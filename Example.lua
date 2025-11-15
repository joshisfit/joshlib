-- Modern UI Library Example Script
-- Load the library
local Library = loadstring(game:HttpGet('https://raw.githubusercontent.com/joshisfit/joshlib/refs/heads/main/Library.lua'))()

-- Create Window
local Window = Library:CreateWindow({
    Title = 'Lunacy Solutions',
    Center = true,
    AutoShow = true
})

-- Create Tabs with custom icons
local Tabs = {
    Legitbot = Window:AddTab('Legitbot', 'rbxassetid://15571371474'),
    Visuals = Window:AddTab('Visuals', 'rbxassetid://6588984328'),
    Misc = Window:AddTab('Misc', 'rbxassetid://82085214486223'),
    Settings = Window:AddTab('Settings', 'rbxassetid://6031280882')
}

-- ========================================
-- LEGITBOT TAB
-- ========================================
local AimbotSettings = Tabs.Legitbot:AddLeftGroupbox('Aimbot Settings')

AimbotSettings:AddToggle('EnableAimbot', {
    Text = 'Enable Aimbot',
    Default = false,
    Tooltip = 'Enables the aimbot feature',
    Callback = function(Value)
        Library:Notify({
            Text = 'Aimbot ' .. (Value and 'enabled' or 'disabled'),
            Duration = 2,
            Type = Value and 'Success' or 'Warning'
        })
    end
})

Toggles.EnableAimbot:OnChanged(function()
    print('Aimbot changed to:', Toggles.EnableAimbot.Value)
end)

AimbotSettings:AddToggle('VisibleCheck', {
    Text = 'Visible Check',
    Default = true,
    Tooltip = 'Only aim at visible targets'
})

AimbotSettings:AddToggle('TeamCheck', {
    Text = 'Team Check',
    Default = true,
    Tooltip = 'Ignore teammates'
})

AimbotSettings:AddSlider('FOVSize', {
    Text = 'FOV Size',
    Default = 100,
    Min = 50,
    Max = 500,
    Rounding = 0,
    Suffix = 'px',
    Callback = function(Value)
        print('FOV Size:', Value)
    end
})

AimbotSettings:AddSlider('Smoothness', {
    Text = 'Smoothness',
    Default = 5,
    Min = 1,
    Max = 10,
    Rounding = 1,
    Callback = function(Value)
        print('Smoothness:', Value)
    end
})

AimbotSettings:AddDropdown('TargetPart', {
    Text = 'Target Part',
    Values = {'Head', 'Torso', 'HumanoidRootPart'},
    Default = 1,
    Callback = function(Value)
        print('Target Part:', Value)
    end
})

AimbotSettings:AddSlider('MaxDistance', {
    Text = 'Max Distance',
    Default = 1000,
    Min = 100,
    Max = 5000,
    Rounding = 0,
    Suffix = ' studs'
})

local PredictionSettings = Tabs.Legitbot:AddRightGroupbox('Prediction')

PredictionSettings:AddToggle('EnablePrediction', {
    Text = 'Enable Prediction',
    Default = false,
    Tooltip = 'Predicts player movement'
})

PredictionSettings:AddSlider('PredictionAmount', {
    Text = 'Prediction Amount',
    Default = 0.13,
    Min = 0,
    Max = 0.5,
    Rounding = 2
})

local TriggerBot = Tabs.Legitbot:AddRightGroupbox('Trigger Bot')

TriggerBot:AddToggle('EnableTriggerBot', {
    Text = 'Enable Trigger Bot',
    Default = false,
    Tooltip = 'Automatically shoots when aiming at enemy'
})

TriggerBot:AddSlider('TriggerDelay', {
    Text = 'Trigger Delay',
    Default = 50,
    Min = 0,
    Max = 500,
    Rounding = 0,
    Suffix = 'ms'
})

TriggerBot:AddLabel('Trigger Key'):AddKeyPicker('TriggerKey', {
    Default = 'LCtrl',
    Mode = 'Toggle',
    Text = 'Trigger Bot Key'
})

-- ========================================
-- VISUALS TAB
-- ========================================
local ESPSettings = Tabs.Visuals:AddLeftGroupbox('Visual Settings')

ESPSettings:AddToggle('ShowFOVCircle', {
    Text = 'Show FOV Circle',
    Default = false,
    Tooltip = 'Shows the FOV circle'
})

ESPSettings:AddLabel('FOV Color'):AddColorPicker('FOVColor', {
    Default = Color3.fromRGB(255, 255, 255),
    Title = 'FOV Circle Color',
    Callback = function(Value)
        print('FOV Color:', Value)
    end
})

ESPSettings:AddToggle('ShowTargetLine', {
    Text = 'Show Target Line',
    Default = false,
    Tooltip = 'Shows a line to the target'
})

