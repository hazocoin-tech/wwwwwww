-- https://lua.expert

local Players = game:GetService("Players")
local BoxingConfig = require(script.Parent:WaitForChild("BoxingConfig"))
local t1 = {}
local t2 = {}

for v1, v2 in BoxingConfig.Stats.Subs do
    for v3, v4 in v2 do
        t2[v4] = {
            v1,
            if v3 == 1 then "A" else "B"
        }
    end
end

local function holder(p1) -- line: 17
    -- upvalues: Players (copy)
    return if typeof(p1) == "Instance" then not p1:IsA("Player") and Players:GetPlayerFromCharacter(p1) or p1 else nil
end

function t1.Get(p2, p3) -- line: 28
    -- upvalues: Players (copy), t2 (copy)
    local v6 = t2[p3]
    local v7 = if typeof(p2) == "Instance" then not p2:IsA("Player") and Players:GetPlayerFromCharacter(p2) or p2 else nil

    if not v6 or not v7 then
        return 0
    end

    return tonumber(v7:GetAttribute("Stat_" .. v6[1] .. "_" .. v6[2])) or 0
end

local function E() -- line: 37
    -- upvalues: BoxingConfig (copy)
    return BoxingConfig.StatEffects
end

function t1.Lasting(p4, p5) -- line: 44
    -- upvalues: Players (copy)
    local v9 = if typeof(p4) == "Instance" then not p4:IsA("Player") and Players:GetPlayerFromCharacter(p4) or p4 else nil
    local v10 = v9 and v9:GetAttribute("LI_" .. p5)

    if type(v10) == "number" and v10 > 0 then
        return v10
    end

    return 1
end

function t1.BloodthirstActive(p6) -- line: 51
    if typeof(p6) ~= "Instance" then
        return false
    end

    local v11 = if p6:IsA("Player") then p6.Character else p6

    return v11 ~= nil and (v11:GetAttribute("BloodthirstUntil") or 0) > workspace:GetServerTimeNow()
end

local function bloodthirstBoost(p7, p8) -- line: 59
    -- upvalues: BoxingConfig (copy), t1 (copy)
    local v12 = BoxingConfig.WillpowerEffects or {}

    return t1.BloodthirstActive(p7) and v12[p8] or 0
end

function t1.DamageMultiplier(p9, p10) -- line: 65
    -- upvalues: BoxingConfig (copy), t1 (copy)
    local StatEffects = BoxingConfig.StatEffects
    local v13 = t1.Get(p9, "Leg Strength")
    local v14 = 1 + StatEffects.ArmDamagePerPoint * t1.Get(p9, "Arm Strength")
    local v15 = BoxingConfig.WillpowerEffects or {}
    local v16 = v14 * (1 + (t1.BloodthirstActive(p9) and v15.BloodthirstStrength or 0)) * t1.Lasting(p9, "PunchDamage") * (1 + (StatEffects.LegAllDamagePerPoint or 0) * v13)

    if p10 and (p10.Anim == "Uppercut" or p10.Anim == "Hook") then
        return v16 * (1 + StatEffects.LegUppercutDamagePerPoint * v13)
    end

    return v16
end

function t1.TechniqueLegMultiplier(p11) -- line: 82
    -- upvalues: BoxingConfig (copy), t1 (copy)
    local StatEffects = BoxingConfig.StatEffects
    local v17 = t1.Get(p11, "Leg Strength")
    local v18 = t1.Get(p11, "Arm Strength")

    return (1 + (StatEffects.LegTechniquePerPoint or 0) * v17) * (1 + (StatEffects.ArmLegTechniquePerPoint or 0) * v18 * v17)
end

function t1.RecoveryFactor(p12) -- line: 90
    local RecoverStart = p12:GetAttribute("RecoverStart")
    local RecoverUntil = p12:GetAttribute("RecoverUntil")

    if not RecoverStart or not RecoverUntil or RecoverUntil <= RecoverStart then
        return 0
    end

    local v19 = (workspace:GetServerTimeNow() - RecoverStart) / (RecoverUntil - RecoverStart)

    if v19 >= 1 or v19 < 0 then
        return 0
    end

    return (1 - v19) ^ 1.5
end

local v20

local function statusValues() -- line: 105
    -- upvalues: v20 (ref)
    if not v20 then
        local BoxingPassives = script.Parent:FindFirstChild("BoxingPassives")

        v20 = BoxingPassives and require(BoxingPassives).Values or {}
    end

    return v20
