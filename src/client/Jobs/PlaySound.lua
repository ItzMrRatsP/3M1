local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local Global = require(ReplicatedStorage.Global)
local Janitor = require(ReplicatedStorage.Packages.Janitor)
local Promise = require(ReplicatedStorage.Packages.Promise)
local SignalWrapper = require(ReplicatedStorage.Shared.SignalWrapper)

local janitor = Janitor.new()

local setVolumeEvent = SignalWrapper:Get("SetMainVolume")

local Sound: Sound = ReplicatedStorage.Assets.Sounds:FindFirstChild("Electro")
Sound.Volume = 0

local function boot()
	setVolumeEvent:Connect(function(new)
		TweenService:Create(
			Sound,
			TweenInfo.new(1, Enum.EasingStyle.Linear),
			{ Volume = new }
		):Play()
	end)

	local Tween = TweenService:Create(
		Sound,
		TweenInfo.new(1, Enum.EasingStyle.Linear),
		{ Volume = 0.35 }
	)

	Sound:Play()
	Tween:Play()

	janitor:AddPromise(Promise.fromEvent(Sound.Ended, function()
		return true
	end)
		:andThen(function()
			task.wait(2)
			Sound:Play()
		end)
		:catch(warn))
end

return Global.Schedule:Add(boot)
