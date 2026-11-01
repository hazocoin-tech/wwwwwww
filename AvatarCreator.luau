-- https://lua.expert

local GuiService = game:GetService("GuiService")
local HttpService = game:GetService("HttpService")
local Lighting = game:GetService("Lighting")
local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Boxing = ReplicatedStorage:WaitForChild("Boxing")
local BoxingConfig = require(Boxing:WaitForChild("BoxingConfig"))
local MenuState = require(Boxing:WaitForChild("MenuState"))
local GothicUI = require(Boxing:WaitForChild("GothicUI"))
local ItemPictures = require(Boxing:WaitForChild("ItemPictures"))
local AvatarRemote = Boxing:WaitForChild("AvatarRemote")
local SurvivalRemote = Boxing:WaitForChild("SurvivalRemote")
local Avatar = BoxingConfig.Avatar
local New = GothicUI.New
local v1 = Font.new("rbxasset://fonts/families/Merriweather.json", Enum.FontWeight.Regular)
local v2 = Font.new("rbxasset://fonts/families/Merriweather.json", Enum.FontWeight.Bold)
local v3 = Font.new("rbxasset://fonts/families/Merriweather.json", Enum.FontWeight.Regular, Enum.FontStyle.Italic)
local v4 = Color3.fromRGB(242, 236, 228)
local v5 = Color3.fromRGB(176, 166, 154)
local v6 = Color3.fromRGB(110, 102, 94)
local Quick = GothicUI.Quick
local t1 = {}

for _, v7 in BoxingConfig.Clothes.List do
    t1[v7.Id] = v7
end

local function byId(p1) -- line: 49
    local t2 = {}

    for _, v8 in p1 or {} do
        t2[v8.Id] = v8
    end

    return t2
end

local v9 = byId(BoxingConfig.Accessories)
local v10 = byId(BoxingConfig.Belts)

local function readJSON(p2, p3) -- line: 59
    -- upvalues: HttpService (copy), LocalPlayer (copy)
    local Attribute = LocalPlayer:GetAttribute(p2)

    if type(Attribute) ~= "string" then
        return p3
    end

    local JSONDecode = HttpService.JSONDecode
    local ok, result = pcall(JSONDecode, HttpService, Attribute)

    if not ok or type(result) ~= "table" then
        return p3
    end

    return result
end

local function label(p4, p5) -- line: 70
    -- upvalues: New (copy), v2 (copy), v4 (copy)
    local v11 = New("TextLabel", {
        BackgroundTransparency = 1,
        TextSize = 15,
        Text = "",
        FontFace = v2,
        TextColor3 = v4,
        TextXAlignment = Enum.TextXAlignment.Left
    }, p4)

    for v12, v13 in p5 do
        v11[v12] = v13
    end

    return v11
end

local function fade(p6, p7, p8) -- line: 86
    -- upvalues: New (copy)
    New("UIGradient", {
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, p7),
            NumberSequenceKeypoint.new(1, p8)
        })
    }, p6)
end

local n1 = 0

local function guarded(p9) -- line: 93
    -- upvalues: GothicUI (copy), n1 (ref)
    return function(...) -- line: 94
        -- upvalues: p9 (copy), GothicUI (copy), n1 (ref)
        local elapsed = os.clock()

        if elapsed < n1 then
            return
        end

        n1 = elapsed + 0.3
        GothicUI.Click()
        p9(...)
    end
end

local t3 = {
    Panel = {
        Id = "rbxassetid://128654832501433",
        Scale = 0.42,
        Rect = { 82, 30, 516, 962 },
        Slice = { 46, 70, 470, 916 }
    },
    Button = {
        Id = "rbxassetid://88548113049400",
        Scale = 0.3,
        FitHeight = true,
        Rect = { 68, 104, 894, 196 },
        Slice = { 40, 20, 780, 34 }
    }
}

local function dressArt(p10, p11) -- line: 112
    -- upvalues: t3 (copy)
    local v14 = t3[p11]

    p10.Image = v14.Id
    p10.ImageRectOffset = Vector2.new(v14.Rect[1], v14.Rect[2])
    p10.ImageRectSize = Vector2.new(v14.Rect[3], v14.Rect[4])
    p10.ScaleType = Enum.ScaleType.Slice
    p10.SliceCenter = Rect.new(v14.Slice[1], v14.Slice[2], v14.Slice[3], v14.Slice[4])
    p10.SliceScale = v14.Scale

    if v14.FitHeight then
        local function fit() -- line: 121
            -- upvalues: p10 (copy), v14 (copy)
            local Y = p10.AbsoluteSize.Y

            if Y > 0 then
                p10.SliceScale = Y / v14.Rect[4]
            end
        end

        p10:GetPropertyChangedSignal("AbsoluteSize"):Connect(fit)
        task.defer(fit)
    end

    return p10
end

local function artBehind(p12, p13, p14) -- line: 132
    -- upvalues: dressArt (copy)
    local ImageLabel = Instance.new("ImageLabel")

    ImageLabel.Name = p13 .. "Art"
    ImageLabel.BackgroundTransparency = 1
    ImageLabel.Size = UDim2.fromScale(1, 1)
    dressArt(ImageLabel, p13)

    for v15, v16 in p14 or {} do
        ImageLabel[v15] = v16
    end

    ImageLabel.Parent = p12

    return ImageLabel
end

local function plateFor(p15) -- line: 145
    -- upvalues: artBehind (copy)
    local Parent = p15.Parent

    if not Parent or Parent:FindFirstChildWhichIsA("UIGridLayout") or Parent:FindFirstChildWhichIsA("UIListLayout") then
        return nil
    end

    p15.ZIndex = math.max(p15.ZIndex, 3)

    local v17 = artBehind(Parent, "Button", {
        Name = p15.Name .. "Plate",
        ZIndex = p15.ZIndex - 1
    })

    local function follow() -- line: 152
        -- upvalues: p15 (copy), v17 (copy)
        local AnchorPoint, Position, Size, Visible = p15.AnchorPoint, p15.Position, p15.Size, p15.Visible

        v17.AnchorPoint = AnchorPoint
        v17.Position = Position
        v17.Size = Size
        v17.Visible = Visible
    end

    for _, v18 in { "AnchorPoint", "Position", "Size", "Visible" } do
        p15:GetPropertyChangedSignal(v18):Connect(follow)
    end

    p15.AncestryChanged:Connect(function() -- line: 158
        -- upvalues: p15 (copy), v17 (copy)
        if not p15.Parent then
            v17:Destroy()
        end
    end)

    local AnchorPoint, Position, Size, Visible = p15.AnchorPoint, p15.Position, p15.Size, p15.Visible

    v17.AnchorPoint = AnchorPoint
    v17.Position = Position
    v17.Size = Size
    v17.Visible = Visible

    return v17
end

local function button(p16, p17, p18, p19) -- line: 168
    -- upvalues: TweenService (copy), New (copy), v2 (copy), v4 (copy), Quick (copy), plateFor (copy)
    local v19 = New("TextButton", {
        TextSize = 13,
        BackgroundTransparency = 0.35,
        AutoButtonColor = false,
        Text = string.upper(p17),
        FontFace = v2,
        TextColor3 = v4,
        BackgroundColor3 = Color3.fromRGB(8, 7, 6),
        Size = p18
    }, p16)

    for v20, v21 in p19 or {} do
        v19[v20] = v21
    end

    local v22 = string.upper(p17)

    if v22:find("REROLL", 1, true) or v22:sub(1, 3) == "R$ " then
        v19:SetAttribute("CharcoalTheme", true)
    end

    local v23 = New("UIStroke", {
        Transparency = 0.78,
        Color = v4,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    }, v19)
    local v24 = plateFor(v19)

    if not v24 then
        v19.MouseEnter:Connect(function() -- line: 205
            -- upvalues: v19 (copy), v23 (copy), TweenService (copy), Quick (copy)
            TweenService:Create(v19, Quick, {
                BackgroundTransparency = 0.12
            }):Play()
            TweenService:Create(v23, Quick, {
                Transparency = 0.45
            }):Play()
        end)
        v19.MouseLeave:Connect(function() -- line: 209
            -- upvalues: v19 (copy), v23 (copy), TweenService (copy), Quick (copy)
            TweenService:Create(v19, Quick, {
                BackgroundTransparency = 0.35
            }):Play()
            TweenService:Create(v23, Quick, {
                Transparency = 0.78
            }):Play()
        end)

        return v19, v23
    end

    v19.BackgroundTransparency = 1
    v19:SetAttribute("MangaAccent", true)
    v23.Transparency = 1

    local v25 = if v19:GetAttribute("CharcoalTheme") then Color3.fromRGB(235, 235, 240) else v4

    v24.ImageColor3 = v25
    v19.MouseEnter:Connect(function() -- line: 197
        -- upvalues: v24 (copy), TweenService (copy), Quick (copy)
        TweenService:Create(v24, Quick, {
            ImageColor3 = Color3.fromRGB(255, 255, 255):Lerp(Color3.fromRGB(255, 120, 120), 0.25)
        }):Play()
    end)
    v19.MouseLeave:Connect(function() -- line: 200
        -- upvalues: v24 (copy), v25 (copy), TweenService (copy), Quick (copy)
        TweenService:Create(v24, Quick, {
            ImageColor3 = v25
        }):Play()
    end)

    return v19, v23
end

local function row(p20, p21, p22) -- line: 216
    -- upvalues: New (copy)
    return New("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, p21),
        LayoutOrder = p22
    }, p20)
end

local function subheading(p23, p24, p25) -- line: 220
    -- upvalues: New (copy), v5 (copy), label (copy)
    local v26 = New("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 24),
        LayoutOrder = p25
    }, p23)

    label(v26, {
        TextSize = 13,
        Text = p24,
        TextColor3 = v5,
        Size = UDim2.fromScale(1, 1),
        TextYAlignment = Enum.TextYAlignment.Bottom
    })

    return v26
end

local v27 = New("ScreenGui", {
    Name = "AvatarCreator",
    ResetOnSpawn = false,
    IgnoreGuiInset = true,
    DisplayOrder = 80,
    Enabled = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling
}, PlayerGui)

v27:SetAttribute("CharcoalTheme", true)

local v28 = New("Frame", {
    Name = "Header",
    BackgroundTransparency = 1,
    Size = UDim2.new(1, 0, 0, 44)
}, v27)
local v29 = label(v28, {
    Text = "CHARACTER CUSTOMIZATION",
    TextSize = 20,
    Position = UDim2.fromOffset(16, 0),
    Size = UDim2.new(1, -32, 1, -4)
})

New("Frame", {
    Name = "Line",
    BackgroundTransparency = 0.55,
    BorderSizePixel = 0,
    BackgroundColor3 = v4,
    Position = UDim2.new(0, 0, 1, 0),
    Size = UDim2.new(1, 0, 0, 1)
}, v28)

local v30 = New("ScrollingFrame", {
    Name = "Panel",
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    ScrollBarThickness = 3,
    ScrollBarImageTransparency = 0.5,
    ScrollBarImageColor3 = v4,
    CanvasSize = UDim2.new(),
    AutomaticCanvasSize = Enum.AutomaticSize.Y,
    ScrollingDirection = Enum.ScrollingDirection.Y,
    Size = UDim2.fromOffset(448, 600)
}, v27)
local v31 = New("UIScale", {}, v30)

New("UIListLayout", {
    SortOrder = Enum.SortOrder.LayoutOrder,
    Padding = UDim.new(0, 6)
}, v30)

local v32 = New("Frame", {
    Name = "Save",
    BackgroundTransparency = 1,
    AnchorPoint = Vector2.new(1, 0),
    Size = UDim2.fromOffset(230, 52)
}, v27)
local v33 = New("UIScale", {}, v32)

v32:SetAttribute("NoSkin", true)

local v34 = artBehind(v32, "Button", {
    Name = "SavePlate",
    ZIndex = 2
})

v34.ImageColor3 = Color3.fromRGB(235, 235, 240)

local v35 = New("TextButton", {
    Text = "SAVE",
    TextSize = 22,
    AutoButtonColor = false,
    BackgroundTransparency = 1,
    ZIndex = 3,
    FontFace = v2,
    TextColor3 = v4,
    Size = UDim2.fromScale(1, 1)
}, v32)

v35:SetAttribute("NoSkin", true)
v35:SetAttribute("MangaAccent", true)
v35.MouseEnter:Connect(function() -- line: 286
    -- upvalues: TweenService (copy), Quick (copy), v34 (copy)
    TweenService:Create(v34, Quick, {
        ImageColor3 = Color3.fromRGB(255, 255, 255):Lerp(Color3.fromRGB(255, 120, 120), 0.25)
    }):Play()
end)
v35.MouseLeave:Connect(function() -- line: 289
    -- upvalues: TweenService (copy), Quick (copy), v34 (copy)
    TweenService:Create(v34, Quick, {
        ImageColor3 = Color3.fromRGB(235, 235, 240)
    }):Play()
end)

