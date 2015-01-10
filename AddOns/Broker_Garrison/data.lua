local ADDON_NAME, private = ...

local _G = getfenv(0)
local LibStub = _G.LibStub

local Garrison = LibStub("AceAddon-3.0"):GetAddon(ADDON_NAME)
local L = LibStub:GetLibrary( "AceLocale-3.0" ):GetLocale(ADDON_NAME)

Garrison.colors = {
	green = {r=0, g=1, b=0, a=1},
	white = {r=1, g=1, b=1, a=1},
	red = {r=1, g=0, b=0, a=1},

	lightGray = {r=(108/255), g=(115/255), b=(120/255), a=1},
	green = {r=(32/255), g=(255/255), b=(32/255), a=1},
	red = {r=(255/255), g=(25/255), b=(25/255), a=1},
	yellow = {r=(255/255), g=(228/255), b=(0/255), a=1},

	--lightGray = {r=0.25, g=0.25, b=0.25, a=1},
	darkGray = {r=0.1, g=0.1, b=0.1, a=1},
	lineGrey = {r=(108/255), g=(115/255), b=(120/255), a=1},
	--lightGray = {r=(82/255), g=(91/255), b=(97/255), a=1},
}

local resets = {
	[1] = 3, -- US, Tuesday
	[2] = 5, -- Korea, Thursday
	[3] = 4, -- Europe(Russia), Wednesday
	[4] = 5, -- Taiwan, Thursday
	[5] = 5, -- China, Thursday
}

Garrison.REGION = _G.GetCurrentRegion()
Garrison.WeeklyResetDay = resets[Garrison.REGION]

Garrison.GARRISON_CURRENCY = 824
Garrison.GARRISON_CURRENCY_APEXIS = 823
Garrison.GARRISON_CURRENTY_SEAL_OF_TEMPERED_FATE = 994

Garrison.GARRISON_TRACK_LOOT_ITEM = {
	{
		itemId = 115508,
		name = "Draenic Stone",
	},
	{
		itemId = 116053,
		name = "Draenic Seeds",
	},
}

Garrison.LOOT_PATTERN = {
	{
		format = LOOT_ITEM_SELF_MULTIPLE,
		numMatch = 2,
		matchPlayer = nil,
		matchCount = 2,
	},
	{
		format = LOOT_ITEM_SELF,
		numMatch = 1,
		matchPlayer = nil,
		matchCount = nil,
	},
}

Garrison.DURATION_PATTERN = {
	{
		format = GARRISON_DURATION_DAYS_HOURS,
		numMatch = 2,
		factor = {
			[0] = 86400,
			[1] = 3600,
		},
	},	
	{
		format = GARRISON_DURATION_DAYS,
		numMatch = 1,
		factor =  {
			[0] = 86400,
		},
	},
	{
		format = GARRISON_DURATION_HOURS_MINUTES,
		numMatch = 2,
		factor = {
			[0] = 3600,
			[1] = 60,
		},
	},
	{
		format = GARRISON_DURATION_HOURS,
		numMatch = 1,
		factor = {
			[0] = 3600,
		},
	},
	{
		format = GARRISON_DURATION_MINUTES,
		numMatch = 1,
		factor = {
			[0] = 60,
		},
	},
	{
		format = GARRISON_DURATION_SECONDS,
		numMatch = 1,
		factor = {
			[0] = 1,
		},
	}
}

Garrison.buildingInfo = {
	["Mine"] = {
		trackLootItemId = 115508,
		minLooted = 5,
		["level"] = {
			[61] = 1,
			[62] = 2,
			[63] = 3,
		},
	},
	["Herb Garden"] = {
		trackLootItemId = 116053,
		minLooted = 5,
		["level"] = {
			[29] = 1,
			[136] = 2,
			[137] = 3,
		},
	},
	["War Mill"] = {
		--trackQuestId = 36058,
		trackCustom = function() return _G.IsQuestFlaggedCompleted(36058) end,
		trackCustomId = "WARMILL",
		minLevel = 3,
		weekly = true,
		["level"] = {
			[8] = 1,
			[9] = 2,
			[10] = 3,
		},
	},
	["Inn"] = {
		trackCustomId = "INN",
		minLevel = 2,
		["level"] = {
			[34] = 1,
			[35] = 2,
			[36] = 3,
		},
	},
}

