--[[

MissionHush

Created by Shadowmage - Stormrage EU

]]

--[[ Gather the locals! ]]
local fontpath = "Fonts\\FRIZQT__.TTF"
local F,C
local trigger = false
local missioncount = 0
local garry = CreateFrame("Button", "garry", UIParent)

--[[ Check is Aurora AddOn is loaded ]]
if IsAddOnLoaded("Aurora") then
	F, C = unpack(Aurora)
	fontpath = C.media["font"]
	garry:SetWidth(303) 
	garry:SetHeight(58) 
	F.CreateBD(garry)
else
	garry:SetWidth(317) 
	garry:SetHeight(82) 
	garry:CreateTexture("garrytex")
	garrytex:SetTexture("Interface/Garrison/GarrisonToast") 
	garrytex:SetTexCoord(0.001953125, 0.62109375, 0.33203125, 0.65234375)
	garrytex:SetAllPoints()
end

garry:SetFrameStrata("HIGH")
garry:SetPoint("CENTER", AlertFrame, 0, 55)
garry:Hide()

local garryfont = garry:CreateFontString()
garryfont:SetPoint("CENTER", 0, -5)
garryfont:SetSize(200, 60) -- 200 60
garryfont:SetFont(fontpath, 16, "OUTLINE")

local misshush = garry:CreateFontString()
misshush:SetPoint("CENTER", 0, 19)
misshush:SetSize(200,60)
misshush:SetFont(fontpath, 12, "OUTLINE")
misshush:SetText("|cffff8040 Mission Hush")


--[[ BLIZZARD CODE UIFrameFlash function to avoid taints ]]

local frameFlashManager = CreateFrame("FRAME");
local FLASHFRAMES = {};
local UIFrameFlashTimers = {};
local UIFrameFlashTimerRefCount = {};

-- Function to see if a frame is already flashing
local function UIFrameIsFlashing(frame)
    for index, value in pairs(FLASHFRAMES) do
        if ( value == frame ) then
            return 1;
        end
    end
    return nil;
end

-- Function to stop flashing
local function UIFrameFlashStop(frame)
    tDeleteItem(FLASHFRAMES, frame);
    frame:SetAlpha(1.0);
    frame.flashTimer = nil;
    if (frame.syncId) then
        UIFrameFlashTimerRefCount[frame.syncId] = UIFrameFlashTimerRefCount[frame.syncId]-1;
        if (UIFrameFlashTimerRefCount[frame.syncId] == 0) then
            UIFrameFlashTimers[frame.syncId] = nil;
            UIFrameFlashTimerRefCount[frame.syncId] = nil;
        end
        frame.syncId = nil;
    end
    if ( frame.showWhenDone ) then
        frame:Show();
    else
        frame:Hide();
    end
end

