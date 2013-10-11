if not Qulight["misk"].classtimer == true then return end

local mediaPath = "Interface\\AddOns\\oUF_Qulight\\media\\Other\\"
local texture = "Interface\\AddOns\\oUF_Qulight\\Root\\Media\\statusbar4"
local glowTex = mediaPath.."glowTex"
fontsize = 10
fontsize1 =  10
local buttonTex = mediaPath.."buttontex"

local CreateSpellEntry = function( id, castByAnyone, color, unitType, castSpellId )
	return { id = id, castByAnyone = castByAnyone, color = color, unitType = unitType or 0, castSpellId = castSpellId };
end

local CreateColor = function( red, green, blue, alpha )
	return { red / 255, green / 255, blue / 255, alpha };
end

local BAR_HEIGHT = 17;
local BAR_SPACING = 1;
local LAYOUT = 4;
local BACKGROUND_ALPHA = 0.9;
local ICON_POSITION = 0;
local ICON_COLOR = CreateColor( 0, 0, 0, 1 );
local SPARK = false;
local CAST_SEPARATOR = true;
local CAST_SEPARATOR_COLOR = CreateColor( .1,.1,.1,1 );
local TEXT_MARGIN = 5;
local MASTER_FONT, STACKS_FONT;
MASTER_FONT = { Qulight["media"].font, fontsize };
STACKS_FONT = { Qulight["media"].font, fontsize1 };
local PERMANENT_AURA_VALUE = 1;
local PLAYER_BAR_COLOR = CreateColor( 70, 70, 150, 1 );
local PLAYER_DEBUFF_COLOR = nil;
local TARGET_BAR_COLOR = CreateColor( 70, 150, 70, 1 );
local TARGET_DEBUFF_COLOR = CreateColor( 150, 70, 70, 1 );
local TRINKET_BAR_COLOR = CreateColor( 150, 150, 70, 1 );
local SORT_DIRECTION = true;
local TENTHS_TRESHOLD = 1

local TRINKET_FILTER = {
		
	CreateSpellEntry( 2825, true ), CreateSpellEntry( 32182, true ), CreateSpellEntry( 80353, true), -- Bloodlust/Heroism/Timewarp
	CreateSpellEntry( 90355, true ), -- Ancient Hysteria, bloodlust from hunters pet
	CreateSpellEntry( 26297 ), -- Berserking (troll racial)
	CreateSpellEntry( 33702 ), CreateSpellEntry( 33697 ), CreateSpellEntry( 20572 ), -- Blood Fury (orc racial)
	CreateSpellEntry( 57933 ), -- Tricks of Trade (15% dmg buff)
		
	-- Professions
    CreateSpellEntry( 74497 ), -- Lifeblood Rank 8 (Herbalism)
    CreateSpellEntry( 74245 ), -- Landslide (Enchanting)
    CreateSpellEntry( 74221 ), -- Hurricane (Enchanting)

	--Raid buff
	CreateSpellEntry( 80627 ), -- Stolen Power
		
	-- Racials
	CreateSpellEntry( 20954 ), -- Stoneform (Dwarf)
	CreateSpellEntry( 59752 ), -- Every Man for Himself (Human)
	CreateSpellEntry( 57901 ), -- Gift of the Naaru (Draenei)
	CreateSpellEntry( 68992 ), -- Darkflight (Worgen)
	CreateSpellEntry( 7744 ), -- Will of the Forsaken (Undead)
	CreateSpellEntry( 20577 ), -- Cannibalize (Undead)
	CreateSpellEntry( 26297 ), -- Berserking (Troll)
	CreateSpellEntry( 20572 ), -- Blood Fury for Attack Power (Orc)
	CreateSpellEntry( 33702 ), -- Blood Fury for Spell Power (Orc)
	CreateSpellEntry( 33697 ), -- Blood Fury for Both (Orc)
		
	--Darkmoon Cards
	CreateSpellEntry( 89181 ), -- Earthquake
	CreateSpellEntry( 89182 ), -- Tsunami
	CreateSpellEntry( 89091 ), -- Volcano
	
	-- Blackwing Descent
	CreateSpellEntry( 91322 ), -- Jar of Ancient Remedies Normal
	CreateSpellEntry( 92331 ), -- Jar of Ancient Remedies Heroic
	CreateSpellEntry( 91007 ), -- Bell of Enraging Reasonance
	CreateSpellEntry( 91816 ), -- Heart of Rage
	CreateSpellEntry( 92235 ), -- Symbiotic Worm
	CreateSpellEntry( 91832 ), -- Fury of Angerforge Stacks
    CreateSpellEntry( 91836 ), -- Fury of Angerforge on use
		
	--The Bastion of Twilight
	CreateSpellEntry( 92126 ), -- Essence of the Cyclone Normal
	CreateSpellEntry( 92351 ), -- Essence of the Cyclone Heroic
	CreateSpellEntry( 91184 ), -- Fall of mortality
	CreateSpellEntry( 92213 ), -- Vial of Stolen Memories
	CreateSpellEntry( 91024 ), -- Theralion's Mirror
	CreateSpellEntry( 91821 ), -- Crushing Weight
	CreateSpellEntry( 91027 ), -- Heart of Ignacious Stacks
	CreateSpellEntry( 91041 ), -- Heart of Ignacious on use
		
	CreateSpellEntry( 96980 ), -- Accelerated (Vessel of Acceleration)
	CreateSpellEntry( 97142 ), -- Accelerated (Vessel of Acceleration) H
	CreateSpellEntry( 96911 ), -- Devour (The Hungerer)
	CreateSpellEntry( 97125 ), -- Devour (The Hungerer) H
	CreateSpellEntry( 96988 ), -- Stay of Execution
	CreateSpellEntry( 97145 ), -- Stay of Execution H
	CreateSpellEntry( 96945 ), -- Loom of Fate (Spidersilk Spindle)
	CreateSpellEntry( 97129 ), -- Loom of Fate (Spidersilk Spindle) H
	CreateSpellEntry( 97007 ), -- Mark of the Firelord (Rune of Zeth)
	CreateSpellEntry( 97146 ), -- Mark of the Firelord (Rune of Zeth) H
	CreateSpellEntry( 96907 ), -- Victorious Jaws of Defeat
	CreateSpellEntry( 97120 ), -- Victorious Jaws of Defeat H
	CreateSpellEntry( 97008 ), -- Fiery Quintessence
	CreateSpellEntry( 97176 ), -- Fiery Quintessence H
	CreateSpellEntry( 97010 ), -- Essence of the Eternal Flame
	CreateSpellEntry( 97179 ), -- Essence of the Eternal Flame
	CreateSpellEntry( 97009 ), -- Ancient Petrified Seed
	CreateSpellEntry( 97177 ), -- Ancient Petrified Seed H

	CreateSpellEntry( 90459 ), -- DPS set
		
	--Druid
	CreateSpellEntry( 90159 ), -- Resto
	CreateSpellEntry( 90164 ), -- Moonkin
	CreateSpellEntry( 90166 ), -- Feral
		
	--Paladin
	CreateSpellEntry( 90311 ), -- Holy
		
	--Priest
	CreateSpellEntry( 89911 ), -- Holy/Disc
		
	--Rogue
	CreateSpellEntry( 90472 ),
		
	--Shaman
	CreateSpellEntry( 90498 ), -- Resto
		
	--Warlock
	CreateSpellEntry( 89937 ),
	CreateSpellEntry( 126659 ),
	CreateSpellEntry( 128985 ),	
	CreateSpellEntry( 125487 ),	
	CreateSpellEntry( 104510 ),
	CreateSpellEntry( 104423 ),
	--Warrior
	CreateSpellEntry( 90294 ), --DPS
};

