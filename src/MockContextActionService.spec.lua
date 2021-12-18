return function()
	local MockContextActionService = require(script.Parent.MockContextActionService)

	describe("BindActionAtPriority", function()
		it("should bind an action", function()
			MockContextActionService:BindActionAtPriority("foo", function() end, false, 2000, Enum.KeyCode.E)
			expect(MockContextActionService._actions.foo).to.be.ok()
		end)
	end)

	describe("UnbindAction", function()
		it("should unbind an action", function()
			MockContextActionService:BindActionAtPriority("foo", function() end, false, 2000, Enum.KeyCode.E)

			expect(MockContextActionService._actions.foo).to.be.ok()

			MockContextActionService:UnbindAction("foo")

			expect(MockContextActionService._actions.foo).to.never.be.ok()
		end)
	end)

	describe("SimulateInput", function()
		it("should simulate a key press that triggers a bound acction's callback at the beginning and end", function()
			local callCount = 0

			local function callback(input)
				expect(
					input.UserInputState == Enum.UserInputState.Begin or input.UserInputState == Enum.UserInputState.End
				)

				callCount = callCount + 1
			end

			MockContextActionService:BindActionAtPriority("foo", callback, false, 2000, Enum.KeyCode.E)
			MockContextActionService:SimulateInput(Enum.KeyCode.E)

			expect(callCount).to.equal(2)
		end)
	end)

	describe("SimulateInputBegin", function()
		it("should simulate a key press that triggers a bound acction's callback at the beginning", function()
			local callCount = 0

			local function callback(input)
				expect(input.UserInputState == Enum.UserInputState.Begin)
				callCount = callCount + 1
			end

			MockContextActionService:BindActionAtPriority("foo", callback, false, 2000, Enum.KeyCode.E)
			MockContextActionService:SimulateInputBegin(Enum.KeyCode.E)

			expect(callCount).to.equal(1)
		end)
	end)

	describe("SimulateInputEnd", function()
		it("should simulate a key press that triggers a bound acction's callback at the end", function()
			local callCount = 0

			local function callback(input)
				expect(input.UserInputState == Enum.UserInputState.End)
				callCount = callCount + 1
			end

			MockContextActionService:BindActionAtPriority("foo", callback, false, 2000, Enum.KeyCode.E)
			MockContextActionService:SimulateInputBegin(Enum.KeyCode.E)

			expect(callCount).to.equal(1)
		end)
	end)
end
