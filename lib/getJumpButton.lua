local Players = game:GetService("Players")

local function getJumpButton()
	local playerModule = require(Players.LocalPlayer.PlayerScripts:WaitForChild("PlayerModule"))
	local controls = playerModule:GetControls()
	local touchJumpController = controls.touchJumpController

	if touchJumpController then
		return touchJumpController.jumpButton
	end
end

return getJumpButton
