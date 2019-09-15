local Action = require(script.Parent.Action)
local types = require(script.Parent.types)

local function createAction(actionObject)
	assert(types.ActionObject(actionObject))
	return Action.fromObject(actionObject)
end

return createAction
