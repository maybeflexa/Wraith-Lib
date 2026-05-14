local Wraith = {}
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Player = Players.LocalPlayer
local WraithFlags = {}
local LoadedIcons = {}
local CurrentIconPlatform = "Lucide"
local AllBinds = {}
local ScreenGui

local PlatformURLs = {
    ["Lucide"] = "https://raw.githubusercontent.com/latte-soft/lucide-roblox/master/files/lucide.json",
    ["Gravity"] = "https://raw.githubusercontent.com/maybeflexa/Wraith-Lib/refs/heads/main/Icons/Gravity.json",
    ["Solar"] = "https://raw.githubusercontent.com/maybeflexa/Wraith-Lib/refs/heads/main/Icons/Solar.json",
    ["SFSymbols"] = "https://raw.githubusercontent.com/maybeflexa/Wraith-Lib/refs/heads/main/Icons/SFSymbols.json"
}

local Themes = {
    ["AMOLED"] = {
        Bg = Color3.fromRGB(0, 0, 0), Bg2 = Color3.fromRGB(8, 8, 8), Bg3 = Color3.fromRGB(18, 18, 18),
        El = Color3.fromRGB(13, 13, 13), ElHov = Color3.fromRGB(22, 22, 22), Border = Color3.fromRGB(34, 34, 34),
        Txt = Color3.fromRGB(255, 255, 255), Txt2 = Color3.fromRGB(160, 160, 160), Txt3 = Color3.fromRGB(95, 95, 95),
        Acc = Color3.fromRGB(212, 212, 212), AccD = Color3.fromRGB(160, 160, 160),
        TOn = Color3.fromRGB(220, 220, 220), TOff = Color3.fromRGB(40, 40, 40), Slider = Color3.fromRGB(200, 200, 200),
        BgTr = 0.1, ElTr = 0.4, SbTr = 0.18
    },
    ["Dark"] = {
        Bg = Color3.fromRGB(14, 14, 16), Bg2 = Color3.fromRGB(20, 20, 23), Bg3 = Color3.fromRGB(28, 28, 32),
        El = Color3.fromRGB(24, 24, 28), ElHov = Color3.fromRGB(36, 36, 40), Border = Color3.fromRGB(46, 46, 50),
        Txt = Color3.fromRGB(244, 244, 244), Txt2 = Color3.fromRGB(154, 154, 160), Txt3 = Color3.fromRGB(100, 100, 108),
        Acc = Color3.fromRGB(200, 200, 208), AccD = Color3.fromRGB(148, 148, 154),
        TOn = Color3.fromRGB(210, 210, 216), TOff = Color3.fromRGB(50, 50, 54), Slider = Color3.fromRGB(190, 190, 198),
        BgTr = 0.12, ElTr = 0.38, SbTr = 0.2
    },
    ["Darker"] = {
        Bg = Color3.fromRGB(6, 6, 8), Bg2 = Color3.fromRGB(12, 12, 14), Bg3 = Color3.fromRGB(20, 20, 22),
        El = Color3.fromRGB(16, 16, 18), ElHov = Color3.fromRGB(28, 28, 30), Border = Color3.fromRGB(38, 38, 42),
        Txt = Color3.fromRGB(238, 238, 238), Txt2 = Color3.fromRGB(142, 142, 148), Txt3 = Color3.fromRGB(90, 90, 96),
        Acc = Color3.fromRGB(192, 192, 198), AccD = Color3.fromRGB(138, 138, 144),
        TOn = Color3.fromRGB(202, 202, 208), TOff = Color3.fromRGB(44, 44, 48), Slider = Color3.fromRGB(182, 182, 190),
        BgTr = 0.08, ElTr = 0.36, SbTr = 0.15
    },
    ["Midnight"] = {
        Bg = Color3.fromRGB(4, 4, 12), Bg2 = Color3.fromRGB(10, 10, 20), Bg3 = Color3.fromRGB(18, 18, 30),
        El = Color3.fromRGB(14, 14, 24), ElHov = Color3.fromRGB(26, 26, 38), Border = Color3.fromRGB(40, 40, 54),
        Txt = Color3.fromRGB(232, 232, 242), Txt2 = Color3.fromRGB(144, 144, 164), Txt3 = Color3.fromRGB(94, 94, 114),
        Acc = Color3.fromRGB(180, 180, 208), AccD = Color3.fromRGB(130, 130, 158),
        TOn = Color3.fromRGB(190, 190, 218), TOff = Color3.fromRGB(42, 42, 54), Slider = Color3.fromRGB(170, 170, 198),
        BgTr = 0.1, ElTr = 0.38, SbTr = 0.18
    },
    ["Charcoal"] = {
        Bg = Color3.fromRGB(20, 20, 20), Bg2 = Color3.fromRGB(28, 28, 28), Bg3 = Color3.fromRGB(38, 38, 38),
        El = Color3.fromRGB(32, 32, 32), ElHov = Color3.fromRGB(46, 46, 46), Border = Color3.fromRGB(56, 56, 56),
        Txt = Color3.fromRGB(248, 248, 248), Txt2 = Color3.fromRGB(162, 162, 162), Txt3 = Color3.fromRGB(108, 108, 108),
        Acc = Color3.fromRGB(212, 212, 212), AccD = Color3.fromRGB(152, 152, 152),
        TOn = Color3.fromRGB(222, 222, 222), TOff = Color3.fromRGB(58, 58, 58), Slider = Color3.fromRGB(198, 198, 198),
        BgTr = 0.12, ElTr = 0.4, SbTr = 0.22
    },
    ["Light"] = {
        Bg = Color3.fromRGB(244, 244, 247), Bg2 = Color3.fromRGB(232, 232, 236), Bg3 = Color3.fromRGB(218, 218, 224),
        El = Color3.fromRGB(225, 225, 230), ElHov = Color3.fromRGB(210, 210, 216), Border = Color3.fromRGB(192, 192, 198),
        Txt = Color3.fromRGB(15, 15, 18), Txt2 = Color3.fromRGB(68, 68, 76), Txt3 = Color3.fromRGB(110, 110, 118),
        Acc = Color3.fromRGB(40, 40, 48), AccD = Color3.fromRGB(80, 80, 88),
        TOn = Color3.fromRGB(28, 28, 34), TOff = Color3.fromRGB(188, 188, 194), Slider = Color3.fromRGB(48, 48, 56),
        BgTr = 0.08, ElTr = 0.3, SbTr = 0.12
    },
    ["Obsidian"] = {
        Bg = Color3.fromRGB(2, 2, 4), Bg2 = Color3.fromRGB(6, 6, 10), Bg3 = Color3.fromRGB(14, 14, 18),
        El = Color3.fromRGB(10, 10, 14), ElHov = Color3.fromRGB(22, 22, 26), Border = Color3.fromRGB(32, 32, 38),
        Txt = Color3.fromRGB(228, 228, 232), Txt2 = Color3.fromRGB(138, 138, 148), Txt3 = Color3.fromRGB(88, 88, 98),
        Acc = Color3.fromRGB(172, 172, 185), AccD = Color3.fromRGB(122, 122, 135),
        TOn = Color3.fromRGB(182, 182, 195), TOff = Color3.fromRGB(38, 38, 44), Slider = Color3.fromRGB(162, 162, 175),
        BgTr = 0.06, ElTr = 0.34, SbTr = 0.12
    }
}

local T = Themes["AMOLED"]

local function Tw(i, p, d, s, dir)
    if not i or not i.Parent then return end
    return TweenService:Create(i, TweenInfo.new(d or 0.25, s or Enum.EasingStyle.Quart, dir or Enum.EasingDirection.Out), p):Play()
end

local function C(cls, pr)
    local i = Instance.new(cls)
    if pr then
        for k, v in pairs(pr) do
            if k ~= "Parent" then pcall(function() i[k] = v end) end
        end
        if pr.Parent then i.Parent = pr.Parent end
    end
    return i
end

local function Cn(p, r) return C("UICorner", {CornerRadius = UDim.new(0, r or 8), Parent = p}) end
local function St(p, c, t, tr) return C("UIStroke", {Color = c or T.Border, Thickness = t or 1, Transparency = tr or 0.45, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = p}) end
local function Pd(p, t, b, l, r) return C("UIPadding", {PaddingTop = UDim.new(0, t or 0), PaddingBottom = UDim.new(0, b or 0), PaddingLeft = UDim.new(0, l or 0), PaddingRight = UDim.new(0, r or 0), Parent = p}) end

local function B(inst, map)
    table.insert(AllBinds, {I = inst, M = map})
    if map.__Init then
        for prop, key in pairs(map) do
            if prop ~= "__Init" and T[key] ~= nil then
                pcall(function() inst[prop] = T[key] end)
            end
        end
    end
end

local function FullApply()
    for i = #AllBinds, 1, -1 do
        local b = AllBinds[i]
        if not b.I or not b.I.Parent then
            table.remove(AllBinds, i)
        else
            for prop, key in pairs(b.M) do
                if prop ~= "__Init" and T[key] ~= nil then
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
end

local function Drag(frame, handle)
    local dr, di, ds, sp = false, nil, nil, nil
    handle = handle or frame
    handle.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dr = true; ds = i.Position; sp = frame.Position
            i.Changed:Connect(function() if i.UserInputState == Enum.UserInputState.End then dr = false end end)
        end
    end)
    handle.InputChanged:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then di = i end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if i == di and dr then
            local d = i.Position - ds
            Tw(frame, {Position = UDim2.new(sp.X.Scale, sp.X.Offset + d.X, sp.Y.Scale, sp.Y.Offset + d.Y)}, 0.04)
        end
    end)
end

