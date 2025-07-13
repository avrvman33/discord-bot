-- =================================================================
-- FINAL VERSION - Shift-Click Teleport & Tutorial Fix
-- =================================================================

--// Services
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local TweenService = game:GetService("TweenService")

--// Script Control
local scriptActive = true -- Master switch for the entire script

--// Variables
local AimbotEnabled = false
local CurrentKey = Enum.KeyCode.E
local SelectingKey = false
local Target = nil
local HighlightedPlayer = nil
local isDropdownOpen = false
local tutorialActive = false

--// UI Sizes
local collapsedSize = UDim2.new(0, 250, 0, 140)
local expandedSize = UDim2.new(0, 250, 0, 280)

--// UI Creation
local Gui = Instance.new("ScreenGui", game:GetService("CoreGui"))
Gui.Name = "3rfeFinalUI_V3"
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Gui.ResetOnSpawn = false

-- Main Frame
local Frame = Instance.new("Frame", Gui)
Frame.Size = collapsedSize
Frame.Position = UDim2.new(0.5, 0, 0.5, 0)
Frame.AnchorPoint = Vector2.new(0.5, 0.5)
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Frame.BackgroundTransparency = 1
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true
Frame.ClipsDescendants = true

local UICorner = Instance.new("UICorner", Frame)
UICorner.CornerRadius = UDim.new(0, 10)
local UIStroke = Instance.new("UIStroke", Frame)
UIStroke.Color = Color3.fromRGB(200, 200, 200)
UIStroke.Thickness = 1
UIStroke.Transparency = 0.5
local UIGradient = Instance.new("UIGradient", Frame)
UIGradient.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(50, 50, 50)), ColorSequenceKeypoint.new(1, Color3.fromRGB(25, 25, 25)) })
UIGradient.Rotation = 45

--// Tutorial Elements
local TutorialContainer = Instance.new("Frame", Gui)
TutorialContainer.BackgroundTransparency = 1
TutorialContainer.Size = UDim2.new(1, 0, 0, 60)
TutorialContainer.Position = UDim2.new(0.5, 0, 0, 0)
TutorialContainer.AnchorPoint = Vector2.new(0.5, 0)
TutorialContainer.Visible = false
TutorialContainer.ZIndex = 10

local TutorialPopup = Instance.new("Frame", TutorialContainer)
TutorialPopup.Size = UDim2.new(0, 400, 0, 50)
TutorialPopup.Position = UDim2.new(0.5, 0, 0.5, 0)
TutorialPopup.AnchorPoint = Vector2.new(0.5, 0.5)
TutorialPopup.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
TutorialPopup.BackgroundTransparency = 1
TutorialPopup.BorderSizePixel = 0

local TutCorner = Instance.new("UICorner", TutorialPopup)
TutCorner.CornerRadius = UDim.new(0, 25)
local TutStroke = Instance.new("UIStroke", TutorialPopup)
TutStroke.Color = Color3.fromRGB(255, 0, 0)
TutStroke.Thickness = 5
TutStroke.Transparency = 1
local TutText = Instance.new("TextLabel", TutorialPopup)
TutText.Size = UDim2.new(1, -20, 1, 0)
TutText.Position = UDim2.new(0.5, 0, 0.5, 0)
TutText.AnchorPoint = Vector2.new(0.5, 0.5)
TutText.BackgroundTransparency = 1
TutText.TextColor3 = Color3.new(1, 1, 1)
TutText.Font = Enum.Font.SourceSans
TutText.Text = "Left Click to Toggle | Right Click to Change Keybind | Shift Click To Toggle Teleport"
TutText.TextSize = 16
TutText.TextWrapped = true
TutText.TextTransparency = 1

-- Tutorial Button
local TutorialButton = Instance.new("TextButton", Frame)
TutorialButton.Size = UDim2.new(0, 30, 0, 30)
TutorialButton.Position = UDim2.new(0, 8, 0, 5)
TutorialButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
TutorialButton.BackgroundTransparency = 0.5
TutorialButton.Font = Enum.Font.SourceSansBold
TutorialButton.Text = "?"
TutorialButton.TextSize = 22
TutorialButton.TextColor3 = Color3.new(1, 1, 1)
local TutBtnCorner = Instance.new("UICorner", TutorialButton)
TutBtnCorner.CornerRadius = UDim.new(0, 8)

-- Close Button
local CloseButton = Instance.new("TextButton", Frame)
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -8, 0, 5)
CloseButton.AnchorPoint = Vector2.new(1, 0)
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseButton.BackgroundTransparency = 0.4
CloseButton.Font = Enum.Font.SourceSansBold
CloseButton.Text = "X"
CloseButton.TextSize = 22
CloseButton.TextColor3 = Color3.new(1, 1, 1)
local CloseBtnCorner = Instance.new("UICorner", CloseButton)
CloseBtnCorner.CornerRadius = UDim.new(0, 8)

