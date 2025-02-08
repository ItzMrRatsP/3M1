local RunService = game:GetService("RunService")

local ContentProvider = game:GetService("ContentProvider")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local GameConfig = require(ReplicatedStorage.Global.Config.GameConfig)
local Global = require(ReplicatedStorage.Global)
local Janitor = require(ReplicatedStorage.Packages.Janitor)
local Promise = require(ReplicatedStorage.Packages.Promise)
local SignalWrapper = require(ReplicatedStorage.Shared.SignalWrapper)

local Assets = ReplicatedStorage:FindFirstChild("Assets")
local Logo = Assets:FindFirstChild("Logo")

local Camera = workspace.CurrentCamera

local OriginalLighting = {
	Ambient = Lighting.Ambient,
	EnvironmentDiffuseScale = Lighting.EnvironmentDiffuseScale,
	EnvironmentSpecularScale = Lighting.EnvironmentSpecularScale,
	Brightness = Lighting.Brightness,
	ClockTime = Lighting.ClockTime,
}

local function setBrightness(number: number, multi)
	for _, Object in Logo:GetDescendants() do
		if not Object:IsA("PointLight") and not Object:IsA("SpotLight") then
			continue
		end

		local Delay = Object:GetAttribute("Index") * 0.5 * multi

		local Info = TweenInfo.new(
			0.85,
			Enum.EasingStyle.Back,
			Enum.EasingDirection.InOut,
			0,
			false,
			Delay -- delay count
		)
		if Object:GetAttribute("Index") ~= 5 then
			task.delay(Delay, function()
				Global.GameUtil.playSound("Flicker")
			end)
		end

		TweenService:Create(Object, Info, { Brightness = number }):Play()
		Object:SetAttribute("Index", math.random(1, 3))
	end
end

return function(StateMachine)
	local State = StateMachine:AddState(script.Name)
	local janitor = Janitor.new()

	function State:Start() end

	function State:Enter()
		Logo.Parent = workspace
		ContentProvider:PreloadAsync(Logo:GetDescendants())

		Camera.CameraType = Enum.CameraType.Scriptable

		-- Lighting settings
		Lighting.Ambient = Color3.new(0, 0, 0)
		Lighting.EnvironmentDiffuseScale = 0
		Lighting.EnvironmentSpecularScale = 0
		Lighting.Brightness = 0
		Lighting.ClockTime = 1

		janitor:Add(function()
			ReplicatedStorage:SetAttribute("IntroFinished", true)
			Camera.CameraType = Enum.CameraType.Custom
		end)

		janitor
			:AddPromise(Promise.try(function()
				task.wait(1)
				setBrightness(0.35, 1)
			end)
				:andThen(function()
					task.wait(4)
					setBrightness(0, 0.5)
				end)
				:andThen(function()
					task.wait(2)
					janitor:Cleanup()
				end))
			:catch(warn)
	end

	function State:Update(dt)
		local Sin = math.sin(tick() * 2.5) / 10
		local Cos = math.cos(tick() * 2.5) / 10

		Camera.CFrame = Logo:FindFirstChild("Camera", true).CFrame
			* CFrame.new(Sin, Cos, 0)
	end

	function State:Exit()
		Camera.CameraType = Enum.CameraType.Custom

		Lighting.Ambient = OriginalLighting.Ambient
		Lighting.EnvironmentDiffuseScale =
			OriginalLighting.EnvironmentDiffuseScale
		Lighting.EnvironmentSpecularScale =
			OriginalLighting.EnvironmentSpecularScale
		Lighting.Brightness = OriginalLighting.Brightness
	end

	return State
end
