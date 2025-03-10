local RunService = game:GetService("RunService")

local ContentProvider = game:GetService("ContentProvider")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Character = require(ReplicatedStorage.Client.BootGameState.Character)
local Global = require(ReplicatedStorage.Global)
local Janitor = require(ReplicatedStorage.Packages.Janitor)
local LightingPresets = require(ReplicatedStorage.Client.LightingPresets)
local Subtitles = require(ReplicatedStorage.Client.Subtitles)

local Zone = require(ReplicatedStorage.Shared.Zones)

local SignalWrapper = require(ReplicatedStorage.Shared.SignalWrapper)

local Camera = workspace.CurrentCamera

local ActiveMap = workspace:WaitForChild("ActiveMap")

local CameraCutsceneRig = ReplicatedStorage.Assets.Rigs.WakeupCutsceneRig
local CameraCutsceneAnimation =
	ReplicatedStorage.Assets.Animations.CameraCutsceneAnimation

local Connected = true

return function(StateMachine)
	local State = StateMachine:AddState(script.Name)
	local janitor = Janitor.new()

	function State:Start() end

	function State:Enter()
		repeat
			task.wait()
		until Global.Character ~= nil

		local Noises: Sound =
			ReplicatedStorage.Assets.Sounds:FindFirstChild("Noise")

		CameraCutsceneRig.Parent = workspace
		Global.Character.Root.Anchored = true
		CameraCutsceneRig:PivotTo(
			Global.Character.Root.CFrame
				* CFrame.new(0, -2, -0.2)
				* CFrame.Angles(0, math.rad(180), 0)
		)

		local CameraCutsceneTrack: AnimationTrack =
			CameraCutsceneRig.Humanoid:LoadAnimation(
				CameraCutsceneAnimation
			)

		repeat
			task.wait()
		until CameraCutsceneTrack.Length > 0 and Noises.TimeLength > 0

		CameraCutsceneTrack.Looped = false
		Noises:Play()
		CameraCutsceneTrack:Play()

		task.wait(0.5)
		ReplicatedStorage:SetAttribute("StartLoading", false)

		CameraCutsceneTrack.Stopped:Connect(function()
			Connected = false
			Global.Character.Root.AssemblyLinearVelocity = Vector3.zero
			Global.Character.Root.Anchored = false

			task.wait(0.5)
			Subtitles.playSubtitle("Intro", true)
			task.wait(2)
			ActiveMap["Intermission"].Assets.SlidingDoor:SetAttribute(
				"Active",
				true
			)

			local zone = Zone.new(
				ActiveMap["LevelOne"].LevelRelated.LevelOneTrigger
			)

			self.ConnectionZone = zone.playerEntered:Connect(
				function(player)
					StateMachine:Transition(StateMachine.LevelOne)
					Subtitles.playSubtitle("StartLVLOne", false, 2)

					task.delay(3, function()
						SignalWrapper:Get("removePreviousLevel")
							:Fire("LevelOne")
					end)
				end
			)
		end)
	end

	function State:Update(dt)
		if Connected then
			CameraCutsceneRig.Torso.CanCollide = false
			Camera.CFrame = CameraCutsceneRig.Torso.CFrame
		end
	end

	function State:Exit()
		if self.ConnectionZone then
			self.ConnectionZone:Disconnect()
		end
	end

	return State
end
