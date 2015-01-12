-- pNameplates
-- Version:  2.1.0
-- Authors:  Crushbeers

--[[       TABLE OF CONTENTS      ]]--
--[[ ---------------------------- ]]--
--[[ 1. TEXTURES/LOCAL VARIABLES  ]]--
--[[ 2. UTILITY FUNCTIONS		  ]]--
--[[ 3. STYLE FUNCTIONS			  ]]--
--[[ 4. THREAT MANAGEMENT		  ]]--
--[[ 5. UPDATE FUNCTIONS		  ]]--
--[[ 6. CORE FUNCTIONS			  ]]--
--[[ 7. SLASH COMMANDS			  ]]--

--------------------------------------
-- 1. TEXUTURES AND LOCAL VARIABLES
--------------------------------------
local combat_toggle = true
local total        = -1
local ForceUpdate  = false
local MoveText     = false
local InCombat     = false

local backgroundTexture  	  = "Interface\\Buttons\\WHITE8x8"
local barTexture         	  = "Interface\\AddOns\\pNameplates\\Textures\\statusbar"

local MarkColors = {
	["0"] = {
		["0"]    = { 1.00, 1.00, 0.00 }, -- Star
		["0.25"] = { 1.00, 0.50, 0.00 }, -- Circle
		["0.5"]  = { 0.78, 0.30, 1.00 }, -- Diamond
		["0.75"] = { 0.30, 1.00, 0.30 }  -- Triangle
	},
	["0.25"] = {
		["0"]    = { 0.60, 0.60, 0.60 }, -- Moon
		["0.25"] = { 0.20, 0.60, 1.00 }, -- Square
		["0.5"]  = { 1.00, 0.30, 0.30 }, -- Cross
		["0.75"] = { 1.00, 1.00, 1.00 }  -- Skull
	}
}


-- Text Location
local TLoc = {
	["top"]     = { "BOTTOM", "TOP"   ,  0, 2, "THINOUTLINE", "CENTER" },
	["left"]    = { "RIGHT" , "LEFT"  , -2, 0, "THINOUTLINE", "RIGHT"  },
	["right"]   = { "LEFT"  , "RIGHT" ,  2, 0, "THINOUTLINE", "LEFT"   },
	["center"]  = { "CENTER", "CENTER",  0, 0, "NONE",        "CENTER" },
	["inleft"]  = { "LEFT"  , "LEFT"  ,  2, 0, "THINOUTLINE", "LEFT"   },
	["inright"] = { "RIGHT" , "RIGHT" , -2, 0, "THINOUTLINE", "RIGHT"  }
}

-- Threat Setting Lists
local ThreatLow = {
	Right   = { loc = "TOPLEFT", x = 0, y = 0 },
	Left    = { loc = "BOTTOMRIGHT", x = 0, y = 0 },
	Color   = { r = 0, g = 1, b = 0 },
	Texture = "Interface\\AddOns\\pNameplates\\Textures\\threat_LOW",
	HPScale = 1,
}

local ThreatMed = {
	Right   = { loc = "TOPLEFT", x = 0, y = 0},
	Left    = { loc = "BOTTOMRIGHT", x = 0, y = 0 },
	Color   = { r = 0.7, g = 0.7, b = 0.0 },
	Texture = "Interface\\AddOns\\pNameplates\\Textures\\threat_MED",
	HPScale = 1,
}

local ThreatHigh = {
	Right   = { loc = "TOPLEFT", x = -1, y = 1 },
	Left    = { loc = "BOTTOMRIGHT", x = 1, y = -1 },
	Color   = { r = 1, g = 0.0, b = 0.0 },
	Texture = "Interface\\AddOns\\pNameplates\\Textures\\threat_HIGH",
	HPScale = 1,
}


--------------------------------------
-- 2. UTILITY FUNCTIONS
--------------------------------------
local function RoundNum(num, dec)
	num = num * math.pow(10, dec)
	num = math.ceil(num)
	num = num / math.pow(10, dec)
	return num
end

local function FormatHP(val)
	if (val >= 100000000) then val = RoundNum((val/100000000), 1).."Y"
	elseif (val >= 10000) then val = RoundNum((val/10000), 1).."W" end
	return val
end

