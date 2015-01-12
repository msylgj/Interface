local QuestPlateDefaults = {
	-- 82/140 * 56.39 = offset for smaller plates?
	IconX = 82,
	IconY = -9,
	TextX = 0,
	TextY = 10,
	EnableText = true,
	EnableIcon = false,
}

local function ResetSettings()
	QuestPlateSettings = {}
	for k,v in pairs(QuestPlateDefaults) do
		QuestPlateSettings[k] = v
	end
end
ResetSettings()

local strmatch = string.match
--local bit_band = bit.band
local OurName = UnitName('player') -- this should probably be available by the time the addon loads
local GUIDs = {} -- [UnitName] = GUID
local QuestItems = {} -- [QuestName] = item texture
local QuestPlateTooltip = CreateFrame('GameTooltip', 'QuestPlateTooltip', nil, 'GameTooltipTemplate')

local function GetQuestProgress(name)
	--if not QuestPlatesEnabled or not name then return end
	local guid = GUIDs[name]
	if not guid then return end
	
	QuestPlateTooltip:SetOwner(WorldFrame, 'ANCHOR_NONE')
	QuestPlateTooltip:SetHyperlink('unit:' .. guid)
	
	local progressGlob -- concatenated glob of quest text
	local questType -- 1 for player, 2 for group
	local objectiveCount = 0
	local questTexture -- if usable item
	for i = 3, QuestPlateTooltip:NumLines() do
		local str = _G['QuestPlateTooltipTextLeft' .. i]
		local text = str and str:GetText()
		if not text then return end
		--(" PlayerName - Quest Name: 0/1"):match('^ ([^ ]-) ?%- (.+)$')
		local playerName, progressText = strmatch(text, '^ ([^ ]-) ?%- (.+)$') -- nil or '' if 1 is missing but 2 is there
		local x, y
		if progressText then
			x, y = strmatch(progressText, '(%d+)/(%d+)$')
			if x and y then
				local numLeft = y - x
				if numLeft > objectiveCount then -- track highest number of objectives
					objectiveCount = numLeft
				end
			end
		end
		
		if playerName and playerName ~= '' and playerName ~= OurName then -- quest is for another group member
			if not questType then
				questType = 2
			end
		else
		
			if progressText then
				--local x, y = strmatch(progressText, '(%d+)/(%d+)$') -- ignore if complete
				if not x or (x and y and x ~= y) then
					progressGlob = progressGlob and progressGlob .. '\n' .. progressText or progressText
				end
			else -- figure out if there's a usable item for this quest
				local itemTexture = QuestItems[text]
				if itemTexture then
					progressGlob = progressGlob and progressGlob .. '\n|cffffff00' .. text .. '|r |T' .. itemTexture .. ':14|t'
					                             or '|cffffff00' .. text .. '|r |T' .. itemTexture .. ':14|t'
					questTexture = itemTexture
				end
			--[[ i'm leaving this here in case i need it later
				if format('%.2f%.2f%.2f', str:GetTextColor()) == '1.000.820.00' then -- text may be a quest title
					for questIndex = 1, GetNumQuestLogEntries() do
						if GetQuestLogTitle(questIndex) == text then -- text is a quest title
							local link, item, charges, showItemWhenComplete = GetQuestLogSpecialItemInfo(questIndex)
							if link then
								local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice = GetItemInfo(link)
								--print(text, GetQuestLogSpecialItemInfo(questIndex))
								progressGlob = progressGlob and (progressGlob .. '\n|cffffff00' .. text .. '|r |T' .. itemTexture .. ':20|t') or ('|cffffff00' .. text .. '|r |T' .. itemTexture .. ':20|t')
							end
							break
						end
					end
				end
			--]]
			end
		end
	end
	
	return progressGlob, progressGlob and 1 or questType, objectiveCount, questTexture
end

