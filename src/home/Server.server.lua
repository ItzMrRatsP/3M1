local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local Global = require(ReplicatedStorage.Global)

for _, Module in ServerStorage.Server:GetDescendants() do
	if not Module:IsA("ModuleScript") then continue end
	pcall(require, Module) -- Required module to start it off
end

Global.Schedule:Boot()
