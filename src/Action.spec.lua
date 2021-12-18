return function()
	local ContextActionService = game:GetService("ContextActionService")

	local MockContextActionService = require(script.Parent.MockContextActionService)
	local Action = require(script.Parent.Action)

	local MOCK_PRIORITY = Enum.ContextActionPriority.Default.Value

	local MOCK_CALLBACK = function() return true end
	local MOCK_INPUT_TYPES = {
		Enum.KeyCode.E,
		Enum.KeyCode.ButtonB,
	}
	local MOCK_MOBILE_BUTTON = Instance.new("ImageButton")

	-- This is for use with GetBoundActionInfo. Apparently an empty table is
	-- returned even if the action has never been bound! cool!
	local function isEmpty(t)
		return next(t) == nil
	end

	describe("new", function()
		it("should create a new Action", function()
			local action = Action.new("foo")

			expect(action.name).to.equal("foo")
			expect(action).to.never.equal(Action)
		end)
	end)

	describe("fromObject", function()
		it("should only require the name field", function()
			expect(function()
				Action.fromObject({
					name = "foo",
				})
			end).to.never.throw()

			expect(function()
				Action.fromObject({})
			end).to.throw()
		end)

		it("should create a new Action from an object", function()
			local action = Action.fromObject({
				name = "foo",
				mobileButton = MOCK_MOBILE_BUTTON,
				callback = MOCK_CALLBACK,
				inputTypes = MOCK_INPUT_TYPES
			})

			expect(action.name).to.equal("foo")
			expect(action.mobileButton).to.equal(MOCK_MOBILE_BUTTON)
			expect(action.callback).to.equal(MOCK_CALLBACK)
			expect(action.inputTypes).equal(MOCK_INPUT_TYPES)
		end)
	end)

	describe("setCallback", function()
		it("should set `callback` to the given function", function()
			local action = Action.new("foo")

			action:setCallback(MOCK_CALLBACK)

			expect(action.callback).to.equal(MOCK_CALLBACK)
		end)
	end)

	describe("setInputTypes", function()
		it("should set `inputTypes` to the given array", function()
			local action = Action.new("foo")

			action:setInputTypes(MOCK_INPUT_TYPES)

			expect(action.inputTypes).to.equal(MOCK_INPUT_TYPES)
		end)
	end)

	-- describe("setMobileButton", function()
	-- 	it("should set properties for the mobile button", function()
	-- 		local action = Action.new("foo")

	-- 		action:setMobileButton(MOCK_MOBILE_BUTTON, MOCK_MOBILE_BUTTON.Activated)

	-- 		expect(action.mobileButton).to.equal(MOCK_MOBILE_BUTTON)
	-- 		expect(action.mobileEvent).to.equal(MOCK_MOBILE_BUTTON.Activated)
	-- 	end)
	-- end)

	describe("bindAtPriority", function()
		it("should register the action with ContextActionService", function()
			local action = Action.new("foo")
			action:setCallback(MOCK_CALLBACK)
			action:setInputTypes(MOCK_INPUT_TYPES)

			action:bindAtPriority(MOCK_PRIORITY)

			local info = ContextActionService:GetBoundActionInfo(action.name)

			expect(not isEmpty(info)).to.equal(true)
		end)

		it("should change `isBound` to true", function()
			local action = Action.new("foo")
			action:setCallback(MOCK_CALLBACK)
			action:setInputTypes(MOCK_INPUT_TYPES)

			expect(action.isBound).to.equal(false)

			action:bindAtPriority(MOCK_PRIORITY)

			expect(action.isBound).to.equal(true)
		end)

		-- Need to mock ContextActionService to test this
		it("should be able to be bound to UserInputState.Begin", function()
			local wasCalled = false

			local action = Action.fromObject({
				name = "foo",
				inputState = Enum.UserInputState.Begin,
				inputTypes = MOCK_INPUT_TYPES,
				callback = function(input)
					expect(input.UserInputState == Enum.UserInputState.Begin)
					wasCalled = true
				end,
			})

			action.contextActionServiceImpl = MockContextActionService
			action:bindAtPriority(MOCK_PRIORITY)

			MockContextActionService:SimulateInputBegin(Enum.KeyCode.E)

			expect(wasCalled).to.equal(true)
		end)

		it("should be able to be bound to UserInputState.End", function()
			local wasCalled = false

			local action = Action.fromObject({
				name = "foo",
				inputState = Enum.UserInputState.Begin,
				inputTypes = MOCK_INPUT_TYPES,
				callback = function(input)
					expect(input.UserInputState == Enum.UserInputState.End)
					wasCalled = true
				end,
			})

			action.contextActionServiceImpl = MockContextActionService
			action:bindAtPriority(MOCK_PRIORITY)

			MockContextActionService:SimulateInputBegin(Enum.KeyCode.E)

			expect(wasCalled).to.equal(true)
		end)

		it("should error if the action is already bound", function()
			local action = Action.new("foo")
			action:setCallback(MOCK_CALLBACK)
			action:setInputTypes(MOCK_INPUT_TYPES)

			expect(action.isBound).to.equal(false)

			action:bindAtPriority(MOCK_PRIORITY)

			expect(action.isBound).to.equal(true)

			expect(function()
				action:bind()
			end).to.throw()
		end)

		it("should error if `inputTypes` isn't set", function()
			local action = Action.new("foo")
			action:setCallback(MOCK_CALLBACK)

			expect(action.inputTypes).to.never.be.ok()

			expect(function()
				action:bindAtPriority(MOCK_PRIORITY)
			end).to.throw()
		end)

		it("should error if `callback` isn't set", function()
			local action = Action.new("foo")
			action:setInputTypes(MOCK_INPUT_TYPES)

			expect(action.callback).to.never.be.ok()

			expect(function()
				action:bindAtPriority(MOCK_PRIORITY)
			end).to.throw()
		end)
	end)

	describe("bind", function()
		-- This does the same thing as bindAtPriority but with implicit
		-- priority. Unsure how to test that
	end)

	describe("unbind()", function()
		it("should change the isBound property to false", function()
			local action = Action.new("foo")
			action:setCallback(MOCK_CALLBACK)
			action:setInputTypes(MOCK_INPUT_TYPES)

			action:bind()

			expect(action.isBound).to.equal(true)

			action:unbind()

			expect(action.isBound).to.equal(false)
		end)

		it("should unbind the action from ContextActionService", function()

		end)

		it("should error if the action is not bound", function()
			local action = Action.new("foo")

			expect(function()
				action:unbind()
			end).to.throw()
		end)
	end)

	-- describe("getInfo()", function()
	-- 	it("should return info from ContextActionService about the bound action", function()

	-- 	end)

	-- 	it("should return nil when the action isn't bound", function()
	-- 		local action = Action.new("foo")

	-- 		expect(action:getInfo()).to.equal(nil)
	-- 	end)
	-- end)
end
