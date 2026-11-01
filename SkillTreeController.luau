-- https://lua.expert

local ContextActionService = game:GetService("ContextActionService")
local Debris = game:GetService("Debris")
local GuiService = game:GetService("GuiService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")

game:GetService("StarterGui")

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Boxing = ReplicatedStorage:WaitForChild("Boxing")
local BoxingConfig = require(Boxing:WaitForChild("BoxingConfig"))
local BoxingSkills = require(Boxing:WaitForChild("BoxingSkills"))
local BoxingCamera = require(Boxing:WaitForChild("BoxingCamera"))
local SkillRemote = Boxing:WaitForChild("SkillRemote")
local Stats = BoxingConfig.Stats
local CurrentCamera = workspace.CurrentCamera

local function watch(p1) -- line: 35
    local v1 = p1:WaitForChild("Humanoid", 10)
    local v2 = p1:WaitForChild("HumanoidRootPart", 10)

    if not v1 or not v2 then
        return
    end

    local function apply() -- line: 41
        -- upvalues: v1 (copy), v2 (copy)
        local Anchored = v2.Anchored

        v1:SetStateEnabled(Enum.HumanoidStateType.Freefall, not Anchored)

        if not Anchored then
            return
        end

        if v1:GetState() == Enum.HumanoidStateType.Freefall then
            v1:ChangeState(Enum.HumanoidStateType.Running)
        end

        local Animator = v1:FindFirstChildOfClass("Animator")

        if Animator then
            for _, v3 in Animator:GetPlayingAnimationTracks() do
                if v3.Name == "FallAnim" or v3.Name == "JumpAnim" then
                    v3:Stop(0.1)
                end
            end
        end
    end

    v2:GetPropertyChangedSignal("Anchored"):Connect(apply)
    v1.StateChanged:Connect(function(_, p3) -- line: 59
        -- upvalues: v2 (copy), apply (copy)
        if v2.Anchored and p3 == Enum.HumanoidStateType.Freefall then
            apply()
        end
    end)
    apply()
end

LocalPlayer.CharacterAdded:Connect(function(p4) -- line: 66
    -- upvalues: watch (copy)
    task.spawn(watch, p4)
end)

if LocalPlayer.Character then
    task.spawn(watch, LocalPlayer.Character)
end

local _ = {
    Brightness = -0.07,
    Contrast = 0.05,
    Saturation = -0.03,
    BloomScale = 0.7,
    BeamBrightness = 0.85,
    Panel = 0.05,
    Title = 0.1,
    TopBar = 0.08
}
local v4 = Font.new("rbxasset://fonts/families/Merriweather.json")
local v5 = Color3.fromRGB(70, 70, 72)
local v6 = Color3.fromRGB(126, 226, 135)
local v7 = Color3.fromRGB(255, 106, 94)
local MenuStyle = require(Boxing:WaitForChild("MenuStyle"))
local Colors = MenuStyle.Colors
local SkillIcons = require(Boxing:WaitForChild("SkillIcons"))
local v8 = Color3.fromRGB(150, 146, 165)
local t1 = {}

local function readGraph() -- line: 118
    -- upvalues: HttpService (copy), SkillRemote (copy), t1 (ref)
    local JSONDecode = HttpService.JSONDecode
    local v9 = SkillRemote:GetAttribute("Graph") or "{}"
    local ok, result = pcall(JSONDecode, HttpService, v9)

    t1 = {}

    if ok and type(result) == "table" then
        for v10, v11 in result do
            local v12 = v11.C or { 0.6, 0.6, 0.6 }
            local t2 = t1

            t2[v10] = {
                Position = Vector3.new(v11.P[1], v11.P[2], v11.P[3]),
                Links = v11.L or {},
                Color = Color3.new(v12[1], v12[2], v12[3]),
                Radius = v11.R or 0.8
            }
        end
    end
end

SkillRemote:GetAttributeChangedSignal("Graph"):Connect(readGraph)
readGraph()

local ScreenGui = Instance.new("ScreenGui")

ScreenGui.Name = "SkillTreeGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.DisplayOrder = 20
ScreenGui.Enabled = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = PlayerGui

local function corner(p5, p6) -- line: 146
    local UICorner = Instance.new("UICorner")

    UICorner.CornerRadius = UDim.new(0, p6)
    UICorner.Parent = p5
end

local function stroke(p7, p8, p9) -- line: 151
    -- upvalues: v5 (copy)
    local UIStroke = Instance.new("UIStroke")

    UIStroke.Color = p9 or v5
    UIStroke.Thickness = p8
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
    UIStroke.Parent = p7

    return UIStroke
end

local function text(p10, p11, p12, p13) -- line: 159
    -- upvalues: MenuStyle (copy)
    local TextLabel = Instance.new("TextLabel")

    TextLabel.Name = p11
    TextLabel.BackgroundTransparency = 1
    TextLabel.TextSize = p12
    MenuStyle.Text(TextLabel, {
        Heading = false,
        Color = Color3.new(1, 1, 1)
    })

    for v16, v17 in p13 or {} do
        TextLabel[v16] = v17
    end

    TextLabel.Parent = p10

    return TextLabel
end

local t4 = {}

local function addScale(p14) -- line: 173
    -- upvalues: t4 (copy)
    local UIScale = Instance.new("UIScale")

    UIScale.Parent = p14
    table.insert(t4, UIScale)

    return UIScale
end

local StatsGui = PlayerGui:WaitForChild("StatsGui")
local clone = StatsGui:WaitForChild("Root"):WaitForChild("Top"):Clone()

for _, descendant in clone:GetDescendants() do
    if descendant:IsA("LuaSourceContainer") then
        descendant:Destroy()
    end
end

clone.Parent = ScreenGui

local UIScale = clone:FindFirstChildOfClass("UIScale")

if not UIScale then
    UIScale = Instance.new("UIScale")
    UIScale.Parent = clone
    table.insert(t4, UIScale)
end

table.insert(t4, UIScale)

local v18 = clone:FindFirstChild("PointsLabel", true)
local ResetButton = clone:FindFirstChild("ResetButton")
local BackButton = clone:FindFirstChild("BackButton")

if ResetButton then
    ResetButton.Visible = true
    ResetButton.Text = "Reset Skills"
end

local ResetOneButton = clone:FindFirstChild("ResetOneButton")

if ResetOneButton then
    ResetOneButton:Destroy()
end

local Position = clone.Position
local UICorner, UIPadding

for _, descendant in clone:GetDescendants() do
    if descendant:IsA("GuiObject") and descendant.BackgroundTransparency < 1 then
        local Scale

        Scale, UICorner, UIPadding = descendant.BackgroundColor3:ToHSV()

        if UIPadding > 0.6 then
            descendant.BackgroundColor3 = descendant.BackgroundColor3:Lerp(Color3.new(0, 0, 0), 0.08)
        end
    end
end

MenuStyle.Recolor(clone)

if v18 then
    MenuStyle.PointsBox(v18.Parent, v18)
end

if BackButton then
    MenuStyle.Button(BackButton, {
        MaxText = 18
    })
end

if ResetButton then
    MenuStyle.Button(ResetButton, {
        MaxText = 16,
        Accent = Colors.Red
    })
end

local Frame = PlayerGui:WaitForChild("BoxingHUD"):WaitForChild("SideMenu", 10)
local clone2

if Frame then
    clone2 = Frame:Clone()

    for _, descendant in clone2:GetDescendants() do
        if descendant:IsA("LuaSourceContainer") then
            descendant:Destroy()
        end
    end

    clone2.Parent = ScreenGui
    clone2:SetAttribute("NoReadableFloor", true)

    for _, child in clone2:GetChildren() do
        if child:IsA("GuiButton") then
            child:SetAttribute("SideStyled", nil)
        end
    end

    require(ReplicatedStorage:WaitForChild("Boxing"):WaitForChild("SideMenuStyle")).Hook(clone2)

    local UIScale = Frame:FindFirstChildOfClass("UIScale")
    local UIScale2 = clone2:FindFirstChildOfClass("UIScale")

    if UIScale and UIScale2 then
        local function syncScale() -- line: 252
            -- upvalues: UIScale (copy), UIScale2 (copy)
            UIScale2.Scale = UIScale.Scale
        end

        UIScale:GetPropertyChangedSignal("Scale"):Connect(syncScale)
        UIScale2.Scale = UIScale.Scale
    end
end

Frame = Instance.new("Frame")
Frame.Name = "Panel"
Frame.AnchorPoint = Vector2.new(1, 0.5)
Frame.Position = UDim2.new(1, -36, 0.5, 30)
Frame.Size = UDim2.fromOffset(540, 640)
Frame.BackgroundTransparency = 1
Frame.Parent = ScreenGui

local UIScale2 = Instance.new("UIScale")

UIScale2.Parent = Frame
table.insert(t4, UIScale2)

local v19 = text(Frame, "Category", 26, {
    Position = UDim2.fromOffset(6, 0),
    Size = UDim2.new(1, -170, 0, 32),
    TextXAlignment = Enum.TextXAlignment.Left
})

MenuStyle.Text(v19, {
    Size = 22,
    Color = Colors.Lilac
})
v19.TextTruncate = Enum.TextTruncate.AtEnd

local Blue, Blue2 = MenuStyle.Tag(Frame, "State", 40, "Blue")

Blue.AnchorPoint = Vector2.new(1, 0)
Blue.Position = UDim2.new(1, -2, 0, -8)

local Frame2 = Instance.new("Frame")

Frame2.Name = "Box"
Frame2.Position = UDim2.fromOffset(0, 36)
Frame2.Size = UDim2.fromOffset(540, 528)
Frame2.BorderSizePixel = 0
UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = Frame2
UICorner = Instance.new("UIStroke")
UICorner.Thickness = 5
UICorner.Parent = Frame2
Frame2.Parent = Frame

local v20 = text(Frame2, "Title", 38, {
    BackgroundTransparency = 0,
    TextScaled = true,
    TextWrapped = true,
    Position = UDim2.fromOffset(8, 8),
    Size = UDim2.new(1, -16, 0, 64)
})

UIPadding = Instance.new("UIPadding")

local UITextSizeConstraint = UDim.new(0, 10)
local v21 = UDim.new(0, 10)

UIPadding.PaddingLeft = UITextSizeConstraint
UIPadding.PaddingRight = v21
UITextSizeConstraint = UDim.new(0, 8)
v21 = UDim.new(0, 8)
UIPadding.PaddingTop = UITextSizeConstraint
UIPadding.PaddingBottom = v21
UIPadding.Parent = v20
UITextSizeConstraint = Instance.new("UICorner")
UITextSizeConstraint.CornerRadius = UDim.new(0, 6)
UITextSizeConstraint.Parent = v20
UITextSizeConstraint = Instance.new("UITextSizeConstraint")
UITextSizeConstraint.MaxTextSize = 38
UITextSizeConstraint.Parent = v20

local v22 = text(Frame2, "Description", 22, {
    TextWrapped = true,
    TextScaled = true,
    Position = UDim2.fromOffset(18, 80),
    Size = UDim2.new(1, -36, 0, 150),
    TextXAlignment = Enum.TextXAlignment.Left,
    TextYAlignment = Enum.TextYAlignment.Top
})
local UITextSizeConstraint2 = Instance.new("UITextSizeConstraint")

UITextSizeConstraint2.MaxTextSize = 22
UITextSizeConstraint2.MinTextSize = 12
UITextSizeConstraint2.Parent = v22

local Frame3 = Instance.new("Frame")

Frame3.Name = "Requirements"
Frame3.BackgroundTransparency = 1
Frame3.Position = UDim2.fromOffset(0, 236)
Frame3.Size = UDim2.new(1, 0, 1, -236)
Frame3.Parent = Frame2

local v23 = text(Frame3, "StatLine", 28, {
    RichText = true,
    Position = UDim2.fromOffset(18, 0),
    Size = UDim2.new(1, -36, 0, 36),
    TextXAlignment = Enum.TextXAlignment.Left
})
local v24 = text(Frame3, "SkillLine", 28, {
    RichText = true,
    Position = UDim2.fromOffset(18, 38),
    Size = UDim2.new(1, -36, 0, 36),
    TextXAlignment = Enum.TextXAlignment.Left
})

local function innerBox(p15, p16, p17) -- line: 344
    -- upvalues: MenuStyle (copy), Frame3 (copy)
    local Frame = Instance.new("Frame")

    Frame.Name = p15
    Frame.Position = p16
    Frame.Size = p17
    Frame.ZIndex = 3
    MenuStyle.Well(Frame, 0.1)
    Frame.Parent = Frame3

    return Frame
end

MenuStyle.Text(v23, {
    Size = 22
})
MenuStyle.Text(v24, {
    Size = 22
})

local v25 = UDim2.fromOffset(12, 84)
local v26 = UDim2.new(0.58, -18, 1, -96)
local Frame4 = Instance.new("Frame")

Frame4.Name = "Stats"
Frame4.Position = v25
Frame4.Size = v26
Frame4.ZIndex = 3
MenuStyle.Well(Frame4, 0.1)
Frame4.Parent = Frame3
v26 = UDim2.new(0.58, 6, 0, 84)

local UIPadding2 = UDim2.new(0.42, -18, 1, -96)
local Frame5 = Instance.new("Frame")

Frame5.Name = "Needs"
Frame5.Position = v26
Frame5.Size = UIPadding2
Frame5.ZIndex = 3
MenuStyle.Well(Frame5, 0.1)
Frame5.Parent = Frame3

local t5 = {}
local t6 = {}

UIPadding2 = Instance.new("UIGridLayout")
UIPadding2.CellSize = UDim2.new(0.5, -6, 0.333, -6)
UIPadding2.CellPadding = UDim2.fromOffset(6, 6)
UIPadding2.SortOrder = Enum.SortOrder.LayoutOrder
UIPadding2.Parent = Frame4
UIPadding2 = Instance.new("UIPadding")

local v27 = UDim.new(0, 8)
local v28 = UDim.new(0, 4)

UIPadding2.PaddingLeft = v27
UIPadding2.PaddingRight = v28
v27 = UDim.new(0, 8)
v28 = UDim.new(0, 4)
UIPadding2.PaddingTop = v27
UIPadding2.PaddingBottom = v28
UIPadding2.Parent = Frame4

