-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

game:GetService("RunService")

local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Boxing = ReplicatedStorage:WaitForChild("Boxing")
local BoxingConfig = require(Boxing:WaitForChild("BoxingConfig"))
local SparringRemote = Boxing:WaitForChild("SparringRemote")
local RingSparring = BoxingConfig.RingSparring
local ScreenGui = Instance.new("ScreenGui")

ScreenGui.Name = "SparringGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 15
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local TextLabel = Instance.new("TextLabel")

TextLabel.AnchorPoint = Vector2.new(0.5, 0)
TextLabel.Position = UDim2.new(0.5, 0, 0, 70)
TextLabel.Size = UDim2.fromOffset(420, 50)
TextLabel.BackgroundTransparency = 1
TextLabel.FontFace = Font.new("rbxasset://fonts/families/Zekton.json", Enum.FontWeight.Bold)
TextLabel.TextSize = 40
TextLabel.TextColor3 = RingSparring.DigitColor
TextLabel.Text = ""
TextLabel.Visible = false
TextLabel.Parent = ScreenGui

local UIStroke = Instance.new("UIStroke")

UIStroke.Thickness = 2.4
UIStroke.Color = Color3.fromRGB(40, 0, 0)
UIStroke.Parent = TextLabel

local function banner(p1, p2, p3, p4, p5) -- line: 36
    -- upvalues: TweenService (copy), ScreenGui (copy)
    local TextLabel = Instance.new("TextLabel")

    TextLabel.AnchorPoint = Vector2.new(0.5, 0.5)
    TextLabel.Position = UDim2.new(0.5, 0, 0.32, p5 or 0)
    TextLabel.Size = UDim2.fromOffset(800, p3 + 12)
    TextLabel.BackgroundTransparency = 1
    TextLabel.FontFace = Font.new("rbxasset://fonts/families/Oswald.json", Enum.FontWeight.Bold)
    TextLabel.TextSize = p3
    TextLabel.TextColor3 = p2
    TextLabel.Text = p1
    TextLabel.Parent = ScreenGui

    local UIStroke = Instance.new("UIStroke")

    UIStroke.Thickness = 3
    UIStroke.Parent = TextLabel

    local UIScale = Instance.new("UIScale")

    UIScale.Scale = 1.4
    UIScale.Parent = TextLabel
    TweenService:Create(UIScale, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Scale = 1
    }):Play()
    task.delay(p4 - 0.4, function() -- line: 54
        -- upvalues: TextLabel (copy), UIStroke (copy), TweenService (copy)
        TweenService:Create(TextLabel, TweenInfo.new(0.4), {
            TextTransparency = 1
        }):Play()
        TweenService:Create(UIStroke, TweenInfo.new(0.4), {
            Transparency = 1
        }):Play()
    end)
    task.delay(p4, TextLabel.Destroy, TextLabel)
end

local UserInputService = game:GetService("UserInputService")
local v1 = Font.new("rbxasset://fonts/families/Montserrat.json", Enum.FontWeight.Heavy, Enum.FontStyle.Italic)
local v2 = Font.new("rbxasset://fonts/families/Montserrat.json", Enum.FontWeight.Medium)
local v3 = Font.new("rbxasset://fonts/families/Montserrat.json", Enum.FontWeight.Bold)
local v4 = Color3.fromRGB(12, 12, 14)
local v5 = Color3.fromRGB(160, 160, 168)
local t1 = {
    Red = Color3.fromRGB(226, 38, 44),
    Blue = Color3.fromRGB(46, 120, 236)
}
local v6 = Color3.fromRGB(222, 222, 228)
local Frame = Instance.new("Frame")

Frame.Name = "NoticeCard"
Frame.AnchorPoint = Vector2.new(0.5, 0)
Frame.Position = UDim2.fromScale(0.5, 0.15)
Frame.Size = UDim2.fromOffset(0, 0)
Frame.AutomaticSize = Enum.AutomaticSize.XY
Frame.BackgroundTransparency = 1
Frame.Visible = false
Frame.Parent = ScreenGui

local UIScale = Instance.new("UIScale")

UIScale.Parent = Frame

local function fitScale() -- line: 87
    -- upvalues: UIScale (copy)
    UIScale.Scale = math.clamp(workspace.CurrentCamera.ViewportSize.Y / 960, 0.7, 1.35)
end

workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(fitScale)
UIScale.Scale = math.clamp(workspace.CurrentCamera.ViewportSize.Y / 960, 0.7, 1.35)

local CanvasGroup = Instance.new("CanvasGroup")

CanvasGroup.Name = "Card"
CanvasGroup.AutomaticSize = Enum.AutomaticSize.XY
CanvasGroup.Size = UDim2.fromOffset(0, 0)
CanvasGroup.BackgroundColor3 = v4
CanvasGroup.BackgroundTransparency = 0.06
CanvasGroup.BorderSizePixel = 0
CanvasGroup.Parent = Frame
Instance.new("UICorner", CanvasGroup).CornerRadius = UDim.new(0, 6)

local UIStroke2 = Instance.new("UIStroke")

UIStroke2.Color = Color3.new(1, 1, 1)
UIStroke2.Transparency = 0.86
UIStroke2.Thickness = 1.5
UIStroke2.Parent = Frame

local Frame2 = Instance.new("Frame")

Frame2.Name = "Edge"
Frame2.BackgroundTransparency = 1
Frame2.Size = UDim2.fromScale(1, 1)
Frame2.ZIndex = 2
Frame2.Parent = CanvasGroup
Instance.new("UICorner", Frame2).CornerRadius = UDim.new(0, 6)
UIStroke2.Parent = Frame2
Frame2 = Instance.new("Frame")
Frame2.Name = "Row"
Frame2.BackgroundTransparency = 1
Frame2.AutomaticSize = Enum.AutomaticSize.XY
Frame2.Size = UDim2.fromOffset(0, 0)
Frame2.Parent = CanvasGroup

local UIPadding = Instance.new("UIListLayout")

UIPadding.FillDirection = Enum.FillDirection.Horizontal
UIPadding.VerticalAlignment = Enum.VerticalAlignment.Center
UIPadding.SortOrder = Enum.SortOrder.LayoutOrder
UIPadding.Padding = UDim.new(0, 18)
UIPadding.Parent = Frame2
UIPadding = Instance.new("UIPadding")

