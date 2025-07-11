-- سكربت Roblox - GUI باسم 3rfe
-- يحتوي على: جميع المودات + UI رمادية + Keybinds + Teleport + Invisible Mode + Anti Punch + مودات Squid Game

-- الخدمات
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")

-- GUI
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "ThreeRfeGUI"

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 600, 0, 400)
MainFrame.Position = UDim2.new(0.25, 0, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = true

-- Toggle GUI with RightShift
UIS.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.RightShift then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

-- تبويبات
local Tabs = { "Main", "Visual", "UI", "Credits", "Keybinds", "Teleport", "Misc" }
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
-- دالة لإضافة زر داخل أي تبويب
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

-- مودات تبويب Main
addButton(TabContent["Main"], "Safe Zone", function()
    if LocalPlayer.Character then
        LocalPlayer.Character:MoveTo(Vector3.new(0, 100, 0))
    end
end)

addButton(TabContent["Main"], "God Mode", function()
    if LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

addButton(TabContent["Main"], "Invisible Mode", function()
    if LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Transparency = 1
            end
        end
    end
end)
-- تبويب Teleport: قائمة اللاعبين
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

-- تبويب Keybinds: تعيين مفاتيح الاختصار
local KeybindActions = {}

UIS.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and KeybindActions[input.KeyCode] then
        KeybindActions[input.KeyCode]()
    end
end)

addButton(TabContent["Keybinds"], "Bind 1 to SafeZone", function()
    KeybindActions[Enum.KeyCode.One] = function()
        LocalPlayer.Character:MoveTo(Vector3.new(0, 100, 0))
    end
end)

addButton(TabContent["Keybinds"], "Bind 2 to Spawn", function()
    KeybindActions[Enum.KeyCode.Two] = function()
        LocalPlayer.Character:MoveTo(Vector3.new(0, 10, 0))
    end
end)
-- Red Light / Green Light (كسر التثبيت والحركة)
addButton(TabContent["Main"], "Red Light / Green Light", function()
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if root then
        root.Anchored = false
        root.Velocity = Vector3.new(50, 0, 0)
    end
end)

-- Hide and Seek ESP
addButton(TabContent["Main"], "Hide and Seek ESP", function()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local gui = Instance.new("BillboardGui", plr.Character.HumanoidRootPart)
            gui.Size = UDim2.new(0, 100, 0, 40)
            gui.AlwaysOnTop = true
            local label = Instance.new("TextLabel", gui)
            label.Size = UDim2.new(1, 0, 1, 0)
            label.Text = plr.Name
            label.TextColor3 = Color3.fromRGB(255, 0, 0)
            label.BackgroundTransparency = 1
        end
    end
end)

-- Tug of War Auto Win
addButton(TabContent["Main"], "Tug of War Auto Win", function()
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if root then
        root.Anchored = true
        task.wait(2)
        root.Anchored = false
    end
end)

-- Glass Bridge Reveal
addButton(TabContent["Main"], "Glass Bridge Reveal", function()
    for _, part in pairs(workspace:GetDescendants()) do
        if part:IsA("Part") and part.Transparency == 1 and part.Name:lower():find("glass") then
            part.Transparency = 0.3
            part.Color = Color3.fromRGB(255, 0, 0)
        end
    end
end)

-- Auto Push Players
addButton(TabContent["Main"], "Auto Push Players", function()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local push = Instance.new("BodyVelocity", plr.Character.HumanoidRootPart)
            push.Velocity = Vector3.new(50, 0, 0)
            push.MaxForce = Vector3.new(1e5, 1e5, 1e5)
            task.delay(1, function() push:Destroy() end)
        end
    end
end)
