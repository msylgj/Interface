﻿local AutoApply = true											--自动按以下参数设置聊天框
local TabCHANNEL = false                                      --TAB键切换频道时包括综合,交易等世界频道
--Setchat parameters. Those parameters will apply to ChatFrame1 when you use /setchat
local def_position = {"BOTTOMLEFT",UIParent,"BOTTOMLEFT",0,15}  --聊天框位置
local chat_height = 175  --聊天框高度
local chat_width = 320   --聊天框宽度
local font = "Fonts\\ARKai_T.ttf"   --字体
local fontsize = 12      --聊天框字体大小
--other variables
local tscol = "64C2F5"						-- Timestamp coloring
local TimeStampsCopy = true					-- Enables special time stamps in chat allowing you to copy the specific line from your chat window by clicking the stamp
local LinkHover = {}; LinkHover.show = {	-- enable (true) or disable (false) LinkHover functionality for different things in chat
	["achievement"] = true,
	["enchant"]     = true,
	["glyph"]       = true,
	["item"]        = true,
	["quest"]       = true,
	["spell"]       = true,
	["talent"]      = true,
	["unit"]        = true,}

---------------- > Sticky Channels
ChatTypeInfo['SAY'].sticky = 1					--說
ChatTypeInfo['YELL'].sticky = 0					--大喊
ChatTypeInfo['EMOTE'].sticky = 0				--表情
ChatTypeInfo['PARTY'].sticky = 1				--隊伍
ChatTypeInfo['GUILD'].sticky = 1				--公會
ChatTypeInfo['OFFICER'].sticky = 1				--公會官員
ChatTypeInfo['RAID'].sticky = 1					--團隊


ChatTypeInfo['RAID_WARNING'].sticky = 0			--團隊警報
ChatTypeInfo['INSTANCE_CHAT'].sticky = 1			--戰場
ChatTypeInfo['WHISPER'].sticky = 0				--悄悄話
ChatTypeInfo.BN_WHISPER.sticky = 0				--实名密语
ChatTypeInfo['CHANNEL'].sticky = 0	

-------------- > Custom timestamps color
do
	ChatFrame2ButtonFrameBottomButton:RegisterEvent("PLAYER_LOGIN")
	ChatFrame2ButtonFrameBottomButton:SetScript("OnEvent", function(f)
		TIMESTAMP_FORMAT_HHMM = "|cff"..tscol.."[%I:%M]|r "
		TIMESTAMP_FORMAT_HHMMSS = "|cff"..tscol.."[%I:%M:%S]|r "
		TIMESTAMP_FORMAT_HHMMSS_24HR = "|cff"..tscol.."[%H:%M:%S]|r "
		TIMESTAMP_FORMAT_HHMMSS_AMPM = "|cff"..tscol.."[%I:%M:%S %p]|r "
		TIMESTAMP_FORMAT_HHMM_24HR = "|cff"..tscol.."[%H:%M]|r "
		TIMESTAMP_FORMAT_HHMM_AMPM = "|cff"..tscol.."[%I:%M %p]|r "
		f:UnregisterEvent("PLAYER_LOGIN")
		f:SetScript("OnEvent", nil)
	end)
end

---------------- > Fading alpha
CHAT_FRAME_TAB_NORMAL_NOMOUSE_ALPHA = 0
CHAT_FRAME_TAB_SELECTED_NOMOUSE_ALPHA = 0

---------------- > Function to move and scale chatframes 
SetChat = function()
    FCF_SetLocked(ChatFrame1, nil)
	FCF_SetChatWindowFontSize(self, ChatFrame1, fontsize) 
    ChatFrame1:ClearAllPoints()
    ChatFrame1:SetPoint(unpack(def_position))
    ChatFrame1:SetWidth(chat_width)
    ChatFrame1:SetHeight(chat_height)
    ChatFrame1:SetFrameLevel(8)
    ChatFrame1:SetUserPlaced(true)
	for i=1,10 do local cf = _G["ChatFrame"..i] FCF_SetWindowAlpha(cf, 0) end
    FCF_SavePositionAndDimensions(ChatFrame1)
	FCF_SetLocked(ChatFrame1, 1)
end
SlashCmdList["SETCHAT"] = SetChat
SLASH_SETCHAT1 = "/setchat"
if AutoApply then
	local f = CreateFrame"Frame"
	f:RegisterEvent("PLAYER_ENTERING_WORLD")
	f:SetScript("OnEvent", function() SetChat() end)
