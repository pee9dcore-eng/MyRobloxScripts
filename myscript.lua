-- [[ MADE BY PEENIGHTCORE ]] --
-- Version: V12 (Minimize UI + Large Text ESP + Pro Aim)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local Settings = {
    Aimlock = false,
    Prediction = 0.012,
    AimPart = "Head",
    ESP = false,
    InfJump = false,
    Noclip = false
}

-- // [ UI SYSTEM V12 ]
local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 230, 0, 350)
Main.Position = UDim2.new(0.05, 0, 0.3, 0)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main)

local Header = Instance.new("Frame", Main)
Header.Size = UDim2.new(1, 0, 0, 40)
Header.BackgroundTransparency = 1

local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(1, -40, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.Text = "PEENIGHTCORE V12"
Title.TextColor3 = Color3.fromRGB(0, 255, 150)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BackgroundTransparency = 1

-- // [ MINIMIZE SYSTEM ]
local Content = Instance.new("Frame", Main)
Content.Size = UDim2.new(1, 0, 1, -40)
Content.Position = UDim2.new(0, 0, 0, 40)
Content.BackgroundTransparency = 1

local MiniBtn = Instance.new("TextButton", Main)
MiniBtn.Size = UDim2.new(0, 30, 0, 30)
MiniBtn.Position = UDim2.new(1, -35, 0, 5)
MiniBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MiniBtn.Text = "-"
MiniBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MiniBtn.Font = Enum.Font.GothamBold
MiniBtn.TextSize = 20
Instance.new("UICorner", MiniBtn)

local IsMinimized = false
MiniBtn.MouseButton1Click:Connect(function()
    IsMinimized = not IsMinimized
    if IsMinimized then
        Main:TweenSize(UDim2.new(0, 230, 0, 40), "Out", "Quad", 0.3, true)
        Content.Visible = false
        MiniBtn.Text = "+"
    else
        Main:TweenSize(UDim2.new(0, 230, 0, 350), "Out", "Quad", 0.3, true)
        Content.Visible = true
        MiniBtn.Text = "-"
    end
end)

local Scroll = Instance.new("ScrollingFrame", Content)
Scroll.Size = UDim2.new(1, -20, 1, -20)
Scroll.Position = UDim2.new(0, 10, 0, 10)
Scroll.BackgroundTransparency = 1
Scroll.ScrollBarThickness = 0
Instance.new("UIListLayout", Scroll).Padding = UDim.new(0, 8)

local function AddToggle(name, setting)
    local Btn = Instance.new("TextButton", Scroll)
    Btn.Size = UDim2.new(1, 0, 0, 40)
    Btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Btn.Text = "  " .. name
    Btn.TextColor3 = Color3.fromRGB(150, 150, 150)
    Btn.Font = Enum.Font.GothamSemibold
    Btn.TextSize = 12
    Btn.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", Btn)

    local Status = Instance.new("Frame", Btn)
    Status.Size = UDim2.new(0, 25, 0, 12)
    Status.Position = UDim2.new(1, -35, 0.5, -6)
    Status.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Instance.new("UICorner", Status).CornerRadius = UDim.new(1, 0)

    Btn.MouseButton1Click:Connect(function()
        Settings[setting] = not Settings[setting]
        Status.BackgroundColor3 = Settings[setting] and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(50, 50, 50)
        Btn.TextColor3 = Settings[setting] and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(150, 150, 150)
    end)
end

-- // [ ELITE ESP V12 - LARGE TEXT ]
local function CreateESP(player)
    local Box = Drawing.new("Square")
    local HealthBarBg = Drawing.new("Square")
    local HealthBar = Drawing.new("Square")
    local NameTag = Drawing.new("Text")

    RunService.RenderStepped:Connect(function()
        if Settings.ESP and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") and player ~= LocalPlayer then
            local Root = player.Character.HumanoidRootPart
            local Hum = player.Character.Humanoid
            local Pos, OnScreen = Camera:WorldToViewportPoint(Root.Position)

            if OnScreen then
                local Size = Vector2.new(2000 / Pos.Z, 3000 / Pos.Z)
                local TopLeft = Vector2.new(Pos.X - Size.X / 2, Pos.Y - Size.Y / 2)

                Box.Visible = true
                Box.Size = Size
                Box.Position = TopLeft
                Box.Color = Color3.fromRGB(0, 255, 150)
                Box.Thickness = 1

                HealthBarBg.Visible = true
                HealthBarBg.Size = Vector2.new(2, Size.Y)
                HealthBarBg.Position = Vector2.new(TopLeft.X - 5, TopLeft.Y)
                HealthBarBg.Color = Color3.fromRGB(0, 0, 0)
                HealthBarBg.Filled = true

                HealthBar.Visible = true
                local hRatio = Hum.Health / Hum.MaxHealth
                HealthBar.Size = Vector2.new(2, Size.Y * hRatio)
                HealthBar.Position = Vector2.new(TopLeft.X - 5, TopLeft.Y + (Size.Y * (1 - hRatio)))
                HealthBar.Color = Color3.fromHSV(hRatio * 0.3, 1, 1)
                HealthBar.Filled = true

                local Dist = math.floor((Root.Position - Camera.CFrame.Position).Magnitude)
                NameTag.Visible = true
                NameTag.Text = player.Name .. " [" .. Dist .. "m]"
                NameTag.Size = 18 -- ใหญ่สะใจ
                NameTag.Center = true
                NameTag.Outline = true -- ขอบดำ
                NameTag.OutlineColor = Color3.fromRGB(0, 0, 0)
                NameTag.Position = Vector2.new(Pos.X, TopLeft.Y - 25)
                NameTag.Color = Color3.fromRGB(255, 255, 255)
            else
                Box.Visible = false; HealthBarBg.Visible = false; HealthBar.Visible = false; NameTag.Visible = false
            end
        else
            Box.Visible = false; HealthBarBg.Visible = false; HealthBar.Visible = false; NameTag.Visible = false
        end
    end)
end

for _, v in pairs(Players:GetPlayers()) do CreateESP(v) end
Players.PlayerAdded:Connect(CreateESP)

-- // AIMLOCK / JUMP / NOCLIP
local Target = nil
UserInputService.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton2 then
    local d = math.huge
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Head") then
            local p, vis = Camera:WorldToViewportPoint(v.Character.Head.Position)
            if vis then
                local m = (Vector2.new(p.X, p.Y) - UserInputService:GetMouseLocation()).Magnitude
                if m < d then d = m; Target = v end
            end
        end
    end
end end)
UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton2 then Target = nil end end)

RunService.RenderStepped:Connect(function()
    if Settings.Aimlock and Target and Target.Character and Target.Character:FindFirstChild("Head") then
        local H = Target.Character.Head
        Camera.CFrame = CFrame.new(Camera.CFrame.Position, H.Position + (H.Velocity * Settings.Prediction))
    end
    if Settings.Noclip and LocalPlayer.Character then
        for _, v in pairs(LocalPlayer.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
    end
end)

UserInputService.JumpRequest:Connect(function()
    if Settings.InfJump and LocalPlayer.Character then LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState(3) end
end)

AddToggle("Aimlock (Head)", "Aimlock")
AddToggle("Pro ESP (Large)", "ESP")
AddToggle("Infinite Jump", "InfJump")
AddToggle("Noclip", "Noclip")