end

local function statusOn(p13, p14) -- line: 112
    if typeof(p13) == "Instance" then
        return (p13:GetAttribute(p14) or 0) > workspace:GetServerTimeNow()
    end

    return false
end

local function recoveryParams(p15) -- line: 116
    -- upvalues: BoxingConfig (copy)
    return BoxingConfig.RecoveryParams and BoxingConfig.RecoveryParams(p15:GetAttribute("RecoverDifficulty") or 0) or {}
end

function t1.PunchTimeMultiplier(p16) -- line: 121
    -- upvalues: BoxingConfig (copy), t1 (copy), v20 (ref)
    local v21 = t1.RecoveryFactor(p16)
    local v22 = if v21 > 0 then 1 + ((BoxingConfig.RecoveryParams and BoxingConfig.RecoveryParams(p16:GetAttribute("RecoverDifficulty") or 0) or {}).PunchSlow or 0) * v21 else 1

    if not v20 then
        local BoxingPassives = script.Parent:FindFirstChild("BoxingPassives")

        v20 = BoxingPassives and require(BoxingPassives).Values or {}
    end

    local v23 = v20

    if typeof(p16) == "Instance" and (p16:GetAttribute("WindedUntil") or 0) > workspace:GetServerTimeNow() and v23.Winded then
        v22 *= v23.Winded.PunchSlow
    end

    if typeof(p16) == "Instance" and (p16:GetAttribute("DazedUntil") or 0) > workspace:GetServerTimeNow() and v23.Daze then
        v22 *= v23.Daze.PunchSlow
    end

    local v24 = if typeof(p16) ~= "Instance" or not p16:IsA("Model") then 0 else BoxingConfig.HeightCloseSpeed(p16)
    local v25 = 1 + BoxingConfig.StatEffects.PunchSpeedPerPoint * t1.Get(p16, "Punch Speed")
    local v26 = BoxingConfig.WillpowerEffects or {}

    return v22 / (v25 * (1 + (t1.BloodthirstActive(p16) and v26.BloodthirstSpeed or 0)) * (1 + v24))
end

function t1.SpeedMultiplier(p17) -- line: 137
    -- upvalues: BoxingConfig (copy), t1 (copy), v20 (ref)
    local v27 = t1.RecoveryFactor(p17)
    local v28 = if v27 > 0 then 1 - ((BoxingConfig.RecoveryParams and BoxingConfig.RecoveryParams(p17:GetAttribute("RecoverDifficulty") or 0) or {}).WalkSlow or 0) * v27 else 1

    if not v20 then
        local BoxingPassives = script.Parent:FindFirstChild("BoxingPassives")

        v20 = BoxingPassives and require(BoxingPassives).Values or {}
    end

    local v29 = v20

    if typeof(p17) == "Instance" and (p17:GetAttribute("DazedUntil") or 0) > workspace:GetServerTimeNow() and v29.Daze then
        v28 *= v29.Daze.WalkMultiplier
    end

    if typeof(p17) == "Instance" and p17:GetAttribute("RibCracked") and BoxingConfig.Injuries then
        v28 *= BoxingConfig.Injuries.Torso.Rib.Walk
    end

    local v30 = v28 * t1.Lasting(p17, "WalkSpeed")
    local v31 = BoxingConfig.WillpowerEffects or {}

    return (1 + (t1.BloodthirstActive(p17) and v31.BloodthirstSpeed or 0)) * v30
end

function t1.DazeMultiplier(p18) -- line: 152
    -- upvalues: BoxingConfig (copy), t1 (copy)
    local v32 = BoxingConfig.WillpowerEffects or {}

    return (math.max(v32.CourageDazeMin or 0.5, 1 - (v32.CourageDazePerPoint or 0) * t1.Get(p18, "Courage")))
end

function t1.DashSpeedMultiplier(p19) -- line: 157
    -- upvalues: BoxingConfig (copy), t1 (copy)
    return 1 + BoxingConfig.StatEffects.LegDashSpeedPerPoint * t1.Get(p19, "Leg Strength")
end

function t1.WalkBonus(p20) -- line: 162
    -- upvalues: BoxingConfig (copy), t1 (copy)
    local StatEffects = BoxingConfig.StatEffects

    return StatEffects.FootworkWalkPerPoint * math.min(t1.Get(p20, "Footwork"), StatEffects.FootworkWalkCap)
