local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local GuiService = game:GetService("GuiService")
local HapticService = game:GetService("HapticService")
local ContextActionService = game:GetService("ContextActionService")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local Platform = {
    IsMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled,
    IsConsole = UserInputService.GamepadEnabled and not UserInputService.KeyboardEnabled and not UserInputService.TouchEnabled,
    IsPC = UserInputService.KeyboardEnabled and UserInputService.MouseEnabled,
    IsTouch = UserInputService.TouchEnabled
}

if UserInputService.TouchEnabled and UserInputService.KeyboardEnabled then
    Platform.IsMobile = false
    Platform.IsPC = true
end

local IconPacks = {
    ["Lucide"] = "https://raw.githubusercontent.com/maybeflexa/Wraith-Lib/refs/heads/main/Icons/Lucide",
    ["Gravity"] = "https://raw.githubusercontent.com/maybeflexa/Wraith-Lib/refs/heads/main/Icons/Gravity",
    ["Solar"] = "https://raw.githubusercontent.com/maybeflexa/Wraith-Lib/refs/heads/main/Icons/Solar",
    ["SFSymbols"] = "https://raw.githubusercontent.com/maybeflexa/Wraith-Lib/refs/heads/main/Icons/SFSymbols"
}

local LoadedIcons = {}
local CurrentIconPack = "Lucide"

local function LoadIcons(pack)
    local success, rawData = pcall(function()
        return game:HttpGet(IconPacks[pack])
    end)
    if success and rawData then
        local func = loadstring(rawData)
        if func then
            local result = func()
            if type(result) == "table" then
                LoadedIcons = result
                CurrentIconPack = pack
            end
        end
    end
end

local function GetIcon(name)
    if not name or name == "" then return "" end
    local id = LoadedIcons[name]
    if not id then return "" end
    if tostring(id):find("rbxassetid://") then
        return tostring(id)
    end
    return "rbxassetid://" .. tostring(id)
end

pcall(function()
    LoadIcons("Lucide")
end)

local function GetScreenSize()
    return workspace.CurrentCamera.ViewportSize
end

local function ScaleForPlatform(base)
    if Platform.IsMobile then return base * 1.15 end
    if Platform.IsConsole then return base * 1.2 end
    return base
end

local function Create(className, properties)
    local inst = Instance.new(className)
    for k, v in pairs(properties) do
        if k ~= "Parent" then
            pcall(function()
                inst[k] = v
            end)
        end
    end
    if properties.Parent then
        inst.Parent = properties.Parent
    end
    return inst
end

local function AddCorner(parent, radius)
    return Create("UICorner", {
        CornerRadius = UDim.new(0, radius or 6),
        Parent = parent
    })
end

local function AddStroke(parent, color, thickness)
    return Create("UIStroke", {
        Color = color or Color3.fromRGB(40, 40, 40),
        Thickness = thickness or 1,
        Parent = parent
    })
end

local function AddPadding(parent, top, bottom, left, right)
    return Create("UIPadding", {
        PaddingTop = UDim.new(0, top or 0),
        PaddingBottom = UDim.new(0, bottom or 0),
        PaddingLeft = UDim.new(0, left or 0),
        PaddingRight = UDim.new(0, right or 0),
        Parent = parent
    })
end

local function AddListLayout(parent, padding, direction, hAlign, vAlign, sortOrder)
    return Create("UIListLayout", {
        Padding = UDim.new(0, padding or 4),
        FillDirection = direction or Enum.FillDirection.Vertical,
        HorizontalAlignment = hAlign or Enum.HorizontalAlignment.Left,
        VerticalAlignment = vAlign or Enum.VerticalAlignment.Top,
        SortOrder = sortOrder or Enum.SortOrder.LayoutOrder,
        Parent = parent
    })
end

local function Tween(obj, props, duration, style, direction)
    local tweenInfo = TweenInfo.new(duration or 0.2, style or Enum.EasingStyle.Quad, direction or Enum.EasingDirection.Out)
    local tween = TweenService:Create(obj, tweenInfo, props)
    tween:Play()
    return tween
end

local function HapticFeedback()
    if Platform.IsConsole or Platform.IsMobile then
        pcall(function()
            HapticService:SetMotor(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.Small, 0.2)
            task.delay(0.1, function()
                pcall(function()
                    HapticService:SetMotor(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.Small, 0)
                end)
            end)
        end)
    end
end

local Colors = {
    WindowBg = Color3.fromRGB(18, 18, 18),
    Topbar = Color3.fromRGB(12, 12, 12),
    Sidebar = Color3.fromRGB(15, 15, 15),
    TabSelected = Color3.fromRGB(30, 30, 30),
    TabHover = Color3.fromRGB(25, 25, 25),
    Content = Color3.fromRGB(20, 20, 20),
    ElementBg = Color3.fromRGB(28, 28, 28),
    Border = Color3.fromRGB(40, 40, 40),
    PrimaryText = Color3.fromRGB(240, 240, 240),
    SecondaryText = Color3.fromRGB(160, 160, 160),
    Accent = Color3.fromRGB(200, 200, 200),
    WLogo = Color3.fromRGB(255, 255, 255),
    ConsoleFocus = Color3.fromRGB(200, 200, 200),
    MobileButton = Color3.fromRGB(18, 18, 18),
    ToggleOff = Color3.fromRGB(40, 40, 40),
    ToggleOn = Color3.fromRGB(200, 200, 200),
}

local Library = {}
Library.__index = Library
Library.Options = {}
Library.Unloaded = false
Library.CurrentIconPack = "Lucide"
Library.MinimizeKey = Enum.KeyCode.LeftControl
Library.UIScale = 1
Library._windows = {}
Library._notifications = {}
Library._screenGui = nil
Library._notifContainer = nil
Library._mobileToggle = nil

function Library:_getScreenGui()
    if self._screenGui and self._screenGui.Parent then
        return self._screenGui
    end
    local sg
    local success = pcall(function()
        sg = Create("ScreenGui", {
            Name = "WraithUI_" .. HttpService:GenerateGUID(false),
            ResetOnSpawn = false,
            ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
            IgnoreGuiInset = true,
            Parent = CoreGui
        })
    end)
    if not success or not sg then
        sg = Create("ScreenGui", {
            Name = "WraithUI_" .. HttpService:GenerateGUID(false),
            ResetOnSpawn = false,
            ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
            IgnoreGuiInset = true,
            Parent = LocalPlayer:WaitForChild("PlayerGui")
        })
    end
    self._screenGui = sg
    return sg
end

function Library:_ensureNotifContainer()
    if self._notifContainer and self._notifContainer.Parent then
        return self._notifContainer
    end
    local sg = self:_getScreenGui()
    local container = Create("Frame", {
        Name = "NotificationContainer",
        Size = UDim2.new(0, 300, 1, -20),
        Position = Platform.IsMobile and UDim2.new(0.5, -150, 0, 10) or UDim2.new(1, -310, 0, 10),
        BackgroundTransparency = 1,
        Parent = sg
    })
    local layout = AddListLayout(container, 6, Enum.FillDirection.Vertical, 
        Platform.IsMobile and Enum.HorizontalAlignment.Center or Enum.HorizontalAlignment.Right,
        Enum.VerticalAlignment.Top)
    self._notifContainer = container
    return container
end

