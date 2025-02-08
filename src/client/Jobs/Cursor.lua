local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Global = require(ReplicatedStorage.Global)

local Player = Players.LocalPlayer
local PlayerMouse = Player:GetMouse()

local Id = 68256994

return Global.Schedule:Add(function()
	PlayerMouse.Icon = "rbxassetid://" .. Id
end)
