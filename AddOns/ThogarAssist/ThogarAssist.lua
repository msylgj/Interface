-----------------------------------------------------------------------
-- Locals
--
-- upvalues
local min = math.min
local pi = math.pi
local cos = math.cos
local sin = math.sin
local rad = math.rad
local GameTooltip = GameTooltip
local CreateFrame = CreateFrame
local GetPlayerMapPosition = GetPlayerMapPosition
local SetMapToCurrentZone = SetMapToCurrentZone
local type = type
local print = print
local UIParent = UIParent
local IsInInstance = IsInInstance
local GetRealZoneText = GetRealZoneText
local GetCurrentMapAreaID = GetCurrentMapAreaID
local GetPlayerFacing = GetPlayerFacing
local LibStub = LibStub
local InterfaceOptionsFrame_OpenToCategory = InterfaceOptionsFrame_OpenToCategory

local addon = CreateFrame("Frame")
local media = LibStub("LibSharedMedia-3.0")

local defaults = {
	profile = {
		font = "Friz Quadrata TT",
		font_size = 12,
		font_outline = true,
		posx = nil,
		posy = nil,
		lock = nil,
		debug_mode = false,
		width = 200,
		height = 160,
		myblipscale = 12,
		trainwarning = 5,
		trainsooncolor = {r=1,g=0,b=0},
		traintherecolor = {r=1,g=1,b=0},
		trainmovingcolor = {r=1,g=0.5,b=0},
		yourlanecolor = {r=0,g=0.5,b=1},
		highlightlane = true,
		lanenumbers = true,
		lanenumbers_position = 'leftinside',
		lanenumbers_inverse = false,
		laneraidicons = true,
		laneraidicons_position = 'leftoutside',
		laneraidicon1 = 'rt2',
		laneraidicon2 = 'rt3',
		laneraidicon3 = 'rt4',
		laneraidicon4 = 'rt5',
	}
}

local trainData = nil
local windowShown = nil
local range = 20
local myblip = nil
local trainCounter = 0
local combatStartedTime = 0
local timeInCombat = 0
local simulating = false
local inFight = false
local lanesUsed = {}
local trainDataNotCompleteMessageShown = false

local mapData = {2599.9990234375, 1733.3330078125}
-- /run local _,a,b,c,d = GetCurrentMapZone(); print(-c+a, -d+b)

-- trainData:
--   spawnTime: The time the train enters the area
--   departureTime: The time the train starts moving again
--   lane: 1 = boss spawn -> 4 = entrance
--   type: see below
--   length: 50 / 75 / 100 (percentage of lane covered)
--   stays: true if train waits until adds are killed
--   leftToRight: true if train is moving from left to right, false if moving from right to left
-- trainType:
--   1: just rushing through the lane
--   2: small Adds
--   3: cannon
--   4: big Adds (men at arms + firemender)
--   5: fire 
--   6: random gap (3x trainType 1)
--	{ ["spawnTime"] = , 	["departureTime"] = , 	["lane"] = , 	["type"] = , 	["length"] = , 	["stays"] = , 	["leftToRight"] = },
local trainDataPerDifficulty = {}

-- 14: Normal
trainDataPerDifficulty[14] = {
}

-- 15: Heroic
trainDataPerDifficulty[15] = {
	{ ["spawnTime"] = 18, 	["departureTime"] = 21, 	["lane"] = 4, 	["type"] = 1, 	["length"] = 100, 	["stays"] = false, 	["leftToRight"] = true },
	{ ["spawnTime"] = 27, 	["departureTime"] = 31, 	["lane"] = 2, 	["type"] = 1, 	["length"] = 100, 	["stays"] = false, 	["leftToRight"] = false },
	{ ["spawnTime"] = 32, 	["departureTime"] = 60, 	["lane"] = 1, 	["type"] = 2, 	["length"] = 75, 	["stays"] =  true, 	["leftToRight"] = false }, --departs when all adds are dead
	{ ["spawnTime"] = 48, 	["departureTime"] = 50, 	["lane"] = 3, 	["type"] = 1, 	["length"] = 100, 	["stays"] = false, 	["leftToRight"] = true },
	{ ["spawnTime"] = 52, 	["departureTime"] = 101, 	["lane"] = 4, 	["type"] = 3, 	["length"] = 100, 	["stays"] =  true, 	["leftToRight"] = true},
	{ ["spawnTime"] = 78, 	["departureTime"] = 81, 	["lane"] = 2, 	["type"] = 1, 	["length"] = 100, 	["stays"] = false, 	["leftToRight"] = false},
	{ ["spawnTime"] = 82, 	["departureTime"] = 93, 	["lane"] = 3, 	["type"] = 4, 	["length"] = 50, 	["stays"] = false, 	["leftToRight"] = true},
	{ ["spawnTime"] = 107, 	["departureTime"] = 110, 	["lane"] = 1, 	["type"] = 1, 	["length"] = 100, 	["stays"] = false, 	["leftToRight"] = false},
	{ ["spawnTime"] = 123, 	["departureTime"] = 155, 	["lane"] = 2, 	["type"] = 2, 	["length"] = 75, 	["stays"] =  true, 	["leftToRight"] = true},
	{ ["spawnTime"] = 123, 	["departureTime"] = 155, 	["lane"] = 3, 	["type"] = 2, 	["length"] = 75, 	["stays"] =  true, 	["leftToRight"] = false},
	{ ["spawnTime"] = 163, 	["departureTime"] = 166, 	["lane"] = 1, 	["type"] = 1, 	["length"] = 100 , 	["stays"] = false, 	["leftToRight"] = false},
	{ ["spawnTime"] = 163, 	["departureTime"] = 166, 	["lane"] = 4, 	["type"] = 1, 	["length"] = 100 , 	["stays"] = false, 	["leftToRight"] = true},
	{ ["spawnTime"] = 172, 	["departureTime"] = 220, 	["lane"] = 1, 	["type"] = 3, 	["length"] = 100, 	["stays"] =  true, 	["leftToRight"] = false},
	{ ["spawnTime"] = 182, 	["departureTime"] = 185, 	["lane"] = 2, 	["type"] = 1, 	["length"] = 100, 	["stays"] = false, 	["leftToRight"] = false},
	{ ["spawnTime"] = 198, 	["departureTime"] = 202, 	["lane"] = 2, 	["type"] = 1, 	["length"] = 100, 	["stays"] = false, 	["leftToRight"] = false},
	{ ["spawnTime"] = 198, 	["departureTime"] = 221, 	["lane"] = 4, 	["type"] = 2, 	["length"] = 100, 	["stays"] =  true, 	["leftToRight"] = true}, --departs when all adds are dead
	{ ["spawnTime"] = 218, 	["departureTime"] = 222, 	["lane"] = 3, 	["type"] = 1, 	["length"] = 100, 	["stays"] = false, 	["leftToRight"] = false},
	{ ["spawnTime"] = 227, 	["departureTime"] = 231, 	["lane"] = 2, 	["type"] = 1, 	["length"] = 100, 	["stays"] = false, 	["leftToRight"] = false},
	{ ["spawnTime"] = 238, 	["departureTime"] = 241 , 	["lane"] = 1, 	["type"] = 1, 	["length"] = 100, 	["stays"] = false, 	["leftToRight"] = false},
	{ ["spawnTime"] = 252, 	["departureTime"] = 264, 	["lane"] = 2, 	["type"] = 4, 	["length"] = 50, 	["stays"] =  true, 	["leftToRight"] = true},
	{ ["spawnTime"] = 252, 	["departureTime"] = 298, 	["lane"] = 4, 	["type"] = 3, 	["length"] = 100, 	["stays"] =  true, 	["leftToRight"] = true},
	{ ["spawnTime"] = 273, 	["departureTime"] = 276, 	["lane"] = 1, 	["type"] = 1, 	["length"] = 100, 	["stays"] = false, 	["leftToRight"] = false},
	{ ["spawnTime"] = 279, 	["departureTime"] = 282, 	["lane"] = 3, 	["type"] = 1, 	["length"] = 100, 	["stays"] = false, 	["leftToRight"] = false},
	{ ["spawnTime"] = 308, 	["departureTime"] = 356, 	["lane"] = 1, 	["type"] = 3, 	["length"] = 100, 	["stays"] =  true, 	["leftToRight"] = false}, 
	{ ["spawnTime"] = 308, 	["departureTime"] = 356, 	["lane"] = 4, 	["type"] = 3, 	["length"] = 100, 	["stays"] =  true, 	["leftToRight"] = true}, 
	{ ["spawnTime"] = 318, 	["departureTime"] = 320, 	["lane"] = 2, 	["type"] = 1, 	["length"] = 100, 	["stays"] = false, 	["leftToRight"] = false},
	{ ["spawnTime"] = 343, 	["departureTime"] = 346, 	["lane"] = 2, 	["type"] = 1, 	["length"] = 100, 	["stays"] = false, 	["leftToRight"] = false},
	{ ["spawnTime"] = 374, 	["departureTime"] = 395, 	["lane"] = 2, 	["type"] = 2, 	["length"] = 75, 	["stays"] =  true, 	["leftToRight"] = true},
	{ ["spawnTime"] = 374, 	["departureTime"] = 385, 	["lane"] = 3, 	["type"] = 4, 	["length"] = 50, 	["stays"] =  true, 	["leftToRight"] = false}, -- departureTime estimated
	{ ["spawnTime"] = 388, 	["departureTime"] = 391, 	["lane"] = 3, 	["type"] = 1, 	["length"] = 100, 	["stays"] = false, 	["leftToRight"] = false}, -- departureTime unknown
}
trainDataPerDifficulty[14] = trainDataPerDifficulty[15] -- TODO normal may be the same as heroic

