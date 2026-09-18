-- ============================================
-- NINJA CHEAT + TOGGLE ESP + AUTOFIRE + KILL AURA
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

-- ==== НАСТРОЙКА ====
local SCRIPT_NAME = "NINJA CHEAT"
local SCRIPT_AUTHOR = "by you"
local NPC_LIST_RADIUS = 500
local NPC_LIST_MAX_ROWS = 18
local NPC_ROW_HEIGHT = 20
local ESP_TOGGLE_KEY = Enum.KeyCode.E   -- клавиша вкл/выкл ESP

local THEME = {
    bg = Color3.fromRGB(18, 18, 24),
    bg2 = Color3.fromRGB(22, 22, 30),
    bg3 = Color3.fromRGB(28, 28, 38),
    border = Color3.fromRGB(45, 45, 60),
    accent = Color3.fromRGB(168, 85, 247),
    text = Color3.fromRGB(220, 220, 230),
    textDim = Color3.fromRGB(120, 120, 140),
    danger = Color3.fromRGB(239, 68, 68),
    green = Color3.fromRGB(0, 255, 140),
    yellow = Color3.fromRGB(255, 200, 50),
    red = Color3.fromRGB(255, 80, 80),
    blue = Color3.fromRGB(100, 200, 255),
}

for _, g in ipairs(LP:WaitForChild("PlayerGui"):GetChildren()) do
    if g.Name == "CheatGUI" then g:Destroy() end
end

local Config = {
    ESP = true, Box = true, Name = true, HP = true, Tool = true,
    Chams = true, Tracers = false,
    ChamsMode = "Both",
    ESPEnabled = true,       -- ESP включён при запуске
    TeamCheck = true,
    DistanceColors = true,
    DistanceThreshold = 20,
    Aimbot = false, ShowFOV = true, FOV = 100,
    VisibleOnly = true,
    FIRE_RATE = 0.1, AimStrength = 0.85,
    AimMode = "Smooth",
    AimBone = "Head",
    AimPrediction = true,
    AimPredictionAmount = 0.15,
    AimIgnoreFOV = false,
    AimPriority = "FOV",
    AutoFire = false,
    AutoFireDelay = 0.1,
    AutoFireMode = "Auto",
    AutoFireOnlyWithAimbot = false,
    AutoFireBurstCount = 3,
    AutoFireRange = 500,
    AutoFireRequireTarget = true,
    DashAimbot = true,
    DashThreshold = 40,
    DashLockTime = 0.8,
    DashIgnoreFOV = true,
    DashHighlight = true,
    KillAura = false,
    KillAuraRange = 15,
    KillAuraDelay = 0.15,
    KillAuraRotate = true,
    Fly = false, Noclip = false,
    SpeedHack = false, WalkSpeed = 16,
    InfiniteJump = false, BunnyHop = false,
    AntiAFK = true, Fullbright = false, AutoReload = false,
    NPCHighlight = true, NPCList = true,
}

local Binds = {
    Aimbot = Enum.KeyCode.Q,
    AutoFire = Enum.KeyCode.X,
    KillAura = Enum.KeyCode.K,
    DashAimbot = Enum.KeyCode.Z,
    Fly = Enum.KeyCode.F,
    Noclip = Enum.KeyCode.V,
    BunnyHop = Enum.KeyCode.B,
    AutoReload = Enum.KeyCode.R,
    NPCHighlight = Enum.KeyCode.H,
    NPCList = Enum.KeyCode.N,
    ESP = Enum.KeyCode.E,
    Chams = Enum.KeyCode.C,
    Fullbright = Enum.KeyCode.L,
    SpeedHack = Enum.KeyCode.G,
    InfiniteJump = Enum.KeyCode.J,
    AntiAFK = Enum.KeyCode.P,
    Menu = Enum.KeyCode.Delete,
}

local gui = Instance.new("ScreenGui")
gui.Name = "CheatGUI"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.DisplayOrder = 999999
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = LP:WaitForChild("PlayerGui")

-- ==== INFO ====
local infoLabel = Instance.new("TextLabel")
infoLabel.Size = UDim2.fromOffset(140, 44)
infoLabel.Position = UDim2.new(1, -150, 0, 10)
infoLabel.BackgroundColor3 = THEME.bg2
infoLabel.BackgroundTransparency = 0.15
infoLabel.BorderSizePixel = 0
infoLabel.TextColor3 = THEME.accent
infoLabel.Font = Enum.Font.Code
infoLabel.TextSize = 13
infoLabel.Text = "FPS: --\nPing: --"
infoLabel.TextXAlignment = Enum.TextXAlignment.Left
infoLabel.TextYAlignment = Enum.TextYAlignment.Center
infoLabel.ZIndex = 500
infoLabel.Parent = gui
Instance.new("UICorner", infoLabel).CornerRadius = UDim.new(0, 8)

-- ==== NPC LIST UI ====
local npcListFrame = Instance.new("Frame")
npcListFrame.Size = UDim2.fromOffset(280, 420)
npcListFrame.Position = UDim2.fromOffset(10, 10)
npcListFrame.BackgroundColor3 = THEME.bg
npcListFrame.BackgroundTransparency = 0.15
npcListFrame.BorderSizePixel = 0
npcListFrame.Visible = true
npcListFrame.ZIndex = 500
npcListFrame.Parent = gui
Instance.new("UICorner", npcListFrame).CornerRadius = UDim.new(0, 8)
local npcListStroke = Instance.new("UIStroke", npcListFrame)
npcListStroke.Color = THEME.accent
npcListStroke.Thickness = 1
npcListStroke.Transparency = 0.4

local npcListTitle = Instance.new("TextLabel")
npcListTitle.Size = UDim2.new(1, 0, 0, 26)
npcListTitle.BackgroundTransparency = 1
npcListTitle.Text = "  NPC / PLAYER LIST"
npcListTitle.TextColor3 = THEME.accent
npcListTitle.Font = Enum.Font.GothamBold
npcListTitle.TextSize = 14
npcListTitle.TextXAlignment = Enum.TextXAlignment.Left
npcListTitle.ZIndex = 501
npcListTitle.Parent = npcListFrame

local npcListContainer = Instance.new("Frame")
npcListContainer.Size = UDim2.new(1, -10, 1, -34)
npcListContainer.Position = UDim2.fromOffset(5, 30)
npcListContainer.BackgroundTransparency = 1
npcListContainer.ClipsDescendants = true
npcListContainer.ZIndex = 501
npcListContainer.Parent = npcListFrame

local fps, frames, lastTime = 0, 0, tick()

-- ==== MENU BUTTON ====
local openBtn = Instance.new("TextButton")
openBtn.Size = UDim2.fromOffset(100, 32)
openBtn.Position = UDim2.new(0, 10, 0, 440)
openBtn.BackgroundColor3 = THEME.accent
openBtn.BorderSizePixel = 0
openBtn.Text = "MENU"
openBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
openBtn.Font = Enum.Font.GothamBold
openBtn.TextSize = 14
openBtn.ZIndex = 3000
openBtn.Parent = gui
Instance.new("UICorner", openBtn).CornerRadius = UDim.new(0, 6)

