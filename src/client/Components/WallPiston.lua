local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local Zones = require(ReplicatedStorage.Shared.Zones)

local Component = require(ReplicatedStorage.Packages.Component)

local WallPiston = Component.new {
	Tag = "WallPiston",
}

local Info = TweenInfo.new(2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

function WallPiston:Start()
	self.BasePart = self.Instance:WaitForChild("Main")
	self.BasePosition = self.BasePart.Position

	self.EndPos = self.Instance.Path.EndPos.Position

	self.Instance:GetAttributeChangedSignal("Active"):Connect(function()
		if self.Instance:GetAttribute("Active") then
			self:Activated()
			return
		end

		self:Deactivated()
	end)
end

function WallPiston:Activated()
	local tween =
		TweenService:Create(self.BasePart, Info, { Position = self.EndPos })
	tween:Play()
end

function WallPiston:Deactivated()
	local tween = TweenService:Create(
		self.BasePart,
		Info,
		{ Position = self.BasePosition }
	)
	tween:Play()
end

function WallPiston:Stop() end

return WallPiston
