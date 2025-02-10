local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GameUtil = require(ReplicatedStorage.Global.Util.GameUtil)
local Subtitles = {}

Subtitles.Enums = GameUtil.arrtodict {
	"StartLVLOne",
	"CompleteLVLOne",
	"LVLFive_1",
	"LVLFive_2",
	"Intro",
	"Emily_LVLSix_employees",
	"Emily_LVLSix_just_through_here",
	"Emily_LVLSix_out_of_bounds",
	"Emily_LVLTwo_bridge",
	"Emily_LVLTwo_brain",
	"Emily_LVLThree_throw",
	"Emily_LVLThree_complete",
	"Emily_LVLFour_intro",
	"Emily_LVLSix_not_intentional",
	"Emily_LVLSix_whatshappening",
	"Emily_Control_Enter",
	"Emily_Avoid_Right",
	"Emily_LVLSeven_Section3",
	"Emily_LVLSeven_Section3.5",
	"Emily_Ending_Introduction",
	"Emily_BadEnding",
	"Emily_Reboot",
	"Emily_Shutdown",
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
	[Subtitles.Enums.Emily_LVLTwo_bridge] = {
		Text = "Oh, no... something is missing here. Where did I put that bridge...?",
		Audio = ReplicatedStorage.Assets.Sounds:FindFirstChild(
			"Emily_LVLTwo_bridge",
			true
		),
	},
	[Subtitles.Enums.Emily_LVLTwo_brain] = {
		Text = "You have a brain. Who knew!",
		Audio = ReplicatedStorage.Assets.Sounds:FindFirstChild(
			"Emily_LVLTwo_brain",
			true
		),
	},
	[Subtitles.Enums.Emily_LVLThree_throw] = {
		Text = "You'll need to throw something in this room. Surely you can handle that, right?",
		Audio = ReplicatedStorage.Assets.Sounds:FindFirstChild(
			"Emily_LVLThree_throw",
			true
		),
	},
	[Subtitles.Enums.Emily_LVLThree_complete] = {
		Text = "Good work. The next one won't be so easy.",
		Audio = ReplicatedStorage.Assets.Sounds:FindFirstChild(
			"Emily_LVLThree_complete",
			true
		),
	},
	[Subtitles.Enums.Emily_LVLSix_employees] = {
		Text = "You're KIDDING. God, the employees can't do ANYTHING right in this facility!",
		Audio = ReplicatedStorage.Assets.Sounds:FindFirstChild(
			"Emily_LVLSix_employees",
			true
		),
	},

	[Subtitles.Enums.Emily_LVLSix_just_through_here] = {
		Text = "Ah, here we are. Just through here, okay?",
		Audio = ReplicatedStorage.Assets.Sounds:FindFirstChild(
			"Emily_LVLSix_just_through_here",
			true
		),
	},
	[Subtitles.Enums.Emily_LVLSix_not_intentional] = {
		Text = "Wait, no. This wasn't intentional, was it? What is going on here?",
		Audio = ReplicatedStorage.Assets.Sounds:FindFirstChild(
			"Emily_LVLSix_not_intentional",
			true
		),
	},
	[Subtitles.Enums.Emily_LVLSix_whatshappening] = {
		Text = "What is happening?!",
		Audio = ReplicatedStorage.Assets.Sounds:FindFirstChild(
			"Emily_LVLSix_whatshappening",
			true
		),
	},
	[Subtitles.Enums.Emily_LVLFour_intro] = {
		Text = "Now you got two cubes! That shouldn't be an issue for you, Right?",
		Audio = ReplicatedStorage.Assets.Sounds:FindFirstChild(
			"Emily_LVLFour_intro",
			true
		),
	},

	[Subtitles.Enums.Emily_LVLSix_out_of_bounds] = {
		Text = "This portion of the room is normally inaccessible and 'out of bounds', as you might call it. I must request for you to remove that knowledge from your memory, otherwise I will be forced to do a mandatory, manual, memory wipe of this room from your brain. It will hurt. Make the right choice for me.",
		Audio = ReplicatedStorage.Assets.Sounds:FindFirstChild(
			"Emily_LVLSix_out_of_bounds",
			true
		),
	},

	[Subtitles.Enums.Emily_Avoid_Right] = {
		Text = "Ah, you see that door on the left labeled... eh... the 'Super Painful Death Door?' Yes, I'd like you to go through that one. ...The right door? The... oh. My control panel. Yes, avoid that one.",
		Audio = ReplicatedStorage.Assets.Sounds:FindFirstChild(
			"Emily_Avoid_Right",
			true
		),
	},

	[Subtitles.Enums.Emily_Control_Enter] = {
		Text = "No no no, don't...! Sigh... great, alright. What a shame it is that you subjects have free will.",
		Audio = ReplicatedStorage.Assets.Sounds:FindFirstChild(
			"Emily_Control_Enter",
			true
		),
	},

	[Subtitles.Enums.Emily_LVLSeven_Section3] = {
		Text = "You need the required Activation Key to open this. Or two cubes. You clearly don't have the cubes, so wait here while I fetch the Activation Key.",
		Audio = ReplicatedStorage.Assets.Sounds:FindFirstChild(
			"Emily_LVLSeven_Section3",
			true
		),
	},

	[Subtitles.Enums["Emily_LVLSeven_Section3.5"]] = {
		Text = "...Where the hell did you get those? Or find those?",
		Audio = ReplicatedStorage.Assets.Sounds:FindFirstChild(
			"Emily_LVLSeven_Section3.5",
			true
		),
	},

	[Subtitles.Enums.Emily_Ending_Introduction] = {
		Text = "God, this place is falling apart! I need you to shut me down. I won't be able to function soon at this rate, and I'd prefer for my death to at least be on my own terms... unless you don't have it in you to do so... I believe this is what I want. I think. I mean, it should just be... powering off, correct? Oh, what am I saying, you can't properly respond to me, can you? Just do it. I'm ready.",
		Audio = ReplicatedStorage.Assets.Sounds:FindFirstChild(
			"Emily_Ending_Introduction",
			true
		),
	},

	[Subtitles.Enums.Emily_Shutdown] = {
		Text = "Thank you.",
		Audio = ReplicatedStorage.Assets.Sounds:FindFirstChild(
			"Emily_Shutdown",
			true
		),
	},
} :: {
	Text: string,
	Audio: Sound,
}

return Subtitles
