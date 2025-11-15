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
    local tweenInfo = TweenInfo.new(duration or 0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
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
        Sections = {},
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
    MainFrame.Size = UDim2.new(0, 650, 0, 500)
    MainFrame.Position = config.Center and UDim2.new(0.5, -325, 0.5, -250) or UDim2.new(0.3, 0, 0.2, 0)
    MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui
    
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 8)
    MainCorner.Parent = MainFrame
    
    MakeDraggable(MainFrame)
    
    -- Sidebar (Left Navigation)
    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Size = UDim2.new(0, 160, 1, 0)
    Sidebar.Position = UDim2.new(0, 0, 0, 0)
    Sidebar.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    Sidebar.BorderSizePixel = 0
    Sidebar.Parent = MainFrame
    
    local SidebarCorner = Instance.new("UICorner")
    SidebarCorner.CornerRadius = UDim.new(0, 8)
    SidebarCorner.Parent = Sidebar
    
    -- Fix corner clipping on right side
    local SidebarCover = Instance.new("Frame")
    SidebarCover.Size = UDim2.new(0, 8, 1, 0)
    SidebarCover.Position = UDim2.new(1, -8, 0, 0)
    SidebarCover.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    SidebarCover.BorderSizePixel = 0
    SidebarCover.Parent = Sidebar
    
    -- Title in Sidebar
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -20, 0, 40)
    TitleLabel.Position = UDim2.new(0, 10, 0, 10)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = config.Title or "UI Library"
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.TextSize = 16
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = Sidebar
    
    -- Tab Container in Sidebar
    local TabContainer = Instance.new("ScrollingFrame")
    TabContainer.Name = "TabContainer"
    TabContainer.Size = UDim2.new(1, -10, 1, -60)
    TabContainer.Position = UDim2.new(0, 5, 0, 55)
    TabContainer.BackgroundTransparency = 1
    TabContainer.BorderSizePixel = 0
    TabContainer.ScrollBarThickness = 0
    TabContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabContainer.Parent = Sidebar
    
    local TabLayout = Instance.new("UIListLayout")
    TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabLayout.Padding = UDim.new(0, 5)
    TabLayout.Parent = TabContainer
    
    TabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabContainer.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y + 10)
    end)
    
    -- Content Area (Right Side)
    local ContentFrame = Instance.new("Frame")
    ContentFrame.Name = "ContentFrame"
    ContentFrame.Size = UDim2.new(1, -170, 1, -10)
    ContentFrame.Position = UDim2.new(0, 165, 0, 5)
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.Parent = MainFrame
    
    window.MainFrame = MainFrame
    window.Sidebar = Sidebar
    window.TabContainer = TabContainer
    window.ContentFrame = ContentFrame
    
    if config.AutoShow ~= false then
        MainFrame.Visible = true
    end
    
    function window:AddTab(name, imageId)
        local tab = {}
        local tabIndex = #self.Tabs + 1
        
        -- Tab Button in Sidebar
        local TabButton = Instance.new("TextButton")
        TabButton.Name = name
        TabButton.Size = UDim2.new(1, -10, 0, 35)
        TabButton.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
        TabButton.BorderSizePixel = 0
        TabButton.AutoButtonColor = false
        TabButton.Text = ""
        TabButton.Parent = TabContainer
        
        local TabCorner = Instance.new("UICorner")
        TabCorner.CornerRadius = UDim.new(0, 6)
        TabCorner.Parent = TabButton
        
        -- Tab Icon (if provided)
        if imageId then
            local TabIcon = Instance.new("ImageLabel")
            TabIcon.Size = UDim2.new(0, 20, 0, 20)
            TabIcon.Position = UDim2.new(0, 8, 0.5, -10)
            TabIcon.BackgroundTransparency = 1
            TabIcon.Image = "rbxassetid://" .. tostring(imageId)
            TabIcon.ImageColor3 = Color3.fromRGB(150, 150, 150)
            TabIcon.Parent = TabButton
            
            tab.Icon = TabIcon
        end
        
        -- Tab Label
        local TabLabel = Instance.new("TextLabel")
        TabLabel.Size = UDim2.new(1, imageId and -36 or -16, 1, 0)
        TabLabel.Position = UDim2.new(0, imageId and 32 or 8, 0, 0)
        TabLabel.BackgroundTransparency = 1
        TabLabel.Text = name
        TabLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
        TabLabel.TextSize = 13
        TabLabel.Font = Enum.Font.Gotham
        TabLabel.TextXAlignment = Enum.TextXAlignment.Left
        TabLabel.Parent = TabButton
        
        -- Tab Content
        local TabContent = Instance.new("Frame")
        TabContent.Name = name .. "Content"
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        TabContent.BackgroundTransparency = 1
        TabContent.Visible = tabIndex == 1
        TabContent.Parent = ContentFrame
        
        -- Section Container (for categories)
        local SectionContainer = Instance.new("ScrollingFrame")
        SectionContainer.Name = "SectionContainer"
        SectionContainer.Size = UDim2.new(1, -5, 1, -5)
        SectionContainer.Position = UDim2.new(0, 0, 0, 0)
        SectionContainer.BackgroundTransparency = 1
        SectionContainer.BorderSizePixel = 0
        SectionContainer.ScrollBarThickness = 4
        SectionContainer.ScrollBarImageColor3 = Color3.fromRGB(60, 60, 60)
        SectionContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
        SectionContainer.Parent = TabContent
        
        local SectionLayout = Instance.new("UIListLayout")
        SectionLayout.SortOrder = Enum.SortOrder.LayoutOrder
        SectionLayout.Padding = UDim.new(0, 15)
        SectionLayout.Parent = SectionContainer
        
        SectionLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            SectionContainer.CanvasSize = UDim2.new(0, 0, 0, SectionLayout.AbsoluteContentSize.Y + 20)
        end)
        
        TabButton.MouseButton1Click:Connect(function()
            for _, t in pairs(self.Tabs) do
                t.Content.Visible = false
                t.Button.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
                t.Label.TextColor3 = Color3.fromRGB(150, 150, 150)
                if t.Icon then
                    t.Icon.ImageColor3 = Color3.fromRGB(150, 150, 150)
                end
            end
            TabContent.Visible = true
            TabButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
            TabLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            if tab.Icon then
                tab.Icon.ImageColor3 = Color3.fromRGB(255, 255, 255)
            end
        end)
        
        if tabIndex == 1 then
            TabButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
            TabLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            if tab.Icon then
                tab.Icon.ImageColor3 = Color3.fromRGB(255, 255, 255)
            end
        end
        
        tab.Button = TabButton
        tab.Label = TabLabel
        tab.Content = TabContent
        tab.SectionContainer = SectionContainer
        
        function tab:AddSection(name)
            local section = {}
            
            -- Section Header
            local SectionHeader = Instance.new("TextLabel")
            SectionHeader.Size = UDim2.new(1, 0, 0, 25)
            SectionHeader.BackgroundTransparency = 1
            SectionHeader.Text = name
            SectionHeader.TextColor3 = Color3.fromRGB(255, 255, 255)
            SectionHeader.TextSize = 14
            SectionHeader.Font = Enum.Font.GothamBold
            SectionHeader.TextXAlignment = Enum.TextXAlignment.Left
            SectionHeader.Parent = self.SectionContainer
            
            -- Elements Container
            local ElementsContainer = Instance.new("Frame")
            ElementsContainer.Name = name .. "Elements"
            ElementsContainer.Size = UDim2.new(1, 0, 0, 0)
            ElementsContainer.AutomaticSize = Enum.AutomaticSize.Y
            ElementsContainer.BackgroundTransparency = 1
            ElementsContainer.Parent = self.SectionContainer
            
            local ElementsLayout = Instance.new("UIListLayout")
            ElementsLayout.SortOrder = Enum.SortOrder.LayoutOrder
            ElementsLayout.Padding = UDim.new(0, 8)
            ElementsLayout.Parent = ElementsContainer
            
            section.Header = SectionHeader
            section.Container = ElementsContainer
            
            function section:AddToggle(idx, config)
                config = config or {}
                local toggle = {Value = config.Default or false}
                
                local ToggleFrame = Instance.new("Frame")
                ToggleFrame.Size = UDim2.new(1, 0, 0, 20)
                ToggleFrame.BackgroundTransparency = 1
                ToggleFrame.Parent = self.Container
                
                -- Checkbox
                local Checkbox = Instance.new("TextButton")
                Checkbox.Size = UDim2.new(0, 16, 0, 16)
                Checkbox.Position = UDim2.new(0, 0, 0, 2)
                Checkbox.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
                Checkbox.BorderColor3 = Color3.fromRGB(60, 60, 60)
                Checkbox.BorderSizePixel = 1
                Checkbox.Text = ""
                Checkbox.Parent = ToggleFrame
                
                local CheckboxCorner = Instance.new("UICorner")
                CheckboxCorner.CornerRadius = UDim.new(0, 3)
                CheckboxCorner.Parent = Checkbox
                
                -- Checkmark
                local Checkmark = Instance.new("ImageLabel")
                Checkmark.Size = UDim2.new(1, -4, 1, -4)
                Checkmark.Position = UDim2.new(0, 2, 0, 2)
                Checkmark.BackgroundTransparency = 1
                Checkmark.Image = "rbxassetid://3926305904"
                Checkmark.ImageRectOffset = Vector2.new(312, 4)
                Checkmark.ImageRectSize = Vector2.new(24, 24)
                Checkmark.ImageColor3 = Color3.fromRGB(100, 180, 255)
                Checkmark.Visible = toggle.Value
                Checkmark.Parent = Checkbox
                
                local ToggleLabel = Instance.new("TextLabel")
                ToggleLabel.Size = UDim2.new(1, -25, 1, 0)
                ToggleLabel.Position = UDim2.new(0, 22, 0, 0)
                ToggleLabel.BackgroundTransparency = 1
                ToggleLabel.Text = config.Text or "Toggle"
                ToggleLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
                ToggleLabel.TextSize = 13
                ToggleLabel.Font = Enum.Font.Gotham
                ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
                ToggleLabel.Parent = ToggleFrame
                
                function toggle:SetValue(value)
                    self.Value = value
                    Checkmark.Visible = value
                    Checkbox.BackgroundColor3 = value and Color3.fromRGB(30, 30, 30) or Color3.fromRGB(20, 20, 20)
                    
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
                
                Checkbox.MouseButton1Click:Connect(function()
                    toggle:SetValue(not toggle.Value)
                end)
                
                Toggles[idx] = toggle
                return toggle
            end
            
            function section:AddSlider(idx, config)
                config = config or {}
                local slider = {Value = config.Default or 0}
                
                local SliderFrame = Instance.new("Frame")
                SliderFrame.Size = UDim2.new(1, 0, 0, 40)
                SliderFrame.BackgroundTransparency = 1
                SliderFrame.Parent = self.Container
                
                local SliderLabel = Instance.new("TextLabel")
                SliderLabel.Size = UDim2.new(1, -50, 0, 18)
                SliderLabel.BackgroundTransparency = 1
                SliderLabel.Text = config.Text or "Slider"
                SliderLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
                SliderLabel.TextSize = 13
                SliderLabel.Font = Enum.Font.Gotham
                SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
                SliderLabel.Parent = SliderFrame
                
                local ValueLabel = Instance.new("TextLabel")
                ValueLabel.Size = UDim2.new(0, 45, 0, 18)
                ValueLabel.Position = UDim2.new(1, -45, 0, 0)
                ValueLabel.BackgroundTransparency = 1
                ValueLabel.Text = tostring(slider.Value)
                ValueLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
                ValueLabel.TextSize = 13
                ValueLabel.Font = Enum.Font.Gotham
                ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
                ValueLabel.Parent = SliderFrame
                
                local SliderBack = Instance.new("Frame")
                SliderBack.Size = UDim2.new(1, 0, 0, 4)
                SliderBack.Position = UDim2.new(0, 0, 0, 24)
                SliderBack.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                SliderBack.BorderSizePixel = 0
                SliderBack.Parent = SliderFrame
                
                local SliderBackCorner = Instance.new("UICorner")
                SliderBackCorner.CornerRadius = UDim.new(1, 0)
                SliderBackCorner.Parent = SliderBack
                
                local SliderFill = Instance.new("Frame")
                SliderFill.Size = UDim2.new(0, 0, 1, 0)
                SliderFill.BackgroundColor3 = Color3.fromRGB(100, 180, 255)
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
                    ValueLabel.Text = tostring(value)
                    
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
            
            function section:AddButton(config)
                config = config or {}
                
                local ButtonFrame = Instance.new("TextButton")
                ButtonFrame.Size = UDim2.new(1, 0, 0, 28)
                ButtonFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
                ButtonFrame.BorderSizePixel = 0
                ButtonFrame.Text = config.Text or "Button"
                ButtonFrame.TextColor3 = Color3.fromRGB(200, 200, 200)
                ButtonFrame.TextSize = 13
                ButtonFrame.Font = Enum.Font.Gotham
                ButtonFrame.Parent = self.Container
                
                local ButtonCorner = Instance.new("UICorner")
                ButtonCorner.CornerRadius = UDim.new(0, 5)
                ButtonCorner.Parent = ButtonFrame
                
                ButtonFrame.MouseButton1Click:Connect(function()
                    if config.Func then
                        config.Func()
                    end
                    
                    Tween(ButtonFrame, {BackgroundColor3 = Color3.fromRGB(35, 35, 35)})
                    task.wait(0.1)
                    Tween(ButtonFrame, {BackgroundColor3 = Color3.fromRGB(25, 25, 25)})
                end)
                
                return ButtonFrame
            end
            
            function section:AddDropdown(idx, config)
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
                DropdownLabel.Size = UDim2.new(1, 0, 0, 18)
                DropdownLabel.BackgroundTransparency = 1
                DropdownLabel.Text = config.Text or "Dropdown"
                DropdownLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
                DropdownLabel.TextSize = 13
                DropdownLabel.Font = Enum.Font.Gotham
                DropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
                DropdownLabel.Parent = DropdownFrame
                
                local DropdownButton = Instance.new("TextButton")
                DropdownButton.Size = UDim2.new(1, 0, 0, 26)
                DropdownButton.Position = UDim2.new(0, 0, 0, 20)
                DropdownButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
                DropdownButton.BorderSizePixel = 0
                DropdownButton.Text = "  " .. (config.Multi and "Select..." or tostring(dropdown.Value))
                DropdownButton.TextColor3 = Color3.fromRGB(180, 180, 180)
                DropdownButton.TextSize = 12
                DropdownButton.Font = Enum.Font.Gotham
                DropdownButton.TextXAlignment = Enum.TextXAlignment.Left
                DropdownButton.Parent = DropdownFrame
                
                local DropdownCorner = Instance.new("UICorner")
                DropdownCorner.CornerRadius = UDim.new(0, 5)
                DropdownCorner.Parent = DropdownButton
                
                local DropdownList = Instance.new("Frame")
                DropdownList.Size = UDim2.new(1, 0, 0, 0)
                DropdownList.Position = UDim2.new(0, 0, 0, 48)
                DropdownList.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
                DropdownList.BorderSizePixel = 0
                DropdownList.Visible = false
                DropdownList.ZIndex = 10
                DropdownList.Parent = DropdownFrame
                
                local ListCorner = Instance.new("UICorner")
                ListCorner.CornerRadius = UDim.new(0, 5)
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
                        OptionButton.Size = UDim2.new(1, 0, 0, 24)
                        OptionButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
                        OptionButton.BorderSizePixel = 0
                        OptionButton.Text = "  " .. tostring(value)
                        OptionButton.TextColor3 = Color3.fromRGB(180, 180, 180)
                        OptionButton.TextSize = 12
                        OptionButton.Font = Enum.Font.Gotham
                        OptionButton.TextXAlignment = Enum.TextXAlignment.Left
                        OptionButton.Parent = DropdownList
                        
                        if config.Multi then
                            if dropdown.Value[value] then
                                OptionButton.BackgroundColor3 = Color3.fromRGB(100, 180, 255)
                                OptionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                            end
                        end
                        
                        OptionButton.MouseButton1Click:Connect(function()
                            if config.Multi then
                                dropdown.Value[value] = not dropdown.Value[value]
                                OptionButton.BackgroundColor3 = dropdown.Value[value] and Color3.fromRGB(100, 180, 255) or Color3.fromRGB(25, 25, 25)
                                OptionButton.TextColor3 = dropdown.Value[value] and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(180, 180, 180)
                                
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
                    
                    DropdownList.Size = UDim2.new(1, 0, 0, math.min(#dropdown.Values * 24, 150))
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
            
            function section:AddLabel(text)
                local LabelFrame = Instance.new("TextLabel")
                LabelFrame.Size = UDim2.new(1, 0, 0, 18)
                LabelFrame.BackgroundTransparency = 1
                LabelFrame.Text = text
                LabelFrame.TextColor3 = Color3.fromRGB(150, 150, 150)
                LabelFrame.TextSize = 13
                LabelFrame.Font = Enum.Font.Gotham
                LabelFrame.TextXAlignment = Enum.TextXAlignment.Left
                LabelFrame.Parent = self.Container
                
                return LabelFrame
            end
            
            function section:AddInput(idx, config)
                config = config or {}
                local input = {Value = config.Default or ""}
                
                local InputFrame = Instance.new("Frame")
                InputFrame.Size = UDim2.new(1, 0, 0, 45)
                InputFrame.BackgroundTransparency = 1
                InputFrame.Parent = self.Container
                
                local InputLabel = Instance.new("TextLabel")
                InputLabel.Size = UDim2.new(1, 0, 0, 18)
                InputLabel.BackgroundTransparency = 1
                InputLabel.Text = config.Text or "Input"
                InputLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
                InputLabel.TextSize = 13
                InputLabel.Font = Enum.Font.Gotham
                InputLabel.TextXAlignment = Enum.TextXAlignment.Left
                InputLabel.Parent = InputFrame
                
                local InputBox = Instance.new("TextBox")
                InputBox.Size = UDim2.new(1, 0, 0, 26)
                InputBox.Position = UDim2.new(0, 0, 0, 20)
                InputBox.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
                InputBox.BorderSizePixel = 0
                InputBox.Text = input.Value
                InputBox.PlaceholderText = config.Placeholder or ""
                InputBox.TextColor3 = Color3.fromRGB(200, 200, 200)
                InputBox.PlaceholderColor3 = Color3.fromRGB(100, 100, 100)
                InputBox.TextSize = 12
                InputBox.Font = Enum.Font.Gotham
                InputBox.ClearTextOnFocus = false
                InputBox.Parent = InputFrame
                
                local InputCorner = Instance.new("UICorner")
                InputCorner.CornerRadius = UDim.new(0, 5)
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
            
            return section
        end
        
        table.insert(self.Tabs, tab)
        self.Tabs[name] = tab
        return tab
    end
    
    function window:SetWatermarkVisibility(visible)
        -- Watermark functionality can be added here
    end
    
    function window:SetWatermark(text)
        -- Watermark text update can be added here
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
