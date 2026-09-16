-- LocalScript в StarterPlayerScripts (только для СВОЕЙ игры)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LP = Players.LocalPlayer

-- ================= НАСТРОЙКИ =================
local Config = {
    ESP = true,
    Box = true,
    Name = true,
    HP = true,
    Tool = true,
    Chams = true,
    Skeleton = true,         -- ← скелет
    Aimbot = false,
    Fly = false,
    Noclip = false,
    FlySpeed = 50,
    FOV = 100,
    FIRE_RATE = 0.1,
}

local Keybinds = {
    ESP      = nil,
    Box      = nil,
    Name     = nil,
    HP       = nil,
    Tool     = nil,
    Chams    = nil,
    Skeleton = nil,
    Aimbot   = Enum.KeyCode.Q,
    Fly      = Enum.KeyCode.F,
    Noclip   = Enum.KeyCode.V,
    Menu     = Enum.KeyCode.Delete,
}
-- =============================================

local gui = Instance.new("ScreenGui")
gui.Name = "CheatGUI"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ClipToDeviceSafeArea = false
gui.Parent = LP:WaitForChild("PlayerGui")

-- ===== ГЛАВНОЕ ОКНО =====
local main = Instance.new("Frame")
main.Size = UDim2.fromOffset(300, 460)
main.Position = UDim2.new(0.5, -150, 0.5, -230)
main.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
main.BorderSizePixel = 0
main.Visible = false
main.Active = true
main.Draggable = true
main.Parent = gui

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(80, 80, 100)
mainStroke.Thickness = 1
mainStroke.Parent = main

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
title.BorderSizePixel = 0
title.Text = "  ESP MENU"
title.TextColor3 = Color3.fromRGB(0, 255, 150)
title.Font = Enum.Font.Code
title.TextSize = 16
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = main

local close = Instance.new("TextButton")
close.Size = UDim2.fromOffset(30, 30)
close.Position = UDim2.new(1, -30, 0, 0)
close.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
close.BorderSizePixel = 0
close.Text = "X"
close.TextColor3 = Color3.fromRGB(255, 255, 255)
close.Font = Enum.Font.Code
close.TextSize = 14
close.Parent = main

-- ===== ПУНКТЫ МЕНЮ =====
local toggles = {}
local bindingKey = nil

local function getBindText(key)
    local kb = Keybinds[key]
    return kb and kb.Name or "—"
end

local function makeToggle(y, label, key)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -80, 0, 26)
    btn.Position = UDim2.fromOffset(10, y)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    btn.BorderSizePixel = 0
    btn.Text = string.format("  [%s]  %s", Config[key] and "+" or "-", label)
    btn.TextColor3 = Config[key] and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(180, 180, 180)
    btn.Font = Enum.Font.Code
    btn.TextSize = 13
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Parent = main
    
    btn.MouseButton1Click:Connect(function()
        Config[key] = not Config[key]
        btn.Text = string.format("  [%s]  %s", Config[key] and "+" or "-", label)
        btn.TextColor3 = Config[key] and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(180, 180, 180)
        if key == "Fly" then toggleFly() end
        if key == "Noclip" then toggleNoclip() end
    end)
    
    local kb = Instance.new("TextButton")
    kb.Size = UDim2.fromOffset(60, 26)
    kb.Position = UDim2.new(1, -70, 0, y)
    kb.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    kb.BorderSizePixel = 0
    kb.Text = getBindText(key)
    kb.TextColor3 = Keybinds[key] and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(120, 120, 120)
    kb.Font = Enum.Font.Code
    kb.TextSize = 12
    kb.Parent = main
    
    kb.MouseButton1Click:Connect(function()
        bindingKey = key
        kb.Text = "..."
        kb.TextColor3 = Color3.fromRGB(255, 200, 60)
    end)
    
    kb.MouseButton2Click:Connect(function()
        Keybinds[key] = nil
        kb.Text = "—"
        kb.TextColor3 = Color3.fromRGB(120, 120, 120)
        showNotify(string.format("[ %s ]  bind reset", label), Color3.fromRGB(255, 180, 60))
    end)
    
    toggles[key] = {btn = btn, kb = kb, label = label}
end

