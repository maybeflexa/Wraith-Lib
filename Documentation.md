
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
```
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
    Title = "Wraith " .. "v1.0.0",
    SubTitle = "by maybeflexa",
    Size = UDim2.new(0, 630, 0, 370),
    MinimizeKey = Enum.KeyCode.LeftControl,
    TabWidth = 175,
    Resizable = true,
    Searchable = true,
    MinSize = Vector2.new(450, 280)
})

local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

Wraith:Notify({
    Title = "Notification",
    Content = "This is a notification",
    SubContent = "SubContent",
    Duration = 5
})

Tabs.Main:AddParagraph({
    Title = "Paragraph",
    Content = "This is a paragraph.\nSecond line!"
})

Tabs.Main:AddButton({
    Title = "Button",
    Description = "Very important button",
    Callback = function()
        Wraith:Dialog({
            Title = "Title",
            Content = "This is a dialog",
            Buttons = {
                {
                    Title = "Cancel",
                    Callback = function()
                        print("Cancelled the dialog.")
                    end
                },
                {
                    Title = "Confirm",
                    Callback = function()
                        print("Confirmed the dialog.")
                    end
                }
            }
        })
    end
})

local Toggle = Tabs.Main:AddToggle("MyToggle", {
    Title = "Toggle",
    Default = false,
    Callback = function(Value)
        print("Toggle changed:", Value)
    end
})

local Checkbox = Tabs.Main:AddCheckbox("MyCheckbox", {
    Title = "Checkbox",
    Description = "This is a checkbox",
    Default = true,
    Callback = function(Value)
        print("Checkbox changed:", Value)
    end
})

local Slider = Tabs.Main:AddSlider("Slider", {
    Title = "Slider",
    Description = "This is a slider",
    Default = 2,
    Min = 0,
    Max = 5,
    Rounding = 1,
    Callback = function(Value)
        print("Slider was changed:", Value)
    end
})

local Dropdown = Tabs.Main:AddDropdown("Dropdown", {
    Title = "Dropdown",
    Values = {"one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten", "eleven", "twelve", "thirteen", "fourteen"},
    Default = "one",
    Callback = function(Value)
        print("Dropdown changed:", Value)
    end
})

local MultiDropdown = Tabs.Main:AddMultiDropdown("MultiDropdown", {
    Title = "Multi Dropdown",
    Description = "You can select multiple values.",
    Values = {"one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten", "eleven", "twelve", "thirteen", "fourteen"},
    Default = {"seven", "twelve"},
    Callback = function(Value)
        local Values = {}
        for Val, State in next, Value do
            if State then
                table.insert(Values, Val)
            end
        end
        print("MultiDropdown changed:", table.concat(Values, ", "))
    end
})

local Colorpicker = Tabs.Main:AddColorpicker("Colorpicker", {
    Title = "Colorpicker",
    Default = Color3.fromRGB(96, 205, 255),
    Callback = function(Value)
        print("Colorpicker changed:", Value)
    end
})

local Keybind = Tabs.Main:AddKeybind("Keybind", {
    Title = "Keybind",
    Default = Enum.KeyCode.LeftControl,
    Callback = function(Value)
        print("Keybind pressed!")
    end,
    ChangedCallback = function(New)
        print("Keybind changed:", New and New.Name or "None")
    end
})

local Input = Tabs.Main:AddInput("Input", {
    Title = "Input",
    Default = "Default",
    Placeholder = "Placeholder",
    Numeric = false,
    Callback = function(Value)
        print("Input changed:", Value)
    end
})

Tabs.Main:AddDivider({ Text = "Number Spinner" })

local Spinner = Tabs.Main:AddNumberSpinner("Spinner", {
    Title = "Number Spinner",
    Description = "Click + or - to change value",
    Min = 0,
    Max = 100,
    Default = 10,
    Step = 5,
    Callback = function(Value)
        print("Spinner changed:", Value)
    end
})

Tabs.Main:AddDivider({ Text = "Multi Input" })

local MultiInput = Tabs.Main:AddMultiInput("MultiInput", {
    Title = "Multi Input",
    Description = "Multiple inputs in one row.",
    Fields = {
        { Name = "X", Default = "0", Placeholder = "X", Numeric = true },
        { Name = "Y", Default = "0", Placeholder = "Y", Numeric = true },
        { Name = "Z", Default = "0", Placeholder = "Z", Numeric = true }
    },
    Callback = function(Values)
        print("MultiInput changed:", Values.X, Values.Y, Values.Z)
    end
})

Tabs.Main:AddDivider({ Text = "Multi Slider" })

local MultiSlider = Tabs.Main:AddMultiSlider("MultiSlider", {
    Title = "Multi Slider",
    Description = "Multiple sliders in one element.",
    Fields = {
        { Name = "A", Min = 0, Max = 100, Default = 50, Suffix = "" },
        { Name = "B", Min = 0, Max = 100, Default = 25, Suffix = "" },
        { Name = "C", Min = 0, Max = 100, Default = 75, Suffix = "" }
    },
    Callback = function(Values)
        print("MultiSlider changed:", Values.A, Values.B, Values.C)
    end
})

Tabs.Main:AddDivider({ Text = "Info Elements" })

Tabs.Main:AddDateTime({
    Title = "Current Time",
    Format = "%H:%M:%S"
})

Tabs.Main:AddDateTime({
    Title = "Current Date",
    Format = "%d/%m/%Y"
})

Tabs.Main:AddStatusBar({
    Title = "FPS",
    UpdateInterval = 0.5,
    Getter = function()
        return math.floor(1 / game:GetService("RunService").Heartbeat:Wait())
    end
})

Tabs.Main:AddStatusBar({
    Title = "Players",
    UpdateInterval = 5,
    Getter = function()
        return #game.Players:GetPlayers()
    end
})

Tabs.Main:AddDivider({ Text = "Layout Elements" })

Tabs.Main:AddSeparator()

Tabs.Main:AddLabel({ Text = "This is a label." })

local Section = Tabs.Main:AddSection("Section")

Section:AddToggle("SectionToggle", {
    Title = "Toggle inside section",
    Default = false,
    Callback = function(Value)
        print("Section toggle:", Value)
    end
})

Section:AddSlider("SectionSlider", {
    Title = "Slider inside section",
    Min = 0,
    Max = 10,
    Default = 5,
    Rounding = 1,
    Callback = function(Value)
        print("Section slider:", Value)
    end
})

SaveManager:SetLibrary(Wraith)
InterfaceManager:SetLibrary(Wraith)

SaveManager:IgnoreThemeSettings()

SaveManager:SetIgnoreIndexes({})

InterfaceManager:SetFolder("WraithExample")
SaveManager:SetFolder("WraithExample/specific-game")

InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

Wraith:Notify({
    Title = "Wraith",
    Content = "The script has been loaded.",
    Duration = 8
})

SaveManager:LoadAutoloadConfig()
```
