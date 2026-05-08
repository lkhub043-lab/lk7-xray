-- [[ BRAINROT X-RAY - INÍCIO EM 50% ]] --

local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local ToggleBtn = Instance.new("TextButton")
local SliderFrame = Instance.new("Frame")
local SliderButton = Instance.new("Frame")
local SliderLabel = Instance.new("TextLabel")
local Title = Instance.new("TextLabel")

-- Interface Setup
ScreenGui.Parent = game.CoreGui
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MainFrame.BackgroundTransparency = 0.6
MainFrame.Position = UDim2.new(0.5, -110, 0.5, -55)
MainFrame.Size = UDim2.new(0, 220, 0, 110)
MainFrame.Active = true
MainFrame.Draggable = true 

Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 25)
Title.BackgroundTransparency = 1
Title.Text = "BRAINROT X-RAY"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 12

ToggleBtn.Parent = MainFrame
ToggleBtn.Position = UDim2.new(0.05, 0, 0.3, 0)
ToggleBtn.Size = UDim2.new(0.9, 0, 0, 35)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ToggleBtn.Text = "TRANSPARENCY: ON"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.BorderSizePixel = 0

SliderFrame.Name = "SliderFrame"
SliderFrame.Parent = MainFrame
SliderFrame.Position = UDim2.new(0.05, 0, 0.75, 0)
SliderFrame.Size = UDim2.new(0.7, 0, 0, 6)
SliderFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SliderFrame.BorderSizePixel = 0

-- AJUSTE INICIAL: Posicionado no meio (50%)
SliderButton.Name = "SliderButton"
SliderButton.Parent = SliderFrame
SliderButton.Size = UDim2.new(0, 14, 0, 14)
SliderButton.Position = UDim2.new(0.5, -7, -0.5, 0) -- 0.5 é 50%
SliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SliderButton.BorderSizePixel = 0

SliderLabel.Parent = MainFrame
SliderLabel.Position = UDim2.new(0.8, 0, 0.68, 0)
SliderLabel.Size = UDim2.new(0, 35, 0, 20)
SliderLabel.BackgroundTransparency = 1
SliderLabel.Text = "50%"
SliderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
SliderLabel.TextSize = 12

-- Lógica de Filtro
local isActive = true
local currentTrans = 0.5 -- Começa em 50%
local dragging = false 
local alvos = {"Brain", "Drop", "Base", "Tycoon", "Object", "Collection"}

local function eAlvo(obj)
    local n = obj.Name:lower()
    local p = (obj.Parent and obj.Parent.Name:lower()) or ""
    for _, t in pairs(alvos) do if n:find(t:lower()) or p:find(t:lower()) then return true end end
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
            if (obj:IsA("BasePart") or obj:IsA("MeshPart")) and eAlvo(obj) then obj.Transparency = 0 end
        end
    else
        apply()
    end
end)

local UIS = game:GetService("UserInputService")

UIS.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        local mPos = UIS:GetMouseLocation()
        local sPos = SliderFrame.AbsolutePosition
        local sSize = SliderFrame.AbsoluteSize
        
        if mPos.X >= sPos.X - 10 and mPos.X <= sPos.X + sSize.X + 10 and
           mPos.Y >= sPos.Y - 10 and mPos.Y <= sPos.Y + sSize.Y + 20 then
            dragging = true
        end
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

game:GetService("RunService").RenderStepped:Connect(function()
    if dragging then
        local mousePos = UIS:GetMouseLocation().X
        local framePos = SliderFrame.AbsolutePosition.X
        local frameSize = SliderFrame.AbsoluteSize.X
        local percent = math.clamp((mousePos - framePos) / frameSize, 0, 1)
        
        SliderButton.Position = UDim2.new(percent, -7, -0.5, 0)
        currentTrans = percent
        SliderLabel.Text = math.floor(percent * 100) .. "%"
        
        if isActive then apply() end
    end
end)

game.Workspace.DescendantAdded:Connect(function(v)
    task.wait(0.2)
    if isActive and eAlvo(v) and (v:IsA("BasePart") or v:IsA("MeshPart")) then
        v.Transparency = currentTrans
    end
end)

-- Execução Inicial
apply()
