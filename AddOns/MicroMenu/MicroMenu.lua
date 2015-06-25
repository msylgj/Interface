--Modify From NDui
--msylgj0
--thx to siweia :P

--config start--
local MicroMenuPos = {"BOTTOM", UIParent, "BOTTOM", -120, -1}
local Scale = 0.75
--config end--

local Media = "Interface\\Addons\\MicroMenu\\Media\\"
local bdTex = "Interface\\ChatFrame\\ChatFrameBackground"
local glowTex = Media.."glowTex"
local InfoColor = "|cff70C0F5"
local myClass = select(2, UnitClass("player"))
local color = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[myClass]
local faction = UnitFactionGroup("player")

local MB = CreateFrame("frame", nil, UIParent)
MB:SetSize(210, 20)
MB:SetScale(Scale)
MB:SetPoint(unpack(MicroMenuPos))
MB:RegisterEvent("PLAYER_ENTERING_WORLD")
MB:SetScript("OnEvent", function()
	MB:UnregisterEvent("PLAYER_ENTERING_WORLD")
	--in case of first call in combat
	ToggleAllBags()
	ToggleAllBags()
end)

local function CreateBD(f, a, s)
	f:SetBackdrop({
		bgFile = bdTex, edgeFile = glowTex, edgeSize = s or 4,
		insets = {left = s or 4, right = s or 4, top = s or 4, bottom = s or 4},
	})
	f:SetBackdropColor(0, 0, 0, a or 0.5)
	f:SetBackdropBorderColor(0, 0, 0)
end

local function CreateMM(f, t)
	f:SetSize(50, 50)
	f:SetFrameStrata("BACKGROUND")
	f:SetBackdrop({bgFile = Media..t})
	f:SetBackdropColor(color.r, color.g, color.b, 1)
end

local function CreateMB(f, parent, w, h, x, y)
	f:SetSize(w, h)
	f:SetPoint("CENTER", parent, "CENTER", x, y)
	CreateBD(f, 1)
	f:SetFrameLevel(parent:GetFrameLevel() - 1)
	f:SetAlpha(0)
end

local function key(text, action)
	if GetBindingKey(action) then
		return text.." ("..GetBindingText(GetBindingKey(action))..")", color.r, color.g, color.b
	else
		return text, color.r, color.g, color.b
	end
end

local MB1 = CreateFrame("frame", nil, MB)
MB1:SetPoint("CENTER", MB, "CENTER", -50, 0)
CreateMM(MB1, "micro_player")
local MB1BG = CreateFrame("button", nil, MB1)
CreateMB(MB1BG, MB1, 35, 20, -6, 0)
MB1BG:SetScript("OnEnter", function(self)
	self:SetAlpha(0.7)
	GameTooltip:SetOwner(self, 'ANCHOR_TOP')
	GameTooltip:AddLine(key(CHARACTER_BUTTON, "TOGGLECHARACTER0"))
	GameTooltip:Show()
end)
MB1BG:SetScript("OnLeave", function(self)
	GameTooltip:Hide()
	self:SetAlpha(0)
end)
MB1BG:SetScript("OnClick", function(self)
	ToggleFrame(CharacterFrame)
end)

local MB2 = CreateFrame("frame", nil, MB)
MB2:SetPoint("CENTER", MB, "CENTER", -24, 0)
CreateMM(MB2, "micro_spellbook")
local MB2BG = CreateFrame("button", nil, MB2)
CreateMB(MB2BG, MB2, 24, 20, 0, 0)
MB2BG:SetScript("OnEnter", function(self)
	self:SetAlpha(0.7)
	GameTooltip:SetOwner(self, 'ANCHOR_TOP')
	GameTooltip:AddLine(key(SPELLBOOK_ABILITIES_BUTTON, "TOGGLESPELLBOOK"))
	GameTooltip:Show()
end)
MB2BG:SetScript("OnLeave", function(self)
	GameTooltip:Hide()
	self:SetAlpha(0)
end)
ToggleFrame(SpellBookFrame)	-- prevent taint
MB2BG:SetScript("OnClick", function(self)
	ToggleFrame(SpellBookFrame)
end)

