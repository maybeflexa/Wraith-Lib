local Wraith = {}
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local Player = Players.LocalPlayer
local IsMobile = UIS.TouchEnabled and not UIS.KeyboardEnabled

local WraithFlags = {}
local LoadedIcons = {}
local AllBinds = {}
local DDRefresh = {}
local TabRefreshers = {}
local ScreenGui

local PlatformURLs = {
    ["Lucide"] = "https://raw.githubusercontent.com/maybeflexa/Wraith-Lib/refs/heads/main/Wraith/Icons/Lucide.lua"
}

local Themes = {
    ["AMOLED"] = {Bg=Color3.fromRGB(0,0,0),Bg2=Color3.fromRGB(8,8,8),Bg3=Color3.fromRGB(18,18,18),El=Color3.fromRGB(13,13,13),ElHov=Color3.fromRGB(22,22,22),Border=Color3.fromRGB(34,34,34),Txt=Color3.fromRGB(255,255,255),Txt2=Color3.fromRGB(160,160,160),Txt3=Color3.fromRGB(95,95,95),Acc=Color3.fromRGB(212,212,212),AccD=Color3.fromRGB(160,160,160),TOn=Color3.fromRGB(220,220,220),TOff=Color3.fromRGB(40,40,40),Slider=Color3.fromRGB(200,200,200),BgTr=0.1,ElTr=0.4,SbTr=0.18},
    ["Dark"] = {Bg=Color3.fromRGB(14,14,16),Bg2=Color3.fromRGB(20,20,23),Bg3=Color3.fromRGB(28,28,32),El=Color3.fromRGB(24,24,28),ElHov=Color3.fromRGB(36,36,40),Border=Color3.fromRGB(46,46,50),Txt=Color3.fromRGB(244,244,244),Txt2=Color3.fromRGB(154,154,160),Txt3=Color3.fromRGB(100,100,108),Acc=Color3.fromRGB(200,200,208),AccD=Color3.fromRGB(148,148,154),TOn=Color3.fromRGB(210,210,216),TOff=Color3.fromRGB(50,50,54),Slider=Color3.fromRGB(190,190,198),BgTr=0.12,ElTr=0.38,SbTr=0.2},
    ["Darker"] = {Bg=Color3.fromRGB(6,6,8),Bg2=Color3.fromRGB(12,12,14),Bg3=Color3.fromRGB(20,20,22),El=Color3.fromRGB(16,16,18),ElHov=Color3.fromRGB(28,28,30),Border=Color3.fromRGB(38,38,42),Txt=Color3.fromRGB(238,238,238),Txt2=Color3.fromRGB(142,142,148),Txt3=Color3.fromRGB(90,90,96),Acc=Color3.fromRGB(192,192,198),AccD=Color3.fromRGB(138,138,144),TOn=Color3.fromRGB(202,202,208),TOff=Color3.fromRGB(44,44,48),Slider=Color3.fromRGB(182,182,190),BgTr=0.08,ElTr=0.36,SbTr=0.15},
    ["Midnight"] = {Bg=Color3.fromRGB(4,4,12),Bg2=Color3.fromRGB(10,10,20),Bg3=Color3.fromRGB(18,18,30),El=Color3.fromRGB(14,14,24),ElHov=Color3.fromRGB(26,26,38),Border=Color3.fromRGB(40,40,54),Txt=Color3.fromRGB(232,232,242),Txt2=Color3.fromRGB(144,144,164),Txt3=Color3.fromRGB(94,94,114),Acc=Color3.fromRGB(180,180,208),AccD=Color3.fromRGB(130,130,158),TOn=Color3.fromRGB(190,190,218),TOff=Color3.fromRGB(42,42,54),Slider=Color3.fromRGB(170,170,198),BgTr=0.1,ElTr=0.38,SbTr=0.18},
    ["Charcoal"] = {Bg=Color3.fromRGB(20,20,20),Bg2=Color3.fromRGB(28,28,28),Bg3=Color3.fromRGB(38,38,38),El=Color3.fromRGB(32,32,32),ElHov=Color3.fromRGB(46,46,46),Border=Color3.fromRGB(56,56,56),Txt=Color3.fromRGB(248,248,248),Txt2=Color3.fromRGB(162,162,162),Txt3=Color3.fromRGB(108,108,108),Acc=Color3.fromRGB(212,212,212),AccD=Color3.fromRGB(152,152,152),TOn=Color3.fromRGB(222,222,222),TOff=Color3.fromRGB(58,58,58),Slider=Color3.fromRGB(198,198,198),BgTr=0.12,ElTr=0.4,SbTr=0.22},
    ["Light"] = {Bg=Color3.fromRGB(244,244,247),Bg2=Color3.fromRGB(232,232,236),Bg3=Color3.fromRGB(218,218,224),El=Color3.fromRGB(225,225,230),ElHov=Color3.fromRGB(210,210,216),Border=Color3.fromRGB(192,192,198),Txt=Color3.fromRGB(15,15,18),Txt2=Color3.fromRGB(68,68,76),Txt3=Color3.fromRGB(110,110,118),Acc=Color3.fromRGB(40,40,48),AccD=Color3.fromRGB(80,80,88),TOn=Color3.fromRGB(28,28,34),TOff=Color3.fromRGB(188,188,194),Slider=Color3.fromRGB(48,48,56),BgTr=0.08,ElTr=0.3,SbTr=0.12},
    ["Obsidian"] = {Bg=Color3.fromRGB(2,2,4),Bg2=Color3.fromRGB(6,6,10),Bg3=Color3.fromRGB(14,14,18),El=Color3.fromRGB(10,10,14),ElHov=Color3.fromRGB(22,22,26),Border=Color3.fromRGB(32,32,38),Txt=Color3.fromRGB(228,228,232),Txt2=Color3.fromRGB(138,138,148),Txt3=Color3.fromRGB(88,88,98),Acc=Color3.fromRGB(172,172,185),AccD=Color3.fromRGB(122,122,135),TOn=Color3.fromRGB(182,182,195),TOff=Color3.fromRGB(38,38,44),Slider=Color3.fromRGB(162,162,175),BgTr=0.06,ElTr=0.34,SbTr=0.12}
}

local T = Themes["AMOLED"]

local function Tw(i,p,d,s,dir)
    if not i or not i.Parent then return end
    TS:Create(i,TweenInfo.new(d or 0.25,s or Enum.EasingStyle.Quart,dir or Enum.EasingDirection.Out),p):Play()
end

local function C(cls,pr)
    local i = Instance.new(cls)
    if pr then
        for k,v in pairs(pr) do if k ~= "Parent" then pcall(function() i[k] = v end) end end
        if pr.Parent then i.Parent = pr.Parent end
    end
    return i
end

local function Cn(p,r) return C("UICorner",{CornerRadius=UDim.new(0,r or 8),Parent=p}) end
local function St(p,c,t,tr) return C("UIStroke",{Color=c or T.Border,Thickness=t or 1,Transparency=tr or 0.45,ApplyStrokeMode=Enum.ApplyStrokeMode.Border,Parent=p}) end
local function Pd(p,t,b,l,r) return C("UIPadding",{PaddingTop=UDim.new(0,t or 0),PaddingBottom=UDim.new(0,b or 0),PaddingLeft=UDim.new(0,l or 0),PaddingRight=UDim.new(0,r or 0),Parent=p}) end
local function B(inst,map) table.insert(AllBinds,{I=inst,M=map}) end

local function Apply()
    for i=#AllBinds,1,-1 do
        local b=AllBinds[i]
        if not b.I or not b.I.Parent then table.remove(AllBinds,i)
        else for prop,key in pairs(b.M) do if T[key]~=nil then pcall(function() if typeof(T[key])=="Color3" then Tw(b.I,{[prop]=T[key]},0.3) elseif typeof(T[key])=="number" then Tw(b.I,{[prop]=T[key]},0.3) end end) end end end
    end
    for i=#DDRefresh,1,-1 do local r=DDRefresh[i]; if r and r.F and r.F.Parent then pcall(r.R) else table.remove(DDRefresh,i) end end
    for i=#TabRefreshers,1,-1 do local r=TabRefreshers[i]; if r and r.F and r.F.Parent then pcall(r.R) else table.remove(TabRefreshers,i) end end
end

local function Drag(frame,handle)
    local dr,di,ds,sp=false,nil,nil,nil
    handle=handle or frame
    handle.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
            dr=true; ds=i.Position; sp=frame.Position
            i.Changed:Connect(function() if i.UserInputState==Enum.UserInputState.End then dr=false end end)
        end
    end)
    handle.InputChanged:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch then di=i end end)
    UIS.InputChanged:Connect(function(i) if i==di and dr then local d=i.Position-ds; Tw(frame,{Position=UDim2.new(sp.X.Scale,sp.X.Offset+d.X,sp.Y.Scale,sp.Y.Offset+d.Y)},0.04) end end)
end