makeToggle(40,  "ESP Master", "ESP")
makeToggle(70,  "Box",        "Box")
makeToggle(100, "Name + Dist","Name")
makeToggle(130, "HP Bar",     "HP")
makeToggle(160, "Tool",       "Tool")
makeToggle(190, "Chams",      "Chams")
makeToggle(220, "Skeleton",   "Skeleton")
makeToggle(250, "Aimbot",     "Aimbot")
makeToggle(280, "Fly",        "Fly")
makeToggle(310, "Noclip",     "Noclip")
makeToggle(340, "Menu Key",   "Menu")

-- ===== УВЕДОМЛЕНИЯ =====
local notifyGui = Instance.new("ScreenGui")
notifyGui.Name = "Notify"
notifyGui.ResetOnSpawn = false
notifyGui.IgnoreGuiInset = true
notifyGui.Parent = LP:WaitForChild("PlayerGui")

local notify = Instance.new("TextLabel")
notify.Size = UDim2.fromOffset(260, 40)
notify.Position = UDim2.new(0.5, -130, 0, 40)
notify.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
notify.BackgroundTransparency = 0.2
notify.BorderSizePixel = 0
notify.Text = ""
notify.TextColor3 = Color3.fromRGB(0, 255, 150)
notify.Font = Enum.Font.Code
notify.TextSize = 16
notify.TextTransparency = 1
notify.Visible = false
notify.Parent = notifyGui

local notifyStroke = Instance.new("UIStroke")
notifyStroke.Color = Color3.fromRGB(0, 255, 150)
notifyStroke.Thickness = 1
notifyStroke.Transparency = 1
notifyStroke.Parent = notify

local notifyToken = 0

function showNotify(text, color)
    notifyToken = notifyToken + 1
    local myToken = notifyToken
    notify.Text = text
    notify.TextColor3 = color
    notifyStroke.Color = color
    notify.Visible = true
    notify.TextTransparency = 0
    notify.BackgroundTransparency = 0.2
    notifyStroke.Transparency = 0
    
    task.spawn(function()
        task.wait(1.2)
        if notifyToken ~= myToken then return end
        for i = 1, 20 do
            if notifyToken ~= myToken then return end
            notify.TextTransparency = i / 20
            notify.BackgroundTransparency = 0.2 + (i / 20) * 0.8
            notifyStroke.Transparency = i / 20
            task.wait(0.02)
        end
        if notifyToken == myToken then
            notify.Visible = false
        end
    end)
end

-- ===== ESP + СКЕЛЕТ =====
local cache = {}

local BONE_CONNECTIONS_R15 = {
    {"Head", "UpperTorso"},
    {"UpperTorso", "LowerTorso"},
    {"UpperTorso", "LeftUpperArm"},
    {"LeftUpperArm", "LeftLowerArm"},
    {"LeftLowerArm", "LeftHand"},
    {"UpperTorso", "RightUpperArm"},
    {"RightUpperArm", "RightLowerArm"},
    {"RightLowerArm", "RightHand"},
    {"LowerTorso", "LeftUpperLeg"},
    {"LeftUpperLeg", "LeftLowerLeg"},
    {"LeftLowerLeg", "LeftFoot"},
    {"LowerTorso", "RightUpperLeg"},
    {"RightUpperLeg", "RightLowerLeg"},
    {"RightLowerLeg", "RightFoot"},
}

local BONE_CONNECTIONS_R6 = {
    {"Head", "Torso"},
    {"Torso", "Left Arm"},
    {"Torso", "Right Arm"},
    {"Torso", "Left Leg"},
    {"Torso", "Right Leg"},
}

local function createBoneLine(parent)
    local line = Instance.new("Frame")
    line.BackgroundColor3 = Color3.fromRGB(0, 255, 140)
    line.BorderSizePixel = 0
    line.AnchorPoint = Vector2.new(0.5, 0.5)
    line.Visible = false
    line.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = line

    return line
end

