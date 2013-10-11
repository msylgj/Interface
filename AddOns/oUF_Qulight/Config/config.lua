Qulight["media"] = {
	["font"] = [=[Interface\Addons\oUF_Qulight\Root\Media\qFont.ttf]=], 			        -- main font in Qulight UI
	["pxfont"] = [=[Interface\Addons\oUF_Qulight\Root\Media\pxFont.ttf]=],
	["fontsize"] = 10, 														    		-- size of font 
}
Qulight["general"] = {
	["AutoScale"] = true,  																-- mainly enabled for users that don't want to mess with the config file
	["UiScale"] = 0.75,																	-- set your value (between 0.64 and 1) of your uiscale if autoscale is off
}
Qulight["raidframes"] = {
	["enable"] = true,
	["scale"] = 1.0,
	["width"] = 76,
    ["height"] = 35,
    ["fontsize"] = 10,
    ["fontsizeEdge"] = 12,
    ["outline"] = "OUTLINE",
    ["solo"] = false,
    ["player"] = true,
    ["party"] = true,
	["altpower"] = false,
    ["numCol"] = 5,
    ["numUnits"] = 5,
    ["spacing"] = 4,
    ["orientation"] = "HORIZONTAL",
    ["porientation"] = "HORIZONTAL",
    ["horizontal"] = true, 
    ["growth"] = "TOP", 
    ["reversecolors"] = true,
    ["definecolors"] = true,
    ["powerbar"] = true,
    ["powerbarsize"] = 0.12,
    ["outsideRange"] = .40,
    ["healtext"] = false,
    ["healbar"] = false,
    ["healoverflow"] = true,
    ["healothersonly"] = false,
    ["healalpha"] = .40,
    ["roleicon"] = false,
    ["indicatorsize"] = 6,
    ["symbolsize"] = 11,
    ["leadersize"] = 12,
	["autorez"] = true,
    ["aurasize"] = 35,
    ["multi"] = false, --Use multiple headers for better group sorting. Note: This disables units per group and sets it to 5.
    ["deficit"] = false,
    ["perc"] = false,
    ["actual"] = false,
    ["myhealcolor"] = { 0, 1, 0.5, 0.4 },
    ["otherhealcolor"] = { 0, 1, 0, 0.4 },
    ["hpcolor"] = { 0.1, 0.1, 0.1, 1 },
    ["hpbgcolor"] = { 0.5, 0.5, 0.5, 1 },
    ["powercolor"] = { 1, 1, 1, 1 },
    ["powerbgcolor"] = { 0.33, 0.33, 0.33, 1 },
    ["powerdefinecolors"] = false,
    ["colorSmooth"] = false,
    ["gradient"] = { 1, 0, 0, 1 },
    ["tborder"] = false,
    ["fborder"] = false,
    ["afk"] = true,
    ["highlight"] = true,
    ["dispel"] = true,
    ["powerclass"] = true,
    ["tooltip"] = true,
    ["sortName"] = false,
    ["sortClass"] = false,
    ["classOrder"] = "DEATHKNIGHT,DRUID,HUNTER,MAGE,PALADIN,PRIEST,ROGUE,SHAMAN,WARLOCK,WARRIOR", --Uppercase English class names separated by a comma. \n { CLASS[,CLASS]... }"
    ["hidemenu"] = true,
}
Qulight["unitframes"] = {
	["enable"] = true,																	-- enable/disable action bars
	["HealthcolorClass"] = false,														-- health color = class color
	["bigcastbar"] = true,
	["Powercolor"] = true,																-- power color = class color
	["showtot"] = true, 																-- show target of target frame
	["showpet"] = true,																	-- show pet frame
	["showfocus"] = true, 																-- show focus frame
	["showfocustarget"] = true, 														-- show focus target frame
	["showBossFrames"] = true, 															-- show boss frame
	["TotemBars"] = true, 																-- show totem bars
	["MTFrames"] = true, 																-- show main tank frames
	["ArenaFrames"]  = true, 															-- show arena frame
	["Reputationbar"] = true, 															-- show reputation bar
	["Experiencebar"] = true, 															-- show experience bar
	["showPlayerAuras"] = false, 														-- use a custom player buffs/debuffs frame instead of blizzard's default.
	["showPortrait"] = true,															-- show portraits
	["showRunebar"] = true, 															-- show dk rune bar
	["showHolybar"] = true, 															-- show paladin HolyPower bar
	["showEclipsebar"] = true, 															-- show druid eclipse bar
	["showShardbar"] = true, 															-- show warlock soulShard bar
	["Castbars"] = true, 																-- use built-in castbars
}
Qulight["buffdebuff"] = {
	["enable"] = true,  
	["iconsize"] = 35, 																	-- buffs size
	["timefontsize"] = 10, 																-- time font size
	["countfontsize"] = 10,  															-- count font size
	["spacing"] = 3, 																	-- spacing between icons(buffs)
	["timeYoffset"] = -2, 																-- verticall offset value for time text field
	["BUFFS_PER_ROW"] = 15,
}

Qulight["misk"] = {																-- enable disable filger
	["classtimer"] = true,																-- enable disable classtimer
}  