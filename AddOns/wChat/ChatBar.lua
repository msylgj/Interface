-- A simple quick chatbar,with low memory cost :)
-- Creat Date : July,20,2011
-- Email : Neavo7@gmail.com
-- Version : 0.1

--need channel colors? create a macro in the game
--/dump ChatTypeInfo['SAY'].r,ChatTypeInfo['SAY'].g,ChatTypeInfo['SAY'].b
--click it
--msylgj0

-- Nevo_Chatbar主框体 --
local chatFrame = SELECTED_DOCK_FRAME
local editBox = chatFrame.editBox
COLORSCHEME_BORDER   = { 0.3,0.3,0.3,1 }

local chatbar = CreateFrame("Frame", "chatbar", UIParent)
chatbar:SetWidth(10) -- 主框体宽度
chatbar:SetHeight(200) -- 主框体高度
chatbar:SetPoint("TOPRIGHT" ,ChatFrame1, "TOPLEFT", 0, 5) -- 锚点,想移动位置的改这里

-- "说(/s)" --
local ChannelSay = CreateFrame("Button", "ChannelSay", UIParent)
ChannelSay:SetWidth(10)  -- 按钮宽度
ChannelSay:SetHeight(20)  -- 按钮高度
ChannelSay:SetPoint("TOP",chatbar,"TOP",0,0)   -- 锚点
ChannelSay:RegisterForClicks("AnyUp")
ChannelSay:SetScript("OnClick", function() ChannelSay_OnClick() end)
ChannelSay:SetScript("OnEnter", function(self) 
	GameTooltip:SetOwner(self, "ANCHOR_TOP", 0, 6)
	GameTooltip:AddLine("说")
	GameTooltip:Show()
end)
ChannelSay:SetScript("OnLeave", function() GameTooltip:Hide() end)
ChannelSayText = ChannelSay:CreateFontString("ChannelSayText", "OVERLAY")
ChannelSayText:SetFont("fonts\\ARKai_T.ttf", 15, "OUTLINE") -- 字体设置
ChannelSayText:SetJustifyH("CENTER")
ChannelSayText:SetWidth(25)
ChannelSayText:SetHeight(25)
ChannelSayText:SetText("▅") -- 显示的文字
ChannelSayText:SetPoint("CENTER", 0, 0)
ChannelSayText:SetTextColor(1,1,1) -- 颜色

function ChannelSay_OnClick()
      ChatFrame_OpenChat("/s ", chatFrame)
end

-- "喊(/y)" --
local ChannelYell = CreateFrame("Button", "ChannelYell", UIParent)
ChannelYell:SetWidth(10) 
ChannelYell:SetHeight(20) 
ChannelYell:SetPoint("TOP",ChannelSay,"BOTTOM",0,0) 
ChannelYell:RegisterForClicks("AnyUp")
ChannelYell:SetScript("OnClick", function() ChannelYell_OnClick() end)
ChannelYell:SetScript("OnEnter", function(self) 
	GameTooltip:SetOwner(self, "ANCHOR_TOP", 0, 6)
	GameTooltip:AddLine("大喊")
	GameTooltip:Show()
end)
ChannelYell:SetScript("OnLeave", function() GameTooltip:Hide() end)
ChannelYellText = ChannelYell:CreateFontString("ChannelYellText", "OVERLAY")
ChannelYellText:SetFont("fonts\\ARKai_T.ttf", 15, "OUTLINE")
ChannelYellText:SetJustifyH("CENTER")
ChannelYellText:SetWidth(25)
ChannelYellText:SetHeight(25)
ChannelYellText:SetText("▅")
ChannelYellText:SetPoint("CENTER", 0, 0)
ChannelYellText:SetTextColor(1,0.25,0.25)

function ChannelYell_OnClick()
      ChatFrame_OpenChat("/y ", chatFrame)
end


-- "队伍(/p)" --
local ChannelParty = CreateFrame("Button", "ChannelParty", UIParent)
ChannelParty:SetWidth(10) 
ChannelParty:SetHeight(20) 
ChannelParty:SetPoint("TOP",ChannelYell,"BOTTOM",0,0) 
ChannelParty:RegisterForClicks("AnyUp")
ChannelParty:SetScript("OnClick", function() ChannelParty_OnClick() end)
ChannelParty:SetScript("OnEnter", function(self) 
	GameTooltip:SetOwner(self, "ANCHOR_TOP", 0, 6)
	GameTooltip:AddLine("队伍")
	GameTooltip:Show()
end)
ChannelParty:SetScript("OnLeave", function() GameTooltip:Hide() end)
ChannelPartyText = ChannelParty:CreateFontString("ChannelPartyText", "OVERLAY")
ChannelPartyText:SetFont("fonts\\ARKai_T.ttf", 15, "OUTLINE")
ChannelPartyText:SetJustifyH("CENTER")
ChannelPartyText:SetWidth(25)
ChannelPartyText:SetHeight(25)
ChannelPartyText:SetText("▅")
ChannelPartyText:SetPoint("CENTER", 0, 0)
ChannelPartyText:SetTextColor(0.67,0.67,1)