-- ==== MAIN WINDOW ====
local main = Instance.new("Frame")
main.Size = UDim2.fromOffset(520, 440)
main.Position = UDim2.new(0.5, -260, 0.5, -220)
main.BackgroundColor3 = THEME.bg
main.BorderSizePixel = 0
main.Visible = true
main.Active = true
main.Draggable = true
main.ZIndex = 1000
main.Parent = gui
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10)
local mainStroke = Instance.new("UIStroke", main)
mainStroke.Color = THEME.border
mainStroke.Thickness = 1

openBtn.MouseButton1Click:Connect(function()
    main.Visible = not main.Visible
end)

local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = THEME.bg2
titleBar.BorderSizePixel = 0
titleBar.ZIndex = 1001
titleBar.Parent = main
Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 10)
local titleFix = Instance.new("Frame")
titleFix.Size = UDim2.new(1, 0, 0, 10)
titleFix.Position = UDim2.new(0, 0, 1, -10)
titleFix.BackgroundColor3 = THEME.bg2
titleFix.BorderSizePixel = 0
titleFix.ZIndex = 1001
titleFix.Parent = titleBar

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -50, 0, 40)
title.Position = UDim2.fromOffset(16, 0)
title.BackgroundTransparency = 1
title.Text = SCRIPT_NAME
title.TextColor3 = THEME.accent
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextXAlignment = Enum.TextXAlignment.Left
title.ZIndex = 1002
title.Parent = titleBar

local subtitle = Instance.new("TextLabel")
subtitle.Size = UDim2.new(1, -50, 0, 40)
subtitle.Position = UDim2.fromOffset(16, 0)
subtitle.BackgroundTransparency = 1
subtitle.Text = SCRIPT_AUTHOR
subtitle.TextColor3 = THEME.textDim
subtitle.Font = Enum.Font.Code
subtitle.TextSize = 10
subtitle.TextXAlignment = Enum.TextXAlignment.Left
subtitle.TextYAlignment = Enum.TextYAlignment.Bottom
subtitle.ZIndex = 1002
subtitle.Parent = titleBar

local close = Instance.new("TextButton")
close.Size = UDim2.fromOffset(28, 28)
close.Position = UDim2.new(1, -36, 0, 6)
close.BackgroundColor3 = THEME.danger
close.BorderSizePixel = 0
close.Text = "X"
close.TextColor3 = Color3.fromRGB(255, 255, 255)
close.Font = Enum.Font.GothamBold
close.TextSize = 14
close.ZIndex = 1002
close.Parent = titleBar
Instance.new("UICorner", close).CornerRadius = UDim.new(0, 6)
close.MouseButton1Click:Connect(function() main.Visible = false end)

local sidebar = Instance.new("Frame")
sidebar.Size = UDim2.new(0, 120, 1, -50)
sidebar.Position = UDim2.fromOffset(8, 46)
sidebar.BackgroundColor3 = THEME.bg2
sidebar.BorderSizePixel = 0
sidebar.ZIndex = 1001
sidebar.Parent = main
Instance.new("UICorner", sidebar).CornerRadius = UDim.new(0, 8)

local sideLayout = Instance.new("UIListLayout")
sideLayout.Padding = UDim.new(0, 4)
sideLayout.Parent = sidebar

local sidePad = Instance.new("UIPadding")
sidePad.PaddingTop = UDim.new(0, 8)
sidePad.PaddingLeft = UDim.new(0, 6)
sidePad.PaddingRight = UDim.new(0, 6)
sidePad.Parent = sidebar

local content = Instance.new("Frame")
content.Size = UDim2.new(1, -144, 1, -58)
content.Position = UDim2.fromOffset(136, 46)
content.BackgroundColor3 = THEME.bg2
content.BorderSizePixel = 0
content.ZIndex = 1001
content.Parent = main
Instance.new("UICorner", content).CornerRadius = UDim.new(0, 8)

local pages = {}
local tabButtons = {}

local function selectTab(name)
    for tabName, page in pairs(pages) do page.Visible = (tabName == name) end
    for tabName, btn in pairs(tabButtons) do
        if tabName == name then
            btn.BackgroundColor3 = THEME.accent
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        else
            btn.BackgroundColor3 = THEME.bg3
            btn.TextColor3 = THEME.textDim
        end
    end
end

local function createTab(name, displayName, emoji)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 32)
    btn.BackgroundColor3 = THEME.bg3
    btn.BorderSizePixel = 0
    btn.Text = "  " .. emoji .. "  " .. displayName
    btn.TextColor3 = THEME.textDim
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 13
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.ZIndex = 1002
    btn.Parent = sidebar
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    local page = Instance.new("ScrollingFrame")
    page.Size = UDim2.new(1, -16, 1, -16)
    page.Position = UDim2.fromOffset(8, 8)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.ScrollBarThickness = 3
    page.ScrollBarImageColor3 = THEME.accent
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    page.Visible = false
    page.ZIndex = 1002
    page.Parent = content

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 5)
    layout.Parent = page

    pages[name] = page
    tabButtons[name] = btn
    btn.MouseButton1Click:Connect(function() selectTab(name) end)
end

createTab("Visual", "Visual", "👁")
createTab("Combat", "Combat", "⚔")
createTab("Movement", "Move", "🏃")
createTab("Misc", "Misc", "⚙")

local notify = Instance.new("TextLabel")
notify.Size = UDim2.fromOffset(280, 40)
notify.Position = UDim2.new(0.5, -140, 0, 20)
notify.BackgroundColor3 = THEME.bg2
notify.BackgroundTransparency = 0.1
notify.BorderSizePixel = 0
notify.Text = ""
notify.TextColor3 = THEME.accent
notify.Font = Enum.Font.Gotham
notify.TextSize = 14
notify.Visible = false
notify.ZIndex = 2000
notify.Parent = gui
Instance.new("UICorner", notify).CornerRadius = UDim.new(0, 8)
local notifyStroke = Instance.new("UIStroke", notify)
notifyStroke.Color = THEME.accent
notifyStroke.Thickness = 1

function showNotify(text, color)
    notify.Text = text
    notify.TextColor3 = color or THEME.accent
    notifyStroke.Color = color or THEME.accent
    notify.Visible = true
    task.spawn(function()
        task.wait(1.5)
        notify.Visible = false
    end)
end

-- FOV Circle
local fovCircle = Drawing.new("Circle")
fovCircle.Thickness = 1
fovCircle.Color = Color3.fromRGB(168, 85, 247)
fovCircle.Transparency = 0.4
fovCircle.Visible = false

local rayParams = RaycastParams.new()
rayParams.FilterType = Enum.RaycastFilterType.Exclude

-- ==== ЦВЕТА ESP ====
local function getESPColor(player, distance)
    local isSameTeam = false
    if Config.TeamCheck then
        local lpTeam = LP.Team
        if lpTeam and player.Team == lpTeam then
            isSameTeam = true
        end
    end

    if isSameTeam then
        if Config.DistanceColors and distance > Config.DistanceThreshold then
            return Color3.fromRGB(0, 255, 255)
        else
            return Color3.fromRGB(0, 0, 255)
        end
    else
        if Config.DistanceColors and distance > Config.DistanceThreshold then
            return Color3.fromRGB(255, 165, 0)
        else
            return Color3.fromRGB(255, 0, 0)
        end
    end
end

-- ==== DASH SYSTEM ====
local playerVelocity = {}
local DASH_LOCK = {}

