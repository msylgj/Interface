--Setchat parameters. Those parameters will apply to ChatFrame1 when you use /setchat
local def_position = {"BOTTOMLEFT",UIParent,"BOTTOMLEFT",13,17}  --聊天框位置
local chat_height = 175  --聊天框高度
local chat_width = 320   --聊天框宽度
local font = "Fonts\\ARKai_T.ttf"   --字体
local fontsize = 12      --聊天框字体大小
local autoset = true  --登陆自动设置聊天框参数
local TimeStampsCopy = true --聊天标签复制
local tscol = "64C2F5"		-- Timestamp coloring
local chatfadehide = false  --隐藏窗口标签
local chatbackgroundhide = true  --隐藏窗口背景
local flashtabfade = true  --隐藏聊天标签闪烁
local uinoticetrue = true --信息提示
local csounds = true --消息声音
local altclickinvite = true  --alt+点击邀请
local eboxbottom = false  --false:输入框在底部 true:输入框在顶部
local fontoutline = false --字体描边
local hidechannelnames = true  --隐藏综合,交易等频道名字
local hideotherchannelnames = true --隐藏说,大喊.工会等频道名字
local hideboxbground = true --隐藏输入框背景
local copyurl = true  --复制URL
local hidechatcopy = true --聊天标签右键复制聊天窗口内容
local bottombuttonhide = false --隐藏"滚动到最下"按钮
local friendshide = false  --隐藏聊天框好友按钮
local removechannelspam = true --隐藏进入退出(综合,本地防务)频道提示

--[[-----------------------------------------------------------------------------

Setting descriptions:

To disable an option set it to false or true.

Chat fade hide.
    Set to false, to not Fade out the chat frames completely instead
	of partially.

Chat background hide.
    Set to false, to not Remove chat background which shows on hovering.

Flash tab fade.
	Set to false to fade tab flashing.

Ui notice true.
	Error notification frame, Set to false to turn off.
        (WTS,WTB,LF,LFG,LFM.You have been outbid,group has been disbanded,instance will reset)

Csounds.
	Chat Sounds, Set to false to turn off.

Alt click invite.
	Alt click invite to party, Set to false to turn off.
        (hold alt and left click to invite from the chat)

Eboxbottom.
	Set to true to have the editbox show at the bottom.

Font outline.
	Set to true to have the Chat text bold.

Hide channel names.
        Set to false to hide the channelnames.

Hide other channel names.
        Set to false to hide the channelnames this may fix for other language "let me know".

Hide box bground.
        Set to false to show the editbox background. "A white border will be there still working on this".

Hide scroll flash.
       Set to false to hide the chat flash icon.

Hide url.
       Set to false to hide url copy.


Hide chat copy.
       Set to false to hide the chat copy.

Bottom button hide.
       Set to true to hide the bottom button Arrow.

Friends hide.
       Set to true to hide the friends icon.

Remove Channel Spam.
       Mutes General and LocalDefense channels while inside instances.

-------------------------------------------------------------------------------]]
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
if autoset then
	local f = CreateFrame"Frame"
	f:RegisterEvent("PLAYER_ENTERING_WORLD")
	f:SetScript("OnEvent", function() SetChat() end)
end

--[[-----------------------------------------------------------------------------
Full Screen Toogle.
Justify --"LEFT","RIGHT", or "CENTER" ChatFrames 1 - 10 --(combatlog) 2,RIGHT.
Real ID Frame.
-------------------------------------------------------------------------------]]
BINDING_HEADER_FULLSCREENTOOGLE = "FullScreenToogle";
--ChatFrame2:SetJustifyH("RIGHT")
--Clamp the toast frame to screen to prevent it cutting out
BNToastFrame:SetClampedToScreen(true)

--[[-----------------------------------------------------------------------------
Chat background hide.
-------------------------------------------------------------------------------]]
if chatbackgroundhide then
	for i=1,10 do
		_G['ChatFrame'..i]:SetFading(false)
		for j = 1, #CHAT_FRAME_TEXTURES do
			_G['ChatFrame'..i..CHAT_FRAME_TEXTURES[j]]:SetTexture(nil)
		end
	end
end

--[[-----------------------------------------------------------------------------
Disable tab flashing.
-------------------------------------------------------------------------------]]
if flashtabfade then
  FCF_FlashTab = function() end
  FCFTab_UpdateAlpha = function() end
