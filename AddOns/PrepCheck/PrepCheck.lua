--Minimalistic addon to check your buffs, flask and food. 6.0.2 edition
--Shoutout to zork and ElvUI for inspiration

local Prepmovable = false
local horizontal = false
--############


local PrepCheck = CreateFrame("Frame", nil, UIParent)
_G["PrepCheck"] = PrepCheck

PrepCheck.defaultDB = {
	["pos1"] = "TOPLEFT",
	["anchor"] = "Minimap",
    ["pos2"] = "TOPRIGHT",
    ["x"] = 4,
    ["y"] = 0,
}

local buffs = {
	Stats =		{1126, 20217, 115921, 116781, 90363, 159988, 160017, 160077, 160206},						-- 5% Stats: Mark of the Wild/Blessing of Kings/Legacy of the Emperor/Legacy of the White Tiger/Embrace of the Shale Spider/backgroundrk of the Wild/Blessing of Kongs/Strength o the Earth/Lonewolf: Power of the Primates
	Stamina =	{469, 21562, 90364, 166928, 160014, 160003, 160199},										-- 10% Stamina: Commanding Shout/Power Word: Fortuitude/Qiraji Fortitude/Blood Pact/Sturdiness/Savage Vigor/Lonewolf: Fortitude of the Bear
	AP =		{6673, 57330, 19506},																		-- 10% AP: backgroundttle Shout/Horn of Winter/Trueshot Aura
	SP =		{109773, 1459, 61316, 126309, 90364, 160205},												-- 10% Spellpower:Dark Intent/Arcane Brilliance/Dalaran Brilliance/Still Water/Qiraji Fortitude/Lonewolf: Wisdom of the Serpent
	Versa =		{55610, 1126, 167187, 167188, 159735, 35290, 160045, 50518, 57386, 160077, 172967},			-- 3% Versatility: Unholy Aura/Mark of the Wild/Sanctity Aura/Inspiring Presence/Tenacity/Indomitable/Defensive Quills/Chitinous Armor/Wild Strength/Strength of the Earth/Lonewolf: Versatility of the Ravager
	Haste =		{113742, 55610, 49868, 116956, 160003, 135678, 160074, 160203},								-- 10% Haste: Swiftblade's Cunning/Unholy Aura/Mind Quickening/Grace of Air/Savage Vigor/Energizing Spores/Speed of the Swarm/Lonewolf: Haste of the Hyena
	Crit =		{17007, 1459, 61316, 116781, 126309, 24604, 90309, 126373, 160052, 90363, 160200},			-- 5% Crit: Leader of the Pack/Arcane Brilliance/Dalaran Brilliance/Legacy of the White Tiger/Still Water/Furious Howl/Terrifying Roar/Fearless Roar/Strength of the Pack/Embrace of the Shale Spider/Lonewolf: Ferocity of the Raptor
	Multi =		{166916, 49868, 113742, 109773, 159733, 54644, 58604, 34889, 160011, 57386, 24844, 172968},	-- 5% Multistrike: Windflurry/Mind Quickening/Swiftblade's Cunning/Dark Intent/backgroundleful Gaze/Frost Breath/Double Bite/Spry Attacks/Agile Reflexes/Wild Strength/Breath of the Winds/Lonewolf: Quickness of the Dragonhawk
	Mastery =	{19740, 116956, 155522, 24907, 93435, 128997, 160039, 160073, 160198},						-- 5% Mastery: Blessing of Might/Grace of Air/Power of the Grave/Moonkin Aura/Roar of Courage/Spirit Beast Blessing/Keen Senses/Plainswalking/Lonewolf: Grace of the Cat
	Flask = {
		156064, --Greater Draenic Agility Flask
		156079, --Greater Draenic Intellect Flask
		156084, --Greater Draenic Stamina Flask
		156080,	--Greater Draenic Strength Flask
		156073, --Draenic Agility Flask
		156070, --Draenic Intellect Flask
		156077, --Draenic Stamina Flask
		156071, --Draenic Strength Flask
		},
	Food = {
		160883, --150 Stam
		160889, --100 Crit
		160894, --100 Haste
		160898, --100 Mastery
		160901, --100 Multi
		160903, --100 Versa
		160846, --112 Stam
		160506, --112 Stam
		160869, --75 Crit
		174303, --75 Crit
		160872, --75 Haste
		174304, --75 Haste
		160879, --75 Mastery
		174305, --75 Mastery
		160880, --75 Multi
		174306, --75 Multi
		160881, --75 Versa
		174307  --75 Versa
		}
	}

local colors = {
	Stats = {0,1,0.59},			--Monk
	Stamina = {1.00,1.00,1.00}, --Priest
	AP = {0.77,0.12,0.23},		--DK
	SP = {0.58,0.51,0.79},		--Warlock
	Versa = {1.00,0.49,0.04},	--Druid
	Haste = {0.0,0.44,0.87},	--Shaman
	Crit = {0.41,0.80,0.94},	--Mage
	Multi = {1.00,0.96,0.41},	--Rogue
	Mastery = {0.96,0.55,0.73},	--Pally
	Flask = {0.00,1.00,0.00},	--Green
	Food = {1.00,1.00,0.00}		--Yellow
	}