local function SetupGui()
    if ScreenGui and ScreenGui.Parent then return ScreenGui end
    local parent
    pcall(function() if gethui then parent = gethui() end end)
    if not parent then
        pcall(function()
            if syn and syn.protect_gui then
                ScreenGui = C("ScreenGui",{Name="Wraith",ZIndexBehavior=Enum.ZIndexBehavior.Sibling,ResetOnSpawn=false,IgnoreGuiInset=true,DisplayOrder=999})
                syn.protect_gui(ScreenGui)
                ScreenGui.Parent = CoreGui
            end
        end)
        if ScreenGui then return ScreenGui end
        parent = CoreGui
    end
    ScreenGui = C("ScreenGui",{Name="Wraith",ZIndexBehavior=Enum.ZIndexBehavior.Sibling,ResetOnSpawn=false,IgnoreGuiInset=true,DisplayOrder=999,Parent=parent})
    return ScreenGui
end

local function EnsF() pcall(function() if not isfolder("Wraith") then makefolder("Wraith") end; if not isfolder("Wraith/Icons") then makefolder("Wraith/Icons") end; if not isfolder("Wraith/configs") then makefolder("Wraith/configs") end; if not isfolder("Wraith/themes") then makefolder("Wraith/themes") end end) end

local function SaveThemePref(name) pcall(function() EnsF(); writefile("Wraith/theme.txt", name) end) end
local function LoadThemePref()
    local ok, r = pcall(function() if isfile("Wraith/theme.txt") then return readfile("Wraith/theme.txt") end return nil end)
    if ok and r and Themes[r] then T = Themes[r]; return r end
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
                    local ok2, data = pcall(function() return HttpService:JSONDecode(content) end)
                    if ok2 and data and data.Name then
                        local theme = {}
                        for k, v in pairs(data) do
                            if k ~= "Name" then
                                if type(v) == "table" and v.R then theme[k] = Color3.new(v.R, v.G, v.B)
                                elseif type(v) == "number" then theme[k] = v end
                            end
                        end
                        if not Themes[data.Name] then Themes[data.Name] = theme end
                    end
                end
            end
        end
    end)
end

local function LoadIcons(p)
    p = p or "Lucide"; EnsF()
    local cp = "Wraith/Icons/" .. p .. ".lua"
    local raw
    pcall(function() if isfile(cp) then local r = readfile(cp); if r and #r > 50 then raw = r end end end)
    if not raw then
        local u = PlatformURLs[p]; if not u then LoadedIcons = {}; return end
        local s, r = pcall(function() return game:HttpGet(u) end)
        if s and r and #r > 50 then raw = r; pcall(function() writefile(cp, r) end) end
    end
    if not raw then LoadedIcons = {}; return end
    local ok, result = pcall(function() local fn = loadstring(raw); if fn then return fn() end; return nil end)
    if ok and type(result) == "table" then LoadedIcons = result else LoadedIcons = {} end
end

local function GetIcon(n)
    if not LoadedIcons or not n then return nil end
    if LoadedIcons[n] then return LoadedIcons[n] end
    return nil
end

local function ApplyIcon(img, d)
    if not d then return end
    if type(d) == "string" then img.Image = d
    elseif type(d) == "number" then img.Image = "rbxassetid://"..tostring(d)
    elseif type(d) == "table" then
        if d.Image then img.Image = d.Image elseif d.id then img.Image = "rbxassetid://"..tostring(d.id) end
        if d.ImageRectOffset then img.ImageRectOffset = Vector2.new(d.ImageRectOffset[1] or 0, d.ImageRectOffset[2] or 0) end
        if d.ImageRectSize then img.ImageRectSize = Vector2.new(d.ImageRectSize[1] or 0, d.ImageRectSize[2] or 0) end
    end
end

local SaveMgr = {Folder="Wraith",CfgFolder="Wraith/configs"}
function SaveMgr:Ensure() EnsF() end
function SaveMgr:Save(n) self:Ensure(); local d={}; for f,e in pairs(WraithFlags) do if type(e)=="table" and e.Save~=false then if e.Type=="Colorpicker" then d[f]={R=e.Value.R,G=e.Value.G,B=e.Value.B} elseif e.Type=="Keybind" then d[f]=e.Value and e.Value.Name or nil else d[f]=e.Value end end end; pcall(function() writefile(self.CfgFolder.."/"..n..".json",HttpService:JSONEncode(d)) end) end
function SaveMgr:Load(n) self:Ensure(); local s,c=pcall(function() return readfile(self.CfgFolder.."/"..n..".json") end); if s and c then local ok,d=pcall(function() return HttpService:JSONDecode(c) end); if ok and d then for f,v in pairs(d) do if WraithFlags[f] and WraithFlags[f].Set then pcall(function() if WraithFlags[f].Type=="Colorpicker" and type(v)=="table" then WraithFlags[f]:Set(Color3.new(v.R,v.G,v.B)) elseif WraithFlags[f].Type=="Keybind" and type(v)=="string" then WraithFlags[f]:Set(Enum.KeyCode[v]) else WraithFlags[f]:Set(v) end end) end end end end end
function SaveMgr:Delete(n) pcall(function() delfile(self.CfgFolder.."/"..n..".json") end) end

Wraith.SaveManager = SaveMgr
Wraith.Flags = WraithFlags
Wraith.Themes = Themes
Wraith.LoadIcons = LoadIcons
Wraith.GetIcon = GetIcon
Wraith.IsMobile = IsMobile

function Wraith:SetTheme(n)
    if Themes[n] then T = Themes[n]; Apply(); SaveThemePref(n) end
end

function Wraith:AddTheme(name, themeData)
    if not name or not themeData then return false end
    Themes[name] = themeData
    pcall(function()
        EnsF()
        local saveData = {Name = name}
        for k, v in pairs(themeData) do
            if typeof(v) == "Color3" then saveData[k] = {R=v.R, G=v.G, B=v.B}
            elseif type(v) == "number" then saveData[k] = v end
        end
        writefile("Wraith/themes/" .. name .. ".json", HttpService:JSONEncode(saveData))
    end)
    return true
end

function Wraith:GetThemes()
    local list = {}
    for k, _ in pairs(Themes) do table.insert(list, k) end
    return list
end

function Wraith:Notify(o)
    o=o or {}; local gui=SetupGui()
    local h=gui:FindFirstChild("WN")
    if not h then h=C("Frame",{Name="WN",Size=UDim2.new(0,300,1,0),Position=UDim2.new(1,-315,0,0),BackgroundTransparency=1,Parent=gui}); C("UIListLayout",{SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,5),VerticalAlignment=Enum.VerticalAlignment.Bottom,HorizontalAlignment=Enum.HorizontalAlignment.Center,Parent=h}); Pd(h,0,14,0,0) end
    local notifs = {}
    for _, c in ipairs(h:GetChildren()) do if c:IsA("Frame") then table.insert(notifs, c) end end
    if #notifs >= 5 then notifs[1]:Destroy() end
    local nf=C("Frame",{Size=UDim2.new(1,0,0,0),BackgroundColor3=T.Bg2,BackgroundTransparency=0.04,ClipsDescendants=true,Parent=h}); Cn(nf,10); local ns=St(nf,T.Border,1,0.3); B(nf,{BackgroundColor3="Bg2"}); B(ns,{Color="Border"})
    local nc=C("Frame",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Parent=nf}); Pd(nc,10,10,12,12)
    local tl=C("TextLabel",{Size=UDim2.new(1,0,0,16),BackgroundTransparency=1,Text=o.Title or "Wraith",TextColor3=T.Txt,TextSize=13,Font=Enum.Font.GothamBold,TextXAlignment=Enum.TextXAlignment.Left,Parent=nc}); B(tl,{TextColor3="Txt"})
    local cl=C("TextLabel",{Size=UDim2.new(1,0,0,0),Position=UDim2.new(0,0,0,18),BackgroundTransparency=1,Text=o.Content or "",TextColor3=T.Txt2,TextSize=11,Font=Enum.Font.Gotham,TextXAlignment=Enum.TextXAlignment.Left,TextWrapped=true,AutomaticSize=Enum.AutomaticSize.Y,Parent=nc}); B(cl,{TextColor3="Txt2"})
    local sl; if (o.SubContent or "")~="" then sl=C("TextLabel",{Size=UDim2.new(1,0,0,0),BackgroundTransparency=1,Text=o.SubContent,TextColor3=T.Txt3,TextSize=10,Font=Enum.Font.Gotham,TextXAlignment=Enum.TextXAlignment.Left,TextWrapped=true,AutomaticSize=Enum.AutomaticSize.Y,Parent=nc}); B(sl,{TextColor3="Txt3"}) end
    local pb=C("Frame",{Size=UDim2.new(1,0,0,2),Position=UDim2.new(0,0,1,-2),BackgroundColor3=T.Acc,BorderSizePixel=0,Parent=nf}); B(pb,{BackgroundColor3="Acc"})
    local dur=o.Duration or 5
    task.defer(function() task.wait(0.05); local ht=18+18; if cl then ht=ht+cl.AbsoluteSize.Y end; if sl then ht=ht+sl.AbsoluteSize.Y+3; sl.Position=UDim2.new(0,0,0,18+cl.AbsoluteSize.Y+2) end; ht=math.max(ht,48); Tw(nf,{Size=UDim2.new(1,0,0,ht)},0.3); Tw(pb,{Size=UDim2.new(0,0,0,2)},dur,Enum.EasingStyle.Linear); task.wait(dur); Tw(nf,{Size=UDim2.new(1,0,0,0),BackgroundTransparency=1},0.3); task.wait(0.35); nf:Destroy() end)
