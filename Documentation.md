# Wraith Library UI Documentation

## Installation

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

```lua
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
```

| Option | Type | Description |
| --- | --- | --- |
| `Title` | string | Window title |
| `SubTitle` | string | Window subtitle |
| `Size` | UDim2 | Window size |
| `MinimizeKey` | Enum.KeyCode | Toggle visibility key |
| `TabWidth` | number | Sidebar width |
| `Resizable` | boolean | Enables resize handle |
| `Searchable` | boolean | Enables sidebar search |
| `MinSize` | Vector2 | Minimum resize size |
| `UIScale` | number | Initial UI scale |
| `OpenButton` | table | Floating button configuration |

## OpenButton

```lua
OpenButton = {
    Enabled = true,
    Title = "W",
    Draggable = true,
    OnlyMobile = false,
    Size = UDim2.new(0, 46, 0, 46),
    Position = UDim2.new(0, 16, 0.5, -23),
    Color = Color3.fromRGB(20, 20, 23),
    Transparency = 0.05,
    TextSize = 22,
    TextScaled = false
}
```

## Tabs

```lua
local Tabs = {
    Main = Window:AddTab({Title = "Main", Icon = "house"}),
    Settings = Window:AddTab({Title = "Settings", Icon = "settings"})
}
```

## Window Methods

```lua
Window:SelectTab(Tabs.Main)
Window:Show()
Window:Hide()
Window:Minimize()
Window:Destroy()
Window:Resize(650, 390)
Window:SetUIScale(0.9)
local scale = Window:GetUIScale()
```

## Window Tags

```lua
Window:Tag({
    Title = "v1.1.0"
})
```

## Topbar Buttons

```lua
Window:CreateTopbarButton("Theme", "settings", function()
    Wraith:SetTheme("Dark")
end)
```

## Notifications

```lua
Wraith:Notify({
    Title = "Wraith",
    Content = "Notification content",
    SubContent = "Extra content",
    Duration = 5
})
```

## Dialogs

```lua
Wraith:Dialog({
    Title = "Dialog",
    Content = "Dialog content",
    Buttons = {
        {
            Title = "Cancel",
            Callback = function() end
        },
        {
            Title = "Confirm",
            Callback = function() end
        }
    }
})
```

## API Syntax

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

```lua
local Paragraph = Tabs.Main:AddParagraph({
    Title = "Paragraph",
    Content = "Content text"
})

Paragraph:Set({
    Title = "New title",
    Content = "New content"
})

Paragraph:SetTitle("New title")
Paragraph:SetDesc("New content")
Paragraph:Destroy()
```

## Button

```lua
local Button = Tabs.Main:AddButton({
    Title = "Button",
    Description = "Button description",
    Callback = function()
        print("clicked")
    end
})

Button:Highlight()
Button:SetTitle("New title")
Button:SetDesc("New description")
Button:Destroy()
```

## Toggle

```lua
local Toggle = Tabs.Main:AddToggle("AutoFarm", {
    Title = "Auto Farm",
    Description = "Toggle description",
    Default = false,
    Callback = function(value)
        print(value)
    end
})

Toggle:Set(true)
```

## Checkbox

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

```lua
local Slider = Tabs.Main:AddSlider("WalkSpeed", {
    Title = "WalkSpeed",
    Min = 16,
    Max = 100,
    Default = 16,
    Rounding = 1,
    Suffix = " studs",
    Callback = function(value)
        print(value)
    end
})

Slider:Set(50)
```

## ProgressBar

```lua
local Progress = Tabs.Main:AddProgressBar({
    Title = "Progress",
    Description = "Progress description",
    Min = 0,
    Max = 100,
    Default = 25
})

Progress:Set(80)
Progress:SetRange(0, 200)
Progress:SetMin(0)
Progress:SetMax(100)
```

Alias:

```lua
local Progress = Tabs.Main:ProgressBar({
    Title = "Progress"
})
```

## Dropdown

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