local function checkDash(player)
    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local vel = hrp.AssemblyLinearVelocity.Magnitude
    local now = tick()
    local prev = playerVelocity[player]
    if not prev then
        playerVelocity[player] = {vel = vel, time = now}
        return
    end
    local delta = math.abs(vel - prev.vel)
    if delta >= Config.DashThreshold and vel > 50 then
        DASH_LOCK[player] = now + Config.DashLockTime
        if not prev.notified then
            prev.notified = true
            showNotify("DASH: " .. player.Name, THEME.yellow)
            task.delay(0.3, function() if prev then prev.notified = false end end)
        end
    end
    prev.vel = vel
    prev.time = now
end

local dashHighlights = {}
local function updateDashHighlight(player)
    local char = player.Character
    if not char then
        if dashHighlights[player] then
            dashHighlights[player]:Destroy()
            dashHighlights[player] = nil
        end
        return
    end
    local isDashing = DASH_LOCK[player] and DASH_LOCK[player] > tick()
    if isDashing and Config.DashHighlight then
        if not dashHighlights[player] or dashHighlights[player].Parent ~= char then
            if dashHighlights[player] then dashHighlights[player]:Destroy() end
            local hl = Instance.new("Highlight")
            hl.Name = "DashHighlight"
            hl.FillColor = Color3.fromRGB(255, 200, 50)
            hl.FillTransparency = 0.3
            hl.OutlineColor = Color3.fromRGB(255, 255, 0)
            hl.OutlineTransparency = 0
            hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            hl.Adornee = char
            hl.Parent = char
            dashHighlights[player] = hl
        end
    else
        if dashHighlights[player] then
            dashHighlights[player]:Destroy()
            dashHighlights[player] = nil
        end
    end
end

-- ==== NPC HIGHLIGHT ====
local npcHighlights = {}
local NPC_HIGHLIGHT_ENABLED = true

local function isNPC(model)
    if not model:IsA("Model") then return false end
    if model == LP.Character then return false end
    local hum = model:FindFirstChildOfClass("Humanoid")
    if not hum then return false end
    if Players:GetPlayerFromCharacter(model) then return false end
    return true
end

local function addNPCHighlight(model)
    if not NPC_HIGHLIGHT_ENABLED then return end
    if npcHighlights[model] then return end
    if not isNPC(model) then return end
    local hl = Instance.new("Highlight")
    hl.Name = "NPCHighlight"
    hl.Adornee = model
    hl.FillColor = THEME.accent
    hl.FillTransparency = 0.5
    hl.OutlineColor = Color3.fromRGB(255, 255, 255)
    hl.OutlineTransparency = 0
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
        if obj:IsA("Model") and isNPC(obj) then addNPCHighlight(obj) end
    end
end

local function setNPCHighlightEnabled(state)
    NPC_HIGHLIGHT_ENABLED = state
    if state then
        scanNPCs()
    else
        for m, hl in pairs(npcHighlights) do hl:Destroy() end
        npcHighlights = {}
    end
end

scanNPCs()

workspace.DescendantAdded:Connect(function(obj)
    if not NPC_HIGHLIGHT_ENABLED then return end
    if obj:IsA("Model") then task.wait(0.1) addNPCHighlight(obj) end
end)

workspace.DescendantRemoving:Connect(function(obj)
    if obj:IsA("Model") then removeNPCHighlight(obj) end
end)

-- ==== NPC LIST ====
local npcRows = {}

local function getNPCPosition(obj)
    local r = obj:FindFirstChild("HumanoidRootPart")
        or obj:FindFirstChild("Torso")
        or obj:FindFirstChild("UpperTorso")
        or obj:FindFirstChild("LowerTorso")
        or obj.PrimaryPart
        or obj:FindFirstChildWhichIsA("BasePart")
    if r then return r.Position end
    for _, d in ipairs(obj:GetDescendants()) do
        if d:IsA("BasePart") then return d.Position end
    end
    return nil
end

task.spawn(function()
    while task.wait(0.3) do
        if not Config.NPCList then
            if npcListFrame.Visible then npcListFrame.Visible = false end
            continue
        end
        if not npcListFrame.Visible then npcListFrame.Visible = true end

        local myPos
        local char = LP.Character
        if char then
            local hrp = char:FindFirstChild("HumanoidRootPart")
            myPos = hrp and hrp.Position or Camera.CFrame.Position
        else
            myPos = Camera.CFrame.Position
        end

        local list = {}

        -- workspace.Players
        local plrFolder = workspace:FindFirstChild("Players")
        if plrFolder then
            for _, obj in ipairs(plrFolder:GetChildren()) do
                if obj:IsA("Model") and obj ~= LP.Character then
                    local hum = obj:FindFirstChildOfClass("Humanoid")
                    if hum and hum.Health > 0 then
                        local pos = getNPCPosition(obj)
                        if pos then
                            local d = (pos - myPos).Magnitude
                            if d < NPC_LIST_RADIUS * 10 then
                                table.insert(list, {model = obj, dist = d, tag = "Players"})
                            end
                        end
                    end
                end
            end
        end

        -- Character у игроков
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LP and plr.Character then
                local hum = plr.Character:FindFirstChildOfClass("Humanoid")
                if hum and hum.Health > 0 then
                    local pos = getNPCPosition(plr.Character)
                    if pos then
                        local d = (pos - myPos).Magnitude
                        if d < NPC_LIST_RADIUS * 10 then
                            table.insert(list, {model = plr.Character, dist = d, tag = "Players"})
                        end
                    end
                end
            end
        end

        table.sort(list, function(a, b) return a.dist < b.dist end)
        while #list > NPC_LIST_MAX_ROWS do table.remove(list) end

        for _, row in pairs(npcRows) do row:Destroy() end
        npcRows = {}

        for i, data in ipairs(list) do
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1, 0, 0, NPC_ROW_HEIGHT)
            lbl.Position = UDim2.fromOffset(0, (i - 1) * NPC_ROW_HEIGHT)
            lbl.BackgroundTransparency = 1
            lbl.Font = Enum.Font.Gotham
            lbl.TextSize = 12
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.ZIndex = 502
            lbl.Text = string.format("  %s  —  %dm", data.model.Name, math.floor(data.dist))

            if data.tag == "NPCs" then lbl.TextColor3 = THEME.red
            elseif data.tag == "Players" then lbl.TextColor3 = THEME.green
            else lbl.TextColor3 = THEME.yellow end

            lbl.Parent = npcListContainer
            table.insert(npcRows, lbl)
        end
    end
end)

-- ==== ВИДИМОСТЬ ====
local function isVisible(fromPos, toPos, charToIgnore)
    rayParams.FilterDescendantsInstances = {LP.Character, charToIgnore}
    local result = workspace:Raycast(fromPos, toPos - fromPos, rayParams)
    return result == nil or result.Instance:IsDescendantOf(charToIgnore)
end

local cache = {}

