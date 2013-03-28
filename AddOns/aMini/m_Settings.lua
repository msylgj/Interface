﻿local SCREENSHOT_QUALITY = 7
local ainvenabled = false
local autorollgreens = false
local HideErrors = true
local autoacceptDE = false

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
      print("常用指令说明:\n打开网格:/align\n移动任务追踪框体:/wf\n获取鼠标指向框体名:/gf\n快速切换天赋:/ss\n自动邀请:/ainv\n解散团队:/rd\n鼠标指向按键绑定 /hb\n模式化聊天框:/setchat\n伤害显示插件移动:/xct")
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

-- Quest tracker(by Tukz)
local wf = WatchFrame
local wfmove = false 

wf:SetMovable(true);
wf:SetClampedToScreen(false); 
wf:ClearAllPoints()
wf:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -35, -200)
wf:SetWidth(250)
wf:SetHeight(500)
wf:SetUserPlaced(true)
wf.SetPoint = function() end

local function WATCHFRAMELOCK()
	if wfmove == false then
		wfmove = true
		print("WatchFrame unlocked for drag")
		wf:EnableMouse(true);
		wf:RegisterForDrag("LeftButton"); 
		wf:SetScript("OnDragStart", wf.StartMoving); 
		wf:SetScript("OnDragStop", wf.StopMovingOrSizing);
	elseif wfmove == true then
		wf:EnableMouse(false);
		wfmove = false
		print("WatchFrame locked")
	end
end

SLASH_WATCHFRAMELOCK1 = "/wf"
SlashCmdList["WATCHFRAMELOCK"] = WATCHFRAMELOCK

-- simple spec switching
SlashCmdList["SPEC"] = function() 
local spec = GetActiveTalentGroup()
if spec == 1 then SetActiveTalentGroup(2) elseif spec == 2 then SetActiveTalentGroup(1) end
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

---副本自动收起任务追踪
local autocollapse = CreateFrame("Frame")
autocollapse:RegisterEvent("ZONE_CHANGED_NEW_AREA")
autocollapse:RegisterEvent("PLAYER_ENTERING_WORLD")
autocollapse:SetScript("OnEvent", function(self)
   if IsInInstance() then
      WatchFrame.userCollapsed = true
      WatchFrame_Collapse(WatchFrame)
   else
      WatchFrame.userCollapsed = nil
      WatchFrame_Expand(WatchFrame)
   end
end)
----修复地城导览
hooksecurefunc("EncounterJournal_LoadUI", function()
    function EncounterJournal_Loot_OnUpdate(self)
        if GameTooltip:IsOwned(self) then
            if IsModifiedClick("COMPAREITEMS") or
                    (GetCVarBool("alwaysCompareItems") and not GameTooltip:IsEquippedItem()) then
                GameTooltip_ShowCompareItem();
            else
                ShoppingTooltip1:Hide();
                ShoppingTooltip2:Hide();
                ShoppingTooltip3:Hide();
            end

            if IsModifiedClick("DRESSUP") then
                ShowInspectCursor();
            else
                ResetCursor();
            end
        end
    end
end)

--快速隐藏显示头盔披风 斬擊分享
local c = {}
local createCheckbox = function(i)
   local cb = CreateFrame("CheckButton", nil, PaperDollFrame)
      cb:SetSize(20, 20)
      cb:SetFrameLevel(10)
      cb:SetNormalTexture([[Interface\Buttons\UI-CheckBox-Up]])
      cb:SetPushedTexture([[Interface\Buttons\UI-CheckBox-Down]])
      cb:SetCheckedTexture([[Interface\Buttons\UI-CheckBox-Check]])
      cb:SetHighlightTexture([[Interface\Buttons\UI-CheckBox-Highlight]])
      cb:SetDisabledCheckedTexture([[Interface\Buttons\UI-CheckBox-Check-Disabled]])
   if i == 1 then
      cb:SetPoint("BOTTOMRIGHT", CharacterHeadSlot, "BOTTOMRIGHT", 5, -5)
      cb:SetScript("OnClick", function() ShowHelm(not ShowingHelm()) end)
      cb:SetChecked(ShowingHelm())
      c[i] = cb
   else
      cb:SetPoint("BOTTOMRIGHT", CharacterBackSlot, "BOTTOMRIGHT", 5, -5)
      cb:SetScript("OnClick", function() ShowCloak(not ShowingCloak()) end)
      cb:SetChecked(ShowingCloak())
      c[i] = cb
   end
end

for i = 1, 2 do
   createCheckbox(i)
end

local F = CreateFrame("Frame")
   F:RegisterEvent("UNIT_MODEL_CHANGED")
   F:SetScript("OnEvent", function()
      c[1]:SetChecked(ShowingHelm())
      c[2]:SetChecked(ShowingCloak())
   end)