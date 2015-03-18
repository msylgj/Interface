local macro = CreateFrame('button', nil, nil, 'SecureActionButtonTemplate, SecureHandlerBaseTemplate')
macro:SetAttribute('type', 'macro')
macro:RegisterForClicks('AnyUp', 'AnyDown')
macro:SetAttribute('downbutton', 'Button31')

macro:WrapScript(macro, 'OnClick', [[ -- self, button, down
	local parent = self:GetParent():GetName()
	self:SetAttribute('*macrotext31', '/click ' .. parent .. ' ' .. button .. '\n/click StaticPopup1Button1')
	if strfind(parent, 'Talent') then
		self:SetAttribute('macrotext1', '/click PlayerTalentFrameTalentsLearnButton\n/use [nomounted] !Trap Launcher')
		self:SetID(self:GetParent():GetID())
	else
		self:SetID(nil)
		self:SetAttribute('macrotext1', '/use [nomounted] !Trap Launcher')
	end
]])

local function HijackButton(button)
	macro:SetParent(button)
	macro:ClearAllPoints()
	macro:SetPoint('TOPLEFT', nil, 'BOTTOMLEFT', button:GetLeft(), button:GetTop())
	macro:SetSize(button:GetSize())
	button:SetScript('OnLeave', nil) -- Temporarily prevent it from hiding the tooltip
	macro:Show()
end

macro:RegisterForDrag('LeftButton') -- Allow dragging talents from the frame
macro:SetScript('OnDragStart', function(self)
	if IsModifiedClick('CHATLINK') then return end -- Don't drag if holding shift, not an ideal solution but the default behavior can't be replicated
	local talentID = self:GetID()
	if talentID then
		PickupTalent(talentID)
	end
end)

-- Hackishly temporarily enable the learn button before we click it so we can return it to its previous state afterwards
local buttonState = false
macro:SetScript('PreClick', function()
	buttonState = PlayerTalentFrameTalentsLearnButton:IsEnabled()
	PlayerTalentFrameTalentsLearnButton:Enable()
end)

macro:SetScript('PostClick', function()
	PlayerTalentFrameTalentsLearnButton:SetEnabled(buttonState)
end)

macro:SetScript('OnLeave', function(self)
	self:Hide()
	GameTooltip_Hide()
	self:GetParent():SetScript('OnLeave', GameTooltip_Hide)
end)

macro:SetScript('OnEvent', function(self, event, addon)
	if addon == 'Blizzard_GlyphUI' then
		for i = 1, 6 do -- Hook glyph frame mouse events
			local glyph = _G['GlyphFrameGlyph' .. i]
			if glyph then
				glyph:HookScript('OnEnter', HijackButton)
			end
		end
	elseif addon == 'Blizzard_TalentUI' then
		hooksecurefunc('PlayerTalentFrameTalent_OnEnter', function(self)
			if InCombatLockdown() then return end
			local _, _, _, _, selected, available = GetTalentInfo(self:GetID(), PlayerTalentFrame.inspect, PlayerTalentFrame.talentGroup)
			if not selected and not available then
				HijackButton(self)
			end
		end)
	end
end)
macro:RegisterEvent('ADDON_LOADED')

-- Suppress chat messages from learning and unlearning abilities
local ChatSpam = {
	'^' .. ERR_LEARN_ABILITY_S:gsub('%%s', '.-') .. '$',
	'^' .. ERR_LEARN_PASSIVE_S:gsub('%%s', '.-') .. '$',
	'^' .. ERR_LEARN_SPELL_S:gsub('%%s', '.-') .. '$',
	'^' .. ERR_SPELL_UNLEARNED_S:gsub('%%s', '.-') .. '$',
}

local function ChatFilter(self, event, msg, ...)
	for _, spam in ipairs(ChatSpam) do
		if strmatch(msg, spam) then return true end
	end
end

ChatFrame_AddMessageEventFilter('CHAT_MSG_SYSTEM', ChatFilter)