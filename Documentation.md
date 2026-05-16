
## Documentation.md

# Wraith UI Library - Documentation

Complete documentation for Wraith UI Library. Every element, method, and addon explained with copy-paste ready examples.

---

## Table of Contents

- [Installation](#installation)
- [Window](#window)
- [Tabs](#tabs)
- [Elements](#elements)
  - [Paragraph](#paragraph)
  - [Button](#button)
  - [Toggle](#toggle)
  - [Checkbox](#checkbox)
  - [Slider](#slider)
  - [Dropdown](#dropdown)
  - [MultiDropdown](#multidropdown)
  - [Colorpicker](#colorpicker)
  - [Keybind](#keybind)
  - [Input](#input)
  - [NumberSpinner](#numberspinner)
  - [DateTime](#datetime)
  - [StatusBar](#statusbar)
  - [Separator](#separator)
  - [Divider](#divider)
  - [Label](#label)
  - [Section](#section)
- [Notifications](#notifications)
- [Dialogs](#dialogs)
- [Theme System](#theme-system)
  - [Built-in Themes](#built-in-themes)
  - [Set Theme](#set-theme)
  - [Custom Themes](#custom-themes)
  - [Theme Properties](#theme-properties)
- [Theme Editor](#theme-editor)
- [Animation System](#animation-system)
- [Tooltip System](#tooltip-system)
- [Window Methods](#window-methods)
- [Flags System](#flags-system)
- [Addons](#addons)
  - [SaveManager](#savemanager)
  - [InterfaceManager](#interfacemanager)
- [Full Example](#full-example)

---

## Installation

### Library only

```lua
local Wraith = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/maybeflexa/Wraith-Lib/refs/heads/main/Wraith/Src/Wraith.luau"
))()
```

### Library with addons

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

Create the main window. Only one window should be created per script.

```lua
local Window = Wraith:CreateWindow({
    Title = "My Script",
    SubTitle = "v1.0.0",
    Size = UDim2.new(0, 630, 0, 370),
    MinimizeKey = Enum.KeyCode.LeftControl,
    TabWidth = 175,
    Resizable = true,
    Searchable = true,
    MinSize = Vector2.new(450, 280)
})
```

### Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Title | string | "Wraith" | Window title |
| SubTitle | string | "" | Subtitle text. Title centers vertically if empty |
| Size | UDim2 | 630x370 | Initial window size |
| MinimizeKey | KeyCode | LeftControl | Key to toggle UI visibility |
| TabWidth | number | 170 | Sidebar width in pixels |
| Resizable | boolean | true | Allow resize from bottom-right corner |
| Searchable | boolean | true | Show search bar in sidebar |
| MinSize | Vector2 | 450x280 | Minimum resize dimensions |

---

## Tabs

Add tabs to the sidebar. Each tab has its own scrollable page.

```lua
local MyTab = Window:AddTab({
    Title = "General",
    Icon = "house"
})
```

### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| Title | string | Tab name displayed in sidebar |
| Icon | string | Lucide icon name (optional) |

### Common Lucide Icon Names

`house`, `swords`, `eye`, `settings`, `user`, `shield`, `zap`, `heart`, `star`, `target`, `globe`, `lock`, `unlock`, `bell`, `search`, `plus`, `minus`, `check`, `x`, `menu`, `arrow-right`, `arrow-left`, `download`, `upload`, `trash`, `edit`, `copy`, `save`, `folder`, `file`, `image`, `camera`, `mic`, `volume-2`, `wifi`, `bluetooth`, `battery`, `clock`, `calendar`, `map`, `compass`, `flag`, `bookmark`, `tag`, `gift`, `shopping-cart`, `credit-card`, `dollar-sign`, `percent`, `hash`, `at-sign`, `link`, `external-link`, `code`, `terminal`, `database`, `server`, `cloud`, `sun`, `moon`, `sparkles`

Full list at https://lucide.dev/icons

---

## Elements

### Paragraph

Text block with title and content.

```lua
local paragraph = MyTab:AddParagraph({
    Title = "Welcome",
    Content = "This is a description paragraph.",
    Tooltip = "Hover for more info"
})
```

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| Title | string | Bold title text (optional) |
| Content | string | Body text |
| Tooltip | string | Hover tooltip text (optional) |

#### Methods

```lua
paragraph:Set({Content = "Updated content text"})
```

---

### Button

Clickable button with optional description.

```lua
MyTab:AddButton({
    Title = "Click Me",
    Description = "This button does something cool",
    Tooltip = "Click to execute",
    Callback = function()
        print("Button was clicked!")
    end
})
```

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| Title | string | Button title |
| Description | string | Description text below title (optional) |
| Tooltip | string | Hover tooltip (optional) |
| Callback | function | Function called on click |

---

### Toggle

On/off switch with animation.

```lua
local toggle = MyTab:AddToggle({
    Title = "Auto Farm",
    Description = "Automatically farms resources",
    Default = false,
    Flag = "AutoFarm",
    Tooltip = "Toggle auto farming",
    Save = true,
    Callback = function(value)
        print("Auto Farm:", value)
    end
})
```

#### Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Title | string | "Toggle" | Toggle title |
| Description | string | "" | Description (optional) |
| Default | boolean | false | Initial state |
| Flag | string | Title | Unique identifier for saving |
| Tooltip | string | nil | Hover tooltip (optional) |
| Save | boolean | true | Include in config saves |
| Callback | function | nil | Called when value changes |

#### Methods

```lua
toggle:Set(true)
toggle:Set(false)
print(toggle.Value) -- true or false
```

---

### Checkbox

Checkmark style boolean selector.

```lua
local checkbox = MyTab:AddCheckbox({
    Title = "Enable Feature",
    Description = "Enables the cool feature",
    Default = true,
    Flag = "CoolFeature",
    Callback = function(value)
        print("Feature:", value)
    end
})
```

#### Parameters

Same as Toggle.

#### Methods

```lua
checkbox:Set(false)
print(checkbox.Value)
```

---

### Slider

Draggable value slider. Drag the knob to change value, or click the value text to type a number manually.

```lua
local slider = MyTab:AddSlider({
    Title = "Walk Speed",
    Description = "Adjust character movement speed",
    Min = 16,
    Max = 200,
    Default = 16,
    Rounding = 1,
    Suffix = " studs/s",
    Flag = "WalkSpeed",
    Tooltip = "Drag or type a value",
    Callback = function(value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
    end
})
```

#### Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Title | string | "Slider" | Slider title |
| Description | string | "" | Description (optional) |
| Min | number | 0 | Minimum value |
| Max | number | 100 | Maximum value |
| Default | number | Min | Starting value |
| Rounding | number | 1 | Step/increment size |
| Suffix | string | "" | Text after the value display |
| Flag | string | Title | Unique identifier |
| Tooltip | string | nil | Hover tooltip (optional) |
| Save | boolean | true | Include in config saves |
| Callback | function | nil | Called when value changes |

#### Methods

```lua
slider:Set(100)
print(slider.Value) -- 100
```

---

### Dropdown

Single selection dropdown menu.

```lua
local dropdown = MyTab:AddDropdown({
    Title = "Game Mode",
    Description = "Select difficulty",
    Values = {"Easy", "Medium", "Hard", "Extreme"},
    Default = "Easy",
    Flag = "GameMode",
    Callback = function(value)
        print("Mode:", value)
    end
})
```

#### Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Title | string | "Dropdown" | Dropdown title |
| Description | string | "" | Description (optional) |
| Values | table | {} | List of options |
| Default | string | nil | Initially selected value |
| Flag | string | Title | Unique identifier |
| Tooltip | string | nil | Hover tooltip (optional) |
| Save | boolean | true | Include in config saves |
| Callback | function | nil | Called when selection changes |

#### Methods

```lua
dropdown:Set("Hard")
dropdown:SetValues({"A", "B", "C", "D"}) -- replace all options
print(dropdown.Value) -- "Hard"
```

---

### MultiDropdown

Multiple selection dropdown menu.

```lua
local multi = MyTab:AddMultiDropdown({
    Title = "Target Types",
    Description = "Select which entities to target",
    Values = {"Players", "NPCs", "Bosses", "Animals"},
    Default = {"NPCs", "Bosses"},
    Flag = "TargetTypes",
    Callback = function(values)
        for name, enabled in pairs(values) do
            if enabled then
                print("Targeting:", name)
            end
        end
    end
})
```

#### Parameters

Same as Dropdown, but Default is a table of strings and the callback receives a table of `{[name] = boolean}`.

#### Methods

```lua
multi:Set({Players = true, NPCs = true, Bosses = false})
multi:SetValues({"A", "B", "C"})
-- multi.Value is a table: {Players = true, NPCs = true}
```

---

### Colorpicker

HSV color picker that opens as a modal dialog. Only closes via Cancel or Apply buttons.

```lua
local picker = MyTab:AddColorpicker({
    Title = "ESP Color",
    Default = Color3.fromRGB(255, 0, 0),
    Flag = "ESPColor",
    Tooltip = "Click to pick a color",
    Callback = function(color)
        print("Color:", color)
        print("Hex:", "#" .. color:ToHex():upper())
    end
})
```

#### Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Title | string | "Color" | Colorpicker title |
| Default | Color3 | White | Initial color |
| Flag | string | Title | Unique identifier |
| Tooltip | string | nil | Hover tooltip (optional) |
| Save | boolean | true | Include in config saves |
| Callback | function | nil | Called when color is applied |

#### Methods

```lua
picker:Set(Color3.fromRGB(0, 255, 0))
picker:Set("#00FF00") -- hex string works too
print(picker.Value) -- Color3
```

---

### Keybind

Keyboard key binding selector. Click the button then press a key to bind. Press Escape to unbind.

```lua
local keybind = MyTab:AddKeybind({
    Title = "Toggle Key",
    Default = Enum.KeyCode.E,
    Flag = "ToggleKey",
    Callback = function(key)
        print("Key was pressed!")
    end,
    ChangedCallback = function(key)
        if key then
            print("Keybind changed to:", key.Name)
        else
            print("Keybind cleared")
        end
    end
})
```

#### Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Title | string | "Keybind" | Keybind title |
| Default | KeyCode | nil | Initial key |
| Flag | string | Title | Unique identifier |
| Tooltip | string | nil | Hover tooltip (optional) |
| Save | boolean | true | Include in config saves |
| Callback | function | nil | Called when the bound key is pressed |
| ChangedCallback | function | nil | Called when the binding changes |

#### Methods

```lua
keybind:Set(Enum.KeyCode.F)
keybind:Set("F") -- string works too
print(keybind.Value) -- Enum.KeyCode.F or nil
```

---

### Input

Text input field with optional numeric mode.

```lua
local input = MyTab:AddInput({
    Title = "Username",
    Description = "Enter the target player name",
    Default = "",
    Placeholder = "Type here...",
    Numeric = false,
    Flag = "TargetName",
    Callback = function(value)
        print("Input:", value)
    end
})
```

#### Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Title | string | "Input" | Input title |
| Description | string | "" | Description (optional) |
| Default | string | "" | Initial text |
| Placeholder | string | "Type..." | Placeholder text |
| Numeric | boolean | false | Only allow numbers |
| Flag | string | Title | Unique identifier |
| Tooltip | string | nil | Hover tooltip (optional) |
| Save | boolean | true | Include in config saves |
| Callback | function | nil | Called when input loses focus |

#### Methods

```lua
input:Set("NewValue")
print(input.Value)
```

---

### NumberSpinner

Number selector with +/- buttons and manual text input.

```lua
local spinner = MyTab:AddNumberSpinner({
    Title = "Amount",
    Min = 0,
    Max = 1000,
    Default = 100,
    Step = 10,
    Flag = "Amount",
    Callback = function(value)
        print("Amount:", value)
    end
})
```

#### Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Title | string | "Number" | Spinner title |
| Min | number | 0 | Minimum value |
| Max | number | 100 | Maximum value |
| Default | number | Min | Initial value |
| Step | number | 1 | Increment per button click |
| Flag | string | Title | Unique identifier |
| Tooltip | string | nil | Hover tooltip (optional) |
| Save | boolean | true | Include in config saves |
| Callback | function | nil | Called when value changes |

#### Methods

```lua
spinner:Set(500)
print(spinner.Value)
```

---

### DateTime

Live updating clock or date display. Updates every second.

```lua
MyTab:AddDateTime({
    Title = "Current Time",
    Format = "%H:%M:%S"
})

MyTab:AddDateTime({
    Title = "Today's Date",
    Format = "%d/%m/%Y"
})

MyTab:AddDateTime({
    Title = "Full DateTime",
    Format = "%Y-%m-%d %H:%M:%S"
})
```

#### Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Title | string | "Time" | Display title |
| Format | string | "%H:%M:%S" | Lua os.date format string |

#### Common Format Codes

| Code | Output | Example |
|------|--------|---------|
| %H | Hour (24h) | 14 |
| %M | Minute | 30 |
| %S | Second | 45 |
| %d | Day | 25 |
| %m | Month | 12 |
| %Y | Year | 2024 |
| %A | Day name | Monday |
| %B | Month name | December |

---

### StatusBar

Auto-updating value display. Runs a getter function at a set interval.

```lua
MyTab:AddStatusBar({
    Title = "FPS",
    UpdateInterval = 0.5,
    Getter = function()
        return math.floor(1 / game:GetService("RunService").Heartbeat:Wait())
    end
})

MyTab:AddStatusBar({
    Title = "Players Online",
    UpdateInterval = 5,
    Getter = function()
        return #game.Players:GetPlayers()
    end
})

MyTab:AddStatusBar({
    Title = "Ping",
    UpdateInterval = 2,
    Getter = function()
        return math.floor(
            game.Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
        ) .. " ms"
    end
})
```

#### Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Title | string | "Status" | Display title |
| UpdateInterval | number | 1 | Seconds between updates |
| Getter | function | nil | Function that returns the display value |

#### Methods

```lua
local status = MyTab:AddStatusBar({...})
status:Set("Custom Value") -- manually override
```

---

### Separator

Simple horizontal line to separate elements.

```lua
MyTab:AddSeparator()
```

No parameters.

---

### Divider

Labeled section divider with horizontal lines on both sides.

```lua
MyTab:AddDivider({Text = "Combat Settings"})
```

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| Text | string | Divider label text |

---

### Label

Simple text label. Useful for version info or notes.

```lua
local label = MyTab:AddLabel({Text = "Version 1.0.0"})
```

#### Methods

```lua
label:Set("Version 2.0.0")
```

---

### Section

Group elements under a titled section. All element methods are available inside sections.

```lua
local section = MyTab:AddSection({Title = "Advanced Options"})

section:AddToggle({
    Title = "Feature A",
    Default = false,
    Flag = "FeatureA",
    Callback = function() end
})

section:AddSlider({
    Title = "Power",
    Min = 0,
    Max = 100,
    Default = 50,
    Flag = "Power",
    Callback = function() end
})

section:AddDropdown({
    Title = "Type",
    Values = {"Alpha", "Beta", "Gamma"},
    Default = "Alpha",
    Flag = "Type",
    Callback = function() end
})
```

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| Title | string | Section header text (optional) |

---

## Notifications

Display temporary notification messages. Maximum 5 visible at once.

```lua
Wraith:Notify({
    Title = "Success",
    Content = "Operation completed!",
    SubContent = "Additional details here",
    Duration = 5
})
```

#### Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Title | string | "Wraith" | Notification title |
| Content | string | "" | Main message |
| SubContent | string | "" | Additional text below content (optional) |
| Duration | number | 5 | Display duration in seconds |

---

## Dialogs

Modal dialog that blocks interaction with the UI behind it.

```lua
Wraith:Dialog({
    Title = "Confirm Action",
    Content = "Are you sure you want to proceed? This cannot be undone.",
    Buttons = {
        {
            Title = "Cancel",
            Callback = function()
                print("User cancelled")
            end
        },
        {
            Title = "Confirm",
            Callback = function()
                print("User confirmed")
            end
        }
    }
})
```

The last button in the list is styled as the primary (accent color) button.

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| Title | string | Dialog title |
| Content | string | Dialog message |
| Buttons | table | List of button objects |

#### Button Object

| Parameter | Type | Description |
|-----------|------|-------------|
| Title | string | Button text |
| Callback | function | Called when button is clicked |

---

## Theme System

### Built-in Themes

| Theme | Description |
|-------|-------------|
| AMOLED | Pure black, high contrast |
| Dark | Standard dark theme |
| Darker | Very dark, low contrast |
| Midnight | Dark blue tint |
| Charcoal | Warm dark gray |
| Light | Light mode |
| Obsidian | Near-black with subtle tint |

### Set Theme

```lua
Wraith:SetTheme("Dark")
```

Theme preference is automatically saved to `Wraith/theme.txt` and restored on next load.

### Get Available Themes

```lua
local themes = Wraith:GetThemes()
-- Returns: {"AMOLED", "Dark", "Darker", "Midnight", "Charcoal", "Light", "Obsidian", ...}
```

### Custom Themes

Create and save custom themes:

```lua
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

Wraith:SetTheme("Ocean")
```

Custom themes are saved to `Wraith/themes/` as JSON files and persist across sessions.

### Theme Properties

| Property | Type | Description |
|----------|------|-------------|
| Bg | Color3 | Main background |
| Bg2 | Color3 | Secondary background (topbar, sidebar) |
| Bg3 | Color3 | Tertiary background (input fields) |
| El | Color3 | Element background |
| ElHov | Color3 | Element hover background |
| Border | Color3 | Border/stroke color |
| Txt | Color3 | Primary text |
| Txt2 | Color3 | Secondary text |
| Txt3 | Color3 | Muted text |
| Acc | Color3 | Accent color (primary buttons) |
| AccD | Color3 | Accent dark variant |
| TOn | Color3 | Toggle on color |
| TOff | Color3 | Toggle off color |
| Slider | Color3 | Slider fill color |
| BgTr | number | Background transparency (0-1) |
| ElTr | number | Element transparency (0-1) |
| SbTr | number | Sidebar transparency (0-1) |

---

## Theme Editor

Open the built-in visual theme editor:

```lua
Wraith:OpenThemeEditor()
```

The theme editor allows you to:
- Pick colors for every theme property using the color picker
- Adjust transparency values
- Preview changes live without saving
- Save as a new named theme
- Saved themes appear in the theme dropdown

---

## Animation System

Change the UI animation style:

```lua
Wraith:SetAnimation("Bounce")
```

### Available Presets

| Preset | Easing Style | Duration | Feel |
|--------|-------------|----------|------|
| Default | Quart | 0.25s | Standard smooth |
| Bounce | Bounce | 0.5s | Bouncy pop |
| Elastic | Elastic | 0.6s | Springy overshoot |
| Smooth | Sine | 0.4s | Gentle ease |
| Snappy | Back | 0.3s | Quick with slight overshoot |
| Fade | Linear | 0.35s | Simple linear fade |

### Get Animation List

```lua
local animations = Wraith:GetAnimations()
-- Returns: {"Default", "Bounce", "Elastic", "Smooth", "Snappy", "Fade"}
```

---

## Tooltip System

Add hover tooltips to any element by including the `Tooltip` parameter:

```lua
MyTab:AddButton({
    Title = "My Button",
    Tooltip = "This tooltip appears when you hover",
    Callback = function() end
})

MyTab:AddToggle({
    Title = "Feature",
    Tooltip = "Enable or disable this feature",
    Default = false,
    Flag = "Feature",
    Callback = function() end
})

MyTab:AddSlider({
    Title = "Speed",
    Tooltip = "Drag to adjust speed value",
    Min = 0,
    Max = 100,
    Default = 50,
    Flag = "Speed",
    Callback = function() end
})
```

Tooltips follow the mouse cursor and disappear when the mouse leaves the element.

---

## Window Methods

```lua
Window:Show()              -- Show the window with animation
Window:Hide()              -- Hide the window (reopen with keybind)
Window:Minimize()          -- Minimize (floating button on mobile)
Window:Destroy()           -- Completely destroy the UI
Window:Resize(800, 500)    -- Resize to specific width, height
```

---

## Flags System

Every element with a `Flag` parameter is stored in `Wraith.Flags` and can be accessed from anywhere:

```lua
-- Get a flag value
local speed = Wraith.Flags["WalkSpeed"].Value

-- Set a flag value
Wraith.Flags["WalkSpeed"]:Set(100)

-- Check toggle state
if Wraith.Flags["AutoFarm"].Value then
    print("Auto farm is enabled")
end
```

---

## Addons

### SaveManager

Full configuration save/load system with autoload support.

#### Setup

```lua
local SaveManager = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/maybeflexa/Wraith-Lib/refs/heads/main/Wraith/Addons/SaveManager.lua"
))()

SaveManager:SetLibrary(Wraith)
SaveManager:IgnoreThemeSettings()
SaveManager:SetFolder("Wraith/MyScript")
```

#### Build Config UI

Automatically adds config management UI to a tab:

```lua
SaveManager:BuildConfigSection(SettingsTab)
```

This creates:
- Config list dropdown
- Config name input
- Create / Save / Load / Delete / Refresh buttons
- Autoload set/reset buttons

#### Load Autoload Config

Call at the end of your script:

```lua
SaveManager:LoadAutoloadConfig()
```

#### Manual Methods

```lua
SaveManager:Save("config_name")
SaveManager:Load("config_name")
SaveManager:Delete("config_name")

local configs = SaveManager:RefreshConfigList()

SaveManager:SetAutoloadConfig("config_name")
SaveManager:DeleteAutoLoadConfig()
local autoload = SaveManager:GetAutoloadConfig()
```

#### Ignore Specific Flags

```lua
SaveManager:SetIgnoreIndexes({"FlagName1", "FlagName2"})
```

---

### InterfaceManager

Theme and animation preference manager.

#### Setup

```lua
local InterfaceManager = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/maybeflexa/Wraith-Lib/refs/heads/main/Wraith/Addons/InterfaceManager.lua"
))()

InterfaceManager:SetLibrary(Wraith)
InterfaceManager:SetFolder("Wraith/MyScript")
```

#### Build Interface UI

Automatically adds theme/animation settings to a tab:

```lua
InterfaceManager:BuildInterfaceSection(SettingsTab)
```

This creates:
- Theme dropdown (auto-saved)
- Animation style dropdown (auto-saved)
- Theme Editor button
- Menu keybind selector

---

## Full Example

Complete script demonstrating all features with addons:

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
    Title = "My Hub",
    SubTitle = "v1.0.0",
    Size = UDim2.new(0, 630, 0, 370),
    MinimizeKey = Enum.KeyCode.LeftControl,
    TabWidth = 175,
    Resizable = true,
    Searchable = true
})

local MainTab = Window:AddTab({Title = "Main", Icon = "house"})
local CombatTab = Window:AddTab({Title = "Combat", Icon = "swords"})
local VisualsTab = Window:AddTab({Title = "Visuals", Icon = "eye"})
local SettingsTab = Window:AddTab({Title = "Settings", Icon = "settings"})

-- Main Tab
MainTab:AddParagraph({
    Title = "Welcome",
    Content = "Script loaded successfully.",
    Tooltip = "Welcome message"
})

MainTab:AddDivider({Text = "Features"})

MainTab:AddToggle({
    Title = "Auto Farm",
    Description = "Automatically farms resources",
    Default = false,
    Flag = "AutoFarm",
    Callback = function(value)
        print("Farm:", value)
    end
})

MainTab:AddCheckbox({
    Title = "Auto Collect",
    Default = true,
    Flag = "AutoCollect",
    Callback = function(value)
        print("Collect:", value)
    end
})

MainTab:AddSlider({
    Title = "Speed",
    Description = "Character speed",
    Min = 16,
    Max = 200,
    Default = 16,
    Suffix = " studs/s",
    Flag = "Speed",
    Callback = function(value)
        pcall(function()
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
        end)
    end
})

MainTab:AddInput({
    Title = "Target",
    Placeholder = "Player name...",
    Flag = "Target",
    Callback = function(value)
        print("Target:", value)
    end
})

MainTab:AddNumberSpinner({
    Title = "Amount",
    Min = 0,
    Max = 100,
    Default = 10,
    Step = 5,
    Flag = "Amount",
    Callback = function(value)
        print("Amount:", value)
    end
})

-- Combat Tab
CombatTab:AddParagraph({
    Title = "Combat",
    Content = "Configure combat settings."
})

CombatTab:AddDivider({Text = "Attack"})

CombatTab:AddToggle({
    Title = "Kill Aura",
    Default = false,
    Flag = "KillAura",
    Callback = function() end
})

CombatTab:AddSlider({
    Title = "Range",
    Min = 5,
    Max = 50,
    Default = 15,
    Suffix = " studs",
    Flag = "Range",
    Callback = function() end
})

CombatTab:AddDropdown({
    Title = "Mode",
    Values = {"Nearest", "Lowest HP", "Highest Level", "Random"},
    Default = "Nearest",
    Flag = "AttackMode",
    Callback = function(value)
        print("Mode:", value)
    end
})

CombatTab:AddDivider({Text = "Targeting"})

CombatTab:AddMultiDropdown({
    Title = "Targets",
    Values = {"Players", "NPCs", "Bosses", "Animals"},
    Default = {"NPCs"},
    Flag = "Targets",
    Callback = function() end
})

CombatTab:AddKeybind({
    Title = "Combat Key",
    Default = Enum.KeyCode.X,
    Flag = "CombatKey",
    Callback = function()
        print("Combat toggled!")
    end
})

-- Visuals Tab
VisualsTab:AddParagraph({
    Title = "Visuals",
    Content = "Customize visual features."
})

VisualsTab:AddDivider({Text = "ESP"})

VisualsTab:AddToggle({
    Title = "ESP Enabled",
    Default = false,
    Flag = "ESP",
    Callback = function() end
})

VisualsTab:AddCheckbox({
    Title = "Show Names",
    Default = true,
    Flag = "ShowNames",
    Callback = function() end
})

VisualsTab:AddCheckbox({
    Title = "Show Health",
    Default = true,
    Flag = "ShowHealth",
    Callback = function() end
})

VisualsTab:AddDivider({Text = "Colors"})

VisualsTab:AddColorpicker({
    Title = "ESP Color",
    Default = Color3.fromRGB(255, 255, 255),
    Flag = "ESPColor",
    Callback = function(color)
        print("ESP Color:", color)
    end
})

VisualsTab:AddColorpicker({
    Title = "Chams Color",
    Default = Color3.fromRGB(150, 150, 150),
    Flag = "ChamsColor",
    Callback = function() end
})

VisualsTab:AddDivider({Text = "Style"})

VisualsTab:AddDropdown({
    Title = "ESP Style",
    Values = {"Box", "Corner", "3D", "Skeleton"},
    Default = "Box",
    Flag = "ESPStyle",
    Callback = function() end
})

VisualsTab:AddDivider({Text = "Info"})

VisualsTab:AddDateTime({
    Title = "Time",
    Format = "%H:%M:%S"
})

VisualsTab:AddStatusBar({
    Title = "FPS",
    UpdateInterval = 0.5,
    Getter = function()
        return math.floor(1 / game:GetService("RunService").Heartbeat:Wait())
    end
})

-- Settings Tab (Automatic)
SaveManager:SetLibrary(Wraith)
InterfaceManager:SetLibrary(Wraith)
SaveManager:IgnoreThemeSettings()
SaveManager:SetFolder("Wraith/MyScript")
InterfaceManager:SetFolder("Wraith/MyScript")

InterfaceManager:BuildInterfaceSection(SettingsTab)
SaveManager:BuildConfigSection(SettingsTab)

-- Welcome notification
Wraith:Notify({
    Title = "Loaded",
    Content = "Script initialized successfully!",
    SubContent = "All features ready.",
    Duration = 5
})

-- Load autoload config if set
SaveManager:LoadAutoloadConfig()
```

---

## File Structure

```
Wraith-Lib/
├── README.md
├── Documentation.md
└── Wraith/
    ├── Src/
    │   └── Wraith.luau
    ├── Addons/
    │   ├── SaveManager.lua
    │   └── InterfaceManager.lua
    └── Icons/
        └── Lucide.lua
```

---

## Credits

- **Wraith** by [maybeflexa](https://github.com/maybeflexa)
- Inspired by [Fluent](https://github.com/dawid-scripts/Fluent) by dawid-scripts
- Icons by [Lucide](https://lucide.dev)

---
```

## Support

Issues or suggestions? Open an issue on [GitHub](https://github.com/maybeflexa/Wraith-Lib/issues).