local v36 = New("Frame", {
    Name = "Bottom",
    BackgroundTransparency = 1,
    AnchorPoint = Vector2.new(0.5, 1),
    Size = UDim2.fromOffset(1000, 190)
}, v27)
local v37 = New("UIScale", {}, v36)

local function keyCap(p26, p27, p28) -- line: 299
    -- upvalues: New (copy), v2 (copy), v4 (copy), label (copy), t3 (copy), artBehind (copy), v36 (copy)
    local v38 = New("Frame", {
        BackgroundTransparency = 1,
        Name = p26,
        AnchorPoint = Vector2.new(0.5, 0),
        Position = UDim2.fromOffset(p27, 28),
        Size = UDim2.fromOffset(120, 58)
    }, v36)

    v38:SetAttribute("NoSkin", true)

    if p28 then
        local Button = t3.Button
        local v39 = Button.Rect[1]
        local v40 = Button.Rect[2]
        local v41 = Button.Rect[3]
        local v42 = Button.Rect[4]
        local v43 = Button.Slice[1]
        local v44 = v41 - Button.Slice[3]
        local v45 = New("Frame", {
            Name = "Plate",
            BackgroundTransparency = 1,
            ZIndex = 1,
            Size = UDim2.fromScale(1, 1)
        }, v38)

        local function strip(p29, p30, p31, p32) -- line: 313
            -- upvalues: Button (copy), v39 (copy), v40 (copy), v42 (copy), v45 (copy), New (copy)
            local v46 = New("ImageLabel", {
                BackgroundTransparency = 1,
                ZIndex = 1,
                Name = p29,
                Image = Button.Id,
                ScaleType = Enum.ScaleType.Stretch,
                ImageColor3 = Color3.fromRGB(235, 235, 240),
                ImageRectOffset = Vector2.new(v39 + p30 + p31, v40),
                ImageRectSize = Vector2.new(-p31, v42)
            }, v45)

            for v47, v48 in p32 do
                v46[v47] = v48
            end

            return v46
        end

        local v49 = strip("Slanted", v41 - v44, v44, {
            Size = UDim2.new(0, 0, 1, 0),
            SizeConstraint = Enum.SizeConstraint.RelativeYY
        })
        local v50 = strip("Square", 0, v43, {
            AnchorPoint = Vector2.new(1, 0),
            Position = UDim2.fromScale(1, 0),
            Size = UDim2.new(0, 0, 1, 0),
            SizeConstraint = Enum.SizeConstraint.RelativeYY
        })
        local v51 = strip("Middle", v43, v41 - v43 - v44, {})
        local v52 = v38.Size.Y.Offset / v42
        local RelativeXY, RelativeXY2 = Enum.SizeConstraint.RelativeXY, Enum.SizeConstraint.RelativeXY

        v49.SizeConstraint = RelativeXY
        v50.SizeConstraint = RelativeXY2
        v49.Size = UDim2.new(0, math.floor(v44 * v52 + 0.5), 1, 0)
        v50.Size = UDim2.new(0, math.floor(v43 * v52 + 0.5), 1, 0)
        v51.Position = UDim2.fromOffset(v49.Size.X.Offset, 0)
        v51.Size = UDim2.new(1, -(v49.Size.X.Offset + v50.Size.X.Offset), 1, 0)
    else
        artBehind(v38, "Button", {
            Name = "Plate",
            ZIndex = 1
        }).ImageColor3 = Color3.fromRGB(235, 235, 240)
    end

    label(v38, {
        TextSize = 30,
        ZIndex = 2,
        Text = p26,
        FontFace = v2,
        TextColor3 = v4,
        TextXAlignment = Enum.TextXAlignment.Center,
        Size = UDim2.fromScale(1, 1)
    })

    return v38
end

keyCap("Q", 260, true)
keyCap("E", 740, false)

local v55 = label(v36, {
    Name = "Notice",
    Text = "",
    TextSize = 16,
    TextTransparency = 1,
    TextColor3 = Color3.fromRGB(255, 196, 150),
    TextXAlignment = Enum.TextXAlignment.Center,
    Position = UDim2.fromOffset(0, -16),
    Size = UDim2.new(1, 0, 0, 24)
})

label(v36, {
    Name = "Hint",
    Text = "Your look is kept the moment you change it - SAVE when you're done. Rerolls use tokens.",
    TextSize = 15,
    FontFace = v3,
    TextColor3 = v5,
    TextXAlignment = Enum.TextXAlignment.Center,
    Position = UDim2.fromOffset(0, 112),
    Size = UDim2.new(1, 0, 0, 22)
})
label(v36, {
    Name = "Credit",
    Text = "HAJIME NO IPPO RISING <font color=\"#8A8076\">// CHARACTER CREATION</font>",
    RichText = true,
    TextSize = 15,
    TextXAlignment = Enum.TextXAlignment.Center,
    Position = UDim2.fromOffset(0, 150),
    Size = UDim2.new(1, 0, 0, 24)
})

local n2 = 0

local function layout() -- line: 397
    -- upvalues: GuiService (copy), v28 (copy), v29 (copy), v30 (copy), v31 (copy), v32 (copy), v33 (copy), v36 (copy), v37 (copy)
    local ViewportSize = workspace.CurrentCamera.ViewportSize
    local Y = GuiService.TopbarInset.Max.Y

    if Y <= 0 then
        Y = 36
    end

    local v59 = math.min(math.clamp(ViewportSize.Y / 1000, 0.5, 1.4), ViewportSize.X * 0.42 / 448)
    local v60 = ViewportSize.Y < 500

    if v60 then
        v59 = math.clamp(ViewportSize.X * 0.54 / 448, 0.72, 0.85)
    end

    for _, v62 in { "Hint", "Credit" } do
        local v63 = v36:FindFirstChild(v62)

        if v63 then
            v63.Visible = not v60
        end
    end

    v28.Position = UDim2.fromOffset(0, Y + 2)
    v28.Size = UDim2.new(1, 0, 0, (math.floor(v59 * 40)))
    v29.TextSize = math.floor(v59 * 20 + 0.5)

    local v66 = Y + 2 + v59 * 40 + v59 * 50

    v30.Position = UDim2.fromOffset(14, v66)
    v31.Scale = v59

    local v67 = if v60 then 70 else v59 * 200

    v30.Size = UDim2.fromOffset(448, (math.max(120, (ViewportSize.Y - v66 - v67) / v59)))
    v32.Position = UDim2.new(1, -math.floor(v59 * 36), 0, v66)
    v33.Scale = v59

    if v60 then
        v32.Position = UDim2.new(1, -10, 0, Y + 2)
        v33.Scale = 0.62
    end

    v36.Position = UDim2.new(0.5, 0, 1, -6)
    v37.Scale = if v60 then 0.6 else math.min(v59, ViewportSize.X / 1000)

    if v60 then
        v36.Position = UDim2.new(0.5, 0, 1, 40)
    end
end

workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(layout)
GuiService:GetPropertyChangedSignal("TopbarInset"):Connect(layout)
layout()

local function sectionIcon(p33, p34) -- line: 444
    -- upvalues: GothicUI (copy), New (copy), v4 (copy)
    if p34 == "Clothing" or p34 == "Accessories" then
        New("ImageLabel", {
            BackgroundTransparency = 1,
            Image = if p34 == "Clothing" then GothicUI.Images.IconShirt else GothicUI.Images.IconRing,
            ScaleType = Enum.ScaleType.Fit,
            Position = UDim2.fromOffset(10, 8),
            Size = UDim2.fromOffset(24, 24)
        }, p33)
    else
        local v72 = New("Frame", {
            BackgroundTransparency = 1,
            Position = UDim2.fromOffset(10, 12),
            Size = UDim2.fromOffset(24, 16)
        }, p33)

        New("UIStroke", {
            Thickness = 1.5,
            Transparency = 0.15,
            Color = v4
        }, v72)
        New("UICorner", {
            CornerRadius = UDim.new(0, 2)
        }, v72)
        New("Frame", {
            BorderSizePixel = 0,
            BackgroundColor3 = v4,
            Position = UDim2.fromOffset(3, 3),
            Size = UDim2.fromOffset(7, 10)
        }, v72)

        for i = 0, 1 do
            New("Frame", {
                BorderSizePixel = 0,
                BackgroundColor3 = v4,
                Position = UDim2.fromOffset(12, i * 5 + 4),
                Size = UDim2.fromOffset(9, 1.5)
            }, v72)
        end
    end
end

local t5 = {}

local function section(p35, p36, p37, p38) -- line: 470
    -- upvalues: GothicUI (copy), New (copy), label (copy), dressArt (copy), artBehind (copy), v30 (copy), sectionIcon (copy), t5 (copy)
    local v73 = New("Frame", {
        BackgroundTransparency = 1,
        Name = p36,
        Size = UDim2.fromOffset(440, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        LayoutOrder = p35
    }, v30)

    New("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 2)
    }, v73)

    local v74 = New("TextButton", {
        Name = "Bar",
        Text = "",
        AutoButtonColor = false,
        BackgroundTransparency = 1,
        LayoutOrder = 1,
        BackgroundColor3 = Color3.fromRGB(8, 7, 6),
        Size = UDim2.new(1, 0, 0, 40)
    }, v73)

    artBehind(v74, "Button", {
        ZIndex = 0,
        SliceScale = 0.45
    })
    sectionIcon(v74, p37)
    label(v74, {
        TextSize = 15,
        Text = p36,
        Position = UDim2.fromOffset(46, 0),
        Size = UDim2.new(1, -140, 1, 0)
    })

    local v75 = label(v74, {
        Text = "OPEN",
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Right,
        Position = UDim2.fromOffset(0, 0),
        Size = UDim2.new(1, -18, 1, 0)
    })
    local v76 = New("ImageLabel", {
        Name = "Body",
        BackgroundTransparency = 1,
        ImageTransparency = 0.06,
        Visible = false,
        LayoutOrder = 2,
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y
    }, v73)

    dressArt(v76, "Panel")
    New("UIPadding", {
        PaddingLeft = UDim.new(0, 12),
        PaddingRight = UDim.new(0, 12),
        PaddingTop = UDim.new(0, 6),
        PaddingBottom = UDim.new(0, 12)
    }, v76)
    New("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 6)
    }, v76)

    local function setOpen(p39) -- line: 516
        -- upvalues: v75 (copy), v76 (copy)
        v76.Visible = p39
        v75.Text = p39 and "CLOSE" or "OPEN"
    end

    v74.Activated:Connect(function() -- line: 520
        -- upvalues: v75 (copy), v76 (copy), GothicUI (copy)
        GothicUI.Click()

        local v77 = not v76.Visible

        v76.Visible = v77
        v75.Text = v77 and "CLOSE" or "OPEN"
    end)

    local v78 = p38 == true

    v76.Visible = v78
    v75.Text = v78 and "CLOSE" or "OPEN"
    t5[p36] = v76

    return v76
end

local v79 = section(1, "CHARACTER", "Character", true)
local v80 = section(2, "CLOTHING", "Clothing", false)
local v81 = section(3, "ACCESSORIES", "Accessories", false)

subheading(v79, "SKIN COLOR", 1)

local v82 = New("Frame", {
    BackgroundTransparency = 1,
    LayoutOrder = 2,
    Size = UDim2.fromOffset(416, 132)
}, v79)

New("UIGridLayout", {
    CellSize = UDim2.fromOffset(31, 30),
    CellPadding = UDim2.fromOffset(4, 4),
    SortOrder = Enum.SortOrder.LayoutOrder
}, v82)

local t6 = {}
local v83

for v84, v85 in Avatar.SkinColors do
    local v86 = New("TextButton", {
        Text = "",
        AutoButtonColor = false,
        Name = "Skin" .. v84,
        BackgroundColor3 = v85,
        LayoutOrder = v84
    }, v82)

    v83 = New("UIStroke", {
        Thickness = 2,
        Transparency = 1,
        Color = v4,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    }, v86)

    local Activated = v86.Activated

    local function v87() -- line: 551
        -- upvalues: AvatarRemote (copy), v84 (copy)
        AvatarRemote:FireServer("Set", "Skin", v84)
    end

    Activated:Connect(function(...) -- line: 94
        -- upvalues: GothicUI (copy), n1 (ref), v87 (copy)
        local elapsed = os.clock()

        if elapsed < n1 then
            return
        end

        n1 = elapsed + 0.3
        GothicUI.Click()
        v87(...)
    end)
    t6[v84] = v83
end

subheading(v79, "NAME:", 3)

local v88 = New("Frame", {
    BackgroundTransparency = 1,
    LayoutOrder = 4,
    Size = UDim2.new(1, 0, 0, 70)
}, v79)

