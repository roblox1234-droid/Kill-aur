-- ============================================
-- FULL ESP + AIMBOT for CS-like Roblox
-- ============================================

local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local UIS = game:GetService("UserInputService")

-- ================= НАСТРОЙКИ =================
local Config = {
    -- ESP
    Box = true,
    Name = true,
    Health = true,
    Chams = true,
    Tracers = false,
    TeamCheck = true,
    MaxDistance = 3000,

    -- Aimbot
    Aimbot = false,
    AimKey = Enum.KeyCode.Q,
    FOV = 150,
    Smoothness = 0.25,
    VisibleOnly = true,

    -- Цвета
    TeamColor = Color3.fromRGB(0, 150, 255),
    EnemyColor = Color3.fromRGB(255, 50, 50),
    NeutralColor = Color3.fromRGB(255, 200, 50),
}
-- =============================================

-- Хранилища
local esp = {}
local highlights = {}

-- ========== ЦВЕТ ==========
local function getColor(player)
    if not Config.TeamCheck then
        return Config.EnemyColor
    end
    if player.Team and LP.Team and player.Team == LP.Team then
        return Config.TeamColor
    end
    return Config.EnemyColor
end

-- ========== ВИДИМОСТЬ ==========
local function isVisible(fromPos, toPos, ignoreChar)
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = {LP.Character, ignoreChar}
    local result = workspace:Raycast(fromPos, toPos - fromPos, params)
    return result == nil or result.Instance:IsDescendantOf(ignoreChar)
end

-- ========== HIGHLIGHT ==========
local function createHighlight(model, color)
    if not model then return nil end
    local old = model:FindFirstChild("ESP_Highlight")
    if old then old:Destroy() end
    local hl = Instance.new("Highlight")
    hl.Name = "ESP_Highlight"
    hl.FillColor = color
    hl.FillTransparency = 0.55
    hl.OutlineColor = Color3.fromRGB(255, 255, 255)
    hl.OutlineTransparency = 0
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    hl.Adornee = model
    hl.Parent = model
    return hl
end

-- ========== СОЗДАНИЕ ESP ==========
local function createESP(player)
    if player == LP then return end
    if esp[player] then return end

    local color = getColor(player)

    esp[player] = {
        box = Drawing.new("Square"),
        name = Drawing.new("Text"),
        healthBg = Drawing.new("Square"),
        healthFill = Drawing.new("Square"),
        tracer = Drawing.new("Line"),
        color = color,
    }

    local d = esp[player]

    d.box.Thickness = 1
    d.box.Filled = false
    d.box.Transparency = 1
    d.box.Visible = false

    d.name.Size = 14
    d.name.Center = true
    d.name.Outline = true
    d.name.OutlineColor = Color3.fromRGB(0, 0, 0)
    d.name.Visible = false

    d.healthBg.Size = Vector2.new(3, 20)
    d.healthBg.Color = Color3.fromRGB(20, 20, 25)
    d.healthBg.Filled = true
    d.healthBg.Transparency = 0.4
    d.healthBg.Visible = false

    d.healthFill.Size = Vector2.new(3, 20)
    d.healthFill.Color = Color3.fromRGB(0, 255, 0)
    d.healthFill.Filled = true
    d.healthFill.Transparency = 1
    d.healthFill.Visible = false

    d.tracer.Thickness = 1
    d.tracer.Transparency = 0.5
    d.tracer.Visible = false

    if player.Character and Config.Chams then
        highlights[player] = createHighlight(player.Character, color)
    end

    player.CharacterAdded:Connect(function(char)
        task.wait(0.5)
        if highlights[player] then
            highlights[player]:Destroy()
            highlights[player] = nil
        end
        if Config.Chams then
            highlights[player] = createHighlight(char, color)
        end
    end)
end

local function removeESP(player)
    local d = esp[player]
    if d then
        for _, obj in pairs(d) do
            if typeof(obj) == "Drawing" then
                pcall(function() obj:Remove() end)
            end
        end
        esp[player] = nil
    end
    if highlights[player] then
        highlights[player]:Destroy()
        highlights[player] = nil
    end
end

for _, p in ipairs(Players:GetPlayers()) do
    createESP(p)
end

Players.PlayerAdded:Connect(createESP)
Players.PlayerRemoving:Connect(removeESP)

-- ========== AIMBOT ==========
local aiming = false

local fovCircle = Drawing.new("Circle")
fovCircle.Thickness = 1
fovCircle.Color = Color3.fromRGB(255, 255, 255)
fovCircle.Transparency = 0.3
fovCircle.Visible = false

local function getClosestTarget()
    local closest = nil
    local shortest = Config.FOV
    local camPos = Camera.CFrame.Position

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LP and player.Character then
            local char = player.Character
            local head = char:FindFirstChild("Head")
            local hum = char:FindFirstChildOfClass("Humanoid")

            if head and hum and hum.Health > 0 then
                local isEnemy = true
                if Config.TeamCheck and LP.Team and player.Team == LP.Team then
                    isEnemy = false
                end

                if isEnemy then
                    local screenPos, onScreen = Camera:WorldToViewportPoint(head.Position)
                    if onScreen and screenPos.Z > 0 then
                        local dx = screenPos.X - Camera.ViewportSize.X / 2
                        local dy = screenPos.Y - Camera.ViewportSize.Y / 2
                        local dist = math.sqrt(dx * dx + dy * dy)

                        if dist < shortest then
                            if not Config.VisibleOnly or isVisible(camPos, head.Position, char) then
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