function ChannelParty_OnClick()
      ChatFrame_OpenChat("/p ", chatFrame)
end

-- "公会(/g)" --
local ChannelGuild = CreateFrame("Button", "ChannelGuild", UIParent)
ChannelGuild:SetWidth(10) 
ChannelGuild:SetHeight(20) 
ChannelGuild:SetPoint("TOP",ChannelParty,"BOTTOM",0,0) 
ChannelGuild:RegisterForClicks("AnyUp")
ChannelGuild:SetScript("OnClick", function() ChannelGuild_OnClick() end)
ChannelGuild:SetScript("OnEnter", function(self) 
	GameTooltip:SetOwner(self, "ANCHOR_TOP", 0, 6)
	GameTooltip:AddLine("公会")
	GameTooltip:Show()
end)
ChannelGuild:SetScript("OnLeave", function() GameTooltip:Hide() end)
ChannelGuildText = ChannelGuild:CreateFontString("ChannelGuildText", "OVERLAY")
ChannelGuildText:SetFont("fonts\\ARKai_T.ttf", 15, "OUTLINE")
ChannelGuildText:SetJustifyH("CENTER")
ChannelGuildText:SetWidth(25)
ChannelGuildText:SetHeight(25)
ChannelGuildText:SetText("▅")
ChannelGuildText:SetPoint("CENTER", 0, 0)
ChannelGuildText:SetTextColor(0.25,1,0.25)

function ChannelGuild_OnClick()
      ChatFrame_OpenChat("/g ", chatFrame)
end

-- "团队(/raid)" --
local ChannelRaid = CreateFrame("Button", "ChannelRaid", UIParent)
ChannelRaid:SetWidth(10) 
ChannelRaid:SetHeight(20) 
ChannelRaid:SetPoint("TOP",ChannelGuild,"BOTTOM",0,0) 
ChannelRaid:RegisterForClicks("AnyUp")
ChannelRaid:SetScript("OnClick", function() ChannelRaid_OnClick() end)
ChannelRaid:SetScript("OnEnter", function(self) 
	GameTooltip:SetOwner(self, "ANCHOR_TOP", 0, 6)
	GameTooltip:AddLine("团队")
	GameTooltip:Show()
end)
ChannelRaid:SetScript("OnLeave", function() GameTooltip:Hide() end)
ChannelRaidText = ChannelRaid:CreateFontString("ChannelRaidText", "OVERLAY")
ChannelRaidText:SetFont("fonts\\ARKai_T.ttf", 15, "OUTLINE")
ChannelRaidText:SetJustifyH("CENTER")
ChannelRaidText:SetWidth(25)
ChannelRaidText:SetHeight(25)
ChannelRaidText:SetText("▅")
ChannelRaidText:SetPoint("CENTER", 0, 0)
ChannelRaidText:SetTextColor(1,0.5,0)

function ChannelRaid_OnClick()
      ChatFrame_OpenChat("/raid ", chatFrame)
end

-- "团队通告(/rw)" --
local Channel_01 = CreateFrame("Button", "Channel_rw", UIParent)
Channel_rw:SetWidth(10) 
Channel_rw:SetHeight(20) 
Channel_rw:SetPoint("TOP",ChannelRaid,"BOTTOM",0,0) 
Channel_rw:RegisterForClicks("AnyUp")
Channel_rw:SetScript("OnClick", function() Channel_rw_OnClick() end)
Channel_rw:SetScript("OnEnter", function(self) 
	GameTooltip:SetOwner(self, "ANCHOR_TOP", 0, 6)
	GameTooltip:AddLine("团队通告")
	GameTooltip:Show()
end)
Channel_rw:SetScript("OnLeave", function() GameTooltip:Hide() end)
Channel_rwText = Channel_01:CreateFontString("Channel_rwText", "OVERLAY")
Channel_rwText:SetFont("fonts\\ARKai_T.ttf", 15, "OUTLINE")
Channel_rwText:SetJustifyH("CENTER")
Channel_rwText:SetWidth(25)
Channel_rwText:SetHeight(25)
Channel_rwText:SetText("▅")
Channel_rwText:SetPoint("CENTER", 0, 0)
Channel_rwText:SetTextColor(1,0.28,0) 

function Channel_rw_OnClick()
      ChatFrame_OpenChat("/rw ", chatFrame)
end

