local addon, ns = ...
local lib = ns.lib
oUF.colors.smooth = {.7, .15, .15, .85, .8, .45, .15, .15, .15}
-----------------------------
-- STYLE FUNCTIONS
-----------------------------
local function CreatePlayerStyle(self, unit, isSingle)
	self.mystyle = "player"
	lib.init(self)
	self.scale = scale
	self:SetSize(unpack(Qulight["unitframes"].playersize))
	lib.gen_hpbar(self)
	lib.gen_hpstrings(self)
	lib.gen_highlight(self)
	lib.gen_ppbar(self)
	lib.gen_RaidMark(self)
	lib.createDebuffs(self)
	if Qulight["unitframes"].showPlayerAuras then
		BuffFrame:Hide()
		lib.createBuffs(self)
	end
	self.Health.frequentUpdates = true
	if Qulight["unitframes"].HealthcolorClass then
	self.Health.colorClass = true
	end
	if Qulight["unitframes"].Powercolor then
	self.Power.colorClass = true
	else
	self.Power.colorPower = true
	end
	self.Power.frequentUpdates = true
	self.Power.bg.multiplier = 0.1
	if not Qulight["unitframes"].bigcastbar then
	lib.gen_castbar(self)
	else
	lib.gen_bigcastbar(self)
	end
	
	lib.gen_InfoIcons(self)
	lib.CreateThreatBorder(self)
	lib.Experience(self)
	lib.Reputation(self)
	lib.ThreatBar(self)
	if Qulight["unitframes"].showPortrait then lib.gen_portrait(self) end
	if Qulight["unitframes"].showRunebar then lib.genRunes(self) end
	if Qulight["unitframes"].showHolybar then lib.genHolyPower(self) end
	if Qulight["unitframes"].showShardbar then lib.genShards(self) end
	if Qulight["unitframes"].TotemBars then lib.TotemBars(self) end
	if Qulight["unitframes"].showEclipsebar then lib.addEclipseBar(self) end
	if Qulight["unitframes"].showHarmonyBar then lib.genHarmony(self) end
	if Qulight["unitframes"].showShadowOrbsBar then lib.genShadowOrbsBar(self) end
	self:RegisterEvent("UNIT_THREAT_LIST_UPDATE", lib.UpdateThreat)
	self:RegisterEvent("UNIT_THREAT_SITUATION_UPDATE", lib.UpdateThreat)
end
local function CreateTargetStyle(self, unit, isSingle)
	self.mystyle = "target"
	lib.init(self)
	self.scale = scale
    self.SpellRange = {
		insideAlpha = 1,
		outsideAlpha = Qulight["raidframes"].outsideRange,}
	self:SetSize(unpack(Qulight["unitframes"].targetsize))
	lib.gen_hpbar(self)
	lib.gen_hpstrings(self)
	lib.gen_highlight(self)
	lib.gen_ppbar(self)
	lib.gen_RaidMark(self)
	lib.gen_mirrorcb(self)
	self.Health.frequentUpdates = false
	if Qulight["unitframes"].HealthcolorClass then
	self.Health.colorClass = true
	self.Health.colorReaction = true
	end
	self.Power.colorTapping = true
	self.Power.colorDisconnected = true
	if Qulight["unitframes"].Powercolor then
	self.Power.colorClass = true
	else
	self.Power.colorPower = true
	end
	self.Power.colorReaction = true
	self.Power.bg.multiplier = 0.1
	if not Qulight["unitframes"].bigcastbar then
	lib.gen_castbar(self)
	else
	lib.gen_bigcastbar(self)
	end
	
	lib.addQuestIcon(self)
	lib.createAuras(self)
	lib.genCPoints(self)
	if Qulight["unitframes"].showPortrait then lib.gen_portrait(self) end
