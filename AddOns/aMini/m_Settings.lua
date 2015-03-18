local SCREENSHOT_QUALITY = 7
local ainvenabled = false
local autorollgreens = true
local HideErrors = true
local autoacceptDE = true

---------------- > Some slash commands
SlashCmdList['RELOADUI'] = function() ReloadUI() end
SLASH_RELOADUI1 = '/rl'

SlashCmdList["TICKET"] = function() ToggleHelpFrame() end
SLASH_TICKET1 = "/gm"

SlashCmdList["READYCHECKSLASHRC"] = function() DoReadyCheck() end
SLASH_READYCHECKSLASHRC1 = '/rc'

SlashCmdList["DISABLE_ADDON"] = function(s) DisableAddOn(s) print(s, format("|cffd36b6b disabled")) end
SLASH_DISABLE_ADDON1 = "/dis"   -- You need to reload UI after enabling/disabling addon

SlashCmdList["ENABLE_ADDON"] = function(s) EnableAddOn(s) print(s, format("|cfff07100 enabled")) end
SLASH_ENABLE_ADDON1 = "/en"   -- You need to reload UI after enabling/disabling addon

SlashCmdList["CLCE"] = function() CombatLogClearEntries() end
SLASH_CLCE1 = "/clfix"

DEFAULT_CHAT_FRAME:AddMessage("|c0000FF00                         >>>欢迎使用OPoA's UI!<<<                          ")
DEFAULT_CHAT_FRAME:AddMessage("|c0000FF00                           >>>整合者:msylgj0<<<                            ")
DEFAULT_CHAT_FRAME:AddMessage("|c0000FF00                      >>>使用/opoaui查看使用说明<<<                     ")



SlashCmdList["OPOAUI"] = function(msg)   
  local cmd = msg:lower()
  if cmd == "cmd" then
      print("常用指令说明:\n打开网格:/align\n获取鼠标指向框体名:/gf\n快速切换天赋:/ss\n自动邀请:/ainv\n解散团队:/rd\n鼠标指向按键绑定 /hb\n模式化聊天框:/setchat\n伤害显示插件移动:/dct\n/dex\n获得buff文字提示移动:/dex\n背包缩放:/cbniv scale 数字")
  elseif cmd == "lua" then
	  print("常用设置修改:\n聊天设置:m_Chat\\m_Chat.lua\n技能监视:Sora's AuraWatch\\AuraWatchList.lua\n小地图位置:m_Minimap\\m_Minimap.lua\n姓名板相关:m_Nameplates\\cfg.lua\n头像相关:oUF_Qulight\\cfg.lua")
  else
      print("/opoaui cmd >>查看常用指令说明")
	  print("/opoaui lua >>查看常用设置修改")
	  print("插件原帖地址:http://nga.178.com/read.php?tid=4439195")
  end
end

SLASH_OPOAUI1 = "/opoaui";
-- a command to show frame you currently have mouseovered
SlashCmdList["FRAME"] = function(arg)
	if arg ~= "" then
		arg = _G[arg]
	else
		arg = GetMouseFocus()
	end
	if arg ~= nil and arg:GetName() ~= nil then
		local point, relativeTo, relativePoint, xOfs, yOfs = arg:GetPoint()
		ChatFrame1:AddMessage("Name: |cffFFD100"..arg:GetName())
		if arg:GetParent() then
			ChatFrame1:AddMessage("Parent: |cffFFD100"..arg:GetParent():GetName())
		end
 		ChatFrame1:AddMessage("Width: |cffFFD100"..format("%.2f",arg:GetWidth()))
		ChatFrame1:AddMessage("Height: |cffFFD100"..format("%.2f",arg:GetHeight()))
		ChatFrame1:AddMessage("Strata: |cffFFD100"..arg:GetFrameStrata())
		ChatFrame1:AddMessage("Level: |cffFFD100"..arg:GetFrameLevel())
 		if xOfs then
			ChatFrame1:AddMessage("X: |cffFFD100"..format("%.2f",xOfs))
		end
		if yOfs then
			ChatFrame1:AddMessage("Y: |cffFFD100"..format("%.2f",yOfs))
		end
		if relativeTo then
			ChatFrame1:AddMessage("Point: |cffFFD100"..point.."|r anchored to "..relativeTo:GetName().."'s |cffFFD100"..relativePoint)
		end
		ChatFrame1:AddMessage("----------------------")
	elseif arg == nil then
		ChatFrame1:AddMessage("Invalid frame name")
	else
		ChatFrame1:AddMessage("Could not find frame info")
	end
