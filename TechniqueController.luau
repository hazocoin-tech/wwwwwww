-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Boxing = ReplicatedStorage:WaitForChild("Boxing")
local BoxingConfig = require(Boxing:WaitForChild("BoxingConfig"))
local BoxingTechniques = require(Boxing:WaitForChild("BoxingTechniques"))
local BoxingSkills = require(Boxing:WaitForChild("BoxingSkills"))
local BoxingStatEffects = require(Boxing:WaitForChild("BoxingStatEffects"))
local BoxingVisuals = require(Boxing:WaitForChild("BoxingVisuals"))
local BoxingCamera = require(Boxing:WaitForChild("BoxingCamera"))
local TechniqueRemote = Boxing:WaitForChild("TechniqueRemote")
local BoxingRemote = Boxing:WaitForChild("BoxingRemote")
local BoxingPassives = require(Boxing:WaitForChild("BoxingPassives"))
local Action4 = Enum.AnimationPriority.Action4
local t1 = {
    { "Skill1", "Skill2" },
    { "Skill3", "Skill4" }
}
local t2 = {}
local t3
local n1 = 0
local t4 = {}

local function character() -- line: 32
    -- upvalues: LocalPlayer (copy)
    local Character = LocalPlayer.Character
    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

    if Humanoid and Humanoid.Health > 0 then
        return Character, Humanoid
    end

    return nil
end

local function now() -- line: 41
    return os.clock()
end

local function serverActive(p1, p2) -- line: 45
    return (p1:GetAttribute(p2) or 0) > workspace:GetServerTimeNow()
end

local function track(p3, p4, p5) -- line: 49
    -- upvalues: Action4 (copy), t4 (copy)
    local v1 = t4[p3]

    if not v1 then
        v1 = {}
        t4[p3] = v1
        p3.Destroying:Connect(function() -- line: 54
            -- upvalues: p3 (copy), t4 (copy)
            t4[p3] = nil
        end)
    end

    local v2 = v1[p4]

    if not v2 then
        local Animator = p3:FindFirstChildOfClass("Animator")

        if not Animator then
            return nil
        end

        local Animation = Instance.new("Animation")

        Animation.AnimationId = p4
        v2 = Animator:LoadAnimation(Animation)
        v2.Priority = Action4
        v1[p4] = v2
    end

    v2.Looped = p5 == true

    return v2
end

local function slotItem(p6) -- line: 75
    -- upvalues: LocalPlayer (copy), BoxingConfig (copy), t1 (copy)
    local v3 = if LocalPlayer:GetAttribute("ActiveStance") == 2 then 2 else 1

    return BoxingConfig.LoadoutOf(LocalPlayer)[t1[v3][p6]]
end

local function finish(p7) -- line: 82
    -- upvalues: LocalPlayer (copy), t3 (ref)
    if t3 and (not p7 or t3.Token == p7) then
        for _, v4 in t3.Tracks do
            if v4.IsPlaying then
                v4:Stop(0.15)
            end
        end

        for _, v5 in t3.Cleanup do
            pcall(v5)
        end

        t3 = nil
        LocalPlayer:SetAttribute("TechniqueUntil", 0)
        LocalPlayer:SetAttribute("PunchLockedUntil", 0)
        LocalPlayer:SetAttribute("TechSlowUntil", 0)
        LocalPlayer:SetAttribute("ForwardWalkUntil", 0)
    end
end

local function forwardWalk(p8, p9) -- line: 104
    -- upvalues: LocalPlayer (copy)
    LocalPlayer:SetAttribute("ForwardWalkScale", p8)
    LocalPlayer:SetAttribute("ForwardWalkUntil", os.clock() + p9)
end

local function dashForward(p10, p11, p12) -- line: 111
    -- upvalues: RunService (copy), t3 (ref)
    local HumanoidRootPart = p10:FindFirstChild("HumanoidRootPart")

    if not HumanoidRootPart then
        return
    end

    local v6 = HumanoidRootPart:FindFirstChild("RootAttachment") or Instance.new("Attachment", HumanoidRootPart)
    local v7 = HumanoidRootPart.CFrame.LookVector * Vector3.new(1, 0, 1)

    if v7.Magnitude < 0.1 then
        return
    end

    local Unit = v7.Unit
    local LinearVelocity = Instance.new("LinearVelocity")

    LinearVelocity.Name = "TechniqueDash"
    LinearVelocity.Attachment0 = v6
    LinearVelocity.RelativeTo = Enum.ActuatorRelativeTo.World
    LinearVelocity.VelocityConstraintMode = Enum.VelocityConstraintMode.Plane
    LinearVelocity.PrimaryTangentAxis = Vector3.new(1, 0, 0)
    LinearVelocity.SecondaryTangentAxis = Vector3.new(0, 0, 1)
    LinearVelocity.MaxForce = HumanoidRootPart.AssemblyMass * 1500
    LinearVelocity.PlaneVelocity = Vector2.new(Unit.X, Unit.Z) * p11.Speed
    LinearVelocity.Parent = HumanoidRootPart

    local v8 = RaycastParams.new()

    v8.FilterType = Enum.RaycastFilterType.Exclude

    local t5 = {
        p10,
        workspace:FindFirstChild("BoxingEffects")
    }
    local t6 = {}

    for _, descendant in workspace:GetDescendants() do
        if descendant:IsA("Humanoid") and descendant.Parent ~= p10 and descendant.Parent:FindFirstChild("HumanoidRootPart") then
            table.insert(t5, descendant.Parent)
            table.insert(t6, descendant.Parent.HumanoidRootPart)
        end
    end

    v8.FilterDescendantsInstances = t5
    v8.RespectCanCollide = true

    local function closeToSomeone() -- line: 145
        -- upvalues: p11 (copy), HumanoidRootPart (copy), Unit (copy), t6 (copy)
        for _, v9 in t6 do
            local v10 = (v9.Position - HumanoidRootPart.Position) * Vector3.new(1, 0, 1)

            if v10.Magnitude < (p11.StopAt or 2.6) and v10.Magnitude > 0.1 and v10.Unit:Dot(Unit) > 0.4 then
                return true
            end
        end

        return false
    end

    local elapsed = os.clock()
    local connection

    connection = RunService.Heartbeat:Connect(function(p13) -- line: 156
        -- upvalues: p10 (copy), p11 (copy), p12 (copy), HumanoidRootPart (copy), Unit (copy), LinearVelocity (copy), v8 (copy), closeToSomeone (copy), elapsed (copy), connection (ref), t3 (ref)
        local v11 = (os.clock() - elapsed) / p11.Duration
        local v12 = not t3

        if not v12 then
            v12 = t3.Token ~= p12 or p10:GetAttribute("Downed") or (p10:GetAttribute("StunnedUntil") or 0) > workspace:GetServerTimeNow()
        end

        local v13 = p11.Speed * (1 - 0.6 * v11 * v11)

        if not (v11 >= 1) and not v12 and not closeToSomeone() and not workspace:Blockcast(HumanoidRootPart.CFrame, Vector3.new(1.8, 2.8, 0.8), Unit * (v13 * math.max(p13, 0.016666666666666666) * 2 + 0.6), v8) then
            LinearVelocity.PlaneVelocity = Vector2.new(Unit.X, Unit.Z) * v13
        else
            if not v12 and v11 < 1 then
                HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, HumanoidRootPart.AssemblyLinearVelocity.Y, 0)
            end

            connection:Disconnect()
            LinearVelocity:Destroy()
        end
    end)
    table.insert(t3.Cleanup, function() -- line: 171
        -- upvalues: LinearVelocity (copy), connection (ref)
        if connection.Connected then
            connection:Disconnect()
            LinearVelocity:Destroy()
        end
    end)