-- Title
local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1, -80, 0, 35)
Title.Position = UDim2.new(0.5, 0, 0, 5)
Title.AnchorPoint = Vector2.new(0.5, 0)
Title.Text = "3rfe"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextXAlignment = Enum.TextXAlignment.Center
Title.TextScaled = true
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.SourceSansBold

-- Aimbot Button
local ToggleBtn = Instance.new("TextButton", Frame)
ToggleBtn.Size = UDim2.new(1, -20, 0, 35)
ToggleBtn.Position = UDim2.new(0.5, 0, 0, 45)
ToggleBtn.AnchorPoint = Vector2.new(0.5, 0)
ToggleBtn.Text = "Aimbot (" .. tostring(CurrentKey):gsub("Enum.KeyCode.", "") .. ")"
ToggleBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
ToggleBtn.BackgroundTransparency = 0.3
ToggleBtn.TextColor3 = Color3.new(1, 1, 1)
ToggleBtn.Font = Enum.Font.SourceSans
ToggleBtn.TextScaled = true
local BtnCorner = Instance.new("UICorner", ToggleBtn)
BtnCorner.CornerRadius = UDim.new(0, 8)

-- Teleport Button
local TeleportBtn = Instance.new("TextButton", Frame)
TeleportBtn.Size = UDim2.new(1, -20, 0, 35)
TeleportBtn.Position = UDim2.new(0.5, 0, 0, 90)
TeleportBtn.AnchorPoint = Vector2.new(0.5, 0)
TeleportBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
TeleportBtn.BackgroundTransparency = 0.3
TeleportBtn.TextColor3 = Color3.new(1, 1, 1)
TeleportBtn.Text = "Select Player..."
TeleportBtn.Font = Enum.Font.SourceSans
TeleportBtn.TextXAlignment = Enum.TextXAlignment.Center
TeleportBtn.TextScaled = true
local TeleportBtnCorner = Instance.new("UICorner", TeleportBtn)
TeleportBtnCorner.CornerRadius = UDim.new(0, 8)

-- Dropdown List for Teleport
local DropdownList = Instance.new("ScrollingFrame", Frame)
DropdownList.Size = UDim2.new(1, -20, 0, 130)
DropdownList.Position = UDim2.new(0.5, 0, 0, 135)
DropdownList.AnchorPoint = Vector2.new(0.5, 0)
DropdownList.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
DropdownList.BorderSizePixel = 0
DropdownList.Visible = false
DropdownList.ClipsDescendants = true
DropdownList.CanvasSize = UDim2.new(0, 0, 0, 0)
DropdownList.ScrollBarThickness = 6
DropdownList.BackgroundTransparency = 0.2
local DropdownCorner = Instance.new("UICorner", DropdownList)
DropdownCorner.CornerRadius = UDim.new(0, 8)
local UIListLayout = Instance.new("UIListLayout", DropdownList)
UIListLayout.Padding = UDim.new(0, 5)
UIListLayout.SortOrder = Enum.SortOrder.Name
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

--// --- Functions ---
-- FIXED Tutorial Functions
function hideTutorial()
	if not tutorialActive then return end
	tutorialActive = false
	local tweenInfo = TweenInfo.new(0.5)
	TweenService:Create(TutorialPopup, tweenInfo, {BackgroundTransparency = 1}):Play()
	TweenService:Create(TutStroke, tweenInfo, {Transparency = 1}):Play()
	local textTween = TweenService:Create(TutText, tweenInfo, {TextTransparency = 1})
	textTween:Play()
	textTween.Completed:Wait()
	TutorialContainer.Visible = false
end

function showTutorial()
	if tutorialActive then return end
	tutorialActive = true
	TutorialContainer.Visible = true
	local tweenInfo = TweenInfo.new(0.5)
	TweenService:Create(TutorialPopup, tweenInfo, {BackgroundTransparency = 0.2}):Play()
	TweenService:Create(TutStroke, tweenInfo, {Transparency = 0.5}):Play()
	TweenService:Create(TutText, tweenInfo, {TextTransparency = 0}):Play()
	task.delay(7, hideTutorial)
end

