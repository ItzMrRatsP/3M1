local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local EmilySubtitles = require(ReplicatedStorage.Global.Config.EmilySubtitles)
local Janitor = require(ReplicatedStorage.Packages.Janitor)
local NewSubtitle = require(script.Modules.NewSubtitle)
local Promise = require(ReplicatedStorage.Packages.Promise)

local janitor = Janitor.new()
local currentSound -- Store the currently playing sound

local Subtitle = {}

function Subtitle.playSubtitle(Name: string, Yield, Speed)
	janitor:Cleanup()

	local toPlay = EmilySubtitles.Config[Name]

	if not toPlay then
		return
	end

	janitor:Add(NewSubtitle(toPlay.Text, Speed))

	local Sound: Sound = toPlay.Audio

	if currentSound and currentSound.IsPlaying then
		currentSound:Stop()
	end

	currentSound = Sound
	Sound.Volume = 0
	Sound:Play()

	local fadeIn = TweenService:Create(
		Sound,
		TweenInfo.new(1, Enum.EasingStyle.Linear),
		{ Volume = 1 }
	)
	fadeIn:Play()

	janitor:Add(function()
		local fadeOut = TweenService:Create(
			Sound,
			TweenInfo.new(1, Enum.EasingStyle.Linear),
			{ Volume = 0 }
		)
		fadeOut:Play()
		task.wait(1)
		Sound:Stop()
	end)

	janitor:AddPromise(Promise.fromEvent(Sound.Ended, function()
		return true
	end)
		:andThen(function()
			task.wait(2)
			janitor:Cleanup()
		end)
		:catch(warn))

	if Yield then
		task.wait(Sound.TimeLength)
	end
end

return Subtitle
