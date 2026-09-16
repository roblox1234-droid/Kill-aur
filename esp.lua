local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

local noclipEnabled = false
local connection

-- Функция включения/выключения noclip
local function toggleNoclip()
	noclipEnabled = not noclipEnabled
	
	if noclipEnabled then
		-- Включаем проход сквозь стены
		connection = RunService.Stepped:Connect(function()
			for _, part in pairs(character:GetDescendants()) do
				if part:IsA("BasePart") then
					part.CanCollide = false
				end
			end
		end)
		
		-- Делаем персонажа чуть "летучим"
		humanoid.PlatformStand = true
		print("Noclip включён")
	else
		-- Выключаем
		if connection then
			connection:Disconnect()
			connection = nil
		end
		
		for _, part in pairs(character:GetDescendants()) do
			if part:IsA("BasePart") then
				part.CanCollide = true
			end
		end
		
		humanoid.PlatformStand = false
		print("Noclip выключен")
	end
end

-- Управление (клавиша N)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	
	if input.KeyCode == Enum.KeyCode.N then
		toggleNoclip()
	end
end)

-- На случай респавна
player.CharacterAdded:Connect(function(newCharacter)
	character = newCharacter
	humanoid = character:WaitForChild("Humanoid")
	rootPart = character:WaitForChild("HumanoidRootPart")
	
	if noclipEnabled then
		-- Перезапускаем noclip после респавна
		toggleNoclip()
		toggleNoclip()
	end
end)