local VisiblePlates = {} -- [NamePlate] = true
local function OnPlateShow(plate)
	VisiblePlates[plate] = true
	local bargroup, namegroup = plate:GetChildren()
	local namestr = namegroup:GetRegions()
	local name = namestr:GetText()
	--plate.QuestPlateText:SetText(GUIDs[name] and (GetQuestProgress(GUIDs[name]) or 'Placeholder: 1/1') or 'Placeholder: 0/1')
	local progressGlob, questType, objectiveCount, questTexture = GetQuestProgress(name)
	if progressGlob then -- has quest
		plate.QuestPlate.questText:SetText(QuestPlateSettings.EnableText and progressGlob or '')
		
		if not QuestPlateSettings.EnableIcon then -- not terribly efficient but none of this is
			plate.QuestPlate.iconText:Hide()
			plate.QuestPlate.jellybean:Hide()
		else
			plate.QuestPlate.iconText:SetText(objectiveCount > 0 and objectiveCount or '?')
			plate.QuestPlate.jellybean:Show()
			plate.QuestPlate.iconText:Show()
		end
		
		plate.QuestPlate:SetScale(min(141,plate:GetWidth())/141) -- scale down the smaller plates? the text is unreadable..
		-- for some reason tidy plates actually manages to make the original nameplate larger than it should be

		if questType == 1 then
			plate.QuestPlate.jellybean:SetDesaturated(false)
			plate.QuestPlate.iconText:SetTextColor(1, .82, 0)
		elseif questType == 2 then
			plate.QuestPlate.jellybean:SetDesaturated(true)
			plate.QuestPlate.iconText:SetTextColor(1, 1, 1)
		end
		
		if questTexture then
			--plate.QuestPlate.itemTexture:SetTexture(questTexture)
			plate.QuestPlate.itemTexture:Show()
		else
			plate.QuestPlate.itemTexture:Hide()
		end
		
		if not plate.QuestPlate:IsVisible() then
			plate.QuestPlate.ani:Stop()
			plate.QuestPlate:Show()
			plate.QuestPlate.ani:Play()
		end
	else
		-- hide it
		plate.QuestPlate:Hide()
		--plate.QuestPlate.questText:SetText('')
	end
end

local function OnPlateHide(plate)
	VisiblePlates[plate] = false
	plate.QuestPlate:Hide()
end


