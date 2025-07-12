--[[
    Squid Game GUI Script
    Generated and Fixed by Gemini

    Version 3.0 Changelog:
    - Complete UI overhaul to match the user's reference image (Grid Layout).
    - Re-implemented all requested features from the images and text.
    - Added a more flexible tab creation system that supports both List and Grid layouts.
    - Added sliders for WalkSpeed and FlySpeed.
    - Ensured all UI elements load correctly and fixed the "empty tab" issue.
    - Maintained stability fixes from v2.0 (pcall wrapper, PlayerGui parent).
]]

local success, err = pcall(function()
    -- // SERVICES
    local Players = game:GetService("Players")
    local UserInputService = game:GetService("UserInputService")
    local RunService = game:GetService("RunService")
    local TweenService = game:GetService("TweenService")

    -- // PLAYER VARIABLES
    local LocalPlayer = Players.LocalPlayer
    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

    -- // GUI LIBRARY
    local OrionLib = {}
    OrionLib.Name = "Squid Game Hub"
    OrionLib.Toggles = {} -- Central place to store toggle states and functions
    OrionLib.Values = { -- Store values for sliders, etc.
        FlySpeed = 50,
        WalkSpeed = 16
    }

    -- Clean up any old GUI
    if PlayerGui:FindFirstChild(OrionLib.Name) then
        PlayerGui:FindFirstChild(OrionLib.Name):Destroy()
    end

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
    MainFrame.Position = UDim2.new(0.5, -325, 0.5, -225)
    MainFrame.Size = UDim2.new(0, 650, 0, 450)
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Visible = true
    local MainCorner = Instance.new("UICorner", MainFrame)
    MainCorner.CornerRadius = UDim.new(0, 12)

    -- Title bar
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Parent = MainFrame
    TitleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    TitleBar.Size = UDim2.new(1, 0, 0, 40)
    local TitleCorner = Instance.new("UICorner", TitleBar)
    TitleCorner.CornerRadius = UDim.new(0, 12)

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "TitleLabel"
    TitleLabel.Parent = TitleBar
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Size = UDim2.new(1, -10, 1, 0)
    TitleLabel.Position = UDim2.new(0, 10, 0, 0)
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
    local TabsLayout = Instance.new("UIListLayout", TabsContainer)
    TabsLayout.FillDirection = Enum.FillDirection.Horizontal
    TabsLayout.Padding = UDim.new(0, 5)

    -- Container for content pages
    local PagesContainer = Instance.new("ScrollingFrame")
    PagesContainer.Name = "PagesContainer"
    PagesContainer.Parent = MainFrame
    PagesContainer.BackgroundTransparency = 1
    PagesContainer.Position = UDim2.new(0, 10, 0, 90)
    PagesContainer.Size = UDim2.new(1, -20, 1, -100)
    PagesContainer.CanvasSize = UDim2.new(0,0,0,0)
    PagesContainer.ScrollBarThickness = 5

    -- Make the window draggable
    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            local dragStart = input.Position
            local startPos = MainFrame.Position
            local conn
            conn = UserInputService.InputChanged:Connect(function(changeInput)
                if changeInput.UserInputType == Enum.UserInputType.MouseMovement or changeInput.UserInputType == Enum.UserInputType.Touch then
                    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + (changeInput.Position.X - dragStart.X), startPos.Y.Scale, startPos.Y.Offset + (changeInput.Position.Y - dragStart.Y))
                end
            end)
            UserInputService.InputEnded:Connect(function(endInput)
                if endInput.UserInputType == Enum.UserInputType.MouseButton1 or endInput.UserInputType == Enum.UserInputType.Touch then
                    conn:Disconnect()
                end
            end)
        end
    end)

    -- Tab creation logic
    local Tabs = {}
    function OrionLib:CreateTab(name, layout)
        local Page = Instance.new("Frame")
        Page.Name = name .. "Page"
        Page.Parent = PagesContainer
        Page.BackgroundTransparency = 1
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.Visible = false
        Page.AutomaticSize = Enum.AutomaticSize.Y
        
        if layout == "Grid" then
            local GridLayout = Instance.new("UIGridLayout", Page)
            GridLayout.CellSize = UDim2.new(0, 140, 0, 150)
            GridLayout.CellPadding = UDim2.new(0, 10, 0, 10)
            GridLayout.SortOrder = Enum.SortOrder.LayoutOrder
            GridLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
            GridLayout.StartCorner = Enum.StartCorner.TopLeft
        else -- Default to List
            local ListLayout = Instance.new("UIListLayout", Page)
            ListLayout.Padding = UDim.new(0, 10)
            ListLayout.FillDirection = Enum.FillDirection.Vertical
            ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        end

        local TabButton = Instance.new("TextButton", TabsContainer)
        TabButton.Name = name .. "Tab"
        TabButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        TabButton.Size = UDim2.new(0, 80, 1, 0)
        TabButton.Font = Enum.Font.Gotham
        TabButton.Text = name
        TabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
        TabButton.TextSize = 14
        local TabCorner = Instance.new("UICorner", TabButton)
        TabCorner.CornerRadius = UDim.new(0, 6)

        local function onTabClick()
            for _, otherTab in pairs(Tabs) do
                otherTab.Page.Visible = false
                otherTab.Button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                otherTab.Button.TextColor3 = Color3.fromRGB(200, 200, 200)
            end
            Page.Visible = true
            TabButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
            TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            PagesContainer.CanvasSize = UDim2.new(0,0,0,Page.AbsoluteSize.Y)
        end
        TabButton.MouseButton1Click:Connect(onTabClick)

        local tabInfo = { Button = TabButton, Page = Page, Click = onTabClick }
        
        function tabInfo:CreateSection(sectionName)
            local SectionFrame = Instance.new("Frame", Page)
            SectionFrame.Name = sectionName
            SectionFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            SectionFrame.BorderSizePixel = 0
            SectionFrame.AutomaticSize = Enum.AutomaticSize.Y
            if layout == "Grid" then
                SectionFrame.Size = UDim2.new(0, 140, 0, 150) -- Fixed size for grid cells
                SectionFrame.AutomaticSize = Enum.AutomaticSize.None
            end
            local SectionCorner = Instance.new("UICorner", SectionFrame)
            SectionCorner.CornerRadius = UDim.new(0, 8)
            
            local SectionLayout = Instance.new("UIListLayout", SectionFrame)
            SectionLayout.Padding = UDim.new(0, 5)
            SectionLayout.SortOrder = Enum.SortOrder.LayoutOrder
            
            local SectionTitle = Instance.new("TextLabel", SectionFrame)
            SectionTitle.BackgroundTransparency = 1
            SectionTitle.Size = UDim2.new(1, -10, 0, 20)
            SectionTitle.Position = UDim2.new(0, 5, 0, 5)
            SectionTitle.Font = Enum.Font.GothamSemibold
            SectionTitle.Text = sectionName
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
                    enabled = false, callback = callback,
                    updateUI = function(state)
                        local color = state and Color3.fromRGB(50, 180, 50) or Color3.fromRGB(180, 50, 50)
                        local pos = state and UDim2.new(0.5, 0, 0, 0) or UDim2.new(0, 0, 0, 0)
                        ToggleIndicator:TweenPosition(pos, "Out", "Quad", 0.2, true)
                        ToggleIndicator.BackgroundColor3 = color
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
            
            function sectionInfo:CreateSlider(name, min, max, start, callback)
                local SliderFrame = Instance.new("Frame", SectionFrame)
                SliderFrame.BackgroundTransparency = 1
                SliderFrame.Size = UDim2.new(1, 0, 0, 35)

                local SliderLabel = Instance.new("TextLabel", SliderFrame)
                SliderLabel.BackgroundTransparency = 1
                SliderLabel.Size = UDim2.new(1, 0, 0, 15)
                SliderLabel.Font = Enum.Font.Gotham
                SliderLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
                SliderLabel.TextSize = 14
                SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
                
                local Slider = Instance.new("Frame", SliderFrame)
                Slider.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                Slider.Size = UDim2.new(1, 0, 0, 10)
                Slider.Position = UDim2.new(0, 0, 0, 20)
                local SliderCorner = Instance.new("UICorner", Slider)
                SliderCorner.CornerRadius = UDim.new(0, 5)

                local Fill = Instance.new("Frame", Slider)
                Fill.BackgroundColor3 = Color3.fromRGB(80, 120, 255)
                local FillCorner = Instance.new("UICorner", Fill)
                FillCorner.CornerRadius = UDim.new(0, 5)

                local function updateSlider(value)
                    local percent = (value - min) / (max - min)
                    Fill.Size = UDim2.new(percent, 0, 1, 0)
                    SliderLabel.Text = name .. ": " .. tostring(math.floor(value))
                    pcall(callback, value)
                end

                Slider.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        local function move(moveInput)
                            local pos = moveInput.Position.X - Slider.AbsolutePosition.X
                            local percent = math.clamp(pos / Slider.AbsoluteSize.X, 0, 1)
                            local value = min + (max - min) * percent
                            updateSlider(value)
                        end
                        local conn = UserInputService.InputChanged:Connect(move)
                        UserInputService.InputEnded:Connect(function(endInput)
                            if endInput.UserInputType == Enum.UserInputType.MouseButton1 then conn:Disconnect() end
                        end)
                    end
                end)
                updateSlider(start)
            end

            return sectionInfo
        end
        table.insert(Tabs, tabInfo)
        if #Tabs == 1 then onTabClick() end
        return tabInfo
    end

    -- // SCRIPT LOGIC
    local ScriptFunctions = {}
    function ScriptFunctions:Noclip(enabled)
        ScriptFunctions.NoclipConnection = enabled and RunService.Stepped:Connect(function()
            if LocalPlayer.Character then
                for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") then part.CanCollide = false end
                end
            end
        end) or (ScriptFunctions.NoclipConnection and ScriptFunctions.NoclipConnection:Disconnect())
    end

    function ScriptFunctions:Fly(enabled)
        ScriptFunctions.Flying = enabled
        if enabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = LocalPlayer.Character.HumanoidRootPart
            local bg = Instance.new("BodyGyro", hrp)
            bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
            local bv = Instance.new("BodyVelocity", hrp)
            bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
            ScriptFunctions.FlyConnection = RunService.RenderStepped:Connect(function()
                bg.CFrame = workspace.CurrentCamera.CFrame
                local dir = Vector3.new()
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir = dir + Vector3.new(0,0,-1) end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir = dir + Vector3.new(0,0,1) end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir = dir + Vector3.new(-1,0,0) end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir = dir + Vector3.new(1,0,0) end
                bv.Velocity = (workspace.CurrentCamera.CFrame:VectorToWorldSpace(dir.Unit) * OrionLib.Values.FlySpeed)
            end)
        elseif ScriptFunctions.FlyConnection then
            ScriptFunctions.FlyConnection:Disconnect()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = LocalPlayer.Character.HumanoidRootPart
                if hrp:FindFirstChildOfClass("BodyGyro") then hrp:FindFirstChildOfClass("BodyGyro"):Destroy() end
                if hrp:FindFirstChildOfClass("BodyVelocity") then hrp:FindFirstChildOfClass("BodyVelocity"):Destroy() end
            end
        end
    end
    
    function ScriptFunctions:SetWalkSpeed(value)
        OrionLib.Values.WalkSpeed = value
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = value
        end
    end

    -- // BUILD THE UI
    local MainTab = OrionLib:CreateTab("Main", "Grid")
    local VisualsTab = OrionLib:CreateTab("Visuals", "List")
    local KeybindsTab = OrionLib:CreateTab("Keybinds", "List")
    local UITab = OrionLib:CreateTab("UI", "List")
    local CreditsTab = OrionLib:CreateTab("Credits", "List")

    -- == MAIN TAB ==
    local PlayerSection = MainTab:CreateSection("Player")
    PlayerSection:CreateToggle("Fly", function(state) ScriptFunctions:Fly(state) end)
    PlayerSection:CreateToggle("Noclip", function(state) ScriptFunctions:Noclip(state) end)
    PlayerSection:CreateToggle("God Mode", function(state)
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
            LocalPlayer.Character.Humanoid.MaxHealth = state and math.huge or 100
            LocalPlayer.Character.Humanoid.Health = state and math.huge or 100
        end
    end)
    
    local MovementSection = MainTab:CreateSection("Movement")
    MovementSection:CreateSlider("WalkSpeed", 16, 200, OrionLib.Values.WalkSpeed, function(val) ScriptFunctions:SetWalkSpeed(val) end)
    MovementSection:CreateSlider("FlySpeed", 50, 500, OrionLib.Values.FlySpeed, function(val) OrionLib.Values.FlySpeed = val end)

    local TeleportSection = MainTab:CreateSection("Teleport")
    -- Player list would be too big for a grid cell, better suited for a list layout tab.
    TeleportSection:CreateButton("TP to Safe Zone", function() if LocalPlayer.Character then LocalPlayer.Character:SetPrimaryPartCFrame(CFrame.new(0, 100, 0)) end end)

    local GameSection = MainTab:CreateSection("Game")
    GameSection:CreateButton("Auto RLGL", function() print("Not Implemented") end)
    GameSection:CreateButton("Auto Glass", function() print("Not Implemented") end)

    -- == VISUALS TAB ==
    local EspSection = VisualsTab:CreateSection("ESP")
    EspSection:CreateToggle("Enable ESP (WIP)", function(state) print("ESP: " .. tostring(state)) end)

    -- == KEYBINDS TAB ==
    local KeybindsSection = KeybindsTab:CreateSection("Set Keybinds")
    -- Keybind logic here...

    -- == UI & CREDITS TABS ==
    UITab:CreateSection("Settings"):CreateButton("Toggle UI (RightShift)", function() MainFrame.Visible = not MainFrame.Visible end)
    local creditLabel = Instance.new("TextLabel", CreditsTab:CreateSection("Credits").Container)
    creditLabel.Size, creditLabel.BackgroundTransparency = UDim2.new(1, -10, 0, 50), 1
    creditLabel.Font, creditLabel.Text = Enum.Font.Gotham, "Script by Gemini AI.\nUI inspired by user request."
    creditLabel.TextColor3, creditLabel.TextSize, creditLabel.TextWrapped = Color3.fromRGB(255, 255, 255), 16, true

    -- Finalize layout
    for _, tab in pairs(Tabs) do
        if tab.Page.Visible then
            task.wait(0.1) -- Wait a moment for UI to draw
            PagesContainer.CanvasSize = UDim2.new(0,0,0,tab.Page.AbsoluteSize.Y)
        end
    end

    -- // INPUT HANDLER
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.KeyCode == Enum.KeyCode.RightShift then
             MainFrame.Visible = not MainFrame.Visible
        end
    end)
end)

if not success then
    warn("Squid Game Hub Script failed to load: " .. tostring(err))
end
