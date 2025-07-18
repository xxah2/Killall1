-- Crear GUI flotante
local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer

local gui = Instance.new("ScreenGui")
gui.Name = "KillAllGui"
gui.ResetOnSpawn = false

if syn and syn.protect_gui then
    syn.protect_gui(gui)
end

gui.Parent = game:GetService("CoreGui")

-- Fondo semi-transparente para facilitar toque en móviles
local background = Instance.new("Frame")
background.Size = UDim2.new(0, 200, 0, 70)
background.Position = UDim2.new(0, 15, 0, 15)
background.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
background.BackgroundTransparency = 0.3
background.Parent = gui
background.ZIndex = 9
background.Active = true
background.Draggable = true

-- Botón de matar
local btn = Instance.new("TextButton")
btn.Size = UDim2.new(1, -20, 1, -20)
btn.Position = UDim2.new(0, 10, 0, 10)
btn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
btn.TextColor3 = Color3.fromRGB(255, 255, 255)
btn.Font = Enum.Font.SourceSansBold
btn.TextSize = 24
btn.Text = "💀 KILL ALL (EXCEPTO YO)"
btn.Parent = background
btn.BorderSizePixel = 0
btn.BackgroundTransparency = 0.05
btn.ZIndex = 10

-- Función para matar jugador (Prison Life)
local function killPlayer(targetPlayer)
    if not targetPlayer.Character then return end
    local char = targetPlayer.Character

    -- Eliminar ForceField para evitar invencibilidad
    local ff = char:FindFirstChildOfClass("ForceField")
    if ff then
        ff:Destroy()
    end

    -- Eliminar scripts de regeneración o curación (según nombres comunes en Prison Life)
    for _, obj in ipairs(char:GetChildren()) do
        if obj:IsA("Script") or obj:IsA("LocalScript") then
            local nameLower = obj.Name:lower()
            if nameLower:find("regen") or nameLower:find("heal") or nameLower:find("recover") then
                obj:Destroy()
            end
        end
    end

    -- Intentar eliminar cualquier evento de regeneración o conexión peligrosa
    -- (Ejemplo: conexiones en Humanoid.HealthChanged que regeneran)
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if humanoid then
        -- Forzar salud a 0 para matar
        humanoid.Health = 0

        -- También forzar estado muerto
        humanoid:ChangeState(Enum.HumanoidStateType.Dead)
    end
end

-- Confirmación para evitar toque accidental (en móviles es importante)
local confirm = false
btn.MouseButton1Click:Connect(function()
    if not confirm then
        btn.Text = "¿CONFIRMAR? 🔥"
        confirm = true
        -- Resetear confirmación en 3 segundos
        delay(3, function()
            confirm = false
            btn.Text = "💀 KILL ALL (EXCEPTO YO)"
        end)
        return
    end

    -- Confirmado: matar a todos menos a localPlayer
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= localPlayer then
            killPlayer(player)
        end
    end

    btn.Text = "✔ TODOS MUERTOS"
    wait(2)
    btn.Text = "💀 KILL ALL (EXCEPTO YO)"
    confirm = false
end)
