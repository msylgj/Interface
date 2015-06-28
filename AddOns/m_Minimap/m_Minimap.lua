-- Config
local Scale = 1.24		-- Minimap缩放
local ClassColorBorder = false	-- Should border around minimap be classcolored? Enabling it disables color settings below
local r, g, b, a = 0.0, 0.0, 0.0, .7	-- Border colors and alhpa. More info: http://www.wowwiki.com/API_Frame_SetBackdropColor
local BGThickness = 1           -- Border thickness in pixels
local MapPosition = {"BOTTOMRIGHT", "UIParent", "BOTTOMRIGHT", -24, 16} ----Minimap位置
local zoneTextYOffset = 10		-- Zone text position
-- Shape, location and scale
function GetMinimapShape() return "SQUARE" end
Minimap:ClearAllPoints()
Minimap:SetPoint(MapPosition[1], MapPosition[2], MapPosition[3], MapPosition[4] / Scale, MapPosition[5] / Scale)
MinimapCluster:SetScale(Scale)
Minimap:SetFrameLevel(10)

-- Mask texture hint => addon will work with Carbonite
local hint = CreateFrame("Frame")
local total = 0
local SetTextureTrick = function(self, elapsed)
    total = total + elapsed
    if(total > 2) then
        Minimap:SetMaskTexture("Interface\\Buttons\\WHITE8X8")
        hint:SetScript("OnUpdate", nil)
    end
end

hint:RegisterEvent("PLAYER_LOGIN")
hint:SetScript("OnEvent", function()
    hint:SetScript("OnUpdate", SetTextureTrick)
end)

-- Background
Minimap:SetBackdrop({bgFile = "Interface\\ChatFrame\\ChatFrameBackground", insets = {
    top = -BGThickness / Scale,
    left = -BGThickness / Scale,
    bottom = -BGThickness / Scale,
    right = -BGThickness / Scale
}})
if(ClassColorBorder==true) then
    local _, class = UnitClass("player")
    local t = RAID_CLASS_COLORS[class]
    Minimap:SetBackdropColor(t.r, t.g, t.b, a)
else
    Minimap:SetBackdropColor(r, g, b, a)
end

-- Mousewheel zoom
Minimap:EnableMouseWheel(true)
Minimap:SetScript("OnMouseWheel", function(_, zoom)
    if zoom > 0 then
        Minimap_ZoomIn()
    else
        Minimap_ZoomOut()
    end
end)

-- Hiding ugly things
local dummy = function() end
local _G = getfenv(0)

local frames = {
    "GameTimeFrame",
    "MinimapBorderTop",
    "MinimapNorthTag",
    "MinimapBorder",
    "MinimapZoneTextButton",
    "MinimapZoomOut",
    "MinimapZoomIn",
    "MiniMapVoiceChatFrame",
    "MiniMapWorldMapButton",
    "MiniMapMailBorder",
	"GarrisonLandingPageMinimapButton",
}

for i in pairs(frames) do
    _G[frames[i]]:Hide()
    _G[frames[i]].Show = dummy
end
MinimapCluster:EnableMouse(false)

-- Tracking
MiniMapTrackingBackground:SetAlpha(0)
MiniMapTrackingButton:SetAlpha(0)
MiniMapTracking:ClearAllPoints()
MiniMapTracking:SetPoint("BOTTOMLEFT", Minimap, -5, -7)

-- LFG icon
QueueStatusMinimapButton:ClearAllPoints()
QueueStatusMinimapButton:SetPoint("TOP", Minimap, "TOP", 1, 8)
QueueStatusMinimapButtonBorder:Hide()

-- Instance Difficulty flag
MiniMapInstanceDifficulty:ClearAllPoints()
MiniMapInstanceDifficulty:SetPoint("TOPRIGHT", Minimap, "TOPRIGHT", 2, 2)
MiniMapInstanceDifficulty:SetScale(0.75)
MiniMapInstanceDifficulty:SetFrameStrata("LOW")

-- Guild Instance Difficulty flag
GuildInstanceDifficulty:ClearAllPoints()
GuildInstanceDifficulty:SetPoint("TOPRIGHT", Minimap, "TOPRIGHT", 2, 2)
GuildInstanceDifficulty:SetScale(0.75)
GuildInstanceDifficulty:SetFrameStrata("LOW")

-- Mail icon
MiniMapMailFrame:ClearAllPoints()
MiniMapMailFrame:SetPoint("BOTTOMRIGHT", Minimap, "BOTTOMRIGHT", 2, -6)
MiniMapMailIcon:SetTexture("Interface\\AddOns\\m_Minimap\\Mail")

-- Invites Icon
GameTimeCalendarInvitesTexture:ClearAllPoints()
GameTimeCalendarInvitesTexture:SetParent("Minimap")
GameTimeCalendarInvitesTexture:SetPoint("TOPRIGHT")

if FeedbackUIButton then
FeedbackUIButton:ClearAllPoints()
FeedbackUIButton:SetPoint("TOPLEFT", Minimap, "TOPLEFT", 6, -6)
FeedbackUIButton:SetScale(0.8)
end