local function SetupGui()
    if ScreenGui and ScreenGui.Parent then return ScreenGui end
    local p = CoreGui
    pcall(function()
        if syn and syn.protect_gui then
            local g = C("ScreenGui", {Name = "Wraith", ZIndexBehavior = Enum.ZIndexBehavior.Sibling, ResetOnSpawn = false, IgnoreGuiInset = true, DisplayOrder = 999})
            syn.protect_gui(g); g.Parent = p; ScreenGui = g
        end
    end)
    if not ScreenGui then
        pcall(function() if gethui then p = gethui() end end)
        ScreenGui = C("ScreenGui", {Name = "Wraith", ZIndexBehavior = Enum.ZIndexBehavior.Sibling, ResetOnSpawn = false, IgnoreGuiInset = true, DisplayOrder = 999, Parent = p})
    end
    return ScreenGui
end

local function EnsureFolder()
    pcall(function()
        if not isfolder("Wraith") then makefolder("Wraith") end
        if not isfolder("Wraith/Icons") then makefolder("Wraith/Icons") end
        if not isfolder("Wraith/configs") then makefolder("Wraith/configs") end
    end)
end

local function LoadIcons(platform)
    platform = platform or "Lucide"
    CurrentIconPlatform = platform
    EnsureFolder()
    local cachePath = "Wraith/Icons/" .. platform .. ".json"
    local data
    pcall(function()
        if isfile(cachePath) then
            local raw = readfile(cachePath)
            if raw and #raw > 50 then
                data = HttpService:JSONDecode(raw)
            end
        end
    end)
    if data and next(data) then LoadedIcons = data; return end
    local url = PlatformURLs[platform]
    if not url then LoadedIcons = {}; return end
    local s, r = pcall(function() return game:HttpGet(url) end)
    if s and r and #r > 50 then
        local ok, d = pcall(function() return HttpService:JSONDecode(r) end)
        if ok and d then
            LoadedIcons = d
            pcall(function() writefile(cachePath, r) end)
        else LoadedIcons = {} end
    else LoadedIcons = {} end
end

local function GetIcon(name)
    if not LoadedIcons or not name then return nil end
    local d = LoadedIcons[name]
    if d then return d end
    if LoadedIcons.icons and LoadedIcons.icons[name] then
        return LoadedIcons.icons[name]
    end
    return nil
end

local SaveMgr = {Folder = "Wraith", CfgFolder = "Wraith/configs"}
function SaveMgr:Ensure() EnsureFolder() end
function SaveMgr:Save(n)
    self:Ensure()
    local d = {}
    for f, e in pairs(WraithFlags) do
        if type(e) == "table" and e.Save ~= false then
            if e.Type == "Colorpicker" then d[f] = {R = e.Value.R, G = e.Value.G, B = e.Value.B}
            elseif e.Type == "Keybind" then d[f] = e.Value and e.Value.Name or nil
            else d[f] = e.Value end
        end
    end
    pcall(function() writefile(self.CfgFolder .. "/" .. n .. ".json", HttpService:JSONEncode(d)) end)
end
function SaveMgr:Load(n)
    self:Ensure()
    local s, c = pcall(function() return readfile(self.CfgFolder .. "/" .. n .. ".json") end)
    if s and c then
        local ok, d = pcall(function() return HttpService:JSONDecode(c) end)
        if ok and d then
            for f, v in pairs(d) do
                if WraithFlags[f] and WraithFlags[f].Set then
                    pcall(function()
                        if WraithFlags[f].Type == "Colorpicker" and type(v) == "table" then WraithFlags[f]:Set(Color3.new(v.R, v.G, v.B))
                        elseif WraithFlags[f].Type == "Keybind" and type(v) == "string" then WraithFlags[f]:Set(Enum.KeyCode[v])
                        else WraithFlags[f]:Set(v) end
                    end)
                end
            end
        end
    end
end
function SaveMgr:Delete(n) pcall(function() delfile(self.CfgFolder .. "/" .. n .. ".json") end) end

Wraith.SaveManager = SaveMgr
Wraith.Flags = WraithFlags
Wraith.Themes = Themes

function Wraith:SetTheme(name)
    if Themes[name] then T = Themes[name]; FullApply() end
end

