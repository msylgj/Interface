local addon, ns = ...
local cfg = ns.cfg

local cbgap = 5
local shieldSize = 14
local backdrop = {
	bgFile = "Interface\\Addons\\m_Nameplates\\media\\backdrop",
	tile = false,	tileSize = 0,
	edgeFile = cfg.nameplates.backdrop_edge, edgeSize = 3,
	insets = {left = 3, right = 3, top = 3, bottom = 3}}

--plate collector
local RNP = CreateFrame("Frame", "PlateCollector", WorldFrame)
RNP:SetAllPoints()
RNP.nameplates = {}

--trash can
RNP.pastebin = CreateFrame("Frame")
RNP.pastebin:Hide()

local RAID_CLASS_COLORS = RAID_CLASS_COLORS
local FACTION_BAR_COLORS = FACTION_BAR_COLORS
	
-- FUNCTIONS
local function CreateBackdrop(obj)
	local frame = CreateFrame("Frame",nil,obj)
	frame:SetFrameLevel(obj:GetFrameLevel()-1)
	frame:SetPoint("TOPLEFT",-backdrop.edgeSize,backdrop.edgeSize)
	frame:SetPoint("BOTTOMRIGHT",backdrop.edgeSize,-backdrop.edgeSize)
	frame:SetBackdrop(backdrop);
	frame:SetBackdropColor(0,0,0,1)
	frame:SetBackdropBorderColor(0,0,0,1)
end

--convert RGB to Hexadecimal color value
local function RGBPercToHex(r, g, b)
	r = r <= 1 and r >= 0 and r or 0
	g = g <= 1 and g >= 0 and g or 0
	b = b <= 1 and b >= 0 and b or 0
	return string.format("%02x%02x%02x", r*255, g*255, b*255)
end

--round color values to fix them
local function FixColor(color)
	color.r,color.g,color.b = floor(color.r*100+.5)/100, floor(color.g*100+.5)/100, floor(color.b*100+.5)/100
end

--get difficulty color func
local function GetLevelColor(self)
	local color = {}
	color.r, color.g, color.b = self.level:GetTextColor()
	FixColor(color)
	return color
end

--get threat color func
local function GetThreatColor(self)
	local color = {}
	color.r, color.g, color.b = self.threat:GetVertexColor()
	FixColor(color)
	return color
end

--get healthbar color func
local function GetHealthbarColor(self)
	if not self.healthbar then return end
	local color = {}
	color.r, color.g, color.b = self.healthbar:GetStatusBarColor()
	FixColor(color)
	return color
end

--get castbar color func
local function GetCastbarColor(self)
	local color = {}
	color.r, color.g, color.b = self.castbar:GetStatusBarColor()
	FixColor(color)
	return color
end

--based on a given color, guess the cass/faction color
local function CalculateClassFactionColor(color)
	for class, _ in pairs(RAID_CLASS_COLORS) do
		if RAID_CLASS_COLORS[class].r == color.r and RAID_CLASS_COLORS[class].g == color.g and RAID_CLASS_COLORS[class].b == color.b then
		return --no color change needed, class color found
		end
	end
	if color.g+color.b == 0 then -- hostile
		--color.r,color.g,color.b = FACTION_BAR_COLORS[2].r, FACTION_BAR_COLORS[2].g, FACTION_BAR_COLORS[2].b
		color.r,color.g,color.b = 0.69, 0.31, 0.31
		return
	elseif color.r+color.b == 0 then -- friendly npc
		--color.r,color.g,color.b = FACTION_BAR_COLORS[6].r, FACTION_BAR_COLORS[6].g, FACTION_BAR_COLORS[6].b
		color.r,color.g,color.b = 0.33, 0.59, 0.33
		return
	elseif color.r+color.g == 2 then -- neutral
		--color.r,color.g,color.b = FACTION_BAR_COLORS[4].r, FACTION_BAR_COLORS[4].g, FACTION_BAR_COLORS[4].b
		color.r,color.g,color.b = 0.71, 0.71, 0.35
		return
	elseif color.r+color.g == 0 then -- friendly player, we don't like 0,0,1 so we change it to a more likable color
		--color.r,color.g,color.b = 0/255, 100/255, 255/255
		color.r,color.g,color.b = 0.31, 0.45, 0.63
		return
	else
		--whatever is left
		return
	end
end

--get hexadecimal color string from color table
local function GetHexColor(color)
	return RGBPercToHex(color.r,color.g,color.b)
end