-- 16: Mythic
trainDataPerDifficulty[16] = {
	{ ["spawnTime"] = 12, 	["departureTime"] = 23, 	["lane"] = 4, 	["type"] = 4, 	["length"] = 50, 	["stays"] = false, 	["leftToRight"] = true},
	{ ["spawnTime"] = 18, 	["departureTime"] = 46, 	["lane"] = 1, 	["type"] = 5, 	["length"] = 100, 	["stays"] = false, 	["leftToRight"] = false},
	{ ["spawnTime"] = 23, 	["departureTime"] = 26, 	["lane"] = 2, 	["type"] = 1, 	["length"] = 100, 	["stays"] = false, 	["leftToRight"] = false},
	{ ["spawnTime"] = 38, 	["departureTime"] = 41, 	["lane"] = 3, 	["type"] = 1, 	["length"] = 100, 	["stays"] = false, 	["leftToRight"] = false},
	{ ["spawnTime"] = 62, 	["departureTime"] = 65, 	["lane"] = 1, 	["type"] = 6, 	["length"] = 100, 	["stays"] = false, 	["leftToRight"] = true},
	{ ["spawnTime"] = 62, 	["departureTime"] = 65, 	["lane"] = 2, 	["type"] = 6, 	["length"] = 100, 	["stays"] = false, 	["leftToRight"] = true},
	{ ["spawnTime"] = 62, 	["departureTime"] = 65, 	["lane"] = 3, 	["type"] = 6, 	["length"] = 100, 	["stays"] = false, 	["leftToRight"] = true},
	{ ["spawnTime"] = 62, 	["departureTime"] = 65, 	["lane"] = 4, 	["type"] = 6, 	["length"] = 100, 	["stays"] = false, 	["leftToRight"] = true},
	{ ["spawnTime"] = 78, 	["departureTime"] = 125, 	["lane"] = 1, 	["type"] = 3, 	["length"] = 100, 	["stays"] = true, 	["leftToRight"] = false},
	{ ["spawnTime"] = 78, 	["departureTime"] = 125, 	["lane"] = 4, 	["type"] = 3, 	["length"] = 100, 	["stays"] = true, 	["leftToRight"] = true},
	{ ["spawnTime"] = 83, 	["departureTime"] = 86, 	["lane"] = 2, 	["type"] = 1, 	["length"] = 100, 	["stays"] = false, 	["leftToRight"] = false},
	{ ["spawnTime"] = 98, 	["departureTime"] = 101, 	["lane"] = 3, 	["type"] = 1, 	["length"] = 100, 	["stays"] = false, 	["leftToRight"] = false},
	{ ["spawnTime"] = 113, 	["departureTime"] = 116, 	["lane"] = 2, 	["type"] = 1, 	["length"] = 100, 	["stays"] = false, 	["leftToRight"] = false},
	{ ["spawnTime"] = 133, 	["departureTime"] = 155, 	["lane"] = 2, 	["type"] = 2, 	["length"] = 100, 	["stays"] = true, 	["leftToRight"] = true}, -- adds need to be killed
	{ ["spawnTime"] = 133, 	["departureTime"] = 155, 	["lane"] = 3, 	["type"] = 2, 	["length"] = 100, 	["stays"] = true, 	["leftToRight"] = false}, -- adds need to be killed
	{ ["spawnTime"] = 158, 	["departureTime"] = 161, 	["lane"] = 4, 	["type"] = 1, 	["length"] = 100, 	["stays"] = false, 	["leftToRight"] = true},
	{ ["spawnTime"] = 158, 	["departureTime"] = 161, 	["lane"] = 1, 	["type"] = 1, 	["length"] = 100, 	["stays"] = false, 	["leftToRight"] = false},
	{ ["spawnTime"] = 173, 	["departureTime"] = 176, 	["lane"] = 1, 	["type"] = 6, 	["length"] = 100, 	["stays"] = false, 	["leftToRight"] = false},
	{ ["spawnTime"] = 173, 	["departureTime"] = 176, 	["lane"] = 2, 	["type"] = 6, 	["length"] = 100, 	["stays"] = false, 	["leftToRight"] = false},
	{ ["spawnTime"] = 173, 	["departureTime"] = 176, 	["lane"] = 3, 	["type"] = 6, 	["length"] = 100, 	["stays"] = false, 	["leftToRight"] = false},
	{ ["spawnTime"] = 173, 	["departureTime"] = 176, 	["lane"] = 4, 	["type"] = 6, 	["length"] = 100, 	["stays"] = false, 	["leftToRight"] = false},
	{ ["spawnTime"] = 194, 	["departureTime"] = 197, 	["lane"] = 1, 	["type"] = 6, 	["length"] = 100, 	["stays"] = false, 	["leftToRight"] = false},
	{ ["spawnTime"] = 194, 	["departureTime"] = 197, 	["lane"] = 2, 	["type"] = 6, 	["length"] = 100, 	["stays"] = false, 	["leftToRight"] = false},
	{ ["spawnTime"] = 194, 	["departureTime"] = 197, 	["lane"] = 3, 	["type"] = 6, 	["length"] = 100, 	["stays"] = false, 	["leftToRight"] = false},
	{ ["spawnTime"] = 194, 	["departureTime"] = 197, 	["lane"] = 4, 	["type"] = 6, 	["length"] = 100, 	["stays"] = false, 	["leftToRight"] = false},
}

