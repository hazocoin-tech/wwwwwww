-- https://lua.expert

local RunService = game:GetService("RunService")
local t1 = {
    Settings = {
        Period = 1.8,
        DampingRatio = 0.2,
        MinAngle = 0.10471975511965978,
        MaxAngle = 1.0471975511965976,
        KickSoftCap = 0.6864379948093697,
        PowerMax = 10,
        WeightFactor = {
            Light = 0.5,
            Medium = 0.75,
            Heavy = 1
        },
        MaxTilt = 0.6981317007977318,
        DentDepth = 0.3,
        DentPowerDepth = 0.7,
        DentIn = 0.05,
        DentOut = 0.35,
        DentHeight = 1,
        DentFacingPower = 4,
        CreakSound = "rbxassetid://9119688363",
        CreakAngle = 0.2617993877991494,
        CreakVolume = { 0.12, 0.35 },
        CreakGap = 0.5,
        ThudSound = "rbxassetid://9113469292",
        ThudFromPower = 0.5,
        ThudVolume = { 0.25, 0.8 },
        ThudPitch = { 1, 0.82 },
        ThudLength = 0.55,
        BagMesh = true,
        BagMeshId = "",
        BagModel = "Blender",
        BagSegments = 64,
        BagRowSpacing = 0.08,
        BagSeamDepth = 0.04,
        BagShade = 0.5,
        BagSeamShade = 0.3,
        BagStitchShade = 0.95,
        BagTabColor = Color3.fromRGB(22, 22, 22),
        BagMaxBuilt = 4,
        BagBuildRange = 45,
        BagReleaseRange = 70,
        DentRadius = { 0.5, 0.55 },
        DentBulge = 0.1,
        PushReach = 1.3,
        PushMinSpeed = 2,
        PushImpact = 0.05235987755982989,
        PushImpactMax = 0.12217304763960307,
        PushLean = 0.9,
        PushSync = 0.1
    }
}
local Settings = t1.Settings
local v1 = 6.283185307179586 / Settings.Period
local v2 = 2 * Settings.DampingRatio * v1
local t2 = {}

local function mainPart(p1) -- line: 90
    return p1:FindFirstChild("PhysicsPart") or p1.PrimaryPart or p1:FindFirstChildWhichIsA("BasePart", true)
end

local function stateFor(p2) -- line: 94
    -- upvalues: RunService (copy), t2 (copy)
    local v3 = t2[p2]

    if v3 then
        return v3
    end

    local PhysicsPart = p2:FindFirstChild("PhysicsPart") or p2.PrimaryPart or p2:FindFirstChildWhichIsA("BasePart", true)

    if not PhysicsPart then
        return nil
    end

    local v4 = not RunService:IsClient()
    local t3 = {}

    for _, descendant in p2:GetDescendants() do
        if descendant:IsA("BasePart") then
            local BagRest = descendant:GetAttribute("BagRest")

            if typeof(BagRest) ~= "CFrame" then
                BagRest = descendant.CFrame

                if v4 then
                    descendant:SetAttribute("BagRest", BagRest)
                end
            end

            t3[descendant] = BagRest
        end
    end

    local v5 = t3[PhysicsPart] or PhysicsPart.CFrame
    local CenterRopeAtt = PhysicsPart:FindFirstChild("CenterRopeAtt")
    local t4 = {
        Theta = Vector3.new(0, 0, 0),
        Omega = Vector3.new(0, 0, 0),
        Moving = false,
        Parts = t3,
        Pivot = if CenterRopeAtt then v5:PointToWorldSpace(CenterRopeAtt.Position) else v5:PointToWorldSpace((Vector3.new(0, PhysicsPart.Size.Y / 2, 0)))
    }

    t2[p2] = t4

    return t4
end

function t1.PowerFraction(p3) -- line: 128
    -- upvalues: Settings (copy)
    local _require = require
    local Parent = script.Parent
    local ok, result = pcall(_require, Parent:WaitForChild("BoxingStatEffects"))

    if not ok or not p3 then
        return 0
    end

    return (math.clamp((result.Get(p3, "Arm Strength") + result.Get(p3, "Leg Strength")) / Settings.PowerMax, 0, 1))
end

function t1.KickFor(p4, p5, p6, p7) -- line: 138
    -- upvalues: Settings (copy), v1 (copy)
    local v9 = Vector3.new(p7.X, 0, p7.Z)

    if v9.Magnitude < 0.001 then
        return (Vector3.new(0, 0, 0))
    end

    local v15 = (Settings.MinAngle + (Settings.MaxAngle - Settings.MinAngle) * math.clamp(p6 or 0, 0, 1)) * ((Settings.WeightFactor[p4 and p4.Weight or "Light"] or 0.5) * (math.clamp(p5 or 1, 0, 1) * 0.4 + 0.6))
    local v17 = Settings.KickSoftCap * math.tanh(v15 / Settings.KickSoftCap)

    return v9.Unit * v17 * v1
end

function t1.CleanFor(p8, p9, p10, p11, p12) -- line: 154
    local v19 = math.max(-p8.HitboxOffset.Z + p8.HitboxSize.Z / 2, 1)
    local v22 = 1 - math.clamp(math.abs(p11 - v19 * (p12 or 1)) / (v19 * 0.55), 0, 1)
    local v23 = (p10 - p9.Position) * Vector3.new(1, 0, 1)
    local v25 = math.clamp(((if v23.Magnitude > 0.01 then p9.LookVector:Dot(v23.Unit) else 1) - 0.5) / 0.45, 0, 1)

    return math.clamp(v22 * 0.85 * (v25 * 0.6 + 0.4) + 0.15, 0, 1), if v23.Magnitude > 0.01 then v23.Unit else p9.LookVector
end

function t1.KickAngle(p13, p14) -- line: 167
    -- upvalues: v1 (copy)
    local v27 = Vector3.new(p13.X, 0, p13.Z)

    if v27.Magnitude < 0.001 then
        return (Vector3.new(0, 0, 0))
    end

    return v27.Unit * p14 * v1
end

function t1.Register(p15) -- line: 176
    -- upvalues: stateFor (copy)
    stateFor(p15)
end

function t1.Kick(p16, p17) -- line: 180
    -- upvalues: t1 (copy), stateFor (copy)
    if t1.PhysicsOn and not t1.PhysicsOn() then
        return
    end

    local v28 = p16 and stateFor(p16)

    if v28 and typeof(p17) == "Vector3" then
        v28.Omega = v28.Omega + Vector3.new(p17.X, 0, p17.Z)
        v28.Moving = true
    end
