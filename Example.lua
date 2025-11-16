-- Enhanced Linoria Library Example Script
-- Written for your custom Linoria implementation

local repo = 'https://raw.githubusercontent.com/joshisfit/joshlib/refs/heads/main/Library.lua'

-- Load the library (adjust the path to your library location)
local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()

-- If using local files, you can do:
-- local Library = loadstring(readfile('Library.lua'))()

-- Create the main window
local Window = Library:CreateWindow({
    Title = 'My Custom Script',
    Center = true,
    AutoShow = true,
    TabPadding = 8,
    MenuFadeTime = 0.2
})

-- IMPORTANT: Callbacks can be passed directly OR set up via :OnChanged()
-- The recommended approach is to create UI elements first, then set up callbacks

-- Create tabs
local Tabs = {
    Main = Window:AddTab('Main'),
    Combat = Window:AddTab('Combat'),
    Visuals = Window:AddTab('Visuals'),
    Misc = Window:AddTab('Misc'),
    Settings = Window:AddTab('UI Settings'),
}

-- ==================== MAIN TAB ====================
local MainGroup = Tabs.Main:AddLeftGroupbox('Main Features')

-- Toggle example
MainGroup:AddToggle('SpeedHack', {
    Text = 'Speed Hack',
    Default = false,
    Tooltip = 'Increases your walk speed',
    
    Callback = function(Value)
        print('[cb] SpeedHack changed to:', Value)
    end
})

-- You can also set up callbacks this way (recommended):
Toggles.SpeedHack:OnChanged(function()
    local enabled = Toggles.SpeedHack.Value
    print('SpeedHack is now:', enabled)
    
    if enabled then
        -- Enable speed hack
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 50
    else
        -- Disable speed hack
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16
    end
end)

-- Slider example
MainGroup:AddSlider('SpeedAmount', {
    Text = 'Speed Multiplier',
    Default = 2,
    Min = 1,
    Max = 10,
    Rounding = 1,
    Compact = false,
    
    Callback = function(Value)
        print('[cb] Speed set to:', Value)
    end
})

Options.SpeedAmount:OnChanged(function()
    local speed = Options.SpeedAmount.Value
    if Toggles.SpeedHack.Value then
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16 * speed
    end
end)

-- Button example
MainGroup:AddButton({
    Text = 'Reset Character',
    Func = function()
        game.Players.LocalPlayer.Character.Humanoid.Health = 0
    end,
    DoubleClick = false,
    Tooltip = 'Kills your character'
})

-- Sub-button example
local TeleportButton = MainGroup:AddButton({
    Text = 'Teleport Menu',
    Func = function()
        print('Opening teleport menu...')
    end,
    Tooltip = 'Opens teleport options'
})

TeleportButton:AddButton({
    Text = 'Spawn',
    Func = function()
        local spawnLocation = workspace.SpawnLocation
        if spawnLocation then
            game.Players.LocalPlayer.Character:MoveTo(spawnLocation.Position)
        end
    end,
    DoubleClick = false,
    Tooltip = 'Teleports to spawn'
})

-- Divider
MainGroup:AddDivider()

-- Label
MainGroup:AddLabel('Character Settings')

-- Input/Textbox example
MainGroup:AddInput('CustomName', {
    Default = '',
    Numeric = false,
    Finished = true, -- Only calls callback when pressing Enter
    Text = 'Display Name',
    Tooltip = 'Set your custom display name',
    Placeholder = 'Enter name...',
    
    Callback = function(Value)
        print('[cb] Name set to:', Value)
    end
})

Options.CustomName:OnChanged(function()
    print('Name updated to:', Options.CustomName.Value)
end)

-- Dropdown example
MainGroup:AddDropdown('GameMode', {
    Values = { 'Normal', 'Hardcore', 'Easy', 'Custom' },
    Default = 1,
    Multi = false,
    Text = 'Game Mode',
    Tooltip = 'Select your preferred game mode',
    
    Callback = function(Value)
        print('[cb] Game mode changed to:', Value)
    end
})

