-- run-in-roblox does not play well with .server.lua files. As such, spec.lua is
-- passed off to run-in-roblox, and this script is mounted in dev.project.json
-- so that we can run tests in Studio.
require(script.spec)