end

---------------- > Chat frame modifications
-- hide menu button
ChatFrameMenuButton:HookScript("OnShow", ChatFrameMenuButton.Hide)
ChatFrameMenuButton:Hide()

-- hide social button
FriendsMicroButton:HookScript("OnShow", FriendsMicroButton.Hide)
FriendsMicroButton:Hide()

-- toastframe
BNToastFrame:SetClampedToScreen(true)
BNToastFrame:SetClampRectInsets(-15,15,15,-15)

local function ApplyChatStyle(self)
	if self == "PET_BATTLE_COMBAT_LOG" then self = ChatFrame11 end
	if not self or (self and self.skinApplied) then return end

	local name = self:GetName()

	--chat frame resizing

	--chat fading
	self:SetFading(false)

	--set font, outline and shadow for chat text
--	self:SetFont(STANDARD_TEXT_FONT, 12, "THINOUTLINE")

	-- Hide chat textures
		for j = 1, #CHAT_FRAME_TEXTURES do
			_G[name..CHAT_FRAME_TEXTURES[j]]:SetTexture(nil)
		end
	--Unlimited chatframes resizing
		self:SetMinResize(100,50)
		self:SetMaxResize(UIParent:GetWidth(), UIParent:GetHeight())
	
	--Allow the chat frame to move to the end of the screen
		self:SetClampedToScreen(false)
		self:SetClampRectInsets(0,0,0,0)
	
	--Scroll to the bottom button
		local function BottomButtonClick(self)
			self:GetParent():ScrollToBottom();
		end
		local bb = _G[name.."ButtonFrameBottomButton"]
		bb:SetParent(_G[name])
		bb:SetHeight(18)
		bb:SetWidth(18)
		bb:ClearAllPoints()
		bb:SetPoint("TOPRIGHT", self, "TOPRIGHT", 0, -6)
		bb:SetAlpha(0.4)
		--bb.SetPoint = function() end
		bb:SetScript("OnClick", BottomButtonClick)

	--Remove scroll buttons
		local bf = _G[name..'ButtonFrame']
		bf:Hide()
		bf:SetScript("OnShow",  bf.Hide)
		
	--remove social button
		
	--EditBox Module
	local ebParts = {'Left', 'Mid', 'Right'}
	local eb = _G[name..'EditBox']
	local el  = _G[name..'EditBoxLanguage']
	for _, ebPart in ipairs(ebParts) do
		_G[name..'EditBox'..ebPart]:SetTexture(0, 0, 0, 0)
		local ebed = _G[name..'EditBoxFocus'..ebPart]
		ebed:SetTexture(0,0,0,0)
		ebed:SetHeight(27)
	end
	eb:SetAltArrowKeyMode(false)
	eb:ClearAllPoints()
	eb:SetPoint('BOTTOMLEFT', ChatFrame1, 'TOPLEFT', -4, 6)
	eb:SetPoint('TOPRIGHT', _G.ChatFrame1, 'TOPRIGHT', 6, 30)
	eb:SetShadowOffset(0, 0)
	eb:HookScript("OnEditFocusGained", function(self) self:Show() end)
	eb:HookScript("OnEditFocusLost", function(self) self:Hide() end)
	el:ClearAllPoints()
	el:SetPoint('BOTTOMLEFT', eb, 'BOTTOMRIGHT', -15, 0)
	el:SetPoint('TOPRIGHT', eb, 'TOPRIGHT', -15, 0)
		
	--chat tab skinning
	local tab = _G[name.."Tab"]
	local tabFs = tab:GetFontString()
	tabFs:SetFont(font,12)--,"THINOUTLINE")
	tabFs:SetShadowOffset(1.75, -1.75)
	tabFs:SetShadowColor(0,0,0,0.6)
	tabFs:SetTextColor(.9,.8,.5) -- 1,.7,.2
	_G[name.."TabLeft"]:SetTexture(nil)
	_G[name.."TabMiddle"]:SetTexture(nil)
	_G[name.."TabRight"]:SetTexture(nil)
	_G[name.."TabSelectedLeft"]:SetTexture(nil)
	_G[name.."TabSelectedMiddle"]:SetTexture(nil)
	_G[name.."TabSelectedRight"]:SetTexture(nil)
	_G[name.."TabGlow"]:SetTexture(nil)
	_G[name.."TabHighlightLeft"]:SetTexture(nil)
	_G[name.."TabHighlightMiddle"]:SetTexture(nil)
	_G[name.."TabHighlightRight"]:SetTexture(nil)
	
    tab:SetAlpha(1)

    self.skinApplied = true
