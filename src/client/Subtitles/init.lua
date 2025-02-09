local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local EmilySubtitles = require(ReplicatedStorage.Global.Config.EmilySubtitles)
local Janitor = require(ReplicatedStorage.Packages.Janitor)
local NewSubtitle = require(script.Modules.NewSubtitle)
local Promise = require(ReplicatedStorage.Packages.Promise)

local janitor = Janitor.new()

local Subtitle = {}

function Subtitle.playSubtitle(Name: string, Yield)
	-- TODO: Play subtitle with the voice
	local toPlay = EmilySubtitles.Config[Name]

	if not toPlay then
		return
	end

	janitor:Add(NewSubtitle(toPlay.Text))

	local Sound: Sound = toPlay.Audio
	Sound.Volume = 0
	Sound:Play()

	TweenService
		:Create(
			Sound,
			TweenInfo.new(1, Enum.EasingStyle.Linear),
			{ Volume = 1 }
		)
		:Play()

	janitor:Add(function()
		TweenService:Create(
			Sound,
			TweenInfo.new(1, Enum.EasingStyle.Linear),
			{ Volume = 0 }
		):Play()
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
