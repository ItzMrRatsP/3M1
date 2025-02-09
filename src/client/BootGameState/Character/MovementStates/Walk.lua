local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local Camera = workspace.CurrentCamera

return function(StateMachine, Character)
	local State = StateMachine:AddState(script.Name)
	local CurrentWalkspeed = 12
	function State:Start()
		StateMachine:AddEvent({
			Name = "WalkEvent",
			ToState = StateMachine.Walk,
			FromStates = {
				StateMachine.Idle,
			},
			Condition = function()
				if Character.Humanoid.MoveDirection.Magnitude > 0.2 then
					return true
				end
			end,
		}, true)
	end

	function State:Enter() end

	function State:Update(DT)
		Character.WalkSpeed += (CurrentWalkspeed - Character.WalkSpeed) * (1 - math.pow(
			5,
			-1.1 * DT
		))
	end

	function State:Exit() end

	function State:Destroy() end

	return State
end
