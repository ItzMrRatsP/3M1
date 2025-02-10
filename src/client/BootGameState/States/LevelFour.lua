local CollectionService = game:GetService("CollectionService")
local ContentProvider = game:GetService("ContentProvider")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Door = require(ReplicatedStorage.Client.Components.Door)
local Global = require(ReplicatedStorage.Global)
local Janitor = require(ReplicatedStorage.Packages.Janitor)
local Promise = require(ReplicatedStorage.Packages.Promise)
local SignalWrapper = require(ReplicatedStorage.Shared.SignalWrapper)
local Subtitles = require(ReplicatedStorage.Client.Subtitles)
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

		SignalWrapper:Get("generateLevel"):Fire()

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

		local zone = Zones.new(
			ActiveMap["LevelFive"].Assets:FindFirstChild("Zone")
		)

		janitor:Add(
			zone.playerEntered:Connect(function()
				-- task.delay(3, function()
				-- 	SignalWrapper:Get("removePreviousLevel")
				-- 		:Fire("LevelSix")
				-- end)

				StateMachine:Transition(StateMachine.LevelFive)
				Subtitles.playSubtitle("LVLFive_1", true)

				local ScaryNoise =
					ReplicatedStorage.Assets.Sounds:FindFirstChild(
						"ScaryNoise"
					)

				SignalWrapper:Get("SetMainVolume"):Fire(0.125)
				ScaryNoise:Play()

				janitor:AddPromise(
					Promise.fromEvent(ScaryNoise.Ended, function()
						return true
					end)
						:andThen(function()
							task.wait(0.25)
							Subtitles.playSubtitle(
								"LVLFive_2",
								true
							)

							SignalWrapper:Get("SetMainVolume")
								:Fire(0.5)
						end)
						:catch(warn)
				)
			end),

			"Disconnect"
		)

		janitor:Add(
			task.spawn(function()
				while true do
					if not PistonButton:GetAttribute("Active") then
						task.wait()
						continue
					end

					Piston:SetAttribute("Active", true)
					task.wait(5)
					Piston:SetAttribute("Active", false)
					task.wait(5)
				end
			end),

			true
		)
	end

	function State:Start() end

	function State:Update() end

	function State:Exit()
		janitor:Cleanup()
	end

	return State
end
