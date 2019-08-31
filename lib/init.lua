local Action = require(script.Action)
local types = require(script.types)

local contextControls = {}

local createActionCheck = types.ActionObject
function contextControls.createAction(actionObject)
	assert(createActionCheck(actionObject))

	local action = Action.fromObject(actionObject)

	return action
end

return contextControls
