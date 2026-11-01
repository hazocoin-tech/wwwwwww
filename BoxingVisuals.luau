-- https://lua.expert

local v1

local function PQ(p1) -- line: 4
    -- upvalues: v1 (ref)
    if type(p1) ~= "number" then
        return p1
    end

    if v1 == nil then
        v1 = false

        local v2

        if game:GetService("RunService"):IsClient() then
            local _require = require
            local Boxing = game:GetService("ReplicatedStorage"):WaitForChild("Boxing")
            local ok, result = pcall(_require, Boxing:WaitForChild("BoxingSettings"))

            v2 = ok and result or false
            v1 = v2
        end
    end

    local v4 = v1 and tonumber(v1.Get("ParticleAmount")) or 100

    if v4 >= 100 or p1 <= 1 then
        return p1
    end

    return (math.max(1, (math.round(p1 * v4 / 100))))
end

local CollectionService = game:GetService("CollectionService")
local ContentProvider = game:GetService("ContentProvider")
local Debris = game:GetService("Debris")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Parent = script.Parent
local BoxingConfig = require(Parent:WaitForChild("BoxingConfig"))
local BoxingPoses = require(Parent:WaitForChild("BoxingPoses"))
local BoxingKnockback = require(Parent:WaitForChild("BoxingKnockback"))
local BoxingCamera = require(Parent:WaitForChild("BoxingCamera"))
local BoxingVFX = require(Parent:WaitForChild("BoxingVFX"))
local BoxingScreen = require(Parent:WaitForChild("BoxingScreen"))
local BoxingSettings = require(Parent:WaitForChild("BoxingSettings"))
local BoxingHitDetection = require(Parent:WaitForChild("BoxingHitDetection"))
local RingRopes = require(Parent:WaitForChild("RingRopes"))
local BoxingShotgunFX = require(script.Parent:WaitForChild("BoxingShotgunFX"))
local BoxingStatEffects = require(Parent:WaitForChild("BoxingStatEffects"))
local BoxingPassives = require(Parent:WaitForChild("BoxingPassives"))
local _ = BoxingPassives.Values.HeadSlip
local BoxingRemote = Parent:WaitForChild("BoxingRemote")
local Stance = BoxingConfig.Animations and BoxingConfig.Animations.Stance or ""
local self = setmetatable({}, {
    __mode = "k"
})
local Block = BoxingConfig.Animations and BoxingConfig.Animations.Block or ""
local HeadGuardLift = BoxingConfig.Animations and BoxingConfig.Animations.HeadGuardLift or 0
local _ = {
    LeadPitch = 62,
    LeadAcross = 18,
    LeadDrop = 0.25,
    RearLift = 0.12,
    ParryTime = 0.28,
    ParrySwing = 70
}
local t3 = {}
local v9 = setmetatable(t3, {
    __mode = "k"
})
local Move = BoxingConfig.Animations and BoxingConfig.Animations.Move or {}
local v8 = (Move.Forward or "") ~= "" or (Move.Backward or "") ~= "" or (Move.Left or "") ~= "" or (Move.Right or "") ~= ""
local t4 = {
    "Forward",
    "Backward",
    "Left",
    "Right"
}
local Weave = BoxingConfig.Weave
local Animation = Weave and Weave.Animation or ""
local v10
local v11 = Color3.fromRGB(255, 214, 140)
local v12 = Color3.fromRGB(110, 170, 255)
local LocalPlayer = Players.LocalPlayer
local v13 = false
local v14 = "Body"
local t5 = {}
local t6 = {}

do
    local function swapSide(p2) -- line: 94
        if type(p2) == "string" then
            return (p2:gsub("Left", "#L#"):gsub("Right", "Left"):gsub("#L#", "Right"))
        end

        return p2
    end
end

do
    local function sideFor(p3, p4) -- line: 100
        -- upvalues: BoxingConfig (copy)
        if BoxingConfig.IsMirrored(p3) and type(p4) == "string" then
            return (p4:gsub("Left", "#L#"):gsub("Right", "Left"):gsub("#L#", "Right"))
        end

        return p4
    end
end

local v15 = Color3.fromRGB(255, 225, 90)
local v16 = BoxingConfig.Impact or {}

do
    local function ownsAnimations(p5) -- line: 112
        -- upvalues: Players (copy), LocalPlayer (copy)
        if p5 == nil then
            return false
        end

        if p5 == LocalPlayer.Character then
            return true
        end

        return Players:GetPlayerFromCharacter(p5) == nil
    end
end

local self2 = setmetatable({}, {
    __mode = "k"
})
local self3 = setmetatable({}, {
    __mode = "k"
})

do
    local function setTrackSpeed(p6, p7) -- line: 121
        -- upvalues: self2 (copy), self3 (copy)
        self3[p6] = nil

        if self2[p6] ~= nil then
            self2[p6] = p7
        else
            p6:AdjustSpeed(p7)
        end
    end
end

local t11 = {}
local t12 = {}

for v19, v20 in BoxingConfig.BlockReactions and BoxingConfig.BlockReactions.Animations or {} do
    t11[v20] = true

    local v21 = if string.find(v19, "LeftArm") then "Left" elseif string.find(v19, "RightArm") then "Right" else nil

    t12[v20] = v21
end

local function freezeTracks(p8, p9) -- line: 140
    -- upvalues: Players (copy), LocalPlayer (copy), self2 (copy), self3 (copy), t11 (copy)
    if not (p9 <= 0) and p8 ~= nil and (p8 == LocalPlayer.Character or Players:GetPlayerFromCharacter(p8) == nil) then
        local Humanoid = p8:FindFirstChildOfClass("Humanoid")
        local Animator = Humanoid and Humanoid:FindFirstChildOfClass("Animator")

        if Animator then
            local t13 = {}

            for _, v22 in Animator:GetPlayingAnimationTracks() do
                if self2[v22] == nil and v22.Speed ~= 0 and (not v22.Animation or not t11[v22.Animation.AnimationId]) then
                    local v24 = self3[v22]

                    self2[v22] = if v24 then v24.Base else v22.Speed
                    self3[v22] = nil
                    v22:AdjustSpeed(0)
                    table.insert(t13, v22)
                end
            end

            if #t13 > 0 then
                task.delay(p9, function() -- line: 161
                    -- upvalues: p9 (copy), t13 (copy), self2 (copy), self3 (copy)
                    for _, v25 in t13 do
                        local v26 = self2[v25]

                        self2[v25] = nil

                        if v26 and v25.IsPlaying and v25.Speed == 0 then
                            if v25.Priority ~= Enum.AnimationPriority.Action4 or v25.Looped then
                                v25:AdjustSpeed(v26)
                            else
                                local t14 = {
                                    Base = v26
                                }

                                self3[v25] = t14
                                v25:AdjustSpeed(v26 * 2)
                                task.delay(p9, function() -- line: 173
                                    -- upvalues: v25 (copy), v26 (copy), t14 (copy), self2 (copy), self3 (copy)
                                    if self3[v25] == t14 then
                                        self3[v25] = nil

                                        if v25.IsPlaying and self2[v25] == nil and math.abs(v25.Speed - v26 * 2) < 0.001 then
                                            v25:AdjustSpeed(v26)
                                        end
                                    end
                                end)
                            end
                        end
                    end
                end)
            end
        end
    end
end

local function hitStopFor(p10, p11, p12, p13) -- line: 191
    -- upvalues: v16 (copy)
    local v28, v29

    if p10 then
        local v30 = (v16.HitStop or {})[p10.Anim]

        if v30 then
            v28 = v30
            v29 = true
        else
            v29 = false
        end
    else
        v29 = false
    end

    if not v29 then
        v28 = 0
    end

    if p11 then
        v28 *= v16.HitStopBlocked or 0.5
    elseif p12 then
        v28 *= v16.HitStopCounter or 1
    end

    if p13 then
        v28 = math.max(v28, v16.HitStopKnockdown or 0)
    end

    return v28
end

local t15 = {
    Pos = Vector3.new(1.45, 0.65, 0.15),
    Pitch = 115,
    Yaw = -60,
    Roll = 0
}

do
    local function isGuardBroken(p14) -- line: 207
        return (p14:GetAttribute("GuardBrokenUntil") or 0) > workspace:GetServerTimeNow()
    end
end

do
    local function guardZoneFor(p15) -- line: 212
        -- upvalues: LocalPlayer (copy), v14 (ref)
        if p15 == LocalPlayer.Character then
            return v14
        end

        return (p15:GetAttribute("GuardZone"))
    end
end

do
    local function guardPoseFor(p16) -- line: 216
        -- upvalues: BoxingPoses (copy), LocalPlayer (copy), v14 (ref)
        if (if p16 == LocalPlayer.Character then v14 else p16:GetAttribute("GuardZone")) == "Head" then
            return BoxingPoses.Block
        end

        return BoxingPoses.BodyBlock
    end
end

local function isBoxing(p17) -- line: 221
    -- upvalues: CollectionService (copy)
    local Tool = p17:FindFirstChildOfClass("Tool")
    local Humanoid = p17:FindFirstChildOfClass("Humanoid")

    return (Tool ~= nil and Tool:GetAttribute("BoxingTool") == true or CollectionService:HasTag(p17, "BoxingNPC")) and Humanoid ~= nil and Humanoid.Health > 0 and p17:GetAttribute("Downed") ~= true
end

local t16 = {
    { "Right", "Torso", "Right Shoulder" },
    { "Left", "Torso", "Left Shoulder" },
    { "RightHip", "Torso", "Right Hip" },
    { "LeftHip", "Torso", "Left Hip" },
    { "Neck", "Torso", "Neck" },
    { "Root", "HumanoidRootPart", "RootJoint" }
}

local function getRig(p18) -- line: 242
    -- upvalues: t5 (copy), t16 (copy)
    local v32 = t5[p18]

    if v32 then
        return v32
    end

    local Humanoid = p18:FindFirstChildOfClass("Humanoid")

    if not Humanoid then
        return nil
    end

    local t17 = {
        BlockBlend = 0,
        PlantBlend = 0,
        ExposedBlend = 0,
        Punch = nil,
        PunchStart = 0,
        PunchSpeed = 1,
        PunchZone = "Head",
        PunchJammed = false,
        PunchTrack = nil,
        PunchToken = 0,
        WalkPhase = 0,
        StanceTrack = nil,
        BlockTrack = nil,
        MoveTracks = nil,
        HeadBlend = 0,
        Humanoid = Humanoid,
        Original = {},
        Tracks = {},
        Phase = math.random() * 10
    }

    for _, v33 in t16 do
        local v34 = p18:FindFirstChild(v33[2])
        local v35 = v34 and v34:FindFirstChild(v33[3])

        if not v35 then
            return nil
        end

        t17[v33[1]] = v35
        t17.Original[v33[1]] = v35.C0
    end

    t5[p18] = t17

    return t17
end

local function removeStars(p19) -- line: 285
    if p19.Stars then
        p19.Stars:Destroy()
        p19.Stars = nil
    end
end

local function updateStars(p20, p21, p22) -- line: 293
    -- upvalues: v15 (copy)
    local Head = p20:FindFirstChild("Head")

    if not Head then
        return
    end

    if not p21.Stars then
        local Model = Instance.new("Model")

        Model.Name = "DazedStars"

        for i = 1, 3 do
            local Part = Instance.new("Part")

            Part.Name = "Star" .. i
            Part.Shape = Enum.PartType.Ball
            Part.Size = Vector3.new(0.35, 0.35, 0.35)
            Part.Material = Enum.Material.Neon
            Part.Color = v15
            Part.Anchored = true
            Part.CanCollide = false
            Part.CanQuery = false
            Part.CanTouch = false
            Part.CastShadow = false
            Part.Parent = Model
        end

        Model.Parent = workspace
        p21.Stars = Model
    end

    local v36 = Head.Position + Vector3.new(0, 1.1, 0)

    for v37, child in p21.Stars:GetChildren() do
        local v38 = p22 * 5 + v37 * 3.141592653589793 * 2 / 3

        child.CFrame = CFrame.new(v36 + Vector3.new(math.cos(v38) * 0.9, math.sin(v38 * 2) * 0.12, math.sin(v38) * 0.9))
    end
end

local function startStance(p23, p24) -- line: 327
    -- upvalues: CollectionService (copy), BoxingConfig (copy), self (copy), LocalPlayer (copy)
    local v43 = BoxingConfig.StanceAnimations(p23).Stance or ""
    local StanceTrack = p24.StanceTrack

    if StanceTrack and not StanceTrack.IsPlaying and (p23 == LocalPlayer.Character or CollectionService:HasTag(p23, "BoxingNPC")) then
        p24.StanceStoppedAt = p24.StanceStoppedAt or os.clock()

        if os.clock() - p24.StanceStoppedAt >= 0.3 then
            p24.StanceStoppedAt = nil

            local Play = StanceTrack.Play

            pcall(Play, StanceTrack, 0.2)
        end
    elseif StanceTrack then
        p24.StanceStoppedAt = nil
    end

    if v43 ~= "" and not p24.StanceTrack and (p23 == LocalPlayer.Character or CollectionService:HasTag(p23, "BoxingNPC")) then
        local Animator = p24.Humanoid:FindFirstChildOfClass("Animator")

        if Animator then
            local Animation = Instance.new("Animation")

            Animation.AnimationId = v43

            local track = Animator:LoadAnimation(Animation)

            self[track] = p23
            track.Priority = Enum.AnimationPriority.Action
            track.Looped = true
            track:Play(0.2)
            p24.StanceTrack = track
        end
    end
end

local function stopStance(p25) -- line: 361
    if p25.StanceTrack then
        p25.StanceTrack:Stop(0.2)
        p25.StanceTrack = nil
    end

    if p25.BlockTrack then
        p25.BlockTrack:Stop(0.1)
        p25.BlockTrack = nil
    end

    p25.BlockTrackId = nil

    if p25.MoveTracks then
        for _, v44 in p25.MoveTracks do
            v44:Stop(0.15)
        end

        p25.MoveTracks = nil
    end

    if p25.WeaveTracks then
        for _, v45 in p25.WeaveTracks do
            v45:Stop(0.1)
        end

        p25.WeaveTracks = nil
        p25.WeaveShown = nil
    end
end

local function updateWeaveTracks(p26, p27) -- line: 389
    -- upvalues: BoxingConfig (copy), BoxingStatEffects (copy), self (copy), Weave (copy), Animation (copy), v10 (ref), LocalPlayer (copy), v13 (ref)
    local v46, v47

    if Animation == "" then
        v47 = true
    elseif p26 == LocalPlayer.Character then
        v46 = v10 or false

        if v46 and BoxingConfig.IsMirrored(p26) and type(v46) == "string" then
            v46 = v46:gsub("Left", "#L#"):gsub("Right", "Left"):gsub("#L#", "Right")
        end

        v47 = false
    else
        v47 = true
    end

    if v47 or p27.WeaveShown == v46 then
        return
    end

    if not p27.WeaveTracks then
        local Animator = p27.Humanoid:FindFirstChildOfClass("Animator")

        if not Animator then
            return
        end

        p27.WeaveTracks = {}

        for v48 in Weave.Poses do
            local Animation2 = Instance.new("Animation")

            Animation2.AnimationId = Animation

            local track = Animator:LoadAnimation(Animation2)

            self[track] = p26
            track.Priority = Enum.AnimationPriority.Action3
            track.Looped = false
            p27.WeaveTracks[v48] = track
        end
    end

    p27.WeaveShown = v46

    for v49, v50 in p27.WeaveTracks do
        if not v50.IsPlaying then
            v50:Play(0, 0.001)
        end

        v50:AdjustSpeed(0)
        v50.TimePosition = Weave.Poses[v49]

        local v51 = (Weave.BlendTime or 0.12) * (if v13 then 1.25 else 1) * BoxingStatEffects.WeaveTimeMultiplier(p26)

        v50:AdjustWeight(v49 == v46 and 1 or 0.001, v51)
    end
end

function t6.SetLocalWeave(p28) -- line: 430
    -- upvalues: v10 (ref)
    v10 = p28
end

local function updateMoveTracks(p29, p30, p31) -- line: 437
    -- upvalues: CollectionService (copy), BoxingConfig (copy), Stance (copy), self (copy), t4 (copy), LocalPlayer (copy), v8 (copy)
    if v8 and Stance ~= "" and (p29 == LocalPlayer.Character or CollectionService:HasTag(p29, "BoxingNPC")) then
        local HumanoidRootPart = p29:FindFirstChild("HumanoidRootPart")

        if HumanoidRootPart then
            if not p30.MoveTracks then
                local Animator = p30.Humanoid:FindFirstChildOfClass("Animator")

                if not Animator then
                    return
                end

                p30.MoveTracks = {}
                p30.MoveWeights = {
                    Forward = 0,
                    Backward = 0,
                    Left = 0,
                    Right = 0
                }

                local Move = BoxingConfig.StanceAnimations(p29).Move

                for _, v53 in t4 do
                    local v54 = Move[v53] or ""

                    if v54 ~= "" then
                        local Animation = Instance.new("Animation")

                        Animation.AnimationId = v54

                        local track = Animator:LoadAnimation(Animation)

                        self[track] = p29
                        track.Priority = Enum.AnimationPriority.Action2
                        track.Looped = true
                        track:Play(0.15, 0.001)
                        p30.MoveTracks[v53] = track
                    end
                end
            end

            local v55 = HumanoidRootPart.AssemblyLinearVelocity * Vector3.new(1, 0, 1)
            local v56 = if p29 == LocalPlayer.Character then p30.Humanoid.MoveDirection else v55
            local v57 = 1 - p30.PlantBlend
            local t18 = {
                Forward = 0,
                Backward = 0,
                Left = 0,
                Right = 0
            }

            if v56.Magnitude > 0.05 then
                local v58 = HumanoidRootPart.CFrame:VectorToObjectSpace(v56.Unit)

                t18.Forward = math.max(0, -v58.Z)
                t18.Backward = math.max(0, v58.Z)
                t18.Right = math.max(0, v58.X)
                t18.Left = math.max(0, -v58.X)

                local v61 = t18.Forward + t18.Backward + t18.Left + t18.Right

                for v62, v63 in t18 do
                    if v61 > 1E-06 then
                        t18[v62] = v63 / v61
                    else
                        t18[v62] = 0
                    end
                end

                if BoxingConfig.IsMirrored(p29) then
                    local Right, Left = t18.Right, t18.Left

                    t18.Left = Right
                    t18.Right = Left
                end
            end

            local v64 = BoxingConfig.Animations.MoveSpeedReference or 16
            local v66 = math.clamp(v55.Magnitude / v64, 0.5, 2.3)

            if v66 ~= v66 then
                v66 = 1
            end

            local v68 = math.min(p31 * 12, 1)

            for v69, v70 in p30.MoveTracks do
                if not v70.IsPlaying then
                    local Play = v70.Play

                    pcall(Play, v70, 0.15, 0.001)
                end

                local v71 = p30.MoveWeights[v69]
                local v72 = v71 + (t18[v69] * v57 - v71) * v68

                if v72 ~= v72 then
                    v72 = 0
                end

                p30.MoveWeights[v69] = v72
                v70:AdjustWeight(math.max(0.001, v72), 0)
                v70:AdjustSpeed(v66)
            end
        end
    end
end

if not BoxingConfig.Animations or type(BoxingConfig.Animations.BlockMove) ~= "table" or not BoxingConfig.Animations.BlockMove then
end

local function blockMoveDirection(p32, p33) -- line: 521
    -- upvalues: LocalPlayer (copy)
    local HumanoidRootPart = p32:FindFirstChild("HumanoidRootPart")

    if not HumanoidRootPart then
        return nil
    end

    local v74 = if p32 == LocalPlayer.Character then p33.Humanoid.MoveDirection else HumanoidRootPart.AssemblyLinearVelocity * Vector3.new(1, 0, 1)

    if v74.Magnitude < 0.05 then
        return nil
    end

    local v75 = HumanoidRootPart.CFrame:VectorToObjectSpace(v74.Unit)

    if math.abs(v75.X) > math.abs(v75.Z) then
        if v75.X > 0 then
            return "Right"
        end

        return "Left"
    end

    if v75.Z < 0 then
        return "Forward"
    end

    return "Backward"
end

local function updateBlockTrack(p34, p35, p36) -- line: 536
    -- upvalues: CollectionService (copy), BoxingConfig (copy), Stance (copy), self (copy), LocalPlayer (copy), blockMoveDirection (copy)
    local v77 = BoxingConfig.StanceAnimations(p34)

    if (v77.Block or "") ~= "" and Stance ~= "" then
        if not p36 or BoxingConfig.BlockArmsOnly(p34) then
            if p35.BlockTrack then
                p35.BlockTrack:Stop(0.1)
                p35.BlockTrack = nil
                p35.BlockTrackId = nil
            end
        elseif p34 == LocalPlayer.Character or CollectionService:HasTag(p34, "BoxingNPC") then
            local v78 = (p35.PlantBlend or 1) < 0.5 and blockMoveDirection(p34, p35)

            if v78 and BoxingConfig.IsMirrored(p34) and type(v78) == "string" then
                v78 = v78:gsub("Left", "#L#"):gsub("Right", "Left"):gsub("#L#", "Right")
            end

            local v79 = v78 and v77.BlockMove[v78]

            if not v79 or v79 == "" then
                v79 = v77.Block
            end

            if not p35.BlockTrack or p35.BlockTrackId ~= v79 then
                local v80 = p35.Tracks[v79]

                if not v80 then
                    local Animator = p35.Humanoid:FindFirstChildOfClass("Animator")

                    if not Animator then
                        return
                    end

                    local Animation = Instance.new("Animation")

                    Animation.AnimationId = v79
                    v80 = Animator:LoadAnimation(Animation)
                    self[v80] = p34
                    v80.Priority = Enum.AnimationPriority.Action4
                    v80.Looped = true
                    p35.Tracks[v79] = v80
                end

                local v81 = p35.BlockTrack ~= nil

                if p35.BlockTrack then
                    p35.BlockTrack:Stop(0.2)
                end

                v80:Play(v81 and 0.2 or 0.1)
                p35.BlockTrack = v80
                p35.BlockTrackId = v79
            end
        end
    end
end

local v82, v83

local function restoreRig(p37, p38) -- line: 588
    -- upvalues: t5 (copy), stopStance (copy), v82 (ref), v83 (ref)
    v82(p38)
    v83(p38)

    for v84, v85 in p38.Original do
        p38[v84].C0 = v85
    end

    stopStance(p38)

    if p38.Stars then
        p38.Stars:Destroy()
        p38.Stars = nil
    end

    t5[p37] = nil
end

local function punchWeight(p39, p40) -- line: 600
    -- upvalues: BoxingPoses (copy)
    local v86 = BoxingPoses.Animations[p39]
    local v87 = v86[2][1]
    local v88 = v86[#v86 - 1][1]
    local v89 = v86[#v86][1]

    if p40 < v87 then
        return p40 / v87
    end

    if not (v88 < p40) then
        return 1
    end

    return (math.clamp((v89 - p40) / (v89 - v88), 0, 1))
end

local _ = {
    Pos = Vector3.new(1.3, 0.65, -0.15),
    Pitch = 132,
    Yaw = 50,
    Roll = 0
}
local t19 = {
    Pos = Vector3.new(1.2, 0.9, -0.95),
    Pitch = 142,
    Yaw = 26,
    Roll = 0
}

t6.SpeedBagContactDelay = 0.231

local SpeedBagAnimations = BoxingConfig.SpeedBagAnimations
local v91 = SpeedBagAnimations ~= nil and SpeedBagAnimations.Cycle ~= nil and SpeedBagAnimations.Cycle ~= ""
local v92 = SpeedBagAnimations ~= nil and (v91 or SpeedBagAnimations.HitLeft ~= nil and SpeedBagAnimations.HitRight ~= nil)

if v92 then
    t6.SpeedBagContactDelay = if v91 then 0 else SpeedBagAnimations.Contact / SpeedBagAnimations.HitSpeed
    task.spawn(function() -- line: 629
        -- upvalues: ContentProvider (copy), SpeedBagAnimations (copy)
        local t20 = {}

        for _, v94 in { "Cycle", "Idle", "HitLeft", "HitRight" } do
            if SpeedBagAnimations[v94] then
                local Animation = Instance.new("Animation")

                Animation.AnimationId = SpeedBagAnimations[v94]
                table.insert(t20, Animation)
            end
        end

        local PreloadAsync = ContentProvider.PreloadAsync

        pcall(PreloadAsync, ContentProvider, t20)
    end)
end

local function speedBagTrack(p41, p42, p43, p44) -- line: 642
    -- upvalues: SpeedBagAnimations (copy)
    p41.SpeedBagTracks = p41.SpeedBagTracks or {}

    local v95 = p41.SpeedBagTracks[p42]

    if v95 then
        return v95
    end

    local Animator = p41.Humanoid:FindFirstChildOfClass("Animator")

    if not (Animator and SpeedBagAnimations[p42]) then
        return nil
    end

    local Animation = Instance.new("Animation")

    Animation.AnimationId = SpeedBagAnimations[p42]

    local track = Animator:LoadAnimation(Animation)

    track.Priority = p43
    track.Looped = p44
    p41.SpeedBagTracks[p42] = track

    return track
end

local function updateSpeedBagTracks(p45, p46, p47) -- line: 662
    -- upvalues: LocalPlayer (copy), v92 (copy), speedBagTrack (copy), v91 (copy)
    if not v92 or v91 or p45 ~= LocalPlayer.Character then
        return
    end

    if p47 then
        local v96 = speedBagTrack(p46, "Idle", Enum.AnimationPriority.Action2, true)

        if v96 and not v96.IsPlaying then
            v96:Play(0.2)
        end
    elseif p46.SpeedBagTracks then
        for _, v97 in p46.SpeedBagTracks do
            if v97.IsPlaying then
                v97:Stop(0.2)
            end
        end
    end
end

local function speedBagPose(p48, p49, p50) -- line: 682
    -- upvalues: t19 (copy)
    local SpeedBagPunch = p48.SpeedBagPunch

    if SpeedBagPunch and SpeedBagPunch.Side == p49 then
        local v99 = (p50 - SpeedBagPunch.Start) / (SpeedBagPunch.Duration or 0.55)
        local v98

        if v99 < 1 then
            v98 = if v99 < 0.42 then math.sin(v99 / 0.42 * 3.141592653589793 / 2) else math.cos((v99 - 0.42) / 0.5800000000000001 * 3.141592653589793 / 2)

            return t19, (math.clamp(v98, 0, 1))
        end
    end

    return t19, 0
end

function t6.SpeedBagPunch(p51, p52) -- line: 701
    -- upvalues: LocalPlayer (copy), t5 (copy), SpeedBagAnimations (copy), v92 (copy), speedBagTrack (copy), v91 (copy)
    local v103 = math.max(p52 or 1, 0.25)
    local v104 = t5[p51]

    if v91 then
        return 0
    end

    if v92 then
        local v105 = SpeedBagAnimations.HitSpeed * v103

        if v104 then
            v104.SpeedBagSide = v104.SpeedBagSide == "Left" and "Right" or "Left"

            if p51 == LocalPlayer.Character then
                local v106 = speedBagTrack(v104, "Hit" .. v104.SpeedBagSide, Enum.AnimationPriority.Action3, false)
                local SpeedBagTracks = v104.SpeedBagTracks

                SpeedBagTracks = SpeedBagTracks and v104.SpeedBagTracks["Hit" .. (if v104.SpeedBagSide == "Left" then "Right" else "Left")]

                if SpeedBagTracks and SpeedBagTracks.IsPlaying then
                    SpeedBagTracks:Stop(0.1)
                end

                if v106 then
                    v106:Play(0.06, 1, v105)
                end
            end
        end

        return SpeedBagAnimations.Contact / v105
    end

    local v107 = 0.55 / v103

    if v104 then
        v104.SpeedBagSide = v104.SpeedBagSide == "Left" and "Right" or "Left"
        v104.SpeedBagPunch = {
            Side = v104.SpeedBagSide,
            Start = os.clock(),
            Duration = v107
        }
    end

    return v107 * 0.42
end

local FlickerJab = BoxingConfig.FlickerJab

local function setFlickerStretch(p53, p54) -- line: 740
    local Arm = p53.Arm

    if Arm and Arm.Parent and not (math.abs(p54 - (p53.K or 1)) < 0.005) then
        p53.K = p54
        Arm.Size = Vector3.new(p53.ArmSize.X, p53.ArmSize.Y * p54, p53.ArmSize.Z)

        if p53.GloveWeld and p53.GloveWeld.Parent then
            p53.GloveWeld.C0 = CFrame.new(0, -(p54 - 1) * p53.ArmSize.Y / 2, 0) * p53.GloveC0
        end
    end
end

v82 = function(p55) -- line: 752
    local Flicker = p55.Flicker

    if not Flicker then
        return
    end

    p55.Flicker = nil

    if Flicker.Arm and Flicker.Arm.Parent then
        Flicker.Arm.Size = Flicker.ArmSize
    end

    if Flicker.GloveWeld and Flicker.GloveWeld.Parent then
        Flicker.GloveWeld.C0 = Flicker.GloveC0
    end

    if Flicker.Trail then
        Flicker.Trail.Enabled = false
    end
end

local function flickerTrail(p56) -- line: 770
    local BoxingGlove = p56:FindFirstChild("BoxingGlove")
    local Handle = BoxingGlove and BoxingGlove:FindFirstChild("Handle")

    if not Handle then
        return nil
    end

    local FlickerTrail = BoxingGlove:FindFirstChild("FlickerTrail")

    if FlickerTrail then
        return FlickerTrail
    end

    local Attachment = Instance.new("Attachment")

    Attachment.Name = "FlickerTop"
    Attachment.Position = Vector3.new(0.35, 0, 0)
    Attachment.Parent = Handle

    local Attachment2 = Instance.new("Attachment")

    Attachment2.Name = "FlickerBottom"
    Attachment2.Position = Vector3.new(-0.35, 0, 0)
    Attachment2.Parent = Handle

    local Trail = Instance.new("Trail")

    Trail.Name = "FlickerTrail"
    Trail.Attachment0 = Attachment
    Trail.Attachment1 = Attachment2
    Trail.FaceCamera = true
    Trail.Lifetime = 0.09
    Trail.MinLength = 0.02
    Trail.LightEmission = 1
    Trail.Brightness = 2
    Trail.Color = ColorSequence.new(Color3.fromRGB(180, 90, 255))
    Trail.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.15),
        NumberSequenceKeypoint.new(1, 1)
    })
    Trail.WidthScale = NumberSequence.new(1, 0.1)
    Trail.Enabled = false
    Trail.Parent = BoxingGlove

    return Trail
