-- https://lua.expert

local HttpService = game:GetService("HttpService")
local t1 = {
    StartPoints = 5,
    Default = { "Boxing Basics" },
    DataStore = "BoxingSkills_v1",
    StatOrder = { "Power", "Endurance", "Stamina", "Speed", "Technique", "Willpower" },
    StatColors = {
        Power = Color3.fromRGB(226, 72, 72),
        Endurance = Color3.fromRGB(236, 146, 52),
        Stamina = Color3.fromRGB(236, 206, 62),
        Speed = Color3.fromRGB(72, 156, 236),
        Technique = Color3.fromRGB(86, 196, 96),
        Willpower = Color3.fromRGB(168, 96, 222)
    },
    Themes = {
        Grey = {
            Box = Color3.fromRGB(122, 122, 124),
            Edge = Color3.fromRGB(80, 80, 82),
            Title = Color3.fromRGB(200, 200, 202)
        },
        Blue = {
            Box = Color3.fromRGB(64, 104, 150),
            Edge = Color3.fromRGB(36, 64, 100),
            Title = Color3.fromRGB(122, 164, 210)
        },
        Green = {
            Box = Color3.fromRGB(58, 132, 110),
            Edge = Color3.fromRGB(32, 86, 70),
            Title = Color3.fromRGB(118, 192, 168)
        },
        Purple = {
            Box = Color3.fromRGB(106, 70, 146),
            Edge = Color3.fromRGB(66, 40, 98),
            Title = Color3.fromRGB(168, 132, 210)
        },
        Olive = {
            Box = Color3.fromRGB(110, 114, 62),
            Edge = Color3.fromRGB(54, 58, 30),
            Title = Color3.fromRGB(150, 156, 94)
        },
        Forest = {
            Box = Color3.fromRGB(70, 110, 62),
            Edge = Color3.fromRGB(34, 60, 30),
            Title = Color3.fromRGB(112, 158, 100)
        },
        Taupe = {
            Box = Color3.fromRGB(122, 112, 102),
            Edge = Color3.fromRGB(64, 58, 52),
            Title = Color3.fromRGB(170, 160, 148)
        },
        Khaki = {
            Box = Color3.fromRGB(118, 108, 64),
            Edge = Color3.fromRGB(60, 54, 30),
            Title = Color3.fromRGB(166, 156, 104)
        },
        Brown = {
            Box = Color3.fromRGB(112, 90, 80),
            Edge = Color3.fromRGB(60, 44, 38),
            Title = Color3.fromRGB(160, 132, 118)
        },
        Tan = {
            Box = Color3.fromRGB(150, 128, 100),
            Edge = Color3.fromRGB(70, 60, 50),
            Title = Color3.fromRGB(172, 152, 124)
        },
        Mauve = {
            Box = Color3.fromRGB(150, 110, 110),
            Edge = Color3.fromRGB(72, 52, 54),
            Title = Color3.fromRGB(172, 132, 132)
        },
        Ochre = {
            Box = Color3.fromRGB(118, 100, 62),
            Edge = Color3.fromRGB(58, 48, 30),
            Title = Color3.fromRGB(140, 122, 80)
        },
        Rust = {
            Box = Color3.fromRGB(120, 86, 62),
            Edge = Color3.fromRGB(60, 40, 28),
            Title = Color3.fromRGB(142, 106, 80)
        },
        Crimson = {
            Box = Color3.fromRGB(122, 58, 58),
            Edge = Color3.fromRGB(64, 28, 30),
            Title = Color3.fromRGB(142, 76, 76)
        }
    },
    List = {
        ["Boxing Basics"] = {
            Type = "Foundation",
            Display = "Boxing Basics",
            Branch = "Orthodox",
            Category = "Basics",
            Theme = "Grey",
            Description = "Basic training in boxing, involving jabs, straights, and blocking.",
            Cost = 0,
            Stats = {},
            Requires = {}
        },
        ["Technique Cancel"] = {
            Type = "Passive",
            Display = "Technique Cancel",
            Branch = "Orthodox",
            Category = "Technique",
            Theme = "Grey",
            Description = "Press a long technique's key again while it's going to stop it early. The cooldown still applies. Works on the Dempsey Roll, Shotgun and Hedgehog.",
            Cost = 1,
            Stats = {},
            Requires = { "Boxing Basics" }
        },
        ["Double Jab"] = {
            Type = "Passive",
            Display = "Double Jab",
            Branch = "Orthodox",
            Category = "Offensive",
            Theme = "Grey",
            Description = "A common boxer technique is to follow a jab with a second jab, in order to pressure your opponents guard or to create space. Unlocking allows up to 2 jabs to be thrown in a row without being affected by the 'Repeat Punch' speed debuff.",
            Cost = 1,
            Stats = {
                Speed = 0.5,
                Technique = 0.5
            },
            Requires = { "Boxing Basics" }
        },
        ["Turtle Strategy"] = {
            Type = "Passive",
            Display = "Turtle Strategy",
            Branch = "Outboxer",
            Category = "Mobility",
            Theme = "Blue",
            Description = "Holding block now increases stamina regen slightly.",
            Cost = 1,
            Stats = {
                Endurance = 0.5,
                Stamina = 0.5
            },
            Requires = { "Boxing Basics" }
        },
        ["Outboxer Dash"] = {
            Type = "Dash",
            Display = "Outboxer",
            Branch = "Outboxer",
            Category = "Dash",
            Theme = "Blue",
            Description = "A dashing style consisting of mainly footwork to create space between the opponent and to land jabs and straights. Unlocks the 'Outboxer' dash set.",
            Cost = 2,
            Grants = "OutboxerDash",
            Stats = {
                Stamina = 1,
                Speed = 1,
                Technique = 1
            },
            Requires = { "Turtle Strategy" }
        },
        ["Footwork Foundation"] = {
            Type = "Passive",
            Display = "Footwork Foundation",
            Branch = "Outboxer",
            Category = "Mobility",
            Theme = "Blue",
            Description = "An understanding of basic boxing footwork. Unlocking makes it harder to get 'Winded' from body blows.",
            Cost = 2,
            Stats = {
                Speed = 1,
                Technique = 1
            },
            Requires = { "Outboxer Dash" }
        },
        ["Orthodox Outboxer Style"] = {
            Type = "Stance",
            Display = "Outboxer",
            Branch = "Outboxer",
            Category = "Stance",
            Theme = "Blue",
            Description = "An orthodox outboxing stance, used by boxers who keep a distance with precise footwork. Using this stance gives a buff to right-handed straight punches.",
            Cost = 3,
            Grants = "OutboxerStance",
            Stats = {
                Stamina = 2,
                Speed = 2,
                Technique = 2
            },
            Requires = { "Clinching", "Footwork Foundation" }
        },
        ["Drive-By Jab"] = {
            Type = "Passive",
            Display = "Drive-By Jab",
            Branch = "Outboxer",
            Category = "Mobility",
            Theme = "Blue",
            Description = "A skilled inboxer can weave in jabs while they strafe their opponent. Unlocking allows you to move while using jabs (in the Orthodox, Outboxer, Hitman and Philly Shell stances).",
            Cost = 4,
            Stats = {
                Speed = 3,
                Technique = 3
            },
            Requires = { "Orthodox Outboxer Style" }
        },
        Clinching = {
            Type = "Technique",
            Display = "Clinching",
            Branch = "Orthodox",
            Category = "Technique",
            Theme = "Grey",
            Description = "A rough form of grappling and occurs when the distance between both fighters has closed and most orthodox punches cannot be employed. Unlocks the technique 'Clinching'.",
            Cost = 2,
            Grants = "Clinch",
            Stats = {
                Stamina = 1,
                Technique = 1
            },
            Requires = { "Turtle Strategy" }
        },
        ["Cross Arm Guard"] = {
            Type = "Guard",
            Display = "Cross Arm",
            Branch = "Orthodox",
            Category = "Guard",
            Theme = "Grey",
            Description = "A guard where the leading arm is crossed over the other arm. It's known to be very durable and is mainly used against uppercuts.",
            Cost = 2,
            Grants = "CrossArmGuard",
            Stats = {
                Endurance = 2,
                Stamina = 1,
                Technique = 1
            },
            Requires = { "Clinching" }
        },
        Weaving = {
            Type = "Mode",
            Display = "Weaving",
            Branch = "Orthodox",
            Category = "Defensive",
            Theme = "Green",
            Description = "Unlocks weaving mode, which allows you to weave out of the way of incoming punches. Hold 'Space' to enter 'Weaving Mode' and use WASD. Weave away from a hook or duck under it, and lean back or to the side from an uppercut, to slip it.",
            Cost = 1,
            Stats = {
                Endurance = 0.5,
                Speed = 0.5
            },
            Requires = { "Boxing Basics" }
        },
        ["Guard Weaving"] = {
            Type = "Passive",
            Display = "Guard Weaving",
            Branch = "Orthodox",
            Category = "Defensive",
            Theme = "Green",
            Description = "With a little endurance training, a boxer can keep a tight guard while weaving. Unlocking allows you to block during weaving.",
            Cost = 2,
            Stats = {
                Endurance = 2,
                Speed = 2
            },
            Requires = { "Weaving", "Turtle Strategy" }
        },
        ["Peek a Boo Style"] = {
            Type = "Stance",
            Display = "Peek-a-Boo",
            Branch = "Defensive Infighter",
            Category = "Stance",
            Theme = "Green",
            Description = "An infighter stance where the user maintains a low centre of gravity whilst using their elbows to block their stomach area and both fists to cover the chin. Using this stance buffs the power of body blows.",
            Cost = 3,
            Grants = "PeekABooStance",
            Stats = {
                Endurance = 4,
                Stamina = 3
            },
            Requires = { "Guard Weaving" }
        },
        ["Slip Counter"] = {
            Type = "Passive",
            Display = "Slip Counter",
            Branch = "Peek a Boo Style",
            Category = "Offensive",
            Theme = "Green",
            Description = "While holding a weave you can throw one punch out of it (one per weave). Counters do 20% more damage, and a punch that lands within 1.2s of slipping a punch does 25% more (the bigger one counts).",
            Cost = 3,
            Stats = {
                Speed = 3,
                Technique = 3
            },
            Requires = { "Guard Bobbing" }
        },
        ["Guard Bobbing"] = {
            Type = "Passive",
            Display = "Guard Bobbing",
            Branch = "Peek a Boo Style",
            Category = "Defensive",
            Theme = "Green",
            Description = "Weaving while blocking now has a small window of iframes on startup",
            Cost = 3,
            Stats = {
                Endurance = 4,
                Stamina = 3,
                Speed = 3,
                Technique = 1
            },
            Requires = { "Peek a Boo Style" }
        },
        ["Dempsey Roll"] = {
            Type = "Technique",
            Display = "Dempsey Roll",
            Branch = "Peek a Boo Style",
            Category = "Technique",
            Theme = "Green",
            Description = "A vicious barrage attack which the duration and windup scales off of leg training.",
            Cost = 4,
            Grants = "DempseyRoll",
            Stats = {
                Endurance = 4,
                Stamina = 3,
                Speed = 4,
                Technique = 3,
                Willpower = 2
            },
            Requires = { "Guard Bobbing" }
        },
        ["The Legendary Combination"] = {
            Type = "Passive",
            Display = "The Legendary Combination",
            Branch = "Peek a Boo Style",
            Category = "Offensive",
            Theme = "Green",
            Description = "Landing a Gazelle Punch after landing a Liver Blow now does 2x stun and reduces the windup and removes cooldown for the Dempsey Roll. Upon activation, there is minute cooldown before this can be used again",
            Cost = 4,
            Stats = {
                Endurance = 5,
                Stamina = 4,
                Speed = 5,
                Technique = 4,
                Willpower = 3
            },
            Requires = { "Dempsey Roll" }
        },
        ["Head Slip"] = {
            Type = "Passive",
            Display = "Head Slip",
            Branch = "Outboxer",
            Category = "Defensive",
            Theme = "Green",
            Description = "Weaving now slips jabs and straights too (slip left / right or duck), weaves go deeper, and every slip gives a moment of iframes. Weaving into a punch still doesn't work. This does not work on body blows.",
            Cost = 1,
            Stats = {
                Endurance = 2,
                Speed = 2
            },
            Requires = { "Weaving" }
        },
        ["Philly Shell Style"] = {
            Type = "Stance",
            Display = "Philly Shell",
            Branch = "Counter Puncher",
            Category = "Stance",
            Theme = "Green",
            Description = "A counter based variant of the famous Detroit Style, with the lowered left arm allowing for longer ranged jabs when extended at the cost some wind up time.",
            Cost = 3,
            Grants = "PhillyStance",
            Stats = {
                Endurance = 3,
                Speed = 3,
                Technique = 2
            },
            Requires = { "Head Slip" }
        },
        ["Flicker Jab"] = {
            Type = "Technique",
            Display = "Flicker Jab",
            Branch = "Hitman",
            Category = "Technique",
            Theme = "Purple",
            Description = "A strange jabbing technique where the boxer quickly jolts their shoulder while jabbing, creating a whip like punch that gives the jab extra speed and distance. On activation for Philly Shell and Outboxer stances, boxer can use flicker jabs for a short duration.",
            Cost = 3,
            Grants = "FlickerJab",
            Stats = {
                Speed = 5,
                Technique = 5,
                Willpower = 1.5
            },
            Requires = { "Philly Shell Style" }
        },
        ["Hitman Style"] = {
            Type = "Philly Shell Variant",
            Display = "Hitman",
            Branch = "Counter Puncher",
            Category = "Stance",
            Theme = "Purple",
            Description = "A agressive variant of the Philly Shell stance, where the boxer mainly focuses on flicker jabs and chopping rights rather than counter punching. Styles jabs are replaced by flicker jabs, and lower straights replaced by chopping right hooks.",
            Cost = 6,
            Grants = "HitmanStance",
            Stats = {
                Speed = 6,
                Technique = 6,
                Willpower = 3
            },
            Requires = { "Flicker Jab" }
        },
        ["Jolt Counter"] = {
            Type = "Passive",
            Display = "Jolt Counter",
            Branch = "Counter Puncher",
            Category = "Defensive",
            Theme = "Forest",
            Description = "Your Cross Counter now has extended counter frames and now insta KOs even when countering jabs. Opponent will also be severely winded if they recover from the KO afterwards.",
            Cost = 4,
            Stats = {
                Speed = 5,
                Technique = 5
            },
            Requires = { "Philly Shell Style", "Cross Counter" }
        },
        ["Cross Counter"] = {
            Type = "Technique",
            Display = "Cross Counter",
            Branch = "Counter Puncher",
            Category = "Technique",
            Theme = "Olive",
            Description = "Unlocks the technique 'Cross Counter', a powerful counter-punch that can instantly K.O when used against a Right Straight punch, and does some okay damage when countering Jabs.",
            Cost = 3,
            Grants = "CrossCounter",
            Stats = {
                Speed = 4,
                Technique = 4
            },
            Requires = { "Overhand Right", "Head Slip", "Counter Punch" }
        },
        ["Swing Counter"] = {
            Type = "Technique",
            Display = "Swing Counter",
            Branch = "Counter Puncher",
            Category = "Technique",
            Theme = "Olive",
            Description = "Unlocks the technique 'Swing Counter'. For a moment you read any punch thrown at you from the front and answer it - left click for a hook, right click for an uppercut (a hook if you press nothing). The answer does 25% more damage than that punch.",
            Cost = 3,
            Grants = "SwingCounter",
            Stats = {
                Power = 4,
                Speed = 4,
                Technique = 5
            },
            Requires = { "Half Guard" }
        },
        ["Half Guard"] = {
            Type = "Guard",
            Display = "Half Guard",
            Branch = "Counter Puncher",
            Category = "Guard",
            Theme = "Olive",
            Description = "A guard where the leading arm is slack by the side while the other arm guards the face. This guard unlocks parrying by pressing the right punch button (M2) during blocking; the left punch button still feints.",
            Cost = 2,
            Grants = "HalfGuard",
            Stats = {
                Endurance = 4,
                Speed = 4,
                Technique = 4
            },
            Requires = { "Cross Counter" }
        },
        ["Parry Counter"] = {
            Type = "Passive",
            Display = "Parry Counter",
            Branch = "Counter Puncher",
            Category = "Passive",
            Theme = "Olive",
            Description = "Allows for quick jabs or straights to be thrown out after a successful Half Guard parry.",
            Cost = 2,
            Stats = {
                Endurance = 4,
                Speed = 5,
                Technique = 5
            },
            Requires = { "Half Guard" }
        },
        ["Counter Punch"] = {
            Type = "Passive",
            Display = "Counter Punch",
            Branch = "Counter Puncher",
            Category = "Defensive",
            Theme = "Olive",
            Description = "Unlocking makes your punches do more stun to your opponent if you hit them while they are punching.",
            Cost = 2,
            Stats = {
                Speed = 2,
                Technique = 3
            },
            Requires = { "Double Jab" }
        },
        ["Triple Jab"] = {
            Type = "Passive",
            Display = "Triple Jab",
            Branch = "Jab Expert",
            Category = "Offensive",
            Theme = "Grey",
            Description = "With enough training and technique, its possible for another follow up jab to be thrown after a two jab combination. Unlocking allows up to 3 jabs to be thrown in a row without being affected by the 'Repeat Punch' speed debuff.",
            Cost = 2,
            Stats = {
                Speed = 3,
                Technique = 2
            },
            Requires = { "Double Jab" }
        },
        Hien = {
            Type = "Passive",
            Display = "Hien",
            Branch = "Jab Expert",
            Category = "Offensive",
            Theme = "Grey",
            Description = "After throwing a jab, the user doesnt full unextend their jabbing arm, allowing a follow up jab to be thrown quicker than before. Unlocking makes repeat jabs even faster.",
            Cost = 3,
            Stats = {
                Speed = 5,
                Technique = 4
            },
            Requires = { "Triple Jab" }
        },
        Shotgun = {
            Type = "Technique",
            Display = "Shotgun",
            Branch = "Unorthodox",
            Category = "Technique",
            Theme = "Taupe",
            Description = "A unorthodox technique where a boxer quickly alternates between jabs and straight punches in a barrage for a short duration.",
            Cost = 3,
            Grants = "Shotgun",
            Stats = {
                Stamina = 3,
                Speed = 3,
                Technique = 3
            },
            Requires = { "Headshot", "Triple Jab" }
        },
        Hedgehog = {
            Type = "Technique",
            Display = "Hedgehog",
            Branch = "Unorthodox",
            Category = "Technique",
            Theme = "Taupe",
            Description = "An evolution of the shotgun technique where the user mixes in hooks with their barrage of straight punches.",
            Cost = 5,
            Grants = "Hedgehog",
            Stats = {
                Stamina = 5,
                Speed = 7,
                Technique = 4
            },
            Requires = { "Shotgun" }
        },
        Headshot = {
            Type = "Passive",
            Display = "Headshot",
            Branch = "Orthodox",
            Category = "Offensive",
            Theme = "Taupe",
            Description = "Hitting an opponents head now dazes them.",
            Cost = 2,
            Stats = {
                Stamina = 1,
                Speed = 1,
                Technique = 1
            },
            Requires = { "One-Two", "Double Jab" }
        },
        ["Southpaw Stance"] = {
            Type = "Stance",
            Display = "Southpaw",
            Branch = "Unorthodox",
            Category = "Stance",
            Theme = "Taupe",
            Description = "An unorthodox stance, where the leading hand is flipped compared to most stances. Using this stance gives a power buff to jabs and switches some techniques to the other side.",
            Cost = 3,
            Grants = "SouthpawStance",
            Stats = {
                Stamina = 3,
                Technique = 3
            },
            Requires = { "Headshot" }
        },
        ["Switch Hitting"] = {
            Type = "Passive",
            Display = "Switch Hitting",
            Branch = "Unorthodox",
            Category = "Offensive",
            Theme = "Taupe",
            Description = "Switch hitting allows for the quick switch between Orthodox and Southpaw stances during a match. Unlocking reduces the cooldown for switching stances drastically, but only if Southpaw is in one of your stance slots.",
            Cost = 3,
            Stats = {
                Stamina = 4,
                Technique = 5
            },
            Requires = { "Southpaw Stance" }
        },
        ["One-Two"] = {
            Type = "Passive",
            Display = "One-Two",
            Branch = "Orthodox",
            Category = "Offensive",
            Theme = "Khaki",
            Description = "A common punch combination where after throwing a jab, a powerful straight punch is thrown after. Unlocking lowers the endlag on a jab thrown if the next punch thrown is a straight.",
            Cost = 1,
            Stats = {
                Speed = 0.5,
                Technique = 0.5
            },
            Requires = { "Double Jab" }
        },
        ["Corkscrew Blow"] = {
            Type = "Technique",
            Display = "Corkscrew Blow",
            Branch = "Orthodox",
            Category = "Technique",
            Theme = "Khaki",
            Description = "A right straight thrown with the rotation of the arm, and can cause cuts if it hits the face. Unlocks the technique 'Corkscrew Blow'.",
            Cost = 2,
            Grants = "CorkscrewBlow",
            Stats = {
                Stamina = 1,
                Speed = 1,
                Technique = 1
            },
            Requires = { "One-Two" }
        },
        ["Corkscrew Counter"] = {
            Type = "Passive",
            Display = "Corkscrew Counter",
            Branch = "Corkscrew Expert",
            Category = "Defensive",
            Theme = "Khaki",
            Description = "Perfecting the Corkscrew allows its pure power to shock opponents if they are hit while trying to punch. Unlocking makes your 'Corkscrew Blow' do more stun to your opponent if they hit while they are punching.",
            Cost = 3,
            Stats = {
                Stamina = 2,
                Speed = 2,
                Technique = 3
            },
            Requires = { "Corkscrew Blow" }
        },
        ["Heart Break Shot"] = {
            Type = "Passive",
            Display = "Heart Break Shot",
            Branch = "Corkscrew Expert",
            Category = "Defensive",
            Theme = "Khaki",
            Description = "Unlocking allows your 'Corkscrew Blow' to freeze your opponent in place if you precisely hit their heart.",
            Cost = 4,
            Stats = {
                Stamina = 3,
                Speed = 4,
                Technique = 6
            },
            Requires = { "Corkscrew Counter" }
        },
        ["Overhand Right"] = {
            Type = "Technique",
            Display = "Overhand Right",
            Branch = "Orthodox",
            Category = "Technique",
            Theme = "Brown",
            Description = "An orthodox punch that is thrown from a top-down trajectory, normally toward the opponent's head, after stepping in and while twisting the hips. Unlocks the technique 'Overhand Right'.",
            Cost = 2,
            Grants = "OverhandRight",
            Stats = {
                Power = 1,
                Stamina = 1,
                Technique = 1
            },
            Requires = { "One-Two" }
        },
        ["Dragon Fish Blow"] = {
            Type = "Technique",
            Display = "Dragon Fish Blow",
            Branch = "Orthodox",
            Category = "Technique",
            Theme = "Brown",
            Description = "A overhand right styled in the movement of a counter punch, while being faster but doing less damage. Unlocks the technique 'Dragon Fish Blow'.",
            Cost = 3,
            Grants = "DragonFishBlow",
            Stats = {
                Power = 2,
                Stamina = 4,
                Technique = 2
            },
            Requires = { "Overhand Right" }
        },
        ["White Fang"] = {
            Type = "Technique",
            Display = "White Fang",
            Branch = "Orthodox",
            Category = "Technique",
            Theme = "Brown",
            Description = "A lightning fast combination consisting of an uppercut followed by an overhand. The two moves are so fluidly executed they can easily seem simultaneous to the untrained eye. Unlocks the technique 'White Fang'.",
            Cost = 4,
            Grants = "WhiteFang",
            Stats = {
                Power = 4,
                Speed = 4,
                Technique = 4
            },
            Requires = { "Uppercut", "Overhand Right" }
        },
        Hook = {
            Type = "Punch Set",
            Display = "Hooks",
            Branch = "Orthodox",
            Category = "Offensive",
            Theme = "Tan",
            Description = "A punch thrown whilst the user's arm is bent at a near 90 degree angle. It is a devastating punch that usually finds its mark at an opposing boxer's jaw or temple. Unlocks the 'Hook' punch set by press 'X'.",
            Cost = 1,
            Stats = {
                Power = 0.5,
                Technique = 0.5
            },
            Requires = { "Boxing Basics" }
        },
        Uppercut = {
            Type = "Punch Set",
            Display = "Uppercuts",
            Branch = "Orthodox",
            Category = "Offensive",
            Theme = "Mauve",
            Description = "a punch thrown from the waist up. Executed after a series of leg and hip movements, the uppercut is immensely powerful if performed with the necessary follow-throughs. Unlocks the 'Uppercut' punch set by press 'C'.",
            Cost = 1,
            Stats = {
                Power = 0.5,
                Speed = 0.5
            },
            Requires = { "Boxing Basics" }
        },
        ["Alternating Hooks"] = {
            Type = "Passive",
            Display = "Alternating Hooks",
            Branch = "Hook Expert",
            Category = "Offensive",
            Theme = "Ochre",
            Description = "An understanding of shifting your weight allows for rapid side to side hooks to be thrown out. Unlocking gives punches from the 'Hook' punch set a speed boost when alternating strikes from side to side.",
            Cost = 2,
            Stats = {
                Power = 2,
                Speed = 1,
                Technique = 2
            },
            Requires = { "Hook" }
        },
        ["Crouching Style"] = {
            Type = "Stance",
            Display = "Crouching",
            Branch = "Infighter",
            Category = "Stance",
            Theme = "Ochre",
            Description = "An infighting boxing style where the users body is in a crouched position, making it easier to shift their weight for strong punches. Using this stance increase the power of your uppercuts.",
            Cost = 3,
            Grants = "CrouchingStance",
            Stats = {
                Power = 3,
                Technique = 3
            },
            Requires = { "Alternating Hooks" }
        },
        ["Liver Blow"] = {
            Type = "Technique",
            Display = "Liver Blow",
            Branch = "Crouching Style",
            Category = "Technique",
            Theme = "Ochre",
            Description = "An body blow aimed at the liver. Unlocks the 'Liver Blow' technique.",
            Cost = 4,
            Grants = "LiverBlow",
            Stats = {
                Power = 6,
                Technique = 4
            },
            Requires = { "Crouching Style" }
        },
        ["Double Hook Barrage"] = {
            Type = "Passive",
            Display = "Double Hook Barrage",
            Branch = "Hook Expert",
            Category = "Offensive",
            Theme = "Rust",
            Description = "Intense training of the hook can allow for a quick and sharp follow up hook after a first hook is thrown. Unlocking allows you to do a fast follow up hook on the same side that the first hook is thrown.",
            Cost = 2,
            Stats = {
                Power = 3,
                Speed = 2,
                Technique = 3
            },
            Requires = { "Hook" }
        },
        ["Triple Hook Barrage"] = {
            Type = "Passive",
            Display = "Triple Hook Barrage",
            Branch = "Hook Expert",
            Category = "Offensive",
            Theme = "Rust",
            Description = "Even further intense training of the hook can allow for a second follow up hook after the first. Unlocking allows you to do an even faster second follow up hook on the same side that the first two hooks were thrown.",
            Cost = 3,
            Stats = {
                Power = 4,
                Speed = 4,
                Technique = 4
            },
            Requires = { "Double Hook Barrage" }
        },
        ["Consecutive Body Blows"] = {
            Type = "Passive",
            Display = "Consecutive Body Blows",
            Branch = "Body Blow Expert",
            Category = "Offensive",
            Theme = "Rust",
            Description = "An understanding of shifting your weight at close range allows for consecutive body blows to be thrown out. Unlocking gives body blow punches from the 'Hook' punch set a speed boost when alternating strikes from side to side.",
            Cost = 3,
            Stats = {
                Power = 3,
                Endurance = 1,
                Technique = 2
            },
            Requires = { "Hook" }
        },
        ["Submarine Body Blow"] = {
            Type = "Passive",
            Display = "Submarine Body Blow",
            Branch = "Body Blow Expert",
            Category = "Offensive",
            Theme = "Rust",
            Description = "Intense training of the body blow allows for their power to wind your oppenent easier. Unlocking makes body blows wind opponents faster.",
            Cost = 3,
            Stats = {
                Power = 5,
                Endurance = 2,
                Technique = 4
            },
            Requires = { "Consecutive Body Blows" }
        },
        ["Brawler Style"] = {
            Type = "Stance",
            Display = "Brawler",
            Branch = "Offensive Infighter",
            Category = "Stance",
            Theme = "Rust",
            Description = "An all-out offensive boxing style that is widely considered the opposite of orthodox boxing. Using this stance increases the power of your hooks.",
            Cost = 3,
            Grants = "BrawlerStance",
            Stats = {
                Power = 5,
                Stamina = 3
            },
            Requires = { "Full-Body Uppercut", "Alternating Hooks" }
        },
        Smash = {
            Type = "Technique",
            Display = "Smash",
            Branch = "Brawler Style",
            Category = "Technique",
            Theme = "Rust",
            Description = "A powerful punch described to be the fusion between a hook and an uppercut, with the target usually being the head. Unlocks the 'Smash' technique.",
            Cost = 3,
            Grants = "Smash",
            Stats = {
                Power = 6,
                Technique = 4
            },
            Requires = { "Brawler Style" }
        },
        ["Low Smash"] = {
            Type = "Technique",
            Display = "Low Smash",
            Branch = "Brawler Style",
            Category = "Technique",
            Theme = "Rust",
            Description = "A smash where the user combines a dash and a weave into their smash punch. Unlocks the 'Low Smash' technique.",
            Cost = 3,
            Grants = "LowSmash",
            Stats = {
                Power = 8,
                Technique = 5
            },
            Requires = { "Smash" }
        },
        ["Full-Body Uppercut"] = {
            Type = "Technique",
            Display = "Full-Body Uppercut",
            Branch = "Infighter",
            Category = "Technique",
            Theme = "Crimson",
            Description = "An uppercut thrown from a crouching position for more power. Unlocks the 'Full-Body Uppercut' technique.",
            Cost = 2,
            Grants = "FullBodyUppercut",
            Stats = {
                Power = 2,
                Technique = 2
            },
            Requires = { "Uppercut" }
        },
        ["Tsubame Gaeshi"] = {
            Type = "Passive",
            Display = "Tsubame Gaeshi",
            Branch = "Infighter",
            Category = "Offensive",
            Theme = "Crimson",
            Description = "A double uppercut combination technique where the second uppercut is a guaranteed block break.",
            Cost = 3,
            Stats = {
                Power = 4,
                Speed = 1,
                Technique = 4
            },
            Requires = { "Full-Body Uppercut" }
        },
        ["Infighter Dash"] = {
            Type = "Dash",
            Display = "Infighter",
            Branch = "Infighter",
            Category = "Dash",
            Theme = "Crimson",
            Description = "A dashing style consisting of diving in towards the oppenent to close the distance or to land short ranged punches. Unlocks the 'Infighter' dash set.",
            Cost = 2,
            Grants = "InfighterDash",
            Stats = {
                Power = 1,
                Stamina = 1,
                Speed = 1
            },
            Requires = { "Uppercut" }
        },
        ["Gazelle Punch"] = {
            Type = "Technique",
            Display = "Gazelle Punch",
            Branch = "Infighter",
            Category = "Technique",
            Theme = "Crimson",
            Description = "A uppercut based technique where the user dashes in and then lifts up from the ground like a gazelle to perform a short-uppercut aimed at the chin. Unlocks the 'Gazelle Punch' technique.",
            Cost = 3,
            Grants = "GazellePunch",
            Stats = {
                Power = 2,
                Speed = 2,
                Technique = 2
            },
            Requires = { "Infighter Dash", "Full-Body Uppercut" }
        },
        ["Bone Breaker"] = {
            Type = "Passive",
            Display = "Bone Breaker",
            Branch = "Infighter",
            Category = "Passive",
            Theme = "Crimson",
            Description = "Every clean hit you land is thrown to break something: injuries build up 40% faster on your opponent. Each injury you inflict costs you 0.02 Willpower (Bloodthirst first, then Courage); with no Willpower to spend, it does nothing.",
            Cost = 3,
            Stats = {
                Power = 5,
                Technique = 3
            },
            Requires = { "Chin Shatter" }
        },
        ["Chin Shatter"] = {
            Type = "Passive",
            Display = "Chin Shatter",
            Branch = "Infighter",
            Category = "Passive",
            Theme = "Crimson",
            Description = "Through rigourous leg training and perfecting the uppercut technique's form, your uppercuts take a bit more stamina but now do deadly damage when they land on your opponents chin.",
            Cost = 3,
            Stats = {
                Power = 4,
                Speed = 2,
                Technique = 3
            },
            Requires = { "Gazelle Punch" }
        }
    }
}