end

--[[-----------------------------------------------------------------------------
Sticky Channels, 0 off, 1 on.
-------------------------------------------------------------------------------]]
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
ChatTypeInfo['CHANNEL'].sticky = 0				--普通频道

--If you want to unsticky whispers or BNet whispers, remove the "--" on the following lines
--ChatTypeInfo.WHISPER.sticky = 0
--ChatTypeInfo.BN_WHISPER.sticky = 0

--[[-----------------------------------------------------------------------------
Chat fade hide.
-------------------------------------------------------------------------------]]
if chatfadehide then
	CHAT_FRAME_TAB_NORMAL_NOMOUSE_ALPHA = 0
	CHAT_FRAME_TAB_SELECTED_NOMOUSE_ALPHA = 0
	CHAT_FRAME_BUTTON_FRAME_MIN_ALPHA = 0
	for i=1, 10 do
		local tab = _G[format("%s%d%s", "ChatFrame", i, "Tab")]
		tab:SetAlpha(0)
		tab.noMouseAlpha = 0
	end
end

--[[-----------------------------------------------------------------------------
Font outline.
-------------------------------------------------------------------------------]]
if fontoutline then 
	for i = 1, 10 do
		local cF = _G[format("%s%d", "ChatFrame", i)]
		local font, size = cF:GetFont()
		cF:SetFont(font, size, "OUTLINE")
	end
end

--[[-----------------------------------------------------------------------------
Scrolldown.
-------------------------------------------------------------------------------]]
FloatingChatFrame_OnMouseScroll = function(self, dir)
  if(dir > 0) then
    if(IsShiftKeyDown()) then self:ScrollToTop()
    else
      self:ScrollUp() end
  else
    if(IsShiftKeyDown()) then self:ScrollToBottom()
    else
      self:ScrollDown() end
  end
end

--[[-----------------------------------------------------------------------------
Timestamp.
-------------------------------------------------------------------------------]]
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
	
	local GetText = function(...)
		for l = 1, select("#", ...) do
			local obj = select(l, ...)
			if obj:GetObjectType() == "FontString" and obj:IsMouseOver() then
				return obj:GetText()
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
			return
		end
		return SetIRef(link, text, ...)
	end
end

--[[-----------------------------------------------------------------------------
Remove Channel Spam.
-------------------------------------------------------------------------------]]
if removechannelspam then
	local rcs = CreateFrame("frame")
	rcs:RegisterEvent("PLAYER_ENTERING_WORLD")
	rcs:SetScript("OnEvent", function()
		if IsInInstance() then
			ChatFrame_RemoveChannel(DEFAULT_CHAT_FRAME, "General")
			ChatFrame_RemoveChannel(DEFAULT_CHAT_FRAME, "LocalDefense")
		else
			ChatFrame_AddChannel(DEFAULT_CHAT_FRAME, "General")
			ChatFrame_AddChannel(DEFAULT_CHAT_FRAME, "LocalDefense")
		end
    end)
end

--[[-----------------------------------------------------------------------------
UI notice.
-------------------------------------------------------------------------------]]
if uinoticetrue then
	local notify = {
		["[Ll][Ff][Gg]"] = "|cff00ff00LFG",
		["[Ll][Ff][Mm]"] = "|cff00ff00LFM",
		["[Ww][Tt][Bb]"] = "|cff0000ffWTB",
		["[Ww][Tt][Ss]"] = "|cffff0000WTS",
		["^A buyer has been found for your auction of "] = false,
		["^This instance will reset in "] = false,
		["^You have been outbid on "] = false,
		["^Your group has been disbanded.$"] = false,
	}
	local framea = CreateFrame('Frame')
	framea:SetScript('OnEvent', function(self, event, message, sender)
		for pattern, tag in pairs(notify) do
			if message:find(pattern) then
				if tag then
					UIErrorsFrame:AddMessage(tag .. ": |cffcccccc" .. sender .. ": |cffffff00" .. message, 1.0, 1.0, 0.0, 1.0, UIERRORS_HOLD_TIME)
				else
					UIErrorsFrame:AddMessage("|cffffff00" .. message, 1.0, 1.0, 0.0, 1.0, UIERRORS_HOLD_TIME)
				end
				PlaySound('MapPing')
				break
			end
		end
	end)
	framea:RegisterEvent('CHAT_MSG_CHANNEL')
