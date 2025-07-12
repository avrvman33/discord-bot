-- سكربت 3rfe GUI المعدل حسب طلبك
-- يشمل: keybinds قابلة للتغيير، Visual speed/infinite jump، إخفاء عالمي، تيليبورته للهايدر، وغيرها

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

-- إعدادات أساسية
local keybinds = {}
local toggleGUIKey = Enum.KeyCode.RightShift
local guiVisible = true
local infiniteJumpEnabled = false
local walkSpeed = 16

-- إنشاء GUI
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "ThreeRfeGUI"

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 600, 0, 400)
MainFrame.Position = UDim2.new(0.25, 0, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = true
local corner = Instance.new("UICorner", MainFrame)
corner.CornerRadius = UDim.new(0, 30)

-- Toggle GUI
UIS.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == toggleGUIKey then
        guiVisible = not guiVisible
        MainFrame.Visible = guiVisible
    end
end)

-- تبويبات
local Tabs = { "Main", "Visual", "UI", "Keybinds", "Teleport" }
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

-- إضافة زر
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
    LocalPlayer.Character:MoveTo(Vector3.new(0, 10, 0))
end)

addButton(TabContent["Main"], "Invisible Mode", function()
    for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.Transparency = 1
            part.CanCollide = false
        end
    end
end)

addButton(TabContent["Main"], "Complete Red/Green Light", function()
    LocalPlayer.Character:MoveTo(Vector3.new(300, 10, 0)) -- غير دي حسب خط النهاية
end)

addButton(TabContent["Main"], "Teleport to Hider", function()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character:MoveTo(plr.Character.HumanoidRootPart.Position + Vector3.new(3, 0, 0))
            break
        end
    end
end)

-- Visual Tab
addButton(TabContent["Visual"], "Set Speed to 1000", function()
    if LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = 1000
    end
end)

addButton(TabContent["Visual"], "Toggle Infinite Jump", function()
    infiniteJumpEnabled = not infiniteJumpEnabled
end)

-- Keybinds
UIS.InputBegan:Connect(function(input, gpe)
    if not gpe and keybinds[input.KeyCode] then
        keybinds[input.KeyCode]()
    end
end)

-- مثال: ربط مفتاح
addButton(TabContent["Keybinds"], "Set K for Safe Zone", function()
    keybinds[Enum.KeyCode.K] = function()
        LocalPlayer.Character:MoveTo(Vector3.new(0, 10, 0))
    end
end)

addButton(TabContent["Keybinds"], "Set F for Toggle GUI", function()
    toggleGUIKey = Enum.KeyCode.F
end)

addButton(TabContent["Keybinds"], "Bind J to Infinite Jump Toggle", function()
    keybinds[Enum.KeyCode.J] = function()
        infiniteJumpEnabled = not infiniteJumpEnabled
    end
end)

-- UI Tab
addButton(TabContent["UI"], "Change GUI Keybind to T", function()
    toggleGUIKey = Enum.KeyCode.T
end)

-- Teleport Tab
local playerList = Instance.new("ScrollingFrame", TabContent["Teleport"])
playerList.Size = UDim2.new(0, 200, 0, 300)
playerList.Position = UDim2.new(0, 10, 0, 10)
playerList.CanvasSize = UDim2.new(0, 0, 5, 0)
playerList.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
playerList.BorderSizePixel = 0

local function refreshPlayers()
    playerList:ClearAllChildren()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local btn = Instance.new("TextButton", playerList)
            btn.Size = UDim2.new(1, -10, 0, 30)
            btn.Position = UDim2.new(0, 5, 0, #playerList:GetChildren() * 32)
            btn.Text = plr.Name
            btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.MouseButton1Click:Connect(function()
                LocalPlayer.Character:MoveTo(plr.Character.HumanoidRootPart.Position + Vector3.new(2, 0, 0))
            end)
        end
    end
end

refreshPlayers()

-- Infinite Jump
UIS.JumpRequest:Connect(function()
    if infiniteJumpEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

print("✅ 3rfe GUI Loaded with all requested features.")