local function GetRaidMark(plate)
	plate.ULx = select(1, plate.Raid:GetTexCoord())..""
	plate.ULy = select(2, plate.Raid:GetTexCoord())..""
end

local function IsTagged(r, g, b)
	return (RoundNum(r, 2) == 0.54 and RoundNum(g, 2) == 0.54 and RoundNum(b, 2) == 1.00)
end
--------------------------------------
-- 3. STYLE FUNCTIONS
--------------------------------------

local function HideBlizz(plate)
	plate.OHB:Hide()
	plate.ONa:Hide()
	plate.OBo:Hide()
	plate.OLv:SetWidth(1)
	plate.OHi:SetTexture(0, 0, 0, 0)
	plate.Thr:SetTexture(0, 0, 0, 0)
	plate.ODg:SetTexture(0, 0, 0, 0)
    plate.OCB.Shield:SetTexture(0, 0, 0, 0)
end

local function StyleCastbar(plate)
	plate.OCB:SetBackdrop({
        bgFile = backgroundTexture,
        insets = { left = -1, right = -1, top = -1, bottom = -1 }
    })
    plate.OCB:SetBackdropColor(0, 0, 0, 0.6)
    
	plate.OCB:ClearAllPoints()
    plate.OCB:SetPoint("TOPRIGHT", plate.HB, "BOTTOMRIGHT", (cfg.cbw/2)-(cfg.hpw/2), -4)
    plate.OCB:SetPoint("BOTTOMLEFT", plate.HB, "BOTTOMLEFT", (cfg.hpw/2)-(cfg.cbw/2), -4-cfg.cbh)
	
	plate.OCB.Border:SetTexture(0, 0, 0, 1)
    plate.OCB.Border:SetTexCoord(0, 1, 0, 1)
    plate.OCB.Border:ClearAllPoints()
    plate.OCB.Border:SetPoint("TOPLEFT", plate.OCB, 0, 0)
    plate.OCB.Border:SetPoint("BOTTOMRIGHT", plate.OCB, 0, 0)
    plate.OCB.Border:SetDrawLayer("BORDER")
    
    plate.OCB.Fill:SetTexture(barTexture)
    plate.OCB.Fill:ClearAllPoints()
    plate.OCB.Fill:SetPoint("TOPLEFT", plate.OCB.Border, "TOPLEFT", -1, 1)
    plate.OCB.Fill:SetPoint("TOPRIGHT", plate.OCB.Border, "BOTTOMRIGHT", 1, -1)
    
    plate.OCB.Icon:SetSize(12,12)
    plate.OCB.Icon:ClearAllPoints()
    plate.OCB.Icon:SetPoint("LEFT", plate.OCB, "RIGHT", 2, 0)
    
    plate.OCB.Time = plate.OCB:CreateFontString(nil, "HIGH")
	plate.OCB.Time:SetFont(cfg.FontType, cfg.FontSize_Cast, "THINOUTLINE")
	plate.OCB.Time:SetPoint("RIGHT", 0, 0)
	
	plate.OCB.Spell = plate.OCB:CreateFontString(nil, "HIGH")
	plate.OCB.Spell:ClearAllPoints()
	plate.OCB.Spell:SetFont(cfg.FontType, cfg.FontSize_Cast, "THINOUTLINE")
	plate.OCB.Spell:SetPoint("LEFT", plate.OCB, "LEFT", 1, 0)
end

local function StyleFonts(plate)
	plate.OCB.Time:SetFont(cfg.FontType, cfg.FontSize_Cast, "THINOUTLINE")
	plate.OCB.Spell:SetFont(cfg.FontType, cfg.FontSize_Cast, "THINOUTLINE")
	if (plate.Low and InCombat) then return end
	plate.HB.Txt:SetFont(cfg.FontType, cfg.FontSize_Perc, cfg.Mvmt["perc"][5])
	plate.Name:SetFont(cfg.FontType, cfg.FontSize_Name, cfg.Mvmt["name"][5])
	plate.Level:SetFont(cfg.FontType, cfg.FontSize_Level, cfg.Mvmt["level"][5])
end

local function ApplyShadow(text)
	text:SetShadowColor(0, 0, 0, 1)
	text:SetShadowOffset(1, -1)
