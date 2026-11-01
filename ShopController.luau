-- https://lua.expert

local GuiService = game:GetService("GuiService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local ProximityPromptService = game:GetService("ProximityPromptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Boxing = ReplicatedStorage:WaitForChild("Boxing")
local t1 = {}
local BoxingConfig = require(Boxing:WaitForChild("BoxingConfig"))
local SurvivalArt = require(Boxing:WaitForChild("SurvivalArt"))
local MenuState = require(Boxing:WaitForChild("MenuState"))
local GothicUI = require(Boxing:WaitForChild("GothicUI"))
local ItemPictures = require(Boxing:WaitForChild("ItemPictures"))
local SurvivalRemote = Boxing:WaitForChild("SurvivalRemote")
local New, Images = GothicUI.New, GothicUI.Images
local Shops, Foods = BoxingConfig.Shops, BoxingConfig.Foods
local v1 = Vector2.new(900, 706)
local v2 = Font.new("rbxasset://fonts/families/Montserrat.json", Enum.FontWeight.Heavy, Enum.FontStyle.Italic)
local _, BoldFont = GothicUI.Font, GothicUI.BoldFont
local v3 = Color3.fromRGB(236, 232, 224)
local v4 = Color3.fromRGB(160, 158, 164)
local v5 = Color3.fromRGB(255, 212, 96)
local v6 = Color3.fromRGB(236, 92, 80)
local v7 = Color3.fromRGB(150, 220, 140)
local Fade, Quick = GothicUI.Fade, GothicUI.Quick
local t2 = {
    Normal = {
        Kana = "コンビニ",
        Tag = "EVERYDAY CONVENIENCE",
        Banner = Images.ShopBannerNormal,
        Accent = Color3.fromRGB(222, 222, 228)
    },
    Noodles = {
        Kana = "ラーメン",
        Tag = "NOODLES & GYOZA",
        Banner = Images.ShopBannerNoodles,
        Accent = Color3.fromRGB(222, 222, 228)
    },
    Bakery = {
        Kana = "山中ベーカリー",
        Tag = "FRESH FROM THE OVEN",
        Banner = Images.ShopBannerBakery,
        Accent = Color3.fromRGB(222, 222, 228)
    },
    Clothes = {
        Kana = "スポーツウェア",
        Tag = "SPORTSWEAR & GYM KIT",
        Banner = Images.ShopBannerClothes,
        Accent = Color3.fromRGB(222, 222, 228)
    }
}
local t3 = {}
local t4

local function setInteract(p1) -- line: 65
    -- upvalues: PlayerGui (copy)
    local v8 = PlayerGui:FindFirstChild("e to interact")

    if v8 then
        v8.Enabled = p1
    end
end

local function refreshInteract() -- line: 72
    -- upvalues: PlayerGui (copy), MenuState (copy), t3 (copy), t4 (ref)
    local v9 = t4 == nil and next(t3) ~= nil and not MenuState.IsOpen()
    local v10 = PlayerGui:FindFirstChild("e to interact")

    if v10 then
        v10.Enabled = v9
    end
end

local v11 = New("ScreenGui", {
    Name = "ShopGui",
    ResetOnSpawn = false,
    IgnoreGuiInset = true,
    DisplayOrder = 60,
    Enabled = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling
})

v11:SetAttribute("CharcoalTheme", true)

local v12 = New("Frame", {
    Name = "Dim",
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    Active = true,
    Size = UDim2.fromScale(1, 1),
    BackgroundColor3 = Color3.new(0, 0, 0)
}, v11)
local v13 = New("CanvasGroup", {
    Name = "Window",
    BackgroundTransparency = 1,
    GroupTransparency = 1,
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromScale(0.5, 0.5),
    Size = UDim2.fromOffset(v1.X + 44, v1.Y + 44)
}, v11)
local v14 = New("UIScale", {}, v13)
local v15 = New("ImageLabel", {
    Name = "Frame",
    BackgroundTransparency = 1,
    SliceScale = 0.85,
    Active = true,
    Position = UDim2.fromOffset(22, 22),
    Size = UDim2.fromOffset(v1.X, v1.Y),
    Image = Images.ShopFrame,
    ScaleType = Enum.ScaleType.Slice,
    SliceCenter = Rect.new(80, 80, 944, 586)
}, v13)
local v16 = New("ImageLabel", {
    Name = "Banner",
    BorderSizePixel = 0,
    ClipsDescendants = true,
    Position = UDim2.fromOffset(44, 50),
    Size = UDim2.fromOffset(v1.X - 88, 112),
    BackgroundColor3 = Color3.fromRGB(14, 14, 16),
    ScaleType = Enum.ScaleType.Crop,
    ImageColor3 = Color3.fromRGB(200, 196, 192)
}, v15)

New("UIStroke", {
    Thickness = 2,
    Color = Color3.fromRGB(8, 8, 10),
    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
}, v16)

local v17 = New("Frame", {
    Name = "Shade",
    BorderSizePixel = 0,
    Size = UDim2.fromScale(1, 1),
    BackgroundColor3 = Color3.fromRGB(6, 6, 8)
}, v16)

New("UIGradient", {
    Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.12),
        NumberSequenceKeypoint.new(0.5, 0.55),
        NumberSequenceKeypoint.new(1, 0.25)
    })
}, v17)

