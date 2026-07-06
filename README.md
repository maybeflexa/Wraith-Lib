<div align="center">
    
<img width="885" height="260" alt="227218" src="https://github.com/user-attachments/assets/63352011-135e-4500-8932-7f963ab8b678" />

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
- 7 built-in themes
- Custom theme support
- Theme editor
- Current theme getter
- Transparency getter
- Smooth animations
- Lucide icons
- Searchable sidebar
- Resizable window
- UI scale support
- Advanced dropdown
- ProgressBar element
- SaveManager addon
- InterfaceManager addon
- ConfigManager bridge
- Tooltip system
- Mobile support
- Dual API syntax

## Themes

`AMOLED` `Dark` `Darker` `Midnight` `Charcoal` `Light` `Obsidian`

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
    Size = UDim2.new(0, 630, 0, 370),
    MinimizeKey = Enum.KeyCode.LeftControl,
    TabWidth = 175,
    Resizable = true,
    Searchable = true,
    MinSize = Vector2.new(450, 280),
    UIScale = 1
})

local Tabs = {
    Main = Window:AddTab({Title = "Main", Icon = "house"}),
    Settings = Window:AddTab({Title = "Settings", Icon = "settings"})
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

## UI Scale

```lua
Window:SetUIScale(0.9)
local scale = Window:GetUIScale()
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