end
-- calls
for i = 1, NUM_CHAT_WINDOWS do
    ApplyChatStyle(_G["ChatFrame"..i])
end
-- temporary chats
hooksecurefunc("FCF_OpenTemporaryWindow", ApplyChatStyle)

---------------- > TellTarget function
local function telltarget(msg)
	if not UnitExists("target") or not (msg and msg:len()>0) or not UnitIsFriend("player","target") then return end
	local name, realm = UnitName("target")
	if realm and not UnitIsSameServer("player", "target") then
		name = ("%s-%s"):format(name, realm)
	end
	SendChatMessage(msg, "WHISPER", nil, name)
end
SlashCmdList["TELLTARGET"] = telltarget
SLASH_TELLTARGET1 = "/tt"
SLASH_TELLTARGET2 = "/ее"
SLASH_TELLTARGET3 = "/wt"

---------------- > Channel names
local gsub = _G.string.gsub
local time = _G.time
local newAddMsg = {}

CHAT_SAY_GET = "[S] %s: "
CHAT_YELL_GET = "[Y] %s: "
CHAT_WHISPER_GET = "[F] %s: "
CHAT_BN_WHISPER_GET = "[F] %s: "
CHAT_WHISPER_INFORM_GET = "[T] %s: "
CHAT_BN_WHISPER_INFORM_GET = "[T] %s: "

CHAT_FLAG_AFK = "[AFK] "
CHAT_FLAG_DND = "[DND] "
CHAT_FLAG_GM = "[GM] "
local chn, rplc
do
	rplc = {
		"[GEN]", --General
		"[T]", --Trade
		"[WD]", --WorldDefense
		"[LD]", --LocalDefense
		"[LFG]", --LookingForGroup
		"[GR]", --GuildRecruitment
		"[I]", --INSTANCE_CHAT 
		"[IL]", --INSTANCE_CHAT_LEADER
		"[G]", --Guild
		"[P]", --Party
		"[PL]", --Party Leader
		"[PL]", --Party Leader (Guide)
		"[O]", --Officer
		"[R]", --Raid
		"[RL]", --Raid Leader
		"[RW]", --Raid Warning
	}
	chn = {
		"%[%d+%. General.-%]",
		"%[%d+%. Trade.-%]",
		"%[%d+%. WorldDefense%]",
		"%[%d+%. LocalDefense.-%]",
		"%[%d+%. LookingForGroup%]",
		"%[%d+%. GuildRecruitment.-%]",
		gsub(CHAT_INSTANCE_CHAT_GET, ".*%[(.*)%].*", "%%[%1%%]"),
		gsub(CHAT_INSTANCE_CHAT_LEADER_GET, ".*%[(.*)%].*", "%%[%1%%]"),
		gsub(CHAT_GUILD_GET, ".*%[(.*)%].*", "%%[%1%%]"),
		gsub(CHAT_PARTY_GET, ".*%[(.*)%].*", "%%[%1%%]"),
		gsub(CHAT_PARTY_LEADER_GET, ".*%[(.*)%].*", "%%[%1%%]"),
		gsub(CHAT_PARTY_GUIDE_GET, ".*%[(.*)%].*", "%%[%1%%]"),
		gsub(CHAT_OFFICER_GET, ".*%[(.*)%].*", "%%[%1%%]"),
		gsub(CHAT_RAID_GET, ".*%[(.*)%].*", "%%[%1%%]"),
		gsub(CHAT_RAID_LEADER_GET, ".*%[(.*)%].*", "%%[%1%%]"),
		gsub(CHAT_RAID_WARNING_GET, ".*%[(.*)%].*", "%%[%1%%]"),
	}
	local L = GetLocale()
	if L == "ruRU" then --Russian
		chn[1] = "%[%d+%. Общий.-%]"
		chn[2] = "%[%d+%. Торговля.-%]"
		chn[3] = "%[%d+%. Оборона: глобальный%]" --Defense: Global
		chn[4] = "%[%d+%. Оборона.-%]" --Defense: Zone
		chn[5] = "%[%d+%. Поиск спутников%]"
		chn[6] = "%[%d+%. Гильдии.-%]"
	elseif L == "deDE" then --German
		chn[1] = "%[%d+%. Allgemein.-%]"
		chn[2] = "%[%d+%. Handel.-%]"
		chn[3] = "%[%d+%. Weltverteidigung%]"
		chn[4] = "%[%d+%. LokaleVerteidigung.-%]"
		chn[5] = "%[%d+%. SucheNachGruppe%]"
		chn[6] = "%[%d+%. Gildenrekrutierung.-%]"
	end
