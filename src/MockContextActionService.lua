--[[
	Mock version of ContextActionService so we can simulate input.

	Because this is all tested from studio and we need it to be automatic, this
	allows us to fake key presses and other input types so that we're fairly
	certain everything will work in a live game.
]]

local MockContextActionService = {
	_actions = {},
}

function MockContextActionService:BindActionAtPriority(name, callback, createTouchButton, priority, ...)
	self._actions[name] = {
		name = name,
		callback = callback,
		createTouchButton = createTouchButton,
		priority = priority,
		inputTypes = { ... },
	}
end

function MockContextActionService:UnbindAction(name)
	self._actions[name] = nil
end

function MockContextActionService:GetActionsForInputType(inputType)
	local actions = {}

	for _, action in pairs(self._actions) do
		for _, otherInputType in ipairs(action.inputTypes) do
			if inputType == otherInputType then
				table.insert(actions, action)
			end
		end
	end

	return actions
end

function MockContextActionService:SimulateInput(inputType: any, inputStates: Enum.UserInputState)
	inputStates = inputStates or {
		Enum.UserInputState.Begin,
		Enum.UserInputState.End,
	}

	local actions = self:GetActionsForInputType(inputType)

	for _, action in ipairs(actions) do
		for _, inputState in ipairs(inputStates) do
			-- Fake InputObject so we can check what the state was
			local inputObject = {
				UserInputState = inputState,
			}

			action.callback(action.name, inputState, inputObject)
		end
	end
end

function MockContextActionService:SimulateInputBegin(inputType: any)
	self:SimulateInput(inputType, { Enum.UserInputState.Begin })
end

function MockContextActionService:SimulateInputEnd(inputType: any)
	self:SimulateInput(inputType, { Enum.UserInputState.End })
end

return MockContextActionService
