



------------
--  设置  --
------------

local cfg = CreateFrame("Frame")
local Media = "Interface\\AddOns\\Sora's Reminder\\Media\\"
cfg.Font = "Fonts\\ARKai_T.ttf"
cfg.Solid = Media.."solid"
cfg.GlowTex = Media.."glowTex"
cfg.Warning = Media.."Warning.mp3"


cfg.RaidBuffSize = 21											 -- RaidBuff图标大小  
cfg.RaidBuffSpace = 1											 -- RaidBuff图标间距
cfg.RaidBuffDirection = 2										 -- RaidBuff图标排列方向 1-横排 2-竖排
cfg.RaidBuffPos = {"BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -1, 170} -- RaidBuff图标位置   
cfg.ShowOnlyInParty = false										 -- 只在队伍中显示RaidBuff图标
cfg.LeaderMod = false                                           -- 团长模式,看到所有团队BUFF状态,不看食物和合剂

cfg.ClassBuffSize = 48											 -- ClassBuff图标大小
cfg.ClassBuffSpace = 40                                       -- ClassBuff图标间隔
cfg.ClassBuffPos = {"CENTER", UIParent, "CENTER", 0, 200}	     -- ClassBuff图标位置
cfg.ClassBuffSound = false                                   -- ClassBuff缺失声音提示


----------------
--  命名空间  --
----------------

local _, SR = ...
SR.RDConfig = cfg

