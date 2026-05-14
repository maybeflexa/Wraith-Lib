local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local GuiService = game:GetService("GuiService")
local HapticService = game:GetService("HapticService")
local ContextActionService = game:GetService("ContextActionService")
local VRService = game:GetService("VRService")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer and LocalPlayer:GetMouse()

local Platform = {
    IsMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled,
    IsConsole = UserInputService.GamepadEnabled and not UserInputService.KeyboardEnabled,
    IsPC = UserInputService.KeyboardEnabled and UserInputService.MouseEnabled,
    IsTouch = UserInputService.TouchEnabled
}

local function GetScreenSize(): Vector2
    local camera = workspace.CurrentCamera
    if camera then
        return camera.ViewportSize
    end
    return Vector2.new(1280, 720)
end

local function ScaleForPlatform(base: number): number
    if Platform.IsMobile then
        return base * 1.15
    elseif Platform.IsConsole then
        return base * 1.2
    end
    return base
end

local Palette = {
    Window = Color3.fromRGB(18, 18, 18),
    Topbar = Color3.fromRGB(12, 12, 12),
    Sidebar = Color3.fromRGB(15, 15, 15),
    TabSelected = Color3.fromRGB(30, 30, 30),
    TabHover = Color3.fromRGB(25, 25, 25),
    Content = Color3.fromRGB(20, 20, 20),
    Element = Color3.fromRGB(28, 28, 28),
    Border = Color3.fromRGB(40, 40, 40),
    Primary = Color3.fromRGB(240, 240, 240),
    Secondary = Color3.fromRGB(160, 160, 160),
    Accent = Color3.fromRGB(200, 200, 200),
    Logo = Color3.fromRGB(255, 255, 255),
    MobileButton = Color3.fromRGB(18, 18, 18),
    Hint = Color3.fromRGB(12, 12, 12)
}

local Library = {}
Library.__index = Library

local Window = {}
Window.__index = Window

local Tab = {}
Tab.__index = Tab

local Toggle = {}
Toggle.__index = Toggle

local Slider = {}
Slider.__index = Slider

local Dropdown = {}
Dropdown.__index = Dropdown

local Colorpicker = {}
Colorpicker.__index = Colorpicker

local Keybind = {}
Keybind.__index = Keybind

local Input = {}
Input.__index = Input

local Element = {}
Element.__index = Element

Library.Options = {}
Library.Unloaded = false
Library.Platform = Platform
Library.Version = "1.0.0"
Library.Windows = {}

local function safe(fn: (...any) -> ...any, ...: any): (boolean, ...any)
    return pcall(fn, ...)
end

local function tween(instance: Instance, time: number, style: Enum.EasingStyle, direction: Enum.EasingDirection, props: {[string]: any}): Tween
    local tw = TweenService:Create(instance, TweenInfo.new(time, style, direction), props)
    tw:Play()
    return tw
end

local function new(className: string, props: {[string]: any}?, children: {Instance}?): Instance
    local inst = Instance.new(className)
    if props then
        for k, v in next, props do
            safe(function()
                inst[k] = v
            end)
        end
    end
    if children then
        for _, child in next, children do
            child.Parent = inst
        end
    end
    return inst
end

local function corner(parent: Instance, radius: number): UICorner
    return new("UICorner", {CornerRadius = UDim.new(0, radius), Parent = parent}) :: UICorner
end

local function stroke(parent: Instance, color: Color3?, thickness: number?, transparency: number?): UIStroke
    return new("UIStroke", {Color = color or Palette.Border, Thickness = thickness or 1, Transparency = transparency or 0, Parent = parent}) :: UIStroke
end

local function padding(parent: Instance, all: number): UIPadding
    return new("UIPadding", {PaddingTop = UDim.new(0, all), PaddingBottom = UDim.new(0, all), PaddingLeft = UDim.new(0, all), PaddingRight = UDim.new(0, all), Parent = parent}) :: UIPadding
end

local function textSize(size: number): number
    return math.floor(ScaleForPlatform(size))
end

local function haptic(intensity: number?)
    safe(function()
        if HapticService:IsVibrationSupported(Enum.UserInputType.Gamepad1) then
            HapticService:SetMotor(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.Small, intensity or 0.35)
            task.delay(0.08, function()
                safe(function()
                    HapticService:SetMotor(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.Small, 0)
                end)
            end)
        end
    end)
end

local function formatNumber(n: number, rounding: number): number
    local mult = 10 ^ math.max(rounding or 0, 0)
    return math.floor(n * mult + 0.5) / mult
end

local function optionText(value: any): string
    if typeof(value) == "table" then
        local out = {}
        for k, v in next, value do
            if v then
                table.insert(out, tostring(k))
            end
        end
        table.sort(out)
        return #out > 0 and table.concat(out, ", ") or "None"
    end
    if typeof(value) == "Color3" then
        return tostring(math.floor(value.R * 255)) .. ", " .. tostring(math.floor(value.G * 255)) .. ", " .. tostring(math.floor(value.B * 255))
    end
    return tostring(value)
end

local function addPress(frame: GuiObject, down: (() -> ())?, up: (() -> ())?)
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if down then down() end
        end
    end)
    frame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if up then up() end
        end
    end)
end

local function clearChildren(frame: Instance)
    for _, child in next, frame:GetChildren() do
        if not child:IsA("UIListLayout") and not child:IsA("UIPadding") and not child:IsA("UICorner") and not child:IsA("UIStroke") then
            child:Destroy()
        end
    end
end

local function makeLabel(parent: Instance, text: string, size: number, color: Color3, bold: boolean): TextLabel
    return new("TextLabel", {
        Parent = parent,
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = color,
        TextSize = textSize(size),
        Font = bold and Enum.Font.GothamBold or Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center,
        TextTruncate = Enum.TextTruncate.AtEnd
    }) :: TextLabel
end

local function getParentGui(): Instance
    local guiParent = CoreGui
    local ok = safe(function()
        local test = Instance.new("ScreenGui")
        test.Name = "WraithWriteTest"
        test.Parent = CoreGui
        test:Destroy()
    end)
    if not ok then
        local playerGui = LocalPlayer and LocalPlayer:FindFirstChildOfClass("PlayerGui")
        if playerGui then
            guiParent = playerGui
        end
    end
    return guiParent
end

local function updateScrollingCanvas(scrolling: ScrollingFrame)
    local layout = scrolling:FindFirstChildOfClass("UIListLayout")
    if layout then
        scrolling.CanvasSize = UDim2.fromOffset(0, layout.AbsoluteContentSize.Y + 18)
    end
end

function Element:OnChanged(fn: (...any) -> ())
    table.insert(self.Changed, fn)
    return self
end

function Element:Fire(...: any)
    for _, fn in next, self.Changed do
        task.spawn(function(...)
            safe(fn, ...)
        end, ...)
    end
end

function Window:SetVisible(state: boolean)
    self.Visible = state
    self.Root.Visible = state
    if self.GamepadHints then
        self.GamepadHints.Visible = Platform.IsConsole and state
    end
    if state then
        self.Root.Size = UDim2.fromOffset(0, 0)
        self:ApplyResponsive()
        tween(self.Root, 0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, {GroupTransparency = 0})
    end
end

