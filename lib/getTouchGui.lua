local Players = game:GetService("Players")

local function getTouchGui()
	local playerModule = require(Players.LocalPlayer.PlayerScripts:WaitForChild("PlayerModule"))
	local controls = playerModule:GetControls()
	return controls.touchGui
end

return getTouchGui
