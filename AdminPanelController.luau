-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Boxing = ReplicatedStorage:WaitForChild("Boxing")
local AdminPanelRemote = Boxing:WaitForChild("AdminPanelRemote")
local AdminPanelEvent = Boxing:WaitForChild("AdminPanelEvent")
local MenuState = require(Boxing:WaitForChild("MenuState"))
local BoxingVirtualInput = require(Boxing:WaitForChild("BoxingVirtualInput"))
local t1 = {
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
local v1 = Font.new("rbxasset://fonts/families/Merriweather.json", Enum.FontWeight.Regular)
local v2 = Font.new("rbxasset://fonts/families/Merriweather.json", Enum.FontWeight.Bold)
local v3 = Font.new("rbxasset://fonts/families/Montserrat.json", Enum.FontWeight.Heavy, Enum.FontStyle.Italic)
local v4 = Color3.fromRGB(242, 236, 228)
local v5 = Color3.fromRGB(176, 166, 154)
local v6 = Color3.fromRGB(200, 30, 40)
local v7 = Color3.fromRGB(120, 230, 140)
local v8 = Color3.fromRGB(255, 200, 200)
local v9 = TweenInfo.new(0.12)

local function new(p1, p2, p3) -- line: 35
    local v10 = Instance.new(p1)

    for v11, v12 in p2 or {} do
        v10[v11] = v12
    end

    v10.Parent = p3

    return v10
end

local function art(p4, p5, p6) -- line: 44
    -- upvalues: t1 (copy)
    local v13 = t1[p5]
    local t2 = {
        BackgroundTransparency = 1,
        Name = p5 .. "Art",
        Size = UDim2.fromScale(1, 1),
        Image = v13.Id,
        ImageRectOffset = Vector2.new(v13.Rect[1], v13.Rect[2]),
        ImageRectSize = Vector2.new(v13.Rect[3], v13.Rect[4]),
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(v13.Slice[1], v13.Slice[2], v13.Slice[3], v13.Slice[4]),
        SliceScale = v13.Scale or 1
    }
    local ImageLabel = Instance.new("ImageLabel")

    for v14, v15 in t2 or {} do
        ImageLabel[v14] = v15
    end

    ImageLabel.Parent = nil

    if v13.FitHeight then
        local function fit() -- line: 52
            -- upvalues: v13 (copy), ImageLabel (copy)
            local Y = ImageLabel.AbsoluteSize.Y

            if Y > 0 then
                ImageLabel.SliceScale = Y / v13.Rect[4]
            end
        end

        ImageLabel:GetPropertyChangedSignal("AbsoluteSize"):Connect(fit)
        task.defer(fit)
    end

    for v16, v17 in p6 or {} do
        ImageLabel[v16] = v17
    end

    ImageLabel.Parent = p4

    return ImageLabel
end

local function ink(p7, p8) -- line: 68
    local t3 = {
        Color = Color3.new(0, 0, 0),
        Thickness = p8 or 1.2
    }
    local UIStroke = Instance.new("UIStroke")

    for v18, v19 in t3 or {} do
        UIStroke[v18] = v19
    end

    UIStroke.Parent = p7
end

local function label(p9, p10) -- line: 72
    -- upvalues: v2 (copy), v4 (copy)
    local t4 = {
        BackgroundTransparency = 1,
        TextSize = 15,
        FontFace = v2,
        TextColor3 = v4,
        TextXAlignment = Enum.TextXAlignment.Left
    }
    local TextLabel = Instance.new("TextLabel")

    for v20, v21 in t4 or {} do
        TextLabel[v20] = v21
    end

    TextLabel.Parent = nil

    for v22, v23 in p10 do
        TextLabel[v22] = v23
    end

    TextLabel.Parent = p9

    return TextLabel
end

local function button(p11, p12, p13, p14) -- line: 82
    -- upvalues: TweenService (copy), v8 (copy), v9 (copy), art (copy), label (copy)
    local t5 = {
        Text = "",
        AutoButtonColor = false,
        BackgroundTransparency = 1,
        ZIndex = 4,
        Name = p12,
        Position = p13,
        Size = p14
    }
    local TextButton = Instance.new("TextButton")

    for v24, v25 in t5 or {} do
        TextButton[v24] = v25
    end

    TextButton.Parent = p11
    TextButton:SetAttribute("MangaAccent", true)

    local v26 = art(TextButton, "Button", {
        ZIndex = 4
    })
    local v27 = label(TextButton, {
        Name = "Label",
        TextSize = 15,
        ZIndex = 5,
        Text = p12,
        TextXAlignment = Enum.TextXAlignment.Center,
        Size = UDim2.new(1, -14, 1, 0)
    })
    local t6 = {
        Thickness = 1.2,
        Color = Color3.new(0, 0, 0)
    }
    local UIStroke = Instance.new("UIStroke")

    for v28, v29 in t6 or {} do
        UIStroke[v28] = v29
    end

    UIStroke.Parent = v27

    local function hover(p15) -- line: 90
        -- upvalues: TextButton (copy), v26 (copy), TweenService (copy), v8 (copy), v9 (copy)
        TweenService:Create(v26, v9, {
            ImageColor3 = if p15 then v8 else TextButton:GetAttribute("Tint") or Color3.new(1, 1, 1)
        }):Play()
    end

    TextButton.MouseEnter:Connect(function() -- line: 93
        -- upvalues: hover (copy)
        hover(true)
    end)
    TextButton.MouseLeave:Connect(function() -- line: 96
        -- upvalues: hover (copy)
        hover(false)
    end)
    TextButton.SelectionGained:Connect(function() -- line: 99
        -- upvalues: hover (copy)
        hover(true)
    end)
    TextButton.SelectionLost:Connect(function() -- line: 102
        -- upvalues: hover (copy)
        hover(false)
    end)

    return TextButton, v27, v26
end

local function textBox(p16, p17, p18, p19, p20) -- line: 108
    -- upvalues: v1 (copy), v4 (copy), v5 (copy)
    local t8 = {
        Text = "",
        ClearTextOnFocus = false,
        TextWrapped = true,
        TextSize = 14,
        BackgroundTransparency = 0.15,
        BorderSizePixel = 0,
        ZIndex = 4,
        PlaceholderText = p17,
        MultiLine = p20 == true,
        FontFace = v1,
        TextColor3 = v4,
        PlaceholderColor3 = v5,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = if p20 then Enum.TextYAlignment.Top else Enum.TextYAlignment.Center,
        BackgroundColor3 = Color3.fromRGB(16, 15, 18),
        Position = p18,
        Size = p19
    }
    local TextBox = Instance.new("TextBox")

    for v30, v31 in t8 or {} do
        TextBox[v30] = v31
    end

    TextBox.Parent = p16

    local t9 = {
        CornerRadius = UDim.new(0, 6)
    }
    local UICorner = Instance.new("UICorner")

    for v32, v33 in t9 or {} do
        UICorner[v32] = v33
    end

    UICorner.Parent = TextBox

    local t10 = {
        Thickness = 1.2,
        Color = Color3.fromRGB(110, 108, 118),
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    }
    local UIStroke = Instance.new("UIStroke")

    for v34, v35 in t10 or {} do
        UIStroke[v34] = v35
    end

    UIStroke.Parent = TextBox

    local t11 = {
        PaddingLeft = UDim.new(0, 8),
        PaddingRight = UDim.new(0, 8),
        PaddingTop = UDim.new(0, 4),
        PaddingBottom = UDim.new(0, 4)
    }
    local UIPadding = Instance.new("UIPadding")

    for v36, v37 in t11 or {} do
        UIPadding[v36] = v37
    end

    UIPadding.Parent = TextBox

    return TextBox
end

local function heading(p21, p22, p23, p24) -- line: 121
    -- upvalues: v3 (copy), label (copy)
    local v38 = label(p21, {
        TextSize = 17,
        ZIndex = 4,
        Text = p22,
        FontFace = v3,
        Position = p23,
        Size = UDim2.fromOffset(p24 or 300, 22)
    })
    local t12 = {
        Thickness = 1,
        Color = Color3.new(0, 0, 0)
    }
    local UIStroke = Instance.new("UIStroke")

    for v39, v40 in t12 or {} do
        UIStroke[v39] = v40
    end

    UIStroke.Parent = v38

    return v38
end

local t13 = {
    Name = "Announcements",
    ResetOnSpawn = false,
    DisplayOrder = 400,
    IgnoreGuiInset = true
}
local ScreenGui = Instance.new("ScreenGui")

for v41, v42 in t13 or {} do
    ScreenGui[v41] = v42
end

ScreenGui.Parent = PlayerGui

local t14 = {}
local v43 = false

local function showNext() -- line: 130
    -- upvalues: TweenService (copy), v1 (copy), v3 (copy), v5 (copy), v6 (copy), art (copy), label (copy), ScreenGui (copy), t14 (copy), v43 (ref), showNext (copy)
    if v43 or #t14 == 0 then
        return
    end

    v43 = true

    local v44 = table.remove(t14, 1)
    local t15 = {
        Name = "Announcement",
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(0.5, 1),
        Position = UDim2.new(0.5, 0, 0, -10),
        Size = UDim2.fromOffset(620, 150)
    }
    local Frame = Instance.new("Frame")

    for v45, v46 in t15 or {} do
        Frame[v45] = v46
    end

    Frame.Parent = ScreenGui

    local t16 = {
        Scale = math.clamp(workspace.CurrentCamera.ViewportSize.Y / 1000, 0.6, 1.2)
    }
    local UIScale = Instance.new("UIScale")

    for v48, v49 in t16 or {} do
        UIScale[v48] = v49
    end

    UIScale.Parent = Frame
    art(Frame, "Panel", {
        ZIndex = 1,
        Position = UDim2.fromOffset(-6, -6),
        Size = UDim2.new(1, 12, 1, 12)
    })

    local v50 = label(Frame, {
        TextSize = 24,
        ZIndex = 3,
        Text = v44.Global and "ANNOUNCEMENT  -  EVERY SERVER" or "ANNOUNCEMENT",
        FontFace = v3,
        TextColor3 = Color3.fromRGB(255, 120, 120),
        Position = UDim2.fromOffset(24, 14),
        Size = UDim2.new(1, -48, 0, 30)
    })
    local t18 = {
        Thickness = 1.5,
        Color = Color3.new(0, 0, 0)
    }
    local UIStroke = Instance.new("UIStroke")

    for v51, v52 in t18 or {} do
        UIStroke[v51] = v52
    end

    UIStroke.Parent = v50

    local t19 = {
        BorderSizePixel = 0,
        ZIndex = 3,
        BackgroundColor3 = v6,
        Position = UDim2.fromOffset(24, 46),
        Size = UDim2.new(0.38, 0, 0, 3)
    }
    local Frame2 = Instance.new("Frame")

    for v53, v54 in t19 or {} do
        Frame2[v53] = v54
    end

    Frame2.Parent = Frame

    local v55 = label(Frame, {
        TextSize = 19,
        TextWrapped = true,
        ZIndex = 3,
        Text = v44.Text,
        TextYAlignment = Enum.TextYAlignment.Top,
        Position = UDim2.fromOffset(24, 56),
        Size = UDim2.new(1, -48, 0, 62)
    })
    local t20 = {
        Thickness = 1.2,
        Color = Color3.new(0, 0, 0)
    }
    local UIStroke2 = Instance.new("UIStroke")

    for v56, v57 in t20 or {} do
        UIStroke2[v56] = v57
    end

    UIStroke2.Parent = v55
    label(Frame, {
        TextSize = 14,
        ZIndex = 3,
        Text = "- " .. tostring(v44.From or "admin"),
        FontFace = v1,
        TextColor3 = v5,
        TextXAlignment = Enum.TextXAlignment.Right,
        Position = UDim2.new(0, 24, 1, -30),
        Size = UDim2.new(1, -48, 0, 20)
    })
    TweenService:Create(Frame, TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.new(0.5, 0, 0, 230)
    }):Play()
    task.delay(math.clamp(#v44.Text / 18 + 5, 6, 14), function() -- line: 157
        -- upvalues: Frame (copy), TweenService (copy), v43 (ref), showNext (copy)
        local tween = TweenService:Create(Frame, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Position = UDim2.new(0.5, 0, 0, -10)
        })

        tween.Completed:Connect(function() -- line: 159
            -- upvalues: Frame (copy), v43 (ref), showNext (copy)
            Frame:Destroy()
            v43 = false
            showNext()
        end)
        tween:Play()
    end)
