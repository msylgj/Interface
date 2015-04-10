local AddonName, Addon = ...

local L = Addon.L

local Zones = {
	[1] = L["Spires of Arak"],
	[2] = L["Talador"],
	[3] = L["Shadowmoon Valley"],
	[4] = L["Nagrand"],
	[5] = L["Gorgrond"],
	[6] = L["Frostfire Ridge"]
}

local frame

hooksecurefunc(GossipFrame, "Show", function(self)
	if GetGossipText() == L["The wormhole is spinning really fast.  You'll have to jump first and hope for the best."] then
		frame = true
	end
end)

hooksecurefunc(GossipFrame, "Hide", function(self)
	frame = nil
end)

for i = 1, #Zones do
	local setting
	hooksecurefunc(_G["GossipTitleButton" .. i], "SetText", function(self)
		if not setting and frame then
			setting = true
			_G["GossipTitleButton" .. i]:SetText(Zones[i])
			setting = nil
		end
	end)
end