local function createESP(player)
    local box = Instance.new("Frame")
    box.BackgroundTransparency = 1
    box.BorderSizePixel = 0
    box.Visible = false
    box.Parent = gui

    -- Углы
    local corners = {}
    local function makeCorner(ax, ay, px, py)
        local f1 = Instance.new("Frame")
        f1.BackgroundColor3 = Color3.fromRGB(0, 255, 140)
        f1.BorderSizePixel = 0
        f1.Size = UDim2.fromOffset(9, 2)
        f1.AnchorPoint = Vector2.new(ax, ay)
        f1.Position = UDim2.new(px, 0, py, 0)
        f1.Parent = box

        local f2 = Instance.new("Frame")
        f2.BackgroundColor3 = Color3.fromRGB(0, 255, 140)
        f2.BorderSizePixel = 0
        f2.Size = UDim2.fromOffset(2, 9)
        f2.AnchorPoint = Vector2.new(ax, ay)
        f2.Position = UDim2.new(px, 0, py, 0)
        f2.Parent = box

        return {f1, f2}
    end

    corners.TL = makeCorner(0, 0, 0, 0)
    corners.TR = makeCorner(1, 0, 1, 0)
    corners.BL = makeCorner(0, 1, 0, 1)
    corners.BR = makeCorner(1, 1, 1, 1)

    -- Имя
    local name = Instance.new("TextLabel")
    name.BackgroundTransparency = 1
    name.TextColor3 = Color3.fromRGB(255, 255, 255)
    name.TextStrokeTransparency = 0.35
    name.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    name.TextSize = 14
    name.Font = Enum.Font.GothamBold
    name.Size = UDim2.new(1, 0, 0, 18)
    name.Position = UDim2.new(0, 0, 0, -22)
    name.TextXAlignment = Enum.TextXAlignment.Center
    name.Parent = box

    -- Инструмент
    local tool = Instance.new("TextLabel")
    tool.BackgroundTransparency = 1
    tool.TextColor3 = Color3.fromRGB(255, 210, 80)
    tool.TextStrokeTransparency = 0.35
    tool.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    tool.TextSize = 12
    tool.Font = Enum.Font.Gotham
    tool.Size = UDim2.new(1, 0, 0, 16)
    tool.Position = UDim2.new(0, 0, 1, 5)
    tool.TextXAlignment = Enum.TextXAlignment.Center
    tool.Parent = box

    -- HP
    local hpBg = Instance.new("Frame")
    hpBg.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    hpBg.BackgroundTransparency = 0.25
    hpBg.BorderSizePixel = 0
    hpBg.Size = UDim2.new(0, 4, 1, 0)
    hpBg.Position = UDim2.new(0, -11, 0, 0)
    hpBg.Parent = box

    local hpBgCorner = Instance.new("UICorner")
    hpBgCorner.CornerRadius = UDim.new(1, 0)
    hpBgCorner.Parent = hpBg

    local hpFill = Instance.new("Frame")
    hpFill.BackgroundColor3 = Color3.fromRGB(0, 255, 120)
    hpFill.BorderSizePixel = 0
    hpFill.Size = UDim2.new(1, 0, 1, 0)
    hpFill.AnchorPoint = Vector2.new(0, 1)
    hpFill.Position = UDim2.new(0, 0, 1, 0)
    hpFill.Parent = hpBg

    local hpFillCorner = Instance.new("UICorner")
    hpFillCorner.CornerRadius = UDim.new(1, 0)
    hpFillCorner.Parent = hpFill

    local gradient = Instance.new("UIGradient")
    gradient.Rotation = 90
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 255, 140)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 170, 80))
    })
    gradient.Parent = hpFill

    -- Скелет
    local skeletonFolder = Instance.new("Folder")
    skeletonFolder.Name = "Skeleton"
    skeletonFolder.Parent = box

    cache[player] = {
        box = box,
        corners = corners,
        name = name,
        tool = tool,
        hpBg = hpBg,
        hpFill = hpFill,
        skeletonFolder = skeletonFolder,
        bones = {},
        highlight = nil
    }
end

local function removeESP(player)
    if cache[player] then
        if cache[player].highlight then cache[player].highlight:Destroy() end
        cache[player].box:Destroy()
        cache[player] = nil
    end
end

Players.PlayerAdded:Connect(createESP)
Players.PlayerRemoving:Connect(removeESP)
for _, p in pairs(Players:GetPlayers()) do
    if p ~= LP then createESP(p) end
end

-- ===== FLY =====
local flyBodyVel, flyBodyGyro, flyConn

local function stopFly()
    if flyBodyVel then flyBodyVel:Destroy() flyBodyVel = nil end
    if flyBodyGyro then flyBodyGyro:Destroy() flyBodyGyro = nil end
    if flyConn then flyConn:Disconnect() flyConn = nil end
end

