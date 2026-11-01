-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

game:GetService("StarterGui")

local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Boxing = ReplicatedStorage:WaitForChild("Boxing")
local BoxingConfig = require(Boxing:WaitForChild("BoxingConfig"))
local BoxingCamera = require(Boxing:WaitForChild("BoxingCamera"))

Boxing:WaitForChild("BoxingRemote")

local Stats = BoxingConfig.Stats
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local StatsGui = PlayerGui:WaitForChild("StatsGui")
local Top = StatsGui:WaitForChild("Root"):WaitForChild("Top")
local PointsLabel = Top:WaitForChild("Header"):WaitForChild("PointsBox"):WaitForChild("PointsLabel")
local ResetButton = Top:WaitForChild("ResetButton")
local BackButton = Top:WaitForChild("BackButton")
local Scale = Top:WaitForChild("Scale")
local MenuStyle = require(Boxing:WaitForChild("MenuStyle"))

MenuStyle.Recolor(Top)
MenuStyle.PointsBox(PointsLabel.Parent, PointsLabel)
MenuStyle.Button(BackButton, {
    MaxText = 18
})
MenuStyle.Button(ResetButton, {
    MaxText = 16,
    Accent = MenuStyle.Colors.Red
})

local RadarChart = workspace:WaitForChild("RadarChart")
local Ring = RadarChart:WaitForChild("Ring")
local BBGuis = RadarChart:FindFirstChild("BBGuis")

local function findCameraPart() -- line: 40
    -- upvalues: Stats (copy)
    local v1 = string.lower(Stats.CameraPart)
    local MenuRooms = workspace:FindFirstChild("MenuRooms")
    local StatsRoom = MenuRooms and MenuRooms:FindFirstChild("StatsRoom")
    local v2 = if StatsRoom then StatsRoom:GetChildren() else workspace:GetChildren()

    for _, v3 in v2 do
        if v3:IsA("BasePart") and string.lower(string.gsub(v3.Name, "^%s*(.-)%s*$", "%1")) == v1 then
            return v3
        end
    end

    return nil
end

local Position = Ring:WaitForChild("Mean"):WaitForChild("Center").Position
local t1 = {}
local Center

for _, v4 in Stats.Names do
    local v5 = Ring:WaitForChild(v4)

    Center = v5:WaitForChild("Center")
    t1[v4] = {
        Shown = 0,
        Model = v5,
        Center = Center,
        Base = Center.CFrame,
        Axis = Center.Position - Position
    }
end

Position = RadarChart:FindFirstChild("RingBeams")

if Position then
    for _, child in Position:GetChildren() do
        if child:IsA("Beam") then
            child.Color = ColorSequence.new(Color3.fromRGB(255, 240, 245))
            child.Width0 = 0.13
            child.Width1 = 0.13
            child.LightEmission = 0.35
            child.LightInfluence = 0
        end
    end
end

local function statValue(p1) -- line: 84
    -- upvalues: LocalPlayer (copy)
    return LocalPlayer:GetAttribute("Stat_" .. p1) or 0
end

local function fraction(p2) -- line: 88
    -- upvalues: LocalPlayer (copy), Stats (copy)
    return Stats.NodeMinRadius + (1 - Stats.NodeMinRadius) * math.clamp((LocalPlayer:GetAttribute("Stat_" .. p2) or 0) / Stats.Max, 0, 1)
end

local function placeNode(p3, p4) -- line: 92
    p3.Shown = p4
    p3.Center.CFrame = p3.Base - p3.Axis + p3.Axis * p4
end

local v8

for v9, v10 in t1 do
    local NodeMinRadius = Stats.NodeMinRadius
    local v11 = 1 - Stats.NodeMinRadius

    v8 = (LocalPlayer:GetAttribute("Stat_" .. v9) or 0) / Stats.Max
    Center = NodeMinRadius + v11 * math.clamp(v8, 0, 1)
    v10.Shown = Center
    v10.Center.CFrame = v10.Base - v10.Axis + v10.Axis * Center
end

RunService.RenderStepped:Connect(function(p5) -- line: 101
    -- upvalues: LocalPlayer (copy), Stats (copy), t1 (copy)
    local v13 = 1 - math.exp(-p5 * 14)

    for v14, v15 in t1 do
        local v18 = Stats.NodeMinRadius + (1 - Stats.NodeMinRadius) * math.clamp((LocalPlayer:GetAttribute("Stat_" .. v14) or 0) / Stats.Max, 0, 1)

        if math.abs(v15.Shown - v18) > 0.001 then
            local v20 = v15.Shown + (v18 - v15.Shown) * v13

            v15.Shown = v20
            v15.Center.CFrame = v15.Base - v15.Axis + v15.Axis * v20
        end
    end
end)

local v21

local function formatValue(p6) -- line: 115
    local v23 = math.floor(p6 * 10000 + 0.5) / 10000
    local v24 = string.format("%.4f", v23)
    local v25 = string.gsub(v24, "0+$", "")

    return (string.gsub(v25, "%.$", ""))
end

local TextService = game:GetService("TextService")

local function evenRows(p7) -- line: 127
    -- upvalues: TextService (copy)
    local t2 = {}

    for _, v26 in { "StatALabel", "StatBLabel" } do
        local v27 = p7:FindFirstChild(v26)
        local UITextSizeConstraint = v27 and v27:FindFirstChildOfClass("UITextSizeConstraint")

        if UITextSizeConstraint and v27.AbsoluteSize.X > 0 then
            table.insert(t2, {
                row = v27,
                limit = UITextSizeConstraint
            })
        end
    end

    local n1 = 100

    for _, v28 in t2 do
        local row = v28.row
        local GetTextBoundsParams = Instance.new("GetTextBoundsParams")

        GetTextBoundsParams.Text = row.ContentText
        GetTextBoundsParams.Font = row.FontFace
        GetTextBoundsParams.Size = 100
        GetTextBoundsParams.Width = 1E+05

        local GetTextBoundsAsync = TextService.GetTextBoundsAsync
        local ok, result = pcall(GetTextBoundsAsync, TextService, GetTextBoundsParams)

        if ok and result.X > 0 and result.Y > 0 then
            n1 = math.min(n1, 100 * row.AbsoluteSize.X * 0.94 / result.X, 100 * row.AbsoluteSize.Y / result.Y)
        end
    end

    for _, v31 in t2 do
        v31.limit.MaxTextSize = math.clamp(math.floor(n1), 1, 100)
    end
end

local function updateLabel(p8) -- line: 154
    -- upvalues: RunService (copy), LocalPlayer (copy), Stats (copy), BBGuis (copy), formatValue (copy), evenRows (copy)
    local v33 = BBGuis and BBGuis:FindFirstChild(p8)
    local CanvasGroup = v33 and v33:FindFirstChild("CanvasGroup")

    if not CanvasGroup then
        return
    end

    local v34 = LocalPlayer:GetAttribute("Stat_" .. p8) or 0
    local NumberLabel = CanvasGroup:FindFirstChild("NumberLabel")

    if NumberLabel then
        NumberLabel.Text = formatValue(v34) .. "/" .. Stats.Max
    end

    local v35 = Stats.Subs and Stats.Subs[p8]

    for v36, v37 in { "StatALabel", "StatBLabel" } do
        local v38 = CanvasGroup:FindFirstChild(v37)

        if v38 then
            local v41 = formatValue(LocalPlayer:GetAttribute("Stat_" .. p8 .. "_" .. (if v36 == 1 then "A" else "B")) or 0) .. "/" .. (Stats.SubMax or Stats.Max)

            v38.Text = (if v35 and v35[v36] then v35[v36] .. ":  " else "") .. v41

            local NumberLabel = v38:FindFirstChild("NumberLabel")

            if NumberLabel then
                NumberLabel.Text = v41
            end
        end
    end

    local v42 = CanvasGroup:FindFirstChild("BarFrame") and CanvasGroup.BarFrame:FindFirstChild("Bar")

    if v42 then
        v42.Size = UDim2.new(math.clamp(v34 / Stats.Max, 0, 1) * 0.95, 0, v42.Size.Y.Scale, v42.Size.Y.Offset)
    end

    task.spawn(function() -- line: 183
        -- upvalues: CanvasGroup (copy), RunService (copy), evenRows (copy)
        RunService.RenderStepped:Wait()
        evenRows(CanvasGroup)
    end)
end

if BBGuis then
    for _, descendant in BBGuis:GetDescendants() do
        if descendant:IsA("TextLabel") then
            if descendant.Name == "StatALabel" or descendant.Name == "StatBLabel" then
                v8 = true
            else
                v8 = descendant.Parent

                if v8 then
                    v8 = descendant.Parent.Name == "StatALabel" or descendant.Parent.Name == "StatBLabel"
                end
            end

            if v8 then
                descendant.FontFace = MenuStyle.BodyFont
            else
                descendant.FontFace = MenuStyle.Font
            end
        end
    end

    for v44, v45 in t1 do
        v8 = BBGuis:FindFirstChild(v44)

        if v8 and v8:IsA("BillboardGui") then
            local v46 = Vector3.new(v45.Axis.X, v45.Axis.Y, v45.Axis.Z)

            if v46.Magnitude > 0.001 then
                v8.StudsOffsetWorldSpace = v46.Unit * 0.5
            end
        end
    end
end

local v47 = false

local function showLabel(p9) -- line: 213
    -- upvalues: TweenService (copy), BBGuis (copy), updateLabel (copy), v47 (ref)
    if not BBGuis then
        return
    end

    for _, child in BBGuis:GetChildren() do
        if child:IsA("BillboardGui") then
            local v48 = v47 and child.Name == p9
            local CanvasGroup = child:FindFirstChild("CanvasGroup")

            if v48 then
                if not child.Enabled then
                    child.Enabled = true

                    if CanvasGroup then
                        CanvasGroup.GroupTransparency = 1
                        TweenService:Create(CanvasGroup, TweenInfo.new(0.15), {
                            GroupTransparency = 0
                        }):Play()
                    end
                end
            else
                child.Enabled = false
            end
        end
    end

    if p9 then
        updateLabel(p9)
    end