end

local t22

local function stopFly() -- line: 170
    -- upvalues: LocalPlayer (copy), t22 (ref)
    if not t22 then
        return
    end

    t22.Conn:Disconnect()
    t22.Velocity:Destroy()
    t22.Align:Destroy()
    t22.Attachment:Destroy()

    local v60 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")

    if v60 then
        v60.PlatformStand = false
    end

    t22 = nil
end

local function startFly() -- line: 183
    -- upvalues: RunService (copy), UserInputService (copy), LocalPlayer (copy), BoxingVirtualInput (copy), t22 (ref), stopFly (copy)
    stopFly()

    local Character = LocalPlayer.Character
    local v61

    if Character then
        v61 = Character:FindFirstChild("HumanoidRootPart")
        Character = Character:FindFirstChildOfClass("Humanoid")
    else
        v61 = Character
    end

    if not (v61 and Character) then
        return
    end

    local t23 = {
        Name = "AdminFly"
    }
    local Attachment = Instance.new("Attachment")

    for v62, v63 in t23 or {} do
        Attachment[v62] = v63
    end

    Attachment.Parent = v61

    local t24 = {
        Name = "AdminFlyVelocity",
        MaxForce = 1e999,
        VectorVelocity = Vector3.new(0, 0, 0),
        Attachment0 = Attachment,
        RelativeTo = Enum.ActuatorRelativeTo.World
    }
    local LinearVelocity = Instance.new("LinearVelocity")

    for v64, v65 in t24 or {} do
        LinearVelocity[v64] = v65
    end

    LinearVelocity.Parent = v61

    local t25 = {
        Name = "AdminFlyAlign",
        MaxTorque = 1e999,
        Responsiveness = 40,
        Mode = Enum.OrientationAlignmentMode.OneAttachment,
        Attachment0 = Attachment,
        CFrame = v61.CFrame.Rotation
    }
    local AlignOrientation = Instance.new("AlignOrientation")

    for v66, v67 in t25 or {} do
        AlignOrientation[v66] = v67
    end

    AlignOrientation.Parent = v61
    Character.PlatformStand = true
    t22 = {
        Attachment = Attachment,
        Velocity = LinearVelocity,
        Align = AlignOrientation,
        Conn = RunService.RenderStepped:Connect(function() -- line: 201
            -- upvalues: Character (ref), LinearVelocity (copy), AlignOrientation (copy), v61 (ref), UserInputService (copy), BoxingVirtualInput (copy)
            local MoveDirection, v68

            if not v61.Parent or UserInputService:GetFocusedTextBox() then
                LinearVelocity.VectorVelocity = Vector3.new(0, 0, 0)

                return
            else
                local CurrentCamera = workspace.CurrentCamera

                MoveDirection = Character.MoveDirection
                v68 = CurrentCamera.CFrame.LookVector * Vector3.new(1, 0, 1)

                if v68.Magnitude > 0.001 and MoveDirection.Magnitude > 0.05 then
                    local v70 = MoveDirection:Dot(v68.Unit)

                    MoveDirection += Vector3.new(0, CurrentCamera.CFrame.LookVector.Y * v70, 0)
                end
            end

            if UserInputService:IsKeyDown(Enum.KeyCode.Space) or BoxingVirtualInput.IsDown("Block") then
                MoveDirection += Vector3.new(0, 1, 0)
            end

            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                MoveDirection -= Vector3.new(0, 1, 0)
            end

            local v72 = if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then 140 else 60

            LinearVelocity.VectorVelocity = if MoveDirection.Magnitude > 0.05 then MoveDirection.Unit * v72 else Vector3.new(0, 0, 0)

            if v68.Magnitude > 0.001 then
                AlignOrientation.CFrame = CFrame.lookAt(Vector3.new(0, 0, 0), v68.Unit)
            end
        end)
    }