Garrison.instanceId = {
	[1153] = {
		-- chest location, 0.01 distance
		x = 0.42065811157227,
		y = 0.47422081232071,
		type = "HL3",
	},
	[1330] = {
		x = 0.41082060337067,
		y = 0.48072397708893,
		type = "HL2",
	},
	[1152] = {
		x = 0.55034613609314,
		y = 0.53083437681198,
		type = "HL1",
	},
	[1331] = {
		x = 0.37776511907578,
		y = 0.31113547086716,
		type = "AL2",
	},
	[1158] = {
		x = 0.49295610189438,
		y = 0.43294894695282,
		type = "AL1",
	},
	[1159] = {
		x = 0.37880980968475,
		y = 0.31599986553192,
		type = "AL3",
	},
}

Garrison.missionModifier = {
	[221] = 0.5,
	[222] = 0.75,
	[95] = 0.75,
	[96] = 0.5,
}
	

Garrison.STATE_BUILDING_ACTIVE = 0
Garrison.STATE_BUILDING_COMPLETE = 1
Garrison.STATE_BUILDING_BUILDING = 2

Garrison.STATE_MISSION_COMPLETE = 0
Garrison.STATE_MISSION_INPROGRESS = 1

Garrison.COLOR_TABLE = _G.CUSTOM_CLASS_COLORS or _G.RAID_CLASS_COLORS

local mediaPath = "Interface\\AddOns\\Broker_Garrison\\Media\\"

