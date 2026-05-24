local Wraith = {}
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Player = Players.LocalPlayer
local IsMobile = UIS.TouchEnabled and not UIS.KeyboardEnabled

local WraithFlags = {}
local LoadedIcons = {}
local AllBinds = {}
local DDRefresh = {}
local TabRefreshers = {}
local SearchableElements = {}
local ScreenGui

local PlatformURLs = {
    ["Lucide"] = "https://raw.githubusercontent.com/maybeflexa/Wraith-Lib/refs/heads/main/Wraith/Icons/Lucide.lua"
}

local AnimPresets = {
    Default = {
        Style = Enum.EasingStyle.Quart,
        Direction = Enum.EasingDirection.Out,
        Duration = 0.25
    },
    Bounce = {
        Style = Enum.EasingStyle.Bounce,
        Direction = Enum.EasingDirection.Out,
        Duration = 0.5
    },
    Elastic = {
        Style = Enum.EasingStyle.Elastic,
        Direction = Enum.EasingDirection.Out,
        Duration = 0.6
    },
    Smooth = {
        Style = Enum.EasingStyle.Sine,
        Direction = Enum.EasingDirection.InOut,
        Duration = 0.4
    },
    Snappy = {
        Style = Enum.EasingStyle.Back,
        Direction = Enum.EasingDirection.Out,
        Duration = 0.3
    },
    Fade = {
        Style = Enum.EasingStyle.Linear,
        Direction = Enum.EasingDirection.InOut,
        Duration = 0.35
    }
}
local CurrentAnim = AnimPresets.Default

local Themes = {
    ["AMOLED"] = {
        Bg = Color3.fromRGB(0, 0, 0),
        Bg2 = Color3.fromRGB(8, 8, 8),
        Bg3 = Color3.fromRGB(18, 18, 18),
        El = Color3.fromRGB(13, 13, 13),
        ElHov = Color3.fromRGB(22, 22, 22),
        Border = Color3.fromRGB(34, 34, 34),
        Txt = Color3.fromRGB(255, 255, 255),
        Txt2 = Color3.fromRGB(160, 160, 160),
        Txt3 = Color3.fromRGB(95, 95, 95),
        Acc = Color3.fromRGB(212, 212, 212),
        AccD = Color3.fromRGB(160, 160, 160),
        TOn = Color3.fromRGB(220, 220, 220),
        TOff = Color3.fromRGB(40, 40, 40),
        Slider = Color3.fromRGB(200, 200, 200),
        BgTr = 0.1,
        ElTr = 0.4,
        SbTr = 0.18
    },
    ["Dark"] = {
        Bg = Color3.fromRGB(14, 14, 16),
        Bg2 = Color3.fromRGB(20, 20, 23),
        Bg3 = Color3.fromRGB(28, 28, 32),
        El = Color3.fromRGB(24, 24, 28),
        ElHov = Color3.fromRGB(36, 36, 40),
        Border = Color3.fromRGB(46, 46, 50),
        Txt = Color3.fromRGB(244, 244, 244),
        Txt2 = Color3.fromRGB(154, 154, 160),
        Txt3 = Color3.fromRGB(100, 100, 108),
        Acc = Color3.fromRGB(200, 200, 208),
        AccD = Color3.fromRGB(148, 148, 154),
        TOn = Color3.fromRGB(210, 210, 216),
        TOff = Color3.fromRGB(50, 50, 54),
        Slider = Color3.fromRGB(190, 190, 198),
        BgTr = 0.12,
        ElTr = 0.38,
        SbTr = 0.2
    },
    ["Darker"] = {
        Bg = Color3.fromRGB(6, 6, 8),
        Bg2 = Color3.fromRGB(12, 12, 14),
        Bg3 = Color3.fromRGB(20, 20, 22),
        El = Color3.fromRGB(16, 16, 18),
        ElHov = Color3.fromRGB(28, 28, 30),
        Border = Color3.fromRGB(38, 38, 42),
        Txt = Color3.fromRGB(238, 238, 238),
        Txt2 = Color3.fromRGB(142, 142, 148),
        Txt3 = Color3.fromRGB(90, 90, 96),
        Acc = Color3.fromRGB(192, 192, 198),
        AccD = Color3.fromRGB(138, 138, 144),
        TOn = Color3.fromRGB(202, 202, 208),
        TOff = Color3.fromRGB(44, 44, 48),
        Slider = Color3.fromRGB(182, 182, 190),
        BgTr = 0.08,
        ElTr = 0.36,
        SbTr = 0.15
    },
    ["Midnight"] = {
        Bg = Color3.fromRGB(4, 4, 12),
        Bg2 = Color3.fromRGB(10, 10, 20),
        Bg3 = Color3.fromRGB(18, 18, 30),
        El = Color3.fromRGB(14, 14, 24),
        ElHov = Color3.fromRGB(26, 26, 38),
        Border = Color3.fromRGB(40, 40, 54),
        Txt = Color3.fromRGB(232, 232, 242),
        Txt2 = Color3.fromRGB(144, 144, 164),
        Txt3 = Color3.fromRGB(94, 94, 114),
        Acc = Color3.fromRGB(180, 180, 208),
        AccD = Color3.fromRGB(130, 130, 158),
        TOn = Color3.fromRGB(190, 190, 218),
        TOff = Color3.fromRGB(42, 42, 54),
        Slider = Color3.fromRGB(170, 170, 198),
        BgTr = 0.1,
        ElTr = 0.38,
        SbTr = 0.18
    },
    ["Charcoal"] = {
        Bg = Color3.fromRGB(20, 20, 20),
        Bg2 = Color3.fromRGB(28, 28, 28),
        Bg3 = Color3.fromRGB(38, 38, 38),
        El = Color3.fromRGB(32, 32, 32),
        ElHov = Color3.fromRGB(46, 46, 46),
        Border = Color3.fromRGB(56, 56, 56),
        Txt = Color3.fromRGB(248, 248, 248),
        Txt2 = Color3.fromRGB(162, 162, 162),
        Txt3 = Color3.fromRGB(108, 108, 108),
        Acc = Color3.fromRGB(212, 212, 212),
        AccD = Color3.fromRGB(152, 152, 152),
        TOn = Color3.fromRGB(222, 222, 222),
        TOff = Color3.fromRGB(58, 58, 58),
        Slider = Color3.fromRGB(198, 198, 198),
        BgTr = 0.12,
        ElTr = 0.4,
        SbTr = 0.22
    },
    ["Light"] = {
        Bg = Color3.fromRGB(244, 244, 247),
        Bg2 = Color3.fromRGB(232, 232, 236),
        Bg3 = Color3.fromRGB(218, 218, 224),
        El = Color3.fromRGB(225, 225, 230),
        ElHov = Color3.fromRGB(210, 210, 216),
        Border = Color3.fromRGB(192, 192, 198),
        Txt = Color3.fromRGB(15, 15, 18),
        Txt2 = Color3.fromRGB(68, 68, 76),
        Txt3 = Color3.fromRGB(110, 110, 118),
        Acc = Color3.fromRGB(40, 40, 48),
        AccD = Color3.fromRGB(80, 80, 88),
        TOn = Color3.fromRGB(28, 28, 34),
        TOff = Color3.fromRGB(188, 188, 194),
        Slider = Color3.fromRGB(48, 48, 56),
        BgTr = 0.08,
        ElTr = 0.3,
        SbTr = 0.12
    },
    ["Obsidian"] = {
        Bg = Color3.fromRGB(2, 2, 4),
        Bg2 = Color3.fromRGB(6, 6, 10),
        Bg3 = Color3.fromRGB(14, 14, 18),
        El = Color3.fromRGB(10, 10, 14),
        ElHov = Color3.fromRGB(22, 22, 26),
        Border = Color3.fromRGB(32, 32, 38),
        Txt = Color3.fromRGB(228, 228, 232),
        Txt2 = Color3.fromRGB(138, 138, 148),
        Txt3 = Color3.fromRGB(88, 88, 98),
        Acc = Color3.fromRGB(172, 172, 185),
        AccD = Color3.fromRGB(122, 122, 135),
        TOn = Color3.fromRGB(182, 182, 195),
        TOff = Color3.fromRGB(38, 38, 44),
        Slider = Color3.fromRGB(162, 162, 175),
        BgTr = 0.06,
        ElTr = 0.34,
        SbTr = 0.12
    }
}

local T = Themes["AMOLED"]

local function Tw(inst, props, dur, style, dir)
    if not inst or not inst.Parent then return end
    TS:Create(
        inst,
        TweenInfo.new(
            dur or CurrentAnim.Duration,
            style or CurrentAnim.Style,
            dir or CurrentAnim.Direction
        ),
        props
    ):Play()
end

local function C(className, properties)
    local inst = Instance.new(className)
    if properties then
        for key, value in pairs(properties) do
            if key ~= "Parent" then
                pcall(function()
                    inst[key] = value
                end)
            end
        end
        if properties.Parent then
            inst.Parent = properties.Parent
        end
    end
    return inst
end

local function Cn(parent, radius)
    return C("UICorner", {
        CornerRadius = UDim.new(0, radius or 8),
        Parent = parent
    })
end

local function St(parent, color, thickness, transparency)
    return C("UIStroke", {
        Color = color or T.Border,
        Thickness = thickness or 1,
        Transparency = transparency or 0.45,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Parent = parent
    })
end

local function Pd(parent, top, bottom, left, right)
    return C("UIPadding", {
        PaddingTop = UDim.new(0, top or 0),
        PaddingBottom = UDim.new(0, bottom or 0),
        PaddingLeft = UDim.new(0, left or 0),
        PaddingRight = UDim.new(0, right or 0),
        Parent = parent
    })
end

local function B(inst, map)
    table.insert(AllBinds, {I = inst, M = map})
end

local function Apply()
    for i = #AllBinds, 1, -1 do
        local b = AllBinds[i]
        if not b.I or not b.I.Parent then
            table.remove(AllBinds, i)
        else
            for prop, key in pairs(b.M) do
                if T[key] ~= nil then
                    pcall(function()
                        if typeof(T[key]) == "Color3" then
                            Tw(b.I, {[prop] = T[key]}, 0.3)
                        elseif typeof(T[key]) == "number" then
                            Tw(b.I, {[prop] = T[key]}, 0.3)
                        end
                    end)
                end
            end
        end
    end
    for i = #DDRefresh, 1, -1 do
        local r = DDRefresh[i]
        if r and r.F and r.F.Parent then
            pcall(r.R)
        else
            table.remove(DDRefresh, i)
        end
    end
    for i = #TabRefreshers, 1, -1 do
        local r = TabRefreshers[i]
        if r and r.F and r.F.Parent then
            pcall(r.R)
        else
            table.remove(TabRefreshers, i)
        end
    end
end

local function Drag(frame, handle)
    local dragging = false
    local dragInput = nil
    local dragStart = nil
    local startPos = nil
    handle = handle or frame

    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            Tw(frame, {
                Position = UDim2.new(
                    startPos.X.Scale,
                    startPos.X.Offset + delta.X,
                    startPos.Y.Scale,
                    startPos.Y.Offset + delta.Y
                )
            }, 0.04)
        end
    end)
end

local function SetupGui()
    if ScreenGui and ScreenGui.Parent then
        return ScreenGui
    end
    local parent
    pcall(function()
        if gethui then
            parent = gethui()
        end
    end)
    if not parent then
        pcall(function()
            if syn and syn.protect_gui then
                ScreenGui = C("ScreenGui", {
                    Name = "Wraith",
                    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
                    ResetOnSpawn = false,
                    IgnoreGuiInset = true,
                    DisplayOrder = 999
                })
                syn.protect_gui(ScreenGui)
                ScreenGui.Parent = CoreGui
            end
        end)
        if ScreenGui then return ScreenGui end
        parent = CoreGui
    end
    ScreenGui = C("ScreenGui", {
        Name = "Wraith",
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        ResetOnSpawn = false,
        IgnoreGuiInset = true,
        DisplayOrder = 999,
        Parent = parent
    })
    return ScreenGui
end

local function EnsF()
    pcall(function()
        if not isfolder("Wraith") then makefolder("Wraith") end
        if not isfolder("Wraith/Icons") then makefolder("Wraith/Icons") end
        if not isfolder("Wraith/configs") then makefolder("Wraith/configs") end
        if not isfolder("Wraith/themes") then makefolder("Wraith/themes") end
    end)
end

local function SaveThemePref(name)
    pcall(function()
        EnsF()
        writefile("Wraith/theme.txt", name)
    end)
end

local function LoadThemePref()
    local ok, r = pcall(function()
        if isfile("Wraith/theme.txt") then
            return readfile("Wraith/theme.txt")
        end
        return nil
    end)
    if ok and r and Themes[r] then
        T = Themes[r]
        return r
    end
    return "AMOLED"
end

local function LoadCustomThemes()
    EnsF()
    pcall(function()
        local files = listfiles("Wraith/themes")
        for _, f in ipairs(files) do
            if f:match("%.json$") then
                local ok, content = pcall(function() return readfile(f) end)
                if ok and content then
                    local ok2, data = pcall(function()
                        return HttpService:JSONDecode(content)
                    end)
                    if ok2 and data and data.Name then
                        local theme = {}
                        for k, v in pairs(data) do
                            if k ~= "Name" then
                                if type(v) == "table" and v.R then
                                    theme[k] = Color3.new(v.R, v.G, v.B)
                                elseif type(v) == "number" then
                                    theme[k] = v
                                end
                            end
                        end
                        if not Themes[data.Name] then
                            Themes[data.Name] = theme
                        end
                    end
                end
            end
        end
    end)
end

local function LoadIcons(platform)
    platform = platform or "Lucide"
    EnsF()
    local cachePath = "Wraith/Icons/" .. platform .. ".lua"
    local raw
    pcall(function()
        if isfile(cachePath) then
            local r = readfile(cachePath)
            if r and #r > 50 then raw = r end
        end
    end)
    if not raw then
        local url = PlatformURLs[platform]
        if not url then
            LoadedIcons = {}
            return
        end
        local success, result = pcall(function()
            return game:HttpGet(url)
        end)
        if success and result and #result > 50 then
            raw = result
            pcall(function() writefile(cachePath, result) end)
        end
    end
    if not raw then
        LoadedIcons = {}
        return
    end
    local ok, result = pcall(function()
        local fn = loadstring(raw)
        if fn then return fn() end
        return nil
    end)
    if ok and type(result) == "table" then
        LoadedIcons = result
    else
        LoadedIcons = {}
    end
end

local function GetIcon(name)
    if not LoadedIcons or not name then return nil end
    if LoadedIcons[name] then return LoadedIcons[name] end
    return nil
end

local function ApplyIcon(img, data)
    if not data then return end
    if type(data) == "string" then
        img.Image = data
    elseif type(data) == "number" then
        img.Image = "rbxassetid://" .. tostring(data)
    elseif type(data) == "table" then
        if data.Image then
            img.Image = data.Image
        elseif data.id then
            img.Image = "rbxassetid://" .. tostring(data.id)
        end
        if data.ImageRectOffset then
            img.ImageRectOffset = Vector2.new(
                data.ImageRectOffset[1] or 0,
                data.ImageRectOffset[2] or 0
            )
        end
        if data.ImageRectSize then
            img.ImageRectSize = Vector2.new(
                data.ImageRectSize[1] or 0,
                data.ImageRectSize[2] or 0
            )
        end
    end
