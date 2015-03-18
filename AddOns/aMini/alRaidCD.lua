﻿-- Config start
local anchor = "TOPLEFT"
local x, y = 12, -200
local width, height = 130, 14
local spacing = 5
local icon_size = 14
local font = GameFontHighlight:GetFont()
local font_size = 11
local font_style = nil
local backdrop_color = {0, 0, 0, 0.4}
local border_color = {0, 0, 0, 1}
local show_icon = true
local texture = "Interface\\TargetingFrame\\UI-StatusBar"
local show = {
	raid = true,
	party = true,
	arena = true,
	--none = true,
}
-- Config end

local spells = {
	--群疗
	[740]    = 180,  -- 宁静
	[115310] = 180,  -- 还魂
	[64843]  = 180,  -- 神圣赞美诗
	[108280] = 180,  -- 奶潮
	[15286]  = 180,  -- 吸血鬼拥抱
	
	-- 群体减伤
	[51052] = 120,  -- 反魔法领域
	[31821] = 180,  -- 光环掌握
	[62618] = 180,  -- 真言术: 障
	[88611] = 180,  --烟雾弹
	[98008] = 180,  -- 灵魂链接图腾
	[97462] = 180,  -- 集结呐喊
	[159916] = 120, -- 魔法增效
	
	-- 单体减伤
	[116849] = 120, -- 泡泡(奶僧100)
	[633] = 600, -- 圣疗
	[6940] = 120, -- 牺牲(惩戒90)
	[33206] = 180, -- 痛苦压制
	[47788] = 180, -- 守护
	[114030] = 120, -- 戒备守护
	-- 战术技能
	[172106] = 180,  --灵狐守护
	[106898] = 120,  --豹奔
	
	-- 战复(特殊处理充能)
	[20484] = true,	-- 复生
	[61999] = true,	-- 复活盟友
	[20707] = true,	-- 灵魂石复活
	[126393] = true, -- 永恒守护者
	
	-- 其他
	[32182] = 300,	-- 英勇
	[2825] = 300,	-- 嗜血
	[80353] = 300,	-- 时间扭曲
	[90355] = 300,	-- 远古狂乱
	[29166] = 180,	-- 激活
	[16190] = 180,  --潮汐
	[115213] = 180,	-- 慈悲庇护
	--[133] = 180, --测试
	
}

local cfg = {}

local filter = COMBATLOG_OBJECT_AFFILIATION_RAID + COMBATLOG_OBJECT_AFFILIATION_PARTY + COMBATLOG_OBJECT_AFFILIATION_MINE
local band = bit.band
local sformat = string.format
local floor = math.floor
local timer = 0

local backdrop = {
	bgFile = [=[Interface\ChatFrame\ChatFrameBackground]=],
	edgeFile = [=[Interface\ChatFrame\ChatFrameBackground]=], edgeSize = 1,
	insets = {top = 0, left = 0, bottom = 0, right = 0},
}

local bars = {}

local anchorframe = CreateFrame("Frame", "RaidCD", UIParent)
anchorframe:SetSize(width, height)
anchorframe:SetPoint(anchor, x, y)
if UIMovableFrames then tinsert(UIMovableFrames, anchorframe) end

local function bossexists()
	for i = 1, MAX_BOSS_FRAMES do
		if UnitExists("boss"..i) then
			return true
		end
	end
end

local FormatTime = function(time)
	if time >= 60 then
		return sformat('%.2d:%.2d', floor(time / 60), time % 60)
	else
		return sformat('%.2d', time)
	end
end

local CreateFS = CreateFS or function(frame)
	local fstring = frame:CreateFontString(nil, 'OVERLAY', 'GameFontHighlight')
	fstring:SetFont(font, font_size, font_style)
	fstring:SetShadowColor(0, 0, 0, 1)
	fstring:SetShadowOffset(0.5, -0.5)
	return fstring
end

local CreateBG = CreateBG or function(parent)
	local bg = CreateFrame("Frame", nil, parent)
	bg:SetPoint("TOPLEFT", parent, "TOPLEFT", -1, 1)
	bg:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT", 1, -1)
	bg:SetFrameStrata("LOW")
	bg:SetBackdrop(backdrop)
	bg:SetBackdropColor(unpack(backdrop_color))
	bg:SetBackdropBorderColor(unpack(border_color))
	return bg
end

local UpdatePositions = function()
	for i = 1, #bars do
		bars[i]:ClearAllPoints()
		if i == 1 then
			bars[i]:SetPoint("TOPLEFT", anchorframe, 0, 0)
		else
			bars[i]:SetPoint("TOPLEFT", bars[i-1], "BOTTOMLEFT", 0, -spacing)
		end
		bars[i].id = i
	end
end

local StopTimer = function(bar)
	bar:SetScript("OnUpdate", nil)
	bar:Hide()
	tremove(bars, bar.id)
	UpdatePositions()
end

local BarUpdate = function(self, elapsed)
	local curTime = GetTime()
	if self.endTime < curTime then
		StopTimer(self)
		return
	end
	self.status:SetValue(100 - (curTime - self.startTime) / (self.endTime - self.startTime) * 100)
	self.right:SetText(FormatTime(self.endTime - curTime))
end