end

local function startFlicker(p57, p58, p59, p60, p61) -- line: 807
    -- upvalues: v82 (ref), FlickerJab (copy), flickerTrail (copy)
    v82(p58)

    local v110 = p57:FindFirstChild("Left Arm")

    if not v110 then
        return
    end

    local BoxingGlove = v110:FindFirstChild("BoxingGlove")
    local Handle = BoxingGlove and BoxingGlove:FindFirstChild("Handle")
    local Weld = Handle and Handle:FindFirstChildOfClass("Weld")
    local v111 = FlickerJab.RandomAngle or 0

    local function rand() -- line: 817
        -- upvalues: v111 (copy)
        return (math.random() * 2 - 1) * v111
    end

    p58.Flicker = {
        Start = os.clock(),
        HitTime = math.max(p60, 0.03),
        Retract = FlickerJab.Retract,
        Arm = v110,
        ArmSize = v110.Size,
        GloveWeld = Weld,
        GloveC0 = Weld and Weld.C0,
        Trail = flickerTrail(v110),
        Stretch = FlickerJab.Stretch,
        StartPitch = 22 + (math.random() * 2 - 1) * v111 * 0.5,
        EndPitch = (p59 == "Body" and 80 or 100) + (math.random() * 2 - 1) * v111,
        StartYaw = -2 + (math.random() * 2 - 1) * v111 * 0.5,
        EndYaw = -12 + (math.random() * 2 - 1) * v111,
        StretchOnly = p61 == true
    }
end

local function applyFlickerStretch(p62, p63) -- line: 841
    -- upvalues: v82 (ref), setFlickerStretch (copy)
    local Flicker = p62.Flicker

    if not (Flicker and Flicker.StretchOnly) then
        return
    end

    local v112 = p63 - Flicker.Start
    local HitTime, Retract = Flicker.HitTime, Flicker.Retract
    local v113, v114

    if HitTime + 0.035 + Retract <= v112 then
        v114 = true
    elseif Flicker.Arm and Flicker.Arm.Parent then
        if v112 < HitTime then
            v113 = 1 + (Flicker.Stretch - 1) * math.clamp((v112 / HitTime - 0.75) / 0.25, 0, 1)
        elseif v112 < HitTime + 0.035 then
            v113 = Flicker.Stretch
        else
            local v117 = (v112 - HitTime - 0.035) / Retract

            v113 = 1 + (Flicker.Stretch - 1) * math.max(0, 1 - v117 / 0.35)
        end

        v114 = false
    else
        v114 = true
    end

    if v114 then
        v82(p62)

        return
    end

    setFlickerStretch(Flicker, v113)

    if Flicker.Trail then
        local Trail = Flicker.Trail

        if HitTime * 0.3 < v112 then
            Trail.Enabled = v112 < HitTime + 0.035 + Retract * 0.3
        else
            Trail.Enabled = false
        end
    end

    if v113 > 1.001 then
        local Left = p62.Left
        local v120 = CFrame.new(0, -(v113 - 1) * Flicker.ArmSize.Y / 2, 0)

        Left.Transform = Left.Transform * Left.C1:Inverse() * v120 * Left.C1
    end
end

local function sampleFlicker(p64, p65, p66) -- line: 873
    -- upvalues: v82 (ref), setFlickerStretch (copy)
    local Flicker = p64.Flicker

    if Flicker and not Flicker.StretchOnly then
        local v121 = p65 - Flicker.Start
        local HitTime, Retract = Flicker.HitTime, Flicker.Retract
        local v122, v123, v124, v125

        if not (HitTime + 0.035 + Retract <= v121) and Flicker.Arm and Flicker.Arm.Parent then
            if v121 < HitTime then
                local v126 = v121 / HitTime
                local v127 = v126 * v126

                v123 = math.clamp(v126 / 0.3, 0, 1)
                v124 = Flicker.StartPitch + (Flicker.EndPitch - Flicker.StartPitch) * v127
                v125 = Flicker.StartYaw + (Flicker.EndYaw - Flicker.StartYaw) * v127
                v122 = 1 + (Flicker.Stretch - 1) * math.clamp((v126 - 0.75) / 0.25, 0, 1)
            elseif v121 < HitTime + 0.035 then
                v123 = 1
                v124 = Flicker.EndPitch
                v125 = Flicker.EndYaw
                v122 = Flicker.Stretch
            else
                local v131 = (v121 - HitTime - 0.035) / Retract

                v123 = (1 - v131) * (1 - v131)
                v124 = Flicker.EndPitch - 25 * v131
                v125 = Flicker.EndYaw
                v122 = 1 + (Flicker.Stretch - 1) * math.max(0, 1 - v131 / 0.35)
            end

            setFlickerStretch(Flicker, v122)

            if Flicker.Trail then
                local Trail = Flicker.Trail

                if HitTime * 0.3 < v121 then
                    Trail.Enabled = v121 < HitTime + 0.035 + Retract * 0.3
                else
                    Trail.Enabled = false
                end
            end

            local Left = p64.Left
            local Rotation = p64.Original.Left.Rotation
            local v134 = p66 * CFrame.Angles(0, math.rad(v125), 0) * CFrame.Angles(math.rad(v124), 0, 0)
            local v135 = CFrame.new(0, -(v122 - 1) * Flicker.ArmSize.Y / 2, 0)

            return v123, Rotation:Inverse() * v134 * Rotation * Left.C1:Inverse() * v135 * Left.C1, -9 * v123
        end

        v82(p64)
    end

    return 0, nil, 0
end

local t22 = {}

for _, v136 in BoxingConfig.TechniqueVFX or {} do
    if v136.ArmSpin and v136.Anim then
        t22[v136.Anim] = v136.ArmSpin
    end
end

local function applyArmSpin(p67, p68) -- line: 926
    -- upvalues: t22 (copy)
    if next(t22) ~= nil and not ((p68:GetAttribute("TechniqueUntil") or 0) <= workspace:GetServerTimeNow()) then
        local Animator = p67.Humanoid:FindFirstChildOfClass("Animator")

        if Animator then
            for _, v137 in Animator:GetPlayingAnimationTracks() do
                local v138 = v137.Animation and t22[v137.Animation.AnimationId]

                if v138 then
                    local v139 = (v137.TimePosition - v138.From) / (v138.To - v138.From)
                    local v140 = p67[v138.Arm or "Right"]

                    if v139 > 0 and v139 < 1 and v140 then
                        local v143 = math.rad(v138.Degrees) * (1 - math.cos(v139 * 3.141592653589793)) / 2

                        v140.Transform = v140.Transform * v140.C1:Inverse() * CFrame.Angles(0, -v143, 0) * v140.C1
                    end

                    return
                end
            end
        end
    end
end

