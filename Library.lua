-- Custom UI Library
-- A modern UI library for Roblox with a clean, functional design

local Library = {}
Library.__index = Library

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Tables for storing UI elements
getgenv().Toggles = getgenv().Toggles or {}
getgenv().Options = getgenv().Options or {}

-- Utility Functions
local function Tween(instance, properties, duration)
    local tweenInfo = TweenInfo.new(duration or 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = TweenService:Create(instance, tweenInfo, properties)
    tween:Play()
    return tween
end

local function MakeDraggable(frame, dragHandle)
    local dragging = false
    local dragInput, mousePos, framePos
    
    dragHandle = dragHandle or frame
    
    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            mousePos = input.Position
            framePos = frame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    dragHandle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - mousePos
            frame.Position = UDim2.new(
                framePos.X.Scale,
                framePos.X.Offset + delta.X,
                framePos.Y.Scale,
                framePos.Y.Offset + delta.Y
            )
        end
    end)
end

-- Create Window
function Library:CreateWindow(config)
    config = config or {}
    local window = {
        Tabs = {},
        Unloaded = false
    }
    
    -- Create ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "CustomUILib"
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = game:GetService("CoreGui")
    
    window.ScreenGui = ScreenGui
    
    -- Main Frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 600, 0, 400)
    MainFrame.Position = config.Center and UDim2.new(0.5, -300, 0.5, -200) or UDim2.new(0.3, 0, 0.2, 0)
    MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 6)
    UICorner.Parent = MainFrame
    
    -- Title Bar
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Size = UDim2.new(1, 0, 0, 35)
    TitleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = MainFrame
    
    local TitleCorner = Instance.new("UICorner")
    TitleCorner.CornerRadius = UDim.new(0, 6)
    TitleCorner.Parent = TitleBar
    
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -10, 1, 0)
    TitleLabel.Position = UDim2.new(0, 10, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = config.Title or "UI Library"
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.TextSize = 14
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = TitleBar
    
    MakeDraggable(MainFrame, TitleBar)
    
    -- Tab Container
    local TabContainer = Instance.new("Frame")
    TabContainer.Name = "TabContainer"
    TabContainer.Size = UDim2.new(1, 0, 0, 30)
    TabContainer.Position = UDim2.new(0, 0, 0, 35)
    TabContainer.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    TabContainer.BorderSizePixel = 0
    TabContainer.Parent = MainFrame
    
    local TabLayout = Instance.new("UIListLayout")
    TabLayout.FillDirection = Enum.FillDirection.Horizontal
    TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabLayout.Padding = UDim.new(0, 5)
    TabLayout.Parent = TabContainer
    
    local TabPadding = Instance.new("UIPadding")
    TabPadding.PaddingLeft = UDim.new(0, 5)
    TabPadding.PaddingTop = UDim.new(0, 5)
    TabPadding.Parent = TabContainer
    
    -- Content Frame
    local ContentFrame = Instance.new("Frame")
    ContentFrame.Name = "ContentFrame"
    ContentFrame.Size = UDim2.new(1, -10, 1, -75)
    ContentFrame.Position = UDim2.new(0, 5, 0, 70)
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.Parent = MainFrame
    
    window.MainFrame = MainFrame
    window.TabContainer = TabContainer
    window.ContentFrame = ContentFrame
    
    if config.AutoShow ~= false then
        MainFrame.Visible = true
    end
    
    function window:AddTab(name)
        local tab = {}
        local tabIndex = #self.Tabs + 1
        
        -- Tab Button
        local TabButton = Instance.new("TextButton")
        TabButton.Name = name
        TabButton.Size = UDim2.new(0, 80, 1, -5)
        TabButton.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
        TabButton.BorderSizePixel = 0
        TabButton.Text = name
        TabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
        TabButton.TextSize = 12
        TabButton.Font = Enum.Font.Gotham
        TabButton.Parent = TabContainer
        
        local TabCorner = Instance.new("UICorner")
        TabCorner.CornerRadius = UDim.new(0, 4)
        TabCorner.Parent = TabButton
        
        -- Tab Content
        local TabContent = Instance.new("Frame")
        TabContent.Name = name .. "Content"
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        TabContent.BackgroundTransparency = 1
        TabContent.Visible = tabIndex == 1
        TabContent.Parent = ContentFrame
        
        -- Left and Right Containers
        local LeftContainer = Instance.new("ScrollingFrame")
        LeftContainer.Name = "LeftContainer"
        LeftContainer.Size = UDim2.new(0.48, 0, 1, 0)
        LeftContainer.Position = UDim2.new(0, 0, 0, 0)
        LeftContainer.BackgroundTransparency = 1
        LeftContainer.BorderSizePixel = 0
        LeftContainer.ScrollBarThickness = 4
        LeftContainer.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 90)
        LeftContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
        LeftContainer.Parent = TabContent
        
        local LeftLayout = Instance.new("UIListLayout")
        LeftLayout.SortOrder = Enum.SortOrder.LayoutOrder
        LeftLayout.Padding = UDim.new(0, 8)
        LeftLayout.Parent = LeftContainer
        
        local RightContainer = Instance.new("ScrollingFrame")
        RightContainer.Name = "RightContainer"
        RightContainer.Size = UDim2.new(0.48, 0, 1, 0)
        RightContainer.Position = UDim2.new(0.52, 0, 0, 0)
        RightContainer.BackgroundTransparency = 1
        RightContainer.BorderSizePixel = 0
        RightContainer.ScrollBarThickness = 4
        RightContainer.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 90)
        RightContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
        RightContainer.Parent = TabContent
        
        local RightLayout = Instance.new("UIListLayout")
        RightLayout.SortOrder = Enum.SortOrder.LayoutOrder
        RightLayout.Padding = UDim.new(0, 8)
        RightLayout.Parent = RightContainer
        
        -- Update canvas size on layout change
        LeftLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            LeftContainer.CanvasSize = UDim2.new(0, 0, 0, LeftLayout.AbsoluteContentSize.Y + 10)
        end)
        
        RightLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            RightContainer.CanvasSize = UDim2.new(0, 0, 0, RightLayout.AbsoluteContentSize.Y + 10)
        end)
        
        TabButton.MouseButton1Click:Connect(function()
            for _, t in pairs(self.Tabs) do
                t.Content.Visible = false
                t.Button.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
                t.Button.TextColor3 = Color3.fromRGB(200, 200, 200)
            end
            TabContent.Visible = true
            TabButton.BackgroundColor3 = Color3.fromRGB(50, 130, 230)
            TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        end)
        
        if tabIndex == 1 then
            TabButton.BackgroundColor3 = Color3.fromRGB(50, 130, 230)
            TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        end
        
        tab.Button = TabButton
        tab.Content = TabContent
        tab.LeftContainer = LeftContainer
        tab.RightContainer = RightContainer
        
        function tab:AddLeftGroupbox(name)
            return self:CreateGroupbox(name, self.LeftContainer)
        end
        
        function tab:AddRightGroupbox(name)
            return self:CreateGroupbox(name, self.RightContainer)
        end
        
        function tab:AddLeftTabbox()
            return self:CreateTabbox(self.LeftContainer)
        end
        
        function tab:AddRightTabbox()
            return self:CreateTabbox(self.RightContainer)
        end
        
        function tab:CreateGroupbox(name, parent)
            local groupbox = {}
            
            local GroupFrame = Instance.new("Frame")
            GroupFrame.Name = name
            GroupFrame.Size = UDim2.new(1, 0, 0, 0)
            GroupFrame.AutomaticSize = Enum.AutomaticSize.Y
            GroupFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
            GroupFrame.BorderSizePixel = 0
            GroupFrame.Parent = parent
            
            local GroupCorner = Instance.new("UICorner")
            GroupCorner.CornerRadius = UDim.new(0, 4)
            GroupCorner.Parent = GroupFrame
            
            local GroupTitle = Instance.new("TextLabel")
            GroupTitle.Size = UDim2.new(1, -10, 0, 20)
            GroupTitle.Position = UDim2.new(0, 5, 0, 5)
            GroupTitle.BackgroundTransparency = 1
            GroupTitle.Text = name
            GroupTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
            GroupTitle.TextSize = 13
            GroupTitle.Font = Enum.Font.GothamBold
            GroupTitle.TextXAlignment = Enum.TextXAlignment.Left
            GroupTitle.Parent = GroupFrame
            
            local GroupContainer = Instance.new("Frame")
            GroupContainer.Name = "Container"
            GroupContainer.Size = UDim2.new(1, -10, 0, 0)
            GroupContainer.Position = UDim2.new(0, 5, 0, 28)
            GroupContainer.AutomaticSize = Enum.AutomaticSize.Y
            GroupContainer.BackgroundTransparency = 1
            GroupContainer.Parent = GroupFrame
            
            local GroupLayout = Instance.new("UIListLayout")
            GroupLayout.SortOrder = Enum.SortOrder.LayoutOrder
            GroupLayout.Padding = UDim.new(0, 5)
            GroupLayout.Parent = GroupContainer
            
            local GroupPadding = Instance.new("UIPadding")
            GroupPadding.PaddingBottom = UDim.new(0, 8)
            GroupPadding.Parent = GroupContainer
            
            groupbox.Frame = GroupFrame
            groupbox.Container = GroupContainer
            
            function groupbox:AddToggle(idx, config)
                config = config or {}
                local toggle = {Value = config.Default or false}
                
                local ToggleFrame = Instance.new("Frame")
                ToggleFrame.Size = UDim2.new(1, 0, 0, 20)
                ToggleFrame.BackgroundTransparency = 1
                ToggleFrame.Parent = self.Container
                
                local ToggleButton = Instance.new("TextButton")
                ToggleButton.Size = UDim2.new(0, 36, 0, 16)
                ToggleButton.Position = UDim2.new(0, 0, 0, 2)
                ToggleButton.BackgroundColor3 = toggle.Value and Color3.fromRGB(50, 130, 230) or Color3.fromRGB(50, 50, 55)
                ToggleButton.BorderSizePixel = 0
                ToggleButton.Text = ""
                ToggleButton.Parent = ToggleFrame
                
                local ToggleCorner = Instance.new("UICorner")
                ToggleCorner.CornerRadius = UDim.new(1, 0)
                ToggleCorner.Parent = ToggleButton
                
                local ToggleIndicator = Instance.new("Frame")
                ToggleIndicator.Size = UDim2.new(0, 12, 0, 12)
                ToggleIndicator.Position = toggle.Value and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)
                ToggleIndicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                ToggleIndicator.BorderSizePixel = 0
                ToggleIndicator.Parent = ToggleButton
                
                local IndicatorCorner = Instance.new("UICorner")
                IndicatorCorner.CornerRadius = UDim.new(1, 0)
                IndicatorCorner.Parent = ToggleIndicator
                
                local ToggleLabel = Instance.new("TextLabel")
                ToggleLabel.Size = UDim2.new(1, -45, 1, 0)
                ToggleLabel.Position = UDim2.new(0, 42, 0, 0)
                ToggleLabel.BackgroundTransparency = 1
                ToggleLabel.Text = config.Text or "Toggle"
                ToggleLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
                ToggleLabel.TextSize = 12
                ToggleLabel.Font = Enum.Font.Gotham
                ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
                ToggleLabel.Parent = ToggleFrame
                
                function toggle:SetValue(value)
                    self.Value = value
                    Tween(ToggleButton, {BackgroundColor3 = value and Color3.fromRGB(50, 130, 230) or Color3.fromRGB(50, 50, 55)})
                    Tween(ToggleIndicator, {Position = value and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)})
                    
                    if self.Changed then
                        self.Changed(value)
                    end
                    if config.Callback then
                        config.Callback(value)
                    end
                end
                
                function toggle:OnChanged(func)
                    self.Changed = func
                end
                
                ToggleButton.MouseButton1Click:Connect(function()
                    toggle:SetValue(not toggle.Value)
                end)
                
                Toggles[idx] = toggle
                return toggle
            end
            
            function groupbox:AddButton(config)
                config = config or {}
                local button = {}
                
                local ButtonFrame = Instance.new("TextButton")
                ButtonFrame.Size = UDim2.new(1, 0, 0, 25)
                ButtonFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
                ButtonFrame.BorderSizePixel = 0
                ButtonFrame.Text = config.Text or "Button"
                ButtonFrame.TextColor3 = Color3.fromRGB(220, 220, 220)
                ButtonFrame.TextSize = 12
                ButtonFrame.Font = Enum.Font.Gotham
                ButtonFrame.Parent = self.Container
                
                local ButtonCorner = Instance.new("UICorner")
                ButtonCorner.CornerRadius = UDim.new(0, 4)
                ButtonCorner.Parent = ButtonFrame
                
                local clickCount = 0
                local lastClick = 0
                
                ButtonFrame.MouseButton1Click:Connect(function()
                    if config.DoubleClick then
                        clickCount = clickCount + 1
                        local currentTime = tick()
                        
                        if clickCount == 1 then
                            lastClick = currentTime
                            task.delay(0.5, function()
                                if tick() - lastClick >= 0.5 then
                                    clickCount = 0
                                end
                            end)
                        elseif clickCount == 2 and (currentTime - lastClick) < 0.5 then
                            clickCount = 0
                            if config.Func then
                                config.Func()
                            end
                        end
                    else
                        if config.Func then
                            config.Func()
                        end
                    end
                    
                    Tween(ButtonFrame, {BackgroundColor3 = Color3.fromRGB(50, 50, 55)})
                    task.wait(0.1)
                    Tween(ButtonFrame, {BackgroundColor3 = Color3.fromRGB(40, 40, 45)})
                end)
                
                function button:AddButton(subConfig)
                    return groupbox:AddButton(subConfig)
                end
                
                return button
            end
            
            function groupbox:AddLabel(text, wrap)
                local LabelFrame = Instance.new("TextLabel")
                LabelFrame.Size = wrap and UDim2.new(1, 0, 0, 0) or UDim2.new(1, 0, 0, 15)
                LabelFrame.AutomaticSize = wrap and Enum.AutomaticSize.Y or Enum.AutomaticSize.None
                LabelFrame.BackgroundTransparency = 1
                LabelFrame.Text = text
                LabelFrame.TextColor3 = Color3.fromRGB(200, 200, 200)
                LabelFrame.TextSize = 12
                LabelFrame.Font = Enum.Font.Gotham
                LabelFrame.TextXAlignment = Enum.TextXAlignment.Left
                LabelFrame.TextYAlignment = Enum.TextYAlignment.Top
                LabelFrame.TextWrapped = wrap or false
                LabelFrame.Parent = self.Container
                
                return LabelFrame
            end
            
            function groupbox:AddDivider()
                local Divider = Instance.new("Frame")
                Divider.Size = UDim2.new(1, 0, 0, 1)
                Divider.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
                Divider.BorderSizePixel = 0
                Divider.Parent = self.Container
            end
            
            function groupbox:AddSlider(idx, config)
                config = config or {}
                local slider = {Value = config.Default or 0}
                
                local SliderFrame = Instance.new("Frame")
                SliderFrame.Size = UDim2.new(1, 0, 0, 35)
                SliderFrame.BackgroundTransparency = 1
                SliderFrame.Parent = self.Container
                
                local SliderLabel = Instance.new("TextLabel")
                SliderLabel.Size = UDim2.new(1, -40, 0, 15)
                SliderLabel.BackgroundTransparency = 1
                SliderLabel.Text = config.Text or "Slider"
                SliderLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
                SliderLabel.TextSize = 12
                SliderLabel.Font = Enum.Font.Gotham
                SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
                SliderLabel.Parent = SliderFrame
                
                local ValueLabel = Instance.new("TextLabel")
                ValueLabel.Size = UDim2.new(0, 40, 0, 15)
                ValueLabel.Position = UDim2.new(1, -40, 0, 0)
                ValueLabel.BackgroundTransparency = 1
                ValueLabel.Text = tostring(slider.Value)
                ValueLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
                ValueLabel.TextSize = 11
                ValueLabel.Font = Enum.Font.Gotham
                ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
                ValueLabel.Parent = SliderFrame
                
                local SliderBack = Instance.new("Frame")
                SliderBack.Size = UDim2.new(1, 0, 0, 6)
                SliderBack.Position = UDim2.new(0, 0, 0, 20)
                SliderBack.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
                SliderBack.BorderSizePixel = 0
                SliderBack.Parent = SliderFrame
                
                local SliderBackCorner = Instance.new("UICorner")
                SliderBackCorner.CornerRadius = UDim.new(1, 0)
                SliderBackCorner.Parent = SliderBack
                
                local SliderFill = Instance.new("Frame")
                SliderFill.Size = UDim2.new(0, 0, 1, 0)
                SliderFill.BackgroundColor3 = Color3.fromRGB(50, 130, 230)
                SliderFill.BorderSizePixel = 0
                SliderFill.Parent = SliderBack
                
                local SliderFillCorner = Instance.new("UICorner")
                SliderFillCorner.CornerRadius = UDim.new(1, 0)
                SliderFillCorner.Parent = SliderFill
                
                local dragging = false
                
                function slider:SetValue(value)
                    value = math.clamp(value, config.Min, config.Max)
                    if config.Rounding then
                        value = math.floor(value * (10 ^ config.Rounding) + 0.5) / (10 ^ config.Rounding)
                    end
                    
                    self.Value = value
                    local percent = (value - config.Min) / (config.Max - config.Min)
                    SliderFill.Size = UDim2.new(percent, 0, 1, 0)
                    ValueLabel.Text = tostring(value) .. (config.Suffix or "")
                    
                    if self.Changed then
                        self.Changed(value)
                    end
                    if config.Callback then
                        config.Callback(value)
                    end
                end
                
                function slider:OnChanged(func)
                    self.Changed = func
                end
                
                local function updateSlider(input)
                    local pos = (input.Position.X - SliderBack.AbsolutePosition.X) / SliderBack.AbsoluteSize.X
                    pos = math.clamp(pos, 0, 1)
                    local value = config.Min + (config.Max - config.Min) * pos
                    slider:SetValue(value)
                end
                
                SliderBack.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = true
                        updateSlider(input)
                    end
                end)
                
                SliderBack.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = false
                    end
                end)
                
                UserInputService.InputChanged:Connect(function(input)
                    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                        updateSlider(input)
                    end
                end)
                
                slider:SetValue(slider.Value)
                Options[idx] = slider
                return slider
            end
            
            function groupbox:AddInput(idx, config)
                config = config or {}
                local input = {Value = config.Default or ""}
                
                local InputFrame = Instance.new("Frame")
                InputFrame.Size = UDim2.new(1, 0, 0, 45)
                InputFrame.BackgroundTransparency = 1
                InputFrame.Parent = self.Container
                
                local InputLabel = Instance.new("TextLabel")
                InputLabel.Size = UDim2.new(1, 0, 0, 15)
                InputLabel.BackgroundTransparency = 1
                InputLabel.Text = config.Text or "Input"
                InputLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
                InputLabel.TextSize = 12
                InputLabel.Font = Enum.Font.Gotham
                InputLabel.TextXAlignment = Enum.TextXAlignment.Left
                InputLabel.Parent = InputFrame
                
                local InputBox = Instance.new("TextBox")
                InputBox.Size = UDim2.new(1, 0, 0, 25)
                InputBox.Position = UDim2.new(0, 0, 0, 18)
                InputBox.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
                InputBox.BorderSizePixel = 0
                InputBox.Text = input.Value
                InputBox.PlaceholderText = config.Placeholder or ""
                InputBox.TextColor3 = Color3.fromRGB(220, 220, 220)
                InputBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
                InputBox.TextSize = 12
                InputBox.Font = Enum.Font.Gotham
                InputBox.ClearTextOnFocus = false
                InputBox.Parent = InputFrame
                
                local InputCorner = Instance.new("UICorner")
                InputCorner.CornerRadius = UDim.new(0, 4)
                InputCorner.Parent = InputBox
                
                local InputPadding = Instance.new("UIPadding")
                InputPadding.PaddingLeft = UDim.new(0, 8)
                InputPadding.PaddingRight = UDim.new(0, 8)
                InputPadding.Parent = InputBox
                
                function input:SetValue(value)
                    self.Value = value
                    InputBox.Text = value
                    
                    if self.Changed then
                        self.Changed(value)
                    end
                    if config.Callback then
                        config.Callback(value)
                    end
                end
                
                function input:OnChanged(func)
                    self.Changed = func
                end
                
                if config.Finished then
                    InputBox.FocusLost:Connect(function(enter)
                        if enter then
                            input:SetValue(InputBox.Text)
                        end
                    end)
                else
                    InputBox:GetPropertyChangedSignal("Text"):Connect(function()
                        input:SetValue(InputBox.Text)
                    end)
                end
                
                Options[idx] = input
                return input
            end
            
            function groupbox:AddDropdown(idx, config)
                config = config or {}
                local dropdown = {
                    Value = config.Multi and {} or (config.Values[config.Default] or config.Default or ""),
                    Values = config.Values or {}
                }
                
                local DropdownFrame = Instance.new("Frame")
                DropdownFrame.Size = UDim2.new(1, 0, 0, 45)
                DropdownFrame.BackgroundTransparency = 1
                DropdownFrame.Parent = self.Container
                
                local DropdownLabel = Instance.new("TextLabel")
                DropdownLabel.Size = UDim2.new(1, 0, 0, 15)
                DropdownLabel.BackgroundTransparency = 1
                DropdownLabel.Text = config.Text or "Dropdown"
                DropdownLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
                DropdownLabel.TextSize = 12
                DropdownLabel.Font = Enum.Font.Gotham
                DropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
                DropdownLabel.Parent = DropdownFrame
                
                local DropdownButton = Instance.new("TextButton")
                DropdownButton.Size = UDim2.new(1, 0, 0, 25)
                DropdownButton.Position = UDim2.new(0, 0, 0, 18)
                DropdownButton.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
                DropdownButton.BorderSizePixel = 0
                DropdownButton.Text = "  " .. (config.Multi and "Multi-Select" or tostring(dropdown.Value))
                DropdownButton.TextColor3 = Color3.fromRGB(220, 220, 220)
                DropdownButton.TextSize = 12
                DropdownButton.Font = Enum.Font.Gotham
                DropdownButton.TextXAlignment = Enum.TextXAlignment.Left
                DropdownButton.Parent = DropdownFrame
                
                local DropdownCorner = Instance.new("UICorner")
                DropdownCorner.CornerRadius = UDim.new(0, 4)
                DropdownCorner.Parent = DropdownButton
                
                local DropdownList = Instance.new("Frame")
                DropdownList.Size = UDim2.new(1, 0, 0, 0)
                DropdownList.Position = UDim2.new(0, 0, 0, 45)
                DropdownList.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
                DropdownList.BorderSizePixel = 0
                DropdownList.Visible = false
                DropdownList.ZIndex = 10
                DropdownList.Parent = DropdownFrame
                
                local ListCorner = Instance.new("UICorner")
                ListCorner.CornerRadius = UDim.new(0, 4)
                ListCorner.Parent = DropdownList
                
                local ListLayout = Instance.new("UIListLayout")
                ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
                ListLayout.Parent = DropdownList
                
                local function updateDropdown()
                    for _, child in pairs(DropdownList:GetChildren()) do
                        if child:IsA("TextButton") then
                            child:Destroy()
                        end
                    end
                    
                    for _, value in pairs(dropdown.Values) do
                        local OptionButton = Instance.new("TextButton")
                        OptionButton.Size = UDim2.new(1, 0, 0, 25)
                        OptionButton.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
                        OptionButton.BorderSizePixel = 0
                        OptionButton.Text = "  " .. tostring(value)
                        OptionButton.TextColor3 = Color3.fromRGB(200, 200, 200)
                        OptionButton.TextSize = 11
                        OptionButton.Font = Enum.Font.Gotham
                        OptionButton.TextXAlignment = Enum.TextXAlignment.Left
                        OptionButton.Parent = DropdownList
                        
                        if config.Multi then
                            if dropdown.Value[value] then
                                OptionButton.BackgroundColor3 = Color3.fromRGB(50, 130, 230)
                            end
                        end
                        
                        OptionButton.MouseButton1Click:Connect(function()
                            if config.Multi then
                                dropdown.Value[value] = not dropdown.Value[value]
                                OptionButton.BackgroundColor3 = dropdown.Value[value] and Color3.fromRGB(50, 130, 230) or Color3.fromRGB(40, 40, 45)
                                
                                if dropdown.Changed then
                                    dropdown.Changed(dropdown.Value)
                                end
                                if config.Callback then
                                    config.Callback(dropdown.Value)
                                end
                            else
                                dropdown.Value = value
                                DropdownButton.Text = "  " .. tostring(value)
                                DropdownList.Visible = false
                                
                                if dropdown.Changed then
                                    dropdown.Changed(value)
                                end
                                if config.Callback then
                                    config.Callback(value)
                                end
                            end
                        end)
                    end
                    
                    DropdownList.Size = UDim2.new(1, 0, 0, math.min(#dropdown.Values * 25, 150))
                end
                
                function dropdown:SetValue(value)
                    if config.Multi then
                        self.Value = value
                        updateDropdown()
                    else
                        self.Value = value
                        DropdownButton.Text = "  " .. tostring(value)
                    end
                    
                    if self.Changed then
                        self.Changed(value)
                    end
                    if config.Callback then
                        config.Callback(value)
                    end
                end
                
                function dropdown:OnChanged(func)
                    self.Changed = func
                end
                
                DropdownButton.MouseButton1Click:Connect(function()
                    DropdownList.Visible = not DropdownList.Visible
                    if DropdownList.Visible then
                        updateDropdown()
                    end
                end)
                
                if config.Multi then
                    for _, value in pairs(dropdown.Values) do
                        dropdown.Value[value] = false
                    end
                end
                
                Options[idx] = dropdown
                return dropdown
            end
            
            return groupbox
        end
        
        function tab:CreateTabbox(parent)
            local tabbox = {}
            tabbox.Tabs = {}
            
            local TabboxFrame = Instance.new("Frame")
            TabboxFrame.Size = UDim2.new(1, 0, 0, 0)
            TabboxFrame.AutomaticSize = Enum.AutomaticSize.Y
            TabboxFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
            TabboxFrame.BorderSizePixel = 0
            TabboxFrame.Parent = parent
            
            local TabboxCorner = Instance.new("UICorner")
            TabboxCorner.CornerRadius = UDim.new(0, 4)
            TabboxCorner.Parent = TabboxFrame
            
            local TabboxButtons = Instance.new("Frame")
            TabboxButtons.Size = UDim2.new(1, 0, 0, 30)
            TabboxButtons.BackgroundTransparency = 1
            TabboxButtons.Parent = TabboxFrame
            
            local ButtonLayout = Instance.new("UIListLayout")
            ButtonLayout.FillDirection = Enum.FillDirection.Horizontal
            ButtonLayout.SortOrder = Enum.SortOrder.LayoutOrder
            ButtonLayout.Padding = UDim.new(0, 3)
            ButtonLayout.Parent = TabboxButtons
            
            local ButtonPadding = Instance.new("UIPadding")
            ButtonPadding.PaddingLeft = UDim.new(0, 5)
            ButtonPadding.PaddingTop = UDim.new(0, 5)
            ButtonPadding.Parent = TabboxButtons
            
            local TabboxContent = Instance.new("Frame")
            TabboxContent.Size = UDim2.new(1, -10, 0, 0)
            TabboxContent.Position = UDim2.new(0, 5, 0, 35)
            TabboxContent.AutomaticSize = Enum.AutomaticSize.Y
            TabboxContent.BackgroundTransparency = 1
            TabboxContent.Parent = TabboxFrame
            
            function tabbox:AddTab(name)
                local subtab = {}
                local tabIndex = #self.Tabs + 1
                
                local TabButton = Instance.new("TextButton")
                TabButton.Size = UDim2.new(0, 70, 0, 22)
                TabButton.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
                TabButton.BorderSizePixel = 0
                TabButton.Text = name
                TabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
                TabButton.TextSize = 11
                TabButton.Font = Enum.Font.Gotham
                TabButton.Parent = TabboxButtons
                
                local TabButtonCorner = Instance.new("UICorner")
                TabButtonCorner.CornerRadius = UDim.new(0, 3)
                TabButtonCorner.Parent = TabButton
                
                local TabContent = Instance.new("Frame")
                TabContent.Size = UDim2.new(1, 0, 0, 0)
                TabContent.AutomaticSize = Enum.AutomaticSize.Y
                TabContent.BackgroundTransparency = 1
                TabContent.Visible = tabIndex == 1
                TabContent.Parent = TabboxContent
                
                local TabLayout = Instance.new("UIListLayout")
                TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
                TabLayout.Padding = UDim.new(0, 5)
                TabLayout.Parent = TabContent
                
                local TabPadding = Instance.new("UIPadding")
                TabPadding.PaddingBottom = UDim.new(0, 5)
                TabPadding.Parent = TabContent
                
                TabButton.MouseButton1Click:Connect(function()
                    for _, t in pairs(tabbox.Tabs) do
                        t.Content.Visible = false
                        t.Button.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
                        t.Button.TextColor3 = Color3.fromRGB(200, 200, 200)
                    end
                    TabContent.Visible = true
                    TabButton.BackgroundColor3 = Color3.fromRGB(50, 130, 230)
                    TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                end)
                
                if tabIndex == 1 then
                    TabButton.BackgroundColor3 = Color3.fromRGB(50, 130, 230)
                    TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                end
                
                subtab.Button = TabButton
                subtab.Content = TabContent
                subtab.Container = TabContent
                
                -- Add all groupbox methods to subtab
                subtab.AddToggle = tab.CreateGroupbox({Container = TabContent}).AddToggle
                subtab.AddButton = tab.CreateGroupbox({Container = TabContent}).AddButton
                subtab.AddLabel = tab.CreateGroupbox({Container = TabContent}).AddLabel
                subtab.AddDivider = tab.CreateGroupbox({Container = TabContent}).AddDivider
                subtab.AddSlider = tab.CreateGroupbox({Container = TabContent}).AddSlider
                subtab.AddInput = tab.CreateGroupbox({Container = TabContent}).AddInput
                subtab.AddDropdown = tab.CreateGroupbox({Container = TabContent}).AddDropdown
                
                table.insert(tabbox.Tabs, subtab)
                return subtab
            end
            
            return tabbox
        end
        
        table.insert(self.Tabs, tab)
        self.Tabs[name] = tab
        return tab
    end
    
    function window:SetWatermarkVisibility(visible)
        -- Watermark functionality
    end
    
    function window:SetWatermark(text)
        -- Watermark text update
    end
    
    function window:OnUnload(func)
        self.UnloadCallback = func
    end
    
    function window:Unload()
        self.Unloaded = true
        if self.UnloadCallback then
            self.UnloadCallback()
        end
        self.ScreenGui:Destroy()
    end
    
    setmetatable(window, Library)
    return window
end

return Library
