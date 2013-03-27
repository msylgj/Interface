local _G = _G
local addonName
addonName, StrataFix = ...
local addon = StrataFix 

local frame = CreateFrame("Button", addonName.."HiddenFrame", UIParent)

local function chatMsg(msg)
     DEFAULT_CHAT_FRAME:AddMessage(addonName..": "..msg)
end

local function debug(msg)
  if addon.settings and addon.settings.debug then chatMsg(msg) end
end

-------------------------------------------------------------------
-- Blacklist maintenance, for force fixes only
-------------------------------------------------------------------
-- Names of frames that should never be messed with,
-- specifically those containing child frames with a deliberately lower strata
addon.blacklist = {
  ["TargetFrame"] = true, -- Adapt and other unit frame model addons
  ["FocusFrame"] = true,  -- Adapt and other unit frame model addons
  ["TicketStatusFrame"] = true,
  ["CalendarTexturePickerFrame"] = true,
  ["CalendarModalDummy"] = true,
  ["TransmogrifyFrameMouseBlock"] = true,
  ["TransmogrifyModelFrame"] = true,
  ["VoidStorageFrame"] = true,
  ["VoidStorageBorderFrame"] = true,
  ["LightHeadedFrame"] = true, -- LightHeaded
  ["GnomeWorksFrame"] = true, -- GnomeWorks buttons
}
for i=1,10 do
  addon.blacklist["ChatFrame"..i.."EditBox"] = true
end
for i=1,MIRRORTIMER_NUMTIMERS do
  addon.blacklist["MirrorTimer"..i] = true
end

-- References to frames that should never be messed with,
-- specifically those containing child frames with a deliberately lower strata
addon.weak_blacklist = setmetatable({}, {__mode = "k"}) 

-- support for Skinner
hooksecurefunc("LowerFrameLevel", function(frame) addon.weak_blacklist[frame] = true end)
if Skinner and Skinner.skinFrame then
  for obj,_ in pairs(Skinner.skinFrame) do
    addon.weak_blacklist[obj] = true
  end
end
if Skinner and Skinner.sBtn then
  for obj,_ in pairs(Skinner.sBtn) do
    addon.weak_blacklist[obj] = true
  end
end

function addon:UpdateSettings() 
  addon.settings.blacklist = addon.settings.blacklist or {}
  for name,val in pairs(addon.settings.blacklist) do
    addon.blacklist[name] = val
  end
end

-------------------------------------------------------------------
-- Command line processing
-------------------------------------------------------------------
SLASH_STRATAFIX1 = "/stratafix"
SlashCmdList["STRATAFIX"] = function(args)
  local cmd, arg = strsplit(" ",args,2)
  cmd = cmd:lower()
  if cmd == "debug" then
    addon.settings.debug = not addon.settings.debug
    chatMsg("debug set to: "..(addon.settings.debug and "true" or "false"))
  elseif cmd == "force" then
    chatMsg("forcing a global fix...")
    addon:FixAll()
  elseif cmd == "bladd" and arg then
    addon.settings.blacklist[arg] = true
    chatMsg("Added "..arg.." to blacklist")
    addon:UpdateSettings()
  elseif cmd == "bldel" and arg then
    addon.settings.blacklist[arg] = false
    chatMsg("Removed "..arg.." from blacklist")
    addon:UpdateSettings()
  elseif cmd == "blshow" then
    chatMsg("Current frame blacklist:")
    local sorttmp = {}
    for name,val in pairs(addon.blacklist) do
      if val then
        table.insert(sorttmp,name)
      end
    end
    table.sort(sorttmp)
    for _,name in ipairs(sorttmp) do
      chatMsg("  "..name)
    end
  end
end

local function SetLevel(frame, level, context)
  local parent = frame:GetParent()
  if not frame.SetFrameLevel then
    debug("Missing frame.SetFrameLevel on "..(frame:GetName() or "<unnamed>").." in "..(context or "unknown"))
    return
  end
  if addon.settings and addon.settings.debug then
    debug("Fixing level of "..(frame:GetName() or "<unnamed>")..":"..(frame:GetFrameLevel() or "nil")..
          " child of "..(parent and parent:GetName() or "<unnamed>")..":"..(parent and parent:GetFrameLevel() or "nil")..
  	  " in "..(context or "unknown"))
  end
  frame:SetFrameLevel(level)
end