function t1.ApplyNames(p1) -- line: 362
    -- upvalues: t1 (copy)
    for v1, v2 in p1 do
        if v2.Skill then
            if t1.List[v2.Skill] then
                v2.Name = v2.Skill
            else
                warn(string.format("[BoxingSkills] loadout item %s names a skill that doesn't exist: %q", v1, v2.Skill))
            end
        end
    end
end

t1.PunchGates = {
    Hook = "Hook",
    Uppercut = "Uppercut"
}

local self = setmetatable({}, {
    __mode = "k"
})

local function cachedSet(p2) -- line: 380
    -- upvalues: HttpService (copy), t1 (copy), self (copy)
    local v5 = p2 and p2:GetAttribute("Skills")
    local v4 = p2 and self[p2]

    if v4 and v4.Raw == v5 then
        return v4.Set
    end

    local t4 = {}

    for _, v6 in t1.Default do
        t4[v6] = true
    end

    if type(v5) == "string" then
        local JSONDecode = HttpService.JSONDecode
        local ok, result = pcall(JSONDecode, HttpService, v5)

        if ok and type(result) == "table" then
            for _, v7 in result do
                t4[v7] = true
            end
        end
    end

    if p2 then
        self[p2] = {
            Raw = v5,
            Set = t4
        }
    end

    return t4
