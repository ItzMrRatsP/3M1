local RunService = game:GetService("RunService")

local ContentProvider = game:GetService("ContentProvider")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ActiveMap = workspace:WaitForChild("ActiveMap")

return function(StateMachine)
	local State = StateMachine:AddState(script.Name)

	function State:Start() end

	function State:Enter() end
	function State:Update(dt) end

	function State:Exit() end

	return State
end
