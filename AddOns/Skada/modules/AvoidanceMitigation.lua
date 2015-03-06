Skada:AddLoadableModule("Avoidance and mitigation", function(Skada, L)
if Skada.db.profile.modulesBlocked.Avoidanceandmitigation then return end

local Skada = Skada

local band = 
      bit.band

local mod = Skada:NewModule(L["Avoidance and mitigation"])
local reduction_breakdown_mod = Skada:NewModule(L["incoming attack breakdown"])

local AUTO_ATTACK = GetSpellInfo(6603)
local CRUSH = TEXT_MODE_A_STRING_RESULT_CRUSHING:gsub("%p","")
local GLANCE = TEXT_MODE_A_STRING_RESULT_GLANCING:gsub("%p","")
local CRIT = CRIT_ABBR
local FULLABSORB = LOC_TYPE_FULL.." "..ABSORB
local SPELLHIT = PLAYERSTAT_SPELL_COMBAT.." "..HIT
local PHYSICALHIT = SPELL_SCHOOL0_CAP.." "..HIT

local function capitalize(str)
  local retval = ""
  str = tostring(str)
  retval = str:sub(1,1):upper() .. str:sub(2):lower()
  return retval
end

local dmg = {}

local function log_attack_result(set)
  -- Get the player.
  local player = Skada:get_player(set, dmg.playerid, dmg.playername)
  if player and player.sam_breakdown and dmg.result then
    -- Add to player breakdown

    player.sam_breakdown[dmg.result] = (player.sam_breakdown[dmg.result] or 0) + 1
    player.sam_total_events = (player.sam_total_events or 0) + 1
    player.sam_total_dmg = (player.sam_total_dmg or 0) + (dmg.amt or 0) + (dmg.absorb or 0) + (dmg.block or 0)
    if dmg.absorb and dmg.absorb > 0 then
      player.sam_absorb =     (player.sam_absorb or 0) +    dmg.absorb
      player.sam_absorb_pp =  (player.sam_absorb_pp or 0) + (dmg.absorb / (dmg.absorb + (dmg.amt or 0)))
      player.sam_absorb_cnt = (player.sam_absorb_cnt or 0) + 1
    end
    if dmg.block and dmg.block > 0 then -- combat table: block amount is calculated before absorb
      player.sam_block =     (player.sam_block or 0) +     dmg.block
      player.sam_block_pp =  (player.sam_block_pp or 0) + (dmg.block / (dmg.block + (dmg.absorb or 0) + (dmg.amt or 0)))
      player.sam_block_cnt = (player.sam_block_cnt or 0) + 1
    end
  end
end
 
local function Damage(spellSchool, ...)
  local amt, amt_overkill, spell_school, amt_resisted, amt_blocked, amt_absorbed, crit_flag, glancing_flag, crush_flag = ...
  dmg.amt = (amt or 0) + (amt_overkill or 0)
  dmg.block = amt_blocked or 0
  dmg.absorb = amt_absorbed or 0
  if dmg.block > 0 then
    dmg.result = BLOCK
  elseif dmg.absorb > 0 then
    dmg.result = ABSORB
  elseif glancing_flag then
    dmg.result = GLANCE
  elseif crit_flag then
    dmg.result = CRIT
  elseif crush_flag then
    dmg.result = CRUSH
  elseif band(spellSchool, 0x1) > 0 then
    dmg.result = PHYSICALHIT
  else
    dmg.result = SPELLHIT
  end

  log_attack_result(Skada.current)
  log_attack_result(Skada.total)
end

local function SwingDamage(timestamp, eventtype, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, ...)
  -- White melee.

  wipe(dmg)
  dmg.playerid = dstGUID
  dmg.playername = dstName
  --dmg.spellid = 6603
  --dmg.spellname = AUTO_ATTACK

  Damage(0x1, ...)
end

local function SpellDamage(timestamp, eventtype, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, 
                           spellId, spellName, spellSchool, ...)
  local spellId, spellName, spellSchool, amt, amt_overkill, spell_school, amt_resisted, amt_blocked, amt_absorbed, crit_flag, glancing_flag, crush_flag = ...

  wipe(dmg)
  dmg.playerid = dstGUID
  dmg.playername = dstName
  --dmg.spellid = spellId
  --dmg.spellname = spellName

  Damage(spellSchool, ...)
end

local function Missed(...)
  local miss_type, _, _, amount_missed = ...
  -- Treat absorbed attacks as hits, since it has to 
  if miss_type == "ABSORB" then
    -- Clarify that 100% of the  damage was absorbed (meaning we can't
    -- tell if it was blocked, or otherwise partially reduced)
    dmg.result = FULLABSORB
    dmg.absorb = amount_missed
  else
    local mu = miss_type:upper()
    dmg.result = _G[mu] or 
                 _G["ACTION_SPELL_MISSED_"..mu] or 
                 _G["ACTION_SWING_MISSED_"..mu] or 
		 L[mu]
    dmg.result:gsub("%p","")
  end

  log_attack_result(Skada.current)
  log_attack_result(Skada.total)
end

local function SwingMissed(timestamp, eventtype, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, ...)

  wipe(dmg)
  dmg.playerid = dstGUID
  dmg.playername = dstName
  --dmg.spellid = 6603
  --dmg.spellname = AUTO_ATTACK

  Missed(...)
end

local function SpellMissed(timestamp, eventtype, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, 
                           spellId, spellName, spellSchool, ...)

  wipe(dmg)
  dmg.playerid = dstGUID
  dmg.playername = dstName
  --dmg.spellid = spellId
  --dmg.spellname = spellName

  Missed(...)
end

-- Update the data set displayed
function mod:Update(win, set)
  local max = 0
  local hit_count = 0
    
  local nr = 1
  for i, player in ipairs(set.players) do

    -- next returns nil if the table is empty
    if next(player.sam_breakdown) then
      local d = win.dataset[nr] or {}
      win.dataset[nr] = d

      local total = player.sam_total_events or 1
      local hit_count = 
         (player.sam_breakdown[PHYSICALHIT] or 0) +
         (player.sam_breakdown[SPELLHIT] or 0) +
         (player.sam_breakdown[GLANCE] or 0) +
         (player.sam_breakdown[CRIT] or 0) +
         (player.sam_breakdown[CRUSH] or 0)

      local avoid_count = total - hit_count

      d.label = player.name
      d.value = (avoid_count * 100.0 / total)
      d.valuetext = ("%02.2f%% (%d)"):format(d.value, avoid_count)
      d.id = player.id
      d.class = player.class

      if d.value > max then
        max = d.value
      end
      nr = nr + 1
    end
  end

  win.metadata.maxvalue = max
end

-- Tooltip for a specific player.
-- This is a post-tooltip
local function mitigation_tooltip(win, id, label, tooltip)
        local set = win:get_selected_set()
        local player = Skada:find_player(set, id)
        --ChatFrame4:AddMessage(("Set: %s, id: %s"):format(set, id))
        if player then
	    local space
	    if (player.sam_absorb or 0) > 0 and (player.sam_absorb_cnt or 0) > 0 then
                tooltip:AddDoubleLine(L["Average"].." "..ABSORB, 
                        Skada:FormatNumber(player.sam_absorb / player.sam_absorb_cnt)..
                        (" (%02.2f%%)"):format(100.0*(player.sam_absorb_pp or 0) / player.sam_absorb_cnt))
		if (player.sam_total_dmg or 0) > 0 then
                  tooltip:AddDoubleLine(TOTAL.." "..ABSORB, 
                        Skada:FormatNumber(player.sam_absorb)..
                        (" (%02.2f%%)"):format(100.0*player.sam_absorb / player.sam_total_dmg))
		end
		space = true
	    end
	    if (player.sam_block or 0) > 0 and (player.sam_block_cnt or 0) > 0 then
		if space then tooltip:AddLine(" ") end
                tooltip:AddDoubleLine(L["Average"].." "..BLOCK, 
                        Skada:FormatNumber(player.sam_block / player.sam_block_cnt)..
                        (" (%02.2f%%)"):format(100.0*(player.sam_block_pp or 0) / player.sam_block_cnt))
		if (player.sam_total_dmg or 0) > 0 then
                   tooltip:AddDoubleLine(TOTAL.." "..BLOCK, 
                        Skada:FormatNumber(player.sam_block)..
                        (" (%02.2f%%)"):format(100.0*player.sam_block / player.sam_total_dmg))
		end
	    end
        end
end

function mod:OnEnable()
  mod.metadata                     = {showspots = true, click1 = reduction_breakdown_mod, post_tooltip=mitigation_tooltip}
  reduction_breakdown_mod.metadata = { }

  Skada:RegisterForCL(SwingDamage, 'SWING_DAMAGE', {dst_is_interesting_nopets = true})
  Skada:RegisterForCL(SwingMissed, 'SWING_MISSED', {dst_is_interesting_nopets = true})
  Skada:RegisterForCL(SpellDamage, 'SPELL_DAMAGE', {dst_is_interesting_nopets = true})
  Skada:RegisterForCL(SpellDamage, 'RANGE_DAMAGE', {dst_is_interesting_nopets = true})
  Skada:RegisterForCL(SpellMissed, 'SPELL_MISSED', {dst_is_interesting_nopets = true})
  Skada:RegisterForCL(SpellMissed, 'RANGE_MISSED', {dst_is_interesting_nopets = true})

  Skada:AddMode(self)
end

function mod:OnDisable()
  Skada:RemoveMode(self)
end

-- Called by Skada when a new player is added to a set.
function mod:AddPlayerAttributes(player)
  if not player.sam_breakdown then
    player.sam_breakdown = {}
    player.sam_total_events = 0
  end
end


function reduction_breakdown_mod:Enter(win, id, label)
  local player = Skada:find_player(win:get_selected_set(), id)
  reduction_breakdown_mod.playerid = id
  reduction_breakdown_mod.title = (player and player.name or UNKNOWN)
                                  ..": "..L["incoming attack breakdown"]
end

-- Player view showing breakdown of damage reduction
function reduction_breakdown_mod:Update(win, set)
  local player = Skada:find_player(set, self.playerid)
  local max = 0
	
  -- If we reset we have no data.
  if player then
    
    local nr = 1
    for mtype, count in pairs(player.sam_breakdown) do
      local d = win.dataset[nr] or {}
      win.dataset[nr] = d

      d.label = mtype
      d.id = mtype
      d.value = (count / (player.sam_total_events or 1)) * 100
      d.valuetext = ("%d"):format(count)..(" (%02.2f%%)"):format(d.value)

      if d.value > max then
        max = d.value
      end

      nr = nr + 1
    end
  end

  win.metadata.maxvalue = max
end
end)