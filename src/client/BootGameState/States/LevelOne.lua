local RunService = game:GetService("RunService")

local ContentProvider = game:GetService("ContentProvider")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Global = require(ReplicatedStorage.Global)
local Janitor = require(ReplicatedStorage.Packages.Janitor)

local SignalWrapper = require(ReplicatedStorage.Shared.SignalWrapper)

local ActiveMap = workspace:WaitForChild("ActiveMap")

return function(StateMachine)
	local State = StateMachine:AddState(script.Name)
	local janitor = Janitor.new()

	function State:Start() 
		
	end

	function State:Enter()
		local LevelOne = ActiveMap["LevelOne"]
		local LevelRelatedAssets = LevelOne.LevelRelated
		local TimedButton = LevelRelatedAssets.TimedButton
		local DoorButton = LevelRelatedAssets.DoorButton
		local SlidingDoorExit = LevelRelatedAssets.SlidingDoorEXIT
		local SlidingDoorEntry = LevelRelatedAssets.SlidingDoorENTRY
		local LazerPart = LevelRelatedAssets.LazerPart
		local Beam = LevelRelatedAssets.Beam

		SlidingDoorEntry:SetAttribute("Locked", true)
		SlidingDoorEntry:SetAttribute("Active", false)

		local function OnTimedButtonActivated()
			LazerPart.CanCollide = false
			Beam.Beam.Enabled = false

			task.delay(10, function()
				LazerPart.CanCollide = true
				Beam.Beam.Enabled = true
			end)
		end

		TimedButton:GetAttributeChangedSignal("Active"):Connect(function()
			if TimedButton:GetAttribute("Active") then
				OnTimedButtonActivated()
			end
		end)

		DoorButton:GetAttributeChangedSignal("Active"):Connect(function()
			SlidingDoorExit:SetAttribute("Active", DoorButton:GetAttribute("Active"))
		end)

		task.wait(1)

		SignalWrapper:Get("generateLevel"):Fire()

	end


	function State:Update(dt)

	end

	function State:Exit()
		janitor:Cleanup()
	end

	return State
end
