-- Modern UI Library
-- Inspired by Linoria with enhanced visuals

local Library = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")

-- Global tables
getgenv().Toggles = {}
getgenv().Options = {}

-- Configuration
local Config = {
    DefaultTheme = {
        Primary = Color3.fromRGB(45, 45, 50),
        Secondary = Color3.fromRGB(35, 35, 40),
        Accent = Color3.fromRGB(120, 80, 255),
        Text = Color3.fromRGB(255, 255, 255),
        TextDark = Color3.fromRGB(180, 180, 180),
        Border = Color3.fromRGB(60, 60, 65),
        Success = Color3.fromRGB(80, 200, 120),
        Warning = Color3.fromRGB(255, 180, 0),
        Error = Color3.fromRGB(255, 80, 80)
    },
    TweenSpeed = 0.2,
    TweenStyle = Enum.EasingStyle.Quad
}

Library.Theme = Config.DefaultTheme
Library.Unloaded = false
Library.TweenStyle = Config.TweenStyle

-- Utility Functions
local function Create(className, properties)
    local instance = Instance.new(className)
    for prop, value in pairs(properties) do
        if prop ~= "Parent" then
            instance[prop] = value
        end
    end
    if properties.Parent then
        instance.Parent = properties.Parent
    end
    return instance
end

local function Tween(instance, properties, duration, style, direction)
    duration = duration or Config.TweenSpeed
    style = style or Library.TweenStyle
    direction = direction or Enum.EasingDirection.Out
    
    local tween = TweenService:Create(instance, TweenInfo.new(duration, style, direction), properties)
    tween:Play()
    return tween
end

local function AddGradient(parent, colors, rotation)
    colors = colors or {
        ColorSequenceKeypoint.new(0, Library.Theme.Accent),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(Library.Theme.Accent.R * 255 * 0.7, Library.Theme.Accent.G * 255 * 0.7, Library.Theme.Accent.B * 255 * 0.7))
    }
    
    return Create("UIGradient", {
        Color = ColorSequence.new(colors),
        Rotation = rotation or 0,
        Parent = parent
    })
end

local function AddGlow(parent, size, color)
    size = size or 15
    color = color or Library.Theme.Accent
    
    local glow = Create("ImageLabel", {
        Name = "Glow",
        BackgroundTransparency = 1,
        Image = "rbxassetid://5028857472",
        ImageColor3 = color,
        ImageTransparency = 0.7,
        Size = UDim2.new(1, size * 2, 1, size * 2),
        Position = UDim2.new(0, -size, 0, -size),
        ZIndex = parent.ZIndex - 1,
        Parent = parent
    })
    
    return glow
end

-- Notification System
Library.Notifications = {}

function Library:Notify(options)
    options = options or {}
    local text = options.Text or "Notification"
    local duration = options.Duration or 3
    local type = options.Type or "Info" -- Info, Success, Warning, Error
    
    local notifGui = Library.NotificationContainer
    if not notifGui then return end
    
    local colors = {
        Info = Library.Theme.Accent,
        Success = Library.Theme.Success,
        Warning = Library.Theme.Warning,
        Error = Library.Theme.Error
    }
    
    local notif = Create("Frame", {
        Name = "Notification",
        BackgroundColor3 = Library.Theme.Secondary,
        BorderSizePixel = 0,
        Size = UDim2.new(0, 300, 0, 60),
        Position = UDim2.new(1, 320, 1, -80),
        Parent = notifGui
    })
    
    Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = notif})
    Create("UIStroke", {Color = colors[type], Thickness = 2, Parent = notif})
    
    AddGlow(notif, 10, colors[type])
    
    local accent = Create("Frame", {
        BackgroundColor3 = colors[type],
        BorderSizePixel = 0,
        Size = UDim2.new(0, 4, 1, 0),
        Parent = notif
    })
    
    Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = accent})
    
    local label = Create("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 15, 0, 0),
        Size = UDim2.new(1, -20, 1, 0),
        Font = Enum.Font.GothamBold,
        Text = text,
        TextColor3 = Library.Theme.Text,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true,
        Parent = notif
    })
    
    Tween(notif, {Position = UDim2.new(1, -320, 1, -80)}, 0.3, Enum.EasingStyle.Back)
    
    task.delay(duration, function()
        Tween(notif, {Position = UDim2.new(1, 320, 1, -80)}, 0.3)
        task.wait(0.3)
        notif:Destroy()
    end)
end

