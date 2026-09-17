-- ============================================
-- CHEAT SCRIPT FOR EXECUTOR + NPC HIGHLIGHT
-- ============================================

local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local Stats = game:GetService("Stats")
local Lighting = game:GetService("Lighting")
local VirtualUser = game:GetService("VirtualUser")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

if _G.MyCheatLoaded then return end
_G.MyCheatLoaded = true

for _, g in ipairs(LP:WaitForChild("PlayerGui"):GetChildren()) do
    if g.Name == "CheatGUI" then g:Destroy() end
end

local Config = {
    ESP = true, Box = true, Name = true, HP = true, Tool = true,
    Chams = true, Tracers = false,
    Aimbot = false, ShowFOV = true, FOV = 100,
    VisibleOnly = true,
    FIRE_RATE = 0.1, AimStrength = 0.85,
    Fly = false, Noclip = false,
    SpeedHack = false, WalkSpeed = 16,
    InfiniteJump = false, BunnyHop = false,
    AntiAFK = true, Fullbright = false, AutoReload = false,
    NPCHighlight = true,
}

local Keybinds = {
    Aimbot = Enum.KeyCode.Q,
    Fly = Enum.KeyCode.F,
    Noclip = Enum.KeyCode.V,
    BunnyHop = Enum.KeyCode.B,
    AutoReload = Enum.KeyCode.R,
    Menu = Enum.KeyCode.Delete,
}

local gui = Instance.new("ScreenGui")
gui.Name = "CheatGUI"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.DisplayOrder = 999999
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = LP:WaitForChild("PlayerGui")

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
infoLabel.Parent = gui
Instance.new("UICorner", infoLabel).CornerRadius = UDim.new(0, 6)

local fps, frames, lastTime = 0, 0, tick()

local main = Instance.new("Frame")
main.Size = UDim2.fromOffset(320, 480)
main.Position = UDim2.new(0.5, -160, 0.5, -240)
main.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
main.BorderSizePixel = 0
main.Visible = false
main.Active = true
main.Draggable = true
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
title.Parent = main

local close = Instance.new("TextButton")
close.Size = UDim2.fromOffset(30, 30)
close.Position = UDim2.new(1, -30, 0, 0)
close.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
close.BorderSizePixel = 0
close.Text = "X"
close.TextColor3 = Color3.fromRGB(255, 255, 255)
close.Parent = main

close.MouseButton1Click:Connect(function()
    main.Visible = false
end)

local tabsBar = Instance.new("Frame")
tabsBar.Size = UDim2.new(1, 0, 0, 30)
tabsBar.Position = UDim2.fromOffset(0, 30)
tabsBar.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
tabsBar.BorderSizePixel = 0
tabsBar.Parent = main

local tabsLayout = Instance.new("UIListLayout")
tabsLayout.FillDirection = Enum.FillDirection.Horizontal
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
    page.Parent = main

    local layout = Instance.new("UIListLayout")
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
notify.Visible = false
notify.Parent = gui

function showNotify(text, color)
    notify.Text = text
    notify.TextColor3 = color or Color3.fromRGB(0, 255, 150)
    notify.Visible = true
    task.spawn(function()
        task.wait(1.5)
        notify.Visible = false
    end)
end

local fovCircle = Instance.new("Frame")
fovCircle.AnchorPoint = Vector2.new(0.5, 0.5)
fovCircle.Position = UDim2.new(0.5, 0, 0.5, 0)
fovCircle.BackgroundTransparency = 1
fovCircle.BorderSizePixel = 0
fovCircle.Visible = false
fovCircle.Parent = gui

local fovStroke = Instance.new("UIStroke")
fovStroke.Color = Color3.fromRGB(0, 255, 150)
fovStroke.Thickness = 2
fovStroke.Transparency = 0.2
fovStroke.Parent = fovCircle
Instance.new("UICorner", fovCircle).CornerRadius = UDim.new(1, 0)

local rayParams = RaycastParams.new()
rayParams.FilterType = Enum.RaycastFilterType.Exclude

