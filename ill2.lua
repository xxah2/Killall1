-- Servicios
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

-- Crear GUI
local gui = Instance.new("ScreenGui")
gui.Name = "KillAllGui"
gui.ResetOnSpawn = false

if syn and syn.protect_gui then
    syn.protect_gui(gui)
end
gui.Parent = game:GetService("CoreGui")

-- Frame táctil para Android
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 220, 0, 70)
frame.Position = UDim2.new(0, 20, 0, 20)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BackgroundTransparency = 0.3
frame.Parent = gui
frame.Active = true
frame.Draggable = true

-- Botón
local btn = Instance.new("TextButton")
btn.Size = UDim2.new(1, -20, 1, -20)
btn.Position = UDim2.new(0, 10, 0, 10)
btn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
btn.TextColor3 = Color3.fromRGB(255, 255, 255)
btn.Font = Enum.Font.SourceSansBold
btn.TextSize = 22
btn.Text = "💀 KILL ALL (NO PERMISOS)"
btn.Parent = frame
btn.BorderSizePixel = 0
btn.ZIndex = 10

-- Función que mata usando rompimiento de Joints
local function killTarget(char)
    if not char then return end

    -- Destruir ForceField
    local ff = char:FindFirstChildOfClass("ForceField")
    if ff then ff:Destroy() end

    -- Eliminar posibles scripts de curación
    for _, obj in ipairs(char:GetChildren()) do
        if obj:IsA("Script") and obj.Name:lower():find("regen") then
            obj:Destroy()
        end
    end

    -- Forzar muerte sin permisos:
    -- Método 1: Romper joints de todas las partes
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part:BreakJoints()
        end
    end

    -- Método 2: Clonar y destruir el humanoid para resetear bindings
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if humanoid then
        local clone = humanoid:Clone()
        humanoid:Destroy()
        clone.Parent = char
        clone.Health = 0
        clone:ChangeState(Enum.HumanoidStateType.Dead)
    end
end

-- Ejecutar al hacer clic
btn.MouseButton1Click:Connect(function()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            killTarget(plr.Character)
        end
    end
    btn.Text = "✔ MUERTOS"
    wait(2)
    btn.Text = "💀 KILL ALL (NO PERMISOS)"
end)