function Window:Toggle()
    self:SetVisible(not self.Visible)
end

function Window:Destroy()
    self.Library.Unloaded = true
    safe(function()
        ContextActionService:UnbindAction("WraithGamepad" .. self.Id)
    end)
    safe(function()
        self.Gui:Destroy()
    end)
end

function Window:ApplyResponsive()
    local screen = GetScreenSize()
    if Platform.IsMobile then
        local w = math.floor(screen.X * 0.85)
        local h = math.floor(math.min(screen.Y * 0.78, 620))
        self.Root.Size = UDim2.fromOffset(w, h)
        self.Root.Position = UDim2.fromOffset(math.floor((screen.X - w) / 2), math.floor((screen.Y - h) / 2) - 12)
        self.Sidebar.Visible = false
        self.MobileTabs.Visible = true
        self.Content.Position = UDim2.fromOffset(0, self.TopbarHeight)
        self.Content.Size = UDim2.new(1, 0, 1, -self.TopbarHeight - self.MobileTabHeight)
    elseif Platform.IsConsole then
        local w = math.floor(screen.X * 0.7)
        local h = math.floor(screen.Y * 0.7)
        self.Root.Size = UDim2.fromOffset(w, h)
        self.Root.Position = UDim2.fromOffset(math.floor((screen.X - w) / 2), math.floor((screen.Y - h) / 2))
        self.Sidebar.Visible = true
        self.MobileTabs.Visible = false
        self.Content.Position = UDim2.fromOffset(self.TabWidth, self.TopbarHeight)
        self.Content.Size = UDim2.new(1, -self.TabWidth, 1, -self.TopbarHeight)
    else
        self.Root.Size = self.DefaultSize
        if not self.Positioned then
            self.Root.Position = UDim2.fromOffset(math.floor((screen.X - self.DefaultSize.X.Offset) / 2), math.floor((screen.Y - self.DefaultSize.Y.Offset) / 2))
            self.Positioned = true
        end
        self.Sidebar.Visible = true
        self.MobileTabs.Visible = false
        self.Content.Position = UDim2.fromOffset(self.TabWidth, self.TopbarHeight)
        self.Content.Size = UDim2.new(1, -self.TabWidth, 1, -self.TopbarHeight)
    end
    self.Sidebar.Size = UDim2.new(0, self.TabWidth, 1, -self.TopbarHeight)
    self.Sidebar.Position = UDim2.fromOffset(0, self.TopbarHeight)
    self.Topbar.Size = UDim2.new(1, 0, 0, self.TopbarHeight)
    self.MobileTabs.Position = UDim2.new(0, 0, 1, -self.MobileTabHeight)
    self.MobileTabs.Size = UDim2.new(1, 0, 0, self.MobileTabHeight)
    for _, tab in next, self.Tabs do
        if tab.Page then
            updateScrollingCanvas(tab.Page)
        end
    end
end

function Window:SelectTab(tab: any)
    for _, t in next, self.Tabs do
        t.Page.Visible = t == tab
        t.Button.BackgroundColor3 = t == tab and Palette.TabSelected or Palette.Sidebar
        t.MobileButton.BackgroundColor3 = t == tab and Palette.TabSelected or Palette.Sidebar
    end
    self.CurrentTab = tab
    self:RefreshFocusables()
end

function Window:NextTab()
    if #self.Tabs == 0 then return end
    local idx = table.find(self.Tabs, self.CurrentTab) or 0
    idx += 1
    if idx > #self.Tabs then idx = 1 end
    self:SelectTab(self.Tabs[idx])
end

function Window:RegisterFocusable(data: {[string]: any})
    table.insert(self.AllFocusables, data)
    self:RefreshFocusables()
end

