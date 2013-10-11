local myPlayerRealm = GetCVar("realmName")
local myPlayerName  = UnitName("player")

if not QulightConfigAll then QulightConfigAll = {} end		
if (QulightConfigAll[myPlayerRealm] == nil) then QulightConfigAll[myPlayerRealm] = {} end
if (QulightConfigAll[myPlayerRealm][myPlayerName] == nil) then QulightConfigAll[myPlayerRealm][myPlayerName] = false end

if QulightConfigAll[myPlayerRealm][myPlayerName] == true and not QulightConfig then return end
if QulightConfigAll[myPlayerRealm][myPlayerName] == false and not QulightConfigSettings then return end


if QulightConfigAll[myPlayerRealm][myPlayerName] == true then
	for group,options in pairs(QulightConfig) do
		if Qulight[group] then
			local count = 0
			for option,value in pairs(options) do
				if Qulight[group][option] ~= nil then
					if Qulight[group][option] == value then
						QulightConfig[group][option] = nil	
					else
						count = count+1
						Qulight[group][option] = value
					end
				end
			end
			-- keeps QulightConfig clean and small
			if count == 0 then QulightConfig[group] = nil end
		else
			QulightConfig[group] = nil
		end
	end
else
	for group,options in pairs(QulightConfigSettings) do
		if Qulight[group] then
			local count = 0
			for option,value in pairs(options) do
				if Qulight[group][option] ~= nil then
					if Qulight[group][option] == value then
						QulightConfigSettings[group][option] = nil	
					else
						count = count+1
						Qulight[group][option] = value
					end
				end
			end
			-- keeps QulightConfig clean and small
			if count == 0 then QulightConfigSettings[group] = nil end
		else
			QulightConfigSettings[group] = nil
		end
	end
end

