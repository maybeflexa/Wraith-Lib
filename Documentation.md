
---

# Wraith LibUi — Documentation

Complete guide for Wraith LibUi. Every element explained with what it does, parameters, methods, and copy-paste examples.

---

## Installation

Load the library and addons:

```lua
local Wraith = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/maybeflexa/Wraith-Lib/refs/heads/main/Wraith/Src/Wraith.luau"
))()

local SaveManager = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/maybeflexa/Wraith-Lib/refs/heads/main/Wraith/Addons/SaveManager.lua"
))()

local InterfaceManager = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/maybeflexa/Wraith-Lib/refs/heads/main/Wraith/Addons/InterfaceManager.lua"
))()
```

---

## Window

The main UI container. Create one window per script.

```lua
local Window = Wraith:CreateWindow({
    Title = "My Hub",
    SubTitle = "v1.0.0",
    Size = UDim2.new(0, 630, 0, 370),
    MinimizeKey = Enum.KeyCode.LeftControl,
    TabWidth = 175,
    Resizable = true,
    Searchable = true,
    MinSize = Vector2.new(450, 280)
})
```

**Parameters:**
- `Title` — Window header text
- `SubTitle` — Small text under title (centers title if empty)
- `Size` — Initial window dimensions
- `MinimizeKey` — Key to toggle UI visibility
- `TabWidth` — Sidebar width in pixels
- `Resizable` — Allow user to drag bottom-right corner to resize
- `Searchable` — Show search bar in sidebar to filter elements
- `MinSize` — Minimum size when resizing

---

## Tabs

Tabs are pages in the sidebar. Each tab has its own scrollable content area.

```lua
local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "house" }),
    Combat = Window:AddTab({ Title = "Combat", Icon = "swords" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}
```

**Parameters:**
- `Title` — Tab name shown in sidebar
- `Icon` — Lucide icon name (optional)

**Popular icons:** `house`, `swords`, `eye`, `settings`, `user`, `shield`, `zap`, `heart`, `star`, `target`, `lock`, `bell`, `search`, `code`, `terminal`, `database`, `cloud`, `sun`, `moon`, `sparkles`

Full list: https://lucide.dev/icons

---

## API Syntax

Every element supports two styles. Use whichever you prefer:

**Fluent-style** (flag as first parameter, recommended for Fluent users):
```lua
local Toggle = Tabs.Main:AddToggle("MyFlag", {
    Title = "My Toggle",
    Default = false,
    Callback = function(v) print(v) end
})
```

**Table-style** (flag inside options table):
```lua
local Toggle = Tabs.Main:AddToggle({
    Title = "My Toggle",
    Flag = "MyFlag",
    Default = false,
    Callback = function(v) print(v) end
})
```

Both work identically.

---

## Elements

### Paragraph

**What it does:** Displays a title and a body of text. Use it for descriptions, info, or instructions.

```lua
local Info = Tabs.Main:AddParagraph("Welcome", {
    Content = "This is a welcome message with description text.",
    Tooltip = "Hover info"
})

-- Update later:
Info:Set({ Content = "Updated text" })
Info:SetTitle("New Title")
Info:SetDesc("New description")
```

---

### Button

**What it does:** Clickable button that runs a function when pressed.

```lua
Tabs.Main:AddButton("RejoinBtn", {
    Title = "Rejoin Server",
    Description = "Teleports you back to this server",
    Tooltip = "Click to rejoin",
    Callback = function()
        game:GetService("TeleportService"):Teleport(game.PlaceId)
    end
})
```

---

### Toggle

**What it does:** On/off switch. Best for enabling/disabling features.

```lua
local AutoFarm = Tabs.Main:AddToggle("AutoFarm", {
    Title = "Auto Farm",
    Description = "Automatically farms resources",
    Default = false,
    Callback = function(value)
        print("AutoFarm is now:", value)
    end
})

-- Get current state:
print(AutoFarm.Value)  -- true or false

-- Set state programmatically:
AutoFarm:Set(true)
```

---

### Checkbox

**What it does:** Same as toggle but with a checkmark style. Use for boolean options in lists.

```lua
local LogActions = Tabs.Main:AddCheckbox("LogActions", {
    Title = "Log to Console",
    Description = "Print all actions to console",
    Default = true,
    Callback = function(value)
        print("Logging:", value)
    end
})

LogActions:Set(false)
```

