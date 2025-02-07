local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LemonSignal = require(ReplicatedStorage.Packages.LemonSignal)

type Signal = LemonSignal.Signal<...any>

local Signals = {}

Signals.ActiveSignals = {}
Signals.NewSignal = LemonSignal.new()

function Signals:Get(Name: string): Signal
	if self.ActiveSignals[Name] then
		return self.ActiveSignals[Name]
	end

	self.ActiveSignals[Name] = LemonSignal.new()
	self.NewSignal:Fire(Name)

	return self.ActiveSignals[Name] :: Signal
end

function Signals:Remove(Name: string): ()
	if not self.ActiveSignals[Name] then
		return
	end
	self.ActiveSignals[Name] = nil
end

function Signals:Load(Name: string, Callback
): LemonSignal.Connection<...any>
	if self.ActiveSignals[Name] then
		return self.ActiveSignals[Name]:Connect(Callback)
	end

	return self.NewSignal:Connect(function(SignalName: string)
		if SignalName ~= Name then
			return
		end

		self.ActiveSignals[Name]:Connect(Callback)
	end)
end

return Signals
