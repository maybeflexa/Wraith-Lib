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

    function FileSystem.DeleteFile(path)
        local fn = delfile
        if type(fn) ~= "function" then
            return false
        end
        local success = pcall(fn, path)
        return success
    end

    function FileSystem.ListFiles(path)
        local fn = listfiles
        if type(fn) ~= "function" then
            return {}
        end
        local success, result = pcall(fn, path)
        if success and type(result) == "table" then
            return result
        end
        return {}
    end
end

local SaveManager = {} do
    SaveManager.Folder = "WraithSettings"
    SaveManager.Ignore = {}
    SaveManager.Parser = {
        Toggle = {
            Save = function(idx, object)
                return {type = "Toggle", idx = idx, value = object.Value}
            end,
            Load = function(idx, data)
                if SaveManager.Library.Flags[idx] then
                    SaveManager.Library.Flags[idx]:Set(data.value)
                end
            end
        },
        Slider = {
            Save = function(idx, object)
                return {type = "Slider", idx = idx, value = tostring(object.Value)}
            end,
            Load = function(idx, data)
                if SaveManager.Library.Flags[idx] then
                    SaveManager.Library.Flags[idx]:Set(tonumber(data.value))
                end
            end
        },
        Dropdown = {
            Save = function(idx, object)
                return {type = "Dropdown", idx = idx, value = object.Value, multi = object.Type == "MultiDropdown"}
            end,
            Load = function(idx, data)
                if SaveManager.Library.Flags[idx] then
                    SaveManager.Library.Flags[idx]:Set(data.value)
                end
            end
        },
        MultiDropdown = {
            Save = function(idx, object)
                return {type = "MultiDropdown", idx = idx, value = object.Value, multi = true}
            end,
            Load = function(idx, data)
                if SaveManager.Library.Flags[idx] then
                    SaveManager.Library.Flags[idx]:Set(data.value)
                end
            end
        },
        Colorpicker = {
            Save = function(idx, object)
                return {
                    type = "Colorpicker",
                    idx = idx,
                    value = {
                        R = object.Value.R,
                        G = object.Value.G,
                        B = object.Value.B
                    }
                }
            end,
            Load = function(idx, data)
                if SaveManager.Library.Flags[idx] and type(data.value) == "table" then
                    SaveManager.Library.Flags[idx]:Set(
                        Color3.new(data.value.R, data.value.G, data.value.B)
                    )
                end
            end
        },
        Keybind = {
            Save = function(idx, object)
                return {
                    type = "Keybind",
                    idx = idx,
                    value = object.Value and object.Value.Name or nil
                }
            end,
            Load = function(idx, data)
                if SaveManager.Library.Flags[idx] and data.value then
                    SaveManager.Library.Flags[idx]:Set(Enum.KeyCode[data.value])
                end
            end
        },
        Input = {
            Save = function(idx, object)
                return {type = "Input", idx = idx, value = object.Value}
            end,
            Load = function(idx, data)
                if SaveManager.Library.Flags[idx] and type(data.value) == "string" then
                    SaveManager.Library.Flags[idx]:Set(data.value)
                end
            end
        },
        Checkbox = {
            Save = function(idx, object)
                return {type = "Checkbox", idx = idx, value = object.Value}
            end,
            Load = function(idx, data)
                if SaveManager.Library.Flags[idx] then
                    SaveManager.Library.Flags[idx]:Set(data.value)
                end
            end
        },
        NumberSpinner = {
            Save = function(idx, object)
                return {type = "NumberSpinner", idx = idx, value = object.Value}
            end,
            Load = function(idx, data)
                if SaveManager.Library.Flags[idx] then
                    SaveManager.Library.Flags[idx]:Set(data.value)
                end
            end
        }
    }

    function SaveManager:SetIgnoreIndexes(list)
        for _, key in ipairs(list) do
            self.Ignore[key] = true
        end
    end

    function SaveManager:SetFolder(folder)
        self.Folder = folder
        self:BuildFolderTree()
    end

    function SaveManager:SetLibrary(library)
        self.Library = library
    end

    function SaveManager:BuildFolderTree()
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

    function SaveManager:CheckFolderTree()
        if FileSystem.IsFolder(self.Folder) then return end
        self:BuildFolderTree()
        task.wait(0.1)
    end

    function SaveManager:Save(name)
        if not name then
            return false, "no config file is selected"
        end
        local fullPath = self.Folder .. "/settings/" .. name .. ".json"
        local data = {objects = {}}

        for idx, flag in pairs(self.Library.Flags) do
            if not self.Parser[flag.Type] then continue end
            if self.Ignore[idx] then continue end
            if flag.Save == false then continue end
            table.insert(data.objects, self.Parser[flag.Type].Save(idx, flag))
        end

        local success, encoded = pcall(HttpService.JSONEncode, HttpService, data)
        if not success then
            return false, "failed to encode data"
        end

        if not FileSystem.WriteFile(fullPath, encoded) then
            return false, "file system is not available"
        end
        return true
    end

    function SaveManager:Load(name)
        if not name then
            return false, "no config file is selected"
        end
        local file = self.Folder .. "/settings/" .. name .. ".json"
        if not FileSystem.IsFile(file) then
            return false, "invalid file"
        end

        local content = FileSystem.ReadFile(file)
        if type(content) ~= "string" then
            return false, "failed to read file"
        end

        local success, decoded = pcall(HttpService.JSONDecode, HttpService, content)
        if not success then
            return false, "decode error"
        end

        for _, option in ipairs(decoded.objects) do
            if self.Parser[option.type] then
                task.spawn(function()
                    self.Parser[option.type].Load(option.idx, option)
                end)
            end
        end

        return true
    end

    function SaveManager:Delete(name)
        if not name then
            return false, "no config file is selected"
        end
        local file = self.Folder .. "/settings/" .. name .. ".json"
        if FileSystem.IsFile(file) then
            if FileSystem.DeleteFile(file) then
                return true
            end
            return false, "failed to delete file"
        end
        return false, "file does not exist"
    end

    function SaveManager:IgnoreThemeSettings()
        self:SetIgnoreIndexes({
            "InterfaceTheme", "AcrylicToggle", "TransparentToggle",
            "MenuKeybind", "_WraithTheme", "_WraithAnim",
            "_WraithConfigName", "_WraithToggleKey", "_WraithAutoLoad"
        })
    end

    function SaveManager:RefreshConfigList()
        local list = FileSystem.ListFiles(self.Folder .. "/settings")
        local out = {}
        for i = 1, #list do
            local file = list[i]
            if file:sub(-5) == ".json" then
                local pos = file:find(".json", 1, true)
                local start = pos
                local char = file:sub(pos, pos)
                while char ~= "/" and char ~= "\\" and char ~= "" do
                    pos = pos - 1
                    char = file:sub(pos, pos)
                end
                if char == "/" or char == "\\" then
                    table.insert(out, file:sub(pos + 1, start - 1))
                end
            end
        end
        return out
    end

    function SaveManager:SetAutoloadConfig(name)
        FileSystem.WriteFile(self.Folder .. "/settings/autoload.txt", name)
    end

    function SaveManager:DeleteAutoLoadConfig()
        if FileSystem.IsFile(self.Folder .. "/settings/autoload.txt") then
            FileSystem.DeleteFile(self.Folder .. "/settings/autoload.txt")
        end
    end

    function SaveManager:GetAutoloadConfig()
        if FileSystem.IsFile(self.Folder .. "/settings/autoload.txt") then
            return FileSystem.ReadFile(self.Folder .. "/settings/autoload.txt")
        end
        return nil
    end

    function SaveManager:LoadAutoloadConfig()
        if FileSystem.IsFile(self.Folder .. "/settings/autoload.txt") then
            local name = FileSystem.ReadFile(self.Folder .. "/settings/autoload.txt")
            local success, err = self:Load(name)
            if not success then
                return self.Library:Notify({
                    Title = "Wraith",
                    Content = "Config loader",
                    SubContent = "Failed to load autoload config: " .. tostring(err),
                    Duration = 7
                })
            end
            self.Library:Notify({
                Title = "Wraith",
                Content = "Config loader",
                SubContent = string.format("Auto loaded config %q", name),
                Duration = 7
            })
        end
    end

    function SaveManager:BuildConfigSection(tab)
        assert(self.Library, "Must set SaveManager.Library")

        tab:AddDivider({Text = "Configuration"})

        local configList
        configList = tab:AddDropdown({
            Title = "Config List",
            Description = "Select a saved configuration",
            Values = self:RefreshConfigList(),
            Default = nil,
            Flag = "SaveManager_ConfigList",
            Save = false,
            Callback = function() end
        })

        local configName = tab:AddInput({
            Title = "Config Name",
            Description = "Name for new configuration",
            Placeholder = "Config name...",
            Default = "",
            Flag = "SaveManager_ConfigName",
            Save = false,
            Callback = function() end
        })

        tab:AddButton({
            Title = "Create Config",
            Description = "Create a new configuration",
            Callback = function()
                local name = self.Library.Flags["SaveManager_ConfigName"].Value
                if name:gsub(" ", "") == "" then
                    return self.Library:Notify({
                        Title = "Wraith",
                        Content = "Save Config",
                        SubContent = "Invalid config name (empty)",
                        Duration = 7
                    })
                end

                local success, err = self:Save(name)
                if not success then
                    return self.Library:Notify({
                        Title = "Wraith",
                        Content = "Save Config",
                        SubContent = "Failed to save config: " .. tostring(err),
                        Duration = 7
                    })
                end

                self.Library:Notify({
                    Title = "Wraith",
                    Content = "Save Config",
                    SubContent = string.format("Created config %q", name),
                    Duration = 7
                })
                configList:SetValues(self:RefreshConfigList())
                configList:Set(name)
            end
        })

        tab:AddButton({
            Title = "Save Config",
            Description = "Overwrite the selected config",
            Callback = function()
                local name = self.Library.Flags["SaveManager_ConfigList"].Value
                if not name or name == "None" then
                    return self.Library:Notify({
                        Title = "Wraith",
                        Content = "Save Config",
                        SubContent = "No config selected",
                        Duration = 7
                    })
                end

                local success, err = self:Save(name)
                if not success then
                    return self.Library:Notify({
                        Title = "Wraith",
                        Content = "Save Config",
                        SubContent = "Failed to save: " .. tostring(err),
                        Duration = 7
                    })
                end

                self.Library:Notify({
                    Title = "Wraith",
                    Content = "Save Config",
                    SubContent = string.format("Saved config %q", name),
                    Duration = 7
                })
            end
        })

        tab:AddButton({
            Title = "Load Config",
            Description = "Load the selected config",
            Callback = function()
                local name = self.Library.Flags["SaveManager_ConfigList"].Value
                if not name or name == "None" then
                    return self.Library:Notify({
                        Title = "Wraith",
                        Content = "Load Config",
                        SubContent = "No config selected",
                        Duration = 7
                    })
                end

                local success, err = self:Load(name)
                if not success then
                    return self.Library:Notify({
                        Title = "Wraith",
                        Content = "Load Config",
                        SubContent = "Failed to load: " .. tostring(err),
                        Duration = 7
                    })
                end

                self.Library:Notify({
                    Title = "Wraith",
                    Content = "Load Config",
                    SubContent = string.format("Loaded config %q", name),
                    Duration = 7
                })
            end
        })

        tab:AddButton({
            Title = "Delete Config",
            Description = "Delete the selected config",
            Callback = function()
                local name = self.Library.Flags["SaveManager_ConfigList"].Value
                if not name or name == "None" then
                    return self.Library:Notify({
                        Title = "Wraith",
                        Content = "Delete Config",
                        SubContent = "No config selected",
                        Duration = 7
                    })
                end

                self.Library:Dialog({
                    Title = "Delete Config",
                    Content = string.format("Delete config %q?", name),
                    Buttons = {
                        {Title = "Cancel", Callback = function() end},
                        {Title = "Delete", Callback = function()
                            local success = self:Delete(name)
                            if success then
                                self.Library:Notify({
                                    Title = "Wraith",
                                    Content = "Delete Config",
                                    SubContent = string.format("Deleted config %q", name),
                                    Duration = 7
                                })
                                configList:SetValues(self:RefreshConfigList())
                                configList:Set(nil)
                            end
                        end}
                    }
                })
            end
        })

        tab:AddButton({
            Title = "Refresh List",
            Description = "Refresh the config list",
            Callback = function()
                configList:SetValues(self:RefreshConfigList())
                configList:Set(nil)
            end
        })

        tab:AddDivider({Text = "Autoload"})

        local autoloadLabel = tab:AddLabel({
            Text = "Current autoload: " .. (self:GetAutoloadConfig() or "none")
        })

        tab:AddButton({
            Title = "Set as Autoload",
            Description = "Auto-load this config on startup",
            Callback = function()
                local name = self.Library.Flags["SaveManager_ConfigList"].Value
                if not name or name == "None" then
                    return self.Library:Notify({
                        Title = "Wraith",
                        Content = "Autoload",
                        SubContent = "No config selected",
                        Duration = 7
                    })
                end
                self:SetAutoloadConfig(name)
                autoloadLabel:Set("Current autoload: " .. name)
                self.Library:Notify({
                    Title = "Wraith",
                    Content = "Autoload",
                    SubContent = string.format("Set %q as autoload", name),
                    Duration = 7
                })
            end
        })

        tab:AddButton({
            Title = "Reset Autoload",
            Description = "Disable autoload",
            Callback = function()
                self:DeleteAutoLoadConfig()
                autoloadLabel:Set("Current autoload: none")
                self.Library:Notify({
                    Title = "Wraith",
                    Content = "Autoload",
                    SubContent = "Autoload disabled",
                    Duration = 7
                })
            end
        })

        SaveManager:SetIgnoreIndexes({
            "SaveManager_ConfigList",
            "SaveManager_ConfigName"
        })
    end

    SaveManager:BuildFolderTree()
end

return SaveManager