local function startFly()
    stopFly()
    local char = LP.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not root or not hum then return end
    
    hum.PlatformStand = true
    
    flyBodyVel = Instance.new("BodyVelocity")
    flyBodyVel.MaxForce = Vector3.new(1e5, 1e5, 1e5)
    flyBodyVel.Velocity = Vector3.zero
    flyBodyVel.Parent = root
    
    flyBodyGyro = Instance.new("BodyGyro")
    flyBodyGyro.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
    flyBodyGyro.P = 3000
    flyBodyGyro.CFrame = root.CFrame
    flyBodyGyro.Parent = root
    
    flyConn = RunService.RenderStepped:Connect(function()
        if not (flyBodyVel and flyBodyGyro and root.Parent) then return end
        local cam = Camera.CFrame
        local move = Vector3.zero
        if UIS:IsKeyDown(Enum.KeyCode.W) then move += cam.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then move -= cam.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then move -= cam.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then move += cam.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.Space) then move += Vector3.new(0, 1, 0) end
        if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then move -= Vector3.new(0, 1, 0) end
        
        flyBodyVel.Velocity = move.Magnitude > 0 and move.Unit * Config.FlySpeed or Vector3.zero
        flyBodyGyro.CFrame = cam
    end)
end

function toggleFly()
    if Config.Fly then
        startFly()
    else
        stopFly()
        local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.PlatformStand = false end
    end
end

-- ===== NOCLIP =====
local noclipConn

local function stopNoclip()
    if noclipConn then
        noclipConn:Disconnect()
        noclipConn = nil
    end
    local char = LP.Character
    if char then
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end

local function startNoclip()
    stopNoclip()
    local char = LP.Character
    if not char then return end
    
    noclipConn = RunService.Stepped:Connect(function()
        local currentChar = LP.Character
        if not currentChar then return end
        for _, part in pairs(currentChar:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end)
end

function toggleNoclip()
    if Config.Noclip then
        startNoclip()
    else
        stopNoclip()
    end
end

LP.CharacterAdded:Connect(function()
    task.wait(0.5)
    if Config.Fly then toggleFly() end
    if Config.Noclip then toggleNoclip() end
end)

-- ===== ОБНОВЛЕНИЕ КНОПОК =====
local function refreshToggle(key)
    local t = toggles[key]
    if not t then return end
    t.btn.Text = string.format("  [%s]  %s", Config[key] and "+" or "-", t.label)
    t.btn.TextColor3 = Config[key] and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(180, 180, 180)
end

-- ===== ВВОД =====
UIS.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
    
    if bindingKey then
        Keybinds[bindingKey] = input.KeyCode
        local kb = toggles[bindingKey].kb
        if kb then
            kb.Text = input.KeyCode.Name
            kb.TextColor3 = Color3.fromRGB(255, 255, 255)
        end
        showNotify(string.format("[ %s ]  bind -> %s", toggles[bindingKey].label, input.KeyCode.Name), Color3.fromRGB(0, 200, 255))
        bindingKey = nil
        return
    end
    
    for key, bind in pairs(Keybinds) do
        if bind and input.KeyCode == bind then
            if key == "Menu" then
                main.Visible = not main.Visible
                return
            end
            
            if Config[key] ~= nil then
                Config[key] = not Config[key]
                refreshToggle(key)
                
                if key == "Fly" then toggleFly() end
                if key == "Noclip" then toggleNoclip() end
                
                showNotify(
                    string.format("[ %s: %s ]", toggles[key].label, Config[key] and "ON" or "OFF"),
                    Config[key] and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(255, 80, 80)
                )
            end
            return
        end
    end
end)

close.MouseButton1Click:Connect(function()
    main.Visible = false
end)

-- ===== ОСНОВНОЙ ЦИКЛ =====
local lastShot = 0