-- ==== СОЗДАНИЕ ESP ====
local function createESP(player)
    if player == LP then return end
    if cache[player] then return end

    cache[player] = {
        box = Drawing.new("Square"),
        nameLbl = Drawing.new("Text"),
        toolLbl = Drawing.new("Text"),
        hpBg = Drawing.new("Square"),
        hpFill = Drawing.new("Square"),
        tracer = Drawing.new("Line"),
        highlight = nil,
    }

    local d = cache[player]
    d.box.Thickness = 1
    d.box.Filled = false
    d.box.Transparency = 1
    d.box.Visible = false

    d.nameLbl.Size = 14
    d.nameLbl.Center = true
    d.nameLbl.Outline = true
    d.nameLbl.OutlineColor = Color3.fromRGB(0, 0, 0)
    d.nameLbl.Visible = false

    d.toolLbl.Size = 12
    d.toolLbl.Center = true
    d.toolLbl.Outline = true
    d.toolLbl.OutlineColor = Color3.fromRGB(0, 0, 0)
    d.toolLbl.Visible = false

    d.hpBg.Filled = true
    d.hpBg.Color = Color3.fromRGB(20, 20, 25)
    d.hpBg.Transparency = 0.4
    d.hpBg.Visible = false

    d.hpFill.Filled = true
    d.hpFill.Color = Color3.fromRGB(0, 255, 0)
    d.hpFill.Transparency = 1
    d.hpFill.Visible = false

    d.tracer.Thickness = 1
    d.tracer.Transparency = 0.5
    d.tracer.Visible = false

    if player.Character and Config.Chams then
        local hl = Instance.new("Highlight")
        hl.FillColor = getESPColor(player, 0)
        hl.FillTransparency = 0.55
        hl.OutlineColor = Color3.fromRGB(255, 255, 255)
        hl.OutlineTransparency = 0
        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        hl.Adornee = player.Character
        hl.Parent = player.Character
        d.highlight = hl
    end

    player.CharacterAdded:Connect(function(char)
        task.wait(0.5)
        if d.highlight then d.highlight:Destroy() end
        if Config.Chams then
            local hl = Instance.new("Highlight")
            hl.FillColor = getESPColor(player, 0)
            hl.FillTransparency = 0.55
            hl.OutlineColor = Color3.fromRGB(255, 255, 255)
            hl.OutlineTransparency = 0
            hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            hl.Adornee = char
            hl.Parent = char
            d.highlight = hl
        end
    end)
end

local function removeESP(player)
    local d = cache[player]
    if d then
        for _, obj in pairs(d) do
            if typeof(obj) == "Drawing" then
                pcall(function() obj:Remove() end)
            elseif typeof(obj) == "Instance" then
                pcall(function() obj:Destroy() end)
            end
        end
        cache[player] = nil
    end
end

Players.PlayerAdded:Connect(createESP)
Players.PlayerRemoving:Connect(removeESP)
for _, p in ipairs(Players:GetPlayers()) do createESP(p) end

-- ==== FLY ====
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
        local cam = Camera.CFrame
        if UIS:IsKeyDown(Enum.KeyCode.W) then MoveDirection += cam.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then MoveDirection -= cam.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then MoveDirection -= cam.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then MoveDirection += cam.RightVector end
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

-- ==== NOCLIP ====
local noclipConn = nil
local function startNoclip()
    if noclipConn then return end
    noclipConn = RunService.Stepped:Connect(function()
        if not Config.Noclip then return end
        local char = LP.Character
        if not char then return end
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then part.CanCollide = false end
        end
    end)
end

local function stopNoclip()
    if noclipConn then noclipConn:Disconnect() noclipConn = nil end
    local char = LP.Character
    if char then
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = true end
        end
    end
end

function toggleNoclip()
    if Config.Noclip then startNoclip() else stopNoclip() end
end

-- ==== SPEED ====
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

-- ==== INFINITE JUMP ====
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

-- ==== BUNNY HOP ====
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

-- ==== ANTI-AFK ====
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

-- ==== FULLBRIGHT ====
local origLighting = {
    Brightness = Lighting.Brightness, ClockTime = Lighting.ClockTime,
    Ambient = Lighting.Ambient, OutdoorAmbient = Lighting.OutdoorAmbient,
    FogEnd = Lighting.FogEnd, GlobalShadows = Lighting.GlobalShadows,
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

-- ==== AUTO-RELOAD ====
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
            if ammo and ammo <= 0 then pcall(function() tool:Activate() end) end
        end)
    end
end

-- ==== KILL AURA ====
local killAuraConn = nil
local lastAuraHit = 0

local function getAuraTargets()
    local targets = {}
    local char = LP.Character
    local myRoot = char and char:FindFirstChild("HumanoidRootPart")
    if not myRoot then return targets end
    local myPos = myRoot.Position

    local function checkFolder(folder)
        if not folder then return end
        for _, model in ipairs(folder:GetChildren()) do
            if model:IsA("Model") and model ~= LP.Character then
                local pRoot = model:FindFirstChild("HumanoidRootPart")
                local pHum = model:FindFirstChildOfClass("Humanoid")
                if pRoot and pHum and pHum.Health > 0 then
                    local dist = (pRoot.Position - myPos).Magnitude
                    if dist <= Config.KillAuraRange then
                        table.insert(targets, {
                            char = model,
                            root = pRoot,
                            dist = dist,
                        })
                    end
                end
            end
        end
    end

    checkFolder(workspace:FindFirstChild("Players"))

    return targets
end

local function startKillAura()
    if killAuraConn then return end
    killAuraConn = RunService.Heartbeat:Connect(function()
        if not Config.KillAura then return end
        if tick() - lastAuraHit < Config.KillAuraDelay then return end

        local targets = getAuraTargets()
        if #targets == 0 then return end

        table.sort(targets, function(a, b) return a.dist < b.dist end)
        local target = targets[1]

        if Config.KillAuraRotate then
            local camPos = Camera.CFrame.Position
            Camera.CFrame = CFrame.new(camPos, target.root.Position)
        end

        local char = LP.Character
        local tool = char and char:FindFirstChildOfClass("Tool")
        if tool then
            pcall(function() tool:Activate() end)
        end

        lastAuraHit = tick()
    end)
end

local function stopKillAura()
    if killAuraConn then
        killAuraConn:Disconnect()
        killAuraConn = nil
    end
end

function toggleKillAura()
    if Config.KillAura then
        startKillAura()
        showNotify("Kill Aura: ON", THEME.red)
    else
        stopKillAura()
        showNotify("Kill Aura: OFF", THEME.danger)
    end
end

local function applyToggle(key, value)
    Config[key] = value
    if key == "Fly" then toggleFly() end
    if key == "Noclip" then toggleNoclip() end
    if key == "SpeedHack" then toggleSpeedHack() end
    if key == "InfiniteJump" then toggleInfiniteJump() end
    if key == "BunnyHop" then toggleBunnyHop() end
    if key == "AntiAFK" then toggleAntiAFK() end
    if key == "Fullbright" then toggleFullbright() end
    if key == "AutoReload" then toggleAutoReload() end
    if key == "KillAura" then toggleKillAura() end
    if key == "NPCHighlight" then setNPCHighlightEnabled(Config.NPCHighlight) end
    if key == "NPCList" then npcListFrame.Visible = Config.NPCList end
    if key == "DashHighlight" and not value then
        for p, hl in pairs(dashHighlights) do hl:Destroy() end
        dashHighlights = {}
    end
end

-- ==== КОМПОНЕНТЫ МЕНЮ ====
local toggles = {}
local bindingMode = nil

