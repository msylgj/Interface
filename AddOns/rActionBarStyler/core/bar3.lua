
  -----------------------------
  -- INIT
  -----------------------------

  --get the addon namespace
  local addon, ns = ...
  local gcfg = ns.cfg
  --get some values from the namespace
  local cfg = gcfg.bars.bar3
  local dragFrameList = ns.dragFrameList

  -----------------------------
  -- FUNCTIONS
  -----------------------------

  if not cfg.enable then return end

  local num = NUM_ACTIONBAR_BUTTONS
  local buttonList = {}

  --create the frame to hold the buttons
  local frame = CreateFrame("Frame", "rABS_MultiBarBottomRight", UIParent, "SecureHandlerStateTemplate")
  frame:SetWidth((num+6)*cfg.buttons.size + (num+5)*cfg.buttons.margin + 2*cfg.padding)
  frame:SetHeight(2*cfg.buttons.size + 2*cfg.padding + cfg.buttons.margin)
  frame:SetPoint(cfg.pos.a1,cfg.pos.af,cfg.pos.a2,cfg.pos.x,cfg.pos.y)
  frame:SetScale(cfg.scale)

  --move the buttons into position and reparent them
  MultiBarBottomRight:SetParent(frame)
  MultiBarBottomRight:EnableMouse(false)

  for i=1, 6 do
    local button = _G["MultiBarBottomRightButton"..i]

    button:SetSize(cfg.buttons.size, cfg.buttons.size)
    button:ClearAllPoints()
    if i == 1 then
      button:SetPoint("BOTTOMLEFT", frame, cfg.padding,0)
    else
      local previous = _G["MultiBarBottomRightButton"..i-1]      
      if  i == 4 then
        previous = _G["MultiBarBottomRightButton1"]
        button:SetPoint("BOTTOMLEFT", previous, "TOPLEFT", 0, cfg.buttons.margin)
      else
        button:SetPoint("LEFT", previous, "RIGHT", cfg.buttons.margin, 0)
      end
      
    end
  end
  
  for i=7, 12 do
    local button = _G["MultiBarBottomRightButton"..i]
    button:SetSize(cfg.buttons.size, cfg.buttons.size)
    button:ClearAllPoints()
    if i == 7 then
      button:SetPoint("BOTTOMRIGHT", frame, -cfg.padding,0)
    else
      local previous = _G["MultiBarBottomRightButton"..i-1]      
      if  i == 10 then
        previous = _G["MultiBarBottomRightButton7"]

        button:SetPoint("BOTTOMLEFT", previous, "TOPLEFT", 0, cfg.buttons.margin)
      else
        button:SetPoint("RIGHT", previous, "LEFT", -cfg.buttons.margin, 0)
      end  
    end
  end

  --show/hide the frame on a given state driver
  RegisterStateDriver(frame, "visibility", "[petbattle][overridebar][vehicleui][possessbar,@vehicle,exists] hide; show")

  --create drag frame and drag functionality
  if cfg.userplaced.enable then
    rCreateDragFrame(frame, dragFrameList, -2 , true) --frame, dragFrameList, inset, clamp
  end

  --create the mouseover functionality
  if cfg.mouseover.enable then
    rButtonBarFader(frame, buttonList, cfg.mouseover.fadeIn, cfg.mouseover.fadeOut) --frame, buttonList, fadeIn, fadeOut
    frame.mouseover = cfg.mouseover
  end

  --create the combat fader
  if cfg.combat.enable then
    rCombatFrameFader(frame, cfg.combat.fadeIn, cfg.combat.fadeOut) --frame, buttonList, fadeIn, fadeOut
  end