local function Questify(plate)
	--if plate.QuestPlateText then return end -- change to create fontstring if doesn't exist, then style accordingly
	plate.Questified = true
	if not plate.QuestPlate then -- make the string if it doesn't exist
		local bargroup, namegroup = plate:GetChildren()
		local healthbar, castbar = bargroup:GetChildren()
		plate.QuestPlateText = namegroup:CreateFontString(nil, 'BACKGROUND', 'GameFontWhiteSmall')
		plate:HookScript('OnShow', OnPlateShow)
		plate:HookScript('OnHide', OnPlateHide)
		
		local name = namegroup:GetRegions()
		hooksecurefunc(name, 'SetTextColor', function() print('SetTextColor!') end)
		
		local frame = CreateFrame('frame', nil, plate)
		frame:Hide()
		--frame:SetAllPoints()
		frame:SetPoint('CENTER')
		frame:SetSize(141, 39)
		plate.QuestPlate = frame
		
		local icon = frame:CreateTexture(nil, nil, nil, 0)
		icon:SetSize(28, 22)
		icon:SetTexture('Interface/QuestFrame/AutoQuest-Parts')
		icon:SetTexCoord(0.30273438, 0.41992188, 0.015625, 0.953125)
		--frame:SetScale(plate:GetWidth()/140)
		--icon:SetPoint('CENTER', QuestPlateSettings.IconX * (plate:GetWidth()/140) + (QuestPlateSettings.IconX < 0 and -14 or 14), QuestPlateSettings.IconY * (plate:GetHeight()/39) )--+ (QuestPlateSettings.IconX < 0 and -14 or 14))
		icon:SetPoint('CENTER', QuestPlateSettings.IconX, QuestPlateSettings.IconY)
		--icon:SetPoint('CENTER', QuestPlateSettings.IconX, QuestPlateSettings.IconY)--+ (QuestPlateSettings.IconX < 0 and -14 or 14))
		frame.jellybean = icon
		
		local itemTexture = frame:CreateTexture(nil, nil, nil, 1)
		--itemTexture:SetSize(19.6, 15.4)
		itemTexture:SetSize(17.6, 13.4)
		itemTexture:SetPoint('CENTER', icon)
		itemTexture:SetTexture('Interface/QuestFrame/AutoQuest-Parts')
		itemTexture:SetTexCoord(0.21679688, 0.29882813, 0.015625, 0.671875)
		itemTexture:SetBlendMode('ADD')
		itemTexture:SetVertexColor(1,1,0,0.4)
		itemTexture:Hide()
		frame.itemTexture = itemTexture
		
		local iconText = frame:CreateFontString(nil, nil, 'SystemFont_Outline_Small')
		iconText:SetPoint('CENTER', icon, 0.8, 0)
		iconText:SetShadowOffset(1, -1)
		--iconText:SetText(math.random(22))
		iconText:SetTextColor(1,.82,0)
		frame.iconText = iconText
		
		local questText = frame:CreateFontString(nil, 'BACKGROUND', 'GameFontWhiteSmall')
		questText:SetPoint('TOP', frame, 'BOTTOM', QuestPlateSettings.TextX, QuestPlateSettings.TextY)
		questText:SetShadowOffset(1, -1)
		frame.questText = questText
		
		
		local qmark = frame:CreateTexture(nil, 'OVERLAY')
		qmark:SetSize(28, 28)
		qmark:SetPoint('CENTER', icon)
		qmark:SetTexture('Interface/WorldMap/UI-WorldMap-QuestIcon')
		qmark:SetTexCoord(0, 0.56, 0.5, 1)
		qmark:SetAlpha(0)
		
		local duration = 1
		local group = qmark:CreateAnimationGroup()
		local alpha = group:CreateAnimation('Alpha')
		alpha:SetOrder(1)
		alpha:SetChange(1)
		alpha:SetDuration(0)
		
		local translation = group:CreateAnimation('Translation')
		translation:SetOrder(1)
		translation:SetOffset(0, 20)
		translation:SetDuration(duration)
		translation:SetSmoothing('OUT')
		
		local alpha2 = group:CreateAnimation('Alpha')
		alpha2:SetOrder(1)
		alpha2:SetChange(-1)
		alpha2:SetDuration(duration)
		alpha2:SetSmoothing('OUT')
		
		--[[
		local scale = group:CreateAnimation('Scale')
		scale:SetOrder(1)
		scale:SetScale(2,2)
		scale:SetDuration(duration)
		scale:SetSmoothing('OUT')
		--]]
		
		frame.ani = group

		--[[
		
		plate.QuestPlateIconFrame = CreateFrame('frame', nil, plate)
		--plate.QuestPlateIconFrame:SetFrameLevel(plate:GetFrameLevel() + 3)
		plate.QuestPlateIconFrame:SetSize(28, 22)
		plate.QuestPlateIconFrame:SetPoint('CENTER', QuestPlateSettings.IconX * (plate:GetWidth()/140), QuestPlateSettings.IconY)
		plate.QuestPlateIcon = plate.QuestPlateIconFrame:CreateTexture(nil, 'ARTWORK')
		plate.QuestPlateIcon:SetTexture('Interface/QuestFrame/AutoQuest-Parts')
		plate.QuestPlateIcon:SetTexCoord(0.30273438, 0.41992188, 0.015625, 0.953125)
		plate.QuestPlateIcon:SetAllPoints()
		
		plate.QuestPlateText2 = plate.QuestPlateIconFrame:CreateFontString(nil, 'ARTWORK', 'SystemFont_Outline_Small')
		plate.QuestPlateText2:SetPoint('CENTER', plate.QuestPlateIconFrame, 0.8, 0)
		plate.QuestPlateText2:SetShadowOffset(1, -1)
		plate.QuestPlateText2:SetText(math.random(22))
		plate.QuestPlateText2:SetTextColor(1,.82,0)
		--]]
	end
