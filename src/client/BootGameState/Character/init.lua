local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Client = ReplicatedStorage:WaitForChild("Client")
local Packages = ReplicatedStorage:WaitForChild("Packages")
local Assets = ReplicatedStorage:WaitForChild("Assets")

local Janitor = require(Packages.Janitor)
local Global = require(ReplicatedStorage.Global)
local CameraHandlerModule = require(script.CameraHandler)

local Camera = workspace.CurrentCamera

local LocalPlayer = Players.LocalPlayer

local Character = {}
Character.__index = Character

local HumanoidDisabledStates = {
	Enum.HumanoidStateType.Jumping,
	Enum.HumanoidStateType.Swimming,
	Enum.HumanoidStateType.Climbing,
	Enum.HumanoidStateType.Ragdoll,
	Enum.HumanoidStateType.FallingDown
}

local function DisableStates(Humanoid, States)
	for _, State in States do
		Humanoid:SetStateEnabled(State, false)
	end
end


function Character.new(CharacterInstance)
	local self = setmetatable({}, Character)
	self.CharacterInstance = CharacterInstance
	self.Humanoid = self.CharacterInstance:WaitForChild("Humanoid")
	self.Animator = self.Humanoid:WaitForChild("Animator")
	self.Root = self.Humanoid.RootPart
	self.Janitor = Janitor.new()

	local CameraHandler = CameraHandlerModule.new(self)

	CameraHandler:Enable()
	for _, Part in self.CharacterInstance:GetDescendants() do
	
		if not Part:IsA("Sound") then continue end
		Part:Destroy()
	end

    DisableStates(self.Humanoid, HumanoidDisabledStates)

    self.WalkSpeed = 1
	self.MovementStateMachine = self.Janitor:Add(Global.StateMachine.newFromFolder(script.MovementStates, self), "Destroy")

	self.MovementStateMachine:Start(self.MovementStateMachine.Idle)

	self.Janitor:Add(RunService.RenderStepped:Connect(function(dt)
		self:Update(dt)
	end))

	return self
end

function Character:Update(DT)
    self.Humanoid.WalkSpeed = self.WalkSpeed
end

function Character:Destroy()
	self.Janitor:Destroy()
	self = nil
end

return Character
