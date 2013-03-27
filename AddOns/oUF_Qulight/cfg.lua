Qulight = { }
Qulight["media"] = {
	["font"] = [=[FONTS\ARKai_T.ttf]=], 			        -- main font in Qulight UI
	["pxfont"] = [=[FONTS\ARKai_T.ttf]=],----[=[FONTS\ARIALN.TTF]=],
	["fontsize"] = 12, 														    		-- size of font 
	["texture"] = "Interface\\AddOns\\oUF_Qulight\\Media\\statusbar4",				-- main texture in Qulight UI
	["blank"] = "Interface\\Buttons\\WHITE8x8",											-- clean texture
	["auratex"] = "Interface\\AddOns\\oUF_Qulight\\Media\\iconborder"
}

Qulight["unitframes"] = {
	["enable"] = true,																	-- 使用头像框体
	["HealthcolorClass"] = false,														-- 血条职业着色
	["bigcastbar"] = true,                                                                 --独立施法条
	["Powercolor"] = true,																-- 蓝条职业着色
	["showtot"] = true, 																-- 目标的目标
	["showpet"] = true,																	-- 宠物
	["showfocus"] = true, 																-- 焦点
	["showfocustarget"] = true, 														-- 焦点目标
	["solo"] = false,      																  	--单人时显示团队框体
    ["player"] = true,  																		--小队中显示玩家
    ["party"] = true,  																		--独立小队框体
	["showBossFrames"] = true, 														-- BOSS框体
	["TotemBars"] = true, 																-- 图腾条
	["MTFrames"] = false, 																-- 坦克框体
	["ArenaFrames"]  = true, 															-- 竞技场框体
	["Reputationbar"] = true, 															-- 声望条
	["Experiencebar"] = true, 															-- 经验条
	["showPlayerAuras"] = false, 														-- 玩家头像上BUFF/DEbuff
	["ThreatBar"] = true,																-- 仇恨条
	["showPortrait"] = true,															-- 3D头像
	["showRunebar"] = true, 															-- DK符文条
	["showHolybar"] = true, 															-- 圣骑圣能条
	["showEclipsebar"] = true, 															-- 德鲁伊月能条
	["showShardbar"] = true, 															-- 术士片片
	["showHarmonyBar"] = true,                                                       -- 武僧"和谐"条
	["showShadowOrbsBar"] = true,                                                     -- 牧师暗能条
	["Castbars"] = true, 																-- 施法条
	["Anchorplayer"] = {"TOPRIGHT", UIParent, "BOTTOM", -10, 220}, --玩家框体位置
	["AnchorAltPowerBar"] = {"BOTTOM", UIParent, "BOTTOM", 0, 300}, --特殊能量条位置
	["playersize"] = {220, 38}, --玩家框体大小
	["targetsize"] = {220, 38}, --目标框体大小
	["focussize"] = {180,34}, --焦点框体大小
	["partysize"] = {180, 34}, --小队框体大小
	["tanksize"] = {100, 22}, --坦克框体大小
	["bosssize"] = {150, 28}, --BOSS框体大小
	["arenasize"] = {150, 28}, --竞技场框体
	["totsize"] = {100, 28}, --目标的目标框体大小
	["focustargetsize"] = {100, 28}, --焦点目标框体大小
	["partytargetsize"] = {100, 28}, --小队目标框体大小
	["petsize"] = {100, 28}, --宠物框体大小
	["playerCastbarsize"] = {302, 18}, --玩家施法条大小
	["targetCastbarsize"] = {197, 18}, --目标施法条大小
	["focusCastbarsize"] = {162, 18}, --焦点施法条大小
	["Anchortarget"] = {"TOPLEFT", UIParent, "BOTTOM", 10, 220},  --目标框体位置
	["Anchorparty"] = {"TOPLEFT", UIParent, "RIGHT", -385, -120},  --小队框体位置
	["Anchortot"] = {"TOPLEFT", UIParent, "BOTTOM", 240, 213},   --目标的目标框体位置
	["Anchorpet"] = {"TOPRIGHT", UIParent, "BOTTOM", -250, 213},   --宠物框体位置
	["Anchorplayercastbar"] = {"BOTTOM", UIParent, "BOTTOM", 11, 125},  --玩家施法条位置(独立施法条)
	["Anchortargetcastbar"] = {"BOTTOM", UIParent, "BOTTOM", 11, 148}, --目标施法条位置(独立施法条)
	["Anchorfocus"] = {"BOTTOMLEFT", 100, 250},   --焦点框体位置
	["Anchorfocustarget"] = {"BOTTOMLEFT", 290, 250}, --焦点目标框体位置
	["Anchorfocuscastbar"] = {"TOP", UIParent, "TOP", 11, -300},   --焦点施法条位置(独立施法条)
	["Anchortank"] = {"BOTTOMLEFT", 310, 470},  --坦克框体位置
	["Anchorboss"] = {"BOTTOMRIGHT", -200, 550},  --BOSS框体位置
	["Anchorarena"] = {"TOP", UIParent, "BOTTOM", 500, 550} --竞技场框体位置
}

