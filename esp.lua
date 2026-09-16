-- LocalScript в StarterPlayerScripts (только для СВОЕЙ игры)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LP = Players.LocalPlayer

-- Локализация
local pairs = pairs
local ipairs = ipairs
local Vector3new = Vector3.new
local UDim2fromOffset = UDim2.fromOffset
local mathfloor = math.floor
local mathclamp = math.clamp
local mathatan2 = math.atan2
local mathdeg = math.deg
local tick = tick
local CFramenew = CFrame.new

-- ================= НАСТРОЙКИ =================
local Config = {
    ESP = true,
    Box = true,
    Name = true,
    HP = true,
    Tool = true,
    Chams = true,
    Skeleton = true,
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

-- ===== GUI =====
local gui = Instance.new("ScreenGui")
gui.Name = "CheatGUI"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ClipToDeviceSafeArea = false
gui.Parent = LP:WaitForChild("PlayerGui")

local main = Instance.new("Frame")
main.Size = UDim2.fromOffset(300, 490)
main.Position = UDim2.new(0.5, -150, 0.5, -245)
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

-- ===== МЕНЮ =====
local toggles = {}
local bindingKey = nil
local FlySpeedDisplay = nil

local function getBindText(key)
    local kb = Keybinds[key]
    return kb and kb.Name or "—"
end

local function makeToggle(y, label, key)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -80, 0, 26)
    btn.Position = UDim2fromOffset(10, y)
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
        showNotify("[ " .. label .. " ]  bind reset", Color3.fromRGB(255, 180, 60))
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

-- Скорость флая
local speedFrame = Instance.new("Frame")
speedFrame.Size = UDim2.new(1, -20, 0, 30)
speedFrame.Position = UDim2fromOffset(10, 370)
speedFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
speedFrame.BorderSizePixel = 0
speedFrame.Parent = main

local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(0.5, 0, 1, 0)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "  Fly Speed: 50"
speedLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
speedLabel.Font = Enum.Font.Code
speedLabel.TextSize = 13
speedLabel.TextXAlignment = Enum.TextXAlignment.Left
speedLabel.Parent = speedFrame
FlySpeedDisplay = speedLabel

local minusBtn = Instance.new("TextButton")
minusBtn.Size = UDim2.fromOffset(34, 24)
minusBtn.Position = UDim2.new(1, -78, 0.5, -12)
minusBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
minusBtn.BorderSizePixel = 0
minusBtn.Text = "−"
minusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minusBtn.Font = Enum.Font.Code
minusBtn.TextSize = 18
minusBtn.Parent = speedFrame

local plusBtn = Instance.new("TextButton")
plusBtn.Size = UDim2.fromOffset(34, 24)
plusBtn.Position = UDim2.new(1, -38, 0.5, -12)
plusBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
plusBtn.BorderSizePixel = 0
plusBtn.Text = "+"
plusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
plusBtn.Font = Enum.Font.Code
plusBtn.TextSize = 18
plusBtn.Parent = speedFrame

local function updateSpeedDisplay()
    FlySpeedDisplay.Text = "  Fly Speed: " .. Config.FlySpeed
end

minusBtn.MouseButton1Click:Connect(function()
    Config.FlySpeed = mathclamp(Config.FlySpeed - 5, 10, 200)
    updateSpeedDisplay()
    showNotify("[ Fly Speed: " .. Config.FlySpeed .. " ]", Color3.fromRGB(0, 200, 255))
end)

plusBtn.MouseButton1Click:Connect(function()
    Config.FlySpeed = mathclamp(Config.FlySpeed + 5, 10, 200)
    updateSpeedDisplay()
    showNotify("[ Fly Speed: " .. Config.FlySpeed .. " ]", Color3.fromRGB(0, 200, 255))
end)

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
    notifyToken += 1
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

