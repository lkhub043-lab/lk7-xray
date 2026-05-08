-- [[ MENU ALVO: APENAS BRAINROTS E BASES ]] --

local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local ToggleBtn = Instance.new("TextButton")
local SliderFrame = Instance.new("Frame")
local SliderButton = Instance.new("TextButton")
local SliderLabel = Instance.new("TextLabel")

-- Configuração da Interface
ScreenGui.Parent = game.CoreGui
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MainFrame.BackgroundTransparency = 0.6
MainFrame.Position = UDim2.new(0.4, 0, 0.4, 0)
MainFrame.Size = UDim2.new(0, 220, 0, 110)
MainFrame.Active = true
MainFrame.Draggable = true 

-- Botão de Ligar/Desligar
ToggleBtn.Parent = MainFrame
ToggleBtn.Position = UDim2.new(0.05, 0, 0.15, 0)
ToggleBtn.Size = UDim2.new(0.9, 0, 0, 40)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
ToggleBtn.BackgroundTransparency = 0.3
ToggleBtn.Text = "TRANSPARENCY: ON"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 14

-- Slider
SliderFrame.Parent = MainFrame
SliderFrame.Position = UDim2.new(0.05, 0, 0.75, 0)
SliderFrame.Size = UDim2.new(0.7, 0, 0, 6)
SliderFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SliderFrame.BorderSizePixel = 0

SliderButton.Parent = SliderFrame
SliderButton.Size = UDim2.new(0, 14, 0, 14)
SliderButton.Position = UDim2.new(1, -7, -0.5, 0)
SliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SliderButton.Text = ""

SliderLabel.Parent = MainFrame
SliderLabel.Position = UDim2.new(0.8, 0, 0.68, 0)
SliderLabel.Size = UDim2.new(0, 35, 0, 20)
SliderLabel.BackgroundTransparency = 1
SliderLabel.Text = "100%"
SliderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
SliderLabel.Font = Enum.Font.Gotham
SliderLabel.TextSize = 12

-- LÓGICA DE FILTRO --

local isActive = true
local currentTrans = 1

-- Nomes de pastas ou modelos que o script vai afetar
local alvos = {"Brain", "Drop", "Base", "Tycoon", "Object", "Collection"}

local function eAlvo(obj)
    local nome = obj.Name:lower()
    local paiNome = (obj.Parent and obj.Parent.Name:lower()) or ""
    
    for _, termo in pairs(alvos) do
        if nome:find(termo:lower()) or paiNome:find(termo:lower()) then
            return true
        end
    end
    return false
end

local function apply()
    if not isActive then return end
    for _, obj in pairs(game.Workspace:GetDescendants()) do
        if (obj:IsA("BasePart") or obj:IsA("MeshPart")) and eAlvo(obj) then
            if not obj:IsDescendantOf(game.Players.LocalPlayer.Character) then
                obj.Transparency = currentTrans
            end
        end
    end
end

ToggleBtn.MouseButton1Click:Connect(function()
    isActive = not isActive
    ToggleBtn.Text = isActive and "TRANSPARENCY: ON" or "TRANSPARENCY: OFF"
    
    if not isActive then
        for _, obj in pairs(game.Workspace:GetDescendants()) do
            if (obj:IsA("BasePart") or obj:IsA("MeshPart")) and eAlvo(obj) then
                obj.Transparency = 0
            end
        end
    else
        apply()
    end
end)

-- Slider Drag
local dragging = false
SliderButton.MouseButton1Down:Connect(function() dragging = true end)
game:GetService("UserInputService").InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
end)

game:GetService("RunService").RenderStepped:Connect(function()
    if dragging then
        local mousePos = game:GetService("UserInputService"):GetMouseLocation().X
        local framePos = SliderFrame.AbsolutePosition.X
        local frameSize = SliderFrame.AbsoluteSize.X
        local percent = math.clamp((mousePos - framePos) / frameSize, 0, 1)
        SliderButton.Position = UDim2.new(percent, -7, -0.5, 0)
        currentTrans = percent
        SliderLabel.Text = math.floor(percent * 100) .. "%"
        if isActive then apply() end
    end
end)

-- Auto-apply para novos itens que nascerem
game.Workspace.DescendantAdded:Connect(function(v)
    task.wait(0.2)
    if isActive and eAlvo(v) then
        if v:IsA("BasePart") or v:IsA("MeshPart") then
            v.Transparency = currentTrans
        end
    end
end)

apply()
