local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local Global = require(ReplicatedStorage.Global)
local Zones = require(ReplicatedStorage.Shared.Zones)

local Component = require(ReplicatedStorage.Packages.Component)

local PressureButton = Component.new {
	Tag = "PressureButton",
}

-- TWEEN SETTINGS
local tweenInfo =
	TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)

function PressureButton:Construct() end

function PressureButton:Start()
	local Pushdown = self.Instance:WaitForChild("Push")
	local originalPosition = Pushdown.Position
	local activeConnections = {}

	local zoneCFrame = self.Instance:GetPivot()
	local zoneSize = Vector3.new(5, 5, 5)
	local zone = Zones.fromRegion(zoneCFrame, zoneSize)

	zone.itemEntered:Connect(function(item)
		local targetPosition = originalPosition - Vector3.new(0, 0.2, 0) -- Moves it down slightly
		local tween = TweenService:Create(
			Pushdown,
			tweenInfo,
			{ Position = targetPosition }
		)

		Global.GameUtil.playSound("Button")
		tween:Play()

		self.Instance:SetAttribute("Active", true)
	end)

	zone.itemExited:Connect(function(item)
		local tween = TweenService:Create(
			Pushdown,
			tweenInfo,
			{ Position = originalPosition }
		)

		tween:Play()

		self.Instance:SetAttribute("Active", false)
	end)

	for _, obj in pairs(CollectionService:GetTagged("Heavy")) do
		zone:trackItem(obj)
	end

	CollectionService:GetInstanceAddedSignal("Heavy"):Connect(function(obj)
		zone:trackItem(obj)
	end)
end

function PressureButton:Stop() end

return PressureButton
