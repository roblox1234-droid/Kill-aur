-- ============================================
-- NINJA STYLE CHEAT GUI + NPC HIGHLIGHT + BINDS + NPC LIST (REAL-TIME)
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

local THEME = {
    bg         = Color3.fromRGB(18, 18, 24),
    bg2        = Color3.fromRGB(22, 22, 30),
    bg3        = Color3.fromRGB(28, 28, 38),
    border     = Color3.fromRGB(45, 45, 60),
    accent     = Color3.fromRGB(168, 85, 247),
    accent2    = Color3.fromRGB(139, 92, 246),
    text       = Color3.fromRGB(220, 220, 230),
    textDim    = Color3.fromRGB(120, 120, 140),
    danger     = Color3.fromRGB(239, 68, 68),
    green      = Color3.fromRGB(0, 255, 140),
    yellow     = Color3.fromRGB(255, 200, 50),
    red        = Color3.fromRGB(255, 80, 80),
}
-- ==================

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
    NPCHighlight = true, NPCList = true,
}

local Binds = {
    Aimbot = Enum.KeyCode.Q,
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
    AntiAFK = Enum.KeyCode.K,
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
infoLabel.Parent = gui
Instance.new("UICorner", infoLabel).CornerRadius = UDim.new(0, 8)
local infoStroke = Instance.new("UIStroke", infoLabel)
infoStroke.Color = THEME.border
infoStroke.Thickness = 1

-- ==== NPC LIST (левый верхний угол) ====
local npcListFrame = Instance.new("Frame")
npcListFrame.Size = UDim2.fromOffset(250, 320)
npcListFrame.Position = UDim2.fromOffset(10, 10)
npcListFrame.BackgroundColor3 = THEME.bg
npcListFrame.BackgroundTransparency = 0.15
npcListFrame.BorderSizePixel = 0
npcListFrame.Visible = true
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
npcListTitle.Parent = npcListFrame

local npcListScroll = Instance.new("ScrollingFrame")
npcListScroll.Size = UDim2.new(1, -12, 1, -34)
npcListScroll.Position = UDim2.fromOffset(6, 30)
npcListScroll.BackgroundTransparency = 1
npcListScroll.BorderSizePixel = 0
npcListScroll.ScrollBarThickness = 3
npcListScroll.ScrollBarImageColor3 = THEME.accent
npcListScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
npcListScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
npcListScroll.Parent = npcListFrame

local npcListLayout = Instance.new("UIListLayout")
npcListLayout.Padding = UDim.new(0, 2)
npcListLayout.SortOrder = Enum.SortOrder.LayoutOrder
npcListLayout.Parent = npcListScroll
-- ==== КОНЕЦ NPC LIST UI ====

local fps, frames, lastTime = 0, 0, tick()

-- ==== ГЛАВНОЕ ОКНО ====
local main = Instance.new("Frame")
main.Size = UDim2.fromOffset(520, 380)
main.Position = UDim2.new(0.5, -260, 0.5, -190)
main.BackgroundColor3 = THEME.bg
main.BorderSizePixel = 0
main.Visible = false
main.Active = true
main.Draggable = true
main.Parent = gui
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10)
local mainStroke = Instance.new("UIStroke", main)
mainStroke.Color = THEME.border
mainStroke.Thickness = 1

local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = THEME.bg2
titleBar.BorderSizePixel = 0
titleBar.Parent = main
Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 10)
local titleFix = Instance.new("Frame")
titleFix.Size = UDim2.new(1, 0, 0, 10)
titleFix.Position = UDim2.new(0, 0, 1, -10)
titleFix.BackgroundColor3 = THEME.bg2
titleFix.BorderSizePixel = 0
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
close.Parent = titleBar
Instance.new("UICorner", close).CornerRadius = UDim.new(0, 6)
close.MouseButton1Click:Connect(function()
    main.Visible = false
end)

local sidebar = Instance.new("Frame")
sidebar.Size = UDim2.new(0, 120, 1, -50)
sidebar.Position = UDim2.fromOffset(8, 46)
sidebar.BackgroundColor3 = THEME.bg2
sidebar.BorderSizePixel = 0
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
content.Parent = main
Instance.new("UICorner", content).CornerRadius = UDim.new(0, 8)

local pages = {}
local tabButtons = {}