if StreamingIcon then
StreamingIcon:ClearAllPoints()
StreamingIcon:SetPoint("TOPRIGHT", Minimap, "TOPRIGHT", 8, 8)
StreamingIcon:SetScale(0.8)
end
-- Creating right click menu
local menuFrame = CreateFrame("Frame", "m_MinimapRightClickMenu", UIParent, "UIDropDownMenuTemplate")
local menuList = {
    {text = CHARACTER_BUTTON,
    func = function() ToggleCharacter("PaperDollFrame") end},
    {text = SPELLBOOK_ABILITIES_BUTTON,
    func = function() ToggleSpellBook("spell") end},
    {text = TALENTS_BUTTON,
    func = function() ToggleTalentFrame() end},
    {text = ACHIEVEMENT_BUTTON,
    func = function() ToggleAchievementFrame() end},
    {text = QUESTLOG_BUTTON,
    func = function() ToggleFrame(WorldMapFrame) end},
    {text = IsInGuild() and GUILD or LOOKINGFORGUILD,
    func = function() ToggleGuildFrame(1) end},
	{text = PLAYER_V_PLAYER,
    func = function() TogglePVPUI() end},
    {text = DUNGEONS_BUTTON,
    func = function() PVEFrame_ToggleFrame() end},
    {text = ADVENTURE_JOURNAL,
    func = function() ToggleEncounterJournal() end},
    {text = COLLECTIONS,
    func = function() ToggleCollectionsJournal(1) end},
    {text = BLIZZARD_STORE,
    func = function() ToggleStoreUI() end},
    {text = FRIENDS,
    func = function() ToggleFriendsFrame(1) end},
    {text = GARRISON_LOCATION_TOOLTIP,
    func = function() GarrisonLandingPage_Toggle() end},
    {text = HELP_BUTTON,
    func = function() ToggleHelpFrame() end},
    {text = READY_CHECK,
    func = function() InitiateRolePoll() end},
    {text = CONVERT_TO_RAID,
    func = function() ConvertToRaid() end},
    {text = CONVERT_TO_PARTY,
    func = function() ConvertToParty() end},
}

-- Click func
Minimap:SetScript('OnMouseUp', function(self, button)
Minimap:StopMovingOrSizing()
    if(button=="MiddleButton") then
        ToggleCalendar()
    elseif(button=="RightButton") then
        EasyMenu(menuList, menuFrame, "cursor", 0, 0, "MENU", 2)
	elseif IsAltKeyDown() then
	    ToggleFrame(WorldMapFrame)
    else
		local x, y = GetCursorPosition()
		x = x / Minimap:GetEffectiveScale()
		y = y / Minimap:GetEffectiveScale()
		local cx, cy = Minimap:GetCenter()
		x = x - cx
		y = y - cy
		if ( sqrt(x * x + y * y) < (Minimap:GetWidth() / 2) ) then
			Minimap:PingLocation(x, y)
		end
		Minimap_SetPing(x, y, 1)
    end
end) 

-- Clock Hide
TimeManagerClockButton:Hide()
-- Zone text
local zoneTextFrame = CreateFrame("Frame", nil, UIParent)
zoneTextFrame:SetPoint("TOPLEFT", Minimap, "TOPLEFT", 0, zoneTextYOffset)
zoneTextFrame:SetPoint("TOPRIGHT", Minimap, "TOPRIGHT", 0, zoneTextYOffset)
zoneTextFrame:SetHeight(19)
zoneTextFrame:SetAlpha(0)
MinimapZoneText:SetParent(zoneTextFrame)
MinimapZoneText:ClearAllPoints()
MinimapZoneText:SetPoint("LEFT", 2, 1)
MinimapZoneText:SetPoint("RIGHT", -2, 1)
MinimapZoneText:SetFont("Fonts\\ARKai_T.ttf", 12, "THINOUTLINE")
Minimap:SetScript("OnEnter", function(self)
	UIFrameFadeIn(zoneTextFrame, 0.3, 0, 1)
end)
Minimap:SetScript("OnLeave", function(self)
	UIFrameFadeOut(zoneTextFrame, 0.3, 1, 0)
end)

--谁在点小地图
local ping = CreateFrame('ScrollingMessageFrame', nil, Minimap)
ping:SetHeight(10)
ping:SetWidth(100)
ping:SetPoint('BOTTOM', Minimap, 0, 20)

ping:SetFont(STANDARD_TEXT_FONT, 10, 'OUTLINE')
ping:SetJustifyH'CENTER'
ping:SetJustifyV'CENTER'
ping:SetMaxLines(1)
ping:SetFading(true)
ping:SetFadeDuration(3)
ping:SetTimeVisible(5)

ping:RegisterEvent'MINIMAP_PING'
ping:SetScript('OnEvent', function(self, event, u)
	local c = RAID_CLASS_COLORS[select(2,UnitClass(u))]
	local name = UnitName(u)
	local pname = UnitName("player")
    if(name ~= pname) then
		ping:AddMessage(name, c.r, c.g, c.b)
	end
end)