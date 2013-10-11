local ADDON_NAME, ns = ...
local oUF = ns.oUF or oUF

ns._Objects = {}
ns._Headers = {}

local colors = setmetatable({
    power = setmetatable({
        ['MANA'] = {.31,.45,.63},
    }, {__index = oUF.colors.power}),
}, {__index = oUF.colors})

function ns:hex(r, g, b)
    if(type(r) == 'table') then
        if(r.r) then r, g, b = r.r, r.g, r.b else r, g, b = unpack(r) end
    end
    return ('|cff%02x%02x%02x'):format(r * 255, g * 255, b * 255)
end
local fs = function(parent, layer, font, fontsiz, outline, r, g, b, justify)
    local string = parent:CreateFontString(nil, layer)
    string:SetFont(font, fontsiz, outline)
    string:SetShadowOffset(1, 1)
    string:SetTextColor(r, g, b)
    if justify then
        string:SetJustifyH(justify)
    end
    return string
end
local function updateHealbar(object)
    object.myHealPredictionBar:ClearAllPoints()
    object.otherHealPredictionBar:ClearAllPoints()

    if Qulight["raidframes"].orientation == "VERTICAL" then
        object.myHealPredictionBar:SetPoint("BOTTOMLEFT", object.Health:GetStatusBarTexture(), "TOPLEFT", 0, 0)
        object.myHealPredictionBar:SetPoint("BOTTOMRIGHT", object.Health:GetStatusBarTexture(), "TOPRIGHT", 0, 0)
        object.myHealPredictionBar:SetSize(0, Qulight["raidframes"].height)
        object.myHealPredictionBar:SetOrientation"VERTICAL"

        object.otherHealPredictionBar:SetPoint("BOTTOMLEFT", object.myHealPredictionBar:GetStatusBarTexture(), "TOPLEFT", 0, 0)
        object.otherHealPredictionBar:SetPoint("BOTTOMRIGHT", object.myHealPredictionBar:GetStatusBarTexture(), "TOPRIGHT", 0, 0)
        object.otherHealPredictionBar:SetSize(0, Qulight["raidframes"].height)
        object.otherHealPredictionBar:SetOrientation"VERTICAL"
    else
        object.myHealPredictionBar:SetPoint("TOPLEFT", object.Health:GetStatusBarTexture(), "TOPRIGHT", 0, 0)
        object.myHealPredictionBar:SetPoint("BOTTOMLEFT", object.Health:GetStatusBarTexture(), "BOTTOMRIGHT", 0, 0)
        object.myHealPredictionBar:SetSize(Qulight["raidframes"].width, 0)
        object.myHealPredictionBar:SetOrientation"HORIZONTAL"

        object.otherHealPredictionBar:SetPoint("TOPLEFT", object.myHealPredictionBar:GetStatusBarTexture(), "TOPRIGHT", 0, 0)
        object.otherHealPredictionBar:SetPoint("BOTTOMLEFT", object.myHealPredictionBar:GetStatusBarTexture(), "BOTTOMRIGHT", 0, 0)
        object.otherHealPredictionBar:SetSize(Qulight["raidframes"].width, 0)
        object.otherHealPredictionBar:SetOrientation"HORIZONTAL"
    end

    object.myHealPredictionBar:GetStatusBarTexture():SetTexture(unpack(Qulight["raidframes"].myhealcolor))
    object.otherHealPredictionBar:GetStatusBarTexture():SetTexture(unpack(Qulight["raidframes"].otherhealcolor))
end

-- Unit Menu
local dropdown = CreateFrame('Frame', ADDON_NAME .. 'DropDown', UIParent, 'UIDropDownMenuTemplate')

local function menu(self)
    dropdown:SetParent(self)
    return ToggleDropDownMenu(1, nil, dropdown, 'cursor', 0, 0)
end