end
local function CreateFocusStyle(self, unit, isSingle)
	self.mystyle = "focus"
	lib.init(self)
	self.scale = scale
    self.SpellRange = {
		insideAlpha = 1,
		outsideAlpha = Qulight["raidframes"].outsideRange,	}
	self:SetSize(unpack(Qulight["unitframes"].focussize))
	lib.gen_hpbar(self)
	lib.gen_hpstrings(self)
	lib.gen_highlight(self)
	lib.gen_ppbar(self)
	
	self.Power.colorTapping = true
	self.Power.colorDisconnected = true
	if Qulight["unitframes"].Powercolor then
	self.Power.colorClass = true
	else
	self.Power.colorPower = true
	end
	self.Power.colorReaction = true
	self.Power.colorHealth = true
	self.Power.bg.multiplier = 0.1
	lib.gen_RaidMark(self)
	self.Health.frequentUpdates = false
	if Qulight["unitframes"].HealthcolorClass then
	self.Health.colorClass = true
	self.Health.colorReaction = true
	end
	if not Qulight["unitframes"].bigcastbar then
	lib.gen_castbar(self)
	else
	lib.gen_bigcastbar(self)
	end
	lib.createAuras(self)
	if Qulight["unitframes"].showPortrait then lib.gen_portrait(self) end
end
local function CreateToTStyle(self, unit, isSingle)
	self.mystyle = "tot"
	lib.init(self)
	self.scale = scale
    self.SpellRange = {
		insideAlpha = 1,
		outsideAlpha = Qulight["raidframes"].outsideRange,	}
	self:SetSize(unpack(Qulight["unitframes"].totsize))
	lib.gen_hpbar(self)
	lib.gen_hpstrings(self)
	lib.gen_highlight(self)
	lib.gen_RaidMark(self)
	lib.createAuras(self)
	lib.gen_ppbar(self)
	self.Power.colorReaction = true
	if Qulight["unitframes"].Powercolor then
	self.Power.colorClass = true
	else
	self.Power.colorPower = true
	end
	self.Power.colorHealth = true
	self.Power.bg.multiplier = 0.5
	
	self.Health.frequentUpdates = false
	if Qulight["unitframes"].HealthcolorClass then
	self.Health.colorClass = true
	self.Health.colorReaction = true
	end
	if Qulight["unitframes"].showPortrait then lib.gen_portrait(self) end
end	
local function CreateFocusTargetStyle(self, unit, isSingle)
	self.mystyle = "focustarget"
	lib.init(self)
	self.scale = scale
    self.SpellRange = {
		insideAlpha = 1,
		outsideAlpha = Qulight["raidframes"].outsideRange,	}
	self:SetSize(unpack(Qulight["unitframes"].focustargetsize))
	lib.gen_hpbar(self)
	lib.gen_hpstrings(self)
	lib.gen_ppbar(self)
	if Qulight["unitframes"].Powercolor then
	self.Power.colorClass = true
	else
	self.Power.colorPower = true
	end
	self.Power.colorReaction = true
	self.Power.colorHealth = true
	self.Power.bg.multiplier = 0.5
	lib.gen_highlight(self)
	lib.gen_RaidMark(self)
	
	self.Health.frequentUpdates = false
	if Qulight["unitframes"].HealthcolorClass then
	self.Health.colorClass = true
	self.Health.colorReaction = true
	end
	if Qulight["unitframes"].showPortrait then lib.gen_portrait(self) end
end	
local function CreatePetStyle(self, unit, isSingle)
	local _, playerClass = UnitClass("player")
	self.mystyle = "pet"
	lib.init(self)
	self.scale = scale
	self:SetSize(unpack(Qulight["unitframes"].petsize))
	lib.gen_hpbar(self)
	lib.gen_hpstrings(self)
	lib.gen_ppbar(self)
	self.Power.colorReaction = true
	self.Power.colorHealth = true
	self.Power.colorClass = true
	self.Power.bg.multiplier = 0.5
	lib.gen_highlight(self)
	lib.gen_RaidMark(self)
	self.Health.frequentUpdates = false
	if PlayerClass == "HUNTER" then
		self.Power.colorReaction = false
		self.Power.colorClass = false
	end
	if Qulight["unitframes"].showPortrait then lib.gen_portrait(self) end
