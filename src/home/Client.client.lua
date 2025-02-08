local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Global = require(ReplicatedStorage.Global)

for _, Module in ReplicatedStorage.Client:GetDescendants() do
	if not Module:IsA("ModuleScript") then
		continue
	end
	pcall(require, Module) -- Required module to start it off
end

Global.Schedule:Boot()
