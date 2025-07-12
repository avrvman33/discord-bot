--// Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- GUI toggle key
local menuKey = Enum.KeyCode.Z

-- Speed toggle key
local speedToggleKey = Enum.KeyCode.X
local speedEnabled = false

-- Auto Attack key
local autoAttackKey = Enum.KeyCode.C
local autoAttackEnabled = false

-- Wall Hack key (NoClip)
local wallHackKey = Enum.KeyCode.V
local wallHackEnabled = false

-- GUI setup
local gui = Instance.new("ScreenGui")
gui.Name = "ModMenu"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 350, 0, 510)
frame.Position = UDim2.new(0, 20, 0.5, -255)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Visible = true
frame.Parent = gui

Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)
Instance.new("UIStroke", frame).Color = Color3.fromRGB(80, 80, 80)

local layout = Instance.new("UIListLayout", frame)
layout.Padding = UDim.new(0, 10)
layout.SortOrder = Enum.SortOrder.LayoutOrder

local padding = Instance.new("UIPadding", frame)
padding.PaddingTop = UDim.new(0, 10)
padding.PaddingBottom = UDim.new(0, 10)
padding.PaddingLeft = UDim.new(0, 10)
padding.PaddingRight = UDim.new(0, 10)

-- Title
local title = Instance.new("TextLabel", frame)
title.Text = "🎯 Mod Menu"
title.Font = Enum.Font.GothamBold
title.TextSize = 22
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundTransparency = 1
title.Size = UDim2.new(1, 0, 0, 30)

-- SPEED SLIDER
local speed = 16
local minSpeed, maxSpeed = 16, 1000

local speedFrame = Instance.new("Frame", frame)
speedFrame.Size = UDim2.new(1, -10, 0, 60)
speedFrame.BackgroundTransparency = 1
speedFrame.ClipsDescendants = true

local speedLabel = Instance.new("TextLabel", speedFrame)
speedLabel.Text = "Speed: " .. speed
speedLabel.Size = UDim2.new(1, 0, 0, 20)
speedLabel.TextColor3 = Color3.new(1, 1, 1)
speedLabel.Font = Enum.Font.Gotham
speedLabel.TextSize = 16
speedLabel.BackgroundTransparency = 1

local sliderBar = Instance.new("Frame", speedFrame)
sliderBar.Position = UDim2.new(0, 0, 0, 35)
sliderBar.Size = UDim2.new(1, 0, 0, 6)
sliderBar.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
sliderBar.BorderSizePixel = 0
Instance.new("UICorner", sliderBar).CornerRadius = UDim.new(1, 0)

local sliderKnob = Instance.new("TextButton", sliderBar)
sliderKnob.Size = UDim2.new(0, 16, 0, 16)
sliderKnob.Position = UDim2.new(0, 0, 0.5, -8)
sliderKnob.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
sliderKnob.BorderSizePixel = 0
sliderKnob.AutoButtonColor = false
sliderKnob.Text = ""
Instance.new("UICorner", sliderKnob).CornerRadius = UDim.new(1, 0)

local dragging = false

sliderKnob.MouseButton1Down:Connect(function()
	dragging = true
	frame.Active = false
end)

UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
		frame.Active = true
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		local x = input.Position.X
		local barPos = sliderBar.AbsolutePosition.X
		local barSize = sliderBar.AbsoluteSize.X
		local relative = math.clamp(x - barPos, 0, barSize)
		local percent = relative / barSize
		sliderKnob.Position = UDim2.new(0, relative - 8, 0.5, -8)
		speed = math.floor(minSpeed + percent * (maxSpeed - minSpeed))
		speedLabel.Text = "Speed: " .. tostring(speed)
	end
end)

-- SPEED KEYBIND BUTTON
local speedKeyBtn = Instance.new("TextButton", frame)
speedKeyBtn.Text = "Speed Toggle [X] - OFF"
speedKeyBtn.Size = UDim2.new(1, -10, 0, 40)
speedKeyBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
speedKeyBtn.TextColor3 = Color3.new(1, 1, 1)
speedKeyBtn.Font = Enum.Font.GothamBold
speedKeyBtn.TextSize = 18
speedKeyBtn.BorderSizePixel = 0
Instance.new("UICorner", speedKeyBtn).CornerRadius = UDim.new(0, 8)

local function toggleSpeed()
	speedEnabled = not speedEnabled
	if speedEnabled then
		speedKeyBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
		speedKeyBtn.Text = "Speed Toggle [X] - ON"
	else
		speedKeyBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
		speedKeyBtn.Text = "Speed Toggle [X] - OFF"
	end
end

speedKeyBtn.MouseButton1Click:Connect(toggleSpeed)

speedKeyBtn.MouseButton2Click:Connect(function()
	speedKeyBtn.Text = "Press key..."
	local conn
	conn = UserInputService.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.Keyboard then
			speedToggleKey = input.KeyCode
			speedKeyBtn.Text = "Speed Toggle [" .. speedToggleKey.Name .. "] - " .. (speedEnabled and "ON" or "OFF")
			conn:Disconnect()
		end
	end)
end)