end
SLASH_FRAME1 = "/gf"

-- simple spec switching
SlashCmdList["SPEC"] = function() 
	local spec = GetActiveSpecGroup(false,false)
	SetActiveSpecGroup(spec == 1 and 2 or 1)
end
SLASH_SPEC1 = "/ss"

---------------- > Proper Ready Check sound
local ShowReadyCheckHook = function(self, initiator, timeLeft)
	if initiator ~= "player" then PlaySound("ReadyCheck") end
end
hooksecurefunc("ShowReadyCheck", ShowReadyCheckHook)


-- UI缩放修正 --
SlashCmdList["AutoSet"] = function()
	if not InCombatLockdown() then
		SetCVar("useUiScale", 1)
		local scale = 768/string.match(({GetScreenResolutions()})[GetCurrentResolution()], "%d+x(%d+)")
		if scale < .64 then
			UIParent:SetScale(scale)
		else
			SetCVar("uiScale", scale)
		end
		ReloadUI()
	end
end
SLASH_AutoSet1 = "/autoset"
SLASH_AutoSet2 = "/as"

---------------- > SetupUI
SetCVar("profanityFilter", 0)
SetCVar("scriptErrors", 1)
SetCVar("buffDurations", 1)
SetCVar("consolidateBuffs",0)
SetCVar("autoLootDefault", 1)
SetCVar("lootUnderMouse", 1)
SetCVar("autoSelfCast", 1)
SetCVar("ShowClassColorInNameplate", 1)
SetCVar("cameraDistanceMax", 50)
SetCVar("cameraDistanceMaxFactor", 3.4)
SetCVar("screenshotQuality", SCREENSHOT_QUALITY)
SetCVar("synchronizeSettings", 1)

---------------- > Moving TicketStatusFrame
TicketStatusFrame:ClearAllPoints()
TicketStatusFrame:SetPoint("TOPLEFT",UIParent,"TOPLEFT")
TicketStatusFrame.SetPoint = function() end

---------------- > ALT+RightClick to buy a stack
hooksecurefunc("MerchantItemButton_OnModifiedClick", function(self, button)
    if MerchantFrame.selectedTab == 1 then
        if IsAltKeyDown() and button=="RightButton" then
            local id=self:GetID()
			local quantity = select(4, GetMerchantItemInfo(id))
            local extracost = select(7, GetMerchantItemInfo(id))
            if not extracost then
                local stack 
				if quantity > 1 then
					stack = quantity*GetMerchantItemMaxStack(id)
				else
					stack = GetMerchantItemMaxStack(id)
				end
                local amount = 1
                if self.count < stack then
                    amount = stack / self.count
                end
                if self.numInStock ~= -1 and self.numInStock < amount then
                    amount = self.numInStock
                end
                local money = GetMoney()
                if (self.price * amount) > money then
                    amount = floor(money / self.price)
                end
                if amount > 0 then
                    BuyMerchantItem(id, amount)
                end
            end
        end
    end
end)

---------------- > Hiding default blizzard's Error Frame (thx nightcracker)
if HideErrors then
local f, o, ncErrorDB = CreateFrame("Frame"), "No error yet.", {
	[INVENTORY_FULL] = true,
}
f:SetScript("OnEvent", function(self, event, error)
	if ncErrorDB[error] then
		UIErrorsFrame:AddMessage(error)
	else
	o = error
	end
end)
SLASH_NCERROR1 = "/error"
function SlashCmdList.NCERROR() print(o) end
UIErrorsFrame:UnregisterEvent("UI_ERROR_MESSAGE")
f:RegisterEvent("UI_ERROR_MESSAGE")
end