function Library:Notify(config)
    config = config or {}
    local title = config.Title or "Notification"
    local content = config.Content or ""
    local subContent = config.SubContent or ""
    local duration = config.Duration or 5

    local container = self:_ensureNotifContainer()

    local notifFrame = Create("Frame", {
        Name = "Notification",
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundColor3 = Colors.ElementBg,
        Parent = container
    })
    AddCorner(notifFrame, 6)
    AddStroke(notifFrame, Colors.Border)
    notifFrame.Position = UDim2.new(1, 50, 0, 0)

    local notifPadding = AddPadding(notifFrame, 10, 10, 12, 12)

    local notifLayout = AddListLayout(notifFrame, 4)

    local titleLabel = Create("TextLabel", {
        Name = "Title",
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = Colors.PrimaryText,
        Font = Enum.Font.GothamBold,
        TextSize = ScaleForPlatform(14),
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true,
        Parent = notifFrame
    })

    if content ~= "" then
        local contentLabel = Create("TextLabel", {
            Name = "Content",
            Size = UDim2.new(1, 0, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1,
            Text = content,
            TextColor3 = Colors.SecondaryText,
            Font = Enum.Font.Gotham,
            TextSize = ScaleForPlatform(12),
            TextXAlignment = Enum.TextXAlignment.Left,
            TextWrapped = true,
            Parent = notifFrame
        })
    end

    if subContent ~= "" then
        local subLabel = Create("TextLabel", {
            Name = "SubContent",
            Size = UDim2.new(1, 0, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1,
            Text = subContent,
            TextColor3 = Color3.fromRGB(120, 120, 120),
            Font = Enum.Font.Gotham,
            TextSize = ScaleForPlatform(11),
            TextXAlignment = Enum.TextXAlignment.Left,
            TextWrapped = true,
            Parent = notifFrame
        })
    end

    Tween(notifFrame, {Position = UDim2.new(0, 0, 0, 0)}, 0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

    local function dismissNotif()
        Tween(notifFrame, {Position = UDim2.new(1, 50, 0, 0)}, 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
        task.delay(0.25, function()
            pcall(function() notifFrame:Destroy() end)
        end)
    end

    task.delay(duration, function()
        if notifFrame and notifFrame.Parent then
            dismissNotif()
        end
    end)

    if Platform.IsConsole then
        local conn
        conn = UserInputService.InputBegan:Connect(function(input)
            if input.KeyCode == Enum.KeyCode.ButtonB then
                if notifFrame and notifFrame.Parent then
                    dismissNotif()
                    if conn then conn:Disconnect() end
                end
            end
        end)
    end

    return notifFrame
end

local WindowClass = {}
WindowClass.__index = WindowClass

function Library:CreateWindow(config)
    config = config or {}
    local title = config.Title or "Wraith"
    local subTitle = config.SubTitle or ""
    local tabWidth = config.TabWidth or 160
    local size = config.Size or UDim2.fromOffset(580, 460)
    local minimizeKey = config.MinimizeKey or Enum.KeyCode.LeftControl

    self.MinimizeKey = minimizeKey

    local sg = self:_getScreenGui()

    local window = setmetatable({}, WindowClass)
    window._library = self
    window._tabs = {}
    window._activeTab = nil
    window._visible = true
    window._tabWidth = tabWidth
    window._config = config
    window._consoleFocusIndex = 1
    window._consoleElements = {}

    local screenSize = GetScreenSize()

    local windowSize
    if Platform.IsMobile then
        local w = math.min(screenSize.X * 0.85, 500)
        local h = math.min(screenSize.Y * 0.8, 500)
        windowSize = UDim2.fromOffset(w, h)
    elseif Platform.IsConsole then
        windowSize = UDim2.fromOffset(math.min(size.X.Offset, screenSize.X * 0.7), math.min(size.Y.Offset, screenSize.Y * 0.7))
    else
        windowSize = size
    end

    local mainFrame = Create("Frame", {
        Name = "WraithWindow",
        Size = windowSize,
        Position = UDim2.new(0.5, -windowSize.X.Offset / 2, 0.5, -windowSize.Y.Offset / 2),
        BackgroundColor3 = Colors.WindowBg,
        ClipsDescendants = true,
        Parent = sg
    })
    AddCorner(mainFrame, 8)
    AddStroke(mainFrame, Colors.Border)
    window.MainFrame = mainFrame

    mainFrame.BackgroundTransparency = 1
    Tween(mainFrame, {BackgroundTransparency = 0}, 0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

    local topbarHeight = ScaleForPlatform(36)
    local topbar = Create("Frame", {
        Name = "Topbar",
        Size = UDim2.new(1, 0, 0, topbarHeight),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = Colors.Topbar,
        Parent = mainFrame
    })
    Create("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = topbar
    })
    local topbarBottomCover = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 8),
        Position = UDim2.new(0, 0, 1, -8),
        BackgroundColor3 = Colors.Topbar,
        BorderSizePixel = 0,
        Parent = topbar
    })
    window.Topbar = topbar

    local wLogo = Create("TextLabel", {
        Name = "WLogo",
        Size = UDim2.new(0, 30, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = "W",
        TextColor3 = Colors.WLogo,
        Font = Enum.Font.GothamBold,
        TextSize = ScaleForPlatform(18),
        TextXAlignment = Enum.TextXAlignment.Center,
        Parent = topbar
    })

    local titleLabel = Create("TextLabel", {
        Name = "Title",
        Size = UDim2.new(0, 200, 1, 0),
        Position = UDim2.new(0, 44, 0, 0),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = Colors.PrimaryText,
        Font = Enum.Font.GothamBold,
        TextSize = ScaleForPlatform(14),
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = topbar
    })

    if subTitle ~= "" then
        local subLabel = Create("TextLabel", {
            Name = "SubTitle",
            Size = UDim2.new(0, 200, 1, 0),
            Position = UDim2.new(0, 44 + titleLabel.TextBounds.X + 6, 0, 0),
            BackgroundTransparency = 1,
            Text = subTitle,
            TextColor3 = Colors.SecondaryText,
            Font = Enum.Font.Gotham,
            TextSize = ScaleForPlatform(12),
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = topbar
        })
        task.defer(function()
            task.wait(0.1)
            pcall(function()
                subLabel.Position = UDim2.new(0, 44 + titleLabel.TextBounds.X + 6, 0, 0)
            end)
        end)
    end

    local closeBtn = Create("TextButton", {
        Name = "Close",
        Size = UDim2.new(0, topbarHeight, 0, topbarHeight),
        Position = UDim2.new(1, -topbarHeight, 0, 0),
        BackgroundTransparency = 1,
        Text = "×",
        TextColor3 = Colors.SecondaryText,
        Font = Enum.Font.GothamBold,
        TextSize = ScaleForPlatform(18),
        Parent = topbar
    })

    closeBtn.MouseButton1Click:Connect(function()
        window:_destroy()
    end)

    if Platform.IsPC then
        closeBtn.MouseEnter:Connect(function()
            Tween(closeBtn, {TextColor3 = Colors.PrimaryText}, 0.15)
        end)
        closeBtn.MouseLeave:Connect(function()
            Tween(closeBtn, {TextColor3 = Colors.SecondaryText}, 0.15)
        end)
    end

    local minimizeBtn = Create("TextButton", {
        Name = "Minimize",
        Size = UDim2.new(0, topbarHeight, 0, topbarHeight),
        Position = UDim2.new(1, -topbarHeight * 2, 0, 0),
        BackgroundTransparency = 1,
        Text = "—",
        TextColor3 = Colors.SecondaryText,
        Font = Enum.Font.GothamBold,
        TextSize = ScaleForPlatform(14),
        Parent = topbar
    })

    minimizeBtn.MouseButton1Click:Connect(function()
        window:_toggleVisible()
    end)

    if Platform.IsPC then
        minimizeBtn.MouseEnter:Connect(function()
            Tween(minimizeBtn, {TextColor3 = Colors.PrimaryText}, 0.15)
        end)
        minimizeBtn.MouseLeave:Connect(function()
            Tween(minimizeBtn, {TextColor3 = Colors.SecondaryText}, 0.15)
        end)
    end

    local bodyFrame = Create("Frame", {
        Name = "Body",
        Size = UDim2.new(1, 0, 1, -topbarHeight),
        Position = UDim2.new(0, 0, 0, topbarHeight),
        BackgroundTransparency = 1,
        Parent = mainFrame
    })

    if Platform.IsMobile then
        local contentFrame = Create("Frame", {
            Name = "Content",
            Size = UDim2.new(1, 0, 1, -44),
            Position = UDim2.new(0, 0, 0, 0),
            BackgroundColor3 = Colors.Content,
            BorderSizePixel = 0,
            Parent = bodyFrame
        })
        window.ContentFrame = contentFrame

        local mobileTabBar = Create("Frame", {
            Name = "MobileTabBar",
            Size = UDim2.new(1, 0, 0, 44),
            Position = UDim2.new(0, 0, 1, -44),
            BackgroundColor3 = Colors.Sidebar,
            BorderSizePixel = 0,
            Parent = bodyFrame
        })
        AddStroke(mobileTabBar, Colors.Border)

        local tabScroll = Create("ScrollingFrame", {
            Name = "TabScroll",
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            ScrollBarThickness = 0,
            ScrollingDirection = Enum.ScrollingDirection.X,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            AutomaticCanvasSize = Enum.AutomaticSize.X,
            Parent = mobileTabBar
        })
        AddListLayout(tabScroll, 2, Enum.FillDirection.Horizontal, Enum.HorizontalAlignment.Center, Enum.VerticalAlignment.Center)
        AddPadding(tabScroll, 4, 4, 8, 8)
        window.TabContainer = tabScroll
    else
        local sidebar = Create("Frame", {
            Name = "Sidebar",
            Size = UDim2.new(0, tabWidth, 1, 0),
            Position = UDim2.new(0, 0, 0, 0),
            BackgroundColor3 = Colors.Sidebar,
            BorderSizePixel = 0,
            ClipsDescendants = true,
            Parent = bodyFrame
        })

        local sidebarScroll = Create("ScrollingFrame", {
            Name = "TabList",
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            ScrollBarThickness = 2,
            ScrollBarImageColor3 = Colors.Border,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            Parent = sidebar
        })
        AddListLayout(sidebarScroll, 2)
        AddPadding(sidebarScroll, 6, 6, 6, 6)
        window.TabContainer = sidebarScroll
        window.Sidebar = sidebar

        local contentFrame = Create("Frame", {
            Name = "Content",
            Size = UDim2.new(1, -tabWidth, 1, 0),
            Position = UDim2.new(0, tabWidth, 0, 0),
            BackgroundColor3 = Colors.Content,
            BorderSizePixel = 0,
            ClipsDescendants = true,
            Parent = bodyFrame
        })
        window.ContentFrame = contentFrame
    end

    if Platform.IsPC then
        local dragging = false
        local dragInput = nil
        local dragStart = nil
        local startPos = nil

        topbar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = mainFrame.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false
                    end
                end)
            end
        end)

        topbar.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                dragInput = input
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if dragging and input == dragInput then
                local delta = input.Position - dragStart
                mainFrame.Position = UDim2.new(
                    startPos.X.Scale, startPos.X.Offset + delta.X,
                    startPos.Y.Scale, startPos.Y.Offset + delta.Y
                )
            end
        end)
    end

    if Platform.IsPC then
        UserInputService.InputBegan:Connect(function(input, processed)
            if processed then return end
            if input.KeyCode == self.MinimizeKey then
                window:_toggleVisible()
            end
        end)
    end

    if Platform.IsMobile then
        local mobileBtn = Create("TextButton", {
            Name = "MobileToggle",
            Size = UDim2.new(0, 50, 0, 50),
            Position = UDim2.new(1, -65, 1, -65),
            BackgroundColor3 = Colors.MobileButton,
            Text = "W",
            TextColor3 = Colors.WLogo,
            Font = Enum.Font.GothamBold,
            TextSize = 20,
            Parent = sg
        })
        Create("UICorner", {
            CornerRadius = UDim.new(1, 0),
            Parent = mobileBtn
        })
        AddStroke(mobileBtn, Colors.Border, 2)

        local mobileDrag = false
        local mobileDragStart = nil
        local mobileBtnStart = nil

        mobileBtn.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch then
                mobileDrag = true
                mobileDragStart = input.Position
                mobileBtnStart = mobileBtn.Position
                local moveConn
                local endConn
                moveConn = UserInputService.InputChanged:Connect(function(moved)
                    if moved.UserInputType == Enum.UserInputType.Touch and mobileDrag then
                        local delta = moved.Position - mobileDragStart
                        if delta.Magnitude > 10 then
                            mobileBtn.Position = UDim2.new(
                                mobileBtnStart.X.Scale, mobileBtnStart.X.Offset + delta.X,
                                mobileBtnStart.Y.Scale, mobileBtnStart.Y.Offset + delta.Y
                            )
                        end
                    end
                end)
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        mobileDrag = false
                        if moveConn then moveConn:Disconnect() end
                        local delta = input.Position - mobileDragStart
                        if delta.Magnitude <= 10 then
                            window:_toggleVisible()
                            HapticFeedback()
                        end
                    end
                end)
            end
        end)
        window._mobileBtn = mobileBtn
        self._mobileToggle = mobileBtn
    end

    if Platform.IsConsole then
        local hintsBar = Create("Frame", {
            Name = "GamepadHints",
            Size = UDim2.new(1, 0, 0, 30),
            Position = UDim2.new(0, 0, 1, -30),
            BackgroundColor3 = Colors.Topbar,
            BorderSizePixel = 0,
            Parent = mainFrame
        })
        local hintsLabel = Create("TextLabel", {
            Size = UDim2.new(1, -20, 1, 0),
            Position = UDim2.new(0, 10, 0, 0),
            BackgroundTransparency = 1,
            Text = "[A] Select  [B] Back  [X] UI  [Y] Tabs",
            TextColor3 = Colors.SecondaryText,
            Font = Enum.Font.Gotham,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Center,
            Parent = hintsBar
        })

        pcall(function()
            ContextActionService:BindAction("WraithToggleUI", function(_, state)
                if state == Enum.UserInputState.Begin then
                    window:_toggleVisible()
                    HapticFeedback()
                end
            end, false, Enum.KeyCode.ButtonX)

            ContextActionService:BindAction("WraithSwitchTab", function(_, state)
                if state == Enum.UserInputState.Begin then
                    local idx = 1
                    for i, t in ipairs(window._tabs) do
                        if t == window._activeTab then
                            idx = i
                            break
                        end
                    end
                    idx = idx + 1
                    if idx > #window._tabs then idx = 1 end
                    window:SelectTab(idx)
                    HapticFeedback()
                end
            end, false, Enum.KeyCode.ButtonY)

            ContextActionService:BindAction("WraithBack", function(_, state)
                if state == Enum.UserInputState.Begin then
                    HapticFeedback()
                end
            end, false, Enum.KeyCode.ButtonB)
        end)
    end

    workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
        if Platform.IsMobile then
            local ss = GetScreenSize()
            local w = math.min(ss.X * 0.85, 500)
            local h = math.min(ss.Y * 0.8, 500)
            mainFrame.Size = UDim2.fromOffset(w, h)
            mainFrame.Position = UDim2.new(0.5, -w / 2, 0.5, -h / 2)
        end
    end)

    table.insert(self._windows, window)
    return window
