    local vmheight = 450
    local vmwidth = 200
	local vm = ObjectiveTrackerFrame
	--移动框体
    vm:SetClampedToScreen(true)
    vm:ClearAllPoints()
    vm.ClearAllPoints = function() end
    vm:SetPoint("TOPRIGHT", MinimapCluster, "BOTTOM", 45, -5) 
    vm.SetPoint = function() end
    vm:SetMovable(true)
    vm:SetUserPlaced(true)
    vm:SetHeight(vmheight)
    vm:SetWidth(vmwidth)
    
    local vmmove = CreateFrame("FRAME", nil, vm)  
    vmmove:SetHeight(16)
    vmmove:SetPoint("TOPLEFT", vm, 0, 0)
    vmmove:SetPoint("TOPRIGHT", vm)
    vmmove:EnableMouse(true)
    vmmove:RegisterForDrag("LeftButton")
    vmmove:SetHitRectInsets(-5, -5, -5, -5)
       vmmove:SetScript("OnDragStart", function(self, button)
    	if  button=="LeftButton" then
        	local f = self:GetParent()
        	f:StartMoving()
        end
    end)
    
    vmmove:SetScript("OnDragStop", function(self, button)
        local f = self:GetParent()
        f:StopMovingOrSizing()
    end)
    




	
	-- 任务物品放左面 -------------------------------------------------------------------

    local function moveQuestObjectiveItems(self)
	    local a = {self:GetPoint()}
	        
	    self:ClearAllPoints()
		self:SetPoint("TOPRIGHT", a[2], "TOPLEFT", -25, -6)
		self:SetFrameLevel(0)
	end
	
	local qitime = 0
	local qiinterval = 1
	
    hooksecurefunc("QuestObjectiveItem_OnUpdate", function(self, elapsed)
    	qitime = qitime + elapsed
    	
    	if qitime > qiinterval then
        	moveQuestObjectiveItems(self)
        	qitime = 0
        end
    end)


-- 标题样式 -------------------------------------------------------
    if IsAddOnLoaded("Blizzard_ObjectiveTracker") then
        hooksecurefunc("ObjectiveTracker_Update", function(reason, id)
            if vm.MODULES then  
                for i = 1, #vm.MODULES do                               
		            vm.MODULES[i].Header.Background:SetAtlas(nil)
		            vm.MODULES[i].Header.Text:SetFont(STANDARD_TEXT_FONT, 16,"OUTLINE")
		            vm.MODULES[i].Header.Text:ClearAllPoints()
		            vm.MODULES[i].Header.Text:SetPoint("Left", vm.MODULES[i].Header, 10, 0)
		            vm.MODULES[i].Header.Text:SetJustifyH("Left")
	            end
	        end
	    end)
	end
	

-- 任务追踪自动开启/关闭 --------------------------------------------

    local vmboss = CreateFrame("Frame", nil)
    vmboss:RegisterEvent("PLAYER_ENTERING_WORLD")
    vmboss:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT")
    vmboss:RegisterEvent("UNIT_TARGETABLE_CHANGED")
    vmboss:RegisterEvent("PLAYER_REGEN_ENABLED")
    vmboss:RegisterEvent("UPDATE_WORLD_STATES")

    local function bossexists()
	    for i = 1, MAX_BOSS_FRAMES do
		    if UnitExists("boss"..i) then
			    return true
		    end
	    end
    end

    vmboss:SetScript("OnEvent", function(self, event)
        local _, instanceType = IsInInstance()
        local bar = _G["WorldStateCaptureBar1"]
        local mapcheck = GetMapInfo(mapFileName)
        
        -- boss战自动关闭
	    if bossexists() then
		    if not vm.collapsed then
			    ObjectiveTracker_Collapse()
		    end
		-- PVP自动关闭
	    elseif instanceType=="arena" or instanceType=="pvp" then
            if not vm.collapsed then
			    ObjectiveTracker_Collapse()
		    end
		-- 获得追踪栏关闭
		elseif bar and bar:IsVisible() then
		    if not vm.collapsed then
			    ObjectiveTracker_Collapse()
		    end
		-- 团队副本且不在战斗状态打开
	    elseif vm.collapsed and instanceType=="raid" and not InCombatLockdown() then
		    ObjectiveTracker_Expand()
		-- 在阿什兰且不在战斗中打开
		elseif vm.collapsed and mapcheck=="Ashran" and not InCombatLockdown() then
		    ObjectiveTracker_Expand()
	    end
    end)
    
