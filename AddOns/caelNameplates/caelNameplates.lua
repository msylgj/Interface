--[[	$Id: caelNameplates.lua 2819 2012-11-30 11:03:27Z sdkyron@gmail.com $	]]

local addonName, ns = ...

local autotoggle = true

local caelNamePlates = CreateFrame("Frame", nil, UIParent)
caelNamePlates:RegisterEvent("PLAYER_ENTERING_WORLD")
caelNamePlates:SetScript("OnEvent", function(self, event, ...) self[event](self, ...) end)
function caelNamePlates:PLAYER_REGEN_ENABLED()
	SetCVar("nameplateShowEnemies", 0)
	SetCVar("nameplateShowFriends", 0)
end

function caelNamePlates:PLAYER_REGEN_DISABLED()
	SetCVar("nameplateShowEnemies", 1)
	SetCVar("nameplateShowFriends", 0)
end

function caelNamePlates:PLAYER_ENTERING_WORLD()
	SetCVar("bloattest", 0) -- 1 might make nameplates larger but it fixes the disappearing ones.
	SetCVar("bloatnameplates", 0) -- 1 makes nameplates larger depending on threat percentage.
	SetCVar("bloatthreat", 0) -- 1 makes nameplates resize depending on threat gain/loss. Only active when a mob has multiple units on its threat table.
	if autotoggle then
		self:RegisterEvent("PLAYER_REGEN_ENABLED")
		self:RegisterEvent("PLAYER_REGEN_DISABLED")
	else
		self:UnregisterEvent("PLAYER_REGEN_ENABLED")
		self:UnregisterEvent("PLAYER_REGEN_DISABLED")
	end
end

local barTexture = [=[Interface\AddOns\caelNameplates\media\normtexc]=]
local iconTexture = [=[Interface\AddOns\caelNameplates\media\buttonnormal]=]
local raidIcons = [=[Interface\AddOns\caelNameplates\media\raidicons]=]
local font = STANDARD_TEXT_FONT
local fontSize = 10
local fontOutline = "THINOUTLINE"
local goodR, goodG, goodB = 0.2, 0.8, 0.2 								-- Good threat color 低仇恨颜色
local transitionR, transitionG, transitionB = 1, 1, 0 					-- Near threat color 高仇恨颜色
local badR, badG, badB = 1, 0, 0										-- Bad threat color OT颜色

local backdrop = {
		bgFile   = 	[=[Interface\ChatFrame\ChatFrameBackground]=],
		edgeFile = 	[=[Interface\AddOns\caelNameplates\media\glowTex3]=], 
		edgeSize = 	2,
		insets   = 	{ left = 2, right = 2, top = 2, bottom = 2 }, 
	}

local select = select

--local pixelScale = caelLib.scale

local UpdateTime = function(self, curValue)
	local minValue, maxValue = self:GetMinMaxValues()
	if self.channeling then
		self.time:SetFormattedText("%.1f ", curValue)
	else
		self.time:SetFormattedText("%.1f ", maxValue - curValue)
	end
end

local ThreatUpdate = function(self, elapsed)
	self.elapsed = self.elapsed + elapsed
	if self.elapsed >= 0.2 then
		local _, maxHealth = self.healthBar:GetMinMaxValues()
		local valueHealth = self.healthBar:GetValue()
		self.hpvalue:SetText(string.format("%d%%", math.floor((valueHealth / maxHealth) * 100)))
		if not self.oldglow:IsShown() then
			if InCombatLockdown() and self.isFriendly == false then
				self.healthBar:SetStatusBarColor(goodR, goodG, goodB)
			else
				self.healthBar:SetStatusBarColor(self.r, self.g, self.b)
			end
		else
			local r, g, b = self.oldglow:GetVertexColor()
			if g + b == 0 then
				self.healthBar:SetStatusBarColor(badR, badG, badB)
			else
				self.healthBar:SetStatusBarColor(transitionR, transitionG, transitionB)
			end
		end
		self.elapsed = 0
	end
end