end
local function AddMessage(frame, text, ...)
	for i = 1, 16 do
		text = gsub(text, chn[i], rplc[i])
	end
	--If Blizz timestamps is enabled, stamp anything it misses
	if CHAT_TIMESTAMP_FORMAT and not text:find("|r") then
		text = BetterDate(CHAT_TIMESTAMP_FORMAT, time())..text
	end
	text = gsub(text, "%[(%d0?)%. .-%]", "[%1]") --custom channels
	return newAddMsg[frame:GetName()](frame, text, ...)
end
do
	for i = 1, 5 do
		if i ~= 2 then -- skip combatlog
			local f = _G[format("%s%d", "ChatFrame", i)]
			newAddMsg[format("%s%d", "ChatFrame", i)] = f.AddMessage
			f.AddMessage = AddMessage
		end
	end
end
---------------- > Enable/Disable mouse for editbox
eb_mouseon = function()
	for i =1, 10 do
		local eb = _G['ChatFrame'..i..'EditBox']
		eb:EnableMouse(true)
	end
end
eb_mouseoff = function()
	for i =1, 10 do
		local eb = _G['ChatFrame'..i..'EditBox']
		eb:EnableMouse(false)
	end
end
hooksecurefunc("ChatFrame_OpenChat",eb_mouseon)
hooksecurefunc("ChatEdit_SendText",eb_mouseoff)

---------------- > Show tooltips when hovering a link in chat (credits to Adys for his LinkHover)
function LinkHover.OnHyperlinkEnter(_this, linkData, link)
	local t = linkData:match("^(.-):")
	if LinkHover.show[t] and IsAltKeyDown() then
		ShowUIPanel(GameTooltip)
		GameTooltip:SetOwner(UIParent, "ANCHOR_CURSOR")
		GameTooltip:SetHyperlink(link)
		GameTooltip:Show()
	end
end
function LinkHover.OnHyperlinkLeave(_this, linkData, link)
	local t = linkData:match("^(.-):")
	if LinkHover.show[t] then
		HideUIPanel(GameTooltip)
	end
end
local function LinkHoverOnLoad()
	for i = 1, NUM_CHAT_WINDOWS do
		local f = _G["ChatFrame"..i]
		f:SetScript("OnHyperlinkEnter", LinkHover.OnHyperlinkEnter)
		f:SetScript("OnHyperlinkLeave", LinkHover.OnHyperlinkLeave)
	end
end
LinkHoverOnLoad()

---------------- > Chat Scroll Module
hooksecurefunc('FloatingChatFrame_OnMouseScroll', function(self, dir)
	if dir > 0 then
		if IsShiftKeyDown() then
			self:ScrollToTop()
		elseif IsControlKeyDown() then
			--only need to scroll twice because of blizzards scroll
			self:ScrollUp()
			self:ScrollUp()
		end
	elseif dir < 0 then
		if IsShiftKeyDown() then
			self:ScrollToBottom()
		elseif IsControlKeyDown() then
			--only need to scroll twice because of blizzards scroll
			self:ScrollDown()
			self:ScrollDown()
		end
	end
end)

---------------- > afk/dnd msg filter
ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL_JOIN", function(msg) return true end)
ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL_LEAVE", function(msg) return true end)
-- ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL_NOTICE", function(msg) return true end)
ChatFrame_AddMessageEventFilter("CHAT_MSG_AFK", function(msg) return true end)
ChatFrame_AddMessageEventFilter("CHAT_MSG_DND", function(msg) return true end)

