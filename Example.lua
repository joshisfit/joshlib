-- Enhanced Linoria UI Example
-- Showcasing the modernized UI with rounded corners, animations, and improved styling

local repo = 'https://raw.githubusercontent.com/joshisfit/joshlib/refs/heads/main/Library.lua'

-- Load the enhanced library (replace with your local path if needed)
local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()

-- Create the main window with enhanced styling
local Window = Library:CreateWindow({
    Title = 'Enhanced UI Demo',
    Center = true,
    AutoShow = true,
    TabPadding = 8,
    MenuFadeTime = 0.2
})

-- CALLBACK NOTE:
-- Using Toggles/Options.INDEX:OnChanged(function(Value) ... ) is the RECOMMENDED way
-- This keeps UI code separate from logic code

-- Create tabs
local Tabs = {
    Main = Window:AddTab('Main'),
    Combat = Window:AddTab('Combat'),
    Visuals = Window:AddTab('Visuals'),
    ['UI Settings'] = Window:AddTab('UI Settings'),
}

-- ===========================
-- MAIN TAB - Left Side
-- ===========================
local MainBox = Tabs.Main:AddLeftGroupbox('Main Features')

MainBox:AddToggle('AutoFarm', {
    Text = 'Auto Farm',
    Default = false,
    Tooltip = 'Automatically farms for you',
    Callback = function(Value)
        print('[AutoFarm] Status:', Value)
    end
})

MainBox:AddToggle('AutoCollect', {
    Text = 'Auto Collect Items',
    Default = false,
    Tooltip = 'Automatically collects nearby items',
})

MainBox:AddDivider()

MainBox:AddSlider('FarmSpeed', {
    Text = 'Farm Speed',
    Default = 1,
    Min = 0.5,
    Max = 5,
    Rounding = 1,
    Compact = false,
    Callback = function(Value)
        print('[FarmSpeed] Set to:', Value)
    end
})

MainBox:AddSlider('CollectRadius', {
    Text = 'Collection Radius',
    Default = 50,
    Min = 10,
    Max = 200,
    Rounding = 0,
    Suffix = ' studs',
})

MainBox:AddDivider()

MainBox:AddDropdown('FarmMode', {
    Values = { 'Closest', 'Highest Value', 'Random', 'Sequential' },
    Default = 1,
    Multi = false,
    Text = 'Farm Mode',
    Tooltip = 'Select farming priority',
    Callback = function(Value)
        print('[FarmMode] Changed to:', Value)
    end
})

MainBox:AddButton({
    Text = 'Start Farming',
    Func = function()
        print('Started farming!')
        Library:Notify('Farm started successfully!', 3)
    end,
    DoubleClick = false,
    Tooltip = 'Click to start farming'
})

-- ===========================
-- MAIN TAB - Right Side
-- ===========================
local TeleportBox = Tabs.Main:AddRightGroupbox('Teleports')

TeleportBox:AddDropdown('LocationSelect', {
    Values = { 'Spawn', 'Shop', 'Boss Arena', 'Secret Area', 'VIP Zone' },
    Default = 1,
    Multi = false,
    Text = 'Select Location',
})

TeleportBox:AddButton({
    Text = 'Teleport',
    Func = function()
        local location = Options.LocationSelect.Value
        print('Teleporting to:', location)
        Library:Notify('Teleported to ' .. location, 2)
    end,
    Tooltip = 'Teleport to selected location'
})

TeleportBox:AddDivider()

TeleportBox:AddToggle('SafeTeleport', {
    Text = 'Safe Teleport',
    Default = true,
    Tooltip = 'Prevents teleporting into walls',
})

local MiscBox = Tabs.Main:AddRightGroupbox('Miscellaneous')

MiscBox:AddToggle('NoClip', {
    Text = 'NoClip',
    Default = false,
    Tooltip = 'Walk through walls',
})

MiscBox:AddToggle('InfiniteJump', {
    Text = 'Infinite Jump',
    Default = false,
    Tooltip = 'Jump infinitely',
})

MiscBox:AddSlider('WalkSpeed', {
    Text = 'Walk Speed',
    Default = 16,
    Min = 16,
    Max = 100,
    Rounding = 0,
})

MiscBox:AddSlider('JumpPower', {
    Text = 'Jump Power',
    Default = 50,
    Min = 50,
    Max = 200,
    Rounding = 0,
})

-- ===========================
-- COMBAT TAB
-- ===========================
local CombatBox = Tabs.Combat:AddLeftGroupbox('Combat Features')

CombatBox:AddToggle('AutoAttack', {
    Text = 'Auto Attack',
    Default = false,
    Tooltip = 'Automatically attacks nearby enemies',
})

CombatBox:AddToggle('KillAura', {
    Text = 'Kill Aura',
    Default = false,
    Tooltip = 'Damages all enemies in range',
    Risky = true, -- Red text for risky features
})

CombatBox:AddDivider()

