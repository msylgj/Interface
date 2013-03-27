local addon, ns = ...
local cfg = ns.cfg
local init = ns.init
local panel = CreateFrame("Frame", nil, UIParent)

if cfg.Mail == true then
    local Stat = CreateFrame("Frame")
    Stat:EnableMouse(false)

    local Text  = panel:CreateFontString(nil, "OVERLAY")
    Text:SetFont(unpack(cfg.Fonts))
    Text:SetPoint(unpack(cfg.MailPoint))
	Stat:SetAllPoints(Text)

	Stat:SetScript("OnUpdate", function()
		Text:SetText(cfg.ColorClass and (HasNewMail() and "|cff00FF00"..infoL["New"].."|r"..init.Colored..infoL["Mail"] or init.Colored..infoL["No Mail"].."|r") or HasNewMail() and "|cff00FF00"..infoL["New"].."|r"..infoL["Mail"] or infoL["No Mail"])
	end)
end