local function makeToggle(page, label, key)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 30)
    row.BackgroundColor3 = THEME.bg3
    row.BorderSizePixel = 0
    row.ZIndex = 1002
    row.Parent = page
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 6)

    local indicator = Instance.new("Frame")
    indicator.Size = UDim2.fromOffset(4, 18)
    indicator.Position = UDim2.new(0, 6, 0.5, -9)
    indicator.BackgroundColor3 = Config[key] and THEME.accent or THEME.textDim
    indicator.BorderSizePixel = 0
    indicator.ZIndex = 1003
    indicator.Parent = row
    Instance.new("UICorner", indicator).CornerRadius = UDim.new(1, 0)

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -80, 1, 0)
    btn.Position = UDim2.fromOffset(16, 0)
    btn.BackgroundTransparency = 1
    btn.BorderSizePixel = 0
    btn.Text = "  " .. label
    btn.TextColor3 = Config[key] and THEME.text or THEME.textDim
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 13
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.ZIndex = 1003
    btn.Active = true
    btn.Parent = row

    local bindBtn = Instance.new("TextButton")
    bindBtn.Size = UDim2.fromOffset(60, 22)
    bindBtn.Position = UDim2.new(1, -66, 0.5, -11)
    bindBtn.BackgroundColor3 = THEME.bg2
    bindBtn.BorderSizePixel = 0
    bindBtn.Text = Binds[key] and Binds[key].Name or "NONE"
    bindBtn.TextColor3 = THEME.accent
    bindBtn.Font = Enum.Font.Code
    bindBtn.TextSize = 11
    bindBtn.ZIndex = 1004
    bindBtn.Active = true
    bindBtn.Parent = row
    Instance.new("UICorner", bindBtn).CornerRadius = UDim.new(0, 4)
    local bs = Instance.new("UIStroke", bindBtn)
    bs.Color = THEME.accent
    bs.Thickness = 1
    bs.Transparency = 0.5

    btn.MouseButton1Click:Connect(function()
        applyToggle(key, not Config[key])
        btn.TextColor3 = Config[key] and THEME.text or THEME.textDim
        indicator.BackgroundColor3 = Config[key] and THEME.accent or THEME.textDim
    end)

    bindBtn.MouseButton1Click:Connect(function()
        bindingMode = key
        bindBtn.Text = "..."
        bindBtn.BackgroundColor3 = THEME.accent
        bindBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        showNotify("Нажми клавишу: " .. label, THEME.accent)
    end)

    toggles[key] = {btn = btn, label = label, bindBtn = bindBtn, indicator = indicator}
end

local function makeSlider(page, label, min, max, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 46)
    frame.BackgroundColor3 = THEME.bg3
    frame.BorderSizePixel = 0
    frame.ZIndex = 1002
    frame.Parent = page
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)

    local titleLbl = Instance.new("TextLabel")
    titleLbl.Size = UDim2.new(1, -20, 0, 18)
    titleLbl.Position = UDim2.fromOffset(10, 4)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = label .. ": " .. default
    titleLbl.TextColor3 = THEME.text
    titleLbl.Font = Enum.Font.Gotham
    titleLbl.TextSize = 13
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.ZIndex = 1003
    titleLbl.Parent = frame

    local sliderBg = Instance.new("Frame")
    sliderBg.Size = UDim2.new(1, -20, 0, 6)
    sliderBg.Position = UDim2.new(0, 10, 1, -16)
    sliderBg.BackgroundColor3 = THEME.bg
    sliderBg.BorderSizePixel = 0
    sliderBg.ZIndex = 1003
    sliderBg.Parent = frame
    Instance.new("UICorner", sliderBg).CornerRadius = UDim.new(1, 0)

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = THEME.accent
    fill.BorderSizePixel = 0
    fill.ZIndex = 1004
    fill.Parent = sliderBg
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

    local thumb = Instance.new("Frame")
    thumb.Size = UDim2.fromOffset(14, 14)
    thumb.AnchorPoint = Vector2.new(0.5, 0.5)
    thumb.Position = UDim2.new((default - min) / (max - min), 0, 0.5, 0)
    thumb.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    thumb.BorderSizePixel = 0
    thumb.ZIndex = 1005
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

-- ==== ЗАПОЛНЕНИЕ МЕНЮ ====
makeToggle(pages.Visual, "ESP Master (E)", "ESP")
makeToggle(pages.Visual, "Box", "Box")
makeToggle(pages.Visual, "Name + Dist", "Name")
makeToggle(pages.Visual, "HP Bar", "HP")
makeToggle(pages.Visual, "Tool", "Tool")
makeToggle(pages.Visual, "Chams", "Chams")
makeToggle(pages.Visual, "Tracers", "Tracers")
makeToggle(pages.Visual, "Team Check", "TeamCheck")
makeToggle(pages.Visual, "Distance Colors", "DistanceColors")
makeSlider(pages.Visual, "Dist Threshold", 5, 200, Config.DistanceThreshold, function(v)
    Config.DistanceThreshold = v
end)
makeToggle(pages.Visual, "NPC Highlight", "NPCHighlight")
makeToggle(pages.Visual, "NPC List", "NPCList")
makeToggle(pages.Visual, "Dash Highlight", "DashHighlight")

-- Chams Mode
local chamsModes = {"Both", "Fill", "Outline", "Neon", "HP"}
local chamsModeBtn = Instance.new("TextButton")
chamsModeBtn.Size = UDim2.new(1, 0, 0, 30)
chamsModeBtn.BackgroundColor3 = THEME.bg3
chamsModeBtn.BorderSizePixel = 0
chamsModeBtn.Text = "  Chams Mode: " .. Config.ChamsMode
chamsModeBtn.TextColor3 = THEME.accent
chamsModeBtn.Font = Enum.Font.Gotham
chamsModeBtn.TextSize = 13
chamsModeBtn.TextXAlignment = Enum.TextXAlignment.Left
chamsModeBtn.ZIndex = 1003
chamsModeBtn.Parent = pages.Visual
Instance.new("UICorner", chamsModeBtn).CornerRadius = UDim.new(0, 6)

chamsModeBtn.MouseButton1Click:Connect(function()
    local currentIndex = 1
    for i, m in ipairs(chamsModes) do
        if m == Config.ChamsMode then currentIndex = i break end
    end
    currentIndex = currentIndex + 1
    if currentIndex > #chamsModes then currentIndex = 1 end
    Config.ChamsMode = chamsModes[currentIndex]
    chamsModeBtn.Text = "  Chams Mode: " .. Config.ChamsMode
    showNotify("Chams: " .. Config.ChamsMode, THEME.accent)
end)

-- Combat
makeToggle(pages.Combat, "Aimbot", "Aimbot")
makeToggle(pages.Combat, "Prediction", "AimPrediction")
makeToggle(pages.Combat, "Ignore FOV", "AimIgnoreFOV")
makeToggle(pages.Combat, "Auto Fire", "AutoFire")
makeToggle(pages.Combat, "Only with Aimbot", "AutoFireOnlyWithAimbot")
makeToggle(pages.Combat, "Require Target", "AutoFireRequireTarget")
makeToggle(pages.Combat, "Dash Aimbot", "DashAimbot")
makeToggle(pages.Combat, "Dash Ignore FOV", "DashIgnoreFOV")
makeToggle(pages.Combat, "Show FOV", "ShowFOV")
makeToggle(pages.Combat, "Visible Only", "VisibleOnly")
makeToggle(pages.Combat, "Kill Aura", "KillAura")
makeSlider(pages.Combat, "FOV", 20, 500, Config.FOV, function(v) Config.FOV = v end)
makeSlider(pages.Combat, "Aim Strength", 0.1, 1.0, Config.AimStrength, function(v) Config.AimStrength = v end)
makeSlider(pages.Combat, "Dash Sensitivity", 10, 200, Config.DashThreshold, function(v) Config.DashThreshold = v end)
makeSlider(pages.Combat, "Dash Lock (sec x10)", 1, 30, Config.DashLockTime * 10, function(v) Config.DashLockTime = v / 10 end)
makeSlider(pages.Combat, "Kill Aura Range", 5, 50, Config.KillAuraRange, function(v) Config.KillAuraRange = v end)
makeSlider(pages.Combat, "Auto Fire Delay x100", 1, 100, Config.AutoFireDelay * 100, function(v) Config.AutoFireDelay = v / 100 end)
makeSlider(pages.Combat, "Burst Count", 1, 10, Config.AutoFireBurstCount, function(v) Config.AutoFireBurstCount = v end)
makeSlider(pages.Combat, "Prediction x100", 1, 50, Config.AimPredictionAmount * 100, function(v)
    Config.AimPredictionAmount = v / 100
end)

