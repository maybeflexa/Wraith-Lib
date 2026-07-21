# Wraith Library UI Documentation

## Installation

Load the library first, then load the addons if you want the ready-made settings and config panels.

```lua
local Wraith = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/maybeflexa/Wraith-Lib/main/Wraith/Src/Wraith.luau"
))()

local SaveManager = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/maybeflexa/Wraith-Lib/main/Wraith/Addons/SaveManager.lua"
))()

local InterfaceManager = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/maybeflexa/Wraith-Lib/main/Wraith/Addons/InterfaceManager.lua"
))()
```

## Window

Creates the main UI window.

```lua
local Window = Wraith:CreateWindow({
    Title = "Wraith v1.0.0",
    SubTitle = "by maybeflexa",
    Size = UDim2.new(0, 650, 0, 390),
    MinimizeKey = Enum.KeyCode.LeftControl,
    TabWidth = 185,
    Resizable = true,
    Searchable = true,
    MinSize = Vector2.new(470, 300),
    BackgroundImage = "",
    BackgroundImageTransparency = 0.75
})
```

| Option | Type | Description |
| --- | --- | --- |
| `Title` | string | Window title |
| `SubTitle` | string | Window subtitle |
| `Size` | UDim2 | Window size |
| `MinimizeKey` | Enum.KeyCode | Toggle visibility key |
| `TabWidth` | number | Sidebar width |
| `Resizable` | boolean | Enables resize handle |
| `Searchable` | boolean | Enables sidebar search and category filter |
| `MinSize` | Vector2 | Minimum resize size |
| `BackgroundImage` | string | Optional image behind the window content |
| `BackgroundImageTransparency` | number | Background image transparency |
| `BackgroundImageScaleType` | Enum.ScaleType | Background image scale type |

## Background Image

Adds an optional image behind the window.

```lua
Window:SetBackgroundImage("6031302932", 0.82)
Window:SetBackgroundImage("rbxassetid://6031302932", 0.82)
Window:SetBackgroundImageTransparency(0.9)
Window:SetBackgroundImageScaleType(Enum.ScaleType.Crop)
Window:SetBackgroundImage(nil)
```

## Tab Groups

Groups tabs in the sidebar and lets the user collapse them.

```lua
local MainGroup = Window:AddTabGroup({
    Title = "Main",
    Opened = true
})

local UtilityGroup = Window:AddTabGroup({
    Title = "Utilities",
    Opened = false
})

local Tabs = {
    Main = MainGroup:AddTab({Title = "Main", Icon = "house"}),
    Elements = MainGroup:AddTab({Title = "Elements", Icon = "sliders-horizontal"}),
    Settings = UtilityGroup:AddTab({Title = "Settings", Icon = "settings"})
}
```

## Tabs

Tabs split the window into pages.

```lua
local Tabs = {
    Main = Window:AddTab({Title = "Main", Icon = "house"}),
    Settings = Window:AddTab({Title = "Settings", Icon = "settings"})
}
```

## Window Methods

Use these after creating the window.

```lua
Window:SelectTab(Tabs.Main)
Window:Show()
Window:Hide()
Window:Minimize()
Window:Destroy()
Window:Resize(650, 390)
```

## Notifications

Small messages that appear without stopping the script.

```lua
Wraith:Notify({
    Title = "Wraith",
    Content = "Notification content",
    SubContent = "Extra content",
    Duration = 5
})
```

## Dialogs

A prompt with custom buttons.

```lua
Wraith:Dialog({
    Title = "Dialog",
    Content = "Dialog content",
    Buttons = {
        {Title = "Cancel", Callback = function() end},
        {Title = "Confirm", Callback = function() end}
    }
})
```

## API Syntax

Elements support flag-first syntax and table syntax.

```lua
Tabs.Main:AddToggle("FlagName", {
    Title = "Toggle"
})
```

```lua
Tabs.Main:AddToggle({
    Flag = "FlagName",
    Title = "Toggle"
})
```

## Paragraph

A simple text block.

```lua
local Paragraph = Tabs.Main:AddParagraph({
    Title = "Paragraph",
    Content = "Content text"
})

Paragraph:Set({Title = "New title", Content = "New content"})
Paragraph:SetTitle("New title")
Paragraph:SetDesc("New content")
```

## Button

Runs a callback when clicked.

```lua
Tabs.Main:AddButton({
    Title = "Button",
    Description = "Button description",
    Callback = function()
        print("clicked")
    end
})
```

## Toggle

A true or false switch.

```lua
local Toggle = Tabs.Main:AddToggle("AutoFarm", {
    Title = "Auto Farm",
    Default = false,
    Callback = function(value)
        print(value)
    end
})

Toggle:Set(true)
```