---------------- > Batch ChatCopy Module
local lines = {}
do
	--Create Frames/Objects
	local frame = CreateFrame("Frame", "BCMCopyFrame", UIParent)
	frame:SetBackdrop({bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
		edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
		tile = true, tileSize = 16, edgeSize = 16,
		insets = {left = 3, right = 3, top = 5, bottom = 3}})
	frame:SetBackdropColor(0,0,0,1)
	frame:SetWidth(500)
	frame:SetHeight(400)
	frame:SetPoint("CENTER", UIParent, "CENTER")
	frame:Hide()
	frame:SetFrameStrata("DIALOG")

	local scrollArea = CreateFrame("ScrollFrame", "BCMCopyScroll", frame, "UIPanelScrollFrameTemplate")
	scrollArea:SetPoint("TOPLEFT", frame, "TOPLEFT", 8, -30)
	scrollArea:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -30, 8)

	local editBox = CreateFrame("EditBox", "BCMCopyBox", frame)
	editBox:SetMultiLine(true)
	editBox:SetMaxLetters(99999)
	editBox:EnableMouse(true)
	editBox:SetAutoFocus(false)
	editBox:SetFontObject(ChatFontNormal)
	editBox:SetWidth(400)
	editBox:SetHeight(270)
	editBox:SetScript("OnEscapePressed", function(f) f:GetParent():GetParent():Hide() f:SetText("") end)
	scrollArea:SetScrollChild(editBox)

	local close = CreateFrame("Button", "BCMCloseButton", frame, "UIPanelCloseButton")
	close:SetPoint("TOPRIGHT", frame, "TOPRIGHT")
	local copyFunc = function(frame, btn)
		local cf = _G[format("%s%d", "ChatFrame", frame:GetID())]
		local _, size = cf:GetFont()
		FCF_SetChatWindowFontSize(cf, cf, 0.01)
		local ct = 1
		for i = select("#", cf:GetRegions()), 1, -1 do
			local region = select(i, cf:GetRegions())
			if region:GetObjectType() == "FontString" then
				lines[ct] = tostring(region:GetText())
				ct = ct + 1
			end
		end
		local lineCt = ct - 1
		local text = table.concat(lines, "\n", 1, lineCt)
		FCF_SetChatWindowFontSize(cf, cf, size)
		BCMCopyFrame:Show()
		BCMCopyBox:SetText(text)
		BCMCopyBox:HighlightText(0)
		wipe(lines)
	end
	local hintFunc = function(frame)
		GameTooltip:SetOwner(frame, "ANCHOR_TOP")
		if SHOW_NEWBIE_TIPS == "1" then
			GameTooltip:AddLine(CHAT_OPTIONS_LABEL, 1, 1, 1)
			GameTooltip:AddLine(NEWBIE_TOOLTIP_CHATOPTIONS, nil, nil, nil, 1)
		end
		GameTooltip:AddLine((SHOW_NEWBIE_TIPS == "1" and "\n" or "").."|TInterface\\Buttons\\UI-GuildButton-OfficerNote-Disabled:17|t双击复制聊天内容.", .7, .7, .2)
		GameTooltip:Show()
		GameTooltip:SetPoint("BOTTOMRIGHT",frame,"TOPRIGHT",120,0)
		--GameTooltip:SetClampRectInsets(0, 0, 0, 0)
	end
	for i = 1, 10 do
		local tab = _G[format("%s%d%s", "ChatFrame", i, "Tab")]
		tab:SetScript("OnDoubleClick", copyFunc)
		tab:SetScript("OnEnter", hintFunc)
	end
end

---------------- > URL copy Module
local tlds = {
	"[Cc][Oo][Mm]", "[Uu][Kk]", "[Nn][Ee][Tt]", "[Dd][Ee]", "[Ff][Rr]", "[Ee][Ss]",
	"[Bb][Ee]", "[Cc][Cc]", "[Uu][Ss]", "[Kk][Oo]", "[Cc][Hh]", "[Tt][Ww]",
	"[Cc][Nn]", "[Rr][Uu]", "[Gg][Rr]", "[Ii][Tt]", "[Ee][Uu]", "[Tt][Vv]",
	"[Nn][Ll]", "[Hh][Uu]", "[Oo][Rr][Gg]", "[Ss][Ee]", "[Nn][Oo]", "[Ff][Ii]"
}

local uPatterns = {
	'(http://%S+)',
	'(www%.%S+)',
	'(%d+%.%d+%.%d+%.%d+:?%d*)',
}

