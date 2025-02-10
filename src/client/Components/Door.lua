local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local Component = require(ReplicatedStorage.Packages.Component)
local Global = require(ReplicatedStorage.Global)

local DoorComponent = Component.new {
	Tag = "Door",
}

-- TWEEN SETTINGS
local tweenInfo =
	TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)

function DoorComponent:Construct()
	print("Created")
end

function DoorComponent:Start()
	local player = Players.LocalPlayer
	local character = player.Character or player.CharacterAdded:Wait()
	local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

	local main = self.Instance:FindFirstChild("Main")
	repeat
		main = self.Instance:FindFirstChild("Main")
		task.wait()
	until main

	local side1: Motor6D = main:FindFirstChild("Side1")
	local side2 = main:FindFirstChild("Side2")

	if not main or not side1 or not side2 then
		warn("Door parts missing in", self.Instance)
		repeat
			main = self.Instance:FindFirstChild("Main")
			side1 = main:FindFirstChild("Side1")
			side2 = main:FindFirstChild("Side2")
			task.wait(0.5)
		until main and side1 and side2
	end

	self.OriginalPositions = {
		Side1 = side1.C0,
		Side2 = side2.C0,
	}

	self.isOpen = false

	-- Listen for changes to the Active attribute
	self.Instance:GetAttributeChangedSignal("Active"):Connect(function()
		self:HandleActiveState(side1, side2)
	end)

	-- RenderStepped for auto doors
	self.connection = RunService.RenderStepped:Connect(function()
		if not humanoidRootPart or not main then
			return
		end

		local isLocked = self.Instance:GetAttribute("Locked")
		local distance = (humanoidRootPart.Position - main.Position).Magnitude

		if isLocked then
			-- Locked doors are controlled by "Active" instead of proximity
			return
		end

		if distance < 10 and not self.isOpen then
			self.isOpen = true
			self.Instance:SetAttribute("PlayerActive", true)
			self:OpenDoor(side1, side2)
		elseif distance > 12 and self.isOpen then
			self.isOpen = false
			self.Instance:SetAttribute("PlayerActive", false)
			self:CloseDoor(side1, side2)
		end
	end)
end

function DoorComponent:HandleActiveState(side1, side2)
	local isLocked = self.Instance:GetAttribute("Locked")
	local isActive = self.Instance:GetAttribute("Active")

	if not isLocked then
		return -- Ignore if the door isn't locked
	end

	if isActive and not self.isOpen then
		self.isOpen = true
		self:OpenDoor(side1, side2)
	elseif not isActive and self.isOpen then
		self.isOpen = false
		self:CloseDoor(side1, side2)
	end
end

function DoorComponent:OpenDoor(side1, side2)
	print("Opening door")
	Global.GameUtil.playSound("Door")
	local tweenSide1 = TweenService:Create(side1, tweenInfo, {
		C0 = (self.OriginalPositions.Side1 * CFrame.new(0, 0, -4)),
	})
	local tweenSide2 = TweenService:Create(side2, tweenInfo, {
		C0 = (self.OriginalPositions.Side2 * CFrame.new(0, 0, 4)),
	})

	tweenSide1:Play()
	tweenSide2:Play()
end

function DoorComponent:CloseDoor(side1, side2)
	print("Closing door")

	local tweenSide1 = TweenService:Create(
		side1,
		tweenInfo,
		{ C0 = self.OriginalPositions.Side1 }
	)
	local tweenSide2 = TweenService:Create(
		side2,
		tweenInfo,
		{ C0 = self.OriginalPositions.Side2 }
	)

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
