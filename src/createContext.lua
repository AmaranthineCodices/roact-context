local makeConsumer = require(script.Parent.makeConsumer)
local makeProvider = require(script.Parent.makeProvider)

local function createContext(defaultValue)
	local contextKey = newproxy()

	return makeProvider(contextKey), makeConsumer(contextKey, defaultValue)
end

return createContext