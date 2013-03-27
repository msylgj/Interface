-- Author      : Nedlinin

local lastplayers = { };

totallastplayers = { };

entries = 0;
local newWhisp=true;
local toggled = "ON";

friendsWhisp = "OFF";
guildWhisp = "OFF";

function WhoWhisperedMe_OnLoad(self)
  SLASH_WWM1 = "/wwm";
  SlashCmdList["WWM"] = WhoWhisperedMeCmds;

	self:RegisterEvent("ADDON_LOADED");
	self:RegisterEvent("CHAT_MSG_WHISPER");

    --DEFAULT_CHAT_FRAME:AddMessage("|c00ffff00WhoWhisperedMe |r Loaded! Use /wwm for command list!");
	WhoWhisperedMe:Hide();
end

function WhoWhisperedMe_OnEvent(self, event, ...)

local arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13 = ...
if(event=="CHAT_MSG_WHISPER") then --if I get a whisper

if totallastplayers["entries"] ~= nil then
  local total = 0;
    totallastplayers["entries"] = nil;
 	for k, v in pairs(totallastplayers) do
		total = total+1;
    end
  entries = total;
end
name = arg2;

if totallastplayers[name.."SentCount"] ~= nil then
  if totallastplayers[name] == nil then
    totallastplayers[name] = totallastplayers[name.."SentCount"];
  end
    totallastplayers[name.."SentCount"] = nil;
end

if(totallastplayers[name] == nil) then

	if(entries == nil) or entries == 0 then
	  entries = 1;
    else
	  entries = entries+1;
	end

  totallastplayers[name] = 1;

else
  totallastplayers[name] = totallastplayers[name]+1;
end

  --newWhisp=true; -- Its a 'new whisperer'
	if(friendsWhisp=="OFF") then -- if I want to not see friends whod
	  for i = 1, GetNumFriends() do -- get friends names(friends 1-# of friends)
		if GetFriendInfo(i) == name then -- They are on friends list
		  newWhisp=false; -- Not a whisper I want to see
		else -- Not on friends list
		end --if GetFriendInfo
      end -- end for loop
    end --end if/else(if FriendsWhisper == OFF)

    if(guildWhisp=="OFF") then -- I dont want to see guild members whod
	 for i = 1, GetNumGuildMembers(1) do
       if GetGuildRosterInfo(i) == name then
			newWhisp=false;
	   end -- end if on guild roster
	 end --end for loop
	end --end if guildWhisp

 if(newWhisp==true) then
	if(toggled=="ON") then
		if(not lastplayers[name]) then
			SendWho(name);
			lastplayers[name] = true;
		end
	end --end if toggled
 end --new whisper
 newWhisp=true;
end -- end if event
end


function WhoWhisperedMeCmds(command)
  command = string.lower(command);
if(command=="toggle") then
  if(toggled=="ON") then
      toggled = "OFF";
	  DEFAULT_CHAT_FRAME:AddMessage("|c00ffff00WhoWhisperedMe|r: disabled!");
    else
      toggled = "ON";
  	  DEFAULT_CHAT_FRAME:AddMessage("|c00ffff00WhoWhisperedMe|r: enabled!");
    end


elseif(command=="friends") then
  if(friendsWhisp=="ON") then
	  friendsWhisp="OFF";
	  DEFAULT_CHAT_FRAME:AddMessage("|c00ffff00WhoWhisperedMe|r: Whoing friends now OFF");
    else
      friendsWhisp="ON";
   	  DEFAULT_CHAT_FRAME:AddMessage("|c00ffff00WhoWhisperedMe|r: Whoing friends now ON");
   end


elseif(command=="guild") then
  if(guildWhisp=="ON") then
    guildWhisp="OFF";
	DEFAULT_CHAT_FRAME:AddMessage("|c00ffff00WhoWhisperedMe|r: Whoing guildmates now OFF");
  else
    guildWhisp="ON";
	DEFAULT_CHAT_FRAME:AddMessage("|c00ffff00WhoWhisperedMe|r: Whoing guildmates now ON");
  end


elseif(command =="stats") then
  if entries == 0 then
      DEFAULT_CHAT_FRAME:AddMessage("|c00ffff00WhoWhisperedMe|r: You have never been whispered!");
  else
    local highest = -1;
	local index = nil;
	for k, v in pairs(totallastplayers) do
		if v > highest then
			highest = v;
			index = k;
		end
	end

   DEFAULT_CHAT_FRAME:AddMessage("|c00ffff00WhoWhisperedMe|r: "..entries.." people have whispered you!");
   DEFAULT_CHAT_FRAME:AddMessage("|c00ffff00WhoWhisperedMe|r: The player who has whispered you the most is: " .. index ..".  They have whispered you ".. highest.." times!");
   end

else
   DEFAULT_CHAT_FRAME:AddMessage("|c00ffff00WhoWhisperedMe|r command list:");
   DEFAULT_CHAT_FRAME:AddMessage("'/wwm toggle' to toggle addon ON or OFF - Currently toggled: " .. toggled);
   DEFAULT_CHAT_FRAME:AddMessage("'/wwm friends' to toggle the Whoing of Friends ON or OFF - Currently toggled: " .. friendsWhisp);
   DEFAULT_CHAT_FRAME:AddMessage("'/wwm guild' to toggle the Whoing of Guildmates ON or OFF - Currently toggled: " .. guildWhisp);
   DEFAULT_CHAT_FRAME:AddMessage("'/wwm stats' to see your whisper statistics");
 end

end--end function


