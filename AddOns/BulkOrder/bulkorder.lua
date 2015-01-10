local THIS_ADDON, data = ...
BulkOrder_data = data

g_BulkOrder = g_BulkOrder or {}

local GARRISON_RESOURCES = 824

local WARMILL = 1
local TRADINGPOST = 2

local BUILDINGS = {
    [8] = WARMILL,
    [9] = WARMILL,
    [10] = WARMILL,
    [111] = TRADINGPOST,
    [144] = TRADINGPOST,
    [145] = TRADINGPOST,
}
-----------------------------------------------------------------

local RED = 'FF0000'
local GREEN = '00FF00'
local function colortext (color, str)
    return '|cFF'..color..str..'|r' 
end

-----------------------------------------------------------------

local function GetUnitID (unit)
    return UnitGUID (unit):match ('([^%-]+)-[^%-]+$')
end

-----------------------------------------------------------------

local THROTTLE = 0.2

function StartAllWorkOrders ()
    frmBulkOrder.elapsed = 0
    frmBulkOrder:SetScript ("OnUpdate", function (self, elapsed)
        self.elapsed = self.elapsed + elapsed
        if self.elapsed > THROTTLE then
            self.elapsed = 0
            C_Garrison.RequestShipmentCreation ()
            if self.maxShipments == C_Garrison.GetNumPendingShipments () then
                self:SetScript ("OnUpdate", nil)
            end
        end
    end)
end

-----------------------------------------------------------------

local f = CreateFrame ("Frame", 'frmBulkOrder', UIParent)

--[[function f:EnableAutoOrders ()
    g_BulkOrder.autoOrders = true
    if self.windowIsOpen then
        StartAllWorkOrders ()
    end
end

function f:DisableAutoOrders ()
    g_BulkOrder.autoOrders = false
    self:SetScript ("OnUpdate", nil)
end

function f:ReportAutoOrders ()
    local msg = colortext ('CCCCCC','[BulkOrder]:') .. ' Automatic work orders are %s!'
    
    if g_BulkOrder.autoOrders then
        print (msg:format (colortext (GREEN, 'ON')))
    else
        print (msg:format (colortext (RED, 'OFF')))
    end
end]]

f:RegisterEvent ("SHIPMENT_CRAFTER_INFO")
--f:RegisterEvent ("SHIPMENT_UPDATE")
f:RegisterEvent ("SHIPMENT_CRAFTER_OPENED")
f:RegisterEvent ("SHIPMENT_CRAFTER_CLOSED")
f:RegisterEvent ("ADDON_LOADED")

-- Event handlers
function f:SHIPMENT_CRAFTER_OPENED (containerID)
    --self.windowIsOpen = true
    self:SetScript ("OnUpdate", nil)    -- Really stupid game bug...
    
    if not GarrisonCapacitiveDisplayFrame.StartAllWorkOrdersButton then
        local btn = CreateFrame ("Button", nil, GarrisonCapacitiveDisplayFrame, "UIPanelButtonTemplate")
        GarrisonCapacitiveDisplayFrame.StartAllWorkOrdersButton = btn
        btn:SetPoint ("BOTTOM", GarrisonCapacitiveDisplayFrame.StartWorkOrderButton, "TOP", 0, 2)
        btn:SetSize (GarrisonCapacitiveDisplayFrame.StartWorkOrderButton:GetSize ())
        btn:SetEnabled (GarrisonCapacitiveDisplayFrame.StartWorkOrderButton:IsEnabled ())
        btn:SetText ('执行所有订单')
        btn:SetScript ("OnClick", StartAllWorkOrders)
    end
    
    if IsLeftShiftKeyDown () then
        self.dontStart = true
    end
end

function f:SHIPMENT_CRAFTER_CLOSED ()
    --self.windowIsOpen = false
    self:SetScript ("OnUpdate", nil)
    self.dontStart = false
end

function f:ADDON_LOADED (name)
    if name==THIS_ADDON then
        BulkOrder_CreateOptions ()
    end
end

function f:SHIPMENT_CRAFTER_INFO (success, _, maxShipments, plotID) 
    GarrisonCapacitiveDisplayFrame.StartAllWorkOrdersButton:SetShown (not g_BulkOrder.HideButton)
    
    -- The normal button's enabled state can tell us whether the player has the resources for more work orders. Let's use that.
    local enabled = GarrisonCapacitiveDisplayFrame.StartWorkOrderButton:IsEnabled ()
    GarrisonCapacitiveDisplayFrame.StartAllWorkOrdersButton:SetEnabled (enabled)
    if not enabled then
        self:SetScript ("OnUpdate", nil)
        return
    end
    
    --local currencyID = C_Garrison.GetShipmentReagentCurrencyInfo ()   -- (currencyID~=GARRISON_RESOURCES or g_BulkOrder.UseGarrisonResources)
    self.maxShipments = maxShipments
    
    if g_BulkOrder.ExcludeEverything then
        return
    end
    
    buildingID = C_Garrison.GetOwnedBuildingInfo (plotID)
    local excluded = (g_BulkOrder.ExcludeTradingPost and BUILDINGS[buildingID]==TRADINGPOST) or (g_BulkOrder.ExcludeWarMill and BUILDINGS[buildingID]==WARMILL)
    
    if (not self.dontStart) and (not excluded) and (self:GetScript ("OnUpdate")==nil) then
        StartAllWorkOrders ()
    end
end

--function f:SHIPMENT_UPDATE (shipmentStarted) end

f:SetScript ("OnEvent", function (self, event, ...)
    if self[event] then
        self[event] (self, ...)
    end
end)


-----------------------------------------------------------------

--for k,v in pairs(C_Garrison) do if k:match('Shipment') then print(k) end end