end

function t1.SlowResist(p21) -- line: 168
    -- upvalues: BoxingConfig (copy), t1 (copy)
    local StatEffects = BoxingConfig.StatEffects
    local v36 = math.max(0, t1.Get(p21, "Footwork") - StatEffects.FootworkWalkCap)
    local v38 = math.max(0.001, (BoxingConfig.Stats.SubMax or 10) - StatEffects.FootworkWalkCap)

    return StatEffects.FootworkSlowResistMax * math.clamp(v36 / v38, 0, 1)
end

function t1.WeaveStartupBonus(p22) -- line: 176
    -- upvalues: BoxingConfig (copy), t1 (copy)
    return BoxingConfig.StatEffects.FootworkWeaveStartupPerPoint * t1.Get(p22, "Footwork")
end

function t1.WeaveTimeMultiplier(p23) -- line: 184
    -- upvalues: BoxingConfig (copy), t1 (copy), v20 (ref)
    local v40 = 1 + (BoxingConfig.StatEffects.FootworkWeaveSpeedPerPoint or 0) * t1.Get(p23, "Footwork")

    if not v20 then
        local BoxingPassives = script.Parent:FindFirstChild("BoxingPassives")

        v20 = BoxingPassives and require(BoxingPassives).Values or {}
    end

    local HeadSlip = v20.HeadSlip

    if HeadSlip and HeadSlip.WeaveSpeed and typeof(p23) == "Instance" then
        local BoxingPassives = script.Parent:FindFirstChild("BoxingPassives")

        if BoxingPassives and require(BoxingPassives).Has(p23, "Head Slip") then
            v40 *= HeadSlip.WeaveSpeed
        end
    end

    return 1 / v40
end

function t1.StunResist(p24) -- line: 198
    -- upvalues: BoxingConfig (copy), t1 (copy)
    return (BoxingConfig.StatEffects.FootworkStunResistMax or 0) * math.clamp(t1.Get(p24, "Footwork") / (BoxingConfig.Stats.SubMax or 10), 0, 1)
end

function t1.StunMultiplier(p25) -- line: 204
    -- upvalues: BoxingConfig (copy), t1 (copy)
    return 1 + BoxingConfig.StatEffects.SharpnessStunPerPoint * t1.Get(p25, "Punch Sharpness")
end

function t1.SharpnessDamageMultiplier(p26, p27) -- line: 210
    -- upvalues: BoxingConfig (copy), t1 (copy)
    return 1 + (BoxingConfig.StatEffects.SharpnessDamagePerPoint or 0) * t1.Get(p26, "Punch Sharpness") * math.clamp(tonumber(p27) or 0, 0, 1)
end

function t1.SharpnessGuardMultiplier(p28) -- line: 214
    -- upvalues: BoxingConfig (copy), t1 (copy)
    return 1 + (BoxingConfig.StatEffects.SharpnessGuardDamagePerPoint or 0) * t1.Get(p28, "Punch Sharpness")
end

function t1.SharpnessInjuryMultiplier(p29) -- line: 218
    -- upvalues: BoxingConfig (copy), t1 (copy)
    return 1 + (BoxingConfig.StatEffects.SharpnessInjuryPerPoint or 0) * t1.Get(p29, "Punch Sharpness")
end

function t1.SkillCooldownMultiplier(p30) -- line: 224
    -- upvalues: BoxingConfig (copy), t1 (copy)
    local StatEffects = BoxingConfig.StatEffects

    return (math.max(StatEffects.SkillMasteryMinCooldown or 0.7, 1 - StatEffects.SkillMasteryCooldownPerPoint * t1.Get(p30, "Skill Mastery")))
end

function t1.SkillDamageMultiplier(p31) -- line: 229
    -- upvalues: BoxingConfig (copy), t1 (copy)
    return 1 + (BoxingConfig.StatEffects.SkillMasteryDamagePerPoint or 0) * t1.Get(p31, "Skill Mastery")
end

function t1.SkillStunMultiplier(p32) -- line: 232
    -- upvalues: BoxingConfig (copy), t1 (copy)
    return 1 + (BoxingConfig.StatEffects.SkillMasteryStunPerPoint or 0) * t1.Get(p32, "Skill Mastery")
end