## Checkbox

A true or false checkbox.

```lua
local Checkbox = Tabs.Main:AddCheckbox("LogActions", {
    Title = "Log Actions",
    Default = true,
    Callback = function(value)
        print(value)
    end
})

Checkbox:Set(false)
```

## Slider

Pick a number from a range. The value box can be edited directly.

```lua
local Slider = Tabs.Main:AddSlider("WalkSpeed", {
    Title = "WalkSpeed",
    Min = 16,
    Max = 100,
    Default = 16,
    Rounding = 1,
    Suffix = "%",
    Callback = function(value)
        print(value)
    end
})

Slider:Set(50)
```

## ProgressBar

Shows progress as a read-only bar. It can be set manually or updated by a getter.

```lua
local Progress = Tabs.Main:AddProgressBar("Progress", {
    Title = "Progress",
    Min = 0,
    Max = 100,
    Default = 25,
    Getter = function()
        return math.random(0, 100)
    end,
    UpdateInterval = 1
})

Progress:Set(80)
Progress:Refresh()
Progress:Stop()
Progress:Start(function()
    return 50
end, 0.5)
Progress:SetRange(0, 200)
Progress:SetMin(0)
Progress:SetMax(100)
```

## Dropdown

Pick one value from a list.

```lua
local Dropdown = Tabs.Main:AddDropdown("Mode", {
    Title = "Mode",
    Values = {"Easy", "Normal", "Hard"},
    Default = "Normal",
    Callback = function(value)
        print(value)
    end
})

Dropdown:Set("Hard")
Dropdown:SetValues({"A", "B", "C"})
Dropdown:Refresh({"One", "Two", "Three"})
Dropdown:Select("Two")
```

## Advanced Dropdown

Dropdown rows can include search, icons, descriptions, dividers, locked states and per-item callbacks.

```lua
local Dropdown = Tabs.Main:AddDropdown("FileAction", {
    Title = "File Action",
    Searchable = true,
    Values = {
        {
            Title = "New File",
            Description = "Create a new file",
            Icon = "file-plus",
            Value = "new",
            Callback = function(option, value)
                print(value)
            end
        },
        {
            Title = "Copy Link",
            Description = "Copy the file link",
            Icon = "copy",
            Value = "copy"
        },
        {
            Type = "Divider"
        },
        {
            Title = "Delete File",
            Description = "Locked item",
            Icon = "trash",
            Value = "delete",
            Locked = true
        }
    },
    Default = "copy",
    Callback = function(value, option)
        print(value, option and option.Title)
    end
})
```

## MultiDropdown

Pick multiple values from one list. Search is supported here too.

```lua
local MultiDropdown = Tabs.Main:AddMultiDropdown("Targets", {
    Title = "Targets",
    Searchable = true,
    Values = {"Player", "NPC", "Boss"},
    Default = {"Player"},
    Callback = function(values)
        print(values)
    end
})

MultiDropdown:Set({"Player", "Boss"})
```

## Colorpicker

Pick a `Color3` value. The picker window stays fixed in place.

```lua
local Colorpicker = Tabs.Main:AddColorpicker("ESPColor", {
    Title = "ESP Color",
    Default = Color3.fromRGB(255, 255, 255),
    Callback = function(color)
        print(color)
    end
})

Colorpicker:Set(Color3.fromRGB(255, 0, 0))
```

## Keybind

Pick a key and listen for it.

```lua
local Keybind = Tabs.Main:AddKeybind("MenuKey", {
    Title = "Menu Key",
    Default = Enum.KeyCode.RightShift,
    Callback = function(key)
        print(key)
    end,
    ChangedCallback = function(key)
        print(key)
    end
})

Keybind:Set(Enum.KeyCode.LeftAlt)
```

## Input

Single-line text input.

```lua
local Input = Tabs.Main:AddInput("Username", {
    Title = "Username",
    Placeholder = "Enter username",
    Default = "",
    Numeric = false,
    Finished = false,
    Callback = function(value)
        print(value)
    end
})

Input:Set("maybeflexa")
```

With `Finished = true`, the callback only runs after Enter is pressed.

```lua
Tabs.Main:AddInput("FinishedInput", {
    Title = "Finished Input",
    Default = "Default",
    Placeholder = "Press Enter to submit",
    Numeric = false,
    Finished = true,
    Callback = function(value)
        print(value)
    end
})
```

## MultiInput

Multiple text boxes in one element.