Garrison.ICON_REPLACEMENT = {
	[strlower("Interface\\ICONS\\Garrison_Building_Armory")] = mediaPath.."garrison_building_armory",
	[strlower("Interface\\ICONS\\Garrison_Building_Stables")] = mediaPath.."garrison_building_stables",
	[strlower("Interface\\ICONS\\Garrison_Building_SparringArena")] = mediaPath.."garrison_building_sparringarena",
	[strlower("Interface\\ICONS\\Garrison_Building_SalvageYard")] = mediaPath.."garrison_building_salvageyard",
	[strlower("Interface\\ICONS\\Garrison_Building_Menagerie")] = mediaPath.."garrison_building_menagerie",
	[strlower("Interface\\ICONS\\Garrison_Building_MageTower")] = mediaPath.."garrison_building_magetower",
	[strlower("Interface\\ICONS\\Garrison_Building_Lumbermill")] = mediaPath.."garrison_building_lumbermill",
	[strlower("Interface\\ICONS\\Garrison_Building_Barracks")] = mediaPath.."garrison_building_barracks",
	[strlower("Interface\\ICONS\\Garrison_Building_Barn")] = mediaPath.."garrison_building_barn",
	[strlower("Interface\\ICONS\\Garrison_Building_Workshop")] = mediaPath.."garrison_building_workshop",
	[strlower("Interface\\ICONS\\Garrison_Building_TradingPost")] = mediaPath.."garrison_building_tradingpost",
	[strlower("Interface\\ICONS\\Garrison_Building_Storehouse")] = mediaPath.."garrison_building_storehouse",
	[strlower("Interface\\ICONS\\Trade_Tailoring")] = mediaPath.."trade_tailoring",
	[strlower("Interface\\ICONS\\Trade_Mining")] = mediaPath.."trade_mining",
	[strlower("Interface\\ICONS\\Trade_Fishing")] = mediaPath.."trade_fishing",
	[strlower("Interface\\ICONS\\Trade_Engraving")] = mediaPath.."trade_engraving",
	[strlower("Interface\\ICONS\\Trade_Engineering")] = mediaPath.."trade_engineering",
	[strlower("Interface\\ICONS\\Trade_Blacksmithing")] = mediaPath.."trade_blacksmithing",
	[strlower("Interface\\ICONS\\Trade_Alchemy")] = mediaPath.."trade_alchemy",
	
	[strlower("Interface\\ICONS\\INV_Misc_Rune_01")] = mediaPath.."inv_misc_rune_01",
	[strlower("Interface\\ICONS\\INV_Misc_Herb_SansamRoot")] = mediaPath.."inv_misc_herb_sansamroot",
	[strlower("Interface\\ICONS\\INV_Misc_Gem_01")] = mediaPath.."inv_misc_gem_01",
	[strlower("Interface\\ICONS\\INV_Misc_Armorkit_17")] = mediaPath.."inv_misc_armorkit_17",
	[strlower("Interface\\ICONS\\INV_Inscription_Tradeskill01")] = mediaPath.."inv_inscription_tradeskill01",

	-- Missions
	[strlower("Interface\\ICONS\\Garrison_ArmorUpgrade")] = mediaPath.."mission\\Garrison_ArmorUpgrade",
	[strlower("Interface\\ICONS\\Garrison_WeaponUpgrade")] = mediaPath.."mission\\Garrison_WeaponUpgrade",
	[strlower("Interface\\ICONS\\INV_Misc_Archstone_01")] = mediaPath.."mission\\INV_Misc_Archstone_01",
	[strlower("Interface\\ICONS\\INV_Misc_Coin_01")] = mediaPath.."mission\\INV_Misc_Coin_01",
	[strlower("Interface\\ICONS\\INV_MISC_Lockboxghostiron")] = mediaPath.."mission\\INV_MISC_Lockboxghostiron",
	[strlower("Interface\\ICONS\\XPBonus_Icon")] = mediaPath.."mission\\XPBonus_Icon",

	[strlower("Interface\\ICONS\\inv_misc_ornatebox")] = mediaPath.."mission\\inv_misc_ornatebox",
	[strlower("Interface\\ICONS\\inv_jewelry_necklace_70")] = mediaPath.."mission\\inv_jewelry_necklace_70",
	[strlower("Interface\\ICONS\\inv_jewelry_ring_146")] = mediaPath.."mission\\inv_jewelry_ring_146",
	[strlower("Interface\\ICONS\\inv_belt_cloth_reputation_c_01")] = mediaPath.."mission\\inv_belt_cloth_reputation_c_01",
	[strlower("Interface\\ICONS\\inv_shoulder_cloth_reputation_c_01")] = mediaPath.."mission\\inv_shoulder_cloth_reputation_c_01",
	[strlower("Interface\\ICONS\\inv_pants_cloth_reputation_c_01")] = mediaPath.."mission\\inv_pants_cloth_reputation_c_01",
	[strlower("Interface\\ICONS\\inv_gauntlets_cloth_reputation_c_01")] = mediaPath.."mission\\inv_gauntlets_cloth_reputation_c_01",
	[strlower("Interface\\ICONS\\inv_boots_cloth_reputation_c_01")] = mediaPath.."mission\\inv_boots_cloth_reputation_c_01",
	[strlower("Interface\\ICONS\\inv_chest_cloth_reputation_c_01")] = mediaPath.."mission\\inv_chest_cloth_reputation_c_01",
	[strlower("Interface\\ICONS\\inv_bracer_cloth_reputation_c_01")] = mediaPath.."mission\\inv_bracer_cloth_reputation_c_01",
	[strlower("Interface\\ICONS\\inv_misc_pvp_trinket")] = mediaPath.."mission\\inv_misc_pvp_trinket",
	[strlower("Interface\\ICONS\\inv_sword_46")] = mediaPath.."mission\\inv_sword_46",
	[strlower("Interface\\ICONS\\xp_icon")] = mediaPath.."mission\\xp_icon",

	[strlower("Interface\\ICONS\\INV_Garrison_Resource")] = mediaPath.."bg_garrison_toolbar_resource",
	[strlower("Interface\\ICONS\\INV_Apexis_Draenor")] = mediaPath.."bg_garrison_toolbar_apexis",
	[strlower("Interface\\ICONS\\Ability_AnimusOrbs")] = mediaPath.."bg_garrison_toolbar_fate",
}

Garrison.ICON_PATH_CURRENCY = mediaPath.."bg_garrison_toolbar_resource"
Garrison.ICON_PATH_CURRENCY_APEXIS = mediaPath.."bg_garrison_toolbar_apexis"
Garrison.ICON_PATH_CURRENCY_TEMPERED_FATE = mediaPath.."bg_garrison_toolbar_fate"

