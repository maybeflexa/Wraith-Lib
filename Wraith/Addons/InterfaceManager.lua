
local HttpService = game:GetService("HttpService")

local InterfaceManager = {} do
    InterfaceManager.Folder = "WraithSettings"
    InterfaceManager.Settings = {
        Theme = "AMOLED",
        Animation = "Default",
        Transparency = true
    }

    function InterfaceManager:SetFolder(folder)
        self.Folder = folder
        self:BuildFolderTree()
    end

    function InterfaceManager:SetLibrary(library)
        self.Library = library
    end

    function InterfaceManager:BuildFolderTree()
        local paths = {
            self.Folder,
            self.Folder .. "/themes",
            self.Folder .. "/settings"
        }
        for _, path in ipairs(paths) do
            if not isfolder(path) then
                makefolder(path)
            end
        end
    end

    function InterfaceManager:SaveSettings()
        local fullPath = self.Folder .. "/options.json"
        local success, encoded = pcall(HttpService.JSONEncode, HttpService, self.Settings)
        if success then
            writefile(fullPath, encoded)
        end
    end

    function InterfaceManager:LoadSettings()
        local path = self.Folder .. "/options.json"
        if isfile(path) then
            local success, decoded = pcall(HttpService.JSONDecode, HttpService, readfile(path))
            if success and type(decoded) == "table" then
                for key, value in pairs(decoded) do
                    self.Settings[key] = value
                end
            end
        end
    end

    function InterfaceManager:BuildInterfaceSection(tab)
        assert(self.Library, "Must set InterfaceManager.Library")
        local Library = self.Library

        self:LoadSettings()
        
        tab:AddDivider({ Text = "Effects" })

        tab:AddToggle("AcrylicToggle", {
            Title = "Acrylic Blur",
            Description = "Enable background blur effect",
            Default = false,
            Save = false,
            Callback = function(value)
                if value then
                    Library:EnableAcrylic()
                else
                    Library:DisableAcrylic()
                end
                self.Settings.Acrylic = value
                self:SaveSettings()
            end
        })

        tab:AddDropdown("TransitionStyle", {
            Title = "Page Transition",
            Description = "Animation when switching tabs",
            Values = Library:GetTransitions(),
            Default = "Fade",
            Save = false,
            Callback = function(value)
                Library:SetTransition(value)
                self.Settings.Transition = value
                self:SaveSettings()
                Library:Notify({
                    Title = "Wraith",
                    Content = "Transition set to " .. value,
                    Duration = 3
                })
            end
        })

        tab:AddDivider({Text = "Interface"})

        tab:AddDropdown({
            Title = "Theme",
            Description = "Change the UI theme",
            Values = Library:GetThemes(),
            Default = self.Settings.Theme or "AMOLED",
            Flag = "InterfaceTheme",
            Save = false,
            Callback = function(value)
                Library:SetTheme(value)
                self.Settings.Theme = value
                self:SaveSettings()
                Library:Notify({
                    Title = "Wraith",
                    Content = "Interface Manager",
                    SubContent = "Theme set to " .. value,
                    Duration = 5
                })
            end
        })

        tab:AddDropdown({
            Title = "Animation Style",
            Description = "UI animation preset",
            Values = Library:GetAnimations(),
            Default = self.Settings.Animation or "Default",
            Flag = "InterfaceAnimation",
            Save = false,
            Callback = function(value)
                Library:SetAnimation(value)
                self.Settings.Animation = value
                self:SaveSettings()
                Library:Notify({
                    Title = "Wraith",
                    Content = "Interface Manager",
                    SubContent = "Animation set to " .. value,
                    Duration = 5
                })
            end
        })

        tab:AddButton({
            Title = "Open Theme Editor",
            Description = "Create your own custom theme",
            Callback = function()
                Library:OpenThemeEditor()
            end
        })

        tab:AddDivider({Text = "Menu"})

        tab:AddKeybind({
            Title = "Menu Keybind",
            Description = "Toggle UI visibility",
            Default = Enum.KeyCode.LeftControl,
            Flag = "MenuKeybind",
            Save = false,
            Callback = function() end,
            ChangedCallback = function(key)
                if key then
                    Library:Notify({
                        Title = "Wraith",
                        Content = "Interface Manager",
                        SubContent = "Menu key set to " .. key.Name,
                        Duration = 5
                    })
                end
            end
        })

        InterfaceManager:Apply()
    end

    function InterfaceManager:Apply()
            if self.Settings.Acrylic and self.Library then
        self.Library:EnableAcrylic()
    end
    if self.Settings.Transition and self.Library then
        self.Library:SetTransition(self.Settings.Transition)
        end
        if self.Settings.Theme and self.Library then
            self.Library:SetTheme(self.Settings.Theme)
        end
        if self.Settings.Animation and self.Library then
            self.Library:SetAnimation(self.Settings.Animation)
        end
    end

    InterfaceManager:BuildFolderTree()
end

return InterfaceManager


        