local CLASS_FILTERS = {
		MONK = { 
			target = {
				CreateSpellEntry( 107428 ), -- Risin Sun Kick
				CreateSpellEntry( 123727 ), -- Dizzying Haze
				CreateSpellEntry( 123725 ), -- Breath of Fire
				CreateSpellEntry( 115804 ), -- Mortal Wounds
			},
			player = {
				CreateSpellEntry( 124081 ), -- Zensphere
				CreateSpellEntry( 125195 ), -- Tigereye Brew
				CreateSpellEntry( 125359 ), -- Tiger Power
				CreateSpellEntry( 115307 ), -- Shuffle
				CreateSpellEntry( 118636 ), -- Power Guard 
				CreateSpellEntry( 115295 ), -- Guard 
				CreateSpellEntry( 128939 ), -- Elusive Brew
			},
			procs = {
				CreateSpellEntry( 116768 ), -- Combobreaker: Blackout-Kick
				CreateSpellEntry( 120273 ), -- Tiger Strikes
				CreateSpellEntry( 118864 ), -- Combobreaker: Tigerpalm
				 CreateSpellEntry( 104993 ), -- Jade Spirit
				CreateSpellEntry( 128985 ), -- Relic of Yu'lon
			}
		},
		DEATHKNIGHT = { 
			target = {
				CreateSpellEntry( 55095 ), -- Frost Fever
				CreateSpellEntry( 55078 ), -- Blood Plague
				CreateSpellEntry( 81130 ), -- Scarlet Fever
				CreateSpellEntry( 50536 ), -- Unholy Blight
				CreateSpellEntry( 65142 ), -- Ebon Plague
				CreateSpellEntry( 51714 ), -- Razorice
				CreateSpellEntry( 98957 ), -- Burning Blood Tank T12
			},
			player = {
				CreateSpellEntry( 59052 ), -- Freezing Fog
				CreateSpellEntry( 51124 ), -- Killing Machine
				CreateSpellEntry( 49016 ), -- Unholy Frenzy
				CreateSpellEntry( 57330 ), -- Horn of Winter
				CreateSpellEntry( 70654 ), -- Blood Armor
				CreateSpellEntry( 77535 ), -- Blood Shield
				CreateSpellEntry( 55233 ), -- Vampiric Blood
				CreateSpellEntry( 81141 ), -- Blood Swarm
				CreateSpellEntry( 45529 ), -- Blood Tap
				CreateSpellEntry( 49222 ), -- Bone sheild
				CreateSpellEntry( 48792 ), -- Ice Bound Fortitude
				CreateSpellEntry( 49028 ), -- Dancing Rune Weapon
				CreateSpellEntry( 51271 ), -- Pillar of Frost
				CreateSpellEntry( 48707 ), -- Anti-Magic Shell
			},
			procs = {
				CreateSpellEntry( 53365 ), -- Unholy Strength
				CreateSpellEntry( 64856 ), -- Blade barrier
				CreateSpellEntry( 70657 ), -- Advantage
				CreateSpellEntry( 81340 ), -- Sudden Doom
			}		
		},
		DRUID = { 
			target = { 
				CreateSpellEntry( 48438 ), -- Wild Growth
				CreateSpellEntry( 774 ), -- Rejuvenation
				CreateSpellEntry( 8936, false, nil, nil, 8936 ), -- Regrowth
				CreateSpellEntry( 33763 ), -- Lifebloom
				CreateSpellEntry( 5570 ), -- Insect Swarm
				CreateSpellEntry( 8921 ), -- Moonfire
				CreateSpellEntry( 339 ), -- Entangling Roots
				CreateSpellEntry( 33786 ), -- Cyclone
				CreateSpellEntry( 2637 ), -- Hibernate
				CreateSpellEntry( 2908 ), -- Soothe
				CreateSpellEntry( 50259 ), -- Feral Charge (Cat) - daze
				CreateSpellEntry( 45334 ), -- Feral Charge (Bear) - immobilize
				CreateSpellEntry( 58180 ), -- Infected Wounds
				CreateSpellEntry( 6795 ), -- Growl
				CreateSpellEntry( 5209 ), -- Challenging Roar
				CreateSpellEntry( 99 ), -- Demoralizing Roar
				CreateSpellEntry( 33745 ), -- Lacerate
				CreateSpellEntry( 5211 ), -- Bash
				CreateSpellEntry( 80964 ), -- Skull Bash (Bear)
				CreateSpellEntry( 80965 ), -- Skull Bash (Cat)
				CreateSpellEntry( 22570 ), -- Maim
				CreateSpellEntry( 1822 ), -- Rake
				CreateSpellEntry( 1079 ), -- Rip
				CreateSpellEntry( 33878, true ), -- Mangle (Bear)
				CreateSpellEntry( 33876, true ), -- Mangle (Cat)
				CreateSpellEntry( 9007 ), -- Pounce bleed
				CreateSpellEntry( 9005 ), -- Pounce stun
				CreateSpellEntry( 16857, true ), -- Faerie Fire (Feral)
				CreateSpellEntry( 770, true ), -- Farie Fire
				CreateSpellEntry( 91565, true), -- Farie Fire? :>
				CreateSpellEntry( 467 ), -- Thorns
				CreateSpellEntry( 78675 ), -- Solar Beam
				CreateSpellEntry( 93402 ), -- Sunfire
			},
			player = {
				CreateSpellEntry( 48505 ), -- Starfall
				CreateSpellEntry( 29166 ), -- Innervate
				CreateSpellEntry( 22812 ), -- Barkskin
				CreateSpellEntry( 5215 ), -- Prowl
				CreateSpellEntry( 16689 ), -- Nature's Grasp
				CreateSpellEntry( 17116 ), -- Nature's Swiftness
				CreateSpellEntry( 5229 ), -- Enrage
				CreateSpellEntry( 52610 ), -- Savage Roar
				CreateSpellEntry( 5217 ), -- Tiger's Fury
				CreateSpellEntry( 1850 ), -- Dash
				CreateSpellEntry( 22842 ), -- Frenzied Regeneration
				CreateSpellEntry( 50334 ), -- Berserk
				CreateSpellEntry( 61336 ), -- Survival Instincts
				CreateSpellEntry( 48438 ), -- Wild Growth
				CreateSpellEntry( 774 ), -- Rejuvenation
				CreateSpellEntry( 8936, false, nil, nil, 8936 ), -- Regrowth
				CreateSpellEntry( 33763 ), -- Lifebloom
				CreateSpellEntry( 467 ), -- Thorns
				CreateSpellEntry( 80951 ), -- Pulverize
				CreateSpellEntry( 16870 ), -- Clearcasting
			},
			procs = {
				CreateSpellEntry( 48518 ), -- Eclipse Lunar
				CreateSpellEntry( 48517 ), -- Eclipse Solar
				CreateSpellEntry( 69369 ), -- Predator's Swiftness
				CreateSpellEntry( 93400 ), -- Shooting Stars
				CreateSpellEntry( 81006 ), CreateSpellEntry( 81191 ), CreateSpellEntry( 81192 ), -- Lunar Shower Rank 1/2/3
				CreateSpellEntry( 16886 ), -- Nature's Grace Rank
				CreateSpellEntry( 104993 ), -- Jade Spirit
				CreateSpellEntry( 128985 ), -- Relic of Yu'lon
			},
		},
		HUNTER = { 
			target = {
				CreateSpellEntry( 49050 ), -- Aimed Shot
				CreateSpellEntry( 1978 ), -- Serpent Sting
				CreateSpellEntry( 53238 ), -- Piercing Shots
				CreateSpellEntry( 3674 ), -- Black Arrow
				CreateSpellEntry( 82654 ), -- Widow Venom
				CreateSpellEntry( 34490 ), -- Silencing Shot
				CreateSpellEntry( 37506 ), -- Scatter Shot
				CreateSpellEntry( 88691 ), -- Marker for death
				CreateSpellEntry( 1130, true ), -- Hunters mark
			},
			player = {
				CreateSpellEntry( 82749 ), -- killing streak
				CreateSpellEntry( 3045 ), -- Rapid Fire
				CreateSpellEntry( 34471 ), --The beast within
				CreateSpellEntry( 53434 ), --call of the wild
				CreateSpellEntry( 64418 ), CreateSpellEntry( 64419 ), CreateSpellEntry( 64420 ), -- Sniper Training Rank 1/2/3
			},
			procs = {
				CreateSpellEntry( 53257 ), -- cobra strikes 
				CreateSpellEntry( 6150 ), -- Quick Shots
				CreateSpellEntry( 56453 ), -- Lock and Load
				CreateSpellEntry( 82692 ), --Focus Fire
				CreateSpellEntry( 35099 ), --Rapid Killing Rank 2
				CreateSpellEntry( 53220 ), -- Improved Steadyshot
				CreateSpellEntry( 89388 ), -- sic'em
				CreateSpellEntry( 94007 ), -- Killing Streak
				CreateSpellEntry( 70893 ), -- Culling the herd
				CreateSpellEntry( 82925 ), --Ready, Set, Aim
				CreateSpellEntry( 82926 ), --Fire
			},
		},
		MAGE = {
			target = { 
				CreateSpellEntry( 44457 ), -- Living Bomb
				CreateSpellEntry( 118 ), -- Polymorph
				CreateSpellEntry( 28271 ), -- Polymorph Turtle
				CreateSpellEntry( 31589 ), -- Slow
				CreateSpellEntry( 116 ), -- Frostbolt
				CreateSpellEntry( 120 ), -- Cone of Cold
				CreateSpellEntry( 122 ), -- Frost Nova
				CreateSpellEntry( 44614 ), -- Frostfire Bolt
				CreateSpellEntry( 92315 ), -- Pyroblast!
				CreateSpellEntry( 12654 ), -- Ignite
				CreateSpellEntry( 22959 ), -- Critical Mass
				CreateSpellEntry( 83853 ), -- Combustion
				CreateSpellEntry( 31661 ), -- Dragon's Breath
				CreateSpellEntry( 83154 ), -- Piercing Chill
				CreateSpellEntry( 44572 ), -- Deep Freeze
				CreateSpellEntry( 11113 ), -- Blast Wave
				CreateSpellEntry( 82691 ), -- Ring of Frost
				CreateSpellEntry( 12355 ), -- Impact
			},
			player = {
				CreateSpellEntry( 36032 ), -- Arcane Blast
				CreateSpellEntry( 12042 ), -- Arcane Power
				CreateSpellEntry( 32612 ), -- Invisibility
				CreateSpellEntry( 1463 ), -- Mana Shield
				CreateSpellEntry( 543 ), -- Mage Ward
				CreateSpellEntry( 11426 ), -- Ice Barrier
				CreateSpellEntry( 45438 ), -- Ice Block
				CreateSpellEntry( 12472 ), -- Icy Veins
				CreateSpellEntry( 130 ), -- Slow Fall
				CreateSpellEntry( 57761 ), -- Brain Freeze
				CreateSpellEntry( 12536 ), -- Clearcasting
			},
			procs = {
				CreateSpellEntry( 44544 ), -- Fingers of Frost
				CreateSpellEntry( 79683 ), -- Arcane Missiles!
				CreateSpellEntry( 48108 ), -- Hot Streak
				CreateSpellEntry( 64343 ), -- Impact
				CreateSpellEntry( 83582 ), -- Pyromaniac
			},
		},
		PALADIN = { 
			target = {
				CreateSpellEntry( 31803 ), -- Censure --
				CreateSpellEntry( 20066 ), -- Repentance --
				CreateSpellEntry( 853 ), -- Hammer of Justice --
				CreateSpellEntry( 31935 ), -- Avenger's Shield --
				CreateSpellEntry( 20170 ), -- Seal of Justice --
				CreateSpellEntry( 26017 ), -- Vindication --
				CreateSpellEntry( 68055 ), -- Judgements of the Just --
				CreateSpellEntry( 86273 ), -- Illuminated Healing
			},
			player = {
				CreateSpellEntry( 642 ), -- Divine Shield
				CreateSpellEntry( 31850 ), -- Ardent Defender
				CreateSpellEntry( 498 ), -- Divine Protection
				CreateSpellEntry( 31884 ), -- Avenging Wrath
				CreateSpellEntry( 85696 ), -- Zealotry
				CreateSpellEntry( 25771 ), -- Debuff: Forbearance
				CreateSpellEntry( 1044 ), -- Hand of Freedom
				CreateSpellEntry( 1022 ), -- Hand of Protection
				CreateSpellEntry( 1038 ), -- Hand of Salvation
				CreateSpellEntry( 53657 ), -- Judgements of the Pure
				CreateSpellEntry( 53563 ), -- Beacon of Light
				CreateSpellEntry( 31821 ), -- Aura Mastery
				CreateSpellEntry( 54428 ), -- Divine Plea
				CreateSpellEntry( 31482 ), -- Divine Favor
				CreateSpellEntry( 6940 ), -- Hand of Sacrifice
				CreateSpellEntry( 84963 ), -- Inquisition
			},
			procs = {
				CreateSpellEntry( 59578 ), -- The Art of War
				CreateSpellEntry( 90174 ), -- Hand of Light
				CreateSpellEntry( 71396 ), -- Rage of the Fallen		
				CreateSpellEntry( 53672 ), CreateSpellEntry( 54149 ), -- Infusion of Light (Rank1/Rank2)
				CreateSpellEntry( 85496 ), -- Speed of Light
				CreateSpellEntry( 88819 ), -- Daybreak
				CreateSpellEntry( 20050 ), 
				CreateSpellEntry( 20052 ), 
				CreateSpellEntry( 20053 ), -- Conviction (Rank1/Rank2/Rank3)
				CreateSpellEntry( 104993 ), -- Jade Spirit
				CreateSpellEntry( 128985 ), -- Relic of Yu'lon
			},
		},
		PRIEST = { 
			target = { 
				CreateSpellEntry( 17 ), -- Power Word: Shield
				CreateSpellEntry( 6788, true, nil, 1 ), -- Weakened Soul
				CreateSpellEntry( 139 ), -- Renew
				CreateSpellEntry( 33076 ), -- Prayer of Mending
				CreateSpellEntry( 552 ), -- Abolish Disease
				CreateSpellEntry( 63877 ), -- Pain Suppression
				CreateSpellEntry( 34914, false, nil, nil, 34914 ), -- Vampiric Touch
				CreateSpellEntry( 589 ), -- Shadow Word: Pain
				CreateSpellEntry( 2944 ), -- Devouring Plague
				CreateSpellEntry( 48153 ), -- Guardian Spirit
				CreateSpellEntry( 77489 ), -- Echo of Light
			},
			player = {
				CreateSpellEntry( 96219 ), -- Strength of Soul (silence immun)
				CreateSpellEntry( 89489 ), -- priest slow immun
				CreateSpellEntry( 139 ), -- Renew
				CreateSpellEntry( 10060 ), -- Power Infusion
				CreateSpellEntry( 47585 ), -- Dispersion
				CreateSpellEntry( 81700 ), -- Archangel
				CreateSpellEntry( 14751 ), -- Chakra
				CreateSpellEntry( 81208 ), -- Chakra Heal
				CreateSpellEntry( 81207 ), -- Chakra Renew
				CreateSpellEntry( 81209 ), -- Chakra Smite
				CreateSpellEntry( 81206 ), -- Prayer of Healing
			},
			procs = {
				CreateSpellEntry( 63735 ), -- Serendipity
				CreateSpellEntry( 88690 ), -- Surge of Light
				CreateSpellEntry( 77487 ), -- Shadow Orb
				CreateSpellEntry( 71572 ), -- Cultivated Power
				CreateSpellEntry( 81661 ), -- Evangelism
				CreateSpellEntry( 72418 ), -- Kuhlendes Wissen
				CreateSpellEntry( 71584 ), -- Revitalize
				CreateSpellEntry( 59888 ), -- Borrowed Time
				CreateSpellEntry( 95799 ), -- Empowered Shadow
				CreateSpellEntry( 104993 ), -- Jade Spirit
				CreateSpellEntry( 128985 ), -- Relic of Yu'lon
			},
		},
		ROGUE = { 
			target = { 
				CreateSpellEntry( 1833 ), -- Cheap Shot
				CreateSpellEntry( 408 ), -- Kidney Shot
				CreateSpellEntry( 1776 ), -- Gouge
				CreateSpellEntry( 2094 ), -- Blind
				CreateSpellEntry( 8647 ), -- Expose Armor
				CreateSpellEntry( 51722 ), -- Dismantle
				CreateSpellEntry( 2818 ), -- Deadly Poison
				CreateSpellEntry( 13218 ), -- Wound Posion
				CreateSpellEntry( 3409 ),  -- Crippling Poison 
				CreateSpellEntry( 5760 ), -- Mind-Numbing Poison
				CreateSpellEntry( 6770 ), -- Sap
				CreateSpellEntry( 1943 ), -- Rupture
				CreateSpellEntry( 703 ), -- Garrote
				CreateSpellEntry( 79140 ), -- vendetta
				CreateSpellEntry( 16511 ), -- Hemorrhage
				CreateSpellEntry( 84745 ), -- Shallow Insight
				CreateSpellEntry( 84746 ), -- Moderate Insight
				CreateSpellEntry( 84747 ), -- Deep Insight
			},
			player = {
				CreateSpellEntry( 13750 ), -- adrenalin stuff
				CreateSpellEntry( 32645 ), -- Envenom
				CreateSpellEntry( 2983 ), -- Sprint
				CreateSpellEntry( 5277 ), -- Evasion
				CreateSpellEntry( 1776 ), -- Gouge
				CreateSpellEntry( 51713 ), -- Shadow Dance
				CreateSpellEntry( 1966 ), -- Feint
				CreateSpellEntry( 73651 ), -- Recuperate
				CreateSpellEntry( 5171 ), -- Slice and Dice
				CreateSpellEntry( 55503 ), -- Lifeblood
				CreateSpellEntry( 13877 ), -- Blade Flurry
				CreateSpellEntry( 74001 ), -- Combat Readiness
			},
			procs = {
				CreateSpellEntry( 71396 ), -- Rage of the Fallen
			},
		},
		SHAMAN = {
			target = {
				CreateSpellEntry( 974 ), -- Earth Shield
				CreateSpellEntry( 8050), -- Flame Shock
				CreateSpellEntry( 8056 ), -- Frost Shock
				CreateSpellEntry( 17364 ), -- Storm Strike
				CreateSpellEntry( 61295 ), -- Riptide
				CreateSpellEntry( 51945 ), -- Earthliving
				CreateSpellEntry( 77657 ), -- Searing Flames
				CreateSpellEntry( 64701 ), -- Elemental Mastery
				CreateSpellEntry( 77661 ), -- Searing Flame
			},
				player = {
				CreateSpellEntry( 324 ), -- Lightning Shield
				CreateSpellEntry( 52127 ), -- Water Shield
				CreateSpellEntry( 974 ), -- Earth Shield
				CreateSpellEntry( 30823 ), -- Shamanistic Rage
				CreateSpellEntry( 55198 ), -- Tidal Force
				CreateSpellEntry( 61295 ), -- Riptide
				CreateSpellEntry( 51562 ), CreateSpellEntry( 51563 ), CreateSpellEntry( 51564 ), -- Tidal Waves Rank 1/2/3
			},
			procs = {
				CreateSpellEntry( 53817 ), -- Maelstrom Weapon
				CreateSpellEntry( 16246 ), -- Clearcasting
				CreateSpellEntry( 104993 ), -- Jade Spirit
				CreateSpellEntry( 128985 ), -- Relic of Yu'lon				
			},
		},
		WARLOCK = {
			target = {
				CreateSpellEntry( 980 ), -- Bane of Agony
				CreateSpellEntry( 603 ), -- Bane of Doom
				CreateSpellEntry( 80240 ), -- Bane of Havoc
				CreateSpellEntry( 1490 ), -- Curse of the Elements
				CreateSpellEntry( 86105 ), -- Jinx: Curse of the Elements
				CreateSpellEntry( 18223 ), -- Curse of Exhaustion
				CreateSpellEntry( 1714 ), -- Curse of Tongue
				CreateSpellEntry( 702 ), -- Curse of Weakness
				CreateSpellEntry( 172 ), -- Corruption
				CreateSpellEntry( 27243, false, nil, nil, 27243 ), -- Seed of Corruption
				CreateSpellEntry( 48181, false, nil, nil, 48181 ), -- Haunt
				CreateSpellEntry( 32389 ), -- Shadow Embrace
				CreateSpellEntry( 30108, false, nil, nil, 30108 ), -- Unstable Affliction
				CreateSpellEntry( 348, false, nil, nil, 348 ), -- Immolate
				CreateSpellEntry( 5782 ), -- Fear
				CreateSpellEntry( 710 ), -- Banish
				CreateSpellEntry( 5484 ), -- Howl of Terror
				CreateSpellEntry( 6789 ), -- Deathcoil
				CreateSpellEntry( 17800 ), -- Shadow & Flame
				CreateSpellEntry( 114790 ), -- Shadow & Flame
				CreateSpellEntry( 87389 ), -- Shadow & Flame
			},
				player = {
				CreateSpellEntry( 17941 ), -- Shadow Trance
				CreateSpellEntry( 64371 ), -- Eradication
				CreateSpellEntry( 113860 ), -- Eradication
				CreateSpellEntry( 85383 ), -- Improved Soul Fire
				CreateSpellEntry( 79459 ),  CreateSpellEntry( 79463 ),  CreateSpellEntry( 79460 ),  CreateSpellEntry( 79462 ),  CreateSpellEntry( 79464 ), -- Demon Soul
			},
			procs = {
				CreateSpellEntry( 86121 ), -- Soul Swap
				CreateSpellEntry( 54274 ), CreateSpellEntry( 54276 ), CreateSpellEntry( 54277 ), -- Backdraft rank 1/2/3
				CreateSpellEntry( 71165 ), -- Molten Core
				CreateSpellEntry( 63167 ), -- Decimation
				CreateSpellEntry( 47283 ), -- Empowered Imp
				CreateSpellEntry( 117828 ), -- Empowered Imp
			},
		},
		WARRIOR = { 
			target = {
				CreateSpellEntry( 94009 ), -- Rend
				CreateSpellEntry( 12294 ), -- Mortal Strike
				CreateSpellEntry( 1160 ), -- Demoralizing Shout
				CreateSpellEntry( 64382 ), -- Shattering Throw
				CreateSpellEntry( 58567 ), -- Sunder Armor
				CreateSpellEntry( 86346 ), -- Colossus Smash
				CreateSpellEntry( 7922 ), -- Charge (stun)
				CreateSpellEntry( 1715 ), -- Hamstring
				CreateSpellEntry( 50725 ), -- Vigilance
				CreateSpellEntry( 676 ), -- Disarm
				CreateSpellEntry( 29703 ), -- Daze (Shield Bash)
				CreateSpellEntry( 18498 ), -- Gag Order
				CreateSpellEntry( 12809 ), -- Concussion Blow
				CreateSpellEntry( 6343 ), -- Thunderclap
				CreateSpellEntry( 12162 ), CreateSpellEntry( 12850 ), CreateSpellEntry( 12868 ), -- Deep Wounds Rank 1, 2 & 3
				CreateSpellEntry( 108126 ), -- DPS Colossus Smash T13
			},
			player = {
				CreateSpellEntry( 469 ), -- Commanding Shout
				CreateSpellEntry( 6673 ), -- Battle Shout
				CreateSpellEntry( 55694 ), -- Enraged Regeneration
				CreateSpellEntry( 23920 ), -- Spell Reflection
				CreateSpellEntry( 871 ), -- Shield Wall
				CreateSpellEntry( 1719 ), -- Recklessness
				CreateSpellEntry( 20230 ), -- Retaliation
				CreateSpellEntry( 2565 ), -- Shield Block
				CreateSpellEntry( 12976 ), -- Last Stand
				CreateSpellEntry( 90806 ), -- Executioner
				CreateSpellEntry( 32216 ), -- Victorious (Victory Rush enabled)
				CreateSpellEntry( 12292 ), -- Death Wish
				CreateSpellEntry( 85738 ), CreateSpellEntry( 85739 ), -- Meat Cleaver Rank 1 and 2
				CreateSpellEntry( 86662 ), CreateSpellEntry( 86663 ), -- Rude interruption rank 1 and 2
				CreateSpellEntry( 23885 ), -- Blood Thirst
				CreateSpellEntry( 84584 ), CreateSpellEntry( 84585 ), CreateSpellEntry( 84586 ), -- Slaughter
			},
			procs = {
				CreateSpellEntry( 46916 ), -- Bloodsurge Slam (Free & Instant)
				CreateSpellEntry( 12964 ), -- Battle Trance (Free Special)
				CreateSpellEntry( 86627 ), -- Incite (Auto-crit HStrike)
			},
		},
};