Garrison.ICON_PATH_ABOUT1 = mediaPath.."bg_garrison_about_h1"

Garrison.ICON_PATH_CURRENCY_TOOLTIP = mediaPath.."bg_garrison_tooltip_resource"
Garrison.ICON_PATH_CURRENCY_APEXIS_TOOLTIP = mediaPath.."bg_garrison_tooltip_apexis"
Garrison.ICON_PATH_CURRENCY_TEMPERED_FATE_TOOLTIP = mediaPath.."bg_garrison_tooltip_fate"

Garrison.ICON_PATH_MISSION = mediaPath.."bg_garrison_toolbar_missions"
Garrison.ICON_PATH_BUILDING = mediaPath.."bg_garrison_toolbar_buildings"

Garrison.ICON_PATH_FOLLOWER_NO_PORTRAIT = mediaPath.."bg_garrison_tooltip_follower"

Garrison.ICON_PATH_OPEN = mediaPath.."bg_garrison_tooltip_arrow_open"
Garrison.ICON_PATH_CLOSE = mediaPath.."bg_garrison_tooltip_arrow_close"

Garrison.ICON_PATH_ARROW_UP = mediaPath.."bg_garrison_tooltip_buildings_active"
Garrison.ICON_PATH_ARROW_UP_WAITING = mediaPath.."bg_garrison_tooltip_buildings_waiting"

Garrison.ICON_PATH_CHECK = mediaPath.."bg_garrison_tooltip_check_active"
Garrison.ICON_PATH_CHECK_WAITING = mediaPath.."bg_garrison_tooltip_check_waiting"
Garrison.ICON_PATH_WARNING = mediaPath.."bg_garrison_toolbar_warning"

Garrison.ICON_PATH_INVASION = mediaPath.."bg_garrison_toolbar_invasion"

Garrison.COMPLETED_PATTERN = "^[^%d]*(0)[^%d]*$"
--Garrison.ICON_CURRENCY = string.format("\124T%s\\%s:%d:%d:1:0\124t", mediaPath, name, 16, 16)

Garrison.ICON_CURRENCY = Garrison.getIconString(Garrison.ICON_PATH_CURRENCY, 16, false)
Garrison.ICON_CURRENCY_APEXIS = Garrison.getIconString(Garrison.ICON_PATH_CURRENCY_APEXIS, 16, false)
Garrison.ICON_CURRENCY_TOOLTIP = Garrison.getIconString(Garrison.ICON_PATH_CURRENCY_TOOLTIP, 16, false)
Garrison.ICON_CURRENCY_TEMPERED_FATE = Garrison.getIconString(Garrison.ICON_PATH_CURRENCY_TEMPERED_FATE, 16, false)
Garrison.ICON_CURRENCY_APEXIS_TOOLTIP = Garrison.getIconString(Garrison.ICON_PATH_CURRENCY_APEXIS_TOOLTIP, 16, false)
Garrison.ICON_CURRENCY_TEMPERED_FATE_TOOLTIP = Garrison.getIconString(Garrison.ICON_PATH_CURRENCY_TEMPERED_FATE_TOOLTIP, 16, false)


Garrison.ICON_MISSION = Garrison.getIconString(Garrison.ICON_PATH_MISSION, 16, false)
Garrison.ICON_BUILDING = Garrison.getIconString(Garrison.ICON_PATH_BUILDING, 16, false)

Garrison.ICON_ARROW_UP = Garrison.getIconString(Garrison.ICON_PATH_ARROW_UP, 16, false)
Garrison.ICON_ARROW_UP_WAITING = Garrison.getIconString(Garrison.ICON_PATH_ARROW_UP_WAITING, 16, false)

Garrison.ICON_CHECK = Garrison.getIconString(Garrison.ICON_PATH_CHECK, 16, false)
Garrison.ICON_CHECK_WAITING = Garrison.getIconString(Garrison.ICON_PATH_CHECK_WAITING, 16, false)
Garrison.ICON_WARNING = Garrison.getIconString(Garrison.ICON_PATH_WARNING, 16, false)
Garrison.ICON_INVASION = Garrison.getIconString(Garrison.ICON_PATH_INVASION, 16, false)


