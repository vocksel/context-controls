local Action = require(script.Parent.Action)
local types = require(script.Parent.types)

--[=[
	Constructs an Action from a table of properties. This allows you to setup
	everything, such as the name, callback, and input types, without having to call
	any methods.

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

	@within ContextControls
	@return Action
]=]
local function createAction(actionObject: types.ActionObject)
	assert(types.ActionObject(actionObject))
	return Action.fromObject(actionObject)
end

return createAction
