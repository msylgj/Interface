-----------------------------
-- INIT
-----------------------------
 --get the addon namespace
local addon, ns = ...
local gcfg = ns.cfg
--get some values from the namespace
local cfg = gcfg.bars.leave_vehicle
local dragFrameList = ns.dragFrameList

-----------------------------
-- FUNCTIONS
-----------------------------

if not cfg.enable then return end

local num = 1
local buttonList = {}

--create the frame to hold the buttons
local frame = CreateFrame("Frame", "rABS_LeaveVehicle", UIParent)
frame:SetWidth(num*cfg.buttons.size + (num-1)*cfg.buttons.margin + 2*cfg.padding)
frame:SetHeight(cfg.buttons.size + 2*cfg.padding)
frame:SetPoint(cfg.pos.a1,cfg.pos.af,cfg.pos.a2,cfg.pos.x,cfg.pos.y)
frame:SetScale(cfg.scale)

--the button
local button = CreateFrame("BUTTON", "rABS_LeaveVehicleButton", frame);
table.insert(buttonList, button) --add the button object to the list
button:SetSize(cfg.buttons.size, cfg.buttons.size)
button:SetPoint("BOTTOMLEFT", frame, cfg.padding, cfg.padding)
button:RegisterForClicks("AnyUp")
button:SetNormalTexture("INTERFACE\\PLAYERACTIONBARALT\\NATURAL")
button:SetPushedTexture("INTERFACE\\PLAYERACTIONBARALT\\NATURAL")
button:SetHighlightTexture("INTERFACE\\PLAYERACTIONBARALT\\NATURAL")
local nt = button:GetNormalTexture()
local pu = button:GetPushedTexture()
local hi = button:GetHighlightTexture()
nt:SetTexCoord(0.0859375,0.1679688,0.359375,0.4414063)
pu:SetTexCoord(0.001953125,0.08398438,0.359375,0.4414063)
hi:SetTexCoord(0.6152344,0.6972656,0.359375,0.4414063)
hi:SetBlendMode("ADD")

hooksecurefunc("MainMenuBarVehicleLeaveButton_Update", function()
	if CanExitVehicle() then
		if UnitOnTaxi("player") then
			button:SetScript("OnClick", function(self)
				TaxiRequestEarlyLanding()
				self:LockHighlight()
			end)
		else
			button:SetScript("OnClick", function(self)
				VehicleExit()
			end)
		end
		button:Show()
		frame:Show()
	else
		button:Hide()
		frame:Hide()
	end
end)

--set tooltip
button:SetScript("OnEnter", function(self)
	if ( UnitOnTaxi("player") ) then
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
		GameTooltip:SetText(TAXI_CANCEL, 1, 1, 1);
		GameTooltip:AddLine(TAXI_CANCEL_DESCRIPTION, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, true);
		GameTooltip:Show();
	else
		GameTooltip_AddNewbieTip(self, LEAVE_VEHICLE, 1.0, 1.0, 1.0, nil);
	end
end)
button:SetScript("OnLeave", function() GameTooltip:Hide() end)

--create drag frame and drag functionality
if cfg.userplaced.enable then
  rCreateDragFrame(frame, dragFrameList, -2 , true) --frame, dragFrameList, inset, clamp
end

--create the mouseover functionality
if cfg.mouseover.enable then
  rButtonBarFader(frame, buttonList, cfg.mouseover.fadeIn, cfg.mouseover.fadeOut) --frame, buttonList, fadeIn, fadeOut
end