end

local TooltipFrame
local function ShowTooltip(text, posX, posY)
    if not TooltipFrame then
        local gui = SetupGui()
        TooltipFrame = C("Frame", {
            Name = "WTooltip",
            Size = UDim2.new(0, 0, 0, 26),
            BackgroundColor3 = T.Bg2,
            BackgroundTransparency = 0.05,
            ZIndex = 300,
            Visible = false,
            AutomaticSize = Enum.AutomaticSize.X,
            Parent = gui
        })
        Cn(TooltipFrame, 6)
        local tts = St(TooltipFrame, T.Border, 1, 0.3)
        B(TooltipFrame, {BackgroundColor3 = "Bg2"})
        B(tts, {Color = "Border"})
        local lbl = C("TextLabel", {
            Name = "Lbl",
            Size = UDim2.new(0, 0, 1, 0),
            BackgroundTransparency = 1,
            Text = "",
            TextColor3 = T.Txt,
            TextSize = 11,
            Font = Enum.Font.Gotham,
            AutomaticSize = Enum.AutomaticSize.X,
            ZIndex = 301,
            Parent = TooltipFrame
        })
        Pd(lbl, 0, 0, 8, 8)
        B(lbl, {TextColor3 = "Txt"})
    end
    local lbl = TooltipFrame:FindFirstChild("Lbl")
    if lbl then lbl.Text = text end
    TooltipFrame.Position = UDim2.new(0, posX + 14, 0, posY + 14)
    TooltipFrame.Visible = true
end

local function HideTooltip()
    if TooltipFrame then
        TooltipFrame.Visible = false
    end
end

local function AttachTooltip(element, text)
    if not text or text == "" then return end
    element.MouseEnter:Connect(function()
        local mouse = Player:GetMouse()
        ShowTooltip(text, mouse.X, mouse.Y)
    end)
    element.MouseLeave:Connect(function()
        HideTooltip()
    end)
end
local SaveMgr = {
    Folder = "Wraith",
    CfgFolder = "Wraith/configs"
}

function SaveMgr:Ensure()
    EnsF()
end

function SaveMgr:Save(name)
    self:Ensure()
    local data = {}
    for flag, element in pairs(WraithFlags) do
        if type(element) == "table" and element.Save ~= false then
            if element.Type == "Colorpicker" then
                data[flag] = {
                    R = element.Value.R,
                    G = element.Value.G,
                    B = element.Value.B
                }
            elseif element.Type == "Keybind" then
                data[flag] = element.Value and element.Value.Name or nil
            else
                data[flag] = element.Value
            end
        end
    end
    pcall(function()
        writefile(
            self.CfgFolder .. "/" .. name .. ".json",
            HttpService:JSONEncode(data)
        )
    end)
end

function SaveMgr:Load(name)
    self:Ensure()
    local success, content = pcall(function()
        return readfile(self.CfgFolder .. "/" .. name .. ".json")
    end)
    if success and content then
        local ok, data = pcall(function()
            return HttpService:JSONDecode(content)
        end)
        if ok and data then
            for flag, value in pairs(data) do
                if WraithFlags[flag] and WraithFlags[flag].Set then
                    pcall(function()
                        if WraithFlags[flag].Type == "Colorpicker" and type(value) == "table" then
                            WraithFlags[flag]:Set(Color3.new(value.R, value.G, value.B))
                        elseif WraithFlags[flag].Type == "Keybind" and type(value) == "string" then
                            WraithFlags[flag]:Set(Enum.KeyCode[value])
                        else
                            WraithFlags[flag]:Set(value)
                        end
                    end)
                end
            end
        end
    end
end

function SaveMgr:Delete(name)
    pcall(function()
        delfile(self.CfgFolder .. "/" .. name .. ".json")
    end)
end

function SaveMgr:GetConfigs()
    self:Ensure()
    local configs = {}
    pcall(function()
        local files = listfiles(self.CfgFolder)
        for _, file in ipairs(files) do
            local fileName = file:match("([^/\\]+)$")
            if fileName and fileName:match("%.json$") then
                table.insert(configs, fileName:gsub("%.json$", ""))
            end
        end
    end)
    return configs
end

Wraith.SaveManager = SaveMgr
Wraith.Flags = WraithFlags
Wraith.Themes = Themes
Wraith.LoadIcons = LoadIcons
Wraith.GetIcon = GetIcon
Wraith.IsMobile = IsMobile
Wraith.AnimPresets = AnimPresets

function Wraith:SetTheme(name)
    if Themes[name] then
        T = Themes[name]
        Apply()
        SaveThemePref(name)
    end
end

function Wraith:SetAnimation(name)
    if AnimPresets[name] then
        CurrentAnim = AnimPresets[name]
    end
end

function Wraith:GetAnimations()
    local list = {}
    for k in pairs(AnimPresets) do
        table.insert(list, k)
    end
    return list
end

function Wraith:GetThemes()
    local list = {}
    for k in pairs(Themes) do
        table.insert(list, k)
    end
    return list
end

function Wraith:AddTheme(name, themeData)
    if not name or not themeData then return false end
    Themes[name] = themeData
    pcall(function()
        EnsF()
        local saveData = {Name = name}
        for k, v in pairs(themeData) do
            if typeof(v) == "Color3" then
                saveData[k] = {R = v.R, G = v.G, B = v.B}
            elseif type(v) == "number" then
                saveData[k] = v
            end
        end
        writefile(
            "Wraith/themes/" .. name .. ".json",
            HttpService:JSONEncode(saveData)
        )
    end)
    return true
end

function Wraith:Notify(o)
    o = o or {}
    local gui = SetupGui()

    local holder = gui:FindFirstChild("WN")
    if not holder then
        holder = C("Frame", {
            Name = "WN",
            Size = UDim2.new(0, 300, 1, 0),
            Position = UDim2.new(1, -315, 0, 0),
            BackgroundTransparency = 1,
            Parent = gui
        })
        C("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 5),
            VerticalAlignment = Enum.VerticalAlignment.Bottom,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            Parent = holder
        })
        Pd(holder, 0, 14, 0, 0)
    end

    local notifs = {}
    for _, child in ipairs(holder:GetChildren()) do
        if child:IsA("Frame") then
            table.insert(notifs, child)
        end
    end
    if #notifs >= 5 then
        notifs[1]:Destroy()
    end

    local notifFrame = C("Frame", {
        Size = UDim2.new(1, 0, 0, 0),
        BackgroundColor3 = T.Bg2,
        BackgroundTransparency = 0.04,
        ClipsDescendants = true,
        Parent = holder
    })
    Cn(notifFrame, 10)
    local notifStroke = St(notifFrame, T.Border, 1, 0.3)
    B(notifFrame, {BackgroundColor3 = "Bg2"})
    B(notifStroke, {Color = "Border"})

    local notifContent = C("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Parent = notifFrame
    })
    Pd(notifContent, 10, 10, 12, 12)

    local notifTitle = C("TextLabel", {
        Size = UDim2.new(1, 0, 0, 16),
        BackgroundTransparency = 1,
        Text = o.Title or "Wraith",
        TextColor3 = T.Txt,
        TextSize = 13,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = notifContent
    })
    B(notifTitle, {TextColor3 = "Txt"})

    local notifBody = C("TextLabel", {
        Size = UDim2.new(1, 0, 0, 0),
        Position = UDim2.new(0, 0, 0, 18),
        BackgroundTransparency = 1,
        Text = o.Content or "",
        TextColor3 = T.Txt2,
        TextSize = 11,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true,
        AutomaticSize = Enum.AutomaticSize.Y,
        Parent = notifContent
    })
    B(notifBody, {TextColor3 = "Txt2"})

    local notifSub
    if (o.SubContent or "") ~= "" then
        notifSub = C("TextLabel", {
            Size = UDim2.new(1, 0, 0, 0),
            BackgroundTransparency = 1,
            Text = o.SubContent,
            TextColor3 = T.Txt3,
            TextSize = 10,
            Font = Enum.Font.Gotham,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextWrapped = true,
            AutomaticSize = Enum.AutomaticSize.Y,
            Parent = notifContent
        })
        B(notifSub, {TextColor3 = "Txt3"})
    end

    local progressContainer = C("Frame", {
        Size = UDim2.new(1, 0, 0, 2),
        Position = UDim2.new(0, 0, 1, -2),
        BackgroundTransparency = 1,
        ClipsDescendants = true,
        Parent = notifFrame
    })
    Cn(progressContainer, 1)

    local progressBar = C("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = T.Acc,
        BorderSizePixel = 0,
        Parent = progressContainer
    })
    B(progressBar, {BackgroundColor3 = "Acc"})

    local duration = o.Duration or 5
    task.defer(function()
        task.wait(0.05)
        local totalHeight = 18 + 18
        if notifBody then
            totalHeight = totalHeight + notifBody.AbsoluteSize.Y
        end
        if notifSub then
            totalHeight = totalHeight + notifSub.AbsoluteSize.Y + 3
            notifSub.Position = UDim2.new(0, 0, 0, 18 + notifBody.AbsoluteSize.Y + 2)
        end
        totalHeight = math.max(totalHeight, 48)
        Tw(notifFrame, {Size = UDim2.new(1, 0, 0, totalHeight)}, 0.3)
        Tw(progressBar, {Size = UDim2.new(0, 0, 1, 0)}, duration, Enum.EasingStyle.Linear)
        task.wait(duration)
        Tw(notifFrame, {Size = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1}, 0.3)
        task.wait(0.35)
        notifFrame:Destroy()
    end)
end

