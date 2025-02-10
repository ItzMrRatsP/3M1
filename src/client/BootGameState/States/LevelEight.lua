local CollectionService = game:GetService("CollectionService")
local ContentProvider = game:GetService("ContentProvider")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local Fusion = require(ReplicatedStorage.Packages.Fusion)
local Global = require(ReplicatedStorage.Global)
local Janitor = require(ReplicatedStorage.Packages.Janitor)
local LightingPresets = require(ReplicatedStorage.Client.LightingPresets)
local SignalWrapper = require(ReplicatedStorage.Shared.SignalWrapper)
local Subtitles = require(ReplicatedStorage.Client.Subtitles)
local Zones = require(ReplicatedStorage.Shared.Zones)

local ActiveMap = workspace:WaitForChild("ActiveMap")
local Scoped = Fusion.scoped(Fusion)

local Children = Fusion.Children

local function fadeToWhite()
	local Value = Scoped:Value(false)

	Scoped:New("ScreenGui") {
		Parent = Players.LocalPlayer.PlayerGui,
		IgnoreGuiInset = true,
		DisplayOrder = 999,

		[Children] = Scoped:New("Frame") {
			Size = UDim2.fromScale(1, 1),

			BackgroundColor3 = Color3.new(1, 1, 1),
			BackgroundTransparency = Scoped:Spring(
				Scoped:Computed(function(Peek)
					return Peek(Value) and 0 or 1
				end),

				5,
				0.85
			),
		},
	}

	return Value
end

return function(StateMachine)
	local State = StateMachine:AddState(script.Name)
	local janitor = Janitor.new()

	function State:Enter()
		-- Last level
		local Level = ActiveMap["LevelEight"]
		local BoomBox = Level.LevelRelated:FindFirstChild("BoomBox")
		local ExitDoor = Level.LevelRelated:FindFirstChild("EntryDoor")
		local EmilyDoor = Level.LevelRelated:FindFirstChild("EmilyDoor")

		local BoomHolder = Level.LevelRelated:FindFirstChild("BoomHolder")
		ExitDoor:SetAttribute("Locked", true)
		ExitDoor:SetAttribute("Active", false)

		local PlayedOnce = false
		local Fade = fadeToWhite()

		EmilyDoor:GetAttributeChangedSignal("PlayerActive")
			:Connect(function()
				if PlayedOnce then
					return
				end

				PlayedOnce = true

				Subtitles.playSubtitle(
					"Emily_Ending_Introduction",
					false,
					1.5
				)
			end)

		local BoomBoomZone =
			Zones.new(Level.LevelRelated:FindFirstChild("BoomZone"))

		BoomBoomZone:trackItem(BoomBox.Grabbable)

		BoomBoomZone.itemEntered:Connect(function()
			Global.Character.PhysicsGrabHandler:Unhold()
			local targetCFrame = BoomHolder.CFrame
				* CFrame.Angles(0, math.rad(90), 0)
			local tweenInfo = TweenInfo.new(
				1,
				Enum.EasingStyle.Quad,
				Enum.EasingDirection.Out
			)

			local tween = TweenService:Create(
				BoomBox.Grabbable,
				tweenInfo,
				{ CFrame = targetCFrame }
			)

			BoomBox.Grabbable.Anchored = true
			tween:Play()

			SignalWrapper:Get("SetMainVolume"):Fire(0)

			Global.GameUtil.playSound("ChargeUp")
			Subtitles.playSubtitle("Emily_Shutdown", false, 1)

			Global.Character.CameraHandler.shaking = true
			Global.Character.CameraHandler.intensity = 8
			Global.Character.CameraHandler.enabled = false

			task.delay(9, function()
				Fade:set(true)
				task.wait(3)
				Fade:set(false)
				SignalWrapper:Get("CreditScreen"):Fire(true)
			end)

			-- for _, Effect in Emily:GetDescendants() do
			-- 	if not Effect:IsA("ParticleEffect") then
			-- 		continue
			-- 	end

			-- 	Effect.Enabled = true
			-- end
		end)
	end

	function State:Start() end

	function State:Update() end

	function State:Exit()
		janitor:Cleanup()
	end

	return State
end
