local CollectionService = game:GetService("CollectionService")
local ContentProvider = game:GetService("ContentProvider")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Janitor = require(ReplicatedStorage.Packages.Janitor)
local SignalWrapper = require(ReplicatedStorage.Shared.SignalWrapper)
local Zones = require(ReplicatedStorage.Shared.Zones)

local ActiveMap = workspace:WaitForChild("ActiveMap")

return function(StateMachine)
	local State = StateMachine:AddState(script.Name)
	local janitor = Janitor.new()

	function State:Enter()
		local Level = workspace.ActiveMaps["LevelFive"]

		local PressureButton = Level.Assets:FindFirstChild("PressureButton")
		local EntranceDoor = Level.Assets:FindFirstChild("EntryDoor")
		local ExitDoor = Level.Assets:FindFirstChild("ExitDoor")

		EntranceDoor:SetAttribute("Locked", true)
		EntranceDoor:SetAttribute("Active", false)

		janitor:Add(
			PressureButton:GetAttributeChangedSignal("Active")
				:Connect(function()
					ExitDoor:SetAttribute(
						"Active",
						PressureButton:GetAttribute("Active")
					)
				end)
		)
	end

	function State:Start() end

	function State:Update() end

	function State:Exit()
		janitor:Cleanup()
	end

	return State
end