local init = function(self)
    if Qulight["raidframes"].hidemenu and InCombatLockdown() then
        return
    end

    local unit = self:GetParent().unit
    local menu, name, id

    if(not unit) then
        return
    end

    if(UnitIsUnit(unit, "player")) then
        menu = "SELF"
    elseif(UnitIsUnit(unit, "vehicle")) then
        menu = "VEHICLE"
    elseif(UnitIsUnit(unit, "pet")) then
        menu = "PET"
    elseif(UnitIsPlayer(unit)) then
        id = UnitInRaid(unit)
        if(id) then
            menu = "RAID_PLAYER"
            name = GetRaidRosterInfo(id)
        elseif(UnitInParty(unit)) then
            menu = "PARTY"
        else
            menu = "PLAYER"
        end
    else
        menu = "TARGET"
        name = RAID_TARGET_ICON
    end

    if(menu) then
        UnitPopup_ShowMenu(self, menu, unit, name, id)
    end
end

UIDropDownMenu_Initialize(dropdown, init, 'MENU')

local backdrop = {
    bgFile = [=[Interface\ChatFrame\ChatFrameBackground]=],
    insets = {top = 0, left = 0, bottom = 0, right = 0},
}

local border = {
    bgFile = [=[Interface\AddOns\oUF_Qulight\Root\Media\white.tga]=],
    insets = {top = -2, left = -2, bottom = -2, right = -2},
}

local border2 = {
    bgFile = [=[Interface\ChatFrame\ChatFrameBackground]=],
    insets = {top = -1, left = -1, bottom = -1, right = -1},
}
-- Show Target Border
local ChangedTarget = function(self)
    if Qulight["raidframes"].tborder and UnitIsUnit('target', self.unit) then
        self.TargetBorder:Show()
    else
        self.TargetBorder:Hide()
    end
end

-- Show Focus Border
local FocusTarget = function(self)
    if Qulight["raidframes"].fborder and UnitIsUnit('focus', self.unit) then
        self.FocusHighlight:Show()
    else
        self.FocusHighlight:Hide()
    end
end

local updateThreat = function(self, event, unit)
    if(unit ~= self.unit) then return end

    local status = UnitThreatSituation(unit)

    if(status and status > 1) then
        local r, g, b = GetThreatStatusColor(status)
        self.Threat:SetBackdropBorderColor(r, g, b, 1)
        self.border:SetBackdropColor(r, g, b, 1)
    else
        self.Threat:SetBackdropBorderColor(0, 0, 0, 1)
        self.border:SetBackdropColor(0, 0, 0, 1)
    end
    self.Threat:Show()
end

ns.nameCache = {}
ns.colorCache = {}
ns.debuffColor = {} -- hex debuff colors for tags

local function utf8sub(str, start, numChars) 
    local currentIndex = start 
    while numChars > 0 and currentIndex <= #str do 
        local char = string.byte(str, currentIndex) 
        if char >= 240 then 
            currentIndex = currentIndex + 4 
        elseif char >= 225 then 
            currentIndex = currentIndex + 3 
        elseif char >= 192 then 
            currentIndex = currentIndex + 2 
        else 
            currentIndex = currentIndex + 1 
        end 
        numChars = numChars - 1 
    end 
    return str:sub(start, currentIndex - 1) 
end 

function ns:UpdateName(name, unit) 
    if(unit) then
        local _NAME = UnitName(unit)
        local _, class = UnitClass(unit)
        if not _NAME or not class then return end

        local substring
        for length=#_NAME, 1, -1 do
            substring = utf8sub(_NAME, 1, length)
            name:SetText(substring)
            if name:GetStringWidth() <= Qulight["raidframes"].width - 8 then name:SetText(nil); break end
        end

        local str = ns.colorCache[class]..substring
        ns.nameCache[_NAME] = str
        name:UpdateTag()
    end
end

