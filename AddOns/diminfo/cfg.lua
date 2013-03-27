local addon, ns = ...
local cfg = CreateFrame("Frame")

-- enable modules
cfg.Bags = true
cfg.BagsPoint = {"bottom", UIParent, "bottomleft", 50, 1}

cfg.Coords = true
cfg.CoordsPoint = {"bottom", Minimap, 0, 1}

cfg.Durability = true
cfg.DurabilityPoint = {"bottom", UIParent, "bottomleft", 150, 1}

cfg.Friends = true
cfg.FriendsPoint = {"top", UIParent, "topleft", 150, -8}

cfg.Gold = true
cfg.GoldPoint = {"bottom", UIParent, "bottomright", -100, 1}

cfg.Guild = true
cfg.GuildPoint = {"top", UIParent, "topleft", 250, -8}

cfg.Mail = true
cfg.MailPoint = {"bottom", UIParent, "bottomleft", 250, 1}

cfg.Memory = true
cfg.MemoryPoint = {"top", UIParent, "topright", -200, -8}
cfg.MaxAddOns = 20

cfg.Positions = true
cfg.PositionsPoint = {"top", UIParent, "top", 0, -8}

cfg.Spec = true
cfg.SpecPoint = {"bottomright", UIParent, -210, 1}

cfg.System = true
cfg.SystemPoint = {"top", UIParent, "topright", -80, -8}

cfg.Time = true
cfg.TimePoint = {"top", UIParent, "topleft", 50, -8}
--Fonts and Colors
cfg.Fonts = {"Fonts\\ARKai_T.ttf", 10, "outline"}
cfg.ColorClass = true


ns.cfg = cfg