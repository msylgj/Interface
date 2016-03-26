
-- // rNamePlates
-- // zork - 2014

-----------------------------
-- VARIABLES
-----------------------------

local an, at = ...
local plates, namePlateIndex, _G, string, WorldFrame, unpack, math, wipe, mod = {}, nil, _G, string, WorldFrame, unpack, math, wipe, mod

local cfg = {}
local Media = "Interface\\AddOns\\rNamePlates\\Media\\"

cfg.font                    = 'Fonts\\ARKai_T.ttf'
cfg.fontsize                = 10
cfg.fontflag                = "THINOUTLINE"
cfg.notFocusedPlateAlpha    = 0.5
cfg.auras                   = true
cfg.threat                  = true
cfg.combat                  = true
cfg.tank_mode				= false
cfg.glowTex                 = Media.."glowTex"
cfg.raidicon                = Media.."raidicons"
cfg.texture                 = Media.."texture"
cfg.threat_glow             = Media.."threat_glow"

local backdrop = {
	bgFile = [=[Interface\ChatFrame\ChatFrameBackground]=],
	edgeFile = cfg.glowTex, edgeSize = 2,
	insets = {left = 2, right = 2, top = 2, bottom = 2}
}

local function CreateBackdrop(obj)
	local frame = CreateFrame("Frame",nil,obj)
	frame:SetFrameLevel(obj:GetFrameLevel()-1 > 0 and obj:GetFrameLevel()-1 or 0)
	frame:SetPoint("TOPLEFT", -2, 2)
	frame:SetPoint("BOTTOMRIGHT", 2, -2)
	frame:SetBackdrop(backdrop);
	frame:SetBackdropColor(0,0,0)
	frame:SetBackdropBorderColor(0,0,0,1)
end

-----------------------------
-- AURAS
-----------------------------

local NUM_MAX_AURAS = 40

local unitDB                = {}  --unit table by guid
local spellDB                     --aura table by spellid

local AuraModule = CreateFrame("Frame")
AuraModule.playerGUID       = nil
AuraModule.petGUID          = nil
AuraModule.updateTarget     = false
AuraModule.updateMouseover  = false

function AuraModule:PLAYER_TARGET_CHANGED(...)
	if not spellDB then return end
	if spellDB.disabled then return end
	if UnitGUID("target") and UnitExists("target") and not UnitIsUnit("target","player") and not UnitIsDead("target") then
		self.updateTarget = true
	else
		self.updateTarget = false
	end
end

function AuraModule:UPDATE_MOUSEOVER_UNIT(...)
	if not spellDB then return end
	if spellDB.disabled then return end
	if UnitGUID("mouseover") and UnitExists("mouseover") and not UnitIsUnit("mouseover","player") and not UnitIsDead("mouseover") then
		self.updateMouseover = true
	else
		self.updateMouseover = false
	end
end

function AuraModule:UNIT_PET(...)
	if UnitGUID("pet") and UnitExists("pet") then
		self.petGUID = UnitGUID("pet")
	end
end

function AuraModule:PLAYER_LOGIN(...)
	if UnitGUID("player") then
		self.playerGUID = UnitGUID("player")
	end
	if UnitGUID("pet") and UnitExists("pet") then
		self.petGUID = UnitGUID("pet")
	end
end

AuraModule.CLEU_FILTER = {
	["SPELL_AURA_APPLIED"]      = true, --UpdateAura
	["SPELL_AURA_REFRESH"]      = true, --UpdateAura
	["SPELL_AURA_APPLIED_DOSE"] = true, --UpdateAura
	["SPELL_AURA_REMOVED_DOSE"] = true, --UpdateAura
	["SPELL_AURA_STOLEN"]       = true, --RemoveAura
	["SPELL_AURA_REMOVED"]      = true, --RemoveAura
	["SPELL_AURA_BROKEN"]       = true, --RemoveAura
	["SPELL_AURA_BROKEN_SPELL"] = true, --RemoveAura
}