ESPSettings:AddLabel('Target Line Color'):AddColorPicker('TargetLineColor', {
    Default = Color3.fromRGB(255, 0, 0),
    Title = 'Target Line Color'
})

ESPSettings:AddSlider('LineThickness', {
    Text = 'Line Thickness',
    Default = 2,
    Min = 1,
    Max = 10,
    Rounding = 0,
    Suffix = 'px'
})

local PlayerESP = Tabs.Visuals:AddRightGroupbox('Player ESP')

PlayerESP:AddToggle('EnableESP', {
    Text = 'Enable ESP',
    Default = false,
    Tooltip = 'Shows player ESP boxes'
})

PlayerESP:AddToggle('ShowName', {
    Text = 'Show Name',
    Default = true
})

PlayerESP:AddToggle('ShowHealth', {
    Text = 'Show Health',
    Default = true
})

PlayerESP:AddToggle('ShowDistance', {
    Text = 'Show Distance',
    Default = true
})

PlayerESP:AddLabel('ESP Color'):AddColorPicker('ESPColor', {
    Default = Color3.fromRGB(0, 255, 0),
    Title = 'ESP Color'
})

-- ========================================
-- MISC TAB
-- ========================================
local MovementSettings = Tabs.Misc:AddLeftGroupbox('Movement')

MovementSettings:AddToggle('SpeedHack', {
    Text = 'Speed Hack',
    Default = false
})

MovementSettings:AddSlider('WalkSpeed', {
    Text = 'Walk Speed',
    Default = 16,
    Min = 16,
    Max = 100,
    Rounding = 0,
    Callback = function(Value)
        if Toggles.SpeedHack.Value then
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
        end
    end
})

MovementSettings:AddToggle('JumpPower', {
    Text = 'Jump Power',
    Default = false
})

MovementSettings:AddSlider('JumpHeight', {
    Text = 'Jump Height',
    Default = 50,
    Min = 50,
    Max = 200,
    Rounding = 0
})

MovementSettings:AddToggle('NoClip', {
    Text = 'No Clip',
    Default = false
})

MovementSettings:AddLabel('NoClip Key'):AddKeyPicker('NoClipKey', {
    Default = 'E',
    Mode = 'Toggle',
    Text = 'NoClip Toggle'
})

local UtilitySettings = Tabs.Misc:AddRightGroupbox('Utility')

UtilitySettings:AddToggle('AutoFarm', {
    Text = 'Auto Farm',
    Default = false
})

UtilitySettings:AddToggle('AntiAFK', {
    Text = 'Anti AFK',
    Default = false
})

UtilitySettings:AddButton({
    Text = 'Teleport to Spawn',
    Func = function()
        Library:Notify({
            Text = 'Teleported to spawn!',
            Duration = 2,
            Type = 'Success'
        })
    end,
    Tooltip = 'Teleports you to spawn'
})

UtilitySettings:AddButton({
    Text = 'Respawn Character',
    Func = function()
        game.Players.LocalPlayer.Character.Humanoid.Health = 0
    end,
    DoubleClick = true,
    Tooltip = 'Double click to respawn'
})

UtilitySettings:AddInput('CustomMessage', {
    Default = 'Hello World',
    Numeric = false,
    Finished = true,
    Text = 'Custom Message',
    Placeholder = 'Enter message...',
    Callback = function(Value)
        print('Message:', Value)
    end
})

-- ========================================
-- SETTINGS TAB
-- ========================================
local UISettings = Tabs.Settings:AddLeftGroupbox('UI Settings')

UISettings:AddToggle('ShowWatermark', {
    Text = 'Show Watermark',
    Default = false,
    Callback = function(Value)
        Library:SetWatermarkVisibility(Value)
    end
})

UISettings:AddToggle('ShowKeybinds', {
    Text = 'Show Keybind List',
    Default = false,
    Callback = function(Value)
        Library.KeybindFrame.Visible = Value
    end
})

UISettings:AddDropdown('TweenStyle', {
    Text = 'Tween Style',
    Values = {'Linear', 'Quad', 'Cubic', 'Quart', 'Quint', 'Sine', 'Expo', 'Back', 'Bounce', 'Elastic'},
    Default = 2,
    Callback = function(Value)
        Library.TweenStyle = Enum.EasingStyle[Value]
        Library:Notify({
            Text = 'Tween style changed to ' .. Value,
            Duration = 2,
            Type = 'Info'
        })
    end
})

UISettings:AddLabel('Menu Keybind'):AddKeyPicker('MenuKeybind', {
    Default = 'RightShift',
    NoUI = true,
    Text = 'Menu Toggle'
})