-- ==== NPC HIGHLIGHT ====
local npcHighlights = {}
local NPC_HIGHLIGHT_ENABLED = true
local NPC_FILL_COLOR = Color3.fromRGB(0, 200, 255)
local NPC_FILL_TRANSPARENCY = 0.5
local NPC_OUTLINE_COLOR = Color3.fromRGB(255, 255, 255)
local NPC_OUTLINE_TRANSPARENCY = 0

local function isNPC(model)
    if not model:IsA("Model") then return false end
    if model == LP.Character then return false end
    local hum = model:FindFirstChildOfClass("Humanoid")
    if not hum then return false end
    local plr = Players:GetPlayerFromCharacter(model)
    if plr then return false end
    return true
end

local function addNPCHighlight(model)
    if not NPC_HIGHLIGHT_ENABLED then return end
    if npcHighlights[model] then return end
    if not isNPC(model) then return end

    local hl = Instance.new("Highlight")
    hl.Name = "NPCHighlight"
    hl.Adornee = model
    hl.FillColor = NPC_FILL_COLOR
    hl.FillTransparency = NPC_FILL_TRANSPARENCY
    hl.OutlineColor = NPC_OUTLINE_COLOR
    hl.OutlineTransparency = NPC_OUTLINE_TRANSPARENCY
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    hl.Enabled = true
    hl.Parent = model

    npcHighlights[model] = hl
end

local function removeNPCHighlight(model)
    if npcHighlights[model] then
        npcHighlights[model]:Destroy()
        npcHighlights[model] = nil
    end
end

local function scanNPCs()
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and isNPC(obj) then
            addNPCHighlight(obj)
        end
    end
end

local function setNPCHighlightEnabled(state)
    NPC_HIGHLIGHT_ENABLED = state
    if state then
        scanNPCs()
    else
        for model, hl in pairs(npcHighlights) do
            hl:Destroy()
        end
        npcHighlights = {}
    end
end

scanNPCs()

workspace.DescendantAdded:Connect(function(obj)
    if not NPC_HIGHLIGHT_ENABLED then return end
    if obj:IsA("Model") then
        task.wait(0.1)
        addNPCHighlight(obj)
    elseif obj:IsA("Humanoid") and obj.Parent then
        task.wait(0.1)
        addNPCHighlight(obj.Parent)
    end
end)

workspace.DescendantRemoving:Connect(function(obj)
    if obj:IsA("Model") then
        removeNPCHighlight(obj)
    end
end)
-- ==== КОНЕЦ NPC HIGHLIGHT ====

local function isVisible(fromPos, toPos, charToIgnore)
    rayParams.FilterDescendantsInstances = {LP.Character, charToIgnore}
    local result = workspace:Raycast(fromPos, toPos - fromPos, rayParams)
    return result == nil or result.Instance:IsDescendantOf(charToIgnore)
end

local cache = {}

local function createESP(player)
    if player == LP then return end
    local box = Instance.new("Frame")
    box.BackgroundTransparency = 1
    box.BorderSizePixel = 0
    box.Visible = false
    box.Parent = gui

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(0, 255, 140)
    stroke.Thickness = 1
    stroke.Parent = box

    local nameLbl = Instance.new("TextLabel")
    nameLbl.BackgroundTransparency = 1
    nameLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLbl.TextStrokeTransparency = 0.35
    nameLbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    nameLbl.TextSize = 14
    nameLbl.Font = Enum.Font.GothamBold
    nameLbl.Size = UDim2.new(1, 0, 0, 18)
    nameLbl.Position = UDim2.new(0, 0, 0, -22)
    nameLbl.TextXAlignment = Enum.TextXAlignment.Center
    nameLbl.Parent = box

    local toolLbl = Instance.new("TextLabel")
    toolLbl.BackgroundTransparency = 1
    toolLbl.TextColor3 = Color3.fromRGB(255, 210, 80)
    toolLbl.TextStrokeTransparency = 0.35
    toolLbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    toolLbl.TextSize = 12
    toolLbl.Font = Enum.Font.Gotham
    toolLbl.Size = UDim2.new(1, 0, 0, 16)
    toolLbl.Position = UDim2.new(0, 0, 1, 5)
    toolLbl.TextXAlignment = Enum.TextXAlignment.Center
    toolLbl.Parent = box

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

    local tracer = Instance.new("Frame")
    tracer.BackgroundColor3 = Color3.fromRGB(0, 255, 140)
    tracer.BorderSizePixel = 0
    tracer.AnchorPoint = Vector2.new(0.5, 0)
    tracer.Size = UDim2.fromOffset(1, 0)
    tracer.Visible = false
    tracer.Parent = gui

    cache[player] = {
        box = box, stroke = stroke, nameLbl = nameLbl, toolLbl = toolLbl,
        hpBg = hpBg, hpFill = hpFill, highlight = nil, tracer = tracer,
    }