function AuraModule:COMBAT_LOG_EVENT_UNFILTERED(...)
	if not spellDB then return end
	if spellDB.disabled then return end
	local _, event, _, srcGUID, _, _, _, destGUID, _, _, _, spellID, spellName, _, _, stackCount = ...
	if self.CLEU_FILTER[event] then
		if not unitDB[destGUID] then return end --no corresponding nameplate found
		if not spellDB[spellID] then return end --no spell info found
		local unitCaster = nil
		if srcGUID == self.playerGUID then
			unitCaster = "player"
		elseif srcGUID == self.petGUID then
			unitCaster = "pet"
		else
			return
		end
		if event == "SPELL_AURA_APPLIED" or event == "SPELL_AURA_REFRESH" or event == "SPELL_AURA_APPLIED_DOSE" or event == "SPELL_AURA_REMOVED_DOSE" then
			unitDB[destGUID]:UpdateAura(GetTime(),nil,unitCaster,spellID,stackCount)
		else
			unitDB[destGUID]:RemoveAura(spellID)
		end
	end
end

function AuraModule:UNIT_AURA(unit)
	if not spellDB then return end
	if spellDB.disabled then return end
	local guid = UnitGUID(unit)
	if guid and unitDB[guid] and not UnitIsUnit(unit,"player") then
		--print("ScanAuras", "UNIT_AURA", unitDB[guid].newPlate.id)
		unitDB[guid]:ScanAuras(unit,"HELPFUL")
		unitDB[guid]:ScanAuras(unit,"HARMFUL")
	end
end

function AuraModule:ADDON_LOADED(name,...)
	if name == an then
		self:UnregisterEvent("ADDON_LOADED")
		if not rNP_SPELL_DB then
			rNP_SPELL_DB = {}
		end
		spellDB = rNP_SPELL_DB --variable is bound by reference. there is no way this can fuck up. like no way.
		if spellDB.disabled then
			print(an,"AuraModule","spell db is currently disabled on this character")
		end
	end
end

AuraModule:RegisterEvent("ADDON_LOADED")
AuraModule:RegisterEvent("PLAYER_LOGIN")
--ok unit_aura is important. otherwise new auras will only be found if they are preset on frame init.
--one cannot add new spells to the DB via CLEU. there is missing data (duration).
AuraModule:RegisterUnitEvent("UNIT_AURA","target","mouseover")
AuraModule:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
AuraModule:RegisterUnitEvent("UNIT_PET", "player")
AuraModule:RegisterEvent("PLAYER_TARGET_CHANGED")
AuraModule:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
AuraModule:SetScript("OnEvent", function(self, event, ...) self[event](self, ...) end)

-----------------------------
-- FUNCTIONS
-----------------------------

local trash = CreateFrame("Frame")
trash:Hide()

local function GetHexColorFromRGB(r, g, b)
	return string.format("%02x%02x%02x", r*255, g*255, b*255)
end

local function GetFormattedTime(time)
	if time <= 0 then
		return ""
	elseif time < 2 then
		return (math.floor(time*10)/10)
	elseif time < 60 then
		return string.format("%d", mod(time, 60))
	elseif time < 3600 then
		return string.format("%dm", math.floor(mod(time, 3600) / 60 + 1))
	else
		return string.format("%dh", math.floor(time / 3600 + 1))
	end
end

local function RoundNumber(n)
	return (math.floor(n*100+0.5)/100)
end

local function NamePlateSetup(blizzPlate)

	blizzPlate.borderTexture:SetTexture(nil)
	blizzPlate.bossIconTexture:SetTexture(nil)
	blizzPlate.eliteDragonTexture:SetTexture(nil)
	blizzPlate.highlightTexture:SetTexture(nil)

	if cfg.threat then
		blizzPlate.threatTexture:ClearAllPoints()
		blizzPlate.threatTexture:SetPoint("TOPLEFT",blizzPlate.newPlate.healthBar,-2,2)
		blizzPlate.threatTexture:SetPoint("BOTTOMRIGHT",blizzPlate.newPlate.healthBar,2,-2)
	end

	local name = blizzPlate.nameString:GetText() or "Unknown"
	local level = blizzPlate.levelString:GetText() or "-1"
	local hexColor = GetHexColorFromRGB(blizzPlate.levelString:GetTextColor()) or "ffffff"

	if blizzPlate.bossIconTexture:IsShown() then
		level = "??"
		hexColor = "ff6600"
	elseif blizzPlate.eliteDragonTexture:IsShown() then
		level = level.."+"
	end
	blizzPlate.newPlate.healthBar.name:SetText("|cff"..hexColor..""..level.."|r "..name)