function Wraith:Notify(o)
    o = o or {}
    local gui = SetupGui()
    local h = gui:FindFirstChild("WN")
    if not h then
        h = C("Frame", {Name = "WN", Size = UDim2.new(0, 300, 1, 0), Position = UDim2.new(1, -315, 0, 0), BackgroundTransparency = 1, Parent = gui})
        C("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 5), VerticalAlignment = Enum.VerticalAlignment.Bottom, HorizontalAlignment = Enum.HorizontalAlignment.Center, Parent = h})
        Pd(h, 0, 14, 0, 0)
    end
    local nf = C("Frame", {Size = UDim2.new(1, 0, 0, 0), BackgroundColor3 = T.Bg2, BackgroundTransparency = 0.04, ClipsDescendants = true, Parent = h})
    Cn(nf, 10); St(nf, T.Border, 1, 0.3)
    B(nf, {BackgroundColor3 = "Bg2"})
    local nc = C("Frame", {Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Parent = nf}); Pd(nc, 10, 10, 12, 12)
    local tl = C("TextLabel", {Size = UDim2.new(1, 0, 0, 16), BackgroundTransparency = 1, Text = o.Title or "Wraith", TextColor3 = T.Txt, TextSize = 13, Font = Enum.Font.GothamBold, TextXAlignment = Enum.TextXAlignment.Left, Parent = nc})
    B(tl, {TextColor3 = "Txt"})
    local cl = C("TextLabel", {Size = UDim2.new(1, 0, 0, 0), Position = UDim2.new(0, 0, 0, 18), BackgroundTransparency = 1, Text = o.Content or "", TextColor3 = T.Txt2, TextSize = 11, Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Left, TextWrapped = true, AutomaticSize = Enum.AutomaticSize.Y, Parent = nc})
    B(cl, {TextColor3 = "Txt2"})
    local sl
    if (o.SubContent or "") ~= "" then
        sl = C("TextLabel", {Size = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1, Text = o.SubContent, TextColor3 = T.Txt3, TextSize = 10, Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Left, TextWrapped = true, AutomaticSize = Enum.AutomaticSize.Y, Parent = nc})
        B(sl, {TextColor3 = "Txt3"})
    end
    local pb = C("Frame", {Size = UDim2.new(1, 0, 0, 2), Position = UDim2.new(0, 0, 1, -2), BackgroundColor3 = T.Acc, BorderSizePixel = 0, Parent = nf})
    B(pb, {BackgroundColor3 = "Acc"})
    local dur = o.Duration or 5
    task.defer(function()
        task.wait(0.05)
        local ht = 18 + 18
        if cl then ht = ht + cl.AbsoluteSize.Y end
        if sl then ht = ht + sl.AbsoluteSize.Y + 3; sl.Position = UDim2.new(0, 0, 0, 18 + cl.AbsoluteSize.Y + 2) end
        ht = math.max(ht, 48)
        Tw(nf, {Size = UDim2.new(1, 0, 0, ht)}, 0.3)
        Tw(pb, {Size = UDim2.new(0, 0, 0, 2)}, dur, Enum.EasingStyle.Linear)
        task.wait(dur)
        Tw(nf, {Size = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1}, 0.3)
        task.wait(0.35); nf:Destroy()
    end)
end

function Wraith:Dialog(o)
    o = o or {}
    local gui = SetupGui()
    local ov = C("Frame", {Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = Color3.new(0, 0, 0), BackgroundTransparency = 0.4, ZIndex = 100, Parent = gui})
    local df = C("Frame", {Size = UDim2.new(0, 360, 0, 0), Position = UDim2.new(0.5, -180, 0.5, 0), AnchorPoint = Vector2.new(0, 0.5), BackgroundColor3 = T.Bg2, BackgroundTransparency = 0.02, ZIndex = 101, ClipsDescendants = true, Parent = gui})
    Cn(df, 14); St(df, T.Border, 1, 0.3)
    B(df, {BackgroundColor3 = "Bg2"})
    local dc = C("Frame", {Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, ZIndex = 102, Parent = df}); Pd(dc, 20, 20, 20, 20)
    local dtl = C("TextLabel", {Size = UDim2.new(1, 0, 0, 18), BackgroundTransparency = 1, Text = o.Title or "Dialog", TextColor3 = T.Txt, TextSize = 15, Font = Enum.Font.GothamBold, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 102, Parent = dc})
    B(dtl, {TextColor3 = "Txt"})
    local dcl = C("TextLabel", {Size = UDim2.new(1, 0, 0, 0), Position = UDim2.new(0, 0, 0, 26), BackgroundTransparency = 1, Text = o.Content or "", TextColor3 = T.Txt2, TextSize = 12, Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Left, TextWrapped = true, AutomaticSize = Enum.AutomaticSize.Y, ZIndex = 102, Parent = dc})
    B(dcl, {TextColor3 = "Txt2"})
    local bh = C("Frame", {Size = UDim2.new(1, 0, 0, 32), Position = UDim2.new(0, 0, 1, -32), BackgroundTransparency = 1, ZIndex = 102, Parent = dc})
    C("UIListLayout", {FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 8), HorizontalAlignment = Enum.HorizontalAlignment.Right, Parent = bh})
    local ev = Instance.new("BindableEvent")
    for i, bd in ipairs(o.Buttons or {}) do
        local pr = (i == #(o.Buttons or {}))
        local bb = C("TextButton", {Size = UDim2.new(0, 90, 0, 28), BackgroundColor3 = pr and T.Acc or T.El, Text = bd.Title or "OK", TextColor3 = pr and T.Bg or T.Txt, TextSize = 11, Font = Enum.Font.GothamSemibold, ZIndex = 103, AutoButtonColor = false, Parent = bh})
        Cn(bb, 7)
        if pr then B(bb, {BackgroundColor3 = "Acc", TextColor3 = "Bg"}) else B(bb, {BackgroundColor3 = "El", TextColor3 = "Txt"}) end
        bb.MouseButton1Click:Connect(function()
            Tw(df, {Size = UDim2.new(0, 360, 0, 0)}, 0.2); Tw(ov, {BackgroundTransparency = 1}, 0.2)
            task.wait(0.25); df:Destroy(); ov:Destroy()
            if bd.Callback then bd.Callback() end; ev:Fire(bd.Title)
        end)
    end
    task.defer(function()
        task.wait(0.05)
        local ht = 26 + dcl.AbsoluteSize.Y + 32 + 42 + 20
        Tw(df, {Size = UDim2.new(0, 360, 0, math.max(ht, 130))}, 0.3, Enum.EasingStyle.Back)
    end)
    return ev.Event:Wait()
end

local function ColorDialog(curCol, cb)
    local gui = SetupGui()
    local hue, sat, val = curCol:ToHSV()
    local tmp = curCol
    local ov = C("Frame", {Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = Color3.new(0, 0, 0), BackgroundTransparency = 0.45, ZIndex = 200, Parent = gui})
    local df = C("Frame", {Size = UDim2.new(0, 290, 0, 0), Position = UDim2.new(0.5, -145, 0.5, 0), AnchorPoint = Vector2.new(0, 0.5), BackgroundColor3 = T.Bg2, BackgroundTransparency = 0.02, ZIndex = 201, ClipsDescendants = true, Parent = gui})
    Cn(df, 14); St(df, T.Border, 1, 0.3)
    B(df, {BackgroundColor3 = "Bg2"})
    local top = C("Frame", {Size = UDim2.new(1, 0, 0, 38), BackgroundColor3 = T.Bg2, BackgroundTransparency = 0, ZIndex = 202, Parent = df})
    Cn(top, 14)
    B(top, {BackgroundColor3 = "Bg2"})
    C("Frame", {Size = UDim2.new(1, 0, 0, 14), Position = UDim2.new(0, 0, 1, -14), BackgroundColor3 = T.Bg2, ZIndex = 202, Parent = top, BorderSizePixel = 0, BackgroundTransparency = 0})
    local ttl = C("TextLabel", {Size = UDim2.new(1, -16, 1, 0), Position = UDim2.new(0, 12, 0, 0), BackgroundTransparency = 1, Text = "Color Picker", TextColor3 = T.Txt, TextSize = 13, Font = Enum.Font.GothamBold, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 203, Parent = top})
    B(ttl, {TextColor3 = "Txt"})
    Drag(df, top)
    local ct = C("Frame", {Size = UDim2.new(1, -24, 1, -50), Position = UDim2.new(0, 12, 0, 44), BackgroundTransparency = 1, ZIndex = 202, Parent = df})
    local sv = C("Frame", {Size = UDim2.new(1, -30, 0, 130), BackgroundColor3 = Color3.fromHSV(hue, 1, 1), ZIndex = 203, Parent = ct})
    Cn(sv, 7)
    C("UIGradient", {Color = ColorSequence.new(Color3.new(1, 1, 1), Color3.new(1, 1, 1)), Transparency = NumberSequence.new(0, 1), Parent = sv})
    local bo = C("Frame", {Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = Color3.new(0, 0, 0), ZIndex = 204, Parent = sv}); Cn(bo, 7)
    C("UIGradient", {Color = ColorSequence.new(Color3.new(0, 0, 0), Color3.new(0, 0, 0)), Transparency = NumberSequence.new(1, 0), Rotation = 90, Parent = bo})
    local svc = C("Frame", {Size = UDim2.new(0, 12, 0, 12), Position = UDim2.new(sat, -6, 1 - val, -6), BackgroundColor3 = Color3.new(1, 1, 1), ZIndex = 206, Parent = sv}); Cn(svc, 6); St(svc, Color3.new(0, 0, 0), 2, 0.2)
    local hb = C("Frame", {Size = UDim2.new(0, 18, 0, 130), Position = UDim2.new(1, -18, 0, 0), BackgroundColor3 = Color3.new(1, 1, 1), ZIndex = 203, Parent = ct}); Cn(hb, 5)
    C("UIGradient", {Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromHSV(0, 1, 1)), ColorSequenceKeypoint.new(0.167, Color3.fromHSV(0.167, 1, 1)),
        ColorSequenceKeypoint.new(0.333, Color3.fromHSV(0.333, 1, 1)), ColorSequenceKeypoint.new(0.5, Color3.fromHSV(0.5, 1, 1)),
        ColorSequenceKeypoint.new(0.667, Color3.fromHSV(0.667, 1, 1)), ColorSequenceKeypoint.new(0.833, Color3.fromHSV(0.833, 1, 1)),
        ColorSequenceKeypoint.new(1, Color3.fromHSV(1, 1, 1))
    }), Rotation = 90, Parent = hb})
    local hc = C("Frame", {Size = UDim2.new(1, 4, 0, 5), Position = UDim2.new(0, -2, hue, -2), BackgroundColor3 = Color3.new(1, 1, 1), ZIndex = 206, Parent = hb}); Cn(hc, 2); St(hc, Color3.new(0, 0, 0), 1, 0.3)
    local pr = C("Frame", {Size = UDim2.new(1, 0, 0, 28), Position = UDim2.new(0, 0, 0, 136), BackgroundTransparency = 1, ZIndex = 203, Parent = ct})
    local pvb = C("Frame", {Size = UDim2.new(0, 28, 0, 28), BackgroundColor3 = tmp, ZIndex = 204, Parent = pr}); Cn(pvb, 6); St(pvb, T.Border, 1, 0.4)
    local hx = C("TextBox", {Size = UDim2.new(1, -36, 0, 28), Position = UDim2.new(0, 34, 0, 0), BackgroundColor3 = T.Bg3, Text = "#" .. tmp:ToHex():upper(), TextColor3 = T.Txt, TextSize = 11, Font = Enum.Font.GothamSemibold, ClearTextOnFocus = false, ZIndex = 204, Parent = pr})
    Cn(hx, 6); Pd(hx, 0, 0, 7, 7); St(hx, T.Border, 1, 0.45)
    B(hx, {BackgroundColor3 = "Bg3", TextColor3 = "Txt"})
    local br = C("Frame", {Size = UDim2.new(1, 0, 0, 30), Position = UDim2.new(0, 0, 0, 170), BackgroundTransparency = 1, ZIndex = 203, Parent = ct})
    C("UIListLayout", {FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 7), HorizontalAlignment = Enum.HorizontalAlignment.Right, Parent = br})
    local canBtn = C("TextButton", {Size = UDim2.new(0, 80, 0, 28), BackgroundColor3 = T.El, Text = "Cancel", TextColor3 = T.Txt, TextSize = 11, Font = Enum.Font.GothamSemibold, AutoButtonColor = false, ZIndex = 204, LayoutOrder = 1, Parent = br})
    Cn(canBtn, 7)
    B(canBtn, {BackgroundColor3 = "El", TextColor3 = "Txt"})
    local okBtn = C("TextButton", {Size = UDim2.new(0, 80, 0, 28), BackgroundColor3 = T.Acc, Text = "Apply", TextColor3 = T.Bg, TextSize = 11, Font = Enum.Font.GothamSemibold, AutoButtonColor = false, ZIndex = 204, LayoutOrder = 2, Parent = br})
    Cn(okBtn, 7)
    B(okBtn, {BackgroundColor3 = "Acc", TextColor3 = "Bg"})
    local function upd()
        tmp = Color3.fromHSV(math.clamp(hue, 0, 0.999), sat, val)
        pvb.BackgroundColor3 = tmp; sv.BackgroundColor3 = Color3.fromHSV(math.clamp(hue, 0, 0.999), 1, 1)
        svc.Position = UDim2.new(sat, -6, 1 - val, -6); hc.Position = UDim2.new(0, -2, hue, -2)
        hx.Text = "#" .. tmp:ToHex():upper()
    end
    local dSV, dH = false, false
    local svb = C("TextButton", {Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "", ZIndex = 207, Parent = sv})
    local hbb = C("TextButton", {Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "", ZIndex = 207, Parent = hb})
    svb.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dSV = true; sat = math.clamp((i.Position.X - sv.AbsolutePosition.X) / sv.AbsoluteSize.X, 0, 1)
            val = 1 - math.clamp((i.Position.Y - sv.AbsolutePosition.Y) / sv.AbsoluteSize.Y, 0, 1); upd()
        end
    end)
    svb.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dSV = false end end)
    hbb.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dH = true; hue = math.clamp((i.Position.Y - hb.AbsolutePosition.Y) / hb.AbsoluteSize.Y, 0, 0.999); upd()
        end
    end)
    hbb.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dH = false end end)
    UserInputService.InputChanged:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then
            if dSV then sat = math.clamp((i.Position.X - sv.AbsolutePosition.X) / sv.AbsoluteSize.X, 0, 1); val = 1 - math.clamp((i.Position.Y - sv.AbsolutePosition.Y) / sv.AbsoluteSize.Y, 0, 1); upd()
            elseif dH then hue = math.clamp((i.Position.Y - hb.AbsolutePosition.Y) / hb.AbsoluteSize.Y, 0, 0.999); upd() end
        end
    end)
    hx.FocusLost:Connect(function()
        local ok, c = pcall(function() return Color3.fromHex("#" .. hx.Text:gsub("#", "")) end)
        if ok and c then hue, sat, val = c:ToHSV(); upd() else hx.Text = "#" .. tmp:ToHex():upper() end
    end)
    local closed = false
    local function cls()
        if closed then return end; closed = true
        Tw(df, {Size = UDim2.new(0, 290, 0, 0)}, 0.2); Tw(ov, {BackgroundTransparency = 1}, 0.2)
        task.wait(0.25); df:Destroy(); ov:Destroy()
    end
    canBtn.MouseButton1Click:Connect(cls)
    okBtn.MouseButton1Click:Connect(function() cls(); cb(tmp) end)
    ov.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then cls() end end)
    task.defer(function() task.wait(0.05); Tw(df, {Size = UDim2.new(0, 290, 0, 280)}, 0.3, Enum.EasingStyle.Back) end)