end

--[[-----------------------------------------------------------------------------
Misc functions (Frame size/move,Arrow keys,editbox to the top).
-------------------------------------------------------------------------------]] 
if hideboxbground then
	for i = 1, NUM_CHAT_WINDOWS do
		local editBoxleft = _G[format("%s%d%s", "ChatFrame", i, "EditBoxLeft")]
		local editBoxright = _G[format("%s%d%s", "ChatFrame", i, "EditBoxRight")]
		local editBoxmid = _G[format("%s%d%s", "ChatFrame", i, "EditBoxMid")]
		editBoxleft:SetAlpha(0)
		editBoxright:SetAlpha(0)
		editBoxmid:SetAlpha(0)
	end
end

--Classic mode hides the editbox when not in use, IM mode fades it out
--since we move the editbox above the chat tabs, we don't want it always showing
SetCVar("chatStyle", "classic")
for i = 1, 10 do
	local eb =  _G[format("%s%d%s", "ChatFrame", i, "EditBox")]
	local cfs = _G[format("%s%d", "ChatFrame", i)]
		--Allow resizing chatframes to whatever size you wish!
	cfs:SetMinResize(100,10)
	cfs:SetMaxResize(0,0)
	--Allow the chat frame to move to the end of the screen
	cfs:SetClampRectInsets(0,0,0,0)
	eb:SetAltArrowKeyMode(false)
	if eboxbottom then
		local el  = _G[format("%s%d%s", "ChatFrame", i, "EditBoxLanguage")]
		eb:ClearAllPoints()
		eb:SetPoint("TOPLEFT",  cfs, "BOTTOMLEFT",  -15, 0)
		eb:SetPoint("TOPRIGHT", cfs, "BOTTOMRIGHT", -5, 0)
		el:ClearAllPoints()
		el:SetPoint('BOTTOMLEFT', eb, 'BOTTOMRIGHT', -18, 0)
		el:SetPoint('TOPRIGHT', eb, 'TOPRIGHT', -18, 0)
		eb:Hide() --call this incase we're just changing to classic mode for the first time
	else
		local el  = _G[format("%s%d%s", "ChatFrame", i, "EditBoxLanguage")]
		eb:ClearAllPoints()
		eb:SetPoint("BOTTOMLEFT",  cfs, "TOPLEFT",  -15, 0)
		eb:SetPoint("BOTTOMRIGHT", cfs, "TOPRIGHT", -5, 0)
		el:ClearAllPoints()
		el:SetPoint('BOTTOMLEFT', eb, 'BOTTOMRIGHT', -18, 0)
		el:SetPoint('TOPRIGHT', eb, 'TOPRIGHT', -18, 0)
		eb:Hide() --call this incase we're just changing to classic mode for the first time
	end
end

--[[-----------------------------------------------------------------------------
Buttons.
-------------------------------------------------------------------------------]] 
local function Hide(f)
	f:SetScript('OnShow', f.Hide)
	f:Hide()
end

if bottombuttonhide then
	local hideFunc = function(frame) frame:Hide() end
	for i = 1, 10 do
		local ab = _G[format("%s%d%s", "ChatFrame", i, "ButtonFrame")]
		ab:SetScript("OnShow", hideFunc)
		ab:Hide()
	end
else
	local function UpdateBottomButton(frame)
		local buttona = frame.buttonFrame.bottomButton
		if frame:AtBottom() then
			buttona:Hide()
		else
			buttona:Show()
		end
	end

	local function OnClick(buttonb)
		local frame = buttonb:GetParent()
		frame:ScrollToBottom()
		UpdateBottomButton(frame)
	end

	hooksecurefunc('FloatingChatFrame_OnMouseScroll', UpdateBottomButton)
	for i= 1, NUM_CHAT_WINDOWS do
		local frame = _G['ChatFrame'..i]
		frame:HookScript('OnShow', UpdateBottomButton)
		
		local buttonc = frame.buttonFrame
		local bottom = buttonc.bottomButton
		bottom:SetPoint('BOTTOMRIGHT', frame, 'BOTTOMRIGHT')
		bottom:SetScript('OnClick', OnClick)
		bottom:SetParent(frame)
		bottom:SetAlpha(.6)
		
		UpdateBottomButton(frame)
		Hide(buttonc)
	end