end

local function NamePlateOnInit(blizzPlate)

	blizzPlate.barFrame, blizzPlate.nameFrame = blizzPlate:GetChildren()
	blizzPlate.healthBar, blizzPlate.castBar = blizzPlate.barFrame:GetChildren()
	blizzPlate.threatTexture, blizzPlate.borderTexture, blizzPlate.highlightTexture, blizzPlate.levelString, blizzPlate.bossIconTexture, blizzPlate.raidIconTexture, blizzPlate.eliteDragonTexture = blizzPlate.barFrame:GetRegions()
	blizzPlate.nameString = blizzPlate.nameFrame:GetRegions()
	blizzPlate.healthBar.statusbarTexture = blizzPlate.healthBar:GetRegions()
	blizzPlate.castBar.statusbarTexture, blizzPlate.castBar.borderTexture, blizzPlate.castBar.shieldTexture, blizzPlate.castBar.spellIconTexture, blizzPlate.castBar.nameString, blizzPlate.castBar.nameShadow = blizzPlate.castBar:GetRegions()

	blizzPlate.healthBar.__owner = blizzPlate
	blizzPlate.castBar.__owner = blizzPlate

	blizzPlate.healthBar:SetParent(trash)
	blizzPlate.castBar:SetParent(blizzPlate)

	blizzPlate.castBar.borderTexture:SetTexture(nil)
	blizzPlate.borderTexture:SetTexture(nil)
	blizzPlate.bossIconTexture:SetTexture(nil)
	blizzPlate.eliteDragonTexture:SetTexture(nil)

end

local function SkinHealthBar(blizzPlate)

	local bar = CreateFrame("StatusBar",nil,blizzPlate.newPlate)
	bar:SetSize(103,6)
	bar:SetStatusBarTexture(cfg.texture)
	bar:SetScale(1)
	bar:SetPoint("CENTER",0,-10)
	bar.bg = bar:CreateTexture(nil, 'BORDER')
	bar.bg:SetAllPoints()
	bar.bg:SetTexture(cfg.texture)
	bar.bg:SetVertexColor(1, 1, 1, 0.25)

	CreateBackdrop(bar)

	local hlf = CreateFrame("Frame",nil,bar)
	hlf:SetAllPoints()
	bar.hlf = hlf

	local name = bar.hlf:CreateFontString(nil, "BORDER")
	name:SetFont(cfg.font, cfg.fontsize, cfg.fontflag)
	name:SetPoint("BOTTOMLEFT", bar, "TOPLEFT",0,2)
	name:SetPoint("LEFT")
	name:SetPoint("RIGHT")
	name:SetJustifyH('LEFT')
	name:SetText("Ich bin ein Berliner!")
	bar.name = name
	
	local hpvalue = bar.hlf:CreateFontString(nil, "OVERLAY")
	hpvalue:SetFont(cfg.font, cfg.fontsize, cfg.fontflag)
	hpvalue:SetPoint("RIGHT", bar, "BOTTOMRIGHT", 0, -3)
	hpvalue:SetTextColor(1, 1, 1)
	bar.hpvalue = hpvalue
	
	blizzPlate.raidIconTexture:SetParent(bar)
	blizzPlate.raidIconTexture:SetTexture(cfg.raidicon)
	blizzPlate.raidIconTexture:SetSize(15,15)
	blizzPlate.raidIconTexture:ClearAllPoints()
	blizzPlate.raidIconTexture:SetPoint("RIGHT",bar,"LEFT")

	if cfg.threat then
		blizzPlate.threatTexture:SetParent(bar)
		blizzPlate.threatTexture:SetTexture(cfg.threat_glow)
		blizzPlate.threatTexture:SetTexCoord(0,1,0,1)
	else
		blizzPlate.threatTexture:SetTexture(nil)
	end

	blizzPlate.newPlate.healthBar = bar

