if select(2, UnitClass("player")) ~= "MAGE" then return end

-- config
local cfg = {
	["point"] = {"LEFT", UIParent, "CENTER", 64, 35},
	["font"] = "Fonts\\ARKai_T.ttf",
	["fontsize"] = 24,
	["fontflag"] = "THINOUTLINE",
	["threshold"] = 100,
}

local IgniteDamage = CreateFrame("Frame", "IgniteDamage", UIParent)
IgniteDamage:SetPoint(unpack(cfg.point))
IgniteDamage:SetSize(cfg.fontsize, cfg.fontsize)
IgniteDamage:RegisterEvent("PLAYER_ENTERING_WORLD")
IgniteDamage:Hide()

local function CombustionReady()
	IgniteDamage.text:SetVertexColor(1, 1, 0)
	IgniteDamage:SetScript("OnUpdate", nil)
end

IgniteDamage:SetScript("OnEvent", function(self, event, ...)
	if event == "PLAYER_ENTERING_WORLD" then
		self:UnregisterEvent("PLAYER_ENTERING_WORLD")
		self:RegisterEvent("PLAYER_REGEN_ENABLED")
		self:RegisterEvent("PLAYER_REGEN_DISABLED")
		self.text = self:CreateFontString(nil, "OVERLAY")
		self.text:SetFont(cfg.font, cfg.fontsize, cfg.fontflag)
		self.text:SetPoint("LEFT")
		self.text:SetVertexColor(1, 1, 0)
		self.text:SetText("")
	elseif event == "PLAYER_REGEN_ENABLED" and GetSpecialization() == 2 then
		self:UnregisterEvent("UNIT_AURA")
		self:UnregisterEvent("UNIT_SPELLCAST_SUCCEEDED")
		self:Hide()
	elseif event == "PLAYER_REGEN_DISABLED" and GetSpecialization() == 2 then
		self:RegisterEvent("UNIT_AURA")
		self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
		self:Show()
	elseif event == "UNIT_AURA" then
		local unitID = ...
		if unitID == "target" then
			if UnitDebuff("target", GetSpellInfo(12654), nil, "PLAYER") then
				local damage = select(15, UnitDebuff("target", GetSpellInfo(12654), nil, "PLAYER"))
				if damage and damage > cfg.threshold then
					self.text:SetText(format("%d", damage))
				else
					self.text:SetText("")
				end
			elseif self.text:GetText() ~= "" then
				self.text:SetText("")
			end
		end
	elseif event == "UNIT_SPELLCAST_SUCCEEDED" then
		local unitID, _, _, _, spellID = ...
		if unitID == "player" and spellID == 11129 then
			self.text:SetVertexColor(1, 0, 0)
			self.timer = 1.0
			self:SetScript("OnUpdate", function(self, elapsed)
				self.timer = self.timer - elapsed
				if self.timer < 0 then
					local start, expires = GetSpellCooldown(11129)
					if start < 0.01 then
						CombustionReady()
					else
						self.timer = start + expires - GetTime() + 0.01
					end
				end
			end)
		end
	end
end)