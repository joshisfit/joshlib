local TweenService = game:GetService('TweenService')
local UserInputService = game:GetService('UserInputService')
local RunService = game:GetService('RunService')
local Players = game:GetService('Players')
local CoreGui = game:GetService('CoreGui')
local TextService = game:GetService('TextService')

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local ScreenGui = Instance.new('ScreenGui')
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = CoreGui

local Library = {
    Flags = {},
    Theme = {
        Main = Color3.fromRGB(25, 25, 35),
        Second = Color3.fromRGB(30, 30, 40),
        Third = Color3.fromRGB(35, 35, 45),
        Accent = Color3.fromRGB(120, 80, 255),
        Text = Color3.fromRGB(255, 255, 255),
        TextDark = Color3.fromRGB(150, 150, 150),
        Outline = Color3.fromRGB(15, 15, 20)
    },
    Notifications = {},
    KeybindList = {},
    Watermark = nil
}

getgenv().Library = Library
getgenv().Toggles = {}
getgenv().Options = {}

local function Create(class, props)
    local obj = Instance.new(class)
    for i,v in pairs(props) do
        if i ~= "Parent" then
            obj[i] = v
        end
    end
    obj.Parent = props.Parent
    return obj
end

local function Tween(obj, props, duration, style)
    duration = duration or 0.3
    style = style or Enum.EasingStyle.Quad
    TweenService:Create(obj, TweenInfo.new(duration, style), props):Play()
end

function Library:Notify(text, duration)
    duration = duration or 3
    
    local notif = Create("Frame", {
        Size = UDim2.new(0, 300, 0, 60),
        Position = UDim2.new(1, -310, 1, 10),
        BackgroundColor3 = Library.Theme.Second,
        BorderSizePixel = 0,
        Parent = ScreenGui
    })
    
    Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = notif})
    Create("UIStroke", {
        Color = Library.Theme.Accent,
        Thickness = 2,
        Parent = notif
    })
    
    local gradient = Create("UIGradient", {
        Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 200, 200))
        },
        Rotation = 90,
        Parent = notif
    })
    
    local label = Create("TextLabel", {
        Size = UDim2.new(1, -20, 1, -20),
        Position = UDim2.new(0, 10, 0, 10),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = Library.Theme.Text,
        TextSize = 14,
        Font = Enum.Font.GothamBold,
        TextWrapped = true,
        Parent = notif
    })
    
    Tween(notif, {Position = UDim2.new(1, -310, 1, -70)}, 0.5, Enum.EasingStyle.Back)
    
    task.delay(duration, function()
        Tween(notif, {Position = UDim2.new(1, -310, 1, 10)}, 0.3)
        task.wait(0.3)
        notif:Destroy()
    end)
end