```lua
local Dropdown = Tabs.Main:AddDropdown("FileAction", {
    Title = "File Action",
    Values = {
        {
            Title = "New File",
            Description = "Create a new file",
            Icon = "file-plus",
            Value = "new",
            Callback = function()
                print("new")
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

```lua
local MultiDropdown = Tabs.Main:AddMultiDropdown("Targets", {
    Title = "Targets",
    Values = {"Player", "NPC", "Boss"},
    Default = {"Player"},
    Callback = function(values)
        print(values)
    end
})

MultiDropdown:Set({"Player", "Boss"})
```

## Colorpicker

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

```lua
local Input = Tabs.Main:AddInput("Username", {
    Title = "Username",
    Placeholder = "Enter username",
    Default = "",
    Callback = function(value)
        print(value)
    end
})

Input:Set("maybeflexa")
```

## Textarea

```lua
local Textarea = Tabs.Main:AddInput("Notes", {
    Title = "Notes",
    Type = "Textarea",
    Placeholder = "Enter notes",
    Default = "Line one\nLine two",
    Callback = function(value)
        print(value)
    end
})
```

Alternative:

```lua
Tabs.Main:AddInput("Notes", {
    Title = "Notes",
    MultiLine = true
})
```

## MultiInput

```lua
local MultiInput = Tabs.Main:AddMultiInput("Coords", {
    Title = "Coordinates",
    Fields = {
        {Name = "X", Placeholder = "0"},
        {Name = "Y", Placeholder = "0"},
        {Name = "Z", Placeholder = "0"}
    },
    Callback = function(values)
        print(values)
    end
})

MultiInput:Set({
    X = "10",
    Y = "20",
    Z = "30"
})
```

## MultiSlider

```lua
local MultiSlider = Tabs.Main:AddMultiSlider("Stats", {
    Title = "Stats",
    Fields = {
        {Name = "Speed", Min = 0, Max = 100, Default = 50},
        {Name = "Power", Min = 0, Max = 100, Default = 25}
    },
    Callback = function(values)
        print(values)
    end
})

MultiSlider:Set({
    Speed = 75,
    Power = 60
})
```

## NumberSpinner

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

Spinner:Set(5)
```

## DateTime

```lua
Tabs.Main:AddDateTime({
    Title = "Clock",
    Format = "%H:%M:%S"
})
```

## StatusBar

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

```lua
Tabs.Main:AddSeparator()
```

## Divider

```lua
Tabs.Main:AddDivider({
    Text = "Section"
})
```

## Label

```lua
local Label = Tabs.Main:AddLabel({
    Text = "Label text"
})

Label:Set("New label")
```

## Space

```lua
Tabs.Main:AddSpace({
    Height = 8
})
```

Alias:

```lua
Tabs.Main:Space({
    Height = 8
})
```

## Section

```lua
local Section = Tabs.Main:AddSection("Combat")

Section:AddToggle("KillAura", {
    Title = "Kill Aura"
})
```

## Group

```lua
local Group = Tabs.Main:AddGroup({
    Padding = 6
})

Group:AddParagraph({
    Title = "Group",
    Content = "Grouped content"
})

Group:AddButton({
    Title = "Grouped Button",
    Callback = function() end
})

Group:Destroy()
```

Alias:

```lua
local Group = Tabs.Main:Group({
    Padding = 6
})
```

## VStack

```lua
local VStack = Tabs.Main:AddVStack({
    Padding = 6
})

VStack:AddButton({
    Title = "Button"
})
```

Alias:

```lua
local VStack = Tabs.Main:VStack({
    Padding = 6
})
```

## HStack

```lua
local Row = Tabs.Main:AddHStack({
    Padding = 6
})

local Left = Row:AddColumn(UDim2.new(0.5, -3, 0, 0))
local Right = Row:AddColumn(UDim2.new(0.5, -3, 0, 0))

Left:AddButton({
    Title = "Left"
})

Right:AddButton({
    Title = "Right"
})
```

Alias:

```lua
local Row = Tabs.Main:HStack({
    Padding = 6
})
```

## Theme System

```lua
Wraith:SetTheme("Dark")
local themes = Wraith:GetThemes()
local current = Wraith:GetCurrentTheme()
```

```lua
Wraith:OnThemeChange(function(name, theme)
    print(name, theme)
end)
```

```lua
local transparency = Wraith:GetTransparency()
print(transparency.Background)
print(transparency.Element)
print(transparency.Sidebar)
```