local function PostHealth(hp, unit)
    local self = hp.__owner
    local name = UnitName(unit)

    if not ns.nameCache[name] then
        ns:UpdateName(self.Name, unit)
    end
		
    if Qulight["raidframes"].definecolors and hp.colorSmooth then
        hp.bg:SetVertexColor(unpack(Qulight["raidframes"].hpbgcolor))
        return
    end

    local suffix = self:GetAttribute'unitsuffix'
    if suffix == 'pet' or unit == 'vehicle' or unit == 'pet' then
        local r, g, b = .2, .9, .1
        hp:SetStatusBarColor(r*.2, g*.2, b*.2)
        hp.bg:SetVertexColor(r, g, b)
        return
    elseif Qulight["raidframes"].definecolors then
        hp.bg:SetVertexColor(unpack(Qulight["raidframes"].hpbgcolor))
        hp:SetStatusBarColor(unpack(Qulight["raidframes"].hpcolor))
        return 
    end

    local r, g, b, t
    if(UnitIsPlayer(unit)) then
        local _, class = UnitClass(unit)
        t = colors.class[class]
    else		
        r, g, b = .2, .9, .1
    end

    if(t) then
        r, g, b = t[1], t[2], t[3]
    end

    if(b) then
        if Qulight["raidframes"].reversecolors then
            hp.bg:SetVertexColor(r*.2, g*.2, b*.2)
            hp:SetStatusBarColor(r, g, b)
        else
            hp.bg:SetVertexColor(r, g, b)
            hp:SetStatusBarColor(0, 0, 0, .8)
        end
    end
end
function ns:UpdateHealth(hp)
    hp:SetStatusBarTexture(Qulight["media"].texture)
    hp:SetOrientation(Qulight["raidframes"].orientation)
    hp.bg:SetTexture(Qulight["media"].texture)
    hp.Smooth = true

    hp.colorSmooth = Qulight["raidframes"].colorSmooth
    hp.smoothGradient = { 
        unpack(Qulight["raidframes"].gradient),
        unpack(Qulight["raidframes"].hpcolor),
    }

    if not Qulight["raidframes"].powerbar then
        hp:SetHeight(Qulight["raidframes"].height)
        hp:SetWidth(Qulight["raidframes"].width)
    end

    hp:ClearAllPoints()
    hp:SetPoint"TOP"
    if Qulight["raidframes"].orientation == "VERTICAL" and Qulight["raidframes"].porientation == "VERTICAL" then
        hp:SetPoint"LEFT"
        hp:SetPoint"BOTTOM"
    elseif Qulight["raidframes"].orientation == "HORIZONTAL" and Qulight["raidframes"].porientation == "VERTICAL" then
        hp:SetPoint"RIGHT"
        hp:SetPoint"BOTTOM"
    else
        hp:SetPoint"LEFT"
        hp:SetPoint"RIGHT"
    end
end

local function PostPower(power, unit)
    local self = power.__owner
    local _, ptype = UnitPowerType(unit)
    local _, class = UnitClass(unit)

    if ptype == 'MANA' then
        power:Show()
        if(Qulight["raidframes"].porientation == "VERTICAL")then
            power:SetWidth(Qulight["raidframes"].width*Qulight["raidframes"].powerbarsize)
            self.Health:SetWidth((0.98 - Qulight["raidframes"].powerbarsize)*Qulight["raidframes"].width)
        else
            power:SetHeight(Qulight["raidframes"].height*Qulight["raidframes"].powerbarsize)
            self.Health:SetHeight((0.98 - Qulight["raidframes"].powerbarsize)*Qulight["raidframes"].height)
        end
    else
        power:Hide()
        if(Qulight["raidframes"].porientation == "VERTICAL")then
            self.Health:SetWidth(Qulight["raidframes"].width)
        else
            self.Health:SetHeight(Qulight["raidframes"].height)
        end
    end

    local perc = oUF.Tags.Methods['perpp'](unit)
    -- This kinda conflicts with the threat module, but I don't really care
    if (perc < 10 and UnitIsConnected(unit) and ptype == 'MANA' and not UnitIsDeadOrGhost(unit)) then
        self.Threat:SetBackdropBorderColor(0, 0, 1, 1)
        self.border:SetBackdropColor(0, 0, 1, 1)
    else
        -- pass the coloring back to the threat func
        updateThreat(self, nil, unit)
    end

    if Qulight["raidframes"].powerdefinecolors then
        power.bg:SetVertexColor(unpack(Qulight["raidframes"].powerbgcolor))
        power:SetStatusBarColor(unpack(Qulight["raidframes"].powercolor))
        return
    end

    local r, g, b, t
    t = Qulight["raidframes"].powerclass and colors.class[class] or colors.power[ptype]

    if(t) then
        r, g, b = t[1], t[2], t[3]
    else
        r, g, b = 1, 1, 1
    end

    if(b) then
        if Qulight["raidframes"].reversecolors or Qulight["raidframes"].powerclass then
            power.bg:SetVertexColor(r*.2, g*.2, b*.2)
            power:SetStatusBarColor(r, g, b)
        else
            power.bg:SetVertexColor(r, g, b)
            power:SetStatusBarColor(0, 0, 0, .8)
        end
    end