end

local t26

local function stopNoclip() -- line: 230
    -- upvalues: t26 (ref)
    if not t26 then
        return
    end

    t26.Conn:Disconnect()

    for v74, v75 in t26.Saved do
        if v74.Parent then
            v74.CanCollide = v75
        end
    end

    t26 = nil
end

local function startNoclip() -- line: 241
    -- upvalues: RunService (copy), LocalPlayer (copy), t26 (ref)
    if t26 then
        t26.Conn:Disconnect()

        for v76, v77 in t26.Saved do
            if v76.Parent then
                v76.CanCollide = v77
            end
        end

        t26 = nil
    end

    local t27 = {}

    t26 = {
        Conn = RunService.Stepped:Connect(function() -- line: 244
            -- upvalues: t27 (copy), LocalPlayer (copy)
            local Character = LocalPlayer.Character

            if Character then
                for _, descendant in Character:GetDescendants() do
                    if descendant:IsA("BasePart") and descendant.CanCollide then
                        if t27[descendant] == nil then
                            t27[descendant] = true
                        end

                        descendant.CanCollide = false
                    end
                end
            end
        end),
        Saved = t27
    }
end

local function syncPowers() -- line: 261
    -- upvalues: LocalPlayer (copy), t22 (ref), stopFly (copy), startFly (copy), t26 (ref), startNoclip (copy)
    if LocalPlayer:GetAttribute("AdminFly") then
        if not (t22 and t22.Attachment.Parent) then
            startFly()
        end
    else
        stopFly()
    end

    if LocalPlayer:GetAttribute("AdminNoclip") then
        if not t26 then
            startNoclip()
        end
    elseif t26 then
        t26.Conn:Disconnect()

        for v78, v79 in t26.Saved do
            if v78.Parent then
                v78.CanCollide = v79
            end
        end

        t26 = nil
    end
