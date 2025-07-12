--[[
    Squid Game GUI Script
    Generated and Fixed by Gemini

    Version 2.0 Changelog:
    - Fixed a critical error with tab creation that prevented the GUI from loading.
    - Changed GUI parent to PlayerGui for better stability and compatibility.
    - Implemented a more robust system for keybinds to toggle features on and off.
    - Added AutomaticSize to UI sections for a more dynamic layout.
    - Wrapped the script in a pcall to prevent silent failures and provide error messages.
]]

local success, err = pcall(function()
    -- // SERVICES
    local Players = game:GetService("Players")
    local UserInputService = game:GetService("UserInputService")
    local RunService = game:GetService("RunService")
    local CoreGui = game:GetService("CoreGui")

    -- // PLAYER VARIABLES
    local LocalPlayer = Players.LocalPlayer
    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

    -- // GUI LIBRARY
    local OrionLib = {}
    OrionLib.Name = "Squid Game Hub"
    OrionLib.Visible = true
    OrionLib.Draggable = true
    OrionLib.Toggles = {} -- Central place to store toggle states and functions

    -- Create the main ScreenGui
    local MainGui = Instance.new("ScreenGui")
    MainGui.Name = OrionLib.Name
    MainGui.Parent = PlayerGui
    MainGui.ResetOnSpawn = false

    -- Create the main frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = MainGui
    MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    MainFrame.BorderColor3 = Color3.fromRGB(80, 80, 80)
    MainFrame.BorderSizePixel = 1
    MainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
    MainFrame.Size = UDim2.new(0, 600, 0, 400)
    MainFrame.Active = true
    MainFrame.Draggable = OrionLib.Draggable
    MainFrame.Visible = OrionLib.Visible

    -- Add a corner radius
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 12)
    UICorner.Parent = MainFrame

    -- Title bar
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Parent = MainFrame
    TitleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    TitleBar.Size = UDim2.new(1, 0, 0, 40)
    local TitleCorner = Instance.new("UICorner")
    TitleCorner.CornerRadius = UDim.new(0, 12)
    TitleCorner.Parent = TitleBar
    local TitleShadow = TitleBar:Clone()
    TitleShadow.Parent = MainFrame
    TitleShadow.ZIndex = 0
    TitleShadow.BackgroundColor3 = Color3.fromRGB(15,15,15)
    TitleShadow.Position = UDim2.new(0,0,0,2)

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "TitleLabel"
    TitleLabel.Parent = TitleBar
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Size = UDim2.new(1, -10, 1, 0)
    TitleLabel.Position = UDim2.new(0, 5, 0, 0)
    TitleLabel.Font = Enum.Font.GothamSemibold
    TitleLabel.Text = OrionLib.Name
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.TextSize = 18
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

    -- Container for tabs
    local TabsContainer = Instance.new("Frame")
    TabsContainer.Name = "TabsContainer"
    TabsContainer.Parent = MainFrame
    TabsContainer.BackgroundTransparency = 1
    TabsContainer.Position = UDim2.new(0, 10, 0, 50)
    TabsContainer.Size = UDim2.new(1, -20, 0, 30)

    -- Container for content pages
    local PagesContainer = Instance.new("Frame")
    PagesContainer.Name = "PagesContainer"
    PagesContainer.Parent = MainFrame
    PagesContainer.BackgroundTransparency = 1
    PagesContainer.Position = UDim2.new(0, 10, 0, 90)
    PagesContainer.Size = UDim2.new(1, -20, 1, -100)

    -- Make the window draggable
    if OrionLib.Draggable then
        TitleBar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                local dragStart = input.Position
                local startPos = MainFrame.Position
                local dragConnection
                dragConnection = UserInputService.InputChanged:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                        local newPos = input.Position
                        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + (newPos.X - dragStart.X), startPos.Y.Scale, startPos.Y.Offset + (newPos.Y - dragStart.Y))
                    end
                end)
                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        dragConnection:Disconnect()
                    end
                end)
            end
        end)
    end

    -- Tab creation logic
    local Tabs = {}
    function OrionLib:CreateTab(name)
        local Page = Instance.new("Frame")
        Page.Name = name .. "Page"
        Page.Parent = PagesContainer
        Page.BackgroundTransparency = 1
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.Visible = false

        local PageLayout = Instance.new("UIListLayout")
        PageLayout.Padding = UDim.new(0, 10)
        PageLayout.FillDirection = Enum.FillDirection.Vertical
        PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
        PageLayout.Parent = Page
        
        local TabButton = Instance.new("TextButton")
        TabButton.Name = name .. "Tab"
        TabButton.Parent = TabsContainer
        TabButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        TabButton.Size = UDim2.new(0, 80, 1, 0)
        TabButton.Font = Enum.Font.Gotham
        TabButton.Text = name
        TabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
        TabButton.TextSize = 14
        local TabCorner = Instance.new("UICorner")
        TabCorner.CornerRadius = UDim.new(0, 6)
        TabCorner.Parent = TabButton

        local function onTabClick()
            for _, v in pairs(Tabs) do
                v.Page.Visible = false
                v.Button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                v.Button.TextColor3 = Color3.fromRGB(200, 200, 200)
            end
            Page.Visible = true
            TabButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
            TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        end

        TabButton.MouseButton1Click:Connect(onTabClick)

        local tabInfo = { Button = TabButton, Page = Page, Sections = {}, Click = onTabClick }
        table.insert(Tabs, tabInfo)
        
        local TabsLayout = TabsContainer:FindFirstChildOfClass("UIListLayout") or Instance.new("UIListLayout", TabsContainer)
        TabsLayout.FillDirection = Enum.FillDirection.Horizontal
        TabsLayout.Padding = UDim.new(0, 5)

        if #Tabs == 1 then
            onTabClick() -- Correctly select the first tab
        end

        function tabInfo:CreateSection(name)
            local SectionFrame = Instance.new("Frame")
            SectionFrame.Name = name
            SectionFrame.Parent = Page
            SectionFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            SectionFrame.BorderSizePixel = 0
            SectionFrame.Size = UDim2.new(1, 0, 0, 0) -- Y size is 0
            SectionFrame.AutomaticSize = Enum.AutomaticSize.Y -- Let content determine height
            
            local SectionCorner = Instance.new("UICorner", SectionFrame)
            SectionCorner.CornerRadius = UDim.new(0, 8)
            
            local SectionLayout = Instance.new("UIListLayout", SectionFrame)
            SectionLayout.Padding = UDim.new(0, 5)
            SectionLayout.SortOrder = Enum.SortOrder.LayoutOrder
            
            local SectionTitle = Instance.new("TextLabel", SectionFrame)
            SectionTitle.Name = "SectionTitle"
            SectionTitle.BackgroundTransparency = 1
            SectionTitle.Size = UDim2.new(1, -10, 0, 20)
            SectionTitle.Position = UDim2.new(0, 5, 0, 0)
            SectionTitle.Font = Enum.Font.GothamSemibold
            SectionTitle.Text = name
            SectionTitle.TextColor3 = Color3.fromRGB(220, 220, 220)
            SectionTitle.TextSize = 16
            SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
            
            local SectionPadding = Instance.new("UIPadding", SectionFrame)
            SectionPadding.PaddingTop = UDim.new(0, 25)
            SectionPadding.PaddingLeft = UDim.new(0, 5)
            SectionPadding.PaddingRight = UDim.new(0, 5)
            SectionPadding.PaddingBottom = UDim.new(0, 5)

            local sectionInfo = { Container = SectionFrame }
            
            function sectionInfo:CreateButton(name, callback)
                local Button = Instance.new("TextButton", SectionFrame)
                Button.Name = name
                Button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                Button.Size = UDim2.new(1, 0, 0, 30)
                Button.Font = Enum.Font.Gotham
                Button.Text = name
                Button.TextColor3 = Color3.fromRGB(255, 255, 255)
                Button.TextSize = 14
                local ButtonCorner = Instance.new("UICorner", Button)
                ButtonCorner.CornerRadius = UDim.new(0, 5)
                Button.MouseButton1Click:Connect(function() pcall(callback) end)
                return Button
            end

            function sectionInfo:CreateToggle(name, callback)
                local ToggleFrame = Instance.new("Frame", SectionFrame)
                ToggleFrame.Name = name
                ToggleFrame.BackgroundTransparency = 1
                ToggleFrame.Size = UDim2.new(1, 0, 0, 30)
                
                local ToggleLabel = Instance.new("TextLabel", ToggleFrame)
                ToggleLabel.BackgroundTransparency = 1
                ToggleLabel.Size = UDim2.new(0.8, 0, 1, 0)
                ToggleLabel.Font = Enum.Font.Gotham
                ToggleLabel.Text = name
                ToggleLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
                ToggleLabel.TextSize = 14
                ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left

                local ToggleButton = Instance.new("TextButton", ToggleFrame)
                ToggleButton.Size = UDim2.new(0.2, -10, 0.8, 0)
                ToggleButton.Position = UDim2.new(0.8, 5, 0.1, 0)
                ToggleButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
                ToggleButton.Text = ""
                local ToggleCorner = Instance.new("UICorner", ToggleButton)
                ToggleCorner.CornerRadius = UDim.new(0, 4)
                
                local ToggleIndicator = Instance.new("Frame", ToggleButton)
                ToggleIndicator.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
                ToggleIndicator.BorderSizePixel = 0
                ToggleIndicator.Size = UDim2.new(0.5, 0, 1, 0)
                local IndicatorCorner = Instance.new("UICorner", ToggleIndicator)
                IndicatorCorner.CornerRadius = UDim.new(0, 4)
                
                OrionLib.Toggles[name] = {
                    enabled = false,
                    callback = callback,
                    updateUI = function(state)
                        if state then
                            ToggleIndicator:TweenPosition(UDim2.new(0.5, 0, 0, 0), "Out", "Quad", 0.2, true)
                            ToggleIndicator.BackgroundColor3 = Color3.fromRGB(50, 180, 50)
                        else
                            ToggleIndicator:TweenPosition(UDim2.new(0, 0, 0, 0), "Out", "Quad", 0.2, true)
                            ToggleIndicator.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
                        end
                    end
                }
                
                ToggleButton.MouseButton1Click:Connect(function()
                    local toggleData = OrionLib.Toggles[name]
                    toggleData.enabled = not toggleData.enabled
                    pcall(toggleData.callback, toggleData.enabled)
                    toggleData.updateUI(toggleData.enabled)
                end)
                
                return ToggleButton
            end

            function sectionInfo:CreatePlayerList(name, callback)
                local DropdownFrame = Instance.new("Frame", SectionFrame)
                DropdownFrame.Name = name
                DropdownFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                DropdownFrame.Size = UDim2.new(1, 0, 0, 30)
                local DropdownCorner = Instance.new("UICorner", DropdownFrame)
                DropdownCorner.CornerRadius = UDim.new(0, 5)

                local SelectedPlayerLabel = Instance.new("TextLabel", DropdownFrame)
                SelectedPlayerLabel.Size = UDim2.new(1, -35, 1, 0)
                SelectedPlayerLabel.BackgroundTransparency = 1
                SelectedPlayerLabel.Font = Enum.Font.Gotham
                SelectedPlayerLabel.Text = "Select a Player"
                SelectedPlayerLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
                SelectedPlayerLabel.TextSize = 14

                local DropdownButton = Instance.new("TextButton", DropdownFrame)
                DropdownButton.Size = UDim2.new(0, 30, 1, 0)
                DropdownButton.Position = UDim2.new(1, -30, 0, 0)
                DropdownButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
                DropdownButton.Font = Enum.Font.Gotham
                DropdownButton.Text = "▼"
                DropdownButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                
                local PlayerList = Instance.new("ScrollingFrame", DropdownFrame)
                PlayerList.Position = UDim2.new(0, 0, 1, 5)
                PlayerList.Size = UDim2.new(1, 0, 0, 150)
                PlayerList.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                PlayerList.BorderSizePixel = 0
                PlayerList.Visible = false
                PlayerList.CanvasSize = UDim2.new(0,0,0,0)
                local PlayerListLayout = Instance.new("UIListLayout", PlayerList)
                PlayerListLayout.SortOrder = Enum.SortOrder.LayoutOrder

                DropdownButton.MouseButton1Click:Connect(function()
                    PlayerList.Visible = not PlayerList.Visible
                    if PlayerList.Visible then
                        for _, v in pairs(PlayerList:GetChildren()) do
                            if v:IsA("TextButton") then v:Destroy() end
                        end
                        for _, player in pairs(Players:GetPlayers()) do
                            if player ~= LocalPlayer then
                                local PlayerButton = Instance.new("TextButton", PlayerList)
                                PlayerButton.Size = UDim2.new(1, 0, 0, 25)
                                PlayerButton.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
                                PlayerButton.Font = Enum.Font.Gotham
                                PlayerButton.Text = player.Name
                                PlayerButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                                PlayerButton.MouseButton1Click:Connect(function()
                                    SelectedPlayerLabel.Text = player.Name
                                    PlayerList.Visible = false
                                    pcall(callback, player)
                                end)
                            end
                        end
                        PlayerList.CanvasSize = UDim2.new(0, 0, 0, PlayerListLayout.AbsoluteContentSize.Y)
                    end
                end)
                return DropdownFrame, SelectedPlayerLabel
            end

            return sectionInfo
        end

        return tabInfo
    end

    -- // SCRIPT LOGIC
    local ScriptFunctions = {}

    function ScriptFunctions:Noclip(enabled)
        if enabled then
            ScriptFunctions.NoclipConnection = RunService.Stepped:Connect(function()
                if LocalPlayer.Character then
                    for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                        if part:IsA("BasePart") then part.CanCollide = false end
                    end
                end
            end)
        elseif ScriptFunctions.NoclipConnection then
            ScriptFunctions.NoclipConnection:Disconnect()
            ScriptFunctions.NoclipConnection = nil
        end
    end

    function ScriptFunctions:Fly(enabled)
        ScriptFunctions.Flying = enabled
        if enabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = LocalPlayer.Character.HumanoidRootPart
            local bodyGyro = Instance.new("BodyGyro", hrp)
            bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
            bodyGyro.CFrame = hrp.CFrame
            local bodyVel = Instance.new("BodyVelocity", hrp)
            bodyVel.MaxForce = Vector3.new(9e9, 9e9, 9e9)
            bodyVel.Velocity = Vector3.new(0, 0, 0)
            
            ScriptFunctions.FlyConnection = UserInputService.InputBegan:Connect(function(input)
                if not ScriptFunctions.Flying then return end
                local cam = workspace.CurrentCamera
                local flySpeed = 50
                if input.KeyCode == Enum.KeyCode.W then bodyVel.Velocity = cam.CFrame.LookVector * flySpeed
                elseif input.KeyCode == Enum.KeyCode.S then bodyVel.Velocity = -cam.CFrame.LookVector * flySpeed
                elseif input.KeyCode == Enum.KeyCode.D then bodyVel.Velocity = cam.CFrame.RightVector * flySpeed
                elseif input.KeyCode == Enum.KeyCode.A then bodyVel.Velocity = -cam.CFrame.RightVector * flySpeed
                end
            end)
             UserInputService.InputEnded:Connect(function(input)
                if input.KeyCode == Enum.KeyCode.W or input.KeyCode == Enum.KeyCode.S or input.KeyCode == Enum.KeyCode.D or input.KeyCode == Enum.KeyCode.A then
                    if bodyVel and bodyVel.Parent then bodyVel.Velocity = Vector3.new(0,0,0) end
                end
            end)

        elseif ScriptFunctions.FlyConnection then
            ScriptFunctions.FlyConnection:Disconnect()
            ScriptFunctions.FlyConnection = nil
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = LocalPlayer.Character.HumanoidRootPart
                if hrp:FindFirstChildOfClass("BodyGyro") then hrp:FindFirstChildOfClass("BodyGyro"):Destroy() end
                if hrp:FindFirstChildOfClass("BodyVelocity") then hrp:FindFirstChildOfClass("BodyVelocity"):Destroy() end
            end
        end
    end

    function ScriptFunctions:GodMode(enabled)
        if enabled then
            ScriptFunctions.GodModeConnection = LocalPlayer.CharacterAdded:Connect(function(char)
                local humanoid = char:WaitForChild("Humanoid")
                humanoid.MaxHealth = math.huge
                humanoid.Health = math.huge
            end)
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.MaxHealth = math.huge
                LocalPlayer.Character.Humanoid.Health = math.huge
            end
        else
            if ScriptFunctions.GodModeConnection then ScriptFunctions.GodModeConnection:Disconnect() end
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                 LocalPlayer.Character.Humanoid.MaxHealth = 100
                 LocalPlayer.Character.Humanoid.Health = 100
            end
        end
    end

    function ScriptFunctions:Invisible(enabled)
        if not LocalPlayer.Character then return end
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") or part:IsA("Decal") then
                part.Transparency = enabled and 1 or 0
            end
        end
    end

    -- // BUILD THE UI
    local MainTab = OrionLib:CreateTab("Main")
    local VisualsTab = OrionLib:CreateTab("Visuals")
    local KeybindsTab = OrionLib:CreateTab("Keybinds")
    local UITab = OrionLib:CreateTab("UI")
    local CreditsTab = OrionLib:CreateTab("Credits")

    -- == MAIN TAB ==
    local PlayerSection = MainTab:CreateSection("Player")
    PlayerSection:CreateToggle("Fly", function(state) ScriptFunctions:Fly(state) end)
    PlayerSection:CreateToggle("Noclip", function(state) ScriptFunctions:Noclip(state) end)
    PlayerSection:CreateToggle("Anti Punch (God)", function(state) ScriptFunctions:GodMode(state) end)
    PlayerSection:CreateToggle("Invisible Mode", function(state) ScriptFunctions:Invisible(state) end)

    local TeleportSection = MainTab:CreateSection("Teleport")
    local _, selectedPlayerLabel = TeleportSection:CreatePlayerList("Players", function() end)
    TeleportSection:CreateButton("Teleport to Selected Player", function()
        local targetPlayer = Players:FindFirstChild(selectedPlayerLabel.Text)
        if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character then
            LocalPlayer.Character:SetPrimaryPartCFrame(targetPlayer.Character.PrimaryPart.CFrame)
        end
    end)

    -- == VISUALS TAB ==
    local EspSection = VisualsTab:CreateSection("ESP")
    EspSection:CreateToggle("Enable ESP (WIP)", function(state) print("ESP: " .. tostring(state)) end)

    -- == KEYBINDS TAB ==
    local KeybindsSection = KeybindsTab:CreateSection("Set Keybinds")
    local Keybinds = {}
    local KeybindButtons = {}
    local isBinding, featureToBind = false, nil

    local function CreateKeybindButton(featureName, action)
        local button = KeybindsSection:CreateButton(featureName .. " : [Not Set]", function()
            if isBinding then return end
            isBinding, featureToBind = true, featureName
            button.Text = featureName .. " : [Press a key...]"
        end)
        KeybindButtons[featureName] = {button = button, action = action, key = nil}
    end

    CreateKeybindButton("Safe Zone Teleport", function()
        if LocalPlayer.Character then
            LocalPlayer.Character:SetPrimaryPartCFrame(CFrame.new(0, 100, 0))
            print("Teleported to Safe Zone")
        end
    end)
    CreateKeybindButton("Toggle Fly", function()
        local toggleData = OrionLib.Toggles["Fly"]
        if toggleData then
            toggleData.enabled = not toggleData.enabled
            pcall(toggleData.callback, toggleData.enabled)
            toggleData.updateUI(toggleData.enabled)
        end
    end)

    -- == UI & CREDITS TABS ==
    UITab:CreateSection("Settings"):CreateButton("Toggle UI (RightShift)", function() MainFrame.Visible = not MainFrame.Visible end)
    local creditLabel = Instance.new("TextLabel", CreditsTab:CreateSection("Credits").Container)
    creditLabel.Size, creditLabel.BackgroundTransparency = UDim2.new(1, -10, 0, 50), 1
    creditLabel.Font, creditLabel.Text = Enum.Font.Gotham, "Script by Gemini AI.\nUI inspired by user request."
    creditLabel.TextColor3, creditLabel.TextSize, creditLabel.TextWrapped = Color3.fromRGB(255, 255, 255), 16, true

    -- // INPUT HANDLER
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed and not isBinding then return end

        if isBinding and featureToBind then
            local key = input.KeyCode
            local currentBinding = KeybindButtons[featureToBind]
            if currentBinding.key then Keybinds[currentBinding.key] = nil end
            currentBinding.key = key
            Keybinds[key] = currentBinding.action
            currentBinding.button.Text = featureToBind .. " : [" .. key.Name .. "]"
            isBinding, featureToBind = false, nil
        elseif Keybinds[input.KeyCode] then
            pcall(Keybinds[input.KeyCode])
        elseif input.KeyCode == Enum.KeyCode.RightShift then
             MainFrame.Visible = not MainFrame.Visible
        end
    end)
end)

if not success then
    warn("Squid Game Hub Script failed to load: " .. tostring(err))
end
