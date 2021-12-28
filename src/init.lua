--[=[
	@class ContextControls

	ContextControls provides a wrapper around `ContextActionService` that offers
	a cleaner API for creating and binding actions.
]=]

return {
	Action = require(script.Action),
	createAction = require(script.createAction),
	getTouchGui = require(script.getTouchGui),
	getJumpButton = require(script.getJumpButton),
}