-- ===== ESP CACHE =====
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

    local corners = {}
    local function makeCorner(ax, ay, px, py)
        local f1 = Instance.new("Frame")
        f1.BackgroundColor3 = Color3.fromRGB(0, 255, 140)
        f1.BorderSizePixel = 0
        f1.Size = UDim2fromOffset(9, 2)
        f1.AnchorPoint = Vector2.new(ax, ay)
        f1.Position = UDim2.new(px, 0, py, 0)
        f1.Parent = box

        local f2 = Instance.new("Frame")
        f2.BackgroundColor3 = Color3.fromRGB(0, 255, 140)
        f2.BorderSizePixel = 0
        f2.Size = UDim2fromOffset(2, 9)
        f2.AnchorPoint = Vector2.new(ax, ay)
        f2.Position = UDim2.new(px, 0, py, 0)
        f2.Parent = box
        return {f1, f2}
    end

    corners.TL = makeCorner(0, 0, 0, 0)
    corners.TR = makeCorner(1, 0, 1, 0)
    corners.BL = makeCorner(0, 1, 0, 1)
    corners.BR = makeCorner(1, 1, 1, 1)

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

    local hpBg = Instance.new("Frame")
    hpBg.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    hpBg.BackgroundTransparency = 0.25
    hpBg.BorderSizePixel = 0
    hpBg.Size = UDim2.new(0, 4, 1, 0)
    hpBg.Position = UDim2.new(0, -11, 0, 0)
    hpBg.Parent = box

    Instance.new("UICorner", hpBg).CornerRadius = UDim.new(1, 0)

    local hpFill = Instance.new("Frame")
    hpFill.BackgroundColor3 = Color3.fromRGB(0, 255, 120)
    hpFill.BorderSizePixel = 0
    hpFill.Size = UDim2.new(1, 0, 1, 0)
    hpFill.AnchorPoint = Vector2.new(0, 1)
    hpFill.Position = UDim2.new(0, 0, 1, 0)
    hpFill.Parent = hpBg

    Instance.new("UICorner", hpFill).CornerRadius = UDim.new(1, 0)

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
        highlight = nil,
        -- кэш частей
        head = nil,
        root = nil,
        humanoid = nil,
        char = nil,
        isR15 = false,
    }
end

local function removeESP(player)
    local data = cache[player]
    if data then
        if data.highlight then data.highlight:Destroy() end
        data.box:Destroy()
        cache[player] = nil
    end
end

local function updateCharacterCache(player)
    local data = cache[player]
    if not data then return end

    local char = player.Character
    if not char then
        data.char = nil
        data.head = nil
        data.root = nil
        data.humanoid = nil
        return
    end

    data.char = char
    data.head = char:FindFirstChild("Head")
    data.root = char:FindFirstChild("HumanoidRootPart")
    data.humanoid = char:FindFirstChildOfClass("Humanoid")
    data.isR15 = char:FindFirstChild("UpperTorso") ~= nil
end

Players.PlayerAdded:Connect(function(player)
    if player == LP then return end
    createESP(player)
    player.CharacterAdded:Connect(function()
        task.wait(0.3)
        updateCharacterCache(player)
    end)
    player.CharacterRemoving:Connect(function()
        updateCharacterCache(player)
    end)
end)

Players.PlayerRemoving:Connect(removeESP)

for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LP then
        createESP(player)
        updateCharacterCache(player)
        player.CharacterAdded:Connect(function()
            task.wait(0.3)
            updateCharacterCache(player)
        end)
    end
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
    flyBodyVel.MaxForce = Vector3new(1e5, 1e5, 1e5)
    flyBodyVel.Velocity = Vector3.zero
    flyBodyVel.Parent = root

    flyBodyGyro = Instance.new("BodyGyro")
    flyBodyGyro.MaxTorque = Vector3new(1e5, 1e5, 1e5)
    flyBodyGyro.P = 3000
    flyBodyGyro.CFrame = root.CFrame
    flyBodyGyro.Parent = root

    flyConn = RunService.RenderStepped:Connect(function()
        if not flyBodyVel or not flyBodyGyro or not root.Parent then return end
        local cam = Camera.CFrame
        local move = Vector3.zero
        if UIS:IsKeyDown(Enum.KeyCode.W) then move += cam.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then move -= cam.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then move -= cam.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then move += cam.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.Space) then move += Vector3new(0, 1, 0) end
        if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then move -= Vector3new(0, 1, 0) end

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
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end

local function startNoclip()
    stopNoclip()
    noclipConn = RunService.Stepped:Connect(function()
        local char = LP.Character
        if not char then return end
        for _, part in ipairs(char:GetChildren()) do -- быстрее, чем GetDescendants
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
        -- дополнительные части
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then hrp.CanCollide = false end
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
    task.wait(0.4)
    if Config.Fly then toggleFly() end
    if Config.Noclip then toggleNoclip() end
end)

-- ===== ВВОД =====
local function refreshToggle(key)
    local t = toggles[key]
    if not t then return end
    t.btn.Text = string.format("  [%s]  %s", Config[key] and "+" or "-", t.label)
    t.btn.TextColor3 = Config[key] and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(180, 180, 180)