local function namePart(p40, p41, p42) -- line: 561
    -- upvalues: GothicUI (copy), AvatarRemote (copy), v5 (copy), label (copy), n1 (ref), button (copy), v88 (copy)
    label(v88, {
        TextSize = 12,
        Text = p41,
        TextColor3 = v5,
        Position = UDim2.fromOffset(0, p40),
        Size = UDim2.fromOffset(44, 32)
    })

    local v89 = label(v88, {
        Text = "",
        TextSize = 18,
        Position = UDim2.fromOffset(46, p40),
        Size = UDim2.new(1, -166, 0, 32)
    })
    local v90 = button(v88, "Reroll", UDim2.fromOffset(110, 30), {
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, 0, 0, p40 + 1)
    })
    local Activated = v90.Activated

    local function v91() -- line: 565
        -- upvalues: p42 (copy), AvatarRemote (copy)
        AvatarRemote:FireServer("Reroll", p42)
    end

    Activated:Connect(function(...) -- line: 94
        -- upvalues: v91 (copy), GothicUI (copy), n1 (ref)
        local elapsed = os.clock()

        if elapsed < n1 then
            return
        end

        n1 = elapsed + 0.3
        GothicUI.Click()
        v91(...)
    end)

    return v89, v90
end

local FirstName, FirstName2 = namePart(0, "FIRST", "FirstName")
local LastName, LastName2 = namePart(36, "LAST", "LastName")
local v92 = label(New("Frame", {
    BackgroundTransparency = 1,
    LayoutOrder = 5,
    Size = UDim2.new(1, 0, 0, 26)
}, v79), {
    Text = "",
    TextSize = 14,
    TextColor3 = v5,
    Size = UDim2.fromScale(1, 1)
})

v83 = New("Frame", {
    BackgroundTransparency = 1,
    LayoutOrder = 6,
    Size = UDim2.new(1, 0, 0, 30)
}, v79)

local v93 = Font.new("rbxasset://fonts/families/Montserrat.json", Enum.FontWeight.Heavy, Enum.FontStyle.Italic)
local v94 = New("TextButton", {
    Name = "TokenShop",
    Text = "",
    AutoButtonColor = false,
    Visible = false,
    ZIndex = 50,
    Selectable = false,
    BackgroundTransparency = 0.45,
    BorderSizePixel = 0,
    BackgroundColor3 = Color3.new(0, 0, 0),
    Size = UDim2.fromScale(1, 1)
}, v27)
local v95 = New("Frame", {
    Name = "Box",
    BorderSizePixel = 0,
    ZIndex = 51,
    Active = true,
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromScale(0.5, 0.5),
    Size = UDim2.fromOffset(460, 290),
    BackgroundColor3 = Color3.new(1, 1, 1)
}, v94)

v95.BackgroundTransparency = 1
artBehind(v95, "Panel", {
    ZIndex = 51,
    SliceScale = 0.36,
    Position = UDim2.fromOffset(-6, -6),
    Size = UDim2.new(1, 12, 1, 12)
})
New("UIStroke", {
    Thickness = 2,
    Color = Color3.fromRGB(165, 165, 172),
    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
}, v95)

local v96 = New("UIScale", {}, v95)

New("Frame", {
    Name = "Line",
    BorderSizePixel = 0,
    ZIndex = 52,
    BackgroundColor3 = Color3.fromRGB(222, 222, 228),
    Size = UDim2.new(0.6, 0, 0, 4)
}, v95)

local v97 = label(v95, {
    Text = "BUY REROLL TOKENS",
    TextSize = 26,
    ZIndex = 52,
    FontFace = v93,
    Position = UDim2.fromOffset(22, 18),
    Size = UDim2.new(1, -80, 0, 32)
})

New("UIStroke", {
    Thickness = 1.5,
    Color = Color3.new(0, 0, 0)
}, v97)

local v98 = label(v95, {
    Text = "",
    TextSize = 14,
    ZIndex = 52,
    TextColor3 = v5,
    Position = UDim2.fromOffset(24, 52),
    Size = UDim2.new(1, -48, 0, 20)
})
local v99 = New("TextButton", {
    Name = "Close",
    Text = "X",
    TextSize = 20,
    AutoButtonColor = false,
    BackgroundTransparency = 0.1,
    BorderSizePixel = 0,
    ZIndex = 53,
    FontFace = v2,
    TextColor3 = v4,
    BackgroundColor3 = Color3.fromRGB(28, 26, 30),
    AnchorPoint = Vector2.new(1, 0),
    Position = UDim2.new(1, -16, 0, 16),
    Size = UDim2.fromOffset(38, 38)
}, v95)

v99:SetAttribute("MangaAccent", true)
New("UICorner", {
    CornerRadius = UDim.new(0, 6)
}, v99)

local v100 = New("UIStroke", {
    Thickness = 1.5,
    Color = Color3.fromRGB(165, 165, 172),
    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
}, v99)

v99.MouseEnter:Connect(function() -- line: 605
    -- upvalues: TweenService (copy), Quick (copy), v99 (copy), v100 (copy)
    TweenService:Create(v99, Quick, {
        BackgroundColor3 = Color3.fromRGB(150, 30, 36)
    }):Play()
    v100.Color = Color3.fromRGB(235, 235, 240)
end)
v99.MouseLeave:Connect(function() -- line: 609
    -- upvalues: TweenService (copy), Quick (copy), v99 (copy), v100 (copy)
    TweenService:Create(v99, Quick, {
        BackgroundColor3 = Color3.fromRGB(28, 26, 30)
    }):Play()
    v100.Color = Color3.fromRGB(165, 165, 172)
end)

local function tokenOption(p43, p44) -- line: 613
    -- upvalues: MarketplaceService (copy), ReplicatedStorage (copy), TweenService (copy), LocalPlayer (copy), GothicUI (copy), New (copy), v4 (copy), Quick (copy), label (copy), n1 (ref), artBehind (copy), v55 (copy), n2 (ref), v93 (copy), v95 (copy)
    local v101 = New("TextButton", {
        Text = "",
        AutoButtonColor = false,
        ZIndex = 52,
        BorderSizePixel = 0,
        Name = p44.Id,
        BackgroundColor3 = Color3.fromRGB(46, 45, 52),
        Position = UDim2.fromOffset(22 + (p43 - 1) * 213, 88),
        Size = UDim2.fromOffset(203, 176)
    }, v95)

    v101:SetAttribute("MangaAccent", true)
    v101.BackgroundTransparency = 1

    local v102 = artBehind(v101, "Panel", {
        ZIndex = 52,
        SliceScale = 0.3
    })
    local v103 = New("UIStroke", {
        Thickness = 1.5,
        Color = Color3.fromRGB(110, 108, 118),
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    }, v101)

    New("ImageLabel", {
        Name = "Icon",
        BackgroundTransparency = 1,
        ZIndex = 53,
        Image = "rbxassetid://" .. tostring(p44.Icon or 0),
        ScaleType = Enum.ScaleType.Fit,
        AnchorPoint = Vector2.new(0.5, 0),
        Position = UDim2.new(0.5, 0, 0, 12),
        Size = UDim2.fromOffset(74, 74)
    }, v101)

    local v105 = label(v101, {
        TextSize = 17,
        ZIndex = 53,
        Text = string.upper(p44.Name),
        FontFace = v93,
        TextXAlignment = Enum.TextXAlignment.Center,
        Position = UDim2.fromOffset(6, 92),
        Size = UDim2.new(1, -12, 0, 24)
    })

    New("UIStroke", {
        Thickness = 1.2,
        Color = Color3.new(0, 0, 0)
    }, v105)

    local v106 = label(v101, {
        TextSize = 22,
        ZIndex = 53,
        Text = if (tonumber(p44.Product) or 0) > 0 then "R$ " .. p44.Robux else "R$ " .. p44.Robux .. " · SOON",
        FontFace = v93,
        TextColor3 = Color3.fromRGB(120, 230, 140),
        TextXAlignment = Enum.TextXAlignment.Center,
        Position = UDim2.fromOffset(6, 126),
        Size = UDim2.new(1, -12, 0, 30)
    })

    New("UIStroke", {
        Thickness = 1.2,
        Color = Color3.new(0, 0, 0)
    }, v106)

    local PaidRandom = require(ReplicatedStorage:WaitForChild("Boxing"):WaitForChild("PaidRandom"))
    local v107 = New("Frame", {
        Name = "Restricted",
        BackgroundTransparency = 0.4,
        BorderSizePixel = 0,
        ZIndex = 54,
        Visible = false,
        BackgroundColor3 = Color3.fromRGB(16, 16, 20),
        Size = UDim2.fromScale(1, 1)
    }, v101)

    local function showPolicy() -- line: 642
        -- upvalues: p44 (copy), v106 (copy), PaidRandom (copy), v107 (copy), LocalPlayer (copy)
        local v108 = PaidRandom.Blocked(LocalPlayer, p44.Product)

        v107.Visible = v108

        if v108 then
            v106.Text = string.upper(PaidRandom.NOTICE)
            v106.TextSize = 13
            v106.TextColor3 = Color3.fromRGB(170, 170, 176)
        else
            v106.Text = if (tonumber(p44.Product) or 0) > 0 then "R$ " .. p44.Robux else "R$ " .. p44.Robux .. " · SOON"
            v106.TextSize = 22
            v106.TextColor3 = Color3.fromRGB(120, 230, 140)
        end
    end

    LocalPlayer:GetAttributeChangedSignal(PaidRandom.ATTRIBUTE):Connect(showPolicy)
    showPolicy()
    v101.MouseEnter:Connect(function() -- line: 658
        -- upvalues: v102 (copy), v103 (copy), TweenService (copy), Quick (copy)
        TweenService:Create(v102, Quick, {
            ImageColor3 = Color3.fromRGB(255, 200, 200)
        }):Play()
        v103.Color = Color3.fromRGB(235, 235, 240)
    end)
    v101.MouseLeave:Connect(function() -- line: 662
        -- upvalues: v102 (copy), v103 (copy), TweenService (copy), v4 (copy), Quick (copy)
        TweenService:Create(v102, Quick, {
            ImageColor3 = v4
        }):Play()
        v103.Color = Color3.fromRGB(110, 108, 118)
    end)
    v101.SelectionGained:Connect(function() -- line: 666
        -- upvalues: v103 (copy)
        v103.Color = Color3.fromRGB(235, 235, 240)
    end)
    v101.SelectionLost:Connect(function() -- line: 669
        -- upvalues: v103 (copy)
        v103.Color = Color3.fromRGB(110, 108, 118)
    end)

    local Activated = v101.Activated

    local function v110() -- line: 672
        -- upvalues: p44 (copy), MarketplaceService (copy), ReplicatedStorage (copy), TweenService (copy), LocalPlayer (copy), v55 (copy), n2 (ref)
        local v111 = tonumber(p44.Product) or 0

        if v111 <= 0 then
            n2 += 1

            local v112 = n2

            v55.Text = "This token pack isn't on sale yet"
            v55.TextTransparency = 0
            task.delay(2.6, function() -- line: 390
                -- upvalues: v112 (copy), TweenService (copy), v55 (copy), n2 (ref)
                if n2 == v112 then
                    TweenService:Create(v55, TweenInfo.new(0.5), {
                        TextTransparency = 1
                    }):Play()
                end
            end)
        else
            local PaidRandom = require(ReplicatedStorage:WaitForChild("Boxing"):WaitForChild("PaidRandom"))

            if PaidRandom.Blocked(LocalPlayer, v111) then
                local v113 = "Reroll tokens: " .. string.lower(PaidRandom.NOTICE)

                n2 += 1

                local v114 = n2

                v55.Text = v113
                v55.TextTransparency = 0
                task.delay(2.6, function() -- line: 390
                    -- upvalues: v114 (copy), TweenService (copy), v55 (copy), n2 (ref)
                    if n2 == v114 then
                        TweenService:Create(v55, TweenInfo.new(0.5), {
                            TextTransparency = 1
                        }):Play()
                    end
                end)
            else
                MarketplaceService:PromptProductPurchase(LocalPlayer, v111)
            end
        end
    end

    Activated:Connect(function(...) -- line: 94
        -- upvalues: v110 (copy), GothicUI (copy), n1 (ref)
        local elapsed = os.clock()

        if elapsed < n1 then
            return
        end

        n1 = elapsed + 0.3
        GothicUI.Click()
        v110(...)
    end)
end

local t9 = {}

for _, v115 in BoxingConfig.Store and BoxingConfig.Store.Products or {} do
    if v115.Tokens then
        table.insert(t9, v115)
    end
end

table.sort(t9, function(p45, p46) -- line: 692
    return p45.Tokens < p46.Tokens
end)

for v116, v117 in t9 do
    if v116 <= 2 then
        tokenOption(v116, v117)
    end
end

local function showTokenCount() -- line: 700
    -- upvalues: LocalPlayer (copy), v98 (copy)
    local v118 = LocalPlayer:GetAttribute("RerollTokens") or 0

    v98.Text = "You have " .. v118 .. (v118 == 1 and " token" or " tokens") .. " - rerolls use one each"
end

LocalPlayer:GetAttributeChangedSignal("RerollTokens"):Connect(showTokenCount)

local function closeTokenShop() -- line: 705
    -- upvalues: GuiService (copy), v94 (copy)
    v94.Visible = false

    if GuiService.SelectedObject and GuiService.SelectedObject:IsDescendantOf(v94) then
        GuiService.SelectedObject = nil
    end
end

