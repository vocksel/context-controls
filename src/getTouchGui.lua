local Players = game:GetService("Players")

--[=[
	Returns the LocalPlayer's TouchGui if they are on a touch enabled device, nil otherwise.

	```lua
	local touchGui = ContextControls.getTouchGui()
	print(touchGui:GetFullName()) -- Players.Player1.PlayerGui.TouchGui
	```

	@within ContextControls
	@yields
	@client
]=]
local function getTouchGui(): GuiObject?
	local playerModule = require(Players.LocalPlayer.PlayerScripts:WaitForChild("PlayerModule"))
	local controls = playerModule:GetControls()
	return controls.touchGui
end

return getTouchGui
