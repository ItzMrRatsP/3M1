local runService = game:GetService("RunService")
local players = game:GetService("Players")
local camera = workspace.CurrentCamera
local uis = game:GetService("UserInputService")

local function lerp(a, b, c)
	return a + (b - a) * c
end

local PhysicsGrabHandler = {}
PhysicsGrabHandler.__index = PhysicsGrabHandler

function PhysicsGrabHandler.new(character)
	local self = setmetatable({}, PhysicsGrabHandler)
	self.character = character

	return self
end


function PhysicsGrabHandler:Destroy()
    
end

return PhysicsGrabHandler