local function torsoInjury(p33, p34) -- line: 238
    -- upvalues: BoxingConfig (copy)
    local InjTorso = typeof(p33) == "Instance" and p33:GetAttribute("InjTorso") or nil
    local v47 = InjTorso and BoxingConfig.Injuries and BoxingConfig.Injuries.Torso[p34]

    return v47 and v47[InjTorso] or 1
end

function t1.StaminaCostMultiplier(p35) -- line: 244
    -- upvalues: BoxingConfig (copy), t1 (copy)
    local StatEffects = BoxingConfig.StatEffects
    local v48 = StatEffects.DrainPerPoint * t1.Get(p35, "Drain Resistance") + StatEffects.FatigueDrainPerPoint * t1.Get(p35, "Fatigue Resistance")
    local v50 = math.max(StatEffects.MinStaminaCostMultiplier, 1 - v48)
    local InjTorso = typeof(p35) == "Instance" and p35:GetAttribute("InjTorso") or nil
    local v51 = InjTorso and BoxingConfig.Injuries and BoxingConfig.Injuries.Torso.StaminaCost

    return v50 * (v51 and v51[InjTorso] or 1)
end

function t1.PunchStaminaMultiplier(p36) -- line: 252
    -- upvalues: t1 (copy)
    return t1.StaminaCostMultiplier(p36) * t1.Lasting(p36, "PunchCost")
end

function t1.StaminaRegenMultiplier(p37) -- line: 257
    -- upvalues: t1 (copy)
    return t1.Lasting(p37, "StaminaRegen")
end

function t1.BlockCostMultiplier(p38) -- line: 261
    -- upvalues: t1 (copy)
    return t1.Lasting(p38, "BlockCost")
end

function t1.GuardRegenMultiplier(p39) -- line: 266
    -- upvalues: BoxingConfig (copy), t1 (copy)
    return 1 + (BoxingConfig.StatEffects.GuardRegenPerPoint or 0) * t1.Get(p39, "Guard Endurance")
end

function t1.LowStaminaRegenMultiplier(p40, p41) -- line: 271
    -- upvalues: BoxingConfig (copy), t1 (copy)
    local StatEffects = BoxingConfig.StatEffects

    if (tonumber(p41) or 1) >= (StatEffects.FatigueLowRegenBelow or 0.3) then
        return 1
    end

    return 1 + (StatEffects.FatigueLowRegenPerPoint or 0) * t1.Get(p40, "Fatigue Resistance")
end

function t1.GuardMax(p42) -- line: 279
    -- upvalues: BoxingConfig (copy), t1 (copy)
    return BoxingConfig.Guard.Max * (1 + BoxingConfig.StatEffects.GuardPerPoint * t1.Get(p42, "Guard Endurance"))
end

function t1.StaminaMax(p43) -- line: 285
    -- upvalues: BoxingConfig (copy), t1 (copy)
    local v52 = t1.Get(p43, "Drain Resistance") + t1.Get(p43, "Fatigue Resistance")
    local MaxPerWholePoint = BoxingConfig.StaminaGrowth and BoxingConfig.StaminaGrowth.MaxPerWholePoint or 0
    local v53 = if BoxingConfig.WeightStaminaScale then BoxingConfig.WeightStaminaScale(p43) else 1
    local v54 = if typeof(p43) ~= "Instance" or not p43:IsA("Player") then p43 else p43.Character
    local v55 = if typeof(v54) == "Instance" and v54:GetAttribute("SaunaFatigue") and BoxingConfig.Sauna then BoxingConfig.Sauna.AfterMaxStamina else 1

    return BoxingConfig.Stamina.Max * (1 + MaxPerWholePoint * v52) * t1.Lasting(p43, "MaxStamina") * v53 * v55
end

function t1.RunStaminaMultiplier(p44) -- line: 296
    -- upvalues: BoxingConfig (copy), t1 (copy)
    local StaminaGrowth = BoxingConfig.StaminaGrowth

    if StaminaGrowth and StaminaGrowth.RunStaminaMultiplier then
        local v59 = math.clamp((t1.Get(p44, "Drain Resistance") + t1.Get(p44, "Fatigue Resistance")) / math.max(StaminaGrowth.RunStaminaFromPoint or 1, 0.01), 0, 1)

        return 1 + (StaminaGrowth.RunStaminaMultiplier - 1) * v59
    end

    return 1
end

