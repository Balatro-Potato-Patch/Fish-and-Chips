return {
    descriptions = {
        Other={
            fac_minty_jeal_needsroom = {
                name = "h",
                text = {
                    "{C:inactive}(You will need room, of course!)"
                }
            }
        },
        fac_Fish = {
            fish_fac_minty_seabass = {
                name = "Sea Bass",
                flavour = {
                    "See? Bass!",
                    "...",
                    "... it's an invasive",
                    "species, just chum it."
                },
                text = {
                    "Use for a {C:green}#1# in #2#{} chance",
                    "to earn {C:fac_sand_dollars,f:fac_sand_dollars}$1{} and a {C:green}#3# in #4#{}",
                    "chance to gain {C:attention}1{} Bait",
                    "Also {C:red,E:2}culls the population{}",
                    "of this invasive species",
                    "{ppu_bubble:usable}"
                }
            },
            fish_fac_minty_seabass_alt = {
                name = "Sea Bass",
                flavour = {
                    "See? The sea!",
                    "This is where they're",
                    "SUPPOSED to live!"
                },
                text = {
                    "Use for a {C:green}#1# in #2#{} chance",
                    "to earn {C:fac_sand_dollars,f:fac_sand_dollars}$1{} and a {C:green}#3# in #4#{}",
                    "chance to gain {C:attention}1{} Bait",
                    "The fish was healthier",
                    "in its native habitat.",
                    "{ppu_bubble:usable}"
                }
            },
            fish_fac_minty_seabass_anvil = {
                name = "Sea Bass",
                flavour = {
                    "See? Bass!",
                    "...",
                    "... it's an invasive",
                    "species, just {element:1}{} it.",
                },
                text = {
                    "Use for a {C:green}#1# in #2#{} chance",
                    "to earn {C:fac_sand_dollars,f:fac_sand_dollars}$1{} and a {C:green}#3# in #4#{}",
                    "chance to gain {C:attention}1{} Bait",
                    "Also {C:red,E:2}culls the population{}",
                    "of this invasive species",
                    "{ppu_bubble:usable}"
                }
            },
            fish_fac_minty_fission = {
                name = "Fission Chip",
                flavour = {
                    "This isn't a fish??",
                },
                text = {
                    "Each {C:fac_fish}Fish{} has a",
                    "{C:green}#1# in #2#{} chance to",
                    "retrigger {C:attention}#3#{} time"
                }
            },
            fish_fac_minty_fission_plural = {
                name = "Fission Chip",
                flavour = {
                    "This isn't a fish??",
                },
                text = {
                    "Each {C:fac_fish}Fish{} has a",
                    "{C:green}#1# in #2#{} chance to",
                    "retrigger {C:attention}#3#{} times"
                }
            },
            fish_fac_minty_catfish = {
                name = "Catfish",
                flavour = {
                    "Mrrp mew mrew :3",
                },
                text = {
                    "{C:green}#1#{} denominator to",
                    "all listed {C:green,E:1}probabilities{}",
                    "{C:inactive,s:0.8}(e.g. {C:green,s:0.8}1 in 5{C:inactive,s:0.8} -> {C:green,s:0.8}1 in #2#{C:inactive,s:0.8})"
                }
            },
            fish_fac_minty_dogfish = {
                name = "Dogfish",
                flavour = {
                    "It's hungry!",
                },
                text = {
                    "{C:red}Destroy{} played {C:attention}Lucky{}",
                    "cards, this {C:fac_fish}Fish{} gains",
                    "{C:white,X:mult}X#2#{} Mult for each",
                    "{C:inactive}(Currently {C:white,X:mult}X#1#{C:inactive} Mult)"
                }
            },
            fish_fac_minty_shrimp_npc = {
                name = "The Shrimp NPC",
                flavour = {
                    "Hello there!",
                    "As the Shrimp NPC,"
                },
                text = {
                    "{C:inactive}(...){}"
                }
            },
            fish_fac_minty_goldfish = {
                name = "Goldfish",
                flavour = {
                    "Smiles back, but",
                    "it's not a snack"
                },
                text = {
                    "Gains {C:fac_sand_dollars,f:fac_sand_dollars}$#1#{} of sell value",
                    "when earning {C:money}dollars{}"
                }
            },
            fish_fac_minty_starfish = {
                name = "Starfish",
                flavour = {
                    "Why yes, this IS",
                    "Fish and Chips,",
                    "how can I help you?"
                },
                text = {
                    "When leveling up any",
                    "hand, {C:green}#1# in #2#{} chance",
                    "to do it {C:attention}again{}"
                }
            },
            fish_fac_minty_mimic_octopus = {
                name = "Mimic Octopus",
                flavour = {
                    "Koppi, arms up!"
                },
                text = {
                    "{C:attention}Use{} to copy {C:fac_fish}Fish{} to the",
                    "right until end of round",
                    "{C:inactive}(Currently {C:attention}#1#{C:inactive})",
                    "{ppu_bubble:usable}"
                }
            },
            fish_fac_minty_electric_eel = {
                name = "Electric Eel",
                flavour = {
                    "If there were four of them, Outkast",
                    "would have to sing an apology."
                },
                text = {
                    {
                        "{C:attention}Use{} to ready a stored charge",
                        "{C:inactive}({C:red}#2#{C:inactive}/{C:blue}#1#{C:inactive} charges readied){}",
                        "{ppu_bubble:1}"
                    },
                    {
                        "Stores {C:blue}+1{} charge when a",
                        "{C:attention}Boss Blind{} is defeated"
                    },
                    {
                        "For each {C:red}readied{} charge, retrigger",
                        "all {C:attention}Jokers{} and {C:fac_fish}Fish{} until",
                        "the end of the round"
                    }
                }
            },
            fish_fac_minty_electric_eel_alt = {
                name = "Electric Eel",
                flavour = {
                    "#1#"
                },
                text = {
                    "{C:attention}Use{} to ready a stored",
                    "charge ({C:blue}#1#{} available)",
                    "For each readied charge ({C:red}#2#{}),",
                    "retrigger every Joker and",
                    "fish next hand",
                    "Gains 1 charge when",
                    "defeating Boss Blind"
                    
                }
            },
            fish_fac_minty_kyriaki = {
                name = "Kyriaki",
                flavour = {
                    "Sunday, the first sin",
                    "Death is denied those who seek",
                    "it, though it be their destiny",
                    "They search for it like treasure,",
                    "but the modern age conceals it"
                },
                text = {
                    "{X:blind,C:white}X#1#{} Blind size when",
                    "{C:attention}Blind{} is selected and",
                    "after each hand played"
                }
            },
            fish_fac_minty_elder_tuna = {
                name = "Elder Tuna",
                flavour = {
                    "I'm old!"
                },
                text = {
                    "When acquired, {C:attention}level up{}",
                    "a semi-random poker hand",
                    "{C:inactive,s:0.8}(Hand selected may be highest level, most",
                    "{C:inactive,s:0.8}played, lowest level or completely random)"
                }
            },
            fish_fac_minty_tundra_eel = {
                name = "Tundra Eel",
                flavour = {
                    "... damn it, I already",
                    "made the Outkast joke."
                },
                text = {
                    "Balances {C:purple}#1#%{} of",
                    "{C:chips}Chips{} and {C:mult}Mult{},",
                    "for some reason"
                }
            },
            fish_fac_minty_gem = {
                name = "Fishgem",
                flavour = {
                    "It's peak!",
                    "... wait, this is a fishing",
                    "mod. It's pike!"
                },
                text = {
                    "Worth a lot of {C:fac_sand_dollars,f:fac_sand_dollars}${}"
                }
            },
            fish_fac_minty_jeal = {
                name = "Jeal Inygmu, Ghoti Shop Owner",
                flavour = {
                    "Pronounced 'jewel', 'enigma', and",
                    "'fish', respectively."
                },
                text = {
                    "Hello! I'm {C:purple}Jeal{}, and I grant wishes!",
                    "Today I have {C:attention}#1#{} for {C:fac_sand_dollars,f:fac_sand_dollars}$#2#{}!",
                    "{ppu_bubble:1}"
                }
            },
            fish_fac_minty_jeal_unready = {
                name = "Jeal Inygmu, Ghoti Shop Owner",
                flavour = {
                    "Pronounced 'jewel', 'enigma', and",
                    "'fish', respectively."
                },
                text = {
                    "Hello! I'm {C:purple}Jeal{}, and I grant wishes!",
                    "I'll have a new offering next hand!",
                    "{ppu_bubble:1}"
                }
            },
            fish_fac_minty_jeal_2 = {
                name = "Jeal Inygmu, Ghoti Shop Owner",
                flavour = {
                    "Normally I grant wishes for free,",
                    "but this is a game, and people",
                    "prefer balance in this case!"
                },
                text = {
                    "Hello! I'm {C:purple}Jeal{}, and I grant wishes!",
                    "Today I have {C:attention}#1#{} for {C:fac_sand_dollars,f:fac_sand_dollars}$#2#{}!",
                    "{ppu_bubble:1}"
                }
            },
            fish_fac_minty_jeal_3 = {
                name = "Jeal Inygmu, Ghoti Shop Owner",
                flavour = {
                    "I see you have DebugPlus!",
                    "If you're not concerned about",
                    "balance, you can set",
                    "G.GAME.fac_jeal_free_wishes",
                    "and I'll stop charging!"
                },
                text = {
                    "Hello! I'm {C:purple}Jeal{}, and I grant wishes!",
                    "Today I have {C:attention}#1#{} for {C:fac_sand_dollars,f:fac_sand_dollars}$#2#{}!",
                    "{ppu_bubble:1}"
                }
            },
            fish_fac_minty_chaos_salmon = {
                name = "Chaos Salmon",
                flavour = {
                    "I can do anything!"
                },
                text = {
                    '{C:fac_fish}Fish{} whose names',
                    'contain "{C:attention}fish{}"',
                    'give {C:white,X:mult}X#1#{} Mult'
                }
            },
            fish_fac_minty_template = {
                name = "fish",
                flavour = {
                    "yum"
                },
                text = {
                    "does a thing"
                }
            },
        },
        PotatoPatch = {
            PotatoPatchDev_minty = {
                name = "mys. minty",
                text = {
                    {
                        "Hi again! Mrrp mrew :3"
                    },
                    {
                        "I went solo this time cause",
                        "it seemed like fun :3 :3"
                    },
                    {
                        "Hope you like scribbles",
                        "and line boil! :3 :3 :3",
                        "{s:0.8}(If you don't like line boil,",
                        "{s:0.8}turn on Reduced Motion",
                        "{s:0.8}in the vanilla config.)"
                    }
                }
            }
        }
    },
    misc = {
        achievement_descriptions={},
        achievement_names={},
        challenge_names={},
        dictionary={
            k_fac_minty_youagain_qex = "You again?!",
            k_fac_minty_ready_ex = "Ready!",
            k_fac_minty_charged_ex = "Charged!",
            b_fac_minty_chum = "CHUM",
            k_fac_minty_iamfoureels1 = "I'm sorry Ms. Jackson",
            k_fac_minty_iamfoureels2 = "I am four eels",
            k_fac_minty_iamfoureels3 = "Never meant to make your daughter cry",
            k_fac_minty_iamfoureels4 = "I am several fish and not a guy",
            
            ppu_bubble_minty_jealusable = " use me and i'll grant your wish! ",
            ppu_bubble_minty_jealused = " come back soon! ",
            fac_minty_jealfree = "free"
        },
        labels={},
        poker_hand_descriptions={},
        poker_hands={},
        quips={
            fac_minty_trauma_center = {
                "The Medical Board",
                "will be notified."
            }
        },
        v_dictionary={},
        v_text={},
    },
}