local t = require(script.Parent.t)

local types = {}

types.InputType = t.union(
	t.enum(Enum.KeyCode),
	t.enum(Enum.UserInputType),
	t.string
)

types.ActionObject = t.interface({
	name = t.string,
	inputTypes = t.optional(t.array(types.InputType)),
	callback = t.optional(t.callback),
	priority = t.optional(t.integer),
	inputState = t.optional(t.enum(Enum.UserInputState)),
	mobileButton = t.optional(t.Instance),
})

types.ActionPriority = t.union(
	t.enum(Enum.ContextActionPriority),
	t.integer
)

return types