local function updateAnimatedRig(p69, p70, p71, p72) -- line: 952
    -- upvalues: BoxingConfig (copy), BoxingPoses (copy), Block (copy), HeadGuardLift (copy), v9 (copy), LocalPlayer (copy), v14 (ref), t6 (copy), t12 (copy), t15 (copy), v92 (copy), updateSpeedBagTracks (copy), speedBagPose (copy), applyFlickerStretch (copy), sampleFlicker (copy), applyArmSpin (copy), v8 (copy)
    local PlantBlend = p70.PlantBlend
    local v144, v145, v146, v147, Side

    if p70.Punch then
        local Punch = p70.Punch
        local v148 = (p72 - p70.PunchStart) / p70.PunchSpeed
        local v149 = if Punch.Side == "Right" then BoxingPoses.GuardRear else BoxingPoses.GuardLead
        local v150 = p70.PunchZone == "Body"
        local v151, v152

        v144, v151, v152 = BoxingPoses.Sample(Punch.Anim, v148, v149, if v150 then BoxingPoses.BodyPitchOffset else nil)

        if v152 then
            v144 = nil
            v145 = 0
            v146 = 0
            v147 = 0
            p70.Punch = nil
        else
            local Side2, Anim = Punch.Side, Punch.Anim
            local v153 = BoxingPoses.Animations[Anim]
            local v154 = v153[2][1]
            local v155 = v153[#v153 - 1][1]
            local v156 = v153[#v153][1]
            local n1 = 1

            if v148 < v154 then
                n1 = v148 / v154
            elseif v155 < v148 then
                n1 = math.clamp((v156 - v148) / (v156 - v155), 0, 1)
            end

            v145 = n1 * (if p70.PunchJammed then 0.5 else 1)

            if Punch.Side ~= "Right" then
                v151 = -v151
            end

            v146 = v151 * v145
            Side = Side2
            v147 = if v150 then v145 * -10 else 0
        end
    else
        v145 = 0
        v146 = 0
        v147 = 0
    end

    local _, v158 = (p70.Original.Root * p70.Root.Transform * p70.Root.C1:Inverse()):ToEulerAnglesYXZ()
    local v159 = if v8 then 0 else 0.6
    local v160 = if not p70.Flicker or p70.Flicker.StretchOnly then 0 else -9
    local v161 = -v158 * (1 - PlantBlend) * v159 + math.rad(v146)

    p70.Root.C0 = CFrame.Angles(0, v161, 0) * CFrame.Angles(math.rad(v147), 0, 0) * p70.Original.Root

    local v162 = (p70.Root.C0 * p70.Root.Transform * p70.Root.C1:Inverse()).Rotation:Inverse()
    local v163, v164, v165 = sampleFlicker(p70, p72, v162)

    if v160 ~= 0 and v163 > 0 then
        p70.Root.C0 = CFrame.Angles(0, math.rad(v165), 0) * p70.Root.C0
        v162 = (p70.Root.C0 * p70.Root.Transform * p70.Root.C1:Inverse()).Rotation:Inverse()
        v163, v164 = sampleFlicker(p70, p72, v162)
    end

    local v166 = p69:GetAttribute("Training") == "Speed bag"

    if not v166 or p69 == LocalPlayer.Character then
        if not v166 then
            p70.SpeedBagHits = 0
        end
    else
        local v167 = p69:GetAttribute("SpeedBagHits") or 0

        if (p70.SpeedBagHits or 0) < v167 then
            t6.SpeedBagPunch(p69)
        end

        p70.SpeedBagHits = v167
    end

    updateSpeedBagTracks(p69, p70, v166)

    local t23 = {
        Left = 0,
        Right = 0
    }
    local v169, v170, v171, v172

    if Block == "" then
        v172 = 0
    elseif p70.BlockBlend > 0.001 then
        v169 = BoxingConfig.BlockArmsOnly(p69)
        v171 = v169

        if v169 then
            local Animator = p70.Humanoid:FindFirstChildOfClass("Animator")

            if Animator then
                v170 = Animator:GetPlayingAnimationTracks()
            else
                v170 = {}
            end

            for _, v173 in v170 do
                if v173.Priority == Enum.AnimationPriority.Action4 then
                    local v174 = math.clamp(v173.WeightCurrent, 0, 1)
                    local v175 = v173.Animation and t12[v173.Animation.AnimationId]

                    if v175 then
                        t23[v175] = math.max(t23[v175], v174)
                    else
                        local v177 = math.max(t23.Left, v174)
                        local v178 = math.max(t23.Right, v174)

                        t23.Left = v177
                        t23.Right = v178
                    end
                end
            end

            v171 = v169
            v172 = p70.BlockBlend
        else
            v172 = 0
        end
    else
        v172 = 0
    end

    local v179 = if v171 then (1 - math.cos(p72 * 2 * 3.141592653589793 / v171.Period)) / 2 else 0
    local v181 = BoxingPoses.Lerp(if (if p69 == LocalPlayer.Character then v14 else p69:GetAttribute("GuardZone")) == "Head" then BoxingPoses.Block else BoxingPoses.BodyBlock, t15, p70.ExposedBlend)
    local v182 = if Block == "" then math.max(p70.BlockBlend, p70.ExposedBlend) else p70.ExposedBlend
    local BreakAnim = p70.BreakAnim
    local v183 = v182

    if BreakAnim then
        local v184 = p72 - BreakAnim.Start
        local v185 = BoxingConfig.BlockReactions and BoxingConfig.BlockReactions.BreakFadeOut or 0.25

        if BreakAnim.Length <= v184 then
            p70.BreakAnim = nil
        else
            v183 = v182 * (1 - math.clamp((BreakAnim.Length - v184) / v185, 0, 1))
        end
    end

    for _, v187 in { "Right", "Left" } do
        local v188 = p70[v187]
        local v189, v190

        if v187 == Side then
            v189 = v144
            v190 = math.max(v145, v183)
        else
            v190 = v183
            v189 = v181
        end

        if v166 then
            if v92 then
                v190 = 0
            else
                v189, v190 = speedBagPose(p70, v187, p72)
            end
        end

        v188.C0 = p70.Original[v187]

        local v191 = v172 * (1 - t23[v187])

        if v191 > 0.001 then
            local v192 = v171.A[v187]:Lerp(v171.B[v187], v179)

            v188.Transform = v188.Transform:Lerp(v192, v191)
        end

        if v190 > 0.001 then
            local v193 = p70.Original[v187]:Inverse() * BoxingPoses.ShoulderC0(v189, v187, v188, 0, 0, v162)

            v188.Transform = v188.Transform:Lerp(v193, v190)
        end

        if v187 == "Left" and v164 and v163 > 0.001 then
            v188.Transform = v188.Transform:Lerp(v164, v163)
        end
    end

    applyFlickerStretch(p70, p72)

    if Block ~= "" and p70.HeadBlend > 0.001 then
        local v194 = CFrame.new(0, HeadGuardLift * p70.HeadBlend * p70.BlockBlend, 0)

        p70.Right.Transform = v194 * p70.Right.Transform
        p70.Left.Transform = v194 * p70.Left.Transform
    end

    local v195, v196

    if p70.BlockBlend > 0.001 or v9[p69] then
        local _, v197 = BoxingConfig.ActiveGuardItem(p69)

        if v197 and v197.Skill == "Half Guard" then
            v195 = p70.BlockBlend * (1 - 0.5 * p70.HeadBlend)
            v196 = CFrame.new(0, -0.25 * v195, 0) * CFrame.Angles(0, 0.3141592653589793 * v195, 1.0821041362364843 * v195)

            local v198 = v9[p69]

            if v198 then
                local v199 = (p72 - v198) / 0.28

                if v199 >= 1 or v199 < 0 then
                    v9[p69] = nil
                else
                    v196 = CFrame.Angles(math.sin(3.141592653589793 * v199) * -1.2217304763960306, 0, 0) * v196
                end
            end

            p70.Left.Transform = v196 * p70.Left.Transform
            p70.Right.Transform = CFrame.new(0, 0.12 * v195, 0) * p70.Right.Transform
        end
    end

    applyArmSpin(p70, p69)
    p70.Neck.C0 = p70.Original.Neck
    p70.LeftHip.C0 = p70.Original.LeftHip
    p70.RightHip.C0 = p70.Original.RightHip

    local HumanoidRootPart = p69:FindFirstChild("HumanoidRootPart")
    local v201 = not v8

    if not v201 then
        v201 = p70.BlockBlend > 0.5 and not v171
    end

    if not (HumanoidRootPart and PlantBlend < 0.999 and v201) then
        return
    end

    local Magnitude = (HumanoidRootPart.AssemblyLinearVelocity * Vector3.new(1, 0, 1)).Magnitude

    p70.WalkPhase = p70.WalkPhase + p71 * 9 * math.clamp(Magnitude / 16, 0.6, 1.8)

    local v204 = CFrame.Angles(0, 0, -math.sin(p70.WalkPhase) * 0.55)

    p70.LeftHip.Transform = p70.LeftHip.Transform:Lerp(v204, 1 - PlantBlend)
    p70.RightHip.Transform = p70.RightHip.Transform:Lerp(v204, 1 - PlantBlend)
end

local function poseOf(p73) -- line: 1122
    return p73.C0 * p73.Transform * p73.C1:Inverse()
end

local function finiteCF(p74) -- line: 1126
    if typeof(p74) ~= "CFrame" then
        return false
    end

    local Position = p74.Position
    local v205, v206, v207 = p74:ToEulerAnglesXYZ()

    if Position.X ~= Position.X
        or Position.Y ~= Position.Y
        or Position.Z ~= Position.Z
        or v205 ~= v205
        or v206 ~= v206
        or v207 ~= v207 then
        return false
    end

    return math.abs(Position.X) + math.abs(Position.Y) + math.abs(Position.Z) < 1E+05
end

t6.FiniteCF = finiteCF

local function scaleCFrame(p75, p76) -- line: 1135
    local v210, v211 = p75:ToAxisAngle()
    local v212 = if math.abs(v211) > 1E-05 then CFrame.fromAxisAngle(v210, v211 * p76) else CFrame.identity

    return CFrame.new(p75.Position * p76) * v212
end

local function deepenWeave(p77, p78, p79) -- line: 1140
    -- upvalues: BoxingStatEffects (copy), BoxingPassives (copy), Weave (copy), v10 (ref), LocalPlayer (copy), finiteCF (copy)
    local v213 = if p77 == LocalPlayer.Character then v10 ~= nil else p77:GetAttribute("Weaving") ~= nil
    local Root = p78.Root
    local v214 = Root.C0 * Root.Transform * Root.C1:Inverse()
    local Neck = p78.Neck
    local v215 = Neck.C0 * Neck.Transform * Neck.C1:Inverse()

    if not v213 and (p78.DeepBlend or 0) < 0.001 then
        p78.StanceTorso = v214
        p78.StanceHead = v215
    end

    local v216 = if not (v213 and BoxingPassives.Has(p77, "Head Slip")) then 0 else 1

    if v216 == 0 and (p78.DeepBlend or 0) < 1E-04 then
        p78.DeepBlend = 0

        return
    end

    local v217 = (Weave and Weave.BlendTime or 0.12) * BoxingStatEffects.WeaveTimeMultiplier(p77)

    if v217 ~= v217 then
        v217 = 0.12
    end

    p78.DeepBlend = (p78.DeepBlend or 0) + (v216 - (p78.DeepBlend or 0)) * math.min(p79 / math.max(v217 * 0.5, 0.02), 1)

    if p78.DeepBlend == p78.DeepBlend then
        local v222 = if p77 == LocalPlayer.Character then v10 else p77:GetAttribute("Weaving")

        if v222 then
            p78.DeepDir = v222
        end

        local v223 = (BoxingPassives.HeadSlipDepth(p78.DeepDir or "Back") - 1) * p78.DeepBlend

        if v223 == v223 and not (v223 < 0.001) and finiteCF(p78.StanceTorso) and finiteCF(p78.StanceHead) and finiteCF(v214) and finiteCF(v215) then
            local function deepAt(p80) -- line: 1176
                -- upvalues: p78 (copy), v214 (copy), v215 (copy)
                local StanceTorso = p78.StanceTorso
                local v224 = p78.StanceTorso:Inverse() * v214
                local v225, v226 = v224:ToAxisAngle()
                local v227 = if math.abs(v226) > 1E-05 then CFrame.fromAxisAngle(v225, v226 * p80) else CFrame.identity
                local v228 = StanceTorso * (CFrame.new(v224.Position * p80) * v227)
                local StanceHead = p78.StanceHead
                local v229 = p78.StanceHead:Inverse() * v215
                local v230, v231 = v229:ToAxisAngle()
                local v232 = if math.abs(v231) > 1E-05 then CFrame.fromAxisAngle(v230, v231 * p80) else CFrame.identity

                return v228, StanceHead * (CFrame.new(v229.Position * p80) * v232)
            end

            local Position = (p78.StanceTorso * p78.StanceHead).Position
            local v233 = ((v214 * v215).Position - Position).Magnitude * (1 + v223)
            local v234 = 1
            local v235 = 1 + v223

            for _ = 1, 7 do
                local v236 = (v234 + v235) / 2
                local StanceTorso = p78.StanceTorso
                local v237 = p78.StanceTorso:Inverse() * v214
                local v238, v239 = v237:ToAxisAngle()
                local v240 = if math.abs(v239) > 1E-05 then CFrame.fromAxisAngle(v238, v239 * v236) else CFrame.identity
                local v241 = StanceTorso * (CFrame.new(v237.Position * v236) * v240)
                local StanceHead = p78.StanceHead
                local v242 = p78.StanceHead:Inverse() * v215
                local v243, v244 = v242:ToAxisAngle()
                local v245 = if math.abs(v244) > 1E-05 then CFrame.fromAxisAngle(v243, v244 * v236) else CFrame.identity

                if ((v241 * (StanceHead * (CFrame.new(v242.Position * v236) * v245))).Position - Position).Magnitude < v233 then
                    v234 = v236
                else
                    v235 = v236
                end
            end

            local v246 = (v234 + v235) / 2
            local StanceTorso = p78.StanceTorso
            local v247 = p78.StanceTorso:Inverse() * v214
            local v248, v249 = v247:ToAxisAngle()
            local v250 = if math.abs(v249) > 1E-05 then CFrame.fromAxisAngle(v248, v249 * v246) else CFrame.identity
            local v251 = StanceTorso * (CFrame.new(v247.Position * v246) * v250)
            local StanceHead = p78.StanceHead
            local v252 = p78.StanceHead:Inverse() * v215
            local v253, v254 = v252:ToAxisAngle()
            local v255 = if math.abs(v254) > 1E-05 then CFrame.fromAxisAngle(v253, v254 * v246) else CFrame.identity
            local v256 = StanceHead * (CFrame.new(v252.Position * v246) * v255)
            local v257 = v251:Inverse() * v214
            local t24 = {}

            for _, v258 in { "LeftHip", "RightHip" } do
                local v259 = p78[v258]

                t24[v258] = v257 * (v259.C0 * v259.Transform * v259.C1:Inverse())
            end

            if finiteCF(v251) and finiteCF(v256) then
                p78.Root.Transform = p78.Root.C0:Inverse() * v251 * p78.Root.C1
                p78.Neck.Transform = p78.Neck.C0:Inverse() * v256 * p78.Neck.C1

                for v260, v261 in t24 do
                    p78[v260].Transform = p78[v260].C0:Inverse() * v261 * p78[v260].C1
                end
            end
        end
    else
        p78.DeepBlend = 0
        p78.StanceTorso = nil
        p78.StanceHead = nil
    end
end

local function updateRig(p81, p82, p83, p84) -- line: 1210
    -- upvalues: BoxingPoses (copy), Stance (copy), LocalPlayer (copy), v13 (ref), v14 (ref), t15 (copy), updateWeaveTracks (copy), updateMoveTracks (copy), updateBlockTrack (copy), v82 (ref), updateAnimatedRig (copy), deepenWeave (copy)
    local Stance2 = BoxingPoses.Stance
    local Humanoid = p82.Humanoid
    local v262 = (p81:GetAttribute("GuardBrokenUntil") or 0) > workspace:GetServerTimeNow()
    local v263 = not v262 and (if p81 == LocalPlayer.Character then v13 else p81:GetAttribute("Blocking") == true)

    p82.BlockBlend = p82.BlockBlend + ((if v263 then 1 else 0) - p82.BlockBlend) * math.min(p83 * 12, 1)

    local v266 = v263 and (if p81 == LocalPlayer.Character then v14 else p81:GetAttribute("GuardZone")) == "Head"

    p82.HeadBlend = p82.HeadBlend + ((if v266 then 1 else 0) - p82.HeadBlend) * math.min(p83 * 12, 1)
    updateBlockTrack(p81, p82, v263)

    local v269

    if p81 == LocalPlayer.Character then
        v269 = Humanoid.MoveDirection.Magnitude >= 0.1
    else
        local HumanoidRootPart = p81:FindFirstChild("HumanoidRootPart")

        v269 = HumanoidRootPart ~= nil and (HumanoidRootPart.AssemblyLinearVelocity * Vector3.new(1, 0, 1)).Magnitude > 1.5
    end

    local v270 = not v269 and Humanoid.FloorMaterial ~= Enum.Material.Air

    p82.PlantBlend = p82.PlantBlend + ((if v270 then 1 else 0) - p82.PlantBlend) * math.min(p83 * 10, 1)
    updateMoveTracks(p81, p82, p83)
    updateWeaveTracks(p81, p82)

    if v263 or v262 then
        p82.Punch = nil
        v82(p82)
    end

    p82.ExposedBlend = p82.ExposedBlend + ((if v262 then 1 else 0) - p82.ExposedBlend) * math.min(p83 * 14, 1)

    if p82.Stars then
        p82.Stars:Destroy()
        p82.Stars = nil
    end

    if Stance ~= "" then
        updateAnimatedRig(p81, p82, p83, p84)
        deepenWeave(p81, p82, p83)

        return
    end

    local v275 = if (if p81 == LocalPlayer.Character then v14 else p81:GetAttribute("GuardZone")) == "Head" then BoxingPoses.Block else BoxingPoses.BodyBlock
    local v276 = BoxingPoses.Lerp(BoxingPoses.Lerp(BoxingPoses.GuardRear, v275, p82.BlockBlend), t15, p82.ExposedBlend)
    local v277 = BoxingPoses.Lerp(BoxingPoses.Lerp(BoxingPoses.GuardLead, v275, p82.BlockBlend), t15, p82.ExposedBlend)
    local v279
    local v278 = v276
    local v280 = v277

    if p82.Punch then
        local v281 = if p82.Punch.Side == "Right" then v276 else v277
        local v282 = (p84 - p82.PunchStart) / p82.PunchSpeed
        local BodyPitchOffset = if p82.PunchZone == "Body" then BoxingPoses.BodyPitchOffset else nil
        local v283

        v278, v279, v283 = BoxingPoses.Sample(p82.Punch.Anim, v282, v281, BodyPitchOffset)

        if p82.PunchJammed and not v283 then
            v278 = BoxingPoses.Lerp(v281, v278, 0.5)
            v279 *= 0.5
        end

        if v283 then
            p82.Punch = nil
            v278 = v276
            v279 = 0
        elseif p82.Punch.Side ~= "Right" then
            v278, v280, v279 = v276, v278, -v279
        end
    else
        v279 = 0
    end

    local v284 = p84 + p82.Phase
    local PlantBlend2 = p82.PlantBlend
    local v286 = math.sin(v284 * Stance2.BobSpeed * 6.283185307179586)
    local v288 = math.sin(v284 * Stance2.SwaySpeed * 6.283185307179586) * Stance2.SwayTwist * PlantBlend2
    local v289 = (Stance2.LegSpread + v286 * Stance2.BobLeg) * PlantBlend2
    local v292 = BoxingPoses.LimbLength(p82.LeftHip) * (1 - math.cos((math.rad(v289))))
    local v293 = (BoxingPoses.LerpNumber(Stance2.Twist, Stance2.BlockTwist, p82.BlockBlend) * BoxingPoses.LerpNumber(Stance2.MovingTwistScale, 1, PlantBlend2) + v288 + v279) * (1 - p82.ExposedBlend)
    local v294 = BoxingPoses.LerpNumber(Stance2.Lean, 6, p82.ExposedBlend)

    p82.Root.C0 = CFrame.new(0, -v292, 0) * CFrame.Angles(0, math.rad(v293), 0) * CFrame.Angles(math.rad(v294), 0, 0) * p82.Original.Root
    p82.Right.C0 = BoxingPoses.ShoulderC0(v278, "Right", p82.Right, v293, v294)
    p82.Left.C0 = BoxingPoses.ShoulderC0(v280, "Left", p82.Left, v293, v294)
    p82.Neck.C0 = BoxingPoses.NeckC0(p82.Neck, v293, v294, BoxingPoses.LerpNumber(Stance2.HeadTuck, 18, p82.ExposedBlend))
    p82.LeftHip.C0 = BoxingPoses.HipC0("Left", v289 - v294, p82.LeftHip)
    p82.RightHip.C0 = BoxingPoses.HipC0("Right", -v289 - v294, p82.RightHip)
    p82.Right.Transform = CFrame.identity
    p82.Left.Transform = CFrame.identity
    p82.Neck.Transform = CFrame.identity
    p82.LeftHip.Transform = p82.LeftHip.Transform:Lerp(CFrame.identity, PlantBlend2)
    p82.RightHip.Transform = p82.RightHip.Transform:Lerp(CFrame.identity, PlantBlend2)
end

local t25 = {}
local t26 = {}

local function applyHeadSnaps(p85) -- line: 1308
    -- upvalues: BoxingConfig (copy), t25 (copy), t26 (copy)
    local HitReactions = BoxingConfig.HitReactions

    for v295, v296 in t25 do
        local v297 = p85 - v296.Start
        local v298 = HitReactions.HeadSnapTime + HitReactions.HeadSnapRecover
        local Neck = v296.Neck

        if v298 <= v297 then
            if not t26[v295] then
                Neck.C0 = v296.Original
            end

            t25[v295] = nil
        elseif Neck.Parent and v295:IsDescendantOf(workspace) then
            local v299

            if v297 < HitReactions.HeadSnapTime then
                v299 = math.sin(v297 / HitReactions.HeadSnapTime * 3.141592653589793 / 2)
            else
                local v301 = (v297 - HitReactions.HeadSnapTime) / HitReactions.HeadSnapRecover

                v299 = 1 - v301 * v301 * (3 - 2 * v301)
            end

            Neck.C0 = (if t26[v295] then Neck.C0 else v296.Original) * CFrame.Angles(-math.rad(v296.Degrees * v299), 0, 0)
        else
            if not t26[v295] then
                Neck.C0 = v296.Original
            end

            t25[v295] = nil
        end
    end
end

local t27 = {}

local function jointOf(p86, p87, p88) -- line: 1338
    local v304 = p86:FindFirstChild(p87)
    local v305 = v304 and v304:FindFirstChild(p88)

    return if v305 and v305:IsA("Motor6D") then v305 else nil
end

local function whip(p89, p90, p91) -- line: 1344
    if p89 < p90 then
        return (math.sin(p89 / p90 * 3.141592653589793 / 2))
    end

    local v308 = math.clamp((p89 - p90) / p91, 0, 1)

    return 1 - v308 * v308 * (3 - v308 * 2)
end

local function applyBodyFx(p92) -- line: 1352
    -- upvalues: BoxingConfig (copy), t26 (copy), t27 (copy)
    local HitReactions = BoxingConfig.HitReactions

    for v309, v310 in t27 do
        local Root, LeftHip, RightHip = v310.Root, v310.LeftHip, v310.RightHip
        local v311 = p92 - v310.TwistStart
        local v312 = p92 - v310.StumbleStart
        local v313 = HitReactions.TwistTime + HitReactions.TwistRecover <= v311
        local v314 = HitReactions.StumbleTime <= v312
        local v315 = p92 - v310.CenterStart
        local v316 = HitReactions.LeanTime + HitReactions.LeanRecover <= v315

        if v313 then
            if v314 then
                if v316 then
                    if not t26[v309] then
                        Root.C0 = v310.Original.Root

                        if LeftHip and RightHip then
                            LeftHip.C0 = v310.Original.LeftHip
                            RightHip.C0 = v310.Original.RightHip
                        end
                    end

                    t27[v309] = nil
                elseif Root.Parent and v309:IsDescendantOf(workspace) then
                    local C0 = if t26[v309] then Root.C0 else v310.Original.Root
                    local identity = CFrame.identity
                    local v317 = math.rad(v310.CenterDegrees)
                    local LeanTime, LeanRecover = HitReactions.LeanTime, HitReactions.LeanRecover
                    local v318

                    if v315 < LeanTime then
                        v318 = math.sin(v315 / LeanTime * 3.141592653589793 / 2)
                    else
                        local v321 = math.clamp((v315 - LeanTime) / LeanRecover, 0, 1)

                        v318 = 1 - v321 * v321 * (3 - v321 * 2)
                    end

                    local v322 = v317 * v318
                    local v323 = CFrame.new(0, -1, 0)
                    local n2 = 0

                    Root.C0 = v323 * CFrame.Angles(v322, 0, 0) * v323:Inverse() * identity * C0

                    if LeftHip and RightHip then
                        if v322 == 0 then
                            if not t26[v309] then
                                LeftHip.C0 = v310.Original.LeftHip
                                RightHip.C0 = v310.Original.RightHip
                            end
                        else
                            local C0 = if t26[v309] then LeftHip.C0 else v310.Original.LeftHip
                            local C0_2 = if t26[v309] then RightHip.C0 else v310.Original.RightHip

                            LeftHip.C0 = C0 * CFrame.Angles(0, 0, n2 + v322)
                            RightHip.C0 = C0_2 * CFrame.Angles(0, 0, n2 - v322)
                        end
                    end
                else
                    if not t26[v309] then
                        Root.C0 = v310.Original.Root

                        if LeftHip and RightHip then
                            LeftHip.C0 = v310.Original.LeftHip
                            RightHip.C0 = v310.Original.RightHip
                        end
                    end

                    t27[v309] = nil
                end
            elseif Root.Parent and v309:IsDescendantOf(workspace) then
                local C0 = if t26[v309] then Root.C0 else v310.Original.Root
                local identity = CFrame.identity
                local v324

                if v316 then
                    v324 = 0
                else
                    local v325 = math.rad(v310.CenterDegrees)
                    local LeanTime, LeanRecover = HitReactions.LeanTime, HitReactions.LeanRecover
                    local v326

                    if v315 < LeanTime then
                        v326 = math.sin(v315 / LeanTime * 3.141592653589793 / 2)
                    else
                        local v329 = math.clamp((v315 - LeanTime) / LeanRecover, 0, 1)

                        v326 = 1 - v329 * v329 * (3 - v329 * 2)
                    end

                    v324 = v325 * v326

                    local v330 = CFrame.new(0, -1, 0)

                    identity = v330 * CFrame.Angles(v324, 0, 0) * v330:Inverse() * identity
                end

                local v331 = math.rad(v310.LeanDegrees)
                local v332 = HitReactions.StumbleTime - 0.1
                local v333

                if v312 < 0.1 then
                    v333 = math.sin(v312 / 0.1 * 3.141592653589793 / 2)
                else
                    local v336 = math.clamp((v312 - 0.1) / v332, 0, 1)

                    v333 = 1 - v336 * v336 * (3 - v336 * 2)
                end

                local v337 = v331 * v333
                local v338 = CFrame.new(0, -3, 0)

                identity = v338 * CFrame.Angles(v337 * v310.LeanZ, 0, -v337 * v310.LeanX) * v338:Inverse() * identity

                local v339 = v312 / HitReactions.StumbleTime
                local v342 = math.rad(HitReactions.StumbleStep) * math.sin(v339 * 3.141592653589793 * 4) * (1 - v339)

                Root.C0 = identity * C0

                if LeftHip and RightHip then
                    if v342 ~= 0 or v324 ~= 0 then
                        local C0 = if t26[v309] then LeftHip.C0 else v310.Original.LeftHip
                        local C0_2 = if t26[v309] then RightHip.C0 else v310.Original.RightHip

                        LeftHip.C0 = C0 * CFrame.Angles(0, 0, v342 + v324)
                        RightHip.C0 = C0_2 * CFrame.Angles(0, 0, v342 - v324)
                    elseif not t26[v309] then
                        LeftHip.C0 = v310.Original.LeftHip
                        RightHip.C0 = v310.Original.RightHip
                    end
                end
            else
                if not t26[v309] then
                    Root.C0 = v310.Original.Root

                    if LeftHip and RightHip then
                        LeftHip.C0 = v310.Original.LeftHip
                        RightHip.C0 = v310.Original.RightHip
                    end
                end

                t27[v309] = nil
            end
        elseif Root.Parent and v309:IsDescendantOf(workspace) then
            local C0 = if t26[v309] then Root.C0 else v310.Original.Root
            local identity, Angles = CFrame.identity, CFrame.Angles
            local TwistDegrees = v310.TwistDegrees
            local TwistTime, TwistRecover = HitReactions.TwistTime, HitReactions.TwistRecover
            local v343

            if v311 < TwistTime then
                v343 = math.sin(v311 / TwistTime * 3.141592653589793 / 2)
            else
                local v346 = math.clamp((v311 - TwistTime) / TwistRecover, 0, 1)

                v343 = 1 - v346 * v346 * (3 - v346 * 2)
            end

            identity *= Angles(0, math.rad(TwistDegrees * v343), 0)

            local v348

            if v316 then
                v348 = 0
            else
                local v349 = math.rad(v310.CenterDegrees)
                local LeanTime, LeanRecover = HitReactions.LeanTime, HitReactions.LeanRecover
                local v350

                if v315 < LeanTime then
                    v350 = math.sin(v315 / LeanTime * 3.141592653589793 / 2)
                else
                    local v353 = math.clamp((v315 - LeanTime) / LeanRecover, 0, 1)

                    v350 = 1 - v353 * v353 * (3 - v353 * 2)
                end

                v348 = v349 * v350

                local v354 = CFrame.new(0, -1, 0)

                identity = v354 * CFrame.Angles(v348, 0, 0) * v354:Inverse() * identity
            end

            local v355

            if v314 then
                v355 = 0
            else
                local v356 = math.rad(v310.LeanDegrees)
                local v357 = HitReactions.StumbleTime - 0.1
                local v358

                if v312 < 0.1 then
                    v358 = math.sin(v312 / 0.1 * 3.141592653589793 / 2)
                else
                    local v361 = math.clamp((v312 - 0.1) / v357, 0, 1)

                    v358 = 1 - v361 * v361 * (3 - v361 * 2)
                end

                local v362 = v356 * v358
                local v363 = CFrame.new(0, -3, 0)

                identity = v363 * CFrame.Angles(v362 * v310.LeanZ, 0, -v362 * v310.LeanX) * v363:Inverse() * identity

                local v364 = v312 / HitReactions.StumbleTime

                v355 = math.rad(HitReactions.StumbleStep) * math.sin(v364 * 3.141592653589793 * 4) * (1 - v364)
            end

            Root.C0 = identity * C0

            if LeftHip and RightHip then
                if v355 ~= 0 or v348 ~= 0 then
                    local C0 = if t26[v309] then LeftHip.C0 else v310.Original.LeftHip
                    local C0_2 = if t26[v309] then RightHip.C0 else v310.Original.RightHip

                    LeftHip.C0 = C0 * CFrame.Angles(0, 0, v355 + v348)
                    RightHip.C0 = C0_2 * CFrame.Angles(0, 0, v355 - v348)
                elseif not t26[v309] then
                    LeftHip.C0 = v310.Original.LeftHip
                    RightHip.C0 = v310.Original.RightHip
                end
            end
        else
            if not t26[v309] then
                Root.C0 = v310.Original.Root

                if LeftHip and RightHip then
                    LeftHip.C0 = v310.Original.LeftHip
                    RightHip.C0 = v310.Original.RightHip
                end
            end

            t27[v309] = nil
        end
    end
end

local function getBodyFx(p93) -- line: 1411
    -- upvalues: t27 (copy)
    local v367 = t27[p93]

    if v367 then
        return v367
    end

    local HumanoidRootPart = p93:FindFirstChild("HumanoidRootPart")
    local RootJoint = HumanoidRootPart and HumanoidRootPart:FindFirstChild("RootJoint")

    if not (RootJoint and RootJoint:IsA("Motor6D")) then
        RootJoint = nil
    end

    local v368

    if RootJoint then
        v368 = RootJoint
    else
        local HumanoidRootPart = p93:FindFirstChild("HumanoidRootPart")
        local v369 = HumanoidRootPart and HumanoidRootPart:FindFirstChild("Root Hip")

        if v369 and v369:IsA("Motor6D") then
            v368 = v369
        end
    end

    if not v368 then
        return nil
    end

    local Torso = p93:FindFirstChild("Torso")
    local v370 = Torso and Torso:FindFirstChild("Left Hip")

    if not (v370 and v370:IsA("Motor6D")) then
        v370 = nil
    end

    local Torso2 = p93:FindFirstChild("Torso")
    local v371 = Torso2 and Torso2:FindFirstChild("Right Hip")

    if not (v371 and v371:IsA("Motor6D")) then
        v371 = nil
    end

    local t28 = {
        TwistStart = (-1e999),
        TwistDegrees = 0,
        StumbleStart = (-1e999),
        CenterStart = (-1e999),
        CenterDegrees = 0,
        LeanDegrees = 0,
        LeanX = 0,
        LeanZ = 1,
        Root = v368,
        LeftHip = v370,
        RightHip = v371,
        Original = {
            Root = v368.C0,
            LeftHip = v370 and v370.C0,
            RightHip = v371 and v371.C0
        }
    }

    t27[p93] = t28

    return t28
end

function t6.BodyTwist(p94, p95) -- line: 1446
    -- upvalues: getBodyFx (copy)
    local v372 = getBodyFx(p94)

    if v372 then
        v372.TwistStart = os.clock()
        v372.TwistDegrees = p95
    end
end

function t6.LeanBack(p96, p97) -- line: 1456
    -- upvalues: getBodyFx (copy)
    local v373 = getBodyFx(p96)

    if v373 then
        v373.CenterStart = os.clock()
        v373.CenterDegrees = p97
    end
end

function t6.Stumble(p98, p99, p100) -- line: 1465
    -- upvalues: BoxingConfig (copy), getBodyFx (copy)
    local v374 = getBodyFx(p98)
    local HumanoidRootPart = p98:FindFirstChild("HumanoidRootPart")

    if not (v374 and HumanoidRootPart) then
        return
    end

    local v375 = p99 * Vector3.new(1, 0, 1)

    if v375.Magnitude < 0.001 then
        v375 = -HumanoidRootPart.CFrame.LookVector
    end

    local v376 = HumanoidRootPart.CFrame:VectorToObjectSpace(v375.Unit)

    v374.StumbleStart = os.clock()
    v374.LeanDegrees = BoxingConfig.HitReactions.StumbleLean * math.clamp(p100, 0.3, 1.2)

    local X, Z = v376.X, v376.Z

    v374.LeanX = X
    v374.LeanZ = Z
end

function t6.HeadSnap(p101, p102) -- line: 1481
    -- upvalues: t25 (copy)
    local v377 = p101:FindFirstChild("Torso") or p101:FindFirstChild("Head")
    local Neck = v377 and v377:FindFirstChild("Neck")

    if not (Neck and Neck:IsA("Motor6D")) then
        return
    end

    local v378 = t25[p101]

    t25[p101] = {
        Start = os.clock(),
        Degrees = p102,
        Neck = Neck,
        Original = if v378 then v378.Original else Neck.C0
    }
end

local t31 = {
    { "Left", "Right" },
    { "LeftHip", "RightHip" }
}
local t32 = {
    "Neck",
    "Root"
}

local function mirrorCFrame(p103) -- line: 1501
    local Components, Components2, Components3, Components4, Components5, Components6, Components7, Components8, Components9, Components10, Components11, Components12 = p103:GetComponents()

    return CFrame.new(-Components, Components2, Components3, Components4, -Components5, -Components6, -Components7, Components8, Components9, -Components10, Components11, Components12)
end

local function partPose(p104) -- line: 1505
    return p104.C0 * p104.Transform * p104.C1:Inverse()
end

local function setPartPose(p105, p106) -- line: 1508
    p105.Transform = p105.C0:Inverse() * p106 * p105.C1
end

local function applyMirror(p107) -- line: 1511
    -- upvalues: t31 (copy), t32 (copy)
    local t33 = {}

    for _, v379 in t31 do
        local v380 = p107[v379[1]]
        local v381 = p107[v379[2]]
        local v382 = v380.C0 * v380.Transform * v380.C1:Inverse()
        local v383 = v381.C0 * v381.Transform * v381.C1:Inverse()
        local Transform = v380.Transform
        local Transform2 = v381.Transform

        t33[v380] = Transform
        t33[v381] = Transform2

        local Components, Components2, Components3, Components4, Components5, Components6, Components7, Components8, Components9, Components10, Components11, Components12 = v383:GetComponents()
        local v384 = CFrame.new(-Components, Components2, Components3, Components4, -Components5, -Components6, -Components7, Components8, Components9, -Components10, Components11, Components12)

        v380.Transform = v380.C0:Inverse() * v384 * v380.C1

        local Components13, Components14, Components15, Components16, Components17, Components18, Components19, Components20, Components21, Components22, Components23, Components24 = v382:GetComponents()
        local v385 = CFrame.new(-Components13, Components14, Components15, Components16, -Components17, -Components18, -Components19, Components20, Components21, -Components22, Components23, Components24)

        v381.Transform = v381.C0:Inverse() * v385 * v381.C1
    end

    for _, v386 in t32 do
        local v387 = p107[v386]

        t33[v387] = v387.Transform

        local Components, Components2, Components3, Components4, Components5, Components6, Components7, Components8, Components9, Components10, Components11, Components12 = (v387.C0 * v387.Transform * v387.C1:Inverse()):GetComponents()
        local v388 = CFrame.new(-Components, Components2, Components3, Components4, -Components5, -Components6, -Components7, Components8, Components9, -Components10, Components11, Components12)

        v387.Transform = v387.C0:Inverse() * v388 * v387.C1
    end

    local t34 = {}

    for v389 in t33 do
        t34[v389] = v389.Transform
    end

    p107.MirrorIn = t33
    p107.MirrorOut = t34
end

v83 = function(p108) -- line: 1533
    if p108.MirrorOut then
        for v390, v391 in p108.MirrorOut do
            if v390.Transform == v391 then
                v390.Transform = p108.MirrorIn[v390]
            end
        end

        p108.MirrorOut = nil
        p108.MirrorIn = nil
    end
end

local n3 = 0
local n4 = 0

local function rigHolds(p109, p110) -- line: 1547
    if p109.StanceTrack == p110 or p109.BlockTrack == p110 then
        return true
    end

    for _, v392 in {
            p109.MoveTracks,
            p109.WeaveTracks,
            p109.Tracks
        } do
        if v392 then
            for _, v393 in v392 do
                if v393 == p110 then
                    return true
                end
            end
        end
    end

    return false
end

local function badCFrame(p111, p112) -- line: 1564
    local Position = p111.Position

    if Position.X ~= Position.X or Position.Y ~= Position.Y or Position.Z ~= Position.Z then
        return true
    end

    return p112 ~= nil and (Position - p112.Position).Magnitude > 4
end

local t35 = {}
local t36 = { "BlockBlend", "HeadBlend", "PlantBlend", "ExposedBlend", "WalkPhase", "DeepBlend", "PunchSpeed", "PunchStart" }

local function rigNaNs(p113) -- line: 1575
    -- upvalues: finiteCF (copy), t36 (copy)
    local t37 = {}

    for _, v394 in t36 do
        local v395 = p113[v394]

        if type(v395) == "number" and v395 ~= v395 then
            table.insert(t37, v394)
            p113[v394] = v394 == "PunchSpeed" and 1 or 0
        end
    end

    for v396, v397 in p113.MoveWeights or {} do
        if v397 ~= v397 then
            table.insert(t37, "Move" .. v396)
            p113.MoveWeights[v396] = 0
        end
    end

    if p113.StanceTorso and not finiteCF(p113.StanceTorso) then
        table.insert(t37, "StanceTorso")
        p113.StanceTorso = nil
        p113.StanceHead = nil
    end

    return t37
end

local function checkJoints(p114, p115) -- line: 1596
    -- upvalues: v82 (ref), t25 (copy), t27 (copy), t35 (copy), rigNaNs (copy)
    local v399 = rigNaNs(p115)
    local v400 = #v399 > 0

    for v401, v402 in p115.Original do
        local v403 = p115[v401]

        if v403 and v403.Parent then
            local C0Position = v403.C0.Position

            if C0Position.X ~= C0Position.X or C0Position.Y ~= C0Position.Y or C0Position.Z ~= C0Position.Z or v402 ~= nil and (C0Position - v402.Position).Magnitude > 4 then
                v403.C0 = v402

                local v404 = v401 .. ".C0"

                v400 = true
                table.insert(v399, v404)
            end

            local Transform = v403.Transform
            local identity = CFrame.identity
            local TransformPosition = Transform.Position

            if TransformPosition.X ~= TransformPosition.X or TransformPosition.Y ~= TransformPosition.Y or TransformPosition.Z ~= TransformPosition.Z or identity ~= nil and (TransformPosition - identity.Position).Magnitude > 4 then
                v403.Transform = CFrame.identity

                local v405 = v401 .. ".T"

                v400 = true
                table.insert(v399, v405)
            end
        end
    end

    local HumanoidRootPart = p114:FindFirstChild("HumanoidRootPart")
    local Torso = p114:FindFirstChild("Torso")

    if HumanoidRootPart and Torso and not p114:GetAttribute("Downed") and (Torso.Position - HumanoidRootPart.Position).Magnitude > 4 then
        for v406, v407 in p115.Original do
            if p115[v406] then
                p115[v406].C0 = v407
                p115[v406].Transform = CFrame.identity
            end
        end

        v400 = true
    end

    if v400 then
        t27[p114] = nil
        t25[p114] = nil
        p115.Punch = nil
        p115.BreakAnim = nil

        local v408 = v82

        pcall(v408, p115)

        local elapsed = os.clock()

        if elapsed - (t35[p114] or 0) > 5 then
            t35[p114] = elapsed
            warn("[BoxingVisuals] put a boxer's joints back (they'd been thrown off the body): " .. p114.Name .. " (" .. table.concat(v399, ","):sub(1, 80) .. ")")
        end
    end

    return v400
end

function t6.ResetRig(p116) -- line: 1646
    -- upvalues: t5 (copy), restoreRig (copy), t25 (copy), t27 (copy)
    local v409 = t5[p116]

    if v409 then
        pcall(restoreRig, p116, v409)

        for v410 in v409.Original or {} do
            local v411 = v409[v410]

            if v411 and v411.Parent then
                v411.Transform = CFrame.identity
            end
        end
    end

    t5[p116] = nil
    t27[p116] = nil
    t25[p116] = nil
end

local t38 = {
    "Head",
    "Torso",
    "Left Arm",
    "Right Arm",
    "Left Leg",
    "Right Leg"
}
local t39 = {}

local function checkVisible(p117) -- line: 1667
    -- upvalues: LocalPlayer (copy), t38 (copy), t39 (copy)
    if p117 ~= LocalPlayer.Character and LocalPlayer:GetAttribute("ReplayPlaying") ~= true and LocalPlayer:GetAttribute("InFrontMenu") ~= true then
        local v412 = false

        for _, v413 in t38 do
            local v414 = p117:FindFirstChild(v413)

            if v414 and v414:IsA("BasePart") then
                if v414.LocalTransparencyModifier > 0.5 then
                    v412 = true
                    v414.LocalTransparencyModifier = 0
                end

                if v414.Transparency > 0.9 then
                    v412 = true
                    v414.Transparency = 0
                end
            end
        end

        if v412 then
            local elapsed = os.clock()

            if elapsed - (t39[p117] or 0) > 5 then
                t39[p117] = elapsed
                warn("[BoxingVisuals] showed a boxer whose body had been left see-through: " .. p117.Name)
            end
        end
    end
end

local n5 = 0
local n6 = 0
local n7 = 0
local elapsed = os.clock()

RunService.PreSimulation:Connect(function(p118) -- line: 1701
    -- upvalues: CollectionService (copy), Players (copy), BoxingConfig (copy), BoxingHitDetection (copy), self (copy), LocalPlayer (copy), t5 (copy), isBoxing (copy), getRig (copy), startStance (copy), stopStance (copy), v82 (ref), v83 (ref), updateRig (copy), t26 (copy), applyHeadSnaps (copy), applyBodyFx (copy), applyMirror (copy), n3 (ref), n4 (ref), rigHolds (copy), checkJoints (copy), checkVisible (copy), n5 (ref), n6 (ref), n7 (ref), elapsed (ref)
    local elapsed2 = os.clock()
    local v415 = workspace:GetAttribute("ProfileVisuals") == true
    local t40 = {}

    table.clear(t26)

    local BoxingNPC = CollectionService:GetTagged("BoxingNPC")

    for _, player in Players:GetPlayers() do
        table.insert(BoxingNPC, player.Character)
    end

    local CurrentCamera = workspace.CurrentCamera
    local v416 = CurrentCamera and CurrentCamera.CFrame.Position

    for _, v417 in BoxingNPC do
        if v417 and v417:IsDescendantOf(workspace) then
            t40[v417] = true

            local v418 = true

            if not v416 or v417 == LocalPlayer.Character then
            else
                local HumanoidRootPart = v417:FindFirstChild("HumanoidRootPart")

                if HumanoidRootPart then
                    local v419 = HumanoidRootPart.Position - v416

                    v418 = v419:Dot(v419) <= 22500
                end
            end

            if v418 and isBoxing(v417) then
                local v420 = getRig(v417)

                if v420 then
                    local v421 = BoxingConfig.StanceOf(v417)

                    if v420.StanceKey ~= v421 then
                        if v420.StanceKey ~= nil then
                            stopStance(v420)
                        end

                        v420.StanceKey = v421
                    end

                    v83(v420)
                    BoxingHitDetection.NoteStance(v417)
                    startStance(v417, v420)
                    updateRig(v417, v420, p118, elapsed2)

                    if BoxingConfig.IsMirrored(v417) then
                        applyMirror(v420)
                    end

                    t26[v417] = true
                end
            elseif t5[v417] then
                local v422 = t5[v417]

                v82(v422)
                v83(v422)

                for v425, v426 in v422.Original do
                    v422[v425].C0 = v426
                end

                stopStance(v422)

                if v422.Stars then
                    v422.Stars:Destroy()
                    v422.Stars = nil
                end

                t5[v417] = nil
            end
        end
    end

    applyBodyFx(elapsed2)
    applyHeadSnaps(elapsed2)

    if v415 then
        n5 += os.clock() - elapsed2
        n6 += 1
        n7 = 0

        for _ in t26 do
            n7 += 1
        end

        if elapsed2 - elapsed >= 1 then
            workspace:SetAttribute("VisualsMs", math.floor(n5 / n6 * 1E+05) / 100)
            workspace:SetAttribute("VisualsRigs", n7)
            n5 = 0
            n6 = 0
            elapsed = elapsed2
        end
    end

    for v430, v431 in t5 do
        if not t40[v430] then
            stopStance(v431)

            if v431.Stars then
                v431.Stars:Destroy()
                v431.Stars = nil
            end

            t5[v430] = nil
        end
    end

    if elapsed2 - n3 >= 0.5 then
        n3 = elapsed2

        for v432, v433 in self do
            local v434 = t5[v433]

            if not v433.Parent or not v434 or not rigHolds(v434, v432) then
                if v432.IsPlaying then
                    v432:Stop(0.2)
                end

                self[v432] = nil
            end
        end
    end

    for v435, v436 in t5 do
        if t26[v435] then
            checkJoints(v435, v436)
        end
    end

    if not (elapsed2 - n4 >= 0.1) then
        return
    end

    n4 = elapsed2

    for v437, v438 in t5 do
        if not t26[v437] then
            checkJoints(v437, v438)
        end
    end

    for _, player in Players:GetPlayers() do
        if player.Character and player.Character:IsDescendantOf(workspace) then
            checkVisible(player.Character)
        end
    end
end)
task.spawn(function() -- line: 1818
    -- upvalues: ContentProvider (copy), BoxingConfig (copy)
    local Folder = Instance.new("Folder")

    Folder.Name = "BoxingSoundCache"
    Folder.Parent = game:GetService("SoundService")

    local t41 = {}

    local function add(p119) -- line: 1823
        -- upvalues: Folder (copy), t41 (copy)
        if type(p119) == "string" and p119 ~= "" and not Folder:FindFirstChild(p119) then
            local Sound = Instance.new("Sound")

            Sound.Name = p119
            Sound.SoundId = p119
            Sound.Volume = 0
            Sound.Parent = Folder
            table.insert(t41, Sound)
        end
    end

    for _, v439 in BoxingConfig.Sounds do
        if type(v439) == "table" then
            for _, v440 in v439 do
                if type(v440) == "string" and v440 ~= "" and not Folder:FindFirstChild(v440) then
                    local Sound = Instance.new("Sound")

                    Sound.Name = v440
                    Sound.SoundId = v440
                    Sound.Volume = 0
                    Sound.Parent = Folder
                    table.insert(t41, Sound)
                end
            end
        elseif type(v439) == "string" and v439 ~= "" and not Folder:FindFirstChild(v439) then
            local Sound = Instance.new("Sound")

            Sound.Name = v439
            Sound.SoundId = v439
            Sound.Volume = 0
            Sound.Parent = Folder
            table.insert(t41, Sound)
        end
    end

    local PreloadAsync = ContentProvider.PreloadAsync

    pcall(PreloadAsync, ContentProvider, t41)
end)

local function playSound(p120, p121, p122, p123) -- line: 1848
    -- upvalues: Debris (copy), BoxingConfig (copy)
    local v441 = BoxingConfig.Sounds[p120]
    local v442 = type(p120) == "string" and string.find(p120, "rbxassetid://", 1, true) == 1

    if v442 then
        v441 = p120
    end

    if type(v441) == "string" and p121 then
        local Sound = Instance.new("Sound")

        Sound.SoundId = v441
        Sound.Volume = p122 or 0.7
        Sound.PlaybackSpeed = if v442 then p123 or 1 else (p123 or 1) * (0.93 + math.random() * 0.14)
        Sound.RollOffMinDistance = 10
        Sound.RollOffMaxDistance = 100
        Sound.Parent = p121
        Sound:Play()
        Sound.Ended:Once(function() -- line: 1865
            -- upvalues: Sound (copy)
            Sound:Destroy()
        end)
        Debris:AddItem(Sound, 8)

        return Sound
    end
end

local function playSoundAt(p124, p125, p126, p127) -- line: 1873
    -- upvalues: Debris (copy), playSound (copy)
    local Attachment = Instance.new("Attachment")

    Attachment.WorldPosition = p125
    Attachment.Parent = workspace.Terrain

    local v444 = playSound(p124, Attachment, p126, p127)

    Debris:AddItem(Attachment, 8)

    if v444 then
        v444.Destroying:Once(function() -- line: 1880
            -- upvalues: Attachment (copy)
            Attachment:Destroy()
        end)
    end

    return v444
end

local function playPunchHit(p128, p129, p130, p131, p132) -- line: 1893
    -- upvalues: Debris (copy), TweenService (copy), BoxingConfig (copy), v16 (copy)
    local Sounds = BoxingConfig.Sounds
    local v445 = p128 and p128.Anim

    if v445 == "Hook" then
        v445 = if p129 == "Head" then "HookHead" else "HookBody"
    end

    local v446 = v445 and Sounds.Hits and Sounds.Hits[v445]

    if not v446 then
        return nil
    end

    local Sound = Instance.new("Sound")

    Sound.SoundId = v446
    Sound.Volume = (Sounds.HitVolume or 1) * (if p132 then BoxingConfig.JamHitVolume or 0.5 else 1)
    Sound.TimePosition = Sounds.HitStart and Sounds.HitStart[v445] or 0

    if (Sounds.HitBass or 0) ~= 0 and not p132 then
        local EqualizerSoundEffect = Instance.new("EqualizerSoundEffect")

        EqualizerSoundEffect.LowGain = Sounds.HitBass
        EqualizerSoundEffect.MidGain = 0
        EqualizerSoundEffect.HighGain = 0
        EqualizerSoundEffect.Parent = Sound
    end

    local Attachment

    if p131 then
        Sound.Parent = game:GetService("SoundService")
    else
        local Attachment2 = Instance.new("Attachment")

        Attachment = Attachment2
        Attachment2.WorldPosition = p130
        Attachment2.Parent = workspace.Terrain
        Sound.RollOffMinDistance = 10
        Sound.RollOffMaxDistance = 100
        Sound.Parent = Attachment2
    end

    local Crack = v16.Crack
    local Sound2, v450

    if Crack and Crack.Id and not p132 then
        Sound2 = Instance.new("Sound")
        Sound2.SoundId = Crack.Id
        v450 = Crack.Volume and Crack.Volume[v445] or 0.25
        Sound2.Volume = v450
        Sound2.PlaybackSpeed = Crack.Speed and Crack.Speed[v445] or 1.5
        Sound2.TimePosition = Crack.Start or 0
        Sound2.RollOffMinDistance = Sound.RollOffMinDistance
        Sound2.RollOffMaxDistance = Sound.RollOffMaxDistance

        local EqualizerSoundEffect = Instance.new("EqualizerSoundEffect")

        EqualizerSoundEffect.LowGain = -24
        EqualizerSoundEffect.MidGain = -2
        EqualizerSoundEffect.HighGain = 4
        EqualizerSoundEffect.Parent = Sound2
        Sound2.Parent = Sound.Parent
        Sound2:Play()

        local delay = task.delay
        local v451 = Crack.Length or 0.12
        local Sound3 = Sound2

        delay(v451, function() -- line: 1943
            -- upvalues: Sound3 (copy), TweenService (copy)
            if Sound3.Parent then
                TweenService:Create(Sound3, TweenInfo.new(0.04), {
                    Volume = 0
                }):Play()
            end
        end)
        Debris:AddItem(Sound2, (Crack.Length or 0.12) + 0.1)
    end

    Sound:Play()
    Sound.Ended:Once(function() -- line: 1951
        -- upvalues: Sound (copy), Attachment (ref)
        Sound:Destroy()

        if Attachment then
            Attachment:Destroy()
        end
    end)
    Debris:AddItem(Sound, 8)

    if Attachment then
        Debris:AddItem(Attachment, 8)
    end

    return Sound
end

local function punchSoundId(p133, p134, p135) -- line: 1965
    if p133 and p134 then
        local Anim = p134.Anim

        if Anim == "Hook" then
            Anim = if p135 == "Head" then "HookHead" else "HookBody"
        end

        return p133[Anim]
    end

    return nil
end

local function playSwing(p136, p137, p138, p139, p140, p141, p142) -- line: 1977
    -- upvalues: BoxingConfig (copy), playSound (copy)
    local HumanoidRootPart = p136:FindFirstChild("HumanoidRootPart")
    local Swings = BoxingConfig.Sounds.Swings
    local v452

    if Swings and p138 then
        local Anim = p138.Anim

        if Anim == "Hook" then
            Anim = if p139 == "Head" then "HookHead" else "HookBody"
        end

        v452 = Swings[Anim]
    end

    if v452 then
        p137.SwingSound = playSound(v452, HumanoidRootPart, p140 * (BoxingConfig.Sounds.SwingVolume or 0.6) / 0.45, p141)
    else
        p137.SwingSound = playSound("Swing", HumanoidRootPart, p140, p142)
    end
end

local function cutSwing(p143) -- line: 1992
    -- upvalues: TweenService (copy), BoxingConfig (copy)
    local v453 = p143 and p143.SwingSound

    if not (v453 and v453.Parent and v453.IsPlaying) then
        return
    end

    p143.SwingSound = nil

    local v454 = v453.Volume * (BoxingConfig.Sounds.SwingDuck or 0)

    TweenService:Create(v453, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Volume = v454
    }):Play()
end

local function playMiss(p144, p145, p146, p147) -- line: 2003
    -- upvalues: Debris (copy), BoxingConfig (copy), LocalPlayer (copy)
    local Miss = BoxingConfig.Sounds.Miss
    local HumanoidRootPart = p144 and p144:FindFirstChild("HumanoidRootPart")

    if not (Miss and p145 and HumanoidRootPart) then
        return nil
    end

    local Anim = p145.Anim

    if Anim == "Hook" then
        Anim = if p146 == "Head" then "HookHead" else "HookBody"
    end

    local v455 = BoxingConfig.MissSoundTuning or {}
    local v456 = v455[Anim] or {}
    local v457 = v455.Vary or 0
    local Sound = Instance.new("Sound")

    Sound.SoundId = Miss
    Sound.Volume = (v456.Volume or 0.6) * (if p147 then v455.Jammed or 0.6 else 1)
    Sound.PlaybackSpeed = (v456.Speed or 1) * (1 - v457 + math.random() * v457 * 2)

    if p144 == LocalPlayer.Character then
        Sound.Parent = game:GetService("SoundService")
    else
        Sound.RollOffMinDistance = 8
        Sound.RollOffMaxDistance = 90
        Sound.Parent = HumanoidRootPart
    end

    Sound:Play()
    Sound.Ended:Once(function() -- line: 2028
        -- upvalues: Sound (copy)
        Sound:Destroy()
    end)
    Debris:AddItem(Sound, 4)

    return Sound
end

local t42 = {}

local function remember(p148) -- line: 2048
    -- upvalues: t42 (copy)
    p148.At = os.clock()
    table.insert(t42, p148)
end

local t43 = {}

local function answerKey(p149, p150, p151) -- line: 2056
    if p149 then
        return "#" .. tostring(p149)
    end

    return tostring(p150) .. "|" .. tostring(p151)
end

local function settle(p152, p153, p154) -- line: 2059
    -- upvalues: t42 (copy), t43 (copy)
    local elapsed = os.clock()

    for i = #t42, 1, -1 do
        if elapsed - t42[i].At > 1 then
            table.remove(t42, i)
        end
    end

    if p152 then
        for v460, v461 in t42 do
            if v461.Id == p152 then
                return table.remove(t42, v460)
            end
        end

        t43["#" .. tostring(p152)] = elapsed
    else
        for i = 1, 2 do
            for v462, v463 in t42 do
                if (i == 2 or v463.Id == nil) and v463.Punch == p154 and (p153 == nil or v463.Target == p153) then
                    return table.remove(t42, v462)
                end
            end
        end

        if p153 ~= nil then
            t43[tostring(p153) .. "|" .. tostring(p154)] = elapsed
        end
    end

    return nil
end

local function alreadyAnswered(p155, p156, p157) -- line: 2089
    -- upvalues: t43 (copy)
    local elapsed = os.clock()

    for v464, v465 in t43 do
        if elapsed - v465 > 1 then
            t43[v464] = nil
        end
    end

    local v466 = if p155 then "#" .. tostring(p155) else tostring(p156) .. "|" .. tostring(p157)

    if not t43[v466] then
        return false
    end

    t43[v466] = nil

    return true
end

local v467, v468

local function findTargetModel(p158) -- line: 2107
    -- upvalues: CollectionService (copy)
    local v469 = p158:FindFirstAncestorOfClass("Model")

    while v469 do
        local Humanoid = v469:FindFirstChildOfClass("Humanoid")

        if Humanoid then
            if CollectionService:HasTag(v469, "TechniqueTree") then
                return nil
            end

            return v469, Humanoid
        end

        v469 = v469.Parent and v469.Parent:FindFirstAncestorOfClass("Model")
    end

    return nil
end

local function predictContact(p159, p160, p161, p162, p163, p164, p165) -- line: 2128
    -- upvalues: CollectionService (copy), BoxingConfig (copy), BoxingHitDetection (copy), RingRopes (copy), playPunchHit (copy), cutSwing (copy), playMiss (copy), t42 (copy), alreadyAnswered (copy), v467 (ref), v468 (ref), findTargetModel (copy)
    local HumanoidRootPart = p159:FindFirstChild("HumanoidRootPart")

    if HumanoidRootPart then
        local v470 = OverlapParams.new()

        v470.FilterType = Enum.RaycastFilterType.Exclude
        v470.FilterDescendantsInstances = { p159 }

        local v471 = HumanoidRootPart.CFrame * CFrame.new(p161.HitboxOffset)
        local t44 = {}

        for _, v472 in workspace:GetPartBoundsInBox(v471, p161.HitboxSize, v470) do
            local v473 = findTargetModel(v472)

            if v473 then
                t44[v473] = v472
            end
        end

        local v474 = BoxingHitDetection.PathFor(p159, p163 or "", p162, p161, p164)
        local v475, v476 = BoxingHitDetection.BroadBox(v474, p161)
        local v477 = next(t44) ~= nil

        if not v477 then
            for _, v478 in workspace:GetPartBoundsInBox(HumanoidRootPart.CFrame * v475, v476 + Vector3.new(3, 3, 3), v470) do
                if findTargetModel(v478) then
                    v477 = true
                    break
                end
            end
        end

        if not v477 then
            for _, v479 in CollectionService:GetTagged("TechniqueTree") do
                local TrunkCollider = v479:FindFirstChild("TrunkCollider")

                if TrunkCollider and (TrunkCollider:GetClosestPointOnSurface(v471.Position) - v471.Position).Magnitude < p161.HitboxSize.Magnitude / 2 + 2 then
                    v477 = true
                    break
                end
            end
        end

        if v477 then
            local Position = (HumanoidRootPart.CFrame * CFrame.new(p161.HitboxOffset.X, p161.HitboxOffset.Y, 0)).Position
            local n8 = 1e999
            local v480

            for v481, v482 in t44 do
                if v481:GetAttribute("PunchingBag") then
                    local Magnitude = (v482:GetClosestPointOnSurface(Position) - Position).Magnitude

                    if Magnitude < n8 then
                        n8 = Magnitude
                        v480 = v481
                    end
                end
            end

            local t45 = {}

            for _, v483 in workspace:GetPartBoundsInBox(HumanoidRootPart.CFrame * v475, v476, v470) do
                local v484, v485 = findTargetModel(v483)

                if v484 and not t45[v484] and v485.Health > 0 then
                    t45[v484] = true

                    if v484:GetAttribute("PunchingBag") then
                        if v484 == v480 then
                            if v484:FindFirstChild("HumanoidRootPart") then
                                if RingRopes.SameSide(p159, v484) then
                                    local v486, v487

                                    if v484:GetAttribute("PunchingBag") then
                                        v486 = t44[v484]
                                        v486 = v486 and v486:GetClosestPointOnSurface(v471.Position)
                                        v487 = p162
                                    else
                                        local v488 = v484:GetAttribute("Blocking") == true and (v484:GetAttribute("GuardZone") or "Body") == p162
                                        local v489 = BoxingHitDetection.Contact(HumanoidRootPart, v474, v484, p162, v488, 0.2, p161)

                                        v486 = v489 and v489.Point
                                        v487 = v489 and v489.Zone or p162
                                    end

                                    if v486 then
                                        if alreadyAnswered(p165, if p165 then nil else v484, p163) then
                                            return nil
                                        end

                                        local HumanoidRootPart2 = v484:FindFirstChild("HumanoidRootPart")
                                        local v491 = HumanoidRootPart2 and ((HumanoidRootPart2.Position - HumanoidRootPart.Position) * Vector3.new(1, 0, 1)).Magnitude or 0
                                        local Blocking = v484:GetAttribute("Blocking")

                                        if not Blocking then
                                            Blocking = v484:GetAttribute("Downed")

                                            if not Blocking then
                                                local v492 = p162 == "Head"
                                                local v493, Weaving

                                                if v492 then
                                                    Weaving = v484:GetAttribute("Weaving")
                                                else
                                                    v493 = v487 == "Head"
                                                end

                                                if v492 and not Weaving or not v492 and not v493 then
                                                    Blocking = if p161.Jammable and v491 < (BoxingConfig.JamRange or 0) then true else (v484:GetAttribute("ProtectedUntil") or 0) > workspace:GetServerTimeNow()
                                                elseif v492 then
                                                    Blocking = Weaving
                                                else
                                                    Weaving = v484:GetAttribute("Weaving")
                                                    Blocking = Weaving or (if p161.Jammable and v491 < (BoxingConfig.JamRange or 0) then true else (v484:GetAttribute("ProtectedUntil") or 0) > workspace:GetServerTimeNow())
                                                end
                                            end
                                        end

                                        if v484:GetAttribute("Blocking") then
                                            local v494 = v467

                                            if v494 then
                                                local v495 = v467

                                                if v495(v484, p159, p161, v487, v486) then
                                                    table.insert(t42, {
                                                        Kind = "Hit",
                                                        Break = true,
                                                        Id = p165,
                                                        Punch = p163,
                                                        Target = v484,
                                                        At = os.clock()
                                                    })

                                                    return v484, v486, true
                                                end
                                            end
                                        end

                                        if not Blocking and playPunchHit(p161, v487, v486, true) then
                                            cutSwing(p160)

                                            local v496 = v468
                                            local v497 = 0

                                            if v496 then
                                                local v498 = v468

                                                v497 = v498(p159, v484, p161, v487, v486, {
                                                    SkipSound = true,
                                                    Bag = v484:GetAttribute("PunchingBag") == true
                                                }) or 0
                                            end

                                            local t48 = {
                                                Kind = "Hit",
                                                Id = p165,
                                                Punch = p163,
                                                Target = v484,
                                                Fx = {
                                                    Until = os.clock() + v497
                                                }
                                            }

                                            if v484:GetAttribute("PunchingBag") then
                                                local function v499() -- line: 2247
                                                    -- upvalues: p159 (copy), p161 (copy), HumanoidRootPart (copy), t44 (copy), Position (copy), v484 (copy), t48 (copy), BoxingConfig (copy)
                                                    local BoxingBagSwing = require(script.Parent:WaitForChild("BoxingBagSwing"))
                                                    local v500 = v484:FindFirstChild("PhysicsPart") or t44[v484]
                                                    local ClosestPointOnSurface = v500:GetClosestPointOnSurface(Position)
                                                    local Magnitude = ((ClosestPointOnSurface - HumanoidRootPart.Position) * Vector3.new(1, 0, 1)).Magnitude
                                                    local v501, v502 = BoxingBagSwing.CleanFor(p161, HumanoidRootPart.CFrame, v500.Position, Magnitude, BoxingConfig.PunchingBag and BoxingConfig.PunchingBag.IdealReach)
                                                    local v503 = BoxingBagSwing.PowerFraction(p159)
                                                    local v504 = BoxingBagSwing.KickFor(p161, v501, v503, v502)

                                                    BoxingBagSwing.Kick(v484, v504)
                                                    BoxingBagSwing.Dent(v484, ClosestPointOnSurface, BoxingBagSwing.DentDepthFor(p161, v503))
                                                    BoxingBagSwing.Thud(v484, ClosestPointOnSurface, p161, v503, v501)
                                                    t48.BagKick = v504
                                                end

                                                if not pcall(v499) then
                                                    t48.BagKick = nil
                                                end
                                            end

                                            t48.At = os.clock()
                                            table.insert(t42, t48)

                                            return v484, v486, false
                                        end
                                    end
                                end
                            else
                                local v505, v506

                                if v484:GetAttribute("PunchingBag") then
                                    v505 = t44[v484]
                                    v505 = v505 and v505:GetClosestPointOnSurface(v471.Position)
                                    v506 = p162
                                else
                                    local v507 = v484:GetAttribute("Blocking") == true and (v484:GetAttribute("GuardZone") or "Body") == p162
                                    local v508 = BoxingHitDetection.Contact(HumanoidRootPart, v474, v484, p162, v507, 0.2, p161)

                                    v505 = v508 and v508.Point
                                    v506 = v508 and v508.Zone or p162
                                end

                                if v505 then
                                    if alreadyAnswered(p165, if p165 then nil else v484, p163) then
                                        return nil
                                    end

                                    local HumanoidRootPart2 = v484:FindFirstChild("HumanoidRootPart")
                                    local v510 = HumanoidRootPart2 and ((HumanoidRootPart2.Position - HumanoidRootPart.Position) * Vector3.new(1, 0, 1)).Magnitude or 0
                                    local Blocking = v484:GetAttribute("Blocking")

                                    if not Blocking then
                                        Blocking = v484:GetAttribute("Downed")

                                        if not Blocking then
                                            if p162 == "Head" or v506 == "Head" then
                                                local Weaving = v484:GetAttribute("Weaving")

                                                Blocking = Weaving or (if p161.Jammable and v510 < (BoxingConfig.JamRange or 0) then true else (v484:GetAttribute("ProtectedUntil") or 0) > workspace:GetServerTimeNow())
                                            else
                                                Blocking = if p161.Jammable and v510 < (BoxingConfig.JamRange or 0) then true else (v484:GetAttribute("ProtectedUntil") or 0) > workspace:GetServerTimeNow()
                                            end
                                        end
                                    end

                                    if v484:GetAttribute("Blocking") then
                                        local v511 = v467

                                        if v511 then
                                            local v512 = v467

                                            if v512(v484, p159, p161, v506, v505) then
                                                table.insert(t42, {
                                                    Kind = "Hit",
                                                    Break = true,
                                                    Id = p165,
                                                    Punch = p163,
                                                    Target = v484,
                                                    At = os.clock()
                                                })

                                                return v484, v505, true
                                            end
                                        end
                                    end

                                    if not Blocking and playPunchHit(p161, v506, v505, true) then
                                        cutSwing(p160)

                                        local v513 = v468
                                        local v514 = 0

                                        if v513 then
                                            local v515 = v468

                                            v514 = v515(p159, v484, p161, v506, v505, {
                                                SkipSound = true,
                                                Bag = v484:GetAttribute("PunchingBag") == true
                                            }) or 0
                                        end

                                        local t52 = {
                                            Kind = "Hit",
                                            Id = p165,
                                            Punch = p163,
                                            Target = v484,
                                            Fx = {
                                                Until = os.clock() + v514
                                            }
                                        }

                                        if v484:GetAttribute("PunchingBag") then
                                            local function v516() -- line: 2247
                                                -- upvalues: p159 (copy), p161 (copy), HumanoidRootPart (copy), t44 (copy), Position (copy), v484 (copy), BoxingConfig (copy), t52 (copy)
                                                local BoxingBagSwing = require(script.Parent:WaitForChild("BoxingBagSwing"))
                                                local v517 = v484:FindFirstChild("PhysicsPart") or t44[v484]
                                                local ClosestPointOnSurface = v517:GetClosestPointOnSurface(Position)
                                                local Magnitude = ((ClosestPointOnSurface - HumanoidRootPart.Position) * Vector3.new(1, 0, 1)).Magnitude
                                                local v518, v519 = BoxingBagSwing.CleanFor(p161, HumanoidRootPart.CFrame, v517.Position, Magnitude, BoxingConfig.PunchingBag and BoxingConfig.PunchingBag.IdealReach)
                                                local v520 = BoxingBagSwing.PowerFraction(p159)
                                                local v521 = BoxingBagSwing.KickFor(p161, v518, v520, v519)

                                                BoxingBagSwing.Kick(v484, v521)
                                                BoxingBagSwing.Dent(v484, ClosestPointOnSurface, BoxingBagSwing.DentDepthFor(p161, v520))
                                                BoxingBagSwing.Thud(v484, ClosestPointOnSurface, p161, v520, v518)
                                                t52.BagKick = v521
                                            end

                                            if not pcall(v516) then
                                                t52.BagKick = nil
                                            end
                                        end

                                        t52.At = os.clock()
                                        table.insert(t42, t52)

                                        return v484, v505, false
                                    end
                                end
                            end
                        end
                    elseif v484:FindFirstChild("HumanoidRootPart") then
                        if RingRopes.SameSide(p159, v484) then
                            local v522, v523

                            if v484:GetAttribute("PunchingBag") then
                                v522 = t44[v484]
                                v522 = v522 and v522:GetClosestPointOnSurface(v471.Position)
                                v523 = p162
                            else
                                local v524 = v484:GetAttribute("Blocking") == true and (v484:GetAttribute("GuardZone") or "Body") == p162
                                local v525 = BoxingHitDetection.Contact(HumanoidRootPart, v474, v484, p162, v524, 0.2, p161)

                                v522 = v525 and v525.Point
                                v523 = v525 and v525.Zone or p162
                            end

                            if v522 then
                                if alreadyAnswered(p165, if p165 then nil else v484, p163) then
                                    return nil
                                end

                                local HumanoidRootPart2 = v484:FindFirstChild("HumanoidRootPart")
                                local v527 = HumanoidRootPart2 and ((HumanoidRootPart2.Position - HumanoidRootPart.Position) * Vector3.new(1, 0, 1)).Magnitude or 0
                                local Blocking = v484:GetAttribute("Blocking")

                                if not Blocking then
                                    Blocking = v484:GetAttribute("Downed")

                                    if not Blocking then
                                        if p162 == "Head" or v523 == "Head" then
                                            local Weaving = v484:GetAttribute("Weaving")

                                            Blocking = Weaving or (if p161.Jammable and v527 < (BoxingConfig.JamRange or 0) then true else (v484:GetAttribute("ProtectedUntil") or 0) > workspace:GetServerTimeNow())
                                        else
                                            Blocking = if p161.Jammable and v527 < (BoxingConfig.JamRange or 0) then true else (v484:GetAttribute("ProtectedUntil") or 0) > workspace:GetServerTimeNow()
                                        end
                                    end
                                end

                                if v484:GetAttribute("Blocking") then
                                    local v528 = v467

                                    if v528 then
                                        local v529 = v467

                                        if v529(v484, p159, p161, v523, v522) then
                                            table.insert(t42, {
                                                Kind = "Hit",
                                                Break = true,
                                                Id = p165,
                                                Punch = p163,
                                                Target = v484,
                                                At = os.clock()
                                            })

                                            return v484, v522, true
                                        end
                                    end
                                end

                                if not Blocking and playPunchHit(p161, v523, v522, true) then
                                    cutSwing(p160)

                                    local v530 = v468
                                    local v531 = 0

                                    if v530 then
                                        local v532 = v468

                                        v531 = v532(p159, v484, p161, v523, v522, {
                                            SkipSound = true,
                                            Bag = v484:GetAttribute("PunchingBag") == true
                                        }) or 0
                                    end

                                    local t56 = {
                                        Kind = "Hit",
                                        Id = p165,
                                        Punch = p163,
                                        Target = v484,
                                        Fx = {
                                            Until = os.clock() + v531
                                        }
                                    }

                                    if v484:GetAttribute("PunchingBag") then
                                        local function v533() -- line: 2247
                                            -- upvalues: p159 (copy), p161 (copy), HumanoidRootPart (copy), t44 (copy), Position (copy), v484 (copy), BoxingConfig (copy), t56 (copy)
                                            local BoxingBagSwing = require(script.Parent:WaitForChild("BoxingBagSwing"))
                                            local v534 = v484:FindFirstChild("PhysicsPart") or t44[v484]
                                            local ClosestPointOnSurface = v534:GetClosestPointOnSurface(Position)
                                            local Magnitude = ((ClosestPointOnSurface - HumanoidRootPart.Position) * Vector3.new(1, 0, 1)).Magnitude
                                            local v535, v536 = BoxingBagSwing.CleanFor(p161, HumanoidRootPart.CFrame, v534.Position, Magnitude, BoxingConfig.PunchingBag and BoxingConfig.PunchingBag.IdealReach)
                                            local v537 = BoxingBagSwing.PowerFraction(p159)
                                            local v538 = BoxingBagSwing.KickFor(p161, v535, v537, v536)

                                            BoxingBagSwing.Kick(v484, v538)
                                            BoxingBagSwing.Dent(v484, ClosestPointOnSurface, BoxingBagSwing.DentDepthFor(p161, v537))
                                            BoxingBagSwing.Thud(v484, ClosestPointOnSurface, p161, v537, v535)
                                            t56.BagKick = v538
                                        end

                                        if not pcall(v533) then
                                            t56.BagKick = nil
                                        end
                                    end

                                    t56.At = os.clock()
                                    table.insert(t42, t56)

                                    return v484, v522, false
                                end
                            end
                        end
                    else
                        local v539, v540

                        if v484:GetAttribute("PunchingBag") then
                            v539 = t44[v484]
                            v539 = v539 and v539:GetClosestPointOnSurface(v471.Position)
                            v540 = p162
                        else
                            local v541 = v484:GetAttribute("Blocking") == true and (v484:GetAttribute("GuardZone") or "Body") == p162
                            local v542 = BoxingHitDetection.Contact(HumanoidRootPart, v474, v484, p162, v541, 0.2, p161)

                            v539 = v542 and v542.Point
                            v540 = v542 and v542.Zone or p162
                        end

                        if v539 then
                            if alreadyAnswered(p165, if p165 then nil else v484, p163) then
                                return nil
                            end

                            local HumanoidRootPart2 = v484:FindFirstChild("HumanoidRootPart")
                            local v544 = HumanoidRootPart2 and ((HumanoidRootPart2.Position - HumanoidRootPart.Position) * Vector3.new(1, 0, 1)).Magnitude or 0
                            local Blocking = v484:GetAttribute("Blocking")

                            if not Blocking then
                                Blocking = v484:GetAttribute("Downed")

                                if not Blocking then
                                    if p162 == "Head" or v540 == "Head" then
                                        local Weaving = v484:GetAttribute("Weaving")

                                        Blocking = Weaving or (if p161.Jammable and v544 < (BoxingConfig.JamRange or 0) then true else (v484:GetAttribute("ProtectedUntil") or 0) > workspace:GetServerTimeNow())
                                    else
                                        Blocking = if p161.Jammable and v544 < (BoxingConfig.JamRange or 0) then true else (v484:GetAttribute("ProtectedUntil") or 0) > workspace:GetServerTimeNow()
                                    end
                                end
                            end

                            if v484:GetAttribute("Blocking") then
                                local v545 = v467

                                if v545 then
                                    local v546 = v467

                                    if v546(v484, p159, p161, v540, v539) then
                                        table.insert(t42, {
                                            Kind = "Hit",
                                            Break = true,
                                            Id = p165,
                                            Punch = p163,
                                            Target = v484,
                                            At = os.clock()
                                        })

                                        return v484, v539, true
                                    end
                                end
                            end

                            if not Blocking and playPunchHit(p161, v540, v539, true) then
                                cutSwing(p160)

                                local v547 = v468
                                local v548 = 0

                                if v547 then
                                    local v549 = v468

                                    v548 = v549(p159, v484, p161, v540, v539, {
                                        SkipSound = true,
                                        Bag = v484:GetAttribute("PunchingBag") == true
                                    }) or 0
                                end

                                local t60 = {
                                    Kind = "Hit",
                                    Id = p165,
                                    Punch = p163,
                                    Target = v484,
                                    Fx = {
                                        Until = os.clock() + v548
                                    }
                                }

                                if v484:GetAttribute("PunchingBag") then
                                    local function v550() -- line: 2247
                                        -- upvalues: p159 (copy), p161 (copy), HumanoidRootPart (copy), t44 (copy), Position (copy), v484 (copy), BoxingConfig (copy), t60 (copy)
                                        local BoxingBagSwing = require(script.Parent:WaitForChild("BoxingBagSwing"))
                                        local v551 = v484:FindFirstChild("PhysicsPart") or t44[v484]
                                        local ClosestPointOnSurface = v551:GetClosestPointOnSurface(Position)
                                        local Magnitude = ((ClosestPointOnSurface - HumanoidRootPart.Position) * Vector3.new(1, 0, 1)).Magnitude
                                        local v552, v553 = BoxingBagSwing.CleanFor(p161, HumanoidRootPart.CFrame, v551.Position, Magnitude, BoxingConfig.PunchingBag and BoxingConfig.PunchingBag.IdealReach)
                                        local v554 = BoxingBagSwing.PowerFraction(p159)
                                        local v555 = BoxingBagSwing.KickFor(p161, v552, v554, v553)

                                        BoxingBagSwing.Kick(v484, v555)
                                        BoxingBagSwing.Dent(v484, ClosestPointOnSurface, BoxingBagSwing.DentDepthFor(p161, v554))
                                        BoxingBagSwing.Thud(v484, ClosestPointOnSurface, p161, v554, v552)
                                        t60.BagKick = v555
                                    end

                                    if not pcall(v550) then
                                        t60.BagKick = nil
                                    end
                                end

                                t60.At = os.clock()
                                table.insert(t42, t60)

                                return v484, v539, false
                            end
                        end
                    end
                end
            end

            table.insert(t42, {
                Kind = "Wait",
                Id = p165,
                Punch = p163,
                At = os.clock()
            })

            return nil
        end

        local v556 = if p165 then alreadyAnswered(p165) else nil

        if not p165 or not v556 then
            table.insert(t42, {
                Kind = "Miss",
                Id = p165,
                Punch = p163,
                At = os.clock()
            })
            playMiss(p159, p161, p162, false)
        end
    else
        table.insert(t42, {
            Kind = "Wait",
            Id = p165,
            Punch = p163,
            At = os.clock()
        })
    end
end

local function v557(p166, p167, p168, p169, p170, p171, p172, p173) -- line: 2274
    -- upvalues: t42 (copy), predictContact (copy)
    if p167.PunchToken == p168 and not p167.PunchJammed then
        predictContact(p166, p167, p169, p170, p171, p172, p173)
    else
        table.insert(t42, {
            Kind = "Wait",
            Id = p173,
            Punch = p171,
            At = os.clock()
        })
    end
end

local t66
local n9 = 0

local function noteLocalPunch(p174, p175, p176, p177) -- line: 2287
    -- upvalues: BoxingPassives (copy), t66 (ref), n9 (ref)
    local elapsed = os.clock()
    local t67 = t66

    t66 = {
        Anim = p175.Anim,
        Side = p175.Side,
        At = elapsed,
        Recovery = (p175.Cooldown or 0.4) * p177
    }

    local Tsubame = BoxingPassives.Values.Tsubame

    if not Tsubame
        or p175.Anim ~= "Uppercut"
        or not t67
        or t67.Anim ~= "Uppercut"
        or t67.Side == p175.Side
        or not (elapsed <= t67.At + t67.Recovery + Tsubame.Window)
        or not (n9 <= elapsed)
        or not BoxingPassives.Has(p174, "Tsubame Gaeshi") then
        return p176
    end

    n9 = elapsed + Tsubame.Cooldown

    local v558 = table.clone(p176)

    v558.GuardBreak = true

    return v558
end

t6.PredictedTechniqueHit = Instance.new("BindableEvent")

local v559

function t6.PredictStrike(p178, p179, p180, p181, p182) -- line: 2311
    -- upvalues: Parent (copy), BoxingConfig (copy), BoxingVFX (copy), BoxingSettings (copy), BoxingHitDetection (copy), LocalPlayer (copy), t5 (copy), t6 (copy), predictContact (copy), v559 (ref)
    local v560 = t5[p178]
    local v561 = BoxingConfig.Punches[p180]

    if not v560 or not v561 or not p182 or p178 ~= LocalPlayer.Character then
        return
    end

    v559 = v559 or require(Parent:WaitForChild("BoxingTechniques"))

    local v562 = table.clone(v561)

    v562.Damage = p182.Damage or v561.Damage
    v562.GuardDamage = (v561.GuardDamage or 10) * (p182.GuardDamage or 1.5)

    if p182.Reach then
        v562.HitboxSize = Vector3.new(v561.HitboxSize.X, v561.HitboxSize.Y, v561.HitboxSize.Z * p182.Reach)
        v562.HitboxOffset = v561.HitboxOffset - Vector3.new(0, 0, v561.HitboxSize.Z * (p182.Reach - 1) / 2)
    end

    if BoxingConfig.IsMirrored(p178) then
        v562.HitboxOffset *= Vector3.new(-1, 1, 1)
        v562.Knockback *= Vector3.new(-1, 1, 1)

        if v561.Side == "Left" then
            v562.Side = "Right"
        elseif v561.Side == "Right" then
            v562.Side = "Left"
        else
            v562.Side = v561.Side
        end
    end

    v562.Jammable = false

    local v566, v567, v568 = predictContact(p178, v560, v562, p181, p180, (BoxingHitDetection.TechniqueOptions(v559.List[p179], p180, p182)))

    if v566 and not v568 then
        t6.PredictedTechniqueHit:Fire(p179, p178, v566, v567)

        local HitVFX = BoxingConfig.HitVFX and BoxingConfig.HitVFX.Techniques and BoxingConfig.HitVFX.Techniques[p179]

        if HitVFX and BoxingSettings.Get("HitFlash") ~= false then
            local HumanoidRootPart = p178:FindFirstChild("HumanoidRootPart")
            local v569 = if HumanoidRootPart then (v567 - HumanoidRootPart.Position) * Vector3.new(1, 0, 1) else Vector3.new(0, 0, 1)
            local v570 = BoxingConfig.HitVFX.TechniqueColors and BoxingConfig.HitVFX.TechniqueColors[p179]

            BoxingVFX.Burst(HitVFX, v567, if v569.Magnitude > 0.001 then v569.Unit else Vector3.new(0, 0, 1), v570, BoxingConfig.HitVFX.TechniqueScale)
        end
    end
end

local function setTrail(p183, p184, p185, p186) -- line: 2350
    -- upvalues: BoxingConfig (copy), BoxingVFX (copy), t5 (copy)
    local UserVFX = BoxingConfig.UserVFX
    local PunchStyle = UserVFX and UserVFX.PunchStyle or "Smear"

    if UserVFX and UserVFX.UseOldPunchLines then
        PunchStyle = "Old"
    end

    local v571 = t5[p183]

    p186 = p186 or v571 and v571.Punch

    local Weight = p186 and p186.Weight or "Light"

    if PunchStyle == "Old" then
        BoxingVFX.SetSpeedLines(p183, p184, p185)
    elseif PunchStyle == "Smear" then
        BoxingVFX.SetPunchSmear(p183, p184, p185, Weight)
    elseif p185 then
        local v573 = p183:FindFirstChild(p184 .. " Arm")

        if v573 then
            local v574 = v573.CFrame * CFrame.new(0, -v573.Size.Y / 2, 0)
            local v575 = CFrame.fromMatrix(v574.Position, -v573.CFrame.UpVector, v573.CFrame.LookVector)

            BoxingVFX.PlayAsset(UserVFX.PunchLines[Weight] or UserVFX.PunchLines.Light, v575, UserVFX.PunchLineCount[Weight], v573)
        end
    end
end

local function loadTrack(p187, p188) -- line: 2379
    local v576 = p187.Tracks[p188]

    if v576 then
        return v576
    end

    local Animator = p187.Humanoid:FindFirstChildOfClass("Animator")

    if not Animator then
        return nil
    end

    local Animation = Instance.new("Animation")

    Animation.AnimationId = p188

    local track = Animator:LoadAnimation(Animation)

    track.Priority = Enum.AnimationPriority.Action3
    track.Looped = false
    p187.Tracks[p188] = track

    return track
end

function t6.Play(p189, p190, p191, p192, p193, p194, p195) -- line: 2405
    -- upvalues: CollectionService (copy), BoxingConfig (copy), BoxingPoses (copy), BoxingCamera (copy), BoxingVFX (copy), BoxingShotgunFX (copy), LocalPlayer (copy), t5 (copy), self2 (copy), self3 (copy), getRig (copy), v82 (ref), startFlicker (copy), v557 (copy), noteLocalPunch (copy), setTrail (copy), loadTrack (copy), v16 (copy)
    local v577, v578

    if type(p194) == "table" then
        if p194.Mode == "Shotgun" then
            v577 = p194
            v578 = true
        elseif type(p194.AnimId) ~= "string" or p194.AnimId == "" then
            v578 = false
        else
            v577 = p194
            v578 = true
        end
    else
        v578 = false
    end

    if not v578 then
        v577 = nil
    end

    local v579 = v577 ~= nil and v577.Mode == "Shotgun"
    local v580 = BoxingConfig.Punches[p190]
    local v581 = v580 and getRig(p189)

    if not v581 then
        return
    end

    local v583 = math.max(tonumber(p191) or 1, 0.3)
    local v584 = math.max(v583, 0.4)
    local v585 = BoxingConfig.PunchZone(p190, v577 and v577.Zone or p192)
    local t68, v586

    if v577 and v577.Points then
        local t69 = {
            Points = v577.Points
        }

        if t69 then
            t68 = t69
            v586 = true
        else
            v586 = false
        end
    else
        v586 = false
    end

    if not v586 then
        t68 = nil
    end

    v581.PunchStart = os.clock()
    v581.PunchSpeed = v584
    v581.PunchZone = v585
    v581.PunchJammed = p193 == true
    v581.PunchToken += 1

    local PunchToken = v581.PunchToken
    local v587, v588, v589 = BoxingConfig.PunchAnimation(p190, v585, p189)
    local v590 = v589 or 1

    if v577 then
        v587 = v577.AnimId or ""
        v588 = tonumber(v577.HitTime) or v588
        v590 = 1
        v581.PunchJammed = false
    end

    local v591 = BoxingConfig.StanceAnimations(p189)
    local v592 = (if v580.Anim == "Cross" then v591.CrossFeint else v591.Feint) or ""
    local PunchJammed = v581.PunchJammed and (v580.Anim == "Jab" or v580.Anim == "Cross") and v592 ~= ""

    if not PunchJammed then
        v592 = v587
    end

    local Side = v580.Side

    if BoxingConfig.IsMirrored(p189) and type(Side) == "string" then
        Side = Side:gsub("Left", "#L#"):gsub("Right", "Left"):gsub("#L#", "Right")
    end

    local v593 = BoxingConfig.StancePunch(p189, p190, v580)
    local v594

    if p190 == "Jab" then
        v594 = not PunchJammed

        if v594 then
            v594 = not v579

            if v594 then
                v594 = v592 == "" and BoxingConfig.HasFlicker(p189)
            end
        end
    else
        v594 = false
    end

    local v595

    if p190 == "Jab" then
        v595 = not PunchJammed

        if v595 then
            v595 = not v579

            if v595 then
                v595 = v592 ~= "" and BoxingConfig.HasFlicker(p189)
            end
        end
    else
        v595 = false
    end

    if PunchJammed then
        v590 = 1
    end

    if v595 then
        v584 = v583
    end

    v82(v581)

    local v596

    if v579 then
        v581.Punch = nil
        v596 = v588 * v584
        BoxingShotgunFX.Jab(p189, v585)
    elseif v594 then
        v584 = v583
        v581.Punch = nil

        if v581.PunchTrack and v581.PunchTrack.IsPlaying then
            v581.PunchTrack:Stop(0.05)
        end

        v596 = v588 * v583
        startFlicker(p189, v581, v585, v596)
    else
        local v597 = false
        local v598 = false
        local v599 = false
        local v600 = false
        local v601 = false

        if v592 == "" then
            v601 = true
        else
            v597 = true
        end

        if v597 then
            v581.Punch = nil
            v596 = v588 * v584

            if p189 == LocalPlayer.Character then
                v599 = true
            else
                v598 = true
            end
        end

        v597 = false

        if v598 then
            if CollectionService:HasTag(p189, "BoxingNPC") then
                v599 = true
            else
                v601 = false
            end
        end

        v598 = false

        local v602

        if v599 then
            v602 = loadTrack(v581, v592)

            if v602 then
                v598 = true
            else
                v597 = true
            end
        end

        v599 = false

        if v598 then
            if v577 then
                v599 = true
            else
                v597 = true
            end
        end

        v598 = false

        if v599 then
            v597 = true
            v602.Priority = Enum.AnimationPriority.Action4
        end

        v599 = false

        if v597 then
            if v602 then
                v599 = true
            else
                v601 = false
            end
        end

        v597 = false

        if v599 then
            if v581.PunchTrack then
                v597 = true
            else
                v598 = true
            end
        end

        v599 = false

        if v597 then
            if v581.PunchTrack == v602 then
                v598 = true
            else
                v599 = true
            end
        end

        v597 = false

        if v599 then
            if v581.PunchTrack.IsPlaying then
                v597 = true
            else
                v598 = true
            end
        end

        v599 = false

        if v597 then
            v598 = true
            v581.PunchTrack:Stop(0.05)
        end

        v597 = false

        if v598 then
            if v577 then
                v597 = true
            else
                v599 = true
            end
        end

        v598 = false

        if v597 then
            if type(v577.AnimNear) == "string" then
                v598 = true
            else
                v599 = true
            end
        end

        v597 = false

        if v598 then
            if v577.AnimNear == "" then
                v599 = true
            else
                v597 = true
            end
        end

        v598 = false

        local v603

        if v597 then
            local v604 = loadTrack(v581, v577.AnimNear)

            if v604 then
                v603 = v604
                v598 = true
            else
                v599 = true
            end
        end

        v597 = false

        if v599 then
            v603 = nil
            v598 = true
        end

        v599 = false

        if v598 then
            if v581.PunchTrackNear then
                v597 = true
            else
                v599 = true
            end
        end

        v598 = false

        if v597 then
            if v581.PunchTrackNear == v603 then
                v599 = true
            else
                v598 = true
            end
        end

        v597 = false

        if v598 then
            if v581.PunchTrackNear == v602 then
                v599 = true
            else
                v597 = true
            end
        end

        v598 = false

        if v597 then
            if v581.PunchTrackNear.IsPlaying then
                v598 = true
            else
                v599 = true
            end
        end

        v597 = false

        if v598 then
            v599 = true
            v581.PunchTrackNear:Stop(0.05)
        end

        v598 = false

        local Snap

        if v599 then
            v581.PunchTrackNear = v603
            self2[v602] = nil
            Snap = v16.Snap

            if Snap then
                v598 = true
            else
                v597 = true
            end
        end

        v599 = false

        if v598 then
            if PunchJammed then
                v597 = true
            else
                v599 = true
            end
        end

        v598 = false

        if v599 then
            if v577 then
                v597 = true
            else
                v598 = true
            end
        end

        v599 = false

        if v598 then
            if (v588 or 0) > 0 then
                v599 = true
            else
                v597 = true
            end
        end

        v598 = false

        if v599 then
            if Snap.Windup < 1 then
                v598 = true
            else
                v597 = true
            end
        end

        v599 = false

        if v598 then
            if Snap.Split / Snap.Windup < 0.95 then
                v599 = true
            else
                v597 = true
            end
        end

        v598 = false

        if v597 then
            if v603 then
                v600 = true
            else
                v598 = true
            end
        end

        v597 = false

        if v598 then
            v597 = true
            v602:Play(0.05, 1, v590 / v584)
        end

        if v600 then
            local v606 = math.clamp(tonumber(v577.Blend) or 1, 0, 1)

            v603.Priority = Enum.AnimationPriority.Action4
            self2[v603] = nil
            v602:Play(0.05, math.max(v606, 0.001), 1 / v584)

            local v607 = 1 - v606

            v597 = true
            v603:Play(0.05, math.max(v607, 0.001), 1 / v584)
        end

        if v599 then
            local v608 = v590 / v584
            local v609 = (1 - Snap.Split) / (1 - Snap.Split / Snap.Windup)

            v602:Play(0.04, 1, v608 * Snap.Windup)

            local delay = task.delay
            local v610 = Snap.Split * v588 * v584 / Snap.Windup
            local v611 = v602

            delay(v610, function() -- line: 2501
                -- upvalues: v581 (copy), PunchToken (copy), v608 (copy), v609 (copy), v611 (copy), self2 (copy), self3 (copy)
                if v581.PunchToken ~= PunchToken or not v611.IsPlaying then
                    return
                end

                local v612 = v608 * v609

                self3[v611] = nil

                if self2[v611] ~= nil then
                    self2[v611] = v612
                else
                    v611:AdjustSpeed(v612)
                end
            end)
            v597 = true
            task.delay(v588 * v584, function() -- line: 2506
                -- upvalues: v581 (copy), PunchToken (copy), v608 (copy), v611 (copy), self2 (copy), self3 (copy)
                if v581.PunchToken ~= PunchToken or not v611.IsPlaying then
                    return
                end

                self3[v611] = nil

                if self2[v611] ~= nil then
                    self2[v611] = v608
                else
                    v611:AdjustSpeed(v608)
                end
            end)
        end

        if v597 then
            v601 = false
            v581.PunchTrack = v602
        end

        if v601 then
            v581.Punch = v580
            v596 = BoxingPoses.ImpactTime(v580.Anim) * v584
        elseif v595 then
            startFlicker(p189, v581, v585, v596, true)
        end
    end

    if p189 == LocalPlayer.Character then
        v581.RecoverFrom = os.clock() + (v588 or v580.HitTime or 0.15) * v584
        v581.RecoverUntil = os.clock() + (v580.Cooldown or 0.4) * v584

        local v614 = (v580.Cooldown or 0.4) * v584
        local PunchTrack, v615

        if v594 or v592 == "" then
            v615 = false
        else
            local PunchTrack2 = v581.PunchTrack

            if PunchTrack2 then
                PunchTrack = PunchTrack2
                v615 = true
            else
                v615 = false
            end
        end

        if not v615 then
            PunchTrack = nil
        end

        if PunchTrack then
            v614 = math.max(v614, if PunchTrack.Length > 0 then PunchTrack.Length * v584 / v590 else 1.5)
        end

        BoxingCamera.LockFacing(v614)

        if (p190 == "Jab" or p190 == "LeftHook" or p190 == "LeftUppercut") and BoxingConfig.ActiveStanceItem(p189) == "HitmanStance" and BoxingCamera.AllowAimSteer then
            BoxingCamera.AllowAimSteer(v614)
        end

        BoxingCamera.PunchPush(v580.Anim, Side, v596)

        if PunchTrack then
            PunchTrack.Stopped:Once(function() -- line: 2554
                -- upvalues: v581 (copy), PunchToken (copy), BoxingCamera (copy)
                if v581.PunchToken == PunchToken then
                    BoxingCamera.ReleaseFacing()
                end
            end)
        end
    end

    local _ = BoxingConfig.Weights[v580.Weight]

    p189:FindFirstChild("HumanoidRootPart")

    if v581.PunchJammed then
        if p189 == LocalPlayer.Character then
            task.delay((v588 or v580.HitTime or 0.15) * v584, v557, p189, v581, PunchToken, v593, v585, p190, t68, p195)
        end
    else
        local UserVFX = BoxingConfig.UserVFX
        local v617, v618, v619

        if UserVFX then
            if (UserVFX.PunchStyle or "Smear") == "Smear" then
                v617 = UserVFX.UseOldPunchLines
                v619 = false
            else
                v618 = false
                v619 = true
            end
        else
            v617 = UserVFX
            v619 = false
        end

        if not v619 then
            v618 = not v617
        end

        BoxingVFX.ArmAura(p189, Side, v596 + 0.15, function() -- line: 2573
            -- upvalues: v581 (copy), PunchToken (copy)
            return v581.PunchToken == PunchToken
        end)

        if not v594 and not v595 then
            if v618 then
                BoxingVFX.DrivePunchSmear(p189, Side, v580.Weight, v596 + 0.15, function() -- line: 2580
                    -- upvalues: v581 (copy), PunchToken (copy)
                    return v581.PunchToken == PunchToken
                end)
            else
                local delay = task.delay
                local v622 = v596 * 0.25
                local Side2 = Side

                delay(v622, function() -- line: 2584
                    -- upvalues: p189 (copy), v580 (copy), v581 (copy), PunchToken (copy), Side2 (copy), setTrail (copy)
                    if v581.PunchToken == PunchToken then
                        setTrail(p189, Side2, true, v580)
                    end
                end)
                task.delay(v596 + 0.06, function() -- line: 2589
                    -- upvalues: p189 (copy), v581 (copy), PunchToken (copy), Side2 (copy), BoxingConfig (copy), BoxingVFX (copy), t5 (copy)
                    if v581.PunchToken ~= PunchToken then
                        return
                    end

                    local UserVFX = BoxingConfig.UserVFX
                    local v623 = UserVFX and UserVFX.PunchStyle or "Smear"

                    if UserVFX and UserVFX.UseOldPunchLines then
                        v623 = "Old"
                    end

                    local v624 = t5[p189]
                    local v625 = v624 and v624.Punch
                    local Weight = v625 and v625.Weight or "Light"

                    if v623 == "Old" then
                        BoxingVFX.SetSpeedLines(p189, Side2, false)
                    elseif v623 == "Smear" then
                        BoxingVFX.SetPunchSmear(p189, Side2, false, Weight)
                    end
                end)
            end
        end

        if p189 == LocalPlayer.Character then
            local v626 = noteLocalPunch(p189, v580, v593, v584)

            task.delay((v588 or v580.HitTime or 0.15) * v584, v557, p189, v581, PunchToken, v626, v585, p190, t68, p195)
        end

        local v627, v628

        if BoxingConfig.HitVFX and BoxingConfig.HitVFX.AirCut then
            local v629 = BoxingConfig.HitVFX.AirCut[v580.Weight]

            if v629 then
                v627 = v629
                v628 = true
            else
                v628 = false
            end
        else
            v628 = false
        end

        if not v628 then
            v627 = 0
        end

        if not (v627 > 0) then
            return
        end

        local delay = task.delay
        local v630 = v596 * 0.9
        local Side2 = Side

        delay(v630, function() -- line: 2604
            -- upvalues: p189 (copy), v581 (copy), PunchToken (copy), v627 (ref), Side2 (copy), BoxingVFX (copy)
            if v581.PunchToken == PunchToken then
                BoxingVFX.AirCut(p189, Side2, v627)
            end
        end)
    end
end

function t6.SetLocalBlocking(p196, p197) -- line: 2612
    -- upvalues: v13 (ref), v14 (ref)
    v13 = p196
    v14 = p197 == "Head" and "Head" or "Body"
end

local n10 = 0
local n11 = (-1e999)
local ColorCorrectionEffect, BlurEffect

local function headHitEffect(p198) -- line: 2623
    -- upvalues: TweenService (copy), BoxingConfig (copy), BoxingCamera (copy), BoxingSettings (copy), n10 (ref), n11 (ref), ColorCorrectionEffect (ref), BlurEffect (ref)
    local HeadHitEffect = BoxingConfig.HeadHitEffect
    local elapsed = os.clock()

    if elapsed - n11 > HeadHitEffect.StackReset then
        n10 = 0
    end

    n11 = elapsed
    n10 += 1

    local v632 = math.min(HeadHitEffect.BaseDuration + HeadHitEffect.PerStack * (n10 - 1), HeadHitEffect.MaxDuration)

    if BoxingSettings.Get("HeadHitBlur") then
        local CurrentCamera = workspace.CurrentCamera

        if not ColorCorrectionEffect or ColorCorrectionEffect.Parent ~= CurrentCamera then
            ColorCorrectionEffect = Instance.new("ColorCorrectionEffect")
            ColorCorrectionEffect.Name = "HeadHitTint"
            ColorCorrectionEffect.Parent = CurrentCamera
            BlurEffect = Instance.new("BlurEffect")
            BlurEffect.Name = "HeadHitBlur"
            BlurEffect.Size = 0
            BlurEffect.Parent = CurrentCamera
        end

        local ColorCorrectionEffect2 = ColorCorrectionEffect

        ColorCorrectionEffect2.TintColor = HeadHitEffect.Tint
        ColorCorrectionEffect.Brightness = 0.08

        local BlurEffect2 = BlurEffect

        BlurEffect2.Size = HeadHitEffect.BlurSize

        local v633 = TweenInfo.new(v632, Enum.EasingStyle.Quad, Enum.EasingDirection.In)

        TweenService:Create(ColorCorrectionEffect, v633, {
            Brightness = 0,
            TintColor = Color3.new(1, 1, 1)
        }):Play()
        TweenService:Create(BlurEffect, v633, {
            Size = 0
        }):Play()
    end

    local v634 = n10

    if v634 >= HeadHitEffect.DazeAfter then
        local v636 = n10
        local v635 = v636 - HeadHitEffect.DazeAfter
        local v638 = math.min(HeadHitEffect.DazeDuration + HeadHitEffect.DazePerStack * v635, HeadHitEffect.DazeMaxDuration)

        BoxingCamera.Daze(v638, (math.min(1, 0.7 + 0.1 * v635)))
    end

    if p198 then
        n10 = 0
    end
end

task.spawn(function() -- line: 2665
    -- upvalues: ContentProvider (copy), BoxingConfig (copy), Animation (copy)
    local t70 = {}

    local function add(p199) -- line: 2667
        -- upvalues: t70 (copy)
        if type(p199) == "string" and p199 ~= "" then
            local Animation = Instance.new("Animation")

            Animation.AnimationId = p199
            table.insert(t70, Animation)
        end
    end

    local Stance = BoxingConfig.Animations.Stance

    if type(Stance) == "string" and Stance ~= "" then
        local Animation = Instance.new("Animation")

        Animation.AnimationId = Stance
        table.insert(t70, Animation)
    end

    local Block = BoxingConfig.Animations.Block

    if type(Block) == "string" and Block ~= "" then
        local Animation = Instance.new("Animation")

        Animation.AnimationId = Block
        table.insert(t70, Animation)
    end

    if type(Animation) == "string" and Animation ~= "" then
        local Animation2 = Instance.new("Animation")

        Animation2.AnimationId = Animation
        table.insert(t70, Animation2)
    end

    for _, v640 in BoxingConfig.Animations.Move or {} do
        if type(v640) == "string" and v640 ~= "" then
            local Animation = Instance.new("Animation")

            Animation.AnimationId = v640
            table.insert(t70, Animation)
        end
    end

    local Feint = BoxingConfig.Animations.Feint

    if type(Feint) == "string" and Feint ~= "" then
        local Animation = Instance.new("Animation")

        Animation.AnimationId = Feint
        table.insert(t70, Animation)
    end

    local CrossFeint = BoxingConfig.Animations.CrossFeint

    if type(CrossFeint) == "string" and CrossFeint ~= "" then
        local Animation = Instance.new("Animation")

        Animation.AnimationId = CrossFeint
        table.insert(t70, Animation)
    end

    for _, v641 in BoxingConfig.Animations.Punches do
        for _, v642 in v641 do
            local Id = v642.Id

            if type(Id) == "string" and Id ~= "" then
                local Animation = Instance.new("Animation")

                Animation.AnimationId = Id
                table.insert(t70, Animation)
            end
        end
    end

    for _, v643 in BoxingConfig.Loadout.Items do
        if v643.Type == "Guard" and v643.Animations then
            local Block = v643.Animations.Block

            if type(Block) == "string" and Block ~= "" then
                local Animation = Instance.new("Animation")

                Animation.AnimationId = Block
                table.insert(t70, Animation)
            end

            for _, v644 in v643.Animations.BlockMove or {} do
                if type(v644) == "string" and v644 ~= "" then
                    local Animation = Instance.new("Animation")

                    Animation.AnimationId = v644
                    table.insert(t70, Animation)
                end
            end
        end

        if v643.FlickerAnim then
            local Id = v643.FlickerAnim.Id

            if type(Id) == "string" and Id ~= "" then
                local Animation = Instance.new("Animation")

                Animation.AnimationId = Id
                table.insert(t70, Animation)
            end
        end

        if v643.Type == "Stance" then
            local v645 = v643.Animations or {}
            local Stance = v645.Stance

            if type(Stance) == "string" and Stance ~= "" then
                local Animation = Instance.new("Animation")

                Animation.AnimationId = Stance
                table.insert(t70, Animation)
            end

            local Block = v645.Block

            if type(Block) == "string" and Block ~= "" then
                local Animation = Instance.new("Animation")

                Animation.AnimationId = Block
                table.insert(t70, Animation)
            end

            local Feint = v645.Feint

            if type(Feint) == "string" and Feint ~= "" then
                local Animation = Instance.new("Animation")

                Animation.AnimationId = Feint
                table.insert(t70, Animation)
            end

            local CrossFeint = v645.CrossFeint

            if type(CrossFeint) == "string" and CrossFeint ~= "" then
                local Animation = Instance.new("Animation")

                Animation.AnimationId = CrossFeint
                table.insert(t70, Animation)
            end

            for _, v646 in v645.Move or {} do
                if type(v646) == "string" and v646 ~= "" then
                    local Animation = Instance.new("Animation")

                    Animation.AnimationId = v646
                    table.insert(t70, Animation)
                end
            end

            for _, v647 in v643.Punches or {} do
                for _, v648 in v647 do
                    local Id = v648.Id

                    if type(Id) == "string" and Id ~= "" then
                        local Animation = Instance.new("Animation")

                        Animation.AnimationId = Id
                        table.insert(t70, Animation)
                    end
                end
            end
        end
    end

    local PreloadAsync = ContentProvider.PreloadAsync

    pcall(PreloadAsync, ContentProvider, t70)
end)

local function effectPart(p200, p201, p202, p203, p204) -- line: 2719
    local Part = Instance.new("Part")

    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.CastShadow = false
    Part.Material = Enum.Material.Neon
    Part.Shape = p204
    Part.Size = p201
    Part.Color = p202
    Part.Transparency = p203
    Part.CFrame = p200
    Part.Parent = workspace

    return Part
end

local function impactEffect(p205, p206, p207, p208, p209, p210, p211, p212, p213, p214) -- line: 2736
    -- upvalues: PQ (copy), Debris (copy), BoxingConfig (copy), BoxingVFX (copy), BoxingSettings (copy), v11 (copy), v12 (copy), playSoundAt (copy), playPunchHit (copy)
    local v649 = BoxingSettings.Get("ZoneHitColors") == true and BoxingConfig.HitVFX and BoxingConfig.HitVFX.ZoneColors

    v649 = v649 and v649[if p210 == "Head" then "Head" else "Body"]

    local v650 = if p208 then v12 else v649 or v11
    local v651 = if p208 then 0.6 else 1
    local v652 = CFrame.lookAt(p205, p205 - p206)
    local v653 = BoxingConfig.HitVFX or {}

    if (BoxingConfig.Impact and BoxingConfig.Impact.ContactStyle) == "Vortex" then
        if p208 then
            BoxingVFX.Burst(v653.Blocked, p205, p206, v12, v653.BlockedScale)
        else
            local v654 = p209 and v653[p209.Anim]
            local Burst = BoxingVFX.Burst

            v654 = v654 and v654[if p210 == "Head" then "Head" else "Body"]
            Burst(v654, p205, p206, v649)

            if p211 then
                BoxingVFX.Burst(v653.Knockdown, p205, p206, nil, v653.KnockdownScale)
            end
        end
    elseif p208 then
        BoxingVFX.Burst(v653.Blocked, p205, p206, v12, v653.BlockedScale)
        BoxingVFX.ImpactLines(p205, v12, 0.55, 8, p206)
    else
        local v655 = p209 and v653[p209.Anim]
        local Burst = BoxingVFX.Burst

        v655 = v655 and v655[if p210 == "Head" then "Head" else "Body"]
        Burst(v655, p205, p206, v649)

        local t71 = {
            Light = 0.75,
            Medium = 1,
            Heavy = 1.3
        }
        local Weight = if p209 then p209.Weight else nil

        if not p209 or not Weight then
            Weight = "Light"
        end

        local v656 = t71[Weight] or 0.75
        local ImpactLines = BoxingVFX.ImpactLines

        if p211 then
            v656 = 1.6
        end

        ImpactLines(p205, v649, v656, p211 and 16 or 12, p206)

        if p211 then
            BoxingVFX.Burst(v653.Knockdown, p205, p206, nil, v653.KnockdownScale)
        end
    end

    local Block = Enum.PartType.Block
    local Part = Instance.new("Part")

    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.CastShadow = false
    Part.Material = Enum.Material.Neon
    Part.Shape = Block
    Part.Size = Vector3.new(0.2, 0.2, 0.2)
    Part.Color = v650
    Part.Transparency = 1
    Part.CFrame = v652
    Part.Parent = workspace

    local v657

    if (BoxingConfig.Impact and BoxingConfig.Impact.ContactStyle) == "Vortex" then
        Part.Transparency = 1
        v657 = setmetatable({
            Sparks = 0
        }, {
            __index = p207
        })
    else
        v657 = p207
    end

    local Attachment = Instance.new("Attachment")

    Attachment.Parent = Part

    local ParticleEmitter = Instance.new("ParticleEmitter")

    ParticleEmitter.Texture = "rbxasset://textures/particles/sparkles_main.dds"
    ParticleEmitter.Color = ColorSequence.new(v650)
    ParticleEmitter.LightEmission = 1
    ParticleEmitter.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0, v651 * 0.45),
        NumberSequenceKeypoint.new(1, 0)
    })
    ParticleEmitter.Lifetime = NumberRange.new(0.12, 0.28)
    ParticleEmitter.Speed = NumberRange.new(14, 26)
    ParticleEmitter.Drag = 6
    ParticleEmitter.SpreadAngle = Vector2.new(55, 55)
    ParticleEmitter.EmissionDirection = Enum.NormalId.Front
    ParticleEmitter.Rate = 0
    ParticleEmitter.Parent = Attachment

    local v658 = BoxingSettings.Get("VFX") ~= false

    if v658 then
        ParticleEmitter:Emit((PQ((math.floor(v657.Sparks * v651)))))
    else
        Part.Transparency = 1
    end

    if not p208 and v658 then
        local ParticleEmitter = Instance.new("ParticleEmitter")

        ParticleEmitter.Texture = "rbxasset://textures/particles/smoke_main.dds"
        ParticleEmitter.Color = ColorSequence.new(Color3.fromRGB(230, 230, 230))
        ParticleEmitter.Transparency = NumberSequence.new(0.55, 1)
        ParticleEmitter.Size = NumberSequence.new(0.6, v657.RingSize * 0.5)
        ParticleEmitter.Lifetime = NumberRange.new(0.25, 0.4)
        ParticleEmitter.Speed = NumberRange.new(2, 5)
        ParticleEmitter.SpreadAngle = Vector2.new(180, 180)
        ParticleEmitter.Rate = 0
        ParticleEmitter.Parent = Attachment
        ParticleEmitter:Emit((PQ(3)))
    end

    local v660 = not p208

    if v660 then
        local Hits = BoxingConfig.Sounds.Hits

        if Hits and p209 then
            local Anim = p209.Anim

            if Anim == "Hook" then
                Anim = if p210 == "Head" then "HookHead" else "HookBody"
            end

            v660 = Hits[Anim]
        else
            v660 = nil
        end
    end

    if not p212 then
        if v660 then
            playPunchHit(p209, p210, p205, p213, p214)
        else
            playSoundAt(if p208 then "BlockedHit" else v657.Sound, p205, v657.Volume * (if p214 then BoxingConfig.JamHitVolume or 0.5 else 1), p208 and 1.1 or 1)
        end
    end

    Debris:AddItem(Part, 2)