local cTypes = {
	"CHAT_MSG_CHANNEL",
	"CHAT_MSG_YELL",
	"CHAT_MSG_GUILD",
	"CHAT_MSG_OFFICER",
	"CHAT_MSG_PARTY",
	"CHAT_MSG_PARTY_LEADER",
	"CHAT_MSG_RAID",
	"CHAT_MSG_RAID_LEADER",
	"CHAT_MSG_SAY",
	"CHAT_MSG_WHISPER",
	"CHAT_MSG_BN_WHISPER",
	"CHAT_MSG_BN_CONVERSATION",
}

for _, event in pairs(cTypes) do
	ChatFrame_AddMessageEventFilter(event, function(self, event, text, ...)
		for i=1, 24 do
			local result, matches = string.gsub(text, "(%S-%."..tlds[i].."/?%S*)", "|cff8A9DDE|Hurl:%1|h[%1]|h|r")
			if matches > 0 then
				return false, result, ...
			end
		end
 		for _, pattern in pairs(uPatterns) do
			local result, matches = string.gsub(text, pattern, '|cff8A9DDE|Hurl:%1|h[%1]|h|r')
			if matches > 0 then
				return false, result, ...
			end
		end 
	end)
end

local GetText = function(...)
	for l = 1, select("#", ...) do
		local obj = select(l, ...)
		if obj:GetObjectType() == "FontString" and obj:IsMouseOver() then
			return obj:GetText()
		end
	end
end

---------------- > Per-line chat copy via time stamps
if TimeStampsCopy then
	SetCVar("showTimestamps", "none")
	CHAT_TIMESTAMP_FORMAT = nil
	local AddMsg = {}
	local AddMessage = function(frame, text, ...)
		text = string.gsub(text, "%[(%d+)%. .-%]", "[%1]")
		text = ('|cffffffff|Hm_Chat|h|r%s|h %s'):format('|cff'..tscol..'['..date('%H:%M')..']|r', text)
		return AddMsg[frame:GetName()](frame, text, ...)
	end
 	for i = 1, 10 do
		if i ~= 2 then
			AddMsg["ChatFrame"..i] = _G["ChatFrame"..i].AddMessage
			_G["ChatFrame"..i].AddMessage = AddMessage
		end
	end
end

local SetIRef = SetItemRef
SetItemRef = function(link, text, ...)
	local txt, frame
	if link:sub(1, 6) == 'm_Chat' then
		frame = GetMouseFocus():GetParent()
		txt = GetText(frame:GetRegions())
		txt = txt:gsub("|c%x%x%x%x%x%x%x%x(.-)|r", "%1")
		txt = txt:gsub("|H.-|h(.-)|h", "%1")
	elseif link:sub(1, 3) == 'url' then
		frame = GetMouseFocus():GetParent()
		txt = link:sub(5)
	end
	if txt then
		local editbox
		if GetCVar('chatStyle') == 'classic' then
			editbox = LAST_ACTIVE_CHAT_EDIT_BOX
		else
			editbox = _G['ChatFrame'..frame:GetID()..'EditBox']
		end
		editbox:Show()
		editbox:Insert(txt)
		editbox:HighlightText()
		editbox:SetFocus()
		eb_mouseon()
		return
	end
	return SetIRef(link, text, ...)
end

--Tab切换聊天
function ChatEdit_CustomTabPressed(self) 
	local b = nil
	local _, a = IsInInstance()
	local b1, _ = GetLFGMode(LE_LFG_CATEGORY_LFD)
	local b2, _ = GetLFGMode(LE_LFG_CATEGORY_RF)
	local b3, _ = GetLFGMode(LE_LFG_CATEGORY_SCENARIO)
	local b4, _ = GetLFGMode(LE_LFG_CATEGORY_LFR)
	local b0 = "lfgparty"
	if a == "pvp" or a == "arena" or b1 == b0 or b2 == b0 or b3 == b0 or b4 == b0 then
		b = true
	end
	if self:GetAttribute("chatType") then
		if IsShiftKeyDown() then
			if (self:GetAttribute("chatType") == "GUILD") then