local function openTokenShop() -- line: 711
    -- upvalues: LocalPlayer (copy), Boxing (copy), v94 (copy), v95 (copy), v96 (copy), v98 (copy)
    local v119 = LocalPlayer:GetAttribute("RerollTokens") or 0

    v98.Text = "You have " .. v119 .. (v119 == 1 and " token" or " tokens") .. " - rerolls use one each"
    v96.Scale = math.clamp(workspace.CurrentCamera.ViewportSize.Y / 1000, 0.6, 1.3)
    v94.Visible = true
    require(Boxing:WaitForChild("PadFocus")).Into(v95)
end

v94.Activated:Connect(closeTokenShop)
v99.Activated:Connect(function(...) -- line: 94
    -- upvalues: GothicUI (copy), n1 (ref), closeTokenShop (copy)
    local elapsed = os.clock()

    if elapsed < n1 then
        return
    end

    n1 = elapsed + 0.3
    GothicUI.Click()
    closeTokenShop(...)
end)
UserInputService.InputBegan:Connect(function(p47) -- line: 719
    -- upvalues: GuiService (copy), v94 (copy)
    if v94.Visible and (p47.KeyCode == Enum.KeyCode.Escape or p47.KeyCode == Enum.KeyCode.ButtonB) then
        v94.Visible = false

        if GuiService.SelectedObject and GuiService.SelectedObject:IsDescendantOf(v94) then
            GuiService.SelectedObject = nil
        end
    end
end)

local Products = button(v83, "Buy Tokens", UDim2.fromOffset(416, 30))

Products.Name = "BuyTokens"

local Activated = Products.Activated

local function v121() -- line: 727
    -- upvalues: openTokenShop (copy)
    openTokenShop()
end

Activated:Connect(function(...) -- line: 94
    -- upvalues: GothicUI (copy), n1 (ref), v121 (copy)
    local elapsed = os.clock()

    if elapsed < n1 then
        return
    end

    n1 = elapsed + 0.3
    GothicUI.Click()
    v121(...)
end)
subheading(v79, "HAIR", 7)
Products = New("Frame", {
    BackgroundTransparency = 1,
    LayoutOrder = 8,
    Size = UDim2.new(1, 0, 0, 32)
}, v79)

local v122 = label(Products, {
    Text = "",
    TextSize = 15,
    Position = UDim2.fromOffset(0, 0),
    Size = UDim2.new(1, -120, 1, 0)
})
local v123 = button(Products, "Reroll", UDim2.fromOffset(110, 30), {
    AnchorPoint = Vector2.new(1, 0),
    Position = UDim2.new(1, 0, 0, 0)
})
local Activated2 = v123.Activated

local function v124() -- line: 742
    -- upvalues: AvatarRemote (copy)
    AvatarRemote:FireServer("Reroll", "HairStyle")
end

Activated2:Connect(function(...) -- line: 94
    -- upvalues: GothicUI (copy), n1 (ref), v124 (copy)
    local elapsed = os.clock()

    if elapsed < n1 then
        return
    end

    n1 = elapsed + 0.3
    GothicUI.Click()
    v124(...)
end)

local t10 = {
    Visible = false
}
local t11 = {
    Visible = false
}
local v125 = New("Frame", {
    BackgroundTransparency = 1,
    LayoutOrder = 9,
    Size = UDim2.new(1, 0, 0, 32)
}, v79)
local v126 = New("Frame", {
    BackgroundColor3 = Color3.new(0, 0, 0),
    Size = UDim2.fromOffset(30, 30)
}, v125)

New("UIStroke", {
    Transparency = 0.5,
    Color = v4
}, v126)

local v127 = label(v125, {
    Text = "",
    TextSize = 15,
    Position = UDim2.fromOffset(42, 0),
    Size = UDim2.new(1, -160, 1, 0)
})
local v128 = button(v125, "Reroll", UDim2.fromOffset(110, 30), {
    AnchorPoint = Vector2.new(1, 0),
    Position = UDim2.new(1, 0, 0, 0)
})
local v129 = v128.Activated

local function v130() -- line: 751
    -- upvalues: AvatarRemote (copy)
    AvatarRemote:FireServer("Reroll", "HairColor")
end

v129:Connect(function(...) -- line: 94
    -- upvalues: GothicUI (copy), n1 (ref), v130 (copy)
    local elapsed = os.clock()

    if elapsed < n1 then
        return
    end

    n1 = elapsed + 0.3
    GothicUI.Click()
    v130(...)
end)
subheading(v79, "HEIGHT", 10)
v129 = New("Frame", {
    BackgroundTransparency = 1,
    LayoutOrder = 11,
    Size = UDim2.new(1, 0, 0, 32)
}, v79)

local v131 = label(v129, {
    Text = "",
    TextSize = 18,
    Size = UDim2.new(1, -236, 1, 0)
})
local v132 = Avatar.HeightRerollCost or 1
local v134 = button(v129, "Reroll · " .. v132 .. (if v132 == 1 then " Token" else " Tokens"), UDim2.fromOffset(136, 30), {
    AnchorPoint = Vector2.new(1, 0),
    Position = UDim2.new(1, -96, 0, 0)
})
local v136 = tonumber(Avatar.HeightRerollProduct) or 0
local v139 = button(v129, if v136 > 0 then "R$ " .. (Avatar.HeightRerollRobux or 5) else "R$ " .. (Avatar.HeightRerollRobux or 5) .. " · Soon", UDim2.fromOffset(88, 30), {
    AnchorPoint = Vector2.new(1, 0),
    Position = UDim2.new(1, 0, 0, 0),
    TextColor3 = if v136 > 0 then Color3.fromRGB(120, 230, 140) else v6
})
local v135 = v134.Activated

local function v140() -- line: 770
    -- upvalues: AvatarRemote (copy)
    AvatarRemote:FireServer("Reroll", "Height")
end

v135:Connect(function(...) -- line: 94
    -- upvalues: GothicUI (copy), n1 (ref), v140 (copy)
    local elapsed = os.clock()

    if elapsed < n1 then
        return
    end

    n1 = elapsed + 0.3
    GothicUI.Click()
    v140(...)
end)

local PaidRandom = require(ReplicatedStorage:WaitForChild("Boxing"):WaitForChild("PaidRandom"))
local Text = v139.Text

local function showPolicy() -- line: 777
    -- upvalues: LocalPlayer (copy), v6 (copy), v136 (copy), v139 (copy), PaidRandom (copy), Text (copy)
    if v136 > 0 and PaidRandom.Blocked(LocalPlayer, v136) then
        v139.Text = "N/A"
        v139.TextColor3 = v6

        return
    end

    v139.Text = Text
    v139.TextColor3 = if v136 > 0 then Color3.fromRGB(120, 230, 140) else v6
end

LocalPlayer:GetAttributeChangedSignal(PaidRandom.ATTRIBUTE):Connect(showPolicy)

local v142

if v136 > 0 and PaidRandom.Blocked(LocalPlayer, v136) then
    v139.Text = "N/A"
    v139.TextColor3 = v6
else
    v139.Text = Text
    v142 = if v136 > 0 then Color3.fromRGB(120, 230, 140) else v6
    v139.TextColor3 = v142
end

v135 = v139.Activated

local function v143() -- line: 789
    -- upvalues: MarketplaceService (copy), ReplicatedStorage (copy), TweenService (copy), LocalPlayer (copy), v55 (copy), n2 (ref), v136 (copy)
    if v136 <= 0 then
        n2 += 1

        local v144 = n2

        v55.Text = "Robux height rerolls are coming soon"
        v55.TextTransparency = 0
        task.delay(2.6, function() -- line: 390
            -- upvalues: v144 (copy), TweenService (copy), v55 (copy), n2 (ref)
            if n2 == v144 then
                TweenService:Create(v55, TweenInfo.new(0.5), {
                    TextTransparency = 1
                }):Play()
            end
        end)
    else
        local PaidRandom = require(ReplicatedStorage:WaitForChild("Boxing"):WaitForChild("PaidRandom"))

        if PaidRandom.Blocked(LocalPlayer, v136) then
            local v145 = "Robux height rerolls: " .. string.lower(PaidRandom.NOTICE)

            n2 += 1

            local v146 = n2

            v55.Text = v145
            v55.TextTransparency = 0
            task.delay(2.6, function() -- line: 390
                -- upvalues: v146 (copy), TweenService (copy), v55 (copy), n2 (ref)
                if n2 == v146 then
                    TweenService:Create(v55, TweenInfo.new(0.5), {
                        TextTransparency = 1
                    }):Play()
                end
            end)
        else
            MarketplaceService:PromptProductPurchase(LocalPlayer, v136)
        end
    end
end

v135:Connect(function(...) -- line: 94
    -- upvalues: GothicUI (copy), n1 (ref), v143 (copy)
    local elapsed = os.clock()

    if elapsed < n1 then
        return
    end

    n1 = elapsed + 0.3
    GothicUI.Click()
    v143(...)
end)
subheading(v79, "GENDER", 12)
v135 = New("Frame", {
    BackgroundTransparency = 1,
    LayoutOrder = 13,
    Size = UDim2.new(1, 0, 0, 30)
}, v79)

local t12 = {}