end

LocalPlayer:GetAttributeChangedSignal("AdminFly"):Connect(syncPowers)
LocalPlayer:GetAttributeChangedSignal("AdminNoclip"):Connect(syncPowers)
LocalPlayer.CharacterAdded:Connect(function(p25) -- line: 279
    -- upvalues: t22 (ref), t26 (ref), syncPowers (copy)
    t22 = nil

    if t26 then
        table.clear(t26.Saved)
    end

    p25:WaitForChild("HumanoidRootPart", 10)
    syncPowers()
end)

local Role
local v80 = {}
local ServerName, ScreenGui2, ScreenGui3, v81, refreshPlayers, setStatus, UserId
local v82 = false

local function can(p26) -- line: 295
    -- upvalues: v80 (ref)
    return table.find(v80, p26) ~= nil
end

local function ask(p27, ...) -- line: 299
    -- upvalues: AdminPanelRemote (copy)
    local InvokeServer = AdminPanelRemote.InvokeServer
    local v83, v84, v85 = pcall(InvokeServer, AdminPanelRemote, p27, ...)

    if v83 then
        return v84, v85
    end

    return false, "Couldn't reach the server"
end

local function setOpen(p28) -- line: 307
    -- upvalues: GuiService (copy), MenuState (copy), BoxingVirtualInput (copy), ScreenGui2 (ref), ScreenGui3 (ref), refreshPlayers (ref), v82 (ref)
    if not ScreenGui2 or p28 == v82 then
        return
    end

    local AdminPanel = if p28 then MenuState.Open("AdminPanel") else nil

    if not p28 or AdminPanel then
        v82 = p28
        ScreenGui3.Visible = p28

        if p28 then
            refreshPlayers()

            if BoxingVirtualInput.Mode() == "Gamepad" then
                GuiService.SelectedObject = ScreenGui3:FindFirstChild("Fly", true)
            end
        else
            MenuState.Close("AdminPanel")

            if GuiService.SelectedObject and GuiService.SelectedObject:IsDescendantOf(ScreenGui3) then
                GuiService.SelectedObject = nil
            end
        end
    end
end

local t28 = {
    { 3600, "1 HOUR" },
    { 86400, "1 DAY" },
    { 604800, "7 DAYS" },
    { -1, "FOREVER" }
}

