return function()
	local ContextControls = require(script.Parent)

	describe("createAction", function()
		it("should return a new Action", function()
			local action = ContextControls.createAction({
				name = "foo",
				callback = function() end,
				inputTypes = {},
			})

			expect(action).to.be.a("table")
			expect(action.name).to.equal("foo")
			expect(action.callback).to.be.a("function")
			expect(action.inputTypes).to.be.a("table")
		end)
	end)
end
