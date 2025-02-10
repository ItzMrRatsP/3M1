local CollectionService = game:GetService("CollectionService")
local ContentProvider = game:GetService("ContentProvider")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Janitor = require(ReplicatedStorage.Packages.Janitor)
local SignalWrapper = require(ReplicatedStorage.Shared.SignalWrapper)
local Zones = require(ReplicatedStorage.Shared.Zones)
local Subtitles = require(ReplicatedStorage.Client.Subtitles)

local ActiveMap = workspace:WaitForChild("ActiveMap")

return function(StateMachine)
	local State = StateMachine:AddState(script.Name)
	local janitor = Janitor.new()

	function State:Enter()
		-- TODO: Check if button pressed
		local ActivatedOnce = false
		local Level = workspace.ActiveMap:FindFirstChild("LevelThree")
		local EntryDoor = Level:FindFirstChild("EnterDoor", true)
		local ExitDoor = Level:FindFirstChild("ExitDoor", true)
		local PressureButton = Level:FindFirstChild("PressureButton", true)

		EntryDoor:SetAttribute("Locked", true)
		EntryDoor:SetAttribute("Active", false)

		task.delay(5, function()
			if not ActivatedOnce then
				Subtitles.playSubtitle("Emily_LVLThree_throw", false)
			end
		end)

		PressureButton:GetAttributeChangedSignal("Active")
			:Connect(function()
				if not ActivatedOnce then
					ActivatedOnce = true
					Subtitles.playSubtitle("Emily_LVLThree_complete")
				end
				ExitDoor:SetAttribute(
					"Active",
					PressureButton:GetAttribute("Active")
				)
			end)

		local zone = Zones.new(
			ActiveMap["LevelFour"].Assets:FindFirstChild("Zone")
		)

		janitor:Add(
			zone.playerEntered:Connect(function()
				task.delay(3, function()
					SignalWrapper:Get("removePreviousLevel")
						:Fire("LevelFour")
				end)

				StateMachine:Transition(StateMachine.LevelFour)
			end),

			"Disconnect"
		)
	end

	function State:Start() end

	function State:Update() end

	function State:Exit()
		janitor:Cleanup()
	end

	return State
end