Garrison.ICON_OPEN = Garrison.getIconString(Garrison.ICON_PATH_OPEN, 16, false)
Garrison.ICON_CLOSE = Garrison.getIconString(Garrison.ICON_PATH_CLOSE, 16, false)
--Garrison.ICON_OPEN = string.format("\124TInterface\\AddOns\\Broker_Garrison\\Media\\Open:%d:%d:1:0\124t", 16, 16)
--Garrison.ICON_CLOSE = string.format("\124TInterface\\AddOns\\Broker_Garrison\\Media\\Close:%d:%d:1:0\124t", 16, 16)

Garrison.ICON_OPEN_DOWN = Garrison.ICON_OPEN
Garrison.ICON_CLOSE_DOWN = Garrison.ICON_CLOSE

Garrison.Icon = {
	[Garrison.TYPE_MISSION] = Garrison.ICON_PATH_MISSION,
	[Garrison.TYPE_SHIPMENT] = Garrison.ICON_PATH_BUILDING,
	[Garrison.TYPE_BUILDING] = Garrison.ICON_PATH_BUILDING,
}

Garrison.NotificationTitle = {
	[Garrison.TYPE_BUILDING] = L["Building"],
	[Garrison.TYPE_MISSION] = L["Mission"],
	[Garrison.TYPE_SHIPMENT] = L["Shipment"],	
}


Garrison.tooltipConfig = {
	["-"] = {
		name = " - ",
	},
	["b.canActivate"] = {
		value = "canActivate",
		name = L["Can be activated"],
		type = Garrison.TYPE_BUILDING,
	},
	["b.isBuilding"]= {
		value = "isBuilding",
		name = L["Is Building"],
		type = Garrison.TYPE_BUILDING,
	},
	["b.shipmentsReady"] = {
		value = "shipment.shipmentsReadyEstimate",
		name = L["Shipments Ready"],
		type = Garrison.TYPE_BUILDING,
	},	
	["b.shipmentsInProgress"] = {
		value = "shipment.shipmentsInProgress",
		name = L["Shipments In Progress"],
		type = Garrison.TYPE_BUILDING,
	},
	["b.shipmentsTotal"] = {
		value = "shipment.shipmentsTotal",
		name = L["Shipments Total (Progress+Ready)"],
		type = Garrison.TYPE_BUILDING,
	},		
	["b.shipmentsAvailable"] = {
		value = "shipment.shipmentsAvailable",
		name = L["Shipments Available"],
		type = Garrison.TYPE_BUILDING,
	},
	["b.shipmentCapacity"] = {
		value = "shipment.shipmentCapacity",
		name = L["Shipment Capacity"],
		type = Garrison.TYPE_BUILDING,
	},
	["b.buildingState"] = {
		value = "buildingState",
		name = L["Building State (Active, Complete, Building)"],
		type = Garrison.TYPE_BUILDING,
	},	
	["b.size"] = {
		value = "plotSize",
		name = L["Building Size"],
		type = Garrison.TYPE_BUILDING,
	},	
	["b.rank"] = {
		value = "rank",
		name = L["Building Rank"],
		type = Garrison.TYPE_BUILDING,
	},	
	["b.name"] = {
		value = "name",
		name = L["Building Name"],
		type = Garrison.TYPE_BUILDING,
	},
	["m.timeLeft"] = {
		value = "timeLeftCalc",
		name = L["Remaining Time"],
		type = Garrison.TYPE_MISSION,
	},	
	["m.level"] = {
		value = "level",
		name = L["Mission Level"],
		type = Garrison.TYPE_MISSION,
	},
	["m.missionState"] = {
		value = "missionState",
		name = L["Mission State (Complete, In Progress)"],
		type = Garrison.TYPE_MISSION,
	},	
	["m.name"] = {
		value = "name",
		name = L["Mission Name"],
		type = Garrison.TYPE_MISSION,
	},
}

