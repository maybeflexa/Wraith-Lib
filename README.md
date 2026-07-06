<div align="center">
    
<img width="885" height="260" alt="227218" src="https://github.com/user-attachments/assets/63352011-135e-4500-8932-7f963ab8b678" />


# Wraith Library Ui

**A Simple User Friendly Library Ui.**

Built with clean design, smooth animations, Lucide icons, and full feature support.

![Lua](https://img.shields.io/badge/Lua-2C2D72?style=for-the-badge&logo=lua&logoColor=white)
![Roblox](https://img.shields.io/badge/Roblox-000000?style=for-the-badge&logo=roblox&logoColor=white)

</div>

Check Out The Documentation For Full Experience!!

https://github.com/maybeflexa/Wraith-Lib/blob/main/Documentation.md

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
- Dual API syntax (Fluent-style and table-style)

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
| MultiInput | Multiple text inputs in one row |
| MultiSlider | Multiple sliders in one element |
| NumberSpinner | +/- number selector |
| DateTime | Live clock/date display |
| StatusBar | Auto-updating value display |
| Separator | Horizontal line |
| Divider | Labeled section divider |
| Label | Simple text label |
| Section | Element group with title |

## Quick Start

```lua
local Wraith = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/maybeflexa/Wraith-Lib/main/Wraith/Src/Wraith.luau"
))()

Wraith:Localization({
    en = {
        Welcome = "Welcome to Wraith"
    },
    tr = {
        Welcome = "Wraith'e hoş geldin"
    }
})

Wraith:SetLanguage("en")
Wraith:SetFont(Enum.Font.Gotham)

Wraith:AddIconPack("custom", {
    star = "rbxassetid://6031068426"
})

Wraith:OnThemeChange(function(name)
    print("Theme changed:", name)
end)

local Window = Wraith:CreateWindow({
    Title = "Wraith v1.1.0",
    SubTitle = "by maybeflexa",
    Size = UDim2.new(0, 650, 0, 390),
    MinimizeKey = Enum.KeyCode.LeftControl,
    TabWidth = 175,
    Resizable = true,
    Searchable = true,
    MinSize = Vector2.new(470, 300),
    UIScale = 1,
    OpenButton = {
        Enabled = true,
        Title = "W",
        Draggable = true,
        OnlyMobile = false
    }
})

Window:Tag({
    Title = "Example"
})

Window:Tag({
    Title = Wraith:GetCurrentTheme()
})

Window:CreateTopbarButton("Theme", "settings", function()
    local themes = Wraith:GetThemes()
    local current = Wraith:GetCurrentTheme()
    local nextTheme = themes[1]

    for index, theme in ipairs(themes) do
        if theme == current then
            nextTheme = themes[index + 1] or themes[1]
            break
        end
    end

    Wraith:SetTheme(nextTheme)
end)

Window:CreateTopbarButton("Scale", nil, function()
    local scale = Window:GetUIScale()
    Window:SetUIScale(scale >= 1 and 0.9 or 1)
end)

local Tabs = {
    Main = Window:AddTab({Title = "Main", Icon = "house"}),
    Elements = Window:AddTab({Title = "Elements", Icon = "boxes"}),
    Layout = Window:AddTab({Title = "Layout", Icon = "panel-top"}),
    Settings = Window:AddTab({Title = "Settings", Icon = "settings"})
}

Wraith:Notify({
    Title = "Wraith",
    Content = Wraith:Translate("Welcome"),
    SubContent = "Updated example loaded",
    Duration = 5
})

Tabs.Main:AddParagraph({
    Title = "Paragraph",
    Content = "This is a paragraph.\nSecond line."
})

local HighlightButton = Tabs.Main:AddButton({
    Title = "Highlight Button",
    Description = "Runs Button:Highlight",
    Callback = function()
        HighlightButton:Highlight()
    end
})

Tabs.Main:AddButton({
    Title = "Dialog Button",
    Description = "Shows a dialog",
    Callback = function()
        Wraith:Dialog({
            Title = "Dialog",
            Content = "This is a dialog.",
            Buttons = {
                {
                    Title = "Cancel",
                    Callback = function() end
                },
                {
                    Title = "Confirm",
                    Callback = function()
                        Wraith:Notify({
                            Title = "Dialog",
                            Content = "Confirmed",
                            Duration = 3
                        })
                    end
                }
            }
        })
    end
})

local Toggle = Tabs.Elements:AddToggle("ExampleToggle", {
    Title = "Toggle",
    Description = "Toggle example",
    Default = false,
    Callback = function(value)
        print("Toggle:", value)
    end
})

local Checkbox = Tabs.Elements:AddCheckbox("ExampleCheckbox", {
    Title = "Checkbox",
    Description = "Checkbox example",
    Default = true,
    Callback = function(value)
        print("Checkbox:", value)
    end
})

local Slider = Tabs.Elements:AddSlider("ExampleSlider", {
    Title = "Slider",
    Description = "Slider example",
    Min = 0,
    Max = 100,
    Default = 50,
    Rounding = 1,
    Suffix = "%",
    Callback = function(value)
        print("Slider:", value)
    end
})

local Progress = Tabs.Elements:AddProgressBar({
    Title = "ProgressBar",
    Description = "Progress example",
    Min = 0,
    Max = 100,
    Default = 35
})

Tabs.Elements:AddButton({
    Title = "Set Progress",
    Description = "Sets progress to 80",
    Callback = function()
        Progress:Set(80)
    end
})

local Dropdown = Tabs.Elements:AddDropdown("AdvancedDropdown", {
    Title = "Advanced Dropdown",
    Description = "Supports icons, descriptions, dividers and locked items",
    Values = {
        {
            Title = "New File",
            Description = "Create a new file",
            Icon = "file-plus",
            Value = "new",
            Callback = function()
                print("New file clicked")
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
        print("Dropdown:", value, option and option.Title)
    end
})

Tabs.Elements:AddButton({
    Title = "Refresh Dropdown",
    Description = "Replaces dropdown values",
    Callback = function()
        Dropdown:Refresh({"Alpha", "Beta", "Gamma"})
        Dropdown:Select("Beta")
    end
})

Tabs.Elements:AddMultiDropdown("MultiDropdown", {
    Title = "Multi Dropdown",
    Description = "Select multiple values",
    Values = {"One", "Two", "Three"},
    Default = {"One"},
    Callback = function(value)
        print("MultiDropdown:", value)
    end
})

Tabs.Elements:AddColorpicker("Colorpicker", {
    Title = "Colorpicker",
    Default = Color3.fromRGB(255, 255, 255),
    Callback = function(value)
        print("Colorpicker:", value)
    end
})

Tabs.Elements:AddKeybind("Keybind", {
    Title = "Keybind",
    Default = Enum.KeyCode.RightShift,
    Callback = function(key)
        print("Keybind pressed:", key)
    end,
    ChangedCallback = function(key)
        print("Keybind changed:", key)
    end
})

Tabs.Elements:AddInput("Input", {
    Title = "Input",
    Placeholder = "Type something...",
    Default = "Hello",
    Callback = function(value)
        print("Input:", value)
    end
})

Tabs.Elements:AddInput("Textarea", {
    Title = "Textarea",
    Type = "Textarea",
    Placeholder = "Type multiple lines...",
    Default = "Line one\nLine two",
    Callback = function(value)
        print("Textarea:", value)
    end
})

Tabs.Elements:AddNumberSpinner("Spinner", {
    Title = "Number Spinner",
    Min = 0,
    Max = 10,
    Default = 3,
    Step = 1,
    Callback = function(value)
        print("Spinner:", value)
    end
})

Tabs.Elements:AddDateTime({
    Title = "Date Time",
    Format = "%H:%M:%S"
})

Tabs.Elements:AddStatusBar({
    Title = "Status Bar",
    Getter = function()
        return "Online"
    end,
    UpdateInterval = 1
})

local Group = Tabs.Layout:AddGroup({
    Padding = 6
})

Group:AddParagraph({
    Title = "Group",
    Content = "Elements inside AddGroup."
})

Group:AddButton({
    Title = "Grouped Button",
    Callback = function()
        print("Grouped button")
    end
})

Tabs.Layout:AddSpace({
    Height = 8
})

local Row = Tabs.Layout:AddHStack({
    Padding = 6
})

local LeftColumn = Row:AddColumn(UDim2.new(0.5, -3, 0, 0))
local RightColumn = Row:AddColumn(UDim2.new(0.5, -3, 0, 0))

LeftColumn:AddButton({
    Title = "Left Column",
    Callback = function()
        print("Left")
    end
})

RightColumn:AddButton({
    Title = "Right Column",
    Callback = function()
        print("Right")
    end
})

local VStack = Tabs.Layout:AddVStack({
    Padding = 6
})

VStack:AddParagraph({
    Title = "VStack",
    Content = "Vertical stack alias for group."
})

Tabs.Layout:AddSeparator()

Tabs.Layout:AddDivider({
    Text = "Labels"
})

local Label = Tabs.Layout:AddLabel({
    Text = "This is a label."
})

Tabs.Layout:AddButton({
    Title = "Update Label",
    Callback = function()
        Label:Set("Label updated")
    end
})

local ConfigName = "default"

Tabs.Settings:AddInput("ConfigName", {
    Title = "Config Name",
    Default = ConfigName,
    Callback = function(value)
        ConfigName = value
    end
})

Tabs.Settings:AddButton({
    Title = "Save Config",
    Callback = function()
        Window.CurrentConfig = Window.ConfigManager:CreateConfig(ConfigName)
        Window.CurrentConfig:Save()
        Wraith:Notify({
            Title = "Config",
            Content = "Saved " .. ConfigName,
            Duration = 3
        })
    end
})

Tabs.Settings:AddButton({
    Title = "Load Config",
    Callback = function()
        Window.CurrentConfig = Window.ConfigManager:CreateConfig(ConfigName)
        Window.CurrentConfig:Load()
        Wraith:Notify({
            Title = "Config",
            Content = "Loaded " .. ConfigName,
            Duration = 3
        })
    end
})

Tabs.Settings:AddButton({
    Title = "Set Autoload",
    Callback = function()
        Window.CurrentConfig = Window.ConfigManager:CreateConfig(ConfigName)
        Window.CurrentConfig:SetAutoLoad(true)
    end
})

Tabs.Settings:AddDropdown("ThemeDropdown", {
    Title = "Theme",
    Values = Wraith:GetThemes(),
    Default = Wraith:GetCurrentTheme(),
    Callback = function(value)
        Wraith:SetTheme(value)
    end
})

Tabs.Settings:AddDropdown("ScaleDropdown", {
    Title = "UI Scale",
    Values = {"0.8", "0.9", "1", "1.1", "1.2"},
    Default = "1",
    Callback = function(value)
        Window:SetUIScale(tonumber(value))
    end
})

Tabs.Settings:AddButton({
    Title = "Destroy Example",
    Callback = function()
        Window:Destroy()
    end
})

Toggle:Set(false)
Checkbox:Set(true)
Slider:Set(50)
Progress:Set(35)

```
