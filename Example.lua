local Library = loadstring(game:HttpGet("YOUR_LIBRARY_URL_HERE"))()

local Window = Library:CreateWindow({
    Name = "Phantom Forces | Modern UI",
    Size = UDim2.new(0, 650, 0, 550)
})

local LegitTab = Window:AddTab({
    Name = "Legitbot",
    Icon = "15571371474"
})

local VisualsTab = Window:AddTab({
    Name = "Visuals",
    Icon = "6588984328"
})

local MiscTab = Window:AddTab({
    Name = "Misc",
    Icon = "82085214486223"
})

local AimbotSection = LegitTab:AddSection("Aimbot")

AimbotSection:AddToggle({
    Name = "Enable Aimbot",
    Default = false,
    Flag = "Aimbot",
    Callback = function(value)
        Library:Notify("Aimbot " .. (value and "enabled" or "disabled"), 2)
    end
})

AimbotSection:AddSlider({
    Name = "FOV Size",
    Min = 0,
    Max = 500,
    Default = 100,
    Increment = 10,
    Flag = "AimbotFOV",
    Callback = function(value)
        print("FOV set to:", value)
    end
})

AimbotSection:AddSlider({
    Name = "Smoothness",
    Min = 0,
    Max = 100,
    Default = 50,
    Increment = 1,
    Flag = "AimbotSmooth",
    Callback = function(value)
        print("Smoothness set to:", value)
    end
})

AimbotSection:AddDropdown({
    Name = "Target Part",
    Options = {"Head", "Torso", "Random"},
    Default = "Head",
    Flag = "TargetPart",
    Callback = function(value)
        print("Targeting:", value)
    end
})

AimbotSection:AddToggle({
    Name = "Visible Check",
    Default = true,
    Flag = "VisibleCheck"
})

AimbotSection:AddToggle({
    Name = "Team Check",
    Default = true,
    Flag = "TeamCheck"
})

AimbotSection:AddKeybind({
    Name = "Aimbot Key",
    Default = Enum.KeyCode.E,
    Flag = "AimbotKey",
    Callback = function(active)
        print("Aimbot key:", active and "pressed" or "released")
    end
})

local TriggerSection = LegitTab:AddSection("Triggerbot")

TriggerSection:AddToggle({
    Name = "Enable Triggerbot",
    Default = false,
    Flag = "Triggerbot",
    Callback = function(value)
        Library:Notify("Triggerbot " .. (value and "enabled" or "disabled"), 2)
    end
})

TriggerSection:AddSlider({
    Name = "Delay (ms)",
    Min = 0,
    Max = 500,
    Default = 50,
    Increment = 10,
    Flag = "TriggerDelay"
})

local ESPSection = VisualsTab:AddSection("ESP")

ESPSection:AddToggle({
    Name = "Enable ESP",
    Default = false,
    Flag = "ESP",
    Callback = function(value)
        Library:Notify("ESP " .. (value and "enabled" or "disabled"), 2)
    end
})

ESPSection:AddToggle({
    Name = "Name Tags",
    Default = true,
    Flag = "NameTags"
})

ESPSection:AddToggle({
    Name = "Display Distance",
    Default = true,
    Flag = "Distance"
})

ESPSection:AddToggle({
    Name = "Boxes",
    Default = true,
    Flag = "Boxes"
})

ESPSection:AddToggle({
    Name = "Healthbars",
    Default = true,
    Flag = "Healthbars"
})

ESPSection:AddToggle({
    Name = "Tracers",
    Default = false,
    Flag = "Tracers"
})

ESPSection:AddColorPicker({
    Name = "ESP Color",
    Default = Color3.fromRGB(255, 0, 0),
    Flag = "ESPColor",
    Callback = function(color)
        print("ESP Color changed to:", color)
    end
})

ESPSection:AddSlider({
    Name = "Max Distance",
    Min = 100,
    Max = 5000,
    Default = 1000,
    Increment = 100,
    Flag = "MaxDistance"
})

local ChamsSection = VisualsTab:AddSection("Chams")

ChamsSection:AddToggle({
    Name = "Enable Chams",
    Default = false,
    Flag = "Chams"
})

ChamsSection:AddColorPicker({
    Name = "Visible Color",
    Default = Color3.fromRGB(0, 255, 0),
    Flag = "ChamsVisible"
})

ChamsSection:AddColorPicker({
    Name = "Hidden Color",
    Default = Color3.fromRGB(255, 0, 0),
    Flag = "ChamsHidden"
})

ChamsSection:AddSlider({
    Name = "Transparency",
    Min = 0,
    Max = 100,
    Default = 50,
    Increment = 1,
    Flag = "ChamsTransparency"
})

local CrosshairSection = VisualsTab:AddSection("Crosshair")

CrosshairSection:AddToggle({
    Name = "Enable Crosshair",
    Default = false,
    Flag = "Crosshair"
})

CrosshairSection:AddToggle({
    Name = "Show Dot",
    Default = true,
    Flag = "CrosshairDot"
})

