--EnhancedChatFilter 用户设置
local repeatCacheLines = 1000 --缓存聊天条目数
local repeatCheckTime = 600   --检测重复发言时间间隔（秒）
local chatLinesLimit = 20     --多少行内不许重复
local chatSenderLimit = 20    --发送者缓存限制
local RaidAlertTag = "%*%*(.+)%*%*"  --RaidAlert 特征
local QuestReportTag = "任务进度提示%s?[:：]" --QuestReport 特征

--EnhancedChatFilter 内部定义
local ecfVersioin = " 1.60.01.26"
local _, ecf = ...
local utf8replace = ecf.utf8replace -- utf8.lua
local debugMode = nil
local filterResult = nil
local chatLines = {}
local chatSender = {}
local prevLineID = 0
local chatTotalLines = 0
local msgList = {}
local msgCount = {}
local msgTime = {}
local msgID = {}

local ecfFrame = CreateFrame("Frame")
local login = nil
local allowWisper = {}

local gsub, strfind, select, ipairs, difftime, tremove = gsub, string.find, select, ipairs, difftime, tremove

--信息中将被过滤器过滤的 UTF-8 符号（常被用于干扰）
local UTF8Symbols = {['·']='',['＠']='',['＃']='',['％']='',
	['＆']='',['＊']='',['——']='',['＋']='',['｜']='',['～']='',['　']='',
	['，']='',['。']='',['、']='',['？']='',['！']='',['：']='',['；']='',
	['’']='',['‘']='',['“']='',['”']='',['【']='',['】']='',['『']='',
	['』']='',['《']='',['》']='',['（']='',['）']='',['￥']='',['＝']='',
	['…']='',['……']='',['１']='',['２']='',['３']='',['４']='',['５']='',
	['６']='',['７']='',['８']='',['９']='',['０']=''}

--http://www.wowwiki.com/USERAPI_StringHash
local function StringHash(text)
	local counter = 1
	local len = string.len(text)
	for i = 1, len, 3 do
	counter = math.fmod(counter*8161, 4294967279) +  -- 2^32 - 17: Prime!
		(string.byte(text,i)*16776193) +
		((string.byte(text,i+1) or (len-i+256))*8372226) +
		((string.byte(text,i+2) or (len-i+256))*3932164)
	end
	return math.fmod(counter, 4294967291) -- 2^32 - 5: Prime (and different from the prime in the loop)
end

local EnhancedChatFilter = LibStub("AceAddon-3.0"):NewAddon("EnhancedChatFilter", "AceConsole-3.0", "AceEvent-3.0")
LibStub("AceConfigRegistry-3.0"):NotifyChange("EnhancedChatFilter")

--数据库初始设置
local defaults = {
	profile = {
		--启用聊天过滤
		enableFilter = true,
		--启用密语过滤
		enableWisper = true,
		--启用“忙碌”玩家过滤
		enbleDND = true,
		--启用重复聊天过滤
		enbleRPT = true,
		--启用切天赋刷屏过滤
		enbleDSS = true,
		--启用成就刷屏过滤
		enbleCFA = true,
		--启用RaidAlert刷屏过滤
		enbleRAF = true,
		--启用QuestReport刷屏过滤
		enbleQRF = true,
		--启用扩展屏蔽名单
		enableIGM = true,
		--黑名单列表
		blackList = {},
		--扩展屏蔽名单
		ignoreMoreList = {},
		--小地图图标选项
		minimap = {
			hide = true,
			enableMinimapIcon = false,
		}
	}
}

--创建小地图图标数据
local ecfLDB = LibStub("LibDataBroker-1.1"):NewDataObject("Enhanced Chat Filter", {
	type = "data source",
	text = "Enhanced Chat Filter",
	icon = "Interface\\Icons\\Trade_Archaeology_Orc_BloodText",
	OnClick = function() EnhancedChatFilter:EnhancedChatFilterOpen() end,
	OnTooltipShow = function(tooltip)
		tooltip:AddLine("|cffecf0f1Enhanced Chat Filter|r\n点击打开配置界面");
	end
})

--创建 Libstub 变量
local icon = LibStub("LibDBIcon-1.0")

--初始化插件
function EnhancedChatFilter:OnInitialize()
	EnhancedChatFilter:RegisterChatCommand("cf", "EnhancedChatFilterOpen")
	EnhancedChatFilter:RegisterChatCommand("cf-toggle", "EnhancedChatFilterToggle")
	EnhancedChatFilter:RegisterChatCommand("cf-clear", "EnhancedChatFilterClear")
	EnhancedChatFilter:RegisterChatCommand("cf-iml", "EnhancedChatFilterIgnoreMoreList")
	EnhancedChatFilter:RegisterChatCommand("cf-cleariml", "EnhancedChatFilterClearIMList")

	self.db = LibStub("AceDB-3.0"):New("ecfDB", defaults, "Default")
	icon:Register("Enhanced Chat Filter", ecfLDB, self.db.profile.minimap)
end;

--获取/设置数据库数据的函数
function EnhancedChatFilter:GetEnableFilter(info)
	return self.db.profile.enableFilter;
end;

function EnhancedChatFilter:ToggleEnableFilter(info, value)
	self.db.profile.enableFilter = value;
end;

function EnhancedChatFilter:GetEnableWisper(info)
	return self.db.profile.enableWisper;
end;

function EnhancedChatFilter:ToggleEnableWisper(info, value)
	self.db.profile.enableWisper = value;
end;

function EnhancedChatFilter:GetEnableDND(info)
	return self.db.profile.enableDND;
end;

function EnhancedChatFilter:ToggleEnableDND(info, value)
	self.db.profile.enableDND = value;
end;

function EnhancedChatFilter:GetEnableRPT(info)
	return self.db.profile.enableRPT;
end;

function EnhancedChatFilter:ToggleEnableRPT(info, value)
	self.db.profile.enableRPT = value;
end;

function EnhancedChatFilter:GetEnableDSS(info)
	return self.db.profile.enableDSS;
end;

function EnhancedChatFilter:ToggleEnableDSS(info, value)
	self.db.profile.enableDSS = value;
end;

function EnhancedChatFilter:GetEnableCFA(info)
	return self.db.profile.enableCFA;
end;

function EnhancedChatFilter:ToggleEnableCFA(info, value)
	self.db.profile.enableCFA = value;
end;

function EnhancedChatFilter:GetEnableRAF(info)
	return self.db.profile.enableRAF;
end;

function EnhancedChatFilter:ToggleEnableRAF(info, value)
	self.db.profile.enableRAF = value;
end;

function EnhancedChatFilter:GetEnableQRF(info)
	return self.db.profile.enableQRF;
end;

function EnhancedChatFilter:ToggleEnableQRF(info, value)
	self.db.profile.enableQRF = value;
end;

function EnhancedChatFilter:GetEnableIGM(info)
	return self.db.profile.enableIGM;
end;

function EnhancedChatFilter:ToggleEnableIGM(info, value)
	self.db.profile.enableIGM = value;
end;

function EnhancedChatFilter:GetEnableMinimapIcon(info)
	return self.db.profile.minimap.enableMinimapIcon;
end;

function EnhancedChatFilter:ToggleEnableMinimapIcon(info, value)
	self.db.profile.minimap.enableMinimapIcon = value;
end;

function EnhancedChatFilter:GetMinimapStatus(info)
	return self.db.profile.minimap.hide;
end;

