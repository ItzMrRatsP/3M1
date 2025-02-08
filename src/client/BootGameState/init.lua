local ChangeHistoryService = game:GetService("ChangeHistoryService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Global = require(ReplicatedStorage.Global)

local CharacterModule = require(script.Character)

local LocalPlayer = Players.LocalPlayer

local function BootGameState()
	local StateMachine = Global.StateMachine.newFromFolder(script.States)

	local function CharacterRemoved(character)
		if Global.Character then
			Global.Character:Destroy()
			Global.Character = nil
		end
	end

	local function CharacterAdded(character)
		CharacterRemoved(character)
		Global.Character = CharacterModule.new(character)
	end

	if LocalPlayer.Character then
		CharacterAdded(LocalPlayer.Character)
	end

	LocalPlayer.CharacterAdded:Connect(CharacterAdded)
	LocalPlayer.CharacterRemoving:Connect(CharacterRemoved)

	StateMachine:Start(StateMachine.Intro)
end

return Global.Schedule:Add(BootGameState)
