<div align="center">

<img width="885" height="260" alt="Wraith" src="https://github.com/user-attachments/assets/63352011-135e-4500-8932-7f963ab8b678" />

# Wraith Library UI

A clean Roblox UI library with themes, animations, configs, icons and modern elements.

![Lua](https://img.shields.io/badge/Lua-2C2D72?style=for-the-badge&logo=lua&logoColor=white)
![Roblox](https://img.shields.io/badge/Roblox-000000?style=for-the-badge&logo=roblox&logoColor=white)

</div>

## Links

Documentation:

https://github.com/maybeflexa/Wraith-Lib/blob/main/Documentation.md

Example:

https://github.com/maybeflexa/Wraith-Lib/blob/main/Example.luau

## Features

- Dark monochrome design
- 6 built-in themes
- Custom theme support
- Theme editor
- Current theme getter
- Transparency getter
- Smooth animations
- Lucide icons
- Searchable sidebar
- Resizable window
- Optional window background image
- Collapsible tab groups
- Advanced dropdown
- Fluent-style input `Finished` mode
- MultiInput `Finished` mode
- Dropdown search
- ProgressBar element
- SaveManager addon
- InterfaceManager addon
- ConfigManager bridge
- Tooltip system
- Mobile support
- Dual API syntax

## Themes

`AMOLED` `Dark` `Midnight` `Obsidian` `Graphite` `Pearl`

## Animations

`Default` `Smooth` `Fade`

## Elements

| Element | Description |
| --- | --- |
| Paragraph | Text block with title and content |
| Button | Clickable button |
| Toggle | Boolean switch |
| Checkbox | Checkbox input |
| Slider | Numeric slider |
| ProgressBar | Progress display |
| Dropdown | Single select dropdown |
| MultiDropdown | Multi select dropdown |
| Colorpicker | HSV color picker |
| Keybind | Key selector |
| Input | Text input |
| MultiInput | Multiple inputs in one element |
| MultiSlider | Multiple sliders in one element |
| NumberSpinner | Stepper number input |
| DateTime | Live date or time label |
| StatusBar | Auto-updating status label |
| Separator | Horizontal line |
| Divider | Labeled divider |
| Label | Simple text label |
| Section | Element section |

## Quick Start

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

local MainGroup = Window:AddTabGroup({
    Title = "Main",
    Opened = true
})

local UtilityGroup = Window:AddTabGroup({
    Title = "Utilities",
    Opened = true
})

local Tabs = {
    Main = MainGroup:AddTab({Title = "Main", Icon = "house"}),
    Elements = MainGroup:AddTab({Title = "Elements", Icon = "sliders-horizontal"}),
    Settings = UtilityGroup:AddTab({Title = "Settings", Icon = "settings"})
}

Tabs.Main:AddParagraph({
    Title = "Theme Info",
    Content = "Current theme: " .. Wraith:GetCurrentTheme()
})

Tabs.Main:AddButton({
    Title = "Button",
    Description = "Button description",
    Callback = function()
        Wraith:Notify({
            Title = "Wraith",
            Content = "Button clicked",
            Duration = 3
        })
    end
})

Tabs.Main:AddProgressBar("Progress", {
    Title = "Progress",
    Min = 0,
    Max = 100,
    Default = 50
})

SaveManager:SetLibrary(Wraith)
InterfaceManager:SetLibrary(Wraith)

SaveManager:IgnoreThemeSettings()

InterfaceManager:SetFolder("WraithExample")
SaveManager:SetFolder("WraithExample/specific-game")

InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

SaveManager:LoadAutoloadConfig()
```

## Advanced Dropdown

```lua
Tabs.Main:AddDropdown("Actions", {
    Title = "Actions",
    Searchable = true,
    Values = {
        {
            Title = "New File",
            Description = "Create a new file",
            Icon = "file-plus",
            Value = "new"
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
    Default = "new",
    Callback = function(value, option)
        print(value, option and option.Title)
    end
})
```

## ProgressBar Getter

```lua
local Progress = Tabs.Main:AddProgressBar("Progress", {
    Title = "Progress",
    Min = 0,
    Max = 100,
    Default = 0,
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
```

## Background Image

```lua
Window:SetBackgroundImage("6031302932", 0.82)
Window:SetBackgroundImage("rbxassetid://6031302932", 0.82)
Window:SetBackgroundImageTransparency(0.9)
Window:SetBackgroundImageScaleType(Enum.ScaleType.Crop)
Window:SetBackgroundImage(nil)
```

## Theme State

```lua
local currentTheme = Wraith:GetCurrentTheme()
local transparency = Wraith:GetTransparency()
```

## ConfigManager Bridge

```lua
local Config = Window.ConfigManager:CreateConfig("default")

Config:Save()
Config:Load()
Config:SetAutoLoad(true)
Config:Delete()
```

## Addons

### SaveManager

```lua
SaveManager:SetLibrary(Wraith)
SaveManager:SetFolder("WraithExample/specific-game")
SaveManager:IgnoreThemeSettings()
SaveManager:BuildConfigSection(Tabs.Settings)
SaveManager:LoadAutoloadConfig()
```

### InterfaceManager

```lua
InterfaceManager:SetLibrary(Wraith)
InterfaceManager:SetFolder("WraithExample")
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
```