end

local function SkinCastBar(blizzPlate)

	local bar = CreateFrame("StatusBar",nil,blizzPlate.newPlate)
	bar:SetSize(103,4)
	bar:SetStatusBarTexture(cfg.texture)
	bar:SetScale(1)
	bar:SetPoint("TOPLEFT",blizzPlate.newPlate.healthBar,"BOTTOMLEFT",0,-5)
	bar.bg = bar:CreateTexture(nil, 'BORDER')
	bar.bg:SetAllPoints()
	bar.bg:SetTexture(cfg.texture)
	bar.bg:SetVertexColor(1, 1, 1, 0.25)

	CreateBackdrop(bar)

	local hlf = CreateFrame("Frame",nil,bar)
	hlf:SetAllPoints()
	bar.hlf = hlf

	local name = bar.hlf:CreateFontString(nil, "BORDER")
	name:SetFont(cfg.font, cfg.fontsize, cfg.fontflag)
	name:SetPoint("BOTTOM",bar,0,-6)
	name:SetPoint("LEFT",5,0)
	name:SetPoint("RIGHT",-5,0)
	bar.nameString = name
	
	bar.iconholder = CreateFrame("Frame", nil, bar)
	bar.iconholder:SetPoint("BOTTOMLEFT", bar, "BOTTOMRIGHT", 3, 0)
	bar.iconholder:SetSize(15, 15)
	bar.iconholder:SetFrameLevel(bar:GetFrameLevel()+1)
	local icon = bar:CreateTexture(nil,"OVERLAY", bar.iconholder)
	icon:SetTexCoord(0.08,0.92,0.08,0.92)
	icon:SetPoint("RIGHT",bar,"LEFT",-58,22)
	icon:SetSize(60,60)
	bar.spellIconTexture = icon
	bar.spellIconTexture:SetAllPoints(bar.iconholder)
	bar.spellIconTexture:SetTexCoord(.07, .93, .07, .93)
	bar.shieldTexture = blizzPlate.castBar.shieldTexture
	CreateBackdrop(bar.iconholder)
	
	if not blizzPlate.castBar:IsShown() then
		bar:Hide()
	end

	blizzPlate.newPlate.castBar = bar

end

local function NamePlatePosition(blizzPlate)
	local sizer = CreateFrame("Frame", nil, blizzPlate.newPlate)
	sizer:SetPoint("BOTTOMLEFT", WorldFrame)
	sizer:SetPoint("TOPRIGHT", blizzPlate, "CENTER")
	sizer:SetScript("OnSizeChanged", function(self, x, y)
		if blizzPlate:IsShown() then
			blizzPlate.newPlate:Hide() -- Important, never move the frame while it"s visible
			blizzPlate.newPlate:SetPoint("CENTER", WorldFrame, "BOTTOMLEFT", x, y) -- Immediately reposition frame
			blizzPlate.newPlate:Show()
		end
	end)
end

local function NamePlateSetGUID(blizzPlate,guid)
	if blizzPlate.guid and guid ~= blizzPlate.guid then
		unitDB[blizzPlate.guid] = nil
		wipe(blizzPlate.auras)
		blizzPlate:UpdateAllAuras() --hide visible buttons
		blizzPlate.guid = guid
		unitDB[guid] = blizzPlate
	elseif not blizzPlate.guid then
		blizzPlate.guid = guid
		unitDB[guid] = blizzPlate
	end
end

local function NamePlateOnShow(blizzPlate)
	NamePlateSetup(blizzPlate)
	blizzPlate.newPlate:Show()
end

local function NamePlateOnHide(blizzPlate)
	blizzPlate.newPlate.castBar:Hide()
	blizzPlate.newPlate:Hide()
	wipe(blizzPlate.auras)
	blizzPlate:UpdateAllAuras() --hide visible buttons
	if blizzPlate.guid then
		unitDB[blizzPlate.guid] = nil
		blizzPlate.guid = nil
	end