local MB3 = CreateFrame("frame", nil, MB)
MB3:SetPoint("CENTER", MB, "CENTER", 2, 0)
CreateMM(MB3, "micro_talents")
local MB3BG = CreateFrame("button", nil, MB3)
CreateMB(MB3BG, MB3, 24, 20, 0, 0)
MB3BG:SetScript("OnEnter", function(self)
	self:SetAlpha(0.7)
	GameTooltip:SetOwner(self, 'ANCHOR_TOP')
	GameTooltip:AddLine(key(TALENTS_BUTTON, "TOGGLETALENTS"))
	GameTooltip:Show()
end)
MB3BG:SetScript("OnLeave", function(self)
	GameTooltip:Hide()
	self:SetAlpha(0)
end)
MB3BG:SetScript("OnClick", function(self)
	if not PlayerTalentFrame then LoadAddOn("Blizzard_TalentUI") end
	if UnitLevel("player") < SHOW_SPEC_LEVEL then
		UIErrorsFrame:AddMessage(InfoColor..format(FEATURE_BECOMES_AVAILABLE_AT_LEVEL, SHOW_SPEC_LEVEL))
	else
		ToggleFrame(PlayerTalentFrame)
	end
end)

local MB4 = CreateFrame("frame", nil, MB)
MB4:SetPoint("CENTER", MB, "CENTER", 28, 0)
CreateMM(MB4, "micro_achievements")
local MB4BG = CreateFrame("button", nil, MB4)
CreateMB(MB4BG, MB4, 24, 20, 0, 0)
MB4BG:SetScript("OnEnter", function(self)
	self:SetAlpha(0.7)
	GameTooltip:SetOwner(self, 'ANCHOR_TOP')
	GameTooltip:AddLine(key(ACHIEVEMENT_BUTTON, "TOGGLEACHIEVEMENT"))
	GameTooltip:Show()
end)
MB4BG:SetScript("OnLeave", function(self)
	GameTooltip:Hide()
	self:SetAlpha(0)
end)
MB4BG:SetScript("OnClick", function(self)
	ToggleAchievementFrame()
end)

local MB5 = CreateFrame("frame", nil, MB)
MB5:SetPoint("CENTER", MB, "CENTER", 54, 0)
CreateMM(MB5, "micro_quests")
local MB5BG = CreateFrame("button", nil, MB5)
CreateMB(MB5BG, MB5, 24, 20, 0, 0)
MB5BG:SetScript("OnEnter", function(self)
	self:SetAlpha(0.7)
	GameTooltip:SetOwner(self, 'ANCHOR_TOP')
	GameTooltip:AddLine(key(QUESTLOG_BUTTON, "TOGGLEQUESTLOG"))
	GameTooltip:Show()
end)
MB5BG:SetScript("OnLeave", function(self)
	GameTooltip:Hide()
	self:SetAlpha(0)
end)
MB5BG:SetScript("OnClick", function(self)
	ToggleFrame(WorldMapFrame)
end)

local MB6 = CreateFrame("frame", nil, MB)
MB6:SetPoint("CENTER", MB, "CENTER", 80, 0)
CreateMM(MB6, "micro_guild")
local MB6BG = CreateFrame("button", nil, MB6)
CreateMB(MB6BG, MB6, 24, 20, 0, 0)
MB6BG:SetScript("OnEnter", function(self)
	self:SetAlpha(0.7)
	GameTooltip:SetOwner(self, 'ANCHOR_TOP')
	if IsInGuild() then
		GameTooltip:AddLine(key(GUILD, "TOGGLEGUILDTAB"))
	else
		GameTooltip:AddLine(key(LOOKINGFORGUILD, "TOGGLEGUILDTAB"))
	end
	GameTooltip:Show()
end)
MB6BG:SetScript("OnLeave", function(self)
	GameTooltip:Hide()
	self:SetAlpha(0)
end)
MB6BG:SetScript("OnClick", function(self)
	if IsTrialAccount() then
		UIErrorsFrame:AddMessage(InfoColor..ERR_GUILD_TRIAL_ACCOUNT)
	elseif faction == "Neutral" then
		UIErrorsFrame:AddMessage(InfoColor..FEATURE_NOT_AVAILBLE_PANDAREN)
	elseif IsInGuild() then
		if not GuildFrame then LoadAddOn("Blizzard_GuildUI") end
		ToggleFrame(GuildFrame)
	else
		if not LookingForGuildFrame then LoadAddOn("Blizzard_LookingForGuildUI") end
		LookingForGuildFrame_Toggle()
	end
end)

