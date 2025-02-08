for _, componentModule in script.ComponentsFolder:GetChildren() do
	if not componentModule:IsA("ModuleScript") then
		continue
	end
	require(componentModule)
end
