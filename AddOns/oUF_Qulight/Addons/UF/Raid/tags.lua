local _, ns = ...
local oUF = ns.oUF or oUF

local foo = {""}
local spellcache = setmetatable({}, 
{__index=function(t,v) 
	local a = {GetSpellInfo(v)} 

	if GetSpellInfo(v) then
	    t[v] = a
	    return a
	end
	--print("Invalid spell ID: ", v)
    t[v] = foo
	return foo
end
})
local function GetSpellInfo(a)
    return unpack(spellcache[a])
end

local GetTime = GetTime

local numberize = function(val)
    if (val >= 1e6) then
        return ("%.1fm"):format(val / 1e6)
    elseif (val >= 1e3) then
        return ("%.1fk"):format(val / 1e3)
    else
        return ("%d"):format(val)
    end
end
ns.numberize = numberize

local x = "M"

local getTime = function(expirationTime)
    local expire = (expirationTime-GetTime())
    local timeleft = numberize(expire)
    if expire > 0.5 then
        return ("|cffffff00"..timeleft.."|r")
    end
end

-- Magic
oUF.Tags.Methods['qu:magic'] = function(u)
    local index = 1
    while true do
        local name,_,_,_, dtype = UnitAura(u, index, 'HARMFUL')
        if not name then break end
        
        if dtype == "Magic" then
            return ns.debuffColor[dtype]..x
        end

        index = index+1
    end
end
oUF.Tags.Events['qu:magic'] = "UNIT_AURA"

-- Disease
oUF.Tags.Methods['qu:disease'] = function(u)
    local index = 1
    while true do
        local name,_,_,_, dtype = UnitAura(u, index, 'HARMFUL')
        if not name then break end
        
        if dtype == "Disease" then
            return ns.debuffColor[dtype]..x
        end

        index = index+1
    end
end
oUF.Tags.Events['qu:disease'] = "UNIT_AURA"

-- Curse
oUF.Tags.Methods['qu:curse'] = function(u)
    local index = 1
    while true do
        local name,_,_,_, dtype = UnitAura(u, index, 'HARMFUL')
        if not name then break end
        
        if dtype == "Curse" then
            return ns.debuffColor[dtype]..x
        end

        index = index+1
    end
end
oUF.Tags.Events['qu:curse'] = "UNIT_AURA"

-- Poison
oUF.Tags.Methods['qu:poison'] = function(u)
    local index = 1
    while true do
        local name,_,_,_, dtype = UnitAura(u, index, 'HARMFUL')
        if not name then break end
        
        if dtype == "Poison" then
            return ns.debuffColor[dtype]..x
        end

        index = index+1
    end
end
oUF.Tags.Events['qu:poison'] = "UNIT_AURA"

-- Priest
local pomCount = {"i","h","g","f","Z","Y"}
oUF.Tags.Methods['qu:pom'] = function(u) 
    local name, _,_, c, _,_,_, fromwho = UnitAura(u, GetSpellInfo(41635)) 
    if fromwho == "player" then
        if(c) then return "|cff66FFFF"..pomCount[c+1].."|r" end
    else
        if(c) then return "|cffFFCF7F"..pomCount[c+1].."|r" end 
    end
end
oUF.Tags.Events['qu:pom'] = "UNIT_AURA"

oUF.Tags.Methods['qu:rnw'] = function(u)
    local name, _,_,_,_,_, expirationTime, fromwho = UnitAura(u, GetSpellInfo(139))
    if(fromwho == "player") then
        local spellTimer = GetTime()-expirationTime
        if spellTimer > -2 then
            return "|cffFF0000"..x.."|r"
        elseif spellTimer > -4 then
            return "|cffFF9900"..x.."|r"
        else
            return "|cff33FF33"..x.."|r"
        end
    end
end
oUF.Tags.Events['qu:rnw'] = "UNIT_AURA"

oUF.Tags.Methods['qu:rnwTime'] = function(u)
    local name, _,_,_,_,_, expirationTime, fromwho = UnitAura(u, GetSpellInfo(139))
    if(fromwho == "player") then return getTime(expirationTime) end 
end
oUF.Tags.Events['qu:rnwTime'] = "UNIT_AURA"

oUF.Tags.Methods['qu:pws'] = function(u) if UnitAura(u, GetSpellInfo(17)) then return "|cff33FF33"..x.."|r" end end
oUF.Tags.Events['qu:pws'] = "UNIT_AURA"

oUF.Tags.Methods['qu:ws'] = function(u) if UnitDebuff(u, GetSpellInfo(6788)) then return "|cffFF9900"..x.."|r" end end
oUF.Tags.Events['qu:ws'] = "UNIT_AURA"