Qulight["raidframes"] = {
	["enable"] = true, --使用Qulight的团队框体
	["Anchorraid"] = {"TOPLEFT", UIParent, "RIGHT", -430, 45},  --团队(小队)框体位置
	["scale"] = 1,  --缩放
	["width"] = 75,  --每个框宽度
    ["height"] = 28,  --每个框高度
    ["fontsize"] = 10,  --字体大小
    ["fontsizeEdge"] = 9,  --状态字体大小
    ["outline"] = "OUTLINE",  --字体描边方式
    ["numCol"] = 5,  --显示队伍数目
    ["numUnits"] = 5,  --每行框体数目
    ["spacing"] = 4.1,  --间距
    ["orientation"] = "HORIZONTAL",   --血条方向
    ["porientation"] = "HORIZONTAL",  --蓝条方向
    ["horizontal"] = true,   --横向框体
    ["growth"] = "RIGHT",  --框体生长方向
    ["reversecolors"] = false,  --反向着色(为false时团队血条掉血颜色为高亮)
    ["definecolors"] = true,  --血条定义颜色(为false时血条职业着色)
    ["powerbar"] = true,  --显示蓝条
    ["powerbarsize"] = 0.12,  --蓝条高度
    ["outsideRange"] = 0.4,  --超出距离框体透明度
    ["healtext"] = false,   --正被治疗数字
    ["healbar"] = true,  --显示正被治疗
    ["healoverflow"] = false,  --显示过量治疗
    ["healothersonly"] = false,  --只显示他人施放治疗
    ["healalpha"] = 0.4, --治疗条透明度
    ["roleicon"] = true,  --职责图标
    ["indicatorsize"] = 6, --边角指示器大小
    ["symbolsize"] = 11,  --职责图标大小
    ["leadersize"] = 12,  --团队领袖图标大小
    ["aurasize"] = 18,  --中部DEBUFF提示图标大小
    ["multi"] = false, --Use multiple headers for better group sorting. Note: This disables units per group and sets it to 5.
    ["deficit"] = false,  --显示损失血量
    ["perc"] = false,  --显示百分比
    ["actual"] = false,  --显示当前血量
    ["autorez"] = true, --点击队友框体救人
	["myhealcolor"] = { 0, 1, 0.5, 0.4 },  --我施放的治疗颜色(rgb)
    ["otherhealcolor"] = { 0, 1, 0, 0.4 },  --他人施放的治疗颜色(rgb)
    ["hpcolor"] = { 0.1, 0.1, 0.1, 1 },  --血条颜色
    ["hpbgcolor"] = { 0.5, 0.5, 0.5, 1 },  --血条背景颜色
    ["powercolor"] = { 1, 1, 1, 1 },  --蓝条颜色
    ["powerbgcolor"] = { 0.33, 0.33, 0.33, 1 },  --蓝条背景颜色
    ["powerdefinecolors"] = false,  --定义蓝条颜色
    ["colorSmooth"] = false,  --颜色渐变
    ["gradient"] = { 1, 0, 0, 1 },  --渐变梯度
    ["tborder"] = true,  --仇恨边框
    ["fborder"] = false,  --焦点边框
    ["afk"] = true,  --显示AFK提示
    ["highlight"] = true,  --高亮
    ["dispel"] = true,  --显示可驱散
    ["powerclass"] = true,  --蓝条职业着色
    ["tooltip"] = true,  --提示
    ["sortName"] = false,  --按姓名排序
    ["sortClass"] = false,  --按职业排序
    ["classOrder"] = "DEATHKNIGHT,DRUID,HUNTER,MAGE,PALADIN,PRIEST,ROGUE,SHAMAN,WARLOCK,WARRIOR", --职业显示顺序
    ["hidemenu"] = true,  --战斗中隐藏团队框体右键菜单
}