local v8 = UDim.new(0, 0)
local UIPadding2 = UDim.new(0, 22)

UIPadding.PaddingLeft = v8
UIPadding.PaddingRight = UIPadding2
v8 = UDim.new(0, 0)
UIPadding2 = UDim.new(0, 0)
UIPadding.PaddingTop = v8
UIPadding.PaddingBottom = UIPadding2
UIPadding.Parent = Frame2

local Frame3 = Instance.new("Frame")

Frame3.Name = "Stripe"
Frame3.LayoutOrder = 1
Frame3.BorderSizePixel = 0
Frame3.Size = UDim2.fromOffset(8, 92)
Frame3.Parent = Frame2
v8 = Instance.new("UIGradient")
v8.Rotation = 90
v8.Transparency = NumberSequence.new(0, 0.25)
v8.Parent = Frame3

local Frame4 = Instance.new("Frame")

Frame4.Name = "Text"
Frame4.LayoutOrder = 2
Frame4.BackgroundTransparency = 1
Frame4.AutomaticSize = Enum.AutomaticSize.XY
Frame4.Size = UDim2.fromOffset(0, 0)
Frame4.Parent = Frame2
UIPadding2 = Instance.new("UIListLayout")
UIPadding2.SortOrder = Enum.SortOrder.LayoutOrder
UIPadding2.Padding = UDim.new(0, 2)
UIPadding2.Parent = Frame4
UIPadding2 = Instance.new("UIPadding")

local v9 = UDim.new(0, 12)
local v10 = UDim.new(0, 13)

UIPadding2.PaddingTop = v9
UIPadding2.PaddingBottom = v10
UIPadding2.Parent = Frame4

local function line(p6, p7, p8, p9) -- line: 158
    -- upvalues: Frame4 (copy)
    local TextLabel = Instance.new("TextLabel")

    TextLabel.LayoutOrder = p6
    TextLabel.BackgroundTransparency = 1
    TextLabel.AutomaticSize = Enum.AutomaticSize.XY
    TextLabel.Size = UDim2.fromOffset(0, 0)
    TextLabel.FontFace = p7
    TextLabel.TextSize = p8
    TextLabel.TextColor3 = p9
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel.RichText = true
    TextLabel.Text = ""
    TextLabel.Parent = Frame4

    return TextLabel
end

local v11 = line(1, v3, 14, v6)
local v12 = line(2, v1, 32, Color3.new(1, 1, 1))
local v13 = line(3, v2, 17, v5)
local Frame5 = Instance.new("Frame")

Frame5.Name = "Key"
Frame5.LayoutOrder = 3
Frame5.BackgroundTransparency = 1
Frame5.AutomaticSize = Enum.AutomaticSize.XY
Frame5.Size = UDim2.fromOffset(0, 0)
Frame5.Parent = Frame2

local UIPadding3 = Instance.new("UIListLayout")

UIPadding3.FillDirection = Enum.FillDirection.Horizontal
UIPadding3.VerticalAlignment = Enum.VerticalAlignment.Center
UIPadding3.Padding = UDim.new(0, 10)
UIPadding3.SortOrder = Enum.SortOrder.LayoutOrder
UIPadding3.Parent = Frame5
UIPadding3 = Instance.new("Frame")
UIPadding3.LayoutOrder = 0
UIPadding3.BorderSizePixel = 0
UIPadding3.BackgroundColor3 = Color3.new(1, 1, 1)
UIPadding3.BackgroundTransparency = 0.88
UIPadding3.Size = UDim2.fromOffset(1, 52)
UIPadding3.Parent = Frame5

local TextLabel2 = Instance.new("TextLabel")

TextLabel2.LayoutOrder = 1
TextLabel2.Size = UDim2.fromOffset(38, 38)
TextLabel2.AutomaticSize = Enum.AutomaticSize.X
TextLabel2.BackgroundColor3 = Color3.fromRGB(236, 236, 240)
TextLabel2.BorderSizePixel = 0
TextLabel2.FontFace = v1
TextLabel2.TextSize = 20
TextLabel2.TextColor3 = v4
TextLabel2.Text = "E"
TextLabel2.Parent = Frame5
Instance.new("UICorner", TextLabel2).CornerRadius = UDim.new(0, 6)
UIPadding3 = Instance.new("UIPadding")

local v14 = UDim.new(0, 8)
local v15 = UDim.new(0, 8)

UIPadding3.PaddingLeft = v14
UIPadding3.PaddingRight = v15
UIPadding3.Parent = TextLabel2
UIPadding3 = Instance.new("UIStroke")
UIPadding3.Color = Color3.fromRGB(120, 120, 128)
UIPadding3.Thickness = 2
UIPadding3.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIPadding3.Parent = TextLabel2

local TextLabel3 = Instance.new("TextLabel")

TextLabel3.LayoutOrder = 2
TextLabel3.BackgroundTransparency = 1
TextLabel3.AutomaticSize = Enum.AutomaticSize.XY
TextLabel3.Size = UDim2.fromOffset(0, 0)
TextLabel3.FontFace = v1
TextLabel3.TextSize = 18
TextLabel3.TextColor3 = Color3.new(1, 1, 1)
TextLabel3.Text = "LEAVE"
TextLabel3.Parent = Frame5

local function keyFor() -- line: 228
    -- upvalues: UserInputService (copy)
    local LastInputType = UserInputService:GetLastInputType()

    if LastInputType.Name:find("Gamepad") then
        return "B"
    end

    if LastInputType == Enum.UserInputType.Touch then
        return "TAP"
    end

    return "E"
end

local n1 = 0
local v16
local v17 = ""

local function fadeOut(p10) -- line: 241
    -- upvalues: TweenService (copy), Frame (copy), CanvasGroup (copy), UIStroke2 (copy), n1 (ref), v16 (ref)
    if n1 ~= p10 or not Frame.Visible then
        return
    end

    TweenService:Create(CanvasGroup, TweenInfo.new(0.3), {
        GroupTransparency = 1
    }):Play()
    TweenService:Create(UIStroke2, TweenInfo.new(0.3), {
        Transparency = 1
    }):Play()
    task.delay(0.3, function() -- line: 247
        -- upvalues: p10 (copy), Frame (copy), n1 (ref), v16 (ref)
        if n1 == p10 then
            Frame.Visible = false
            v16 = nil
        end
    end)