end

function WindowClass:_toggleVisible()
    self._visible = not self._visible
    if self._visible then
        self.MainFrame.Visible = true
        Tween(self.MainFrame, {BackgroundTransparency = 0}, 0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        for _, child in ipairs(self.MainFrame:GetDescendants()) do
            pcall(function()
                if child:IsA("GuiObject") and child.Name ~= "WraithWindow" then
                    child.Visible = true
                end
            end)
        end
    else
        Tween(self.MainFrame, {BackgroundTransparency = 1}, 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
        task.delay(0.25, function()
            if not self._visible then
                self.MainFrame.Visible = false
            end
        end)
    end
end

function WindowClass:_destroy()
    self._library.Unloaded = true
    pcall(function()
        ContextActionService:UnbindAction("WraithToggleUI")
        ContextActionService:UnbindAction("WraithSwitchTab")
        ContextActionService:UnbindAction("WraithBack")
    end)
    pcall(function()
        if self._mobileBtn then self._mobileBtn:Destroy() end
    end)
    Tween(self.MainFrame, {BackgroundTransparency = 1, Size = UDim2.fromOffset(0, 0)}, 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
    task.delay(0.25, function()
        pcall(function()
            self._library._screenGui:Destroy()
        end)
    end)
end

function WindowClass:Dialog(config)
    config = config or {}
    local sg = self._library:_getScreenGui()

    local overlay = Create("Frame", {
        Name = "DialogOverlay",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BackgroundTransparency = 0.5,
        ZIndex = 100,
        Parent = sg
    })

    local dialogFrame = Create("Frame", {
        Name = "Dialog",
        Size = UDim2.fromOffset(ScaleForPlatform(320), 0),
        Position = UDim2.new(0.5, -ScaleForPlatform(160), 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundColor3 = Colors.ElementBg,
        ZIndex = 101,
        Parent = sg
    })
    AddCorner(dialogFrame, 8)
    AddStroke(dialogFrame, Colors.Border)
    AddPadding(dialogFrame, 16, 16, 16, 16)
    AddListLayout(dialogFrame, 10)

    dialogFrame.Position = UDim2.new(0.5, -ScaleForPlatform(160), 0.5, 0)

    local dtitle = Create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        Text = config.Title or "Dialog",
        TextColor3 = Colors.PrimaryText,
        Font = Enum.Font.GothamBold,
        TextSize = ScaleForPlatform(16),
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true,
        ZIndex = 101,
        Parent = dialogFrame
    })

    local dcontent = Create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        Text = config.Content or "",
        TextColor3 = Colors.SecondaryText,
        Font = Enum.Font.Gotham,
        TextSize = ScaleForPlatform(13),
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true,
        ZIndex = 101,
        Parent = dialogFrame
    })

    local btnContainer = Create("Frame", {
        Size = UDim2.new(1, 0, 0, ScaleForPlatform(32)),
        BackgroundTransparency = 1,
        ZIndex = 101,
        Parent = dialogFrame
    })
    AddListLayout(btnContainer, 8, Enum.FillDirection.Horizontal, Enum.HorizontalAlignment.Right, Enum.VerticalAlignment.Center)

    local function closeDialog()
        Tween(dialogFrame, {BackgroundTransparency = 1}, 0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
        Tween(overlay, {BackgroundTransparency = 1}, 0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
        task.delay(0.2, function()
            pcall(function() dialogFrame:Destroy() end)
            pcall(function() overlay:Destroy() end)
        end)
    end

    if config.Buttons then
        for _, btnConfig in ipairs(config.Buttons) do
            local btn = Create("TextButton", {
                Size = UDim2.new(0, ScaleForPlatform(80), 0, ScaleForPlatform(30)),
                BackgroundColor3 = Colors.Border,
                Text = btnConfig.Title or "OK",
                TextColor3 = Colors.PrimaryText,
                Font = Enum.Font.GothamSemibold,
                TextSize = ScaleForPlatform(12),
                ZIndex = 102,
                Parent = btnContainer
            })
            AddCorner(btn, 6)

            btn.MouseButton1Click:Connect(function()
                closeDialog()
                if btnConfig.Callback then
                    pcall(btnConfig.Callback)
                end
            end)

            if Platform.IsPC then
                btn.MouseEnter:Connect(function()
                    Tween(btn, {BackgroundColor3 = Colors.TabHover}, 0.15)
                end)
                btn.MouseLeave:Connect(function()
                    Tween(btn, {BackgroundColor3 = Colors.Border}, 0.15)
                end)
            end
        end
    end

    overlay.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            closeDialog()
        end
    end)

    Tween(dialogFrame, {BackgroundTransparency = 0}, 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
end

local TabClass = {}
TabClass.__index = TabClass

function WindowClass:AddTab(config)
    config = config or {}
    local tabTitle = config.Title or "Tab"
    local tabIcon = config.Icon or ""

    local tab = setmetatable({}, TabClass)
    tab._window = self
    tab._library = self._library
    tab._elements = {}
    tab._title = tabTitle

    local contentScroll = Create("ScrollingFrame", {
        Name = "Tab_" .. tabTitle,
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = Colors.Border,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Visible = false,
        Parent = self.ContentFrame
    })
    AddListLayout(contentScroll, 6)
    AddPadding(contentScroll, 8, 8, 8, 8)
    tab.ContentScroll = contentScroll

    local tabBtnHeight = Platform.IsMobile and 44 or ScaleForPlatform(32)

    local tabBtn
    if Platform.IsMobile then
        tabBtn = Create("TextButton", {
            Name = "TabBtn_" .. tabTitle,
            Size = UDim2.new(0, 70, 0, 40),
            BackgroundColor3 = Colors.Sidebar,
            BackgroundTransparency = 1,
            Text = "",
            Parent = self.TabContainer
        })
        AddCorner(tabBtn, 6)

        local tabBtnLayout = Create("UIListLayout", {
            FillDirection = Enum.FillDirection.Vertical,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            Padding = UDim.new(0, 2),
            Parent = tabBtn
        })

        if tabIcon ~= "" then
            local iconImg = Create("ImageLabel", {
                Name = "Icon",
                Size = UDim2.new(0, 18, 0, 18),
                BackgroundTransparency = 1,
                Image = GetIcon(tabIcon),
                ImageColor3 = Colors.SecondaryText,
                Parent = tabBtn
            })
            tab._tabIcon = iconImg
        end

        local tabLabel = Create("TextLabel", {
            Name = "Label",
            Size = UDim2.new(0, 60, 0, 12),
            BackgroundTransparency = 1,
            Text = tabTitle,
            TextColor3 = Colors.SecondaryText,
            Font = Enum.Font.Gotham,
            TextSize = 10,
            TextTruncate = Enum.TextTruncate.AtEnd,
            Parent = tabBtn
        })
        tab._tabLabel = tabLabel
    else
        tabBtn = Create("TextButton", {
            Name = "TabBtn_" .. tabTitle,
            Size = UDim2.new(1, 0, 0, tabBtnHeight),
            BackgroundColor3 = Colors.Sidebar,
            BackgroundTransparency = 1,
            Text = "",
            Parent = self.TabContainer
        })
        AddCorner(tabBtn, 6)

        local iconSize = ScaleForPlatform(16)
        if tabIcon ~= "" then
            local iconImg = Create("ImageLabel", {
                Name = "Icon",
                Size = UDim2.new(0, iconSize, 0, iconSize),
                Position = UDim2.new(0, 10, 0.5, -iconSize / 2),
                BackgroundTransparency = 1,
                Image = GetIcon(tabIcon),
                ImageColor3 = Colors.SecondaryText,
                Parent = tabBtn
            })
            tab._tabIcon = iconImg
        end

        local labelX = tabIcon ~= "" and (10 + iconSize + 8) or 10
        local tabLabel = Create("TextLabel", {
            Name = "Label",
            Size = UDim2.new(1, -labelX - 6, 1, 0),
            Position = UDim2.new(0, labelX, 0, 0),
            BackgroundTransparency = 1,
            Text = tabTitle,
            TextColor3 = Colors.SecondaryText,
            Font = Enum.Font.Gotham,
            TextSize = ScaleForPlatform(13),
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd,
            Parent = tabBtn
        })
        tab._tabLabel = tabLabel
    end

    tab.TabButton = tabBtn

    tabBtn.MouseButton1Click:Connect(function()
        local idx = table.find(self._tabs, tab)
        if idx then
            self:SelectTab(idx)
        end
        HapticFeedback()
    end)

    if Platform.IsPC then
        tabBtn.MouseEnter:Connect(function()
            if self._activeTab ~= tab then
                Tween(tabBtn, {BackgroundTransparency = 0, BackgroundColor3 = Colors.TabHover}, 0.15)
            end
        end)
        tabBtn.MouseLeave:Connect(function()
            if self._activeTab ~= tab then
                Tween(tabBtn, {BackgroundTransparency = 1}, 0.15)
            end
        end)
    end

    table.insert(self._tabs, tab)

    if #self._tabs == 1 then
        self:SelectTab(1)
    end

    return tab
end

function WindowClass:SelectTab(index)
    if type(index) ~= "number" or index < 1 or index > #self._tabs then return end

    for _, t in ipairs(self._tabs) do
        t.ContentScroll.Visible = false
        Tween(t.TabButton, {BackgroundTransparency = 1}, 0.15)
        if t._tabLabel then
            Tween(t._tabLabel, {TextColor3 = Colors.SecondaryText}, 0.15)
        end
        if t._tabIcon then
            Tween(t._tabIcon, {ImageColor3 = Colors.SecondaryText}, 0.15)
        end
    end

    local tab = self._tabs[index]
    tab.ContentScroll.Visible = true
    Tween(tab.TabButton, {BackgroundTransparency = 0, BackgroundColor3 = Colors.TabSelected}, 0.15)
    if tab._tabLabel then
        Tween(tab._tabLabel, {TextColor3 = Colors.PrimaryText}, 0.15)
    end
    if tab._tabIcon then
        Tween(tab._tabIcon, {ImageColor3 = Colors.PrimaryText}, 0.15)
    end
    self._activeTab = tab
end

function TabClass:_createElementFrame(title, description, height)
    local frame = Create("Frame", {
        Name = "Element_" .. (title or ""),
        Size = UDim2.new(1, 0, 0, height or 0),
        AutomaticSize = height == nil and Enum.AutomaticSize.Y or Enum.AutomaticSize.None,
        BackgroundColor3 = Colors.ElementBg,
        Parent = self.ContentScroll
    })
    AddCorner(frame, 6)
    AddStroke(frame, Colors.Border)
    return frame
end

function TabClass:AddParagraph(config)
    config = config or {}
    local frame = Create("Frame", {
        Name = "Paragraph",
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundColor3 = Colors.ElementBg,
        Parent = self.ContentScroll
    })
    AddCorner(frame, 6)
    AddStroke(frame, Colors.Border)
    AddPadding(frame, 10, 10, 12, 12)
    AddListLayout(frame, 4)

    if config.Title and config.Title ~= "" then
        Create("TextLabel", {
            Size = UDim2.new(1, 0, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1,
            Text = config.Title,
            TextColor3 = Colors.PrimaryText,
            Font = Enum.Font.GothamBold,
            TextSize = ScaleForPlatform(14),
            TextXAlignment = Enum.TextXAlignment.Left,
            TextWrapped = true,
            Parent = frame
        })
    end

    if config.Content and config.Content ~= "" then
        Create("TextLabel", {
            Size = UDim2.new(1, 0, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1,
            Text = config.Content,
            TextColor3 = Colors.SecondaryText,
            Font = Enum.Font.Gotham,
            TextSize = ScaleForPlatform(12),
            TextXAlignment = Enum.TextXAlignment.Left,
            TextWrapped = true,
            Parent = frame
        })
    end

    return frame
end

function TabClass:AddButton(config)
    config = config or {}
    local elemHeight = ScaleForPlatform(config.Description and 50 or 36)
    local frame = Create("Frame", {
        Name = "Button",
        Size = UDim2.new(1, 0, 0, elemHeight),
        BackgroundColor3 = Colors.ElementBg,
        Parent = self.ContentScroll
    })
    AddCorner(frame, 6)
    AddStroke(frame, Colors.Border)

    local btn = Create("TextButton", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "",
        Parent = frame
    })

    local titleLabel = Create("TextLabel", {
        Size = UDim2.new(1, -24, 0, config.Description and (elemHeight / 2) or elemHeight),
        Position = UDim2.new(0, 12, 0, 0),
        BackgroundTransparency = 1,
        Text = config.Title or "Button",
        TextColor3 = Colors.PrimaryText,
        Font = Enum.Font.GothamSemibold,
        TextSize = ScaleForPlatform(13),
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = frame
    })

    if config.Description then
        Create("TextLabel", {
            Size = UDim2.new(1, -24, 0, elemHeight / 2),
            Position = UDim2.new(0, 12, 0, elemHeight / 2),
            BackgroundTransparency = 1,
            Text = config.Description,
            TextColor3 = Colors.SecondaryText,
            Font = Enum.Font.Gotham,
            TextSize = ScaleForPlatform(11),
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = frame
        })
    end

    btn.MouseButton1Click:Connect(function()
        HapticFeedback()
        if config.Callback then
            pcall(config.Callback)
        end
    end)

    if Platform.IsPC then
        btn.MouseEnter:Connect(function()
            Tween(frame, {BackgroundColor3 = Colors.TabHover}, 0.15)
        end)
        btn.MouseLeave:Connect(function()
            Tween(frame, {BackgroundColor3 = Colors.ElementBg}, 0.15)
        end)
    end

    return frame
end

local ToggleClass = {}
ToggleClass.__index = ToggleClass

function TabClass:AddToggle(index, config)
    config = config or {}
    local toggle = setmetatable({}, ToggleClass)
    toggle.Value = config.Default or false
    toggle._callbacks = {}
    toggle._index = index
    toggle._library = self._library

    self._library.Options[index] = toggle

    local elemHeight = ScaleForPlatform(36)
    local frame = Create("Frame", {
        Name = "Toggle_" .. index,
        Size = UDim2.new(1, 0, 0, elemHeight),
        BackgroundColor3 = Colors.ElementBg,
        Parent = self.ContentScroll
    })
    AddCorner(frame, 6)
    AddStroke(frame, Colors.Border)
    toggle._frame = frame

    local titleLabel = Create("TextLabel", {
        Size = UDim2.new(1, -70, 1, 0),
        Position = UDim2.new(0, 12, 0, 0),
        BackgroundTransparency = 1,
        Text = config.Title or "Toggle",
        TextColor3 = Colors.PrimaryText,
        Font = Enum.Font.Gotham,
        TextSize = ScaleForPlatform(13),
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = frame
    })

    local trackWidth = ScaleForPlatform(36)
    local trackHeight = ScaleForPlatform(18)
    local knobSize = trackHeight - 4

    local track = Create("Frame", {
        Name = "Track",
        Size = UDim2.new(0, trackWidth, 0, trackHeight),
        Position = UDim2.new(1, -trackWidth - 12, 0.5, -trackHeight / 2),
        BackgroundColor3 = toggle.Value and Colors.ToggleOn or Colors.ToggleOff,
        Parent = frame
    })
    Create("UICorner", {
        CornerRadius = UDim.new(1, 0),
        Parent = track
    })

    local knob = Create("Frame", {
        Name = "Knob",
        Size = UDim2.new(0, knobSize, 0, knobSize),
        Position = toggle.Value and UDim2.new(1, -knobSize - 2, 0.5, -knobSize / 2) or UDim2.new(0, 2, 0.5, -knobSize / 2),
        BackgroundColor3 = Colors.PrimaryText,
        Parent = track
    })
    Create("UICorner", {
        CornerRadius = UDim.new(1, 0),
        Parent = knob
    })
    toggle._track = track
    toggle._knob = knob
    toggle._knobSize = knobSize

    local btn = Create("TextButton", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "",
        Parent = frame
    })

    btn.MouseButton1Click:Connect(function()
        toggle:SetValue(not toggle.Value)
        HapticFeedback()
    end)

    if Platform.IsPC then
        btn.MouseEnter:Connect(function()
            Tween(frame, {BackgroundColor3 = Colors.TabHover}, 0.15)
        end)
        btn.MouseLeave:Connect(function()
            Tween(frame, {BackgroundColor3 = Colors.ElementBg}, 0.15)
        end)
    end

    return toggle
end

function ToggleClass:SetValue(val)
    self.Value = val
    local knobSize = self._knobSize
    if val then
        Tween(self._track, {BackgroundColor3 = Colors.ToggleOn}, 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
        Tween(self._knob, {Position = UDim2.new(1, -knobSize - 2, 0.5, -knobSize / 2)}, 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
    else
        Tween(self._track, {BackgroundColor3 = Colors.ToggleOff}, 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
        Tween(self._knob, {Position = UDim2.new(0, 2, 0.5, -knobSize / 2)}, 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
    end
    for _, cb in ipairs(self._callbacks) do
        pcall(cb)
    end
end

function ToggleClass:OnChanged(callback)
    table.insert(self._callbacks, callback)
end

local SliderClass = {}
SliderClass.__index = SliderClass

function TabClass:AddSlider(index, config)
    config = config or {}
    local slider = setmetatable({}, SliderClass)
    slider.Value = config.Default or config.Min or 0
    slider._min = config.Min or 0
    slider._max = config.Max or 100
    slider._rounding = config.Rounding or 1
    slider._callbacks = {}
    slider._directCallback = config.Callback
    slider._index = index
    slider._library = self._library

    self._library.Options[index] = slider

    local hasDesc = config.Description and config.Description ~= ""
    local elemHeight = ScaleForPlatform(hasDesc and 64 or 50)

    local frame = Create("Frame", {
        Name = "Slider_" .. index,
        Size = UDim2.new(1, 0, 0, elemHeight),
        BackgroundColor3 = Colors.ElementBg,
        Parent = self.ContentScroll
    })
    AddCorner(frame, 6)
    AddStroke(frame, Colors.Border)
    slider._frame = frame

    local titleY = hasDesc and 6 or 4
    local titleLabel = Create("TextLabel", {
        Size = UDim2.new(0.6, -12, 0, ScaleForPlatform(16)),
        Position = UDim2.new(0, 12, 0, titleY),
        BackgroundTransparency = 1,
        Text = config.Title or "Slider",
        TextColor3 = Colors.PrimaryText,
        Font = Enum.Font.Gotham,
        TextSize = ScaleForPlatform(13),
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = frame
    })

    if hasDesc then
        Create("TextLabel", {
            Size = UDim2.new(1, -24, 0, ScaleForPlatform(12)),
            Position = UDim2.new(0, 12, 0, titleY + ScaleForPlatform(16)),
            BackgroundTransparency = 1,
            Text = config.Description,
            TextColor3 = Colors.SecondaryText,
            Font = Enum.Font.Gotham,
            TextSize = ScaleForPlatform(11),
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = frame
        })
    end

    local valueLabel = Create("TextLabel", {
        Size = UDim2.new(0.4, -12, 0, ScaleForPlatform(16)),
        Position = UDim2.new(0.6, 0, 0, titleY),
        BackgroundTransparency = 1,
        Text = tostring(slider.Value),
        TextColor3 = Colors.Accent,
        Font = Enum.Font.GothamSemibold,
        TextSize = ScaleForPlatform(13),
        TextXAlignment = Enum.TextXAlignment.Right,
        Parent = frame
    })
    slider._valueLabel = valueLabel

    local trackHeight = ScaleForPlatform(6)
    local trackY = elemHeight - trackHeight - 10
    local track = Create("Frame", {
        Name = "SliderTrack",
        Size = UDim2.new(1, -24, 0, trackHeight),
        Position = UDim2.new(0, 12, 0, trackY),
        BackgroundColor3 = Colors.ToggleOff,
        Parent = frame
    })
    Create("UICorner", {
        CornerRadius = UDim.new(1, 0),
        Parent = track
    })

    local pct = math.clamp((slider.Value - slider._min) / (slider._max - slider._min), 0, 1)
    local fill = Create("Frame", {
        Name = "Fill",
        Size = UDim2.new(pct, 0, 1, 0),
        BackgroundColor3 = Colors.Accent,
        Parent = track
    })
    Create("UICorner", {
        CornerRadius = UDim.new(1, 0),
        Parent = fill
    })
    slider._fill = fill
    slider._track = track

    local sliderBtn = Create("TextButton", {
        Size = UDim2.new(1, 0, 0, trackHeight + 20),
        Position = UDim2.new(0, 0, 0, trackY - 10),
        BackgroundTransparency = 1,
        Text = "",
        Parent = frame
    })

    local function updateSlider(inputX)
        local trackAbsPos = track.AbsolutePosition.X
        local trackAbsSize = track.AbsoluteSize.X
        local rel = math.clamp((inputX - trackAbsPos) / trackAbsSize, 0, 1)
        local rawVal = slider._min + (slider._max - slider._min) * rel
        local rounding = slider._rounding
        local rounded
        if rounding == 0 then
            rounded = rawVal
        else
            local mult = math.pow(10, rounding)
            rounded = math.floor(rawVal * mult + 0.5) / mult
        end
        rounded = math.clamp(rounded, slider._min, slider._max)
        slider.Value = rounded
        local newPct = math.clamp((rounded - slider._min) / (slider._max - slider._min), 0, 1)
        Tween(fill, {Size = UDim2.new(newPct, 0, 1, 0)}, 0.05, Enum.EasingStyle.Linear)
        valueLabel.Text = tostring(rounded)
        if slider._directCallback then
            pcall(slider._directCallback, rounded)
        end
        for _, cb in ipairs(slider._callbacks) do
            pcall(cb, rounded)
        end
    end

    local sliding = false

    sliderBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            sliding = true
            updateSlider(input.Position.X)
        end
    end)

    sliderBtn.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            sliding = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateSlider(input.Position.X)
        end
    end)

    if Platform.IsPC then
        sliderBtn.MouseEnter:Connect(function()
            Tween(frame, {BackgroundColor3 = Colors.TabHover}, 0.15)
        end)
        sliderBtn.MouseLeave:Connect(function()
            if not sliding then
                Tween(frame, {BackgroundColor3 = Colors.ElementBg}, 0.15)
            end
        end)
    end

    return slider
end

function SliderClass:SetValue(val)
    val = math.clamp(val, self._min, self._max)
    local rounding = self._rounding
    if rounding == 0 then
        self.Value = val
    else
        local mult = math.pow(10, rounding)
        self.Value = math.floor(val * mult + 0.5) / mult
    end
    local pct = math.clamp((self.Value - self._min) / (self._max - self._min), 0, 1)
    Tween(self._fill, {Size = UDim2.new(pct, 0, 1, 0)}, 0.1)
    self._valueLabel.Text = tostring(self.Value)
    if self._directCallback then
        pcall(self._directCallback, self.Value)
    end
    for _, cb in ipairs(self._callbacks) do
        pcall(cb, self.Value)
    end
end

function SliderClass:OnChanged(callback)
    table.insert(self._callbacks, callback)
end

local DropdownClass = {}
DropdownClass.__index = DropdownClass

function TabClass:AddDropdown(index, config)
    config = config or {}
    local dropdown = setmetatable({}, DropdownClass)
    dropdown._multi = config.Multi or false
    dropdown._values = config.Values or {}
    dropdown._callbacks = {}
    dropdown._index = index
    dropdown._library = self._library
    dropdown._open = false
    dropdown._tab = self

    if dropdown._multi then
        dropdown.Value = {}
        if config.Default and type(config.Default) == "table" then
            for _, v in ipairs(config.Default) do
                dropdown.Value[v] = true
            end
        end
    else
        if config.Default then
            if type(config.Default) == "number" and dropdown._values[config.Default] then
                dropdown.Value = dropdown._values[config.Default]
            else
                dropdown.Value = config.Default
            end
        else
            dropdown.Value = dropdown._values[1] or ""
        end
    end

    self._library.Options[index] = dropdown

    local hasDesc = config.Description and config.Description ~= ""
    local elemHeight = ScaleForPlatform(hasDesc and 56 or 36)

    local frame = Create("Frame", {
        Name = "Dropdown_" .. index,
        Size = UDim2.new(1, 0, 0, elemHeight),
        BackgroundColor3 = Colors.ElementBg,
        ClipsDescendants = false,
        Parent = self.ContentScroll
    })
    AddCorner(frame, 6)
    AddStroke(frame, Colors.Border)
    dropdown._frame = frame

    local titleLabel = Create("TextLabel", {
        Size = UDim2.new(0.5, -12, 0, ScaleForPlatform(16)),
        Position = UDim2.new(0, 12, 0, hasDesc and 6 or (elemHeight / 2 - ScaleForPlatform(8))),
        BackgroundTransparency = 1,
        Text = config.Title or "Dropdown",
        TextColor3 = Colors.PrimaryText,
        Font = Enum.Font.Gotham,
        TextSize = ScaleForPlatform(13),
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = frame
    })

    if hasDesc then
        Create("TextLabel", {
            Size = UDim2.new(1, -24, 0, ScaleForPlatform(12)),
            Position = UDim2.new(0, 12, 0, 6 + ScaleForPlatform(16) + 2),
            BackgroundTransparency = 1,
            Text = config.Description,
            TextColor3 = Colors.SecondaryText,
            Font = Enum.Font.Gotham,
            TextSize = ScaleForPlatform(11),
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = frame
        })
    end

    local function getDisplayText()
        if dropdown._multi then
            local selected = {}
            for v, s in pairs(dropdown.Value) do
                if s then table.insert(selected, v) end
            end
            if #selected == 0 then return "None" end
            return table.concat(selected, ", ")
        else
            return tostring(dropdown.Value)
        end
    end

    local displayLabel = Create("TextLabel", {
        Size = UDim2.new(0.5, -18, 0, ScaleForPlatform(16)),
        Position = UDim2.new(0.5, 0, 0, hasDesc and 6 or (elemHeight / 2 - ScaleForPlatform(8))),
        BackgroundTransparency = 1,
        Text = getDisplayText(),
        TextColor3 = Colors.Accent,
        Font = Enum.Font.GothamSemibold,
        TextSize = ScaleForPlatform(12),
        TextXAlignment = Enum.TextXAlignment.Right,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Parent = frame
    })
    dropdown._displayLabel = displayLabel

    local arrowLabel = Create("TextLabel", {
        Size = UDim2.new(0, 16, 0, 16),
        Position = UDim2.new(1, -22, 0, hasDesc and 6 or (elemHeight / 2 - 8)),
        BackgroundTransparency = 1,
        Text = "▼",
        TextColor3 = Colors.SecondaryText,
        Font = Enum.Font.Gotham,
        TextSize = 10,
        Parent = frame
    })

    local optionsList
    local bottomSheet
    local bottomSheetOverlay

    local function closeDropdown()
        dropdown._open = false
        Tween(arrowLabel, {Rotation = 0}, 0.2)
        if Platform.IsMobile then
            if bottomSheet then
                Tween(bottomSheet, {Position = UDim2.new(0, 0, 1, 0)}, 0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
                task.delay(0.3, function()
                    pcall(function()
                        if bottomSheet then bottomSheet:Destroy() end
                        if bottomSheetOverlay then bottomSheetOverlay:Destroy() end
                    end)
                    bottomSheet = nil
                    bottomSheetOverlay = nil
                end)
            end
        else
            if optionsList then
                Tween(optionsList, {Size = UDim2.new(1, 0, 0, 0)}, 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                task.delay(0.25, function()
                    pcall(function()
                        if optionsList then optionsList:Destroy() end
                    end)
                    optionsList = nil
                end)
            end
        end
    end

    local function openDropdown()
        dropdown._open = true
        Tween(arrowLabel, {Rotation = 180}, 0.2)

        if Platform.IsMobile then
            local sg = self._library:_getScreenGui()
            bottomSheetOverlay = Create("Frame", {
                Name = "BottomSheetOverlay",
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundColor3 = Color3.fromRGB(0, 0, 0),
                BackgroundTransparency = 0.5,
                ZIndex = 90,
                Parent = sg
            })
            bottomSheetOverlay.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Touch then
                    closeDropdown()
                end
            end)

            local sheetHeight = math.min(#dropdown._values * 44 + 60, GetScreenSize().Y * 0.6)
            bottomSheet = Create("Frame", {
                Name = "BottomSheet",
                Size = UDim2.new(1, 0, 0, sheetHeight),
                Position = UDim2.new(0, 0, 1, 0),
                BackgroundColor3 = Colors.ElementBg,
                ZIndex = 91,
                Parent = sg
            })
            Create("UICorner", {
                CornerRadius = UDim.new(0, 12),
                Parent = bottomSheet
            })
            local sheetCover = Create("Frame", {
                Size = UDim2.new(1, 0, 0, 12),
                Position = UDim2.new(0, 0, 1, -12),
                BackgroundColor3 = Colors.ElementBg,
                BorderSizePixel = 0,
                ZIndex = 91,
                Parent = bottomSheet
            })

            local sheetTitle = Create("TextLabel", {
                Size = UDim2.new(1, -24, 0, 40),
                Position = UDim2.new(0, 12, 0, 0),
                BackgroundTransparency = 1,
                Text = config.Title or "Select",
                TextColor3 = Colors.PrimaryText,
                Font = Enum.Font.GothamBold,
                TextSize = 16,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 92,
                Parent = bottomSheet
            })

            local sheetScroll = Create("ScrollingFrame", {
                Size = UDim2.new(1, 0, 1, -44),
                Position = UDim2.new(0, 0, 0, 44),
                BackgroundTransparency = 1,
                ScrollBarThickness = 2,
                ScrollBarImageColor3 = Colors.Border,
                CanvasSize = UDim2.new(0, 0, 0, 0),
                AutomaticCanvasSize = Enum.AutomaticSize.Y,
                ZIndex = 92,
                Parent = bottomSheet
            })
            AddListLayout(sheetScroll, 2)
            AddPadding(sheetScroll, 4, 4, 12, 12)

            for _, val in ipairs(dropdown._values) do
                local optBtn = Create("TextButton", {
                    Size = UDim2.new(1, 0, 0, 44),
                    BackgroundColor3 = Colors.ElementBg,
                    BackgroundTransparency = 1,
                    Text = tostring(val),
                    TextColor3 = Colors.PrimaryText,
                    Font = Enum.Font.Gotham,
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 93,
                    Parent = sheetScroll
                })
                AddCorner(optBtn, 6)
                AddPadding(optBtn, 0, 0, 12, 12)

                if dropdown._multi then
                    if dropdown.Value[val] then
                        optBtn.BackgroundTransparency = 0
                        optBtn.BackgroundColor3 = Colors.TabSelected
                    end
                else
                    if dropdown.Value == val then
                        optBtn.BackgroundTransparency = 0
                        optBtn.BackgroundColor3 = Colors.TabSelected
                    end
                end

                optBtn.MouseButton1Click:Connect(function()
                    HapticFeedback()
                    if dropdown._multi then
                        dropdown.Value[val] = not dropdown.Value[val]
                        if not dropdown.Value[val] then dropdown.Value[val] = nil end
                        optBtn.BackgroundTransparency = dropdown.Value[val] and 0 or 1
                        optBtn.BackgroundColor3 = Colors.TabSelected
                        displayLabel.Text = getDisplayText()
                        for _, cb in ipairs(dropdown._callbacks) do
                            pcall(cb, dropdown.Value)
                        end
                    else
                        dropdown.Value = val
                        displayLabel.Text = getDisplayText()
                        for _, cb in ipairs(dropdown._callbacks) do
                            pcall(cb, dropdown.Value)
                        end
                        closeDropdown()
                    end
                end)
            end

            Tween(bottomSheet, {Position = UDim2.new(0, 0, 1, -sheetHeight)}, 0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
        else
            local maxVisible = math.min(#dropdown._values, 6)
            local optHeight = ScaleForPlatform(28)
            local listHeight = maxVisible * optHeight + 8

            optionsList = Create("ScrollingFrame", {
                Name = "OptionsList",
                Size = UDim2.new(1, 0, 0, 0),
                Position = UDim2.new(0, 0, 0, elemHeight),
                BackgroundColor3 = Colors.ElementBg,
                ScrollBarThickness = 2,
                ScrollBarImageColor3 = Colors.Border,
                CanvasSize = UDim2.new(0, 0, 0, 0),
                AutomaticCanvasSize = Enum.AutomaticSize.Y,
                ClipsDescendants = true,
                ZIndex = 50,
                Parent = frame
            })
            AddCorner(optionsList, 6)
            AddStroke(optionsList, Colors.Border)
            AddListLayout(optionsList, 2)
            AddPadding(optionsList, 4, 4, 4, 4)

            for _, val in ipairs(dropdown._values) do
                local optBtn = Create("TextButton", {
                    Size = UDim2.new(1, 0, 0, optHeight),
                    BackgroundColor3 = Colors.ElementBg,
                    BackgroundTransparency = 1,
                    Text = tostring(val),
                    TextColor3 = Colors.PrimaryText,
                    Font = Enum.Font.Gotham,
                    TextSize = ScaleForPlatform(12),
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 51,
                    Parent = optionsList
                })
                AddCorner(optBtn, 4)
                AddPadding(optBtn, 0, 0, 8, 8)

                if dropdown._multi then
                    if dropdown.Value[val] then
                        optBtn.BackgroundTransparency = 0
                        optBtn.BackgroundColor3 = Colors.TabSelected
                    end
                else
                    if dropdown.Value == val then
                        optBtn.BackgroundTransparency = 0
                        optBtn.BackgroundColor3 = Colors.TabSelected
                    end
                end

                if Platform.IsPC then
                    optBtn.MouseEnter:Connect(function()
                        Tween(optBtn, {BackgroundTransparency = 0, BackgroundColor3 = Colors.TabHover}, 0.15)
                    end)
                    optBtn.MouseLeave:Connect(function()
                        local isSelected = false
                        if dropdown._multi then
                            isSelected = dropdown.Value[val] == true
                        else
                            isSelected = dropdown.Value == val
                        end
                        if isSelected then
                            Tween(optBtn, {BackgroundColor3 = Colors.TabSelected}, 0.15)
                        else
                            Tween(optBtn, {BackgroundTransparency = 1}, 0.15)
                        end
                    end)
                end

                optBtn.MouseButton1Click:Connect(function()
                    HapticFeedback()
                    if dropdown._multi then
                        dropdown.Value[val] = not dropdown.Value[val]
                        if not dropdown.Value[val] then dropdown.Value[val] = nil end
                        if dropdown.Value[val] then
                            optBtn.BackgroundTransparency = 0
                            optBtn.BackgroundColor3 = Colors.TabSelected
                        else
                            optBtn.BackgroundTransparency = 1
                        end
                        displayLabel.Text = getDisplayText()
                        for _, cb in ipairs(dropdown._callbacks) do
                            pcall(cb, dropdown.Value)
                        end
                    else
                        dropdown.Value = val
                        displayLabel.Text = getDisplayText()
                        for _, cb in ipairs(dropdown._callbacks) do
                            pcall(cb, dropdown.Value)
                        end
                        closeDropdown()
                    end
                end)
            end

            Tween(optionsList, {Size = UDim2.new(1, 0, 0, listHeight)}, 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        end
    end

    local headerBtn = Create("TextButton", {
        Size = UDim2.new(1, 0, 0, elemHeight),
        BackgroundTransparency = 1,
        Text = "",
        Parent = frame
    })

    headerBtn.MouseButton1Click:Connect(function()
        if dropdown._open then
            closeDropdown()
        else
            openDropdown()
        end
        HapticFeedback()
    end)

    if Platform.IsPC then
        headerBtn.MouseEnter:Connect(function()
            Tween(frame, {BackgroundColor3 = Colors.TabHover}, 0.15)
        end)
        headerBtn.MouseLeave:Connect(function()
            Tween(frame, {BackgroundColor3 = Colors.ElementBg}, 0.15)
        end)
    end

    return dropdown
end

function DropdownClass:SetValue(val)
    if self._multi then
        if type(val) == "table" then
            for k, v in pairs(val) do
                if v then
                    self.Value[k] = true
                else
                    self.Value[k] = nil
                end
            end
        end
    else
        self.Value = val
    end
    local function getDisplayText()
        if self._multi then
            local selected = {}
            for v, s in pairs(self.Value) do
                if s then table.insert(selected, v) end
            end
            if #selected == 0 then return "None" end
            return table.concat(selected, ", ")
        else
            return tostring(self.Value)
        end
    end
    self._displayLabel.Text = getDisplayText()
    for _, cb in ipairs(self._callbacks) do
        pcall(cb, self.Value)
    end
end

function DropdownClass:OnChanged(callback)
    table.insert(self._callbacks, callback)
end

local ColorpickerClass = {}
ColorpickerClass.__index = ColorpickerClass

function TabClass:AddColorpicker(index, config)
    config = config or {}
    local cp = setmetatable({}, ColorpickerClass)
    cp.Value = config.Default or Color3.fromRGB(255, 255, 255)
    cp.Transparency = config.Transparency or nil
    cp._hasTransparency = config.Transparency ~= nil
    cp._callbacks = {}
    cp._index = index
    cp._library = self._library
    cp._open = false
    cp._tab = self

    self._library.Options[index] = cp

    local hasDesc = config.Description and config.Description ~= ""
    local elemHeight = ScaleForPlatform(hasDesc and 50 or 36)

    local frame = Create("Frame", {
        Name = "Colorpicker_" .. index,
        Size = UDim2.new(1, 0, 0, elemHeight),
        BackgroundColor3 = Colors.ElementBg,
        ClipsDescendants = false,
        Parent = self.ContentScroll
    })
    AddCorner(frame, 6)
    AddStroke(frame, Colors.Border)
    cp._frame = frame

    Create("TextLabel", {
        Size = UDim2.new(0.7, -12, 0, ScaleForPlatform(16)),
        Position = UDim2.new(0, 12, 0, hasDesc and 6 or (elemHeight / 2 - ScaleForPlatform(8))),
        BackgroundTransparency = 1,
        Text = config.Title or "Colorpicker",
        TextColor3 = Colors.PrimaryText,
        Font = Enum.Font.Gotham,
        TextSize = ScaleForPlatform(13),
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = frame
    })

    if hasDesc then
        Create("TextLabel", {
            Size = UDim2.new(1, -24, 0, ScaleForPlatform(12)),
            Position = UDim2.new(0, 12, 0, 6 + ScaleForPlatform(16) + 2),
            BackgroundTransparency = 1,
            Text = config.Description,
            TextColor3 = Colors.SecondaryText,
            Font = Enum.Font.Gotham,
            TextSize = ScaleForPlatform(11),
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = frame
        })
    end

    local previewSize = ScaleForPlatform(22)
    local preview = Create("Frame", {
        Name = "Preview",
        Size = UDim2.new(0, previewSize, 0, previewSize),
        Position = UDim2.new(1, -previewSize - 12, 0.5, -previewSize / 2),
        BackgroundColor3 = cp.Value,
        Parent = frame
    })
    AddCorner(preview, 4)
    AddStroke(preview, Colors.Border)
    cp._preview = preview

    local pickerOverlay
    local pickerFrame

    local function closePicker()
        cp._open = false
        if Platform.IsMobile then
            if pickerOverlay then
                Tween(pickerOverlay, {BackgroundTransparency = 1}, 0.2)
                task.delay(0.25, function()
                    pcall(function()
                        if pickerOverlay then pickerOverlay:Destroy() end
                    end)
                    pickerOverlay = nil
                end)
            end
        else
            if pickerFrame then
                Tween(pickerFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.2)
                task.delay(0.25, function()
                    pcall(function()
                        if pickerFrame then pickerFrame:Destroy() end
                    end)
                    pickerFrame = nil
                end)
            end
        end
    end

    local function openPicker()
        cp._open = true

        local h, s, v = cp.Value:ToHSV()

        local function updateColor(nh, ns, nv)
            h, s, v = nh or h, ns or s, nv or v
            cp.Value = Color3.fromHSV(h, s, v)
            preview.BackgroundColor3 = cp.Value
            for _, cb in ipairs(cp._callbacks) do
                pcall(cb)
            end
        end

        if Platform.IsMobile then
            local sg = self._library:_getScreenGui()
            pickerOverlay = Create("Frame", {
                Name = "ColorpickerOverlay",
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundColor3 = Color3.fromRGB(0, 0, 0),
                BackgroundTransparency = 0.3,
                ZIndex = 90,
                Parent = sg
            })

            local pickerPanel = Create("Frame", {
                Size = UDim2.fromOffset(280, cp._hasTransparency and 340 or 300),
                Position = UDim2.new(0.5, -140, 0.5, cp._hasTransparency and -170 or -150),
                BackgroundColor3 = Colors.ElementBg,
                ZIndex = 91,
                Parent = pickerOverlay
            })
            AddCorner(pickerPanel, 8)
            AddStroke(pickerPanel, Colors.Border)
            AddPadding(pickerPanel, 12, 12, 12, 12)
            AddListLayout(pickerPanel, 8)

            local svFrame = Create("Frame", {
                Size = UDim2.new(1, 0, 0, 180),
                BackgroundColor3 = Color3.fromHSV(h, 1, 1),
                ZIndex = 92,
                Parent = pickerPanel
            })
            AddCorner(svFrame, 4)

            local whiteGrad = Create("UIGradient", {
                Color = ColorSequence.new(Color3.new(1, 1, 1), Color3.new(1, 1, 1)),
                Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 0),
                    NumberSequenceKeypoint.new(1, 1)
                }),
                Parent = svFrame
            })

            local blackOverlay = Create("Frame", {
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundColor3 = Color3.new(0, 0, 0),
                BackgroundTransparency = 0,
                ZIndex = 93,
                Parent = svFrame
            })
            AddCorner(blackOverlay, 4)
            Create("UIGradient", {
                Color = ColorSequence.new(Color3.new(0, 0, 0), Color3.new(0, 0, 0)),
                Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 1),
                    NumberSequenceKeypoint.new(1, 0)
                }),
                Rotation = 90,
                Parent = blackOverlay
            })

            local svCursor = Create("Frame", {
                Size = UDim2.new(0, 10, 0, 10),
                Position = UDim2.new(s, -5, 1 - v, -5),
                BackgroundColor3 = Color3.new(1, 1, 1),
                ZIndex = 94,
                Parent = svFrame
            })
            Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = svCursor})
            AddStroke(svCursor, Color3.new(0, 0, 0), 1)

            local svBtn = Create("TextButton", {
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Text = "",
                ZIndex = 95,
                Parent = svFrame
            })

            local svDragging = false
            svBtn.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
                    svDragging = true
                end
            end)
            svBtn.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
                    svDragging = false
                end
            end)

            local function updateSV(pos)
                local relX = math.clamp((pos.X - svFrame.AbsolutePosition.X) / svFrame.AbsoluteSize.X, 0, 1)
                local relY = math.clamp((pos.Y - svFrame.AbsolutePosition.Y) / svFrame.AbsoluteSize.Y, 0, 1)
                svCursor.Position = UDim2.new(relX, -5, relY, -5)
                updateColor(nil, relX, 1 - relY)
            end

            svBtn.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
                    updateSV(input.Position)
                end
            end)

            UserInputService.InputChanged:Connect(function(input)
                if svDragging and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
                    updateSV(input.Position)
                end
            end)

            local hueBar = Create("Frame", {
                Size = UDim2.new(1, 0, 0, 20),
                BackgroundColor3 = Color3.new(1, 1, 1),
                ZIndex = 92,
                Parent = pickerPanel
            })
            AddCorner(hueBar, 4)
            Create("UIGradient", {
                Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromHSV(0, 1, 1)),
                    ColorSequenceKeypoint.new(0.167, Color3.fromHSV(0.167, 1, 1)),
                    ColorSequenceKeypoint.new(0.333, Color3.fromHSV(0.333, 1, 1)),
                    ColorSequenceKeypoint.new(0.5, Color3.fromHSV(0.5, 1, 1)),
                    ColorSequenceKeypoint.new(0.667, Color3.fromHSV(0.667, 1, 1)),
                    ColorSequenceKeypoint.new(0.833, Color3.fromHSV(0.833, 1, 1)),
                    ColorSequenceKeypoint.new(1, Color3.fromHSV(1, 1, 1))
                }),
                Parent = hueBar
            })

            local hueCursor = Create("Frame", {
                Size = UDim2.new(0, 6, 1, -4),
                Position = UDim2.new(h, -3, 0, 2),
                BackgroundColor3 = Color3.new(1, 1, 1),
                ZIndex = 93,
                Parent = hueBar
            })
            AddCorner(hueCursor, 2)
            AddStroke(hueCursor, Color3.new(0, 0, 0), 1)

            local hueBtn = Create("TextButton", {
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Text = "",
                ZIndex = 94,
                Parent = hueBar
            })

            local hueDragging = false
            hueBtn.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
                    hueDragging = true
                    local relX = math.clamp((input.Position.X - hueBar.AbsolutePosition.X) / hueBar.AbsoluteSize.X, 0, 1)
                    hueCursor.Position = UDim2.new(relX, -3, 0, 2)
                    svFrame.BackgroundColor3 = Color3.fromHSV(relX, 1, 1)
                    updateColor(relX, nil, nil)
                end
            end)
            hueBtn.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
                    hueDragging = false
                end
            end)
            UserInputService.InputChanged:Connect(function(input)
                if hueDragging and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
                    local relX = math.clamp((input.Position.X - hueBar.AbsolutePosition.X) / hueBar.AbsoluteSize.X, 0, 1)
                    hueCursor.Position = UDim2.new(relX, -3, 0, 2)
                    svFrame.BackgroundColor3 = Color3.fromHSV(relX, 1, 1)
                    updateColor(relX, nil, nil)
                end
            end)

            if cp._hasTransparency then
                local transpBar = Create("Frame", {
                    Size = UDim2.new(1, 0, 0, 20),
                    BackgroundColor3 = Color3.new(1, 1, 1),
                    ZIndex = 92,
                    Parent = pickerPanel
                })
                AddCorner(transpBar, 4)
                Create("UIGradient", {
                    Color = ColorSequence.new(Color3.new(1, 1, 1), Color3.new(0, 0, 0)),
                    Parent = transpBar
                })

                local transpCursor = Create("Frame", {
                    Size = UDim2.new(0, 6, 1, -4),
                    Position = UDim2.new(cp.Transparency or 0, -3, 0, 2),
                    BackgroundColor3 = Color3.new(1, 1, 1),
                    ZIndex = 93,
                    Parent = transpBar
                })
                AddCorner(transpCursor, 2)
                AddStroke(transpCursor, Color3.new(0, 0, 0), 1)

                local transpBtn = Create("TextButton", {
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundTransparency = 1,
                    Text = "",
                    ZIndex = 94,
                    Parent = transpBar
                })

                local transpDragging = false
                transpBtn.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
                        transpDragging = true
                        local relX = math.clamp((input.Position.X - transpBar.AbsolutePosition.X) / transpBar.AbsoluteSize.X, 0, 1)
                        transpCursor.Position = UDim2.new(relX, -3, 0, 2)
                        cp.Transparency = relX
                        for _, cb in ipairs(cp._callbacks) do pcall(cb) end
                    end
                end)
                transpBtn.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
                        transpDragging = false
                    end
                end)
                UserInputService.InputChanged:Connect(function(input)
                    if transpDragging and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
                        local relX = math.clamp((input.Position.X - transpBar.AbsolutePosition.X) / transpBar.AbsoluteSize.X, 0, 1)
                        transpCursor.Position = UDim2.new(relX, -3, 0, 2)
                        cp.Transparency = relX
                        for _, cb in ipairs(cp._callbacks) do pcall(cb) end
                    end
                end)
            end

            local closePickerBtn = Create("TextButton", {
                Size = UDim2.new(1, 0, 0, 36),
                BackgroundColor3 = Colors.Border,
                Text = "Done",
                TextColor3 = Colors.PrimaryText,
                Font = Enum.Font.GothamSemibold,
                TextSize = 14,
                ZIndex = 92,
                Parent = pickerPanel
            })
            AddCorner(closePickerBtn, 6)
            closePickerBtn.MouseButton1Click:Connect(function()
                closePicker()
            end)

        else
            local pickerW = 220
            local pickerH = cp._hasTransparency and 260 or 230
            pickerFrame = Create("Frame", {
                Name = "PickerPanel",
                Size = UDim2.new(0, 0, 0, 0),
                Position = UDim2.new(1, -pickerW, 0, elemHeight + 4),
                BackgroundColor3 = Colors.ElementBg,
                ZIndex = 50,
                ClipsDescendants = true,
                Parent = frame
            })
            AddCorner(pickerFrame, 6)
            AddStroke(pickerFrame, Colors.Border)
            AddPadding(pickerFrame, 8, 8, 8, 8)
            AddListLayout(pickerFrame, 6)

            local svSize = pickerW - 16
            local svFrame = Create("Frame", {
                Size = UDim2.new(0, svSize, 0, 140),
                BackgroundColor3 = Color3.fromHSV(h, 1, 1),
                ZIndex = 51,
                Parent = pickerFrame
            })
            AddCorner(svFrame, 4)

            Create("UIGradient", {
                Color = ColorSequence.new(Color3.new(1, 1, 1), Color3.new(1, 1, 1)),
                Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 0),
                    NumberSequenceKeypoint.new(1, 1)
                }),
                Parent = svFrame
            })

            local blackOverlay = Create("Frame", {
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundColor3 = Color3.new(0, 0, 0),
                ZIndex = 52,
                Parent = svFrame
            })
            AddCorner(blackOverlay, 4)
            Create("UIGradient", {
                Color = ColorSequence.new(Color3.new(0, 0, 0), Color3.new(0, 0, 0)),
                Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 1),
                    NumberSequenceKeypoint.new(1, 0)
                }),
                Rotation = 90,
                Parent = blackOverlay
            })

            local svCursor = Create("Frame", {
                Size = UDim2.new(0, 8, 0, 8),
                Position = UDim2.new(s, -4, 1 - v, -4),
                BackgroundColor3 = Color3.new(1, 1, 1),
                ZIndex = 53,
                Parent = svFrame
            })
            Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = svCursor})
            AddStroke(svCursor, Color3.new(0, 0, 0), 1)

            local svBtn = Create("TextButton", {
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Text = "",
                ZIndex = 54,
                Parent = svFrame
            })

            local svDragging = false
            svBtn.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    svDragging = true
                    local relX = math.clamp((input.Position.X - svFrame.AbsolutePosition.X) / svFrame.AbsoluteSize.X, 0, 1)
                    local relY = math.clamp((input.Position.Y - svFrame.AbsolutePosition.Y) / svFrame.AbsoluteSize.Y, 0, 1)
                    svCursor.Position = UDim2.new(relX, -4, relY, -4)
                    updateColor(nil, relX, 1 - relY)
                end
            end)
            svBtn.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    svDragging = false
                end
            end)
            UserInputService.InputChanged:Connect(function(input)
                if svDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    local relX = math.clamp((input.Position.X - svFrame.AbsolutePosition.X) / svFrame.AbsoluteSize.X, 0, 1)
                    local relY = math.clamp((input.Position.Y - svFrame.AbsolutePosition.Y) / svFrame.AbsoluteSize.Y, 0, 1)
                    svCursor.Position = UDim2.new(relX, -4, relY, -4)
                    updateColor(nil, relX, 1 - relY)
                end
            end)

            local hueBar = Create("Frame", {
                Size = UDim2.new(0, svSize, 0, 16),
                BackgroundColor3 = Color3.new(1, 1, 1),
                ZIndex = 51,
                Parent = pickerFrame
            })
            AddCorner(hueBar, 4)
            Create("UIGradient", {
                Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromHSV(0, 1, 1)),
                    ColorSequenceKeypoint.new(0.167, Color3.fromHSV(0.167, 1, 1)),
                    ColorSequenceKeypoint.new(0.333, Color3.fromHSV(0.333, 1, 1)),
                    ColorSequenceKeypoint.new(0.5, Color3.fromHSV(0.5, 1, 1)),
                    ColorSequenceKeypoint.new(0.667, Color3.fromHSV(0.667, 1, 1)),
                    ColorSequenceKeypoint.new(0.833, Color3.fromHSV(0.833, 1, 1)),
                    ColorSequenceKeypoint.new(1, Color3.fromHSV(1, 1, 1))
                }),
                Parent = hueBar
            })

            local hueCursor = Create("Frame", {
                Size = UDim2.new(0, 4, 1, -4),
                Position = UDim2.new(h, -2, 0, 2),
                BackgroundColor3 = Color3.new(1, 1, 1),
                ZIndex = 52,
                Parent = hueBar
            })
            AddCorner(hueCursor, 2)
            AddStroke(hueCursor, Color3.new(0, 0, 0), 1)

            local hueBtn = Create("TextButton", {
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Text = "",
                ZIndex = 53,
                Parent = hueBar
            })

            local hueDragging = false
            hueBtn.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    hueDragging = true
                    local relX = math.clamp((input.Position.X - hueBar.AbsolutePosition.X) / hueBar.AbsoluteSize.X, 0, 1)
                    hueCursor.Position = UDim2.new(relX, -2, 0, 2)
                    svFrame.BackgroundColor3 = Color3.fromHSV(relX, 1, 1)
                    updateColor(relX, nil, nil)
                end
            end)
            hueBtn.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    hueDragging = false
                end
            end)
            UserInputService.InputChanged:Connect(function(input)
                if hueDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    local relX = math.clamp((input.Position.X - hueBar.AbsolutePosition.X) / hueBar.AbsoluteSize.X, 0, 1)
                    hueCursor.Position = UDim2.new(relX, -2, 0, 2)
                    svFrame.BackgroundColor3 = Color3.fromHSV(relX, 1, 1)
                    updateColor(relX, nil, nil)
                end
            end)

            if cp._hasTransparency then
                local transpBar = Create("Frame", {
                    Size = UDim2.new(0, svSize, 0, 16),
                    BackgroundColor3 = Color3.new(1, 1, 1),
                    ZIndex = 51,
                    Parent = pickerFrame
                })
                AddCorner(transpBar, 4)
                Create("UIGradient", {
                    Color = ColorSequence.new(Color3.new(1, 1, 1), Color3.new(0, 0, 0)),
                    Parent = transpBar
                })

                local transpCursor = Create("Frame", {
                    Size = UDim2.new(0, 4, 1, -4),
                    Position = UDim2.new(cp.Transparency or 0, -2, 0, 2),
                    BackgroundColor3 = Color3.new(1, 1, 1),
                    ZIndex = 52,
                    Parent = transpBar
                })
                AddCorner(transpCursor, 2)
                AddStroke(transpCursor, Color3.new(0, 0, 0), 1)

                local transpBtn = Create("TextButton", {
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundTransparency = 1,
                    Text = "",
                    ZIndex = 53,
                    Parent = transpBar
                })

                local transpDragging = false
                transpBtn.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        transpDragging = true
                        local relX = math.clamp((input.Position.X - transpBar.AbsolutePosition.X) / transpBar.AbsoluteSize.X, 0, 1)
                        transpCursor.Position = UDim2.new(relX, -2, 0, 2)
                        cp.Transparency = relX
                        for _, cb in ipairs(cp._callbacks) do pcall(cb) end
                    end
                end)
                transpBtn.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        transpDragging = false
                    end
                end)
                UserInputService.InputChanged:Connect(function(input)
                    if transpDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                        local relX = math.clamp((input.Position.X - transpBar.AbsolutePosition.X) / transpBar.AbsoluteSize.X, 0, 1)
                        transpCursor.Position = UDim2.new(relX, -2, 0, 2)
                        cp.Transparency = relX
                        for _, cb in ipairs(cp._callbacks) do pcall(cb) end
                    end
                end)
            end

            Tween(pickerFrame, {Size = UDim2.fromOffset(pickerW, pickerH)}, 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        end
    end

    local headerBtn = Create("TextButton", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "",
        Parent = frame
    })

    headerBtn.MouseButton1Click:Connect(function()
        if cp._open then
            closePicker()
        else
            openPicker()
        end
        HapticFeedback()
    end)

    if Platform.IsPC then
        headerBtn.MouseEnter:Connect(function()
            Tween(frame, {BackgroundColor3 = Colors.TabHover}, 0.15)
        end)
        headerBtn.MouseLeave:Connect(function()
            Tween(frame, {BackgroundColor3 = Colors.ElementBg}, 0.15)
        end)
    end

    return cp
