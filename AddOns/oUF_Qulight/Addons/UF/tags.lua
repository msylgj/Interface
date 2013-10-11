local addon, ns = ...
local cfg = ns.cfg
local oUF = ns.oUF or oUF

local SVal = function(val)
	if val then
		if (val >= 1e6) then
			return ("%.1fm"):format(val / 1e6)
		elseif (val >= 1e3) then
			return ("%.1fk"):format(val / 1e3)
		else
			return ("%d"):format(val)
		end
	end
end
local function hex(r, g, b)
	if r then
		if (type(r) == 'table') then
			if(r.r) then r, g, b = r.r, r.g, r.b else r, g, b = unpack(r) end
		end
		return ('|cff%02x%02x%02x'):format(r * 255, g * 255, b * 255)
	end
end

local utf8sub = function(string, i, dots)
	if not string then return end
	local bytes = string:len()
	if (bytes <= i) then
		return string
	else
		local len, pos = 0, 1
		while(pos <= bytes) do
			len = len + 1
			local c = string:byte(pos)
			if (c > 0 and c <= 127) then
				pos = pos + 1
			elseif (c >= 192 and c <= 223) then
				pos = pos + 2
			elseif (c >= 224 and c <= 239) then
				pos = pos + 3
			elseif (c >= 240 and c <= 247) then
				pos = pos + 4
			end
			if (len == i) then break end
		end

		if (len == i and pos <= bytes) then
			return string:sub(1, pos - 1)..(dots and '...' or '')
		else
			return string
		end
	end
end

oUF.Tags.Events['nameshort'] = 'UNIT_NAME_UPDATE'
oUF.Tags.Methods['nameshort'] = function(unit)
	local name = UnitName(unit)
	return utf8sub(name, 9, false)
end

oUF.Tags.Events['namemedium'] = 'UNIT_NAME_UPDATE'
oUF.Tags.Methods['namemedium'] = function(unit)
	local name = UnitName(unit)
	return utf8sub(name, 15, true)
end

oUF.Tags.Events['namelong'] = 'UNIT_NAME_UPDATE'
oUF.Tags.Methods['namelong'] = function(unit)
	local name = UnitName(unit)
	return utf8sub(name, 20, true)
end

oUF.Tags.Methods['hp']  = function(u) 
  if UnitIsDead(u) or UnitIsGhost(u) or not UnitIsConnected(u) then
    return oUF.Tags.Methods['DDG'](u)
  else
	local per = oUF.Tags.Methods['perhp'](u).."%" or 0
    local min, max = UnitHealth(u), UnitHealthMax(u)
    if u == "player" or u == "target" then
      if min~=max then 
        return SVal(min).." | "..per
      else
        return SVal(max).." | "..per
      end
    else
      return per
    end
  end
end
oUF.Tags.Events['hp'] = 'UNIT_HEALTH'

oUF.Tags.Methods['per']  = function(u) 
	local per = oUF.Tags.Methods['perhp'](u).."%" or 0
    local min, max = UnitHealth(u), UnitHealthMax(u)
    if u == "player" or u == "target" then
      if min~=max then 
        return per
      end
    end
end
oUF.Tags.Events['per'] = 'UNIT_HEALTH'

oUF.Tags.Methods['power']  = function(u) 
	local min, max = UnitPower(u), UnitPowerMax(u)
	if min~=max then 
		return SVal(min)
	else 
		return SVal(max)
	end
end
oUF.Tags.Events['power'] = 'UNIT_POWER'



oUF.Tags.Methods['color'] = function(u, r)
	local _, class = UnitClass(u)
	local reaction = UnitReaction(u, "player")
	
	if UnitIsDead(u) or UnitIsGhost(u) or not UnitIsConnected(u) then
		return "|cffA0A0A0"
	elseif (UnitIsTapped(u) and not UnitIsTappedByPlayer(u)) then
		return hex(oUF.colors.tapped)
	elseif (UnitIsPlayer(u)) then
		return hex(oUF.colors.class[class])
	elseif reaction then
		return hex(oUF.colors.reaction[reaction])
	else
		return hex(1, 1, 1)
	end
end
oUF.Tags.Events['color'] = 'UNIT_REACTION UNIT_HEALTH UNIT_HAPPINESS'

oUF.Tags.Methods["afk"] = function(unit) 
	
	return UnitIsAFK(unit) and "|cffCFCFCF afk|r" or ""
end
oUF.Tags.Events["afk"] = "PLAYER_FLAGS_CHANGED"

oUF.Tags.Methods['DDG'] = function(u)
	if UnitIsDead(u) then
		return "|cffCFCFCF Dead|r"
	elseif UnitIsGhost(u) then
		return "|cffCFCFCF Ghost|r"
	elseif not UnitIsConnected(u) then
		return "|cffCFCFCF D/C|r"
	end
end
oUF.Tags.Events['DDG'] = 'UNIT_HEALTH'

oUF.Tags.Methods['LFD'] = function(u)
	local role = UnitGroupRolesAssigned(u)
	if role == "HEALER" then
		return "|cff8AFF30H|r"
	elseif role == "TANK" then
		return "|cff5F9BFFT|r"
	elseif role == "DAMAGER" then
		return "|cffFF6161D|r"
	end
end
oUF.Tags.Events['LFD'] = 'PLAYER_ROLES_ASSIGNED PARTY_MEMBERS_CHANGED'
-- Level
oUF.Tags.Methods["level"] = function(unit)
	
	local c = UnitClassification(unit)
	local l = UnitLevel(unit)
	local d = GetQuestDifficultyColor(l)
	
	local str = l
		
	if l <= 0 then l = "??" end
	
	if c == "worldboss" then
		str = string.format("|cff%02x%02x%02xBoss|r",250,20,0)
	elseif c == "eliterare" then
		str = string.format("|cff%02x%02x%02x%s|r|cff0080FFR|r+",d.r*255,d.g*255,d.b*255,l)
	elseif c == "elite" then
		str = string.format("|cff%02x%02x%02x%s|r+",d.r*255,d.g*255,d.b*255,l)
	elseif c == "rare" then
		str = string.format("|cff%02x%02x%02x%s|r|cff0080FFR|r",d.r*255,d.g*255,d.b*255,l)
	else
		if not UnitIsConnected(unit) then
			str = "??"
		else
			if UnitIsPlayer(unit) then
				str = string.format("|cff%02x%02x%02x%s",d.r*255,d.g*255,d.b*255,l)
			elseif UnitPlayerControlled(unit) then
				str = string.format("|cff%02x%02x%02x%s",d.r*255,d.g*255,d.b*255,l)
			else
				str = string.format("|cff%02x%02x%02x%s",d.r*255,d.g*255,d.b*255,l)
			end
		end		
	end
	
	return str
end
oUF.Tags.Events["level"] = "UNIT_LEVEL PLAYER_LEVEL_UP UNIT_CLASSIFICATION_CHANGED"

-- AltPower value tag
oUF.Tags.Methods['altpower'] = function(unit)
	local cur = UnitPower(unit, ALTERNATE_POWER_INDEX)
	local max = UnitPowerMax(unit, ALTERNATE_POWER_INDEX)
	if(max > 0 and not UnitIsDeadOrGhost(unit)) then
		return ("%s%%"):format(math.floor(cur/max*100+.5))
	end
end
oUF.Tags.Events['altpower'] = 'UNIT_POWER'