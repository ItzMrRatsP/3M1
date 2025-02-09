local players = game:GetService("Players")
local runService = game:GetService("RunService")
local camera = workspace.CurrentCamera
local uis = game:GetService("UserInputService")

local function lerp(a, b, c)
	return a + (b - a) * c
end

local CameraHandler = {}
CameraHandler.__index = CameraHandler

function CameraHandler.new(character)
	local self = setmetatable({}, CameraHandler)
	self.character = character
	self.humanoid = character.Humanoid
	self.enabled = false
	self.bobbingConnection = nil

	self.horizontalBobbing = 0
	self.verticalBobbing = 0
	self.angleBobbing = 0
	self.forwardBobbing = 0
	self.lateralBobbing = 0
	self.walkBobbingFrequency = 5
	self.walkBobbingAmplitude = 5
	self.smoothedLookVector = camera.CFrame.LookVector
	self.trueDirection = camera.CFrame

	return self
end

function CameraHandler:Enable()
	if self.enabled then
		return
	end
	self.enabled = true

	self.bobbingConnection = runService.RenderStepped:Connect(
		function(deltaTime)
			deltaTime = deltaTime * 60

			local rootPart = self.character.Root
			local rootMagnitude = rootPart
					and Vector3.new(
						rootPart.Velocity.X,
						0,
						rootPart.Velocity.Z
					).Magnitude
				or 0
			local calcRootMagnitude = math.min(rootMagnitude * 2, 25)

			if deltaTime > 1.5 then
				self.horizontalBobbing = 0
				self.verticalBobbing = 0
			else
				self.horizontalBobbing = lerp(
					self.horizontalBobbing,
					math.cos(tick() * 0.5 * math.random(5, 7.5))
						* (math.random(2.5, 10) / 100)
						* deltaTime,
					0.05 * deltaTime
				)
				self.verticalBobbing = lerp(
					self.verticalBobbing,
					math.cos(tick() * 0.5 * math.random(2.5, 5))
						* (math.random(1, 5) / 100)
						* deltaTime,
					0.05 * deltaTime
				)
			end

			camera.CFrame = camera.CFrame
				* (
					CFrame.fromEulerAnglesXYZ(
						0,
						0,
						math.rad(self.angleBobbing)
					)
					* CFrame.fromEulerAnglesXYZ(
						math.rad(self.forwardBobbing * deltaTime),
						math.rad(self.lateralBobbing * deltaTime),
						0
					)
					* CFrame.Angles(
						0,
						0,
						math.rad(
							self.forwardBobbing
								* deltaTime
								* (calcRootMagnitude / 5)
						)
					)
					* CFrame.fromEulerAnglesXYZ(
						math.rad(self.horizontalBobbing),
						math.rad(self.verticalBobbing),
						math.rad(self.verticalBobbing * 10)
					)
				)

			self.lateralBobbing = math.clamp(
				lerp(
					self.lateralBobbing,
					-camera.CFrame:VectorToObjectSpace(
							(
								rootPart
									and rootPart.Velocity
								or Vector3.new()
							)
								/ math.max(
									self.humanoid.WalkSpeed,
									0.01
								)
						).X * 0.04,
					0.1 * deltaTime
				),
				-0.12,
				0.1
			)
			self.angleBobbing = lerp(
				self.angleBobbing,
				math.clamp(uis:GetMouseDelta().X, -2.5, 2.5),
				0.25 * deltaTime
			)
			self.forwardBobbing = lerp(
				self.forwardBobbing,
				math.sin(tick() * self.walkBobbingFrequency)
					/ 5
					* math.min(1, self.walkBobbingAmplitude / 10),
				0.25 * deltaTime
			)

			if rootMagnitude > 1 then
				self.lateralBobbing = lerp(
					self.lateralBobbing,
					math.cos(
						tick()
							* 0.5
							* math.floor(
								self.walkBobbingFrequency
							)
					) * (self.walkBobbingFrequency / 200),
					0.25 * deltaTime
				)
			else
				self.lateralBobbing =
					lerp(self.lateralBobbing, 0, 0.05 * deltaTime)
			end

			if rootMagnitude > 6 then
				self.walkBobbingFrequency = 10
				self.walkBobbingAmplitude = 4
			elseif rootMagnitude > 0.1 then
				self.walkBobbingFrequency = 6
				self.walkBobbingAmplitude = 7
			else
				self.walkBobbingAmplitude = 0
			end

			self.smoothedLookVector = lerp(
				self.smoothedLookVector,
				camera.CFrame.LookVector,
				0.125 * deltaTime
			)
		end
	)
end

function CameraHandler:Disable()
	if not self.enabled then
		return
	end
	self.enabled = false

	if self.bobbingConnection then
		self.bobbingConnection:Disconnect()
		self.bobbingConnection = nil
	end
end

function CameraHandler:Destroy()
	self:Disable()
end

return CameraHandler
