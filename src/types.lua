local t = require(script.Parent.t)

local types = {}
export type InputTypes = { Enum.KeyCode | Enum.UserInputType | Enum.PlayerActions | string }

types.InputType = t.union(t.enum(Enum.KeyCode), t.enum(Enum.UserInputType), t.enum(Enum.PlayerActions), t.string)

export type ActionObject = {
	name: string?,
	priority: Enum.ContextActionPriority?,
	inputState: Enum.UserInputState?,
	inputTypes: { Enum.UserInputType }?,
	callback: ((InputObject) -> nil)?,
}

types.ActionObject = t.interface({
	name = t.string,
	inputTypes = t.optional(t.array(types.InputType)),
	callback = t.optional(t.callback),
	priority = t.optional(t.integer),
	inputState = t.optional(t.enum(Enum.UserInputState)),
})

types.ActionPriority = t.union(t.enum(Enum.ContextActionPriority), t.integer)

return types
