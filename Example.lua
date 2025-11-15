-- Example usage of Custom UI Library (Sidebar Style)
-- Load your library
local Library = loadstring(game:HttpGet('https://raw.githubusercontent.com/joshisfit/joshlib/refs/heads/main/Library.lua'))()

-- Create the main window
local Window = Library:CreateWindow({
    Title = 'my script',
    Center = true,
    AutoShow = true,
})

-- Create tabs with custom icons (use Roblox asset IDs)
-- Find icons at: https://create.roblox.com/marketplace/asset or use rbxassetid numbers
local LegitTab = Window:AddTab('legit', 6031302931) -- Example icon ID
local PlayersTab = Window:AddTab('players', 6031302931)
local EntitiesTab = Window:AddTab('entities', 6031302931)
local MiscTab = Window:AddTab('misc', 6031302931)
local MainTab = Window:AddTab('main', 6031302931)
local MovementTab = Window:AddTab('movement', 6031302931)
local VisualsTab = Window:AddTab('visuals', 6031302931)
local SettingsTab = Window:AddTab('settings', 6031302931)

-- LEGIT TAB - Modifications Section
local ModificationsSection = LegitTab:AddSection('modifications')

ModificationsSection:AddToggle('Enabled', {
    Text = 'enabled',
    Default = true,
    Callback = function(Value)
        print('Enabled:', Value)
    end
})

ModificationsSection:AddToggle('Recoil', {
    Text = 'recoil',
    Default = true,
    Callback = function(Value)
        print('Recoil:', Value)
    end
})

ModificationsSection:AddToggle('RapidFire', {
    Text = 'rapid fire',
    Default = true,
    Callback = function(Value)
        print('Rapid Fire:', Value)
    end
})

ModificationsSection:AddToggle('InstantEoka', {
    Text = 'instant eoka',
    Default = false,
    Callback = function(Value)
        print('Instant Eoka:', Value)
    end
})

ModificationsSection:AddToggle('AutomaticPitch', {
    Text = 'automatic pitch',
    Default = true,
    Callback = function(Value)
        print('Automatic Pitch:', Value)
    end
})

ModificationsSection:AddSlider('Pitch', {
    Text = 'pitch',
    Default = 100,
    Min = 0,
    Max = 100,
    Rounding = 0,
    Callback = function(Value)
        print('Pitch:', Value)
    end
})

ModificationsSection:AddSlider('Yaw', {
    Text = 'yaw',
    Default = 100,
    Min = 0,
    Max = 100,
    Rounding = 0,
    Callback = function(Value)
        print('Yaw:', Value)
    end
})

ModificationsSection:AddSlider('ADS', {
    Text = 'ads',
    Default = 100,
    Min = 0,
    Max = 100,
    Rounding = 0,
    Callback = function(Value)
        print('ADS:', Value)
    end
})

ModificationsSection:AddSlider('Speed', {
    Text = 'speed',
    Default = 93,
    Min = 0,
    Max = 100,
    Rounding = 0,
    Callback = function(Value)
        print('Speed:', Value)
    end
})

-- LEGIT TAB - Removals Section
local RemovalsSection = LegitTab:AddSection('removals')

RemovalsSection:AddToggle('FallDamage', {
    Text = 'fall damage',
    Default = true,
    Callback = function(Value)
        print('Fall Damage:', Value)
    end
})

-- LEGIT TAB - Funny Section
local FunnySection = LegitTab:AddSection('funny')

FunnySection:AddToggle('Jitter', {
    Text = 'jitter',
    Default = false,
    Callback = function(Value)
        print('Jitter:', Value)
    end
})

-- MISC TAB Example
local MiscSection = MiscTab:AddSection('misc settings')

MiscSection:AddToggle('AutoCollect', {
    Text = 'auto collect',
    Default = false,
    Callback = function(Value)
        print('Auto Collect:', Value)
    end
})

MiscSection:AddButton({
    Text = 'teleport to base',
    Func = function()
        print('Teleporting to base!')
    end
})

MiscSection:AddDropdown('GameMode', {
    Values = {'Survival', 'Creative', 'Adventure'},
    Default = 'Survival',
    Multi = false,
    Text = 'game mode',
    Callback = function(Value)
        print('Game Mode:', Value)
    end
})

-- MOVEMENT TAB Example
local MovementSection = MovementTab:AddSection('movement')

MovementSection:AddToggle('SpeedHack', {
    Text = 'speed hack',
    Default = false,
    Callback = function(Value)
        print('Speed Hack:', Value)
    end
})

MovementSection:AddSlider('WalkSpeed', {
    Text = 'walk speed',
    Default = 16,
    Min = 16,
    Max = 100,
    Rounding = 0,
    Callback = function(Value)
        print('Walk Speed:', Value)
    end
})

MovementSection:AddToggle('Flight', {
    Text = 'flight',
    Default = false,
    Callback = function(Value)
        print('Flight:', Value)
    end
})

MovementSection:AddSlider('FlightSpeed', {
    Text = 'flight speed',
    Default = 50,
    Min = 10,
    Max = 200,
    Rounding = 0,
    Callback = function(Value)
        print('Flight Speed:', Value)
    end
})

-- VISUALS TAB Example
local VisualsSection = VisualsTab:AddSection('esp')

VisualsSection:AddToggle('PlayerESP', {
    Text = 'player esp',
    Default = false,
    Callback = function(Value)
        print('Player ESP:', Value)
    end
})

VisualsSection:AddToggle('ChamsESP', {
    Text = 'chams',
    Default = false,
    Callback = function(Value)
        print('Chams:', Value)
    end
})

VisualsSection:AddToggle('Tracers', {
    Text = 'tracers',
    Default = false,
    Callback = function(Value)
        print('Tracers:', Value)
    end
})

-- SETTINGS TAB Example
local SettingsSection = SettingsTab:AddSection('ui settings')

SettingsSection:AddButton({
    Text = 'unload ui',
    Func = function()
        Window:Unload()
    end
})

SettingsSection:AddInput('ConfigName', {
    Default = 'default',
    Numeric = false,
    Finished = true,
    Text = 'config name',
    Placeholder = 'Enter config name...',
    Callback = function(Value)
        print('Config Name:', Value)
    end
})

SettingsSection:AddButton({
    Text = 'save config',
    Func = function()
        print('Config saved!')
    end
})

SettingsSection:AddButton({
    Text = 'load config',
    Func = function()
        print('Config loaded!')
    end
})

local InfoSection = SettingsTab:AddSection('information')

InfoSection:AddLabel('version: 1.0.0')
InfoSection:AddLabel('created by: you')
InfoSection:AddLabel('discord: discord.gg/your-server')

-- Accessing values later
print('Current Speed value:', Options.Speed.Value)
print('Current Enabled toggle:', Toggles.Enabled.Value)

-- OnChanged callbacks
Toggles.Enabled:OnChanged(function()
    print('Enabled changed to:', Toggles.Enabled.Value)
end)

Options.Pitch:OnChanged(function()
    print('Pitch changed to:', Options.Pitch.Value)
end)

-- Cleanup on unload
Window:OnUnload(function()
    print('UI Unloaded!')
    Library.Unloaded = true
end)

print('UI Library loaded successfully!')