local MB7 = CreateFrame("frame", nil, MB)
MB7:SetPoint("CENTER", MB, "CENTER", 106, 0)
CreateMM(MB7, "micro_pvp")
local MB7BG = CreateFrame("button", nil, MB7)
CreateMB(MB7BG, MB7, 24, 20, 0, 0)
MB7BG:SetScript("OnEnter", function(self)
	self:SetAlpha(0.7)
	GameTooltip:SetOwner(self, 'ANCHOR_TOP')
	GameTooltip:AddLine(key(PLAYER_V_PLAYER, "TOGGLECHARACTER4"))
	GameTooltip:Show()
end)
MB7BG:SetScript("OnLeave", function(self)
	GameTooltip:Hide()
	self:SetAlpha(0)
end)
MB7BG:SetScript("OnClick", function(self)
	if faction == "Neutral" then
		UIErrorsFrame:AddMessage(InfoColor..FEATURE_NOT_AVAILBLE_PANDAREN)
	elseif UnitLevel("player") < LFDMicroButton.minLevel then
		UIErrorsFrame:AddMessage(InfoColor..format(FEATURE_BECOMES_AVAILABLE_AT_LEVEL, LFDMicroButton.minLevel))
	else
		TogglePVPUI()
	end
end)

local MB8 = CreateFrame("frame", nil, MB)
MB8:SetPoint("CENTER", MB, "CENTER", 132, 0)
CreateMM(MB8, "micro_LFD")
local MB8BG = CreateFrame("button", nil, MB8)
CreateMB(MB8BG, MB8, 24, 20, 0, 0)
MB8BG:SetScript("OnEnter", function(self)
	self:SetAlpha(0.7)
	GameTooltip:SetOwner(self, 'ANCHOR_TOP')
	GameTooltip:AddLine(key(DUNGEONS_BUTTON, "TOGGLEGROUPFINDER"))
	GameTooltip:Show()
end)
MB8BG:SetScript("OnLeave", function(self)
	GameTooltip:Hide()
	self:SetAlpha(0)
end)
MB8BG:SetScript("OnClick", function(self)
	if faction == "Neutral" then
		UIErrorsFrame:AddMessage(InfoColor..FEATURE_NOT_AVAILBLE_PANDAREN)
	elseif UnitLevel("player") < LFDMicroButton.minLevel then
		UIErrorsFrame:AddMessage(InfoColor..format(FEATURE_BECOMES_AVAILABLE_AT_LEVEL, LFDMicroButton.minLevel))
	else
		PVEFrame_ToggleFrame()
	end
end)

local MB9 = CreateFrame("frame", nil, MB)
MB9:SetPoint("CENTER", MB, "CENTER", 158, 0)
CreateMM(MB9, "micro_encounter")
local MB9BG = CreateFrame("button", nil, MB9)
CreateMB(MB9BG, MB9, 24, 20, 0, 0)
MB9BG:SetScript("OnEnter", function(self)
	self:SetAlpha(0.7)
	GameTooltip:SetOwner(self, 'ANCHOR_TOP')
	GameTooltip:AddLine(key(ADVENTURE_JOURNAL, "TOGGLEENCOUNTERJOURNAL"))
	GameTooltip:Show()
end)
MB9BG:SetScript("OnLeave", function(self)
	GameTooltip:Hide()
	self:SetAlpha(0)
end)
MB9BG:SetScript("OnClick", function(self)
	if not EncounterJournal then LoadAddOn("Blizzard_EncounterJournal") end
	ToggleFrame(EncounterJournal)
end)