local v18 = New("TextLabel", {
    Name = "Title",
    BackgroundTransparency = 1,
    TextSize = 46,
    Text = "",
    Position = UDim2.fromOffset(22, 12),
    Size = UDim2.new(1, -260, 0, 56),
    FontFace = v2,
    TextColor3 = v3,
    TextXAlignment = Enum.TextXAlignment.Left
}, v16)

New("UIStroke", {
    Thickness = 2.2,
    Transparency = 0.1,
    Color = Color3.fromRGB(0, 0, 0)
}, v18)

local v19 = New("TextLabel", {
    Name = "Subtitle",
    BackgroundTransparency = 1,
    TextSize = 16,
    Text = "",
    Position = UDim2.fromOffset(24, 70),
    Size = UDim2.new(1, -260, 0, 22),
    FontFace = BoldFont,
    TextColor3 = v4,
    TextXAlignment = Enum.TextXAlignment.Left
}, v16)

New("UIStroke", {
    Thickness = 1.4,
    Transparency = 0.2,
    Color = Color3.fromRGB(0, 0, 0)
}, v19)

local v20 = New("Frame", {
    Name = "Accent",
    BorderSizePixel = 0,
    AnchorPoint = Vector2.new(0, 1),
    Position = UDim2.new(0, 0, 1, 0),
    Size = UDim2.new(1, 0, 0, 3)
}, v16)
local v21 = New("Frame", {
    Name = "Balance",
    BackgroundTransparency = 0.12,
    BorderSizePixel = 0,
    AnchorPoint = Vector2.new(1, 0),
    Position = UDim2.new(1, -18, 0, 18),
    Size = UDim2.fromOffset(196, 58),
    BackgroundColor3 = Color3.fromRGB(16, 16, 19)
}, v16)

New("UIStroke", {
    Thickness = 1.2,
    Transparency = 0.35,
    Color = Color3.fromRGB(120, 122, 130),
    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
}, v21)
New("TextLabel", {
    BackgroundTransparency = 1,
    TextSize = 13,
    Text = "YOUR BALANCE",
    Position = UDim2.fromOffset(12, 5),
    Size = UDim2.new(1, -24, 0, 16),
    FontFace = BoldFont,
    TextColor3 = v4,
    TextXAlignment = Enum.TextXAlignment.Right
}, v21)

local v22 = New("TextLabel", {
    Name = "Amount",
    BackgroundTransparency = 1,
    TextSize = 26,
    Text = "",
    Position = UDim2.fromOffset(12, 20),
    Size = UDim2.new(1, -24, 0, 32),
    FontFace = Font.new("rbxasset://fonts/families/FredokaOne.json"),
    TextColor3 = Color3.new(1, 1, 1),
    TextXAlignment = Enum.TextXAlignment.Right
}, v21)

New("UIGradient", {
    Rotation = 90,
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 251, 168)),
        ColorSequenceKeypoint.new(0.45, Color3.fromRGB(255, 226, 64)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(226, 158, 20))
    })
}, v22)
New("UIStroke", {
    Thickness = 1.4,
    Color = Color3.fromRGB(58, 34, 8)
}, v22)

local v23 = GothicUI.Close(v13, UDim2.fromOffset(56, 56), {
    ZIndex = 10,
    Position = UDim2.fromOffset(22 + v1.X - 44, 2)
})
local v24 = New("ScrollingFrame", {
    Name = "Items",
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    ScrollBarThickness = 5,
    Position = UDim2.fromOffset(44, 176),
    Size = UDim2.fromOffset(v1.X - 88, v1.Y - 176 - 44 - 46),
    ScrollBarImageColor3 = Color3.fromRGB(150, 152, 160),
    CanvasSize = UDim2.new(),
    AutomaticCanvasSize = Enum.AutomaticSize.Y,
    ScrollingDirection = Enum.ScrollingDirection.Y
}, v15)

New("UIGridLayout", {
    CellSize = UDim2.fromOffset(186, 204),
    CellPadding = UDim2.fromOffset(12, 12),
    SortOrder = Enum.SortOrder.LayoutOrder,
    HorizontalAlignment = Enum.HorizontalAlignment.Center
}, v24)
New("UIPadding", {
    PaddingTop = UDim.new(0, 4),
    PaddingBottom = UDim.new(0, 6),
    PaddingRight = UDim.new(0, 6)
}, v24)

local v25 = New("Frame", {
    Name = "Message",
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    AnchorPoint = Vector2.new(0.5, 1),
    Position = UDim2.new(0.5, 0, 1, -48),
    Size = UDim2.fromOffset(v1.X - 88 - 60, 34),
    BackgroundColor3 = Color3.fromRGB(30, 30, 34)
}, v15)
local v26 = New("UIStroke", {
    Thickness = 1.2,
    Transparency = 1,
    Color = v7,
    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
}, v25)
local v27 = New("TextLabel", {
    BackgroundTransparency = 1,
    TextSize = 17,
    TextTransparency = 1,
    Text = "",
    Size = UDim2.fromScale(1, 1),
    FontFace = BoldFont,
    TextColor3 = v3,
    TextTruncate = Enum.TextTruncate.AtEnd
}, v25)

New("UIStroke", {
    Thickness = 1.2,
    Transparency = 0.3,
    Color = Color3.fromRGB(0, 0, 0)
}, v27)

local n1 = 0

