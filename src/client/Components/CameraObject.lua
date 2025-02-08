local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local Component = require(ReplicatedStorage.Packages.Component)

local player = Players.LocalPlayer

local CameraObject = Component.new {
	Tag = "CameraObject",
}

-- TWEEN SETTINGS
local tweenInfo =
	TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, -1, true, 3) -- 1 second animation

    
local function worldCFrameToC0ObjectSpace(motor6DJoint,worldCFrame)
	local part1CF = motor6DJoint.Part1.CFrame
	local c1Store = motor6DJoint.C1
	local c0Store = motor6DJoint.C0
	local relativeToPart1 =c0Store*c1Store:Inverse()*part1CF:Inverse()*worldCFrame*c1Store
	relativeToPart1 -= relativeToPart1.Position
	
	local goalC0CFrame = relativeToPart1+c0Store.Position--New orientation but keep old C0 joint position
	return goalC0CFrame
end

function CameraObject:Construct()

end

function CameraObject:Start()
    local CameraBlink = self.Instance:FindFirstChild("Sphere")
    repeat
        CameraBlink = self.Instance:FindFirstChild("Sphere")
        task.wait(1)
    until CameraBlink
	local tweenSide1 = TweenService:Create(
		CameraBlink,
		tweenInfo,
		{
			Color = Color3.new(0, 0, 0)
		}
    ):Play()

	self.connection = RunService.RenderStepped:Connect(function()
        local CameraHead = self.Instance:FindFirstChild("CameraHead")
        local CameraMain = self.Instance:FindFirstChild("Main") 
        
        if not CameraHead or not CameraMain then return end
        local Joint = CameraMain.HeadJoint
        local character = player.Character
        if not character then return end

        local humanoidRootPart = character.HumanoidRootPart

        if not humanoidRootPart then return end

        local GoalCF = CFrame.lookAt(CameraHead.Position, humanoidRootPart.Position, CameraMain.CFrame.UpVector)
        local RelativeGoalCF = worldCFrameToC0ObjectSpace(Joint, GoalCF)

        local rx, ry, rz = RelativeGoalCF:ToOrientation()
        local TargetAbove = (humanoidRootPart.Position - CameraHead.Position).Unit.Y > 0

        if TargetAbove then -- Target is above head
            if math.sin(ry) > 0 then
                ry = math.clamp(ry, math.rad(0), math.rad(90))
            else
                ry = math.clamp(ry, math.rad(-90), math.rad(0))
            end
        else
            if math.sin(ry) > 0 then
                ry = math.clamp(ry, math.rad(90), math.rad(180))
            else
                ry = math.clamp(ry, math.rad(-180), math.rad(-90))
            end
        end

        local FinalGoalCF = (CFrame.new(Joint.C0.Position) * CFrame.fromOrientation(rx, ry, rz) * CFrame.Angles(0,math.rad(-90),0))
        Joint.C0 = Joint.C0:Lerp(FinalGoalCF, 0.2)
	end)
end

function CameraObject:Stop()
	if self.connection then
		self.connection:Disconnect()
		self.connection = nil
	end
end

return CameraObject
