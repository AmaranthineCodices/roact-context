--[[
	A signal that calls listeners synchronously.
]]

local Signal = {}
Signal.__index = Signal

function Signal.new()
	return setmetatable({
		_listeners = {},
	}, Signal)
end

function Signal:connect(listener)
	table.insert(self._listeners, listener)

	return {
		disconnect = function()
			for i = #self._listeners, 1, -1 do
				if self._listeners[i] == listener then
					table.remove(self._listeners, i)
					break
				end
			end
		end,
	}
end

function Signal:fire(...)
	for _, listener in ipairs(self._listeners) do
		listener(...)
	end
end

return Signal