end

local function NamePlateCastBarOnHide(castBar)
	local blizzPlate = castBar.__owner
	local castBar2 = blizzPlate.newPlate.castBar
	castBar2:Hide()
end

local function NamePlateCastBarUpdate(castBar, value)
	local blizzPlate = castBar.__owner
	local castBar2 = blizzPlate.newPlate.castBar
	if castBar:IsShown() then
		castBar2:Show()
	else
		castBar2:Hide()
		return
	end
	if value == 0 then
		castBar2:Hide()
		return    
	end
	castBar2.spellIconTexture:SetTexture(castBar.spellIconTexture:GetTexture())
	castBar2.nameString:SetText(castBar.nameString:GetText())
	castBar2:SetMinMaxValues(castBar:GetMinMaxValues())
	castBar2:SetValue(castBar:GetValue())
	if castBar.shieldTexture:IsShown() then
		castBar2:SetStatusBarColor(1, .9, .4)
	else
		castBar2:SetStatusBarColor(0, 0.7, 1)
	end
end

local function NamePlateHealthBarUpdate(healthBar)
	local blizzPlate = healthBar.__owner
	local healthBar2 = blizzPlate.newPlate.healthBar
	healthBar2:SetMinMaxValues(healthBar:GetMinMaxValues())
	healthBar2:SetValue(healthBar:GetValue())
	healthBar2.hpvalue:SetText(string.format("%d%%", math.floor((healthBar:GetValue() / (select(2,healthBar:GetMinMaxValues()))) * 100)))
end

local RAID_CLASS_COLORS = RAID_CLASS_COLORS
local FACTION_BAR_COLORS = FACTION_BAR_COLORS

local function NamePlateHealthBarColor(blizzPlate)
	if cfg.tank_mode then
		if blizzPlate.threatTexture:IsShown() then
			local r,g,b = blizzPlate.threatTexture:GetVertexColor()
			if g+b == 0 then
				blizzPlate.newPlate.healthBar:SetStatusBarColor(0,1,0)--tank mode
			else
				blizzPlate.newPlate.healthBar:SetStatusBarColor(r,g,b)
			end
			return
		end
	end
	local r,g,b = blizzPlate.healthBar:GetStatusBarColor()
	if g+b == 0 then -- hostile
		r,g,b = FACTION_BAR_COLORS[2].r, FACTION_BAR_COLORS[2].g, FACTION_BAR_COLORS[2].b
	elseif r+b == 0 then -- friendly npc
		r,g,b = FACTION_BAR_COLORS[6].r, FACTION_BAR_COLORS[6].g, FACTION_BAR_COLORS[6].b
	elseif r+g > 1.95 then -- neutral
		r,g,b = FACTION_BAR_COLORS[4].r, FACTION_BAR_COLORS[4].g, FACTION_BAR_COLORS[4].b
	elseif r+g == 0 then -- friendly player, we don't like 0,0,1 so we change it to a more likable color
		r,g,b = 0/255, 100/255, 255/255
	end
	blizzPlate.newPlate.healthBar:SetStatusBarColor(r,g,b)
end

local function CreateNewPlate(blizzPlate)
	blizzPlate.newPlate = CreateFrame("Frame", nil, WorldFrame)
	blizzPlate.newPlate.id = namePlateIndex
	blizzPlate.newPlate:SetSize(36,36)
	plates[blizzPlate] = blizzPlate.newPlate
end