function Wraith:Dialog(o)
    o = o or {}
    local gui = SetupGui()

    local blocker = C("TextButton", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Color3.new(0, 0, 0),
        BackgroundTransparency = 0.4,
        ZIndex = 100,
        Text = "",
        AutoButtonColor = false,
        Modal = true,
        Parent = gui
    })

    local dialogFrame = C("Frame", {
        Size = UDim2.new(0, 360, 0, 0),
        Position = UDim2.new(0.5, -180, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundColor3 = T.Bg2,
        BackgroundTransparency = 0.02,
        ZIndex = 101,
        ClipsDescendants = true,
        Parent = gui
    })
    Cn(dialogFrame, 14)
    local dialogStroke = St(dialogFrame, T.Border, 1, 0.3)
    B(dialogFrame, {BackgroundColor3 = "Bg2"})
    B(dialogStroke, {Color = "Border"})

    local dialogContent = C("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        ZIndex = 102,
        Parent = dialogFrame
    })
    Pd(dialogContent, 20, 20, 20, 20)

    local dialogTitle = C("TextLabel", {
        Size = UDim2.new(1, 0, 0, 18),
        BackgroundTransparency = 1,
        Text = o.Title or "Dialog",
        TextColor3 = T.Txt,
        TextSize = 15,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 102,
        Parent = dialogContent
    })
    B(dialogTitle, {TextColor3 = "Txt"})

    local dialogText = C("TextLabel", {
        Size = UDim2.new(1, 0, 0, 0),
        Position = UDim2.new(0, 0, 0, 26),
        BackgroundTransparency = 1,
        Text = o.Content or "",
        TextColor3 = T.Txt2,
        TextSize = 12,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true,
        AutomaticSize = Enum.AutomaticSize.Y,
        ZIndex = 102,
        Parent = dialogContent
    })
    B(dialogText, {TextColor3 = "Txt2"})

    local buttonHolder = C("Frame", {
        Size = UDim2.new(1, 0, 0, 32),
        Position = UDim2.new(0, 0, 1, -32),
        BackgroundTransparency = 1,
        ZIndex = 102,
        Parent = dialogContent
    })
    C("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        Padding = UDim.new(0, 8),
        HorizontalAlignment = Enum.HorizontalAlignment.Right,
        Parent = buttonHolder
    })

    local event = Instance.new("BindableEvent")

    local function closeDialog()
        Tw(dialogFrame, {Size = UDim2.new(0, 360, 0, 0)}, 0.2)
        Tw(blocker, {BackgroundTransparency = 1}, 0.2)
        task.wait(0.25)
        dialogFrame:Destroy()
        blocker:Destroy()
    end

    for i, buttonData in ipairs(o.Buttons or {}) do
        local isPrimary = (i == #(o.Buttons or {}))
        local btn = C("TextButton", {
            Size = UDim2.new(0, 90, 0, 28),
            BackgroundColor3 = isPrimary and T.Acc or T.El,
            Text = buttonData.Title or "OK",
            TextColor3 = isPrimary and T.Bg or T.Txt,
            TextSize = 11,
            Font = Enum.Font.GothamSemibold,
            ZIndex = 103,
            AutoButtonColor = false,
            Parent = buttonHolder
        })
        Cn(btn, 7)
        if isPrimary then
            B(btn, {BackgroundColor3 = "Acc", TextColor3 = "Bg"})
        else
            B(btn, {BackgroundColor3 = "El", TextColor3 = "Txt"})
        end
        btn.MouseButton1Click:Connect(function()
            closeDialog()
            if buttonData.Callback then
                buttonData.Callback()
            end
            event:Fire(buttonData.Title)
        end)
    end

    task.defer(function()
        task.wait(0.05)
        local height = 26 + dialogText.AbsoluteSize.Y + 32 + 42 + 20
        Tw(dialogFrame, {
            Size = UDim2.new(0, 360, 0, math.max(height, 130))
        }, 0.3, Enum.EasingStyle.Back)
    end)

    return event.Event:Wait()
end

local function ColorDialog(currentColor, callback)
    local gui = SetupGui()
    local hue, sat, val = currentColor:ToHSV()
    local tempColor = currentColor

    local blocker = C("TextButton", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Color3.new(0, 0, 0),
        BackgroundTransparency = 0.45,
        ZIndex = 200,
        Text = "",
        AutoButtonColor = false,
        Modal = true,
        Parent = gui
    })

    local pickerFrame = C("Frame", {
        Size = UDim2.new(0, 300, 0, 0),
        Position = UDim2.new(0.5, -150, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundColor3 = T.Bg2,
        BackgroundTransparency = 0.02,
        ZIndex = 201,
        ClipsDescendants = true,
        Parent = gui
    })
    Cn(pickerFrame, 14)
    local pickerStroke = St(pickerFrame, T.Border, 1, 0.3)
    B(pickerFrame, {BackgroundColor3 = "Bg2"})
    B(pickerStroke, {Color = "Border"})

    local topBar = C("Frame", {
        Size = UDim2.new(1, 0, 0, 38),
        BackgroundColor3 = T.Bg2,
        ZIndex = 202,
        BorderSizePixel = 0,
        Parent = pickerFrame
    })
    Cn(topBar, 14)
    B(topBar, {BackgroundColor3 = "Bg2"})

    C("Frame", {
        Size = UDim2.new(1, 0, 0, 14),
        Position = UDim2.new(0, 0, 1, -14),
        BackgroundColor3 = T.Bg2,
        ZIndex = 202,
        BorderSizePixel = 0,
        Parent = topBar
    })

    C("TextLabel", {
        Size = UDim2.new(1, -16, 1, 0),
        Position = UDim2.new(0, 12, 0, 0),
        BackgroundTransparency = 1,
        Text = "Color Picker",
        TextColor3 = T.Txt,
        TextSize = 13,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 203,
        Parent = topBar
    })
    Drag(pickerFrame, topBar)

    local contentArea = C("Frame", {
        Size = UDim2.new(1, -24, 1, -50),
        Position = UDim2.new(0, 12, 0, 44),
        BackgroundTransparency = 1,
        ZIndex = 202,
        Parent = pickerFrame
    })

    local svArea = C("Frame", {
        Size = UDim2.new(1, -32, 0, 140),
        BackgroundColor3 = Color3.fromHSV(hue, 1, 1),
        ZIndex = 203,
        Parent = contentArea
    })
    Cn(svArea, 7)

    local whiteLayer = C("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Color3.new(1, 1, 1),
        ZIndex = 204,
        Parent = svArea
    })
    Cn(whiteLayer, 7)
    C("UIGradient", {
        Color = ColorSequence.new(Color3.new(1, 1, 1), Color3.new(1, 1, 1)),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0),
            NumberSequenceKeypoint.new(1, 1)
        }),
        Rotation = 0,
        Parent = whiteLayer
    })

    local blackLayer = C("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Color3.new(0, 0, 0),
        ZIndex = 205,
        Parent = svArea
    })
    Cn(blackLayer, 7)
    C("UIGradient", {
        Color = ColorSequence.new(Color3.new(0, 0, 0), Color3.new(0, 0, 0)),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(1, 0)
        }),
        Rotation = 90,
        Parent = blackLayer
    })

    local svCursor = C("Frame", {
        Size = UDim2.new(0, 14, 0, 14),
        Position = UDim2.new(sat, -7, 1 - val, -7),
        BackgroundColor3 = Color3.new(1, 1, 1),
        ZIndex = 208,
        Parent = svArea
    })
    Cn(svCursor, 7)
    St(svCursor, Color3.new(0, 0, 0), 2, 0.2)

    local hueBar = C("Frame", {
        Size = UDim2.new(0, 20, 0, 140),
        Position = UDim2.new(1, -20, 0, 0),
        BackgroundColor3 = Color3.new(1, 1, 1),
        ZIndex = 203,
        Parent = contentArea
    })
    Cn(hueBar, 6)
    C("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0.000, Color3.fromHSV(0.000, 1, 1)),
            ColorSequenceKeypoint.new(0.167, Color3.fromHSV(0.167, 1, 1)),
            ColorSequenceKeypoint.new(0.333, Color3.fromHSV(0.333, 1, 1)),
            ColorSequenceKeypoint.new(0.500, Color3.fromHSV(0.500, 1, 1)),
            ColorSequenceKeypoint.new(0.667, Color3.fromHSV(0.667, 1, 1)),
            ColorSequenceKeypoint.new(0.833, Color3.fromHSV(0.833, 1, 1)),
            ColorSequenceKeypoint.new(1.000, Color3.fromHSV(0.999, 1, 1))
        }),
        Rotation = 90,
        Parent = hueBar
    })

    local hueCursor = C("Frame", {
        Size = UDim2.new(1, 6, 0, 6),
        Position = UDim2.new(0, -3, hue, -3),
        BackgroundColor3 = Color3.new(1, 1, 1),
        ZIndex = 208,
        Parent = hueBar
    })
    Cn(hueCursor, 3)
    St(hueCursor, Color3.new(0, 0, 0), 1, 0.3)

    local previewRow = C("Frame", {
        Size = UDim2.new(1, 0, 0, 28),
        Position = UDim2.new(0, 0, 0, 148),
        BackgroundTransparency = 1,
        ZIndex = 203,
        Parent = contentArea
    })

    local previewBox = C("Frame", {
        Size = UDim2.new(0, 28, 0, 28),
        BackgroundColor3 = tempColor,
        ZIndex = 204,
        Parent = previewRow
    })
    Cn(previewBox, 6)

    local hexInput = C("TextBox", {
        Size = UDim2.new(1, -38, 0, 28),
        Position = UDim2.new(0, 36, 0, 0),
        BackgroundColor3 = T.Bg3,
        Text = "#" .. tempColor:ToHex():upper(),
        TextColor3 = T.Txt,
        TextSize = 11,
        Font = Enum.Font.GothamSemibold,
        ClearTextOnFocus = false,
        ZIndex = 204,
        Parent = previewRow
    })
    Cn(hexInput, 6)
    Pd(hexInput, 0, 0, 7, 7)
    B(hexInput, {BackgroundColor3 = "Bg3", TextColor3 = "Txt"})

    local buttonRow = C("Frame", {
        Size = UDim2.new(1, 0, 0, 30),
        Position = UDim2.new(0, 0, 0, 184),
        BackgroundTransparency = 1,
        ZIndex = 203,
        Parent = contentArea
    })
    C("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        Padding = UDim.new(0, 7),
        HorizontalAlignment = Enum.HorizontalAlignment.Right,
        Parent = buttonRow
    })

    local cancelBtn = C("TextButton", {
        Size = UDim2.new(0, 80, 0, 28),
        BackgroundColor3 = T.El,
        Text = "Cancel",
        TextColor3 = T.Txt,
        TextSize = 11,
        Font = Enum.Font.GothamSemibold,
        AutoButtonColor = false,
        ZIndex = 204,
        LayoutOrder = 1,
        Parent = buttonRow
    })
    Cn(cancelBtn, 7)
    B(cancelBtn, {BackgroundColor3 = "El", TextColor3 = "Txt"})

    local applyBtn = C("TextButton", {
        Size = UDim2.new(0, 80, 0, 28),
        BackgroundColor3 = T.Acc,
        Text = "Apply",
        TextColor3 = T.Bg,
        TextSize = 11,
        Font = Enum.Font.GothamSemibold,
        AutoButtonColor = false,
        ZIndex = 204,
        LayoutOrder = 2,
        Parent = buttonRow
    })
    Cn(applyBtn, 7)
    B(applyBtn, {BackgroundColor3 = "Acc", TextColor3 = "Bg"})

    local function updateColor()
        tempColor = Color3.fromHSV(
            math.clamp(hue, 0, 0.999),
            math.clamp(sat, 0, 1),
            math.clamp(val, 0, 1)
        )
        previewBox.BackgroundColor3 = tempColor
        svArea.BackgroundColor3 = Color3.fromHSV(math.clamp(hue, 0, 0.999), 1, 1)
        svCursor.Position = UDim2.new(
            math.clamp(sat, 0, 1), -7,
            math.clamp(1 - val, 0, 1), -7
        )
        hueCursor.Position = UDim2.new(0, -3, math.clamp(hue, 0, 0.999), -3)
        hexInput.Text = "#" .. tempColor:ToHex():upper()
    end

    local draggingSV = false
    local draggingH = false

    local svButton = C("TextButton", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "",
        ZIndex = 209,
        Parent = svArea
    })

    local hueButton = C("TextButton", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "",
        ZIndex = 209,
        Parent = hueBar
    })

    local function handleSVInput(input)
        local absPos = svArea.AbsolutePosition
        local absSize = svArea.AbsoluteSize
        if absSize.X > 0 and absSize.Y > 0 then
            sat = math.clamp(
                (input.Position.X - absPos.X) / absSize.X,
                0, 1
            )
            val = 1 - math.clamp(
                (input.Position.Y - absPos.Y) / absSize.Y,
                0, 1
            )
            updateColor()
        end
    end

    local function handleHueInput(input)
        local absPos = hueBar.AbsolutePosition
        local absSize = hueBar.AbsoluteSize
        if absSize.Y > 0 then
            hue = math.clamp(
                (input.Position.Y - absPos.Y) / absSize.Y,
                0, 0.999
            )
            updateColor()
        end
    end

    svButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            draggingSV = true
            handleSVInput(input)
        end
    end)

    svButton.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            draggingSV = false
        end
    end)

    hueButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            draggingH = true
            handleHueInput(input)
        end
    end)

    hueButton.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            draggingH = false
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch then
            if draggingSV then
                handleSVInput(input)
            elseif draggingH then
                handleHueInput(input)
            end
        end
    end)

    hexInput.FocusLost:Connect(function()
        local success, color = pcall(function()
            return Color3.fromHex("#" .. hexInput.Text:gsub("#", ""))
        end)
        if success and color then
            hue, sat, val = color:ToHSV()
            updateColor()
        else
            hexInput.Text = "#" .. tempColor:ToHex():upper()
        end
    end)

    local closed = false
    local function closePicker()
        if closed then return end
        closed = true
        Tw(pickerFrame, {Size = UDim2.new(0, 300, 0, 0)}, 0.2)
        Tw(blocker, {BackgroundTransparency = 1}, 0.2)
        task.wait(0.25)
        pickerFrame:Destroy()
        blocker:Destroy()
    end

    cancelBtn.MouseButton1Click:Connect(closePicker)
    applyBtn.MouseButton1Click:Connect(function()
        closePicker()
        callback(tempColor)
    end)

    task.defer(function()
        task.wait(0.05)
        Tw(pickerFrame, {
            Size = UDim2.new(0, 300, 0, 290)
        }, 0.3, Enum.EasingStyle.Back)
    end)
end

function Wraith:OpenThemeEditor()
    local gui = SetupGui()

    local blocker = C("TextButton", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Color3.new(0, 0, 0),
        BackgroundTransparency = 0.4,
        ZIndex = 150,
        Text = "",
        AutoButtonColor = false,
        Modal = true,
        Parent = gui
    })

    local editorFrame = C("Frame", {
        Size = UDim2.new(0, 420, 0, 0),
        Position = UDim2.new(0.5, -210, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundColor3 = T.Bg2,
        BackgroundTransparency = 0.02,
        ZIndex = 151,
        ClipsDescendants = true,
        Parent = gui
    })
    Cn(editorFrame, 14)
    local editorStroke = St(editorFrame, T.Border, 1, 0.3)
    B(editorFrame, {BackgroundColor3 = "Bg2"})
    B(editorStroke, {Color = "Border"})

    local editorTopBar = C("Frame", {
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = T.Bg2,
        ZIndex = 152,
        BorderSizePixel = 0,
        Parent = editorFrame
    })
    Cn(editorTopBar, 14)
    B(editorTopBar, {BackgroundColor3 = "Bg2"})

    C("Frame", {
        Size = UDim2.new(1, 0, 0, 14),
        Position = UDim2.new(0, 0, 1, -14),
        BackgroundColor3 = T.Bg2,
        ZIndex = 152,
        BorderSizePixel = 0,
        Parent = editorTopBar
    })

    C("TextLabel", {
        Size = UDim2.new(1, -50, 1, 0),
        Position = UDim2.new(0, 14, 0, 0),
        BackgroundTransparency = 1,
        Text = "Theme Editor",
        TextColor3 = T.Txt,
        TextSize = 14,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 153,
        Parent = editorTopBar
    })
    Drag(editorFrame, editorTopBar)

    local closeEditorBtn = C("TextButton", {
        Size = UDim2.new(0, 26, 0, 26),
        Position = UDim2.new(1, -34, 0, 7),
        BackgroundColor3 = T.El,
        BackgroundTransparency = 0.15,
        Text = "",
        AutoButtonColor = false,
        ZIndex = 154,
        Parent = editorTopBar
    })
    Cn(closeEditorBtn, 7)
    C("Frame", {
        Size = UDim2.new(0, 10, 0, 2),
        Position = UDim2.new(0.5, -5, 0.5, -1),
        BackgroundColor3 = T.Txt2,
        Rotation = 45,
        ZIndex = 155,
        Parent = closeEditorBtn
    })
    C("Frame", {
        Size = UDim2.new(0, 10, 0, 2),
        Position = UDim2.new(0.5, -5, 0.5, -1),
        BackgroundColor3 = T.Txt2,
        Rotation = -45,
        ZIndex = 155,
        Parent = closeEditorBtn
    })

    local editorScroll = C("ScrollingFrame", {
        Size = UDim2.new(1, -20, 1, -100),
        Position = UDim2.new(0, 10, 0, 46),
        BackgroundTransparency = 1,
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = T.Border,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ZIndex = 152,
        Parent = editorFrame
    })
    C("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 4),
        Parent = editorScroll
    })

    local nameInput = C("TextBox", {
        Size = UDim2.new(1, 0, 0, 28),
        BackgroundColor3 = T.Bg3,
        Text = "My Theme",
        PlaceholderText = "Theme name...",
        PlaceholderColor3 = T.Txt3,
        TextColor3 = T.Txt,
        TextSize = 11,
        Font = Enum.Font.GothamSemibold,
        ClearTextOnFocus = false,
        ZIndex = 153,
        Parent = editorScroll
    })
    Cn(nameInput, 6)
    Pd(nameInput, 0, 0, 8, 8)

    local themeColors = {}
    local colorKeys = {
        "Bg", "Bg2", "Bg3", "El", "ElHov", "Border",
        "Txt", "Txt2", "Txt3", "Acc", "AccD",
        "TOn", "TOff", "Slider"
    }
    local colorLabels = {
        Bg = "Background",
        Bg2 = "Secondary BG",
        Bg3 = "Tertiary BG",
        El = "Element",
        ElHov = "Element Hover",
        Border = "Border",
        Txt = "Text Primary",
        Txt2 = "Text Secondary",
        Txt3 = "Text Muted",
        Acc = "Accent",
        AccD = "Accent Dark",
        TOn = "Toggle On",
        TOff = "Toggle Off",
        Slider = "Slider Fill"
    }

    for _, key in ipairs(colorKeys) do
        themeColors[key] = T[key]

        local row = C("Frame", {
            Size = UDim2.new(1, 0, 0, 30),
            BackgroundTransparency = 1,
            ZIndex = 153,
            Parent = editorScroll
        })

        C("TextLabel", {
            Size = UDim2.new(1, -40, 1, 0),
            Position = UDim2.new(0, 4, 0, 0),
            BackgroundTransparency = 1,
            Text = colorLabels[key] or key,
            TextColor3 = T.Txt2,
            TextSize = 11,
            Font = Enum.Font.Gotham,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 153,
            Parent = row
        })

        local colorBtn = C("TextButton", {
            Size = UDim2.new(0, 28, 0, 20),
            Position = UDim2.new(1, -32, 0, 5),
            BackgroundColor3 = themeColors[key],
            Text = "",
            AutoButtonColor = false,
            ZIndex = 154,
            Parent = row
        })
        Cn(colorBtn, 5)
        St(colorBtn, T.Border, 1, 0.4)

        colorBtn.MouseButton1Click:Connect(function()
            ColorDialog(themeColors[key], function(newColor)
                themeColors[key] = newColor
                colorBtn.BackgroundColor3 = newColor
            end)
        end)
    end

    local numberValues = {}
    local numberKeys = {"BgTr", "ElTr", "SbTr"}
    local numberLabels = {
        BgTr = "BG Transparency",
        ElTr = "Element Transparency",
        SbTr = "Sidebar Transparency"
    }

    for _, key in ipairs(numberKeys) do
        numberValues[key] = T[key]

        local row = C("Frame", {
            Size = UDim2.new(1, 0, 0, 30),
            BackgroundTransparency = 1,
            ZIndex = 153,
            Parent = editorScroll
        })

        C("TextLabel", {
            Size = UDim2.new(1, -60, 1, 0),
            Position = UDim2.new(0, 4, 0, 0),
            BackgroundTransparency = 1,
            Text = numberLabels[key] or key,
            TextColor3 = T.Txt2,
            TextSize = 11,
            Font = Enum.Font.Gotham,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 153,
            Parent = row
        })

        local valInput = C("TextBox", {
            Size = UDim2.new(0, 50, 0, 22),
            Position = UDim2.new(1, -54, 0, 4),
            BackgroundColor3 = T.Bg3,
            Text = tostring(numberValues[key]),
            TextColor3 = T.Txt,
            TextSize = 10,
            Font = Enum.Font.GothamSemibold,
            ClearTextOnFocus = true,
            ZIndex = 154,
            Parent = row
        })
        Cn(valInput, 4)

        valInput.FocusLost:Connect(function()
            local num = tonumber(valInput.Text)
            if num then
                numberValues[key] = math.clamp(num, 0, 1)
                valInput.Text = tostring(numberValues[key])
            else
                valInput.Text = tostring(numberValues[key])
            end
        end)
    end

    local bottomBar = C("Frame", {
        Size = UDim2.new(1, -20, 0, 40),
        Position = UDim2.new(0, 10, 1, -48),
        BackgroundTransparency = 1,
        ZIndex = 152,
        Parent = editorFrame
    })
    C("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        Padding = UDim.new(0, 8),
        HorizontalAlignment = Enum.HorizontalAlignment.Right,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        Parent = bottomBar
    })

    local previewBtn = C("TextButton", {
        Size = UDim2.new(0, 80, 0, 30),
        BackgroundColor3 = T.El,
        Text = "Preview",
        TextColor3 = T.Txt,
        TextSize = 11,
        Font = Enum.Font.GothamSemibold,
        AutoButtonColor = false,
        ZIndex = 153,
        LayoutOrder = 1,
        Parent = bottomBar
    })
    Cn(previewBtn, 7)
    B(previewBtn, {BackgroundColor3 = "El", TextColor3 = "Txt"})

    local saveEditorBtn = C("TextButton", {
        Size = UDim2.new(0, 80, 0, 30),
        BackgroundColor3 = T.Acc,
        Text = "Save",
        TextColor3 = T.Bg,
        TextSize = 11,
        Font = Enum.Font.GothamSemibold,
        AutoButtonColor = false,
        ZIndex = 153,
        LayoutOrder = 2,
        Parent = bottomBar
    })
    Cn(saveEditorBtn, 7)
    B(saveEditorBtn, {BackgroundColor3 = "Acc", TextColor3 = "Bg"})

    local function buildTheme()
        local theme = {}
        for k, v in pairs(themeColors) do
            theme[k] = v
        end
        for k, v in pairs(numberValues) do
            theme[k] = v
        end
        return theme
    end

    previewBtn.MouseButton1Click:Connect(function()
        local theme = buildTheme()
        Themes["_preview_"] = theme
        T = theme
        Apply()
    end)

    saveEditorBtn.MouseButton1Click:Connect(function()
        local themeName = nameInput.Text
        if themeName == "" then
            themeName = "Custom Theme"
        end
        local theme = buildTheme()
        Wraith:AddTheme(themeName, theme)
        Wraith:SetTheme(themeName)
        Wraith:Notify({
            Title = "Theme Saved",
            Content = "Theme '" .. themeName .. "' saved.",
            Duration = 3
        })
    end)

    local function closeEditor()
        Tw(editorFrame, {Size = UDim2.new(0, 420, 0, 0)}, 0.2)
        Tw(blocker, {BackgroundTransparency = 1}, 0.2)
        task.wait(0.25)
        editorFrame:Destroy()
        blocker:Destroy()
        if Themes["_preview_"] then
            Themes["_preview_"] = nil
        end
    end

    closeEditorBtn.MouseButton1Click:Connect(closeEditor)

    task.defer(function()
        task.wait(0.05)
        Tw(editorFrame, {
            Size = UDim2.new(0, 420, 0, 480)
        }, 0.3, Enum.EasingStyle.Back)
    end)
