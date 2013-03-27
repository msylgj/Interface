--[[

    nBuff
    Copyright (c) 2008-2010, Anton 'Neav' Ickert
    All rights reserved.

--]]

DAY_ONELETTER_ABBR    = '|cffffffff%dd|r'
HOUR_ONELETTER_ABBR   = '|cffffffff%dh|r'
MINUTE_ONELETTER_ABBR = '|cffffffff%dm|r'
SECOND_ONELETTER_ABBR = '|cffffffff%ds|r'

TemporaryEnchantFrame:ClearAllPoints()
TemporaryEnchantFrame:SetPoint("TOPRIGHT","UIParent", -7, -27)
--TemporaryEnchantFrame:SetPoint('TOPRIGHT', Minimap, 'TOPLEFT', -7, 0)
TemporaryEnchantFrame.SetPoint = function() end

TempEnchant2:ClearAllPoints()
TempEnchant2:SetPoint('TOPRIGHT', TempEnchant1, 'TOPLEFT', -nBuff.padding.x, 0)


ConsolidatedBuffs:SetHeight(20)
ConsolidatedBuffs:SetWidth(20)

ConsolidatedBuffs:ClearAllPoints()
ConsolidatedBuffs:SetPoint('BOTTOM', TempEnchant1, 'TOP', 0, 5)
ConsolidatedBuffs.SetPoint = function() end

ConsolidatedBuffsIcon:SetAlpha(0)
	
ConsolidatedBuffsCount:ClearAllPoints()
ConsolidatedBuffsCount:SetPoint('CENTER', ConsolidatedBuffsIcon)
ConsolidatedBuffsCount:SetFont('Interface\\Addons\\nBuff\\ROADWAY.ttf', 16, 'THINOUTLINE')
ConsolidatedBuffsCount:SetShadowOffset(0, 0)

ConsolidatedBuffsTooltip:SetScale(1.2)

local BUFF_NEW_INDEX = 1

local function BuffFrame_SetPoint(self)
    local i = 0
	local hasMainHandEnchant, _, _, hasOffHandEnchant = GetWeaponEnchantInfo()
    if hasMainHandEnchant then
        i = i + 1
    end
    if hasOffHandEnchant then
        i = i + 1
    end
	if (self and self:IsShown()) then
        self:ClearAllPoints()
        if (UnitHasVehicleUI('player')) then
            self:SetPoint('TOPRIGHT', TempEnchant1)
            return
        else
			if i == 2 then            
                self:SetPoint('TOPRIGHT', TempEnchant2, 'TOPLEFT', -nBuff.padding.x, 0)
                return
            elseif i == 1 then
                self:SetPoint('TOPRIGHT', TempEnchant1, 'TOPLEFT', -nBuff.padding.x, 0)
                return
			elseif i == 0 then
                self:SetPoint('TOPRIGHT', TempEnchant1)
                return
            end
        end
    end
end

hooksecurefunc('BuffFrame_UpdatePositions', function()
    if (CONSOLIDATED_BUFF_ROW_HEIGHT ~= 28) then
        CONSOLIDATED_BUFF_ROW_HEIGHT = 28
    end
end)

BuffFrame:SetScript('OnUpdate', function(self, elapsed)
    self.BuffFrameUpdateTime = self.BuffFrameUpdateTime + elapsed
    if (self.BuffFrameUpdateTime > TOOLTIP_UPDATE_TIME) then
        self.BuffFrameUpdateTime = 0
        if (BuffButton1) then
            if (not BuffButton1:GetParent() == ConsolidatedBuffsContainer) then
                BuffFrame_SetPoint(BuffButton1)
            end
        end
    end
end)

hooksecurefunc('BuffFrame_UpdateAllBuffAnchors', function()  
    local BUFF_PREVIOUS, BUFF_ABOVE
	local numBuffs = 0

	for i = 1, BUFF_ACTUAL_DISPLAY do
		local buff = _G['BuffButton'..i]
        local hasMainHandEnchant, _, _, hasOffHandEnchant = GetWeaponEnchantInfo()

		if (buff.consolidated) then
			if (buff.parent == BuffFrame) then
				buff:SetParent(ConsolidatedBuffsContainer)
				buff.parent = ConsolidatedBuffsContainer
			end
		else
			numBuffs = numBuffs + 1
			index    = numBuffs
            local i = 0
			if hasMainHandEnchant then
                i = i + 1
            end
            if hasOffHandEnchant then
                i = i + 1
            end
			index = index + i

			if (buff.parent ~= BuffFrame) then
				buff:SetParent(BuffFrame)
                buff.parent = BuffFrame
			end
                
            buff:ClearAllPoints()
            if (index > 1 and mod(index, nBuff.button.buffPerRow) == 1) then
                if (index == nBuff.button.buffPerRow + 1) then
                    buff:SetPoint('TOP', TempEnchant1, 'BOTTOM', 0, -nBuff.padding.y)
                else
                    buff:SetPoint('TOP', BUFF_ABOVE, 'BOTTOM', 0, -nBuff.padding.y)
                end
                BUFF_ABOVE = buff
            elseif (numBuffs == 1) then
                BuffFrame_SetPoint(buff)
            else
                buff:SetPoint('RIGHT', BUFF_PREVIOUS, 'LEFT', -nBuff.padding.x, 0)
            end
            
            BUFF_PREVIOUS = buff
            BUFF_NEW_INDEX = index
        end
	end
end)