end

local function swingCFrame(p18) -- line: 192
    local Magnitude = p18.Theta.Magnitude

    if Magnitude < 1E-05 then
        return CFrame.identity
    end

    local v29 = p18.Theta.Unit:Cross((Vector3.new(0, 1, 0)))

    return CFrame.new(p18.Pivot) * CFrame.fromAxisAngle(v29, Magnitude) * CFrame.new(-p18.Pivot)
end

local v30

if RunService:IsClient() then
    v30 = function(p19, p20) -- line: 203
        -- upvalues: Settings (copy)
        local Magnitude = p20.Theta.Magnitude
        local elapsed = os.clock()
        local PhysicsPart, v31

        if Magnitude < Settings.CreakAngle or elapsed - (p20.CreakAt or 0) < Settings.CreakGap then
            v31 = true
        elseif Settings.CreakSound then
            p20.CreakAt = elapsed
            PhysicsPart = p19:FindFirstChild("PhysicsPart") or p19.PrimaryPart or p19:FindFirstChildWhichIsA("BasePart", true)
            v31 = false
        else
            v31 = true
        end

        if v31 then
            return
        end

        PhysicsPart = PhysicsPart and (PhysicsPart:FindFirstChild("CenterRopeAtt") or PhysicsPart)

        if not PhysicsPart then
            return
        end

        local v33 = math.clamp((Magnitude - Settings.CreakAngle) / (Settings.MaxTilt - Settings.CreakAngle), 0, 1)
        local Sound = Instance.new("Sound")

        Sound.SoundId = Settings.CreakSound
        Sound.Volume = Settings.CreakVolume[1] + (Settings.CreakVolume[2] - Settings.CreakVolume[1]) * v33
        Sound.PlaybackSpeed = 0.85 + math.random() * 0.15
        Sound.RollOffMinDistance = 8
        Sound.RollOffMaxDistance = 60
        Sound.Parent = PhysicsPart
        Sound:Play()
        Sound.Ended:Once(function() -- line: 225
            -- upvalues: Sound (copy)
            Sound:Destroy()
        end)
        task.delay(4, function() -- line: 228
            -- upvalues: Sound (copy)
            if Sound.Parent then
                Sound:Destroy()
            end
        end)
    end
else
    v30 = function() -- line: 235
    end
end

local v34 = not RunService:IsClient()

local function place(p21) -- line: 245
    -- upvalues: swingCFrame (copy)
    local v35 = swingCFrame(p21)

    for v36, v37 in p21.Parts do
        if v36.Parent then
            v36.CFrame = v35 * v37
        end
    end

    p21.PlacedAt = os.clock()
    p21.Stale = false
end

function t1.PlaceAll() -- line: 257
    -- upvalues: t2 (copy), swingCFrame (copy)
    for v38, v39 in t2 do
        if v39.Stale and v38.Parent then
            local v40 = swingCFrame(v39)

            for v41, v42 in v39.Parts do
                if v41.Parent then
                    v41.CFrame = v40 * v42
                end
            end

            v39.PlacedAt = os.clock()
            v39.Stale = false
        end
    end
end

local function step(p22) -- line: 265
    -- upvalues: Settings (copy), v1 (copy), v2 (copy), t2 (copy), swingCFrame (copy), v30 (ref), v34 (copy)
    local v43 = math.min(p22, 0.05)
    local elapsed = os.clock()

    for v44, v45 in t2 do
        if v44.Parent then
            if v45.Moving then
                local v46 = v43 / 3

                for _ = 1, 3 do
                    v45.Omega += (-v1 * v1 * v45.Theta - v2 * v45.Omega) * v46
                    v45.Theta += v45.Omega * v46
                end

                if v45.Theta.Magnitude > Settings.MaxTilt then
                    v45.Theta = v45.Theta.Unit * Settings.MaxTilt
                    v45.Omega *= 0.5
                end

                local v47 = v45.Theta:Dot(v45.Omega)

                if v45.Outward and v45.Outward > 0 and v47 <= 0 then
                    v30(v44, v45)
                end

                v45.Outward = v47

                local v48 = v45.Theta.Magnitude < 1E-04 and v45.Omega.Magnitude < 0.001

                if v48 then
                    v45.Theta = Vector3.new(0, 0, 0)
                    v45.Omega = Vector3.new(0, 0, 0)
                    v45.Moving = false
                end

                if not v34 or v48 or elapsed - (v45.PlacedAt or 0) >= 0.08333333333333333 then
                    local v52 = swingCFrame(v45)

                    for v53, v54 in v45.Parts do
                        if v53.Parent then
                            v53.CFrame = v52 * v54
                        end
                    end

                    v45.PlacedAt = os.clock()
                    v45.Stale = false
                else
                    v45.Stale = true
                end
            end
        else
            t2[v44] = nil
        end
    end
end

local AssetService = game:GetService("AssetService")
local t5 = {}
local t6 = {}
local t7 = {}

local function loadBag(p23) -- line: 316
    -- upvalues: Settings (copy), AssetService (copy)
    local Size = p23.Size
    local v55 = AssetService:CreateEditableMeshAsync(Content.fromUri(Settings.BagMeshId), {
        FixedSize = true
    })
    local v56 = Vector3.new(1, 1, 1) * 1e999
    local v57 = Vector3.new(-1, -1, -1, -0) * 1e999

    for _, v58 in v55:GetVertices() do
        local Position = v55:GetPosition(v58)

        v56 = v56:Min(Position)
        v57 = v57:Max(Position)
    end

    local v59 = (v56 + v57) / 2
    local t8 = {}
    local t9 = {}
    local t10 = {}

    for _, v60 in v55:GetVertices() do
        local Position = v55:GetPosition(v60)
        local v63 = Vector3.new(Position.X - v59.X, 0, Position.Z - v59.Z)

        t8[v60] = Position

        if v63.Magnitude > 1E-04 then
            t9[v60] = v63.Unit
        else
            t9[v60] = Vector3.new(0, 0, 0)
        end

        table.insert(t10, v60)
    end

    local function v64() -- line: 333
        -- upvalues: v55 (copy), AssetService (copy)
        return AssetService:CreateMeshPartAsync(Content.fromObject(v55), {
            CollisionFidelity = Enum.CollisionFidelity.Hull
        })
    end

    local ok, result = pcall(v64)

    if not ok then
        v55:Destroy()
        error(result)
    end

    local clone = p23:Clone()

    clone:ClearAllChildren()
    p23:ApplyMesh(result)
    result:Destroy()

    return {
        Original = clone,
        Mesh = v55,
        Rest = t8,
        Out = t9,
        Ids = t10,
        Main = p23,
        Centre = v59,
        Scale = (v57 - v56) / Size,
        Radius = math.min(Size.X, Size.Z) / 2,
        Moved = {}
    }
