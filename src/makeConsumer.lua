local Roact = require(script.Parent.Parent.Roact)

local function makeConsumer(contextKey, defaultValue)
	local consumerComponent = Roact.PureComponent:extend("RoactContext.Consumer")

	function consumerComponent:init()
		self.state = {
			contextValue = self:getProvidedValue()
		}
	end

	function consumerComponent:getProvider()
		local provider = self._context[contextKey]

		return provider
	end

	function consumerComponent:didUpdate()
		local currentProvider = self._provider
		local provider = self:getProvider()

		if provider == currentProvider then
			return
		else
			self._providerConnection:disconnect()
			self._providerConnection = provider.changed:connect(function(newValue)
				self:setState({
					contextValue = self:getProvidedValue()
				})
			end)

			self:setState({
				contextValue = self:getProvidedValue()
			})
		end
	end

	function consumerComponent:willUnmount()
		if self._providerConnection then
			self._providerConnection:Disconnect()
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
