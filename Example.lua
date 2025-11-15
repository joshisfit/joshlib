-- Modern UI Library Example with Configs & Features
local Library = loadstring(game:HttpGet('https://raw.githubusercontent.com/joshisfit/joshlib/refs/heads/main/Library.lua'))()

-- Create Window
local Window = Library:CreateWindow({
    Title = 'RUST',
    Description = 'premium cheats',
    Center = true,
    AutoShow = true,
})

-- Create Tabs (with custom icon IDs)
local LegitTab = Window:AddTab('legitbot', 6031302931)
local MiscTab = Window:AddTab('misc', 6031154871)
local VisualsTab = Window:AddTab('visuals', 6031097225)
local SettingsTab = Window:AddTab('settings', 6034287594)

-- ========== LEGITBOT TAB ==========
local AimbotSection = LegitTab:AddSection('Aimbot', 'left')

AimbotSection:AddToggle('Aimbot', {
    Text = 'aimbot',
    Default = false,
    Callback = function(Value)
        print('Aimbot:', Value)
    end
})

AimbotSection:AddToggle('Smoothing', {
    Text = 'smoothing',
    Default = true,
    Callback = function(Value)
        print('Smoothing:', Value)
    end
})

AimbotSection:AddToggle('Curving', {
    Text = 'curving',
    Default = false,
    Callback = function(Value)
        print('Curving:', Value)
    end
})

AimbotSection:AddToggle('SilentAim', {
    Text = 'silent aim',
    Default = false,
    Callback = function(Value)
        print('Silent Aim:', Value)
    end
})

AimbotSection:AddToggle('FoV', {
    Text = 'FoV',
    Default = true,
    Callback = function(Value)
        print('FoV:', Value)
    end
})

AimbotSection:AddSlider('Radius', {
    Text = 'radius',
    Default = 125,
    Min = 0,
    Max = 500,
    Rounding = 0,
    Suffix = 'px',
    Callback = function(Value)
        print('Radius:', Value)
    end
})

-- Right Column for Legitbot
local ModificationsSection = LegitTab:AddSection('modifications', 'right')

ModificationsSection:AddToggle('Enabled', {
    Text = 'enabled',
    Default = true,
    Callback = function(Value)
        print('Modifications Enabled:', Value)
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
    Suffix = '%',
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
    Suffix = '%',
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
    Suffix = '%',
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
    Suffix = '%',
    Callback = function(Value)
        print('Speed:', Value)
    end
})

local RemovalsSection = LegitTab:AddSection('removals', 'right')

RemovalsSection:AddToggle('FallDamage', {
    Text = 'fall damage',
    Default = true,
    Callback = function(Value)
        print('Fall Damage:', Value)
    end
})

-- ========== MISC TAB ==========
local MiscSection = MiscTab:AddSection('misc', 'left')

MiscSection:AddToggle('BunnyHop', {
    Text = 'bunny hop',
    Default = false,
    Callback = function(Value)
        print('Bunny Hop:', Value)
    end
})

MiscSection:AddToggle('AutoSprint', {
    Text = 'auto sprint',
    Default = false,
    Callback = function(Value)
        print('Auto Sprint:', Value)
    end
})

MiscSection:AddToggle('NoClip', {
    Text = 'noclip',
    Default = false,
    Callback = function(Value)
        print('NoClip:', Value)
    end
})

MiscSection:AddSlider('WalkSpeed', {
    Text = 'walk speed',
    Default = 16,
    Min = 16,
    Max = 100,
    Rounding = 0,
    Suffix = ' studs',
    Callback = function(Value)
        print('Walk Speed:', Value)
    end
})

MiscSection:AddButton({
    Text = 'respawn',
    Func = function()
        print('Respawning...')
    end
})

local UtilitySection = MiscTab:AddSection('utility', 'right')

UtilitySection:AddToggle('AutoCollect', {
    Text = 'auto collect',
    Default = false,
    Callback = function(Value)
        print('Auto Collect:', Value)
    end
})

UtilitySection:AddToggle('AutoFarm', {
    Text = 'auto farm',
    Default = false,
    Callback = function(Value)
        print('Auto Farm:', Value)
    end
})

UtilitySection:AddDropdown('FarmMode', {
    Values = {'Wood', 'Stone', 'Metal', 'Sulfur'},
    Default = 'Wood',
    Multi = false,
    Text = 'farm mode',
    Callback = function(Value)
        print('Farm Mode:', Value)
    end
})

-- ========== VISUALS TAB ==========
local ESPSection = VisualsTab:AddSection('esp', 'left')