end

local function RemoveShadow(text)
	text:SetShadowColor(0, 0, 0, 0)
end

local function StyleLevelText(plate)
    plate.OBo:SetTexture(nil)
--    plate.Boss:SetTexture(nil)
    plate.ODg:SetTexture(nil)
    plate.OHi:SetTexture(nil)

	if (plate.Boss:IsShown()) then 
	plate.Level:Hide() 
	else 
	plate.Level:Show() 
	end
	
	
	plate.Level:SetTextColor(plate.OLv:GetTextColor())
	local string = plate.OLv:GetText() or "-1"
	if (not string) then string = "" end
	if (plate.ODg:IsShown())  then string = string.."+" end
	return string
end

local function LowHealthWarn(plate)
	if (plate.Low) then
		plate.HB.Txt:SetFont(cfg.FontType, cfg.FontSize_Perc+3, cfg.Mvmt["perc"][5])
		plate.HB.Txt:SetTextColor(1, 0.5, 0)
	else
		plate.HB.Txt:SetFont(cfg.FontType, cfg.FontSize_Perc, cfg.Mvmt["perc"][5])
		plate.HB.Txt:SetTextColor(1, 1, 1)
	end
end

--------------------------------------
-- 4. THREAT MANAGEMENT
--------------------------------------

local function SetThreatStyle(plate, Threat)
	if (not cfg.RaidMarkColor or (cfg.RaidMarkColor and not plate.Raid:IsShown())) then
		plate.HB:SetStatusBarColor(Threat.Color.r, Threat.Color.g, Threat.Color.b, 1)
	end
	plate.Threat:SetPoint(Threat.Right.loc, plate.Border, Threat.Right.x, Threat.Right.y)
	plate.Threat:SetPoint(Threat.Left.loc, plate.Border, Threat.Left.x, Threat.Left.y)
	plate.Threat:SetTexture(Threat.Texture)
	plate.HB:SetScale(Threat.HPScale)
end

local function UpdateThreat(plate)
	if ((not InCombat and plate.Threat:IsShown()) or not cfg.ThreatEnabled or plate.Player) then
		plate.Threat:Hide()
		plate.HB:SetStatusBarColor(plate.OHB:GetStatusBarColor())
		plate.HB:SetScale(1)
		plate.ThreatOn = false
		return 
	elseif (InCombat and not plate.Player) then
		plate.ThreatOn = true
		plate.Threat:Show()
	else return end -- Returns if out of combat AND threat objects are hidden
	
	local red, green, blue, _ = plate.Thr:GetVertexColor()
	local shown = plate.Thr:IsShown()
	
	if (not shown) then 
		if (cfg.DPSHealerMode) then SetThreatStyle(plate, ThreatLow)
		else SetThreatStyle(plate, ThreatHigh) end
	elseif (red > 0) then
		if (green > 0) then SetThreatStyle(plate, ThreatMed) return end
		if (cfg.DPSHealerMode) then SetThreatStyle(plate, ThreatHigh)
		else SetThreatStyle(plate, ThreatLow) end
	end
end

--------------------------------------
-- 5. UPDATE FUNCTIONS
--------------------------------------

