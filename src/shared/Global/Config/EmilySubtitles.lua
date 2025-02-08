local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GameUtil = require(ReplicatedStorage.Global.Util.GameUtil)
local Subtitles = {}

Subtitles.Enums = GameUtil.arrtodict { "Softlock", "Move", "Waitting", "Intro" }

Subtitles.Config = {
	[Subtitles.Enums.Softlock] = {
		Text = "Is that a softlock?",
		Audio = ReplicatedStorage.Assets.Sounds:FindFirstChild(
			"Emily_SoftLock",
			true
		),
	},

	[Subtitles.Enums.Move] = {
		Text = "Did you just move?!",
		Audio = ReplicatedStorage.Assets.Sounds:FindFirstChild(
			"Emily_Move",
			true
		),
	},

	[Subtitles.Enums.Waitting] = {
		Text = "...",
		Audio = ReplicatedStorage.Assets.Sounds:FindFirstChild(
			"Emily_Waitting",
			true
		),
	},

	[Subtitles.Enums.Intro] = {
		Text = "Hey, good morning! You've been asleep for 9-9-9-9-9-9... uh, it-it's not important, anyway-I'm here to get you out of here. Just follow my voice, or more accurately, my instructions, and you'll be home free in no time.",
		Audio = ReplicatedStorage.Assets.Sounds:FindFirstChild(
			"Emily_Intro",
			true
		),
	},
} :: {
	Text: string,
	Audio: Sound,
}

return Subtitles
