local _, ns = ...
local oUF = ns.oUF or oUF
assert(oUF, 'oUF_HarmonyBar was unable to locate oUF install')
if select(2, UnitClass('player')) ~= "MONK" then return end

local SPELL_POWER_CHI = SPELL_POWER_CHI

local function Update(self, event, unit, powerType)
	if(self.unit ~= unit or (powerType and powerType ~= 'CHI')) then return end
	
	local hb = self.HarmonyBar
	
	if(hb.PreUpdate) then
		hb:PreUpdate(unit)
	end
	
	local light = UnitPower("player", SPELL_POWER_CHI)
	local numPoints = UnitPowerMax("player", SPELL_POWER_CHI)

	if hb.numPoints ~= numPoints then
		if numPoints == 4 then
			hb[5]:Hide()
			for i = 1, 4 do
				hb[i]:SetWidth((hb:GetWidth()-3)/4)
			end
		else
			hb[5]:Show()
			for i = 1, 5 do
				hb[i]:SetWidth((hb:GetWidth()-4)/5)
			end
		end
		
		hb.numPoints = numPoints
	end

	for i = 1, numPoints do
		if i <= light then
			hb[i]:SetAlpha(1)
		else
			hb[i]:SetAlpha(.2)
		end
	end
	
	if(hb.PostUpdate) then
		return hb:PostUpdate(light)
	end
end

local Path = function(self, ...)
	return (self.HarmonyBar.Override or Update) (self, ...)
end

local ForceUpdate = function(element)
	return Path(element.__owner, 'ForceUpdate', element.__owner.unit, 'CHI')
end

local function Enable(self, unit)
	local hb = self.HarmonyBar
	if hb and unit == "player" then
		hb.__owner = self
		hb.ForceUpdate = ForceUpdate
		
		self:RegisterEvent("UNIT_POWER", Path)
		self:RegisterEvent("UNIT_DISPLAYPOWER", Path)
		
		for i = 1, 5 do
			local Point = hb[i]
			if not Point:GetStatusBarTexture() then
				Point:SetStatusBarTexture([=[Interface\TargetingFrame\UI-StatusBar]=])
			end
			
			Point:SetFrameLevel(hb:GetFrameLevel() + 1)
			Point:GetStatusBarTexture():SetHorizTile(false)
			Point.W = Point:GetWidth()
		end
		
		hb.numPoints = 5
		
		return true
	end
end

local function Disable(self)
	if self.HarmonyBar then
		self:UnregisterEvent("UNIT_POWER", Path)
		self:UnregisterEvent("UNIT_DISPLAYPOWER", Path)
	end
end

oUF:AddElement('HarmonyBar', Update, Enable, Disable)