```lua
local MultiInput = Tabs.Main:AddMultiInput("Coords", {
    Title = "Coordinates",
    Finished = true,
    Numeric = true,
    Fields = {
        {Name = "X", Placeholder = "0"},
        {Name = "Y", Placeholder = "0"},
        {Name = "Z", Placeholder = "0"}
    },
    Callback = function(values)
        print(values)
    end
})

MultiInput:Set({X = "10", Y = "20", Z = "30"})
```

## MultiSlider

Multiple sliders in one element. The value boxes can be edited directly.

```lua
local MultiSlider = Tabs.Main:AddMultiSlider("Stats", {
    Title = "Stats",
    Fields = {
        {Name = "Speed", Min = 0, Max = 100, Default = 50, Suffix = "%"},
        {Name = "Power", Min = 0, Max = 100, Default = 25, Suffix = "%"}
    },
    Callback = function(values)
        print(values)
    end
})

MultiSlider:Set({Speed = 75, Power = 60})
```

## NumberSpinner

Number input with plus and minus buttons.

```lua
local Spinner = Tabs.Main:AddNumberSpinner("Amount", {
    Title = "Amount",
    Min = 0,
    Max = 10,
    Default = 3,
    Step = 1,
    Callback = function(value)
        print(value)
    end
})
```

## DateTime

Displays live date or time text.

```lua
Tabs.Main:AddDateTime({
    Title = "Clock",
    Format = "%H:%M:%S"
})
```

## StatusBar

Displays a value that can update on a timer.

```lua
local Status = Tabs.Main:AddStatusBar({
    Title = "Status",
    Getter = function()
        return "Online"
    end,
    UpdateInterval = 1
})

Status:Set("Offline")
```

## Separator

A simple horizontal line.

```lua
Tabs.Main:AddSeparator()
```

## Divider

A labeled line for splitting content.

```lua
Tabs.Main:AddDivider({
    Text = "Section"
})
```

## Label

Small text-only element.

```lua
local Label = Tabs.Main:AddLabel({
    Text = "Label text"
})

Label:Set("New label")
```

## Section

A titled container with its own elements.

```lua
local Section = Tabs.Main:AddSection("Combat")

Section:AddToggle("KillAura", {
    Title = "Kill Aura"
})
```

## Themes

Wraith includes AMOLED, Dark, Midnight, Obsidian, Graphite and Pearl.

```lua
Wraith:SetTheme("Dark")
local themes = Wraith:GetThemes()
```

## Theme State

Read the active theme and current transparency values.

```lua
local currentTheme = Wraith:GetCurrentTheme()
local transparency = Wraith:GetTransparency()

print(currentTheme)
print(transparency.Background)
print(transparency.Element)
print(transparency.Sidebar)
```

## Theme Editor

Opens the built-in theme editor.

```lua
Wraith:OpenThemeEditor()
```

## Animation System

Changes the animation preset used by transitions.

```lua
Wraith:SetAnimation("Smooth")
local animations = Wraith:GetAnimations()
```

Built-in presets:

| Name |
| --- |
| `Default` |
| `Smooth` |
| `Fade` |

## SaveManager Addon

Adds a ready-made config section.

```lua
SaveManager:SetLibrary(Wraith)
SaveManager:SetFolder("WraithExample/specific-game")
SaveManager:IgnoreThemeSettings()
SaveManager:BuildConfigSection(Tabs.Configs)
SaveManager:LoadAutoloadConfig()
```

## InterfaceManager Addon

Adds a ready-made interface section for theme, animation and menu keybind.

```lua
InterfaceManager:SetLibrary(Wraith)
InterfaceManager:SetFolder("WraithExample")
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
```

## ConfigManager Bridge

A direct config wrapper on the window. It works alongside the addon.

```lua
local Config = Window.ConfigManager:CreateConfig("default")

Config:Save()
Config:Load()
Config:SetAutoLoad(true)
Config:Delete()
```

```lua
local configs = Window.ConfigManager:AllConfigs()
local config = Window.ConfigManager:GetConfig("default")
local autoload = Window.ConfigManager:GetAutoLoadConfig()
Window.ConfigManager:LoadAutoLoadConfig()
```

## Core SaveManager

Direct access to the internal save manager.

```lua
Wraith.SaveManager:Save("default")
Wraith.SaveManager:Load("default")
Wraith.SaveManager:Delete("default")
local configs = Wraith.SaveManager:GetConfigs()
```

## Flags

Elements with flags are stored here.

```lua
local toggle = Wraith.Flags.AutoFarm

toggle:Set(true)
```

## Tooltip

Shows a small hint while hovering an element.

```lua
Tabs.Main:AddButton({
    Title = "Button",
    Tooltip = "Tooltip text",
    Callback = function() end
})
```

## Full Example

Use `Example.luau` for the complete updated example.