function Window:RefreshFocusables()
    self.Focusables = {}
    for _, item in next, self.AllFocusables do
        if item.Tab == self.CurrentTab and item.Frame and item.Frame.Visible then
            table.insert(self.Focusables, item)
        end
    end
    if Platform.IsConsole then
        if #self.Focusables > 0 then
            self.FocusIndex = math.clamp(self.FocusIndex or 1, 1, #self.Focusables)
        else
            self.FocusIndex = 0
        end
        self:UpdateFocus()
    end
end

function Window:UpdateFocus()
    if not Platform.IsConsole then return end
    for i, item in next, self.Focusables do
        if item.FocusStroke then
            tween(item.FocusStroke, 0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, {Thickness = i == self.FocusIndex and 2 or 0, Transparency = i == self.FocusIndex and 0 or 1})
        end
    end
    local current = self.Focusables[self.FocusIndex]
    if current and current.Frame and current.Scroll then
        local y = current.Frame.AbsolutePosition.Y - current.Scroll.AbsolutePosition.Y + current.Scroll.CanvasPosition.Y
        current.Scroll.CanvasPosition = Vector2.new(0, math.max(0, y - 30))
    end
end

function Window:MoveFocus(delta: number)
    if #self.Focusables == 0 then return end
    self.FocusIndex += delta
    if self.FocusIndex < 1 then self.FocusIndex = #self.Focusables end
    if self.FocusIndex > #self.Focusables then self.FocusIndex = 1 end
    haptic(0.15)
    self:UpdateFocus()
end

function Window:ActivateFocus()
    local current = self.Focusables[self.FocusIndex]
    if current and current.Activate then
        haptic(0.3)
        safe(current.Activate)
    end
end

function Window:AdjustFocus(delta: number)
    local current = self.Focusables[self.FocusIndex]
    if current and current.Adjust then
        haptic(0.2)
        safe(current.Adjust, delta)
    end
end

function Window:CloseTopLayer()
    if self.ActivePopup and self.ActivePopup.Parent then
        self.ActivePopup:Destroy()
        self.ActivePopup = nil
        return true
    end
    if self.Visible then
        self:SetVisible(false)
        return true
    end
    return false
end

function Window:BindGamepad()
    local name = "WraithGamepad" .. self.Id
    ContextActionService:BindAction(name, function(_, state, input)
        if state ~= Enum.UserInputState.Begin and state ~= Enum.UserInputState.Change then
            return Enum.ContextActionResult.Pass
        end
        if input.KeyCode == Enum.KeyCode.ButtonX and state == Enum.UserInputState.Begin then
            self:Toggle()
            return Enum.ContextActionResult.Sink
        end
        if not self.Visible then
            return Enum.ContextActionResult.Pass
        end
        if state == Enum.UserInputState.Begin then
            if input.KeyCode == Enum.KeyCode.ButtonA then
                self:ActivateFocus()
            elseif input.KeyCode == Enum.KeyCode.ButtonB then
                self:CloseTopLayer()
            elseif input.KeyCode == Enum.KeyCode.ButtonY then
                self:NextTab()
            elseif input.KeyCode == Enum.KeyCode.DPadUp then
                self:MoveFocus(-1)
            elseif input.KeyCode == Enum.KeyCode.DPadDown then
                self:MoveFocus(1)
            elseif input.KeyCode == Enum.KeyCode.DPadLeft then
                self:AdjustFocus(-1)
            elseif input.KeyCode == Enum.KeyCode.DPadRight then
                self:AdjustFocus(1)
            end
        elseif state == Enum.UserInputState.Change then
            if input.KeyCode == Enum.KeyCode.Thumbstick2 then
                local pos = input.Position
                self.Root.Position = self.Root.Position + UDim2.fromOffset(math.floor(pos.X * 8), math.floor(-pos.Y * 8))
            elseif input.KeyCode == Enum.KeyCode.Thumbstick1 and self.CurrentTab and self.CurrentTab.Page then
                local pos = input.Position
                self.CurrentTab.Page.CanvasPosition += Vector2.new(0, math.floor(-pos.Y * 18))
            end
        end
        return Enum.ContextActionResult.Sink
    end, false, Enum.KeyCode.ButtonA, Enum.KeyCode.ButtonB, Enum.KeyCode.ButtonX, Enum.KeyCode.ButtonY, Enum.KeyCode.DPadUp, Enum.KeyCode.DPadDown, Enum.KeyCode.DPadLeft, Enum.KeyCode.DPadRight, Enum.KeyCode.Thumbstick1, Enum.KeyCode.Thumbstick2)
end

function Window:Dialog(config: {[string]: any})
    local overlay = new("Frame", {Parent = self.Gui, Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.new(0, 0, 0), BackgroundTransparency = 0.35, ZIndex = 100}) :: Frame
    local box = new("Frame", {Parent = overlay, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(math.floor(ScaleForPlatform(360)), math.floor(ScaleForPlatform(200))), BackgroundColor3 = Palette.Window, ZIndex = 101}) :: Frame
    corner(box, 10)
    stroke(box, Palette.Border, 1, 0)
    padding(box, 16)
    local layout = new("UIListLayout", {Parent = box, FillDirection = Enum.FillDirection.Vertical, Padding = UDim.new(0, 12), SortOrder = Enum.SortOrder.LayoutOrder})
    makeLabel(box, tostring(config.Title or "Dialog"), 16, Palette.Primary, true).Size = UDim2.new(1, 0, 0, 24)
    local content = makeLabel(box, tostring(config.Content or ""), 14, Palette.Secondary, false)
    content.Size = UDim2.new(1, 0, 1, -94)
    content.TextWrapped = true
    content.TextYAlignment = Enum.TextYAlignment.Top
    local buttons = new("Frame", {Parent = box, Size = UDim2.new(1, 0, 0, 42), BackgroundTransparency = 1}) :: Frame
    new("UIListLayout", {Parent = buttons, FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 10), HorizontalAlignment = Enum.HorizontalAlignment.Right, SortOrder = Enum.SortOrder.LayoutOrder})
    for _, b in next, config.Buttons or {{Title = "OK"}} do
        local button = new("TextButton", {Parent = buttons, Size = UDim2.fromOffset(math.floor(ScaleForPlatform(112)), math.max(44, math.floor(ScaleForPlatform(38)))), BackgroundColor3 = Palette.Element, Text = tostring(b.Title or "Button"), TextColor3 = Palette.Primary, TextSize = textSize(13), Font = Enum.Font.GothamBold, AutoButtonColor = false, ZIndex = 102}) :: TextButton
        corner(button, 8)
        stroke(button, Palette.Border, 1, 0)
        button.MouseButton1Click:Connect(function()
            haptic(0.25)
            overlay:Destroy()
            self.ActivePopup = nil
            if b.Callback then
                task.spawn(function()
                    safe(b.Callback)
                end)
            end
        end)
    end
    self.ActivePopup = overlay
    box.Size = UDim2.fromOffset(0, 0)
    tween(box, 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, {Size = UDim2.fromOffset(math.floor(ScaleForPlatform(360)), math.floor(ScaleForPlatform(200)))})
    return overlay
end

function Library:Notify(config: {[string]: any})
    local holder = self.NotificationHolder
    if not holder then
        local parent = self.Gui or getParentGui()
        local gui = self.Gui
        if not gui or not gui.Parent then
            gui = new("ScreenGui", {Name = "WraithNotifications", ResetOnSpawn = false, IgnoreGuiInset = true, ZIndexBehavior = Enum.ZIndexBehavior.Sibling, Parent = parent}) :: ScreenGui
            self.Gui = gui
        end
        holder = new("Frame", {Parent = gui, BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), ZIndex = 200}) :: Frame
        self.NotificationHolder = holder
    end
    local screen = GetScreenSize()
    local width = Platform.IsPC and 330 or math.floor(math.min(screen.X * 0.9, 420))
    local xStart = Platform.IsPC and UDim2.new(1, 24, 0, 24) or UDim2.new(0.5, 0, 0, -100)
    local xEnd = Platform.IsPC and UDim2.new(1, -width - 24, 0, 24) or UDim2.new(0.5, -width / 2, 0, 24)
    local note = new("Frame", {Parent = holder, Position = xStart, Size = UDim2.fromOffset(width, math.floor(ScaleForPlatform(92))), BackgroundColor3 = Palette.Window, ZIndex = 201}) :: Frame
    corner(note, 10)
    stroke(note, Palette.Border, 1, 0)
    padding(note, 12)
    new("UIListLayout", {Parent = note, FillDirection = Enum.FillDirection.Vertical, Padding = UDim.new(0, 3), SortOrder = Enum.SortOrder.LayoutOrder})
    makeLabel(note, tostring(config.Title or "Notification"), 15, Palette.Primary, true).Size = UDim2.new(1, 0, 0, 20)
    makeLabel(note, tostring(config.Content or ""), 13, Palette.Secondary, false).Size = UDim2.new(1, 0, 0, 20)
    makeLabel(note, tostring(config.SubContent or ""), 12, Palette.Secondary, false).Size = UDim2.new(1, 0, 0, 18)
    for _, child in next, holder:GetChildren() do
        if child:IsA("Frame") and child ~= note then
            child.Position += UDim2.fromOffset(0, math.floor(ScaleForPlatform(102)))
        end
    end
    tween(note, 0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, {Position = xEnd})
    local dismissed = false
    local function dismiss()
        if dismissed then return end
        dismissed = true
        local out = Platform.IsPC and UDim2.new(1, 24, 0, note.Position.Y.Offset) or UDim2.new(0.5, -width / 2, 0, -110)
        tween(note, 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In, {Position = out, BackgroundTransparency = 1})
        task.delay(0.22, function()
            safe(function() note:Destroy() end)
        end)
    end
    note.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            dismiss()
        elseif input.KeyCode == Enum.KeyCode.ButtonB then
            dismiss()
        end
    end)
    task.spawn(function()
        task.wait(tonumber(config.Duration) or 5)
        dismiss()
    end)
    return note
end

function Window:CreateMobileOpenButton()
    local screen = GetScreenSize()
    local button = new("TextButton", {Parent = self.Gui, Size = UDim2.fromOffset(50, 50), Position = UDim2.fromOffset(screen.X - 68, screen.Y - 78), BackgroundColor3 = Palette.MobileButton, Text = "W", TextColor3 = Palette.Logo, TextSize = 24, Font = Enum.Font.GothamBlack, AutoButtonColor = false, ZIndex = 50}) :: TextButton
    corner(button, 25)
    stroke(button, Palette.Border, 1, 0)
    local dragging = false
    local startPos = Vector2.zero
    local startButton = UDim2.new()
    local moved = false
    button.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            moved = false
            startPos = input.Position
            startButton = button.Position
        end
    end)
    button.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
            local delta = input.Position - startPos
            if delta.Magnitude > 5 then moved = true end
            button.Position = startButton + UDim2.fromOffset(delta.X, delta.Y)
        end
    end)
    button.InputEnded:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1) then
            dragging = false
            if not moved then
                self:Toggle()
            end
        end
    end)
    self.MobileOpenButton = button
