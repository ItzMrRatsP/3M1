local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local Component = require(ReplicatedStorage.Packages.Component)

local PressureButton = Component.new {
	Tag = "PressureButton",
}

-- TWEEN SETTINGS
local tweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)

function PressureButton:Construct()

end

function PressureButton:Start()
    local Pushdown = self.Instance:WaitForChild("Push")
    local originalPosition = Pushdown.Position
    local activeConnections = {}
    
    Pushdown.Touched:Connect(function(hit)
        local model = hit.Parent
        if model and CollectionService:HasTag(model, "Heavy") then
            local targetPosition = originalPosition - Vector3.new(0, 0.2, 0) -- Moves it down slightly
            local tween = TweenService:Create(Pushdown, tweenInfo, {Position = targetPosition})
            tween:Play()
            
            self.Instance:SetAttribute("Active", true)
            activeConnections[model] = true
        end
    end)
    
    Pushdown.TouchEnded:Connect(function(hit)
        local model = hit.Parent
        if model and activeConnections[model] then
            activeConnections[model] = nil
            
            if next(activeConnections) == nil then -- Check if no more "Heavy" objects are on the button
                local tween = TweenService:Create(Pushdown, tweenInfo, {Position = originalPosition})
                tween:Play()
                
                self.Instance:SetAttribute("Active", false)
            end
        end
    end)
end

function PressureButton:Stop()

end

return PressureButton
