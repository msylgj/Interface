local loadf = CreateFrame("frame", "aLoadFrame", UIParent)
loadf:SetWidth(400)
loadf:SetHeight(600)
loadf:SetPoint("CENTER")
loadf:EnableMouse(true)
loadf:SetMovable(true)
loadf:SetUserPlaced(true)
loadf:SetClampedToScreen(true)
loadf:SetScript("OnMouseDown", function(self) self:StartMoving() end)
loadf:SetScript("OnMouseUp", function(self) self:StopMovingOrSizing() end)
loadf:SetFrameStrata("DIALOG")
tinsert(UISpecialFrames, "aLoadFrame")

local stylef = function(f)
	f:SetBackdrop({
			bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
			edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
			tileSize = 16,
			edgeSize = 16,
			insets = {left=3, right=3, top=3, bottom=3},
		})
	f:SetBackdropColor(.01, .01, .01, .85)
	f:SetBackdropBorderColor(.4, .4, .4, 1)
end


local NewButton = function(text,parent)
	local result = CreateFrame("Button", "btn_"..parent:GetName(), parent, "UIPanelButtonTemplate")
	result:SetText(text)
	return result
end

stylef(loadf)
loadf:Hide()
loadf:SetScript("OnHide", function(self) ShowUIPanel(GameMenuFrame) end)
--print("|cffff0000ALoad:|r use /al or /aload commands for show the addon window, or see game menu")

loadf:SetResizable(true)
local resize = CreateFrame("button", "resizebut", loadf)
loadf:SetMinResize(200, 400)
loadf:SetMaxResize(800, 800)
resize:SetPoint("BOTTOMRIGHT", loadf, "BOTTOMRIGHT", -6, 6)
resize:SetWidth(16)
resize:SetHeight(16)
resize:SetNormalTexture("Interface\\CHATFRAME\\UI-ChatIM-SizeGrabber-Up")
resize:SetHighlightTexture("Interface\\CHATFRAME\\UI-ChatIM-SizeGrabber-Highlight")
resize:SetPushedTexture("Interface\\CHATFRAME\\UI-ChatIM-SizeGrabber-Down")

resize:SetScript("OnMouseDown", function(self)   
   loadf:StartSizing()
end)

resize:SetScript("OnMouseUp", function(self)
   loadf:StopMovingOrSizing()
end)

local title = loadf:CreateFontString(nil, "OVERLAY", "GameFontNormal")
title:SetPoint("TOPLEFT", 10, -10)
title:SetText("ALoad")

local scrollf = CreateFrame("ScrollFrame", "aload_Scroll", loadf, "UIPanelScrollFrameTemplate")
local mainf = CreateFrame("frame", "aloadmainf", scrollf)

scrollf:SetPoint("TOPLEFT", loadf, "TOPLEFT", 10, -30)
scrollf:SetPoint("BOTTOMRIGHT", loadf, "BOTTOMRIGHT", -28, 40)
scrollf:SetScrollChild(mainf)

local reloadb = NewButton("重載插件", loadf)
reloadb:SetWidth(150)
reloadb:SetHeight(22)
reloadb:SetPoint("BOTTOM", 0, 10)
reloadb:SetScript("OnClick", function() ReloadUI() end)

local closeb = CreateFrame("button", "ALoadCloseButton", loadf, "UIPanelCloseButton")
closeb:SetPoint("TOPRIGHT")
closeb:SetScript("OnClick", function()
	loadf:Hide()
	--print("|cffff0000ALoad:|r use /al or /aload commands for show the addon window, or see game menu")
end)

local makeList = function()
	local self = mainf
	stylef(scrollf)
   self:SetPoint("TOPLEFT")
   self:SetWidth(scrollf:GetWidth())
   self:SetHeight(scrollf:GetHeight())
	self.addons = {}
	for i=1, GetNumAddOns() do
		self.addons[i] = select(1, GetAddOnInfo(i))
	end
	table.sort(self.addons)

	local oldb

	for i,v in pairs(self.addons) do
		local name, title, notes, enabled, loadable, reason, security = GetAddOnInfo(v)

		if name then
			local bf = _G[v.."_cbf"] or CreateFrame("CheckButton", v.."_cbf", self, "OptionsCheckButtonTemplate")
			bf:EnableMouse(true)
			bf.title = title.."|n"
			if notes then bf.title = bf.title.."|cffffffff"..notes.."|r|n" end
			if (GetAddOnDependencies(v)) then
				bf.title ="|cffff4400Dependencies: "
				for i=1, select("#", GetAddOnDependencies(v)) do
					bf.title = bf.title..select(i,GetAddOnDependencies(v))
					if (i>1) then bf.title=bf.title..", " end
				end
				bf.title = bf.title.."|r"
			end
				
			if i==1 then
				bf:SetPoint("TOPLEFT",self, "TOPLEFT", 10, -10)
			else
				bf:SetPoint("TOP", oldb, "BOTTOM", 0, 2)
			end
			
			bf:SetBackdrop({ bgFile = "Interface\\Buttons\\WHITE8x8", })
			bf:SetBackdropColor(0,0,0,0)
	
			bf:SetScript("OnEnter", function(self)
				GameTooltip:ClearLines()
				GameTooltip:SetOwner(self, ANCHOR_TOPRIGHT)
				GameTooltip:AddLine(self.title)
				GameTooltip:Show()
			end)
			
			bf:SetScript("OnLeave", function(self)
				GameTooltip:Hide()
			end)
			
			bf:SetScript("OnClick", function()
				local _, _, _, enabled = GetAddOnInfo(name)
				if enabled then
					DisableAddOn(name)
				else
					EnableAddOn(name)
				end
			end)
			bf:SetChecked(enabled)
			
			_G[v.."_cbfText"]:SetText(title) 

			oldb = bf
		end
	end
end

makeList()

-- slash command
SLASH_ALOAD1 = "/aload"
SLASH_ALOAD2 = "/al"
SlashCmdList["ALOAD"] = function (msg)
   loadf:Show()
end

--localize the game menu buttons
local menu = _G.GameMenuFrame
local macros = _G.GameMenuButtonMacros
local ratings = _G.GameMenuButtonRatings
local logout = _G.GameMenuButtonLogout

local showb = CreateFrame("button", "GameMenuButtonAddonManager", GameMenuFrame, "GameMenuButtonTemplate")
showb:SetText("插件管理")

if Aurora then
	local F, C = unpack(Aurora)
	F.Reskin(showb)
end
showb:SetPoint("TOP", "GameMenuButtonStore", "BOTTOM", 0, -1)
GameMenuButtonOptions:ClearAllPoints()
GameMenuButtonOptions:SetPoint('TOP', showb, 'BOTTOM', 0, -1)
GameMenuButtonOptions.SetPoint = function() end

GameMenuButtonContinue:ClearAllPoints()
GameMenuButtonContinue:SetPoint('TOP', GameMenuButtonQuit, 'BOTTOM', 0, -10)

showb:SetScript("OnClick", function()
	PlaySound("igMainMenuOption")
	HideUIPanel(GameMenuFrame)
	loadf:Show()
end)