-- 17: LFR
trainDataPerDifficulty[17] = {
}
trainDataPerDifficulty[17] = trainDataPerDifficulty[15] -- TODO lfr may be the same as heroic

local texTrainLength={
	["l50"] = "Interface\\AddOns\\ThogarAssist\\Textures\\train_left_50.tga",
	["l75"] = "Interface\\AddOns\\ThogarAssist\\Textures\\train_left_75.tga",
	["l100"] = "Interface\\AddOns\\ThogarAssist\\Textures\\train_left_100.tga",
	["r50"] = "Interface\\AddOns\\ThogarAssist\\Textures\\train_right_50.tga",
	["r75"] = "Interface\\AddOns\\ThogarAssist\\Textures\\train_right_75.tga",
	["r100"] = "Interface\\AddOns\\ThogarAssist\\Textures\\train_right_100.tga"
}

local texTrainTypes={
	["type1"] = "Interface\\AddOns\\ThogarAssist\\Textures\\adds_train.tga",
	["type2"] = "Interface\\AddOns\\ThogarAssist\\Textures\\adds_small.tga",
	["type3"] = "Interface\\AddOns\\ThogarAssist\\Textures\\adds_cannon.tga",
	["type4"] = "Interface\\AddOns\\ThogarAssist\\Textures\\adds_big.tga",
	["type5"] = "Interface\\AddOns\\ThogarAssist\\Textures\\adds_fire.tga",
	["type6"] = "Interface\\AddOns\\ThogarAssist\\Textures\\adds_randomtrain.tga",
}

local texRaidIconCoords={
	["rt1"] = {0,.25,0,.25},
	["rt2"] = {.25,.5,0,.25},
	["rt3"] = {.5,.75,0,.25},
	["rt4"] = {.75,1,0,.25},
	["rt5"] = {0,.25,.25,.5},
	["rt6"] = {.25,.5,.25,.5},
	["rt7"] = {.5,.75,.25,.5},
	["rt8"] = {.75,1,.25,.5},
}

local display = nil

local unlock = "Interface\\AddOns\\ThogarAssist\\Textures\\icons\\lock"
local lock = "Interface\\AddOns\\ThogarAssist\\Textures\\icons\\un_lock"

local window = nil

local L = LibStub("AceLocale-3.0"):GetLocale("ThogarAssist")


local function updateDisplay()
	local width, height = display:GetWidth(), display:GetHeight()
	local ppy = min(width, height)
	display.lanegird:SetSize(ppy, ppy)
	
	local laneX = "lane%d"
	for i=1, 4 do
		display[laneX:format(i)]:SetSize((ppy), ppy * 0.25) -- 1/4 per lane
		display[laneX:format(i).."icon"]:SetSize(32*(ppy/(range*2))/2, 16*(ppy/(range*2))/2) -- 1/4 per lane
	end
	display["lane1"]:SetPoint("CENTER", 0, (ppy) / 8 * 3)
	display["lane2"]:SetPoint("CENTER", 0, (ppy) / 8)
	display["lane3"]:SetPoint("CENTER", 0, -(ppy) / 8)
	display["lane4"]:SetPoint("CENTER", 0, -(ppy) / 8 * 3)
	
	display["lane1highlight"]:SetAllPoints(display["lane1"])
	display["lane2highlight"]:SetAllPoints(display["lane2"])
	display["lane3highlight"]:SetAllPoints(display["lane3"])
	display["lane4highlight"]:SetAllPoints(display["lane4"])
	
	
	local laneX = "lane%dhighlight"
	for i=1, 4 do
		display[laneX:format(i)]:SetTexture(addon.db.profile.yourlanecolor.r,addon.db.profile.yourlanecolor.g,addon.db.profile.yourlanecolor.b,0.75)
	end
	
	if not addon.db.profile.highlightlane then
		for i = 1,4 do
			display["lane"..i.."highlight"]:SetAlpha(0)
		end
	end
	
	display["lane1icon"]:SetPoint("CENTER", 0, (ppy) / 8 * 3)
	display["lane2icon"]:SetPoint("CENTER", 0, (ppy) / 8)
	display["lane3icon"]:SetPoint("CENTER", 0, -(ppy) / 8)
	display["lane4icon"]:SetPoint("CENTER", 0, -(ppy) / 8 * 3)
	
	if addon.db.profile.lanenumbers then
		for i = 1,4 do
			display.lanenumber[i]:Show()
		end
	else
		for i = 1,4 do
			display.lanenumber[i]:Hide()
		end
	end
	
	local lanenumber_anchor, lanenumber_xoffset, lanenumber_multi
	if addon.db.profile.lanenumbers_position == 'leftinside' then
		lanenumber_anchor = "LEFT"
		lanenumber_xoffset = 9
		lanenumber_multi = 1
	elseif addon.db.profile.lanenumbers_position ==  'leftoutside' then
		lanenumber_anchor = "LEFT"
		lanenumber_xoffset = -5
		lanenumber_multi = 1
	elseif addon.db.profile.lanenumbers_position ==  'rightinside' then
		lanenumber_anchor = "RIGHT"
		lanenumber_xoffset = -7
		lanenumber_multi = -1
	else -- rightoutside
		lanenumber_anchor = "RIGHT"
		lanenumber_xoffset = 7
		lanenumber_multi = -1
	end
	display.lanenumber[1]:SetPoint("CENTER", display, lanenumber_anchor, (width-ppy)/2*lanenumber_multi+lanenumber_xoffset, (ppy) / 8 * 3)
	display.lanenumber[2]:SetPoint("CENTER", display, lanenumber_anchor, (width-ppy)/2*lanenumber_multi+lanenumber_xoffset, (ppy) / 8)
	display.lanenumber[3]:SetPoint("CENTER", display, lanenumber_anchor, (width-ppy)/2*lanenumber_multi+lanenumber_xoffset, -(ppy) / 8)
	display.lanenumber[4]:SetPoint("CENTER", display, lanenumber_anchor, (width-ppy)/2*lanenumber_multi+lanenumber_xoffset, -(ppy) / 8 * 3)
	if addon.db.profile.lanenumbers_inverse then 
		for i = 1,4 do
			display.lanenumber[i]:SetText(5-i)
		end
	else
		for i = 1,4 do
			display.lanenumber[i]:SetText(i)
		end
	end
	
	
	
	if addon.db.profile.laneraidicons then
		for i = 1,4 do
			display["lane"..i.."raidicon"]:SetAlpha(1)
		end
	else
		for i = 1,4 do
			display["lane"..i.."raidicon"]:SetAlpha(0)
		end
	end
	
	local laneraidicon_anchor, laneraidicon_xoffset, laneraidicon_multi
	if addon.db.profile.laneraidicons_position == 'leftinside' then
		laneraidicon_anchor = "LEFT"
		laneraidicon_xoffset = 13
		laneraidicon_multi = 1
		if addon.db.profile.lanenumbers and addon.db.profile.laneraidicons and addon.db.profile.lanenumbers_position == addon.db.profile.laneraidicons_position then
			laneraidicon_xoffset = laneraidicon_xoffset + 10
		end
	elseif addon.db.profile.laneraidicons_position ==  'leftoutside' then
		laneraidicon_anchor = "LEFT"
		laneraidicon_xoffset = -10
		laneraidicon_multi = 1
		if addon.db.profile.lanenumbers and addon.db.profile.laneraidicons and addon.db.profile.lanenumbers_position == addon.db.profile.laneraidicons_position then
			laneraidicon_xoffset = laneraidicon_xoffset - 10
		end
	elseif addon.db.profile.laneraidicons_position ==  'rightinside' then
		laneraidicon_anchor = "RIGHT"
		laneraidicon_xoffset = -13
		laneraidicon_multi = -1
		if addon.db.profile.lanenumbers and addon.db.profile.laneraidicons and addon.db.profile.lanenumbers_position == addon.db.profile.laneraidicons_position then
			laneraidicon_xoffset = laneraidicon_xoffset - 13
		end
	else -- rightoutside
		laneraidicon_anchor = "RIGHT"
		laneraidicon_xoffset = 10
		laneraidicon_multi = -1
		if addon.db.profile.lanenumbers and addon.db.profile.laneraidicons and addon.db.profile.lanenumbers_position == addon.db.profile.laneraidicons_position then
			laneraidicon_xoffset = laneraidicon_xoffset + 10
		end
	end
	display["lane1raidicon"]:SetPoint("CENTER", display, laneraidicon_anchor, (width-ppy)/2*laneraidicon_multi+laneraidicon_xoffset, (ppy) / 8 * 3)
	display["lane2raidicon"]:SetPoint("CENTER", display, laneraidicon_anchor, (width-ppy)/2*laneraidicon_multi+laneraidicon_xoffset, (ppy) / 8)
	display["lane3raidicon"]:SetPoint("CENTER", display, laneraidicon_anchor, (width-ppy)/2*laneraidicon_multi+laneraidicon_xoffset, -(ppy) / 8)
	display["lane4raidicon"]:SetPoint("CENTER", display, laneraidicon_anchor, (width-ppy)/2*laneraidicon_multi+laneraidicon_xoffset, -(ppy) / 8 * 3)

	for i=1,4 do
		display["lane"..i.."raidicon"]:SetSize(20,20)
	end
	
	if addon.db.profile.lanenumbers_inverse then 
		display["lane1raidicon"]:SetTexCoord(unpack(texRaidIconCoords[addon.db.profile.laneraidicon4]));
		display["lane2raidicon"]:SetTexCoord(unpack(texRaidIconCoords[addon.db.profile.laneraidicon3]));
		display["lane3raidicon"]:SetTexCoord(unpack(texRaidIconCoords[addon.db.profile.laneraidicon2]));
		display["lane4raidicon"]:SetTexCoord(unpack(texRaidIconCoords[addon.db.profile.laneraidicon1]));
	else
		display["lane1raidicon"]:SetTexCoord(unpack(texRaidIconCoords[addon.db.profile.laneraidicon1]));
		display["lane2raidicon"]:SetTexCoord(unpack(texRaidIconCoords[addon.db.profile.laneraidicon2]));
		display["lane3raidicon"]:SetTexCoord(unpack(texRaidIconCoords[addon.db.profile.laneraidicon3]));
		display["lane4raidicon"]:SetTexCoord(unpack(texRaidIconCoords[addon.db.profile.laneraidicon4]));
	end
	
	-- fonts
	for i=1,4 do
		display.lanenumber[i]:SetFont(media:Fetch("font", addon.db.profile.font) or STANDARD_TEXT_FONT, addon.db.profile.font_size or 12, addon.db.profile.font_outline and "OUTLINE" or "")
	end
	display.header:SetFont(media:Fetch("font", addon.db.profile.font) or STANDARD_TEXT_FONT, addon.db.profile.font_size or 12, addon.db.profile.font_outline and "OUTLINE" or "")
	display.tic:SetFont(media:Fetch("font", addon.db.profile.font) or STANDARD_TEXT_FONT, addon.db.profile.font_size or 12, addon.db.profile.font_outline and "OUTLINE" or "")
	if addon.db.profile.debug_mode then
		display.tic:Show()
	else
		display.tic:Hide()
	end