local CreateUnitAuraDataSource;
do
	local auraTypes = { "HELPFUL", "HARMFUL" };

	local CheckFilter = function( self, id, caster, filter )
		if ( filter == nil ) then return false; end
			
		local byPlayer = caster == "player" or caster == "pet" or caster == "vehicle";
			
		for _, v in ipairs( filter ) do
			if ( v.id == id and ( v.castByAnyone or byPlayer ) ) then return v; end
		end
		return false;
	end
	
	local CheckUnit = function( self, unit, filter, result )
		if ( not UnitExists( unit ) ) then return 0; end

		local unitIsFriend = UnitIsFriend( "player", unit );

		for _, auraType in ipairs( auraTypes ) do
			local isDebuff = auraType == "HARMFUL";
		
			for index = 1, 40 do
				local name, _, texture, stacks, _, duration, expirationTime, caster, _, _, spellId = UnitAura( unit, index, auraType );		
				if ( name == nil ) then
					break;
				end							
				
				local filterInfo = CheckFilter( self, spellId, caster, filter );
				if ( filterInfo and ( filterInfo.unitType ~= 1 or unitIsFriend ) and ( filterInfo.unitType ~= 2 or not unitIsFriend ) ) then 					
					filterInfo.name = name;
					filterInfo.texture = texture;
					filterInfo.duration = duration;
					filterInfo.expirationTime = expirationTime;
					filterInfo.stacks = stacks;
					filterInfo.unit = unit;
					filterInfo.isDebuff = isDebuff;
					table.insert( result, filterInfo );
				end
			end
		end
	end

	-- public 
	local Update = function( self )
		local result = self.table;

		for index = 1, #result do
			table.remove( result );
		end				

		CheckUnit( self, self.unit, self.filter, result );
		if ( self.includePlayer ) then
			CheckUnit( self, "player", self.playerFilter, result );
		end
		
		self.table = result;
	end

	local SetSortDirection = function( self, descending )
		self.sortDirection = descending;
	end
	
	local GetSortDirection = function( self )
		return self.sortDirection;
	end
	
	local Sort = function( self )
		local direction = self.sortDirection;
		local time = GetTime();
	
		local sorted;
		repeat
			sorted = true;
			for key, value in pairs( self.table ) do
				local nextKey = key + 1;
				local nextValue = self.table[ nextKey ];
				if ( nextValue == nil ) then break; end
				
				local currentRemaining = value.expirationTime == 0 and 4294967295 or math.max( value.expirationTime - time, 0 );
				local nextRemaining = nextValue.expirationTime == 0 and 4294967295 or math.max( nextValue.expirationTime - time, 0 );
				
				if ( ( direction and currentRemaining < nextRemaining ) or ( not direction and currentRemaining > nextRemaining ) ) then
					self.table[ key ] = nextValue;
					self.table[ nextKey ] = value;
					sorted = false;
				end				
			end			
		until ( sorted == true )
	end
	
	local Get = function( self )
		return self.table;
	end
	
	local Count = function( self )
		return #self.table;
	end
	
	local AddFilter = function( self, filter, defaultColor, debuffColor )
		if ( filter == nil ) then return; end
		
		for _, v in pairs( filter ) do
			local clone = { };
			
			clone.id = v.id;
			clone.castByAnyone = v.castByAnyone;
			clone.color = v.color;
			clone.unitType = v.unitType;
			clone.castSpellId = v.castSpellId;
			
			clone.defaultColor = defaultColor;
			clone.debuffColor = debuffColor;
			
			table.insert( self.filter, clone );
		end
	end
	
	local AddPlayerFilter = function( self, filter, defaultColor, debuffColor )
		if ( filter == nil ) then return; end

		for _, v in pairs( filter ) do
			local clone = { };
			
			clone.id = v.id;
			clone.castByAnyone = v.castByAnyone;
			clone.color = v.color;
			clone.unitType = v.unitType;
			clone.castSpellId = v.castSpellId;
			
			clone.defaultColor = defaultColor;
			clone.debuffColor = debuffColor;
			
			table.insert( self.playerFilter, clone );
		end
	end
	
	local GetUnit = function( self )
		return self.unit;
	end
	
	local GetIncludePlayer = function( self )
		return self.includePlayer;
	end
	
	local SetIncludePlayer = function( self, value )
		self.includePlayer = value;
	end
	
	-- constructor
	CreateUnitAuraDataSource = function( unit )
		local result = {  };

		result.Sort = Sort;
		result.Update = Update;
		result.Get = Get;
		result.Count = Count;
		result.SetSortDirection = SetSortDirection;
		result.GetSortDirection = GetSortDirection;
		result.AddFilter = AddFilter;
		result.AddPlayerFilter = AddPlayerFilter;
		result.GetUnit = GetUnit; 
		result.SetIncludePlayer = SetIncludePlayer; 
		result.GetIncludePlayer = GetIncludePlayer; 
		
		result.unit = unit;
		result.includePlayer = false;
		result.filter = { };
		result.playerFilter = { };
		result.table = { };
		
		return result;
	end