end

local function flash(p215, p216, p217) -- line: 2830
    -- upvalues: Debris (copy), TweenService (copy), BoxingSettings (copy), v12 (copy)
    if not BoxingSettings.Get("HitFlash") then
        return
    end

    local Highlight = Instance.new("Highlight")

    Highlight.FillColor = if p216 then v12 else Color3.new(1, 1, 1)
    Highlight.OutlineColor = Color3.new(0, 0, 0)
    Highlight.DepthMode = Enum.HighlightDepthMode.Occluded
    Highlight.Adornee = p215
    Highlight.Parent = p215

    local v664 = p217 and not p216

    Highlight.FillTransparency = v664 and 0 or 0.3
    Highlight.OutlineTransparency = v664 and 0 or 1

    local v665 = if v664 then 0.05 else 0

    task.delay(v665, function() -- line: 2844
        -- upvalues: Highlight (copy), TweenService (copy)
        if Highlight.Parent then
            TweenService:Create(Highlight, TweenInfo.new(0.18), {
                FillTransparency = 1,
                OutlineTransparency = 1
            }):Play()
        end
    end)
    Debris:AddItem(Highlight, v665 + 0.2)
end

local function punchTravel(p218, p219, p220) -- line: 2855
    -- upvalues: BoxingConfig (copy)
    local HumanoidRootPart = p218 and p218:FindFirstChild("HumanoidRootPart")
    local v666

    if HumanoidRootPart then
        local v667 = (p220 - HumanoidRootPart.Position) * Vector3.new(1, 0, 1)

        if v667.Magnitude < 0.001 then
            v667 = HumanoidRootPart.CFrame.LookVector * Vector3.new(1, 0, 1)
        end

        v666 = if v667.Magnitude > 0.001 then v667.Unit else Vector3.new(0, 0, 1)
    else
        v666 = Vector3.new(0, 0, 1)
    end

    if p219 and p219.Anim == "Uppercut" then
        return (v666 + Vector3.new(0, 1.5, 0)).Unit, nil
    end

    if not p219 or p219.Anim ~= "Hook" then
        return v666, nil
    end

    local Unit = v666:Cross((Vector3.new(0, 1, 0))).Unit
    local Side = p219.Side

    if p218 and BoxingConfig.IsMirrored(p218) and type(Side) == "string" then
        Side = Side:gsub("Left", "#L#"):gsub("Right", "Left"):gsub("#L#", "Right")
    end

    if Side ~= "Left" then
        Unit = -Unit
    end

    return (Unit + v666 * 0.55).Unit, (Unit - v666 * 0.35).Unit
