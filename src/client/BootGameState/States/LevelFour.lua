local CollectionService = game:GetService("CollectionService")
local ContentProvider = game:GetService("ContentProvider")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Door = require(ReplicatedStorage.Client.Components.Door)
local Janitor = require(ReplicatedStorage.Packages.Janitor)
local SignalWrapper = require(ReplicatedStorage.Shared.SignalWrapper)
local Zones = require(ReplicatedStorage.Shared.Zones)

local ActiveMap = workspace:WaitForChild("ActiveMap")

return function(StateMachine)
	local State = StateMachine:AddState(script.Name)
	local janitor = Janitor.new()

	function State:Enter()
		local Level = ActiveMap["LevelFour"]

		local ExitDoor = Level.Assets:FindFirstChild("ExitDoor")
		local EntryDoor = Level.Assets:FindFirstChild("ExitDoor")

		local PistonButton = Level.Assets:FindFirstChild("PistonButton")
		local Button1 = Level.Assets:FindFirstChild("Button1")
		local Button2 = Level.Assets:FindFirstChild("Button2")
		local Piston = Level.Assets:FindFirstChild("Piston")

		task.spawn(function()
			while PistonButton:GetAttribute("Active") do
				Piston:SetAttribute("Active", true)
				task.wait(2)
				Piston:SetAttribute("Active", false)
				task.wait(2)
			end
		end)

		--todo, while pistonButton active, every 2 seconds Piston is activated and deactivated
		EntryDoor:SetAttribute("Locked", true)
		EntryDoor:SetAttribute("Active", false)

		local function JointButtonPressed()
			if
				Button1:GetAttribute("Active")
				and Button2:GetAttribute("Active")
			then
				ExitDoor:SetAttribute("Active", true)
			else
				ExitDoor:SetAttribute("Active", false)
			end
		end

		Button1:GetAttributeChangedSignal("Active")
			:Connect(JointButtonPressed)
		Button2:GetAttributeChangedSignal("Active")
			:Connect(JointButtonPressed)
	end

	function State:Start() end

	function State:Update() end

	function State:Exit() end

	return State
end