function removeHighlight() if HighlightedPlayer and HighlightedPlayer.Character then local old = HighlightedPlayer.Character:FindFirstChild("AimbotHighlight") if old then old:Destroy() end end; HighlightedPlayer = nil end
function highlightTarget(player) if player == HighlightedPlayer then return end; removeHighlight(); local highlight = Instance.new("Highlight", player.Character); highlight.Name = "AimbotHighlight"; highlight.FillColor = Color3.fromRGB(255, 0, 0); highlight.OutlineColor = Color3.fromRGB(200, 0, 0); highlight.FillTransparency = 0.6; HighlightedPlayer = player end
function getClosestTarget() local p, d = nil, math.huge; for _, v in ipairs(Players:GetPlayers()) do if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Head") and v.Character:FindFirstChildOfClass("Humanoid").Health > 0 then local s, o = Camera:WorldToViewportPoint(v.Character.Head.Position); if o then local t = (Vector2.new(s.X, s.Y) - UserInputService:GetMouseLocation()).Magnitude; if t < d then d = t; p = v end end end end return p end
function toggleAimbot() AimbotEnabled = not AimbotEnabled; if AimbotEnabled then ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 80) Target = getClosestTarget() else ToggleBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50) removeHighlight() Target = nil end end
function collapseDropdown() isDropdownOpen = false; DropdownList.Visible = false; Frame:TweenSize(collapsedSize, Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.3, true); TeleportBtn.Text = "Select Player..." end
function expandDropdown() isDropdownOpen = true; updatePlayerList(); Frame:TweenSize(expandedSize, Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.3, true); DropdownList.Visible = true; TeleportBtn.Text = "▲ Close Menu" end

-- MODIFIED updatePlayerList to support Shift-Click
function updatePlayerList()
	for _, child in ipairs(DropdownList:GetChildren()) do
		if child:IsA("TextButton") then
			child:Destroy()
		end
	end
	local playerCount = 0
	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= LocalPlayer then
			playerCount = playerCount + 1
			local playerBtn = Instance.new("TextButton", DropdownList)
			playerBtn.Name = player.Name
			playerBtn.Size = UDim2.new(1, -10, 0, 30)
			playerBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
			playerBtn.TextColor3 = Color3.new(1, 1, 1)
			playerBtn.Text = "  " .. player.DisplayName
			playerBtn.Font = Enum.Font.SourceSans
			playerBtn.TextXAlignment = Enum.TextXAlignment.Left
			playerBtn.TextScaled = true
			local plrBtnCorner = Instance.new("UICorner", playerBtn)
			plrBtnCorner.CornerRadius = UDim.new(0, 6)
			
			playerBtn.MouseButton1Click:Connect(function()
				if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
					LocalPlayer.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame * CFrame.new(0, 3, 0)
					
					-- Check if Shift key is held down
					local shiftHeld = UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or UserInputService:IsKeyDown(Enum.KeyCode.RightShift)
					if not shiftHeld then
						collapseDropdown()
					end
				end
			end)
		end
	end
	DropdownList.CanvasSize = UDim2.new(0, 0, 0, (30 + UIListLayout.Padding.Offset) * playerCount + 5)
end

--// --- Input Handling ---
TutorialButton.MouseButton1Click:Connect(showTutorial)
TeleportBtn.MouseButton1Click:Connect(function() if isDropdownOpen then collapseDropdown() else expandDropdown() end end)
CloseButton.MouseButton1Click:Connect(function() scriptActive = false; removeHighlight(); Gui:Destroy() end)
ToggleBtn.MouseButton1Click:Connect(toggleAimbot)
ToggleBtn.MouseButton2Click:Connect(function() if isDropdownOpen then collapseDropdown() end; SelectingKey = true; ToggleBtn.Text = "Press any key..." end)

UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
	if not scriptActive or gameProcessedEvent then return end
	if SelectingKey and input.UserInputType == Enum.UserInputType.Keyboard then
		CurrentKey = input.KeyCode
		SelectingKey = false
		local keyName = tostring(CurrentKey):gsub("Enum.KeyCode.", "")
		ToggleBtn.Text = "Aimbot (" .. keyName .. ")"
	elseif input.KeyCode == CurrentKey then
		toggleAimbot()
	end
end)

--// --- Main Loop & Initial Animation ---
Frame:TweenSize(collapsedSize, Enum.EasingDirection.Out, Enum.EasingStyle.Back, 0.4, true)
TweenService:Create(Frame, TweenInfo.new(0.4), { BackgroundTransparency = 0.6 }):Play()

RunService.RenderStepped:Connect(function()
	if not scriptActive then return end
	UIGradient.Rotation = 45 + math.sin(tick() * 0.5) * 10
	if AimbotEnabled and Target then
		if Target.Character and Target.Character:FindFirstChild("Head") and Target.Character:FindFirstChildOfClass("Humanoid").Health > 0 then
			highlightTarget(Target)
			Camera.CFrame = CFrame.new(Camera.CFrame.Position, Target.Character.Head.Position)
		else
			removeHighlight()
			Target = nil
		end
	end
end)