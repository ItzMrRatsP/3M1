local RunService = game:GetService("RunService")

local ContentProvider = game:GetService("ContentProvider")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Character = require(ReplicatedStorage.Client.BootGameState.Character)
local Global = require(ReplicatedStorage.Global)
local Janitor = require(ReplicatedStorage.Packages.Janitor)
local Subtitles = require(ReplicatedStorage.Client.Subtitles)

local ZonePlus = require(ReplicatedStorage.Modules.Zone)

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
			
			task.wait(0.5)
			Subtitles.playSubtitle("Intro", true)
			task.wait(2)
			ActiveMap["Intermission"].Assets.SlidingDoor:SetAttribute("Active", true)
		
			local zone = ZonePlus.new(ActiveMap["LevelOne"].LevelRelated.LevelOneTrigger)
			print(zone)
		
			zone.playerEntered:Connect(function(player)
				StateMachine:Transition(StateMachine.LevelOne)
				print(("%s entered the zone!"):format(player.Name))
			end)
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
