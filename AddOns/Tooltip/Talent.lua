----------------------------------------------------------------------------------------
--	Target Talents(TipTacTalents by Aezay)
----------------------------------------------------------------------------------------
local _, ns = ...
local cfg = ns.config
-- main
if cfg.Talent then
local gtt = GameTooltip;

-- Constants
local TALENTS_PREFIX = SPECIALIZATION..":|cffffffff ";	-- MoP: Could be changed from TALENTS to SPECIALIZATION
local NO_TALENTS = "|cffB5B5B5"..NONE.."|r"
if GetLocale()=="zhCN" then
	LOADING = "载入中"
elseif GetLocale()=="zhTW" then
	LOADING = "載入中"
elseif GetLocale()=="enUS" then
	LOADING = "Loading"
end
local CACHE_SIZE = 25;		-- Change cache size here (Default 25)
local INSPECT_DELAY = 0.2;
local INSPECT_FREQ = 2;

-- Variables
local ttt = CreateFrame("Frame","TipTacTalents");
local cache = {};
local current = {};

-- Time of the last inspect reuqest. Init this to zero, just to make sure. This is a global so other addons could use this variable as well
lastInspectRequest = 0;

-- Allow these to be accessed externally from other addons
ttt.cache = cache;
ttt.current = current;

ttt:Hide();

-- Helper function to determine if an "Inspect Frame" is open. Native Inspect as well as Examiner is supported.
local function IsInspectFrameOpen() return (InspectFrame and InspectFrame:IsShown()) or (Examiner and Examiner:IsShown()); end

--------------------------------------------------------------------------------------------------------
--                                           Gather Talents                                           --
--------------------------------------------------------------------------------------------------------

local function GatherTalents(isInspect)
	-- MoP Note: Is it no longer possible to query the different talent spec groups anymore?
--	local group = GetActiveTalentGroup and GetActiveTalentGroup(isInspect) or 1;	-- Az: replaced with GetActiveSpecGroup(), but that does not support inspect?
	-- New MoP Code
--	local spec = GetInspectSpecialization(current.unit,nil,group);	-- Az: didn't seem like this func supported pet & talent group index; added it anyway, just in case
	local spec = isInspect and GetInspectSpecialization(current.unit) or GetSpecialization();
	if (spec) and (spec > 0) then
		local _, specName = GetSpecializationInfoByID(spec);
		--local _, specName = GetSpecializationInfoForClassID(spec,current.classID);
		current.format = specName or "N/A";
	else
		current.format = NO_TALENTS;
	end
	-- Set the tips line output, for inspect, only update if the tip is still showing a unit!
	if (not isInspect) then
	local sepc1 = GetSpecialization()
	if sepc1 == nil then
	gtt:AddLine(TALENTS_PREFIX..NO_TALENTS);
	else 
	local _, specName1 = GetSpecializationInfo(sepc1);
	gtt:AddLine(TALENTS_PREFIX.."|c000EEE00"..specName1.."|r");
	end
	elseif (gtt:GetUnit()) then
		for i = 2, gtt:NumLines() do
			if ((_G["GameTooltipTextLeft"..i]:GetText() or ""):match("^"..TALENTS_PREFIX)) then
				_G["GameTooltipTextLeft"..i]:SetFormattedText("%s%s",TALENTS_PREFIX,"|c000EEE00"..current.format.."|r");
				-- Do not call Show() if the tip is fading out, this only works with TipTac, if TipTacTalents are used alone, it might still bug the fadeout
				if (not gtt.fadeOut) then
					gtt:Show();
				end
				break;
			end
		end
	end
	-- Organise Cache
	local cacheSize = (TipTac_Config and TipTac_Config.talentCacheSize or CACHE_SIZE);
	for i = #cache, 1, -1 do
		if (current.name == cache[i].name) then
			tremove(cache,i);
			break;
		end
	end
	if (#cache > cacheSize) then
		tremove(cache,1);
	end
	-- Cache the new entry
	if (cacheSize > 0) then
		cache[#cache + 1] = CopyTable(current);
	end
end

--------------------------------------------------------------------------------------------------------
--                                           Event Handling                                           --
--------------------------------------------------------------------------------------------------------

-- OnEvent
ttt:SetScript("OnEvent",function(self,event,guid)
	self:UnregisterEvent(event);
	if (guid == current.guid) then
		GatherTalents(1);
	end
end);

-- OnUpdate
ttt:SetScript("OnUpdate",function(self,elapsed)
	self.nextUpdate = (self.nextUpdate - elapsed);
	if (self.nextUpdate <= 0) then
		self:Hide();
		-- Make sure the mouseover unit is still our unit
		-- Check IsInspectFrameOpen() again: Since if the user right-clicks a unit frame, and clicks inspect, it could cause TTT to schedule an inspect, while the inspection window is open
		if (UnitGUID("mouseover") == current.guid) and (not IsInspectFrameOpen()) then
			lastInspectRequest = GetTime();
			self:RegisterEvent("INSPECT_READY");
			NotifyInspect(current.unit);
		end
	end
end);

-- HOOK: OnTooltipSetUnit
gtt:HookScript("OnTooltipSetUnit",function(self,...)
	if (TipTac_Config) and (TipTac_Config.showTalents == false) then
		return;
	end
	-- Abort any delayed inspect in progress
	ttt:Hide();
	-- Get the unit -- Check the UnitFrame unit if this tip is from a concated unit, such as "targettarget".
	local _, unit = self:GetUnit();
	if (not unit) then
		local mFocus = GetMouseFocus();
		if (mFocus) and (mFocus.unit) then
			unit = mFocus.unit;
		end
	end
	-- No Unit or not a Player
	if (not unit) or (not UnitIsPlayer(unit)) then
		return;
	end
	-- Show only talents for people in your party/raid
	if (TipTac_Config and TipTac_Config.talentOnlyInParty and not UnitInParty(unit) and not UnitInRaid(unit)) then
		return;
	end
	-- Only bother for players over level 9
	local level = UnitLevel(unit);
	if (level > 9 or level == -1) then
		-- Wipe Current Record
		wipe(current);
		current.unit = unit;
		current.name = UnitName(unit);
		current.guid = UnitGUID(unit)
		-- Az: Is classID needed for MoP inspect?
--		local _, _, classID = UnitClass(unit);
--		current.classID = classID;
		-- No need for inspection on the player
		if (UnitIsUnit(unit,"player")) then
			GatherTalents();
			return;
		end
		-- Show Cached Talents, If Available
		local cacheLoaded = false;
		for _, entry in ipairs(cache) do
			if (current.name == entry.name) then
				self:AddLine(TALENTS_PREFIX.."|c000EEE00"..entry.format.."|r");
				current.format = entry.format;
				cacheLoaded = true;
				break;
			end
		end
		-- Queue an inspect request
		if (CanInspect(unit)) and (not IsInspectFrameOpen()) then
			local lastInspectTime = (GetTime() - lastInspectRequest);
			ttt.nextUpdate = (lastInspectTime > INSPECT_FREQ) and INSPECT_DELAY or (INSPECT_FREQ - lastInspectTime + INSPECT_DELAY);
			ttt:Show();
			if (not cacheLoaded) then
				self:AddLine(TALENTS_PREFIX..LOADING);
			end
		end
	end
end);
end