local function say(p2, p3) -- line: 258
    -- upvalues: TweenService (copy), v3 (copy), v4 (copy), v25 (copy), v26 (copy), v27 (copy), n1 (ref)
    n1 += 1

    local v28 = n1

    v27.Text = p2
    v27.TextColor3 = p3 or v3
    v27.TextTransparency = 0
    v25.BackgroundTransparency = 0.05
    v26.Color = p3 or v4
    v26.Transparency = 0.2
    task.delay(3.5, function() -- line: 267
        -- upvalues: v28 (copy), TweenService (copy), v25 (copy), v26 (copy), v27 (copy), n1 (ref)
        if v28 ~= n1 then
            return
        end

        local tween = TweenService:Create(v27, TweenInfo.new(0.5), {
            TextTransparency = 1
        })

        tween.Completed:Connect(function() -- line: 270
            -- upvalues: v28 (copy), v27 (copy), n1 (ref)
            if v28 == n1 then
                v27.Text = ""
            end
        end)
        tween:Play()
        TweenService:Create(v25, TweenInfo.new(0.5), {
            BackgroundTransparency = 1
        }):Play()
        TweenService:Create(v26, TweenInfo.new(0.5), {
            Transparency = 1
        }):Play()
    end)
end

local t5 = {}

t1[1] = t2.Normal.Accent

local v29 = BoxingConfig.Currency and BoxingConfig.Currency.Symbol or "¥"

local function money(p4) -- line: 287
    -- upvalues: v29 (copy)
    local v32 = tostring((math.floor(p4 + 0.5))):reverse():gsub("(%d%d%d)", "%1,"):reverse()

    if v32:sub(1, 1) == "," then
        v32 = v32:sub(2)
    end

    return v29 .. v32
end

local function ownedSet(p5) -- line: 296
    -- upvalues: HttpService (copy), LocalPlayer (copy)
    local t6 = {}
    local JSONDecode = HttpService.JSONDecode
    local v33 = LocalPlayer:GetAttribute(p5) or "[]"
    local ok, result = pcall(JSONDecode, HttpService, v33)

    if ok and type(result) == "table" then
        for _, v34 in result do
            t6[v34] = true
        end
    end

    return t6
end

local function cash() -- line: 307
    -- upvalues: LocalPlayer (copy)
    return tonumber(LocalPlayer:GetAttribute("Cash")) or 0
end

local function owned(p6) -- line: 312
    -- upvalues: HttpService (copy), LocalPlayer (copy)
    local JSONDecode = HttpService.JSONDecode
    local v35 = LocalPlayer:GetAttribute("Items") or "{}"
    local ok, result = pcall(JSONDecode, HttpService, v35)

    if not ok or type(result) ~= "table" then
        return 0
    end

    return tonumber(result[p6]) or 0
end

local function setBuy(p7, p8) -- line: 318
    -- upvalues: v3 (copy)
    if p7.State == p8 then
        return
    end

    p7.State = p8

    local Buy, BuyText = p7.Buy, p7.BuyText

    if p8 == "Buy" then
        Buy.ImageColor3 = Color3.fromRGB(235, 228, 228)
        BuyText.Text = "BUY"
        BuyText.TextColor3 = v3
    elseif p8 == "Owned" then
        Buy.ImageColor3 = Color3.fromRGB(92, 92, 98)
        BuyText.Text = "OWNED"
        BuyText.TextColor3 = Color3.fromRGB(200, 200, 206)
    else
        Buy.ImageColor3 = Color3.fromRGB(110, 96, 96)
        BuyText.Text = "BUY"
        BuyText.TextColor3 = Color3.fromRGB(170, 160, 160)
    end
end

local function refreshCards() -- line: 339
    -- upvalues: HttpService (copy), LocalPlayer (copy), v4 (copy), v5 (copy), v6 (copy), v22 (copy), t5 (copy), money (copy), ownedSet (copy), setBuy (copy)
    v22.Text = money(tonumber(LocalPlayer:GetAttribute("Cash")) or 0)

    local OwnedClothes = ownedSet("OwnedClothes")
    local OwnedAccessories = ownedSet("OwnedAccessories")

    for _, v37 in t5 do
        local v38 = (tonumber(LocalPlayer:GetAttribute("Cash")) or 0) + 1E-06 >= v37.Price

        if v37.Kind == "Clothes" or v37.Kind == "Accessory" then
            local v39 = if v37.Kind == "Clothes" then OwnedClothes[v37.Name] else OwnedAccessories[v37.Name]

            setBuy(v37, if v39 then "Owned" elseif v38 then "Buy" else "Poor")

            local PriceLabel = v37.PriceLabel

            if v39 then
                PriceLabel.TextColor3 = v4
            elseif v38 then
                PriceLabel.TextColor3 = v5
            else
                PriceLabel.TextColor3 = v6
            end

            v37.Owned.Text = v39 and "OWNED" or ""
        else
            setBuy(v37, v38 and "Buy" or "Poor")

            local PriceLabel = v37.PriceLabel

            if v38 then
                PriceLabel.TextColor3 = v5
            else
                PriceLabel.TextColor3 = v6
            end

            local Name = v37.Name
            local JSONDecode = HttpService.JSONDecode
            local v40 = LocalPlayer:GetAttribute("Items") or "{}"
            local ok, result = pcall(JSONDecode, HttpService, v40)
            local v41 = ok and type(result) == "table" and tonumber(result[Name]) or 0
            local Owned = v37.Owned

            if v41 > 0 then
                Owned.Text = "x" .. v41 .. " OWNED"
            else
                Owned.Text = ""
            end
        end
    end