end

local n2 = 0

UserInputService.InputChanged:Connect(function(p14) -- line: 182
    -- upvalues: n2 (ref)
    if p14.UserInputType == Enum.UserInputType.MouseMovement then
        n2 = n2 * 0.8 + p14.Delta.X
    end
end)

local function lookSide(p15) -- line: 188
    -- upvalues: n2 (ref)
    local HumanoidRootPart = p15:FindFirstChild("HumanoidRootPart")
    local v15 = workspace.CurrentCamera.CFrame.LookVector * Vector3.new(1, 0, 1)

    if HumanoidRootPart and v15.Magnitude > 0.05 then
        local Unit = v15.Unit
        local n3 = 12
        local Unit2

        for _, descendant in workspace:GetDescendants() do
            if descendant:IsA("Humanoid") and descendant.Parent ~= p15 and descendant.Health > 0 then
                local HumanoidRootPart2 = descendant.Parent:FindFirstChild("HumanoidRootPart")

                if HumanoidRootPart2 then
                    local v16 = (HumanoidRootPart2.Position - HumanoidRootPart.Position) * Vector3.new(1, 0, 1)

                    if v16.Magnitude < n3 and v16.Magnitude > 0.1 and v16.Unit:Dot(Unit) > 0.3 then
                        Unit2 = v16.Unit
                        n3 = v16.Magnitude
                    end
                end
            end
        end

        if Unit2 then
            if Unit2:Cross(Unit).Y < 0 then
                return "Right"
            end

            return "Left"
        end
    end

    if n2 < 0 then
        return "Left"
    end

    return "Right"
end

local function canUse(p16) -- line: 215
    -- upvalues: LocalPlayer (copy), BoxingCamera (copy), t3 (ref)
    if LocalPlayer:GetAttribute("BoxingEquipped") and not BoxingCamera.IsSuspended() then
        if p16:GetAttribute("Downed")
            or p16:GetAttribute("Blocking")
            or p16:GetAttribute("Weaving")
            or LocalPlayer:GetAttribute("WeaveMode")
            or p16:GetAttribute("Training")
            or p16:GetAttribute("ClinchedBy")
            or p16:GetAttribute("ClinchState")
            or p16:GetAttribute("RingBreak") then
            return false
        end

        if not ((p16:GetAttribute("StunnedUntil") or 0) > workspace:GetServerTimeNow()) and not ((p16:GetAttribute("ExposedUntil") or 0) > workspace:GetServerTimeNow()) and not ((p16:GetAttribute("TechniqueUntil") or 0) > workspace:GetServerTimeNow()) then
            return not (t3 or (LocalPlayer:GetAttribute("DashingUntil") or 0) > os.clock())
        end
    end

    return false
end

local function play(p17, p18, p19, p20) -- line: 232
    -- upvalues: RunService (copy), t3 (ref), track (copy)
    local v17 = track(p17, p18, p20)

    if v17 then
        v17:Play(0.05, 1, p19 or 1)
        table.insert(t3.Tracks, v17)

        if v17.Length <= 0 and not p20 then
            local elapsed = os.clock()
            local Token = t3.Token
            local connection

            connection = RunService.Heartbeat:Connect(function() -- line: 242
                -- upvalues: p19 (copy), v17 (copy), elapsed (copy), Token (copy), connection (ref), t3 (ref)
                if t3 and t3.Token == Token and v17.IsPlaying and not (os.clock() - elapsed > 3) then
                    if v17.Length > 0 then
                        connection:Disconnect()
                        v17.TimePosition = math.min((os.clock() - elapsed) * (p19 or 1), v17.Length * 0.95)
                    end

                    return
                end

                connection:Disconnect()
            end)
        end
    end

    return v17
end

local function startStrike(p21, p22, p23, p24, p25, p26) -- line: 255
    -- upvalues: RunService (copy), BoxingTechniques (copy), BoxingVisuals (copy), t3 (ref), dashForward (copy), play (copy)
    for _, v20 in p23.Hits or {} do
        local v21 = if p25 == "Right" then "Right" else "Left"
        local v22 = if type(v20.Base) == "table" then v20.Base[v21] else v20.Base
        local v23 = if v20.Zone ~= "Aim" then v20.Zone elseif p25 == "Body" then "Body" else "Head"

        task.delay(BoxingTechniques.RealTime(p23, v20.Time), function() -- line: 263
            -- upvalues: p21 (copy), p24 (copy), p26 (copy), v23 (copy), v20 (copy), v22 (copy), BoxingVisuals (copy), t3 (ref)
            if t3 and t3.Token == p24 and not p21:GetAttribute("Downed") then
                local v24 = (p21:GetAttribute("StunnedUntil") or 0) > workspace:GetServerTimeNow()

                if not v24 then
                    BoxingVisuals.PredictStrike(p21, p26, v22, v23, v20)
                end
            end
        end)
    end

    if p23.Chain then
        for _, v25 in p23.Chain do
            task.delay(v25.At, function() -- line: 271
                -- upvalues: p22 (copy), p24 (copy), v25 (copy), t3 (ref), play (copy)
                if t3 and t3.Token == p24 then
                    play(p22, v25.Anim, v25.Speed)
                end
            end)
        end
    else
        local v27 = play(p22, if p23.Anims then p23.Anims[p25] else p23.Anim, if p23.SlowMo then p23.SlowMo.Speed else p23.Speed)

        if v27 and p23.SlowMo then
            local connection

            connection = RunService.Heartbeat:Connect(function() -- line: 283
                -- upvalues: p23 (copy), p24 (copy), v27 (copy), connection (ref), t3 (ref)
                if v27.IsPlaying and t3 and t3.Token == p24 then
                    if v27.Length > 0 and v27.TimePosition >= p23.SlowMo.Until then
                        connection:Disconnect()
                        v27:AdjustSpeed(1)
                    end
                else
                    connection:Disconnect()
                end
            end)
        end
    end

    if p23.Dash then
        task.delay(p23.Dash.Delay, function() -- line: 294
            -- upvalues: p21 (copy), p23 (copy), p24 (copy), t3 (ref), dashForward (copy)
            if t3 and t3.Token == p24 then
                dashForward(p21, p23.Dash, p24)
            end
        end)
    end
end

local function barrageTarget(p27, p28) -- line: 304
    -- upvalues: Players (copy)
    local HumanoidRootPart = p27:FindFirstChild("HumanoidRootPart")

    if not HumanoidRootPart then
        return nil
    end

    local v28 = HumanoidRootPart.CFrame.LookVector * Vector3.new(1, 0, 1)
    local v29 = if v28.Magnitude > 0.001 then v28.Unit else Vector3.new(0, 0, -1)
    local BoxingDummy = game:GetService("CollectionService"):GetTagged("BoxingDummy")

    for _, player in Players:GetPlayers() do
        if player.Character then
            table.insert(BoxingDummy, player.Character)
        end
    end

    local v31 = p28
    local Unit
    local v30

    for _, v32 in BoxingDummy do
        local v33 = v32 ~= p27 and v32:FindFirstChild("HumanoidRootPart")
        local v34 = v33 and v32:FindFirstChildOfClass("Humanoid")

        if v34 and v34.Health > 0 and not v32:GetAttribute("Downed") then
            local v35 = (v33.Position - HumanoidRootPart.Position) * Vector3.new(1, 0, 1)
            local Magnitude = v35.Magnitude

            if Magnitude > 0.1 and Magnitude < v31 and v35.Unit:Dot(v29) > 0.5 then
                v30 = v33
                v31 = Magnitude
                Unit = v35.Unit
            end
        end
    end

    return v30, v31, Unit