end

function Wraith:Dialog(o)
    o=o or {}; local gui=SetupGui()
    local blocker=C("TextButton",{Size=UDim2.new(1,0,1,0),BackgroundColor3=Color3.new(0,0,0),BackgroundTransparency=0.4,ZIndex=100,Text="",AutoButtonColor=false,Modal=true,Parent=gui})
    local df=C("Frame",{Size=UDim2.new(0,360,0,0),Position=UDim2.new(0.5,-180,0.5,0),AnchorPoint=Vector2.new(0,0.5),BackgroundColor3=T.Bg2,BackgroundTransparency=0.02,ZIndex=101,ClipsDescendants=true,Parent=gui}); Cn(df,14); local ds=St(df,T.Border,1,0.3); B(df,{BackgroundColor3="Bg2"}); B(ds,{Color="Border"})
    local dc=C("Frame",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,ZIndex=102,Parent=df}); Pd(dc,20,20,20,20)
    local dt=C("TextLabel",{Size=UDim2.new(1,0,0,18),BackgroundTransparency=1,Text=o.Title or "Dialog",TextColor3=T.Txt,TextSize=15,Font=Enum.Font.GothamBold,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=102,Parent=dc}); B(dt,{TextColor3="Txt"})
    local dcl=C("TextLabel",{Size=UDim2.new(1,0,0,0),Position=UDim2.new(0,0,0,26),BackgroundTransparency=1,Text=o.Content or "",TextColor3=T.Txt2,TextSize=12,Font=Enum.Font.Gotham,TextXAlignment=Enum.TextXAlignment.Left,TextWrapped=true,AutomaticSize=Enum.AutomaticSize.Y,ZIndex=102,Parent=dc}); B(dcl,{TextColor3="Txt2"})
    local bh=C("Frame",{Size=UDim2.new(1,0,0,32),Position=UDim2.new(0,0,1,-32),BackgroundTransparency=1,ZIndex=102,Parent=dc}); C("UIListLayout",{FillDirection=Enum.FillDirection.Horizontal,Padding=UDim.new(0,8),HorizontalAlignment=Enum.HorizontalAlignment.Right,Parent=bh})
    local ev=Instance.new("BindableEvent")
    local function closeDialog() Tw(df,{Size=UDim2.new(0,360,0,0)},0.2); Tw(blocker,{BackgroundTransparency=1},0.2); task.wait(0.25); df:Destroy(); blocker:Destroy() end
    for i,bd in ipairs(o.Buttons or {}) do
        local pr=(i==#(o.Buttons or {}))
        local bb=C("TextButton",{Size=UDim2.new(0,90,0,28),BackgroundColor3=pr and T.Acc or T.El,Text=bd.Title or "OK",TextColor3=pr and T.Bg or T.Txt,TextSize=11,Font=Enum.Font.GothamSemibold,ZIndex=103,AutoButtonColor=false,Parent=bh}); Cn(bb,7)
        if pr then B(bb,{BackgroundColor3="Acc",TextColor3="Bg"}) else B(bb,{BackgroundColor3="El",TextColor3="Txt"}) end
        bb.MouseButton1Click:Connect(function() closeDialog(); if bd.Callback then bd.Callback() end; ev:Fire(bd.Title) end)
    end
    task.defer(function() task.wait(0.05); local ht=26+dcl.AbsoluteSize.Y+32+42+20; Tw(df,{Size=UDim2.new(0,360,0,math.max(ht,130))},0.3,Enum.EasingStyle.Back) end)
    return ev.Event:Wait()
end

local function ColorDialog(curCol,cb)
    local gui=SetupGui()
    local hue,sat,val=curCol:ToHSV(); local tmp=curCol
    local blocker=C("TextButton",{Size=UDim2.new(1,0,1,0),BackgroundColor3=Color3.new(0,0,0),BackgroundTransparency=0.45,ZIndex=200,Text="",AutoButtonColor=false,Modal=true,Parent=gui})
    local df=C("Frame",{Size=UDim2.new(0,290,0,0),Position=UDim2.new(0.5,-145,0.5,0),AnchorPoint=Vector2.new(0,0.5),BackgroundColor3=T.Bg2,BackgroundTransparency=0.02,ZIndex=201,ClipsDescendants=true,Parent=gui}); Cn(df,14); local ds=St(df,T.Border,1,0.3); B(df,{BackgroundColor3="Bg2"}); B(ds,{Color="Border"})
    local top=C("Frame",{Size=UDim2.new(1,0,0,38),BackgroundColor3=T.Bg2,ZIndex=202,BorderSizePixel=0,Parent=df}); Cn(top,14); B(top,{BackgroundColor3="Bg2"})
    local tf=C("Frame",{Size=UDim2.new(1,0,0,14),Position=UDim2.new(0,0,1,-14),BackgroundColor3=T.Bg2,ZIndex=202,BorderSizePixel=0,Parent=top}); B(tf,{BackgroundColor3="Bg2"})
    local tt=C("TextLabel",{Size=UDim2.new(1,-16,1,0),Position=UDim2.new(0,12,0,0),BackgroundTransparency=1,Text="Color Picker",TextColor3=T.Txt,TextSize=13,Font=Enum.Font.GothamBold,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=203,Parent=top}); B(tt,{TextColor3="Txt"})
    Drag(df,top)
    local ct=C("Frame",{Size=UDim2.new(1,-24,1,-50),Position=UDim2.new(0,12,0,44),BackgroundTransparency=1,ZIndex=202,Parent=df})
    local sv=C("Frame",{Size=UDim2.new(1,-30,0,130),BackgroundColor3=Color3.fromHSV(hue,1,1),ZIndex=203,Parent=ct}); Cn(sv,7)
    C("UIGradient",{Color=ColorSequence.new(Color3.new(1,1,1),Color3.new(1,1,1)),Transparency=NumberSequence.new(0,1),Parent=sv})
    local bo=C("Frame",{Size=UDim2.new(1,0,1,0),BackgroundColor3=Color3.new(0,0,0),ZIndex=204,Parent=sv}); Cn(bo,7)
    C("UIGradient",{Color=ColorSequence.new(Color3.new(0,0,0),Color3.new(0,0,0)),Transparency=NumberSequence.new(1,0),Rotation=90,Parent=bo})
    local svc=C("Frame",{Size=UDim2.new(0,12,0,12),Position=UDim2.new(sat,-6,1-val,-6),BackgroundColor3=Color3.new(1,1,1),ZIndex=206,Parent=sv}); Cn(svc,6); St(svc,Color3.new(0,0,0),2,0.2)
    local hb=C("Frame",{Size=UDim2.new(0,18,0,130),Position=UDim2.new(1,-18,0,0),BackgroundColor3=Color3.new(1,1,1),ZIndex=203,Parent=ct}); Cn(hb,5)
    C("UIGradient",{Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromHSV(0,1,1)),ColorSequenceKeypoint.new(0.167,Color3.fromHSV(0.167,1,1)),ColorSequenceKeypoint.new(0.333,Color3.fromHSV(0.333,1,1)),ColorSequenceKeypoint.new(0.5,Color3.fromHSV(0.5,1,1)),ColorSequenceKeypoint.new(0.667,Color3.fromHSV(0.667,1,1)),ColorSequenceKeypoint.new(0.833,Color3.fromHSV(0.833,1,1)),ColorSequenceKeypoint.new(1,Color3.fromHSV(1,1,1))}),Rotation=90,Parent=hb})
    local hc=C("Frame",{Size=UDim2.new(1,4,0,5),Position=UDim2.new(0,-2,hue,-2),BackgroundColor3=Color3.new(1,1,1),ZIndex=206,Parent=hb}); Cn(hc,2); St(hc,Color3.new(0,0,0),1,0.3)
    local pr=C("Frame",{Size=UDim2.new(1,0,0,28),Position=UDim2.new(0,0,0,136),BackgroundTransparency=1,ZIndex=203,Parent=ct})
    local pvb=C("Frame",{Size=UDim2.new(0,28,0,28),BackgroundColor3=tmp,ZIndex=204,Parent=pr}); Cn(pvb,6)
    local hx=C("TextBox",{Size=UDim2.new(1,-36,0,28),Position=UDim2.new(0,34,0,0),BackgroundColor3=T.Bg3,Text="#"..tmp:ToHex():upper(),TextColor3=T.Txt,TextSize=11,Font=Enum.Font.GothamSemibold,ClearTextOnFocus=false,ZIndex=204,Parent=pr}); Cn(hx,6); Pd(hx,0,0,7,7); B(hx,{BackgroundColor3="Bg3",TextColor3="Txt"})
    local br=C("Frame",{Size=UDim2.new(1,0,0,30),Position=UDim2.new(0,0,0,170),BackgroundTransparency=1,ZIndex=203,Parent=ct})
    C("UIListLayout",{FillDirection=Enum.FillDirection.Horizontal,Padding=UDim.new(0,7),HorizontalAlignment=Enum.HorizontalAlignment.Right,Parent=br})
    local cb1=C("TextButton",{Size=UDim2.new(0,80,0,28),BackgroundColor3=T.El,Text="Cancel",TextColor3=T.Txt,TextSize=11,Font=Enum.Font.GothamSemibold,AutoButtonColor=false,ZIndex=204,LayoutOrder=1,Parent=br}); Cn(cb1,7); B(cb1,{BackgroundColor3="El",TextColor3="Txt"})
    local ok=C("TextButton",{Size=UDim2.new(0,80,0,28),BackgroundColor3=T.Acc,Text="Apply",TextColor3=T.Bg,TextSize=11,Font=Enum.Font.GothamSemibold,AutoButtonColor=false,ZIndex=204,LayoutOrder=2,Parent=br}); Cn(ok,7); B(ok,{BackgroundColor3="Acc",TextColor3="Bg"})
    local function upd() tmp=Color3.fromHSV(math.clamp(hue,0,0.999),sat,val); pvb.BackgroundColor3=tmp; sv.BackgroundColor3=Color3.fromHSV(math.clamp(hue,0,0.999),1,1); svc.Position=UDim2.new(sat,-6,1-val,-6); hc.Position=UDim2.new(0,-2,hue,-2); hx.Text="#"..tmp:ToHex():upper() end
    local dSV,dH=false,false
    local svb=C("TextButton",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Text="",ZIndex=207,Parent=sv})
    local hbb=C("TextButton",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Text="",ZIndex=207,Parent=hb})
    svb.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dSV=true; sat=math.clamp((i.Position.X-sv.AbsolutePosition.X)/sv.AbsoluteSize.X,0,1); val=1-math.clamp((i.Position.Y-sv.AbsolutePosition.Y)/sv.AbsoluteSize.Y,0,1); upd() end end)
    svb.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dSV=false end end)
    hbb.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dH=true; hue=math.clamp((i.Position.Y-hb.AbsolutePosition.Y)/hb.AbsoluteSize.Y,0,0.999); upd() end end)
    hbb.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dH=false end end)
    UIS.InputChanged:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch then if dSV then sat=math.clamp((i.Position.X-sv.AbsolutePosition.X)/sv.AbsoluteSize.X,0,1); val=1-math.clamp((i.Position.Y-sv.AbsolutePosition.Y)/sv.AbsoluteSize.Y,0,1); upd() elseif dH then hue=math.clamp((i.Position.Y-hb.AbsolutePosition.Y)/hb.AbsoluteSize.Y,0,0.999); upd() end end end)
    hx.FocusLost:Connect(function() local s,c=pcall(function() return Color3.fromHex("#"..hx.Text:gsub("#","")) end); if s and c then hue,sat,val=c:ToHSV(); upd() else hx.Text="#"..tmp:ToHex():upper() end end)
    local cl=false
    local function close() if cl then return end; cl=true; Tw(df,{Size=UDim2.new(0,290,0,0)},0.2); Tw(blocker,{BackgroundTransparency=1},0.2); task.wait(0.25); df:Destroy(); blocker:Destroy() end
    cb1.MouseButton1Click:Connect(close)
    ok.MouseButton1Click:Connect(function() close(); cb(tmp) end)
    task.defer(function() task.wait(0.05); Tw(df,{Size=UDim2.new(0,290,0,280)},0.3,Enum.EasingStyle.Back) end)