end

local function hideNotice() -- line: 254
    -- upvalues: n1 (ref), fadeOut (copy)
    fadeOut(n1)
end

local function showNotice(p11) -- line: 259
    -- upvalues: TweenService (copy), LocalPlayer (copy), UserInputService (copy), t1 (copy), v6 (copy), Frame (copy), CanvasGroup (copy), UIStroke2 (copy), Frame3 (copy), v11 (copy), v12 (copy), v13 (copy), Frame5 (copy), TextLabel2 (copy), TextLabel3 (copy), n1 (ref), v16 (ref), v17 (ref), fadeOut (copy)
    local v19 = tostring(p11 or "")

    n1 += 1

    local v20 = n1
    local v21 = v19:sub(1, 14) == "Ranked bout - "
    local v22

    if v21 then
        v22 = v21
        v19 = v19:sub(15)
    else
        v22 = v19:lower():find("ranked", 1, true) ~= nil
    end

    local v23 = v19:find("(E to leave)", 1, true) ~= nil
    local v24 = v19:gsub("%s*%(E to leave%)", "")
    local v25 = v24:match("(%a+) corner")

    if not (v25 and t1[v25]) then
        v25 = nil
    end

    local v26 = v25 and v24:find("waiting for an opponent", 1, true)

    Frame3.BackgroundColor3 = if v25 then t1[v25] elseif v22 then t1.Red else v6
    v11.Text = string.upper(if v21 then "Ranked bout"
        elseif v22 then "Ranked"
        elseif v25 then "Sparring"
        else "Ring")
    v11.TextColor3 = if v22 then Color3.fromRGB(255, 92, 92) else v6

    if v26 then
        v12.Text = string.upper(v25 .. " corner") .. "  <font color=\"#A0A0A8\">·</font>  READY"
        v17 = "Waiting for an opponent"
    else
        if v25 then
            v12.Text = string.upper("You're in the " .. v25 .. " corner")
        else
            v12.Text = string.upper((v24:gsub("%.$", "")))
        end

        v17 = ""
    end

    v13.Text = v17
    v13.Visible = v17 ~= ""
    Frame5.Visible = v23

    local LastInputType = UserInputService:GetLastInputType()
    local v30 = if LastInputType.Name:find("Gamepad") then "B" elseif LastInputType == Enum.UserInputType.Touch then "TAP" else "E"

    TextLabel2.Text = v30
    TextLabel3.Text = v30 == "TAP" and "THE PROMPT TO LEAVE" or "LEAVE"
    Frame3.Size = UDim2.fromOffset(8, v17 == "" and 70 or 92)
    Frame.Visible = true
    CanvasGroup.GroupTransparency = 1
    UIStroke2.Transparency = 1
    Frame.Position = UDim2.new(0.5, 0, 0.15, -18)
    TweenService:Create(CanvasGroup, TweenInfo.new(0.25), {
        GroupTransparency = 0
    }):Play()
    TweenService:Create(UIStroke2, TweenInfo.new(0.25), {
        Transparency = 0.86
    }):Play()
    TweenService:Create(Frame, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.fromScale(0.5, 0.15)
    }):Play()

    if not v26 then
        task.delay(2.8, fadeOut, v20)

        return
    end

    local Character = LocalPlayer.Character
    local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")

    v16 = HumanoidRootPart and HumanoidRootPart.Position
    task.spawn(function() -- line: 305
        -- upvalues: v20 (copy), LocalPlayer (copy), Frame (copy), v13 (copy), n1 (ref), v16 (ref), v17 (ref), fadeOut (copy)
        local elapsed = os.clock()

        while true do
            if n1 == v20 and Frame.Visible then
                local v32 = math.floor((os.clock() - elapsed) * 2) % 4

                v13.Text = v17 .. string.rep(".", v32)

                local Character = LocalPlayer.Character
                local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")

                if not HumanoidRootPart or v16 and (HumanoidRootPart.Position - v16).Magnitude > 5 or os.clock() - elapsed > 300 then
                    break
                end

                task.wait(0.25)
                continue
            end

            return
        end

        fadeOut(v20)
    end)
end

local RankedLadder = require(Boxing:WaitForChild("RankedLadder"))
local v33 = BoxingConfig.Currency and BoxingConfig.Currency.Symbol or "¥"

local function money(p12) -- line: 328
    -- upvalues: v33 (copy)
    local v35 = tostring((math.floor(p12))):reverse():gsub("(%d%d%d)", "%1,"):reverse()

    if v35:sub(1, 1) == "," then
        v35 = v35:sub(2)
    end

    return v33 .. v35
end

local function rankIndex(p13) -- line: 332
    -- upvalues: RankedLadder (copy)
    for v36, v37 in RankedLadder.Ranks do
        if v37.Name == p13 then
            return v36
        end
    end

    return 0
end

v5 = BoxingConfig.Stats and BoxingConfig.Stats.Subs and BoxingConfig.Stats.Subs[RingSparring.Stat[1]]

local v38 = v5 and v5[RingSparring.Stat[2]] or "Drain Resistance"
local GothicUI = require(Boxing:WaitForChild("GothicUI"))
local BoxingCamera = require(Boxing:WaitForChild("BoxingCamera"))
local CurrentCamera = workspace.CurrentCamera
local ScreenGui2 = Instance.new("ScreenGui")

ScreenGui2.Name = "ChooseStatGui"
ScreenGui2.ResetOnSpawn = false
ScreenGui2.DisplayOrder = 120
ScreenGui2.Parent = LocalPlayer:WaitForChild("PlayerGui")

local v39 = GothicUI.Panel(ScreenGui2, UDim2.fromOffset(580, 270), {
    Name = "ChooseStat",
    Visible = false,
    ZIndex = 4,
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromScale(0.5, 0.58)
})
local UIScale2 = Instance.new("UIScale")

UIScale2.Parent = v39

local n2 = 1

