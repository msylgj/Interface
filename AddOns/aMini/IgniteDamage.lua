--[[
引用自NGA用户24kobebest08的帖子http://bbs.nga.cn/read.php?tid=8200126
前面数字是当前目标每跳点燃值，乘号后面是点燃剩余时间
绿：点燃值小于你接下来一发火冲带来的点燃。也就是说点燃值会很容易地通过你紧接着的火球/炎爆/火冲而增加。
黄：点燃值小于你接下来一发不爆击的炎爆带来的点燃。也就是说点燃值会通过你紧接着炎爆而增加。
橙：点燃值小于你接下来一发平均的炎爆带来的点燃。也就是说点燃值只会通过你紧接着爆击炎爆而增加。
红：点燃值小于你接下来一发爆击的炎爆带来的点燃。当你与目标距离非常近，你的这发炎爆爆击还运气不错溅射了，而且命中刷新点燃前只跳出了1跳点燃。那么点燃值才有机会增加。这种情况通常是要在饰品触发下出现。(我个人打了十分钟木桩的经验，单目标下几乎不可能见到红色)
紫：点燃值大于你接下来一发爆击的炎爆带来的点燃。只有当你之前施放了一次流星，它接下来命中目标且爆击。那么点燃值才有机会增加。除非使用超级燃烧，不然是几乎不可能达到紫色。当你看到数字变紫后应尽快燃烧并传染。
此外，Komma强调了颜色的区分只是为了帮助玩家判断自己接下来的操作会使点燃发生的变化。并不存在“到某种颜色适合出手燃烧”的说法。
]]--
--config
local font = {STANDARD_TEXT_FONT, 24, "THINOUTLINE"}
local point = {"CENTER", UIParent, "CENTER", 0, -100}
local size = {200, 30}
--config end

local frame = CreateFrame("Frame", "IgniteDamage", UIParent)
frame:SetSize(unpack(size))
frame:SetPoint(unpack(point))
frame:Hide()

local fstring = frame:CreateFontString(nil, "OVERLAY")
fstring:SetFont(unpack(font))
fstring:SetShadowColor(0, 0, 0, 1)
fstring:SetShadowOffset(0.5, -0.5)
fstring:SetText("")
fstring:SetAllPoints(frame)
frame.fstring = fstring

local OnUpdate = function(self, elapsed)
	self.elapsed = self.elapsed + elapsed
	if self.elapsed>=0.1 then
		local ignite_tick = select(15, UnitAura("target", GetSpellInfo(12654), nil, "HARMFUL"));
		local ignite_expiry = select(7, UnitAura("target", GetSpellInfo(12654), nil, "HARMFUL"));
		if ignite_tick == nil then
			frame:Hide()
		else
			local ignite_remains = string.format("%.1f", ignite_expiry - GetTime());
			local ignite = ignite_tick.." x "..ignite_remains

			-- Stats
			local spell_power = GetSpellBonusDamage( 3 )
			local crit = min( (GetSpellCritChance(3) - 3) * 1.3, 100 )
			local mastery = GetMasteryEffect()
			local versatility = GetCombatRatingBonus( CR_VERSATILITY_DAMAGE_DONE )
			local multistrike = GetMultistrikeEffect()

			-- Spellpower coefficients
			local pyro_coeff = 2.423
			local ib_coeff = 1.018

			-- Crit damage bonus
			local crit_damage = 2.0

			-- Proc buffs
			local pyro_proc = 0.25

			-- Talent multipliers
			local multiplier = 1.0
			if UnitAura("player", GetSpellInfo(116014)) then
				multiplier = multiplier * 1.15
			elseif UnitAura("player", GetSpellInfo(116267)) then
				multiplier = multiplier * 1.12
			end
			-- or (UnitFullName("target") == "Prismatic Crystal")
			if (UnitFullName("target") == "幻灵晶体") and UnitCanAttack("player", "target") then
				multiplier = multiplier * 1.3
			end

			local pyro_ignite = spell_power * pyro_coeff *( 1 + ( versatility / 100 ) ) * ( mastery / 100 ) * ( 1+ ( multistrike * 0.6 / 100 )) * ( 1 + pyro_proc ) * multiplier
			local pyro_crit_ignite = pyro_ignite * crit_damage
			local pyro_avg_ignite = pyro_ignite + pyro_crit_ignite * ( crit / 100 )
			local ib_ignite = spell_power * ib_coeff * crit_damage * ( 1 + ( versatility / 100 ) ) * ( mastery / 100 ) * ( 1+ ( multistrike * 0.6 / 100 )) * multiplier

			if ignite_tick > pyro_crit_ignite then
				frame.fstring:SetText("|cFF8800FF"..ignite)
			elseif ignite_tick > pyro_avg_ignite then
				frame.fstring:SetText("|cFFFF0000"..ignite)
			elseif ignite_tick > pyro_ignite then
				frame.fstring:SetText("|cFFFF5800"..ignite)
			elseif ignite_tick > ib_ignite then
				frame.fstring:SetText("|cFFFFFF00"..ignite)
			else
				frame.fstring:SetText("|cFF00FF00"..ignite)
			end
			frame:Show()
		end
		self.elapsed = 0
	end
end

local Event = CreateFrame("Frame")
Event:RegisterEvent("PLAYER_ENTERING_WORLD")
Event:SetScript("OnEvent", function(self, event, ...)
	--setup event!
	if event == "PLAYER_ENTERING_WORLD" then
		local class = select(2, UnitClass("player"))
		if class == "MAGE" then
			self:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
			local spec = GetSpecialization()
			if spec == 2 then
				self:RegisterEvent("PLAYER_REGEN_ENABLED")
				self:RegisterEvent("PLAYER_REGEN_DISABLED")
			end
		end
	elseif event == "ACTIVE_TALENT_GROUP_CHANGED" then
		local spec = GetSpecialization()
		if spec == 2 then
			self:RegisterEvent("PLAYER_REGEN_ENABLED")
			self:RegisterEvent("PLAYER_REGEN_DISABLED")
		else
			self:UnregisterEvent("PLAYER_REGEN_ENABLED")
			self:UnregisterEvent("PLAYER_REGEN_DISABLED")
		end
	end
	--do
	if event == "PLAYER_REGEN_DISABLED" then
		self.elapsed = 0
		self:SetScript("OnUpdate", OnUpdate)
	elseif event == "PLAYER_REGEN_ENABLED" then
		self.elapsed = 0
		self:SetScript("OnUpdate", nil)
		frame:Hide()
	end
end)