end

local function removeESP(player)
    local d = cache[player]
    if d then
        if d.highlight then d.highlight:Destroy() end
        if d.tracer then d.tracer:Destroy() end
        d.box:Destroy()
        cache[player] = nil
    end
end

Players.PlayerAdded:Connect(createESP)
Players.PlayerRemoving:Connect(removeESP)

for _, p in ipairs(Players:GetPlayers()) do
    createESP(p)
end

-- FLY
local flying = false
local flySpeed = 100
local maxFlySpeed = 1000
local speedIncrement = 0.4
local originalGravity = workspace.Gravity
local flyThread = nil

local function randomizeValue(value, range)
    return value + (value * (math.random(-range, range) / 100))
end

local function flyLoop()
    while flying do
        local char = LP.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if not root then break end

        local MoveDirection = Vector3.new()
        local cameraCFrame = Camera.CFrame

        if UIS:IsKeyDown(Enum.KeyCode.W) then MoveDirection += cameraCFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then MoveDirection -= cameraCFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then MoveDirection -= cameraCFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then MoveDirection += cameraCFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.Space) then MoveDirection += Vector3.new(0, 1, 0) end
        if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then MoveDirection -= Vector3.new(0, 1, 0) end

        if MoveDirection.Magnitude > 0 then
            flySpeed = math.min(flySpeed + speedIncrement, maxFlySpeed)
            MoveDirection = MoveDirection.Unit * math.min(randomizeValue(flySpeed, 10), maxFlySpeed)
            root.AssemblyLinearVelocity = MoveDirection * 0.5
        else
            root.AssemblyLinearVelocity = Vector3.zero
        end

        RunService.RenderStepped:Wait()
    end
end

function toggleFly()
    if Config.Fly then
        flying = true
        workspace.Gravity = 0
        flyThread = task.spawn(flyLoop)
    else
        flying = false
        flySpeed = 100
        workspace.Gravity = originalGravity
        local char = LP.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if root then root.AssemblyLinearVelocity = Vector3.zero end
    end
end

-- NOCLIP
local noclipConn = nil

local function startNoclip()
    if noclipConn then return end
    noclipConn = RunService.Stepped:Connect(function()
        if not Config.Noclip then return end
        local char = LP.Character
        if not char then return end
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end)
end

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

function toggleNoclip()
    if Config.Noclip then
        startNoclip()
    else
        stopNoclip()
    end
end

-- SPEED HACK
local speedConn

function toggleSpeedHack()
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

function toggleInfiniteJump()
    if infJumpConn then infJumpConn:Disconnect() infJumpConn = nil end
    if Config.InfiniteJump then
        infJumpConn = UIS.JumpRequest:Connect(function()
            local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
        end)
    end
end

-- BUNNY HOP
local bhopConn

function toggleBunnyHop()
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

function toggleAntiAFK()
    if antiAfkConn then antiAfkConn:Disconnect() antiAfkConn = nil end
    if Config.AntiAFK then
        antiAfkConn = LP.Idled:Connect(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end)
    end
end