function t1.MaxHealth(p45) -- line: 307
    -- upvalues: BoxingConfig (copy), t1 (copy)
    local StatEffects = BoxingConfig.StatEffects
    local v60 = if typeof(p45) ~= "Instance" or not p45:IsA("Player") then p45 else p45.Character
    local v61 = if typeof(v60) == "Instance" then tonumber(v60:GetAttribute("RoundMaxShare")) else nil

    return StatEffects.BaseMaxHealth * (1 + StatEffects.TorsoHealthPerPoint * t1.Get(p45, "Torso Endurance")) * t1.Lasting(p45, "MaxHealth") * math.clamp(v61 or 1, 0.05, 1)
end

local function W() -- line: 317
    -- upvalues: BoxingConfig (copy)
    return BoxingConfig.WillpowerEffects or {}
end

local function healthFraction(p46) -- line: 321
    local v64 = typeof(p46) == "Instance" and p46:IsA("Model") and p46:FindFirstChildOfClass("Humanoid")

    if not v64 or v64.MaxHealth <= 0 then
        return 1
    end

    return (math.clamp(v64.Health / v64.MaxHealth, 0, 1))
end

function t1.CourageDamageTaken(p47) -- line: 330
    -- upvalues: BoxingConfig (copy), t1 (copy)
    local v66 = BoxingConfig.WillpowerEffects or {}
    local v67 = typeof(p47) == "Instance" and p47:IsA("Model") and p47:FindFirstChildOfClass("Humanoid")

    if (if not v67 or v67.MaxHealth <= 0 then 1 else math.clamp(v67.Health / v67.MaxHealth, 0, 1)) > (v66.CourageLowHealth or 0.35) then
        return 1
    end

    return 1 - math.min(v66.CourageReductionMax or 0.3, (v66.CourageReductionPerPoint or 0) * t1.Get(p47, "Courage"))
end

function t1.ProcChance(p48, p49) -- line: 341
    -- upvalues: BoxingConfig (copy), t1 (copy)
    local v72 = BoxingConfig.WillpowerEffects or {}
    local v74 = math.max(t1.Get(p48, p49), 0)
    local v75 = (v72.ProcBase or 0.01) + (v72.ProcPerTenth or 0.01) * (v74 / 0.1)

    return (math.min(v72.ProcMax or 0.6, v75))
end

function t1.IsDetermined(p50) -- line: 349
    return p50 ~= nil and (p50:GetAttribute("DeterminationUntil") or 0) > workspace:GetServerTimeNow()
end

function t1.DeterminationDamageTaken(p51) -- line: 354
    -- upvalues: BoxingConfig (copy), t1 (copy)
    if t1.IsDetermined(p51) then
        return (BoxingConfig.WillpowerEffects or {}).DeterminationDamageTaken or 0.7
    end

    return 1
end

function t1.GetUpTimeMultiplier(p52) -- line: 362
    -- upvalues: BoxingConfig (copy), t1 (copy)
    local v77 = BoxingConfig.WillpowerEffects or {}

    return (math.max(v77.CourageGetUpMin or 0.6, 1 - (v77.CourageGetUpPerPoint or 0) * t1.Get(p52, "Courage")))
end

function t1.BloodthirstDamage(p53, p54) -- line: 368
    -- upvalues: BoxingConfig (copy), t1 (copy)
    local v80 = BoxingConfig.WillpowerEffects or {}
    local v81 = typeof(p54) == "Instance" and p54:IsA("Model") and p54:FindFirstChildOfClass("Humanoid")
    local v87 = math.clamp((1 - (if not v81 or v81.MaxHealth <= 0 then 1 else math.clamp(v81.Health / v81.MaxHealth, 0, 1))) / math.max(0.01, 1 - (v80.BloodthirstFullAt or 0.3)), 0, 1)

    return 1 + (v80.BloodthirstDamagePerPoint or 0) * t1.Get(p53, "Bloodthirst") * v87
end

function t1.BloodthirstStamina(p55, p56) -- line: 375
    -- upvalues: BoxingConfig (copy), t1 (copy)
    local v88 = BoxingConfig.WillpowerEffects or {}

    if (tonumber(p56) or 0) < (v88.BloodthirstMinClean or 0.5) then
        return 0
    end

    return (v88.BloodthirstStaminaPerPoint or 0) * t1.Get(p55, "Bloodthirst")
end

return t1
