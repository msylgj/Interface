--[[

AchievementLinkFix
// Colors linked achievements green.

By Moduspwnens of Shattered Hand

A very simple add-on to re-color achievement links that are completed.

]] --
-- Below is the hex code for the color to be used for completed achievements.
-- You can change it, but it must be a hex code.
-- See some here: http://www.malanenewman.com/browser_safe_color_wheel.html
ALF_ReplacementColor = "99FF00"
local _G = _G
local chatChannels = {
	"CHAT_MSG_ACHIEVEMENT",
	"CHAT_MSG_BATTLEGROUND",
	"CHAT_MSG_BATTLEGROUND_LEADER",
	"CHAT_MSG_CHANNEL",
	"CHAT_MSG_CHANNEL_JOIN",
	"CHAT_MSG_CHANNEL_LEAVE",
	"CHAT_MSG_EMOTE",
	"CHAT_MSG_GUILD",
	"CHAT_MSG_GUILD_ACHIEVEMENT",
	"CHAT_MSG_OFFICER",
	"CHAT_MSG_PARTY",
	"CHAT_MSG_RAID",
	"CHAT_MSG_RAID_LEADER",
	"CHAT_MSG_RAID_WARNING",
	"CHAT_MSG_SAY",
	"CHAT_MSG_TEXT_EMOTE",
	"CHAT_MSG_WHISPER",
	"CHAT_MSG_WHISPER_INFORM",
	"CHAT_MSG_YELL",
}

--------------------------
-- OnLoad function
--
-- This should just initialize the message event filters. No filtering is actually done here.
--------------------------

function ALF_OnLoad(self, event, addon)

	-- Loads message event filters for each achievement type.
	for i=1, #(chatChannels) do
		ChatFrame_AddMessageEventFilter(chatChannels[i], ALF_OnChatReceived)
	end

	-- This is necessary because evidently macros hit this, but I won't be editing macros... just achievement links.
	hooksecurefunc('ChatEdit_ParseText', ALF_ParseText)

	AchievementLinkFix:UnregisterAllEvents()
	AchievementLinkFix:SetScript("OnEvent", nil)
end

--------------------------
-- OnChatReceived
--
-- This is the function that is passed each chat message's details. Filtering is done here.
--------------------------

function ALF_OnChatReceived(self, event, message, author, ...)

	local message = message

	if(strfind(message, "|cffffff00|Hachievement:") ~= nil) then
		-- There is an achievement in chat.
		local fullMessage = message

		while(fullMessage ~= nil) do
			-- Split the message by colons.
			part1, fullMessage = strsplit(":", fullMessage, 2)

			if(strfind(part1,"|Hachievement")) then
				-- If a resulting string contains the text used to make an achievement hyperlink
				local id,guid,completed,_ = strsplit(":", fullMessage)

				if(completed == "1") then
					-- If it's completed, figure out the beginning of the link based on the ID and GUID.
					-- This way we only recolor the achievement we want, rather than all of them in the message.
					local targetString = "|cffffff00|Hachievement:"..id..":"..guid..":"..completed
					local replacementString = "|cff"..ALF_ReplacementColor.."|Hachievement:"..id..":"..guid..":"..completed
					message = string.gsub(message, targetString, replacementString)
				end
			end
		end
		return false, message, author, ...
	end
	return false
end

--------------------------
-- ParseText
--
-- This function checks outgoing messages for achievement links colored green (invalid to the server) and
-- sets them back to standard color.
--------------------------

function ALF_ParseText(chatEntry, send)
	if (send == 1) then
		-- This message is being sent.

		local message = chatEntry:GetText()

		if(strfind(message,  "|cff"..ALF_ReplacementColor.."|Hachievement")) then

			local targetString =  "|cff"..ALF_ReplacementColor.."|Hachievement"
			local replacementString = "|cffffff00|Hachievement"
			message = string.gsub(message, targetString, replacementString)
			chatEntry:SetText(message)

		end

	end
end


-- This done to create the frame so it need not be done in XML.
local AchievementLinkFix = CreateFrame("Frame", "AchievementLinkFix")
AchievementLinkFix:RegisterEvent("ADDON_LOADED")
AchievementLinkFix:SetScript("OnEvent", ALF_OnLoad)