end

if friendshide then
	local hideFunc = function(frame) frame:Hide() end

	ChatFrameMenuButton:SetScript("OnShow", hideFunc) 
	ChatFrameMenuButton:Hide() 
	FriendsMicroButton:SetScript("OnShow", hideFunc) 
	FriendsMicroButton:Hide() 
else
	FriendsMicroButton:SetAlpha(.6)
	FriendsMicroButton:ClearAllPoints()
	FriendsMicroButton:SetPoint('TOPRIGHT', ChatFrame1, 0, 30)
	FriendsMicroButton:RegisterForClicks('LeftButtonUp', 'RightButtonUp')
	FriendsMicroButton:SetScript('OnClick', function(self, button)
		if button == 'RightButton' then
			PlaySound('igChatEmoteButton')
			ChatFrame_OpenMenu()
		else
			ToggleFriendsFrame()
		end
	end)

	ChatMenu:SetPoint('BOTTOMLEFT', FriendsMicroButton, 'TOPRIGHT')
	Hide(ChatFrameMenuButton)
end

--[[-----------------------------------------------------------------------------
Channels.
-------------------------------------------------------------------------------]] 
if hideotherchannelnames then
	CHAT_SAY_GET = "[S] %s: "
	CHAT_YELL_GET = "[Y] %s: "
	CHAT_WHISPER_GET = "[F] %s: "
	CHAT_BN_WHISPER_GET = "[F] %s: "
	CHAT_WHISPER_INFORM_GET = "[T] %s: "
	CHAT_BN_WHISPER_INFORM_GET = "[T] %s: "
	CHAT_FLAG_AFK = "[AFK] "
	CHAT_FLAG_DND = "[DND] "
	CHAT_FLAG_GM = "[GM] "
end

if hidechannelnames then
	local gsub = gsub
	local time = _G.time
	local newAddMsg = {}

	local rplc = {
		"[GEN]", --General
		"[T]", --Trade
		"[WD]", --WorldDefense
		"[LD]", --LocalDefense
		"[LFG]", --LookingForGroup
		"[GR]", --GuildRecruitment
		"[I]", --Instance
		"[IL]", --Instance Leader
		"[G]", --Guild
		"[P]", --Party
		"[PL]", --Party Leader
		"[PL]", --Party Leader (Guide)
		"[O]", --Officer
		"[R]", --Raid
		"[RL]", --Raid Leader
		"[RW]", --Raid Warning
		"[%1]", --Custom Channels
	}

	local chn = {
		"%[%d0?%. General.-%]",
		"%[%d0?%. Trade.-%]",
		"%[%d0?%. WorldDefense%]",
		"%[%d0?%. LocalDefense.-%]",
		"%[%d0?%. LookingForGroup%]",
		"%[%d0?%. GuildRecruitment.-%]",
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
		"%[(%d0?)%. (.-)%]", --Custom Channels
	}

	local L = GetLocale()
	if L == "ruRU" then --Russian
		chn[1] = "%[%d0?%. Общий.-%]"
		chn[2] = "%[%d0?%. Торговля.-%]"
		chn[3] = "%[%d0?%. Оборона: глобальный%]" --Defense: Global
		chn[4] = "%[%d0?%. Оборона.-%]" --Defense: Zone
		chn[5] = "%[%d0?%. Поиск спутников%]"
		chn[6] = "%[%d0?%. Гильдии.-%]"
	elseif L == "deDE" then --German
		chn[1] = "%[%d0?%. Allgemein.-%]"
		chn[2] = "%[%d0?%. Handel.-%]"
		chn[3] = "%[%d0?%. Weltverteidigung%]"
		chn[4] = "%[%d0?%. LokaleVerteidigung.-%]"
		chn[5] = "%[%d0?%. SucheNachGruppe%]"
		chn[6] = "%[%d0?%. Gildenrekrutierung.-%]"
	elseif L == "frFR" then --French
		chn[1] = "%[%d0?%. Général.-%]"
		chn[2] = "%[%d0?%. Commerce.-%]"
		chn[3] = "%[%d0?%. DéfenseUniverselle%]"
		chn[4] = "%[%d0?%. DéfenseLocale.-%]"
		chn[5] = "%[%d0?%. RechercheDeGroupe%]"
		chn[6] = "%[%d0?%. RecrutementDeGuilde.-%]"
	elseif L == "zhTW" then --Traditional Chinese
		chn[1] = "%[%d0?%. 綜合.-%]"
		chn[2] = "%[%d0?%. 交易.-%]"
		chn[3] = "%[%d0?%. 世界防務%]"
		chn[4] = "%[%d0?%. 本地防務.-%]"
		chn[5] = "%[%d0?%. 尋求組隊%]"
		chn[6] = "%[%d0?%. 公會招募.-%]"
	elseif L == "koKR" then --Korean
		chn[1] = "%[%d0?%. 일반.-%]"
		chn[2] = "%[%d0?%. 거래.-%]"
		chn[3] = "%[%d0?%. 광역수비%]"
		chn[4] = "%[%d0?%. 지역수비.-%]"
		chn[5] = "%[%d0?%. 파티찾기%]"
		chn[6] = "%[%d0?%. 길드찾기.-%]"
	end

	local AddMessage = function(frame, text, ...)
		for i = 1, 17 do	
			text = gsub(text, chn[i], rplc[i])
		end

		--If Blizz timestamps is enabled, stamp anything it misses
		if CHAT_TIMESTAMP_FORMAT and not text:find("^|r") then
			text = BetterDate(CHAT_TIMESTAMP_FORMAT, time())..text
		end
		text = gsub(text, "%[(%d0?)%. .-%]", "[%1]") --custom channels
		return newAddMsg[frame:GetName()](frame, text, ...)
	end

	for i = 1, 10 do
		local fcl = _G[format("%s%d", "ChatFrame", i)]
		--skip combatlog and frames with no messages registered
		if i ~= 2 then -- skip combatlog
			newAddMsg[format("%s%d", "ChatFrame", i)] = fcl.AddMessage
			fcl.AddMessage = AddMessage
		end
	end
