-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Boxing = ReplicatedStorage:WaitForChild("Boxing")
local BoxingConfig = require(Boxing:WaitForChild("BoxingConfig"))
local BoxingCamera = require(Boxing:WaitForChild("BoxingCamera"))
local BoxingVisuals = require(Boxing:WaitForChild("BoxingVisuals"))
local SoundService = game:GetService("SoundService")
local BoxingRemote = Boxing:WaitForChild("BoxingRemote")
local Training = BoxingConfig.Training
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local function padMode() -- line: 37
    -- upvalues: UserInputService (copy)
    return string.find(UserInputService:GetLastInputType().Name, "Gamepad", 1, true) ~= nil
end

local t1 = {
    Power = Color3.fromRGB(235, 40, 40),
    Speed = Color3.fromRGB(40, 130, 235),
    Technique = Color3.fromRGB(245, 165, 25),
    Willpower = Color3.fromRGB(160, 80, 245),
    Endurance = Color3.fromRGB(40, 190, 40),
    Stamina = Color3.fromRGB(245, 215, 30)
}
local MenuStyle = require(Boxing:WaitForChild("MenuStyle"))
local HudArt = require(Boxing:WaitForChild("HudArt"))
local Colors, Font = MenuStyle.Colors, MenuStyle.Font

local function mul(p1, p2) -- line: 57
    return Color3.new(p1.R * p2, p1.G * p2, p1.B * p2)
end

local function corner(p3, p4) -- line: 61
    local UICorner = Instance.new("UICorner")

    UICorner.CornerRadius = p4 or UDim.new(0.5, 0)
    UICorner.Parent = p3

    return UICorner
end

local function stroke(p5, p6, p7, p8) -- line: 68
    local UIStroke = Instance.new("UIStroke")

    UIStroke.Color = p6
    UIStroke.Thickness = p7
    UIStroke.LineJoinMode = Enum.LineJoinMode.Round

    if not p8 then
        UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    end

    UIStroke.Parent = p5

    return UIStroke
end

local function label(p9, p10, p11, p12, p13, p14, p15, p16) -- line: 80
    -- upvalues: MenuStyle (copy)
    local TextLabel = Instance.new("TextLabel")

    TextLabel.Name = p10
    TextLabel.BackgroundTransparency = 1
    TextLabel.Text = p11
    TextLabel.TextScaled = true
    TextLabel.RichText = true
    TextLabel.Size = p12
    TextLabel.Position = p13
    TextLabel.AnchorPoint = Vector2.new(0.5, 0)
    TextLabel.Parent = p9
    MenuStyle.Text(TextLabel, {
        Color = p14,
        Stroke = if p15 then p16 or 2 else 0
    })

    if not p15 then
        local UIStroke = TextLabel:FindFirstChildOfClass("UIStroke")

        if UIStroke then
            UIStroke:Destroy()
        end
    end

    return TextLabel
end

local function endClip(p17, p18) -- line: 103
    -- upvalues: HudArt (copy)
    local ImageLabel = Instance.new("ImageLabel")

    ImageLabel.Name = p18 and "EndRight" or "EndLeft"
    ImageLabel.BackgroundTransparency = 1
    ImageLabel.AnchorPoint = Vector2.new(p18 and 0 or 1, 0.5)
    ImageLabel.Position = UDim2.new(p18 and 1 or 0, p18 and 1 or -1, 0.5, 0)
    ImageLabel.Size = UDim2.new(0, 12, 1, 4)
    ImageLabel.ScaleType = Enum.ScaleType.Stretch
    ImageLabel.ResampleMode = Enum.ResamplerMode.Pixelated
    ImageLabel.ZIndex = 8
    ImageLabel.Parent = p17

    local Apply = HudArt.Apply
    local v1 = not p18

    pcall(Apply, ImageLabel, "StaminaEnd", v1)

    return ImageLabel
end

local function spike(p19, p20, p21, p22, p23) -- line: 119
    local Frame = Instance.new("Frame")

    Frame.BackgroundTransparency = 1
    Frame.AnchorPoint = Vector2.new(0.5, p23 and 1 or 0)
    Frame.Size = UDim2.fromOffset(10, p21)
    Frame.Position = UDim2.new(p20, 0, p23 and 0 or 1, p23 and 2 or -2)
    Frame.ZIndex = 3

    for i = 1, 5 do
        local Frame2 = Instance.new("Frame")

        Frame2.BorderSizePixel = 0
        Frame2.BackgroundColor3 = p22
        Frame2.ZIndex = 3

        local v2 = (1 - (i - 1) / 5) * 10

        Frame2.Size = UDim2.new(0, math.max(1, v2), 0.2, 1)
        Frame2.AnchorPoint = Vector2.new(0.5, 0)

        local v3 = if p23 then 5 - i else i - 1

        Frame2.Position = UDim2.new(0.5, 0, v3 / 5, 0)
        Frame2.Parent = Frame
    end

    Frame.Parent = p19

    return Frame
end

local v4