end

function Window:MakeDraggable(handle: GuiObject)
    local dragging = false
    local startInput = Vector2.zero
    local startPosition = UDim2.new()
    handle.InputBegan:Connect(function(input)
        if Platform.IsConsole then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            startInput = input.Position
            startPosition = self.Root.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if not dragging then return end
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            local delta = input.Position - startInput
            self.Root.Position = startPosition + UDim2.fromOffset(delta.X, delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

function Window:SetupSwipe()
    local start: Vector2? = nil
    self.Root.InputBegan:Connect(function(input)
        if Platform.IsMobile and input.UserInputType == Enum.UserInputType.Touch then
            start = input.Position
        end
    end)
    self.Root.InputEnded:Connect(function(input)
        if Platform.IsMobile and start and input.UserInputType == Enum.UserInputType.Touch then
            local delta = input.Position - start
            if math.abs(delta.X) > 100 and math.abs(delta.Y) < 60 then
                if delta.X > 0 then
                    self:SetVisible(false)
                else
                    self:SetVisible(true)
                end
            end
            start = nil
        end
    end)
end

function Library:CreateWindow(config: {[string]: any})
    local id = tostring(math.random(100000, 999999))
    local gui = new("ScreenGui", {Name = "WraithUI_" .. id, ResetOnSpawn = false, IgnoreGuiInset = true, ZIndexBehavior = Enum.ZIndexBehavior.Sibling, Parent = getParentGui()}) :: ScreenGui
    self.Gui = gui
    local root = new("CanvasGroup", {Parent = gui, BackgroundColor3 = Palette.Window, GroupTransparency = 0, ClipsDescendants = true, ZIndex = 1}) :: CanvasGroup
    corner(root, 12)
    stroke(root, Palette.Border, 1, 0)
    local object = setmetatable({
        Library = self,
        Id = id,
        Gui = gui,
        Root = root,
        Title = tostring(config.Title or "Wraith UI"),
        SubTitle = tostring(config.SubTitle or ""),
        TabWidth = tonumber(config.TabWidth) or 160,
        DefaultSize = config.Size or UDim2.fromOffset(580, 460),
        MinimizeKey = config.MinimizeKey or Enum.KeyCode.LeftControl,
        Tabs = {},
        AllFocusables = {},
        Focusables = {},
        FocusIndex = 1,
        Visible = true,
        TopbarHeight = math.max(52, math.floor(ScaleForPlatform(48))),
        MobileTabHeight = math.max(58, math.floor(ScaleForPlatform(52)))
    }, Window)
    local topbar = new("Frame", {Parent = root, BackgroundColor3 = Palette.Topbar, BorderSizePixel = 0, ZIndex = 2}) :: Frame
    object.Topbar = topbar
    local logo = new("TextButton", {Parent = topbar, Position = UDim2.fromOffset(12, 7), Size = UDim2.fromOffset(36, 36), BackgroundTransparency = 1, Text = "W", TextColor3 = Palette.Logo, TextSize = textSize(24), Font = Enum.Font.GothamBlack, AutoButtonColor = false, ZIndex = 3}) :: TextButton
    local title = makeLabel(topbar, object.Title, 16, Palette.Primary, true)
    title.Position = UDim2.fromOffset(54, 6)
    title.Size = UDim2.new(1, -170, 0, 22)
    local subtitle = makeLabel(topbar, object.SubTitle, 12, Palette.Secondary, false)
    subtitle.Position = UDim2.fromOffset(54, 27)
    subtitle.Size = UDim2.new(1, -170, 0, 18)
    local minimize = new("TextButton", {Parent = topbar, AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -52, 0, 8), Size = UDim2.fromOffset(34, 34), BackgroundColor3 = Palette.Element, Text = "−", TextColor3 = Palette.Primary, TextSize = textSize(18), Font = Enum.Font.GothamBold, AutoButtonColor = false, ZIndex = 3}) :: TextButton
    corner(minimize, 8)
    local close = new("TextButton", {Parent = topbar, AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -12, 0, 8), Size = UDim2.fromOffset(34, 34), BackgroundColor3 = Palette.Element, Text = "×", TextColor3 = Palette.Primary, TextSize = textSize(18), Font = Enum.Font.GothamBold, AutoButtonColor = false, ZIndex = 3}) :: TextButton
    corner(close, 8)
    local sidebar = new("Frame", {Parent = root, BackgroundColor3 = Palette.Sidebar, BorderSizePixel = 0, ZIndex = 2}) :: Frame
    object.Sidebar = sidebar
    padding(sidebar, 8)
    new("UIListLayout", {Parent = sidebar, FillDirection = Enum.FillDirection.Vertical, Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder})
    local content = new("Frame", {Parent = root, BackgroundColor3 = Palette.Content, BorderSizePixel = 0, ClipsDescendants = true, ZIndex = 2}) :: Frame
    object.Content = content
    local mobileTabs = new("ScrollingFrame", {Parent = root, BackgroundColor3 = Palette.Sidebar, BorderSizePixel = 0, ScrollBarThickness = 2, CanvasSize = UDim2.fromOffset(0, 0), ScrollingDirection = Enum.ScrollingDirection.X, ZIndex = 4}) :: ScrollingFrame
    object.MobileTabs = mobileTabs
    padding(mobileTabs, 7)
    local mobileLayout = new("UIListLayout", {Parent = mobileTabs, FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 7), SortOrder = Enum.SortOrder.LayoutOrder}) :: UIListLayout
    mobileLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        mobileTabs.CanvasSize = UDim2.fromOffset(mobileLayout.AbsoluteContentSize.X + 14, 0)
    end)
    if Platform.IsConsole then
        local hints = new("Frame", {Parent = gui, AnchorPoint = Vector2.new(0.5, 1), Position = UDim2.new(0.5, 0, 1, -8), Size = UDim2.new(0, math.floor(GetScreenSize().X * 0.7), 0, 38), BackgroundColor3 = Palette.Hint, ZIndex = 60}) :: Frame
        corner(hints, 10)
        stroke(hints, Palette.Border, 1, 0)
        local hintText = new("TextLabel", {Parent = hints, Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = "[A] Select   [B] Back   [X] Toggle UI   [Y] Tab Switch   [D-Pad] Navigate/Adjust", TextColor3 = Palette.Primary, TextSize = textSize(13), Font = Enum.Font.GothamBold, ZIndex = 61}) :: TextLabel
        object.GamepadHints = hints
    end
    minimize.MouseButton1Click:Connect(function()
        object:Toggle()
    end)
    logo.MouseButton1Click:Connect(function()
        if Platform.IsMobile then object:Toggle() end
    end)
    close.MouseButton1Click:Connect(function()
        object:Destroy()
    end)
    UserInputService.InputBegan:Connect(function(input, gp)
        if gp then return end
        if Platform.IsPC and input.KeyCode == object.MinimizeKey then
            object:Toggle()
        end
    end)
    object:MakeDraggable(Platform.IsMobile and (new("TextButton", {Parent = root, AnchorPoint = Vector2.new(1, 1), Position = UDim2.new(1, -10, 1, -10), Size = UDim2.fromOffset(54, 54), BackgroundColor3 = Palette.Element, Text = "↕", TextColor3 = Palette.Primary, TextSize = 20, Font = Enum.Font.GothamBold, AutoButtonColor = false, ZIndex = 20}) :: TextButton) or topbar)
    if Platform.IsMobile then
        corner(root:FindFirstChildWhichIsA("TextButton", true), 27)
        object:CreateMobileOpenButton()
    end
    object:SetupSwipe()
    object:ApplyResponsive()
    if Platform.IsConsole then
        object:BindGamepad()
    end
    local camera = workspace.CurrentCamera
    if camera then
        camera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
            task.defer(function()
                object:ApplyResponsive()
            end)
        end)
    end
    table.insert(self.Windows, object)
    return object