function EnhancedChatFilter:SetMinimapStatus(info, value)
	self.db.profile.minimap.hide = value;
end;

function EnhancedChatFilter:GetBlackList(info)
	return self.db.profile.blackList;
end;

function EnhancedChatFilter:InsertBlackList(info, value,typeModus)
	table.insert(self.db.profile.blackList,{value,typeModus})
end;

function EnhancedChatFilter:RemoveFromBlackList(info, index)
	table.remove(self.db.profile.blackList,index)
end;

function EnhancedChatFilter:ClearBlackList(info, index)
	self.db.profile.blackList = {}
end;

function EnhancedChatFilter:GetIgnoreMoreList(info)
	return self.db.profile.ignoreMoreList;
end;

function EnhancedChatFilter:InsertIgnoreMoreList(info, value)
	table.insert(self.db.profile.ignoreMoreList,{value})
end;

function EnhancedChatFilter:RemoveFromIgnoreMoreList(info, index)
	table.remove(self.db.profile.ignoreMoreList,index)
end;


function EnhancedChatFilter:ClearIgnoreMoreList(info, index)
	self.db.profile.ignoreMoreList = {}
end;

--扩展黑名单
local function SendMessage(event, msg, r, g, b)
	local info = ChatTypeInfo[strsub(event, 10)]
	for i = 1, NUM_CHAT_WINDOWS do
		ChatFrames = _G["ChatFrame"..i]
		if (ChatFrames and ChatFrames:IsEventRegistered(event)) then
			ChatFrames:AddMessage(msg, info.r, info.g, info.b)
		end
	end
end

local function ignoreMore(player)
	if (EnhancedChatFilter:GetEnableIGM(info) ~= true) then return end
	if (not player) then return end
	local ignore = nil
	if GetNumIgnores() >= 50 then
		for i = 1, GetNumIgnores() do
			local name = GetIgnoreName(i)
			if (player == name) then
				ignore = true
				break
			end
		end
		if (not ignore) then
			local trimmedPlayer = Ambiguate(player, "none")
			EnhancedChatFilter:InsertIgnoreMoreList(info, trimmedPlayer)
			if debugMode then print("Added to ECF ignoreMoreList!") end
			SendMessage("CHAT_MSG_SYSTEM", format(ERR_IGNORE_ADDED_S, trimmedPlayer))
		end
	end
end

hooksecurefunc("AddIgnore", ignoreMore)
hooksecurefunc("AddOrDelIgnore", ignoreMore)

--禁用暴雪内部语言过滤器
local GetCVar,SetCVar,BNGetMatureLanguageFilter,BNSetMatureLanguageFilter,BNConnected =
GetCVar,SetCVar,BNGetMatureLanguageFilter,BNSetMatureLanguageFilter,BNConnected

local frame=CreateFrame("Frame")
frame:Hide()

local function allowSwearing()
	if GetCVar("profanityFilter")~="0" then
		SetCVar("profanityFilter", "0")
		--print("Turned Mature Language Filter off.")
	end
	if BNConnected() and BNGetMatureLanguageFilter() then
		BNSetMatureLanguageFilter(false)
		--print("Turned Battle.net Mature Language Filter off.")
	end
end

frame:SetScript("OnEvent", allowSwearing)
frame:RegisterEvent("VARIABLES_LOADED")
frame:RegisterEvent("CVAR_UPDATE")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:RegisterEvent("BN_MATURE_LANGUAGE_FILTER")
frame:RegisterEvent("BN_CONNECTED")

allowSwearing() -- 确认再次载入

--登陆/好友列表更新时同步更新允许密语玩家列表
ecfFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
ecfFrame:RegisterEvent("FRIENDLIST_UPDATE")
ecfFrame:SetScript("OnEvent", function(self, event, msg)
	if event == "PLAYER_ENTERING_WORLD" then
		ShowFriends() --强制刷新一次好友列表
	else
		if not login then --登陆时只添加一次
			login = true
			local num = GetNumFriends()
			for i = 1, num do
				local n = GetFriendInfo(i)
				--添加好友到允许名单
				if n then allowWisper[n] = true end
			end
			return
		end
	end
	if debugMode then for k in pairs(allowWisper) do print("allowed: "..k) end end
end)

--自己主动密语的玩家加入安全名单
local function addToAllowWisper(self,event,msg,player)
	local trimmedPlayer = Ambiguate(player, "none")
	if allowWisper[trimmedPlayer] then return end --Do nothing if on safe list
	allowWisper[trimmedPlayer] = true --If we want to whisper someone, they're good
end