end

local n12 = 0

v468 = function(p221, p222, p223, p224, p225, p226) -- line: 2884
    -- upvalues: BoxingConfig (copy), BoxingCamera (copy), BoxingVFX (copy), BoxingSettings (copy), LocalPlayer (copy), t5 (copy), freezeTracks (copy), hitStopFor (copy), impactEffect (copy), flash (copy), punchTravel (copy), n12 (ref), v16 (copy)
    local v668 = p226

    p226 = p226 or {}
    v668 = p226

    local v670 = BoxingConfig.Weights[p223 and p223.Weight or "Light"] or BoxingConfig.Weights.Light
    local v671, v672 = punchTravel(p221, p223, p225)
    local Anim = p223 and p223.Anim or "Jab"
    local v673 = (v16.Tier or {})[Anim] or 1
    local v674 = p226.Counter and not p226.Blocked or p226.KnockedDown
    local v675 = p221 == LocalPlayer.Character or p222 == LocalPlayer.Character

    if p221 == LocalPlayer.Character and not p226.Bag then
        BoxingCamera.PunchLanded()
    end

    impactEffect(p225, v671, v670, p226.Blocked, p223, p224, p226.KnockedDown, p226.SkipSound, v675, p226.Close)

    if p226.Counter and not p226.Blocked and not p226.Bag and BoxingConfig.HitVFX and BoxingConfig.HitVFX.Counter then
        BoxingVFX.Burst(BoxingConfig.HitVFX.Counter, p225, v671, nil, BoxingConfig.HitVFX.CounterScale)
    end

    local v676 = not p226.Bag and p222 and p222:FindFirstChild("HumanoidRootPart")
    local v677

    if v676 and p224 == "Body" then
        local v678 = v671 * Vector3.new(1, 0, 1)
        local v679 = if v678.Magnitude > 0.001 then v678.Unit else -v676.CFrame.LookVector

        v677 = v676.Position + v679 * 0.7 + Vector3.new(0, 1, 0)
    end

    BoxingVFX.AnimeImpact(p225, v671, {
        Kind = Anim,
        Zone = p224,
        Tier = v673,
        Boost = v674,
        Blocked = p226.Blocked,
        SweepTo = v672,
        Exit = v677
    })

    if not (p226.Blocked or p226.Bag) then
        BoxingVFX.HitWind(p225, v671, p223 and p223.Weight or "Light", v674)
    end

    if not p226.Bag then
        flash(p222, p226.Blocked, v673 >= 3 or v674)
    end

    local v681 = hitStopFor(p223, p226.Blocked, p226.Counter, p226.KnockedDown)

    if p226.Bag then
        v681 *= v16.HitStopBag or 0.6
    end

    if v681 > 0 then
        local v682 = p221 and t5[p221]

        if v682 and v682.Punch then
            v682.PunchStart += v681
        end

        freezeTracks(p221, v681)

        if not p226.Bag and p222 ~= p221 then
            freezeTracks(p222, v681)
        end
    end

    if v675 then
        local v683 = ((v16.Jolt or {})[Anim] or 0.15) * (if p222 == LocalPlayer.Character then v16.JoltTaken or 1 else v16.JoltThrown or 0.6)

        if p226.Blocked then
            v683 *= 0.5
        elseif p226.KnockedDown then
            v683 *= 1.6
        end

        if p226.Bag then
            v683 *= 0.7
        end

        BoxingCamera.Jolt(v671, v683)

        local function v684() -- line: 2959
            -- upvalues: v668 (ref), p222 (copy), v673 (copy), v674 (copy), LocalPlayer (copy)
            local BoxingVirtualInput = require(script.Parent:WaitForChild("BoxingVirtualInput"))

            if p222 ~= LocalPlayer.Character or v668.Bag then
                BoxingVirtualInput.Vibrate(v668.Blocked and 0.12 or 0.2, 0.07)
            else
                local v685 = if v668.KnockedDown then 1
                    elseif v668.Blocked then 0.25
                    elseif v673 >= 3 or v674 then 0.7
                    else 0.45

                BoxingVirtualInput.Vibrate(v685, v668.KnockedDown and 0.5 or 0.14)
            end
        end

        pcall(v684)

        if p222 == LocalPlayer.Character and not v668.Bag then
            BoxingCamera.HitKick(Anim, p224, v671, v668.Blocked)
        end

        if not (v668.Blocked or v668.Bag or v668.KnockedDown or not (v673 >= 3) and not v674) then
            BoxingVFX.FovKick(v16.HeavyZoom or -3)

            local elapsed = os.clock()
            local MangaFrame, v687

            if v16.ImpactFrame ~= false and BoxingSettings.Get("HitFlash") and elapsed - n12 > 0.4 then
                n12 = elapsed
                MangaFrame = BoxingVFX.MangaFrame
                v687 = if v674 then 1 else 0.6
                MangaFrame(v687)
            end
        end
    end

    return v681
