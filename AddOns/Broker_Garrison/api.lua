local ADDON_NAME, private = ...

local Garrison = LibStub("AceAddon-3.0"):GetAddon(ADDON_NAME)
local garrisonDb, globalDb, configDb

local debugPrint = Garrison.debugPrint

local events = {
	[Garrison.TYPE_MISSION] = {},
	[Garrison.TYPE_BUILDING] = {},
	[Garrison.TYPE_SHIPMENT] = {},
}

local function ldb(name) 
	if Garrison.ldbVars and Garrison.ldbVars[name] and Garrison.ldbVars[name].data and Garrison.data then
		return Garrison.ldbVars[name].data(Garrison.data)
	end

	return nil
end

local function get(realm, player) 
	if globalDb.data and globalDb.data[realm] and globalDb.data[realm][player] then
		return globalDb.data[realm][player]
	end

	return nil
end

local function register(event, callable) 
	if event and callable and events[event] then
		events[event][#events] = callable
	end
end

local function fireEvent(event, paramCharInfo, data)
	local dataCopy = Garrison.deepcopy(data)
	if events and events[event] ~= nil then
		debugPrint(("fireEvent [%s] (%s-%s): %s"):format(event, paramCharInfo.realmName, paramCharInfo.playerName, tostring(data)))
		for _, callable in pairs(events[event]) do			
			callable(paramCharInfo, dataCopy)
		end
	end
end

Garrison.fireEvent = fireEvent

function Garrison:SetupAPI()
	garrisonDb = self.DB
	configDb = garrisonDb.profile
	globalDb = garrisonDb.global

end


--_G["BrokerGarrison"].ldbVars = Garrison.ldbVars
_G["BrokerGarrison"].ldb = ldb
_G["BrokerGarrison"].get = get
_G["BrokerGarrison"].registerEvent = register
_G["BrokerGarrison"].TYPE_MISSION = Garrison.TYPE_MISSION
_G["BrokerGarrison"].TYPE_BUILDING = Garrison.TYPE_BUILDING
_G["BrokerGarrison"].TYPE_SHIPMENT = Garrison.TYPE_SHIPMENT
