  local addon, ns = ...
  local cfg = CreateFrame("Frame")

  -----------------------------
  -- MEDIA
  -----------------------------
  local MediaPath = "Interface\\AddOns\\m_Loot\\media\\"
  
  cfg.bartex =		MediaPath.."statusbar"
  cfg.bordertex =	MediaPath.."icon_clean"	
  cfg.fontn =		"Fonts\\ARKai_T.ttf"	
  cfg.edgetex = 	"Interface\\Tooltips\\UI-Tooltip-Border"
  cfg.loottex =		"Interface\\QuestFrame\\UI-QuestLogTitleHighlight"
  cfg.blanktex = "Interface\\Buttons\\WHITE8x8"
  cfg.glow = MediaPath.."glow"
  -----------------------------
  -- CONFIG
  -----------------------------
  cfg.iconsize = 30 					-- loot frame icon's size
  
  -- HANDOVER
  ns.cfg = cfg
