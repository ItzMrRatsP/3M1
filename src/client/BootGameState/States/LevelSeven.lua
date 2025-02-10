local CollectionService = game:GetService("CollectionService")
local ContentProvider = game:GetService("ContentProvider")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local CameraShaker = require(ReplicatedStorage.Shared.CameraShaker)
local Global = require(ReplicatedStorage.Global)
local Janitor = require(ReplicatedStorage.Packages.Janitor)
local SignalWrapper = require(ReplicatedStorage.Shared.SignalWrapper)
local Subtitles = require(ReplicatedStorage.Client.Subtitles)
local Zones = require(ReplicatedStorage.Shared.Zones)

local Camera = workspace.CurrentCamera

local CameraShake = CameraShaker.new(
	Enum.RenderPriority.Last.Value,
	function(CF)
		Camera.CFrame = Camera.CFrame * CF
	end
)

local shakeIntensity = 2.9 -- Adjust this value to control the intensity of the shake
local shakeSpeed = 8

local ActiveMap = workspace:WaitForChild("ActiveMap")

return function(StateMachine)
	local State = StateMachine:AddState(script.Name)
	local janitor = Janitor.new()

	function State:Enter()
		local ActivatedZone = false
		local ActivatedEmiDoor = false
		local Opened = false
		local Level = ActiveMap["LevelSeven"]

		SignalWrapper:Get("generateLevel"):Fire()

		local ExitDoor = Level.LevelRelated.L1:FindFirstChild("SlidingDoor")
		local EmiDoor = Level.LevelRelated:FindFirstChild("EmiDoor")

		local Button1 = Level.LevelRelated.L1:FindFirstChild("Button1")
		local Button2 = Level.LevelRelated.L1:FindFirstChild("Button2")

		local DidOnce = false

		local function JointButtonPressed()
			if
				Button1:GetAttribute("Active")
				and Button2:GetAttribute("Active")
			then
				if not DidOnce then
					DidOnce = true
					Subtitles.playSubtitle(
						"Emily_LVLSeven_Section3.5",
						false,
						1.5
					)
				end

				ExitDoor:SetAttribute("Active", true)
			else
				ExitDoor:SetAttribute("Active", false)
			end
		end

		local function OpenedEmiDoor()
			if ActivatedEmiDoor then
				return
			end

			ActivatedEmiDoor = true
			Subtitles.playSubtitle("Emily_Control_Enter")
		end

		Button1:GetAttributeChangedSignal("Active")
			:Connect(JointButtonPressed)
		Button2:GetAttributeChangedSignal("Active")
			:Connect(JointButtonPressed)

		EmiDoor:GetAttributeChangedSignal("PlayerActive")
			:Connect(OpenedEmiDoor)

		local BigEntryDoor =
			Level.LevelRelated:FindFirstChild("BigEntryDoor")

		local BigDoorButton =
			Level.LevelRelated:FindFirstChild("BigDoorButton")

		local zone = Zones.new(Level.LevelRelated.L2:FindFirstChild("Zone"))

		local FinalZone = Zones.new(
			ActiveMap["LevelEight"].LevelRelated:FindFirstChild("Zone")
		)

		local gainAccessZone =
			Zones.new(Level.LevelRelated.L2:FindFirstChild("GainAccess"))

		local alreadyStated = false

		janitor:Add(
			FinalZone.playerEntered:Connect(function()
				StateMachine:Transition(StateMachine.LevelEight)
			end),

			"Disconnect"
		)

		janitor:Add(
			gainAccessZone.playerEntered:Connect(function()
				if alreadyStated then
					return
				end

				alreadyStated = true
				Subtitles.playSubtitle(
					"Emily_LVLSeven_Section3",
					false,
					1.5
				)
			end),

			"Disconnect"
		)

		janitor:Add(
			zone.playerEntered:Connect(function()
				if ActivatedZone then
					return
				end

				ActivatedZone = true
				Subtitles.playSubtitle("Emily_Avoid_Right")
			end),

			"Disconnect"
		)

		BigDoorButton:GetAttributeChangedSignal("Active"):Connect(function()
			if not BigDoorButton:GetAttribute("Active") then
				return
			end

			if Opened then
				return
			end

			Opened = true

			task.spawn(function()
				Global.GameUtil.playSound("Siren")
				task.wait(2)
				Global.GameUtil.playSound("Siren")
				task.wait(2)
				Global.GameUtil.playSound("Siren")
				task.wait(2)
				Global.GameUtil.playSound("Siren")
				task.wait(2)
			end)

			Global.Character.CameraHandler.shaking = true
			Global.Character.CameraHandler.intensity = shakeIntensity

			Global.Character.CameraHandler.enabled = false

			task.wait(3)

			-- We unlock the door
			TweenService:Create(
				BigEntryDoor.Side1,
				TweenInfo.new(8, Enum.EasingStyle.Linear),
				{
					CFrame = BigEntryDoor.Side1.CFrame
						* CFrame.new(0, 0, -15),
				}
			):Play()

			local tween = TweenService:Create(
				BigEntryDoor.Side2,
				TweenInfo.new(8, Enum.EasingStyle.Linear),
				{
					CFrame = BigEntryDoor.Side2.CFrame
						* CFrame.new(0, 0, 15),
				}
			)

			tween:Play()

			tween.Completed:Once(function()
				Global.Character.CameraHandler.enabled = true
				Global.Character.CameraHandler.shaking = false

				CameraShake:Stop()
			end)
		end)
	end

	function State:Start() end

	function State:Update() end

	function State:Exit()
		janitor:Cleanup()
	end

	return State
end
