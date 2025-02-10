local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Fusion = require(ReplicatedStorage.Packages.Fusion)

local Scoped = Fusion.scoped(Fusion)
local Children = Fusion.Children

local function Typewritter(Text, MainText, Speed)
	Speed = Speed or 1

	for letter in utf8.graphemes(Text) do
		local current = string.sub(Text, letter, letter)
		MainText:set(Fusion.peek(MainText) .. current)

		if current == "-" or current == "," then
			task.wait(0.35 / Speed)
		elseif current == "." then
			task.wait(0.25 / Speed)
		end

		task.wait(0.045 / Speed)
	end
end

return function(Text: string, Speed)
	local OurText = Scoped:Value("")
	task.spawn(Typewritter, Text, OurText, Speed)

	return Scoped:New("ScreenGui") {
		Name = "Subtitles",
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		Parent = Players.LocalPlayer.PlayerGui,

		[Children] = {
			Scoped:New("TextLabel") {
				Name = "Text",
				FontFace = Font.new("rbxassetid://16658246179"),
				Text = OurText,
				TextColor3 = Color3.fromRGB(255, 255, 255),
				TextScaled = true,
				TextSize = 14,
				TextWrapped = true,
				AnchorPoint = Vector2.new(0.5, 0.5),
				AutomaticSize = Enum.AutomaticSize.XY,
				BackgroundColor3 = Color3.fromRGB(0, 0, 0),
				BackgroundTransparency = 0.75,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Position = UDim2.fromScale(0.5, 0.975),
				Size = UDim2.fromScale(0.223, 0.0195),

				[Children] = {
					Scoped:New("UITextSizeConstraint") {
						Name = "UITextSizeConstraint",
						MaxTextSize = 15,
					},
				},
			},
		},
	}
end
