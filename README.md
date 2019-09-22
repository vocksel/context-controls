# ContextControls

Wrapper around ContextActionService that provides a clean API for creating and
binding actions, along with flexible mobile button support.

## Getting Started

```lua
local action = ContextControls.createAction({
    name = "foo",
    inputTypes = {
        Enum.KeyCode.E,
        Enum.KeyCode.ButtonX,
    },
    callback = function(input)
        print("Hello world!")
    end,
})

action:bind()
```

## API

**ContextControls.createAction(actionObject): Action**

Constructs an Action from a table of properties. This allows you to setup
everything, such as the name, callback, and input types, without having to call
any methods.

Most if not all properties of the Action class listed below can be used here.

```lua
local action = Action.fromObject({
	name = "foo",
	inputTypes = {
		Enum.KeyCode.E,
		Enum.UserInputType.MouseButton1,
	},
	callback = function()
		print("Hello, world!")
	end
})
```

## Action

This is the class that wraps around ContextActionService to provide a better API
to work with. Use one of the constructors to create one,

### Constructors

**new(name: string): Action**

Constructs an Action instance from a name. You then need to use the various
methods of this class to setup the callback, input types, and anything else
before binding.

```lua
local action = Action.new("foo")

action:setInputTypes({
	Enum.KeyCode.E,
	Enum.UserInputType.MouseButton1,
})

action:setCallback(function()
	print("Hello, world!")
end)
```

**fromObject(actionObject): Action**

Constructs an Action from a table of properties. This allows you to setup
everything, such as the name, callback, and input types, without having to call
any methods.

All properties listed below can be used here.

```lua
local action = Action.fromObject({
	name = "foo",
	inputTypes = {
		Enum.KeyCode.E,
		Enum.UserInputType.MouseButton1,
	},
	callback = function()
		print("Hello, world!")
	end
})
```

### Properties

**name: string**

The name of the action.

**callback: function**

The function that gets run when the action is triggered.

**inputTypes: Array<KeyCode|UserInputType|PlayerActions|string>**

The various input types that the action responds to.

**inputState: UserInputState (optional)**

A specific UserInputState that the callback responds to.

By default, the callback is called twice: once when the user starts interacting,
and again when they stop. This is because ContextActionService does not use
`InputBegan` or `InputEnd` events like UserInputService. It triggers the
callback for both, and leaves it up to the user to filter out the one they want.

Instead of having a to check `if input.UserInputState == Enum.UserInputState.Foo`
in your callback, you can simply set this property.

**mobileButton: GuiObject (optional)**

The mobile touch button that will allow the user

**priority: integer (optional)**

Sets the priority that ContextActionService will use for the action. By default
this is `Enum.ContextActionPriority.Default.Value`

**isBound: boolean (readonly)**

Whether or not the action is currently bound.

This is managed internally and should not be set from outside the class.

### Methods

**setCallback(callback: function): void**

Sets the callback for the action. This is what gets called when one of the input
types is activated by the user.

```lua
local action = Action.new("foo")

action:setCallback(function()
	print("Hello world!")
end)
```

**setInputTypes(inputTypes: Array<KeyCode|UserInputType|PlayerActions|string>): void**

Sets the input types that the action will be triggered for.

```lua
local action = Action.new("foo")

action:setInputTypes({
	Enum.KeyCode.E,
	Enum.KeyCode.ButtonX,
})
```

**bindAtPriority(priority: integer): void**

Binds the action at the given priority level. From here, any of the input types
being triggered will cause the callback to be run.

If the callback or input types are not set, this function will error.

If the function is already bound, it will error.

```lua
local action = Action.new("foo")
action:setCallback(...)
action:setInputTypes(...)

action:bindAtPriority(Enum.ContextActionPriority.High.Value)
```

**bind(): void**

**Binds the action using the default priority level
(`Enum.ContextActionPriority.Default.Value`). From here, any of the input types
being triggered will cause the callback to be run.

If the callback or input types are not set, this function will error.

If the function is already bound, it will error.

```lua
local action = Action.new("foo")
action:setCallback(...)
action:setInputTypes(...)

action:bind()
```

**unbind(): void**

Unbinds the action so that the callback will not be run when one of the input
types is triggered.

```lua
local action = Action.new("foo")
action:setCallback(...)
action:setInputTypes(...)

action:bind()

-- later
action:unbind()
```