end

--[[-----------------------------------------------------------------------------
URL Copy.
-------------------------------------------------------------------------------]] 
if copyurl then
	local color = "ffffff"
	local pattern = "[wWhH][wWtT][wWtT][\46pP]%S+[^%p%s]"

	function string.color(text, color)
		return "|cff"..color..text.."|r"
	end

	function string.link(text, type, value, color)
		return "|H"..type..":"..tostring(value).."|h"..tostring(text):color(color or "ffffff").."|h"
	end

	StaticPopupDialogs["LINKME"] = {
		text = "URL COPY",
		button2 = CANCEL,
		hasEditBox = true,
			editBoxWidth = 400,
		timeout = 0,
		exclusive = 1,
		hideOnEscape = 1,
		EditBoxOnEscapePressed = function(self) self:GetParent():Hide() end,
		whileDead = 1,
		maxLetters = 255,
	}

	local function f(url)
		return string.link("["..url.."]", "url", url, color)
	end

	local function hook(self, text, ...)
		self:f(text:gsub(pattern, f), ...)
	end

	for i = 1, NUM_CHAT_WINDOWS do
		if ( i ~= 2 ) then
			local lframe = _G["ChatFrame"..i]
			lframe.f = lframe.AddMessage
			lframe.AddMessage = hook
		end
	end

	local ur = ChatFrame_OnHyperlinkShow
	function ChatFrame_OnHyperlinkShow(self, link, text, button)
		local type, value = link:match("(%a+):(.+)")
		if ( type == "url" ) then
			local dialog = StaticPopup_Show("LINKME")
			local editbox1 = _G[dialog:GetName().."EditBox"]  
			editbox1:SetText(value)
			editbox1:SetFocus()
			editbox1:HighlightText()
			local button = _G[dialog:GetName().."Button2"]
			button:ClearAllPoints()
			button:SetPoint("CENTER", editbox1, "CENTER", 0, -30)
		else
			ur(self, link, text, button)
		end
	end
end