CombatBox:AddSlider('AttackRange', {
    Text = 'Attack Range',
    Default = 15,
    Min = 5,
    Max = 50,
    Rounding = 0,
    Suffix = ' studs',
})

CombatBox:AddSlider('AttackDelay', {
    Text = 'Attack Delay',
    Default = 0.5,
    Min = 0.1,
    Max = 2,
    Rounding = 1,
    Suffix = 's',
})

CombatBox:AddDivider()

CombatBox:AddDropdown('TargetPriority', {
    Values = { 'Closest', 'Lowest Health', 'Highest Health', 'Random' },
    Default = 1,
    Multi = false,
    Text = 'Target Priority',
})

local DefenseBox = Tabs.Combat:AddRightGroupbox('Defense')

DefenseBox:AddToggle('AutoHeal', {
    Text = 'Auto Heal',
    Default = false,
    Tooltip = 'Automatically heals when low HP',
})

DefenseBox:AddSlider('HealThreshold', {
    Text = 'Heal Threshold',
    Default = 50,
    Min = 10,
    Max = 90,
    Rounding = 0,
    Suffix = '%',
})

DefenseBox:AddDivider()

DefenseBox:AddToggle('AutoBlock', {
    Text = 'Auto Block',
    Default = false,
    Tooltip = 'Automatically blocks incoming attacks',
})

DefenseBox:AddToggle('DodgeAttacks', {
    Text = 'Auto Dodge',
    Default = false,
    Tooltip = 'Automatically dodges attacks',
})

-- ===========================
-- VISUALS TAB
-- ===========================
local ESPBox = Tabs.Visuals:AddLeftGroupbox('ESP')

ESPBox:AddToggle('PlayerESP', {
    Text = 'Player ESP',
    Default = false,
    Tooltip = 'See players through walls',
})

ESPBox:AddToggle('NPCEsp', {
    Text = 'NPC ESP',
    Default = false,
    Tooltip = 'See NPCs through walls',
})

ESPBox:AddToggle('ItemESP', {
    Text = 'Item ESP',
    Default = false,
    Tooltip = 'See items through walls',
})

ESPBox:AddDivider()

ESPBox:AddLabel('ESP Color'):AddColorPicker('ESPColor', {
    Default = Color3.fromRGB(255, 255, 255),
    Title = 'ESP Color',
    Transparency = 0,
    Callback = function(Value)
        print('[ESP Color] Changed to:', Value)
    end
})

ESPBox:AddSlider('ESPDistance', {
    Text = 'ESP Distance',
    Default = 1000,
    Min = 100,
    Max = 5000,
    Rounding = 0,
    Suffix = ' studs',
})

local AmbientBox = Tabs.Visuals:AddRightGroupbox('Ambient')

AmbientBox:AddToggle('Fullbright', {
    Text = 'Fullbright',
    Default = false,
    Tooltip = 'Makes everything bright',
})

AmbientBox:AddToggle('NoFog', {
    Text = 'No Fog',
    Default = false,
    Tooltip = 'Removes fog',
})

AmbientBox:AddDivider()

AmbientBox:AddLabel('Ambient Color'):AddColorPicker('AmbientColor', {
    Default = Color3.fromRGB(255, 255, 255),
    Title = 'Ambient Color',
})

AmbientBox:AddSlider('Brightness', {
    Text = 'Brightness',
    Default = 1,
    Min = 0,
    Max = 5,
    Rounding = 1,
})

local TracersBox = Tabs.Visuals:AddRightGroupbox('Tracers')

TracersBox:AddToggle('PlayerTracers', {
    Text = 'Player Tracers',
    Default = false,
    Tooltip = 'Draw lines to players',
})

TracersBox:AddLabel('Tracer Color'):AddColorPicker('TracerColor', {
    Default = Color3.fromRGB(255, 0, 0),
    Title = 'Tracer Color',
})

-- ===========================
-- TABBOX EXAMPLE
-- ===========================
local TabBox = Tabs.Main:AddLeftTabbox('Advanced Settings')

local Tab1 = TabBox:AddTab('Configuration')
Tab1:AddToggle('AutoSave', {
    Text = 'Auto Save Config',
    Default = true,
    Tooltip = 'Automatically saves your configuration'
})

Tab1:AddSlider('SaveInterval', {
    Text = 'Save Interval',
    Default = 60,
    Min = 30,
    Max = 300,
    Rounding = 0,
    Suffix = 's',
})

local Tab2 = TabBox:AddTab('Performance')
Tab2:AddToggle('LowGFX', {
    Text = 'Low Graphics Mode',
    Default = false,
    Tooltip = 'Reduces graphics for better performance'
})

Tab2:AddSlider('MaxFPS', {
    Text = 'Max FPS',
    Default = 60,
    Min = 30,
    Max = 240,
    Rounding = 0,
})

-- ===========================
-- DEPENDENCY BOX EXAMPLE
-- ===========================
local DepBox = Tabs.Combat:AddLeftGroupbox('Advanced Combat')

