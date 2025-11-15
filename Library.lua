-- Modern UI Library with Gradients & Animations
local Library = {}
Library.__index = Library

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

-- Tables
getgenv().Toggles = getgenv().Toggles or {}
getgenv().Options = getgenv().Options or {}

-- Config Storage
local ConfigFolder = "UILibConfigs"
local Configs = {}

-- Theme Colors
local Theme = {
    Primary = Color3.fromRGB(100, 180, 255),
    Background = Color3.fromRGB(25, 25, 30),
    Secondary = Color3.fromRGB(35, 35, 40),
    Tertiary = Color3.fromRGB(45, 45, 50),
    Text = Color3.fromRGB(255, 255, 255),
    TextDark = Color3.fromRGB(150, 150, 150),
    Accent = Color3.fromRGB(80, 160, 240)
}

-- Utility Functions
local function Tween(instance, properties, duration, style, direction)
    local tweenInfo = TweenInfo.new(
        duration or 0.3,
        style or Enum.EasingStyle.Quad,
        direction or Enum.EasingDirection.Out
    )
    local tween = TweenService:Create(instance, tweenInfo, properties)
    tween:Play()
    return tween
end

local function MakeDraggable(frame)
    local dragging, dragInput, mousePos, framePos
    
    frame.InputBegan:Connect(function(input)
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
    
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - mousePos
            Tween(frame, {
                Position = UDim2.new(
                    framePos.X.Scale,
                    framePos.X.Offset + delta.X,
                    framePos.Y.Scale,
                    framePos.Y.Offset + delta.Y
                )
            }, 0.1)
        end
    end)
end

