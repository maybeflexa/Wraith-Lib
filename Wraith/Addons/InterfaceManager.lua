local HttpService = game:GetService("HttpService")

local FileSystem = {}
do
    function FileSystem.IsFolder(path)
        local fn = isfolder
        if type(fn) ~= "function" then
            return false
        end
        local success, result = pcall(fn, path)
        return success and result == true
    end

    function FileSystem.IsFile(path)
        local fn = isfile
        if type(fn) ~= "function" then
            return false
        end
        local success, result = pcall(fn, path)
        return success and result == true
    end

    function FileSystem.MakeFolder(path)
        local fn = makefolder
        if type(fn) ~= "function" then
            return false
        end
        local success = pcall(fn, path)
        return success
    end

    function FileSystem.ReadFile(path)
        local fn = readfile
        if type(fn) ~= "function" then
            return nil
        end
        local success, result = pcall(fn, path)
        if success then
            return result
        end
        return nil
    end

    function FileSystem.WriteFile(path, content)
        local fn = writefile
        if type(fn) ~= "function" then
            return false
        end
        local success = pcall(fn, path, content)
        return success
    end
end

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
            if not FileSystem.IsFolder(path) then
                FileSystem.MakeFolder(path)
            end
        end
    end

    function InterfaceManager:SaveSettings()
        local fullPath = self.Folder .. "/options.json"
        local success, encoded = pcall(HttpService.JSONEncode, HttpService, self.Settings)
        if success then
            FileSystem.WriteFile(fullPath, encoded)
        end
    end

    function InterfaceManager:LoadSettings()
        local path = self.Folder .. "/options.json"
        if FileSystem.IsFile(path) then
            local content = FileSystem.ReadFile(path)
            local success, decoded = pcall(HttpService.JSONDecode, HttpService, content)
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
        if self.Settings.Transition and self.Library and self.Library.SetTransition then
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