local function selectTab(name)
    for tabName, page in pairs(pages) do
        page.Visible = (tabName == name)
    end
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
    page.Parent = content

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 5)
    layout.Parent = page

    pages[name] = page
    tabButtons[name] = btn

    btn.MouseButton1Click:Connect(function()
        selectTab(name)
    end)
end

createTab("Visual", "Visual", "👁")
createTab("Aimbot", "Aimbot", "🎯")
createTab("Movement", "Move", "🏃")
createTab("Misc", "Misc", "⚙")

local notify = Instance.new("TextLabel")
notify.Size = UDim2.fromOffset(260, 40)
notify.Position = UDim2.new(0.5, -130, 0, 20)
notify.BackgroundColor3 = THEME.bg2
notify.BackgroundTransparency = 0.1
notify.BorderSizePixel = 0
notify.Text = ""
notify.TextColor3 = THEME.accent
notify.Font = Enum.Font.Gotham
notify.TextSize = 14
notify.Visible = false
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

local fovCircle = Instance.new("Frame")
fovCircle.AnchorPoint = Vector2.new(0.5, 0.5)
fovCircle.Position = UDim2.new(0.5, 0, 0.5, 0)
fovCircle.BackgroundTransparency = 1
fovCircle.BorderSizePixel = 0
fovCircle.Visible = false
fovCircle.Parent = gui

local fovStroke = Instance.new("UIStroke")
fovStroke.Color = THEME.accent
fovStroke.Thickness = 2
fovStroke.Transparency = 0.2
fovStroke.Parent = fovCircle
Instance.new("UICorner", fovCircle).CornerRadius = UDim.new(1, 0)

local rayParams = RaycastParams.new()
rayParams.FilterType = Enum.RaycastFilterType.Exclude

-- ==== NPC HIGHLIGHT ====
local npcHighlights = {}
local NPC_HIGHLIGHT_ENABLED = true
local NPC_FILL_COLOR = Color3.fromRGB(168, 85, 247)
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

-- ==== NPC LIST ОБНОВЛЕНИЕ (REAL-TIME) ====
local npcRows = {}

local function getNPCLevel(obj)
    local lvl = obj:GetAttribute("Level") or obj:GetAttribute("Lvl")
    if not lvl then
        local hum = obj:FindFirstChildOfClass("Humanoid")
        if hum then
            lvl = hum:GetAttribute("Level") or hum:GetAttribute("Lvl")
        end
    end
    if not lvl then
        local num = obj.Name:match("Lv%.?%s*(%d+)") or obj.Name:match("%[Lv%.%s*(%d+)%]")
        if num then lvl = tonumber(num) end
    end
    return lvl
end

local function getNPCCategory(model)
    local parent = model.Parent
    while parent do
        if parent.Name == "NPCs" then return "ENEMY" end
        if parent.Name == "Players" then return "PLAYER" end
        if parent.Name == "StaticNPCs" then return "STATIC" end
        parent = parent.Parent
    end
    return "OTHER"
end

local function getNPCPosition(obj)
    local root = obj:FindFirstChild("HumanoidRootPart")
        or obj:FindFirstChild("Torso")
        or obj:FindFirstChild("UpperTorso")
        or obj:FindFirstChild("LowerTorso")
        or obj.PrimaryPart
        or obj:FindFirstChildWhichIsA("BasePart")
    return root and root.Position or nil
end

RunService.RenderStepped:Connect(function()
    if not Config.NPCList then
        if npcListFrame.Visible then
            npcListFrame.Visible = false
        end
        return
    end
    if not npcListFrame.Visible then
        npcListFrame.Visible = true
    end

    local char = LP.Character
    local myRoot = char and char:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end
    local myPos = myRoot.Position

    local active = {}

    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Model") then
            local hum = obj:FindFirstChildOfClass("Humanoid")
            if hum then
                local category = getNPCCategory(obj)
                if category == "ENEMY" or category == "PLAYER" then
                    local pos = getNPCPosition(obj)
                    if pos then
                        local dist = (pos - myPos).Magnitude
                        if dist < 1000 then
                            active[obj] = {
                                dist = dist,
                                level = getNPCLevel(obj),
                                category = category,
                            }
                        end
                    end
                end
            end
        end
    end

    for model, row in pairs(npcRows) do
        if not active[model] then
            row.lbl:Destroy()
            npcRows[model] = nil
        end
    end

    for model, data in pairs(active) do
        if not npcRows[model] then
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1, 0, 0, 20)
            lbl.BackgroundTransparency = 1
            lbl.TextColor3 = THEME.text
            lbl.Font = Enum.Font.Gotham
            lbl.TextSize = 12
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.Parent = npcListScroll
            npcRows[model] = {lbl = lbl}
        end

        local lvl = data.level
        local lvlText = lvl and ("[Lv. " .. lvl .. "] ") or ""
        local prefix = data.category == "ENEMY" and "👹 " or "👤 "
        local displayName = model.Name:gsub("_Server", ""):gsub("_Client", "")

        npcRows[model].lbl.Text = string.format(
            "  %s%s%s  —  %dm",
            prefix, lvlText, displayName, math.floor(data.dist)
        )

        if data.category == "ENEMY" then
            npcRows[model].lbl.TextColor3 = THEME.red
        else
            npcRows[model].lbl.TextColor3 = THEME.green
        end

        npcRows[model].lbl.LayoutOrder = math.floor(data.dist)
    end