end

local function damageNumber(p227, p228, p229, p230) -- line: 2983
    -- upvalues: Debris (copy), TweenService (copy), BoxingConfig (copy), v12 (copy)
    if not p230 and not BoxingConfig.ShowDamageNumbers then
        return
    end

    local v688 = p227:FindFirstChild("Head") or p227:FindFirstChild("HumanoidRootPart")

    if v688 then
        local BillboardGui = Instance.new("BillboardGui")

        if p230 then
            BillboardGui.Size = UDim2.fromOffset(260, 60)
        else
            BillboardGui.Size = UDim2.fromOffset(140, 40)
        end

        BillboardGui.StudsOffset = Vector3.new(math.random(-10, 10) / 10, 2.2, 0)
        BillboardGui.AlwaysOnTop = true
        BillboardGui.Adornee = v688

        local TextLabel = Instance.new("TextLabel")

        TextLabel.BackgroundTransparency = 1
        TextLabel.Size = UDim2.fromScale(1, 1)
        TextLabel.Font = Enum.Font.GothamBlack
        TextLabel.TextScaled = true

        if p230 then
            TextLabel.Text = "KNOCKDOWN!"
        elseif p229 then
            TextLabel.Text = ("-%* BLOCKED"):format(p228)
        else
            TextLabel.Text = ("-%*"):format(p228)
        end

        if p230 then
            TextLabel.TextColor3 = Color3.fromRGB(255, 70, 60)
        elseif p229 then
            TextLabel.TextColor3 = v12
        elseif p228 >= 12 then
            TextLabel.TextColor3 = Color3.fromRGB(255, 200, 60)
        else
            TextLabel.TextColor3 = Color3.new(1, 1, 1)
        end

        local UIStroke = Instance.new("UIStroke")

        UIStroke.Thickness = 2
        UIStroke.Parent = TextLabel
        TextLabel.Parent = BillboardGui

        local UIScale = Instance.new("UIScale")

        if p230 then
            UIScale.Scale = 2.2
        elseif p228 >= 12 then
            UIScale.Scale = 1.8
        else
            UIScale.Scale = 1.5
        end

        UIScale.Parent = TextLabel
        BillboardGui.Parent = v688
        TweenService:Create(UIScale, TweenInfo.new(0.16, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Scale = 1
        }):Play()

        local v692 = Vector3.new(math.random(-6, 6) / 10, if p230 then 2 else 1.5, 0)
        local v693 = TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local v694 = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.In, 0, false, 0.45)

        TweenService:Create(BillboardGui, v693, {
            StudsOffset = BillboardGui.StudsOffset + v692
        }):Play()
        TweenService:Create(TextLabel, v694, {
            TextTransparency = 1
        }):Play()
        TweenService:Create(UIStroke, v694, {
            Transparency = 1
        }):Play()
        Debris:AddItem(BillboardGui, 0.85)
    end
end

local v695 = Color3.fromRGB(170, 210, 255)
local t74 = { "Head", "Torso", "Left Arm", "Right Arm", "Left Leg", "Right Leg" }

local function afterimage(p231) -- line: 3035
    -- upvalues: Debris (copy), TweenService (copy), v695 (copy), t74 (copy)
    for _, v696 in t74 do
        local v697 = p231:FindFirstChild(v696)

        if v697 then
            local CFrame, Size = v697.CFrame, v697.Size
            local Block = Enum.PartType.Block
            local Part = Instance.new("Part")

            Part.Anchored = true
            Part.CanCollide = false
            Part.CanQuery = false
            Part.CanTouch = false
            Part.CastShadow = false
            Part.Material = Enum.Material.Neon
            Part.Shape = Block
            Part.Size = Size
            Part.Color = v695
            Part.Transparency = 0.55
            Part.CFrame = CFrame
            Part.Parent = workspace
            Part.Material = Enum.Material.ForceField
            TweenService:Create(Part, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Transparency = 1
            }):Play()
            Debris:AddItem(Part, 0.32)
        end
    end
end

local self4 = setmetatable({}, {
    __mode = "k"
})

local function playDodgeSound(p232) -- line: 3052
    -- upvalues: BoxingConfig (copy), playSound (copy), self4 (copy)
    local ExtraSounds = BoxingConfig.ExtraSounds
    local v699 = p232 and (p232:FindFirstChild("Head") or p232:FindFirstChild("HumanoidRootPart"))

    if ExtraSounds and ExtraSounds.Dodge and v699 then
        local elapsed = os.clock()

        if not (self4[p232] and elapsed - self4[p232] < 0.25) then
            self4[p232] = elapsed
            playSound(ExtraSounds.Dodge, v699, ExtraSounds.DodgeVolume or 1, 0.95 + math.random() * 0.1)
        end

        return true
    end

    return false