end
function Wraith:CreateWindow(o)
    o = o or {}
    local windowTitle = o.Title or "Wraith"
    local windowSubTitle = o.SubTitle or ""
    local windowSize = o.Size or UDim2.new(0, 630, 0, 370)
    local minimizeKey = o.MinimizeKey or Enum.KeyCode.LeftControl
    local tabWidth = o.TabWidth or 170
    local minSize = o.MinSize or Vector2.new(450, 280)
    local resizable = o.Resizable ~= false
    local searchable = o.Searchable ~= false
    local gui = SetupGui()

    local W = {
        Tabs = {},
        ActiveTab = nil,
        Vis = true,
        Min = false,
        Gui = gui,
        CurrentSize = windowSize
    }

    local main = C("Frame", {
        Name = "WM",
        Size = windowSize,
        Position = UDim2.new(
            0.5, -(windowSize.X.Offset / 2),
            0.5, -(windowSize.Y.Offset / 2)
        ),
        BackgroundColor3 = T.Bg,
        BackgroundTransparency = T.BgTr,
        ClipsDescendants = true,
        Parent = gui
    })
    Cn(main, 14)
    local mainStroke = St(main, T.Border, 1, 0.2)
    B(main, {BackgroundColor3 = "Bg", BackgroundTransparency = "BgTr"})
    B(mainStroke, {Color = "Border"})

    local topBar = C("Frame", {
        Size = UDim2.new(1, 0, 0, 48),
        BackgroundColor3 = T.Bg2,
        BackgroundTransparency = 0.05,
        BorderSizePixel = 0,
        ZIndex = 3,
        Parent = main
    })
    Cn(topBar, 14)
    B(topBar, {BackgroundColor3 = "Bg2"})

    local topBarFix = C("Frame", {
        Size = UDim2.new(1, 0, 0, 14),
        Position = UDim2.new(0, 0, 1, -14),
        BackgroundColor3 = T.Bg2,
        BackgroundTransparency = 0.05,
        BorderSizePixel = 0,
        ZIndex = 3,
        Parent = topBar
    })
    B(topBarFix, {BackgroundColor3 = "Bg2"})

    local logoBg = C("Frame", {
        Size = UDim2.new(0, 32, 0, 32),
        Position = UDim2.new(0, 10, 0, 8),
        BackgroundColor3 = T.El,
        BackgroundTransparency = 0.15,
        ZIndex = 4,
        Parent = topBar
    })
    Cn(logoBg, 8)
    B(logoBg, {BackgroundColor3 = "El"})

    local logoText = C("TextLabel", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "W",
        TextColor3 = T.Txt,
        TextSize = 18,
        Font = Enum.Font.GothamBold,
        ZIndex = 5,
        Parent = logoBg
    })
    B(logoText, {TextColor3 = "Txt"})

    local titleYPos = windowSubTitle ~= "" and 8 or 15

    local titleLabel = C("TextLabel", {
        Size = UDim2.new(0, 200, 0, 18),
        Position = UDim2.new(0, 50, 0, titleYPos),
        BackgroundTransparency = 1,
        Text = windowTitle,
        TextColor3 = T.Txt,
        TextSize = 14,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 4,
        Parent = topBar
    })
    B(titleLabel, {TextColor3 = "Txt"})

    if windowSubTitle ~= "" then
        local subLabel = C("TextLabel", {
            Size = UDim2.new(0, 200, 0, 12),
            Position = UDim2.new(0, 50, 0, 27),
            BackgroundTransparency = 1,
            Text = windowSubTitle,
            TextColor3 = T.Txt3,
            TextSize = 10,
            Font = Enum.Font.Gotham,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 4,
            Parent = topBar
        })
        B(subLabel, {TextColor3 = "Txt3"})
    end

    local controlsFrame = C("Frame", {
        Size = UDim2.new(0, 66, 0, 26),
        Position = UDim2.new(1, -78, 0, 11),
        BackgroundTransparency = 1,
        ZIndex = 4,
        Parent = topBar
    })
    C("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        Padding = UDim.new(0, 5),
        HorizontalAlignment = Enum.HorizontalAlignment.Right,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        Parent = controlsFrame
    })

    local minBtn = C("TextButton", {
        Size = UDim2.new(0, 26, 0, 26),
        BackgroundColor3 = T.El,
        BackgroundTransparency = 0.15,
        Text = "",
        AutoButtonColor = false,
        LayoutOrder = 1,
        ZIndex = 5,
        Parent = controlsFrame
    })
    Cn(minBtn, 7)
    B(minBtn, {BackgroundColor3 = "El"})
    C("Frame", {
        Size = UDim2.new(0, 10, 0, 2),
        Position = UDim2.new(0.5, -5, 0.5, -1),
        BackgroundColor3 = T.Txt2,
        BorderSizePixel = 0,
        ZIndex = 6,
        Parent = minBtn
    })

    local closeBtn = C("TextButton", {
        Size = UDim2.new(0, 26, 0, 26),
        BackgroundColor3 = T.El,
        BackgroundTransparency = 0.15,
        Text = "",
        AutoButtonColor = false,
        LayoutOrder = 2,
        ZIndex = 5,
        Parent = controlsFrame
    })
    Cn(closeBtn, 7)
    B(closeBtn, {BackgroundColor3 = "El"})
    C("Frame", {
        Size = UDim2.new(0, 10, 0, 2),
        Position = UDim2.new(0.5, -5, 0.5, -1),
        BackgroundColor3 = T.Txt2,
        Rotation = 45,
        ZIndex = 6,
        Parent = closeBtn
    })
    C("Frame", {
        Size = UDim2.new(0, 10, 0, 2),
        Position = UDim2.new(0.5, -5, 0.5, -1),
        BackgroundColor3 = T.Txt2,
        Rotation = -45,
        ZIndex = 6,
        Parent = closeBtn
    })

    minBtn.MouseEnter:Connect(function()
        Tw(minBtn, {BackgroundTransparency = 0}, 0.1)
    end)
    minBtn.MouseLeave:Connect(function()
        Tw(minBtn, {BackgroundTransparency = 0.15}, 0.1)
    end)
    closeBtn.MouseEnter:Connect(function()
        Tw(closeBtn, {
            BackgroundColor3 = Color3.fromRGB(170, 42, 42),
            BackgroundTransparency = 0
        }, 0.1)
    end)
    closeBtn.MouseLeave:Connect(function()
        Tw(closeBtn, {
            BackgroundColor3 = T.El,
            BackgroundTransparency = 0.15
        }, 0.1)
    end)

    local floatBtn
    if IsMobile then
        floatBtn = C("ImageButton", {
            Name = "WFloat",
            Size = UDim2.new(0, 46, 0, 46),
            Position = UDim2.new(0, 16, 0.5, -23),
            BackgroundColor3 = T.Bg2,
            BackgroundTransparency = 0.05,
            Image = "",
            AutoButtonColor = false,
            Visible = false,
            ZIndex = 50,
            Parent = gui
        })
        Cn(floatBtn, 12)
        local fStroke = St(floatBtn, T.Border, 1, 0.3)
        B(floatBtn, {BackgroundColor3 = "Bg2"})
        B(fStroke, {Color = "Border"})
        C("TextLabel", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Text = "W",
            TextColor3 = T.Txt,
            TextSize = 22,
            Font = Enum.Font.GothamBold,
            ZIndex = 51,
            Parent = floatBtn
        })
        Drag(floatBtn)
    end

    local function showWindow()
        W.Vis = true
        W.Min = false
        main.Visible = true
        if floatBtn then floatBtn.Visible = false end
        main.Size = UDim2.new(0, W.CurrentSize.X.Offset, 0, 0)
        main.BackgroundTransparency = 1
        Tw(main, {
            Size = W.CurrentSize,
            BackgroundTransparency = T.BgTr
        }, 0.4, Enum.EasingStyle.Back)
    end

    local function hideWindow()
        W.Vis = false
        Tw(main, {
            Size = UDim2.new(0, W.CurrentSize.X.Offset, 0, 0),
            BackgroundTransparency = 1
        }, 0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
        task.wait(0.45)
        main.Visible = false
    end

    local function minimizeWindow()
        W.Min = true
        W.Vis = false
        Tw(main, {
            Size = UDim2.new(0, W.CurrentSize.X.Offset, 0, 0),
            BackgroundTransparency = 1
        }, 0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
        task.wait(0.42)
        main.Visible = false
        if floatBtn then
            floatBtn.Visible = true
            floatBtn.Size = UDim2.new(0, 0, 0, 0)
            Tw(floatBtn, {
                Size = UDim2.new(0, 46, 0, 46)
            }, 0.3, Enum.EasingStyle.Back)
        end
    end

    minBtn.MouseButton1Click:Connect(minimizeWindow)
    closeBtn.MouseButton1Click:Connect(hideWindow)
    if floatBtn then
        floatBtn.MouseButton1Click:Connect(function()
            Tw(floatBtn, {
                Size = UDim2.new(0, 0, 0, 0)
            }, 0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
            task.wait(0.27)
            floatBtn.Visible = false
            showWindow()
        end)
    end
    Drag(main, topBar)

    if resizable then
        local resizeHandle = C("Frame", {
            Size = UDim2.new(0, 18, 0, 18),
            Position = UDim2.new(1, -18, 1, -18),
            BackgroundTransparency = 1,
            ZIndex = 10,
            Parent = main
        })

        local resizeLine1 = C("Frame", {
            Size = UDim2.new(0, 10, 0, 1),
            Position = UDim2.new(1, -4, 1, -4),
            AnchorPoint = Vector2.new(1, 1),
            BackgroundColor3 = T.Txt3,
            BackgroundTransparency = 0.3,
            BorderSizePixel = 0,
            Rotation = -45,
            ZIndex = 11,
            Parent = resizeHandle
        })
        B(resizeLine1, {BackgroundColor3 = "Txt3"})

        local resizeLine2 = C("Frame", {
            Size = UDim2.new(0, 6, 0, 1),
            Position = UDim2.new(1, -4, 1, -8),
            AnchorPoint = Vector2.new(1, 1),
            BackgroundColor3 = T.Txt3,
            BackgroundTransparency = 0.3,
            BorderSizePixel = 0,
            Rotation = -45,
            ZIndex = 11,
            Parent = resizeHandle
        })
        B(resizeLine2, {BackgroundColor3 = "Txt3"})

        local resizeLine3 = C("Frame", {
            Size = UDim2.new(0, 6, 0, 1),
            Position = UDim2.new(1, -8, 1, -4),
            AnchorPoint = Vector2.new(1, 1),
            BackgroundColor3 = T.Txt3,
            BackgroundTransparency = 0.3,
            BorderSizePixel = 0,
            Rotation = -45,
            ZIndex = 11,
            Parent = resizeHandle
        })
        B(resizeLine3, {BackgroundColor3 = "Txt3"})

        local resizeBtn = C("TextButton", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Text = "",
            AutoButtonColor = false,
            ZIndex = 12,
            Parent = resizeHandle
        })

        local resizing = false
        local startSize = nil
        local startPos = nil

        resizeBtn.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1
                or input.UserInputType == Enum.UserInputType.Touch then
                resizing = true
                startSize = main.AbsoluteSize
                startPos = input.Position
            end
        end)
        resizeBtn.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1
                or input.UserInputType == Enum.UserInputType.Touch then
                resizing = false
            end
        end)
        UIS.InputChanged:Connect(function(input)
            if resizing and (
                input.UserInputType == Enum.UserInputType.MouseMovement
                or input.UserInputType == Enum.UserInputType.Touch
            ) then
                local delta = input.Position - startPos
                local newW = math.max(minSize.X, startSize.X + delta.X)
                local newH = math.max(minSize.Y, startSize.Y + delta.Y)
                main.Size = UDim2.new(0, newW, 0, newH)
                W.CurrentSize = UDim2.new(0, newW, 0, newH)
            end
        end)

        resizeHandle.MouseEnter:Connect(function()
            Tw(resizeLine1, {BackgroundTransparency = 0}, 0.12)
            Tw(resizeLine2, {BackgroundTransparency = 0}, 0.12)
            Tw(resizeLine3, {BackgroundTransparency = 0}, 0.12)
        end)
        resizeHandle.MouseLeave:Connect(function()
            Tw(resizeLine1, {BackgroundTransparency = 0.3}, 0.12)
            Tw(resizeLine2, {BackgroundTransparency = 0.3}, 0.12)
            Tw(resizeLine3, {BackgroundTransparency = 0.3}, 0.12)
        end)
    end

    local contentArea = C("Frame", {
        Size = UDim2.new(1, 0, 1, -48),
        Position = UDim2.new(0, 0, 0, 48),
        BackgroundTransparency = 1,
        ClipsDescendants = true,
        Parent = main
    })

    local sideBar = C("Frame", {
        Size = UDim2.new(0, tabWidth, 1, 0),
        BackgroundColor3 = T.Bg2,
        BackgroundTransparency = T.SbTr,
        BorderSizePixel = 0,
        Parent = contentArea
    })
    Cn(sideBar, 14)
    B(sideBar, {BackgroundColor3 = "Bg2", BackgroundTransparency = "SbTr"})

    local sbRight = C("Frame", {
        Position = UDim2.new(1, -14, 0, 0),
        Size = UDim2.new(0, 14, 1, 0),
        BackgroundColor3 = T.Bg2,
        BackgroundTransparency = T.SbTr,
        BorderSizePixel = 0,
        Parent = sideBar
    })
    B(sbRight, {BackgroundColor3 = "Bg2", BackgroundTransparency = "SbTr"})

    local sbTop = C("Frame", {
        Size = UDim2.new(1, 0, 0, 14),
        BackgroundColor3 = T.Bg2,
        BackgroundTransparency = T.SbTr,
        BorderSizePixel = 0,
        Parent = sideBar
    })
    B(sbTop, {BackgroundColor3 = "Bg2", BackgroundTransparency = "SbTr"})

    local sbDiv = C("Frame", {
        Size = UDim2.new(0, 1, 1, 0),
        Position = UDim2.new(1, 0, 0, 0),
        BackgroundColor3 = T.Border,
        BackgroundTransparency = 0.6,
        BorderSizePixel = 0,
        Parent = sideBar
    })
    B(sbDiv, {BackgroundColor3 = "Border"})

    local searchHeight = searchable and 36 or 0
    if searchable then
        local searchBox = C("TextBox", {
            Size = UDim2.new(1, -12, 0, 28),
            Position = UDim2.new(0, 6, 0, 4),
            BackgroundColor3 = T.Bg3,
            Text = "",
            PlaceholderText = "Search...",
            PlaceholderColor3 = T.Txt3,
            TextColor3 = T.Txt,
            TextSize = 11,
            Font = Enum.Font.Gotham,
            ClearTextOnFocus = false,
            Parent = sideBar
        })
        Cn(searchBox, 6)
        Pd(searchBox, 0, 0, 8, 8)
        local sStroke = St(searchBox, T.Border, 1, 0.5)
        B(searchBox, {BackgroundColor3 = "Bg3", TextColor3 = "Txt", PlaceholderColor3 = "Txt3"})
        B(sStroke, {Color = "Border"})

        searchBox:GetPropertyChangedSignal("Text"):Connect(function()
            local query = searchBox.Text:lower()
            for _, el in ipairs(SearchableElements) do
                if el.Frame and el.Frame.Parent then
                    if query == "" then
                        el.Frame.Visible = true
                    else
                        local visible = false
                        if el.Title and el.Title:lower():find(query, 1, true) then
                            visible = true
                        end
                        if not visible and el.Description
                            and el.Description:lower():find(query, 1, true) then
                            visible = true
                        end
                        el.Frame.Visible = visible
                    end
                end
            end
        end)
    end

    local tabList = C("ScrollingFrame", {
        Size = UDim2.new(1, -12, 1, -(12 + searchHeight)),
        Position = UDim2.new(0, 6, 0, 6 + searchHeight),
        BackgroundTransparency = 1,
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = T.Border,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Parent = sideBar
    })
    C("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 3),
        Parent = tabList
    })

    local pageHolder = C("Frame", {
        Size = UDim2.new(1, -tabWidth, 1, 0),
        Position = UDim2.new(0, tabWidth, 0, 0),
        BackgroundTransparency = 1,
        ClipsDescendants = true,
        Parent = contentArea
    })

    UIS.InputBegan:Connect(function(input, gp)
        if gp then return end
        if input.KeyCode == minimizeKey then
            if W.Vis then
                hideWindow()
            else
                if floatBtn and floatBtn.Visible then
                    floatBtn.Visible = false
                end
                showWindow()
            end
        end
    end)

    function W:SelectTab(tab)
        if self.ActiveTab == tab then return end
        if self.ActiveTab then
            self.ActiveTab._sel = false
            Tw(self.ActiveTab.Btn, {BackgroundColor3 = T.Bg2, BackgroundTransparency = 1}, 0.2)
            Tw(self.ActiveTab.Lbl, {TextColor3 = T.Txt2}, 0.2)
            if self.ActiveTab.Ico then Tw(self.ActiveTab.Ico, {ImageColor3 = T.Txt2}, 0.2) end
            if self.ActiveTab.Ind then Tw(self.ActiveTab.Ind, {BackgroundTransparency = 1}, 0.15) end
            self.ActiveTab.Pg.Visible = false
        end
        self.ActiveTab = tab
        tab._sel = true
        Tw(tab.Btn, {BackgroundColor3 = T.El, BackgroundTransparency = T.ElTr * 0.5}, 0.2)
        Tw(tab.Lbl, {TextColor3 = T.Txt}, 0.2)
        if tab.Ico then Tw(tab.Ico, {ImageColor3 = T.Txt}, 0.2) end
        if tab.Ind then Tw(tab.Ind, {BackgroundTransparency = 0}, 0.15) end
        tab.Pg.Visible = true
    end

    function W:AddTab(tabOpts)
        tabOpts = tabOpts or {}
        local tabName = tabOpts.Title or "Tab"
        local tabIcon = tabOpts.Icon
        local tab = {Name = tabName, _sel = false}

        local tabBtn = C("TextButton", {
            Size = UDim2.new(1, 0, 0, 34),
            BackgroundColor3 = T.Bg2,
            BackgroundTransparency = 1,
            Text = "",
            AutoButtonColor = false,
            Parent = tabList
        })
        Cn(tabBtn, 7)

        local tabInd = C("Frame", {
            Size = UDim2.new(0, 3, 0, 16),
            Position = UDim2.new(0, 0, 0.5, -8),
            BackgroundColor3 = T.Acc,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Parent = tabBtn
        })
        Cn(tabInd, 2)
        B(tabInd, {BackgroundColor3 = "Acc"})
        tab.Ind = tabInd

        local iconOffset = 0
        if tabIcon and tabIcon ~= "" then
            local iconImg = C("ImageLabel", {
                Size = UDim2.new(0, 16, 0, 16),
                Position = UDim2.new(0, 11, 0.5, -8),
                BackgroundTransparency = 1,
                ImageColor3 = T.Txt2,
                Parent = tabBtn
            })
            ApplyIcon(iconImg, GetIcon(tabIcon))
            iconOffset = 32
            tab.Ico = iconImg
            B(iconImg, {ImageColor3 = "Txt2"})
        end

        local tabLabel = C("TextLabel", {
            Size = UDim2.new(1, -(10 + iconOffset), 0, 34),
            Position = UDim2.new(0, iconOffset + 12, 0, 0),
            BackgroundTransparency = 1,
            Text = tabName,
            TextColor3 = T.Txt2,
            TextSize = 12,
            Font = Enum.Font.GothamSemibold,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = tabBtn
        })
        tab.Btn = tabBtn
        tab.Lbl = tabLabel

        local function refreshTabColors()
            if tab._sel then
                Tw(tabBtn, {BackgroundColor3 = T.El, BackgroundTransparency = T.ElTr * 0.5}, 0.3)
                Tw(tabLabel, {TextColor3 = T.Txt}, 0.3)
                if tab.Ico then Tw(tab.Ico, {ImageColor3 = T.Txt}, 0.3) end
                if tabInd then Tw(tabInd, {BackgroundColor3 = T.Acc, BackgroundTransparency = 0}, 0.3) end
            else
                Tw(tabBtn, {BackgroundColor3 = T.Bg2, BackgroundTransparency = 1}, 0.3)
                Tw(tabLabel, {TextColor3 = T.Txt2}, 0.3)
                if tab.Ico then Tw(tab.Ico, {ImageColor3 = T.Txt2}, 0.3) end
                if tabInd then Tw(tabInd, {BackgroundColor3 = T.Acc, BackgroundTransparency = 1}, 0.3) end
            end
        end
        table.insert(TabRefreshers, {F = tabBtn, R = refreshTabColors})

        tabBtn.MouseEnter:Connect(function()
            if not tab._sel then Tw(tabBtn, {BackgroundTransparency = 0.45}, 0.1) end
        end)
        tabBtn.MouseLeave:Connect(function()
            if not tab._sel then Tw(tabBtn, {BackgroundTransparency = 1}, 0.1) end
        end)
        tabBtn.MouseButton1Click:Connect(function()
            self:SelectTab(tab)
        end)

        local page = C("ScrollingFrame", {
            Size = UDim2.new(1, -18, 1, -18),
            Position = UDim2.new(0, 9, 0, 9),
            BackgroundTransparency = 1,
            ScrollBarThickness = 2,
            ScrollBarImageColor3 = T.Border,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            Visible = false,
            Parent = pageHolder
        })
        C("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 6),
            Parent = page
        })
        tab.Pg = page
        table.insert(self.Tabs, tab)
        if #self.Tabs == 1 then self:SelectTab(tab) end

        local function makeContainer(targetParent, height)
            targetParent = targetParent or page
            local container = C("Frame", {
                Size = UDim2.new(1, 0, 0, height),
                BackgroundColor3 = T.El,
                BackgroundTransparency = T.ElTr,
                BorderSizePixel = 0,
                Parent = targetParent
            })
            Cn(container, 10)
            local cs = St(container, T.Border, 1, 0.4)
            B(container, {BackgroundColor3 = "El", BackgroundTransparency = "ElTr"})
            B(cs, {Color = "Border"})
            return container
        end

        local function regSearch(frame, title, desc)
            table.insert(SearchableElements, {Frame = frame, Title = title, Description = desc or ""})
        end

        local function resolveArgs(a, b)
            if type(a) == "string" and type(b) == "table" then
                b.Title = b.Title or a
                b.Flag = b.Flag or a
                return b
            elseif type(a) == "table" then
                return a
            else
                return {}
            end
        end
        local function createElements(targetParent)
            local E = {}

            function E:AddParagraph(a, b)
                local p = resolveArgs(a, b)
                local container = C("Frame", {
                    Size = UDim2.new(1, 0, 0, 0),
                    BackgroundColor3 = T.El,
                    BackgroundTransparency = T.ElTr,
                    AutomaticSize = Enum.AutomaticSize.Y,
                    BorderSizePixel = 0,
                    Parent = targetParent
                })
                Cn(container, 10)
                local cs = St(container, T.Border, 1, 0.4)
                Pd(container, 12, 12, 14, 14)
                B(container, {BackgroundColor3 = "El", BackgroundTransparency = "ElTr"})
                B(cs, {Color = "Border"})
                C("UIListLayout", {
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    Padding = UDim.new(0, 2),
                    Parent = container
                })
                local titleLbl
                if (p.Title or "") ~= "" then
                    titleLbl = C("TextLabel", {
                        Size = UDim2.new(1, 0, 0, 15),
                        BackgroundTransparency = 1,
                        Text = p.Title,
                        TextColor3 = T.Txt,
                        TextSize = 13,
                        Font = Enum.Font.GothamBold,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        Parent = container
                    })
                    B(titleLbl, {TextColor3 = "Txt"})
                end
                local contentLbl = C("TextLabel", {
                    Size = UDim2.new(1, 0, 0, 0),
                    BackgroundTransparency = 1,
                    Text = p.Content or "",
                    TextColor3 = T.Txt2,
                    TextSize = 11,
                    Font = Enum.Font.Gotham,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextWrapped = true,
                    AutomaticSize = Enum.AutomaticSize.Y,
                    Parent = container
                })
                B(contentLbl, {TextColor3 = "Txt2"})
                regSearch(container, p.Title or "", p.Content)
                if p.Tooltip then AttachTooltip(container, p.Tooltip) end
                local el = {Type = "Paragraph"}
                function el:Set(x)
                    if type(x) == "table" then
                        if x.Title and titleLbl then titleLbl.Text = x.Title end
                        if x.Content then contentLbl.Text = x.Content end
                    end
                end
                function el:SetTitle(txt)
                    if titleLbl then titleLbl.Text = txt end
                end
                function el:SetDesc(txt)
                    contentLbl.Text = txt
                end
                return el
            end

            function E:AddButton(a, b)
                local p = resolveArgs(a, b)
                local h = (p.Description or "") ~= "" and 52 or 38
                local container = makeContainer(targetParent, h)
                local btn = C("TextButton", {
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundTransparency = 1,
                    Text = "",
                    AutoButtonColor = false,
                    Parent = container
                })
                local titleLbl = C("TextLabel", {
                    Size = UDim2.new(1, -28, 0, 14),
                    Position = UDim2.new(0, 14, 0, (p.Description or "") ~= "" and 9 or 12),
                    BackgroundTransparency = 1,
                    Text = p.Title or "Button",
                    TextColor3 = T.Txt,
                    TextSize = 12,
                    Font = Enum.Font.GothamSemibold,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = container
                })
                B(titleLbl, {TextColor3 = "Txt"})
                if (p.Description or "") ~= "" then
                    local descLbl = C("TextLabel", {
                        Size = UDim2.new(1, -28, 0, 12),
                        Position = UDim2.new(0, 14, 0, 26),
                        BackgroundTransparency = 1,
                        Text = p.Description,
                        TextColor3 = T.Txt3,
                        TextSize = 10,
                        Font = Enum.Font.Gotham,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        Parent = container
                    })
                    B(descLbl, {TextColor3 = "Txt3"})
                end
                btn.MouseEnter:Connect(function()
                    Tw(container, {BackgroundColor3 = T.ElHov}, 0.1)
                end)
                btn.MouseLeave:Connect(function()
                    Tw(container, {BackgroundColor3 = T.El}, 0.1)
                end)
                btn.MouseButton1Click:Connect(function()
                    Tw(container, {BackgroundColor3 = T.Bg3}, 0.05)
                    task.wait(0.05)
                    Tw(container, {BackgroundColor3 = T.El}, 0.1)
                    if p.Callback then p.Callback() end
                end)
                regSearch(container, p.Title or "Button", p.Description)
                if p.Tooltip then AttachTooltip(container, p.Tooltip) end
                return {Type = "Button"}
            end

            function E:AddToggle(a, b)
                local p = resolveArgs(a, b)
                local h = (p.Description or "") ~= "" and 52 or 38
                local toggled = p.Default or false
                local flag = p.Flag or p.Title or "Tog"
                local cb = p.Callback or function() end
                local container = makeContainer(targetParent, h)
                local titleLbl = C("TextLabel", {
                    Size = UDim2.new(1, -68, 0, 14),
                    Position = UDim2.new(0, 14, 0, (p.Description or "") ~= "" and 9 or 12),
                    BackgroundTransparency = 1,
                    Text = p.Title or "Toggle",
                    TextColor3 = T.Txt,
                    TextSize = 12,
                    Font = Enum.Font.GothamSemibold,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = container
                })
                B(titleLbl, {TextColor3 = "Txt"})
                if (p.Description or "") ~= "" then
                    local descLbl = C("TextLabel", {
                        Size = UDim2.new(1, -68, 0, 12),
                        Position = UDim2.new(0, 14, 0, 26),
                        BackgroundTransparency = 1,
                        Text = p.Description,
                        TextColor3 = T.Txt3,
                        TextSize = 10,
                        Font = Enum.Font.Gotham,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        Parent = container
                    })
                    B(descLbl, {TextColor3 = "Txt3"})
                end
                local outer = C("Frame", {
                    Size = UDim2.new(0, 38, 0, 20),
                    Position = UDim2.new(1, -52, 0.5, -10),
                    BackgroundColor3 = toggled and T.TOn or T.TOff,
                    Parent = container
                })
                Cn(outer, 10)
                local inner = C("Frame", {
                    Size = UDim2.new(0, 14, 0, 14),
                    Position = toggled and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7),
                    BackgroundColor3 = toggled and T.Bg or T.Txt2,
                    Parent = outer
                })
                Cn(inner, 7)
                local btn = C("TextButton", {
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundTransparency = 1,
                    Text = "",
                    AutoButtonColor = false,
                    Parent = container
                })
                local el = {Type = "Toggle", Value = toggled, Flag = flag, Save = p.Save ~= false}
                local function update()
                    Tw(outer, {BackgroundColor3 = toggled and T.TOn or T.TOff}, 0.2)
                    Tw(inner, {
                        Position = toggled and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7),
                        BackgroundColor3 = toggled and T.Bg or T.Txt2
                    }, 0.2, Enum.EasingStyle.Back)
                end
                function el:Set(v) toggled = v; el.Value = v; update(); cb(v) end
                btn.MouseButton1Click:Connect(function()
                    toggled = not toggled
                    el.Value = toggled
                    update()
                    cb(toggled)
                end)
                table.insert(DDRefresh, {F = container, R = update})
                regSearch(container, p.Title or "Toggle", p.Description)
                if p.Tooltip then AttachTooltip(container, p.Tooltip) end
                WraithFlags[flag] = el
                return el
            end

            function E:AddCheckbox(a, b)
                local p = resolveArgs(a, b)
                local h = (p.Description or "") ~= "" and 52 or 38
                local checked = p.Default or false
                local flag = p.Flag or p.Title or "Chk"
                local cb = p.Callback or function() end
                local container = makeContainer(targetParent, h)
                local titleLbl = C("TextLabel", {
                    Size = UDim2.new(1, -50, 0, 14),
                    Position = UDim2.new(0, 38, 0, (p.Description or "") ~= "" and 9 or 12),
                    BackgroundTransparency = 1,
                    Text = p.Title or "Checkbox",
                    TextColor3 = T.Txt,
                    TextSize = 12,
                    Font = Enum.Font.GothamSemibold,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = container
                })
                B(titleLbl, {TextColor3 = "Txt"})
                if (p.Description or "") ~= "" then
                    local descLbl = C("TextLabel", {
                        Size = UDim2.new(1, -50, 0, 12),
                        Position = UDim2.new(0, 38, 0, 26),
                        BackgroundTransparency = 1,
                        Text = p.Description,
                        TextColor3 = T.Txt3,
                        TextSize = 10,
                        Font = Enum.Font.Gotham,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        Parent = container
                    })
                    B(descLbl, {TextColor3 = "Txt3"})
                end
                local box = C("Frame", {
                    Size = UDim2.new(0, 18, 0, 18),
                    Position = UDim2.new(0, 14, 0.5, -9),
                    BackgroundColor3 = checked and T.Acc or T.Bg3,
                    Parent = container
                })
                Cn(box, 4)
                St(box, T.Border, 1, 0.4)
                local checkMark = C("TextLabel", {
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundTransparency = 1,
                    Text = "✓",
                    TextColor3 = T.Bg,
                    TextSize = 14,
                    Font = Enum.Font.GothamBold,
                    Visible = checked,
                    Parent = box
                })
                B(checkMark, {TextColor3 = "Bg"})
                local btn = C("TextButton", {
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundTransparency = 1,
                    Text = "",
                    AutoButtonColor = false,
                    Parent = container
                })
                local el = {Type = "Checkbox", Value = checked, Flag = flag, Save = p.Save ~= false}
                local function update()
                    Tw(box, {BackgroundColor3 = checked and T.Acc or T.Bg3}, 0.2)
                    checkMark.Visible = checked
                end
                function el:Set(v) checked = v; el.Value = v; update(); cb(v) end
                btn.MouseButton1Click:Connect(function()
                    checked = not checked
                    el.Value = checked
                    update()
                    cb(checked)
                end)
                table.insert(DDRefresh, {F = container, R = update})
                regSearch(container, p.Title or "Checkbox", p.Description)
                if p.Tooltip then AttachTooltip(container, p.Tooltip) end
                WraithFlags[flag] = el
                return el
            end

            function E:AddSlider(a, b)
                local p = resolveArgs(a, b)
                local h = (p.Description or "") ~= "" and 70 or 52
                local mn, mx = p.Min or 0, p.Max or 100
                local def = p.Default or mn
                local rd = p.Rounding or 1
                local flag = p.Flag or p.Title or "Sl"
                local sf = p.Suffix or ""
                local cb = p.Callback or function() end
                local container = makeContainer(targetParent, h)
                local titleLbl = C("TextLabel", {
                    Size = UDim2.new(1, -80, 0, 14),
                    Position = UDim2.new(0, 14, 0, (p.Description or "") ~= "" and 7 or 5),
                    BackgroundTransparency = 1,
                    Text = p.Title or "Slider",
                    TextColor3 = T.Txt,
                    TextSize = 12,
                    Font = Enum.Font.GothamSemibold,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = container
                })
                B(titleLbl, {TextColor3 = "Txt"})
                local valBox = C("TextBox", {
                    Size = UDim2.new(0, 60, 0, 16),
                    Position = UDim2.new(1, -74, 0, (p.Description or "") ~= "" and 6 or 4),
                    BackgroundTransparency = 1,
                    Text = tostring(def) .. sf,
                    TextColor3 = T.Txt2,
                    TextSize = 11,
                    Font = Enum.Font.GothamSemibold,
                    TextXAlignment = Enum.TextXAlignment.Right,
                    ClearTextOnFocus = true,
                    Parent = container
                })
                B(valBox, {TextColor3 = "Txt2"})
                if (p.Description or "") ~= "" then
                    local descLbl = C("TextLabel", {
                        Size = UDim2.new(1, -28, 0, 12),
                        Position = UDim2.new(0, 14, 0, 22),
                        BackgroundTransparency = 1,
                        Text = p.Description,
                        TextColor3 = T.Txt3,
                        TextSize = 10,
                        Font = Enum.Font.Gotham,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        Parent = container
                    })
                    B(descLbl, {TextColor3 = "Txt3"})
                end
                local barY = (p.Description or "") ~= "" and 44 or 28
                local bg = C("Frame", {
                    Size = UDim2.new(1, -28, 0, 5),
                    Position = UDim2.new(0, 14, 0, barY),
                    BackgroundColor3 = T.Bg3,
                    Parent = container
                })
                Cn(bg, 2)
                B(bg, {BackgroundColor3 = "Bg3"})
                local initFill = math.clamp((def - mn) / (mx - mn), 0, 1)
                local fill = C("Frame", {
                    Size = UDim2.new(initFill, 0, 1, 0),
                    BackgroundColor3 = T.Slider,
                    Parent = bg
                })
                Cn(fill, 2)
                B(fill, {BackgroundColor3 = "Slider"})
                local knob = C("Frame", {
                    Size = UDim2.new(0, 14, 0, 14),
                    Position = UDim2.new(initFill, -7, 0.5, -7),
                    BackgroundColor3 = T.Txt,
                    ZIndex = 3,
                    Parent = bg
                })
                Cn(knob, 7)
                B(knob, {BackgroundColor3 = "Txt"})
                local sliderBtn = C("TextButton", {
                    Size = UDim2.new(1, 16, 1, 16),
                    Position = UDim2.new(0, -8, 0, -8),
                    BackgroundTransparency = 1,
                    Text = "",
                    AutoButtonColor = false,
                    ZIndex = 4,
                    Parent = bg
                })
                local dragging = false
                local el = {Type = "Slider", Value = def, Flag = flag, Save = p.Save ~= false}
                local function setVal(v)
                    v = math.clamp(v, mn, mx)
                    v = math.floor(v / rd + 0.5) * rd
                    el.Value = v
                    local f = math.clamp((v - mn) / (mx - mn), 0, 1)
                    Tw(fill, {Size = UDim2.new(f, 0, 1, 0)}, 0.06)
                    Tw(knob, {Position = UDim2.new(f, -7, 0.5, -7)}, 0.06)
                    valBox.Text = tostring(v) .. sf
                    cb(v)
                end
                function el:Set(v) setVal(v) end
                local function handleSliderInput(input)
                    local pp = math.clamp(
                        (input.Position.X - bg.AbsolutePosition.X) / bg.AbsoluteSize.X,
                        0, 1
                    )
                    setVal(mn + (mx - mn) * pp)
                end
                sliderBtn.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1
                        or input.UserInputType == Enum.UserInputType.Touch then
                        dragging = true
                        handleSliderInput(input)
                    end
                end)
                sliderBtn.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1
                        or input.UserInputType == Enum.UserInputType.Touch then
                        dragging = false
                    end
                end)
                UIS.InputChanged:Connect(function(input)
                    if dragging and (
                        input.UserInputType == Enum.UserInputType.MouseMovement
                        or input.UserInputType == Enum.UserInputType.Touch
                    ) then
                        handleSliderInput(input)
                    end
                end)
                valBox.FocusLost:Connect(function()
                    local raw = valBox.Text:gsub(sf, "")
                    local num = tonumber(raw)
                    if num then
                        setVal(num)
                    else
                        valBox.Text = tostring(el.Value) .. sf
                    end
                end)
                regSearch(container, p.Title or "Slider", p.Description)
                if p.Tooltip then AttachTooltip(container, p.Tooltip) end
                WraithFlags[flag] = el
                return el
            end

            function E:AddDropdown(a, b)
                local p = resolveArgs(a, b)
                local multi = p.Multi or false
                local vals = p.Values or {}
                local sel = multi and {} or p.Default
                local flag = p.Flag or p.Title or "DD"
                local cb = p.Callback or function() end
                local isOpen = false
                if multi and p.Default and type(p.Default) == "table" then
                    for _, v in ipairs(p.Default) do sel[v] = true end
                end
                local ht = (p.Description or "") ~= "" and 68 or 50
                local container = makeContainer(targetParent, ht)
                container.ClipsDescendants = true
                local titleLbl = C("TextLabel", {
                    Size = UDim2.new(1, -28, 0, 14),
                    Position = UDim2.new(0, 14, 0, (p.Description or "") ~= "" and 7 or 5),
                    BackgroundTransparency = 1,
                    Text = p.Title or "Dropdown",
                    TextColor3 = T.Txt,
                    TextSize = 12,
                    Font = Enum.Font.GothamSemibold,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = container
                })
                B(titleLbl, {TextColor3 = "Txt"})
                if (p.Description or "") ~= "" then
                    local descLbl = C("TextLabel", {
                        Size = UDim2.new(1, -28, 0, 12),
                        Position = UDim2.new(0, 14, 0, 22),
                        BackgroundTransparency = 1,
                        Text = p.Description,
                        TextColor3 = T.Txt3,
                        TextSize = 10,
                        Font = Enum.Font.Gotham,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        Parent = container
                    })
                    B(descLbl, {TextColor3 = "Txt3"})
                end
                local dY = (p.Description or "") ~= "" and 40 or 24
                local dropBtn = C("TextButton", {
                    Size = UDim2.new(1, -28, 0, 20),
                    Position = UDim2.new(0, 14, 0, dY),
                    BackgroundColor3 = T.Bg3,
                    Text = "",
                    AutoButtonColor = false,
                    Parent = container
                })
                Cn(dropBtn, 5)
                local dbs = St(dropBtn, T.Border, 1, 0.5)
                B(dropBtn, {BackgroundColor3 = "Bg3"})
                B(dbs, {Color = "Border"})
                local function getDisp()
                    if multi then
                        local items = {}
                        for k, v in pairs(sel) do
                            if v then table.insert(items, k) end
                        end
                        return #items == 0 and "None" or table.concat(items, ", ")
                    else
                        return sel or "None"
                    end
                end
                local dropLbl = C("TextLabel", {
                    Size = UDim2.new(1, -20, 1, 0),
                    Position = UDim2.new(0, 7, 0, 0),
                    BackgroundTransparency = 1,
                    Text = getDisp(),
                    TextColor3 = T.Txt2,
                    TextSize = 10,
                    Font = Enum.Font.Gotham,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextTruncate = Enum.TextTruncate.AtEnd,
                    Parent = dropBtn
                })
                B(dropLbl, {TextColor3 = "Txt2"})
                local arrowLbl = C("TextLabel", {
                    Size = UDim2.new(0, 12, 1, 0),
                    Position = UDim2.new(1, -16, 0, 0),
                    BackgroundTransparency = 1,
                    Text = "v",
                    TextColor3 = T.Txt3,
                    TextSize = 10,
                    Font = Enum.Font.GothamBold,
                    Parent = dropBtn
                })
                B(arrowLbl, {TextColor3 = "Txt3"})
                local optionsFrame = C("Frame", {
                    Size = UDim2.new(1, -28, 0, 0),
                    Position = UDim2.new(0, 14, 0, dY + 24),
                    BackgroundTransparency = 1,
                    ClipsDescendants = true,
                    Parent = container
                })
                C("UIListLayout", {
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    Padding = UDim.new(0, 2),
                    Parent = optionsFrame
                })
                local el = {Type = multi and "MultiDropdown" or "Dropdown", Value = sel, Flag = flag, Save = p.Save ~= false}
                local function refresh()
                    for _, ch in ipairs(optionsFrame:GetChildren()) do
                        if ch:IsA("TextButton") then ch:Destroy() end
                    end
                    for _, v in ipairs(vals) do
                        local isSel = multi and sel[v] or (sel == v)
                        local ob = C("TextButton", {
                            Size = UDim2.new(1, 0, 0, 24),
                            BackgroundColor3 = isSel and T.ElHov or T.Bg3,
                            BackgroundTransparency = isSel and 0.1 or 0.3,
                            Text = v,
                            TextColor3 = isSel and T.Txt or T.Txt2,
                            TextSize = 10,
                            Font = Enum.Font.Gotham,
                            AutoButtonColor = false,
                            Parent = optionsFrame
                        })
                        Cn(ob, 5)
                        if isSel then
                            B(ob, {BackgroundColor3 = "ElHov", TextColor3 = "Txt"})
                        else
                            B(ob, {BackgroundColor3 = "Bg3", TextColor3 = "Txt2"})
                        end
                        ob.MouseEnter:Connect(function() Tw(ob, {BackgroundTransparency = 0.05}, 0.08) end)
                        ob.MouseLeave:Connect(function()
                            local s = multi and sel[v] or (sel == v)
                            Tw(ob, {BackgroundTransparency = s and 0.1 or 0.3}, 0.08)
                        end)
                        ob.MouseButton1Click:Connect(function()
                            if multi then
                                sel[v] = not sel[v]
                                el.Value = sel
                            else
                                sel = v
                                el.Value = v
                            end
                            dropLbl.Text = getDisp()
                            refresh()
                            cb(multi and sel or v)
                            if not multi then
                                isOpen = false
                                Tw(container, {Size = UDim2.new(1, 0, 0, ht)}, 0.2)
                                Tw(optionsFrame, {Size = UDim2.new(1, -28, 0, 0)}, 0.2)
                                arrowLbl.Text = "v"
                            end
                        end)
                    end
                end
                refresh()
                table.insert(DDRefresh, {F = container, R = refresh})
                dropBtn.MouseButton1Click:Connect(function()
                    isOpen = not isOpen
                    if isOpen then
                        local oh = #vals * 26
                        Tw(container, {Size = UDim2.new(1, 0, 0, ht + oh + 4)}, 0.2)
                        Tw(optionsFrame, {Size = UDim2.new(1, -28, 0, oh)}, 0.2)
                        arrowLbl.Text = "^"
                    else
                        Tw(container, {Size = UDim2.new(1, 0, 0, ht)}, 0.2)
                        Tw(optionsFrame, {Size = UDim2.new(1, -28, 0, 0)}, 0.2)
                        arrowLbl.Text = "v"
                    end
                end)
                function el:Set(v)
                    if multi then
                        if type(v) == "table" then sel = v end
                    else
                        sel = v
                    end
                    el.Value = sel
                    dropLbl.Text = getDisp()
                    refresh()
                    cb(sel)
                end
                function el:SetValues(nv) vals = nv; refresh() end
                regSearch(container, p.Title or "Dropdown", p.Description)
                if p.Tooltip then AttachTooltip(container, p.Tooltip) end
                WraithFlags[flag] = el
                return el
            end

            function E:AddMultiDropdown(a, b)
                local p = resolveArgs(a, b)
                p.Multi = true
                return self:AddDropdown(p)
            end

            function E:AddColorpicker(a, b)
                local p = resolveArgs(a, b)
                local cur = p.Default or Color3.fromRGB(255, 255, 255)
                local flag = p.Flag or p.Title or "CP"
                local cb = p.Callback or function() end
                local container = makeContainer(targetParent, 38)
                local titleLbl = C("TextLabel", {
                    Size = UDim2.new(1, -68, 0, 14),
                    Position = UDim2.new(0, 14, 0, 12),
                    BackgroundTransparency = 1,
                    Text = p.Title or "Color",
                    TextColor3 = T.Txt,
                    TextSize = 12,
                    Font = Enum.Font.GothamSemibold,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = container
                })
                B(titleLbl, {TextColor3 = "Txt"})
                local preview = C("TextButton", {
                    Size = UDim2.new(0, 26, 0, 18),
                    Position = UDim2.new(1, -40, 0, 10),
                    BackgroundColor3 = cur,
                    Text = "",
                    AutoButtonColor = false,
                    Parent = container
                })
                Cn(preview, 5)
                local pvs = St(preview, T.Border, 1, 0.35)
                B(pvs, {Color = "Border"})
                local el = {Type = "Colorpicker", Value = cur, Flag = flag, Save = p.Save ~= false}
                preview.MouseButton1Click:Connect(function()
                    ColorDialog(el.Value, function(nc)
                        el.Value = nc
                        preview.BackgroundColor3 = nc
                        cb(nc)
                    end)
                end)
                function el:Set(col)
                    if type(col) == "string" then
                        pcall(function() col = Color3.fromHex(col) end)
                    end
                    el.Value = col
                    preview.BackgroundColor3 = col
                    cb(col)
                end
                regSearch(container, p.Title or "Color")
                if p.Tooltip then AttachTooltip(container, p.Tooltip) end
                WraithFlags[flag] = el
                return el
            end

            function E:AddKeybind(a, b)
                local p = resolveArgs(a, b)
                local curKey = p.Default
                local flag = p.Flag or p.Title or "KB"
                local cb = p.Callback or function() end
                local ccb = p.ChangedCallback or function() end
                local listening = false
                local container = makeContainer(targetParent, 38)
                local titleLbl = C("TextLabel", {
                    Size = UDim2.new(1, -94, 0, 14),
                    Position = UDim2.new(0, 14, 0, 12),
                    BackgroundTransparency = 1,
                    Text = p.Title or "Keybind",
                    TextColor3 = T.Txt,
                    TextSize = 12,
                    Font = Enum.Font.GothamSemibold,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = container
                })
                B(titleLbl, {TextColor3 = "Txt"})
                local kbBtn = C("TextButton", {
                    Size = UDim2.new(0, 66, 0, 22),
                    Position = UDim2.new(1, -80, 0, 8),
                    BackgroundColor3 = T.Bg3,
                    Text = curKey and curKey.Name or "None",
                    TextColor3 = T.Txt2,
                    TextSize = 10,
                    Font = Enum.Font.GothamSemibold,
                    AutoButtonColor = false,
                    Parent = container
                })
                Cn(kbBtn, 5)
                local kbs = St(kbBtn, T.Border, 1, 0.5)
                B(kbBtn, {BackgroundColor3 = "Bg3", TextColor3 = "Txt2"})
                B(kbs, {Color = "Border"})
                local el = {Type = "Keybind", Value = curKey, Flag = flag, Save = p.Save ~= false}
                kbBtn.MouseButton1Click:Connect(function()
                    listening = true
                    kbBtn.Text = "..."
                end)
                UIS.InputBegan:Connect(function(input, gp)
                    if gp then return end
                    if listening then
                        if input.UserInputType == Enum.UserInputType.Keyboard then
                            if input.KeyCode == Enum.KeyCode.Escape then
                                curKey = nil
                                kbBtn.Text = "None"
                            else
                                curKey = input.KeyCode
                                kbBtn.Text = curKey.Name
                            end
                            el.Value = curKey
                            listening = false
                            ccb(curKey)
                        end
                    elseif curKey and input.KeyCode == curKey then
                        cb(curKey)
                    end
                end)
                function el:Set(k)
                    if type(k) == "string" then k = Enum.KeyCode[k] end
                    curKey = k
                    el.Value = k
                    kbBtn.Text = k and k.Name or "None"
                    ccb(k)
                end
                regSearch(container, p.Title or "Keybind")
                if p.Tooltip then AttachTooltip(container, p.Tooltip) end
                WraithFlags[flag] = el
                return el
            end

            function E:AddInput(a, b)
                local p = resolveArgs(a, b)
                local h = (p.Description or "") ~= "" and 68 or 50
                local flag = p.Flag or p.Title or "In"
                local cb = p.Callback or function() end
                local container = makeContainer(targetParent, h)
                local titleLbl = C("TextLabel", {
                    Size = UDim2.new(1, -28, 0, 14),
                    Position = UDim2.new(0, 14, 0, (p.Description or "") ~= "" and 7 or 5),
                    BackgroundTransparency = 1,
                    Text = p.Title or "Input",
                    TextColor3 = T.Txt,
                    TextSize = 12,
                    Font = Enum.Font.GothamSemibold,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = container
                })
                B(titleLbl, {TextColor3 = "Txt"})
                if (p.Description or "") ~= "" then
                    local descLbl = C("TextLabel", {
                        Size = UDim2.new(1, -28, 0, 12),
                        Position = UDim2.new(0, 14, 0, 22),
                        BackgroundTransparency = 1,
                        Text = p.Description,
                        TextColor3 = T.Txt3,
                        TextSize = 10,
                        Font = Enum.Font.Gotham,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        Parent = container
                    })
                    B(descLbl, {TextColor3 = "Txt3"})
                end
                local iY = (p.Description or "") ~= "" and 40 or 26
                local inputBox = C("TextBox", {
                    Size = UDim2.new(1, -28, 0, 20),
                    Position = UDim2.new(0, 14, 0, iY),
                    BackgroundColor3 = T.Bg3,
                    Text = p.Default or "",
                    PlaceholderText = p.Placeholder or "Type...",
                    PlaceholderColor3 = T.Txt3,
                    TextColor3 = T.Txt,
                    TextSize = 10,
                    Font = Enum.Font.Gotham,
                    ClearTextOnFocus = false,
                    Parent = container
                })
                Cn(inputBox, 5)
                Pd(inputBox, 0, 0, 7, 7)
                local ibs = St(inputBox, T.Border, 1, 0.5)
                B(inputBox, {BackgroundColor3 = "Bg3", TextColor3 = "Txt", PlaceholderColor3 = "Txt3"})
                B(ibs, {Color = "Border"})
                local el = {Type = "Input", Value = p.Default or "", Flag = flag, Save = p.Save ~= false}
                inputBox.FocusLost:Connect(function()
                    local v = inputBox.Text
                    if p.Numeric then
                        v = tonumber(v) or el.Value
                        inputBox.Text = tostring(v)
                    end
                    el.Value = v
                    cb(v)
                end)
                function el:Set(v) el.Value = v; inputBox.Text = tostring(v); cb(v) end
                regSearch(container, p.Title or "Input", p.Description)
                if p.Tooltip then AttachTooltip(container, p.Tooltip) end
                WraithFlags[flag] = el
                return el
            end

            function E:AddMultiInput(a, b)
                local p = resolveArgs(a, b)
                local fields = p.Fields or {}
                local h = (p.Description or "") ~= "" and 76 or 58
                local flag = p.Flag or p.Title or "MI"
                local container = makeContainer(targetParent, h)
                local titleLbl = C("TextLabel", {
                    Size = UDim2.new(1, -28, 0, 14),
                    Position = UDim2.new(0, 14, 0, (p.Description or "") ~= "" and 6 or 4),
                    BackgroundTransparency = 1,
                    Text = p.Title or "Multi Input",
                    TextColor3 = T.Txt,
                    TextSize = 12,
                    Font = Enum.Font.GothamSemibold,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = container
                })
                B(titleLbl, {TextColor3 = "Txt"})
                if (p.Description or "") ~= "" then
                    local descLbl = C("TextLabel", {
                        Size = UDim2.new(1, -28, 0, 12),
                        Position = UDim2.new(0, 14, 0, 20),
                        BackgroundTransparency = 1,
                        Text = p.Description,
                        TextColor3 = T.Txt3,
                        TextSize = 10,
                        Font = Enum.Font.Gotham,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        Parent = container
                    })
                    B(descLbl, {TextColor3 = "Txt3"})
                end
                local inputsY = (p.Description or "") ~= "" and 38 or 24
                local inputsFrame = C("Frame", {
                    Size = UDim2.new(1, -28, 0, 22),
                    Position = UDim2.new(0, 14, 0, inputsY),
                    BackgroundTransparency = 1,
                    Parent = container
                })
                C("UIListLayout", {
                    FillDirection = Enum.FillDirection.Horizontal,
                    Padding = UDim.new(0, 6),
                    Parent = inputsFrame
                })
                local values = {}
                local el = {Type = "MultiInput", Value = values, Flag = flag, Save = p.Save ~= false}
                local count = #fields
                local widthPerField = count > 0 and (1 / count) or 1
                for i, field in ipairs(fields) do
                    local fieldName = field.Name or ("Field" .. i)
                    local fieldDefault = field.Default or ""
                    local fieldPlaceholder = field.Placeholder or fieldName
                    local fieldCallback = field.Callback or function() end
                    values[fieldName] = fieldDefault
                    local inBox = C("TextBox", {
                        Size = UDim2.new(widthPerField, -6, 1, 0),
                        BackgroundColor3 = T.Bg3,
                        Text = fieldDefault,
                        PlaceholderText = fieldPlaceholder,
                        PlaceholderColor3 = T.Txt3,
                        TextColor3 = T.Txt,
                        TextSize = 10,
                        Font = Enum.Font.Gotham,
                        ClearTextOnFocus = false,
                        Parent = inputsFrame
                    })
                    Cn(inBox, 5)
                    Pd(inBox, 0, 0, 7, 7)
                    local ibs = St(inBox, T.Border, 1, 0.5)
                    B(inBox, {BackgroundColor3 = "Bg3", TextColor3 = "Txt", PlaceholderColor3 = "Txt3"})
                    B(ibs, {Color = "Border"})
                    inBox.FocusLost:Connect(function()
                        local v = inBox.Text
                        if field.Numeric then
                            v = tonumber(v) or fieldDefault
                            inBox.Text = tostring(v)
                        end
                        values[fieldName] = v
                        el.Value = values
                        fieldCallback(v, values)
                        if p.Callback then p.Callback(values) end
                    end)
                end
                function el:Set(t)
                    if type(t) ~= "table" then return end
                    for k, v in pairs(t) do values[k] = v end
                    el.Value = values
                    if p.Callback then p.Callback(values) end
                end
                regSearch(container, p.Title or "Multi Input", p.Description)
                if p.Tooltip then AttachTooltip(container, p.Tooltip) end
                WraithFlags[flag] = el
                return el
            end

            function E:AddMultiSlider(a, b)
                local p = resolveArgs(a, b)
                local fields = p.Fields or {}
                local count = #fields
                local h = (p.Description or "") ~= "" and (24 + count * 24 + 14) or (24 + count * 24)
                local flag = p.Flag or p.Title or "MS"
                local container = makeContainer(targetParent, h)
                local titleLbl = C("TextLabel", {
                    Size = UDim2.new(1, -28, 0, 14),
                    Position = UDim2.new(0, 14, 0, (p.Description or "") ~= "" and 6 or 4),
                    BackgroundTransparency = 1,
                    Text = p.Title or "Multi Slider",
                    TextColor3 = T.Txt,
                    TextSize = 12,
                    Font = Enum.Font.GothamSemibold,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = container
                })
                B(titleLbl, {TextColor3 = "Txt"})
                if (p.Description or "") ~= "" then
                    local descLbl = C("TextLabel", {
                        Size = UDim2.new(1, -28, 0, 12),
                        Position = UDim2.new(0, 14, 0, 20),
                        BackgroundTransparency = 1,
                        Text = p.Description,
                        TextColor3 = T.Txt3,
                        TextSize = 10,
                        Font = Enum.Font.Gotham,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        Parent = container
                    })
                    B(descLbl, {TextColor3 = "Txt3"})
                end
                local startY = (p.Description or "") ~= "" and 38 or 24
                local values = {}
                local el = {Type = "MultiSlider", Value = values, Flag = flag, Save = p.Save ~= false}
                for i, field in ipairs(fields) do
                    local fieldName = field.Name or ("Slider" .. i)
                    local mn, mx = field.Min or 0, field.Max or 100
                    local def = field.Default or mn
                    local rd = field.Rounding or 1
                    local sf = field.Suffix or ""
                    local fieldCb = field.Callback or function() end
                    values[fieldName] = def
                    local rowY = startY + (i - 1) * 24
                    local nameLbl = C("TextLabel", {
                        Size = UDim2.new(0, 60, 0, 16),
                        Position = UDim2.new(0, 14, 0, rowY + 2),
                        BackgroundTransparency = 1,
                        Text = fieldName,
                        TextColor3 = T.Txt2,
                        TextSize = 10,
                        Font = Enum.Font.GothamSemibold,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        Parent = container
                    })
                    B(nameLbl, {TextColor3 = "Txt2"})
                    local valBox = C("TextBox", {
                        Size = UDim2.new(0, 50, 0, 14),
                        Position = UDim2.new(1, -64, 0, rowY + 3),
                        BackgroundTransparency = 1,
                        Text = tostring(def) .. sf,
                        TextColor3 = T.Txt2,
                        TextSize = 10,
                        Font = Enum.Font.GothamSemibold,
                        TextXAlignment = Enum.TextXAlignment.Right,
                        ClearTextOnFocus = true,
                        Parent = container
                    })
                    B(valBox, {TextColor3 = "Txt2"})
                    local bg = C("Frame", {
                        Size = UDim2.new(1, -158, 0, 4),
                        Position = UDim2.new(0, 80, 0, rowY + 9),
                        BackgroundColor3 = T.Bg3,
                        Parent = container
                    })
                    Cn(bg, 2)
                    B(bg, {BackgroundColor3 = "Bg3"})
                    local initFill = math.clamp((def - mn) / (mx - mn), 0, 1)
                    local fill = C("Frame", {
                        Size = UDim2.new(initFill, 0, 1, 0),
                        BackgroundColor3 = T.Slider,
                        Parent = bg
                    })
                    Cn(fill, 2)
                    B(fill, {BackgroundColor3 = "Slider"})
                    local knob = C("Frame", {
                        Size = UDim2.new(0, 10, 0, 10),
                        Position = UDim2.new(initFill, -5, 0.5, -5),
                        BackgroundColor3 = T.Txt,
                        ZIndex = 3,
                        Parent = bg
                    })
                    Cn(knob, 5)
                    B(knob, {BackgroundColor3 = "Txt"})
                    local sliderBtn = C("TextButton", {
                        Size = UDim2.new(1, 16, 1, 16),
                        Position = UDim2.new(0, -8, 0, -8),
                        BackgroundTransparency = 1,
                        Text = "",
                        AutoButtonColor = false,
                        ZIndex = 4,
                        Parent = bg
                    })
                    local dragging = false
                    local function setVal(v)
                        v = math.clamp(v, mn, mx)
                        v = math.floor(v / rd + 0.5) * rd
                        values[fieldName] = v
                        el.Value = values
                        local f = math.clamp((v - mn) / (mx - mn), 0, 1)
                        Tw(fill, {Size = UDim2.new(f, 0, 1, 0)}, 0.06)
                        Tw(knob, {Position = UDim2.new(f, -5, 0.5, -5)}, 0.06)
                        valBox.Text = tostring(v) .. sf
                        fieldCb(v, values)
                        if p.Callback then p.Callback(values) end
                    end
                    local function handleInput(input)
                        local pp = math.clamp(
                            (input.Position.X - bg.AbsolutePosition.X) / bg.AbsoluteSize.X,
                            0, 1
                        )
                        setVal(mn + (mx - mn) * pp)
                    end
                    sliderBtn.InputBegan:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1
                            or input.UserInputType == Enum.UserInputType.Touch then
                            dragging = true
                            handleInput(input)
                        end
                    end)
                    sliderBtn.InputEnded:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1
                            or input.UserInputType == Enum.UserInputType.Touch then
                            dragging = false
                        end
                    end)
                    UIS.InputChanged:Connect(function(input)
                        if dragging and (
                            input.UserInputType == Enum.UserInputType.MouseMovement
                            or input.UserInputType == Enum.UserInputType.Touch
                        ) then
                            handleInput(input)
                        end
                    end)
                    valBox.FocusLost:Connect(function()
                        local raw = valBox.Text:gsub(sf, "")
                        local num = tonumber(raw)
                        if num then
                            setVal(num)
                        else
                            valBox.Text = tostring(values[fieldName]) .. sf
                        end
                    end)
                end
                function el:Set(t)
                    if type(t) ~= "table" then return end
                    for k, v in pairs(t) do values[k] = v end
                    el.Value = values
                    if p.Callback then p.Callback(values) end
                end
                regSearch(container, p.Title or "Multi Slider", p.Description)
                if p.Tooltip then AttachTooltip(container, p.Tooltip) end
                WraithFlags[flag] = el
                return el
            end

            function E:AddNumberSpinner(a, b)
                local p = resolveArgs(a, b)
                local mn, mx = p.Min or 0, p.Max or 100
                local step = p.Step or 1
                local flag = p.Flag or p.Title or "NS"
                local cb = p.Callback or function() end
                local cur = math.clamp(p.Default or mn, mn, mx)
                local container = makeContainer(targetParent, 38)
                local titleLbl = C("TextLabel", {
                    Size = UDim2.new(1, -110, 0, 14),
                    Position = UDim2.new(0, 14, 0, 12),
                    BackgroundTransparency = 1,
                    Text = p.Title or "Number",
                    TextColor3 = T.Txt,
                    TextSize = 12,
                    Font = Enum.Font.GothamSemibold,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = container
                })
                B(titleLbl, {TextColor3 = "Txt"})
                local minusBtn = C("TextButton", {
                    Size = UDim2.new(0, 22, 0, 22),
                    Position = UDim2.new(1, -96, 0, 8),
                    BackgroundColor3 = T.Bg3,
                    Text = "-",
                    TextColor3 = T.Txt,
                    TextSize = 14,
                    Font = Enum.Font.GothamBold,
                    AutoButtonColor = false,
                    Parent = container
                })
                Cn(minusBtn, 5)
                B(minusBtn, {BackgroundColor3 = "Bg3", TextColor3 = "Txt"})
                local valBox = C("TextBox", {
                    Size = UDim2.new(0, 42, 0, 22),
                    Position = UDim2.new(1, -72, 0, 8),
                    BackgroundColor3 = T.Bg3,
                    Text = tostring(cur),
                    TextColor3 = T.Txt,
                    TextSize = 11,
                    Font = Enum.Font.GothamSemibold,
                    PlaceholderColor3 = T.Txt3,
                    ClearTextOnFocus = true,
                    Parent = container
                })
                Cn(valBox, 5)
                B(valBox, {BackgroundColor3 = "Bg3", TextColor3 = "Txt", PlaceholderColor3 = "Txt3"})
                local plusBtn = C("TextButton", {
                    Size = UDim2.new(0, 22, 0, 22),
                    Position = UDim2.new(1, -26, 0, 8),
                    BackgroundColor3 = T.Bg3,
                    Text = "+",
                    TextColor3 = T.Txt,
                    TextSize = 14,
                    Font = Enum.Font.GothamBold,
                    AutoButtonColor = false,
                    Parent = container
                })
                Cn(plusBtn, 5)
                B(plusBtn, {BackgroundColor3 = "Bg3", TextColor3 = "Txt"})
                local el = {Type = "NumberSpinner", Value = cur, Flag = flag, Save = p.Save ~= false}
                local function setVal(v)
                    cur = math.clamp(v, mn, mx)
                    el.Value = cur
                    valBox.Text = tostring(cur)
                    cb(cur)
                end
                function el:Set(v) setVal(v) end
                minusBtn.MouseButton1Click:Connect(function() setVal(cur - step) end)
                plusBtn.MouseButton1Click:Connect(function() setVal(cur + step) end)
                valBox.FocusLost:Connect(function()
                    local n = tonumber(valBox.Text)
                    if n then setVal(n) else valBox.Text = tostring(cur) end
                end)
                regSearch(container, p.Title or "Number")
                if p.Tooltip then AttachTooltip(container, p.Tooltip) end
                WraithFlags[flag] = el
                return el
            end

            function E:AddDateTime(a, b)
                local p = resolveArgs(a, b)
                local container = makeContainer(targetParent, 38)
                local titleLbl = C("TextLabel", {
                    Size = UDim2.new(1, -100, 0, 14),
                    Position = UDim2.new(0, 14, 0, 12),
                    BackgroundTransparency = 1,
                    Text = p.Title or "Time",
                    TextColor3 = T.Txt,
                    TextSize = 12,
                    Font = Enum.Font.GothamSemibold,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = container
                })
                B(titleLbl, {TextColor3 = "Txt"})
                local dispLbl = C("TextLabel", {
                    Size = UDim2.new(0, 90, 0, 16),
                    Position = UDim2.new(1, -100, 0, 11),
                    BackgroundTransparency = 1,
                    Text = "",
                    TextColor3 = T.Txt2,
                    TextSize = 11,
                    Font = Enum.Font.GothamSemibold,
                    TextXAlignment = Enum.TextXAlignment.Right,
                    Parent = container
                })
                B(dispLbl, {TextColor3 = "Txt2"})
                local fmt = p.Format or "%H:%M:%S"
                task.spawn(function()
                    while container.Parent do
                        dispLbl.Text = os.date(fmt)
                        task.wait(1)
                    end
                end)
                regSearch(container, p.Title or "DateTime")
                return {Type = "DateTime"}
            end

            function E:AddStatusBar(a, b)
                local p = resolveArgs(a, b)
                local container = makeContainer(targetParent, 38)
                local titleLbl = C("TextLabel", {
                    Size = UDim2.new(1, -100, 0, 14),
                    Position = UDim2.new(0, 14, 0, 12),
                    BackgroundTransparency = 1,
                    Text = p.Title or "Status",
                    TextColor3 = T.Txt,
                    TextSize = 12,
                    Font = Enum.Font.GothamSemibold,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = container
                })
                B(titleLbl, {TextColor3 = "Txt"})
                local valLbl = C("TextLabel", {
                    Size = UDim2.new(0, 90, 0, 16),
                    Position = UDim2.new(1, -100, 0, 11),
                    BackgroundTransparency = 1,
                    Text = "...",
                    TextColor3 = T.Acc,
                    TextSize = 11,
                    Font = Enum.Font.GothamBold,
                    TextXAlignment = Enum.TextXAlignment.Right,
                    Parent = container
                })
                B(valLbl, {TextColor3 = "Acc"})
                local interval = p.UpdateInterval or 1
                local getter = p.Getter or function() return "N/A" end
                task.spawn(function()
                    while container.Parent do
                        local ok, val = pcall(getter)
                        if ok then valLbl.Text = tostring(val) end
                        task.wait(interval)
                    end
                end)
                regSearch(container, p.Title or "Status")
                local el = {Type = "StatusBar"}
                function el:Set(v) valLbl.Text = tostring(v) end
                return el
            end

            function E:AddSeparator()
                local s = C("Frame", {
                    Size = UDim2.new(1, 0, 0, 1),
                    BackgroundColor3 = T.Border,
                    BackgroundTransparency = 0.5,
                    BorderSizePixel = 0,
                    Parent = targetParent
                })
                B(s, {BackgroundColor3 = "Border"})
                return {Type = "Separator"}
            end

            function E:AddDivider(a, b)
                local p = resolveArgs(a, b)
                local f = C("Frame", {
                    Size = UDim2.new(1, 0, 0, 22),
                    BackgroundTransparency = 1,
                    Parent = targetParent
                })
                C("UIListLayout", {
                    FillDirection = Enum.FillDirection.Horizontal,
                    HorizontalAlignment = Enum.HorizontalAlignment.Center,
                    VerticalAlignment = Enum.VerticalAlignment.Center,
                    Padding = UDim.new(0, 8),
                    Parent = f
                })
                local line1 = C("Frame", {
                    Size = UDim2.new(0.4, -50, 0, 1),
                    BackgroundColor3 = T.Border,
                    BackgroundTransparency = 0.5,
                    BorderSizePixel = 0,
                    LayoutOrder = 1,
                    Parent = f
                })
                B(line1, {BackgroundColor3 = "Border"})
                local lbl = C("TextLabel", {
                    Size = UDim2.new(0, 0, 0, 14),
                    AutomaticSize = Enum.AutomaticSize.X,
                    BackgroundTransparency = 1,
                    Text = p.Text or "---",
                    TextColor3 = T.Txt3,
                    TextSize = 10,
                    Font = Enum.Font.GothamSemibold,
                    LayoutOrder = 2,
                    Parent = f
                })
                B(lbl, {TextColor3 = "Txt3"})
                local line2 = C("Frame", {
                    Size = UDim2.new(0.4, -50, 0, 1),
                    BackgroundColor3 = T.Border,
                    BackgroundTransparency = 0.5,
                    BorderSizePixel = 0,
                    LayoutOrder = 3,
                    Parent = f
                })
                B(line2, {BackgroundColor3 = "Border"})
                return {Type = "Divider"}
            end

            function E:AddLabel(a, b)
                local p = resolveArgs(a, b)
                local l = C("TextLabel", {
                    Size = UDim2.new(1, 0, 0, 18),
                    BackgroundTransparency = 1,
                    Text = p.Text or "",
                    TextColor3 = T.Txt3,
                    TextSize = 11,
                    Font = Enum.Font.GothamSemibold,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = targetParent
                })
                B(l, {TextColor3 = "Txt3"})
                local el = {Type = "Label"}
                function el:Set(txt) l.Text = txt end
                return el
            end

            return E
        end

        local tabElements = createElements(page)
        for k, v in pairs(tabElements) do tab[k] = v end

        function tab:AddSection(a, b)
            local p
            if type(a) == "string" then
                p = b or {}
                p.Title = a
            else
                p = a or {}
            end
            local sFrame = C("Frame", {
                Size = UDim2.new(1, 0, 0, 0),
                BackgroundTransparency = 1,
                AutomaticSize = Enum.AutomaticSize.Y,
                Parent = page
            })
            if p.Title then
                local tLbl = C("TextLabel", {
                    Size = UDim2.new(1, 0, 0, 18),
                    BackgroundTransparency = 1,
                    Text = p.Title,
                    TextColor3 = T.Txt,
                    TextSize = 13,
                    Font = Enum.Font.GothamBold,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = sFrame
                })
                B(tLbl, {TextColor3 = "Txt"})
            end
            local content = C("Frame", {
                Size = UDim2.new(1, 0, 0, 0),
                Position = UDim2.new(0, 0, 0, p.Title and 22 or 0),
                BackgroundTransparency = 1,
                AutomaticSize = Enum.AutomaticSize.Y,
                Parent = sFrame
            })
            C("UIListLayout", {
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 6),
                Parent = content
            })
            return createElements(content)
        end

        return tab
    end

    W.MainFrame = main
    W.FloatButton = floatBtn
    function W:Show() showWindow() end
    function W:Hide() hideWindow() end
    function W:Minimize() minimizeWindow() end
    function W:Destroy()
        if main then main:Destroy() end
        if floatBtn then floatBtn:Destroy() end
    end
    function W:Resize(w, h)
        W.CurrentSize = UDim2.new(0, w, 0, h)
        main.Size = W.CurrentSize
    end

    return W
end

Wraith.Icons = {
    LoadPlatform = function(p) LoadIcons(p) end,
    Get = function(n) return GetIcon(n) end
}

pcall(function()
    if CoreGui:FindFirstChild("Wraith") then
        CoreGui:FindFirstChild("Wraith"):Destroy()
    end
end)
pcall(function()
    if gethui and gethui():FindFirstChild("Wraith") then
        gethui():FindFirstChild("Wraith"):Destroy()
    end
end)

LoadCustomThemes()
LoadThemePref()
LoadIcons("Lucide")

return Wraith
