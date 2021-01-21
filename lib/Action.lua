local ContextActionService = game:GetService("ContextActionService")

local t = require(script.Parent.t)
local types = require(script.Parent.types)

local Action = {}
Action.__index = Action

Action.contextActionServiceImpl = ContextActionService

function Action.new(name)
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

function Action.fromObject(actionObject)
	assert(types.ActionObject(actionObject))

	local action = Action.new(actionObject.name)

	-- Override properties in the action instance with the ones passed in by the
	-- object.
	for k, v in pairs(actionObject) do
		action[k] = v
	end

	return action
end

function Action:setCallback(callback)
	assert(t.callback(callback))

	self.callback = callback
end

local setInputTypesCheck = t.array(types.InputType)
function Action:setInputTypes(inputTypes)
	assert(setInputTypesCheck(inputTypes))

	self.inputTypes = inputTypes
end

local setMobileButtonCheck = t.instanceIsA("GuiButton")
function Action:setMobileButton(mobileButton)
	assert(setMobileButtonCheck(mobileButton))

	self.mobileButton = mobileButton
end

function Action:bindAtPriority(priority)
	assert(types.ActionPriority(priority))

	assert(not self.isBound, ("%s is already bound and cannot be bound to again"):format(self.name))
	assert(self.callback, "No callback found, run setCallback() first")
	assert(self.inputTypes, "No input types found, run setInputTypes() first")

	local function callback(_, inputState, inputObject)
		if (not self.inputState) or (self.inputState and inputState == self.inputState) then
			return self.callback(inputObject)
		end
	end

	self.contextActionServiceImpl:BindActionAtPriority(self.name, callback, false, priority, unpack(self.inputTypes))
	self.isBound = true
end

function Action:bind()
	self:bindAtPriority(self.priority)
end

function Action:unbind()
	assert(self.isBound, ("Could not unbind %s (already unbound)"):format(self.name))

	self.contextActionServiceImpl:UnbindAction(self.name)
	self.isBound = false
end

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