-- Main Window Creation
function Library:CreateWindow(options)
    options = options or {}
    local title = options.Title or "UI Library"
    local center = options.Center or true
    local autoShow = options.AutoShow or true
    
    -- Create ScreenGui
    local ScreenGui = Create("ScreenGui", {
        Name = "ModernUILibrary",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        Parent = game:GetService("CoreGui")
    })
    
    Library.ScreenGui = ScreenGui
    
    -- Notification Container
    Library.NotificationContainer = Create("Frame", {
        Name = "Notifications",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        ZIndex = 1000,
        Parent = ScreenGui
    })
    
    -- Main Container
    local MainFrame = Create("Frame", {
        Name = "MainFrame",
        BackgroundColor3 = Library.Theme.Primary,
        BorderSizePixel = 0,
        Position = UDim2.new(0.5, -400, 0.5, -300),
        Size = UDim2.new(0, 800, 0, 600),
        ClipsDescendants = true,
        Active = true,
        Parent = ScreenGui
    })
    
    Create("UICorner", {CornerRadius = UDim.new(0, 12), Parent = MainFrame})
    AddGlow(MainFrame, 20, Color3.fromRGB(0, 0, 0))
    
    Library.MainFrame = MainFrame
    
    -- Make draggable and resizable
    local dragging, resizing
    local dragStart, startPos, startSize
    
    MainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local mousePos = UserInputService:GetMouseLocation()
            local framePos = MainFrame.AbsolutePosition
            local frameSize = MainFrame.AbsoluteSize
            
            -- Check if near corner for resizing
            if mousePos.X >= framePos.X + frameSize.X - 20 and mousePos.Y >= framePos.Y + frameSize.Y - 20 then
                resizing = true
                startSize = MainFrame.Size
            else
                dragging = true
                dragStart = input.Position
                startPos = MainFrame.Position
            end
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            if dragging then
                local delta = input.Position - dragStart
                MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            elseif resizing then
                local mousePos = UserInputService:GetMouseLocation()
                local framePos = MainFrame.AbsolutePosition
                local newWidth = math.max(600, mousePos.X - framePos.X)
                local newHeight = math.max(400, mousePos.Y - framePos.Y)
                MainFrame.Size = UDim2.new(0, newWidth, 0, newHeight)
            end
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
            resizing = false
        end
    end)
    
    -- Top Bar
    local TopBar = Create("Frame", {
        Name = "TopBar",
        BackgroundColor3 = Library.Theme.Secondary,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 50),
        Parent = MainFrame
    })
    
    Create("UICorner", {CornerRadius = UDim.new(0, 12), Parent = TopBar})
    
    -- User Info Section
    local UserSection = Create("Frame", {
        Name = "UserSection",
        BackgroundColor3 = Library.Theme.Primary,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 10, 0, 8),
        Size = UDim2.new(0, 180, 0, 34),
        Parent = TopBar
    })
    
    Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = UserSection})
    Create("UIStroke", {Color = Library.Theme.Border, Thickness = 1, Parent = UserSection})
    
    local UserAvatar = Create("ImageLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 5, 0, 5),
        Size = UDim2.new(0, 24, 0, 24),
        Image = Players:GetUserThumbnailAsync(Players.LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48),
        Parent = UserSection
    })
    
    Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = UserAvatar})
    
    local UserName = Create("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 35, 0, 0),
        Size = UDim2.new(1, -40, 1, 0),
        Font = Enum.Font.GothamBold,
        Text = Players.LocalPlayer.Name,
        TextColor3 = Library.Theme.Text,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = UserSection
    })
    
    -- Title
    local TitleLabel = Create("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 200, 0, 0),
        Size = UDim2.new(0, 200, 1, 0),
        Font = Enum.Font.GothamBold,
        Text = title,
        TextColor3 = Library.Theme.Text,
        TextSize = 16,
        Parent = TopBar
    })
    
    -- Settings Button
    local SettingsBtn = Create("ImageButton", {
        Name = "SettingsButton",
        BackgroundColor3 = Library.Theme.Primary,
        BorderSizePixel = 0,
        Position = UDim2.new(1, -45, 0, 8),
        Size = UDim2.new(0, 34, 0, 34),
        Image = "rbxassetid://6031280882",
        ImageColor3 = Library.Theme.Text,
        Parent = TopBar
    })
    
    Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = SettingsBtn})
    
    SettingsBtn.MouseEnter:Connect(function()
        Tween(SettingsBtn, {BackgroundColor3 = Library.Theme.Accent})
    end)
    
    SettingsBtn.MouseLeave:Connect(function()
        Tween(SettingsBtn, {BackgroundColor3 = Library.Theme.Primary})
    end)
    
    -- Sidebar
    local Sidebar = Create("Frame", {
        Name = "Sidebar",
        BackgroundColor3 = Library.Theme.Secondary,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0, 50),
        Size = UDim2.new(0, 200, 1, -50),
        Parent = MainFrame
    })
    
    Create("UIStroke", {Color = Library.Theme.Border, Thickness = 1, Parent = Sidebar})
    
    -- Search Box
    local SearchContainer = Create("Frame", {
        Name = "SearchContainer",
        BackgroundColor3 = Library.Theme.Primary,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 10, 0, 10),
        Size = UDim2.new(1, -20, 0, 35),
        Parent = Sidebar
    })
    
    Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = SearchContainer})
    Create("UIStroke", {Color = Library.Theme.Border, Thickness = 1, Parent = SearchContainer})
    
    local SearchIcon = Create("ImageLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 8, 0.5, -8),
        Size = UDim2.new(0, 16, 0, 16),
        Image = "rbxassetid://6031154871",
        ImageColor3 = Library.Theme.TextDark,
        Parent = SearchContainer
    })
    
    local SearchBox = Create("TextBox", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 30, 0, 0),
        Size = UDim2.new(1, -35, 1, 0),
        Font = Enum.Font.Gotham,
        PlaceholderText = "search...",
        PlaceholderColor3 = Library.Theme.TextDark,
        Text = "",
        TextColor3 = Library.Theme.Text,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = SearchContainer
    })
    
    -- Tab Container
    local TabContainer = Create("ScrollingFrame", {
        Name = "TabContainer",
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 10, 0, 55),
        Size = UDim2.new(1, -20, 1, -65),
        ScrollBarThickness = 4,
        ScrollBarImageColor3 = Library.Theme.Accent,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        Parent = Sidebar
    })
    
    Create("UIListLayout", {
        Padding = UDim.new(0, 5),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = TabContainer
    })
    
    -- Content Area
    local ContentArea = Create("Frame", {
        Name = "ContentArea",
        BackgroundColor3 = Library.Theme.Primary,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 200, 0, 50),
        Size = UDim2.new(1, -200, 1, -50),
        Parent = MainFrame
    })
    
    -- Watermark
    local Watermark = Create("TextLabel", {
        Name = "Watermark",
        BackgroundColor3 = Library.Theme.Secondary,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 10, 0, 10),
        Size = UDim2.new(0, 250, 0, 30),
        Font = Enum.Font.GothamBold,
        Text = title .. " | " .. Players.LocalPlayer.Name,
        TextColor3 = Library.Theme.Text,
        TextSize = 12,
        Visible = false,
        Parent = ScreenGui
    })
    
    Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = Watermark})
    Create("UIStroke", {Color = Library.Theme.Border, Thickness = 1, Parent = Watermark})
    AddGradient(Watermark)
    
    Library.Watermark = Watermark
    
    -- Keybind Frame
    local KeybindFrame = Create("Frame", {
        Name = "KeybindFrame",
        BackgroundColor3 = Library.Theme.Secondary,
        BorderSizePixel = 0,
        Position = UDim2.new(1, -210, 0, 10),
        Size = UDim2.new(0, 200, 0, 200),
        Visible = false,
        Active = true,
        Parent = ScreenGui
    })
    
    Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = KeybindFrame})
    Create("UIStroke", {Color = Library.Theme.Border, Thickness = 1, Parent = KeybindFrame})
    AddGlow(KeybindFrame, 10)
    
    -- Make keybind frame draggable
    local kbDragging, kbDragStart, kbStartPos
    
    KeybindFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            kbDragging = true
            kbDragStart = input.Position
            kbStartPos = KeybindFrame.Position
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and kbDragging then
            local delta = input.Position - kbDragStart
            KeybindFrame.Position = UDim2.new(kbStartPos.X.Scale, kbStartPos.X.Offset + delta.X, kbStartPos.Y.Scale, kbStartPos.Y.Offset + delta.Y)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            kbDragging = false
        end
    end)
    
    local KBTitle = Create("TextLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 30),
        Font = Enum.Font.GothamBold,
        Text = "Keybinds",
        TextColor3 = Library.Theme.Text,
        TextSize = 13,
        Parent = KeybindFrame
    })
    
    local KBList = Create("ScrollingFrame", {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 5, 0, 35),
        Size = UDim2.new(1, -10, 1, -40),
        ScrollBarThickness = 4,
        ScrollBarImageColor3 = Library.Theme.Accent,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        Parent = KeybindFrame
    })
    
    Create("UIListLayout", {
        Padding = UDim.new(0, 3),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = KBList
    })
    
    Library.KeybindFrame = KeybindFrame
    Library.KeybindList = KBList
    
    -- Settings Panel
    local SettingsPanel = Create("Frame", {
        Name = "SettingsPanel",
        BackgroundColor3 = Library.Theme.Secondary,
        BorderSizePixel = 0,
        Position = UDim2.new(0.5, -200, 0.5, -150),
        Size = UDim2.new(0, 400, 0, 300),
        Visible = false,
        ZIndex = 100,
        Parent = ScreenGui
    })
    
    Create("UICorner", {CornerRadius = UDim.new(0, 12), Parent = SettingsPanel})
    Create("UIStroke", {Color = Library.Theme.Border, Thickness = 2, Parent = SettingsPanel})
    AddGlow(SettingsPanel, 15)
    
    SettingsBtn.MouseButton1Click:Connect(function()
        SettingsPanel.Visible = not SettingsPanel.Visible
    end)
    
    Library.SettingsPanel = SettingsPanel
    
    -- Window Object
    local Window = {
        Tabs = {},
        CurrentTab = nil
    }
    
    function Window:AddTab(name, icon)
        icon = icon or "rbxassetid://6031280882"
        
        local TabButton = Create("Frame", {
            Name = name,
            BackgroundColor3 = Library.Theme.Primary,
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 0, 40),
            Parent = TabContainer
        })
        
        Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = TabButton})
        
        local TabIcon = Create("ImageLabel", {
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 10, 0.5, -10),
            Size = UDim2.new(0, 20, 0, 20),
            Image = icon,
            ImageColor3 = Library.Theme.TextDark,
            Parent = TabButton
        })
        
        local TabLabel = Create("TextLabel", {
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 40, 0, 0),
            Size = UDim2.new(1, -45, 1, 0),
            Font = Enum.Font.GothamBold,
            Text = name,
            TextColor3 = Library.Theme.TextDark,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = TabButton
        })
        
        local TabContent = Create("Frame", {
            Name = name .. "Content",
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            Visible = false,
            Parent = ContentArea
        })
        
        local LeftSide = Create("ScrollingFrame", {
            Name = "LeftSide",
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Position = UDim2.new(0, 10, 0, 10),
            Size = UDim2.new(0.48, -10, 1, -20),
            ScrollBarThickness = 4,
            ScrollBarImageColor3 = Library.Theme.Accent,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            Parent = TabContent
        })
        
        Create("UIListLayout", {
            Padding = UDim.new(0, 10),
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = LeftSide
        })
        
        local RightSide = Create("ScrollingFrame", {
            Name = "RightSide",
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Position = UDim2.new(0.52, 0, 0, 10),
            Size = UDim2.new(0.48, -10, 1, -20),
            ScrollBarThickness = 4,
            ScrollBarImageColor3 = Library.Theme.Accent,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            Parent = TabContent
        })
        
        Create("UIListLayout", {
            Padding = UDim.new(0, 10),
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = RightSide
        })
        
        local TabBtn = Create("TextButton", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            Text = "",
            Parent = TabButton
        })
        
        TabBtn.MouseButton1Click:Connect(function()
            for _, tab in pairs(Window.Tabs) do
                tab.Content.Visible = false
                Tween(tab.Button:FindFirstChildOfClass("ImageLabel"), {ImageColor3 = Library.Theme.TextDark})
                Tween(tab.Button:FindFirstChildOfClass("TextLabel"), {TextColor3 = Library.Theme.TextDark})
                Tween(tab.Button, {BackgroundColor3 = Library.Theme.Primary})
            end
            
            TabContent.Visible = true
            Tween(TabIcon, {ImageColor3 = Library.Theme.Accent})
            Tween(TabLabel, {TextColor3 = Library.Theme.Text})
            Tween(TabButton, {BackgroundColor3 = Library.Theme.Accent})
            
            Window.CurrentTab = Tab
        end)
        
        local Tab = {
            Name = name,
            Button = TabButton,
            Content = TabContent,
            LeftSide = LeftSide,
            RightSide = RightSide
        }
        
        function Tab:AddLeftGroupbox(name)
            return self:CreateGroupbox(name, self.LeftSide)
        end
        
        function Tab:AddRightGroupbox(name)
            return self:CreateGroupbox(name, self.RightSide)
        end
        
        function Tab:AddLeftTabbox()
            return self:CreateTabbox(self.LeftSide)
        end
        
        function Tab:AddRightTabbox()
            return self:CreateTabbox(self.RightSide)
        end
        
        function Tab:CreateGroupbox(name, parent)
            local Groupbox = Create("Frame", {
                Name = name,
                BackgroundColor3 = Library.Theme.Secondary,
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 0, 40),
                Parent = parent
            })
            
            Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = Groupbox})
            Create("UIStroke", {Color = Library.Theme.Border, Thickness = 1, Parent = Groupbox})
            
            local Title = Create("TextLabel", {
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 10, 0, 8),
                Size = UDim2.new(1, -20, 0, 20),
                Font = Enum.Font.GothamBold,
                Text = name,
                TextColor3 = Library.Theme.Text,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = Groupbox
            })
            
            local Container = Create("Frame", {
                Name = "Container",
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 10, 0, 35),
                Size = UDim2.new(1, -20, 1, -40),
                Parent = Groupbox
            })
            
            local Layout = Create("UIListLayout", {
                Padding = UDim.new(0, 8),
                SortOrder = Enum.SortOrder.LayoutOrder,
                Parent = Container
            })
            
            Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                Groupbox.Size = UDim2.new(1, 0, 0, Layout.AbsoluteContentSize.Y + 50)
                parent.CanvasSize = UDim2.new(0, 0, 0, parent.UIListLayout.AbsoluteContentSize.Y + 20)
            end)
            
            local GroupboxObj = {
                Container = Container,
                Frame = Groupbox
            }
            
            -- AddToggle
            function GroupboxObj:AddToggle(idx, options)
                options = options or {}
                local text = options.Text or "Toggle"
                local default = options.Default or false
                local tooltip = options.Tooltip
                local callback = options.Callback or function() end
                
                local ToggleFrame = Create("Frame", {
                    Name = idx,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 25),
                    Parent = Container
                })
                
                local ToggleLabel = Create("TextLabel", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, -35, 1, 0),
                    Font = Enum.Font.Gotham,
                    Text = text,
                    TextColor3 = Library.Theme.Text,
                    TextSize = 12,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = ToggleFrame
                })
                
                local ToggleButton = Create("Frame", {
                    BackgroundColor3 = Library.Theme.Primary,
                    BorderSizePixel = 0,
                    Position = UDim2.new(1, -30, 0.5, -10),
                    Size = UDim2.new(0, 30, 0, 20),
                    Parent = ToggleFrame
                })
                
                Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = ToggleButton})
                Create("UIStroke", {Color = Library.Theme.Border, Thickness = 1, Parent = ToggleButton})
                
                local Checkmark = Create("ImageLabel", {
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0.5, -8, 0.5, -8),
                    Size = UDim2.new(0, 16, 0, 16),
                    Image = "rbxassetid://6031094678",
                    ImageColor3 = Library.Theme.Success,
                    ImageTransparency = 1,
                    Parent = ToggleButton
                })
                
                local ToggleBtn = Create("TextButton", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 1, 0),
                    Text = "",
                    Parent = ToggleFrame
                })
                
                local toggled = default
                
                local function UpdateToggle(state)
                    toggled = state
                    
                    if toggled then
                        Tween(ToggleButton, {BackgroundColor3 = Library.Theme.Accent})
                        Tween(Checkmark, {ImageTransparency = 0}, 0.15)
                    else
                        Tween(ToggleButton, {BackgroundColor3 = Library.Theme.Primary})
                        Tween(Checkmark, {ImageTransparency = 1}, 0.15)
                    end
                    
                    callback(state)
                end
                
                ToggleBtn.MouseButton1Click:Connect(function()
                    UpdateToggle(not toggled)
                end)
                
                UpdateToggle(default)
                
                local ToggleObj = {
                    Value = default,
                    Type = "Toggle"
                }
                
                function ToggleObj:SetValue(value)
                    UpdateToggle(value)
                    self.Value = value
                end
                
                function ToggleObj:OnChanged(func)
                    ToggleBtn.MouseButton1Click:Connect(function()
                        func(toggled)
                    end)
                end
                
                Toggles[idx] = ToggleObj
                
                return ToggleObj
            end
            
            -- AddButton
            function GroupboxObj:AddButton(options)
                options = options or {}
                local text = options.Text or "Button"
                local func = options.Func or function() end
                local doubleClick = options.DoubleClick or false
                local tooltip = options.Tooltip
                
                local ButtonFrame = Create("Frame", {
                    BackgroundColor3 = Library.Theme.Primary,
                    BorderSizePixel = 0,
                    Size = UDim2.new(1, 0, 0, 30),
                    Parent = Container
                })
                
                Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = ButtonFrame})
                Create("UIStroke", {Color = Library.Theme.Border, Thickness = 1, Parent = ButtonFrame})
                
                local ButtonLabel = Create("TextLabel", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 1, 0),
                    Font = Enum.Font.GothamBold,
                    Text = text,
                    TextColor3 = Library.Theme.Text,
                    TextSize = 12,
                    Parent = ButtonFrame
                })
                
                local Button = Create("TextButton", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 1, 0),
                    Text = "",
                    Parent = ButtonFrame
                })
                
                Button.MouseEnter:Connect(function()
                    Tween(ButtonFrame, {BackgroundColor3 = Library.Theme.Accent})
                end)
                
                Button.MouseLeave:Connect(function()
                    Tween(ButtonFrame, {BackgroundColor3 = Library.Theme.Primary})
                end)
                
                if doubleClick then
                    local clicks = 0
                    Button.MouseButton1Click:Connect(function()
                        clicks = clicks + 1
                        if clicks == 2 then
                            func()
                            clicks = 0
                        end
                        task.delay(0.5, function()
                            clicks = 0
                        end)
                    end)
                else
                    Button.MouseButton1Click:Connect(func)
                end
                
                local ButtonObj = {
                    Frame = ButtonFrame
                }
                
                function ButtonObj:AddButton(subOptions)
                    return GroupboxObj:AddButton(subOptions)
                end
                
                return ButtonObj
            end
            
            -- AddSlider
            function GroupboxObj:AddSlider(idx, options)
                options = options or {}
                local text = options.Text or "Slider"
                local default = options.Default or 0
                local min = options.Min or 0
                local max = options.Max or 100
                local rounding = options.Rounding or 0
                local suffix = options.Suffix or ""
                local callback = options.Callback or function() end
                
                local SliderFrame = Create("Frame", {
                    Name = idx,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 45),
                    Parent = Container
                })
                
                local SliderLabel = Create("TextLabel", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0.7, 0, 0, 20),
                    Font = Enum.Font.Gotham,
                    Text = text,
                    TextColor3 = Library.Theme.Text,
                    TextSize = 12,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = SliderFrame
                })
                
                local ValueLabel = Create("TextLabel", {
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0.7, 0, 0, 0),
                    Size = UDim2.new(0.3, 0, 0, 20),
                    Font = Enum.Font.GothamBold,
                    Text = tostring(default) .. suffix,
                    TextColor3 = Library.Theme.Accent,
                    TextSize = 12,
                    TextXAlignment = Enum.TextXAlignment.Right,
                    Parent = SliderFrame
                })
                
                local SliderBack = Create("Frame", {
                    BackgroundColor3 = Library.Theme.Primary,
                    BorderSizePixel = 0,
                    Position = UDim2.new(0, 0, 0, 25),
                    Size = UDim2.new(1, 0, 0, 6),
                    Parent = SliderFrame
                })
                
                Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = SliderBack})
                
                local SliderFill = Create("Frame", {
                    BackgroundColor3 = Library.Theme.Accent,
                    BorderSizePixel = 0,
                    Size = UDim2.new(0, 0, 1, 0),
                    Parent = SliderBack
                })
                
                Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = SliderFill})
                AddGradient(SliderFill)
                
                local SliderDot = Create("Frame", {
                    BackgroundColor3 = Library.Theme.Text,
                    BorderSizePixel = 0,
                    Position = UDim2.new(0, -6, 0.5, -6),
                    Size = UDim2.new(0, 12, 0, 12),
                    ZIndex = 2,
                    Parent = SliderFill
                })
                
                Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = SliderDot})
                AddGlow(SliderDot, 3, Library.Theme.Accent)
                
                local dragging = false
                local value = default
                
                local function Round(num)
                    if rounding == 0 then
                        return math.floor(num)
                    end
                    return math.floor(num * (10 ^ rounding) + 0.5) / (10 ^ rounding)
                end
                
                local function UpdateSlider(val)
                    value = math.clamp(val, min, max)
                    value = Round(value)
                    
                    local percent = (value - min) / (max - min)
                    Tween(SliderFill, {Size = UDim2.new(percent, 0, 1, 0)}, 0.1)
                    ValueLabel.Text = tostring(value) .. suffix
                    
                    callback(value)
                end
                
                SliderBack.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = true
                        local percent = math.clamp((input.Position.X - SliderBack.AbsolutePosition.X) / SliderBack.AbsoluteSize.X, 0, 1)
                        UpdateSlider(min + (max - min) * percent)
                    end
                end)
                
                UserInputService.InputChanged:Connect(function(input)
                    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                        local percent = math.clamp((input.Position.X - SliderBack.AbsolutePosition.X) / SliderBack.AbsoluteSize.X, 0, 1)
                        UpdateSlider(min + (max - min) * percent)
                    end
                end)
                
                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = false
                    end
                end)
                
                UpdateSlider(default)
                
                local SliderObj = {
                    Value = value,
                    Type = "Slider"
                }
                
                function SliderObj:SetValue(val)
                    UpdateSlider(val)
                    self.Value = val
                end
                
                function SliderObj:OnChanged(func)
                    SliderBack.InputBegan:Connect(function()
                        func(value)
                    end)
                end
                
                Options[idx] = SliderObj
                
                return SliderObj
            end
            
            -- AddInput
            function GroupboxObj:AddInput(idx, options)
                options = options or {}
                local text = options.Text or "Input"
                local default = options.Default or ""
                local numeric = options.Numeric or false
                local finished = options.Finished or false
                local placeholder = options.Placeholder or ""
                local callback = options.Callback or function() end
                
                local InputFrame = Create("Frame", {
                    Name = idx,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 50),
                    Parent = Container
                })
                
                local InputLabel = Create("TextLabel", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 20),
                    Font = Enum.Font.Gotham,
                    Text = text,
                    TextColor3 = Library.Theme.Text,
                    TextSize = 12,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = InputFrame
                })
                
                local InputBox = Create("Frame", {
                    BackgroundColor3 = Library.Theme.Primary,
                    BorderSizePixel = 0,
                    Position = UDim2.new(0, 0, 0, 25),
                    Size = UDim2.new(1, 0, 0, 25),
                    Parent = InputFrame
                })
                
                Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = InputBox})
                Create("UIStroke", {Color = Library.Theme.Border, Thickness = 1, Parent = InputBox})
                
                local TextBox = Create("TextBox", {
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 8, 0, 0),
                    Size = UDim2.new(1, -16, 1, 0),
                    Font = Enum.Font.Gotham,
                    PlaceholderText = placeholder,
                    PlaceholderColor3 = Library.Theme.TextDark,
                    Text = default,
                    TextColor3 = Library.Theme.Text,
                    TextSize = 11,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = InputBox
                })
                
                if numeric then
                    TextBox:GetPropertyChangedSignal("Text"):Connect(function()
                        TextBox.Text = TextBox.Text:gsub("%D", "")
                    end)
                end
                
                TextBox.Focused:Connect(function()
                    Tween(InputBox:FindFirstChildOfClass("UIStroke"), {Color = Library.Theme.Accent})
                end)
                
                TextBox.FocusLost:Connect(function()
                    Tween(InputBox:FindFirstChildOfClass("UIStroke"), {Color = Library.Theme.Border})
                    if finished then
                        callback(TextBox.Text)
                    end
                end)
                
                if not finished then
                    TextBox:GetPropertyChangedSignal("Text"):Connect(function()
                        callback(TextBox.Text)
                    end)
                end
                
                local InputObj = {
                    Value = default,
                    Type = "Input"
                }
                
                function InputObj:SetValue(val)
                    TextBox.Text = val
                    self.Value = val
                end
                
                function InputObj:OnChanged(func)
                    TextBox:GetPropertyChangedSignal("Text"):Connect(function()
                        func(TextBox.Text)
                    end)
                end
                
                Options[idx] = InputObj
                
                return InputObj
            end
            
            -- AddDropdown
            function GroupboxObj:AddDropdown(idx, options)
                options = options or {}
                local text = options.Text or "Dropdown"
                local values = options.Values or {}
                local default = options.Default or 1
                local multi = options.Multi or false
                local callback = options.Callback or function() end
                
                local DropdownFrame = Create("Frame", {
                    Name = idx,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 50),
                    Parent = Container
                })
                
                local DropdownLabel = Create("TextLabel", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 20),
                    Font = Enum.Font.Gotham,
                    Text = text,
                    TextColor3 = Library.Theme.Text,
                    TextSize = 12,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = DropdownFrame
                })
                
                local DropdownButton = Create("Frame", {
                    BackgroundColor3 = Library.Theme.Primary,
                    BorderSizePixel = 0,
                    Position = UDim2.new(0, 0, 0, 25),
                    Size = UDim2.new(1, 0, 0, 25),
                    Parent = DropdownFrame
                })
                
                Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = DropdownButton})
                Create("UIStroke", {Color = Library.Theme.Border, Thickness = 1, Parent = DropdownButton})
                
                local DropdownText = Create("TextLabel", {
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 8, 0, 0),
                    Size = UDim2.new(1, -30, 1, 0),
                    Font = Enum.Font.Gotham,
                    Text = type(default) == "number" and values[default] or default,
                    TextColor3 = Library.Theme.Text,
                    TextSize = 11,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = DropdownButton
                })
                
                local Arrow = Create("ImageLabel", {
                    BackgroundTransparency = 1,
                    Position = UDim2.new(1, -20, 0.5, -5),
                    Size = UDim2.new(0, 10, 0, 10),
                    Image = "rbxassetid://6031091004",
                    ImageColor3 = Library.Theme.TextDark,
                    Parent = DropdownButton
                })
                
                local DropdownList = Create("Frame", {
                    BackgroundColor3 = Library.Theme.Secondary,
                    BorderSizePixel = 0,
                    Position = UDim2.new(0, 0, 0, 30),
                    Size = UDim2.new(1, 0, 0, 0),
                    ClipsDescendants = true,
                    ZIndex = 10,
                    Parent = DropdownFrame
                })
                
                Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = DropdownList})
                Create("UIStroke", {Color = Library.Theme.Border, Thickness = 1, Parent = DropdownList})
                
                local ListLayout = Create("UIListLayout", {
                    Padding = UDim.new(0, 2),
                    Parent = DropdownList
                })
                
                local isOpen = false
                local selectedValues = multi and {} or nil
                
                local DropBtn = Create("TextButton", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 1, 0),
                    Text = "",
                    Parent = DropdownButton
                })
                
                DropBtn.MouseButton1Click:Connect(function()
                    isOpen = not isOpen
                    if isOpen then
                        Tween(DropdownList, {Size = UDim2.new(1, 0, 0, math.min(#values * 27 + 4, 135))}, 0.2, Enum.EasingStyle.Back)
                        Tween(Arrow, {Rotation = 180})
                    else
                        Tween(DropdownList, {Size = UDim2.new(1, 0, 0, 0)})
                        Tween(Arrow, {Rotation = 0})
                    end
                end)
                
                for i, value in ipairs(values) do
                    local ItemFrame = Create("Frame", {
                        BackgroundColor3 = Library.Theme.Primary,
                        BorderSizePixel = 0,
                        Size = UDim2.new(1, -4, 0, 25),
                        Parent = DropdownList
                    })
                    
                    Create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = ItemFrame})
                    
                    local ItemLabel = Create("TextLabel", {
                        BackgroundTransparency = 1,
                        Position = UDim2.new(0, 8, 0, 0),
                        Size = UDim2.new(1, -16, 1, 0),
                        Font = Enum.Font.Gotham,
                        Text = value,
                        TextColor3 = Library.Theme.Text,
                        TextSize = 11,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        Parent = ItemFrame
                    })
                    
                    local ItemBtn = Create("TextButton", {
                        BackgroundTransparency = 1,
                        Size = UDim2.new(1, 0, 1, 0),
                        Text = "",
                        Parent = ItemFrame
                    })
                    
                    ItemBtn.MouseEnter:Connect(function()
                        Tween(ItemFrame, {BackgroundColor3 = Library.Theme.Accent})
                    end)
                    
                    ItemBtn.MouseLeave:Connect(function()
                        Tween(ItemFrame, {BackgroundColor3 = Library.Theme.Primary})
                    end)
                    
                    ItemBtn.MouseButton1Click:Connect(function()
                        if multi then
                            selectedValues[value] = not selectedValues[value]
                            local selected = {}
                            for k, v in pairs(selectedValues) do
                                if v then table.insert(selected, k) end
                            end
                            DropdownText.Text = #selected > 0 and table.concat(selected, ", ") or "None"
                            callback(selectedValues)
                        else
                            DropdownText.Text = value
                            isOpen = false
                            Tween(DropdownList, {Size = UDim2.new(1, 0, 0, 0)})
                            Tween(Arrow, {Rotation = 0})
                            callback(value)
                        end
                    end)
                end
                
                local DropdownObj = {
                    Value = multi and selectedValues or (type(default) == "number" and values[default] or default),
                    Type = "Dropdown"
                }
                
                function DropdownObj:SetValue(val)
                    if multi then
                        selectedValues = val
                        local selected = {}
                        for k, v in pairs(selectedValues) do
                            if v then table.insert(selected, k) end
                        end
                        DropdownText.Text = #selected > 0 and table.concat(selected, ", ") or "None"
                    else
                        DropdownText.Text = val
                    end
                    self.Value = val
                end
                
                function DropdownObj:OnChanged(func)
                    DropBtn.MouseButton1Click:Connect(function()
                        func(self.Value)
                    end)
                end
                
                Options[idx] = DropdownObj
                
                return DropdownObj
            end
            
            -- AddLabel
            function GroupboxObj:AddLabel(text, wrap)
                local Label = Create("TextLabel", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 20),
                    Font = Enum.Font.Gotham,
                    Text = text,
                    TextColor3 = Library.Theme.TextDark,
                    TextSize = 11,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextYAlignment = Enum.TextYAlignment.Top,
                    TextWrapped = wrap or false,
                    Parent = Container
                })
                
                if wrap then
                    Label.Size = UDim2.new(1, 0, 0, 0)
                    Label.AutomaticSize = Enum.AutomaticSize.Y
                end
                
                local LabelObj = {
                    Label = Label
                }
                
                function LabelObj:AddColorPicker(idx, options)
                    return GroupboxObj:AddColorPicker(idx, options, Label)
                end
                
                function LabelObj:AddKeyPicker(idx, options)
                    return GroupboxObj:AddKeyPicker(idx, options, Label)
                end
                
                return LabelObj
            end
            
            -- AddDivider
            function GroupboxObj:AddDivider()
                local Divider = Create("Frame", {
                    BackgroundColor3 = Library.Theme.Border,
                    BorderSizePixel = 0,
                    Size = UDim2.new(1, 0, 0, 1),
                    Parent = Container
                })
                
                return Divider
            end
            
            -- AddColorPicker
            function GroupboxObj:AddColorPicker(idx, options, attachTo)
                options = options or {}
                local default = options.Default or Color3.new(1, 1, 1)
                local title = options.Title or "Color Picker"
                local transparency = options.Transparency
                local callback = options.Callback or function() end
                
                local parent = attachTo or Container
                local cpFrame
                
                if attachTo then
                    cpFrame = Create("Frame", {
                        BackgroundColor3 = default,
                        BorderSizePixel = 0,
                        Position = UDim2.new(1, -25, 0.5, -10),
                        Size = UDim2.new(0, 20, 0, 20),
                        Parent = parent
                    })
                else
                    cpFrame = Create("Frame", {
                        BackgroundTransparency = 1,
                        Size = UDim2.new(1, 0, 0, 25),
                        Parent = parent
                    })
                    
                    local cpLabel = Create("TextLabel", {
                        BackgroundTransparency = 1,
                        Size = UDim2.new(1, -30, 1, 0),
                        Font = Enum.Font.Gotham,
                        Text = title,
                        TextColor3 = Library.Theme.Text,
                        TextSize = 12,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        Parent = cpFrame
                    })
                    
                    cpFrame = Create("Frame", {
                        BackgroundColor3 = default,
                        BorderSizePixel = 0,
                        Position = UDim2.new(1, -25, 0.5, -10),
                        Size = UDim2.new(0, 20, 0, 20),
                        Parent = cpFrame
                    })
                end
                
                Create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = cpFrame})
                Create("UIStroke", {Color = Library.Theme.Border, Thickness = 1, Parent = cpFrame})
                
                local cpBtn = Create("TextButton", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 1, 0),
                    Text = "",
                    Parent = cpFrame
                })
                
                local ColorPickerObj = {
                    Value = default,
                    Transparency = transparency or 0,
                    Type = "ColorPicker"
                }
                
                cpBtn.MouseButton1Click:Connect(function()
                    -- Open color picker (simplified)
                    Library:Notify({
                        Text = "Color picker clicked!",
                        Duration = 2,
                        Type = "Info"
                    })
                end)
                
                function ColorPickerObj:SetValueRGB(color)
                    cpFrame.BackgroundColor3 = color
                    self.Value = color
                    callback(color)
                end
                
                function ColorPickerObj:OnChanged(func)
                    cpBtn.MouseButton1Click:Connect(function()
                        func(self.Value)
                    end)
                end
                
                Options[idx] = ColorPickerObj
                
                return ColorPickerObj
            end
            
            -- AddKeyPicker
            function GroupboxObj:AddKeyPicker(idx, options, attachTo)
                options = options or {}
                local default = options.Default or "NONE"
                local mode = options.Mode or "Toggle"
                local text = options.Text or "Keybind"
                local callback = options.Callback or function() end
                
                local parent = attachTo or Container
                local kpFrame
                
                if attachTo then
                    kpFrame = Create("Frame", {
                        BackgroundColor3 = Library.Theme.Primary,
                        BorderSizePixel = 0,
                        Position = UDim2.new(1, -50, 0.5, -10),
                        Size = UDim2.new(0, 45, 0, 20),
                        Parent = parent
                    })
                else
                    kpFrame = Create("Frame", {
                        BackgroundTransparency = 1,
                        Size = UDim2.new(1, 0, 0, 25),
                        Parent = parent
                    })
                    
                    local kpLabel = Create("TextLabel", {
                        BackgroundTransparency = 1,
                        Size = UDim2.new(1, -55, 1, 0),
                        Font = Enum.Font.Gotham,
                        Text = text,
                        TextColor3 = Library.Theme.Text,
                        TextSize = 12,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        Parent = kpFrame
                    })
                    
                    kpFrame = Create("Frame", {
                        BackgroundColor3 = Library.Theme.Primary,
                        BorderSizePixel = 0,
                        Position = UDim2.new(1, -50, 0.5, -10),
                        Size = UDim2.new(0, 45, 0, 20),
                        Parent = kpFrame
                    })
                end
                
                Create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = kpFrame})
                Create("UIStroke", {Color = Library.Theme.Border, Thickness = 1, Parent = kpFrame})
                
                local kpText = Create("TextLabel", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 1, 0),
                    Font = Enum.Font.GothamBold,
                    Text = default,
                    TextColor3 = Library.Theme.Text,
                    TextSize = 10,
                    Parent = kpFrame
                })
                
                local kpBtn = Create("TextButton", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 1, 0),
                    Text = "",
                    Parent = kpFrame
                })
                
                local KeyPickerObj = {
                    Value = default,
                    Mode = mode,
                    Type = "KeyPicker",
                    Active = false
                }
                
                local binding = false
                
                kpBtn.MouseButton1Click:Connect(function()
                    if not binding then
                        binding = true
                        kpText.Text = "..."
                        
                        local connection
                        connection = UserInputService.InputBegan:Connect(function(input)
                            if input.UserInputType == Enum.UserInputType.Keyboard then
                                local key = input.KeyCode.Name
                                kpText.Text = key
                                KeyPickerObj.Value = key
                                binding = false
                                connection:Disconnect()
                            end
                        end)
                    end
                end)
                
                function KeyPickerObj:SetValue(value)
                    kpText.Text = type(value) == "table" and value[1] or value
                    self.Value = type(value) == "table" and value[1] or value
                    self.Mode = type(value) == "table" and value[2] or self.Mode
                end
                
                function KeyPickerObj:OnClick(func)
                    callback = func
                end
                
                function KeyPickerObj:OnChanged(func)
                    kpBtn.MouseButton1Click:Connect(function()
                        func(self.Value)
                    end)
                end
                
                function KeyPickerObj:GetState()
                    return self.Active
                end
                
                Options[idx] = KeyPickerObj
                
                return KeyPickerObj
            end
            
            -- AddImage
            function GroupboxObj:AddImage(assetId, size)
                size = size or UDim2.new(1, 0, 0, 100)
                
                local ImageFrame = Create("ImageLabel", {
                    BackgroundTransparency = 1,
                    Size = size,
                    Image = "rbxassetid://" .. assetId,
                    ScaleType = Enum.ScaleType.Fit,
                    Parent = Container
                })
                
                return ImageFrame
            end
            
            return GroupboxObj
        end
        
        function Tab:CreateTabbox(parent)
            local TabboxFrame = Create("Frame", {
                BackgroundColor3 = Library.Theme.Secondary,
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 0, 300),
                Parent = parent
            })
            
            Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = TabboxFrame})
            Create("UIStroke", {Color = Library.Theme.Border, Thickness = 1, Parent = TabboxFrame})
            
            local TabButtons = Create("Frame", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 35),
                Parent = TabboxFrame
            })
            
            Create("UIListLayout", {
                FillDirection = Enum.FillDirection.Horizontal,
                Padding = UDim.new(0, 5),
                SortOrder = Enum.SortOrder.LayoutOrder,
                Parent = TabButtons
            })
            
            local ContentFrame = Create("Frame", {
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 5, 0, 40),
                Size = UDim2.new(1, -10, 1, -45),
                Parent = TabboxFrame
            })
            
            local Tabbox = {
                Tabs = {},
                Frame = TabboxFrame
            }
            
            function Tabbox:AddTab(name)
                local isFirst = #self.Tabs == 0
                
                local TabBtn = Create("Frame", {
                    BackgroundColor3 = isFirst and Library.Theme.Accent or Library.Theme.Primary,
                    BorderSizePixel = 0,
                    Size = UDim2.new(0, 80, 0, 30),
                    Parent = TabButtons
                })
                
                Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = TabBtn})
                
                local TabLabel = Create("TextLabel", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 1, 0),
                    Font = Enum.Font.GothamBold,
                    Text = name,
                    TextColor3 = Library.Theme.Text,
                    TextSize = 11,
                    Parent = TabBtn
                })
                
                local TabContent = Create("ScrollingFrame", {
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    Size = UDim2.new(1, 0, 1, 0),
                    ScrollBarThickness = 4,
                    ScrollBarImageColor3 = Library.Theme.Accent,
                    CanvasSize = UDim2.new(0, 0, 0, 0),
                    Visible = isFirst,
                    Parent = ContentFrame
                })
                
                Create("UIListLayout", {
                    Padding = UDim.new(0, 8),
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    Parent = TabContent
                })
                
                local Button = Create("TextButton", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 1, 0),
                    Text = "",
                    Parent = TabBtn
                })
                
                Button.MouseButton1Click:Connect(function()
                    for _, tab in pairs(self.Tabs) do
                        tab.Content.Visible = false
                        Tween(tab.Button, {BackgroundColor3 = Library.Theme.Primary})
                    end
                    
                    TabContent.Visible = true
                    Tween(TabBtn, {BackgroundColor3 = Library.Theme.Accent})
                end)
                
                local TabObj = {
                    Name = name,
                    Button = TabBtn,
                    Content = TabContent,
                    Container = TabContent
                }
                
                -- Add all groupbox methods to tabbox tabs
                setmetatable(TabObj, {__index = function(t, k)
                    local groupboxMethods = {
                        "AddToggle", "AddButton", "AddSlider", "AddInput", 
                        "AddDropdown", "AddLabel", "AddDivider", "AddColorPicker",
                        "AddKeyPicker", "AddImage"
                    }
                    
                    for _, method in ipairs(groupboxMethods) do
                        if k == method then
                            return function(self, ...)
                                local mockGroupbox = {Container = TabContent}
                                setmetatable(mockGroupbox, {__index = function(tbl, key)
                                    -- Find the method in a real groupbox
                                    local realGroupbox = Tab:CreateGroupbox("temp", parent)
                                    return realGroupbox[key]
                                end})
                                return mockGroupbox[method](mockGroupbox, ...)
                            end
                        end
                    end
                end})
                
                table.insert(self.Tabs, TabObj)
                
                return TabObj
            end
            
            return Tabbox
        end
        
        table.insert(Window.Tabs, Tab)
        
        if #Window.Tabs == 1 then
            TabContent.Visible = true
            Tween(TabIcon, {ImageColor3 = Library.Theme.Accent})
            Tween(TabLabel, {TextColor3 = Library.Theme.Text})
            Tween(TabButton, {BackgroundColor3 = Library.Theme.Accent})
            Window.CurrentTab = Tab
        end
        
        return Tab
    end
    
    -- Search functionality
    SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
        local query = SearchBox.Text:lower()
        
        for _, tab in pairs(Window.Tabs) do
            for _, side in pairs({tab.LeftSide, tab.RightSide}) do
                for _, groupbox in pairs(side:GetChildren()) do
                    if groupbox:IsA("Frame") and groupbox.Name ~= "LeftSide" and groupbox.Name ~= "RightSide" then
                        local container = groupbox:FindFirstChild("Container")
                        if container then
                            local hasMatch = false
                            for _, element in pairs(container:GetChildren()) do
                                if element:IsA("GuiObject") then
                                    local text = ""
                                    if element:FindFirstChildOfClass("TextLabel") then
                                        text = element:FindFirstChildOfClass("TextLabel").Text:lower()
                                    end
                                    
                                    if query == "" or text:find(query) then
                                        element.Visible = true
                                        hasMatch = true
                                    else
                                        element.Visible = false
                                    end
                                end
                            end
                            groupbox.Visible = hasMatch or query == ""
                        end
                    end
                end
            end
        end
    end)
    
    if not autoShow then
        MainFrame.Visible = false
    end
    
    return Window