-- "副本(/i)" --
local Channel_02 = CreateFrame("Button", "Channel_02", UIParent)
Channel_02:SetWidth(10) 
Channel_02:SetHeight(20) 
Channel_02:SetPoint("TOP",Channel_rw,"BOTTOM",0,0) 
Channel_02:RegisterForClicks("AnyUp")
Channel_02:SetScript("OnClick", function() Channel_02_OnClick() end)
Channel_02:SetScript("OnEnter", function(self) 
	GameTooltip:SetOwner(self, "ANCHOR_TOP", 0, 6)
	GameTooltip:AddLine("副本")
	GameTooltip:Show()
end)
Channel_02:SetScript("OnLeave", function() GameTooltip:Hide() end)
Channel_02Text = Channel_02:CreateFontString("Channel_02Text", "OVERLAY")
Channel_02Text:SetFont("fonts\\ARKai_T.ttf", 15, "OUTLINE")
Channel_02Text:SetJustifyH("CENTER")
Channel_02Text:SetWidth(25)
Channel_02Text:SetHeight(25)
Channel_02Text:SetText("▅")
Channel_02Text:SetPoint("CENTER", 0, 0)
Channel_02Text:SetTextColor(1,0.5,0)

function Channel_02_OnClick()
      ChatFrame_OpenChat("/i ", chatFrame)
end

-- "密语(/w)" --
local Channel_04 = CreateFrame("Button", "Channel_04", UIParent)
Channel_04:SetWidth(10) 
Channel_04:SetHeight(20) 
Channel_04:SetPoint("TOP",Channel_02,"BOTTOM",0,0) 
Channel_04:RegisterForClicks("AnyUp")
Channel_04:SetScript("OnClick", function() Channel_04_OnClick() end)
Channel_04:SetScript("OnEnter", function(self) 
	GameTooltip:SetOwner(self, "ANCHOR_TOP", 0, 6)
	GameTooltip:AddLine("密语")
	GameTooltip:Show()
end)
Channel_04:SetScript("OnLeave", function() GameTooltip:Hide() end)
Channel_04Text = Channel_04:CreateFontString("Channel_04Text", "OVERLAY")
Channel_04Text:SetFont("fonts\\ARKai_T.ttf", 15, "OUTLINE")
Channel_04Text:SetJustifyH("CENTER")
Channel_04Text:SetWidth(25)
Channel_04Text:SetHeight(25)
Channel_04Text:SetText("▅")
Channel_04Text:SetPoint("CENTER", 0, 0)
Channel_04Text:SetTextColor(1,0.5,1)

function Channel_04_OnClick()
      ChatFrame_OpenChat("/w ", chatFrame)
end

-- "大脚世界频道(/0)" --
local Channel_05 = CreateFrame("Button", "Channel_05", UIParent)
Channel_05:SetWidth(10) 
Channel_05:SetHeight(20) 
Channel_05:SetPoint("TOP",Channel_04,"BOTTOM",0,0) 
Channel_05:RegisterForClicks("AnyUp")
Channel_05:SetScript("OnClick", function(self,button) Channel_05_OnClick(self,button) end)
Channel_05:SetScript("OnEnter", function(self) 
	GameTooltip:SetOwner(self, "ANCHOR_TOP", 0, 6)
	GameTooltip:AddLine("大脚世界频道")
	GameTooltip:Show()
end)
Channel_05:SetScript("OnLeave", function() GameTooltip:Hide() end)
Channel_05Text = Channel_05:CreateFontString("Channel_05Text", "OVERLAY")
Channel_05Text:SetFont("fonts\\ARKai_T.ttf", 15, "OUTLINE")
Channel_05Text:SetJustifyH("CENTER")
Channel_05Text:SetWidth(25)
Channel_05Text:SetHeight(25)
Channel_05Text:SetText("▅")
Channel_05Text:SetPoint("CENTER", 0, 0)
Channel_05Text:SetTextColor(1,0.75,0.75) 

-- Roll --
local roll = CreateFrame("Button", "rollMacro", UIParent, "SecureActionButtonTemplate")
roll:SetAttribute("*type*", "macro")
roll:SetAttribute("macrotext", "/roll")
roll:SetWidth(20)
roll:SetHeight(20)
roll:SetPoint("TOP",Channel_05,"BOTTOM",5,-2)
roll:SetScript("OnEnter", function(self) 
	GameTooltip:SetOwner(self, "ANCHOR_TOP", 0, 6)
	GameTooltip:AddLine("觉悟吧!你可笑的骰子背叛了你!")
	GameTooltip:Show()
end)
roll:SetScript("OnLeave", function() GameTooltip:Hide() end)
roll.t = roll:CreateTexture()
roll.t:SetAllPoints()
roll.t:SetWidth(25)
roll.t:SetHeight(25)
roll.t:SetTexture("Interface\\Buttons\\UI-GroupLoot-Dice-Up")

function Channel_05_OnClick(self,button)
	if button == "RightButton" then   
		local _, channelName, _  =  GetChannelName("大脚世界频道")
		if channelName == nil then
			JoinPermanentChannel("大脚世界频道", nil, 1, 1) 
			ChatFrame_RemoveMessageGroup(ChatFrame1, "CHANNEL")
			ChatFrame_AddChannel(ChatFrame1,"大脚世界频道")
		else
			LeaveChannelByName("大脚世界频道") 
		end
    else   
		local channel,_,_  = GetChannelName("大脚世界频道")
		ChatFrame_OpenChat("/"..channel.." ", chatFrame)
	end         
end