-- FULLBRIGHT
local origLighting = {
    Brightness = Lighting.Brightness,
    ClockTime = Lighting.ClockTime,
    Ambient = Lighting.Ambient,
    OutdoorAmbient = Lighting.OutdoorAmbient,
    FogEnd = Lighting.FogEnd,
    GlobalShadows = Lighting.GlobalShadows,
}

function toggleFullbright()
    if Config.Fullbright then
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.Ambient = Color3.fromRGB(200, 200, 200)
        Lighting.OutdoorAmbient = Color3.fromRGB(200, 200, 200)
        Lighting.FogEnd = 100000
        Lighting.GlobalShadows = false
    else
        Lighting.Brightness = origLighting.Brightness
        Lighting.ClockTime = origLighting.ClockTime
        Lighting.Ambient = origLighting.Ambient
        Lighting.OutdoorAmbient = origLighting.OutdoorAmbient
        Lighting.FogEnd = origLighting.FogEnd
        Lighting.GlobalShadows = origLighting.GlobalShadows
    end
end

-- AUTO-RELOAD
local autoReloadConn = nil

function toggleAutoReload()
    if autoReloadConn then autoReloadConn:Disconnect() autoReloadConn = nil end
    if Config.AutoReload then
        autoReloadConn = RunService.Heartbeat:Connect(function()
            local char = LP.Character
            if not char then return end
            local tool = char:FindFirstChildOfClass("Tool")
            if not tool then return end

            local ammo = tool:GetAttribute("Ammo") or tool:GetAttribute("CurrentAmmo")
            if ammo and ammo <= 0 then
                pcall(function() tool:Activate() end)
            end

            local remote = ReplicatedStorage:FindFirstChild("Reload") or ReplicatedStorage:FindFirstChild("ReloadEvent")
            if remote and remote:IsA("RemoteEvent") then
                pcall(function() remote:FireServer() end)
            end
        end)
    end
end

-- MENU
local toggles = {}

local function makeToggle(page, label, key)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 26)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    btn.BorderSizePixel = 0
    btn.Text = string.format("  [%s]  %s", Config[key] and "+" or "-", label)
    btn.TextColor3 = Config[key] and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(180, 180, 180)
    btn.Font = Enum.Font.Code
    btn.TextSize = 13
    btn.TextXAlignment = Enum.TextXAlignment.Left
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
        if key == "NPCHighlight" then setNPCHighlightEnabled(Config.NPCHighlight) end
    end)

    toggles[key] = {btn = btn, label = label}
end

local function makeSlider(page, label, min, max, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 44)
    frame.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    frame.BorderSizePixel = 0
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
    titleLbl.Parent = frame

    local sliderBg = Instance.new("Frame")
    sliderBg.Size = UDim2.new(1, -20, 0, 8)
    sliderBg.Position = UDim2.new(0, 10, 1, -18)
    sliderBg.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    sliderBg.BorderSizePixel = 0
    sliderBg.Parent = frame
    Instance.new("UICorner", sliderBg).CornerRadius = UDim.new(1, 0)

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(0, 255, 140)
    fill.BorderSizePixel = 0
    fill.Parent = sliderBg
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

    local thumb = Instance.new("Frame")
    thumb.Size = UDim2.fromOffset(16, 16)
    thumb.AnchorPoint = Vector2.new(0.5, 0.5)
    thumb.Position = UDim2.new((default - min) / (max - min), 0, 0.5, 0)
    thumb.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    thumb.BorderSizePixel = 0
    thumb.Parent = sliderBg
    Instance.new("UICorner", thumb).CornerRadius = UDim.new(1, 0)

    local dragging = false

    local function update(value)
        value = math.clamp(value, min, max)
        local p = (value - min) / (max - min)
        fill.Size = UDim2.new(p, 0, 1, 0)
        thumb.Position = UDim2.new(p, 0, 0.5, 0)
        titleLbl.Text = label .. ": " .. math.floor(value)
        callback(math.floor(value))
    end

    local function getVal(x)
        local absPos = sliderBg.AbsolutePosition.X
        local absSize = sliderBg.AbsoluteSize.X
        return min + (max - min) * math.clamp((x - absPos) / absSize, 0, 1)
    end

    sliderBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            update(getVal(input.Position.X))
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            update(getVal(input.Position.X))
        end
    end)

    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