end

local function effectRow(p9, p10, p11) -- line: 359
    -- upvalues: SurvivalArt (copy), New (copy), BoldFont (copy)
    local v43 = New("Frame", {
        Name = "Effects",
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(10, p11),
        Size = UDim2.new(1, -20, 0, 16)
    }, p9)

    New("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        Padding = UDim.new(0, 4),
        SortOrder = Enum.SortOrder.LayoutOrder
    }, v43)

    local n2 = 0

    for _, v44 in { "Energy", "Hunger", "Thirst" } do
        local v45 = p10[v44] or 0

        if v45 ~= 0 then
            local v46 = n2 + 1
            local v47 = SurvivalArt.Size("Icon" .. v44)
            local v48 = 14 / v47.Y
            local v50 = New("ImageLabel", {
                BackgroundTransparency = 1,
                Size = UDim2.fromOffset(math.floor(v47.X * v48 + 0.5), 14),
                LayoutOrder = v46
            }, v43)

            SurvivalArt.Apply(v50, "Icon" .. v44)
            n2 = v46 + 1
            New("TextLabel", {
                BackgroundTransparency = 1,
                TextSize = 14,
                AutomaticSize = Enum.AutomaticSize.X,
                Size = UDim2.fromOffset(0, 16),
                FontFace = BoldFont,
                TextColor3 = Color3.fromRGB(214, 214, 220),
                Text = "+" .. v45,
                LayoutOrder = n2
            }, v43)
        end
    end
end

local v51 = false

local function buy(p12) -- line: 402
    -- upvalues: TweenService (copy), LocalPlayer (copy), SurvivalRemote (copy), v3 (copy), v4 (copy), v6 (copy), t4 (ref), v25 (copy), v26 (copy), v27 (copy), n1 (ref), money (copy), v51 (ref)
    local v52 = v51

    if not v52 and t4 then
        if p12.State == "Owned" then
            local v53 = "You already own " .. (p12.Label or p12.Name) .. " - wear it from your Backpack (M)"

            n1 += 1

            local v54 = n1

            v27.Text = v53
            v27.TextColor3 = v4 or v3
            v27.TextTransparency = 0
            v25.BackgroundTransparency = 0.05
            v26.Color = v4 or v4
            v26.Transparency = 0.2
            task.delay(3.5, function() -- line: 267
                -- upvalues: v54 (copy), TweenService (copy), v25 (copy), v26 (copy), v27 (copy), n1 (ref)
                if v54 ~= n1 then
                    return
                end

                local tween = TweenService:Create(v27, TweenInfo.new(0.5), {
                    TextTransparency = 1
                })

                tween.Completed:Connect(function() -- line: 270
                    -- upvalues: v54 (copy), v27 (copy), n1 (ref)
                    if v54 == n1 then
                        v27.Text = ""
                    end
                end)
                tween:Play()
                TweenService:Create(v25, TweenInfo.new(0.5), {
                    BackgroundTransparency = 1
                }):Play()
                TweenService:Create(v26, TweenInfo.new(0.5), {
                    Transparency = 1
                }):Play()
            end)
        elseif (tonumber(LocalPlayer:GetAttribute("Cash")) or 0) + 1E-06 < p12.Price then
            local v55 = string.format("Not enough money - %s costs %s, you have %s", p12.Label or p12.Name, money(p12.Price), (money(tonumber(LocalPlayer:GetAttribute("Cash")) or 0)))

            n1 += 1

            local v56 = n1

            v27.Text = v55
            v27.TextColor3 = v6 or v3
            v27.TextTransparency = 0
            v25.BackgroundTransparency = 0.05
            v26.Color = v6 or v4
            v26.Transparency = 0.2
            task.delay(3.5, function() -- line: 267
                -- upvalues: v56 (copy), TweenService (copy), v25 (copy), v26 (copy), v27 (copy), n1 (ref)
                if v56 ~= n1 then
                    return
                end

                local tween = TweenService:Create(v27, TweenInfo.new(0.5), {
                    TextTransparency = 1
                })

                tween.Completed:Connect(function() -- line: 270
                    -- upvalues: v56 (copy), v27 (copy), n1 (ref)
                    if v56 == n1 then
                        v27.Text = ""
                    end
                end)
                tween:Play()
                TweenService:Create(v25, TweenInfo.new(0.5), {
                    BackgroundTransparency = 1
                }):Play()
                TweenService:Create(v26, TweenInfo.new(0.5), {
                    Transparency = 1
                }):Play()
            end)
        else
            v51 = true
            SurvivalRemote:FireServer("Buy", t4.Id, p12.Name)
            task.delay(0.3, function() -- line: 416
                -- upvalues: v51 (ref)
                v51 = false
            end)
        end
    end
end