end)
-- ==== КОНЕЦ NPC LIST ====

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
    stroke.Color = THEME.accent
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
    hpFill.BackgroundColor3 = THEME.accent
    hpFill.BorderSizePixel = 0
    hpFill.Size = UDim2.new(1, 0, 1, 0)
    hpFill.AnchorPoint = Vector2.new(0, 1)
    hpFill.Position = UDim2.new(0, 0, 1, 0)
    hpFill.Parent = hpBg
    Instance.new("UICorner", hpFill).CornerRadius = UDim.new(1, 0)

    local tracer = Instance.new("Frame")
    tracer.BackgroundColor3 = THEME.accent
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
    if key == "NPCHighlight" then setNPCHighlightEnabled(Config.NPCHighlight) end
    if key == "NPCList" then npcListFrame.Visible = Config.NPCList end
end

-- ==== КОМПОНЕНТЫ ====
local toggles = {}
local bindingMode = nil

local function makeToggle(page, label, key)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 30)
    row.BackgroundColor3 = THEME.bg3
    row.BorderSizePixel = 0
    row.Parent = page
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 6)

    local indicator = Instance.new("Frame")
    indicator.Size = UDim2.fromOffset(4, 18)
    indicator.Position = UDim2.new(0, 6, 0.5, -9)
    indicator.BackgroundColor3 = Config[key] and THEME.accent or THEME.textDim
    indicator.BorderSizePixel = 0
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
    btn.ZIndex = 2
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
    bindBtn.ZIndex = 3
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
        showNotify("Нажми клавишу: " .. label .. " (Escape = отмена)", THEME.accent)
    end)

    toggles[key] = {btn = btn, label = label, bindBtn = bindBtn, indicator = indicator}
end

local function makeSlider(page, label, min, max, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 46)
    frame.BackgroundColor3 = THEME.bg3
    frame.BorderSizePixel = 0
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
    titleLbl.Parent = frame

    local sliderBg = Instance.new("Frame")
    sliderBg.Size = UDim2.new(1, -20, 0, 6)
    sliderBg.Position = UDim2.new(0, 10, 1, -16)
    sliderBg.BackgroundColor3 = THEME.bg
    sliderBg.BorderSizePixel = 0
    sliderBg.Parent = frame
    Instance.new("UICorner", sliderBg).CornerRadius = UDim.new(1, 0)

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = THEME.accent
    fill.BorderSizePixel = 0
    fill.Parent = sliderBg
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

    local thumb = Instance.new("Frame")
    thumb.Size = UDim2.fromOffset(14, 14)
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
makeToggle(pages.Visual, "NPC List", "NPCList")

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

selectTab("Visual")

UIS.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.UserInputType ~= Enum.UserInputType.Keyboard then return end

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

    if input.KeyCode == Binds.Menu then
        main.Visible = not main.Visible
        return
    end

    for key, bind in pairs(Binds) do
        if key ~= "Menu" and input.KeyCode == bind and Config[key] ~= nil then
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
                hl.FillColor = THEME.accent
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
            local boxColor = ratio > 0.6 and Color3.fromRGB(168, 85, 247)
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
        fovStroke.Color = closestTarget and THEME.danger or THEME.accent
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

showNotify(SCRIPT_NAME .. " загружен! " .. Binds.Menu.Name .. " = меню", THEME.accent)