end

function ns:UpdatePower(power)
    if Qulight["raidframes"].powerbar then
        power:Show()
        power.PostUpdate = PostPower
    else
        power:Hide()
        power.PostUpdate = nil
        return
    end
    power:SetStatusBarTexture(Qulight["media"].texture)
    power:SetOrientation(Qulight["raidframes"].porientation)
    power.bg:SetTexture(Qulight["media"].texture)

    power:ClearAllPoints()
    if Qulight["raidframes"].orientation == "HORIZONTAL" and Qulight["raidframes"].porientation == "VERTICAL" then
        power:SetPoint"LEFT"
        power:SetPoint"TOP"
        power:SetPoint"BOTTOM"
    elseif Qulight["raidframes"].porientation == "VERTICAL" then
        power:SetPoint"TOP"
        power:SetPoint"RIGHT"
        power:SetPoint"BOTTOM"
    else
        power:SetPoint"LEFT"
        power:SetPoint"RIGHT"
        power:SetPoint"BOTTOM"
    end
end

-- Show Mouseover highlight
local OnEnter = function(self)
    if Qulight["raidframes"].tooltip then
        UnitFrame_OnEnter(self)
    else
        GameTooltip:Hide()
    end

    if Qulight["raidframes"].highlight then
        self.Highlight:Show()
    end
end

local OnLeave = function(self)
    if Qulight["raidframes"].tooltip then
        UnitFrame_OnLeave(self)
    end
    self.Highlight:Hide()
end
SetFontString = function(parent, fontName, fontHeight, fontStyle)
	local fs = parent:CreateFontString(nil, "OVERLAY")
	fs:SetFont(fontName, fontHeight, fontStyle)
	fs:SetJustifyH("LEFT")
	fs:SetShadowColor(0, 0, 0)
	fs:SetShadowOffset(1.25, -1.25)
	return fs