end

-- Library Functions
function Library:SetWatermark(text)
    if self.Watermark then
        self.Watermark.Text = text
    end
end

function Library:SetWatermarkVisibility(visible)
    if self.Watermark then
        self.Watermark.Visible = visible
    end
end

function Library:Unload()
    if self.ScreenGui then
        self.ScreenGui:Destroy()
    end
    self.Unloaded = true
end

function Library:OnUnload(callback)
    game:GetService("Players").LocalPlayer.Character:WaitForChild("Humanoid").Died:Connect(callback)
end

-- Update keybind list
function Library:UpdateKeybindList()
    if not self.KeybindList then return end
    
    for _, child in pairs(self.KeybindList:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end
    
    local yPos = 0
    for idx, keybind in pairs(Options) do
        if keybind.Type == "KeyPicker" and keybind.Active then
            local KBItem = Create("Frame", {
                BackgroundColor3 = Library.Theme.Primary,
                BorderSizePixel = 0,
                Position = UDim2.new(0, 0, 0, yPos),
                Size = UDim2.new(1, 0, 0, 25),
                Parent = self.KeybindList
            })
            
            Create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = KBItem})
            
            local KBText = Create("TextLabel", {
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 5, 0, 0),
                Size = UDim2.new(0.7, 0, 1, 0),
                Font = Enum.Font.Gotham,
                Text = idx,
                TextColor3 = Library.Theme.Text,
                TextSize = 11,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = KBItem
            })
            
            local KBKey = Create("TextLabel", {
                BackgroundTransparency = 1,
                Position = UDim2.new(0.7, 0, 0, 0),
                Size = UDim2.new(0.3, -5, 1, 0),
                Font = Enum.Font.GothamBold,
                Text = keybind.Value,
                TextColor3 = Library.Theme.Accent,
                TextSize = 10,
                TextXAlignment = Enum.TextXAlignment.Right,
                Parent = KBItem
            })
            
            yPos = yPos + 28
        end
    end
    
    self.KeybindList.CanvasSize = UDim2.new(0, 0, 0, yPos)
end

return Library
