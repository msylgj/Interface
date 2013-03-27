-- yleaf @ cwdg (yaroot@gmail.com)
local _G = _G
local r, g, b = 1, 136/255, 0	-- color

local function hooktip(tip)
	local set = tip:GetScript('OnTooltipSetItem')
	
	tip:SetScript('OnTooltipSetItem', function(self, ...)
		if set then
			set(self, ...)
		end
		
		local link = select(2, self:GetItem())
		if link then
			local id = tonumber(link:match("item:(%d+):"))
			
			if id then
				local _, _, _, level, _, itype, subtype, stack = GetItemInfo(id)
				if level then
					local typetext = itype and subtype and string.format('Type: %s - %s', itype, subtype) or nil
					
					self:AddDoubleLine("iLevel: "..level, "ItemID: "..id, r, g, b, r, g, b)
					if stack ~= 1 then
						self:AddDoubleLine(typetext, 'Stack: '..stack, r, g, b, r, g, b)
					else
						self:AddLine(typetext, r, g, b)
					end
					self:Show()
				end
			end
		end	
	end)
end

hooktip(GameTooltip)
hooktip(ItemRefTooltip)
hooktip(ShoppingTooltip1)
hooktip(ShoppingTooltip2)