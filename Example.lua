local Library = loadstring(game:HttpGet('https://raw.githubusercontent.com/joshisfit/joshlib/refs/heads/main/Library.luaE'))()

-- Create the main window
local Window = Library:CreateWindow({
    Title = 'My Custom UI',
    Center = true,
    AutoShow = true,
})

-- Create tabs
local Tabs = {
    Main = Window:AddTab('Main'),
    Combat = Window:AddTab('Combat'),
    Settings = Window:AddTab('Settings'),
}

-- LEFT SIDE - Main Tab
local LeftGroupBox = Tabs.Main:AddLeftGroupbox('Player Features')

-- Add a toggle
LeftGroupBox:AddToggle('SpeedHack', {
    Text = 'Speed Hack',
    Default = false,
    Tooltip = 'Increases your movement speed',
    Callback = function(Value)
        print('Speed hack:', Value)
        -- Your speed hack code here
    end
})

-- Access toggle value later
Toggles.SpeedHack:OnChanged(function()
    print('Speed hack changed to:', Toggles.SpeedHack.Value)
end)

-- Add a button
LeftGroupBox:AddButton({
    Text = 'Teleport to Spawn',
    Func = function()
        print('Teleporting to spawn!')
        -- Your teleport code here
    end,
    Tooltip = 'Teleports you back to spawn'
})

-- Add a label
LeftGroupBox:AddLabel('Movement Controls')

-- Add a divider
LeftGroupBox:AddDivider()

-- Add a slider
LeftGroupBox:AddSlider('WalkSpeed', {
    Text = 'Walk Speed',
    Default = 16,
    Min = 16,
    Max = 200,
    Rounding = 0,
    Suffix = ' studs/s',
    Callback = function(Value)
        print('Walk speed set to:', Value)
        -- game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
    end
})

-- Access slider value
Options.WalkSpeed:OnChanged(function()
    print('Walk speed changed:', Options.WalkSpeed.Value)
end)

-- Add an input box
LeftGroupBox:AddInput('PlayerName', {
    Default = 'Enter name...',
    Numeric = false,
    Finished = true,
    Text = 'Target Player',
    Placeholder = 'Username',
    Callback = function(Value)
        print('Target player:', Value)
    end
})

-- Add a dropdown
LeftGroupBox:AddDropdown('Weapon', {
    Values = {'Sword', 'Bow', 'Staff', 'Dagger'},
    Default = 1,
    Multi = false,
    Text = 'Select Weapon',
    Tooltip = 'Choose your weapon',
    Callback = function(Value)
        print('Weapon selected:', Value)
    end
})

-- RIGHT SIDE - Main Tab with Tabbox
local TabBox = Tabs.Main:AddRightTabbox()

local AutoFarmTab = TabBox:AddTab('Auto Farm')
AutoFarmTab:AddToggle('AutoFarm', {
    Text = 'Enable Auto Farm',
    Default = false
})

AutoFarmTab:AddSlider('FarmSpeed', {
    Text = 'Farm Speed',
    Default = 1,
    Min = 0.5,
    Max = 5,
    Rounding = 1
})

local CollectTab = TabBox:AddTab('Collect')
CollectTab:AddToggle('AutoCollect', {
    Text = 'Auto Collect Items',
    Default = false
})

CollectTab:AddDropdown('CollectType', {
    Values = {'Coins', 'Gems', 'All'},
    Default = 'All',
    Multi = false,
    Text = 'Collection Type'
})

-- COMBAT TAB
local CombatGroup = Tabs.Combat:AddLeftGroupbox('Combat Settings')

CombatGroup:AddToggle('AutoAttack', {
    Text = 'Auto Attack',
    Default = false,
    Callback = function(Value)
        print('Auto attack:', Value)
    end
})

CombatGroup:AddSlider('AttackRange', {
    Text = 'Attack Range',
    Default = 10,
    Min = 5,
    Max = 50,
    Rounding = 0,
    Suffix = ' studs'
})

CombatGroup:AddDivider()

CombatGroup:AddDropdown('TargetMode', {
    Values = {'Nearest', 'Lowest HP', 'Highest Level'},
    Default = 'Nearest',
    Multi = false,
    Text = 'Target Priority'
})

-- Multi-select dropdown example
local CombatGroup2 = Tabs.Combat:AddRightGroupbox('Target Filters')

CombatGroup2:AddDropdown('TargetFilter', {
    Values = {'Players', 'NPCs', 'Bosses', 'Minions'},
    Default = 1,
    Multi = true,
    Text = 'Attack Targets',
    Callback = function(Value)
        print('Target filters updated:')
        for target, enabled in pairs(Value) do
            print(target, enabled)
        end
    end
})

-- Set multiple values
Options.TargetFilter:SetValue({
    Players = true,
    NPCs = true,
    Bosses = false,
    Minions = false
})

-- SETTINGS TAB
local UIGroup = Tabs.Settings:AddLeftGroupbox('UI Settings')

UIGroup:AddButton({
    Text = 'Unload UI',
    Func = function()
        Window:Unload()
    end,
    Tooltip = 'Completely removes the UI'
})

UIGroup:AddLabel('Press END to toggle menu'):AddKeyPicker('MenuKeybind', {
    Default = 'End',
    NoUI = true,
    Text = 'Menu Toggle Key'
})

-- Set the menu keybind
Library.ToggleKeybind = Options.MenuKeybind

-- Info Group
local InfoGroup = Tabs.Settings:AddRightGroupbox('Information')

InfoGroup:AddLabel('Version: 1.0.0')
InfoGroup:AddLabel('Created by: YourName')
InfoGroup:AddDivider()
InfoGroup:AddLabel('Thank you for using\nthis UI library!', true)

-- Watermark example
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
    
    Library:SetWatermark(('Custom UI | %s fps | %s ms'):format(
        math.floor(FPS),
        math.floor(game:GetService('Stats').Network.ServerStatsItem['Data Ping']:GetValue())
    ))
end)

-- Cleanup on unload
Library:OnUnload(function()
    WatermarkConnection:Disconnect()
    print('UI Unloaded!')
    Library.Unloaded = true
end)

print('UI Library loaded successfully!')
