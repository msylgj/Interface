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

	local function Update(self, event, ...)
		Text:SetText((cfg.ColorClass and (HasNewMail() and "|cff00FF00"..infoL["New"].."|r"..init.Colored..infoL["Mail"] or init.Colored..infoL["No Mail"].."|r")) or (HasNewMail() and "|cff00FF00"..infoL["New"].."|r"..infoL["Mail"] or infoL["No Mail"]))
	end
	
	Stat:RegisterEvent("MAIL_SHOW")
	Stat:RegisterEvent("MAIL_INBOX_UPDATE")
	Stat:RegisterEvent("MAIL_CLOSED")
	Stat:SetScript("OnUpdate", Update)
	Stat:SetScript("OnEvent", Update)
end