-- Aim Mode
local aimModes = {"Smooth", "Instant", "Snap"}
local aimModeBtn = Instance.new("TextButton")
aimModeBtn.Size = UDim2.new(1, 0, 0, 30)
aimModeBtn.BackgroundColor3 = THEME.bg3
aimModeBtn.BorderSizePixel = 0
aimModeBtn.Text = "  Aim Mode: " .. Config.AimMode
aimModeBtn.TextColor3 = THEME.accent
aimModeBtn.Font = Enum.Font.Gotham
aimModeBtn.TextSize = 13
aimModeBtn.TextXAlignment = Enum.TextXAlignment.Left
aimModeBtn.ZIndex = 1003
aimModeBtn.Parent = pages.Combat
Instance.new("UICorner", aimModeBtn).CornerRadius = UDim.new(0, 6)

aimModeBtn.MouseButton1Click:Connect(function()
    local idx = 1
    for i, m in ipairs(aimModes) do
        if m == Config.AimMode then idx = i break end
    end
    idx = idx + 1
    if idx > #aimModes then idx = 1 end
    Config.AimMode = aimModes[idx]
    aimModeBtn.Text = "  Aim Mode: " .. Config.AimMode
    showNotify("Aim: " .. Config.AimMode, THEME.accent)
end)

-- Aim Bone
local aimBones = {"Head", "Nearest", "Chest"}
local aimBoneBtn = Instance.new("TextButton")
aimBoneBtn.Size = UDim2.new(1, 0, 0, 30)
aimBoneBtn.BackgroundColor3 = THEME.bg3
aimBoneBtn.BorderSizePixel = 0
aimBoneBtn.Text = "  Aim Bone: " .. Config.AimBone
aimBoneBtn.TextColor3 = THEME.accent
aimBoneBtn.Font = Enum.Font.Gotham
aimBoneBtn.TextSize = 13
aimBoneBtn.TextXAlignment = Enum.TextXAlignment.Left
aimBoneBtn.ZIndex = 1003
aimBoneBtn.Parent = pages.Combat
Instance.new("UICorner", aimBoneBtn).CornerRadius = UDim.new(0, 6)

aimBoneBtn.MouseButton1Click:Connect(function()
    local idx = 1
    for i, m in ipairs(aimBones) do
        if m == Config.AimBone then idx = i break end
    end
    idx = idx + 1
    if idx > #aimBones then idx = 1 end
    Config.AimBone = aimBones[idx]
    aimBoneBtn.Text = "  Aim Bone: " .. Config.AimBone
    showNotify("Bone: " .. Config.AimBone, THEME.accent)
end)

-- Aim Priority
local aimPriorities = {"FOV", "Distance", "HP"}
local aimPriorityBtn = Instance.new("TextButton")
aimPriorityBtn.Size = UDim2.new(1, 0, 0, 30)
aimPriorityBtn.BackgroundColor3 = THEME.bg3
aimPriorityBtn.BorderSizePixel = 0
aimPriorityBtn.Text = "  Target Priority: " .. Config.AimPriority
aimPriorityBtn.TextColor3 = THEME.accent
aimPriorityBtn.Font = Enum.Font.Gotham
aimPriorityBtn.TextSize = 13
aimPriorityBtn.TextXAlignment = Enum.TextXAlignment.Left
aimPriorityBtn.ZIndex = 1003
aimPriorityBtn.Parent = pages.Combat
Instance.new("UICorner", aimPriorityBtn).CornerRadius = UDim.new(0, 6)

aimPriorityBtn.MouseButton1Click:Connect(function()
    local idx = 1
    for i, m in ipairs(aimPriorities) do
        if m == Config.AimPriority then idx = i break end
    end
    idx = idx + 1
    if idx > #aimPriorities then idx = 1 end
    Config.AimPriority = aimPriorities[idx]
    aimPriorityBtn.Text = "  Target Priority: " .. Config.AimPriority
    showNotify("Priority: " .. Config.AimPriority, THEME.accent)
end)

-- Auto-Fire Mode
local afModes = {"Single", "Burst", "Auto"}
local afModeBtn = Instance.new("TextButton")
afModeBtn.Size = UDim2.new(1, 0, 0, 30)
afModeBtn.BackgroundColor3 = THEME.bg3
afModeBtn.BorderSizePixel = 0
afModeBtn.Text = "  Auto-Fire Mode: " .. Config.AutoFireMode
afModeBtn.TextColor3 = THEME.accent
afModeBtn.Font = Enum.Font.Gotham
afModeBtn.TextSize = 13
afModeBtn.TextXAlignment = Enum.TextXAlignment.Left
afModeBtn.ZIndex = 1003
afModeBtn.Parent = pages.Combat
Instance.new("UICorner", afModeBtn).CornerRadius = UDim.new(0, 6)

afModeBtn.MouseButton1Click:Connect(function()
    local idx = 1
    for i, m in ipairs(afModes) do
        if m == Config.AutoFireMode then idx = i break end
    end
    idx = idx + 1
    if idx > #afModes then idx = 1 end
    Config.AutoFireMode = afModes[idx]
    afModeBtn.Text = "  Auto-Fire Mode: " .. Config.AutoFireMode
    showNotify("Auto-Fire: " .. Config.AutoFireMode, THEME.accent)
end)

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

selectTab("Visual")

-- ==== AUTO-FIRE SYSTEM ====
local lastShot = 0
local burstShotsLeft = 0
local burstStart = 0
local burstDelay = 0.05

local function getClosestVisibleTarget(maxRange)
    local closest = nil
    local shortest = math.huge
    local camPos = Camera.CFrame.Position
    local centerX = Camera.ViewportSize.X / 2
    local centerY = Camera.ViewportSize.Y / 2

    -- Собираем все цели: workspace.Players + Players
    local targets = {}
    local plrFolder = workspace:FindFirstChild("Players")
    if plrFolder then
        for _, model in ipairs(plrFolder:GetChildren()) do
            if model:IsA("Model") and model ~= LP.Character then
                table.insert(targets, model)
            end
        end
    end
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP and plr.Character then
            table.insert(targets, plr.Character)
        end
    end

    for _, char in ipairs(targets) do
        local head = char:FindFirstChild("Head")
        local root = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")

        if head and root and hum and hum.Health > 0 then
            local dist = (camPos - root.Position).Magnitude
            if dist <= maxRange then
                local sp, on = Camera:WorldToViewportPoint(head.Position)
                if on and sp.Z > 0 then
                    local dx = sp.X - centerX
                    local dy = sp.Y - centerY
                    local screenDist = math.sqrt(dx * dx + dy * dy)

                    if screenDist < Config.FOV then
                        if Config.VisibleOnly then
                            if isVisible(camPos, head.Position, char) then
                                if dist < shortest then
                                    shortest = dist
                                    closest = head
                                end
                            end
                        else
                            if dist < shortest then
                                shortest = dist
                                closest = head
                            end
                        end
                    end
                end
            end
        end
    end
    return closest