local function buildUi(p24, p25) -- line: 147
    -- upvalues: UserInputService (copy), t1 (copy), MenuStyle (copy), Colors (copy), Font (copy), label (copy), endClip (copy), spike (copy)
    local v5 = t1[p24] or Color3.new(1, 1, 1)

    Color3.new(v5.R * 0.22, v5.G * 0.22, v5.B * 0.22)

    local BillboardGui = Instance.new("BillboardGui")

    BillboardGui.Name = "TrainingBar"
    BillboardGui.Size = UDim2.fromOffset(480, 272)
    BillboardGui.StudsOffsetWorldSpace = Vector3.new(0, 4.2, 0)
    BillboardGui.AlwaysOnTop = true
    BillboardGui.LightInfluence = 0
    BillboardGui.ResetOnSpawn = false
    BillboardGui.MaxDistance = 200
    BillboardGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local Frame = Instance.new("Frame")

    Frame.Name = "Header"
    Frame.AnchorPoint = Vector2.new(0.5, 0)
    Frame.Position = UDim2.new(0.5, 0, 0, 0)
    Frame.Size = UDim2.fromOffset(372, 44)
    Frame.ZIndex = 2
    Frame.Parent = BillboardGui

    local v6 = MenuStyle.Face(Frame)
    local Frame2 = Instance.new("Frame")

    Frame2.Name = "Gem"
    Frame2.BorderSizePixel = 0
    Frame2.BackgroundColor3 = v5
    Frame2.Size = UDim2.new(0, 10, 1, 0)
    Frame2.ZIndex = v6.ZIndex
    Frame2.Parent = v6

    local Frame3 = Instance.new("Frame")

    Frame3.BorderSizePixel = 0
    Frame3.BackgroundColor3 = Color3.new(1, 1, 1)
    Frame3.BackgroundTransparency = 0.55
    Frame3.Size = UDim2.new(1, 0, 0, 3)
    Frame3.ZIndex = v6.ZIndex
    Frame3.Parent = Frame2
    endClip(Frame, true)

    local v7 = label(Frame, "Title", "", UDim2.new(1, -36, 1, -14), UDim2.new(0.5, 6, 0, 8), Color3.new(1, 1, 1), Colors.Navy, 2)

    v7.ZIndex = 4

    local UITextSizeConstraint = Instance.new("UITextSizeConstraint")

    UITextSizeConstraint.MaxTextSize = 18
    UITextSizeConstraint.Parent = v7

    local Frame4 = Instance.new("Frame")

    Frame4.Name = "ProgressFrame"
    Frame4.AnchorPoint = Vector2.new(0.5, 0)
    Frame4.Position = UDim2.new(0.5, 0, 0, 50)
    Frame4.Size = UDim2.fromOffset(300, 16)
    Frame4.BackgroundColor3 = Colors.Body
    Frame4.BorderSizePixel = 0
    Frame4.ZIndex = 2
    Frame4.Parent = BillboardGui
    MenuStyle.Bevel(Frame4, 1)

    local Frame5 = Instance.new("Frame")

    Frame5.Name = "Progress"
    Frame5.Position = UDim2.fromOffset(3, 3)
    Frame5.Size = UDim2.new(1, -6, 1, -7)
    Frame5.ZIndex = 3
    Frame5.Parent = Frame4

    local v8 = MenuStyle.Track(Frame5, v5)

    v8.ZIndex = 3

    local v9 = label(BillboardGui, "Subtitle", string.upper("Training " .. p25), UDim2.fromOffset(400, 16), UDim2.new(0.5, 0, 0, 74), Colors.Lilac, Colors.Navy, 2)
    local v10 = label(BillboardGui, "Timing", "", UDim2.fromOffset(240, 13), UDim2.new(0, 170, 0, 112), Color3.fromRGB(255, 210, 90), Colors.Navy, 2)
    local v11 = label(BillboardGui, "Rating", "", UDim2.fromOffset(260, 26), UDim2.new(0, 170, 0, 130), Color3.fromRGB(255, 150, 60), Colors.Navy, 3)

    v10.TextXAlignment = Enum.TextXAlignment.Left
    v11.TextXAlignment = Enum.TextXAlignment.Left
    v10.AnchorPoint = Vector2.new(0, 0)
    v11.AnchorPoint = Vector2.new(0, 0)
    v10.Position = UDim2.new(0.5, -196, 0, 110)
    v11.Position = UDim2.new(0.5, -196, 0, 128)

    local Frame6 = Instance.new("Frame")

    Frame6.Name = "Bar"
    Frame6.AnchorPoint = Vector2.new(0.5, 0)
    Frame6.Position = UDim2.new(0.5, 0, 0, 176)
    Frame6.Size = UDim2.fromOffset(392, 34)
    Frame6.BackgroundColor3 = Colors.Body
    Frame6.BorderSizePixel = 0
    Frame6.ZIndex = 2
    Frame6.Parent = BillboardGui
    MenuStyle.Bevel(Frame6, 2)
    endClip(Frame6, false)
    endClip(Frame6, true)

    local Frame7 = Instance.new("Frame")

    Frame7.Name = "Track"
    Frame7.Position = UDim2.fromOffset(5, 5)
    Frame7.Size = UDim2.new(1, -10, 1, -11)
    Frame7.BackgroundColor3 = v5:Lerp(Colors.Track, 0.25)
    Frame7.BorderSizePixel = 0
    Frame7.ZIndex = 3
    Frame7.Parent = Frame6

    local UIGradient = Instance.new("UIGradient")

    UIGradient.Rotation = 90
    UIGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(209, 209, 209)),
        ColorSequenceKeypoint.new(0.14, Color3.new(1, 1, 1)),
        ColorSequenceKeypoint.new(0.7, Color3.new(1, 1, 1)),
        ColorSequenceKeypoint.new(0.9, Color3.fromRGB(173, 173, 173)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(115, 115, 115))
    })
    UIGradient.Parent = Frame7

    local Frame8 = Instance.new("Frame")

    Frame8.BorderSizePixel = 0
    Frame8.BackgroundColor3 = Colors.Navy
    Frame8.BackgroundTransparency = 0.55
    Frame8.Size = UDim2.new(1, 0, 0, 2)
    Frame8.ZIndex = 3
    Frame8.Parent = Frame7

    local Frame9 = Instance.new("Frame")

    Frame9.BorderSizePixel = 0
    Frame9.BackgroundColor3 = Color3.new(1, 1, 1)
    Frame9.BackgroundTransparency = 0.6
    Frame9.Position = UDim2.fromOffset(0, 2)
    Frame9.Size = UDim2.new(1, 0, 0, 1)
    Frame9.ZIndex = 3
    Frame9.Parent = Frame7

    for _, v12 in { 0.25, 0.5, 0.75 } do
        local Frame = Instance.new("Frame")

        Frame.BorderSizePixel = 0
        Frame.BackgroundColor3 = Color3.fromRGB(18, 22, 34)
        Frame.BackgroundTransparency = v12 == 0.5 and 0 or 0.25
        Frame.AnchorPoint = Vector2.new(0.5, 0)
        Frame.Position = UDim2.fromScale(v12, 0)
        Frame.Size = UDim2.new(0, v12 == 0.5 and 3 or 2, 1, 0)
        Frame.ZIndex = 3
        Frame.Parent = Frame7

        local v13 = if v12 == 0.5 then 16 else 10
        local v14 = if v12 == 0.5 then Color3.new(1, 1, 1) else Colors.Lilac

        spike(Frame7, v12, v13, v14, true)
        spike(Frame7, v12, v13, v14, false)
    end

    local Frame10 = Instance.new("Frame")

    Frame10.Name = "HoldZone"
    Frame10.BackgroundColor3 = Color3.fromRGB(242, 238, 228)
    Frame10.AnchorPoint = Vector2.new(0, 0.5)
    Frame10.Position = UDim2.fromScale(0.3, 0.5)
    Frame10.Size = UDim2.new(0.3, 0, 1, -6)
    Frame10.Visible = false
    Frame10.ZIndex = 4
    Frame10.BorderSizePixel = 0

    local Navy = Colors.Navy
    local UIStroke = Instance.new("UIStroke")

    UIStroke.Color = Navy
    UIStroke.Thickness = 2
    UIStroke.LineJoinMode = Enum.LineJoinMode.Round
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    UIStroke.Parent = Frame10

    local TextLabel = Instance.new("TextLabel")

    TextLabel.BackgroundTransparency = 1
    TextLabel.Size = UDim2.new(1, -8, 0.62, 0)
    TextLabel.Position = UDim2.fromScale(0.5, 0.52)
    TextLabel.AnchorPoint = Vector2.new(0.5, 0.5)
    TextLabel.FontFace = Font

    if string.find(UserInputService:GetLastInputType().Name, "Gamepad", 1, true) ~= nil then
        TextLabel.Text = "HOLD A"
    elseif not UserInputService.TouchEnabled or UserInputService.MouseEnabled then
        TextLabel.Text = "HOLD LEFT CLICK"
    else
        TextLabel.Text = "HOLD"
    end

    TextLabel.TextScaled = true
    TextLabel.TextColor3 = Colors.Navy
    TextLabel.ZIndex = 5
    TextLabel.Parent = Frame10
    Frame10.Parent = Frame7

    local Frame11 = Instance.new("Frame")

    Frame11.Name = "Cursor"
    Frame11.AnchorPoint = Vector2.new(0.5, 0.5)
    Frame11.Position = UDim2.fromScale(0, 0.5)
    Frame11.Size = UDim2.new(0, 6, 1, 24)
    Frame11.BackgroundColor3 = Color3.new(1, 1, 1)
    Frame11.BorderSizePixel = 0
    Frame11.ZIndex = 6

    local Navy2 = Colors.Navy
    local UIStroke2 = Instance.new("UIStroke")

    UIStroke2.Color = Navy2
    UIStroke2.Thickness = 2
    UIStroke2.LineJoinMode = Enum.LineJoinMode.Round
    UIStroke2.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    UIStroke2.Parent = Frame11
    Frame11.Parent = Frame7

    local v15 = label(BillboardGui, "Hint", "", UDim2.fromOffset(392, 30), UDim2.new(0.5, 0, 0, 234), Colors.SoftText, Colors.Navy, 1.5)

    v15.FontFace = MenuStyle.BodyFont
    v15.TextWrapped = true

    local UITextSizeConstraint2 = Instance.new("UITextSizeConstraint")

    UITextSizeConstraint2.MaxTextSize = 14
    UITextSizeConstraint2.Parent = v15

    local Frame12 = Instance.new("Frame")

    Frame12.Name = "Popups"
    Frame12.BackgroundTransparency = 1
    Frame12.Position = UDim2.new(0.5, 76, 0, 104)
    Frame12.Size = UDim2.fromOffset(120, 72)
    Frame12.Parent = BillboardGui

    return {
        Gui = BillboardGui,
        Color = v5,
        Title = v7,
        Fill = v8,
        Subtitle = v9,
        Timing = v10,
        Rating = v11,
        Zone = Frame10,
        Cursor = Frame11,
        Popups = Frame12,
        Hint = v15
    }