end

showLabel(nil)
ResetButton.Visible = true

local function refresh() -- line: 243
    -- upvalues: LocalPlayer (copy), Stats (copy), PointsLabel (copy), MenuStyle (copy), v21 (ref), updateLabel (copy)
    local StatPointsRemaining = LocalPlayer:GetAttribute("StatPointsRemaining")

    if StatPointsRemaining == nil then
        local n2 = 0

        for _, v49 in Stats.Names do
            if v49 ~= "Willpower" then
                n2 += math.floor((LocalPlayer:GetAttribute("Stat_" .. v49) or 0) + 1E-06)
            end
        end

        StatPointsRemaining = math.max(0, (Stats.PointCap or 40) - n2)
    end

    PointsLabel.Text = string.format("<font color=\"%s\">%d</font> STAT POINT%s <font color=\"%s\">REMAINING</font>", MenuStyle.Hex.Amber, StatPointsRemaining, StatPointsRemaining == 1 and "" or "S", MenuStyle.Hex.Lilac)

    if v21 then
        updateLabel(v21)
    end
end

LocalPlayer:GetAttributeChangedSignal("StatPointsRemaining"):Connect(refresh)

for _, v52 in Stats.Names do
    LocalPlayer:GetAttributeChangedSignal("Stat_" .. v52):Connect(refresh)
    LocalPlayer:GetAttributeChangedSignal("Stat_" .. v52 .. "_A"):Connect(refresh)
    LocalPlayer:GetAttributeChangedSignal("Stat_" .. v52 .. "_B"):Connect(refresh)
end

refresh()

local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")

local function nodeUnderMouse(p10) -- line: 276
    -- upvalues: Scale (copy), t1 (copy), UserInputService (copy), GuiService (copy)
    local GuiInset = GuiService:GetGuiInset()
    local v53 = if p10 then Vector2.new(p10.X, p10.Y + GuiInset.Y) else UserInputService:GetMouseLocation()
    local v54 = nil
    local v55 = 26 * Scale.Scale

    for v56, v57 in t1 do
        local v58, v59 = workspace.CurrentCamera:WorldToViewportPoint(v57.Center.Position)

        if v59 then
            local Magnitude = (Vector2.new(v58.X, v58.Y) - v53).Magnitude

            if Magnitude < v55 then
                v55 = Magnitude
                v54 = v56
            end
        end
    end

    return v54
end

padPicking = false

local n3 = 0
local v60 = true

function padStep(p11) -- line: 298
    -- upvalues: Stats (copy), StatsGui (copy), v21 (ref), v47 (ref), showLabel (copy), n3 (ref)
    if not v47 or StatsGui:GetAttribute("View") == "Build" then
        return
    end

    local Names = Stats.Names

    n3 = (n3 - 1 + p11) % #Names + 1
    padPicking = true
    v21 = Names[n3]
    showLabel(v21)
end

UserInputService.InputChanged:Connect(function(p12) -- line: 308
    if p12.UserInputType == Enum.UserInputType.MouseMovement then
        padPicking = false
    end
end)
RunService.RenderStepped:Connect(function() -- line: 314
    -- upvalues: StatsGui (copy), v21 (ref), v47 (ref), showLabel (copy), nodeUnderMouse (copy)
    if v47 and not padPicking then
        local v62 = if StatsGui:GetAttribute("View") == "Build" then nil else nodeUnderMouse()

        if v62 ~= v21 then
            v21 = v62
            showLabel(v62)
        end
    end
end)
UserInputService.InputBegan:Connect(function(p13, p14) -- line: 328
    -- upvalues: v21 (ref), v47 (ref), showLabel (copy), nodeUnderMouse (copy)
    if v47 and not p14 then
        local v63 = if p13.UserInputType == Enum.UserInputType.MouseButton1 then nodeUnderMouse() elseif p13.UserInputType == Enum.UserInputType.Touch then nodeUnderMouse(Vector2.new(p13.Position.X, p13.Position.Y)) else nil

        if v63 and p13.UserInputType == Enum.UserInputType.Touch then
            v21 = v63
            showLabel(v63)
        end
    end
end)

local CurrentCamera = workspace.CurrentCamera
local t4 = {}
local t5, v64
local v65 = false
local ContextActionService = game:GetService("ContextActionService")
local t6 = {
    Enum.KeyCode.W,
    Enum.KeyCode.A,
    Enum.KeyCode.S,
    Enum.KeyCode.D,
    Enum.KeyCode.Up,
    Enum.KeyCode.Down,
    Enum.KeyCode.Left,
    Enum.KeyCode.Right,
    Enum.KeyCode.Space,
    Enum.KeyCode.Q,
    Enum.KeyCode.F,
    Enum.KeyCode.LeftShift,
    Enum.KeyCode.Thumbstick1,
    Enum.KeyCode.ButtonA,
    Enum.KeyCode.DPadUp,
    Enum.KeyCode.DPadDown,
    Enum.KeyCode.ButtonL1,
    Enum.KeyCode.ButtonR1
}

local function setFrozen(p15) -- line: 364
    -- upvalues: LocalPlayer (copy), v60 (ref), ContextActionService (copy), t6 (copy)
    if not p15 then
        ContextActionService:UnbindAction("StatsFreeze")

        return
    end

    ContextActionService:BindActionAtPriority("StatsFreeze", function(_, p17, p18) -- line: 366
        -- upvalues: v60 (ref)
        if (p18.KeyCode == Enum.KeyCode.DPadDown or p18.KeyCode == Enum.KeyCode.ButtonR1) and p17 == Enum.UserInputState.Begin then
            padStep(1)
        elseif (p18.KeyCode == Enum.KeyCode.DPadUp or p18.KeyCode == Enum.KeyCode.ButtonL1) and p17 == Enum.UserInputState.Begin then
            padStep(-1)
        elseif p18.KeyCode == Enum.KeyCode.Thumbstick1 then
            local Position = p18.Position
            local v68 = if math.abs(Position.X) > math.abs(Position.Y) then Position.X else -Position.Y

            if v60 and math.abs(v68) > 0.6 then
                v60 = false
                padStep(v68 > 0 and 1 or -1)
            elseif math.abs(Position.X) < 0.3 and math.abs(Position.Y) < 0.3 then
                v60 = true
            end
        end

        return Enum.ContextActionResult.Sink
    end, false, Enum.ContextActionPriority.High.Value + 100, table.unpack(t6))

    local v70 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")

    if v70 then
        v70:Move((Vector3.new(0, 0, 0)))
    end
end

local Bottom = StatsGui:WaitForChild("Root"):WaitForChild("Bottom")
local Scale2 = Bottom:WaitForChild("Scale")

MenuStyle.Recolor(Bottom)

for _, v71 in { "BoxingTab", "GlovesTab" } do
    local v72 = Bottom:FindFirstChild(v71)

    if v72 then
        MenuStyle.Button(v72, {
            Clip = false,
            Inset = 5
        })

        local Icon = v72:FindFirstChild("Icon")

        if Icon then
            Icon.Size = UDim2.new(1, -18, 1, -18)
            Icon.BackgroundTransparency = 1

            if v71 == "GlovesTab" then
                local Frame = Instance.new("Frame")

                Frame.Name = "SelectTint"
                Frame.Size = UDim2.fromScale(1, 1)
                Frame.BorderSizePixel = 0
                Frame.BackgroundColor3 = MenuStyle.Colors.Blue
                Frame.BackgroundTransparency = 1
                Frame.ZIndex = Icon.ZIndex + 1
                Frame.Parent = Icon

                local UICorner = Icon:FindFirstChildOfClass("UICorner")

                if UICorner then
                    UICorner:Clone().Parent = Frame
                end
            end
        end
    end
end

local function updateScale() -- line: 424
    -- upvalues: StatsGui (copy), Scale (copy), MenuStyle (copy), CurrentCamera (copy), Scale2 (copy)
    local v74 = math.clamp(CurrentCamera.ViewportSize.Y / 1080, 0.5, 1.5)

    Scale.Scale = v74
    Scale2.Scale = v74
    MenuStyle.KeepReadable(StatsGui, v74)

    local v75 = StatsGui:FindFirstChild("Root") and StatsGui.Root:FindFirstChild("Top")

    if not v75 then
        return
    end

    local v76 = if CurrentCamera.ViewportSize.Y < 500 then game:GetService("GuiService").TopbarInset.Height + 8 else 0

    v75.Position = UDim2.new(v75.Position.X.Scale, v75.Position.X.Offset, 0, v76)
end

CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(updateScale)
game:GetService("GuiService"):GetPropertyChangedSignal("TopbarInset"):Connect(updateScale)
updateScale()

local t7, v77

local function holdCamera() -- line: 447
    -- upvalues: TweenService (copy), Stats (copy), CurrentCamera (copy), v64 (ref), t7 (ref), v77 (ref)
    if not v64 then
        return
    end

    if t7 then
        local v79 = math.clamp((os.clock() - t7.Start) / t7.Time, 0, 1)
        local Value = TweenService:GetValue(v79, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)

        v64 = t7.From:Lerp(t7.To, Value)
        v77 = t7.FovFrom + (t7.FovTo - t7.FovFrom) * Value

        if v79 >= 1 then
            t7 = nil
        end
    end

    CurrentCamera.CameraType = Enum.CameraType.Scriptable
    CurrentCamera.CFrame = v64
    CurrentCamera.FieldOfView = v77 or Stats.CameraFOV or 52
end

local BindableEvent = Instance.new("BindableEvent")

