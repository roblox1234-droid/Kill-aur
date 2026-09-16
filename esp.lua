-- ЗАПОЛНЕНИЕ ВКЛАДОК

-- Visual
makeToggle(pages.Visual, "ESP Master",   "ESP")
makeToggle(pages.Visual, "Box",          "Box")
makeToggle(pages.Visual, "Name + Dist",  "Name")
makeToggle(pages.Visual, "HP Bar",       "HP")
makeToggle(pages.Visual, "Tool",         "Tool")
makeToggle(pages.Visual, "Chams",        "Chams")
makeToggle(pages.Visual, "Visible Only", "VisibleOnly")
makeToggle(pages.Visual, "Tracers",      "Tracers")

-- Aimbot
makeToggle(pages.Aimbot, "Aimbot",   "Aimbot")
makeToggle(pages.Aimbot, "Show FOV", "ShowFOV")
makeSlider(pages.Aimbot, "FOV", 20, 500, Config.FOV, function(v) Config.FOV = v end)
makeSlider(pages.Aimbot, "Aim Strength", 0.1, 1.0, Config.AimStrength, function(v) Config.AimStrength = v end)

-- Movement
makeToggle(pages.Movement, "Fly",          "Fly")
makeToggle(pages.Movement, "Noclip",       "Noclip")
makeToggle(pages.Movement, "Speed Hack",   "SpeedHack")
makeToggle(pages.Movement, "Infinite Jump","InfiniteJump")
makeToggle(pages.Movement, "Bunny Hop",    "BunnyHop")
makeSlider(pages.Movement, "Fly Speed", 10, 500, Config.FlySpeed, function(v) Config.FlySpeed = v end)
makeSlider(pages.Movement, "Walk Speed", 16, 200, Config.WalkSpeed, function(v)
    Config.WalkSpeed = v
    if Config.SpeedHack then
        local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = v end
    end
end)

-- Misc
makeToggle(pages.Misc, "Anti-AFK",    "AntiAFK")
makeToggle(pages.Misc, "Fullbright",  "Fullbright")
makeToggle(pages.Misc, "FPS Boost",   "FPSBoost")
makeToggle(pages.Misc, "Auto Reload", "AutoReload")
makeToggle(pages.Misc, "Menu Key",    "Menu")

selectTab("Visual")

-- ВВОД
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
        showNotify(string.format("[ %s ] bind -> %s", toggles[bindingKey].label, input.KeyCode.Name), Color3.fromRGB(0, 200, 255))
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
                if key == "SpeedHack" then toggleSpeedHack() end
                if key == "InfiniteJump" then toggleInfiniteJump() end
                if key == "BunnyHop" then toggleBunnyHop() end
                if key == "AntiAFK" then toggleAntiAFK() end
                if key == "Fullbright" then toggleFullbright() end
                if key == "AutoReload" then toggleAutoReload() end
                showNotify(string.format("[ %s: %s ]", toggles[key].label, Config[key] and "ON" or "OFF"), Config[key] and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(255, 80, 80))
            end
            return
        end
    end
end)

close.MouseButton1Click:Connect(function()
    main.Visible = false
end)

-- РЕСПАВН
LP.CharacterAdded:Connect(function()
    task.wait(0.5)
    if Config.Fly then toggleFly() end
    if Config.Noclip then toggleNoclip() end
    if Config.SpeedHack then toggleSpeedHack() end
    if Config.InfiniteJump then toggleInfiniteJump() end
    if Config.BunnyHop then toggleBunnyHop() end
    if Config.AutoReload then toggleAutoReload() end
end)

-- ОСНОВНОЙ ЦИКЛ
local lastShot = 0

RunService.RenderStepped:Connect(function()
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

    if Config.ShowFOV and Config.Aimbot then
        local diameter = Config.FOV * 2
        fovCircle.Size = UDim2fromOffset(diameter, diameter)
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

    if Config.ShowFOV and Config.Aimbot then
        if closestTarget then
            fovStroke.Color = Color3.fromRGB(255, 50, 50)
        else
            fovStroke.Color = Color3.fromRGB(0, 255, 150)
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
