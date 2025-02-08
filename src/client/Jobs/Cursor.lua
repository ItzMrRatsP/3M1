local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Global = require(ReplicatedStorage.Global)

local Camera = workspace.CurrentCamera
local Player = Players.LocalPlayer

return Global.Schedule:Add(function()
	local CursorGui =
		ReplicatedStorage.Assets:FindFirstChild("Cursor"):Clone()
	CursorGui.Parent = Player.PlayerGui

	UserInputService.MouseIconEnabled = false

	RunService.RenderStepped:Connect(function()
		local position = UserInputService:GetMouseLocation()
		CursorGui.Image.Position = UDim2.fromScale(
			position.X / Camera.ViewportSize.X,
			position.Y / Camera.ViewportSize.Y
		)
	end)
end)
