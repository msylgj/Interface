	do
		local ORD = oUF_RaidDebuffs

		if not ORD then return end
		
		ORD.ShowDispelableDebuff = true
		ORD.FilterDispellableDebuff = true
		ORD.MatchBySpellName = true
		ORD.DeepCorruption = true
		
		local function SpellName(id)
			local name = select(1, GetSpellInfo(id))
			return name	
		end

		debuffids = {			
			-----------------------------------------------------------------
			-- Mogu'shan Vaults
			-----------------------------------------------------------------
			-- The Stone Guard
			SpellName(116281),	-- Cobalt Mine Blast
			
			-- Feng the Accursed
			SpellName(116784),	-- Wildfire Spark
			SpellName(116417),	-- Arcane Resonance
			SpellName(116942),	-- Flaming Spear
			
			-- Gara'jal the Spiritbinder
			SpellName(116161),	-- Crossed Over
			SpellName(122151),	-- Voodoo Dolls
			
			-- The Spirit Kings
			SpellName(117708),	-- Maddening Shout
			SpellName(118303),	-- Fixate
			SpellName(118048),	-- Pillaged
			SpellName(118135),	-- Pinned Down
			
			-- Elegon
			SpellName(117878),	-- Overcharged
			SpellName(117949),	-- Closed Circuit
			
			-- Will of the Emperor
			SpellName(116835),	-- Devastating Arc
			SpellName(116778),	-- Focused Defense
			SpellName(116525),	-- Focused Assault
			
			-----------------------------------------------------------------
			-- Heart of Fear
			-----------------------------------------------------------------
			-- Imperial Vizier Zor'lok
			SpellName(122761),	-- Exhale
			SpellName(122760), -- Exhale
			SpellName(122740),	-- Convert
			SpellName(123812),	-- Pheromones of Zeal
			
			-- Blade Lord Ta'yak
			SpellName(123180),	-- Wind Step
			SpellName(123474),	-- Overwhelming Assault
			
			-- Garalon
			SpellName(122835),	-- Pheromones
			SpellName(123081),	-- Pungency
			
			-- Wind Lord Mel'jarak
			SpellName(122125),	-- Corrosive Resin Pool
			SpellName(121885), 	-- Amber Prison
			
			-- Amber-Shaper Un'sok
			SpellName(121949),	-- Parasitic Growth
			-- Grand Empress Shek'zeer
			
			-----------------------------------------------------------------
			-- Terrace of Endless Spring
			-----------------------------------------------------------------
			-- Protectors of the Endless
			SpellName(117436),	-- Lightning Prison
			SpellName(118091),	-- Defiled Ground
			SpellName(117519),	-- Touch of Sha 118191
			SpellName(118191),	-- Corrupted Essence (Heroic)

			-- Tsulong
			SpellName(122752),	-- Shadow Breath
			SpellName(123011),	-- Terrorize
			SpellName(116161),	-- Crossed Over
			
			-- Lei Shi
			SpellName(123121),	-- Spray
			
			-- Sha of Fear
			SpellName(119985),	-- Dread Spray
			SpellName(119086),	-- Penetrating Bolt
			SpellName(119775),	-- Reaching Attack
			SpellName(120629),	-- Reaching Attack
			
			SpellName(120669),	-- Naked and Afraid
			
			-----------------------------------------------------------------
			-- Throne of Thunder
			-----------------------------------------------------------------			
			--Trash
			SpellName(138349), -- Static Wound
			SpellName(137371), -- Thundering Throw
			
			--Horridon
			SpellName(136767), --Triple Puncture
			
			--Council of Elders
			SpellName(137641), --Soul Fragment
			SpellName(137359), --Shadowed Loa Spirit Fixate
			SpellName(137972), --Twisted Fate
			SpellName(136903), --Frigid Assault
			
			--Tortos
			SpellName(136753), --Slashing Talons
			SpellName(137633), --Crystal Shell
			
			--Megaera
			SpellName(137731), --Ignite Flesh
			
			--Ji-Kun
			SpellName(138309), --Slimed
			
			--Durumu the Forgotten
			SpellName(133767), --Serious Wound
			SpellName(133768), --Arterial Cut
			
			--Primordius
			SpellName(136050), --Malformed Blood
			
			--Dark Animus
			SpellName(138569), --Explosive Slam
			
			--Iron Qon
			SpellName(134691), --Impale
			
			--Twin Consorts
			SpellName(137440), --Icy Shadows
			SpellName(137408), --Fan of Flames
			SpellName(137360), --Corrupted Healing
			
			--Lei Shen
			SpellName(135000), --Decapitate
			
		-----------------------------------------------------------------
		-- PvP
		-----------------------------------------------------------------
			-- Death Knight
			SpellName(115001),	-- Remorseless Winter
			SpellName(108194),	-- Asphyxiate
			SpellName(47476),	-- Strangulate
			SpellName(47481),	-- Gnaw (Ghoul)
			SpellName(91797),	-- Monstrous Blow (Mutated Ghoul)
			-- Druid
			SpellName(33786),	-- Cyclone
			SpellName(2637),	-- Hibernate
			SpellName(339),		-- Entangling Roots
			SpellName(78675),	-- Solar Beam
			-- Hunter
			SpellName(3355),	-- Freezing Trap
			SpellName(117526),	-- Binding Shot
			SpellName(1513),	-- Scare Beast
			SpellName(19503),	-- Scatter Shot
			SpellName(34490),	-- Silence Shot
			SpellName(19386),	-- Wyvern Sting

			-- Mage
			SpellName(31661),	-- Dragon's Breath
			SpellName(82691),	-- Ring of Frost
			SpellName(61305),	-- Polymorph
			SpellName(102051),	-- Frostjaw
			SpellName(55021),	-- Improved Counterspell
			SpellName(122),		-- Frost Nova
			SpellName(111340),	-- Ice Ward
			-- Monk
			SpellName(115078),	-- Paralysis
			-- Paladin
			SpellName(20066),	-- Repentance
			SpellName(853),		-- Hammer of Justice
			SpellName(105593),	-- Fist of Justice
			SpellName(105421),	-- Blinding Light
			-- Priest
			SpellName(605),		-- Dominate Mind
			SpellName(8122),	-- Psychic Scream
			SpellName(113792),	-- Psychic Terror
			SpellName(64044),	-- Psychic Horror
			SpellName(15487),	-- Silence
			SpellName(6778),	-- Silence
			-- Rogue
			SpellName(2094),	-- Blind
			SpellName(1776),	-- Gouge
			SpellName(6770),	-- Sap
			-- Shaman
			SpellName(51514),	-- Hex
			SpellName(118905),	-- Static Charge
			SpellName(3600),	-- Earthbind
			SpellName(8056),	-- Frost Shock
			SpellName(63685),	-- Freeze
			-- Warlock
			SpellName(118699),	-- Fear
			SpellName(104045),	-- Sleep
			SpellName(6789),	-- Mortal Coil
			SpellName(5484),	-- Howl of Terror
			SpellName(6358),	-- Seduction (Succubus)
			SpellName(115268),	-- Mesmerize (Shivarra)
			SpellName(30283),	-- Shadowfury
			-- Warrior
			SpellName(46968),	-- Shockwave
			SpellName(20511),	-- Intimidating Shout
		}

		ReverseTimer = {
		},
		
		ORD:RegisterDebuffs(debuffids)
	end