local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")

local GameUtil = {}
local RNG = Random.new()

local Camera = workspace.CurrentCamera

function GameUtil.SetValue(
	Main: number,
	Value: number,
	Max: number?,
	DefaultValue: number
): number
	if Main + Value > Max then
		return DefaultValue
	end

	return Main + Value
end

function GameUtil.Destroy(Time: number, Instance: Instance): Instance
	task.delay(Time, function()
		Instance:Destroy()
	end)

	return Instance :: typeof(Instance)
end

function GameUtil.debounce(callback)
	local db = false

	return function(...)
		if db then
			return
		end
		db = true

		task.spawn(function(...)
			callback(...)
			db = false
		end, ...)
	end
end

function GameUtil.doUnpack(V: { any })
	return typeof(V) ~= "table" and V or table.unpack(V)
end

function GameUtil:OnCameraView(Pos: Vector3): boolean
	return (Pos - Camera.CFrame.Position).Unit:Dot(Camera.CFrame.LookVector)
		> 0
end

function GameUtil.selectRandom(t: { any })
	if #t <= 0 then
		return
	end
	if #t <= 1 then
		return t[1]
	end

	local randomIndex = RNG:NextInteger(1, #t)
	return t[randomIndex]
end

function GameUtil.tweenModel(model: Model, info, newCF: CFrame)
	local CFrameValue = Instance.new("CFrameValue")
	CFrameValue.Value = model:GetPivot()

	CFrameValue:GetPropertyChangedSignal("Value"):Connect(function()
		model:PivotTo(CFrameValue.Value)
	end)

	local tween = TweenService:Create(CFrameValue, info, { Value = newCF })
	return tween
end

local classTypeTransparency = {
	ImageLabel = "ImageTransparency",
	TextLabel = "TextTransparency",
}

function GameUtil.setUITransparency(
	arr: { GuiObject? },
	info,
	newTransparency: number,
	fromTransparency: number
)
	local NumberValue = Instance.new("NumberValue")
	NumberValue.Value = fromTransparency or 0

	NumberValue:GetPropertyChangedSignal("Value"):Connect(function()
		for _, object in arr do
			if not object:IsA("GuiObject") then
				continue
			end
			if object:IsA("Frame") then
				continue
			end
			object[classTypeTransparency[object.ClassName]] =
				NumberValue.Value
		end
	end)

	local tween =
		TweenService:Create(NumberValue, info, { Value = newTransparency })
	return tween
end

function GameUtil.setModelTransparency(
	model,
	info,
	newTransparency: number,
	fromTransparency: number
)
	local NumberValue = Instance.new("NumberValue")
	NumberValue.Value = fromTransparency or 0

	NumberValue:GetPropertyChangedSignal("Value"):Connect(function()
		for _, instance in model:GetChildren() do
			if not instance:IsA("BasePart") then
				continue
			end
			if instance == model.PrimaryPart then
				continue
			end

			instance.Transparency = NumberValue.Value
		end
	end)

	local tween =
		TweenService:Create(NumberValue, info, { Value = newTransparency })
	return tween
end

function GameUtil.getTableLength(t)
	local length = 0

	for _, _ in t do
		length += 1
	end

	return length
end

function GameUtil.getWeighted(weights, prizes)
	local weight = 0

	for _, w in weights do
		weight += w
	end

	weight = RNG:NextNumber() * weight -- random weight

	for i, w in weights do
		weight -= w
		if weight <= 0 then
			return prizes[i]
		end
	end

	return prizes[GameUtil.getTableLength(prizes)]
end

function GameUtil.playSound(name: string)
	local sound = ReplicatedStorage.Assets.Sounds:FindFirstChild(name, true)

	if not sound then
		return
	end

	if not sound:IsA("Sound") then
		return
	end

	if not RunService:IsClient() then
		warn("Runs on client only!")
		return
	end

	SoundService:PlayLocalSound(sound)
end

function GameUtil.weld(b1: BasePart?, b2: BasePart?)
	-- check
	if not b1 or not b2 then
		return
	end

	local weld = Instance.new("Weld")
	weld.Part0 = b1
	weld.Part1 = b2
	weld.C0 = b1.CFrame:ToObjectSpace(b2.CFrame)
	weld.Parent = b1
end

function GameUtil.arrtodictsorted(arr: { any }): { [any]: number }
	local t = {}

	for index, value in arr do
		t[value] = index
	end

	return t
end

function GameUtil.getIndex(arr: { any })
	local t = {}

	for index, _ in arr do
		t[index] = index
	end

	return t
end

function GameUtil.squaredDist(pos1: Vector3, pos2: Vector3)
	local v = pos1 - pos2
	return v:Dot(v)
end

function GameUtil.getKeys(arr: { [any]: any }): { [number]: any }
	local keys = {}

	for key, _ in arr do
		table.insert(keys, key)
	end

	return keys -- {[A] = B} -> {A}
end

function GameUtil.getValues(arr: { [any]: any }): { [number]: any }
	local values = {}

	for _, value in arr do
		table.insert(values, value)
	end

	return values -- {[A] = B} -> {B}
end

function GameUtil.dicttoarr(arr: { any })
	local t = {}

	for _, value in arr do
		table.insert(t, value)
	end

	return t
end

function GameUtil.arrtodict(arr: { any })
	local dict = {}

	for _, value in arr do
		dict[value] = value
	end

	return dict
end

function GameUtil.search<T>(array, predict: (T) -> boolean)
	local final = {}

	for index, value in array do
		if not predict(value) then
			continue
		end
		final[index] = value
	end

	return final
end

function GameUtil.getbiggestValue<T>(
	array,
	predict: (current: T, new: T) -> boolean
)
	local result = nil

	for _, value in array do
		if not result then
			result = value
			continue
		end

		if not predict(result, value) then
			continue
		end
		result = value
	end

	return result
end

function GameUtil.getSmallestValue<T>(
	array,
	predict: (current: T, new: T) -> boolean
)
	local result = nil

	for _, value in array do
		if not result then
			result = value
			continue
		end

		if not predict(result, value) then
			continue
		end
		result = value
	end

	return result
end

return GameUtil
