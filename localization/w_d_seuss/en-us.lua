return {
    descriptions = {
        PotatoPatch = {
			PotatoPatchDev_Nick = {
				name = "Moby Nick",
                text = {
                    "Meow"
                },
			},
            PotatoPatchDev_Jolyne = {
				name = "JoFIN",
                text = {
                    "Meow"
                },
			},
        },
        fac_Fish = {
            fish_fac_one = {
                name = "One Fish",
                text = {
                    "Played {C:attention}Aces{}",
                    "give {C:mult}+#1#{} Mult",
                    "when scored",
                },
                flavour = {
                    "Its name seems redundant.",
                    "I mean, it's not like you can",
                    "catch multiple fish at once..."
                }
            },
            fish_fac_two = {
                name = "Two Fish",
                text = {
                    "Played {C:attention}2s{}",
                    "give {C:mult}+#1#{} Mult",
                    "when scored",
                },
                flavour = {
                    "Well, holy carp! You CAN",
                    "catch two fish at once!"
                }
            },
            fish_fac_red = {
                name = "Red Fish",
                text = {
                    "Converts {C:attention}#1#%{} of scored",
                    "{C:chips}Chips{} to {C:mult}Mult{} and set",
                    "scored {C:chips}Chips{} to base",
                    "poker hand {C:chips}Chips",
                },
                flavour = {
                    "Doesn't really work",
                    "with Blue Fish :/"
                }
            },
            fish_fac_blue = {
                name = "Blue Fish",
                text = {
                    "Convert {C:attention}#1#%{} of scored",
                    "{C:mult}Mult{} to {C:chips}Chips{} and set",
                    "scored {C:mult}Mult{} to base",
                    "poker hand {C:mult}Mult",
                },
                flavour = {
                    "Doesn't really work",
                    "with Red Fish :/"
                }
            },
            fish_fac_old = {
                name = "Old Fish",
                text = {
                    "Creates a Fish with",
                    "a {C:blind}Deltarune{} attribute",
                    "{C:inactive}(Must have room)",
                },
                flavour = {
                    "{C:green}Gyaa Ha Ha!"
                }
            },
            fish_fac_bad = {
                name = "Bad Fish",
                text = {
                    {
                        "{X:blind,C:inscryption_blue}Brittle:",
                        "{C:red}Instantly perish{} at the",
                        "end of final score",
                    },
                    {
                        "{X:blind,C:inscryption_blue}Annoying:",
                        "When {C:attention}Blind{} is selected,",
                        "Increase Blind",
                        "Requirement by {X:blind,C:white}X#1#{}"
                    },
                    {
                        "Cannot be sold",
                        "{C:inactive,s:0.6}How {C:jolyne,s:0.6}priceless{C:inactive,s:0.6}..."
                    }
                },
                flavour = {
                    "Lost the 50/25/25 Lmao",
                }
            },
            fish_fac_darwin = {
                name = "Darwin",
                text = {
                    "{X:mult,C:white}X#1#{} Mult after",
                    "{C:attention}#2#{C:inactive} [#3#]{} rounds",
                    "{C:inactive}#4#"
                },
                flavour = {
                    "I'm on my way, I'm on my way!"
                }
            },
            fish_fac_pear = {
                name = "Pear Fish",
                text = {
                    "The next {C:attention}#1#{C:inactive} [#2#]{} fishing",
                    "attempts, successful fish",
                    "catches level up {C:attention}Pair{} by {C:attention}#3#{}"
                },
                flavour = {
                    "A dark, forboding",
                    "feeling overtakes you.",
                    "You know this face,",
                    "even in its absence."
                }
            },
            fish_fac_sukuna = {
                name = "Ryomen Sutuna",
                text = {
                    "Switch {C:attention}current",
                    "{C:attention}ability{} when used",
                    "{C:inactive}(Currently {C:mult}+#1#{C:inactive} Mult)",
                    "{C:inactive}(Currently {C:chips}+#2#{C:inactive} Chips)",
                    "{C:inactive}(Currently: #3#)"
                },
                flavour = {
                    "King of Sturgeons"
                }
            },
            fish_fac_gojo = {
                name = "Troutoru GoFish",
                text = {
                    ""
                },
                flavour = {
                    ""
                }
            },
            fish_fac_lordx = {
                name = "Lord X-ray Fish",
                text = {
                    ""
                },
                flavour = {
                    "{element:1}"
                }
            },
            fish_fac_majin = {
                name = "Marlin",
                text = {
                    ""
                },
                flavour = {
                    "{element:1}"
                }
            },
            fish_fac_redglove = {
                name = "Red-Herring",
                text = {
                    ""
                },
                flavour = {
                    "{element:1}"
                }
            },
            fish_fac_faker = {
                name = "Flounder",
                text = {
                    ""
                },
                flavour = {
                    "{element:1}"
                }
            },
            fish_fac_spalmon = {
                name = "[[{C:spalmon_pink}SPA{}L{C:spalmon_gold}MON{}]]",
                text = {
                    "{s:2}[Press F1 For] HELP",
                    "{C:inactive}at a [[phishing]] [site]"
                },
                flavour = {
                    "ARE {s:0.5,C:hearts}YOU{} GETTING ALL THIS {s:1.5,C:white}[Mack]{}!?",
                    "{s:0.7}I'M FINALLY {s:1.3}I'M FINALLY{} GONNA",
                    "BE A {s:2,C:spalmon_pink}BIG {s:2,C:spalmon_gold}TROUT{s:2}!!!{}"
                }
            },
            fish_fac_forgotten = {
                name = "Forgotten Fish",
                text = {
                    "Gains {C:fac_sand_dollars,f:fac_sand_dollars}${C:fac_sand_dollars}#1#{} of",
                    "{C:attention}sell value{} at",
                    "end of fishing",
                },
                flavour = {
                    "Well, there is a fish here."
                }
            },
            fish_fac_togore = {
                name = "Topegore",
                text = {
                    "",
                },
                flavour = {
                    ""
                }
            },
            fish_fac_gaster = {
                name = "Basster",
                text = {
                    "",
                },
                flavour = {
                    "Notably Not Green"
                }
            },
        },
        Other = {
            w_d_seuss_dismantle = {
                name = "Dismantle",
                text= {
                    "Destroy a random Fish",
                    "and add {C:attention}double{} its",
                    "sell value to this {C:mult}Mult",
                },
            },
            w_d_seuss_cleave = {
                name = "Cleave",
                text= {
                    "Destroy selected card",
                    "and add {C:attention}triple{} its rank",
                    "value to this {C:chips}Chips",
                },
            },
        },
    },
    misc = {
        dictionary = {
            k_omw = "I'm on my way!",
            k_lost = "I'm lost :(",
            k_dismantle = "Dismantle",
            k_cleave = "Cleave",
            k_bigtrout = "[[BIG TROUT]]",
            k_hokimama = "[HOKI MAMA]",
        },
        achievement_names = {
        },
        achievement_descriptions = {
        },
        quips = {
        },
        v_dictionary = {
        },
        tutorial = {
        },
    }
}