end

function Wraith:CreateWindow(o)
    o=o or {}
    local wT,wS,wSz=o.Title or "Wraith",o.SubTitle or "",o.Size or UDim2.new(0,630,0,370)
    local mK,tW=o.MinimizeKey or Enum.KeyCode.LeftControl,o.TabWidth or 170
    local minSize = o.MinSize or Vector2.new(450, 280)
    local resizable = o.Resizable ~= false
    local gui=SetupGui()
    local W={Tabs={},ActiveTab=nil,Vis=true,Min=false,Gui=gui,CurrentSize=wSz}

    local main=C("Frame",{Name="WM",Size=wSz,Position=UDim2.new(0.5,-(wSz.X.Offset/2),0.5,-(wSz.Y.Offset/2)),BackgroundColor3=T.Bg,BackgroundTransparency=T.BgTr,ClipsDescendants=true,Parent=gui}); Cn(main,14); local ms=St(main,T.Border,1,0.2); B(main,{BackgroundColor3="Bg",BackgroundTransparency="BgTr"}); B(ms,{Color="Border"})

    local tb=C("Frame",{Size=UDim2.new(1,0,0,48),BackgroundColor3=T.Bg2,BackgroundTransparency=0.05,BorderSizePixel=0,ZIndex=3,Parent=main}); Cn(tb,14); B(tb,{BackgroundColor3="Bg2"})
    local tbf=C("Frame",{Size=UDim2.new(1,0,0,14),Position=UDim2.new(0,0,1,-14),BackgroundColor3=T.Bg2,BackgroundTransparency=0.05,BorderSizePixel=0,ZIndex=3,Parent=tb}); B(tbf,{BackgroundColor3="Bg2"})

    local lbg=C("Frame",{Size=UDim2.new(0,32,0,32),Position=UDim2.new(0,10,0,8),BackgroundColor3=T.El,BackgroundTransparency=0.15,ZIndex=4,Parent=tb}); Cn(lbg,8); B(lbg,{BackgroundColor3="El"})
    local lt=C("TextLabel",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Text="W",TextColor3=T.Txt,TextSize=18,Font=Enum.Font.GothamBold,ZIndex=5,Parent=lbg}); B(lt,{TextColor3="Txt"})

    local titleYPos = wS ~= "" and 8 or 15
    local ttl=C("TextLabel",{Size=UDim2.new(0,200,0,18),Position=UDim2.new(0,50,0,titleYPos),BackgroundTransparency=1,Text=wT,TextColor3=T.Txt,TextSize=14,Font=Enum.Font.GothamBold,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=4,Parent=tb}); B(ttl,{TextColor3="Txt"})
    if wS ~= "" then
        local stl=C("TextLabel",{Size=UDim2.new(0,200,0,12),Position=UDim2.new(0,50,0,27),BackgroundTransparency=1,Text=wS,TextColor3=T.Txt3,TextSize=10,Font=Enum.Font.Gotham,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=4,Parent=tb}); B(stl,{TextColor3="Txt3"})
    end

    local cf=C("Frame",{Size=UDim2.new(0,66,0,26),Position=UDim2.new(1,-78,0,11),BackgroundTransparency=1,ZIndex=4,Parent=tb}); C("UIListLayout",{FillDirection=Enum.FillDirection.Horizontal,Padding=UDim.new(0,5),HorizontalAlignment=Enum.HorizontalAlignment.Right,VerticalAlignment=Enum.VerticalAlignment.Center,Parent=cf})
    local mb=C("TextButton",{Size=UDim2.new(0,26,0,26),BackgroundColor3=T.El,BackgroundTransparency=0.15,Text="",AutoButtonColor=false,LayoutOrder=1,ZIndex=5,Parent=cf}); Cn(mb,7); B(mb,{BackgroundColor3="El"})
    C("Frame",{Size=UDim2.new(0,10,0,2),Position=UDim2.new(0.5,-5,0.5,-1),BackgroundColor3=T.Txt2,BorderSizePixel=0,ZIndex=6,Parent=mb})
    local xb=C("TextButton",{Size=UDim2.new(0,26,0,26),BackgroundColor3=T.El,BackgroundTransparency=0.15,Text="",AutoButtonColor=false,LayoutOrder=2,ZIndex=5,Parent=cf}); Cn(xb,7); B(xb,{BackgroundColor3="El"})
    C("Frame",{Size=UDim2.new(0,10,0,2),Position=UDim2.new(0.5,-5,0.5,-1),BackgroundColor3=T.Txt2,Rotation=45,ZIndex=6,Parent=xb})
    C("Frame",{Size=UDim2.new(0,10,0,2),Position=UDim2.new(0.5,-5,0.5,-1),BackgroundColor3=T.Txt2,Rotation=-45,ZIndex=6,Parent=xb})

    mb.MouseEnter:Connect(function() Tw(mb,{BackgroundTransparency=0},0.1) end)
    mb.MouseLeave:Connect(function() Tw(mb,{BackgroundTransparency=0.15},0.1) end)
    xb.MouseEnter:Connect(function() Tw(xb,{BackgroundColor3=Color3.fromRGB(170,42,42),BackgroundTransparency=0},0.1) end)
    xb.MouseLeave:Connect(function() Tw(xb,{BackgroundColor3=T.El,BackgroundTransparency=0.15},0.1) end)

    local floatBtn
    if IsMobile then
        floatBtn=C("ImageButton",{Name="WFloat",Size=UDim2.new(0,46,0,46),Position=UDim2.new(0,16,0.5,-23),BackgroundColor3=T.Bg2,BackgroundTransparency=0.05,Image="",AutoButtonColor=false,Visible=false,ZIndex=50,Parent=gui}); Cn(floatBtn,12); local fbs=St(floatBtn,T.Border,1,0.3); B(floatBtn,{BackgroundColor3="Bg2"}); B(fbs,{Color="Border"})
        C("TextLabel",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Text="W",TextColor3=T.Txt,TextSize=22,Font=Enum.Font.GothamBold,ZIndex=51,Parent=floatBtn})
        Drag(floatBtn)
    end

    local function showWindow() W.Vis=true; W.Min=false; main.Visible=true; if floatBtn then floatBtn.Visible=false end; main.Size=UDim2.new(0,W.CurrentSize.X.Offset,0,0); main.BackgroundTransparency=1; Tw(main,{Size=W.CurrentSize,BackgroundTransparency=T.BgTr},0.4,Enum.EasingStyle.Back) end
    local function hideWindow() W.Vis=false; Tw(main,{Size=UDim2.new(0,W.CurrentSize.X.Offset,0,0),BackgroundTransparency=1},0.4,Enum.EasingStyle.Quart,Enum.EasingDirection.In); task.wait(0.45); main.Visible=false end
    local function minimizeWindow() W.Min=true; W.Vis=false; Tw(main,{Size=UDim2.new(0,W.CurrentSize.X.Offset,0,0),BackgroundTransparency=1},0.4,Enum.EasingStyle.Quart,Enum.EasingDirection.In); task.wait(0.42); main.Visible=false; if floatBtn then floatBtn.Visible=true; floatBtn.Size=UDim2.new(0,0,0,0); Tw(floatBtn,{Size=UDim2.new(0,46,0,46)},0.3,Enum.EasingStyle.Back) end end

    mb.MouseButton1Click:Connect(minimizeWindow)
    xb.MouseButton1Click:Connect(hideWindow)
    if floatBtn then floatBtn.MouseButton1Click:Connect(function() Tw(floatBtn,{Size=UDim2.new(0,0,0,0)},0.25,Enum.EasingStyle.Quart,Enum.EasingDirection.In); task.wait(0.27); floatBtn.Visible=false; showWindow() end) end
    Drag(main,tb)

    if resizable then
        local rh = C("Frame",{Size=UDim2.new(0,16,0,16),Position=UDim2.new(1,-16,1,-16),BackgroundColor3=T.Border,BackgroundTransparency=0.6,ZIndex=10,Parent=main})
        Cn(rh,3); B(rh,{BackgroundColor3="Border"})
        local rhBtn = C("TextButton",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Text="",AutoButtonColor=false,ZIndex=11,Parent=rh})
        local resizing, startSize, startPos = false, nil, nil
        rhBtn.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                resizing = true
                startSize = main.AbsoluteSize
                startPos = i.Position
            end
        end)
        rhBtn.InputEnded:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                resizing = false
            end
        end)
        UIS.InputChanged:Connect(function(i)
            if resizing and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
                local delta = i.Position - startPos
                local newW = math.max(minSize.X, startSize.X + delta.X)
                local newH = math.max(minSize.Y, startSize.Y + delta.Y)
                main.Size = UDim2.new(0, newW, 0, newH)
                W.CurrentSize = UDim2.new(0, newW, 0, newH)
            end
        end)
        rh.MouseEnter:Connect(function() Tw(rh,{BackgroundTransparency=0.3},0.12) end)
        rh.MouseLeave:Connect(function() Tw(rh,{BackgroundTransparency=0.6},0.12) end)
    end

    local ca=C("Frame",{Size=UDim2.new(1,0,1,-48),Position=UDim2.new(0,0,0,48),BackgroundTransparency=1,ClipsDescendants=true,Parent=main})
    local sb=C("Frame",{Size=UDim2.new(0,tW,1,0),BackgroundColor3=T.Bg2,BackgroundTransparency=T.SbTr,BorderSizePixel=0,Parent=ca}); Cn(sb,14); B(sb,{BackgroundColor3="Bg2",BackgroundTransparency="SbTr"})
    local sbR=C("Frame",{Position=UDim2.new(1,-14,0,0),Size=UDim2.new(0,14,1,0),BackgroundColor3=T.Bg2,BackgroundTransparency=T.SbTr,BorderSizePixel=0,Parent=sb}); B(sbR,{BackgroundColor3="Bg2",BackgroundTransparency="SbTr"})
    local sbT=C("Frame",{Size=UDim2.new(1,0,0,14),BackgroundColor3=T.Bg2,BackgroundTransparency=T.SbTr,BorderSizePixel=0,Parent=sb}); B(sbT,{BackgroundColor3="Bg2",BackgroundTransparency="SbTr"})

    local sbDiv = C("Frame",{Size=UDim2.new(0,1,1,0),Position=UDim2.new(1,0,0,0),BackgroundColor3=T.Border,BackgroundTransparency=0.6,BorderSizePixel=0,Parent=sb})
    B(sbDiv,{BackgroundColor3="Border"})

    local tl=C("ScrollingFrame",{Size=UDim2.new(1,-12,1,-12),Position=UDim2.new(0,6,0,6),BackgroundTransparency=1,ScrollBarThickness=2,ScrollBarImageColor3=T.Border,CanvasSize=UDim2.new(0,0,0,0),AutomaticCanvasSize=Enum.AutomaticSize.Y,Parent=sb})
    C("UIListLayout",{SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,3),Parent=tl})
    local ph=C("Frame",{Size=UDim2.new(1,-tW,1,0),Position=UDim2.new(0,tW,0,0),BackgroundTransparency=1,ClipsDescendants=true,Parent=ca})

    UIS.InputBegan:Connect(function(i,g) if g then return end; if i.KeyCode==mK then if W.Vis then hideWindow() else if floatBtn and floatBtn.Visible then floatBtn.Visible=false end; showWindow() end end end)

    function W:SelectTab(tab)
        if self.ActiveTab==tab then return end
        if self.ActiveTab then self.ActiveTab._sel=false; Tw(self.ActiveTab.Btn,{BackgroundColor3=T.Bg2,BackgroundTransparency=1},0.2); Tw(self.ActiveTab.Lbl,{TextColor3=T.Txt2},0.2); if self.ActiveTab.Ico then Tw(self.ActiveTab.Ico,{ImageColor3=T.Txt2},0.2) end; if self.ActiveTab.Ind then Tw(self.ActiveTab.Ind,{BackgroundTransparency=1},0.15) end; self.ActiveTab.Pg.Visible=false end
        self.ActiveTab=tab; tab._sel=true
        Tw(tab.Btn,{BackgroundColor3=T.El,BackgroundTransparency=T.ElTr*0.5},0.2); Tw(tab.Lbl,{TextColor3=T.Txt},0.2)
        if tab.Ico then Tw(tab.Ico,{ImageColor3=T.Txt},0.2) end
        if tab.Ind then Tw(tab.Ind,{BackgroundTransparency=0},0.15) end
        tab.Pg.Visible=true
    end

    function W:AddTab(o2)
        o2=o2 or {}; local n=o2.Title or "Tab"; local ic=o2.Icon
        local tab={Name=n,_sel=false}
        local btn=C("TextButton",{Size=UDim2.new(1,0,0,34),BackgroundColor3=T.Bg2,BackgroundTransparency=1,Text="",AutoButtonColor=false,Parent=tl}); Cn(btn,7)
        local ind=C("Frame",{Size=UDim2.new(0,3,0,16),Position=UDim2.new(0,0,0.5,-8),BackgroundColor3=T.Acc,BackgroundTransparency=1,BorderSizePixel=0,Parent=btn}); Cn(ind,2); B(ind,{BackgroundColor3="Acc"})
        tab.Ind=ind
        local iOff=0
        if ic then
            local img=C("ImageLabel",{Size=UDim2.new(0,16,0,16),Position=UDim2.new(0,11,0.5,-8),BackgroundTransparency=1,ImageColor3=T.Txt2,Parent=btn})
            ApplyIcon(img,GetIcon(ic))
            iOff=32; tab.Ico=img; B(img,{ImageColor3="Txt2"})
        end
        local lbl=C("TextLabel",{Size=UDim2.new(1,-(10+iOff),0,34),Position=UDim2.new(0,iOff+12,0,0),BackgroundTransparency=1,Text=n,TextColor3=T.Txt2,TextSize=12,Font=Enum.Font.GothamSemibold,TextXAlignment=Enum.TextXAlignment.Left,Parent=btn})
        tab.Btn=btn; tab.Lbl=lbl
        local function refreshTabColors()
            if tab._sel then Tw(btn,{BackgroundColor3=T.El,BackgroundTransparency=T.ElTr*0.5},0.3); Tw(lbl,{TextColor3=T.Txt},0.3); if tab.Ico then Tw(tab.Ico,{ImageColor3=T.Txt},0.3) end; if ind then Tw(ind,{BackgroundColor3=T.Acc,BackgroundTransparency=0},0.3) end
            else Tw(btn,{BackgroundColor3=T.Bg2,BackgroundTransparency=1},0.3); Tw(lbl,{TextColor3=T.Txt2},0.3); if tab.Ico then Tw(tab.Ico,{ImageColor3=T.Txt2},0.3) end; if ind then Tw(ind,{BackgroundColor3=T.Acc,BackgroundTransparency=1},0.3) end end
        end
        table.insert(TabRefreshers,{F=btn,R=refreshTabColors})
        btn.MouseEnter:Connect(function() if not tab._sel then Tw(btn,{BackgroundTransparency=0.45},0.1) end end)
        btn.MouseLeave:Connect(function() if not tab._sel then Tw(btn,{BackgroundTransparency=1},0.1) end end)
        btn.MouseButton1Click:Connect(function() self:SelectTab(tab) end)
        local pg=C("ScrollingFrame",{Size=UDim2.new(1,-18,1,-18),Position=UDim2.new(0,9,0,9),BackgroundTransparency=1,ScrollBarThickness=2,ScrollBarImageColor3=T.Border,CanvasSize=UDim2.new(0,0,0,0),AutomaticCanvasSize=Enum.AutomaticSize.Y,Visible=false,Parent=ph})
        C("UIListLayout",{SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,6),Parent=pg})
        tab.Pg=pg; table.insert(self.Tabs,tab); if #self.Tabs==1 then self:SelectTab(tab) end

        local function makeContainer(parent, h)
            parent = parent or pg
            local c=C("Frame",{Size=UDim2.new(1,0,0,h),BackgroundColor3=T.El,BackgroundTransparency=T.ElTr,Parent=parent}); Cn(c,10); local cs=St(c,T.Border,1,0.4); B(c,{BackgroundColor3="El",BackgroundTransparency="ElTr"}); B(cs,{Color="Border"}); return c
        end

        local function createElements(parent)
            local elements = {}
            function elements:AddParagraph(p) p=p or {}; local c=C("Frame",{Size=UDim2.new(1,0,0,0),BackgroundColor3=T.El,BackgroundTransparency=T.ElTr,AutomaticSize=Enum.AutomaticSize.Y,Parent=parent}); Cn(c,10); local cs=St(c,T.Border,1,0.4); Pd(c,12,12,14,14); B(c,{BackgroundColor3="El",BackgroundTransparency="ElTr"}); B(cs,{Color="Border"}); C("UIListLayout",{SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,2),Parent=c}); if (p.Title or "")~="" then local t=C("TextLabel",{Size=UDim2.new(1,0,0,15),BackgroundTransparency=1,Text=p.Title,TextColor3=T.Txt,TextSize=13,Font=Enum.Font.GothamBold,TextXAlignment=Enum.TextXAlignment.Left,Parent=c}); B(t,{TextColor3="Txt"}) end; local cl=C("TextLabel",{Size=UDim2.new(1,0,0,0),BackgroundTransparency=1,Text=p.Content or "",TextColor3=T.Txt2,TextSize=11,Font=Enum.Font.Gotham,TextXAlignment=Enum.TextXAlignment.Left,TextWrapped=true,AutomaticSize=Enum.AutomaticSize.Y,Parent=c}); B(cl,{TextColor3="Txt2"}); return {Type="Paragraph",Set=function(_,x) if x.Content then cl.Text=x.Content end end} end
            function elements:AddButton(p) p=p or {}; local h=(p.Description or "")~="" and 52 or 38; local c=makeContainer(parent,h); local b=C("TextButton",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Text="",AutoButtonColor=false,Parent=c}); local t=C("TextLabel",{Size=UDim2.new(1,-28,0,14),Position=UDim2.new(0,14,0,(p.Description or "")~="" and 9 or 12),BackgroundTransparency=1,Text=p.Title or "Button",TextColor3=T.Txt,TextSize=12,Font=Enum.Font.GothamSemibold,TextXAlignment=Enum.TextXAlignment.Left,Parent=c}); B(t,{TextColor3="Txt"}); if (p.Description or "")~="" then local d=C("TextLabel",{Size=UDim2.new(1,-28,0,12),Position=UDim2.new(0,14,0,26),BackgroundTransparency=1,Text=p.Description,TextColor3=T.Txt3,TextSize=10,Font=Enum.Font.Gotham,TextXAlignment=Enum.TextXAlignment.Left,Parent=c}); B(d,{TextColor3="Txt3"}) end; b.MouseEnter:Connect(function() Tw(c,{BackgroundColor3=T.ElHov},0.1) end); b.MouseLeave:Connect(function() Tw(c,{BackgroundColor3=T.El},0.1) end); b.MouseButton1Click:Connect(function() Tw(c,{BackgroundColor3=T.Bg3},0.05); task.wait(0.05); Tw(c,{BackgroundColor3=T.El},0.1); if p.Callback then p.Callback() end end); return {Type="Button"} end
            function elements:AddToggle(p) p=p or {}; local h=(p.Description or "")~="" and 52 or 38; local tog=p.Default or false; local fl=p.Flag or p.Title or "Tog"; local cb2=p.Callback or function() end; local c=makeContainer(parent,h); local t=C("TextLabel",{Size=UDim2.new(1,-68,0,14),Position=UDim2.new(0,14,0,(p.Description or "")~="" and 9 or 12),BackgroundTransparency=1,Text=p.Title or "Toggle",TextColor3=T.Txt,TextSize=12,Font=Enum.Font.GothamSemibold,TextXAlignment=Enum.TextXAlignment.Left,Parent=c}); B(t,{TextColor3="Txt"}); if (p.Description or "")~="" then local d=C("TextLabel",{Size=UDim2.new(1,-68,0,12),Position=UDim2.new(0,14,0,26),BackgroundTransparency=1,Text=p.Description,TextColor3=T.Txt3,TextSize=10,Font=Enum.Font.Gotham,TextXAlignment=Enum.TextXAlignment.Left,Parent=c}); B(d,{TextColor3="Txt3"}) end; local ot=C("Frame",{Size=UDim2.new(0,38,0,20),Position=UDim2.new(1,-52,0.5,-10),BackgroundColor3=tog and T.TOn or T.TOff,Parent=c}); Cn(ot,10); local inn=C("Frame",{Size=UDim2.new(0,14,0,14),Position=tog and UDim2.new(1,-17,0.5,-7) or UDim2.new(0,3,0.5,-7),BackgroundColor3=tog and T.Bg or T.Txt2,Parent=ot}); Cn(inn,7); local bt=C("TextButton",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Text="",AutoButtonColor=false,Parent=c}); local el={Type="Toggle",Value=tog,Flag=fl,Save=p.Save~=false}; local function upd() Tw(ot,{BackgroundColor3=tog and T.TOn or T.TOff},0.2); Tw(inn,{Position=tog and UDim2.new(1,-17,0.5,-7) or UDim2.new(0,3,0.5,-7),BackgroundColor3=tog and T.Bg or T.Txt2},0.2,Enum.EasingStyle.Back) end; function el:Set(v) tog=v; el.Value=v; upd(); cb2(v) end; bt.MouseButton1Click:Connect(function() tog=not tog; el.Value=tog; upd(); cb2(tog) end); table.insert(DDRefresh,{F=c,R=upd}); WraithFlags[fl]=el; return el end
            function elements:AddSlider(p) p=p or {}; local h=(p.Description or "")~="" and 70 or 52; local mn,mx=p.Min or 0,p.Max or 100; local def=p.Default or mn; local rd=p.Rounding or 1; local fl=p.Flag or p.Title or "Sl"; local sf=p.Suffix or ""; local cb2=p.Callback or function() end; local c=makeContainer(parent,h); local t=C("TextLabel",{Size=UDim2.new(1,-80,0,14),Position=UDim2.new(0,14,0,(p.Description or "")~="" and 7 or 5),BackgroundTransparency=1,Text=p.Title or "Slider",TextColor3=T.Txt,TextSize=12,Font=Enum.Font.GothamSemibold,TextXAlignment=Enum.TextXAlignment.Left,Parent=c}); B(t,{TextColor3="Txt"}); local vl=C("TextBox",{Size=UDim2.new(0,60,0,16),Position=UDim2.new(1,-74,0,(p.Description or "")~="" and 6 or 4),BackgroundTransparency=1,Text=tostring(def)..sf,TextColor3=T.Txt2,TextSize=11,Font=Enum.Font.GothamSemibold,TextXAlignment=Enum.TextXAlignment.Right,ClearTextOnFocus=true,Parent=c}); B(vl,{TextColor3="Txt2"}); if (p.Description or "")~="" then local d=C("TextLabel",{Size=UDim2.new(1,-28,0,12),Position=UDim2.new(0,14,0,22),BackgroundTransparency=1,Text=p.Description,TextColor3=T.Txt3,TextSize=10,Font=Enum.Font.Gotham,TextXAlignment=Enum.TextXAlignment.Left,Parent=c}); B(d,{TextColor3="Txt3"}) end; local bY=(p.Description or "")~="" and 44 or 28; local bg=C("Frame",{Size=UDim2.new(1,-28,0,5),Position=UDim2.new(0,14,0,bY),BackgroundColor3=T.Bg3,Parent=c}); Cn(bg,2); B(bg,{BackgroundColor3="Bg3"}); local iF=math.clamp((def-mn)/(mx-mn),0,1); local fl2=C("Frame",{Size=UDim2.new(iF,0,1,0),BackgroundColor3=T.Slider,Parent=bg}); Cn(fl2,2); B(fl2,{BackgroundColor3="Slider"}); local kn=C("Frame",{Size=UDim2.new(0,14,0,14),Position=UDim2.new(iF,-7,0.5,-7),BackgroundColor3=T.Txt,ZIndex=3,Parent=bg}); Cn(kn,7); B(kn,{BackgroundColor3="Txt"}); local knBtn=C("TextButton",{Size=UDim2.new(0,24,0,24),Position=UDim2.new(0,-5,0,-5),BackgroundTransparency=1,Text="",ZIndex=4,Parent=kn}); local dr=false; local el={Type="Slider",Value=def,Flag=fl,Save=p.Save~=false}; local function setVal(v) v=math.clamp(v,mn,mx); v=math.floor(v/rd+0.5)*rd; el.Value=v; local f=math.clamp((v-mn)/(mx-mn),0,1); Tw(fl2,{Size=UDim2.new(f,0,1,0)},0.06); Tw(kn,{Position=UDim2.new(f,-7,0.5,-7)},0.06); vl.Text=tostring(v)..sf; cb2(v) end; function el:Set(v) setVal(v) end; knBtn.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dr=true end end); knBtn.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dr=false end end); UIS.InputChanged:Connect(function(i) if dr and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then local pp=math.clamp((i.Position.X-bg.AbsolutePosition.X)/bg.AbsoluteSize.X,0,1); setVal(mn+(mx-mn)*pp) end end); vl.FocusLost:Connect(function() local raw=vl.Text:gsub(sf,""); local num=tonumber(raw); if num then setVal(num) else vl.Text=tostring(el.Value)..sf end end); WraithFlags[fl]=el; return el end
            function elements:AddDropdown(p) p=p or {}; local multi=p.Multi or false; local vals=p.Values or {}; local sel=multi and {} or p.Default; local fl=p.Flag or p.Title or "DD"; local cb2=p.Callback or function() end; local isO=false; if multi and p.Default and type(p.Default)=="table" then for _,v in ipairs(p.Default) do sel[v]=true end end; local ht=(p.Description or "")~="" and 68 or 50; local c=makeContainer(parent,ht); c.ClipsDescendants=true; local t=C("TextLabel",{Size=UDim2.new(1,-28,0,14),Position=UDim2.new(0,14,0,(p.Description or "")~="" and 7 or 5),BackgroundTransparency=1,Text=p.Title or "Dropdown",TextColor3=T.Txt,TextSize=12,Font=Enum.Font.GothamSemibold,TextXAlignment=Enum.TextXAlignment.Left,Parent=c}); B(t,{TextColor3="Txt"}); if (p.Description or "")~="" then local d=C("TextLabel",{Size=UDim2.new(1,-28,0,12),Position=UDim2.new(0,14,0,22),BackgroundTransparency=1,Text=p.Description,TextColor3=T.Txt3,TextSize=10,Font=Enum.Font.Gotham,TextXAlignment=Enum.TextXAlignment.Left,Parent=c}); B(d,{TextColor3="Txt3"}) end; local dY=(p.Description or "")~="" and 40 or 24; local db=C("TextButton",{Size=UDim2.new(1,-28,0,20),Position=UDim2.new(0,14,0,dY),BackgroundColor3=T.Bg3,Text="",AutoButtonColor=false,Parent=c}); Cn(db,5); local dbs=St(db,T.Border,1,0.5); B(db,{BackgroundColor3="Bg3"}); B(dbs,{Color="Border"}); local function gD() if multi then local it={}; for k,v in pairs(sel) do if v then table.insert(it,k) end end; return #it==0 and "None" or table.concat(it,", ") else return sel or "None" end end; local dl=C("TextLabel",{Size=UDim2.new(1,-20,1,0),Position=UDim2.new(0,7,0,0),BackgroundTransparency=1,Text=gD(),TextColor3=T.Txt2,TextSize=10,Font=Enum.Font.Gotham,TextXAlignment=Enum.TextXAlignment.Left,TextTruncate=Enum.TextTruncate.AtEnd,Parent=db}); B(dl,{TextColor3="Txt2"}); local al=C("TextLabel",{Size=UDim2.new(0,12,1,0),Position=UDim2.new(1,-16,0,0),BackgroundTransparency=1,Text="▼",TextColor3=T.Txt3,TextSize=8,Font=Enum.Font.Gotham,Parent=db}); B(al,{TextColor3="Txt3"}); local of=C("Frame",{Size=UDim2.new(1,-28,0,0),Position=UDim2.new(0,14,0,dY+24),BackgroundTransparency=1,ClipsDescendants=true,Parent=c}); C("UIListLayout",{SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,2),Parent=of}); local el={Type=multi and "MultiDropdown" or "Dropdown",Value=sel,Flag=fl,Save=p.Save~=false}; local function ref() for _,ch in ipairs(of:GetChildren()) do if ch:IsA("TextButton") then ch:Destroy() end end; for _,v in ipairs(vals) do local iS=multi and sel[v] or (sel==v); local ob=C("TextButton",{Size=UDim2.new(1,0,0,24),BackgroundColor3=iS and T.ElHov or T.Bg3,BackgroundTransparency=iS and 0.1 or 0.3,Text=v,TextColor3=iS and T.Txt or T.Txt2,TextSize=10,Font=Enum.Font.Gotham,AutoButtonColor=false,Parent=of}); Cn(ob,5); if iS then B(ob,{BackgroundColor3="ElHov",TextColor3="Txt"}) else B(ob,{BackgroundColor3="Bg3",TextColor3="Txt2"}) end; ob.MouseEnter:Connect(function() Tw(ob,{BackgroundTransparency=0.05},0.08) end); ob.MouseLeave:Connect(function() local s=multi and sel[v] or (sel==v); Tw(ob,{BackgroundTransparency=s and 0.1 or 0.3},0.08) end); ob.MouseButton1Click:Connect(function() if multi then sel[v]=not sel[v]; el.Value=sel else sel=v; el.Value=v end; dl.Text=gD(); ref(); cb2(multi and sel or v); if not multi then isO=false; Tw(c,{Size=UDim2.new(1,0,0,ht)},0.2); Tw(of,{Size=UDim2.new(1,-28,0,0)},0.2); al.Text="▼" end end) end end; ref(); table.insert(DDRefresh,{F=c,R=ref}); db.MouseButton1Click:Connect(function() isO=not isO; if isO then local oh=#vals*26; Tw(c,{Size=UDim2.new(1,0,0,ht+oh+4)},0.2); Tw(of,{Size=UDim2.new(1,-28,0,oh)},0.2); al.Text="▲" else Tw(c,{Size=UDim2.new(1,0,0,ht)},0.2); Tw(of,{Size=UDim2.new(1,-28,0,0)},0.2); al.Text="▼" end end); function el:Set(v) if multi then if type(v)=="table" then sel=v end else sel=v end; el.Value=sel; dl.Text=gD(); ref(); cb2(sel) end; function el:SetValues(nv) vals=nv; ref() end; WraithFlags[fl]=el; return el end
            function elements:AddMultiDropdown(p) p.Multi=true; return self:AddDropdown(p) end
            function elements:AddColorpicker(p) p=p or {}; local cur=p.Default or Color3.fromRGB(255,255,255); local fl=p.Flag or p.Title or "CP"; local cb2=p.Callback or function() end; local c=makeContainer(parent,38); local t=C("TextLabel",{Size=UDim2.new(1,-68,0,14),Position=UDim2.new(0,14,0,12),BackgroundTransparency=1,Text=p.Title or "Color",TextColor3=T.Txt,TextSize=12,Font=Enum.Font.GothamSemibold,TextXAlignment=Enum.TextXAlignment.Left,Parent=c}); B(t,{TextColor3="Txt"}); local pv=C("TextButton",{Size=UDim2.new(0,26,0,18),Position=UDim2.new(1,-40,0,10),BackgroundColor3=cur,Text="",AutoButtonColor=false,Parent=c}); Cn(pv,5); local pvs=St(pv,T.Border,1,0.35); B(pvs,{Color="Border"}); local el={Type="Colorpicker",Value=cur,Flag=fl,Save=p.Save~=false}; pv.MouseButton1Click:Connect(function() ColorDialog(el.Value,function(nc) el.Value=nc; pv.BackgroundColor3=nc; cb2(nc) end) end); function el:Set(col) if type(col)=="string" then pcall(function() col=Color3.fromHex(col) end) end; el.Value=col; pv.BackgroundColor3=col; cb2(col) end; WraithFlags[fl]=el; return el end
            function elements:AddKeybind(p) p=p or {}; local ck=p.Default; local fl=p.Flag or p.Title or "KB"; local cb2,ccb=p.Callback or function() end,p.ChangedCallback or function() end; local lis=false; local c=makeContainer(parent,38); local t=C("TextLabel",{Size=UDim2.new(1,-94,0,14),Position=UDim2.new(0,14,0,12),BackgroundTransparency=1,Text=p.Title or "Keybind",TextColor3=T.Txt,TextSize=12,Font=Enum.Font.GothamSemibold,TextXAlignment=Enum.TextXAlignment.Left,Parent=c}); B(t,{TextColor3="Txt"}); local kb=C("TextButton",{Size=UDim2.new(0,66,0,22),Position=UDim2.new(1,-80,0,8),BackgroundColor3=T.Bg3,Text=ck and ck.Name or "None",TextColor3=T.Txt2,TextSize=10,Font=Enum.Font.GothamSemibold,AutoButtonColor=false,Parent=c}); Cn(kb,5); local kbs=St(kb,T.Border,1,0.5); B(kb,{BackgroundColor3="Bg3",TextColor3="Txt2"}); B(kbs,{Color="Border"}); local el={Type="Keybind",Value=ck,Flag=fl,Save=p.Save~=false}; kb.MouseButton1Click:Connect(function() lis=true; kb.Text="..." end); UIS.InputBegan:Connect(function(i,g) if g then return end; if lis then if i.UserInputType==Enum.UserInputType.Keyboard then if i.KeyCode==Enum.KeyCode.Escape then ck=nil; kb.Text="None" else ck=i.KeyCode; kb.Text=ck.Name end; el.Value=ck; lis=false; ccb(ck) end elseif ck and i.KeyCode==ck then cb2(ck) end end); function el:Set(k) if type(k)=="string" then k=Enum.KeyCode[k] end; ck=k; el.Value=k; kb.Text=k and k.Name or "None"; ccb(k) end; WraithFlags[fl]=el; return el end
            function elements:AddInput(p) p=p or {}; local h=(p.Description or "")~="" and 68 or 50; local fl=p.Flag or p.Title or "In"; local cb2=p.Callback or function() end; local c=makeContainer(parent,h); local t=C("TextLabel",{Size=UDim2.new(1,-28,0,14),Position=UDim2.new(0,14,0,(p.Description or "")~="" and 7 or 5),BackgroundTransparency=1,Text=p.Title or "Input",TextColor3=T.Txt,TextSize=12,Font=Enum.Font.GothamSemibold,TextXAlignment=Enum.TextXAlignment.Left,Parent=c}); B(t,{TextColor3="Txt"}); if (p.Description or "")~="" then local d=C("TextLabel",{Size=UDim2.new(1,-28,0,12),Position=UDim2.new(0,14,0,22),BackgroundTransparency=1,Text=p.Description,TextColor3=T.Txt3,TextSize=10,Font=Enum.Font.Gotham,TextXAlignment=Enum.TextXAlignment.Left,Parent=c}); B(d,{TextColor3="Txt3"}) end; local iY=(p.Description or "")~="" and 40 or 26; local ib=C("TextBox",{Size=UDim2.new(1,-28,0,20),Position=UDim2.new(0,14,0,iY),BackgroundColor3=T.Bg3,Text=p.Default or "",PlaceholderText=p.Placeholder or "Type...",PlaceholderColor3=T.Txt3,TextColor3=T.Txt,TextSize=10,Font=Enum.Font.Gotham,ClearTextOnFocus=false,Parent=c}); Cn(ib,5); Pd(ib,0,0,7,7); local ibs=St(ib,T.Border,1,0.5); B(ib,{BackgroundColor3="Bg3",TextColor3="Txt"}); B(ibs,{Color="Border"}); local el={Type="Input",Value=p.Default or "",Flag=fl,Save=p.Save~=false}; ib.FocusLost:Connect(function() local v=ib.Text; if p.Numeric then v=tonumber(v) or el.Value; ib.Text=tostring(v) end; el.Value=v; cb2(v) end); function el:Set(v) el.Value=v; ib.Text=tostring(v); cb2(v) end; WraithFlags[fl]=el; return el end
            function elements:AddSeparator() local s=C("Frame",{Size=UDim2.new(1,0,0,1),BackgroundColor3=T.Border,BackgroundTransparency=0.5,Parent=parent}); B(s,{BackgroundColor3="Border"}); return {Type="Separator"} end
            function elements:AddDivider(p) p=p or {}; local f=C("Frame",{Size=UDim2.new(1,0,0,22),BackgroundTransparency=1,Parent=parent}); local l=C("TextLabel",{Size=UDim2.new(1,0,0,14),Position=UDim2.new(0,0,0,4),BackgroundTransparency=1,Text=p.Text or "—",TextColor3=T.Txt3,TextSize=10,Font=Enum.Font.GothamSemibold,TextXAlignment=Enum.TextXAlignment.Center,Parent=f}); B(l,{TextColor3="Txt3"}); local line1=C("Frame",{Size=UDim2.new(0.3,0,0,1),Position=UDim2.new(0,0,0.5,0),BackgroundColor3=T.Border,BackgroundTransparency=0.5,Parent=f}); B(line1,{BackgroundColor3="Border"}); local line2=C("Frame",{Size=UDim2.new(0.3,0,0,1),Position=UDim2.new(0.7,0,0.5,0),BackgroundColor3=T.Border,BackgroundTransparency=0.5,Parent=f}); B(line2,{BackgroundColor3="Border"}); return {Type="Divider"} end
            function elements:AddLabel(p) p=p or {}; local l=C("TextLabel",{Size=UDim2.new(1,0,0,18),BackgroundTransparency=1,Text=p.Text or "",TextColor3=T.Txt3,TextSize=11,Font=Enum.Font.GothamSemibold,TextXAlignment=Enum.TextXAlignment.Left,Parent=parent}); B(l,{TextColor3="Txt3"}); local el={Type="Label"}; function el:Set(txt) l.Text=txt end; return el end
            function elements:AddProgressBar(p) p=p or {}; local fl=p.Flag or p.Title or "PB"; local c=makeContainer(parent,42); local t=C("TextLabel",{Size=UDim2.new(1,-60,0,14),Position=UDim2.new(0,14,0,5),BackgroundTransparency=1,Text=p.Title or "Progress",TextColor3=T.Txt,TextSize=12,Font=Enum.Font.GothamSemibold,TextXAlignment=Enum.TextXAlignment.Left,Parent=c}); B(t,{TextColor3="Txt"}); local vl=C("TextLabel",{Size=UDim2.new(0,40,0,14),Position=UDim2.new(1,-54,0,5),BackgroundTransparency=1,Text=tostring(p.Default or 0).."%",TextColor3=T.Txt2,TextSize=10,Font=Enum.Font.GothamSemibold,TextXAlignment=Enum.TextXAlignment.Right,Parent=c}); B(vl,{TextColor3="Txt2"}); local bg=C("Frame",{Size=UDim2.new(1,-28,0,5),Position=UDim2.new(0,14,0,26),BackgroundColor3=T.Bg3,Parent=c}); Cn(bg,2); B(bg,{BackgroundColor3="Bg3"}); local def=math.clamp((p.Default or 0)/100,0,1); local fl2=C("Frame",{Size=UDim2.new(def,0,1,0),BackgroundColor3=T.Slider,Parent=bg}); Cn(fl2,2); B(fl2,{BackgroundColor3="Slider"}); local el={Type="ProgressBar",Value=p.Default or 0,Flag=fl}; function el:Set(v) v=math.clamp(v,0,100); el.Value=v; Tw(fl2,{Size=UDim2.new(v/100,0,1,0)},0.2); vl.Text=tostring(v).."%" end; WraithFlags[fl]=el; return el end
            return elements
        end

        local tabElements = createElements(pg)
        for k, v in pairs(tabElements) do tab[k] = v end

        function tab:AddSection(p)
            p = p or {}
            local sectionFrame = C("Frame",{Size=UDim2.new(1,0,0,0),BackgroundTransparency=1,AutomaticSize=Enum.AutomaticSize.Y,Parent=pg})
            if p.Title then
                local titleLabel = C("TextLabel",{Size=UDim2.new(1,0,0,18),BackgroundTransparency=1,Text=p.Title,TextColor3=T.Txt,TextSize=13,Font=Enum.Font.GothamBold,TextXAlignment=Enum.TextXAlignment.Left,Parent=sectionFrame})
                B(titleLabel,{TextColor3="Txt"})
            end
            local content = C("Frame",{Size=UDim2.new(1,0,0,0),Position=UDim2.new(0,0,0,p.Title and 22 or 0),BackgroundTransparency=1,AutomaticSize=Enum.AutomaticSize.Y,Parent=sectionFrame})
            C("UIListLayout",{SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,6),Parent=content})
            return createElements(content)
        end

        return tab
    end

    W.MainFrame=main; W.FloatButton=floatBtn
    function W:Show() showWindow() end
    function W:Hide() hideWindow() end
    function W:Minimize() minimizeWindow() end
    function W:Destroy() if main then main:Destroy() end; if floatBtn then floatBtn:Destroy() end end
    function W:Resize(width, height) W.CurrentSize = UDim2.new(0, width, 0, height); main.Size = W.CurrentSize end
    return W
end

Wraith.Icons={LoadPlatform=function(p) LoadIcons(p) end,Get=function(n) return GetIcon(n) end}

pcall(function() if CoreGui:FindFirstChild("Wraith") then CoreGui:FindFirstChild("Wraith"):Destroy() end end)
pcall(function() if gethui and gethui():FindFirstChild("Wraith") then gethui():FindFirstChild("Wraith"):Destroy() end end)
LoadCustomThemes()
LoadThemePref()
LoadIcons("Lucide")
return Wraith
