--[[
	Cloudy Unit Info
	Copyright (c) 2013, Cloudyfa
	All rights reserved.
]]


--- Variables ---
local currentID, currentGUID
local GearDB, SpecDB = {}, {}

local nextInspectRequest = 0
lastInspectRequest = 0

local prefixColor = '|cffF9D700'
local detailColor = '|cffffffff'

--local gearPrefix = STAT_AVERAGE_ITEM_LEVEL .. ': '
local gearPrefix = '装备等级: '
local specPrefix = SPECIALIZATION .. ': '

local upgradeTable = { 
   [0]   =  0, 
   [1]   =  8, -- 1/1 
   [15]   =  10, -- 2/2
   [171]   =  5, -- 2/2
   [373]   =  4, -- 1/2 
   [374]   =  8, -- 2/2 
   [375]   =  4, -- 1/3 
   [376]   =  4, -- 2/3 
   [377]   =  4, -- 3/3 
   [379]   =  4, -- 1/2 
   [380]   =  4, -- 2/2 
   [445]   =  0, -- 0/2 
   [446]   =  4, -- 1/2 
   [447]   =  8, -- 2/2
   [451]   =  0, -- 1/1 
   [452]   =  8, -- 1/1 
   [453]   =  0, -- 0/2 
   [454]   =  4, -- 1/2 
   [455]   =  8, -- 2/2 
   [456]   =  0, -- 0/1 
   [457]   =  8, -- 1/1 
   [458]   =  0, -- 0/4 
   [459]   =  4, -- 1/4 
   [460]   =  8, -- 2/4 
   [461]   = 12, -- 3/4 
   [462]   = 16, -- 4/4 
   [465]   =  0, -- 0/2
   [466]   =  4,
   [467]   =  8, 
   [468]   =  0, -- 0/2 
   [469]   =  4,
   [470]   =  8, -- 2/4 
   [471]   = 12, 
   [472]   = 16, 
   [476]   =  0, 
   [477]   =  4, 
   [478]   =  8, 
   [479]   =  0, 
   [480]   =  8, 
   [491]   =  0,
   [492]   =  4,
   [493]   =  8,
   [494]   =  0,
   [495]   =  4,
   [496]   =  8,
   [497]   = 12,
   [498]   = 16,
   [501]   = 0,
   [502]   = 4,
   [503]   = 8,
   [504]   = 12,
   [505]   = 16,
   [506]   = 20,
   [507]   = 24,
}

--- Create Frame ---
local f = CreateFrame('Frame', 'CloudyUnitInfo')
f:RegisterEvent('UNIT_INVENTORY_CHANGED')
f:RegisterEvent('INSPECT_READY')


--- Set Unit Info ---
local function SetUnitInfo(gear, spec)
	if (not gear) and (not spec) then return end

	local _, unit = GameTooltip:GetUnit()
	if (not unit) or (UnitGUID(unit) ~= currentGUID) then return end

	local gearLine, specLine
	for i = 2, GameTooltip:NumLines() do
		local line = _G['GameTooltipTextLeft' .. i]
		local text = line:GetText()

		if text and strfind(text, gearPrefix) then
			gearLine = line
		elseif text and strfind(text, specPrefix) then
			specLine = line
		end
	end

	if gear then
		gear = prefixColor .. gearPrefix .. detailColor .. gear

		if gearLine then
			gearLine:SetText(gear)
		else
			GameTooltip:AddLine(gear)
		end
	end

	if spec then
		spec = prefixColor .. specPrefix .. detailColor .. spec

		if specLine then
			specLine:SetText(spec)
		else
			GameTooltip:AddLine(spec)
		end
	end

	GameTooltip:Show()
end


--- BOA Item Level ---
local function BOALevel(level, slot)
	if (level > 80) and (slot ~= 'INVTYPE_CLOAK') and (slot ~= 'INVTYPE_HEAD') and (slot ~= 'INVTYPE_LEGS') then
		level = 80
	elseif (level > 85) then
		level = 85
	end

	if (level > 83) then
		level = 333 - (85 - level) * 8
	elseif (level > 80) then
		level = 317 - (83 - level) * 17
	elseif (level >= 68) then
		level = 187 - (80 - level) * 4
	elseif (level >= 58) then
		level = 109 - (68 - level) * 3
	else
		level = level + 5
	end

	return level
end


--- PVP Item Detect ---
local function IsPVPItem(link)
	local itemStats = GetItemStats(link)

	for stat in pairs(itemStats) do
		if (stat == 'ITEM_MOD_RESILIENCE_RATING_SHORT') or (stat == 'ITEM_MOD_PVP_POWER_SHORT') then
			return true
		end
	end

	return false
end


--- Unit Gear Info ---
local function UnitGear(id)
	if (not id) or (UnitGUID(id) ~= currentGUID) then return end

	local ulvl = UnitLevel(id)
	local class = select(2, UnitClass(id))

	local ilvl, boa, pvp = 0, 0, 0
	local total, count, delay = 0, 16, nil
	local mainhand, offhand, twohand = 1, 1, 0

	for i = 1, 17 do
		if (i ~= 4) then
			local itemTexture = GetInventoryItemTexture(id, i)

			if itemTexture then
				local itemLink = GetInventoryItemLink(id, i)

				if (not itemLink) then
					delay = true
				else
					local _, _, quality, level, _, _, _, _, slot = GetItemInfo(itemLink)

					if (not quality) or (not level) then
						delay = true
					else
--			 tonumber(select(1,strsplit(":", select(11,strsplit(":", string.match(GetInventoryItemLink("player", 1), "item[%-?%d:]+"))))))		
						--if (quality == 7) then
							--total = total + BOALevel(ulvl, slot)
							--boa = boa + 1
						--else