local function rescale() -- line: 362
    -- upvalues: CurrentCamera (copy), UIScale2 (copy), n2 (ref)
    n2 = math.clamp(CurrentCamera.ViewportSize.Y / 1080, 0.6, 1.4)
    UIScale2.Scale = n2
end

CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(rescale)
n2 = math.clamp(CurrentCamera.ViewportSize.Y / 1080, 0.6, 1.4)
UIScale2.Scale = n2
GothicUI.Label(v39, {
    TextSize = 34,
    Text = "CHOOSE A STAT TO UPGRADE",
    ZIndex = 5,
    Position = UDim2.fromOffset(0, 32),
    Size = UDim2.new(1, 0, 0, 44),
    FontFace = GothicUI.PosterFont
})

local v41 = GothicUI.Label(v39, {
    TextSize = 24,
    ZIndex = 5,
    Position = UDim2.fromOffset(0, 80),
    Size = UDim2.new(1, 0, 0, 30),
    TextColor3 = GothicUI.Soft
})
local v42 = false

local function choiceButton(p14, p15, p16) -- line: 376
    -- upvalues: GothicUI (copy), v39 (copy)
    local v43 = GothicUI.Button(v39, p14, UDim2.fromOffset(230, 60), {
        ZIndex = 5,
        Position = UDim2.fromOffset(p15, 140)
    })
    local Label = v43:FindFirstChild("Label")
    local UITextSizeConstraint = Label and Label:FindFirstChildOfClass("UITextSizeConstraint")

    if UITextSizeConstraint then
        UITextSizeConstraint.MaxTextSize = 30
    end

    GothicUI.New("Frame", {
        Name = "StatColor",
        BorderSizePixel = 0,
        ZIndex = 5,
        AnchorPoint = Vector2.new(0.5, 0),
        Position = UDim2.new(0.5, 0, 1, 8),
        Size = UDim2.new(0.5, 0, 0, 4),
        BackgroundColor3 = p16
    }, v43)

    return v43
end

v8 = choiceButton("Courage", 45, Color3.fromRGB(255, 205, 90))
UIPadding2 = choiceButton("Bloodthirst", 305, Color3.fromRGB(220, 40, 40))

local CameraMinZoomDistance, CameraMaxZoomDistance

local function zoomOutForChooser() -- line: 398
    -- upvalues: LocalPlayer (copy), CameraMinZoomDistance (ref), CameraMaxZoomDistance (ref)
    if CameraMinZoomDistance == nil then
        local CameraMinZoomDistance2, CameraMaxZoomDistance2 = LocalPlayer.CameraMinZoomDistance, LocalPlayer.CameraMaxZoomDistance

        CameraMinZoomDistance = CameraMinZoomDistance2
        CameraMaxZoomDistance = CameraMaxZoomDistance2
    end

    if LocalPlayer.CameraMaxZoomDistance < 12 then
        LocalPlayer.CameraMaxZoomDistance = 12
    end

    LocalPlayer.CameraMinZoomDistance = 12
end

local function restoreZoom() -- line: 407
    -- upvalues: LocalPlayer (copy), CameraMinZoomDistance (ref), CameraMaxZoomDistance (ref)
    if CameraMinZoomDistance == nil then
        return
    end

    local CameraMinZoomDistance2 = CameraMinZoomDistance

    LocalPlayer.CameraMinZoomDistance = math.min(CameraMinZoomDistance2, LocalPlayer.CameraMaxZoomDistance)
    LocalPlayer.CameraMaxZoomDistance = math.max(CameraMaxZoomDistance, CameraMinZoomDistance)
    CameraMinZoomDistance = nil
    CameraMaxZoomDistance = nil
end

local function choose(p17) -- line: 414
    -- upvalues: LocalPlayer (copy), SparringRemote (copy), BoxingCamera (copy), v39 (copy), v42 (ref), CameraMinZoomDistance (ref), CameraMaxZoomDistance (ref)
    if v39.Visible then
        v39.Visible = false
        v42 = false

        if CameraMinZoomDistance ~= nil then
            local CameraMinZoomDistance2 = CameraMinZoomDistance

            LocalPlayer.CameraMinZoomDistance = math.min(CameraMinZoomDistance2, LocalPlayer.CameraMaxZoomDistance)
            LocalPlayer.CameraMaxZoomDistance = math.max(CameraMaxZoomDistance, CameraMinZoomDistance)
            CameraMinZoomDistance = nil
            CameraMaxZoomDistance = nil
        end

        BoxingCamera.SetSuspended(false, "SparringController")
        SparringRemote:FireServer("Choose", p17)
    end
end

for _, v44 in { v8, UIPadding2 } do
    v44.Activated:Connect(function() -- line: 424
        -- upvalues: LocalPlayer (copy), SparringRemote (copy), BoxingCamera (copy), v39 (copy), v42 (ref), CameraMinZoomDistance (ref), CameraMaxZoomDistance (ref), v44 (copy)
        local Name = v44.Name

        if v39.Visible then
            v39.Visible = false
            v42 = false

            if CameraMinZoomDistance ~= nil then
                local CameraMinZoomDistance2 = CameraMinZoomDistance

                LocalPlayer.CameraMinZoomDistance = math.min(CameraMinZoomDistance2, LocalPlayer.CameraMaxZoomDistance)
                LocalPlayer.CameraMaxZoomDistance = math.max(CameraMaxZoomDistance, CameraMinZoomDistance)
                CameraMinZoomDistance = nil
                CameraMaxZoomDistance = nil
            end

            BoxingCamera.SetSuspended(false, "SparringController")
            SparringRemote:FireServer("Choose", Name)
        end
    end)
end