local checks = {
	"Stats",
	"Stamina",
	"AP",
	"SP",
	"Versa",
	"Haste",
	"Crit",
	"Multi",
	"Mastery",
	"Flask",
	"Food",
	}

local tips = { 
   "属性", 
   "耐力", 
   "攻强", 
   "法伤", 
   "全能", 
   "急速", 
   "爆击", 
   "溅射", 
   "精通", 
   "合剂", 
   "食物", 
   }
	
local GetFormattedTime = function(time)
	local hr, m, s, text
	if time <= 0 then text = ""
	elseif(time < 3600) then
		hr = floor(time / 3600)
		m = floor(mod(time, 3600) / 60 + 1)
		text = m
	else
		hr = floor(time / 3600 + 1)
		text = hr
	end
	return text
end

function PrepCheck:UpdatePosition()
	PrepCheck:SetPoint(PrepCheckDB.pos1, PrepCheckDB.anchor, PrepCheckDB.pos2, PrepCheckDB.x, PrepCheckDB.y)    
end

PrepCheck:EnableMouse(Prepmovable)
PrepCheck:SetMovable(Prepmovable)
-- Dragging functionality
if Prepmovable then
	PrepCheck:SetScript("OnMouseDown",function()
		PrepCheck:StartMoving()
	end)
	PrepCheck:SetScript("OnMouseUp",function()
		PrepCheck:StopMovingOrSizing()
		local pos1, anchor, pos2, x, y = PrepCheck:GetPoint()
		PrepCheckDB.pos1 = pos1
		PrepCheckDB.anchor = anchor
		PrepCheckDB.pos2 = pos2
		PrepCheckDB.x = x
		PrepCheckDB.y = y
	end)
end

local k = {}
local background = {}
local text = {}
local glow = {}
for i = 1,#checks do
	k[i] = CreateFrame("Statusbar",nil,UIParent)
	--set button size
	k[i]:SetSize(19,_G["Minimap"]:GetHeight()/(#checks-1))
	
	if horizontal then
		PrepCheck:SetSize(k[i]:GetWidth()*(#checks),k[i]:GetHeight())
		if i == 1 then
			k[i]:SetPoint("LEFT", PrepCheck, "LEFT", 0, 0)
		else
			k[i]:SetPoint("LEFT", k[i-1], "RIGHT", 2, 0)
		end
	else
		PrepCheck:SetSize(k[i]:GetWidth(),k[i]:GetHeight()*(#checks))
		if i == 1 then
			k[i]:SetPoint("TOP", PrepCheck, "TOP", 0, 0)
		else
			k[i]:SetPoint("TOP", k[i-1], "BOTTOM", 0, -2)
		end
	end
	background[i] = k[i]:CreateTexture(nil, "backgroundCKGROUND",nil,-3)
	background[i]:SetAllPoints(k[i])
	background[i]:SetTexture(colors[checks[i]][1],colors[checks[i]][2],colors[checks[i]][3],1)
	text[i] = k[i]:CreateFontString(nil, "BORDER")
    text[i]:SetFont(STANDARD_TEXT_FONT, 12)
    text[i]:SetPoint("BOTTOM", 0, 0)
    text[i]:SetTextColor(0, 0, 0)
	glow[i] = k[i]:CreateTexture(nil, "backgroundCKGROUND",nil,-8)
    glow[i]:SetPoint("TOPLEFT",k[i],"TOPLEFT",-1,1)
    glow[i]:SetPoint("BOTTOMRIGHT",k[i],"BOTTOMRIGHT",1,-1)
    glow[i]:SetTexture("Interface\\Tooltips\\UI-Tooltip-backgroundckground")
    glow[i]:SetVertexColor(0, 0, 0, 1)
	k[i]:SetScript("OnEnter", function()
		GameTooltip:SetOwner(k[i], "ANCHOR_RIGHT")
		--GameTooltip:AddLine(checks[i])
		GameTooltip:AddLine(tips[i])
		GameTooltip:Show()
	end)
	k[i]:SetScript("OnLeave", function()
		GameTooltip:Hide()
	end)
end

local function updateIcon()
	for i = 1,#checks do
	local value = 0
		local found = true
		for j = 1,#buffs[checks[i]] do
			if (UnitAura("player", GetSpellInfo(buffs[checks[i]][j])) and found) then
				value = (select(7,UnitAura("player", GetSpellInfo(buffs[checks[i]][j])))-GetTime())
				found = false
			else
				text[i]:SetText("")
			end
		end
		if found then
			k[i]:Show()
		elseif value<450 and value>0 then
			text[i]:SetText(GetFormattedTime(value))
			k[i]:Show()
		else
			k[i]:Hide()
		end
	end	
end

function PrepDB()
    if(not PrepCheckDB) then
        PrepCheckDB = {}
		for i, v in pairs(PrepCheck.defaultDB) do
			PrepCheckDB[i] = v
		end
    end
end

local a = CreateFrame("Frame")
a:SetScript("OnEvent", function(self, event)
	if(event=="PLAYER_LOGIN") then
		PrepDB()
		PrepCheck:UpdatePosition()
		self:SetScript("OnUpdate", updateIcon)
	end
end)

a:RegisterEvent("PLAYER_LOGIN")