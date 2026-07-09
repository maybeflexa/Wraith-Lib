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
    Layout = MainGroup:AddTab({Title = "Layout", Icon = "layout-dashboard"}),
    Settings = UtilityGroup:AddTab({Title = "Settings", Icon = "settings"}),
    Configs = UtilityGroup:AddTab({Title = "Configs", Icon = "folder"})
}

Wraith:Notify({
    Title = "Wraith",
    Content = "The script has been loaded.",
    SubContent = "Current theme: " .. Wraith:GetCurrentTheme(),
    Duration = 5
})

Tabs.Main:AddParagraph({
    Title = "Theme Info",
    Content = "Current theme: " .. Wraith:GetCurrentTheme() .. "\nBackground transparency: " .. tostring(Wraith:GetTransparency().Background)
})

Tabs.Main:AddButton({
    Title = "Dialog",
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

Tabs.Main:AddButton({
    Title = "Set Background Image",
    Description = "Sets an optional window background image",
    Callback = function()
        Window:SetBackgroundImage("rbxassetid://6031302932", 0.82)
    end
})

Tabs.Main:AddButton({
    Title = "Clear Background Image",
    Description = "Removes the window background image",
    Callback = function()
        Window:SetBackgroundImage(nil)
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

local startTime = os.clock()
local Progress = Tabs.Elements:AddProgressBar("ExampleProgress", {
    Title = "ProgressBar",
    Description = "Auto updates from Getter",
    Min = 0,
    Max = 100,
    Default = 35,
    UpdateInterval = 0.25,
    Getter = function()
        return (os.clock() - startTime) % 100
    end
})

Tabs.Elements:AddButton({
    Title = "Set Progress",
    Description = "Sets progress to 80",
    Callback = function()
        Progress:Set(80)
    end
})

Tabs.Elements:AddButton({
    Title = "Restart Progress Getter",
    Description = "Starts automatic progress updates again",
    Callback = function()
        Progress:Start(function()
            return (os.clock() - startTime) % 100
        end, 0.25)
    end
})

local Dropdown = Tabs.Elements:AddDropdown("AdvancedDropdown", {
    Title = "Advanced Dropdown",
    Description = "Supports search, icons, descriptions, dividers and locked items",
    Searchable = true,
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
    Searchable = true,
    Values = {"One", "Two", "Three", "Four", "Five", "Six", "Seven"},
    Default = {"One"},
    Callback = function(value)
        print("MultiDropdown:", value)
    end
})

Tabs.Elements:AddInput("Input", {
    Title = "Input",
    Default = "Hello",
    Placeholder = "Type something...",
    Callback = function(value)
        print("Input:", value)
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

Tabs.Elements:AddNumberSpinner("Spinner", {
    Title = "Number Spinner",
    Description = "Click plus or minus to change value",
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

Tabs.Layout:AddDivider({
    Text = "Multi Input"
})

local MultiInput = Tabs.Layout:AddMultiInput("MultiInput", {
    Title = "Multi Input",
    Description = "Multiple inputs in one row",
    Fields = {
        {Name = "X", Default = "0", Placeholder = "X", Numeric = true},
        {Name = "Y", Default = "0", Placeholder = "Y", Numeric = true},
        {Name = "Z", Default = "0", Placeholder = "Z", Numeric = true}
    },
    Callback = function(values)
        print("MultiInput:", values.X, values.Y, values.Z)
    end
})

Tabs.Layout:AddDivider({
    Text = "Multi Slider"
})

local MultiSlider = Tabs.Layout:AddMultiSlider("MultiSlider", {
    Title = "Multi Slider",
    Description = "Multiple sliders in one element",
    Fields = {
        {Name = "A", Min = 0, Max = 100, Default = 50, Suffix = "%"},
        {Name = "B", Min = 0, Max = 100, Default = 25, Suffix = "%"},
        {Name = "C", Min = 0, Max = 100, Default = 75, Suffix = "%"}
    },
    Callback = function(values)
        print("MultiSlider:", values.A, values.B, values.C)
    end
})

Tabs.Layout:AddButton({
    Title = "Set Multi Values",
    Description = "Updates MultiInput and MultiSlider",
    Callback = function()
        MultiInput:Set({X = "10", Y = "20", Z = "30"})
        MultiSlider:Set({A = 80, B = 40, C = 60})
    end
})

Tabs.Layout:AddSeparator()

local Label = Tabs.Layout:AddLabel({
    Text = "This is a label."
})

Tabs.Layout:AddButton({
    Title = "Update Label",
    Callback = function()
        Label:Set("Label updated")
    end
})

local Section = Tabs.Layout:AddSection("Section")

Section:AddToggle("SectionToggle", {
    Title = "Toggle inside section",
    Default = false,
    Callback = function(value)
        print("Section toggle:", value)
    end
})

Section:AddSlider("SectionSlider", {
    Title = "Slider inside section",
    Min = 0,
    Max = 10,
    Default = 5,
    Rounding = 1,
    Callback = function(value)
        print("Section slider:", value)
    end
})

SaveManager:SetLibrary(Wraith)
InterfaceManager:SetLibrary(Wraith)

SaveManager:IgnoreThemeSettings()

InterfaceManager:SetFolder("WraithExample")
SaveManager:SetFolder("WraithExample/specific-game")

InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Configs)

Tabs.Configs:AddDivider({
    Text = "ConfigManager"
})

local ConfigName = "default"

Tabs.Configs:AddInput("ConfigManagerName", {
    Title = "Config Name",
    Default = ConfigName,
    Save = false,
    Callback = function(value)
        ConfigName = value
    end
})

Tabs.Configs:AddButton({
    Title = "ConfigManager Save",
    Description = "Saves current flags",
    Callback = function()
        Window.CurrentConfig = Window.ConfigManager:CreateConfig(ConfigName)
        Window.CurrentConfig:Save()
        Wraith:Notify({
            Title = "ConfigManager",
            Content = "Saved " .. ConfigName,
            Duration = 3
        })
    end
})

Tabs.Configs:AddButton({
    Title = "ConfigManager Load",
    Description = "Loads selected config",
    Callback = function()
        Window.CurrentConfig = Window.ConfigManager:CreateConfig(ConfigName)
        Window.CurrentConfig:Load()
        Wraith:Notify({
            Title = "ConfigManager",
            Content = "Loaded " .. ConfigName,
            Duration = 3
        })
    end
})

Tabs.Configs:AddButton({
    Title = "Set ConfigManager Autoload",
    Description = "Sets selected config as autoload",
    Callback = function()
        Window.CurrentConfig = Window.ConfigManager:CreateConfig(ConfigName)
        Window.CurrentConfig:SetAutoLoad(true)
    end
})

Toggle:Set(false)
Checkbox:Set(true)
Slider:Set(50)
Progress:Set(35)

SaveManager:LoadAutoloadConfig()
Window.ConfigManager:LoadAutoLoadConfig()
