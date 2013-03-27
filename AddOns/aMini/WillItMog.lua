local _G = _G
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
 ["INVTYPE_WEAPONMAINHAND"]=1,
 ["INVTYPE_WEAPONOFFHAND"]=1,
 ["INVTYPE_HOLDABLE"]=1,
 ["INVTYPE_RANGED"]=1,
 ["INVTYPE_THROWN"]=1,
 ["INVTYPE_RANGEDRIGHT"]=1,
 }

local wx={ -- white items that are a source for transmog
 -- Brunnhildar proc weapons
 [41746]=1,
 [43600]=1,
 [43601]=1,
 -- Darkmoon cloak and hammer, thanks Ashelia from Wowhead
 [78340]=1,
 [78341]=1,
 }


local WIMtooltip=function(tooltip)
 local _,link=tooltip:GetItem()
 if not link then return end
 GetItemInfo(link) -- item should be cached by now, but who knows, let's 'preload' so that the next line receives valid data
 local _,_,quality,_,_,itemType,subType,_,slot=GetItemInfo(link)
   if not itemType or (quality<2 and not wx[tonumber(link:match("item:(%d+):"))]) or not (itemType==ARMOR or itemType==ENCHSLOT_WEAPON) or subType==MISCELLANEOUS or not locs[slot] then
  return end -- no weapon or armor, or misc 'weapon', or invalid slot
 local canBeChanged, noChangeReason, canBeSource, noSourceReason = GetItemTransmogrifyInfo(link)
 tooltip:AddLine(
  "|cFF"..(canBeChanged and "11DD11" or "FF0000不").."可幻化|r / |cFF"..(canBeSource and "11DD11" or "FF0000非").."幻化源|r",
  nil,nil,nil,true)
 if WillItMog.verbose and noChangeReason then
  tooltip:AddLine(gsub(_G["ERR_TRANSMOGRIFY_"..noChangeReason] or noChangeReason,"%%s",""),nil,nil,nil,true)
  end
 if WillItMog.verbose and noSourceReason and noSourceReason ~= noChangeReason
  then tooltip:AddLine(gsub(_G["ERR_TRANSMOGRIFY_"..noSourceReason] or noSourceReason,"%%s",""),nil,nil,nil,true)
  end
 tooltip:Show()
 end

local frame=CreateFrame("FRAME")
frame:SetScript("OnEvent",function(self,event)
 frame:UnregisterEvent("ADDON_LOADED")
-- start hooking tooltips
 GameTooltip:HookScript("OnTooltipSetItem",WIMtooltip)
 ItemRefTooltip:HookScript("OnTooltipSetItem",WIMtooltip)
 end)

frame:RegisterEvent("ADDON_LOADED")