--						local upgradeId = tonumber(strmatch(itemLink, "item:%d+:%d+:%d+:%d+:%d+:%d+:%-?%d+:%-?%d+:%d+:%d+:(%d+)"))
							if (level >= 458) then 
								local upgradeId = tonumber(select(1,strsplit(":", select(11,strsplit(":", string.match(itemLink, "item[%-?%d:]+"))))))
								level = level + (upgradeId and upgradeTable[upgradeId] or 0) 

							end
							total = total + level
							if IsPVPItem(itemLink) then
								pvp = pvp + 1
							end
						--end

						if (i >= 16) then
							if (slot == 'INVTYPE_2HWEAPON') or (slot == 'INVTYPE_RANGED') or ((slot == 'INVTYPE_RANGEDRIGHT') and (class == 'HUNTER')) then
								twohand = twohand + 1
							end
						end
					end
				end
			else
				if (i == 16) then
					mainhand = 0
				elseif (i == 17) then
					offhand = 0
				end
			end
		end
	end

	if (mainhand == 0) and (offhand == 0) or (twohand == 1) then
		count = count - 1
	end

	if (not delay) then
		if (id == 'player') and (GetAverageItemLevel() > 0) then
			_, ilvl = GetAverageItemLevel()
		else
			ilvl = total / count
		end

		if (ilvl > 0) then ilvl = string.format('%.1f', ilvl) end
		if (boa > 0) then ilvl = ilvl .. '  |cffe6cc80' .. boa .. ' 帳綁' end
		if (pvp > 0) then ilvl = ilvl .. '  |cffa335ee' .. pvp .. ' PVP' end
	else
		ilvl = nil
	end

	return ilvl
end


--- Unit Specialization ---
local function UnitSpec(id)
	if (not id) or (UnitGUID(id) ~= currentGUID) then return end

	local specName

	if (id == 'player') then
		local specIndex = GetSpecialization()

		if specIndex then
			_, specName = GetSpecializationInfo(specIndex)
		else
			specName = NONE
		end
	else
		local specID = GetInspectSpecialization(id)

		if specID and (specID > 0) then
			_, specName = GetSpecializationInfoByID(specID)
		elseif (specID == 0) then
			specName = NONE
		end
	end

	return specName
end


--- Scan Current Unit ---
local function ScanUnit(id, forced)
	local cachedGear, cachedSpec

	if UnitIsUnit(id, 'player') then
		cachedGear = UnitGear('player')
		cachedSpec = UnitSpec('player')

		SetUnitInfo(cachedGear or CONTINUED, cachedSpec or CONTINUED)
	else
		if (not id) or (UnitGUID(id) ~= currentGUID) then return end

		cachedGear = GearDB[currentGUID]
		cachedSpec = SpecDB[currentGUID]

		if cachedGear or forced then
			SetUnitInfo(cachedGear or CONTINUED, cachedSpec)
		end

		if not (IsShiftKeyDown() or forced) then
			if cachedGear and cachedSpec then return end
			if UnitAffectingCombat('player') then return end
		end

		if (not UnitIsVisible(id)) then return end
		if UnitIsDeadOrGhost('player') or UnitOnTaxi('player') then return end
		if InspectFrame and InspectFrame:IsShown() then return end

		SetUnitInfo(CONTINUED, cachedSpec or CONTINUED)

		local timeSinceLastInspect = GetTime() - lastInspectRequest
		if (timeSinceLastInspect >= 1.5) then
			nextInspectRequest = 0
		else
			nextInspectRequest = 1.5 - timeSinceLastInspect
		end
		f:Show()
	end
end


--- Character Info Sheet ---
hooksecurefunc('PaperDollFrame_SetItemLevel', function(self, unit)
	if (unit ~= 'player') then return end

	local total, equip = GetAverageItemLevel()
	if (total > 0) then total = string.format('%.1f', total) end
	if (equip > 0) then equip = string.format('%.1f', equip) end

	local ilvl = equip
	if (equip < total) then
		ilvl = equip .. ' / ' .. total
	end

	local ilvlLine = _G[self:GetName() .. 'StatText']
	ilvlLine:SetText(ilvl)

	self.tooltip = detailColor .. STAT_AVERAGE_ITEM_LEVEL .. ' ' .. ilvl
end)


--- Handle Events ---
f:SetScript('OnEvent', function(self, event, ...)
	if (event == 'UNIT_INVENTORY_CHANGED') then
		local id = ...
		if (UnitGUID(id) == currentGUID) then
			ScanUnit(id, true)
		end
	elseif (event == 'INSPECT_READY') then
		local guid = ...
		if (guid ~= currentGUID) then return end

		local gear = UnitGear(currentID)
		GearDB[currentGUID] = gear

		local spec = UnitSpec(currentID)
		SpecDB[currentGUID] = spec

		if (not gear) or (not spec) then
			ScanUnit(currentID, true)
		else
			SetUnitInfo(gear, spec)
		end
	end
end)

f:SetScript('OnUpdate', function(self, elapsed)
	nextInspectRequest = nextInspectRequest - elapsed
	if (nextInspectRequest > 0) then return end

	self:Hide()

	if currentID and (UnitGUID(currentID) == currentGUID) then
		lastInspectRequest = GetTime()
		NotifyInspect(currentID)
	end
end)

GameTooltip:HookScript('OnTooltipSetUnit', function(self)
	local _, unit = self:GetUnit()

	if (not unit) or (not CanInspect(unit)) then return end
	if (UnitLevel(unit) > 0) and (UnitLevel(unit) < 10) then return end

	currentID, currentGUID = unit, UnitGUID(unit)
	ScanUnit(unit)
end)