function Library:CreateWindow(config)
    config = config or {}
    config.Name = config.Name or "UI Library"
    config.Size = config.Size or UDim2.new(0, 600, 0, 500)
    
    local Window = {
        Tabs = {},
        CurrentTab = nil
    }
    
    local Main = Create("Frame", {
        Size = config.Size,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Library.Theme.Main,
        BorderSizePixel = 0,
        Parent = ScreenGui
    })
    
    Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = Main})
    
    local glow = Create("ImageLabel", {
        Size = UDim2.new(1, 40, 1, 40),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        Image = "rbxassetid://5028857084",
        ImageColor3 = Library.Theme.Accent,
        ImageTransparency = 0.7,
        ZIndex = 0,
        Parent = Main
    })
    
    local Topbar = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = Library.Theme.Second,
        BorderSizePixel = 0,
        Parent = Main
    })
    
    Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = Topbar})
    
    local TopbarGradient = Create("UIGradient", {
        Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 180, 180))
        },
        Rotation = 90,
        Parent = Topbar
    })
    
    local Title = Create("TextLabel", {
        Size = UDim2.new(0, 200, 1, 0),
        Position = UDim2.new(0, 15, 0, 0),
        BackgroundTransparency = 1,
        Text = config.Name,
        TextColor3 = Library.Theme.Text,
        TextSize = 16,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = Topbar
    })
    
    local Username = Create("TextLabel", {
        Size = UDim2.new(0, 150, 1, 0),
        Position = UDim2.new(1, -165, 0, 0),
        BackgroundTransparency = 1,
        Text = LocalPlayer.Name,
        TextColor3 = Library.Theme.TextDark,
        TextSize = 13,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Right,
        Parent = Topbar
    })
    
    local TabContainer = Create("Frame", {
        Size = UDim2.new(0, 60, 1, -50),
        Position = UDim2.new(0, 5, 0, 45),
        BackgroundTransparency = 1,
        Parent = Main
    })
    
    Create("UIListLayout", {
        Padding = UDim.new(0, 5),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = TabContainer
    })
    
    local ContentContainer = Create("Frame", {
        Size = UDim2.new(1, -75, 1, -50),
        Position = UDim2.new(0, 70, 0, 45),
        BackgroundTransparency = 1,
        Parent = Main
    })
    
    local dragging, dragInput, dragStart, startPos
    
    Topbar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = Main.Position
            
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
    
    RunService.RenderStepped:Connect(function()
        if dragging and dragInput then
            local delta = dragInput.Position - dragStart
            Tween(Main, {Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)}, 0.1, Enum.EasingStyle.Linear)
        end
    end)
    
    local resizing = false
    local resizeStart
    local resizeStartSize
    
    local ResizeButton = Create("TextButton", {
        Size = UDim2.new(0, 20, 0, 20),
        Position = UDim2.new(1, -20, 1, -20),
        BackgroundColor3 = Library.Theme.Accent,
        BorderSizePixel = 0,
        Text = "",
        Parent = Main
    })
    
    Create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = ResizeButton})
    
    ResizeButton.MouseButton1Down:Connect(function()
        resizing = true
        resizeStart = UserInputService:GetMouseLocation()
        resizeStartSize = Main.Size
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            resizing = false
        end
    end)
    
    RunService.RenderStepped:Connect(function()
        if resizing then
            local mouse = UserInputService:GetMouseLocation()
            local delta = mouse - resizeStart
            local newSize = UDim2.new(0, math.max(400, resizeStartSize.X.Offset + delta.X), 0, math.max(300, resizeStartSize.Y.Offset + delta.Y))
            Main.Size = newSize
        end
    end)
    
    function Window:AddTab(config)
        config = config or {}
        config.Name = config.Name or "Tab"
        config.Icon = config.Icon or "6588984328"
        
        local Tab = {
            Sections = {},
            Content = nil
        }
        
        local TabButton = Create("TextButton", {
            Size = UDim2.new(1, 0, 0, 50),
            BackgroundColor3 = Library.Theme.Second,
            BorderSizePixel = 0,
            Text = "",
            AutoButtonColor = false,
            Parent = TabContainer
        })
        
        Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = TabButton})
        
        local TabIcon = Create("ImageLabel", {
            Size = UDim2.new(0, 30, 0, 30),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundTransparency = 1,
            Image = "rbxassetid://" .. config.Icon,
            ImageColor3 = Library.Theme.TextDark,
            Parent = TabButton
        })
        
        local TabContent = Create("ScrollingFrame", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ScrollBarThickness = 4,
            ScrollBarImageColor3 = Library.Theme.Accent,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            Visible = false,
            Parent = ContentContainer
        })
        
        Create("UIListLayout", {
            Padding = UDim.new(0, 10),
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = TabContent
        })
        
        TabContent:GetPropertyChangedSignal("AbsoluteCanvasSize"):Connect(function()
            TabContent.CanvasSize = UDim2.new(0, 0, 0, TabContent.UIListLayout.AbsoluteContentSize.Y + 10)
        end)
        
        Tab.Content = TabContent
        
        TabButton.MouseButton1Click:Connect(function()
            for _, tab in pairs(Window.Tabs) do
                tab.Content.Visible = false
                Tween(tab.Button.ImageLabel, {ImageColor3 = Library.Theme.TextDark}, 0.2)
                Tween(tab.Button, {BackgroundColor3 = Library.Theme.Second}, 0.2)
            end
            
            Tween(TabIcon, {ImageColor3 = Library.Theme.Accent}, 0.2)
            Tween(TabButton, {BackgroundColor3 = Library.Theme.Third}, 0.2)
            TabContent.Visible = true
            Window.CurrentTab = Tab
        end)
        
        Tab.Button = TabButton
        
        function Tab:AddSection(name)
            local Section = {
                Elements = {}
            }
            
            local SectionFrame = Create("Frame", {
                Size = UDim2.new(0.48, 0, 0, 0),
                BackgroundColor3 = Library.Theme.Second,
                BorderSizePixel = 0,
                Parent = TabContent
            })
            
            Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = SectionFrame})
            
            local SectionGradient = Create("UIGradient", {
                Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(220, 220, 220))
                },
                Rotation = 90,
                Transparency = NumberSequence.new(0.95),
                Parent = SectionFrame
            })
            
            local SectionTitle = Create("TextLabel", {
                Size = UDim2.new(1, -20, 0, 30),
                Position = UDim2.new(0, 10, 0, 5),
                BackgroundTransparency = 1,
                Text = name,
                TextColor3 = Library.Theme.Text,
                TextSize = 15,
                Font = Enum.Font.GothamBold,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = SectionFrame
            })
            
            local SectionContent = Create("Frame", {
                Size = UDim2.new(1, -20, 1, -40),
                Position = UDim2.new(0, 10, 0, 35),
                BackgroundTransparency = 1,
                Parent = SectionFrame
            })
            
            Create("UIListLayout", {
                Padding = UDim.new(0, 8),
                SortOrder = Enum.SortOrder.LayoutOrder,
                Parent = SectionContent
            })
            
            local function UpdateSize()
                SectionFrame.Size = UDim2.new(0.48, 0, 0, SectionContent.UIListLayout.AbsoluteContentSize.Y + 45)
            end
            
            SectionContent:GetPropertyChangedSignal("AbsoluteSize"):Connect(UpdateSize)
            
            function Section:AddToggle(config)
                config = config or {}
                config.Name = config.Name or "Toggle"
                config.Default = config.Default or false
                config.Flag = config.Flag
                config.Callback = config.Callback or function() end
                
                local Toggle = {
                    Value = config.Default
                }
                
                local ToggleFrame = Create("Frame", {
                    Size = UDim2.new(1, 0, 0, 35),
                    BackgroundColor3 = Library.Theme.Third,
                    BorderSizePixel = 0,
                    Parent = SectionContent
                })
                
                Create("UICorner", {CornerRadius = UDim.new(0, 5), Parent = ToggleFrame})
                
                local ToggleButton = Create("TextButton", {
                    Size = UDim2.new(0, 40, 0, 20),
                    Position = UDim2.new(1, -50, 0.5, 0),
                    AnchorPoint = Vector2.new(0, 0.5),
                    BackgroundColor3 = config.Default and Library.Theme.Accent or Library.Theme.Main,
                    BorderSizePixel = 0,
                    Text = "",
                    AutoButtonColor = false,
                    Parent = ToggleFrame
                })
                
                Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = ToggleButton})
                
                local ToggleIndicator = Create("Frame", {
                    Size = UDim2.new(0, 16, 0, 16),
                    Position = config.Default and UDim2.new(1, -18, 0.5, 0) or UDim2.new(0, 2, 0.5, 0),
                    AnchorPoint = Vector2.new(0, 0.5),
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    BorderSizePixel = 0,
                    Parent = ToggleButton
                })
                
                Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = ToggleIndicator})
                
                local Checkmark = Create("TextLabel", {
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundTransparency = 1,
                    Text = "✓",
                    TextColor3 = Color3.fromRGB(255, 255, 255),
                    TextSize = 16,
                    Font = Enum.Font.GothamBold,
                    Visible = config.Default,
                    Parent = ToggleButton
                })
                
                local ToggleLabel = Create("TextLabel", {
                    Size = UDim2.new(1, -60, 1, 0),
                    Position = UDim2.new(0, 10, 0, 0),
                    BackgroundTransparency = 1,
                    Text = config.Name,
                    TextColor3 = Library.Theme.Text,
                    TextSize = 14,
                    Font = Enum.Font.Gotham,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = ToggleFrame
                })
                
                function Toggle:SetValue(val)
                    Toggle.Value = val
                    Tween(ToggleButton, {BackgroundColor3 = val and Library.Theme.Accent or Library.Theme.Main}, 0.2)
                    Tween(ToggleIndicator, {Position = val and UDim2.new(1, -18, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)}, 0.2)
                    Checkmark.Visible = val
                    
                    if config.Flag then
                        Library.Flags[config.Flag] = val
                    end
                    
                    pcall(config.Callback, val)
                end
                
                ToggleButton.MouseButton1Click:Connect(function()
                    Toggle:SetValue(not Toggle.Value)
                end)
                
                if config.Flag then
                    Library.Flags[config.Flag] = config.Default
                    Toggles[config.Flag] = Toggle
                end
                
                UpdateSize()
                return Toggle
            end
            
            function Section:AddButton(config)
                config = config or {}
                config.Name = config.Name or "Button"
                config.Callback = config.Callback or function() end
                
                local ButtonFrame = Create("TextButton", {
                    Size = UDim2.new(1, 0, 0, 35),
                    BackgroundColor3 = Library.Theme.Third,
                    BorderSizePixel = 0,
                    Text = "",
                    AutoButtonColor = false,
                    Parent = SectionContent
                })
                
                Create("UICorner", {CornerRadius = UDim.new(0, 5), Parent = ButtonFrame})
                
                local ButtonLabel = Create("TextLabel", {
                    Size = UDim2.new(1, -20, 1, 0),
                    Position = UDim2.new(0, 10, 0, 0),
                    BackgroundTransparency = 1,
                    Text = config.Name,
                    TextColor3 = Library.Theme.Text,
                    TextSize = 14,
                    Font = Enum.Font.Gotham,
                    Parent = ButtonFrame
                })
                
                ButtonFrame.MouseButton1Click:Connect(function()
                    Tween(ButtonFrame, {BackgroundColor3 = Library.Theme.Accent}, 0.1)
                    task.wait(0.1)
                    Tween(ButtonFrame, {BackgroundColor3 = Library.Theme.Third}, 0.1)
                    pcall(config.Callback)
                end)
                
                UpdateSize()
            end
            
            function Section:AddSlider(config)
                config = config or {}
                config.Name = config.Name or "Slider"
                config.Min = config.Min or 0
                config.Max = config.Max or 100
                config.Default = config.Default or 50
                config.Increment = config.Increment or 1
                config.Flag = config.Flag
                config.Callback = config.Callback or function() end
                
                local Slider = {
                    Value = config.Default,
                    Dragging = false
                }
                
                local SliderFrame = Create("Frame", {
                    Size = UDim2.new(1, 0, 0, 45),
                    BackgroundColor3 = Library.Theme.Third,
                    BorderSizePixel = 0,
                    Parent = SectionContent
                })
                
                Create("UICorner", {CornerRadius = UDim.new(0, 5), Parent = SliderFrame})
                
                local SliderLabel = Create("TextLabel", {
                    Size = UDim2.new(1, -20, 0, 20),
                    Position = UDim2.new(0, 10, 0, 5),
                    BackgroundTransparency = 1,
                    Text = config.Name,
                    TextColor3 = Library.Theme.Text,
                    TextSize = 13,
                    Font = Enum.Font.Gotham,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = SliderFrame
                })
                
                local SliderValue = Create("TextLabel", {
                    Size = UDim2.new(0, 50, 0, 20),
                    Position = UDim2.new(1, -60, 0, 5),
                    BackgroundTransparency = 1,
                    Text = tostring(config.Default),
                    TextColor3 = Library.Theme.Accent,
                    TextSize = 13,
                    Font = Enum.Font.GothamBold,
                    TextXAlignment = Enum.TextXAlignment.Right,
                    Parent = SliderFrame
                })
                
                local SliderBar = Create("Frame", {
                    Size = UDim2.new(1, -20, 0, 4),
                    Position = UDim2.new(0, 10, 1, -12),
                    BackgroundColor3 = Library.Theme.Main,
                    BorderSizePixel = 0,
                    Parent = SliderFrame
                })
                
                Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = SliderBar})
                
                local SliderFill = Create("Frame", {
                    Size = UDim2.new((config.Default - config.Min) / (config.Max - config.Min), 0, 1, 0),
                    BackgroundColor3 = Library.Theme.Accent,
                    BorderSizePixel = 0,
                    Parent = SliderBar
                })
                
                Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = SliderFill})
                
                local SliderDot = Create("Frame", {
                    Size = UDim2.new(0, 12, 0, 12),
                    Position = UDim2.new(1, -6, 0.5, 0),
                    AnchorPoint = Vector2.new(0, 0.5),
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    BorderSizePixel = 0,
                    Parent = SliderFill
                })
                
                Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = SliderDot})
                
                function Slider:SetValue(val)
                    val = math.clamp(val, config.Min, config.Max)
                    val = math.floor(val / config.Increment + 0.5) * config.Increment
                    Slider.Value = val
                    
                    local percent = (val - config.Min) / (config.Max - config.Min)
                    SliderFill.Size = UDim2.new(percent, 0, 1, 0)
                    SliderValue.Text = tostring(val)
                    
                    if config.Flag then
                        Library.Flags[config.Flag] = val
                    end
                    
                    pcall(config.Callback, val)
                end
                
                SliderBar.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        Slider.Dragging = true
                        local function Update()
                            local pos = math.clamp((Mouse.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
                            local value = config.Min + ((config.Max - config.Min) * pos)
                            Slider:SetValue(value)
                        end
                        Update()
                        local connection
                        connection = input.Changed:Connect(function()
                            if input.UserInputState == Enum.UserInputState.End then
                                Slider.Dragging = false
                                connection:Disconnect()
                            end
                        end)
                    end
                end)
                
                UserInputService.InputChanged:Connect(function(input)
                    if Slider.Dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                        local pos = math.clamp((Mouse.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
                        local value = config.Min + ((config.Max - config.Min) * pos)
                        Slider:SetValue(value)
                    end
                end)
                
                if config.Flag then
                    Library.Flags[config.Flag] = config.Default
                    Options[config.Flag] = Slider
                end
                
                UpdateSize()
                return Slider
            end
            
            function Section:AddDropdown(config)
                config = config or {}
                config.Name = config.Name or "Dropdown"
                config.Options = config.Options or {}
                config.Default = config.Default or config.Options[1]
                config.Flag = config.Flag
                config.Callback = config.Callback or function() end
                
                local Dropdown = {
                    Value = config.Default,
                    Options = config.Options,
                    Open = false
                }
                
                local DropdownFrame = Create("Frame", {
                    Size = UDim2.new(1, 0, 0, 35),
                    BackgroundColor3 = Library.Theme.Third,
                    BorderSizePixel = 0,
                    Parent = SectionContent
                })
                
                Create("UICorner", {CornerRadius = UDim.new(0, 5), Parent = DropdownFrame})
                
                local DropdownLabel = Create("TextLabel", {
                    Size = UDim2.new(1, -60, 1, 0),
                    Position = UDim2.new(0, 10, 0, 0),
                    BackgroundTransparency = 1,
                    Text = config.Name .. ": " .. (config.Default or "None"),
                    TextColor3 = Library.Theme.Text,
                    TextSize = 14,
                    Font = Enum.Font.Gotham,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = DropdownFrame
                })
                
                local DropdownButton = Create("TextButton", {
                    Size = UDim2.new(0, 30, 0, 25),
                    Position = UDim2.new(1, -40, 0.5, 0),
                    AnchorPoint = Vector2.new(0, 0.5),
                    BackgroundColor3 = Library.Theme.Main,
                    BorderSizePixel = 0,
                    Text = "▼",
                    TextColor3 = Library.Theme.Text,
                    TextSize = 12,
                    Font = Enum.Font.Gotham,
                    AutoButtonColor = false,
                    Parent = DropdownFrame
                })
                
                Create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = DropdownButton})
                
                local DropdownList = Create("Frame", {
                    Size = UDim2.new(1, 0, 0, 0),
                    Position = UDim2.new(0, 0, 1, 5),
                    BackgroundColor3 = Library.Theme.Second,
                    BorderSizePixel = 0,
                    Visible = false,
                    ZIndex = 10,
                    ClipsDescendants = true,
                    Parent = DropdownFrame
                })
                
                Create("UICorner", {CornerRadius = UDim.new(0, 5), Parent = DropdownList})
                
                local DropdownScroll = Create("ScrollingFrame", {
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    ScrollBarThickness = 3,
                    ScrollBarImageColor3 = Library.Theme.Accent,
                    CanvasSize = UDim2.new(0, 0, 0, 0),
                    Parent = DropdownList
                })
                
                Create("UIListLayout", {
                    Padding = UDim.new(0, 2),
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    Parent = DropdownScroll
                })
                
                DropdownScroll:GetPropertyChangedSignal("AbsoluteCanvasSize"):Connect(function()
                    DropdownScroll.CanvasSize = UDim2.new(0, 0, 0, DropdownScroll.UIListLayout.AbsoluteContentSize.Y)
                end)
                
                function Dropdown:Refresh(options)
                    Dropdown.Options = options or Dropdown.Options
                    for _, child in pairs(DropdownScroll:GetChildren()) do
                        if child:IsA("TextButton") then
                            child:Destroy()
                        end
                    end
                    
                    for _, option in pairs(Dropdown.Options) do
                        local OptionButton = Create("TextButton", {
                            Size = UDim2.new(1, -4, 0, 30),
                            BackgroundColor3 = Library.Theme.Third,
                            BorderSizePixel = 0,
                            Text = option,
                            TextColor3 = Library.Theme.Text,
                            TextSize = 13,
                            Font = Enum.Font.Gotham,
                            AutoButtonColor = false,
                            Parent = DropdownScroll
                        })
                        
                        Create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = OptionButton})
                        
                        OptionButton.MouseButton1Click:Connect(function()
                            Dropdown:SetValue(option)
                            Dropdown:Toggle()
                        end)
                        
                        OptionButton.MouseEnter:Connect(function()
                            Tween(OptionButton, {BackgroundColor3 = Library.Theme.Accent}, 0.2)
                        end)
                        
                        OptionButton.MouseLeave:Connect(function()
                            Tween(OptionButton, {BackgroundColor3 = Library.Theme.Third}, 0.2)
                        end)
                    end
                end
                
                function Dropdown:SetValue(val)
                    Dropdown.Value = val
                    DropdownLabel.Text = config.Name .. ": " .. val
                    
                    if config.Flag then
                        Library.Flags[config.Flag] = val
                    end
                    
                    pcall(config.Callback, val)
                end
                
                function Dropdown:Toggle()
                    Dropdown.Open = not Dropdown.Open
                    local targetSize = Dropdown.Open and math.min(#Dropdown.Options * 32, 150) or 0
                    
                    Tween(DropdownList, {Size = UDim2.new(1, 0, 0, targetSize)}, 0.3)
                    Tween(DropdownButton, {Rotation = Dropdown.Open and 180 or 0}, 0.3)
                    DropdownList.Visible = true
                    
                    if not Dropdown.Open then
                        task.wait(0.3)
                        DropdownList.Visible = false
                    end
                end
                
                DropdownButton.MouseButton1Click:Connect(function()
                    Dropdown:Toggle()
                end)
                
                Dropdown:Refresh()
                
                if config.Flag then
                    Library.Flags[config.Flag] = config.Default
                    Options[config.Flag] = Dropdown
                end
                
                UpdateSize()
                return Dropdown
            end
            
            function Section:AddKeybind(config)
                config = config or {}
                config.Name = config.Name or "Keybind"
                config.Default = config.Default or Enum.KeyCode.E
                config.Flag = config.Flag
                config.Callback = config.Callback or function() end
                
                local Keybind = {
                    Value = config.Default,
                    Binding = false,
                    Active = false
                }
                
                local KeybindFrame = Create("Frame", {
                    Size = UDim2.new(1, 0, 0, 35),
                    BackgroundColor3 = Library.Theme.Third,
                    BorderSizePixel = 0,
                    Parent = SectionContent
                })
                
                Create("UICorner", {CornerRadius = UDim.new(0, 5), Parent = KeybindFrame})
                
                local KeybindLabel = Create("TextLabel", {
                    Size = UDim2.new(1, -100, 1, 0),
                    Position = UDim2.new(0, 10, 0, 0),
                    BackgroundTransparency = 1,
                    Text = config.Name,
                    TextColor3 = Library.Theme.Text,
                    TextSize = 14,
                    Font = Enum.Font.Gotham,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = KeybindFrame
                })
                
                local KeybindButton = Create("TextButton", {
                    Size = UDim2.new(0, 80, 0, 25),
                    Position = UDim2.new(1, -90, 0.5, 0),
                    AnchorPoint = Vector2.new(0, 0.5),
                    BackgroundColor3 = Library.Theme.Main,
                    BorderSizePixel = 0,
                    Text = config.Default.Name,
                    TextColor3 = Library.Theme.Text,
                    TextSize = 12,
                    Font = Enum.Font.Gotham,
                    AutoButtonColor = false,
                    Parent = KeybindFrame
                })
                
                Create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = KeybindButton})
                
                function Keybind:SetValue(key)
                    Keybind.Value = key
                    KeybindButton.Text = key.Name
                    
                    if config.Flag then
                        Library.Flags[config.Flag] = key
                    end
                end
                
                KeybindButton.MouseButton1Click:Connect(function()
                    Keybind.Binding = true
                    KeybindButton.Text = "..."
                    
                    local connection
                    connection = UserInputService.InputBegan:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.Keyboard then
                            Keybind:SetValue(input.KeyCode)
                            Keybind.Binding = false
                            connection:Disconnect()
                        end
                    end)
                end)
                
                UserInputService.InputBegan:Connect(function(input)
                    if not Keybind.Binding and input.KeyCode == Keybind.Value then
                        Keybind.Active = true
                        table.insert(Library.KeybindList, {Name = config.Name, Active = true})
                        pcall(config.Callback, true)
                    end
                end)
                
                UserInputService.InputEnded:Connect(function(input)
                    if input.KeyCode == Keybind.Value and Keybind.Active then
                        Keybind.Active = false
                        for i, kb in pairs(Library.KeybindList) do
                            if kb.Name == config.Name then
                                table.remove(Library.KeybindList, i)
                                break
                            end
                        end
                        pcall(config.Callback, false)
                    end
                end)
                
                if config.Flag then
                    Library.Flags[config.Flag] = config.Default
                    Options[config.Flag] = Keybind
                end
                
                UpdateSize()
                return Keybind
            end
            
            function Section:AddColorPicker(config)
                config = config or {}
                config.Name = config.Name or "Color"
                config.Default = config.Default or Color3.fromRGB(255, 255, 255)
                config.Flag = config.Flag
                config.Callback = config.Callback or function() end
                
                local ColorPicker = {
                    Value = config.Default
                }
                
                local PickerFrame = Create("Frame", {
                    Size = UDim2.new(1, 0, 0, 35),
                    BackgroundColor3 = Library.Theme.Third,
                    BorderSizePixel = 0,
                    Parent = SectionContent
                })
                
                Create("UICorner", {CornerRadius = UDim.new(0, 5), Parent = PickerFrame})
                
                local PickerLabel = Create("TextLabel", {
                    Size = UDim2.new(1, -60, 1, 0),
                    Position = UDim2.new(0, 10, 0, 0),
                    BackgroundTransparency = 1,
                    Text = config.Name,
                    TextColor3 = Library.Theme.Text,
                    TextSize = 14,
                    Font = Enum.Font.Gotham,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = PickerFrame
                })
                
                local ColorDisplay = Create("TextButton", {
                    Size = UDim2.new(0, 40, 0, 25),
                    Position = UDim2.new(1, -50, 0.5, 0),
                    AnchorPoint = Vector2.new(0, 0.5),
                    BackgroundColor3 = config.Default,
                    BorderSizePixel = 0,
                    Text = "",
                    AutoButtonColor = false,
                    Parent = PickerFrame
                })
                
                Create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = ColorDisplay})
                Create("UIStroke", {
                    Color = Library.Theme.Outline,
                    Thickness = 2,
                    Parent = ColorDisplay
                })
                
                function ColorPicker:SetValue(color)
                    ColorPicker.Value = color
                    ColorDisplay.BackgroundColor3 = color
                    
                    if config.Flag then
                        Library.Flags[config.Flag] = color
                    end
                    
                    pcall(config.Callback, color)
                end
                
                ColorDisplay.MouseButton1Click:Connect(function()
                    Library:Notify("Color picker opened for: " .. config.Name, 2)
                end)
                
                if config.Flag then
                    Library.Flags[config.Flag] = config.Default
                    Options[config.Flag] = ColorPicker
                end
                
                UpdateSize()
                return ColorPicker
            end
            
            function Section:AddLabel(text)
                local LabelFrame = Create("TextLabel", {
                    Size = UDim2.new(1, 0, 0, 25),
                    BackgroundTransparency = 1,
                    Text = text,
                    TextColor3 = Library.Theme.TextDark,
                    TextSize = 13,
                    Font = Enum.Font.Gotham,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextWrapped = true,
                    Parent = SectionContent
                })
                
                UpdateSize()
                return LabelFrame
            end
            
            function Section:AddImage(config)
                config = config or {}
                config.Image = config.Image or "6588984328"
                config.Size = config.Size or UDim2.new(0, 100, 0, 100)
                
                local ImageFrame = Create("ImageLabel", {
                    Size = config.Size,
                    BackgroundTransparency = 1,
                    Image = "rbxassetid://" .. config.Image,
                    ScaleType = Enum.ScaleType.Fit,
                    Parent = SectionContent
                })
                
                UpdateSize()
                return ImageFrame
            end
            
            table.insert(Tab.Sections, Section)
            return Section
        end
        
        table.insert(Window.Tabs, Tab)
        
        if #Window.Tabs == 1 then
            TabButton.MouseButton1Click:Fire()
        end
        
        return Tab
    end
    
    local SettingsTab = Window:AddTab({Name = "Settings", Icon = "82085214486223"})
    local UISection = SettingsTab:AddSection("UI Settings")
    
    UISection:AddToggle({
        Name = "Show Watermark",
        Default = true,
        Callback = function(val)
            if Library.Watermark then
                Library.Watermark.Visible = val
            end
        end
    })
    
    UISection:AddToggle({
        Name = "Show Keybind List",
        Default = true,
        Callback = function(val)
            if Library.KeybindFrame then
                Library.KeybindFrame.Visible = val
            end
        end
    })
    
    UISection:AddColorPicker({
        Name = "Accent Color",
        Default = Library.Theme.Accent,
        Callback = function(color)
            Library.Theme.Accent = color
        end
    })
    
    UISection:AddDropdown({
        Name = "Tween Style",
        Options = {"Linear", "Quad", "Cubic", "Quart", "Quint", "Sine", "Expo", "Circular", "Elastic", "Back", "Bounce"},
        Default = "Quad",
        Callback = function(style)
            Library.TweenStyle = Enum.EasingStyle[style]
        end
    })
    
    local WatermarkFrame = Create("Frame", {
        Size = UDim2.new(0, 250, 0, 40),
        Position = UDim2.new(0, 10, 0, 10),
        BackgroundColor3 = Library.Theme.Second,
        BorderSizePixel = 0,
        Parent = ScreenGui
    })
    
    Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = WatermarkFrame})
    Create("UIStroke", {
        Color = Library.Theme.Accent,
        Thickness = 2,
        Parent = WatermarkFrame
    })
    
    local WatermarkGradient = Create("UIGradient", {
        Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 200, 200))
        },
        Rotation = 90,
        Parent = WatermarkFrame
    })
    
    local WatermarkText = Create("TextLabel", {
        Size = UDim2.new(1, -20, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = "",
        TextColor3 = Library.Theme.Text,
        TextSize = 13,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = WatermarkFrame
    })
    
    Library.Watermark = WatermarkFrame
    
    local KeybindListFrame = Create("Frame", {
        Size = UDim2.new(0, 200, 0, 100),
        Position = UDim2.new(1, -210, 0, 10),
        BackgroundColor3 = Library.Theme.Second,
        BorderSizePixel = 0,
        Parent = ScreenGui
    })
    
    Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = KeybindListFrame})
    Create("UIStroke", {
        Color = Library.Theme.Accent,
        Thickness = 2,
        Parent = KeybindListFrame
    })
    
    local KeybindTitle = Create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundTransparency = 1,
        Text = "Keybinds",
        TextColor3 = Library.Theme.Text,
        TextSize = 14,
        Font = Enum.Font.GothamBold,
        Parent = KeybindListFrame
    })
    
    local KeybindContainer = Create("Frame", {
        Size = UDim2.new(1, -10, 1, -40),
        Position = UDim2.new(0, 5, 0, 35),
        BackgroundTransparency = 1,
        Parent = KeybindListFrame
    })
    
    Create("UIListLayout", {
        Padding = UDim.new(0, 5),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = KeybindContainer
    })
    
    Library.KeybindFrame = KeybindListFrame
    
    local draggingWatermark = false
    local dragInputWatermark
    local dragStartWatermark
    local startPosWatermark
    
    WatermarkFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            draggingWatermark = true
            dragStartWatermark = input.Position
            startPosWatermark = WatermarkFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    draggingWatermark = false
                end
            end)
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            if draggingWatermark then
                local delta = input.Position - dragStartWatermark
                WatermarkFrame.Position = UDim2.new(startPosWatermark.X.Scale, startPosWatermark.X.Offset + delta.X, startPosWatermark.Y.Scale, startPosWatermark.Y.Offset + delta.Y)
            end
        end
    end)
    
    local draggingKeybind = false
    local dragInputKeybind
    local dragStartKeybind
    local startPosKeybind
    
    KeybindListFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            draggingKeybind = true
            dragStartKeybind = input.Position
            startPosKeybind = KeybindListFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    draggingKeybind = false
                end
            end)
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            if draggingKeybind then
                local delta = input.Position - dragStartKeybind
                KeybindListFrame.Position = UDim2.new(startPosKeybind.X.Scale, startPosKeybind.X.Offset + delta.X, startPosKeybind.Y.Scale, startPosKeybind.Y.Offset + delta.Y)
            end
        end
    end)
    
    RunService.RenderStepped:Connect(function()
        local time = os.date("*t")
        local scriptName = config.Name or "UI Library"
        WatermarkText.Text = string.format("%s | %s | %02d:%02d:%02d", scriptName, LocalPlayer.Name, time.hour, time.min, time.sec)
        
        for i, child in pairs(KeybindContainer:GetChildren()) do
            if child:IsA("Frame") then
                child:Destroy()
            end
        end
        
        for i, keybind in pairs(Library.KeybindList) do
            local KeybindEntry = Create("Frame", {
                Size = UDim2.new(1, 0, 0, 25),
                BackgroundColor3 = Library.Theme.Third,
                BorderSizePixel = 0,
                Parent = KeybindContainer
            })
            
            Create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = KeybindEntry})
            
            local KeybindName = Create("TextLabel", {
                Size = UDim2.new(1, -10, 1, 0),
                Position = UDim2.new(0, 5, 0, 0),
                BackgroundTransparency = 1,
                Text = keybind.Name,
                TextColor3 = keybind.Active and Library.Theme.Accent or Library.Theme.Text,
                TextSize = 12,
                Font = Enum.Font.Gotham,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = KeybindEntry
            })
        end
        
        KeybindListFrame.Size = UDim2.new(0, 200, 0, math.max(100, 40 + (#Library.KeybindList * 30)))
    end)
    
    return Window
end

return Library