end

function ColorpickerClass:SetValueRGB(color)
    self.Value = color
    self._preview.BackgroundColor3 = color
    for _, cb in ipairs(self._callbacks) do
        pcall(cb)
    end
end

function ColorpickerClass:OnChanged(callback)
    table.insert(self._callbacks, callback)
end

local KeybindClass = {}
KeybindClass.__index = KeybindClass

function TabClass:AddKeybind(index, config)
    config = config or {}
    local kb = setmetatable({}, KeybindClass)
    kb.Value = config.Default or "None"
    kb._mode = config.Mode or "Toggle"
    kb._state = false
    kb._callbacks = {}
    kb._clickCallbacks = {}
    kb._changedCallbacks = {}
    kb._directCallback = config.Callback
    kb._changedCallback = config.ChangedCallback
    kb._index = index
    kb._library = self._library
    kb._listening = false

    self._library.Options[index] = kb

    if Platform.IsMobile then
        local elemHeight = ScaleForPlatform(36)
        local frame = Create("Frame", {
            Name = "Keybind_" .. index,
            Size = UDim2.new(1, 0, 0, elemHeight),
            BackgroundColor3 = Colors.ElementBg,
            Parent = self.ContentScroll
        })
        AddCorner(frame, 6)
        AddStroke(frame, Colors.Border)
        kb._frame = frame

        Create("TextLabel", {
            Size = UDim2.new(0.7, -12, 1, 0),
            Position = UDim2.new(0, 12, 0, 0),
            BackgroundTransparency = 1,
            Text = config.Title or "Keybind",
            TextColor3 = Colors.PrimaryText,
            Font = Enum.Font.Gotham,
            TextSize = ScaleForPlatform(13),
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = frame
        })

        local mobileToggleBtn = Create("TextButton", {
            Size = UDim2.new(0, 60, 0, 24),
            Position = UDim2.new(1, -72, 0.5, -12),
            BackgroundColor3 = Colors.ToggleOff,
            Text = "OFF",
            TextColor3 = Colors.SecondaryText,
            Font = Enum.Font.GothamSemibold,
            TextSize = 11,
            Parent = frame
        })
        AddCorner(mobileToggleBtn, 4)

        mobileToggleBtn.MouseButton1Click:Connect(function()
            kb._state = not kb._state
            mobileToggleBtn.Text = kb._state and "ON" or "OFF"
            mobileToggleBtn.BackgroundColor3 = kb._state and Colors.ToggleOn or Colors.ToggleOff
            mobileToggleBtn.TextColor3 = kb._state and Colors.Topbar or Colors.SecondaryText
            HapticFeedback()
            if kb._directCallback then
                pcall(kb._directCallback, kb._state)
            end
            for _, cb in ipairs(kb._clickCallbacks) do
                pcall(cb)
            end
        end)
    else
        local elemHeight = ScaleForPlatform(36)
        local frame = Create("Frame", {
            Name = "Keybind_" .. index,
            Size = UDim2.new(1, 0, 0, elemHeight),
            BackgroundColor3 = Colors.ElementBg,
            Parent = self.ContentScroll
        })
        AddCorner(frame, 6)
        AddStroke(frame, Colors.Border)
        kb._frame = frame

        Create("TextLabel", {
            Size = UDim2.new(0.6, -12, 1, 0),
            Position = UDim2.new(0, 12, 0, 0),
            BackgroundTransparency = 1,
            Text = config.Title or "Keybind",
            TextColor3 = Colors.PrimaryText,
            Font = Enum.Font.Gotham,
            TextSize = ScaleForPlatform(13),
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = frame
        })

        local bindBtn = Create("TextButton", {
            Size = UDim2.new(0, 80, 0, 24),
            Position = UDim2.new(1, -92, 0.5, -12),
            BackgroundColor3 = Colors.ToggleOff,
            Text = kb.Value,
            TextColor3 = Colors.Accent,
            Font = Enum.Font.GothamSemibold,
            TextSize = ScaleForPlatform(11),
            Parent = frame
        })
        AddCorner(bindBtn, 4)
        kb._bindBtn = bindBtn

        bindBtn.MouseButton1Click:Connect(function()
            if kb._listening then return end
            kb._listening = true
            bindBtn.Text = "..."

            local conn
            conn = UserInputService.InputBegan:Connect(function(input, processed)
                if processed then return end
                local keyName = ""
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    keyName = "MB1"
                elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
                    keyName = "MB2"
                elseif input.KeyCode ~= Enum.KeyCode.Unknown then
                    keyName = input.KeyCode.Name
                end
                if keyName ~= "" then
                    kb.Value = keyName
                    bindBtn.Text = keyName
                    kb._listening = false
                    if conn then conn:Disconnect() end
                    if kb._changedCallback then
                        pcall(kb._changedCallback, keyName)
                    end
                    for _, cb in ipairs(kb._changedCallbacks) do
                        pcall(cb)
                    end
                end
            end)
        end)

        UserInputService.InputBegan:Connect(function(input, processed)
            if processed then return end
            if kb._listening then return end
            local keyName = ""
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                keyName = "MB1"
            elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
                keyName = "MB2"
            elseif input.KeyCode ~= Enum.KeyCode.Unknown then
                keyName = input.KeyCode.Name
            end
            if keyName == kb.Value then
                if kb._mode == "Toggle" then
                    kb._state = not kb._state
                elseif kb._mode == "Hold" then
                    kb._state = true
                elseif kb._mode == "Always" then
                    kb._state = true
                end
                if kb._directCallback then
                    pcall(kb._directCallback, kb._state)
                end
                for _, cb in ipairs(kb._clickCallbacks) do
                    pcall(cb)
                end
            end
        end)

        UserInputService.InputEnded:Connect(function(input)
            if kb._listening then return end
            local keyName = ""
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                keyName = "MB1"
            elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
                keyName = "MB2"
            elseif input.KeyCode ~= Enum.KeyCode.Unknown then
                keyName = input.KeyCode.Name
            end
            if keyName == kb.Value and kb._mode == "Hold" then
                kb._state = false
            end
        end)

        if Platform.IsPC then
            bindBtn.MouseEnter:Connect(function()
                Tween(frame, {BackgroundColor3 = Colors.TabHover}, 0.15)
            end)
            bindBtn.MouseLeave:Connect(function()
                Tween(frame, {BackgroundColor3 = Colors.ElementBg}, 0.15)
            end)
        end
    end

    return kb
