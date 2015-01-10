local ADDON, data = ...

local checkboxes = {}   -- Will contain {checkbox, variable} pairs. Used in the refresh function.


--[[
local L = setmetatable({}, { __index = function(t, k)
    local v = tostring(k)
    t[k] = v
    return v
end })

if GetLocale() == "deDE" then
    L["Miscellaneous:"] = "Verscheidene:"
    L["Use Garrison Resources"] = "Garnisonressourcen verwenden"
    L["If this option is checked, BulkOrder will automatically queue work orders even if they use garrison resources."] = "Wenn diese Option aktiviert ist, wird BulkOrder automatisch die Arbeitsaufträge einreihen, auch wenn sie Garnisonressourcen verwenden."
    L["While this add-on is installed, opening a work orders window will automatically queue up all available work orders."] = "Wenn dieses Addon aktiviert ist, wird alle verfügbare Arbeitsaufträge bei der Öffnung eines Arbeitsauftragfenster automatisch eingereiht werden."
    L["You can avoid the automatic work orders by holding LEFT SHIFT down while clicking on the work orders NPC."] = "Man kann die Automatisierung durch Drücken der Shift-Taste bei Interaktion mit dem Arbeitsauftrag-NPC verhindern."
    L["In addition, work orders that use garrison resources are by default not automatic, unless you enable the above option."] = "Arbeitsaufträge, die Garnisonressourcen verwenden, werden nicht automatisiert werden, außer wenn die obige Option aktiviert ist."

elseif GetLocale() == "esES" or GetLocale() == "esMX" then
    L["Miscellaneous:"] = "Misceláneo:"
    L["Use Garrison Resources"] = "Usar recursos de la ciudadela"
    L["If this option is checked, BulkOrder will automatically queue work orders even if they use garrison resources."] = "Si esta opción se activa, BulkOrder pondrá automaticamente los pedidos en cola, incluso si requieren recursos de la ciudadela."
    L["While this add-on is installed, opening a work orders window will automatically queue up all available work orders."] = "Si este addon se activa, todos los pedidos disponibles se pondrán en cola al abrir una ventana de pedidos."
    L["You can avoid the automatic work orders by holding LEFT SHIFT down while clicking on the work orders NPC."] = "Para evitar la automación de pedidos, presiona la tecla Mayús izquierda al hacer clic en el PNJ de pedidos."
    L["In addition, work orders that use garrison resources are by default not automatic, unless you enable the above option."] = "Además, los pedidos que requieren recursos de la ciudadela no están automatizados por defecto menos que se active la opción anterior."
end
--]]





-----------------------------------------------------------------

local function CreateCheckBox (parent, anchorTo, x, y, text)
    local frm = CreateFrame ("CheckButton", '', parent, "InterfaceOptionsCheckButtonTemplate")
    frm:SetPoint ("TOPLEFT", anchorTo, "BOTTOMLEFT", x, y)
    frm.Text:SetText (text)
    
    function frm:SetTooltip (title, text)
        self:SetScript("OnEnter", function(self, motion, ...)
            GameTooltip:SetOwner (self, "ANCHOR_TOPLEFT")
            GameTooltip:AddLine (title, 1, 1, 0)
            GameTooltip:AddLine (text, 1, 1, 1)
            GameTooltip:Show ()
        end)
        self:SetScript("OnLeave", function(self, motion, ...)
            GameTooltip:Hide ()
        end)
    end
    
    function frm:Bind (varname)
        self:SetScript ("OnClick", function (self, ...)
            g_BulkOrder[varname] = self:GetChecked ()
        end)
        table.insert (checkboxes, {frm, varname})
    end
    
    return frm
end

-----------------------------------------------------------------

function BulkOrder_CreateOptions ()
    -- Default values!
    g_BulkOrder = g_BulkOrder or {}
    if g_BulkOrder.ExcludeTradingPost==nil then 
        g_BulkOrder.ExcludeTradingPost = true 
    end
    if g_BulkOrder.ExcludeWarMill==nil then 
        g_BulkOrder.ExcludeWarMill = true 
    end

    -- GUI stuff!
    local Options = CreateFrame ("Frame", "BulkOrderOptions", UIParent);
    Options.name = "BulkOrder";
    Options:Hide ()
    InterfaceOptions_AddCategory (Options);
    
    Options.refresh = function ()
        for i,v in pairs(checkboxes) do
            v[1]:SetChecked (g_BulkOrder[v[2]])
        end
    end
    
    Options.CreateCheckBox = CreateCheckBox
    
    local txt = {
        '-启用本插件后, 打开订单窗口时会自动执行所有可用订单.',
        '-你可以在打开订单窗口时按住左Shift键来避免自动执行订单.',
        '-此外, 货栈或矮人地堡/战争磨坊默认不自动执行, 你可以修改这些设置.',
    }
    local sometext = Options:CreateFontString (nil, "ARTWORK", "GameFontHighlight")
    sometext:SetPoint ("TOPLEFT", 8, -40)
    sometext:SetText (string.join ('\n', unpack (txt)))
    sometext:SetWidth (500)
    sometext:SetJustifyH ("LEFT")
    Options.sometext = sometext
    
    -----------------------------------------------------------------
    
    local Title = Options:CreateFontString (nil, "ARTWORK", "GameFontNormalLarge")
    Title:SetPoint ("TOPLEFT", 8, -16)
    Title:SetText (Options.name)
    Options.Title = Title

    
    -- 排除建筑
    local TitleExclude = Options:CreateFontString (nil, "ARTWORK", "GameFontHighlight")
    TitleExclude:SetPoint ("TOPLEFT", 8, -130)
    TitleExclude:SetText ('这些建筑例外:')
    Options.TitleExclude = TitleExclude
    local y=-6
    
    Options.chkTradingPost = Options:CreateCheckBox (TitleExclude, 0, y, '货栈')
    Options.chkTradingPost:Bind ('ExcludeTradingPost', false, true)
    Options.chkTradingPost:SetTooltip ('排除货栈', '如果勾选此项,BulkOrder不会自动执行货栈的订单.')
    y=y-25
    
    Options.chkWarMill = Options:CreateCheckBox (TitleExclude, 0, y, '矮人地堡/战争磨坊')
    Options.chkWarMill:Bind ('ExcludeWarMill', false, true)
    Options.chkWarMill:SetTooltip ('矮人地堡/战争磨坊', '如果勾选此项,BulkOrder不会自动执行矮人地堡/战争磨坊的订单.')
    y=y-25
    
    Options.chkEverything = Options:CreateCheckBox (TitleExclude, 0, y, '所有建筑!')
    Options.chkEverything:Bind ('ExcludeEverything', false, true)
    Options.chkEverything:SetTooltip ('排除所有建筑!', '如果勾选此项,BulkOrder永远不会自动执行任何建筑的订单.\n你需要总是手动点击执行所有订单按钮.')
    y=y-25
    
    
    -- 杂项
    local TitleMisc = Options:CreateFontString (nil, "ARTWORK", "GameFontHighlight")
    TitleMisc:SetPoint ("TOPLEFT", 8, -240)
    TitleMisc:SetText ('杂项:')
    Options.TitleMisc = TitleMisc
    local y=-6
    
    Options.chkHideButton = Options:CreateCheckBox (TitleMisc, 0, y, '隐藏按钮')
    Options.chkHideButton:Bind ('HideButton', false, true)
    Options.chkHideButton:SetTooltip ('隐藏按钮', '如果勾选此项,订单界面不会显示额外的执行所有订单按钮.')
    y=y-25
    
    
    
    

end