end

function t6.DodgeEffect(p233, _, p235) -- line: 3069
    -- upvalues: Debris (copy), TweenService (copy), playSound (copy), afterimage (copy)
    afterimage(p233)
    playSound("Swing", p233:FindFirstChild("HumanoidRootPart"), 0.5, 1.3)

    local DodgeHighlight = p233:FindFirstChild("DodgeHighlight")

    if DodgeHighlight then
        DodgeHighlight:Destroy()
    end

    local Highlight = Instance.new("Highlight")

    Highlight.Name = "DodgeHighlight"
    Highlight.FillColor = Color3.new(1, 1, 1)
    Highlight.OutlineColor = Color3.new(1, 1, 1)
    Highlight.FillTransparency = 1
    Highlight.OutlineTransparency = 0
    Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    Highlight.Adornee = p233
    Highlight.Parent = p233

    local v700 = p235 == "HeadSlip" or p235 == "IFrame"

    TweenService:Create(Highlight, TweenInfo.new(if v700 then 0.3 else 0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.In, 0, false, v700 and 0.1 or 0.65), {
        FillTransparency = 1,
        OutlineTransparency = 1
    }):Play()
    Debris:AddItem(Highlight, 1.05)
end

local function slowTracks(p236, p237, p238) -- line: 3098
    -- upvalues: Players (copy), LocalPlayer (copy), self2 (copy)
    if p236 ~= nil and (p236 == LocalPlayer.Character or Players:GetPlayerFromCharacter(p236) == nil) then
        local Humanoid = p236:FindFirstChildOfClass("Humanoid")
        local Animator = Humanoid and Humanoid:FindFirstChildOfClass("Animator")

        if not Animator then
            return
        end

        local t77 = {}

        for _, v703 in Animator:GetPlayingAnimationTracks() do
            if self2[v703] == nil and v703.Speed > 0 then
                local Speed = v703.Speed

                v703:AdjustSpeed(Speed * p237)
                table.insert(t77, {
                    v703,
                    Speed
                })
            end
        end

        task.delay(p238, function() -- line: 3115
            -- upvalues: p237 (copy), t77 (copy), self2 (copy)
            for _, v704 in t77 do
                local v705 = v704[1]
                local v706 = v704[2]

                if v705.IsPlaying and self2[v705] == nil and math.abs(v705.Speed - v706 * p237) < 0.001 then
                    v705:AdjustSpeed(v706)
                end
            end
        end)
    end
end

local function slowMoScreen(p239) -- line: 3127
    -- upvalues: TweenService (copy)
    local Lighting = game:GetService("Lighting")
    local SlipCounterSlowMo = Lighting:FindFirstChild("SlipCounterSlowMo")

    if not SlipCounterSlowMo then
        SlipCounterSlowMo = Instance.new("ColorCorrectionEffect")
        SlipCounterSlowMo.Name = "SlipCounterSlowMo"
        SlipCounterSlowMo.Parent = Lighting
    end

    local v708 = (SlipCounterSlowMo:GetAttribute("Token") or 0) + 1

    SlipCounterSlowMo:SetAttribute("Token", v708)
    TweenService:Create(SlipCounterSlowMo, TweenInfo.new(0.08), {
        Saturation = -0.55,
        Contrast = 0.12,
        TintColor = Color3.fromRGB(222, 232, 255)
    }):Play()
    task.delay(p239, function() -- line: 3138
        -- upvalues: SlipCounterSlowMo (ref), v708 (copy), TweenService (copy)
        if SlipCounterSlowMo.Parent and SlipCounterSlowMo:GetAttribute("Token") == v708 then
            TweenService:Create(SlipCounterSlowMo, TweenInfo.new(0.2), {
                Saturation = 0,
                Contrast = 0,
                TintColor = Color3.new(1, 1, 1)
            }):Play()
        end
    end)
end

function t6.PerfectStunEffect(p240, p241, p242) -- line: 3147
    -- upvalues: Debris (copy), TweenService (copy), BoxingVFX (copy), BoxingSettings (copy), LocalPlayer (copy), playSound (copy)
    local HumanoidRootPart = p241 and p241:FindFirstChild("HumanoidRootPart")

    if not HumanoidRootPart then
        return
    end

    local v709 = tonumber(p242) or 0.6
    local v710 = Color3.fromRGB(255, 205, 70)
    local Highlight = Instance.new("Highlight")

    Highlight.Name = "PerfectStunHighlight"
    Highlight.FillColor = v710
    Highlight.FillTransparency = 0.55
    Highlight.OutlineColor = v710
    Highlight.OutlineTransparency = 0
    Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    Highlight.Adornee = p241
    Highlight.Parent = p241
    TweenService:Create(Highlight, TweenInfo.new(v709, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        FillTransparency = 1,
        OutlineTransparency = 1
    }):Play()
    Debris:AddItem(Highlight, v709 + 0.1)

    if BoxingSettings.Get("VFX") ~= false then
        local v711 = CFrame.new(HumanoidRootPart.Position - Vector3.new(0, 2.6, 0)) * CFrame.Angles(0, 0, 1.5707963267948966)
        local Cylinder = Enum.PartType.Cylinder
        local Part = Instance.new("Part")

        Part.Anchored = true
        Part.CanCollide = false
        Part.CanQuery = false
        Part.CanTouch = false
        Part.CastShadow = false
        Part.Material = Enum.Material.Neon
        Part.Shape = Cylinder
        Part.Size = Vector3.new(0.15, 1.5, 1.5)
        Part.Color = v710
        Part.Transparency = 0.15
        Part.CFrame = v711
        Part.Parent = workspace
        TweenService:Create(Part, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = Vector3.new(0.15, 10, 10),
            Transparency = 1
        }):Play()
        Debris:AddItem(Part, 0.4)
    end

    local Head = p241:FindFirstChild("Head")

    if Head then
        BoxingVFX.Burst("V2_Stun", Head.Position + Vector3.new(0, 1.1, 0), (Vector3.new(0, 1, 0)))
    end

    playSound("GuardBreak", HumanoidRootPart, 0.9, 1.3)

    if p240 == LocalPlayer.Character then
        BoxingVFX.FovKick(-8)
    end
end

function t6.PerfectDodgeEffect(p243, p244) -- line: 3187
    -- upvalues: Debris (copy), TweenService (copy), BoxingConfig (copy), BoxingVFX (copy), BoxingPassives (copy), LocalPlayer (copy), t6 (copy), playSound (copy), afterimage (copy), playDodgeSound (copy), slowTracks (copy), slowMoScreen (copy)
    local v712 = BoxingConfig.PerfectDodge or {}
    local PerfectDodgeHighlight = p243:FindFirstChild("PerfectDodgeHighlight")

    if PerfectDodgeHighlight then
        PerfectDodgeHighlight:Destroy()
    end

    local Highlight = Instance.new("Highlight")

    Highlight.Name = "PerfectDodgeHighlight"
    Highlight.FillTransparency = 1
    Highlight.OutlineColor = v712.OutlineColor or Color3.new(1, 1, 1)
    Highlight.OutlineTransparency = 0
    Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    Highlight.Adornee = p243
    Highlight.Parent = p243

    local v713 = v712.OutlineTime or 0.7

    TweenService:Create(Highlight, TweenInfo.new(v713 * 0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In, 0, false, v713 * 0.6), {
        OutlineTransparency = 1
    }):Play()
    Debris:AddItem(Highlight, v713 + 0.1)
    afterimage(p243)

    local HumanoidRootPart = p243:FindFirstChild("HumanoidRootPart")

    if HumanoidRootPart then
        local HumanoidRootPart2 = p244 and p244:FindFirstChild("HumanoidRootPart")
        local v714 = if HumanoidRootPart2 then (HumanoidRootPart.Position - HumanoidRootPart2.Position) * Vector3.new(1, 0, 1) else HumanoidRootPart.CFrame.LookVector

        BoxingVFX.Burst("V2_Slip", HumanoidRootPart.Position + Vector3.new(0, 0.8, 0), if v714.Magnitude > 0.001 then v714.Unit else Vector3.new(0, 0, 1))
    end

    if not playDodgeSound(p243) then
        playSound("Swing", p243:FindFirstChild("HumanoidRootPart"), 0.7, 0.8)
    end

    if p243 == LocalPlayer.Character then
        BoxingVFX.FovKick(-6)
    end

    if p244 then
        t6.CancelPunch(p244)
    end

    local SlowTime = BoxingPassives.Values.PerfectStun and BoxingPassives.Values.PerfectStun.SlowTime or 0.45

    if p244 then
        slowTracks(p244, 0.3, SlowTime)
    end

    if p243 == LocalPlayer.Character then
        slowMoScreen(SlowTime)
        playSound("Swing", p243:FindFirstChild("HumanoidRootPart"), 0.6, 0.5)
    end
end

function t6.CanCancelRecovery(p245) -- line: 3238
    -- upvalues: BoxingConfig (copy), BoxingStatEffects (copy), LocalPlayer (copy), t5 (copy)
    local v715 = t5[p245]
    local PunchCancel = BoxingConfig.PunchCancel

    if not v715 or not PunchCancel or not PunchCancel.Enabled or not v715.RecoverFrom or p245 ~= LocalPlayer.Character then
        return false
    end

    local elapsed = os.clock()

    if v715.RecoverFrom <= elapsed and elapsed < (v715.RecoverUntil or 0) then
        return (p245:GetAttribute("Stamina") or 0) >= (PunchCancel.Stamina or 4) * BoxingStatEffects.StaminaCostMultiplier(p245)
    end

    return false
end

function t6.PunchBusy(p246) -- line: 3251
    -- upvalues: t5 (copy)
    local v716 = t5[p246]

    if v716 == nil or v716.RecoverUntil == nil then
        return false
    end

    return os.clock() < v716.RecoverUntil
end

function t6.CancelRecovery(p247) -- line: 3256
    -- upvalues: BoxingCamera (copy), BoxingRemote (copy), LocalPlayer (copy), t5 (copy), t6 (copy), v82 (ref)
    if not t6.CanCancelRecovery(p247) then
        return false
    end

    local v717 = t5[p247]

    v717.RecoverFrom = nil
    v717.RecoverUntil = nil
    v717.PunchToken += 1
    v717.Punch = nil

    local PunchTrack = v717.PunchTrack

    if PunchTrack and PunchTrack.IsPlaying then
        PunchTrack:Stop(0.08)
    end

    if v717.PunchTrackNear and v717.PunchTrackNear.IsPlaying then
        v717.PunchTrackNear:Stop(0.08)
    end

    v82(v717)
    BoxingCamera.ReleaseFacing()
    LocalPlayer:SetAttribute("PunchLockedUntil", 0)
    LocalPlayer:SetAttribute("PunchSlowUntil", 0)
    BoxingRemote:FireServer("CancelRecovery")

    return true
end

function t6.CancelPunch(p248) -- line: 3280
    -- upvalues: CollectionService (copy), LocalPlayer (copy), t5 (copy), cutSwing (copy)
    local v718 = t5[p248]

    if not v718 then
        return
    end

    v718.PunchToken += 1
    v718.Punch = nil

    local PunchTrack = v718.PunchTrack

    if PunchTrack and PunchTrack.IsPlaying and (p248 == LocalPlayer.Character or CollectionService:HasTag(p248, "BoxingNPC")) then
        PunchTrack:Stop(0.12)
    end

    cutSwing(v718)
end

function t6.Feint(p249, p250, p251, p252) -- line: 3300
    -- upvalues: BoxingConfig (copy), playSound (copy)
    local v719 = BoxingConfig.Animations or {}
    local v720 = p251 and BoxingConfig.Punches[p251]
    local Humanoid = p249 and p249:FindFirstChildOfClass("Humanoid")
    local Animator = Humanoid and Humanoid:FindFirstChildOfClass("Animator")

    if not Animator then
        return
    end

    local v721, v722, v723

    if v720 and (v720.Anim == "Hook" or v720.Anim == "Uppercut") then
        local PunchAnimation = BoxingConfig.PunchAnimation
        local v724 = BoxingConfig.PunchZone(p251, p252 or "Head")
        local v725, v726, v727 = pcall(PunchAnimation, p251, v724, p249)

        if not v725 or type(v726) ~= "string" or v726 == "" then
            v723 = 1.3
        else
            local v728 = tonumber(v727) or v720.HitTime or 0.2

            v721 = v726
            v722 = math.max(0.06, v728 * 0.45)
            v723 = 1
        end
    else
        v723 = 1.3
    end

    if not v721 then
        v721 = if p250 == "Right" then v719.CrossFeint else v719.Feint
    end

    if type(v721) == "string" and v721 ~= "" then
        local Animation = Instance.new("Animation")

        Animation.AnimationId = v721

        local LoadAnimation = Animator.LoadAnimation
        local ok, result = pcall(LoadAnimation, Animator, Animation)

        if ok and result then
            result.Priority = Enum.AnimationPriority.Action4
            result.Looped = false
            result:Play(0.05, 1, v723)

            if v722 then
                task.delay(v722, function() -- line: 3330
                    -- upvalues: result (copy)
                    if result.IsPlaying then
                        result:Stop(0.18)
                    end
                end)
            end
        end

        playSound("Swing", p249:FindFirstChild("HumanoidRootPart"), 0.3, 1.25)
    end
end

function t6.CounterPopup(p253, p254) -- line: 3341
    -- upvalues: Debris (copy), TweenService (copy), LocalPlayer (copy)
    local Head = p253:FindFirstChild("Head")

    if not Head then
        return
    end

    local BillboardGui = Instance.new("BillboardGui")

    BillboardGui.Name = "CounterPopup"
    BillboardGui.Size = UDim2.fromOffset(220, 50)
    BillboardGui.StudsOffsetWorldSpace = Vector3.new(0, 2.6, 0)
    BillboardGui.AlwaysOnTop = true
    BillboardGui.Adornee = Head

    local TextLabel = Instance.new("TextLabel")

    TextLabel.Size = UDim2.fromScale(1, 1)
    TextLabel.BackgroundTransparency = 1
    TextLabel.FontFace = Font.new("rbxasset://fonts/families/Oswald.json", Enum.FontWeight.Bold)
    TextLabel.TextScaled = true

    if p254 == "Exposed" then
        TextLabel.Text = "OPEN!"
    elseif p254 == "Feint" then
        TextLabel.Text = "BAITED!"
    else
        TextLabel.Text = "COUNTER!"
    end

    if p254 == "Interrupt" then
        TextLabel.TextColor3 = Color3.fromRGB(255, 205, 70)
    else
        TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    end

    TextLabel.Parent = BillboardGui

    local UIStroke = Instance.new("UIStroke")

    UIStroke.Thickness = 2
    UIStroke.Parent = TextLabel

    local UIScale = Instance.new("UIScale")

    UIScale.Scale = 1.5
    UIScale.Parent = TextLabel
    BillboardGui.Parent = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    TweenService:Create(UIScale, TweenInfo.new(0.15, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Scale = 1
    }):Play()
    TweenService:Create(BillboardGui, TweenInfo.new(0.7, Enum.EasingStyle.Quad, Enum.EasingDirection.In, 0, false, 0.3), {
        StudsOffsetWorldSpace = Vector3.new(0, 3.6, 0)
    }):Play()
    TweenService:Create(TextLabel, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In, 0, false, 0.6), {
        TextTransparency = 1
    }):Play()
    TweenService:Create(UIStroke, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In, 0, false, 0.6), {
        Transparency = 1
    }):Play()
    Debris:AddItem(BillboardGui, 1.1)
end

local self5 = setmetatable({}, {
    __mode = "k"
})

function t6.DashSound(p255, p256) -- line: 3376
    -- upvalues: Debris (copy), BoxingConfig (copy), self5 (copy)
    local Dash = BoxingConfig.Sounds.Dash

    if not Dash or not p255 then
        return nil
    end

    local elapsed = os.clock()

    if elapsed - (self5[p255] or (-1e999)) < 0.12 then
        return nil
    end

    self5[p255] = elapsed

    local Sound = Instance.new("Sound")

    Sound.SoundId = Dash
    Sound.Volume = p256 and 1 or 1.6
    Sound.PlaybackSpeed = 1
    Sound.TimePosition = 0
    Sound.RollOffMinDistance = 8
    Sound.RollOffMaxDistance = 90
    Sound.Parent = p255
    Sound:Play()
    Sound.Ended:Once(function() -- line: 3398
        -- upvalues: Sound (copy)
        Sound:Destroy()
    end)
    Debris:AddItem(Sound, 2)

    return Sound
end

function t6.DashEffect(p257, p258, p259) -- line: 3407
    -- upvalues: Players (copy), HttpService (copy), BoxingConfig (copy), BoxingCamera (copy), BoxingVFX (copy), LocalPlayer (copy), t6 (copy), afterimage (copy)
    local HumanoidRootPart = p257:FindFirstChild("HumanoidRootPart")

    if not HumanoidRootPart then
        return
    end

    local v731 = p259 == "Minimal"

    t6.DashSound(HumanoidRootPart, v731)

    local v732 = p258 * Vector3.new(1, 0, 1)

    if v732.Magnitude < 0.001 then
        v732 = HumanoidRootPart.CFrame.LookVector
    end

    BoxingVFX.DashBurst(p257, v732, v731 and 0.45 or 1)

    local Duration = BoxingConfig.Dash and BoxingConfig.Dash.Duration or 0.28
    local v733 = if v731 then "OutboxerDash" else "InfighterDash"
    local PlayerFromCharacter = Players:GetPlayerFromCharacter(p257)

    local function v734() -- line: 3431
        -- upvalues: PlayerFromCharacter (copy), HttpService (copy)
        return HttpService:JSONDecode(PlayerFromCharacter and PlayerFromCharacter:GetAttribute("Loadout") or "{}")
    end

    local ok, result = pcall(v734)

    if ok and type(result) == "table" and type(result.Dash) == "string" then
        v733 = result.Dash
    end

    local v735 = BoxingConfig.DashSettings and BoxingConfig.DashSettings(v733)
    local Duration2 = if v735 then v735.Duration else nil

    if v735 and Duration2 then
        Duration = Duration2
    end

    BoxingVFX.DashMotionLines(p257, v732, Duration, v731 and 0.6 or 1)
    BoxingVFX.DashWind(p257, v732, Duration, v731 and 0.55 or 1)
    BoxingVFX.DashAura(p257, v732, Duration)

    if v731 then
        return
    end

    local UserVFX = BoxingConfig.UserVFX

    if UserVFX and UserVFX.Dash then
        local Unit = v732.Unit

        BoxingVFX.PlayAsset(UserVFX.Dash, CFrame.fromMatrix(HumanoidRootPart.Position, Unit, (Vector3.new(0, 1, 0))), UserVFX.DashCount, HumanoidRootPart)
    end

    task.spawn(function() -- line: 3459
        -- upvalues: p257 (copy), afterimage (copy)
        for _ = 1, 5 do
            if not p257.Parent then
                return
            end

            afterimage(p257)
            task.wait(0.05)
        end
    end)

    if p257 == LocalPlayer.Character then
        BoxingCamera.KickFov(8, 0.35)
    end
end

local function shakeCamera(p260) -- line: 3475
    -- upvalues: BoxingCamera (copy)
    BoxingCamera.Shake(p260)
end

local ColorCorrectionEffect2, BlurEffect2
local n13 = 0

RunService.RenderStepped:Connect(function(p261) -- line: 3484
    -- upvalues: BoxingConfig (copy), BoxingSettings (copy), LocalPlayer (copy), ColorCorrectionEffect2 (ref), BlurEffect2 (ref), n13 (ref)
    local LowHealthEffect = BoxingConfig.LowHealthEffect
    local v736 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    local v737

    if v736 and v736.MaxHealth > 0 and BoxingSettings.Get("LowHealthEffect") then
        local v738 = v736.Health / v736.MaxHealth

        v737 = math.clamp((LowHealthEffect.Threshold - v738) / LowHealthEffect.Threshold, 0, 1)

        if LocalPlayer.Character:GetAttribute("Downed") and BoxingConfig.Knockdown.Recovery then
            v737 *= 0.3
        end
    else
        v737 = 0
    end

    n13 += (v737 - n13) * math.min(p261 * 4, 1)

    if n13 < 0.005 and not ColorCorrectionEffect2 then
        return
    end

    local CurrentCamera = workspace.CurrentCamera

    if not ColorCorrectionEffect2 or ColorCorrectionEffect2.Parent ~= CurrentCamera then
        ColorCorrectionEffect2 = Instance.new("ColorCorrectionEffect")
        ColorCorrectionEffect2.Name = "LowHealthTint"
        ColorCorrectionEffect2.Parent = CurrentCamera
        BlurEffect2 = Instance.new("BlurEffect")
        BlurEffect2.Name = "LowHealthBlur"
        BlurEffect2.Parent = CurrentCamera
    end

    local v744 = 1 + math.sin(os.clock() * 5) * LowHealthEffect.Pulse * n13
    local v746 = math.clamp(n13 * v744, 0, 1)

    ColorCorrectionEffect2.TintColor = Color3.new(1, 1, 1):Lerp(LowHealthEffect.Tint, v746)
    ColorCorrectionEffect2.Saturation = -LowHealthEffect.MaxDesaturate * n13
    BlurEffect2.Size = LowHealthEffect.MaxBlur * n13
end)

local function guardBreakEffect(p262, p263, p264) -- line: 3517
    -- upvalues: BoxingConfig (copy), BoxingCamera (copy), BoxingVFX (copy), LocalPlayer (copy), playSoundAt (copy)
    local v747 = p262:FindFirstChild("Torso") or p262:FindFirstChild("HumanoidRootPart")

    if not v747 then
        return
    end

    p263 = p263 or v747.Position

    local HumanoidRootPart = p262:FindFirstChild("HumanoidRootPart")
    local HumanoidRootPart2 = p264 and p264:FindFirstChild("HumanoidRootPart")
    local v749 = if HumanoidRootPart2 then (HumanoidRootPart2.Position - p263) * Vector3.new(1, 0, 1) elseif HumanoidRootPart then HumanoidRootPart.CFrame.LookVector else Vector3.new(0, 0, 1)
    local v750 = BoxingConfig.UserVFX and BoxingConfig.UserVFX.GuardBreak

    if v750 then
        BoxingVFX.ImpactFrame(v750, p263, v749)
    else
        BoxingVFX.GuardShatter(p263, v749)
    end

    playSoundAt("GuardBreak", p263, 1, BoxingConfig.ExtraSounds and BoxingConfig.ExtraSounds.GuardBreakPitch or 0.7)

    if p262 == LocalPlayer.Character or p264 == LocalPlayer.Character then
        BoxingCamera.Shake(1.4)
        BoxingVFX.FovKick(6)
    end
end

local self6 = setmetatable({}, {
    __mode = "k"
})

task.spawn(function() -- line: 3548
    -- upvalues: ContentProvider (copy), BoxingConfig (copy)
    local t83 = {}

    for _, v752 in BoxingConfig.HitReactions and BoxingConfig.HitReactions.Animations or {} do
        local Animation = Instance.new("Animation")

        Animation.AnimationId = v752
        table.insert(t83, Animation)
    end

    local PreloadAsync = ContentProvider.PreloadAsync

    pcall(PreloadAsync, ContentProvider, t83)
end)

local function playHitReaction(p265, p266, p267, p268) -- line: 3557
    -- upvalues: Players (copy), BoxingConfig (copy), LocalPlayer (copy), self6 (copy)
    local HitReactions = BoxingConfig.HitReactions
    local v753 = if BoxingConfig.IsMirrored(p265) and type(p266) == "string" then p266:gsub("Left", "#L#"):gsub("Right", "Left"):gsub("#L#", "Right") else p266

    if HitReactions and v753 and HitReactions.Animations[v753] and (not Players:GetPlayerFromCharacter(p265) or p265 == LocalPlayer.Character) then
        local Humanoid = p265:FindFirstChildOfClass("Humanoid")
        local Animator = Humanoid and Humanoid:FindFirstChildOfClass("Animator")

        if Animator then
            local v754 = self6[Animator]
            local v755 = v754

            if not v754 then
                local t84 = {}

                v755 = t84
                self6[Animator] = t84
            end

            local function getTrack(p269) -- line: 3576
                -- upvalues: HitReactions (copy), Animator (copy), v755 (ref)
                local v756 = v755[p269]

                if not v756 then
                    local Animation = Instance.new("Animation")

                    Animation.AnimationId = HitReactions.Animations[p269]
                    v756 = Animator:LoadAnimation(Animation)
                    v756.Priority = HitReactions.Priority
                    v756.Looped = false

                    local v757 = v755

                    v757[p269] = v756
                end

                return v756
            end

            local v760 = HitReactions.MinWeight + (1 - HitReactions.MinWeight) * math.clamp(tonumber(p267) or 1, 0, 1)
            local t85 = {
                [v753] = v760
            }
            local v761 = HitReactions.Companions and HitReactions.Companions[v753]

            if v761 and HitReactions.Animations[v761] then
                t85[v761] = v760 * (HitReactions.CompanionMin + (HitReactions.CompanionMax - HitReactions.CompanionMin) * math.clamp(tonumber(p268) or 0, 0, 1))
            end

            for v764, v765 in v755 do
                if not t85[v764] and v765.IsPlaying then
                    v765:Stop(0.08)
                end
            end

            for v766, v767 in t85 do
                local v768 = v755[v766]

                if not v768 then
                    local Animation = Instance.new("Animation")

                    Animation.AnimationId = HitReactions.Animations[v766]
                    v768 = Animator:LoadAnimation(Animation)
                    v768.Priority = HitReactions.Priority
                    v768.Looped = false

                    local v769 = v755

                    v769[v766] = v768
                end

                v768:Play(HitReactions.FadeIn, v767, 1)
            end
        end
    end
end

task.spawn(function() -- line: 3611
    -- upvalues: ContentProvider (copy), BoxingConfig (copy)
    local t86 = {}

    for _, v770 in BoxingConfig.BlockReactions and BoxingConfig.BlockReactions.Animations or {} do
        local Animation = Instance.new("Animation")

        Animation.AnimationId = v770
        table.insert(t86, Animation)
    end

    local PreloadAsync = ContentProvider.PreloadAsync

    pcall(PreloadAsync, ContentProvider, t86)
end)

local self7 = setmetatable({}, {
    __mode = "k"
})

local function blockReactionTrack(p270, p271) -- line: 3621
    -- upvalues: BoxingConfig (copy), self7 (copy)
    local BlockReactions = BoxingConfig.BlockReactions
    local v772 = BlockReactions and BlockReactions.Animations[p271]
    local Humanoid = p270:FindFirstChildOfClass("Humanoid")
    local Animator = Humanoid and Humanoid:FindFirstChildOfClass("Animator")

    if not (v772 and Animator) then
        return nil
    end

    local v773 = self7[Animator]

    if not v773 then
        v773 = {}
        self7[Animator] = v773
    end

    local v774 = v773[p271]

    if not v774 then
        local Animation = Instance.new("Animation")

        Animation.AnimationId = v772
        v774 = Animator:LoadAnimation(Animation)
        v774.Priority = Enum.AnimationPriority.Action4
        v774.Looped = false
        v773[p271] = v774
    end

    return v774, v773
