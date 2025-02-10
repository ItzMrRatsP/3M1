local ReplicatedStorage = game:GetService("ReplicatedStorage")

export type PossiblePreset = "DayPreset" | "NightPreset"
export type Preset = {
	LightingSettings: {
		Ambient: Color3,
		Brightness: number,
		ColorShift_Bottom: Color3,
		ColorShift_Top: Color3,
		EnvironmentDiffuseScale: number,
		EnvironmentSpecularScale: number,
		OutdoorAmbient: Color3,
		ShadowSoftness: number,
		ClockTime: number,
	},

	Config: Folder,
}

return {
	DayPreset = {
		LightingSettings = {
			Ambient = Color3.fromRGB(112, 170, 99),
			Brightness = 5,
			ColorShift_Bottom = Color3.new(1, 1, 1),
			ColorShift_Top = Color3.new(1, 1, 1),
			EnvironmentDiffuseScale = 0,
			EnvironmentSpecularScale = 0,
			OutdoorAmbient = Color3.new(1, 1, 1),
			ShadowSoftness = 0.2,
			ClockTime = 12,
		},

		Config = ReplicatedStorage.Assets.Presets:FindFirstChild(
			"DayPreset"
		),
	},

	NightPreset = {
		LightingSettings = {
			Ambient = Color3.fromRGB(129, 129, 129),
			Brightness = 4,
			ColorShift_Bottom = Color3.new(0, 0, 0),
			ColorShift_Top = Color3.new(0, 0, 0),
			EnvironmentDiffuseScale = 0,
			EnvironmentSpecularScale = 0,
			OutdoorAmbient = Color3.new(0, 0, 0),
			ShadowSoftness = 0.2,
			ClockTime = 0,
		},

		Config = ReplicatedStorage.Assets.Presets:FindFirstChild(
			"NightPreset",
			true
		),
	},
} :: { [PossiblePreset]: Preset }