local function CreateNamePlateAuraFunctions(blizzPlate)
	blizzPlate.auras = {}
	blizzPlate.auraButtons = {}
	function blizzPlate:CreateAuraHeader()
		local auraHeader = CreateFrame("Frame",nil,self.newPlate)
		auraHeader:SetScale(.35)
		auraHeader:SetPoint("BOTTOMLEFT",self.newPlate.healthBar,"TOPLEFT",0,30)
		auraHeader:SetSize(45,40)
		auraHeader:SetFrameLevel(self.newPlate.healthBar:GetFrameLevel())
		blizzPlate.auraHeader = auraHeader
	end
	function blizzPlate:UpdateAura(startTime,expirationTime,unitCaster,spellID,stackCount)
		if not spellDB then return end
		if not spellDB[spellID] then return end
		if spellDB[spellID].blacklisted then return end
		if not expirationTime then
			expirationTime = startTime+spellDB[spellID].duration
		elseif not startTime then
			startTime = expirationTime-spellDB[spellID].duration
		end
		self.auras[spellID] = {
			spellId         = spellID,
			name            = spellDB[spellID].name,
			texture         = spellDB[spellID].texture,
			startTime       = startTime,
			expirationTime  = expirationTime,
			duration        = spellDB[spellID].duration,
			unitCaster      = unitCaster,
			stackCount      = stackCount,
		}
	end
	function blizzPlate:RemoveAura(spellID)
		if self.auras[spellID] then
			self.auras[spellID] = nil
		end
	end
	function blizzPlate:ScanAuras(unit,filter)
		if not spellDB then return end
		if spellDB.disabled then return end
		for index = 1, NUM_MAX_AURAS do
			local name, _, texture, stackCount, _, duration, expirationTime, unitCaster, _, _, spellID = UnitAura(unit, index, filter)
			if not name then break end
			if spellID and (unitCaster == "player" or unitCaster == "pet") and not spellDB[spellID] then
				spellDB[spellID] = {
					name        = name,
					texture     = texture,
					duration    = duration,
					blacklisted = false,
				}
				--print(an,"AuraModule","adding new spell to db",spellID,name)
			end
			if spellID and (unitCaster == "player" or unitCaster == "pet") then
				self:UpdateAura(nil,expirationTime,unitCaster,spellID,stackCount)
			end
		end
	end
	function blizzPlate:CreateAuraButton(index)
		if not self.auraHeader then
			self:CreateAuraHeader()
		end
		local button = CreateFrame("Frame",nil,self.auraHeader)
		CreateBackdrop(button)
		button:SetSize(self.auraHeader:GetSize())
		button.icon = button:CreateTexture(nil,"BACKGROUND",nil,-7)
		button.icon:SetPoint("TOPLEFT",1,-1)
		button.icon:SetPoint("BOTTOMRIGHT",-1,1)
		button.icon:SetTexCoord(0.1,0.9,0.2,0.8)
		button.cooldown = button:CreateFontString(nil, "BORDER")
		button.cooldown:SetFont(cfg.font, cfg.fontsize/self.auraHeader:GetScale(), cfg.fontflag)
		button.cooldown:SetPoint("TOPLEFT",button)
		button.cooldown:SetJustifyH("LEFT")
		button.stack = button:CreateFontString(nil, "BORDER")
		button.stack:SetFont(cfg.font, cfg.fontsize/self.auraHeader:GetScale(), cfg.fontflag)
		button.stack:SetPoint("BOTTOMRIGHT",button,5,0)
		button.stack:SetJustifyH("RIGHT")
		if index == 1 then
			button:SetPoint("CENTER")
		else
			button:SetPoint("LEFT",self.auraButtons[index-1],"RIGHT",5,0)
		end
		button:Hide()
		self.auraButtons[index] = button
		return button
	end
	function blizzPlate:UpdateAllAuras()
		local buttonIndex = 1
		for index, button in next, self.auraButtons do
			button:Hide()
		end
		for spellID, data in next, self.auras do
			local cooldown = data.expirationTime-GetTime()
			if cooldown < 0 then
				self:RemoveAura(spellID)
			else
				local button = self.auraButtons[buttonIndex] or self:CreateAuraButton(buttonIndex)
				--set texture
				button.icon:SetTexture(data.texture)
				--set cooldown
				button.cooldown:SetText(GetFormattedTime(cooldown))
				--set stackCount
				if data.stackCount and data.stackCount > 1 then
					button.stack:SetText(data.stackCount)
				else
					button.stack:SetText("")
				end
				button:Show()
				buttonIndex = buttonIndex + 1
			end
		end
	end
end