end

local function onDragStart(self) self:StartMoving() end
local function onDragStop(self)
	self:StopMovingOrSizing()
	local s = self:GetEffectiveScale()
	addon.db.profile.posx = self:GetLeft() * s
	addon.db.profile.posy = self:GetTop() * s
end
local function OnDragHandleMouseDown(self) self.frame:StartSizing("BOTTOMRIGHT") end
local function OnDragHandleMouseUp(self) self.frame:StopMovingOrSizing() end
local function onResize(self, width, height)
	addon.db.profile.width = width
	addon.db.profile.height = height
	updateDisplay()
end

local locked = nil
local function lockDisplay()
	if locked then return end
	window:EnableMouse(false)
	window:SetMovable(false)
	window:SetResizable(false)
	window:RegisterForDrag()
	window:SetScript("OnSizeChanged", nil)
	window:SetScript("OnDragStart", nil)
	window:SetScript("OnDragStop", nil)
	window.drag:Hide()
	locked = true
end

local function unlockDisplay()
	if not locked then return end
	window:EnableMouse(true)
	window:SetMovable(true)
	window:SetResizable(true)
	window:RegisterForDrag("LeftButton")
	window:SetScript("OnSizeChanged", onResize)
	window:SetScript("OnDragStart", onDragStart)
	window:SetScript("OnDragStop", onDragStop)
	window.drag:Show()
	locked = nil
end

local function updateLockButton()
	if not window then return end
	window.lock:SetNormalTexture(addon.db.profile.lock and unlock or lock)
end

local function toggleLock()
	if addon.db.profile.lock then
		unlockDisplay()
	else
		lockDisplay()
	end
	addon.db.profile.lock = not addon.db.profile.lock
	updateLockButton()
end

local function onControlEnter(self)
	GameTooltip:ClearLines()
	GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT")
	GameTooltip:AddLine(self.tooltipHeader)
	GameTooltip:AddLine(self.tooltipText, 1, 1, 1, 1)
	GameTooltip:Show()
end
local function onControlLeave() GameTooltip:Hide() end
local function closeWindow() 
	if window then 
		window:Hide() 
		windowShown = false 
	end 
	if addon then 
		addon:Hide() 
	end 
end

