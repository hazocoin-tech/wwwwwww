-- https://lua.expert

local ContextActionService = game:GetService("ContextActionService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local AdminPanelRemote = ReplicatedStorage:WaitForChild("Boxing"):WaitForChild("AdminPanelRemote")
local t1 = {
    {
        Name = "Move",
        Color = Color3.fromRGB(90, 170, 255)
    },
    {
        Name = "Clone",
        Color = Color3.fromRGB(120, 230, 140)
    },
    {
        Name = "Delete",
        Color = Color3.fromRGB(255, 90, 90)
    }
}
local v1 = Color3.fromRGB(16, 15, 18)
local v2 = Color3.fromRGB(110, 108, 118)
local v3 = Color3.fromRGB(242, 236, 228)
local v4 = Color3.fromRGB(200, 196, 190)
local v5 = Font.new("rbxasset://fonts/families/Merriweather.json", Enum.FontWeight.Bold)
local v6 = "Move"
local v7 = false
local ScreenGui, TextLabel
local t2 = {}
local SelectionBox, t3, connection

local function ask(...) -- line: 37
    -- upvalues: AdminPanelRemote (copy)
    local InvokeServer = AdminPanelRemote.InvokeServer
    local v8, v9, v10 = pcall(InvokeServer, AdminPanelRemote, ...)

    if v8 then
        return v9, v10
    end

    return false, "Couldn't reach the server"
end

local function setStatus(p1, p2) -- line: 45
    -- upvalues: v4 (copy), TextLabel (ref)
    if not TextLabel then
        return
    end

    local TextLabel2 = TextLabel

    TextLabel2.Text = p1 or ""

    local TextLabel3 = TextLabel

    if p2 == false then
        TextLabel3.TextColor3 = Color3.fromRGB(255, 140, 140)
    elseif p2 then
        TextLabel3.TextColor3 = Color3.fromRGB(150, 235, 160)
    else
        TextLabel3.TextColor3 = v4
    end
end

local function modeColor() -- line: 52
    -- upvalues: t1 (copy), v3 (copy), v6 (ref)
    for _, v11 in t1 do
        if v11.Name == v6 then
            return v11.Color
        end
    end

    return v3
end

local function castFromMouse(p3) -- line: 62
    -- upvalues: UserInputService (copy), LocalPlayer (copy)
    local CurrentCamera = workspace.CurrentCamera
    local MouseLocation = UserInputService:GetMouseLocation()
    local v12 = CurrentCamera:ViewportPointToRay(MouseLocation.X, MouseLocation.Y)
    local v13 = RaycastParams.new()

    v13.FilterType = Enum.RaycastFilterType.Exclude

    local t4 = {
        LocalPlayer.Character
    }

    for _, v14 in p3 or {} do
        table.insert(t4, v14)
    end

    v13.FilterDescendantsInstances = t4

    return workspace:Raycast(v12.Origin, v12.Direction * 1500, v13)
end

local function wholeHeld() -- line: 76
    -- upvalues: UserInputService (copy)
    return UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or UserInputService:IsKeyDown(Enum.KeyCode.RightShift)
end

local function onCharacter(p4) -- line: 81
    local v15 = p4:FindFirstAncestorOfClass("Model")

    while true do
        if not v15 then
            return false
        end

        if v15:FindFirstChildOfClass("Humanoid") then
            break
        end

        v15 = v15.Parent and v15.Parent:FindFirstAncestorOfClass("Model")
    end

    return true
end

local function targetOf(p5, p6) -- line: 93
    -- upvalues: onCharacter (copy)
    return if p5 and p5:IsA("BasePart") and not p5:IsA("Terrain") and not onCharacter(p5) then p6 and p5:FindFirstAncestorOfClass("Model") or p5 else nil
end

local function pivotOf(p7) -- line: 103
    if p7:IsA("Model") then
        return (p7:GetPivot())
    end

    return p7.CFrame
end

local function setPivot(p8, p9) -- line: 106
    if p8:IsA("Model") then
        p8:PivotTo(p9)
    else
        p8.CFrame = p9
    end
end

local function boundsOf(p10) -- line: 113
    if p10:IsA("Model") then
        return p10:GetBoundingBox()
    end

    return p10.CFrame, p10.Size
end

local function startDrag(p11, p12) -- line: 121
    -- upvalues: v4 (copy), TextLabel (ref), t3 (ref), onCharacter (copy)
    local v16 = if p11 and p11:IsA("BasePart") and not p11:IsA("Terrain") and not onCharacter(p11) then p12 and p11:FindFirstAncestorOfClass("Model") or p11 else nil

    if not v16 then
        return
    end

    if v16:IsA("BasePart") and math.max(v16.Size.X, v16.Size.Y, v16.Size.Z) > 300 then
        local v17 = v16.Name .. " is too big to move"

        if TextLabel then
            local TextLabel2 = TextLabel

            TextLabel2.Text = v17 or ""

            local TextLabel3 = TextLabel

            TextLabel3.TextColor3 = Color3.fromRGB(255, 140, 140)
        end

        return
    end

    local BoundingBox, BoundingBox2

    if v16:IsA("Model") then
        BoundingBox, BoundingBox2 = v16:GetBoundingBox()
    else
        BoundingBox = v16.CFrame
        BoundingBox2 = v16.Size
    end

    local v18 = if v16:IsA("Model") then v16:GetPivot() else v16.CFrame

    t3 = {
        Part = p11,
        Whole = p12,
        Target = v16,
        Start = v18,
        Offset = BoundingBox:ToObjectSpace(v18),
        Size = BoundingBox2,
        Turn = BoundingBox.Rotation
    }

    local v19 = "Moving " .. v16.Name .. " - R turn, T tip, Esc cancel"

    if not TextLabel then
        return
    end

    local TextLabel2 = TextLabel

    TextLabel2.Text = v19 or ""
    TextLabel.TextColor3 = v4
end

local function snap(p13, p14) -- line: 136
    if math.abs(p14) < 0.5 then
        return math.floor(p13 / 0.5 + 0.5) * 0.5
    end

    return p13
end

local function followMouse() -- line: 143
    -- upvalues: t3 (ref), castFromMouse (copy)
    local v21 = castFromMouse({ t3.Target })

    if not v21 then
        return
    end

    local Normal = v21.Normal
    local Turn = t3.Turn
    local v22 = t3.Size / 2
    local v28 = math.abs((Normal:Dot(Turn.RightVector))) * v22.X + math.abs((Normal:Dot(Turn.UpVector))) * v22.Y + math.abs((Normal:Dot(Turn.LookVector))) * v22.Z
    local v29 = v21.Position + Normal * v28
    local X = v29.X

    if math.abs(Normal.X) < 0.5 then
        X = math.floor(X / 0.5 + 0.5) * 0.5
    end

    local Y = v29.Y

    if math.abs(Normal.Y) < 0.5 then
        Y = math.floor(Y / 0.5 + 0.5) * 0.5
    end

    local Z = v29.Z

    if math.abs(Normal.Z) < 0.5 then
        Z = math.floor(Z / 0.5 + 0.5) * 0.5
    end

    local v33 = Vector3.new(X, Y, Z)
    local t5 = t3

    t5.Pivot = CFrame.new(v33) * Turn * t3.Offset

    local Target, Pivot = t3.Target, t3.Pivot

    if Target:IsA("Model") then
        Target:PivotTo(Pivot)
    else
        Target.CFrame = Pivot
    end
end

local function cancelDrag() -- line: 156
    -- upvalues: v4 (copy), TextLabel (ref), t3 (ref)
    if not t3 then
        return
    end

    if t3.Target.Parent then
        local Target, Start = t3.Target, t3.Start

        if Target:IsA("Model") then
            Target:PivotTo(Start)
        else
            Target.CFrame = Start
        end
    end

    t3 = nil

    if not TextLabel then
        return
    end

    TextLabel.Text = "Move cancelled"
    TextLabel.TextColor3 = v4
end

local function finishDrag() -- line: 166
    -- upvalues: v4 (copy), TextLabel (ref), t3 (ref), ask (copy)
    local t6 = t3

    t3 = nil

    if t6 and t6.Pivot then
        local v34, v35 = ask("Build", "Move", t6.Part, t6.Pivot, t6.Whole)

        if not v34 and t6.Target.Parent then
            local Target, Start = t6.Target, t6.Start

            if Target:IsA("Model") then
                Target:PivotTo(Start)
            else
                Target.CFrame = Start
            end
        end

        local v36 = v34 == true

        if not TextLabel then
            return
        end

        local TextLabel2 = TextLabel

        TextLabel2.Text = v35 or ""

        local TextLabel3 = TextLabel

        if v36 == false then
            TextLabel3.TextColor3 = Color3.fromRGB(255, 140, 140)
        elseif v36 then
            TextLabel3.TextColor3 = Color3.fromRGB(150, 235, 160)
        else
            TextLabel3.TextColor3 = v4
        end
    end
end

local function overGui(p15) -- line: 180
    -- upvalues: PlayerGui (copy)
    for _, v37 in PlayerGui:GetGuiObjectsAtPosition(p15.X, p15.Y) do
        if v37.Visible and (v37:IsA("GuiButton") or v37:IsA("TextBox") or v37.Active) then
            return true
        end
    end

    return false
end

local function onClick(_, p17, p18) -- line: 189
    -- upvalues: UserInputService (copy), v4 (copy), v6 (ref), TextLabel (ref), t3 (ref), ask (copy), castFromMouse (copy), onCharacter (copy), startDrag (copy), finishDrag (copy), overGui (copy)
    if p17 == Enum.UserInputState.Begin then
        if overGui(p18.Position) or UserInputService:GetFocusedTextBox() then
            return Enum.ContextActionResult.Pass
        end

        local v38 = castFromMouse()
        local v39 = v38 and v38.Instance

        if v39 and v39:IsA("BasePart") and not v39:IsA("Terrain") and not onCharacter(v39) and v39 then
            local v40 = UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or UserInputService:IsKeyDown(Enum.KeyCode.RightShift)

            if v6 == "Move" then
                startDrag(v39, v40)
            else
                local v41, v42 = ask("Build", v6, v39, nil, v40)
                local v43 = v41 == true

                if TextLabel then
                    TextLabel.Text = v42 or ""

                    local TextLabel3 = TextLabel

                    if v43 == false then
                        TextLabel3.TextColor3 = Color3.fromRGB(255, 140, 140)
                    elseif v43 then
                        TextLabel3.TextColor3 = Color3.fromRGB(150, 235, 160)
                    else
                        TextLabel3.TextColor3 = v4
                    end
                end
            end
        else
            local v44 = if v39 and v39:IsA("BasePart") and not v39:IsA("Terrain") then "Characters, NPCs and dummies can't be built on" else "Click a part"

            if TextLabel then
                TextLabel.Text = v44 or ""
                TextLabel.TextColor3 = Color3.fromRGB(255, 140, 140)
            end
        end
    else
        if p17 ~= Enum.UserInputState.End or not t3 then
            return Enum.ContextActionResult.Pass
        end

        finishDrag()
    end

    return Enum.ContextActionResult.Sink
end

local function undoLast() -- line: 217
    -- upvalues: v4 (copy), TextLabel (ref), t3 (ref), ask (copy)
    if t3 then
        if t3.Target.Parent then
            local Target, Start = t3.Target, t3.Start

            if Target:IsA("Model") then
                Target:PivotTo(Start)
            else
                Target.CFrame = Start
            end
        end

        t3 = nil

        if TextLabel then
            TextLabel.Text = "Move cancelled"
            TextLabel.TextColor3 = v4
        end
    end

    local Undo, Undo2 = ask("Build", "Undo")
    local v45 = Undo == true

    if not TextLabel then
        return
    end

    TextLabel.Text = Undo2 or ""

    local TextLabel3 = TextLabel

    if v45 == false then
        TextLabel3.TextColor3 = Color3.fromRGB(255, 140, 140)
    elseif v45 then
        TextLabel3.TextColor3 = Color3.fromRGB(150, 235, 160)
    else
        TextLabel3.TextColor3 = v4
    end
end

local function onKey(_, p20, p21) -- line: 223
    -- upvalues: UserInputService (copy), v4 (copy), TextLabel (ref), t3 (ref), ask (copy)
    if p20 ~= Enum.UserInputState.Begin or UserInputService:GetFocusedTextBox() then
        return Enum.ContextActionResult.Pass
    end

    local KeyCode = p21.KeyCode

    if KeyCode == Enum.KeyCode.Z and (UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or UserInputService:IsKeyDown(Enum.KeyCode.RightControl)) then
        if t3 then
            if t3.Target.Parent then
                local Target, Start = t3.Target, t3.Start

                if Target:IsA("Model") then
                    Target:PivotTo(Start)
                else
                    Target.CFrame = Start
                end
            end

            t3 = nil

            if TextLabel then
                TextLabel.Text = "Move cancelled"
                TextLabel.TextColor3 = v4
            end
        end

        local Undo, Undo2 = ask("Build", "Undo")
        local v46 = Undo == true

        if TextLabel then
            TextLabel.Text = Undo2 or ""

            local TextLabel3 = TextLabel

            if v46 == false then
                TextLabel3.TextColor3 = Color3.fromRGB(255, 140, 140)
            elseif v46 then
                TextLabel3.TextColor3 = Color3.fromRGB(150, 235, 160)
            else
                TextLabel3.TextColor3 = v4
            end
        end

        return Enum.ContextActionResult.Sink
    end

    if not t3 then
        return Enum.ContextActionResult.Pass
    end

    if KeyCode == Enum.KeyCode.R then
        t3.Turn = CFrame.Angles(0, 1.5707963267948966, 0) * t3.Turn
    elseif KeyCode == Enum.KeyCode.T then
        t3.Turn = CFrame.Angles(1.5707963267948966, 0, 0) * t3.Turn
    elseif KeyCode == Enum.KeyCode.Escape and t3 then
        if t3.Target.Parent then
            local Target, Start = t3.Target, t3.Start

            if Target:IsA("Model") then
                Target:PivotTo(Start)
            else
                Target.CFrame = Start
            end
        end

        t3 = nil

        if TextLabel then
            TextLabel.Text = "Move cancelled"
            TextLabel.TextColor3 = v4
        end
    end

    return Enum.ContextActionResult.Sink
end

local function paintModes() -- line: 246
    -- upvalues: t1 (copy), v1 (copy), v2 (copy), v3 (copy), v6 (ref), t2 (copy)
    for v47, v48 in t2 do
        local v49 = v47 == v6
        local v50 = v3

        for _, v51 in t1 do
            if v51.Name == v47 then
                v50 = v51.Color
            end
        end

        if v49 then
            v48.BackgroundColor3 = v50:Lerp(v1, 0.55)
            v48.TextColor3 = v50
        else
            v48.BackgroundColor3 = Color3.fromRGB(32, 30, 36)
            v48.TextColor3 = v3
        end

        local UIStroke = v48:FindFirstChildOfClass("UIStroke")

        if UIStroke then
            if not v49 then
                v50 = v2
            end

            UIStroke.Color = v50
        end
    end
end

local function newButton(p22, p23, p24, p25) -- line: 264
    -- upvalues: v2 (copy), v3 (copy), v5 (copy)
    local TextButton = Instance.new("TextButton")

    TextButton.Name = p23
    TextButton.Text = p23
    TextButton.FontFace = v5
    TextButton.TextSize = 15
    TextButton.TextColor3 = v3
    TextButton.AutoButtonColor = false
    TextButton.BackgroundColor3 = Color3.fromRGB(32, 30, 36)
    TextButton.BorderSizePixel = 0
    TextButton.Position = UDim2.fromOffset(p24, 36)
    TextButton.Size = UDim2.fromOffset(p25, 34)
    Instance.new("UICorner", TextButton).CornerRadius = UDim.new(0, 6)

    local UIStroke = Instance.new("UIStroke")

    UIStroke.Color = v2
    UIStroke.Thickness = 1.2
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    UIStroke.Parent = TextButton
    TextButton.Parent = p22

    return TextButton
end

local function buildGui() -- line: 286
    -- upvalues: PlayerGui (copy), t1 (copy), v1 (copy), v2 (copy), v4 (copy), v6 (ref), ScreenGui (ref), TextLabel (ref), t2 (copy), SelectionBox (ref), t3 (ref), ask (copy), undoLast (copy), paintModes (copy), newButton (copy)
    ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "AdminBuildTools"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.DisplayOrder = 290
    ScreenGui.Enabled = false
    ScreenGui.Parent = PlayerGui

    local Frame = Instance.new("Frame")

    Frame.Name = "Bar"
    Frame.AnchorPoint = Vector2.new(0.5, 0)
    Frame.Position = UDim2.new(0.5, 0, 0, 10)
    Frame.Size = UDim2.fromOffset(470, 104)
    Frame.BackgroundColor3 = v1
    Frame.BackgroundTransparency = 0.12
    Frame.BorderSizePixel = 0
    Frame.Active = true
    Frame.Parent = ScreenGui
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 8)

    local UIStroke = Instance.new("UIStroke")

    UIStroke.Color = v2
    UIStroke.Thickness = 1.5
    UIStroke.Parent = Frame

    local TextLabel2 = Instance.new("TextLabel")

    TextLabel2.BackgroundTransparency = 1
    TextLabel2.FontFace = Font.new("rbxasset://fonts/families/Montserrat.json", Enum.FontWeight.Heavy, Enum.FontStyle.Italic)
    TextLabel2.Text = "BUILD TOOLS"
    TextLabel2.TextSize = 17
    TextLabel2.TextColor3 = Color3.fromRGB(255, 120, 120)
    TextLabel2.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel2.Position = UDim2.fromOffset(14, 8)
    TextLabel2.Size = UDim2.fromOffset(200, 22)
    TextLabel2.Parent = Frame

    local TextLabel3 = Instance.new("TextLabel")

    TextLabel3.BackgroundTransparency = 1
    TextLabel3.FontFace = Font.new("rbxasset://fonts/families/Merriweather.json")
    TextLabel3.Text = "Shift = whole model   Ctrl+Z = undo"
    TextLabel3.TextSize = 12
    TextLabel3.TextColor3 = v4
    TextLabel3.TextXAlignment = Enum.TextXAlignment.Right
    TextLabel3.Position = UDim2.fromOffset(170, 10)
    TextLabel3.Size = UDim2.fromOffset(250, 18)
    TextLabel3.Parent = Frame

    local n1 = 14

    for _, v52 in t1 do
        local v53 = newButton(Frame, string.upper(v52.Name), n1, 100)

        t2[v52.Name] = v53
        v53.Activated:Connect(function() -- line: 333
            -- upvalues: v52 (copy), v4 (copy), v6 (ref), TextLabel (ref), t3 (ref), paintModes (copy)
            if t3 then
                if t3.Target.Parent then
                    local Target, Start = t3.Target, t3.Start

                    if Target:IsA("Model") then
                        Target:PivotTo(Start)
                    else
                        Target.CFrame = Start
                    end
                end

                t3 = nil

                if TextLabel then
                    TextLabel.Text = "Move cancelled"
                    TextLabel.TextColor3 = v4
                end
            end

            v6 = v52.Name
            paintModes()

            local v54 = if v6 == "Move" then "Drag a part to move it" elseif v6 == "Clone" then "Click a part to copy it" else "Click a part to delete it"

            if not TextLabel then
                return
            end

            TextLabel.Text = v54 or ""
            TextLabel.TextColor3 = v4
        end)
        n1 += 108
    end

    newButton(Frame, "UNDO", n1, 100).Activated:Connect(undoLast)

    local v55 = newButton(Frame, "X", 428, 30)

    v55.Position = UDim2.fromOffset(432, 6)
    v55.Size = UDim2.fromOffset(28, 26)
    v55.Activated:Connect(function() -- line: 346
        -- upvalues: TextLabel (ref), ask (copy)
        local v56, v57 = ask("BTools", false)

        if v56 or not TextLabel then
            return
        end

        TextLabel.Text = v57 or ""
        TextLabel.TextColor3 = Color3.fromRGB(255, 140, 140)
    end)
    TextLabel = Instance.new("TextLabel")
    TextLabel.BackgroundTransparency = 1

    local TextLabel4 = TextLabel

    TextLabel4.FontFace = Font.new("rbxasset://fonts/families/Merriweather.json")
    TextLabel.TextSize = 13
    TextLabel.TextColor3 = v4

    local TextLabel5 = TextLabel

    TextLabel5.TextXAlignment = Enum.TextXAlignment.Left

    local TextLabel6 = TextLabel

    TextLabel6.TextTruncate = Enum.TextTruncate.AtEnd

    local TextLabel7 = TextLabel

    TextLabel7.Position = UDim2.fromOffset(14, 76)

    local TextLabel8 = TextLabel

    TextLabel8.Size = UDim2.fromOffset(442, 20)
    TextLabel.Parent = Frame
    SelectionBox = Instance.new("SelectionBox")
    SelectionBox.Name = "BuildHover"
    SelectionBox.LineThickness = 0.06
    SelectionBox.SurfaceTransparency = 0.85
    SelectionBox.Parent = ScreenGui
    paintModes()
