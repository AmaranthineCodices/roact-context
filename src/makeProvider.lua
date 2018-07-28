local Roact = require(script.Parent.Parent.Roact)
local Signal = require(script.Parent.Signal)

local function makeProvider(contextKey)
	local providerComponent = Roact.PureComponent:extend("RoactContext.Provider")

	function providerComponent:init()
		self._context[contextKey] = self
		self.changed = Signal.new()
	end

	function providerComponent:didUpdate()
		self.changed:fire(self.props.value)
	end

	function providerComponent:getValue()
		return self.props.value
	end

	function providerComponent:render()
		return Roact.oneChild(self.props[Roact.Children])
	end
end

return makeProvider