local function IsTargetNameplate(self)
	return (self:IsShown() and self:GetAlpha() >= 0.99 and UnitExists("target")) or false
end
local function PlateOnUpdate(self, elapsed)
	self.elapsed = self.elapsed + elapsed
	if self.elapsed > 0.15 then 	
		-- setting target attribute
		if IsTargetNameplate(self) then self.isTarget = true else self.isTarget = false end		
		-- mouseover highlight
		if self.highlight:IsShown() then
			self._name:SetTextColor(1, 1, 0)
		else
			self._name:SetTextColor(1, 1, 1)
			--local color = GetHealthbarColor(self)
			--self._name:SetTextColor(color.r,color.g,color.b)
		end

		if self.isTarget then 
			self.healthbar.tarT:SetVertexColor(1, .7, .2, 1)
			self.healthbar.tarB:SetVertexColor(1, .7, .2, 1)
			self.healthbar.tarL:SetVertexColor(1, .7, .2, 1)
			self.healthbar.tarR:SetVertexColor(1, .7, .2, 1)
		else 
			self.healthbar.tarT:SetVertexColor(0, 0, 0, 0)
			self.healthbar.tarB:SetVertexColor(0, 0, 0, 0)
			self.healthbar.tarL:SetVertexColor(0, 0, 0, 0)
			self.healthbar.tarR:SetVertexColor(0, 0, 0, 0)
		end
		self.elapsed = 0 --reset
	end
end

local function round(num, idp)
	return tonumber(format("%." .. (idp or 0) .. "f", num))
end

local function formatNumber(number)
	if number >= 1e6 then
		return round(number/1e6, 1).."|cffEEEE00m|r"
	elseif number >= 1e3 then
		return round(number/1e3, 1).."|cffEEEE00k|r"
	else
		return number
	end
end

local function updateHealth(healthbar, maxHp)
	local newPlate = healthbar:GetParent()--:GetParent()
	local plate = newPlate.blizzPlate
	--print(plate:GetName())
	--if self.healthbar then
	local _, maxhealth = plate.healthbar:GetMinMaxValues()
	if maxHp == "x" then
		maxHp = maxhealth
	end
	local currentValue = plate.healthbar:GetValue()
	local p = (currentValue/maxhealth)*100
	plate.hp:SetTextColor(r, g, b)
		
	if p < 100 and currentValue > 1 then
		--self.hp:SetFormattedText("|cffFFFFFF%s|r|cffffffff - |r%.1f%%", formatNumber(currentValue), p)
		plate.hp:SetText(formatNumber(currentValue))
		plate.pct:SetText(format("%.1f %s",p,"%"))
	else
		plate.hp:SetText("")
		plate.pct:SetText("")
	end

	if(p <= 35 and p >= 25) then
		plate.hp:SetTextColor(253/255, 238/255, 80/255)
		plate.pct:SetTextColor(253/255, 238/255, 80/255)
	elseif(p < 25 and p >= 20) then
		plate.hp:SetTextColor(250/255, 130/255, 0/255)
		plate.pct:SetTextColor(250/255, 130/255, 0/255)
	elseif(p < 20) then
		plate.hp:SetTextColor(200/255, 20/255, 40/255)
		plate.pct:SetTextColor(200/255, 20/255, 40/255)
	else
		plate.hp:SetTextColor(1,1,1)
		plate.pct:SetTextColor(1,1,1)
	end	
	--end
end
--
--

--NamePlateOnShow func
local function NamePlateOnShow(self)
	--healthbar
	self.healthbar:ClearAllPoints()
	self.healthbar:SetPoint("TOP", self.newPlate)
	self.healthbar:SetPoint("LEFT", self.newPlate)
	self.healthbar:SetPoint("RIGHT", self.newPlate)
	self.healthbar:SetHeight(cfg.nameplates.hpHeight)
	--threat glow
	self.threat:ClearAllPoints()
	self.threat:SetPoint("TOPLEFT",self.healthbar,-2,2)
	self.threat:SetPoint("BOTTOMRIGHT",self.healthbar,2,-2)
	-- highlight
	self.highlight:ClearAllPoints()
	self.highlight:SetAllPoints(self.healthbar)
	--set name and level
	local hexColor = GetHexColor(GetLevelColor(self)) or "ffffff"
	local name = self.name:GetText() or "Unknown"
	local level = self.level:GetText() or "-1"
	if self.boss:IsShown() then
		level = "??"
		hexColor = "ff6600"
	elseif self.dragon:IsShown() then
		level = level.."+"
	end
	local color = GetHealthbarColor(self)
	CalculateClassFactionColor(color)
	if self.healthbar._texture then
		self.healthbar._texture:SetVertexColor(color.r,color.g,color.b)
	end
	self._name:SetTextColor(color.r,color.g,color.b)
	self._name:SetText("|cff"..hexColor..""..level.."|r "..name)
	
