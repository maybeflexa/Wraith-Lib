local Wraith = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/maybeflexa/Wraith-Lib/refs/heads/main/Wraith/Src/Wraith.luau"
))()

local SaveManager = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/maybeflexa/Wraith-Lib/refs/heads/main/Wraith/Addons/SaveManager.lua"
))()

local InterfaceManager = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/maybeflexa/Wraith-Lib/refs/heads/main/Wraith/Addons/InterfaceManager.lua"
))()

local Window = Wraith:CreateWindow({
    Title = "Test Hub",
    SubTitle = "v1.0.0",
    Size = UDim2.new(0, 630, 0, 370),
    MinimizeKey = Enum.KeyCode.LeftControl,
    TabWidth = 175,
    Resizable = true,
    Searchable = true,
    MinSize = Vector2.new(450, 280)
})

local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "house" }),
    Combat = Window:AddTab({ Title = "Combat", Icon = "swords" }),
    Visuals = Window:AddTab({ Title = "Visuals", Icon = "eye" }),
    Misc = Window:AddTab({ Title = "Misc", Icon = "sparkles" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

Tabs.Main:AddParagraph("Welcome", {
    Content = "Welcome to Test This example demonstrates every single element available in the library.",
    Tooltip = "This is a paragraph element"
})

Tabs.Main:AddDivider({ Text = "Toggles and Checkboxes" })

Tabs.Main:AddToggle("AutoFarm", {
    Title = "Auto Farm",
    Description = "Automatically farms resources for you",
    Default = false,
    Tooltip = "Enable to start farming",
    Callback = function(value)
        print("Auto Farm:", value)
    end
})

Tabs.Main:AddToggle("AntiAFK", {
    Title = "Anti AFK",
    Description = "Prevents you from being kicked for inactivity",
    Default = true,
    Callback = function(value)
        print("Anti AFK:", value)
    end
})

Tabs.Main:AddCheckbox("LogActions", {
    Title = "Log Actions",
    Description = "Print all script actions to console",
    Default = false,
    Callback = function(value)
        print("Logging:", value)
    end
})

Tabs.Main:AddCheckbox("ShowNotifs", {
    Title = "Show Notifications",
    Default = true,
    Callback = function(value)
        print("Notifications:", value)
    end
})

Tabs.Main:AddDivider({ Text = "Sliders" })

Tabs.Main:AddSlider("WalkSpeed", {
    Title = "Walk Speed",
    Description = "Adjust your character movement speed",
    Min = 16,
    Max = 200,
    Default = 16,
    Rounding = 1,
    Suffix = " studs/s",
    Tooltip = "Drag the knob or click value to type",
    Callback = function(value)
        pcall(function()
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
        end)
    end
})

Tabs.Main:AddSlider("JumpPower", {
    Title = "Jump Power",
    Description = "How high you can jump",
    Min = 50,
    Max = 500,
    Default = 50,
    Rounding = 5,
    Callback = function(value)
        pcall(function()
            game.Players.LocalPlayer.Character.Humanoid.JumpPower = value
        end)
    end
})

Tabs.Main:AddSlider("FOV", {
    Title = "Field of View",
    Min = 30,
    Max = 120,
    Default = 70,
    Rounding = 1,
    Callback = function(value)
        pcall(function()
            game.Workspace.CurrentCamera.FieldOfView = value
        end)
    end
})

Tabs.Main:AddDivider({ Text = "Inputs" })

Tabs.Main:AddInput("TargetPlayer", {
    Title = "Target Player",
    Description = "Enter the username of the player to target",
    Default = "",
    Placeholder = "Username...",
    Callback = function(value)
        print("Target:", value)
    end
})

Tabs.Main:AddInput("WebhookURL", {
    Title = "Webhook URL",
    Description = "Discord webhook for notifications",
    Default = "",
    Placeholder = "https://discord.com/api/webhooks/...",
    Callback = function(value)
        print("Webhook:", value)
    end
})

Tabs.Main:AddInput("CustomMessage", {
    Title = "Custom Message",
    Placeholder = "Type anything...",
    Callback = function(value)
        print("Message:", value)
    end
})

Tabs.Main:AddDivider({ Text = "Multi Input" })

Tabs.Main:AddMultiInput("TeleportCoords", {
    Title = "Teleport Position",
    Description = "Enter X, Y, Z coordinates to teleport",
    Fields = {
        { Name = "X", Default = "0", Placeholder = "X", Numeric = true },
        { Name = "Y", Default = "100", Placeholder = "Y", Numeric = true },
        { Name = "Z", Default = "0", Placeholder = "Z", Numeric = true }
    },
    Callback = function(values)
        print("Coords:", values.X, values.Y, values.Z)
    end
})

Tabs.Main:AddMultiInput("RGBValues", {
    Title = "RGB Color Input",
    Description = "Enter R, G, B values manually",
    Fields = {
        { Name = "R", Default = "255", Placeholder = "R", Numeric = true },
        { Name = "G", Default = "255", Placeholder = "G", Numeric = true },
        { Name = "B", Default = "255", Placeholder = "B", Numeric = true }
    },
    Callback = function(values)
        print("RGB:", values.R, values.G, values.B)
    end
})

Tabs.Main:AddDivider({ Text = "Number Spinners" })

Tabs.Main:AddNumberSpinner("BuyAmount", {
    Title = "Buy Amount",
    Min = 1,
    Max = 100,
    Default = 10,
    Step = 5,
    Callback = function(value)
        print("Amount:", value)
    end
})

Tabs.Main:AddNumberSpinner("RepeatCount", {
    Title = "Repeat Count",
    Min = 1,
    Max = 50,
    Default = 1,
    Step = 1,
    Callback = function(value)
        print("Repeat:", value)
    end
})

Tabs.Main:AddDivider({ Text = "Buttons" })

Tabs.Main:AddButton("NotifyTest", {
    Title = "Test Notification",
    Description = "Sends a test notification to the screen",
    Tooltip = "Click to send a notification",
    Callback = function()
        Wraith:Notify({
            Title = "Test Notification",
            Content = "This is a test notification from the example script.",
            SubContent = "It will disappear in 5 seconds.",
            Duration = 5
        })
    end
})

Tabs.Main:AddButton("DialogTest", {
    Title = "Test Dialog",
    Description = "Opens a confirmation dialog",
    Callback = function()
        Wraith:Dialog({
            Title = "Confirm Action",
            Content = "Are you sure you want to proceed? This is an example dialog with two buttons.",
            Buttons = {
                {
                    Title = "Cancel",
                    Callback = function()
                        Wraith:Notify({
                            Title = "Cancelled",
                            Content = "Action was cancelled.",
                            Duration = 3
                        })
                    end
                },
                {
                    Title = "Confirm",
                    Callback = function()
                        Wraith:Notify({
                            Title = "Confirmed",
                            Content = "Action was confirmed!",
                            Duration = 3
                        })
                    end
                }
            }
        })
    end
})

Tabs.Main:AddButton("RejoinBtn", {
    Title = "Rejoin Server",
    Callback = function()
        Wraith:Dialog({
            Title = "Rejoin",
            Content = "Do you want to rejoin this server?",
            Buttons = {
                { Title = "No", Callback = function() end },
                { Title = "Yes", Callback = function()
                    game:GetService("TeleportService"):Teleport(game.PlaceId)
                end }
            }
        })
    end
})

Tabs.Combat:AddParagraph("Combat", {
    Content = "Configure all combat-related settings here."
})

Tabs.Combat:AddDivider({ Text = "Main" })

Tabs.Combat:AddToggle("KillAura", {
    Title = "Kill Aura",
    Description = "Automatically attacks nearby enemies",
    Default = false,
    Callback = function(value)
        print("Kill Aura:", value)
    end
})

Tabs.Combat:AddToggle("AutoParry", {
    Title = "Auto Parry",
    Description = "Automatically parries incoming attacks",
    Default = false,
    Callback = function(value)
        print("Auto Parry:", value)
    end
})

Tabs.Combat:AddSlider("AttackRange", {
    Title = "Attack Range",
    Description = "How far Kill Aura can reach",
    Min = 5,
    Max = 50,
    Default = 15,
    Suffix = " studs",
    Callback = function(value)
        print("Range:", value)
    end
})

Tabs.Combat:AddSlider("AttackSpeed", {
    Title = "Attack Speed",
    Min = 1,
    Max = 20,
    Default = 5,
    Rounding = 0.5,
    Suffix = " hits/s",
    Callback = function(value)
        print("Speed:", value)
    end
})

Tabs.Combat:AddDivider({ Text = "Multi Sliders" })

Tabs.Combat:AddMultiSlider("CombatStats", {
    Title = "Combat Stats",
    Description = "Adjust damage, defense, and speed together",
    Fields = {
        { Name = "Damage", Min = 1, Max = 100, Default = 10, Suffix = "" },
        { Name = "Defense", Min = 0, Max = 100, Default = 5, Suffix = "" },
        { Name = "Speed", Min = 1, Max = 50, Default = 10, Suffix = "" }
    },
    Callback = function(values)
        print("DMG:", values.Damage, "DEF:", values.Defense, "SPD:", values.Speed)
    end
})

Tabs.Combat:AddDivider({ Text = "Targeting" })

Tabs.Combat:AddDropdown("AttackMode", {
    Title = "Attack Mode",
    Description = "How to select targets",
    Values = {"Nearest", "Lowest HP", "Highest Level", "Random"},
    Default = "Nearest",
    Callback = function(value)
        print("Mode:", value)
    end
})

Tabs.Combat:AddMultiDropdown("TargetTypes", {
    Title = "Target Types",
    Description = "Which entity types to target",
    Values = {"Players", "NPCs", "Bosses", "Animals", "Monsters"},
    Default = {"NPCs", "Monsters"},
    Callback = function(values)
        local selected = {}
        for name, enabled in pairs(values) do
            if enabled then
                table.insert(selected, name)
            end
        end
        print("Targets:", table.concat(selected, ", "))
    end
})

Tabs.Combat:AddDropdown("WeaponSelect", {
    Title = "Weapon",
    Values = {"Sword", "Bow", "Staff", "Fists"},
    Default = "Sword",
    Callback = function(value)
        print("Weapon:", value)
    end
})

Tabs.Combat:AddDivider({ Text = "Keybinds" })

Tabs.Combat:AddKeybind("CombatToggle", {
    Title = "Toggle Combat",
    Default = Enum.KeyCode.X,
    Callback = function()
        print("Combat toggled!")
        Wraith:Notify({
            Title = "Combat",
            Content = "Combat toggled!",
            Duration = 2
        })
    end,
    ChangedCallback = function(key)
        if key then
            print("Combat key changed to:", key.Name)
        end
    end
})

Tabs.Combat:AddKeybind("ParryKey", {
    Title = "Parry Key",
    Default = Enum.KeyCode.F,
    Callback = function()
        print("Manual parry!")
    end
})

Tabs.Visuals:AddParagraph("Visuals", {
    Content = "Customize ESP, chams, and other visual features."
})

Tabs.Visuals:AddDivider({ Text = "ESP Toggles" })

Tabs.Visuals:AddToggle("ESPEnabled", {
    Title = "ESP Enabled",
    Description = "Show player ESP boxes",
    Default = false,
    Callback = function(value)
        print("ESP:", value)
    end
})

Tabs.Visuals:AddToggle("ChamsEnabled", {
    Title = "Chams Enabled",
    Description = "Highlight players through walls",
    Default = false,
    Callback = function(value)
        print("Chams:", value)
    end
})

Tabs.Visuals:AddToggle("TracersEnabled", {
    Title = "Tracers",
    Default = false,
    Callback = function() end
})

Tabs.Visuals:AddDivider({ Text = "ESP Options" })

Tabs.Visuals:AddCheckbox("ShowNames", {
    Title = "Show Names",
    Default = true,
    Callback = function() end
})

Tabs.Visuals:AddCheckbox("ShowHealth", {
    Title = "Show Health Bars",
    Default = true,
    Callback = function() end
})

Tabs.Visuals:AddCheckbox("ShowDistance", {
    Title = "Show Distance",
    Default = false,
    Callback = function() end
})

Tabs.Visuals:AddCheckbox("ShowWeapon", {
    Title = "Show Equipped Weapon",
    Default = false,
    Callback = function() end
})

Tabs.Visuals:AddDivider({ Text = "Colors" })

Tabs.Visuals:AddColorpicker("ESPColor", {
    Title = "ESP Color",
    Default = Color3.fromRGB(255, 255, 255),
    Callback = function(color)
        print("ESP:", "#" .. color:ToHex():upper())
    end
})

Tabs.Visuals:AddColorpicker("ChamsColor", {
    Title = "Chams Color",
    Default = Color3.fromRGB(150, 0, 255),
    Callback = function(color)
        print("Chams:", "#" .. color:ToHex():upper())
    end
})

Tabs.Visuals:AddColorpicker("TracerColor", {
    Title = "Tracer Color",
    Default = Color3.fromRGB(0, 255, 0),
    Callback = function() end
})

Tabs.Visuals:AddColorpicker("CrosshairColor", {
    Title = "Crosshair Color",
    Default = Color3.fromRGB(255, 0, 0),
    Callback = function() end
})

Tabs.Visuals:AddDivider({ Text = "Style" })

Tabs.Visuals:AddDropdown("ESPStyle", {
    Title = "ESP Style",
    Description = "Visual style of ESP boxes",
    Values = {"Box", "Corner", "3D", "Skeleton"},
    Default = "Box",
    Callback = function(value)
        print("ESP Style:", value)
    end
})

Tabs.Visuals:AddSlider("ESPTransparency", {
    Title = "ESP Transparency",
    Min = 0,
    Max = 100,
    Default = 50,
    Rounding = 5,
    Suffix = "%",
    Callback = function(value)
        print("ESP Trans:", value)
    end
})

Tabs.Visuals:AddSlider("TracerThickness", {
    Title = "Tracer Thickness",
    Min = 1,
    Max = 5,
    Default = 1,
    Rounding = 0.5,
    Suffix = "px",
    Callback = function() end
})

Tabs.Misc:AddParagraph("Miscellaneous", {
    Content = "Extra tools and information displays."
})

Tabs.Misc:AddDivider({ Text = "Information" })

Tabs.Misc:AddDateTime({
    Title = "Current Time",
    Format = "%H:%M:%S"
})

Tabs.Misc:AddDateTime({
    Title = "Today's Date",
    Format = "%d/%m/%Y"
})

Tabs.Misc:AddDateTime({
    Title = "Full DateTime",
    Format = "%Y-%m-%d %H:%M:%S"
})

Tabs.Misc:AddDivider({ Text = "Live Stats" })

Tabs.Misc:AddStatusBar({
    Title = "FPS",
    UpdateInterval = 0.5,
    Getter = function()
        return math.floor(1 / game:GetService("RunService").Heartbeat:Wait())
    end
})

Tabs.Misc:AddStatusBar({
    Title = "Players Online",
    UpdateInterval = 5,
    Getter = function()
        return #game.Players:GetPlayers()
    end
})

Tabs.Misc:AddStatusBar({
    Title = "Ping",
    UpdateInterval = 2,
    Getter = function()
        local ok, val = pcall(function()
            return math.floor(
                game.Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
            )
        end)
        return ok and (val .. " ms") or "N/A"
    end
})

Tabs.Misc:AddStatusBar({
    Title = "Memory Usage",
    UpdateInterval = 3,
    Getter = function()
        local ok, val = pcall(function()
            return math.floor(
                game:GetService("Stats"):GetTotalMemoryUsageMb()
            )
        end)
        return ok and (val .. " MB") or "N/A"
    end
})

Tabs.Misc:AddDivider({ Text = "Sections Demo" })

local ToolsSection = Tabs.Misc:AddSection("Utility Tools")

ToolsSection:AddButton("CopyPlaceId", {
    Title = "Copy Place ID",
    Description = "Copies the current game's Place ID",
    Callback = function()
        pcall(function()
            if setclipboard then
                setclipboard(tostring(game.PlaceId))
            end
        end)
        Wraith:Notify({
            Title = "Copied",
            Content = "Place ID: " .. tostring(game.PlaceId),
            Duration = 3
        })
    end
})

ToolsSection:AddButton("CopyJobId", {
    Title = "Copy Job ID",
    Description = "Copies the current server's Job ID",
    Callback = function()
        pcall(function()
            if setclipboard then
                setclipboard(game.JobId)
            end
        end)
        Wraith:Notify({
            Title = "Copied",
            Content = "Job ID copied to clipboard",
            Duration = 3
        })
    end
})

ToolsSection:AddToggle("InfiniteJump", {
    Title = "Infinite Jump",
    Default = false,
    Callback = function(value)
        print("Inf Jump:", value)
    end
})

ToolsSection:AddSlider("Gravity", {
    Title = "Gravity",
    Min = 0,
    Max = 500,
    Default = 196,
    Rounding = 1,
    Callback = function(value)
        game.Workspace.Gravity = value
    end
})

local TeleportSection = Tabs.Misc:AddSection("Teleport")

TeleportSection:AddMultiInput("TPCoords", {
    Title = "Coordinates",
    Description = "X, Y, Z position",
    Fields = {
        { Name = "X", Default = "0", Placeholder = "X", Numeric = true },
        { Name = "Y", Default = "100", Placeholder = "Y", Numeric = true },
        { Name = "Z", Default = "0", Placeholder = "Z", Numeric = true }
    },
    Callback = function(values)
        print("TP To:", values.X, values.Y, values.Z)
    end
})

TeleportSection:AddButton("TeleportGo", {
    Title = "Teleport",
    Description = "Teleport to the entered coordinates",
    Callback = function()
        local coords = Wraith.Flags["TPCoords"]
        if coords then
            local x = tonumber(coords.Value.X) or 0
            local y = tonumber(coords.Value.Y) or 0
            local z = tonumber(coords.Value.Z) or 0
            pcall(function()
                game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(
                    CFrame.new(x, y, z)
                )
            end)
            Wraith:Notify({
                Title = "Teleported",
                Content = string.format("Moved to (%d, %d, %d)", x, y, z),
                Duration = 3
            })
        end
    end
})

Tabs.Misc:AddDivider({ Text = "Multi Slider Demo" })

Tabs.Misc:AddMultiSlider("CharacterStats", {
    Title = "Character Stats",
    Description = "Adjust multiple character stats at once",
    Fields = {
        { Name = "HP", Min = 0, Max = 1000, Default = 100, Suffix = "" },
        { Name = "MP", Min = 0, Max = 500, Default = 50, Suffix = "" },
        { Name = "STR", Min = 1, Max = 100, Default = 10, Suffix = "" },
        { Name = "DEF", Min = 1, Max = 100, Default = 5, Suffix = "" }
    },
    Callback = function(values)
        print("HP:", values.HP, "MP:", values.MP, "STR:", values.STR, "DEF:", values.DEF)
    end
})

Tabs.Misc:AddDivider({ Text = "Miscellaneous" })

Tabs.Misc:AddLabel({ Text = "Test Hub" })
Tabs.Misc:AddLabel({ Text = "Made with Wraith UI Library" })

Tabs.Misc:AddSeparator()

Tabs.Misc:AddLabel({ Text = "github.com/maybeflexa/Wraith-Lib" })

SaveManager:SetLibrary(Wraith)
InterfaceManager:SetLibrary(Wraith)

SaveManager:IgnoreThemeSettings()

SaveManager:SetFolder("Wraith/WraithHub")
InterfaceManager:SetFolder("Wraith/WraithHub")

InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

Wraith:Notify({
    Title = "Test-Hub",
    Content = "Script loaded successfully!",
    SubContent = "All features are ready. Press LCtrl to toggle UI.",
    Duration = 6
})

SaveManager:LoadAutoloadConfig()
