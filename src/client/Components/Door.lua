local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local Component = require(ReplicatedStorage.Packages.Component)

local DoorComponent = Component.new {
	Tag = "Door",
}

-- TWEEN SETTINGS
local tweenInfo =
	TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out) -- 1 second animation

function DoorComponent:Construct()
	print("Created")
end

function DoorComponent:Start()
	local player = Players.LocalPlayer
	local character = player.Character or player.CharacterAdded:Wait()
	local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

	local main = self.Instance:FindFirstChild("Main")
	local side1 = self.Instance:FindFirstChild("Side1")
	local side2 = self.Instance:FindFirstChild("Side2")

	if not main or not side1 or not side2 then
		warn("Door parts missing in", self.Instance)
		return
	end

	self.OriginalPositions = {
		Side1 = side1.Position,
		Side2 = side2.Position,
	}

	self.isOpen = false
	self.connection = RunService.RenderStepped:Connect(function()
		if not humanoidRootPart or not main then
			return
		end

		local distance = (humanoidRootPart.Position - main.Position).Magnitude

		if distance < 10 and not self.isOpen then
			self.isOpen = true
			self:OpenDoor(side1, side2)
		elseif distance > 12 and self.isOpen then
			self.isOpen = false
			self:CloseDoor(side1, side2)
		end
	end)
end

function DoorComponent:OpenDoor(side1, side2)
	print("Opening door")

	local tweenSide1 = TweenService:Create(
		side1,
		tweenInfo,
		{
			CFrame = (CFrame.new(self.OriginalPositions.Side1) * CFrame.new(-3, 0, 0)),
		}
	) -- Move left
	local tweenSide2 = TweenService:Create(
		side2,
		tweenInfo,
		{
			(CFrame = CFrame.new(
				self.OriginalPositions.Side2) * CFrame.new(3, 0, 0)
			),
		}
	) -- Move right

	tweenSide1:Play()
	tweenSide2:Play()
end

function DoorComponent:CloseDoor(side1, side2)
	print("Closing door")

	local tweenSide1 = TweenService:Create(
		side1,
		tweenInfo,
		{ Position = self.OriginalPositions.Side1 }
	) -- Move back to original position
	local tweenSide2 = TweenService:Create(
		side2,
		tweenInfo,
		{ Position = self.OriginalPositions.Side2 }
	) -- Move back to original position

	tweenSide1:Play()
	tweenSide2:Play()
end

function DoorComponent:Stop()
	if self.connection then
		self.connection:Disconnect()
		self.connection = nil
	end
end

return DoorComponent
