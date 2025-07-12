-- سكربت 3rfe GUI المعدل - نسخة ثابتة
-- تبويبات: Main, Visual, Teleport - بدون Invisible Mode أو Complete Red/Green Light

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local keybinds = {}
local toggleGUIKey = Enum.KeyCode.RightShift
local guiVisible = true
local infiniteJumpEnabled = false
local selectedSpeed = 16
local speedEnabled = false

-- GUI
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "ThreeRfeGUI"

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 600, 0, 400)
MainFrame.Position = UDim2.new(0.25, 0, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = true
MainFrame.Active = true
MainFrame.Draggable = true

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 30)
corner.Parent = MainFrame

-- Tabs
local Tabs = { "Main", "Visual", "Teleport" }
local TabContent = {}

local TabFrame = Instance.new("Frame", MainFrame)
TabFrame.Size = UDim2.new(1, 0, 0, 40)
TabFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

local ContentFrame = Instance.new("Frame", MainFrame)
ContentFrame.Position = UDim2.new(0, 0, 0, 40)
ContentFrame.Size = UDim2.new(1, 0, 1, -40)
ContentFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)

local function switchTab(tab)
    for name, frame in pairs(TabContent) do
        frame.Visible = (name == tab)
    end
end

for i, tabName in ipairs(Tabs) do
    local btn = Instance.new("TextButton", TabFrame)
    btn.Size = UDim2.new(0, 80, 1, 0)
    btn.Position = UDim2.new(0, (i - 1) * 85, 0, 0)
    btn.Text = tabName
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 18
    btn.MouseButton1Click:Connect(function() switchTab(tabName) end)

    local tabPanel = Instance.new("Frame", ContentFrame)
    tabPanel.Size = UDim2.new(1, 0, 1, 0)
    tabPanel.BackgroundTransparency = 1
    tabPanel.Visible = (i == 1)
    TabContent[tabName] = tabPanel
end

-- زر مساعد
local function addButton(parent, text, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(0, 200, 0, 30)
    btn.Position = UDim2.new(0, 10, 0, #parent:GetChildren() * 35)
    btn.Text = text
    btn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 16
    btn.MouseButton1Click:Connect(callback)
end

-- Main Tab
addButton(TabContent["Main"], "Safe Zone", function()
    -- مكان افتراضي آمن، عدله حسب الماب الحقيقي
    LocalPlayer.Character:MoveTo(Vector3.new(100, 10, 100))
end)

-- Teleport to hider
addButton(TabContent["Main"], "Teleport to Hider", function()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character:MoveTo(plr.Character.HumanoidRootPart.Position + Vector3.new(3, 0, 0))
            break
        end
    end
end)

-- Visual Tab
local speedLabel = Instance.new("TextLabel", TabContent["Visual"])
speedLabel.Size = UDim2.new(0, 200, 0, 30)
speedLabel.Position = UDim2.new(0, 10, 0, 10)
speedLabel.Text = "Speed: 16"
speedLabel.BackgroundTransparency = 1
speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)

local speedSlider = Instance.new("TextBox", TabContent["Visual"])
speedSlider.Size = UDim2.new(0, 200, 0, 30)
speedSlider.Position = UDim2.new(0, 10, 0, 50)
speedSlider.Text = "16"
speedSlider.ClearTextOnFocus = false
speedSlider.FocusLost:Connect(function()
    local val = tonumber(speedSlider.Text)
    if val and val >= 1 and val <= 1000 then
        selectedSpeed = val
        speedLabel.Text = "Speed: " .. val
    end
end)

local toggleSpeedBtn = Instance.new("TextButton", TabContent["Visual"])
toggleSpeedBtn.Size = UDim2.new(0, 200, 0, 30)
toggleSpeedBtn.Position = UDim2.new(0, 10, 0, 90)
toggleSpeedBtn.Text = "Toggle Speed"
toggleSpeedBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
toggleSpeedBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleSpeedBtn.MouseButton1Click:Connect(function()
    speedEnabled = not speedEnabled
end)

local infBtn = Instance.new("TextButton", TabContent["Visual"])
infBtn.Size = UDim2.new(0, 200, 0, 30)
infBtn.Position = UDim2.new(0, 10, 0, 130)
infBtn.Text = "Toggle Infinite Jump"
infBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
infBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
infBtn.MouseButton1Click:Connect(function()
    infiniteJumpEnabled = not infiniteJumpEnabled
end)

RunService.RenderStepped:Connect(function()
    local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = speedEnabled and selectedSpeed or 16
    end
end)

UIS.JumpRequest:Connect(function()
    if infiniteJumpEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

print("✅ سكربت 3rfe GUI - نسخة ثابتة بدون مشاكل")