Options.GameMode:OnChanged(function()
    print('Game mode is now:', Options.GameMode.Value)
end)

-- Multi-select dropdown
MainGroup:AddDropdown('EnabledFeatures', {
    Values = { 'ESP', 'Aimbot', 'Triggerbot', 'Bhop' },
    Default = 1,
    Multi = true,
    Text = 'Enabled Features',
    Tooltip = 'Select multiple features to enable',
    
    Callback = function(Value)
        print('[cb] Features changed')
    end
})

Options.EnabledFeatures:OnChanged(function()
    print('Enabled features:')
    for feature, enabled in pairs(Options.EnabledFeatures.Value) do
        if enabled then
            print('  -', feature)
        end
    end
end)

-- Player dropdown (special type)
MainGroup:AddDropdown('TargetPlayer', {
    SpecialType = 'Player',
    Text = 'Target Player',
    Tooltip = 'Select a player to target',
    
    Callback = function(Value)
        print('[cb] Targeting:', Value)
    end
})

-- ==================== RIGHT SIDE ====================
local RightGroup = Tabs.Main:AddRightGroupbox('Advanced')

-- Color picker example
RightGroup:AddLabel('Theme Color'):AddColorPicker('ThemeColor', {
    Default = Color3.fromRGB(0, 120, 255),
    Title = 'Choose Theme Color',
    Transparency = 0,
    
    Callback = function(Value)
        print('[cb] Color changed:', Value)
    end
})

Options.ThemeColor:OnChanged(function()
    print('Theme color:', Options.ThemeColor.Value)
    print('Transparency:', Options.ThemeColor.Transparency)
end)

-- Keybind example
RightGroup:AddLabel('Toggle Key'):AddKeyPicker('ToggleKey', {
    Default = 'E',
    SyncToggleState = false,
    Mode = 'Toggle', -- Always, Toggle, Hold
    Text = 'Feature Toggle',
    NoUI = false,
    
    Callback = function(Value)
        print('[cb] Keybind pressed!', Value)
    end,
    
    ChangedCallback = function(New)
        print('[cb] Keybind changed to:', New)
    end
})

Options.ToggleKey:OnClick(function()
    print('Toggle key pressed! State:', Options.ToggleKey:GetState())
end)

-- Blank space
RightGroup:AddBlank(10)

-- Wrapped label
RightGroup:AddLabel('This is a long label that will wrap to multiple lines when it gets too long for the groupbox width.', true)

-- ==================== TABBOX EXAMPLE ====================
local TabBox = Tabs.Main:AddRightTabbox()

local Tab1 = TabBox:AddTab('Weapons')
Tab1:AddToggle('InfiniteAmmo', { 
    Text = 'Infinite Ammo',
    Default = false,
    Tooltip = 'Never run out of ammo'
})

Tab1:AddToggle('NoRecoil', { 
    Text = 'No Recoil',
    Default = false 
})

local Tab2 = TabBox:AddTab('Movement')
Tab2:AddToggle('NoClip', { 
    Text = 'No Clip',
    Default = false 
})

Tab2:AddSlider('JumpPower', {
    Text = 'Jump Power',
    Default = 50,
    Min = 50,
    Max = 200,
    Rounding = 0
})

-- ==================== DEPENDENCY BOX EXAMPLE ====================
local DepGroup = Tabs.Combat:AddLeftGroupbox('Aimbot')

DepGroup:AddToggle('AimbotEnabled', {
    Text = 'Enable Aimbot',
    Default = false,
    Tooltip = 'Automatically aims at enemies'
})

-- Dependency box (only shows when AimbotEnabled is true)
local AimbotSettings = DepGroup:AddDependencyBox()

AimbotSettings:AddToggle('AimbotSmooth', {
    Text = 'Smooth Aim',
    Default = true
})

AimbotSettings:AddSlider('AimbotFOV', {
    Text = 'FOV Circle',
    Default = 100,
    Min = 50,
    Max = 500,
    Rounding = 0
})

