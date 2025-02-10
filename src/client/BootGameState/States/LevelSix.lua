local CollectionService = game:GetService("CollectionService")
local ContentProvider = game:GetService("ContentProvider")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Janitor = require(ReplicatedStorage.Packages.Janitor)
local SignalWrapper = require(ReplicatedStorage.Shared.SignalWrapper)
local Subtitles = require(ReplicatedStorage.Client.Subtitles)
local Zones = require(ReplicatedStorage.Shared.Zones)

local ActiveMap = workspace:WaitForChild("ActiveMap")

return function(StateMachine)
	local State = StateMachine:AddState(script.Name)
	local janitor = Janitor.new()

	local StartButtonActivated = false
	local OutofBoundSlidingDoorActive = false
	local TextureDoorActive = false

	function State:Enter()
		local Level = workspace.ActiveMap:WaitForChild("LevelSix")

		local UnloadOne = Level.UnloadOne
		local UnloadTwo = Level.UnloadTwo
		local UnloadThree = Level.UnloadThree

		SignalWrapper:Get("generateLevel"):Fire()

		--UnloadedOne

		local OneButton1 = UnloadOne.Button1
		local OneButton2 = UnloadOne.Button2
		local Door = UnloadOne.SlidingDoor

		local function JointButtonPressed()
			if
				OneButton1:GetAttribute("Active")
				and OneButton2:GetAttribute("Active")
			then
				Door:SetAttribute("Active", true)
			else
				Door:SetAttribute("Active", false)
			end
		end

		OneButton1:GetAttributeChangedSignal("Active")
			:Connect(JointButtonPressed)
		OneButton2:GetAttributeChangedSignal("Active")
			:Connect(JointButtonPressed)

		--UnloadTwo

		UnloadThree:WaitForChild("DoorButton")
			:GetAttributeChangedSignal("Active")
			:Connect(function()
				UnloadThree.SlidingDoorEXIT:SetAttribute(
					"Active",
					UnloadThree.DoorButton:GetAttribute("Active")
				)
			end)

		UnloadTwo:WaitForChild("PressureButton")
			:GetAttributeChangedSignal("Active")
			:Connect(function()
				UnloadTwo.SlidingDoor:SetAttribute(
					"Active",
					UnloadTwo.PressureButton:GetAttribute("Active")
				)
			end)

		local EntranceDoor =
			Level.LevelRelated:FindFirstChild("SlidingDoorSTART")
		local StartButton = Level.LevelRelated:FindFirstChild("StartButton")
		local StartPiston = Level.LevelRelated:FindFirstChild("StartPiston")
		local OutOfBoundDoor =
			Level.LevelRelated:FindFirstChild("OutofBoundSlidingDoor")
		local TextureDoor = Level.LevelRelated:FindFirstChild("TextureDoor")

		EntranceDoor:SetAttribute("Locked", true)
		EntranceDoor:SetAttribute("Active", false)

		OutOfBoundDoor:GetAttributeChangedSignal("PlayerActive")
			:Connect(function()
				if
					OutOfBoundDoor:GetAttribute("PlayerActive")
					and not OutofBoundSlidingDoorActive
				then
					OutofBoundSlidingDoorActive = true
					task.wait(1)
					Subtitles.playSubtitle(
						"Emily_LVLSix_out_of_bounds",
						false
					)
				end
			end)

		TextureDoor:GetAttributeChangedSignal("PlayerActive")
			:Connect(function()
				if
					TextureDoor:GetAttribute("PlayerActive")
					and not TextureDoorActive
				then
					TextureDoorActive = true
					task.wait(1)
					Subtitles.playSubtitle(
						"Emily_LVLSix_not_intentional",
						false,
						2
					)
				end
			end)

		StartButton:GetAttributeChangedSignal("Active"):Connect(function()
			if
				StartButton:GetAttribute("Active")
				and not StartButtonActivated
			then
				StartButtonActivated = true
				task.wait(2)
				Subtitles.playSubtitle(
					"Emily_LVLSix_employees",
					true,
					1.5
				)

				task.wait(2)
				Subtitles.playSubtitle(
					"Emily_LVLSix_just_through_here",
					false,
					1.5
				)

				StartPiston:SetAttribute("Active", true)
			end
		end)

		local zone = Zones.new(
			ActiveMap["LevelSeven"].LevelRelated:WaitForChild("Zone")
		)

		janitor:Add(
			zone.playerEntered:Connect(function()
				SignalWrapper:Get("removePreviousLevel")
					:Fire("LevelSeven")

				local SevenEntryDoor =
					ActiveMap["LevelSeven"].LevelRelated:FindFirstChild(
						"EntryDoor"
					)

				SevenEntryDoor:SetAttribute("Locked", true)
				StateMachine:Transition(StateMachine.LevelSeven)
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
