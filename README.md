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
