local addonName, L = ...;

local function PremadeFilter_DefaultString(L, key)
	return key;
end

setmetatable(L, { __index = PremadeFilter_DefaultString });