--[[-----------------------------------------------------------------------------
Chat copy.
-------------------------------------------------------------------------------]]
if hidechatcopy then
	local frame = CreateFrame('Frame', nil, UIParent)
	frame:SetFrameStrata('DIALOG')
	frame:SetPoint('LEFT', 3, 10)
	frame:SetHeight(400)
	frame:SetWidth(500)
	frame:Hide()

	frame:SetBackdrop({
		bgFile = [[Interface\DialogFrame\UI-DialogBox-Background]],
		edgeFile = [[Interface\DialogFrame\UI-DialogBox-Border]],
		edgeSize = 16, tileSize = 16, tile = true,
		insets = { left = 3, right = 3, top = 5, bottom = 3 }
	})
	frame:SetBackdropColor(0, 0, 0, 1)

	local scrollArea = CreateFrame('ScrollFrame', "wChatScrollFrame", frame, 'UIPanelScrollFrameTemplate')
	scrollArea:SetPoint('TOPLEFT', 13, -30)
	scrollArea:SetPoint('BOTTOMRIGHT', -30, 13)

	local editBox = CreateFrame('EditBox', nil, frame)
	editBox:SetMultiLine(true)
	editBox:SetMaxLetters(20000)
	editBox:EnableMouse(true)
	editBox:SetAutoFocus(true)
	editBox:SetFontObject(ChatFontNormal)
	editBox:SetWidth(450)
	editBox:SetHeight(270)
	editBox:SetScript('OnEscapePressed', function() frame:Hide() end)

	scrollArea:SetScrollChild(editBox)

	local close = CreateFrame('Button', nil, frame, 'UIPanelCloseButton')
	close:SetPoint('TOPRIGHT', 0, -1)

	local CopyChat = function(self, chatTab)
		local chatFrame = _G['ChatFrame' .. chatTab:GetID()]
		local numMessages = chatFrame:GetNumMessages()
		if numMessages >= 1 then
			local GetMessageInfo = chatFrame.GetMessageInfo
			local text = GetMessageInfo(chatFrame, 1)
			for index = 2, numMessages do
				text = text .. "\n" .. GetMessageInfo(chatFrame, index)
			end
			frame:Show()
			editBox:SetText(text)
		end
	end

	hooksecurefunc('FCF_Tab_OnClick', function(self)
		local info = UIDropDownMenu_CreateInfo()
		info.text = "复制聊天内容"
		info.notCheckable = true
		info.func = CopyChat
		info.arg1 = self
		UIDropDownMenu_AddButton(info)
	end)
end

--[[-----------------------------------------------------------------------------
Chat Sounds.
-------------------------------------------------------------------------------]]
if csounds then
	local name, ns = ...
	local mediaPath = [=[Interface\AddOns\wChat\media\]=]
	local name = UnitName'player'
	local evtsounds = {
		["CHAT_MSG_GUILD"] = "Kachink",
		["CHAT_MSG_OFFICER"] = "Link",
		["CHAT_MSG_PARTY"] = "pop1",
		["CHAT_MSG_PARTY_LEADER"] = "pop2",
		["CHAT_MSG_RAID"] = "Text2",
		["CHAT_MSG_WHISPER"] = "Heart",
		["CHAT_MSG_GMWHISPER"] = "gasp",
		["CHAT_MSG_RAID_LEADER"] = "Choo",
		["CHAT_MSG_BATTLEGROUND"] = "switchy",
		["CHAT_MSG_BATTLEGROUND_LEADER"] = "doublehit",
		["CHAT_MSG_CHANNEL"] = true, --dummy,
		["CHAT_MSG_REALID"] = "Heart"
	}

	local cs = CreateFrame'Frame'
	cs:SetScript('OnEvent', function(self, event, ...)
		local msg, author, lang, channel = ...
		if author == name then return end
		if event == "CHAT_MSG_CHANNEL" then
			-- TODO
		else
			local sound = mediaPath..evtsounds[event]..'.mp3'
			PlaySoundFile(sound)
		end
	end)

	for event, sound in pairs(evtsounds) do
		cs:RegisterEvent(event)
	end
end

--[[-----------------------------------------------------------------------------
Alt click invite.
-------------------------------------------------------------------------------]]
if altclickinvite then
    local origSetItemRef = SetItemRef
    SetItemRef = function(link, text, button)
        local linkType = string.sub(link, 1, 6)
        if IsAltKeyDown() and linkType == "player" then
			local aname = string.match(link, "player:([^:]+)")
            InviteUnit(aname)
            return nil
        end
		return origSetItemRef(link,text,button)
    end
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