---

### Slider

**What it does:** Draggable bar for selecting a number in a range. Click the value text to type manually.

```lua
local WalkSpeed = Tabs.Main:AddSlider("WalkSpeed", {
    Title = "Walk Speed",
    Description = "Character movement speed",
    Min = 16,
    Max = 200,
    Default = 16,
    Rounding = 1,           -- step size
    Suffix = " studs/s",   -- text after value
    Callback = function(value)
        pcall(function()
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
        end)
    end
})

WalkSpeed:Set(100)
```

---

### Dropdown

**What it does:** Click to open a list, pick one option.

```lua
local GameMode = Tabs.Main:AddDropdown("GameMode", {
    Title = "Game Mode",
    Description = "Select difficulty",
    Values = {"Easy", "Medium", "Hard", "Extreme"},
    Default = "Easy",
    Callback = function(value)
        print("Selected:", value)
    end
})

GameMode:Set("Hard")

-- Replace all options:
GameMode:SetValues({"A", "B", "C"})
```

---

### MultiDropdown

**What it does:** Like dropdown but you can select multiple options at once. Returns a table.

```lua
local Targets = Tabs.Main:AddMultiDropdown("Targets", {
    Title = "Target Types",
    Description = "Pick which entities to target",
    Values = {"Players", "NPCs", "Bosses", "Animals"},
    Default = {"NPCs", "Bosses"},
    Callback = function(values)
        for name, enabled in pairs(values) do
            if enabled then
                print("Targeting:", name)
            end
        end
    end
})

Targets:Set({ Players = true, NPCs = true })
```

---

### Colorpicker

**What it does:** Opens a modal HSV color picker. User selects color and hits Apply.

```lua
local ESPColor = Tabs.Main:AddColorpicker("ESPColor", {
    Title = "ESP Color",
    Default = Color3.fromRGB(255, 0, 0),
    Callback = function(color)
        print("Hex:", "#" .. color:ToHex():upper())
    end
})

ESPColor:Set(Color3.fromRGB(0, 255, 0))
ESPColor:Set("#00FF00")  -- hex string works
```

---

### Keybind

**What it does:** Bind a keyboard key. Callback fires when the bound key is pressed. Press Escape to unbind.

```lua
local ToggleKey = Tabs.Main:AddKeybind("ToggleKey", {
    Title = "Toggle Aimbot",
    Default = Enum.KeyCode.E,
    Callback = function()
        print("Aimbot toggled!")
    end,
    ChangedCallback = function(key)
        print("Key changed to:", key and key.Name or "None")
    end
})

ToggleKey:Set(Enum.KeyCode.F)
ToggleKey:Set("F")  -- string works
```

---

### Input

**What it does:** Single-line text input field.

```lua
local Username = Tabs.Main:AddInput("Username", {
    Title = "Target Player",
    Description = "Enter player username",
    Default = "",
    Placeholder = "Type username...",
    Numeric = false,         -- set true to only allow numbers
    Callback = function(value)
        print("Target:", value)
    end
})

Username:Set("RandomGuy123")
```

---

### MultiInput

**What it does:** Multiple text inputs in a single row. Perfect for coordinates, RGB values, etc.

```lua
local Coords = Tabs.Main:AddMultiInput("Coords", {
    Title = "Teleport Position",
    Description = "Enter X, Y, Z",
    Fields = {
        { Name = "X", Default = "0", Placeholder = "X", Numeric = true },
        { Name = "Y", Default = "0", Placeholder = "Y", Numeric = true },
        { Name = "Z", Default = "0", Placeholder = "Z", Numeric = true }
    },
    Callback = function(values)
        print("X:", values.X, "Y:", values.Y, "Z:", values.Z)
    end
})

Coords:Set({ X = "100", Y = "50", Z = "200" })
```

---

### MultiSlider

**What it does:** Multiple sliders stacked in one element. Great for adjusting related stats together.

```lua
local Stats = Tabs.Main:AddMultiSlider("Stats", {
    Title = "Player Stats",
    Description = "Adjust HP, MP, and STR",
    Fields = {
        { Name = "HP",  Min = 0, Max = 1000, Default = 100, Suffix = "" },
        { Name = "MP",  Min = 0, Max = 500,  Default = 50,  Suffix = "" },
        { Name = "STR", Min = 1, Max = 100,  Default = 10,  Suffix = "" }
    },
    Callback = function(values)
        print("HP:", values.HP, "MP:", values.MP, "STR:", values.STR)
    end
})

Stats:Set({ HP = 500, MP = 250 })
```