local Frame6

for v29, v30 in BoxingSkills.StatOrder do
    Frame6 = Instance.new("Frame")
    Frame6.Name = v30
    Frame6.LayoutOrder = v29
    Frame6.BackgroundTransparency = 1
    Frame6.Parent = Frame4

    local v31 = text(Frame6, "Label", 17, {
        TextScaled = true,
        Size = UDim2.new(1, 0, 1, -10),
        TextXAlignment = Enum.TextXAlignment.Left,
        Text = v30 .. ": 0"
    })
    local UITextSizeConstraint = Instance.new("UITextSizeConstraint")

    UITextSizeConstraint.MaxTextSize = 17
    UITextSizeConstraint.MinTextSize = 9
    UITextSizeConstraint.Parent = v31
    UITextSizeConstraint = Instance.new("Frame")
    UITextSizeConstraint.Name = "Bar"
    UITextSizeConstraint.AnchorPoint = Vector2.new(0, 1)
    UITextSizeConstraint.Position = UDim2.new(0, 0, 1, -3)
    UITextSizeConstraint.Size = UDim2.new(0.9, 0, 0, 6)
    UITextSizeConstraint.ZIndex = 4
    UITextSizeConstraint.Parent = Frame6
    t6[v30] = MenuStyle.Track(UITextSizeConstraint, BoxingSkills.StatColors[v30])
    t5[v30] = v31
end

local Frame7 = Instance.new("Frame")

Frame7.BackgroundTransparency = 1
Frame7.Size = UDim2.fromScale(1, 1)
Frame7.Parent = Frame5
Frame4 = Instance.new("UIListLayout")
Frame4.SortOrder = Enum.SortOrder.LayoutOrder
Frame4.Padding = UDim.new(0, 4)
Frame4.Parent = Frame7
Frame4 = Instance.new("UIPadding")
UIPadding2 = UDim.new(0, 10)
Frame5 = UDim.new(0, 8)
Frame4.PaddingLeft = UIPadding2
Frame4.PaddingRight = Frame5
Frame4.PaddingTop = UDim.new(0, 8)
Frame4.Parent = Frame7

local v32 = text(Frame2, "Unlocked", 86, {
    Text = "Unlocked!",
    Visible = false,
    Position = UDim2.fromOffset(0, 250),
    Size = UDim2.new(1, 0, 1, -270),
    TextColor3 = v6
})

v32.Text = "UNLOCKED"
MenuStyle.Text(v32, {
    Size = 52,
    Stroke = 4,
    Color = v6
})
Frame5 = Instance.new("Frame")
Frame5.Name = "TitleBar"
Frame5.Position = v20.Position
Frame5.Size = v20.Size
Frame5.ZIndex = 2
Frame5.Parent = Frame2
v28 = MenuStyle.Face(Frame5)

local Frame8 = Instance.new("Frame")

Frame8.Name = "Gem"
Frame8.Size = UDim2.new(0, 8, 1, 0)
Frame8.BorderSizePixel = 0
Frame8.ZIndex = v28.ZIndex
Frame8.Parent = v28

local ImageLabel = Instance.new("ImageLabel")

ImageLabel.Name = "Icon"
ImageLabel.AnchorPoint = Vector2.new(0, 0.5)
ImageLabel.Position = UDim2.new(0, 16, 0.5, 0)
ImageLabel.Size = UDim2.fromOffset(52, 52)
ImageLabel.BackgroundTransparency = 0
ImageLabel.BackgroundColor3 = Color3.fromRGB(242, 238, 228)
ImageLabel.ScaleType = Enum.ScaleType.Fit
ImageLabel.ZIndex = Frame5.ZIndex + 1
ImageLabel.Parent = Frame5

local UICorner2 = Instance.new("UICorner")

UICorner2.CornerRadius = UDim.new(0.5, 0)
UICorner2.Parent = ImageLabel
UICorner2 = Instance.new("UIStroke")
UICorner2.Thickness = 2
UICorner2.Color = Colors.Navy
UICorner2.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UICorner2.Parent = ImageLabel

for _, child in v20:GetChildren() do
    if child:IsA("UICorner") then
        child:Destroy()
    end
end

v20.BackgroundTransparency = 1
v20.ZIndex = 4
MenuStyle.Text(v20, {
    Stroke = 2
})
UITextSizeConstraint.MaxTextSize = 20
UICorner2 = UDim.new(0, 4)

local v33 = UDim.new(0, 2)

UIPadding.PaddingTop = UICorner2
UIPadding.PaddingBottom = v33
UIPadding.PaddingLeft = UDim.new(0, 74)
v22.ZIndex = 3
Frame3.ZIndex = 3
v32.ZIndex = 3
MenuStyle.Panel(Frame2)

local Frame9 = Instance.new("Frame")

Frame9.Name = "Unlock"
Frame9.AnchorPoint = Vector2.new(1, 0)
Frame9.Position = UDim2.new(1, 0, 0, 576)
Frame9.Size = UDim2.fromOffset(210, 62)
Frame9.BackgroundTransparency = 1
Frame9.Parent = Frame

local TextButton = Instance.new("TextButton")

TextButton.Name = "Click"
TextButton.Position = UDim2.fromOffset(0, 0)
TextButton.Size = UDim2.new(1, -12, 1, 0)
TextButton.Text = "Unlock"
TextButton.Parent = Frame9
MenuStyle.Button(TextButton, {
    MaxText = 22,
    Accent = Colors.Green
})
MenuStyle.SetSelected(TextButton, true)
UICorner2 = Instance.new("Frame")
UICorner2.Name = "Arrows"
UICorner2.BackgroundTransparency = 1
UICorner2.Size = UDim2.fromScale(1, 1)
UICorner2.ZIndex = 2
UICorner2.Parent = ScreenGui

local t7 = {}
local n1 = 1

local function updateScale() -- line: 507
    -- upvalues: CurrentCamera (copy), MenuStyle (copy), ScreenGui (copy), t4 (copy), n1 (ref)
    local v35 = math.clamp(CurrentCamera.ViewportSize.Y / 1080, 0.5, 1.5)

    for _, v36 in t4 do
        v36.Scale = v35
    end

    if v35 ~= n1 then
        n1 = v35
        MenuStyle.KeepReadable(ScreenGui, v35)
    end

    local v37 = CurrentCamera.ViewportSize.Y < 500
    local Height = game:GetService("GuiService").TopbarInset.Height
    local Top = ScreenGui:FindFirstChild("Top")

    if Top then
        Top.Position = UDim2.new(Top.Position.X.Scale, Top.Position.X.Offset, 0, if v37 then Height + 8 else 0)
    end

    local Panel = ScreenGui:FindFirstChild("Panel")

    if Panel then
        local UIScale = Panel:FindFirstChildOfClass("UIScale")

        if UIScale then
            if v37 then
                UIScale.Scale = v35 * 0.84
                Panel.Position = UDim2.new(1, -36, 0.5, 30 + Height / 2)

                return v35
            end

            Panel.Position = UDim2.new(1, -36, 0.5, 30)
        end
    end

    return v35
end

game:GetService("GuiService"):GetPropertyChangedSignal("TopbarInset"):Connect(updateScale)
MenuStyle.KeepReadable(ScreenGui, (math.clamp(CurrentCamera.ViewportSize.Y / 1080, 0.5, 1.5)))
CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(updateScale)
updateScale()

local v39 = BoxingConfig.UISounds or {}
local t8 = {}

local function playSound(p18, p19, p20) -- line: 545
    -- upvalues: SoundService (copy), t8 (copy), v39 (copy)
    p19 = p19 or v39[p18]

    if not p19 then
        return
    end

    local v41 = t8[p18]

    if not v41 or not v41.Parent then
        local Sound = Instance.new("Sound")

        v41 = Sound
        Sound.Name = "UI_Skill" .. p18
        Sound.SoundId = p19
        Sound.Volume = p20 or v39.Volume or 0.6
        Sound.SoundGroup = SoundService:FindFirstChild("BoxingUI")
        Sound.Parent = SoundService
        t8[p18] = Sound
    end

    v41.TimePosition = 0
    v41:Play()
end

local function click() -- line: 563
    -- upvalues: BoxingConfig (copy), playSound (copy)
    playSound("Click", BoxingConfig.Loadout and BoxingConfig.Loadout.ClickSound, BoxingConfig.Loadout and BoxingConfig.Loadout.ClickVolume)
end

local v42 = false
local v43 = false
local v44 = "Boxing Basics"
local v45, t9
local v46 = false

local function statValue(p21) -- line: 573
    -- upvalues: LocalPlayer (copy)
    return LocalPlayer:GetAttribute("Stat_" .. p21) or 0
end

local function fmt(p22) -- line: 576
    local v48 = string.format("%.2f", math.floor(p22 * 100 + 1E-04) / 100)
    local v49 = string.gsub(v48, "0+$", "")

    return (string.gsub(v49, "%.$", ""))
end

local function hex(p23) -- line: 584
    return string.format("#%02X%02X%02X", p23.R * 255, p23.G * 255, p23.B * 255)
end

local function mark(p24) -- line: 587
    -- upvalues: v6 (copy), v7 (copy), hex (copy)
    if p24 then
        return (string.format("<font color=\"%s\">MET</font>", hex(v6)))
    end

    return (string.format("<font color=\"%s\">NOT MET</font>", hex(v7)))
end

local function availablePoints() -- line: 591
    -- upvalues: LocalPlayer (copy), BoxingSkills (copy), Stats (copy)
    local SkillPoints = LocalPlayer:GetAttribute("SkillPoints")

    if SkillPoints == nil then
        SkillPoints = BoxingSkills.Earned(LocalPlayer, Stats) - BoxingSkills.Spent(BoxingSkills.Unlocked(LocalPlayer))
    end

    return SkillPoints
end

local SkillPoints
local n2 = 0

local function setPointsText(p25) -- line: 602
    -- upvalues: MenuStyle (copy), v18 (copy)
    v18.Text = string.format("<font color=\"%s\">%d</font> SKILL POINT%s", MenuStyle.Hex.Amber, p25, p25 == 1 and "" or "S")
end

local function popPoints() -- line: 605
    -- upvalues: TweenService (copy), v18 (copy)
    local v50 = v18 and v18.Parent

    if not v50 then
        return
    end

    local Pop = v50:FindFirstChild("Pop")

    if not Pop then
        Pop = Instance.new("UIScale")
        Pop.Name = "Pop"
        Pop.Parent = v50
    end

    Pop.Scale = 1.16
    TweenService:Create(Pop, TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Scale = 1
    }):Play()
end

local function refreshHeader() -- line: 619
    -- upvalues: LocalPlayer (copy), BoxingSkills (copy), Stats (copy), MenuStyle (copy), v18 (copy), v42 (ref), SkillPoints (ref), n2 (ref), popPoints (copy)
    if not v18 then
        return
    end

    local SkillPoints2 = LocalPlayer:GetAttribute("SkillPoints")

    if SkillPoints2 == nil then
        SkillPoints2 = BoxingSkills.Earned(LocalPlayer, Stats) - BoxingSkills.Spent(BoxingSkills.Unlocked(LocalPlayer))
    end

    n2 += 1

    if not SkillPoints or not (SkillPoints2 < SkillPoints) or not v42 then
        SkillPoints = SkillPoints2
        v18.Text = string.format("<font color=\"%s\">%d</font> SKILL POINT%s", MenuStyle.Hex.Amber, SkillPoints2, SkillPoints2 == 1 and "" or "S")

        return
    end

    local v51 = n2
    local SkillPoints3 = SkillPoints

    SkillPoints = SkillPoints2

    local spawn = task.spawn
    local SkillPoints4 = SkillPoints2

    spawn(function() -- line: 628
        -- upvalues: v51 (copy), SkillPoints3 (copy), SkillPoints4 (copy), MenuStyle (copy), v18 (copy), n2 (ref), popPoints (copy)
        for i = SkillPoints3 - 1, SkillPoints4, -1 do
            if v51 ~= n2 then
                return
            end

            v18.Text = string.format("<font color=\"%s\">%d</font> SKILL POINT%s", MenuStyle.Hex.Amber, i, i == 1 and "" or "S")
            popPoints()
            task.wait(0.14)
        end
    end)
end