---------------- > Autoinvite by whisper
local autoinvite = CreateFrame("frame")
autoinvite:RegisterEvent("CHAT_MSG_WHISPER")
autoinvite:SetScript("OnEvent", function(self,event,arg1,arg2)
	if ((not UnitExists("party1") or UnitIsGroupLeader("player") or UnitIsGroupAssistant("player")) and arg1 == "1") and ainvenabled == true then
		InviteUnit(arg2)
	end
end)
function SlashCmdList.AUTOINVITE(msg, editbox)
	if (msg == 'off') then
		ainvenabled = false
		print("自动邀请已关闭")
	else
		ainvenabled = true
		SendChatMessage(msg.."开组!退组M我打1进组!","GUILD")
	end
end
SLASH_AUTOINVITE1 = '/ainv'
---------------- > Disband Group
local GroupDisband = function()
	local pName = UnitName("player")
	if UnitInRaid("player") then
	SendChatMessage("解散当前队伍", "RAID")
		for i = 1, GetNumGroupMembers() do
			local name, _, _, _, _, _, _, online = GetRaidRosterInfo(i)
			if online and name ~= pName then
				UninviteUnit(name)
			end
		end
	LeaveParty()
	elseif UnitInParty("player") then
		SendChatMessage("解散当前队伍", "PARTY")
		for i = 1, GetNumSubgroupMembers() do
			if UnitName("party"..i) then
				UninviteUnit(UnitName("party"..i))
			end
		end
	LeaveParty()
	else
		StaticPopup_Show("NOGROUP")
	end
	
end
StaticPopupDialogs["DISBAND_GROUP"] = {
	text = "确认要解散当前队伍?",
	button1 = YES,
	button2 = NO,
	OnAccept = GroupDisband,
	timeout = 0,
	whileDead = 1,
}

StaticPopupDialogs["NOGROUP"] = {
	text = "你没有在任何一个队伍中!",
	button1 = OKAY,
	timeout = 0,
	whileDead = 1,
}

SlashCmdList["GROUPDISBAND"] = function()
	StaticPopup_Show("DISBAND_GROUP")
end
SLASH_GROUPDISBAND1 = '/rd'

---------------- > Autogreed on greens © tekkub
if autorollgreens then
	local f = CreateFrame("Frame", nil, UIParent)
	f:RegisterEvent("START_LOOT_ROLL")
	f:SetScript("OnEvent", function(_, _, id)
	if not id then return end -- What the fuck?
	local _, _, _, quality, bop, _, _, canDE = GetLootRollItemInfo(id)
	if quality == 2 and not bop then RollOnLoot(id, canDE and 3 or 2) end
	end)
end

---------------- > ©tekKrush by tekkub
if autoacceptDE then
--	if GetNumRaidMembers() > 0 then return end
	local f = CreateFrame("Frame")
	f:RegisterEvent("CONFIRM_DISENCHANT_ROLL")
	f:SetScript("OnEvent", function(self, event, id, rollType)
		for i=1,STATICPOPUP_NUMDIALOGS do
			local frame = _G["StaticPopup"..i]
			if frame.which == "CONFIRM_LOOT_ROLL" and frame.data == id and frame.data2 == rollType and frame:IsVisible() then StaticPopup_OnClick(frame, 1) end
		end
	end)
end

--快速隐藏显示头盔披风 y368413分享
local GameTooltip = GameTooltip 
local helmcb = CreateFrame("CheckButton", nil, PaperDollFrame) 
helmcb:ClearAllPoints() 
helmcb:SetSize(22,22) 
helmcb:SetFrameLevel(10) 
helmcb:SetPoint("TOPLEFT", CharacterHeadSlot, "BOTTOMRIGHT", 5, 5) 
helmcb:SetScript("OnClick", function() ShowHelm(not ShowingHelm()) end) 
helmcb:SetScript("OnEnter", function(self) 
    GameTooltip:SetOwner(self, "ANCHOR_RIGHT") 
   GameTooltip:SetText("显示/隐藏 头部") 
end) 
helmcb:SetScript("OnLeave", function() GameTooltip:Hide() end) 
helmcb:SetScript("OnEvent", function() helmcb:SetChecked(ShowingHelm()) end) 
helmcb:SetNormalTexture("Interface\\Buttons\\UI-CheckBox-Up") 
helmcb:SetPushedTexture("Interface\\Buttons\\UI-CheckBox-Down") 
helmcb:SetHighlightTexture("Interface\\Buttons\\UI-CheckBox-Highlight") 
helmcb:SetDisabledCheckedTexture("Interface\\Buttons\\UI-CheckBox-Check-Disabled") 
helmcb:SetCheckedTexture("Interface\\Buttons\\UI-CheckBox-Check") 
helmcb:RegisterEvent("UNIT_MODEL_CHANGED") 