--				if a then
				if b then
					self:SetAttribute("chatType", "INSTANCE_CHAT");
					ChatEdit_UpdateHeader(self);
				elseif (GetNumGroupMembers()>0 and IsInRaid()) then
					self:SetAttribute("chatType", "RAID");
					ChatEdit_UpdateHeader(self);
				elseif (GetNumSubgroupMembers()>0) then
					self:SetAttribute("chatType", "PARTY");
					ChatEdit_UpdateHeader(self);
				else
					self:SetAttribute("chatType", "SAY");
					ChatEdit_UpdateHeader(self);
				end
			elseif (self:GetAttribute("chatType") == "INSTANCE_CHAT") then
				if (GetNumGroupMembers()>0 and IsInRaid() and (not b)) then
					self:SetAttribute("chatType", "RAID");
					ChatEdit_UpdateHeader(self);
				elseif (GetNumSubgroupMembers()>0) and (not b) then
					self:SetAttribute("chatType", "PARTY");
					ChatEdit_UpdateHeader(self);
				else
					self:SetAttribute("chatType", "SAY");
					ChatEdit_UpdateHeader(self);
				end
			elseif (self:GetAttribute("chatType") == "RAID") then
				if (GetNumSubgroupMembers()>0) then
					self:SetAttribute("chatType", "PARTY");
					ChatEdit_UpdateHeader(self);
				else
					self:SetAttribute("chatType", "SAY");
					ChatEdit_UpdateHeader(self);
				end
			elseif (self:GetAttribute("chatType") == "PARTY") then
				self:SetAttribute("chatType", "SAY");
				ChatEdit_UpdateHeader(self);
			elseif  (self:GetAttribute("chatType") == "SAY")  then
				if (IsInGuild()) then
					self:SetAttribute("chatType", "GUILD");
					ChatEdit_UpdateHeader(self);
				elseif b then
					self:SetAttribute("chatType", "INSTANCE_CHAT");
					ChatEdit_UpdateHeader(self);
				elseif (GetNumGroupMembers()>0 and IsInRaid()) then
					self:SetAttribute("chatType", "RAID");
					ChatEdit_UpdateHeader(self);
				elseif (GetNumSubgroupMembers()>0) then
					self:SetAttribute("chatType", "PARTY");
					ChatEdit_UpdateHeader(self);
				else
					return;
				end
			elseif (self:GetAttribute("chatType") == "CHANNEL") then
				if (IsInGuild()) then
					self:SetAttribute("chatType", "GUILD");
					ChatEdit_UpdateHeader(self);
				elseif b then
					self:SetAttribute("chatType", "INSTANCE_CHAT");
					ChatEdit_UpdateHeader(self);
				elseif (GetNumGroupMembers()>0 and IsInRaid()) then
					self:SetAttribute("chatType", "RAID");
					ChatEdit_UpdateHeader(self);
				elseif (GetNumSubgroupMembers()>0) then
					self:SetAttribute("chatType", "PARTY");
					ChatEdit_UpdateHeader(self);
				else
					self:SetAttribute("chatType", "SAY");
					ChatEdit_UpdateHeader(self);
				end
			else
				self:SetAttribute("chatType", "SAY");
				ChatEdit_UpdateHeader(self);
			end
		elseif IsControlKeyDown() then
			if (self:GetAttribute("chatType") == "OFFICER") then
				if (IsInGuild()) then
					self:SetAttribute("chatType", "GUILD");
					ChatEdit_UpdateHeader(self);
				end				
			else
				if (IsInGuild()) then
					self:SetAttribute("chatType", "OFFICER");
					ChatEdit_UpdateHeader(self);
				else
					self:SetAttribute("chatType", "SAY");
					ChatEdit_UpdateHeader(self);					
				end		
			end
		else
			if  (self:GetAttribute("chatType") == "SAY")  then
				if (GetNumSubgroupMembers()>0) then
					self:SetAttribute("chatType", "PARTY");
					ChatEdit_UpdateHeader(self);
				elseif (GetNumGroupMembers()>0 and IsInRaid()) then
					self:SetAttribute("chatType", "RAID");
					ChatEdit_UpdateHeader(self);
				elseif b then
					self:SetAttribute("chatType", "INSTANCE_CHAT");
					ChatEdit_UpdateHeader(self);
				elseif (IsInGuild()) then
					self:SetAttribute("chatType", "GUILD");
					ChatEdit_UpdateHeader(self);
				else
					return;
				end
			elseif (self:GetAttribute("chatType") == "PARTY") then
				if (GetNumGroupMembers()>0 and IsInRaid()) then
					self:SetAttribute("chatType", "RAID");
					ChatEdit_UpdateHeader(self);
				elseif b then
					self:SetAttribute("chatType", "INSTANCE_CHAT");
					ChatEdit_UpdateHeader(self);
				elseif (IsInGuild()) then
					self:SetAttribute("chatType", "GUILD");
					ChatEdit_UpdateHeader(self);
				else
					self:SetAttribute("chatType", "SAY");
					ChatEdit_UpdateHeader(self);
				end			
			elseif (self:GetAttribute("chatType") == "RAID") then
				if b then
					self:SetAttribute("chatType", "INSTANCE_CHAT");
					ChatEdit_UpdateHeader(self);
				elseif (IsInGuild()) then
					self:SetAttribute("chatType", "GUILD");
					ChatEdit_UpdateHeader(self);
				else
					self:SetAttribute("chatType", "SAY");
					ChatEdit_UpdateHeader(self);
				end
			elseif (self:GetAttribute("chatType") == "INSTANCE_CHAT") then
				if (IsInGuild) then
					self:SetAttribute("chatType", "GUILD");
					ChatEdit_UpdateHeader(self);
				else
					self:SetAttribute("chatType", "SAY");
					ChatEdit_UpdateHeader(self);
				end
			elseif (self:GetAttribute("chatType") == "GUILD") then
				self:SetAttribute("chatType", "SAY");
				ChatEdit_UpdateHeader(self);
			elseif (self:GetAttribute("chatType") == "CHANNEL") then
				if (GetNumSubgroupMembers()>0) then
					self:SetAttribute("chatType", "PARTY");
					ChatEdit_UpdateHeader(self);
				elseif (GetNumGroupMembers()>0 and IsInRaid()) then
					self:SetAttribute("chatType", "RAID");
					ChatEdit_UpdateHeader(self);
				elseif b then
					self:SetAttribute("chatType", "INSTANCE_CHAT");
					ChatEdit_UpdateHeader(self);
				elseif (IsInGuild()) then
					self:SetAttribute("chatType", "GUILD");
					ChatEdit_UpdateHeader(self);
				else
					self:SetAttribute("chatType", "SAY");
					ChatEdit_UpdateHeader(self);
				end
			elseif (self:GetAttribute("chatType") == "OFFICER") then
				if (IsInGuild) then
					self:SetAttribute("chatType", "GUILD");
					ChatEdit_UpdateHeader(self);
				else
					self:SetAttribute("chatType", "SAY");
					ChatEdit_UpdateHeader(self);
				end
			end
		end
	end
