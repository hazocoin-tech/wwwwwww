-- https://lua.expert

local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local t1 = {
    ShowDamageNumbers = false,
    ShowHitboxes = false,
    CooldownTolerance = 0.08,
    InputBuffer = 0.25,
    SkillInputBuffer = 0.25,
    PunchCancel = {
        Enabled = true,
        Stamina = 4,
        Tolerance = 0.15
    },
    PunchPull = {
        Enabled = true,
        Max = 0.8,
        Min = 0.05,
        Slack = 0.3,
        Lead = 0.8,
        FrontDepth = 0.5,
        Sink = 0.35
    },
    CombatTimer = false,
    Stances = {
        {
            Name = "Orthodox",
            Skills = { "Skill Name", "Skill Name" }
        },
        {
            Name = "Stance 2",
            Skills = { "Skill Name", "Skill Name" }
        }
    },
    SkillKeys = {
        Enum.KeyCode.E,
        Enum.KeyCode.R
    },
    StanceSwitchKey = Enum.KeyCode.T,
    Weave = {
        Animation = "rbxassetid://140392450140966",
        BlendTime = 0.18,
        MinHold = 0.1,
        SpamWindow = 1.5,
        SpamAllowed = 2,
        SpamStartup = 0.06,
        SpamStartupMax = 0.3,
        EntryStamina = 3,
        MaxDodgeHold = 1.5,
        DodgesBodyShots = false,
        DodgeStaminaCost = 0,
        Key = Enum.KeyCode.Space,
        Poses = {
            Forward = 0.1,
            Left = 0.2,
            Back = 0.3,
            Right = 0.4
        },
        Keys = {
            [Enum.KeyCode.W] = "Forward",
            [Enum.KeyCode.A] = "Left",
            [Enum.KeyCode.S] = "Back",
            [Enum.KeyCode.D] = "Right"
        }
    },
    PunchRootsYou = true,
    PunchMoveLockExtra = 0.05,
    BlockKey = Enum.KeyCode.F,
    HeadBlockKey = Enum.KeyCode.G,
    FeintKey = Enum.KeyCode.V,
    BlockDamageMultiplier = 0.2,
    BlockKnockbackMultiplier = 0.25,
    BlockFrontDot = 0.2,
    BlockRecovery = 0.2,
    LagCompensation = {
        Enabled = true,
        HistoryTime = 1,
        InterpDelay = 0.08,
        MaxRewind = 0.25,
        MaxShift = 4
    },
    Aim = {
        Range = 12,
        MaxMiss = 3,
        HeadMargin = 0.15,
        FallbackHeadLookY = -0.12
    },
    HeadHitEffect = {
        BaseDuration = 0.2,
        PerStack = 0.15,
        MaxDuration = 1.2,
        StackReset = 5,
        BlurSize = 14,
        DazeAfter = 3,
        DazeDuration = 2,
        DazePerStack = 0.75,
        DazeMaxDuration = 4.5,
        DazeDegrees = 2.2,
        Tint = Color3.fromRGB(255, 110, 110)
    },
    LowHealthEffect = {
        Threshold = 0.3,
        MaxBlur = 4,
        MaxDesaturate = 0.3,
        Pulse = 0.12,
        Tint = Color3.fromRGB(255, 95, 95)
    },
    LowHealthMuffle = {
        Threshold = 0.25,
        StartStrength = 0.4,
        HighGain = -32,
        MidGain = -12,
        Smoothing = 4
    },
    UISounds = {
        StatsOpen = "rbxassetid://140910211",
        TabClick = "rbxassetid://136111991961082",
        Volume = 0.6,
        Transition = "rbxassetid://132010613759452",
        TransitionVolume = 0.7,
        TransitionClose = "rbxassetid://83380104662884",
        TransitionCloseVolume = 0.65,
        TransitionOpen = "rbxassetid://85485781329441",
        TransitionOpenVolume = 0.5,
        SkillUnlock = "rbxassetid://3422389728",
        SkillUnlockVolume = 0.8
    },
    Blink = {
        CounterMinClean = 0.4,
        HeavyMinClean = 0.6,
        PunchWindowExtra = 0.05,
        Kinds = {
            Heavy = {
                Close = 0.8,
                In = 0.05,
                Hold = 0.03,
                Out = 0.2
            },
            Counter = {
                Close = 1,
                In = 0.04,
                Hold = 0.08,
                Out = 0.24,
                Flutter = 0.45
            },
            GuardBreak = {
                Close = 0.9,
                In = 0.05,
                Hold = 0.1,
                Out = 0.3,
                Flutter = 0.4
            },
            Knockdown = {
                Close = 1,
                In = 0.05,
                Hold = 0.25,
                Out = 0.5,
                Flutter = 0.6
            }
        },
        Priority = {
            Heavy = 1,
            Counter = 2,
            GuardBreak = 3,
            Knockdown = 4
        }
    },
    HitVignette = {
        Duration = 0.35,
        Width = 0.22,
        Color = Color3.fromRGB(200, 0, 0),
        Strength = {
            Blocked = 0.25,
            Light = 0.5,
            Medium = 0.6,
            Heavy = 0.72,
            Knockdown = 0.85
        }
    },
    KnockdownEffect = {
        Blur = 26,
        Hold = 5,
        Duration = 5,
        MidGain = -14,
        HighGain = -40
    },
    Camera = {
        ShoulderOffset = Vector3.new(1.75, 0, 0),
        BlendTime = 0.4,
        TurnRate = 12,
        SnapFacing = true,
        FirstPersonOffset = Vector3.new(0, 0.3, 1.15),
        FirstPersonFov = 12,
        LockSettleTime = 0.15,
        BodyFade = 0,
        BodyFadeOnHit = 0,
        BodyFadeHitTime = 0.3,
        BodyFadeRange = 9,
        BodyFadeRate = 14,
        ShakeReferenceZoom = 12,
        ShakeMinScale = 0.35,
        ShiftLockKeys = {
            Enum.KeyCode.LeftAlt,
            Enum.KeyCode.RightAlt
        },
        HeadFollow = {
            Position = 1,
            Turn = 0.22,
            Roll = 0.5,
            Smooth = 16,
            Recentre = 2,
            MaxOffset = 1.1,
            MaxDegrees = 10
        },
        HitKick = {
            Degrees = 7,
            Push = 0.18,
            Rise = 0.018,
            Decay = 0.09,
            Body = 0.45,
            Blocked = 0.3,
            Max = 14,
            Kinds = {
                Jab = 0.6,
                Cross = 0.85,
                Hook = 1,
                Uppercut = 1
            }
        },
        PunchPush = {
            Straight = 0.22,
            HookDegrees = 3,
            UppercutDegrees = 2.5,
            Return = 0.12
        }
    },
    BlockReactions = {
        BlockHitPunches = nil,
        BlockHitZone = nil,
        FadeIn = 0.05,
        BlockWeightDuring = 0.05,
        BreakFadeOut = 0.25,
        Animations = {
            BlockHit_LeftArm = "rbxassetid://91755484550150",
            BlockHit_RightArm = "rbxassetid://83184408195757",
            GuardBreak_RightArm = "rbxassetid://86425095610649",
            GuardBreak_LeftArm = "rbxassetid://83443607979067"
        }
    },
    Roadwork = {
        Stat = "Stamina",
        Sub = 2,
        CheckpointRadius = 7,
        CheckpointHeight = 10,
        MaxSpeed = 40,
        CheckpointGain = 0.004,
        FinishGain = 0.05,
        MinStaminaToStart = 10,
        RingSpinSpeed = 1.2,
        TrailLength = 110,
        Difficulties = {
            Easy = {
                Pace = 14,
                Bonus = 10,
                Mult = 1
            },
            Medium = {
                Pace = 16,
                Bonus = 8,
                Mult = 1.4
            },
            Hard = {
                Pace = 18,
                Bonus = 6,
                Mult = 1.9,
                Sub = 1
            }
        },
        MarkerColor = Color3.fromRGB(255, 232, 0),
        ChevronColors = {
            Color3.fromRGB(255, 222, 0),
            Color3.fromRGB(255, 176, 0)
        },
        TimerColor = Color3.fromRGB(235, 10, 10)
    },
    SpamStamina = {
        Free = 2,
        Window = 2.5,
        PerExtra = 1,
        Max = 4,
        Kinds = {
            Hook = true,
            Uppercut = true
        }
    },
    SubGainMultiplier = {
        Stamina_A = 1.5
    },
    StatEvent = {
        GainMultiplier = 2,
        DataStore = "BoxingStatEvent_v1",
        Topic = "BoxingStatEvent"
    },
    FootworkCounter = {
        PerPoint = 0.02
    },
    FootworkDash = {
        DurationPerPoint = 0.02
    },
    FeintDashCancel = {
        Window = 0.45
    },
    FootworkBodyHookSlow = {
        MaxChance = 1,
        MinChance = 0.4
    },
    DamageSoftCap = {
        Start = 1.5,
        Rate = 0.4,
        Max = 2.2
    },
    PunchingBag = {
        Stat = "Technique",
        Sub = 1,
        Gain = 0.008,
        ComboWindow = 1.1,
        ComboStep = 0.1,
        ComboMax = 1.5,
        IdealReach = 0.75,
        WeightMult = {
            Light = 0.7,
            Medium = 0.9,
            Heavy = 1.2
        },
        Push = {
            Light = 3,
            Medium = 4.5,
            Heavy = 6
        }
    },
    Mitts = {
        Window = 1.1,
        PerfectTime = 0.32,
        RaiseCooldown = 0.15,
        HitterGain = 0.02,
        HolderGain = 0.012,
        PartnerDistance = 3.8,
        MaxDistance = 10,
        HitterStat = { "Technique", 1 },
        HolderStat = { "Endurance", 1 },
        Animations = {
            Idle = "rbxassetid://120867428036441",
            Left = "rbxassetid://80980749185256",
            Right = "rbxassetid://109785857198996"
        }
    },
    Leaves = {
        Duration = 30,
        SpawnInterval = 0.55,
        CatchRadius = 2.6,
        Reach = 2.6,
        GroundOffset = 0.3,
        Gain = 0.006,
        CatchCooldown = 0.25,
        NeedsGloves = true,
        ArmTimeout = 30,
        ArmRange = 18,
        HitSound = "rbxassetid://9113225979",
        HitVolume = 0.8,
        LeafSound = "rbxassetid://5108956689",
        LeafVolume = 1,
        Stat = { "Technique", 2 },
        FallSpeed = { 2.6, 4.2 },
        Sway = { 0.8, 2.2 },
        SwayFrequency = { 1.2, 2.4 },
        HitSpeed = { 2.5, 2.85 },
        LeafSpeed = { 1.35, 1.65 }
    },
    RingSparring = {
        RoundLength = 180,
        BreakLength = 60,
        BreakHealShare = 0.7,
        Countdown = 5,
        SpentGain = 0.02,
        FinishGain = 0.02,
        WinGain = 0.03,
        OutOfRingForfeit = 4,
        AutoWalkSpeed = 14,
        AutoWalkTimeout = 6,
        StoolPadGap = 0.3,
        StandFromStool = 1.6,
        StoolPromptDistance = 6,
        StoolSitAnimation = "rbxassetid://113548738818137",
        DividerHeight = 14,
        BellSound = "rbxassetid://121004887582791",
        BellVolume = 1,
        EndBellSound = "rbxassetid://133297450283399",
        EndBellVolume = 1,
        Stat = { "Stamina", 1 },
        DigitColor = Color3.fromRGB(255, 45, 30)
    },
    HealingBench = {
        FullHealSeconds = 18
    },
    Gains = {
        RoadworkCheckpoint = { 0.039, 0.045 },
        PunchingBag = { 0.011, 0.016 },
        SpeedBag = { 0.027, 0.032 },
        JumpRope = { 0.018, 0.021 },
        Curls = { 0.022, 0.029 },
        Bench = { 0.031, 0.038 },
        Squats = { 0.026, 0.032 },
        AbCrunches = { 0.039, 0.048 },
        MittsHolder = { 0.013, 0.015 },
        MittsHitter = { 0.015, 0.02 },
        Leaf = { 0.014, 0.016 }
    },
    GainShares = {
        1, 0.5, 0.3, 0.21, 0.1575, 0.1, 0.05, 0.04,
        0.03, 0.02
    }
}