local function UpdateDisplay(plate)
	GetRaidMark(plate)
	
	plate.HB:SetSize(cfg.hpw,cfg.hph)
	plate.Name:SetText(plate.ONa:GetText())
	for  _,name in pairs(Whitelist) do
	    if plate.ONa:GetText() == name then
		plate.HB:SetSize(cfg.hpw,cfg.hph*2)
		plate.HB:SetFrameStrata("HIGH")
		end
	end
	for  _,name in pairs(Blacklist) do
	    if plate.ONa:GetText() == name then
		plate.HB:Hide()
		end
	end
	plate.Level:SetText(StyleLevelText(plate))
	 
	local _, max = plate.OHB:GetMinMaxValues()
	local value = plate.OHB:GetValue()
	local perc = math.floor((value/max)*100)
	plate.Low = (cfg.LowHP[1] and perc <= cfg.LowHP[2])
	
	if (ForceUpdate) then UpdateThreat(plate) end
	if (InCombat) then LowHealthWarn(plate) end
	
	if ((cfg.RaidMarkColor and plate.Raid:IsShown()) or not plate.Mod) then
		plate.HB:SetStatusBarColor(MarkColors[plate.ULy][plate.ULx][1],
		MarkColors[plate.ULy][plate.ULx][2], MarkColors[plate.ULy][plate.ULx][3], 1)
	elseif (not InCombat or (InCombat and not plate.Raid:IsShown() and not cfg.ThreatEnabled)) then
		plate.HB:SetStatusBarColor(plate.OHB:GetStatusBarColor())
	end
	
	if (cfg.ShowPercent) then
		if (perc >= 100 and not cfg.ShowWhenMax) then plate.HB.Txt:SetText("")
		else
			if (cfg.ShowHPValue) then plate.HB.Txt:SetText(FormatHP(value).." / "..perc.."%")
			else plate.HB.Txt:SetText(perc.."%") end
		end
	else
		plate.HB.Txt:SetText("")
	end
	
	--[[CheckAbbrv(plate)
	if (cfg.TargetBorder) then 
	plate.TBorder:Show()
	else 
	plate.TBorder:Hide()
	end
	]]
end

local function UpdateCastInfo(Castbar)
	plate = Castbar:GetParent()

	Castbar:ClearAllPoints()
    Castbar:SetPoint("TOPRIGHT", plate.HB, "BOTTOMRIGHT", (cfg.cbw/2)-(cfg.hpw/2), -4)
    Castbar:SetPoint("BOTTOMLEFT", plate.HB, "BOTTOMLEFT", (cfg.hpw/2)-(cfg.cbw/2), -5-cfg.cbh)

	local last = Castbar.last and Castbar.last or 0
	local _, max = Castbar:GetMinMaxValues()
	local current = Castbar:GetValue()
	local finish = (current > last) and (max - current) or current
	Castbar.Time:SetText(math.floor((finish)*10)/10)
	
	-- Fixes phantom Castbar frames appearing
	if (not finish or finish <= 0) then Castbar:Hide()
	else Castbar:Show() end
	
	Castbar.last = current
end

local function UpdateTextLocations(plate)
	plate.HB.Txt:ClearAllPoints()
	plate.HB.Txt:SetPoint(cfg.Mvmt["perc"][1], plate.HB, cfg.Mvmt["perc"][2], cfg.Mvmt["perc"][3], cfg.Mvmt["perc"][4])
	plate.HB.Txt:SetJustifyH(cfg.Mvmt["perc"][6])
	if (cfg.Mvmt["perc"][5] == "NONE") then ApplyShadow(plate.HB.Txt)
	else RemoveShadow(plate.HB.Txt) end
	
	plate.Name:ClearAllPoints()
	plate.Name:SetPoint(cfg.Mvmt["name"][1], plate.Level, cfg.Mvmt["name"][2], cfg.Mvmt["name"][3], cfg.Mvmt["name"][4])
	plate.Name:SetJustifyH(cfg.Mvmt["name"][6])
	if (cfg.Mvmt["name"][5] == "NONE") then ApplyShadow(plate.Name)
	else RemoveShadow(plate.Name) end
	
	plate.Level:ClearAllPoints()
	plate.Level:SetPoint(cfg.Mvmt["level"][1], plate.HB, cfg.Mvmt["level"][2], cfg.Mvmt["level"][3], cfg.Mvmt["level"][4])
	plate.Level:SetJustifyH(cfg.Mvmt["level"][6])
	if (cfg.Mvmt["level"][5] == "NONE") then ApplyShadow(plate.Level)
	else RemoveShadow(plate.Level) end
	
	plate.Raid:ClearAllPoints()
	plate.Raid:SetSize(cfg.raidSize, cfg.raidSize)
	plate.Raid:SetPoint(cfg.Mvmt["raid"][1], plate.HB, cfg.Mvmt["raid"][2], cfg.Mvmt["raid"][3], cfg.Mvmt["raid"][4])
	
	plate.Boss:ClearAllPoints()
	plate.Boss:SetPoint(plate.Level:GetPoint())
	
	--CheckAbbrv(plate)
end

--------------------------------------
-- 6. CORE FUNCTIONS
--------------------------------------

