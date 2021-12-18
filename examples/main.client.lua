local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ContextControls = require(ReplicatedStorage.ContextControls)

local interact = ContextControls.createAction({
	name = "interact",
	inputTypes = {
		Enum.KeyCode.E,
		Enum.KeyCode.ButtonX,
	},
	inputState = Enum.UserInputState.Begin,
	callback = function(_input: InputObject)
		print("attempting to interact...")
	end,
})

while true do
	print("bound")
	interact:bind()

	task.wait(2)

	print("unbound")
	interact:unbind()

	task.wait(2)
end
