local Action = require(script.Action)
local types = require(script.types)

local function createAction(actionObject)
	assert(types.ActionObject(actionObject))
	return Action.fromObject(actionObject)
end

return createAction