local UpdatePlate = function(self)
	local r, g, b = self.healthBar:GetStatusBarColor()
	local newr, newg, newb
	if g + b == 0 then
		-- Hostile unit
		newr, newg, newb = 0.85, 0.27, 0.27
		self.healthBar:SetStatusBarColor(0.85, 0.27, 0.27)
		self.isFriendly = false
	elseif r + b == 0 then
		-- Friendly unit
		newr, newg, newb = 0.33, 0.59, 0.33
		self.healthBar:SetStatusBarColor(0.33, 0.59, 0.33)
		self.isFriendly = true
	elseif r + g == 0 then
		-- Friendly player
		newr, newg, newb = 0.31, 0.45, 0.63
		self.healthBar:SetStatusBarColor(0.31, 0.45, 0.63)
		self.isFriendly = true
	elseif 2 - (r + g) < 0.05 and b == 0 then
		-- Neutral unit
		newr, newg, newb = 0.85, 0.77, 0.36
		self.healthBar:SetStatusBarColor(0.85, 0.77, 0.36)
		self.isFriendly = false
	else
		-- Hostile player - class colored.
		newr, newg, newb = r, g, b
		self.isFriendly = false
	end

	self.r, self.g, self.b = newr, newg, newb
	self.healthBar:ClearAllPoints()
	self.healthBar:SetPoint("CENTER", self.healthBar:GetParent())
	self.healthBar:SetHeight(6)
	self.healthBar:SetWidth(100)

	self.healthBar.hpBackground:SetVertexColor(self.r * 0.33, self.g * 0.33, self.b * 0.33, 0.75)
	self.castBar.IconOverlay:SetVertexColor(self.r, self.g, self.b)

	self.castBar:ClearAllPoints()
	self.castBar:SetPoint("TOP", self.healthBar, "BOTTOM", 0, -6)
	self.castBar:SetHeight(6)
	self.castBar:SetWidth(100)

	self.highlight:ClearAllPoints()
	self.highlight:SetAllPoints(self.healthBar)

	local oldName = self.oldname:GetText()
	local newName = (string.len(oldName) > 20) and string.gsub(oldName, "%s?(.[\128-\191]*)%S+%s", "%1. ") or oldName -- "%s?(.)%S+%s"

	self.name:SetText(newName)

	local level, elite, mylevel = tonumber(self.level:GetText()), self.elite:IsShown(), UnitLevel("player")
	self.level:ClearAllPoints()
	self.level:SetPoint("RIGHT", self.healthBar, "LEFT")
	if self.boss:IsShown() then
		self.level:SetText("Boss")
		self.level:SetTextColor(0.8, 0.05, 0)
		self.level:Show()
	elseif not elite and level == mylevel then
		self.level:Hide()
	else
		self.level:SetText(level..(elite and "+" or ""))
	end
end

local FixCastbar = function(self)
	self.castbarOverlay:Hide()
	self:ClearAllPoints()
	self:SetPoint("TOP", self.healthBar, "BOTTOM", 0, -6)
	self:SetHeight(3)
	self:SetWidth(100)
end

local ColorCastBar = function(self, shielded)
	if shielded then
		self:SetStatusBarColor(0.8, 0.05, 0)
		self.cbGlow:SetBackdropBorderColor(0.75, 0.75, 0.75)
	else
		self.cbGlow:SetBackdropBorderColor(0, 0, 0)
	end
end

local OnSizeChanged = function(self, width, height)
	if floor(height) ~= 3 then
		self.needFix = true
	end
end

local OnShow = function(self)
	self.channeling  = UnitChannelInfo("target")
	if self.needFix then
		FixCastbar(self)
	end
	ColorCastBar(self, self.shieldedRegion:IsShown())
	self.IconOverlay:Show()
end

local OnValueChanged = function(self, curValue)
	UpdateTime(self, curValue)
	if self.needFix then
		FixCastbar(self)
		self.needFix = nil
	end
end

local OnHide = function(self)
	self.highlight:Hide()
	self.healthBar.hpGlow:SetBackdropBorderColor(0, 0, 0)
	self.isFriendly = nil