local function aimAt(target)
    if not target then return end
    local camPos = Camera.CFrame.Position
    local newCFrame = CFrame.new(camPos, target.Position)
    Camera.CFrame = Camera.CFrame:Lerp(newCFrame, Config.Smoothness)
end

-- ========== ВВОД ==========
UIS.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.UserInputType == Enum.UserInputType.Keyboard then
        if input.KeyCode == Config.AimKey then
            aiming = true
        end
    end
end)

UIS.InputEnded:Connect(function(input, gp)
    if gp then return end
    if input.UserInputType == Enum.UserInputType.Keyboard then
        if input.KeyCode == Config.AimKey then
            aiming = false
        end
    end
end)

-- ========== ГЛАВНЫЙ ЦИКЛ ==========
RunService.RenderStepped:Connect(function()
    local camPos = Camera.CFrame.Position
    local vpSize = Camera.ViewportSize

    -- FOV Circle
    if Config.Aimbot then
        fovCircle.Position = Vector2.new(vpSize.X / 2, vpSize.Y / 2)
        fovCircle.Radius = Config.FOV
        fovCircle.Visible = true
    else
        fovCircle.Visible = false
    end

    -- Aimbot
    if aiming and Config.Aimbot then
        local target = getClosestTarget()
        if target then
            aimAt(target)
        end
    end

    -- ESP
    for player, d in pairs(esp) do
        local char = player.Character
        local head = char and char:FindFirstChild("Head")
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")

        if head and hrp and hum and hum.Health > 0 then
            local dist = (camPos - hrp.Position).Magnitude

            if dist > Config.MaxDistance then
                d.box.Visible = false
                d.name.Visible = false
                d.healthBg.Visible = false
                d.healthFill.Visible = false
                d.tracer.Visible = false
            else
                local color = getColor(player)
                if color ~= d.color then
                    d.color = color
                    if highlights[player] then
                        highlights[player].FillColor = color
                    end
                end

                local topPos = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
                local botPos = Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3, 0))

                if topPos.Z > 0 and botPos.Z > 0 then
                    local height = math.abs(botPos.Y - topPos.Y)
                    if height < 5 then height = 40 end
                    local width = math.max(height * 0.55, 15)
                    local x = topPos.X - width / 2
                    local y = topPos.Y

                    -- Box
                    if Config.Box then
                        d.box.Visible = true
                        d.box.Color = color
                        d.box.Size = Vector2.new(width, height)
                        d.box.Position = Vector2.new(x, y)
                    else
                        d.box.Visible = false
                    end

                    -- Name
                    if Config.Name then
                        d.name.Visible = true
                        d.name.Text = string.format("%s [%dm]", player.Name, math.floor(dist))
                        d.name.Position = Vector2.new(topPos.X, y - 18)
                        d.name.Color = color
                    else
                        d.name.Visible = false
                    end

                    -- Health
                    if Config.Health then
                        local ratio = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
                        d.healthBg.Visible = true
                        d.healthBg.Size = Vector2.new(3, height)
                        d.healthBg.Position = Vector2.new(x - 6, y)

                        d.healthFill.Visible = true
                        d.healthFill.Size = Vector2.new(3, height * ratio)
                        d.healthFill.Position = Vector2.new(x - 6, y + height * (1 - ratio))

                        if ratio > 0.6 then
                            d.healthFill.Color = Color3.fromRGB(0, 255, 0)
                        elseif ratio > 0.3 then
                            d.healthFill.Color = Color3.fromRGB(255, 200, 0)
                        else
                            d.healthFill.Color = Color3.fromRGB(255, 50, 50)
                        end
                    else
                        d.healthBg.Visible = false
                        d.healthFill.Visible = false
                    end

                    -- Tracers
                    if Config.Tracers then
                        d.tracer.Visible = true
                        d.tracer.Color = color
                        d.tracer.From = Vector2.new(vpSize.X / 2, vpSize.Y)
                        d.tracer.To = Vector2.new(topPos.X, botPos.Y)
                    else
                        d.tracer.Visible = false
                    end
                else
                    d.box.Visible = false
                    d.name.Visible = false
                    d.healthBg.Visible = false
                    d.healthFill.Visible = false
                    d.tracer.Visible = false
                end
            end
        else
            d.box.Visible = false
            d.name.Visible = false
            d.healthBg.Visible = false
            d.healthFill.Visible = false
            d.tracer.Visible = false
        end
    end
end)

-- ========== ЗАПУСК ==========
print("[ESP] Loaded")
print("[ESP] Box:", Config.Box)
print("[ESP] Chams:", Config.Chams)
print("[ESP] Health:", Config.Health)
print("[Aimbot] Key: Q, FOV:", Config.FOV)
