if not Qulight["buffdebuff"].enable or not Qulight["unitframes"].enable == true then return end 
local addon, ns = ...

AnchorBuff = CreateFrame("Frame","Move_Buff",UIParent)
AnchorBuff:SetPoint("TOPRIGHT","UIParent", -7, -27)
CreateAnchor(AnchorBuff, "Move Buff", 300, 70)
local mainhand, _, _, offhand, _, _, hand3 = GetWeaponEnchantInfo()
local rowbuffs = 16

local GetFormattedTime = function(s)
	if s >= 86400 then
		return format("%dd", floor(s/86400 + 0.5))
	elseif s >= 3600 then
		return format("%dh", floor(s/3600 + 0.5))
	elseif s >= 60 then
		return format("%dm", floor(s/60 + 0.5))
	end
	return floor(s + 0.5)
end

ConsolidatedBuffs:ClearAllPoints()
ConsolidatedBuffs:SetPoint("TOPRIGHT", AnchorBuff)
ConsolidatedBuffs:SetSize(Qulight["buffdebuff"].iconsize, Qulight["buffdebuff"].iconsize)
ConsolidatedBuffs.SetPoint = nil

ConsolidatedBuffsIcon:SetTexture("Interface\\Icons\\Spell_ChargePositive")
ConsolidatedBuffsIcon:SetTexCoord(0.03,0.97,0.03,0.97)
ConsolidatedBuffsIcon:SetSize(Qulight["buffdebuff"].iconsize-2,Qulight["buffdebuff"].iconsize-2)

local h = CreateFrame("Frame")
h:SetParent(ConsolidatedBuffs)
h:SetAllPoints(ConsolidatedBuffs)
h:SetFrameLevel(30)

ConsolidatedBuffsCount:SetParent(h)
ConsolidatedBuffsCount:SetPoint("TOPRIGHT")
ConsolidatedBuffsCount:SetFont(Qulight["media"].pxfont, Qulight["buffdebuff"].countfontsize, "OUTLINE")

local CBbg = CreateFrame("Frame", nil, ConsolidatedBuffs)
CreateShadow(CBbg)

for i = 1, 3 do
	local te 			= _G["TempEnchant"..i]
	local teicon 		= _G["TempEnchant"..i.."Icon"]
	local teduration 	= _G["TempEnchant"..i.."Duration"]
	_G["TempEnchant"..i.."Border"]:Hide()
	_G["TempEnchant"..i.."Icon"]:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	_G["TempEnchant"..i.."Icon"]:SetPoint("TOPLEFT", _G["TempEnchant"..i], 2, -2)
	_G["TempEnchant"..i.."Icon"]:SetPoint("BOTTOMRIGHT", _G["TempEnchant"..i], -2, 2)
	
	_G["TempEnchant"..i]:SetHeight(Qulight["buffdebuff"].iconsize)
	_G["TempEnchant"..i]:SetWidth(Qulight["buffdebuff"].iconsize)
	_G["TempEnchant"..i.."Duration"]:ClearAllPoints()
	_G["TempEnchant"..i.."Duration"]:SetPoint("BOTTOM", 0, -2)
	_G["TempEnchant"..i.."Duration"]:SetFont(Qulight["media"].pxfont, Qulight["buffdebuff"].countfontsize, "OUTLINE")
	local h = CreateFrame("Frame")
	h:SetParent(te)
	h:SetAllPoints(te)
	h:SetFrameLevel(30)
	CreateShadow(h)
end
local function StyleBuffs(buttonName, index, debuff)
	local buff = _G[buttonName..index]
	local icon = _G[buttonName..index.."Icon"]
	local border = _G[buttonName..index.."Border"]
	local duration = _G[buttonName..index.."Duration"]
	local count = _G[buttonName..index.."Count"]
	if icon and not _G[buttonName..index.."Panel"] then
		icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
		icon:SetPoint("TOPLEFT", buff, 2, -2)
		icon:SetPoint("BOTTOMRIGHT", buff, -2, 2)
		
		buff:SetHeight(Qulight["buffdebuff"].iconsize)
		buff:SetWidth(Qulight["buffdebuff"].iconsize)
		
		duration:ClearAllPoints()
		duration:SetPoint("BOTTOM", 0, -2)
		duration:SetFont(Qulight["media"].pxfont, Qulight["buffdebuff"].countfontsize, "OUTLINE")
		
				
		count:ClearAllPoints()
		count:SetPoint("TOPRIGHT", 2, 2)
		count:SetFont(Qulight["media"].pxfont, Qulight["buffdebuff"].countfontsize, "OUTLINE")
		
		local panel = CreateFrame("Frame", buttonName..index.."Panel", buff)
		CreatePanel(panel, Qulight["buffdebuff"].iconsize, Qulight["buffdebuff"].iconsize, "CENTER", buff, "CENTER", 0, 0)
		
		panel:SetFrameLevel(0)
		panel:SetFrameStrata(buff:GetFrameStrata())
		CreateShadow(panel)
	end

	if border then border:Hide() end
end

function UpdateFlash(self, elapsed)
	local index = self:GetID()
	self:SetAlpha(1)
end

local UpdateDuration = function(auraButton, timeLeft)
	local duration = auraButton.duration
	if SHOW_BUFF_DURATIONS == "1" and timeLeft then
		duration:SetFormattedText(GetFormattedTime(timeLeft))
		duration:SetVertexColor(1, 1, 1)
		duration:Show()
	else
		duration:Hide()
	end
end

