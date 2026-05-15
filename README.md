<div align="center">

<img width="1536" height="1024" alt="227216" src="https://github.com/user-attachments/assets/bab7ba9c-ec36-4181-bdb3-7173b27ee0c5" />


# Wraith Library Ui

**A Simple User Friendly Liblary Ui.**

Built with clean design, smooth animations, Lucide icons, and full feature support.

![Lua](https://img.shields.io/badge/Lua-2C2D72?style=for-the-badge&logo=lua&logoColor=white)
![Roblox](https://img.shields.io/badge/Roblox-000000?style=for-the-badge&logo=roblox&logoColor=white)

</div>

---

## Features

- Dark monochrome design with transparency
- 7 built-in themes + custom theme support + theme editor
- Lucide icon integration
- Smooth animations with 6 presets
- Full config save/load/autoload system
- Search bar for elements
- Resizable window
- Mobile support with floating button
- Tooltip system
- Auto-save theme preference
- gethui fallback for anti-cheat bypass

## Themes

`AMOLED` `Dark` `Darker` `Midnight` `Charcoal` `Light` `Obsidian` + Custom themes

## Elements

| Element | Description |
|---------|-------------|
| Paragraph | Title + content text block |
| Button | Clickable button with optional description |
| Toggle | On/off switch |
| Checkbox | Checkmark box |
| Slider | Draggable value slider with manual input |
| Dropdown | Single select dropdown |
| MultiDropdown | Multiple select dropdown |
| Colorpicker | HSV color picker dialog |
| Keybind | Key binding selector |
| Input | Text input field |
| NumberSpinner | +/- number selector |
| DateTime | Live clock/date display |
| StatusBar | Auto-updating value display |
| Separator | Horizontal line |
| Divider | Labeled section divider |
| Label | Simple text label |
| Section | Element group with title |

## Quick Start

```lua
local Wraith = loadstring(game:HttpGet("https://raw.githubusercontent.com/maybeflexa/Wraith-Lib/refs/heads/main/Wraith/Src/Wraith.luau"))()

local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/maybeflexa/Wraith-Lib/refs/heads/main/Wraith/Addons/SaveManager.lua"))()

local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/maybeflexa/Wraith-Lib/refs/heads/main/Wraith/Addons/InterfaceManager.lua"))()

local Window = Wraith:CreateWindow({
    Title = "Test-Hub",
    SubTitle = "v1.0.0",
    Size = UDim2.new(0, 630, 0, 370),
    MinimizeKey = Enum.KeyCode.LeftControl,
    TabWidth = 175,
    Resizable = true,
    Searchable = true
})

local MainTab = Window:AddTab({Title = "Main", Icon = "house"})
local SettingsTab = Window:AddTab({Title = "Settings", Icon = "settings"})

MainTab:AddToggle({
    Title = "Feature",
    Default = false,
    Flag = "MyFeature",
    Callback = function(value)
        print("Feature:", value)
    end
})

SaveManager:SetLibrary(Wraith)
InterfaceManager:SetLibrary(Wraith)
SaveManager:IgnoreThemeSettings()
SaveManager:SetFolder("Wraith/MyScript")
InterfaceManager:SetFolder("Wraith/MyScript")

InterfaceManager:BuildInterfaceSection(SettingsTab)
SaveManager:BuildConfigSection(SettingsTab)
SaveManager:LoadAutoloadConfig()
```