local function build() -- line: 331
    -- upvalues: Players (copy), GuiService (copy), LocalPlayer (copy), PlayerGui (copy), MenuState (copy), BoxingVirtualInput (copy), v1 (copy), v2 (copy), v3 (copy), v4 (copy), v5 (copy), v6 (copy), v7 (copy), art (copy), label (copy), button (copy), textBox (copy), heading (copy), Role (ref), v80 (ref), ServerName (ref), ScreenGui2 (ref), ScreenGui3 (ref), v81 (ref), refreshPlayers (ref), setStatus (ref), UserId (ref), v82 (ref), ask (copy), setOpen (copy), t28 (copy)
    local v86 = {
        Name = "AdminPanel",
        ResetOnSpawn = false,
        DisplayOrder = 300,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    }
    local ScreenGui = Instance.new("ScreenGui")

    for v87, v88 in v86 or {} do
        ScreenGui[v87] = v88
    end

    ScreenGui.Parent = PlayerGui
    ScreenGui2 = ScreenGui
    v86 = ScreenGui2
    v81 = button(v86, Role == "Host" and "HOST" or "ADMIN", UDim2.new(1, -112, 0.5, -170), UDim2.fromOffset(96, 34))
    v81.Activated:Connect(function() -- line: 335
        -- upvalues: v82 (ref), setOpen (copy)
        setOpen(not v82)
    end)
    v86 = {
        Name = "Panel",
        BackgroundTransparency = 1,
        Visible = false,
        Active = true,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.52),
        Size = UDim2.fromOffset(660, 610)
    }

    local v89 = ScreenGui2

    ScreenGui = Instance.new("Frame")

    for v90, v91 in v86 or {} do
        ScreenGui[v90] = v91
    end

    ScreenGui.Parent = v89
    ScreenGui3 = ScreenGui

    local v92 = {}

    v89 = ScreenGui3

    local UIScale = Instance.new("UIScale")

    for v93, v94 in v92 or {} do
        UIScale[v93] = v94
    end

    UIScale.Parent = v89

    local function fit() -- line: 343
        -- upvalues: UIScale (copy)
        UIScale.Scale = math.clamp(workspace.CurrentCamera.ViewportSize.Y / 800, 0.55, 1.3)
    end

    workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(fit)
    UIScale.Scale = math.clamp(workspace.CurrentCamera.ViewportSize.Y / 800, 0.55, 1.3)
    art(ScreenGui3, "Panel", {
        ZIndex = 1,
        Position = UDim2.fromOffset(-6, -6),
        Size = UDim2.new(1, 12, 1, 12)
    })
    v89 = ScreenGui3
    ScreenGui = {
        TextSize = 30,
        ZIndex = 3
    }
    ScreenGui.Text = Role == "Host" and "HOST PANEL" or "ADMIN PANEL"
    ScreenGui.FontFace = v3
    ScreenGui.Position = UDim2.fromOffset(26, 18)
    ScreenGui.Size = UDim2.new(1, -110, 0, 36)
    v92 = label(v89, ScreenGui)
    v89 = {
        Thickness = 1.5,
        Color = Color3.new(0, 0, 0)
    }
    ScreenGui = Instance.new("UIStroke")

    for v96, v97 in v89 or {} do
        ScreenGui[v96] = v97
    end

    ScreenGui.Parent = v92
    v89 = {
        BorderSizePixel = 0,
        ZIndex = 3,
        BackgroundColor3 = v6,
        Position = UDim2.fromOffset(26, 56),
        Size = UDim2.new(0.38, 0, 0, 3)
    }
    ScreenGui = ScreenGui3

    local Frame = Instance.new("Frame")

    for v98, v99 in v89 or {} do
        Frame[v98] = v99
    end

    Frame.Parent = ScreenGui
    ScreenGui = ScreenGui3
    Frame = {
        TextSize = 13,
        ZIndex = 3
    }

    if Role == "Host" then
        Frame.Text = "You host " .. tostring(ServerName or "this server") .. " - these work in this server only."
    else
        Frame.Text = "Every command, in any server. Everything you do is logged."
    end

    Frame.FontFace = v1
    Frame.TextColor3 = v5
    Frame.Position = UDim2.fromOffset(26, 64)
    Frame.Size = UDim2.new(1, -52, 0, 18)
    label(ScreenGui, Frame)
    ScreenGui = {
        Name = "Close",
        Text = "X",
        TextSize = 20,
        AutoButtonColor = false,
        BackgroundTransparency = 0.1,
        BorderSizePixel = 0,
        ZIndex = 4,
        FontFace = v2,
        TextColor3 = v4,
        BackgroundColor3 = Color3.fromRGB(28, 26, 30),
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, -20, 0, 18),
        Size = UDim2.fromOffset(38, 38)
    }
    Frame = ScreenGui3

    local TextButton = Instance.new("TextButton")

    for v101, v102 in ScreenGui or {} do
        TextButton[v101] = v102
    end

    TextButton.Parent = Frame
    ScreenGui = {
        CornerRadius = UDim.new(0, 6)
    }
    Frame = Instance.new("UICorner")

    for v103, v104 in ScreenGui or {} do
        Frame[v103] = v104
    end

    Frame.Parent = TextButton
    ScreenGui = {
        Thickness = 1.5,
        Color = Color3.fromRGB(165, 165, 172),
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    }
    Frame = Instance.new("UIStroke")

    for v105, v106 in ScreenGui or {} do
        Frame[v105] = v106
    end

    Frame.Parent = TextButton
    TextButton.Activated:Connect(function() -- line: 367
        -- upvalues: GuiService (copy), MenuState (copy), ScreenGui2 (ref), ScreenGui3 (ref), v82 (ref)
        if not ScreenGui2 or v82 == false then
            return
        end

        v82 = false
        ScreenGui3.Visible = false
        MenuState.Close("AdminPanel")

        if GuiService.SelectedObject and GuiService.SelectedObject:IsDescendantOf(ScreenGui3) then
            GuiService.SelectedObject = nil
        end
    end)
    heading(ScreenGui3, "PLAYERS", UDim2.fromOffset(26, 96), 220)
    ScreenGui = {
        Name = "Players",
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 5,
        ZIndex = 3,
        Position = UDim2.fromOffset(22, 124),
        Size = UDim2.fromOffset(236, 380),
        CanvasSize = UDim2.new(),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ScrollingDirection = Enum.ScrollingDirection.Y
    }
    Frame = ScreenGui3

    local ScrollingFrame = Instance.new("ScrollingFrame")

    for v107, v108 in ScreenGui or {} do
        ScrollingFrame[v107] = v108
    end

    ScrollingFrame.Parent = Frame
    ScreenGui = button(ScreenGui3, "REFRESH", UDim2.fromOffset(22, 512), UDim2.fromOffset(236, 36))

    local v109

    Frame, v109 = button(ScreenGui3, "X2 STATS: OFF", UDim2.fromOffset(22, 556), UDim2.fromOffset(236, 36))
    Frame.Visible = table.find(v80, "StatEvent") ~= nil

    local function paintEvent() -- line: 381
        -- upvalues: v109 (ref), v4 (copy)
        local v110 = workspace:GetAttribute("StatEventOn") == true

        v109.Text = "X2 STATS EVENT: " .. (v110 and "ON" or "OFF")

        local v111 = if v110 then Color3.fromRGB(255, 210, 90) else v4

        v109.TextColor3 = v111
    end

    workspace:GetAttributeChangedSignal("StatEventOn"):Connect(paintEvent)

    local v112 = workspace:GetAttribute("StatEventOn") == true

    v109.Text = "X2 STATS EVENT: " .. (v112 and "ON" or "OFF")

    if v112 then
        v109.TextColor3 = Color3.fromRGB(255, 210, 90)
    else
        v109.TextColor3 = v4
    end

    Frame.Activated:Connect(function() -- line: 388
        -- upvalues: setStatus (ref), ask (copy)
        local v113, v114 = ask("StatEvent", workspace:GetAttribute("StatEventOn") ~= true)

        setStatus(v114, v113 == true)
    end)
    heading(ScreenGui3, "YOU", UDim2.fromOffset(280, 96))

    local v115 = if table.find(v80, "BTools") ~= nil then 114 else 174
    local v116

    v112, v116 = button(ScreenGui3, "Fly", UDim2.fromOffset(280, 122), UDim2.fromOffset(v115, 36))

    local v117, v118 = button(ScreenGui3, "Noclip", UDim2.fromOffset(v115 + 280 + 7, 122), UDim2.fromOffset(v115, 36))
    local v119, v120 = button(ScreenGui3, "BTools", UDim2.fromOffset(522, 122), UDim2.fromOffset(114, 36))

    v119.Visible = table.find(v80, "BTools") ~= nil

    local v121 = heading(ScreenGui3, "PICK A PLAYER", UDim2.fromOffset(280, 172), 356)
    local v122 = ScreenGui3
    local v123 = UDim2.fromOffset(280, 198)
    local v124 = UDim2.fromOffset
    local v125 = button(v122, "FLING", v123, v124(114, 36))
    local v126 = button(ScreenGui3, "KICK", UDim2.fromOffset(401, 198), UDim2.fromOffset(114, 36))
    local v127

    v122, v127 = button(ScreenGui3, "BAN", UDim2.fromOffset(522, 198), UDim2.fromOffset(114, 36))

    local n1 = 2
    local v128

    v124, v128 = button(ScreenGui3, "BAN: 1 DAY", UDim2.fromOffset(280, 242), UDim2.fromOffset(174, 34))

    if Role == "Host" then
        v128.Text = "BAN: THIS SERVER"
    end

    local v129 = textBox(ScreenGui3, "Reason (optional)", UDim2.fromOffset(462, 242), UDim2.fromOffset(174, 34))
    local GIVE = heading(ScreenGui3, "GIVE", UDim2.fromOffset(280, 290))
    local v130 = textBox(ScreenGui3, "Amount", UDim2.fromOffset(280, 316), UDim2.fromOffset(110, 36))
    local v131 = button(ScreenGui3, "GIVE YEN", UDim2.fromOffset(398, 316), UDim2.fromOffset(116, 36))
    local v132 = button(ScreenGui3, "GIVE REROLLS", UDim2.fromOffset(520, 316), UDim2.fromOffset(116, 36))

    heading(ScreenGui3, "MESSAGE", UDim2.fromOffset(280, 368))

    local v133 = textBox(ScreenGui3, "Type a message...", UDim2.fromOffset(280, 394), UDim2.fromOffset(356, 70), true)
    local v134 = button(ScreenGui3, "THIS SERVER", UDim2.fromOffset(280, 472), UDim2.fromOffset(174, 36))
    local v135 = button(ScreenGui3, "ALL SERVERS", UDim2.fromOffset(462, 472), UDim2.fromOffset(174, 36))
    local v136 = label(ScreenGui3, {
        Text = "",
        TextSize = 14,
        TextWrapped = true,
        ZIndex = 3,
        FontFace = v1,
        TextColor3 = v5,
        Position = UDim2.fromOffset(280, 520),
        Size = UDim2.fromOffset(356, 50)
    })

    for _, v137 in {
            { GIVE, "GiveYen" },
            { v130, "GiveYen" },
            { v131, "GiveYen" },
            { v132, "GiveRerolls" },
            { v135, "GlobalMessage" }
        } do
        local v138 = v137[1]
        local v139 = v137[2]

        v138.Visible = table.find(v80, v139) ~= nil
    end

    function setStatus(p29, p30) -- line: 430
        -- upvalues: v136 (copy), v5 (copy), v7 (copy)
        v136.Text = p29 or ""
        v136.TextColor3 = if p30 == true then v7 elseif p30 == false then Color3.fromRGB(255, 140, 140) else v5
    end

    local t29 = {}
    local t30 = {}

    function refreshPlayers() -- line: 437
        -- upvalues: ScrollingFrame (copy), v121 (copy), t29 (copy), t30 (copy), v4 (copy), button (copy), UserId (ref), ask (copy)
        local Players = ask("Players")

        for _, v141 in t30 do
            v141:Destroy()
        end

        table.clear(t30)

        if type(Players) ~= "table" then
            return
        end

        table.sort(Players, function(p31, p32) -- line: 446
            return string.lower(p31.DisplayName) < string.lower(p32.DisplayName)
        end)

        local v142 = false

        for v143, v144 in Players do
            local v146, v147 = button(ScrollingFrame, v144.DisplayName .. (if v144.Admin then "  (admin)" else ""), UDim2.fromOffset(2, (v143 - 1) * 40), UDim2.new(1, -10, 0, 36))

            v147.TextXAlignment = Enum.TextXAlignment.Left
            v147.Position = UDim2.fromOffset(12, 0)
            t29[v144.UserId] = v144.DisplayName

            if v144.UserId == UserId then
                v142 = true
                v147.TextColor3 = Color3.fromRGB(255, 150, 150)
            end

            v146.Activated:Connect(function() -- line: 460
                -- upvalues: v144 (copy), v146 (copy), v121 (copy), t30 (copy), v4 (copy), UserId (ref)
                UserId = v144.UserId
                v121.Text = "PICKED: " .. string.upper(v144.DisplayName) .. "  (@" .. v144.Name .. ")"

                for _, v148 in t30 do
                    local Label = v148:FindFirstChild("Label")

                    if Label then
                        if v148 == v146 then
                            Label.TextColor3 = Color3.fromRGB(255, 150, 150)
                        else
                            Label.TextColor3 = v4
                        end
                    end
                end
            end)
            table.insert(t30, v146)
        end

        if not v142 then
            UserId = nil
            v121.Text = "PICK A PLAYER"
        end
    end

    local Activated = ScreenGui.Activated
    local refreshPlayers2 = refreshPlayers

    Activated:Connect(refreshPlayers2)

    local function paintPowers() -- line: 479
        -- upvalues: v116 (ref), v118 (copy), v120 (copy), LocalPlayer (copy)
        v116.Text = "FLY: " .. (LocalPlayer:GetAttribute("AdminFly") and "ON" or "OFF")
        v118.Text = "NOCLIP: " .. (LocalPlayer:GetAttribute("AdminNoclip") and "ON" or "OFF")
        v120.Text = "BTOOLS: " .. (LocalPlayer:GetAttribute("AdminBTools") and "ON" or "OFF")
    end

    LocalPlayer:GetAttributeChangedSignal("AdminFly"):Connect(paintPowers)
    LocalPlayer:GetAttributeChangedSignal("AdminNoclip"):Connect(paintPowers)
    LocalPlayer:GetAttributeChangedSignal("AdminBTools"):Connect(paintPowers)
    v116.Text = "FLY: " .. (LocalPlayer:GetAttribute("AdminFly") and "ON" or "OFF")
    v118.Text = "NOCLIP: " .. (LocalPlayer:GetAttribute("AdminNoclip") and "ON" or "OFF")
    v120.Text = "BTOOLS: " .. (LocalPlayer:GetAttribute("AdminBTools") and "ON" or "OFF")
    v112.Activated:Connect(function() -- line: 488
        -- upvalues: LocalPlayer (copy), setStatus (ref), ask (copy)
        local v149, v150 = ask("Fly", not LocalPlayer:GetAttribute("AdminFly"))

        setStatus(v150, v149 == true)
    end)
    v117.Activated:Connect(function() -- line: 492
        -- upvalues: LocalPlayer (copy), setStatus (ref), ask (copy)
        local v151, v152 = ask("Noclip", not LocalPlayer:GetAttribute("AdminNoclip"))

        setStatus(v152, v151 == true)
    end)
    v119.Activated:Connect(function() -- line: 496
        -- upvalues: GuiService (copy), LocalPlayer (copy), MenuState (copy), ScreenGui2 (ref), ScreenGui3 (ref), setStatus (ref), v82 (ref), ask (copy)
        local v153 = not LocalPlayer:GetAttribute("AdminBTools")
        local v154, v155 = ask("BTools", v153)
        local setStatus2 = setStatus

        if v154 and v153 then
            v155 = "Build tools on - the bar is at the bottom of the screen"
        end

        setStatus2(v155, v154 == true)

        if not (v154 and v153 and ScreenGui2) or v82 == false then
            return
        end

        v82 = false
        ScreenGui3.Visible = false
        MenuState.Close("AdminPanel")

        if GuiService.SelectedObject and GuiService.SelectedObject:IsDescendantOf(ScreenGui3) then
            GuiService.SelectedObject = nil
        end
    end)

    local function onTarget(p33, ...) -- line: 505
        -- upvalues: refreshPlayers (ref), setStatus (ref), UserId (ref), ask (copy)
        if not UserId then
            setStatus("Pick a player on the left first", false)

            return
        end

        local v156, v157 = ask(p33, UserId, ...)

        setStatus(v157, v156 == true)

        if v156 and (p33 == "Kick" or p33 == "Ban") then
            task.delay(0.5, refreshPlayers)
        end
    end

    v125.Activated:Connect(function() -- line: 516
        -- upvalues: onTarget (copy)
        onTarget("Fling")
    end)
    v126.Activated:Connect(function() -- line: 519
        -- upvalues: onTarget (copy)
        onTarget("Kick")
    end)

    local n2 = 0

    v122.Activated:Connect(function() -- line: 524
        -- upvalues: v127 (ref), n1 (ref), v129 (copy), t29 (copy), onTarget (copy), n2 (ref), setStatus (ref), UserId (ref), t28 (copy)
        if not UserId then
            setStatus("Pick a player on the left first", false)

            return
        end

        if os.clock() - n2 > 3 then
            n2 = os.clock()
            v127.Text = "SURE?"
            setStatus("Press BAN again to ban " .. tostring(t29[UserId] or "them"), nil)
            task.delay(3, function() -- line: 533
                -- upvalues: v127 (ref), n2 (ref)
                if os.clock() - n2 >= 3 then
                    v127.Text = "BAN"
                end
            end)
        else
            n2 = 0
            v127.Text = "BAN"
            onTarget("Ban", t28[n1][1], v129.Text)
        end
    end)
    v124.Activated:Connect(function() -- line: 544
        -- upvalues: n1 (ref), v128 (ref), Role (ref), t28 (copy)
        if Role ~= "Host" then
            n1 = n1 % #t28 + 1
            v128.Text = "BAN: " .. t28[n1][2]
        end
    end)
    v131.Activated:Connect(function() -- line: 551
        -- upvalues: v130 (copy), onTarget (copy)
        onTarget("GiveYen", (tonumber(v130.Text)))
    end)
    v132.Activated:Connect(function() -- line: 554
        -- upvalues: v130 (copy), onTarget (copy)
        onTarget("GiveRerolls", (tonumber(v130.Text)))
    end)
    v134.Activated:Connect(function() -- line: 557
        -- upvalues: v133 (copy), setStatus (ref), ask (copy)
        local v160, v161 = ask("ServerMessage", v133.Text)

        setStatus(v161, v160 == true)

        if v160 then
            v133.Text = ""
        end
    end)
    v135.Activated:Connect(function() -- line: 564
        -- upvalues: v133 (copy), setStatus (ref), ask (copy)
        local v162, v163 = ask("GlobalMessage", v133.Text)

        setStatus(v163, v162 == true)

        if v162 then
            v133.Text = ""
        end
    end)
    BoxingVirtualInput.Changed:Connect(function(p34, p35) -- line: 572
        -- upvalues: GuiService (copy), MenuState (copy), ScreenGui2 (ref), ScreenGui3 (ref), v82 (ref)
        if not p35 or p34 ~= "Back" or not v82 or not ScreenGui2 or v82 == false then
            return
        end

        v82 = false
        ScreenGui3.Visible = false
        MenuState.Close("AdminPanel")

        if GuiService.SelectedObject and GuiService.SelectedObject:IsDescendantOf(ScreenGui3) then
            GuiService.SelectedObject = nil
        end
    end)
    Players.PlayerAdded:Connect(function() -- line: 577
        -- upvalues: refreshPlayers (ref), v82 (ref)
        if v82 then
            refreshPlayers()
        end
    end)
    Players.PlayerRemoving:Connect(function() -- line: 582
        -- upvalues: refreshPlayers (ref), v82 (ref)
        if v82 then
            task.defer(refreshPlayers)
        end
    end)