oUF.Tags.Methods['qu:fw'] = function(u) if UnitAura(u, GetSpellInfo(6346)) then return "|cff8B4513"..x.."|r" end end
oUF.Tags.Events['qu:fw'] = "UNIT_AURA"

oUF.Tags.Methods['qu:fort'] = function(u) if not(UnitAura(u, GetSpellInfo(6307)) or UnitAura(u, GetSpellInfo(469)) or UnitAura(u, GetSpellInfo(21562)) or UnitAura(u, GetSpellInfo(90364)) or UnitAura(u, GetSpellInfo(72590))) then return "|cff00A1DE"..x.."|r" end end
oUF.Tags.Events['qu:fort'] = "UNIT_AURA"

oUF.Tags.Methods['qu:pwb'] = function(u) if UnitAura(u, GetSpellInfo(81782)) then return "|cffEEEE00"..x.."|r" end end
oUF.Tags.Events['qu:pwb'] = "UNIT_AURA"

-- Druid
local lbCount = { 4, 2, 3}
oUF.Tags.Methods['qu:lb'] = function(u) 
    local name, _,_, c,_,_, expirationTime, fromwho = UnitAura(u, GetSpellInfo(33763))
    if(fromwho == "player") then
        local spellTimer = GetTime()-expirationTime
        if spellTimer > -2 then
            return "|cffFF0000"..lbCount[c].."|r"
        elseif spellTimer > -4 then
            return "|cffFF9900"..lbCount[c].."|r"
        else
            return "|cffA7FD0A"..lbCount[c].."|r"
        end
    end
end
oUF.Tags.Events['qu:lb'] = "UNIT_AURA"

oUF.Tags.Methods['qu:rejuv'] = function(u)
    local name, _,_,_,_,_, expirationTime, fromwho = UnitAura(u, GetSpellInfo(774))
    if(fromwho == "player") then
        local spellTimer = GetTime()-expirationTime
        if spellTimer > -2 then
            return "|cffFF0000"..x.."|r"
        elseif spellTimer > -4 then
            return "|cffFF9900"..x.."|r"
        else
            return "|cff33FF33"..x.."|r"
        end
    end
end
oUF.Tags.Events['qu:rejuv'] = "UNIT_AURA"

oUF.Tags.Methods['qu:rejuvTime'] = function(u)
    local name, _,_,_,_,_, expirationTime, fromwho = UnitAura(u, GetSpellInfo(774))
    if(fromwho == "player") then return getTime(expirationTime) end 
end
oUF.Tags.Events['qu:rejuvTime'] = "UNIT_AURA"

oUF.Tags.Methods['qu:regrow'] = function(u) if UnitAura(u, GetSpellInfo(8936)) then return "|cff00FF10"..x.."|r" end end
oUF.Tags.Events['qu:regrow'] = "UNIT_AURA"

oUF.Tags.Methods['qu:wg'] = function(u) if UnitAura(u, GetSpellInfo(48438)) then return "|cff33FF33"..x.."|r" end end
oUF.Tags.Events['qu:wg'] = "UNIT_AURA"

oUF.Tags.Methods['qu:motw'] = function(u) if not(UnitAura(u, GetSpellInfo(1126)) or UnitAura(u,GetSpellInfo(20217)) or UnitAura(u,GetSpellInfo(90363)) or UnitAura(u,GetSpellInfo(115921))) then return "|cff00A1DE"..x.."|r" end end
oUF.Tags.Events['qu:motw'] = "UNIT_AURA"

-- Warrior
oUF.Tags.Methods['qu:stragi'] = function(u) if not(UnitAura(u, GetSpellInfo(6673)) or UnitAura(u, GetSpellInfo(57330)) or UnitAura(u, GetSpellInfo(19506))) then return "|cffFF0000"..x.."|r" end end
oUF.Tags.Events['qu:stragi'] = "UNIT_AURA"

-- Shaman
oUF.Tags.Methods['qu:rip'] = function(u) 
    local name, _,_,_,_,_,_, fromwho = UnitAura(u, GetSpellInfo(61295))
    if(fromwho == 'player') then return "|cff00FEBF"..x.."|r" end
end
oUF.Tags.Events['qu:rip'] = 'UNIT_AURA'

oUF.Tags.Methods['qu:ripTime'] = function(u)
    local name, _,_,_,_,_, expirationTime, fromwho = UnitAura(u, GetSpellInfo(61295))
    if(fromwho == "player") then return getTime(expirationTime) end 