game:GetService("UserInputService").InputBegan:Connect(function(p18) -- line: 429
    -- upvalues: LocalPlayer (copy), SparringRemote (copy), BoxingCamera (copy), v39 (copy), v42 (ref), CameraMinZoomDistance (ref), CameraMaxZoomDistance (ref)
    if v39.Visible then
        if p18.KeyCode == Enum.KeyCode.ButtonX then
            if v39.Visible then
                v39.Visible = false
                v42 = false

                if CameraMinZoomDistance ~= nil then
                    local CameraMinZoomDistance2 = CameraMinZoomDistance

                    LocalPlayer.CameraMinZoomDistance = math.min(CameraMinZoomDistance2, LocalPlayer.CameraMaxZoomDistance)
                    LocalPlayer.CameraMaxZoomDistance = math.max(CameraMaxZoomDistance, CameraMinZoomDistance)
                    CameraMinZoomDistance = nil
                    CameraMaxZoomDistance = nil
                end

                BoxingCamera.SetSuspended(false, "SparringController")
                SparringRemote:FireServer("Choose", "Courage")
            end
        elseif p18.KeyCode == Enum.KeyCode.ButtonY and v39.Visible then
            v39.Visible = false
            v42 = false

            if CameraMinZoomDistance ~= nil then
                local CameraMinZoomDistance2 = CameraMinZoomDistance

                LocalPlayer.CameraMinZoomDistance = math.min(CameraMinZoomDistance2, LocalPlayer.CameraMaxZoomDistance)
                LocalPlayer.CameraMaxZoomDistance = math.max(CameraMaxZoomDistance, CameraMinZoomDistance)
                CameraMinZoomDistance = nil
                CameraMaxZoomDistance = nil
            end

            BoxingCamera.SetSuspended(false, "SparringController")
            SparringRemote:FireServer("Choose", "Bloodthirst")
        end
    end
end)
task.spawn(function() -- line: 441
    -- upvalues: LocalPlayer (copy), BoxingCamera (copy), ScreenGui2 (copy), v39 (copy), v42 (ref), CameraMinZoomDistance (ref), CameraMaxZoomDistance (ref)
    while true do
        task.wait(0.2)

        if v42 and v39.Visible then
            if not LocalPlayer:GetAttribute("ReplayPlaying") and LocalPlayer.CameraMinZoomDistance < 12 then
                if CameraMinZoomDistance == nil then
                    local CameraMinZoomDistance2, CameraMaxZoomDistance2 = LocalPlayer.CameraMinZoomDistance, LocalPlayer.CameraMaxZoomDistance

                    CameraMinZoomDistance = CameraMinZoomDistance2
                    CameraMaxZoomDistance = CameraMaxZoomDistance2
                end

                if LocalPlayer.CameraMaxZoomDistance < 12 then
                    LocalPlayer.CameraMaxZoomDistance = 12
                end

                LocalPlayer.CameraMinZoomDistance = 12
            end

            if not ScreenGui2.Enabled and not LocalPlayer:GetAttribute("ReplayPlaying") then
                ScreenGui2.Enabled = true
            end

            if not BoxingCamera.IsSuspended() then
                BoxingCamera.SetSuspended(true, "SparringController")
            end
        end
    end
end)

local function showChooser(p19) -- line: 457
    -- upvalues: TweenService (copy), LocalPlayer (copy), BoxingCamera (copy), v39 (copy), UIScale2 (copy), n2 (ref), v41 (copy), CameraMinZoomDistance (ref), CameraMaxZoomDistance (ref)
    v41.Text = string.format("+%.2f Willpower", p19 or 0)
    v39.Visible = true

    if CameraMinZoomDistance == nil then
        local CameraMinZoomDistance2, CameraMaxZoomDistance2 = LocalPlayer.CameraMinZoomDistance, LocalPlayer.CameraMaxZoomDistance

        CameraMinZoomDistance = CameraMinZoomDistance2
        CameraMaxZoomDistance = CameraMaxZoomDistance2
    end

    if LocalPlayer.CameraMaxZoomDistance < 12 then
        LocalPlayer.CameraMaxZoomDistance = 12
    end

    LocalPlayer.CameraMinZoomDistance = 12
    BoxingCamera.SetSuspended(true, "SparringController")
    UIScale2.Scale = n2 * 0.7
    TweenService:Create(UIScale2, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Scale = n2
    }):Play()
end

local v45 = nil
local v46 = Color3.fromRGB(242, 196, 60)

local function signed(p20) -- line: 471
    return (if p20 >= 0 then "+" else "-") .. string.format("%.2f", (math.abs(p20)))
end

