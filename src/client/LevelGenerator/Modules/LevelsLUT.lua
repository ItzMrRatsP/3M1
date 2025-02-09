local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Global = require(ReplicatedStorage.Global)

local Maps = ReplicatedStorage.Assets.Maps

local Levels = {}

Levels.OrderedIndex = Global.GameUtil.arrtodictsorted {
	"Intermission",
	"LevelOne",
	"LevelTwo"
}

Levels.IndexedLevel = {
	[Levels.OrderedIndex.Intermission] = "Intermission",
	[Levels.OrderedIndex.LevelOne] = "LevelOne",
	[Levels.OrderedIndex.LevelTwo] = "LevelTwo",
}

Levels.Config = {
	[Levels.OrderedIndex.Intermission] = {
		Map = Maps:FindFirstChild("Intermission"),
		HasEntrance = false,
	},

	[Levels.OrderedIndex.LevelOne] = {
		Map = Maps:FindFirstChild("LevelOne"),
		HasEntrance = true,
	},

	[Levels.OrderedIndex.LevelTwo] = {
		Map = Maps:FindFirstChild("LevelTwo"),
		HasEntrance = true,
	},

} :: {
	[number]: {
		Map: Folder,
		HasEntrance: boolean, -- Checks if it have entrance or not
	},
}

return Levels