local function SkinPlate(blizzPlate)
	if plates[blizzPlate] then return end
	CreateNewPlate(blizzPlate)
	NamePlateOnInit(blizzPlate)
	SkinHealthBar(blizzPlate)
	SkinCastBar(blizzPlate)
	NamePlateSetup(blizzPlate)
	NamePlatePosition(blizzPlate)
	if not blizzPlate:IsShown() then
		blizzPlate.newPlate:Hide()
	end
	CreateNamePlateAuraFunctions(blizzPlate)
	blizzPlate:HookScript("OnShow", NamePlateOnShow)
	blizzPlate:HookScript("OnHide", NamePlateOnHide)
	blizzPlate.castBar:HookScript("OnShow", NamePlateCastBarUpdate)
	blizzPlate.castBar:HookScript("OnHide", NamePlateCastBarOnHide)
	blizzPlate.castBar:HookScript("OnValueChanged", NamePlateCastBarUpdate)
	blizzPlate.healthBar:HookScript("OnValueChanged", NamePlateHealthBarUpdate)
	NamePlateHealthBarUpdate(blizzPlate.healthBar)
	NamePlateHealthBarColor(blizzPlate)
	namePlateIndex = namePlateIndex+1
end

-----------------------------
-- ONUPDATE
-----------------------------

local countFramesWithFullAlpha = 0
local targetPlate = nil
local delayCounter = 0
local timer = 0.0
local interval = 0.1

WorldFrame:HookScript("OnUpdate", function(self, elapsed)
	timer = timer+elapsed
	countFramesWithFullAlpha = 0
	for blizzPlate, newPlate in next, plates do
		if blizzPlate:IsShown() then
			if blizzPlate:GetAlpha() == 1 then
				newPlate:SetAlpha(1)
			else
				newPlate:SetAlpha(cfg.notFocusedPlateAlpha)
			end
			if cfg.auras and AuraModule.updateTarget and blizzPlate:GetAlpha() == 1 then
				countFramesWithFullAlpha = countFramesWithFullAlpha + 1
				targetPlate = blizzPlate
			end
			if cfg.auras and AuraModule.updateMouseover and blizzPlate.highlightTexture:IsShown() and UnitGUID("mouseover") and UnitExists("mouseover") then
				NamePlateSetGUID(blizzPlate,UnitGUID("mouseover"))
				blizzPlate:ScanAuras("mouseover","HELPFUL")
				blizzPlate:ScanAuras("mouseover","HARMFUL")
				AuraModule.updateMouseover = false
			end
			if timer > interval then
				NamePlateHealthBarColor(blizzPlate)
				if cfg.auras then blizzPlate:UpdateAllAuras() end
			end
		end
	end
	if timer > interval then
		timer = 0
	end
	if cfg.auras and AuraModule.updateTarget and countFramesWithFullAlpha == 1 and UnitGUID("target") and UnitExists("target") and not UnitIsDead("target") then
		--this may look wierd but is actually needed.
		--when the PLAYER_TARGET_CHANGED event fires the nameplate need one cycle to update the alpha, otherwise the old target would be tagged.
		if delayCounter == 1 then
			NamePlateSetGUID(targetPlate,UnitGUID("target"))
			targetPlate:ScanAuras("target","HELPFUL")
			targetPlate:ScanAuras("target","HARMFUL")
			AuraModule.updateTarget = false
			delayCounter = 0
			targetPlate = nil
		else
			delayCounter = delayCounter + 1
		end
	end
	if not namePlateIndex then
		for _, blizzPlate in next, {self:GetChildren()} do
			local name = blizzPlate:GetName()
			if name and string.match(name, "^NamePlate%d+$") then
				namePlateIndex = string.gsub(name,"NamePlate","")
				break
			end
		end
	else
		local blizzPlate = _G["NamePlate"..namePlateIndex]
		if not blizzPlate then return end
		SkinPlate(blizzPlate)
	end
end)

--reset some outdated (yet still active) bloat variables if people run old config.wtf files
--setvar
SetCVar("bloatnameplates",0)
SetCVar("bloatthreat",0)
SetCVar("bloattest",0)