CrosshairSection:AddSlider({
    Name = "Size",
    Min = 1,
    Max = 100,
    Default = 10,
    Increment = 1,
    Flag = "CrosshairSize"
})

CrosshairSection:AddSlider({
    Name = "Gap",
    Min = 0,
    Max = 50,
    Default = 5,
    Increment = 1,
    Flag = "CrosshairGap"
})

CrosshairSection:AddColorPicker({
    Name = "Crosshair Color",
    Default = Color3.fromRGB(255, 255, 255),
    Flag = "CrosshairColor"
})

local WorldSection = VisualsTab:AddSection("World")

WorldSection:AddToggle({
    Name = "No Recoil",
    Default = false,
    Flag = "NoRecoil",
    Callback = function(value)
        Library:Notify("No Recoil " .. (value and "enabled" or "disabled"), 2)
    end
})

WorldSection:AddToggle({
    Name = "No Spread",
    Default = false,
    Flag = "NoSpread"
})

WorldSection:AddToggle({
    Name = "Infinite Ammo",
    Default = false,
    Flag = "InfiniteAmmo"
})

WorldSection:AddSlider({
    Name = "FOV Changer",
    Min = 70,
    Max = 120,
    Default = 90,
    Increment = 1,
    Flag = "FOV"
})

WorldSection:AddSlider({
    Name = "Brightness",
    Min = 0,
    Max = 100,
    Default = 50,
    Increment = 1,
    Flag = "Brightness"
})

local MovementSection = MiscTab:AddSection("Movement")

MovementSection:AddToggle({
    Name = "Speed Hack",
    Default = false,
    Flag = "Speed",
    Callback = function(value)
        Library:Notify("Speed Hack " .. (value and "enabled" or "disabled"), 2)
    end
})

MovementSection:AddSlider({
    Name = "Speed Multiplier",
    Min = 1,
    Max = 5,
    Default = 1.5,
    Increment = 0.1,
    Flag = "SpeedMultiplier"
})

MovementSection:AddToggle({
    Name = "Fly",
    Default = false,
    Flag = "Fly"
})

MovementSection:AddSlider({
    Name = "Fly Speed",
    Min = 10,
    Max = 200,
    Default = 50,
    Increment = 5,
    Flag = "FlySpeed"
})

MovementSection:AddToggle({
    Name = "No Clip",
    Default = false,
    Flag = "NoClip"
})

MovementSection:AddToggle({
    Name = "Infinite Jump",
    Default = false,
    Flag = "InfiniteJump"
})

MovementSection:AddKeybind({
    Name = "Fly Key",
    Default = Enum.KeyCode.F,
    Flag = "FlyKey",
    Callback = function(active)
        if active then
            Library:Notify("Fly activated", 1)
        end
    end
})

local ExploitSection = MiscTab:AddSection("Exploits")

ExploitSection:AddToggle({
    Name = "Auto Farm",
    Default = false,
    Flag = "AutoFarm",
    Callback = function(value)
        Library:Notify("Auto Farm " .. (value and "enabled" or "disabled"), 2)
    end
})

ExploitSection:AddToggle({
    Name = "Auto Heal",
    Default = false,
    Flag = "AutoHeal"
})

ExploitSection:AddToggle({
    Name = "Auto Reload",
    Default = false,
    Flag = "AutoReload"
})

ExploitSection:AddButton({
    Name = "Kill All Players",
    Callback = function()
        Library:Notify("Kill all executed", 3)
    end
})

ExploitSection:AddButton({
    Name = "Teleport to Spawn",
    Callback = function()
        Library:Notify("Teleported to spawn", 2)
    end
})

ExploitSection:AddDropdown({
    Name = "Weapon Select",
    Options = {"AK47", "M4A1", "AWP", "MP5", "Desert Eagle"},
    Default = "AK47",
    Flag = "WeaponSelect",
    Callback = function(value)
        print("Selected weapon:", value)
    end
})

local LocalPlayerSection = MiscTab:AddSection("Local Player")

LocalPlayerSection:AddToggle({
    Name = "God Mode",
    Default = false,
    Flag = "GodMode",
    Callback = function(value)
        Library:Notify("God Mode " .. (value and "enabled" or "disabled"), 2)
    end
})

LocalPlayerSection:AddSlider({
    Name = "Health",
    Min = 0,
    Max = 500,
    Default = 100,
    Increment = 10,
    Flag = "Health"
})

LocalPlayerSection:AddSlider({
    Name = "Jump Power",
    Min = 50,
    Max = 300,
    Default = 50,
    Increment = 10,
    Flag = "JumpPower"
})

LocalPlayerSection:AddToggle({
    Name = "No Fall Damage",
    Default = false,
    Flag = "NoFallDamage"
})

LocalPlayerSection:AddLabel("Hold CTRL to open menu")

LocalPlayerSection:AddImage({
    Image = "6588984328",
    Size = UDim2.new(0, 80, 0, 80)
})

Library:Notify("UI Loaded Successfully!", 3)