end

local function IsNameplate(plate)
	if plate.Questified then return false end -- ignore if already modified

	local name = plate:GetName()
	if name and strmatch(name, '^NamePlate%d+$') then -- default
		Questify(plate)
		--local bargroup, namegroup = plate:GetChildren()
		--plate.QuestPlateText:SetShadowOffset(1, -1)
		--plate.QuestPlateText:SetPoint('TOP', plate, 'BOTTOM', 0, -2)
		
		--local mt = getmetatable(plate)
		--if not mt.__newindex then
			--setmetatable(plate, {__index = mt.__index, __newindex = MetaHook}) -- this is a horrible idea
		--end
		return true
	end
	
	return false
end

local numWorldChildren = 0
WorldFrame:HookScript('OnUpdate', function(self)
	local children = self:GetNumChildren()
	if children ~= numWorldChildren then numWorldChildren = children
		for _, plate in pairs({self:GetChildren()}) do
			--local platename = plate:GetName()
			if IsNameplate(plate) then
				OnPlateShow(plate)
			end
		end
	end	
end)

local function RefreshPlates()
	--print(GetTime(), 'RefreshPlates')
	-- Ideally we would only update the nameplates that have changed their progress text, but meh
	for plate, shown in pairs(VisiblePlates) do
		if shown then
			OnPlateShow(plate)
		end
	end
end

local function UpdateStyles()
	for plate, shown in pairs(VisiblePlates) do
		plate.QuestPlate.jellybean:ClearAllPoints()
		plate.QuestPlate.jellybean:SetPoint('CENTER', plate.QuestPlate, QuestPlateSettings.IconX, QuestPlateSettings.IconY)
		plate.QuestPlate.questText:ClearAllPoints()
		plate.QuestPlate.questText:SetPoint('TOP', plate.QuestPlate, 'BOTTOM', QuestPlateSettings.TextX, QuestPlateSettings.TextY)
	end
end

local function CacheGUID(name, guid)
	if not name then return end
	if not GUIDs[name] then
		GUIDs[name] = guid
		RefreshPlates() -- only refresh if it's the first time we've encountered this unit
		-- we also really only need to refresh if it has quest text, so it might be more efficient to check that first
	else
		GUIDs[name] = guid -- update guid because i'm not sure how long it can be used
	end
end

local f = CreateFrame('frame')
f:SetScript('OnEvent', function(self, event, ...)
	return self[event] and self[event](self, ...)
end)

function f:UPDATE_MOUSEOVER_UNIT()
	local name = UnitName('mouseover')
	if name then CacheGUID(name, UnitGUID('mouseover')) end
end
f:RegisterEvent('UPDATE_MOUSEOVER_UNIT')

function f:PLAYER_TARGET_CHANGED()
	local name = UnitName('target')
	if name then CacheGUID(name, UnitGUID('target')) end -- and not UnitIsPlayerControlled('target') 
end
f:RegisterEvent('PLAYER_TARGET_CHANGED')

function f:COMBAT_LOG_EVENT_UNFILTERED(_, _, _, srcGUID, srcName, srcFlags, _, dstGUID, dstName, dstFlags)
	-- i really don't think it would be worth checking if the unit is a player before caching its guid
	-- plus i think players can be quest objectives..
	--bit_band(flags, COMBATLOG_OBJECT_CONTROL_MASK) == COMBATLOG_OBJECT_CONTROL_PLAYER
	if srcName then CacheGUID(srcName, srcGUID) end
	if dstName then CacheGUID(dstName, dstGUID) end
end
f:RegisterEvent('COMBAT_LOG_EVENT_UNFILTERED')

