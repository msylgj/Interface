  local addon, ns = ...
  local cfg = CreateFrame("Frame")

  cfg.nameplates = {
  
  -- MEDIA
	font = "Fonts\\ARKai_T.ttf",
	icontex = "Interface\\AddOns\\m_Nameplates\\media\\iconborder",
	backdrop_edge = "Interface\\AddOns\\m_Nameplates\\media\\glowTex",
	statusbar = "Interface\\AddOns\\m_Nameplates\\media\\statusbar",
	
  -- CONFIG
	fontsize = 10,					-- Font size for Name and HP text
	fontflag = "THINOUTLINE",		-- Text outline
	hpHeight = 9,					-- Health bar height
	hpWidth = 110,					-- Health bar width
	namecolor = false,				-- Colorize names based on reaction
	raidIconSize = 25,				-- Raid icon size
	combat_toggle = true, 			-- If set to true nameplates will be automatically toggled on when you enter the combat
	castbar = {
		icon_size = 20,				-- Cast bar icon size
		height = 6,					-- Cast bar height
	},
  }
  

  -- HANDOVER
  ns.cfg = cfg