local function ensureDisplay()
	if window then return end
	display = CreateFrame("Frame", "ThogarAssistAnchor", UIParent)
	display:SetWidth(addon.db.profile.width)
	display:SetHeight(addon.db.profile.height)
	display:SetMinResize(100, 100)
	display:SetClampedToScreen(true)
	local bg = display:CreateTexture(nil, "PARENT")
	bg:SetAllPoints(display)
	bg:SetBlendMode("BLEND")
	bg:SetTexture(0, 0, 0, 0.3)

	local close = CreateFrame("Button", nil, display)
	close:SetPoint("BOTTOMRIGHT", display, "TOPRIGHT", -2, 2)
	close:SetHeight(16)
	close:SetWidth(16)
	close.tooltipHeader = L["Close"]
	close.tooltipText = L["Closes the Thogar Assist Window."]
	close:SetNormalTexture("Interface\\AddOns\\ThogarAssist\\Textures\\icons\\close")
	close:SetScript("OnEnter", onControlEnter)
	close:SetScript("OnLeave", onControlLeave)
	close:SetScript("OnClick", closeWindow)

	local lock = CreateFrame("Button", nil, display)
	lock:SetPoint("BOTTOMLEFT", display, "TOPLEFT", 2, 2)
	lock:SetHeight(16)
	lock:SetWidth(16)
	lock.tooltipHeader = L["Toggle lock"]
	lock.tooltipText = L["Toggle whether or not the Thogar Assist window should be locked or not."]
	lock:SetScript("OnEnter", onControlEnter)
	lock:SetScript("OnLeave", onControlLeave)
	lock:SetScript("OnClick", toggleLock)
	display.lock = lock

	local settings = CreateFrame("Button", nil, display)
	settings:SetPoint("BOTTOMLEFT", display, "TOPLEFT", 18, 2)
	settings:SetHeight(16)
	settings:SetWidth(16)
	settings.tooltipHeader = L["Show settings"]
	settings.tooltipText = L["Open the interface settings dialog"]
	settings:SetNormalTexture("Interface\\AddOns\\ThogarAssist\\Textures\\icons\\settings")
	settings:SetScript("OnEnter", onControlEnter)
	settings:SetScript("OnLeave", onControlLeave)
	settings:SetScript("OnClick", function() InterfaceOptionsFrame_OpenToCategory("Thogar Assist") InterfaceOptionsFrame_OpenToCategory("Thogar Assist") end)

	local header = display:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	header:SetText("Thogar Assist")
	header:SetPoint("BOTTOM", display, "TOP", 0, 4)
	display.header = header
	
	local lanegird = display:CreateTexture(nil, "OVERLAY")
	lanegird:SetPoint("CENTER")
	lanegird:SetTexture([[Interface\AddOns\ThogarAssist\Textures\lanes.tga]])
	lanegird:SetBlendMode("ADD")
	display.lanegird = lanegird
	display.lanegird:SetAlpha(1)
	
	local laneX = "lane%d"
	for i=1, 4 do
		display[laneX:format(i)] = display:CreateTexture(nil, "OVERLAY")
		display[laneX:format(i)]:SetDrawLayer("OVERLAY", 2)
		display[laneX:format(i)]:SetTexture(i%2==0 and texTrainLength.r100 or texTrainLength.l100)
		display[laneX:format(i)]:SetBlendMode("ADD")
		display[laneX:format(i)]:SetAlpha(0.5)
	end
	
	laneX = "lane%dhighlight"
	for i=1, 4 do
		display[laneX:format(i)] = display:CreateTexture(nil, "OVERLAY")
		display[laneX:format(i)]:SetDrawLayer("OVERLAY", 1)
		display[laneX:format(i)]:SetTexture(0,0.5,1,0.75)
		display[laneX:format(i)]:SetBlendMode("BLEND")
		display[laneX:format(i)]:SetAlpha(0)
	end
	
	local laneXicon = "lane%dicon"
	for i=1, 4 do
		display[laneXicon:format(i)] = display:CreateTexture(nil, "OVERLAY", nil, 3)
		display[laneXicon:format(i)]:SetTexture(texTrainTypes.type6)
	end
	
	local drag = CreateFrame("Frame", nil, display)
	drag.frame = display
	drag:SetFrameLevel(display:GetFrameLevel() + 10) -- place this above everything
	drag:SetWidth(16)
	drag:SetHeight(16)
	drag:SetPoint("BOTTOMRIGHT", display, -1, 1)
	drag:EnableMouse(true)
	drag:SetScript("OnMouseDown", OnDragHandleMouseDown)
	drag:SetScript("OnMouseUp", OnDragHandleMouseUp)
	drag:SetAlpha(0.5)
	display.drag = drag

	local tex = drag:CreateTexture(nil, "BACKGROUND")
	tex:SetTexture("Interface\\AddOns\\ThogarAssist\\Textures\\draghandle")
	tex:SetWidth(16)
	tex:SetHeight(16)
	tex:SetBlendMode("ADD")
	tex:SetPoint("CENTER", drag)
	
	local lanenumber = {}
	for i=1,4 do
		lanenumber[i] = display:CreateFontString(nil, "OVERLAY", "GameFontNormal")
		lanenumber[i]:SetTextColor(1,1,1,1)
		lanenumber[i]:SetText(i)
	end
	display.lanenumber = lanenumber
	
	laneX = "lane%draidicon"
	for i=1,4 do
		display[laneX:format(i)] = display:CreateTexture(nil, "OVERLAY")
		display[laneX:format(i)]:SetDrawLayer("OVERLAY", 4)
		display[laneX:format(i)]:SetTexture("Interface\\TARGETINGFRAME\\UI-RaidTargetingIcons.png")
		display[laneX:format(i)]:SetTexCoord(0,0.25,0,0.25)
		display[laneX:format(i)]:SetAlpha(1)
	end

	-- debug stuff
	local tic = display:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	tic:SetText("0s")
	tic:SetPoint("BOTTOMRIGHT", display, "BOTTOMRIGHT", 0, 0)
	display.tic = tic
	--[[
	local encounter_start_button = CreateFrame("Button", nil, display, "UIPanelButtonTemplate")
	encounter_start_button:SetPoint("BOTTOMLEFT", display, "BOTTOMRIGHT", 5, 0)
	encounter_start_button:SetText("esb")
	encounter_start_button:SetHeight(16)
	encounter_start_button:SetWidth(16)
	encounter_start_button:SetScript("OnClick", function() addon:ENCOUNTER_START("ENCOUNTER_START", 1692, "", 15, 20) end)
	--encounter_start_button:SetScript("OnClick", function() addon:ENCOUNTER_START("ENCOUNTER_START", 1692, "", 16, 20) end)
	--]]
	-- debug stuff end
	
	window = display

	local x = addon.db.profile.posx
	local y = addon.db.profile.posy
	if x and y then
		local s = display:GetEffectiveScale()
		display:ClearAllPoints()
		display:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", x / s, y / s)
	else
		display:ClearAllPoints()
		display:SetPoint("CENTER", UIParent)
	end

	updateLockButton()
	if addon.db.profile.lock then
		locked = nil
		lockDisplay()
	else
		locked = true
		unlockDisplay()
	end

	myblip = display:CreateTexture(nil, "OVERLAY", nil, 7)
	myblip:SetSize(56, 56) -- this gets changed on onupdate anyways
	myblip:SetTexture([[Interface\Minimap\MinimapArrow]])
	myblip:Hide()
end


local function displayTrainOnLane(lane, length, color, leftToRight, trainType)
	if not lane or not length then return end
	if lane < 1 or lane > 4 then return end
	if length ~= 0 and length ~= 50 and length ~= 75 and length ~= 100 then return end
	if length ~= 0 and (not color or not color.r or not color.g or not color.b) then return end
	if length == 0 then
		display["lane"..lane]:SetVertexColor(0,0,0,0)
		display["lane"..lane.."icon"]:SetVertexColor(0,0,0,0)
	else
		--print("displayTrainOnLane", lane, length, color, leftToRight) --debug
		if leftToRight then
			display["lane"..lane]:SetTexture(texTrainLength["r"..length])
		else
			display["lane"..lane]:SetTexture(texTrainLength["l"..length])
		end
		display["lane"..lane]:SetVertexColor(color.r,color.g,color.b,1)
		
		if trainType then
			display["lane"..lane.."icon"]:SetVertexColor(1,1,1,1)
			display["lane"..lane.."icon"]:SetTexture(texTrainTypes["type"..trainType])
			local point, relativeTo, relativePoint, xOffset, yOffset = display["lane"..lane.."icon"]:GetPoint(1)
			if leftToRight then
				xOffset =   display["lane"..lane.."icon"]:GetWidth()/16*(100-length)/5
			else
				xOffset = - display["lane"..lane.."icon"]:GetWidth()/16*(100-length)/5
			end
			display["lane"..lane.."icon"]:SetPoint(point, relativeTo, relativePoint, xOffset, yOffset)
		end
	end		