function f:QUEST_LOG_UPDATE()
	for questIndex = 1, GetNumQuestLogEntries() do -- cache which quests have items
		local link = GetQuestLogSpecialItemInfo(questIndex)
		if link then
			local _, _, _, _, _, _, _, _, _, texture = GetItemInfo(link)
			QuestItems[GetQuestLogTitle(questIndex)] = texture
		end
	end
	RefreshPlates()
end
f:RegisterEvent('QUEST_LOG_UPDATE')

function f:ZONE_CHANGED_NEW_AREA()
	wipe(GUIDs) -- flush our cache when we change zones, just to keep the table size down
	--wipe(QuestItems)
end
f:RegisterEvent('ZONE_CHANGED_NEW_AREA')

local AddonName = ...
function f:ADDON_LOADED(addon)
	if addon ~= AddonName then return end
	f:UnregisterEvent('ADDON_LOADED')
	
	OurName = UnitName('player') -- probably not necessary
	
	for k,v in pairs(QuestPlateDefaults) do -- Load default settings for any keys that don't exist
		if QuestPlateSettings[k] == nil then
			QuestPlateSettings[k] = v
		end
	end
	
	RefreshPlates()
end
f:RegisterEvent('ADDON_LOADED')



local function DemoPlate() -- this should create an acceptable approximation of a nameplate in the center of the screen
	if NamePlate0 then
		NamePlate0:SetShown(not NamePlate0:IsShown())
	else
		local plate = CreateFrame('frame', 'NamePlate0', WorldFrame)
		--plate:SetPoint('CENTER')
		
		local bargroup, namegroup = CreateFrame('frame', nil, plate), CreateFrame('frame', nil, plate)
		
		--- BAR GROUP
		local healthbar, castbar = CreateFrame('statusbar', nil, bargroup), CreateFrame('statusbar', nil, bargroup)
		local x, y = WorldFrame:GetSize()
		bargroup:SetPoint('BOTTOM', WorldFrame, 'BOTTOMLEFT', x/2, y/2 + 20)
		bargroup:SetSize(141, 39)
		plate:SetPoint('TOPLEFT', bargroup) -- yeah..
		plate:SetSize(141, 39)
		--plate.SetSize = function() end
		--plate.SetHeight = function() end
		--plate.SetWidth = function() end
	
		healthbar:SetSize(113.35, 11)
		healthbar:SetStatusBarTexture([[Interface\TargetingFrame\UI-TargetingFrame-BarFill]], 'BACKGROUND')
		healthbar:SetFrameLevel(bargroup:GetFrameLevel()-1)
		healthbar:SetStatusBarColor(1, 0, 0)
		healthbar:SetMinMaxValues(0, 1)
		healthbar:SetValue(1)
		healthbar:SetPoint('BOTTOMLEFT', plate, 4.37, 4.89)
		
		local glow = bargroup:CreateTexture() glow:Hide()
		
		local border = bargroup:CreateTexture()
		border:SetAllPoints(plate)
		border:SetTexture("Interface\\Tooltips\\Nameplate-Border")
		
		local highlight = bargroup:CreateTexture() highlight:Hide()
		
		local level = bargroup:CreateFontString(nil, nil, 'SystemFont_Shadow_Med3')
		level:SetShadowOffset(1.56, -1.56)
		level:SetTextColor(1, 1, 0)
		level:SetText('99')
		level:SetPoint('CENTER', plate, 'BOTTOMRIGHT', -12.61, 11.14)
		
		local bossIcon, raidIcon, stateIcon = bargroup:CreateTexture(), bargroup:CreateTexture(), bargroup:CreateTexture()
		bossIcon:Hide()
		raidIcon:Hide()
		stateIcon:Hide()
		
		-- CAST BAR
		local _, castbarOverlay, shieldedRegion, spellIconRegion = castbar:CreateTexture(), castbar:CreateTexture(), castbar:CreateTexture(), castbar:CreateTexture()
		castbar:Hide()
		
		-- NAME GROUP
		local name = namegroup:CreateFontString(nil, nil, 'SystemFont_Shadow_Med3')
		name:SetPoint('BOTTOM', plate, 'CENTER') -- frizqt 14
		name:SetShadowOffset(1.56, -1.56)
		name:SetText('QuestPlates')
		
		-- create draggable elements for the icon and the quest text then save their relative positions
		if not IsNameplate(plate) then return end
		
		plate.QuestPlate:Show()
		plate.QuestPlate.Hide = function() end
	
		--plate.QuestPlate:HookScript('OnHide', function(self) self:Show() end) -- this is not a great solution
		plate.QuestPlate.questText:SetText('This is some placeholder text: 0/1\n|cffffff00> Click to drag < |r')
		plate.QuestPlate.iconText:SetText('?')
	
		local plateX, plateY = plate:GetCenter()
		
		local jellybeanFrame = CreateFrame('frame', nil, plate.QuestPlate)
		plate.QuestPlate.jellybeanFrame = jellybeanFrame
		
		local iconX, iconY = plate.QuestPlate.jellybean:GetCenter()
		jellybeanFrame:SetSize(plate.QuestPlate.jellybean:GetSize())
		--jellybeanFrame:SetPoint('CENTER', iconX - plateX, iconY - plateY)
		jellybeanFrame:SetPoint('CENTER', plate.QuestPlate.jellybean)
		
		--plate.QuestPlate.jellybean:ClearAllPoints()
		--plate.QuestPlate.jellybean:SetPoint('CENTER', jellybeanFrame)
		
		jellybeanFrame:SetBackdrop({edgeFile='interface/buttons/white8x8', edgeSize=2})
		jellybeanFrame:SetBackdropBorderColor(1,0,0,0)
		
		--jellybeanFrame:SetAllPoints(plate.QuestPlate.jellybean)
		
		jellybeanFrame:EnableMouse(true)
		jellybeanFrame:SetScript('OnEnter', function(self)
			SetCursor('INTERACT_CURSOR')
			self:SetBackdropBorderColor(1,0,0,0.4)
		end)
		jellybeanFrame:SetScript('OnLeave', function(self)
			ResetCursor()
			self:SetBackdropBorderColor(1,0,0,0)
		end)
		
		jellybeanFrame:SetMovable(true)
		jellybeanFrame:SetScript('OnMouseDown', function(self)
			self:StartMoving()
		end)
		
		jellybeanFrame:SetScript('OnMouseUp', function(self)
			self:StopMovingOrSizing()
			local plateX, plateY = plate:GetCenter()
			local iconX, iconY = self:GetCenter() -- find offset from center of nameplate and save it
			QuestPlateSettings.IconX, QuestPlateSettings.IconY = iconX - plateX, iconY - plateY
			--[[ this was to choose which side to anchor on
			local offsetX = 0
			if newX < 0 then
				offsetX = plate:GetLeft() - self:GetLeft() + self:GetWidth()
				print('on left side', offsetX)
			else
				offsetX = self:GetRight() - self:GetWidth() - plate:GetRight()
				print('on right side', offsetX)
			end
			--]]
			UpdateStyles()
		end)
		-- /run print(select(4,NamePlate150:GetChildren():GetRegions()):GetTextColor())
		
		local questTextFrame = CreateFrame('frame', nil, plate.QuestPlate)
		plate.QuestPlate.questTextFrame = questTextFrame
		
		local textX, textY = plate.QuestPlate.questText:GetCenter()
		questTextFrame:SetSize(plate.QuestPlate.questText:GetSize())
		--questTextFrame:SetPoint('CENTER', textX - plateX, textY - plateY)
		questTextFrame:SetPoint('CENTER', plate.QuestPlate.questText)
		
		--plate.QuestPlate.questText:ClearAllPoints()
		--plate.QuestPlate.questText:SetPoint('CENTER', questTextFrame)
		
		--questTextFrame:SetAllPoints(plate.QuestPlate.questText)
		
		questTextFrame:SetBackdrop({edgeFile='interface/buttons/white8x8', edgeSize=2})
		questTextFrame:SetBackdropBorderColor(1,0,0,0)
		
		questTextFrame:EnableMouse(true)
		questTextFrame:SetScript('OnEnter', function(self)
			SetCursor('INTERACT_CURSOR')
			self:SetBackdropBorderColor(1,0,0,0.4)
		end)
		questTextFrame:SetScript('OnLeave', function(self)
			ResetCursor()
			self:SetBackdropBorderColor(1,0,0,0)
		end)
		
		questTextFrame:SetMovable(true)
		questTextFrame:SetScript('OnMouseDown', function(self)
			self:StartMoving()
		end)
		
		questTextFrame:SetScript('OnMouseUp', function(self)
			self:StopMovingOrSizing()
			local plateX, plateY = plate:GetCenter()
			local textX, textY = self:GetCenter()
			
			-- offset between bottom of plate and top of text
			--local offsetY = plate:GetBottom() - self:GetBottom() + self:GetHeight()
			QuestPlateSettings.TextX, QuestPlateSettings.TextY = textX - plateX, self:GetTop() - (plate.QuestPlate:GetTop() - plate.QuestPlate:GetHeight()) -- plate:GetTop() - plate:GetHeight() - self:GetTop() --self:GetBottom() + self:GetHeight() - plate:GetBottom()
			UpdateStyles()
		end)
		
		tinsert(UISpecialFrames, 'NamePlate0')
		
		OnPlateShow(plate)
	end
	if NamePlate0:IsVisible() then
		print('|cffaaffaaUse the demo plate in the middle of the screen to position the quest text and icon.|r')
	end