-- 任务追踪名称职业着色 -------------------------------------------------------
    local r, g, b = 103/255, 103/255, 103/255
    local class = select(2, UnitClass("player"))
	local colour = CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[class] or RAID_CLASS_COLORS[class]

    hooksecurefunc(QUEST_TRACKER_MODULE, "SetBlockHeader", function(_, block)
			block.HeaderText:SetFont(STANDARD_TEXT_FONT, 14,"OUTLINE")
	        block.HeaderText:SetShadowOffset(.7, -.7)
            block.HeaderText:SetShadowColor(0, 0, 0, 1)
            block.HeaderText:SetTextColor(colour.r, colour.g, colour.b)
            block.HeaderText:SetJustifyH("Left")
            block.HeaderText:SetWidth(vmwidth)
	local heightcheck = block.HeaderText:GetNumLines()      
            if heightcheck==2 then
                local height = block:GetHeight()     
                block:SetHeight(height + 2)
            end
    end)
    
    local function hoverquest(_, block)
	        block.HeaderText:SetTextColor(colour.r, colour.g, colour.b)
    end
    hooksecurefunc(QUEST_TRACKER_MODULE, "OnBlockHeaderEnter", hoverquest)  
    hooksecurefunc(QUEST_TRACKER_MODULE, "OnBlockHeaderLeave", hoverquest)
  

    hooksecurefunc(ACHIEVEMENT_TRACKER_MODULE, "SetBlockHeader", function(_, block)
        local trackedAchievements = {GetTrackedAchievements()}
        
        for i = 1, #trackedAchievements do
		    local achieveID = trackedAchievements[i]
		    local _, achievementName, _, completed, _, _, _, description, _, icon, _, _, wasEarnedByMe = GetAchievementInfo(achieveID)
	        local showAchievement = true
	        
		    if wasEarnedByMe then
			    showAchievement = false
		    elseif displayOnlyArena then
			    if GetAchievementCategory(achieveID)~=ARENA_CATEGORY then
				    showAchievement = false
			    end
		    end
		    
            if showAchievement then
	            block.HeaderText:SetFont(STANDARD_TEXT_FONT, 14,"OUTLINE")
	            block.HeaderText:SetShadowOffset(.7, -.7)
                block.HeaderText:SetShadowColor(0, 0, 0, 1)
                block.HeaderText:SetTextColor(colour.r, colour.g, colour.b)
                block.HeaderText:SetJustifyH("Left")
                block.HeaderText:SetWidth(vmwidth)
            end
        end
    end)
      
    local function hoverachieve(_, block)
	        block.HeaderText:SetTextColor(colour.r, colour.g, colour.b)
        end
      
    hooksecurefunc(ACHIEVEMENT_TRACKER_MODULE, "OnBlockHeaderEnter", hoverachieve)
    hooksecurefunc(ACHIEVEMENT_TRACKER_MODULE, "OnBlockHeaderLeave", hoverachieve)

     
--------------------------------------------------------------------------------------------------------
--                                    显示任务等级                                      --
--------------------------------------------------------------------------------------------------------
local QuestLevelPatch = {}

-- 追踪栏显示任务等级
function SetBlockHeader_hook()
	for i = 1, GetNumQuestWatches() do
		local questID, title, questLogIndex, numObjectives, requiredMoney, isComplete, startEvent, isAutoComplete, failureTime, timeElapsed, questType, isTask, isStory, isOnMap, hasLocalPOI = GetQuestWatchInfo(i)
		if ( not questID ) then
			break
		end
		local oldBlock = QUEST_TRACKER_MODULE:GetExistingBlock(questID)
		if oldBlock then
			local oldHeight = QUEST_TRACKER_MODULE:SetStringText(oldBlock.HeaderText, title, nil, OBJECTIVE_TRACKER_COLOR["Header"])
			local newTitle = "["..select(2, GetQuestLogTitle(questLogIndex)).."] "..title
			local newHeight = QUEST_TRACKER_MODULE:SetStringText(oldBlock.HeaderText, newTitle, nil, OBJECTIVE_TRACKER_COLOR["Header"])

		end
	end
end
hooksecurefunc(QUEST_TRACKER_MODULE, "Update", SetBlockHeader_hook)



-- 任务详细信息显示任务等级
function QuestInfo_hook(template, parentFrame, acceptButton, material, mapView)
	local elementsTable = template.elements
	for i = 1, #elementsTable, 3 do
		if elementsTable[i] == QuestInfo_ShowTitle then
			if QuestInfoFrame.questLog then
				local questLogIndex = GetQuestLogSelection()
				local level = select(2, GetQuestLogTitle(questLogIndex))
				local newTitle = "["..level.."] "..QuestInfoTitleHeader:GetText()
				QuestInfoTitleHeader:SetText(newTitle)
			end
		end
	end
end
hooksecurefunc("QuestInfo_Display", QuestInfo_hook)
