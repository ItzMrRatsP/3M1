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

local function Tween(Model: Model, CF, Info)
	local CFrameValue = Instance.new("CFrameValue")
	CFrameValue.Value = Model:GetPivot()

	CFrameValue:GetPropertyChangedSignal("Value"):Connect(function()
		Model:PivotTo(CFrameValue.Value)
	end)

	local T = TweenService:Create(CFrameValue, Info, { Value = CF })
	T:Play()

	local Connection
	Connection = T.Completed:Connect(function(pb)
		if pb ~= Enum.PlaybackState.Completed then
			return
		end

		Connection:Disconnect()
	end)
end

function WallPiston:Start()
	self.BasePart = self.Instance:WaitForChild("Main")
	self.BasePosition = self.BasePart:GetPivot()

	self.EndPos =
		self.Instance:WaitForChild("Path"):WaitForChild("EndPos"):GetPivot()

	self.Instance:GetAttributeChangedSignal("Active"):Connect(function()
		if self.Instance:GetAttribute("Active") then
			self:Activated()
			return
		end

		self:Deactivated()
	end)
end

function WallPiston:Activated()
	Tween(self.BasePart, self.EndPos, Info)
end

function WallPiston:Deactivated()
	Tween(self.BasePart, self.BasePosition, Info)
end

function WallPiston:Stop() end

return WallPiston