Garrison.ldbTemplate = {
	["A1"] = {
		name = L["Garrison Resources (Current char)"],
		text = "%resfmt% %resicon%%cachewarning%",
	},
	["A1"] = {
		name = L["Garrison Resources (No icon)"],
		text = "%resfmt%%cachewarning%",
	},
	["M1"] = {
		name = L["Progress, Complete"],
		text = L["In Progress: %mp% Complete: %mc%"],
		type = Garrison.TYPE_MISSION,
	},	
	["M2"] = {
		name = L["Missions Complete + Time to next completion (All characters)"],
		text = L["Complete: %mc% Next: %mnt|-%"],
		type = Garrison.TYPE_MISSION,
	},	
	["M3"] = {
		name = L["Missions Complete + Time/Char to next completion (All characters)"],
		text = L["Complete: %mc% Next: %mnt|-% (%mnc|-%)"],
		type = Garrison.TYPE_MISSION,
	},	
	["B1"] = {
		name = L["Shipments Ready (All characters)"],
		text = L["Shipments Ready: %sr%%cachewarning%"].."%cinvasion%",
		type = Garrison.TYPE_BUILDING,
	},
	["B2"] = {
		name = L["Shipments Ready + Time to next shipment (All characters)"],
		text = L["Ready: %sr% Next: %snt|-%"],
		type = Garrison.TYPE_BUILDING,
	},	
	["B3"] = {
		name = L["Shipments Ready + Time/Char to next shipment (All characters)"],
		text = L["Ready: %sr% Next: %snt|-% (%snc|-%)"],
		type = Garrison.TYPE_BUILDING,
	},
}