v142 = math.floor((416 - (#Avatar.Genders - 1) * 8) / #Avatar.Genders)

for v147, v148 in Avatar.Genders do
    local v150, v151 = button(v135, Avatar.GenderNames and Avatar.GenderNames[v148] or v148, UDim2.fromOffset(v142, 30), {
        Position = UDim2.fromOffset((v147 - 1) * (v142 + 8), 0)
    })
    local Activated = v150.Activated

    local function v152() -- line: 811
        -- upvalues: AvatarRemote (copy), v148 (copy)
        AvatarRemote:FireServer("Set", "Gender", v148)
    end

    Activated:Connect(function(...) -- line: 94
        -- upvalues: GothicUI (copy), n1 (ref), v152 (copy)
        local elapsed = os.clock()

        if elapsed < n1 then
            return
        end

        n1 = elapsed + 0.3
        GothicUI.Click()
        v152(...)
    end)
    t12[v148] = {
        Button = v150,
        Stroke = v151
    }
end

subheading(v79, "EYE COLOUR", 14)
v142 = New("Frame", {
    BackgroundTransparency = 1,
    LayoutOrder = 15,
    Size = UDim2.new(1, 0, 0, 32)
}, v79)

local v153 = New("Frame", {
    BackgroundColor3 = Color3.new(0, 0, 0),
    Size = UDim2.fromOffset(30, 30)
}, v142)

New("UICorner", {
    CornerRadius = UDim.new(1, 0)
}, v153)
New("UIStroke", {
    Transparency = 0.5,
    Color = v4
}, v153)

local v154 = label(v142, {
    Text = "",
    TextSize = 15,
    Position = UDim2.fromOffset(42, 0),
    Size = UDim2.new(1, -160, 1, 0)
})
local v155 = button(v142, "Reroll", UDim2.fromOffset(110, 30), {
    AnchorPoint = Vector2.new(1, 0),
    Position = UDim2.new(1, 0, 0, 0)
})
local Activated3 = v155.Activated

local function v156() -- line: 826
    -- upvalues: AvatarRemote (copy)
    AvatarRemote:FireServer("Reroll", "EyeColor")
end

Activated3:Connect(function(...) -- line: 94
    -- upvalues: GothicUI (copy), n1 (ref), v156 (copy)
    local elapsed = os.clock()

    if elapsed < n1 then
        return
    end

    n1 = elapsed + 0.3
    GothicUI.Click()
    v156(...)
end)
subheading(v79, "FACE", 16)
v142 = {
    {
        Tag = "ALL",
        What = "Face"
    },
    {
        Tag = "EYES",
        What = "FaceEyes",
        Part = "Eyes"
    },
    {
        Tag = "BROWS",
        What = "FaceBrows",
        Part = "Brows"
    },
    {
        Tag = "NOSE",
        What = "FaceNose",
        Part = "Nose"
    },
    {
        Tag = "MOUTH",
        What = "FaceMouth",
        Part = "Mouth"
    }
}

local v157 = #v142 * 36 - 4
local v158 = New("Frame", {
    BackgroundTransparency = 1,
    LayoutOrder = 17,
    Size = UDim2.new(1, 0, 0, v157)
}, v79)
local t13 = {}

for v159, v160 in v142 do
    local v161 = (v159 - 1) * 36

    label(v158, {
        TextSize = 12,
        Text = v160.Tag,
        TextColor3 = v5,
        Position = UDim2.fromOffset(0, v161),
        Size = UDim2.fromOffset(52, 32)
    })

    local v162 = label(v158, {
        Text = "",
        TextSize = 15,
        Position = UDim2.fromOffset(56, v161),
        Size = UDim2.new(1, -176, 0, 32)
    })
    local v163 = button(v158, "Reroll", UDim2.fromOffset(110, 30), {
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, 0, 0, v161 + 1)
    })

    v163.Name = "Reroll" .. v160.What

    local Activated = v163.Activated

    local function v164() -- line: 849
        -- upvalues: AvatarRemote (copy), v160 (copy)
        AvatarRemote:FireServer("Reroll", v160.What)
    end

    Activated:Connect(function(...) -- line: 94
        -- upvalues: GothicUI (copy), n1 (ref), v164 (copy)
        local elapsed = os.clock()

        if elapsed < n1 then
            return
        end

        n1 = elapsed + 0.3
        GothicUI.Click()
        v164(...)
    end)
    t13[v159] = {
        Line = v160,
        Name = v162,
        Reroll = v163
    }
end

local Walkouts = require(Boxing:WaitForChild("Walkouts"))
local SoundService = game:GetService("SoundService")

subheading(v79, "WALKOUT SONG", 18)
v158 = New("Frame", {
    BackgroundTransparency = 1,
    LayoutOrder = 19,
    Size = UDim2.new(1, 0, 0, 56)
}, v79)

local v165 = label(v158, {
    Text = "",
    TextSize = 15,
    Position = UDim2.fromOffset(0, 0),
    Size = UDim2.new(1, -206, 0, 30)
})
local v166 = label(v158, {
    Text = "",
    TextSize = 12,
    TextColor3 = v5,
    Position = UDim2.fromOffset(0, 30),
    Size = UDim2.new(1, -206, 0, 22)
})
local v167 = button(v158, "Play", UDim2.fromOffset(84, 30), {
    AnchorPoint = Vector2.new(1, 0),
    Position = UDim2.new(1, -118, 0, 0)
})

v167.Name = "PlayWalkout"

local v168 = button(v158, "Reroll", UDim2.fromOffset(110, 30), {
    AnchorPoint = Vector2.new(1, 0),
    Position = UDim2.new(1, 0, 0, 0)
})

v168.Name = "RerollWalkout"
label(v79, {
    Name = "WalkoutOdds",
    TextSize = 11,
    TextWrapped = true,
    LayoutOrder = 20,
    Text = "ODDS  " .. Walkouts.OddsText(),
    TextColor3 = v6,
    FontFace = v3,
    Size = UDim2.fromOffset(416, 30)
})

local Sound
local n3 = 0

local function stopPreview() -- line: 876
    -- upvalues: TweenService (copy), LocalPlayer (copy), v167 (copy), Sound (ref), n3 (ref)
    n3 += 1

    if Sound then
        local Sound2 = Sound

        Sound = nil
        TweenService:Create(Sound2, TweenInfo.new(0.4), {
            Volume = 0
        }):Play()
        task.delay(0.45, function() -- line: 882
            -- upvalues: Sound2 (copy)
            Sound2:Destroy()
        end)
    end

    LocalPlayer:SetAttribute("WalkoutPlaying", nil)
    v167.Text = "PLAY"
end

local function startPreview(p48) -- line: 889
    -- upvalues: TweenService (copy), LocalPlayer (copy), Walkouts (copy), SoundService (copy), v167 (copy), Sound (ref), n3 (ref), stopPreview (copy)
    stopPreview()
    n3 += 1

    local v169 = n3
    local Sound2 = Instance.new("Sound")

    Sound2.Name = "WalkoutPreview"
    Sound2.SoundId = "rbxassetid://" .. tostring(p48.Sound)
    Sound2.Volume = 0
    Sound2.SoundGroup = SoundService:FindFirstChild("BoxingMusic")
    Sound2.Parent = SoundService
    Sound2:Play()
    TweenService:Create(Sound2, TweenInfo.new(0.4), {
        Volume = Walkouts.Entrance.SongVolume or 0.8
    }):Play()
    Sound = Sound2
    LocalPlayer:SetAttribute("WalkoutPlaying", true)
    v167.Text = "STOP"
    Sound2.Ended:Connect(function() -- line: 904
        -- upvalues: v169 (copy), n3 (ref), stopPreview (copy)
        if n3 == v169 then
            stopPreview()
        end
    end)
    task.delay(Walkouts.PreviewSeconds or 12, function() -- line: 909
        -- upvalues: v169 (copy), n3 (ref), stopPreview (copy)
        if n3 == v169 then
            stopPreview()
        end
    end)
end

local function current() -- line: 915
    -- upvalues: HttpService (copy), LocalPlayer (copy), Walkouts (copy)
    local Get = Walkouts.Get
    local v170 = {}
    local Avatar = LocalPlayer:GetAttribute("Avatar")

    if type(Avatar) == "string" then
        local JSONDecode = HttpService.JSONDecode
        local ok, result = pcall(JSONDecode, HttpService, Avatar)

        if ok and type(result) == "table" then
            v170 = result
        end
    end

    return Get(v170.Walkout)
end

local n4 = (-1e999)
local v171
local Activated4 = v167.Activated

local function v172() -- line: 920
    -- upvalues: HttpService (copy), TweenService (copy), LocalPlayer (copy), v55 (copy), n2 (ref), Walkouts (copy), Sound (ref), stopPreview (copy), startPreview (copy)
    if Sound then
        stopPreview()
    else
        local Get = Walkouts.Get
        local v173 = {}
        local Avatar = LocalPlayer:GetAttribute("Avatar")

        if type(Avatar) == "string" then
            local JSONDecode = HttpService.JSONDecode
            local ok, result = pcall(JSONDecode, HttpService, Avatar)

            if ok and type(result) == "table" then
                v173 = result
            end
        end

        local v174 = Get(v173.Walkout)

        if v174 then
            startPreview(v174)
        else
            n2 += 1

            local v175 = n2

            v55.Text = "No walkout song yet - reroll for one"
            v55.TextTransparency = 0
            task.delay(2.6, function() -- line: 390
                -- upvalues: v175 (copy), TweenService (copy), v55 (copy), n2 (ref)
                if n2 == v175 then
                    TweenService:Create(v55, TweenInfo.new(0.5), {
                        TextTransparency = 1
                    }):Play()
                end
            end)
        end
    end
end

Activated4:Connect(function(...) -- line: 94
    -- upvalues: GothicUI (copy), n1 (ref), v172 (copy)
    local elapsed = os.clock()

    if elapsed < n1 then
        return
    end

    n1 = elapsed + 0.3
    GothicUI.Click()
    v172(...)
end)
Activated4 = v168.Activated

local function v176() -- line: 932
    -- upvalues: AvatarRemote (copy), stopPreview (copy), n4 (ref)
    stopPreview()
    n4 = os.clock()
    AvatarRemote:FireServer("Reroll", "Walkout")
end

Activated4:Connect(function(...) -- line: 94
    -- upvalues: GothicUI (copy), n1 (ref), v176 (copy)
    local elapsed = os.clock()

    if elapsed < n1 then
        return
    end

    n1 = elapsed + 0.3
    GothicUI.Click()
    v176(...)
end)

local function show() -- line: 937
    -- upvalues: HttpService (copy), LocalPlayer (copy), Avatar (copy), v4 (copy), v5 (copy), v6 (copy), v27 (copy), Walkouts (copy), v165 (copy), v166 (copy), v167 (copy), v168 (copy), startPreview (copy), n4 (ref), v171 (ref)
    local Get = Walkouts.Get
    local v177 = {}
    local Avatar2 = LocalPlayer:GetAttribute("Avatar")

    if type(Avatar2) == "string" then
        local JSONDecode = HttpService.JSONDecode
        local ok, result = pcall(JSONDecode, HttpService, Avatar2)

        if ok and type(result) == "table" then
            v177 = result
        end
    end

    local v178 = Get(v177.Walkout)
    local v179 = LocalPlayer:GetAttribute("RerollTokens") or 0

    v165.Text = if v178 then string.upper(v178.Name) else "NONE"
    v165.TextColor3 = if v178 then v4 else v5
    v166.Text = if v178 then string.upper(v178.Rarity) .. "  ·  USED IN RANKED ENTRANCES" else "REROLL TO GET A WALKOUT SONG"
    v166.TextColor3 = if v178 then Walkouts.RarityColor(v178.Rarity) else v6
    v167.Visible = v178 ~= nil
    v168.TextTransparency = (Avatar.RerollCost or 1) <= v179 and 0 or 0.55

    local v184 = v178 and v178.Id

    if v184 ~= v171 then
        v171 = v184

        if v178 and v27.Enabled and os.clock() - n4 < 5 then
            startPreview(v178)
        end
    end
end

for _, v185 in { "Avatar", "RerollTokens" } do
    LocalPlayer:GetAttributeChangedSignal(v185):Connect(show)
end

v27:GetPropertyChangedSignal("Enabled"):Connect(function() -- line: 958
    -- upvalues: v27 (copy), stopPreview (copy), show (copy)
    if v27.Enabled then
        show()
    else
        stopPreview()
    end
end)
show()

do
    local function strip(p49, p50, p51) -- line: 971
        -- upvalues: New (copy), v4 (copy)
        local v186 = New("ScrollingFrame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ScrollBarThickness = 3,
            ScrollBarImageTransparency = 0.5,
            ScrollBarImageColor3 = v4,
            CanvasSize = UDim2.new(),
            AutomaticCanvasSize = Enum.AutomaticSize.X,
            ScrollingDirection = Enum.ScrollingDirection.X,
            Size = UDim2.fromOffset(416, p51),
            LayoutOrder = p50
        }, p49)

        New("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            Padding = UDim.new(0, 8),
            SortOrder = Enum.SortOrder.LayoutOrder
        }, v186)
        New("UIPadding", {
            PaddingTop = UDim.new(0, 2),
            PaddingLeft = UDim.new(0, 2)
        }, v186)

        return v186
    end

    local function clear(p52) -- line: 989
        for _, child in p52:GetChildren() do
            if child:IsA("GuiObject") then
                child:Destroy()
            end
        end
    end

    local function itemCard(p53, p54, p55, p56, p57, p58) -- line: 997
        -- upvalues: GothicUI (copy), New (copy), v1 (copy), v4 (copy), label (copy), n1 (ref)
        local v187 = New("TextButton", {
            Text = "",
            AutoButtonColor = false,
            BackgroundTransparency = 0.3,
            Name = p55,
            BackgroundColor3 = Color3.fromRGB(8, 7, 6),
            Size = UDim2.fromOffset(92, 116),
            LayoutOrder = p54
        }, p53)

        New("UIStroke", {
            Color = v4,
            Thickness = p57 and 2 or 1,
            Transparency = p57 and 0.05 or 0.8,
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        }, v187)

        local v188 = New("Frame", {
            BackgroundTransparency = 1,
            ClipsDescendants = true,
            Position = UDim2.fromOffset(4, 4),
            Size = UDim2.fromOffset(84, 76)
        }, v187)

        if p56 then
            p56.Parent = v188
        end

        label(v187, {
            TextSize = 10,
            TextWrapped = true,
            Text = string.upper(p55),
            FontFace = v1,
            TextXAlignment = Enum.TextXAlignment.Center,
            Position = UDim2.fromOffset(3, 80),
            Size = UDim2.fromOffset(86, 34)
        })
        v187.Activated:Connect(function(...) -- line: 94
            -- upvalues: p58 (copy), GothicUI (copy), n1 (ref)
            local elapsed = os.clock()

            if elapsed < n1 then
                return
            end

            n1 = elapsed + 0.3
            GothicUI.Click()
            p58(...)
        end)

        return v187
    end

    subheading(v80, "TOPS", 1)

    local v189 = strip(v80, 2, 120)
    local v190 = label(v80, {
        Text = "",
        TextSize = 13,
        LayoutOrder = 3,
        TextColor3 = v6,
        Size = UDim2.fromOffset(416, 20),
        FontFace = v3
    })

    subheading(v80, "BOTTOMS", 4)

    local v191 = strip(v80, 5, 120)
    local v192 = label(v80, {
        Text = "",
        TextSize = 13,
        LayoutOrder = 6,
        TextColor3 = v6,
        Size = UDim2.fromOffset(416, 20),
        FontFace = v3
    })

    label(v80, {
        Text = "More clothes are sold at the Clothing Store.",
        TextSize = 13,
        LayoutOrder = 7,
        FontFace = v3,
        TextColor3 = v5,
        Size = UDim2.fromOffset(416, 22)
    })
    subheading(v81, "ACCESSORIES", 1)

    local v193 = strip(v81, 2, 120)
    local v194 = label(v81, {
        Text = "",
        TextSize = 13,
        LayoutOrder = 3,
        TextColor3 = v6,
        Size = UDim2.fromOffset(416, 20),
        FontFace = v3
    })

    subheading(v81, "BELTS", 4)

    local v195 = strip(v81, 5, 120)
    local v196 = label(v81, {
        Text = "",
        TextSize = 13,
        LayoutOrder = 6,
        TextColor3 = v6,
        Size = UDim2.fromOffset(416, 20),
        FontFace = v3
    })

    local function thumbnail(p59) -- line: 1052
        -- upvalues: New (copy)
        return New("ImageLabel", {
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 1),
            ScaleType = Enum.ScaleType.Fit,
            Image = string.format("rbxthumb://type=Asset&id=%d&w=150&h=150", p59 or 0)
        })
    end

    local function refreshWardrobe() -- line: 1061
        -- upvalues: HttpService (copy), TweenService (copy), LocalPlayer (copy), ItemPictures (copy), SurvivalRemote (copy), t1 (copy), v9 (copy), v10 (copy), v55 (copy), n2 (ref), clear (copy), itemCard (copy), v189 (copy), v190 (copy), v191 (copy), v192 (copy), v193 (copy), v194 (copy), v195 (copy), v196 (copy), thumbnail (copy)
        local v197 = {}
        local Equipped = LocalPlayer:GetAttribute("Equipped")

        if type(Equipped) == "string" then
            local JSONDecode = HttpService.JSONDecode
            local ok, result = pcall(JSONDecode, HttpService, Equipped)

            if ok and type(result) == "table" then
                v197 = result
            end
        end

        clear(v189)
        clear(v191)

        local t15 = {}
        local t16 = {}
        local v198 = {}
        local OwnedClothes = LocalPlayer:GetAttribute("OwnedClothes")

        if type(OwnedClothes) == "string" then
            local JSONDecode = HttpService.JSONDecode
            local ok, result = pcall(JSONDecode, HttpService, OwnedClothes)

            if not ok or type(result) ~= "table" then
                result = v198
            end

            v198 = result
        end

        local v199, v200

        for _, v201 in v198, v199, v200 do
            local v202 = t1[v201]

            if v202 then
                table.insert(if v202.Kind == "Shirt" then t15 else t16, v202)
            end
        end

        for _, v204 in { t15, t16 } do
            table.sort(v204, function(p60, p61) -- line: 1074
                return p60.Name < p61.Name
            end)
        end

        for v205, v206 in t15 do
            local v207 = v197.Shirt == v206.Id

            itemCard(v189, v205, v206.Name, ItemPictures.Clothes(v206), v207, function() -- line: 1080
                -- upvalues: v206 (copy), v207 (copy), TweenService (copy), SurvivalRemote (copy), v55 (copy), n2 (ref)
                if not v207 then
                    SurvivalRemote:FireServer("Wear", "Shirt", v206.Id)

                    return
                end

                n2 += 1

                local v209 = n2

                v55.Text = "You always wear a top - pick another one to change"
                v55.TextTransparency = 0
                task.delay(2.6, function() -- line: 390
                    -- upvalues: v209 (copy), TweenService (copy), v55 (copy), n2 (ref)
                    if n2 == v209 then
                        TweenService:Create(v55, TweenInfo.new(0.5), {
                            TextTransparency = 1
                        }):Play()
                    end
                end)
            end)
        end

        for v210, v211 in t16 do
            local v212 = v197.Pants == v211.Id

            itemCard(v191, v210, v211.Name, ItemPictures.Clothes(v211), v212, function() -- line: 1090
                -- upvalues: v211 (copy), v212 (copy), TweenService (copy), SurvivalRemote (copy), v55 (copy), n2 (ref)
                if not v212 then
                    SurvivalRemote:FireServer("Wear", "Pants", v211.Id)

                    return
                end

                n2 += 1

                local v214 = n2

                v55.Text = "You always wear bottoms - pick another pair to change"
                v55.TextTransparency = 0
                task.delay(2.6, function() -- line: 390
                    -- upvalues: v214 (copy), TweenService (copy), v55 (copy), n2 (ref)
                    if n2 == v214 then
                        TweenService:Create(v55, TweenInfo.new(0.5), {
                            TextTransparency = 1
                        }):Play()
                    end
                end)
            end)
        end

        local v215 = #t15 > 0
        local v216 = #t15 == 0

        v189.Visible = v215
        v190.Visible = v216

        local v217 = #t16 > 0
        local v218 = #t16 == 0

        v191.Visible = v217
        v192.Visible = v218
        v190.Text = "No tops yet."
        v192.Text = "No bottoms yet."
        clear(v193)
        clear(v195)

        local t17 = {}

        for _, v219 in v197.Accessories or {} do
            t17[v219] = true
        end

        local v220 = {}
        local OwnedAccessories = LocalPlayer:GetAttribute("OwnedAccessories")

        if type(OwnedAccessories) == "string" then
            local JSONDecode = HttpService.JSONDecode
            local ok, result = pcall(JSONDecode, HttpService, OwnedAccessories)

            if not ok or type(result) ~= "table" then
                result = v220
            end

            v220 = result
        end

        local v221, v222
        local n5 = 0

        for _, v223 in v220, v221, v222 do
            local v224 = v9[v223]

            if v224 then
                n5 += 1
                itemCard(v193, n5, v224.Name or v223, thumbnail(v224.Asset), t17[v223], function() -- line: 1114
                    -- upvalues: v223 (copy), SurvivalRemote (copy)
                    SurvivalRemote:FireServer("Wear", "Accessory", v223)
                end)
            end
        end

        local v228 = {}
        local OwnedBelts = LocalPlayer:GetAttribute("OwnedBelts")

        if type(OwnedBelts) == "string" then
            local JSONDecode = HttpService.JSONDecode
            local ok, result = pcall(JSONDecode, HttpService, OwnedBelts)

            if not ok or type(result) ~= "table" then
                result = v228
            end

            v228 = result
        end

        local v229, v230
        local n6 = 0

        for _, v231 in v228, v229, v230 do
            local v232 = v10[v231]

            if v232 then
                n6 += 1

                local v233 = v197.Belt == v231

                itemCard(v195, n6, v232.Name or v231, thumbnail(v232.Asset), v233, function() -- line: 1124
                    -- upvalues: v231 (copy), v233 (copy), SurvivalRemote (copy)
                    SurvivalRemote:FireServer("Wear", "Belt", if v233 then "" else v231)
                end)
            end
        end

        local v237 = n5 > 0
        local v238 = n5 == 0

        v193.Visible = v237
        v194.Visible = v238

        local v239 = n6 > 0
        local v240 = n6 == 0

        v195.Visible = v239
        v196.Visible = v240
        v194.Text = "No accessories yet."
        v196.Text = "No belts yet."
    end

    local function feet(p62) -- line: 1137
        -- upvalues: Avatar (copy)
        local v242 = math.floor(p62 or Avatar.Height.Base)

        return string.format("%d'%d\"", math.floor(v242 / 12), v242 % 12)
    end

    local function refresh() -- line: 1142
        -- upvalues: HttpService (copy), LocalPlayer (copy), BoxingConfig (copy), Avatar (copy), v4 (copy), v5 (copy), t6 (copy), FirstName (copy), FirstName2 (copy), LastName (copy), LastName2 (copy), v92 (copy), v122 (copy), v123 (copy), t10 (copy), t11 (copy), v126 (copy), v127 (copy), v128 (copy), v131 (copy), v132 (copy), v134 (copy), t12 (copy), v153 (copy), v154 (copy), v155 (copy), t13 (copy)
        local v244 = {}
        local Avatar2 = LocalPlayer:GetAttribute("Avatar")

        if type(Avatar2) == "string" then
            local JSONDecode = HttpService.JSONDecode
            local ok, result = pcall(JSONDecode, HttpService, Avatar2)

            if ok and type(result) == "table" then
                v244 = result
            end
        end

        local RerollTokens = LocalPlayer:GetAttribute("RerollTokens") or v244.Tokens or 0
        local v245 = Avatar.RerollCost or 1

        for v246, v247 in t6 do
            v247.Transparency = v246 == v244.Skin and 0 or 1
        end

        FirstName.Text = string.upper(v244.First or "")
        LastName.Text = string.upper(v244.Last or "")
        v92.Text = "REROLL TOKENS - " .. RerollTokens

        local v248 = Avatar.HairStyles[v244.HairStyle or 1]

        v122.Text = string.upper(v248 and v248.Name or "-")
        t10.Visible = #Avatar.HairStyles > 1
        t11.Visible = #Avatar.HairStyles > 1

        local v249 = Avatar.HairColors[v244.HairColor or 1]

        v126.BackgroundColor3 = v249 and v249.Color or Color3.new(0, 0, 0)
        v127.Text = string.upper(v249 and v249.Name or "")
        v131.Text = BoxingConfig.FormatHeight(v244.Height)

        local v250 = Avatar.EyeColors[v244.EyeColor or 1]

        v153.BackgroundColor3 = v250 and v250.Color or Color3.new(0, 0, 0)
        v154.Text = string.upper(v250 and v250.Name or "")

        local v251 = BoxingConfig.Faces or {}
        local v252 = if type(v244.Face) == "table" then v244.Face else {}
        local Eyes = v252.Eyes or v244.FaceStyle or 1
        local v253 = true

        for _, v254 in t13 do
            if v254.Line.Part and (v252[v254.Line.Part] or Eyes) ~= Eyes then
                v253 = false
            end
        end

        for _, v255 in t13 do
            local v256 = v251[v255.Line.Part and v252[v255.Line.Part] or Eyes]
            local Name = v255.Name

            if v255.Line.Part or v253 then
                Name.Text = string.upper(v256 and v256.Name or "Ippo")
            else
                Name.Text = "MIXED"
            end

            v255.Reroll.Visible = #v251 > 1
        end

        for v257, v258 in t12 do
            local v259 = v257 == v244.Gender

            v258.Stroke.Transparency = v259 and 0.05 or 0.78
            v258.Stroke.Thickness = v259 and 2 or 1

            local Button = v258.Button

            if v259 then
                Button.TextColor3 = v4
            else
                Button.TextColor3 = v5
            end
        end

        local v260 = v245 <= RerollTokens
        local t18 = {
            FirstName2,
            LastName2,
            v128,
            v155,
            v123
        }

        for _, v261 in t13 do
            table.insert(t18, v261.Reroll)
        end

        for _, v262 in t18 do
            v262.TextTransparency = v260 and 0 or 0.55
        end

        v134.TextTransparency = v132 <= RerollTokens and 0 or 0.55
    end

    local v263 = false
    local t19 = {}
    local v264
    local t20 = {}
    local n7 = 0
    local t21

    local function hideOthers() -- line: 1204
        -- upvalues: PlayerGui (copy), v27 (copy), t19 (copy)
        for _, child in PlayerGui:GetChildren() do
            if child:IsA("ScreenGui") and child ~= v27 and child.Enabled and child.Name ~= "TouchGui" then
                child.Enabled = false
                t19[child] = true
            end
        end
    end

    local v265 = New("ScreenGui", {
        Name = "AvatarCreatorCurtain",
        ResetOnSpawn = false,
        IgnoreGuiInset = true,
        DisplayOrder = 200
    }, PlayerGui)
    local v266 = New("Frame", {
        Name = "Curtain",
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Visible = false,
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = Color3.new(0, 0, 0)
    }, v265)
    local startHideLoop
    local n8 = 0
    local clone, ExposureCompensation, t22
    local v267 = false
    local t23 = {}
    local t24 = {
        "LuaSourceContainer",
        "Tool",
        "ForceField",
        "BillboardGui",
        "Sound",
        "BodyMover",
        "ProximityPrompt"
    }

    local function clearPreview() -- line: 1264
        -- upvalues: t22 (ref)
        if not t22 then
            return
        end

        if t22.Track then
            local function v268() -- line: 1267
                -- upvalues: t22 (ref)
                t22.Track:Stop(0)
            end

            pcall(v268)
        end

        t22.Model:Destroy()
        t22 = nil
    end

    local function buildPreview() -- line: 1276
        -- upvalues: LocalPlayer (copy), New (copy), n7 (ref), clone (ref), t22 (ref), t24 (copy)
        if t22 then
            if t22.Track then
                local function v269() -- line: 1267
                    -- upvalues: t22 (ref)
                    t22.Track:Stop(0)
                end

                pcall(v269)
            end

            t22.Model:Destroy()
            t22 = nil
        end

        local Character = LocalPlayer.Character
        local Stand = clone and clone:FindFirstChild("Stand")

        if not (Character and Stand) then
            return
        end

        local Archivable = Character.Archivable

        Character.Archivable = true

        local Clone = Character.Clone
        local ok, result = pcall(Clone, Character)

        Character.Archivable = Archivable

        if ok and result then
            for _, descendant in result:GetDescendants() do
                for _, v270 in t24 do
                    if descendant:IsA(v270) then
                        descendant:Destroy()
                        break
                    end
                end
            end

            result.Name = "CreatorPreview"

            local Humanoid = result:FindFirstChildOfClass("Humanoid")
            local HumanoidRootPart = result:FindFirstChild("HumanoidRootPart")

            if not Humanoid or not HumanoidRootPart then
                result:Destroy()
            else
                Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
                Humanoid.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOff
                Humanoid.BreakJointsOnDeath = false

                for _, descendant in result:GetDescendants() do
                    if descendant:IsA("BasePart") then
                        descendant.Anchored = descendant == HumanoidRootPart
                        descendant.CanCollide = false
                        descendant.CanTouch = false
                        descendant.CanQuery = false
                    end
                end

                result.PrimaryPart = HumanoidRootPart
                result.Parent = clone
                result:PivotTo(Stand.CFrame)

                local BoundingBox, BoundingBox2 = result:GetBoundingBox()
                local v272 = Stand.CFrame + Vector3.new(0, Stand.Position.Y - (BoundingBox.Position.Y - BoundingBox2.Y / 2), 0)

                result:PivotTo(v272 * CFrame.Angles(0, n7, 0))

                local Animate = Character:FindFirstChild("Animate")
                local idle = Animate and Animate:FindFirstChild("idle")
                local v273 = idle and idle:FindFirstChildWhichIsA("Animation", true)
                local v274 = Humanoid:FindFirstChildOfClass("Animator") or New("Animator", {}, Humanoid)
                local result2

                if v273 then
                    local LoadAnimation = v274.LoadAnimation
                    local ok

                    ok, result2 = pcall(LoadAnimation, v274, v273)

                    if ok and result2 then
                        result2.Looped = true
                        result2:Play(0)
                    else
                        result2 = nil
                    end
                end

                t22 = {
                    Model = result,
                    Base = v272,
                    Track = result2
                }
            end
        end
    end

    local function queuePreview() -- line: 1338
        -- upvalues: v263 (ref), v267 (ref), buildPreview (copy)
        if not v267 and v263 then
            v267 = true
            task.delay(0.45, function() -- line: 1343
                -- upvalues: v263 (ref), v267 (ref), buildPreview (copy)
                v267 = false

                if v263 then
                    buildPreview()
                end
            end)
        end
    end

    local function buildGym() -- line: 1351
        -- upvalues: Boxing (copy), Avatar (copy), clone (ref)
        local v276 = Boxing:FindFirstChild(Avatar.GymTemplate or "CreatorGym")

        if not v276 then
            return
        end

        clone = v276:Clone()
        clone.Name = "LocalCreatorGym"

        local clone2 = clone

        clone2:PivotTo(CFrame.new(Avatar.GymSpot or Vector3.new(6000, 600, 6000)) * v276:GetPivot().Rotation)

        local clone3 = clone

        clone3.Parent = workspace
    end

    local n9 = 0

    UserInputService.InputChanged:Connect(function(p63) -- line: 1364
        -- upvalues: n9 (ref)
        if p63.KeyCode == Enum.KeyCode.Thumbstick2 then
            n9 = p63.Position.X
        end
    end)

    local function padDown(p64) -- line: 1369
        -- upvalues: UserInputService (copy)
        if UserInputService:IsKeyDown(p64) then
            return true
        end

        local IsGamepadButtonDown = UserInputService.IsGamepadButtonDown
        local Gamepad1 = Enum.UserInputType.Gamepad1
        local ok, result = pcall(IsGamepadButtonDown, UserInputService, Gamepad1, p64)

        return ok and result == true
    end

    local function holdCamera(p65) -- line: 1377
        -- upvalues: UserInputService (copy), n7 (ref), clone (ref), t22 (ref), n9 (ref)
        local CameraSpot = clone and clone:FindFirstChild("CameraSpot")
        local CurrentCamera = workspace.CurrentCamera

        if CameraSpot then
            CurrentCamera.CameraType = Enum.CameraType.Scriptable

            local v277 = CurrentCamera.ViewportSize.Y < 500 and -4.8 or 0

            CurrentCamera.CFrame = CameraSpot.CFrame * CFrame.new(v277, 0, 0)
            CurrentCamera.FieldOfView = CameraSpot:GetAttribute("FieldOfView") or 48
        end

        local v278

        if UserInputService:GetFocusedTextBox() then
            v278 = 0
        else
            local v279

            if UserInputService:IsKeyDown(Enum.KeyCode.Q) then
                v279 = 0 + 1
            else
                local ButtonL1 = Enum.KeyCode.ButtonL1

                if UserInputService:IsKeyDown(ButtonL1) then
                    v279 = 0 + 1
                else
                    local IsGamepadButtonDown = UserInputService.IsGamepadButtonDown
                    local Gamepad1 = Enum.UserInputType.Gamepad1
                    local ok, result = pcall(IsGamepadButtonDown, UserInputService, Gamepad1, ButtonL1)

                    v279 = if ok and result == true then 0 + 1 else 0
                end
            end

            local v280, v281

            if UserInputService:IsKeyDown(Enum.KeyCode.E) then
                v281 = false
            else
                local ButtonR1 = Enum.KeyCode.ButtonR1

                if UserInputService:IsKeyDown(ButtonR1) then
                    v281 = false
                else
                    local IsGamepadButtonDown = UserInputService.IsGamepadButtonDown
                    local Gamepad1 = Enum.UserInputType.Gamepad1
                    local ok, result = pcall(IsGamepadButtonDown, UserInputService, Gamepad1, ButtonR1)

                    if ok and result == true then
                        v281 = false
                    else
                        v280 = v279
                        v281 = true
                    end
                end
            end

            if not v281 then
                v280 = v279 - 1
            end

            v278 = v280

            if v280 == 0 and math.abs(n9) > 0.25 then
                v278 = -n9
            end
        end

        if v278 ~= 0 then
            n7 += v278 * 2.6179938779914944 * p65

            if t22 and t22.Model.Parent then
                t22.Model:PivotTo(t22.Base * CFrame.Angles(0, n7, 0))
            end
        end
    end

    local function setOpen(p66) -- line: 1409
        -- upvalues: Lighting (copy), RunService (copy), TweenService (copy), LocalPlayer (copy), MenuState (copy), New (copy), v27 (copy), layout (copy), refreshWardrobe (copy), refresh (copy), v263 (ref), t19 (copy), v264 (ref), t20 (copy), n7 (ref), t21 (ref), hideOthers (copy), v266 (copy), startHideLoop (ref), n8 (ref), clone (ref), ExposureCompensation (ref), t22 (ref), t23 (copy), buildPreview (copy), queuePreview (copy), buildGym (copy), holdCamera (copy)
        if v263 == p66 then
            return
        end

        v263 = p66

        if p66 then
            local v284 = MenuState.Current()

            if v284 and v284 ~= "Avatar" then
                MenuState.Close(v284)
            end

            MenuState.Open("Avatar")
            n7 = 0
            t21 = {
                FieldOfView = workspace.CurrentCamera.FieldOfView
            }
            hideOthers()
            v264 = New("ColorCorrectionEffect", {
                Name = "AvatarCreatorGrade",
                Brightness = -0.03,
                Contrast = 0.2,
                Saturation = -0.22,
                TintColor = Color3.fromRGB(255, 240, 226)
            }, Lighting)

            for _, child in Lighting:GetChildren() do
                if (child:IsA("DepthOfFieldEffect") or child:IsA("BloomEffect")) and child.Enabled then
                    child.Enabled = false
                    t20[child] = true
                end
            end

            ExposureCompensation = Lighting.ExposureCompensation
            Lighting.ExposureCompensation = ExposureCompensation - 0.85
            buildGym()
            buildPreview()

            local Character = LocalPlayer.Character

            if Character then
                table.insert(t23, Character.DescendantAdded:Connect(queuePreview))
                table.insert(t23, Character.DescendantRemoving:Connect(queuePreview))
                table.insert(t23, Character:GetAttributeChangedSignal("AvatarVersion"):Connect(queuePreview))
            end

            RunService:BindToRenderStep("AvatarCreatorCamera", Enum.RenderPriority.Camera.Value + 20, holdCamera)
            refresh()
            refreshWardrobe()
            layout()
            v27.Enabled = true
            n8 += 1

            local v286 = n8

            v266.BackgroundTransparency = 0
            v266.Visible = true
            task.delay(0.08, function() -- line: 1238
                -- upvalues: v286 (copy), TweenService (copy), v266 (copy), n8 (ref)
                if n8 ~= v286 then
                    return
                end

                local tween = TweenService:Create(v266, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    BackgroundTransparency = 1
                })

                tween.Completed:Connect(function(p67) -- line: 1243
                    -- upvalues: v286 (copy), v266 (copy), n8 (ref)
                    if p67 == Enum.PlaybackState.Completed and n8 == v286 then
                        v266.Visible = false
                    end
                end)
                tween:Play()
            end)
            startHideLoop()
        else
            v27.Enabled = false
            RunService:UnbindFromRenderStep("AvatarCreatorCamera")

            for _, v287 in t23 do
                v287:Disconnect()
            end

            table.clear(t23)

            if t22 then
                if t22.Track then
                    local function v288() -- line: 1267
                        -- upvalues: t22 (ref)
                        t22.Track:Stop(0)
                    end

                    pcall(v288)
                end

                t22.Model:Destroy()
                t22 = nil
            end

            if clone then
                clone:Destroy()
                clone = nil
            end

            for v289 in t19 do
                if v289.Parent then
                    v289.Enabled = true
                end
            end

            table.clear(t19)

            if v264 then
                v264:Destroy()
                v264 = nil
            end

            for v290 in t20 do
                if v290.Parent then
                    v290.Enabled = true
                end
            end

            table.clear(t20)

            if ExposureCompensation then
                Lighting.ExposureCompensation = ExposureCompensation
                ExposureCompensation = nil
            end

            local CurrentCamera = workspace.CurrentCamera

            CurrentCamera.CameraType = Enum.CameraType.Custom

            local Character = LocalPlayer.Character
            local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

            if Humanoid then
                CurrentCamera.CameraSubject = Humanoid
            end

            if t21 then
                CurrentCamera.FieldOfView = t21.FieldOfView
            end

            n8 += 1

            local v291 = n8

            v266.BackgroundTransparency = 0
            v266.Visible = true
            task.delay(0.08, function() -- line: 1238
                -- upvalues: v291 (copy), TweenService (copy), v266 (copy), n8 (ref)
                if n8 ~= v291 then
                    return
                end

                local tween = TweenService:Create(v266, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    BackgroundTransparency = 1
                })

                tween.Completed:Connect(function(p68) -- line: 1243
                    -- upvalues: v291 (copy), v266 (copy), n8 (ref)
                    if p68 == Enum.PlaybackState.Completed and n8 == v291 then
                        v266.Visible = false
                    end
                end)
                tween:Play()
            end)
            MenuState.Close("Avatar")
        end
    end

    PlayerGui.ChildAdded:Connect(function(p69) -- line: 1504
        -- upvalues: v27 (copy), v263 (ref), t19 (copy)
        if v263 and p69:IsA("ScreenGui") and p69 ~= v27 then
            task.defer(function() -- line: 1506
                -- upvalues: p69 (copy), v263 (ref), t19 (copy)
                if v263 and p69.Enabled then
                    p69.Enabled = false
                    t19[p69] = true
                end
            end)
        end
    end)

    local n10 = 0

    function startHideLoop() -- line: 1515
        -- upvalues: v263 (ref), hideOthers (copy), n10 (ref)
        n10 += 1

        local v292 = n10

        task.spawn(function() -- line: 1518
            -- upvalues: v292 (copy), v263 (ref), hideOthers (copy), n10 (ref)
            while v263 and n10 == v292 do
                task.wait(0.5)

                if v263 and n10 == v292 then
                    hideOthers()
                end
            end
        end)
    end

    v35.Activated:Connect((guarded(function() -- line: 1528
        -- upvalues: AvatarRemote (copy)
        AvatarRemote:FireServer("Save")
    end)))

    local function watchCharacter(p70) -- line: 1532
        -- upvalues: LocalPlayer (copy), setOpen (copy)
        local function check() -- line: 1533
            -- upvalues: p70 (copy), setOpen (copy)
            setOpen(p70:GetAttribute("InCreator") == true and p70.Parent ~= nil)
        end

        p70:GetAttributeChangedSignal("InCreator"):Connect(check)
        p70.AncestryChanged:Connect(function() -- line: 1537
            -- upvalues: p70 (copy), LocalPlayer (copy), setOpen (copy)
            if not p70.Parent and LocalPlayer.Character == p70 then
                setOpen(false)
            end
        end)
        setOpen(p70:GetAttribute("InCreator") == true and p70.Parent ~= nil)
    end

    LocalPlayer.CharacterAdded:Connect(function(p71) -- line: 1544
        -- upvalues: setOpen (copy), watchCharacter (copy)
        setOpen(false)
        watchCharacter(p71)
    end)

    if LocalPlayer.Character then
        watchCharacter(LocalPlayer.Character)
    end

    AvatarRemote.OnClientEvent:Connect(function(p72, p73) -- line: 1552
        -- upvalues: TweenService (copy), v55 (copy), n2 (ref), v263 (ref)
        if p72 ~= "Notice" or type(p73) ~= "string" or not v263 then
            return
        end

        n2 += 1

        local v295 = n2

        v55.Text = p73
        v55.TextTransparency = 0
        task.delay(2.6, function() -- line: 390
            -- upvalues: v295 (copy), TweenService (copy), v55 (copy), n2 (ref)
            if n2 == v295 then
                TweenService:Create(v55, TweenInfo.new(0.5), {
                    TextTransparency = 1
                }):Play()
            end
        end)
    end)

    for _, v296 in { "Avatar", "RerollTokens" } do
        LocalPlayer:GetAttributeChangedSignal(v296):Connect(function() -- line: 1559
            -- upvalues: refresh (copy), v263 (ref)
            if v263 then
                refresh()
            end
        end)
    end

    for _, v297 in { "OwnedClothes", "OwnedAccessories", "OwnedBelts", "Equipped" } do
        LocalPlayer:GetAttributeChangedSignal(v297):Connect(function() -- line: 1566
            -- upvalues: refreshWardrobe (copy), v263 (ref)
            if v263 then
                refreshWardrobe()
            end
        end)
    end