end
local function CreateBossStyle(self, unit, isSingle)
	self.mystyle = "boss"
	self:SetSize(unpack(Qulight["unitframes"].bosssize))
	lib.gen_hpbar(self)
	lib.gen_hpstrings(self)
	lib.gen_highlight(self)
	lib.gen_RaidMark(self)
	lib.gen_ppbar(self)
	self.Power.colorTapping = true
	self.Power.colorDisconnected = true
	self.Power.colorClass = true
	self.Power.colorReaction = true
	self.Power.colorHealth = true
	self.Power.bg.multiplier = 0.5
	lib.gen_castbar(self)
	lib.AltPowerBar(self)
	lib.createBuffs(self)
	lib.createDebuffs(self)
	lib.CreateTargetBorder(self)
	self.Health.frequentUpdates = false
	if Qulight["unitframes"].showPortrait then lib.gen_portrait(self) end
end
local function CreateMTStyle(self)
	self.mystyle = "oUF_MT"
	self:SetSize(unpack(Qulight["unitframes"].tanksize))
	lib.gen_hpbar(self)
	lib.gen_hpstrings(self)
	lib.gen_highlight(self)
	lib.gen_RaidMark(self)
	self.Health.frequentUpdates = false
	if Qulight["unitframes"].HealthcolorClass then
	self.Health.colorClass = true
	self.Health.colorReaction = true
	end
	if Qulight["unitframes"].showPortrait then lib.gen_portrait(self) end
end
local function CreateArenaStyle(self, unit, isSingle)
	self.mystyle = "oUF_Arena"
	self:SetSize(unpack(Qulight["unitframes"].arenasize))
	lib.gen_hpbar(self)
	lib.gen_hpstrings(self)
	lib.gen_highlight(self)
	lib.gen_RaidMark(self)
	lib.gen_ppbar(self)
	self.Power.colorTapping = true
	self.Power.colorDisconnected = true
	if Qulight["unitframes"].Powercolor then
	self.Power.colorClass = true
	else
	self.Power.colorPower = true
	end
	self.Power.colorReaction = true
	self.Power.colorHealth = true
	self.Power.bg.multiplier = 0.5
	lib.gen_castbar(self)
	lib.createBuffs(self)
	lib.createDebuffs(self)
	self.Health.frequentUpdates = false
	if Qulight["unitframes"].HealthcolorClass then
	self.Health.colorClass = true
	self.Health.colorReaction = true
	end
	if Qulight["unitframes"].showPortrait then lib.gen_portrait(self) end
end
-----------------------------
-- SPAWN UNITS
-----------------------------
oUF:RegisterStyle("Player", CreatePlayerStyle)
oUF:RegisterStyle("Target", CreateTargetStyle)
oUF:RegisterStyle("ToT", CreateToTStyle)
oUF:RegisterStyle("Focus", CreateFocusStyle)
oUF:RegisterStyle("FocusTarget", CreateFocusTargetStyle)
oUF:RegisterStyle("Pet", CreatePetStyle)
oUF:RegisterStyle("Boss", CreateBossStyle)
oUF:RegisterStyle("oUF_MT", CreateMTStyle)
oUF:RegisterStyle("oUF_Arena", CreateArenaStyle)

