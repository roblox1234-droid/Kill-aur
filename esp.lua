-- ============================================
-- CHEAT SCRIPT FOR EXECUTOR
-- ============================================

local Players = game:GetService("Players")
local LP = Players.LocalPlayer

if not LP then
    repeat task.wait() until Players.LocalPlayer
    LP = Players.LocalPlayer
end

if _G.MyCheatLoaded then
    warn("[CHEAT] Уже загружено!")
    return
end
_G.MyCheatLoaded = true

for _, g in ipairs(LP:WaitForChild("PlayerGui"):GetChildren()) do
    if g.Name == "CheatGUI" or g.Name == "Notify" then
        g:Destroy()
    end
end

local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local Stats = game:GetService("Stats")
local Lighting = game:GetService("Lighting")
local VirtualUser = game:GetService("VirtualUser")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local pairs = pairs
local ipairs = ipairs
local Vector3new = Vector3.new
local UDim2fromOffset = UDim2.fromOffset
local mathfloor = math.floor
local mathclamp = math.clamp
local tick = tick
local CFramenew = CFrame.new

-- ================= НАСТРОЙКИ =================
local Config = {
    -- Visual
    ESP = true,
    Box = true,
    Name = true,
    HP = true,
    Tool = true,
    Chams = true,
    VisibleOnly = false,
    Tracers = false,
    -- Aimbot
    Aimbot = false,
    ShowFOV = true,
    FOV = 100,
    FIRE_RATE = 0.1,
    AimStrength = 0.85,
    -- Movement
    Fly = false,
    Noclip = false,
    FlySpeed = 50,
    SpeedHack = false,
    WalkSpeed = 16,
    InfiniteJump = false,
    BunnyHop = false,
    -- Misc
    AntiAFK = true,
    Fullbright = false,
    FPSBoost = false,
    AutoReload = false,
}

local Keybinds = {
    ESP         = nil,
    Box         = nil,
    Name        = nil,
    HP          = nil,
    Tool        = nil,
    Chams       = nil,
    VisibleOnly = nil,
    Tracers     = nil,
    Aimbot      = Enum.KeyCode.Q,
    ShowFOV     = nil,
    Fly         = Enum.KeyCode.F,
    Noclip      = Enum.KeyCode.V,
    SpeedHack   = nil,
    InfiniteJump= nil,
    BunnyHop    = Enum.KeyCode.B,
    AntiAFK     = nil,
    Fullbright  = nil,
    FPSBoost    = nil,
    AutoReload  = Enum.KeyCode.R,
    Menu        = Enum.KeyCode.Delete,
}

-- ===== GUI =====
local gui = Instance.new("ScreenGui")
gui.Name = "CheatGUI"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ClipToDeviceSafeArea = false
gui.DisplayOrder = 999999
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = LP:WaitForChild("PlayerGui")

-- FPS + PING
local infoLabel = Instance.new("TextLabel")
infoLabel.Size = UDim2.fromOffset(120, 40)
infoLabel.Position = UDim2.new(1, -130, 0, 10)
infoLabel.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
infoLabel.BackgroundTransparency = 0.3
infoLabel.BorderSizePixel = 0
infoLabel.TextColor3 = Color3.fromRGB(0, 255, 140)
infoLabel.Font = Enum.Font.Code
infoLabel.TextSize = 13
infoLabel.Text = "FPS: --\nPing: --"
infoLabel.TextXAlignment = Enum.TextXAlignment.Left
infoLabel.TextYAlignment = Enum.TextYAlignment.Center
infoLabel.ZIndex = 10
infoLabel.Parent = gui

local pad = Instance.new("UIPadding")
pad.PaddingLeft = UDim.new(0, 8)
pad.Parent = infoLabel
Instance.new("UICorner", infoLabel).CornerRadius = UDim.new(0, 6)

local fps, frames, lastTime = 0, 0, tick()

local function getRainbowColor()
    local t = tick() * 2.5
    return Color3.new(
        math.sin(t) * 0.5 + 0.5,
        math.sin(t + 2) * 0.5 + 0.5,
        math.sin(t + 4) * 0.5 + 0.5
    )
