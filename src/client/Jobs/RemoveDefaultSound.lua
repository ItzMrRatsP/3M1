-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Global = require(ReplicatedStorage.Global)

-- Variables
-- Removes footstep audio

local AudioRemoval = {}

-- Functions

local function RemoveAudio(PlayerCharacter: Model, name: string)
	local Hmrpt = PlayerCharacter:WaitForChild("HumanoidRootPart")
	local Audio = Hmrpt:WaitForChild(name)

	if not Audio then
		return
	end

	Audio.Volume = 0
end

local function CharacterAdded(Character)
	RemoveAudio(Character, "Running")
end

local function PlayerAdded(Player: Player)
	-- Upon joining players:
	Player.CharacterAdded:Connect(CharacterAdded)

	-- Already existing characters:
	if Player.Character then
		warn("Remove Audio!")
		CharacterAdded(Player.Character)
	end
end

local function boot()
	for _, Player in Players:GetPlayers() do
		PlayerAdded(Player)
	end

	Players.PlayerAdded:Connect(PlayerAdded)
end

return Global.Schedule:Add(boot)