if not Qulight["unitframes"].enable == true then return end
oUF:Factory(function(self)
	self:SetActiveStyle("Player")
	local player = self:Spawn("player", "oUF_Player")
	player:SetPoint(unpack(Qulight["unitframes"].Anchorplayer))
	self:SetActiveStyle("Target")
	local target = self:Spawn("Target", "oUF_Target")
	target:SetPoint(unpack(Qulight["unitframes"].Anchortarget))
	if Qulight["unitframes"].showtot then
		self:SetActiveStyle("ToT")
		local targettarget = self:Spawn("targettarget", "oUF_tot")
		targettarget:SetPoint(unpack(Qulight["unitframes"].Anchortot))
	end
	if Qulight["unitframes"].showpet then
		self:SetActiveStyle("Pet")
		local pet = self:Spawn("pet", "oUF_pet")
		pet:SetPoint(unpack(Qulight["unitframes"].Anchorpet))
	end
	if Qulight["unitframes"].showfocus then 
		self:SetActiveStyle("Focus")
		local focus = self:Spawn("focus", "oUF_focus")
		focus:SetPoint(unpack(Qulight["unitframes"].Anchorfocus))
	end
	if Qulight["unitframes"].showfocustarget then 
		self:SetActiveStyle("FocusTarget")
		local focustarget = self:Spawn("focustarget", "oUF_focustarget")
		focustarget:SetPoint(unpack(Qulight["unitframes"].Anchorfocustarget))
	end
	if Qulight["unitframes"].MTFrames then
		self:SetActiveStyle("oUF_MT")
		local tank = self:SpawnHeader('oUF_MT', nil, 'raid',
			'showRaid', true,
			'groupFilter', 'MAINTANK',
			'yOffset', 8,
			'point' , 'BOTTOM',
			'template', 'oUF_MainTank')
		tank:SetPoint(unpack(Qulight["unitframes"].Anchortank))
    end
	if Qulight["unitframes"].showBossFrames then
		self:SetActiveStyle("Boss")
		local boss = {}
			for i = 1, MAX_BOSS_FRAMES do
				boss[i] = self:Spawn("boss"..i, "oUF_Boss"..i)
				if i == 1 then
					boss[i]:SetPoint(unpack(Qulight["unitframes"].Anchorboss))
				else
					boss[i]:SetPoint("BOTTOMRIGHT", boss[i-1], "BOTTOMRIGHT", 0, 50)
			end
		end
	end
	
	if Qulight["unitframes"].ArenaFrames then
	self:SetActiveStyle("oUF_Arena")
	local arena = {}
	for i = 1, 5 do
		arena[i] = self:Spawn("arena"..i, "oUF_Arena"..i)
		if i == 1 then
			arena[i]:SetPoint(unpack(Qulight["unitframes"].Anchorarena))
		else
			arena[i]:SetPoint("BOTTOM", arena[i-1], "TOP", 0, 35)
		end
		arena[i]:SetSize(unpack(Qulight["unitframes"].arenasize))
	end	
	end
end)

PetCastingBarFrame:UnregisterAllEvents()
PetCastingBarFrame.Show = function() end
PetCastingBarFrame:Hide()
--Ãÿ ‚Ãı
local AltPowerBar = CreateFrame("Frame", "AltPowerBarHolder", UIParent)
AltPowerBar:SetPoint(unpack(Qulight["unitframes"].AnchorAltPowerBar))
AltPowerBar:SetSize(128, 50)

PlayerPowerBarAlt:ClearAllPoints()
PlayerPowerBarAlt:SetPoint("CENTER", AltPowerBar, "CENTER")
PlayerPowerBarAlt:SetParent(AltPowerBar)
PlayerPowerBarAlt.ignoreFramePositionManager = true
	
