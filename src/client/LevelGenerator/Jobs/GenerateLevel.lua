local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local GameConfig = require(ReplicatedStorage.Global.Config.GameConfig)
local Global = require(ReplicatedStorage.Global)
local Janitor = require(ReplicatedStorage.Packages.Janitor)
local LevelsLUT =
	require(ReplicatedStorage.Client.LevelGenerator.Modules.LevelsLUT)
local SignalWrapper = require(ReplicatedStorage.Shared.SignalWrapper)

-- This will help us keep track of the previous level
local janitor = Janitor.new()
local currentLevel = nil
local nextLevelSpawn = nil
local currentIndex = 1

local Levels = {} :: { [number]: { Entrance: Model?, Map: Model } }

-- Variables
local Player = Players.LocalPlayer
-- local function destroyPreviousLevel() end void

local function generateEntrance()
	-- todo: generate entrance for the current level
	if not nextLevelSpawn then
		warn("No next levelspawn, idk")
		return
	end

	local entrance = janitor:Add(
		ReplicatedStorage.Assets:FindFirstChild("Entrance", true):Clone()
	)

	entrance:PivotTo(nextLevelSpawn:GetPivot())
	entrance.Parent = workspace

	nextLevelSpawn = entrance:FindFirstChild("NextLevelSpawn")

	return entrance
end

local function generateLevel()
	-- todo: generate the levels passivly
	local levelIndex = LevelsLUT.IndexedLevel[currentIndex]

	if not levelIndex then
		warn("No level index")
		return
	end

	local levelConfig = LevelsLUT.Config[currentIndex]

	if not levelConfig then
		warn("No level config")
		return
	end

	currentLevel = janitor:Add(levelConfig.Map:Clone())
	currentLevel.Parent = workspace:FindFirstChild("ActiveMap")

	local Entrance = nil

	if levelConfig.HasEntrance then
		print("Has entrance, create entrance for the room")
		Entrance = generateEntrance()
	end

	Levels[currentIndex] = { Entrance = Entrance, Map = currentLevel }

	-- Set the CFrame of the level
	if GameConfig.StartLevel == levelIndex then
		local Spawn = workspace:WaitForChild("LevelSpawn")

		if not Spawn then
			warn("No spawn")
			return
		end

		currentLevel:PivotTo(Spawn:GetPivot())
		nextLevelSpawn = currentLevel:FindFirstChild("NextLevelSpawn", true)
	else
		if not nextLevelSpawn then
			warn("No next level spawn, possibly no next level exist.")
			return
		end

		-- Nothing to generate for next level

		currentLevel:PivotTo(nextLevelSpawn:GetPivot())
		nextLevelSpawn = currentLevel:FindFirstChild("NextLevelSpawn", true)
	end

	if Player.Character then
		if GameConfig.StartLevel == levelIndex then
			Player.Character:PivotTo(
				currentLevel:FindFirstChild("Spawn", true).CFrame
			)
		end
	end

	janitor:Add(Player.CharacterAdded:Connect(function(Char)
		if GameConfig.StartLevel == levelIndex then
			Char:PivotTo(
				currentLevel:FindFirstChild("Spawn", true).CFrame
			)
		end
	end))

	-- Move to the next index
	currentIndex += 1
end

return Global.Schedule:Add(function()
	SignalWrapper:Get("generateLevel"):Connect(generateLevel)

	SignalWrapper:Get("removePreviousLevel"):Connect(function(level: string?)
		local index = LevelsLUT.OrderedIndex[level]

		-- NO previous level exist
		if not index then
			warn("No previous level exist.")
			return
		end

		for _, Model in Levels[index - 1] do
			Model:Destroy()
		end
	end)

	generateLevel() -- Intermission level
end)
