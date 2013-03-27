  local addon, ns = ...
  local cfg = CreateFrame("Frame")

  -----------------------------
  -- CONFIG
  -----------------------------
	cfg.lock_map_position = false					-- lock your map in set position
	cfg.decimal_coords = false						-- displays decimal expansion @ coordinates' values
	cfg.mpos = {"CENTER",UIParent,"CENTER",0,65}	-- set position for locked map
	cfg.map_scale = 0.9								-- Mini World Map scale
	cfg.isize = 20									-- raid icon (dot) size
	cfg.remove_fog = true							-- remove fog from the map
	
  
  -- HANDOVER
  ns.cfg = cfg
