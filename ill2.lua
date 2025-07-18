-- Crear GUI flotante
local gui = Instance.new("ScreenGui")
gui.Name = "KillAllGui"
gui.ResetOnSpawn = false

if syn and syn.protect_gui then
	syn.protect_gui(gui)
end

gui.Parent = game:GetService("CoreGui")

-- Botón de matar
local btn = Instance.new("TextButton")
btn.Size = UDim2.new(0, 160, 0, 45)
btn.Position = UDim2.new(0, 15, 0, 15)
btn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
btn.TextColor3 = Color3.fromRGB(255, 255, 255)
btn.Font = Enum.Font.SourceSansBold
btn.TextSize = 20
btn.Text = "💀 KILL ALL (EXCEPTO YO)"
btn.Parent = gui
btn.BorderSizePixel = 0
btn.BackgroundTransparency = 0.05
btn.ZIndex = 10

-- Función al presionar
btn.MouseButton1Click:Connect(function()
	local localPlayer = game.Players.LocalPlayer

	for _, target in pairs(game.Players:GetPlayers()) do
		if target ~= localPlayer and target.Character then
			local char = target.Character

			-- Destruir ForceField
			local ff = char:FindFirstChildOfClass("ForceField")
			if ff then ff:Destroy() end

			-- Eliminar posibles scripts de regeneración
			for _, obj in ipairs(char:GetChildren()) do
				if obj:IsA("Script") and obj.Name:lower():find("regen") then
					obj:Destroy()
				end
			end

			-- Forzar muerte real reemplazando el Humanoid
			local oldHumanoid = char:FindFirstChildOfClass("Humanoid")
			if oldHumanoid then
				local newHumanoid = oldHumanoid:Clone()
				oldHumanoid:Destroy()
				newHumanoid.Parent = char
				newHumanoid:TakeDamage(newHumanoid.MaxHealth + 100)
			end
		end
	end
end)
