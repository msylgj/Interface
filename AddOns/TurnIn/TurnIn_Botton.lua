local GameTooltip = GameTooltip
local Ti_b = CreateFrame("Button", "Ti_bMacro", ObjectiveTrackerBlocksFrame.QuestHeader , "SecureActionButtonTemplate" , GameTooltip)--UIParent 
Ti_b:SetAttribute("*type*", "macro") 
Ti_b:SetAttribute("macrotext", "/ti toggle") 
Ti_b:SetWidth(28); 
Ti_b:SetHeight(28); 
Ti_b:SetPoint("Left",ObjectiveTrackerBlocksFrame.QuestHeader ,"Left",-22,-1);  
Ti_b:SetAlpha(1)
Ti_b:SetNormalTexture("Interface\\HelpFrame\\HelpIcon-ReportLag") 
Ti_b:SetPushedTexture("Interface\\HelpFrame\\HelpIcon-ReportLag") 
Ti_b:SetHighlightTexture("Interface\\HelpFrame\\HelpIcon-ReportLag")