local MB10 = CreateFrame("frame", nil, MB)
MB10:SetPoint("CENTER", MB, "CENTER", 184, 0)
CreateMM(MB10, "micro_pets")
local MB10BG = CreateFrame("button", nil, MB10)
CreateMB(MB10BG, MB10, 24, 20, 0, 0)
MB10BG:SetScript("OnEnter", function(self)
	self:SetAlpha(0.7)
	GameTooltip:SetOwner(self, 'ANCHOR_TOP')
	GameTooltip:AddLine(key(COLLECTIONS, "TOGGLECOLLECTIONS"))
	GameTooltip:Show()
end)
MB10BG:SetScript("OnLeave", function(self)
	GameTooltip:Hide()
	self:SetAlpha(0)
end)
MB10BG:SetScript("OnClick", function(self)
	ToggleCollectionsJournal()
end)

local MB11 = CreateFrame("frame", nil, MB)
MB11:SetPoint("CENTER", MB, "CENTER", 210, 0)
CreateMM(MB11, "micro_store")
local MB11BG = CreateFrame("button", nil, MB11)
CreateMB(MB11BG, MB11, 24, 20, 0, 0)
MB11BG:SetScript("OnEnter", function(self)
	self:SetAlpha(0.7)
	GameTooltip:SetOwner(self, 'ANCHOR_TOP')
	GameTooltip:AddLine(BLIZZARD_STORE, color.r, color.g, color.b)
	GameTooltip:Show()
end)
MB11BG:SetScript("OnLeave", function(self)
	GameTooltip:Hide()
	self:SetAlpha(0)
end)
MB11BG:SetScript("OnClick", function(self)
	if IsTrialAccount() then
		UIErrorsFrame:AddMessage(InfoColor..ERR_GUILD_TRIAL_ACCOUNT)
	elseif C_StorePublic.IsDisabledByParentalControls() then
		UIErrorsFrame:AddMessage(InfoColor..BLIZZARD_STORE_ERROR_PARENTAL_CONTROLS)
	else
		ToggleStoreUI()
	end
end)

local MB12 = CreateFrame("frame", nil, MB)
MB12:SetPoint("CENTER", MB, "CENTER", 236, 0)
CreateMM(MB12, "micro_gm")
local MB12BG = CreateFrame("button", nil, MB12)
CreateMB(MB12BG, MB12, 24, 20, 0, 0)
MB12BG:SetScript("OnEnter", function(self)
	self:SetAlpha(0.7)
	GameTooltip:SetOwner(self, 'ANCHOR_TOP')
	GameTooltip:AddLine(HELP_BUTTON, color.r, color.g, color.b)
	GameTooltip:Show()
end)
MB12BG:SetScript("OnLeave", function(self)
	GameTooltip:Hide()
	self:SetAlpha(0)
end)
MB12BG:SetScript("OnClick", function(self)
	ToggleFrame(HelpFrame)
end)

local MB13 = CreateFrame("frame", nil, MB)
MB13:SetPoint("CENTER", MB, "CENTER", 262, 0)
CreateMM(MB13, "micro_settings")
local MB13BG = CreateFrame("button", nil, MB13)
CreateMB(MB13BG, MB13, 24, 20, 0, 0)
MB13BG:SetScript("OnEnter", function(self)
	self:SetAlpha(0.7)
	GameTooltip:SetOwner(self, 'ANCHOR_TOP')
	GameTooltip:AddLine(MAIN_MENU, color.r, color.g, color.b)
	GameTooltip:Show()
end)
MB13BG:SetScript("OnLeave", function(self)
	GameTooltip:Hide()
	self:SetAlpha(0)
end)
MB13BG:SetScript("OnClick", function(self)
	ToggleFrame(GameMenuFrame)
	PlaySound("igMiniMapOpen")
end)

local MB14 = CreateFrame("frame", nil, MB)
MB14:SetPoint("CENTER", MB, "CENTER", 299, 0)
CreateMM(MB14, "micro_bags")
local MB14BG = CreateFrame("button", nil, MB14)
CreateMB(MB14BG, MB14, 35, 20, -6, 0)
MB14BG:SetScript("OnEnter", function(self)
	self:SetAlpha(0.7)
	GameTooltip:SetOwner(self, 'ANCHOR_TOP')
	GameTooltip:AddLine(key(BAGSLOT, "OPENALLBAGS"))
	GameTooltip:Show()
end)
MB14BG:SetScript("OnLeave", function(self)
	GameTooltip:Hide()
	self:SetAlpha(0)
end)
MB14BG:SetScript("OnClick", function(self)
	ToggleAllBags()
end)