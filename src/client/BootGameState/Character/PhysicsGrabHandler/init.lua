local ContextActionService = game:GetService("ContextActionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Fusion = require(ReplicatedStorage.Packages.Fusion)
local Global = require(ReplicatedStorage.Global)
local Janitor = require(ReplicatedStorage.Packages.Janitor)
local Camera = workspace.CurrentCamera

local janitor = Janitor.new()
local Scoped = Fusion.scoped(Fusion)

local PhysicsGrab = {}
PhysicsGrab.__index = PhysicsGrab

local function newBeam(Attachment0, Attachment1)
	return Scoped:New("Beam") {
		Name = "Beam",
		LightEmission = 1,
		LightInfluence = 1,
		Texture = "rbxassetid://5889875399",
		TextureLength = 0.1,
		Transparency = NumberSequence.new {
			NumberSequenceKeypoint.new(0, 0),
			NumberSequenceKeypoint.new(1, 1),
		},

		Attachment0 = Attachment0,
		Attachment1 = Attachment1,

		Width0 = 4,
		Width1 = 4,

		Parent = Attachment0,
	}
end

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
	self.AlignPosition.MaxForce = 30000
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

	local headAttachment = janitor:Add(Instance.new("Attachment"))
	headAttachment.Parent = self.Character:FindFirstChild("Head")

	janitor:Add(newBeam(self.Attachment0, self.Attachment1))

	janitor:Add(function()
		self:Unhold()
		ContextActionService:UnbindAction("holdPhysic")
	end)

	ContextActionService:BindAction("holdPhysic", function(_, State)
		if State ~= Enum.UserInputState.Begin then
			return
		end

		janitor:Cleanup()

		object.AssemblyLinearVelocity = Camera.CFrame.LookVector * 75
	end, true, Enum.UserInputType.MouseButton1)
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
	self.CameraPart.Position = Camera.CFrame.LookVector * 6
		+ self.Head.Position
	self.CameraPart.Orientation = self.CameraPart.Orientation

	if not self.Grabbed then
		return
	end

	if
		(
			self.Grabbed.Position.Magnitude
			- self.CameraPart.Position.Magnitude
		) >= 8
	then
		self:Unhold()
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
	janitor:Cleanup()
end

function PhysicsGrab:Start()
	self.Connection = RunService.RenderStepped:Connect(function(deltaTime)
		self:Update(deltaTime)
	end)
end

return PhysicsGrab
