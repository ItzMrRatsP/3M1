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
		ActiveMap["LevelTwo"].Assets.SlidingDoorENTRY:SetAttribute(
			"Locked",
			true
		)

		
		Subtitles.playSubtitle("Emily_LVLTwo_bridge", false)

		SignalWrapper:Get("generateLevel"):Fire()

		local zone =
			Zones.new(ActiveMap["LevelThree"]:FindFirstChild("EntryZone"))

		janitor:Add(
			zone.playerEntered:Connect(function()
				task.delay(5, function()
					SignalWrapper:Get("removePreviousLevel")
						:Fire("LevelThree")
				end)

				Subtitles.playSubtitle("Emily_LVLTwo_brain")

				

				StateMachine:Transition(StateMachine.LevelThree)
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