end

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
        showNotify("[ " .. toggles[bindingKey].label .. " ]  bind -> " .. input.KeyCode.Name, Color3.fromRGB(0, 200, 255))
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
                showNotify("[ " .. toggles[key].label .. ": " .. (Config[key] and "ON" or "OFF") .. " ]",
                    Config[key] and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(255, 80, 80))
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
    if not Config.ESP and not Config.Aimbot then return end

    local vpSize = Camera.ViewportSize
    local centerX, centerY = vpSize.X * 0.5, vpSize.Y * 0.5
    local closestTarget, shortest = nil, Config.FOV
    local camPos = Camera.CFrame.Position

    for player, esp in pairs(cache) do
        -- обновляем кэш если нужно
        if not esp.char or not esp.char.Parent then
            updateCharacterCache(player)
        end

        local head = esp.head
        local root = esp.root
        local hum = esp.humanoid
        local char = esp.char

        if not (head and root and hum and hum.Health > 0) then
            esp.box.Visible = false
            for i = 1, #esp.bones do
                esp.bones[i].Visible = false
            end
            continue
        end

        -- Chams
        if Config.Chams then
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
        elseif esp.highlight then
            esp.highlight:Destroy()
            esp.highlight = nil
        end

        local topPos, topOn = Camera:WorldToViewportPoint(head.Position + Vector3new(0, 0.9, 0))
        local botPos, botOn = Camera:WorldToViewportPoint(root.Position - Vector3new(0, 3.1, 0))

        local visible = topOn and botOn and topPos.Z > 0 and botPos.Z > 0

        if visible and Config.ESP then
            local height = botPos.Y - topPos.Y
            if height < 0 then height = -height end
            local width = height * 0.55

            esp.box.Visible = Config.Box
            esp.box.Position = UDim2fromOffset(topPos.X - width * 0.5, topPos.Y)
            esp.box.Size = UDim2fromOffset(width, height)

            local ratio = mathclamp(hum.Health / hum.MaxHealth, 0, 1)
            local boxColor = ratio > 0.6 and Color3.fromRGB(0, 255, 140)
                or ratio > 0.3 and Color3.fromRGB(255, 220, 50)
                or Color3.fromRGB(255, 70, 70)

            for _, group in pairs(esp.corners) do
                group[1].BackgroundColor3 = boxColor
                group[2].BackgroundColor3 = boxColor
            end

            if Config.Name then
                esp.name.Visible = true
                local dist = mathfloor((camPos - root.Position).Magnitude)
                esp.name.Text = player.Name .. "  ·  " .. dist .. "m"
            else
                esp.name.Visible = false
            end

            if Config.Tool then
                local held = char:FindFirstChildOfClass("Tool")
                esp.tool.Visible = true
                esp.tool.Text = held and held.Name or ""
            else
                esp.tool.Visible = false
            end

            if Config.HP then
                esp.hpBg.Visible = true
                esp.hpFill.Size = UDim2.new(1, 0, ratio, 0)
            else
                esp.hpBg.Visible = false
            end

            -- Скелет
            if Config.Skeleton then
                local connections = esp.isR15 and BONE_CONNECTIONS_R15 or BONE_CONNECTIONS_R6
                local bones = esp.bones

                if #bones < #connections then
                    for i = #bones + 1, #connections do
                        bones[i] = createBoneLine(esp.skeletonFolder)
                    end
                end

                for i, connection in ipairs(connections) do
                    local part0 = char:FindFirstChild(connection[1])
                    local part1 = char:FindFirstChild(connection[2])
                    local line = bones[i]

                    if part0 and part1 then
                        local p0, on0 = Camera:WorldToViewportPoint(part0.Position)
                        local p1, on1 = Camera:WorldToViewportPoint(part1.Position)

                        if on0 and on1 and p0.Z > 0 and p1.Z > 0 then
                            local dx = p1.X - p0.X
                            local dy = p1.Y - p0.Y
                            local dist = (dx * dx + dy * dy) ^ 0.5
                            local midX = (p0.X + p1.X) * 0.5
                            local midY = (p0.Y + p1.Y) * 0.5

                            line.Visible = true
                            line.BackgroundColor3 = boxColor
                            line.Size = UDim2fromOffset(dist, 2)
                            line.Position = UDim2fromOffset(midX, midY)
                            line.Rotation = mathdeg(mathatan2(dy, dx))
                        else
                            line.Visible = false
                        end
                    else
                        line.Visible = false
                    end
                end
            else
                for i = 1, #esp.bones do
                    esp.bones[i].Visible = false
                end
            end
        else
            esp.box.Visible = false
            for i = 1, #esp.bones do
                esp.bones[i].Visible = false
            end
        end

        -- Aimbot
        if Config.Aimbot then
            local headScreen, headOn = Camera:WorldToViewportPoint(head.Position)
            if headOn and headScreen.Z > 0 then
                local dx = headScreen.X - centerX
                local dy = headScreen.Y - centerY
                local d = (dx * dx + dy * dy) ^ 0.5
                if d < shortest then
                    shortest = d
                    closestTarget = head
                end
            end
        end
    end

    if Config.Aimbot and closestTarget then
        Camera.CFrame = Camera.CFrame:Lerp(CFramenew(Camera.CFrame.Position, closestTarget.Position), 0.2)
        if tick() - lastShot >= Config.FIRE_RATE then
            lastShot = tick()
            local tool = LP.Character and LP.Character:FindFirstChildOfClass("Tool")
            if tool then tool:Activate() end
        end
    end
end)