-- Called every frame to update flashing frames
local function UIFrameFlash_OnUpdate(self, elapsed)
    local frame;
    local index = #FLASHFRAMES;
     
    -- Update timers for all synced frames
    for syncId, timer in pairs(UIFrameFlashTimers) do
        UIFrameFlashTimers[syncId] = timer + elapsed;
    end
     
    while FLASHFRAMES[index] do
        frame = FLASHFRAMES[index];
        frame.flashTimer = frame.flashTimer + elapsed;
 
        if ( (frame.flashTimer > frame.flashDuration) and frame.flashDuration ~= -1 ) then
            UIFrameFlashStop(frame);
        else
            local flashTime = frame.flashTimer;
            local alpha;
             
            if (frame.syncId) then
                flashTime = UIFrameFlashTimers[frame.syncId];
            end
             
            flashTime = flashTime%(frame.fadeInTime+frame.fadeOutTime+(frame.flashInHoldTime or 0)+(frame.flashOutHoldTime or 0));
            if (flashTime < frame.fadeInTime) then
                alpha = flashTime/frame.fadeInTime;
            elseif (flashTime < frame.fadeInTime+(frame.flashInHoldTime or 0)) then
                alpha = 1;
            elseif (flashTime < frame.fadeInTime+(frame.flashInHoldTime or 0)+frame.fadeOutTime) then
                alpha = 1 - ((flashTime - frame.fadeInTime - (frame.flashInHoldTime or 0))/frame.fadeOutTime);
            else
                alpha = 0;
            end
             
            frame:SetAlpha(alpha);
            frame:Show();
        end
         
        -- Loop in reverse so that removing frames is safe
        index = index - 1;
    end
     
    if ( #FLASHFRAMES == 0 ) then
        self:SetScript("OnUpdate", nil);
    end
end

-- Function to start a frame flashing
local function UIFrameFlash(frame, fadeInTime, fadeOutTime, flashDuration, showWhenDone, flashInHoldTime, flashOutHoldTime, syncId)
    if ( frame ) then
        local index = 1;
        -- If frame is already set to flash then return
        while FLASHFRAMES[index] do
            if ( FLASHFRAMES[index] == frame ) then
                return;
            end
            index = index + 1;
        end

        if (syncId) then
            frame.syncId = syncId;
            if (UIFrameFlashTimers[syncId] == nil) then
                UIFrameFlashTimers[syncId] = 0;
                UIFrameFlashTimerRefCount[syncId] = 0;
            end
            UIFrameFlashTimerRefCount[syncId] = UIFrameFlashTimerRefCount[syncId]+1;
        else
            frame.syncId = nil;
        end
         
        -- Time it takes to fade in a flashing frame
        frame.fadeInTime = fadeInTime;
        -- Time it takes to fade out a flashing frame
        frame.fadeOutTime = fadeOutTime;
        -- How long to keep the frame flashing
        frame.flashDuration = flashDuration;
        -- Show the flashing frame when the fadeOutTime has passed
        frame.showWhenDone = showWhenDone;
        -- Internal timer
        frame.flashTimer = 0;
        -- How long to hold the faded in state
        frame.flashInHoldTime = flashInHoldTime;
        -- How long to hold the faded out state
        frame.flashOutHoldTime = flashOutHoldTime;
         
        tinsert(FLASHFRAMES, frame);
         
        frameFlashManager:SetScript("OnUpdate", UIFrameFlash_OnUpdate);
    end
end

garry:RegisterEvent("PLAYER_REGEN_DISABLED")
garry:RegisterEvent("PLAYER_REGEN_ENABLED")
garry:RegisterEvent("GARRISON_MISSION_FINISHED")
garry:RegisterEvent("GARRISON_BUILDING_ACTIVATABLE")

local function eventHandler(self, event, ...)

	if event == "PLAYER_REGEN_DISABLED" then
		AlertFrame:UnregisterEvent("GARRISON_MISSION_FINISHED")
		AlertFrame:UnregisterEvent("GARRISON_BUILDING_ACTIVATABLE")
		trigger = true
	end

	if event == "PLAYER_REGEN_ENABLED" then
		AlertFrame:RegisterEvent("GARRISON_MISSION_FINISHED")
		AlertFrame:RegisterEvent("GARRISON_BUILDING_ACTIVATABLE")
			if missioncount > 0 then
				garryfont:SetText(missioncount ..  " Mission(s) Complete")
				UIFrameFlash(garry, 0.2, 0.2, 3, false, 1.5, 1.5)
				PlaySound("UI_Garrison_Toast_MissionComplete");
			end
			trigger = false
			missioncount = 0		
	end
		
	if trigger == true then
		if event == "GARRISON_MISSION_FINISHED" or event == "GARRISON_BUILDING_ACTIVATABLE" then
			missioncount = missioncount + 1
		end
	end
		
end

garry:SetScript("OnEvent", eventHandler);
garry:SetScript("OnClick", function(self, button, down) garry:Hide() end)