DepBox:AddToggle('AdvancedMode', {
    Text = 'Enable Advanced Mode',
    Default = false,
    Tooltip = 'Unlocks advanced combat features'
})

local DepBoxContent = DepBox:AddDependencyBox()
DepBoxContent:AddToggle('CriticalHits', {
    Text = 'Critical Hit Multiplier',
    Default = false,
})

DepBoxContent:AddSlider('CritMultiplier', {
    Text = 'Crit Multiplier',
    Default = 2,
    Min = 1,
    Max = 5,
    Rounding = 1,
    Suffix = 'x',
})

DepBoxContent:SetupDependencies({
    { Toggles.AdvancedMode, true }
})

-- ===========================
-- KEYBINDS
-- ===========================
Toggles.AutoFarm:AddKeyPicker('AutoFarmKey', {
    Default = 'F',
    SyncToggleState = true,
    Mode = 'Toggle',
    Text = 'Auto Farm',
    NoUI = false,
})

Toggles.NoClip:AddKeyPicker('NoClipKey', {
    Default = 'G',
    SyncToggleState = true,
    Mode = 'Toggle',
    Text = 'NoClip',
    NoUI = false,
})

-- ===========================
-- LIBRARY FEATURES
-- ===========================

-- Set watermark
Library:SetWatermarkVisibility(true)

-- Dynamic watermark with FPS and Ping
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

    Library:SetWatermark(('Enhanced UI | %s fps | %s ms'):format(
        math.floor(FPS),
        math.floor(game:GetService('Stats').Network.ServerStatsItem['Data Ping']:GetValue())
    ))
end)

-- Show keybind list
Library.KeybindFrame.Visible = true

-- ===========================
-- UI SETTINGS TAB
-- ===========================
local MenuGroup = Tabs['UI Settings']:AddLeftGroupbox('Menu')

MenuGroup:AddButton({
    Text = 'Unload UI',
    Func = function()
        Library:Unload()
    end,
    DoubleClick = true,
    Tooltip = 'Double click to unload the UI'
})

MenuGroup:AddLabel('Menu bind'):AddKeyPicker('MenuKeybind', {
    Default = 'RightShift',
    NoUI = true,
    Text = 'Menu keybind'
})

Library.ToggleKeybind = Options.MenuKeybind

-- ===========================
-- THEME & SAVE MANAGER
-- ===========================

-- Hand the library over to managers
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)

-- Ignore theme settings in configs
SaveManager:IgnoreThemeSettings()

-- Ignore menu keybind in configs
SaveManager:SetIgnoreIndexes({ 'MenuKeybind' })

-- Set folders for themes and configs
ThemeManager:SetFolder('EnhancedUI')
SaveManager:SetFolder('EnhancedUI/configs')

-- Build config section
SaveManager:BuildConfigSection(Tabs['UI Settings'])

-- Build theme section
ThemeManager:ApplyToTab(Tabs['UI Settings'])

-- Load autoload config if it exists
SaveManager:LoadAutoloadConfig()

-- ===========================
-- ONCHANGED CALLBACKS
-- ===========================

-- Example: Set up callbacks after UI is created
Toggles.AutoFarm:OnChanged(function()
    local enabled = Toggles.AutoFarm.Value
    print('Auto Farm:', enabled)
    
    if enabled then
        Library:Notify('Auto Farm enabled!', 2)
    else
        Library:Notify('Auto Farm disabled!', 2)
    end
end)

Options.WalkSpeed:OnChanged(function()
    local speed = Options.WalkSpeed.Value
    print('Walk Speed:', speed)
    
    -- Apply walkspeed to player
    local player = game.Players.LocalPlayer
    if player and player.Character and player.Character:FindFirstChild('Humanoid') then
        player.Character.Humanoid.WalkSpeed = speed
    end
end)

Options.JumpPower:OnChanged(function()
    local power = Options.JumpPower.Value
    print('Jump Power:', power)
    
    -- Apply jump power to player
    local player = game.Players.LocalPlayer
    if player and player.Character and player.Character:FindFirstChild('Humanoid') then
        player.Character.Humanoid.JumpPower = power
    end
end)

-- ===========================
-- UNLOAD HANDLING
-- ===========================

Library:OnUnload(function()
    WatermarkConnection:Disconnect()
    
    -- Reset player properties
    local player = game.Players.LocalPlayer
    if player and player.Character and player.Character:FindFirstChild('Humanoid') then
        player.Character.Humanoid.WalkSpeed = 16
        player.Character.Humanoid.JumpPower = 50
    end
    
    print('Enhanced UI Unloaded!')
    Library.Unloaded = true
end)

-- ===========================
-- STARTUP MESSAGE
-- ===========================

Library:Notify('Enhanced UI loaded successfully!', 5)
print('Enhanced UI initialized | Features: ' .. #Tabs .. ' tabs')
print('Press RightShift to toggle the menu')