-------------------------------------------------------------------
-- Old fixing code, globally fix on timer with blacklist
-------------------------------------------------------------------
function addon:FixHelper(lvl, ...)
  local n = select("#",...)
  local changes = 0
  for i=1,n do
    local frame = select(i, ...)
    changes = changes + addon:Fix(frame, lvl)
  end
  return changes
end

function addon:Fix(frame,lvl)
  if not frame:IsShown() or 
     addon.blacklist[frame:GetName() or ""] or
     addon.weak_blacklist[frame] then
    return 0
  end
  local curlvl = frame:GetFrameLevel()
  local changes = 0
  lvl = lvl or curlvl
  if curlvl < lvl then
     curlvl = lvl
     SetLevel(frame,curlvl,"forced FixAll")
     changes = changes + 1
  end
  changes = changes + addon:FixHelper(curlvl+1, frame:GetChildren())
  return changes
end

function addon:FixAll(silent)
  local changes = 0
  local frame = EnumerateFrames(); -- Get the first frame
  while frame do
    if ( frame:IsToplevel() and frame:IsVisible() ) then
      changes = changes + addon:Fix(frame)
    end
    frame = EnumerateFrames(frame); -- Get the next frame
  end

  if not silent and changes ~= addon.lastchanges then
    chatMsg("Frame strata fixed! ("..changes.." changes)")
  end
  addon.lastchanges = changes
end


local upd = 0
function StrataFix_OnUpdate(frame, elapsed)
  if InCombatLockdown() then return end
  upd = upd + elapsed
  if upd < 0.5 then 
    return
  else
    upd = 0
  end
  addon:FixAll(not addon.debug)
end

function StrataFix_OnEvent(frame, event, name, ...)
   if event == "ADDON_LOADED" and name == addonName then
       StrataFixDB = StrataFixDB or {}
       addon.settings = StrataFixDB
       addon:UpdateSettings()
       addon:InitHooks()
--[[       
   elseif event == "PLAYER_REGEN_ENABLED" then 
       -- This event is called when the player exits combat
       frame:SetScript("OnUpdate", StrataFix_OnUpdate);
   elseif event == "PLAYER_REGEN_DISABLED" then
       -- This event is called when we enter combat
       frame:SetScript("OnUpdate", nil);
--]]
   end
end


frame:SetScript("OnEvent", StrataFix_OnEvent);
frame:RegisterEvent("ADDON_LOADED")
--[[
if not InCombatLockdown() then
  frame:SetScript("OnUpdate", StrataFix_OnUpdate);
end
frame:RegisterEvent("PLAYER_REGEN_ENABLED")
frame:RegisterEvent("PLAYER_REGEN_DISABLED")
hooksecurefunc("ShowUIPanel",function() addon:FixAll(not addon.debug) end)
--]]

-------------------------------------------------------------------
-- New fixing code, fix on frame parenting
-------------------------------------------------------------------

local function CheckOne(frame, parent, context)
  local p = parent.GetFrameLevel and parent:GetFrameLevel()
  local c = frame.GetFrameLevel and frame:GetFrameLevel()
  if not c or not p then return end
  if c <= p then
    SetLevel(frame, p+1, context)
  end
end

local function CreateFrameHelper(frameType, name, parent, template, ...)
  local n = select("#",...)
  if n == 0 then return end -- TaxiRouteMap
  local frame = select(n, ...)
  CheckOne(frame, parent, "CreateFrame")
end

function StrataFix_CreateFrame(frameType, name, parent, template) 
  if parent and parent ~= UIParent then
    CreateFrameHelper(frameType, name, parent, template, parent:GetChildren())
  end
end
hooksecurefunc("CreateFrame", StrataFix_CreateFrame)

function StrataFix_SetParent(self,parent)
  if type(parent) == "string" then -- handle Frame:SetParent("name")
    parent = _G[parent]
  end
  if parent then
    CheckOne(self, parent, "SetParent")
  end
end

function addon:SetHook(object)
  local mt = getmetatable(object)
  if mt.__index and mt.__index.SetParent then
    hooksecurefunc( mt.__index, "SetParent", StrataFix_SetParent)
  end
end
addon.hookTypes = {
  "Frame",
  "Button",
  "CheckButton",
  "Cooldown",
  "ColorSelect",
  "Slider", 
  "EditBox",
  "SimpleHTML",
  "StatusBar",
  "ScrollFrame",
  "MessageFrame",
  "ScrollingMessageFrame",
}
 
function addon:InitHooks()
  for _,t in pairs(addon.hookTypes) do
    local o = CreateFrame(t)
    addon:SetHook(o)
    o:Hide()
    o:UnregisterAllEvents() 
  end
end