end

local function clearLane(lane)
	displayTrainOnLane(lane, 0)
end

local function clearAllTrains()
	for i=1,4 do
		displayTrainOnLane(i,0)		
	end
end

local function rotateTextureAroundCenterPoint(texture, hAngle)
	local s = sin(hAngle)
	local c = cos(hAngle)
	texture:SetTexCoord(
	0.5 - s, 0.5 + c,
	0.5 + c, 0.5 + s,
	0.5 - c, 0.5 - s,
	0.5 + s, 0.5 - c
	)
end

do
	-- dx and dy are in yards
	-- facing is radians with 0 being north, counting up clockwise
	local setDot = function(dx, dy, blip)
		local width, height = display:GetWidth(), display:GetHeight()
		--local range = activeRange and activeRange or 10
		-- range * 3, so we have 3x radius space
		
		local pixperyard = min(width, height) / (range * 3)


		blip:ClearAllPoints()

		local x = -min(width, height)/2 + dx*min(width, height)
		local y = -min(width, height)/2 + dy*min(width, height)
		blip:SetPoint("CENTER", display, "CENTER", x, -y)

		blip:SetSize(addon.db.profile.myblipscale*pixperyard, addon.db.profile.myblipscale*pixperyard)
		
		-- do some rotation
		local bearing = GetPlayerFacing()
		local hAngle = bearing - rad(225)

		rotateTextureAroundCenterPoint(blip, hAngle)
	end
	function addon:setMyDot(srcX, srcY)
		local roomX, roomY = 0.39309698343277, 0.18051677942276
		local roomWidth, roomHeight = 0.128162309583664, 0.19867861270905
		-- width: 0.521259293016434-0.39309698343277
		-- height: 0.37919539213181-0.18051677942276

		setDot((srcX-roomX)/roomWidth, (srcY-roomY)/roomHeight, myblip)
	end

	function addon:highlightMyLane(srcY)
		local roomY = 0.18051677942276
		local roomHeight = 0.19867861270905
		local value = (srcY-roomY)/roomHeight
		if value >= 0 and value < 0.25 then
			display["lane1highlight"]:SetAlpha(0.5)
			display["lane2highlight"]:SetAlpha(0)
			display["lane3highlight"]:SetAlpha(0)
			display["lane4highlight"]:SetAlpha(0)
		elseif value >= 0.25 and value < 0.5 then
			display["lane1highlight"]:SetAlpha(0)
			display["lane2highlight"]:SetAlpha(0.5)
			display["lane3highlight"]:SetAlpha(0)
			display["lane4highlight"]:SetAlpha(0)
		elseif value >= 0.5 and value < 0.75 then
			display["lane1highlight"]:SetAlpha(0)
			display["lane2highlight"]:SetAlpha(0)
			display["lane3highlight"]:SetAlpha(0.5)
			display["lane4highlight"]:SetAlpha(0)
		elseif value >= 0.75 and value <= 1 then
			display["lane1highlight"]:SetAlpha(0)
			display["lane2highlight"]:SetAlpha(0)
			display["lane3highlight"]:SetAlpha(0)
			display["lane4highlight"]:SetAlpha(0.5)
		end
	end
	
	
	function addon:updateData()
		if simulating or not inFight then return end
		
		local srcX, srcY = GetPlayerMapPosition("player")
		if srcX == 0 and srcY == 0 then
			SetMapToCurrentZone()
			srcX, srcY = GetPlayerMapPosition("player")
		end

		addon:setMyDot(srcX, srcY)
		
		if addon.db.profile.highlightlane then
			addon:highlightMyLane(srcY)
		end
			
		lanesUsed = {}
		timeInCombat = GetTime() - combatStartedTime
		window.tic:SetText(string.format("%.0fs", timeInCombat))
		for k,train in pairs(trainData) do
			--{ ["spawnTime"]=1, ["departureTime"] = 3, ["lane"] = 1, ["type"] = 2, ["length"] = 50, ["stays"] = false, ["leftToRight"] = true }
			if train.spawnTime-addon.db.profile.trainwarning < timeInCombat and train.departureTime > timeInCombat then --train is there or incoming soon
				if train.spawnTime < timeInCombat then --train is there
					if not train.trainDisplayed then
						if train.stays then
							displayTrainOnLane(train.lane, train.length, addon.db.profile.traintherecolor, train.leftToRight, train.type)
						else
							displayTrainOnLane(train.lane, train.length, addon.db.profile.trainmovingcolor, train.leftToRight, train.type)
						end
						trainData[k]["trainDisplayed"] = true
						addon:SendMessage("ThogarAssist_TrainIncoming",train.lane, train.type, train.leftToRight)
					end
				else --train is incoming soon
					if not train.warningDisplayed then
						displayTrainOnLane(train.lane, 100, addon.db.profile.trainsooncolor, train.leftToRight, train.type) -- you should not stand on a lane where a train is incoming
						trainData[k]["warningDisplayed"] = true
						addon:SendMessage("ThogarAssist_TrainIncomingSoon",train.lane, train.type, train.leftToRight)
					end
				end
				table.insert(lanesUsed, train.lane)
			end
		end
		for i=1,4 do
			local used = false
			for k,v in pairs(lanesUsed) do
				if i == v then
					used = true
				end
			end
			if not used then
				clearLane(i)
			end
		end
	end
end


local function newTrainSim()
	trainCounter = trainCounter + 1
	local l = 0
	local ltr = false
	local color = {}
	local n 
	
	if 		trainCounter%4 == 1 then l = 50
	elseif trainCounter%4 == 2 then l = 75
	elseif trainCounter%4 == 3 then l = 100
	else 	l = 0 end
	
	if math.random(1,2) == 1 then ltr = true end

	n = math.random(1,3)
	if n == 1 then
		color = addon.db.profile.trainsooncolor
	elseif n == 2 then 
		color = addon.db.profile.trainmovingcolor
	else
		color = addon.db.profile.traintherecolor
	end
	
	displayTrainOnLane(math.random(1,4),l,color,ltr,math.random(1,4))
	
	if trainCounter < 10 then
		addon:ScheduleTimer(newTrainSim, 0.5)
	else
		addon:ScheduleTimer(clearAllTrains, 0.5)
		print("|cffaa00ffThogar Assist:|r "..L["Simulation done."])
	end
end

