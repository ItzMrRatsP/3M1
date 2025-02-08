local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Global = require(ReplicatedStorage.Global)

local function BootGameState()
    local StateMachine = Global.StateMachine.newFromFolder(script.States)

    StateMachine:Start(StateMachine.Intro)
end

return Global.Schedule:Add(BootGameState)