function t1.GainMultiplier(p1) -- line: 463
    -- upvalues: t1 (copy)
    local GainShares = t1.GainShares

    return GainShares[math.clamp(math.floor(math.max(tonumber(p1) or 0, 0) + 1E-06) + 1, 1, #GainShares)]
end

function t1.GainAmount(p2, p3, p4) -- line: 471
    -- upvalues: t1 (copy)
    local v5 = t1.Gains[p2]

    if not v5 then
        return 0
    end

    local v6 = if p4 then math.clamp(p4, 0, 1) else math.random()

    return (v5[1] + (v5[2] - v5[1]) * v6) * t1.GainMultiplier(p3)
end

t1.StaminaGrowth = {
    MaxPerWholePoint = 0.15,
    RunStaminaFromPoint = 1,
    RunStaminaMultiplier = 1.8
}

function t1.MaxStamina(p5) -- line: 491
    -- upvalues: t1 (copy)
    return p5 and p5:GetAttribute("StaminaMax") or t1.Stamina.Max
end

t1.HitReactions = {
    MinWeight = 0.35,
    CenterWidth = 0.4,
    SinkDepth = 0.6,
    DepthTolerance = 1.2,
    FadeIn = 0.05,
    CompanionMin = 0.25,
    CompanionMax = 0.6,
    CenterZone = 0.25,
    CenterHeadTilt = 16,
    HookCenterZone = 0.4,
    HookCenterLean = 12,
    UppercutCenterZone = 0.32,
    LeanTime = 0.06,
    LeanRecover = 0.38,
    TwistTime = 0.05,
    TwistRecover = 0.38,
    StumbleMinKnockback = 6,
    CounterStrength = 1.35,
    CounterStagger = 0.75,
    StumbleLean = 11,
    StumbleStep = 22,
    StumbleTime = 0.5,
    UppercutHeadSnap = 40,
    HeadSnapTime = 0.045,
    HeadSnapRecover = 0.4,
    Animations = {
        HitHead_Left = "rbxassetid://120742081211243",
        HitHead_Right = "rbxassetid://118580375559325",
        HitHead_Top = "rbxassetid://76893698810484",
        HitTorso_Bottom = "rbxassetid://137802751438826",
        HitTorso_Left = "rbxassetid://115241899954316",
        HitTorso_Right = "rbxassetid://138851158398020",
        HitTorso_Top = "rbxassetid://96928973696614"
    },
    Priority = Enum.AnimationPriority.Action3,
    Companions = {
        HitHead_Left = "HitTorso_Left",
        HitHead_Right = "HitTorso_Right",
        HitHead_Top = "HitTorso_Top",
        HitTorso_Left = "HitHead_Left",
        HitTorso_Right = "HitHead_Right",
        HitTorso_Top = "HitHead_Top"
    },
    TwistDegrees = {
        Hook = 21,
        Jab = 13,
        Cross = 16,
        Uppercut = 18
    },
    CenterLean = {
        Jab = 8,
        Cross = 13,
        Hook = 7,
        Uppercut = 8
    }
}
t1.Stats = {
    Max = 10,
    SubMax = 10,
    PointCap = 40,
    StartValue = 0,
    StartingPoints = 40,
    NodeMinRadius = 0.18,
    CameraPart = "camera test",
    CameraTweenTime = 0.6,
    CameraFOV = 56,
    DataStore = "BoxingStats_v2",
    Names = { "Power", "Speed", "Technique", "Willpower", "Endurance", "Stamina" },
    Subs = {
        Power = { "Arm Strength", "Leg Strength" },
        Speed = { "Punch Speed", "Footwork" },
        Technique = { "Punch Sharpness", "Skill Mastery" },
        Willpower = { "Courage", "Bloodthirst" },
        Endurance = { "Guard Endurance", "Torso Endurance" },
        Stamina = { "Drain Resistance", "Fatigue Resistance" }
    }
}
t1.LockOn = {
    Range = 45,
    BreakRange = 70,
    CameraSpring = 13,
    MaxZoom = 11,
    ZoomInRate = 8,
    CameraRaise = 1.1,
    FovWiden = 8,
    BlendTime = 0.35,
    FaceRate = 22,
    Key = Enum.UserInputType.MouseButton3,
    AltKey = Enum.KeyCode.L
}
t1.SettingsSections = { "Gameplay", "Effects", "Graphics", "Audio", "Controls" }
t1.Settings = {
    {
        Key = "AimIndicator",
        Section = "Gameplay",
        Name = "Aim indicator",
        Hint = "HEAD / BODY under the crosshair",
        Default = false
    },
    {
        Key = "Crosshair",
        Section = "Gameplay",
        Name = "Crosshair",
        Hint = "Tiny box in the middle of the screen in shift lock",
        Default = true
    },
    {
        Key = "Hitmarker",
        Section = "Gameplay",
        Name = "Hitmarker",
        Hint = "The crosshair pops when your punch lands",
        Default = true
    },
    {
        Key = "WeightInPounds",
        Section = "Gameplay",
        Name = "Weight in pounds (LBS)",
        Hint = "Off = kilograms (KG)",
        Default = false
    },
    {
        Key = "CameraShake",
        Section = "Effects",
        Name = "Camera shake",
        Hint = "Shake on hits, sway when dazed",
        Default = true
    },
    {
        Key = "HitFlash",
        Section = "Effects",
        Name = "Hit flashes",
        Hint = "Body flash, screen flash and red screen edges",
        Default = true
    },
    {
        Key = "HeadHitBlur",
        Section = "Effects",
        Name = "Head-hit blur",
        Hint = "Red blur when you're hit in the head",
        Default = true
    },
    {
        Key = "LowHealthEffect",
        Section = "Effects",
        Name = "Low health effect",
        Hint = "Red, blurry screen at low health",
        Default = true
    },
    {
        Key = "KnockdownEffect",
        Section = "Effects",
        Name = "Knockdown effect",
        Hint = "Blur and muffled sound when knocked down",
        Default = true
    },
    {
        Key = "KnockoutReplay",
        Section = "Effects",
        Name = "Knockout replay",
        Hint = "Slow-motion replay of the finishing knockdown",
        Default = true
    },
    {
        Key = "VFX",
        Section = "Effects",
        Name = "Punch & technique effects",
        Hint = "Hit sparks, speed lines, technique swirls, auras and impacts",
        Default = true
    },
    {
        Key = "ZoneHitColors",
        Section = "Effects",
        Name = "Head / body hit colours",
        Hint = "Red hit effects on the head, blue on the body",
        Default = false
    },
    {
        Key = "BagPhysics",
        Section = "Effects",
        Name = "Punching bag physics",
        Hint = "Heavy bags swing and dent when you hit them - off for a smoother game",
        Default = true
    },
    {
        Key = "GraphicsPreset",
        Section = "Graphics",
        Name = "Graphics quality",
        Hint = "1 = Low (phones, old PCs)  ·  2 = Medium  ·  3 = High - sets everything below",
        Default = 3,
        Min = 1,
        Max = 3,
        Step = 1,
        Format = "%d"
    },
    {
        Key = "ParticleAmount",
        Section = "Graphics",
        Name = "Particle amount",
        Hint = "Fewer sparks, dust and aura particles - lower runs smoother in busy fights",
        Default = 100,
        Min = 25,
        Max = 100,
        Step = 5,
        Format = "%d%%"
    },
    {
        Key = "Blood",
        Section = "Graphics",
        Name = "Blood",
        Hint = "Blood on hits, cuts and the nose drip",
        Default = true
    },
    {
        Key = "Shadows",
        Section = "Graphics",
        Name = "Shadows",
        Hint = "Turn off for more frames on slower devices",
        Default = true
    },
    {
        Key = "Glow",
        Section = "Graphics",
        Name = "Glow and sun rays",
        Hint = "Bloom on bright lights and the sun's rays",
        Default = true
    },
    {
        Key = "LowGraphics",
        Section = "Graphics",
        Name = "Low graphics",
        Hint = "No shadows, glow or rain particles - smoother on phones (on by default there)",
        Default = false
    },
    {
        Key = "NearbyLightsOn3",
        Section = "Graphics",
        Name = "Nearby lights only",
        Hint = "Only lights close to you are switched on - off lights up the whole map but runs slower",
        Default = false
    },
    {
        Key = "Rain",
        Section = "Graphics",
        Name = "Rain",
        Hint = "Falling rain and splashes (the sky still darkens) - off for more frames",
        Default = true
    },
    {
        Key = "ViewDistance",
        Section = "Graphics",
        Name = "View distance",
        Hint = "How far away buildings and props are drawn - lower runs smoother",
        Default = 1000,
        Min = 150,
        Max = 1000,
        Step = 50,
        Format = "%d studs",
        MaxText = "Max"
    },
    {
        Key = "DetailDistance",
        Section = "Graphics",
        Name = "Detail (LOD)",
        Hint = "How far small props and decorations are drawn - lower runs smoother",
        Default = 1000,
        Min = 50,
        Max = 1000,
        Step = 25,
        Format = "%d studs",
        MaxText = "Max"
    },
    {
        Key = "MasterVolume",
        Section = "Audio",
        Name = "Master volume",
        Hint = "Every sound in the game",
        Default = 100,
        Min = 0,
        Max = 100,
        Step = 5,
        Format = "%d%%"
    },
    {
        Key = "MusicVolume",
        Section = "Audio",
        Name = "Music",
        Hint = "Day / night themes and the fight music",
        Default = 70,
        Min = 0,
        Max = 100,
        Step = 5,
        Format = "%d%%"
    },
    {
        Key = "WalkoutSongs",
        Section = "Audio",
        Name = "Walkout songs",
        Hint = "Boxers' songs during ranked entrances in Korakuen Hall",
        Default = true
    },
    {
        Key = "GameVolume",
        Section = "Audio",
        Name = "Game sounds",
        Hint = "Punches, training, the town",
        Default = 100,
        Min = 0,
        Max = 100,
        Step = 5,
        Format = "%d%%"
    },
    {
        Key = "InterfaceVolume",
        Section = "Audio",
        Name = "Interface sounds",
        Hint = "Menu clicks, timers and alerts",
        Default = 100,
        Min = 0,
        Max = 100,
        Step = 5,
        Format = "%d%%"
    },
    {
        Key = "Sensitivity",
        Section = "Controls",
        Name = "Camera sensitivity",
        Hint = "How fast the mouse turns the camera",
        Default = 1,
        Min = 0.2,
        Max = 2,
        Step = 0.05,
        Format = "%.2fx"
    },
    {
        Key = "FieldOfView",
        Section = "Controls",
        Name = "Field of view",
        Hint = "How wide the camera sees",
        Default = 70,
        Min = 60,
        Max = 90,
        Step = 1,
        Format = "%d°"
    },
    {
        Key = "FeintOnKey",
        Section = "Controls",
        Name = "Right feint on its own key",
        Hint = "Off: tap right click while blocking to feint  ·  On: press the Right feint key (V - change it in Keyboard Keys), right click only holds the head guard",
        Default = false
    },
    {
        Key = "Vibration",
        Section = "Controls",
        Name = "Controller vibration",
        Hint = "Rumble when you hit or get hit",
        Default = true
    },
    {
        Key = "TouchButtonSize",
        Section = "Controls",
        Name = "Touch button size",
        Hint = "The fight buttons on phones and tablets",
        Default = 1,
        Min = 0.7,
        Max = 1.4,
        Step = 0.05,
        Format = "%.2fx"
    },
    {
        Key = "ControllerBinds",
        Section = "Controls",
        Name = "Controller buttons",
        Default = "",
        Hidden = true,
        MaxLength = 1500
    },
    {
        Key = "KeyboardBinds",
        Section = "Controls",
        Name = "Keyboard keys",
        Default = "",
        Hidden = true,
        MaxLength = 1500
    },
    {
        Key = "TouchLayout",
        Section = "Controls",
        Name = "Touch button layout",
        Default = "",
        Hidden = true,
        MaxLength = 1500
    },
    {
        Key = "JoystickLayout",
        Section = "Controls",
        Name = "Joystick layout",
        Default = "",
        Hidden = true,
        MaxLength = 300
    },
    {
        Key = "TutorialDone",
        Section = "Gameplay",
        Name = "Tutorial done",
        Default = false,
        Hidden = true
    }
}
t1.Gamepad = {
    Gloved = {
        {
            Action = "PunchLeft",
            Name = "Left punch",
            Default = "ButtonX"
        },
        {
            Action = "PunchRight",
            Name = "Right punch",
            Default = "ButtonY"
        },
        {
            Action = "HoldHook",
            Name = "Hooks (hold)",
            Default = "ButtonR2"
        },
        {
            Action = "HoldUppercut",
            Name = "Uppercuts (hold)",
            Default = "ButtonL2"
        },
        {
            Action = "Block",
            Name = "Block (+ Dash button = head block)",
            Default = "ButtonA"
        },
        {
            Action = "Weave",
            Name = "Weave",
            Default = "ButtonL1"
        },
        {
            Action = "Dash",
            Name = "Dash / head block while blocking",
            Default = "ButtonR1"
        },
        {
            Action = "Tech1",
            Name = "Technique 1",
            Default = "DPadLeft"
        },
        {
            Action = "Tech2",
            Name = "Technique 2",
            Default = "DPadRight"
        },
        {
            Action = "Stance",
            Name = "Switch stance",
            Default = "DPadUp"
        },
        {
            Action = "Gloves",
            Name = "Gloves off",
            Default = "DPadDown"
        },
        {
            Action = "LockOn",
            Name = "Lock on",
            Default = "ButtonR3"
        }
    },
    Ungloved = {
        {
            Action = "Gloves",
            Name = "Gloves on / put away",
            Default = "DPadDown"
        },
        {
            Action = "HotbarNext",
            Name = "Next hotbar slot",
            Default = "ButtonR1"
        },
        {
            Action = "HotbarPrev",
            Name = "Previous hotbar slot",
            Default = "ButtonL1"
        },
        {
            Action = "RunToggle",
            Name = "Run",
            Default = "ButtonL3"
        },
        {
            Action = "SkillTree",
            Name = "Skill Tree",
            Default = "DPadLeft"
        },
        {
            Action = "Statistics",
            Name = "Statistics",
            Default = "DPadRight"
        },
        {
            Action = "LockOn",
            Name = "Lock on",
            Default = "ButtonR3"
        },
        {
            Action = "PickButtons",
            Name = "Pick on-screen buttons",
            Default = "DPadUp"
        }
    },
    Allowed = {
        "ButtonA",
        "ButtonX",
        "ButtonY",
        "ButtonL1",
        "ButtonR1",
        "ButtonL2",
        "ButtonR2",
        "ButtonL3",
        "ButtonR3",
        "DPadUp",
        "DPadDown",
        "DPadLeft",
        "DPadRight"
    },
    UnglovedTaken = {
        ButtonA = "Jump",
        ButtonR2 = "Use item"
    },
    ShortNames = {
        ButtonA = "A",
        ButtonB = "B",
        ButtonX = "X",
        ButtonY = "Y",
        ButtonL1 = "LB",
        ButtonR1 = "RB",
        ButtonL2 = "LT",
        ButtonR2 = "RT",
        ButtonL3 = "L3",
        ButtonR3 = "R3",
        DPadUp = "D-pad up",
        DPadDown = "D-pad down",
        DPadLeft = "D-pad left",
        DPadRight = "D-pad right",
        ButtonSelect = "View"
    }
}

function t1.GamepadBinds(p6) -- line: 723
    -- upvalues: t1 (copy)
    local t2 = {
        Gloved = {},
        Ungloved = {}
    }
    local v7, v8

    if type(p6) == "string" and p6 ~= "" then
        local function v9() -- line: 727
            -- upvalues: p6 (copy)
            return game:GetService("HttpService"):JSONDecode(p6)
        end

        local ok, result = pcall(v9)

        v7 = ok and type(result) == "table" and result or nil
        v8 = v7
    end

    local t3 = {}

    for _, v10 in t1.Gamepad.Allowed do
        t3[v10] = true
    end

    for v11, v12 in {
            Gloved = t1.Gamepad.Gloved,
            Ungloved = t1.Gamepad.Ungloved
        } do
        local v13 = if v8 then type(v8[v11]) == "table" and v8[v11] or {} else {}

        for _, v15 in v12 do
            local v16 = v13[v15.Action]

            if type(v16) ~= "string" or not t3[v16] or v11 == "Ungloved" and t1.Gamepad.UnglovedTaken[v16] then
                v16 = v15.Default
            end

            t2[v11][v15.Action] = v16
        end
    end

    return t2
end

t1.MenuKey = Enum.KeyCode.M
t1.Keyboard = {
    List = {
        {
            Action = "Straight",
            Name = "Straights",
            Default = "Z"
        },
        {
            Action = "Hook",
            Name = "Hooks",
            Default = "X"
        },
        {
            Action = "Uppercut",
            Name = "Uppercuts",
            Default = "C"
        },
        {
            Action = "Block",
            Name = "Body block",
            Default = "F"
        },
        {
            Action = "HeadBlock",
            Name = "Head block",
            Default = "G"
        },
        {
            Action = "Feint",
            Name = "Right feint",
            Default = "V"
        },
        {
            Action = "Weave",
            Name = "Weave (hold)",
            Default = "Space"
        },
        {
            Action = "Dash",
            Name = "Dash",
            Default = "Q"
        },
        {
            Action = "Run",
            Name = "Run",
            Default = "LeftShift"
        },
        {
            Action = "Tech1",
            Name = "Technique 1",
            Default = "E"
        },
        {
            Action = "Tech2",
            Name = "Technique 2",
            Default = "R"
        },
        {
            Action = "Stance",
            Name = "Switch stance",
            Default = "T"
        },
        {
            Action = "LockOn",
            Name = "Lock on",
            Default = "L"
        },
        {
            Action = "ShiftLock",
            Name = "Shift lock",
            Default = "LeftAlt"
        },
        {
            Action = "Menu",
            Name = "Menu",
            Default = "M"
        }
    },
    Allowed = {
        "B",
        "C",
        "E",
        "F",
        "G",
        "H",
        "I",
        "J",
        "K",
        "L",
        "M",
        "N",
        "O",
        "P",
        "Q",
        "R",
        "T",
        "U",
        "V",
        "X",
        "Y",
        "Z",
        "Space",
        "LeftShift",
        "RightShift",
        "LeftControl",
        "RightControl",
        "LeftAlt",
        "RightAlt",
        "Tab",
        "CapsLock"
    },
    ShortNames = {
        LeftShift = "L Shift",
        RightShift = "R Shift",
        LeftControl = "L Ctrl",
        RightControl = "R Ctrl",
        LeftAlt = "L Alt",
        RightAlt = "R Alt",
        CapsLock = "Caps"
    }
}

function t1.KeyboardBinds(p7) -- line: 782
    -- upvalues: t1 (copy)
    local v17, v18

    if type(p7) == "string" and p7 ~= "" then
        local function v19() -- line: 785
            -- upvalues: p7 (copy)
            return game:GetService("HttpService"):JSONDecode(p7)
        end

        local ok, result = pcall(v19)

        v17 = ok and type(result) == "table" and result or nil
        v18 = v17
    end

    local t4 = {}

    for _, v20 in t1.Keyboard.Allowed do
        t4[v20] = true
    end

    local t5 = {}
    local t6 = {}

    for _, v21 in t1.Keyboard.List do
        local v22 = v18 and v18[v21.Action]

        if type(v22) ~= "string" or not t4[v22] or t6[v22] then
            v22 = v21.Default
        end

        t5[v21.Action] = v22
        t6[v22] = true
    end

    return t5
end

local t7 = {
    Enum.KeyCode.LeftAlt,
    Enum.KeyCode.RightAlt
}

function t1.ApplyKeyboardBinds(p8) -- line: 808
    -- upvalues: t1 (copy), t7 (copy)
    local v23 = t1.KeyboardBinds(p8)
    local KeyCode = Enum.KeyCode

    table.clear(t1.StyleKeys)
    t1.StyleKeys[KeyCode[v23.Straight]] = "Straight"
    t1.StyleKeys[KeyCode[v23.Hook]] = "Hook"
    t1.StyleKeys[KeyCode[v23.Uppercut]] = "Uppercut"
    t1.BlockKey = KeyCode[v23.Block]
    t1.HeadBlockKey = KeyCode[v23.HeadBlock] or Enum.KeyCode.G
    t1.FeintKey = KeyCode[v23.Feint] or Enum.KeyCode.V
    t1.Weave.Key = KeyCode[v23.Weave]
    t1.Dash.Key = KeyCode[v23.Dash]
    t1.Movement.RunKey = KeyCode[v23.Run]
    t1.SkillKeys[1] = KeyCode[v23.Tech1]
    t1.SkillKeys[2] = KeyCode[v23.Tech2]
    t1.StanceSwitchKey = KeyCode[v23.Stance]
    t1.LockOn.AltKey = KeyCode[v23.LockOn]
    table.clear(t1.Camera.ShiftLockKeys)

    if v23.ShiftLock == "LeftAlt" then
        for _, v24 in t7 do
            table.insert(t1.Camera.ShiftLockKeys, v24)
        end
    else
        table.insert(t1.Camera.ShiftLockKeys, KeyCode[v23.ShiftLock])
    end

    t1.MenuKey = KeyCode[v23.Menu]

    return v23
end

t1.SettingsDataStore = "BoxingSettings_v1"
t1.JamRange = 3
t1.JamKnockbackMultiplier = 0.5
t1.JamHitKnockback = 0.1
t1.JamHitVolume = 0.5
t1.JamTouching = 1.5
t1.JamDamageMin = 0.1
t1.JamDamageMax = 0.4

function t1.JamDamageScale(p9) -- line: 851
    -- upvalues: t1 (copy)
    local v27 = math.max(t1.JamRange - t1.JamTouching, 0.01)
    local v29 = math.clamp((p9 - t1.JamTouching) / v27, 0, 1)

    return t1.JamDamageMin + (t1.JamDamageMax - t1.JamDamageMin) * v29
end

t1.Guard = {
    Max = 260,
    RegenPerSecond = 40,
    RegenDelay = 1.5,
    BreakStun = 1.8,
    BrokenDamageMultiplier = 1.25,
    BlockStun = 0.15
}
t1.Stamina = {
    Max = 240,
    RunDrainPerSecond = 8.75,
    RegenPerSecond = 11.15,
    RegenDelay = 0.9,
    MinToStartRunning = 10,
    OutOfCombatMultiplier = 3,
    OutOfCombatAfter = 6
}
t1.Movement = {
    WalkSpeed = 16,
    RunSpeed = 26,
    GlovedWalkSpeed = 9,
    BlockSpeed = 4.5,
    HitStunSpeed = 6,
    DoubleTapWindow = 0.3,
    RunFovBoost = 6,
    RunKey = Enum.KeyCode.LeftShift
}
t1.Fatigue = {
    PerRepeat = 0.15,
    MaxRepeats = 5,
    ResetAfter = 0.35
}

function t1.FatigueMultiplier(p10) -- line: 905
    -- upvalues: t1 (copy)
    local Fatigue = t1.Fatigue

    return 1 / (1 - Fatigue.PerRepeat) ^ math.clamp(p10, 0, Fatigue.MaxRepeats)
end

t1.StyleKeys = {
    [Enum.KeyCode.Z] = "Straight",
    [Enum.KeyCode.X] = "Hook",
    [Enum.KeyCode.C] = "Uppercut"
}
t1.StanceName = "Orthodox Stance:"
t1.Styles = {
    Straight = {
        Left = "Jab",
        Right = "Cross",
        Display = "Jab / Straights"
    },
    Uppercut = {
        Left = "LeftUppercut",
        Right = "RightUppercut",
        Display = "Uppercuts"
    },
    Hook = {
        Left = "LeftHook",
        Right = "RightHook",
        Display = "Hooks"
    }
}
t1.Animations = {
    Stance = "rbxassetid://78935802790252",
    Block = "rbxassetid://82960884735709",
    MoveSpeedReference = 9,
    HeadGuardLift = 0.6,
    Feint = "rbxassetid://135003386275261",
    CrossFeint = "rbxassetid://74443132951222",
    BlockMove = {
        Forward = "rbxassetid://93289376961976",
        Backward = "rbxassetid://123010918201206",
        Left = "rbxassetid://96374161778542",
        Right = "rbxassetid://133955867010329"
    },
    Move = {
        Forward = "rbxassetid://131153290635389",
        Backward = "rbxassetid://75801148026867",
        Left = "rbxassetid://88421446141360",
        Right = "rbxassetid://101417937749270"
    },
    Run = {
        Fresh = "rbxassetid://70833215978103",
        Tired = "rbxassetid://79540580743976",
        TiredBelow = 0.2,
        SpeedReference = 26
    },
    Punches = {
        Jab = {
            Head = {
                Id = "rbxassetid://120929572380803",
                HitTime = 0.08
            },
            Body = {
                Id = "rbxassetid://121490556182390",
                HitTime = 0.08
            }
        },
        Cross = {
            Head = {
                Id = "rbxassetid://125925250642881",
                HitTime = 0.2
            },
            Body = {
                Id = "rbxassetid://73037255825531",
                HitTime = 0.2
            }
        },
        LeftHook = {
            Head = {
                Id = "rbxassetid://74116903745736",
                HitTime = 0.15
            },
            Body = {
                Id = "rbxassetid://83179438149307",
                HitTime = 0.2
            }
        },
        RightHook = {
            Head = {
                Id = "rbxassetid://82778007170820",
                HitTime = 0.15
            },
            Body = {
                Id = "rbxassetid://126934482441014",
                HitTime = 0.2
            }
        },
        LeftUppercut = {
            Head = {
                Id = "rbxassetid://81448912816321",
                HitTime = 0.3
            },
            Body = {
                Id = "rbxassetid://127754184468456",
                HitTime = 0.18
            }
        },
        RightUppercut = {
            Head = {
                Id = "rbxassetid://131513453986819",
                HitTime = 0.3
            },
            Body = {
                Id = "rbxassetid://139884663728274",
                HitTime = 0.18
            }
        }
    }
}

local HttpService = game:GetService("HttpService")
local t8 = {}

function t1.LoadoutOf(p11) -- line: 991
    -- upvalues: HttpService (copy), t8 (copy)
    local Loadout = p11 and p11:GetAttribute("Loadout")

    if type(Loadout) ~= "string" then
        return {}
    end

    local v31 = t8[p11]

    if v31 and v31.Raw == Loadout then
        return v31.Table
    end

    local JSONDecode = HttpService.JSONDecode
    local ok, result = pcall(JSONDecode, HttpService, Loadout)

    if not ok or type(result) ~= "table" then
        result = {}
    end

    t8[p11] = {
        Raw = Loadout,
        Table = result
    }

    return result
end

function t1.ActiveStanceItem(p12) -- line: 1005
    -- upvalues: Players (copy), t1 (copy)
    local v32 = p12 and Players:GetPlayerFromCharacter(p12)

    if not v32 then
        return p12 and p12:GetAttribute("StanceItem") or nil
    end

    local v33 = if v32:GetAttribute("ActiveStance") == 2 then "Stance2" else "Stance1"

    return t1.LoadoutOf(v32)[v33]
end

function t1.PunchAnimation(p13, p14, p15) -- line: 1018
    -- upvalues: t1 (copy)
    local v34 = p15 and t1.ActiveStanceItem(p15)
    local v35 = v34 and t1.Loadout.Items[v34]

    if p13 ~= "Jab" or not t1.HasFlicker(p15) then
        local v36 = if p13 == "Jab" and v35 and v35.JabWindup then v35.JabWindup else 1
        local Punches = v35 and v35.Punches and v35.Punches[p13] and v35.Punches[p13][p14]

        if Punches and Punches.Id and Punches.Id ~= "" then
            local v37 = Punches.Rate or 1

            return Punches.Id, (Punches.HitTime or 0.2) / v37 * v36, v37
        end

        local v38 = t1.Animations.Punches[p13]
        local v39 = v38 and v38[p14]
        local v40 = t1.Punches[p13]
        local Id, HitTime

        if v39 and v39.Id and v39.Id ~= "" then
            Id = v39.Id
            HitTime = v39.HitTime or v40 and v40.HitTime or 0.15

            return Id, HitTime * v36, 1
        end

        return "", (v40 and v40.HitTime or 0.15) * v36, 1
    end

    local FlickerJab = t1.FlickerJab
    local _, v41 = t1.StanceOf(p15)
    local FlickerAnim = v41.FlickerAnim

    if not FlickerAnim or not FlickerAnim.Id or FlickerAnim.Id == "" then
        return "", FlickerJab.HitTime * FlickerJab.Windup, 1
    end

    local v42 = FlickerAnim.Rate or 1

    return FlickerAnim.Id, FlickerAnim.HitTime / v42, v42
end

function t1.ActiveGuardItem(p16) -- line: 1050
    -- upvalues: Players (copy), t1 (copy)
    local v43 = p16 and Players:GetPlayerFromCharacter(p16)
    local GuardItem

    if v43 then
        local v44 = if v43:GetAttribute("ActiveStance") == 2 then "Guard2" else "Guard1"

        GuardItem = t1.LoadoutOf(v43)[v44]
    else
        if p16 then
            GuardItem = p16:GetAttribute("GuardItem")
        end

        if not p16 or not GuardItem then
            GuardItem = nil
        end
    end

    local v45 = GuardItem and t1.Loadout.Items[GuardItem]

    if v45 and v45.Type == "Guard" then
        return GuardItem, v45
    end

    return nil, nil
end

function t1.StanceOf(p17) -- line: 1067
    -- upvalues: t1 (copy)
    local Items = t1.Loadout.Items
    local v46 = p17 and t1.ActiveStanceItem(p17)

    if v46 and Items[v46] and Items[v46].Type == "Stance" then
        return v46, Items[v46]
    end

    return "OrthodoxStance", Items.OrthodoxStance
end

local t9 = {}

function t1.StanceAnimations(p18) -- line: 1080
    -- upvalues: t1 (copy), t9 (copy)
    local v47, v48 = t1.StanceOf(p18)
    local v49, v50 = t1.ActiveGuardItem(p18)

    if not (v50 and v50.Animations) then
        v49 = ""
    end

    local v51 = v47 .. "|" .. v49
    local v52 = t9[v51]

    if v52 then
        return v52, v47
    end

    local Animations = t1.Animations
    local v53 = v48.Animations or {}
    local t10 = {
        Stance = v53.Stance or Animations.Stance,
        Block = v53.Block or Animations.Block,
        Feint = v53.Feint or Animations.Feint,
        CrossFeint = v53.CrossFeint or Animations.CrossFeint,
        Move = table.clone(Animations.Move or {}),
        BlockMove = table.clone(Animations.BlockMove or {})
    }

    for v54, v55 in v53.Move or {} do
        t10.Move[v54] = v55
    end

    for v56, v57 in v53.BlockMove or {} do
        t10.BlockMove[v56] = v57
    end

    local v58 = v50 and v50.Animations

    if v58 then
        if v58.Block then
            t10.Block = v58.Block
        end

        for v59, v60 in v58.BlockMove or {} do
            t10.BlockMove[v59] = v60
        end
    end

    t9[v51] = t10

    return t10, v47
end

t1.BlockArmPoses = {
    ["rbxassetid://82960884735709"] = {
        Period = 2,
        A = {
            Right = CFrame.new(0.2395, -0.7428, -0.4729, 0.1086, -0.1502, 0.9827, 0.1187, -0.9795, -0.1628, 0.987, 0.1343, -0.0885),
            Left = CFrame.new(0.1985, -0.7406, -0.293, -0.4618, 0.1716, -0.8702, -0.1205, -0.9841, -0.1301, -0.8788, 0.0448, 0.4751)
        },
        B = {
            Right = CFrame.new(0.2395, -0.7428, -0.4729, 0.1213, -0.1479, 0.9815, 0.1368, -0.9769, -0.1641, 0.9831, 0.1542, -0.0983),
            Left = CFrame.new(0.1985, -0.7406, -0.293, -0.4499, 0.1824, -0.8742, -0.1425, -0.981, -0.1313, -0.8816, 0.0655, 0.4674)
        }
    },
    ["rbxassetid://80928731104774"] = {
        Period = 1.695,
        A = {
            Right = CFrame.new(0.7993, 0.2432, -0.4884, -0.1223, 0.0607, 0.9906, 0.9696, -0.2059, 0.1323, 0.212, 0.9767, -0.0337),
            Left = CFrame.new(-0.3303, -0.3279, -0.261, 0.1378, 0.4672, -0.8734, -0.9641, 0.2654, -0.0102, 0.227, 0.8434, 0.487)
        },
        B = {
            Right = CFrame.new(0.7908, 0.1872, -0.49, -0.0694, 0.0351, 0.997, 0.9836, -0.1641, 0.0743, 0.1662, 0.9858, -0.0231),
            Left = CFrame.new(-0.2949, -0.3976, -0.2261, 0.1785, 0.4765, -0.8609, -0.9635, 0.2618, -0.0549, 0.1993, 0.8393, 0.5059)
        }
    },
    ["rbxassetid://103697110601001"] = {
        Period = 2,
        A = {
            Right = CFrame.new(0.1613, -0.6589, -0.5434, -0.0957, -0.1614, 0.9822, 0.0821, -0.9847, -0.1538, 0.992, 0.0659, 0.1075),
            Left = CFrame.new(-0.1426, -0.6633, -0.4659, -0.0962, 0.1638, -0.9818, -0.0751, -0.9847, -0.1569, -0.9925, 0.0586, 0.1071)
        },
        B = {
            Right = CFrame.new(0.1613, -0.6873, -0.4935, -0.0792, -0.1605, 0.9838, 0.0333, -0.9868, -0.1583, 0.9963, 0.0203, 0.0835),
            Left = CFrame.new(-0.1426, -0.7054, -0.4989, -0.121, 0.1641, -0.979, -0.0291, -0.9864, -0.1617, -0.9922, 0.0089, 0.1241)
        }
    }
}

function t1.BlockArmsOnly(p19) -- line: 1140
    -- upvalues: t1 (copy)
    local _, v61 = t1.StanceOf(p19)

    return if v61.BlockArmsOnly ~= false then t1.BlockArmPoses[t1.StanceAnimations(p19).Block or ""] else nil
end

function t1.IsMirrored(p20) -- line: 1149
    -- upvalues: t1 (copy)
    local _, v62 = t1.StanceOf(p20)

    return v62.Mirror == true
end

t1.FlickerJab = {
    HitTime = 0.1,
    Windup = 1.15,
    Reach = 1.5,
    Stretch = 2.24,
    Retract = 0.09,
    RandomAngle = 6,
    BuffTime = 8,
    BuffSpeed = 1.25
}

local function permanentFlicker(p21, p22) -- line: 1169
    if not p22.Flicker then
        return false
    end

    if p22.FlickerSkill then
        return require(script.Parent:WaitForChild("BoxingSkills")).ModelHas(p21, p22.FlickerSkill)
    end

    return true
end

function t1.HasFlicker(p23) -- line: 1178
    -- upvalues: t1 (copy)
    if not p23 then
        return false
    end

    local _, v63 = t1.StanceOf(p23)

    if v63.Flicker and (not v63.FlickerSkill or require(script.Parent:WaitForChild("BoxingSkills")).ModelHas(p23, v63.FlickerSkill)) then
        return true
    end

    if v63.FlickerWithBuff == true or v63.Flicker == true then
        return (p23:GetAttribute("FlickerUntil") or 0) > workspace:GetServerTimeNow()
    end

    return false
end

function t1.FlickerSpeed(p24) -- line: 1190
    -- upvalues: t1 (copy)
    local _, v64 = t1.StanceOf(p24)

    if not not (not v64.Flicker or v64.FlickerSkill and not require(script.Parent:WaitForChild("BoxingSkills")).ModelHas(p24, v64.FlickerSkill) or not ((p24:GetAttribute("FlickerUntil") or 0) > workspace:GetServerTimeNow())) then
        return 1
    end

    return 1 / t1.FlickerJab.BuffSpeed
end

function t1.StancePunch(p25, p26, p27) -- line: 1200
    -- upvalues: t1 (copy)
    p27 = p27 or t1.Punches[p26]

    if not p27 then
        return nil
    end

    local _, v66 = t1.StanceOf(p25)
    local v67, v68

    if p27.Anim == "Jab" or p26 == "Jab" then
        v67 = if t1.HasFlicker(p25) then t1.FlickerJab.Reach else v66.JabReach or 1
        v68 = v66.JabContact or 0
    else
        v67 = 1
        v68 = 0
    end

    if v67 == 1 and not v66.Mirror and v68 == 0 then
        return p27
    end

    local v69 = table.clone(p27)

    if v68 ~= 0 then
        v69.ContactBonus = (p27.ContactBonus or 0) + v68
    end

    if v67 ~= 1 then
        v69.HitboxSize = Vector3.new(p27.HitboxSize.X, p27.HitboxSize.Y, p27.HitboxSize.Z * v67)
        v69.HitboxOffset = p27.HitboxOffset - Vector3.new(0, 0, p27.HitboxSize.Z * (v67 - 1) / 2)
    end

    if v66.Mirror then
        v69.HitboxOffset *= Vector3.new(-1, 1, 1)
        v69.Knockback *= Vector3.new(-1, 1, 1)

        if v69.Side == "Left" then
            v69.Side = "Right"

            return v69
        end

        if v69.Side == "Right" then
            v69.Side = "Left"
        end
    end

    return v69
end

function t1.StanceDamageBonus(p28, p29, p30, p31) -- line: 1236
    -- upvalues: t1 (copy)
    local _, v72 = t1.StanceOf(p28)
    local Damage = v72.Damage

    if not Damage then
        return 0
    end

    local v73 = Damage.Punches and Damage.Punches[p29] or 0

    if Damage.BodyHooks and p31 == "Body" and p30 and p30.Anim == "Hook" then
        v73 += Damage.BodyHooks
    end

    if Damage.AllScale then
        v73 = (1 + v73) * Damage.AllScale - 1
    end

    return v73
end

t1.Sounds = {
    Swing = "rbxassetid://9120972444",
    LightHit = "rbxassetid://9113573976",
    MediumHit = "rbxassetid://9113574268",
    HeavyHit = "rbxassetid://9113573524",
    BlockedHit = "rbxassetid://3041192327",
    GuardBreak = "rbxassetid://314390675",
    Knockdown = "rbxassetid://121870043011805",
    Dash = "rbxassetid://120987650087629",
    DashStart = 0.035,
    ClinchGrab = "rbxassetid://131051744133255",
    ClinchGrabVolume = 0.9,
    DempseyRoll = "rbxassetid://74886557331045",
    DempseyRollVolume = 0.9,
    DempseyHit = "rbxassetid://91550126297493",
    DempseyHitVolume = 0.9,
    Miss = "rbxassetid://118012739001969",
    HitBass = 5,
    SwingDuck = 0.2,
    SwingVolume = 0.6,
    HitVolume = 1,
    Swings = {
        Jab = "rbxassetid://132453117712837",
        Cross = "rbxassetid://94510542258901",
        HookBody = "rbxassetid://76806731730251",
        HookHead = "rbxassetid://91781565739105",
        Uppercut = "rbxassetid://125679766292495"
    },
    Hits = {
        Jab = "rbxassetid://81300082069270",
        Cross = "rbxassetid://109841939740266",
        HookBody = "rbxassetid://73527674298327",
        HookHead = "rbxassetid://111640520462137",
        Uppercut = "rbxassetid://114297515697155"
    },
    HitStart = {
        Jab = 0.245,
        Cross = 0.05,
        HookBody = 0.042,
        HookHead = 0.05,
        Uppercut = 0.058
    }
}
t1.ExtraSounds = {
    GuardBreakPitch = 1,
    BloodyHitVolume = 2.5,
    BloodSpill = "rbxassetid://4459578169",
    BloodSpillVolume = 0.45,
    BreathIn = "rbxassetid://9056982730",
    BreathOut = "rbxassetid://9056984256",
    BreathVolume = 1,
    Hover = "rbxassetid://147982968",
    HoverVolume = 0.5,
    Dodge = "rbxassetid://6128977275",
    DodgeVolume = 1,
    Eat = "rbxassetid://4511723890",
    Drink = "rbxassetid://3583411622",
    EatVolume = 2,
    CorkscrewStart = "rbxassetid://8759525785",
    CorkscrewStartVolume = 1,
    CorkscrewHit = "rbxassetid://3763474273",
    CorkscrewHitVolume = 2.5,
    Outside = "rbxassetid://9118752742",
    OutsideVolume = 0.5,
    OutsideFade = 1.5,
    RoofCheckHeight = 150,
    BloodyHit = {
        Light = "rbxassetid://3739363791",
        Medium = "rbxassetid://4086189694",
        Heavy = "rbxassetid://4086190131"
    }
}
t1.World = {
    DayMinutes = 60,
    NightMinutes = 30,
    Sunrise = 6.5,
    Sunset = 17.75,
    StartClock = 10,
    Twilight = 1.1,
    UpdateEvery = 0.1,
    RainChance = 0.4,
    RainFade = 25,
    StartRaining = false,
    RainHeight = 95,
    StreakRate = 420,
    SplashRate = 110,
    FightRate = 0.4,
    IndoorCheck = 140,
    RainSound = "rbxassetid://121597382303951",
    RainVolume = 0.6,
    RainIndoorVolume = 0.22,
    Night = {
        Brightness = 1.1,
        EnvironmentDiffuseScale = 0.35,
        EnvironmentSpecularScale = 0.4,
        AtmosphereDensity = 0.34,
        AtmosphereHaze = 1.1,
        AtmosphereGlare = 0,
        SunRays = 0,
        Saturation = -0.08,
        Ambient = Color3.fromRGB(92, 100, 132),
        OutdoorAmbient = Color3.fromRGB(78, 88, 126),
        AtmosphereColor = Color3.fromRGB(96, 108, 142),
        AtmosphereDecay = Color3.fromRGB(46, 56, 92),
        Tint = Color3.fromRGB(210, 222, 255),
        CloudColor = Color3.fromRGB(70, 78, 104)
    },
    ClearMinutes = { 15, 35 },
    RainMinutes = { 5, 12 },
    Rain = {
        Brightness = 0.72,
        AmbientGrey = 0.25,
        AtmosphereDensity = 0.12,
        AtmosphereHaze = 0.8,
        CloudCover = 0.92,
        CloudDensity = 0.85,
        Saturation = -0.18,
        BrightnessShift = -0.03,
        AtmosphereColor = Color3.fromRGB(160, 166, 178),
        CloudColor = Color3.fromRGB(150, 155, 165)
    }
}
t1.Music = {
    Volume = 0.5,
    Fade = 2,
    RingsideRadius = 90,
    OnceMaxSeconds = 90,
    Lists = {
        Menu = { 75409770616978 },
        Day = { 78890228923213, 129665993980383, 119432709171841, 136965807871663, 83263160212903, 97485864529799, 120535652829181 },
        Night = { 133302062276412, 138696507850114, 85475177287986, 133002401826596, 72231624998784, 126292295615856 },
        Combat = { 118505464248763, 100965855630276, 78596001213409, 90574100906983, 121513540011955, 113978288309376, 132136119076588 },
        Losing = { 99051933443239, 112231509447082, 81562540995100, 138642052881724, 107873264231400, 70855015702749, 134474266900877 },
        Comeback = { 123201766697197, 124327249627542, 123787543650993, 80761818901582, 122929776837295, 77271648800702 },
        Ringside = { 97015116179946, 87013023176586, 114892047271651, 140610695644050 },
        RingsideStarting = { 80056636232346 },
        RankedVictory = { 80056636232346 },
        RankedLoss = { 105757450459211 }
    },
    Once = {
        RankedVictory = true,
        RankedLoss = true
    }
}
t1.StatLocks = {
    IconLocked = "rbxassetid://82747377585540",
    IconOpen = "rbxassetid://88751145334337"
}
t1.Footsteps = {
    Default = "Stone",
    Volume = 0.5,
    WalkInterval = 0.42,
    WalkSpeed = 16,
    MinInterval = 0.22,
    RollOffMax = 50,
    Sounds = {
        Brick = "rbxasset://sounds/grassstone3.ogg",
        Foil = "rbxasset://sounds/metal3.ogg",
        Grass = "rbxassetid://2229380697",
        Ice = "rbxasset://sounds/icestone.ogg",
        Metal = "rbxassetid://2218385587",
        Neon = "rbxassetid://4953173408",
        Pebble = "rbxassetid://133761546",
        Sand = "rbxassetid://227922350",
        Snow = "rbxassetid://19326880",
        Soft = "rbxassetid://133705377",
        Stone = "rbxassetid://6002128747",
        Water = "rbxassetid://6002132005",
        Wood = "rbxassetid://6002134937",
        WoodPlanks = "rbxassetid://698880433"
    },
    Materials = {
        Brick = "Brick",
        Foil = "Foil",
        Grass = "Grass",
        LeafyGrass = "Grass",
        Ground = "Grass",
        Mud = "Grass",
        Ice = "Ice",
        Glacier = "Ice",
        Metal = "Metal",
        DiamondPlate = "Metal",
        CorrodedMetal = "Metal",
        Neon = "Neon",
        Glass = "Neon",
        ForceField = "Neon",
        Pebble = "Pebble",
        Cobblestone = "Pebble",
        Salt = "Pebble",
        Sand = "Sand",
        Sandstone = "Sand",
        Snow = "Snow",
        Carpet = "Soft",
        Fabric = "Soft",
        Rubber = "Soft",
        Leather = "Soft",
        Cardboard = "Soft",
        Concrete = "Stone",
        Asphalt = "Stone",
        Pavement = "Stone",
        Slate = "Stone",
        Marble = "Stone",
        Granite = "Stone",
        Rock = "Stone",
        Basalt = "Stone",
        Limestone = "Stone",
        CeramicTiles = "Stone",
        Plaster = "Stone",
        ClayRoofTiles = "Stone",
        RoofShingles = "Stone",
        CrackedLava = "Stone",
        Water = "Water",
        Wood = "Wood",
        WoodPlanks = "WoodPlanks"
    }
}
t1.MissSoundTuning = {
    Vary = 0.04,
    Jammed = 0.6,
    Jab = {
        Speed = 1.15,
        Volume = 1.2
    },
    Cross = {
        Speed = 1.02,
        Volume = 1.25
    },
    HookHead = {
        Speed = 0.92,
        Volume = 1.25
    },
    HookBody = {
        Speed = 0.9,
        Volume = 1.25
    },
    Uppercut = {
        Speed = 0.86,
        Volume = 1.25
    }
}
t1.HitVFX = {
    Counter = nil,
    CounterScale = 1,
    Blocked = "LightHit_2",
    BlockedScale = 0.75,
    Knockdown = "BigHit_2",
    KnockdownScale = 1.4,
    TechniqueScale = 1,
    HeavyFlash = 0.85,
    KnockdownFlash = 0.45,
    Jab = {
        Body = "LightHit_1",
        Head = "LightHit_2"
    },
    Cross = {
        Body = "LightHit_1",
        Head = "LightHit_2"
    },
    Hook = {
        Body = "MediumHit_1",
        Head = "MediumHit_2"
    },
    Uppercut = {
        Body = "BigHit_1",
        Head = "BigHit_2"
    },
    ZoneColors = {
        Head = Color3.fromRGB(255, 50, 45),
        Body = Color3.fromRGB(60, 140, 255)
    },
    Techniques = {
        Smash = "SmashVFX",
        LowSmash = "SmashVFX",
        CorkscrewBlow = "CorkscrewVFX"
    },
    TechniqueColors = {
        Smash = Color3.fromRGB(255, 45, 40),
        LowSmash = Color3.fromRGB(255, 45, 40),
        CorkscrewBlow = Color3.fromRGB(255, 255, 255)
    },
    AirCut = {
        Light = 0,
        Medium = 0,
        Heavy = 0
    }
}
t1.TechniqueVFX = {
    CorkscrewBlow = {
        Anim = "rbxassetid://130072400506672",
        ArmSpin = {
            Arm = "Right",
            Degrees = 720,
            From = 0.88,
            To = 1.24
        },
        Activate = {
            Asset = "CorkscrewActivate",
            Height = 1.1,
            StreakSpeed = 1.4,
            FlashTime = 1,
            Fill = 0.35,
            LightRange = 14,
            LightBrightness = 6,
            Color = Color3.fromRGB(255, 255, 255),
            Tint = Color3.fromRGB(255, 255, 255)
        },
        Swirl = {
            Asset = "CorkscrewSwirl",
            From = 0.72,
            Until = 1.3,
            Arm = "Right",
            Scale = 0.75,
            Light = 6,
            Rates = {
                BlueSpiral = 45,
                GoldSpiral = 40,
                Streaks = 70
            },
            Colors = {
                BlueSpiral = Color3.fromRGB(235, 242, 255),
                GoldSpiral = Color3.fromRGB(255, 255, 255),
                Streaks = Color3.fromRGB(255, 255, 255)
            },
            LightColor = Color3.fromRGB(255, 255, 255),
            Boost = {
                GoldSpiral = {
                    Scale = 1.6,
                    LightEmission = 0.7
                },
                BlueSpiral = {
                    LightEmission = 0.3
                }
            }
        },
        Impact = {
            Scale = 2.4,
            BlockedScale = 1.2,
            ShockwaveScale = 0.6,
            FovKick = 5,
            Counts = {
                BlueSpiral = 10,
                GoldSpiral = 12,
                Streaks = 40,
                Ring = 5,
                Flare = 3,
                FlareStreaks = 45,
                GoldSparks = 24
            },
            Ball = {
                From = 1.2,
                To = 8,
                Time = 0.3,
                Transparency = 0.35,
                Color = Color3.fromRGB(255, 255, 255)
            },
            SparkColor = Color3.fromRGB(255, 255, 255),
            Light = {
                Range = 22,
                Brightness = 9,
                Time = 0.5,
                Color = Color3.fromRGB(255, 255, 255)
            },
            Tint = Color3.fromRGB(255, 255, 255)
        }
    },
    LiverBlow = {
        Anims = {
            ["rbxassetid://77763112594102"] = "Left",
            ["rbxassetid://104545547351000"] = "Right"
        },
        Swirl = {
            Asset = "CorkscrewSwirl",
            From = 0,
            Until = 0.32,
            Scale = 0.7,
            Extra = "LiverSparks",
            ExtraScale = 0.55,
            Light = 7,
            Rates = {
                BlueSpiral = 45,
                GoldSpiral = 40,
                Streaks = 80
            },
            Colors = {
                BlueSpiral = Color3.fromRGB(255, 205, 50),
                GoldSpiral = Color3.fromRGB(255, 248, 200),
                Streaks = Color3.fromRGB(255, 222, 90)
            },
            Boost = {
                GoldSpiral = {
                    Scale = 1.6,
                    LightEmission = 0.7
                },
                BlueSpiral = {
                    LightEmission = 0.4
                }
            },
            ExtraRates = {
                Motes = 120,
                Lightning = 30
            },
            LightColor = Color3.fromRGB(255, 210, 80)
        },
        Impact = {
            Style = "Boom",
            Scale = 1.4,
            BlockedScale = 0.7,
            Freeze = 0.09,
            Shake = 0.9,
            Flash = 0.55,
            FlashTime = 0.25,
            FovKick = 6,
            Counts = {
                Flash = 4,
                Inward = 1,
                Circles = 8,
                Crescents = 10,
                Swell = 12,
                Puffs = 26,
                Lines = 40,
                Rings = 5
            },
            Ball = {
                From = 3,
                To = 13,
                Time = 0.5,
                Delay = 0.05,
                Transparency = 0.62,
                Color = Color3.fromRGB(255, 218, 105),
                Material = Enum.Material.Neon
            },
            Shell = {
                From = 5,
                To = 22,
                Time = 0.7,
                Delay = 0.05,
                Transparency = 0,
                Color = Color3.fromRGB(255, 205, 60),
                Material = Enum.Material.ForceField
            },
            Light = {
                Range = 30,
                Brightness = 10,
                Time = 0.6,
                Color = Color3.fromRGB(255, 205, 90)
            }
        }
    },
    WhiteFang = {
        Anim = "rbxassetid://116552280797916",
        Swirl = {
            Asset = "CorkscrewSwirl",
            Scale = 0.7,
            Extra = "LiverSparks",
            ExtraScale = 0.55,
            Light = 7,
            Phases = {
                {
                    Arm = "Left",
                    From = 0,
                    Until = 0.42
                },
                {
                    Arm = "Right",
                    From = 0.31,
                    Until = 0.72
                }
            },
            Rates = {
                BlueSpiral = 45,
                GoldSpiral = 40,
                Streaks = 80
            },
            Colors = {
                BlueSpiral = Color3.fromRGB(140, 215, 255),
                GoldSpiral = Color3.fromRGB(255, 255, 255),
                Streaks = Color3.fromRGB(205, 240, 255)
            },
            Boost = {
                GoldSpiral = {
                    Scale = 1.6,
                    LightEmission = 0.7
                },
                BlueSpiral = {
                    LightEmission = 0.4
                }
            },
            ExtraRates = {
                Motes = 120,
                Lightning = 30
            },
            ExtraColors = {
                Motes = Color3.fromRGB(210, 240, 255),
                Lightning = Color3.fromRGB(160, 225, 255)
            },
            LightColor = Color3.fromRGB(170, 225, 255)
        },
        Impact = {
            Style = "Boom",
            Asset = "LiverBoom",
            Scale = 1.3,
            BlockedScale = 0.65,
            Freeze = 0.08,
            FreezeAfter = 0.08,
            Shake = 0.8,
            Flash = 0.6,
            FlashTime = 0.22,
            FovKick = 5,
            Colors = {
                Flash = Color3.fromRGB(240, 250, 255),
                Inward = Color3.fromRGB(240, 250, 255),
                Circles = Color3.fromRGB(150, 215, 255),
                Crescents = Color3.fromRGB(175, 228, 255),
                Swell = Color3.fromRGB(130, 205, 255),
                Puffs = Color3.fromRGB(235, 248, 255),
                Lines = Color3.fromRGB(190, 235, 255),
                Rings = Color3.fromRGB(160, 220, 255)
            },
            HitScales = { 1, 1.2 },
            Counts = {
                Flash = 4,
                Inward = 1,
                Circles = 8,
                Crescents = 10,
                Swell = 12,
                Puffs = 26,
                Lines = 40,
                Rings = 5
            },
            Ball = {
                From = 3,
                To = 12,
                Time = 0.45,
                Delay = 0.05,
                Transparency = 0.62,
                Color = Color3.fromRGB(205, 238, 255),
                Material = Enum.Material.Neon
            },
            Shell = {
                From = 4.5,
                To = 20,
                Time = 0.6,
                Delay = 0.05,
                Transparency = 0,
                Color = Color3.fromRGB(150, 215, 255),
                Material = Enum.Material.ForceField
            },
            Light = {
                Range = 28,
                Brightness = 9,
                Time = 0.5,
                Color = Color3.fromRGB(175, 225, 255)
            }
        }
    },
    GazellePunch = {
        Anim = "rbxassetid://99910143081906",
        Swirl = {
            Asset = "CorkscrewSwirl",
            Scale = 0.75,
            Arm = "Left",
            From = 0,
            Until = 0.5,
            Extra = "LiverSparks",
            ExtraScale = 0.55,
            Light = 7,
            Rates = {
                BlueSpiral = 45,
                GoldSpiral = 40,
                Streaks = 80
            },
            Colors = {
                BlueSpiral = Color3.fromRGB(255, 150, 40),
                GoldSpiral = Color3.fromRGB(255, 246, 228),
                Streaks = Color3.fromRGB(255, 190, 90)
            },
            Boost = {
                GoldSpiral = {
                    Scale = 1.6,
                    LightEmission = 0.7
                },
                BlueSpiral = {
                    LightEmission = 0.4
                }
            },
            ExtraRates = {
                Motes = 120,
                Lightning = 30
            },
            ExtraColors = {
                Motes = Color3.fromRGB(255, 205, 130),
                Lightning = Color3.fromRGB(255, 170, 60)
            },
            LightColor = Color3.fromRGB(255, 170, 80)
        },
        DashLines = {
            Asset = "GazelleDashLines",
            From = 0,
            Until = 0.32,
            Size = Vector3.new(2.2, 4.4, 0.6),
            Rates = {
                Lines = 150,
                Strands = 110
            }
        },
        Impact = {
            Style = "Boom",
            Asset = "LiverBoom",
            Scale = 1.55,
            BlockedScale = 0.78,
            Freeze = 0.09,
            FreezeAfter = 0.08,
            Shake = 1,
            Flash = 0.5,
            FlashTime = 0.25,
            FovKick = 6,
            Colors = {
                Flash = Color3.fromRGB(255, 246, 228),
                Inward = Color3.fromRGB(255, 240, 215),
                Circles = Color3.fromRGB(255, 160, 50),
                Crescents = Color3.fromRGB(255, 236, 212),
                Swell = Color3.fromRGB(255, 150, 40),
                Puffs = Color3.fromRGB(255, 236, 212),
                Lines = Color3.fromRGB(255, 185, 80),
                Rings = Color3.fromRGB(255, 170, 70)
            },
            Counts = {
                Flash = 4,
                Inward = 1,
                Circles = 8,
                Crescents = 16,
                Swell = 12,
                Puffs = 30,
                Lines = 44,
                Rings = 6
            },
            Ball = {
                From = 3.2,
                To = 14,
                Time = 0.5,
                Delay = 0.05,
                Transparency = 0.6,
                Color = Color3.fromRGB(255, 226, 180),
                Material = Enum.Material.Neon
            },
            Shell = {
                From = 5,
                To = 23,
                Time = 0.7,
                Delay = 0.05,
                Transparency = 0,
                Color = Color3.fromRGB(255, 160, 60),
                Material = Enum.Material.ForceField
            },
            Light = {
                Range = 30,
                Brightness = 10,
                Time = 0.6,
                Color = Color3.fromRGB(255, 175, 90)
            }
        }
    }
}

local function studioSwirl(p32, p33, p34, p35, p36) -- line: 1688
    return {
        Asset = "CorkscrewSwirl",
        Scale = 0.7,
        From = 0,
        Light = 7,
        Arm = p32,
        Until = p33,
        Rates = {
            BlueSpiral = 45,
            GoldSpiral = 40,
            Streaks = 80
        },
        Colors = {
            BlueSpiral = p34,
            GoldSpiral = p35,
            Streaks = p36
        },
        Boost = {
            GoldSpiral = {
                Scale = 1.6,
                LightEmission = 0.7
            },
            BlueSpiral = {
                LightEmission = 0.4
            }
        },
        LightColor = p34
    }
end

local function studioBoom(p37, p38, p39) -- line: 1697
    return {
        Style = "Boom",
        Asset = "SparkBoom",
        Freeze = 0.08,
        FreezeAfter = 0.07,
        Shake = 0.85,
        Flash = 0.6,
        FlashTime = 0.22,
        FovKick = 5,
        Colors = {
            Flash = p39,
            Lines = p38,
            Puffs = p39,
            Swell = p38
        },
        Scale = p37,
        BlockedScale = p37 / 2,
        Ball = {
            From = 2.5,
            To = 11,
            Time = 0.45,
            Delay = 0.04,
            Transparency = 0.62,
            Color = p39,
            Material = Enum.Material.Neon
        },
        Shell = {
            From = 4,
            To = 18,
            Time = 0.6,
            Delay = 0.04,
            Transparency = 0,
            Color = p38,
            Material = Enum.Material.ForceField
        },
        Light = {
            Range = 26,
            Brightness = 8,
            Time = 0.5,
            Color = p38
        }
    }
end

local v74 = Color3.fromRGB(40, 230, 160)
local v75 = Color3.fromRGB(210, 255, 236)
local v76 = Color3.fromRGB(255, 196, 50)
local v77 = Color3.fromRGB(255, 248, 215)
local v78 = Color3.fromRGB(255, 120, 35)
local v79 = Color3.fromRGB(255, 226, 190)
local v80 = Color3.fromRGB(165, 90, 255)
local v81 = Color3.fromRGB(232, 212, 255)

t1.TechniqueVFX.DragonFishBlow = {
    Anim = "rbxassetid://120017830245349",
    Swirl = studioSwirl("Right", 0.45, v74, v75, Color3.fromRGB(120, 255, 200)),
    Impact = studioBoom(1.45, v74, v75)
}
t1.TechniqueVFX.CrossCounter = {
    Anims = {
        ["rbxassetid://86724968844668"] = "Right",
        ["rbxassetid://129500150927164"] = "Right"
    },
    Swirl = studioSwirl(nil, 0.45, v76, v77, Color3.fromRGB(255, 222, 110)),
    Impact = studioBoom(1.6, v76, v77)
}
t1.TechniqueVFX.SwingCounter = {
    Impact = studioBoom(1.5, v76, v77)
}
t1.TechniqueVFX.OverhandRight = {
    Anim = "rbxassetid://113680467731340",
    Swirl = studioSwirl("Right", 0.55, v78, v79, Color3.fromRGB(255, 175, 90)),
    Impact = studioBoom(1.4, v78, v79)
}
t1.TechniqueVFX.FullBodyUppercut = {
    Anim = "rbxassetid://80149519752250",
    Swirl = studioSwirl("Right", 0.55, v80, v81, Color3.fromRGB(200, 150, 255)),
    Impact = studioBoom(1.5, v80, v81)
}

local v82 = Color3.fromRGB(255, 45, 40)
local v83 = Color3.fromRGB(200, 15, 20)
local v84 = Color3.fromRGB(255, 190, 180)

local function redSwirl(p40, p41) -- line: 1749
    -- upvalues: v82 (copy), v84 (copy)
    return {
        Asset = "CorkscrewSwirl",
        Scale = 0.75,
        Arm = "Left",
        Extra = "LiverSparks",
        ExtraScale = 0.55,
        Light = 7,
        From = p40,
        Until = p41,
        Rates = {
            BlueSpiral = 45,
            GoldSpiral = 40,
            Streaks = 80
        },
        Colors = {
            BlueSpiral = v82,
            GoldSpiral = v84,
            Streaks = Color3.fromRGB(255, 90, 70)
        },
        Boost = {
            GoldSpiral = {
                Scale = 1.6,
                LightEmission = 0.7
            },
            BlueSpiral = {
                LightEmission = 0.4
            }
        },
        ExtraRates = {
            Motes = 120,
            Lightning = 30
        },
        ExtraColors = {
            Motes = Color3.fromRGB(255, 120, 100),
            Lightning = Color3.fromRGB(255, 60, 50)
        },
        LightColor = Color3.fromRGB(255, 70, 60)
    }
end

local function redImpact(p42) -- line: 1760
    -- upvalues: v82 (copy), v83 (copy)
    return {
        Style = "Boom",
        Asset = "LiverBoom",
        Freeze = 0.09,
        FreezeAfter = 0.08,
        Shake = 0.95,
        Flash = 0.55,
        FlashTime = 0.25,
        FovKick = 6,
        Colors = {
            Flash = Color3.fromRGB(255, 225, 215),
            Inward = Color3.fromRGB(255, 215, 205),
            Circles = v82,
            Crescents = Color3.fromRGB(255, 120, 105),
            Swell = v83,
            Puffs = Color3.fromRGB(255, 200, 190),
            Lines = Color3.fromRGB(255, 80, 65),
            Rings = v82
        },
        Scale = p42,
        BlockedScale = p42 / 2,
        Counts = {
            Flash = 4,
            Inward = 1,
            Circles = 8,
            Crescents = 12,
            Swell = 12,
            Puffs = 26,
            Lines = 40,
            Rings = 5
        },
        Ball = {
            From = 3,
            To = 13,
            Time = 0.5,
            Delay = 0.05,
            Transparency = 0.6,
            Color = Color3.fromRGB(255, 140, 125),
            Material = Enum.Material.Neon
        },
        Shell = {
            From = 5,
            To = 22,
            Time = 0.7,
            Delay = 0.05,
            Transparency = 0,
            Color = v82,
            Material = Enum.Material.ForceField
        },
        Light = {
            Range = 28,
            Brightness = 9,
            Time = 0.55,
            Color = Color3.fromRGB(255, 70, 60)
        }
    }
end

t1.TechniqueVFX.Smash = {
    Anim = "rbxassetid://100898543082436",
    Swirl = redSwirl(0, 0.6),
    Impact = redImpact(1.45)
}
t1.TechniqueVFX.LowSmash = {
    Anim = "rbxassetid://98300861321176",
    Swirl = redSwirl(0, 0.6),
    DashLines = {
        Asset = "GazelleDashLines",
        From = 0.14,
        Until = 0.4,
        Size = Vector3.new(2.2, 4.4, 0.6),
        Rates = {
            Lines = 150,
            Strands = 110
        }
    },
    Impact = redImpact(1.6)
}

local v85 = Color3.fromRGB(255, 185, 45)
local v86 = Color3.fromRGB(255, 240, 200)

t1.TechniqueVFX.DempseyRoll = {
    Anims = {
        ["rbxassetid://86897243375562"] = "Both",
        ["rbxassetid://86300186634892"] = "Both"
    },
    GloveAura = {
        Assets = {
            {
                Asset = "CorkscrewSwirl",
                Scale = 0.55,
                Rates = {
                    BlueSpiral = 30,
                    GoldSpiral = 25,
                    Streaks = 40
                },
                Colors = {
                    BlueSpiral = v85,
                    GoldSpiral = v86,
                    Streaks = Color3.fromRGB(255, 205, 100)
                }
            },
            {
                Asset = "LiverSparks",
                Scale = 0.5,
                Rates = {
                    Motes = 80,
                    Lightning = 20
                },
                Colors = {
                    Motes = Color3.fromRGB(255, 215, 130),
                    Lightning = v85
                }
            }
        }
    },
    Afterimages = {
        Every = 0.06,
        Start = 0.4,
        Life = 0.28,
        Color = Color3.fromRGB(255, 200, 90)
    },
    Impact = {
        Style = "Boom",
        Asset = "LiverBoom",
        Scale = 0.9,
        BlockedScale = 0.5,
        Freeze = 0,
        Shake = 0.35,
        Flash = 1,
        FovKick = 0,
        Colors = {
            Flash = v86,
            Inward = v86,
            Circles = v85,
            Crescents = Color3.fromRGB(255, 225, 150),
            Swell = v85,
            Puffs = v86,
            Lines = Color3.fromRGB(255, 200, 80),
            Rings = v85
        },
        Counts = {
            Flash = 2,
            Inward = 1,
            Circles = 4,
            Crescents = 6,
            Swell = 6,
            Puffs = 14,
            Lines = 22,
            Rings = 3
        },
        Ball = {
            From = 2,
            To = 7,
            Time = 0.35,
            Delay = 0.03,
            Transparency = 0.65,
            Color = Color3.fromRGB(255, 225, 150),
            Material = Enum.Material.Neon
        },
        Shell = {
            From = 3,
            To = 11,
            Time = 0.45,
            Delay = 0.03,
            Transparency = 0,
            Color = v85,
            Material = Enum.Material.ForceField
        },
        Light = {
            Range = 18,
            Brightness = 6,
            Time = 0.35,
            Color = Color3.fromRGB(255, 190, 80)
        }
    }
}
t1.Impact = {
    HitStopBlocked = 0.5,
    HitStopCounter = 1.35,
    HitStopKnockdown = 0.1,
    HitStopBag = 0.6,
    JoltTaken = 1.35,
    JoltThrown = 0.6,
    HeavyZoom = -3,
    ContactStyle = "Vortex",
    ImpactFrame = true,
    HitStop = {
        Jab = 0.02,
        Cross = 0.045,
        Hook = 0.065,
        Uppercut = 0.08
    },
    Snap = {
        Split = 0.55,
        Windup = 0.786,
        Drive = 1.5
    },
    Tier = {
        Jab = 1,
        Cross = 2,
        Hook = 3,
        Uppercut = 3
    },
    Jolt = {
        Jab = 0.1,
        Cross = 0.2,
        Hook = 0.26,
        Uppercut = 0.28
    },
    Crack = {
        Id = "rbxassetid://139560115031437",
        Start = 0.08,
        Length = 0.12,
        Speed = {
            Jab = 1.7,
            Cross = 1.6,
            HookHead = 1.5,
            HookBody = 1.45,
            Uppercut = 1.45
        },
        Volume = {
            Jab = 0.22,
            Cross = 0.28,
            HookHead = 0.3,
            HookBody = 0.26,
            Uppercut = 0.32
        }
    },
    SoftSize = {
        Jab = 1.6,
        Cross = 2.15,
        Hook = 2.25,
        Uppercut = 2.4
    },
    Textures = {
        swirl = "rbxassetid://139234940317644",
        crescent = "rbxassetid://98811387004678",
        burst = "rbxassetid://114197054027732",
        wisps = "rbxassetid://129149879261287"
    }
}
t1.Knockdown = {
    PressDecayPerSecond = 2.5,
    PressStaminaCost = 4,
    MinPressStrength = 1,
    DownedStaminaRegen = 6,
    CountSeconds = 10,
    CountTo = 10,
    MaxOverkill = 0.5,
    GetUpAtHealth = 0.05,
    HealPerSecond = 0.03,
    PotentialRegenMultiplier = 1.2,
    HealCap = 0.75,
    HealSlowdownAt = 0.25,
    HealSlowdownMultiplier = 0.75,
    HealIntoPotential = true,
    KnockoutStayDown = 5,
    GetUpInvulnerability = 1.5,
    DummyGetUpTime = 4,
    DummyGetUpHealthFraction = 1,
    LaunchMultiplier = 1.4,
    LaunchUp = 4,
    GetUpKey = Enum.KeyCode.Space,
    Severity = {
        Light = {
            StunTime = 1,
            Presses = 8
        },
        Heavy = {
            StunTime = 2.5,
            Presses = 8
        }
    },
    LightFinishers = {
        Jab = {
            Head = true,
            Body = true
        },
        LeftHook = {
            Body = true
        },
        RightHook = {
            Body = true
        }
    },
    CantFinishWith = {
        Jab = true
    },
    FlurryFinish = {
        Count = 3,
        Window = 1.5
    },
    TimeDown = {
        HealthPerSecond = 0.035,
        HealthCap = 0.85,
        StaminaBase = 0.4,
        StaminaPerSecond = 0.05,
        StaminaMax = 0.9
    },
    Animations = {
        RiseWithPresses = 0.55,
        Fall = {
            Forward = "rbxassetid://128258769473678",
            Backward = "rbxassetid://93863714390139",
            Left = "rbxassetid://109514951527019",
            Right = "rbxassetid://80517498454200"
        },
        Loop = {
            Forward = "rbxassetid://108543040151905",
            Backward = "rbxassetid://119503340992866",
            Left = "rbxassetid://85992807608737",
            Right = "rbxassetid://139568423926264"
        },
        ByPunch = {
            Jab = "Backward",
            Cross = "Backward",
            LeftHook = "Right",
            RightHook = "Left",
            LeftUppercut = "Forward",
            RightUppercut = "Forward"
        }
    },
    Balance = {
        OverkillSeconds = 2,
        RepeatSeconds = 0.6,
        OutDrainPerSecond = 0.35,
        Zone = 0.22,
        ZoneShrinkPerKnockdown = 0.03,
        Drift = 0.9,
        DriftPerKnockdown = 0.25,
        Push = 2.6,
        Gravity = 1.1,
        ReportRate = 10,
        PushCost = 4.8,
        PushCostGrowth = 1.2,
        LeftKey = Enum.KeyCode.A,
        RightKey = Enum.KeyCode.D,
        Seconds = {
            Light = 1.8,
            Heavy = 2.8
        }
    },
    Recovery = {
        UseHealthGate = false,
        MinGetUpHealth = 0.15,
        GetUpProtection = 0.6,
        StandUpFade = 0.8,
        MemorySeconds = 240,
        OverkillWeight = 0.2,
        HeavyWeight = 0.05,
        StaminaWeight = 0.15,
        RecentSeconds = 45,
        RecentWeight = 0.15,
        CourageCutPerPoint = 0.03,
        CourageMaxCut = 0.3,
        MaxDifficulty = 0.97,
        RiseDriftBoost = 0.6,
        ReportRate = 10,
        RiseKeys = {
            Enum.KeyCode.Space,
            Enum.KeyCode.W,
            Enum.KeyCode.Up
        },
        LeftKeys = {
            Enum.KeyCode.A,
            Enum.KeyCode.Left
        },
        RightKeys = {
            Enum.KeyCode.D,
            Enum.KeyCode.Right
        },
        ByKnockdown = { 0.12, 0.42, 0.7, 0.93 },
        Easy = {
            Zone = 0.33,
            Drift = 0.48,
            Gravity = 0.6,
            Push = 3.3,
            FocusSeconds = 1.1,
            RiseSeconds = 1.2,
            Slip = 0.4,
            Sink = 0.22,
            LoseFocus = 1.35,
            RecoverSeconds = 2.5,
            WalkSlow = 0.45,
            PunchSlow = 0.35,
            PunchLock = 0.5
        },
        Hard = {
            Zone = 0.09,
            Drift = 2.25,
            Gravity = 2.25,
            Push = 2.6,
            FocusSeconds = 4,
            RiseSeconds = 3.4,
            Slip = 1.4,
            Sink = 0.55,
            LoseFocus = 0.55,
            RecoverSeconds = 6,
            WalkSlow = 0.7,
            PunchSlow = 0.6,
            PunchLock = 1.1
        },
        Effects = {
            FallSeconds = 0.85,
            Flash = 0.15,
            ImpactShake = 2.2,
            FOVKick = 18,
            FOVTunnel = -12,
            Blur = 18,
            Saturation = -0.8,
            Contrast = 0.2,
            Brightness = -0.06,
            Vignette = 0.85,
            Wobble = 9,
            Tilt = 16,
            LookUp = 16,
            MuffleHigh = -42,
            MuffleMid = -18,
            ImpactSound = "rbxassetid://121870043011805",
            ImpactPitch = 0.75,
            ImpactVolume = 1.4,
            CrowdSound = "",
            CrowdVolume = 0.5,
            RingingSound = "",
            RingingVolume = 0.35,
            RecoverStrength = 0.55,
            KOFade = 2.5,
            Tint = Color3.fromRGB(255, 226, 222),
            LookRange = Vector2.new(40, 22)
        }
    },
    Stumble = {
        PlayFraction = 0.45,
        Speed = 1.3,
        StunTime = 0.9,
        CenterWidth = 0.25
    }
}

function t1.RecoveryParams(p43) -- line: 2044
    -- upvalues: t1 (copy)
    local Recovery = t1.Knockdown.Recovery
    local v88 = math.clamp(tonumber(p43) or 0, 0, 1)
    local t11 = {}

    for v89, v90 in Recovery.Easy do
        t11[v89] = v90 + ((Recovery.Hard[v89] or v90) - v90) * v88
    end

    return t11
end

t1.Dash = {
    StartSpeed = 62,
    EndSpeed = 16,
    Duration = 0.28,
    Cooldown = 0.8,
    StaminaCost = 12,
    RequiresGloves = false,
    LegScale = 1,
    Key = Enum.KeyCode.Q,
    Animations = {
        Forward = "rbxassetid://73364481153533",
        Back = "rbxassetid://87158075190405",
        Left = "rbxassetid://100668259601255",
        Right = "rbxassetid://102259347386113"
    },
    Types = {
        OutboxerDash = {
            StartSpeed = 75,
            Duration = 0.24,
            LegScale = 2,
            Cooldown = 0.8,
            StaminaCost = 12,
            Effect = "Minimal",
            Animations = {
                Forward = "rbxassetid://93756350345127",
                Right = "rbxassetid://132112940938440",
                Left = "rbxassetid://98547565737161",
                Back = "rbxassetid://102392907581736"
            }
        },
        InfighterDash = {
            StartSpeed = 50,
            Duration = 0.3,
            LegScale = 1,
            Cooldown = 1,
            StaminaCost = 20,
            IFrames = 0.15,
            BackAnimation = "Forward",
            Animations = {
                Forward = "rbxassetid://130453156679648",
                Left = "rbxassetid://98001434709576",
                Right = "rbxassetid://122678369378099"
            },
            LowStamina = {
                Below = 0.25,
                SpeedMultiplier = 0.65,
                IFrames = 0.05
            }
        }
    }
}

local t12 = {}

function t1.DashSettings(p44) -- line: 2111
    -- upvalues: t1 (copy), t12 (copy)
    local v91 = p44 or ""

    if t12[v91] then
        return t12[v91]
    end

    local Dash = t1.Dash
    local t13 = {}

    for v92, v93 in Dash do
        if v92 ~= "Types" then
            t13[v92] = v93
        end
    end

    for v94, v95 in p44 and Dash.Types[p44] or {} do
        t13[v94] = v95
    end

    t12[v91] = t13

    return t13
end

function t1.DashAnimationIds() -- line: 2131
    -- upvalues: t1 (copy)
    local t14 = {}

    for _, v96 in t1.Dash.Animations do
        table.insert(t14, v96)
    end

    for _, v97 in t1.Dash.Types do
        for _, v98 in v97.Animations or {} do
            table.insert(t14, v98)
        end
    end

    return t14
end

t1.Sparring = {
    Range = 4,
    AttackDelayMin = 0.9,
    AttackDelayMax = 1.6,
    Punches = { "Jab", "Jab", "Cross", "LeftHook", "RightHook", "LeftUppercut", "RightUppercut" }
}
t1.Weights = {
    Light = {
        RingSize = 2.2,
        Sparks = 8,
        Shake = 0.25,
        Sound = "LightHit",
        Volume = 0.6,
        SwingPitch = 1.25,
        HitStop = 0,
        HitStun = 0.35
    },
    Medium = {
        RingSize = 3,
        Sparks = 12,
        Shake = 0.4,
        Sound = "MediumHit",
        Volume = 0.75,
        SwingPitch = 1.05,
        HitStop = 0.03,
        HitStun = 0.45
    },
    Heavy = {
        RingSize = 4.2,
        Sparks = 18,
        Shake = 0.65,
        Sound = "HeavyHit",
        Volume = 0.9,
        SwingPitch = 0.9,
        HitStop = 0.07,
        HitStun = 0.6
    }
}
t1.Atm = {
    DailyCap = 1E+06,
    Min = 100,
    Max = 1E+06,
    Range = 10,
    Cooldown = 3
}
t1.BodyShotTaken = 0.85
t1.Punches = {
    Jab = {
        Side = "Left",
        Anim = "Jab",
        Weight = "Light",
        Damage = 9,
        Cooldown = 0.29,
        HitTime = 0.1,
        Jammable = true,
        StaminaCost = 4.6,
        GuardDamage = 14,
        HitboxSize = Vector3.new(1.8, 2.6, 2.8),
        HitboxOffset = Vector3.new(-0.2, 0.7, -2.6),
        Knockback = Vector3.new(0, 0, -3.825),
        ContactBonus = 0.12
    },
    Cross = {
        Side = "Right",
        Anim = "Cross",
        Weight = "Medium",
        Damage = 13,
        Cooldown = 0.41,
        HitTime = 0.15,
        Jammable = true,
        StaminaCost = 7,
        GuardDamage = 21,
        HitboxSize = Vector3.new(1.8, 2.6, 2.6),
        HitboxOffset = Vector3.new(0.5, 0.7, -2.5),
        Knockback = Vector3.new(0, 0, -10.5)
    },
    LeftHook = {
        Side = "Left",
        Anim = "Hook",
        Weight = "Heavy",
        Damage = 10,
        Cooldown = 0.57,
        HitTime = 0.23,
        HitStun = 0.38,
        MaxStun = 0.45,
        StaminaCost = 10.4,
        GuardDamage = 25,
        HitboxSize = Vector3.new(3.2, 2.6, 2),
        HitboxOffset = Vector3.new(0, 0.3, -2),
        Knockback = Vector3.new(2, 0, -0.75),
        ZoneDamage = {
            Head = 8,
            Body = 9
        }
    },
    RightHook = {
        Side = "Right",
        Anim = "Hook",
        Weight = "Heavy",
        Damage = 10,
        Cooldown = 0.57,
        HitTime = 0.23,
        HitStun = 0.38,
        MaxStun = 0.45,
        StaminaCost = 10.4,
        GuardDamage = 25,
        HitboxSize = Vector3.new(3.2, 2.6, 2),
        HitboxOffset = Vector3.new(0, 0.3, -2),
        Knockback = Vector3.new(-2, 0, -0.75),
        ZoneDamage = {
            Head = 8,
            Body = 9
        }
    },
    LeftUppercut = {
        Side = "Left",
        Anim = "Uppercut",
        Weight = "Heavy",
        Damage = 13.6,
        Cooldown = 0.52,
        HitTime = 0.27,
        StaminaCost = 13,
        GuardDamage = 30,
        HitboxSize = Vector3.new(1.8, 2.8, 2.2),
        HitboxOffset = Vector3.new(-0.3, 1.2, -1.9),
        Knockback = Vector3.new(0, 0, -8.625),
        Reach = {
            Head = 1.11,
            Body = 0.93
        }
    },
    RightUppercut = {
        Side = "Right",
        Anim = "Uppercut",
        Weight = "Heavy",
        Damage = 13.6,
        Cooldown = 0.52,
        HitTime = 0.27,
        StaminaCost = 13,
        GuardDamage = 30,
        HitboxSize = Vector3.new(1.8, 2.8, 2.2),
        HitboxOffset = Vector3.new(0.5, 1.2, -1.9),
        Knockback = Vector3.new(0, 0, -8.625),
        Reach = {
            Head = 1.22,
            Body = 1.05
        }
    }
}

function t1.OpponentDistanceInFront(p45) -- line: 2233
    -- upvalues: CollectionService (copy), Players (copy)
    local HumanoidRootPart = p45:FindFirstChild("HumanoidRootPart")

    if not HumanoidRootPart then
        return 1e999
    end

    local BoxingDummy = CollectionService:GetTagged("BoxingDummy")

    for _, player in Players:GetPlayers() do
        if player.Character then
            table.insert(BoxingDummy, player.Character)
        end
    end

    local n1 = 1e999

    for _, v99 in BoxingDummy do
        local v100 = v99 ~= p45 and v99:FindFirstChild("HumanoidRootPart")
        local v101 = v100 and v99:FindFirstChildOfClass("Humanoid")

        if v101 and v101.Health > 0 and not v99:GetAttribute("Downed") then
            local v102 = (v100.Position - HumanoidRootPart.Position) * Vector3.new(1, 0, 1)

            if v102:Dot(HumanoidRootPart.CFrame.LookVector) > 0 then
                n1 = math.min(n1, v102.Magnitude)
            end
        end
    end

    return n1
end

function t1.IsJammed(p46, p47) -- line: 2259
    -- upvalues: t1 (copy)
    local v103 = t1.Punches[p47]

    if v103 ~= nil and v103.Jammable == true then
        return t1.OpponentDistanceInFront(p46) < t1.JamRange
    end

    return false
end

function t1.PunchZone(p48, p49) -- line: 2266
    -- upvalues: t1 (copy)
    local v104 = t1.Punches[p48]
    local v105 = v104 and v104.Zones

    if v105 then
        if table.find(v105, p49) then
            return p49
        end

        return v105[1]
    end

    if p49 == "Head" then
        return "Head"
    end

    return "Body"
end

function t1.KnockdownSeverity(p50, p51) -- line: 2276
    -- upvalues: t1 (copy)
    local v106 = t1.Knockdown.LightFinishers[p50]

    if not (v106 and v106[p51]) then
        return "Heavy"
    end

    return "Light"
end

t1.StatEffects = {
    ArmDamagePerPoint = 0.06,
    LegUppercutDamagePerPoint = 0.03,
    LegAllDamagePerPoint = 0.02,
    LegTechniquePerPoint = 0.03,
    ArmLegTechniquePerPoint = 0.002,
    LegDashSpeedPerPoint = 0.03,
    PunchSpeedPerPoint = 0.045,
    FootworkWalkPerPoint = 0.5,
    FootworkWalkCap = 10,
    FootworkSlowResistMax = 0.6,
    FootworkStunResistMax = 0.4,
    FootworkWeaveStartupPerPoint = 0.012,
    FootworkWeaveSpeedPerPoint = 0.1,
    SharpnessStunPerPoint = 0.15,
    SharpnessDamagePerPoint = 0.05,
    SharpnessGuardDamagePerPoint = 0.03,
    SharpnessInjuryPerPoint = 0.03,
    SkillMasteryCooldownPerPoint = 0.03,
    SkillMasteryMinCooldown = 0.7,
    SkillMasteryDamagePerPoint = 0.015,
    SkillMasteryStunPerPoint = 0.02,
    DrainPerPoint = 0.03,
    FatigueDrainPerPoint = 0.01,
    MinStaminaCostMultiplier = 0.5,
    GuardPerPoint = 0.15,
    GuardRegenPerPoint = 0.08,
    FatigueLowRegenPerPoint = 0.03,
    FatigueLowRegenBelow = 0.3,
    TorsoHealthPerPoint = 0.08,
    BaseMaxHealth = 200
}
t1.Training = {
    GainBase = 0.035,
    GainFalloff = 0.4,
    GainFloor = 0.25,
    StaminaCostBase = 28,
    StaminaCostSkill = 0.55,
    StaminaCostBest = 0.8,
    StaminaCostWorst = 1.2,
    SweepTimeSlow = 2.6,
    SweepTimeFast = 1.1,
    TickSound = "rbxassetid://408524543",
    ReleaseTickSpeed = 1.5,
    TickVolume = 4,
    MissStaminaFraction = 0.5,
    MinRepTime = 0.3,
    Rhythm = {
        Start = 1,
        Max = 1.3,
        Min = 0.8,
        Perfect = 0.06,
        Good = 0.04,
        Bad = -0.06,
        Miss = -0.12
    },
    HoldZoneWidth = { 0.22, 0.34 },
    Ratings = {
        {
            Min = 0.9,
            Text = "Crushing It!",
            Color = Color3.fromRGB(90, 255, 120)
        },
        {
            Min = 0.78,
            Text = "Pretty Good",
            Color = Color3.fromRGB(170, 255, 90)
        },
        {
            Min = 0.64,
            Text = "Doing Decent",
            Color = Color3.fromRGB(255, 240, 90)
        },
        {
            Min = 0.48,
            Text = "Hanging In There",
            Color = Color3.fromRGB(255, 225, 120)
        },
        {
            Min = -1,
            Text = "Struggling",
            Color = Color3.fromRGB(255, 150, 60)
        }
    },
    Grades = {
        {
            Max = 0.03,
            Text = "Perfect",
            Color = Color3.fromRGB(255, 240, 90)
        },
        {
            Max = 0.08,
            Text = "Great",
            Color = Color3.fromRGB(110, 235, 90)
        },
        {
            Max = 0.16,
            Text = "Good",
            Color = Color3.fromRGB(170, 230, 90)
        },
        {
            Max = 0.3,
            Text = "Okay",
            Color = Color3.fromRGB(255, 70, 50)
        },
        {
            Max = 1e999,
            Text = "Bad",
            Color = Color3.fromRGB(200, 40, 40)
        }
    },
    Stations = {
        Benches = {
            Gain = "Bench",
            Stat = "Power",
            Sub = 1,
            Animation = "rbxassetid://131769405213938",
            Weight = "Barbell",
            Mode = "Hold",
            SweepScale = 1.6,
            BarScale = 1.3
        },
        ["Bicep Curls"] = {
            Gain = "Curls",
            Stat = "Power",
            Sub = 1,
            Animation = "rbxassetid://118261695894805",
            Weight = "Dumbbells",
            Mode = "Tap",
            SweepScale = 1.25
        },
        ["Squat Racks"] = {
            Gain = "Squats",
            Stat = "Power",
            Sub = 2,
            Animation = "rbxassetid://85601150898544",
            Weight = "Barbell",
            Mode = "Hold",
            SweepScale = 1.6
        },
        AbCrunches = {
            Gain = "AbCrunches",
            Stat = "Endurance",
            Sub = 2,
            Animation = "rbxassetid://117741940405848",
            Mode = "Hold",
            SweepScale = 1.725
        },
        JumpRope = {
            Gain = "JumpRope",
            Stat = "Speed",
            Sub = 2,
            Animation = "rbxassetid://138156613350824",
            Weight = "JumpRope",
            Mode = "Tap",
            SweepScale = 0.714,
            Rhythm = {
                Start = 0.7,
                Max = 2.5,
                Gain = 2.2
            }
        },
        ["Speed bag"] = {
            Gain = "SpeedBag",
            Stat = "Speed",
            Sub = 1,
            Procedural = "SpeedBag",
            NeedsGloves = true,
            Mode = "Tap",
            Rhythm = {
                Start = 1,
                Max = 2.5,
                Perfect = 0.22,
                Good = 0.03
            }
        }
    }
}
t1.LowStamina = {
    Threshold = 0.15,
    PunchSlow = 1.5,
    TrainingSlow = 1.5
}

function t1.LowStaminaMultiplier(p52, p53) -- line: 2386
    -- upvalues: t1 (copy)
    local LowStamina = t1.LowStamina
    local Stamina = p52 and p52:GetAttribute("Stamina")

    return LowStamina and Stamina and Stamina < t1.MaxStamina(p52) * LowStamina.Threshold and LowStamina[p53] or 1
end

t1.FatigueState = {
    LowThreshold = 0.2,
    LowSecondsToFatigue = 8,
    Empties = 3,
    EmptyWindow = 45,
    MinDuration = 20,
    RecoverAbove = 0.75,
    RegenMultiplier = 0.7,
    WalkMultiplier = 0.8,
    ResistancePerPoint = 0.1
}
t1.UserVFX = {
    PunchStyle = "Smear",
    UseOldPunchLines = false,
    Sweat = "Sweat",
    GuardBreak = "BlockBreak",
    Dash = "DashLines",
    DashCount = 12,
    PunchLines = {
        Light = "Impact3",
        Medium = "Impact1",
        Heavy = "Impact2"
    },
    PunchLineCount = {
        Light = 8,
        Medium = 10,
        Heavy = 12
    }
}
t1.Whiff = {
    Range = 12,
    StaminaExtra = 0.5,
    RecoveryExtra = 0.2,
    CounterWindow = 0.6,
    CounterDamage = 1.4
}
t1.Interrupt = {
    DamageMultiplier = 1.5
}
t1.PerfectDodge = {
    WeaveWindow = 0.18,
    DashWindow = 0.35,
    DashRange = 8,
    ExposedTime = 0.8,
    GuardDamageMultiplier = 3,
    DamageMultiplier = 1.3,
    OutlineTime = 0.7,
    OutlineColor = Color3.fromRGB(255, 255, 255)
}
t1.WillpowerEffects = {
    CourageLowHealth = 0.35,
    CourageReductionPerPoint = 0.03,
    CourageReductionMax = 0.3,
    CourageGetUpPerPoint = 0.04,
    CourageGetUpMin = 0.6,
    BloodthirstDamagePerPoint = 0.04,
    BloodthirstFullAt = 0.3,
    BloodthirstStaminaPerPoint = 0.5,
    BloodthirstMinClean = 0.5,
    CourageFlurryAt = 3,
    CourageCrossAt = 6,
    CourageDazePerPoint = 0.05,
    CourageDazeMin = 0.5,
    BloodthirstLowHealth = 0.25,
    ProcBase = 0.01,
    ProcPerTenth = 0.01,
    ProcMax = 0.6,
    BloodthirstSound = "rbxassetid://18924585347",
    BloodthirstSoundVolume = 1.5,
    BloodthirstJolt = 0.9,
    BloodthirstJoltTime = 0.5,
    BloodthirstDuration = 20,
    BloodthirstStrength = 0.2,
    BloodthirstSpeed = 0.2,
    BloodthirstShake = 0.35,
    DeterminationLowHealth = 0.25,
    DeterminationDuration = 15,
    DeterminationDamageTaken = 0.7,
    DeterminationSound = "rbxassetid://117689535312983",
    DeterminationSoundVolume = 1.5,
    DeterminationFlashTime = 0.5,
    DeterminationEyes = {
        Image = "rbxassetid://75671605529840",
        FaceRadius = 0.609,
        GlowIrisBrightness = 1.3,
        GlowHaloTexture = "rbxasset://textures/particles/explosion01_shockwave_main.dds",
        GlowHaloSize = 0.3,
        GlowHaloTransparency = 0.5,
        GlowHaloRate = 20,
        GlowHaloEmission = 0.3,
        GlowHaloZOffset = 0.15,
        GlowLightBrightness = 1,
        GlowLightRange = 1.8,
        GlowColor = Color3.fromRGB(90, 255, 110),
        GlowHaloColor = Color3.fromRGB(60, 230, 90),
        Size = Vector2.new(0.125, 0.185),
        Eyes = {
            {
                Offset = Vector3.new(0.255, 0.115, -0.61),
                RectOffset = Vector2.new(56, 147),
                RectSize = Vector2.new(72, 109)
            },
            {
                Offset = Vector3.new(-0.215, 0.115, -0.61),
                RectOffset = Vector2.new(386, 148),
                RectSize = Vector2.new(71, 108)
            }
        }
    }
}
t1.MittsAim = {
    Lateral = 2,
    Height = 1.6,
    HeadLine = 1.4,
    BodyLine = 0.1,
    MaxReach = 6,
    MissDamageMultiplier = 0.6
}
t1.SpeedBagAnimations = {
    Cycle = "rbxassetid://81663394385165",
    CycleLength = 0.55,
    Idle = "rbxassetid://106081887588050",
    HitLeft = "rbxassetid://109605160707670",
    HitRight = "rbxassetid://129316351767854",
    Contact = 0.4,
    HitSpeed = 1.6,
    CycleContacts = { 0.2, 0.475 }
}
t1.SpeedBagStand = {
    Side = 0.27,
    Distance = 3.5
}
t1.Loadout = {
    DataStore = "BoxingLoadout_v1",
    ClickSound = "rbxassetid://140910211",
    ClickVolume = 0.7,
    Slots = {
        Stance1 = {
            Type = "Stance",
            Required = true
        },
        Guard1 = {
            Type = "Guard",
            Required = true
        },
        Stance2 = {
            Type = "Stance",
            Required = true
        },
        Guard2 = {
            Type = "Guard",
            Required = true
        },
        Skill1 = {
            Type = "Skill"
        },
        Skill2 = {
            Type = "Skill"
        },
        Skill3 = {
            Type = "Skill"
        },
        Skill4 = {
            Type = "Skill"
        },
        Dash = {
            Type = "Dash"
        }
    },
    Items = {
        OrthodoxStance = {
            Name = "Orthodox Stance",
            Type = "Stance",
            Icon = "rbxassetid://73584842023549",
            IconHasName = true
        },
        OrthodoxGuard = {
            Name = "Orthodox Guard",
            Type = "Guard",
            Icon = "rbxassetid://73584842023549",
            IconHasName = true
        },
        HalfGuard = {
            Name = "Half Guard",
            Type = "Guard",
            Skill = "Half Guard",
            HalfGuard = {
                ChipDamage = 0.8,
                GuardDamage = 0.85
            }
        },
        CrossArmGuard = {
            Name = "Cross Arm Guard",
            Type = "Guard",
            Skill = "Cross Arm Guard",
            Animations = {
                Block = "rbxassetid://80928731104774",
                BlockMove = {
                    Forward = "rbxassetid://133476790557703",
                    Backward = "rbxassetid://129939225450058",
                    Left = "rbxassetid://96678689183724",
                    Right = "rbxassetid://124845204410994"
                }
            },
            CrossArm = {
                UppercutBlockedDamage = 0,
                UppercutGuardDamage = 0.5,
                GuardDamage = 0.75
            }
        },
        OutboxerDash = {
            Name = "Outboxer Dash",
            Type = "Dash",
            Skill = "Outboxer Dash",
            Icon = "rbxassetid://123017060616407"
        },
        InfighterDash = {
            Name = "Infighter Dash",
            Type = "Dash",
            Skill = "Infighter Dash"
        },
        SouthpawStance = {
            Name = "Southpaw Stance",
            Type = "Stance",
            Skill = "Southpaw Stance",
            Mirror = true,
            JabReach = 1.1,
            Damage = {
                Punches = {
                    Jab = 0.2
                }
            }
        },
        OutboxerStance = {
            Name = "Orthodox Outboxer Style",
            Type = "Stance",
            Skill = "Orthodox Outboxer Style",
            JabReach = 1.4,
            JabStun = 0.75,
            JabContact = 0.12,
            OpenLeft = 0.5,
            FlickerWithBuff = true,
            Animations = {
                Stance = "rbxassetid://138320059499518"
            },
            Damage = {
                Punches = {
                    Cross = 0.1,
                    Jab = 0.15
                }
            }
        },
        PeekABooStance = {
            Name = "Peek a Boo Style",
            Type = "Stance",
            Skill = "Peek a Boo Style",
            JabReach = 0.95,
            Animations = {
                Stance = "rbxassetid://70955293423884",
                Block = "rbxassetid://103697110601001",
                Feint = "rbxassetid://137536361831826",
                Move = {
                    Forward = "rbxassetid://82062474100550",
                    Backward = "rbxassetid://94840686953965",
                    Left = "rbxassetid://129434511922627",
                    Right = "rbxassetid://102902251247860"
                }
            },
            Punches = {
                Jab = {
                    Head = {
                        Id = "rbxassetid://131178018360202",
                        HitTime = 0.08
                    },
                    Body = {
                        Id = "rbxassetid://76027208196185",
                        HitTime = 0.08
                    }
                },
                Cross = {
                    Head = {
                        Id = "rbxassetid://95322020322532",
                        HitTime = 0.2
                    },
                    Body = {
                        Id = "rbxassetid://102184380390003",
                        HitTime = 0.2
                    }
                },
                LeftHook = {
                    Head = {
                        Id = "rbxassetid://93304291250792",
                        HitTime = 0.13
                    },
                    Body = {
                        Id = "rbxassetid://83179438149307",
                        HitTime = 0.2
                    }
                },
                RightHook = {
                    Head = {
                        Id = "rbxassetid://87863046500368",
                        HitTime = 0.13
                    },
                    Body = {
                        Id = "rbxassetid://126934482441014",
                        HitTime = 0.2
                    }
                }
            },
            Damage = {
                BodyHooks = 0.2,
                AllScale = 0.8
            },
            PeekGuard = {
                GuardDamage = 0.6,
                BlockedDamage = 0
            }
        },
        PhillyStance = {
            Name = "Philly Shell Style",
            Type = "Stance",
            Skill = "Philly Shell Style",
            JabReach = 1.5,
            JabWindup = 1.15,
            FlickerWithBuff = true,
            JabContact = 0.06,
            Animations = {
                Stance = "rbxassetid://114946417944987",
                Move = {
                    Forward = "rbxassetid://90083330450337",
                    Backward = "rbxassetid://102547285591982",
                    Left = "rbxassetid://106444397798669",
                    Right = "rbxassetid://138876067560275"
                }
            },
            FlickerAnim = {
                Id = "rbxassetid://75622835049331",
                HitTime = 0.36,
                Rate = 1.8
            },
            Punches = {
                Cross = {
                    Head = {
                        Id = "rbxassetid://107802864339404",
                        HitTime = 0.3,
                        Rate = 1.5
                    },
                    Body = {
                        Id = "rbxassetid://107802864339404",
                        HitTime = 0.3,
                        Rate = 1.5
                    }
                }
            },
            Damage = {
                Punches = {
                    Jab = 0.08,
                    Cross = -0.05
                }
            }
        },
        CrouchingStance = {
            Name = "Crouching Style",
            Type = "Stance",
            Skill = "Crouching Style",
            JabReach = 0.95,
            Animations = {
                Stance = "rbxassetid://113138496002426",
                Move = {
                    Forward = "rbxassetid://101638591585530",
                    Backward = "rbxassetid://97271223790217",
                    Left = "rbxassetid://85564471141426",
                    Right = "rbxassetid://137264841009244"
                }
            },
            Damage = {
                Punches = {
                    LeftUppercut = 0.15,
                    RightUppercut = 0.15
                }
            }
        },
        BrawlerStance = {
            Name = "Brawler Style",
            Type = "Stance",
            Skill = "Brawler Style",
            JabReach = 0.95,
            Animations = {
                Stance = "rbxassetid://122649906610272",
                Move = {
                    Forward = "rbxassetid://117038108284073",
                    Backward = "rbxassetid://100036552232100",
                    Left = "rbxassetid://138560917760220",
                    Right = "rbxassetid://100548434596444"
                }
            },
            Damage = {
                Punches = {
                    LeftHook = 0.35,
                    RightHook = 0.35
                }
            }
        },
        HitmanStance = {
            Name = "Hitman Style",
            Type = "Stance",
            Skill = "Hitman Style",
            JabReach = 1.5,
            JabWindup = 1.15,
            Flicker = true,
            JabContact = 0.03,
            Punches = {
                Cross = {
                    Head = {
                        Id = "rbxassetid://107802864339404",
                        HitTime = 0.3,
                        Rate = 1.5
                    },
                    Body = {
                        Id = "rbxassetid://82443271676764",
                        HitTime = 0.27
                    }
                }
            },
            Animations = {
                Stance = "rbxassetid://131923904442209",
                Move = {
                    Forward = "rbxassetid://110689630017491",
                    Backward = "rbxassetid://87748180072926",
                    Left = "rbxassetid://94059087403279",
                    Right = "rbxassetid://95153678435971"
                }
            },
            FlickerAnim = {
                Id = "rbxassetid://89348553600769",
                HitTime = 0.24,
                Rate = 1.2
            },
            Damage = {
                Punches = {
                    Jab = 0.07
                }
            }
        },
        FlickerJab = {
            Name = "Flicker Jab",
            Type = "Skill",
            Skill = "Flicker Jab"
        },
        Clinch = {
            Name = "Clinching",
            Type = "Skill",
            Skill = "Clinching"
        },
        CrossCounter = {
            Name = "Cross Counter",
            Type = "Skill",
            Skill = "Cross Counter"
        },
        SwingCounter = {
            Name = "Swing Counter",
            Type = "Skill",
            Skill = "Swing Counter"
        },
        OverhandRight = {
            Name = "Overhand Right",
            Type = "Skill",
            Skill = "Overhand Right"
        },
        CorkscrewBlow = {
            Name = "Corkscrew Blow",
            Type = "Skill",
            Skill = "Corkscrew Blow"
        },
        DragonFishBlow = {
            Name = "Dragon Fish Blow",
            Type = "Skill",
            Skill = "Dragon Fish Blow"
        },
        WhiteFang = {
            Name = "White Fang",
            Type = "Skill",
            Skill = "White Fang"
        },
        LiverBlow = {
            Name = "Liver Blow",
            Type = "Skill",
            Skill = "Liver Blow"
        },
        Smash = {
            Name = "Smash",
            Type = "Skill",
            Skill = "Smash"
        },
        LowSmash = {
            Name = "Low Smash",
            Type = "Skill",
            Skill = "Low Smash"
        },
        FullBodyUppercut = {
            Name = "Full-Body Uppercut",
            Type = "Skill",
            Skill = "Full-Body Uppercut"
        },
        GazellePunch = {
            Name = "Gazelle Punch",
            Type = "Skill",
            Skill = "Gazelle Punch"
        },
        DempseyRoll = {
            Name = "Dempsey Roll",
            Type = "Skill",
            Skill = "Dempsey Roll"
        },
        Shotgun = {
            Name = "Shotgun",
            Type = "Skill",
            Skill = "Shotgun"
        },
        Hedgehog = {
            Name = "Hedgehog",
            Type = "Skill",
            Skill = "Hedgehog"
        }
    },
    StartingItems = { "OrthodoxStance", "OrthodoxGuard" },
    Defaults = {
        Stance1 = "OrthodoxStance",
        Guard1 = "OrthodoxGuard",
        Stance2 = "OrthodoxStance",
        Guard2 = "OrthodoxGuard"
    },
    TypeNames = {
        Stance = "Stance",
        Guard = "Guard",
        Skill = "Skill",
        Dash = "Dash"
    }
}
t1.Ranked = {
    RingName = "RankedRing(new)",
    Rounds = 8,
    RoundHealthLoss = 0.1,
    GymRingName = "GYMKamogawaRing(new)",
    Cooldown = 600,
    LossCooldown = 180,
    RematchGap = 3,
    ChoiceTimeout = 30,
    Banner = "rbxassetid://127028104857389",
    WinPurse = 1E+05,
    LossPurse = 50000,
    Leagues = {
        {
            Name = "Unranked",
            Win = 0.3,
            Loss = 0.15,
            Emblem = "rbxassetid://74422088866677",
            Ranks = { 0, 0.5, 1 },
            Color = Color3.fromRGB(175, 175, 180)
        },
        {
            Name = "Bronze",
            Win = 0.15,
            Loss = 0.2,
            Emblem = "rbxassetid://81573294180900",
            Ranks = { 1.5, 2, 2.5 },
            Color = Color3.fromRGB(205, 127, 50)
        },
        {
            Name = "Silver",
            Win = 0.1,
            Loss = 0.25,
            Emblem = "rbxassetid://115494723804069",
            Ranks = { 3, 3.5, 4 },
            Color = Color3.fromRGB(205, 212, 222)
        },
        {
            Name = "Gold",
            Win = 0.07,
            Loss = 0.3,
            Emblem = "rbxassetid://103543734989139",
            Ranks = { 5, 6, 7 },
            Color = Color3.fromRGB(242, 196, 60)
        },
        {
            Name = "Diamond",
            Win = 0.05,
            Loss = 0.35,
            Emblem = "rbxassetid://123048201083138",
            Ranks = { 8, 9, 10 },
            Color = Color3.fromRGB(120, 220, 255)
        },
        {
            Name = "Master",
            Win = 0.05,
            Loss = 0.35,
            Emblem = "rbxassetid://123048201083138",
            Ranks = { 11, 12, 13 },
            Color = Color3.fromRGB(176, 110, 255)
        },
        {
            Name = "Grandmaster",
            Win = 0.05,
            Loss = 0.35,
            Emblem = "rbxassetid://123048201083138",
            Ranks = { 14, 15, 16 },
            Color = Color3.fromRGB(235, 70, 90)
        },
        {
            Name = "Champion",
            Win = 0.05,
            Loss = 0.35,
            Emblem = "rbxassetid://123048201083138",
            Ranks = { 17.5, 19, 20.5 },
            Color = Color3.fromRGB(255, 165, 40)
        },
        {
            Name = "Elite",
            Win = 0.05,
            Loss = 0.35,
            Emblem = "rbxassetid://123048201083138",
            Ranks = { 22, 23.5, 25 },
            Color = Color3.fromRGB(60, 225, 185)
        },
        {
            Name = "Legend",
            Win = 0.05,
            Loss = 0.35,
            Emblem = "rbxassetid://123048201083138",
            Ranks = { 27, 29, 31 },
            Color = Color3.fromRGB(255, 236, 160)
        },
        {
            Name = "World Champion",
            Win = 0.05,
            Loss = 0.35,
            Emblem = "rbxassetid://123048201083138",
            Ranks = { 34 },
            Color = Color3.fromRGB(255, 90, 45)
        }
    }
}
t1.FrontMenu = {
    Enabled = true,
    HoldSpot = Vector3.new(-6000, 640, -6400),
    HoldSpacing = 14,
    OrbitRadius = 58,
    OrbitHeight = 46,
    OrbitLookHeight = 11,
    OrbitFov = 40,
    OrbitSeconds = 80,
    Logo = "",
    IppoStance = "rbxassetid://78935802790252",
    Title = "HAJIME NO IPPO",
    Subtitle = "RISING"
}
t1.Slots = {
    Max = 5,
    Free = 1,
    Product = 3719347290,
    Price = 75,
    DataStore = "BoxingSlots_v1"
}
t1.PlayerDamageMultiplier = 0.5
t1.RingLocksGloves = true
t1.PowerMuscles = {
    MaxStage = 7,
    RingOnly = true,
    Inflate = {
        [123699237758561] = Vector3.new(1.08, 1.01, 1.08),
        [85182492180103] = Vector3.new(1.08, 1.01, 1.08),
        [123537725182712] = Vector3.new(0.99, 0.99, 1.18),
        [87817364961144] = Vector3.new(0.99, 0.99, 1.18),
        [103864846089327] = Vector3.new(1, 1, 1.18),
        [71713660049654] = Vector3.new(1, 1, 1.18)
    },
    Shift = {
        [123537725182712] = Vector3.new(0, 0, -0.1),
        [87817364961144] = Vector3.new(0, 0, -0.1),
        [103864846089327] = Vector3.new(0, 0, 0.09),
        [71713660049654] = Vector3.new(0, 0, 0.09)
    },
    SuitMaterial = Enum.Material.SmoothPlastic,
    GearGrow = {
        Shorts = Vector3.new(1.06, 1, 1.06),
        Shoe = Vector3.new(1.07, 1.02, 1.05),
        Waistband = Vector3.new(1.02, 1, 1.09),
        WaistbandTorsos = { 123537725182712, 87817364961144, 103864846089327, 71713660049654, 122178095031297 }
    },
    Stages = {
        {
            Torso = 84090931952537
        },
        {
            Torso = 123537725182712
        },
        {
            Torso = 87817364961144,
            ["Left Arm"] = 113437104526085,
            ["Right Arm"] = 104546868690494
        },
        {
            Torso = 132694187722714,
            ["Left Arm"] = 113437104526085,
            ["Right Arm"] = 104546868690494
        },
        {
            Torso = 103864846089327,
            ["Left Arm"] = 113437104526085,
            ["Right Arm"] = 104546868690494,
            ["Left Leg"] = 123699237758561,
            ["Right Leg"] = 85182492180103
        },
        {
            Torso = 71713660049654,
            ["Left Arm"] = 113437104526085,
            ["Right Arm"] = 104546868690494,
            ["Left Leg"] = 123699237758561,
            ["Right Leg"] = 85182492180103
        },
        {
            Torso = 122178095031297,
            ["Left Arm"] = 83124039764247,
            ["Right Arm"] = 92500700571067,
            ["Left Leg"] = 123699237758561,
            ["Right Leg"] = 85182492180103
        }
    }
}
t1.BodyEffects = {
    BreathingSound = "rbxassetid://101395573137763",
    BreathingVolume = 0.9,
    LowStamina = 0.3,
    FatiguedIntensity = 0.85,
    BloodthirstIntensity = 1,
    CourageIntensity = 0.7,
    Hunch = 7,
    Heave = 2.5,
    ShoulderLift = 0.07,
    HeartbeatSound = "rbxassetid://139459003161851",
    HeartbeatBelow = 0.25,
    JumpRopeSound = "rbxassetid://73294243782256",
    JumpRopeVolume = 0.8,
    BreathsPerSecond = { 0.35, 1.1 },
    HeartbeatInterval = { 1.05, 0.42 },
    HeartbeatVolume = { 0.5, 2 },
    LiftSounds = {
        ["Bicep Curls"] = {
            Sound = "rbxassetid://101395573137763",
            Volume = 1.1,
            Slice = 0.9,
            RandomStart = 4,
            Marks = { 0.02, 1.02 }
        },
        Benches = {
            Sound = "rbxassetid://112023791713767",
            Volume = 1,
            Marks = { 0.02 }
        },
        ["Squat Racks"] = {
            Sound = "rbxassetid://112023791713767",
            Volume = 1,
            Marks = { 1.02 }
        }
    }
}
t1.SpeedBagRhythm = {
    Sound = "rbxassetid://137959735829795",
    Volume = 1,
    Voices = 3,
    Crossfade = 0.12,
    Duck = 0.55,
    MinGap = 0.06,
    ReboundMinSpeed = 4,
    SpeedUpPerHit = 0.012,
    Window = 0.13,
    PerfectWindow = 0.04,
    MissesToEnd = 3,
    WarmupBeats = 3,
    ComboGainPerHit = 0.02,
    ComboGainMax = 0.5,
    RepScale = 0.35,
    MinRepTime = 0.2,
    BeatTime = { 0.62, 0.3 }
}
t1.Injuries = {
    Enabled = true,
    CleanBase = 0.5,
    Counter = 1.3,
    KnockdownBonus = 20,
    MaxPoints = 280,
    Weight = {
        Light = 0.9,
        Medium = 1,
        Heavy = 1.15
    },
    Decay = {
        Delay = 10,
        PerSecond = 1
    },
    Head = {
        Thresholds = { 36, 80, 140, 200 },
        Blur = {
            Duration = 4,
            Cooldown = 6,
            RetriggerPoints = 6,
            Size = { 10, 13, 15, 15 }
        },
        Sway = {
            Strength = { 0, 0.6, 0.8, 0.9 }
        },
        BloodyEye = {
            Side = "Right",
            ScreenTransparency = 0.45,
            ScreenWidth = 0.36,
            FaceImage = "",
            FaceEye = Vector3.new(0.271, 0.102, -0.61),
            FaceRadius = 0.615,
            FaceMaskCoreUp = 0.118,
            FaceMaskCorner = 0.05,
            FaceMaskShade = 0.97,
            FaceStrips = 16,
            EyeCentre = 0.12,
            ScreenColor = Color3.fromRGB(150, 8, 8),
            FaceColor = Color3.fromRGB(165, 10, 10),
            FaceMaskCore = Vector2.new(0.305, 0.238),
            FaceMaskFeather = {
                Side = 0.035,
                Top = 0.01,
                Bottom = 0.035
            },
            FaceArt = Vector2.new(0.285, 0.2),
            FaceArtOffset = Vector2.new(0, 0.004),
            BloodshotDecals = { "rbxassetid://118447410595252", "rbxassetid://134715056544951", "rbxassetid://86852166919399" },
            BloodshotPoints = { 140, 170, 200 },
            BloodshotDecalsLeft = { "rbxassetid://103473995383423", "rbxassetid://70693232240658", "rbxassetid://74937230414277" }
        },
        Blackout = {
            FadeIn = 0.12,
            Hold = 0.55,
            FadeOut = 0.9,
            Cooldown = 25,
            TriggerPoints = 10,
            RingSound = "rbxassetid://71033223432168",
            RingVolume = 0.45,
            RingFade = 2.6
        }
    },
    Torso = {
        WindFill = 1.3,
        Thresholds = { 45, 105, 190 },
        StaminaCost = { 1.08, 1.15, 1.25 },
        Regen = { 0.92, 0.82, 0.7 },
        Breathing = { 0, 0.6, 0.85 },
        BodyStun = {
            Duration = 0.7,
            MinWeight = "Heavy",
            MinClean = 0.45,
            Cooldown = 5
        },
        Rib = {
            BodyDamage = 1.5,
            Walk = 0.92,
            Sound = "rbxassetid://81176352888976",
            Volume = 1.2,
            Treatments = 2
        }
    },
    Arms = {
        FatigueGuard = 0.25,
        Guard = 1.35,
        Chip = 1.5,
        Punch = 0.9,
        Centre = 0.2,
        Thresholds = { 80, 200 },
        Recover = {
            Delay = 3,
            PerSecond = 16
        },
        Severe = {
            Burst = 120,
            Window = 3,
            Chance = 0.1,
            Guard = 1.5,
            Chip = 2,
            Punch = 0.85
        }
    },
    Treatment = {
        PerBreak = 2,
        Head = 60,
        Torso = 48,
        Arms = 90,
        RingDoctor = {
            Cost = 7500,
            FreeAfterSparWins = 40
        }
    },
    Rest = {
        Head = 12,
        Torso = 10,
        Arms = 50,
        RibSeconds = 12,
        SevereSeconds = 8
    },
    Icons = {
        Size = 64,
        Gap = 6,
        Right = 14,
        Bottom = 12
    }
}
t1.Blood = {
    Enabled = true,
    Combo = 0.2,
    ComboMax = 0.6,
    ComboWindow = 2.5,
    Nose = 60,
    Face = 130,
    Max = 200,
    TreatBleed = 120,
    RestPerSecond = 16,
    HitFxMin = 24,
    ShellSize = 1.2125,
    Weight = {
        Light = 0.6,
        Medium = 1,
        Heavy = 1.4
    },
    FaceDecals = {
        Nose = "rbxassetid://91142100756795",
        Face = "rbxassetid://131574604203279"
    },
    Splash = {
        MinGain = 4,
        GainForMax = 22,
        Size = { 0.5, 1.6 },
        Drops = { 3, 7 },
        Throw = { 1.5, 4.5 }
    },
    Drip = {
        Every = { 2, 3.5 },
        FaceEvery = { 1, 2 }
    },
    CutFx = {
        Count = 8,
        Drops = { 1, 3 }
    },
    BreakFx = {
        Count = 30,
        Lines = 18
    },
    Puddle = {
        Life = 180,
        FadeTime = 3,
        Start = 0.9,
        Grow = 0.55,
        MaxSize = 5,
        Merge = 0.7,
        Max = 120,
        Color = Color3.fromRGB(120, 0, 6)
    }
}
t1.Survival = {
    Max = 100,
    HungerMinutes = 60,
    ThirstMinutes = 60,
    EnergyTrainingMinutes = 10,
    StartingCash = 1E+05,
    Low = 20,
    EatCooldown = 1,
    MaxStack = 99,
    DataStore = "BoxingSurvival_v1",
    Start = {
        Hunger = 100,
        Thirst = 100,
        Energy = 100
    },
    NoEnergy = {
        GainScale = 0.35,
        StaminaScale = 0.5
    },
    Penalty = {
        Amount = 0.1,
        RestoreTo = 50,
        Skip = {
            Willpower = true
        }
    }
}
t1.Foods = {
    Donut = {
        Asset = 114588918662296,
        Energy = 20,
        Hunger = 15,
        Thirst = 0,
        Stamina = -0.05
    },
    ["Bread Rolls"] = {
        Asset = 83381953526206,
        Energy = 15,
        Hunger = 25,
        Thirst = 0,
        Stamina = -0.04
    },
    Bread = {
        Asset = 118384197323358,
        Energy = 10,
        Hunger = 20,
        Thirst = 0,
        Stamina = -0.025
    },
    Gyoza = {
        Asset = 137596063805578,
        Energy = 10,
        Hunger = 20,
        Thirst = 0,
        Stamina = -0.03
    },
    ["Beef Ramen"] = {
        Asset = 114569172258762,
        Energy = 10,
        Hunger = 35,
        Thirst = 5,
        Stamina = -0.03
    },
    ["Plain Ramen"] = {
        Asset = 107976807087760,
        Energy = 8,
        Hunger = 25,
        Thirst = 5,
        Stamina = -0.02
    },
    Sushi = {
        Asset = 75084740856039,
        Energy = 8,
        Hunger = 20,
        Thirst = 0,
        Stamina = 0,
        Healthy = true
    },
    ["Water Bottle"] = {
        Asset = 112898020818906,
        Energy = 5,
        Hunger = 0,
        Thirst = 50,
        Stamina = 0,
        Drink = true
    },
    ["Coffee Cup"] = {
        Asset = 101200082597200,
        Energy = 10,
        Hunger = 0,
        Thirst = 10,
        Stamina = -0.005,
        Drink = true
    },
    Hotdog = {
        Asset = 120708473375628,
        Energy = 10,
        Hunger = 25,
        Thirst = 0,
        Stamina = -0.02
    },
    Pizza = {
        Asset = 104115539097982,
        Energy = 15,
        Hunger = 35,
        Thirst = 0,
        Stamina = -0.03
    },
    Tomato = {
        Asset = 113596984195569,
        Energy = 5,
        Hunger = 10,
        Thirst = 10,
        Stamina = 0,
        Healthy = true,
        WeightScale = 0.025
    },
    ["Energy Drink"] = {
        Energy = 45,
        Hunger = 0,
        Thirst = 15,
        Stamina = 0,
        Drink = true
    },
    ["Cup Noodles"] = {
        Asset = 80529832558691,
        Energy = 8,
        Hunger = 20,
        Thirst = 5,
        Stamina = -0.025
    }
}
t1.Currency = {
    Symbol = "¥"
}
t1.Shops = {
    InteractDistance = 8,
    BuyCooldown = 0.25,
    List = {
        Normal = {
            Name = "Normal Shop",
            Items = {
                { "Water Bottle", 750 },
                { "Coffee Cup", 1500 },
                { "Hotdog", 2000 },
                { "Pizza", 1750 },
                { "Tomato", 500 },
                { "Cup Noodles", 1250 },
                { "Energy Drink", 4500 }
            }
        },
        Noodles = {
            Name = "Noodles Shop",
            Items = {
                { "Plain Ramen", 4000 },
                { "Sushi", 5000 },
                { "Beef Ramen", 6000 },
                { "Gyoza", 3000 }
            }
        },
        Bakery = {
            Name = "Yamanaka Bakery",
            Items = {
                { "Bread", 1250 },
                { "Bread Rolls", 1500 },
                { "Donut", 1000 }
            }
        },
        Clothes = {
            Name = "Clothing Store",
            Clothes = true
        }
    }
}
t1.LastingInjuries = {
    Enabled = true,
    TreatmentCost = 5000,
    MaxPerFight = 3,
    Insurance = {
        Price = 3E+05,
        Days = 7,
        HospitalDiscount = 0.5
    },
    Risk = {
        DamageFrom = 0.25,
        PerDamage = 0.3,
        PerKnockdown = 0.12,
        Stopped = 0.25,
        MinutesFrom = 3,
        PerMinute = 0.01,
        IntensityFrom = 0.25,
        Intensity = 0.1,
        Max = 0.9,
        Rolls = { 1, 0.45, 0.18 }
    },
    Limits = {
        Min = 0.7,
        Max = 1.4
    },
    Types = {
        {
            Id = "BlackEye",
            Name = "Bloody / Black Eye",
            Class = "Common",
            Weight = 6,
            Region = "Head",
            Side = "Eye",
            Effect = "Darker, blurred vision on that side",
            Vision = "BlackEye",
            Boost = {
                Head = 0.25,
                EyeBlood = 0.5
            },
            Face = {
                R = "rbxassetid://124863282318822",
                L = "rbxassetid://129680210534715"
            }
        },
        {
            Id = "BrokenNose",
            Name = "Broken Nose",
            Class = "Uncommon",
            Weight = 3,
            Region = "Head",
            Effect = "Stamina recovers 15% slower",
            Face = "rbxassetid://119107317401225",
            Effects = {
                StaminaRegen = 0.85
            },
            Boost = {
                Head = 0.3,
                Bleeding = 0.4
            }
        },
        {
            Id = "BrokenRibs",
            Name = "Broken Ribs",
            Class = "Serious",
            Weight = 1.5,
            Region = "Body",
            Effect = "Max stamina -12%, blocking costs 25% more guard",
            Body = "Ribs",
            Effects = {
                MaxStamina = 0.88,
                BlockCost = 1.25
            },
            Boost = {
                Torso = 0.8
            }
        },
        {
            Id = "CutForehead",
            Name = "Cut Forehead",
            Class = "Common",
            Weight = 6,
            Region = "Head",
            Effect = "Bleeding - stamina recovers 6% slower",
            Face = "rbxassetid://135459458358313",
            Effects = {
                StaminaRegen = 0.94
            },
            Boost = {
                Head = 0.2,
                Bleeding = 0.8
            }
        },
        {
            Id = "ShoulderInjury",
            Name = "Shoulder Injury",
            Class = "Uncommon",
            Weight = 3,
            Region = "Arms",
            Side = "Arm",
            Effect = "Punches cost 15% more stamina and hit 7% softer",
            Body = "Shoulder",
            Effects = {
                PunchCost = 1.15,
                PunchDamage = 0.93
            },
            Boost = {
                Arms = 0.5
            }
        },
        {
            Id = "HandFracture",
            Name = "Hand / Wrist Fracture",
            Class = "Serious",
            Weight = 1.5,
            Region = "Arms",
            Side = "Arm",
            Effect = "Punches hit 12% softer and cost 8% more stamina",
            Body = "Wrist",
            Effects = {
                PunchDamage = 0.88,
                PunchCost = 1.08
            },
            Boost = {
                Arms = 0.6
            }
        },
        {
            Id = "Concussion",
            Name = "Concussion",
            Class = "Serious",
            Weight = 1.5,
            Region = "Head",
            Effect = "Max health -8%, 8% slower on your feet, vision blurs now and then",
            Vision = "Concussion",
            Face = "rbxassetid://97562873259557",
            Effects = {
                MaxHealth = 0.92,
                WalkSpeed = 0.92
            },
            Boost = {
                Head = 0.35,
                Knockdowns = 0.6,
                Stopped = 1.5
            }
        }
    },
    Classes = {
        Common = 1,
        Uncommon = 2,
        Serious = 3
    },
    Concussion = {
        Duration = 2.6,
        Blur = 7,
        Sway = 0.25,
        Every = { 90, 160 }
    },
    BlackEye = {
        Width = 0.34,
        Strength = 0.5
    },
    BodyMarks = {
        Shoulder = "rbxassetid://90072855446314",
        Wrist = "rbxassetid://110362812957207",
        Ribs = {
            Front = "rbxassetid://138474659146736",
            Back = "rbxassetid://71601324360862",
            Side = "rbxassetid://124305947060359"
        }
    },
    Hospital = {
        ShopId = "Hospital",
        Name = "Hospital",
        Kana = "病院",
        Tag = "SPORTS INJURY CLINIC",
        Banner = "rbxassetid://76588622770163"
    }
}
t1.Clothes = {
    Starter = { "IppoTrainingShirt", "IppoTrainingPants" },
    List = {
        {
            Id = "IppoTrainingShirt",
            Name = "Ippo Training Shirt",
            Kind = "Shirt",
            Template = "rbxassetid://87696902889429",
            Price = 2000,
            Section = "Ippo Makunouchi"
        },
        {
            Id = "IppoTrainingPants",
            Name = "Ippo Training Pants",
            Kind = "Pants",
            Template = "rbxassetid://87354446729496",
            Price = 2000,
            Section = "Ippo Makunouchi"
        },
        {
            Id = "TakamuraShirt",
            Name = "Takamura Shirt",
            Kind = "Shirt",
            Template = "rbxassetid://15318492477",
            Price = 3000,
            Section = "Takamura"
        },
        {
            Id = "TakamuraPants",
            Name = "Takamura Pants",
            Kind = "Pants",
            Template = "rbxassetid://15318477974",
            Price = 3000,
            Section = "Takamura"
        },
        {
            Id = "KimuraTracksuitTop",
            Name = "Kimura Tracksuit Top",
            Kind = "Shirt",
            Template = "rbxassetid://6902163882",
            Price = 3000,
            Section = "Kimura"
        },
        {
            Id = "KimuraTracksuitBottoms",
            Name = "Kimura Tracksuit Bottoms",
            Kind = "Pants",
            Template = "rbxassetid://6921216326",
            Price = 3000,
            Section = "Kimura"
        },
        {
            Id = "MiyataTracksuitTop",
            Name = "Miyata Tracksuit Top",
            Kind = "Shirt",
            Template = "rbxassetid://6902108275",
            Price = 3000,
            Section = "Miyata"
        },
        {
            Id = "MiyataPants",
            Name = "Miyata Pants",
            Kind = "Pants",
            Template = "rbxassetid://14746192443",
            Price = 3000,
            Section = "Miyata"
        },
        {
            Id = "MartinezSuitTop",
            Name = "Martinez Suit Top",
            Kind = "Shirt",
            Template = "rbxassetid://139241231648900",
            Price = 3000,
            Section = "Martinez"
        },
        {
            Id = "MartinezSuitPants",
            Name = "Martinez Suit Pants",
            Kind = "Pants",
            Template = "rbxassetid://102730936195182",
            Price = 3000,
            Section = "Martinez"
        },
        {
            Id = "RedTieSuitJacket",
            Name = "Red Tie Suit Jacket",
            Kind = "Shirt",
            Template = "rbxassetid://4835523159",
            Price = 2500,
            Section = "Suits"
        },
        {
            Id = "RedTieSuitPants",
            Name = "Red Tie Suit Pants",
            Kind = "Pants",
            Template = "rbxassetid://4835526018",
            Price = 2500,
            Section = "Suits"
        },
        {
            Id = "SocialShirt",
            Name = "Social Shirt",
            Kind = "Shirt",
            Template = "rbxassetid://15632805823",
            Price = 2000,
            Section = "Casual"
        },
        {
            Id = "PeakyBlackPants",
            Name = "Peaky Black Pants",
            Kind = "Pants",
            Template = "rbxassetid://7943692126",
            Price = 2000,
            Section = "Casual"
        },
        {
            Id = "KamogawaGymPants",
            Name = "Kamogawa Gym Pants (Black-Blue)",
            Kind = "Pants",
            Template = "rbxassetid://15837900966",
            Price = 3000,
            Section = "Kamogawa Gym"
        }
    }
}
t1.Accessories = {}
t1.Belts = {}
t1.Hotbar = {
    Slots = 9
}

local function skinRow(p54, p55) -- line: 3311
    local t15 = {}

    for i = 0, 11 do
        table.insert(t15, p54:Lerp(p55, i / 11))
    end

    return t15
end

local t16 = {}

for _, v108 in {
        {
            Color3.fromRGB(252, 238, 230),
            Color3.fromRGB(58, 40, 34)
        },
        {
            Color3.fromRGB(255, 240, 196),
            Color3.fromRGB(78, 60, 32)
        },
        {
            Color3.fromRGB(252, 230, 226),
            Color3.fromRGB(70, 42, 42)
        },
        {
            Color3.fromRGB(255, 226, 200),
            Color3.fromRGB(82, 46, 26)
        }
    } do
    for _, v109 in skinRow(v108[1], v108[2]) do
        table.insert(t16, v109)
    end
end

t1.Avatar = {
    DataStore = "BoxingAvatar_v1",
    ProfileVersion = 2,
    StartTokens = 10,
    ResetCost = 1,
    StatResetCost = 1,
    RerollCost = 1,
    HeightRerollCost = 1,
    HeightRerollProduct = 3719347322,
    HeightRerollRobux = 5,
    DefaultSkin = 16,
    DefaultHairColor = 1,
    DefaultEyeColor = 1,
    DefaultHair = 1,
    TorsoWidth = 2,
    FemaleTorsoMesh = 48112070,
    GymTemplate = "CreatorGym",
    GymSpot = Vector3.new(6000, 600, 6000),
    HoldSpot = Vector3.new(-6000, 600, -6000),
    HoldSpacing = 16,
    SkinColors = t16,
    HairColors = {
        {
            Name = "Black",
            Weight = 60,
            Color = Color3.fromRGB(22, 20, 20)
        },
        {
            Name = "Brown",
            Weight = 20,
            Color = Color3.fromRGB(92, 60, 36)
        },
        {
            Name = "Blonde",
            Weight = 15,
            Color = Color3.fromRGB(222, 194, 124)
        },
        {
            Name = "Red",
            Weight = 4,
            Color = Color3.fromRGB(156, 46, 34)
        },
        {
            Name = "White",
            Weight = 1,
            Color = Color3.fromRGB(236, 234, 228)
        }
    },
    EyeColors = {
        {
            Name = "Brown",
            Weight = 66,
            Texture = "rbxassetid://126940859157781",
            Color = Color3.fromRGB(72, 58, 36),
            Tint = Color3.fromRGB(150, 92, 50)
        },
        {
            Name = "Blue",
            Weight = 15,
            Texture = "rbxassetid://90782930699772",
            Color = Color3.fromRGB(0, 196, 240),
            Tint = Color3.fromRGB(70, 175, 235)
        },
        {
            Name = "Hazel",
            Weight = 13,
            Texture = "rbxassetid://140100526932853",
            Color = Color3.fromRGB(130, 104, 62),
            Tint = Color3.fromRGB(160, 132, 72)
        },
        {
            Name = "Dark Blue",
            Weight = 5,
            Texture = "rbxassetid://131677637876386",
            Color = Color3.fromRGB(64, 100, 236),
            Tint = Color3.fromRGB(70, 105, 225)
        },
        {
            Name = "White",
            Weight = 1,
            Texture = "rbxassetid://102451021185663",
            Color = Color3.fromRGB(240, 240, 240),
            Tint = Color3.fromRGB(228, 230, 236)
        }
    },
    HairStyles = {
        {
            Name = "Bald",
            Asset = 0
        },
        {
            Name = "Ippo",
            Model = "Ippo"
        },
        {
            Name = "Ippo Spiky",
            Model = "Ippo Spiky"
        },
        {
            Name = "Japanese Hawk",
            Model = "Japanese Hawk"
        },
        {
            Name = "Naniwa Tiger",
            Model = "Naniwa Tiger"
        },
        {
            Name = "Yellow Hair",
            Model = "Yellow Hair"
        },
        {
            Name = "Side Swept",
            Model = "Side Swept"
        },
        {
            Name = "Messy Mullet",
            Model = "Messy Mullet"
        },
        {
            Name = "Aoki",
            Model = "Aoki"
        },
        {
            Name = "Flying Dragon",
            Model = "Flying Dragon"
        },
        {
            Name = "Wally",
            Model = "Wally"
        },
        {
            Name = "Messy Medium",
            Model = "Messy Medium"
        }
    },
    Height = {
        Min = 63,
        Max = 76,
        Base = 68,
        Odds = {
            {
                Min = 63,
                Max = 63,
                Weight = 5
            },
            {
                Min = 64,
                Max = 65,
                Weight = 32
            },
            {
                Min = 66,
                Max = 68,
                Weight = 41
            },
            {
                Min = 69,
                Max = 71,
                Weight = 15
            },
            {
                Min = 72,
                Max = 74,
                Weight = 6
            },
            {
                Min = 75,
                Max = 76,
                Weight = 1
            }
        }
    },
    Genders = { "Masculine", "Feminine" },
    GenderNames = {
        Masculine = "Male",
        Feminine = "Female"
    },
    FirstNames = {
        Masculine = {
            "Takeshi",
            "Haruto",
            "Ren",
            "Kaito",
            "Ryuji",
            "Daichi",
            "Kenji",
            "Akira",
            "Takumi",
            "Shinji",
            "Tatsuya",
            "Kenta",
            "Masaru",
            "Hayato",
            "Makoto",
            "Isamu",
            "Naoki",
            "Hiroshi",
            "Koji",
            "Ryota",
            "Yuto",
            "Kazuki",
            "Shota",
            "Goro",
            "Eiji",
            "Ippo",
            "Wally",
            "Ichiro",
            "Jason"
        },
        Feminine = {
            "Kumi",
            "Yuki",
            "Aiko",
            "Hana",
            "Mei",
            "Sakura",
            "Rin",
            "Yui",
            "Emi",
            "Nana",
            "Mio",
            "Saki",
            "Ayaka",
            "Misaki"
        }
    },
    LastNames = {
        "Makunouchi",
        "Takamura",
        "Miyata",
        "Sendo",
        "Mashiba",
        "Kimura",
        "Aoki",
        "Kamogawa",
        "Date",
        "Itagaki",
        "Sawamura",
        "Volg",
        "Kobashi",
        "Hayami",
        "Saeki",
        "Imai",
        "Hoshi",
        "Fujii",
        "Suzuki",
        "Tanaka",
        "Sato",
        "Nakamura",
        "Ishikawa",
        "Kurosawa",
        "Shibata",
        "Ozuma"
    }
}

function t1.FormatHeight(p56) -- line: 3437
    local v111 = math.floor((tonumber(p56) or 68) + 0.5)

    return string.format("%d'%d\"", math.floor(v111 / 12), v111 % 12)
end

function t1.HeightOf(p57) -- line: 3443
    -- upvalues: t1 (copy)
    local v113 = typeof(p57) == "Instance" and p57:GetAttribute("HeightInches")

    if type(v113) == "number" then
        return v113
    end

    return t1.Avatar.Height.Base
end

t1.HeightCombat = {
    ReachFollowsBody = 1.6,
    ShortestFull = 63,
    TallestFull = 76,
    CloseDamage = 0.18,
    CloseSpeed = 0.14,
    LongDamage = 0.12,
    CloseRange = 3.6,
    CloseFade = 0.8
}

function t1.ShortBonus(p58) -- line: 3472
    -- upvalues: t1 (copy)
    local HeightCombat = t1.HeightCombat
    local Base = t1.Avatar.Height.Base
    local v115 = math.max(Base - HeightCombat.ShortestFull, 1)

    return (math.clamp((Base - t1.HeightOf(p58)) / v115, 0, 1))
end

function t1.CloseFactor(p59) -- line: 3479
    -- upvalues: t1 (copy)
    local HeightCombat = t1.HeightCombat

    if type(p59) ~= "number" then
        return 0
    end

    return (math.clamp(1 - (p59 - HeightCombat.CloseRange) / math.max(HeightCombat.CloseFade, 0.001), 0, 1))
end

local CollectionService2 = game:GetService("CollectionService")
local Players2 = game:GetService("Players")

function t1.NearestFighterGap(p60) -- line: 3490
    -- upvalues: CollectionService2 (copy), Players2 (copy)
    local HumanoidRootPart = p60 and p60:FindFirstChild("HumanoidRootPart")

    if not HumanoidRootPart then
        return nil
    end

    local Magnitude

    local function consider(p61) -- line: 3496
        -- upvalues: p60 (copy), HumanoidRootPart (copy), Magnitude (ref)
        if p61 ~= p60 and p61 then
            local HumanoidRootPart2 = p61:FindFirstChild("HumanoidRootPart")
            local Humanoid = p61:FindFirstChildOfClass("Humanoid")

            if HumanoidRootPart2 and Humanoid and Humanoid.Health > 0 then
                local v119 = HumanoidRootPart2.Position - HumanoidRootPart.Position

                if math.abs(v119.Y) < 6 then
                    local Magnitude2 = (v119 * Vector3.new(1, 0, 1)).Magnitude

                    if not Magnitude or Magnitude2 < Magnitude then
                        Magnitude = Magnitude2
                    end
                end
            end
        end
    end

    for _, player in Players2:GetPlayers() do
        consider(player.Character)
    end

    for _, v120 in { "BoxingNPC", "BoxingDummy" } do
        for _, v121 in CollectionService2:GetTagged(v120) do
            if v121:IsA("Model") then
                consider(v121)
            end
        end
    end

    return Magnitude
end

function t1.HeightCloseSpeed(p62) -- line: 3526
    -- upvalues: t1 (copy)
    local v122 = t1.ShortBonus(p62)

    if v122 <= 0 then
        return 0
    end

    return t1.HeightCombat.CloseSpeed * v122 * t1.CloseFactor(t1.NearestFighterGap(p62))
end

function t1.TallBonus(p63) -- line: 3535
    -- upvalues: t1 (copy)
    local HeightCombat = t1.HeightCombat
    local Base = t1.Avatar.Height.Base
    local v124 = math.max((HeightCombat.TallestFull or 76) - Base, 1)

    return (math.clamp((t1.HeightOf(p63) - Base) / v124, 0, 1))
end

function t1.HeightLongDamage(p64, p65) -- line: 3541
    -- upvalues: t1 (copy)
    local HeightCombat = t1.HeightCombat

    if not HeightCombat.LongDamage or type(p65) ~= "number" then
        return 0
    end

    return HeightCombat.LongDamage * t1.TallBonus(p64) * (1 - t1.CloseFactor(p65))
end

function t1.HeightCloseDamage(p66, p67) -- line: 3550
    -- upvalues: t1 (copy)
    local v126 = t1.ShortBonus(p66)

    if v126 <= 0 then
        return 0
    end

    return t1.HeightCombat.CloseDamage * v126 * t1.CloseFactor(p67)
end

t1.ServerList = {
    Map = "HajimeServers_v1",
    Refresh = 30,
    Expire = 90
}
t1.Codes = {
    ROBES = {
        Tokens = 10
    },
    BIGUPDATE = {
        Tokens = 10
    },
    TESTING = {
        Tokens = 20,
        Expires = 1792967760
    },
    UPDATE = {
        Tokens = 5,
        Expires = 1792967760
    },
    ["UPDATE 2"] = {
        Tokens = 5,
        Expires = 1792967760
    },
    RANKED = {
        Tokens = 15,
        Expires = 1792967760
    },
    PEEKABOO = {
        Tokens = 10,
        Expires = 1792967760
    },
    PERFORMANCE = {
        Tokens = 5,
        Expires = 1792967760
    },
    MOBILEFIX = {
        Tokens = 5,
        Expires = 1792967760
    }
}
t1.CodeRules = {
    MaxLength = 30,
    Cooldown = 1.5
}
t1.LastingInjuries.Recovery = {
    Seconds = 600,
    Color = Color3.fromRGB(238, 234, 224),
    Material = Enum.Material.Fabric
}
t1.Gear = {
    ShopId = "Gear",
    Name = "Boxing Gear",
    Kana = "ボクシング用品",
    Tag = "GLOVES · SHOES · TRUNKS",
    Banner = "rbxassetid://101888091636258",
    Default = "Red",
    Cooldown = 0.4,
    Items = {
        {
            Id = "Gloves",
            Name = "Gloves",
            Price = 60000
        },
        {
            Id = "Shoes",
            Name = "Shoes",
            Price = 75000
        },
        {
            Id = "Trunks",
            Name = "Trunks",
            Price = 50000
        }
    },
    Colours = {
        {
            Id = "Red",
            Name = "Red",
            Color = Color3.fromRGB(200, 20, 24)
        },
        {
            Id = "Blue",
            Name = "Blue",
            Color = Color3.fromRGB(28, 64, 190)
        },
        {
            Id = "Black",
            Name = "Black",
            Color = Color3.fromRGB(26, 26, 30)
        },
        {
            Id = "White",
            Name = "White",
            Color = Color3.fromRGB(236, 234, 228)
        },
        {
            Id = "Gold",
            Name = "Gold",
            Color = Color3.fromRGB(214, 168, 40)
        },
        {
            Id = "Green",
            Name = "Green",
            Color = Color3.fromRGB(28, 140, 58)
        }
    }
}
t1.RankedCounter = {
    ShopId = "Ranked",
    MatchEvery = 2,
    GlobalEvery = 2,
    Tournaments = false,
    LiveMap = "HajimeRankedLive_v1",
    LiveRefresh = 8,
    LiveExpire = 25,
    SpectateRadius = 25,
    Cooldown = 1
}
t1.ProLicense = {
    UnlockAt = 30,
    Job = "Pro Boxer",
    Gym = "Kamogawa Boxing Gym",
    Item = "ProLicense",
    RequiredForRanked = true,
    Art = {
        Background = "rbxassetid://117135570902053",
        Seal = "rbxassetid://115501294930506",
        MenuIcon = "rbxassetid://85436074090124"
    }
}
t1.Stink = {
    FillMinutes = 60,
    HitWindow = 4,
    WashSeconds = 15,
    IdleOff = 10,
    WaterSound = "rbxassetid://365551014",
    WaterTexture = "http://www.roblox.com/asset/?id=242802297",
    FullNotice = "YOU STINK! Go take a shower at the gym",
    CleanNotice = "Fresh and clean!"
}
t1.MangaUI = {
    Enabled = true,
    Theme = "Navy",
    Icons = {
        Glove = "rbxassetid://134627525008182",
        Portrait = "rbxassetid://106109307153227",
        Hex = "rbxassetid://75725728181188",
        Edit = "rbxassetid://84170430065934",
        Grid = "rbxassetid://87856566268472"
    },
    MainMenu = {
        Background = 114167580851456,
        BackgroundAlt = 76927312641762,
        Glove = 106666434489287,
        Bar = 103536953660898,
        BarSliceScale = 0.45,
        Back = 92044758498878,
        BarRect = { 30, 208, 962, 158 },
        BarSlice = { 90, 25, 872, 133 },
        Icons = {
            Settings = 132740185448277,
            Shop = 127174722532265,
            Guide = 131475583825518,
            Serverlist = 109121610938481,
            Quest = 87983107592590,
            ["Avatar Creation"] = 82002175822137,
            Backpack = 95981905572198,
            Codes = 108787090310511
        }
    },
    NavyIcons = {
        Shop = "Glove",
        Backpack = "Glove",
        ["Avatar Creation"] = "Edit",
        Settings = "Edit",
        Codes = "Edit",
        Guide = "Portrait",
        Quest = "Portrait",
        Serverlist = "Portrait",
        ["Find Match"] = "Glove",
        Servers = "Portrait"
    },
    Screens = { "AvatarCreator", "SkillTreeGui", "StatsGui", "BoxingSettingsMenu", "LoadoutPicker", "MainMenu", "FrontMenu" },
    Panels = {}
}
require(script.Parent:WaitForChild("BoxingSkills")).ApplyNames(t1.Loadout.Items)

local FaceStyles = script.Parent:FindFirstChild("FaceStyles")

t1.Faces = if FaceStyles then require(FaceStyles) else {
    {
        Name = "Ippo",
        Ippo = true,
        Weight = 1
    }
}
t1.Store = {
    Products = {
        {
            Id = "Token1",
            Name = "1 Reroll Token",
            Tokens = 1,
            Robux = 5,
            Product = 3719346847,
            Icon = 107582703314569
        },
        {
            Id = "Token100",
            Name = "100 Reroll Tokens",
            Tokens = 100,
            Robux = 450,
            Product = 3719346951,
            Icon = 116502998687247
        },
        {
            Id = "Yen10K",
            Name = "¥10,000",
            Yen = 10000,
            Robux = 10,
            Product = 3719347048,
            Icon = 90834635702605
        },
        {
            Id = "Yen100K",
            Name = "¥100,000",
            Yen = 1E+05,
            Robux = 100,
            Product = 3719347127,
            Icon = 123433877464721
        },
        {
            Id = "Yen1M",
            Name = "¥1,000,000",
            Yen = 1E+06,
            Robux = 1000,
            Product = 3719347225,
            Icon = 102153681623808
        }
    },
    Passes = {
        {
            Id = "TripleHunger",
            Name = "Triple Hunger",
            Perk = true,
            Product = 3720790194,
            Robux = 150,
            Icon = 127929080025637,
            Bar = "Hunger",
            DrainScale = 0.3333333333333333
        },
        {
            Id = "TripleThirst",
            Name = "Triple Thirst",
            Perk = true,
            Product = 3720790388,
            Robux = 150,
            Icon = 93914087653820,
            Bar = "Thirst",
            DrainScale = 0.3333333333333333
        },
        {
            Id = "DoubleEnergy",
            Name = "Double Energy",
            Perk = true,
            Product = 0,
            Robux = 0,
            Bar = "Energy",
            DrainScale = 0.5
        }
    }
}

for v128, v129 in t1.TechniqueVFX do
    if v128 ~= "CorkscrewBlow" then
        local Swirl = v129.Swirl

        if Swirl and Swirl.Asset == "CorkscrewSwirl" then
            local v130 = Swirl.Colors or {}
            local BlueSpiral = v130.BlueSpiral or v130.Streaks or Swirl.LightColor
            local v131 = v130.GoldSpiral or BlueSpiral

            Swirl.Asset = "GloveSparks"
            Swirl.Scale = 1
            Swirl.Boost = nil
            Swirl.Rates = {
                Crackle = 22,
                Glow = 14,
                Streaks = 45,
                Specks = 30
            }

            if BlueSpiral then
                Swirl.Colors = {
                    Crackle = v131,
                    Glow = BlueSpiral,
                    Streaks = v130.Streaks or BlueSpiral,
                    Specks = v131
                }
            else
                Swirl.Colors = nil
            end
        end

        if v129.GloveAura and v129.GloveAura.Assets then
            for _, v132 in v129.GloveAura.Assets do
                if v132.Asset == "CorkscrewSwirl" then
                    v132.Asset = "GloveSparks"
                    v132.Scale = 0.8
                    v132.Rates = {
                        Crackle = 14,
                        Glow = 8,
                        Streaks = 25,
                        Specks = 18
                    }
                    v132.Colors = {
                        Crackle = Color3.fromRGB(255, 240, 200),
                        Glow = Color3.fromRGB(255, 190, 80),
                        Streaks = Color3.fromRGB(255, 205, 90),
                        Specks = Color3.fromRGB(255, 240, 200)
                    }
                end
            end
        end

        local Impact = v129.Impact

        if Impact and Impact.Style == "Boom" then
            Impact.Asset = "SparkBoom"
            Impact.Shell = nil

            if Impact.Ball then
                Impact.Ball = {
                    Time = 0.14,
                    Delay = 0,
                    Transparency = 0.4,
                    From = Impact.Ball.From * 0.6,
                    To = Impact.Ball.To * 0.4,
                    Color = Impact.Ball.Color,
                    Material = Enum.Material.Neon
                }
            end
        end
    end
end

if t1.HitVFX and t1.HitVFX.Techniques then
    t1.HitVFX.Techniques.Smash = nil
    t1.HitVFX.Techniques.LowSmash = nil
end

local t17 = {
    LiverBlow = Color3.fromRGB(255, 215, 40),
    WhiteFang = Color3.fromRGB(150, 220, 255),
    GazellePunch = Color3.fromRGB(255, 140, 30),
    DragonFishBlow = Color3.fromRGB(40, 230, 160),
    CrossCounter = Color3.fromRGB(255, 80, 170),
    OverhandRight = Color3.fromRGB(150, 255, 60),
    FullBodyUppercut = Color3.fromRGB(165, 90, 255),
    Smash = Color3.fromRGB(255, 45, 40),
    LowSmash = Color3.fromRGB(200, 0, 70),
    DempseyRoll = Color3.fromRGB(255, 185, 45)
}

for v133, v134 in t1.TechniqueVFX do
    if v133 ~= "CorkscrewBlow" then
        v134.Swirl = nil
        v134.GloveAura = nil

        local Impact = v134.Impact

        if Impact and Impact.Style == "Boom" then
            Impact.Asset = "PunchHit"
            Impact.Tint = t17[v133] or Color3.fromRGB(255, 255, 255)
            Impact.TintPale = Color3.fromRGB(255, 255, 255)
            Impact.Colors = nil
            Impact.Ball = nil
            Impact.Shell = nil

            if Impact.Light then
                Impact.Light.Color = Impact.Tint
            end
        end
    end
end

t1.AttackSwitch = {
    Delay = {
        Hook = 0.12,
        Uppercut = 0.2
    },
    Passives = {
        ["Alternating Hooks"] = 0.5
    }
}
t1.ComboScaling = {
    FullHits = 2,
    First = 0.8,
    Step = 0.05,
    Min = 0.5,
    ResetAfter = 2
}
t1.BodyWeight = {
    NaturalKg = 63,
    NaturalInches = 68,
    PerInch = 1.6,
    Min = 45,
    Max = 100,
    GainPerHunger = 0.03,
    OverfillAt = 70,
    ReturnPerMinute = 0.06,
    GainPerThirst = 0.008,
    BurnPerMinute = 0.02,
    TrainingBurnPerMinute = 0.15,
    StarvingBurnPerMinute = 0.5,
    DehydratedBurnPerMinute = 0.6,
    Reference = 70,
    DamagePerKg = 0.01,
    DamageMin = 0.8,
    DamageMax = 1.3,
    KnockbackPerKg = 0.012,
    KnockbackMin = 0.65,
    KnockbackMax = 1.35,
    SpeedPerKg = 0.003,
    SpeedMin = 0.9,
    SpeedMax = 1.06,
    CutStaminaPerKg = 0.025,
    CutStaminaMin = 0.7
}
t1.Sauna = {
    BurnPerMinute = 1,
    ThirstPerMinute = 10,
    DrainPerSecond = 4,
    MinStaminaShare = 0.25,
    AfterMaxStamina = 0.85,
    AfterSeconds = 120,
    MinWeightOverNatural = -6
}

function t1.NaturalWeight(p68) -- line: 3900
    -- upvalues: t1 (copy)
    local BodyWeight = t1.BodyWeight

    return math.floor(math.clamp(BodyWeight.NaturalKg + ((tonumber(p68) or BodyWeight.NaturalInches) - BodyWeight.NaturalInches) * BodyWeight.PerInch, BodyWeight.Min, BodyWeight.Max) * 10 + 0.5) / 10
end

function t1.WeightOf(p69) -- line: 3907
    if typeof(p69) ~= "Instance" then
        return nil, nil
    end

    local v137 = if p69:IsA("Player") then p69 else game:GetService("Players"):GetPlayerFromCharacter(p69)
    local v138 = v137 and tonumber(v137:GetAttribute("BodyWeight"))

    if v138 then
        return v138, tonumber(v137:GetAttribute("NaturalWeight")) or v138
    end

    return nil, nil
end

local function weightScale(p70, p71, p72, p73, p74) -- line: 3919
    -- upvalues: t1 (copy)
    local v139 = t1.WeightOf(p70)

    if not v139 then
        return 1
    end

    return (math.clamp(1 + p74 * (v139 - t1.BodyWeight.Reference) * p71, p72, p73))
end

function t1.WeightDamage(p75) -- line: 3926
    -- upvalues: t1 (copy)
    local BodyWeight = t1.BodyWeight
    local DamagePerKg, DamageMin, DamageMax = BodyWeight.DamagePerKg, BodyWeight.DamageMin, BodyWeight.DamageMax
    local v141 = t1.WeightOf(p75)

    if not v141 then
        return 1
    end

    return (math.clamp(1 + 1 * (v141 - t1.BodyWeight.Reference) * DamagePerKg, DamageMin, DamageMax))
end

function t1.WeightKnockbackTaken(p76) -- line: 3930
    -- upvalues: t1 (copy)
    local BodyWeight = t1.BodyWeight
    local KnockbackPerKg, KnockbackMin, KnockbackMax = BodyWeight.KnockbackPerKg, BodyWeight.KnockbackMin, BodyWeight.KnockbackMax
    local v143 = t1.WeightOf(p76)

    if not v143 then
        return 1
    end

    return (math.clamp(1 + -1 * (v143 - t1.BodyWeight.Reference) * KnockbackPerKg, KnockbackMin, KnockbackMax))
end

function t1.WeightSpeed(p77) -- line: 3934
    -- upvalues: t1 (copy)
    local BodyWeight = t1.BodyWeight
    local SpeedPerKg, SpeedMin, SpeedMax = BodyWeight.SpeedPerKg, BodyWeight.SpeedMin, BodyWeight.SpeedMax
    local v145 = t1.WeightOf(p77)

    if not v145 then
        return 1
    end

    return (math.clamp(1 + -1 * (v145 - t1.BodyWeight.Reference) * SpeedPerKg, SpeedMin, SpeedMax))
end

function t1.WeightStaminaScale(p78) -- line: 3938
    -- upvalues: t1 (copy)
    local BodyWeight = t1.BodyWeight
    local v147, v148 = t1.WeightOf(p78)

    if not v147 or v148 <= v147 then
        return 1
    end

    return (math.max(BodyWeight.CutStaminaMin, 1 - (v148 - v147) * BodyWeight.CutStaminaPerKg))
end

t1.Quests = {
    DataStore = "Quests_v1",
    Daily = {
        Count = 3,
        Pool = {
            {
                Id = "D_Land",
                Text = "Land %d punches in fights",
                Event = "Landed",
                Goal = 60,
                Yen = 3000
            },
            {
                Id = "D_Dodge",
                Text = "Slip %d punches with a weave",
                Event = "Dodge",
                Goal = 10,
                Yen = 3000
            },
            {
                Id = "D_Train",
                Text = "Gain stats from %d training reps",
                Event = "Train",
                Goal = 40,
                Yen = 2500
            },
            {
                Id = "D_Bout",
                Text = "Finish %d spar or ranked bout",
                Event = "Bout",
                Goal = 1,
                Yen = 4000
            },
            {
                Id = "D_Eat",
                Text = "Eat or drink %d times",
                Event = "Eat",
                Goal = 4,
                Yen = 1500
            },
            {
                Id = "D_KD",
                Text = "Score %d knockdown",
                Event = "Knockdown",
                Goal = 1,
                Yen = 5000,
                Tokens = 1
            }
        }
    },
    Weekly = {
        Count = 3,
        Pool = {
            {
                Id = "W_Ranked",
                Text = "Win %d ranked bouts",
                Event = "RankedWin",
                Goal = 3,
                Yen = 15000,
                Tokens = 3
            },
            {
                Id = "W_Bouts",
                Text = "Finish %d bouts",
                Event = "Bout",
                Goal = 8,
                Yen = 10000,
                Tokens = 2
            },
            {
                Id = "W_Land",
                Text = "Land %d punches in fights",
                Event = "Landed",
                Goal = 600,
                Yen = 10000,
                Tokens = 2
            },
            {
                Id = "W_Train",
                Text = "Gain stats from %d training reps",
                Event = "Train",
                Goal = 300,
                Yen = 12000
            },
            {
                Id = "W_KD",
                Text = "Score %d knockdowns",
                Event = "Knockdown",
                Goal = 5,
                Yen = 8000,
                Tokens = 2
            }
        }
    }
}

return t1