local function realTrainSim()
	trainCounter = trainCounter + 1
	local randomTrain = trainDataPerDifficulty[15][math.random(1,#trainDataPerDifficulty[15])]
	local color
	local n = math.random(1,3)
	if n == 1 then
		color = addon.db.profile.trainsooncolor
	elseif n == 2 then 
		color = addon.db.profile.trainmovingcolor
	else
		color = addon.db.profile.traintherecolor
	end
	displayTrainOnLane(randomTrain.lane, randomTrain.length, color, randomTrain.leftToRight, randomTrain.type)
	if trainCounter < 10 then
		addon:ScheduleTimer(realTrainSim, 0.5)
	else
		addon:ScheduleTimer(function() clearAllTrains() simulating = false end, 2)
		print("|cffaa00ffThogar Assist:|r "..L["Simulation done."])
	end
end

function addon:sim()
	trainCounter = 0
	clearAllTrains()
	print("|cffaa00ffThogar Assist:|r "..L["Simulating 10 trains..."])
	simulating = true
	--addon:ScheduleTimer(newTrainSim, 0.5)
	addon:ScheduleTimer(realTrainSim, 0.5)
end



local function resetWindow()
	window:ClearAllPoints()
	window:SetPoint("CENTER", UIParent)
	window:SetWidth(defaults.profile.width)
	window:SetHeight(defaults.profile.height)
	updateDisplay()
	addon.db.profile.posx = nil
	addon.db.profile.posy = nil
	addon.db.profile.width = nil
	addon.db.profile.height = nil
end


local function openWindow()
	-- Make sure the window is there
	ensureDisplay()
	-- Start the show!
	window:Show()
	-- debug
	combatStartedTime = GetTime() 
	windowShown = true
	updateDisplay()
end


local function slashCommand(input)
	input = input:trim()
	if input == "reset" then
		resetWindow()
	elseif input == "lock" or input == "unlock" then
		toggleLock()
	elseif input == "config" then
		InterfaceOptionsFrame_OpenToCategory("Thogar Assist")
		InterfaceOptionsFrame_OpenToCategory("Thogar Assist")
	else
		openWindow()
	end
end

local options = {
	type = "group",
	handler = addon,
	get = function(info) return addon.db.profile[info[1]] end,
	set = function(info, v) addon.db.profile[info[1]] = v updateDisplay() end,
	args = {
		desc = {
			type = "description",
			name = L["Displays the next incoming trains so you can get out of the way"],
			order = 1,
			fontSize = "medium",
		},
		general_header = {
			type = "header",
			name = L["General"],
			order = 70,
		},
		resetbutton = {
			order = 200,
			type = "execute",
			name = L["Reset display"],
			desc = L["Reset the scale and position of the display"],
			func = resetWindow,
		},
		test = {
			order = 200,
			type = "execute",
			name = L["Test"],
			func = function() openWindow() addon:sim() end,
		},
		myblipscale = {
			order = 300,
			type = "range",
			name = L["My blip scale"],
			desc = L["Set the scale of the arrow indicating your own position on the display"],
			min = 10, max = 50, step = 2,
		},
		trainwarning = {
			order = 310,
			type = "range",
			name = L["Train warning"],
			desc = L["How many seconds should a train be displayed before it arrives"],
			min = 0, max = 10, step = 0.5,
		},
		highlightlane = {
			type = "toggle",
			name = L["Highlight your lane"],
			desc = L["Toggle if you want your line to be highlighted"],
			order = 320,
		},
		debug_mode = {
			order = 340,
			type = "toggle",
			name = L["Debug"],
			desc = L["Toggle the debug mode (this displays a timer in the bottom right of the display)"],
		},
		font_settings = {
			type = "header",
			name = L["Text settings"],
			order = 350,
		},
		font = {
			order = 360,
			name = L["Font"],
			desc = L["Font used by the addon"],
			type = 'select',
			dialogControl = 'LSM30_Font',
			values = media:HashTable("font"),
		},
		font_outline = {
			order = 370,
			type = "toggle",
			name = L["Outline"],
			desc = L["Toggle if the text gets outlined"],
		},
		font_size = {
			order = 380,
			type = "range",
			name = L["Text size"],
			desc = L["Size of the text"],
			min = 8, max = 30, step = 1,
		},
		color_header = {
			type = "header",
			name = L["Colors"],
			order = 400,
		},
		trainsooncolor = {
			type = "color",
			name = L["Train incoming soon"],
			order = 500,
			hasAlpha = false,
			get = function ()
					local color = addon.db.profile.trainsooncolor
					return color.r, color.g, color.b
				end,
			set = function ( _, r, g, b)
					local color = addon.db.profile.trainsooncolor
					color.r = r
					color.g = g
					color.b = b
				end,
		},
		traintherecolor = {
			type = "color",
			name = L["Train is in the lane"],
			order = 510,
			hasAlpha = false,
			get = function ()
					local color = addon.db.profile.traintherecolor
					return color.r, color.g, color.b
				end,
			set = function ( _, r, g, b)
					local color = addon.db.profile.traintherecolor
					color.r = r
					color.g = g
					color.b = b
				end,
		},
		trainmovingcolor = {
			type = "color",
			name = L["Train is moving"],
			order = 520,
			hasAlpha = false,
			get = function ()
					local color = addon.db.profile.trainmovingcolor
					return color.r, color.g, color.b
				end,
			set = function ( _, r, g, b)
					local color = addon.db.profile.trainmovingcolor
					color.r = r
					color.g = g
					color.b = b
				end,
		},
		yourlanecolor = {
			type = "color",
			name = L["Your lane"],
			order = 530,
			hasAlpha = false,
			get = function ()
					local color = addon.db.profile.yourlanecolor
					return color.r, color.g, color.b
				end,
			set = function ( _, r, g, b)
					local color = addon.db.profile.yourlanecolor
					color.r = r
					color.g = g
					color.b = b
				end,
		},
		lanenumbers_header = {
			type = "header",
			name = L["Lane numbers"],
			order = 600,
		},
		lanenumbers = {
			type = "toggle",
			name = L["Display lane numbers"],
			desc = L["Toggle if lane numbers are displayed"],
			order = 610,
		},
		lanenumbers_position = {
			order = 620,
			type = "select",
			name = L["Position"],
			desc = L["Change the position of the lane numbers"],
			values = {
						leftinside = L['left inside'],
						leftoutside = L['left outside'],
						rightinside = L['right inside'],
						rightoutside = L['right outside'],
			},
		},
		lanenumbers_inverse = {
			type = "toggle",
			name = L["Inverse lane numbers"],
			desc = L["Toggle if lane numbers should be displayed inverse"],
			order = 630,
		},
		laneraidicons_header = {
			type = "header",
			name = L["Lane raid icons"],
			order = 700,
		},
		laneraidicons = {
			type = "toggle",
			name = L["Display raid icons"],
			desc = L["Toggle if raid icons are displayed on the lanes"],
			order = 710,
		},
		laneraidicons_position = {
			order = 720,
			type = "select",
			name = L["Position"],
			desc = L["Change the position of the raid icons"],
			values = {
						leftinside = L['left inside'],
						leftoutside = L['left outside'],
						rightinside = L['right inside'],
						rightoutside = L['right outside'],
			},
		},
		laneraidicon1 = {
			order = 730,
			type = "select",
			name = L["Lane 1 Icon"],
			desc = L["Select the raid icon"],
			values = {
						rt1 = "|TInterface\\TARGETINGFRAME\\UI-RaidTargetingIcons.png:20:20:0:0:256:256:0:64:0:64|t " ..L["Star"],
						rt2 = "|TInterface\\TARGETINGFRAME\\UI-RaidTargetingIcons.png:20:20:0:0:256:256:64:128:0:64|t "..L["Circle"],
						rt3 = "|TInterface\\TARGETINGFRAME\\UI-RaidTargetingIcons.png:20:20:0:0:256:256:128:192:0:64|t "..L["Diamond"],
						rt4 = "|TInterface\\TARGETINGFRAME\\UI-RaidTargetingIcons.png:20:20:0:0:256:256:192:256:0:64|t "..L["Triangle"],
						rt5 = "|TInterface\\TARGETINGFRAME\\UI-RaidTargetingIcons.png:20:20:0:0:256:256:0:64:64:128|t "..L["Moon"],
						rt6 = "|TInterface\\TARGETINGFRAME\\UI-RaidTargetingIcons.png:20:20:0:0:256:256:64:128:64:128|t "..L["Square"],
						rt7 = "|TInterface\\TARGETINGFRAME\\UI-RaidTargetingIcons.png:20:20:0:0:256:256:128:192:64:128|t "..L["Cross"],
						rt8 = "|TInterface\\TARGETINGFRAME\\UI-RaidTargetingIcons.png:20:20:0:0:256:256:192:256:64:128|t "..L["Skull"],
			},
		},
		laneraidicon2 = {
			order = 732,
			type = "select",
			name = L["Lane 2 Icon"],
			desc = L["Select the raid icon"],
			values = {
						rt1 = "|TInterface\\TARGETINGFRAME\\UI-RaidTargetingIcons.png:20:20:0:0:256:256:0:64:0:64|t " ..L["Star"],
						rt2 = "|TInterface\\TARGETINGFRAME\\UI-RaidTargetingIcons.png:20:20:0:0:256:256:64:128:0:64|t "..L["Circle"],
						rt3 = "|TInterface\\TARGETINGFRAME\\UI-RaidTargetingIcons.png:20:20:0:0:256:256:128:192:0:64|t "..L["Diamond"],
						rt4 = "|TInterface\\TARGETINGFRAME\\UI-RaidTargetingIcons.png:20:20:0:0:256:256:192:256:0:64|t "..L["Triangle"],
						rt5 = "|TInterface\\TARGETINGFRAME\\UI-RaidTargetingIcons.png:20:20:0:0:256:256:0:64:64:128|t "..L["Moon"],
						rt6 = "|TInterface\\TARGETINGFRAME\\UI-RaidTargetingIcons.png:20:20:0:0:256:256:64:128:64:128|t "..L["Square"],
						rt7 = "|TInterface\\TARGETINGFRAME\\UI-RaidTargetingIcons.png:20:20:0:0:256:256:128:192:64:128|t "..L["Cross"],
						rt8 = "|TInterface\\TARGETINGFRAME\\UI-RaidTargetingIcons.png:20:20:0:0:256:256:192:256:64:128|t "..L["Skull"],
			},
		},
		laneraidicon3 = {
			order = 734,
			type = "select",
			name = L["Lane 3 Icon"],
			desc = L["Select the raid icon"],
			values = {
						rt1 = "|TInterface\\TARGETINGFRAME\\UI-RaidTargetingIcons.png:20:20:0:0:256:256:0:64:0:64|t " ..L["Star"],
						rt2 = "|TInterface\\TARGETINGFRAME\\UI-RaidTargetingIcons.png:20:20:0:0:256:256:64:128:0:64|t "..L["Circle"],
						rt3 = "|TInterface\\TARGETINGFRAME\\UI-RaidTargetingIcons.png:20:20:0:0:256:256:128:192:0:64|t "..L["Diamond"],
						rt4 = "|TInterface\\TARGETINGFRAME\\UI-RaidTargetingIcons.png:20:20:0:0:256:256:192:256:0:64|t "..L["Triangle"],
						rt5 = "|TInterface\\TARGETINGFRAME\\UI-RaidTargetingIcons.png:20:20:0:0:256:256:0:64:64:128|t "..L["Moon"],
						rt6 = "|TInterface\\TARGETINGFRAME\\UI-RaidTargetingIcons.png:20:20:0:0:256:256:64:128:64:128|t "..L["Square"],
						rt7 = "|TInterface\\TARGETINGFRAME\\UI-RaidTargetingIcons.png:20:20:0:0:256:256:128:192:64:128|t "..L["Cross"],
						rt8 = "|TInterface\\TARGETINGFRAME\\UI-RaidTargetingIcons.png:20:20:0:0:256:256:192:256:64:128|t "..L["Skull"],
			},
		},
		laneraidicon4 = {
			order = 736,
			type = "select",
			name = L["Lane 4 Icon"],
			desc = L["Select the raid icon"],
			values = {
						rt1 = "|TInterface\\TARGETINGFRAME\\UI-RaidTargetingIcons.png:20:20:0:0:256:256:0:64:0:64|t " ..L["Star"],
						rt2 = "|TInterface\\TARGETINGFRAME\\UI-RaidTargetingIcons.png:20:20:0:0:256:256:64:128:0:64|t "..L["Circle"],
						rt3 = "|TInterface\\TARGETINGFRAME\\UI-RaidTargetingIcons.png:20:20:0:0:256:256:128:192:0:64|t "..L["Diamond"],
						rt4 = "|TInterface\\TARGETINGFRAME\\UI-RaidTargetingIcons.png:20:20:0:0:256:256:192:256:0:64|t "..L["Triangle"],
						rt5 = "|TInterface\\TARGETINGFRAME\\UI-RaidTargetingIcons.png:20:20:0:0:256:256:0:64:64:128|t "..L["Moon"],
						rt6 = "|TInterface\\TARGETINGFRAME\\UI-RaidTargetingIcons.png:20:20:0:0:256:256:64:128:64:128|t "..L["Square"],
						rt7 = "|TInterface\\TARGETINGFRAME\\UI-RaidTargetingIcons.png:20:20:0:0:256:256:128:192:64:128|t "..L["Cross"],
						rt8 = "|TInterface\\TARGETINGFRAME\\UI-RaidTargetingIcons.png:20:20:0:0:256:256:192:256:64:128|t "..L["Skull"],
			},
		},
	}
}

local function OnEvent(self, event, ...)
	if event == "ADDON_LOADED" then
		if select(1,...)	== "ThogarAssist" then
			LibStub("AceTimer-3.0"):Embed(addon)
			LibStub("AceEvent-3.0"):Embed(addon)
			self.db = LibStub("AceDB-3.0"):New("ThogarAssistDB", defaults, true)
			LibStub("AceConfig-3.0"):RegisterOptionsTable("Thogar Assist", options)
			LibStub("AceConfigDialog-3.0"):AddToBlizOptions("Thogar Assist", "Thogar Assist")
			SlashCmdList.ThogarAssist = slashCommand
			SLASH_ThogarAssist1 = "/thogar"
			self:UnregisterEvent("ADDON_LOADED")
			addon:RegisterEvent("ENCOUNTER_START")
			addon:RegisterEvent("ENCOUNTER_END")
		end
	end
end

function addon:ENCOUNTER_START(event, encounterID, encounterName, difficultyID, raidSize)
	--print("TA", event, encounterID, encounterName, difficultyID, raidSize)
	if encounterID == 1692 then
		--print("TA", "Thogar Fight: ", difficultyID)
		if trainDataPerDifficulty[difficultyID] then
			if not trainDataNotCompleteMessageShown then
				print("|cffaa00ffThogar Assist:|r "..L["This is an early release. The train data may not be complete. If you want to help complete it, please message me on curse."])
				trainDataNotCompleteMessageShown = true
			end
			--print("TA", "got trainData!")
			simulating = false
			inFight = true
			
			addon:Show()
			trainData = trainDataPerDifficulty[difficultyID]
			
			for k,v in pairs(trainData) do--test this shit
				trainData[k].trainDisplayed = nil
				trainData[k].warningDisplayed = nil
			end
			
			openWindow()
			myblip:Show()
			combatStartedTime = GetTime() 
		end
	end
end

function addon:ENCOUNTER_END(event, encounterID, encounterName, difficultyID, raidSize, endStatus)
	if encounterID == 1692 then
		inFight = false
		addon:Hide()
		myblip:Hide()
		closeWindow()
	end
end

addon:Hide()
addon:RegisterEvent("ADDON_LOADED")
addon:SetScript("OnEvent", OnEvent)


local total = 0
addon:SetScript("OnUpdate", function(self, elapsed)
	total = total + elapsed
	if total > 0.05 then
		if windowShown then
			addon:updateData()
		end
		total = 0
	end
end)