local function showRankedCard(p21, p22) -- line: 474
    -- upvalues: TweenService (copy), ScreenGui (copy), RankedLadder (copy), money (copy), GothicUI (copy), n2 (ref), v45 (ref), v46 (copy)
    if v45 then
        v45:Destroy()
    end

    local New, Label = GothicUI.New, GothicUI.Label
    local v47 = tonumber(p22.Willpower) or 0
    local v48 = RankedLadder.RankOf(v47)
    local v49 = RankedLadder.Leagues[v48.LeagueIndex] or {}
    local v50 = GothicUI.Panel(ScreenGui, UDim2.fromOffset(480, 340), {
        Name = "RankedResult",
        ZIndex = 5,
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, 560, 0.5, 0)
    })

    v45 = v50
    New("UIScale", {
        Scale = n2
    }, v50)
    Label(v50, {
        TextSize = 30,
        Text = "RANKED RESULT",
        ZIndex = 6,
        Position = UDim2.fromOffset(0, 28),
        Size = UDim2.new(1, 0, 0, 36),
        FontFace = GothicUI.PosterFont
    })
    New("ImageLabel", {
        Name = "Emblem",
        BackgroundTransparency = 1,
        ZIndex = 6,
        Position = UDim2.fromOffset(40, 76),
        Size = UDim2.fromOffset(118, 118),
        Image = v49.Emblem or "",
        ScaleType = Enum.ScaleType.Fit
    }, v50)
    Label(v50, {
        Name = "Rank",
        TextSize = 44,
        ZIndex = 6,
        Position = UDim2.fromOffset(176, 80),
        Size = UDim2.fromOffset(270, 48),
        FontFace = GothicUI.PosterFont,
        TextXAlignment = Enum.TextXAlignment.Left,
        Text = string.upper(v48.Name),
        TextColor3 = v48.Color
    })

    local Before = p22.Before
    local v51 = false
    local v52

    for v53, v54 in RankedLadder.Ranks do
        if v54.Name == Before then
            v52 = v53
            v51 = true
            break
        end
    end

    if not v51 then
        v52 = 0
    end

    local After = p22.After
    local v55 = false
    local v56

    for v57, v58 in RankedLadder.Ranks do
        if v58.Name == After then
            v56 = v57
            v55 = true
            break
        end
    end

    if not v55 then
        v56 = 0
    end

    local Soft = GothicUI.Soft
    local v59 = "RANK HELD"

    if p22.Custom then
        v59 = "CUSTOM SERVER"
    elseif p22.Unfinished then
        v59 = "UNFINISHED BOUT"
    elseif p22.WillpowerCooldown then
        v59 = "WILLPOWER COOLDOWN"
    elseif v52 < v56 then
        v59 = "PROMOTED"
        Soft = v46
    elseif v56 < v52 then
        v59 = "DEMOTED"
        Soft = GothicUI.Accent
    end

    local v60 = Label(v50, {
        Name = "Tag",
        TextSize = 24,
        ZIndex = 6,
        Position = UDim2.fromOffset(190, 128),
        Size = UDim2.fromOffset(250, 28),
        FontFace = GothicUI.PosterFont,
        TextXAlignment = Enum.TextXAlignment.Left,
        Text = v59,
        TextColor3 = Soft
    })

    New("Frame", {
        BorderSizePixel = 0,
        ZIndex = 6,
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(0, -8, 0.5, 0),
        Size = UDim2.fromOffset(4, 20),
        BackgroundColor3 = Soft
    }, v60)

    local v61 = if (p21 or 0) == 0 then "" else "   (" .. ((if p21 >= 0 then "+" else "-") .. string.format("%.2f", (math.abs(p21)))) .. ")"

    Label(v50, {
        Name = "Willpower",
        TextSize = 22,
        RichText = true,
        ZIndex = 6,
        Position = UDim2.fromOffset(176, 160),
        Size = UDim2.fromOffset(270, 28),
        TextXAlignment = Enum.TextXAlignment.Left,
        Text = string.format("WILLPOWER  <b>%.2f</b>%s", v47, v61),
        TextColor3 = if (p21 or 0) < 0 then Color3.fromRGB(255, 150, 140) else GothicUI.Text
    })

    local v62 = GothicUI.Slot(v50, UDim2.fromOffset(400, 14), {
        Name = "Progress",
        ZIndex = 6,
        Position = UDim2.fromOffset(40, 214)
    })

    TweenService:Create(New("Frame", {
        BorderSizePixel = 0,
        ZIndex = 7,
        Size = UDim2.fromScale(0, 1),
        BackgroundColor3 = v48.Color
    }, v62), TweenInfo.new(0.9, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = UDim2.fromScale(v48.Progress, 1)
    }):Play()
    Label(v50, {
        TextSize = 18,
        ZIndex = 6,
        Position = UDim2.fromOffset(40, 232),
        Size = UDim2.fromOffset(200, 24),
        TextColor3 = GothicUI.Soft,
        TextXAlignment = Enum.TextXAlignment.Left,
        Text = string.upper(v48.Name)
    })
    Label(v50, {
        TextSize = 18,
        ZIndex = 6,
        Position = UDim2.fromOffset(240, 232),
        Size = UDim2.fromOffset(200, 24),
        TextColor3 = GothicUI.Soft,
        TextXAlignment = Enum.TextXAlignment.Right,
        Text = if v48.NextName then string.format("%s AT %.2f", string.upper(v48.NextName), v48.Next) else "TOP OF THE LADDER"
    })

    local v64 = tonumber(p22.Purse) or 0

    Label(v50, {
        Name = "Purse",
        TextSize = 28,
        ZIndex = 6,
        Position = UDim2.fromOffset(0, 270),
        Size = UDim2.new(1, 0, 0, 34),
        FontFace = GothicUI.PosterFont,
        Text = if p22.Custom then "NO WILLPOWER IN CUSTOM SERVERS"
            elseif p22.Unfinished then "NO RANKED RESULT"
            elseif v64 > 0 then "+" .. money(v64) .. "  FIGHT PURSE"
            else "NO PURSE",
        TextColor3 = if not (v64 > 0) or p22.Unfinished then GothicUI.Soft else v46
    })
    TweenService:Create(v50, TweenInfo.new(0.45, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
        Position = UDim2.new(1, -36, 0.5, 0)
    }):Play()
    task.delay(9, function() -- line: 537
        -- upvalues: v50 (copy), TweenService (copy), v45 (ref)
        if v45 == v50 then
            TweenService:Create(v50, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                Position = UDim2.new(1, 560, 0.5, 0)
            }):Play()
            task.delay(0.45, function() -- line: 542
                -- upvalues: v50 (copy), v45 (ref)
                v50:Destroy()

                if v45 == v50 then
                    v45 = nil
                end
            end)
        end
    end)
end

local function afterReplay() -- line: 552
    -- upvalues: LocalPlayer (copy)
    local n3 = 0

    while LocalPlayer:GetAttribute("ReplayPlaying") and n3 < 20 do
        n3 += task.wait(0.1)
    end
end