local cloakcb = CreateFrame("CheckButton", nil, PaperDollFrame) 
cloakcb:ClearAllPoints() 
cloakcb:SetSize(22,22) 
cloakcb:SetFrameLevel(10) 
cloakcb:SetPoint("TOPLEFT", CharacterBackSlot, "BOTTOMRIGHT", 5, 5) 
cloakcb:SetScript("OnClick", function() ShowCloak(not ShowingCloak()) end) 
cloakcb:SetScript("OnEnter", function(self) 
   GameTooltip:SetOwner(self, "ANCHOR_RIGHT") 
   GameTooltip:SetText("显示/隐藏 披风") 
end) 
cloakcb:SetScript("OnLeave", function() GameTooltip:Hide() end) 
cloakcb:SetScript("OnEvent", function() cloakcb:SetChecked(ShowingCloak()) end) 
cloakcb:SetNormalTexture("Interface\\Buttons\\UI-CheckBox-Up") 
cloakcb:SetPushedTexture("Interface\\Buttons\\UI-CheckBox-Down") 
cloakcb:SetHighlightTexture("Interface\\Buttons\\UI-CheckBox-Highlight") 
cloakcb:SetDisabledCheckedTexture("Interface\\Buttons\\UI-CheckBox-Check-Disabled") 
cloakcb:SetCheckedTexture("Interface\\Buttons\\UI-CheckBox-Check") 
cloakcb:RegisterEvent("UNIT_MODEL_CHANGED") 

helmcb:SetChecked(ShowingHelm()) 
cloakcb:SetChecked(ShowingCloak())

--玩具界面默认显示已收集 banewu分享
ToyBoxFilterFixerFilter = false
local f, name = CreateFrame('frame'), ...
f:SetScript('OnEvent', function(self, event, addon)
	if addon == name then
		C_ToyBox.SetFilterUncollected(ToyBoxFilterFixerFilter)
		hooksecurefunc(C_ToyBox, 'SetFilterUncollected', function(filter) ToyBoxFilterFixerFilter = filter end)
		self:UnregisterEvent(event)
	end
end)
f:RegisterEvent('ADDON_LOADED')

--自动存材料到材料银行 素年已逝分享
local frame = CreateFrame("Frame")

frame:RegisterEvent("BANKFRAME_OPENED")
frame:SetScript("OnEvent", function(self, event, ...)
   if not BankFrameItemButton_Update_OLD then
      BankFrameItemButton_Update_OLD = BankFrameItemButton_Update
      BankFrameItemButton_Update = function(button)
         if button then
            BankFrameItemButton_Update_OLD(button)
         end
      end      
   end
   DepositReagentBank()
end)

--一键收取邮件  jj89520分享
local deletedelay, t = 0.5, 0 
local takingOnlyCash = false 
local button, button2, waitForMail, doNothing, openAll, openAllCash, openMail, lastopened, stopOpening, onEvent, needsToWait, copper_to_pretty_money, total_cash 
local _G = _G 
local baseInboxFrame_OnClick 
function doNothing() end 

function openAll() 
   if GetInboxNumItems() == 0 then return end 
   button:SetScript("OnClick", nil) 
   button2:SetScript("OnClick", nil) 
   baseInboxFrame_OnClick = InboxFrame_OnClick 
   InboxFrame_OnClick = doNothing 
   button:RegisterEvent("UI_ERROR_MESSAGE") 
   openMail(GetInboxNumItems()) 
end 
function openAllCash() 
   takingOnlyCash = true 
   openAll() 