end

function KeybindClass:GetState()
    return self._state
end

function KeybindClass:SetValue(key, mode)
    self.Value = key
    if mode then self._mode = mode end
    if self._bindBtn then
        self._bindBtn.Text = key
    end
    if self._changedCallback then
        pcall(self._changedCallback, key)
    end
    for _, cb in ipairs(self._changedCallbacks) do
        pcall(cb)
    end
end

function KeybindClass:OnClick(callback)
    table.insert(self._clickCallbacks, callback)
end

function KeybindClass:OnChanged(callback)
    table.insert(self._changedCallbacks, callback)
end

local InputClass = {}
InputClass.__index = InputClass

function TabClass:AddInput(index, config)
    config = config or {}
    local inputObj = setmetatable({}, InputClass)
    inputObj.Value = config.Default or ""
    inputObj._callbacks = {}
    inputObj._directCallback = config.Callback
    inputObj._index = index
    inputObj._library = self._library

    self._library.Options[index] = inputObj

    local elemHeight = ScaleForPlatform(36)
    local frame = Create("Frame", {
        Name = "Input_" .. index,
        Size = UDim2.new(1, 0, 0, elemHeight),
        BackgroundColor3 = Colors.ElementBg,
        Parent = self.ContentScroll
    })
    AddCorner(frame, 6)
    AddStroke(frame, Colors.Border)
    inputObj._frame = frame

    Create("TextLabel", {
        Size = UDim2.new(0.4, -12, 1, 0),
        Position = UDim2.new(0, 12, 0, 0),
        BackgroundTransparency = 1,
        Text = config.Title or "Input",
        TextColor3 = Colors.PrimaryText,
        Font = Enum.Font.Gotham,
        TextSize = ScaleForPlatform(13),
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = frame
    })

    local textBox = Create("TextBox", {
        Size = UDim2.new(0.6, -16, 0, 24),
        Position = UDim2.new(0.4, 4, 0.5, -12),
        BackgroundColor3 = Colors.ToggleOff,
        Text = config.Default or "",
        PlaceholderText = config.Placeholder or "",
        TextColor3 = Colors.PrimaryText,
        PlaceholderColor3 = Color3.fromRGB(100, 100, 100),
        Font = Enum.Font.Gotham,
        TextSize = ScaleForPlatform(12),
        ClearTextOnFocus = false,
        Parent = frame
    })
    AddCorner(textBox, 4)
    AddPadding(textBox, 0, 0, 6, 6)
    inputObj._textBox = textBox

    local function onTextChange()
        local val = textBox.Text
        if config.Numeric then
            val = val:gsub("[^%d%.%-]", "")
            textBox.Text = val
        end
        inputObj.Value = val
        if inputObj._directCallback then
            pcall(inputObj._directCallback, val)
        end
        for _, cb in ipairs(inputObj._callbacks) do
            pcall(cb)
        end
    end

    if config.Finished then
        textBox.FocusLost:Connect(function(enterPressed)
            onTextChange()
        end)
    else
        textBox:GetPropertyChangedSignal("Text"):Connect(function()
            onTextChange()
        end)
    end

    if Platform.IsPC then
        textBox.Focused:Connect(function()
            Tween(frame, {BackgroundColor3 = Colors.TabHover}, 0.15)
        end)
        textBox.FocusLost:Connect(function()
            Tween(frame, {BackgroundColor3 = Colors.ElementBg}, 0.15)
        end)
    end

    return inputObj
end

function InputClass:OnChanged(callback)
    table.insert(self._callbacks, callback)
end

Library.GetIcon = GetIcon
Library.LoadIcons = LoadIcons
Library.IconPacks = IconPacks
Library.CurrentIconPack = CurrentIconPack
Library.Platform = Platform
Library.Colors = Colors

return Library