local function refreshPanel() -- line: 644
    -- upvalues: LocalPlayer (copy), BoxingSkills (copy), Stats (copy), v6 (copy), v7 (copy), MenuStyle (copy), Colors (copy), SkillIcons (copy), v8 (copy), text (copy), v19 (copy), Blue (copy), Blue2 (copy), Frame2 (copy), v20 (copy), v22 (copy), Frame3 (copy), v23 (copy), v24 (copy), t5 (copy), t6 (copy), Frame7 (copy), v32 (copy), Frame8 (copy), ImageLabel (copy), Frame9 (copy), TextButton (copy), n1 (ref), v44 (ref), hex (copy)
    local v53 = BoxingSkills.List[v44]
    local v54 = BoxingSkills.Themes[v53 and v53.Theme or "Grey"] or BoxingSkills.Themes.Grey

    MenuStyle.SetAccent(Frame2, v54.Title)
    Frame8.BackgroundColor3 = v54.Title

    for _, child in Frame7:GetChildren() do
        if child:IsA("TextLabel") then
            child:Destroy()
        end
    end

    ImageLabel.Image = if v53 then SkillIcons.For(v44, v53) else ""

    if v53 then
        v19.Text = string.format("%s: %s Skill", v53.Branch, v53.Category)
        v20.Text = string.format("%s: %s", v53.Type, v53.Display)
        v22.Text = v53.Description

        local v56 = BoxingSkills.Has(LocalPlayer, v44)

        v32.Visible = v56
        Frame3.Visible = not v56
        Blue.Visible = true

        if v56 then
            MenuStyle.SetTag(Blue, "Green")
            Blue2.Text = "UNLOCKED"
            Frame9.Visible = false
        else
            local v57, v58, v59 = BoxingSkills.Check(LocalPlayer, v44, Stats)
            local v60 = v57 and v58 and v59

            MenuStyle.SetTag(Blue, v60 and "Amber" or "Red")
            Blue2.Text = v60 and "AVAILABLE" or "LOCKED"
            v23.Text = string.format("<font color=\"%s\">STATS</font>  ", MenuStyle.Hex.Lilac) .. (if v57 then string.format("<font color=\"%s\">MET</font>", hex(v6)) else string.format("<font color=\"%s\">NOT MET</font>", hex(v7)))
            v24.Text = string.format("<font color=\"%s\">SKILLS + POINTS</font>  ", MenuStyle.Hex.Lilac) .. (if v58 and v59 then string.format("<font color=\"%s\">MET</font>", hex(v6)) else string.format("<font color=\"%s\">NOT MET</font>", hex(v7)))

            for v65, v66 in t5 do
                local v67 = (v53.Stats or {})[v65] or 0
                local v68 = LocalPlayer:GetAttribute("Stat_" .. v65) or 0

                if v67 > 0 then
                    local format = string.format
                    local v69 = math.min(v68, v67)
                    local v71 = string.format("%.2f", math.floor(v69 * 100 + 1E-04) / 100)
                    local v72 = string.gsub(v71, "0+$", "")
                    local v73 = string.gsub(v72, "%.$", "")
                    local v75 = string.format("%.2f", math.floor(v67 * 100 + 1E-04) / 100)
                    local v76 = string.gsub(v75, "0+$", "")

                    v66.Text = format("%s %s/%s", v65, v73, (string.gsub(v76, "%.$", "")))
                else
                    v66.Text = string.format("%s -", v65)
                end

                if v67 <= 0 then
                    v66.TextColor3 = v8
                elseif v68 + 1E-06 < v67 then
                    v66.TextColor3 = v7
                else
                    v66.TextColor3 = v6
                end

                local v77 = t6[v65]

                if v77 then
                    v77.Size = UDim2.fromScale(if v67 > 0 then math.clamp(v68 / v67, 0, 1) else 0, 1)
                end
            end

            local v80 = v53.Cost or 0

            text(Frame7, "Points", 24, {
                LayoutOrder = 0,
                Size = UDim2.new(1, 0, 0, 30),
                TextXAlignment = Enum.TextXAlignment.Left,
                Text = string.format("%d Skill Point%s", v80, v80 == 1 and "" or "s"),
                TextColor3 = if v59 then v6 else v7
            })

            local v81 = BoxingSkills.Unlocked(LocalPlayer)

            for v82, v83 in v53.Requires or {} do
                text(Frame7, "Need" .. v82, 20, {
                    TextWrapped = true,
                    LayoutOrder = v82,
                    Size = UDim2.new(1, 0, 0, 26),
                    AutomaticSize = Enum.AutomaticSize.Y,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Text = string.format("• Unlock '%s' Skill", v83),
                    TextColor3 = if v81[v83] then v6 else v7
                }).Size = UDim2.new(1, 0, 0, 0)
            end

            Frame9.Visible = true
            MenuStyle.SetButtonAccent(TextButton, if v60 then Colors.Green else Colors.Red)
            MenuStyle.KeepReadable(Frame7, n1)
        end
    else
        Blue.Visible = false
        v19.Text = ""
        v20.Text = v44
        v22.Text = "This skill isn't available yet."
        Frame3.Visible = false
        v32.Visible = false
        Frame9.Visible = false
    end
end

local function nodeView(p26) -- line: 725
    -- upvalues: CurrentCamera (copy), t1 (ref)
    local v86 = t1[p26]

    if not v86 then
        return nil
    end

    local ViewportSize = CurrentCamera.ViewportSize
    local v87 = 0 * (5.484827557301444 * (if ViewportSize.Y > 0 then ViewportSize.X / ViewportSize.Y else 1.7777777777777777))
    local Unit = (Vector3.new(0, -1, 0)).Unit
    local v88 = v86.Position + Vector3.new(0, 0, 1) * v87 - Unit * (9.5 / -Unit.Y)

    return CFrame.lookAt(v88, v88 + Unit, (Vector3.new(1, 0, 0)))
end

local function overviewView() -- line: 746
    -- upvalues: CurrentCamera (copy), t1 (ref)
    local n3 = 1e999
    local n4 = (-1e999)
    local n5 = 1e999
    local n6 = (-1e999)
    local n7 = 0
    local n8 = 0

    for _, v89 in t1 do
        local v90 = v89.Position:Dot((Vector3.new(1, 0, 0)))
        local v91 = v89.Position:Dot((Vector3.new(0, 0, 1)))

        n3 = math.min(n3, v90)
        n4 = math.max(n4, v90)
        n5 = math.min(n5, v91)
        n6 = math.max(n6, v91)
        n7 += v89.Position.Y
        n8 += 1
    end

    if n8 == 0 then
        return nil
    end

    local v92 = n7 / n8
    local ViewportSize = CurrentCamera.ViewportSize
    local v93 = if ViewportSize.Y > 0 then ViewportSize.X / ViewportSize.Y else 1.7777777777777777
    local v94 = (n4 - n3) / 2 + 2
    local v95 = (n6 - n5) / 2 + 2
    local v98 = math.max(v94 / 0.7002075382097097, v95 / (0.7002075382097097 * v93 * 0.58)) * 1.08
    local v99 = 0.42000000000000004 * (v98 * 0.7002075382097097 * v93)
    local v100 = Vector3.new(1, 0, 0) * ((n3 + n4) / 2) + Vector3.new(0, 0, 1) * ((n5 + n6) / 2 + v99) + Vector3.new(0, v92, 0)
    local v101 = v100 + Vector3.new(0, v98, 0)

    return CFrame.lookAt(v101, v100, (Vector3.new(1, 0, 0)))
end

local SkillTreeArrow = Boxing:WaitForChild("SkillTreeArrow")
local Folder = Instance.new("Folder")

Folder.Name = "SkillTreeArrows"

local t12 = {}
local t13 = {}
local Highlight = Instance.new("Highlight")

Highlight.Name = "SkillTreeArrowHover"
Highlight.FillTransparency = 0.6
Highlight.FillColor = Color3.new(1, 1, 1)
Highlight.OutlineColor = Color3.new(1, 1, 1)
Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop

local v102 = text(ScreenGui, "Tooltip", 22, {
    Visible = false,
    ZIndex = 5,
    AnchorPoint = Vector2.new(0, 1),
    Size = UDim2.fromOffset(0, 30),
    AutomaticSize = Enum.AutomaticSize.X,
    TextXAlignment = Enum.TextXAlignment.Left
})

MenuStyle.Text(v102, {
    Size = 12
})
v102.BackgroundColor3 = Colors.Navy
v102.BackgroundTransparency = 0.12

local UIPadding3 = Instance.new("UIStroke")

UIPadding3.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIPadding3.Color = Colors.BevelSide
UIPadding3.Parent = v102
UIPadding3 = Instance.new("UIPadding")

local v103 = UDim.new(0, 10)
local v104 = UDim.new(0, 10)
local v105 = UDim.new(0, 3)

UIPadding3.PaddingLeft = v103
UIPadding3.PaddingRight = v104
UIPadding3.PaddingTop = v105
UIPadding3.Parent = v102

local function clearArrows() -- line: 815
    -- upvalues: t7 (copy), Folder (copy), t12 (copy), t13 (copy), Highlight (copy), v102 (copy)
    Highlight.Parent = nil
    v102.Visible = false
    Folder:ClearAllChildren()
    table.clear(t12)
    table.clear(t13)
    table.clear(t7)
end

local styleBoard

