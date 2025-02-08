local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera

local PhysicsGrab = {}
PhysicsGrab.__index = PhysicsGrab

function PhysicsGrab.new(Character)
	local self = {}
	self.CharacterObject = Character
	self.Character = Character.CharacterInstance

	self.CameraPart = Instance.new("Part")
	self.CameraPart.Anchored = true
	self.CameraPart.Transparency = 1
	self.CameraPart.CanQuery = false
	self.CameraPart.CanCollide = false
	self.CameraPart.Name = "CameraPart"
	self.CameraPart.Parent = self.Character

	self.AlignPosition = Instance.new("AlignPosition")
	self.AlignPosition.ReactionForceEnabled = true
	self.AlignOrientation = Instance.new("AlignOrientation")
	self.Attachment0 = nil
	self.Attachment1 = Instance.new("Attachment")

	self.AlignPosition.Parent = self.CameraPart
	self.AlignOrientation.Parent = self.CameraPart
	self.Attachment1.Parent = self.CameraPart
	self.Head = self.Character:WaitForChild("Head")
	self.AlignPosition.Attachment1 = self.Attachment1
	self.AlignPosition.MaxForce = math.huge
	self.AlignPosition.Responsiveness = 30
	self.AlignOrientation.Mode = Enum.OrientationAlignmentMode.OneAttachment

	self.CameraPart.Parent = workspace
	self.Connection = nil
	self.Grabbed = nil

	return setmetatable(self, PhysicsGrab)
end

function PhysicsGrab:IsModel(Object: BasePart)
	if Object:FindFirstAncestorOfClass("Model") then
		return Object:FindFirstAncestorOfClass("Model")
	end
end

function PhysicsGrab:IsGrabbing()
	return self.Grabbed
end

function PhysicsGrab:Hold(object)
	if self:IsGrabbing() then
		self:Unhold()
		return
	end
	if not object then
		return
	end
	local model = false

	if model then
		if model.PrimaryPart then
			object = model.PrimaryPart
		end
	end

	self.Attachment0 = Instance.new("Attachment")
	self.Attachment0.Parent = object
	self.AlignPosition.Attachment0 = self.Attachment0
	self.AlignOrientation.Attachment0 = self.Attachment0
	self.Grabbed = object
	self.AlignPosition.Attachment1 = self.Attachment1
end

function PhysicsGrab:CheckForObjects()
	local rayOrigin = self.Head.Position
	local rayDirection = Camera.CFrame.LookVector * 10
	local raycastparams = RaycastParams.new()
	raycastparams.FilterDescendantsInstances = { self.Character }
	raycastparams.FilterType = Enum.RaycastFilterType.Exclude
	local raycastResult =
		workspace:Raycast(rayOrigin, rayDirection, raycastparams)

	if raycastResult then
		return raycastResult.Instance
	end
end

function PhysicsGrab:Update(dt)
	self.CameraPart.Position = Camera.CFrame.LookVector * 4
		+ self.Head.Position
	self.CameraPart.Orientation = self.CameraPart.Orientation
	if not self.Grabbed then
		return
	end
	self.AlignOrientation.CFrame =
		CFrame.lookAt(self.Grabbed.Position, self.Head.Position)
end

function PhysicsGrab:Unhold()
	self.AlignPosition.Attachment1 = nil
	self.AlignOrientation.Attachment0 = nil
	if self.Attachment0 then
		self.Attachment0:Destroy()
	end
	--PhysicsGrab:EnabledCollision(self.Grabbed)
	self.Grabbed = nil
end

function PhysicsGrab:Start()
	self.Connection = RunService.RenderStepped:Connect(function(deltaTime)
		self:Update(deltaTime)
	end)
end

return PhysicsGrab
