local ReplicatedStorage = game:GetService("ReplicatedStorage")

local TestEz = require(script.Parent.TestEz)

local TEST_LOCATIONS = {
	ReplicatedStorage,
}

TestEz.TestBootstrap:run(TEST_LOCATIONS, TestEz.Reporters.TextReporterQuiet)