--主过滤函数
local function filterdWords(self,event,msg,player,_,_,_,flags,_,_,_,_,lineID,...)

	--如果不启用过滤直接返回
	if(EnhancedChatFilter:GetEnableFilter(info) ~= true) then return end

	--如果开启过滤功能
	--聊天信息会注册到不止一个窗口，我们防止多次处理（会不会影响多窗口密语？！）
	if lineID == prevLineID then
		return filterResult
	else
		prevLineID, filterResult = lineID, nil
		--从数据库读取黑名单
		blacklist = EnhancedChatFilter:GetBlackList(info)
		if debugMode then print("RAWMsg: "..msg) end

		--如果扩展屏蔽列表功能开启
		if(EnhancedChatFilter:GetEnableIGM(info) == true) then
			ignoreMoreList = EnhancedChatFilter:GetIgnoreMoreList(info)
			local trimmedPlayer = Ambiguate(player, "none")
			for index,ignorePlayer in ipairs(ignoreMoreList) do
				if (trimmedPlayer == ignorePlayer[1]) then
					if debugMode then print(trimmedPlayer.." Muted~!") end
					filterResult = true
					return true
				end
			end
		end

		--如果“忙碌”玩家过滤功能开启
		if(EnhancedChatFilter:GetEnableDND(info) == true) then
			if type(flags) == "string" and flags == "DND" then
				filterResult = true
				return true
			end
		end

		--删除所有物品链接标志, 空格以及一些符号
		--所有标点： !"#$%&'()*+,-./:;<=>?@[\]^_`{|}~   魔术字符： ^$()%.[]*+-?
		--如果我们想使用正则表达式例如 {.*} ，那么就不能使用过滤所有符号的功能:gsub("%p", "") 参考部分过滤: msg = gsub(msg, "[%*%-%(%)\"`'_%+#%%%^&;:~{} ]", "")
		local filterString = msg:upper():gsub("|C[0-9A-F]+",""):gsub("|H[^|]+|H",""):gsub("|H|R",""):gsub("%s", ""):gsub("[@|!`'_#&;:,~/<=>%?%[%]%$%*%-%(%)%+%-%%%^%.\"\\]", "")
		if debugMode then print("filterString: "..filterString) end

		--删除 UTF-8 干扰符
		local word = utf8replace(filterString, UTF8Symbols)

		--初始化任务状态
		local haveDailyQuest, title, isCompleted = nil, nil, nil
		local numEntries, _ = GetNumQuestLogEntries()
		--从处理过的聊天信息中过滤包含黑名单词语的聊天内容
		for index, blacklistWord in ipairs(blacklist) do
			if (blacklistWord[2] == "日常") then
				haveDailyQuest = nil
				--检查任务列表是否有这个日常任务而且没有完成
				for i=1, numEntries do
					title,_,_,_,_,isCompleted = GetQuestLogTitle(i)
					if (string.find(title, blacklistWord[1]) and isCompleted ~= 1) then
						haveDailyQuest = true
					end
				end
				--如果发现日常黑名单，但是玩家没有任务或者已完成，或者玩家已经在队伍团队中，过滤！
				if (string.find(word,blacklistWord[1]) and (not haveDailyQuest or (UnitInRaid("player") or UnitInParty("player")))) then
					filterResult = true
					return true --deletion of message from chat
				end
			else
				--检查常规黑名单
				if (string.find(word,blacklistWord[1])) then
					filterResult = true
					return true --deletion of message from chat
				end
			end
		end

		--如果重复信息过滤功能开启
		if(EnhancedChatFilter:GetEnableRPT(info) == true) then
			--防止为了缓存聊天信息而使内存无限增长
			chatTotalLines = chatTotalLines + 1
			if debugMode then print("chatTotalLines: "..chatTotalLines) end
			if chatTotalLines >= repeatCacheLines then
				if debugMode then print("Memory Free~!: ") end
				chatTotalLines = 0
				msgList = {}
				msgCount = {}
				msgTime = {}
				msgID = {}
			end

			--通过时间，发送者以及整理过的聊天信息来检查是否是重复信息
			local msgLine = player..":"..word:gsub("%w+", ""):gsub("%p+", ""):gsub("{.*}","")
			if debugMode then print("msgLine: "..msgLine) end

			--按照条目过滤
			--聊天缓存, 检查当前行, 如果和前 20 （可设置）行任何一条相同，则过滤
			for i=1, #chatLines do
				if chatLines[i] == msgLine then
					if debugMode then print("i: "..i) end
					filterResult = true
					return true --...filter!
				end
				if i == chatLinesLimit then tremove(chatLines, 1) end --控制缓存大小
			end
			chatLines[#chatLines+1] = msgLine
			--聊天缓存结束

			--个人多行刷屏
			local msgtable = { Sender = player, Time = GetTime() }
			for i=1, #chatSender do
				if (chatSender[i].Sender == player and (GetTime() - chatSender[i].Time) < 0.400) then
					filterResult = true
					return true
				end
				if i == chatSenderLimit then tremove(chatSender, 1) end
			end
			tinsert(chatSender, msgtable)

			--按照时间过滤
			if (msgList[msgLine] == nil) then  -- 如果我们从未见过这条信息
				msgList[msgLine] = true
				msgCount[msgLine] = 1
				msgTime[msgLine] = time()
				msgID[msgLine] = lineID
			else
				if msgID[msgLine] ~= lineID then
					msgCount[msgLine] = msgCount[msgLine] + 1
				end
			end

			if (msgList[msgLine] ~= nil) then	--这个一般都是 true, 但是为了阻止出错不妨做个检测
				if (msgCount[msgLine] > 1) then
					if debugMode then print("difftime: "..difftime(time(), msgTime[msgLine])) end
					if (difftime(time(), msgTime[msgLine]) <= repeatCheckTime) then
						filterResult = true
						return true
					end
				end
			end
			msgTime[msgLine] = time()

		end

		--如果密语过滤功能开启
		if (EnhancedChatFilter:GetEnableWisper() == true and event == "CHAT_MSG_WHISPER") then
			--从聊天信息获取到的： player = playerName - realmName, 我们要移除 realmName
			local trimmedPlayer = Ambiguate(player, "none")
			--对 GM 和 DEV 的密语不做处理
			if type(flags) == "string" and (flags == "GM" or flags == "DEV") then return end
			--强制刷新一次好友列表
			ShowFriends()
			--同工会，自己，同团队，同小队和好友不做处理
			if allowWisper[trimmedPlayer] or UnitIsInMyGuild(trimmedPlayer) or UnitIsUnit(trimmedPlayer,"player") or UnitInRaid(trimmedPlayer) or UnitInParty(trimmedPlayer) then return end
			--战网好友不做处理
			for i = 1, select(2, BNGetNumFriends()) do
				local toon = BNGetNumFriendToons(i)
				for j = 1, toon do
					local rFocus, rName, rGame = BNGetFriendToonInfo(i, j)
					if (rName == trimmedPlayer and rGame == "WoW") then return end
				end
			end
			if debugMode then print(player.."'s wisper blocked.") end
			filterResult = true
			return true
		end

		--信息到这里什么也没过滤到? 那么直接放行~
		return
	end
end

--简单的清洁一下聊天内容
local function cleanMessage(self,event,msg,...)
	if msg then
		msg = msg:gsub("M+", "M"):gsub("m+", "m")
	end
	return false, msg, ...
end

--团队信息过滤
local function raidWords(self,event,msg)
	if (EnhancedChatFilter:GetEnableFilter(info) ~= true or not IsInGroup()) then return end
	if (EnhancedChatFilter:GetEnableRAF(info) == true and msg:find(RaidAlertTag)) then
		if debugMode then print("RaidAlert Filter!") end
		return true
	end
	if (EnhancedChatFilter:GetEnableQRF(info) == true and msg:find(QuestReportTag)) then
		if debugMode then print("QuestReport Filter!") end
		return true
	end
end

ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER_INFORM", addToAllowWisper)

ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", filterdWords)
ChatFrame_AddMessageEventFilter("CHAT_MSG_YELL", filterdWords)
ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", filterdWords)
ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", cleanMessage)
ChatFrame_AddMessageEventFilter("CHAT_MSG_YELL", cleanMessage)

ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY", raidWords)
ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY_LEADER", raidWords)
ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID", raidWords)
ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_LEADER", raidWords)
ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_WARNING", raidWords)
ChatFrame_AddMessageEventFilter("CHAT_MSG_INSTANCE_CHAT", raidWords)
ChatFrame_AddMessageEventFilter("CHAT_MSG_INSTANCE_CHAT_LEADER", raidWords)

---------------------------------------FRAMES---------------------------------------------------------

--main frames
local blackListFrame = CreateFrame("Frame","ConfigFrame",UIParent,"BasicFrameTemplate")
local blackListScroll = CreateFrame("Frame", "ScrollFrame", blackListFrame)

--text
local titleText = blackListFrame:CreateFontString("frametext" ,"ARTWORK","GameFontNormal")
local titleScroll = blackListFrame:CreateFontString("frametext" ,"ARTWORK","GameFontNormal")
local titleAdd = blackListFrame:CreateFontString("frametext" ,"ARTWORK","GameFontNormal")
local titleOptions = blackListFrame:CreateFontString("frametext" ,"ARTWORK","GameFontNormal")
local toggleText = blackListFrame:CreateFontString("frametext" ,"ARTWORK","GameFontNormal")
local minimapToggleText = blackListFrame:CreateFontString("frametext" ,"ARTWORK","GameFontNormal")
local wisperToggleText = blackListFrame:CreateFontString("frametext" ,"ARTWORK","GameFontNormal")
local dndToggleText = blackListFrame:CreateFontString("frametext" ,"ARTWORK","GameFontNormal")
local rptToggleText = blackListFrame:CreateFontString("frametext" ,"ARTWORK","GameFontNormal")
local dssToggleText = blackListFrame:CreateFontString("frametext" ,"ARTWORK","GameFontNormal")
local cfaToggleText = blackListFrame:CreateFontString("frametext" ,"ARTWORK","GameFontNormal")
local rafToggleText = blackListFrame:CreateFontString("frametext" ,"ARTWORK","GameFontNormal")
local qrfToggleText = blackListFrame:CreateFontString("frametext" ,"ARTWORK","GameFontNormal")
local igmToggleText = blackListFrame:CreateFontString("frametext" ,"ARTWORK","GameFontNormal")

--toggles , input fields, buttons etc
local blackListWordField = CreateFrame("EditBox", "blackListWordField", blackListFrame,"InputBoxTemplate")
local blackListWordIOField = CreateFrame("EditBox", "blackListWordIOField", blackListFrame,"InputBoxTemplate")

local blackListWordDrop = CreateFrame("Button", "DropDownMenuTest", blackListFrame, "UIDropDownMenuTemplate")

local EnableFilterToggle = CreateFrame("CheckButton", "EnableFilterToggle", blackListFrame,"UICheckButtonTemplate")
local EnableMinimap = CreateFrame("CheckButton", "EnableMinimap", blackListFrame,"UICheckButtonTemplate")
local EnableWisper = CreateFrame("CheckButton", "enableWisper", blackListFrame,"UICheckButtonTemplate")
local EnableDND = CreateFrame("CheckButton", "enableDND", blackListFrame,"UICheckButtonTemplate")
local EnableRPT = CreateFrame("CheckButton", "enableRPT", blackListFrame,"UICheckButtonTemplate")
local EnableDSS = CreateFrame("CheckButton", "enableDSS", blackListFrame,"UICheckButtonTemplate")
local EnableCFA = CreateFrame("CheckButton", "enableCFA", blackListFrame,"UICheckButtonTemplate")
local EnableRAF = CreateFrame("CheckButton", "enableRAF", blackListFrame,"UICheckButtonTemplate")
local EnableQRF = CreateFrame("CheckButton", "enableQRF", blackListFrame,"UICheckButtonTemplate")
local EnableIGM = CreateFrame("CheckButton", "enableQRF", blackListFrame,"UICheckButtonTemplate")

local removeButton = CreateFrame("Button", "removeButton", blackListFrame, "UIPanelButtonTemplate")
local addButton = CreateFrame("Button", "addButton", blackListFrame, "UIPanelButtonTemplate")

local ioButton = CreateFrame("Button", "ioButton", blackListFrame, "UIPanelButtonTemplate")
local clearUpButton = CreateFrame("Button", "clearUpButton", blackListFrame, "UIPanelButtonTemplate")
local importButton = CreateFrame("Button", "importButton", blackListFrame, "UIPanelButtonTemplate")
local exportButton = CreateFrame("Button", "exportButton", blackListFrame, "UIPanelButtonTemplate")

local selectedWord = ""
local types = {
	"隐藏",
	"日常",
}

local function tablelength(T)
	local count = 0
	for index in pairs(T) do count = count + 1 end
	return count
end

local function SetToggleText(check,typeToggle)
	if(typeToggle == 'filter') then
		if(check ~= 'no') then
			EnhancedChatFilter:ToggleEnableFilter(info,check)
		end

		if(EnhancedChatFilter:GetEnableFilter(info) == true) then
			toggleText:SetText("|cff2ed689聊天过滤器启用(总开关)")
			EnableFilterToggle:SetChecked(true)
		else
			toggleText:SetText("|cffE2252D聊天过滤器禁用(总开关)")
			EnableFilterToggle:SetChecked(false)
		end
	elseif(typeToggle == 'minimap') then
		if(check ~= 'no') then
			EnhancedChatFilter:ToggleEnableMinimapIcon(info,check)
		end

		if(EnhancedChatFilter:GetEnableMinimapIcon(info) == true) then
			minimapToggleText:SetText("|cff2ed689小地图图标已启用(/RL)")
			EnableMinimap:SetChecked(true)
			EnhancedChatFilter:SetMinimapStatus(true)
			icon:Show("Enhanced Chat Filter")

		else
			minimapToggleText:SetText("|cffE2252D小地图图标已禁用(/RL)")
			EnableMinimap:SetChecked(false)
			EnhancedChatFilter:SetMinimapStatus(false)
			icon:Hide("Enhanced Chat Filter")

		end
	elseif(typeToggle == 'wisper') then
		if(check ~= 'no') then
			EnhancedChatFilter:ToggleEnableWisper(info,check)
		end

		if(EnhancedChatFilter:GetEnableWisper(info) == true) then
			wisperToggleText:SetText("|cff2ed689密语过滤开启(慎用)")
			EnableWisper:SetChecked(true)
		else
			wisperToggleText:SetText("|cffE2252D密语过滤关闭(安全)")
			EnableWisper:SetChecked(false)
		end
	elseif(typeToggle == 'dnd') then
		if(check ~= 'no') then
			EnhancedChatFilter:ToggleEnableDND(info,check)
		end

		if(EnhancedChatFilter:GetEnableDND(info) == true) then
			dndToggleText:SetText("|cff2ed689'忙碌'玩家过滤开启")
			EnableDND:SetChecked(true)
		else
			dndToggleText:SetText("|cffE2252D'忙碌'玩家过滤关闭")
			EnableDND:SetChecked(false)
		end
	elseif(typeToggle == 'rpt') then
		if(check ~= 'no') then
			EnhancedChatFilter:ToggleEnableRPT(info,check)
		end

		if(EnhancedChatFilter:GetEnableRPT(info) == true) then
			rptToggleText:SetText("|cff2ed689重复信息过滤开启")
			EnableRPT:SetChecked(true)
		else
			rptToggleText:SetText("|cffE2252D重复信息过滤关闭")
			EnableRPT:SetChecked(false)
		end
	elseif(typeToggle == 'dss') then
		if(check ~= 'no') then
			EnhancedChatFilter:ToggleEnableDSS(info,check)
		end

		if(EnhancedChatFilter:GetEnableDSS(info) == true) then
			dssToggleText:SetText("|cff2ed689切天赋刷屏过滤开启")
			EnableDSS:SetChecked(true)
		else
			dssToggleText:SetText("|cffE2252D切天赋刷屏过滤关闭")
			EnableDSS:SetChecked(false)
		end
	elseif(typeToggle == 'cfa') then
		if(check ~= 'no') then
			EnhancedChatFilter:ToggleEnableCFA(info,check)
		end

		if(EnhancedChatFilter:GetEnableCFA(info) == true) then
			cfaToggleText:SetText("|cff2ed689成就刷屏过滤开启")
			EnableCFA:SetChecked(true)
		else
			cfaToggleText:SetText("|cffE2252D成就刷屏过滤关闭")
			EnableCFA:SetChecked(false)
		end
	elseif(typeToggle == 'raf') then
		if(check ~= 'no') then
			EnhancedChatFilter:ToggleEnableRAF(info,check)
		end

		if(EnhancedChatFilter:GetEnableRAF(info) == true) then
			rafToggleText:SetText("|cff2ed689RaidAlert刷屏过滤开启")
			EnableRAF:SetChecked(true)
		else
			rafToggleText:SetText("|cffE2252DRaidAlert刷屏过滤关闭")
			EnableRAF:SetChecked(false)
		end
	elseif(typeToggle == 'qrf') then
		if(check ~= 'no') then
			EnhancedChatFilter:ToggleEnableQRF(info,check)
		end

		if(EnhancedChatFilter:GetEnableQRF(info) == true) then
			qrfToggleText:SetText("|cff2ed689QuestReport刷屏过滤开启")
			EnableQRF:SetChecked(true)
		else
			qrfToggleText:SetText("|cffE2252DQuestReport刷屏过滤关闭")
			EnableQRF:SetChecked(false)
		end
	elseif(typeToggle == 'igm') then
		if(check ~= 'no') then
			EnhancedChatFilter:ToggleEnableIGM(info,check)
		end

		if(EnhancedChatFilter:GetEnableIGM(info) == true) then
			igmToggleText:SetText("|cff2ed689扩展屏蔽名单启用")
			EnableIGM:SetChecked(true)
		else
			igmToggleText:SetText("|cffE2252D扩展屏蔽名单禁用")
			EnableIGM:SetChecked(false)
		end
	end
end

local function unlockHighlight()
	local offset = FauxScrollFrame_GetOffset(blackListScroll.scrollFrame)
	for i=1,14 do
		local idx = offset+i
		blackListScroll.list[i]:UnlockHighlight()
	end
end

local function BuildUpFrame()
	blackListFrame:SetSize(520,400) -- width, height
	blackListFrame:SetPoint("Center",UIParent,"CENTER",0,0)
	blackListFrame:SetFrameStrata("HIGH")
	blackListFrame:SetBackdrop({bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background", tile = true, tileSize = 16, edgeSize = 16,insets = { left = 4, right = 4, top = 4, bottom = 4 }})
	blackListFrame:Hide();

	----------------------------------------------
	--------------dropdown for types--------------
	blackListWordDrop:SetPoint("RIGHT",blackListFrame,"RIGHT",0,100)

	function OnClick(self)
		UIDropDownMenu_SetSelectedID(DropDownMenuTest, self:GetID())
		typeWord = self:GetText();
		if(newWord ~= nil) and (newWord ~= "") then
			addButton:Enable()
		end
	end

	function initialize(self, level)
		local info = UIDropDownMenu_CreateInfo()
		typeWord=types[1]

		for k,v in pairs(types) do
			info = UIDropDownMenu_CreateInfo()
			info.text = v
			info.value = v
			info.func = OnClick
			UIDropDownMenu_AddButton(info, level)
		end
	end

	UIDropDownMenu_Initialize(DropDownMenuTest, initialize)
	UIDropDownMenu_SetWidth(DropDownMenuTest, 187);
	UIDropDownMenu_SetButtonWidth(DropDownMenuTest, 124)
	UIDropDownMenu_SetSelectedID(DropDownMenuTest, 1)
	UIDropDownMenu_JustifyText(DropDownMenuTest, "LEFT")
	-----------------------------------------------------------

	blackListScroll:SetPoint("LEFT",blackListFrame,"LEFT",10,-10)
	blackListScroll:SetSize(250,300) -- width, height
	blackListScroll:SetBackdrop({edgeFile = "Interface/Tooltips/UI-Tooltip-Border",tile = true, tileSize = 16, edgeSize = 16,insets = { left = 4, right = 4, top = 4, bottom = 4 }})

	EnableFilterToggle:SetPoint("RIGHT",blackListFrame,"RIGHT",-200,20)
	EnableFilterToggle:SetScript("OnClick", function(self, button, down)
		SetToggleText(EnableFilterToggle:GetChecked(),'filter')
	end)

	EnableMinimap:SetPoint("RIGHT",blackListFrame,"RIGHT",-200,-2)
	EnableMinimap:SetScript("OnClick", function(self, button, down)
		SetToggleText(EnableMinimap:GetChecked(),'minimap')
	end)

	EnableWisper:SetPoint("RIGHT",blackListFrame,"RIGHT",-200,-24)
	EnableWisper:SetScript("OnClick", function(self, button, down)
		SetToggleText(EnableWisper:GetChecked(),'wisper')
	end)

	EnableDND:SetPoint("RIGHT",blackListFrame,"RIGHT",-200,-46)
	EnableDND:SetScript("OnClick", function(self, button, down)
		SetToggleText(EnableDND:GetChecked(),'dnd')
	end)

	EnableRPT:SetPoint("RIGHT",blackListFrame,"RIGHT",-200,-68)
	EnableRPT:SetScript("OnClick", function(self, button, down)
		SetToggleText(EnableRPT:GetChecked(),'rpt')
	end)

	EnableDSS:SetPoint("RIGHT",blackListFrame,"RIGHT",-200,-90)
	EnableDSS:SetScript("OnClick", function(self, button, down)
		SetToggleText(EnableDSS:GetChecked(),'dss')
	end)

	EnableCFA:SetPoint("RIGHT",blackListFrame,"RIGHT",-200,-112)
	EnableCFA:SetScript("OnClick", function(self, button, down)
		SetToggleText(EnableCFA:GetChecked(),'cfa')
	end)

	EnableRAF:SetPoint("RIGHT",blackListFrame,"RIGHT",-200,-134)
	EnableRAF:SetScript("OnClick", function(self, button, down)
		SetToggleText(EnableRAF:GetChecked(),'raf')
	end)

	EnableQRF:SetPoint("RIGHT",blackListFrame,"RIGHT",-200,-156)
	EnableQRF:SetScript("OnClick", function(self, button, down)
		SetToggleText(EnableQRF:GetChecked(),'qrf')
	end)

	EnableIGM:SetPoint("RIGHT",blackListFrame,"RIGHT",-200,-178)
	EnableIGM:SetScript("OnClick", function(self, button, down)
		SetToggleText(EnableIGM:GetChecked(),'igm')
	end)

	blackListWordField:SetPoint("RIGHT",blackListFrame,"RIGHT",-15,130)
	blackListWordField:SetSize(200,50) -- width, height
	blackListWordField:SetMaxLetters(40)
	blackListWordField:SetTextInsets(5, 5, 2, 2)
	blackListWordField:SetText("")
	blackListWordField:SetAutoFocus(false)
	blackListWordField:SetScript("OnTextChanged", function(self,userinput)
		if(userinput == true) then
			newWord = self:GetText();
			if(typeWord ~= nil) and (typeWord ~= "") then
				addButton:Enable()
			end
		end
	end)

	blackListWordIOField:SetPoint("BOTTOMLEFT",blackListFrame,"BOTTOMLEFT",10,-40)
	blackListWordIOField:SetSize(300,50) -- width, height
	blackListWordIOField:SetTextInsets(5, 5, 2, 2)
	blackListWordIOField:SetText("")
	blackListWordIOField:SetAutoFocus(false)
	blackListWordIOField:SetScript("OnTextChanged", function(self)
			newWord = self:GetText();
			if(typeWord ~= nil) and (typeWord ~= "") and (self:HasFocus()) then
				importButton:Enable()
			end
	end)
	blackListWordIOField:Hide()

	importButton:SetSize(100,30) -- width, height
	importButton:SetText("导入")
	importButton:SetPoint("BOTTOMLEFT",blackListFrame,"BOTTOMLEFT",315,-30)
	importButton:SetScript("OnClick", function()
		local importString = blackListWordIOField:GetText()
		local newBlackList = {}
		local oldHashString, newHashString = "", ""
		local crcCheck = nil
		if (importString == "") then
			print("导入字符串为空！请检查后重试！")
			return
		end

		if (string.find(importString, "@")) then
			importString, newHashString = strsplit("@", importString)
			newHashString = tonumber(newHashString)
			oldHashString = tonumber(StringHash(importString))
			if ( oldHashString ~= newHashString ) then
				print("导入的黑名单校验错误，请检查后重试！")
				return
			end
		else
			print("您导入的是旧版数据，导入将继续。\n为保证数据完整性，请用新版重新导出后导入！")
		end

		local newBlackList = { strsplit("|", importString) }
		local imNewWord, imTypeWord = "", ""
		for _, blacklist in ipairs(newBlackList) do
			if (blacklist ~= nil and blacklist ~= "") then
				imNewWord, imTypeWord = strsplit(",",blacklist)
				EnhancedChatFilter:InsertBlackList(info,imNewWord,imTypeWord)
			end
		end
		blackListScroll.ScrollFrameUpdate()
		blackListWordIOField:SetText("")
		importButton:Disable()
	end)
	importButton:Disable()
	importButton:Hide()

	exportButton:SetSize(100,30) -- width, height
	exportButton:SetText("导出")
	exportButton:SetPoint("BOTTOMLEFT",blackListFrame,"BOTTOMLEFT",420,-30)
	exportButton:SetScript("OnClick", function()
		blacklist = EnhancedChatFilter:GetBlackList(info)
		local blackString, hashString = "", ""
		for index, blackWord in ipairs(blacklist) do
			_, t1 = gsub(blackWord[1],"|","")
			_, t2 = gsub(blackWord[1],",","")
			_, t3 = gsub(blackWord[1],"@","")
			if (t1 + t2 + t3 == 0) then
				blackString = blackString..blackWord[1]..","..blackWord[2].."|"
			else
				print(blackWord[1].."包含非法字符！已经被忽略！")
			end
		end
		blackString = blackString:gsub("|$","")
		hashString = StringHash(blackString)
		blackListWordIOField:SetText(blackString.."@"..hashString)
		blackListWordIOField:SetFocus()
		exportButton:Disable()
	end)
	exportButton:Hide()

	addButton:SetSize(205,30) -- width, height
	addButton:SetText("添加新关键字")
	addButton:SetPoint("RIGHT",blackListFrame,"RIGHT",-25,70)
	addButton:SetScript("OnClick", function()
		EnhancedChatFilter:InsertBlackList(info,newWord,typeWord)
		blackListScroll.ScrollFrameUpdate()
		blackListWordField:SetText("")
		newWord = ""
		blackListWordField:ClearFocus()
		addButton:Disable()
	end)
	addButton:Disable()

	removeButton:SetSize(80 ,30) -- width, height
	removeButton:SetText("移除")
	removeButton:SetPoint("LEFT",blackListFrame,"LEFT",10,-175)
	removeButton:SetScript("OnClick", function()
		for i, word in ipairs(	EnhancedChatFilter:GetBlackList(info)) do
			if(selectedWord == word[1].." |cff95a5a6类型: "..word[2]) then
				unlockHighlight()
				EnhancedChatFilter:RemoveFromBlackList(info, i)
				blackListScroll.ScrollFrameUpdate()
				removeButton:Disable()
				return true;
			end
		end
	end)
	removeButton:Disable()

	ioButton:SetSize(80 ,30) -- width, height
	ioButton:SetText("导入/导出")
	ioButton:SetPoint("LEFT",blackListFrame,"LEFT",92,-175)
	ioButton:SetScript("OnClick", function()
		blackListWordIOField:SetText("")
		if (blackListWordIOField:IsVisible() == false) then
			blackListWordIOField:Show()
			importButton:Show()
			exportButton:Show()
			importButton:Disable()
			exportButton:Enable()
		else
			blackListWordIOField:Hide()
			importButton:Hide()
			exportButton:Hide()
		end
	end)

	clearUpButton:SetSize(80 ,30) -- width, height
	clearUpButton:SetText("整理")
	clearUpButton:SetPoint("LEFT",blackListFrame,"LEFT",174,-175)
	clearUpButton:SetScript("OnClick", function()
		blacklist = EnhancedChatFilter:GetBlackList(info)
		local hashWord = {}
		local newBlackList = {}

		for _,v in ipairs(blacklist) do
		   if (not hashWord[v[1]..v[2]]) then
			   newBlackList[#newBlackList+1] = { v[1], v[2] }
			   hashWord[v[1]..v[2]] = true
		   end
		end

		EnhancedChatFilter:ClearBlackList(info)

		for _,v in ipairs(newBlackList) do
			EnhancedChatFilter:InsertBlackList(info,v[1],v[2])
		end

		blackListScroll.ScrollFrameUpdate()
	end)

	titleText:SetPoint("CENTER", blackListFrame, "TOP", 0, -10)
	titleText:SetJustifyH("left")
	titleText:SetText("Enhanced Chat Filter MOD"..ecfVersioin)

	toggleText:SetPoint("LEFT",blackListFrame,"LEFT",320,20)
	toggleText:SetJustifyH("LEFT")
	SetToggleText('no','filter')

	minimapToggleText:SetPoint("LEFT",blackListFrame,"LEFT",320,-2)
	minimapToggleText:SetJustifyH("LEFT")
	SetToggleText('no','minimap')

	wisperToggleText:SetPoint("LEFT",blackListFrame,"LEFT",320,-24)
	wisperToggleText:SetJustifyH("LEFT")
	SetToggleText('no','wisper')

	dndToggleText:SetPoint("LEFT",blackListFrame,"LEFT",320,-46)
	dndToggleText:SetJustifyH("LEFT")
	SetToggleText('no','dnd')

	rptToggleText:SetPoint("LEFT",blackListFrame,"LEFT",320,-68)
	rptToggleText:SetJustifyH("LEFT")
	SetToggleText('no','rpt')

	dssToggleText:SetPoint("LEFT",blackListFrame,"LEFT",320,-90)
	dssToggleText:SetJustifyH("LEFT")
	SetToggleText('no','dss')

	cfaToggleText:SetPoint("LEFT",blackListFrame,"LEFT",320,-112)
	cfaToggleText:SetJustifyH("LEFT")
	SetToggleText('no','cfa')

	rafToggleText:SetPoint("LEFT",blackListFrame,"LEFT",320,-134)
	rafToggleText:SetJustifyH("LEFT")
	SetToggleText('no','raf')

	qrfToggleText:SetPoint("LEFT",blackListFrame,"LEFT",320,-156)
	qrfToggleText:SetJustifyH("LEFT")
	SetToggleText('no','qrf')

	igmToggleText:SetPoint("LEFT",blackListFrame,"LEFT",320,-178)
	igmToggleText:SetJustifyH("LEFT")
	SetToggleText('no','igm')

	titleOptions:SetPoint("RIGHT", blackListFrame, "RIGHT", -110,40)
	titleOptions:SetJustifyH("center")
	titleOptions:SetText("选项")

	titleAdd:SetPoint("RIGHT", blackListFrame, "RIGHT", -58,160)
	titleAdd:SetJustifyH("center")
	titleAdd:SetText("添加新黑名单关键字")

	titleScroll:SetPoint("LEFT", blackListFrame, "LEFT",100,160)
	titleScroll:SetJustifyH("center")
	titleScroll:SetText("黑名单")

	blackListScroll.list = {}
	for i=1,14 do
		blackListScroll.list[i] = CreateFrame("Button",nil,blackListScroll,"SecureHandlerClickTemplate")
		blackListScroll.list[i]:SetSize(200,20)
		blackListScroll.list[i]:SetPoint("TOPLEFT",blackListScroll,"TOPLEFT",8,(i-1)*-20-5)
		blackListScroll.list[i]:SetHighlightTexture("Interface\\Buttons\\UI-PlusButton-Hilight","ADD")
		blackListScroll.list[i]:RegisterForClicks("AnyUp", "AnyDown")

		blackListScroll.list[i].name = blackListScroll.list[i]:CreateFontString(nil,"ARTWORK","GameFontHighlight")
		blackListScroll.list[i].name:SetSize(200-16-8,50)
		blackListScroll.list[i].name:SetJustifyV("CENTER")
		blackListScroll.list[i].name:SetJustifyH("LEFT")

		blackListScroll.list[i]:SetScript("OnClick", function()
			unlockHighlight()
			blackListScroll.list[i]:LockHighlight()
			removeButton:Enable()
			selectedWord = blackListScroll.list[i].name:GetText()
		end)
	end
	blackListScroll.scrollFrame = CreateFrame("ScrollFrame","FauxScrollFrameTestScrollFrame",blackListScroll,"FauxScrollFrameTemplate")
	blackListScroll.scrollFrame:SetPoint("TOPLEFT",blackListScroll,"TOPLEFT",0,-6)
	blackListScroll.scrollFrame:SetPoint("BOTTOMRIGHT",blackListScroll,"BOTTOMRIGHT",-28,6)
	blackListScroll.scrollFrame:SetScript("OnShow",blackListScroll.ScrollFrameUpdate)
	blackListScroll.scrollFrame:SetScript("OnVerticalScroll",function(self,offset)
		FauxScrollFrame_OnVerticalScroll(self,offset,20,blackListScroll.ScrollFrameUpdate)
	end)
end

-- create startup event when player logs in
local startUp = CreateFrame("Frame")
startUp:RegisterEvent("PLAYER_LOGIN");

--function that gets called when an event within startUp triggers.
startUp:SetScript("OnEvent", function(self, event, ...)
	BuildUpFrame()
	print("|cffffff00Enhanced Chat Filter MOD|r|cff3498db v"..ecfVersioin.."|cffecf0f1 - 键入 '/cf' 打开配置窗口");
end)

function blackListScroll.ScrollFrameUpdate()
	local offset = FauxScrollFrame_GetOffset(blackListScroll.scrollFrame)
	FauxScrollFrame_Update(blackListScroll.scrollFrame, tablelength(EnhancedChatFilter:GetBlackList(info)), 14, 20)

	for i=1,14 do
		local idx = offset+i
		if idx<=tablelength(EnhancedChatFilter:GetBlackList(info)) then
			blackListScroll.list[i].name:SetPoint("LEFT",blackListScroll.list[i],"LEFT",2)
			blackListScroll.list[i].name:SetTextColor(1,1,1)
			blackListScroll.list[i].name:SetText(EnhancedChatFilter:GetBlackList(info)[idx][1].." |cff95a5a6类型: ".. EnhancedChatFilter:GetBlackList(info)[idx][2])

			blackListScroll.list[i]:Show()
		else
			blackListScroll.list[i]:Hide()
		end
	end
end

--method run on /cf
function EnhancedChatFilter:EnhancedChatFilterOpen()
	if(InCombatLockdown()) then return end
	if(blackListFrame:IsVisible() == false) then
		blackListFrame:Show()
		unlockHighlight()
		removeButton:Disable()
	else
		blackListFrame:Hide()
	end
end

--method run on /cf-toggle
function EnhancedChatFilter:EnhancedChatFilterToggle()
	if(EnhancedChatFilter:GetEnableFilter(info) == false) then
		EnhancedChatFilter:ToggleEnableFilter(info, true)
		print("聊天过滤器启用")
		SetToggleText(EnhancedChatFilter:GetEnableFilter(info),'filter')
	else
		EnhancedChatFilter:ToggleEnableFilter(info, false)
		print("聊天过滤器禁用")
		SetToggleText(EnhancedChatFilter:GetEnableFilter(info),'filter')
	end

end

--method run on /cf-clear
function EnhancedChatFilter:EnhancedChatFilterClear()
	EnhancedChatFilter:ClearBlackList(info)
	blackListScroll.ScrollFrameUpdate()
	print("已清空黑名单")
end

--method run on /cf-iml
function EnhancedChatFilter:EnhancedChatFilterIgnoreMoreList()
	local ignoreMoreList = EnhancedChatFilter:GetIgnoreMoreList(info)
	print("扩展屏蔽名单列表： \n")
	for index,ignorePlayer in ipairs(ignoreMoreList) do
		print(ignorePlayer[1])
	end
end

--method run on /cf-cleariml
function EnhancedChatFilter:EnhancedChatFilterClearIMList()
	EnhancedChatFilter:ClearIgnoreMoreList(info)
	print("已清空扩展屏蔽名单")
end

--防止切天赋刷屏模块
local spamFilterMatch1 = string.gsub(ERR_LEARN_ABILITY_S:gsub('%.', '%.'), '%%s', '(.*)')
local spamFilterMatch2 = string.gsub(ERR_LEARN_SPELL_S:gsub('%.', '%.'), '%%s', '(.*)')
local spamFilterMatch3 = string.gsub(ERR_SPELL_UNLEARNED_S:gsub('%.', '%.'), '%%s', '(.*)')
local spamFilterMatch4 = string.gsub(ERR_LEARN_PASSIVE_S:gsub('%.', '%.'), '%%s', '(.*)')
local petFilterMatch1 = string.gsub(ERR_PET_SPELL_UNLEARNED_S:gsub('%.', '%.'), '%%s', '(.*)')
local petFilterMatch2 = string.gsub(ERR_PET_LEARN_ABILITY_S:gsub('%.', '%.'), '%%s', '(.*)')
local petFilterMatch3 = string.gsub(ERR_PET_LEARN_SPELL_S:gsub('%.', '%.'), '%%s', '(.*)')
local notinparty = "你现在没有在一个队伍中"
local notininstant = "你不在副本队伍中"
local notinraid = "你不在一个团队中"
local primarySpecSpellName = GetSpellInfo(63645)
local secondarySpecSpellName = GetSpellInfo(63644)

local HideSpam = CreateFrame("Frame");
HideSpam:RegisterEvent("UNIT_SPELLCAST_START");
HideSpam:RegisterEvent("UNIT_SPELLCAST_STOP");
HideSpam:RegisterEvent("UNIT_SPELLCAST_INTERRUPTED");
HideSpam:RegisterEvent("PLAYER_LOGIN");

HideSpam.NotIn = function(self, event, msg, ...)
	if EnhancedChatFilter:GetEnableDSS(info) ~= true then return end
	if strfind(msg, notinparty) then
		return true
	elseif strfind(msg, notininstant) then
		return true
	elseif strfind(msg, notinraid) then
		return true
	end
	return false, msg, ...
end

HideSpam.filter = function(self, event, msg, ...)
	if EnhancedChatFilter:GetEnableDSS(info) ~= true then return end
	if strfind(msg, spamFilterMatch1) then
		return true
	elseif strfind(msg, spamFilterMatch2) then
		return true
	elseif strfind(msg, spamFilterMatch3) then
		return true
	elseif strfind(msg, spamFilterMatch4) then
		return true
	end
	return false, msg, ...
end

HideSpam.Petfilter = function(self, event, msg, ...)
	if EnhancedChatFilter:GetEnableDSS(info) ~= true then return end
	if strfind(msg, petFilterMatch1) then
		return true
	elseif strfind(msg, petFilterMatch2) then
		return true
	elseif strfind(msg, petFilterMatch3) then
		return true
	end
	return false, msg, ...
end

HideSpam:SetScript("OnEvent", function( self, event, ...)

	local unit, spellName = ...

	if event == "PLAYER_LOGIN" then
		self:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
		self:RegisterEvent("PET_SPECIALIZATION_CHANGED")
		ChatFrame_AddMessageEventFilter("CHAT_MSG_SYSTEM", self.NotIn)

	elseif(event == "UNIT_SPELLCAST_START") then
		if unit == "player" and (spellName == primarySpecSpellName or spellName == secondarySpecSpellName) then
			ChatFrame_AddMessageEventFilter("CHAT_MSG_SYSTEM", self.filter)
		end

	elseif(event == "UNIT_SPELLCAST_STOP") or (event == "UNIT_SPELLCAST_INTERRUPTED") then
		if unit == "player" and (spellName == primarySpecSpellName or spellName == secondarySpecSpellName) then
			ChatFrame_RemoveMessageEventFilter("CHAT_MSG_SYSTEM", self.filter)
		end

	elseif(event == "ACTIVE_TALENT_GROUP_CHANGED") then
		local specId = GetSpecialization(false, false, group);
		if (specId == nil) then
			print("切换到未配置天赋.")
		else
			local _, spec, _, icon = GetSpecializationInfo(specId, false, false);
			print("已切换到  |T".. icon ..":0|t |cff6adb54".. spec .."|r 天赋.")
		end

	elseif(event == "PET_SPECIALIZATION_CHANGED") then
		ChatFrame_AddMessageEventFilter("CHAT_MSG_SYSTEM", self.Petfilter)
	end

end);

-----------------------------------------------------------------------
-- ChatFilter 成就刷屏过滤模块
-----------------------------------------------------------------------
local _G = _G
local strsub, pairs, getn, tinsert, tremove, sort, select, format, tonumber, strlen, strmatch = strsub, pairs, getn, tinsert, tremove, sort, select, format, tonumber, strlen, string.match

local ChatFilter = CreateFrame("Frame")
local achievements, alreadySent = {}, {}
local spamCategories, specialFilters = {[95] = true, [155] = true, [168] = true, [14807] = true, [15165] = true}, {[456] = true, [1400] = true, [1402] = true, [2186] = true, [2187] = true, [2903] = true, [2904] = true, [3004] = true, [3005] = true, [3117] = true, [3259] = true, [3316] = true, [3808] = true, [3809] = true, [3810] = true, [3817] = true, [3818] = true, [3819] = true, [4078] = true, [4079] = true, [4080] = true, [4156] = true, [4576] = true, [4626] = true, [5313] = true, [6954] = true, [7485] = true, [7486] = true, [7487] = true, [8089] = true, [8238] = true, [8246] = true, [8248] = true, [8249] = true, [8260] = true, [8306] = true, [8307] = true, [8398] = true, [8399] = true, [8400] = true, [8401] = true, [8430] = true, [8431] = true, [8432] = true, [8433] = true, [8434] = true, [8435] = true, [8436] = true, [8437] = true, [8438] = true, [8439] = true}

local function SendMessage(event, msg, r, g, b)
	local info = ChatTypeInfo[strsub(event, 10)]
	for i = 1, NUM_CHAT_WINDOWS do
		ChatFrames = _G["ChatFrame"..i]
		if (ChatFrames and ChatFrames:IsEventRegistered(event)) then
			ChatFrames:AddMessage(msg, info.r, info.g, info.b)
		end
	end
end

local function SendAchievement(event, achievementID, players)
	if (not players) then return end
	for k in pairs(alreadySent) do alreadySent[k] = nil end
	for i = getn(players), 1, -1 do
		if (alreadySent[players[i].name]) then
			tremove(players, i)
		else
			alreadySent[players[i].name] = true
		end
	end
	if (getn(players) > 1) then
		sort(players, function(a, b) return a.name < b.name end)
	end
	for i = 1, getn(players) do
		local class, color, r, g, b
		if (players[i].guid and players[i].guid:find("Player")) then
			class = select(2, GetPlayerInfoByGUID(players[i].guid))
			color = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[class]
		end
		if (not color) then
			local info = ChatTypeInfo[strsub(event, 10)]
			r, g, b = info.r, info.g, info.b
		else
			r, g, b = color.r, color.g, color.b
		end
		players[i] = format("|cff%02x%02x%02x|Hplayer:%s|h%s|h|r", r*255, g*255, b*255, players[i].name, players[i].name)
	end
	SendMessage(event, format("[%s]获得了成就%s!", table.concat(players, "、"), GetAchievementLink(achievementID)))
end

local function achievementReady(id, achievement)
	if (achievement.area and achievement.guild) then
		local playerGuild = GetGuildInfo("player")
		for i = getn(achievement.area), 1, -1 do
			local player = achievement.area[i].name
			if (UnitExists(player) and playerGuild and playerGuild == GetGuildInfo(player)) then
				tinsert(achievement.guild, tremove(achievement.area, i))
			end
		end
	end
	if (achievement.area and getn(achievement.area) > 0) then
		SendAchievement("CHAT_MSG_ACHIEVEMENT", id, achievement.area)
	end
	if (achievement.guild and getn(achievement.guild) > 0) then
		SendAchievement("CHAT_MSG_GUILD_ACHIEVEMENT", id, achievement.guild)
	end
end

local function ChatFrames_OnUpdate(self, elapsed)
	local found
	for id, achievement in pairs(achievements) do
		if (achievement.timeout <= GetTime()) then
			achievementReady(id, achievement)
			achievements[id] = nil
		end
		found = true
	end
	if (not found) then
		self:SetScript("OnUpdate", nil)
	end
end

local function queueAchievementSpam(event, achievementID, playerdata)
	achievements[achievementID] = achievements[achievementID] or {timeout = GetTime() + 0.5}
	achievements[achievementID][event] = achievements[achievementID][event] or {}
	tinsert(achievements[achievementID][event], playerdata)
	ChatFilter:SetScript("OnUpdate", ChatFrames_OnUpdate)
end

local function ChatFilter_Achievement(self, event, msg, player, _, _, _, _, _, _, _, _, _, guid)
	if EnhancedChatFilter:GetEnableCFA(info) ~= true then return end
	local achievementID = strmatch(msg, "achievement:(%d+)")
	if (not achievementID) then return end
	achievementID = tonumber(achievementID)
	local player, Name, Server = player
	if (guid and guid:find("Player")) then
		Name = select(6, GetPlayerInfoByGUID(guid))
		Server = select(7, GetPlayerInfoByGUID(guid))
		player = Name or player
		if (Name and Server and strlen(Server) > 0 and Server ~= GetRealmName()) then
			player = Name.."-"..Server
		end
	end
	local playerdata = {name = player, guid = guid}
	local categoryID = GetAchievementCategory(achievementID)
	if (spamCategories[categoryID] or spamCategories[select(2, GetCategoryInfo(categoryID))] or specialFilters[achievementID]) then
		queueAchievementSpam((event == "CHAT_MSG_GUILD_ACHIEVEMENT" and "guild" or "area"), achievementID, playerdata)
		return true
	end
end

ChatFrame_AddMessageEventFilter("CHAT_MSG_ACHIEVEMENT", ChatFilter_Achievement)
ChatFrame_AddMessageEventFilter("CHAT_MSG_GUILD_ACHIEVEMENT", ChatFilter_Achievement)

--拾取物品过滤器(阿什兰破碎骨骼)
local ashranBadWords = {"破碎骨骼", "神器碎片"}
function bonesfilter(self,event,msg)
	for _, word in ipairs(ashranBadWords) do
		if (string.find(msg, word)) then
			return true
		end
	end
end

ChatFrame_AddMessageEventFilter("CHAT_MSG_LOOT", bonesfilter)