AimbotSettings:AddDropdown('AimbotPart', {
    Values = { 'Head', 'Torso', 'Random' },
    Default = 1,
    Multi = false,
    Text = 'Target Part'
})

-- Setup the dependency
AimbotSettings:SetupDependencies({
    { Toggles.AimbotEnabled, true }
})

-- Nested dependency box example
local AdvancedAimbot = AimbotSettings:AddDependencyBox()

AdvancedAimbot:AddToggle('PredictMovement', {
    Text = 'Predict Movement',
    Default = false
})

AdvancedAimbot:AddSlider('PredictionAmount', {
    Text = 'Prediction',
    Default = 50,
    Min = 0,
    Max = 100,
    Rounding = 0,
    Suffix = '%'
})

-- This will only show when both AimbotEnabled AND AimbotSmooth are true
AdvancedAimbot:SetupDependencies({
    { Toggles.AimbotSmooth, true }
})

-- ==================== VISUALS TAB ====================
local VisualsGroup = Tabs.Visuals:AddLeftGroupbox('ESP')

VisualsGroup:AddToggle('BoxESP', {
    Text = 'Box ESP',
    Default = false
})

VisualsGroup:AddToggle('NameESP', {
    Text = 'Name ESP',
    Default = false
})

VisualsGroup:AddToggle('HealthESP', {
    Text = 'Health ESP',
    Default = false
})

VisualsGroup:AddDivider()

VisualsGroup:AddLabel('ESP Color'):AddColorPicker('ESPColor', {
    Default = Color3.fromRGB(255, 255, 255),
    Title = 'ESP Color',
    Transparency = 0.5
})

VisualsGroup:AddSlider('ESPThickness', {
    Text = 'Box Thickness',
    Default = 1,
    Min = 1,
    Max = 5,
    Rounding = 0,
    Suffix = 'px'
})

-- ==================== WATERMARK EXAMPLE ====================
Library:SetWatermarkVisibility(true)

local FrameTimer = tick()
local FrameCounter = 0
local FPS = 60

local WatermarkConnection = game:GetService('RunService').RenderStepped:Connect(function()
    FrameCounter = FrameCounter + 1
    
    if (tick() - FrameTimer) >= 1 then
        FPS = FrameCounter
        FrameTimer = tick()
        FrameCounter = 0
    end
    
    Library:SetWatermark(string.format(
        'My Script | %d fps | %d ms',
        math.floor(FPS),
        math.floor(game:GetService('Stats').Network.ServerStatsItem['Data Ping']:GetValue())
    ))
end)

-- Show keybind frame
Library.KeybindFrame.Visible = true

-- ==================== UI SETTINGS TAB ====================
local MenuGroup = Tabs.Settings:AddLeftGroupbox('Menu')

MenuGroup:AddButton({
    Text = 'Unload Script',
    Func = function() 
        Library:Unload() 
    end,
    DoubleClick = true,
    Tooltip = 'Double click to unload the script'
})

MenuGroup:AddLabel('Menu Keybind'):AddKeyPicker('MenuKeybind', {
    Default = 'RightControl',
    NoUI = true,
    Text = 'Menu toggle keybind',
    Mode = 'Toggle',
    
    ChangedCallback = function(New)
        print('Menu keybind changed to:', New)
    end
})

-- Set the menu keybind
Library.ToggleKeybind = Options.MenuKeybind

-- Notification examples
MenuGroup:AddButton({
    Text = 'Test Notification',
    Func = function()
        Library:Notify('This is a test notification!', 3)
    end,
    Tooltip = 'Shows a test notification'
})

-- ==================== UNLOAD HANDLER ====================
Library:OnUnload(function()
    WatermarkConnection:Disconnect()
    
    -- Clean up your script here
    print('Script unloaded!')
    Library.Unloaded = true
end)

-- ==================== INITIALIZATION ====================
print('Script loaded successfully!')
Library:Notify('Script loaded! Press RightControl to toggle menu.', 5)
