return function()
	local Roact = require(script.Parent.Parent.Roact)
	local e = Roact.createElement
	local createContext = require(script.Parent.createContext)

	it("should create a unique provider and consumer pair", function()
		local providerA, consumerA = createContext("default")
		local providerB, consumerB = createContext("default")

		expect(providerA).to.never.equal(providerB)
		expect(consumerA).to.never.equal(consumerB)
	end)

	it("should allow use of the provided value", function()
		local provider, consumer = createContext("default")
		local providedValue = nil

		local tree = e(provider, {
			value = "test",
		}, {
			e("Frame", {}, {
				e(consumer, {}, {
					function(value)
						providedValue = value
						return nil
					end
				})
			})
		})

		local handle = Roact.mount(tree, nil, "test")
		expect(providedValue).to.equal("test")

		handle = Roact.reconcile(handle, e(provider, {
			value = "abc",
		}, {
			e("Frame", {}, {
				e(consumer, {}, {
					function(value)
						providedValue = value
						return nil
					end
				})
			})
		}))

		expect(providedValue).to.equal("abc")

		Roact.unmount(handle)
	end)

	it("should use the value provided to createContext if and only if no provider exists in the tree", function()
		local provider, consumer = createContext("default")

		local tree = e(consumer, {}, {
			function(value)
				expect(value).to.equal("default")
				return nil
			end
		})

		local handle = Roact.mount(tree, nil, "test")
		Roact.unmount(handle)

		tree = e(provider, {
			value = nil
		}, {
			e(consumer, {}, {
				function(value)
					expect(value).to.equal(nil)
					return nil
				end
			})
		})

		handle = Roact.mount(tree, nil, "test")
		Roact.unmount(handle)
	end)
end