end

-- ГЛАВНОЕ ОКНО
local main = Instance.new("Frame")
main.Size = UDim2.fromOffset(320, 480)
main.Position = UDim2.new(0.5, -160, 0.5, -240)
main.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
main.BorderSizePixel = 0
main.Visible = false
main.Active = true
main.Draggable = true
main.ZIndex = 10
main.Parent = gui
Instance.new("UIStroke", main).Color = Color3.fromRGB(80, 80, 100)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
title.BorderSizePixel = 0
title.Text = "  CHEAT MENU"
title.TextColor3 = Color3.fromRGB(0, 255, 150)
title.Font = Enum.Font.Code
title.TextSize = 16
title.TextXAlignment = Enum.TextXAlignment.Left
title.ZIndex = 11
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
close.ZIndex = 12
close.Parent = main

-- ВКЛАДКИ
local tabsBar = Instance.new("Frame")
tabsBar.Size = UDim2.new(1, 0, 0, 30)
tabsBar.Position = UDim2.fromOffset(0, 30)
tabsBar.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
tabsBar.BorderSizePixel = 0
tabsBar.ZIndex = 11
tabsBar.Parent = main

local tabsLayout = Instance.new("UIListLayout")
tabsLayout.FillDirection = Enum.FillDirection.Horizontal
tabsLayout.SortOrder = Enum.SortOrder.LayoutOrder
tabsLayout.Parent = tabsBar

local pages = {}
local tabButtons = {}

local function selectTab(name)
    for tabName, page in pairs(pages) do
        page.Visible = (tabName == name)
    end
    for tabName, btn in pairs(tabButtons) do
        if tabName == name then
            btn.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
            btn.TextColor3 = Color3.fromRGB(0, 255, 150)
        else
            btn.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
            btn.TextColor3 = Color3.fromRGB(150, 150, 150)
        end
    end
end

local function createTab(name, displayName)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1/4, 0, 1, 0)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
    btn.BorderSizePixel = 0
    btn.Text = displayName
    btn.TextColor3 = Color3.fromRGB(150, 150, 150)
    btn.Font = Enum.Font.Code
    btn.TextSize = 13
    btn.ZIndex = 12
    btn.Parent = tabsBar

    local page = Instance.new("ScrollingFrame")
    page.Size = UDim2.new(1, -10, 1, -70)
    page.Position = UDim2.fromOffset(5, 65)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.ScrollBarThickness = 4
    page.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 100)
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    page.Visible = false
    page.ZIndex = 11
    page.Parent = main

    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 4)
    layout.Parent = page

    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, 5)
    padding.PaddingLeft = UDim.new(0, 5)
    padding.PaddingRight = UDim.new(0, 5)
    padding.Parent = page

    pages[name] = page
    tabButtons[name] = btn

    btn.MouseButton1Click:Connect(function()
        selectTab(name)
    end)
end

createTab("Visual", "Visual")
createTab("Aimbot", "Aimbot")
createTab("Movement", "Move")
createTab("Misc", "Misc")

-- УВЕДОМЛЕНИЯ
local notifyGui = Instance.new("ScreenGui")
notifyGui.Name = "Notify"
notifyGui.ResetOnSpawn = false
notifyGui.IgnoreGuiInset = true
notifyGui.DisplayOrder = 9999999
notifyGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
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
notify.ZIndex = 2
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

-- FOV CIRCLE
local fovCircle = Instance.new("Frame")
fovCircle.AnchorPoint = Vector2.new(0.5, 0.5)
fovCircle.Position = UDim2.new(0.5, 0, 0.5, 0)
fovCircle.BackgroundTransparency = 1
fovCircle.BorderSizePixel = 0
fovCircle.Visible = false
fovCircle.ZIndex = 5
fovCircle.Parent = gui

local fovStroke = Instance.new("UIStroke")
fovStroke.Color = Color3.fromRGB(0, 255, 150)
fovStroke.Thickness = 2
fovStroke.Transparency = 0.2
fovStroke.Parent = fovCircle
Instance.new("UICorner", fovCircle).CornerRadius = UDim.new(1, 0)