end

local t25 = {
    {
        Name = "Common",
        Min = 0.4,
        Color = Color3.fromRGB(196, 196, 204)
    },
    {
        Name = "Uncommon",
        Min = 0.15,
        Color = Color3.fromRGB(110, 210, 120)
    },
    {
        Name = "Rare",
        Min = 0.05,
        Color = Color3.fromRGB(90, 160, 255)
    },
    {
        Name = "Epic",
        Min = 0.02,
        Color = Color3.fromRGB(186, 102, 255)
    },
    {
        Name = "Legendary",
        Min = 0,
        Color = Color3.fromRGB(255, 198, 64)
    }
}

local function rarityOf(p74) -- line: 1587
    -- upvalues: t25 (copy)
    for _, v298 in t25 do
        if v298.Min <= p74 then
            return v298
        end
    end

    return t25[#t25]
end

local function pct(p75) -- line: 1595
    if p75 >= 0.1 then
        return string.format("%d%%", (math.floor(p75 * 100 + 0.5)))
    end

    return (string.format("%.1f%%", p75 * 100):gsub("%.0%%", "%%"))
end

local function weighted(p76, p77) -- line: 1602
    local n11 = 0

    for _, v300 in p76 do
        n11 += v300.Weight or 1
    end

    local t26 = {}
    local v301

    for _, v302 in p76 do
        local v303 = (v302.Weight or 1) / math.max(n11, 1E-06)

        table.insert(t26, v302.Name .. " " .. (if v303 >= 0.1 then string.format("%d%%", (math.floor(v303 * 100 + 0.5))) else string.format("%.1f%%", v303 * 100):gsub("%.0%%", "%%")))

        if string.upper(v302.Name) == string.upper(p77) then
            v301 = v303
        end
    end

    return v301, table.concat(t26, "  ·  ")
end

local Walkouts2 = require(Boxing:WaitForChild("Walkouts"))
local t27 = {}

local function equalList(p78, p79) -- line: 1621
    -- upvalues: v5 (copy), pct (copy)
    return "Standard", v5, string.format("Every %s is equally likely: 1 in %d (%s)", p79, p78, pct(1 / math.max(p78, 1))), nil
end

t27[FirstName] = function(p80) -- line: 1624
    -- upvalues: Avatar (copy), equalList (copy)
    return p80, equalList(#(Avatar.FirstNames or {}), "first name")
end

t27[LastName] = function(p81) -- line: 1627
    -- upvalues: Avatar (copy), equalList (copy)
    return p81, equalList(#(Avatar.LastNames or {}), "last name")
end

t27[v122] = function(p82) -- line: 1630
    -- upvalues: Avatar (copy), equalList (copy)
    return p82, equalList(#(Avatar.HairStyles or {}), "hair style")
end

t27[v127] = function(p83) -- line: 1633
    -- upvalues: Avatar (copy), t25 (copy), weighted (copy)
    local v307, v308 = weighted(Avatar.HairColors or {}, p83)
    local v309 = v307 or 0
    local v310 = false
    local v311

    for _, v312 in t25 do
        if v312.Min <= v309 then
            v311 = v312
            v310 = true
            break
        end
    end

    if not v310 then
        v311 = t25[#t25]
    end

    local Name, Color = v311.Name, v311.Color

    if not v307 then
        local v313 = ""

        return p83, Name, Color, v313, v308
    end

    return p83, Name, Color, (if v307 >= 0.1 then string.format("%d%%", (math.floor(v307 * 100 + 0.5))) else string.format("%.1f%%", v307 * 100):gsub("%.0%%", "%%")) .. " chance on a reroll", v308
end

t27[v154] = function(p84) -- line: 1638
    -- upvalues: Avatar (copy), t25 (copy), weighted (copy)
    local v316, v317 = weighted(Avatar.EyeColors or {}, p84)
    local v318 = v316 or 0
    local v319 = false
    local v320

    for _, v321 in t25 do
        if v321.Min <= v318 then
            v320 = v321
            v319 = true
            break
        end
    end

    if not v319 then
        v320 = t25[#t25]
    end

    local Name, Color = v320.Name, v320.Color

    if not v316 then
        local v322 = ""

        return p84, Name, Color, v322, v317
    end

    return p84, Name, Color, (if v316 >= 0.1 then string.format("%d%%", (math.floor(v316 * 100 + 0.5))) else string.format("%.1f%%", v316 * 100):gsub("%.0%%", "%%")) .. " chance on a reroll", v317
end

t27[v131] = function(p85) -- line: 1643
    -- upvalues: BoxingConfig (copy), Avatar (copy), t25 (copy), pct (copy)
    local v325 = Avatar.Height or {}
    local n12 = 0

    for _, v326 in v325.Odds or {} do
        n12 += v326.Weight
    end

    local t28 = {}
    local t29

    for _, v327 in v325.Odds or {} do
        local v328 = v327.Weight / math.max(n12, 1E-06)
        local v329 = if v327.Min == v327.Max then BoxingConfig.FormatHeight(v327.Min) else BoxingConfig.FormatHeight(v327.Min) .. "-" .. BoxingConfig.FormatHeight(v327.Max)

        table.insert(t28, v329 .. " " .. (if v328 >= 0.1 then string.format("%d%%", (math.floor(v328 * 100 + 0.5))) else string.format("%.1f%%", v328 * 100):gsub("%.0%%", "%%")))

        for i = v327.Min, v327.Max do
            if BoxingConfig.FormatHeight(i) == p85 then
                t29 = {
                    Range = v329,
                    Chance = v328,
                    Inch = v328 / (v327.Max - v327.Min + 1)
                }
            end
        end
    end

    local Chance = t29 and t29.Chance or 0
    local v333 = false
    local v334

    for _, v335 in t25 do
        if v335.Min <= Chance then
            v334 = v335
            v333 = true
            break
        end
    end

    if not v333 then
        v334 = t25[#t25]
    end

    local v336

    if not t29 then
        v336 = ""

        return p85, v334.Name, v334.Color, v336, table.concat(t28, "  ·  ")
    end

    local format = string.format
    local Range, Chance2 = t29.Range, t29.Chance

    v336 = format("%s range: %s  ·  exactly %s: %s", Range, if Chance2 >= 0.1 then string.format("%d%%", (math.floor(Chance2 * 100 + 0.5))) else string.format("%.1f%%", Chance2 * 100):gsub("%.0%%", "%%"), p85, pct(t29.Inch))

    return p85, v334.Name, v334.Color, v336, table.concat(t28, "  ·  ")
end

local Name

for _, v339 in t13 do
    Name = v339.Name

    t27[Name] = function(p86) -- line: 1665
        -- upvalues: BoxingConfig (copy), v5 (copy), equalList (copy)
        if p86 == "MIXED" then
            return "MIXED", "Mixed", v5, "Parts from different faces", nil
        end

        return p86, equalList(#(BoxingConfig.Faces or {}), "face")
    end
end

local v340 = v27:FindFirstChild("RerollWalkout", true)

if v340 and v340.Parent then
    for _, child in v340.Parent:GetChildren() do
        if child:IsA("TextLabel") and child.TextSize == 15 then
            t27[child] = function(p87) -- line: 1677
                -- upvalues: v5 (copy), Walkouts2 (copy)
                local n13 = 0
                local v341

                for _, v342 in Walkouts2.Songs or Walkouts2.List or {} do
                    n13 += v342.Weight or 1

                    if string.upper(v342.Name) == p87 then
                        v341 = v342
                    end
                end

                if not v341 then
                    return p87, "None", v5, "Reroll for a walkout song", Walkouts2.OddsText()
                end

                local Rarity = v341.Rarity
                local v343 = Walkouts2.RarityColor(v341.Rarity)
                local v344 = (v341.Weight or 1) / math.max(n13, 1E-06)

                if not (v344 >= 0.1) then
                    local v345 = string.format("%.1f%%", v344 * 100):gsub("%.0%%", "%%")

                    return p87, Rarity, v343, v345 .. " chance on a reroll", Walkouts2.OddsText()
                end

                return p87, Rarity, v343, string.format("%d%%", (math.floor(v344 * 100 + 0.5))) .. " chance on a reroll", Walkouts2.OddsText()
            end
        end
    end
end

local Frame = Instance.new("Frame")

Frame.Name = "RarityCard"
Frame.BackgroundColor3 = Color3.fromRGB(16, 15, 18)
Frame.BackgroundTransparency = 0.08
Frame.BorderSizePixel = 0
Frame.AutomaticSize = Enum.AutomaticSize.Y
Frame.Size = UDim2.fromOffset(300, 0)
Frame.Visible = false
Frame.ZIndex = 60
Frame.Parent = v27

local UIStroke = Instance.new("UIStroke")

UIStroke.Thickness = 2
UIStroke.Parent = Frame

local UIPadding = Instance.new("UIPadding")
local v347 = UDim.new(0, 12)
local v348 = UDim.new(0, 12)

Name = UDim.new(0, 8)

local v349 = UDim.new(0, 10)

UIPadding.PaddingLeft = v347
UIPadding.PaddingRight = v348
UIPadding.PaddingTop = Name
UIPadding.PaddingBottom = v349
UIPadding.Parent = Frame
UIPadding = Instance.new("UIListLayout")
UIPadding.SortOrder = Enum.SortOrder.LayoutOrder
UIPadding.Padding = UDim.new(0, 3)
UIPadding.Parent = Frame

local function line(p88, p89, p90, p91) -- line: 1715
    -- upvalues: v2 (copy), Frame (copy)
    local TextLabel = Instance.new("TextLabel")

    TextLabel.BackgroundTransparency = 1
    TextLabel.FontFace = p91 or v2
    TextLabel.TextSize = p89
    TextLabel.TextColor3 = p90
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel.TextWrapped = true
    TextLabel.AutomaticSize = Enum.AutomaticSize.Y
    TextLabel.Size = UDim2.new(1, 0, 0, 0)
    TextLabel.LayoutOrder = p88
    TextLabel.ZIndex = 61
    TextLabel.Parent = Frame

    return TextLabel
end

local v350 = line(1, 17, v4)
local v351 = line(2, 15, v4)
local v352 = line(3, 13, v5)
local v353 = line(4, 11, v6)
local v354 = nil
local v355

local function place() -- line: 1736
    -- upvalues: UserInputService (copy), Frame (copy)
    local MouseLocation = UserInputService:GetMouseLocation()
    local ViewportSize = workspace.CurrentCamera.ViewportSize
    local AbsoluteSize = Frame.AbsoluteSize
    local v358 = math.min(MouseLocation.X + 18, ViewportSize.X - AbsoluteSize.X - 8)
    local v361 = math.min(MouseLocation.Y + 18, ViewportSize.Y - AbsoluteSize.Y - 8)

    Frame.Position = UDim2.fromOffset(math.max(8, v358), (math.max(8, v361)))
end

local function show2(p92) -- line: 1744
    -- upvalues: v4 (copy), v5 (copy), t27 (copy), Frame (copy), UIStroke (copy), v350 (copy), v351 (copy), v352 (copy), v353 (copy), v354 (ref), place (copy)
    local v362 = t27[p92]
    local Text = p92.Text

    if v362 and Text ~= "" and Text ~= "-" then
        local v363, v364, v365, v366, v367, v368 = pcall(v362, Text)

        if not v363 then
            return
        end

        v350.Text = v364
        v351.Text = string.upper(v365 or "")
        v351.TextColor3 = v366 or v4
        UIStroke.Color = v366 or v5
        v352.Text = v367 or ""
        v353.Text = if v368 then "ODDS  " .. v368 else ""
        v353.Visible = v368 ~= nil
        v354 = p92
        Frame.Visible = true
        place()
    end
end

for v371 in t27 do
    v371.Active = true
    v371.MouseEnter:Connect(function() -- line: 1773
        -- upvalues: v355 (ref), show2 (copy), v371 (copy)
        v355 = nil
        show2(v371)
    end)
    v371.MouseLeave:Connect(function() -- line: 1777
        -- upvalues: Frame (copy), v354 (ref), v355 (ref), v371 (copy)
        if v354 ~= v371 and v371 ~= nil then
            return
        end

        v354 = nil
        v355 = nil
        Frame.Visible = false
    end)
    v371.InputBegan:Connect(function(p93) -- line: 1780
        -- upvalues: v355 (ref), show2 (copy), v371 (copy)
        if p93.UserInputType == Enum.UserInputType.Touch then
            show2(v371)
            v355 = os.clock() + 3
        end
    end)
end

game:GetService("RunService").RenderStepped:Connect(function() -- line: 1787
    -- upvalues: v27 (copy), Frame (copy), v354 (ref), v355 (ref), place (copy)
    if Frame.Visible then
        if v27.Enabled and (not v354 or v354:IsDescendantOf(v27)) and (not v355 or not (os.clock() >= v355)) then
            if not v355 then
                place()
            end
        else
            if v354 == nil then
            end

            v354 = nil
            v355 = nil
            Frame.Visible = false
        end
    end
end)