end

function Window:AddTab(config: {[string]: any})
    local tab = setmetatable({Window = self, Title = tostring(config.Title or "Tab"), Icon = tostring(config.Icon or ""), Elements = {}}, Tab)
    local button = new("TextButton", {Parent = self.Sidebar, Size = UDim2.new(1, 0, 0, math.max(44, math.floor(ScaleForPlatform(38)))), BackgroundColor3 = Palette.Sidebar, Text = (tab.Icon ~= "" and tab.Icon .. "  " or "") .. tab.Title, TextColor3 = Palette.Primary, TextSize = textSize(13), Font = Enum.Font.GothamBold, TextXAlignment = Enum.TextXAlignment.Left, AutoButtonColor = false, ZIndex = 3}) :: TextButton
    corner(button, 8)
    padding(button, 10)
    local mobile = new("TextButton", {Parent = self.MobileTabs, Size = UDim2.fromOffset(math.floor(ScaleForPlatform(120)), math.max(44, math.floor(ScaleForPlatform(38)))), BackgroundColor3 = Palette.Sidebar, Text = (tab.Icon ~= "" and tab.Icon .. "  " or "") .. tab.Title, TextColor3 = Palette.Primary, TextSize = textSize(13), Font = Enum.Font.GothamBold, AutoButtonColor = false, ZIndex = 5}) :: TextButton
    corner(mobile, 8)
    local page = new("ScrollingFrame", {Parent = self.Content, Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = Platform.IsMobile and 3 or 5, CanvasSize = UDim2.fromOffset(0, 0), Visible = false, ZIndex = 3}) :: ScrollingFrame
    padding(page, 12)
    local layout = new("UIListLayout", {Parent = page, FillDirection = Enum.FillDirection.Vertical, Padding = UDim.new(0, 10), SortOrder = Enum.SortOrder.LayoutOrder}) :: UIListLayout
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        updateScrollingCanvas(page)
    end)
    tab.Button = button
    tab.MobileButton = mobile
    tab.Page = page
    button.MouseButton1Click:Connect(function() self:SelectTab(tab) end)
    mobile.MouseButton1Click:Connect(function() self:SelectTab(tab) end)
    if Platform.IsPC then
        button.MouseEnter:Connect(function()
            if self.CurrentTab ~= tab then tween(button, 0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, {BackgroundColor3 = Palette.TabHover}) end
        end)
        button.MouseLeave:Connect(function()
            if self.CurrentTab ~= tab then tween(button, 0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, {BackgroundColor3 = Palette.Sidebar}) end
        end)
    end
    table.insert(self.Tabs, tab)
    if #self.Tabs == 1 then
        self:SelectTab(tab)
    end
    return tab
end

function Tab:Base(titleText: string, description: string?): Frame
    local minHeight = description and description ~= "" and 66 or 54
    local frame = new("Frame", {Parent = self.Page, Size = UDim2.new(1, 0, 0, math.max(44, math.floor(ScaleForPlatform(minHeight)))), BackgroundColor3 = Palette.Element, ZIndex = 4}) :: Frame
    corner(frame, 9)
    stroke(frame, Palette.Border, 1, 0)
    local focusStroke = stroke(frame, Palette.Accent, 0, 1)
    local title = makeLabel(frame, titleText, 14, Palette.Primary, true)
    title.Position = UDim2.fromOffset(12, description and description ~= "" and 8 or 0)
    title.Size = UDim2.new(1, -24, 0, description and description ~= "" and 22 or frame.Size.Y.Offset)
    if description and description ~= "" then
        local desc = makeLabel(frame, description, 12, Palette.Secondary, false)
        desc.Position = UDim2.fromOffset(12, 31)
        desc.Size = UDim2.new(1, -24, 0, 24)
        desc.TextWrapped = true
    end
    return frame, focusStroke
end

function Tab:AddParagraph(config: {[string]: any})
    local height = math.max(74, math.floor(ScaleForPlatform(74)))
    local frame = new("Frame", {Parent = self.Page, Size = UDim2.new(1, 0, 0, height), BackgroundColor3 = Palette.Element, ZIndex = 4}) :: Frame
    corner(frame, 9)
    stroke(frame, Palette.Border, 1, 0)
    local title = makeLabel(frame, tostring(config.Title or "Paragraph"), 14, Palette.Primary, true)
    title.Position = UDim2.fromOffset(12, 8)
    title.Size = UDim2.new(1, -24, 0, 22)
    local content = makeLabel(frame, tostring(config.Content or ""), 12, Palette.Secondary, false)
    content.Position = UDim2.fromOffset(12, 32)
    content.Size = UDim2.new(1, -24, 1, -38)
    content.TextWrapped = true
    content.TextYAlignment = Enum.TextYAlignment.Top
    return frame
end

function Tab:AddButton(config: {[string]: any})
    local frame, focusStroke = self:Base(tostring(config.Title or "Button"), config.Description)
    local button = new("TextButton", {Parent = frame, AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -10, 0.5, 0), Size = UDim2.fromOffset(math.max(44, math.floor(ScaleForPlatform(90))), math.max(44, math.floor(ScaleForPlatform(34)))), BackgroundColor3 = Palette.Topbar, Text = "Run", TextColor3 = Palette.Primary, TextSize = textSize(13), Font = Enum.Font.GothamBold, AutoButtonColor = false, ZIndex = 5}) :: TextButton
    corner(button, 8)
    stroke(button, Palette.Border, 1, 0)
    local function activate()
        haptic(0.25)
        if config.Callback then
            task.spawn(function()
                safe(config.Callback)
            end)
        end
    end
    button.MouseButton1Click:Connect(activate)
    self.Window:RegisterFocusable({Tab = self, Frame = frame, FocusStroke = focusStroke, Scroll = self.Page, Activate = activate})
    return frame
end