SparringRemote.OnClientEvent:Connect(function(p23, p24, p25, p26, _, p28, p29) -- line: 559
    -- upvalues: LocalPlayer (copy), banner (copy), hideNotice (copy), showNotice (copy), v38 (copy), BoxingCamera (copy), v39 (copy), v42 (ref), CameraMinZoomDistance (ref), CameraMaxZoomDistance (ref), showChooser (copy), showRankedCard (copy), afterReplay (copy)
    if p23 == "Countdown" or p23 == "Start" or p23 == "Round" then
        hideNotice()
    end

    if p23 == "Countdown" then
        banner(tostring(p24), Color3.fromRGB(255, 225, 60), 90, 0.9)
    elseif p23 == "Start" then
        banner(p24 .. "  vs  " .. p25, Color3.new(1, 1, 1), 44, 2.2, -70)
    elseif p23 == "Round" then
        banner("ROUND " .. p24, Color3.fromRGB(255, 225, 60), 80, 1.8)
    elseif p23 == "Break" then
        banner("END OF ROUND " .. p24, Color3.fromRGB(230, 230, 230), 56, 2)
    elseif p23 == "Knockdown" then
        banner("DOWN!  " .. p24 .. " (" .. p25 .. ")", Color3.fromRGB(255, 70, 60), 60, 1.8)
    elseif p23 == "Result" then
        if p24 == "Cancelled" then
            banner("Match cancelled", Color3.fromRGB(230, 230, 230), 44, 2)
        else
            banner(if p24 == "Draw" then "DRAW" elseif p25 == LocalPlayer.Name then "YOU WIN  (" .. p24 .. ")" else tostring(p25) .. " WINS  (" .. p24 .. ")", if p25 == LocalPlayer.Name then Color3.fromRGB(255, 225, 60) else Color3.fromRGB(230, 230, 230), 64, 3.5)

            if p28 == "Willpower" then
                local v67 = if type(p29) == "table" then p29 else {}

                task.delay(0.6, function() -- line: 592
                    -- upvalues: p26 (copy), v67 (copy), showRankedCard (copy), afterReplay (copy)
                    afterReplay()
                    showRankedCard(p26 or 0, v67)
                end)
            else
                banner(string.format("+%.4f %s", p26 or 0, v38), Color3.new(1, 1, 1), 30, 3.5, 60)
            end
        end
    elseif p23 == "ChooseStat" then
        v42 = true
        task.spawn(function() -- line: 601
            -- upvalues: p24 (copy), v42 (ref), showChooser (copy), afterReplay (copy)
            task.wait(0.3)
            afterReplay()

            if v42 then
                showChooser(p24)
            end
        end)
    elseif p23 == "Chosen" then
        v42 = false

        if CameraMinZoomDistance ~= nil then
            local CameraMinZoomDistance2 = CameraMinZoomDistance

            LocalPlayer.CameraMinZoomDistance = math.min(CameraMinZoomDistance2, LocalPlayer.CameraMaxZoomDistance)
            LocalPlayer.CameraMaxZoomDistance = math.max(CameraMaxZoomDistance, CameraMinZoomDistance)
            CameraMinZoomDistance = nil
            CameraMaxZoomDistance = nil
        end

        if v39.Visible then
            v39.Visible = false
            BoxingCamera.SetSuspended(false, "SparringController")
        end

        banner(string.format("+%.2f %s", p25 or 0, (tostring(p24))), if p24 == "Bloodthirst" then Color3.fromRGB(255, 90, 90) else Color3.fromRGB(255, 215, 110), 34, 2.5, 60)
    elseif p23 == "Notice" then
        showNotice(p24)
    end
end)

local MenuState = require(Boxing:WaitForChild("MenuState"))
local BackpackLock = require(Boxing:WaitForChild("BackpackLock"))
local t5 = {
    Settings = "BoxingSettingsMenu",
    CounterShop = "ShopGui",
    MainMenu = "MainMenu",
    Avatar = "AvatarCreator",
    Hospital = "HospitalGui",
    GearShop = "GearShopGui",
    RankedCounter = "RankedCounterGui",
    Replay = "KnockoutReplay",
    ProLicense = "ProLicense",
    AdminPanel = "AdminPanel",
    Walkout = "WalkoutGui",
    FrontMenu = "FrontMenu",
    TouchEdit = "MobileCombatPad"
}
local t6 = {
    SkillTree = "SkillTreeGui",
    Statistics = "StatsGui"
}

local function shown(p30) -- line: 645
    -- upvalues: LocalPlayer (copy)
    local v70 = LocalPlayer.PlayerGui:FindFirstChild(p30)

    return v70 ~= nil and v70:IsA("ScreenGui") and v70.Enabled
end

local v71
local GuiService = game:GetService("GuiService")
local UserInputService2 = game:GetService("UserInputService")

local function drawsSomething(p31) -- line: 656
    if not (p31:IsA("GuiObject") and p31.Visible) then
        return false
    end

    if p31.BackgroundTransparency < 0.98 then
        return true
    end

    if not p31:IsA("TextLabel") and not p31:IsA("TextButton") and not p31:IsA("TextBox") then
        if (p31:IsA("ImageLabel") or p31:IsA("ImageButton")) and p31.Image ~= "" and p31.ImageTransparency < 0.98 then
            return true
        end

        return p31:IsA("ViewportFrame") or p31:IsA("VideoFrame")
    end

    if p31.Text ~= "" and p31.TextTransparency < 0.98 then
        return true
    end

    if not p31:IsA("ImageLabel") and not p31:IsA("ImageButton") then
        return p31:IsA("ViewportFrame") or p31:IsA("VideoFrame")
    end

    if p31.Image ~= "" and p31.ImageTransparency < 0.98 then
        return true
    end

    return p31:IsA("ViewportFrame") or p31:IsA("VideoFrame")
end

local function emptyLayer(p32) -- line: 671
    -- upvalues: drawsSomething (copy)
    if drawsSomething(p32) then
        return false
    end

    for _, descendant in p32:GetDescendants() do
        if descendant:IsA("GuiObject") and drawsSomething(descendant) then
            local Parent = descendant.Parent
            local v72

            while true do
                if not Parent or Parent == p32 then
                    v72 = true
                else
                    if not Parent:IsA("GuiObject") or Parent.Visible then
                        Parent = Parent.Parent
                        continue
                    end

                    v72 = false
                end

                break
            end

            if v72 then
                return false
            end
        end
    end

    return true
end

local function freeMouseLayers() -- line: 693
    -- upvalues: LocalPlayer (copy), GuiService (copy), UserInputService2 (copy), emptyLayer (copy)
    local ViewportSize = workspace.CurrentCamera.ViewportSize
    local GuiInset = GuiService:GetGuiInset()
    local v73 = UserInputService2:GetMouseLocation() - GuiInset

    for _, v74 in {
            ViewportSize / 2 - GuiInset,
            v73
        } do
        for _, v75 in LocalPlayer.PlayerGui:GetGuiObjectsAtPosition(v74.X, v74.Y) do
            local ScreenGui = v75:FindFirstAncestorWhichIsA("ScreenGui")

            if ScreenGui and ScreenGui.Enabled and (v75.Active or v75:IsA("GuiButton")) and v75.Visible and v75.AbsoluteSize.X * v75.AbsoluteSize.Y > ViewportSize.X * ViewportSize.Y * 0.25 and emptyLayer(v75) then
                warn("[SparringController] an invisible layer was catching the mouse in the fight - let go: " .. v75:GetFullName())

                if v75:IsA("GuiButton") then
                    v75.Visible = false
                else
                    v75.Active = false
                end
            end
        end
    end
