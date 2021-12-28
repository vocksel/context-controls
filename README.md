# ContextControls

[![CI](https://github.com/vocksel/context-controls/actions/workflows/ci.yml/badge.svg)](https://github.com/vocksel/context-controls/actions/workflows/ci.yml)
[![Docs](https://img.shields.io/badge/docs-website-brightgreen)](https://vocksel.github.io/context-controls)


Wrapper around ContextActionService that provides a clean API for creating and
binding actions.

## Usage

```lua
local ContextControls = require(game.ReplicatedStorage.ContextControls)

local action = ContextControls.createAction({
    name = "foo",
    inputTypes = {
        Enum.KeyCode.E,
        Enum.KeyCode.ButtonX,
    },
    callback = function(input: InputObject)
        print("Hello world!")
    end,
})

action:bind()
```

## Installation

### Wally

Add the following to your `wally.toml`:

```
[dependencies]
ContextControls = "vocksel/context-controls@1.0.1
```

### Model File

* Download a copy of the rbxm from the [releases page](https://github.com/vocksel/context-controls/releases/latest) under the Assets section.
* Drag and drop the file into Roblox Studio to add it to your experience.

## Documentation

You can find the documentation [here](https://vocksel.github.io/context-controls).

## Contributing

See the [contributing guide](https://vocksel.github.io/context-controls/docs/contributing).

## License

[MIT License](LICENSE)
