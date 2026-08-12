local pa_fish = {
    descriptions = {
		PotatoPatch = {
			PotatoPatchDev_Axy = {
				name = "Axy",
                text = {
                    {
                        "Am {V:1}Axy{}, did most of the coding and",
                        "one shader for Axy's and {C:fac_fish}Pulsar's{} fish",
                    },
                    {
                        "Am a {V:1}wob{} {element:1}",
                        "that likes plushies and cookies",
                        "and is most certainly not a {C:fac_fish}fish{}, but am {C:dark_edition}witch{}!"
                    },
                    {
                        "Made a mod called Berry's Legendaries",
                        "around mid-2025 as our first ever mod!",
                        "It adds a few {C:legendary}legendaries{} based on some friends",
                        "Can be found at {C:blue}https://github.com/TonyKrZa/BerryLegendaries",
                        "{C:attention}Click{} on this card to go there!"
                    }
                }
			},
			PotatoPatchDev_Pulsar = {
				name = "Pulsar",
                text = {
                    {"I'm {C:fac_fish}Pulsar{}, I did the art and a",
                    "smidge of code for me and {C:green}Axy's{} fish"},

                    {"I'm a {X:chips,C:white}Blue{} goat-{C:fac_fish}fish{} creature that",
                    "likes space and- w-wait... {C:fac_fish}fish{}...?",
                    "i'm just a little guy...",
                    "please don't fish me... {element:1}"},

                    {"I'm currently working on my own mod {C:legendary}Nebula{}",
                    " that adds about 60 jokers and a new Consumable set",
                    "there's a good chance it'll be finished when this is!",
                    "{C:blue}https://github.com/PSRPulsar/Nebula",
                    "{C:attention}Click{} this card to go to my Github profile"
                    },

                    {"Random Quip:",
                    "#1#"}
                }
			},
        },
        fac_Fish = {
            fish_fac_pa_videogame = {
                name = "Fishing Simulator 2007",
                text = {
                    "Gains {X:mult,C:white}X#1#{} Mult if",
                    "{C:fac_fish}fish{} is caught {C:attention}perfectly",
                    "{C:inactive}Currently {X:mult,C:white}X#2#{C:inactive} Mult"
                },
                flavour = {
                    "Rated F for Fish"
                }
            },
            fish_fac_pa_heatshield = {
                name = "Heatshield Tile",
                text = {
                    "Gains {C:attention}+#1#{} free {C:attention}Location Reroll{}",
                    "for each used {C:planet}Planet{} card",
                    "{C:inactive}(Rerolls left: {C:attention}#2#{})"
                },
                flavour = {
                    "Fell off of a reusable",
                    "rocket's upper stage",
                    "during a test flight.",
                    "It's still warm from reentry"
                }
            },
            fish_fac_pa_onering = {
                name = "The One Fish",
                text = {{
                    "Disable all {C:attention}Boss Blinds{}",
                    "Blind Size temporarily increases by",
                    "{B:blind,C:white}X#1#{} each round while held",
                    "{C:inactive}(Current blind size: {}{B:blind,C:white}#4#x{}{C:inactive}){}"
                },{
                    "If {C:attention}sold or destroyed{}:",
                    "Outside of {X:fac_environment,C:white}Volcano{}, {X:blind,C:white}X#2#{} base blind size permanently",
                    "Inside of {X:fac_environment,C:white}Volcano{}, {X:blind,C:white}X#3#{} base blind size permanently",
                }},
                flavour = {
                    "One fish to rule them all,",
                    "one fish to find them,",
                    "One fish to bring them all",
                    "and in the darkness bind them."
                }
            },
            fish_fac_pa_onering_variable = {
                name = "The #5# Fish",
                text = {{
                    "Disable all {C:attention}Boss Blinds{}",
                    "Blind Size temporarily increases by",
                    "{B:blind,C:white}X#1#{} each round while held",
                    "{C:inactive}(Current blind size: {}{B:blind,C:white}#4#x{}{C:inactive}){}"
                },{
                    "If {C:attention}sold or destroyed{}:",
                    "Outside of {X:fac_environment,C:white}Volcano{}, {X:blind,C:white}X#2#{} base blind size permanently",
                    "Inside of {X:fac_environment,C:white}Volcano{}, {X:blind,C:white}X#3#{} base blind size permanently",
                }},
                flavour = {
                    "#1# fish to rule them all,",
                    "#2# fish to find them,",
                    "#1# fish to bring them all",
                    "and in the darkness bind them."
                }
            },
            fish_fac_pa_mysteryfish = {
                name = "Mystery Fish",
                text = {
                    "Gives {X:mult,C:white}X#1#{} Mult on",
                    "one {C:attention}random hand{}",
                    "each round"
                },
                flavour = {
                    'Quite a rare catch,',
                    "still isn't the",
                    "King of the Pond"
                }
            },
            fish_fac_pa_F = {
                name = "F",
                text = {
                    "{C:mult}+#1#{} Mult for each",
                    "{C:attention}unique character{} in",
                    "names of {C:fac_fish}Fish{}",
                    "{C:inactive}(Currently{} {C:mult}+#2#{} {C:inactive}Mult){}"
                },
                flavour = {
                    'This alphabet soup',
                    "brought to you by",
                    "the letter F"
                }
            },
            fish_fac_pa_fishingfish = {
                name = 'The "Fish"ing Rod',
                text = {
                    "Max fish {C:attention}speed{} is slower by {X:fac_fish,C:white}X#1#{}"
                },
                flavour = {
                    'Some traditional fishers prefer',
                    'these over man-made fishing rods',
                    "(they don't mind being fished with)"
                }
            },
            fish_fac_pa_shellphone = {
                name = "Shellphone",
                text = {{
                    'Increases {C:fac_sand_dollars}sell value{} by {C:fac_sand_dollars,f:fac_sand_dollars}${C:fac_sand_dollars}#1#{} when',
                    'the below sequence of ranks',
                    'is {C:attention}fully played{}, then',
                    'creates a new sequence'
                },{
                    '{V:1}#2#{}{V:2}#3#{}{V:3}#4#{}{V:4}#5#{}{V:5}#6#{}{V:6}#7#{}{V:7}#8#{}{V:8}#9#{}', -- inactive or black, rank or '', repeat this 3-8 times in code
                }},
                flavour = {
                    "This phone seems to",
                    "get more phishing calls",
                    'than usual phones'
                }
            },
            fish_fac_pa_fromg = {
                name = "fromg",
                text = {
                    '{C:attention}Use{} this fromg while',
                    'an owned {C:attention}Consumable{} is',
                    'selected to {C:attention}eat{} it',
                    'and gain {C:chips}+#1#{} chips',
                    '{C:inactive}(Currently {C:chips}+#2#{}{C:inactive} chips){}'
                },
                flavour = {
                    'ribbit'
                }
            },
            fish_fac_pa_box_jellyfish = {
                name = "Box Jellyfish",
                text = {
                    'Use to copy selected ',
                    '{C:attention}Booster Pack{} in shop,',
                    'Use again in shop to',
                    'open stored {C:attention}Booster Pack{}',
                    '{s:0.8}{C:inactive}(Usable {C:attention}once{}{s:0.8}{C:inactive} per shop)'
                },
                flavour = {
                    'I wonder why nobody has',
                    'tried doing an unboxing',
                    "on one of these"
                }
            },
            fish_fac_pa_blackhole = {
                name = "Accretion Disk Fish",
                text = {
                    'Does nothing, but is',
                    'Extremely {C:attention}large{}',
                    'and extremely {C:attention}heavy{}'
                },
                flavour = {
                    'An unusual form of life that lives',
                    'around primordial black holes',
                    'only the accretion disk is alive,',
                    'but it depends on the singularity'
                }
            },
            fish_fac_pa_chocolate = {
                name = "Chocolate Gar",
                text = {
                    'Gives {C:chips}+#1#{} Chips',
                    'to all {C:attention}held{} cards',
                    '{C:attention}permanently{} when used'
                },
                flavour = {
                    'Common fish made entirely',
                    'of solid milk chocolate',
                    'usually described as better',
                    'than normal chocolate bars'
                }
            },
            fish_fac_pa_cake = {
                name = "Ocaketopus",
                text = {
                    'Gives {C:mult}+#1#{} Mult',
                    'to all {C:attention}held{} cards',
                    '{C:attention}permanently{} when used'
                },
                flavour = {
                    'Mollusk made of plain',
                    'cake and overly-sweet icing',
                    "They're more intelligent",
                    'than your average cake'
                }
            },
            fish_fac_pa_goofball = {
                name = "Perch Goofball",
                text = {
                    '{C:green}#1# in #2#{} chance',
                    'for each scored {C:attention}4{}',
                    'to give a random',
                    '{C:spectral}Spectral{} card'
                },
                flavour = {
                    "Hey guys it's me!",
                    "Perch Goofball",
                    'the main catch',
                    'of Ante number 4!'
                }
            },
            fish_fac_pa_lavalamp = {
                name = "Lava Lamp",
                text = {
                    'If {C:attention}previous{} blind was',
                    'beaten in {C:attention}one{} hand,',
                    'give {C:attention}#1#{} selected playing',
                    'card a random {C:dark_edition}Edition'
                },
                flavour = {
                    'delicious, nutritious',
                    '...but only once'
                }
            },
            fish_fac_pa_charcoal_biscuit = {
                name = "Cookie Cod (Burnt)",
                text = {
                    "Retriggers all played",
                    "{C:spades}Spades{} cards {C:attention}#1#{} times"
                },
                flavour = {
                    "Axy, how sure are you that",
                    "you didn't burn this cookie?",
                    "{element:1}"
                }
            },
            fish_fac_pa_sushi = {
                name = "Temaki-Mahi",
                text = {
                    "Each {C:fac_fish}fish{} catchable",
                    "in {C:attention}The Soup{}",
                    "gives {X:mult,C:white}X#1#{} mult"
                },
                flavour = {
                    "This Fish has an ingenious",
                    "disguise: it looks like a",
                    "sushi roll, meaning nobody",
                    "will try putting it in sushi"
                }
            },
            fish_fac_pa_photon = {
                name = "{V:1}Photonfin",
                text = {
                    "Gives {C:attention}#1#{} random tags when",
                    "a blind is {C:attention}skipped"
                },
                flavour = {
                    'Unique type of fish that has',
                    'evolved to become so small',
                    'that it has become massless',
                    'and acts like a singular photon'
                }
            },
            fish_fac_pa_pulsar = {
                name = "Pulsar",
                text = {
                    "Each {C:clubs}Club{}",
                    "held in hand",
                    "gives {X:chips,C:white}X#1#{} Chips"
                },
                flavour = {
                    "I give {X:chips,C:white}XChips{}",
                    "because I'm {X:chips,C:white}Blue{}",
                    "...I told you not",
                    "to catch me {element:1}",
                }
            }
        },
    },
    misc = {
        dictionary = {
            au_format = '%.4f AU', --Astronomical Units, or the mean distance between Earth and the Sun
            yg_format = '%.3f Yg', --Yottagrams, or septillions of grams
            nm_format = '%.f nm', --nanometers, 10^-9
            k_fac_pa_fromg = "fromg",
            k_fac_pa_box_jellyfish_open = "Open",
            k_fac_pa_box_jellyfish_consume = "Consume",
        },
    }
}
pa_fish.descriptions.fac_Fish.fish_fac_pa_doorfish = SMODS.load_file("localization/pulsaraxy/doorfish/en-us.lua", "FishAndChips")()
return pa_fish