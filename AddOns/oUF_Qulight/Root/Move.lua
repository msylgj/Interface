local t_unlock = false
AnchorFrames = {}
UISavedPositions = {}

local SetPosition = function(anch)
	local ap, _, rp, x, y = anch:GetPoint()
	UISavedPositions[anch:GetName()] = {ap, "UIParent", rp, x, y}
end

local OnDragStart = function(self)
	self:StartMoving()
end

local OnDragStop = function(self)
	self:StopMovingOrSizing()
	SetPosition(self)
end

local shadows = {
	bgFile =  "Interface\\AddOns\\oUF_Qulight\\Root\\Media\\statusbar4",
	edgeFile = "Interface\\AddOns\\oUF_Qulight\\Root\\Media\\glowTex", 
	edgeSize = 2,
	insets = { left = 2, right = 2, top = 2, bottom = 2 }
}
function CreateShadowmove(f) --
	if f.shadow then return end
	local shadow = CreateFrame("Frame", nil, f)
	shadow:SetFrameLevel(29)
	shadow:SetFrameStrata(f:GetFrameStrata())
	shadow:SetPoint("TOPLEFT", -2, 2)
	shadow:SetPoint("BOTTOMRIGHT", 2, -2)
	shadow:SetBackdrop(shadows)
	shadow:SetBackdropColor( .05,.05,.05, 1)
	shadow:SetBackdropBorderColor(.23,.45,.13, 0)
	f.shadow = shadow
	return shadow
end
function framemove(f)
	f:SetBackdrop({
		bgFile =  [=[Interface\ChatFrame\ChatFrameBackground]=],
        edgeFile = "Interface\\Buttons\\WHITE8x8", edgeSize = 1, 
		insets = {left = -1, right = -1, top = -1, bottom = -1} 
	})
	f:SetBackdropColor(.05,.05,.05,0.5)
	f:SetBackdropBorderColor(.23,.45,.13, 1)	
end
function CreateAnchor(f, text, width, height)
	f:SetScale(1)
	f:SetFrameStrata("TOOLTIP")
	f:SetScript("OnDragStart", OnDragStart)
	f:SetScript("OnDragStop", OnDragStop)
	f:SetWidth(width)
	f:SetHeight(height)
	
	local h = CreateFrame("Frame", nil)
	h:SetFrameLevel(30)
	h:SetAllPoints(f)
	f.dragtexture = h
	
	local v = CreateFrame("Frame", nil, h)
	v:SetPoint("TOPLEFT",0,0)
	v:SetPoint("BOTTOMRIGHT",0,0)
	framemove(v)

	f:SetMovable(true)
	f.dragtexture:SetAlpha(0)
	f:EnableMouse(nil)
	f:RegisterForDrag(nil)

	f.text = f:CreateFontString(nil, "OVERLAY")
	f.text:SetFont(Qulight["media"].font, 10)
	f.text:SetJustifyH("LEFT")
	f.text:SetShadowColor(0, 0, 0)
	f.text:SetShadowOffset(1, -1)
	f.text:SetAlpha(0)
	f.text:SetPoint("CENTER")
	f.text:SetText(text)

	tinsert(AnchorFrames, f:GetName())
end

function AnchorsUnlock()
	print("UI: all frames unlocked")
	for _, v in pairs(AnchorFrames) do
		f = _G[v]
		f.dragtexture:SetAlpha(1)
		f.text:SetAlpha(1)
		f:EnableMouse(true)
		f:RegisterForDrag("LeftButton")
	end
end

function AnchorsLock()
	print("UI: all frames locked")
	for _, v in pairs(AnchorFrames) do
		f = _G[v]
		f.dragtexture:SetAlpha(0)
		f.text:SetAlpha(0)
		f:EnableMouse(nil)
		f:SetUserPlaced(false)
		f:RegisterForDrag(nil)
	end
end

function AnchorsReset()
	if(UISavedPositions) then UISavedPositions = nil end
	ReloadUI()
end
local grid
local boxSize = 64

function Grid_Show()
	if not grid then
        Grid_Create()
	elseif grid.boxSize ~= boxSize then
        grid:Hide()
        Grid_Create()
    else
		grid:Show()
	end
end

function Grid_Hide()
	if grid then
		grid:Hide()
	end
end
function Grid_Create() 
	grid = CreateFrame('Frame', nil, UIParent) 
	grid.boxSize = boxSize 
	grid:SetAllPoints(UIParent) 

	local size = 2 
	local width = GetScreenWidth()
	local ratio = width / GetScreenHeight()
	local height = GetScreenHeight() * ratio

	local wStep = width / boxSize
	local hStep = height / boxSize

	for i = 0, boxSize do 
		local tx = grid:CreateTexture(nil, 'BACKGROUND') 
		if i == boxSize / 2 then 
			tx:SetTexture(1, 0, 0, 0.5) 
		else 
			tx:SetTexture(0, 0, 0, 0.5) 
		end 
		tx:SetPoint("TOPLEFT", grid, "TOPLEFT", i*wStep - (size/2), 0) 
		tx:SetPoint('BOTTOMRIGHT', grid, 'BOTTOMLEFT', i*wStep + (size/2), 0) 
	end 
	height = GetScreenHeight()
	
	do
		local tx = grid:CreateTexture(nil, 'BACKGROUND') 
		tx:SetTexture(1, 0, 0, 0.5)
		tx:SetPoint("TOPLEFT", grid, "TOPLEFT", 0, -(height/2) + (size/2))
		tx:SetPoint('BOTTOMRIGHT', grid, 'TOPRIGHT', 0, -(height/2 + size/2))
	end
	
	for i = 1, math.floor((height/2)/hStep) do
		local tx = grid:CreateTexture(nil, 'BACKGROUND') 
		tx:SetTexture(0, 0, 0, 0.5)
		
		tx:SetPoint("TOPLEFT", grid, "TOPLEFT", 0, -(height/2+i*hStep) + (size/2))
		tx:SetPoint('BOTTOMRIGHT', grid, 'TOPRIGHT', 0, -(height/2+i*hStep + size/2))
		
		tx = grid:CreateTexture(nil, 'BACKGROUND') 
		tx:SetTexture(0, 0, 0, 0.5)
		
		tx:SetPoint("TOPLEFT", grid, "TOPLEFT", 0, -(height/2-i*hStep) + (size/2))
		tx:SetPoint('BOTTOMRIGHT', grid, 'TOPRIGHT', 0, -(height/2-i*hStep + size/2))
		
	end
	