local function init(plate)
	OldFrames, OldName = plate:GetChildren()
	plate.ONa = OldName:GetRegions()
	plate.OHB, plate.OCB = OldFrames:GetChildren()
	
    plate.OCB.Fill, plate.OCB.Border, plate.OCB.Shield, plate.OCB.Icon = plate.OCB:GetRegions()
    plate.Thr, plate.OBo, plate.OHi, plate.OLv, plate.Boss, plate.Raid, plate.ODg = OldFrames:GetRegions()
	
	plate.HB = CreateFrame("StatusBar", nil, plate)
	plate.HB:SetPoint("center", plate, "center", 0, 0)
	plate.HB:SetSize(cfg.hpw,cfg.hph-2)
	plate.HB:SetStatusBarTexture(barTexture)
    plate.HB:SetBackdrop({
        bgFile = backgroundTexture,
        insets = { left = 1, right = 1, top = 1, bottom = 1 }
    })
    plate.HB:SetBackdropColor(0, 0, 0, 0.4)
    plate.HB:SetStatusBarColor(plate.OHB:GetStatusBarColor())
    
    plate.Over = plate:CreateTexture(nil, "Texture")
    plate.Over:SetParent(plate.HB)
    plate.Over:SetDrawLayer("OVERLAY", 7)
    plate.Over:SetTexture(1, 1, 1, 0.25)
	plate.Over:SetPoint("TOPLEFT", plate.HB, "TOPLEFT", -1, 1)
	plate.Over:SetPoint("BOTTOMRIGHT", plate.HB, "BOTTOMRIGHT", 1, -1)
	plate.Over:Hide()
	
	plate.Border = CreateFrame("Frame", nil, plate.HB)
	plate.Border:SetAllPoints(plate.HB)
	plate.Border:SetPoint("TOPLEFT", plate.HB, "TOPLEFT", -1, 1)
	plate.Border:SetPoint("BOTTOMRIGHT", plate.HB, "BOTTOMRIGHT", 1, -1)
	plate.Border:SetBackdrop( { 
		bgFile = nil, 
		edgeFile = backgroundTexture, 
		tile = false, tileSize = 0, edgeSize = 1, 
		insets = { left = -1, right = -1, top = -1, bottom = -1 }
	})
	plate.Border:SetBackdropBorderColor(0, 0, 0, 1)
	
	if not plate.HB.mark1 then
	plate.HB.mark1 = plate.HB:CreateFontString(nil, "OVERLAY")
	plate.HB.mark1:SetFont(STANDARD_TEXT_FONT, 14, "THINOUTLINE")
	plate.HB.mark1:SetText(">")
	plate.HB.mark1:SetTextColor(1,0,1)
	plate.HB.mark1:SetPoint("RIGHT", plate.HB, "LEFT", -1, 2)
	end
	if not plate.HB.mark2 then
	plate.HB.mark2 = plate.HB:CreateFontString(nil, "OVERLAY")
	plate.HB.mark2:SetFont(STANDARD_TEXT_FONT, 14, "THINOUTLINE")
	plate.HB.mark2:SetText("<")
	plate.HB.mark2:SetTextColor(1,0,1)
	plate.HB.mark2:SetPoint("LEFT", plate.HB, "RIGHT", 1, 2)
	end
