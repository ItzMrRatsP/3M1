local RunService = game:GetService("RunService")

return function(StateMachine, Character)
	local State = StateMachine:AddState(script.Name)

	function State:Start()
		StateMachine:AddEvent({
			Name = "IdleEvent",
			ToState = StateMachine.Idle,
			FromStates = {
				StateMachine.Walk,
			},
			Condition = function()
				if Character.Humanoid.MoveDirection.Magnitude < 0.1 then
					return true
				end
			end,
		}, true)
	end

	function State:Enter()
		Character.WalkSpeed = 1
	end

	function State:Update(dt) end

	function State:Exit() end

	return State
end