end

local function keepRange(p29, p30, p31) -- line: 338
    -- upvalues: RunService (copy), BoxingCamera (copy), t3 (ref), barrageTarget (copy)
    local HumanoidRootPart = p29:FindFirstChild("HumanoidRootPart")
    local Humanoid = p29:FindFirstChildOfClass("Humanoid")

    if not (HumanoidRootPart and Humanoid) then
        return
    end

    local v36 = HumanoidRootPart:FindFirstChild("RootAttachment") or Instance.new("Attachment", HumanoidRootPart)
    local LinearVelocity = Instance.new("LinearVelocity")

    LinearVelocity.Name = "BarrageSpacing"
    LinearVelocity.Attachment0 = v36
    LinearVelocity.RelativeTo = Enum.ActuatorRelativeTo.World
    LinearVelocity.VelocityConstraintMode = Enum.VelocityConstraintMode.Line
    LinearVelocity.LineDirection = Vector3.new(1, 0, 0)
    LinearVelocity.LineVelocity = 0
    LinearVelocity.MaxForce = HumanoidRootPart.AssemblyMass * 900
    LinearVelocity.Enabled = false
    LinearVelocity.Parent = HumanoidRootPart

    local n4 = 0
    local n5 = 0
    local n6 = 0

    local function follow(p32, p33) -- line: 357
        -- upvalues: n4 (ref), n5 (ref), n6 (ref)
        n4 = os.clock() + p33
        n5 = n4 + 0.18
        n6 = p32 / 0.18
    end

    local connection

    connection = RunService.Heartbeat:Connect(function(p34) -- line: 363
        -- upvalues: p29 (copy), p30 (copy), p31 (copy), HumanoidRootPart (copy), Humanoid (copy), LinearVelocity (copy), n4 (ref), n5 (ref), n6 (ref), connection (ref), BoxingCamera (copy), t3 (ref), barrageTarget (copy)
        if not t3 or t3.Token ~= p30 or not HumanoidRootPart.Parent then
            connection:Disconnect()
            LinearVelocity:Destroy()

            return
        end

        local v37, v38, v39 = barrageTarget(p29, 8)
        local v40, v41 = p31()
        local v42, v43

        if not v37 or not v40 or p29:GetAttribute("Downed") then
            v43 = true
        else
            v42 = (p29:GetAttribute("StunnedUntil") or 0) > workspace:GetServerTimeNow()
            v43 = false
        end

        if v43 or v42 then
            LinearVelocity.Enabled = false

            return
        end

        BoxingCamera.SteerFacing(v39, 5.235987755982989 * p34)

        local v44 = (v40 + v41) / 2
        local v45 = Humanoid.MoveDirection.Magnitude > 0.1 and Humanoid.MoveDirection.Unit:Dot(v39) < -0.4
        local v46 = if v41 < v38 and not v45 then math.clamp((v38 - v44) * 12 + 2, 0, 14) elseif v38 < v40 then -math.clamp((v44 - v38) * 10 + 1, 0, 9) else 0
        local elapsed = os.clock()

        if n4 <= elapsed and elapsed < n5 and not v45 and v40 < v38 then
            v46 = math.max(v46, 0) + n6
        end

        if v46 == 0 then
            LinearVelocity.Enabled = false
        else
            LinearVelocity.LineDirection = v39
            LinearVelocity.LineVelocity = v46
            LinearVelocity.Enabled = true
        end
    end)
    table.insert(t3.Cleanup, function() -- line: 396
        -- upvalues: LinearVelocity (copy), connection (ref)
        if connection.Connected then
            connection:Disconnect()
        end

        LinearVelocity:Destroy()
    end)

    return follow
end

local function extendedArm(p35) -- line: 407
    -- upvalues: BoxingTechniques (copy), t3 (ref), track (copy)
    local Extend = BoxingTechniques.Extend
    local t7 = {
        Hold = nil
    }
    local v50, v51

    local function weights(p36, p37) -- line: 411
        -- upvalues: Extend (copy), v50 (ref), v51 (ref), BoxingTechniques (copy)
        if v50 and v51 then
            local v52 = BoxingTechniques.ReachBlend({
                Dist = Extend.Dist
            }, p36)
            local v53 = v51

            v53:AdjustWeight(math.max(v52, 0.001), p37 or 0.1)

            local v54 = v50

            v54:AdjustWeight(math.max(1 - v52, 0.001), p37 or 0.1)
        end
    end

    function t7.Out(p38, p39) -- line: 418
        -- upvalues: p35 (copy), Extend (copy), t7 (copy), v50 (ref), v51 (ref), weights (copy), BoxingTechniques (copy), t3 (ref), track (copy)
        local v56 = track(p35, BoxingTechniques.ClipId(Extend.Thrust), false)

        v50 = track(p35, BoxingTechniques.ClipId(Extend.HoldNear), true)
        v51 = track(p35, BoxingTechniques.ClipId(Extend.HoldFar), true)

        for _, v57 in { v56, v50, v51 } do
            v57.Priority = Enum.AnimationPriority.Action4
        end

        v56:Play(0.04)
        table.insert(t3.Tracks, v50)
        table.insert(t3.Tracks, v51)
        task.delay(Extend.ThrustTime - 0.03, function() -- line: 428
            -- upvalues: p38 (copy), p39 (copy), t7 (copy), v50 (ref), v51 (ref), weights (copy), t3 (ref)
            if not t3 or t3.Token ~= p39 then
                return
            end

            v50:Play(0.05, 0.001)
            v51:Play(0.05, 0.001)
            weights(p38, 0)
            t7.Holding = true
        end)
    end

    t7.Weights = weights

    function t7.Back() -- line: 438
        -- upvalues: p35 (copy), Extend (copy), t7 (copy), v50 (ref), v51 (ref), BoxingTechniques (copy), track (copy)
        if not v50 then
            return
        end

        t7.Holding = false

        local v60 = track(p35, BoxingTechniques.ClipId(Extend.Recover), false)

        v60.Priority = Enum.AnimationPriority.Action4
        v60:Play(0.04)
        v50:Stop(0.06)
        v51:Stop(0.06)
        v50 = nil
        v51 = nil
    end

    return t7
end