--[[
	plate.TBorder = CreateFrame("Frame", nil, plate.Border)
	plate.TBorder:SetPoint("TOPLEFT", plate.HB, "TOPLEFT", -2, 2)
	plate.TBorder:SetPoint("BOTTOMRIGHT", plate.HB, "BOTTOMRIGHT", 2, -2)
	plate.TBorder:SetBackdrop( { 
		bgFile = nil, 
		edgeFile = backgroundTexture, 
		tile = false, tileSize = 0, edgeSize = 1, 
		insets = { left = 2, right = 2, top = 2, bottom = 2 }
	})
	plate.TBorder:SetBackdropBorderColor(1, 1, 1, 0)
  ]]
    plate.Threat = plate:CreateTexture(nil, "Texture")
    plate.Threat:SetPoint("TOPLEFT", plate.Border, -1, 1)
    plate.Threat:SetPoint("BOTTOMRIGHT", plate.Border, 1, -1)
	
	plate.Level = plate.HB:CreateFontString(nil, "ARTWORK", plate.HB)
	plate.Level:SetFont(cfg.FontType, cfg.FontSize_Level, cfg.Mvmt["level"][5])
	
	plate.Name = plate.HB:CreateFontString(nil, "ARTWORK", plate.HB)
	plate.Name:SetFont(cfg.FontType, cfg.FontSize_Name, cfg.Mvmt["name"][5])
	plate.Name:SetText(plate.ONa:GetText())
	plate.Name:SetWordWrap(false)
	plate.Name:SetWidth(100)
	
	plate.Raid:SetPoint(cfg.Mvmt["raid"][1], plate.HB, cfg.Mvmt["raid"][2], cfg.Mvmt["raid"][3], cfg.Mvmt["raid"][4])
	plate.Raid:SetSize(cfg.raidSize, cfg.raidSize)
	
	plate.HB.Txt = plate.HB:CreateFontString(nil, "ARTWORK", plate.HB)
	plate.HB.Txt:SetFont(cfg.FontType, cfg.FontSize_Perc, cfg.Mvmt["perc"][5])
	
	-- Initialization Stuff
	plate.Mod = true
	HideBlizz(plate)
	UpdateTextLocations(plate)
	UpdateDisplay(plate)
	StyleCastbar(plate)
	
	plate.OCB:SetScript("OnValueChanged", UpdateCastInfo)
	plate.OCB:SetParent(plate)
	
	plate:SetScript("OnUpdate", function(plate, time)
		if (plate.OHi:IsShown()) then plate.Over:Show() else plate.Over:Hide() end
	
		plate.HB:SetMinMaxValues(plate.OHB:GetMinMaxValues())
		plate.HB:SetValue(plate.OHB:GetValue())
		
		local r1, g1, b1, _ = plate.HB:GetStatusBarColor()
		local r2, g2, b2, _ = plate.OHB:GetStatusBarColor()
		
		plate.IsTagged = IsTagged(r2, g2, b2)
		
		if (b2 > 0 and g2 > 0  and not plate.IsTagged) then plate.Player = true else plate.Player = false end
		if (cfg.ThreatEnabled) then UpdateThreat(plate) end
		
		if (not plate.HB or (plate.ThreatOn and not plate.Player) or plate.Raid:IsShown()) then return end
		if (plate.IsTagged and cfg.RecolorTagged) then
			plate.HB:SetStatusBarColor(0.5, 0.5, 0.5, 1.0)
		elseif (r1 ~= r2 or g1 ~= g2 or b1 ~= b2) then
			plate.HB:SetStatusBarColor(plate.OHB:GetStatusBarColor())
		end
	end)
	
	plate.HB:SetScript("OnShow", function()
		UpdateDisplay(plate)
		UpdateCastInfo(plate.OCB)
	end)
	plate.HB:SetScript("OnHide", function() UpdateDisplay(plate) end)
	plate.HB:SetScript("OnValueChanged", function() UpdateDisplay(plate) end)
	plate.HB:SetScript("OnMinMaxChanged", function() UpdateDisplay(plate) end)
	
	plate:SetScript("OnEvent", function(plate, event)
		if (event == "RAID_TARGET_UPDATE") then
			UpdateDisplay(plate) end end)
	plate:RegisterEvent("RAID_TARGET_UPDATE")
end

local function GetObjects(frame, elapsed)
    local current = select("#", WorldFrame:GetChildren())
    if (current ~= total or ForceUpdate or MoveText) then
    	total = current
	  	for i = 1, current do
			local plate = select(i, WorldFrame:GetChildren())
			if (plate:GetName() and plate:GetName():match("NamePlate")) then
		  		if (not plate.Mod) then init(plate)
		  		else 
		  			UpdateDisplay(plate)
		  			if (ForceUpdate or MoveText) then StyleFonts(plate) end
		  			if (MoveText) then UpdateTextLocations(plate) end
		  		end
		  	end
		end
		ForceUpdate = false
		MoveText = false
    end
	
	local HasTarget = UnitExists("target")
	for i = 1, current do
		local plate = select(i, WorldFrame:GetChildren())
		if (plate:GetName() and plate:GetName():match("NamePlate")) then
			if (not HasTarget or (HasTarget and plate:GetAlpha() < 1)) then
