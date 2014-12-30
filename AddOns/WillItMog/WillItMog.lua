local WHITE_MOG="Despite being of common quality, this item's appearance can be used to transmogrify other items"
local MISC_NOTE="Note that this item is in the '"..MISCELLANEOUS.."' category, it is incompatible to true armor."

WillItMog={ -- default for fresh installation or borked savedvar, will be overwritten from savedvar when that is loaded
 ["verbose"]=false
 }

local locs={ -- clunky, but easier
 ["INVTYPE_HEAD"]=1,
 ["INVTYPE_SHOULDER"]=1,
 ["INVTYPE_CHEST"]=1,
 ["INVTYPE_ROBE"]=1,
 ["INVTYPE_WAIST"]=1,
 ["INVTYPE_LEGS"]=1,
 ["INVTYPE_FEET"]=1,
 ["INVTYPE_WRIST"]=1,
 ["INVTYPE_HAND"]=1,
 ["INVTYPE_CLOAK"]=1,
 ["INVTYPE_WEAPON"]=1,
 ["INVTYPE_SHIELD"]=1,
 ["INVTYPE_2HWEAPON"]=1,
 ["INVTYPE_HOLDABLE"]=1,
 ["INVTYPE_WEAPONMAINHAND"]=1,
 ["INVTYPE_WEAPONOFFHAND"]=1,
 ["INVTYPE_RANGED"]=1,
 ["INVTYPE_THROWN"]=1,
 ["INVTYPE_RANGEDRIGHT"]=1,
 }

local WIMtooltip=function(tooltip)
 local _,link=tooltip:GetItem()
 if not link then return end
 local itemID = link:match("item:(%d+)")
 if not itemID then return end
 -- since GetItemTransmogrifyInfo can't take item links anymore and thus does not get random enchant info, let's take care of that ourselves
 local rndench = link:match("item:[^:]+:[^:]+:[^:]+:[^:]+:[^:]+:[^:]+:([^:]+):")
 GetItemInfo(itemID) -- item should be cached by now, but who knows, let's 'preload' so that the next line receives valid data
 local _,_,quality,_,_,itemType,subType,_,slot=GetItemInfo(itemID)
 if not itemType or not (itemType==ARMOR or itemType==ENCHSLOT_WEAPON) or (subType==MISCELLANEOUS and (itemType==ENCHSLOT_WEAPON or slot=="INVTYPE_CLOAK")) or not locs[slot] then
  return end -- no weapon or armor, or misc 'weapon' or cloak, or invalid slot
 local canBeChanged, noChangeReason, canBeSource, noSourceReason = GetItemTransmogrifyInfo(itemID)
 if rndench and rndench~="0" and noSourceReason=="NO_STATS" then
   canBeChanged = true
   canBeSource = true
 end
 if (quality<2 or subType==MISCELLANEOUS) and not (canBeChanged or canBeSource) then return end -- white/misc that's imcompatible altogether
 tooltip:AddLine(
  "|cFF"..(canBeChanged and "11DD11" or "FF0000不").."可幻化|r / |cFF"..(canBeSource and "11DD11" or "FF0000非").."幻化源|r",
  nil,nil,nil,true)
 if subType==MISCELLANEOUS and itemType~="INVTYPE_HOLDABLE" then tooltip:AddLine(MISC_NOTE,nil,nil,nil,true) end
 if noChangeReason and quality<2 then noChangeReason=WHITE_MOG end
 if WillItMog.verbose and noChangeReason then
  tooltip:AddLine(gsub(_G["ERR_TRANSMOGRIFY_"..noChangeReason] or noChangeReason,"%%s",""),nil,nil,nil,true)
  end
 if WillItMog.verbose and noSourceReason and noSourceReason ~= noChangeReason
  then tooltip:AddLine(gsub(_G["ERR_TRANSMOGRIFY_"..noSourceReason] or noSourceReason,"%%s",""),nil,nil,nil,true)
  end
 tooltip:Show()
 end

local frame=CreateFrame("FRAME")
frame:SetScript("OnEvent",function(self,event,arg)
 if arg~="WillItMog" then
  return end
 frame:UnregisterEvent("ADDON_LOADED")
 LibStub("LibTipHooker-1.1"):Hook(WIMtooltip,"item")
 end)

frame:RegisterEvent("ADDON_LOADED")