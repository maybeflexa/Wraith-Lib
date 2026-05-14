local HttpService = game:GetService("HttpService")

local SaveManager = {}
SaveManager.Library = nil
SaveManager.Folder = "Wraith"
SaveManager.Ignore = {}
SaveManager.IgnoreThemes = false
SaveManager.Autoload = "autoload"

local function safe(fn: (...any) -> ...any, ...: any): (boolean, ...any)
    return pcall(fn, ...)
end

local function hasFileApi(): boolean
    return typeof(writefile) == "function" and typeof(readfile) == "function" and typeof(isfile) == "function"
end

local function ensureFolder(path: string)
    if typeof(isfolder) ~= "function" or typeof(makefolder) ~= "function" then return end
    local current = ""
    for part in string.gmatch(path, "[^/]+") do
        current = current == "" and part or current .. "/" .. part
        safe(function()
            if not isfolder(current) then makefolder(current) end
        end)
    end
end

local function encodeValue(option: any): any
    if not option then return nil end
    if option.Type == "Colorpicker" then
        return {Type = option.Type, Value = {R = math.floor(option.Value.R * 255), G = math.floor(option.Value.G * 255), B = math.floor(option.Value.B * 255)}, Transparency = option.Transparency}
    end
    return {Type = option.Type, Value = option.Value, Mode = option.Mode}
end

local function decodeValue(data: any): any
    if typeof(data) ~= "table" then return data end
    if data.Type == "Colorpicker" and typeof(data.Value) == "table" then
        return Color3.fromRGB(tonumber(data.Value.R) or 255, tonumber(data.Value.G) or 255, tonumber(data.Value.B) or 255), data.Transparency
    end
    return data.Value, data.Mode
end

function SaveManager:SetLibrary(library: any)
    self.Library = library
    return self
end

function SaveManager:IgnoreThemeSettings()
    self.IgnoreThemes = true
    return self
end

function SaveManager:SetIgnoreIndexes(indexes: {any})
    self.Ignore = {}
    for _, index in next, indexes or {} do
        self.Ignore[tostring(index)] = true
    end
    return self
end

function SaveManager:SetFolder(folder: string)
    self.Folder = tostring(folder or self.Folder)
    ensureFolder(self.Folder)
    return self
end

function SaveManager:GetPath(name: string): string
    return self.Folder .. "/" .. tostring(name) .. ".json"
end

function SaveManager:GetConfig(name: string): {[string]: any}
    local library = self.Library
    local data = {Objects = {}}
    if not library or not library.Options then return data end
    for index, option in next, library.Options do
        if not self.Ignore[tostring(index)] then
            data.Objects[tostring(index)] = encodeValue(option)
        end
    end
    return data
end

function SaveManager:Save(name: string): boolean
    if not hasFileApi() then return false end
    ensureFolder(self.Folder)
    local path = self:GetPath(name)
    local data = self:GetConfig(name)
    local ok, encoded = safe(function()
        return HttpService:JSONEncode(data)
    end)
    if not ok then return false end
    local writeOk = safe(function()
        writefile(path, encoded)
    end)
    return writeOk
end

function SaveManager:Load(name: string): boolean
    if not hasFileApi() then return false end
    local path = self:GetPath(name)
    local exists = false
    safe(function()
        exists = isfile(path)
    end)
    if not exists then return false end
    local okRead, content = safe(function()
        return readfile(path)
    end)
    if not okRead then return false end
    local okDecode, decoded = safe(function()
        return HttpService:JSONDecode(content)
    end)
    if not okDecode or typeof(decoded) ~= "table" or typeof(decoded.Objects) ~= "table" then return false end
    local library = self.Library
    if not library or not library.Options then return false end
    for index, data in next, decoded.Objects do
        local option = library.Options[index]
        if option then
            local value, extra = decodeValue(data)
            safe(function()
                if option.Type == "Colorpicker" then
                    option:SetValueRGB(value)
                    if extra ~= nil and option.SetTransparency then option:SetTransparency(extra) end
                elseif option.Type == "Keybind" then
                    option:SetValue(value, extra)
                else
                    option:SetValue(value)
                end
            end)
        end
    end
    return true
end

function SaveManager:Delete(name: string): boolean
    if typeof(delfile) ~= "function" then return false end
    local path = self:GetPath(name)
    local ok = safe(function()
        if isfile(path) then delfile(path) end
    end)
    return ok
end

function SaveManager:ListConfigs(): {string}
    local configs = {}
    if typeof(listfiles) ~= "function" then return configs end
    local ok, files = safe(function()
        return listfiles(self.Folder)
    end)
    if not ok or typeof(files) ~= "table" then return configs end
    for _, file in next, files do
        local name = tostring(file):match("([^/\\]+)%.json$")
        if name then table.insert(configs, name) end
    end
    table.sort(configs)
    return configs
end

function SaveManager:SaveAutoloadConfig(name: string): boolean
    if not hasFileApi() then return false end
    ensureFolder(self.Folder)
    local ok = safe(function()
        writefile(self:GetPath(self.Autoload), HttpService:JSONEncode({Config = name}))
    end)
    return ok
end

function SaveManager:LoadAutoloadConfig(): boolean
    if not hasFileApi() then return false end
    local path = self:GetPath(self.Autoload)
    local exists = false
    safe(function() exists = isfile(path) end)
    if not exists then return false end
    local okRead, content = safe(function() return readfile(path) end)
    if not okRead then return false end
    local okDecode, decoded = safe(function() return HttpService:JSONDecode(content) end)
    if not okDecode or typeof(decoded) ~= "table" or not decoded.Config then return false end
    return self:Load(tostring(decoded.Config))
end

function SaveManager:BuildConfigSection(tab: any)
    if not tab then return end
    local selected = "default"
    local nameInput = tab:AddInput("ConfigName", {Title = "Config Name", Default = "default", Placeholder = "config name", Finished = true, Callback = function(value)
        selected = tostring(value ~= "" and value or "default")
    end})
    if nameInput and nameInput.OnChanged then
        nameInput:OnChanged(function()
            selected = tostring(nameInput.Value ~= "" and nameInput.Value or "default")
        end)
    end
    tab:AddButton({Title = "Save Config", Description = "Writes current Wraith options to disk", Callback = function()
        local ok = self:Save(selected)
        if self.Library and self.Library.Notify then
            self.Library:Notify({Title = "SaveManager", Content = ok and "Saved config" or "Save skipped", SubContent = selected, Duration = 3})
        end
    end})
    tab:AddButton({Title = "Load Config", Description = "Loads options from disk", Callback = function()
        local ok = self:Load(selected)
        if self.Library and self.Library.Notify then
            self.Library:Notify({Title = "SaveManager", Content = ok and "Loaded config" or "Load failed", SubContent = selected, Duration = 3})
        end
    end})
    tab:AddButton({Title = "Set Autoload", Description = "Loads this config automatically next launch", Callback = function()
        local ok = self:SaveAutoloadConfig(selected)
        if self.Library and self.Library.Notify then
            self.Library:Notify({Title = "SaveManager", Content = ok and "Autoload set" or "Autoload skipped", SubContent = selected, Duration = 3})
        end
    end})
end

return SaveManager
