return {
    descriptions = {
        Other={},
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
                    "Use for {C:green}#1# in #2#{} chance",
                    "to get a sand dollar, and",
                    "{C:green}#3# in #4#{} chance for some bait",
                    "Also {C:red}culls the population{}",
                    "of this invasive species"
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
                    "Use for {C:green}#1# in #2#{} chance",
                    "to get a sand dollar, and",
                    "{C:green}#3# in #4#{} chance for some bait",
                    "The fish was healthier",
                    "in its native habitat."
                }
            },
            fish_fac_minty_fission = {
                name = "Fission Chip",
                flavour = {
                    "This isn't a fish??",
                },
                text = {
                    "{C:green}#1# in #2#{} chance to",
                    "retrigger any other fish",
                    "#3# time#4#"
                }
            },
            fish_fac_minty_catfish = {
                name = "Catfish",
                flavour = {
                    "Mrrp mew mrew :3",
                },
                text = {
                    "{C:green}#1#{} denominator to",
                    "all listed probabilities",
                    "{C:inactive,s:0.8}(e.g. {C:green,s:0.8}1 in 5{C:inactive,s:0.8} -> {C:green,s:0.8}1 in #2#{C:inactive,s:0.8})"
                }
            },
            fish_fac_minty_dogfish = {
                name = "Dogfish",
                flavour = {
                    "It's hungry!",
                },
                text = {
                    "{C:red}Destroy{} played {C:attention}Lucky Cards{}",
                    "and gain {C:white,X:mult}X#2#{} Mult for each",
                    "{C:inactive}(Currently {C:white,X:mult}X#1#{C:inactive})"
                }
            },
            fish_fac_minty_shrimp_npc = {
                name = "The Shrimp NPC",
                flavour = {
                    "Hello there!",
                    "As the Shrimp NPC,"
                },
                text = {}
            },
            fish_fac_minty_goldfish = {
                name = "Goldfish",
                flavour = {
                    "Smiles back, but",
                    "it's not a snack"
                },
                text = {
                    "Gains {C:fac_sand_dollars,f:fac_sand_dollars}$#1#{} sell value",
                    "when gaining money"
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
                    "When leveling up any hand",
                    "{C:green}#1# in #2#{} chance to",
                    "level it up again"
                }
            },
            fish_fac_minty_mimic_octopus = {
                name = "Mimic Octopus",
                flavour = {
                    "Koppi, arms up!"
                },
                text = {
                    "{C:attention}Use{} to copy fish to",
                    "the right until end of round",
                    "{C:inactive}(Currently copying: {C:attention}#1#{C:inactive})"
                }
            },
            fish_fac_minty_electric_eel = {
                name = "Electric Eel",
                flavour = {
                    "If there were four of",
                    "them, Outkast would have",
                    "to sing an apology."
                },
                text = {
                    "{C:attention}Use{} to ready a stored",
                    "charge ({C:blue}#1#{} available)",
                    "For each readied charge ({C:red}#2#{}),",
                    "retrigger every Joker and",
                    "fish next hand"
                    
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
                    "fish next hand"
                    
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
                    "{X:purple,C:white}X#1#{} Blind size when",
                    "entering blind and after",
                    "each hand played"
                }
            },
            fish_fac_minty_elder_tuna = {
                name = "Elder Tuna",
                flavour = {
                    "I'm old!"
                },
                text = {
                    "When acquired, level up",
                    "a semi-random poker hand",
                    --[[
                    "{C:inactive}(33% highest level,",
                    "{C:inactive}33% most played,",
                    "{C:inactive}22% lowest level,",
                    "{C:inactive}11% random visible)"
                    --]]
                }
            },
            fish_fac_minty_tundra_eel = {
                name = "Tundra Eel",
                flavour = {
                    "... damn it, I already",
                    "made the Outkast joke."
                },
                text = {
                    "{C:purple}Balances{} #1#% of",
                    "Chips and Mult,",
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
                    {"Hi again! Mrrp mrew :3"}
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
            k_fac_minty_chum = "Chum",
            k_fac_minty_iamfoureels1 = "I'm sorry Ms. Jackson",
            k_fac_minty_iamfoureels2 = "I am four eels",
            k_fac_minty_iamfoureels3 = "Never meant to make your daughter cry",
            k_fac_minty_iamfoureels4 = "I am several fish and not a guy",
        },
        labels={},
        poker_hand_descriptions={},
        poker_hands={},
        quips={},
        v_dictionary={},
        v_text={},
    },
}