BindableEvent.Name = "CameraControl"
BindableEvent.Parent = StatsGui
BindableEvent.Event:Connect(function(p19, p20, p21) -- line: 466
    -- upvalues: Stats (copy), v64 (ref), t7 (ref), v77 (ref)
    if not v64 or typeof(p19) ~= "CFrame" then
        return
    end

    local v81 = v77 or Stats.CameraFOV or 52

    t7 = {
        From = v64,
        To = p19,
        FovFrom = v81,
        FovTo = p20 or v81,
        Start = os.clock(),
        Time = math.max(p21 or 0.6, 0.01)
    }
end)

local ScreenGui = Instance.new("ScreenGui")

ScreenGui.Name = "StatsFade"
ScreenGui.IgnoreGuiInset = true
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 1000
ScreenGui.Enabled = false

local Event = Instance.new("Frame")

Event.Name = "Black"
Event.BackgroundColor3 = Color3.new(0, 0, 0)
Event.BackgroundTransparency = 1
Event.BorderSizePixel = 0
Event.Size = UDim2.fromScale(1, 1)
Event.Parent = ScreenGui
ScreenGui.Parent = PlayerGui

local MangaTransition = require(Boxing:WaitForChild("MangaTransition"))

local function blackout(p22) -- line: 496
    -- upvalues: v65 (ref), MangaTransition (copy)
    v65 = true
    MangaTransition.Play(p22)
    v65 = false
end

local TopPosition = Top.Position
local BottomPosition = Bottom.Position