local function UpdateBuffAnchors()
	local buttonName = "BuffButton"
	local buff, previousBuff, aboveBuff
	local numBuffs = 0
	local slack = BuffFrame.numEnchants
	local mainhand, _, _, offhand, _, _, hand3 = GetWeaponEnchantInfo()

	for index = 1, BUFF_ACTUAL_DISPLAY do
		StyleBuffs(buttonName, index, false)
		local buff = _G[buttonName..index]
		
		if not buff.consolidated then	
			numBuffs = numBuffs + 1
			index = numBuffs + slack
			buff:ClearAllPoints()
			if ( (index > 1) and (mod(index, Qulight["buffdebuff"].BUFFS_PER_ROW) == 1) ) then
 				if ( index == Qulight["buffdebuff"].BUFFS_PER_ROW + 1 ) then
					buff:SetPoint("TOP", ConsolidatedBuffs, "BOTTOM", 0, -3)
				else
					buff:SetPoint("TOP", aboveBuff, "BOTTOM", 0, -3)
				end
				aboveBuff = buff
			elseif index == 1 then
				buff:SetPoint("TOPRIGHT", AnchorBuff)
			else
				if numBuffs == 1 then
					if (mainhand and offhand and hand3) and not UnitHasVehicleUI("player") then
						buff:SetPoint("RIGHT", TempEnchant3, "LEFT", -3, 0)
					elseif ((mainhand and offhand) or (mainhand and hand3) or (offhand and hand3)) and not UnitHasVehicleUI("player") then
						buff:SetPoint("RIGHT", TempEnchant2, "LEFT", -3, 0)
					elseif ((mainhand and not offhand and not hand3) or (offhand and not mainhand and not hand3) or (hand3 and not mainhand and not offhand)) and not UnitHasVehicleUI("player") then
						buff:SetPoint("RIGHT", TempEnchant1, "LEFT", -3, 0)
					else
						buff:SetPoint("RIGHT", ConsolidatedBuffs, "LEFT", -3, 0)
					end
				else
					buff:SetPoint("RIGHT", previousBuff, "LEFT", -3, 0)
				end
			end
			previousBuff = buff
		end
	end
end

local function UpdateDebuffAnchors(buttonName, index)
	_G[buttonName..index]:Hide()
end

local z = 0.79
local function UpdateConsolidatedBuffsAnchors()
	ConsolidatedBuffsTooltip:SetWidth(min(BuffFrame.numConsolidated * Qulight["buffdebuff"].iconsize * z + 18, 4 * Qulight["buffdebuff"].iconsize * z + 18))
    ConsolidatedBuffsTooltip:SetHeight(floor((BuffFrame.numConsolidated + 3) / 4 ) * Qulight["buffdebuff"].iconsize * z + CONSOLIDATED_BUFF_ROW_HEIGHT * z)
end

hooksecurefunc("BuffFrame_UpdateAllBuffAnchors", UpdateBuffAnchors)
hooksecurefunc("DebuffButton_UpdateAnchors", UpdateDebuffAnchors)
hooksecurefunc("AuraButton_UpdateDuration", UpdateDuration)
hooksecurefunc("AuraButton_OnUpdate", UpdateFlash)
----------------------------------------------------------------------------------------
--	Tells you who cast a buff or debuff in its tooltip(CastBy by Compost)
----------------------------------------------------------------------------------------
local a, b, d = _G.GameTooltip.SetUnitAura, _G.GameTooltip.SetUnitBuff, _G.GameTooltip.SetUnitDebuff
local un, uc, uvsi, ua, uip, upc, sub = _G.UnitName, _G.UnitClass, _G.UnitVehicleSeatInfo, _G.UnitAura, _G.UnitIsPlayer, _G.UnitPlayerControlled, _G.string.sub
local co = setmetatable({}, {__index = function(t, cl)
	local c = CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[cl] or RAID_CLASS_COLORS[cl]
	if c then
		t[cl] = ("ff%02x%02x%02x"):format(c.r * 255, c.g * 255, c.b * 255)
	else
		t[cl] = "ffffffff"
	end
	return t[cl]
end})

local function h(o, ...)
	o(...)
	local _, uid, id, f = ...
	if o == b then
		f = "HELPFUL " .. (f or "")
	elseif o == d then
		f = "HARMFUL " .. (f or "")
	end
	local _, _, _, _, _, _, _, c = ua(uid, id, f)
	local cl, str
	if c then
		if not uip(c) and upc(c) then
			local n
			_, n = uvsi(c, 1)
			if n then
				_, cl = uc(n)
				str = ("|c%s%s|r"):format(co[cl], n)
				_, n = uvsi(c, 2)
				if n then
					_, cl = uc(n)
					str = str.." & "..("|c%s%s|r"):format(co[cl], n)
				end
			else
				local cl2, n2
				if c == "pet" then
					_, cl=uc(c);_, cl2 = uc("player");n, n2 = un(c), un("player")
				elseif sub(c, 1, 8) == "partypet" then
					id = sub(c, 9)
					_, cl = uc(c);_, cl2 = uc("party"..id);n, n2 = un(c), un("party"..id)
				elseif sub(c, 1, 7) == "raidpet" then
					id = sub(c, 8)
					_, cl = uc(c);_, cl2=uc("raid"..id);n, n2 = un(c), un("raid"..id)
				end
				if cl then
					str = ("|c%s%s|r (|c%s%s|r)"):format(co[cl], n,co[cl2], n2)
				else
					_, cl = uc(c)
					str = ("|c%s%s|r"):format(co[cl], un(c))
				end
			end
		else
			_, cl = uc(c)
			str = ("|c%s%s|r"):format(co[cl], un(c))
		end
	end
	if str then
		GameTooltip:AddLine(DONE_BY.." "..str)
		GameTooltip:Show()
	end
end

GameTooltip.SetUnitAura = function( ... )
	h( a, ... )
end

GameTooltip.SetUnitBuff = function( ... )
	h( b, ... )
end

GameTooltip.SetUnitDebuff = function( ... )
	h( d, ... )
end