-- Speed loop
RunService.Heartbeat:Connect(function()
	if speedEnabled and player.Character and player.Character:FindFirstChild("Humanoid") then
		player.Character.Humanoid.WalkSpeed = speed
	elseif not speedEnabled and player.Character and player.Character:FindFirstChild("Humanoid") then
		player.Character.Humanoid.WalkSpeed = 16
	end
end)

-- AIMBOT
local aimKey = Enum.KeyCode.E
local aimActive = false
local lockedTarget = nil
local currentHighlight = nil

local function getClosestTarget()
	local shortest = math.huge
	local target = nil
	for _, plr in pairs(Players:GetPlayers()) do
		if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
			local pos = workspace.CurrentCamera:WorldToScreenPoint(plr.Character.HumanoidRootPart.Position)
			local dist = (Vector2.new(mouse.X, mouse.Y) - Vector2.new(pos.X, pos.Y)).Magnitude
			if dist < shortest then
				shortest = dist
				target = plr
			end
		end
	end
	return target
end

local function highlightTarget(char)
	local h = Instance.new("Highlight")
	h.FillColor = Color3.new(1, 0, 0)
	h.OutlineTransparency = 1
	h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
	h.Parent = char
	return h
end

RunService.RenderStepped:Connect(function()
	if aimActive and lockedTarget and lockedTarget.Character and lockedTarget.Character:FindFirstChild("HumanoidRootPart") then
		local targetPart = lockedTarget.Character.HumanoidRootPart
		mouse.TargetFilter = lockedTarget.Character
		local camera = workspace.CurrentCamera
		camera.CFrame = CFrame.new(camera.CFrame.Position, targetPart.Position)
	end
end)

local aimBtn = Instance.new("TextButton", frame)
aimBtn.Text = "AimBot [E]"
aimBtn.Size = UDim2.new(1, -10, 0, 40)
aimBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
aimBtn.TextColor3 = Color3.new(1, 1, 1)
aimBtn.Font = Enum.Font.GothamBold
aimBtn.TextSize = 18
aimBtn.BorderSizePixel = 0
Instance.new("UICorner", aimBtn).CornerRadius = UDim.new(0, 8)

local function toggleAim()
	aimActive = not aimActive
	if aimActive then
		lockedTarget = getClosestTarget()
		if lockedTarget and lockedTarget.Character then
			if currentHighlight then currentHighlight:Destroy() end
			currentHighlight = highlightTarget(lockedTarget.Character)
		end
		aimBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
		aimBtn.Text = "AimBot [E] - ON"
	else
		lockedTarget = nil
		if currentHighlight then currentHighlight:Destroy() end
		currentHighlight = nil
		aimBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
		aimBtn.Text = "AimBot [E] - OFF"
	end
end

aimBtn.MouseButton1Click:Connect(toggleAim)

aimBtn.MouseButton2Click:Connect(function()
	aimBtn.Text = "Press key..."
	local conn
	conn = UserInputService.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.Keyboard then
			aimKey = input.KeyCode
			aimBtn.Text = "AimBot [" .. aimKey.Name .. "] - " .. (aimActive and "ON" or "OFF")
			conn:Disconnect()
		end
	end)
end)

-- AUTO ATTACK
local autoAttackBtn = Instance.new("TextButton", frame)
autoAttackBtn.Text = "Auto Attack [C] - OFF"
autoAttackBtn.Size = UDim2.new(1, -10, 0, 40)
autoAttackBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
autoAttackBtn.TextColor3 = Color3.new(1, 1, 1)
autoAttackBtn.Font = Enum.Font.GothamBold
autoAttackBtn.TextSize = 18
autoAttackBtn.BorderSizePixel = 0
Instance.new("UICorner", autoAttackBtn).CornerRadius = UDim.new(0, 8)

local function toggleAutoAttack()
	autoAttackEnabled = not autoAttackEnabled
	if autoAttackEnabled then
		autoAttackBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
		autoAttackBtn.Text = "Auto Attack [C] - ON"
	else
		autoAttackBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
		autoAttackBtn.Text = "Auto Attack [C] - OFF"
	end
end

autoAttackBtn.MouseButton1Click:Connect(toggleAutoAttack)

autoAttackBtn.MouseButton2Click:Connect(function()
	autoAttackBtn.Text = "Press key..."
	local conn
	conn = UserInputService.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.Keyboard then
			autoAttackKey = input.KeyCode
			autoAttackBtn.Text = "Auto Attack [" .. autoAttackKey.Name .. "] - " .. (autoAttackEnabled and "ON" or "OFF")
			conn:Disconnect()
		end
	end)
end)

-- Auto Attack Logic
local lastAttackTime = 0
local attackCooldown = 0.5 -- نصف ثانية بين كل ضربة