## AddTheme

```lua
Wraith:AddTheme("Ocean", {
    Bg = Color3.fromRGB(8, 12, 18),
    Bg2 = Color3.fromRGB(12, 18, 26),
    Bg3 = Color3.fromRGB(18, 26, 36),
    El = Color3.fromRGB(16, 24, 34),
    ElHov = Color3.fromRGB(22, 34, 48),
    Border = Color3.fromRGB(40, 60, 80),
    Txt = Color3.fromRGB(235, 245, 255),
    Txt2 = Color3.fromRGB(150, 175, 195),
    Txt3 = Color3.fromRGB(90, 115, 135),
    Acc = Color3.fromRGB(80, 170, 255),
    AccD = Color3.fromRGB(45, 120, 200),
    TOn = Color3.fromRGB(80, 170, 255),
    TOff = Color3.fromRGB(35, 50, 65),
    Slider = Color3.fromRGB(80, 170, 255),
    BgTr = 0.1,
    ElTr = 0.35,
    SbTr = 0.18
})
```

## Theme Editor

```lua
Wraith:OpenThemeEditor()
```

## Gradient Helper

```lua
local gradient = Wraith:Gradient({
    {Time = 0, Color = Color3.fromRGB(255, 0, 0)},
    {Time = 1, Color = Color3.fromRGB(0, 0, 255)}
})
```

## ApplyGradient

```lua
local frame = Instance.new("Frame")
local gradient = Wraith:Gradient({
    {Time = 0, Color = Color3.fromRGB(255, 0, 0)},
    {Time = 1, Color = Color3.fromRGB(0, 0, 255)}
})

Wraith:ApplyGradient(frame, gradient, 0)
```

Theme key usage:

```lua
Wraith:AddTheme("GradientTheme", {
    AccentGradient = Wraith:Gradient({
        {Time = 0, Color = Color3.fromRGB(255, 0, 0)},
        {Time = 1, Color = Color3.fromRGB(0, 0, 255)}
    })
})

Wraith:ApplyGradient(frame, "AccentGradient", 0)
```

## Font System

```lua
Wraith:SetFont(Enum.Font.Gotham)
```

## Localization

```lua
Wraith:Localization({
    en = {
        Welcome = "Welcome"
    },
    de = {
        Welcome = "Willkommen"
    }
})

Wraith:SetLanguage("de")
print(Wraith:Translate("Welcome"))
```

## Icon System

```lua
Wraith.LoadIcons("Lucide")
local icon = Wraith.GetIcon("settings")
```

```lua
Wraith:AddIconPack("custom", {
    star = "rbxassetid://6031068426"
})

Window:CreateTopbarButton("Star", "custom:star", function() end)
```

## Animation System

```lua
Wraith:SetAnimation("Smooth")
local animations = Wraith:GetAnimations()
```

Built-in presets:

| Name |
| --- |
| `Default` |
| `Bounce` |
| `Elastic` |
| `Smooth` |
| `Snappy` |
| `Fade` |

## SaveManager Addon

```lua
SaveManager:SetLibrary(Wraith)
SaveManager:SetFolder("WraithExample/specific-game")
SaveManager:IgnoreThemeSettings()
SaveManager:BuildConfigSection(Tabs.Settings)
SaveManager:LoadAutoloadConfig()
```

## InterfaceManager Addon

```lua
InterfaceManager:SetLibrary(Wraith)
InterfaceManager:SetFolder("WraithExample")
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
```

## ConfigManager Bridge

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
local autoload = Window.ConfigManager:GetAutoLoadConfigs()
```

## Core SaveManager

```lua
Wraith.SaveManager:Save("default")
Wraith.SaveManager:Load("default")
Wraith.SaveManager:Delete("default")
local configs = Wraith.SaveManager:GetConfigs()
```

## Flags

```lua
local toggle = Wraith.Flags.AutoFarm

toggle:Set(true)
```

## Tooltip

```lua
Tabs.Main:AddButton({
    Title = "Button",
    Tooltip = "Tooltip text",
    Callback = function() end
})
```

## Full Example

Use `Example.luau` for the complete updated example.
