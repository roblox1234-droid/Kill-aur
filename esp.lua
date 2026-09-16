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

-- ===== ОСНОВНОЙ ЦИКЛ =====
local lastShot = 0

RunService.RenderStepped:Connect(function()
    -- FPS + Ping
    infoLabel.TextColor3 = getRainbowColor()
    frames += 1
    if tick() - lastTime >= 1 then
        fps = frames
        frames = 0
        lastTime = tick()
        local ping = 0
        pcall(function()
            ping = mathfloor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
        end)
        infoLabel.Text = "FPS: " .. fps .. "\nPing: " .. ping .. " ms"
    end

    if not Config.ESP and not Config.Aimbot then return end

    local vpSize = Camera.ViewportSize
    local centerX, centerY = vpSize.X * 0.5, vpSize.Y * 0.5
    local closestTarget, shortest = nil, Config.FOV
    local camPos = Camera.CFrame.Position

    for player, esp in pairs(cache) do
        if not esp.char or not esp.char.Parent then
            updateCharacterCache(player)
        end

        local head = esp.head
        local root = esp.root
        local hum = esp.humanoid
        local char = esp.char

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

        local topPos, topOn = Camera:WorldToViewportPoint(head.Position + Vector3new(0, 0.9, 0))
        local botPos, botOn = Camera:WorldToViewportPoint(root.Position - Vector3new(0, 3.1, 0))
        local onScreen = topOn and botOn and topPos.Z > 0 and botPos.Z > 0

        local canSee = true
        if Config.VisibleOnly then
            canSee = isVisible(camPos, head.Position, char)
        end

        local visible = onScreen and canSee

        if visible and Config.ESP then
            local height = math.abs(botPos.Y - topPos.Y)
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
                    local d = (dx * dx + dy * dy) ^ 0.5
                    if d < shortest then
                        shortest = d
                        closestTarget = head
                    end
                end
            end
        end
    end

    if Config.Aimbot and closestTarget then
        Camera.CFrame = Camera.CFrame:Lerp(CFramenew(Camera.CFrame.Position, closestTarget.Position), Config.AimStrength)
        if tick() - lastShot >= Config.FIRE_RATE then
            lastShot = tick()
            local tool = LP.Character and LP.Character:FindFirstChildOfClass("Tool")
            if tool then tool:Activate() end
        end
    end
end)