hooksecurefunc('DebuffButton_UpdateAnchors', function(self, index)
    local BUFF_NEW_SPACE, BUFF_NEW_ROW, BUFF_NUM_ROWS, BUFF_NUM_BUFFS

    BUFF_NEW_SPACE = 31 + nBuff.padding.y
    BUFF_NUM_BUFFS = (BUFF_NEW_INDEX > 0 and BUFF_NEW_INDEX) or 1
    BUFF_NUM_ROWS  = ceil(BUFF_NUM_BUFFS/nBuff.button.buffPerRow)
    
    if (BUFF_NUM_ROWS and BUFF_NUM_ROWS > 1) then
        BUFF_NEW_ROW = -BUFF_NUM_ROWS * BUFF_NEW_SPACE
    else
        BUFF_NEW_ROW = -BUFF_NEW_SPACE
    end
    
    local buff = _G[self..index]
    buff:ClearAllPoints()
    if (index == 1) then
        buff:SetPoint('TOP', TempEnchant1, 'BOTTOM', 0, BUFF_NEW_ROW)
	elseif (index >= 2 and mod(index, nBuff.button.buffPerRow) == 1) then
		buff:SetPoint('TOP', _G[self..(index-nBuff.button.buffPerRow)], 'BOTTOM', 0, -nBuff.padding.y)
	else
		buff:SetPoint('RIGHT', _G[self..(index-1)], 'LEFT', -nBuff.padding.x, 0)
	end
end)

for i = 1, 2 do
    local button = _G['TempEnchant'..i]
    if (button) then
        button:SetWidth(nBuff.button.size)
        button:SetHeight(nBuff.button.size)
        button:SetScale(nBuff.button.scale)
    end

    local icon = _G['TempEnchant'..i..'Icon']
    icon:SetTexCoord(0.03, 0.97, 0.03, 0.97)

    local duration = _G['TempEnchant'..i..'Duration']
    duration:ClearAllPoints()
    duration:SetPoint('BOTTOM', button, 'BOTTOM', 0, -8)
    duration:SetFont(nBuff.button.durationFont, nBuff.button.durationFontsize,'OUTLINE')
	-- duration:SetTextColor(1.00, 1.00, 0.00 )
    -- duration:SetShadowOffset(1, 1)
    duration:SetDrawLayer('OVERLAY')

    local border = _G['TempEnchant'..i..'Border']
    border:ClearAllPoints()
    border:SetPoint('TOPRIGHT', button, 2.5, 2.5)
    border:SetPoint('BOTTOMLEFT', button, -2.5, -2.5)    
    border:SetTexture(nBuff.button.borderDebuff)
    border:SetTexCoord(0, 1, 0, 1)
    border:SetVertexColor(0.9, 0.25, 0.9)

    button.Shadow = button:CreateTexture('$parentBackground', 'BACKGROUND')
    button.Shadow:SetPoint('TOPRIGHT', border, 1.35, 1.35)
    button.Shadow:SetPoint('BOTTOMLEFT', border, -1.35, -1.35)
    button.Shadow:SetTexture('Interface\\AddOns\\nBuff\\media\\textureShadow')
    button.Shadow:SetVertexColor(0, 0, 0, 1)
end

hooksecurefunc('AuraButton_Update', function(self, index)
    local button = _G[self..index]
    if (button) then
        button:SetWidth(nBuff.button.size)
        button:SetHeight(nBuff.button.size)
        button:SetScale(nBuff.button.scale)
    end
        
    local icon = _G[self..index..'Icon']
    if (icon) then
        icon:SetTexCoord(0.03, 0.97, 0.03, 0.97)
    end
        
    local duration = _G[self..index..'Duration']
    if (duration) then
        duration:ClearAllPoints()
        duration:SetPoint('BOTTOM', button, 'BOTTOM', 0, -8)
        duration:SetFont(nBuff.button.durationFont, nBuff.button.durationFontsize,'OUTLINE')
		--duration:SetTextColor(1.00, 0.96, 0.41, 1 )
        --duration:SetShadowOffset(0, 0)
        duration:SetDrawLayer('OVERLAY')
    end

    local count = _G[self..index..'Count']
    if (count) then
        count:ClearAllPoints()
        count:SetPoint('TOPRIGHT', button)
        count:SetFont(nBuff.button.countFont, nBuff.button.countFontsize, 'OUTLINE')
        count:SetShadowOffset(0, 0)
        count:SetDrawLayer('OVERLAY')
    end
        
    local border = _G[self..index..'Border']
    if (border) then
        border:SetTexture(nBuff.button.borderDebuff)
        border:SetPoint('TOPRIGHT', button, 2.5, 2.5)
        border:SetPoint('BOTTOMLEFT', button, -2.5, -2.5)
        border:SetTexCoord(0, 1, 0, 1)
    end
    
    if (button and not border) then
        if (not button.texture) then
            button.texture = button:CreateTexture('$parentOverlay', 'ARTWORK')
            button.texture:SetParent(button)
            button.texture:SetTexture(nBuff.button.borderBuff)
            button.texture:SetPoint('TOPRIGHT', button, 2.5, 2.5)
            button.texture:SetPoint('BOTTOMLEFT', button, -2.5, -2.5)
            button.texture:SetVertexColor(unpack(nBuff.button.buffBorderColor))
        end
    end
    
    if (button) then
        if (not button.Shadow) then
            button.Shadow = button:CreateTexture('$parentShadow', 'BACKGROUND')
            button.Shadow:SetTexture('Interface\\AddOns\\nBuff\\media\\textureShadow')
            button.Shadow:SetPoint('TOPRIGHT', button.texture or border, 1.35, 1.35)
            button.Shadow:SetPoint('BOTTOMLEFT', button.texture or border, -1.35, -1.35)
            button.Shadow:SetVertexColor(0, 0, 0, 1)
        end
    end
end)