end

-----NeonChat 聊天输入框染色

local chateditbox = CreateFrame("Button", nil, ChatFrame1EditBox)
chateditbox:SetBackdrop({bgFile = 'Interface\\Buttons\\WHITE8x8', edgeFile = 'Interface\\Buttons\\WHITE8x8', edgeSize = 1})
chateditbox:SetBackdropColor(0,0,0,.7)
hooksecurefunc("ChatEdit_UpdateHeader", function(editbox)
	if ACTIVE_CHAT_EDIT_BOX then
		local type = editbox:GetAttribute("chatType")
		local frame = string.match(ACTIVE_CHAT_EDIT_BOX:GetName(), "^(.-)EditBox$")

		if ( type == "CHANNEL" ) then
			local id = GetChannelName(editbox:GetAttribute("channelTarget"))
			if id == 0 then	
				chateditbox:SetBackdropBorderColor(0.5,0.5,0.5,.5)
			else 
				chateditbox:SetBackdropBorderColor(ChatTypeInfo[type..id].r,ChatTypeInfo[type..id].g,ChatTypeInfo[type..id].b,.5)
			end
		else
			chateditbox:SetBackdropBorderColor(ChatTypeInfo[type].r,ChatTypeInfo[type].g,ChatTypeInfo[type].b,.5)
		end
		

		chateditbox:SetParent(ACTIVE_CHAT_EDIT_BOX)
		chateditbox:ClearAllPoints()
		chateditbox:SetPoint("TOPLEFT",ACTIVE_CHAT_EDIT_BOX:GetName().."FocusLeft","TOPLEFT",4,-3)
		chateditbox:SetPoint("BOTTOMRIGHT",ACTIVE_CHAT_EDIT_BOX:GetName().."FocusRight","BOTTOMRIGHT",-4,3)
		chateditbox:SetFrameLevel(_G[frame.."EditBox"]:GetFrameLevel()-1)

	else
		chateditbox:SetBackdropBorderColor(0,0,0,0)
	end
	
	for chatframe=1,CURRENT_CHAT_FRAME_ID do
		for i=6,8 do select(i, _G["ChatFrame"..chatframe.."EditBox"]:GetRegions()):Hide() end
	end
end)