local OnEnter = function(self)
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
	GameTooltip:AddLine(self.spell)
	GameTooltip:SetClampedToScreen(true)
	GameTooltip:Show()
end

local OnLeave = function(self)
	GameTooltip:Hide()
end

local OnMouseDown = function(self, button)
	if button == "LeftButton" then
		SendChatMessage(sformat("团队技能冷却时间 %s %s: %s", self.left:GetText(), self.spell, self.right:GetText()), "RAID")
	elseif button == "RightButton" then
		StopTimer(self)
	end
end

local CreateBar = function()
	local bar = CreateFrame("Frame", nil, UIParent)
	bar:SetSize(width, height)
	bar.status = CreateFrame("Statusbar", nil, bar)
	if show_icon then
		bar.icon = CreateFrame("button", nil, bar)
		bar.icon:SetSize(icon_size, icon_size)
		bar.icon:SetPoint("BOTTOMLEFT", 0, 0)
		bar.status:SetPoint("BOTTOMLEFT", bar.icon, "BOTTOMRIGHT", 5, 0)
	else
		bar.status:SetPoint("BOTTOMLEFT", 0, 0)
	end
	bar.status:SetPoint("BOTTOMRIGHT", 0, 0)
	bar.status:SetHeight(height)
	bar.status:SetStatusBarTexture(texture)
	bar.status:SetMinMaxValues(0, 100)
	bar.status:SetFrameLevel(bar:GetFrameLevel()-1)
	bar.left = CreateFS(bar)
	bar.left:SetPoint('LEFT', bar.status, 2, 1)
	bar.left:SetJustifyH('LEFT')
	bar.right = CreateFS(bar)
	bar.right:SetPoint('RIGHT', bar.status, -2, 1)
	bar.right:SetJustifyH('RIGHT')
	CreateBG(bar.icon)
	CreateBG(bar.status)
	return bar
end

local StartTimer = function(name, spellId)
	local spell, rank, icon = GetSpellInfo(spellId)
	for _, v in pairs(bars) do
		if v.name == name and v.spell == spell then
			--发现重复计时事件时重置计时条,适应充能
			StopTimer(v)
		end
	end
	local bar = CreateBar()
	--判断战复充能冷却时间
	local cooldown = spells[spellId]
	local _, _, difficulty, _, maxPlayers, _, _, _, instanceGroupSize = GetInstanceInfo()
	if cooldown == true then
	   if bossexists() then
		  if difficulty == 14 or difficulty == 15 or difficulty == 17 then  --彈性模式
			 cooldown = (90/instanceGroupSize)*60
		  elseif difficulty == 3 or difficulty == 5 then
			 cooldown = 540
		  elseif difficulty == 16 then
			 cooldown = 270
		  elseif difficulty == 4 or difficulty == 6 then
			 cooldown = 216
		  else
			 cooldown = 180
		  end
	   else
		  cooldown = 600
	   end
	end
	bar.endTime = GetTime() + cooldown
	bar.startTime = GetTime()
	bar.left:SetText(name)
	bar.name = name
	bar.right:SetText(FormatTime(cooldown))
	if icon and bar.icon then
		bar.icon:SetNormalTexture(icon)
		bar.icon:GetNormalTexture():SetTexCoord(0.07, 0.93, 0.07, 0.93)
	end
	bar.spell = spell
	bar:Show()
	local color = RAID_CLASS_COLORS[select(2, UnitClass(name))]
	bar.status:SetStatusBarColor(color.r, color.g, color.b)
	bar:SetScript("OnUpdate", BarUpdate)
	bar:EnableMouse(true)
	bar:SetScript("OnEnter", OnEnter)
	bar:SetScript("OnLeave", OnLeave)
	bar:SetScript("OnMouseDown", OnMouseDown)
	tinsert(bars, bar)
	UpdatePositions()
end

local OnEvent = function(self, event, ...)
	if event == "COMBAT_LOG_EVENT_UNFILTERED" then
		local timestamp, eventType, _, sourceGUID, sourceName, sourceFlags = ...
		if band(sourceFlags, filter) == 0 then return end
		if eventType == "SPELL_RESURRECT" or eventType == "SPELL_CAST_SUCCESS" or eventType == "SPELL_AURA_APPLIED" then
			local spellId = select(12, ...)
			if sourceName then
				sourceName = sourceName:gsub("-%w+", "")
			else
				return
			end
			if spells[spellId] and show[select(2, IsInInstance())] then
				StartTimer(sourceName, spellId)
			end
		end
	--增加首领战时清空计时条,适应现在boss战重置CD机制
	elseif (event == "ZONE_CHANGED_NEW_AREA" and select(2, IsInInstance()) == "arena") or (event == "PLAYER_REGEN_DISABLED" and bossexists()) then
		for k, v in pairs(bars) do
			StopTimer(v)
		end
	end
end

local addon = CreateFrame("frame")
addon:SetScript('OnEvent', OnEvent)
addon:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
addon:RegisterEvent("ZONE_CHANGED_NEW_AREA")
addon:RegisterEvent("PLAYER_REGEN_DISABLED")

SlashCmdList["RaidCD"] = function(msg) 
	StartTimer(UnitName('player'), 20484)
	StartTimer(UnitName('player'), 61999)
	StartTimer(UnitName('player'), 20707)
end
SLASH_RaidCD1 = "/raidcd"