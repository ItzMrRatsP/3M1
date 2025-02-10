local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local EmilySubtitles = require(ReplicatedStorage.Global.Config.EmilySubtitles)
local Janitor = require(ReplicatedStorage.Packages.Janitor)
local NewSubtitle = require(script.Modules.NewSubtitle)
local Promise = require(ReplicatedStorage.Packages.Promise)

local janitor = Janitor.new()
local currentSound -- Store the currently playing sound
local currentName = nil

local Subtitle = {}

function Subtitle.playSubtitle(Name: string, Yield, Speed)
	local toPlay = EmilySubtitles.Config[Name]

	if not toPlay then
		return
	end

	if currentSound then
		print("there is a sound playing, cancel it")

		currentSound:Stop()
		janitor:Cleanup()
	end

	janitor:Add(NewSubtitle(toPlay.Text, Speed), "Destroy", Name)

	local Sound: Sound = toPlay.Audio
	currentSound = Sound
	currentSound.Volume = 0

	Sound:Play()

	local fadeIn = TweenService:Create(
		Sound,
		TweenInfo.new(1, Enum.EasingStyle.Linear),
		{ Volume = 1 }
	)

	fadeIn:Play()

	janitor:AddPromise(Promise.fromEvent(Sound.Ended, function()
		return true
	end)
		:andThen(function()
			task.wait(1)
			if currentName == Name then
				janitor:Cleanup()
			else
				janitor:Remove(Name)
			end
		end)
		:catch(warn))

	if Yield then
		task.wait(Sound.TimeLength)
	end
end

return Subtitle