end

local function fireOnce()
    local char = LP.Character
    if not char then return end
    local tool = char:FindFirstChildOfClass("Tool")
    if tool then
        pcall(function() tool:Activate() end)
    end
end

local function processAutoFire()
    if not Config.AutoFire then
        burstShotsLeft = 0
        return
    end

    if Config.AutoFireOnlyWithAimbot and not Config.Aimbot then return end

    local target = nil
    if Config.AutoFireRequireTarget then
        target = getClosestVisibleTarget(Config.AutoFireRange)
        if not target then return end
    end

    local now = tick()

    if Config.AutoFireMode == "Burst" then
        if burstShotsLeft > 0 then
            if now - burstStart >= burstDelay then
                fireOnce()
                burstShotsLeft = burstShotsLeft - 1
                burstStart = now
            end
        else
            if now - lastShot >= Config.AutoFireDelay then
                lastShot = now
                burstShotsLeft = Config.AutoFireBurstCount
                burstStart = now
                fireOnce()
                burstShotsLeft = burstShotsLeft - 1
            end
        end
        return
    end

    if Config.AutoFireMode == "Single" then return end

    if now - lastShot >= Config.AutoFireDelay then
        lastShot = now
        fireOnce()
    end
end

-- ==== INPUT ====
UIS.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.UserInputType ~= Enum.UserInputType.Keyboard then return end

    -- TOGGLE ESP (клавиша E)
    if input.KeyCode == ESP_TOGGLE_KEY then
        Config.ESPEnabled = not Config.ESPEnabled
        if Config.ESPEnabled then
            showNotify("ESP: ON", THEME.green)
        else
            showNotify("ESP: OFF", THEME.danger)
            -- Скрываем всё
            for _, d in pairs(cache) do
                d.box.Visible = false
                d.nameLbl.Visible = false
                d.toolLbl.Visible = false
                d.hpBg.Visible = false
                d.hpFill.Visible = false
                d.tracer.Visible = false
                if d.highlight then d.highlight.Enabled = false end
            end
        end
        return
    end

    -- Single Auto-Fire
    if Config.AutoFire and Config.AutoFireMode == "Single" then
        if input.KeyCode == Enum.KeyCode.X then
            local target = getClosestVisibleTarget(Config.AutoFireRange)
            if target or not Config.AutoFireRequireTarget then
                fireOnce()
            end
            return
        end
    end

    if bindingMode then
        local key = bindingMode
        bindingMode = nil
        if input.KeyCode == Enum.KeyCode.Escape then
            if toggles[key] then
                toggles[key].bindBtn.Text = Binds[key] and Binds[key].Name or "NONE"
                toggles[key].bindBtn.BackgroundColor3 = THEME.bg2
                toggles[key].bindBtn.TextColor3 = THEME.accent
            end
            showNotify("Бинд отменён", THEME.danger)
            return
        end
        Binds[key] = input.KeyCode
        if toggles[key] then
            toggles[key].bindBtn.Text = input.KeyCode.Name
            toggles[key].bindBtn.BackgroundColor3 = THEME.bg2
            toggles[key].bindBtn.TextColor3 = THEME.accent
        end
        showNotify("Бинд: " .. key .. " -> " .. input.KeyCode.Name, THEME.accent)
        return
    end

    if input.KeyCode == Binds.Menu or input.KeyCode == Enum.KeyCode.RightShift or input.KeyCode == Enum.KeyCode.M then
        main.Visible = not main.Visible
        return
    end

    for key, bind in pairs(Binds) do
        if key ~= "Menu" and key ~= "ESP" and input.KeyCode == bind and Config[key] ~= nil then
            applyToggle(key, not Config[key])
            if toggles[key] then
                local t = toggles[key]
                t.btn.TextColor3 = Config[key] and THEME.text or THEME.textDim
                t.indicator.BackgroundColor3 = Config[key] and THEME.accent or THEME.textDim
            end
            showNotify(key .. ": " .. (Config[key] and "ON" or "OFF"),
                Config[key] and THEME.accent or THEME.danger)
            return
        end
    end
end)

LP.CharacterAdded:Connect(function()
    task.wait(0.5)
    if Config.Fly then flying = false toggleFly() end
    if Config.Noclip then toggleNoclip() end
    if Config.SpeedHack then toggleSpeedHack() end
    if Config.InfiniteJump then toggleInfiniteJump() end
    if Config.BunnyHop then toggleBunnyHop() end
    if Config.AutoReload then toggleAutoReload() end
    if Config.KillAura then stopKillAura() startKillAura() end
end)