function Tab:AddToggle(index: string, config: {[string]: any})
    local frame, focusStroke = self:Base(tostring(config.Title or index), config.Description)
    local holder = new("Frame", {Parent = frame, AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -12, 0.5, 0), Size = UDim2.fromOffset(54, 30), BackgroundColor3 = Palette.Topbar, ZIndex = 5}) :: Frame
    corner(holder, 15)
    stroke(holder, Palette.Border, 1, 0)
    local knob = new("Frame", {Parent = holder, Position = UDim2.fromOffset(3, 3), Size = UDim2.fromOffset(24, 24), BackgroundColor3 = Palette.Secondary, ZIndex = 6}) :: Frame
    corner(knob, 12)
    local object = setmetatable({Type = "Toggle", Index = index, Value = config.Default == true, Changed = {}, Frame = frame, Holder = holder, Knob = knob}, Toggle)
    self.Window.Library.Options[index] = object
    local function render()
        tween(holder, 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, {BackgroundColor3 = object.Value and Palette.Accent or Palette.Topbar})
        tween(knob, 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, {Position = object.Value and UDim2.fromOffset(27, 3) or UDim2.fromOffset(3, 3), BackgroundColor3 = object.Value and Palette.Window or Palette.Secondary})
    end
    function object:SetValue(value: boolean)
        self.Value = value == true
        render()
        self:Fire(self.Value)
    end
    setmetatable(object, {__index = function(t, k) return Toggle[k] or Element[k] end})
    local function activate()
        object:SetValue(not object.Value)
        haptic(0.25)
    end
    holder.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then activate() end
    end)
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then activate() end
    end)
    render()
    if config.Callback then object:OnChanged(config.Callback) end
    self.Window:RegisterFocusable({Tab = self, Frame = frame, FocusStroke = focusStroke, Scroll = self.Page, Activate = activate})
    return object
end

function Tab:AddSlider(index: string, config: {[string]: any})
    local frame, focusStroke = self:Base(tostring(config.Title or index), config.Description)
    frame.Size = UDim2.new(1, 0, 0, math.max(78, math.floor(ScaleForPlatform(78))))
    local valueLabel = makeLabel(frame, "", 13, Palette.Primary, true)
    valueLabel.AnchorPoint = Vector2.new(1, 0)
    valueLabel.Position = UDim2.new(1, -12, 0, 9)
    valueLabel.Size = UDim2.fromOffset(90, 20)
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    local track = new("Frame", {Parent = frame, Position = UDim2.fromOffset(12, frame.Size.Y.Offset - 28), Size = UDim2.new(1, -24, 0, 8), BackgroundColor3 = Palette.Topbar, ZIndex = 5}) :: Frame
    corner(track, 4)
    local fill = new("Frame", {Parent = track, Size = UDim2.fromScale(0, 1), BackgroundColor3 = Palette.Accent, ZIndex = 6}) :: Frame
    corner(fill, 4)
    local min = tonumber(config.Min) or 0
    local max = tonumber(config.Max) or 100
    local rounding = tonumber(config.Rounding) or 0
    local object = setmetatable({Type = "Slider", Index = index, Value = tonumber(config.Default) or min, Min = min, Max = max, Rounding = rounding, Changed = {}, Frame = frame}, {__index = function(_, k) return Slider[k] or Element[k] end})
    self.Window.Library.Options[index] = object
    local function render()
        local pct = math.clamp((object.Value - min) / (max - min), 0, 1)
        valueLabel.Text = tostring(object.Value)
        tween(fill, 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, {Size = UDim2.fromScale(pct, 1)})
    end
    function object:SetValue(value: number)
        self.Value = formatNumber(math.clamp(tonumber(value) or min, min, max), rounding)
        render()
        self:Fire(self.Value)
    end
    local dragging = false
    local function setFromX(x: number)
        local pct = math.clamp((x - track.AbsolutePosition.X) / math.max(track.AbsoluteSize.X, 1), 0, 1)
        object:SetValue(min + (max - min) * pct)
    end
    track.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true setFromX(input.Position.X) end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then setFromX(input.Position.X) end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
    end)
    render()
    if config.Callback then object:OnChanged(config.Callback) end
    self.Window:RegisterFocusable({Tab = self, Frame = frame, FocusStroke = focusStroke, Scroll = self.Page, Activate = function() haptic(0.15) end, Adjust = function(delta) object:SetValue(object.Value + ((max - min) / 20) * delta) end})
    return object
end

function Dropdown:CurrentIndex()
    if self.Multi then return 1 end
    for i, v in next, self.Values do
        if v == self.Value then return i end
    end
    return 1
end

