local _, sakaras = ...
local Misc = sakaras.FilgerSettings

Filger_Spells = {
	["DEATHKNIGHT"] = {			--[����]
		{
			Name = "P_BUFF_ICON",
			Direction = "LEFT",
			Mode = "ICON",
			Interval = 3,
			Alpha = 1,
			IconSize = Misc.IconSize,
			Position = {unpack(Filger_Settings.player_buff_icon)},

			-- Bone Shield
			{spellID = 49222, unitID = "player", caster = "player", filter = "BUFF"},
			-- Bone Wall (T16)
			{spellID = 144948, unitID = "player", caster = "player", filter = "BUFF"},
			-- Vampiric Blood
			{spellID = 55233, unitID = "player", caster = "player", filter = "BUFF"},
			-- Icebound Fortitude
			{spellID = 48792, unitID = "player", caster = "player", filter = "BUFF"},
			-- Anti-Magic Shell
			{spellID = 48707, unitID = "player", caster = "player", filter = "BUFF"},
			-- Dancing Rune Weapon
			{spellID = 81256, unitID = "player", caster = "player", filter = "BUFF"},
			-- Lichborne
			{spellID = 49039, unitID = "player", caster = "player", filter = "BUFF"},
			-- Pillar of Frost
			{spellID = 51271, unitID = "player", caster = "player", filter = "BUFF"},
			-- Death's Advance
			{spellID = 96268, unitID = "player", caster = "player", filter = "BUFF"},
			-- Unholy Blight
			{spellID = 115989, unitID = "player", caster = "player", filter = "BUFF"},
		},
		{
			Name = "P_PROC_ICON",
			Direction = "RIGHT",
			Mode = "ICON",
			Interval = 3,
			Alpha = 1,
			IconSize = Misc.IconSize,
			Position = {unpack(Filger_Settings.player_proc_icon)},

			-- Buffs
			-- Scent of Blood
			{spellID = 50421, unitID = "player", caster = "player", filter = "BUFF"},
			-- Crimson Scourge
			{spellID = 81141, unitID = "player", caster = "player", filter = "BUFF"},
			-- Freezing Fog
			{spellID = 59052, unitID = "player", caster = "player", filter = "BUFF"},
			-- Killing Machine
			{spellID = 51124, unitID = "player", caster = "player", filter = "BUFF"},
			-- Sudden Doom
			{spellID = 81340, unitID = "player", caster = "player", filter = "BUFF"},
			-- Unholy Strength
			{spellID = 53365, unitID = "player", caster = "player", filter = "BUFF"},
			-- Dark Transformation
			{spellID = 63560, unitID = "pet", caster = "player", filter = "BUFF"},
			-- Shadow Infusion
			{spellID = 91342, unitID = "pet", caster = "player", filter = "BUFF", count = 5},
			-- Blood Charge
			{spellID = 114851, unitID = "player", caster = "player", filter = "BUFF", count = 10},

			-- Trinkets
			-- General
			-- Darkmoon Cards (Proc)
			{spellID = 128985, unitID = "player", caster = "player", filter = "BUFF"},
			-- PvP Trinkets (Health, Use)
			{spellID = 126697, unitID = "player", caster = "player", filter = "BUFF"},
			-- Tank
			-- Rook's Unlucky Talisman (Reduces damage, Use)
			{spellID = 146343, unitID = "player", caster = "player", filter = "BUFF"},
			-- Resolve of Niuzao (Dodge, Use)
			{spellID = 146344, unitID = "player", caster = "player", filter = "BUFF"},
			-- Steadfast Talisman of the Shado-Pan Assault (Dodge, Use)
			{spellID = 138728, unitID = "player", caster = "player", filter = "BUFF"},
			-- Delicate Vial of the Sanguinaire (Mastery, Proc)
			{spellID = 138864, unitID = "player", caster = "player", filter = "BUFF"},
			-- Stuff of Nightmares (Dodge, Proc)
			{spellID = 126646, unitID = "player", caster = "player", filter = "BUFF"},
			-- Vial of Dragon's Blood (Dodge, Proc)
			{spellID = 126533, unitID = "player", caster = "player", filter = "BUFF"},
			-- Jade Warlord Figurine (Mastery, Use)
			{spellID = 126597, unitID = "player", caster = "player", filter = "BUFF"},
			-- Physical Strength DPS
			-- Evil Eye of Galakras (Strength, Proc)
			{spellID = 146245, unitID = "player", caster = "player", filter = "BUFF"},
			-- Thok's Tail Tip (Strength, Proc)
			{spellID = 146250, unitID = "player", caster = "player", filter = "BUFF", absID = true},
			-- Skeer's Bloodsoaked Talisman (Strength, Proc)
			{spellID = 146285, unitID = "player", caster = "player", filter = "BUFF"},
			-- Fusion-Fire Core (Strength, Proc)
			{spellID = 148899, unitID = "player", caster = "player", filter = "BUFF", absID = true},
			-- Celestial Celerity (Haste, Proc) [Alacrity of Xuen]
			{spellID = 146296, unitID = "player", caster = "player", filter = "BUFF"},
			-- Brutal Talisman of the Shado-Pan Assault (Strength, Proc)
			{spellID = 138702, unitID = "player", caster = "player", filter = "BUFF"},
			-- Fabled Feather of Ji-Kun (Strength, Proc)
			{spellID = 138759, unitID = "player", caster = "player", filter = "BUFF"},
			-- Spark of Zandalar (Strength, Proc)
			{spellID = 138958, unitID = "player", caster = "player", filter = "BUFF"},
			-- Primordius' Talisman of Rage (Strength, Proc)
			{spellID = 138870, unitID = "player", caster = "player", filter = "BUFF"},
			-- Gaze of the Twins (Crit, Proc)
			{spellID = 139170, unitID = "player", caster = "player", filter = "BUFF"},
			-- Helmbreaker Medallion (Crit, Use)
			{spellID = 136084, unitID = "player", caster = "player", filter = "BUFF"},
			-- Darkmist Vortex (Haste, Proc)
			{spellID = 126657, unitID = "player", caster = "player", filter = "BUFF"},
			-- Lei Shin's Final Orders (Strength, Proc)
			{spellID = 126582, unitID = "player", caster = "player", filter = "BUFF"},
			-- Jade Charioteer Figurine (Strength, Use)
			{spellID = 126599, unitID = "player", caster = "player", filter = "BUFF"},
			-- Iron Belly Wok (Haste, Use)
			{spellID = 129812, unitID = "player", caster = "player", filter = "BUFF"},
			-- PvP Trinkets (Strength, Use)
			{spellID = 126679, unitID = "player", caster = "player", filter = "BUFF"},
			-- PvP Trinkets (Strength, Proc)
			{spellID = 126700, unitID = "player", caster = "player", filter = "BUFF"},

			-- Enchants
			-- General
			-- Tank
			-- River's Song (Dodge)
			{spellID = 116660, unitID = "player", caster = "all", filter = "BUFF"},
			-- Physical General
			-- Physical Melee
			-- Dancing Steel (Strength)
			{spellID = 120032, unitID = "player", caster = "all", filter = "BUFF"},

			-- ��ɫ���
			-- ����֮Դ�� (����, ����)
			{spellID = 137593, unitID = "player", caster = "all", filter = "BUFF", absID = true},
		},
		{
			Name = "T_DE/BUFF_BAR",
			enable = Misc.Tbar,
			Direction = "UP",
			IconSide = "LEFT",
			Mode = "BAR",
			Interval = 3,
			Alpha = 1,
			IconSize = Misc.barIconSize,
			BarWidth = Misc.barw,
			Position = {unpack(Filger_Settings.target_bar)},

			-- Blood Plague
			{spellID = 55078, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- Frost Fever
			{spellID = 55095, unitID = "target", caster = "player", filter = "DEBUFF"},
		},
		{
			Name = "COOLDOWN",
			enable = Misc.CD,
			Direction = "RIGHT",
			Mode = "ICON",
			NumPerLine = Misc.CDnum,
			Interval = 3,
			Alpha = 1,
			IconSize = Misc.CDIconSize,
			Position = {unpack(Filger_Settings.cooldown)},

			-- Self
			-- Mind Freeze
			{spellID = 47528, filter = "CD"},
			-- Strangulate
			{spellID = 47476, filter = "CD"},
			-- Gnaw (Ghoul)
			{spellID = 47481, filter = "CD"},
			-- Remorseless Winter
			{spellID = 108200, filter = "CD"},
			-- Dark Simulacrum
			{spellID = 77606, filter = "CD"},
			-- Soul Reaper
			{spellID = 130736, filter = "CD"},
			-- Death Grip
			{spellID = 49576, filter = "CD"},
			-- Plague Leech
			{spellID = 123693, filter = "CD"},
			-- Rune Tap
			{spellID = 48982, filter = "CD"},
			-- Death and Decay
			{spellID = 43265, filter = "CD"},
			-- Death's Advance
			{spellID = 96268, filter = "CD"},
			-- Anti-Magic Shell
			{spellID = 48707, filter = "CD"},
			-- Vampiric Blood
			{spellID = 55233, filter = "CD"},
			-- Outbreak
			{spellID = 77575, filter = "CD"},
			-- Pillar of Frost
			{spellID = 51271, filter = "CD"},
			-- Gorefiend's Grasp
			{spellID = 108199, filter = "CD"},
			-- Dancing Rune Weapon
			{spellID = 49028, filter = "CD"},
			-- Unholy Blight
			{spellID = 115989, filter = "CD"},
			-- Lichborne
			{spellID = 49039, filter = "CD"},
			-- Desecrated Ground
			{spellID = 108201, filter = "CD"},
			-- Death Pact
			{spellID = 48743, filter = "CD"},
			-- Raise Dead
			{spellID = 46584, filter = "CD"},
			-- Anti-Magic Zone
			{spellID = 51052, filter = "CD"},
			-- Icebound Fortitude
			{spellID = 48792, filter = "CD"},
			-- Summon Gargoyle
			{spellID = 49206, filter = "CD"},

			-- Racial
			-- Every Man for Himself (Human)
			{spellID = 59752, filter = "CD"},
			-- Stoneform (Dwarf)
			{spellID = 20594, filter = "CD"},
			-- Shadowmeld (Night Elf)
			{spellID = 58984, filter = "CD"},
			-- Escape Artist (Gnome)
			{spellID = 20589, filter = "CD"},
			-- Gift of the Naaru (Draenei)
			{spellID = 28880, filter = "CD"},
			-- Darkflight (Worgen)
			{spellID = 68992, filter = "CD"},
			-- Blood Fury (Orc)
			{spellID = 20572, filter = "CD"},
			-- Will of the Forsaken (Forsaken)
			{spellID = 7744, filter = "CD"},
			-- Cannibalize (Forsaken)
			{spellID = 20577, filter = "CD"},
			-- War Stomp (Tauren)
			{spellID = 20549, filter = "CD"},
			-- Berserking (Troll)
			{spellID = 26297, filter = "CD"},
			-- Arcane Torrent (Blood Elf)
			{spellID = 69179, filter = "CD"},
			-- Rocket Jump (Goblin)
			{spellID = 69070, filter = "CD"},

			-- Items
			-- Gloves
			{slotID = 10, filter = "CD"},
			-- Belt
			{slotID = 6, filter = "CD"},
			-- Back
			{slotID = 15, filter = "CD"},
			-- Trinkets
			{slotID = 13, filter = "CD"},
			{slotID = 14, filter = "CD"},

			-- Internal
			-- Shroud of Purgatory
			--{spellID = 116888, filter = "ICD", trigger = "BUFF", duration = 180},
		},
	},
	["DRUID"] = {			--[С��]
		{
			Name = "P_BUFF_ICON",
			Direction = "LEFT",
			Mode = "ICON",
			Interval = 3,
			Alpha = 1,
			IconSize = Misc.IconSize,
			Position = {unpack(Filger_Settings.player_buff_icon)},

			-- Cenarion Ward
			{spellID = 102351, unitID = "player", caster = "player", filter = "BUFF"},
			-- Incarnation: Tree of Life
			{spellID = 117679, unitID = "player", caster = "player", filter = "BUFF"},
			-- Incarnation: Chosen of Elunee
			{spellID = 102560, unitID = "player", caster = "player", filter = "BUFF"},
			-- Incarnation: King of the Jungle
			{spellID = 102543, unitID = "player", caster = "player", filter = "BUFF"},
			-- Incarnation: Son of Ursoc
			{spellID = 102558, unitID = "player", caster = "player", filter = "BUFF"},
			-- Nature's Vigil
			{spellID = 124974, unitID = "player", caster = "player", filter = "BUFF"},
			-- Survival Instincts
			{spellID = 61336, unitID = "player", caster = "player", filter = "BUFF"},
			-- Barkskin
			{spellID = 22812, unitID = "player", caster = "player", filter = "BUFF"},
			-- Savage Defense
			{spellID = 132402, unitID = "player", caster = "player", filter = "BUFF"},
			-- Savage Roar
			{spellID = 52610, unitID = "player", caster = "player", filter = "BUFF"},
			-- Berserk
			{spellID = 50334, unitID = "player", caster = "player", filter = "BUFF"},
			-- Tiger's Fury
			{spellID = 5217, unitID = "player", caster = "player", filter = "BUFF"},
			-- Celestial Alignment
			{spellID = 112071, unitID = "player", caster = "player", filter = "BUFF"},
			-- Heart of the Wild
			{spellID = 108294, unitID = "player", caster = "player", filter = "BUFF"},
			-- Starfall
			{spellID = 48505, unitID = "player", caster = "player", filter = "BUFF"},
			-- Nature's Grasp
			{spellID = 170856, unitID = "player", caster = "player", filter = "BUFF"},
			-- Dash
			{spellID = 1850, unitID = "player", caster = "player", filter = "BUFF"},
		},
		{
			Name = "P_PROC_ICON",
			Direction = "RIGHT",
			Mode = "ICON",
			Interval = 3,
			Alpha = 1,
			IconSize = Misc.IconSize,
			Position = {unpack(Filger_Settings.player_proc_icon)},

			-- Buffs
			-- Bloodtalons
			{spellID = 145152, unitID = "player", caster = "player", filter = "BUFF"},
			-- Lunar Peak
			{spellID = 171743, unitID = "player", caster = "player", filter = "BUFF"},
			-- Solar Peak
			{spellID = 171744, unitID = "player", caster = "player", filter = "BUFF"},
			-- Glyph of Rejuvenation
			{spellID = 96206, unitID = "player", caster = "player", filter = "BUFF"},
			-- Clearcasting
			{spellID = 16870, unitID = "player", caster = "player", filter = "BUFF"},
			-- Soul of the Forest
			{spellID = 114108, unitID = "player", caster = "player", filter = "BUFF"},
			-- Tooth and Claw
			{spellID = 135286, unitID = "player", caster = "player", filter = "BUFF"},
			-- Predator's Swiftness
			{spellID = 69369, unitID = "player", caster = "player", filter = "BUFF"},
			
			-- Item sets ��װ
			-- Sage Mender (����T16)
			{spellID = 144871, unitID = "player", caster = "player", filter = "BUFF"},
			
			-- Trinkets
			-- General
			-- Darkmoon Cards (Proc)
			{spellID = 128985, unitID = "player", caster = "player", filter = "BUFF"},
			-- PvP Trinkets (Health, Use)
			{spellID = 126697, unitID = "player", caster = "player", filter = "BUFF"},
			-- Tank
			-- Rook's Unlucky Talisman (Reduces damage, Use)
			{spellID = 146343, unitID = "player", caster = "player", filter = "BUFF"},
			-- Resolve of Niuzao (Dodge, Use)
			{spellID = 146344, unitID = "player", caster = "player", filter = "BUFF"},
			-- Steadfast Talisman of the Shado-Pan Assault (Dodge, Use)
			{spellID = 138728, unitID = "player", caster = "player", filter = "BUFF"},
			-- Delicate Vial of the Sanguinaire (Mastery, Proc)
			{spellID = 138864, unitID = "player", caster = "player", filter = "BUFF"},
			-- Stuff of Nightmares (Dodge, Proc)
			{spellID = 126646, unitID = "player", caster = "player", filter = "BUFF"},
			-- Vial of Dragon's Blood (Dodge, Proc)
			{spellID = 126533, unitID = "player", caster = "player", filter = "BUFF"},
			-- Jade Warlord Figurine (Mastery, Use)
			{spellID = 126597, unitID = "player", caster = "player", filter = "BUFF"},
			-- Physical Agility DPS
			-- Assurance of Consequence (Agility, Proc)
			{spellID = 146308, unitID = "player", caster = "player", filter = "BUFF"},
			-- Haromm's Talisman (Agility, Proc)
			{spellID = 148903, unitID = "player", caster = "player", filter = "BUFF"},
			-- Sigil of Rampage (Agility, Proc)
			{spellID = 148896, unitID = "player", caster = "player", filter = "BUFF"},
			-- Ticking Ebon Detonator (Agility, Proc)
			{spellID = 146310, unitID = "player", caster = "player", filter = "BUFF"},
			-- Discipline of Xuen (Crit, Proc)
			{spellID = 146312, unitID = "player", caster = "player", filter = "BUFF"},
			-- Vicious Talisman of the Shado-Pan Assault (Agility, Proc)
			{spellID = 138699, unitID = "player", caster = "player", filter = "BUFF"},
			-- Bad Juju (Agility, Proc)
			{spellID = 138938, unitID = "player", caster = "player", filter = "BUFF"},
			-- Talisman of Bloodlust (Haste, Proc)
			{spellID = 138895, unitID = "player", caster = "player", filter = "BUFF"},
			-- Rune of Re-Origination (Convert, Proc)
			{spellID = 139120, unitID = "player", caster = "player", filter = "BUFF"},
			-- Renataki's Soul Charm (Agility, Proc)
			{spellID = 138756, unitID = "player", caster = "player", filter = "BUFF"},
			-- Arrowflight Medallion (Crit, Use)
			{spellID = 136086, unitID = "player", caster = "player", filter = "BUFF"},
			-- Terror in the Mists (Crit, Proc)
			{spellID = 126649, unitID = "player", caster = "player", filter = "BUFF"},
			-- Jade Bandit Figurine (Haste, Use)
			{spellID = 126599, unitID = "player", caster = "player", filter = "BUFF"},
			-- Bottle of Infinite Stars (Agility, Proc)
			{spellID = 126554, unitID = "player", caster = "player", filter = "BUFF"},
			-- PvP Trinkets (Agility, Use)
			{spellID = 126690, unitID = "player", caster = "player", filter = "BUFF"},
			-- PvP Trinkets (Agility, Proc)
			{spellID = 126707, unitID = "player", caster = "player", filter = "BUFF"},
			-- Caster General
			-- Shock-Charger Medallion Figurine (Intellect, Use)
			{spellID = 136082, unitID = "player", caster = "player", filter = "BUFF"},
			-- Jade Magistrate Figurine (Crit, Use)
			{spellID = 126605, unitID = "player", caster = "player", filter = "BUFF"},
			-- PvP Trinkets (Spell Power, Use)
			{spellID = 126683, unitID = "player", caster = "player", filter = "BUFF"},
			-- PvP Trinkets (Spell Power, Proc)
			{spellID = 126705, unitID = "player", caster = "player", filter = "BUFF"},
			-- Caster DPS
			-- Purified Bindings of Immerseus (Intellect, Proc)
			{spellID = 146046, unitID = "player", caster = "player", filter = "BUFF"},
			-- Kardris' Toxic Totem (Intellect, Proc)
			{spellID = 148906, unitID = "player", caster = "player", filter = "BUFF"},
			-- Frenzied Crystal of Rage (Intellect, Proc)
			{spellID = 148897, unitID = "player", caster = "player", filter = "BUFF"},
			-- Black Blood of Y'Shaarj (Intellect, Proc)
			{spellID = 146184, unitID = "player", caster = "player", filter = "BUFF"},
			-- Yu'lon's Bite (Crit, Proc)
			{spellID = 146218, unitID = "player", caster = "player", filter = "BUFF"},
			-- ����ľ�׼֮��
			{spellID = 138963, unitID = "player", caster = "player", filter = "BUFF"},
			-- Volatile Talisman of the Shado-Pan Assault (Haste, Proc)
			{spellID = 138703, unitID = "player", caster = "player", filter = "BUFF"},
			-- Cha-Ye's Essence of Brilliance (Intellect, Proc)
			{spellID = 139133, unitID = "player", caster = "player", filter = "BUFF"},
			-- Breath of the Hydra (Intellect, Proc)
			{spellID = 138898, unitID = "player", caster = "player", filter = "BUFF"},
			-- Wushoolay's Final Choice (Intellect, Proc)
			{spellID = 138786, unitID = "player", caster = "player", filter = "BUFF"},
			-- Essence of Terror (Haste, Proc)
			{spellID = 126659, unitID = "player", caster = "player", filter = "BUFF"},
			-- Light of the Cosmos (Intellect, Proc)
			{spellID = 126577, unitID = "player", caster = "player", filter = "BUFF"},
			-- Caster Heal
			-- Prismatic Prison of Pride (Intellect, Proc)
			{spellID = 146314, unitID = "player", caster = "player", filter = "BUFF"},
			-- Nazgrim's Burnished Insignia (Intellect, Proc)
			{spellID = 148908, unitID = "player", caster = "player", filter = "BUFF"},
			-- Thok's Acid-Grooved Tooth (Intellect, Proc)
			{spellID = 148911, unitID = "player", caster = "player", filter = "BUFF"},
			-- Qin-xi's Polarizing Seal (Intellect, Proc)
			{spellID = 126588, unitID = "player", caster = "player", filter = "BUFF"},

			-- Enchants
			-- General
			-- Tank
			-- River's Song (Dodge)
			{spellID = 116660, unitID = "player", caster = "all", filter = "BUFF"},
			-- Physical General
			-- Physical Melee
			-- Dancing Steel (Agility)
			{spellID = 120032, unitID = "player", caster = "all", filter = "BUFF"},
			-- Caster General
			-- Jade Spirit (Intellect + Spirit)
			{spellID = 104993, unitID = "player", caster = "all", filter = "BUFF"},
			-- Lightweave (Intellect)
			--{spellID = 125487, unitID = "player", caster = "player", filter = "BUFF"},
			-- Caster Heal
			
			-- ��ɫ���
			-- ����֮Դ�� (����, ����)
			{spellID = 137593, unitID = "player", caster = "all", filter = "BUFF", absID = true},
			-- ����֮Դ�� (����, ����)
			{spellID = 137590, unitID = "player", caster = "all", filter = "BUFF"},
			-- Ӣ��֮Դ�� (����, ����)
			{spellID = 137288, unitID = "player", caster = "all", filter = "BUFF"},

			-- ʷʫ����
			-- Spirit of Chi-Ji
			{spellID = 146200, unitID = "player", caster = "all", filter = "BUFF"},
		},
		{
			Name = "T_DEBUFF_ICON",
			Direction = "RIGHT",
			Mode = "ICON",
			Interval = 3,
			Alpha = 1,
			IconSize = Misc.IconSize,
			Position = {unpack(Filger_Settings.target_debuff_icon)},

			-- Moonfire
			{spellID = 164812, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- Sunfire
			{spellID = 164815, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- Rake
			{spellID = 155722, unitID = "target", caster = "player", filter = "DEBUFF", absID = true},
			-- Rip
			{spellID = 1079, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- Lacerate
			{spellID = 33745, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- ʹ��
			{spellID = 77758, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- Immobilized
			{spellID = 45334, unitID = "target", caster = "player", filter = "DEBUFF"},
		},
		{
			Name = "T_DE/BUFF_BAR",
			enable = Misc.Tbar,
			Direction = "UP",
			IconSide = "LEFT",
			Mode = "BAR",
			Interval = 3,
			Alpha = 1,
			IconSize = Misc.barIconSize,
			BarWidth = Misc.barw,
			Position = {unpack(Filger_Settings.target_bar)},

			-- Lifebloom
			{spellID = 33763, unitID = "target", caster = "player", filter = "BUFF"},
			-- Rejuvenation
			{spellID = 774, unitID = "target", caster = "player", filter = "BUFF"},
			-- Regrowth
			{spellID = 8936, unitID = "target", caster = "player", filter = "BUFF"},
			-- Wild Growth
			{spellID = 48438, unitID = "target", caster = "player", filter = "BUFF"},
			-- Cenarion Ward
			{spellID = 102351, unitID = "target", caster = "player", filter = "BUFF"},
		},
		{
			Name = "PVE/PVP_CC",
			enable = Misc.Pbar,
			Direction = "DOWN",
			IconSide = "LEFT",
			Mode = "BAR",
			Interval = 3,
			Alpha = 1,
			IconSize = Misc.barIconSize,
			BarWidth = Misc.barw,
			Position = {unpack(Filger_Settings.pve_cc)},

			-- Cyclone
			{spellID = 33786, unitID = "focus", caster = "all", filter = "DEBUFF"},
			-- Entangling Roots
			{spellID = 339, unitID = "focus", caster = "all", filter = "DEBUFF"},
		},
		{
			Name = "COOLDOWN",
			enable = Misc.CD,
			Direction = "RIGHT",
			Mode = "ICON",
			NumPerLine = Misc.CDnum,
			Interval = 3,
			Alpha = 1,
			IconSize = Misc.CDIconSize,
			Position = {unpack(Filger_Settings.cooldown)},

			-- Self
			-- Nature's Cure
			{spellID = 88423, filter = "CD"},
			-- Remove Corruption
			{spellID = 2782, filter = "CD"},
			-- Skull Bash
			{spellID = 106839, filter = "CD"},
			-- Mangle
			{spellID = 33917, filter = "CD"},
			-- Wild Growth
			{spellID = 48438, filter = "CD"},
			-- Swiftmend
			{spellID = 18562, filter = "CD"},
			-- Growl
			{spellID = 6795, filter = "CD"},
			-- Maim
			{spellID = 22570, filter = "CD"},
			-- Starsurge
			{spellID = 78674, filter = "CD"},
			-- Wild Charge
			{spellID = 102401, filter = "CD"},
			-- Force of Nature
			{spellID = 102693, filter = "CD"},
			-- Faerie Fire
			{spellID = 770, filter = "CD"},
			-- Tiger's Fury
			{spellID = 5217, filter = "CD"},
			-- Incapacitating Roar
			{spellID = 99, filter = "CD"},
			-- Mass Entanglement
			{spellID = 102359, filter = "CD"},
			-- Typhoon
			{spellID = 132469, filter = "CD"},
			-- Mighty Bash
			{spellID = 5211, filter = "CD"},
			-- Solar Beam
			{spellID = 78675, filter = "CD"},
			-- Barkskin
			{spellID = 22812, filter = "CD"},
			-- Ironbark
			{spellID = 102342, filter = "CD"},
			-- Nature's Swiftness
			{spellID = 132158, filter = "CD"},
			-- Ursol's Vortex
			{spellID = 102793, filter = "CD"},
			-- Nature's Vigil
			{spellID = 124974, filter = "CD"},
			-- Berserk
			{spellID = 106952, filter = "CD"},
			-- Incarnation: Son of Ursoc
			{spellID = 102558, filter = "CD"},
			-- Incarnation: Tree of Life
			{spellID = 33891, filter = "CD"},
			-- Incarnation: Chosen of Elunee
			{spellID = 102560, filter = "CD"},
			-- Incarnation: King of the Jungle
			{spellID = 102543, filter = "CD"},

			-- Racial
			-- Shadowmeld (Night Elf)
			{spellID = 58984, filter = "CD"},
			-- Darkflight (Worgen)
			{spellID = 68992, filter = "CD"},
			-- War Stomp (Tauren)
			{spellID = 20549, filter = "CD"},
			-- Berserking (Troll)
			{spellID = 26297, filter = "CD", absID = true},

			-- Items
			-- Gloves
			{slotID = 10, filter = "CD"},
			-- Belt
			{slotID = 6, filter = "CD"},
			-- Back
			{slotID = 15, filter = "CD"},
			-- Trinkets
			{slotID = 13, filter = "CD"},
			{slotID = 14, filter = "CD"},

			-- Internal
			-- Lightweave
			--{spellID = 125487, filter = "ICD", trigger = "BUFF", duration = 60},
			-- Purified Bindings of Immerseus (Intellect, Proc)
			{spellID = 146046, filter = "ICD", trigger = "BUFF", duration = 115},
		},
	},
	["HUNTER"] = {			--[����]
		{
			Name = "P_BUFF_ICON",
			Direction = "LEFT",
			Mode = "ICON",
			Interval = 3,
			Alpha = 1,
			IconSize = Misc.IconSize,
			Position = {unpack(Filger_Settings.player_buff_icon)},

			-- Deterrence
			{spellID = 19263, unitID = "player", caster = "player", filter = "BUFF"},
			-- Rapid Fire
			{spellID = 3045, unitID = "player", caster = "player", filter = "BUFF"},
			-- Bestial Wrath
			{spellID = 19574, unitID = "player", caster = "player", filter = "BUFF"},
			-- Focus Fire
			{spellID = 82692, unitID = "player", caster = "player", filter = "BUFF"},
			-- Spirit Mend
			{spellID = 90361, unitID = "player", caster = "player", filter = "BUFF"},
			-- Posthaste
			{spellID = 118922, unitID = "player", caster = "player", filter = "BUFF"},
		},
		{
			Name = "P_PROC_ICON",
			Direction = "RIGHT",
			Mode = "ICON",
			Interval = 3,
			Alpha = 1,
			IconSize = Misc.IconSize,
			Position = {unpack(Filger_Settings.player_proc_icon)},

			-- Buffs
			-- Steady Focus
			{spellID = 177668, unitID = "player", caster = "player", filter = "BUFF"},
			-- Lock and Load
			{spellID = 168980, unitID = "player", caster = "player", filter = "BUFF"},
			-- Thrill of the Hunt
			{spellID = 34720, unitID = "player", caster = "player", filter = "BUFF"},
			-- Frenzy
			{spellID = 19615, unitID = "player", caster = "player", filter = "BUFF", absID = true},
			-- Mend Pet
			{spellID = 136, unitID = "pet", caster = "player", filter = "BUFF"},

			-- Trinkets
			-- General
			-- Darkmoon Cards (Proc)
			{spellID = 128985, unitID = "player", caster = "player", filter = "BUFF"},
			-- PvP Trinkets (Health, Use)
			{spellID = 126697, unitID = "player", caster = "player", filter = "BUFF"},
			-- Physical Agility DPS
			-- Assurance of Consequence (Agility, Proc)
			{spellID = 146308, unitID = "player", caster = "player", filter = "BUFF"},
			-- Haromm's Talisman (Agility, Proc)
			{spellID = 148903, unitID = "player", caster = "player", filter = "BUFF"},
			-- Sigil of Rampage (Agility, Proc)
			{spellID = 148896, unitID = "player", caster = "player", filter = "BUFF"},
			-- Ticking Ebon Detonator (Agility, Proc)
			{spellID = 146310, unitID = "player", caster = "player", filter = "BUFF"},
			-- Discipline of Xuen (Crit, Proc)
			{spellID = 146312, unitID = "player", caster = "player", filter = "BUFF"},
			-- Vicious Talisman of the Shado-Pan Assault (Agility, Proc)
			{spellID = 138699, unitID = "player", caster = "player", filter = "BUFF"},
			-- Bad Juju (Agility, Proc)
			{spellID = 138938, unitID = "player", caster = "player", filter = "BUFF"},
			-- Talisman of Bloodlust (Haste, Proc)
			{spellID = 138895, unitID = "player", caster = "player", filter = "BUFF", absID = true},
			-- Rune of Re-Origination (Convert, Proc)
			{spellID = 139120, unitID = "player", caster = "player", filter = "BUFF"},
			-- Renataki's Soul Charm (Agility, Proc)
			{spellID = 138756, unitID = "player", caster = "player", filter = "BUFF"},
			-- Arrowflight Medallion (Crit, Use)
			{spellID = 136086, unitID = "player", caster = "player", filter = "BUFF"},
			-- Terror in the Mists (Crit, Proc)
			{spellID = 126649, unitID = "player", caster = "player", filter = "BUFF"},
			-- Jade Bandit Figurine (Haste, Use)
			{spellID = 126599, unitID = "player", caster = "player", filter = "BUFF"},
			-- Bottle of Infinite Stars (Agility, Proc)
			{spellID = 126554, unitID = "player", caster = "player", filter = "BUFF"},
			-- PvP Trinkets (Agility, Use)
			{spellID = 126690, unitID = "player", caster = "player", filter = "BUFF"},
			-- PvP Trinkets (Agility, Proc)
			{spellID = 126707, unitID = "player", caster = "player", filter = "BUFF"},

			-- Enchants
			-- General
			-- Physical General
			-- Physical Ranged
			-- Mirror Scope (Crit)
			{spellID = 109092, unitID = "player", caster = "player", filter = "BUFF"},
			-- Lord Blastington's Scope of Doom (Agility)
			{spellID = 109085, unitID = "player", caster = "player", filter = "BUFF"},
		},
		{
			Name = "T_DEBUFF_ICON",
			Direction = "RIGHT",
			Mode = "ICON",
			Interval = 3,
			Alpha = 1,
			IconSize = Misc.IconSize,
			Position = {unpack(Filger_Settings.target_debuff_icon)},

			-- Black Arrow
			{spellID = 3674, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- Explosive Shot
			{spellID = 53301, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- Narrow Escape
			{spellID = 136634, unitID = "target", caster = "player", filter = "DEBUFF"},
		},
--[[		{
			Name = "T_DE/BUFF_BAR",
			enable = Misc.Tbar,
			Direction = "UP",
			IconSide = "LEFT",
			Mode = "BAR",
			Interval = 3,
			Alpha = 1,
			IconSize = Misc.barIconSize,
			BarWidth = Misc.barw,
			Position = {unpack(Filger_Settings.target_bar)},

			-- Hunter's Mark
			{spellID = 1130, unitID = "target", caster = "all", filter = "DEBUFF"},
			-- Serpent Sting
			{spellID = 1978, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- Black Arrow
			{spellID = 3674, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- Explosive Shot
			{spellID = 53301, unitID = "target", caster = "player", filter = "DEBUFF"},
		},]]
		{
			Name = "PVE/PVP_CC",
			enable = Misc.Pbar,
			Direction = "DOWN",
			IconSide = "LEFT",
			Mode = "BAR",
			Interval = 3,
			Alpha = 1,
			IconSize = Misc.barIconSize,
			BarWidth = Misc.barw,
			Position = {unpack(Filger_Settings.pve_cc)},

			-- Wyvern Sting
			{spellID = 19386, unitID = "focus", caster = "player", filter = "DEBUFF"},
		},
		{
			Name = "COOLDOWN",
			enable = Misc.CD,
			Direction = "RIGHT",
			Mode = "ICON",
			NumPerLine = Misc.CDnum,
			Interval = 3,
			Alpha = 1,
			IconSize = Misc.CDIconSize,
			Position = {unpack(Filger_Settings.cooldown)},

			-- Self
			-- Concussive Shot
			{spellID = 5116, filter = "CD"},
			-- Counter Shot
			{spellID = 147362, filter = "CD"},
			-- Kill Command
			{spellID = 34026, filter = "CD"},
			-- Explosive Shot
			{spellID = 53301, filter = "CD"},
			-- Chimera Shot
			{spellID = 53209, filter = "CD"},
			-- Kill Shot
			{spellID = 53351, filter = "CD"},
			-- Glaive Toss
			{spellID = 117050, filter = "CD"},
			-- Barrage
			{spellID = 120360, filter = "CD"},
			-- Disengage
			{spellID = 781, filter = "CD"},
			-- Dire Beast
			{spellID = 120679, filter = "CD"},
			-- Fervor
			{spellID = 82726, filter = "CD"},
			-- Misdirection
			{spellID = 34477, filter = "CD"},
			-- Feign Death
			{spellID = 5384, filter = "CD"},
			-- Explosive Trap
			{spellID = 13813, filter = "CD"},
			-- Ice Trap
			{spellID = 13809, filter = "CD"},
			-- Binding Shot
			{spellID = 117526, filter = "CD"},
			-- Master's Call
			{spellID = 53271, filter = "CD"},
			-- Powershot
			{spellID = 109259, filter = "CD"},
			-- Wyvern Sting
			{spellID = 19386, filter = "CD"},
			-- Intimidation
			{spellID = 19577, filter = "CD"},
			-- Bestial Wrath
			{spellID = 19574, filter = "CD"},
			-- A Murder of Crows
			{spellID = 131894, filter = "CD"},
			-- Lynx Rush
			{spellID = 120697, filter = "CD"},
			-- Exhilaration
			{spellID = 109304, filter = "CD"},
			-- Rapid Fire
			{spellID = 3045, filter = "CD"},
			-- Deterrence
			{spellID = 19263, filter = "CD"},
			-- Spirit Mend (Pet)
			{spellID = 90361, filter = "CD"},

			-- Racial
			-- Every Man for Himself (Human)
			{spellID = 59752, filter = "CD"},
			-- Stoneform (Dwarf)
			{spellID = 20594, filter = "CD"},
			-- Shadowmeld (Night Elf)
			{spellID = 58984, filter = "CD"},
			-- Gift of the Naaru (Draenei)
			{spellID = 28880, filter = "CD"},
			-- Darkflight (Worgen)
			{spellID = 68992, filter = "CD"},
			-- Blood Fury (Orc)
			{spellID = 20572, filter = "CD"},
			-- Will of the Forsaken (Forsaken)
			{spellID = 7744, filter = "CD"},
			-- Cannibalize (Forsaken)
			{spellID = 20577, filter = "CD"},
			-- War Stomp (Tauren)
			{spellID = 20549, filter = "CD"},
			-- Berserking (Troll)
			{spellID = 26297, filter = "CD"},
			-- Arcane Torrent (Blood Elf)
			{spellID = 69179, filter = "CD"},
			-- Rocket Jump (Goblin)
			{spellID = 69070, filter = "CD"},
			-- Quaking Palm (Pandaren)
			{spellID = 107079, filter = "CD"},

			-- Items
			-- Gloves
			{slotID = 10, filter = "CD"},
			-- Belt
			{slotID = 6, filter = "CD"},
			-- Back
			{slotID = 15, filter = "CD"},
			-- Trinkets
			{slotID = 13, filter = "CD"},
			{slotID = 14, filter = "CD"},

			-- Internal
		},
	},
	["MAGE"] = {			--[��ʦ]
		{
			Name = "P_BUFF_ICON",
			Direction = "LEFT",
			Mode = "ICON",
			Interval = 3,
			Alpha = 1,
			IconSize = Misc.IconSize,
			Position = {unpack(Filger_Settings.player_buff_icon)},

			-- Ice Block
			{spellID = 45438, unitID = "player", caster = "player", filter = "BUFF"},
			-- Invisibility
			{spellID = 32612, unitID = "player", caster = "player", filter = "BUFF"},
			-- Greater Invisibility
			{spellID = 110960, unitID = "player", caster = "player", filter = "BUFF", absID = true},
			-- Icy Veins
			{spellID = 12472, unitID = "player", caster = "player", filter = "BUFF"},
			-- Arcane Power
			{spellID = 12042, unitID = "player", caster = "player", filter = "BUFF"},
			-- Ice Barrier
			{spellID = 11426, unitID = "player", caster = "player", filter = "BUFF"},
			-- Ice Ward
			{spellID = 111264, unitID = "player", caster = "player", filter = "BUFF"},
			-- Heating Up
			{spellID = 48107, unitID = "player", caster = "player", filter = "BUFF"},
			-- Ice Floes
			{spellID = 108839, unitID = "player", caster = "player", filter = "BUFF"},
			-- Incanter's Ward
			{spellID = 1463, unitID = "player", caster = "player", filter = "BUFF"},
			-- Alter Time
			{spellID = 110909, unitID = "player", caster = "player", filter = "BUFF"},
			-- Temporal Shield
			{spellID = 115610, unitID = "player", caster = "player", filter = "BUFF"},
			-- Rune of Power
			{spellID = 116014, unitID = "player", caster = "player", filter = "BUFF"},
		},
		{
			Name = "P_PROC_ICON",
			Direction = "RIGHT",
			Mode = "ICON",
			Interval = 3,
			Alpha = 1,
			IconSize = Misc.IconSize,
			Position = {unpack(Filger_Settings.player_proc_icon)},

			-- Buffs
			-- Fingers of Frost
			{spellID = 44544, unitID = "player", caster = "player", filter = "BUFF"},
			-- Brain Freeze
			{spellID = 57761, unitID = "player", caster = "player", filter = "BUFF"},
			-- Arcane Missiles!
			{spellID = 79683, unitID = "player", caster = "player", filter = "BUFF"},
			-- Pyroblast!
			{spellID = 48108, unitID = "player", caster = "player", filter = "BUFF"},
			-- ��ָ
			{spellID = 177159, unitID = "player", caster = "player", filter = "BUFF"},
			-- 2T17 ��
			{spellID = 166871, unitID = "player", caster = "player", filter = "BUFF"},
			-- 4T17 ��
			{spellID = 166868, unitID = "player", caster = "player", filter = "BUFF"},
			-- 4T17 ��
			{spellID = 166872, unitID = "player", caster = "player", filter = "BUFF"},

			-- Trinkets
			-- General
			{spellID = 162919, unitID = "player", caster = "player", filter = "BUFF"},
			{spellID = 177046, unitID = "player", caster = "player", filter = "BUFF"},
			{spellID = 60234, unitID = "player", caster = "player", filter = "BUFF"},
			{spellID = 177051, unitID = "player", caster = "player", filter = "BUFF"},
			-- Darkmoon Cards (Proc)
			{spellID = 128985, unitID = "player", caster = "player", filter = "BUFF"},
			-- PvP Trinkets (Health, Use)
			{spellID = 126697, unitID = "player", caster = "player", filter = "BUFF"},
			-- Caster General
			-- Shock-Charger Medallion Figurine (Intellect, Use)
			{spellID = 136082, unitID = "player", caster = "player", filter = "BUFF"},
			-- Jade Magistrate Figurine (Crit, Use)
			{spellID = 126605, unitID = "player", caster = "player", filter = "BUFF"},
			-- PvP Trinkets (Spell Power, Use)
			{spellID = 126683, unitID = "player", caster = "player", filter = "BUFF"},
			-- PvP Trinkets (Spell Power, Proc)
			{spellID = 126705, unitID = "player", caster = "player", filter = "BUFF"},
			-- Caster DPS
			-- Purified Bindings of Immerseus (Intellect, Proc)
			{spellID = 146046, unitID = "player", caster = "player", filter = "BUFF"},
			-- Kardris' Toxic Totem (Intellect, Proc)
			{spellID = 148906, unitID = "player", caster = "player", filter = "BUFF"},
			-- Frenzied Crystal of Rage (Intellect, Proc)
			{spellID = 148897, unitID = "player", caster = "player", filter = "BUFF"},
			-- Black Blood of Y'Shaarj (Intellect, Proc)
			{spellID = 146184, unitID = "player", caster = "player", filter = "BUFF"},
			-- Yu'lon's Bite (Crit, Proc)
			{spellID = 146218, unitID = "player", caster = "player", filter = "BUFF"},
			-- ����ľ�׼֮��
			{spellID = 138963, unitID = "player", caster = "player", filter = "BUFF"},
			-- Volatile Talisman of the Shado-Pan Assault (Haste, Proc)
			{spellID = 138703, unitID = "player", caster = "player", filter = "BUFF"},
			-- Cha-Ye's Essence of Brilliance (Intellect, Proc)
			{spellID = 139133, unitID = "player", caster = "player", filter = "BUFF"},
			-- Breath of the Hydra (Intellect, Proc)
			{spellID = 138898, unitID = "player", caster = "player", filter = "BUFF"},
			-- Wushoolay's Final Choice (Intellect, Proc)
			{spellID = 138786, unitID = "player", caster = "player", filter = "BUFF"},
			-- Essence of Terror (Haste, Proc)
			{spellID = 126659, unitID = "player", caster = "player", filter = "BUFF"},
			-- Light of the Cosmos (Intellect, Proc)
			{spellID = 126577, unitID = "player", caster = "player", filter = "BUFF"},

			-- Enchants
			-- General
			-- Caster General
			-- Jade Spirit (Intellect + Spirit)
			{spellID = 104993, unitID = "player", caster = "all", filter = "BUFF"},
			-- Ѫ��֮ӡ
			{spellID = 173322, unitID = "player", caster = "all", filter = "BUFF"},
			-- ����֮ӡ
			{spellID = 159234, unitID = "player", caster = "all", filter = "BUFF"},
			-- ��ɫ���
			-- ����֮Դ�� (����, ����)
			{spellID = 137590, unitID = "player", caster = "all", filter = "BUFF"},
		},
		{
			Name = "T_DEBUFF_ICON",
			Direction = "RIGHT",
			Mode = "ICON",
			Interval = 3,
			Alpha = 1,
			IconSize = Misc.IconSize,
			Position = {unpack(Filger_Settings.target_debuff_icon)},

			-- Arcane Charge
			{spellID = 36032, unitID = "player", caster = "player", filter = "DEBUFF"},
			-- Slow
			{spellID = 31589, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- Ignite
			{spellID = 12654, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- Living Bomb
			{spellID = 44457, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- Nether Tempest
			{spellID = 114923, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- Frost Bomb
			{spellID = 112948, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- Pyroblast
			{spellID = 11366, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- Combustion
			{spellID = 83853, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- Freeze (Pet)
			{spellID = 33395, unitID = "target", caster = "all", filter = "DEBUFF"},
			-- Frost Nova
			{spellID = 122, unitID = "target", caster = "all", filter = "DEBUFF"},
			-- Ice Ward
			{spellID = 111340, unitID = "target", caster = "all", filter = "DEBUFF"},
			-- Cone of Cold
			{spellID = 120, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- Frostfire Bolt
			{spellID = 44614, unitID = "target", caster = "player", filter = "DEBUFF"},
		},
		{
			Name = "PVE/PVP_CC",
			enable = Misc.Pbar,
			Direction = "DOWN",
			IconSide = "LEFT",
			Mode = "BAR",
			Interval = 3,
			Alpha = 1,
			IconSize = Misc.barIconSize,
			BarWidth = Misc.barw,
			Position = {unpack(Filger_Settings.pve_cc)},

			-- Polymorph
			{spellID = 118, unitID = "focus", caster = "all", filter = "DEBUFF"},
		},
		{
			Name = "COOLDOWN",
			enable = Misc.CD,
			Direction = "RIGHT",
			Mode = "ICON",
			NumPerLine = Misc.CDnum,
			Interval = 3,
			Alpha = 1,
			IconSize = Misc.CDIconSize,
			Position = {unpack(Filger_Settings.cooldown)},

			-- Self
			-- Remove Curse
			{spellID = 475, filter = "CD"},
			-- Frostjaw
			{spellID = 102051, filter = "CD"},
			-- Counterspell
			{spellID = 2139, filter = "CD"},
			-- Blink
			{spellID = 1953, filter = "CD"},
			-- Blazing Speed
			{spellID = 108843, filter = "CD"},
			-- Deep Freeze
			{spellID = 44572, filter = "CD"},
			-- Frost Nova
			{spellID = 122, filter = "CD"},
			-- Ice Ward
			{spellID = 111264, filter = "CD"},
			-- Ring of Frost
			{spellID = 113724, filter = "CD"},
			-- Ice Barrier
			{spellID = 11426, filter = "CD"},
			-- Temporal Shield
			{spellID = 115610, filter = "CD"},
			-- Incanter's Ward
			{spellID = 1463, filter = "CD"},
			-- Fire Blast
			{spellID = 2136, filter = "CD"},
			-- Frost Bomb
			{spellID = 112948, filter = "CD"},
			-- Flamestrike
			{spellID = 2120, filter = "CD"},
			-- Cone of Cold
			{spellID = 120, filter = "CD"},
			-- Freeze (Pet)
			{spellID = 33395, filter = "CD"},
			-- Ice Floes
			{spellID = 108839, filter = "CD"},
			-- Combustion
			{spellID = 11129, filter = "CD"},
			-- Frozen Orb
			{spellID = 84714, filter = "CD"},
			-- Arcane Power
			{spellID = 12042, filter = "CD"},
			-- Presence of Mind
			{spellID = 12043, filter = "CD"},
			-- Evocation
			{spellID = 12051, filter = "CD"},
			-- Icy Veins
			{spellID = 12472, filter = "CD"},
			-- Cold Snap
			{spellID = 11958, filter = "CD"},
			-- Mirror Image
			{spellID = 55342, filter = "CD"},
			-- Alter Time
			{spellID = 108978, filter = "CD"},
			-- Ice Block
			{spellID = 45438, filter = "CD"},
			-- Invisibility
			{spellID = 66, filter = "CD"},

			-- Racial
			-- Every Man for Himself (Human)
			{spellID = 59752, filter = "CD"},
			-- Stoneform (Dwarf)
			{spellID = 20594, filter = "CD"},
			-- Shadowmeld (Night Elf)
			{spellID = 58984, filter = "CD"},
			-- Escape Artist (Gnome)
			{spellID = 20589, filter = "CD"},
			-- Gift of the Naaru (Draenei)
			{spellID = 28880, filter = "CD"},
			-- Darkflight (Worgen)
			{spellID = 68992, filter = "CD"},
			-- Blood Fury (Orc)
			{spellID = 20572, filter = "CD"},
			-- Will of the Forsaken (Forsaken)
			{spellID = 7744, filter = "CD"},
			-- Cannibalize (Forsaken)
			{spellID = 20577, filter = "CD"},
			-- Berserking (Troll)
			{spellID = 26297, filter = "CD"},
			-- Arcane Torrent (Blood Elf)
			{spellID = 69179, filter = "CD"},
			-- Rocket Jump (Goblin)
			{spellID = 69070, filter = "CD"},
			-- Quaking Palm (Pandaren)
			{spellID = 107079, filter = "CD"},

			-- Items
			-- Gloves
			{slotID = 10, filter = "CD"},
			-- Belt
			{slotID = 6, filter = "CD"},
			-- Back
			{slotID = 15, filter = "CD"},
			-- Trinkets
			{slotID = 13, filter = "CD"},
			{slotID = 14, filter = "CD"},

			-- Internal
			-- Lightweave
			--{spellID = 125487, filter = "ICD", trigger = "BUFF", duration = 60},
			-- Purified Bindings of Immerseus (Intellect, Proc)
			{spellID = 146046, filter = "ICD", trigger = "BUFF", duration = 115},
		},
	},
	["MONK"] = {			--[��ɮ]
		{
			Name = "P_BUFF_ICON",
			Direction = "LEFT",
			Mode = "ICON",
			Interval = 3,
			Alpha = 1,
			IconSize = Misc.IconSize,
			Position = {unpack(Filger_Settings.player_buff_icon)},

			-- Guard������
			{spellID = 115295, unitID = "player", caster = "player", filter = "BUFF"},
			-- Fortifying Brew׳����
			{spellID = 120954, unitID = "player", caster = "player", filter = "BUFF"},
			-- Elusive BrewƮ���
			{spellID = 115308, unitID = "player", caster = "player", filter = "BUFF", absID = true},
			-- Tigereye Brew���۾�
			{spellID = 116740, unitID = "player", caster = "player", filter = "BUFF", absID = true},
			-- Touch of Karmaҵ��֮��
			{spellID = 125174, unitID = "player", caster = "player", filter = "BUFF"},
			-- Diffuse Magicɢħ��
			{spellID = 122783, unitID = "player", caster = "player", filter = "BUFF"},
			-- Energizing Brew���ܾ�
			{spellID = 115288, unitID = "player", caster = "player", filter = "BUFF"},
			-- Thunder Focus Tea
			{spellID = 116680, unitID = "player", caster = "player", filter = "BUFF"},
			-- Momentum��������
			{spellID = 119085, unitID = "player", caster = "player", filter = "BUFF"},
			--�����ȭ
			{spellID = 124275, unitID = "player", caster = "all", filter = "DEBUFF"},
			--�ж���ȭ
			{spellID = 124274, unitID = "player", caster = "all", filter = "DEBUFF"},
			--�ض���ȭ
			{spellID = 124273, unitID = "player", caster = "all", filter = "DEBUFF"},
		},
		{
			Name = "P_PROC_ICON",
			Direction = "RIGHT",
			Mode = "ICON",
			Interval = 3,
			Alpha = 1,
			IconSize = Misc.IconSize,
			Position = {unpack(Filger_Settings.player_proc_icon)},

			-- Buffs
			-- �ͻ�����
			{spellID = 120273, unitID = "player", caster = "player", filter = "BUFF"},
			-- Elusive Brew
			{spellID = 128939, unitID = "player", caster = "player", filter = "BUFF", absID = true, count = 12},
			-- Mana Tea
			{spellID = 115867, unitID = "player", caster = "player", filter = "BUFF", absID = true, count = 18},
			-- Tigereye Brew
			{spellID = 125195, unitID = "player", caster = "player", filter = "BUFF", absID = true, count = 10},
			-- Tiger Power
			{spellID = 125359, unitID = "player", caster = "player", filter = "BUFF"},
			-- Combo Breaker: Blackout Kick
			{spellID = 116768, unitID = "player", caster = "player", filter = "BUFF"},
			-- Combo Breaker: Tiger Palm
			{spellID = 118864, unitID = "player", caster = "player", filter = "BUFF"},
			-- Shuffle
			{spellID = 115307, unitID = "player", caster = "player", filter = "BUFF"},
			-- Vital Mists����֮��
			{spellID = 118674, unitID = "player", caster = "player", filter = "BUFF"},
			-- Serpent's Zeal����֮��
			{spellID = 127722, unitID = "player", caster = "player", filter = "BUFF"},

			-- Trinkets
			-- General
			-- Darkmoon Cards (Proc)
			{spellID = 128985, unitID = "player", caster = "player", filter = "BUFF"},
			-- PvP Trinkets (Health, Use)
			{spellID = 126697, unitID = "player", caster = "player", filter = "BUFF"},
			-- Tank
			-- Rook's Unlucky Talisman (Reduces damage, Use)
			{spellID = 146343, unitID = "player", caster = "player", filter = "BUFF"},
			-- Resolve of Niuzao (Dodge, Use)
			{spellID = 146344, unitID = "player", caster = "player", filter = "BUFF"},
			-- Steadfast Talisman of the Shado-Pan Assault (Dodge, Use)
			{spellID = 138728, unitID = "player", caster = "player", filter = "BUFF"},
			-- Delicate Vial of the Sanguinaire (Mastery, Proc)
			{spellID = 138864, unitID = "player", caster = "player", filter = "BUFF"},
			-- Stuff of Nightmares (Dodge, Proc)
			{spellID = 126646, unitID = "player", caster = "player", filter = "BUFF"},
			-- Vial of Dragon's Blood (Dodge, Proc)
			{spellID = 126533, unitID = "player", caster = "player", filter = "BUFF"},
			-- Jade Warlord Figurine (Mastery, Use)
			{spellID = 126597, unitID = "player", caster = "player", filter = "BUFF"},
			-- Physical Agility DPS
			-- Assurance of Consequence (Agility, Proc)
			{spellID = 146308, unitID = "player", caster = "player", filter = "BUFF"},
			-- Haromm's Talisman (Agility, Proc)
			{spellID = 148903, unitID = "player", caster = "player", filter = "BUFF"},
			-- Sigil of Rampage (Agility, Proc)
			{spellID = 148896, unitID = "player", caster = "player", filter = "BUFF"},
			-- Ticking Ebon Detonator (Agility, Proc)
			{spellID = 146310, unitID = "player", caster = "player", filter = "BUFF"},
			-- Discipline of Xuen (Crit, Proc)
			{spellID = 146312, unitID = "player", caster = "player", filter = "BUFF"},
			-- Vicious Talisman of the Shado-Pan Assault (Agility, Proc)
			{spellID = 138699, unitID = "player", caster = "player", filter = "BUFF"},
			-- Bad Juju (Agility, Proc)
			{spellID = 138938, unitID = "player", caster = "player", filter = "BUFF"},
			-- Talisman of Bloodlust (Haste, Proc)
			{spellID = 138895, unitID = "player", caster = "player", filter = "BUFF"},
			-- Rune of Re-Origination (Convert, Proc)
			{spellID = 139120, unitID = "player", caster = "player", filter = "BUFF"},
			-- Renataki's Soul Charm (Agility, Proc)
			{spellID = 138756, unitID = "player", caster = "player", filter = "BUFF"},
			-- Arrowflight Medallion (Crit, Use)
			{spellID = 136086, unitID = "player", caster = "player", filter = "BUFF"},
			-- Terror in the Mists (Crit, Proc)
			{spellID = 126649, unitID = "player", caster = "player", filter = "BUFF"},
			-- Jade Bandit Figurine (Haste, Use)
			{spellID = 126599, unitID = "player", caster = "player", filter = "BUFF"},
			-- Bottle of Infinite Stars (Agility, Proc)
			{spellID = 126554, unitID = "player", caster = "player", filter = "BUFF"},
			-- PvP Trinkets (Agility, Use)
			{spellID = 126690, unitID = "player", caster = "player", filter = "BUFF"},
			-- PvP Trinkets (Agility, Proc)
			{spellID = 126707, unitID = "player", caster = "player", filter = "BUFF"},
			-- Caster General
			-- Shock-Charger Medallion Figurine (Intellect, Use)
			{spellID = 136082, unitID = "player", caster = "player", filter = "BUFF"},
			-- Jade Magistrate Figurine (Crit, Use)
			{spellID = 126605, unitID = "player", caster = "player", filter = "BUFF"},
			-- PvP Trinkets (Spell Power, Use)
			{spellID = 126683, unitID = "player", caster = "player", filter = "BUFF"},
			-- PvP Trinkets (Spell Power, Proc)
			{spellID = 126705, unitID = "player", caster = "player", filter = "BUFF"},
			-- Caster Heal
			-- Prismatic Prison of Pride (Intellect, Proc)
			{spellID = 146314, unitID = "player", caster = "player", filter = "BUFF"},
			-- Nazgrim's Burnished Insignia (Intellect, Proc)
			{spellID = 148908, unitID = "player", caster = "player", filter = "BUFF"},
			-- Thok's Acid-Grooved Tooth (Intellect, Proc)
			{spellID = 148911, unitID = "player", caster = "player", filter = "BUFF"},
			-- Qin-xi's Polarizing Seal (Intellect, Proc)
			{spellID = 126588, unitID = "player", caster = "player", filter = "BUFF"},

			-- Enchants
			-- General
			-- Tank
			-- River's Song (Dodge)
			{spellID = 116660, unitID = "player", caster = "all", filter = "BUFF"},
			-- Physical General
			-- Physical Melee
			-- Dancing Steel (Agility)
			{spellID = 120032, unitID = "player", caster = "all", filter = "BUFF"},
			-- Caster General
			-- Jade Spirit (Intellect + Spirit)
			{spellID = 104993, unitID = "player", caster = "all", filter = "BUFF"},
			-- Lightweave (Intellect)
			--{spellID = 125487, unitID = "player", caster = "player", filter = "BUFF"},
			-- Caster Heal

			-- ��ɫ���
			-- ����֮Դ�� (����, ����)
			{spellID = 137593, unitID = "player", caster = "all", filter = "BUFF", absID = true},
			-- Ӣ��֮Դ�� (����, ����)
			{spellID = 137288, unitID = "player", caster = "all", filter = "BUFF"},

			-- ʷʫ����
			-- Spirit of Chi-Ji
			{spellID = 146200, unitID = "player", caster = "all", filter = "BUFF"},
		},
		{
			Name = "T_DEBUFF_ICON",
			Direction = "RIGHT",
			Mode = "ICON",
			Interval = 3,
			Alpha = 1,
			IconSize = Misc.IconSize,
			Position = {unpack(Filger_Settings.target_debuff_icon)},

			-- Heavy Stagger
			{spellID = 124273, unitID = "player", caster = "player", filter = "DEBUFF"},
			-- Dizzying Haze
			{spellID = 116330, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- Breath of Fire
			{spellID = 123725, unitID = "target", caster = "player", filter = "DEBUFF"},
		},
		--[[{
			Name = "T_DE/BUFF_BAR",
			enable = Misc.Tbar,
			Direction = "UP",
			IconSide = "LEFT",
			Mode = "BAR",
			Interval = 3,
			Alpha = 1,
			IconSize = Misc.barIconSize,
			BarWidth = Misc.barw,
			Position = {unpack(Filger_Settings.target_bar)},

		},]]
		{
			Name = "COOLDOWN",
			enable = Misc.CD,
			Direction = "RIGHT",
			Mode = "ICON",
			NumPerLine = Misc.CDnum,
			Interval = 3,
			Alpha = 1,
			IconSize = Misc.CDIconSize,
			Position = {unpack(Filger_Settings.cooldown)},

			-- Self
			-- Detox
			{spellID = 115450, filter = "CD"},
			-- Spear Hand Strike
			{spellID = 116705, filter = "CD"},
			-- Paralysis
			{spellID = 115078, filter = "CD"},
			-- Expel Harm
			{spellID = 115072, filter = "CD"},
			-- Rising Sun Kick
			{spellID = 107428, filter = "CD"},
			-- Provoke
			{spellID = 115546, filter = "CD"},
			-- Zen Sphere
			{spellID = 124081, filter = "CD"},
			-- Chi Wave
			{spellID = 115098, filter = "CD"},
			-- Fists of Fury
			{spellID = 113656, filter = "CD"},
			-- Chi Burst
			{spellID = 123986, filter = "CD"},
			-- Guard
			{spellID = 115295, filter = "CD"},
			-- Charging Ox Wave
			{spellID = 119392, filter = "CD"},
			-- Ring of Peace
			{spellID = 116844, filter = "CD"},
			-- Thunder Focus Tea
			{spellID = 116680, filter = "CD"},
			-- Dampen Harm
			{spellID = 122278, filter = "CD"},
			-- Flying Serpent Kick
			{spellID = 101545, filter = "CD"},
			-- Energizing Brew
			{spellID = 115288, filter = "CD"},
			-- Touch of Karma
			{spellID = 122470, filter = "CD"},
			-- Touch of Death
			{spellID = 115080, filter = "CD"},
			-- Nimble Brew
			{spellID = 137562, filter = "CD"},
			-- Life Cocoon
			{spellID = 116849, filter = "CD"},
			-- Invoke Xuen, the White Tiger
			{spellID = 123904, filter = "CD"},

			-- Racial
			-- Every Man for Himself (Human)
			{spellID = 59752, filter = "CD"},
			-- Stoneform (Dwarf)
			{spellID = 20594, filter = "CD"},
			-- Shadowmeld (Night Elf)
			{spellID = 58984, filter = "CD"},
			-- Escape Artist (Gnome)
			{spellID = 20589, filter = "CD"},
			-- Gift of the Naaru (Draenei)
			{spellID = 28880, filter = "CD"},
			-- Blood Fury (Orc)
			{spellID = 20572, filter = "CD"},
			-- Will of the Forsaken (Forsaken)
			{spellID = 7744, filter = "CD"},
			-- Cannibalize (Forsaken)
			{spellID = 20577, filter = "CD"},
			-- War Stomp (Tauren)
			{spellID = 20549, filter = "CD"},
			-- Berserking (Troll)
			{spellID = 26297, filter = "CD"},
			-- Arcane Torrent (Blood Elf)
			{spellID = 69179, filter = "CD"},
			-- Quaking Palm (Pandaren)
			{spellID = 107079, filter = "CD"},

			-- Items
			-- Gloves
			{slotID = 10, filter = "CD"},
			-- Belt
			{slotID = 6, filter = "CD"},
			-- Back
			{slotID = 15, filter = "CD"},
			-- Trinkets
			{slotID = 13, filter = "CD"},
			{slotID = 14, filter = "CD"},

			-- Internal
		},
	},
	["PALADIN"] = {			--[ʥ��]
		{
			Name = "P_BUFF_ICON",
			Direction = "LEFT",
			Mode = "ICON",
			Interval = 3,
			Alpha = 1,
			IconSize = Misc.IconSize,
			Position = {unpack(Filger_Settings.player_buff_icon)},

			-- Divine Shield
			{spellID = 642, unitID = "player", caster = "player", filter = "BUFF"},
			-- ͼ����Ĳþ� (20%�ƶ��ٶ�)
			{spellID = 156987, unitID = "player", caster = "player", filter = "BUFF"},
			-- ��ɪ��֮�� (2���1%Ѫ)
			{spellID = 156988, unitID = "player", caster = "player", filter = "BUFF"},
			-- ���ǵ��յĹ��� (15%����,20��)
			{spellID = 156989, unitID = "player", caster = "player", filter = "BUFF"},
			-- ������µ����� (15%��ǿ,20��)
			{spellID = 156990, unitID = "player", caster = "player", filter = "BUFF"},
			-- Guardian of Ancient Kings
			{spellID = 86659, unitID = "player", caster = "player", filter = "BUFF"},
			-- Holy Avenger
			{spellID = 105809, unitID = "player", caster = "player", filter = "BUFF"},
			-- Avenging Wrath
			{spellID = 31884, unitID = "player", caster = "player", filter = "BUFF"},
			-- Argent Defender
			{spellID = 31850, unitID = "player", caster = "player", filter = "BUFF"},
			-- Divine Protection
			{spellID = 498, unitID = "player", caster = "player", filter = "BUFF"},
			-- Speed of Light
			{spellID = 85499, unitID = "player", caster = "player", filter = "BUFF"},
			-- Eternal Flame
			{spellID = 114163, unitID = "player", caster = "player", filter = "BUFF"},
			-- Sacred Shield
			{spellID = 20925, unitID = "player", caster = "player", filter = "BUFF", absID = true},
			-- Shield of the righteous ����ܻ�
			--{spellID = 53600, unitID = "player", caster = "player", filter = "BUFF"},
		},
		{
			Name = "P_PROC_ICON",
			Direction = "RIGHT",
			Mode = "ICON",
			Interval = 3,
			Alpha = 1,
			IconSize = Misc.IconSize,
			Position = {unpack(Filger_Settings.player_proc_icon)},

			-- Buffs
			-- Infusion of Light
			{spellID = 54149, unitID = "player", caster = "player", filter = "BUFF"},
			-- Bastion of Glory
			{spellID = 114637, unitID = "player", caster = "player", filter = "BUFF"},
			-- Selfless Healer
			{spellID = 114250, unitID = "player", caster = "player", filter = "BUFF"},
			-- Divine Purpose
			{spellID = 90174, unitID = "player", caster = "player", filter = "BUFF"},
			-- Grand Crusader
			{spellID = 85416, unitID = "player", caster = "player", filter = "BUFF"},
			-- Daybreak
			{spellID = 88819, unitID = "player", caster = "player", filter = "BUFF"},
			-- Long Arm of the Law
			{spellID = 87173, unitID = "player", caster = "player", filter = "BUFF"},

			-- Item sets
			-- Divine Crusader (T16)
			{spellID = 144595, unitID = "player", caster = "player", filter = "BUFF"},
			
			-- Trinkets
			-- General
			-- Darkmoon Cards (Proc)
			{spellID = 128985, unitID = "player", caster = "player", filter = "BUFF"},
			-- PvP Trinkets (Health, Use)
			{spellID = 126697, unitID = "player", caster = "player", filter = "BUFF"},
			-- Tank
			-- Rook's Unlucky Talisman (Reduces damage, Use)
			{spellID = 146343, unitID = "player", caster = "player", filter = "BUFF"},
			-- Resolve of Niuzao (Dodge, Use)
			{spellID = 146344, unitID = "player", caster = "player", filter = "BUFF"},
			-- Steadfast Talisman of the Shado-Pan Assault (Dodge, Use)
			{spellID = 138728, unitID = "player", caster = "player", filter = "BUFF"},
			-- Delicate Vial of the Sanguinaire (Mastery, Proc)
			{spellID = 138864, unitID = "player", caster = "player", filter = "BUFF"},
			-- Stuff of Nightmares (Dodge, Proc)
			{spellID = 126646, unitID = "player", caster = "player", filter = "BUFF"},
			-- Vial of Dragon's Blood (Dodge, Proc)
			{spellID = 126533, unitID = "player", caster = "player", filter = "BUFF"},
			-- Jade Warlord Figurine (Mastery, Use)
			{spellID = 126597, unitID = "player", caster = "player", filter = "BUFF"},
			-- Physical Strength DPS
			-- Evil Eye of Galakras (Strength, Proc)
			{spellID = 146245, unitID = "player", caster = "player", filter = "BUFF"},
			-- Thok's Tail Tip (Strength, Proc)
			{spellID = 146250, unitID = "player", caster = "player", filter = "BUFF", absID = true},
			-- Skeer's Bloodsoaked Talisman (Strength, Proc)
			{spellID = 146285, unitID = "player", caster = "player", filter = "BUFF"},
			-- Fusion-Fire Core (Strength, Proc)
			{spellID = 148899, unitID = "player", caster = "player", filter = "BUFF", absID = true},
			-- Alacrity of Xuen (Haste, Proc)
			{spellID = 146296, unitID = "player", caster = "player", filter = "BUFF"},
			-- Brutal Talisman of the Shado-Pan Assault (Strength, Proc)
			{spellID = 138702, unitID = "player", caster = "player", filter = "BUFF"},
			-- Fabled Feather of Ji-Kun (Strength, Proc)
			{spellID = 138759, unitID = "player", caster = "player", filter = "BUFF"},
			-- Spark of Zandalar (Strength, Proc)
			{spellID = 138958, unitID = "player", caster = "player", filter = "BUFF"},
			-- Primordius' Talisman of Rage (Strength, Proc)
			{spellID = 138870, unitID = "player", caster = "player", filter = "BUFF"},
			-- Gaze of the Twins (Crit, Proc)
			{spellID = 139170, unitID = "player", caster = "player", filter = "BUFF"},
			-- Helmbreaker Medallion (Crit, Use)
			{spellID = 136084, unitID = "player", caster = "player", filter = "BUFF"},
			-- Darkmist Vortex (Haste, Proc)
			{spellID = 126657, unitID = "player", caster = "player", filter = "BUFF"},
			-- Lei Shin's Final Orders (Strength, Proc)
			{spellID = 126582, unitID = "player", caster = "player", filter = "BUFF"},
			-- Jade Charioteer Figurine (Strength, Use)
			{spellID = 126599, unitID = "player", caster = "player", filter = "BUFF"},
			-- Iron Belly Wok (Haste, Use)
			{spellID = 129812, unitID = "player", caster = "player", filter = "BUFF"},
			-- PvP Trinkets (Strength, Use)
			{spellID = 126679, unitID = "player", caster = "player", filter = "BUFF"},
			-- PvP Trinkets (Strength, Proc)
			{spellID = 126700, unitID = "player", caster = "player", filter = "BUFF"},
			-- Caster General
			-- Shock-Charger Medallion Figurine (Intellect, Use)
			{spellID = 136082, unitID = "player", caster = "player", filter = "BUFF"},
			-- Jade Magistrate Figurine (Crit, Use)
			{spellID = 126605, unitID = "player", caster = "player", filter = "BUFF"},
			-- PvP Trinkets (Spell Power, Use)
			{spellID = 126683, unitID = "player", caster = "player", filter = "BUFF"},
			-- PvP Trinkets (Spell Power, Proc)
			{spellID = 126705, unitID = "player", caster = "player", filter = "BUFF"},
			-- Caster Heal
			-- Prismatic Prison of Pride (Intellect, Proc)
			{spellID = 146314, unitID = "player", caster = "player", filter = "BUFF"},
			-- Nazgrim's Burnished Insignia (Intellect, Proc)
			{spellID = 148908, unitID = "player", caster = "player", filter = "BUFF"},
			-- Thok's Acid-Grooved Tooth (Intellect, Proc)
			{spellID = 148911, unitID = "player", caster = "player", filter = "BUFF"},
			-- Qin-xi's Polarizing Seal (Intellect, Proc)
			{spellID = 126588, unitID = "player", caster = "player", filter = "BUFF"},

			-- Enchants
			-- General
			-- Tank
			-- River's Song (Dodge)
			{spellID = 116660, unitID = "player", caster = "all", filter = "BUFF"},
			-- Physical General
			-- Physical Melee
			-- Dancing Steel (Strength)
			{spellID = 120032, unitID = "player", caster = "all", filter = "BUFF"},
			-- Caster General
			-- Jade Spirit (Intellect + Spirit)
			{spellID = 104993, unitID = "player", caster = "all", filter = "BUFF"},
			-- Lightweave (Intellect)
			--{spellID = 125487, unitID = "player", caster = "player", filter = "BUFF"},
			-- Caster Heal

			-- ��ɫ���
			-- ����֮Դ�� (����, ����)
			{spellID = 137593, unitID = "player", caster = "all", filter = "BUFF", absID = true},
			-- Ӣ��֮Դ�� (����, ����)
			{spellID = 137288, unitID = "player", caster = "all", filter = "BUFF"},

			-- ʷʫ����
			-- Spirit of Chi-Ji
			{spellID = 146200, unitID = "player", caster = "all", filter = "BUFF"},
		},
		{
			Name = "T_DEBUFF_ICON",
			Direction = "RIGHT",
			Mode = "ICON",
			Interval = 3,
			Alpha = 1,
			IconSize = Misc.IconSize,
			Position = {unpack(Filger_Settings.target_debuff_icon)},

			-- Forbearance
			{spellID = 25771, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- Censure
			{spellID = 31803, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- Glyph of Dazing Shield
			{spellID = 63529, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- Seal of Justice
			{spellID = 20170, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- Denounce
			{spellID = 2812, unitID = "target", caster = "player", filter = "DEBUFF"},
		},
		{
			Name = "COOLDOWN",
			enable = Misc.CD,
			Direction = "RIGHT",
			Mode = "ICON",
			NumPerLine = Misc.CDnum,
			Interval = 3,
			Alpha = 1,
			IconSize = Misc.CDIconSize,
			Position = {unpack(Filger_Settings.cooldown)},

			-- Self
			-- Cleanse
			{spellID = 4987, filter = "CD"},
			-- Rebuke
			{spellID = 96231, filter = "CD"},
			-- Repentance
			{spellID = 20066, filter = "CD"},
			-- Turn Evil
			{spellID = 10326, filter = "CD"},
			-- Hammer of Justice
			{spellID = 853, filter = "CD"},
			-- Judgment
			{spellID = 20271, filter = "CD"},
			-- Consecration
			{spellID = 26573, filter = "CD"},
			-- Holy Wrath
			{spellID = 119072, filter = "CD"},
			-- Avenger's Shield
			{spellID = 31935, filter = "CD"},
			-- Exorcism
			{spellID = 879, filter = "CD"},
			-- Holy Prism
			{spellID = 114165, filter = "CD"},
			-- Hand of Freedom
			{spellID = 1044, filter = "CD"},
			-- Hand of Purity
			{spellID = 114039, filter = "CD"},
			-- Speed of Light
			{spellID = 85499, filter = "CD"},
			-- Divine Protection
			{spellID = 498, filter = "CD"},
			-- Execution Sentence
			{spellID = 114157, filter = "CD"},
			-- Light's Hammer
			{spellID = 114158, filter = "CD"},
			-- Blinding Light
			{spellID = 115750, filter = "CD"},
			-- Holy Avenger
			{spellID = 105809, filter = "CD"},
			-- Devotion Aura
			{spellID = 31821, filter = "CD"},
			-- Hand of Sacrifice
			{spellID = 6940, filter = "CD"},
			-- Avenging Wrath
			{spellID = 31884, filter = "CD"},
			-- Ardent Defender
			{spellID = 31850, filter = "CD"},
			-- Hand of Protection
			{spellID = 1022, filter = "CD"},

			-- Racial
			-- Every Man for Himself (Human)
			{spellID = 59752, filter = "CD"},
			-- Stoneform (Dwarf)
			{spellID = 20594, filter = "CD"},
			-- Gift of the Naaru (Draenei)
			{spellID = 28880, filter = "CD"},
			-- War Stomp (Tauren)
			{spellID = 20549, filter = "CD"},
			-- Arcane Torrent (Blood Elf)
			{spellID = 69179, filter = "CD"},

			-- Items
			-- Gloves
			{slotID = 10, filter = "CD"},
			-- Belt
			{slotID = 6, filter = "CD"},
			-- Back
			{slotID = 15, filter = "CD"},
			-- Trinkets
			{slotID = 13, filter = "CD"},
			{slotID = 14, filter = "CD"},

			-- Internal
		},
	},
	["PRIEST"] = {			--[��ʦ]
		{
			Name = "P_BUFF_ICON",
			Direction = "LEFT",
			Mode = "ICON",
			Interval = 3,
			Alpha = 1,
			IconSize = Misc.IconSize,
			Position = {unpack(Filger_Settings.player_buff_icon)},

			-- Dispersion
			{spellID = 47585, unitID = "player", caster = "player", filter = "BUFF"},
			-- Power Infusion
			{spellID = 10060, unitID = "player", caster = "player", filter = "BUFF"},
			-- Spirit Shell
			{spellID = 109964, unitID = "player", caster = "player", filter = "BUFF", absID = true},
			-- Archangel ����ʹ
			{spellID = 81700, unitID = "player", caster = "player", filter = "BUFF"},
			-- Vampiric Embrace
			{spellID = 15286, unitID = "player", caster = "player", filter = "BUFF"},
			-- Power Word: Shield
			{spellID = 17, unitID = "player", caster = "all", filter = "BUFF"},
			-- Renew
			{spellID = 139, unitID = "player", caster = "player", filter = "BUFF"},
			-- Fade
			{spellID = 586, unitID = "player", caster = "player", filter = "BUFF"},
			-- Focused Will
			{spellID = 45242, unitID = "player", caster = "player", filter = "BUFF"},
		},
		{
			Name = "P_PROC_ICON",
			Direction = "RIGHT",
			Mode = "ICON",
			Interval = 3,
			Alpha = 1,
			IconSize = Misc.IconSize,
			Position = {unpack(Filger_Settings.player_proc_icon)},

			-- Buffs
			--��Ӱ����
			{spellID = 77487, unitID = "player", caster = "player", filter = "BUFF"},
 			-- Divine Insight
			{spellID = 123267, unitID = "player", caster = "player", filter = "BUFF"},
			-- Shadowy Insight
 			{spellID = 124430, unitID = "player", caster = "player", filter = "BUFF"},
			-- Surge of Light
			{spellID = 114255, unitID = "player", caster = "player", filter = "BUFF"},
			-- Surge of Darkness
			{spellID = 87160, unitID = "player", caster = "player", filter = "BUFF"},
			-- Serendipity
			{spellID = 63735, unitID = "player", caster = "player", filter = "BUFF"},
			-- Glyph of Mind Spike
			{spellID = 81292, unitID = "player", caster = "player", filter = "BUFF"},
			-- Borrowed Time
			{spellID = 59889, unitID = "player", caster = "player", filter = "BUFF"},
			-- Twist of Fate
			{spellID = 123254, unitID = "player", caster = "player", filter = "BUFF"},
			-- Evangelism
			{spellID = 81661, unitID = "player", caster = "player", filter = "BUFF"},
			-- Shadow Word: Insanity
			{spellID = 132573, unitID = "player", caster = "player", filter = "BUFF"},
			-- Trinkets
			-- General
			-- Darkmoon Cards (Proc)
			{spellID = 128985, unitID = "player", caster = "player", filter = "BUFF"},
			-- PvP Trinkets (Health, Use)
			{spellID = 126697, unitID = "player", caster = "player", filter = "BUFF"},
			-- Caster General
			-- Shock-Charger Medallion Figurine (Intellect, Use)
			{spellID = 136082, unitID = "player", caster = "player", filter = "BUFF"},
			-- Jade Magistrate Figurine (Crit, Use)
			{spellID = 126605, unitID = "player", caster = "player", filter = "BUFF"},
			-- PvP Trinkets (Spell Power, Use)
			{spellID = 126683, unitID = "player", caster = "player", filter = "BUFF"},
			-- PvP Trinkets (Spell Power, Proc)
			{spellID = 126705, unitID = "player", caster = "player", filter = "BUFF"},
			-- Caster DPS
			-- Purified Bindings of Immerseus (Intellect, Proc)
			{spellID = 146046, unitID = "player", caster = "player", filter = "BUFF"},
			-- Kardris' Toxic Totem (Intellect, Proc)
			{spellID = 148906, unitID = "player", caster = "player", filter = "BUFF"},
			-- Frenzied Crystal of Rage (Intellect, Proc)
			{spellID = 148897, unitID = "player", caster = "player", filter = "BUFF"},
			-- Black Blood of Y'Shaarj (Intellect, Proc)
			{spellID = 146184, unitID = "player", caster = "player", filter = "BUFF"},
			-- Yu'lon's Bite (Crit, Proc)
			{spellID = 146218, unitID = "player", caster = "player", filter = "BUFF"},
			-- ����ľ�׼֮��
			{spellID = 138963, unitID = "player", caster = "player", filter = "BUFF"},
			-- Volatile Talisman of the Shado-Pan Assault (Haste, Proc)
			{spellID = 138703, unitID = "player", caster = "player", filter = "BUFF"},
			-- Cha-Ye's Essence of Brilliance (Intellect, Proc)
			{spellID = 139133, unitID = "player", caster = "player", filter = "BUFF"},
			-- Breath of the Hydra (Intellect, Proc)
			{spellID = 138898, unitID = "player", caster = "player", filter = "BUFF"},
			-- Wushoolay's Final Choice (Intellect, Proc)
			{spellID = 138786, unitID = "player", caster = "player", filter = "BUFF"},
			-- Essence of Terror (Haste, Proc)
			{spellID = 126659, unitID = "player", caster = "player", filter = "BUFF"},
			-- Light of the Cosmos (Intellect, Proc)
			{spellID = 126577, unitID = "player", caster = "player", filter = "BUFF"},
			-- Caster Heal
			-- Prismatic Prison of Pride (Intellect, Proc)
			{spellID = 146314, unitID = "player", caster = "player", filter = "BUFF"},
			-- Nazgrim's Burnished Insignia (Intellect, Proc)
			{spellID = 148908, unitID = "player", caster = "player", filter = "BUFF"},
			-- Thok's Acid-Grooved Tooth (Intellect, Proc)
			{spellID = 148911, unitID = "player", caster = "player", filter = "BUFF"},
			-- Qin-xi's Polarizing Seal (Intellect, Proc)
			{spellID = 126588, unitID = "player", caster = "player", filter = "BUFF"},

			-- Enchants
			-- General
			-- Caster General
			-- Jade Spirit (Intellect + Spirit)
			{spellID = 104993, unitID = "player", caster = "all", filter = "BUFF"},
			-- Lightweave (Intellect)
			--{spellID = 125487, unitID = "player", caster = "player", filter = "BUFF"},
			-- Caster Heal

			-- ��ɫ���
			--{spellID = 137596, unitID = "player", caster = "all", filter = "BUFF"},
			-- ����֮Դ�� (����, ����)
			{spellID = 137590, unitID = "player", caster = "all", filter = "BUFF"},
			-- Ӣ��֮Դ�� (����, ����)
			{spellID = 137288, unitID = "player", caster = "all", filter = "BUFF"},

			-- ʷʫ����
			-- Spirit of Chi-Ji
			{spellID = 146200, unitID = "player", caster = "all", filter = "BUFF"},
		},
		{
			Name = "T_DEBUFF_ICON",
			Direction = "RIGHT",
			Mode = "ICON",
			Interval = 3,
			Alpha = 1,
			IconSize = Misc.IconSize,
			Position = {unpack(Filger_Settings.target_debuff_icon)},

			-- Void Tendril's Grasp
			{spellID = 114404, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- Glyph of Mind Blast
			{spellID = 87194, unitID = "target", caster = "player", filter = "DEBUFF"},
		},
		{
			Name = "T_DE/BUFF_BAR",
			enable = Misc.Tbar,
			Direction = "UP",
			IconSide = "LEFT",
			Mode = "BAR",
			Interval = 3,
			Alpha = 1,
			IconSize = Misc.barIconSize,
			BarWidth = Misc.barw,
			Position = {unpack(Filger_Settings.target_bar)},

			-- Renew
			{spellID = 139, unitID = "target", caster = "player", filter = "BUFF"},
			-- Prayer of Mending
			{spellID = 41635, unitID = "target", caster = "player", filter = "BUFF"},
			-- Guardian Spirit
			{spellID = 47788, unitID = "target", caster = "player", filter = "BUFF"},
			-- Pain Suppression
			{spellID = 33206, unitID = "target", caster = "player", filter = "BUFF"},
			-- Shadow Word: Pain
			{spellID = 589, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- Vampiric Touch
			{spellID = 34914, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- Devouring Plague
			{spellID = 2944, unitID = "target", caster = "player", filter = "DEBUFF"},
		},
		{
			Name = "PVE/PVP_CC",
			enable = Misc.Pbar,
			Direction = "DOWN",
			IconSide = "LEFT",
			Mode = "BAR",
			Interval = 3,
			Alpha = 1,
			IconSize = Misc.barIconSize,
			BarWidth = Misc.barw,
			Position = {unpack(Filger_Settings.pve_cc)},

			-- Shackle Undead
			{spellID = 9484, unitID = "focus", caster = "player", filter = "DEBUFF"},
			-- Psychic Scream
			{spellID = 8122, unitID = "focus", caster = "player", filter = "DEBUFF"},
		},
		{
			Name = "COOLDOWN",
			enable = Misc.CD,
			Direction = "RIGHT",
			Mode = "ICON",
			NumPerLine = Misc.CDnum,
			Interval = 3,
			Alpha = 1,
			IconSize = Misc.CDIconSize,
			Position = {unpack(Filger_Settings.cooldown)},

			-- Self
			-- Purify
			{spellID = 527, filter = "CD"},
			-- Mass Dispel
			{spellID = 32375, filter = "CD"},
			-- Penance
			{spellID = 47540, filter = "CD"},
			-- Mind Blast
			{spellID = 8092, filter = "CD"},
			-- Holy Fire
			{spellID = 14914, filter = "CD"},
			-- Circle of Healing
			{spellID = 34861, filter = "CD"},
			-- Prayer of Mending
			{spellID = 33076, filter = "CD"},
			-- Divine Star
			{spellID = 110744, filter = "CD"},
			-- Cascade
			{spellID = 121135, filter = "CD"},
			-- Archangel
			{spellID = 81700, filter = "CD"},
			-- Holy Word: Chastise
			{spellID = 88625, filter = "CD"},
			-- Halo
			{spellID = 120517, filter = "CD"},
			-- Shadow Word: Death
			{spellID = 32379, filter = "CD"},
			-- Psychic Scream
			{spellID = 8122, filter = "CD"},
			-- Psychic Horror
			{spellID = 64044, filter = "CD"},
			-- Silence
			{spellID = 15487, filter = "CD"},
			-- Power Infusion
			{spellID = 10060, filter = "CD"},
			-- Dispersion
			{spellID = 47585, filter = "CD"},
			-- Pain Suppression
			{spellID = 33206, filter = "CD"},
			-- Guardian Spirit
			{spellID = 47788, filter = "CD"},
			-- Power Word: Barrier
			{spellID = 62618, filter = "CD"},
			-- Desperate Prayer
			{spellID = 19236, filter = "CD"},
			-- Leap of Faith
			{spellID = 73325, filter = "CD"},
			-- Void Tendrils
			{spellID = 108920, filter = "CD"},

			-- Racial
			-- Every Man for Himself (Human)
			{spellID = 59752, filter = "CD"},
			-- Stoneform (Dwarf)
			{spellID = 20594, filter = "CD"},
			-- Shadowmeld (Night Elf)
			{spellID = 58984, filter = "CD"},
			-- Escape Artist (Gnome)
			{spellID = 20589, filter = "CD"},
			-- Gift of the Naaru (Draenei)
			{spellID = 28880, filter = "CD"},
			-- Darkflight (Worgen)
			{spellID = 68992, filter = "CD"},
			-- Will of the Forsaken (Forsaken)
			{spellID = 7744, filter = "CD"},
			-- Cannibalize (Forsaken)
			{spellID = 20577, filter = "CD"},
			-- War Stomp (Tauren)
			{spellID = 20549, filter = "CD"},
			-- Berserking (Troll)
			{spellID = 26297, filter = "CD"},
			-- Arcane Torrent (Blood Elf)
			{spellID = 69179, filter = "CD"},
			-- Rocket Jump (Goblin)
			{spellID = 69070, filter = "CD"},
			-- Quaking Palm (Pandaren)
			{spellID = 107079, filter = "CD"},

			-- Items
			-- Gloves
			{slotID = 10, filter = "CD"},
			-- Belt
			{slotID = 6, filter = "CD"},
			-- Back
			{slotID = 15, filter = "CD"},
			-- Trinkets
			{slotID = 13, filter = "CD"},
			{slotID = 14, filter = "CD"},

			-- Internal
			-- Lightweave
			--{spellID = 125487, filter = "ICD", trigger = "BUFF", duration = 60},
			-- Purified Bindings of Immerseus (Intellect, Proc)
			{spellID = 146046, filter = "ICD", trigger = "BUFF", duration = 115},
		},
	},
	["ROGUE"] = {			--[����]
		{
			Name = "P_BUFF_ICON",
			Direction = "LEFT",
			Mode = "ICON",
			Interval = 3,
			Alpha = 1,
			IconSize = Misc.IconSize,
			Position = {unpack(Filger_Settings.player_buff_icon)},

			-- Slice and Dice
			{spellID = 5171, unitID = "player", caster = "player", filter = "BUFF"},
			-- Recuperate
			{spellID = 73651, unitID = "player", caster = "player", filter = "BUFF"},
			-- Adrenaline Rush
			{spellID = 13750, unitID = "player", caster = "player", filter = "BUFF"},
			-- Evasion
			{spellID = 5277, unitID = "player", caster = "player", filter = "BUFF"},
			-- Envenom
			{spellID = 32645, unitID = "player", caster = "player", filter = "BUFF"},
			-- Shadow Dance
			{spellID = 51713, unitID = "player", caster = "player", filter = "BUFF"},
			-- Master of Subtlety
			{spellID = 31665, unitID = "player", caster = "player", filter = "BUFF"},
			-- Cloak of Shadows
			{spellID = 31224, unitID = "player", caster = "player", filter = "BUFF"},
			-- Vanish
			{spellID = 1856, unitID = "player", caster = "player", filter = "BUFF"},
			-- Combat Readiness
			{spellID = 74001, unitID = "player", caster = "player", filter = "BUFF"},
			-- Combat Insight
			{spellID = 74002, unitID = "player", caster = "player", filter = "BUFF"},
			-- Cheating Death
			{spellID = 45182, unitID = "player", caster = "player", filter = "BUFF"},
			-- Blade Flurry
			{spellID = 13877, unitID = "player", caster = "player", filter = "BUFF"},
			-- Sprint
			{spellID = 2983, unitID = "player", caster = "player", filter = "BUFF"},
			-- Feint
			{spellID = 1966, unitID = "player", caster = "player", filter = "BUFF"},
			-- Subterfuge
			{spellID = 115192, unitID = "player", caster = "player", filter = "BUFF"},
		},
		{
			Name = "P_PROC_ICON",
			Direction = "RIGHT",
			Mode = "ICON",
			Interval = 3,
			Alpha = 1,
			IconSize = Misc.IconSize,
			Position = {unpack(Filger_Settings.player_proc_icon)},

			-- Buffs
			-- Anticipation
			{spellID = 115189, unitID = "player", caster = "player", filter = "BUFF"},
			-- Shallow Insight
			{spellID = 84745, unitID = "player", caster = "player", filter = "BUFF"},
			-- Moderate Insight
			{spellID = 84746, unitID = "player", caster = "player", filter = "BUFF"},
			-- Deep Insight
			{spellID = 84747, unitID = "player", caster = "player", filter = "BUFF"},
			-- Blindside
			{spellID = 121153, unitID = "player", caster = "player", filter = "BUFF"},

			-- Trinkets
			-- General
			-- Darkmoon Cards (Proc)
			{spellID = 128985, unitID = "player", caster = "player", filter = "BUFF"},
			-- PvP Trinkets (Health, Use)
			{spellID = 126697, unitID = "player", caster = "player", filter = "BUFF"},
			-- Physical Agility DPS
			-- Assurance of Consequence (Agility, Proc)
			{spellID = 146308, unitID = "player", caster = "player", filter = "BUFF"},
			-- Haromm's Talisman (Agility, Proc)
			{spellID = 148903, unitID = "player", caster = "player", filter = "BUFF"},
			-- Sigil of Rampage (Agility, Proc)
			{spellID = 148896, unitID = "player", caster = "player", filter = "BUFF"},
			-- Ticking Ebon Detonator (Agility, Proc)
			{spellID = 146310, unitID = "player", caster = "player", filter = "BUFF"},
			-- Discipline of Xuen (Crit, Proc)
			{spellID = 146312, unitID = "player", caster = "player", filter = "BUFF"},
			-- Vicious Talisman of the Shado-Pan Assault (Agility, Proc)
			{spellID = 138699, unitID = "player", caster = "player", filter = "BUFF"},
			-- Bad Juju (Agility, Proc)
			{spellID = 138938, unitID = "player", caster = "player", filter = "BUFF"},
			-- Talisman of Bloodlust (Haste, Proc)
			{spellID = 138895, unitID = "player", caster = "player", filter = "BUFF"},
			-- Rune of Re-Origination (Convert, Proc)
			{spellID = 139120, unitID = "player", caster = "player", filter = "BUFF"},
			-- Renataki's Soul Charm (Agility, Proc)
			{spellID = 138756, unitID = "player", caster = "player", filter = "BUFF"},
			-- Arrowflight Medallion (Crit, Use)
			{spellID = 136086, unitID = "player", caster = "player", filter = "BUFF"},
			-- Terror in the Mists (Crit, Proc)
			{spellID = 126649, unitID = "player", caster = "player", filter = "BUFF"},
			-- Jade Bandit Figurine (Haste, Use)
			{spellID = 126599, unitID = "player", caster = "player", filter = "BUFF"},
			-- Bottle of Infinite Stars (Agility, Proc)
			{spellID = 126554, unitID = "player", caster = "player", filter = "BUFF"},
			-- PvP Trinkets (Agility, Use)
			{spellID = 126690, unitID = "player", caster = "player", filter = "BUFF"},
			-- PvP Trinkets (Agility, Proc)
			{spellID = 126707, unitID = "player", caster = "player", filter = "BUFF"},

			-- Enchants
			-- General
			-- Physical General
			-- Physical Melee
			-- Dancing Steel (Agility)
			{spellID = 120032, unitID = "player", caster = "all", filter = "BUFF"},
		},
		{
			Name = "T_DEBUFF_ICON",
			Direction = "RIGHT",
			Mode = "ICON",
			Interval = 3,
			Alpha = 1,
			IconSize = Misc.IconSize,
			Position = {unpack(Filger_Settings.target_debuff_icon)},

			-- Rupture
			{spellID = 1943, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- Garrote
			{spellID = 703, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- Gouge
			{spellID = 1776, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- Revealing Strike
			{spellID = 84617, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- Vendetta
			{spellID = 79140, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- Hemorrhage
			{spellID = 16511, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- Find Weakness
			{spellID = 91021, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- Deadly Poison
			{spellID = 2818, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- Crippling Poison
			{spellID = 3409, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- Wound Poison
			{spellID = 8680, unitID = "target", caster = "player", filter = "DEBUFF"},
		},
		{
			Name = "PVE/PVP_CC",
			enable = Misc.Pbar,
			Direction = "DOWN",
			IconSide = "LEFT",
			Mode = "BAR",
			Interval = 3,
			Alpha = 1,
			IconSize = Misc.barIconSize,
			BarWidth = Misc.barw,
			Position = {unpack(Filger_Settings.pve_cc)},

			-- Blind
			{spellID = 2094, unitID = "focus", caster = "player", filter = "DEBUFF"},
			-- Sap
			{spellID = 6770, unitID = "focus", caster = "player", filter = "DEBUFF"},
		},
		{
			Name = "COOLDOWN",
			enable = Misc.CD,
			Direction = "RIGHT",
			Mode = "ICON",
			NumPerLine = Misc.CDnum,
			Interval = 3,
			Alpha = 1,
			IconSize = Misc.CDIconSize,
			Position = {unpack(Filger_Settings.cooldown)},

			-- Self
			-- Stealth
			{spellID = 1784, filter = "CD"},
			-- Kick
			{spellID = 1766, filter = "CD"},
			-- Gouge
			{spellID = 1776, filter = "CD"},
			-- Kidney Shot
			{spellID = 408, filter = "CD"},
			-- Premiditation
			{spellID = 14183, filter = "CD"},
			-- Sprint
			{spellID = 2983, filter = "CD"},
			-- Killing Spree
			{spellID = 51690, filter = "CD"},
			-- Adrenaline Rush
			{spellID = 13750, filter = "CD"},
			-- Vendetta
			{spellID = 79140, filter = "CD"},
			-- Shadow Dance
			{spellID = 51713, filter = "CD"},
			-- Combat Readiness
			{spellID = 74001, filter = "CD"},
			-- Vanish
			{spellID = 1856, filter = "CD"},

			-- Racial
			-- Every Man for Himself (Human)
			{spellID = 59752, filter = "CD"},
			-- Stoneform (Dwarf)
			{spellID = 20594, filter = "CD"},
			-- Shadowmeld (Night Elf)
			{spellID = 58984, filter = "CD"},
			-- Escape Artist (Gnome)
			{spellID = 20589, filter = "CD"},
			-- Darkflight (Worgen)
			{spellID = 68992, filter = "CD"},
			-- Blood Fury (Orc)
			{spellID = 20572, filter = "CD"},
			-- Will of the Forsaken (Forsaken)
			{spellID = 7744, filter = "CD"},
			-- Cannibalize (Forsaken)
			{spellID = 20577, filter = "CD"},
			-- Berserking (Troll)
			{spellID = 26297, filter = "CD"},
			-- Arcane Torrent (Blood Elf)
			{spellID = 69179, filter = "CD"},
			-- Rocket Jump (Goblin)
			{spellID = 69070, filter = "CD"},
			-- Quaking Palm (Pandaren)
			{spellID = 107079, filter = "CD"},

			-- Items
			-- Gloves
			{slotID = 10, filter = "CD"},
			-- Belt
			{slotID = 6, filter = "CD"},
			-- Back
			{slotID = 15, filter = "CD"},
			-- Trinkets
			{slotID = 13, filter = "CD"},
			{slotID = 14, filter = "CD"},

			-- Internal
		},
	},
	["SHAMAN"] = {			--[����]
		{
			Name = "P_BUFF_ICON",
			Direction = "LEFT",
			Mode = "ICON",
			Interval = 3,
			Alpha = 1,
			IconSize = Misc.IconSize,
			Position = {unpack(Filger_Settings.player_buff_icon)},

			-- Maelstorm Weapon
			{spellID = 53817, unitID = "player", caster = "player", filter = "BUFF"},
			-- Lightning Shield
			{spellID = 324, unitID = "player", caster = "player", filter = "BUFF", spec = 1, count = 6},
			-- Shamanistic Rage
			{spellID = 30823, unitID = "player", caster = "player", filter = "BUFF"},
			-- Elemental Mastery
			{spellID = 16166, unitID = "player", caster = "player", filter = "BUFF"},
			-- Ascendance
			{spellID = 114049, unitID = "player", caster = "player", filter = "BUFF"},
			-- Spiritwalker's Grace
			{spellID = 79206, unitID = "player", caster = "player", filter = "BUFF"},
			-- Unleash Flame
			{spellID = 73683, unitID = "player", caster = "player", filter = "BUFF"},
			-- Unleash Life
			{spellID = 73685, unitID = "player", caster = "player", filter = "BUFF"},
			-- Nature Guardian
			{spellID = 31616, unitID = "player", caster = "player", filter = "BUFF"},
			-- Stone Bulwark
			{spellID = 114893, unitID = "player", caster = "player", filter = "BUFF"},
			-- Ancestral Guidance
			{spellID = 108281, unitID = "player", caster = "player", filter = "BUFF"},
			-- Astral Shift
			{spellID = 108271, unitID = "player", caster = "player", filter = "BUFF"},
		},
		{
			Name = "P_PROC_ICON",
			Direction = "RIGHT",
			Mode = "ICON",
			Interval = 3,
			Alpha = 1,
			IconSize = Misc.IconSize,
			Position = {unpack(Filger_Settings.player_proc_icon)},

			-- Buffs
			-- Lava Surge
			{spellID = 77762, unitID = "player", caster = "player", filter = "BUFF"},
			-- Elemental Blast
			{spellID = 118522, unitID = "player", caster = "player", filter = "BUFF"},
			-- Tidal Waves
			{spellID = 53390, unitID = "player", caster = "player", filter = "BUFF"},

			-- Trinkets
			-- General
			-- Darkmoon Cards (Proc)
			{spellID = 128985, unitID = "player", caster = "player", filter = "BUFF"},
			-- PvP Trinkets (Health, Use)
			{spellID = 126697, unitID = "player", caster = "player", filter = "BUFF"},
			-- Physical Agility DPS
			-- Assurance of Consequence (Agility, Proc)
			{spellID = 146308, unitID = "player", caster = "player", filter = "BUFF"},
			-- Haromm's Talisman (Agility, Proc)
			{spellID = 148903, unitID = "player", caster = "player", filter = "BUFF"},
			-- Sigil of Rampage (Agility, Proc)
			{spellID = 148896, unitID = "player", caster = "player", filter = "BUFF"},
			-- Ticking Ebon Detonator (Agility, Proc)
			{spellID = 146310, unitID = "player", caster = "player", filter = "BUFF"},
			-- Discipline of Xuen (Crit, Proc)
			{spellID = 146312, unitID = "player", caster = "player", filter = "BUFF"},
			-- Vicious Talisman of the Shado-Pan Assault (Agility, Proc)
			{spellID = 138699, unitID = "player", caster = "player", filter = "BUFF"},
			-- Bad Juju (Agility, Proc)
			{spellID = 138938, unitID = "player", caster = "player", filter = "BUFF"},
			-- Talisman of Bloodlust (Haste, Proc)
			{spellID = 138895, unitID = "player", caster = "player", filter = "BUFF"},
			-- Rune of Re-Origination (Convert, Proc)
			{spellID = 139120, unitID = "player", caster = "player", filter = "BUFF"},
			-- Renataki's Soul Charm (Agility, Proc)
			{spellID = 138756, unitID = "player", caster = "player", filter = "BUFF"},
			-- Arrowflight Medallion (Crit, Use)
			{spellID = 136086, unitID = "player", caster = "player", filter = "BUFF"},
			-- Terror in the Mists (Crit, Proc)
			{spellID = 126649, unitID = "player", caster = "player", filter = "BUFF"},
			-- Jade Bandit Figurine (Haste, Use)
			{spellID = 126599, unitID = "player", caster = "player", filter = "BUFF"},
			-- Bottle of Infinite Stars (Agility, Proc)
			{spellID = 126554, unitID = "player", caster = "player", filter = "BUFF"},
			-- PvP Trinkets (Agility, Use)
			{spellID = 126690, unitID = "player", caster = "player", filter = "BUFF"},
			-- PvP Trinkets (Agility, Proc)
			{spellID = 126707, unitID = "player", caster = "player", filter = "BUFF"},
			-- Caster General
			-- Shock-Charger Medallion Figurine (Intellect, Use)
			{spellID = 136082, unitID = "player", caster = "player", filter = "BUFF"},
			-- Jade Magistrate Figurine (Crit, Use)
			{spellID = 126605, unitID = "player", caster = "player", filter = "BUFF"},
			-- PvP Trinkets (Spell Power, Use)
			{spellID = 126683, unitID = "player", caster = "player", filter = "BUFF"},
			-- PvP Trinkets (Spell Power, Proc)
			{spellID = 126705, unitID = "player", caster = "player", filter = "BUFF"},
			-- Caster DPS
			-- Purified Bindings of Immerseus (Intellect, Proc)
			{spellID = 146046, unitID = "player", caster = "player", filter = "BUFF"},
			-- Kardris' Toxic Totem (Intellect, Proc)
			{spellID = 148906, unitID = "player", caster = "player", filter = "BUFF"},
			-- Frenzied Crystal of Rage (Intellect, Proc)
			{spellID = 148897, unitID = "player", caster = "player", filter = "BUFF"},
			-- Black Blood of Y'Shaarj (Intellect, Proc)
			{spellID = 146184, unitID = "player", caster = "player", filter = "BUFF"},
			-- Yu'lon's Bite (Crit, Proc)
			{spellID = 146218, unitID = "player", caster = "player", filter = "BUFF"},
			-- ����ľ�׼֮��
			{spellID = 138963, unitID = "player", caster = "player", filter = "BUFF"},
			-- Volatile Talisman of the Shado-Pan Assault (Haste, Proc)
			{spellID = 138703, unitID = "player", caster = "player", filter = "BUFF"},
			-- Cha-Ye's Essence of Brilliance (Intellect, Proc)
			{spellID = 139133, unitID = "player", caster = "player", filter = "BUFF"},
			-- Breath of the Hydra (Intellect, Proc)
			{spellID = 138898, unitID = "player", caster = "player", filter = "BUFF"},
			-- Wushoolay's Final Choice (Intellect, Proc)
			{spellID = 138786, unitID = "player", caster = "player", filter = "BUFF"},
			-- Essence of Terror (Haste, Proc)
			{spellID = 126659, unitID = "player", caster = "player", filter = "BUFF"},
			-- Light of the Cosmos (Intellect, Proc)
			{spellID = 126577, unitID = "player", caster = "player", filter = "BUFF"},
			-- Caster Heal
			-- Prismatic Prison of Pride (Intellect, Proc)
			{spellID = 146314, unitID = "player", caster = "player", filter = "BUFF"},
			-- Nazgrim's Burnished Insignia (Intellect, Proc)
			{spellID = 148908, unitID = "player", caster = "player", filter = "BUFF"},
			-- Thok's Acid-Grooved Tooth (Intellect, Proc)
			{spellID = 148911, unitID = "player", caster = "player", filter = "BUFF"},
			-- Qin-xi's Polarizing Seal (Intellect, Proc)
			{spellID = 126588, unitID = "player", caster = "player", filter = "BUFF"},

			-- Enchants
			-- General
			-- Physical General
			-- Physical Melee
			-- Dancing Steel (Agility)
			{spellID = 120032, unitID = "player", caster = "all", filter = "BUFF"},
			-- Caster General
			-- Jade Spirit (Intellect + Spirit)
			{spellID = 104993, unitID = "player", caster = "all", filter = "BUFF"},
			-- Lightweave (Intellect)
			--{spellID = 125487, unitID = "player", caster = "player", filter = "BUFF"},
			-- Caster Heal

			-- ��ɫ���
			-- ����֮Դ�� (����, ����)
			{spellID = 137590, unitID = "player", caster = "all", filter = "BUFF"},
			-- Ӣ��֮Դ�� (����, ����)
			{spellID = 137288, unitID = "player", caster = "all", filter = "BUFF"},

			-- ʷʫ����
			-- Spirit of Chi-Ji
			{spellID = 146200, unitID = "player", caster = "all", filter = "BUFF"},
		},
		{
			Name = "T_DEBUFF_ICON",
			Direction = "RIGHT",
			Mode = "ICON",
			Interval = 3,
			Alpha = 1,
			IconSize = Misc.IconSize,
			Position = {unpack(Filger_Settings.target_debuff_icon)},

			-- Stormstrike
			{spellID = 17364, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- Frost Shock
			{spellID = 8056, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- Flame Shock
			{spellID = 8050, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- Earthgrab
			{spellID = 64695, unitID = "target", caster = "player", filter = "DEBUFF"},
		},
		{
			Name = "T_DE/BUFF_BAR",
			enable = Misc.Tbar,
			Direction = "UP",
			IconSide = "LEFT",
			Mode = "BAR",
			Interval = 3,
			Alpha = 1,
			IconSize = Misc.barIconSize,
			BarWidth = Misc.barw,
			Position = {unpack(Filger_Settings.target_bar)},

			-- Earth Shield
			{spellID = 974, unitID = "target", caster = "player", filter = "BUFF"},
			-- Riptide
			{spellID = 61295, unitID = "target", caster = "player", filter = "BUFF"},
		},
		{
			Name = "PVE/PVP_CC",
			enable = Misc.Pbar,
			Direction = "DOWN",
			IconSide = "LEFT",
			Mode = "BAR",
			Interval = 3,
			Alpha = 1,
			IconSize = Misc.barIconSize,
			BarWidth = Misc.barw,
			Position = {unpack(Filger_Settings.pve_cc)},

			-- Hex
			{spellID = 51514, unitID = "focus", caster = "player", filter = "DEBUFF"},
		},
		{
			Name = "COOLDOWN",
			enable = Misc.CD,
			Direction = "RIGHT",
			Mode = "ICON",
			NumPerLine = Misc.CDnum,
			Interval = 3,
			Alpha = 1,
			IconSize = Misc.CDIconSize,
			Position = {unpack(Filger_Settings.cooldown)},

			-- Self
			-- Cleanse Spirit
			{spellID = 51886, filter = "CD"},
			-- Wind Shear
			{spellID = 57994, filter = "CD"},
			-- Hex
			{spellID = 51514, filter = "CD"},
			-- Earth Shock
			{spellID = 8042, filter = "CD"},
			-- Lava Burst
			{spellID = 51505, filter = "CD"},
			-- Riptide
			{spellID = 61295, filter = "CD"},
			-- Stormstrike
			{spellID = 17364, filter = "CD"},
			-- Lava Lash
			{spellID = 60103, filter = "CD"},
			-- Healing Rain
			{spellID = 73920, filter = "CD"},
			-- Elemental Blast
			{spellID = 117014, filter = "CD"},
			-- Unleash Elements
			{spellID = 73680, filter = "CD"},
			-- Thunderstorm
			{spellID = 51490, filter = "CD"},
			-- Earthbind Totem
			{spellID = 2484, filter = "CD"},
			-- Tremor Totem
			{spellID = 8143, filter = "CD"},
			-- Shamanistic Rage
			{spellID = 30823, filter = "CD"},
			-- Stone Bulwark Totem
			{spellID = 108270, filter = "CD"},
			-- Astral Shift
			{spellID = 108271, filter = "CD"},
			-- Ancestral Swiftness
			{spellID = 16188, filter = "CD"},
			-- Feral Spirit
			{spellID = 51533, filter = "CD"},
			-- Spiritwalker's Grace
			{spellID = 79206, filter = "CD"},
			-- Ancestral Guidance
			{spellID = 108281, filter = "CD"},
			-- Ascendance
			{spellID = 114049, filter = "CD"},

			-- Racial
			-- Stoneform (Dwarf)
			{spellID = 20594, filter = "CD"},
			-- Gift of the Naaru (Draenei)
			{spellID = 28880, filter = "CD"},
			-- Blood Fury (Orc)
			{spellID = 20572, filter = "CD"},
			-- War Stomp (Tauren)
			{spellID = 20549, filter = "CD"},
			-- Berserking (Troll)
			{spellID = 26297, filter = "CD"},
			-- Rocket Jump (Goblin)
			{spellID = 69070, filter = "CD"},
			-- Quaking Palm (Pandaren)
			{spellID = 107079, filter = "CD"},

			-- Items
			-- Gloves
			{slotID = 10, filter = "CD"},
			-- Belt
			{slotID = 6, filter = "CD"},
			-- Back
			{slotID = 15, filter = "CD"},
			-- Trinkets
			{slotID = 13, filter = "CD"},
			{slotID = 14, filter = "CD"},

			-- Internal
			-- Lightweave
			--{spellID = 125487, filter = "ICD", trigger = "BUFF", duration = 60},
			-- Purified Bindings of Immerseus (Intellect, Proc)
			{spellID = 146046, filter = "ICD", trigger = "BUFF", duration = 115},
		},
	},
	["WARLOCK"] = {			--[��ʿ]
		{
			Name = "P_BUFF_ICON",
			Direction = "LEFT",
			Mode = "ICON",
			Interval = 3,
			Alpha = 1,
			IconSize = Misc.IconSize,
			Position = {unpack(Filger_Settings.player_buff_icon)},

			-- Dark Bargain
			{spellID = 110913, unitID = "player", caster = "player", filter = "BUFF"},
			-- Unending Resolve
			{spellID = 104773, unitID = "player", caster = "player", filter = "BUFF"},
			-- Dark Soul: Knowledge
			{spellID = 113861, unitID = "player", caster = "player", filter = "BUFF"},
			-- Dark Soul: Misery
			{spellID = 113860, unitID = "player", caster = "player", filter = "BUFF"},
			-- Dark Soul: Instability
			{spellID = 113858, unitID = "player", caster = "player", filter = "BUFF"},
			-- Soul burn
			{spellID = 74434, unitID = "player", caster = "player", filter = "BUFF"},
			-- Soul Swap
			{spellID = 86211, unitID = "player", caster = "player", filter = "BUFF"},
			-- Burning Rush
			{spellID = 111400, unitID = "player", caster = "player", filter = "BUFF"},
			-- Fire and Brimstone ����һ�
			{spellID = 108683, unitID = "player", caster = "player", filter = "BUFF"},
		},
		{
			Name = "P_PROC_ICON",
			Direction = "RIGHT",
			Mode = "ICON",
			Interval = 3,
			Alpha = 1,
			IconSize = Misc.IconSize,
			Position = {unpack(Filger_Settings.player_proc_icon)},

			-- Buffs
			-- Molten Core
			{spellID = 122355, unitID = "player", caster = "player", filter = "BUFF"},
			-- Backdraft
			{spellID = 117828, unitID = "player", caster = "player", filter = "BUFF"},
			-- Demonic Synergy
			{spellID = 171982, unitID = "player", caster = "player", filter = "BUFF"},

			-- Item sets
			-- Ember Master (T16)
			{spellID = 145164, unitID = "player", caster = "player", filter = "BUFF"},

			-- Trinkets
			-- General
			-- Darkmoon Cards (Proc)
			{spellID = 128985, unitID = "player", caster = "player", filter = "BUFF"},
			-- PvP Trinkets (Health, Use)
			{spellID = 126697, unitID = "player", caster = "player", filter = "BUFF"},
			-- Caster General
			-- Shock-Charger Medallion Figurine (Intellect, Use)
			{spellID = 136082, unitID = "player", caster = "player", filter = "BUFF"},
			-- Jade Magistrate Figurine (Crit, Use)
			{spellID = 126605, unitID = "player", caster = "player", filter = "BUFF"},
			-- PvP Trinkets (Spell Power, Use)
			{spellID = 126683, unitID = "player", caster = "player", filter = "BUFF"},
			-- PvP Trinkets (Spell Power, Proc)
			{spellID = 126705, unitID = "player", caster = "player", filter = "BUFF"},
			-- Caster DPS
			-- Purified Bindings of Immerseus (Intellect, Proc)
			{spellID = 146046, unitID = "player", caster = "player", filter = "BUFF"},
			-- Kardris' Toxic Totem (Intellect, Proc)
			{spellID = 148906, unitID = "player", caster = "player", filter = "BUFF"},
			-- Frenzied Crystal of Rage (Intellect, Proc)
			{spellID = 148897, unitID = "player", caster = "player", filter = "BUFF"},
			-- Black Blood of Y'Shaarj (Intellect, Proc)
			{spellID = 146184, unitID = "player", caster = "player", filter = "BUFF"},
			-- Yu'lon's Bite (Crit, Proc)
			{spellID = 146218, unitID = "player", caster = "player", filter = "BUFF"},
			-- ����ľ�׼֮��
			{spellID = 138963, unitID = "player", caster = "player", filter = "BUFF"},
			-- Volatile Talisman of the Shado-Pan Assault (Haste, Proc)
			{spellID = 138703, unitID = "player", caster = "player", filter = "BUFF"},
			-- Cha-Ye's Essence of Brilliance (Intellect, Proc)
			{spellID = 139133, unitID = "player", caster = "player", filter = "BUFF"},
			-- Breath of the Hydra (Intellect, Proc)
			{spellID = 138898, unitID = "player", caster = "player", filter = "BUFF"},
			-- Wushoolay's Final Choice (Intellect, Proc)
			{spellID = 138786, unitID = "player", caster = "player", filter = "BUFF"},
			-- Essence of Terror (Haste, Proc)
			{spellID = 126659, unitID = "player", caster = "player", filter = "BUFF"},
			-- Light of the Cosmos (Intellect, Proc)
			{spellID = 126577, unitID = "player", caster = "player", filter = "BUFF"},

			-- Enchants
			-- General
			-- Caster General
			-- Jade Spirit (Intellect + Spirit)
			{spellID = 104993, unitID = "player", caster = "all", filter = "BUFF"},
			-- Lightweave (Intellect)
			--{spellID = 125487, unitID = "player", caster = "player", filter = "BUFF"},

			-- ��ɫ���
			-- ����֮Դ�� (����, ����)
			{spellID = 137590, unitID = "player", caster = "all", filter = "BUFF"},
		},
		{
			Name = "T_DEBUFF_ICON",
			Direction = "RIGHT",
			Mode = "ICON",
			Interval = 3,
			Alpha = 1,
			IconSize = Misc.IconSize,
			Position = {unpack(Filger_Settings.target_debuff_icon)},

			-- Self
			-- Enslave Demon
			{spellID = 1098, unitID = "target", caster = "player", filter = "DEBUFF"},
            ----------++++++++++++
            {spellID = 34889, unitID = "target", caster = "all", filter = "DEBUFF"},
			{spellID = 980, unitID = "target", caster = "player", filter = "DEBUFF"},
			{spellID = 146739, unitID = "target", caster = "player", filter = "DEBUFF"},
			{spellID = 30108, unitID = "target", caster = "player", filter = "DEBUFF"},
			{spellID = 48181, unitID = "target", caster = "player", filter = "DEBUFF"},
			{spellID = 348, unitID = "target", caster = "player", filter = "DEBUFF"},
			{spellID = 80240, unitID = "target", caster = "player", filter = "DEBUFF"},
		},
		{
			Name = "T_DE/BUFF_BAR",
			enable = Misc.Tbar,
			Direction = "UP",
			IconSide = "LEFT",
			Mode = "BAR",
			Interval = 3,
			Alpha = 1,
			IconSize = Misc.barIconSize,
			BarWidth = Misc.barw,
			Position = {unpack(Filger_Settings.target_bar)},

			-- Doom
			{spellID = 603, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- Agony
			{spellID = 980, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- Corruption
			{spellID = 146739, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- Seed of Corruption
			{spellID = 27243, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- Immolate
			{spellID = 348, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- Unstable Affliction
			{spellID = 30108, unitID = "target", caster = "player", filter = "DEBUFF", absID = true},
			-- Haunt
			{spellID = 48181, unitID = "target", caster = "player", filter = "DEBUFF"},
		},
		{
			Name = "PVE/PVP_CC",
			enable = Misc.Pbar,
			Direction = "DOWN",
			IconSide = "LEFT",
			Mode = "BAR",
			Interval = 3,
			Alpha = 1,
			IconSize = Misc.barIconSize,
			BarWidth = Misc.barw,
			Position = {unpack(Filger_Settings.pve_cc)},

			-- Fear
			{spellID = 118699, unitID = "focus", caster = "player", filter = "DEBUFF"},
			-- Banish
			{spellID = 710, unitID = "focus", caster = "player", filter = "DEBUFF"},
		},
		{
			Name = "COOLDOWN",
			enable = Misc.CD,
			Direction = "RIGHT",
			Mode = "ICON",
			NumPerLine = Misc.CDnum,
			Interval = 3,
			Alpha = 1,
			IconSize = Misc.CDIconSize,
			Position = {unpack(Filger_Settings.cooldown)},

			-- Self
			-- Devour Magic (Felhunter)
			{spellID = 19505, filter = "CD"},
			-- Spell Lock (Felhunter)
			{spellID = 19647, filter = "CD"},
			-- Shadowfury
			{spellID = 30283, filter = "CD"},
			-- Howl of Terror
			{spellID = 5484, filter = "CD"},
			-- Mortal Coil
			{spellID = 6789, filter = "CD"},
			-- Sacrifice (Voidwalker)
			{spellID = 7812, filter = "CD"},
			-- Hand of Gul'dan
			{spellID = 105174, filter = "CD"},
			-- Demonic Circle: Teleport
			{spellID = 48020, filter = "CD"},
			-- Felstorm
			{spellID = 89751, filter = "CD"},
			-- Soulburn
			{spellID = 74434, filter = "CD"},
			-- Grimoire of Service
			{spellID = 108501, filter = "CD"},

			-- Racial
			-- Every Man for Himself (Human)
			{spellID = 59752, filter = "CD"},
			-- Stoneform (Dwarf)
			{spellID = 20594, filter = "CD"},
			-- Escape Artist (Gnome)
			{spellID = 20589, filter = "CD"},
			-- Darkflight (Worgen)
			{spellID = 68992, filter = "CD"},
			-- Blood Fury (Orc)
			{spellID = 20572, filter = "CD"},
			-- Will of the Forsaken (Forsaken)
			{spellID = 7744, filter = "CD"},
			-- Cannibalize (Forsaken)
			{spellID = 20577, filter = "CD"},
			-- Berserking (Troll)
			{spellID = 26297, filter = "CD"},
			-- Arcane Torrent (Blood Elf)
			{spellID = 69179, filter = "CD"},
			-- Rocket Jump (Goblin)
			{spellID = 69070, filter = "CD"},

			-- Items
			-- Gloves
			{slotID = 10, filter = "CD"},
			-- Belt
			{slotID = 6, filter = "CD"},
			-- Back
			{slotID = 15, filter = "CD"},
			-- Trinkets
			{slotID = 13, filter = "CD"},
			{slotID = 14, filter = "CD"},

			-- Internal
			-- Lightweave
			--{spellID = 125487, filter = "ICD", trigger = "BUFF", duration = 60},
			-- Purified Bindings of Immerseus (Intellect, Proc)
			{spellID = 146046, filter = "ICD", trigger = "BUFF", duration = 115},
		},
	},
	["WARRIOR"] = {			--[սʿ]
		{
			Name = "P_BUFF_ICON",
			Direction = "LEFT",
			Mode = "ICON",
			Interval = 3,
			Alpha = 1,
			IconSize = Misc.IconSize,
			Position = {unpack(Filger_Settings.player_buff_icon)},

			-- Shield Wall
			{spellID = 871, unitID = "player", caster = "player", filter = "BUFF"},
			-- Last Stand
			{spellID = 12975, unitID = "player", caster = "player", filter = "BUFF"},
			-- Enraged Regeneration
			{spellID = 55694, unitID = "player", caster = "player", filter = "BUFF"},
			-- Shield Block
			{spellID = 2565, unitID = "player", caster = "player", filter = "BUFF"},
			-- Shield Barrier
			{spellID = 112048, unitID = "player", caster = "player", filter = "BUFF"},
			-- Spell Reflection
			{spellID = 23920, unitID = "player", caster = "player", filter = "BUFF"},
			-- Die by the Sword
			{spellID = 118038, unitID = "player", caster = "player", filter = "BUFF"},
			-- Berserker Rage
			{spellID = 18499, unitID = "player", caster = "player", filter = "BUFF"},
			-- Avatar
			{spellID = 107574, unitID = "player", caster = "player", filter = "BUFF"},
			-- Bloodbath
			{spellID = 12292, unitID = "player", caster = "player", filter = "BUFF"},
			-- Recklesness
			{spellID = 1719, unitID = "player", caster = "player", filter = "BUFF"},
			-- Shield Charge
			{spellID = 169667, unitID = "player", caster = "player", filter = "BUFF"},
			-- Sweeping Strikes
			{spellID = 12328, unitID = "player", caster = "player", filter = "BUFF"},
			-- Victorious
			{spellID = 32216, unitID = "player", caster = "player", filter = "BUFF"},
		},
		{
			Name = "P_PROC_ICON",
			Direction = "RIGHT",
			Mode = "ICON",
			Interval = 3,
			Alpha = 1,
			IconSize = Misc.IconSize,
			Position = {unpack(Filger_Settings.player_proc_icon)},

			-- Raging Blow ŭ��
			{spellID = 131116, unitID = "player", caster = "player", filter = "BUFF"},
			-- Sudden Death ���
			{spellID = 52437, unitID = "player", caster = "player", filter = "BUFF"},
			-- Bloodsurge
			{spellID = 46916, unitID = "player", caster = "player", filter = "BUFF"},
			-- Sword and Board
			{spellID = 50227, unitID = "player", caster = "player", filter = "BUFF"},
			-- Ultimatum
			{spellID = 122510, unitID = "player", caster = "player", filter = "BUFF"},
			-- Meat Cleaver
			{spellID = 85739, unitID = "player", caster = "player", filter = "BUFF"},
			-- Unyielding Strikes
			{spellID = 169686, unitID = "player", caster = "player", filter = "BUFF"},
			-- Enrage
			{spellID = 12880, unitID = "player", caster = "player", filter = "BUFF"},
			-- Rude Interruption
			{spellID = 86663, unitID = "player", caster = "player", filter = "BUFF"},

			-- Trinkets
			-- General
			-- Darkmoon Cards (Proc)
			{spellID = 128985, unitID = "player", caster = "player", filter = "BUFF"},
			-- PvP Trinkets (Health, Use)
			{spellID = 126697, unitID = "player", caster = "player", filter = "BUFF"},
			-- Tank
			-- Rook's Unlucky Talisman (Reduces damage, Use)
			{spellID = 146343, unitID = "player", caster = "player", filter = "BUFF"},
			-- Resolve of Niuzao (Dodge, Use)
			{spellID = 146344, unitID = "player", caster = "player", filter = "BUFF"},
			-- Steadfast Talisman of the Shado-Pan Assault (Dodge, Use)
			{spellID = 138728, unitID = "player", caster = "player", filter = "BUFF"},
			-- Delicate Vial of the Sanguinaire (Mastery, Proc)
			{spellID = 138864, unitID = "player", caster = "player", filter = "BUFF"},
			-- Stuff of Nightmares (Dodge, Proc)
			{spellID = 126646, unitID = "player", caster = "player", filter = "BUFF"},
			-- Vial of Dragon's Blood (Dodge, Proc)
			{spellID = 126533, unitID = "player", caster = "player", filter = "BUFF"},
			-- Jade Warlord Figurine (Mastery, Use)
			{spellID = 126597, unitID = "player", caster = "player", filter = "BUFF"},
			-- Physical Strength DPS
			-- Evil Eye of Galakras (Strength, Proc)
			{spellID = 146245, unitID = "player", caster = "player", filter = "BUFF"},
			-- Thok's Tail Tip (Strength, Proc)
			{spellID = 146250, unitID = "player", caster = "player", filter = "BUFF", absID = true},
			-- Skeer's Bloodsoaked Talisman (Strength, Proc)
			{spellID = 146285, unitID = "player", caster = "player", filter = "BUFF"},
			-- Fusion-Fire Core (Strength, Proc)
			{spellID = 148899, unitID = "player", caster = "player", filter = "BUFF", absID = true},
			-- Alacrity of Xuen (Haste, Proc)
			{spellID = 146296, unitID = "player", caster = "player", filter = "BUFF"},
			-- Brutal Talisman of the Shado-Pan Assault (Strength, Proc)
			{spellID = 138702, unitID = "player", caster = "player", filter = "BUFF"},
			-- Fabled Feather of Ji-Kun (Strength, Proc)
			{spellID = 138759, unitID = "player", caster = "player", filter = "BUFF"},
			-- Spark of Zandalar (Strength, Proc)
			{spellID = 138958, unitID = "player", caster = "player", filter = "BUFF"},
			-- Primordius' Talisman of Rage (Strength, Proc)
			{spellID = 138870, unitID = "player", caster = "player", filter = "BUFF"},
			-- Gaze of the Twins (Crit, Proc)
			{spellID = 139170, unitID = "player", caster = "player", filter = "BUFF"},
			-- Helmbreaker Medallion (Crit, Use)
			{spellID = 136084, unitID = "player", caster = "player", filter = "BUFF"},
			-- Darkmist Vortex (Haste, Proc)
			{spellID = 126657, unitID = "player", caster = "player", filter = "BUFF"},
			-- Lei Shin's Final Orders (Strength, Proc)
			{spellID = 126582, unitID = "player", caster = "player", filter = "BUFF"},
			-- Jade Charioteer Figurine (Strength, Use)
			{spellID = 126599, unitID = "player", caster = "player", filter = "BUFF"},
			-- Iron Belly Wok (Haste, Use)
			{spellID = 129812, unitID = "player", caster = "player", filter = "BUFF"},
			-- PvP Trinkets (Strength, Use)
			{spellID = 126679, unitID = "player", caster = "player", filter = "BUFF"},
			-- PvP Trinkets (Strength, Proc)
			{spellID = 126700, unitID = "player", caster = "player", filter = "BUFF"},
			-- ̼��챦ʯ
			{spellID = 126513, unitID = "player", caster = "player", filter = "BUFF"},

			-- Enchants
			-- General
			-- Tank
			-- River's Song (Dodge)
			{spellID = 116660, unitID = "player", caster = "all", filter = "BUFF"},
			-- Physical General
			-- Physical Melee
			-- Dancing Steel (Strength)
			{spellID = 120032, unitID = "player", caster = "all", filter = "BUFF"},

			-- ��ɫ���
			-- ����֮Դ�� (����, ����)
			{spellID = 137593, unitID = "player", caster = "all", filter = "BUFF", absID = true},
		},
		{
			Name = "T_DEBUFF_ICON",
			Direction = "RIGHT",
			Mode = "ICON",
			Interval = 3,
			Alpha = 1,
			IconSize = Misc.IconSize,
			Position = {unpack(Filger_Settings.target_debuff_icon)},

			-- ˺��
			{spellID = 772, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- Colossus Smash
			{spellID = 86346, unitID = "target", caster = "player", filter = "DEBUFF"},
			-- Hamstring
			{spellID = 1715, unitID = "target", caster = "all", filter = "DEBUFF"},
			-- Demoralizing Shout
			{spellID = 1160, unitID = "target", caster = "all", filter = "DEBUFF"},
		},
		{
			Name = "COOLDOWN",
			enable = Misc.CD,
			Direction = "RIGHT",
			Mode = "ICON",
			NumPerLine = Misc.CDnum,
			Interval = 3,
			Alpha = 1,
			IconSize = Misc.CDIconSize,
			Position = {unpack(Filger_Settings.cooldown)},

			-- Self
			-- Pummel
			{spellID = 6552, filter = "CD"},
			-- Shield Slam
			{spellID = 23922, filter = "CD"},
			-- Shockwave
			{spellID = 46968, filter = "CD"},
			-- Storm Bolt
			{spellID = 107570, filter = "CD"},
			-- Thunder Clap
			{spellID = 6343, filter = "CD"},
			-- Taunt
			{spellID = 355, filter = "CD"},
			-- Colossus Smash
			{spellID = 86346, filter = "CD"},
			-- Charge
			{spellID = 100, filter = "CD"},
			-- Spell Reflection
			{spellID = 23920, filter = "CD"},
			-- Intervene
			{spellID = 3411, filter = "CD"},
			-- Berserker Rage
			{spellID = 18499, filter = "CD"},
			-- Heroic Leap
			{spellID = 6544, filter = "CD"},
			-- Demoralizing Shout
			{spellID = 1160, filter = "CD"},
			-- Enraged Regeneration
			{spellID = 55694, filter = "CD"},
			-- Commanding Shout
			--{spellID = 469, filter = "CD"},
			-- Shield Wall
			{spellID = 871, filter = "CD"},
			-- Last Stand
			{spellID = 12975, filter = "CD"},
			-- Rallying Cry
			{spellID = 97462, filter = "CD"},

			-- Racial
			-- Every Man for Himself (Human)
			{spellID = 59752, filter = "CD"},
			-- Stoneform (Dwarf)
			{spellID = 20594, filter = "CD"},
			-- Shadowmeld (Night Elf)
			{spellID = 58984, filter = "CD"},
			-- Escape Artist (Gnome)
			{spellID = 20589, filter = "CD"},
			-- Gift of the Naaru (Draenei)
			{spellID = 28880, filter = "CD"},
			-- Darkflight (Worgen)
			{spellID = 68992, filter = "CD"},
			-- Blood Fury (Orc)
			{spellID = 20572, filter = "CD"},
			-- Will of the Forsaken (Forsaken)
			{spellID = 7744, filter = "CD"},
			-- Cannibalize (Forsaken)
			{spellID = 20577, filter = "CD"},
			-- War Stomp (Tauren)
			{spellID = 20549, filter = "CD"},
			-- Berserking (Troll)
			{spellID = 26297, filter = "CD"},
			-- Arcane Torrent (Blood Elf)
			{spellID = 69179, filter = "CD"},
			-- Rocket Jump (Goblin)
			{spellID = 69070, filter = "CD"},
			-- Quaking Palm (Pandaren)
			{spellID = 107079, filter = "CD"},

			-- Items
			-- Gloves����
			{slotID = 10, filter = "CD"},
			-- Belt����
			{slotID = 6, filter = "CD"},
			-- Back����
			{slotID = 15, filter = "CD"},
			-- Trinkets��Ʒ
			{slotID = 13, filter = "CD"},
			{slotID = 14, filter = "CD"},

			-- Internal
		},
	},
	["ALL"] = {			--[����]
		{
			Name = "SPECIAL_P_BUFF_ICON",
			Direction = "LEFT",
			Mode = "ICON",
			Interval = 3,
			Alpha = 1,
			IconSize = Misc.IconSize,
			Position = {unpack(Filger_Settings.special_proc_icon)},

			-- Potions
			-- Draenic Agility Potion
			{spellID = 156423, unitID = "player", caster = "player", filter = "BUFF"},
			-- Draenic Intellect Potion
			{spellID = 156426, unitID = "player", caster = "player", filter = "BUFF"},
			-- Draenic Strength Potion
			{spellID = 156428, unitID = "player", caster = "player", filter = "BUFF"},
			-- Draenic Armor Potion
			{spellID = 156430, unitID = "player", caster = "player", filter = "BUFF"},
			-- Virmen's Bite
			{spellID = 105697, unitID = "player", caster = "player", filter = "BUFF"},
			-- Potion of Mogu Power
			{spellID = 105706, unitID = "player", caster = "player", filter = "BUFF"},
			-- Potion of the Jade Serpent
			{spellID = 105702, unitID = "player", caster = "player", filter = "BUFF"},
			-- Kafa Press �Ƿ�����(����+4000��25��)
			{spellID = 125282, unitID = "player", caster = "player", filter = "BUFF"},
			-- Speed (Potion)
			{spellID = 2379, unitID = "player", caster = "player", filter = "BUFF", absID = true},
			-- Speed (BG)
			{spellID = 23451, unitID = "player", caster = "all", filter = "BUFF", absID = true},

			-- Leeroy Jenkins
			-- Bloodlust
			{spellID = 2825, unitID = "player", caster = "all", filter = "BUFF"},
			-- Heroism
			{spellID = 32182, unitID = "player", caster = "all", filter = "BUFF"},
			-- Time Warp
			{spellID = 80353, unitID = "player", caster = "all", filter = "BUFF"},
			-- Ancient Hysteria
			{spellID = 90355, unitID = "player", caster = "all", filter = "BUFF"},
			-- Drums of Rage
			{spellID = 146555, unitID = "player", caster = "all", filter = "BUFF"},
			
			-- Professions
			-- Nitro Boosts
			{spellID = 54861, unitID = "player", caster = "player", filter = "BUFF"},
			-- Parachute
			{spellID = 55001, unitID = "player", caster = "player", filter = "BUFF"},

			-- Racial
			-- Berserking (Troll)
			{spellID = 26297, unitID = "player", caster = "player", filter = "BUFF", absID = true},
			-- Stoneform (Dwarf)
			{spellID = 65116, unitID = "player", caster = "player", filter = "BUFF"},
			-- Blood Fury (Orc)
			{spellID = 20572, unitID = "player", caster = "player", filter = "BUFF"},
			-- Darkflight (Worgen)
			{spellID = 68992, unitID = "player", caster = "player", filter = "BUFF"},
			-- Shadowmeld (Night Elf)
			{spellID = 58984, unitID = "player", caster = "player", filter = "BUFF"},
			-- Gift of the Naaru (Draenei)
			{spellID = 28880, unitID = "player", caster = "all", filter = "BUFF"},

			-- Other
			-- Hand of Protection
			{spellID = 1022, unitID = "player", caster = "all", filter = "BUFF"},
			-- Hand of Freedom
			{spellID = 1044, unitID = "player", caster = "all", filter = "BUFF"},
			-- Hand of Sacrifice
			{spellID = 6940, unitID = "player", caster = "all", filter = "BUFF"},
			-- Hand of Purity
			{spellID = 114039, unitID = "player", caster = "all", filter = "BUFF"},
			-- Life Cocoon
			{spellID = 116849, unitID = "player", caster = "all", filter = "BUFF"},
			-- Guardian Spirit
			{spellID = 47788, unitID = "player", caster = "all", filter = "BUFF"},
			-- Pain Suppression
			{spellID = 33206, unitID = "player", caster = "all", filter = "BUFF"},
			-- Vigilance
			{spellID = 114030, unitID = "player", caster = "all", filter = "BUFF"},
			-- Ironbark
			{spellID = 102342, unitID = "player", caster = "all", filter = "BUFF"},
			-- Devotion Aura
			{spellID = 31821, unitID = "player", caster = "all", filter = "BUFF"},
			-- Rallying Cry
			{spellID = 97463, unitID = "player", caster = "all", filter = "BUFF"},
			-- Amplify Magic
			{spellID = 159916, unitID = "player", caster = "all", filter = "BUFF"},
			-- Tricks of the Trade
			{spellID = 57933, unitID = "player", caster = "all", filter = "BUFF"},
			-- Stampeding Roar
			{spellID = 77764, unitID = "player", caster = "all", filter = "BUFF"},
			-- Mass Spell Reflection
			{spellID = 114028, unitID = "player", caster = "all", filter = "BUFF"},
			-- Grounding Totem
			{spellID = 8178, unitID = "player", caster = "all", filter = "BUFF"},
			-- Lightwell Renew
			{spellID = 7001, unitID = "player", caster = "all", filter = "BUFF"},
			-- Aspect of the Fox
			{spellID = 172106, unitID = "player", caster = "all", filter = "BUFF"},
			-- Slow Fall
			{spellID = 130, unitID = "player", caster = "all", filter = "BUFF"},
			-- Levitate
			{spellID = 1706, unitID = "player", caster = "all", filter = "BUFF"},
			-- Tiger's Lust
			{spellID = 116841, unitID = "player", caster = "all", filter = "BUFF"},
			-- Body and Soul
			{spellID = 65081, unitID = "player", caster = "all", filter = "BUFF"},
			-- Angelic Feather
			{spellID = 121557, unitID = "player", caster = "all", filter = "BUFF"},
			-- Fear Ward
			{spellID = 6346, unitID = "player", caster = "all", filter = "BUFF"},
		},
		{
			Name = "PVE/PVP_DEBUFF",
			Direction = "UP",
			Mode = "ICON",
			Interval = 3,
			Alpha = 1,
			IconSize = Misc.IconSize + 20,
			Position = {unpack(Filger_Settings.pve_debuff)},

			-- Death Knight
			-- Shroud of Purgatory
			{spellID = 116888, unitID = "player", caster = "player", filter = "DEBUFF"},
			-- Gnaw (Ghoul)
			{spellID = 91800, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- Monstrous Blow (Mutated Ghoul)
			{spellID = 91797, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- Asphyxiate
			{spellID = 108194, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- Remorseless Winter
			{spellID = 115001, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- Strangulate
			{spellID = 47476, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- Dark Simulacrum
			{spellID = 77606, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- Chains of Ice
			{spellID = 45524, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- Chilblains
			{spellID = 50435, unitID = "player", caster = "all", filter = "DEBUFF"},

			-- Druid
			-- Cyclone
			{spellID = 33786, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- Mighty Bash
			{spellID = 5211, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- Maim
			{spellID = 22570, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- Rake
			{spellID = 163505, unitID = "player", caster = "all", filter = "DEBUFF", absID = true},
			-- Incapacitating Roar
			{spellID = 99, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- Solar Beam
			{spellID = 78675, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- Fae Silence
			{spellID = 114238, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- Entangling Roots
			{spellID = 339, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- Immobilized
			{spellID = 45334, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- Infected Wounds
			{spellID = 58180, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- Typhoon
			{spellID = 61391, unitID = "player", caster = "all", filter = "DEBUFF"},

			-- Hunter
			-- Aspect of the Pack
			{spellID = 13159, unitID = "player", caster = "all", filter = "BUFF"},
			-- Intimidation
			{spellID = 24394, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- Binding Shot
			{spellID = 117526, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- Freezing Trap
			{spellID = 3355, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- Wyvern Sting
			{spellID = 19386, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- Narrow Escape
			{spellID = 136634, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- Entrapment
			{spellID = 135373, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- Concussive Shot
			{spellID = 5116, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- Frozen Wake (Glyph of Freezing Trap)
			{spellID = 61394, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- Ice Trap
			{spellID = 135299, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- Frost Breath (Chimaera)
			{spellID = 54644, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- Ankle Crack (Crocolisk)
			{spellID = 50433, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- Time Warp (Warp Stalker)
			{spellID = 35346, unitID = "player", caster = "all", filter = "DEBUFF"},
			
			-- Mage
			-- Cauterize
			{spellID = 87023, unitID = "player", caster = "player", filter = "DEBUFF"},
			-- Deep Freeze
			{spellID = 44572, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- Polymorph
			{spellID = 118, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- Ring of Frost
			{spellID = 82691, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- Dragon's Breath
			{spellID = 31661, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- Frostjaw
			{spellID = 102051, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- Freeze (Pet)
			{spellID = 33395, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- Frost Nova
			{spellID = 122, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- Ice Ward
			{spellID = 111340, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- Cone of Cold
			{spellID = 120, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- Slow
			{spellID = 31589, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- Frostbolt
			{spellID = 116, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- Frostfire Bolt
			{spellID = 44614, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- Chilled
			{spellID = 7321, unitID = "player", caster = "all", filter = "DEBUFF"},

			-- Monk
			-- Paralysis
			{spellID = 115078, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- Leg Sweep
			{spellID = 119381, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- Fists of Fury
			{spellID = 120086, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- Charging Ox Wave
			{spellID = 119392, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- Disable
			{spellID = 116706, unitID = "player", caster = "all", filter = "DEBUFF", absID = true},
			
			-- Paladin
			-- Hammer of Justice
			{spellID = 853, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- Fist of Justice
			{spellID = 105593, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- Repentance
			{spellID = 20066, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- Turn Evil
			{spellID = 10326, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- Blinding Light
			{spellID = 105421, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- Avenger's Shield
			{spellID = 31935, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- Glyph of Dazing Shield
			{spellID = 63529, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- Seal of Justice
			{spellID = 20170, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- Denounce
			{spellID = 2812, unitID = "player", caster = "all", filter = "DEBUFF"},

			-- Priest
			-- Dominate Mind
			{spellID = 605, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- Psychic Scream
			{spellID = 8122, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- Psychic Horror
			{spellID = 64044, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- Sin and Punishment
			{spellID = 87204, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- Silence
			{spellID = 15487, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- Void Tendril's Grasp
			{spellID = 114404, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- Glyph of Mind Blast
			{spellID = 87194, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- Mind Flay
			{spellID = 15407, unitID = "player", caster = "all", filter = "DEBUFF"},

			-- Rogue
			-- Kidney Shot
			{spellID = 408, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- Cheap Shot
			{spellID = 1833, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- Sap
			{spellID = 6770, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- Blind
			{spellID = 2094, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- Gouge
			{spellID = 1776, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- Garrote - Silence
			{spellID = 1330, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- Smoke Bomb
			{spellID = 76577, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- Deadly Throw
			{spellID = 26679, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- Crippling Poison
			{spellID = 3409, unitID = "player", caster = "all", filter = "DEBUFF"},
			
			-- Shaman
			-- Hex
			{spellID = 51514, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- Static Charge
			{spellID = 118905, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- Pulverize (Earth Elemental)
			{spellID = 118345, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- Earthquake
			{spellID = 77505, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- Earthgrab
			{spellID = 64695, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- Earthbind
			{spellID = 3600, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- Frost Shock
			{spellID = 8056, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- Thunderstorm
			{spellID = 51490, unitID = "player", caster = "all", filter = "DEBUFF"},

			-- Warlock
			-- Shadowfury
			{spellID = 30283, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- Axe Toss (Felguard)
			{spellID = 89766, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- Fear
			{spellID = 118699, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- Howl of Terror
			{spellID = 5484, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- Blood Horror
			{spellID = 137143, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- Mortal Coil
			{spellID = 6789, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- Seduction (Succubus)
			{spellID = 6358, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- Mesmerize (Shivarra)
			{spellID = 115268, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- Unstable Affliction
			{spellID = 31117, unitID = "player", caster = "all", filter = "DEBUFF", absID = true},
			-- Conflagrate
			{spellID = 17962, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- Shadowflame
			{spellID = 47960, unitID = "player", caster = "all", filter = "DEBUFF"},

			-- Warrior
			-- Storm Bolt
			{spellID = 132169, unitID = "player", caster = "all", filter = "DEBUFF", absID = true},
			-- Shockwave
			{spellID = 132168, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- Intimidating Shout
			{spellID = 5246, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- Staggering Shout
			{spellID = 107566, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- Hamstring
			{spellID = 1715, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- Piercing Howl
			{spellID = 12323, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- Colossus Smash
			{spellID = 86346, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- Warbringer
			{spellID = 7922, unitID = "player", caster = "all", filter = "DEBUFF"},
			
			-- Racial
			-- War Stomp
			{spellID = 20549, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- Quaking Palm
			{spellID = 107079, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- Arcane Torrent
			{spellID = 28730, unitID = "player", caster = "all", filter = "DEBUFF"},

			-- Other
			-- Rocket Fuel Leak ���Ь©��
			{spellID = 94794, unitID = "player", caster = "player", filter = "DEBUFF"},
		
			--  -- <<  PVE  >> -- --
			-- Throne of Thunder	-- �׵����� 930
			-- Jin'rokh the Breaker [�����߽��޿�] --
			-- Focused Lightning רע����
			{spellID = 137422, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- ���뷴Ӧ
			{spellID = 138732, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- ���紴��
			{spellID = 138349, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- ����Ͷ��
			{spellID = 137371, unitID = "player", caster = "all", filter = "DEBUFF"},
			
			-- ������ --
			-- ���ش���
			{spellID = 136767, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- ���
			{spellID = 136769, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- ��ɳ����
			{spellID = 136723, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- �����
			{spellID = 136646, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- ��������
			{spellID = 136573, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- ��������
			{spellID = 136490, unitID = "player", caster = "all", filter = "DEBUFF"},
         
			-- Council of Elders [�������] --
			-- ����Ƭ
			{spellID = 137641, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- Marked Soul ������
			{spellID = 137359, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- Ť������
			{spellID = 137972, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- ����ͻ��
			{spellID = 136903, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- Frostbite ˪���̹�
			{spellID = 136922, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- Biting Cold �̹�֮��
			{spellID = 136992, unitID = "player", caster = "all", filter = "DEBUFF"},
			
			-- �ж�˹ --
			-- ����צ
			{spellID = 136753, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- �����׿�
			{spellID = 137633, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- �����׿ǣ��ٽ�ֵ��
			{spellID = 140701, unitID = "player", caster = "all", filter = "DEBUFF"},
			
			-- Megaera [ī������] --
			-- ȼ��Ѫ��
			{spellID = 137731, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- Torrent of Ice ��������
			{spellID = 139857, unitID = "player", caster = "all", filter = "DEBUFF"},
			{spellID = 139889, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- Cinder ȼ��
			{spellID = 134391, unitID = "player", caster = "all", filter = "DEBUFF"},
			{spellID = 139822, unitID = "player", caster = "all", filter = "DEBUFF"},
			
			-- ���d --
			-- צ��
			{spellID = 134366, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- ����֮��
			{spellID = 134339, unitID = "player", caster = "all", filter = "DEBUFF"},
			
			-- �����߶�³ķ --
			-- ��������
			{spellID = 133767, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- ����׷��
			{spellID = 139202, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- ���׷��
			{spellID = 139204, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- ǿ��
			{spellID = 133738, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- ��������
			{spellID = 134044, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- ��Ѫ
			{spellID = 133795, unitID = "player", caster = "all", filter = "DEBUFF"},
			
			-- ����Ī��˹ --
			{spellID = 136050, unitID = "player", caster = "all", filter = "DEBUFF"},
			
			-- �ڰ���־ --
			-- ��ը�ͻ�
			{spellID = 138569, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- �ɺ�׷��
			{spellID = 138480, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- ����֮��
			{spellID = 136954, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- ���ʽ���
			{spellID = 138618, unitID = "player", caster = "all", filter = "DEBUFF"},
			
			-- ��� --
			-- ����
			{spellID = 134691, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- ����
			{spellID = 134647, unitID = "player", caster = "all", filter = "DEBUFF"},
			
			-- ħ��˫�� --
			-- ������Ӱ
			{spellID = 137440, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- ��������
			{spellID = 137408, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- ��������
			{spellID = 137360, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- ������
			{spellID = 137375, unitID = "player", caster = "all", filter = "DEBUFF"},
			
			-- Lei Shen [����] --
			-- ն��
			{spellID = 135000, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- Static Shock ������
			{spellID = 135695, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- ����
			{spellID = 136295, unitID = "player", caster = "all", filter = "DEBUFF"},
		 
			
			-- Mogu'shan Vaults -- ħ��ɽ���� 896
			-- The Stone Guard [ʯͷ����]
			-- Amethyst Pool �Ͼ�֮��
			{spellID = 116235, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- Jasper Chains ��������
			{spellID = 130395, unitID = "player", caster = "all", filter = "DEBUFF"},
			
			-- Feng the Accursed [������ħ��]
			-- Wildfire Spark Ұ�Ի�
			{spellID = 116784, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- Arcane Resonance ��������
			{spellID = 116417, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- Nullification Barrier �������
			{spellID = 115856, unitID = "player", caster = "all", filter = "BUFF"},
			-- Shroud of Reversal ������
			{spellID = 115911, unitID = "player", caster = "all", filter = "BUFF"},
			
			-- Gara'jal the Spiritbinder [�����߸�����]
			-- Voodoo Doll �׶�����
			{spellID = 122151, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- Cross Over ���Խ��
			{spellID = 116166, unitID = "player", caster = "all", filter = "DEBUFF"},
			
			-- Elegon [������]
			-- Overcharged ��������
			{spellID = 117878, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- Closed Circuit ��ջ�·
			{spellID = 117949, unitID = "player", caster = "all", filter = "DEBUFF"},
			
			-- Will of the Emperor [�ʵ۵���־]
			-- Focused Assault רע���
			{spellID = 116525, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- Focused Energy רע����
			{spellID = 116829, unitID = "player", caster = "all", filter = "DEBUFF"},
			
			
			-- Heart of Fear -- �־�֮�� 897
			-- Imperial Vizier Zor'lok [�ʼ������������]
			-- Exhale ����
			{spellID = 122761, unitID = "player", caster = "all", filter = "DEBUFF"},
			
			-- Blade Lord Ta'yak [�����������ǿ�]
			-- Overwhelming Assault ѹ��ͻϮ
			{spellID = 123474, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- Windstep ���粽
			{spellID = 123175, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- Unseen Strike ��Ӱ��
			{spellID = 123017, unitID = "player", caster = "all", filter = "DEBUFF"},
			
			-- Garalon [����¡]
			-- Pheromones ��Ϣ��
			{spellID = 123092, unitID = "player", caster = "all", filter = "DEBUFF"},
			
			-- Wind Lord Mel'Jarak [������÷��������]
			-- Wind Bomb �籬��
			{spellID = 131813, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- Amber Prison �������
			{spellID = 121885, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- Corrosive Resin ��ʴ��֬
			{spellID = 122064, unitID = "player", caster = "all", filter = "DEBUFF"},
			
			-- Amber-Shaper Un'sok [���������߰����]
			-- Burning Amber
			{spellID = 122504, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- Parasitic Growth ��������
			{spellID = 121949, unitID = "player", caster = "all", filter = "DEBUFF"},
			
			-- Grand Empress Shek'zeer [��Ů���Ŀ�ϣ��]
			-- Eyes of the Empress Ů��а��
			{spellID = 123707, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- Fixate
			-- Sticky Resin ճ����֬
			{spellID = 124097, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- Poison-Drenched Armor ��������
			{spellID = 124821, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- Consuming Terror �־�����
			{spellID = 124849, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- Visions of Demise ��������
			{spellID = 124862, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- Heart of Fear �־�֮��
			{spellID = 123845, unitID = "player", caster = "all", filter = "DEBUFF"},
			
			
			-- terrace of endless spring -- ����̨ 886
			-- Protector of the Endless [�޾��ػ���]
			-- Lightning Prison ��������
			{spellID = 111850, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- Defiled Ground �����Ⱦ
			{spellID = 117986, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- Corrupted Essence ���Ͷ��侫��
			{spellID = 117905, unitID = "player", caster = "all", filter = "DEBUFF"},
			
			-- Tsulong [����]
			-- Dread Shadows �־�֮Ӱ
			{spellID = 122768, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- Shadow Breath ��Ӱ��Ϣ
			{spellID = 122752, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- Terrorize ��Ӱ�ֲ�
			{spellID = 123011, unitID = "player", caster = "all", filter = "DEBUFF"},
			
			-- Lei Shi [��ʩ]
			-- Spray ����
			{spellID = 123121, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- Scary Fog �ֲ�����
			{spellID = 123705, unitID = "player", caster = "all", filter = "DEBUFF"},
			
			-- Sha of Fear [��֮ɷ]
			-- Fearless ��η
			{spellID = 118977, unitID = "player", caster = "all", filter = "BUFF"},
			
			
			-- ��ս�¸����� Siege Of Orgrimmar 953
			-- 1	��ī��˹ [Immerseus]
			-- аɷ��
			{spellID = 143297, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- ��ʴ���
			{spellID = 143436, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- ɷ�ܸ�ʴ H
			{spellID = 143579, unitID = "player", caster = "all", filter = "DEBUFF"},
			
			-- 2	������ػ��� [FallenProtectors]
			-- ����
			{spellID = 143198, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- ��ʹӡ��
			{spellID = 143840, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- ��Ӱ����
			{spellID = 144176, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- ɷ������
			{spellID = 143423, unitID = "player", caster = "all", filter = "DEBUFF"},
			
			-- 3	ŵ³ʲ [Norushen]
			-- ����
			{spellID = 144452, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- �Ի�
			{spellID = 146124, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- ������ʴ
			{spellID = 144514, unitID = "player", caster = "all", filter = "DEBUFF"},
			
			-- 4	��֮ɷ [ShaofPride]
			-- ��������
			{spellID = 144358, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- �����⻷
			{spellID = 146817, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- ͶӰ
			{spellID = 146822, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- ̩̹֮��
			{spellID = 146594, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- ̩̹֮��
			{spellID = 144364, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- ��ҡ�ľ��� H
			{spellID = 147207, unitID = "player", caster = "all", filter = "DEBUFF"},
			
			-- 5	������˹ [Galakras]
			-- ��������
			{spellID = 147705, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- �����
			{spellID = 146765, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- ������¡֮�� (����)
			--{spellID = 147068, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- ������¡֮�� (debuff)
			{spellID = 147029, unitID = "player", caster = "all", filter = "DEBUFF"},
			
			-- 6	����սЫ [IronJuggernaut]
			-- ȼ�ջ���
			{spellID = 144467, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- ���ѽ���
			{spellID = 144498, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- �и��
			{spellID = 146325, unitID = "player", caster = "all", filter = "DEBUFF"},
			
			-- 7	�⿨¡�ڰ����� [KorkronDarkShaman]
			-- ��˪�籩���
			{spellID = 144215, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- ˺��
			{spellID = 144304, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- �綾֮��
			{spellID = 144089, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- �������� H
			{spellID = 144330, unitID = "player", caster = "all", filter = "DEBUFF"},
			
			-- 8	���ȸ��ֽ��� [GeneralNazgrim]
			-- ����ػ�
			{spellID = 143494, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- ����ش�
			{spellID = 143638, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- �̿�ӡ��
			{spellID = 143480, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- ����ӡ��
			{spellID = 143882, unitID = "player", caster = "all", filter = "DEBUFF"},
			
			-- 9	������޿� [Malkorok]
			-- �������
			{spellID = 142990, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- ɢ������
			{spellID = 142913, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- ���� H
			{spellID = 143919, unitID = "player", caster = "all", filter = "DEBUFF"},
			
			-- 10	�˴�����ս��Ʒ [SpoilsOfPandria]
			-- ����ըҩ
			{spellID = 145987, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- Ũ����Ϣ��
			{spellID = 145747, unitID = "player", caster = "all", filter = "DEBUFF"},
			
			-- 11	��Ѫ������ [ThokTheBloodthirsty]
			-- �ֻ�
			{spellID = 143766, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- ������Ϣ
			{spellID = 143767, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- ������Ϣ
			{spellID = 143780, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- ������Ϣ
			{spellID = 143773, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- ����
			{spellID = 143445, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- ����֮Ѫ
			{spellID = 143800, unitID = "player", caster = "all", filter = "DEBUFF"},
			
			-- 12	���ǽ�ʦ���� [SiegecrafterBlackfuse]
			-- ��ɳ��
			{spellID = 143385, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- ����
			{spellID = 143856, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- ͼ��ʶ��
			{spellID = 144236, unitID = "player", caster = "all", filter = "DEBUFF"},
			
			-- 13	��������Ӣ�� [ParagonsOfTheKlaxxi]
			-- ע��
			{spellID = 143339, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- ��ɫ����
			{spellID = 142533, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- ��ɫ����
			{spellID = 142532, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- ��ɫ����
			{spellID = 142534, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- ��ɫ����
			{spellID = 142547, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- ��ɫ�߻���ը֮��
			{spellID = 142803, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- ��ɫ����
			{spellID = 142549, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- ��ɫ�߻�����֮��
			{spellID = 142945, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- ��ɫ�߻��ȹ�ȼ��
			{spellID = 143572, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- ��ɫ����
			{spellID = 142550, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- Ѫ����¶
			{spellID = 142931, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- �ӿ�
			{spellID = 143275, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- �������
			{spellID = 143279, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- ���
			{spellID = 143939, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- �ܻ�
			{spellID = 143974, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- ����ѪҺ
			{spellID = 142315, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- ������
			{spellID = 142671, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- ��׼
			{spellID = 142948, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- �׽�Ļ���
			{spellID = 142808, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- ����ȱ��
			{spellID = 148589, unitID = "player", caster = "all", filter = "DEBUFF"},
			
			-- 14	�Ӷ�³ʲ���������� [GarroshHellscream]
			-- ����֮��
			{spellID = 145183, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- ǿ������֮��
			{spellID = 145195, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- ����֮��
			{spellID = 145213, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- ����
			{spellID = 148994, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- ����
			{spellID = 148983, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- ϣ��
			{spellID = 149004, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- ����(P2)
			--{spellID = 144762, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- ����(P3)
			{spellID = 144817, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- ��ɷ��֮��
			{spellID = 145065, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- ������ɷ��֮��
			{spellID = 145171, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- ���� H
			{spellID = 147665, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- Һ̬���� H
			{spellID = 147136, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- ���� H
			{spellID = 147209, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- ������ H
			{spellID = 147235, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- ��ս�¸����� [����]
			
			
			-- ��鳱� 994
			-- 1	����˹����ȭ [Kargath Bladefist]
			-- ���� (T)
			{spellID = 159113, unitID = "player", caster = "all", filter = "DEBUFF", absID = true},
			-- ���Ѵ��� (T) 1~2��
			{spellID = 159178, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- ��������
			{spellID = 159311, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- ����ը��
			{spellID = 159386, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- ��Ű��
			{spellID = 159413, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- ��Ѱ����
			{spellID = 162497, unitID = "player", caster = "all", filter = "DEBUFF"},
			
			-- 2	���� [The Butcher]
			-- ����� (T) 2~3��
			{spellID = 156151, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- ���⵶
			{spellID = 156147, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- ���Ѵ���
			{spellID = 156152, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- �׹�����
			{spellID = 163046, unitID = "player", caster = "all", filter = "DEBUFF"},
			
			-- 3	̩��ͼ˹ [Tectus]
			-- ʯ��
			{spellID = 162892, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- ������Ļ - ����
			{spellID = 162346, unitID = "player", caster = "all", filter = "DEBUFF", absID = true},
			-- ������Ļ - �ȵ���
			{spellID = 162370, unitID = "player", caster = "all", filter = "DEBUFF", absID = true},
			
			-- 4	������˹�� [Brackenspore]
			-- ���� (T) 4~6��
			{spellID = 163241, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- ������Ϣ
			{spellID = 159220, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- ʴ�����
			{spellID = 163140, unitID = "player", caster = "all", filter = "DEBUFF"},
			{spellID = 160179, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- �������̦޺
			{spellID = 163590, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- ���ѹ�ע
			{spellID = 165223, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- �ش�����
			{spellID = 159426, unitID = "player", caster = "all", filter = "DEBUFF"},
			
			-- 5	����ħ˫�� [Twin Ogron]
			-- ��������
			{spellID = 159709, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- ��˥����
			{spellID = 158026, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- ����
			{spellID = 158241, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- ����֮�� (T)
			{spellID = 167200, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- ���ܶ���
			{spellID = 163372, unitID = "player", caster = "all", filter = "DEBUFF"},
			
			-- 6	������ [Ko'ragh]
			-- ħ��ɢ�䣺���� (T)
			{spellID = 162186, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- ħ��ɢ�䣺����
			{spellID = 162185, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- ħ��ɢ�䣺��˪
			{spellID = 172813, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- ħ��ɢ�䣺��Ӱ
			{spellID = 162184, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- �������
			{spellID = 156803, unitID = "player", caster = "all", filter = "DEBUFF"},
			{spellID = 172886, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- ѹ������
			{spellID = 161345, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- ��ʴ����
			{spellID = 161242, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- ħ��ɢ�䣺а�� - ����
			{spellID = 172895, unitID = "player", caster = "all", filter = "DEBUFF", absID = true},
			-- ħ��ɢ�䣺а�� - �ȵ���
			{spellID = 172917, unitID = "player", caster = "all", filter = "DEBUFF", absID = true},
			
			-- 7	Ԫ������߿� [Imperator Mar'gok]
			-- ������ (T) P1��T
			{spellID = 158605, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- �����ǣ�ƫ�� (T) P2��T
			{spellID = 164176, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- �����ǣ�ǿ�� (T) P3��T
			{spellID = 164178, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- �����ǣ����� (T) P4��T
			{spellID = 164191, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- ������ŭ P1
			{spellID = 156225, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- ������ŭ P2
			{spellID = 164004, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- ������ŭ P3
			{spellID = 164005, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- ������ŭ P4
			{spellID = 164006, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- ����
			{spellID = 157801, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- ����
			{spellID = 157763, unitID = "player", caster = "all", filter = "DEBUFF", absID = true},
			-- ������
			{spellID = 159200, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- ���黤��
			{spellID = 158553, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- ��鳱� [����]
			
			
			

			-- ��ʯ���쳧 988
			-- 1	��³�� [Gruul]
			-- ������� (T)
			{spellID = 162322, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- ѹ�ȴ�� (T)
			{spellID = 155078, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- �����и�
			{spellID = 155080, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- ��ʯ
			{spellID = 173192, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- ʯ��
			{spellID = 155330, unitID = "player", caster = "all", filter = "DEBUFF", absID = true},
			
			-- 2	�¶��߸� [Oregorger]
			-- ��Һ�޿� (T)
			{spellID = 173471, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- ��Һ����
			{spellID = 156297, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- Ż�º�ʯ
			{spellID = 156203, unitID = "player", caster = "all", filter = "DEBUFF"},
			
			-- 3	��������� [Beastlord Darmac]
			-- ����˺��-�� (T) ��
			{spellID = 155061, unitID = "player", caster = "all", filter = "DEBUFF", absID = true},
			-- ����˺��-BOSS (T) ��
			{spellID = 162283, unitID = "player", caster = "all", filter = "DEBUFF", absID = true},
			-- �������� (T) ��
			{spellID = 155030, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- ���黤�� (T) ��
			{spellID = 155236, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- �ض�ɽҡ
			{spellID = 162276, unitID = "player", caster = "all", filter = "DEBUFF", absID = true},
			-- ��ȼ
			{spellID = 155399, unitID = "player", caster = "all", filter = "DEBUFF"},


			
			-- 4	�����߿������� [Flamebender Ka'graz]
			-- ������Ϣ (T) 1~5 ��
			{spellID = 155074, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- �������� (T) 
			{spellID = 163284, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- ����
			{spellID = 155049, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- ���Ҽ���
			{spellID = 154932, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- ����
			{spellID = 154952, unitID = "player", caster = "all", filter = "DEBUFF", absID = true},
			-- ���ȹ��
			{spellID = 155277, unitID = "player", caster = "all", filter = "DEBUFF"},
			
			-- 5	��˹�Ӷ��븥������ [Hans'gar and Franzok]
			-- �ۼ���׵
			{spellID = 157139, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- ����ȼ��
			{spellID = 155818, unitID = "player", caster = "all", filter = "DEBUFF"},
			
			-- 6	��������� [Operator Thogar]
			-- ��ȼ (T) ��
			{spellID = 155921, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- ʵ������������
			{spellID = 165195, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- ȼ��
			{spellID = 164380, unitID = "player", caster = "all", filter = "DEBUFF"},
			
			-- 7	������¯ [The Blast Furnace]
			-- ���� (T) ��
			{spellID = 155242, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- ��� (T)
			{spellID = 155240, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- ����
			{spellID = 156932, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- ը��
			{spellID = 155192, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- ����
			{spellID = 160379, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- ���ȶ��Ļ���
			{spellID = 176121, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- ����
			{spellID = 155196, unitID = "player", caster = "all", filter = "DEBUFF", absID = true},
			-- ������
			{spellID = 155743, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- �ۻ�
			{spellID = 155225, unitID = "player", caster = "all", filter = "DEBUFF", absID = true},
			-- �ۻ�
			{spellID = 155223, unitID = "player", caster = "all", filter = "DEBUFF", absID = true},

			
			-- 8	����Ī�� [Kromog]
			-- Ť������ (T) 4~5 ��
			{spellID = 156766, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- ����֮�ط���
			{spellID = 157059, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- �����ط���
			{spellID = 161923, unitID = "player", caster = "all", filter = "DEBUFF"},
			
			-- 9	����Ů���� [The Iron Maidens]
			-- �������
			{spellID = 156631, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- ��͸���
			{spellID = 164271, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- ��Ӱ��ɱ
			{spellID = 158315, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- ��Ѫ������
			{spellID = 158010, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- ����Ͷ��
			{spellID = 158692, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- ����
			{spellID = 158702, unitID = "player", caster = "all", filter = "DEBUFF", absID = true},
			-- �Ƽ�
			{spellID = 158686, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- ����֮Ѫ
			{spellID = 158683, unitID = "player", caster = "all", filter = "DEBUFF"},
			
			-- 10	���� [Blackhand]
			-- �������
			{spellID = 156096, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- ����-��̹��׷
			{spellID = 156653, unitID = "player", caster = "all", filter = "DEBUFF", absID = true},
			-- ¯����� 156047/157018/157322
			{spellID = 156047, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- ���� 156743/175020
			{spellID = 156743, unitID = "player", caster = "all", filter = "DEBUFF", absID = true},
			-- ���������ͻ�
			{spellID = 158054, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- ȼ��
			{spellID = 162490, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- �ۻ�¯��
			{spellID = 156401, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- ����
			{spellID = 156404, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- ȼ�����
			{spellID = 156772, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- Ͷ��¯��ը��
			{spellID = 157000, unitID = "player", caster = "all", filter = "DEBUFF", absID = true},
			-- Ͷ��¯��ը�� (T)
			{spellID = 159179, unitID = "player", caster = "all", filter = "DEBUFF", absID = true},
			 
			-- ��ʯ���쳧 [����]
			
			
			-- outdoor bosses -- ��������
			-- Sha of Anger [ŭ֮ɷ]
			--Seethe
			{spellID = 119487, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- Aggressive Behavior
			{spellID = 119626, unitID = "player", caster = "all", filter = "DEBUFF"},
			-- Unleashed Wrath
			{spellID = 119488, unitID = "player", caster = "all", filter = "DEBUFF"},
			
			--Salys's Warband [����˹����]
			--Yu'lon	����(����)
			--Xuen		ѩŭ(�׻�)
			--Chi-ji	�ྫ(���)
			--Niuzao	�e��(��ţ)
			--Ordos		�Ӷ���˹(Ұţ�˻���)
			
			-- ���� [�ȸ���¡]
			{spellID = 63050, unitID = "player", caster = "all", filter = "DEBUFF"},
		},
		{
			Name = "T_BUFF",
			Direction = "UP",
			Mode = "ICON",
			Interval = 3,
			Alpha = 1,
			IconSize = Misc.IconSize + 20,
			Position = {unpack(Filger_Settings.target_buff_icon)},

			-- Death knight
			-- Anti-Magic Shell
			{spellID = 48707, unitID = "target", caster = "all", filter = "BUFF"},
			-- Desecrated Ground
			{spellID = 115018, unitID = "target", caster = "all", filter = "BUFF"},
			-- Lichborne
			{spellID = 49039, unitID = "target", caster = "all", filter = "BUFF"},
			-- Icebound Fortitude
			{spellID = 48792, unitID = "target", caster = "all", filter = "BUFF"},
			-- Pillar of Frost
			{spellID = 51271, unitID = "target", caster = "all", filter = "BUFF"},
			-- Death's Advance
			{spellID = 96268, unitID = "target", caster = "all", filter = "BUFF"},
			-- Debuffs
			-- Remorseless Winter
			{spellID = 115001, unitID = "target", caster = "all", filter = "DEBUFF", absID = true},
			-- Asphyxiate
			{spellID = 108194, unitID = "target", caster = "all", filter = "DEBUFF"},
			-- Gnaw (Ghoul)
			{spellID = 91800, unitID = "target", caster = "all", filter = "DEBUFF"},
			-- Monstrous Blow (Mutated Ghoul)
			{spellID = 91797, unitID = "target", caster = "all", filter = "DEBUFF"},
			-- Strangulate
			{spellID = 47476, unitID = "target", caster = "all", filter = "DEBUFF"},

			-- Druid
			-- Survival Instincts
			{spellID = 61336, unitID = "target", caster = "all", filter = "BUFF"},
			-- Barkskin
			{spellID = 22812, unitID = "target", caster = "all", filter = "BUFF"},
			-- Ironbark
			{spellID = 102342, unitID = "target", caster = "all", filter = "BUFF"},
			-- Nature's Grasp
			{spellID = 170856, unitID = "target", caster = "all", filter = "BUFF"},
			-- Stampeding Roar
			{spellID = 77764, unitID = "target", caster = "all", filter = "BUFF"},
			-- Incarnation: Tree of Life
			{spellID = 117679, unitID = "target", caster = "all", filter = "BUFF"},
			-- Berserk
			{spellID = 50334, unitID = "target", caster = "all", filter = "BUFF"},
			-- Debuffs
			-- Cyclone
			{spellID = 33786, unitID = "target", caster = "all", filter = "DEBUFF"},
			-- Mighty Bash
			{spellID = 5211, unitID = "target", caster = "all", filter = "DEBUFF"},
			-- Maim
			{spellID = 22570, unitID = "target", caster = "all", filter = "DEBUFF"},
			-- Rake
			{spellID = 163505, unitID = "target", caster = "all", filter = "DEBUFF", absID = true},
			-- Incapacitating Roar
			{spellID = 99, unitID = "target", caster = "all", filter = "DEBUFF"},
			-- Solar Beam
			{spellID = 78675, unitID = "target", caster = "all", filter = "DEBUFF"},
			-- Fae Silence
			{spellID = 114238, unitID = "target", caster = "all", filter = "DEBUFF"},
			-- Entangling Roots
			{spellID = 339, unitID = "target", caster = "all", filter = "DEBUFF"},

			-- Hunter
			-- Aspect of the Pack
			{spellID = 13159, unitID = "target", caster = "all", filter = "BUFF"},
			-- Aspect of the Cheetah
			{spellID = 5118, unitID = "target", caster = "all", filter = "BUFF"},
			-- Deterrence
			{spellID = 19263, unitID = "target", caster = "all", filter = "BUFF"},
			-- Posthaste
			{spellID = 118922, unitID = "target", caster = "all", filter = "BUFF"},
			-- Debuffs
			-- Freezing Trap
			{spellID = 3355, unitID = "target", caster = "all", filter = "DEBUFF"},
			-- Wyvern Sting
			{spellID = 19386, unitID = "target", caster = "all", filter = "DEBUFF"},
			-- Binding Shot
			{spellID = 117526, unitID = "target", caster = "all", filter = "DEBUFF", absID = true},
			-- Intimidation
			{spellID = 24394, unitID = "target", caster = "all", filter = "DEBUFF"},

			-- Mage
			-- Ice Block
			{spellID = 45438, unitID = "target", caster = "all", filter = "BUFF"},
			-- Invisibility
			{spellID = 66, unitID = "target", caster = "all", filter = "BUFF"},
			-- Evocation
			{spellID = 12051, unitID = "target", caster = "all", filter = "BUFF"},
			-- Temporal Shield
			{spellID = 115610, unitID = "target", caster = "all", filter = "BUFF"},
			-- Alter Time
			{spellID = 110909, unitID = "target", caster = "all", filter = "BUFF"},
			-- Debuffs
			-- Cauterize
			{spellID = 87023, unitID = "target", caster = "target", filter = "DEBUFF"},
			-- Polymorph
			{spellID = 118, unitID = "target", caster = "all", filter = "DEBUFF"},
			-- Deep Freeze
			{spellID = 44572, unitID = "target", caster = "all", filter = "DEBUFF"},
			-- Ring of Frost
			{spellID = 82691, unitID = "target", caster = "all", filter = "DEBUFF"},
			-- Dragon's Breath
			{spellID = 31661, unitID = "target", caster = "all", filter = "DEBUFF"},
			-- Frostjaw
			{spellID = 102051, unitID = "target", caster = "all", filter = "DEBUFF"},
			
			-- Monk
			-- Touch of Karma
			{spellID = 125174, unitID = "target", caster = "target", filter = "BUFF"},
			-- Ring of Peace
			{spellID = 116844, unitID = "target", caster = "target", filter = "BUFF"},
			-- Diffuse Magic
			{spellID = 122783, unitID = "target", caster = "target", filter = "BUFF"},
			-- Debuffs
			-- Paralysis
			{spellID = 115078, unitID = "target", caster = "all", filter = "DEBUFF"},
			-- Leg Sweep
			{spellID = 119381, unitID = "target", caster = "all", filter = "DEBUFF"},
			-- Fists of Fury
			{spellID = 120086, unitID = "target", caster = "all", filter = "DEBUFF"},
			-- Charging Ox Wave
			{spellID = 119392, unitID = "target", caster = "all", filter = "DEBUFF"},
			
			-- Paladin
			-- Divine Shield
			{spellID = 642, unitID = "target", caster = "all", filter = "BUFF"},
			-- Hand of Protection
			{spellID = 1022, unitID = "target", caster = "all", filter = "BUFF"},
			-- Hand of Sacrifice
			{spellID = 6940, unitID = "target", caster = "all", filter = "BUFF"},
			-- Hand of Freedom
			{spellID = 1044, unitID = "target", caster = "all", filter = "BUFF"},
			-- Hand of Purity
			{spellID = 114039, unitID = "target", caster = "all", filter = "BUFF"},
			-- Devotion Aura
			{spellID = 31821, unitID = "target", caster = "all", filter = "BUFF"},
			-- Ardent Defender
			{spellID = 31850, unitID = "target", caster = "all", filter = "BUFF"},
			-- Divine Protection
			{spellID = 498, unitID = "target", caster = "all", filter = "BUFF"},
			-- Guardian of Ancient Kings
			{spellID = 86659, unitID = "target", caster = "all", filter = "BUFF"},
			-- Debuffs
			-- Hammer of Justice
			{spellID = 853, unitID = "target", caster = "all", filter = "DEBUFF"},
			-- Fist of Justice
			{spellID = 105593, unitID = "target", caster = "all", filter = "DEBUFF"},
			-- Repentance
			{spellID = 20066, unitID = "target", caster = "all", filter = "DEBUFF"},
			-- Turn Evil
			{spellID = 10326, unitID = "target", caster = "all", filter = "DEBUFF"},
			-- Blinding Light
			{spellID = 105421, unitID = "target", caster = "all", filter = "DEBUFF"},
			-- Avenger's Shield
			{spellID = 31935, unitID = "target", caster = "all", filter = "DEBUFF"},

			-- Priest
			-- Dispersion
			{spellID = 47585, unitID = "target", caster = "all", filter = "BUFF"},
			-- Pain Suppression
			{spellID = 33206, unitID = "target", caster = "all", filter = "BUFF"},
			-- Guardian Spirit
			{spellID = 47788, unitID = "target", caster = "all", filter = "BUFF"},
			-- Phantasm
			{spellID = 114239, unitID = "target", caster = "all", filter = "BUFF"},
			-- Fear Ward
			{spellID = 6346, unitID = "target", caster = "all", filter = "BUFF"},
			-- Debuffs
			-- Dominate Mind
			{spellID = 605, unitID = "target", caster = "all", filter = "DEBUFF"},
			-- Psychic Scream
			{spellID = 8122, unitID = "target", caster = "all", filter = "DEBUFF"},
			-- Psychic Horror
			{spellID = 64044, unitID = "target", caster = "all", filter = "DEBUFF"},
			-- Silence
			{spellID = 15487, unitID = "target", caster = "all", filter = "DEBUFF"},

			-- Rogue
			-- Cloak of Shadows
			{spellID = 31224, unitID = "target", caster = "all", filter = "BUFF"},
			-- Evasion
			{spellID = 5277, unitID = "target", caster = "all", filter = "BUFF"},
			-- Cheating Death
			{spellID = 45182, unitID = "target", caster = "all", filter = "BUFF"},
			-- Combat Insight
			{spellID = 74002, unitID = "target", caster = "all", filter = "BUFF"},
			-- Shadow Dance
			{spellID = 51713, unitID = "target", caster = "all", filter = "BUFF"},
			-- Debuffs
			-- Kidney Shot
			{spellID = 408, unitID = "target", caster = "all", filter = "DEBUFF"},
			-- Cheap Shot
			{spellID = 1833, unitID = "target", caster = "all", filter = "DEBUFF"},
			-- Sap
			{spellID = 6770, unitID = "target", caster = "all", filter = "DEBUFF"},
			-- Blind
			{spellID = 2094, unitID = "target", caster = "all", filter = "DEBUFF"},
			-- Garrote - Silence
			{spellID = 1330, unitID = "target", caster = "all", filter = "DEBUFF"},
			-- Smoke Bomb
			{spellID = 76577, unitID = "target", caster = "all", filter = "DEBUFF"},

			-- Shaman
			-- Grounding Totem Effect
			{spellID = 8178, unitID = "target", caster = "all", filter = "BUFF"},
			-- Shamanistic Rage
			{spellID = 30823, unitID = "target", caster = "all", filter = "BUFF"},
			-- Spiritwalker's Grace
			{spellID = 79206, unitID = "target", caster = "all", filter = "BUFF"},
			-- Debuffs
			-- Hex
			{spellID = 51514, unitID = "target", caster = "all", filter = "DEBUFF"},
			-- Static Charge
			{spellID = 118905, unitID = "target", caster = "all", filter = "DEBUFF"},
			-- Pulverize (Earth Elemental)
			{spellID = 118345, unitID = "target", caster = "all", filter = "DEBUFF"},

			-- Warlock
			-- Dark Bargain
			{spellID = 110913, unitID = "target", caster = "all", filter = "BUFF"},
			-- Unending Resolve
			{spellID = 104773, unitID = "target", caster = "all", filter = "BUFF"},
			-- Soulstone
			{spellID = 20707, unitID = "target", caster = "all", filter = "BUFF"},
			-- Debuffs
			-- Banish
			{spellID = 710, unitID = "target", caster = "all", filter = "DEBUFF"},
			-- Shadowfury
			{spellID = 30283, unitID = "target", caster = "all", filter = "DEBUFF"},
			-- Axe Toss (Felguard)
			{spellID = 89766, unitID = "target", caster = "all", filter = "DEBUFF"},
			-- Fear
			{spellID = 118699, unitID = "target", caster = "all", filter = "DEBUFF"},
			-- Howl of Terror
			{spellID = 5484, unitID = "target", caster = "all", filter = "DEBUFF"},
			-- Blood Horror
			{spellID = 137143, unitID = "target", caster = "all", filter = "DEBUFF"},
			-- Mortal Coil
			{spellID = 6789, unitID = "target", caster = "all", filter = "DEBUFF"},
			-- Seduction (Succubus)
			{spellID = 6358, unitID = "target", caster = "all", filter = "DEBUFF"},
			-- Mesmerize (Shivarra)
			{spellID = 115268, unitID = "target", caster = "all", filter = "DEBUFF"},
			-- Unstable Affliction
			{spellID = 31117, unitID = "target", caster = "all", filter = "DEBUFF", absID = true},
			
			-- Warrior
			-- Spell Reflection
			{spellID = 23920, unitID = "target", caster = "all", filter = "BUFF"},
			-- Mass Spell Reflection
			{spellID = 114028, unitID = "target", caster = "all", filter = "BUFF"},
			-- Die by the Sword
			{spellID = 118038, unitID = "target", caster = "all", filter = "BUFF"},
			-- Shield Wall
			{spellID = 871, unitID = "target", caster = "all", filter = "BUFF"},
			-- Berserker Rage
			{spellID = 18499, unitID = "target", caster = "all", filter = "BUFF"},
			-- Last Stand
			{spellID = 12975, unitID = "target", caster = "all", filter = "BUFF"},
			-- Bladestorm
			{spellID = 46924, unitID = "target", caster = "all", filter = "BUFF"},
			-- Debuffs
			-- Storm Bolt
			{spellID = 132169, unitID = "target", caster = "all", filter = "DEBUFF", absID = true},
			-- Shockwave
			{spellID = 132168, unitID = "target", caster = "all", filter = "DEBUFF"},
			-- Intimidating Shout
			{spellID = 5246, unitID = "target", caster = "all", filter = "DEBUFF"},
			-- Silenced (Gag Order)
			{spellID = 18498, unitID = "target", caster = "all", filter = "DEBUFF"},
			-- �̶�ŭ��
			{spellID = 12323, unitID = "target", caster = "all", filter = "DEBUFF"},

			-- Racial
			-- War Stomp
			{spellID = 20549, unitID = "target", caster = "all", filter = "DEBUFF"},
			-- Quaking Palm
			{spellID = 107079, unitID = "target", caster = "all", filter = "DEBUFF"},
			-- Arcane Torrent
			{spellID = 28730, unitID = "target", caster = "all", filter = "DEBUFF"},

			-- Heart of Fear
			-- Impaling Spear (Wind Lord Mel'jarak)
			{spellID = 122224, unitID = "target", caster = "all", filter = "DEBUFF"},
		
			-- All
			-- Warsong Flag
			{spellID = 23333, unitID = "target", caster = "all", filter = "BUFF"},
			{spellID = 23335, unitID = "target", caster = "all", filter = "BUFF"},
			-- Netherstorm Flag
			{spellID = 34976, unitID = "target", caster = "all", filter = "BUFF"},
			-- Orb of Power
			{spellID = 121175, unitID = "target", caster = "all", filter = "DEBUFF"},
			-- Seaforium
			{spellID = 66271, unitID = "target", caster = "all", filter = "DEBUFF"},
			-- Drink
			{spellID = 80167, unitID = "target", caster = "all", filter = "BUFF"},
		},
	},
}