end

task.spawn(function() -- line: 712
    -- upvalues: LocalPlayer (copy), BoxingCamera (copy), v39 (copy), MenuState (copy), BackpackLock (copy), t5 (copy), t6 (copy), v71 (ref), freeMouseLayers (copy)
    while true do
        task.wait(0.5)

        local Character = LocalPlayer.Character
        local v76 = false
        local v77 = false
        local v78 = false
        local v79 = false
        local v80 = false

        if Character then
            v76 = true
        else
            v80 = true
        end

        if v76 then
            if Character:GetAttribute("Sparring") then
                v77 = true
            else
                v80 = true
            end
        end

        v76 = false

        if v77 then
            if Character:GetAttribute("RingBreak") then
                v80 = true
            else
                v76 = true
            end
        end

        v77 = false

        if v76 then
            if Character:GetAttribute("Downed") then
                v80 = true
            else
                v77 = true
            end
        end

        v76 = false

        if v77 then
            if LocalPlayer:GetAttribute("ReplayPlaying") then
                v80 = true
            else
                v76 = true
            end
        end

        v77 = false

        local v81

        if v76 then
            v81 = MenuState.Current()

            if v81 then
                v77 = true
            else
                v80 = false
            end
        end

        v76 = false

        if v77 then
            if v81 == "Walkout" then
                v80 = false
            else
                v76 = true
            end
        end

        v77 = false

        local v82, v83

        if v76 then
            local v84 = t5[v81] or "MainMenu"

            v82 = LocalPlayer.PlayerGui:FindFirstChild(v84)

            if v82 ~= nil then
                v77 = true
            else
                v83 = false
                v78 = true
            end
        end

        v76 = false

        if v77 then
            local ScreenGui = v82:IsA("ScreenGui")

            if ScreenGui then
                v76 = true
            else
                v83 = ScreenGui
                v78 = true
            end
        end

        v77 = false

        if v76 then
            v83 = v82.Enabled
            v78 = true
        end

        v76 = false

        if v78 then
            if v83 then
                v80 = false
            else
                v76 = true
            end
        end

        v78 = false

        if v76 then
            if t5[v81] ~= nil then
                v77 = true
            else
                v78 = true
            end
        end

        v76 = false

        local MainMenu, v85

        if v78 then
            MainMenu = LocalPlayer.PlayerGui:FindFirstChild("MainMenu")

            if MainMenu ~= nil then
                v76 = true
            else
                v85 = false
                v79 = true
            end
        end

        v78 = false

        if v76 then
            local ScreenGui = MainMenu:IsA("ScreenGui")

            if ScreenGui then
                v78 = true
            else
                v85 = ScreenGui
                v79 = true
            end
        end

        if v78 then
            v85 = MainMenu.Enabled
            v79 = true
        end

        if v79 then
            if v85 then
                v80 = false
            else
                v77 = true
            end
        end

        if v77 then
            warn("[SparringController] the " .. v81 .. " screen was holding the controls in the fight without being on screen - let go")
            v80 = false
            MenuState.Close(v81)
        end

        if not v80 then
            for v86, v87 in t6 do
                if BackpackLock.IsLocked(v86) then
                    local v88 = LocalPlayer.PlayerGui:FindFirstChild(v87)

                    if v88 == nil or not v88:IsA("ScreenGui") or not v88.Enabled then
                        warn("[SparringController] the " .. v86 .. " lock was left on in the fight - let go")
                        BackpackLock.Unlock(v86)
                    end
                end
            end

            local CurrentCamera = workspace.CurrentCamera
            local v89 = false

            if CurrentCamera.CameraType == Enum.CameraType.Scriptable then
                local WalkoutGui = LocalPlayer.PlayerGui:FindFirstChild("WalkoutGui")

                if WalkoutGui ~= nil then
                    if WalkoutGui:IsA("ScreenGui") and WalkoutGui.Enabled then
                    else
                        local KnockoutReplay = LocalPlayer.PlayerGui:FindFirstChild("KnockoutReplay")

                        v89 = if KnockoutReplay ~= nil then (not KnockoutReplay:IsA("ScreenGui") or not KnockoutReplay.Enabled) and not MenuState.IsOpen() else not MenuState.IsOpen()
                    end
                else
                    local KnockoutReplay = LocalPlayer.PlayerGui:FindFirstChild("KnockoutReplay")

                    v89 = if KnockoutReplay ~= nil then (not KnockoutReplay:IsA("ScreenGui") or not KnockoutReplay.Enabled) and not MenuState.IsOpen() else not MenuState.IsOpen()
                end
            end

            if v89 then
                v71 = v71 or os.clock()

                if os.clock() - v71 > 1 then
                    v71 = nil
                    warn("[SparringController] the camera was left scripted in the fight - given back")
                    CurrentCamera.CameraType = Enum.CameraType.Custom

                    local Humanoid = Character:FindFirstChildOfClass("Humanoid")

                    if Humanoid then
                        CurrentCamera.CameraSubject = Humanoid
                    end
                end

                if MenuState.Current() == "Walkout" then
                    local WalkoutGui = LocalPlayer.PlayerGui:FindFirstChild("WalkoutGui")

                    if not WalkoutGui or not WalkoutGui.Enabled then
                        warn("[SparringController] the walkout screen was still holding the controls in the fight - let go")
                        MenuState.Close("Walkout")
                    end
                end
            else
                v71 = nil

                if MenuState.Current() == "Walkout" then
                    local WalkoutGui = LocalPlayer.PlayerGui:FindFirstChild("WalkoutGui")

                    if not WalkoutGui or not WalkoutGui.Enabled then
                        warn("[SparringController] the walkout screen was still holding the controls in the fight - let go")
                        MenuState.Close("Walkout")
                    end
                end
            end

            if not MenuState.IsOpen() and not v39.Visible then
                pcall(freeMouseLayers)
            end

            if BoxingCamera.IsSuspended() and not MenuState.IsOpen() and not BackpackLock.IsLocked() and not v39.Visible then
                warn("[SparringController] punches were switched off with no screen open - switched back on")
                BoxingCamera.ReleaseSuspend()
            end
        end
    end
end)