end

--NamePlateCastbarOnShow func
local function NamePlateCastbarOnShow(self)
	local newPlate = self:GetParent()
	--castbar
	self:ClearAllPoints()
	self:SetPoint("BOTTOM", newPlate)
	self:SetPoint("LEFT", newPlate)
	self:SetPoint("RIGHT", newPlate)
	self:SetHeight(cfg.nameplates.castbar.height)
	--castbar icon
	self.icon:ClearAllPoints()
	self.icon:SetPoint("RIGHT", newPlate, "LEFT", -cbgap, 0)
	if self.shield:IsShown() then
		--castbar shield
		self.shield:ClearAllPoints()
		self.shield:SetPoint("BOTTOM",self.icon,0,-shieldSize/2+2)
		self.shield:SetSize(shieldSize,shieldSize)
		--self.iconBorder:SetDesaturated(1)
		self.iconBorder:SetVertexColor(0.8,0,0)
		self:SetStatusBarColor(0.8,0.8,0.8)
	else
		--self.iconBorder:SetDesaturated(0)
		self.iconBorder:SetVertexColor(0,0,0)
	end
end

--NamePlateInit func
local function NamePlateInit(plate)
	--the gathering
	plate.barFrame, plate.nameFrame = plate:GetChildren()
	plate.healthbar, plate.castbar = plate.barFrame:GetChildren()
	plate.threat, plate.border, plate.highlight, plate.level, plate.boss, plate.raid, plate.dragon = plate.barFrame:GetRegions()
	plate.name = plate.nameFrame:GetRegions()
	plate.healthbar.texture = plate.healthbar:GetRegions()
	plate.castbar.texture, plate.castbar.border, plate.castbar.shield, plate.castbar.icon, plate.castbar.name, plate.castbar.nameShadow = plate.castbar:GetRegions()
	plate.castbar.icon.layer, plate.castbar.icon.sublevel = plate.castbar.icon:GetDrawLayer()
	plate.rnp_checked = true
	--create a new plate
	RNP.nameplates[plate] = CreateFrame("Frame", "New"..plate:GetName(), RNP)
	local newPlate = RNP.nameplates[plate]
	newPlate:SetSize(cfg.nameplates.hpWidth,cfg.nameplates.hpHeight+cfg.nameplates.castbar.height+cbgap)
	--keep the frame reference for later
	newPlate.blizzPlate = plate
	plate.newPlate = newPlate
	--barFrame
	--do not touch it
	--nameFrame
	plate.nameFrame:SetParent(RNP.pastebin)
	plate.nameFrame:Hide()
	--healthbar
	plate.healthbar:SetParent(newPlate)
	--plate.healthbar:SetStatusBarTexture(cfg.nameplates.statusbar)
	plate.healthbar.texture = plate.healthbar:GetStatusBarTexture()
	plate.healthbar.texture:SetTexture(nil)
	--new fake healthbar
	plate.healthbar._texture = plate.healthbar:CreateTexture(nil, "BACKGROUND",nil,-6)
	plate.healthbar._texture:SetAllPoints(plate.healthbar.texture)
	plate.healthbar._texture:SetTexture(cfg.nameplates.statusbar) --texture file path
	plate.healthbar._texture:SetVertexColor(0,1,1)
	--plate.healthbar:SetBackdropColor(0, 0, 0, 1)
	--[[
	--healthbar bg test
	plate.healthbar.bg = plate.healthbar:CreateTexture(nil, "BACKGROUND",nil,-6)
	plate.healthbar.bg:SetAllPoints(plate.healthbar)
	plate.healthbar.bg:SetTexture(1,1,1)
	plate.healthbar.bg:SetVertexColor(1,0,0,0.2)
	]]--
	CreateBackdrop(plate.healthbar)
	--threat
	plate.threat:SetParent(plate.healthbar)
	plate.threat:SetTexture("Interface\\AddOns\\rNamePlates2\\media\\threat_glow")
	plate.threat:SetTexCoord(0,1,0,1)
	--level
	plate.level:SetParent(RNP.pastebin) --trash the level string, it will come back OnShow and OnDrunk otherwise ;)
	plate.level:Hide()
	--hide textures
	plate.border:SetTexture(nil)
	plate.highlight:SetTexture(nil)
	plate.boss:SetTexture(nil)
	plate.dragon:SetTexture(nil)
	--highlight
	plate.highlight:SetTexture(cfg.nameplates.statusbar)
		--plate.highlight:SetVertexColor(0.25, 0.25, 0.25, 0.8)
		--plate.highlight:ClearAllPoints()
		--plate.highlight:SetAllPoints(plate.healthbar)
	--castbar
	plate.castbar:SetParent(newPlate)
	plate.castbar:SetStatusBarTexture(cfg.nameplates.statusbar)
	--plate.castbar:SetBackdropColor(0, 0, 0, 1)
	CreateBackdrop(plate.castbar)
	--castbar border
	plate.castbar.border:SetTexture(nil)
	--castbar icon
	plate.castbar.icon:SetTexCoord(0.1,0.9,0.1,0.9)
	plate.castbar.icon:SetSize(cfg.nameplates.castbar.icon_size,cfg.nameplates.castbar.icon_size)
	--castbar spellname
	plate.castbar.name:ClearAllPoints()
	plate.castbar.name:SetPoint("BOTTOM",plate.castbar,0,-5)
	plate.castbar.name:SetPoint("LEFT",plate.castbar,5,0)
	plate.castbar.name:SetPoint("RIGHT",plate.castbar,-5,0)
	plate.castbar.name:SetFont(cfg.nameplates.font, cfg.nameplates.fontsize, cfg.nameplates.fontflag)
	plate.castbar.name:SetShadowColor(0,0,0,0)
	--castbar shield
	plate.castbar.shield:SetTexture("Interface\\AddOns\\m_Nameplates\\media\\castbar_shield")
	plate.castbar.shield:SetTexCoord(0,1,0,1)
	plate.castbar.shield:SetDrawLayer(plate.castbar.icon.layer, plate.castbar.icon.sublevel+2)
	--new castbar icon border
	plate.castbar.iconBorder = plate.castbar:CreateTexture(nil, plate.castbar.icon.layer, nil, plate.castbar.icon.sublevel+1)
	plate.castbar.iconBorder:SetTexture(cfg.nameplates.icontex)
	plate.castbar.iconBorder:SetPoint("TOPLEFT",plate.castbar.icon,"TOPLEFT",-1.5,1.5)
	plate.castbar.iconBorder:SetPoint("BOTTOMRIGHT",plate.castbar.icon,"BOTTOMRIGHT",1.5,-1.5)
	plate.castbar.nameShadow:SetTexture(nil)
	--new name
	newPlate.name = newPlate:CreateFontString(nil,"BORDER")
	newPlate.name:SetPoint("BOTTOM", newPlate, "TOP",0,2)
	newPlate.name:SetPoint("LEFT", newPlate,-2,0)
	newPlate.name:SetPoint("RIGHT", newPlate,2,0)
	newPlate.name:SetFont(cfg.nameplates.font, cfg.nameplates.fontsize, cfg.nameplates.fontflag)
	plate._name = newPlate.name
	--raid icon
	plate.raid:SetParent(newPlate)
	plate.raid:ClearAllPoints()
	plate.raid:SetSize(cfg.nameplates.raidIconSize,cfg.nameplates.raidIconSize)
	plate.raid:SetPoint("BOTTOM",newPlate.name,"TOP",0,0)
	--target border
	healthBar = plate.healthbar
	healthBar.tar = CreateFrame("Frame", nil, healthBar)
	healthBar.tar:SetFrameLevel(plate:GetFrameLevel()+2)
	
	healthBar.tarT = healthBar.tar:CreateTexture(nil, "PARENT")
	healthBar.tarT:SetTexture(1,1,1,1)
	healthBar.tarT:SetPoint("TOPLEFT", healthBar, "TOPLEFT",0,1)
	healthBar.tarT:SetPoint("TOPRIGHT", healthBar, "TOPRIGHT",0,1)
	healthBar.tarT:SetHeight(1)
	healthBar.tarT:SetVertexColor(1,1,1,1)
	
	healthBar.tarB = healthBar.tar:CreateTexture(nil, "PARENT")
	healthBar.tarB:SetTexture(1,1,1,1)
	healthBar.tarB:SetPoint("BOTTOMLEFT", healthBar, "BOTTOMLEFT",0,-1)
	healthBar.tarB:SetPoint("BOTTOMRIGHT", healthBar, "BOTTOMRIGHT",0,-1)
	healthBar.tarB:SetHeight(1)
	healthBar.tarB:SetVertexColor(1,1,1,1)
	
	healthBar.tarL = healthBar.tar:CreateTexture(nil, "PARENT")
	healthBar.tarL:SetTexture(1,1,1,1)
	healthBar.tarL:SetPoint("TOPLEFT", healthBar, "TOPLEFT",-1,1)
	healthBar.tarL:SetPoint("BOTTOMLEFT", healthBar, "BOTTOMLEFT",-1,-1)
	healthBar.tarL:SetWidth(1)
	healthBar.tarL:SetVertexColor(1,1,1,1)
	
	healthBar.tarR = healthBar.tar:CreateTexture(nil, "PARENT")
	healthBar.tarR:SetTexture(1,1,1,1)
	healthBar.tarR:SetPoint("TOPRIGHT", healthBar, "TOPRIGHT",1,1)
	healthBar.tarR:SetPoint("BOTTOMRIGHT", healthBar, "BOTTOMRIGHT",1,-1)
	healthBar.tarR:SetWidth(1)
	healthBar.tarR:SetVertexColor(1,1,1,1)
	plate.isTarget = false
	
	--health text
	plate.pct = plate.healthbar:CreateFontString(nil, "OVERLAY")	
	plate.pct:SetFont(cfg.nameplates.font, cfg.nameplates.fontsize-1, cfg.nameplates.fontflag)
	plate.pct:SetPoint("CENTER", plate.healthbar, "CENTER", 0, 0)
	plate.hp = plate:CreateFontString(nil, 'ARTWORK')
	plate.hp:SetPoint("LEFT", plate.healthbar, "RIGHT", 5, 0)
	plate.hp:SetFont(cfg.nameplates.font, cfg.nameplates.fontsize, cfg.nameplates.fontflag)
	plate.hp:SetShadowOffset(0, 0)
	--plate.pct:SetText("1%")
	--plate.hp:SetText("100")
	
	--hooks
	plate.healthbar:SetScript("OnValueChanged", updateHealth)
	plate:SetScript("OnUpdate", PlateOnUpdate)
	plate.elapsed = 1

	plate:HookScript("OnShow", NamePlateOnShow)
	plate.castbar:HookScript("OnShow", NamePlateCastbarOnShow)
	NamePlateOnShow(plate)