---

### NumberSpinner

**What it does:** Number input with + and - buttons. Click buttons or type to change value.

```lua
local Amount = Tabs.Main:AddNumberSpinner("Amount", {
    Title = "Buy Amount",
    Min = 0,
    Max = 100,
    Default = 10,
    Step = 5,           -- increment per button click
    Callback = function(value)
        print("Amount:", value)
    end
})

Amount:Set(50)
```

---

### DateTime

**What it does:** Live clock or date display. Auto-updates every second.

```lua
-- Live clock:
Tabs.Main:AddDateTime({
    Title = "Current Time",
    Format = "%H:%M:%S"
})

-- Date:
Tabs.Main:AddDateTime({
    Title = "Today's Date",
    Format = "%d/%m/%Y"
})

-- Full datetime:
Tabs.Main:AddDateTime({
    Title = "Full",
    Format = "%Y-%m-%d %H:%M:%S"
})
```

**Format codes:**
- `%H` hour (24h)
- `%M` minute
- `%S` second
- `%d` day
- `%m` month
- `%Y` year

---

### StatusBar

**What it does:** Auto-updating display that calls a function repeatedly and shows the result. Perfect for FPS, ping, player count, etc.

```lua
-- FPS counter:
Tabs.Main:AddStatusBar({
    Title = "FPS",
    UpdateInterval = 0.5,
    Getter = function()
        return math.floor(1 / game:GetService("RunService").Heartbeat:Wait())
    end
})

-- Player count:
Tabs.Main:AddStatusBar({
    Title = "Players",
    UpdateInterval = 5,
    Getter = function()
        return #game.Players:GetPlayers()
    end
})

-- Ping:
Tabs.Main:AddStatusBar({
    Title = "Ping",
    UpdateInterval = 2,
    Getter = function()
        return math.floor(
            game.Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
        ) .. " ms"
    end
})
```

---

### Separator

**What it does:** Simple horizontal line. Use to visually separate elements.

```lua
Tabs.Main:AddSeparator()
```

---

### Divider

**What it does:** Horizontal line with a label in the middle. Use to start a new section.

```lua
Tabs.Main:AddDivider({ Text = "Combat Settings" })
Tabs.Main:AddDivider({ Text = "Visuals" })
Tabs.Main:AddDivider({ Text = "Misc" })
```

---

### Label

**What it does:** Simple text label without background. Good for version info, notes, credits.

```lua
local Version = Tabs.Main:AddLabel({ Text = "v1.0.0" })

-- Update:
Version:Set("v2.0.0")
```

---

### Section

**What it does:** Group multiple elements under a titled section. All element methods are available inside.

```lua
local CombatSection = Tabs.Main:AddSection("Combat Options")

CombatSection:AddToggle("KillAura", {
    Title = "Kill Aura",
    Default = false,
    Callback = function() end
})

CombatSection:AddSlider("Range", {
    Title = "Range",
    Min = 5,
    Max = 50,
    Default = 15,
    Callback = function() end
})
```

---

## Notifications

**What it does:** Pop-up message in the bottom-right corner. Max 5 visible at once.

```lua
Wraith:Notify({
    Title = "Success",
    Content = "Operation completed!",
    SubContent = "Additional info",
    Duration = 5
})
```

---

## Dialogs

**What it does:** Modal confirmation popup. Blocks UI behind it until user clicks a button.

```lua
Wraith:Dialog({
    Title = "Confirm",
    Content = "Are you sure you want to proceed?",
    Buttons = {
        { Title = "Cancel", Callback = function() end },
        { Title = "Confirm", Callback = function()
            print("Confirmed!")
        end }
    }
})
```

The **last button** is highlighted as the primary action (accent color).

---

## Theme System

**Built-in themes:** `AMOLED`, `Dark`, `Darker`, `Midnight`, `Charcoal`, `Light`, `Obsidian`