local function startBarrage(p40, p41, p42, p43, p44) -- line: 458
    -- upvalues: BoxingConfig (copy), BoxingTechniques (copy), BoxingVisuals (copy), t3 (ref), track (copy), finish (copy), barrageTarget (copy), keepRange (copy), extendedArm (copy)
    local Humanoid = p40:FindFirstChildOfClass("Humanoid")
    local v61 = Humanoid ~= nil and BoxingTechniques.ClipsReady(p41)
    local v62, v63
    local v64 = v61 and extendedArm(Humanoid) or nil
    local v65 = if v61 and not p41.Rooted then keepRange(p40, p42, function() -- line: 465
        -- upvalues: v62 (ref), v63 (ref)
        return v62, v63
    end) else nil

    task.spawn(function() -- line: 469
        -- upvalues: p40 (copy), p41 (copy), p42 (copy), p43 (copy), p44 (copy), Humanoid (copy), v62 (ref), v63 (ref), v61 (copy), v64 (copy), v65 (copy), BoxingConfig (copy), BoxingTechniques (copy), BoxingVisuals (copy), t3 (ref), track (copy), finish (copy), barrageTarget (copy)
        local elapsed = os.clock()
        local n7 = 0
        local n8 = 0
        local n9 = 0
        local v67
        local v66

        while t3 do
            local v68

            if t3.Token ~= p42 or not (os.clock() - elapsed < p43) or p40:GetAttribute("Downed") then
                break
            else
                v68 = (p40:GetAttribute("StunnedUntil") or 0) > workspace:GetServerTimeNow()
            end

            local v70 = false
            local v71 = false
            local v72 = false
            local v73 = false
            local v74 = false
            local v75 = false

            if v68 then
                v75 = true
            else
                v70 = true
            end

            if v70 then
                if v61 then
                    v72 = true
                else
                    v71 = true
                end
            end

            v70 = false

            local v76, v77, v78

            if v71 then
                v76 = n7 + 1

                local v79 = p41.Sequence[(v76 - 1) % #p41.Sequence + 1]

                if p41.Halves then
                    v70 = true
                else
                    v78 = n8
                    v77 = v79
                    v73 = true
                end
            end

            v71 = false

            if v70 then
                if os.clock() - elapsed < p43 / 2 then
                    v74 = true
                else
                    v71 = true
                end
            end

            if v71 then
                v78 = n8 + 1
                v77 = p41.Sequence[(v78 - 1) % #p41.Sequence + 1]
                v73 = true
            end

            v71 = false

            if v74 then
                v78 = 0
                v77 = p41.Sequence[1]
                v73 = true
            end

            v74 = false

            local v80, v81, v82, v83, v84

            if v73 then
                BoxingVisuals.Play(p40, v77, 1, p44 or "Head", false)
                v83 = v76
                v84 = v78
                v80 = v66
                v82 = n9
                v81 = v67
                v75 = false
            end

            v73 = false

            local v85, v86, v87, v88, v89, v90

            if v72 then
                v85, v86, v87 = BoxingTechniques.BarragePhase(p41, os.clock() - elapsed)

                if v85 == v66 then
                    v88 = v66
                    v90 = n9
                    v89 = v67
                    v71 = true
                else
                    v74 = true
                end
            end

            v72 = false

            if v74 then
                if v64 then
                    v72 = true
                else
                    v73 = true
                end
            end

            v74 = false

            if v72 then
                v64.Back()

                if v86.Extended then
                    v74 = true
                else
                    v73 = true
                end
            end

            v72 = false

            if v74 then
                local _, v91 = barrageTarget(p40, 8)

                v73 = true
                v64.Out(v91, p42)
            end

            v74 = false

            if v73 then
                if v86.Stance then
                    v74 = true
                else
                    v72 = true
                end
            end

            v73 = false

            local v92

            if v74 then
                local v93 = BoxingTechniques.ClipId(v86.Stance)

                if v93 then
                    v92 = v93
                    v73 = true
                else
                    v72 = true
                end
            end

            v74 = false

            if v72 then
                v92 = nil
                v73 = true
            end

            v72 = false

            if v73 then
                if v92 then
                    v72 = true
                else
                    v74 = true
                end
            end

            v73 = false

            local v94

            if v72 then
                local v95 = track(Humanoid, v92, true)

                if v95 then
                    v94 = v95
                    v73 = true
                else
                    v74 = true
                end
            end

            v72 = false

            if v74 then
                v94 = nil
                v73 = true
            end

            v74 = false

            local v96

            if v73 then
                v96 = v86.Fade or 0.12

                if v67 then
                    v74 = true
                else
                    v72 = true
                end
            end

            v73 = false

            if v74 then
                if v67 == v94 then
                    v72 = true
                else
                    v73 = true
                end
            end

            v74 = false

            if v73 then
                if v67.IsPlaying then
                    v74 = true
                else
                    v72 = true
                end
            end

            v73 = false

            if v74 then
                v72 = true
                v67:Stop(v96)
            end

            v74 = false

            if v72 then
                if v94 then
                    v74 = true
                else
                    v73 = true
                end
            end

            v72 = false

            if v74 then
                if v94.IsPlaying then
                    v73 = true
                else
                    v72 = true
                end
            end

            if v72 then
                v94.Priority = Enum.AnimationPriority.Action3
                v94:Play(v96)

                local Tracks = t3.Tracks

                v73 = true
                table.insert(Tracks, v94)
            end

            v72 = false

            local v97, v98

            if v73 then
                v97, v98 = BoxingTechniques.PhaseRange(v86)

                if v97 then
                    v72 = true
                else
                    v88 = v85
                    v90 = 0
                    v89 = v94
                    v71 = true
                end
            end

            v73 = false

            if v72 then
                v62 = v97
                v63 = v98
                v88 = v85
                v90 = 0
                v89 = v94
                v71 = true
            end

            v72 = false

            local Hits

            if v71 then
                Hits = v86.Hits

                if v64 then
                    v72 = true
                else
                    v73 = true
                end
            end

            v71 = false

            if v72 then
                if v86.Extended then
                    v71 = true
                else
                    v73 = true
                end
            end

            v72 = false

            if v71 then
                local _, v99 = barrageTarget(p40, 8)

                v73 = true
                v64.Weights(v99)
            end

            v71 = false

            if v73 then
                if Hits then
                    v71 = true
                else
                    v83 = n7
                    v84 = n8
                    v80 = v88
                    v82 = v90
                    v81 = v89
                    v75 = false
                end
            end

            v73 = false

            if v71 then
                if #Hits > 0 then
                    v73 = true
                else
                    v83 = n7
                    v84 = n8
                    v80 = v88
                    v82 = v90
                    v81 = v89
                    v75 = false
                end
            end

            v71 = false

            if v73 then
                if (v86.Windup or 0) - 0.001 <= v87 then
                    v71 = true
                else
                    v83 = n7
                    v84 = n8
                    v80 = v88
                    v82 = v90
                    v81 = v89
                    v75 = false
                end
            end

            v73 = false

            local v100, v101, v102, v103, Play, v104, Base, v105

            if v71 then
                v100 = v90 + 1
                v101 = Hits[(v100 - 1) % #Hits + 1]
                v102, v103 = barrageTarget(p40, 8)
                Play = BoxingVisuals.Play
                v104 = p40
                Base = v101.Base

                local Zone = v101.Zone

                if Zone then
                    v105 = Zone
                    v72 = true
                else
                    v73 = true
                end
            end

            v71 = false

            if v73 then
                if p44 then
                    v105 = p44
                    v72 = true
                else
                    v71 = true
                end
            end

            if v71 then
                v105 = "Head"
                v72 = true
            end

            v71 = false

            local v106

            if v72 then
                Play(v104, Base, 1, v105, false, BoxingTechniques.HitOverride(v101, v103))
                v106 = BoxingConfig.Punches[v101.Base]

                if v65 then
                    v71 = true
                else
                    v83 = n7
                    v84 = n8
                    v80 = v88
                    v82 = v100
                    v81 = v89
                    v75 = false
                end
            end

            v72 = false

            if v71 then
                if v102 then
                    v72 = true
                else
                    v83 = n7
                    v84 = n8
                    v80 = v88
                    v82 = v100
                    v81 = v89
                    v75 = false
                end
            end

            v71 = false

            if v72 then
                if v106 then
                    v71 = true
                else
                    v83 = n7
                    v84 = n8
                    v80 = v88
                    v82 = v100
                    v81 = v89
                    v75 = false
                end
            end

            v72 = false

            if v71 then
                if v106.Knockback then
                    v72 = true
                else
                    v83 = n7
                    v84 = n8
                    v80 = v88
                    v82 = v100
                    v81 = v89
                    v75 = false
                end
            end

            if v72 then
                v65(math.abs(v106.Knockback.Z) * 0.11, (math.max(v101.HitTime - 0.02, 0)))
                v83 = n7
                v84 = n8
                v80 = v88
                v82 = v100
                v81 = v89
                v75 = false
            end

            if v75 then
                break
            end

            v67 = v81
            task.wait(p41.Interval)
            n7 = v83
            n8 = v84
            v66 = v80
            n9 = v82
        end

        if v64 then
            v64.Back()
        end

        finish(p42)
    end)
end

local Sounds = BoxingConfig.Sounds

task.spawn(function() -- line: 551
    local function v109() -- line: 552
        local Sound = Instance.new("Sound")

        Sound.SoundId = "rbxassetid://103582912071516"
        game:GetService("ContentProvider"):PreloadAsync({
            Sound
        })
        Sound:Destroy()
    end

    pcall(v109)
end)

local function techSound(p45, p46, p47, p48) -- line: 560
    local HumanoidRootPart = p45 and p45:FindFirstChild("HumanoidRootPart")

    if not (HumanoidRootPart and p46) then
        return nil
    end

    local Sound = Instance.new("Sound")

    Sound.SoundId = p46
    Sound.Volume = p47 or 0.8
    Sound.PlaybackSpeed = p48 or 1
    Sound.RollOffMinDistance = 8
    Sound.RollOffMaxDistance = 100
    Sound.Parent = HumanoidRootPart
    Sound:Play()
    Sound.Ended:Once(function() -- line: 573
        -- upvalues: Sound (copy)
        Sound:Destroy()
    end)

    return Sound
end

local function fadeOut(p49, p50) -- line: 578
    if p49 and p49.Parent then
        game:GetService("TweenService"):Create(p49, TweenInfo.new(p50 or 0.2), {
            Volume = 0
        }):Play()
        game:GetService("Debris"):AddItem(p49, (p50 or 0.2) + 0.05)
    end
end

local self = setmetatable({}, {
    __mode = "k"
})

local function dempseySound(p51, p52) -- line: 586
    -- upvalues: Sounds (copy), techSound (copy), fadeOut (copy), self (copy)
    local v111 = self[p51] or {}

    self[p51] = v111

    local fadeOut2, Roll, v112

    if p52 ~= "Roll" and v111.Roll then
        fadeOut2 = fadeOut
        Roll = v111.Roll
        v112 = if p52 == "Hit" then 0.12 else 0.2
        fadeOut2(Roll, v112)
        v111.Roll = nil
    end

    if p52 ~= "Hit" and v111.Hit then
        fadeOut(v111.Hit, 0.25)
        v111.Hit = nil
    end

    if p52 ~= "Roll" or v111.Roll then
        if p52 == "Hit" and not v111.Hit then
            v111.Hit = techSound(p51, Sounds.DempseyHit, Sounds.DempseyHitVolume)
        end
    else
        v111.Roll = techSound(p51, Sounds.DempseyRoll, Sounds.DempseyRollVolume)
    end
end

local function startDempsey(p53, p54, p55, p56) -- line: 604
    -- upvalues: LocalPlayer (copy), BoxingTechniques (copy), BoxingStatEffects (copy), t3 (ref), finish (copy), play (copy), Sounds (copy), techSound (copy), fadeOut (copy), self (copy)
    local v113, v114 = BoxingTechniques.DempseyTimes(p55, BoxingStatEffects.Get(p53, "Leg Strength"), p53)

    if p55.RollForwardWalk then
        LocalPlayer:SetAttribute("ForwardWalkScale", p55.RollForwardWalk)
        LocalPlayer:SetAttribute("ForwardWalkUntil", os.clock() + v113)
    else
        LocalPlayer:SetAttribute("PunchLockedUntil", os.clock() + v113)
    end

    local v115 = play(p54, p55.RollAnim, 1, true)
    local v116 = self[p53] or {}

    self[p53] = v116

    if v116.Hit then
        fadeOut(v116.Hit, 0.25)
        v116.Hit = nil
    end

    if not v116.Roll then
        v116.Roll = techSound(p53, Sounds.DempseyRoll, Sounds.DempseyRollVolume)
    end

    table.insert(t3.Cleanup, function() -- line: 614
        -- upvalues: p53 (copy), fadeOut (copy), self (copy)
        local v118 = self[p53] or {}

        self[p53] = v118

        if v118.Roll then
            fadeOut(v118.Roll, 0.2)
            v118.Roll = nil
        end

        if v118.Hit then
            fadeOut(v118.Hit, 0.25)
            v118.Hit = nil
        end
    end)
    task.delay(v113, function() -- line: 617
        -- upvalues: p53 (copy), p54 (copy), p55 (copy), p56 (copy), v114 (copy), v115 (copy), LocalPlayer (copy), t3 (ref), play (copy), Sounds (copy), techSound (copy), fadeOut (copy), self (copy)
        if not t3 or t3.Token ~= p56 then
            return
        end

        if v115 then
            v115:Stop(0.1)
        end

        play(p54, p55.HitAnim, 1, true)

        local v119 = self[p53] or {}

        self[p53] = v119

        if v119.Roll then
            fadeOut(v119.Roll, 0.12)
            v119.Roll = nil
        end

        if not v119.Hit then
            v119.Hit = techSound(p53, Sounds.DempseyHit, Sounds.DempseyHitVolume)
        end

        LocalPlayer:SetAttribute("ForwardWalkUntil", 0)

        if p55.WalkMultiplier then
            LocalPlayer:SetAttribute("TechSlowMultiplier", p55.WalkMultiplier)
            LocalPlayer:SetAttribute("TechSlowUntil", os.clock() + v114)
        end
    end)
    task.delay(v113 + v114, finish, p56)
end

local t10 = {}

local function startClinch(p57, p58) -- line: 636
    -- upvalues: BoxingVisuals (copy), play (copy)
    play(p57, p58.Anims.Grab, 1)
    BoxingVisuals.DashSound(p57.Parent:FindFirstChild("HumanoidRootPart"))
end

local v120 = BoxingConfig.SkillInputBuffer or 0.25
local v121
local n10 = 0
local t11 = {
    Dempsey = true,
    Barrage = true
}

local function tryCancel(p59) -- line: 649
    -- upvalues: LocalPlayer (copy), BoxingConfig (copy), BoxingSkills (copy), TechniqueRemote (copy), t1 (copy), t3 (ref), finish (copy), v121 (ref), t11 (copy)
    if not t3 or not t11[t3.Kind] then
        return false
    end

    local Id = t3.Id
    local v122 = if LocalPlayer:GetAttribute("ActiveStance") == 2 then 2 else 1

    if Id == BoxingConfig.LoadoutOf(LocalPlayer)[t1[v122][p59]] then
        if not BoxingSkills.Has(LocalPlayer, "Technique Cancel") or os.clock() - (t3.StartedAt or 0) < 0.2 then
            return false
        end

        TechniqueRemote:FireServer("Cancel", t3.Id)
        finish()
        v121 = nil
        LocalPlayer:SetAttribute("TechniqueUntil", nil)
        LocalPlayer:SetAttribute("PunchLockedUntil", 0)
        LocalPlayer:SetAttribute("TechSlowUntil", 0)
        LocalPlayer:SetAttribute("ForwardWalkUntil", 0)

        return true
    end

    return false
end

local function useSlot(p60, p61) -- line: 666
    -- upvalues: LocalPlayer (copy), BoxingConfig (copy), BoxingTechniques (copy), BoxingStatEffects (copy), BoxingVisuals (copy), BoxingCamera (copy), TechniqueRemote (copy), t1 (copy), t2 (copy), t3 (ref), n1 (ref), finish (copy), lookSide (copy), canUse (copy), play (copy), startStrike (copy), startBarrage (copy), startDempsey (copy), v120 (copy), v121 (ref), n10 (ref), tryCancel (copy)
    local Character = LocalPlayer.Character
    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

    if not (Humanoid and Humanoid.Health > 0) then
        Character = nil
        Humanoid = nil
    end

    if Character and (p61 or not tryCancel(p60)) then
        if canUse(Character) then
            local v123 = if LocalPlayer:GetAttribute("ActiveStance") == 2 then 2 else 1
            local v124 = BoxingConfig.LoadoutOf(LocalPlayer)[t1[v123][p60]]
            local v125 = BoxingTechniques.Get(v124)

            if v125 then
                if (t2[v124] or 0) > os.clock() then
                    if not p61 and t2[v124] - os.clock() <= v120 then
                        local elapsed = os.clock()

                        v121 = p60
                        n10 = elapsed
                    end
                elseif not ((Character:GetAttribute("Stamina") or 0) < v125.StaminaCost * BoxingStatEffects.PunchStaminaMultiplier(Character)) and (not v125.Stances or v125.Stances[BoxingConfig.StanceOf(Character)]) then
                    v121 = nil
                    n1 += 1

                    local v126 = n1

                    t3 = {
                        Id = v124,
                        Kind = v125.Kind,
                        Token = v126,
                        Tracks = {},
                        Cleanup = {},
                        StartedAt = os.clock()
                    }
                    t2[v124] = os.clock() + v125.Cooldown * BoxingStatEffects.SkillCooldownMultiplier(Character)
                    LocalPlayer:SetAttribute("Cooldown_" .. v124, t2[v124])

                    local v127, v128

                    if v125.Kind == "Barrage" then
                        v128 = v125.Duration[1] + math.random() * (v125.Duration[2] - v125.Duration[1])
                        v127 = v128
                    elseif v125.Swing then
                        v128 = if LocalPlayer:GetAttribute("BoxingStyle") == "Uppercut" then "Uppercut" else "Hook"
                    elseif v125.Sided then
                        v128 = lookSide(Character)
                    elseif v125.Hits and v125.Hits[1] and v125.Hits[1].Zone == "Aim" then
                        v128 = BoxingCamera.GetAimZone() or "Head"
                    end

                    local v129 = BoxingTechniques.BusyTime(v125, BoxingStatEffects.Get(Character, "Leg Strength"), v127, Character)

                    LocalPlayer:SetAttribute("TechniqueUntil", os.clock() + v129)

                    if v125.Kind == "Strike" or v125.Kind == "Counter" or v125.Kind == "Clinch" then
                        if v125.Dash then
                            local v130 = v125.Dash.Delay + v125.Dash.Duration

                            LocalPlayer:SetAttribute("PunchLockedUntil", 0)
                            task.delay(v130, function() -- line: 725
                                -- upvalues: v126 (copy), v129 (copy), v130 (copy), LocalPlayer (copy), t3 (ref)
                                if not t3 or t3.Token ~= v126 then
                                    return
                                end

                                LocalPlayer:SetAttribute("PunchLockedUntil", os.clock() + math.max(0, v129 - v130))
                            end)
                        else
                            LocalPlayer:SetAttribute("PunchLockedUntil", os.clock() + v129)
                        end
                    end

                    for _, v132 in Humanoid:FindFirstChildOfClass("Animator"):GetPlayingAnimationTracks() do
                        for _, v133 in BoxingConfig.DashAnimationIds() do
                            if v132.Animation and v132.Animation.AnimationId == v133 then
                                v132:Stop(0.05)
                            end
                        end
                    end

                    TechniqueRemote:FireServer("Use", v124, v128)

                    if v125.Kind == "Strike" then
                        startStrike(Character, Humanoid, v125, v126, v128, v124)
                        task.delay(v129, finish, v126)
                    elseif v125.Kind == "Counter" then
                        task.delay(v129, function() -- line: 748
                            -- upvalues: v126 (copy), t3 (ref), finish (copy)
                            if t3 and t3.Token == v126 and not t3.Countering then
                                finish(v126)
                            end
                        end)
                    elseif v125.Kind == "Clinch" then
                        play(Humanoid, v125.Anims.Grab, 1)
                        BoxingVisuals.DashSound(Humanoid.Parent:FindFirstChild("HumanoidRootPart"))

                        local delay = task.delay
                        local v134 = v129 + 0.3
                        local Character2 = Character

                        delay(v134, function() -- line: 755
                            -- upvalues: v126 (copy), Character2 (copy), t3 (ref), finish (copy)
                            if t3 and t3.Token == v126 and not Character2:GetAttribute("ClinchState") then
                                finish(v126)
                            end
                        end)
                    elseif v125.Kind == "Barrage" then
                        if v125.ForwardWalk then
                            LocalPlayer:SetAttribute("ForwardWalkScale", v125.ForwardWalk)
                            LocalPlayer:SetAttribute("ForwardWalkUntil", os.clock() + v127)
                        elseif v125.Rooted then
                            LocalPlayer:SetAttribute("PunchLockedUntil", os.clock() + v127)
                        elseif v125.WalkMultiplier then
                            LocalPlayer:SetAttribute("TechSlowMultiplier", v125.WalkMultiplier)
                            LocalPlayer:SetAttribute("TechSlowUntil", os.clock() + v127)
                        end

                        startBarrage(Character, v125, v126, v127)
                    elseif v125.Kind == "Dempsey" then
                        startDempsey(Character, Humanoid, v125, v126)
                    elseif v125.Kind == "Buff" then
                        task.delay(v129, finish, v126)
                    end
                end
            end
        elseif not p61 then
            local elapsed = os.clock()

            v121 = p60
            n10 = elapsed
        end
    end
end

TechniqueRemote.OnClientEvent:Connect(function(p62, p63, p64, p65, ...) -- line: 780
    -- upvalues: LocalPlayer (copy), BoxingConfig (copy), BoxingTechniques (copy), BoxingVisuals (copy), t2 (copy), t3 (ref), track (copy), finish (copy), techSound (copy)
    if p62 == "Denied" then
        if t3 and t3.Id == p63 then
            finish()
        end

        t2[p63] = 0
        LocalPlayer:SetAttribute("Cooldown_" .. tostring(p63), 0)
    elseif p62 == "Stop" then
        if t3 and t3.Id == p63 then
            finish()
        end
    elseif p62 == "Countered" then
        local v135 = ...
        local CrossCounter = BoxingTechniques.List.CrossCounter
        local Character = LocalPlayer.Character

        if type(v135) == "string" then
            if p63 == Character then
                local Character2 = LocalPlayer.Character
                local Humanoid = Character2 and Character2:FindFirstChildOfClass("Humanoid")

                if not (Humanoid and Humanoid.Health > 0) then
                    Humanoid = nil
                end

                local v136 = Humanoid and BoxingConfig.PunchAnimation(v135, "Head", Character)

                if t3 then
                    t3.Countering = true
                end

                local v137 = v136 and track(Humanoid, v136, false)

                if v137 then
                    v137:Play(0.05)
                end

                LocalPlayer:SetAttribute("PunchLockedUntil", os.clock() + 0.7)

                local v138 = t3 and t3.Token

                task.delay(0.7, finish, v138)
            elseif p64 == Character then
                local Character2 = LocalPlayer.Character
                local Humanoid = Character2 and Character2:FindFirstChildOfClass("Humanoid")

                if not (Humanoid and Humanoid.Health > 0) then
                    Humanoid = nil
                end

                if Humanoid then
                    BoxingVisuals.CancelPunch(Character)

                    local v139 = track(Humanoid, BoxingTechniques.List.SwingCounter.VictimAnim, false)

                    if v139 then
                        v139:Play(0.05)
                    end
                end
            end
        else
            if p65 and typeof(p63) == "Instance" then
                techSound(p63, "rbxassetid://103582912071516", 1)
            end

            if p63 == Character then
                local Character = LocalPlayer.Character
                local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

                if not (Humanoid and Humanoid.Health > 0) then
                    Humanoid = nil
                end

                if Humanoid then
                    if t3 then
                        t3.Countering = true
                    end

                    local v141 = track(Humanoid, if p65 then CrossCounter.JoltAnim else CrossCounter.Anim, false)

                    if v141 then
                        v141:Play(0.05)
                    end

                    LocalPlayer:SetAttribute("PunchLockedUntil", os.clock() + 1)

                    local v142 = t3 and t3.Token

                    task.delay(1, finish, v142)
                end
            elseif p64 == Character then
                local Character2 = LocalPlayer.Character
                local Humanoid = Character2 and Character2:FindFirstChildOfClass("Humanoid")

                if not (Humanoid and Humanoid.Health > 0) then
                    Humanoid = nil
                end

                if Humanoid then
                    BoxingVisuals.CancelPunch(Character)

                    local v143 = track(Humanoid, CrossCounter.VictimAnim, false)

                    if v143 then
                        v143:Play(0.05)
                    end
                end
            end
        end
    end
end)
BoxingRemote.OnClientEvent:Connect(function(p66, p67) -- line: 855
    -- upvalues: LocalPlayer (copy)
    if p66 == "StanceDenied" and type(p67) == "number" then
        LocalPlayer:SetAttribute("ActiveStance", p67)
    end
end)

local function onClinchState(p68) -- line: 868
    -- upvalues: LocalPlayer (copy), t3 (ref), finish (copy)
    local Character = LocalPlayer.Character
    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

    if not (Humanoid and Humanoid.Health > 0) then
        Humanoid = nil
    end

    if Humanoid and p68 == LocalPlayer.Character then
        local ClinchState = p68:GetAttribute("ClinchState")

        if ClinchState ~= "Hold" or not t3 then
            if ClinchState == nil then
                finish()
            end
        else
            LocalPlayer:SetAttribute("TechniqueUntil", os.clock() + 4)
            LocalPlayer:SetAttribute("PunchLockedUntil", os.clock() + 4)
        end
    end
end

local t12

RunService.RenderStepped:Connect(function() -- line: 883
    -- upvalues: LocalPlayer (copy), BoxingTechniques (copy), track (copy), t12 (ref)
    local Character = LocalPlayer.Character
    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

    if not (Humanoid and Humanoid.Health > 0) then
        Character = nil
        Humanoid = nil
    end

    local v144 = Character

    if Character then
        v144 = Character:GetAttribute("ClinchT0")
        Character = Character:GetAttribute("ClinchRole")
    end

    local Clinch = BoxingTechniques.List.Clinch
    local PushOff = Clinch.PushOff

    if v144 and Character and Humanoid then
        if not t12 or t12.Role ~= Character then
            local v145 = if Character == "Held" then PushOff.Hands else Clinch.Anims.Hold
            local v146 = if Character == "Held" then PushOff.Shove else Clinch.Anims.Pushed
            local v147 = track(Humanoid, v145, true)
            local v148 = track(Humanoid, v146, true)

            if not v147 or not v148 then
                return
            end

            for _, v149 in { v147, v148 } do
                if not v149.IsPlaying then
                    v149:Play(0, 0.001)
                end
            end

            t12 = {
                Role = Character,
                A = v147,
                B = v148
            }

            if Character == "Holder" then
                local v150 = track(Humanoid, Clinch.Anims.Grab, false)

                if v150 and v150.IsPlaying then
                    v150:Stop((math.max(PushOff.Settle - (workspace:GetServerTimeNow() - v144), 0.05)))
                end
            end
        end

        local v152 = BoxingTechniques.ClinchPose(Clinch, workspace:GetServerTimeNow() - v144)
        local v153 = if Character == "Held" then v152.Held else v152.Holder
        local v154 = if Character == "Held" then v152.W else v152.V

        t12.A:AdjustWeight(math.max(v153 * (1 - v154), 0.001), 0)
        t12.B:AdjustWeight(math.max(v153 * v154, 0.001), 0)
        Humanoid.CameraOffset = Vector3.new(0, 0, if Character == "Held" then PushOff.HeldTorsoBack * v152.Held * (1 - v152.W) else PushOff.HolderTorsoBack * v152.Holder * v152.V)
    elseif t12 then
        t12.A:Stop(0.25)
        t12.B:Stop(0.25)
        t12 = nil
    elseif Humanoid and Humanoid.CameraOffset.Magnitude > 0.001 then
        Humanoid.CameraOffset = Humanoid.CameraOffset:Lerp(Vector3.new(0, 0, 0), 0.3)

        if Humanoid.CameraOffset.Magnitude < 0.01 then
            Humanoid.CameraOffset = Vector3.new(0, 0, 0)
        end
    end
end)

local t13 = {}
local t14 = {}
local t15 = {}

local function scan(p69) -- line: 939
    -- upvalues: t13 (copy), t14 (copy), t15 (copy), scan (copy)
    if type(p69) == "string" then
        if p69:sub(1, 13) == "rbxassetid://" and not t15[p69] then
            t15[p69] = true
            table.insert(t13, p69)
        end
    elseif type(p69) == "table" and not t14[p69] then
        t14[p69] = true

        for _, v158 in p69 do
            scan(v158)
        end
    end
end

scan(BoxingTechniques.List)
task.spawn(function() -- line: 953
    -- upvalues: t13 (copy)
    local t16 = {}

    for _, v159 in t13 do
        local Animation = Instance.new("Animation")

        Animation.AnimationId = v159
        table.insert(t16, Animation)
    end

    local PreloadAsync = game:GetService("ContentProvider").PreloadAsync
    local ContentProvider = game:GetService("ContentProvider")

    pcall(PreloadAsync, ContentProvider, t16)
end)

local function hookCharacter(p70) -- line: 964
    -- upvalues: LocalPlayer (copy), BoxingTechniques (copy), t2 (copy), t3 (ref), track (copy), finish (copy), t10 (copy), onClinchState (copy), t12 (ref), t13 (copy)
    table.clear(t10)
    t12 = nil
    task.spawn(function() -- line: 968
        -- upvalues: p70 (copy), track (copy), t13 (copy)
        local v160 = p70:WaitForChild("Humanoid", 10)

        if v160 and v160:WaitForChild("Animator", 10) then
            for _, v161 in t13 do
                if v160.Parent then
                    track(v160, v161, false)
                end
            end
        end
    end)
    task.spawn(function() -- line: 979
        -- upvalues: p70 (copy), BoxingTechniques (copy), track (copy)
        local v162 = p70:WaitForChild("Humanoid", 10)
        local Clinch = BoxingTechniques.List.Clinch

        if not (v162 and v162:WaitForChild("Animator", 10)) then
            return
        end

        local t17 = {}

        for _, v163 in {
                Clinch.PushOff.Hands,
                Clinch.PushOff.Shove,
                Clinch.Anims.Hold,
                Clinch.Anims.Pushed
            } do
            local Animation = Instance.new("Animation")

            Animation.AnimationId = v163
            table.insert(t17, Animation)
            track(v162, v163, true)
        end

        local PreloadAsync = game:GetService("ContentProvider").PreloadAsync
        local ContentProvider = game:GetService("ContentProvider")

        pcall(PreloadAsync, ContentProvider, t17)
    end)

    if t3 then
        finish()
    end

    p70:GetAttributeChangedSignal("LegendaryUntil"):Connect(function() -- line: 997
        -- upvalues: p70 (copy), LocalPlayer (copy), t2 (copy)
        if (p70:GetAttribute("LegendaryUntil") or 0) > workspace:GetServerTimeNow() then
            t2.DempseyRoll = 0
            LocalPlayer:SetAttribute("Cooldown_DempseyRoll", 0)
        end
    end)
    p70:GetAttributeChangedSignal("ClinchState"):Connect(function() -- line: 1003
        -- upvalues: p70 (copy), onClinchState (copy)
        onClinchState(p70)
    end)
end

LocalPlayer.CharacterAdded:Connect(hookCharacter)

if LocalPlayer.Character then
    hookCharacter(LocalPlayer.Character)
end

local t18 = {}

RunService.Heartbeat:Connect(function() -- line: 1015
    -- upvalues: Players (copy), LocalPlayer (copy), t3 (ref), finish (copy), v120 (copy), v121 (ref), n10 (ref), useSlot (copy), t18 (copy)
    local ServerTimeNow = workspace:GetServerTimeNow()

    for _, player in Players:GetPlayers() do
        local Character = player.Character

        if Character then
            local v164 = ServerTimeNow < (Character:GetAttribute("CounterReadyUntil") or 0)
            local v165 = t18[Character]

            if v164 then
                if not v165 then
                    local Highlight = Instance.new("Highlight")

                    Highlight.Name = "CounterReady"
                    Highlight.FillTransparency = 1
                    Highlight.OutlineColor = Color3.fromRGB(255, 236, 160)
                    Highlight.OutlineTransparency = 0.2
                    Highlight.DepthMode = Enum.HighlightDepthMode.Occluded
                    Highlight.Parent = Character
                    t18[Character] = Highlight
                end
            elseif v165 then
                v165:Destroy()
                t18[Character] = nil
            end
        end
    end

    if v121 then
        if os.clock() - n10 > v120 then
            v121 = nil
        else
            useSlot(v121, true)
        end
    end

    local Character = LocalPlayer.Character

    if t3 and Character and (Character:GetAttribute("Downed") or t3.Kind ~= "Clinch" and (Character:GetAttribute("StunnedUntil") or 0) > workspace:GetServerTimeNow() and not t3.Countering) then
        finish()
    end
end)

local t20 = {}
local v167 = setmetatable(t20, {
    __mode = "k"
})

local function watchCharacter(p71) -- line: 1057
    -- upvalues: LocalPlayer (copy), BoxingTechniques (copy), BoxingVisuals (copy), Sounds (copy), techSound (copy), dempseySound (copy), v167 (copy)
    p71:GetAttributeChangedSignal("DempseyPhase"):Connect(function() -- line: 1058
        -- upvalues: p71 (copy), LocalPlayer (copy), dempseySound (copy)
        if p71 ~= LocalPlayer.Character then
            dempseySound(p71, p71:GetAttribute("DempseyPhase"))
        end
    end)

    local v168 = p71:GetAttribute("ClinchState") ~= nil

    p71:GetAttributeChangedSignal("ClinchState"):Connect(function() -- line: 1064
        -- upvalues: p71 (copy), v168 (ref), LocalPlayer (copy), BoxingVisuals (copy)
        local ClinchState = p71:GetAttribute("ClinchState")

        if ClinchState and not v168 and p71 ~= LocalPlayer.Character then
            BoxingVisuals.DashSound(p71:FindFirstChild("HumanoidRootPart"))
        end

        v168 = ClinchState ~= nil
    end)
    p71:GetAttributeChangedSignal("ClinchT0"):Connect(function() -- line: 1071
        -- upvalues: p71 (copy), BoxingTechniques (copy), Sounds (copy), techSound (copy), v167 (copy)
        local ClinchT0 = p71:GetAttribute("ClinchT0")

        if ClinchT0 and p71:GetAttribute("ClinchRole") == "Holder" and v167[p71] ~= ClinchT0 then
            v167[p71] = ClinchT0

            local Settle = BoxingTechniques.List.Clinch.PushOff.Settle

            task.delay(math.max(0, ClinchT0 + Settle * 0.6 - workspace:GetServerTimeNow()), function() -- line: 1078
                -- upvalues: ClinchT0 (copy), p71 (copy), Sounds (copy), techSound (copy)
                if p71:GetAttribute("ClinchT0") == ClinchT0 then
                    techSound(p71, Sounds.ClinchGrab, Sounds.ClinchGrabVolume)
                end
            end)
        end
    end)
end

local function watchPlayer(p72) -- line: 1085
    -- upvalues: watchCharacter (copy)
    p72.CharacterAdded:Connect(watchCharacter)

    if p72.Character then
        watchCharacter(p72.Character)
    end
end

Players.PlayerAdded:Connect(watchPlayer)

for _, player in Players:GetPlayers() do
    player.CharacterAdded:Connect(watchCharacter)

    if player.Character then
        watchCharacter(player.Character)
    end
end

local spawn = require(ReplicatedStorage:WaitForChild("Boxing"):WaitForChild("BoxingVirtualInput"))

local function switchStance() -- line: 1100
    -- upvalues: LocalPlayer (copy), BoxingRemote (copy), BoxingPassives (copy), t3 (ref)
    local v170, v171

    if not LocalPlayer:GetAttribute("BoxingEquipped") or t3 then
        v171 = true
    elseif BoxingPassives.CanSwitchStance(LocalPlayer) then
        v170 = if LocalPlayer:GetAttribute("ActiveStance") == 2 then 1 else 2
        v171 = false
    else
        v171 = true
    end

    if v171 then
        return
    end

    LocalPlayer:SetAttribute("ActiveStance", v170)
    LocalPlayer:SetAttribute("StanceSwitchReadyAt", workspace:GetServerTimeNow() + BoxingPassives.StanceSwitchCooldown(LocalPlayer))
    BoxingRemote:FireServer("Stance", v170)
end

UserInputService.InputBegan:Connect(function(p73, p74) -- line: 1110
    -- upvalues: UserInputService (copy), LocalPlayer (copy), BoxingConfig (copy), TechniqueRemote (copy), t3 (ref), useSlot (copy), switchStance (copy)
    if UserInputService:GetFocusedTextBox() then
        return
    end

    local Character = LocalPlayer.Character

    if Character and Character:GetAttribute("ClinchedBy") and (p73.UserInputType == Enum.UserInputType.MouseButton1 or p73.UserInputType == Enum.UserInputType.MouseButton2 or p73.UserInputType == Enum.UserInputType.Touch) then
        return
    end

    if t3 and t3.Id == "SwingCounter" and not t3.Countering then
        if p73.UserInputType == Enum.UserInputType.MouseButton1 then
            TechniqueRemote:FireServer("CounterPick", "Hook")
        elseif p73.UserInputType == Enum.UserInputType.MouseButton2 then
            TechniqueRemote:FireServer("CounterPick", "Uppercut")
        end
    end

    if not p74 then
        for v172, v173 in BoxingConfig.SkillKeys or {} do
            if p73.KeyCode == v173 then
                useSlot(v172)

                return
            end
        end

        if p73.KeyCode == BoxingConfig.StanceSwitchKey then
            switchStance()
        end
    end
end)
spawn.Changed:Connect(function(p75, p76) -- line: 1144
    -- upvalues: UserInputService (copy), TechniqueRemote (copy), t3 (ref), useSlot (copy), switchStance (copy)
    if p76 and not UserInputService:GetFocusedTextBox() then
        if t3 and t3.Id == "SwingCounter" and not t3.Countering and (p75 == "PunchLeft" or p75 == "PunchRight") then
            TechniqueRemote:FireServer("CounterPick", p75 == "PunchRight" and "Uppercut" or "Hook")
        elseif p75 == "Tech1" then
            useSlot(1)
        elseif p75 == "Tech2" then
            useSlot(2)
        elseif p75 == "Stance" then
            switchStance()
        end
    end
end)
