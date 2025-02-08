local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local GameConfig = require(ReplicatedStorage.Global.Config.GameConfig)
local Global = require(ReplicatedStorage.Global)
local Janitor = require(ReplicatedStorage.Packages.Janitor)
local LevelsLUT =
	require(ReplicatedStorage.Client.LevelGenerator.Modules.LevelsLUT)
local Promise = require(ReplicatedStorage.Packages.Promise)
local SignalWrapper = require(ReplicatedStorage.Shared.SignalWrapper)

local janitor = Janitor.new()
local LocalPlayer = Players.LocalPlayer
local Index = 1

local function switchGameState(Name)
	if not Global.SceneManager[Name] then
		return
	end

	Global.SceneManager:Transition(Global.SceneManager[Name])
end

local function addLoading(levelIndex)
	janitor
		:AddPromise(Promise.try(function()
			ReplicatedStorage:SetAttribute("StartLoading", true)
			return Promise.delay(2)
		end):andThen(function()
			switchGameState(levelIndex)
		end))
		:catch(warn)
end

local function generateNextLevel()
	local levelIndex = LevelsLUT.IndexedLevel[Index]

	-- Level doesn't exist, close off the script
	if not levelIndex then
		return
	end

	local levelConfig = LevelsLUT.Config[LevelsLUT.OrderedIndex[levelIndex]]

	-- Level config doesn't exist, which means level haven't been added yet
	if not levelConfig then
		warn("Level Config doesn't exist")
		return
	end

	janitor:Cleanup() -- Cleanup before doing new stuff
	janitor:Add(function()
		ReplicatedStorage:SetAttribute("StartLoading", true)
	end)

	local map = janitor:Add(levelConfig.Map:Clone())
	map.Parent = workspace

	print("Level generated, Next task is to tp all players")

	local mapSpawn = map:FindFirstChild("Spawn", true)


	if LocalPlayer.Character then
		LocalPlayer.Character:PivotTo(mapSpawn.CFrame)
	end
	
	janitor:Add(LocalPlayer.CharacterAdded:Connect(function(Character)
		print("pivoted")
		Character:PivotTo(mapSpawn.CFrame)
	end))

	if not ReplicatedStorage:GetAttribute("IntroFinished") then
		janitor:Add(
			ReplicatedStorage:GetAttributeChangedSignal("IntroFinished")
				:Connect(function()
					-- Finished
					addLoading(levelIndex)
				end)
		)
	else
		addLoading(Index)
	end

	-- Set the index to the next index
	Index += 1
end

local function boot()
	-- TODO: Generate Level on Signal
	SignalWrapper:Load("generateNextLevel", generateNextLevel)
	generateNextLevel()
end

return Global.Schedule:Add(boot)