do
	UnitPopupMenus["SELF"] = {"PVP_FLAG", "LOOT_METHOD", "SELECT_LOOT_SPECIALIZATION", "LOOT_THRESHOLD", "OPT_OUT_LOOT_TITLE", "LOOT_PROMOTE", "CONVERT_TO_RAID", "CONVERT_TO_PARTY", "DUNGEON_DIFFICULTY", "RAID_DIFFICULTY", "RESET_INSTANCES", "RESET_CHALLENGE_MODE", "RAID_TARGET_ICON", "SELECT_ROLE", "INSTANCE_LEAVE", "LEAVE", "CANCEL"}
	UnitPopupMenus["PET"] = {"RAID_TARGET_ICON", "PET_PAPERDOLL", "PET_RENAME", "PET_ABANDON", "PET_DISMISS", "CANCEL"}
	UnitPopupMenus["OTHERPET"] = {"RAID_TARGET_ICON", "REPORT_PET", "CANCEL"}
	UnitPopupMenus["PARTY"] = {"ADD_FRIEND", "ADD_FRIEND_MENU", "MUTE", "UNMUTE", "PARTY_SILENCE", "PARTY_UNSILENCE", "RAID_SILENCE", "RAID_UNSILENCE", "BATTLEGROUND_SILENCE", "BATTLEGROUND_UNSILENCE", "WHISPER", "PROMOTE", "PROMOTE_GUIDE", "LOOT_PROMOTE", "VOTE_TO_KICK", "UNINVITE", "INSPECT", "ACHIEVEMENTS", "TRADE", "FOLLOW", "DUEL", "PET_BATTLE_PVP_DUEL", "RAID_TARGET_ICON", "SELECT_ROLE", "PVP_REPORT_AFK", "RAF_SUMMON", "RAF_GRANT_LEVEL", "REPORT_PLAYER", "CANCEL"}
	UnitPopupMenus["PLAYER"] = {"ADD_FRIEND", "ADD_FRIEND_MENU", "WHISPER", "INSPECT", "ACHIEVEMENTS", "INVITE", "TRADE", "FOLLOW", "DUEL", "PET_BATTLE_PVP_DUEL", "RAID_TARGET_ICON", "RAF_SUMMON", "RAF_GRANT_LEVEL", "REPORT_PLAYER", "CANCEL"}
	UnitPopupMenus["RAID_PLAYER"] = {"ADD_FRIEND", "ADD_FRIEND_MENU", "MUTE", "UNMUTE", "RAID_SILENCE", "RAID_UNSILENCE", "BATTLEGROUND_SILENCE", "BATTLEGROUND_UNSILENCE", "WHISPER", "INSPECT", "ACHIEVEMENTS", "TRADE", "FOLLOW", "DUEL", "PET_BATTLE_PVP_DUEL", "RAID_TARGET_ICON", "SELECT_ROLE", "RAID_LEADER", "RAID_PROMOTE", "RAID_DEMOTE", "LOOT_PROMOTE", "VOTE_TO_KICK", "RAID_REMOVE", "PVP_REPORT_AFK", "RAF_SUMMON", "RAF_GRANT_LEVEL", "REPORT_PLAYER", "CANCEL"}
	UnitPopupMenus["RAID"] = {"MUTE", "UNMUTE", "RAID_SILENCE", "RAID_UNSILENCE", "BATTLEGROUND_SILENCE", "BATTLEGROUND_UNSILENCE", "RAID_LEADER", "RAID_PROMOTE", "RAID_MAINTANK", "RAID_MAINASSIST", "LOOT_PROMOTE", "RAID_DEMOTE", "VOTE_TO_KICK", "RAID_REMOVE", "PVP_REPORT_AFK", "REPORT_PLAYER", "CANCEL"}
	UnitPopupMenus["VEHICLE"] = {"RAID_TARGET_ICON", "VEHICLE_LEAVE", "CANCEL"}
	UnitPopupMenus["TARGET"] = {"ADD_FRIEND", "ADD_FRIEND_MENU", "RAID_TARGET_ICON", "CANCEL"}
	UnitPopupMenus["ARENAENEMY"] = {"CANCEL"}
	UnitPopupMenus["FOCUS"] = {"RAID_TARGET_ICON", "CANCEL"}
	UnitPopupMenus["BOSS"] = {"RAID_TARGET_ICON", "CANCEL"}
end