end

local function armHit(p272, p273) -- line: 3648
    if not (typeof(p273) == "Vector3" and math.abs(p273.X) > 0.05) then
        if not p272 or p272.Side ~= "Right" then
            return "Right"
        end
    elseif p273.X > 0 then
        return "Right"
    end

    return "Left"
end

local function overrideRemoteBreak(p274, p275, p276) -- line: 3658
    -- upvalues: BoxingConfig (copy)
    local Humanoid = p274:FindFirstChildOfClass("Humanoid")
    local Animator = Humanoid and Humanoid:FindFirstChildOfClass("Animator")

    if not Animator then
        return
    end

    local t89 = {}
    local v777 = BoxingConfig.StanceAnimations(p274)

    if v777.Block and v777.Block ~= "" then
        t89[v777.Block] = true
    end

    for _, v778 in v777.BlockMove do
        if v778 ~= "" then
            t89[v778] = true
        end
    end

    for _, v779 in Animator:GetPlayingAnimationTracks() do
        if v779 ~= p275 and v779.Animation and t89[v779.Animation.AnimationId] then
            v779:AdjustWeight(0.01, 0.05)
        end
    end

    local v780 = BoxingConfig.BlockReactions.Animations[p276]
    local connection = Animator.AnimationPlayed:Connect(function(p277) -- line: 3681
        -- upvalues: p275 (copy), v780 (copy)
        if p277 ~= p275 and p277.Animation and p277.Animation.AnimationId == v780 then
            p277:Stop(0)
        end
    end)

    task.delay(1.2, function() -- line: 3686
        -- upvalues: connection (copy)
        connection:Disconnect()
    end)
end

local function playBlockReaction(p278, p279, p280, p281) -- line: 3691
    -- upvalues: Players (copy), BoxingConfig (copy), LocalPlayer (copy), t5 (copy), blockReactionTrack (copy), overrideRemoteBreak (copy)
    local BlockReactions = BoxingConfig.BlockReactions
    local v781 = if BoxingConfig.IsMirrored(p278) and type(p279) == "string" then p279:gsub("Left", "#L#"):gsub("Right", "Left"):gsub("#L#", "Right") else p279
    local v782, v783 = blockReactionTrack(p278, v781)

    if not v782 then
        return
    end

    local v784 = t5[p278]

    if p280 and v784 then
        local Length = v782.Length

        if Length <= 0 then
            Length = 0.8
        end

        v784.BreakAnim = {
            Start = os.clock(),
            Length = Length
        }
    end

    local v785 = Players:GetPlayerFromCharacter(p278) ~= nil and p278 ~= LocalPlayer.Character

    if not (not v785 or p280 and p281) then
        return
    end

    if v785 then
        overrideRemoteBreak(p278, v782, v781)
    end

    for v786, v787 in v783 do
        if v786 ~= v781 and v787.IsPlaying then
            v787:Stop(0.08)
        end
    end

    local v788 = v784 and v784.BlockTrack

    if v788 and v788.IsPlaying then
        v788:AdjustWeight(BlockReactions.BlockWeightDuring or 0.05, BlockReactions.FadeIn)
    end

    local v789 = v784 or {}

    v789.BlockReactionToken = (v789.BlockReactionToken or 0) + 1

    local BlockReactionToken = v789.BlockReactionToken

    v782:Play(BlockReactions.FadeIn, 1, 1)

    local v790 = if v782.Length > 0 then v782.Length else 0.8
    local v791 = if p280 then BlockReactions.BreakFadeOut or 0.25 else 0.15

    task.delay(math.max(v790 - v791, 0.05), function() -- line: 3729
        -- upvalues: v782 (copy), v789 (copy), BlockReactionToken (copy), v791 (copy)
        if v789.BlockReactionToken ~= BlockReactionToken then
            return
        end

        v782:Stop(v791)

        local BlockTrack = v789.BlockTrack

        if BlockTrack and BlockTrack.IsPlaying then
            BlockTrack:AdjustWeight(1, v791)
        end
    end)
end

v467 = function(p282, p283, p284, p285, p286) -- line: 3743
    -- upvalues: BoxingConfig (copy), guardBreakEffect (copy), playBlockReaction (copy)
    if (p282:GetAttribute("GuardBrokenUntil") or 0) > workspace:GetServerTimeNow() or (p282:GetAttribute("GuardZone") or "Body") ~= p285 then
        return false
    end

    local HumanoidRootPart = p282:FindFirstChild("HumanoidRootPart")
    local HumanoidRootPart2 = p283:FindFirstChild("HumanoidRootPart")

    if not HumanoidRootPart or not HumanoidRootPart2 then
        return false
    end

    local v793 = (HumanoidRootPart2.Position - HumanoidRootPart.Position) * Vector3.new(1, 0, 1)

    if v793.Magnitude > 0.001 and HumanoidRootPart.CFrame.LookVector:Dot(v793.Unit) < (BoxingConfig.BlockFrontDot or 0) then
        return false
    end

    local GuardDamage = p284.GuardDamage
    local _, v794 = BoxingConfig.StanceOf(p282)

    if v794.PeekGuard then
        GuardDamage *= v794.PeekGuard.GuardDamage
    end

    local _, v795 = BoxingConfig.ActiveGuardItem(p282)

    if v795 and v795.CrossArm then
        GuardDamage *= if p284.Anim == "Uppercut" then v795.CrossArm.UppercutGuardDamage or 0.5 else v795.CrossArm.GuardDamage or 0.75
    elseif v795 and v795.HalfGuard and not v794.PeekGuard then
        GuardDamage *= v795.HalfGuard.GuardDamage or 1
    end

    local v796 = BoxingConfig.Injuries and BoxingConfig.Injuries.Arms
    local HumanoidRootPart3 = p282:FindFirstChild("HumanoidRootPart")

    if v796 and HumanoidRootPart3 and p286 then
        local X = HumanoidRootPart3.CFrame:PointToObjectSpace(p286).X
        local v797 = if p285 == "Head" or p284.Anim == "Uppercut" then 0.55 else 0.95

        if p284.Anim == "Hook" and math.abs(X) > (BoxingConfig.HitReactions and BoxingConfig.HitReactions.HookCenterZone or 0.4) then
            X = (if p284.Knockback.X > 0 then 1 else -1) * v797 * 0.85 + X * 0.3
        end

        local v799 = math.clamp(X, -v797, v797)
        local t90 = if math.abs(v799) < v796.Centre then { "L", "R" } elseif v799 > 0 then { "R" } else { "L" }
        local n14 = 1

        for _, v800 in t90 do
            local v801 = p282:GetAttribute("InjArm" .. v800 .. "Pts") or 0
            local n15 = 1

            if p282:GetAttribute("ArmSevere" .. v800) then
                n15 = v796.Severe.Guard
            elseif v796.Thresholds[2] <= v801 then
                n15 = v796.Guard
            elseif v796.Thresholds[1] <= v801 then
                n15 = 1 + v796.FatigueGuard * math.clamp((v801 - v796.Thresholds[1]) / (v796.Thresholds[2] - v796.Thresholds[1]), 0, 1)
            end

            n14 = math.max(n14, n15)
        end

        GuardDamage *= n14
    end

    local v803 = if (p282:GetAttribute("ExposedUntil") or 0) > workspace:GetServerTimeNow() then GuardDamage * (BoxingConfig.PerfectDodge and BoxingConfig.PerfectDodge.GuardDamageMultiplier or 1) else GuardDamage

    if (p282:GetAttribute("BlockStamina") or 0) - v803 > 0 and not p284.GuardBreak then
        return false
    end

    guardBreakEffect(p282, p286, p283)

    if BoxingConfig.BlockReactions then
        playBlockReaction(p282, "GuardBreak_" .. (p284 and p284.Side == "Right" and "Left" or "Right") .. "Arm", true, true)
    end

    return true
end

function t6.HitBodyReaction(p287, p288, p289, p290, p291, p292, p293) -- line: 3816
    -- upvalues: BoxingConfig (copy), t6 (copy)
    local HitReactions = BoxingConfig.HitReactions
    local HumanoidRootPart = p287:FindFirstChild("HumanoidRootPart")

    if not (HitReactions and p289 and HumanoidRootPart) then
        return
    end

    local v806 = (0.5 + 0.5 * math.clamp(tonumber(p291) or 1, 0, 1)) * (if p293 then HitReactions.CounterStrength or 1.35 else 1)
    local v807 = if typeof(p290) == "Vector3" then p290.X elseif p289.Side == "Left" then 0.6 else -0.6
    local v808 = p292 == "Head" or p289.Anim == "Uppercut"
    local v809 = if v808 then 0.55 else 0.95
    local v810 = math.abs(v807)
    local v811 = HitReactions.CenterZone * (if v808 then 0.6 else 1)
    local v812 = if p289.Anim == "Hook" then HitReactions.HookCenterZone or v811 else p289.Anim == "Uppercut" and HitReactions.UppercutCenterZone or v811

    if p289.Anim == "Hook" and v810 <= v812 then
        t6.LeanBack(p287, -(HitReactions.HookCenterLean or 9) * v806)
    elseif v810 <= v812 then
        t6.LeanBack(p287, (HitReactions.CenterLean[p289.Anim] or 7) * v806)

        if v808 and p289.Anim ~= "Uppercut" then
            t6.HeadSnap(p287, HitReactions.CenterHeadTilt * v806)
        end
    else
        local v813 = if v807 > 0 then 1 else -1
        local v817 = math.clamp((v810 - v812) / math.max(v809 * 0.6 - v812, 0.05), 0.5, 1)
        local v818 = (HitReactions.TwistDegrees[p289.Anim] or 6) * v806 * v817
        local v819 = if p289.Anim == "Hook" then v813 * v818 else -v813 * v818

        t6.BodyTwist(p287, v819)
    end

    local Magnitude = p289.Knockback.Magnitude

    if not (HitReactions.StumbleMinKnockback <= Magnitude or p293) then
        return
    end

    local HumanoidRootPart2 = p288 and p288:FindFirstChild("HumanoidRootPart")
    local v820 = if HumanoidRootPart2 then HumanoidRootPart.Position - HumanoidRootPart2.Position else -HumanoidRootPart.CFrame.LookVector

    t6.Stumble(p287, v820, v806 * math.max(Magnitude / 8.6, if p293 then HitReactions.CounterStagger or 0.75 else 0))
end

local function onHit(p294, p295, p296, p297, p298, p299, p300, p301, p302, p303, p304, p305, p306, p307, p308, p309, p310, p311) -- line: 3872
    -- upvalues: BoxingConfig (copy), BoxingCamera (copy), BoxingVFX (copy), BoxingScreen (copy), BoxingSettings (copy), LocalPlayer (copy), t5 (copy), t6 (copy), cutSwing (copy), settle (copy), v468 (ref), headHitEffect (copy), punchTravel (copy), damageNumber (copy), guardBreakEffect (copy), playHitReaction (copy), playBlockReaction (copy), v16 (copy)
    if p308 == "Interrupt" then
        t6.CancelPunch(p294)
    end

    local v823 = if p298 ~= nil and p298 == LocalPlayer.Character then settle(p311, p294, p297) else nil
    local v824 = v823 ~= nil and v823.Kind == "Hit"
    local v825 = p310 and not p296 and not v824 and BoxingConfig.HitVFX and BoxingConfig.HitVFX.Techniques and BoxingConfig.HitVFX.Techniques[p310]

    if v825 then
        if typeof(p299) == "Vector3" and BoxingSettings.Get("HitFlash") ~= false then
            local HumanoidRootPart = p298 and p298:FindFirstChild("HumanoidRootPart")
            local v826 = if HumanoidRootPart then (p299 - HumanoidRootPart.Position) * Vector3.new(1, 0, 1) else Vector3.new(0, 0, 1)
            local v827 = BoxingConfig.HitVFX.TechniqueColors and BoxingConfig.HitVFX.TechniqueColors[p310]

            BoxingVFX.Burst(v825, p299, if v826.Magnitude > 0.001 then v826.Unit else Vector3.new(0, 0, 1), v827, BoxingConfig.HitVFX.TechniqueScale)
        end
    end

    local v828 = p301 and v824 and v823.Break == true

    cutSwing(p298 and t5[p298])

    local v829 = v824 and v823.Fx ~= nil and not p296
    local v830 = v823 ~= nil and v823.Kind == "Miss"
    local Fx = if v824 then v823.Fx else nil
    local v831 = BoxingConfig.Punches[p297]
    local v832 = BoxingConfig.Weights[v831 and v831.Weight or "Light"]
    local HumanoidRootPart = p294:FindFirstChild("HumanoidRootPart")
    local v833 = p299 or HumanoidRootPart and HumanoidRootPart.Position
    local n16 = 0

    if Fx then
        n16 = math.max(0, Fx.Until - os.clock())

        if p300 and v833 then
            local v835 = BoxingConfig.HitVFX or {}

            BoxingVFX.Burst(v835.Knockdown, v833, punchTravel(p298, v831, v833), nil, v835.KnockdownScale)
        end
    elseif v833 then
        n16 = v468(p298, p294, v831, p302, v833, {
            Blocked = p296,
            Counter = p307 and not p296,
            KnockedDown = p300,
            Close = p309 == true,
            SkipSound = v829 or v830
        })
    end

    local function react() -- line: 3921
        -- upvalues: p294 (copy), p296 (copy), p298 (copy), p300 (copy), p302 (copy), p303 (copy), p304 (copy), p305 (copy), p306 (copy), p307 (copy), v831 (copy), BoxingConfig (copy), t6 (copy), playHitReaction (copy)
        local playHitReaction2, v837, v838, v839, v840

        if p296 or p300 then
            v840 = true
        elseif p294.Parent then
            playHitReaction2 = playHitReaction
            v837 = p294
            v838 = p303
            v839 = if p307 then 1 else p304
            v840 = false
        else
            v840 = true
        end

        if v840 then
            return
        end

        playHitReaction2(v837, v838, v839, p305)

        local v841 = BoxingConfig.HitReactions and BoxingConfig.HitReactions.UppercutHeadSnap

        t6.HitBodyReaction(p294, p298, v831, p306, p304, p302, p307)

        if v841 and v831 and v831.Anim == "Uppercut" then
            t6.HeadSnap(p294, v841 * (math.clamp(tonumber(p304) or 1, 0, 1) * 0.5 + 0.5))
        end
    end

    if n16 > 0 then
        task.delay(n16, react)
    else
        react()
    end

    damageNumber(p294, p295, p296, p300)

    if p301 and not v828 then
        guardBreakEffect(p294, p299, p298)
    end

    local BlockReactions = BoxingConfig.BlockReactions

    if BlockReactions and v831 and not p300 then
        if p301 then
            if not v828 then
                local v843 = "Right"

                if typeof(p306) == "Vector3" then
                    v843 = if math.abs(p306.X) > 0.05 then if p306.X > 0 then "Right" else "Left" elseif v831.Side == "Right" then "Left" else "Right"
                elseif v831.Side == "Right" then
                    v843 = "Left"
                end

                playBlockReaction(p294, "GuardBreak_" .. v843 .. "Arm", true, true)
            end
        elseif p296 and (BlockReactions.BlockHitPunches == nil or BlockReactions.BlockHitPunches[v831.Anim]) and (BlockReactions.BlockHitZone == nil or p302 == BlockReactions.BlockHitZone) then
            local v844 = "Right"

            if typeof(p306) == "Vector3" then
                v844 = if math.abs(p306.X) > 0.05 then if p306.X > 0 then "Right" else "Left" elseif v831.Side == "Right" then "Left" else "Right"
            elseif v831.Side == "Right" then
                v844 = "Left"
            end

            playBlockReaction(p294, "BlockHit_" .. v844 .. "Arm", false)
        end
    end

    if p300 then
        task.delay(0.3, BoxingVFX.GroundShockwave, p294)
        task.delay(0.3, function() -- line: 3958
            -- upvalues: p294 (copy), BoxingVFX (copy)
            local v845 = p294.Parent and p294:FindFirstChild("HumanoidRootPart")

            if not v845 then
                return
            end

            local v846 = RaycastParams.new()

            v846.FilterType = Enum.RaycastFilterType.Exclude

            local t92 = {
                p294
            }

            if workspace:FindFirstChild("BoxingEffects") then
                table.insert(t92, workspace.BoxingEffects)
            end

            v846.FilterDescendantsInstances = t92

            local v847 = workspace:Raycast(v845.Position, Vector3.new(0, -8, 0), v846)

            if v847 then
                BoxingVFX.Burst("V2_Knockdown", v847.Position + Vector3.new(0, 0.05, 0), (Vector3.new(0, 1, 0)))
            end
        end)
    end

    if (p298 == LocalPlayer.Character or p294 == LocalPlayer.Character) and p300 then
        local v848 = v832.Shake * 1.8

        BoxingCamera.Shake(v848)

        local v849 = BoxingSettings.Get("HitFlash") and BoxingConfig.HitVFX or {}

        BoxingVFX.ScreenFlash(v849.KnockdownFlash or 1, 0.25)
        BoxingVFX.FovKick(10)

        if BoxingSettings.Get("HitFlash") and v16.ImpactFrame ~= false then
            BoxingVFX.MangaFrame(1)
        end
    end

    if p294 == LocalPlayer.Character and p302 == "Head" and not p296 then
        headHitEffect(p300)
    end

    if p294 == LocalPlayer.Character then
        local HitVignette = BoxingScreen.HitVignette
        local Weight = if v831 then v831.Weight else nil

        if not v831 or not Weight then
            Weight = "Light"
        end

        HitVignette(Weight, p296, p300)

        local Blink = BoxingConfig.Blink

        if Blink then
            local v850 = tonumber(p304) or 0
            local v851 = if p300 then "Knockdown"
                elseif p301 then "GuardBreak"
                elseif p307 or p296 then if not p296 then "Counter" else nil
                elseif v831 and v831.Weight == "Heavy" and Blink.HeavyMinClean <= v850 then "Heavy"
                else nil

            if v851 then
                BoxingScreen.Blink(v851)
            end
        end
    end

    if p298 ~= nil and p298 == LocalPlayer.Character and p294 ~= p298 then
        BoxingCamera.PulseCrosshair(p296)
    end
end

local BoxingBagSwing = require(script.Parent:WaitForChild("BoxingBagSwing"))
local BoxingMittImpact = require(script.Parent:WaitForChild("BoxingMittImpact"))

local function onBagHit(p312, p313, p314, p315, p316, p317, _, p319, p320) -- line: 4024
    -- upvalues: BoxingConfig (copy), BoxingCamera (copy), LocalPlayer (copy), t5 (copy), cutSwing (copy), settle (copy), v468 (ref), BoxingBagSwing (copy), BoxingMittImpact (copy)
    local v852 = BoxingConfig.Punches[p314]

    if not (v852 and p312 and p315) then
        return
    end

    local v853 = if p313 ~= nil and p313 == LocalPlayer.Character then settle(nil, p312, p314) else nil

    if p312:GetAttribute("PunchingBag") then
        local v854 = v853 and v853.BagKick

        if typeof(v854) == "Vector3" then
            if typeof(p319) == "Vector3" and (p319 - v854).Magnitude > 1E-04 then
                BoxingBagSwing.Kick(p312, p319 - v854)
            end
        else
            if typeof(p319) == "Vector3" then
                BoxingBagSwing.Kick(p312, p319)
            end

            BoxingBagSwing.Dent(p312, p315, BoxingBagSwing.DentDepthFor(v852, tonumber(p320) or 0))
            BoxingBagSwing.Thud(p312, p315, v852, tonumber(p320) or 0, p317)
        end
    end

    cutSwing(p313 and t5[p313])

    local v855 = v853 ~= nil and (v853.Kind == "Hit" or v853.Kind == "Miss")
    local _ = BoxingConfig.Weights[v852.Weight or "Light"]
    local HumanoidRootPart = p313 and p313:FindFirstChild("HumanoidRootPart")
    local v856

    if HumanoidRootPart then
        local v857 = (p315 - HumanoidRootPart.Position) * Vector3.new(1, 0, 1)

        v856 = if v857.Magnitude > 0.001 then v857.Unit else Vector3.new(0, 0, 1)
    else
        v856 = Vector3.new(0, 0, 1)
    end

    if v852.Anim == "Uppercut" then
        v856 = (v856 + Vector3.new(0, 1.5, 0)).Unit
    end

    if p312:FindFirstChild("MittLeft") or p312:FindFirstChild("MittRight") then
        BoxingMittImpact.Hit(p312, p315, v856, v852.Weight, p317)
    end

    local v858 = p313 == LocalPlayer.Character

    if v853 == nil or v853.Kind ~= "Hit" or not v853.Fx then
        v468(p313, p312, v852, p316, p315, {
            Bag = true,
            SkipSound = v855
        })
    end

    if v858 then
        BoxingCamera.PulseCrosshair(false)
    end
end

local self8 = setmetatable({}, {
    __mode = "k"
})

local function weaveDirection(p321, p322) -- line: 4080
    local HumanoidRootPart = p321:FindFirstChild("HumanoidRootPart")

    if not HumanoidRootPart then
        return nil
    end

    local CFrame = HumanoidRootPart.CFrame

    if p322 == "Left" then
        return -CFrame.RightVector
    end

    if p322 ~= "Right" then
        if p322 == "Back" then
            return -CFrame.LookVector
        end

        if p322 == "Forward" then
            return (CFrame.LookVector - Vector3.new(0, 0.6, 0)).Unit
        end
    end

    return CFrame.RightVector
end

local function onWeaveDodge(p323, p324, p325) -- line: 4097
    -- upvalues: BoxingVFX (copy), self8 (copy)
    local Head = p323 and p323:FindFirstChild("Head")

    if not Head then
        return
    end

    local v860 = self8[p323]

    if v860 and v860.Attacker == p324 and os.clock() - v860.At < 0.08 then
        return
    end

    self8[p323] = {
        At = os.clock(),
        Attacker = p324
    }

    local DodgeLines = BoxingVFX.DodgeLines

    p325 = p325 or p323:GetAttribute("Weaving")

    local HumanoidRootPart = p323:FindFirstChild("HumanoidRootPart")
    local v862

    if HumanoidRootPart then
        local CFrame = HumanoidRootPart.CFrame

        v862 = if p325 == "Left" then -CFrame.RightVector
            elseif p325 == "Right" then CFrame.RightVector
            elseif p325 == "Back" then -CFrame.LookVector
            elseif p325 == "Forward" then (CFrame.LookVector - Vector3.new(0, 0.6, 0)).Unit
            else CFrame.RightVector
    end

    DodgeLines(Head, v862)
end

local function bagPopup() -- line: 4111
    -- upvalues: Parent (copy), BoxingConfig (copy)
    require(Parent:WaitForChild("StatHeader")).Show(BoxingConfig.PunchingBag.Stat, BoxingConfig.PunchingBag.Sub, 3)
end

task.spawn(function() -- line: 4119
    -- upvalues: BoxingConfig (copy), LocalPlayer (copy)
    local v863 = BoxingConfig.WillpowerEffects and BoxingConfig.WillpowerEffects.DeterminationEyes

    if not v863 then
        return
    end

    local ScreenGui = Instance.new("ScreenGui")

    ScreenGui.Name = "DeterminationEyesPreload"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.DisplayOrder = -100

    local t95 = {}

    for _, v864 in {
            v863.Image,
            v863.GlowHaloTexture
        } do
        if v864 then
            local ImageLabel = Instance.new("ImageLabel")

            ImageLabel.Image = v864
            ImageLabel.Size = UDim2.fromOffset(1, 1)
            ImageLabel.BackgroundTransparency = 1
            ImageLabel.ImageTransparency = 0.99
            ImageLabel.Parent = ScreenGui
            table.insert(t95, ImageLabel)
        end
    end

    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

    local function v865() -- line: 4142
        -- upvalues: t95 (copy)
        game:GetService("ContentProvider"):PreloadAsync(t95)
    end

    pcall(v865)
end)
BoxingRemote.OnClientEvent:Connect(function(p326, ...) -- line: 4147
    -- upvalues: Parent (copy), BoxingConfig (copy), BoxingKnockback (copy), BoxingVFX (copy), v9 (copy), LocalPlayer (copy), t6 (copy), playMiss (copy), settle (copy), onHit (copy), BoxingBagSwing (copy), onBagHit (copy), onWeaveDodge (copy)
    if p326 == "BagHit" then
        onBagHit(...)
    elseif p326 == "BagPush" then
        local v866, v867 = ...

        if v866 and typeof(v867) == "Vector3" then
            BoxingBagSwing.Kick(v866, v867)
        end
    elseif p326 == "BagGain" then
        require(Parent:WaitForChild("StatHeader")).Show(BoxingConfig.PunchingBag.Stat, BoxingConfig.PunchingBag.Sub, 3)
    elseif p326 == "Punch" then
        local v868, v869, v870, v871, v872, v873 = ...

        if v868 and v868 ~= LocalPlayer.Character then
            t6.Play(v868, v869, v870, v871, v872, v873)
        end
    elseif p326 == "Hit" then
        if ... then
            onHit(...)
        end
    elseif p326 == "Miss" then
        local v874, v875, v876, v877, v878 = ...
        local v879 = BoxingConfig.Punches[v875]

        if v874 and v879 then
            local v880 = false

            if v874 == LocalPlayer.Character then
                local v881 = settle(v878, nil, v875)

                v880 = v881 ~= nil and (v881.Kind == "Miss" or v881.Kind == "Hit")
            end

            if not v880 then
                playMiss(v874, v879, v876, v877 == true)
            end
        end
    elseif p326 == "Dash" then
        local v883, v884, v885 = ...

        if v883 and v883 ~= LocalPlayer.Character and typeof(v884) == "Vector3" then
            t6.DashEffect(v883, v884, v885)
        end
    elseif p326 == "WeaveDodge" then
        local v886, v887, _, v888 = ...

        if v886 then
            onWeaveDodge(v886, v887, v888)
        end
    elseif p326 == "Dodge" then
        local v889, v890, _, v891 = ...

        if v889 then
            t6.DodgeEffect(v889, v890, v891)
        end
    elseif p326 == "PerfectDodge" then
        local v892, v893 = ...

        if v892 then
            t6.PerfectDodgeEffect(v892, v893)
        end
    elseif p326 == "Baited" then
        local v894 = ...

        if v894 then
            t6.CounterPopup(v894, "Feint")

            local v895 = v894:FindFirstChild("Torso") or v894:FindFirstChild("HumanoidRootPart")

            if v895 then
                BoxingVFX.Burst("V2_Baited", v895.Position, v895.CFrame.LookVector)
            end
        end
    elseif p326 == "Parry" then
        local v896 = ...

        if v896 then
            v9[v896] = os.clock()
        end
    elseif p326 == "PerfectStun" then
        local v897, v898, v899 = ...

        if v898 then
            t6.PerfectStunEffect(v897, v898, v899)
        end
    elseif p326 == "Knockback" then
        local v900 = ...
        local Character = LocalPlayer.Character
        local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")

        if HumanoidRootPart and typeof(v900) == "Vector3" then
            BoxingKnockback(HumanoidRootPart, v900)
        end
    end
end)

function t6.Freeze(p327, p328) -- line: 4239
    -- upvalues: freezeTracks (copy)
    if p327 and (p328 or 0) > 0 then
        freezeTracks(p327, p328)
    end
end

return t6