local function slideIn() -- line: 504
    -- upvalues: TweenService (copy), Top (copy), Bottom (copy), TopPosition (copy), BottomPosition (copy)
    Top.Position = TopPosition - UDim2.fromOffset(0, 220)
    Bottom.Position = BottomPosition + UDim2.fromOffset(0, 240)

    local v83 = TweenInfo.new(0.55, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

    task.delay(0.15, function() -- line: 508
        -- upvalues: v83 (copy), TweenService (copy), Top (copy), Bottom (copy), TopPosition (copy), BottomPosition (copy)
        TweenService:Create(Top, v83, {
            Position = TopPosition
        }):Play()
        TweenService:Create(Bottom, v83, {
            Position = BottomPosition
        }):Play()
    end)
end

local SoundService = game:GetService("SoundService")
local v84 = BoxingConfig.UISounds or {}
local t9 = {}

local function getUISound(p23) -- line: 518
    -- upvalues: SoundService (copy), t9 (copy), v84 (copy)
    local v85 = v84[p23]

    if not v85 then
        return nil
    end

    local v86 = t9[p23]

    if not (v86 and v86.Parent) then
        v86 = Instance.new("Sound")
        v86.Name = "UI_" .. p23
        v86.SoundId = v85
        v86.Volume = v84.Volume or 0.6
        v86.SoundGroup = SoundService:FindFirstChild("BoxingUI")
        v86.Parent = SoundService
        t9[p23] = v86
    end

    return v86
end

local function uiSound(p24) -- line: 535
    -- upvalues: getUISound (copy)
    local v87 = getUISound(p24)

    if v87 then
        v87.TimePosition = 0
        v87:Play()
    end
end

task.spawn(function() -- line: 543
    -- upvalues: getUISound (copy)
    local t10 = {}

    for _, v88 in { "StatsOpen", "TabClick" } do
        table.insert(t10, (getUISound(v88)))
    end

    local function v90() -- line: 548
        -- upvalues: t10 (copy)
        game:GetService("ContentProvider"):PreloadAsync(t10)
    end

    pcall(v90)
end)

local BackpackLock = require(game:GetService("ReplicatedStorage"):WaitForChild("Boxing"):WaitForChild("BackpackLock"))

local function openStats() -- line: 554
    -- upvalues: RunService (copy), BoxingCamera (copy), Stats (copy), PlayerGui (copy), StatsGui (copy), RadarChart (copy), findCameraPart (copy), v47 (ref), refresh (copy), CurrentCamera (copy), t4 (copy), t5 (ref), v64 (ref), v65 (ref), setFrozen (copy), holdCamera (copy), ScreenGui (copy), MangaTransition (copy), slideIn (copy), BackpackLock (copy)
    if not v47 and not v65 then
        local v91 = findCameraPart()
        local v92 = if v91 then v91.CFrame else RadarChart:GetAttribute("CameraCFrame")

        if typeof(v92) ~= "CFrame" then
            warn("StatsController: no part named '" .. Stats.CameraPart .. "' in Workspace")

            return
        end

        v47 = true
        setFrozen(true)
        BoxingCamera.SetSuspended(true, "StatsController")

        local function v93() -- line: 570
            -- upvalues: v92 (copy), RunService (copy), Stats (copy), PlayerGui (copy), StatsGui (copy), refresh (copy), CurrentCamera (copy), t4 (copy), t5 (ref), v64 (ref), holdCamera (copy), ScreenGui (copy), slideIn (copy), BackpackLock (copy)
            t5 = {
                Type = CurrentCamera.CameraType,
                CFrame = CurrentCamera.CFrame,
                FieldOfView = CurrentCamera.FieldOfView
            }
            table.clear(t4)

            for _, child in PlayerGui:GetChildren() do
                if child:IsA("ScreenGui") and child ~= StatsGui and child ~= ScreenGui and child.Enabled and child.Name ~= "TouchGui" then
                    child.Enabled = false
                    table.insert(t4, child)
                end
            end

            BackpackLock.Lock("Statistics")
            CurrentCamera.FieldOfView = Stats.CameraFOV or 52
            v64 = v92
            RunService:BindToRenderStep("StatsCamera", Enum.RenderPriority.Camera.Value + 10, holdCamera)
            holdCamera()
            StatsGui.Enabled = true
            refresh()
            slideIn()
        end

        v65 = true
        MangaTransition.Play(v93)
        v65 = false
    end
end

local function closeStats() -- line: 592
    -- upvalues: RunService (copy), Boxing (copy), BoxingCamera (copy), StatsGui (copy), v21 (ref), v47 (ref), showLabel (copy), CurrentCamera (copy), t4 (copy), t5 (ref), v64 (ref), v65 (ref), ContextActionService (copy), t7 (ref), v77 (ref), MangaTransition (copy), BackpackLock (copy)
    local v95 = v47

    if not v95 or v65 then
        return
    end

    v21 = nil

    local function v96() -- line: 597
        -- upvalues: RunService (copy), Boxing (copy), BoxingCamera (copy), StatsGui (copy), v47 (ref), showLabel (copy), CurrentCamera (copy), t4 (copy), t5 (ref), v64 (ref), ContextActionService (copy), t7 (ref), v77 (ref), BackpackLock (copy)
        v47 = false

        local function v97() -- line: 599
            -- upvalues: Boxing (copy)
            Boxing:WaitForChild("SkillRemote"):FireServer("Viewing", false)
        end

        pcall(v97)
        showLabel(nil)
        StatsGui.Enabled = false
        RunService:UnbindFromRenderStep("StatsCamera")
        v64 = nil
        t7 = nil
        v77 = nil
        StatsGui:SetAttribute("View", nil)
        CurrentCamera.CameraType = t5 and t5.Type or Enum.CameraType.Custom

        if t5 then
            CurrentCamera.FieldOfView = t5.FieldOfView
            CurrentCamera.CFrame = t5.CFrame
        end

        for _, v98 in t4 do
            if v98.Parent then
                v98.Enabled = true
            end
        end

        table.clear(t4)
        BackpackLock.Unlock("Statistics")
        ContextActionService:UnbindAction("StatsFreeze")
        BoxingCamera.SetSuspended(false, "StatsController")
    end

    v65 = true
    MangaTransition.Play(v96)
    v65 = false
end

local BindableEvent2 = Instance.new("BindableEvent")

BindableEvent2.Name = "Open"
BindableEvent2.Parent = StatsGui
BindableEvent2.Event:Connect(function() -- line: 630
    -- upvalues: openStats (copy)
    openStats()
end)

local t11 = {}
local v99

for _, v100 in { "BoxingTab", "GlovesTab" } do
    v99 = Bottom:FindFirstChild(v100)

    if v99 then
        t11[v100] = v99
    end
end

local function selectTab(p25) -- line: 643
    -- upvalues: TweenService (copy), MenuStyle (copy), t11 (copy)
    for v101, v102 in t11 do
        local v103 = v101 == p25

        MenuStyle.SetSelected(v102, v103)

        local v104 = v102:FindFirstChild("Icon") and v102.Icon:FindFirstChild("SelectTint")

        if v104 then
            TweenService:Create(v104, TweenInfo.new(0.15), {
                BackgroundTransparency = v103 and 0.55 or 1
            }):Play()
        end

        local Icon = v102:FindFirstChild("Icon")

        if Icon and Icon:IsA("ImageLabel") then
            Icon.ImageTransparency = v103 and 0 or 0.12
        end
    end
end

for v106, v107 in t11 do
    v107.MouseEnter:Connect(function() -- line: 658
        -- upvalues: TweenService (copy), v107 (copy)
        TweenService:Create(v107, TweenInfo.new(0.12), {
            Size = v107:GetAttribute("BaseSize") + UDim2.fromOffset(8, 6)
        }):Play()
    end)
    v107.MouseLeave:Connect(function() -- line: 661
        -- upvalues: TweenService (copy), v107 (copy)
        TweenService:Create(v107, TweenInfo.new(0.12), {
            Size = v107:GetAttribute("BaseSize")
        }):Play()
    end)
    v107:SetAttribute("BaseSize", v107.Size)
    v107.Activated:Connect(function() -- line: 665
        -- upvalues: SoundService (copy), t9 (copy), v84 (copy), selectTab (copy), v106 (copy)
        local TabClick = v84.TabClick
        local TabClick2

        if TabClick then
            TabClick2 = t9.TabClick

            if not TabClick2 or not TabClick2.Parent then
                TabClick2 = Instance.new("Sound")
                TabClick2.Name = "UI_TabClick"
                TabClick2.SoundId = TabClick
                TabClick2.Volume = v84.Volume or 0.6
                TabClick2.SoundGroup = SoundService:FindFirstChild("BoxingUI")
                TabClick2.Parent = SoundService
                t9.TabClick = TabClick2
            end
        end

        if TabClick2 then
            TabClick2.TimePosition = 0
            TabClick2:Play()
        end

        selectTab(v106)
    end)
end

selectTab("BoxingTab")
BackButton.Activated:Connect(function() -- line: 672
    -- upvalues: RunService (copy), Boxing (copy), BoxingCamera (copy), StatsGui (copy), v21 (ref), v47 (ref), showLabel (copy), CurrentCamera (copy), t4 (copy), t5 (ref), v64 (ref), v65 (ref), ContextActionService (copy), t7 (ref), v77 (ref), MangaTransition (copy), SoundService (copy), t9 (copy), v84 (copy), BackpackLock (copy)
    if v47 and not v65 then
        local StatsOpen2 = v84.StatsOpen
        local StatsOpen

        if StatsOpen2 then
            StatsOpen = t9.StatsOpen

            if not StatsOpen or not StatsOpen.Parent then
                StatsOpen = Instance.new("Sound")
                StatsOpen.Name = "UI_StatsOpen"
                StatsOpen.SoundId = StatsOpen2
                StatsOpen.Volume = v84.Volume or 0.6
                StatsOpen.SoundGroup = SoundService:FindFirstChild("BoxingUI")
                StatsOpen.Parent = SoundService
                t9.StatsOpen = StatsOpen
            end
        end

        if StatsOpen then
            StatsOpen.TimePosition = 0
            StatsOpen:Play()
        end
    end

    if not v47 or v65 then
        return
    end

    v21 = nil

    local function v108() -- line: 597
        -- upvalues: RunService (copy), Boxing (copy), BoxingCamera (copy), StatsGui (copy), v47 (ref), showLabel (copy), CurrentCamera (copy), t4 (copy), t5 (ref), v64 (ref), ContextActionService (copy), t7 (ref), v77 (ref), BackpackLock (copy)
        v47 = false

        local function v109() -- line: 599
            -- upvalues: Boxing (copy)
            Boxing:WaitForChild("SkillRemote"):FireServer("Viewing", false)
        end

        pcall(v109)
        showLabel(nil)
        StatsGui.Enabled = false
        RunService:UnbindFromRenderStep("StatsCamera")
        v64 = nil
        t7 = nil
        v77 = nil
        StatsGui:SetAttribute("View", nil)
        CurrentCamera.CameraType = t5 and t5.Type or Enum.CameraType.Custom

        if t5 then
            CurrentCamera.FieldOfView = t5.FieldOfView
            CurrentCamera.CFrame = t5.CFrame
        end

        for _, v110 in t4 do
            if v110.Parent then
                v110.Enabled = true
            end
        end

        table.clear(t4)
        BackpackLock.Unlock("Statistics")
        ContextActionService:UnbindAction("StatsFreeze")
        BoxingCamera.SetSuspended(false, "StatsController")
    end

    v65 = true
    MangaTransition.Play(v108)
    v65 = false
end)

local StatsRemote = ReplicatedStorage:WaitForChild("Boxing"):WaitForChild("StatsRemote")
local v111

local function buildConfirm() -- line: 681
    -- upvalues: BoxingConfig (copy), StatsGui (copy), MenuStyle (copy), SoundService (copy), t9 (copy), v84 (copy), StatsRemote (copy)
    local v112 = StatsGui:FindFirstChild("Root") or StatsGui
    local Frame = Instance.new("Frame")

    Frame.Name = "ResetConfirm"
    Frame.AnchorPoint = Vector2.new(0.5, 0.5)
    Frame.Position = UDim2.fromScale(0.5, 0.5)
    Frame.Size = UDim2.fromOffset(540, 380)
    Frame.BackgroundColor3 = Color3.fromRGB(58, 58, 60)
    Frame.ZIndex = 50
    Frame.Visible = false
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 12)
    Instance.new("UIScale").Parent = Frame

    local function lightBox(p26, p27, p28) -- line: 694
        -- upvalues: Frame (copy)
        local TextButton = Instance.new("TextButton")

        TextButton.Name = p26
        TextButton.AutoButtonColor = false
        TextButton.Position = p27
        TextButton.Size = p28
        TextButton.BackgroundColor3 = Color3.fromRGB(200, 200, 202)
        TextButton.FontFace = Font.new("rbxasset://fonts/families/Merriweather.json")
        TextButton.TextColor3 = Color3.new(1, 1, 1)
        TextButton.TextScaled = true
        TextButton.ZIndex = 51
        Instance.new("UICorner", TextButton).CornerRadius = UDim.new(0, 8)

        local UIStroke = Instance.new("UIStroke")

        UIStroke.Color = Color3.fromRGB(70, 70, 72)
        UIStroke.Thickness = 2
        UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
        UIStroke.Parent = TextButton

        local UIPadding = Instance.new("UIPadding")
        local v113 = UDim.new(0, 12)
        local v114 = UDim.new(0, 12)

        UIPadding.PaddingLeft = v113
        UIPadding.PaddingRight = v114

        local v115 = UDim.new(0, 8)
        local v116 = UDim.new(0, 8)

        UIPadding.PaddingTop = v115
        UIPadding.PaddingBottom = v116
        UIPadding.Parent = TextButton
        TextButton.Parent = Frame

        return TextButton
    end

    local v117 = lightBox("Message", UDim2.fromOffset(8, 8), UDim2.new(1, -16, 1, -80))

    v117.Active = false
    v117.Text = "Reseting your build will set all stats you have/training back to 0 and will reset all skills. It costs " .. (BoxingConfig.Avatar and BoxingConfig.Avatar.ResetCost or 1) .. " reroll token. Are you sure you want to do this?"

    local v118 = lightBox("Cancel", UDim2.new(0, 8, 1, -64), UDim2.new(0.5, -12, 0, 56))

    v118.Text = "Cancel"

    local v119 = lightBox("Confirm", UDim2.new(0.5, 4, 1, -64), UDim2.new(0.5, -12, 0, 56))

    v119.Text = "Confirm"
    MenuStyle.Panel(Frame, {
        Accent = MenuStyle.Colors.Red
    })

    for _, child in v117:GetChildren() do
        if child:IsA("UICorner") then
            child:Destroy()
        end
    end

    v117.BackgroundTransparency = 1
    MenuStyle.Text(v117, {
        Heading = false
    })

    local UITextSizeConstraint = Instance.new("UITextSizeConstraint")

    UITextSizeConstraint.MaxTextSize = 26
    UITextSizeConstraint.Parent = v117
    MenuStyle.Button(v118, {
        MaxText = 18
    })
    MenuStyle.Button(v119, {
        MaxText = 18,
        Accent = MenuStyle.Colors.Red
    })
    v118.Activated:Connect(function() -- line: 741
        -- upvalues: Frame (copy), SoundService (copy), t9 (copy), v84 (copy)
        local TabClick = v84.TabClick
        local TabClick2

        if TabClick then
            TabClick2 = t9.TabClick

            if not TabClick2 or not TabClick2.Parent then
                TabClick2 = Instance.new("Sound")
                TabClick2.Name = "UI_TabClick"
                TabClick2.SoundId = TabClick
                TabClick2.Volume = v84.Volume or 0.6
                TabClick2.SoundGroup = SoundService:FindFirstChild("BoxingUI")
                TabClick2.Parent = SoundService
                t9.TabClick = TabClick2
            end
        end

        if TabClick2 then
            TabClick2.TimePosition = 0
            TabClick2:Play()
        end

        Frame.Visible = false
    end)
    v119.Activated:Connect(function() -- line: 745
        -- upvalues: Frame (copy), SoundService (copy), t9 (copy), v84 (copy), StatsRemote (copy)
        local StatsOpen = v84.StatsOpen
        local StatsOpen2

        if StatsOpen then
            StatsOpen2 = t9.StatsOpen

            if not StatsOpen2 or not StatsOpen2.Parent then
                StatsOpen2 = Instance.new("Sound")
                StatsOpen2.Name = "UI_StatsOpen"
                StatsOpen2.SoundId = StatsOpen
                StatsOpen2.Volume = v84.Volume or 0.6
                StatsOpen2.SoundGroup = SoundService:FindFirstChild("BoxingUI")
                StatsOpen2.Parent = SoundService
                t9.StatsOpen = StatsOpen2
            end
        end

        if StatsOpen2 then
            StatsOpen2.TimePosition = 0
            StatsOpen2:Play()
        end

        Frame.Visible = false
        StatsRemote:FireServer("ResetBuild")
    end)
    Frame.Parent = v112

    return Frame
end

ResetButton.Activated:Connect(function() -- line: 753
    -- upvalues: Boxing (copy), v65 (ref), SoundService (copy), t9 (copy), v84 (copy), v111 (ref), buildConfirm (copy)
    if v65 then
        return
    end

    local StatsOpen = v84.StatsOpen
    local StatsOpen2

    if StatsOpen then
        StatsOpen2 = t9.StatsOpen

        if not StatsOpen2 or not StatsOpen2.Parent then
            StatsOpen2 = Instance.new("Sound")
            StatsOpen2.Name = "UI_StatsOpen"
            StatsOpen2.SoundId = StatsOpen
            StatsOpen2.Volume = v84.Volume or 0.6
            StatsOpen2.SoundGroup = SoundService:FindFirstChild("BoxingUI")
            StatsOpen2.Parent = SoundService
            t9.StatsOpen = StatsOpen2
        end
    end

    if StatsOpen2 then
        StatsOpen2.TimePosition = 0
        StatsOpen2:Play()
    end

    v111 = v111 or buildConfirm()
    v111.Visible = true
    require(Boxing:WaitForChild("PadFocus")).Into(v111)
end)