local function makeCard(p13, p14, p15, p16, p17) -- line: 422
    -- upvalues: TweenService (copy), GothicUI (copy), New (copy), Images (copy), v2 (copy), BoldFont (copy), v3 (copy), v5 (copy), v7 (copy), Quick (copy), v24 (copy), t5 (copy), t1 (copy), money (copy), buy (copy)
    local v57 = New("ImageButton", {
        BackgroundTransparency = 1,
        AutoButtonColor = false,
        SliceScale = 0.3,
        Name = p14,
        LayoutOrder = p13,
        Image = Images.ShopCard,
        ImageColor3 = Color3.fromRGB(205, 205, 212),
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(64, 64, 621, 960)
    }, v24)
    local v58 = New("UIStroke", {
        Thickness = 1.5,
        Transparency = 1,
        Color = t1[1],
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    }, v57)
    local v59 = New("Frame", {
        Name = "Picture",
        BackgroundTransparency = 1,
        ClipsDescendants = true,
        AnchorPoint = Vector2.new(0.5, 0),
        Position = UDim2.new(0.5, 0, 0, 12),
        Size = UDim2.fromOffset(98, 92)
    }, v57)

    if p17 then
        p17.Parent = v59
    end

    local v60 = New("TextLabel", {
        Name = "Owned",
        BackgroundTransparency = 1,
        TextSize = 12,
        Text = "",
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, -12, 0, 10),
        Size = UDim2.fromOffset(90, 14),
        FontFace = BoldFont,
        TextColor3 = v7,
        TextXAlignment = Enum.TextXAlignment.Right
    }, v57)

    New("UIStroke", {
        Thickness = 1,
        Transparency = 0.3,
        Color = Color3.fromRGB(0, 0, 0)
    }, v60)

    local v61 = New("TextLabel", {
        Name = "ItemName",
        BackgroundTransparency = 1,
        TextSize = 19,
        TextScaled = true,
        Position = UDim2.fromOffset(10, 106),
        Size = UDim2.new(1, -20, 0, 24),
        FontFace = v2,
        TextColor3 = v3,
        Text = string.upper(p15)
    }, v57)

    New("UITextSizeConstraint", {
        MaxTextSize = 19,
        MinTextSize = 11
    }, v61)
    New("UIStroke", {
        Thickness = 1.2,
        Transparency = 0.2,
        Color = Color3.fromRGB(0, 0, 0)
    }, v61)

    local v62 = New("TextLabel", {
        Name = "Price",
        BackgroundTransparency = 1,
        TextSize = 21,
        AnchorPoint = Vector2.new(0, 1),
        Position = UDim2.new(0, 14, 1, -14),
        Size = UDim2.fromOffset(70, 28),
        FontFace = v2,
        TextColor3 = v5,
        TextXAlignment = Enum.TextXAlignment.Left,
        Text = money(p16)
    }, v57)

    New("UIStroke", {
        Thickness = 1.3,
        Transparency = 0.15,
        Color = Color3.fromRGB(0, 0, 0)
    }, v62)

    local v63 = New("ImageButton", {
        Name = "Buy",
        BackgroundTransparency = 1,
        AutoButtonColor = false,
        AnchorPoint = Vector2.new(1, 1),
        Position = UDim2.new(1, -12, 1, -12),
        Size = UDim2.fromOffset(88, 30),
        Image = Images.ShopBuy,
        ScaleType = Enum.ScaleType.Stretch
    }, v57)
    local v64 = New("UIScale", {}, v63)
    local v65 = New("TextLabel", {
        BackgroundTransparency = 1,
        TextSize = 17,
        Text = "BUY",
        Size = UDim2.fromScale(1, 1),
        FontFace = v2,
        TextColor3 = v3
    }, v63)

    New("UIStroke", {
        Thickness = 1.3,
        Transparency = 0.1,
        Color = Color3.fromRGB(30, 4, 4)
    }, v65)

    local v66 = New("UIScale", {}, v57)

    v57.MouseEnter:Connect(function() -- line: 507
        -- upvalues: v57 (copy), v58 (copy), v66 (copy), TweenService (copy), Quick (copy)
        TweenService:Create(v66, Quick, {
            Scale = 1.025
        }):Play()
        TweenService:Create(v58, Quick, {
            Transparency = 0.25
        }):Play()
        TweenService:Create(v57, Quick, {
            ImageColor3 = Color3.fromRGB(240, 240, 245)
        }):Play()
    end)
    v57.MouseLeave:Connect(function() -- line: 512
        -- upvalues: v57 (copy), v58 (copy), v66 (copy), TweenService (copy), Quick (copy)
        TweenService:Create(v66, Quick, {
            Scale = 1
        }):Play()
        TweenService:Create(v58, Quick, {
            Transparency = 1
        }):Play()
        TweenService:Create(v57, Quick, {
            ImageColor3 = Color3.fromRGB(205, 205, 212)
        }):Play()
    end)
    v63.MouseButton1Down:Connect(function() -- line: 517
        -- upvalues: v64 (copy), TweenService (copy), Quick (copy)
        TweenService:Create(v64, Quick, {
            Scale = 0.94
        }):Play()
    end)
    v63.MouseButton1Up:Connect(function() -- line: 520
        -- upvalues: v64 (copy), TweenService (copy), Quick (copy)
        TweenService:Create(v64, Quick, {
            Scale = 1
        }):Play()
    end)
    v63.MouseLeave:Connect(function() -- line: 523
        -- upvalues: v64 (copy), TweenService (copy), Quick (copy)
        TweenService:Create(v64, Quick, {
            Scale = 1
        }):Play()
    end)

    local t8 = {
        Name = p14,
        Label = p15,
        Price = p16,
        Card = v57,
        Buy = v63,
        BuyText = v65,
        PriceLabel = v62,
        Owned = v60,
        Glow = v58
    }

    v63.Activated:Connect(function() -- line: 527
        -- upvalues: t8 (copy), GothicUI (copy), buy (copy)
        GothicUI.Click()
        buy(t8)
    end)
    table.insert(t5, t8)

    return v57, t8