function Tab:AddDropdown(index: string, config: {[string]: any})
    local frame, focusStroke = self:Base(tostring(config.Title or index), config.Description)
    frame.Size = UDim2.new(1, 0, 0, math.max(68, math.floor(ScaleForPlatform(68))))
    local display = new("TextButton", {Parent = frame, AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -12, 0.5, 0), Size = UDim2.fromOffset(math.floor(ScaleForPlatform(180)), math.max(44, math.floor(ScaleForPlatform(36)))), BackgroundColor3 = Palette.Topbar, Text = "", TextColor3 = Palette.Primary, TextSize = textSize(12), Font = Enum.Font.Gotham, AutoButtonColor = false, ZIndex = 5}) :: TextButton
    corner(display, 8)
    stroke(display, Palette.Border, 1, 0)
    local values = config.Values or {}
    local multi = config.Multi == true
    local defaultValue: any = nil
    if multi then
        defaultValue = {}
        if typeof(config.Default) == "table" then
            for k, v in next, config.Default do
                if typeof(k) == "number" then defaultValue[v] = true else defaultValue[k] = v == true end
            end
        end
    else
        if typeof(config.Default) == "number" then defaultValue = values[config.Default] else defaultValue = config.Default or values[1] end
    end
    local object = setmetatable({Type = "Dropdown", Index = index, Values = values, Multi = multi, Value = defaultValue, Changed = {}, Frame = frame, Open = false}, {__index = function(_, k) return Dropdown[k] or Element[k] end})
    self.Window.Library.Options[index] = object
    local function render()
        display.Text = optionText(object.Value)
    end
    function object:SetValue(value: any)
        if self.Multi then
            local nextValue = {}
            if typeof(value) == "table" then
                for k, v in next, value do
                    if typeof(k) == "number" then nextValue[v] = true else nextValue[k] = v == true end
                end
            else
                nextValue[value] = true
            end
            self.Value = nextValue
        else
            self.Value = value
        end
        render()
        self:Fire(self.Value)
    end
    local function choose(v: any, popup: Instance?)
        if multi then
            local copy = {}
            for k, state in next, object.Value do copy[k] = state end
            copy[v] = not copy[v]
            object:SetValue(copy)
        else
            object:SetValue(v)
            if popup then popup:Destroy() end
            self.Window.ActivePopup = nil
        end
        haptic(0.2)
    end
    local function openPopup()
        if self.Window.ActivePopup then self.Window.ActivePopup:Destroy() end
        if Platform.IsMobile then
            local overlay = new("Frame", {Parent = self.Window.Gui, Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.new(0, 0, 0), BackgroundTransparency = 0.45, ZIndex = 110}) :: Frame
            local sheet = new("Frame", {Parent = overlay, AnchorPoint = Vector2.new(0, 1), Position = UDim2.new(0, 0, 1, 260), Size = UDim2.new(1, 0, 0, math.min(360, GetScreenSize().Y * 0.55)), BackgroundColor3 = Palette.Window, ZIndex = 111}) :: Frame
            corner(sheet, 16)
            padding(sheet, 14)
            local title = makeLabel(sheet, tostring(config.Title or index), 16, Palette.Primary, true)
            title.Size = UDim2.new(1, 0, 0, 28)
            local list = new("ScrollingFrame", {Parent = sheet, Position = UDim2.fromOffset(0, 38), Size = UDim2.new(1, 0, 1, -38), BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 3, ZIndex = 112}) :: ScrollingFrame
            local layout = new("UIListLayout", {Parent = list, Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder}) :: UIListLayout
            layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() list.CanvasSize = UDim2.fromOffset(0, layout.AbsoluteContentSize.Y + 12) end)
            for _, v in next, values do
                local opt = new("TextButton", {Parent = list, Size = UDim2.new(1, 0, 0, 48), BackgroundColor3 = Palette.Element, Text = tostring(v), TextColor3 = Palette.Primary, TextSize = textSize(14), Font = Enum.Font.GothamBold, AutoButtonColor = false, ZIndex = 113}) :: TextButton
                corner(opt, 9)
                opt.MouseButton1Click:Connect(function() choose(v, overlay) end)
            end
            overlay.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Touch and input.Position.Y < sheet.AbsolutePosition.Y then overlay:Destroy() self.Window.ActivePopup = nil end
            end)
            self.Window.ActivePopup = overlay
            tween(sheet, 0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, {Position = UDim2.new(0, 0, 1, 0)})
        else
            local abs = display.AbsolutePosition
            local popup = new("Frame", {Parent = self.Window.Gui, Position = UDim2.fromOffset(abs.X, abs.Y + display.AbsoluteSize.Y + 6), Size = UDim2.fromOffset(display.AbsoluteSize.X, 0), BackgroundColor3 = Palette.Window, ClipsDescendants = true, ZIndex = 120}) :: Frame
            corner(popup, 9)
            stroke(popup, Palette.Border, 1, 0)
            local list = new("ScrollingFrame", {Parent = popup, Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 4, ZIndex = 121}) :: ScrollingFrame
            padding(list, 6)
            local layout = new("UIListLayout", {Parent = list, Padding = UDim.new(0, 5), SortOrder = Enum.SortOrder.LayoutOrder}) :: UIListLayout
            for _, v in next, values do
                local opt = new("TextButton", {Parent = list, Size = UDim2.new(1, -12, 0, 34), BackgroundColor3 = Palette.Element, Text = tostring(v), TextColor3 = Palette.Primary, TextSize = textSize(12), Font = Enum.Font.Gotham, AutoButtonColor = false, ZIndex = 122}) :: TextButton
                corner(opt, 7)
                opt.MouseButton1Click:Connect(function() choose(v, popup) end)
            end
            task.defer(function()
                local h = math.min(220, layout.AbsoluteContentSize.Y + 14)
                list.CanvasSize = UDim2.fromOffset(0, layout.AbsoluteContentSize.Y + 14)
                tween(popup, 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, {Size = UDim2.fromOffset(display.AbsoluteSize.X, h)})
            end)
            self.Window.ActivePopup = popup
        end
    end
    display.MouseButton1Click:Connect(openPopup)
    render()
    self.Window:RegisterFocusable({Tab = self, Frame = frame, FocusStroke = focusStroke, Scroll = self.Page, Activate = openPopup, Adjust = function(delta)
        if multi then return end
        local idx = object:CurrentIndex() + delta
        if idx < 1 then idx = #values end
        if idx > #values then idx = 1 end
        object:SetValue(values[idx])
    end})
    return object
end

function Tab:AddColorpicker(index: string, config: {[string]: any})
    local frame, focusStroke = self:Base(tostring(config.Title or index), config.Description)
    local preview = new("TextButton", {Parent = frame, AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -12, 0.5, 0), Size = UDim2.fromOffset(math.max(44, math.floor(ScaleForPlatform(46))), math.max(44, math.floor(ScaleForPlatform(34)))), BackgroundColor3 = config.Default or Color3.new(1, 1, 1), Text = "", AutoButtonColor = false, ZIndex = 5}) :: TextButton
    corner(preview, 8)
    stroke(preview, Palette.Border, 1, 0)
    local object = setmetatable({Type = "Colorpicker", Index = index, Value = config.Default or Color3.new(1, 1, 1), Transparency = config.Transparency or 0, Changed = {}, Frame = frame}, {__index = function(_, k) return Colorpicker[k] or Element[k] end})
    self.Window.Library.Options[index] = object
    function object:SetValueRGB(value: Color3)
        self.Value = value
        preview.BackgroundColor3 = value
        self:Fire(self.Value, self.Transparency)
    end
    function object:SetTransparency(value: number)
        self.Transparency = math.clamp(value, 0, 1)
        self:Fire(self.Value, self.Transparency)
    end
    local function openPicker()
        if self.Window.ActivePopup then self.Window.ActivePopup:Destroy() end
        local overlayParent = Platform.IsMobile and self.Window.Gui or self.Window.Gui
        local overlay = new("Frame", {Parent = overlayParent, Size = Platform.IsMobile and UDim2.fromScale(1, 1) or UDim2.fromOffset(260, config.Transparency ~= nil and 230 or 180), Position = Platform.IsMobile and UDim2.fromScale(0, 0) or UDim2.fromOffset(preview.AbsolutePosition.X - 214, preview.AbsolutePosition.Y + 44), BackgroundColor3 = Platform.IsMobile and Color3.new(0, 0, 0) or Palette.Window, BackgroundTransparency = Platform.IsMobile and 0.08 or 0, ZIndex = 130}) :: Frame
        corner(overlay, Platform.IsMobile and 0 or 10)
        stroke(overlay, Palette.Border, 1, Platform.IsMobile and 1 or 0)
        local panel = overlay
        if Platform.IsMobile then
            panel = new("Frame", {Parent = overlay, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.new(0.88, 0, 0, 330), BackgroundColor3 = Palette.Window, ZIndex = 131}) :: Frame
            corner(panel, 14)
        end
        padding(panel, 14)
        local y = 12
        local function channel(name: string, current: number, cb: (number) -> ())
            local lbl = makeLabel(panel, name, 13, Palette.Primary, true)
            lbl.Position = UDim2.fromOffset(14, y)
            lbl.Size = UDim2.fromOffset(35, 22)
            local track = new("Frame", {Parent = panel, Position = UDim2.fromOffset(58, y + 7), Size = UDim2.new(1, -78, 0, 8), BackgroundColor3 = Palette.Topbar, ZIndex = 132}) :: Frame
            corner(track, 4)
            local fill = new("Frame", {Parent = track, Size = UDim2.fromScale(current, 1), BackgroundColor3 = Palette.Accent, ZIndex = 133}) :: Frame
            corner(fill, 4)
            local dragging = false
            local function set(x: number)
                local pct = math.clamp((x - track.AbsolutePosition.X) / math.max(track.AbsoluteSize.X, 1), 0, 1)
                fill.Size = UDim2.fromScale(pct, 1)
                cb(pct)
            end
            track.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true set(input.Position.X) end
            end)
            UserInputService.InputChanged:Connect(function(input)
                if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then set(input.Position.X) end
            end)
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
            end)
            y += 44
        end
        local r, g, b = object.Value.R, object.Value.G, object.Value.B
        local function apply()
            object:SetValueRGB(Color3.new(r, g, b))
        end
        channel("R", r, function(v) r = v apply() end)
        channel("G", g, function(v) g = v apply() end)
        channel("B", b, function(v) b = v apply() end)
        if config.Transparency ~= nil then
            channel("A", object.Transparency, function(v) object:SetTransparency(v) end)
        end
        local done = new("TextButton", {Parent = panel, AnchorPoint = Vector2.new(1, 1), Position = UDim2.new(1, -14, 1, -14), Size = UDim2.fromOffset(96, 44), BackgroundColor3 = Palette.Element, Text = "Done", TextColor3 = Palette.Primary, TextSize = textSize(13), Font = Enum.Font.GothamBold, AutoButtonColor = false, ZIndex = 134}) :: TextButton
        corner(done, 8)
        done.MouseButton1Click:Connect(function() overlay:Destroy() self.Window.ActivePopup = nil end)
        self.Window.ActivePopup = overlay
        if Platform.IsMobile then
            panel.Size = UDim2.fromOffset(0, 0)
            tween(panel, 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, {Size = UDim2.new(0.88, 0, 0, 330)})
        end
    end
    preview.MouseButton1Click:Connect(openPicker)
    if config.Callback then object:OnChanged(config.Callback) end
    self.Window:RegisterFocusable({Tab = self, Frame = frame, FocusStroke = focusStroke, Scroll = self.Page, Activate = openPicker})
    return object