end

local CreateFramedTexture;
do
	-- public
	local SetTexture = function( self, ... )
		return self.texture:SetTexture( ... );
	end
	
	local GetTexture = function( self )
		return self.texture:GetTexture();
	end
	
	local GetTexCoord = function( self )
		return self.texture:GetTexCoord();
	end
	
	local SetTexCoord = function( self, ... )
		return self.texture:SetTexCoord( ... );
	end
	
	local SetBorderColor = function( self, ... )
		return self.border:SetVertexColor( ... );
	end
	
	-- constructor
	CreateFramedTexture = function( parent )
		local result = parent:CreateTexture( nil, "BACKGROUND", nil );
		local border = parent:CreateTexture( nil, "BORDER", nil );
		local background = parent:CreateTexture( nil, "ARTWORK", nil );
		local texture = parent:CreateTexture( nil, "OVERLAY", nil );		
		
		result:SetTexture(.05,.05,.05,0);
		border:SetTexture(.15,.15,.15,0);
		background:SetTexture(.05,.05,.05,0);
		
		border:SetPoint( "TOPLEFT", result, "TOPLEFT", 0, 0 );
		border:SetPoint( "BOTTOMRIGHT", result, "BOTTOMRIGHT", 0, 0 );
		
		background:SetPoint( "TOPLEFT", border, "TOPLEFT", 1, -1 );
		background:SetPoint( "BOTTOMRIGHT", border, "BOTTOMRIGHT", -1, 1 );

		texture:SetPoint( "TOPLEFT", background, "TOPLEFT", 1, -1 );
		texture:SetPoint( "BOTTOMRIGHT", background, "BOTTOMRIGHT", -1, 1 );
			
		result.border = border;
		result.background = background;
		result.texture = texture;
			
		result.SetBorderColor = SetBorderColor;
		
		result.SetTexture = SetTexture;
		result.GetTexture = GetTexture;
		result.SetTexCoord = SetTexCoord;
		result.GetTexCoord = GetTexCoord;
			
		return result;
	end
