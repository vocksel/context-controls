local ContextActionService = game:GetService("ContextActionService")

local t = require(script.Parent.t)
local types = require(script.Parent.types)

--[=[
	This is the class that wraps around ContextActionService to provide a better
	API to work with.

	You should typically use `ContextControls.createAction()`, but you can also
	instantiate an Action instance manually using `Action.new()` or
	`Action.fromObject()` which are documented below.

	@class Action
]=]
local Action = {}
Action.__index = Action

type Action = typeof(Action.new())

Action.contextActionServiceImpl = ContextActionService

--[=[
	@prop name string
	@within Action

	The name of the action.
]=]

--[=[
	@prop inputTypes InputTypes
	@within Action

	The various input types that the action responds to.
]=]

--[=[
	@prop inputState Enum.UserInputState
	@within Action

	A specific UserInputState that the callback responds to.

	By default, the callback is called twice: once when the user starts
	interacting, and again when they stop. This is because ContextActionService
	does not use `InputBegan` or `InputEnd` events like UserInputService. It
	triggers the callback for both, and leaves it up to the user to filter out
	the one they want.

	Instead of having to check `if input.UserInputState == Enum.UserInputState.Foo`
	in your callback, you can simply set this property.
]=]

--[=[
	@prop priority number
	@within Action

	Sets the priority that ContextActionService will use for the action. By
	default this is `Enum.ContextActionPriority.Default.Value`
]=]

--[=[
	Constructs an Action instance from a name. You then need to use the various
	methods of this class to setup the callback, input types, and anything else
	before binding.

	```lua
	local action = Action.new("foo")

	action:setInputTypes({
		Enum.KeyCode.E,
		Enum.UserInputType.MouseButton1,
	})

	action:setCallback(function(input: InputObject)
		print("Hello, world!")
	end)
	```
]=]
function Action.new(name: string): Action
	assert(t.string(name))

	local self = {
		name = name,
		priority = Enum.ContextActionPriority.Default.Value,
		isBound = false,
		inputState = nil,
		callback = nil,
		inputTypes = nil,
		mobileButton = nil,
	}

	return setmetatable(self, Action)
end

--[=[
	Constructs an Action from a table of properties. This allows you to setup
	everything, such as the name, callback, and input types, without having to
	call any methods.

	All of the properties listed above can be used here.

	```lua
	local action = Action.fromObject({
		name = "foo",
		inputTypes = {
			Enum.KeyCode.E,
			Enum.UserInputType.MouseButton1,
		},
		callback = function(input: InputObject)
			print("Hello, world!")
		end
	})
	```
]=]
function Action.fromObject(actionObject: types.ActionObject): Action
	assert(types.ActionObject(actionObject))

	local action = Action.new(actionObject.name)

	-- Override properties in the action instance with the ones passed in by the
	-- object.
	for k, v in pairs(actionObject) do
		action[k] = v
	end

	return action
end

--[=[
	Sets the callback for the action.

	This is what gets called when one of the input types is activated by the user.

	```lua
	local action = Action.new("foo")

	action:setCallback(function(input: InputObject)
		print("Hello world!")
	end)
	```
]=]
function Action:setCallback(callback: (InputObject) -> nil)
	assert(t.callback(callback))

	self.callback = callback
end

local setInputTypesCheck = t.array(types.InputType)
--[=[
	Sets the input types that the action will be triggered for.

	```lua
	local action = Action.new("foo")

	action:setInputTypes({
		Enum.KeyCode.E,
		Enum.KeyCode.ButtonX,
	})
	```
]=]
function Action:setInputTypes(inputTypes: types.InputTypes)
	assert(setInputTypesCheck(inputTypes))

	self.inputTypes = inputTypes
end

local setMobileButtonCheck = t.instanceIsA("GuiButton")
function Action:setMobileButton(mobileButton)
	assert(setMobileButtonCheck(mobileButton))

	self.mobileButton = mobileButton
end

--[=[
	Binds the action at the given priority level.

	From here, any of the input types being triggered will cause the callback to
	be run.

	If the callback or input types are not set, this function will error.

	If the function is already bound, it will error.

	```lua
	local action = Action.new("foo")
	action:setCallback(...)
	action:setInputTypes(...)

	action:bindAtPriority(Enum.ContextActionPriority.High.Value)
	```
]=]
function Action:bindAtPriority(priority: Enum.ContextActionPriority | number)
	assert(types.ActionPriority(priority))

	assert(not self.isBound, ("%s is already bound and cannot be bound to again"):format(self.name))
	assert(self.callback, "No callback found, run setCallback() first")
	assert(self.inputTypes, "No input types found, run setInputTypes() first")

	local function callback(_, inputState, inputObject)
		if not self.inputState or (self.inputState and inputState == self.inputState) then
			return self.callback(inputObject)
		end
	end

	self.contextActionServiceImpl:BindActionAtPriority(self.name, callback, false, priority, unpack(self.inputTypes))
	self.isBound = true
end

--[=[
	Binds the action at the same priority as the `priority` property.

	From here, any of the input types being triggered will cause the callback to
	be run.

	If the callback or input types are not set, this function will error.

	If the function is already bound, it will error.

	```lua
	local action = Action.new("foo")
	action:setCallback(...)
	action:setInputTypes(...)

	action:bind()
	```
]=]
function Action:bind()
	self:bindAtPriority(self.priority)
end

--[=[
	Unbinds the action so that the callback will not be run when one of the
	input types is triggered.

	```lua
	local action = Action.new("foo")
	action:setCallback(...)
	action:setInputTypes(...)

	action:bind()

	-- later
	action:unbind()
	```
]=]
function Action:unbind()
	assert(self.isBound, ("Could not unbind %s (already unbound)"):format(self.name))

	self.contextActionServiceImpl:UnbindAction(self.name)
	self.isBound = false
end

--[=[
	Automatically binds and unbinds the action when in range of a ProximityPrompt.

	With this method, you do not need to call `bind()`, `unbind()`, or
	`setCallback()`. These methods are all handled automatically based on the
	`PromptShown` and `PromptHidden` events of the ProximityPrompt.

	```lua
	local action = Action.new("foo")
	action:setInputTypes(...)

	action:addTrigger(trigger, function(input: InputObject)
		print("Hello world!")
	end)
	```

	You can add as many triggers as you want for the same action, and they will
	all take control of binding and unbinding it.

	:::caution
	When using this method do not manually bind and unbind the action as this
	can lead to the action getting unexpectedly stuck in bound/unbound states.
	:::
]=]
function Action:addTrigger(trigger: ProximityPrompt, callback: () -> nil)
	trigger.PromptShown:Connect(function()
		if self.isBound then
			self:unbind()
		end

		self:setCallback(callback)
		self:bind()
	end)

	trigger.PromptHidden:Connect(function()
		if self.isBound then
			self:unbind()
		end
	end)
end

return Action
