local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local Janitor = require(ReplicatedStorage.Packages.Janitor)
local Presets = require(script.Modules.Presets)

local janitor = Janitor.new()

local LightingPresets = {}

function LightingPresets.setPreset(Preset: Presets.PossiblePreset)
	if not Presets[Preset] then
		return
	end

	local PresetAsset = Presets[Preset]

	for Name, Value in PresetAsset.LightingSettings do
		if not Lighting[Name] then
			return
		end

		TweenService:Create(
			Lighting[Name],
			TweenInfo.new(0.45, Enum.EasingStyle.Linear),
			{ Value = Value }
		):Play()
	end

	local Config = janitor:Add(PresetAsset.Config:Clone())
	Config.Parent = Lighting

	for _, child in Config:GetChildren() do
		janitor:Add(child)
		child.Parent = child.Parent.Parent
	end
end

return LightingPresets