--			plate.TBorder:SetBackdropBorderColor(1, 1, 1, 0)
			plate.HB.mark1:Hide()
			plate.HB.mark2:Hide()
			else 
--			plate.TBorder:SetBackdropBorderColor(1, 1, 1, 1)
			plate.HB.mark1:Show()
			plate.HB.mark2:Show()
			end
		end
	end

end

local function CheckDefaults()
	if (not cfg) then cfg = { } end
	
	if (not cfg.FontSize_Perc) then cfg.FontSize_Perc = 12 end
	if (not cfg.FontSize_Name) then cfg.FontSize_Name = 10 end
	if (not cfg.FontSize_Cast) then cfg.FontSize_Cast = 10 end
	if (not cfg.FontSize_Level) then cfg.FontSize_Level = 12 end
	if (not cfg.FontType) then cfg.FontType = STANDARD_TEXT_FONT end
	if (not cfg.hpw) then cfg.hpw = 120 end
	if (not cfg.hph) then cfg.hph = 6 end
	if (not cfg.cbw) then cfg.cbw = 120 end
	if (not cfg.cbh) then cfg.cbh = 6 end
	if (not cfg.raidSize) then cfg.raidSize = 24 end
	
	-- Boolean Variables
	if (cfg.ShowPercent == nil) then cfg.ShowPercent = true end
	if (cfg.ShowWhenMax == nil) then cfg.ShowWhenMax = false end
	if (cfg.ShowHPValue == nil) then cfg.ShowHPValue = true end
	if (cfg.ThreatEnabled == nil) then cfg.ThreatEnabled = true end
	if (cfg.DPSHealerMode == nil) then cfg.DPSHealerMode = true end
	if (cfg.RaidMarkColor == nil) then cfg.RaidMarkColor = true end
	--if (cfg.abbrv == nil) then cfg.abbrv = true end
	if (cfg.RecolorTagged == nil) then cfg.RecolorTagged = true end
	if (cfg.TargetBorder == nil) then cfg.TargetBorder = true end
	-- Text Element Positions
	if (not cfg.Mvmt) then cfg.Mvmt = { } end
	if (not cfg.Mvmt["raid"])  then cfg.Mvmt["raid"]  = { "RIGHT" , "LEFT"  ,-10, 0, "THINOUTLINE", "RIGHT"  } end
	if (not cfg.Mvmt["perc"])  then cfg.Mvmt["perc"]  = { "LEFT", "RIGHT"   , 15, 0, "THINOUTLINE", "CENTER" } end
	if (not cfg.Mvmt["name"])  then cfg.Mvmt["name"]  = { "LEFT", "RIGHT"   , 0, 0, "THINOUTLINE", "CENTER" } end
	if (not cfg.Mvmt["level"]) then cfg.Mvmt["level"] = { "BOTTOMLEFT"  , "TOPLEFT" , 0, 0, "THINOUTLINE", "LEFT"   } end
	
	-- Low Health Warning
	if (not cfg.LowHP) then cfg.LowHP = {
		[1] = false,    -- Enabled?
		[2] = 20,       -- Threshold
	} end
end

local f = CreateFrame("Frame")
f:SetScript("OnEvent", function(g, event)
	ForceUpdate = true
	if (event == "PLAYER_LOGIN") then
		CheckDefaults()
		SetCVar("ShowClassColorInNameplate", 1)
		g:SetScript("OnUpdate", GetObjects)
	elseif (event == "PLAYER_REGEN_DISABLED") then 
		InCombat = true
		if combat_toggle then 
			SetCVar("nameplateShowEnemies", 1)
		end
	elseif (event == "PLAYER_REGEN_ENABLED") then
		InCombat = false
		if combat_toggle then 
			SetCVar("nameplateShowEnemies", 0) 
		end
	end
	collectgarbage()
end)

-- if (UtoG[plate.Name:GetText()..string.sub(plate:GetName(), 10)])
-- if (GtoU[GUID])
  
f:RegisterEvent("PLAYER_LOGIN")
f:RegisterEvent("PLAYER_REGEN_DISABLED") -- Enter Combat
f:RegisterEvent("PLAYER_REGEN_ENABLED")  -- Leave Combat

