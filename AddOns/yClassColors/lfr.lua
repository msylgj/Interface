
local _, ns = ...
local ycc = ns.ycc

hooksecurefunc('LFRBrowseFrameListButton_SetData', function(button, index)
    local name, level, areaName, className, comment, partyMembers, status, class, encountersTotal, encountersComplete, isLeader, isTank, isHealer, isDamage = SearchLFGGetResults(index)

    if(index and class and name and level and (name~=ycc.myName)) then
        button.name:SetText(ycc.classColor[class] .. name)
        button.class:SetText(ycc.classColor[class] .. className)
        button.level:SetText(ycc.diffColor[level] .. level)
    end
end)