-- ПРОВЕРКА ВИДИМОСТИ
local rayParams = RaycastParams.new()
rayParams.FilterType = Enum.RaycastFilterType.Exclude

local function isVisible(fromPos, toPos, characterToIgnore)
    rayParams.FilterDescendantsInstances = {LP.Character, characterToIgnore}
    local result = workspace:Raycast(fromPos, toPos - fromPos, rayParams)
    return result == nil or result.Instance:IsDescendantOf(characterToIgnore)
end

-- ESP
local cache = {}

local function createESP(player)
    local box = Instance.new("Frame")
    box.BackgroundTransparency = 1
    box.BorderSizePixel = 0
    box.Visible = false
    box.ZIndex = 3
    box.Parent = gui

    local corners = {}
    local function makeCorner(ax, ay, px, py)
        local f1 = Instance.new("Frame")
        f1.BackgroundColor3 = Color3.fromRGB(0, 255, 140)
        f1.BorderSizePixel = 0
        f1.Size = UDim2fromOffset(9, 2)
        f1.AnchorPoint = Vector2.new(ax, ay)
        f1.Position = UDim2.new(px, 0, py, 0)
        f1.ZIndex = 4
        f1.Parent = box

        local f2 = Instance.new("Frame")
        f2.BackgroundColor3 = Color3.fromRGB(0, 255, 140)
        f2.BorderSizePixel = 0
        f2.Size = UDim2fromOffset(2, 9)
        f2.AnchorPoint = Vector2.new(ax, ay)
        f2.Position = UDim2.new(px, 0, py, 0)
        f2.ZIndex = 4
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
    name.ZIndex = 4
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
    tool.ZIndex = 4
    tool.Parent = box

    local hpBg = Instance.new("Frame")
    hpBg.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    hpBg.BackgroundTransparency = 0.25
    hpBg.BorderSizePixel = 0
    hpBg.Size = UDim2.new(0, 4, 1, 0)
    hpBg.Position = UDim2.new(0, -11, 0, 0)
    hpBg.ZIndex = 4
    hpBg.Parent = box
    Instance.new("UICorner", hpBg).CornerRadius = UDim.new(1, 0)

    local hpFill = Instance.new("Frame")
    hpFill.BackgroundColor3 = Color3.fromRGB(0, 255, 120)
    hpFill.BorderSizePixel = 0
    hpFill.Size = UDim2.new(1, 0, 1, 0)
    hpFill.AnchorPoint = Vector2.new(0, 1)
    hpFill.Position = UDim2.new(0, 0, 1, 0)
    hpFill.ZIndex = 5
    hpFill.Parent = hpBg
    Instance.new("UICorner", hpFill).CornerRadius = UDim.new(1, 0)

    local tracer = Instance.new("Frame")
    tracer.BackgroundColor3 = Color3.fromRGB(0, 255, 140)
    tracer.BorderSizePixel = 0
    tracer.AnchorPoint = Vector2.new(0.5, 0)
    tracer.Size = UDim2.fromOffset(1, 0)
    tracer.Visible = false
    tracer.ZIndex = 3
    tracer.Parent = gui

    cache[player] = {
        box = box, corners = corners, name = name, tool = tool,
        hpBg = hpBg, hpFill = hpFill, highlight = nil,
        tracer = tracer,
        head = nil, root = nil, humanoid = nil, char = nil,
    }
end

local function removeESP(player)
    local data = cache[player]
    if data then
        if data.highlight then data.highlight:Destroy() end
        if data.tracer then data.tracer:Destroy() end
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
end