local function buildArrows() -- line: 826
    -- upvalues: t1 (ref), t7 (copy), v42 (ref), v44 (ref), SkillTreeArrow (copy), Folder (copy), t12 (copy), t13 (copy), Highlight (copy), v102 (copy)
    Highlight.Parent = nil
    v102.Visible = false
    Folder:ClearAllChildren()
    table.clear(t12)
    table.clear(t13)
    table.clear(t7)

    local t14 = t1
    local v106 = t14[v44]

    if not v106 then
        return
    end

    local Links = v106.Links

    if #Links == 0 then
        local t15 = {}

        for v107, v108 in t1 do
            if v107 ~= v44 then
                table.insert(t15, {
                    v107,
                    (v108.Position - v106.Position).Magnitude
                })
            end
        end

        table.sort(t15, function(p27, p28) -- line: 842
            return p27[2] < p28[2]
        end)
        Links = {}

        for i = 1, math.min(3, #t15) do
            table.insert(Links, t15[i][1])
        end
    end

    for _, v111 in Links do
        local v112 = t1[v111]
        local v113 = v112 and Vector3.new(v112.Position.X - v106.Position.X, 0, v112.Position.Z - v106.Position.Z)

        if v113 and v113.Magnitude > 0.001 then
            local Unit = v113.Unit
            local clone = SkillTreeArrow:Clone()

            clone.Name = v111

            local v117 = math.max(0, (v106.Radius or 0.8) - 0.8)

            clone:PivotTo(CFrame.lookAt(v106.Position, v106.Position + Unit) + Unit * v117 + Vector3.new(0, #t7 * 0.012, 0))

            local v120, v121 = v112.Color:ToHSV()
            local v123 = Color3.fromHSV(v120, math.min(1, v121 * 1.1), if v121 < 0.05 then 0.72 else 0.74)

            for _, descendant in clone:GetDescendants() do
                if descendant:IsA("BasePart") then
                    if descendant.Name == "Center" then
                        descendant.CanQuery = false
                    else
                        descendant.CanQuery = true
                        t12[descendant] = v111

                        if descendant.Name == "Head" or descendant.Name == "Tail" then
                            descendant.Color = v112.Color
                        else
                            descendant.Color = v123
                        end

                        descendant:SetAttribute("Fill", descendant.Color)
                    end
                end
            end

            clone.Parent = Folder
            t13[v111] = clone
            table.insert(t7, {
                Model = clone,
                Target = v111
            })
        end
    end

    Folder.Parent = if v42 then workspace else nil
end

local t18 = {}

local function restoreBeams() -- line: 891
    -- upvalues: t18 (copy)
    for v125, v126 in t18 do
        if v125.Parent then
            v125.Color = v126.Color
            v125.LightEmission = v126.LightEmission
            v125.Brightness = v126.Brightness
        end
    end

    table.clear(t18)
end

local function beamBetween(p29, p30) -- line: 901
    for _, v127 in { p29, p30 } do
        local Options = v127:FindFirstChild("Options")

        if Options then
            for _, child in Options:GetChildren() do
                if child:IsA("Beam") and child.Attachment0 and child.Attachment1 then
                    local Model = child.Attachment0:FindFirstAncestorWhichIsA("Model")
                    local Model2 = child.Attachment1:FindFirstAncestorWhichIsA("Model")

                    if Model == p29 and Model2 == p30 or Model == p30 and Model2 == p29 then
                        return child
                    end
                end
            end
        end
    end

    return nil
end

local function lightBeams() -- line: 918
    -- upvalues: t1 (ref), v42 (ref), v44 (ref), t18 (copy), restoreBeams (copy), beamBetween (copy)
    restoreBeams()

    local v128 = workspace:FindFirstChild("Skill tree")
    local v129 = v128 and v128:FindFirstChild(v44)
    local t19 = t1
    local v130 = t19[v44]

    if v42 and v129 and v130 then
        for _, v131 in v130.Links do
            local v132 = v128:FindFirstChild(v131)
            local v133 = v132 and beamBetween(v129, v132)

            if v133 and t1[v131] then
                t18[v133] = {
                    Color = v133.Color,
                    LightEmission = v133.LightEmission,
                    Brightness = v133.Brightness
                }

                local v134, v135 = t1[v131].Color:ToHSV()

                v133.Color = ColorSequence.new(Color3.fromHSV(v134, v135, 1))
                v133.LightEmission = 0.85
                v133.Brightness = 1.3
            end
        end
    end
end

local function clearBoard() -- line: 939
    -- upvalues: t7 (copy), Folder (copy), t12 (copy), t13 (copy), Highlight (copy), v102 (copy), restoreBeams (copy)
    Highlight.Parent = nil
    v102.Visible = false
    Folder:ClearAllChildren()
    table.clear(t12)
    table.clear(t13)
    table.clear(t7)
    Folder.Parent = nil
    restoreBeams()
end

local function arrowAt(p31) -- line: 946
    -- upvalues: CurrentCamera (copy), Folder (copy), t12 (copy)
    if not Folder.Parent then
        return nil
    end

    local v136 = CurrentCamera:ViewportPointToRay(p31.X, p31.Y)
    local v137 = RaycastParams.new()

    v137.FilterType = Enum.RaycastFilterType.Include
    v137.FilterDescendantsInstances = { Folder }

    local v138 = workspace:Raycast(v136.Origin, v136.Direction * 200, v137)

    return v138 and t12[v138.Instance]
end

local function placeArrows() -- line: 958
    -- upvalues: UserInputService (copy), LocalPlayer (copy), BoxingSkills (copy), v6 (copy), v42 (ref), v43 (ref), t9 (ref), t13 (copy), v102 (copy), arrowAt (copy)
    local MouseLocation = UserInputService:GetMouseLocation()
    local v139 = if v42 and not v43 and not t9 then arrowAt(MouseLocation) else nil
    local v140 = v139 and t13[v139]

    for _, v141 in t13 do
        for _, descendant in v141:GetDescendants() do
            local v142 = descendant:IsA("BasePart") and descendant:GetAttribute("Fill")

            if v142 then
                if v141 == v140 then
                    v142 = v142:Lerp(Color3.new(1, 1, 1), 0.45)
                end

                descendant.Color = v142
            end
        end
    end

    if not v140 then
        v102.Visible = false

        return
    end

    v102.Text = v139
    v102.TextColor3 = if BoxingSkills.Has(LocalPlayer, v139) then v6 else Color3.new(1, 1, 1)
    v102.Position = UDim2.fromOffset(MouseLocation.X + 18, MouseLocation.Y - 6)
    v102.Visible = true
end

local function holdCamera() -- line: 981
    -- upvalues: TweenService (copy), CurrentCamera (copy), v45 (ref), t9 (ref), v46 (ref), placeArrows (copy)
    if not v45 then
        return
    end

    if t9 then
        local v145 = math.clamp((os.clock() - t9.Start) / t9.Time, 0, 1)
        local Value = TweenService:GetValue(v145, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)

        v45 = t9.From:Lerp(t9.To, Value)

        if v145 >= 1 then
            t9 = nil
        end
    end

    CurrentCamera.CameraType = Enum.CameraType.Scriptable
    CurrentCamera.CFrame = v45

    local v146 = if v46 then 70 else 60

    CurrentCamera.FieldOfView = if t9 then CurrentCamera.FieldOfView + (v146 - CurrentCamera.FieldOfView) * 0.15 else v146
    placeArrows()
end

local Highlight2 = Instance.new("Highlight")

local function goTo(p32, p33) -- line: 1004
    -- upvalues: t1 (ref), v42 (ref), v44 (ref), v45 (ref), t9 (ref), v46 (ref), refreshPanel (copy), nodeView (copy), styleBoard (ref), buildArrows (copy), t18 (copy), lightBeams (copy)
    if t1[p32] then
        v46 = false
        v44 = p32

        local v147 = nodeView(p32)

        if v147 and v45 and not p33 then
            t9 = {
                Time = 0.45,
                From = v45,
                To = v147,
                Start = os.clock()
            }
        elseif v147 then
            v45 = v147
            t9 = nil
        end

        buildArrows()
        refreshPanel()
        lightBeams()
        task.delay(1, function() -- line: 1020
            -- upvalues: p32 (copy), v42 (ref), v44 (ref), styleBoard (ref), t18 (copy), lightBeams (copy)
            if v42 and v44 == p32 and next(t18) == nil then
                lightBeams()
            end

            if v42 then
                styleBoard(true)
            end
        end)
    end
end

local function nodeAt(p34) -- line: 1031
    -- upvalues: CurrentCamera (copy), t1 (ref)
    local v149 = nil
    local v150 = math.clamp(CurrentCamera.ViewportSize.Y / 1080, 0.5, 1.5) * 34

    for v151, v152 in t1 do
        local v153, v154 = CurrentCamera:WorldToViewportPoint(v152.Position)

        if v154 then
            local Magnitude = (Vector2.new(v153.X, v153.Y) - p34).Magnitude

            if Magnitude < v150 then
                v150 = Magnitude
                v149 = v151
            end
        end
    end

    return v149
end

UserInputService.InputBegan:Connect(function(p35, p36) -- line: 1044
    -- upvalues: GuiService (copy), UserInputService (copy), BoxingConfig (copy), playSound (copy), v42 (ref), v43 (ref), v44 (ref), arrowAt (copy), goTo (copy), nodeAt (copy)
    local v155, v156

    if not v42 or v43 or p36 then
        v156 = true
    else
        if p35.UserInputType == Enum.UserInputType.MouseButton1 then
            v155 = UserInputService:GetMouseLocation()
        elseif p35.UserInputType == Enum.UserInputType.Touch then
            v155 = Vector2.new(p35.Position.X, p35.Position.Y + GuiService:GetGuiInset().Y)
        end

        v156 = false
    end

    if v156 or not v155 then
        return
    end

    local v157 = arrowAt(v155) or nodeAt(v155)
    local playSound2, v158

    if v157 and v157 ~= v44 then
        playSound2 = playSound
        v158 = BoxingConfig.Loadout and BoxingConfig.Loadout.ClickSound
        playSound2("Click", v158, BoxingConfig.Loadout and BoxingConfig.Loadout.ClickVolume)
        goTo(v157)
    end
end)

local t20 = {
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
    Enum.KeyCode.ButtonA
}

local function setFrozen(p37) -- line: 1071
    -- upvalues: ContextActionService (copy), LocalPlayer (copy), t20 (copy)
    if not p37 then
        ContextActionService:UnbindAction("SkillTreeFreeze")

        return
    end

    ContextActionService:BindActionAtPriority("SkillTreeFreeze", function() -- line: 1073
        return Enum.ContextActionResult.Sink
    end, false, Enum.ContextActionPriority.High.Value + 100, table.unpack(t20))

    local v161 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")

    if v161 then
        v161:Move((Vector3.new(0, 0, 0)))
    end
end

local ScreenGui2 = Instance.new("ScreenGui")

ScreenGui2.Name = "SkillTreeFade"
ScreenGui2.IgnoreGuiInset = true
ScreenGui2.ResetOnSpawn = false
ScreenGui2.DisplayOrder = 1000
ScreenGui2.Enabled = false

local _require = Instance.new("Frame")

_require.BackgroundColor3 = Color3.new(0, 0, 0)
_require.BackgroundTransparency = 1
_require.BorderSizePixel = 0
_require.Size = UDim2.fromScale(1, 1)
_require.Parent = ScreenGui2
ScreenGui2.Parent = PlayerGui

local MangaTransition = require(Boxing:WaitForChild("MangaTransition"))

local function blackout(p38) -- line: 1102
    -- upvalues: v43 (ref), MangaTransition (copy)
    v43 = true
    MangaTransition.Play(p38)
    v43 = false
end

local Lighting = game:GetService("Lighting")
local ColorCorrectionEffect
local t21 = {}
local t22 = {}

local function setDimmed(p39) -- line: 1110
    -- upvalues: Lighting (copy), ColorCorrectionEffect (ref), t21 (copy), t22 (copy)
    local v162 = workspace:FindFirstChild("Skill tree")

    if not p39 or not v162 then
        if not p39 then
            for v163, v164 in t22 do
                if v163.Parent then
                    v163.Brightness = v164
                end
            end

            table.clear(t22)
        end
    else
        for _, descendant in v162:GetDescendants() do
            if descendant:IsA("Beam") and not t22[descendant] then
                t22[descendant] = descendant.Brightness
                descendant.Brightness = 0.85
            end
        end
    end

    if p39 then
        if not ColorCorrectionEffect then
            ColorCorrectionEffect = Instance.new("ColorCorrectionEffect")
            ColorCorrectionEffect.Name = "SkillTreeDim"
            ColorCorrectionEffect.Brightness = -0.07
            ColorCorrectionEffect.Contrast = 0.05
            ColorCorrectionEffect.Saturation = -0.03
        end

        ColorCorrectionEffect.Parent = Lighting

        for _, child in Lighting:GetChildren() do
            if child:IsA("BloomEffect") and child.Enabled and not t21[child] then
                t21[child] = child.Intensity
                child.Intensity *= 0.7
            end
        end
    else
        if ColorCorrectionEffect then
            ColorCorrectionEffect.Parent = nil
        end

        for v165, v166 in t21 do
            if v165.Parent then
                v165.Intensity = v166
            end
        end

        table.clear(t21)
    end
end

local v167 = Color3.fromRGB(42, 40, 54)
local t23 = {
    Unlocked = Color3.fromRGB(110, 200, 118),
    Available = Color3.fromRGB(235, 180, 60),
    Locked = Color3.fromRGB(64, 62, 76)
}
local v168 = Color3.fromRGB(242, 238, 228)
local t24 = {}

local function buildMarker(p40) -- line: 1173
    -- upvalues: Colors (copy)
    local Frame = Instance.new("Frame")

    Frame.Name = "Marker"
    Frame.AnchorPoint = Vector2.new(0.5, 0.5)
    Frame.Position = UDim2.fromScale(0.86, 0.86)
    Frame.Size = UDim2.fromScale(0.42, 0.42)
    Frame.BorderSizePixel = 0
    Frame.ZIndex = 3
    Frame.Parent = p40

    local UICorner = Instance.new("UICorner")

    UICorner.CornerRadius = UDim.new(0.5, 0)
    UICorner.Parent = Frame

    local UIStroke = Instance.new("UIStroke")

    UIStroke.Thickness = 3
    UIStroke.Color = Colors.Navy
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    UIStroke.Parent = Frame

    local Frame2 = Instance.new("Frame")

    Frame2.Name = "Lock"
    Frame2.BackgroundTransparency = 1
    Frame2.Size = UDim2.fromScale(1, 1)
    Frame2.ZIndex = 4
    Frame2.Parent = Frame

    local Frame3 = Instance.new("Frame")

    Frame3.AnchorPoint = Vector2.new(0.5, 0)
    Frame3.Position = UDim2.fromScale(0.5, 0.46)
    Frame3.Size = UDim2.fromScale(0.5, 0.32)
    Frame3.BackgroundColor3 = Color3.new(1, 1, 1)
    Frame3.BorderSizePixel = 0
    Frame3.ZIndex = 5
    Frame3.Parent = Frame2

    local UICorner2 = Instance.new("UICorner")

    UICorner2.CornerRadius = UDim.new(0.2, 0)
    UICorner2.Parent = Frame3

    local Frame4 = Instance.new("Frame")

    Frame4.AnchorPoint = Vector2.new(0.5, 0)
    Frame4.Position = UDim2.fromScale(0.5, 0.2)
    Frame4.Size = UDim2.fromScale(0.32, 0.4)
    Frame4.BackgroundTransparency = 1
    Frame4.ZIndex = 5
    Frame4.Parent = Frame2

    local UICorner3 = Instance.new("UICorner")

    UICorner3.CornerRadius = UDim.new(0.5, 0)
    UICorner3.Parent = Frame4

    local UIStroke2 = Instance.new("UIStroke")

    UIStroke2.Thickness = 4
    UIStroke2.Color = Color3.new(1, 1, 1)
    UIStroke2.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    UIStroke2.Parent = Frame4

    local Frame5 = Instance.new("Frame")

    Frame5.Name = "Check"
    Frame5.BackgroundTransparency = 1
    Frame5.Size = UDim2.fromScale(1, 1)
    Frame5.ZIndex = 4
    Frame5.Parent = Frame

    for _, v169 in {
            { 0.36, 0.56, 0.3, 45 },
            { 0.58, 0.48, 0.52, -50 }
        } do
        local Frame = Instance.new("Frame")

        Frame.AnchorPoint = Vector2.new(0.5, 0.5)
        Frame.Position = UDim2.fromScale(v169[1], v169[2])
        Frame.Size = UDim2.fromScale(v169[3], 0.13)
        Frame.Rotation = v169[4]
        Frame.BackgroundColor3 = Color3.new(1, 1, 1)
        Frame.BorderSizePixel = 0
        Frame.ZIndex = 5
        Frame.Parent = Frame5
    end

    return Frame
end

local Folder2
local t25 = {}

local function clearNodeIcons() -- line: 1246
    -- upvalues: t24 (copy), t25 (copy)
    for _, v170 in t25 do
        v170.Gui:Destroy()
    end

    table.clear(t25)
    table.clear(t24)
end

local function nodeIcon(p41, p42, p43) -- line: 1253
    -- upvalues: PlayerGui (copy), SkillIcons (copy), t23 (copy), v168 (copy), t24 (copy), buildMarker (copy), Folder2 (ref), t25 (copy)
    if not (Folder2 and Folder2.Parent) then
        Folder2 = Instance.new("Folder")
        Folder2.Name = "SkillTreeIcons"
        Folder2.Parent = PlayerGui
    end

    local v171 = t25[p41]
    local v172

    if v171 and v171.Gui.Parent and v171.Gui.Adornee == p42 then
        v172 = v171
    else
        if v171 then
            v171.Gui:Destroy()
        end

        local SurfaceGui = Instance.new("SurfaceGui")

        SurfaceGui.Name = p41.Name
        SurfaceGui.Adornee = p42

        local v173 = Enum.NormalId.Top
        local n9 = -2

        for _, v174 in Enum.NormalId:GetEnumItems() do
            local v175 = p42.CFrame:VectorToWorldSpace(Vector3.FromNormalId(v174))

            if n9 < v175.Y then
                v173 = v174
                n9 = v175.Y
            end
        end

        SurfaceGui.Face = v173
        SurfaceGui.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
        SurfaceGui.PixelsPerStud = 160
        SurfaceGui.LightInfluence = 0
        SurfaceGui.ZOffset = 2
        SurfaceGui.ResetOnSpawn = false

        local Frame = Instance.new("Frame")

        Frame.Name = "Badge"
        Frame.AnchorPoint = Vector2.new(0.5, 0.5)
        Frame.Position = UDim2.fromScale(0.5, 0.5)
        Frame.Size = UDim2.fromScale(0.96, 0.96)
        Frame.BackgroundColor3 = v168
        Frame.BackgroundTransparency = 1
        Frame.Parent = SurfaceGui

        local UIScale = Instance.new("UIScale")

        UIScale.Name = "Pulse"
        UIScale.Parent = Frame

        local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")

        UIAspectRatioConstraint.AspectType = Enum.AspectType.FitWithinMaxSize
        UIAspectRatioConstraint.Parent = Frame

        local UICorner = Instance.new("UICorner")

        UICorner.CornerRadius = UDim.new(0.5, 0)
        UICorner.Parent = Frame

        local UIStroke = Instance.new("UIStroke")

        UIStroke.Thickness = 6
        UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        UIStroke.Enabled = false
        UIStroke.Parent = Frame

        local ImageLabel = Instance.new("ImageLabel")

        ImageLabel.Name = "Icon"
        ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
        ImageLabel.Position = UDim2.fromScale(0.5, 0.5)
        ImageLabel.Size = UDim2.fromScale(1, 1)
        ImageLabel.BackgroundTransparency = 1
        ImageLabel.ScaleType = Enum.ScaleType.Fit
        ImageLabel.Parent = Frame

        local v176 = p42.CFrame:VectorToObjectSpace((Vector3.new(1, 0, 0)))

        Frame.Rotation = math.deg((math.atan2(v176.X, v176.Z))) - 90 + 0

        local v178 = buildMarker(Frame)

        SurfaceGui.Parent = Folder2
        v172 = {
            Gui = SurfaceGui,
            Ring = UIStroke,
            Image = ImageLabel,
            Badge = Frame,
            Marker = v178,
            Pulse = Frame.Pulse
        }
        t25[p41] = v172
    end

    v172.Image.Image = SkillIcons.For(p41.Name)
    v172.Ring.Color = t23[p43] or t23.Locked
    v172.Image.ImageTransparency = p43 == "Locked" and 0.3 or 0

    local Image = v172.Image

    if p43 == "Locked" then
        Image.ImageColor3 = Color3.fromRGB(150, 148, 160)
    else
        Image.ImageColor3 = Color3.new(1, 1, 1)
    end

    v172.Marker.Visible = p43 ~= "Available"

    local Marker = v172.Marker

    if p43 == "Unlocked" then
        Marker.BackgroundColor3 = Color3.fromRGB(90, 186, 100)
    else
        Marker.BackgroundColor3 = Color3.fromRGB(46, 44, 56)
    end

    v172.Marker.Lock.Visible = p43 == "Locked"
    v172.Marker.Check.Visible = p43 == "Unlocked"

    if p43 == "Available" then
        t24[v172.Pulse] = true
    else
        t24[v172.Pulse] = nil
        v172.Pulse.Scale = 1
    end
end

Color3.fromRGB(196, 146, 46)
Color3.fromRGB(120, 86, 28)

local t26 = {}
local t27 = {}

local function remember(p44, p45) -- line: 1341
    -- upvalues: t26 (copy)
    local v179 = t26[p44]

    if not v179 then
        v179 = {}
        t26[p44] = v179
    end

    for _, v180 in p45 do
        if v179[v180] == nil then
            v179[v180] = p44[v180]
        end
    end

    return v179
end

local function nodeState(p46) -- line: 1354
    -- upvalues: LocalPlayer (copy), BoxingSkills (copy), Stats (copy)
    if BoxingSkills.Has(LocalPlayer, p46) then
        return "Unlocked"
    end

    if BoxingSkills.List[p46] then
        local v181, v182, v183 = BoxingSkills.Check(LocalPlayer, p46, Stats)

        if v181 and v182 and v183 then
            return "Available"
        end
    end

    return "Locked"
end

function styleBoard(p47) -- line: 1366
    -- upvalues: LocalPlayer (copy), BoxingSkills (copy), Stats (copy), v167 (copy), clearNodeIcons (copy), nodeIcon (copy), t26 (copy), t27 (copy), remember (copy)
    table.clear(t27)

    local v184 = workspace:FindFirstChild("Skill tree")

    if not p47 or not v184 then
        clearNodeIcons()

        for v185, v186 in t26 do
            if v185.Parent then
                for v187, v188 in v186 do
                    v185[v187] = v188
                end
            end
        end

        table.clear(t26)
    else
        for _, child in v184:GetChildren() do
            local v189 = child:IsA("Model") and child:FindFirstChild("Inner")
            local v190 = child:IsA("Model") and child:FindFirstChild("Outter")

            if v189 and v190 and v189:IsA("BasePart") and v190:IsA("BasePart") then
                local v191 = remember(v189, { "Color", "Material" })
                local v192 = remember(v190, { "Color", "Material" })

                v190.Material = Enum.Material.SmoothPlastic

                local Name = child.Name
                local v193 = "Locked"

                if BoxingSkills.Has(LocalPlayer, Name) then
                    v193 = "Unlocked"
                elseif BoxingSkills.List[Name] then
                    local v194, v195, v196 = BoxingSkills.Check(LocalPlayer, Name, Stats)

                    v193 = if v194 and v195 and v196 then "Available" else "Locked"
                end

                nodeIcon(child, v189, v193)
                v189.Material = v191.Material
                v189.Color = v191.Color:Lerp(Color3.new(1, 1, 1), 0.12)

                if v193 == "Locked" then
                    v190.Color = v192.Color:Lerp(v167, 0.75)
                else
                    v190.Color = v191.Color:Lerp(Color3.new(0, 0, 0), 0.45)
                end
            end
        end
    end
end

RunService.Heartbeat:Connect(function() -- line: 1404
    -- upvalues: v42 (ref), t24 (copy)
    if not v42 or next(t24) == nil then
        return
    end

    local v199 = math.sin(os.clock() * 4) * 0.07 + 1

    for v200 in t24 do
        if v200.Parent then
            v200.Scale = v199
        else
            t24[v200] = nil
        end
    end
end)

local t28 = {}
local t29
local BackpackLock = require(Boxing:WaitForChild("BackpackLock"))

local function openTree() -- line: 1423
    -- upvalues: RunService (copy), TweenService (copy), PlayerGui (copy), BoxingCamera (copy), CurrentCamera (copy), t1 (ref), readGraph (copy), ScreenGui (copy), StatsGui (copy), clone (copy), Position (copy), updateScale (copy), v42 (ref), v43 (ref), v44 (ref), refreshHeader (copy), styleBoard (ref), holdCamera (copy), goTo (copy), setFrozen (copy), ScreenGui2 (copy), MangaTransition (copy), setDimmed (copy), t28 (copy), t29 (ref), BackpackLock (copy)
    if v42 or v43 or StatsGui.Enabled then
        return
    end

    local v201 = next(t1) == nil
    local v202

    if v201 then
        readGraph()
        v202 = next(t1) == nil
    end

    if v201 and v202 then
        warn("SkillTreeController: the skill tree layout hasn't loaded")

        return
    end

    v42 = true
    setFrozen(true)
    BoxingCamera.SetSuspended(true, "SkillTreeController")

    local function v203() -- line: 1439
        -- upvalues: RunService (copy), TweenService (copy), PlayerGui (copy), CurrentCamera (copy), ScreenGui (copy), clone (copy), Position (copy), updateScale (copy), v44 (ref), refreshHeader (copy), styleBoard (ref), holdCamera (copy), goTo (copy), ScreenGui2 (copy), setDimmed (copy), t28 (copy), t29 (ref), BackpackLock (copy)
        t29 = {
            Type = CurrentCamera.CameraType,
            CFrame = CurrentCamera.CFrame,
            FieldOfView = CurrentCamera.FieldOfView
        }
        table.clear(t28)

        for _, child in PlayerGui:GetChildren() do
            if child:IsA("ScreenGui") and child ~= ScreenGui and child ~= ScreenGui2 and child.Enabled and child.Name ~= "TouchGui" then
                child.Enabled = false
                table.insert(t28, child)
            end
        end

        BackpackLock.Lock("SkillTree")
        updateScale()
        refreshHeader()
        setDimmed(true)
        styleBoard(true)
        goTo(v44, true)
        RunService:BindToRenderStep("SkillTreeCamera", Enum.RenderPriority.Camera.Value + 10, holdCamera)
        holdCamera()
        ScreenGui.Enabled = true
        clone.Position = Position - UDim2.fromOffset(0, 220)
        task.delay(0.15, function() -- line: 1459
            -- upvalues: TweenService (copy), clone (copy), Position (copy)
            TweenService:Create(clone, TweenInfo.new(0.55, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Position = Position
            }):Play()
        end)
    end

    v43 = true
    MangaTransition.Play(v203)
    v43 = false
end

local function closeTree(p48) -- line: 1465
    -- upvalues: ContextActionService (copy), RunService (copy), BoxingCamera (copy), SkillRemote (copy), CurrentCamera (copy), ScreenGui (copy), t7 (copy), v42 (ref), v43 (ref), v45 (ref), t9 (ref), Folder (copy), t12 (copy), t13 (copy), Highlight (copy), v102 (copy), styleBoard (ref), restoreBeams (copy), Highlight2 (copy), MangaTransition (copy), ColorCorrectionEffect (ref), t21 (copy), t22 (copy), t28 (copy), t29 (ref), BackpackLock (copy)
    if not v42 or v43 then
        return
    end

    local function v205() -- line: 1469
        -- upvalues: ContextActionService (copy), RunService (copy), BoxingCamera (copy), SkillRemote (copy), CurrentCamera (copy), ScreenGui (copy), t7 (copy), v42 (ref), v45 (ref), t9 (ref), Folder (copy), t12 (copy), t13 (copy), Highlight (copy), v102 (copy), styleBoard (ref), restoreBeams (copy), Highlight2 (copy), ColorCorrectionEffect (ref), t21 (copy), t22 (copy), t28 (copy), t29 (ref), BackpackLock (copy)
        v42 = false
        SkillRemote:FireServer("Viewing", false)
        ScreenGui.Enabled = false
        Highlight2.Parent = nil
        Highlight.Parent = nil
        v102.Visible = false
        Folder:ClearAllChildren()
        table.clear(t12)
        table.clear(t13)
        table.clear(t7)
        Folder.Parent = nil
        restoreBeams()
        workspace:FindFirstChild("Skill tree")

        for v206, v207 in t22 do
            if v206.Parent then
                v206.Brightness = v207
            end
        end

        table.clear(t22)

        if ColorCorrectionEffect then
            ColorCorrectionEffect.Parent = nil
        end

        for v208, v209 in t21 do
            if v208.Parent then
                v208.Intensity = v209
            end
        end

        table.clear(t21)
        styleBoard(false)
        RunService:UnbindFromRenderStep("SkillTreeCamera")
        v45 = nil
        t9 = nil
        CurrentCamera.CameraType = t29 and t29.Type or Enum.CameraType.Custom

        if t29 then
            CurrentCamera.FieldOfView = t29.FieldOfView
            CurrentCamera.CFrame = t29.CFrame
        end

        for _, v210 in t28 do
            if v210.Parent then
                v210.Enabled = true
            end
        end

        table.clear(t28)
        BackpackLock.Unlock("SkillTree")
        ContextActionService:UnbindAction("SkillTreeFreeze")
        BoxingCamera.SetSuspended(false, "SkillTreeController")
    end

    v43 = true
    MangaTransition.Play(v205)
    v43 = false

    if p48 then
        p48()
    end
end

if BackButton then
    BackButton.Activated:Connect(function() -- line: 1501
        -- upvalues: ContextActionService (copy), RunService (copy), BoxingCamera (copy), SkillRemote (copy), CurrentCamera (copy), ScreenGui (copy), t7 (copy), playSound (copy), v42 (ref), v43 (ref), v45 (ref), t9 (ref), Folder (copy), t12 (copy), t13 (copy), Highlight (copy), v102 (copy), styleBoard (ref), restoreBeams (copy), Highlight2 (copy), MangaTransition (copy), ColorCorrectionEffect (ref), t21 (copy), t22 (copy), t28 (copy), t29 (ref), BackpackLock (copy)
        if v42 and not v43 then
            playSound("StatsOpen")
        end

        if not v42 or v43 then
            return
        end

        local function v211() -- line: 1469
            -- upvalues: ContextActionService (copy), RunService (copy), BoxingCamera (copy), SkillRemote (copy), CurrentCamera (copy), ScreenGui (copy), t7 (copy), v42 (ref), v45 (ref), t9 (ref), Folder (copy), t12 (copy), t13 (copy), Highlight (copy), v102 (copy), styleBoard (ref), restoreBeams (copy), Highlight2 (copy), ColorCorrectionEffect (ref), t21 (copy), t22 (copy), t28 (copy), t29 (ref), BackpackLock (copy)
            v42 = false
            SkillRemote:FireServer("Viewing", false)
            ScreenGui.Enabled = false
            Highlight2.Parent = nil
            Highlight.Parent = nil
            v102.Visible = false
            Folder:ClearAllChildren()
            table.clear(t12)
            table.clear(t13)
            table.clear(t7)
            Folder.Parent = nil
            restoreBeams()
            workspace:FindFirstChild("Skill tree")

            for v212, v213 in t22 do
                if v212.Parent then
                    v212.Brightness = v213
                end
            end

            table.clear(t22)

            if ColorCorrectionEffect then
                ColorCorrectionEffect.Parent = nil
            end

            for v214, v215 in t21 do
                if v214.Parent then
                    v214.Intensity = v215
                end
            end

            table.clear(t21)
            styleBoard(false)
            RunService:UnbindFromRenderStep("SkillTreeCamera")
            v45 = nil
            t9 = nil
            CurrentCamera.CameraType = t29 and t29.Type or Enum.CameraType.Custom

            if t29 then
                CurrentCamera.FieldOfView = t29.FieldOfView
                CurrentCamera.CFrame = t29.CFrame
            end

            for _, v216 in t28 do
                if v216.Parent then
                    v216.Enabled = true
                end
            end

            table.clear(t28)
            BackpackLock.Unlock("SkillTree")
            ContextActionService:UnbindAction("SkillTreeFreeze")
            BoxingCamera.SetSuspended(false, "SkillTreeController")
        end

        v43 = true
        MangaTransition.Play(v211)
        v43 = false
    end)
end

if clone2 then
    local Activated = clone2:FindFirstChild("Statistics")

    if Activated then
        Activated.Activated:Connect(function() -- line: 1511
            -- upvalues: ContextActionService (copy), RunService (copy), BoxingCamera (copy), SkillRemote (copy), CurrentCamera (copy), ScreenGui (copy), StatsGui (copy), t7 (copy), playSound (copy), v42 (ref), v43 (ref), v45 (ref), t9 (ref), Folder (copy), t12 (copy), t13 (copy), Highlight (copy), v102 (copy), styleBoard (ref), restoreBeams (copy), Highlight2 (copy), MangaTransition (copy), ColorCorrectionEffect (ref), t21 (copy), t22 (copy), t28 (copy), t29 (ref), BackpackLock (copy)
            if v42 and not v43 then
                playSound("StatsOpen")

                local function v218() -- line: 1516
                    -- upvalues: StatsGui (copy)
                    local Open = StatsGui:FindFirstChild("Open")

                    if Open then
                        Open:Fire()
                    end
                end

                if not v42 or v43 then
                    return
                end

                local function v219() -- line: 1469
                    -- upvalues: ContextActionService (copy), RunService (copy), BoxingCamera (copy), SkillRemote (copy), CurrentCamera (copy), ScreenGui (copy), t7 (copy), v42 (ref), v45 (ref), t9 (ref), Folder (copy), t12 (copy), t13 (copy), Highlight (copy), v102 (copy), styleBoard (ref), restoreBeams (copy), Highlight2 (copy), ColorCorrectionEffect (ref), t21 (copy), t22 (copy), t28 (copy), t29 (ref), BackpackLock (copy)
                    v42 = false
                    SkillRemote:FireServer("Viewing", false)
                    ScreenGui.Enabled = false
                    Highlight2.Parent = nil
                    Highlight.Parent = nil
                    v102.Visible = false
                    Folder:ClearAllChildren()
                    table.clear(t12)
                    table.clear(t13)
                    table.clear(t7)
                    Folder.Parent = nil
                    restoreBeams()
                    workspace:FindFirstChild("Skill tree")

                    for v220, v221 in t22 do
                        if v220.Parent then
                            v220.Brightness = v221
                        end
                    end

                    table.clear(t22)

                    if ColorCorrectionEffect then
                        ColorCorrectionEffect.Parent = nil
                    end

                    for v222, v223 in t21 do
                        if v222.Parent then
                            v222.Intensity = v223
                        end
                    end

                    table.clear(t21)
                    styleBoard(false)
                    RunService:UnbindFromRenderStep("SkillTreeCamera")
                    v45 = nil
                    t9 = nil
                    CurrentCamera.CameraType = t29 and t29.Type or Enum.CameraType.Custom

                    if t29 then
                        CurrentCamera.FieldOfView = t29.FieldOfView
                        CurrentCamera.CFrame = t29.CFrame
                    end

                    for _, v224 in t28 do
                        if v224.Parent then
                            v224.Enabled = true
                        end
                    end

                    table.clear(t28)
                    BackpackLock.Unlock("SkillTree")
                    ContextActionService:UnbindAction("SkillTreeFreeze")
                    BoxingCamera.SetSuspended(false, "SkillTreeController")
                end

                v43 = true
                MangaTransition.Play(v219)
                v43 = false

                if v218 then
                    local Open = StatsGui:FindFirstChild("Open")

                    if Open then
                        Open:Fire()
                    end
                end
            end
        end)
    end

    Activated = clone2:FindFirstChild("SkillTree")

    if Activated then
        Activated.Activated:Connect(function() -- line: 1527
            -- upvalues: ContextActionService (copy), RunService (copy), BoxingCamera (copy), SkillRemote (copy), CurrentCamera (copy), ScreenGui (copy), t7 (copy), playSound (copy), v42 (ref), v43 (ref), v45 (ref), t9 (ref), Folder (copy), t12 (copy), t13 (copy), Highlight (copy), v102 (copy), styleBoard (ref), restoreBeams (copy), Highlight2 (copy), MangaTransition (copy), ColorCorrectionEffect (ref), t21 (copy), t22 (copy), t28 (copy), t29 (ref), BackpackLock (copy)
            if v42 and not v43 then
                playSound("StatsOpen")
            end

            if not v42 or v43 then
                return
            end

            local function v225() -- line: 1469
                -- upvalues: ContextActionService (copy), RunService (copy), BoxingCamera (copy), SkillRemote (copy), CurrentCamera (copy), ScreenGui (copy), t7 (copy), v42 (ref), v45 (ref), t9 (ref), Folder (copy), t12 (copy), t13 (copy), Highlight (copy), v102 (copy), styleBoard (ref), restoreBeams (copy), Highlight2 (copy), ColorCorrectionEffect (ref), t21 (copy), t22 (copy), t28 (copy), t29 (ref), BackpackLock (copy)
                v42 = false
                SkillRemote:FireServer("Viewing", false)
                ScreenGui.Enabled = false
                Highlight2.Parent = nil
                Highlight.Parent = nil
                v102.Visible = false
                Folder:ClearAllChildren()
                table.clear(t12)
                table.clear(t13)
                table.clear(t7)
                Folder.Parent = nil
                restoreBeams()
                workspace:FindFirstChild("Skill tree")

                for v226, v227 in t22 do
                    if v226.Parent then
                        v226.Brightness = v227
                    end
                end

                table.clear(t22)

                if ColorCorrectionEffect then
                    ColorCorrectionEffect.Parent = nil
                end

                for v228, v229 in t21 do
                    if v228.Parent then
                        v228.Intensity = v229
                    end
                end

                table.clear(t21)
                styleBoard(false)
                RunService:UnbindFromRenderStep("SkillTreeCamera")
                v45 = nil
                t9 = nil
                CurrentCamera.CameraType = t29 and t29.Type or Enum.CameraType.Custom

                if t29 then
                    CurrentCamera.FieldOfView = t29.FieldOfView
                    CurrentCamera.CFrame = t29.CFrame
                end

                for _, v230 in t28 do
                    if v230.Parent then
                        v230.Enabled = true
                    end
                end

                table.clear(t28)
                BackpackLock.Unlock("SkillTree")
                ContextActionService:UnbindAction("SkillTreeFreeze")
                BoxingCamera.SetSuspended(false, "SkillTreeController")
            end

            v43 = true
            MangaTransition.Play(v225)
            v43 = false
        end)
    end
end

local v231, v232, v233

local function missingFor(p49) -- line: 1540
    -- upvalues: LocalPlayer (copy), BoxingSkills (copy), Stats (copy), MenuStyle (copy)
    local v234 = BoxingSkills.List[p49]
    local t30 = {}

    if v234 then
        local Amber = MenuStyle.Hex.Amber
        local v235 = table.clone(Stats.Names)

        for v236 in v234.Stats or {} do
            if not table.find(v235, v236) then
                table.insert(v235, v236)
            end
        end

        for _, v237 in v235 do
            local v238 = (v234.Stats or {})[v237]

            if v238 and v238 > 0 then
                local v239 = LocalPlayer:GetAttribute("Stat_" .. v237) or 0

                if v239 + 1E-06 < v238 then
                    local format = string.format
                    local v241 = string.format("%.2f", math.floor(v238 * 100 + 1E-04) / 100)
                    local v242 = string.gsub(v241, "0+$", "")
                    local v243 = string.gsub(v242, "%.$", "")
                    local v245 = string.format("%.2f", math.floor(v239 * 100 + 1E-04) / 100)
                    local v246 = string.gsub(v245, "0+$", "")

                    table.insert(t30, format("%s <font color=\"%s\">%s</font>  (you have %s)", v237, Amber, v243, (string.gsub(v246, "%.$", ""))))
                end
            end
        end

        local v248 = BoxingSkills.Unlocked(LocalPlayer)

        for _, v249 in v234.Requires or {} do
            if not v248[v249] then
                table.insert(t30, string.format("Unlock <font color=\"%s\">%s</font> first", Amber, v249))
            end
        end

        local v250 = v234.Cost or 0
        local SkillPoints = LocalPlayer:GetAttribute("SkillPoints")

        if SkillPoints == nil then
            SkillPoints = BoxingSkills.Earned(LocalPlayer, Stats) - BoxingSkills.Spent(BoxingSkills.Unlocked(LocalPlayer))
        end

        if SkillPoints < v250 then
            table.insert(t30, string.format("<font color=\"%s\">%d</font> skill point%s  (you have %d)", Amber, v250, if v250 == 1 then "" else "s", (math.max(SkillPoints, 0))))
        end
    end

    return t30
end

local function buildNeeds() -- line: 1576
    -- upvalues: v7 (copy), MenuStyle (copy), Colors (copy), ScreenGui (copy), text (copy), t4 (copy), updateScale (copy), playSound (copy)
    local Frame = Instance.new("Frame")

    Frame.Name = "NeedsPopup"
    Frame.AnchorPoint = Vector2.new(0.5, 0.5)
    Frame.Position = UDim2.fromScale(0.5, 0.5)
    Frame.Size = UDim2.fromOffset(580, 340)
    Frame.ZIndex = 50
    Frame.Visible = false

    local UIScale = Instance.new("UIScale")

    UIScale.Parent = Frame
    table.insert(t4, UIScale)

    local v253 = text(Frame, "Title", 22, {
        Text = "CAN'T UNLOCK YET",
        ZIndex = 52,
        Position = UDim2.fromOffset(22, 20),
        Size = UDim2.new(1, -44, 0, 34)
    })

    MenuStyle.Text(v253, {
        Size = 22,
        Stroke = 3,
        Color = v7
    })

    local v254 = text(Frame, "Body", 22, {
        RichText = true,
        TextWrapped = true,
        TextScaled = true,
        ZIndex = 52,
        Position = UDim2.fromOffset(26, 66),
        Size = UDim2.new(1, -52, 1, -150),
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top
    })
    local UITextSizeConstraint = Instance.new("UITextSizeConstraint")

    UITextSizeConstraint.MaxTextSize = 24
    UITextSizeConstraint.MinTextSize = 10
    UITextSizeConstraint.Parent = v254

    local TextButton = Instance.new("TextButton")

    TextButton.Name = "OK"
    TextButton.AnchorPoint = Vector2.new(0.5, 1)
    TextButton.Position = UDim2.new(0.5, 0, 1, -18)
    TextButton.Size = UDim2.fromOffset(220, 56)
    TextButton.Text = "OK"
    TextButton.ZIndex = 52
    TextButton.Parent = Frame
    MenuStyle.Panel(Frame, {
        Accent = Colors.Red
    })
    MenuStyle.Button(TextButton, {
        MaxText = 18
    })
    TextButton.Activated:Connect(function() -- line: 1616
        -- upvalues: Frame (copy), playSound (copy)
        playSound("TabClick")
        Frame.Visible = false
    end)
    Frame.Parent = ScreenGui
    updateScale()

    return Frame, v253, v254
end

local function needsShowing() -- line: 1625
    -- upvalues: v231 (ref)
    return v231 ~= nil and v231.Visible
end

local function showNeeds(p50, p51) -- line: 1630
    -- upvalues: BoxingSkills (copy), MenuStyle (copy), n1 (ref), playSound (copy), v231 (ref), v232 (ref), v233 (ref), missingFor (copy), buildNeeds (copy)
    local v255 = missingFor(p50)

    if #v255 == 0 then
        if not p51 then
            return
        end

        v255 = { "Your stats are still updating - try again in a moment" }
    end

    if not v231 then
        v231, v232, v233 = buildNeeds()
    end

    local v256 = BoxingSkills.List[p50]
    local v257 = v233

    v257.Text = string.format("To unlock <font color=\"%s\">%s</font> you still need:", MenuStyle.Hex.Lilac, v256 and v256.Display or p50) .. "\n• " .. table.concat(v255, "\n• ")
    v231.Visible = true
    MenuStyle.KeepReadable(v231, n1)
    playSound("TabClick")
end

local n10 = 0

local function hideNeeds() -- line: 1650
    -- upvalues: playSound (copy), v231 (ref), n10 (ref)
    if v231 == nil or not v231.Visible then
        return false
    end

    v231.Visible = false
    n10 = os.clock()
    playSound("TabClick")

    return true
end

ScreenGui:GetPropertyChangedSignal("Enabled"):Connect(function() -- line: 1660
    -- upvalues: ScreenGui (copy), v231 (ref)
    if not ScreenGui.Enabled and v231 then
        v231.Visible = false
    end
end)
TextButton.Activated:Connect(function() -- line: 1666
    -- upvalues: LocalPlayer (copy), BoxingSkills (copy), SkillRemote (copy), Stats (copy), playSound (copy), v42 (ref), v43 (ref), v44 (ref), showNeeds (copy)
    if v42 and not v43 and not BoxingSkills.Has(LocalPlayer, v44) then
        local v258, v259, v260 = BoxingSkills.Check(LocalPlayer, v44, Stats)

        if not v258 or not v259 or not v260 then
            showNeeds(v44)

            return
        end

        playSound("StatsOpen")
        SkillRemote:FireServer("Unlock", v44)
    end
end)

local v262

local function buildConfirm() -- line: 1681
    -- upvalues: BoxingConfig (copy), SkillRemote (copy), v4 (copy), v5 (copy), MenuStyle (copy), Colors (copy), ScreenGui (copy), t4 (copy), updateScale (copy), playSound (copy)
    local Frame = Instance.new("Frame")

    Frame.Name = "ResetConfirm"
    Frame.AnchorPoint = Vector2.new(0.5, 0.5)
    Frame.Position = UDim2.fromScale(0.5, 0.5)
    Frame.Size = UDim2.fromOffset(540, 340)
    Frame.BackgroundColor3 = Color3.fromRGB(58, 58, 60)
    Frame.ZIndex = 50
    Frame.Visible = false

    local UICorner = Instance.new("UICorner")

    UICorner.CornerRadius = UDim.new(0, 12)
    UICorner.Parent = Frame

    local UIScale = Instance.new("UIScale")

    UIScale.Parent = Frame
    table.insert(t4, UIScale)
    updateScale()

    local function lightBox(p52, p53, p54) -- line: 1693
        -- upvalues: Frame (copy), v4 (copy), v5 (copy)
        local TextButton = Instance.new("TextButton")

        TextButton.Name = p52
        TextButton.AutoButtonColor = false
        TextButton.Position = p53
        TextButton.Size = p54
        TextButton.BackgroundColor3 = Color3.fromRGB(200, 200, 202)
        TextButton.FontFace = v4
        TextButton.TextColor3 = Color3.new(1, 1, 1)
        TextButton.TextScaled = true
        TextButton.ZIndex = 51

        local UICorner = Instance.new("UICorner")

        UICorner.CornerRadius = UDim.new(0, 8)
        UICorner.Parent = TextButton

        local UIStroke = Instance.new("UIStroke")

        UIStroke.Color = v5
        UIStroke.Thickness = 2
        UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
        UIStroke.Parent = TextButton

        local UIPadding = Instance.new("UIPadding")
        local v263 = UDim.new(0, 12)
        local v264 = UDim.new(0, 12)

        UIPadding.PaddingLeft = v263
        UIPadding.PaddingRight = v264

        local v265 = UDim.new(0, 8)
        local v266 = UDim.new(0, 8)

        UIPadding.PaddingTop = v265
        UIPadding.PaddingBottom = v266
        UIPadding.Parent = TextButton
        TextButton.Parent = Frame

        return TextButton
    end

    local v267 = lightBox("Message", UDim2.fromOffset(8, 8), UDim2.new(1, -16, 1, -80))

    v267.Active = false
    v267.Text = "Resetting your skills will refund all of your skill points and lock every skill except Boxing Basics. It costs " .. (BoxingConfig.Avatar and BoxingConfig.Avatar.ResetCost or 1) .. " reroll token. Are you sure you want to do this?"

    local v268 = lightBox("Cancel", UDim2.new(0, 8, 1, -64), UDim2.new(0.5, -12, 0, 56))

    v268.Text = "Cancel"

    local v269 = lightBox("Confirm", UDim2.new(0.5, 4, 1, -64), UDim2.new(0.5, -12, 0, 56))

    v269.Text = "Confirm"
    MenuStyle.Panel(Frame, {
        Accent = Colors.Red
    })

    for _, child in v267:GetChildren() do
        if child:IsA("UICorner") then
            child:Destroy()
        end
    end

    v267.BackgroundTransparency = 1
    MenuStyle.Text(v267, {
        Heading = false
    })

    local UITextSizeConstraint = Instance.new("UITextSizeConstraint")

    UITextSizeConstraint.MaxTextSize = 26
    UITextSizeConstraint.Parent = v267
    v268.Size = UDim2.new(0.5, -22, 0, 56)
    v269.Size = UDim2.new(0.5, -22, 0, 56)
    MenuStyle.Button(v268, {
        MaxText = 18
    })
    MenuStyle.Button(v269, {
        MaxText = 18,
        Accent = Colors.Red
    })
    v268.Activated:Connect(function() -- line: 1738
        -- upvalues: Frame (copy), playSound (copy)
        playSound("TabClick")
        Frame.Visible = false
    end)
    v269.Activated:Connect(function() -- line: 1742
        -- upvalues: Frame (copy), SkillRemote (copy), playSound (copy)
        playSound("StatsOpen")
        Frame.Visible = false
        SkillRemote:FireServer("Reset")
    end)
    Frame.Parent = ScreenGui

    return Frame
end

if ResetButton then
    ResetButton.Activated:Connect(function() -- line: 1751
        -- upvalues: Boxing (copy), playSound (copy), v43 (ref), v262 (ref), buildConfirm (copy)
        if v43 then
            return
        end

        playSound("StatsOpen")
        v262 = v262 or buildConfirm()
        v262.Visible = true
        require(Boxing:WaitForChild("PadFocus")).Into(v262)
    end)
end

local function unlockMoment(p55) -- line: 1769
    -- upvalues: Debris (copy), TweenService (copy), LocalPlayer (copy), BoxingSkills (copy), Stats (copy), MenuStyle (copy), Colors (copy), t1 (ref), ScreenGui (copy), updateScale (copy), playSound (copy), v39 (copy), v42 (ref), styleBoard (ref), beamBetween (copy), MangaTransition (copy)
    playSound("SkillUnlock", v39.SkillUnlock, v39.SkillUnlockVolume)

    local v270 = workspace:FindFirstChild("Skill tree")
    local v271 = v270 and v270:FindFirstChild(p55)
    local Inner = v271 and v271:FindFirstChild("Inner")
    local v272 = t1[p55]
    local Position = Inner and Inner.Position or v272 and v272.Position

    if Inner and Inner:IsA("BasePart") then
        local Color = Inner.Color

        Inner.Color = Color3.new(1, 1, 1)
        TweenService:Create(Inner, TweenInfo.new(0.7, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Color = Color
        }):Play()
    end

    if Position then
        local Part = Instance.new("Part")

        Part.Name = "SkillUnlockRing"
        Part.Shape = Enum.PartType.Cylinder
        Part.Material = Enum.Material.Neon
        Part.Color = Color3.new(1, 1, 1)
        Part.Anchored = true
        Part.CanCollide = false
        Part.CanQuery = false
        Part.CanTouch = false
        Part.CastShadow = false
        Part.Size = Vector3.new(0.05, 1.6, 1.6)
        Part.Transparency = 0.15
        Part.CFrame = CFrame.new(Position + Vector3.new(0, 0.45, 0)) * CFrame.Angles(0, 0, 1.5707963267948966)
        Part.Parent = workspace
        TweenService:Create(Part, TweenInfo.new(0.55, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Size = Vector3.new(0.05, 7.5, 7.5),
            Transparency = 1
        }):Play()

        local Attachment = Instance.new("Attachment")

        Attachment.Parent = Part

        local ParticleEmitter = Instance.new("ParticleEmitter")

        ParticleEmitter.Texture = "rbxasset://textures/particles/sparkles_main.dds"
        ParticleEmitter.Color = ColorSequence.new(Color3.new(1, 1, 1), Color3.fromRGB(255, 210, 90))
        ParticleEmitter.LightEmission = 1
        ParticleEmitter.LightInfluence = 0
        ParticleEmitter.Size = NumberSequence.new(0.7, 0)
        ParticleEmitter.Lifetime = NumberRange.new(0.45, 0.9)
        ParticleEmitter.Speed = NumberRange.new(8, 18)
        ParticleEmitter.SpreadAngle = Vector2.new(180, 180)
        ParticleEmitter.Drag = 5
        ParticleEmitter.Enabled = false
        ParticleEmitter.Parent = Attachment
        ParticleEmitter:Emit(46)
        Debris:AddItem(Part, 2)
    end

    local Frame = Instance.new("Frame")

    Frame.Name = "UnlockBanner"
    Frame.BackgroundTransparency = 1
    Frame.Size = UDim2.fromScale(1, 1)
    Frame.ZIndex = 30
    Frame.Parent = ScreenGui

    local Frame2 = Instance.new("Frame")

    Frame2.Name = "UnlockLines"
    Frame2.BackgroundTransparency = 1
    Frame2.Size = UDim2.fromScale(1, 1)
    Frame2.ZIndex = 0
    Frame2.Parent = ScreenGui
    MangaTransition.SpeedLines(Frame2, 1.7, Colors.Navy)
    task.delay(2.2, function() -- line: 1826
        -- upvalues: Frame2 (copy)
        Frame2:Destroy()
    end)

    local CanvasGroup = Instance.new("CanvasGroup")

    CanvasGroup.AnchorPoint = Vector2.new(0.5, 0.5)
    CanvasGroup.Position = UDim2.fromScale(0.5, 0.36)
    CanvasGroup.Size = UDim2.fromOffset(820, 190)
    CanvasGroup.BackgroundTransparency = 1
    CanvasGroup.Rotation = -4
    CanvasGroup.ZIndex = 31
    CanvasGroup.Parent = Frame

    local UIScale = Instance.new("UIScale")

    UIScale.Scale = updateScale()
    UIScale.Parent = CanvasGroup

    local Frame3 = Instance.new("Frame")

    Frame3.BackgroundTransparency = 1
    Frame3.Size = UDim2.fromScale(1, 1)
    Frame3.Parent = CanvasGroup

    local UIScale2 = Instance.new("UIScale")

    UIScale2.Scale = 2.6
    UIScale2.Parent = Frame3

    local Green, Green2 = MenuStyle.Tag(Frame3, "Tag", 86, "Green")

    Green.AnchorPoint = Vector2.new(0.5, 0)
    Green.Position = UDim2.fromScale(0.5, 0)
    Green2.Text = "SKILL UNLOCKED!"

    local v273 = BoxingSkills.List[p55]
    local TextLabel = Instance.new("TextLabel")

    TextLabel.BackgroundTransparency = 1
    TextLabel.AnchorPoint = Vector2.new(0.5, 0)
    TextLabel.Position = UDim2.new(0.5, 0, 0, 104)
    TextLabel.Size = UDim2.new(1, 0, 0, 44)
    TextLabel.Text = string.upper(v273 and v273.Display or p55)
    MenuStyle.Text(TextLabel, {
        Size = 30,
        Stroke = 4
    })
    TextLabel.Parent = Frame3
    TweenService:Create(UIScale2, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Scale = 1
    }):Play()
    task.spawn(function() -- line: 1861
        -- upvalues: Frame (copy), CanvasGroup (copy), UIScale2 (copy), TweenService (copy)
        task.wait(0.3)

        for i = 1, 6 do
            local v274 = (7 - i) * 2.2

            CanvasGroup.Position = UDim2.new(0.5, math.random(-v274, v274), 0.36, math.random(-v274, v274))
            task.wait(0.03)
        end

        CanvasGroup.Position = UDim2.fromScale(0.5, 0.36)
        task.wait(1.15)
        TweenService:Create(UIScale2, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Scale = 0.85
        }):Play()

        local tween = TweenService:Create(CanvasGroup, TweenInfo.new(0.25), {
            GroupTransparency = 1
        })

        tween:Play()
        tween.Completed:Wait()
        Frame:Destroy()
    end)

    local v275 = v270 and v270:FindFirstChild(p55)

    if v275 and v272 then
        for _, v276 in v272.Links do
            local v277 = v270:FindFirstChild(v276)

            if v277 then
                local v278 = "Locked"

                if BoxingSkills.Has(LocalPlayer, v276) then
                    v278 = "Unlocked"
                elseif BoxingSkills.List[v276] then
                    local v279, v280, v281 = BoxingSkills.Check(LocalPlayer, v276, Stats)

                    v278 = if v279 and v280 and v281 then "Available" else "Locked"
                end

                v277 = v278 == "Available" and beamBetween(v275, v277)
            end

            if v277 then
                local Brightness, Width0, Width1 = v277.Brightness, v277.Width0, v277.Width1

                v277.Brightness = 6

                local v282 = Width0 * 1.8
                local v283 = Width1 * 1.8

                v277.Width0 = v282
                v277.Width1 = v283
                TweenService:Create(v277, TweenInfo.new(1.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Brightness = Brightness,
                    Width0 = Width0,
                    Width1 = Width1
                }):Play()
            end
        end
    end

    task.delay(0.75, function() -- line: 1891
        -- upvalues: v42 (ref), styleBoard (ref)
        if v42 then
            styleBoard(true)
        end
    end)
end

local function refreshAll() -- line: 1899
    -- upvalues: v42 (ref), refreshHeader (copy), refreshPanel (copy), styleBoard (ref), buildArrows (copy), placeArrows (copy)
    refreshHeader()

    if not v42 then
        return
    end

    refreshPanel()
    buildArrows()
    placeArrows()
    styleBoard(true)
end

LocalPlayer:GetAttributeChangedSignal("Skills"):Connect(refreshAll)
LocalPlayer:GetAttributeChangedSignal("SkillPoints"):Connect(refreshAll)

for _, v284 in Stats.Names do
    LocalPlayer:GetAttributeChangedSignal("Stat_" .. v284):Connect(function() -- line: 1911
        -- upvalues: v42 (ref), refreshPanel (copy), styleBoard (ref)
        if v42 then
            refreshPanel()
            styleBoard(true)
        end
    end)
end

SkillRemote.OnClientEvent:Connect(function(p56, p57) -- line: 1918
    -- upvalues: TweenService (copy), v32 (copy), v42 (ref), v44 (ref), showNeeds (copy), unlockMoment (copy)
    if p56 == "UnlockDenied" and type(p57) == "string" then
        showNeeds(p57, true)

        return
    end

    if p56 == "Unlocked" and v42 and p57 == v44 then
        task.defer(unlockMoment, p57)
        v32.TextTransparency = 1
        TweenService:Create(v32, TweenInfo.new(0.25), {
            TextTransparency = 0
        }):Play()
    end
end)
refreshHeader()

local function hookButton() -- line: 1932
    -- upvalues: PlayerGui (copy), playSound (copy), v42 (ref), v43 (ref), openTree (copy)
    local v285 = PlayerGui:WaitForChild("BoxingHUD", 10)
    local v286 = v285 and v285:WaitForChild("SideMenu", 10)
    local v287 = v286 and v286:WaitForChild("SkillTree", 10)

    if v287 and not v287:GetAttribute("SkillTreeHooked") then
        v287:SetAttribute("SkillTreeHooked", true)
        v287.Activated:Connect(function() -- line: 1938
            -- upvalues: playSound (copy), v42 (ref), v43 (ref), openTree (copy)
            if not v42 and not v43 then
                playSound("StatsOpen")
            end

            openTree()
        end)
    end
end

task.spawn(hookButton)

local BoxingVirtualInput = require(ReplicatedStorage:WaitForChild("Boxing"):WaitForChild("BoxingVirtualInput"))
local t31 = {
    [Enum.KeyCode.DPadUp] = Vector2.new(0, 1),
    [Enum.KeyCode.DPadDown] = Vector2.new(0, -1),
    [Enum.KeyCode.DPadLeft] = Vector2.new(-1, 0),
    [Enum.KeyCode.DPadRight] = Vector2.new(1, 0)
}

local function confirmShowing() -- line: 1959
    -- upvalues: v262 (ref)
    return v262 ~= nil and v262.Visible
end

local function stepToward(p58) -- line: 1962
    -- upvalues: BoxingConfig (copy), t1 (ref), playSound (copy), v44 (ref), goTo (copy)
    local t32 = t1
    local v288 = t32[v44]

    if not v288 or p58.Magnitude < 0.001 then
        return
    end

    local Unit = p58.Unit
    local n11 = 0.35
    local v289

    for _, v290 in v288.Links do
        local v291 = t1[v290]

        if v291 then
            local v292 = v291.Position - v288.Position
            local v293 = Vector2.new(v292:Dot((Vector3.new(0, 0, 1))), v292:Dot((Vector3.new(1, 0, 0))))

            if v293.Magnitude > 0.001 then
                local v294 = v293.Unit:Dot(Unit)

                if n11 < v294 then
                    n11 = v294
                    v289 = v290
                end
            end
        end
    end

    if not v289 then
        return
    end

    playSound("Click", BoxingConfig.Loadout and BoxingConfig.Loadout.ClickSound, BoxingConfig.Loadout and BoxingConfig.Loadout.ClickVolume)
    goTo(v289)
end

local function padUnlock() -- line: 1987
    -- upvalues: LocalPlayer (copy), BoxingSkills (copy), SkillRemote (copy), Stats (copy), playSound (copy), v42 (ref), v43 (ref), v44 (ref), showNeeds (copy)
    if v42 and not v43 and not BoxingSkills.Has(LocalPlayer, v44) then
        local v296, v297, v298 = BoxingSkills.Check(LocalPlayer, v44, Stats)

        if not v296 or not v297 or not v298 then
            showNeeds(v44)

            return
        end

        playSound("StatsOpen")
        SkillRemote:FireServer("Unlock", v44)
    end
end

local v300 = Vector2.zero
local n12 = 0

UserInputService.InputBegan:Connect(function(p59) -- line: 2001
    -- upvalues: Boxing (copy), ResetButton (copy), playSound (copy), v42 (ref), v43 (ref), v46 (ref), v231 (ref), n10 (ref), v262 (ref), buildConfirm (copy), t31 (copy), stepToward (copy), padUnlock (copy)
    if v42 and not v43 and (v262 == nil or not v262.Visible) then
        if v231 ~= nil and v231.Visible then
            if (p59.KeyCode == Enum.KeyCode.ButtonA or p59.KeyCode == Enum.KeyCode.ButtonB) and v231 ~= nil and v231.Visible then
                v231.Visible = false
                n10 = os.clock()
                playSound("TabClick")
            end
        else
            local v302 = t31[p59.KeyCode]

            if v302 then
                stepToward(v302)
            elseif p59.KeyCode == Enum.KeyCode.ButtonA then
                padUnlock()
            elseif p59.KeyCode == Enum.KeyCode.ButtonX then
                if setOverview then
                    setOverview(not v46)
                end
            elseif p59.KeyCode == Enum.KeyCode.ButtonY and ResetButton then
                playSound("StatsOpen")
                v262 = v262 or buildConfirm()
                v262.Visible = true
                require(Boxing:WaitForChild("PadFocus")).Into(v262)
            end
        end
    end
end)
UserInputService.InputChanged:Connect(function(p60) -- line: 2031
    -- upvalues: v300 (ref)
    if p60.KeyCode == Enum.KeyCode.Thumbstick1 then
        v300 = Vector2.new(p60.Position.X, p60.Position.Y)
    end
end)
UserInputService.InputEnded:Connect(function(p61) -- line: 2036
    -- upvalues: v300 (ref)
    if p61.KeyCode == Enum.KeyCode.Thumbstick1 then
        v300 = Vector2.zero
    end
end)

local v303 = text(ScreenGui, "PadHint", 20, {
    Text = "LEFT STICK / D-PAD: MOVE   ·   A: UNLOCK   ·   X: ZOOM   ·   Y: RESET SKILLS   ·   B: BACK",
    Visible = false,
    ZIndex = 5,
    AnchorPoint = Vector2.new(0.5, 1),
    Position = UDim2.new(0.5, 0, 1, -18),
    Size = UDim2.fromOffset(0, 30),
    AutomaticSize = Enum.AutomaticSize.X
})

MenuStyle.Text(v303, {
    Size = 12
})
v303.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
v303.BackgroundTransparency = 0.2

local UIPadding4 = Instance.new("UIPadding")
local v304 = UDim.new(0, 14)
local v305 = UDim.new(0, 14)

UIPadding4.PaddingLeft = v304
UIPadding4.PaddingRight = v305
UIPadding4.Parent = v303

local TextButton2 = Instance.new("TextButton")

TextButton2.Name = "ZoomButton"
TextButton2.AnchorPoint = Vector2.new(0, 1)
TextButton2.Position = UDim2.new(0, 18, 1, -18)
TextButton2.Size = UDim2.fromOffset(190, 46)
TextButton2.Text = "ZOOM OUT"
TextButton2.ZIndex = 5
TextButton2.Parent = ScreenGui
MenuStyle.Button(TextButton2, {
    MaxText = 16
})
v304 = Instance.new("UIScale")
v304.Parent = TextButton2
table.insert(t4, v304)

local function paintZoom() -- line: 2074
    -- upvalues: MenuStyle (copy), v46 (ref), TextButton2 (copy)
    local v306 = TextButton2:FindFirstChild("MenuFace") and TextButton2.MenuFace:FindFirstChild("Label")

    if v306 then
        v306.Text = v46 and "ZOOM IN" or "ZOOM OUT"
    end

    MenuStyle.SetSelected(TextButton2, v46)
end

function setOverview(p62) -- line: 2081
    -- upvalues: BoxingConfig (copy), MenuStyle (copy), playSound (copy), v42 (ref), v43 (ref), v44 (ref), v45 (ref), t9 (ref), v46 (ref), nodeView (copy), overviewView (copy), TextButton2 (copy)
    local v307, v308

    if not v42 or v43 or p62 == v46 then
        v308 = true
    else
        v307 = if p62 then overviewView() else nodeView(v44)
        v308 = false
    end

    if v308 or not v307 then
        return
    end

    v46 = p62
    playSound("Click", BoxingConfig.Loadout and BoxingConfig.Loadout.ClickSound, BoxingConfig.Loadout and BoxingConfig.Loadout.ClickVolume)
    t9 = {
        Time = 0.63,
        From = v45 or v307,
        To = v307,
        Start = os.clock()
    }

    local v310 = TextButton2:FindFirstChild("MenuFace") and TextButton2.MenuFace:FindFirstChild("Label")

    if v310 then
        v310.Text = v46 and "ZOOM IN" or "ZOOM OUT"
    end

    MenuStyle.SetSelected(TextButton2, v46)
end

TextButton2.Activated:Connect(function() -- line: 2094
    -- upvalues: v46 (ref)
    setOverview(not v46)
end)
UserInputService.InputChanged:Connect(function(p63, p64) -- line: 2097
    -- upvalues: v42 (ref)
    if v42 and not p64 and p63.UserInputType == Enum.UserInputType.MouseWheel then
        if p63.Position.Z < 0 then
            setOverview(true)
        elseif p63.Position.Z > 0 then
            setOverview(false)
        end
    end
end)
UserInputService.TouchPinch:Connect(function(_, p66, _, p68, p69) -- line: 2109
    -- upvalues: v42 (ref)
    if v42 and not p69 and p68 == Enum.UserInputState.End then
        if p66 < 0.85 then
            setOverview(true)
        elseif p66 > 1.15 then
            setOverview(false)
        end
    end
end)

local t33
local v311 = false

local function setCeilingHidden(p70) -- line: 2124
    -- upvalues: t33 (ref), v311 (ref)
    if p70 == v311 then
        return
    end

    v311 = p70

    if not t33 then
        t33 = {}

        local MenuRooms = workspace:FindFirstChild("MenuRooms")

        for _, v312 in {
                MenuRooms and MenuRooms:FindFirstChild("SkillTreeDecor"),
                workspace:FindFirstChild("Skill tree")
            } do
            if v312 then
                for _, descendant in v312:GetDescendants() do
                    if descendant:IsA("BasePart") and descendant.Position.Y - descendant.Size.Y / 2 > 27.5 then
                        table.insert(t33, descendant)
                    end
                end
            end
        end
    end

    for _, v313 in t33 do
        if v313.Parent then
            v313.LocalTransparencyModifier = p70 and 1 or 0
        end
    end
end

RunService.Heartbeat:Connect(function() -- line: 2151
    -- upvalues: LocalPlayer (copy), MenuStyle (copy), v42 (ref), v43 (ref), v46 (ref), v262 (ref), BoxingVirtualInput (copy), stepToward (copy), v300 (ref), n12 (ref), v303 (copy), TextButton2 (copy), setCeilingHidden (copy)
    if TextButton2.Visible ~= v42 then
        TextButton2.Visible = v42
    end

    setCeilingHidden(v42 and v46)

    if v42 and TextButton2:FindFirstChild("MenuFace") and TextButton2.MenuFace:FindFirstChild("Label") and TextButton2.MenuFace.Label.Text ~= (if v46 then "ZOOM IN" else "ZOOM OUT") then
        local v314 = TextButton2:FindFirstChild("MenuFace") and TextButton2.MenuFace:FindFirstChild("Label")

        if v314 then
            v314.Text = v46 and "ZOOM IN" or "ZOOM OUT"
        end

        MenuStyle.SetSelected(TextButton2, v46)
    end

    local v315 = BoxingVirtualInput.Mode() == "Gamepad"
    local v316 = v42
    local v317, v318

    if v316 then
        if v315 then
            v317 = v262 ~= nil and v262.Visible
            v318 = not v317
        else
            v318 = v315
        end
    else
        v318 = v316
    end

    if LocalPlayer:GetAttribute("PadOwnNav") ~= (v318 or nil) then
        LocalPlayer:SetAttribute("PadOwnNav", v318 or nil)
    end

    v303.Visible = v42 and v315

    if not v318 or v43 then
        n12 = 0

        return
    end

    local v319 = v300.Magnitude > 0.6
    local elapsed, v320

    if v319 then
        elapsed = os.clock()
        v320 = n12 <= elapsed
    else
        n12 = 0
    end

    if (not v319 or v320) and v319 then
        n12 = elapsed + (n12 == 0 and 0.45 or 0.35)
        stepToward(v300)
    end
end)
require(ReplicatedStorage:WaitForChild("Boxing"):WaitForChild("BoxingVirtualInput")).Changed:Connect(function(p71, p72) -- line: 2182
    -- upvalues: ContextActionService (copy), RunService (copy), BoxingCamera (copy), SkillRemote (copy), CurrentCamera (copy), ScreenGui (copy), t7 (copy), playSound (copy), v42 (ref), v43 (ref), v45 (ref), t9 (ref), Folder (copy), t12 (copy), t13 (copy), Highlight (copy), v102 (copy), styleBoard (ref), restoreBeams (copy), Highlight2 (copy), MangaTransition (copy), ColorCorrectionEffect (ref), t21 (copy), t22 (copy), t28 (copy), t29 (ref), BackpackLock (copy), openTree (copy), v231 (ref), n10 (ref)
    if not p72 or v43 then
        return
    end

    if p71 == "SkillTree" and not v42 then
        playSound("StatsOpen")
        openTree()

        return
    end

    if p71 == "Back" and v42 and (v231 ~= nil and v231.Visible or os.clock() - n10 < 0.25) then
        return
    end

    if (p71 == "Back" or p71 == "SkillTree") and v42 then
        playSound("StatsOpen")

        if v42 then
            if v43 then
                return
            end

            local function v321() -- line: 1469
                -- upvalues: ContextActionService (copy), RunService (copy), BoxingCamera (copy), SkillRemote (copy), CurrentCamera (copy), ScreenGui (copy), t7 (copy), v42 (ref), v45 (ref), t9 (ref), Folder (copy), t12 (copy), t13 (copy), Highlight (copy), v102 (copy), styleBoard (ref), restoreBeams (copy), Highlight2 (copy), ColorCorrectionEffect (ref), t21 (copy), t22 (copy), t28 (copy), t29 (ref), BackpackLock (copy)
                v42 = false
                SkillRemote:FireServer("Viewing", false)
                ScreenGui.Enabled = false
                Highlight2.Parent = nil
                Highlight.Parent = nil
                v102.Visible = false
                Folder:ClearAllChildren()
                table.clear(t12)
                table.clear(t13)
                table.clear(t7)
                Folder.Parent = nil
                restoreBeams()
                workspace:FindFirstChild("Skill tree")

                for v322, v323 in t22 do
                    if v322.Parent then
                        v322.Brightness = v323
                    end
                end

                table.clear(t22)

                if ColorCorrectionEffect then
                    ColorCorrectionEffect.Parent = nil
                end

                for v324, v325 in t21 do
                    if v324.Parent then
                        v324.Intensity = v325
                    end
                end

                table.clear(t21)
                styleBoard(false)
                RunService:UnbindFromRenderStep("SkillTreeCamera")
                v45 = nil
                t9 = nil
                CurrentCamera.CameraType = t29 and t29.Type or Enum.CameraType.Custom

                if t29 then
                    CurrentCamera.FieldOfView = t29.FieldOfView
                    CurrentCamera.CFrame = t29.CFrame
                end

                for _, v326 in t28 do
                    if v326.Parent then
                        v326.Enabled = true
                    end
                end

                table.clear(t28)
                BackpackLock.Unlock("SkillTree")
                ContextActionService:UnbindAction("SkillTreeFreeze")
                BoxingCamera.SetSuspended(false, "SkillTreeController")
            end

            v43 = true
            MangaTransition.Play(v321)
            v43 = false
        end
    end
end)
LocalPlayer.CharacterAdded:Connect(function() -- line: 2196
    -- upvalues: ContextActionService (copy), RunService (copy), BoxingCamera (copy), SkillRemote (copy), CurrentCamera (copy), ScreenGui (copy), t7 (copy), v42 (ref), v43 (ref), v45 (ref), t9 (ref), Folder (copy), t12 (copy), t13 (copy), Highlight (copy), v102 (copy), styleBoard (ref), restoreBeams (copy), Highlight2 (copy), MangaTransition (copy), ColorCorrectionEffect (ref), t21 (copy), t22 (copy), t28 (copy), t29 (ref), BackpackLock (copy), hookButton (copy)
    if v42 and v42 and not v43 then
        local function v327() -- line: 1469
            -- upvalues: ContextActionService (copy), RunService (copy), BoxingCamera (copy), SkillRemote (copy), CurrentCamera (copy), ScreenGui (copy), t7 (copy), v42 (ref), v45 (ref), t9 (ref), Folder (copy), t12 (copy), t13 (copy), Highlight (copy), v102 (copy), styleBoard (ref), restoreBeams (copy), Highlight2 (copy), ColorCorrectionEffect (ref), t21 (copy), t22 (copy), t28 (copy), t29 (ref), BackpackLock (copy)
            v42 = false
            SkillRemote:FireServer("Viewing", false)
            ScreenGui.Enabled = false
            Highlight2.Parent = nil
            Highlight.Parent = nil
            v102.Visible = false
            Folder:ClearAllChildren()
            table.clear(t12)
            table.clear(t13)
            table.clear(t7)
            Folder.Parent = nil
            restoreBeams()
            workspace:FindFirstChild("Skill tree")

            for v328, v329 in t22 do
                if v328.Parent then
                    v328.Brightness = v329
                end
            end

            table.clear(t22)

            if ColorCorrectionEffect then
                ColorCorrectionEffect.Parent = nil
            end

            for v330, v331 in t21 do
                if v330.Parent then
                    v330.Intensity = v331
                end
            end

            table.clear(t21)
            styleBoard(false)
            RunService:UnbindFromRenderStep("SkillTreeCamera")
            v45 = nil
            t9 = nil
            CurrentCamera.CameraType = t29 and t29.Type or Enum.CameraType.Custom

            if t29 then
                CurrentCamera.FieldOfView = t29.FieldOfView
                CurrentCamera.CFrame = t29.CFrame
            end

            for _, v332 in t28 do
                if v332.Parent then
                    v332.Enabled = true
                end
            end

            table.clear(t28)
            BackpackLock.Unlock("SkillTree")
            ContextActionService:UnbindAction("SkillTreeFreeze")
            BoxingCamera.SetSuspended(false, "SkillTreeController")
        end

        v43 = true
        MangaTransition.Play(v327)
        v43 = false
    end

    task.defer(hookButton)
end)