```lua
-- Change theme:
Wraith:SetTheme("Midnight")

-- Add custom theme:
Wraith:AddTheme("Ocean", {
    Bg = Color3.fromRGB(8, 12, 20),
    Bg2 = Color3.fromRGB(14, 20, 32),
    Bg3 = Color3.fromRGB(22, 30, 44),
    El = Color3.fromRGB(18, 25, 38),
    ElHov = Color3.fromRGB(30, 40, 55),
    Border = Color3.fromRGB(40, 52, 68),
    Txt = Color3.fromRGB(220, 230, 245),
    Txt2 = Color3.fromRGB(140, 160, 185),
    Txt3 = Color3.fromRGB(90, 110, 135),
    Acc = Color3.fromRGB(100, 160, 220),
    AccD = Color3.fromRGB(70, 120, 180),
    TOn = Color3.fromRGB(110, 170, 230),
    TOff = Color3.fromRGB(35, 45, 60),
    Slider = Color3.fromRGB(90, 150, 210),
    BgTr = 0.1,
    ElTr = 0.38,
    SbTr = 0.18
})

-- Get all theme names:
local themes = Wraith:GetThemes()
```

Theme preference auto-saves and loads on next run.

---

## Theme Editor

**What it does:** Visual editor to design your own theme. Pick colors with color picker, preview live, save when ready.

```lua
Wraith:OpenThemeEditor()
```

---

## Animation System

**What it does:** Change how UI elements animate (transitions, hovers, etc.)

```lua
Wraith:SetAnimation("Bounce")
```

**Available presets:**
- `Default` — Standard smooth (Quart, 0.25s)
- `Bounce` — Bouncy pop (0.5s)
- `Elastic` — Springy overshoot (0.6s)
- `Smooth` — Gentle ease (Sine, 0.4s)
- `Snappy` — Quick with slight overshoot (Back, 0.3s)
- `Fade` — Linear fade (0.35s)

---

## Tooltip System

**What it does:** Show a small hint text when user hovers over an element. Add `Tooltip` parameter to any element.

```lua
Tabs.Main:AddButton("Btn", {
    Title = "Mysterious Button",
    Tooltip = "This button does something mysterious",
    Callback = function() end
})
```

---

## Window Methods

```lua
Window:Show()              -- show window with animation
Window:Hide()              -- hide window (reopen with keybind)
Window:Minimize()          -- minimize (floating button on mobile)
Window:Destroy()           -- destroy entirely
Window:Resize(800, 500)    -- programmatic resize
```

---

## Flags System

Every element with a `Flag` is stored globally and can be accessed from anywhere:

```lua
-- Get value:
local isOn = Wraith.Flags["AutoFarm"].Value

-- Set value:
Wraith.Flags["WalkSpeed"]:Set(100)

-- Check in a loop:
if Wraith.Flags["AutoFarm"].Value then
    -- do something
end
```

---

## Addons

### SaveManager

**What it does:** Save/load all UI flag values to JSON files. Supports autoload (loads saved config on script start).

```lua
SaveManager:SetLibrary(Wraith)
SaveManager:IgnoreThemeSettings()  -- don't save theme in configs
SaveManager:SetFolder("Wraith/MyHub")  -- folder path

-- Build the full config UI in a tab:
SaveManager:BuildConfigSection(Tabs.Settings)

-- Load autoload config at script start:
SaveManager:LoadAutoloadConfig()
```

**Manual methods:**
```lua
SaveManager:Save("myconfig")
SaveManager:Load("myconfig")
SaveManager:Delete("myconfig")

local configs = SaveManager:RefreshConfigList()
SaveManager:SetAutoloadConfig("myconfig")
SaveManager:DeleteAutoLoadConfig()
```

---

### InterfaceManager

**What it does:** Save/load theme and animation preferences. Builds a settings UI section.

```lua
InterfaceManager:SetLibrary(Wraith)
InterfaceManager:SetFolder("Wraith/MyHub")

-- Build theme/animation settings UI:
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
```

This auto-adds:
- Theme dropdown (saves on change)
- Animation dropdown (saves on change)
- Theme Editor button
- Menu keybind selector

---

## Full Example

```lua
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
    Title = "Wraith Hub",
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
    Content = "Welcome to Wraith Hub! This example demonstrates every single element available in the library.",
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

Tabs.Misc:AddLabel({ Text = "Wraith Hub v1.0.0" })
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
    Title = "Wraith Hub",
    Content = "Script loaded successfully!",
    SubContent = "All features are ready. Press LCtrl to toggle UI.",
    Duration = 6
})

SaveManager:LoadAutoloadConfig()
```

---