end


local Commands = {
	text = 'Toggle quest text on or off',
	icon = 'Toggle circular icon on or off',
	move = 'Adjust icon and text position',
	reset = 'Returns everything to default settings',
}

SLASH_QUESTPLATES1, SLASH_QUESTPLATES2, SLASH_QUESTPLATES3 = '/qp', '/questplates', '/questplate'
function SlashCmdList.QUESTPLATES(msg)
	local command, rest = msg:lower():match('^(%S*)%s*(.-)$')
	if not Commands[command] then
		print('|cffaaffaaQuestPlates Commands:|r')
		for k,v in pairs(Commands) do
			print(format('|cffaaffaa  %s|r - %s', k:upper(), v))
		end
	else
		if command == 'text' then
			if rest == 'on' then
				QuestPlateSettings.EnableText = true
			elseif rest == 'off' then
				QuestPlateSettings.EnableText = false
			else
				QuestPlateSettings.EnableText = not QuestPlateSettings.EnableText
			end
			RefreshPlates()
			print('|cffaaffaaQuest text |r' .. (QuestPlateSettings.EnableText and '|cff66ff66Enabled|r' or '|cffff6666Disabled|r'))
		elseif command == 'icon' then
			if rest == 'on' then
				QuestPlateSettings.EnableIcon = true
			elseif rest == 'off' then
				QuestPlateSettings.EnableIcon = false
			else
				QuestPlateSettings.EnableIcon = not QuestPlateSettings.EnableIcon
			end
			
			RefreshPlates()
			print('|cffaaffaaQuest icon |r' .. (QuestPlateSettings.EnableIcon and '|cff66ff66Enabled|r' or '|cffff6666Disabled|r'))
		elseif command == 'move' then
			DemoPlate()
		elseif command == 'reset' then
			ResetSettings()
			UpdateStyles()
			RefreshPlates()
			if NamePlate0 then -- hack to put the draggy bits back where they should be
				NamePlate0.QuestPlate.jellybeanFrame:SetPoint('CENTER', NamePlate0.QuestPlate.jellybean)
				NamePlate0.QuestPlate.questTextFrame:SetPoint('CENTER', NamePlate0.QuestPlate.questText)
			end
			print('|cffaaffaaQuestPlates reset.|r')
		end
	end
end