ESPSection:AddToggle('PlayerESP', {
    Text = 'player esp',
    Default = false,
    Callback = function(Value)
        print('Player ESP:', Value)
    end
})

ESPSection:AddToggle('NameESP', {
    Text = 'name esp',
    Default = false,
    Callback = function(Value)
        print('Name ESP:', Value)
    end
})

ESPSection:AddToggle('DistanceESP', {
    Text = 'distance esp',
    Default = false,
    Callback = function(Value)
        print('Distance ESP:', Value)
    end
})

ESPSection:AddToggle('BoxESP', {
    Text = 'box esp',
    Default = false,
    Callback = function(Value)
        print('Box ESP:', Value)
    end
})

ESPSection:AddToggle('Tracers', {
    Text = 'tracers',
    Default = false,
    Callback = function(Value)
        print('Tracers:', Value)
    end
})

ESPSection:AddToggle('Chams', {
    Text = 'chams',
    Default = false,
    Callback = function(Value)
        print('Chams:', Value)
    end
})

ESPSection:AddColorPicker('ESPColor', {
    Default = Color3.fromRGB(100, 180, 255),
    Text = 'esp color',
    Callback = function(Value)
        print('ESP Color:', Value)
    end
})

local WorldSection = VisualsTab:AddSection('world', 'right')

WorldSection:AddToggle('FullBright', {
    Text = 'fullbright',
    Default = false,
    Callback = function(Value)
        print('Fullbright:', Value)
    end
})

WorldSection:AddToggle('NoFog', {
    Text = 'no fog',
    Default = false,
    Callback = function(Value)
        print('No Fog:', Value)
    end
})

WorldSection:AddSlider('Ambient', {
    Text = 'ambient',
    Default = 50,
    Min = 0,
    Max = 100,
    Rounding = 0,
    Suffix = '%',
    Callback = function(Value)
        print('Ambient:', Value)
    end
})

local CrosshairSection = VisualsTab:AddSection('crosshair', 'right')

CrosshairSection:AddToggle('Crosshair', {
    Text = 'custom crosshair',
    Default = false,
    Callback = function(Value)
        print('Crosshair:', Value)
    end
})

CrosshairSection:AddSlider('CrosshairSize', {
    Text = 'size',
    Default = 10,
    Min = 5,
    Max = 50,
    Rounding = 0,
    Suffix = 'px',
    Callback = function(Value)
        print('Crosshair Size:', Value)
    end
})

CrosshairSection:AddColorPicker('CrosshairColor', {
    Default = Color3.fromRGB(255, 255, 255),
    Text = 'color',
    Callback = function(Value)
        print('Crosshair Color:', Value)
    end
})

-- ========== SETTINGS TAB ==========
local UISection = SettingsTab:AddSection('ui settings', 'left')

UISection:AddButton({
    Text = 'unload ui',
    Func = function()
        Window:Unload()
    end
})

UISection:AddKeybind('MenuKeybind', {
    Default = 'RightShift',
    Text = 'menu toggle',
    Mode = 'Toggle',
    Callback = function(Value)
        print('Menu Keybind:', Value)
    end
})

UISection:AddColorPicker('ThemeColor', {
    Default = Color3.fromRGB(100, 180, 255),
    Text = 'theme color',
    Callback = function(Value)
        print('Theme Color:', Value)
        -- Update theme here
    end
})

-- Config Section with Save/Load functionality
Window:CreateConfigSection(SettingsTab)

local InfoSection = SettingsTab:AddSection('information', 'right')

InfoSection:AddLabel('version: 1.0.0')
InfoSection:AddLabel('created by: your name')
InfoSection:AddLabel('discord: discord.gg/example')
InfoSection:AddLabel(' ')
InfoSection:AddLabel('press the search icon to')
InfoSection:AddLabel('search for features')

-- Notifications Example
Window:Notify({
    Title = 'UI Loaded!',
    Text = 'Welcome to the UI Library',
    Duration = 3,
    Icon = 6031302931
})

task.wait(3)

Window:Notify({
    Title = 'Tip',
    Text = 'Click the settings icon to customize colors',
    Duration = 4,
    Icon = 6031154871
})

-- Example: Accessing values
print('Aimbot enabled:', Toggles.Aimbot.Value)
print('Pitch value:', Options.Pitch.Value)

-- Example: OnChanged callbacks
Toggles.Aimbot:OnChanged(function()
    print('Aimbot changed to:', Toggles.Aimbot.Value)
end)

Options.Pitch:OnChanged(function()
    print('Pitch changed to:', Options.Pitch.Value)
end)

-- Cleanup
Window:OnUnload(function()
    print('UI Unloaded!')
end)

print('Modern UI Library loaded successfully!')