makeToggle(pages.Visual, "ESP Master", "ESP")
makeToggle(pages.Visual, "Box", "Box")
makeToggle(pages.Visual, "Name + Dist", "Name")
makeToggle(pages.Visual, "HP Bar", "HP")
makeToggle(pages.Visual, "Tool", "Tool")
makeToggle(pages.Visual, "Chams", "Chams")
makeToggle(pages.Visual, "Tracers", "Tracers")
makeToggle(pages.Visual, "NPC Highlight", "NPCHighlight")

makeToggle(pages.Aimbot, "Aimbot", "Aimbot")
makeToggle(pages.Aimbot, "Show FOV", "ShowFOV")
makeToggle(pages.Aimbot, "Visible Only", "VisibleOnly")
makeSlider(pages.Aimbot, "FOV", 20, 500, Config.FOV, function(v) Config.FOV = v end)
makeSlider(pages.Aimbot, "Aim Strength", 0.1, 1.0, Config.AimStrength, function(v) Config.AimStrength = v end)

makeToggle(pages.Movement, "Fly", "Fly")
makeToggle(pages.Movement, "Noclip", "Noclip")
makeToggle(pages.Movement, "Speed Hack", "SpeedHack")
makeToggle(pages.Movement, "Infinite Jump", "InfiniteJump")
makeToggle(pages.Movement, "Bunny Hop", "BunnyHop")
makeSlider(pages.Movement, "Walk Speed", 16, 200, Config.WalkSpeed, function(v)
    Config.WalkSpeed = v
    if Config.SpeedHack then
        local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = v end
    end
end)

makeToggle(pages.Misc, "Anti-AFK", "AntiAFK")
makeToggle(pages.Misc, "Fullbright", "Fullbright")
makeToggle(pages.Misc, "Auto Reload", "AutoReload")
makeToggle(pages.Misc, "Menu Key", "Menu")

selectTab("Visual")

UIS.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.UserInputType ~= Enum.UserInputType.Keyboard then return end

    for key, bind in pairs(Keybinds) do
        if input.KeyCode == bind then
            if key == "Menu" then
                main.Visible = not main.Visible
                return
            end
            if Config[key] ~= nil then
                Config[key] = not Config[key]
                if toggles[key] then
                    local t = toggles[key]
                    t.btn.Text = string.format("  [%s]  %s", Config[key] and "+" or "-", t.label)
                    t.btn.TextColor3 = Config[key] and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(180, 180, 180)
                end
                if key == "Fly" then toggleFly() end
                if key == "Noclip" then toggleNoclip() end
                if key == "BunnyHop" then toggleBunnyHop() end
                if key == "AutoReload" then toggleAutoReload() end
                showNotify(string.format("[ %s: %s ]", key, Config[key] and "ON" or "OFF"),
                    Config[key] and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(255, 80, 80))
            end
            return
        end
    end
end)

LP.CharacterAdded:Connect(function()
    task.wait(0.5)
    if Config.Fly then
        flying = false
        toggleFly()
    end
    if Config.Noclip then toggleNoclip() end
    if Config.SpeedHack then toggleSpeedHack() end
    if Config.InfiniteJump then toggleInfiniteJump() end
    if Config.BunnyHop then toggleBunnyHop() end
    if Config.AutoReload then toggleAutoReload() end
end)

local lastShot = 0

