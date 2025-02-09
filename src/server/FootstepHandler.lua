-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

-- Variables
local Global = require(ReplicatedStorage.Global)
local Janitor = require(ReplicatedStorage.Packages.Janitor)
local Promise = require(ReplicatedStorage.Packages.Promise)

local Assets = ReplicatedStorage.Assets
local FootstepSounds = Assets.Sounds.Footstep

function cast(playerCharacter)
	local params = RaycastParams.new()
	params.FilterType = Enum.RaycastFilterType.Exclude
	params.FilterDescendantsInstances = { playerCharacter }

	local humanoidRootPart =
		playerCharacter:FindFirstChild("HumanoidRootPart")
	local origin = humanoidRootPart.Position
	local direction = -(humanoidRootPart.CFrame.UpVector * 35) -- Minus 30 stud lower than hmrpt.

	local ray = workspace:Raycast(origin, direction, params)

	if not ray then
		return
	end

	local instance = ray.Instance
	local material = instance.Material

	return material.Name
end

local function playerCharacterAdded(Character)
	local janitor = Janitor.new()
	local canPlay = true
	local humanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
	local humanoid = Character:FindFirstChild("Humanoid")
	local currentSoundIndex = 1
	local footstepSounds = FootstepSounds:GetChildren()

	janitor:Add(RunService.Heartbeat:Connect(function()
		if humanoidRootPart.Anchored then
			return
		end

		if humanoid.MoveDirection.Magnitude <= 0 then
			return
		end

		local material = cast(Character)

		if not material then
			return
		end

		if not canPlay then
			return
		end

		local Sound = janitor:Add(footstepSounds[currentSoundIndex]:Clone())
		Sound.Name = "Walk"
		Sound.Parent = humanoidRootPart

		local Normal = humanoid.WalkSpeed / 10
		local Equalizer = 2 -- Normal Equalizer

		local PitchShift = (Normal / Equalizer)
		local OctaveShift = (Normal * Equalizer)

		Sound.PlaybackSpeed = PitchShift

		local PitchShiftSoundEffect =
			janitor:Add(Instance.new("PitchShiftSoundEffect"))
		PitchShiftSoundEffect.Octave = OctaveShift
		PitchShiftSoundEffect.Parent = Sound

		if currentSoundIndex % #footstepSounds == 0 then
			currentSoundIndex = 1
		else
			currentSoundIndex += 1
		end

		Sound:Play()
		canPlay = false

		Promise.fromEvent(Sound.Ended, function()
			Sound:Destroy()

			task.delay(
				0.5,
				function() -- wait 0.5 second before removing the sound.
					canPlay = true
				end
			)

			return true
		end)
	end))

	janitor:Add(humanoid.Died:Connect(function()
		return janitor:Cleanup()
	end))
end

local function boot()
	for _, Player in Players:GetPlayers() do
		if not Player.Character then
			continue
		end

		playerCharacterAdded(Player.Character)
	end

	Players.PlayerAdded:Connect(function(Player)
		Player.CharacterAdded:Connect(playerCharacterAdded)
	end)
end

return Global.Schedule:Add(boot)
