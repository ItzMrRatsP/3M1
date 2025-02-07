local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LemonSignal = require(ReplicatedStorage.Packages.LemonSignal)

local CharacterTracker = {}

CharacterTracker.CharacterAdded = LemonSignal.new()
CharacterTracker.CharacterRemoved = LemonSignal.new()

CharacterTracker.Characters = {}

function CharacterTracker:Add(Player: Player, Character: Model)
	self.Characters[Character] = Player
	self.CharacterAdded:Fire(Player, Character)
end

function CharacterTracker:Remove(Character: Model)
	if not self.Characters[Character] then
		warn("Character is not valid member of Characters")
		return
	end

	self.Characters[Character] = nil
	self.CharacterRemoved:Fire(Character)
end

return CharacterTracker
