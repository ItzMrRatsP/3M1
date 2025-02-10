local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Global = require(ReplicatedStorage.Global)
local SignalWrapper = require(ReplicatedStorage.Shared.SignalWrapper)

local function boot()
	local CreditScreen =
		ReplicatedStorage.Assets.UI:FindFirstChild("CreditScreen"):Clone()
	CreditScreen.Main.Visible = false
	CreditScreen.Parent = Players.LocalPlayer.PlayerGui

	SignalWrapper:Get("CreditScreen"):Connect(function(state)
		if not state then
			return
		end

		-- Test
		Global.GameUtil.playSound("Ending")

		CreditScreen.Main.Visible = true
		CreditScreen.Main.GroupTransparency = 0
	end)
end

return Global.Schedule:Add(boot)