end

local function checkRole() -- line: 590
    -- upvalues: Role (ref), v80 (ref), ServerName (ref), ScreenGui2 (ref), ask (copy), build (copy)
    local Role2 = ask("Role")
    local Role3, v164

    if type(Role2) ~= "table" or not Role2.Role or ScreenGui2 then
        return
    else
        Role3 = Role2.Role
        v164 = Role2.Commands or {}
    end

    local ServerName2 = Role2.ServerName

    Role = Role3
    v80 = v164
    ServerName = ServerName2
    build()
end

task.delay(3, checkRole)
workspace:GetAttributeChangedSignal("CustomHost"):Connect(function() -- line: 599
    -- upvalues: checkRole (copy)
    task.delay(1, checkRole)
end)
AdminPanelEvent.OnClientEvent:Connect(function(p36, p37, p38, p39) -- line: 603
    -- upvalues: GuiService (copy), MenuState (copy), BoxingVirtualInput (copy), t14 (copy), showNext (copy), ScreenGui2 (ref), ScreenGui3 (ref), refreshPlayers (ref), v82 (ref), checkRole (copy)
    if p36 == "Announce" and type(p37) == "string" then
        table.insert(t14, {
            Text = p37,
            From = p38,
            Global = p39 == true
        })
        showNext()
    elseif p36 == "Open" then
        if not ScreenGui2 then
            checkRole()
        end

        if ScreenGui2 then
            if v82 == true or not MenuState.Open("AdminPanel") then
                return
            end

            v82 = true
            ScreenGui3.Visible = true
            refreshPlayers()

            if BoxingVirtualInput.Mode() == "Gamepad" then
                GuiService.SelectedObject = ScreenGui3:FindFirstChild("Fly", true)
            end
        end
    end
end)
