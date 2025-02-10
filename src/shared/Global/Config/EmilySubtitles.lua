local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GameUtil = require(ReplicatedStorage.Global.Util.GameUtil)
local Subtitles = {}

Subtitles.Enums = GameUtil.arrtodict {
	"StartLVLOne",
	"CompleteLVLOne",
	"LVLFive_1",
	"LVLFive_2",
	"Intro",
}

Subtitles.Config = {
	[Subtitles.Enums.StartLVLOne] = {
		Text = "Ooh, this is going to be the easiest room you see today. I'd say 'good luck', but you don't need that, do you? I'm serious, this room is idiot-proof.",
		Audio = ReplicatedStorage.Assets.Sounds:FindFirstChild(
			"Emily_LVLOne_Start",
			true
		),
	},

	[Subtitles.Enums.CompleteLVLOne] = {
		Text = "Congratulations on beating the first level. See you in the next room.",
		Audio = ReplicatedStorage.Assets.Sounds:FindFirstChild(
			"Emily_LVLOne_Complete",
			true
		),
	},

	[Subtitles.Enums.LVLFive_2] = {
		Text = "...Ah. I don't recall it being that old. My apologies.",
		Audio = ReplicatedStorage.Assets.Sounds:FindFirstChild(
			"Emily_LVLFive_2",
			true
		),
	},

	[Subtitles.Enums.LVLFive_1] = {
		Text = "This is one of the older rooms in our facility.",
		Audio = ReplicatedStorage.Assets.Sounds:FindFirstChild(
			"Emily_LVLFive_1",
			true
		),
	},

	[Subtitles.Enums.Intro] = {
		Text = "Hey, good morning! You've been asleep for-for-uh... it-it's not important! Anyway, I'm here to get you out of here. Just follow my voice, or more accurately, my instructions, and you'll be home free in no time.",
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