local NamePlates = CreateFrame("Frame", nil, UIParent)
NamePlates:SetScript("OnEvent", function(self, event, ...) self[event](self, ...) end)
if cfg.combat == true then
	NamePlates:RegisterEvent("PLAYER_REGEN_ENABLED")
	NamePlates:RegisterEvent("PLAYER_REGEN_DISABLED")

	function NamePlates:PLAYER_REGEN_ENABLED()
		SetCVar("nameplateShowEnemies", 0)
	end

	function NamePlates:PLAYER_REGEN_DISABLED()
		SetCVar("nameplateShowEnemies", 1)
		AuraModule.updateTarget = true
	end
end
NamePlates:RegisterEvent("PLAYER_ENTERING_WORLD")
function NamePlates:PLAYER_ENTERING_WORLD()
	if cfg.combat == true then
		if InCombatLockdown() then
			SetCVar("nameplateShowEnemies", 1)
			AuraModule.updateTarget = true
		else
			SetCVar("nameplateShowEnemies", 0)
		end
	end
	if cfg.threat == true then
		SetCVar("threatWarning", 3)
	end
end
-----------------------------
-- SLASH_COMMAND_LIST
-----------------------------

local color         = "FFFFAA00"
local shortcut      = "rnp"

local function HandleSlashCmd(cmd)
	if not spellDB then return end
	local spellID = tonumber(strsub(cmd, (strfind(cmd, " ") or 0)+1))
	if (cmd:match"blacklist") then
		print("|c"..color..an.." blacklist|r")
		if spellID and spellDB[spellID] then
			spellDB[spellID].blacklisted = true
			print(spellID,spellDB[spellID].name,"is now blacklisted")
		else
			print("no matching spellid found")
		end
	elseif (cmd:match"whitelist") then
		print("|c"..color..an.." whitelist|r")
		if spellID and spellDB[spellID] then
			spellDB[spellID].blacklisted = false
			print(spellID,spellDB[spellID].name,"is now whitelisted")
		else
			print("no matching spellid found")
		end
	elseif (cmd:match"list") then
		print("|c"..color..an.." list|r")
		print("spellID","|","name","|","blacklisted")
		print("------------------------------------")
		local count = 0
		for key, data in next, spellDB do
			if type(key) == "number" then
				print(key,"|",data.name,"|",data.blacklisted)
				count = count+1
			end
		end
		if count == 0 then
			print("list has no entries")
		end
	elseif (cmd:match"remove") then
		print("|c"..color..an.." remove|r")
		if spellID and spellDB[spellID] then
			print(spellID,spellDB[spellID].name,"removed")
			spellDB[spellID] = nil
		else
			print("no matching spellid found")
		end
	elseif (cmd:match"resetspelldb") then
		print("|c"..color..an.." resetspelldb|r")
		wipe(spellDB)
		print("spell db has been reset")
	elseif (cmd:match"disable") then
		print("|c"..color..an.." disable|r")
		spellDB.disabled = true
		print("spell db has been disabled")
	elseif (cmd:match"enable") then
		print("|c"..color..an.." enable|r")
		spellDB.disabled = false
		print("spell db has been enabled")
	else
		print("|c"..color..an.." command list|r")
		print("|c"..color.."\/"..shortcut.." list|r to list all entries in spellDB")
		print("|c"..color.."\/"..shortcut.." blacklist SPELLID|r to blacklist a spellid in spellDB")
		print("|c"..color.."\/"..shortcut.." whitelist SPELLID|r to whitelist a spellid in spellDB")
		print("|c"..color.."\/"..shortcut.." remove SPELLID|r to remove a spellid from spellDB")
		print("|c"..color.."\/"..shortcut.." disable|r to disable the spellDB for this character")
		print("|c"..color.."\/"..shortcut.." enable|r to enable the spellDB for this character")
		print("|c"..color.."\/"..shortcut.." resetspelldb|r to reset the spellDB for this character")
	end
end

--slash commands
SlashCmdList[shortcut] = HandleSlashCmd
SLASH_rnp1 = "/"..shortcut;