local _, ns = ...
local oUF = ns.oUF or oUF
assert(oUF, "oUF_q was unable to locate oUF install.")

local foo = {""}
local spellcache = setmetatable({}, 
{__index=function(t,id) 
	local a = {GetSpellInfo(id)} 

	if GetSpellInfo(id) then
	    t[id] = a
	    return a
	end

	--print("Invalid spell ID: ", id)
        t[id] = foo
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
oUF.Tags.Methods['q:magic'] = function(u)
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
oUF.Tags.Events['q:magic'] = "UNIT_AURA"

-- Disease
oUF.Tags.Methods['q:disease'] = function(u)
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
oUF.Tags.Events['q:disease'] = "UNIT_AURA"

-- Curse
oUF.Tags.Methods['q:curse'] = function(u)
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
oUF.Tags.Events['q:curse'] = "UNIT_AURA"

-- Poison
oUF.Tags.Methods['q:poison'] = function(u)
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
oUF.Tags.Events['q:poison'] = "UNIT_AURA"

-- Priest
local pomCount = {
	[1] = 'i',
	[2] = 'h',
	[3] = 'g',
	[4] = 'f',
	[5] = 'Z',
	[6] = 'Y',
}
oUF.Tags.Methods['q:pom'] = function(u) 
    local name, _,_, c, _,_,_, fromwho = UnitAura(u, GetSpellInfo(33076))
    if name and pomCount[c] then
        if(fromwho == "player") then
            return "|cff66FFFF"..pomCount[c].."|r"
        else
            return "|cffFFCF7F"..pomCount[c].."|r"
        end
    end
end
oUF.Tags.Events['q:pom'] = "UNIT_AURA"

oUF.Tags.Methods['q:rnw'] = function(u)
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
oUF.Tags.Events['q:rnw'] = "UNIT_AURA"

oUF.Tags.Methods['q:rnwTime'] = function(u)
    local name, _,_,_,_,_, expirationTime, fromwho = UnitAura(u, GetSpellInfo(139))
    if(fromwho == "player") then return getTime(expirationTime) end 
end
oUF.Tags.Events['q:rnwTime'] = "UNIT_AURA"

oUF.Tags.Methods['q:pws'] = function(u) if UnitAura(u, GetSpellInfo(17)) then return "|cff33FF33"..x.."|r" end end
oUF.Tags.Events['q:pws'] = "UNIT_AURA"

oUF.Tags.Methods['q:ws'] = function(u) if UnitDebuff(u, GetSpellInfo(6788)) then return "|cffFF9900"..x.."|r" end end
oUF.Tags.Events['q:ws'] = "UNIT_AURA"

oUF.Tags.Methods['q:fw'] = function(u) if UnitAura(u, GetSpellInfo(6346)) then return "|cff8B4513"..x.."|r" end end
oUF.Tags.Events['q:fw'] = "UNIT_AURA"

oUF.Tags.Methods['q:fort'] = function(u) if not(UnitAura(u, GetSpellInfo(21562)) or UnitAura(u, GetSpellInfo(6307)) or UnitAura(u, GetSpellInfo(469))) then return "|cff00A1DE"..x.."|r" end end
oUF.Tags.Events['q:fort'] = "UNIT_AURA"

oUF.Tags.Methods['q:pwb'] = function(u) if UnitAura(u, GetSpellInfo(81782)) then return "|cffEEEE00"..x.."|r" end end
oUF.Tags.Events['q:pwb'] = "UNIT_AURA"

-- Druid
local lbCount = { 4, 2, 3}
oUF.Tags.Methods['q:lb'] = function(u) 
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
oUF.Tags.Events['q:lb'] = "UNIT_AURA"

oUF.Tags.Methods['q:rejuv'] = function(u)
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
oUF.Tags.Events['q:rejuv'] = "UNIT_AURA"

oUF.Tags.Methods['q:rejuvTime'] = function(u)
    local name, _,_,_,_,_, expirationTime, fromwho = UnitAura(u, GetSpellInfo(774))
    if(fromwho == "player") then return getTime(expirationTime) end 
end
oUF.Tags.Events['q:rejuvTime'] = "UNIT_AURA"

oUF.Tags.Methods['q:regrow'] = function(u) if UnitAura(u, GetSpellInfo(8936)) then return "|cff00FF10"..x.."|r" end end
oUF.Tags.Events['q:regrow'] = "UNIT_AURA"

oUF.Tags.Methods['q:wg'] = function(u) if UnitAura(u, GetSpellInfo(48438)) then return "|cff33FF33"..x.."|r" end end
oUF.Tags.Events['q:wg'] = "UNIT_AURA"

oUF.Tags.Methods['q:motw'] = function(u) if not(UnitAura(u, GetSpellInfo(1126)) or UnitAura(u,GetSpellInfo(20217)) or UnitAura(u,GetSpellInfo(115921))) then return "|cff00A1DE"..x.."|r" end end
oUF.Tags.Events['q:motw'] = "UNIT_AURA"

-- Warrior
oUF.Tags.Methods['q:stragi'] = function(u) if not(UnitAura(u, GetSpellInfo(6673)) or UnitAura(u, GetSpellInfo(57330)) or UnitAura(u, GetSpellInfo(19506))) then return "|cffFF0000"..x.."|r" end end
oUF.Tags.Events['q:stragi'] = "UNIT_AURA"

-- Shaman
oUF.Tags.Methods['q:rip'] = function(u) 
    local name, _,_,_,_,_,_, fromwho = UnitAura(u, GetSpellInfo(61295))
    if(fromwho == 'player') then return "|cff00FEBF"..x.."|r" end
end
oUF.Tags.Events['q:rip'] = 'UNIT_AURA'

oUF.Tags.Methods['q:ripTime'] = function(u)
    local name, _,_,_,_,_, expirationTime, fromwho = UnitAura(u, GetSpellInfo(61295))
    if(fromwho == "player") then return getTime(expirationTime) end 
end
oUF.Tags.Events['q:ripTime'] = 'UNIT_AURA'

local earthCount = {'i','h','g','f','p','q','Z','Z','Y'}
oUF.Tags.Methods['q:earth'] = function(u) 
    local c = select(4, UnitAura(u, GetSpellInfo(974))) if c then return '|cffFFCF7F'..earthCount[c]..'|r' end 
end
oUF.Tags.Events['q:earth'] = 'UNIT_AURA'

-- Paladin
oUF.Tags.Methods['q:might'] = function(u) if not(UnitAura(u, GetSpellInfo(109773))) then return "|cffFF0000"..x.."|r" end end
oUF.Tags.Events['q:might'] = "UNIT_AURA"

oUF.Tags.Methods['q:beacon'] = function(u)
    local name, _,_,_,_,_,_, fromwho = UnitAura(u, GetSpellInfo(53563))
    if not name then return end
    if(fromwho == "player") then
        return "|cffFFCC003|r"
    else
        return "|cff996600Y|r" -- other pally's beacon
    end
end
oUF.Tags.Events['q:beacon'] = "UNIT_AURA"

oUF.Tags.Methods['q:forbearance'] = function(u) if UnitDebuff(u, GetSpellInfo(25771)) then return "|cffFF9900"..x.."|r" end end
oUF.Tags.Events['q:forbearance'] = "UNIT_AURA"

oUF.Tags.Methods['q:sacred'] = function(u)
    local name, _,_,_,_,_,_, fromwho = UnitAura(u, GetSpellInfo(20925))
    if not name then return end
    if(fromwho == "player") then
        return "|cffFFCC00"..x.."|r"
    end
end
oUF.Tags.Events['q:sacred'] = "UNIT_AURA"

oUF.Tags.Methods['q:eternalTime'] = function(u)
    local name, _,_,_,_,_, expirationTime, fromwho = UnitAura(u, GetSpellInfo(114163))
    if(fromwho == "player") then return getTime(expirationTime) end 
end
oUF.Tags.Events['q:eternalTime'] = "UNIT_AURA"

-- Warlock
oUF.Tags.Methods['q:di'] = function(u) 
    local name, _,_,_,_,_,_, fromwho = UnitAura(u, GetSpellInfo(109773))
    if fromwho == "player" then
        return "|cff6600FF"..x.."|r"
    elseif name then
        return "|cffCC00FF"..x.."|r"
    end
end
oUF.Tags.Events['q:di'] = "UNIT_AURA"

oUF.Tags.Methods['q:ss'] = function(u) 
    local name, _,_,_,_,_,_, fromwho = UnitAura(u, GetSpellInfo(20707)) 
    if fromwho == "player" then
        return "|cff6600FFY|r"
    elseif name then
        return "|cffCC00FFY|r"
    end
end
oUF.Tags.Events['q:ss'] = "UNIT_AURA"

-- Mage
oUF.Tags.Methods['q:int'] = function(u) if not(UnitAura(u, GetSpellInfo(1459)) or UnitAura(u, GetSpellInfo(61316))) then return "|cff00A1DE"..x.."|r" end end
oUF.Tags.Events['q:int'] = "UNIT_AURA"

-- Monk
oUF.Tags.Methods['q:zs'] = function(u) if UnitAura(u, GetSpellInfo(124081)) then return "|cff97FFFF"..x.."|r" end end -- 阳屦?溺屙
oUF.Tags.Events['q:zs'] = "UNIT_AURA"

oUF.Tags.Methods['q:remist'] = function(u) -- 青骅怆栝 蝮爨?
local name, _,_,_,_,_, expirationTime, fromwho = UnitAura(u, GetSpellInfo(119611))
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
oUF.Tags.Events['q:remist'] = "UNIT_AURA"
ns.classIndicators={
    ["DRUID"] = {
        ["TL"] = "",
        ["TR"] = "[q:motw]",
        ["BL"] = "[q:regrow][q:wg]",
        ["BR"] = "[q:lb]",
        ["Cen"] = "[q:rejuvTime]",
    },
    ["PRIEST"] = {
        ["TL"] = "[q:pws][q:ws]",
        ["TR"] = "[q:fw][q:fort]",
        ["BL"] = "[q:rnw][q:pwb]",
        ["BR"] = "[q:pom]",
        ["Cen"] = "[q:rnwTime]",
    },
    ["PALADIN"] = {
        ["TL"] = "[q:forbearance]",
        ["TR"] = "[q:might][q:motw]",
        ["BL"] = "[q:sacred]",
        ["BR"] = "[q:beacon]",
        ["Cen"] = "[q:eternalTime]",
    },
    ["WARLOCK"] = {
        ["TL"] = "",
        ["TR"] = "[q:di]",
        ["BL"] = "",
        ["BR"] = "[q:ss]",
        ["Cen"] = "",
    },
    ["WARRIOR"] = {
        ["TL"] = "",
        ["TR"] = "[q:stragi][q:fort]",
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
        ["TL"] = "[q:rip]",
        ["TR"] = "",
        ["BL"] = "",
        ["BR"] = "[q:earth]",
        ["Cen"] = "[q:ripTime]",
    },
    ["HUNTER"] = {
        ["TL"] = "",
        ["TR"] = "",
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
        ["TR"] = "[q:int]",
        ["BL"] = "",
        ["BR"] = "",
        ["Cen"] = "",
    },
    ["MONK"] = {
	["TL"] = "[q:zs]",
	["TR"] = "[q:remist]",
	["BL"] = "",
	["BR"] = "",
	["Cen"] = "",
},
}