end

--IsNamePlateFrame func
local function IsNamePlateFrame(obj)
	local name = obj:GetName()
	if name and name:find("NamePlate") then
		return true
	end
	obj.rnp_checked = true
	return false
end

--SearchForNamePlates func
local function SearchForNamePlates(self)
	for _, obj in pairs({self:GetChildren()}) do
		if not obj.rnp_checked and IsNamePlateFrame(obj) then
		NamePlateInit(obj)
		end
	end
end

--RepositionAllNamePlates func
local function RepositionAllNamePlates()
	RNP:Hide()
	for blizzPlate, newPlate in pairs(RNP.nameplates) do
		newPlate:Hide()
		if blizzPlate:IsShown() then
		newPlate:SetPoint("CENTER", WorldFrame, "BOTTOMLEFT", blizzPlate:GetCenter())
		newPlate:SetAlpha(blizzPlate:GetAlpha())
		newPlate:Show()
		end
	end
	RNP:Show()
end

--OnUpdate func
RNP.lastUpdate = 0
RNP.updateInterval = 1.0
local function OnUpdate(self,elapsed)
	RNP.lastUpdate = RNP.lastUpdate + elapsed
	RepositionAllNamePlates()
	if RNP.lastUpdate > RNP.updateInterval then
		SearchForNamePlates(self)
		RNP.lastUpdate = 0
	end
end

-- INIT
WorldFrame:HookScript("OnUpdate", OnUpdate)

--fixing the nameplate threat bloat
SetCVar("bloatnameplates",0)
SetCVar("bloatthreat",0)

-->Register initial login event 
local updateFrame = CreateFrame("Frame")
updateFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
updateFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
local InCombat = false
updateFrame:SetScript("OnEvent", function(self, event, ...)
	if (event == "PLAYER_REGEN_DISABLED") then 
		InCombat = true
		SetCVar("nameplateShowEnemies", 1)
	elseif (event == "PLAYER_REGEN_ENABLED") then
		InCombat = false
		SetCVar("nameplateShowEnemies", 0) 
		--collectgarbage()
	end
end)