end
local style = function(self)
    self.menu = menu

    -- Backdrop
    self.BG = CreateFrame("Frame", nil, self)
    self.BG:SetPoint("TOPLEFT", self, "TOPLEFT")
    self.BG:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT")
    self.BG:SetFrameLevel(3)
    self.BG:SetBackdrop(backdrop)
    self.BG:SetBackdropColor(0, 0, 0)

    self.border = CreateFrame("Frame", nil, self)
    self.border:SetPoint("TOPLEFT", self, "TOPLEFT")
    self.border:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT")
    self.border:SetFrameLevel(2)
    self.border:SetBackdrop(border2)
    self.border:SetBackdropColor(0, 0, 0)

    -- Mouseover script
    self:SetScript("OnEnter", OnEnter)
    self:SetScript("OnLeave", OnLeave)
    self:RegisterForClicks"AnyUp"

    -- Health
    self.Health = CreateFrame"StatusBar"
    self.Health:SetParent(self)
    self.Health.frequentUpdates = true

    self.Health.bg = self.Health:CreateTexture(nil, "BORDER")
    self.Health.bg:SetAllPoints(self.Health)

    self.Health.PostUpdate = PostHealth
    ns:UpdateHealth(self.Health)

    -- Threat
    local threat = CreateFrame("Frame", nil, self)
    threat:SetPoint("TOPLEFT", self, "TOPLEFT", -5, 5)
    threat:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", 5, -5)
    threat:SetFrameLevel(0)
	CreateShadow0(threat)
    threat:SetBackdropColor(0, 0, 0, 0)
    threat:SetBackdropBorderColor(0, 0, 0, 1)
    threat.Override = updateThreat
    self.Threat = threat

    -- Name
    local name = self.Health:CreateFontString(nil, "OVERLAY")
    name:SetPoint("CENTER")
    name:SetJustifyH("CENTER")
    name:SetFont(Qulight["media"].font, Qulight["raidframes"].fontsize, Qulight["raidframes"].outline)
    name:SetShadowOffset(1.25, -1.25)
    name:SetWidth(Qulight["raidframes"].width)
    name.overrideUnit = true
    self.Name = name
    self:Tag(self.Name, '[color][name]')

    ns:UpdateName(self.Name)

    -- Power
    self.Power = CreateFrame"StatusBar"
    self.Power:SetParent(self)
    self.Power.bg = self.Power:CreateTexture(nil, "BORDER")
    self.Power.bg:SetAllPoints(self.Power)
    ns:UpdatePower(self.Power)

    -- Highlight tex
    local hl = self.Health:CreateTexture(nil, "OVERLAY")
    hl:SetAllPoints(self)
    hl:SetTexture([=[Interface\AddOns\oUF_Qulight\Root\Media\white.tga]=])
    hl:SetVertexColor(1,1,1,.1)
    hl:SetBlendMode("ADD")
    hl:Hide()
    self.Highlight = hl

    -- Target tex
    local tBorder = CreateFrame("Frame", nil, self)
    tBorder:SetPoint("TOPLEFT", self, "TOPLEFT")
    tBorder:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT")
    tBorder:SetBackdrop(border)
    tBorder:SetBackdropColor(.8, .8, .8, 1)
    tBorder:SetFrameLevel(1)
    tBorder:Hide()
    self.TargetBorder = tBorder

    -- Focus tex
    local fBorder = CreateFrame("Frame", nil, self)
    fBorder:SetPoint("TOPLEFT", self, "TOPLEFT")
    fBorder:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT")
    fBorder:SetBackdrop(border)
    fBorder:SetBackdropColor(.6, .8, 0, 1)
    fBorder:SetFrameLevel(1)
    fBorder:Hide()
    self.FocusHighlight = fBorder
			
    -- Raid Icons
    local ricon = self.Health:CreateTexture(nil, 'OVERLAY')
    ricon:SetPoint("TOP", self, 0, 5)
	ricon:SetTexture("Interface\\AddOns\\oUF_Qulight\\Root\\Media\\raidicons")	
    ricon:SetSize(Qulight["raidframes"].leadersize+2, Qulight["raidframes"].leadersize+2)
    self.RaidIcon = ricon

    -- Leader Icon
    self.Leader = self.Health:CreateTexture(nil, "OVERLAY")
    self.Leader:SetPoint("TOPLEFT", self, 0, 8)
    self.Leader:SetSize(Qulight["raidframes"].leadersize, Qulight["raidframes"].leadersize)

    -- Assistant Icon
    self.Assistant = self.Health:CreateTexture(nil, "OVERLAY")
    self.Assistant:SetPoint("TOPLEFT", self, 0, 8)
    self.Assistant:SetSize(Qulight["raidframes"].leadersize, Qulight["raidframes"].leadersize)

    local masterlooter = self.Health:CreateTexture(nil, 'OVERLAY')
    masterlooter:SetSize(Qulight["raidframes"].leadersize, Qulight["raidframes"].leadersize)
    masterlooter:SetPoint('LEFT', self.Leader, 'RIGHT')
    self.MasterLooter = masterlooter

    -- Role Icon
    if Qulight["raidframes"].roleicon then
        local lfd = fs(self.Health, "OVERLAY", fontsymbol, 10, OUTLINE, 1, 1, 1)
		lfd:SetPoint("LEFT", self.Health, 0, 6)
		lfd:SetJustifyH"LEFT"
	    self:Tag(lfd, '[LFD]')
    end

    self.freebIndicators = true
    self.freebAfk = true
    self.freebHeals = true

    self.ResurrectIcon = self.Health:CreateTexture(nil, 'OVERLAY')
    self.ResurrectIcon:SetPoint("TOP", self, 0, -2)
    self.ResurrectIcon:SetSize(16, 16)

    -- Range
    self.Range = {
		insideAlpha = 1,
		outsideAlpha = Qulight["raidframes"].outsideRange,	}
		
    -- ReadyCheck
    self.ReadyCheck = self.Health:CreateTexture(nil, "OVERLAY")
    self.ReadyCheck:SetPoint("TOP", self)
    self.ReadyCheck:SetSize(Qulight["raidframes"].leadersize, Qulight["raidframes"].leadersize)

	-- Raid Debuffs (big middle icon)
	local RaidDebuffs = CreateFrame("Frame", nil, self)
	RaidDebuffs:SetHeight(Qulight["raidframes"].aurasize)
	RaidDebuffs:SetWidth(Qulight["raidframes"].aurasize)
	RaidDebuffs:SetPoint("CENTER", self.Health, 0, 0)
	RaidDebuffs:SetFrameStrata(self.Health:GetFrameStrata())
	RaidDebuffs:SetFrameLevel(self.Health:GetFrameLevel() + 2)
			
	CreateShadowclassbar(RaidDebuffs)
			
	RaidDebuffs.icon = RaidDebuffs:CreateTexture(nil, "OVERLAY")
	RaidDebuffs.icon:SetTexCoord(.1,.9,.1,.9)
	RaidDebuffs.icon:SetPoint("TOPLEFT", 2, -2)
	RaidDebuffs.icon:SetPoint("BOTTOMRIGHT", -2, 2)
		
	RaidDebuffs.cd = CreateFrame("Cooldown", nil, RaidDebuffs)
	RaidDebuffs.cd:SetPoint("TOPLEFT", 2, -2)
	RaidDebuffs.cd:SetPoint("BOTTOMRIGHT", -2, 2)
	RaidDebuffs.cd.noOCC = true -- remove this line if you want cooldown number on it
		
	RaidDebuffs.count = RaidDebuffs:CreateFontString(nil, "OVERLAY")
	RaidDebuffs.count:SetFont(Qulight["media"].pxfont, Qulight["raidframes"].fontsize+4, Qulight["raidframes"].outline)
	RaidDebuffs.count:SetPoint("BOTTOMRIGHT", RaidDebuffs, "BOTTOMRIGHT", 0, 2)
	RaidDebuffs.count:SetTextColor(1, .9, 0)
						
	RaidDebuffs.time = RaidDebuffs:CreateFontString(nil, "OVERLAY")
	RaidDebuffs.time:SetFont(Qulight["media"].pxfont, Qulight["raidframes"].fontsize+4, Qulight["raidframes"].outline)
	RaidDebuffs.time:SetPoint("CENTER")
	RaidDebuffs.time:SetTextColor(1, .9, 0)
						
	self.RaidDebuffs = RaidDebuffs
		
    -- Add events
    self:RegisterEvent('PLAYER_FOCUS_CHANGED', FocusTarget)
    self:RegisterEvent('RAID_ROSTER_UPDATE', FocusTarget)
    self:RegisterEvent('PLAYER_TARGET_CHANGED', ChangedTarget)
    self:RegisterEvent('RAID_ROSTER_UPDATE', ChangedTarget)

    self:SetScale(Qulight["raidframes"].scale)

    table.insert(ns._Objects, self)