end

function t1.Unlocked(p3) -- line: 404
    -- upvalues: cachedSet (copy)
    return table.clone((cachedSet(p3)))
end

function t1.Has(p4, p5) -- line: 408
    -- upvalues: cachedSet (copy)
    return cachedSet(p4)[p5] == true
end

function t1.ModelHas(p6, p7) -- line: 413
    -- upvalues: t1 (copy)
    local PlayerFromCharacter = game:GetService("Players"):GetPlayerFromCharacter(p6)

    if PlayerFromCharacter then
        return t1.Has(PlayerFromCharacter, p7)
    end

    return true
end

function t1.Earned(p8, p9) -- line: 422
    -- upvalues: t1 (copy)
    local n1 = 0

    for _, v8 in p9.Names do
        n1 += math.floor(math.max(p8:GetAttribute("Stat_" .. v8) or 0, 0) + 1E-06)
    end

    return t1.StartPoints + n1
end

function t1.Spent(p10) -- line: 432
    -- upvalues: t1 (copy)
    local n2 = 0

    for v11 in p10 do
        local v12 = t1.List[v11]

        if v12 then
            n2 += v12.Cost or 0
        end
    end

    return n2
end

function t1.TutorialWaived(p11, p12) -- line: 447
    local v13 = typeof(p11) == "Instance" and p11:GetAttribute("TutorialUnlock")

    if type(v13) == "string" then
        for match in string.gmatch(v13, "[^|]+") do
            if match == p12 then
                return true
            end
        end
    end

    return false
end

function t1.Check(p13, p14, p15) -- line: 460
    -- upvalues: t1 (copy)
    if t1.TutorialWaived(p13, p14) then
        return true, true, true
    end

    local v14 = t1.List[p14]

    if not v14 then
        return false, false, false
    end

    local v15 = true

    for v16, v17 in v14.Stats or {} do
        if (p13:GetAttribute("Stat_" .. v16) or 0) + 1E-06 < v17 then
            v15 = false
        end
    end

    local v18 = t1.Unlocked(p13)
    local v19 = true

    for _, v20 in v14.Requires or {} do
        if not v18[v20] then
            v19 = false
        end
    end

    local SkillPoints = p13:GetAttribute("SkillPoints")

    if SkillPoints == nil then
        SkillPoints = t1.Earned(p13, p15) - t1.Spent(v18)
    end

    return v15, v19, (v14.Cost or 0) <= SkillPoints
end

return t1