end

local function popup(p26, p27) -- line: 347
    -- upvalues: TweenService (copy), label (copy), v4 (ref)
    if not v4 then
        return
    end

    local Frame = Instance.new("Frame")

    Frame.BackgroundTransparency = 1
    Frame.Size = UDim2.fromOffset(120, 52)
    Frame.Position = UDim2.fromOffset(0, 22)

    local v16 = label(Frame, "Grade", p26.Text, UDim2.fromOffset(120, 26), UDim2.new(0.5, 0, 0, 0), p26.Color, Color3.fromRGB(20, 10, 0), 2)
    local v18 = label(Frame, "Number", if p27 < 0.005 then "0" else string.format("-%.2f", p27), UDim2.fromOffset(120, 26), UDim2.new(0.5, 0, 0, 24), p26.Color, Color3.fromRGB(20, 10, 0), 2)

    Frame.Parent = v4.Popups

    local v19 = TweenInfo.new(0.9, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

    TweenService:Create(Frame, v19, {
        Position = UDim2.fromOffset(0, -18)
    }):Play()

    for _, v20 in { v16, v18 } do
        TweenService:Create(v20, v19, {
            TextTransparency = 1
        }):Play()
        TweenService:Create(v20:FindFirstChildOfClass("UIStroke"), v19, {
            Transparency = 1
        }):Play()
    end

    task.delay(0.95, function() -- line: 364
        -- upvalues: Frame (copy)
        Frame:Destroy()
    end)
end

local ScreenGui = Instance.new("ScreenGui")

ScreenGui.Name = "TrainingNotice"
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 30

local TextLabel = Instance.new("TextLabel")

TextLabel.BackgroundTransparency = 1
TextLabel.AnchorPoint = Vector2.new(0.5, 0.5)
TextLabel.Position = UDim2.fromScale(0.5, 0.72)
TextLabel.Size = UDim2.fromOffset(600, 34)
TextLabel.FontFace = Font
TextLabel.TextScaled = true
TextLabel.TextColor3 = Color3.new(1, 1, 1)
TextLabel.TextTransparency = 1
TextLabel.Size = UDim2.fromOffset(600, 20)

if workspace.CurrentCamera.ViewportSize.Y < 500 then
    TextLabel.Size = UDim2.new(0.86, 0, 0, 34)
    TextLabel.Position = UDim2.fromScale(0.5, 0.6)
    TextLabel.TextWrapped = true

    local UITextSizeConstraint = Instance.new("UITextSizeConstraint")

    UITextSizeConstraint.MaxTextSize = 14
    UITextSizeConstraint.Parent = TextLabel
end

local Navy = Colors.Navy
local UIStroke = Instance.new("UIStroke")

UIStroke.Color = Navy
UIStroke.Thickness = 2
UIStroke.LineJoinMode = Enum.LineJoinMode.Round
UIStroke.Parent = TextLabel
UIStroke.Transparency = 1
TextLabel.Parent = ScreenGui
ScreenGui.Parent = PlayerGui

local function notice(p28) -- line: 398
    -- upvalues: TweenService (copy), TextLabel (copy), UIStroke (copy)
    TextLabel.Text = p28
    TextLabel.TextTransparency = 0
    UIStroke.Transparency = 0

    local v21 = TweenInfo.new(1.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In, 0, false, 1.2)

    TweenService:Create(TextLabel, v21, {
        TextTransparency = 1
    }):Play()
    TweenService:Create(UIStroke, v21, {
        Transparency = 1
    }):Play()
end

local t3

local function subValue() -- line: 412
    -- upvalues: BoxingConfig (copy), LocalPlayer (copy), t3 (ref)
    if t3 then
        return LocalPlayer:GetAttribute("Stat_" .. t3.Stat .. "_" .. (if t3.Sub == 1 then "A" else "B")) or BoxingConfig.Stats.StartValue
    end

    return 0
end

local function refreshHeader() -- line: 419
    -- upvalues: BoxingConfig (copy), LocalPlayer (copy), MenuStyle (copy), v4 (ref), t3 (ref)
    if not (t3 and v4) then
        return
    end

    local Attribute = if t3 then LocalPlayer:GetAttribute("Stat_" .. t3.Stat .. "_" .. (if t3.Sub == 1 then "A" else "B")) or BoxingConfig.Stats.StartValue else 0

    v4.Title.Text = string.format("<font color=\"%s\">%s</font>  %.4f / %d", MenuStyle.Hex.Lilac, string.upper(t3.Stat), Attribute, BoxingConfig.Stats.SubMax)
    v4.Fill.Size = UDim2.fromScale(math.clamp(Attribute / BoxingConfig.Stats.SubMax, 0, 1), 1)
end

local function averageQuality() -- line: 428
    -- upvalues: t3 (ref)
    local t4 = t3

    if not t4 or #t3.Recent == 0 then
        return 0
    end

    local n1 = 0

    for _, v25 in t3.Recent do
        n1 += v25
    end

    return n1 / #t3.Recent
end

local function gradeFor(p29) -- line: 441
    -- upvalues: Training (copy)
    for _, v26 in Training.Grades do
        if p29 <= v26.Max then
            return v26
        end
    end

    return Training.Grades[#Training.Grades]
end

local function ratingFor(p30) -- line: 450
    -- upvalues: Training (copy)
    for _, v27 in Training.Ratings do
        if v27.Min <= p30 then
            return v27
        end
    end

    return Training.Ratings[#Training.Ratings]
end

local function timingText(p31, p32) -- line: 459
    if p32 then
        return "Timing: Missed"
    end

    local v28 = math.abs(p31)

    if v28 < 0.03 then
        return "Timing: Perfect"
    end

    local v29 = if p31 < 0 then "Early" else "Late"

    if v28 > 0.15 then
        return "Timing: Very " .. v29
    end

    if v28 < 0.08 then
        return "Timing: Slightly " .. v29
    end

    return "Timing: " .. v29
end

local Sound = Instance.new("Sound")

Sound.Name = "TrainingTick"
Sound.SoundId = Training.TickSound or ""
Sound.Volume = Training.TickVolume or 4
Sound.Parent = SoundService

local clone = Sound:Clone()

clone.Name = "TrainingReleaseTick"
clone.PlaybackSpeed = Training.ReleaseTickSpeed or 1.5
clone.Parent = SoundService
task.defer(function() -- line: 486
    -- upvalues: SoundService (copy), Sound (copy), clone (copy)
    Sound.SoundGroup = SoundService:FindFirstChild("BoxingUI")
    clone.SoundGroup = Sound.SoundGroup
end)

local function tick(p33) -- line: 490
    -- upvalues: Sound (copy), clone (copy)
    local v30 = if p33 then clone else Sound

    if v30.SoundId ~= "" then
        v30.TimePosition = 0
        v30:Play()
    end
end

local t5 = {}

local function nearestBagStation(p34) -- line: 504
    local HumanoidRootPart = p34 and p34:FindFirstChild("HumanoidRootPart")

    if not HumanoidRootPart then
        return nil
    end

    local n2 = 12
    local child

    for _, child2 in workspace:GetChildren() do
        local v31 = child2.Name == "Speed bag" and child2:FindFirstChild("CF")

        if v31 then
            local Magnitude = (v31.Position - HumanoidRootPart.Position).Magnitude

            if Magnitude < n2 then
                n2 = Magnitude
                child = child2
            end
        end
    end

    return child
end

local function setupBag(p35) -- line: 521
    local Sandbag = p35 and p35:FindFirstChild("Sandbag")
    local PhysicsPart = Sandbag and Sandbag:FindFirstChild("PhysicsPart")
    local CF = p35 and p35:FindFirstChild("CF")

    if not (PhysicsPart and CF) then
        return nil
    end

    local Attachment = PhysicsPart:FindFirstChild("Attachment")
    local v32 = if Attachment then Attachment.WorldPosition else PhysicsPart.Position + Vector3.new(0, PhysicsPart.Size.Y / 2, 0)
    local v34 = CF.CFrame.LookVector * Vector3.new(1, 0, 1)
    local v35 = if v34.Magnitude > 0.01 then v34.Unit else Vector3.new(0, 0, -1)
    local t6 = {}

    for _, descendant in Sandbag:GetDescendants() do
        if descendant:IsA("BasePart") then
            t6[descendant] = CFrame.new(v32):ToObjectSpace(descendant.CFrame)
        end
    end

    return {
        Angle = 0,
        Speed = 0,
        Pivot = v32,
        Axis = v35:Cross((Vector3.new(0, 1, 0))),
        Parts = t6,
        Part = PhysicsPart
    }
end

local v36 = BoxingConfig.SpeedBagRhythm or {}
local TweenService2 = game:GetService("TweenService")
local t7 = {}
local n3 = 1
local n4 = (-1e999)

local function voice(p36, p37) -- line: 552
    -- upvalues: t7 (copy), v36 (copy)
    local v37 = t7[p36]

    if not (v37 and v37.Sound.Parent) then
        local Sound = Instance.new("Sound")

        Sound.Name = "SpeedBagRattle" .. p36
        Sound.SoundId = v36.Sound
        Sound.RollOffMaxDistance = 60
        Sound.RollOffMinDistance = 6
        Sound.Parent = p37
        v37 = {
            Sound = Sound
        }
        t7[p36] = v37
    end

    if v37.Sound.Parent ~= p37 then
        v37.Sound.Parent = p37
    end

    return v37
end

local function fadeVoice(p38, p39, p40) -- line: 569
    -- upvalues: TweenService2 (copy)
    if p38.Tween then
        p38.Tween:Cancel()
    end

    p38.Tween = TweenService2:Create(p38.Sound, TweenInfo.new(p39, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Volume = p40
    })
    p38.Tween:Play()
end

local function bagStrike(p41, p42, p43) -- line: 577
    -- upvalues: TweenService2 (copy), t7 (copy), n3 (ref), n4 (ref), voice (copy), v36 (copy), fadeVoice (copy)
    if v36.Sound then
        local elapsed = os.clock()

        if not (elapsed - n4 < (v36.MinGap or 0.06)) and p43 and p43.Parent then
            n4 = elapsed

            local v38 = v36.Voices or 3
            local v41 = (v36.Volume or 1) * math.clamp(0.45 + 0.55 * p41, 0.3, 1)

            for i = 1, v38 do
                local v42 = t7[i]

                if v42 and v42.Sound.IsPlaying and i ~= n3 then
                    fadeVoice(v42, v36.Crossfade or 0.12, v42.Sound.Volume * (v36.Duck or 0.55))
                end
            end

            local v43 = voice(n3, p43)

            local function start() -- line: 599
                -- upvalues: p42 (copy), v41 (copy), v43 (copy)
                if v43.Tween then
                    v43.Tween:Cancel()
                end

                v43.Sound.PlaybackSpeed = (p42 or 1) * (0.97 + math.random() * 0.06)
                v43.Sound.TimePosition = 0
                v43.Sound.Volume = v41
                v43.Sound:Play()
            end

            if v43.Sound.IsPlaying then
                local clone = v43.Sound:Clone()

                clone.Parent = p43
                clone.TimePosition = v43.Sound.TimePosition
                clone:Play()
                v43.Sound:Stop()
                TweenService2:Create(clone, TweenInfo.new(v36.Crossfade or 0.12), {
                    Volume = 0
                }):Play()
                task.delay((v36.Crossfade or 0.12) + 0.05, function() -- line: 616
                    -- upvalues: clone (copy)
                    clone:Destroy()
                end)
            end

            if v43.Tween then
                v43.Tween:Cancel()
            end

            v43.Sound.PlaybackSpeed = (p42 or 1) * (0.97 + math.random() * 0.06)
            v43.Sound.TimePosition = 0
            v43.Sound.Volume = v41
            v43.Sound:Play()
            n3 = n3 % v38 + 1
        end
    end
end

local n5 = 1

local function v44(p44, p45, _) -- line: 628
    -- upvalues: LocalPlayer (copy), t5 (copy), nearestBagStation (copy), setupBag (copy), bagStrike (copy), n5 (ref)
    local v45 = nearestBagStation(p45 or LocalPlayer.Character)

    if not v45 then
        return
    end

    local v46 = t5[v45] or setupBag(v45)

    t5[v45] = v46

    if v46 then
        v46.Speed += 12 * p44
        bagStrike(math.clamp(p44, 0, 1), n5, v46.Part)
    end
end

local function stepOneBag(p47, p48) -- line: 641
    -- upvalues: v36 (copy), bagStrike (copy), n5 (ref)
    local v47 = math.abs(p47.Angle) < 0.001
    local v48 = if v47 then math.abs(p47.Speed) < 0.001 else nil

    if v47 and v48 then
        return
    end

    local v49 = math.min(p48, 0.03333333333333333)

    p47.Speed += (-70 * p47.Angle - 5 * p47.Speed) * v49
    p47.Angle += p47.Speed * v49

    local n6 = 0

    if p47.Angle > 1.25 then
        n6 = math.abs(p47.Speed)

        local v50 = -math.abs(p47.Speed) * 0.6

        p47.Angle = 1.25
        p47.Speed = v50
    elseif p47.Angle < -0.9 then
        n6 = math.abs(p47.Speed)

        local v51 = math.abs(p47.Speed) * 0.6

        p47.Angle = -0.9
        p47.Speed = v51
    end

    if (v36.ReboundMinSpeed or 4) < n6 then
        bagStrike(math.clamp(n6 / 14, 0, 0.8), n5, p47.Part)
    end

    local v53 = CFrame.new(p47.Pivot) * CFrame.fromAxisAngle(p47.Axis, p47.Angle)

    for v54, v55 in p47.Parts do
        if v54.Parent then
            v54.CFrame = v53 * v55
        end
    end
end

local function stepSpeedBag(p49) -- line: 667
    -- upvalues: t5 (copy), stepOneBag (copy)
    for _, v56 in t5 do
        stepOneBag(v56, p49)
    end
end

local t8 = {}

local function watchOtherBagHits() -- line: 674
    -- upvalues: Players (copy), BoxingVisuals (copy), LocalPlayer (copy), v44 (copy), t8 (copy)
    for _, player in Players:GetPlayers() do
        local Character = player.Character

        if player ~= LocalPlayer and Character then
            local v57 = Character:GetAttribute("SpeedBagHits") or 0

            if (t8[player] or 0) < v57 then
                task.delay(BoxingVisuals.SpeedBagContactDelay or 0.23, function() -- line: 680
                    -- upvalues: Character (copy), v44 (copy)
                    v44(1, Character, true)
                end)
            end

            t8[player] = v57
        end
    end
end

local function dropMarker(p50, _) -- line: 690
    -- upvalues: Colors (copy), v4 (ref)
    if not v4 then
        return nil
    end

    local Frame = Instance.new("Frame")

    Frame.Name = "Marker"
    Frame.AnchorPoint = Vector2.new(0.5, 0.5)
    Frame.Position = UDim2.fromScale(p50, 0.5)
    Frame.Size = UDim2.new(0, 10, 1, 24)
    Frame.BackgroundColor3 = Colors.Navy
    Frame.BackgroundTransparency = 0.15
    Frame.BorderSizePixel = 0
    Frame.ZIndex = 5
    Frame.Parent = v4.Cursor.Parent

    return Frame
end

local function fadeMarker(p52) -- line: 707
    -- upvalues: TweenService (copy)
    if not p52 then
        return
    end

    TweenService:Create(p52, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 26, 1, 50)
    }):Play()
    task.delay(0.45, function() -- line: 713
        -- upvalues: p52 (copy)
        p52:Destroy()
    end)
end

local function serverNow() -- line: 720
    return workspace:GetServerTimeNow()
end

local function currentRep() -- line: 725
    -- upvalues: t3 (ref)
    if not t3 then
        return nil
    end

    local ServerTimeNow = workspace:GetServerTimeNow()
    local v59

    for _, v60 in t3.Reps do
        if v60.Start <= ServerTimeNow and (not v59 or v60.Start > v59.Start) then
            v59 = v60
        end
    end

    return v59
end

local function barPos(p53, p54) -- line: 740
    local v62 = math.clamp((p54 - p53.Start) / p53.Duration, 0, 1)

    return if p53.Dir == -1 then 1 - v62 else v62, v62
end

local function cursorPos() -- line: 745
    -- upvalues: t3 (ref), currentRep (copy)
    local v63 = currentRep()

    if v63 then
        local v65 = math.clamp((workspace:GetServerTimeNow() - v63.Start) / v63.Duration, 0, 1)

        if v63.Dir == -1 then
            return 1 - v65
        end

        return v65
    end

    if not t3 or t3.FirstDir ~= -1 then
        return 0
    end

    return 1
end

local function showRep(p55) -- line: 754
    -- upvalues: v4 (ref), t3 (ref)
    if not (t3 and v4) then
        return
    end

    if p55.Hold then
        v4.Zone.Position = UDim2.fromScale(p55.ZoneStart, 0.5)
        v4.Zone.Size = UDim2.new(p55.ZoneEnd - p55.ZoneStart, 0, 1, -6)
    end

    v4.Zone.Visible = p55.Hold == true

    if not t3.Track or t3.Cycle then
        return
    end

    t3.Track:AdjustSpeed((math.clamp(t3.AnimLength / p55.Duration, 0.4, 4)))
end

local function showResult(p56) -- line: 769
    -- upvalues: Training (copy), v4 (ref), popup (copy), t3 (ref)
    if t3 and v4 then
        local v68 = math.clamp(tonumber(p56.Error) or 1, 0, 1)

        table.insert(t3.Recent, (math.clamp(1 - v68 / 0.35, 0, 1)))

        if #t3.Recent > 6 then
            table.remove(t3.Recent, 1)
        end

        local t9 = t3
        local v71

        if not t9 or #t3.Recent == 0 then
            v71 = 0
        else
            local n7 = 0

            for _, v72 in t3.Recent do
                n7 += v72
            end

            v71 = n7 / #t3.Recent
        end

        local v73 = false
        local v74

        for _, v75 in Training.Ratings do
            if v75.Min <= v71 then
                v74 = v75
                v73 = true
                break
            end
        end

        if not v73 then
            v74 = Training.Ratings[#Training.Ratings]
        end

        v4.Rating.Text = v74.Text
        v4.Rating.TextColor3 = v74.Color

        local Timing = v4.Timing
        local v76 = tonumber(p56.Signed) or 0

        if p56.Missed == true then
            Timing.Text = "Timing: Missed"
        else
            local v77 = math.abs(v76)

            if v77 < 0.03 then
                Timing.Text = "Timing: Perfect"
            else
                local v78 = if v76 < 0 then "Early" else "Late"

                if v77 > 0.15 then
                    Timing.Text = "Timing: Very " .. v78
                elseif v77 < 0.08 then
                    Timing.Text = "Timing: Slightly " .. v78
                else
                    Timing.Text = "Timing: " .. v78
                end
            end
        end

        local v79 = false
        local v80

        for _, v81 in Training.Grades do
            if v68 <= v81.Max then
                v80 = v81
                v79 = true
                break
            end
        end

        if not v79 then
            v80 = Training.Grades[#Training.Grades]
        end

        popup(v80, v68)

        if t3.Beat then
            v4.Timing.Text = (if p56.Missed then "Missed The Beat" else v4.Timing.Text) .. "   |   Combo x" .. (tonumber(p56.Combo) or 0)
        end
    end
end

local v83

local function press() -- line: 790
    -- upvalues: BoxingRemote (copy), t3 (ref), Sound (copy), dropMarker (copy), fadeMarker (copy), serverNow (copy), currentRep (copy), v83 (ref)
    local v84 = currentRep()
    local v85

    if not v84 or v84.Pressed or workspace:GetServerTimeNow() > v84.Start + v84.Duration then
        return
    else
        v84.Pressed = true

        local v87 = currentRep()

        if v87 then
            v85 = math.clamp((workspace:GetServerTimeNow() - v87.Start) / v87.Duration, 0, 1)

            if v87.Dir == -1 then
                v85 = 1 - v85
            end
        else
            v85 = if t3 and t3.FirstDir == -1 then 1 else 0
        end
    end

    if Sound.SoundId ~= "" then
        Sound.TimePosition = 0
        Sound:Play()
    end

    BoxingRemote:FireServer("TrainPress", v84.Id, serverNow())

    if v84.Hold then
        v83 = v84
        v84.Marker = dropMarker(v85, true)
    else
        fadeMarker((dropMarker(v85, false)))
    end
end

local function release() -- line: 807
    -- upvalues: BoxingRemote (copy), t3 (ref), clone (copy), dropMarker (copy), fadeMarker (copy), serverNow (copy), currentRep (copy), v83 (ref)
    local v89 = v83

    v83 = nil

    local v90

    if not v89 or v89.Released then
        return
    else
        v89.Released = true

        if workspace:GetServerTimeNow() >= v89.Start + v89.Duration then
            v90 = 1
        else
            local v92 = currentRep()

            if v92 then
                v90 = math.clamp((workspace:GetServerTimeNow() - v92.Start) / v92.Duration, 0, 1)

                if v92.Dir == -1 then
                    v90 = 1 - v90
                end
            else
                v90 = if t3 and t3.FirstDir == -1 then 1 else 0
            end
        end
    end

    if clone.SoundId ~= "" then
        clone.TimePosition = 0
        clone:Play()
    end

    BoxingRemote:FireServer("TrainRelease", v89.Id, serverNow())

    local Marker = v89.Marker
    local v94 = dropMarker(v90, true)

    v89.Marker = nil
    task.delay(0.3, function() -- line: 819
        -- upvalues: Marker (copy), v94 (copy), fadeMarker (copy)
        fadeMarker(Marker)
        fadeMarker(v94)
    end)
end

local ContextActionService = game:GetService("ContextActionService")
local t10 = {
    Enum.KeyCode.ButtonA,
    Enum.KeyCode.ButtonX,
    Enum.KeyCode.ButtonY,
    Enum.KeyCode.ButtonR2
}
local t11 = {
    Enum.KeyCode.ButtonL1,
    Enum.KeyCode.ButtonR1,
    Enum.KeyCode.ButtonL2
}
local v95 = Enum.ContextActionPriority.High.Value + 100
local v96 = false

local function onPadPress(_, p58) -- line: 834
    -- upvalues: t3 (ref), press (copy), release (copy)
    if not t3 then
        return Enum.ContextActionResult.Pass
    end

    if p58 == Enum.UserInputState.Begin then
        press()
    elseif p58 == Enum.UserInputState.End or p58 == Enum.UserInputState.Cancel then
        release()
    end

    return Enum.ContextActionResult.Sink
end

local function onPadQuiet() -- line: 845
    -- upvalues: t3 (ref)
    if t3 then
        return Enum.ContextActionResult.Sink
    end

    return Enum.ContextActionResult.Pass
end

local function bindPad(p59) -- line: 848
    -- upvalues: ContextActionService (copy), t10 (copy), t11 (copy), v95 (copy), v96 (ref), onPadPress (copy), onPadQuiet (copy)
    if p59 ~= v96 then
        v96 = p59

        if p59 then
            ContextActionService:BindActionAtPriority("TrainingPadPress", onPadPress, false, v95, table.unpack(t10))
            ContextActionService:BindActionAtPriority("TrainingPadQuiet", onPadQuiet, false, v95, table.unpack(t11))
        else
            ContextActionService:UnbindAction("TrainingPadPress")
            ContextActionService:UnbindAction("TrainingPadQuiet")
        end
    end
end

local v97 = BoxingConfig.SpeedBagAnimations or {}

local function syncCycle(p60) -- line: 865
    -- upvalues: t3 (ref), v97 (copy)
    local v98 = t3 and t3.Cycle

    if not (v98 and p60 and v98.Length > 0) then
        return
    end

    local v99 = v97.CycleLength or v98.Length
    local v100 = v99 / 2
    local v101 = v97.CycleContacts or { 0.2, 0.475 }
    local v103 = math.clamp((workspace:GetServerTimeNow() - p60.Start) / p60.Duration, 0, 1)

    if p60.Dir == -1 then
        local _ = 1 - v103
    end

    local v104 = (v101[if p60.Id % 2 == 1 then 1 else 2] + (v103 - 0.5) * v100) % v99
    local v106 = math.clamp(v100 / p60.Duration, 0.2, 4)

    if math.abs(v98.Speed - v106) > 0.01 then
        v98:AdjustSpeed(v106)
    end

    local v109 = math.abs(v98.TimePosition - v104)

    if math.min(v109, v99 - v109) > 0.03 then
        v98.TimePosition = v104
    end
end

local function animator() -- line: 889
    -- upvalues: LocalPlayer (copy)
    local Character = LocalPlayer.Character
    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

    return Humanoid and Humanoid:FindFirstChildOfClass("Animator")
end

local function loadTrack(p61, p62, p63) -- line: 895
    -- upvalues: LocalPlayer (copy)
    local Character = LocalPlayer.Character
    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
    local Animator = Humanoid and Humanoid:FindFirstChildOfClass("Animator")

    if not Animator or not p61 or p61 == "" then
        return nil
    end

    local Animation = Instance.new("Animation")

    Animation.AnimationId = p61

    local LoadAnimation = Animator.LoadAnimation
    local ok, result = pcall(LoadAnimation, Animator, Animation)

    if not ok then
        return nil
    end

    result.Priority = p62
    result.Looped = p63

    return result
end

local function endSession(p64) -- line: 913
    -- upvalues: BoxingCamera (copy), v4 (ref), notice (copy), t3 (ref), v83 (ref), ContextActionService (copy), v96 (ref)
    if not t3 then
        return
    end

    local t12 = t3

    t3 = nil
    v83 = nil

    if v96 ~= false then
        v96 = false
        ContextActionService:UnbindAction("TrainingPadPress")
        ContextActionService:UnbindAction("TrainingPadQuiet")
    end

    if t12.Track then
        t12.Track:Stop(0.25)
    end

    if t12.Cycle then
        t12.Cycle:Stop(0.25)
    end

    if v4 then
        v4.Gui:Destroy()
        v4 = nil
    end

    BoxingCamera.SetSuspended(false, "TrainingController")
    require(game:GetService("ReplicatedStorage").Boxing.BackpackLock).Unlock("Training")

    if p64 then
        notice(p64)
    end
end

local function startSession(p65) -- line: 938
    -- upvalues: UserInputService (copy), BoxingCamera (copy), LocalPlayer (copy), PlayerGui (copy), MenuStyle (copy), v4 (ref), buildUi (copy), t3 (ref), refreshHeader (copy), v36 (copy), ContextActionService (copy), t10 (copy), t11 (copy), v95 (copy), v96 (ref), onPadPress (copy), onPadQuiet (copy), v97 (copy), endSession (copy)
    endSession(nil)

    local Character = LocalPlayer.Character
    local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")

    if not HumanoidRootPart then
        return
    end

    t3 = {
        FirstDir = 1,
        Station = p65.Station,
        Stat = p65.Stat,
        Sub = p65.Sub,
        SubName = p65.SubName,
        Recent = {},
        Mode = p65.Mode or "Tap",
        Procedural = p65.Procedural,
        SweepScale = p65.SweepScale or 1,
        NeedsGloves = p65.NeedsGloves,
        Reps = {}
    }
    v4 = buildUi(p65.Stat, p65.SubName)
    v4.Gui.Adornee = HumanoidRootPart
    v4.Gui.Parent = PlayerGui
    v4.Rating.Text = "GET READY"
    v4.Rating.TextColor3 = Color3.new(1, 1, 1)
    v4.Timing.Text = string.format("PRESS <font color=\"%s\">%s</font> TO STOP", MenuStyle.Hex.White, string.find(UserInputService:GetLastInputType().Name, "Gamepad", 1, true) ~= nil and "B" or "E")

    if v96 ~= true then
        v96 = true
        ContextActionService:BindActionAtPriority("TrainingPadPress", onPadPress, false, v95, table.unpack(t10))
        ContextActionService:BindActionAtPriority("TrainingPadQuiet", onPadQuiet, false, v95, table.unpack(t11))
    end

    v4.Hint.Text = t3.Mode == "Hold" and "Hint: Hold Left Click When The Indicator Enters The White Bar And Let Go When It Leaves" or "Hint: Time Left Clicks When The Indicator Is In The Middle Of The Timing Bar"

    if t3.Mode ~= "Hold" then
        v4.Hint.Text = "Hint: The Indicator Bounces Back And Forth - Left Click Every Time It Crosses The Middle Of The Timing Bar"
    end

    local t13, Cycle, Action4, Humanoid

    if p65.Procedural == "SpeedBag" and v36.BeatTime then
        t3.Beat = true
        v4.Hint.Text = "Hint: The Bag Swings On Its Own - Punch (Left Click) Every Time It Bounces Back (The Indicator Crosses The Middle). Keep The Rhythm Going!"

        if v97.Cycle and v97.Cycle ~= "" then
            t13 = t3
            Cycle = v97.Cycle
            Action4 = Enum.AnimationPriority.Action4

            local Character = LocalPlayer.Character

            Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

            local Animator = Humanoid and Humanoid:FindFirstChildOfClass("Animator")
            local result

            if Animator and Cycle and Cycle ~= "" then
                local Animation = Instance.new("Animation")

                Animation.AnimationId = Cycle

                local LoadAnimation = Animator.LoadAnimation
                local ok

                ok, result = pcall(LoadAnimation, Animator, Animation)

                if ok then
                    result.Priority = Action4
                    result.Looped = true
                else
                    result = nil
                end
            end

            t13.Cycle = result

            if t3.Cycle then
                t3.Cycle:Play(0.2)
            end
        end
    end

    if string.find(UserInputService:GetLastInputType().Name, "Gamepad", 1, true) ~= nil then
        v4.Hint.Text = string.gsub(string.gsub(v4.Hint.Text, "Left Clicks", "A Presses"), "Left Click", "A")
    end

    refreshHeader()

    if not t3.NeedsGloves then
        require(game:GetService("ReplicatedStorage").Boxing.BackpackLock).Lock("Training")
    end

    BoxingCamera.SetSuspended(true, "TrainingController")

    local t14, Animation, Action4_2, Humanoid2, v111

    if p65.Procedural then
        v111 = true
    elseif p65.Animation then
        t14 = t3
        Animation = p65.Animation
        Action4_2 = Enum.AnimationPriority.Action4

        local Character = LocalPlayer.Character

        Humanoid2 = Character and Character:FindFirstChildOfClass("Humanoid")
        v111 = false
    else
        v111 = true
    end

    if v111 then
        return
    end

    local Animator = Humanoid2 and Humanoid2:FindFirstChildOfClass("Animator")
    local result

    if Animator and Animation and Animation ~= "" then
        local Animation2 = Instance.new("Animation")

        Animation2.AnimationId = Animation

        local LoadAnimation = Animator.LoadAnimation
        local ok

        ok, result = pcall(LoadAnimation, Animator, Animation2)

        if ok then
            result.Priority = Action4_2
            result.Looped = true
        else
            result = nil
        end
    end

    t14.Track = result

    if t3.Track then
        t3.Track:Play(0.2)
        t3.AnimLength = 2
        task.spawn(function() -- line: 997
            -- upvalues: p65 (copy), t3 (ref)
            local v112 = t3 and t3.Track

            while v112 and v112.Length <= 0 and t3 and t3.Track == v112 do
                task.wait()
            end

            if v112 and t3 and t3.Track == v112 then
                local t15 = t3

                if p65.Station == "JumpRope" then
                    t15.AnimLength = v112.Length * 3
                else
                    t15.AnimLength = v112.Length
                end
            end
        end)
    end
end

local function placeBarbells() -- line: 1012
    -- upvalues: Players (copy)
    for _, player in Players:GetPlayers() do
        local Character = player.Character
        local TrainingBarbell = Character and Character:FindFirstChild("TrainingBarbell")
        local v113, v114, v115

        if TrainingBarbell then
            v113 = Character:FindFirstChild("Right Arm")
            v114 = Character:FindFirstChild("Left Arm")
            v115 = Character:FindFirstChild("Torso")
        else
            v115 = TrainingBarbell
            v113 = TrainingBarbell
            v114 = TrainingBarbell
        end

        if v113 and v114 and v115 then
            local v117 = v113.CFrame * Vector3.new(0, -v113.Size.Y / 2 + 0.2, 0)
            local v119 = v114.CFrame * Vector3.new(0, -v114.Size.Y / 2 + 0.2, 0)
            local v120 = v117 - v119

            if v120.Magnitude > 0.05 then
                local Unit = v120.Unit
                local v121 = Unit:Cross(v115.CFrame.UpVector)

                if v121.Magnitude < 0.05 then
                    v121 = Unit:Cross(v115.CFrame.LookVector)
                end

                local Unit2 = v121.Unit

                TrainingBarbell.CFrame = CFrame.fromMatrix((v117 + v119) / 2, Unit, Unit2:Cross(Unit), Unit2)
            end
        end
    end
end

local function shapeJumpRopes() -- line: 1040
    -- upvalues: Players (copy)
    for _, player in Players:GetPlayers() do
        local Character = player.Character
        local TrainingJumpRope = Character and Character:FindFirstChild("TrainingJumpRope")
        local v122, v123

        if TrainingJumpRope then
            v122 = Character:FindFirstChild("HumanoidRootPart")
            v123 = TrainingJumpRope:FindFirstChild("MiddlePart")
        else
            v123 = TrainingJumpRope
            v122 = TrainingJumpRope
        end

        if v122 and v123 then
            local _CFrame = v122.CFrame
            local v124 = _CFrame:PointToObjectSpace(v123.Position)
            local n8 = 0

            for _, v125 in {
                    { "HandleL", "AttL", "BL" },
                    { "HandleR", "AttR", "BR" }
                } do
                local v126 = TrainingJumpRope:FindFirstChild(v125[1])
                local v127 = v126 and v126:FindFirstChild(v125[2])

                if v127 then
                    local v129 = v126.CFrame * Vector3.new(0, -v126.Size.Y / 2, 0)
                    local X = _CFrame:PointToObjectSpace(v129).X
                    local v130 = if X >= 0 then 1 else -1
                    local v131 = X * 1.55

                    n8 = math.max(n8, (math.abs(v131)))

                    local v133 = _CFrame * Vector3.new(v131, v124.Y, v124.Z) - v129

                    if v133.Magnitude > 0.05 then
                        local v134 = _CFrame.RightVector * v130
                        local Unit = (v133.Unit + v134 * 0.7).Unit
                        local Unit2 = Unit:Cross(if math.abs((Unit:Dot(_CFrame.UpVector))) > 0.95 then _CFrame.LookVector else _CFrame.UpVector).Unit

                        v127.WorldCFrame = CFrame.fromMatrix(v129, Unit, Unit2:Cross(Unit), Unit2)

                        local v136 = TrainingJumpRope:FindFirstChild(v125[3])

                        if v136 then
                            v136.CurveSize0 = v133.Magnitude * 0.65
                        end
                    end
                end
            end

            for _, v137 in { "BL", "BR" } do
                local v138 = TrainingJumpRope:FindFirstChild(v137)

                if v138 then
                    v138.CurveSize1 = n8 * 1.2
                end
            end
        end
    end
end

RunService.RenderStepped:Connect(function(p66) -- line: 1086
    -- upvalues: v4 (ref), t3 (ref), t5 (copy), n5 (ref), v44 (copy), stepOneBag (copy), watchOtherBagHits (copy), fadeMarker (copy), currentRep (copy), showRep (copy), v83 (ref), release (copy), syncCycle (copy), placeBarbells (copy), shapeJumpRopes (copy)
    watchOtherBagHits()

    for _, v139 in t5 do
        stepOneBag(v139, p66)
    end

    placeBarbells()
    shapeJumpRopes()

    if t3 and v4 then
        local v140 = currentRep()

        if v140 then
            if t3.ShownId ~= v140.Id then
                local v141 = t3.Reps[t3.ShownId or -1]

                if v141 and v141.Marker and v141 ~= v83 then
                    fadeMarker(v141.Marker)
                    v141.Marker = nil
                end

                t3.ShownId = v140.Id
                showRep(v140)
            end

            local v143 = math.clamp((workspace:GetServerTimeNow() - v140.Start) / v140.Duration, 0, 1)
            local v144 = if v140.Dir == -1 then 1 - v143 else v143

            v4.Cursor.Position = UDim2.fromScale(v144, 0.5)

            if v140.Bounce then
                syncCycle(v140)

                if not v140.Bounced and v143 >= 0.5 then
                    v140.Bounced = true
                    n5 = 0.98 + (0.62 / v140.Duration - 1) * 0.08
                    v44(0.75)
                end
            end

            if v83 and workspace:GetServerTimeNow() > v83.Start + v83.Duration + 0.05 then
                release()
            end
        else
            local Cursor = v4.Cursor
            local fromScale = UDim2.fromScale
            local v145 = currentRep()
            local v146

            if v145 then
                v146 = math.clamp((workspace:GetServerTimeNow() - v145.Start) / v145.Duration, 0, 1)

                if v145.Dir == -1 then
                    v146 = 1 - v146
                end
            else
                v146 = if not t3 or t3.FirstDir ~= -1 then 0 else 1
            end

            Cursor.Position = fromScale(v146, 0.5)
        end
    end
end)
UserInputService.InputBegan:Connect(function(p67, p68) -- line: 1126
    -- upvalues: UserInputService (copy), BoxingRemote (copy), t3 (ref), press (copy)
    if t3 then
        if (p67.KeyCode == Enum.KeyCode.E or p67.KeyCode == Enum.KeyCode.ButtonB) and not UserInputService:GetFocusedTextBox() then
            BoxingRemote:FireServer("TrainStop")
        elseif not p68 and (p67.UserInputType == Enum.UserInputType.MouseButton1 or p67.UserInputType == Enum.UserInputType.Touch) then
            press()
        end
    end
end)
UserInputService.InputEnded:Connect(function(p69) -- line: 1144
    -- upvalues: t3 (ref), release (copy)
    if t3 and (p69.UserInputType == Enum.UserInputType.MouseButton1 or p69.UserInputType == Enum.UserInputType.Touch) then
        release()
    end
end)
BoxingRemote.OnClientEvent:Connect(function(p70, p71) -- line: 1153
    -- upvalues: notice (copy), t3 (ref), refreshHeader (copy), showResult (copy), endSession (copy), startSession (copy)
    if p70 == "TrainStart" and type(p71) == "table" then
        startSession(p71)
    elseif p70 == "TrainSweep" and type(p71) == "table" then
        if t3 and type(p71.Id) == "number" then
            if p71.Id == 1 then
                t3.FirstDir = p71.Dir or 1
            end

            t3.Reps[p71.Id] = p71
            t3.Reps[p71.Id - 5] = nil
        end
    elseif p70 == "TrainResult" and type(p71) == "table" then
        refreshHeader()
        showResult(p71)
    elseif p70 == "TrainEnd" then
        endSession(p71)
    elseif p70 == "TrainNotice" and type(p71) == "string" then
        notice(p71)
    end
end)
LocalPlayer.CharacterAdded:Connect(function() -- line: 1174
    -- upvalues: endSession (copy)
    endSession(nil)
end)