end 
function openMail(index) 
   if not InboxFrame:IsVisible() then return stopOpening("Need a mailbox.") end 
   if index == 0 then return stopOpening("Reached the end.", true) end 
   local _, _, _, _, money, COD, _, numItems = GetInboxHeaderInfo(index) 
   if not takingOnlyCash then 
      if money > 0 or (numItems and numItems > 0) and COD <= 0 then 
         AutoLootMailItem(index) 
         needsToWait = true 
      end 
   elseif money > 0 then 
      TakeInboxMoney(index) 
      needsToWait = true 
      if total_cash then total_cash = total_cash - money end 
   end 
   local items = GetInboxNumItems() 
   if (numItems and numItems > 0) or (items > 1 and index <= items) then 
      lastopened = index 
      button:SetScript("OnUpdate", waitForMail) 
   else 
      stopOpening("All done.", true) 
   end 
end 
function waitForMail(this, arg1) 
   t = t + arg1 
   if (not needsToWait) or (t > deletedelay) then 
      if not InboxFrame:IsVisible() then return stopOpening("Need a mailbox.") end 
      t = 0 
      needsToWait = false 
      button:SetScript("OnUpdate", nil) 
       
      local _, _, _, _, money, COD, _, numItems = GetInboxHeaderInfo(lastopened) 
      if money > 0 or ((not takingOnlyCash) and COD <= 0 and numItems and (numItems > 0)) then 
         --The lastopened index inbox item still contains stuff we want 
         openMail(lastopened) 
      else 
         openMail(lastopened - 1) 
      end 
   end 
end 
function stopOpening(msg, hide_minimap_button, ...) 
   button:SetScript("OnUpdate", nil) 
   button:SetScript("OnClick", openAll) 
   button2:SetScript("OnClick", openAllCash) 
   if baseInboxFrame_OnClick then 
      InboxFrame_OnClick = baseInboxFrame_OnClick 
   end 
   button:UnregisterEvent("UI_ERROR_MESSAGE") 
   takingOnlyCash = false 
   total_cash = nil 
   needsToWait = false 
   if hide_minimap_button then MiniMapMailFrame:Hide() end 
   if msg then DEFAULT_CHAT_FRAME:AddMessage("OpenAll: "..msg, ...) end 
end 
function onEvent(frame, event, arg1, arg2, arg3, arg4) 
   if event == "UI_ERROR_MESSAGE" then 
      if arg1 == ERR_INV_FULL then 
         stopOpening("Stopped, inventory is full.") 
      end 
   end 
end 
local function makeButton(id, text, w, h, x, y) 
   local button = CreateFrame("Button", id, InboxFrame, "UIPanelButtonTemplate") 
   button:SetWidth(w) 
   button:SetHeight(h) 
   button:SetPoint("CENTER", InboxFrame, "TOP", x, y) 
   button:SetText(text) 
   return button 
end
button = makeButton("TakeAllButton", "Take All", 80, 25, -60, -410) 
button:SetScript("OnClick", openAll) 
button:SetScript("OnEvent", onEvent) 
button2 = makeButton("TakeCashButton", "Take Cash", 80, 25, 30, -410)
button2:SetScript("OnClick", openAllCash) 

button:SetScript("OnEnter", function() 
   GameTooltip:SetOwner(button, "ANCHOR_RIGHT") 
   GameTooltip:AddLine(string.format("%d messages", GetInboxNumItems()), 1, 1, 1) 
   GameTooltip:Show() 
end) 
button:SetScript("OnLeave", function() GameTooltip:Hide() end) 

function copper_to_pretty_money(c) 
   if c > 10000 then 
      return ("%d|cffffd700g|r%d|cffc7c7cfs|r%d|cffeda55fc|r"):format(c/10000, (c/100)%100, c%100) 
   elseif c > 100 then 
      return ("%d|cffc7c7cfs|r%d|cffeda55fc|r"):format((c/100)%100, c%100) 
   else 
      return ("%d|cffeda55fc|r"):format(c%100) 
   end 
end 
button2:SetScript("OnEnter", function() 
   if not total_cash then 
      total_cash = 0 
      for index=0, GetInboxNumItems() do 
         total_cash = total_cash + select(5, GetInboxHeaderInfo(index)) 
      end 
   end 
   GameTooltip:SetOwner(button, "ANCHOR_RIGHT") 
   GameTooltip:AddLine(copper_to_pretty_money(total_cash), 1, 1, 1) 
   GameTooltip:Show() 
end) 
button2:SetScript("OnLeave", function() GameTooltip:Hide() end)

local F = unpack(Aurora)
F.Reskin(button)
F.Reskin(button2)