local Activated = if not BoxingConfig.StatLocks then {} else nil
local t13 = {
    Panel = {
        Id = "rbxassetid://128654832501433",
        Scale = 0.42,
        Rect = { 82, 30, 516, 962 },
        Slice = { 46, 70, 470, 916 }
    },
    Button = {
        Id = "rbxassetid://88548113049400",
        FitHeight = true,
        Rect = { 68, 104, 894, 196 },
        Slice = { 40, 20, 780, 34 }
    }
}

Font.new("rbxasset://fonts/families/Merriweather.json", Enum.FontWeight.Regular)

local v120 = Font.new("rbxasset://fonts/families/Merriweather.json", Enum.FontWeight.Bold)

Font.new("rbxasset://fonts/families/Montserrat.json", Enum.FontWeight.Heavy, Enum.FontStyle.Italic)

local v121 = Color3.fromRGB(242, 236, 228)
local v122 = Color3.fromRGB(176, 166, 154)

Color3.fromRGB(235, 80, 80)
Color3.fromRGB(120, 230, 140)
Color3.fromRGB(255, 200, 200)

local function art(p29, p30, p31) -- line: 782
    -- upvalues: t13 (copy)
    local v123 = t13[p30]
    local ImageLabel = Instance.new("ImageLabel")

    ImageLabel.Name = p30 .. "Art"
    ImageLabel.BackgroundTransparency = 1
    ImageLabel.Size = UDim2.fromScale(1, 1)
    ImageLabel.Image = v123.Id
    ImageLabel.ImageRectOffset = Vector2.new(v123.Rect[1], v123.Rect[2])
    ImageLabel.ImageRectSize = Vector2.new(v123.Rect[3], v123.Rect[4])
    ImageLabel.ScaleType = Enum.ScaleType.Slice
    ImageLabel.SliceCenter = Rect.new(v123.Slice[1], v123.Slice[2], v123.Slice[3], v123.Slice[4])
    ImageLabel.SliceScale = v123.Scale or 1

    if v123.FitHeight then
        local function fit() -- line: 795
            -- upvalues: v123 (copy), ImageLabel (copy)
            local Y = ImageLabel.AbsoluteSize.Y

            if Y > 0 then
                ImageLabel.SliceScale = Y / v123.Rect[4]
            end
        end

        ImageLabel:GetPropertyChangedSignal("AbsoluteSize"):Connect(fit)
        task.defer(fit)
    end

    for v124, v125 in p31 or {} do
        ImageLabel[v124] = v125
    end

    ImageLabel.Parent = p29

    return ImageLabel
end

local function text(p32, p33) -- line: 810
    -- upvalues: v120 (copy), v121 (copy)
    local TextLabel = Instance.new("TextLabel")

    TextLabel.BackgroundTransparency = 1
    TextLabel.FontFace = v120
    TextLabel.TextColor3 = v121
    TextLabel.TextSize = 15
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left

    for v126, v127 in p33 do
        TextLabel[v126] = v127
    end

    TextLabel.Parent = p32

    return TextLabel
end

local function ink(p34, p35) -- line: 823
    local UIStroke = Instance.new("UIStroke")

    UIStroke.Color = Color3.new(0, 0, 0)
    UIStroke.Thickness = p35 or 1.2
    UIStroke.Parent = p34
end

local t14 = {}
local t15, v128

for _, v129 in Stats.Names do
    if v129 ~= "Willpower" then
        for i = 1, 2 do
            v99 = Stats.Subs[v129] and Stats.Subs[v129][i]
            t15 = {
                Stat = v129,
                Index = i
            }

            local v130

            if type(v99) == "table" then
                local Name = v99.Name

                if Name then
                    v130 = Name
                    v128 = true
                else
                    Name = v99[1]

                    if Name then
                        v130 = Name
                        v128 = true
                    else
                        v128 = false
                    end
                end
            else
                v128 = false
            end

            if not v128 then
                v130 = tostring(v99)
            end

            t15.Label = v130
            table.insert(t14, t15)
        end
    end
end

local function lockAttr(p36) -- line: 840
    return "StatLock_" .. p36.Stat .. "_" .. (if p36.Index == 1 then "A" else "B")
end

local MenuStyle2 = require(ReplicatedStorage:WaitForChild("Boxing"):WaitForChild("MenuStyle"))
local Frame = Instance.new("Frame")