end

oUF:RegisterStyle("Freebgrid", style)

function ns:Colors()
    for class, color in next, colors.class do
        if Qulight["raidframes"].reversecolors then
            ns.colorCache[class] = "|cffFFFFFF"
        else
            ns.colorCache[class] = ns:hex(color)
        end
    end

    for dtype, color in next, DebuffTypeColor do
        ns.debuffColor[dtype] = ns:hex(color)
    end
end

local pos, posRel, colX, colY
local function freebHeader(name, group, temp, pet, MT)
    local horiz, grow = Qulight["raidframes"].horizontal, Qulight["raidframes"].growth
    local numUnits = Qulight["raidframes"].multi and 5 or Qulight["raidframes"].numUnits

    local initconfig = [[
    self:SetWidth(%d)
    self:SetHeight(%d)
    ]]

    local point, growth, xoff, yoff
    if horiz then
        point = "LEFT"
        xoff = Qulight["raidframes"].spacing
        yoff = 0
        
            growth = "BOTTOM"
            pos = "BOTTOMLEFT"
            posRel = "TOPLEFT"
            colY = Qulight["raidframes"].spacing
        
    else
        point = "TOP"
        xoff = 0
        yoff = -Qulight["raidframes"].spacing
        if grow == "RIGHT" then
            growth = "LEFT"
            pos = "TOPLEFT"
            posRel = "TOPRIGHT"
            colX = Qulight["raidframes"].spacing
        else
            growth = "RIGHT"
            pos = "TOPRIGHT"
            posRel = "TOPLEFT"
            colX = -Qulight["raidframes"].spacing
        end
    end

    local sort, groupBy, groupOrder = "INDEX", "GROUP", "1,2,3,4,5,6,7,8"
    if not pet and not MT then
        if Qulight["raidframes"].sortName then
            sort = "NAME"
            groupBy = nil
        end

        if Qulight["raidframes"].sortClass then
            groupBy = "CLASS"
            groupOrder = Qulight["raidframes"].classOrder
            group = Qulight["raidframes"].classOrder
        end
    end

    local template = temp or nil
    local header = oUF:SpawnHeader(name, template, 'raid,party,solo',
    'oUF-initialConfigFunction', (initconfig):format(Qulight["raidframes"].width, Qulight["raidframes"].height),
    'showPlayer', Qulight["raidframes"].player,
    'showSolo', Qulight["raidframes"].solo,
    'showParty', Qulight["raidframes"].party,
    'showRaid', true,
    'xOffset', xoff,
    'yOffset', yoff,
    'point', point,
    'sortMethod', sort,
    'groupFilter', group,
    'groupingOrder', groupOrder,
    'groupBy', groupBy,
    'maxColumns', Qulight["raidframes"].numCol,
    'unitsPerColumn', numUnits,
    'columnSpacing', Qulight["raidframes"].spacing,
    'columnAnchorPoint', "BOTTOM")

    return header
end

oUF:Factory(function(self)
    ns:Colors()
	
	CompactRaidFrameManager:UnregisterAllEvents()
	CompactRaidFrameManager.Show = dummy
	CompactRaidFrameManager:Hide()

	CompactRaidFrameContainer:UnregisterAllEvents()
	CompactRaidFrameContainer.Show = dummy
	CompactRaidFrameContainer:Hide()
	
	if Qulight["raidframes"].enable then
		self:SetActiveStyle"Freebgrid"
		if Qulight["raidframes"].multi then
			local raid = {}
			for i=1, Qulight["raidframes"].numCol do
				local group = freebHeader("Raid_Freebgrid"..i, i)
				if i == 1 then
					group:SetPoint("BOTTOM", Anchorraid)
				else
					group:SetPoint(pos, raid[i-1], posRel, colX or 0, colY or 0)
				end
				raid[i] = group
				ns._Headers[group:GetName()] = group
			end
		else
			local raid = freebHeader("Raid_Freebgrid")
			raid:SetPoint("TOPLEFT", Anchorraid)
			ns._Headers[raid:GetName()] = raid
		end
	end
	
end)