end

function Tab:AddKeybind(index: string, config: {[string]: any})
    if Platform.IsMobile then
        return self:AddToggle(index, {Title = config.Title or index, Description = config.Description, Default = false, Callback = config.Callback})
    end
    local frame, focusStroke = self:Base(tostring(config.Title or index), config.Description)
    local button = new("TextButton", {Parent = frame, AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -12, 0.5, 0), Size = UDim2.fromOffset(math.floor(ScaleForPlatform(130)), math.max(44, math.floor(ScaleForPlatform(34)))), BackgroundColor3 = Palette.Topbar, Text = tostring(config.Default or "None"), TextColor3 = Palette.Primary, TextSize = textSize(12), Font = Enum.Font.GothamBold, AutoButtonColor = false, ZIndex = 5}) :: TextButton
    corner(button, 8)
    stroke(button, Palette.Border, 1, 0)
    local object = setmetatable({Type = "Keybind", Index = index, Value = tostring(config.Default or "None"), Mode = tostring(config.Mode or "Toggle"), State = false, Changed = {}, Clicked = {}, Frame = frame, Listening = false}, {__index = function(_, k) return Keybind[k] or Element[k] end})
    self.Window.Library.Options[index] = object
    function object:SetValue(value: string, mode: string?)
        self.Value = tostring(value)
        if mode then self.Mode = mode end
        button.Text = self.Value
        self:Fire(self.Value)
        if config.ChangedCallback then task.spawn(function() safe(config.ChangedCallback, self.Value) end) end
    end
    function object:GetState()
        return self.State
    end
    function object:OnClick(fn: () -> ())
        table.insert(self.Clicked, fn)
        return self
    end
    local function click()
        if object.Mode == "Toggle" then object.State = not object.State else object.State = true end
        for _, fn in next, object.Clicked do task.spawn(function() safe(fn) end) end
        if config.Callback then task.spawn(function() safe(config.Callback, object.State) end) end
        haptic(0.2)
    end
    button.MouseButton1Click:Connect(function()
        object.Listening = true
        button.Text = "..."
    end)
    UserInputService.InputBegan:Connect(function(input, gp)
        if object.Listening then
            object.Listening = false
            local name = input.UserInputType == Enum.UserInputType.MouseButton2 and "MB2" or input.KeyCode.Name
            if Platform.IsConsole and input.UserInputType.Name:find("Gamepad") then name = UserInputService:GetStringForKeyCode(input.KeyCode) end
            object:SetValue(name ~= "Unknown" and name or input.KeyCode.Name)
            return
        end
        local inputName = input.UserInputType == Enum.UserInputType.MouseButton2 and "MB2" or input.KeyCode.Name
        if inputName == object.Value then
            click()
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        local inputName = input.UserInputType == Enum.UserInputType.MouseButton2 and "MB2" or input.KeyCode.Name
        if object.Mode == "Hold" and inputName == object.Value then object.State = false end
    end)
    self.Window:RegisterFocusable({Tab = self, Frame = frame, FocusStroke = focusStroke, Scroll = self.Page, Activate = function() object.Listening = true button.Text = "..." end})
    return object
end

function Keybind:OnChanged(fn: (any) -> ())
    table.insert(self.Changed, fn)
    return self
end

function Tab:AddInput(index: string, config: {[string]: any})
    local frame, focusStroke = self:Base(tostring(config.Title or index), nil)
    frame.Size = UDim2.new(1, 0, 0, math.max(72, math.floor(ScaleForPlatform(72))))
    local box = new("TextBox", {Parent = frame, AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -12, 0.5, 8), Size = UDim2.fromOffset(math.floor(ScaleForPlatform(210)), math.max(44, math.floor(ScaleForPlatform(36)))), BackgroundColor3 = Palette.Topbar, Text = tostring(config.Default or ""), PlaceholderText = tostring(config.Placeholder or ""), TextColor3 = Palette.Primary, PlaceholderColor3 = Palette.Secondary, TextSize = textSize(12), Font = Enum.Font.Gotham, ClearTextOnFocus = false, ZIndex = 5}) :: TextBox
    corner(box, 8)
    stroke(box, Palette.Border, 1, 0)
    local object = setmetatable({Type = "Input", Index = index, Value = tostring(config.Default or ""), Changed = {}, Frame = frame}, {__index = function(_, k) return Input[k] or Element[k] end})
    self.Window.Library.Options[index] = object
    function object:SetValue(value: string)
        self.Value = tostring(value)
        box.Text = self.Value
        self:Fire(self.Value)
    end
    box:GetPropertyChangedSignal("Text"):Connect(function()
        if config.Numeric then
            local filtered = box.Text:gsub("[^%d%.%-]", "")
            if filtered ~= box.Text then box.Text = filtered end
        end
        if not config.Finished then
            object.Value = box.Text
            object:Fire(object.Value)
            if config.Callback then task.spawn(function() safe(config.Callback, object.Value) end) end
        end
    end)
    box.Focused:Connect(function()
        if Platform.IsMobile then
            safe(function() GuiService:GetNotificationTypeList() end)
            self.Window.Root.Position = UDim2.fromOffset(self.Window.Root.Position.X.Offset, math.max(8, self.Window.Root.Position.Y.Offset - 80))
        end
    end)
    box.FocusLost:Connect(function()
        object.Value = box.Text
        object:Fire(object.Value)
        if config.Callback then task.spawn(function() safe(config.Callback, object.Value) end) end
        if Platform.IsMobile then self.Window:ApplyResponsive() end
    end)
    self.Window:RegisterFocusable({Tab = self, Frame = frame, FocusStroke = focusStroke, Scroll = self.Page, Activate = function() box:CaptureFocus() end})
    return object
end

return setmetatable(Library, Library)