end
oUF.Tags.Events['qu:ripTime'] = 'UNIT_AURA'

local earthCount = {'i','h','g','f','p','q','Z','Z','Y'}
oUF.Tags.Methods['qu:earth'] = function(u) 
    local c = select(4, UnitAura(u, GetSpellInfo(974))) if c then return '|cffFFCF7F'..earthCount[c]..'|r' end 
end
oUF.Tags.Events['qu:earth'] = 'UNIT_AURA'

-- Paladin
oUF.Tags.Methods['qu:beacon'] = function(u)
    local name, _,_,_,_,_, expirationTime, fromwho = UnitAura(u, GetSpellInfo(53563))
    if not name then return end
    if(fromwho == "player") then
        local spellTimer = GetTime()-expirationTime
        if spellTimer > -30 then
            return "|cffFF00004|r"
        else
            return "|cffFFCC003|r"
        end
    else
        return "|cff996600Y|r" -- other pally's beacon
    end
end
oUF.Tags.Events['qu:beacon'] = "UNIT_AURA"

oUF.Tags.Methods['qu:forbearance'] = function(u) if UnitDebuff(u, GetSpellInfo(25771)) then return "|cffFF9900"..x.."|r" end end
oUF.Tags.Events['qu:forbearance'] = "UNIT_AURA"

-- Warlock

oUF.Tags.Methods['qu:ss'] = function(u) 
    local name, _,_,_,_,_,_, fromwho = UnitAura(u, GetSpellInfo(20707)) 
    if fromwho == "player" then
        return "|cff6600FFY|r"
    elseif name then
        return "|cffCC00FFY|r"
    end
end
oUF.Tags.Events['qu:ss'] = "UNIT_AURA"

-- Mage
oUF.Tags.Methods['qu:int'] = function(u) if not(UnitAura(u, GetSpellInfo(1459)) or UnitAura(u, GetSpellInfo(61316))) then return "|cff00A1DE"..x.."|r" end end
oUF.Tags.Events['qu:int'] = "UNIT_AURA"

ns.classIndicators={
    ["DRUID"] = {
        ["TL"] = "",
        ["TR"] = "[qu:motw]",
        ["BL"] = "[qu:regrow][qu:wg]",
        ["BR"] = "[qu:lb]",
        ["Cen"] = "[qu:rejuvTime]",
    },
    ["PRIEST"] = {
        ["TL"] = "[qu:pws][qu:ws]",
        ["TR"] = "[qu:fw][qu:fort]",
        ["BL"] = "[qu:rnw][qu:pwb]",
        ["BR"] = "[qu:pom]",
        ["Cen"] = "[qu:rnwTime]",
    },
    ["PALADIN"] = {
        ["TL"] = "[qu:forbearance]",
        ["TR"] = "[qu:motw]",
        ["BL"] = "",
        ["BR"] = "[qu:beacon]",
        ["Cen"] = "",
    },
    ["WARLOCK"] = {
        ["TL"] = "",
        ["TR"] = "",
        ["BL"] = "",
        ["BR"] = "[qu:ss]",
        ["Cen"] = "",
    },
    ["WARRIOR"] = {
        ["TL"] = "",
        ["TR"] = "[qu:stragi][qu:fort]",
        ["BL"] = "",
        ["BR"] = "",
        ["Cen"] = "",
    },
    ["DEATHKNIGHT"] = {
        ["TL"] = "",
        ["TR"] = "",
        ["BL"] = "",
        ["BR"] = "",
        ["Cen"] = "",
    },
    ["SHAMAN"] = {
        ["TL"] = "[qu:rip]",
        ["TR"] = "",
        ["BL"] = "",
        ["BR"] = "[qu:earth]",
        ["Cen"] = "[qu:ripTime]",
    },
    ["HUNTER"] = {
        ["TL"] = "",
        ["TR"] = "[qu:stragi]",
        ["BL"] = "",
        ["BR"] = "",
        ["Cen"] = "",
    },
    ["ROGUE"] = {
        ["TL"] = "",
        ["TR"] = "",
        ["BL"] = "",
        ["BR"] = "",
        ["Cen"] = "",
    },
    ["MAGE"] = {
        ["TL"] = "",
        ["TR"] = "[qu:int]",
        ["BL"] = "",
        ["BR"] = "",
        ["Cen"] = "",
    },
    ["MONK"] = {
        ["TL"] = "",
        ["TR"] = "[qu:motw]",
        ["BL"] = "",
        ["BR"] = "",
        ["Cen"] = "",
    },
}