end

local function buildClothesCards() -- line: 536
    -- upvalues: BoxingConfig (copy), ItemPictures (copy), New (copy), BoldFont (copy), v4 (copy), refreshCards (copy), makeCard (copy)
    local t9 = {}

    for _, v67 in BoxingConfig.Clothes.List do
        table.insert(t9, {
            Kind = "Clothes",
            Item = v67
        })
    end

    for _, v68 in BoxingConfig.Accessories or {} do
        if v68.Price then
            table.insert(t9, {
                Kind = "Accessory",
                Item = v68
            })
        end
    end

    local t12 = {
        ["Ippo Makunouchi"] = 1,
        Takamura = 2,
        Kimura = 3,
        Miyata = 4,
        Martinez = 5,
        Suits = 6,
        Casual = 7,
        ["Kamogawa Gym"] = 8
    }
    local t13 = {
        Shirt = 1,
        Pants = 2
    }

    table.sort(t9, function(p18, p19) -- line: 549
        -- upvalues: t12 (copy), t13 (copy)
        local v69 = t12[p18.Item.Section or ""] or 99
        local v70 = t12[p19.Item.Section or ""] or 99

        if v69 ~= v70 then
            return v69 < v70
        end

        local v71 = t13[p18.Item.Kind or ""] or 9
        local v72 = t13[p19.Item.Kind or ""] or 9

        if v71 == v72 then
            return p18.Item.Name < p19.Item.Name
        end

        return v71 < v72
    end)

    for v73, v74 in t9 do
        local Item = v74.Item
        local v75 = if v74.Kind == "Clothes" then ItemPictures.Clothes(Item) else New("ImageLabel", {
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 1),
            ScaleType = Enum.ScaleType.Fit,
            Image = string.format("rbxthumb://type=Asset&id=%d&w=150&h=150", Item.Asset or 0)
        })
        local v76, v77 = makeCard(v73, Item.Id, Item.Name, Item.Price or 0, v75)

        v77.Kind = v74.Kind
        New("TextLabel", {
            Name = "Section",
            BackgroundTransparency = 1,
            TextSize = 13,
            Position = UDim2.fromOffset(10, 130),
            Size = UDim2.new(1, -20, 0, 16),
            FontFace = BoldFont,
            TextColor3 = v4,
            Text = string.upper((Item.Section or v74.Kind) .. "  ·  " .. (if Item.Kind == "Shirt" then "Top" elseif Item.Kind == "Pants" then "Bottom" else "Accessory"))
        }, v76)
    end

    refreshCards()
end

local function buildCards(p20) -- line: 586
    -- upvalues: ItemPictures (copy), New (copy), Shops (copy), Foods (copy), BoldFont (copy), v7 (copy), t5 (copy), refreshCards (copy), effectRow (copy), makeCard (copy), buildClothesCards (copy)
    for _, v78 in t5 do
        v78.Card:Destroy()
    end

    table.clear(t5)

    local v79 = Shops.List[p20]

    if v79.Clothes then
        buildClothesCards()
    else
        for v80, v81 in v79.Items do
            local v82 = v81[1]
            local v83 = v81[2]
            local v84 = Foods[v82] or {}
            local v86 = makeCard(v80, v82, v82, v83, ItemPictures.Food(v82) or New("ImageLabel", {
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(1, 1),
                Image = string.format("rbxthumb://type=Asset&id=%d&w=150&h=150", v84.Asset or 0)
            }))

            effectRow(v86, v84, 130)

            local v87 = v84.Stamina or 0

            if v87 ~= 0 then
                New("TextLabel", {
                    Name = "StaminaStat",
                    BackgroundTransparency = 1,
                    TextSize = 12,
                    Position = UDim2.fromOffset(10, 147),
                    Size = UDim2.new(1, -20, 0, 14),
                    FontFace = BoldFont,
                    TextColor3 = if v87 > 0 then v7 else Color3.fromRGB(240, 140, 130),
                    Text = string.format("STAMINA STAT %s%s", v87 > 0 and "+" or "-", (string.gsub(string.format("%.3f", (math.abs(v87))), "0$", "")))
                }, v86)
            end
        end

        refreshCards()
    end
end

local v88 = v1.Y