-- Create Window
function Library:CreateWindow(config)
    config = config or {}
    local window = {
        Tabs = {},
        Sections = {},
        Unloaded = false,
        SearchActive = false,
        CurrentTheme = Theme
    }
    
    -- ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "ModernUILib"
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = game:GetService("CoreGui")
    
    -- Main Frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 520, 0, 380)
    MainFrame.Position = UDim2.new(0.5, -260, 0.5, -190)
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui
    
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 10)
    MainCorner.Parent = MainFrame
    
    -- Glow Effect
    local Glow = Instance.new("ImageLabel")
    Glow.Name = "Glow"
    Glow.Size = UDim2.new(1, 40, 1, 40)
    Glow.Position = UDim2.new(0, -20, 0, -20)
    Glow.BackgroundTransparency = 1
    Glow.Image = "rbxassetid://5028857084"
    Glow.ImageColor3 = Theme.Primary
    Glow.ImageTransparency = 0.7
    Glow.ScaleType = Enum.ScaleType.Slice
    Glow.SliceCenter = Rect.new(24, 24, 276, 276)
    Glow.Parent = MainFrame
    
    MakeDraggable(MainFrame)
    
    -- Header
    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.Size = UDim2.new(1, 0, 0, 55)
    Header.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    Header.BorderSizePixel = 0
    Header.Parent = MainFrame
    
    local HeaderCorner = Instance.new("UICorner")
    HeaderCorner.CornerRadius = UDim.new(0, 10)
    HeaderCorner.Parent = Header
    
    local HeaderCover = Instance.new("Frame")
    HeaderCover.Size = UDim2.new(1, 0, 0, 10)
    HeaderCover.Position = UDim2.new(0, 0, 1, -10)
    HeaderCover.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    HeaderCover.BorderSizePixel = 0
    HeaderCover.Parent = Header
    
    -- User Info
    local UserAvatar = Instance.new("ImageLabel")
    UserAvatar.Size = UDim2.new(0, 35, 0, 35)
    UserAvatar.Position = UDim2.new(0, 10, 0, 10)
    UserAvatar.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    UserAvatar.BorderSizePixel = 0
    UserAvatar.Image = Players:GetUserThumbnailAsync(Players.LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
    UserAvatar.Parent = Header
    
    local AvatarCorner = Instance.new("UICorner")
    AvatarCorner.CornerRadius = UDim.new(1, 0)
    AvatarCorner.Parent = UserAvatar
    
    local Username = Instance.new("TextLabel")
    Username.Size = UDim2.new(0, 200, 0, 18)
    Username.Position = UDim2.new(0, 52, 0, 10)
    Username.BackgroundTransparency = 1
    Username.Text = Players.LocalPlayer.Name
    Username.TextColor3 = Color3.fromRGB(255, 255, 255)
    Username.TextSize = 14
    Username.Font = Enum.Font.GothamBold
    Username.TextXAlignment = Enum.TextXAlignment.Left
    Username.Parent = Header
    
    local TimeRemaining = Instance.new("TextLabel")
    TimeRemaining.Size = UDim2.new(0, 200, 0, 15)
    TimeRemaining.Position = UDim2.new(0, 52, 0, 28)
    TimeRemaining.BackgroundTransparency = 1
    TimeRemaining.Text = "Time remaining: ∞"
    TimeRemaining.TextColor3 = Color3.fromRGB(120, 120, 130)
    TimeRemaining.TextSize = 11
    TimeRemaining.Font = Enum.Font.Gotham
    TimeRemaining.TextXAlignment = Enum.TextXAlignment.Left
    TimeRemaining.Parent = Header
    
    -- Tab Icons Container
    local TabIconsContainer = Instance.new("Frame")
    TabIconsContainer.Size = UDim2.new(0, 200, 0, 35)
    TabIconsContainer.Position = UDim2.new(1, -210, 0, 10)
    TabIconsContainer.BackgroundTransparency = 1
    TabIconsContainer.Parent = Header
    
    local IconLayout = Instance.new("UIListLayout")
    IconLayout.FillDirection = Enum.FillDirection.Horizontal
    IconLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    IconLayout.SortOrder = Enum.SortOrder.LayoutOrder
    IconLayout.Padding = UDim.new(0, 8)
    IconLayout.Parent = TabIconsContainer
    
    -- Content Container
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Name = "ContentContainer"
    ContentContainer.Size = UDim2.new(1, -20, 1, -105)
    ContentContainer.Position = UDim2.new(0, 10, 0, 60)
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.ClipsDescendants = true
    ContentContainer.Parent = MainFrame
    
    -- Footer
    local Footer = Instance.new("Frame")
    Footer.Name = "Footer"
    Footer.Size = UDim2.new(1, 0, 0, 40)
    Footer.Position = UDim2.new(0, 0, 1, -40)
    Footer.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    Footer.BorderSizePixel = 0
    Footer.Parent = MainFrame
    
    local FooterCorner = Instance.new("UICorner")
    FooterCorner.CornerRadius = UDim.new(0, 10)
    FooterCorner.Parent = Footer
    
    local FooterCover = Instance.new("Frame")
    FooterCover.Size = UDim2.new(1, 0, 0, 10)
    FooterCover.Position = UDim2.new(0, 0, 0, 0)
    FooterCover.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    FooterCover.BorderSizePixel = 0
    FooterCover.Parent = Footer
    
    -- Game Name
    local GameName = Instance.new("TextLabel")
    GameName.Size = UDim2.new(0, 200, 1, 0)
    GameName.Position = UDim2.new(0, 10, 0, 0)
    GameName.BackgroundTransparency = 1
    GameName.Text = config.Title or "UI Library"
    GameName.TextColor3 = Color3.fromRGB(255, 255, 255)
    GameName.TextSize = 12
    GameName.Font = Enum.Font.GothamBold
    GameName.TextXAlignment = Enum.TextXAlignment.Left
    GameName.Parent = Footer
    
    local GameDesc = Instance.new("TextLabel")
    GameDesc.Size = UDim2.new(0, 200, 1, 0)
    GameDesc.Position = UDim2.new(0, 10, 0, 0)
    GameDesc.BackgroundTransparency = 1
    GameDesc.Text = config.Description or "v1.0.0"
    GameDesc.TextColor3 = Color3.fromRGB(100, 100, 110)
    GameDesc.TextSize = 10
    GameDesc.Font = Enum.Font.Gotham
    GameDesc.TextXAlignment = Enum.TextXAlignment.Left
    GameDesc.TextYAlignment = Enum.TextYAlignment.Bottom
    GameDesc.Parent = Footer
    
    -- Search Button
    local SearchBtn = Instance.new("ImageButton")
    SearchBtn.Size = UDim2.new(0, 30, 0, 30)
    SearchBtn.Position = UDim2.new(1, -70, 0.5, -15)
    SearchBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    SearchBtn.BorderSizePixel = 0
    SearchBtn.Image = "rbxassetid://6031154871"
    SearchBtn.ImageColor3 = Color3.fromRGB(150, 150, 150)
    SearchBtn.Parent = Footer
    
    local SearchCorner = Instance.new("UICorner")
    SearchCorner.CornerRadius = UDim.new(0, 6)
    SearchCorner.Parent = SearchBtn
    
    -- Settings Button
    local SettingsBtn = Instance.new("ImageButton")
    SettingsBtn.Size = UDim2.new(0, 30, 0, 30)
    SettingsBtn.Position = UDim2.new(1, -35, 0.5, -15)
    SettingsBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    SettingsBtn.BorderSizePixel = 0
    SettingsBtn.Image = "rbxassetid://6031154871"
    SettingsBtn.ImageColor3 = Color3.fromRGB(150, 150, 150)
    SettingsBtn.Parent = Footer
    
    local SettingsCorner = Instance.new("UICorner")
    SettingsCorner.CornerRadius = UDim.new(0, 6)
    SettingsCorner.Parent = SettingsBtn
    
    -- Search Frame (Hidden by default)
    local SearchFrame = Instance.new("Frame")
    SearchFrame.Name = "SearchFrame"
    SearchFrame.Size = UDim2.new(1, -20, 0, 35)
    SearchFrame.Position = UDim2.new(0, 10, 0, -45)
    SearchFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    SearchFrame.BorderSizePixel = 0
    SearchFrame.Visible = false
    SearchFrame.Parent = ContentContainer
    
    local SearchFrameCorner = Instance.new("UICorner")
    SearchFrameCorner.CornerRadius = UDim.new(0, 6)
    SearchFrameCorner.Parent = SearchFrame
    
    local SearchBox = Instance.new("TextBox")
    SearchBox.Size = UDim2.new(1, -40, 1, -8)
    SearchBox.Position = UDim2.new(0, 35, 0, 4)
    SearchBox.BackgroundTransparency = 1
    SearchBox.PlaceholderText = "Search..."
    SearchBox.PlaceholderColor3 = Color3.fromRGB(100, 100, 110)
    SearchBox.Text = ""
    SearchBox.TextColor3 = Color3.fromRGB(200, 200, 200)
    SearchBox.TextSize = 12
    SearchBox.Font = Enum.Font.Gotham
    SearchBox.TextXAlignment = Enum.TextXAlignment.Left
    SearchBox.Parent = SearchFrame
    
    local SearchIcon = Instance.new("ImageLabel")
    SearchIcon.Size = UDim2.new(0, 18, 0, 18)
    SearchIcon.Position = UDim2.new(0, 10, 0.5, -9)
    SearchIcon.BackgroundTransparency = 1
    SearchIcon.Image = "rbxassetid://6031154871"
    SearchIcon.ImageColor3 = Color3.fromRGB(120, 120, 130)
    SearchIcon.Parent = SearchFrame
    
    SearchBtn.MouseButton1Click:Connect(function()
        window.SearchActive = not window.SearchActive
        SearchFrame.Visible = window.SearchActive
        
        if window.SearchActive then
            Tween(SearchFrame, {Position = UDim2.new(0, 10, 0, 0)}, 0.3, Enum.EasingStyle.Back)
            SearchBox:CaptureFocus()
        else
            Tween(SearchFrame, {Position = UDim2.new(0, 10, 0, -45)}, 0.3)
            SearchBox.Text = ""
            -- Reset all element visibility
            for _, tab in pairs(window.Tabs) do
                if tab.Content then
                    for _, child in pairs(tab.Content:GetDescendants()) do
                        if child:IsA("Frame") and child.Name:find("Element") then
                            child.Visible = true
                        end
                    end
                end
            end
        end
    end)
    
    -- Search functionality
    SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
        local query = SearchBox.Text:lower()
        for _, tab in pairs(window.Tabs) do
            if tab.Content then
                for _, child in pairs(tab.Content:GetDescendants()) do
                    if child:IsA("TextLabel") and child.Parent.Name:find("Element") then
                        local text = child.Text:lower()
                        child.Parent.Visible = text:find(query) ~= nil or query == ""
                    end
                end
            end
        end
    end)
    
    -- Settings Panel
    local SettingsPanel = Instance.new("Frame")
    SettingsPanel.Name = "SettingsPanel"
    SettingsPanel.Size = UDim2.new(0, 280, 0, 320)
    SettingsPanel.Position = UDim2.new(0.5, -140, 0.5, -160)
    SettingsPanel.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    SettingsPanel.BorderSizePixel = 0
    SettingsPanel.Visible = false
    SettingsPanel.ZIndex = 100
    SettingsPanel.Parent = ScreenGui
    
    local SettingsPanelCorner = Instance.new("UICorner")
    SettingsPanelCorner.CornerRadius = UDim.new(0, 10)
    SettingsPanelCorner.Parent = SettingsPanel
    
    local SettingsPanelGlow = Instance.new("ImageLabel")
    SettingsPanelGlow.Size = UDim2.new(1, 40, 1, 40)
    SettingsPanelGlow.Position = UDim2.new(0, -20, 0, -20)
    SettingsPanelGlow.BackgroundTransparency = 1
    SettingsPanelGlow.Image = "rbxassetid://5028857084"
    SettingsPanelGlow.ImageColor3 = Theme.Primary
    SettingsPanelGlow.ImageTransparency = 0.6
    SettingsPanelGlow.ScaleType = Enum.ScaleType.Slice
    SettingsPanelGlow.SliceCenter = Rect.new(24, 24, 276, 276)
    SettingsPanelGlow.Parent = SettingsPanel
    
    local SettingsTitle = Instance.new("TextLabel")
    SettingsTitle.Size = UDim2.new(1, -20, 0, 30)
    SettingsTitle.Position = UDim2.new(0, 10, 0, 10)
    SettingsTitle.BackgroundTransparency = 1
    SettingsTitle.Text = "UI Settings"
    SettingsTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    SettingsTitle.TextSize = 16
    SettingsTitle.Font = Enum.Font.GothamBold
    SettingsTitle.TextXAlignment = Enum.TextXAlignment.Left
    SettingsTitle.Parent = SettingsPanel
    
    local CloseSettings = Instance.new("TextButton")
    CloseSettings.Size = UDim2.new(0, 30, 0, 30)
    CloseSettings.Position = UDim2.new(1, -40, 0, 10)
    CloseSettings.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    CloseSettings.BorderSizePixel = 0
    CloseSettings.Text = "×"
    CloseSettings.TextColor3 = Color3.fromRGB(200, 200, 200)
    CloseSettings.TextSize = 20
    CloseSettings.Font = Enum.Font.GothamBold
    CloseSettings.Parent = SettingsPanel
    
    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 6)
    CloseCorner.Parent = CloseSettings
    
    CloseSettings.MouseButton1Click:Connect(function()
        Tween(SettingsPanel, {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0)}, 0.3)
        task.wait(0.3)
        SettingsPanel.Visible = false
        SettingsPanel.Size = UDim2.new(0, 280, 0, 320)
        SettingsPanel.Position = UDim2.new(0.5, -140, 0.5, -160)
    end)
    
    -- Color Picker in Settings
    local ColorPickerLabel = Instance.new("TextLabel")
    ColorPickerLabel.Size = UDim2.new(1, -20, 0, 20)
    ColorPickerLabel.Position = UDim2.new(0, 10, 0, 50)
    ColorPickerLabel.BackgroundTransparency = 1
    ColorPickerLabel.Text = "Primary Color"
    ColorPickerLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    ColorPickerLabel.TextSize = 13
    ColorPickerLabel.Font = Enum.Font.Gotham
    ColorPickerLabel.TextXAlignment = Enum.TextXAlignment.Left
    ColorPickerLabel.Parent = SettingsPanel
    
    local ColorPreview = Instance.new("Frame")
    ColorPreview.Size = UDim2.new(1, -20, 0, 30)
    ColorPreview.Position = UDim2.new(0, 10, 0, 75)
    ColorPreview.BackgroundColor3 = Theme.Primary
    ColorPreview.BorderSizePixel = 0
    ColorPreview.Parent = SettingsPanel
    
    local ColorPreviewCorner = Instance.new("UICorner")
    ColorPreviewCorner.CornerRadius = UDim.new(0, 6)
    ColorPreviewCorner.Parent = ColorPreview
    
    local ColorGradient = Instance.new("UIGradient")
    ColorGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Theme.Primary),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(
            math.clamp(Theme.Primary.R * 255 + 40, 0, 255),
            math.clamp(Theme.Primary.G * 255 + 40, 0, 255),
            math.clamp(Theme.Primary.B * 255 + 40, 0, 255)
        ))
    }
    ColorGradient.Parent = ColorPreview
    
    SettingsBtn.MouseButton1Click:Connect(function()
        SettingsPanel.Visible = true
        SettingsPanel.Size = UDim2.new(0, 0, 0, 0)
        SettingsPanel.Position = UDim2.new(0.5, 0, 0.5, 0)
        Tween(SettingsPanel, {Size = UDim2.new(0, 280, 0, 320), Position = UDim2.new(0.5, -140, 0.5, -160)}, 0.3, Enum.EasingStyle.Back)
    end)
    
    window.ScreenGui = ScreenGui
    window.MainFrame = MainFrame
    window.ContentContainer = ContentContainer
    window.TabIconsContainer = TabIconsContainer
    window.SettingsPanel = SettingsPanel
    
    function window:AddTab(name, iconId)
        local tab = {}
        local tabIndex = #self.Tabs + 1
        
        -- Tab Icon Button
        local TabIcon = Instance.new("ImageButton")
        TabIcon.Name = name
        TabIcon.Size = UDim2.new(0, 35, 0, 35)
        TabIcon.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
        TabIcon.BorderSizePixel = 0
        TabIcon.Image = iconId and "rbxassetid://" .. tostring(iconId) or ""
        TabIcon.ImageColor3 = Color3.fromRGB(120, 120, 130)
        TabIcon.LayoutOrder = tabIndex
        TabIcon.Parent = TabIconsContainer
        
        local TabIconCorner = Instance.new("UICorner")
        TabIconCorner.CornerRadius = UDim.new(0, 8)
        TabIconCorner.Parent = TabIcon
        
        local TabGradient = Instance.new("UIGradient")
        TabGradient.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 35)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(35, 35, 40))
        }
        TabGradient.Rotation = 45
        TabGradient.Parent = TabIcon
        
        -- Tab Content (Two Columns)
        local TabContent = Instance.new("Frame")
        TabContent.Name = name .. "Content"
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        TabContent.BackgroundTransparency = 1
        TabContent.Visible = tabIndex == 1
        TabContent.Parent = ContentContainer
        
        -- Left Column
        local LeftColumn = Instance.new("ScrollingFrame")
        LeftColumn.Name = "LeftColumn"
        LeftColumn.Size = UDim2.new(0.48, 0, 1, 0)
        LeftColumn.Position = UDim2.new(0, 0, 0, 0)
        LeftColumn.BackgroundTransparency = 1
        LeftColumn.BorderSizePixel = 0
        LeftColumn.ScrollBarThickness = 4
        LeftColumn.ScrollBarImageColor3 = Color3.fromRGB(60, 60, 70)
        LeftColumn.CanvasSize = UDim2.new(0, 0, 0, 0)
        LeftColumn.Parent = TabContent
        
        local LeftLayout = Instance.new("UIListLayout")
        LeftLayout.SortOrder = Enum.SortOrder.LayoutOrder
        LeftLayout.Padding = UDim.new(0, 12)
        LeftLayout.Parent = LeftColumn
        
        LeftLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            LeftColumn.CanvasSize = UDim2.new(0, 0, 0, LeftLayout.AbsoluteContentSize.Y + 10)
        end)
        
        -- Right Column
        local RightColumn = Instance.new("ScrollingFrame")
        RightColumn.Name = "RightColumn"
        RightColumn.Size = UDim2.new(0.48, 0, 1, 0)
        RightColumn.Position = UDim2.new(0.52, 0, 0, 0)
        RightColumn.BackgroundTransparency = 1
        RightColumn.BorderSizePixel = 0
        RightColumn.ScrollBarThickness = 4
        RightColumn.ScrollBarImageColor3 = Color3.fromRGB(60, 60, 70)
        RightColumn.CanvasSize = UDim2.new(0, 0, 0, 0)
        RightColumn.Parent = TabContent
        
        local RightLayout = Instance.new("UIListLayout")
        RightLayout.SortOrder = Enum.SortOrder.LayoutOrder
        RightLayout.Padding = UDim.new(0, 12)
        RightLayout.Parent = RightColumn
        
        RightLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            RightColumn.CanvasSize = UDim2.new(0, 0, 0, RightLayout.AbsoluteContentSize.Y + 10)
        end)
        
        TabIcon.MouseButton1Click:Connect(function()
            for _, t in pairs(self.Tabs) do
                t.Content.Visible = false
                t.Icon.ImageColor3 = Color3.fromRGB(120, 120, 130)
                t.Icon.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
                
                -- Fade out animation
                Tween(t.Content, {Position = UDim2.new(0, -20, 0, 0)}, 0.2)
                task.wait(0.05)
            end
            
            -- Fade in animation
            TabContent.Position = UDim2.new(0, 20, 0, 0)
            TabContent.Visible = true
            Tween(TabContent, {Position = UDim2.new(0, 0, 0, 0)}, 0.3, Enum.EasingStyle.Back)
            
            Tween(TabIcon, {ImageColor3 = Color3.fromRGB(255, 255, 255)}, 0.2)
            Tween(TabIcon, {BackgroundColor3 = Theme.Primary}, 0.2)
        end)
        
        if tabIndex == 1 then
            TabIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)
            TabIcon.BackgroundColor3 = Theme.Primary
        end
        
        tab.Icon = TabIcon
        tab.Content = TabContent
        tab.LeftColumn = LeftColumn
        tab.RightColumn = RightColumn
        
        function tab:AddSection(name, side)
            local section = {}
            local parent = side == "right" and self.RightColumn or self.LeftColumn
            
            -- Section Container
            local SectionFrame = Instance.new("Frame")
            SectionFrame.Name = name .. "Section"
            SectionFrame.Size = UDim2.new(1, 0, 0, 0)
            SectionFrame.AutomaticSize = Enum.AutomaticSize.Y
            SectionFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
            SectionFrame.BorderSizePixel = 0
            SectionFrame.Parent = parent
            
            local SectionCorner = Instance.new("UICorner")
            SectionCorner.CornerRadius = UDim.new(0, 8)
            SectionCorner.Parent = SectionFrame
            
            -- Section Gradient
            local SectionGradient = Instance.new("UIGradient")
            SectionGradient.Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 25, 30)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 30, 35))
            }
            SectionGradient.Rotation = 90
            SectionGradient.Parent = SectionFrame
            
            -- Section Header
            local SectionHeader = Instance.new("Frame")
            SectionHeader.Size = UDim2.new(1, 0, 0, 35)
            SectionHeader.BackgroundTransparency = 1
            SectionHeader.Parent = SectionFrame
            
            local SectionIcon = Instance.new("ImageLabel")
            SectionIcon.Size = UDim2.new(0, 18, 0, 18)
            SectionIcon.Position = UDim2.new(0, 12, 0, 8)
            SectionIcon.BackgroundTransparency = 1
            SectionIcon.Image = "rbxassetid://6031302931"
            SectionIcon.ImageColor3 = Theme.Primary
            SectionIcon.Parent = SectionHeader
            
            local SectionTitle = Instance.new("TextLabel")
            SectionTitle.Size = UDim2.new(1, -40, 1, 0)
            SectionTitle.Position = UDim2.new(0, 35, 0, 0)
            SectionTitle.BackgroundTransparency = 1
            SectionTitle.Text = name
            SectionTitle.TextColor3 = Color3.fromRGB(200, 200, 210)
            SectionTitle.TextSize = 13
            SectionTitle.Font = Enum.Font.GothamBold
            SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
            SectionTitle.Parent = SectionHeader
            
            -- Elements Container
            local ElementsContainer = Instance.new("Frame")
            ElementsContainer.Name = "ElementsContainer"
            ElementsContainer.Size = UDim2.new(1, -20, 0, 0)
            ElementsContainer.Position = UDim2.new(0, 10, 0, 35)
            ElementsContainer.AutomaticSize = Enum.AutomaticSize.Y
            ElementsContainer.BackgroundTransparency = 1
            ElementsContainer.Parent = SectionFrame
            
            local ElementsLayout = Instance.new("UIListLayout")
            ElementsLayout.SortOrder = Enum.SortOrder.LayoutOrder
            ElementsLayout.Padding = UDim.new(0, 8)
            ElementsLayout.Parent = ElementsContainer
            
            local ElementsPadding = Instance.new("UIPadding")
            ElementsPadding.PaddingBottom = UDim.new(0, 10)
            ElementsPadding.Parent = ElementsContainer
            
            section.Container = ElementsContainer
            section.Frame = SectionFrame
            
            function section:AddToggle(idx, config)
                config = config or {}
                local toggle = {Value = config.Default or false}
                
                local ToggleFrame = Instance.new("Frame")
                ToggleFrame.Name = "ToggleElement"
                ToggleFrame.Size = UDim2.new(1, 0, 0, 22)
                ToggleFrame.BackgroundTransparency = 1
                ToggleFrame.Parent = self.Container
                
                -- Checkbox
                local Checkbox = Instance.new("TextButton")
                Checkbox.Size = UDim2.new(0, 18, 0, 18)
                Checkbox.Position = UDim2.new(0, 0, 0, 2)
                Checkbox.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
                Checkbox.BorderSizePixel = 0
                Checkbox.Text = ""
                Checkbox.AutoButtonColor = false
                Checkbox.Parent = ToggleFrame
                
                local CheckboxCorner = Instance.new("UICorner")
                CheckboxCorner.CornerRadius = UDim.new(0, 4)
                CheckboxCorner.Parent = Checkbox
                
                local CheckboxStroke = Instance.new("UIStroke")
                CheckboxStroke.Color = Color3.fromRGB(50, 50, 55)
                CheckboxStroke.Thickness = 1
                CheckboxStroke.Parent = Checkbox
                
                -- Checkmark (using TextLabel with checkmark symbol)
                local Checkmark = Instance.new("TextLabel")
                Checkmark.Size = UDim2.new(1, 0, 1, 0)
                Checkmark.BackgroundTransparency = 1
                Checkmark.Text = "✓"
                Checkmark.TextColor3 = Theme.Primary
                Checkmark.TextSize = 14
                Checkmark.Font = Enum.Font.GothamBold
                Checkmark.Visible = toggle.Value
                Checkmark.Parent = Checkbox
                
                local ToggleLabel = Instance.new("TextLabel")
                ToggleLabel.Size = UDim2.new(1, -25, 1, 0)
                ToggleLabel.Position = UDim2.new(0, 25, 0, 0)
                ToggleLabel.BackgroundTransparency = 1
                ToggleLabel.Text = config.Text or "Toggle"
                ToggleLabel.TextColor3 = Color3.fromRGB(180, 180, 190)
                ToggleLabel.TextSize = 12
                ToggleLabel.Font = Enum.Font.Gotham
                ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
                ToggleLabel.Parent = ToggleFrame
                
                function toggle:SetValue(value)
                    self.Value = value
                    
                    if value then
                        Checkmark.Visible = true
                        Tween(Checkbox, {BackgroundColor3 = Theme.Primary}, 0.2)
                        Tween(CheckboxStroke, {Color = Theme.Primary}, 0.2)
                        Tween(Checkmark, {TextTransparency = 0}, 0.2)
                    else
                        Tween(Checkmark, {TextTransparency = 1}, 0.2)
                        task.wait(0.2)
                        Checkmark.Visible = false
                        Tween(Checkbox, {BackgroundColor3 = Color3.fromRGB(35, 35, 40)}, 0.2)
                        Tween(CheckboxStroke, {Color = Color3.fromRGB(50, 50, 55)}, 0.2)
                    end
                    
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
                    
                    -- Button press animation
                    Tween(Checkbox, {Size = UDim2.new(0, 16, 0, 16)}, 0.1)
                    task.wait(0.1)
                    Tween(Checkbox, {Size = UDim2.new(0, 18, 0, 18)}, 0.1)
                end)
                
                Toggles[idx] = toggle
                return toggle
            end
            
            function section:AddSlider(idx, config)
                config = config or {}
                local slider = {Value = config.Default or 0}
                
                local SliderFrame = Instance.new("Frame")
                SliderFrame.Name = "SliderElement"
                SliderFrame.Size = UDim2.new(1, 0, 0, 42)
                SliderFrame.BackgroundTransparency = 1
                SliderFrame.Parent = self.Container
                
                local SliderLabel = Instance.new("TextLabel")
                SliderLabel.Size = UDim2.new(1, -45, 0, 18)
                SliderLabel.BackgroundTransparency = 1
                SliderLabel.Text = config.Text or "Slider"
                SliderLabel.TextColor3 = Color3.fromRGB(180, 180, 190)
                SliderLabel.TextSize = 12
                SliderLabel.Font = Enum.Font.Gotham
                SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
                SliderLabel.Parent = SliderFrame
                
                local ValueLabel = Instance.new("TextLabel")
                ValueLabel.Size = UDim2.new(0, 45, 0, 18)
                ValueLabel.Position = UDim2.new(1, -45, 0, 0)
                ValueLabel.BackgroundTransparency = 1
                ValueLabel.Text = tostring(slider.Value) .. (config.Suffix or "%")
                ValueLabel.TextColor3 = Theme.Primary
                ValueLabel.TextSize = 12
                ValueLabel.Font = Enum.Font.GothamBold
                ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
                ValueLabel.Parent = SliderFrame
                
                local SliderBack = Instance.new("Frame")
                SliderBack.Size = UDim2.new(1, 0, 0, 6)
                SliderBack.Position = UDim2.new(0, 0, 0, 26)
                SliderBack.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
                SliderBack.BorderSizePixel = 0
                SliderBack.Parent = SliderFrame
                
                local SliderBackCorner = Instance.new("UICorner")
                SliderBackCorner.CornerRadius = UDim.new(1, 0)
                SliderBackCorner.Parent = SliderBack
                
                local SliderFill = Instance.new("Frame")
                SliderFill.Size = UDim2.new(0, 0, 1, 0)
                SliderFill.BackgroundColor3 = Theme.Primary
                SliderFill.BorderSizePixel = 0
                SliderFill.Parent = SliderBack
                
                local SliderFillCorner = Instance.new("UICorner")
                SliderFillCorner.CornerRadius = UDim.new(1, 0)
                SliderFillCorner.Parent = SliderFill
                
                local SliderGradient = Instance.new("UIGradient")
                SliderGradient.Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, Theme.Primary),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(
                        math.clamp(Theme.Primary.R * 255 + 30, 0, 255),
                        math.clamp(Theme.Primary.G * 255 + 30, 0, 255),
                        math.clamp(Theme.Primary.B * 255 + 30, 0, 255)
                    ))
                }
                SliderGradient.Parent = SliderFill
                
                local SliderDot = Instance.new("Frame")
                SliderDot.Size = UDim2.new(0, 12, 0, 12)
                SliderDot.Position = UDim2.new(0, -6, 0.5, -6)
                SliderDot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                SliderDot.BorderSizePixel = 0
                SliderDot.Parent = SliderFill
                
                local DotCorner = Instance.new("UICorner")
                DotCorner.CornerRadius = UDim.new(1, 0)
                DotCorner.Parent = SliderDot
                
                local DotGlow = Instance.new("ImageLabel")
                DotGlow.Size = UDim2.new(2, 0, 2, 0)
                DotGlow.Position = UDim2.new(-0.5, 0, -0.5, 0)
                DotGlow.BackgroundTransparency = 1
                DotGlow.Image = "rbxassetid://5028857084"
                DotGlow.ImageColor3 = Theme.Primary
                DotGlow.ImageTransparency = 0.5
                DotGlow.ScaleType = Enum.ScaleType.Slice
                DotGlow.SliceCenter = Rect.new(24, 24, 276, 276)
                DotGlow.Parent = SliderDot
                
                local dragging = false
                
                function slider:SetValue(value)
                    value = math.clamp(value, config.Min, config.Max)
                    if config.Rounding then
                        value = math.floor(value * (10 ^ config.Rounding) + 0.5) / (10 ^ config.Rounding)
                    else
                        value = math.floor(value)
                    end
                    
                    self.Value = value
                    local percent = (value - config.Min) / (config.Max - config.Min)
                    
                    Tween(SliderFill, {Size = UDim2.new(percent, 0, 1, 0)}, 0.1)
                    ValueLabel.Text = tostring(value) .. (config.Suffix or "%")
                    
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
                        Tween(SliderDot, {Size = UDim2.new(0, 16, 0, 16)}, 0.2)
                    end
                end)
                
                SliderBack.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = false
                        Tween(SliderDot, {Size = UDim2.new(0, 12, 0, 12)}, 0.2)
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
                ButtonFrame.Name = "ButtonElement"
                ButtonFrame.Size = UDim2.new(1, 0, 0, 30)
                ButtonFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
                ButtonFrame.BorderSizePixel = 0
                ButtonFrame.Text = config.Text or "Button"
                ButtonFrame.TextColor3 = Color3.fromRGB(180, 180, 190)
                ButtonFrame.TextSize = 12
                ButtonFrame.Font = Enum.Font.Gotham
                ButtonFrame.AutoButtonColor = false
                ButtonFrame.Parent = self.Container
                
                local ButtonCorner = Instance.new("UICorner")
                ButtonCorner.CornerRadius = UDim.new(0, 6)
                ButtonCorner.Parent = ButtonFrame
                
                local ButtonGradient = Instance.new("UIGradient")
                ButtonGradient.Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(35, 35, 40)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 40, 45))
                }
                ButtonGradient.Rotation = 90
                ButtonGradient.Parent = ButtonFrame
                
                ButtonFrame.MouseButton1Click:Connect(function()
                    if config.Func then
                        config.Func()
                    end
                    
                    Tween(ButtonFrame, {BackgroundColor3 = Theme.Primary}, 0.1)
                    Tween(ButtonFrame, {TextColor3 = Color3.fromRGB(255, 255, 255)}, 0.1)
                    task.wait(0.2)
                    Tween(ButtonFrame, {BackgroundColor3 = Color3.fromRGB(35, 35, 40)}, 0.2)
                    Tween(ButtonFrame, {TextColor3 = Color3.fromRGB(180, 180, 190)}, 0.2)
                end)
                
                ButtonFrame.MouseEnter:Connect(function()
                    Tween(ButtonFrame, {BackgroundColor3 = Color3.fromRGB(45, 45, 50)}, 0.2)
                end)
                
                ButtonFrame.MouseLeave:Connect(function()
                    Tween(ButtonFrame, {BackgroundColor3 = Color3.fromRGB(35, 35, 40)}, 0.2)
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
                DropdownFrame.Name = "DropdownElement"
                DropdownFrame.Size = UDim2.new(1, 0, 0, 48)
                DropdownFrame.BackgroundTransparency = 1
                DropdownFrame.Parent = self.Container
                
                local DropdownLabel = Instance.new("TextLabel")
                DropdownLabel.Size = UDim2.new(1, 0, 0, 18)
                DropdownLabel.BackgroundTransparency = 1
                DropdownLabel.Text = config.Text or "Dropdown"
                DropdownLabel.TextColor3 = Color3.fromRGB(180, 180, 190)
                DropdownLabel.TextSize = 12
                DropdownLabel.Font = Enum.Font.Gotham
                DropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
                DropdownLabel.Parent = DropdownFrame
                
                local DropdownButton = Instance.new("TextButton")
                DropdownButton.Size = UDim2.new(1, 0, 0, 28)
                DropdownButton.Position = UDim2.new(0, 0, 0, 22)
                DropdownButton.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
                DropdownButton.BorderSizePixel = 0
                DropdownButton.Text = ""
                DropdownButton.AutoButtonColor = false
                DropdownButton.Parent = DropdownFrame
                
                local DropdownCorner = Instance.new("UICorner")
                DropdownCorner.CornerRadius = UDim.new(0, 6)
                DropdownCorner.Parent = DropdownButton
                
                local DropdownText = Instance.new("TextLabel")
                DropdownText.Size = UDim2.new(1, -30, 1, 0)
                DropdownText.Position = UDim2.new(0, 10, 0, 0)
                DropdownText.BackgroundTransparency = 1
                DropdownText.Text = config.Multi and "Select..." or tostring(dropdown.Value)
                DropdownText.TextColor3 = Color3.fromRGB(160, 160, 170)
                DropdownText.TextSize = 11
                DropdownText.Font = Enum.Font.Gotham
                DropdownText.TextXAlignment = Enum.TextXAlignment.Left
                DropdownText.TextTruncate = Enum.TextTruncate.AtEnd
                DropdownText.Parent = DropdownButton
                
                local DropdownArrow = Instance.new("TextLabel")
                DropdownArrow.Size = UDim2.new(0, 20, 1, 0)
                DropdownArrow.Position = UDim2.new(1, -25, 0, 0)
                DropdownArrow.BackgroundTransparency = 1
                DropdownArrow.Text = "▼"
                DropdownArrow.TextColor3 = Color3.fromRGB(120, 120, 130)
                DropdownArrow.TextSize = 10
                DropdownArrow.Font = Enum.Font.Gotham
                DropdownArrow.Parent = DropdownButton
                
                local DropdownList = Instance.new("ScrollingFrame")
                DropdownList.Size = UDim2.new(1, 0, 0, 0)
                DropdownList.Position = UDim2.new(0, 0, 0, 52)
                DropdownList.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
                DropdownList.BorderSizePixel = 0
                DropdownList.Visible = false
                DropdownList.ScrollBarThickness = 4
                DropdownList.ScrollBarImageColor3 = Color3.fromRGB(60, 60, 70)
                DropdownList.CanvasSize = UDim2.new(0, 0, 0, 0)
                DropdownList.ZIndex = 10
                DropdownList.Parent = DropdownFrame
                
                local ListCorner = Instance.new("UICorner")
                ListCorner.CornerRadius = UDim.new(0, 6)
                ListCorner.Parent = DropdownList
                
                local ListLayout = Instance.new("UIListLayout")
                ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
                ListLayout.Padding = UDim.new(0, 2)
                ListLayout.Parent = DropdownList
                
                ListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                    DropdownList.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y)
                end)
                
                local function updateDropdown()
                    for _, child in pairs(DropdownList:GetChildren()) do
                        if child:IsA("TextButton") then
                            child:Destroy()
                        end
                    end
                    
                    for _, value in pairs(dropdown.Values) do
                        local OptionButton = Instance.new("TextButton")
                        OptionButton.Size = UDim2.new(1, -4, 0, 26)
                        OptionButton.Position = UDim2.new(0, 2, 0, 0)
                        OptionButton.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
                        OptionButton.BorderSizePixel = 0
                        OptionButton.Text = "  " .. tostring(value)
                        OptionButton.TextColor3 = Color3.fromRGB(160, 160, 170)
                        OptionButton.TextSize = 11
                        OptionButton.Font = Enum.Font.Gotham
                        OptionButton.TextXAlignment = Enum.TextXAlignment.Left
                        OptionButton.AutoButtonColor = false
                        OptionButton.Parent = DropdownList
                        
                        local OptionCorner = Instance.new("UICorner")
                        OptionCorner.CornerRadius = UDim.new(0, 4)
                        OptionCorner.Parent = OptionButton
                        
                        if config.Multi then
                            if dropdown.Value[value] then
                                OptionButton.BackgroundColor3 = Theme.Primary
                                OptionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                            end
                        end
                        
                        OptionButton.MouseEnter:Connect(function()
                            if not (config.Multi and dropdown.Value[value]) then
                                Tween(OptionButton, {BackgroundColor3 = Color3.fromRGB(45, 45, 50)}, 0.1)
                            end
                        end)
                        
                        OptionButton.MouseLeave:Connect(function()
                            if not (config.Multi and dropdown.Value[value]) then
                                Tween(OptionButton, {BackgroundColor3 = Color3.fromRGB(35, 35, 40)}, 0.1)
                            end
                        end)
                        
                        OptionButton.MouseButton1Click:Connect(function()
                            if config.Multi then
                                dropdown.Value[value] = not dropdown.Value[value]
                                
                                if dropdown.Value[value] then
                                    Tween(OptionButton, {BackgroundColor3 = Theme.Primary}, 0.2)
                                    Tween(OptionButton, {TextColor3 = Color3.fromRGB(255, 255, 255)}, 0.2)
                                else
                                    Tween(OptionButton, {BackgroundColor3 = Color3.fromRGB(35, 35, 40)}, 0.2)
                                    Tween(OptionButton, {TextColor3 = Color3.fromRGB(160, 160, 170)}, 0.2)
                                end
                                
                                if dropdown.Changed then
                                    dropdown.Changed(dropdown.Value)
                                end
                                if config.Callback then
                                    config.Callback(dropdown.Value)
                                end
                            else
                                dropdown.Value = value
                                DropdownText.Text = tostring(value)
                                
                                Tween(DropdownList, {Size = UDim2.new(1, 0, 0, 0)}, 0.2)
                                task.wait(0.2)
                                DropdownList.Visible = false
                                Tween(DropdownArrow, {Rotation = 0}, 0.2)
                                
                                if dropdown.Changed then
                                    dropdown.Changed(value)
                                end
                                if config.Callback then
                                    config.Callback(value)
                                end
                            end
                        end)
                    end
                    
                    local listHeight = math.min(#dropdown.Values * 28, 120)
                    Tween(DropdownList, {Size = UDim2.new(1, 0, 0, listHeight)}, 0.2, Enum.EasingStyle.Back)
                end
                
                function dropdown:SetValue(value)
                    if config.Multi then
                        self.Value = value
                        updateDropdown()
                    else
                        self.Value = value
                        DropdownText.Text = tostring(value)
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
                        Tween(DropdownArrow, {Rotation = 180}, 0.2)
                    else
                        Tween(DropdownList, {Size = UDim2.new(1, 0, 0, 0)}, 0.2)
                        task.wait(0.2)
                        Tween(DropdownArrow, {Rotation = 0}, 0.2)
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
                LabelFrame.Name = "LabelElement"
                LabelFrame.Size = UDim2.new(1, 0, 0, 18)
                LabelFrame.BackgroundTransparency = 1
                LabelFrame.Text = text
                LabelFrame.TextColor3 = Color3.fromRGB(130, 130, 140)
                LabelFrame.TextSize = 11
                LabelFrame.Font = Enum.Font.Gotham
                LabelFrame.TextXAlignment = Enum.TextXAlignment.Left
                LabelFrame.Parent = self.Container
                
                return LabelFrame
            end
            
            function section:AddKeybind(idx, config)
                config = config or {}
                local keybind = {
                    Value = config.Default or "None",
                    Mode = config.Mode or "Toggle"
                }
                
                local KeybindFrame = Instance.new("Frame")
                KeybindFrame.Name = "KeybindElement"
                KeybindFrame.Size = UDim2.new(1, 0, 0, 22)
                KeybindFrame.BackgroundTransparency = 1
                KeybindFrame.Parent = self.Container
                
                local KeybindLabel = Instance.new("TextLabel")
                KeybindLabel.Size = UDim2.new(1, -55, 1, 0)
                KeybindLabel.BackgroundTransparency = 1
                KeybindLabel.Text = config.Text or "Keybind"
                KeybindLabel.TextColor3 = Color3.fromRGB(180, 180, 190)
                KeybindLabel.TextSize = 12
                KeybindLabel.Font = Enum.Font.Gotham
                KeybindLabel.TextXAlignment = Enum.TextXAlignment.Left
                KeybindLabel.Parent = KeybindFrame
                
                local KeybindButton = Instance.new("TextButton")
                KeybindButton.Size = UDim2.new(0, 50, 0, 20)
                KeybindButton.Position = UDim2.new(1, -50, 0, 1)
                KeybindButton.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
                KeybindButton.BorderSizePixel = 0
                KeybindButton.Text = keybind.Value
                KeybindButton.TextColor3 = Theme.Primary
                KeybindButton.TextSize = 10
                KeybindButton.Font = Enum.Font.GothamBold
                KeybindButton.AutoButtonColor = false
                KeybindButton.Parent = KeybindFrame
                
                local KeybindCorner = Instance.new("UICorner")
                KeybindCorner.CornerRadius = UDim.new(0, 4)
                KeybindCorner.Parent = KeybindButton
                
                local listening = false
                
                function keybind:SetValue(value)
                    self.Value = value
                    KeybindButton.Text = value
                    
                    if self.Changed then
                        self.Changed(value)
                    end
                    if config.Callback then
                        config.Callback(value)
                    end
                end
                
                function keybind:OnChanged(func)
                    self.Changed = func
                end
                
                KeybindButton.MouseButton1Click:Connect(function()
                    if listening then return end
                    listening = true
                    KeybindButton.Text = "..."
                    Tween(KeybindButton, {BackgroundColor3 = Theme.Primary}, 0.2)
                    
                    local connection
                    connection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
                        if gameProcessed then return end
                        
                        local keyName = input.KeyCode.Name
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then
                            keyName = "MB1"
                        elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
                            keyName = "MB2"
                        end
                        
                        keybind:SetValue(keyName)
                        listening = false
                        Tween(KeybindButton, {BackgroundColor3 = Color3.fromRGB(35, 35, 40)}, 0.2)
                        connection:Disconnect()
                    end)
                end)
                
                Options[idx] = keybind
                return keybind
            end
            
            function section:AddColorPicker(idx, config)
                config = config or {}
                local colorpicker = {
                    Value = config.Default or Color3.fromRGB(100, 180, 255)
                }
                
                local PickerFrame = Instance.new("Frame")
                PickerFrame.Name = "ColorPickerElement"
                PickerFrame.Size = UDim2.new(1, 0, 0, 22)
                PickerFrame.BackgroundTransparency = 1
                PickerFrame.Parent = self.Container
                
                local PickerLabel = Instance.new("TextLabel")
                PickerLabel.Size = UDim2.new(1, -30, 1, 0)
                PickerLabel.BackgroundTransparency = 1
                PickerLabel.Text = config.Text or "Color"
                PickerLabel.TextColor3 = Color3.fromRGB(180, 180, 190)
                PickerLabel.TextSize = 12
                PickerLabel.Font = Enum.Font.Gotham
                PickerLabel.TextXAlignment = Enum.TextXAlignment.Left
                PickerLabel.Parent = PickerFrame
                
                local ColorDisplay = Instance.new("TextButton")
                ColorDisplay.Size = UDim2.new(0, 24, 0, 20)
                ColorDisplay.Position = UDim2.new(1, -24, 0, 1)
                ColorDisplay.BackgroundColor3 = colorpicker.Value
                ColorDisplay.BorderSizePixel = 0
                ColorDisplay.Text = ""
                ColorDisplay.AutoButtonColor = false
                ColorDisplay.Parent = PickerFrame
                
                local ColorCorner = Instance.new("UICorner")
                ColorCorner.CornerRadius = UDim.new(0, 4)
                ColorCorner.Parent = ColorDisplay
                
                local ColorStroke = Instance.new("UIStroke")
                ColorStroke.Color = Color3.fromRGB(60, 60, 70)
                ColorStroke.Thickness = 1
                ColorStroke.Parent = ColorDisplay
                
                function colorpicker:SetValue(value)
                    self.Value = value
                    ColorDisplay.BackgroundColor3 = value
                    
                    if self.Changed then
                        self.Changed(value)
                    end
                    if config.Callback then
                        config.Callback(value)
                    end
                end
                
                function colorpicker:OnChanged(func)
                    self.Changed = func
                end
                
                ColorDisplay.MouseButton1Click:Connect(function()
                    Tween(ColorDisplay, {Size = UDim2.new(0, 22, 0, 18)}, 0.1)
                    task.wait(0.1)
                    Tween(ColorDisplay, {Size = UDim2.new(0, 24, 0, 20)}, 0.1)
                    -- Color picker UI would open here
                end)
                
                Options[idx] = colorpicker
                return colorpicker
            end
            
            return section
        end
        
        table.insert(self.Tabs, tab)
        self.Tabs[name] = tab
        return tab
    end
    
    -- Config System
    function window:SaveConfig(name)
        local config = {
            Toggles = {},
            Options = {}
        }
        
        for idx, toggle in pairs(Toggles) do
            config.Toggles[idx] = toggle.Value
        end
        
        for idx, option in pairs(Options) do
            if typeof(option.Value) == "Color3" then
                config.Options[idx] = {option.Value.R, option.Value.G, option.Value.B}
            else
                config.Options[idx] = option.Value
            end
        end
        
        Configs[name] = config
        return config
    end
    
    function window:LoadConfig(name)
        local config = Configs[name]
        if not config then return end
        
        for idx, value in pairs(config.Toggles) do
            if Toggles[idx] then
                Toggles[idx]:SetValue(value)
            end
        end
        
        for idx, value in pairs(config.Options) do
            if Options[idx] then
                if type(value) == "table" and #value == 3 then
                    Options[idx]:SetValue(Color3.new(value[1], value[2], value[3]))
                else
                    Options[idx]:SetValue(value)
                end
            end
        end
    end
    
    function window:GetConfigList()
        local list = {}
        for name, _ in pairs(Configs) do
            table.insert(list, name)
        end
        return list
    end
    
    function window:CreateConfigSection(tab)
        local ConfigSection = tab:AddSection("Config System", "left")
        
        local configNameInput
        configNameInput = ConfigSection:AddInput('ConfigName', {
            Default = 'default',
            Text = 'Config Name',
            Placeholder = 'Enter name...',
        })
        
        ConfigSection:AddButton({
            Text = 'Save Config',
            Func = function()
                local name = Options.ConfigName.Value
                if name and name ~= "" then
                    self:SaveConfig(name)
                    print('Config saved: ' .. name)
                end
            end
        })
        
        local configDropdown
        configDropdown = ConfigSection:AddDropdown('ConfigList', {
            Values = self:GetConfigList(),
            Default = 1,
            Multi = false,
            Text = 'Select Config',
        })
        
        ConfigSection:AddButton({
            Text = 'Load Config',
            Func = function()
                local name = Options.ConfigList.Value
                if name and name ~= "" then
                    self:LoadConfig(name)
                    print('Config loaded: ' .. name)
                end
            end
        })
        
        ConfigSection:AddButton({
            Text = 'Refresh List',
            Func = function()
                configDropdown.Values = self:GetConfigList()
            end
        })
    end
    
    function window:Notify(config)
        config = config or {}
        
        local NotifFrame = Instance.new("Frame")
        NotifFrame.Size = UDim2.new(0, 0, 0, 0)
        NotifFrame.Position = UDim2.new(0, 10, 0, 10)
        NotifFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
        NotifFrame.BorderSizePixel = 0
        NotifFrame.Parent = self.ScreenGui
        
        local NotifCorner = Instance.new("UICorner")
        NotifCorner.CornerRadius = UDim.new(0, 8)
        NotifCorner.Parent = NotifFrame
        
        local NotifGlow = Instance.new("ImageLabel")
        NotifGlow.Size = UDim2.new(1, 40, 1, 40)
        NotifGlow.Position = UDim2.new(0, -20, 0, -20)
        NotifGlow.BackgroundTransparency = 1
        NotifGlow.Image = "rbxassetid://5028857084"
        NotifGlow.ImageColor3 = Theme.Primary
        NotifGlow.ImageTransparency = 0.5
        NotifGlow.ScaleType = Enum.ScaleType.Slice
        NotifGlow.SliceCenter = Rect.new(24, 24, 276, 276)
        NotifGlow.Parent = NotifFrame
        
        local NotifIcon = Instance.new("ImageLabel")
        NotifIcon.Size = UDim2.new(0, 20, 0, 20)
        NotifIcon.Position = UDim2.new(0, 10, 0, 10)
        NotifIcon.BackgroundTransparency = 1
        NotifIcon.Image = config.Icon or "rbxassetid://6031302931"
        NotifIcon.ImageColor3 = Theme.Primary
        NotifIcon.Parent = NotifFrame
        
        local NotifTitle = Instance.new("TextLabel")
        NotifTitle.Size = UDim2.new(1, -40, 0, 20)
        NotifTitle.Position = UDim2.new(0, 35, 0, 10)
        NotifTitle.BackgroundTransparency = 1
        NotifTitle.Text = config.Title or "Notification"
        NotifTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
        NotifTitle.TextSize = 13
        NotifTitle.Font = Enum.Font.GothamBold
        NotifTitle.TextXAlignment = Enum.TextXAlignment.Left
        NotifTitle.Parent = NotifFrame
        
        local NotifText = Instance.new("TextLabel")
        NotifText.Size = UDim2.new(1, -40, 0, 18)
        NotifText.Position = UDim2.new(0, 35, 0, 28)
        NotifText.BackgroundTransparency = 1
        NotifText.Text = config.Text or "This is a notification!"
        NotifText.TextColor3 = Color3.fromRGB(180, 180, 190)
        NotifText.TextSize = 11
        NotifText.Font = Enum.Font.Gotham
        NotifText.TextXAlignment = Enum.TextXAlignment.Left
        NotifText.Parent = NotifFrame
        
        Tween(NotifFrame, {Size = UDim2.new(0, 280, 0, 55)}, 0.3, Enum.EasingStyle.Back)
        
        task.delay(config.Duration or 3, function()
            Tween(NotifFrame, {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0, 145, 0, 27.5)}, 0.3)
            task.wait(0.3)
            NotifFrame:Destroy()
        end)
    end
    
    function window:OnUnload(func)
        self.UnloadCallback = func
    end
    
    function window:Unload()
        self.Unloaded = true
        if self.UnloadCallback then
            self.UnloadCallback()
        end
        Tween(self.MainFrame, {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0)}, 0.3)
        task.wait(0.3)
        self.ScreenGui:Destroy()
    end
    
    if config.AutoShow ~= false then
        MainFrame.Size = UDim2.new(0, 0, 0, 0)
        MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
        Tween(MainFrame, {Size = UDim2.new(0, 520, 0, 380), Position = UDim2.new(0.5, -260, 0.5, -190)}, 0.4, Enum.EasingStyle.Back)
    end
    
    setmetatable(window, Library)
    return window
end

return Library