end

local CreateAuraBarFrame;
do
	-- classes
	local CreateAuraBar;
	do
		-- private 
		local OnUpdate = function( self, elapsed )	
			local time = GetTime();
		
			if ( time > self.expirationTime ) then
				self.bar:SetScript( "OnUpdate", nil );
				self.bar:SetValue( 0 );
				self.time:SetText( "" );
				
				local spark = self.spark;
				if ( spark ) then			
					spark:Hide();
				end
			else
				local remaining = self.expirationTime - time;
				self.bar:SetValue( remaining );
				
				local timeText = "";
				if ( remaining >= 3600 ) then
					timeText = tostring( math.floor( remaining / 3600 ) ) .. "h";
				elseif ( remaining >= 60 ) then
					timeText = tostring( math.floor( remaining / 60 ) ) .. "m";
				elseif ( remaining > TENTHS_TRESHOLD ) then
					timeText = tostring( math.floor( remaining ) );
				elseif ( remaining > 0 ) then
					timeText = tostring( math.floor( remaining * 10 ) / 10 );
				end
				self.time:SetText( timeText );
				
				local barWidth = self.bar:GetWidth();
				
				local spark = self.spark;
				if ( spark ) then			
					spark:SetPoint( "CENTER", self.bar, "LEFT", barWidth * remaining / self.duration, 0 );
				end
				
				local castSeparator = self.castSeparator;
				if ( castSeparator and self.castSpellId ) then
					local _, _, _, _, _, _, castTime, _, _ = GetSpellInfo( self.castSpellId );

					castTime = castTime / 1000;
					if ( castTime and remaining > castTime ) then
						castSeparator:SetPoint( "CENTER", self.bar, "LEFT", barWidth * ( remaining - castTime ) / self.duration, 0 );
					else
						castSeparator:Hide();
					end
				end
			end
		end
		
		-- public
		local SetIcon = function( self, icon )
			if ( not self.icon ) then return; end
			
			self.icon:SetTexture( icon );
		end
		
		local SetTime = function( self, expirationTime, duration )
			self.expirationTime = expirationTime;
			self.duration = duration;
			
			if ( expirationTime > 0 and duration > 0 ) then		
				self.bar:SetMinMaxValues( 0, duration );
				OnUpdate( self, 0 );
		
				local spark = self.spark;
				if ( spark ) then 
					spark:Show();
				end
		
				self:SetScript( "OnUpdate", OnUpdate );
			else
				self.bar:SetMinMaxValues( 0, 1 );
				self.bar:SetValue( PERMANENT_AURA_VALUE );
				self.time:SetText( "" );
				
				local spark = self.spark;
				if ( spark ) then 
					spark:Hide();
				end
				
				self:SetScript( "OnUpdate", nil );
			end
		end
		
		local SetName = function( self, name )
			self.name:SetText( name );
		end
		
		local SetStacks = function( self, stacks )
			if ( not self.stacks ) then
				if ( stacks ~= nil and stacks > 1 ) then
					local name = self.name;
					
					name:SetText( tostring( stacks ) .. "  " .. name:GetText() );
				end
			else			
				if ( stacks ~= nil and stacks > 1 ) then
					self.stacks:SetText( stacks );
				else
					self.stacks:SetText( "" );
				end
			end
		end
		
		local SetColor = function( self, color )
			self.bar:SetStatusBarColor( unpack( color ) );
		end
		
		local SetCastSpellId = function( self, id )
			self.castSpellId = id;
			
			local castSeparator = self.castSeparator;
			if ( castSeparator ) then
				if ( id ) then
					self.castSeparator:Show();
				else
					self.castSeparator:Hide();
				end
			end
		end
		
		local SetAuraInfo = function( self, auraInfo )
			self:SetName( auraInfo.name );
			self:SetIcon( auraInfo.texture );	
			self:SetTime( auraInfo.expirationTime, auraInfo.duration );
			self:SetStacks( auraInfo.stacks );
			self:SetCastSpellId( auraInfo.castSpellId );
		end
		
		-- constructor
		CreateAuraBar = function( parent )
			local result = CreateFrame( "Frame", nil, parent, nil );

			if ( bit.band( ICON_POSITION, 4 ) == 0 ) then		
				local icon = CreateFramedTexture( result, "ARTWORK" );
				icon:SetTexCoord( 0.15, 0.85, 0.15, 0.85 );
				icon:SetBorderColor( unpack( ICON_COLOR ) );
				
				local iconAnchor1;
				local iconAnchor2;
				local iconOffset;
				if ( bit.band( ICON_POSITION, 1 ) == 1 ) then
					iconAnchor1 = "TOPLEFT";
					iconAnchor2 = "TOPRIGHT";
					iconOffset = 1;
				else
					iconAnchor1 = "TOPRIGHT";
					iconAnchor2 = "TOPLEFT";
					iconOffset = -1;
				end			
				
				if ( bit.band( ICON_POSITION, 2 ) == 2 ) then
					icon:SetPoint( iconAnchor1, result, iconAnchor2, iconOffset * 6, 1 );
				else
					icon:SetPoint( iconAnchor1, result, iconAnchor2, iconOffset * ( -BAR_HEIGHT - 1 ), 1 );
				end			
				icon:SetWidth( BAR_HEIGHT + 2 );
				icon:SetHeight( BAR_HEIGHT + 2 );	

				result.icon = icon;
				
				local stacks = result:CreateFontString( nil, "OVERLAY", nil );
				stacks:SetFont( unpack( STACKS_FONT ) );
				stacks:SetShadowColor( 0, 0, 0 );
				stacks:SetShadowOffset( 1.25, -1.25 );
				stacks:SetJustifyH( "RIGHT" );
				stacks:SetJustifyV( "BOTTOM" );
				stacks:SetPoint( "TOPLEFT", icon, "TOPLEFT", 0, 0 );
				stacks:SetPoint( "BOTTOMRIGHT", icon, "BOTTOMRIGHT", 0, 3 );
				result.stacks = stacks;
			end
			
			local bar = CreateFrame( "StatusBar", nil, result, nil );
			bar:SetStatusBarTexture( texture );
			if ( bit.band( ICON_POSITION, 2 ) == 2 or bit.band( ICON_POSITION, 4 ) == 4 ) then
				bar:SetPoint( "TOPLEFT", result, "TOPLEFT", 0, 0 );
				bar:SetPoint( "BOTTOMRIGHT", result, "BOTTOMRIGHT", 0, 0 );
			else
				if ( bit.band( ICON_POSITION, 1 ) == 1 ) then
					bar:SetPoint( "TOPLEFT", result, "TOPLEFT", 0, 0 );
					bar:SetPoint( "BOTTOMRIGHT", result, "BOTTOMRIGHT", -BAR_HEIGHT - 1, 0 );
				else
					bar:SetPoint( "TOPLEFT", result, "TOPLEFT", BAR_HEIGHT + 1, 0 );
					bar:SetPoint( "BOTTOMRIGHT", result, "BOTTOMRIGHT", 0, 0 );					
				end	
			end
			result.bar = bar;
			
			if ( SPARK ) then
				local spark = bar:CreateTexture( nil, "OVERLAY", nil );
				spark:SetTexture( [[Interface\CastingBar\UI-CastingBar-Spark]] );
				spark:SetWidth( 12 );
				spark:SetBlendMode( "ADD" );
				spark:Show();
				result.spark = spark;
			end
			
			if ( CAST_SEPARATOR ) then
				local castSeparator = bar:CreateTexture( nil, "OVERLAY", nil );
				castSeparator:SetTexture( unpack( CAST_SEPARATOR_COLOR ) );
				castSeparator:SetWidth( 1 );
				castSeparator:SetHeight( BAR_HEIGHT );
				castSeparator:Show();
				result.castSeparator = castSeparator;
			end
						
			local name = bar:CreateFontString( nil, "OVERLAY", nil );
			name:SetFont( unpack( MASTER_FONT ) );
			name:SetJustifyH( "LEFT" );
			name:SetShadowColor( 0, 0, 0 );
			name:SetShadowOffset( 1.25, -1.25 );
			name:SetPoint( "TOPLEFT", bar, "TOPLEFT", TEXT_MARGIN, 0 );
			name:SetPoint( "BOTTOMRIGHT", bar, "BOTTOMRIGHT", -45, 2 );
			result.name = name;
			
			local time = bar:CreateFontString( nil, "OVERLAY", nil );
			time:SetFont( unpack( MASTER_FONT ) );
			time:SetJustifyH( "RIGHT" );
			time:SetShadowColor( 0, 0, 0 );
			time:SetShadowOffset( 1.25, -1.25 );
			time:SetPoint( "TOPLEFT", name, "TOPRIGHT", 0, 0 );
			time:SetPoint( "BOTTOMRIGHT", bar, "BOTTOMRIGHT", -TEXT_MARGIN, 2 );
			result.time = time;
			
			result.SetIcon = SetIcon;
			result.SetTime = SetTime;
			result.SetName = SetName;
			result.SetStacks = SetStacks;
			result.SetAuraInfo = SetAuraInfo;
			result.SetColor = SetColor;
			result.SetCastSpellId = SetCastSpellId;
			
			return result;
		end
	end

	-- private
	local SetAuraBar = function( self, index, auraInfo )
		local line = self.lines[ index ]
		if ( line == nil ) then
			line = CreateAuraBar( self );
			if ( index == 1 ) then
				line:SetPoint( "TOPLEFT", self, "BOTTOMLEFT", 0, BAR_HEIGHT );
				line:SetPoint( "BOTTOMRIGHT", self, "BOTTOMRIGHT", 0, 0 );
			else
				local anchor = self.lines[ index - 1 ];
				line:SetPoint( "TOPLEFT", anchor, "TOPLEFT", 0, BAR_HEIGHT + BAR_SPACING );
				line:SetPoint( "BOTTOMRIGHT", anchor, "TOPRIGHT", 0, BAR_SPACING );
			end
			tinsert( self.lines, index, line );
		end	
		
		line:SetAuraInfo( auraInfo );
		if ( auraInfo.color ) then
			line:SetColor( auraInfo.color );
		elseif ( auraInfo.debuffColor and auraInfo.isDebuff ) then
			line:SetColor( auraInfo.debuffColor );
		elseif ( auraInfo.defaultColor ) then
			line:SetColor( auraInfo.defaultColor );
		end
		
		line:Show();
	end
	
	local function OnUnitAura( self, unit )
		if ( unit ~= self.unit and ( self.dataSource:GetIncludePlayer() == false or unit ~= "player" ) ) then
			return;
		end
		
		self:Render();
	end
	
	local function OnPlayerTargetChanged( self, method )
		self:Render();
	end
	
	local function OnPlayerEnteringWorld( self )
		self:Render();
	end
	
	local function OnEvent( self, event, ... )
		if ( event == "UNIT_AURA" ) then
			OnUnitAura( self, ... );
		elseif ( event == "PLAYER_TARGET_CHANGED" ) then
			OnPlayerTargetChanged( self, ... );
		elseif ( event == "PLAYER_ENTERING_WORLD" ) then
			OnPlayerEnteringWorld( self );
		else
			error( "Unhandled event " .. event );
		end
	end
	
	-- public
	local function Render( self )
		local dataSource = self.dataSource;	

		dataSource:Update();
		dataSource:Sort();
		
		local count = dataSource:Count();

		for index, auraInfo in ipairs( dataSource:Get() ) do
			SetAuraBar( self, index, auraInfo );
		end
		
		for index = count + 1, 80 do
			local line = self.lines[ index ];
			if ( line == nil or not line:IsShown() ) then
				break;
			end
			line:Hide();
		end
		
		if ( count > 0 ) then
			self:SetHeight( ( BAR_HEIGHT + BAR_SPACING ) * count - BAR_SPACING );
			self:Show();
		else
			self:Hide();
			self:SetHeight( self.hiddenHeight or 1 );
		end
	end
	
	local function SetHiddenHeight( self, height )
		self.hiddenHeight = height;
	end

	-- constructor
	CreateAuraBarFrame = function( dataSource, parent )
		local result = CreateFrame( "Frame", nil, parent, nil );
		local unit = dataSource:GetUnit();
		
		result.unit = unit;
		
		result.lines = { };		
		result.dataSource = dataSource;
		
		local background = result:CreateTexture( nil, "BACKGROUND", nil );
		background:SetAlpha( BACKGROUND_ALPHA );
		background:SetTexture( texture );
		background:SetPoint( "TOPLEFT", result, "TOPLEFT", 0, 0 );
		background:SetPoint( "BOTTOMRIGHT", result, "BOTTOMRIGHT", 0, 0 );
		background:SetVertexColor( .1,.1,.1,1 );
		result.background = background;
		
		local border = CreateFrame( "Frame", nil, result, nil );
		border:SetAlpha( BACKGROUND_ALPHA );
		border:SetFrameStrata( "BACKGROUND" );
		border:SetBackdrop( {
			edgeFile = glowTex, edgeSize = 5,
			insets = { left = 3, right = 3, top = 3, bottom = 3 }
		} );
		border:SetBackdropColor( 0, 0, 0, 0 );
		border:SetBackdropBorderColor( 0, 0, 0 );
		border:SetPoint( "TOPLEFT", result, "TOPLEFT", -1, 1 );
		border:SetPoint( "BOTTOMRIGHT", result, "BOTTOMRIGHT", 1, -1 );
		result.border = border;		
		CreateShadow(border)
		result:RegisterEvent( "PLAYER_ENTERING_WORLD" );
		result:RegisterEvent( "UNIT_AURA" );
		if ( unit == "target" ) then
			result:RegisterEvent( "PLAYER_TARGET_CHANGED" );
		end
		
		result:SetScript( "OnEvent", OnEvent );
		
		result.Render = Render;
		result.SetHiddenHeight = SetHiddenHeight;
		
		return result;
	end