end

local v65

local function base64Decode(p24) -- line: 360
    local function v66() -- line: 361
        -- upvalues: p24 (copy)
        return game:GetService("EncodingService"):Base64Decode(buffer.fromstring(p24))
    end

    local ok, result = pcall(v66)

    if ok and result then
        return result
    end

    local t12 = {}

    for i = 1, 64 do
        t12[string.byte("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/", i)] = i - 1
    end

    local v67 = string.gsub(p24, "[^%w%+/]", "")
    local v69 = math.floor(#v67 * 3 / 4)
    local v70 = buffer.create(v69)
    local n1 = 0

    for i = 1, #v67, 4 do
        local v72, v73, v74, v75 = string.byte(v67, i, i + 3)
        local v76 = t12[v72] * 262144 + t12[v73] * 4096
        local v77 = if v74 then t12[v74] else nil
        local v78 = v76 + (if not v74 or not v77 then 0 else v77) * 64
        local v79 = if v75 then t12[v75] else nil
        local v80 = v78 + (if not v75 or not v79 then 0 else v79)

        if n1 < v69 then
            buffer.writeu8(v70, n1, (bit32.rshift(v80, 16)))
        end

        if n1 + 1 < v69 then
            buffer.writeu8(v70, n1 + 1, (bit32.band(bit32.rshift(v80, 8), 255)))
        end

        if n1 + 2 < v69 then
            buffer.writeu8(v70, n1 + 2, (bit32.band(v80, 255)))
        end

        n1 += 3
    end

    return v70
end

local function getBlenderData() -- line: 388
    -- upvalues: v65 (ref), base64Decode (copy)
    if v65 ~= nil then
        return v65 or nil
    end

    v65 = false

    local HeavyBagMesh = script.Parent:FindFirstChild("HeavyBagMesh")

    if HeavyBagMesh then
        local _require = require
        local ok, result = pcall(_require, HeavyBagMesh)

        if ok then
            v65 = {
                Info = result,
                Bytes = base64Decode(result.Data)
            }
        end
    end

    return v65 or nil
end

local function buildBlenderBag(p25, p26) -- line: 404
    -- upvalues: AssetService (copy)
    local Info, Bytes = p26.Info, p26.Bytes
    local Size = p25.Size
    local Vertices, Triangles = Info.Vertices, Info.Triangles
    local v87 = AssetService:CreateEditableMesh({})
    local elapsed = os.clock()

    local function breathe() -- line: 410
        -- upvalues: elapsed (ref)
        if os.clock() - elapsed > 0.004 then
            task.wait()
            elapsed = os.clock()
        end
    end

    local t13 = {}

    for v88, v89 in Info.Palette do
        local function srgb(p27) -- line: 419
            if p27 <= 0.0031308 then
                return 12.92 * p27
            end

            return 1.055 * p27 ^ 0.4166666666666667 - 0.055
        end

        local v90 = v88 - 1
        local new = Color3.new
        local v91 = v89[1]
        local v92 = if v91 <= 0.0031308 then 12.92 * v91 else 1.055 * v91 ^ 0.4166666666666667 - 0.055
        local v93 = v89[2]
        local v94 = if v93 <= 0.0031308 then 12.92 * v93 else 1.055 * v93 ^ 0.4166666666666667 - 0.055
        local v95 = v89[3]

        t13[v90] = v87:AddColor(new(v92, v94, if v95 <= 0.0031308 then 12.92 * v95 else 1.055 * v95 ^ 0.4166666666666667 - 0.055), 1)
    end

    local v97 = Vertices * 6
    local v98 = Vertices * 7
    local v99 = v98 + Triangles * 6
    local v100 = table.create(Vertices)
    local t14 = {}
    local t15 = {}
    local v101 = table.create(Vertices)
    local v102 = table.create(Vertices)
    local X, Y, Z = Info.Size.X, Info.Size.Y, Info.Size.Z

    for i = 0, Vertices - 1 do
        if i % 500 == 0 and os.clock() - elapsed > 0.004 then
            task.wait()
            elapsed = os.clock()
        end

        local v103 = (buffer.readu16(Bytes, i * 6 + 0) / 65535 - 0.5) * X
        local v104 = (buffer.readu16(Bytes, i * 6 + 0 + 2) / 65535 - 0.5) * Y
        local v105 = (buffer.readu16(Bytes, i * 6 + 0 + 4) / 65535 - 0.5) * Z
        local v106 = Vector3.new(v103, v104, v105)
        local v107 = v87:AddVertex(v106)

        v100[i + 1] = v107
        t14[v107] = v106

        local v108 = Vector3.new(v103, 0, v105)

        if v108.Magnitude > 1E-04 then
            t15[v107] = v108.Unit
        else
            t15[v107] = Vector3.new(0, 0, 0)
        end

        local v109 = v97 + i

        v101[i + 1] = t13[buffer.readu8(Bytes, v109)]

        local v110 = math.atan2(v105, v103) / 6.283185307179586 % 1

        v102[i + 1] = {
            v110,
            v104 / Y + 0.5,
            nil
        }
    end

    local function uvId(p28, p29) -- line: 445
        -- upvalues: v87 (copy), v102 (copy)
        local v111 = v102[p28]
        local v112 = if p29 then 3 else 4

        if not v111[v112] then
            v111[v112] = v87:AddUV(Vector2.new(v111[1] + (p29 and 1 or 0), v111[2]))
        end

        return v111[v112]
    end

    for i = 0, Triangles - 1 do
        if i % 400 == 0 and os.clock() - elapsed > 0.004 then
            task.wait()
            elapsed = os.clock()
        end

        local v116 = buffer.readu16(Bytes, v98 + i * 6) + 1
        local v118 = buffer.readu16(Bytes, v98 + i * 6 + 2) + 1
        local v120 = buffer.readu16(Bytes, v98 + i * 6 + 4) + 1
        local v121 = v87:AddTriangle(v100[v116], v100[v118], v100[v120])

        v87:SetFaceColors(v121, {
            v101[v116],
            v101[v118],
            v101[v120]
        })

        local v122 = v102[v116][1]
        local v123 = v102[v118][1]
        local v124 = v102[v120][1]
        local v125 = math.max(v122, v123, v124) - math.min(v122, v123, v124) > 0.5
        local v126 = v125 and v122 < 0.5
        local v127 = v102[v116]
        local v128 = if v126 then 3 else 4

        if not v127[v128] then
            v127[v128] = v87:AddUV(Vector2.new(v127[1] + (v126 and 1 or 0), v127[2]))
        end

        local v131 = v127[v128]
        local v132 = v125 and v123 < 0.5
        local v133 = v102[v118]
        local v134 = if v132 then 3 else 4

        if not v133[v134] then
            v133[v134] = v87:AddUV(Vector2.new(v133[1] + (v132 and 1 or 0), v133[2]))
        end

        local v137 = v133[v134]
        local v138 = v125 and v124 < 0.5
        local v139 = v102[v120]
        local v140 = if v138 then 3 else 4

        if not v139[v140] then
            v139[v140] = v87:AddUV(Vector2.new(v139[1] + (v138 and 1 or 0), v139[2]))
        end

        v87:SetFaceUVs(v121, {
            v131,
            v137,
            v139[v140]
        })

        if buffer.readu8(Bytes, v99 + i) == 0 then
            local v145 = t14[v100[v116]]
            local v146 = t14[v100[v118]]
            local v147 = t14[v100[v120]]
            local v148 = (v146 - v145):Cross(v147 - v145)

            if v148.Magnitude > 1E-09 then
                local v149 = v87:AddNormal(v148.Unit)

                v87:SetFaceNormals(v121, {
                    v149,
                    v149,
                    v149
                })
            end
        end
    end

    if os.clock() - elapsed > 0.004 then
        task.wait()
        elapsed = os.clock()
    end

    local v150 = Vector3.new(1, 1, 1) * 1e999
    local v151 = Vector3.new(-1, -1, -1, -0) * 1e999

    for _, v152 in t14 do
        v150 = v150:Min(v152)
        v151 = v151:Max(v152)
    end

    local function v153() -- line: 481
        -- upvalues: v87 (copy), AssetService (copy)
        return AssetService:CreateMeshPartAsync(Content.fromObject(v87), {
            CollisionFidelity = Enum.CollisionFidelity.Hull
        })
    end

    local ok, result = pcall(v153)

    if not ok then
        v87:Destroy()
        error(result)
    end

    local clone = p25:Clone()

    clone:ClearAllChildren()
    p25:ApplyMesh(result)
    result:Destroy()

    local t17 = {}

    for _, v154 in v100 do
        table.insert(t17, v154)
    end

    return {
        Original = clone,
        Mesh = v87,
        Rest = t14,
        Out = t15,
        Ids = t17,
        Main = p25,
        Centre = (v150 + v151) / 2,
        Scale = (v151 - v150) / Size,
        Radius = math.min(Size.X, Size.Z) / 2,
        Moved = {}
    }
end

local function buildBag(p30) -- line: 510
    -- upvalues: Settings (copy), AssetService (copy), loadBag (copy), getBlenderData (copy), buildBlenderBag (copy)
    if Settings.BagMeshId == "" and Settings.BagModel == "Blender" then
        local v155 = getBlenderData()

        if v155 then
            local ok, result = pcall(buildBlenderBag, p30, v155)

            if ok then
                return result
            end

            warn("[BagSwing] couldn't build the Blender bag, building the code one:", result)
        end
    end

    if Settings.BagMeshId ~= "" then
        local ok, result = pcall(loadBag, p30)

        if ok then
            return result
        end

        warn("[BagSwing] couldn't load the Blender bag, building one in code:", result)
    end

    local Size = p30.Size
    local v156 = math.min(Size.X, Size.Z) / 2
    local v157 = Size.Y / 2
    local v158 = v156 / 1.108
    local v159 = v158 * 0.035
    local v160 = v157 - v159
    local v161 = v158 * 0.25
    local v162 = v158 * 0.16
    local BagSegments = Settings.BagSegments
    local v163 = AssetService:CreateEditableMesh({})
    local t19 = {}
    local v164 = v163:AddColor(Color3.new(Settings.BagShade, Settings.BagShade, Settings.BagShade), 1)
    local v165 = v163:AddColor(Color3.new(Settings.BagSeamShade, Settings.BagSeamShade, Settings.BagSeamShade), 1)
    local v166 = v163:AddColor(Color3.new(Settings.BagStitchShade, Settings.BagStitchShade, Settings.BagStitchShade), 1)

    local function tri(p31, p32, p33, p34, p35, p36, p37) -- line: 542
        -- upvalues: v163 (copy), t19 (copy), v164 (copy)
        local v167, v168, v169

        if (p35 - p34):Cross(p36 - p34):Dot(p37) < 0 then
            v167 = p33
            v168 = p32
            v169 = true
        else
            v167 = p32
            v168 = p33
            v169 = false
        end

        local v170 = v163:AddTriangle(p31, v167, v168)

        v163:SetFaceColors(v170, {
            t19[p31] or v164,
            t19[v167] or v164,
            t19[v168] or v164
        })

        return v170, v169
    end

    local t21 = {
        { 0, -v157, 0 }
    }

    for i = 0, 6 do
        local v174 = math.rad(i * 15 + -90)

        table.insert(t21, {
            v156 - v161 + v161 * math.cos(v174),
            -v157 + v161 + v161 * math.sin(v174),
            i / 6
        })
    end

    local v175 = -v157 + v161
    local v176 = v160 - v162
    local v179 = math.max(2, (math.ceil((v176 - v175) / Settings.BagRowSpacing)))

    for i = 1, v179 - 1 do
        table.insert(t21, {
            v156,
            v175 + (v176 - v175) * i / v179,
            1
        })
    end

    for i = 0, 6 do
        local v180 = math.rad(i * 15)

        table.insert(t21, {
            v156 - v162 + v162 * math.cos(v180),
            v160 - v162 + v162 * math.sin(v180),
            1 - i / 6,
            i == 3
        })
    end

    table.insert(t21, {
        0,
        v160,
        0
    })

    local t26 = {}
    local t27 = {}
    local t28 = {}
    local t29 = {}
    local t30 = {}
    local elapsed = os.clock()

    local function breathe() -- line: 574
        -- upvalues: elapsed (ref)
        if os.clock() - elapsed > 0.004 then
            task.wait()
            elapsed = os.clock()
        end
    end

    for v185, v186 in t21 do
        if os.clock() - elapsed > 0.004 then
            task.wait()
            elapsed = os.clock()
        end

        local t31 = {}
        local t32 = {}
        local v187 = (v186[2] + v157) / (2 * v157)

        if v186[1] <= 0 then
            local v189 = Vector3.new(0, v186[2], 0)

            t31.Center = v163:AddVertex(v189)
            t31.CenterPos = v189
            t32.Center = v163:AddUV(Vector2.new(0.5, v187))
        else
            for j = 0, BagSegments - 1 do
                local v190 = 6.283185307179586 * j / BagSegments
                local v191 = v186[1]

                if j % (BagSegments / 4) == 0 then
                    v191 -= Settings.BagSeamDepth * v158 * v186[3]
                end

                local v195 = Vector3.new(v191 * math.cos(v190), v186[2], v191 * math.sin(v190))
                local v196 = v163:AddVertex(v195)

                if j % (BagSegments / 4) ~= 0 or not (v186[3] > 0.3) then
                    if v186[4] and j % 4 < 2 then
                        t19[v196] = v166
                    end
                else
                    t19[v196] = v165
                end

                t31[j] = v196
                t26[v196] = v195
                t27[v196] = Vector3.new(math.cos(v190), 0, (math.sin(v190)))
                table.insert(t28, v196)
            end

            for k = 0, BagSegments do
                t32[k] = v163:AddUV(Vector2.new(k / BagSegments, v187))
            end
        end

        t29[v185] = t31
        t30[v185] = t32
    end

    local function pos(p38, p39) -- line: 614
        -- upvalues: t26 (copy)
        return t26[p38[p39]]
    end

    for i = 1, #t21 - 1 do
        if os.clock() - elapsed > 0.004 then
            task.wait()
            elapsed = os.clock()
        end

        local v199 = t29[i]
        local v200 = t29[i + 1]
        local v201 = t30[i]
        local v202 = t30[i + 1]

        for j = 0, BagSegments - 1 do
            local v203 = (j + 1) % BagSegments

            if v199.Center then
                local v204, v205 = tri(v199.Center, v200[j], v200[v203], v199.CenterPos, t26[v200[j]], t26[v200[v203]], (Vector3.new(0, -1, 0)))

                v163:SetFaceUVs(v204, if v205 then {
                    v201.Center,
                    v202[j + 1],
                    v202[j]
                } else {
                    v201.Center,
                    v202[j],
                    v202[j + 1]
                })
            elseif v200.Center then
                local v206, v207 = tri(v200.Center, v199[j], v199[v203], v200.CenterPos, t26[v199[j]], t26[v199[v203]], (Vector3.new(0, 1, 0)))

                v163:SetFaceUVs(v206, if v207 then {
                    v202.Center,
                    v201[j + 1],
                    v201[j]
                } else {
                    v202.Center,
                    v201[j],
                    v201[j + 1]
                })
            else
                local v208 = (t26[v199[j]] + t26[v200[v203]]) / 2
                local v209 = Vector3.new(v208.X, 0, v208.Z)
                local v210, v211 = tri(v199[j], v199[v203], v200[v203], t26[v199[j]], t26[v199[v203]], t26[v200[v203]], v209)

                v163:SetFaceUVs(v210, if v211 then {
                    v201[j],
                    v202[j + 1],
                    v201[j + 1]
                } else {
                    v201[j],
                    v201[j + 1],
                    v202[j + 1]
                })

                local v212, v213 = tri(v199[j], v200[v203], v200[j], t26[v199[j]], t26[v200[v203]], t26[v200[j]], v209)

                v163:SetFaceUVs(v212, if v213 then {
                    v201[j],
                    v202[j],
                    v202[j + 1]
                } else {
                    v201[j],
                    v202[j + 1],
                    v202[j]
                })
            end
        end
    end

    local v214 = v163:AddColor(Settings.BagTabColor, 1)
    local v215 = v163:AddUV(Vector2.new(0.5, 0.5))

    local function box(p40, p41, p42, p43, p44) -- line: 642
        -- upvalues: v163 (copy), tri (copy), v214 (copy), v215 (copy)
        for _, v216 in {
                {
                    p43,
                    p41,
                    p42,
                    p44.Z,
                    p44.X,
                    p44.Y
                },
                {
                    p41,
                    p42,
                    p43,
                    p44.X,
                    p44.Y,
                    p44.Z
                },
                {
                    p42,
                    p43,
                    p41,
                    p44.Y,
                    p44.Z,
                    p44.X
                }
            } do
            local v217 = v216[1]
            local v218 = v216[2]
            local v219 = v216[3]
            local v220 = v216[4]
            local v221 = v216[5]
            local v222 = v216[6]

            for _, v223 in { 1, -1 } do
                local v224 = p40 + v217 * v220 * v223
                local v225 = v224 - v218 * v221 - v219 * v222
                local v226 = v224 + v218 * v221 - v219 * v222
                local v227 = v224 + v218 * v221 + v219 * v222
                local v228 = v224 - v218 * v221 + v219 * v222
                local v229 = v163:AddVertex(v225)
                local v230 = v163:AddVertex(v226)
                local v231 = v163:AddVertex(v227)
                local v232 = v163:AddVertex(v228)

                for _, v233 in {
                        tri(v229, v230, v231, v225, v226, v227, v217 * v223),
                        (tri(v229, v231, v232, v225, v227, v228, v217 * v223))
                    } do
                    v163:SetFaceColors(v233, {
                        v214,
                        v214,
                        v214
                    })
                    v163:SetFaceUVs(v233, {
                        v215,
                        v215,
                        v215
                    })
                end
            end
        end
    end

    local v234 = v158 * 0.15
    local v235 = v158 * 0.24
    local v236 = v158 * 0.17

    for i = 0, 3 do
        local v237 = math.rad(i * 90 + 45)
        local v240 = Vector3.new(math.cos(v237), 0, (math.sin(v237)))
        local v241 = (Vector3.new(0, 1, 0)):Cross(v240)

        box(v240 * (v156 + v159 / 2 - 0.005) + Vector3.new(0, v160 - v235, 0), v241, Vector3.new(0, 1, 0), v240, (Vector3.new(v234, v235, v159 / 2 + 0.005)))
        box(v240 * (v156 - v236 + v159) + Vector3.new(0, v160 + v159 / 2 - 0.005, 0), v241, v240, Vector3.new(0, 1, 0), (Vector3.new(v234, v236, v159 / 2 + 0.005)))
    end

    if os.clock() - elapsed > 0.004 then
        task.wait()
        elapsed = os.clock()
    end

    local v250 = Vector3.new(1, 1, 1) * 1e999
    local v251 = Vector3.new(-1, -1, -1, -0) * 1e999

    for _, v252 in v163:GetVertices() do
        local Position = v163:GetPosition(v252)

        v250 = v250:Min(Position)
        v251 = v251:Max(Position)
    end

    local function v253() -- line: 678
        -- upvalues: v163 (copy), AssetService (copy)
        return AssetService:CreateMeshPartAsync(Content.fromObject(v163), {
            CollisionFidelity = Enum.CollisionFidelity.Hull
        })
    end

    local ok, result = pcall(v253)

    if not ok then
        v163:Destroy()
        error(result)
    end

    local clone = p30:Clone()

    clone:ClearAllChildren()
    p30:ApplyMesh(result)
    result:Destroy()

    return {
        Original = clone,
        Mesh = v163,
        Rest = t26,
        Out = t27,
        Ids = t28,
        Main = p30,
        Centre = (v250 + v251) / 2,
        Scale = (v251 - v250) / Size,
        Radius = v156,
        Moved = {}
    }
end

local function builtCount() -- line: 704
    -- upvalues: t5 (copy), t6 (copy)
    local n2 = 0

    for _ in t5 do
        n2 += 1
    end

    for _ in t6 do
        n2 += 1
    end

    return n2
end

local function releaseBag(p45) -- line: 716
    -- upvalues: t5 (copy)
    local v254 = t5[p45]

    if not v254 then
        return
    end

    t5[p45] = nil

    if p45.Parent then
        local ApplyMesh = p45.ApplyMesh
        local Original = v254.Original

        pcall(ApplyMesh, p45, Original)
    end

    v254.Original:Destroy()
    v254.Mesh:Destroy()
end

local result

local function cheapDents() -- line: 735
    -- upvalues: result (ref)
    if not result then
        local BoxingSettings = script.Parent:FindFirstChild("BoxingSettings")

        local function v255() -- line: 739
            -- upvalues: BoxingSettings (copy)
            return BoxingSettings and require(BoxingSettings)
        end

        local ok, result2 = pcall(v255)

        if ok and type(result2) == "table" then
            result = result2
        end
    end

    if result and result.Get then
        local Get = result.Get
        local LowGraphics, LowGraphics2 = pcall(Get, "LowGraphics")

        if LowGraphics and LowGraphics2 == true then
            return true
        end
    end

    local UserInputService = game:GetService("UserInputService")

    if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled then
        return true
    end

    local function v256() -- line: 756
        return UserSettings():GetService("UserGameSettings").SavedQualityLevel.Value
    end

    local ok, result2 = pcall(v256)

    if ok then
        ok = result2 >= 1 and result2 <= 4
    end

    return ok
end

local v257 = false
local n3 = (-1e999)
local v258 = true

local function physicsOn() -- line: 768
    -- upvalues: RunService (copy), result (ref), cheapDents (copy), n3 (ref), v258 (ref)
    if not RunService:IsClient() then
        return true
    end

    local elapsed = os.clock()

    if not (elapsed - n3 < 0.5) then
        n3 = elapsed

        if not result then
            cheapDents()
        end

        local BagPhysics, BagPhysics2

        if result and result.Get then
            local Get = result.Get

            BagPhysics, BagPhysics2 = pcall(Get, "BagPhysics")
        else
            BagPhysics = false
        end

        v258 = not (BagPhysics and BagPhysics2 == false)
    end

    return v258
end

t1.PhysicsOn = physicsOn

local function ensureBag(p46) -- line: 789
    -- upvalues: Settings (copy), t5 (copy), t6 (copy), t7 (copy), buildBag (copy), v257 (ref)
    if not v257 and not t5[p46] and not next(t6) and Settings.BagMesh then
        local n4 = 0

        for _ in t5 do
            n4 += 1
        end

        for _ in t6 do
            n4 += 1
        end

        if not (Settings.BagMaxBuilt <= n4) and not (t7[p46] and os.clock() - t7[p46] < 10) then
            t6[p46] = true
            task.spawn(function() -- line: 797
                -- upvalues: p46 (copy), t5 (copy), t6 (copy), t7 (copy), buildBag (copy)
                local ok, result = pcall(buildBag, p46)

                t6[p46] = nil

                if ok and result and p46.Parent then
                    t5[p46] = result
                    t7[p46] = nil
                    p46.Destroying:Once(function() -- line: 803
                        -- upvalues: result (copy), p46 (copy), t5 (copy)
                        if t5[p46] == result then
                            t5[p46] = nil
                        end

                        result.Original:Destroy()
                        result.Mesh:Destroy()
                    end)
                elseif not ok or not result then
                    t7[p46] = os.clock()
                else
                    result.Original:Destroy()
                    result.Mesh:Destroy()
                end
            end)
        end
    end
end

local t37 = {}
local t38 = {}
local t39 = {}
local t40 = {}

local function meshDent(p47, p48, p49, p50) -- line: 828
    -- upvalues: Settings (copy), t38 (copy)
    local v259 = p48.CFrame:PointToObjectSpace(p49)
    local v260 = p47.Centre + v259 * p47.Scale
    local v263 = Vector3.new(v260.X - p47.Centre.X, 0, v260.Z - p47.Centre.Z)

    if v263.Magnitude < 0.001 then
        return
    end

    local v264 = p47.Radius * p47.Scale.X
    local v265 = Vector3.new(p47.Centre.X, v260.Y, p47.Centre.Z) + v263.Unit * v264
    local X2 = p47.Scale.X
    local v266 = (Settings.DentRadius[1] + Settings.DentRadius[2] * p50) * X2
    local v267 = v266 * 1.6
    local t41 = {}
    local v268 = false

    for _, v269 in p47.Ids do
        local Magnitude = (p47.Rest[v269] - v265).Magnitude

        if Magnitude < v266 then
            local v270 = Magnitude / v266
            local v271 = (1 - v270 * v270) ^ 2

            v268 = true
            t41[v269] = -p47.Out[v269] * (v271 * X2)
        elseif Magnitude < v267 then
            t41[v269] = p47.Out[v269] * (Settings.DentBulge * X2 * math.sin(3.141592653589793 * (Magnitude - v266) / (v267 - v266)))
        end
    end

    if v268 then
        table.insert(t38, {
            Record = p47,
            Verts = t41,
            Depth = p50,
            Start = os.clock()
        })
    end
end

function t1.Dent(p51, p52, p53) -- line: 861
    -- upvalues: Settings (copy), t5 (copy), physicsOn (copy), ensureBag (copy), t37 (copy), meshDent (copy)
    if not physicsOn() then
        return
    end

    local PhysicsPart = p51 and (p51:FindFirstChild("PhysicsPart") or p51.PrimaryPart or p51:FindFirstChildWhichIsA("BasePart", true))

    if PhysicsPart and p52 then
        local v275 = t5[PhysicsPart]

        if v275 == nil then
            ensureBag(PhysicsPart)
        end

        if v275 then
            meshDent(v275, PhysicsPart, p52, p53)
        else
            local v276 = PhysicsPart.CFrame:PointToObjectSpace(p52)
            local v277 = Vector3.new(v276.X, 0, v276.Z)

            if not (v277.Magnitude < 0.001) then
                local Unit = v277.Unit
                local t43 = {}
                local v278 = false

                for _, child in PhysicsPart:GetChildren() do
                    if child:IsA("Bone") and string.find(child.Name, "_Offshoot", 1, true) then
                        local UpVector = child.CFrame.UpVector
                        local v279 = Vector3.new(UpVector.X, 0, UpVector.Z)

                        if v279.Magnitude > 0.5 then
                            local v281 = math.max(Unit:Dot(v279.Unit), 0)
                            local v284 = math.max(1 - math.abs(v276.Y - child.Position.Y) / Settings.DentHeight, 0)
                            local v285 = v281 ^ Settings.DentFacingPower * v284 * v284

                            if v285 > 0.02 then
                                v278 = true
                                t43[child] = v285
                            end
                        end
                    end
                end

                if v278 then
                    local n5 = 0

                    for _, v286 in t43 do
                        n5 = math.max(n5, v286)
                    end

                    for v287, v288 in t43 do
                        t43[v287] = v288 / n5
                    end

                    table.insert(t37, {
                        Bones = t43,
                        Depth = p53,
                        Start = os.clock()
                    })
                end
            end
        end
    end
end

local function dentAmount(p54) -- line: 916
    -- upvalues: Settings (copy)
    if p54 < Settings.DentIn then
        local v289 = p54 / Settings.DentIn

        return v289 * v289 * (3 - 2 * v289)
    end

    local v291 = math.clamp((p54 - Settings.DentIn) / Settings.DentOut, 0, 1)

    return 1 - v291 * v291 * (3 - v291 * 2)
end

local function stepMeshDents() -- line: 926
    -- upvalues: Settings (copy), t5 (copy), t38 (copy), t40 (copy)
    if #t38 == 0 and next(t40) == nil then
        return
    end

    local elapsed = os.clock()
    local t45 = {}

    for i = #t38, 1, -1 do
        local v292 = t38[i]
        local v293 = elapsed - v292.Start
        local v294, v295

        if Settings.DentIn + Settings.DentOut <= v293 then
            v295 = true
        elseif t5[v292.Record.Main] == v292.Record then
            if v293 < Settings.DentIn then
                local v296 = v293 / Settings.DentIn

                v294 = v296 * v296 * (3 - 2 * v296)
            else
                local v298 = math.clamp((v293 - Settings.DentIn) / Settings.DentOut, 0, 1)

                v294 = 1 - v298 * v298 * (3 - v298 * 2)
            end

            v295 = false
        else
            v295 = true
        end

        if v295 then
            table.remove(t38, i)
        else
            local v299 = v294 * v292.Depth
            local v300 = t45[v292.Record]

            if not v300 then
                v300 = {}
                t45[v292.Record] = v300
            end

            for v301, v302 in v292.Verts do
                v300[v301] = (v300[v301] or Vector3.new(0, 0, 0)) + v302 * v299
            end
        end
    end

    local v303 = Settings.DentDepth + Settings.DentPowerDepth

    for v304 in t40 do
        local v305 = t45[v304] or {}
        local Mesh = v304.Mesh

        for v306 in v304.Moved do
            if not v305[v306] then
                local SetPosition = Mesh.SetPosition
                local v307 = v304.Rest[v306]

                pcall(SetPosition, Mesh, v306, v307)
                v304.Moved[v306] = nil
            end
        end

        if next(v304.Moved) == nil and not t45[v304] then
            t40[v304] = nil
        end
    end

    for v308, v309 in t45 do
        local Mesh = v308.Mesh
        local v310 = v303 * v308.Scale.X

        for v311, v312 in v309 do
            local v313 = if v310 < v312.Magnitude then v312.Unit * v310 else v312

            Mesh:SetPosition(v311, v308.Rest[v311] + v313)
            v308.Moved[v311] = true
        end

        t40[v308] = true
    end
end

local function stepDents() -- line: 977
    -- upvalues: Settings (copy), t37 (copy), t39 (copy), stepMeshDents (copy)
    stepMeshDents()

    if #t37 == 0 and next(t39) == nil then
        return
    end

    local elapsed = os.clock()
    local t46 = {}

    for i = #t37, 1, -1 do
        local v314 = t37[i]
        local v315 = elapsed - v314.Start

        if Settings.DentIn + Settings.DentOut <= v315 then
            table.remove(t37, i)
        else
            local v316

            if v315 < Settings.DentIn then
                local v317 = v315 / Settings.DentIn

                v316 = v317 * v317 * (3 - 2 * v317)
            else
                local v319 = math.clamp((v315 - Settings.DentIn) / Settings.DentOut, 0, 1)

                v316 = 1 - v319 * v319 * (3 - v319 * 2)
            end

            local v320 = v316 * v314.Depth

            for v321, v322 in v314.Bones do
                t46[v321] = (t46[v321] or 0) + v320 * v322
            end
        end
    end

    for v323 in t39 do
        if not t46[v323] then
            if v323.Parent then
                v323.Transform = CFrame.identity
            end

            t39[v323] = nil
        end
    end

    for v324, v325 in t46 do
        if v324.Parent then
            v324.Transform = CFrame.new(0, -math.min(v325, Settings.DentDepth + Settings.DentPowerDepth), 0)
            t39[v324] = true
        end
    end
end

function t1.Thud(p55, p56, p57, p58, p59) -- line: 1013
    -- upvalues: Settings (copy)
    local PhysicsPart = p55 and (p55:FindFirstChild("PhysicsPart") or p55.PrimaryPart or p55:FindFirstChildWhichIsA("BasePart", true))
    local v328 = math.clamp(tonumber(p58) or 0, 0, 1)
    local v329, v330

    if not PhysicsPart
        or not p56
        or not p57
        or not Settings.ThudSound
        or p57.Weight == "Light"
        or v328 < Settings.ThudFromPower then
        return
    else
        v329 = (v328 - Settings.ThudFromPower) / math.max(1 - Settings.ThudFromPower, 0.001)
        v330 = if p57.Weight == "Heavy" then 1 else 0.8
    end

    local v335 = math.clamp(tonumber(p59) or 1, 0, 1) * 0.25 + 0.75
    local Attachment = Instance.new("Attachment")

    Attachment.Name = "BagThud"
    Attachment.Position = PhysicsPart.CFrame:PointToObjectSpace(p56)
    Attachment.Parent = PhysicsPart

    local Sound = Instance.new("Sound")

    Sound.SoundId = Settings.ThudSound
    Sound.Volume = (Settings.ThudVolume[1] + (Settings.ThudVolume[2] - Settings.ThudVolume[1]) * v329) * v330 * v335
    Sound.PlaybackSpeed = (Settings.ThudPitch[1] + (Settings.ThudPitch[2] - Settings.ThudPitch[1]) * v329) * (0.97 + math.random() * 0.06)
    Sound.RollOffMinDistance = 10
    Sound.RollOffMaxDistance = 80
    Sound.Parent = Attachment
    Sound:Play()

    local Volume = Sound.Volume

    task.delay(Settings.ThudLength * 0.6, function() -- line: 1035
        -- upvalues: Attachment (copy), Sound (copy), Volume (copy), Settings (copy)
        local v336 = Settings.ThudLength * 0.4
        local elapsed = os.clock()

        while Sound.Parent and os.clock() - elapsed < v336 do
            Sound.Volume = Volume * (1 - (os.clock() - elapsed) / v336)
            task.wait()
        end

        Attachment:Destroy()
    end)
end

function t1.DentDepthFor(p60, p61) -- line: 1047
    -- upvalues: Settings (copy)
    local v337 = Settings.WeightFactor[p60 and p60.Weight or "Light"] or 0.5

    return (Settings.DentDepth + Settings.DentPowerDepth * math.clamp(p61 or 0, 0, 1)) * (0.7 + 0.3 * v337)
end

if not RunService:IsClient() then
    RunService.Heartbeat:Connect(step)

    return t1
end

task.spawn(function() -- line: 1056
    -- upvalues: Settings (copy)
    local t47 = {}

    for _, v339 in {
            Settings.ThudSound,
            Settings.CreakSound
        } do
        if v339 then
            local Sound = Instance.new("Sound")

            Sound.Name = "BagSoundPreload"
            Sound.SoundId = v339
            Sound.Volume = 0
            Sound.Parent = game:GetService("SoundService")
            table.insert(t47, Sound)
        end
    end

    local function v340() -- line: 1068
        -- upvalues: t47 (copy)
        game:GetService("ContentProvider"):PreloadAsync(t47)
    end

    pcall(v340)
end)
RunService.RenderStepped:Connect(function(p62) -- line: 1072
    -- upvalues: step (copy), stepDents (copy)
    step(p62)
    stepDents()
end)

if Settings.BagMesh then
    local t48 = {}

    local function consider(p63) -- line: 1080
        -- upvalues: t48 (copy)
        if p63:IsA("Model") and p63:GetAttribute("PunchingBag") then
            t48[p63] = true
        end
    end

    local function holdStill() -- line: 1087
        -- upvalues: t2 (copy), stateFor (copy), physicsOn (copy), t48 (copy)
        if physicsOn() then
            return
        end

        for v341 in t48 do
            if v341.Parent then
                local v342 = t2[v341] or stateFor(v341)

                if v342 then
                    v342.Theta = Vector3.new(0, 0, 0)
                    v342.Omega = Vector3.new(0, 0, 0)
                    v342.Moving = false

                    for v343, v344 in v342.Parts do
                        if v343.Parent and v343.CFrame ~= v344 then
                            v343.CFrame = v344
                        end
                    end
                end
            end
        end
    end

    RunService:BindToRenderStep("BagHoldStill", Enum.RenderPriority.Last.Value + 20, holdStill)
    RunService.Heartbeat:Connect(holdStill)
    task.spawn(function() -- line: 1108
        -- upvalues: Settings (copy), t5 (copy), cheapDents (copy), v257 (ref), physicsOn (copy), ensureBag (copy), t48 (copy), consider (copy)
        for _, descendant in workspace:GetDescendants() do
            if descendant:IsA("Model") and descendant:GetAttribute("PunchingBag") then
                t48[descendant] = true
            end
        end

        workspace.DescendantAdded:Connect(consider)

        local n6 = (-1e999)

        while true do
            local CurrentCamera = workspace.CurrentCamera
            local v345 = CurrentCamera and CurrentCamera.CFrame.Position
            local v346

            if os.clock() - n6 >= 2 then
                local elapsed = os.clock()

                v257 = cheapDents() or not physicsOn()
                v346 = elapsed

                if v257 then
                    for v347 in t5 do
                        v346 = elapsed

                        local v348 = t5[v347]

                        if v348 then
                            t5[v347] = nil

                            if v347.Parent then
                                local ApplyMesh = v347.ApplyMesh
                                local Original = v348.Original

                                pcall(ApplyMesh, v347, Original)
                            end

                            v348.Original:Destroy()
                            v348.Mesh:Destroy()
                        end
                    end
                end
            else
                v346 = n6
            end

            n6 = v346

            if v345 and not v257 then
                for v349 in t5 do
                    if not v349.Parent or (v349.Position - v345).Magnitude > Settings.BagReleaseRange then
                        local v351 = t5[v349]

                        if v351 then
                            t5[v349] = nil

                            if v349.Parent then
                                local ApplyMesh = v349.ApplyMesh
                                local Original = v351.Original

                                pcall(ApplyMesh, v349, Original)
                            end

                            v351.Original:Destroy()
                            v351.Mesh:Destroy()
                        end
                    end
                end

                local t49 = {}

                for v352 in t48 do
                    if v352.Parent then
                        local PhysicsPart = v352:FindFirstChild("PhysicsPart")

                        if PhysicsPart and PhysicsPart:IsA("MeshPart") and not t5[PhysicsPart] then
                            local Magnitude = (PhysicsPart.Position - v345).Magnitude

                            if Magnitude < Settings.BagBuildRange then
                                table.insert(t49, {
                                    PhysicsPart,
                                    Magnitude
                                })
                            end
                        end
                    else
                        t48[v352] = nil
                    end
                end

                table.sort(t49, function(p64, p65) -- line: 1149
                    return p64[2] < p65[2]
                end)

                for _, v353 in t49 do
                    ensureBag(v353[1])
                end
            end

            task.wait(0.5)
        end
    end)
end

return t1