RunService.RenderStepped:Connect(function()
    frames += 1
    if tick() - lastTime >= 1 then
        fps = frames
        frames = 0
        lastTime = tick()
        local ping = 0
        pcall(function()
            ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
        end)
        infoLabel.Text = "FPS: " .. fps .. "\nPing: " .. ping .. " ms"
    end

    if Config.ShowFOV and Config.Aimbot then
        fovCircle.Size = UDim2.fromOffset(Config.FOV * 2, Config.FOV * 2)
        fovCircle.Visible = true
    else
        fovCircle.Visible = false
    end

    if not Config.ESP and not Config.Aimbot then return end

    local vpSize = Camera.ViewportSize
    local centerX, centerY = vpSize.X * 0.5, vpSize.Y * 0.5
    local closestTarget, shortest = nil, Config.FOV
    local camPos = Camera.CFrame.Position

    for player, esp in pairs(cache) do
        local char = player.Character
        local head = char and char:FindFirstChild("Head")
        local root = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")

        if not (head and root and hum and hum.Health > 0) then
            esp.box.Visible = false
            if esp.tracer then esp.tracer.Visible = false end
            continue
        end

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

        local topPos, topOn = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.9, 0))
        local botPos, botOn = Camera:WorldToViewportPoint(root.Position - Vector3.new(0, 3.1, 0))
        local onScreen = topOn and botOn and topPos.Z > 0 and botPos.Z > 0

        if onScreen and Config.ESP then
            local height = math.abs(botPos.Y - topPos.Y)
            local width = height * 0.55

            esp.box.Visible = Config.Box
            esp.box.Position = UDim2.fromOffset(topPos.X - width/2, topPos.Y)
            esp.box.Size = UDim2.fromOffset(width, height)

            local ratio = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
            local boxColor = ratio > 0.6 and Color3.fromRGB(0, 255, 140)
                or ratio > 0.3 and Color3.fromRGB(255, 220, 50)
                or Color3.fromRGB(255, 70, 70)
            esp.stroke.Color = boxColor

            esp.nameLbl.Visible = Config.Name
            if Config.Name then
                local dist = math.floor((camPos - root.Position).Magnitude)
                esp.nameLbl.Text = player.Name .. " [" .. dist .. "m]"
            end

            esp.toolLbl.Visible = Config.Tool
            if Config.Tool then
                local held = char:FindFirstChildOfClass("Tool")
                esp.toolLbl.Text = held and held.Name or ""
            end

            esp.hpBg.Visible = Config.HP
            if Config.HP then
                esp.hpFill.Size = UDim2.new(1, 0, ratio, 0)
            end

            if Config.Tracers and esp.tracer then
                esp.tracer.Visible = true
                esp.tracer.Position = UDim2.new(0.5, 0, 1, 0)
                esp.tracer.Size = UDim2.fromOffset(1, (botPos.Y - vpSize.Y) * -1)
                esp.tracer.BackgroundColor3 = boxColor
            elseif esp.tracer then
                esp.tracer.Visible = false
            end
        else
            esp.box.Visible = false
            if esp.tracer then esp.tracer.Visible = false end
        end

        if Config.Aimbot then
            local headScreen, headOn = Camera:WorldToViewportPoint(head.Position)
            if headOn and headScreen.Z > 0 then
                local canAim = true
                if Config.VisibleOnly then
                    canAim = isVisible(camPos, head.Position, char)
                end
                if canAim then
                    local dx = headScreen.X - centerX
                    local dy = headScreen.Y - centerY
                    local d = (dx*dx + dy*dy) ^ 0.5
                    if d < shortest then
                        shortest = d
                        closestTarget = head
                    end
                end
            end
        end
    end

    if Config.ShowFOV and Config.Aimbot then
        fovStroke.Color = closestTarget and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(0, 255, 150)
    end

    if Config.Aimbot and closestTarget then
        Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, closestTarget.Position), Config.AimStrength)
        if tick() - lastShot >= Config.FIRE_RATE then
            lastShot = tick()
            local tool = LP.Character and LP.Character:FindFirstChildOfClass("Tool")
            if tool then tool:Activate() end
        end
    end
end)

if Config.AntiAFK then toggleAntiAFK() end

showNotify("Скрипт загружен! Delete = меню", Color3.fromRGB(0, 255, 150))