end

function Wraith:CreateWindow(o)
    o = o or {}
    local wT = o.Title or "Wraith"
    local wS = o.SubTitle or ""
    local wSz = o.Size or UDim2.new(0, 620, 0, 460)
    local mK = o.MinimizeKey or Enum.KeyCode.LeftControl
    local tW = o.TabWidth or 170
    local gui = SetupGui()
    local W = {Tabs = {}, ActiveTab = nil, Min = false, Vis = true, Gui = gui}

    local main = C("Frame", {Name = "WM", Size = wSz, Position = UDim2.new(0.5, -(wSz.X.Offset / 2), 0.5, -(wSz.Y.Offset / 2)), BackgroundColor3 = T.Bg, BackgroundTransparency = T.BgTr, ClipsDescendants = true, Parent = gui})
    Cn(main, 14); St(main, T.Border, 1, 0.2)
    B(main, {BackgroundColor3 = "Bg", BackgroundTransparency = "BgTr"})

    local tb = C("Frame", {Size = UDim2.new(1, 0, 0, 48), BackgroundColor3 = T.Bg2, BackgroundTransparency = 0.05, BorderSizePixel = 0, ZIndex = 3, Parent = main})
    Cn(tb, 14)
    B(tb, {BackgroundColor3 = "Bg2"})
    local tbFix = C("Frame", {Size = UDim2.new(1, 0, 0, 14), Position = UDim2.new(0, 0, 1, -14), BackgroundColor3 = T.Bg2, BackgroundTransparency = 0.05, BorderSizePixel = 0, ZIndex = 3, Parent = tb})
    B(tbFix, {BackgroundColor3 = "Bg2"})

    local lbg = C("Frame", {Size = UDim2.new(0, 32, 0, 32), Position = UDim2.new(0, 10, 0, 8), BackgroundColor3 = T.El, BackgroundTransparency = 0.15, ZIndex = 4, Parent = tb})
    Cn(lbg, 8)
    B(lbg, {BackgroundColor3 = "El"})
    local lt = C("TextLabel", {Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "W", TextColor3 = T.Txt, TextSize = 18, Font = Enum.Font.GothamBold, ZIndex = 5, Parent = lbg})
    B(lt, {TextColor3 = "Txt"})
    local ttl = C("TextLabel", {Size = UDim2.new(0, 200, 0, 18), Position = UDim2.new(0, 50, 0, 8), BackgroundTransparency = 1, Text = wT, TextColor3 = T.Txt, TextSize = 14, Font = Enum.Font.GothamBold, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 4, Parent = tb})
    B(ttl, {TextColor3 = "Txt"})
    local stl = C("TextLabel", {Size = UDim2.new(0, 200, 0, 12), Position = UDim2.new(0, 50, 0, 27), BackgroundTransparency = 1, Text = wS, TextColor3 = T.Txt3, TextSize = 10, Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 4, Parent = tb})
    B(stl, {TextColor3 = "Txt3"})

    local cf = C("Frame", {Size = UDim2.new(0, 66, 0, 26), Position = UDim2.new(1, -78, 0, 11), BackgroundTransparency = 1, ZIndex = 4, Parent = tb})
    C("UIListLayout", {FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 5), HorizontalAlignment = Enum.HorizontalAlignment.Right, VerticalAlignment = Enum.VerticalAlignment.Center, Parent = cf})
    local mb = C("TextButton", {Size = UDim2.new(0, 26, 0, 26), BackgroundColor3 = T.El, BackgroundTransparency = 0.15, Text = "", AutoButtonColor = false, LayoutOrder = 1, ZIndex = 5, Parent = cf}); Cn(mb, 7)
    B(mb, {BackgroundColor3 = "El"})
    local ml = C("Frame", {Size = UDim2.new(0, 10, 0, 2), Position = UDim2.new(0.5, -5, 0.5, -1), BackgroundColor3 = T.Txt2, BorderSizePixel = 0, ZIndex = 6, Parent = mb})
    B(ml, {BackgroundColor3 = "Txt2"})
    local xb = C("TextButton", {Size = UDim2.new(0, 26, 0, 26), BackgroundColor3 = T.El, BackgroundTransparency = 0.15, Text = "", AutoButtonColor = false, LayoutOrder = 2, ZIndex = 5, Parent = cf}); Cn(xb, 7)
    B(xb, {BackgroundColor3 = "El"})
    local x1 = C("Frame", {Size = UDim2.new(0, 10, 0, 2), Position = UDim2.new(0.5, -5, 0.5, -1), BackgroundColor3 = T.Txt2, Rotation = 45, ZIndex = 6, Parent = xb})
    B(x1, {BackgroundColor3 = "Txt2"})
    local x2 = C("Frame", {Size = UDim2.new(0, 10, 0, 2), Position = UDim2.new(0.5, -5, 0.5, -1), BackgroundColor3 = T.Txt2, Rotation = -45, ZIndex = 6, Parent = xb})
    B(x2, {BackgroundColor3 = "Txt2"})

    mb.MouseEnter:Connect(function() Tw(mb, {BackgroundTransparency = 0}, 0.1) end)
    mb.MouseLeave:Connect(function() Tw(mb, {BackgroundTransparency = 0.15}, 0.1) end)
    xb.MouseEnter:Connect(function() Tw(xb, {BackgroundColor3 = Color3.fromRGB(170, 42, 42), BackgroundTransparency = 0}, 0.1) end)
    xb.MouseLeave:Connect(function() Tw(xb, {BackgroundColor3 = T.El, BackgroundTransparency = 0.15}, 0.1) end)

    mb.MouseButton1Click:Connect(function()
        W.Min = not W.Min
        if W.Min then
            Tw(main, {Size = UDim2.new(0, wSz.X.Offset, 0, 0), BackgroundTransparency = 1}, 0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
            task.wait(0.42); main.Visible = false
        else
            main.Visible = true
            main.Size = UDim2.new(0, wSz.X.Offset, 0, 0)
            main.BackgroundTransparency = 1
            Tw(main, {Size = wSz, BackgroundTransparency = T.BgTr}, 0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        end
    end)
    xb.MouseButton1Click:Connect(function()
        W.Vis = false
        Tw(main, {Size = UDim2.new(0, wSz.X.Offset, 0, 0), BackgroundTransparency = 1}, 0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
        task.wait(0.45); main.Visible = false
    end)
    Drag(main, tb)

    local ca = C("Frame", {Size = UDim2.new(1, 0, 1, -48), Position = UDim2.new(0, 0, 0, 48), BackgroundTransparency = 1, ClipsDescendants = true, Parent = main})

    local sb = C("Frame", {Size = UDim2.new(0, tW, 1, 0), BackgroundColor3 = T.Bg2, BackgroundTransparency = T.SbTr, BorderSizePixel = 0, Parent = ca})
    Cn(sb, 14)
    B(sb, {BackgroundColor3 = "Bg2", BackgroundTransparency = "SbTr"})
    local sbFixR = C("Frame", {Size = UDim2.new(0, 14, 1, 0), Position = UDim2.new(1, -14, 0, 0), BackgroundColor3 = T.Bg2, BackgroundTransparency = T.SbTr, BorderSizePixel = 0, Parent = sb})
    B(sbFixR, {BackgroundColor3 = "Bg2", BackgroundTransparency = "SbTr"})
    local sbFixT = C("Frame", {Size = UDim2.new(1, 0, 0, 14), Position = UDim2.new(0, 0, 0, 0), BackgroundColor3 = T.Bg2, BackgroundTransparency = T.SbTr, BorderSizePixel = 0, Parent = sb})
    B(sbFixT, {BackgroundColor3 = "Bg2", BackgroundTransparency = "SbTr"})

    local tl = C("ScrollingFrame", {Size = UDim2.new(1, -12, 1, -12), Position = UDim2.new(0, 6, 0, 6), BackgroundTransparency = 1, ScrollBarThickness = 2, ScrollBarImageColor3 = T.Border, CanvasSize = UDim2.new(0, 0, 0, 0), AutomaticCanvasSize = Enum.AutomaticSize.Y, Parent = sb})
    C("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 3), Parent = tl})
    local ph = C("Frame", {Size = UDim2.new(1, -tW, 1, 0), Position = UDim2.new(0, tW, 0, 0), BackgroundTransparency = 1, ClipsDescendants = true, Parent = ca})

    UserInputService.InputBegan:Connect(function(i, g)
        if g then return end
        if i.KeyCode == mK then
            W.Vis = not W.Vis
            if W.Vis then
                main.Visible = true
                main.Size = UDim2.new(0, wSz.X.Offset, 0, 0)
                main.BackgroundTransparency = 1
                Tw(main, {Size = wSz, BackgroundTransparency = T.BgTr}, 0.4, Enum.EasingStyle.Back)
                W.Min = false
            else
                Tw(main, {Size = UDim2.new(0, wSz.X.Offset, 0, 0), BackgroundTransparency = 1}, 0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
                task.wait(0.45); main.Visible = false
            end
        end
    end)

    function W:SelectTab(tab)
        if self.ActiveTab == tab then return end
        if self.ActiveTab then
            Tw(self.ActiveTab.Btn, {BackgroundColor3 = T.Bg2, BackgroundTransparency = 1}, 0.2)
            Tw(self.ActiveTab.Lbl, {TextColor3 = T.Txt2}, 0.2)
            if self.ActiveTab.Ico then Tw(self.ActiveTab.Ico, {ImageColor3 = T.Txt2}, 0.2) end
            if self.ActiveTab.Ind then Tw(self.ActiveTab.Ind, {BackgroundTransparency = 1}, 0.15) end
            self.ActiveTab.Pg.Visible = false
        end
        self.ActiveTab = tab
        Tw(tab.Btn, {BackgroundColor3 = T.El, BackgroundTransparency = T.ElTr * 0.5}, 0.2)
        Tw(tab.Lbl, {TextColor3 = T.Txt}, 0.2)
        if tab.Ico then Tw(tab.Ico, {ImageColor3 = T.Txt}, 0.2) end
        if tab.Ind then Tw(tab.Ind, {BackgroundTransparency = 0}, 0.15) end
        tab.Pg.Visible = true
    end

    function W:AddTab(o2)
        o2 = o2 or {}
        local n = o2.Title or o2.Name or "Tab"
        local ic = o2.Icon
        local tab = {Name = n}
        local btn = C("TextButton", {Size = UDim2.new(1, 0, 0, 34), BackgroundColor3 = T.Bg2, BackgroundTransparency = 1, Text = "", AutoButtonColor = false, Parent = tl})
        Cn(btn, 7)
        local ind = C("Frame", {Size = UDim2.new(0, 3, 0, 16), Position = UDim2.new(0, 0, 0.5, -8), BackgroundColor3 = T.Acc, BackgroundTransparency = 1, BorderSizePixel = 0, Parent = btn}); Cn(ind, 2)
        B(ind, {BackgroundColor3 = "Acc"})
        tab.Ind = ind
        local iOff = 0
        if ic then
            local img = C("ImageLabel", {Size = UDim2.new(0, 16, 0, 16), Position = UDim2.new(0, 11, 0.5, -8), BackgroundTransparency = 1, ImageColor3 = T.Txt2, Parent = btn})
            local iD = GetIcon(ic)
            if iD then
                if type(iD) == "string" then img.Image = iD
                elseif type(iD) == "number" then img.Image = "rbxassetid://" .. tostring(iD)
                elseif type(iD) == "table" and iD.Image then img.Image = iD.Image; if iD.ImageRectOffset then img.ImageRectOffset = Vector2.new(iD.ImageRectOffset[1] or 0, iD.ImageRectOffset[2] or 0) end; if iD.ImageRectSize then img.ImageRectSize = Vector2.new(iD.ImageRectSize[1] or 0, iD.ImageRectSize[2] or 0) end end
            end
            iOff = 32; tab.Ico = img
            B(img, {ImageColor3 = "Txt2"})
        end
        local lbl = C("TextLabel", {Size = UDim2.new(1, -(10 + iOff), 0, 34), Position = UDim2.new(0, iOff + 12, 0, 0), BackgroundTransparency = 1, Text = n, TextColor3 = T.Txt2, TextSize = 12, Font = Enum.Font.GothamSemibold, TextXAlignment = Enum.TextXAlignment.Left, Parent = btn})
        B(lbl, {TextColor3 = "Txt2"})
        tab.Btn = btn; tab.Lbl = lbl
        btn.MouseEnter:Connect(function() if self.ActiveTab ~= tab then Tw(btn, {BackgroundTransparency = 0.45}, 0.1) end end)
        btn.MouseLeave:Connect(function() if self.ActiveTab ~= tab then Tw(btn, {BackgroundTransparency = 1}, 0.1) end end)
        btn.MouseButton1Click:Connect(function() self:SelectTab(tab) end)
        local pg = C("ScrollingFrame", {Size = UDim2.new(1, -18, 1, -18), Position = UDim2.new(0, 9, 0, 9), BackgroundTransparency = 1, ScrollBarThickness = 2, ScrollBarImageColor3 = T.Border, CanvasSize = UDim2.new(0, 0, 0, 0), AutomaticCanvasSize = Enum.AutomaticSize.Y, Visible = false, Parent = ph})
        C("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 6), Parent = pg})
        tab.Pg = pg
        table.insert(self.Tabs, tab)
        if #self.Tabs == 1 then self:SelectTab(tab) end

        function tab:AddParagraph(p)
            p = p or {}
            local c = C("Frame", {Size = UDim2.new(1, 0, 0, 0), BackgroundColor3 = T.El, BackgroundTransparency = T.ElTr, AutomaticSize = Enum.AutomaticSize.Y, Parent = pg})
            Cn(c, 10); St(c, T.Border, 1, 0.4); Pd(c, 12, 12, 14, 14)
            B(c, {BackgroundColor3 = "El", BackgroundTransparency = "ElTr"})
            C("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 2), Parent = c})
            if (p.Title or "") ~= "" then
                local t = C("TextLabel", {Size = UDim2.new(1, 0, 0, 15), BackgroundTransparency = 1, Text = p.Title, TextColor3 = T.Txt, TextSize = 13, Font = Enum.Font.GothamBold, TextXAlignment = Enum.TextXAlignment.Left, Parent = c})
                B(t, {TextColor3 = "Txt"})
            end
            local cl = C("TextLabel", {Size = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1, Text = p.Content or "", TextColor3 = T.Txt2, TextSize = 11, Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Left, TextWrapped = true, AutomaticSize = Enum.AutomaticSize.Y, Parent = c})
            B(cl, {TextColor3 = "Txt2"})
            return {Type = "Paragraph", Set = function(_, x) if x.Content then cl.Text = x.Content end end}
        end

        function tab:AddButton(p)
            p = p or {}
            local h = (p.Description or "") ~= "" and 52 or 38
            local c = C("Frame", {Size = UDim2.new(1, 0, 0, h), BackgroundColor3 = T.El, BackgroundTransparency = T.ElTr, Parent = pg})
            Cn(c, 10); St(c, T.Border, 1, 0.4)
            B(c, {BackgroundColor3 = "El", BackgroundTransparency = "ElTr"})
            local b = C("TextButton", {Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "", AutoButtonColor = false, Parent = c})
            local t = C("TextLabel", {Size = UDim2.new(1, -28, 0, 14), Position = UDim2.new(0, 14, 0, (p.Description or "") ~= "" and 9 or 12), BackgroundTransparency = 1, Text = p.Title or "Button", TextColor3 = T.Txt, TextSize = 12, Font = Enum.Font.GothamSemibold, TextXAlignment = Enum.TextXAlignment.Left, Parent = c})
            B(t, {TextColor3 = "Txt"})
            if (p.Description or "") ~= "" then
                local d = C("TextLabel", {Size = UDim2.new(1, -28, 0, 12), Position = UDim2.new(0, 14, 0, 26), BackgroundTransparency = 1, Text = p.Description, TextColor3 = T.Txt3, TextSize = 10, Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Left, Parent = c})
                B(d, {TextColor3 = "Txt3"})
            end
            b.MouseEnter:Connect(function() Tw(c, {BackgroundColor3 = T.ElHov}, 0.1) end)
            b.MouseLeave:Connect(function() Tw(c, {BackgroundColor3 = T.El}, 0.1) end)
            b.MouseButton1Click:Connect(function() Tw(c, {BackgroundColor3 = T.Bg3}, 0.05); task.wait(0.05); Tw(c, {BackgroundColor3 = T.El}, 0.1); if p.Callback then p.Callback() end end)
            return {Type = "Button"}
        end

        function tab:AddToggle(p)
            p = p or {}
            local h = (p.Description or "") ~= "" and 52 or 38
            local tog = p.Default or false
            local fl = p.Flag or p.Title or "Tog"
            local cb2 = p.Callback or function() end
            local c = C("Frame", {Size = UDim2.new(1, 0, 0, h), BackgroundColor3 = T.El, BackgroundTransparency = T.ElTr, Parent = pg})
            Cn(c, 10); St(c, T.Border, 1, 0.4)
            B(c, {BackgroundColor3 = "El", BackgroundTransparency = "ElTr"})
            local t = C("TextLabel", {Size = UDim2.new(1, -68, 0, 14), Position = UDim2.new(0, 14, 0, (p.Description or "") ~= "" and 9 or 12), BackgroundTransparency = 1, Text = p.Title or "Toggle", TextColor3 = T.Txt, TextSize = 12, Font = Enum.Font.GothamSemibold, TextXAlignment = Enum.TextXAlignment.Left, Parent = c})
            B(t, {TextColor3 = "Txt"})
            if (p.Description or "") ~= "" then
                local d = C("TextLabel", {Size = UDim2.new(1, -68, 0, 12), Position = UDim2.new(0, 14, 0, 26), BackgroundTransparency = 1, Text = p.Description, TextColor3 = T.Txt3, TextSize = 10, Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Left, Parent = c})
                B(d, {TextColor3 = "Txt3"})
            end
            local ot = C("Frame", {Size = UDim2.new(0, 38, 0, 20), Position = UDim2.new(1, -52, 0.5, -10), BackgroundColor3 = tog and T.TOn or T.TOff, Parent = c}); Cn(ot, 10)
            local inn = C("Frame", {Size = UDim2.new(0, 14, 0, 14), Position = tog and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7), BackgroundColor3 = tog and T.Bg or T.Txt2, Parent = ot}); Cn(inn, 7)
            local bt = C("TextButton", {Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "", AutoButtonColor = false, Parent = c})
            local el = {Type = "Toggle", Value = tog, Flag = fl, Save = p.Save ~= false}
            local function upd()
                Tw(ot, {BackgroundColor3 = tog and T.TOn or T.TOff}, 0.2)
                Tw(inn, {Position = tog and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7), BackgroundColor3 = tog and T.Bg or T.Txt2}, 0.2, Enum.EasingStyle.Back)
            end
            function el:Set(v) tog = v; el.Value = v; upd(); cb2(v) end
            bt.MouseButton1Click:Connect(function() tog = not tog; el.Value = tog; upd(); cb2(tog) end)
            WraithFlags[fl] = el; return el
        end

        function tab:AddSlider(p)
            p = p or {}
            local h = (p.Description or "") ~= "" and 70 or 52
            local mn, mx = p.Min or 0, p.Max or 100
            local def = p.Default or mn
            local rd = p.Rounding or 1
            local fl = p.Flag or p.Title or "Sl"
            local sf = p.Suffix or ""
            local cb2 = p.Callback or function() end
            local c = C("Frame", {Size = UDim2.new(1, 0, 0, h), BackgroundColor3 = T.El, BackgroundTransparency = T.ElTr, Parent = pg})
            Cn(c, 10); St(c, T.Border, 1, 0.4)
            B(c, {BackgroundColor3 = "El", BackgroundTransparency = "ElTr"})
            local t = C("TextLabel", {Size = UDim2.new(1, -80, 0, 14), Position = UDim2.new(0, 14, 0, (p.Description or "") ~= "" and 7 or 5), BackgroundTransparency = 1, Text = p.Title or "Slider", TextColor3 = T.Txt, TextSize = 12, Font = Enum.Font.GothamSemibold, TextXAlignment = Enum.TextXAlignment.Left, Parent = c})
            B(t, {TextColor3 = "Txt"})
            local vl = C("TextLabel", {Size = UDim2.new(0, 60, 0, 14), Position = UDim2.new(1, -74, 0, (p.Description or "") ~= "" and 7 or 5), BackgroundTransparency = 1, Text = tostring(def) .. sf, TextColor3 = T.Txt2, TextSize = 11, Font = Enum.Font.GothamSemibold, TextXAlignment = Enum.TextXAlignment.Right, Parent = c})
            B(vl, {TextColor3 = "Txt2"})
            if (p.Description or "") ~= "" then
                local d = C("TextLabel", {Size = UDim2.new(1, -28, 0, 12), Position = UDim2.new(0, 14, 0, 22), BackgroundTransparency = 1, Text = p.Description, TextColor3 = T.Txt3, TextSize = 10, Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Left, Parent = c})
                B(d, {TextColor3 = "Txt3"})
            end
            local bY = (p.Description or "") ~= "" and 44 or 28
            local bg = C("Frame", {Size = UDim2.new(1, -28, 0, 5), Position = UDim2.new(0, 14, 0, bY), BackgroundColor3 = T.Bg3, Parent = c}); Cn(bg, 2)
            B(bg, {BackgroundColor3 = "Bg3"})
            local iF = math.clamp((def - mn) / (mx - mn), 0, 1)
            local fl2 = C("Frame", {Size = UDim2.new(iF, 0, 1, 0), BackgroundColor3 = T.Slider, Parent = bg}); Cn(fl2, 2)
            B(fl2, {BackgroundColor3 = "Slider"})
            local kn = C("Frame", {Size = UDim2.new(0, 12, 0, 12), Position = UDim2.new(iF, -6, 0.5, -6), BackgroundColor3 = T.Txt, ZIndex = 3, Parent = bg}); Cn(kn, 6)
            B(kn, {BackgroundColor3 = "Txt"})
            local sb2 = C("TextButton", {Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "", AutoButtonColor = false, Parent = c})
            local dr = false
            local el = {Type = "Slider", Value = def, Flag = fl, Save = p.Save ~= false}
            local function up(i)
                local pp = math.clamp((i.Position.X - bg.AbsolutePosition.X) / bg.AbsoluteSize.X, 0, 1)
                local rv = math.floor((mn + (mx - mn) * pp) / rd + 0.5) * rd
                rv = math.clamp(rv, mn, mx); el.Value = rv
                local f = math.clamp((rv - mn) / (mx - mn), 0, 1)
                Tw(fl2, {Size = UDim2.new(f, 0, 1, 0)}, 0.03); Tw(kn, {Position = UDim2.new(f, -6, 0.5, -6)}, 0.03)
                vl.Text = tostring(rv) .. sf; cb2(rv)
            end
            function el:Set(v) v = math.clamp(v, mn, mx); v = math.floor(v / rd + 0.5) * rd; el.Value = v; local f = math.clamp((v - mn) / (mx - mn), 0, 1); Tw(fl2, {Size = UDim2.new(f, 0, 1, 0)}, 0.1); Tw(kn, {Position = UDim2.new(f, -6, 0.5, -6)}, 0.1); vl.Text = tostring(v) .. sf; cb2(v) end
            sb2.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dr = true; up(i) end end)
            sb2.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dr = false end end)
            UserInputService.InputChanged:Connect(function(i) if dr and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then up(i) end end)
            WraithFlags[fl] = el; return el
        end

        function tab:AddDropdown(p)
            p = p or {}
            local multi = p.Multi or false
            local vals = p.Values or {}
            local sel = multi and {} or p.Default
            local fl = p.Flag or p.Title or "DD"
            local cb2 = p.Callback or function() end
            local isO = false
            if multi and p.Default then if type(p.Default) == "table" then for _, v in ipairs(p.Default) do sel[v] = true end end end
            local ht = (p.Description or "") ~= "" and 68 or 50
            local c = C("Frame", {Size = UDim2.new(1, 0, 0, ht), BackgroundColor3 = T.El, BackgroundTransparency = T.ElTr, ClipsDescendants = true, Parent = pg})
            Cn(c, 10); St(c, T.Border, 1, 0.4)
            B(c, {BackgroundColor3 = "El", BackgroundTransparency = "ElTr"})
            local t = C("TextLabel", {Size = UDim2.new(1, -28, 0, 14), Position = UDim2.new(0, 14, 0, (p.Description or "") ~= "" and 7 or 5), BackgroundTransparency = 1, Text = p.Title or "Dropdown", TextColor3 = T.Txt, TextSize = 12, Font = Enum.Font.GothamSemibold, TextXAlignment = Enum.TextXAlignment.Left, Parent = c})
            B(t, {TextColor3 = "Txt"})
            if (p.Description or "") ~= "" then
                local d = C("TextLabel", {Size = UDim2.new(1, -28, 0, 12), Position = UDim2.new(0, 14, 0, 22), BackgroundTransparency = 1, Text = p.Description, TextColor3 = T.Txt3, TextSize = 10, Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Left, Parent = c})
                B(d, {TextColor3 = "Txt3"})
            end
            local dY = (p.Description or "") ~= "" and 40 or 24
            local db = C("TextButton", {Size = UDim2.new(1, -28, 0, 20), Position = UDim2.new(0, 14, 0, dY), BackgroundColor3 = T.Bg3, Text = "", AutoButtonColor = false, Parent = c})
            Cn(db, 5); St(db, T.Border, 1, 0.5)
            B(db, {BackgroundColor3 = "Bg3"})
            local function gD()
                if multi then local it = {}; for k, v in pairs(sel) do if v then table.insert(it, k) end end; return #it == 0 and "None" or table.concat(it, ", ")
                else return sel or "None" end
            end
            local dl = C("TextLabel", {Size = UDim2.new(1, -20, 1, 0), Position = UDim2.new(0, 7, 0, 0), BackgroundTransparency = 1, Text = gD(), TextColor3 = T.Txt2, TextSize = 10, Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd, Parent = db})
            B(dl, {TextColor3 = "Txt2"})
            local al = C("TextLabel", {Size = UDim2.new(0, 12, 1, 0), Position = UDim2.new(1, -16, 0, 0), BackgroundTransparency = 1, Text = "▼", TextColor3 = T.Txt3, TextSize = 8, Font = Enum.Font.Gotham, Parent = db})
            B(al, {TextColor3 = "Txt3"})
            local of = C("Frame", {Size = UDim2.new(1, -28, 0, 0), Position = UDim2.new(0, 14, 0, dY + 24), BackgroundTransparency = 1, ClipsDescendants = true, Parent = c})
            C("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 2), Parent = of})
            local el = {Type = multi and "MultiDropdown" or "Dropdown", Value = sel, Flag = fl, Save = p.Save ~= false}
            local function ref()
                for _, ch in ipairs(of:GetChildren()) do if ch:IsA("TextButton") then ch:Destroy() end end
                for _, v in ipairs(vals) do
                    local iS = multi and sel[v] or (sel == v)
                    local ob = C("TextButton", {Size = UDim2.new(1, 0, 0, 24), BackgroundColor3 = iS and T.ElHov or T.Bg3, BackgroundTransparency = iS and 0.1 or 0.3, Text = v, TextColor3 = iS and T.Txt or T.Txt2, TextSize = 10, Font = Enum.Font.Gotham, AutoButtonColor = false, Parent = of})
                    Cn(ob, 5)
                    if iS then B(ob, {BackgroundColor3 = "ElHov", TextColor3 = "Txt"}) else B(ob, {BackgroundColor3 = "Bg3", TextColor3 = "Txt2"}) end
                    ob.MouseEnter:Connect(function() Tw(ob, {BackgroundTransparency = 0.05}, 0.08) end)
                    ob.MouseLeave:Connect(function() local s = multi and sel[v] or (sel == v); Tw(ob, {BackgroundTransparency = s and 0.1 or 0.3}, 0.08) end)
                    ob.MouseButton1Click:Connect(function()
                        if multi then sel[v] = not sel[v]; el.Value = sel else sel = v; el.Value = v end
                        dl.Text = gD(); ref(); cb2(multi and sel or v)
                        if not multi then isO = false; Tw(c, {Size = UDim2.new(1, 0, 0, ht)}, 0.2); Tw(of, {Size = UDim2.new(1, -28, 0, 0)}, 0.2); al.Text = "▼" end
                    end)
                end
            end
            ref()
            db.MouseButton1Click:Connect(function()
                isO = not isO
                if isO then local oh = #vals * 26; Tw(c, {Size = UDim2.new(1, 0, 0, ht + oh + 4)}, 0.2); Tw(of, {Size = UDim2.new(1, -28, 0, oh)}, 0.2); al.Text = "▲"
                else Tw(c, {Size = UDim2.new(1, 0, 0, ht)}, 0.2); Tw(of, {Size = UDim2.new(1, -28, 0, 0)}, 0.2); al.Text = "▼" end
            end)
            function el:Set(v) if multi then if type(v) == "table" then sel = v end else sel = v end; el.Value = sel; dl.Text = gD(); ref(); cb2(sel) end
            function el:SetValues(nv) vals = nv; ref() end
            WraithFlags[fl] = el; return el
        end

        function tab:AddMultiDropdown(p) p.Multi = true; return tab:AddDropdown(p) end

        function tab:AddColorpicker(p)
            p = p or {}
            local cur = p.Default or Color3.fromRGB(255, 255, 255)
            local fl = p.Flag or p.Title or "CP"
            local cb2 = p.Callback or function() end
            local c = C("Frame", {Size = UDim2.new(1, 0, 0, 38), BackgroundColor3 = T.El, BackgroundTransparency = T.ElTr, Parent = pg})
            Cn(c, 10); St(c, T.Border, 1, 0.4)
            B(c, {BackgroundColor3 = "El", BackgroundTransparency = "ElTr"})
            local t = C("TextLabel", {Size = UDim2.new(1, -68, 0, 14), Position = UDim2.new(0, 14, 0, 12), BackgroundTransparency = 1, Text = p.Title or "Color", TextColor3 = T.Txt, TextSize = 12, Font = Enum.Font.GothamSemibold, TextXAlignment = Enum.TextXAlignment.Left, Parent = c})
            B(t, {TextColor3 = "Txt"})
            local pv = C("TextButton", {Size = UDim2.new(0, 26, 0, 18), Position = UDim2.new(1, -40, 0, 10), BackgroundColor3 = cur, Text = "", AutoButtonColor = false, Parent = c}); Cn(pv, 5); St(pv, T.Border, 1, 0.35)
            local el = {Type = "Colorpicker", Value = cur, Flag = fl, Save = p.Save ~= false}
            pv.MouseButton1Click:Connect(function()
                ColorDialog(el.Value, function(nc)
                    el.Value = nc; pv.BackgroundColor3 = nc; cb2(nc)
                end)
            end)
            function el:Set(col) if type(col) == "string" then pcall(function() col = Color3.fromHex(col) end) end; el.Value = col; pv.BackgroundColor3 = col; cb2(col) end
            WraithFlags[fl] = el; return el
        end

        function tab:AddKeybind(p)
            p = p or {}
            local ck = p.Default
            local fl = p.Flag or p.Title or "KB"
            local cb2, ccb = p.Callback or function() end, p.ChangedCallback or function() end
            local lis = false
            local c = C("Frame", {Size = UDim2.new(1, 0, 0, 38), BackgroundColor3 = T.El, BackgroundTransparency = T.ElTr, Parent = pg})
            Cn(c, 10); St(c, T.Border, 1, 0.4)
            B(c, {BackgroundColor3 = "El", BackgroundTransparency = "ElTr"})
            local t = C("TextLabel", {Size = UDim2.new(1, -94, 0, 14), Position = UDim2.new(0, 14, 0, 12), BackgroundTransparency = 1, Text = p.Title or "Keybind", TextColor3 = T.Txt, TextSize = 12, Font = Enum.Font.GothamSemibold, TextXAlignment = Enum.TextXAlignment.Left, Parent = c})
            B(t, {TextColor3 = "Txt"})
            local kb = C("TextButton", {Size = UDim2.new(0, 66, 0, 22), Position = UDim2.new(1, -80, 0, 8), BackgroundColor3 = T.Bg3, Text = ck and ck.Name or "None", TextColor3 = T.Txt2, TextSize = 10, Font = Enum.Font.GothamSemibold, AutoButtonColor = false, Parent = c})
            Cn(kb, 5); St(kb, T.Border, 1, 0.5)
            B(kb, {BackgroundColor3 = "Bg3", TextColor3 = "Txt2"})
            local el = {Type = "Keybind", Value = ck, Flag = fl, Save = p.Save ~= false}
            kb.MouseButton1Click:Connect(function() lis = true; kb.Text = "..."; Tw(kb, {BackgroundColor3 = T.ElHov}, 0.1) end)
            UserInputService.InputBegan:Connect(function(i, g)
                if g then return end
                if lis then
                    if i.UserInputType == Enum.UserInputType.Keyboard then
                        if i.KeyCode == Enum.KeyCode.Escape then ck = nil; kb.Text = "None"
                        else ck = i.KeyCode; kb.Text = ck.Name end
                        el.Value = ck; lis = false; Tw(kb, {BackgroundColor3 = T.Bg3}, 0.1); ccb(ck)
                    end
                elseif ck and i.KeyCode == ck then cb2(ck) end
            end)
            function el:Set(k) if type(k) == "string" then k = Enum.KeyCode[k] end; ck = k; el.Value = k; kb.Text = k and k.Name or "None"; ccb(k) end
            WraithFlags[fl] = el; return el
        end

        function tab:AddInput(p)
            p = p or {}
            local h = (p.Description or "") ~= "" and 68 or 50
            local fl = p.Flag or p.Title or "In"
            local cb2 = p.Callback or function() end
            local c = C("Frame", {Size = UDim2.new(1, 0, 0, h), BackgroundColor3 = T.El, BackgroundTransparency = T.ElTr, Parent = pg})
            Cn(c, 10); St(c, T.Border, 1, 0.4)
            B(c, {BackgroundColor3 = "El", BackgroundTransparency = "ElTr"})
            local t = C("TextLabel", {Size = UDim2.new(1, -28, 0, 14), Position = UDim2.new(0, 14, 0, (p.Description or "") ~= "" and 7 or 5), BackgroundTransparency = 1, Text = p.Title or "Input", TextColor3 = T.Txt, TextSize = 12, Font = Enum.Font.GothamSemibold, TextXAlignment = Enum.TextXAlignment.Left, Parent = c})
            B(t, {TextColor3 = "Txt"})
            if (p.Description or "") ~= "" then
                local d = C("TextLabel", {Size = UDim2.new(1, -28, 0, 12), Position = UDim2.new(0, 14, 0, 22), BackgroundTransparency = 1, Text = p.Description, TextColor3 = T.Txt3, TextSize = 10, Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Left, Parent = c})
                B(d, {TextColor3 = "Txt3"})
            end
            local iY = (p.Description or "") ~= "" and 40 or 26
            local ib = C("TextBox", {Size = UDim2.new(1, -28, 0, 20), Position = UDim2.new(0, 14, 0, iY), BackgroundColor3 = T.Bg3, Text = p.Default or "", PlaceholderText = p.Placeholder or "Type...", PlaceholderColor3 = T.Txt3, TextColor3 = T.Txt, TextSize = 10, Font = Enum.Font.Gotham, ClearTextOnFocus = false, Parent = c})
            Cn(ib, 5); Pd(ib, 0, 0, 7, 7); St(ib, T.Border, 1, 0.5)
            B(ib, {BackgroundColor3 = "Bg3", TextColor3 = "Txt"})
            local el = {Type = "Input", Value = p.Default or "", Flag = fl, Save = p.Save ~= false}
            ib.Focused:Connect(function() Tw(ib, {BackgroundColor3 = T.ElHov}, 0.1) end)
            ib.FocusLost:Connect(function() Tw(ib, {BackgroundColor3 = T.Bg3}, 0.1); local v = ib.Text; if p.Numeric then v = tonumber(v) or el.Value; ib.Text = tostring(v) end; el.Value = v; cb2(v) end)
            function el:Set(v) el.Value = v; ib.Text = tostring(v); cb2(v) end
            WraithFlags[fl] = el; return el
        end

        return tab
    end

    W.MainFrame = main
    return W
end

function Wraith:CreateIconFinder()
    local gui = SetupGui()
    local cp = CurrentIconPlatform
    local ff = C("Frame", {Size = UDim2.new(0, 380, 0, 440), Position = UDim2.new(0.5, -190, 0.5, -220), BackgroundColor3 = T.Bg, BackgroundTransparency = T.BgTr, Visible = true, ZIndex = 50, ClipsDescendants = true, Parent = gui})
    Cn(ff, 14); St(ff, T.Border, 1, 0.2)
    B(ff, {BackgroundColor3 = "Bg", BackgroundTransparency = "BgTr"})
    local ft = C("Frame", {Size = UDim2.new(1, 0, 0, 40), BackgroundColor3 = T.Bg2, BackgroundTransparency = 0.05, ZIndex = 51, BorderSizePixel = 0, Parent = ff}); Cn(ft, 14)
    B(ft, {BackgroundColor3 = "Bg2"})
    local ftFix = C("Frame", {Size = UDim2.new(1, 0, 0, 14), Position = UDim2.new(0, 0, 1, -14), BackgroundColor3 = T.Bg2, BackgroundTransparency = 0.05, ZIndex = 51, BorderSizePixel = 0, Parent = ft})
    B(ftFix, {BackgroundColor3 = "Bg2"})
    local ftl = C("TextLabel", {Size = UDim2.new(0, 100, 1, 0), Position = UDim2.new(0, 12, 0, 0), BackgroundTransparency = 1, Text = "Icon Finder", TextColor3 = T.Txt, TextSize = 13, Font = Enum.Font.GothamBold, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 52, Parent = ft})
    B(ftl, {TextColor3 = "Txt"})
    Drag(ff, ft)
    local cb = C("TextButton", {Size = UDim2.new(0, 24, 0, 24), Position = UDim2.new(1, -32, 0, 8), BackgroundColor3 = T.El, BackgroundTransparency = 0.15, Text = "", AutoButtonColor = false, ZIndex = 52, Parent = ft}); Cn(cb, 6)
    B(cb, {BackgroundColor3 = "El"})
    local cx1 = C("Frame", {Size = UDim2.new(0, 9, 0, 2), Position = UDim2.new(0.5, -4, 0.5, -1), BackgroundColor3 = T.Txt2, Rotation = 45, ZIndex = 53, Parent = cb})
    B(cx1, {BackgroundColor3 = "Txt2"})
    local cx2 = C("Frame", {Size = UDim2.new(0, 9, 0, 2), Position = UDim2.new(0.5, -4, 0.5, -1), BackgroundColor3 = T.Txt2, Rotation = -45, ZIndex = 53, Parent = cb})
    B(cx2, {BackgroundColor3 = "Txt2"})
    cb.MouseEnter:Connect(function() Tw(cb, {BackgroundColor3 = Color3.fromRGB(170, 42, 42), BackgroundTransparency = 0}, 0.1) end)
    cb.MouseLeave:Connect(function() Tw(cb, {BackgroundColor3 = T.El, BackgroundTransparency = 0.15}, 0.1) end)
    cb.MouseButton1Click:Connect(function() Tw(ff, {Size = UDim2.new(0, 380, 0, 0)}, 0.2); task.wait(0.25); ff:Destroy() end)
    local crf = C("Frame", {Size = UDim2.new(1, -18, 0, 64), Position = UDim2.new(0, 9, 0, 46), BackgroundTransparency = 1, ZIndex = 51, Parent = ff})
    local pf = C("Frame", {Size = UDim2.new(1, 0, 0, 24), BackgroundTransparency = 1, ZIndex = 51, Parent = crf})
    C("UIListLayout", {FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 4), Parent = pf})
    local pBs = {}
    for _, pn in ipairs({"Lucide", "Gravity", "Solar", "SFSymbols"}) do
        local act = (pn == cp)
        local pb = C("TextButton", {Size = UDim2.new(0, 82, 0, 22), BackgroundColor3 = act and T.Acc or T.El, Text = pn, TextColor3 = act and T.Bg or T.Txt2, TextSize = 9, Font = Enum.Font.GothamSemibold, AutoButtonColor = false, ZIndex = 52, Parent = pf}); Cn(pb, 5)
        pBs[pn] = pb
    end
    local sx = C("TextBox", {Size = UDim2.new(1, -48, 0, 28), Position = UDim2.new(0, 0, 0, 30), BackgroundColor3 = T.Bg3, Text = "", PlaceholderText = "Search...", PlaceholderColor3 = T.Txt3, TextColor3 = T.Txt, TextSize = 10, Font = Enum.Font.Gotham, ClearTextOnFocus = false, ZIndex = 52, Parent = crf})
    Cn(sx, 6); Pd(sx, 0, 0, 8, 8); St(sx, T.Border, 1, 0.4)
    B(sx, {BackgroundColor3 = "Bg3", TextColor3 = "Txt"})
    local rb = C("TextButton", {Size = UDim2.new(0, 38, 0, 28), Position = UDim2.new(1, -38, 0, 30), BackgroundColor3 = T.El, Text = "↻", TextColor3 = T.Txt2, TextSize = 14, Font = Enum.Font.GothamBold, AutoButtonColor = false, ZIndex = 52, Parent = crf}); Cn(rb, 6)
    B(rb, {BackgroundColor3 = "El", TextColor3 = "Txt2"})
    local rs = C("ScrollingFrame", {Size = UDim2.new(1, -18, 1, -118), Position = UDim2.new(0, 9, 0, 114), BackgroundTransparency = 1, ScrollBarThickness = 2, ScrollBarImageColor3 = T.Border, CanvasSize = UDim2.new(0, 0, 0, 0), AutomaticCanvasSize = Enum.AutomaticSize.Y, ZIndex = 51, Parent = ff})
    C("UIListLayout", {SortOrder = Enum.SortOrder.Name, Padding = UDim.new(0, 3), Parent = rs})
    local function pop(flt)
        for _, ch in ipairs(rs:GetChildren()) do if ch:IsA("Frame") then ch:Destroy() end end
        if not LoadedIcons or type(LoadedIcons) ~= "table" then return end
        local src = LoadedIcons.icons or LoadedIcons
        local cnt = 0
        for n, d in pairs(src) do
            if type(n) == "string" then
                if flt and flt ~= "" and not string.find(string.lower(n), string.lower(flt)) then continue end
                cnt = cnt + 1; if cnt > 120 then break end
                local r = C("Frame", {Size = UDim2.new(1, 0, 0, 34), BackgroundColor3 = T.El, BackgroundTransparency = T.ElTr, ZIndex = 52, Parent = rs}); Cn(r, 6)
                B(r, {BackgroundColor3 = "El", BackgroundTransparency = "ElTr"})
                local img = C("ImageLabel", {Size = UDim2.new(0, 16, 0, 16), Position = UDim2.new(0, 8, 0.5, -8), BackgroundTransparency = 1, ImageColor3 = T.Txt, ZIndex = 53, Parent = r})
                B(img, {ImageColor3 = "Txt"})
                if type(d) == "string" then img.Image = d
                elseif type(d) == "number" then img.Image = "rbxassetid://" .. tostring(d)
                elseif type(d) == "table" and d.Image then img.Image = d.Image; if d.ImageRectOffset then img.ImageRectOffset = Vector2.new(d.ImageRectOffset[1] or 0, d.ImageRectOffset[2] or 0) end; if d.ImageRectSize then img.ImageRectSize = Vector2.new(d.ImageRectSize[1] or 0, d.ImageRectSize[2] or 0) end end
                local nl = C("TextLabel", {Size = UDim2.new(1, -120, 1, 0), Position = UDim2.new(0, 30, 0, 0), BackgroundTransparency = 1, Text = n, TextColor3 = T.Txt, TextSize = 10, Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 53, Parent = r})
                B(nl, {TextColor3 = "Txt"})
                local cnb = C("TextButton", {Size = UDim2.new(0, 38, 0, 20), Position = UDim2.new(1, -84, 0, 7), BackgroundColor3 = T.Bg3, Text = "Name", TextColor3 = T.Txt2, TextSize = 8, Font = Enum.Font.GothamSemibold, AutoButtonColor = false, ZIndex = 54, Parent = r}); Cn(cnb, 4)
                B(cnb, {BackgroundColor3 = "Bg3", TextColor3 = "Txt2"})
                local cib = C("TextButton", {Size = UDim2.new(0, 38, 0, 20), Position = UDim2.new(1, -42, 0, 7), BackgroundColor3 = T.Bg3, Text = "ID", TextColor3 = T.Txt2, TextSize = 8, Font = Enum.Font.GothamSemibold, AutoButtonColor = false, ZIndex = 54, Parent = r}); Cn(cib, 4)
                B(cib, {BackgroundColor3 = "Bg3", TextColor3 = "Txt2"})
                cnb.MouseButton1Click:Connect(function() pcall(function() if setclipboard then setclipboard(n) end end); cnb.Text = "✓"; task.wait(0.7); cnb.Text = "Name" end)
                cib.MouseButton1Click:Connect(function() pcall(function() if setclipboard then local idstr = type(d) == "table" and (d.Image or "") or tostring(d); setclipboard(idstr) end end); cib.Text = "✓"; task.wait(0.7); cib.Text = "ID" end)
            end
        end
    end
    local function sw(p)
        cp = p
        for pn, pb in pairs(pBs) do
            if pn == p then Tw(pb, {BackgroundColor3 = T.Acc}, 0.1); pb.TextColor3 = T.Bg
            else Tw(pb, {BackgroundColor3 = T.El}, 0.1); pb.TextColor3 = T.Txt2 end
        end
        task.spawn(function() LoadIcons(p); pop(sx.Text) end)
    end
    for pn, pb in pairs(pBs) do pb.MouseButton1Click:Connect(function() sw(pn) end) end
    sx:GetPropertyChangedSignal("Text"):Connect(function() pop(sx.Text) end)
    rb.MouseButton1Click:Connect(function() task.spawn(function() pcall(function() delfile("Wraith/Icons/" .. cp .. ".json") end); LoadIcons(cp); pop(sx.Text) end) end)
    if LoadedIcons and next(LoadedIcons) then pop("") else task.spawn(function() LoadIcons(cp); pop("") end) end
    return ff
end

Wraith.LoadIcons = LoadIcons
Wraith.GetIcon = GetIcon
Wraith.Icons = {LoadPlatform = function(p) LoadIcons(p) end, Get = function(n) return GetIcon(n) end}

pcall(function() if CoreGui:FindFirstChild("Wraith") then CoreGui:FindFirstChild("Wraith"):Destroy() end end)
pcall(function() if gethui and gethui():FindFirstChild("Wraith") then gethui():FindFirstChild("Wraith"):Destroy() end end)

LoadIcons("Lucide")

return Wraith
