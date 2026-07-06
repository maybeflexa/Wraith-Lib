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
    Elements = Window:AddTab({Title = "Elements", Icon = "sliders-horizontal"}),
    Settings = Window:AddTab({Title = "Settings", Icon = "settings"})
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

local Toggle = Tabs.Elements:AddToggle("ExampleToggle", {
    Title = "Toggle",
    Description = "Toggle example",
    Default = false,
    Callback = function(value)
        print("Toggle:", value)
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

local Progress = Tabs.Elements:AddProgressBar("ExampleProgress", {
    Title = "ProgressBar",
    Description = "Progress display",
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

SaveManager:SetLibrary(Wraith)
InterfaceManager:SetLibrary(Wraith)

SaveManager:IgnoreThemeSettings()

InterfaceManager:SetFolder("WraithExample")
SaveManager:SetFolder("WraithExample/specific-game")

InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

Tabs.Settings:AddDivider({
    Text = "Window"
})

Tabs.Settings:AddDropdown("UIScale", {
    Title = "UI Scale",
    Description = "Changes the window scale",
    Values = {"0.8", "0.9", "1", "1.1", "1.2"},
    Default = "1",
    Save = false,
    Callback = function(value)
        Window:SetUIScale(tonumber(value))
    end
})

Tabs.Settings:AddDivider({
    Text = "ConfigManager"
})

local ConfigName = "default"

Tabs.Settings:AddInput("ConfigManagerName", {
    Title = "Config Name",
    Default = ConfigName,
    Save = false,
    Callback = function(value)
        ConfigName = value
    end
})

Tabs.Settings:AddButton({
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

Tabs.Settings:AddButton({
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

Tabs.Settings:AddButton({
    Title = "Set ConfigManager Autoload",
    Description = "Sets selected config as autoload",
    Callback = function()
        Window.CurrentConfig = Window.ConfigManager:CreateConfig(ConfigName)
        Window.CurrentConfig:SetAutoLoad(true)
    end
})

Toggle:Set(false)
Slider:Set(50)
Progress:Set(35)

SaveManager:LoadAutoloadConfig()
Window.ConfigManager:LoadAutoLoadConfig()