end

local function setActive(p26) -- line: 370
    -- upvalues: ContextActionService (copy), RunService (copy), UserInputService (copy), t1 (copy), v3 (copy), v4 (copy), v6 (ref), v7 (ref), ScreenGui (ref), TextLabel (ref), SelectionBox (ref), t3 (ref), connection (ref), castFromMouse (copy), onCharacter (copy), followMouse (copy), onClick (copy), onKey (copy), buildGui (copy)
    if p26 == v7 then
        return
    end

    v7 = p26

    if p26 then
        if not ScreenGui then
            buildGui()
        end

        ScreenGui.Enabled = true

        if TextLabel then
            TextLabel.Text = "Drag a part to move it"
            TextLabel.TextColor3 = v4
        end

        ContextActionService:BindActionAtPriority("AdminBuildClick", onClick, false, 3000, Enum.UserInputType.MouseButton1)
        ContextActionService:BindActionAtPriority("AdminBuildKeys", onKey, false, 3000, Enum.KeyCode.R, Enum.KeyCode.T, Enum.KeyCode.Z, Enum.KeyCode.Escape)
        connection = RunService.RenderStepped:Connect(function() -- line: 383
            -- upvalues: UserInputService (copy), t1 (copy), v3 (copy), v6 (ref), SelectionBox (ref), t3 (ref), castFromMouse (copy), onCharacter (copy), followMouse (copy)
            if t3 then
                if t3.Target.Parent then
                    followMouse()
                else
                    t3 = nil
                end

                SelectionBox.Adornee = t3 and t3.Target
            else
                local v58 = castFromMouse()
                local SelectionBox2 = SelectionBox

                if v58 then
                    v58 = v58.Instance

                    local v59 = UserInputService:IsKeyDown(Enum.KeyCode.LeftShift)

                    if v59 then
                        v58 = if not v58 or not v58:IsA("BasePart") or v58:IsA("Terrain") or onCharacter(v58) then nil else v58:FindFirstAncestorOfClass("Model") or v58
                    else
                        v59 = UserInputService:IsKeyDown(Enum.KeyCode.RightShift)

                        if not v58 or not v58:IsA("BasePart") or v58:IsA("Terrain") or onCharacter(v58) then
                            v58 = nil
                        elseif v59 then
                            v58 = v58:FindFirstAncestorOfClass("Model") or v58
                        end
                    end
                end

                SelectionBox2.Adornee = v58
            end

            local SelectionBox2 = SelectionBox
            local v60 = false
            local v61

            for _, v62 in t1 do
                if v62.Name == v6 then
                    v61 = v62.Color
                    v60 = true
                    break
                end
            end

            SelectionBox2.Color3 = if not v60 then v3 else v61

            local SelectionBox3 = SelectionBox
            local v63 = false
            local v64

            for _, v65 in t1 do
                if v65.Name == v6 then
                    v64 = v65.Color
                    v63 = true
                    break
                end
            end

            SelectionBox3.SurfaceColor3 = if not v63 then v3 else v64
        end)
    else
        if t3 then
            if t3.Target.Parent then
                local Target, Start = t3.Target, t3.Start

                if Target:IsA("Model") then
                    Target:PivotTo(Start)
                else
                    Target.CFrame = Start
                end
            end

            t3 = nil

            if TextLabel then
                TextLabel.Text = "Move cancelled"
                TextLabel.TextColor3 = v4
            end
        end

        ContextActionService:UnbindAction("AdminBuildClick")
        ContextActionService:UnbindAction("AdminBuildKeys")

        if connection then
            connection:Disconnect()
            connection = nil
        end

        if ScreenGui then
            ScreenGui.Enabled = false
            SelectionBox.Adornee = nil
        end
    end
end

LocalPlayer:GetAttributeChangedSignal("AdminBTools"):Connect(function() -- line: 413
    -- upvalues: LocalPlayer (copy), setActive (copy)
    setActive(LocalPlayer:GetAttribute("AdminBTools") == true)
end)
setActive(LocalPlayer:GetAttribute("AdminBTools") == true)