end
local function SlashCmd(cmd)
	if InCombatLockdown() then print(ERR_NOT_IN_COMBAT) return end
	
	if (cmd:match"reset") then
		AnchorsReset()
	else
		if t_unlock == false then
			t_unlock = true
			AnchorsUnlock()
			boxSize = (math.ceil((tonumber(arg) or boxSize) / 32) * 32)
				 
					Grid_Show()
					isAligning = true
				
		elseif t_unlock == true then
			t_unlock = false
			AnchorsLock()
			Grid_Hide()
            isAligning = false
		end
	end
end

local RestoreUI = function(self)
	if InCombatLockdown() then
		if not self.shedule then self.shedule = CreateFrame("Frame", nil, self) end
		self.shedule:RegisterEvent("PLAYER_REGEN_ENABLED")
		self.shedule:SetScript("OnEvent", function(self)
			RestoreUI(self:GetParent())
			self:UnregisterEvent("PLAYER_REGEN_ENABLED")
			self:SetScript("OnEvent", nil)
		end)
		return
	end
	for frame_name, SetPoint in pairs(UISavedPositions) do
		if _G[frame_name] then
			_G[frame_name]:ClearAllPoints()
			_G[frame_name]:SetPoint(unpack(SetPoint))
		end
	end
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:SetScript("OnEvent", function(self, event)
	self:UnregisterEvent(event)
	RestoreUI(self)
	
end)

SlashCmdList["ui"] = SlashCmd;
SLASH_ui1 = "/ui";

Anchorplayer = CreateFrame("Frame","Move_player",UIParent)
Anchorplayer:SetPoint("TOPRIGHT", UIParent, "BOTTOM", -200, 329)
CreateAnchor(Anchorplayer, "Move player", 220, 38)

Anchortarget = CreateFrame("Frame","Move_target",UIParent)
Anchortarget:SetPoint("TOPLEFT", UIParent, "BOTTOM", 200, 329)
CreateAnchor(Anchortarget, "Move target", 220, 38)

Anchorraid = CreateFrame("Frame","Move_raid",UIParent)
Anchorraid:SetPoint("TOPLEFT", UIParent, 3, -3)
CreateAnchor(Anchorraid, "Move raid", 392, 146)

Anchortot = CreateFrame("Frame","Move_tot",UIParent)
Anchortot:SetPoint("TOPLEFT", UIParent, "BOTTOM", 425, 319) 
CreateAnchor(Anchortot, "Move tot", 100, 28)

Anchorpet = CreateFrame("Frame","Move_pet",UIParent)
Anchorpet:SetPoint("TOPRIGHT", UIParent, "BOTTOM", -425, 319) 
CreateAnchor(Anchorpet, "Move pet", 100, 28)

if Qulight["unitframes"].bigcastbar then
	Anchorplayercastbar = CreateFrame("Frame","Move_playercastbar",UIParent)
	Anchorplayercastbar:SetPoint("BOTTOM", UIParent, "BOTTOM", -1, 351)
	CreateAnchor(Anchorplayercastbar, "Move playercastbar", 327, 18)

	Anchortargetcastbar = CreateFrame("Frame","Move_targetcastbar",UIParent)
	Anchortargetcastbar:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 400)
	CreateAnchor(Anchortargetcastbar, "Move targetcastbar", 223, 18)
end

Anchorfocus = CreateFrame("Frame","Move_focus",UIParent)
Anchorfocus:SetPoint("BOTTOMLEFT", 300, 450) 
CreateAnchor(Anchorfocus, "Move focus", 180, 34)

Anchorfocuscastbar = CreateFrame("Frame","Move_focuscastbar",UIParent)
Anchorfocuscastbar:SetPoint("BOTTOMLEFT", 322, 490) 
CreateAnchor(Anchorfocuscastbar, "Move focuscastbar", 155, 13)

Anchortank = CreateFrame("Frame","Move_tank",UIParent)
Anchortank:SetPoint("BOTTOMLEFT", 310, 370)
CreateAnchor(Anchortank, "Move tank", 80, 18)

Anchorboss = CreateFrame("Frame","Move_boss",UIParent)
Anchorboss:SetPoint("BOTTOMRIGHT", -350, 450)
CreateAnchor(Anchorboss, "Move boss", 150, 200)