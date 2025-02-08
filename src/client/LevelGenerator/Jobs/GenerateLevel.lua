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

-- Variables
local Player = Players.LocalPlayer
-- local function destroyPreviousLevel() end void

local function switchGameState(Name)
	if not Global.SceneManager[Name] then
		return
	end

	Global.SceneManager:Transition(Global.SceneManager[Name])
end

local function OpenDoors() end

local function generateEntrance()
	-- todo: generate entrance for the current level
	if not nextLevelSpawn then
		return
	end

	local entrance = janitor:Add(
		ReplicatedStorage.Assets:FindFirstChild("Entrance", true):Clone()
	)

	entrance:PivotTo(nextLevelSpawn:GetPivot())
	entrance.Parent = workspace

	nextLevelSpawn = entrance:FindFirstChild("NextLevelSpawn")
end

local function generateLevel()
	-- todo: generate the levels passivly
	local levelIndex = LevelsLUT.IndexedLevel[currentIndex]

	if not levelIndex then
		warn("No level index")
		return
	end

	local levelConfig = LevelsLUT.Config[LevelsLUT.OrderedIndex[levelIndex]]

	if not levelConfig then
		warn("No level config")
		return
	end

	currentLevel = janitor:Add(levelConfig.Map:Clone())
	currentLevel.Parent = workspace


	if levelConfig.HasEntrance then
		print("Has entrance, create entrance for the room")
		generateEntrance()
	end

	-- Set the CFrame of the level
	if GameConfig.StartLevel == levelIndex then
		local Spawn = workspace:WaitForChild("LevelSpawn")

		if not Spawn then
			warn("No spawn")
			return
		end

		currentLevel:PivotTo(Spawn:GetPivot())
	else
		if not nextLevelSpawn then
			warn("No next level spawn, possibly no next level exist.")
			return
		end

		-- Nothing to generate for next level
		currentLevel:PivotTo(nextLevelSpawn:GetPivot())
	end

	nextLevelSpawn = currentLevel:FindFirstChild("NextLevelSpawn", true)


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
	generateLevel() -- Intermission level
end)

