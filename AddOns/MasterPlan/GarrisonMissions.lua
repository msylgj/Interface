local _, T = ...
if T.Mark ~= 50 then return end
local EV, G, L = T.Evie, T.Garrison, T.L

local roamingParty, easyDrop = T.MissionsUI.roamingParty, T.MissionsUI.easyDrop
local MISSION_PAGE_FRAME = GarrisonMissionFrame.MissionTab.MissionPage
local SHIP_MISSION_PAGE = GarrisonShipyardFrame.MissionTab.MissionPage

do -- GarrisonFollowerList_SortFollowers
	local toggle = CreateFrame("CheckButton", nil, GarrisonMissionFrameFollowers, "InterfaceOptionsCheckButtonTemplate")
	toggle:SetSize(24, 24) toggle:SetHitRectInsets(0,0,0,0)
	toggle:SetPoint("LEFT", GarrisonMissionFrameFollowers.SearchBox, "RIGHT", 12, 0)
	toggle:SetScript("OnClick", function(self)
		MasterPlan:SetSortFollowers(self:GetChecked())
	end)
	
	local missionFollowerSort do
		local finfo, cinfo, tinfo, mlvl
		local statusPriority = {
		  [GARRISON_FOLLOWER_WORKING] = 5,
		  [GARRISON_FOLLOWER_ON_MISSION] = 4,
		  [GARRISON_FOLLOWER_EXHAUSTED] = 3,
		  [GARRISON_FOLLOWER_INACTIVE] = 2,
		  [""]=1,
		}
		local function cmp(a, b)
			local af, bf = finfo[a], finfo[b]
			local ac, bc = af.isCollected and 1 or 0, bf.isCollected and 1 or 0
			if ac == bc then
				ac, bc = statusPriority[af.status] or 6, statusPriority[bf.status] or 6
			end
			if ac == bc then
				ac, bc = cinfo[af.followerID] and (#cinfo[af.followerID])*100 or 0, cinfo[bf.followerID] and (#cinfo[bf.followerID])*100 or 0
				ac, bc = ac + (tinfo[af.followerID] and #tinfo[af.followerID] or 0), bc + (tinfo[bf.followerID] and #tinfo[bf.followerID] or 0)
				if (ac > 0) ~= (bc > 0) then
					return ac > 0
				elseif ac > 0 and ((af.level >= mlvl) ~= (bf.level >= mlvl)) then
					return af.level >= mlvl
				end
			end
			if ac == bc then
				ac, bc = af.level, bf.level
			end
			if ac == bc then
				ac, bc = af.iLevel, bf.iLevel
			end
			if ac == bc then
				ac, bc = af.quality, bf.quality
			end
			if ac == bc then
				ac, bc = 0, strcmputf8i(af.name, bf.name)
			end
			return ac > bc
		end
		function missionFollowerSort(t, followers, counters, traits, level)
			finfo, cinfo, tinfo, mlvl = followers, counters, traits, level
			table.sort(t, cmp)
			finfo, cinfo, tinfo, mlvl = nil
		end
	end
	local oldSortFollowers = GarrisonFollowerList_SortFollowers
	function GarrisonFollowerList_SortFollowers(self)
	   local followerCounters = GarrisonMissionFrame.followerCounters
	   local followerTraits = GarrisonMissionFrame.followerTraits
		for k,v in pairs(self.followers) do
			local tmid = G.GetFollowerTentativeMission(v.followerID)
			if tmid and (v.status or "") == "" then
				v.status = GARRISON_FOLLOWER_IN_PARTY
			elseif (v.status or "") == "" and T.config.ignore[v.followerID] then
				v.status = GARRISON_FOLLOWER_WORKING
			end
		end
		toggle:SetShown(GarrisonMissionFrame.MissionTab:IsShown())
		local mi = MISSION_PAGE_FRAME.missionInfo
	   if followerCounters and followerTraits and GarrisonMissionFrame.MissionTab:IsVisible() and mi and MasterPlan:GetSortFollowers() then
			return missionFollowerSort(self.followersList, self.followers, followerCounters, followerTraits, mi.level)
		end
		return oldSortFollowers(self)
	end
	function EV:MP_SETTINGS_CHANGED(s)
		if (s == nil or s == "sortFollowers") then
			if GarrisonMissionFrame:IsVisible() then
				GarrisonFollowerList_UpdateFollowers(GarrisonMissionFrame.FollowerList)
			end
			toggle:SetChecked(MasterPlan:GetSortFollowers())
		end
	end
end

local GarrisonFollower_OnDoubleClick do
	local old = GarrisonFollowerListButton_OnClick
	local function resetAndReturn(followerFrame, ...)
		followerFrame.FollowerList.canExpand = true
		GarrisonFollowerList_Update(followerFrame)
		return ...
	end
	function GarrisonFollowerListButton_OnClick(self, ...)
		local followerFrame = self:GetParent():GetParent().followerFrame
		if self.PortraitFrame and self.PortraitFrame:IsMouseOver() and MISSION_PAGE_FRAME.missionInfo and MISSION_PAGE_FRAME:IsShown() then
			followerFrame.FollowerList.canExpand = false
			return resetAndReturn(followerFrame, old(self, ...))
		end
		return old(self, ...)
	end
	function GarrisonFollower_OnDoubleClick(self)
		if self.PortraitFrame and self.PortraitFrame:IsMouseOver() then
			local mi = MISSION_PAGE_FRAME.missionInfo
			local fi = self.info
			if fi and fi.followerID and mi and mi.missionID and fi.status == nil then
				local f = MISSION_PAGE_FRAME.Followers
				for i=1, mi.numFollowers do
					if not f[i].info then
						GarrisonMissionFrame:AssignFollowerToMission(f[i], fi)
						GarrisonMissionFrame.FollowerList:CollapseButton(self)
						return
					end
				end
				if mi.numFollowers == 1 then
					GarrisonMissionFrame:AssignFollowerToMission(f[1], fi)
				else
					local f1, f2, f3 = f[1].info, f[2].info, f[3].info
					f1, f2, f3 = f1 and f1.followerID, f2 and f2.followerID, f3 and f3.followerID
					local g = G.GetBackfillMissionGroups(mi, G.GroupFilter.IDLE, G.GetMissionDefaultGroupRank(mi), 1, f1, f2, f3, fi.followerID)
					if g and g[1] then
						local p1, p2, p3 = g[1][5], g[1][6], g[1][7]
						for i=1,mi.numFollowers do
							if p1 ~= f1 and p2 ~= f1 and p3 ~= f1 then
								GarrisonMissionFrame:AssignFollowerToMission(f[i], fi)
								break
							end
							f1, f2 = f2, f3
						end
					end
				end
			elseif fi and fi.status == GARRISON_FOLLOWER_IN_PARTY then
				local f = MISSION_PAGE_FRAME.Followers
				for i=1, #f do
					if f[i].info and f[i].info.followerID == fi.followerID then
						GarrisonMissionFrame:RemoveFollowerFromMission(f[i], true)
						break
					end
				end
			end
		end
	end
end
hooksecurefunc("GarrisonFollowerList_Update", function(self)
	local buttons = self.FollowerList.listScroll.buttons
	local mi = MISSION_PAGE_FRAME:IsShown() and MISSION_PAGE_FRAME.missionInfo
	local mlvl = mi and G.GetFMLevel(mi)
	for i=1, #buttons do
		local btn = buttons[i]
		if btn:IsShown() then
			local follower, st = btn.info, btn.XPBar.statusText
			if not st then
				st = btn:CreateFontString(nil, "ARTWORK", "TextStatusBarText")
				st:SetTextColor(0.7, 0.6, 0.85)
				st:SetPoint("TOPRIGHT", -4, -44)
				btn.UpArrow:ClearAllPoints() btn.UpArrow:SetPoint("TOP", 16, -38)
				btn.DownArrow:ClearAllPoints() btn.DownArrow:SetPoint("TOP", 16, -38)
				btn.XPBar.statusText = st
				btn:SetScript("OnDoubleClick", GarrisonFollower_OnDoubleClick)
			end
			if mi then
				local ef = G.GetLevelEfficiency(G.GetFMLevel(follower), mlvl)
				if ef < 0.5 then
					btn.PortraitFrame.Level:SetTextColor(1, 0.1, 0.1)
				elseif ef < 1 then
					btn.PortraitFrame.Level:SetTextColor(1, 0.5, 0.25)
				else
					btn.PortraitFrame.Level:SetTextColor(1, 1, 1)
				end
			else
				btn.PortraitFrame.Level:SetTextColor(1, 1, 1)
			end
			if not follower.isCollected or follower.status == GARRISON_FOLLOWER_INACTIVE or follower.levelXP == 0 then
				st:SetText("")
			else
				st:SetFormattedText(L"%s XP", BreakUpLargeNumbers(follower.levelXP - follower.xp))
			end
		end
	end
end)
local function FollowerList_UpdateShip(self)
	local buttons = self.listScroll.buttons
	for i=1, #buttons do
		local btn = buttons[i]
		if btn:IsShown() then
			local follower, st = btn.info, btn.XPBar.statusText
			if not st then
				st = btn:CreateFontString(nil, "ARTWORK", "TextStatusBarText")
				st:SetTextColor(0.7, 0.6, 0.85)
				st:SetPoint("BOTTOMLEFT", 25, 5)
				btn.XPBar.statusText = st
			end
			if not follower.isCollected or follower.status == GARRISON_FOLLOWER_INACTIVE or follower.levelXP == 0 then
				st:SetText("")
			else
				st:SetFormattedText(L"%s XP", BreakUpLargeNumbers(follower.levelXP - follower.xp))
			end
			if follower.status == GARRISON_FOLLOWER_ON_MISSION then
				btn.Status:SetText(C_Garrison.GetFollowerMissionTimeLeft(follower.followerID))
			end
		end
	end
end
hooksecurefunc(GarrisonShipyardFrame.FollowerList, "UpdateData", FollowerList_UpdateShip)
hooksecurefunc(GarrisonLandingPage.ShipFollowerList, "UpdateData", FollowerList_UpdateShip)
do -- Follower counter button tooltips
	local fake, old = {}
	local function OnEnter(self, ...)
		old, fake.info = self, self.info
		return GarrisonMissionMechanicFollowerCounter_OnEnter(self, ...)
	end
	hooksecurefunc("GarrisonFollowerButton_UpdateCounters", function(self)
		if old and (fake.info ~= old.info or not (old:IsShown() and old:IsMouseOver())) then
			GarrisonMissionMechanicFollowerCounter_OnLeave(fake)
			old, fake.info = nil
		end
		for i=1,self.Counters and #self.Counters or 0 do -- TODO: does this ever exist?
			local self = self.Counters[i]
			self:SetScript("OnEnter", OnEnter)
			if self:IsShown() and self:IsMouseOver() then
				OnEnter(self)
			end
		end
	end)
end

local function GetRewardsDesc(mid)
	local r, mi = "", C_Garrison.GetBasicMissionInfo(mid)
	if mi and mi.rewards then
		for k,v in pairs(mi.rewards) do
			if v.currencyID == 0 then
				r = r .. " |TInterface\\MoneyFrame\\UI-GoldIcon:0|t"
			elseif v.icon then
				r = r .. " |T" .. v.icon .. ":0|t"
			elseif v.currencyID then
				local c = select(3, GetCurrencyInfo(v.currencyID))
				r = r .. " |T" .. (c or "Interface/Icons/Temp") .. ":0|t"
			elseif v.itemID then
				r = r .. " |T" .. GetItemIcon(v.itemID) .. ":0|t"
			end
		end
	end
	return r
end
local function FollowerButton_OnEnter(self)
	if (not MISSION_PAGE_FRAME:IsVisible() and IsAddOnLoaded("SmartFollowerManager")) then
		local info, id = self.info
		local GetAbility = C_Garrison[info.garrFollowerID and "GetFollowerAbilityAtIndex" or "GetFollowerAbilityAtIndexByID"]
		local GetTrait = C_Garrison[info.garrFollowerID and "GetFollowerTraitAtIndex" or "GetFollowerTraitAtIndexByID"]

		GarrisonFollowerTooltip_Owner, id = self, info.followerID
		GarrisonFollowerTooltip:ClearAllPoints()
		GarrisonFollowerTooltip:SetPoint("TOPLEFT", self, "TOPRIGHT", 0, 4)
		GarrisonFollowerTooltip_Show(info.garrFollowerID or info.followerID,
			not not info.isCollected, info.quality, info.level,
			info.xp, info.levelXP, info.iLevel,
			GetAbility(id, 1), GetAbility(id, 2), GetAbility(id, 3), GetAbility(id, 4),
			GetTrait(id, 1), GetTrait(id, 2), GetTrait(id, 3), GetTrait(id, 4),
			false
		)
		
		return
	end
	
	local tmid = self and self.id and G.GetFollowerTentativeMission(self.id)
	if tmid then
		GameTooltip:SetOwner(self, "ANCHOR_NONE")
		GameTooltip:SetPoint("TOPLEFT", self, "TOPRIGHT", 4, 4)
		GameTooltip:SetText(L"In Tentative Party")
		GameTooltip:AddDoubleLine(C_Garrison.GetMissionName(tmid), GetRewardsDesc(tmid), 1,1,1)
		if MISSION_PAGE_FRAME:IsVisible() then
			GameTooltip:AddLine("|n|TInterface\\TUTORIALFRAME\\UI-TUTORIAL-FRAME:14:12:0:-1:512:512:10:70:330:410|t " .. GARRISON_MISSION_ADD_FOLLOWER, 0.5, 0.8, 1)
		end
		GameTooltip:Show()
	elseif GameTooltip:IsOwned(self) then
		GameTooltip:Hide()
	end
end
local function FollowerButton_OnLeave(self)
	if GarrisonFollowerTooltip_Owner == self then
		GarrisonFollowerTooltip:Hide()
		GarrisonFollowerTooltip_Owner = nil
	end
	if GameTooltip:IsOwned(self) then
		GameTooltip:Hide()
	end
end
hooksecurefunc("GarrisonFollowerList_Update", function(self)
	local buttons, fl = self.FollowerList.listScroll.buttons, G.GetFollowerInfo()
	local mi = MISSION_PAGE_FRAME.missionInfo
	local mid = mi and mi.missionID
	for i=1, #buttons do
		local fi = fl[buttons[i].id]
		if fi then
			local tmid = G.GetFollowerTentativeMission(fi.followerID)
			local status, ns = buttons[i].info.status or ""
			if tmid then
				ns = tmid == mid and GARRISON_FOLLOWER_IN_PARTY or L"In Tentative Party"
			elseif T.config.ignore[fi.followerID] then
				if fi.status == nil and status == GARRISON_FOLLOWER_WORKING then
					ns = L"Ignored"
				elseif fi.status == GARRISON_FOLLOWER_INACTIVE or fi.status == GARRISON_FOLLOWER_WORKING then
					ns = fi.status .. " " .. L"Ignored"
				end
			end
			if ns then
				buttons[i].Status:SetText(ns)
			end
			if (ns or status) == "" and fi.level == 100 then
				local _weaponItemID, weaponItemLevel, _armorItemID, armorItemLevel = C_Garrison.GetFollowerItems(fi.followerID)
				if weaponItemLevel ~= armorItemLevel then
					buttons[i].ILevel:SetText(ITEM_LEVEL_ABBR .. " " .. fi.iLevel .. " (" .. weaponItemLevel .. "/" .. armorItemLevel .. ")")
				end
			end
			if self == GarrisonMissionFrame then
				buttons[i]:SetScript("OnEnter", FollowerButton_OnEnter)
				buttons[i]:SetScript("OnLeave", FollowerButton_OnLeave)
			end
		end
	end
end)
local function mousewheelListUpdate(self, ...)
	HybridScrollFrame_OnMouseWheel(self, ...)
	local buttons = self.buttons
	for i = 1, #buttons do
		if buttons[i]:IsMouseOver() then
			local oe = buttons[i]:GetScript("OnEnter")
			if oe then
				oe(buttons[i])
				return
			end
		end
	end
end
GarrisonMissionFrame.FollowerList.listScroll:SetScript("OnMouseWheel", mousewheelListUpdate)
GarrisonLandingPage.FollowerList.listScroll:SetScript("OnMouseWheel", mousewheelListUpdate)
GarrisonRecruitSelectFrame.FollowerList.listScroll:SetScript("OnMouseWheel", mousewheelListUpdate)

local function Mechanic_OnClick(self)
	T.Mechanic_OnClick(self)
end
local function Mechanic_OnEnter(self)
	local mi = MISSION_PAGE_FRAME.missionInfo
	GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT")
	G.SetThreatTooltip(GameTooltip, self.info.icon:lower(), nil, G.GetFMLevel(mi))
	GameTooltip:Show()
end
local function Mechanic_OnLeave(self)
	if GameTooltip:IsOwned(self) then
		GameTooltip:Hide()
	end
end
hooksecurefunc(GarrisonMissionFrame, "SetEnemies", function(_, f, enemies)
	for i=1, #enemies do
		local m = f.Enemies[i] and f.Enemies[i].Mechanics
		for i=1,m and #m or 0 do
			if not m[i].highlight then
				m[i].highlight = m[i]:CreateTexture(nil, "HIGHLIGHT")
				m[i].highlight:SetAllPoints()
				m[i].highlight:SetTexture("Interface\\Buttons\\ButtonHilight-Square")
				m[i].highlight:SetBlendMode("ADD")
				m[i]:SetScript("OnClick", Mechanic_OnClick)
				m[i]:SetScript("OnEnter", Mechanic_OnEnter)
				m[i]:SetScript("OnLeave", Mechanic_OnLeave)
			end
			m[i].hasCounter = nil
			m[i].Check:Hide()
			m[i].Anim:Stop()
		end
	end
end)
local function UpdateHover(_, frame)
	if frame:IsMouseOver() and frame:IsShown() then
		local	ol, oe = frame:GetScript("OnLeave"), frame:GetScript("OnEnter")
		if ol then
			securecall(ol, frame)
		end
		if oe then
			oe(frame)
		end
	end
end
hooksecurefunc(GarrisonMissionFrame, "AssignFollowerToMission", UpdateHover)
hooksecurefunc(GarrisonMissionFrame, "RemoveFollowerFromMission", UpdateHover)
hooksecurefunc(GarrisonShipyardFrame, "AssignFollowerToMission", UpdateHover)
hooksecurefunc(GarrisonShipyardFrame, "RemoveFollowerFromMission", UpdateHover)

local lfgButton do
	local seen = MISSION_PAGE_FRAME.Stage:CreateFontString(nil, "OVERLAY", "GameFontNormalMed2")
	seen:SetPoint("TOPLEFT", MISSION_PAGE_FRAME.Stage.MissionEnv, "BOTTOMLEFT", 0, -3)
	seen:SetJustifyH("LEFT")
	MISSION_PAGE_FRAME.Stage.MissionSeen = seen
	
	lfgButton = CreateFrame("Button", nil, MISSION_PAGE_FRAME.Stage)
	lfgButton:SetSize(33,33)
	lfgButton:SetHighlightTexture("?") local hi = lfgButton:GetHighlightTexture()
	hi:SetAtlas("groupfinder-eye-highlight", true)
	hi:SetBlendMode("ADD")
	hi:SetAlpha(0.25)
	local border = lfgButton:CreateTexture("OVERLAY")
	border:SetSize(52, 52)
	border:SetPoint("TOPLEFT", 1, -1.5)
	border:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")
	local ico = lfgButton:CreateTexture(nil, "ARTWORK")
	ico:SetTexture("Interface\\LFGFrame\\BattlenetWorking28")
	ico:SetAllPoints()
	local curIco, nextSwap = 28, 0.08
	lfgButton:SetScript("OnUpdate", function(self, elapsed)
		local goal, animate
		if easyDrop:IsOpen(self) then
			goal = 17
		else
			goal, animate = 28, self:IsMouseOver()
		end
		if curIco ~= goal or animate then
			if nextSwap < elapsed then
				curIco, nextSwap = (curIco + 1) % 29, 0.08
				local curIco = curIco > 4 and curIco < 9 and (8-curIco) or (curIco == 16 and 15) or curIco
				ico:SetTexture("Interface\\LFGFrame\\BattlenetWorking" .. curIco)
			else
				nextSwap = nextSwap - elapsed
			end
		end
	end)
	lfgButton:SetScript("OnHide", function(self)
		curIco, nextSwap, self.clickOpen = 28, 0.08
		ico:SetTexture("Interface\\LFGFrame\\BattlenetWorking28")
		if easyDrop:IsOpen(self) then
			CloseDropDownMenus()
		end
	end)
	lfgButton:SetScript("OnEnter", function(self)
		easyDrop:DelayOpenClick(self)
	end)

	lfgButton:SetScript("OnClick", function(self)
		local PAGE_FRAME = self:GetParent():GetParent()
		if easyDrop:CheckToggle(self) then
			local mi = PAGE_FRAME.missionInfo
			local ff = PAGE_FRAME.Followers
			local f1, f2, f3 = ff[1].info, ff[2].info, ff[3].info
			f1, f2, f3 = f1 and f1.followerID, mi.numFollowers > 1 and f2 and f2.followerID, mi.numFollowers > 1 and f3 and f3.followerID

			local mm = G.GetSuggestedGroupsMenu(mi, f1, f2, f3)
			if mm and #mm > 1 then
				easyDrop:Open(self, mm, "TOPRIGHT", self, "TOPLEFT", -2, 12)
			else
				self:Hide()
			end
		end
	end)
	
	MISSION_PAGE_FRAME:HookScript("OnShow", function()
		lfgButton:SetParent(MISSION_PAGE_FRAME.Stage)
		lfgButton:SetPoint("TOPRIGHT", MISSION_PAGE_FRAME.Stage, "TOPRIGHT", -6, -28)
	end)
	SHIP_MISSION_PAGE:HookScript("OnShow", function()
		lfgButton:SetParent(SHIP_MISSION_PAGE.Stage)
		lfgButton:SetPoint("TOPRIGHT", SHIP_MISSION_PAGE.Stage, "TOPRIGHT", -6, -28)
		lfgButton:Show()
	end)
end
local function clearSearch()
	local sb = GarrisonMissionFrameFollowers.SearchBox
	if sb:GetText() == sb.clearText then
		sb:SetText("")
	end
	sb.clearText = nil
end
hooksecurefunc(GarrisonMissionFrame, "ShowMission", function()
	clearSearch()
	local mi = MISSION_PAGE_FRAME.missionInfo
	local _, expTime = G.GetMissionSeen(mi and mi.missionID, mi)
	if expTime ~= "" then
		MISSION_PAGE_FRAME.Stage.MissionSeen:SetText(L"Expires in:" .. " " .. HIGHLIGHT_FONT_COLOR_CODE .. expTime)
	else
		MISSION_PAGE_FRAME.Stage.MissionSeen:SetText("")
	end
	lfgButton:Show()
end)
EV.GARRISON_MISSION_NPC_CLOSE = clearSearch

do -- Mission details close button size [6.1]
	MISSION_PAGE_FRAME.CloseButton:SetSize(32, 32)
	MISSION_PAGE_FRAME.CloseButton:SetPoint("TOPRIGHT", 2, 2)
end
do -- Minimize mission
	local min = CreateFrame("Button", nil, MISSION_PAGE_FRAME, "UIPanelCloseButtonNoScripts")
	MISSION_PAGE_FRAME.MinimizeButton = min
	min:SetNormalTexture("Interface\\Buttons\\UI-Panel-HideButton-Up")
	min:SetPushedTexture("Interface\\Buttons\\UI-Panel-HideButton-Down")
	min:SetPoint("RIGHT", MISSION_PAGE_FRAME.CloseButton, "LEFT", 8, 0)
	min:SetHitRectInsets(0,8,0,0)
	min:SetScript("OnClick", function()
		local mi = MISSION_PAGE_FRAME.missionInfo
		local mid, f1, f2, f3 = mi.missionID
		for i=1, mi.numFollowers do
			local fi = MISSION_PAGE_FRAME.Followers[mi.numFollowers+1-i].info
			f1, f2, f3 = fi and fi.followerID, f1, f2
			if mid and f1 then
				C_Garrison.RemoveFollowerFromMission(mid, f1)
			end
		end
		G.SaveMissionParty(mi.missionID, f1, f2, f3)
		roamingParty:DropFollowers(f1, f2, f3)
		MISSION_PAGE_FRAME.CloseButton:Click()
	end)
	min:SetScript("OnHide", function(self)
		if MISSION_PAGE_FRAME.missionInfo then
			if MISSION_PAGE_FRAME:IsShown() and self:IsShown() then
				self:Click()
			end
		end
	end)
	
	hooksecurefunc(GarrisonMissionFrame, "AssignFollowerToMission", function(_, _, info)
		if info and info.followerID then
			G.DissolveMissionByFollower(info.followerID)
			G.PushFollowerPartyStatus(info.followerID)
		end
	end)
end

do -- GarrisonFollowerTooltip xp textures
	local tf, tf2 = GarrisonFollowerTooltip, GarrisonShipyardFollowerTooltip
	repeat
		tf.XPGained = tf:CreateTexture(nil, "ARTWORK", nil, 2)
		tf.XPGained:SetTexture(1, 0.8, 0.2)
		tf.XPRewardBase = tf:CreateTexture(nil, "ARTWORK", nil, 2)
		tf.XPRewardBase:SetTexture(0.6, 1, 0)
		tf.XPRewardBase:SetPoint("TOPLEFT", tf.XPBar, "TOPRIGHT")
		tf.XPRewardBase:SetPoint("BOTTOMLEFT", tf.XPBar, "BOTTOMRIGHT")
		tf.XPRewardBonus = tf:CreateTexture(nil, "ARTWORK", nil, 2)
		tf.XPRewardBonus:SetTexture(0, 0.75, 1)
		tf.XPRewardBonus:SetPoint("TOPLEFT", tf.XPRewardBase, "TOPRIGHT")
		tf.XPRewardBonus:SetPoint("BOTTOMLEFT", tf.XPRewardBase, "BOTTOMRIGHT")
		tf, tf2 = tf2
	until not tf
	local function setFollowerData(self, data)
		self.lastShownData = data
		if self.XPGained then
			self.XPGained:Hide()
			self.XPRewardBase:Hide()
			self.XPRewardBonus:Hide()
		end
	end
	hooksecurefunc("GarrisonFollowerTooltipTemplate_SetGarrisonFollower", setFollowerData)
	hooksecurefunc("GarrisonFollowerTooltipTemplate_SetShipyardFollower", setFollowerData)
end
do -- Projected XP rewards
	local function MissionFollower_OnEnter(self)
		local mf = MISSION_PAGE_FRAME:IsVisible() and MISSION_PAGE_FRAME or SHIP_MISSION_PAGE
		if self.info and mf.missionInfo then
			G.ExtendMissionInfoWithXPRewardData(mf.missionInfo, true)
			G.ExtendFollowerTooltipProjectedRewardXP(mf.missionInfo, self.info)
		end
	end
	for i=1,3 do
		MISSION_PAGE_FRAME.Followers[i]:HookScript("OnEnter", MissionFollower_OnEnter)
		SHIP_MISSION_PAGE.Followers[i]:HookScript("OnEnter", MissionFollower_OnEnter)
	end
end
do -- Counter-follower lists
	local itip = CreateFrame("GameTooltip", "MPInnerTip", nil, "GameTooltipTemplate") do
		itip:SetBackdrop(nil)
		itip:SetPadding(0)
		itip:SetScript("OnHide", function(self)
			self:Hide()
			self:SetParent(nil)
			self:ClearAllPoints()
		end)
		local function adjustTipSize(atip, itip)
			local il, al, at, iw = itip:GetLeft(), atip:GetLeft(), atip:GetTop(), itip:GetWidth()
			if not (il and al and at and iw) then
				return
			end
			local lm = il - al
			atip:SetWidth(math.max(245, lm + iw))
			if atip.Description then
				atip.Description:SetWidth(atip:GetWidth()+atip:GetLeft()-atip.Description:GetLeft()-10)
			end
			local tw = atip:GetWidth() - lm - 18
			if tw > itip:GetWidth() then
				itip:SetMinimumWidth(tw)
				itip:Show()
			end
			itip:Show()
			atip:SetHeight(at-itip:GetTop()+itip:GetHeight()+2)
		end
		itip:SetScript("OnUpdate", function(self)
			local p = self:GetParent()
			if p and p.InnerTip == self then
				adjustTipSize(p, self)
			end
		end)
		function itip:ActivateFor(owner, ...)
			if owner then
				self:SetParent(owner)
				self:SetOwner(owner, "ANCHOR_PRESERVE")
				self:ClearAllPoints()
				owner.InnerTip = self
				self:SetPoint(...)
			end
		end
	end
	
	hooksecurefunc("GarrisonFollowerTooltipTemplate_SetGarrisonFollower", function(self, _info)
		for i=1,#self.Abilities do
			local ci = self.Abilities[i].CounterIcon
			if ci:IsShown() then
				ci:SetMask("")
				ci:SetTexCoord(4/64,60/64,4/64,60/64)
			end
		end
	end)
	
	hooksecurefunc("GarrisonFollowerAbilityTooltipTemplate_SetAbility", function(self, aid)
		self.CounterIcon:SetMask("")
		self.CounterIcon:SetTexCoord(4/64,60/64,4/64,60/64)
		if self.Details:IsShown() then
			itip:ActivateFor(self, "TOPLEFT", self.CounterIcon, "BOTTOMLEFT", -14, 16)
		else
			itip:ActivateFor(self, "TOPLEFT", self.Description, "BOTTOMLEFT", -10, 12)
		end
		local tid = not C_Garrison.GetFollowerAbilityIsTrait(aid) and C_Garrison.GetFollowerAbilityCounterMechanicInfo(aid)
		if self.Details:IsShown() and tid then
			G.SetThreatTooltip(itip, tid, nil, nil, nil, true)
		else
			G.SetTraitTooltip(itip, aid, nil, nil, true)
		end
		itip:Show()
	end)
	GarrisonMissionMechanicFollowerCounterTooltip:HookScript("OnShow", function(self)
		local mech = G.GetMechanicInfo((self.Icon:GetTexture() or ""):lower())
		if mech then
			if self.CounterName:IsShown() then
				itip:ActivateFor(self, "TOPLEFT", self.CounterIcon, "BOTTOMLEFT", -10, 16)
			else
				itip:ActivateFor(self, "TOPLEFT", self.Name, "BOTTOMLEFT", -10, 0)
			end
			G.SetThreatTooltip(itip, mech, nil, nil, nil, true)
			itip:Show()
		end
	end)
	GarrisonMissionMechanicTooltip:HookScript("OnShow", function(self)
		local mech = G.GetMechanicInfo((self.Icon:GetTexture() or ""):lower())
		if mech then
			itip:ActivateFor(self, "TOPLEFT", self.Description, "BOTTOMLEFT", -10, 16)
			G.SetThreatTooltip(itip, mech, nil, self.missionLevel, nil, true)
			itip:Show()
		end
	end)
end
do -- suppress completion toast while missions UI is visible
	local registered = false
	GarrisonMissionFrame:HookScript("OnShow", function()
		if AlertFrame:IsEventRegistered("GARRISON_MISSION_FINISHED") then
			registered = true
			AlertFrame:UnregisterEvent("GARRISON_MISSION_FINISHED")
		end
	end)
	GarrisonMissionFrame:HookScript("OnHide", function()
		if registered then
			AlertFrame:RegisterEvent("GARRISON_MISSION_FINISHED")
			registered = false
		end
	end)
end
do -- Mission page rewards
	local function Reward_OnClick(self)
		if IsModifiedClick("CHATLINK") then
			local q, text = self.quantity and self.quantity > 1 and self.quantity .. " " or ""
			if self.itemID then
				text = select(2, GetItemInfo(self.itemID))
				if text then
					text = q .. text
				end
			elseif self.currencyID and self.currencyID > 0 and self.currencyQuantity then
				text = self.currencyQuantity .. " " .. GetCurrencyLink(self.currencyID)
			elseif self.title then
				text = q .. self.title
			end
			if text then
				ChatEdit_InsertLink(text)
			end
		end
	end
	hooksecurefunc("GarrisonMissionPage_SetReward", function(self, reward)
		self.quantity = reward.quantity or reward.followerXP
		self:SetScript("OnMouseUp", Reward_OnClick)
	end)
end

local function SetFollowerIgnore(_, fid, val)
	MasterPlan:SetFollowerIgnored(fid, val)
	GarrisonMissionFrame.FollowerList.dirtyList = true
	GarrisonFollowerList_UpdateFollowers(GarrisonMissionFrame.FollowerList)
end
hooksecurefunc(GarrisonFollowerOptionDropDown, "initialize", function(self)
	local fi = self.followerID and C_Garrison.GetFollowerInfo(self.followerID)
	if fi and fi.isCollected then
		DropDownList1.numButtons = DropDownList1.numButtons - 1
		
		local info, ignored = UIDropDownMenu_CreateInfo(), T.config.ignore[fi.followerID]
		info.text, info.notCheckable = ignored and L"Unignore" or L"Ignore", true
		info.func, info.arg1, info.arg2 = SetFollowerIgnore, fi.followerID, not ignored
		UIDropDownMenu_AddButton(info)
		
		info.text, info.func = CANCEL
		UIDropDownMenu_AddButton(info)
	end
end)

do -- Follower headcounts
	local mf = GarrisonMissionFrame.MissionTab.MissionList.MaterialFrame
	local ff, fs = CreateFrame("Frame", nil, mf), mf:CreateFontString(nil, "ARTWORK", "GameFontHighlightLarge")
	local ni, nw, nx, nm = 0, 0, 0, 0
	ff:SetWidth(190) ff:SetPoint("TOPLEFT") ff:SetPoint("BOTTOMLEFT")
	fs:SetPoint("LEFT", 16, 0)
	ff:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT")
		GameTooltip:AddLine(GARRISON_FOLLOWERS_TITLE, 1,1,1)
		if ni > 0 then
			GameTooltip:AddLine("|cff40ff40" .. ni .. " " .. L"Idle")
		end
		if nx > 0 then
			GameTooltip:AddLine("|cffc864ff" .. nx .. " " .. L"Idle (max-level)")
		end
		if nw > 0 then
			GameTooltip:AddLine(nw .. " " .. GARRISON_FOLLOWER_WORKING)
		end
		if nm > 0 then
			GameTooltip:AddLine("|cff80dfff" .. nm .. " " .. GARRISON_FOLLOWER_ON_MISSION)
		end
		GameTooltip:Show()
	end)
	ff:SetScript("OnLeave", function(self)
		if GameTooltip:IsOwned(self) then
			GameTooltip:Hide()
		end
	end)
	for _, s in pairs({mf:GetRegions()}) do
		if s:IsObjectType("FontString") and s:GetText() == GARRISON_YOUR_MATERIAL then
			s:Hide()
		end
	end
	local function sync()
		ni, nw, nx, nm = 0, 0, 0, 0
		for k, v in pairs(G.GetFollowerInfo()) do
			if not v.isCollected or T.config.ignore[k] or v.followerTypeID ~= 1 then
			elseif v.status == GARRISON_FOLLOWER_WORKING then
				nw = nw + 1
			elseif v.status == GARRISON_FOLLOWER_ON_MISSION then
				nm = nm + 1
			elseif (v.status or "") ~= "" and v.status ~= GARRISON_FOLLOWER_IN_PARTY then
			elseif v.level == 100 and v.quality >= 4 then
				nx = nx + 1
			else
				ni = ni + 1
			end
		end
		local ico, spacer, t = "|TInterface\\FriendsFrame\\UI-Toast-FriendOnlineIcon:11:11:3:0:32:32:8:24:8:24:", "|TInterface\\Buttons\\UI-Quickslot2:9:9:0:0:64:64:31:32:31:32|t"
		if ni > 0 then t = ni .. ico .. "50:255:50|t" end
		if nx > 0 then t = (t and t .. spacer or "") .. nx .. ico .. "200:100:255|t" end
		if nw > 0 then t = (t and t .. spacer or "") .. nw .. ico .. "255:208:0|t" end
		if nm > 0 then t = (t and t .. spacer or "") .. nm .. ico .. "125:230:255|t" end
		fs:SetText(t or "")
	end
	
	hooksecurefunc(GarrisonMissionFrame, "UpdateCurrency", sync)
	EV.GARRISON_MISSION_NPC_OPENED = sync
	mf:HookScript("OnShow", sync)
end
do -- Scary follower warning
	local fol = MISSION_PAGE_FRAME.Followers
	for i=1,#fol do
		fol[i]:HookScript("OnEnter", function(self)
			local mi, td = MISSION_PAGE_FRAME.missionInfo, GarrisonFollowerTooltip.lastShownData
			if td and mi and self.info and td.underBiased and mi.level <= self.info.level and self.info.quality < 4 then
				local ub = GarrisonFollowerTooltip.UnderBiased
				local oh = ub:GetHeight()
				ub:SetText(GARRISON_FOLLOWER_BELOW_LEVEL_MAX_XP_TOOLTIP)
				GarrisonFollowerTooltip:SetHeight(GarrisonFollowerTooltip:GetHeight()-oh+ub:GetHeight())
			end
		end)
	end
end

do
	local r = MISSION_PAGE_FRAME.RewardsFrame.Rewards
	local oe = r[1]:GetScript("OnEnter")
	local function Reward_OnEnter(self, ...)
		if self.itemID then
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			G.SetItemTooltip(GameTooltip, self.itemID)
			GameTooltip:Show()
		else
			oe(self, ...)
		end
	end
	for i=1,#r do
		r[i]:SetScript("OnEnter", Reward_OnEnter)
	end
end