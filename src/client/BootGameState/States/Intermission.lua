local RunService = game:GetService("RunService")

local ContentProvider = game:GetService("ContentProvider")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Character = require(ReplicatedStorage.Client.BootGameState.Character)
local Global = require(ReplicatedStorage.Global)
local Janitor = require(ReplicatedStorage.Packages.Janitor)
local Subtitles = require(ReplicatedStorage.Client.Subtitles)

local SignalWrapper = require(ReplicatedStorage.Shared.SignalWrapper)

local Camera = workspace.CurrentCamera

local CameraCutsceneRig = ReplicatedStorage.Assets.Rigs.WakeupCutsceneRig
local CameraCutsceneAnimation =
	ReplicatedStorage.Assets.Animations.CameraCutsceneAnimation

local Connected = true

local function Setup()
	CameraCutsceneRig.Parent = workspace
	Global.Character.Root.Anchored = true
	CameraCutsceneRig:PivotTo(
		Global.Character.Root.CFrame
			* CFrame.new(0, -2, -0.2)
			* CFrame.Angles(0, math.rad(180), 0)
	)

	local CameraCutsceneTrack: AnimationTrack =
		CameraCutsceneRig.Humanoid:LoadAnimation(CameraCutsceneAnimation)

	repeat
		task.wait()
	until CameraCutsceneTrack.Length > 0
	print("Working")
	CameraCutsceneTrack.Looped = false
	CameraCutsceneTrack:Play()

	task.wait(0.5)

	ReplicatedStorage:SetAttribute("StartLoading", false)
	CameraCutsceneTrack.Stopped:Connect(function()
		Connected = false
		Global.Character.Root.AssemblyLinearVelocity = Vector3.zero
		Global.Character.Root.Anchored = false
	end)
end

return function(StateMachine)
	local State = StateMachine:AddState(script.Name)
	local janitor = Janitor.new()

	function State:Start() end

	function State:Enter()
		repeat
			task.wait()
		until Global.Character ~= nil

		Subtitles.playSubtitle("Intro")
		Setup()
	end

	function State:Update(dt)
		if Connected then
			CameraCutsceneRig.Torso.CanCollide = false
			Camera.CFrame = CameraCutsceneRig.Torso.CFrame
		end
	end

	function State:Exit() end

	return State
end