-- ==== MAIN LOOP ====
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

    if Config.DashAimbot then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LP then
                checkDash(player)
                updateDashHighlight(player)
            end
        end
    end

    if Config.ShowFOV and Config.Aimbot then
        fovCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
        fovCircle.Radius = Config.FOV
        fovCircle.Visible = true
    else
        fovCircle.Visible = false
    end

    if Config.ESPEnabled or Config.Aimbot then
        local vpSize = Camera.ViewportSize
        local centerX, centerY = vpSize.X * 0.5, vpSize.Y * 0.5
        local closestTarget, shortest = nil, Config.FOV
        local dashTarget = nil
        local camPos = Camera.CFrame.Position

        for player, esp in pairs(cache) do
            local char = player.Character
            local head = char and char:FindFirstChild("Head")
            local root = char and char:FindFirstChild("HumanoidRootPart")
            local hum = char and char:FindFirstChildOfClass("Humanoid")

            -- Если ESP выключен или нет цели — скрываем
            if not (head and root and hum and hum.Health > 0) or not Config.ESPEnabled then
                esp.box.Visible = false
                esp.nameLbl.Visible = false
                esp.toolLbl.Visible = false
                esp.hpBg.Visible = false
                esp.hpFill.Visible = false
                esp.tracer.Visible = false
                if esp.highlight then esp.highlight.Enabled = false end
                continue
            end

            local distToPlayer = (camPos - root.Position).Magnitude

            -- CHAMS
            if Config.Chams then
                if not esp.highlight or esp.highlight.Parent ~= char then
                    if esp.highlight then esp.highlight:Destroy() end
                    local hl = Instance.new("Highlight")
                    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    hl.Adornee = char
                    hl.Parent = char
                    esp.highlight = hl
                end
                esp.highlight.Enabled = true

                local baseColor = getESPColor(player, distToPlayer)
                local isDashing = DASH_LOCK[player] and DASH_LOCK[player] > tick()

                if isDashing then
                    local pulse = 0.5 + 0.5 * math.sin(tick() * 15)
                    esp.highlight.FillColor = Color3.fromRGB(255, 255, 0)
                    esp.highlight.FillTransparency = 0.3 + pulse * 0.3
                    esp.highlight.OutlineColor = Color3.fromRGB(255, 255, 0)
                    esp.highlight.OutlineTransparency = 0
                elseif Config.ChamsMode == "HP" then
                    local hpRatio = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
                    if hpRatio > 0.7 then
                        esp.highlight.FillColor = Color3.fromRGB(0, 255, 100)
                        esp.highlight.FillTransparency = 0.6
                        esp.highlight.OutlineColor = Color3.fromRGB(0, 255, 100)
                        esp.highlight.OutlineTransparency = 0.2
                    elseif hpRatio > 0.35 then
                        esp.highlight.FillColor = Color3.fromRGB(255, 220, 0)
                        esp.highlight.FillTransparency = 0.5
                        esp.highlight.OutlineColor = Color3.fromRGB(255, 220, 0)
                        esp.highlight.OutlineTransparency = 0.1
                    else
                        local pulse = 0.5 + 0.5 * math.sin(tick() * 10)
                        esp.highlight.FillColor = Color3.fromRGB(255, 0, 0)
                        esp.highlight.FillTransparency = 0.2 + pulse * 0.2
                        esp.highlight.OutlineColor = Color3.fromRGB(255, 50, 50)
                        esp.highlight.OutlineTransparency = 0
                    end
                elseif Config.ChamsMode == "Fill" then
                    esp.highlight.FillColor = baseColor
                    esp.highlight.FillTransparency = 0.45
                    esp.highlight.OutlineTransparency = 1
                elseif Config.ChamsMode == "Outline" then
                    esp.highlight.FillTransparency = 1
                    esp.highlight.OutlineColor = baseColor
                    esp.highlight.OutlineTransparency = 0
                elseif Config.ChamsMode == "Neon" then
                    esp.highlight.FillColor = Color3.fromRGB(0, 0, 0)
                    esp.highlight.FillTransparency = 0.7
                    esp.highlight.OutlineColor = baseColor
                    esp.highlight.OutlineTransparency = 0
                else
                    esp.highlight.FillColor = baseColor
                    esp.highlight.FillTransparency = 0.55
                    esp.highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                    esp.highlight.OutlineTransparency = 0
                end
            elseif esp.highlight then
                esp.highlight:Destroy()
                esp.highlight = nil
            end

            local topPos, topOn = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.9, 0))
            local botPos, botOn = Camera:WorldToViewportPoint(root.Position - Vector3.new(0, 3.1, 0))
            local onScreen = topOn and botOn and topPos.Z > 0 and botPos.Z > 0

            if onScreen and Config.ESPEnabled then
                local height = math.abs(botPos.Y - topPos.Y)
                local width = math.max(height * 0.55, 15)
                local x = topPos.X - width / 2
                local y = topPos.Y

                local ratio = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
                local boxColor = getESPColor(player, distToPlayer)

                if DASH_LOCK[player] and DASH_LOCK[player] > tick() then
                    boxColor = Color3.fromRGB(255, 255, 0)
                end

                esp.box.Visible = Config.Box
                esp.box.Color = boxColor
                esp.box.Position = Vector2.new(x, y)
                esp.box.Size = Vector2.new(width, height)

                esp.nameLbl.Visible = Config.Name
                if Config.Name then
                    esp.nameLbl.Text = player.Name .. " [" .. math.floor(distToPlayer) .. "m]"
                    esp.nameLbl.Position = Vector2.new(topPos.X, y - 18)
                    esp.nameLbl.Color = boxColor
                end

                esp.toolLbl.Visible = Config.Tool
                if Config.Tool then
                    local held = char:FindFirstChildOfClass("Tool")
                    esp.toolLbl.Text = held and held.Name or ""
                    esp.toolLbl.Position = Vector2.new(topPos.X, y + height + 2)
                    esp.toolLbl.Color = Color3.fromRGB(255, 210, 80)
                end

                esp.hpBg.Visible = Config.HP
                esp.hpFill.Visible = Config.HP
                if Config.HP then
                    esp.hpBg.Position = Vector2.new(x - 6, y)
                    esp.hpBg.Size = Vector2.new(3, height)
                    esp.hpFill.Position = Vector2.new(x - 6, y + height * (1 - ratio))
                    esp.hpFill.Size = Vector2.new(3, height * ratio)
                    esp.hpFill.Color = ratio > 0.6 and Color3.fromRGB(0, 255, 0)
                        or ratio > 0.3 and Color3.fromRGB(255, 200, 0)
                        or Color3.fromRGB(255, 50, 50)
                end

                esp.tracer.Visible = Config.Tracers
                if Config.Tracers then
                    esp.tracer.Color = boxColor
                    esp.tracer.From = Vector2.new(vpSize.X / 2, vpSize.Y)
                    esp.tracer.To = Vector2.new(topPos.X, botPos.Y)
                end
            else
                esp.box.Visible = false
                esp.nameLbl.Visible = false
                esp.toolLbl.Visible = false
                esp.hpBg.Visible = false
                esp.hpFill.Visible = false
                esp.tracer.Visible = false
            end

            -- AIMBOT TARGETING
            if Config.Aimbot then
                local aimPart = head
                if Config.AimBone == "Chest" then
                    aimPart = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso") or head
                end

                local headScreen, headOn = Camera:WorldToViewportPoint(aimPart.Position)
                if headOn and headScreen.Z > 0 then
                    local dx = headScreen.X - centerX
                    local dy = headScreen.Y - centerY
                    local d = (dx*dx + dy*dy) ^ 0.5

                    local isDashing = DASH_LOCK[player] and DASH_LOCK[player] > tick()

                    local sameTeam = false
                    if Config.TeamCheck and LP.Team and player.Team == LP.Team then
                        sameTeam = true
                    end

                    local canAim = not sameTeam
                    if canAim and Config.VisibleOnly then
                        canAim = isVisible(camPos, aimPart.Position, char)
                    end

                    if canAim and isDashing and Config.DashAimbot then
                        dashTarget = aimPart
                    end

                    local inFOV = d < Config.FOV or Config.AimIgnoreFOV

                    if canAim and inFOV then
                        if d < shortest then
                            shortest = d
                            closestTarget = aimPart
                        end
                    end
                end
            end
        end

        local finalTarget = dashTarget or closestTarget

        if Config.ShowFOV and Config.Aimbot then
            if finalTarget then
                fovCircle.Color = THEME.danger
            else
                fovCircle.Color = THEME.accent
            end
        end

        if Config.Aimbot and finalTarget then
            local targetPos = finalTarget.Position

            if Config.AimPrediction then
                local velocity = finalTarget.AssemblyLinearVelocity
                if velocity.Magnitude > 1 then
                    targetPos = targetPos + velocity * Config.AimPredictionAmount
                end
            end

            local newCF = CFrame.new(Camera.CFrame.Position, targetPos)

            if Config.AimMode == "Instant" then
                Camera.CFrame = newCF
            elseif Config.AimMode == "Snap" then
                Camera.CFrame = newCF
                if tick() - lastShot >= 0.02 then
                    lastShot = tick()
                    local tool = LP.Character and LP.Character:FindFirstChildOfClass("Tool")
                    if tool then pcall(function() tool:Activate() end) end
                end
            else
                Camera.CFrame = Camera.CFrame:Lerp(newCF, Config.AimStrength)
            end
        end
    end

    -- AUTO FIRE
    processAutoFire()
end)

if Config.AntiAFK then toggleAntiAFK() end

showNotify(SCRIPT_NAME .. " загружен! M / Delete = меню, E = ESP", THEME.accent)
print("[NINJA] Загружено")
print("[NINJA] E = toggle ESP")
print("[NINJA] M / Delete = меню")