Frame.Name = "LockPanel"
Frame.AnchorPoint = Vector2.new(0, 0.5)
Frame.Position = UDim2.new(0, 18, 0.5, 0)
Frame.Size = UDim2.fromOffset(320, 30 + #t14 * 50)
Frame.BackgroundTransparency = 1
Frame.ZIndex = 5
Frame.Parent = StatsGui:WaitForChild("Root")

local UIScale = Instance.new("UIScale")

UIScale.Parent = Frame

local function syncScale() -- line: 859
    -- upvalues: Scale (copy), CurrentCamera (copy), Frame (copy), UIScale (copy)
    local v131 = CurrentCamera.ViewportSize.Y < 500

    UIScale.Scale = Scale.Scale * (v131 and 0.88 or 1)
    Frame.Position = UDim2.new(0, 18, 0.5, v131 and 14 or 0)
end

Scale:GetPropertyChangedSignal("Scale"):Connect(syncScale)

local v132 = CurrentCamera.ViewportSize.Y < 500

UIScale.Scale = Scale.Scale * (v132 and 0.88 or 1)
Frame.Position = UDim2.new(0, 18, 0.5, v132 and 14 or 0)

local function syncView() -- line: 869
    -- upvalues: StatsGui (copy), Frame (copy)
    Frame.Visible = StatsGui:GetAttribute("View") ~= "Build"
end

StatsGui:GetAttributeChangedSignal("View"):Connect(syncView)
Frame.Visible = StatsGui:GetAttribute("View") ~= "Build"
v132 = {
    Name = "Hint",
    Text = "STAT LOCKS  (LOCKED = TRAINING WON'T RAISE IT)",
    TextSize = 13,
    ZIndex = 8,
    TextColor3 = v122,
    Position = UDim2.fromOffset(4, 0),
    Size = UDim2.new(1, -8, 0, 24)
}

local TextLabel = Instance.new("TextLabel")

TextLabel.BackgroundTransparency = 1
TextLabel.FontFace = v120
TextLabel.TextColor3 = v121
TextLabel.TextSize = 15
TextLabel.TextXAlignment = Enum.TextXAlignment.Left

for v133, v134 in v132 do
    TextLabel[v133] = v134
end

TextLabel.Parent = Frame

local Text = MenuStyle2.Text
local TextLabel2 = {
    Stroke = 1.5
}

pcall(Text, TextLabel, TextLabel2)
TextLabel.TextScaled = true
v132 = Instance.new("UITextSizeConstraint")
v132.MaxTextSize = 16
v132.Parent = TextLabel

local t16 = {}

local function paint(p37) -- line: 885
    -- upvalues: LocalPlayer (copy), MenuStyle2 (copy), t16 (copy)
    local v135 = t16[p37]
    local v137 = LocalPlayer:GetAttribute("StatLock_" .. p37.Stat .. "_" .. (if p37.Index == 1 then "A" else "B")) == true
    local v138 = v135:FindFirstChild("MenuFace") and v135.MenuFace:FindFirstChild("Label")

    if v138 then
        v138.RichText = true
        v138.Text = string.upper(p37.Label) .. ":  " .. (v137 and "<font color=\"#EB5050\">LOCKED</font>" or "OPEN")
    end

    MenuStyle2.SetSelected(v135, v137)
end

local v139, FocusLost

for v140, v141 in t14 do
    local TextButton = Instance.new("TextButton")

    TextButton.Name = v141.Stat .. "_" .. v141.Index
    TextButton.Position = UDim2.fromOffset(0, 30 + (v140 - 1) * 50)
    TextButton.Size = UDim2.fromOffset(320, 44)
    TextButton.Text = string.upper(v141.Label)
    TextButton.ZIndex = 8
    TextButton.Parent = Frame
    MenuStyle2.Button(TextButton, {
        MaxText = 17
    })
    t16[v141] = TextButton
    TextButton.Activated:Connect(function() -- line: 907
        -- upvalues: LocalPlayer (copy), SoundService (copy), t9 (copy), v84 (copy), StatsRemote (copy), v141 (copy)
        local TabClick = v84.TabClick
        local TabClick2

        if TabClick then
            TabClick2 = t9.TabClick

            if not TabClick2 or not TabClick2.Parent then
                TabClick2 = Instance.new("Sound")
                TabClick2.Name = "UI_TabClick"
                TabClick2.SoundId = TabClick
                TabClick2.Volume = v84.Volume or 0.6
                TabClick2.SoundGroup = SoundService:FindFirstChild("BoxingUI")
                TabClick2.Parent = SoundService
                t9.TabClick = TabClick2
            end
        end

        if TabClick2 then
            TabClick2.TimePosition = 0
            TabClick2:Play()
        end

        StatsRemote:FireServer("Lock", v141.Stat, v141.Index, LocalPlayer:GetAttribute("StatLock_" .. v141.Stat .. "_" .. (v141.Index == 1 and "A" or "B")) ~= true)
    end)
    FocusLost = v141.Stat
    v139 = if v141.Index == 1 then "A" else "B"
    LocalPlayer:GetAttributeChangedSignal("StatLock_" .. FocusLost .. "_" .. v139):Connect(function() -- line: 911
        -- upvalues: paint (copy), v141 (copy)
        paint(v141)
    end)
    task.defer(paint, v141)
end

Frame.Size = UDim2.fromOffset(440, Frame.Size.Y.Offset)
TextLabel.Size = UDim2.new(0, 312, 0, 24)

local Scale3 = {
    Name = "GoalHint",
    Text = "GOAL CAP",
    TextSize = 13,
    ZIndex = 8,
    TextColor3 = v122,
    TextXAlignment = Enum.TextXAlignment.Center,
    Position = UDim2.fromOffset(336, 0),
    Size = UDim2.fromOffset(104, 24)
}

TextLabel2 = Instance.new("TextLabel")
TextLabel2.BackgroundTransparency = 1
TextLabel2.FontFace = v120
TextLabel2.TextColor3 = v121
TextLabel2.TextSize = 15
TextLabel2.TextXAlignment = Enum.TextXAlignment.Left

for v142, v143 in Scale3 do
    TextLabel2[v142] = v143
end

TextLabel2.Parent = Frame

local Text2 = MenuStyle2.Text

t15 = {
    Stroke = 1.5
}
pcall(Text2, TextLabel2, t15)
TextLabel2.TextScaled = true
Scale3 = Instance.new("UITextSizeConstraint")
Scale3.MaxTextSize = 16
Scale3.Parent = TextLabel2

local function goalAttr(p38) -- line: 935
    return "StatGoal_" .. p38.Stat .. "_" .. (if p38.Index == 1 then "A" else "B")
end

local function subAttr(p39) -- line: 938
    return "Stat_" .. p39.Stat .. "_" .. (if p39.Index == 1 then "A" else "B")
end

local t17 = {
    ["-"] = true,
    none = true,
    off = true,
    x = true,
    clear = true
}

for v144, v145 in t14 do
    local TextButton = Instance.new("TextButton")

    TextButton.Name = "Goal_" .. v145.Stat .. "_" .. v145.Index
    TextButton.Position = UDim2.fromOffset(336, 30 + (v144 - 1) * 50)
    TextButton.Size = UDim2.fromOffset(104, 44)
    TextButton.Text = "NONE"
    TextButton.ZIndex = 8
    TextButton.Parent = Frame
    MenuStyle2.Button(TextButton, {
        MaxText = 15,
        Accent = MenuStyle2.Colors.Amber
    })

    local MenuFace = TextButton:FindFirstChild("MenuFace")
    local Label = MenuFace and MenuFace:FindFirstChild("Label")
    local TextBox = Instance.new("TextBox")

    TextBox.Name = "Input"
    TextBox.BackgroundTransparency = 1
    TextBox.Size = UDim2.fromScale(1, 1)
    TextBox.Text = ""
    v139 = Stats.SubMax
    TextBox.PlaceholderText = "0-" .. tostring(v139)
    TextBox.PlaceholderColor3 = v122
    TextBox.ClearTextOnFocus = true
    TextBox.TextEditable = true
    TextBox.Selectable = false
    TextBox.FontFace = MenuStyle2.Font
    TextBox.TextColor3 = v121
    TextBox.TextScaled = true
    TextBox.TextTransparency = 1
    TextBox.ZIndex = 20

    local UIPadding = Instance.new("UITextSizeConstraint")

    UIPadding.MaxTextSize = 15
    UIPadding.MinTextSize = 6
    UIPadding.Parent = TextBox
    UIPadding = Instance.new("UIPadding")
    FocusLost = UDim.new(0, 8)

    local v146 = UDim.new(0, 8)

    UIPadding.PaddingLeft = FocusLost
    UIPadding.PaddingRight = v146
    FocusLost = UDim.new(0, 6)
    v146 = UDim.new(0, 4)
    UIPadding.PaddingTop = FocusLost
    UIPadding.PaddingBottom = v146
    UIPadding.Parent = TextBox
    TextBox.Parent = TextButton

    local function paintGoal() -- line: 979
        -- upvalues: LocalPlayer (copy), MenuStyle2 (copy), TextButton (copy), v145 (copy), Label (copy)
        local Attribute = LocalPlayer:GetAttribute("StatGoal_" .. v145.Stat .. "_" .. (if v145.Index == 1 then "A" else "B"))

        if not Label then
            return
        end

        Label.RichText = true

        if type(Attribute) == "number" then
            local v149 = (LocalPlayer:GetAttribute("Stat_" .. v145.Stat .. "_" .. (if v145.Index == 1 then "A" else "B")) or 0) >= Attribute - 1E-06
            local v150 = string.format("%.1f", Attribute)

            Label.Text = if v149 then string.format("<font color=\"%s\">%s</font>", MenuStyle2.Hex.Green, v150) else v150
        else
            Label.Text = string.format("<font color=\"%s\">NONE</font>", MenuStyle2.Hex.Lilac)
        end

        MenuStyle2.SetSelected(TextButton, type(Attribute) == "number")
    end

    FocusLost = TextBox.Focused
    FocusLost:Connect(function() -- line: 994
        -- upvalues: SoundService (copy), t9 (copy), v84 (copy), TextBox (copy), Label (copy)
        local TabClick = v84.TabClick
        local TabClick2

        if TabClick then
            TabClick2 = t9.TabClick

            if not TabClick2 or not TabClick2.Parent then
                TabClick2 = Instance.new("Sound")
                TabClick2.Name = "UI_TabClick"
                TabClick2.SoundId = TabClick
                TabClick2.Volume = v84.Volume or 0.6
                TabClick2.SoundGroup = SoundService:FindFirstChild("BoxingUI")
                TabClick2.Parent = SoundService
                t9.TabClick = TabClick2
            end
        end

        if TabClick2 then
            TabClick2.TimePosition = 0
            TabClick2:Play()
        end

        TextBox.TextTransparency = 0

        if Label then
            Label.Visible = false
        end
    end)
    FocusLost = TextBox.FocusLost
    FocusLost:Connect(function(p40) -- line: 1001
        -- upvalues: LocalPlayer (copy), Stats (copy), StatsRemote (copy), t17 (copy), v145 (copy), TextBox (copy), paintGoal (copy), Label (copy)
        local v151 = string.lower((string.gsub(TextBox.Text, "^%s*(.-)%s*$", "%1")))

        TextBox.Text = ""
        TextBox.TextTransparency = 1

        if Label then
            Label.Visible = true
        end

        local v153 = tonumber((string.gsub(v151, ",", ".")))

        if not t17[v151] and v153 ~= 0 and (v151 ~= "" or not p40) then
            if v153 and v153 > 0 then
                local v156 = math.clamp(math.floor(v153 * 10 + 0.5) / 10, 0.1, Stats.SubMax)

                StatsRemote:FireServer("Goal", v145.Stat, v145.Index, v156)
            end
        elseif LocalPlayer:GetAttribute("StatGoal_" .. v145.Stat .. "_" .. (if v145.Index == 1 then "A" else "B")) ~= nil then
            StatsRemote:FireServer("Goal", v145.Stat, v145.Index, false)
        end

        paintGoal()
    end)
    FocusLost = TextButton.Activated
    FocusLost:Connect(function() -- line: 1020
        -- upvalues: TextBox (copy)
        if not TextBox:IsFocused() then
            TextBox:CaptureFocus()
        end
    end)

    local v158

    LocalPlayer:GetAttributeChangedSignal("StatGoal_" .. v145.Stat .. "_" .. (if v145.Index == 1 then "A" else "B")):Connect(paintGoal)

    local Stat = v145.Stat

    v158 = if v145.Index == 1 then "A" else "B"
    LocalPlayer:GetAttributeChangedSignal("Stat_" .. Stat .. "_" .. v158):Connect(paintGoal)
    task.defer(paintGoal)
end

local v159

if BoxingConfig.Avatar then
    Activated = BoxingConfig.Avatar.StatResetCost

    if Activated then
        v159 = Activated
        v128 = true
    else
        Activated = BoxingConfig.Avatar.ResetCost

        if Activated then
            v159 = Activated
            v128 = true
        else
            v128 = false
        end
    end
else
    v128 = false
end

if not v128 then
    v159 = 1
end

local TextButton = Instance.new("TextButton")

TextButton.Name = "ResetOneButton"
TextButton.Position = ResetButton.Position + UDim2.fromOffset(0, ResetButton.Size.Y.Offset + 8)
TextButton.Size = UDim2.new(ResetButton.Size.X, UDim.new(0, 40))
TextButton.Text = "RESET ONE STAT"
TextButton.ZIndex = ResetButton.ZIndex
TextButton.Parent = ResetButton.Parent
MenuStyle.Button(TextButton, {
    MaxText = 14,
    Accent = MenuStyle.Colors.Red
})

local v160

local function build() -- line: 1046
    -- upvalues: LocalPlayer (copy), Stats (copy), StatsGui (copy), Scale (copy), MenuStyle (copy), SoundService (copy), t9 (copy), v84 (copy), StatsRemote (copy), v160 (ref), v159 (ref)
    local v161 = StatsGui:FindFirstChild("Root") or StatsGui

    v160 = Instance.new("Frame")
    v160.Name = "ResetOneStat"

    local v162 = v160

    v162.AnchorPoint = Vector2.new(0.5, 0.5)

    local v163 = v160

    v163.Position = UDim2.fromScale(0.5, 0.5)

    local v164 = v160

    v164.Size = UDim2.fromOffset(540, 400)

    local v165 = v160

    v165.BackgroundColor3 = Color3.fromRGB(58, 58, 60)
    v160.ZIndex = 50
    v160.Visible = false

    local UIScale = Instance.new("UIScale")

    UIScale.Parent = v160

    local function syncScale() -- line: 1058
        -- upvalues: UIScale (copy), Scale (copy)
        UIScale.Scale = Scale.Scale
    end

    Scale:GetPropertyChangedSignal("Scale"):Connect(syncScale)
    UIScale.Scale = Scale.Scale
    MenuStyle.Panel(v160, {
        Accent = MenuStyle.Colors.Red
    })

    local TextLabel = Instance.new("TextLabel")

    TextLabel.Name = "Message"
    TextLabel.BackgroundTransparency = 1
    TextLabel.Position = UDim2.fromOffset(16, 14)
    TextLabel.Size = UDim2.new(1, -32, 0, 96)
    TextLabel.TextScaled = true
    TextLabel.TextWrapped = true
    TextLabel.RichText = true
    TextLabel.ZIndex = 52
    TextLabel.Parent = v160
    MenuStyle.Text(TextLabel, {
        Heading = false
    })

    local UITextSizeConstraint = Instance.new("UITextSizeConstraint")

    UITextSizeConstraint.MaxTextSize = 22
    UITextSizeConstraint.Parent = TextLabel

    local function makeButton(p41, p42, p43, p44, p45) -- line: 1078
        -- upvalues: MenuStyle (copy), v160 (ref)
        local TextButton = Instance.new("TextButton")

        TextButton.Name = p41
        TextButton.Position = p43
        TextButton.Size = p44
        TextButton.Text = p42
        TextButton.ZIndex = 52
        TextButton.Parent = v160
        MenuStyle.Button(TextButton, {
            MaxText = 16,
            Accent = p45
        })

        return TextButton
    end

    local t18 = {}

    for v166, v167 in Stats.Names do
        local v168 = (v166 - 1) % 2
        local v170 = math.floor((v166 - 1) / 2)

        t18[v167] = makeButton("Stat_" .. v167, string.upper(v167), UDim2.new(v168 * 0.5, v168 == 0 and 16 or 6, 0, v170 * 58 + 122), UDim2.new(0.5, -22, 0, 48))
    end

    local v175 = makeButton("Cancel", "CANCEL", UDim2.new(0, 16, 1, -70), UDim2.new(0.5, -22, 0, 54))
    local v176 = makeButton("Confirm", "CONFIRM", UDim2.new(0.5, 6, 1, -70), UDim2.new(0.5, -22, 0, 54), MenuStyle.Colors.Red)
    local v177

    local function value(p46) -- line: 1098
        -- upvalues: LocalPlayer (copy)
        return (LocalPlayer:GetAttribute("Stat_" .. p46 .. "_A") or 0) + (LocalPlayer:GetAttribute("Stat_" .. p46 .. "_B") or 0)
    end

    local function show(p47) -- line: 1101
        -- upvalues: TextLabel (copy), UITextSizeConstraint (copy), t18 (copy), v175 (copy), v176 (copy), v177 (ref), LocalPlayer (copy), Stats (copy), MenuStyle (copy), v159 (ref)
        v177 = p47

        for v178, v179 in t18 do
            v179.Visible = p47 == nil

            local v180 = v179:FindFirstChild("MenuFace") and v179.MenuFace:FindFirstChild("Label")

            if v180 then
                v180.RichText = true
                v180.Text = string.format("%s  <font color=\"%s\">%.1f</font>", string.upper(v178), MenuStyle.Hex.Amber, (LocalPlayer:GetAttribute("Stat_" .. v178 .. "_A") or 0) + (LocalPlayer:GetAttribute("Stat_" .. v178 .. "_B") or 0))
            end
        end

        v176.Visible = p47 ~= nil
        TextLabel.Size = if p47 then UDim2.new(1, -32, 1, -112) else UDim2.new(1, -32, 0, 96)
        UITextSizeConstraint.MaxTextSize = p47 and 26 or 22

        if p47 then
            local v182 = Stats.Subs[p47]
            local format = string.format
            local Red = MenuStyle.Hex.Red
            local v183 = string.upper(p47)
            local v184 = v182[1]
            local v185 = v182[2]
            local v186 = v159 == 1 and "" or "s"

            TextLabel.Text = format("Reset <font color=\"%s\">%s</font> (%s + %s) back to 0? It costs %d reroll token%s. Your other stats, skills, locks and goal caps stay. This can't be undone.", Red, v183, v184, v185, v159, v186)
            v175.Text = "BACK"
        else
            TextLabel.Text = string.format("Pick ONE stat to reset back to 0. It costs %d reroll token%s, and nothing else changes.", v159, v159 == 1 and "" or "s")
            v175.Text = "CANCEL"
        end

        local v187 = v175:FindFirstChild("MenuFace") and v175.MenuFace:FindFirstChild("Label")

        if v187 then
            v187.Text = v175.Text
        end
    end

    for v188, v189 in t18 do
        v189.Activated:Connect(function() -- line: 1131
            -- upvalues: show (copy), v188 (copy), SoundService (copy), t9 (copy), v84 (copy)
            local TabClick = v84.TabClick
            local TabClick2

            if TabClick then
                TabClick2 = t9.TabClick

                if not TabClick2 or not TabClick2.Parent then
                    TabClick2 = Instance.new("Sound")
                    TabClick2.Name = "UI_TabClick"
                    TabClick2.SoundId = TabClick
                    TabClick2.Volume = v84.Volume or 0.6
                    TabClick2.SoundGroup = SoundService:FindFirstChild("BoxingUI")
                    TabClick2.Parent = SoundService
                    t9.TabClick = TabClick2
                end
            end

            if TabClick2 then
                TabClick2.TimePosition = 0
                TabClick2:Play()
            end

            show(v188)
        end)
    end

    v175.Activated:Connect(function() -- line: 1136
        -- upvalues: v177 (ref), show (copy), SoundService (copy), t9 (copy), v84 (copy), v160 (ref)
        local TabClick = v84.TabClick
        local TabClick2

        if TabClick then
            TabClick2 = t9.TabClick

            if not TabClick2 or not TabClick2.Parent then
                TabClick2 = Instance.new("Sound")
                TabClick2.Name = "UI_TabClick"
                TabClick2.SoundId = TabClick
                TabClick2.Volume = v84.Volume or 0.6
                TabClick2.SoundGroup = SoundService:FindFirstChild("BoxingUI")
                TabClick2.Parent = SoundService
                t9.TabClick = TabClick2
            end
        end

        if TabClick2 then
            TabClick2.TimePosition = 0
            TabClick2:Play()
        end

        if v177 then
            show(nil)
        else
            v160.Visible = false
        end
    end)
    v176.Activated:Connect(function() -- line: 1144
        -- upvalues: v177 (ref), SoundService (copy), t9 (copy), v84 (copy), StatsRemote (copy), v160 (ref)
        if not v177 then
            return
        end

        local StatsOpen = v84.StatsOpen
        local StatsOpen2

        if StatsOpen then
            StatsOpen2 = t9.StatsOpen

            if not StatsOpen2 or not StatsOpen2.Parent then
                StatsOpen2 = Instance.new("Sound")
                StatsOpen2.Name = "UI_StatsOpen"
                StatsOpen2.SoundId = StatsOpen
                StatsOpen2.Volume = v84.Volume or 0.6
                StatsOpen2.SoundGroup = SoundService:FindFirstChild("BoxingUI")
                StatsOpen2.Parent = SoundService
                t9.StatsOpen = StatsOpen2
            end
        end

        if StatsOpen2 then
            StatsOpen2.TimePosition = 0
            StatsOpen2:Play()
        end

        StatsRemote:FireServer("ResetStat", v177)
        v160.Visible = false
    end)
    show(nil)
    v160.Parent = v161

    return v160, show
end

local v191

TextButton.Activated:Connect(function() -- line: 1157
    -- upvalues: v65 (ref), SoundService (copy), t9 (copy), v84 (copy), v111 (ref), v160 (ref), build (copy), v191 (ref)
    if v65 then
        return
    end

    local StatsOpen = v84.StatsOpen
    local StatsOpen2

    if StatsOpen then
        StatsOpen2 = t9.StatsOpen

        if not StatsOpen2 or not StatsOpen2.Parent then
            StatsOpen2 = Instance.new("Sound")
            StatsOpen2.Name = "UI_StatsOpen"
            StatsOpen2.SoundId = StatsOpen
            StatsOpen2.Volume = v84.Volume or 0.6
            StatsOpen2.SoundGroup = SoundService:FindFirstChild("BoxingUI")
            StatsOpen2.Parent = SoundService
            t9.StatsOpen = StatsOpen2
        end
    end

    if StatsOpen2 then
        StatsOpen2.TimePosition = 0
        StatsOpen2:Play()
    end

    if not v160 then
        v160, v191 = build()
    end

    v191(nil)
    v160.Visible = true

    if v111 then
        v111.Visible = false
    end
end)

local function hookButton() -- line: 1174
    -- upvalues: PlayerGui (copy), v47 (ref), v65 (ref), SoundService (copy), t9 (copy), v84 (copy), openStats (copy)
    local v192 = PlayerGui:WaitForChild("BoxingHUD", 10)
    local v193 = v192 and v192:WaitForChild("SideMenu", 10)
    local v194 = v193 and v193:WaitForChild("Statistics", 10)

    if v194 and not v194:GetAttribute("StatsHooked") then
        v194:SetAttribute("StatsHooked", true)
        v194.Activated:Connect(function() -- line: 1180
            -- upvalues: v47 (ref), v65 (ref), SoundService (copy), t9 (copy), v84 (copy), openStats (copy)
            if not (v47 or v65) then
                local StatsOpen = v84.StatsOpen
                local StatsOpen2

                if StatsOpen then
                    StatsOpen2 = t9.StatsOpen

                    if not StatsOpen2 or not StatsOpen2.Parent then
                        StatsOpen2 = Instance.new("Sound")
                        StatsOpen2.Name = "UI_StatsOpen"
                        StatsOpen2.SoundId = StatsOpen
                        StatsOpen2.Volume = v84.Volume or 0.6
                        StatsOpen2.SoundGroup = SoundService:FindFirstChild("BoxingUI")
                        StatsOpen2.Parent = SoundService
                        t9.StatsOpen = StatsOpen2
                    end
                end

                if StatsOpen2 then
                    StatsOpen2.TimePosition = 0
                    StatsOpen2:Play()
                end
            end

            openStats()
        end)
    end
end

task.spawn(hookButton)
require(ReplicatedStorage:WaitForChild("Boxing"):WaitForChild("BoxingVirtualInput")).Changed:Connect(function(p48, p49) -- line: 1191
    -- upvalues: RunService (copy), Boxing (copy), BoxingCamera (copy), StatsGui (copy), v21 (ref), v47 (ref), showLabel (copy), CurrentCamera (copy), t4 (copy), t5 (ref), v64 (ref), v65 (ref), ContextActionService (copy), t7 (ref), v77 (ref), MangaTransition (copy), SoundService (copy), t9 (copy), v84 (copy), BackpackLock (copy), openStats (copy)
    if not p49 or v65 or p48 == "Back" and (StatsGui:GetAttribute("PickerOpen") or os.clock() - (StatsGui:GetAttribute("PickerClosedAt") or 0) < 0.3) then
        return
    end

    if p48 ~= "Statistics" or v47 then
        if (p48 == "Back" or p48 == "Statistics") and v47 then
            local StatsOpen = v84.StatsOpen
            local StatsOpen2

            if StatsOpen then
                StatsOpen2 = t9.StatsOpen

                if not StatsOpen2 or not StatsOpen2.Parent then
                    StatsOpen2 = Instance.new("Sound")
                    StatsOpen2.Name = "UI_StatsOpen"
                    StatsOpen2.SoundId = StatsOpen
                    StatsOpen2.Volume = v84.Volume or 0.6
                    StatsOpen2.SoundGroup = SoundService:FindFirstChild("BoxingUI")
                    StatsOpen2.Parent = SoundService
                    t9.StatsOpen = StatsOpen2
                end
            end

            if StatsOpen2 then
                StatsOpen2.TimePosition = 0
                StatsOpen2:Play()
            end

            if v47 then
                if v65 then
                    return
                end

                v21 = nil

                local function v196() -- line: 597
                    -- upvalues: RunService (copy), Boxing (copy), BoxingCamera (copy), StatsGui (copy), v47 (ref), showLabel (copy), CurrentCamera (copy), t4 (copy), t5 (ref), v64 (ref), ContextActionService (copy), t7 (ref), v77 (ref), BackpackLock (copy)
                    v47 = false

                    local function v197() -- line: 599
                        -- upvalues: Boxing (copy)
                        Boxing:WaitForChild("SkillRemote"):FireServer("Viewing", false)
                    end

                    pcall(v197)
                    showLabel(nil)
                    StatsGui.Enabled = false
                    RunService:UnbindFromRenderStep("StatsCamera")
                    v64 = nil
                    t7 = nil
                    v77 = nil
                    StatsGui:SetAttribute("View", nil)
                    CurrentCamera.CameraType = t5 and t5.Type or Enum.CameraType.Custom

                    if t5 then
                        CurrentCamera.FieldOfView = t5.FieldOfView
                        CurrentCamera.CFrame = t5.CFrame
                    end

                    for _, v198 in t4 do
                        if v198.Parent then
                            v198.Enabled = true
                        end
                    end

                    table.clear(t4)
                    BackpackLock.Unlock("Statistics")
                    ContextActionService:UnbindAction("StatsFreeze")
                    BoxingCamera.SetSuspended(false, "StatsController")
                end

                v65 = true
                MangaTransition.Play(v196)
                v65 = false
            end
        end
    else
        local StatsOpen2 = v84.StatsOpen
        local StatsOpen

        if StatsOpen2 then
            StatsOpen = t9.StatsOpen

            if not StatsOpen or not StatsOpen.Parent then
                StatsOpen = Instance.new("Sound")
                StatsOpen.Name = "UI_StatsOpen"
                StatsOpen.SoundId = StatsOpen2
                StatsOpen.Volume = v84.Volume or 0.6
                StatsOpen.SoundGroup = SoundService:FindFirstChild("BoxingUI")
                StatsOpen.Parent = SoundService
                t9.StatsOpen = StatsOpen
            end
        end

        if StatsOpen then
            StatsOpen.TimePosition = 0
            StatsOpen:Play()
        end

        openStats()
    end
end)
LocalPlayer.CharacterAdded:Connect(function() -- line: 1207
    -- upvalues: RunService (copy), Boxing (copy), BoxingCamera (copy), StatsGui (copy), v21 (ref), v47 (ref), showLabel (copy), CurrentCamera (copy), t4 (copy), t5 (ref), v64 (ref), v65 (ref), ContextActionService (copy), t7 (ref), v77 (ref), MangaTransition (copy), BackpackLock (copy), hookButton (copy)
    if v47 and v47 and not v65 then
        v21 = nil

        local function v199() -- line: 597
            -- upvalues: RunService (copy), Boxing (copy), BoxingCamera (copy), StatsGui (copy), v47 (ref), showLabel (copy), CurrentCamera (copy), t4 (copy), t5 (ref), v64 (ref), ContextActionService (copy), t7 (ref), v77 (ref), BackpackLock (copy)
            v47 = false

            local function v200() -- line: 599
                -- upvalues: Boxing (copy)
                Boxing:WaitForChild("SkillRemote"):FireServer("Viewing", false)
            end

            pcall(v200)
            showLabel(nil)
            StatsGui.Enabled = false
            RunService:UnbindFromRenderStep("StatsCamera")
            v64 = nil
            t7 = nil
            v77 = nil
            StatsGui:SetAttribute("View", nil)
            CurrentCamera.CameraType = t5 and t5.Type or Enum.CameraType.Custom

            if t5 then
                CurrentCamera.FieldOfView = t5.FieldOfView
                CurrentCamera.CFrame = t5.CFrame
            end

            for _, v201 in t4 do
                if v201.Parent then
                    v201.Enabled = true
                end
            end

            table.clear(t4)
            BackpackLock.Unlock("Statistics")
            ContextActionService:UnbindAction("StatsFreeze")
            BoxingCamera.SetSuspended(false, "StatsController")
        end

        v65 = true
        MangaTransition.Play(v199)
        v65 = false
    end

    task.defer(hookButton)
end)

local GuiService2 = game:GetService("GuiService")
local UserInputService2 = game:GetService("UserInputService")
local t19 = {}

for _, v202 in Stats.Names do
    t19[v202] = true
end

local function statOf(p50) -- line: 1228
    -- upvalues: StatsGui (copy), t19 (copy)
    local v204

    while true do
        if not p50 or p50 == StatsGui then
            return nil
        end

        v204 = string.match(p50.Name, "^Goal_(%a+)_%d$") or string.match(p50.Name, "^(%a+)_%d$")

        local v205 = if v204 then t19[v204] else nil

        if not v204 or not v205 then
            p50 = p50.Parent
            continue
        end

        break
    end

    return v204
end

GuiService2:GetPropertyChangedSignal("SelectedObject"):Connect(function() -- line: 1238
    -- upvalues: Stats (copy), StatsGui (copy), v21 (ref), v47 (ref), showLabel (copy), n3 (ref), GuiService2 (copy), statOf (copy)
    local SelectedObject = GuiService2.SelectedObject

    if v47 and SelectedObject and SelectedObject:IsDescendantOf(StatsGui) then
        local v206 = statOf(SelectedObject)

        if not v206 then
            return
        end

        padPicking = true
        v21 = v206
        n3 = table.find(Stats.Names, v206) or n3
        showLabel(v206)
    end
end)
task.spawn(function() -- line: 1253
    -- upvalues: StatsGui (copy), MenuStyle (copy), UserInputService2 (copy)
    local v207 = StatsGui:WaitForChild("Root"):WaitForChild("LockPanel", 30)

    if not v207 then
        return
    end

    local TextLabel = Instance.new("TextLabel")

    TextLabel.Name = "PadTip"
    TextLabel.BackgroundTransparency = 1
    TextLabel.AnchorPoint = Vector2.new(0, 0)
    TextLabel.Position = UDim2.new(0, 4, 1, 4)
    TextLabel.Size = UDim2.new(1, -8, 0, 22)
    TextLabel.Text = "L1 / R1  -  SEE EACH STAT'S POINTS"
    TextLabel.TextColor3 = Color3.fromRGB(255, 210, 90)
    TextLabel.TextScaled = true
    TextLabel.ZIndex = 8

    local UITextSizeConstraint = Instance.new("UITextSizeConstraint")

    UITextSizeConstraint.MaxTextSize = 16
    UITextSizeConstraint.Parent = TextLabel

    local Text = MenuStyle.Text
    local t20 = {
        Stroke = 1.5
    }

    pcall(Text, TextLabel, t20)
    TextLabel.Parent = v207

    local function sync() -- line: 1273
        -- upvalues: TextLabel (copy), UserInputService2 (copy)
        local LastInputType = UserInputService2:GetLastInputType()
        local GamepadEnabled = UserInputService2.GamepadEnabled
        local v208, v209

        if GamepadEnabled then
            if string.find(LastInputType.Name, "Gamepad") ~= nil then
                v209 = true
            else
                v208 = UserInputService2.KeyboardEnabled or UserInputService2.TouchEnabled
                v209 = not v208
            end
        else
            v209 = GamepadEnabled
        end

        TextLabel.Visible = v209
    end

    UserInputService2.LastInputTypeChanged:Connect(sync)

    local LastInputType = UserInputService2:GetLastInputType()
    local GamepadEnabled = UserInputService2.GamepadEnabled
    local v210, v211

    if GamepadEnabled then
        if string.find(LastInputType.Name, "Gamepad") ~= nil then
            v211 = true
        else
            v210 = UserInputService2.KeyboardEnabled or UserInputService2.TouchEnabled
            v211 = not v210
        end
    else
        v211 = GamepadEnabled
    end

    TextLabel.Visible = v211
end)
