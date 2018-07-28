local Roact = require(script.Parent.Parent.Roact)

local function makeConsumer(contextKey, defaultValue)
	local consumerComponent = Roact.PureComponent:extend("RoactContext.Consumer")

	function consumerComponent:init()
		self.state = {
			contextValue = self:getProvidedValue()
		}

		self:connectProvider()
	end

	function consumerComponent:getProvider()
		local provider = self._context[contextKey]

		return provider
	end

	function consumerComponent:connectProvider()
		local currentProvider = self._provider
		local provider = self:getProvider()

		if provider == currentProvider then
			return
		elseif provider ~= nil then
			self._provider = provider

			if self._providerConnection ~= nil then
				self._providerConnection:disconnect()
			end

			self._providerConnection = provider.changed:connect(function(newValue)
				self:setState({
					contextValue = self:getProvidedValue()
				})
			end)
		end
	end

	function consumerComponent:willUpdate()
		self:connectProvider()
	end

	function consumerComponent:willUnmount()
		if self._providerConnection ~= nil then
			self._providerConnection:disconnect()
		end
	end

	function consumerComponent:getProvidedValue()
		local provider = self:getProvider()

		if provider == nil then
			return defaultValue
		else
			return provider:getValue()
		end
	end

	function consumerComponent:render()
		local renderer = Roact.oneChild(self.props[Roact.Children])
		local providedValue = self:getProvidedValue()

		return renderer(providedValue)
	end

	return consumerComponent
end

return makeConsumer