Players.PlayerAdded:Connect(function(player)
    if player == LP then return end
    createESP(player)
    player.CharacterAdded:Connect(function()
        task.wait(0.3)
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

-- FLY
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

-- NOCLIP
local noclipConn

local function stopNoclip()
    if noclipConn then
        noclipConn:Disconnect()
        noclipConn = nil
    end
    local char = LP.Character
    if char then
        for _, part in ipairs(char:GetChildren()) do
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
        for _, part in ipairs(char:GetChildren()) do
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

-- SPEED HACK
local speedConn

local function toggleSpeedHack()
    if speedConn then speedConn:Disconnect() speedConn = nil end
    if Config.SpeedHack then
        speedConn = RunService.Heartbeat:Connect(function()
            local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum.WalkSpeed = Config.WalkSpeed end
        end)
    else
        local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = 16 end
    end
end

-- INFINITE JUMP
local infJumpConn

local function toggleInfiniteJump()
    if infJumpConn then infJumpConn:Disconnect() infJumpConn = nil end
    if Config.InfiniteJump then
        infJumpConn = UIS.JumpRequest:Connect(function()
            local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
            if hum then
                hum:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
    end
end

-- BUNNY HOP
local bhopConn

local function toggleBunnyHop()
    if bhopConn then bhopConn:Disconnect() bhopConn = nil end
    if Config.BunnyHop then
        bhopConn = RunService.Stepped:Connect(function()
            local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
            if hum and hum.FloorMaterial ~= Enum.Material.Air then
                hum:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
    end
end

-- ANTI-AFK
local antiAfkConn

local function toggleAntiAFK()
    if antiAfkConn then antiAfkConn:Disconnect() antiAfkConn = nil end
    if Config.AntiAFK then
        antiAfkConn = LP.Idled:Connect(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end)
    end
end

-- FULLBRIGHT
local originalLighting = {
    Brightness = Lighting.Brightness,
    ClockTime = Lighting.ClockTime,
    Ambient = Lighting.Ambient,
    OutdoorAmbient = Lighting.OutdoorAmbient,
    FogEnd = Lighting.FogEnd,
    GlobalShadows = Lighting.GlobalShadows,
}

local function toggleFullbright()
    if Config.Fullbright then
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.Ambient = Color3.fromRGB(200, 200, 200)
        Lighting.OutdoorAmbient = Color3.fromRGB(200, 200, 200)
        Lighting.FogEnd = 100000
        Lighting.GlobalShadows = false
    else
        Lighting.Brightness = originalLighting.Brightness
        Lighting.ClockTime = originalLighting.ClockTime
        Lighting.Ambient = originalLighting.Ambient
        Lighting.OutdoorAmbient = originalLighting.OutdoorAmbient
        Lighting.FogEnd = originalLighting.FogEnd
        Lighting.GlobalShadows = originalLighting.GlobalShadows
    end
end

-- AUTO-RELOAD
local autoReloadConn = nil

local function startAutoReload()
    if autoReloadConn then return end
    autoReloadConn = RunService.Heartbeat:Connect(function()
        local char = LP.Character
        if not char then return end
        local tool = char:FindFirstChildOfClass("Tool")
        if not tool then return end

        local ammo = tool:GetAttribute("Ammo") 
            or tool:GetAttribute("CurrentAmmo")
            or tool:GetAttribute("AmmoCount")

        if ammo and ammo <= 0 then
            pcall(function()
                tool:Activate()
            end)
        end

        local remote = ReplicatedStorage:FindFirstChild("Reload")
            or ReplicatedStorage:FindFirstChild("ReloadEvent")
        if remote and remote:IsA("RemoteEvent") then
            pcall(function()
                remote:FireServer()
            end)
        end
    end)
end

local function stopAutoReload()
    if autoReloadConn then
        autoReloadConn:Disconnect()
        autoReloadConn = nil
    end
end

local function toggleAutoReload()
    if Config.AutoReload then
        startAutoReload()
    else
        stopAutoReload()
    end
end

-- ТОГГЛЫ
local toggles = {}
local bindingKey = nil

local function getBindText(key)
    local kb = Keybinds[key]
    return kb and kb.Name or "—"
end

local function makeToggle(page, label, key)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -80, 0, 26)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    btn.BorderSizePixel = 0
    btn.Text = string.format("  [%s]  %s", Config[key] and "+" or "-", label)
    btn.TextColor3 = Config[key] and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(180, 180, 180)
    btn.Font = Enum.Font.Code
    btn.TextSize = 13
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.ZIndex = 12
    btn.Parent = page

    btn.MouseButton1Click:Connect(function()
        Config[key] = not Config[key]
        btn.Text = string.format("  [%s]  %s", Config[key] and "+" or "-", label)
        btn.TextColor3 = Config[key] and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(180, 180, 180)
        if key == "Fly" then toggleFly() end
        if key == "Noclip" then toggleNoclip() end
        if key == "SpeedHack" then toggleSpeedHack() end
        if key == "InfiniteJump" then toggleInfiniteJump() end
        if key == "BunnyHop" then toggleBunnyHop() end
        if key == "AntiAFK" then toggleAntiAFK() end
        if key == "Fullbright" then toggleFullbright() end
        if key == "AutoReload" then toggleAutoReload() end
    end)

    local kb = Instance.new("TextButton")
    kb.Size = UDim2.fromOffset(60, 26)
    kb.Position = UDim2.new(1, -70, 0, 0)
    kb.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    kb.BorderSizePixel = 0
    kb.Text = getBindText(key)
    kb.TextColor3 = Keybinds[key] and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(120, 120, 120)
    kb.Font = Enum.Font.Code
    kb.TextSize = 12
    kb.ZIndex = 12
    kb.Parent = btn

    kb.MouseButton1Click:Connect(function()
        bindingKey = key
        kb.Text = "..."
        kb.TextColor3 = Color3.fromRGB(255, 200, 60)
    end)

    kb.MouseButton2Click:Connect(function()
        Keybinds[key] = nil
        kb.Text = "—"
        kb.TextColor3 = Color3.fromRGB(120, 120, 120)
    end)

    toggles[key] = {btn = btn, kb = kb, label = label}
end

-- СЛАЙДЕРЫ
local function makeSlider(page, label, min, max, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 44)
    frame.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    frame.BorderSizePixel = 0
    frame.ZIndex = 11
    frame.Parent = page

    local titleLbl = Instance.new("TextLabel")
    titleLbl.Size = UDim2.new(1, -20, 0, 18)
    titleLbl.Position = UDim2.fromOffset(10, 4)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = label .. ": " .. default
    titleLbl.TextColor3 = Color3.fromRGB(0, 255, 150)
    titleLbl.Font = Enum.Font.Code
    titleLbl.TextSize = 13
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.ZIndex = 12
    titleLbl.Parent = frame

    local sliderBg = Instance.new("Frame")
    sliderBg.Size = UDim2.new(1, -20, 0, 8)
    sliderBg.Position = UDim2.new(0, 10, 1, -18)
    sliderBg.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    sliderBg.BorderSizePixel = 0
    sliderBg.ZIndex = 12
    sliderBg.Parent = frame
    Instance.new("UICorner", sliderBg).CornerRadius = UDim.new(1, 0)

    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(0, 255, 140)
    sliderFill.BorderSizePixel = 0
    sliderFill.ZIndex = 13
    sliderFill.Parent = sliderBg
    Instance.new("UICorner", sliderFill).CornerRadius = UDim.new(1, 0)

    local thumb = Instance.new("Frame")
    thumb.Size = UDim2.fromOffset(16, 16)
    thumb.AnchorPoint = Vector2.new(0.5, 0.5)
    thumb.Position = UDim2.new((default - min) / (max - min), 0, 0.5, 0)
    thumb.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    thumb.BorderSizePixel = 0
    thumb.ZIndex = 14
    thumb.Parent = sliderBg
    Instance.new("UICorner", thumb).CornerRadius = UDim.new(1, 0)

    local dragging = false

    local function update(value)
        value = mathclamp(value, min, max)
        local percent = (value - min) / (max - min)
        sliderFill.Size = UDim2.new(percent, 0, 1, 0)
        thumb.Position = UDim2.new(percent, 0, 0.5, 0)
        titleLbl.Text = label .. ": " .. mathfloor(value)
        callback(mathfloor(value))
    end

    local function getValue(x)
        local absPos = sliderBg.AbsolutePosition.X
        local absSize = sliderBg.AbsoluteSize.X
        local rel = mathclamp((x - absPos) / absSize, 0, 1)
        return min + (max - min) * rel
    end

    sliderBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            update(getValue(input.Position.X))
        end
    end)

    thumb.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            update(getValue(input.Position.X))
        end
    end)

    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch
