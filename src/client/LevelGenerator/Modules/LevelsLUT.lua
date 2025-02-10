local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Global = require(ReplicatedStorage.Global)

local Maps = ReplicatedStorage.Assets.Maps

local Levels = {}

Levels.OrderedIndex = Global.GameUtil.arrtodictsorted {
	"Intermission",
	"LevelOne",
	"LevelTwo",
	"LevelThree",
	"LevelFour",
	"LevelFive",
	"LevelSix",
}

Levels.IndexedLevel = {
	[Levels.OrderedIndex.Intermission] = "Intermission",
	[Levels.OrderedIndex.LevelOne] = "LevelOne",
	[Levels.OrderedIndex.LevelTwo] = "LevelTwo",
	[Levels.OrderedIndex.LevelThree] = "LevelThree",
	[Levels.OrderedIndex.LevelFour] = "LevelFour",
	[Levels.OrderedIndex.LevelFive] = "LevelFive",
	[Levels.OrderedIndex.LevelSix] = "LevelSix",
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

	[Levels.OrderedIndex.LevelThree] = {
		Map = Maps:FindFirstChild("LevelThree"),
		HasEntrance = true,
	},

	[Levels.OrderedIndex.LevelFour] = {
		Map = Maps:FindFirstChild("LevelFour"),
		HasEntrance = true,
	},

	[Levels.OrderedIndex.LevelFive] = {
		Map = Maps:FindFirstChild("LevelFive"),
		HasEntrance = true,
	},

	[Levels.OrderedIndex.LevelSix] = {
		Map = Maps:FindFirstChild("LevelSix"),
		HasEntrance = true,
	},
} :: {
	[number]: {
		Map: Folder,
		HasEntrance: boolean, -- Checks if it have entrance or not
	},
}

return Levels