end

local _, playerClass = UnitClass( "player" );
local classFilter = CLASS_FILTERS[ playerClass ];
classtimerload = CreateFrame("Frame")
classtimerload:RegisterEvent("PLAYER_LOGIN")
classtimerload:SetScript("OnEvent", function(self, event, addon)
if ( LAYOUT == 1 ) then
	local dataSource = CreateUnitAuraDataSource( "target" );

	dataSource:SetSortDirection( SORT_DIRECTION );
	
	dataSource:AddPlayerFilter( TRINKET_FILTER, TRINKET_BAR_COLOR );
	
	if ( classFilter ) then
		dataSource:AddFilter( classFilter.target, TARGET_BAR_COLOR, TARGET_DEBUFF_COLOR );
		dataSource:AddPlayerFilter( classFilter.player, PLAYER_BAR_COLOR, PLAYER_DEBUFF_COLOR );
		dataSource:AddPlayerFilter( classFilter.procs, TRINKET_BAR_COLOR );
		dataSource:SetIncludePlayer( classFilter.player ~= nil );
	end

	local frame = CreateAuraBarFrame( dataSource,  oUF_Player );
	local yOffset = 1;
	if ( playerClass == "DEATHKNIGHT" or playerClass == "SHAMAN" or playerClass == "WARLOCK"  or playerClass == "PALADIN") then
		yOffset = yOffset + 8;
	end
	frame:SetPoint( "BOTTOMLEFT",  oUF_Player, "TOPLEFT", 0, yOffset );
	frame:SetPoint( "BOTTOMRIGHT",  oUF_Player, "TOPRIGHT", 0, yOffset );
	frame:Show(); 
elseif ( LAYOUT == 2 ) then
	local targetDataSource = CreateUnitAuraDataSource( "target" );
	local playerDataSource = CreateUnitAuraDataSource( "player" );

	targetDataSource:SetSortDirection( SORT_DIRECTION );
	playerDataSource:SetSortDirection( SORT_DIRECTION );
	
	playerDataSource:AddFilter( TRINKET_FILTER, TRINKET_BAR_COLOR );

	if ( classFilter ) then
		targetDataSource:AddFilter( classFilter.target, TARGET_BAR_COLOR, TARGET_DEBUFF_COLOR );
		playerDataSource:AddFilter( classFilter.player, PLAYER_BAR_COLOR, PLAYER_DEBUFF_COLOR );
		playerDataSource:AddFilter( classFilter.procs, TRINKET_BAR_COLOR );
	end

	local yOffset = 8;
	
	local playerFrame = CreateAuraBarFrame( playerDataSource,  oUF_Player );	
	playerFrame:SetHiddenHeight( -yOffset );
	if ( playerClass == "DEATHKNIGHT" or playerClass == "SHAMAN" or playerClass == "WARLOCK"  or playerClass == "PALADIN") then
		playerFrame:SetPoint( "BOTTOMLEFT",  oUF_Player, "TOPLEFT", 0, yOffset + 1 );
		playerFrame:SetPoint( "BOTTOMRIGHT",  oUF_Player, "TOPRIGHT", 0, yOffset + 1 );
	else
		playerFrame:SetPoint( "BOTTOMLEFT",  oUF_Player, "TOPLEFT", 0, yOffset );
		playerFrame:SetPoint( "BOTTOMRIGHT",  oUF_Player, "TOPRIGHT", 0, yOffset );
	end
	playerFrame:Show();

	local targetFrame = CreateAuraBarFrame( targetDataSource,  oUF_Player );
	targetFrame:SetPoint( "BOTTOMLEFT", playerFrame, "TOPLEFT", 0, yOffset );
	targetFrame:SetPoint( "BOTTOMRIGHT", playerFrame, "TOPRIGHT", 0, yOffset );
	targetFrame:Show();
elseif ( LAYOUT == 3 ) then
	local yOffset = 15;

	local targetDataSource = CreateUnitAuraDataSource( "target" );
	local playerDataSource = CreateUnitAuraDataSource( "player" );
	local trinketDataSource = CreateUnitAuraDataSource( "player" );
	
	targetDataSource:SetSortDirection( SORT_DIRECTION );
	playerDataSource:SetSortDirection( SORT_DIRECTION );
	trinketDataSource:SetSortDirection( SORT_DIRECTION );
	
	if ( classFilter ) then
		targetDataSource:AddFilter( classFilter.target, TARGET_BAR_COLOR, TARGET_DEBUFF_COLOR );		
		playerDataSource:AddFilter( classFilter.player, PLAYER_BAR_COLOR, PLAYER_DEBUFF_COLOR );
		trinketDataSource:AddFilter( classFilter.procs, TRINKET_BAR_COLOR );
	end
	trinketDataSource:AddFilter( TRINKET_FILTER, TRINKET_BAR_COLOR );

	local playerFrame = CreateAuraBarFrame( playerDataSource,  oUF_Player );
	playerFrame:SetHiddenHeight( -yOffset );
	if ( playerClass == "DEATHKNIGHT" or playerClass == "SHAMAN" or playerClass == "WARLOCK"  or playerClass == "PALADIN") then
		playerFrame:SetPoint( "BOTTOMLEFT",  oUF_Player, "TOPLEFT", 0, yOffset + 1 );
		playerFrame:SetPoint( "BOTTOMRIGHT",  oUF_Player, "TOPRIGHT", 0, yOffset + 1 );
	else
		playerFrame:SetPoint( "BOTTOMLEFT",  oUF_Player, "TOPLEFT", 0, yOffset );
		playerFrame:SetPoint( "BOTTOMRIGHT",  oUF_Player, "TOPRIGHT", 0, yOffset );
	end
	playerFrame:Show();

	local trinketFrame = CreateAuraBarFrame( trinketDataSource,  oUF_Player );
	trinketFrame:SetHiddenHeight( -yOffset );
	trinketFrame:SetPoint( "BOTTOMLEFT", playerFrame, "TOPLEFT", 0, yOffset );
	trinketFrame:SetPoint( "BOTTOMRIGHT", playerFrame, "TOPRIGHT", 0, yOffset );
	trinketFrame:Show();
	
	local targetFrame = CreateAuraBarFrame( targetDataSource,  oUF_Player );
	targetFrame:SetHiddenHeight( -yOffset );
	targetFrame:SetPoint( "BOTTOMLEFT", trinketFrame, "TOPLEFT", 0, yOffset );
	targetFrame:SetPoint( "BOTTOMRIGHT", trinketFrame, "TOPRIGHT", 0, yOffset );
	targetFrame:Show();
elseif ( LAYOUT == 4 ) then
	local yOffset = 11;

	local targetDataSource = CreateUnitAuraDataSource( "target" );
	local playerDataSource = CreateUnitAuraDataSource( "player" );
	local trinketDataSource = CreateUnitAuraDataSource( "player" );
	
	targetDataSource:SetSortDirection( SORT_DIRECTION );
	playerDataSource:SetSortDirection( SORT_DIRECTION );
	trinketDataSource:SetSortDirection( SORT_DIRECTION );
	
	if ( classFilter ) then
		targetDataSource:AddFilter( classFilter.target, TARGET_BAR_COLOR, TARGET_DEBUFF_COLOR );		
		playerDataSource:AddFilter( classFilter.player, PLAYER_BAR_COLOR, PLAYER_DEBUFF_COLOR );
		trinketDataSource:AddFilter( classFilter.procs, TRINKET_BAR_COLOR );
	end
	trinketDataSource:AddFilter( TRINKET_FILTER, TRINKET_BAR_COLOR );

	local playerFrame = CreateAuraBarFrame( playerDataSource,  oUF_Player );
	playerFrame:SetHiddenHeight( -yOffset );
	if ( playerClass == "DRUID" or playerClass == "DEATHKNIGHT" or playerClass == "SHAMAN" or playerClass == "WARLOCK"  or playerClass == "PALADIN") then
		playerFrame:SetPoint( "BOTTOMLEFT",  oUF_Player, "TOPLEFT", 0, 18 );
		playerFrame:SetPoint( "BOTTOMRIGHT",  oUF_Player, "TOPRIGHT", 0, 18 );
	else
		playerFrame:SetPoint( "BOTTOMLEFT",  oUF_Player, "TOPLEFT", 0, 8 );
		playerFrame:SetPoint( "BOTTOMRIGHT",  oUF_Player, "TOPRIGHT", 0, 8 );
	end
	playerFrame:Show();

	local trinketFrame = CreateAuraBarFrame( trinketDataSource,  oUF_Player );
	trinketFrame:SetHiddenHeight( -yOffset );
	trinketFrame:SetPoint( "BOTTOMLEFT", playerFrame, "TOPLEFT", 0, 10 );
	trinketFrame:SetPoint( "BOTTOMRIGHT", playerFrame, "TOPRIGHT", 0, 10 );
	trinketFrame:Show();
	
	local targetFrame = CreateAuraBarFrame( targetDataSource,  oUF_Target );
	if ( playerClass == "ROGUE" or playerClass == "DRUID") then
		targetFrame:SetPoint( "BOTTOMLEFT",  oUF_Target, "TOPLEFT", 0, 18);
		targetFrame:SetPoint( "BOTTOMRIGHT",  oUF_Target, "TOPRIGHT", 0, 18);
	else
		targetFrame:SetPoint( "BOTTOMLEFT",  oUF_Target, "TOPLEFT", 0, 8);
		targetFrame:SetPoint( "BOTTOMRIGHT",  oUF_Target, "TOPRIGHT", 0, 8);
	end
	targetFrame:Show();
else
	error( "Undefined layout " .. tostring( LAYOUT ) );
end
classtimerload:UnregisterEvent("PLAYER_LOGIN")
classtimerload:SetScript("OnEvent", nil)
end)