RunService.RenderStepped:Connect(function()
    local vpSize = Camera.ViewportSize
    local center = Vector2.new(vpSize.X/2, vpSize.Y/2)
    local closestTarget, shortest = nil, Config.FOV
    
    for player, esp in pairs(cache) do
        local char = player.Character
        local head = char and char:FindFirstChild("Head")
        local root = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        
        if esp.highlight and (not char or esp.highlight.Parent ~= char) then
            esp.highlight:Destroy()
            esp.highlight = nil
        end
        
        local alive = head and root and hum and hum.Health > 0
        
        if not alive then
            esp.box.Visible = false
            for _, line in ipairs(esp.bones) do line.Visible = false end
            continue
        end
        
        -- Chams
        if Config.ESP and Config.Chams then
            if not esp.highlight or esp.highlight.Parent ~= char then
                if esp.highlight then esp.highlight:Destroy() end
                local hl = Instance.new("Highlight")
                hl.FillColor = Color3.fromRGB(255, 50, 50)
                hl.FillTransparency = 0.55
                hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                hl.OutlineTransparency = 0
                hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                hl.Adornee = char
                hl.Parent = char
                esp.highlight = hl
            end
        else
            if esp.highlight then
                esp.highlight:Destroy()
                esp.highlight = nil
            end
        end
        
        local topPos, topOn = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.9, 0))
        local botPos, botOn = Camera:WorldToViewportPoint(root.Position - Vector3.new(0, 3.1, 0))
        
        local visible = topOn and botOn and topPos.Z > 0 and botPos.Z > 0
        
        if visible then
            local height = math.abs(botPos.Y - topPos.Y)
            local width = height * 0.55
            
            -- Бокс
            esp.box.Visible = Config.ESP and Config.Box
            esp.box.Position = UDim2.fromOffset(topPos.X - width/2, topPos.Y)
            esp.box.Size = UDim2.fromOffset(width, height)
            
            local ratio = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
            local boxColor = ratio > 0.6 and Color3.fromRGB(0, 255, 140)
                or ratio > 0.3 and Color3.fromRGB(255, 220, 50)
                or Color3.fromRGB(255, 70, 70)
            
            for _, group in pairs(esp.corners) do
                for _, f in pairs(group) do
                    f.BackgroundColor3 = boxColor
                end
            end
            
            -- Имя
            esp.name.Visible = Config.ESP and Config.Name
            local dist = math.floor((Camera.CFrame.Position - root.Position).Magnitude)
            esp.name.Text = string.format("%s  ·  %dm", player.Name, dist)
            
            -- Инструмент
            esp.tool.Visible = Config.ESP and Config.Tool
            local held = char:FindFirstChildOfClass("Tool")
            esp.tool.Text = held and held.Name or ""
            
            -- HP
            esp.hpBg.Visible = Config.ESP and Config.HP
            esp.hpFill.Size = UDim2.new(1, 0, ratio, 0)
            
            -- ===== СКЕЛЕТ =====
            if Config.ESP and Config.Skeleton then
                local isR15 = char:FindFirstChild("UpperTorso") ~= nil
                local connections = isR15 and BONE_CONNECTIONS_R15 or BONE_CONNECTIONS_R6
                
                if #esp.bones < #connections then
                    for i = #esp.bones + 1, #connections do
                        table.insert(esp.bones, createBoneLine(esp.skeletonFolder))
                    end
                end
                
                for i, connection in ipairs(connections) do
                    local part0 = char:FindFirstChild(connection[1])
                    local part1 = char:FindFirstChild(connection[2])
                    local line = esp.bones[i]
                    
                    if part0 and part1 and line then
                        local p0, on0 = Camera:WorldToViewportPoint(part0.Position)
                        local p1, on1 = Camera:WorldToViewportPoint(part1.Position)
                        
                        if on0 and on1 and p0.Z > 0 and p1.Z > 0 then
                            local from = Vector2.new(p0.X, p0.Y)
                            local to = Vector2.new(p1.X, p1.Y)
                            local dist = (to - from).Magnitude
                            local mid = (from + to) / 2
                            local angle = math.atan2(to.Y - from.Y, to.X - from.X)
                            
                            line.Visible = true
                            line.BackgroundColor3 = boxColor
                            line.Size = UDim2.fromOffset(dist, 2)
                            line.Position = UDim2.fromOffset(mid.X, mid.Y)
                            line.Rotation = math.deg(angle)
                        else
                            line.Visible = false
                        end
                    elseif line then
                        line.Visible = false
                    end
                end
            else
                for _, line in ipairs(esp.bones) do
                    line.Visible = false
                end
            end
        else
            esp.box.Visible = false
            for _, line in ipairs(esp.bones) do
                line.Visible = false
            end
        end
        
        -- Aimbot
        if Config.Aimbot then
            local headScreen, headOn = Camera:WorldToViewportPoint(head.Position)
            if headOn and headScreen.Z > 0 then
                local d = (Vector2.new(headScreen.X, headScreen.Y) - center).Magnitude
                if d < shortest then
                    shortest = d
                    closestTarget = head
                end
            end
        end
    end
    
    if Config.Aimbot and closestTarget then
        Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, closestTarget.Position), 0.2)
        if tick() - lastShot >= Config.FIRE_RATE then
            lastShot = tick()
            local tool = LP.Character and LP.Character:FindFirstChildOfClass("Tool")
            if tool then tool:Activate() end
        end
    end
end)