Garrison.ldbVars = {
	["mt"] = {
		name = L["Missions: Total"],
		data = function(data) return Garrison.getTableValue(data, "missionCount", "total") end,
		type = Garrison.TYPE_MISSION,
	},
	["mp"] = {
		name = L["Missions: In Progress"],
		data = function(data) return Garrison.getTableValue(data, "missionCount", "inProgress") end,
		type = Garrison.TYPE_MISSION,
	},
	["mc"] = {
		name = L["Missions: Complete"],
		data = function(data) return Garrison.getTableValue(data, "missionCount", "complete") end,
		type = Garrison.TYPE_MISSION,
	},
	["mnt"] = {
		name = L["Time until next mission"],
		data = function(data) 
			local time = Garrison.getTableValue(data, "missionCount", "nextTime") or 0
			if time > 0 then
				return Garrison.formattedSeconds(time)
			else
				return nil
			end
		end,
		type = Garrison.TYPE_MISSION,
	},
	["mnr"] = {
		name = L["Realm next mission"],
		data = function(data) 
			return Garrison.getTableValue(data, "missionCount", "nextChar", "playerRealm")
		end,
		type = Garrison.TYPE_MISSION,
	},
	["mnc"] = {
		name = L["Character next mission"],
		data = function(data) 
			return Garrison.getTableValue(data, "missionCount", "nextChar", "playerName")
		end,
		type = Garrison.TYPE_MISSION,
	},	
	["cmt"] = {
		name = L["Current Player Missions: Total"],
		data = function(data) return Garrison.getTableValue(data, "missionCountCurrent", "total") end,
		type = Garrison.TYPE_MISSION,
	},
	["cmp"] = {
		name = L["Current Player Missions: In Progress"],
		data = function(data) return Garrison.getTableValue(data, "missionCountCurrent", "inProgress") end,
		type = Garrison.TYPE_MISSION,
	},
	["cmc"] = {
		name = L["Current Player Missions: Complete"],
		data = function(data) return Garrison.getTableValue(data, "missionCountCurrent", "complete") end,
		type = Garrison.TYPE_MISSION,
	},	
	["bt"] = {
		name = L["Buildings: Total"],
		data = function(data) return Garrison.getTableValue(data, "buildingCount", "building", "total") end,
		type = Garrison.TYPE_BUILDING,
	},
	["bb"] = {
		name = L["Buildings: Building"],
		data = function(data) return Garrison.getTableValue(data, "buildingCount", "building", "building") end,
		type = Garrison.TYPE_BUILDING,
	},
	["bc"] = {
		name = L["Buildings: Complete"],
		data = function(data) return Garrison.getTableValue(data, "buildingCount", "building", "complete") end,
		type = Garrison.TYPE_BUILDING,
	},
	["ba"] = {
		name = L["Buildings: Active"],
		data = function(data) return Garrison.getTableValue(data, "buildingCount", "building", "active") end,
		type = Garrison.TYPE_BUILDING,
	},
	["bbicon"] = {
		name = L["Icon Buildings: Building"],
		data = function(data) return (Garrison.getTableValue(data, "buildingCount", "building", "building") or 0) > 0 and Garrison.ICON_ARROW_UP_WAITING or "" end,
		type = Garrison.TYPE_BUILDING,
	},
	["bcicon"] = {
		name = L["Icon Buildings: Complete"],
		data = function(data) return (Garrison.getTableValue(data, "buildingCount", "building", "complete") or 0) > 0 and Garrison.ICON_ARROW_UP or "" end,
		type = Garrison.TYPE_BUILDING,
	},
	["bicon"] = {
		name = L["Icon Buildings"],
		data = function(data) 
			if (Garrison.getTableValue(data, "buildingCount", "building", "complete") or 0) > 0 then
				return Garrison.ICON_ARROW_UP
			elseif (Garrison.getTableValue(data, "buildingCount", "building", "building") or 0) > 0 then
				return Garrison.ICON_ARROW_UP_WAITING
			else
				return ""
			end
		end,
		type = Garrison.TYPE_BUILDING,
	},	
	["st"] = {
		name = L["Shipments: Total"],
		data = function(data) return Garrison.getTableValue(data, "buildingCount", "shipment", "total") end,
		type = Garrison.TYPE_BUILDING,
	},
	["sp"] = {
		name = L["Shipments: In Progress"],
		data = function(data) return Garrison.getTableValue(data, "buildingCount", "shipment", "inProgress") end,
		type = Garrison.TYPE_BUILDING,
	},
	["sr"] = {
		name = L["Shipments: Ready"],
		data = function(data) return Garrison.getTableValue(data, "buildingCount", "shipment", "ready") end,
		type = Garrison.TYPE_BUILDING,
	},
	["sa"] = {
		name = L["Shipments: Available"],
		data = function(data) return Garrison.getTableValue(data, "buildingCount", "shipment", "available") end,
		type = Garrison.TYPE_BUILDING,
	},
	["snt"] = {
		name = L["Time until next shipment"],
		data = function(data) 
			local time = Garrison.getTableValue(data, "buildingCount", "shipment", "nextTime") or 0
			if time > 0 then
				return Garrison.formattedSeconds(time)
			else
				return nil
			end
		end,
		type = Garrison.TYPE_BUILDING,
	},
	["sncr"] = {
		name = L["Realm next shipment"],
		data = function(data) 
			return Garrison.getTableValue(data, "buildingCount", "shipment", "nextChar", "playerRealm")
		end,
		type = Garrison.TYPE_BUILDING,
	},
	["snc"] = {
		name = L["Character next shipment"],
		data = function(data) 
			return Garrison.getTableValue(data, "buildingCount", "shipment", "nextChar", "playerName")
		end,
		type = Garrison.TYPE_BUILDING,
	},	
	["cbt"] = {
		name = L["Current Player Buildings: Total"],
		data = function(data) return Garrison.getTableValue(data, "buildingCountCurrent", "building", "total") end,
		type = Garrison.TYPE_BUILDING,
	},
	["cbb"] = {
		name = L["Current Player Buildings: Building"],
		data = function(data) return Garrison.getTableValue(data, "buildingCountCurrent", "building", "building") end,
		type = Garrison.TYPE_BUILDING,
	},
	["cbc"] = {
		name = L["Current Player Buildings: Complete"],
		data = function(data) return Garrison.getTableValue(data, "buildingCountCurrent", "building", "complete") end,
		type = Garrison.TYPE_BUILDING,
	},	
	["cba"] = {
		name = L["Current Player Buildings: Active"],
		data = function(data) return Garrison.getTableValue(data, "buildingCountCurrent", "building", "active") end,
		type = Garrison.TYPE_BUILDING,
	},
	["cst"] = {
		name = L["Current Player Shipments: Total"],
		data = function(data) return Garrison.getTableValue(data, "buildingCountCurrent", "shipment", "total") end,
		type = Garrison.TYPE_BUILDING,
	},
	["csp"] = {
		name = L["Current Player Shipments: In Progress"],
		data = function(data) return Garrison.getTableValue(data, "buildingCountCurrent", "shipment", "inProgress") end,
		type = Garrison.TYPE_BUILDING,
	},
	["csr"] = {
		name = L["Current Player Shipments: Ready"],
		data = function(data) return Garrison.getTableValue(data, "buildingCountCurrent", "shipment", "ready") end,
		type = Garrison.TYPE_BUILDING,
	},
	["csa"] = {
		name = L["Current Player Shipments: Available"],
		data = function(data) return Garrison.getTableValue(data, "buildingCountCurrent", "shipment", "available") end,
		type = Garrison.TYPE_BUILDING,
	},
	["res"] = {
		name = L["Garrison Resources"],
		data = function(data) return Garrison.getTableValue(data, "currencyAmount") or 0 end,
	},
	["resfmt"] = {
		name = L["Garrison Resources (Formatted)"],
		data = function(data) return _G.BreakUpLargeNumbers(Garrison.getTableValue(data, "currencyAmount") or 0) end,
	},
	["tres"] = {
		name = L["Garrison Resources (Total)"],
		data = function(data) return Garrison.getTableValue(data, "currencyTotal") or 0 end,
	},
	["tresfmt"] = {
		name = L["Garrison Resources (Total, Formatted)"],
		data = function(data) return _G.BreakUpLargeNumbers(Garrison.getTableValue(data, "currencyTotal") or 0) end,
	},
	["resicon"] = {
		name = L["Icon: Garrison Resource"],
		data = function(data) return Garrison.ICON_CURRENCY end,
	},
	["apexis"] = {
		name = L["Apexis Crystals"],
		data = function(data) return Garrison.getTableValue(data, "currencyApexisAmount") or 0 end,
	},
	["sotf"] = {
		name = L["Seal of Tempered Fate"],
		data = function(data) return Garrison.getTableValue(data, "currencySealOfTemperedFateAmount") or 0 end,
	},	
	["sotficon"] = {
		name = L["Icon: Seal of Tempered Fate"],
		data = function(data) return Garrison.ICON_CURRENCY_TEMPERED_FATE end,
	},	
	["tapexis"] = {
		name = L["Apexis Crystals (Total)"],
		data = function(data) return Garrison.getTableValue(data, "currencyApexisTotal") or 0 end,
	},
	["apexisicon"] = {
		name = L["Icon: Apexis Crystal"],
		data = function(data) return Garrison.ICON_CURRENCY_APEXIS end,
	},
	["cachewarning"] = {
		name = L["Resource Cache Warning Icon"],
		data = function(data) return (Garrison.getTableValue(data, "resourceCacheAmountMax") or 0) > 400 and Garrison.ICON_WARNING or "" end,
	},
	["crescache"] = {
		name = L["Current Player Resource Cache"],
		data = function(data) return Garrison.getTableValue(data, "resourceCacheAmount") or 0 end,
	},
	["rescachemax"] = {
		name = L["Max Resource Cache"],
		data = function(data) return Garrison.getTableValue(data, "resourceCacheAmountMax") or 0 end,
	},
	["rescachemaxchar"] = {
		name = L["Character Max Resource Cache"],
		data = function(data) 
			return Garrison.getTableValue(data, "resourceCacheAmountMaxChar", "playerName")
		end,
	},
	["cinvasion"] = {
		name = L["Current Player Invasion Available"],
		data = function(data) return (Garrison.getTableValue(data, "invasionAvailableCurrent") and Garrison.ICON_INVASION or "") end,
	},
	["invasion"] = {
		name = L["Invasion Available"],
		data = function(data) return (Garrison.getTableValue(data, "invasionAvailable") and Garrison.ICON_INVASION or "") end,
	},	
}