local function performAttack()
	if not player.Character then return end
	
	-- البحث عن السلاح في اليد
	local tool = player.Character:FindFirstChildOfClass("Tool")
	if tool then
		-- إذا كان السلاح يحتوي على Handle
		if tool:FindFirstChild("Handle") then
			-- تفعيل السلاح
			tool:Activate()
		end
		
		-- إذا كان السلاح يحتوي على RemoteEvent للضرب
		for _, v in pairs(tool:GetDescendants()) do
			if v:IsA("RemoteEvent") and (v.Name:lower():find("fire") or v.Name:lower():find("shoot") or v.Name:lower():find("attack") or v.Name:lower():find("damage")) then
				pcall(function()
					v:FireServer()
				end)
			end
		end
	else
		-- إذا لم يكن هناك سلاح، استخدم الضرب بالايد
		local humanoid = player.Character:FindFirstChild("Humanoid")
		if humanoid then
			-- محاولة تفعيل الضرب
			humanoid:EquipTool(nil)
		end
	end
end

RunService.Heartbeat:Connect(function()
	if autoAttackEnabled and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
		local currentTime = tick()
		if currentTime - lastAttackTime >= attackCooldown then
			-- البحث عن أقرب هدف
			local closestTarget = getClosestTarget()
			if closestTarget and closestTarget.Character and closestTarget.Character:FindFirstChild("HumanoidRootPart") then
				local targetPos = closestTarget.Character.HumanoidRootPart.Position
				local playerPos = player.Character.HumanoidRootPart.Position
				local distance = (targetPos - playerPos).Magnitude
				
				-- إذا كان الهدف قريب (أقل من 10 studs)
				if distance <= 10 then
					performAttack()
					lastAttackTime = currentTime
				end
			end
		end
	end
end)

-- WALL HACK (NoClip)
local wallHackBtn = Instance.new("TextButton", frame)
wallHackBtn.Text = "Wall Hack [V] - OFF"
wallHackBtn.Size = UDim2.new(1, -10, 0, 40)
wallHackBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
wallHackBtn.TextColor3 = Color3.new(1, 1, 1)
wallHackBtn.Font = Enum.Font.GothamBold
wallHackBtn.TextSize = 18
wallHackBtn.BorderSizePixel = 0
Instance.new("UICorner", wallHackBtn).CornerRadius = UDim.new(0, 8)

local function toggleWallHack()
	wallHackEnabled = not wallHackEnabled
	if wallHackEnabled then
		wallHackBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
		wallHackBtn.Text = "Wall Hack [V] - ON"
	else
		wallHackBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
		wallHackBtn.Text = "Wall Hack [V] - OFF"
	end
end

wallHackBtn.MouseButton1Click:Connect(toggleWallHack)

wallHackBtn.MouseButton2Click:Connect(function()
	wallHackBtn.Text = "Press key..."
	local conn
	conn = UserInputService.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.Keyboard then
			wallHackKey = input.KeyCode
			wallHackBtn.Text = "Wall Hack [" .. wallHackKey.Name .. "] - " .. (wallHackEnabled and "ON" or "OFF")
			conn:Disconnect()
		end
	end)
end)

-- NoClip Logic
RunService.Heartbeat:Connect(function()
	if wallHackEnabled and player.Character then
		for _, part in pairs(player.Character:GetChildren()) do
			if part:IsA("BasePart") then
				part.CanCollide = false
			end
		end
	elseif not wallHackEnabled and player.Character then
		for _, part in pairs(player.Character:GetChildren()) do
			if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
				part.CanCollide = true
			end
		end
	end
end)

-- MENU TOGGLE KEY BUTTON
local menuKeyBtn = Instance.new("TextButton", frame)
menuKeyBtn.Text = "Menu Keybind [Z]"
menuKeyBtn.Size = UDim2.new(1, -10, 0, 40)
menuKeyBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
menuKeyBtn.TextColor3 = Color3.new(1, 1, 1)
menuKeyBtn.Font = Enum.Font.GothamBold
menuKeyBtn.TextSize = 18
menuKeyBtn.BorderSizePixel = 0
Instance.new("UICorner", menuKeyBtn).CornerRadius = UDim.new(0, 8)

menuKeyBtn.MouseButton2Click:Connect(function()
	menuKeyBtn.Text = "Press key..."
	local conn
	conn = UserInputService.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.Keyboard then
			menuKey = input.KeyCode
			menuKeyBtn.Text = "Menu Keybind [" .. menuKey.Name .. "]"
			conn:Disconnect()
		end
	end)
end)

-- KILL GUI BUTTON
local killBtn = Instance.new("TextButton", frame)
killBtn.Text = "🗑️ Kill GUI"
killBtn.Size = UDim2.new(1, -10, 0, 40)
killBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
killBtn.TextColor3 = Color3.new(1, 1, 1)
killBtn.Font = Enum.Font.GothamBold
killBtn.TextSize = 18
killBtn.BorderSizePixel = 0
Instance.new("UICorner", killBtn).CornerRadius = UDim.new(0, 8)

killBtn.MouseButton1Click:Connect(function()
	gui:Destroy()
end)

-- KEY BINDS
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if input.KeyCode == aimKey then
		toggleAim()
	elseif input.KeyCode == menuKey then
		frame.Visible = not frame.Visible
	elseif input.KeyCode == speedToggleKey then
		toggleSpeed()
	elseif input.KeyCode == autoAttackKey then
		toggleAutoAttack()
	elseif input.KeyCode == wallHackKey then
		toggleWallHack()
	end
end)