UISettings:AddButton({
    Text = 'Unload UI',
    Func = function()
        Library:Unload()
    end,
    DoubleClick = true,
    Tooltip = 'Double click to unload'
})

local ThemeSettings = Tabs.Settings:AddRightGroupbox('Theme')

ThemeSettings:AddLabel('Primary Color'):AddColorPicker('PrimaryColor', {
    Default = Library.Theme.Primary,
    Title = 'Primary Color',
    Callback = function(Value)
        Library.Theme.Primary = Value
    end
})

ThemeSettings:AddLabel('Accent Color'):AddColorPicker('AccentColor', {
    Default = Library.Theme.Accent,
    Title = 'Accent Color',
    Callback = function(Value)
        Library.Theme.Accent = Value
    end
})

ThemeSettings:AddLabel('Text Color'):AddColorPicker('TextColor', {
    Default = Library.Theme.Text,
    Title = 'Text Color',
    Callback = function(Value)
        Library.Theme.Text = Value
    end
})

ThemeSettings:AddDivider()

ThemeSettings:AddButton({
    Text = 'Reset to Default',
    Func = function()
        Library:SetTheme({
            Primary = Color3.fromRGB(45, 45, 50),
            Secondary = Color3.fromRGB(35, 35, 40),
            Accent = Color3.fromRGB(120, 80, 255),
            Text = Color3.fromRGB(255, 255, 255),
            TextDark = Color3.fromRGB(180, 180, 180),
            Border = Color3.fromRGB(60, 60, 65)
        })
        Library:Notify({
            Text = 'Theme reset to default',
            Duration = 2,
            Type = 'Success'
        })
    end
})

local ConfigSettings = Tabs.Settings:AddRightGroupbox('Configuration')

ConfigSettings:AddInput('ConfigName', {
    Default = 'Default',
    Numeric = false,
    Finished = true,
    Text = 'Config Name',
    Placeholder = 'Enter config name...'
})

ConfigSettings:AddButton({
    Text = 'Save Current Preset',
    Func = function()
        local configName = Options.ConfigName.Value
        Library:Notify({
            Text = 'Config "' .. configName .. '" saved!',
            Duration = 2,
            Type = 'Success'
        })
    end,
    Tooltip = 'Saves current settings'
})

ConfigSettings:AddButton({
    Text = 'Load Preset',
    Func = function()
        local configName = Options.ConfigName.Value
        Library:Notify({
            Text = 'Config "' .. configName .. '" loaded!',
            Duration = 2,
            Type = 'Info'
        })
    end,
    Tooltip = 'Loads saved settings'
})

ConfigSettings:AddDropdown('PresetList', {
    Text = 'Saved Presets',
    Values = {'Default', 'Legit', 'Rage', 'HvH'},
    Default = 1,
    Callback = function(Value)
        print('Selected preset:', Value)
    end
})

-- ========================================
-- WATERMARK UPDATE
-- ========================================
local function UpdateWatermark()
    local time = os.date("*t")
    local hour = string.format("%02d", time.hour)
    local min = string.format("%02d", time.min)
    local sec = string.format("%02d", time.sec)
    local day = string.format("%02d", time.day)
    local month = string.format("%02d", time.month)
    local year = time.year
    
    Library:SetWatermark(string.format(
        'Lunacy Solutions | %s | %s/%s/%s - %s:%s:%s',
        game.Players.LocalPlayer.Name,
        day, month, year,
        hour, min, sec
    ))
end

-- Update watermark every second
game:GetService('RunService').RenderStepped:Connect(function()
    if Toggles.ShowWatermark and Toggles.ShowWatermark.Value then
        UpdateWatermark()
    end
end)

-- ========================================
-- KEYBIND FUNCTIONALITY
-- ========================================
-- Set menu toggle keybind
Library.ToggleKeybind = Options.MenuKeybind

-- Listen for menu toggle
game:GetService('UserInputService').InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode.Name == Options.MenuKeybind.Value then
        Library.MainFrame.Visible = not Library.MainFrame.Visible
    end
end)

-- ========================================
-- UNLOAD HANDLER
-- ========================================
Library:OnUnload(function()
    print('UI Unloaded!')
    
    -- Cleanup code here
    if Toggles.SpeedHack.Value then
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16
    end
    
    Library:Notify({
        Text = 'UI unloaded successfully!',
        Duration = 3,
        Type = 'Info'
    })
    
    Library.Unloaded = true
end)

-- ========================================
-- STARTUP NOTIFICATION
-- ========================================
Library:Notify({
    Text = 'Lunacy Solutions loaded successfully!',
    Duration = 3,
    Type = 'Success'
})

print('Lunacy Solutions UI loaded!')
print('Toggle with: ' .. Options.MenuKeybind.Value)
