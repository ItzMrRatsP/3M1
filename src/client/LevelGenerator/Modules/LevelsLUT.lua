local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Global = require(ReplicatedStorage.Global)

local Maps = ReplicatedStorage.Assets.Maps

local Levels = {}

Levels.OrderedIndex = Global.GameUtil.arrtodictsorted {
	"Intermission",
	"LevelOne",
}

Levels.IndexedLevel = {
	[Levels.OrderedIndex.Intermission] = "Intermission",
	[Levels.OrderedIndex.LevelOne] = "LevelOne",
}

Levels.Config = {
	[Levels.OrderedIndex.Intermission] = {
		Map = Maps:FindFirstChild("Intermission"),
		-- Add more configs
	},

	[Levels.OrderedIndex.LevelOne] = {
		Map = Maps:FindFirstChild("LevelOne"),
	},
} :: {
	[number]: {
		Map: Folder,
	},
}

return Levels