end

local OnEvent = function(self, event, unit)
	if unit == "target" then
		if self:IsShown() then
			ColorCastBar(self, event == "UNIT_SPELLCAST_NOT_INTERRUPTIBLE")
		end
	end
end

local CreatePlate = function(frame)
     
	frame.done = true
	frame.isFriendly = nil
	frame.barFrame, frame.nameFrame = frame:GetChildren()
	frame.healthBar, frame.castBar = frame.barFrame:GetChildren()

	local healthBar, castBar = frame.healthBar, frame.castBar
	local glowRegion, overlayRegion, highlightRegion, levelTextRegion, bossIconRegion, raidIconRegion, stateIconRegion = frame.barFrame:GetRegions()
	local _, castbarOverlay, shieldedRegion, spellIconRegion = castBar:GetRegions()
	local nameTextRegion = frame.nameFrame:GetRegions()

	frame.oldname = nameTextRegion
	nameTextRegion:Hide()

	local newNameRegion = frame:CreateFontString(nil, "ARTWORK")
	newNameRegion:SetPoint("BOTTOMLEFT", healthBar, "TOPLEFT", 0, 2)
	newNameRegion:SetFont(font, fontSize, fontOutline)
	newNameRegion:SetTextColor(0.84, 0.75, 0.65)
	newNameRegion:SetShadowOffset(1.25, -1.25)
	frame.name = newNameRegion
	
	local healthvalueRegion = frame:CreateFontString(nil, "ARTWORK")
	healthvalueRegion:SetPoint("RIGHT", healthBar, "BOTTOMRIGHT", 0, -3)
	healthvalueRegion:SetFont(font, fontSize, fontOutline)
	healthvalueRegion:SetTextColor(0.84, 0.75, 0.65)
	healthvalueRegion:SetShadowOffset(1.25, -1.25)
	healthvalueRegion:SetTextColor(1, 1, 1)
	frame.hpvalue = healthvalueRegion
	
	frame.level = levelTextRegion
	levelTextRegion:SetFont(font, fontSize, fontOutline)
	levelTextRegion:SetShadowOffset(1.25, -1.25)

	healthBar:SetStatusBarTexture(barTexture)

	healthBar.hpBackground = healthBar:CreateTexture(nil, "BACKGROUND")
	healthBar.hpBackground:SetAllPoints()
	healthBar.hpBackground:SetTexture(barTexture)

	healthBar.hpGlow = CreateFrame("Frame", nil, healthBar)
	healthBar.hpGlow:SetFrameLevel(healthBar:GetFrameLevel() -1 > 0 and healthBar:GetFrameLevel() -1 or 0)
	healthBar.hpGlow:SetPoint("TOPLEFT", healthBar, "TOPLEFT", -2, 2)
	healthBar.hpGlow:SetPoint("BOTTOMRIGHT", healthBar, "BOTTOMRIGHT", 2, -2)
	healthBar.hpGlow:SetBackdrop(backdrop)
	healthBar.hpGlow:SetBackdropColor(0, 0, 0, 0)
	healthBar.hpGlow:SetBackdropBorderColor(0, 0, 0)

	castBar.castbarOverlay = castbarOverlay
	castBar.healthBar = healthBar
	castBar.shieldedRegion = shieldedRegion
	castBar:SetStatusBarTexture(barTexture)

	castBar:HookScript("OnShow", OnShow)
	castBar:HookScript("OnSizeChanged", OnSizeChanged)
	castBar:HookScript("OnValueChanged", OnValueChanged)
	castBar:HookScript("OnEvent", OnEvent)
	castBar:RegisterEvent("UNIT_SPELLCAST_INTERRUPTIBLE")
	castBar:RegisterEvent("UNIT_SPELLCAST_NOT_INTERRUPTIBLE")

	castBar.time = castBar:CreateFontString(nil, "ARTWORK")
	castBar.time:SetPoint("LEFT", castBar, "LEFT", 3, -1)
	castBar.time:SetFont(font, fontSize, fontOutline)
	castBar.time:SetTextColor(0.84, 0.75, 0.65)
	castBar.time:SetShadowOffset(1.25, -1.25)

	castBar.cbBackground = castBar:CreateTexture(nil, "BACKGROUND")
	castBar.cbBackground:SetAllPoints()
	castBar.cbBackground:SetTexture(barTexture)
	castBar.cbBackground:SetVertexColor(0.25, 0.25, 0.25, 0.75)

	castBar.cbGlow = CreateFrame("Frame", nil, castBar)
	castBar.cbGlow:SetFrameLevel(castBar:GetFrameLevel() -1 > 0 and castBar:GetFrameLevel() -1 or 0)
	castBar.cbGlow:SetPoint("TOPLEFT", castBar, -2, 2)
	castBar.cbGlow:SetPoint("BOTTOMRIGHT", castBar, 2, -2)
	castBar.cbGlow:SetBackdrop(backdrop)
	castBar.cbGlow:SetBackdropColor(0, 0, 0, 0)
	castBar.cbGlow:SetBackdropBorderColor(0, 0, 0)

	castBar.HolderA = CreateFrame("Frame", nil, castBar)
	castBar.HolderA:SetFrameLevel(castBar.HolderA:GetFrameLevel() + 1)
	castBar.HolderA:SetAllPoints()

	spellIconRegion:ClearAllPoints()
	spellIconRegion:SetParent(castBar.HolderA)
	spellIconRegion:SetPoint("BOTTOMLEFT", castBar, "BOTTOMRIGHT", 2, 0)
	spellIconRegion:SetSize(15, 15)

	castBar.HolderB = CreateFrame("Frame", nil, castBar)
	castBar.HolderB:SetFrameLevel(castBar.HolderA:GetFrameLevel() + 1)
	castBar.HolderB:SetAllPoints()

	castBar.IconOverlay = castBar.HolderB:CreateTexture(nil, "OVERLAY")
	castBar.IconOverlay:SetPoint("TOPLEFT", spellIconRegion, -1.5, 1.5)
	castBar.IconOverlay:SetPoint("BOTTOMRIGHT", spellIconRegion, 1.5, -1.5)
	castBar.IconOverlay:SetTexture(iconTexture)

	highlightRegion:SetTexture(barTexture)
	highlightRegion:SetVertexColor(0.25, 0.25, 0.25)
	frame.highlight = highlightRegion

	raidIconRegion:ClearAllPoints()
	raidIconRegion:SetPoint("RIGHT", healthBar, 0, 7)
	raidIconRegion:SetSize(15, 15)
	raidIconRegion:SetTexture(raidIcons)	

	frame.oldglow = glowRegion
	frame.elite = stateIconRegion
	frame.boss = bossIconRegion

	glowRegion:SetTexture(nil)
	overlayRegion:SetTexture(nil)
	shieldedRegion:SetTexture(nil)
	castbarOverlay:SetTexture(nil)
	stateIconRegion:SetAlpha(0)
	bossIconRegion:SetTexture(nil)

	UpdatePlate(frame)
	frame:SetScript("OnShow", UpdatePlate)
	frame:SetScript("OnHide", OnHide)

	frame.elapsed = 0
	frame:SetScript("OnUpdate", ThreatUpdate)
end

local numKids = 0
local lastUpdate = 0
local index = 1
local OnUpdate = function(self, elapsed)
	lastUpdate = lastUpdate + elapsed

	if lastUpdate > 0.1 then
		lastUpdate = 0

		local newNumKids = WorldFrame:GetNumChildren()
		if newNumKids ~= numKids then
			numKids = WorldFrame:GetNumChildren()
			for i = index, numKids do
				local frame = select(i, WorldFrame:GetChildren())
				local name = frame:GetName()

				if name and name:find("NamePlate") and not frame.done then
					CreatePlate(frame)
					index = i
				end
			end
		end
	end
end
caelNamePlates:SetScript("OnUpdate", OnUpdate)