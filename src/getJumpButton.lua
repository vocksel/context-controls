local Players = game:GetService("Players")

--[=[
	Returns the LocalPlayer's JumpButton if they are on a touch enabled device, nil otherwise.

	```lua
	local jumpButton = ContextControls.getJumpButton()
	print(jumpButton:GetFullName()) -- ...TouchGui.TouchControlFrame.JumpButton
	```

	@within ContextControls
	@yields
	@client
]=]
local function getJumpButton(): GuiObject?
	local playerModule = require(Players.LocalPlayer.PlayerScripts:WaitForChild("PlayerModule"))
	local controls = playerModule:GetControls()
	local touchJumpController = controls.touchJumpController

	if touchJumpController then
		return touchJumpController.jumpButton
	end
end

return getJumpButton
