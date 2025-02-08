local ContentProvider = game:GetService("ContentProvider")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Global = require(ReplicatedStorage.Global)
local Janitor = require(ReplicatedStorage.Packages.Janitor)
local Promise = require(ReplicatedStorage.Packages.Promise)

local Assets = ReplicatedStorage:FindFirstChild("Assets")
local Logo = Assets:FindFirstChild("Logo")

local janitor = Janitor.new()
local Camera = workspace.CurrentCamera

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

local function boot()
	Logo.Parent = workspace
	ContentProvider:PreloadAsync(Logo:GetDescendants())

	Camera.CameraType = Enum.CameraType.Scriptable

	-- Lighting settings
	Lighting.Ambient = Color3.new(0, 0, 0)
	Lighting.EnvironmentDiffuseScale = 0
	Lighting.EnvironmentSpecularScale = 0
	Lighting.Brightness = 0

	janitor:Add(function()
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
				task.wait(3)
				janitor:Cleanup()
			end))
		:catch(warn)

	janitor:Add(RunService.RenderStepped:Connect(function()
		local Sin = math.sin(tick() * 2.5) / 10
		local Cos = math.cos(tick() * 2.5) / 10

		Camera.CFrame = Logo:FindFirstChild("Camera", true).CFrame
			* CFrame.new(Sin, Cos, 0)
	end))
end

return Global.Schedule:Add(boot)