local function fitHeight() -- line: 627
    -- upvalues: v1 (copy), v13 (copy), v15 (copy), v24 (copy), t5 (copy), v88 (ref)
    local v91 = math.max(1, (math.floor((v1.X - 88 - 6 + 12) / 198)))

    v88 = math.clamp(math.max(1, (math.ceil(#t5 / v91))) * 216 + 176 + 10 + 46 + 44, 470, v1.Y)
    v13.Size = UDim2.fromOffset(v1.X + 44, v88 + 44)
    v15.Size = UDim2.fromOffset(v1.X, v88)
    v24.Size = UDim2.fromOffset(v1.X - 88, v88 - 176 - 44 - 46)
end

local v95

local function playOpenSound() -- line: 641
    -- upvalues: SoundService (copy), BoxingConfig (copy), New (copy), v95 (ref)
    local v96 = BoxingConfig.UISounds or {}

    if v96.StatsOpen then
        if not (v95 and v95.Parent) then
            v95 = New("Sound", {
                Name = "UI_ShopOpen",
                SoundId = v96.StatsOpen,
                Volume = v96.Volume or 0.6,
                SoundGroup = SoundService:FindFirstChild("BoxingUI")
            }, SoundService)
        end

        v95.TimePosition = 0
        v95:Play()
    end
end

local function fitScale() -- line: 658
    -- upvalues: GuiService (copy), v1 (copy), v13 (copy), v88 (ref)
    local ViewportSize = workspace.CurrentCamera.ViewportSize
    local Y = GuiService:GetGuiInset().Y

    if ViewportSize.Y < 500 then
        local v97 = GuiService.TopbarInset.Min.X + 8

        v13.Position = UDim2.fromOffset((v97 + ViewportSize.X - 8) / 2, ViewportSize.Y / 2)

        return (math.clamp(math.min((ViewportSize.Y - 12) / (v88 + 44), (ViewportSize.X - 8 - v97) / (v1.X + 44)), 0.35, 1.25))
    end

    v13.Position = UDim2.fromScale(0.5, 0.5)

    return (math.clamp(math.min((ViewportSize.Y - Y - 20) / (v88 + 44), (ViewportSize.X - 16) / (v1.X + 44), ViewportSize.Y / 820), 0.35, 1.25))
end

local function closeShop() -- line: 673
    -- upvalues: TweenService (copy), PlayerGui (copy), MenuState (copy), Fade (copy), t3 (copy), t4 (ref), v11 (copy), v12 (copy), v13 (copy), v14 (copy)
    if not t4 then
        return
    end

    t4 = nil
    MenuState.Close("CounterShop")

    local Scale = v14.Scale

    TweenService:Create(v12, Fade, {
        BackgroundTransparency = 1
    }):Play()
    TweenService:Create(v14, Fade, {
        Scale = Scale * 0.96
    }):Play()

    local tween = TweenService:Create(v13, Fade, {
        GroupTransparency = 1
    })

    tween.Completed:Connect(function() -- line: 683
        -- upvalues: t4 (ref), v11 (copy)
        if not t4 then
            v11.Enabled = false
        end
    end)
    tween:Play()

    local v105 = t4 == nil and next(t3) ~= nil and not MenuState.IsOpen()
    local v106 = PlayerGui:FindFirstChild("e to interact")

    if v106 then
        v106.Enabled = v105
    end
end

local function openShop(p21, p22) -- line: 692
    -- upvalues: TweenService (copy), PlayerGui (copy), MenuState (copy), Shops (copy), Fade (copy), t2 (copy), t3 (copy), t4 (ref), v11 (copy), v12 (copy), v13 (copy), v14 (copy), v16 (copy), v18 (copy), v19 (copy), v20 (copy), v24 (copy), v25 (copy), v26 (copy), v27 (copy), n1 (ref), t1 (copy), buildCards (copy), fitHeight (copy), playOpenSound (copy), fitScale (copy)
    local v107 = Shops.List[p21]
    local v108, v109

    if not v107 or t4 then
        v109 = true
    elseif MenuState.Open("CounterShop") then
        t4 = {
            Id = p21,
            Prompt = p22
        }
        playOpenSound()
        v108 = t2[p21] or t2.Normal
        v109 = false
    else
        v109 = true
    end

    if v109 then
        return
    end

    t1[1] = v108.Accent
    v16.Image = v108.Banner or ""
    v18.Text = string.upper(v107.Name)
    v19.Text = v108.Kana .. "   ·   " .. v108.Tag
    v20.BackgroundColor3 = t1[1]
    v24.ScrollBarImageColor3 = t1[1]:Lerp(Color3.fromRGB(160, 160, 166), 0.5)
    buildCards(p21)
    fitHeight()
    n1 += 1
    v27.Text = ""
    v27.TextTransparency = 1
    v25.BackgroundTransparency = 1
    v26.Transparency = 1
    v24.CanvasPosition = Vector2.zero

    local v110 = fitScale()

    v14.Scale = v110 * 0.96
    v13.GroupTransparency = 1
    v11.Enabled = true
    TweenService:Create(v12, Fade, {
        BackgroundTransparency = 0.45
    }):Play()
    TweenService:Create(v13, Fade, {
        GroupTransparency = 0
    }):Play()
    TweenService:Create(v14, Fade, {
        Scale = v110
    }):Play()

    local v111 = t4 == nil and next(t3) ~= nil and not MenuState.IsOpen()
    local v112 = PlayerGui:FindFirstChild("e to interact")

    if v112 then
        v112.Enabled = v111
    end
end

v23.Activated:Connect(closeShop)

local n3 = 0

UserInputService.InputBegan:Connect(function(p23) -- line: 726
    -- upvalues: t4 (ref), closeShop (copy), n3 (ref)
    if (p23.KeyCode == Enum.KeyCode.Escape or p23.KeyCode == Enum.KeyCode.ButtonB and os.clock() - n3 > 0.3) and t4 then
        n3 = os.clock()
        closeShop()
    end
end)
workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function() -- line: 732
    -- upvalues: t4 (ref), v14 (copy), fitScale (copy)
    if t4 then
        v14.Scale = fitScale()
    end
end)
ProximityPromptService.PromptShown:Connect(function(p24) -- line: 738
    -- upvalues: PlayerGui (copy), MenuState (copy), t3 (copy), t4 (ref)
    if not p24:GetAttribute("ShopId") and not p24:GetAttribute("DoorPrompt") and not p24:GetAttribute("Interact") then
        return
    end

    t3[p24] = true

    local v113 = t4 == nil and next(t3) ~= nil and not MenuState.IsOpen()
    local v114 = PlayerGui:FindFirstChild("e to interact")

    if v114 then
        v114.Enabled = v113
    end
end)
ProximityPromptService.PromptHidden:Connect(function(p25) -- line: 746
    -- upvalues: PlayerGui (copy), MenuState (copy), t3 (copy), t4 (ref), closeShop (copy)
    if t3[p25] then
        t3[p25] = nil

        if t4 and t4.Prompt == p25 then
            closeShop()
        end

        local v115 = t4 == nil and next(t3) ~= nil and not MenuState.IsOpen()
        local v116 = PlayerGui:FindFirstChild("e to interact")

        if v116 then
            v116.Enabled = v115
        end
    end
end)
ProximityPromptService.PromptTriggered:Connect(function(p26, p27) -- line: 755
    -- upvalues: LocalPlayer (copy), t4 (ref), closeShop (copy), openShop (copy), n3 (ref)
    local ShopId = p26:GetAttribute("ShopId")

    if ShopId and (not p27 or p27 == LocalPlayer) and not (os.clock() - n3 < 0.3) then
        n3 = os.clock()

        if t4 then
            closeShop()
        else
            openShop(ShopId, p26)
        end
    end
end)
SurvivalRemote.OnClientEvent:Connect(function(p28, p29, p30, p31) -- line: 772
    -- upvalues: TweenService (copy), New (copy), v3 (copy), v4 (copy), v6 (copy), v7 (copy), t4 (ref), v25 (copy), v26 (copy), v27 (copy), n1 (ref), t5 (copy), refreshCards (copy)
    if p28 ~= "BuyResult" or not t4 then
        return
    end

    local v117 = (if p29 then "✔  " else "") .. (p30 or "")
    local v118 = if p29 then v7 else v6

    n1 += 1

    local v119 = n1

    v27.Text = v117
    v27.TextColor3 = v118 or v3
    v27.TextTransparency = 0
    v25.BackgroundTransparency = 0.05
    v26.Color = v118 or v4
    v26.Transparency = 0.2
    task.delay(3.5, function() -- line: 267
        -- upvalues: v119 (copy), TweenService (copy), v25 (copy), v26 (copy), v27 (copy), n1 (ref)
        if v119 ~= n1 then
            return
        end

        local tween = TweenService:Create(v27, TweenInfo.new(0.5), {
            TextTransparency = 1
        })

        tween.Completed:Connect(function() -- line: 270
            -- upvalues: v119 (copy), v27 (copy), n1 (ref)
            if v119 == n1 then
                v27.Text = ""
            end
        end)
        tween:Play()
        TweenService:Create(v25, TweenInfo.new(0.5), {
            BackgroundTransparency = 1
        }):Play()
        TweenService:Create(v26, TweenInfo.new(0.5), {
            Transparency = 1
        }):Play()
    end)

    if p29 then
        for _, v120 in t5 do
            if v120.Name == p31 then
                local v121 = New("Frame", {
                    BackgroundTransparency = 0.7,
                    BorderSizePixel = 0,
                    ZIndex = 8,
                    Size = UDim2.fromScale(1, 1),
                    BackgroundColor3 = Color3.new(1, 1, 1)
                }, v120.Card)

                TweenService:Create(v121, TweenInfo.new(0.35), {
                    BackgroundTransparency = 1
                }):Play()
                task.delay(0.4, function() -- line: 788
                    -- upvalues: v121 (copy)
                    v121:Destroy()
                end)
            end
        end
    end

    task.defer(refreshCards)
end)

for _, v122 in { "Cash", "OwnedClothes", "OwnedAccessories", "Items" } do
    LocalPlayer:GetAttributeChangedSignal(v122):Connect(function() -- line: 799
        -- upvalues: t4 (ref), refreshCards (copy)
        if t4 then
            refreshCards()
        end
    end)
end

MenuState.Changed:Connect(refreshInteract)
LocalPlayer.CharacterAdded:Connect(function() -- line: 808
    -- upvalues: t3 (copy), refreshInteract (copy), closeShop (copy)
    closeShop()
    table.clear(t3)
    task.defer(refreshInteract)
end)
task.spawn(function() -- line: 815
    -- upvalues: New (copy), Images (copy)
    local ContentProvider = game:GetService("ContentProvider")
    local t16 = {}

    for _, v123 in { "ShopFrame", "ShopCard", "ShopBuy", "ShopBannerNormal", "ShopBannerNoodles", "ShopBannerBakery", "ShopBannerClothes" } do
        if Images[v123] then
            table.insert(t16, New("ImageLabel", {
                Image = Images[v123]
            }))
        end
    end

    local PreloadAsync = ContentProvider.PreloadAsync

    pcall(PreloadAsync, ContentProvider, t16)
end)
v11.Parent = PlayerGui
