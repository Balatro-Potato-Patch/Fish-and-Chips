return {
    descriptions = {
        fac_Fish = {
            fish_fac_floppy_fih = {
                name = "Floppy Fish",
                text = {
                    "Occasionally starts {C:attention}flopping",
                    "Gains {X:mult,C:white}X#1#{} Mult when",
                    "stopping the flopping",
                    "by {C:attention}selecting{} this {C:fac_fish}Fish{}",
                    "{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive} Mult)"
                },
                flavour = {
                    "flippity floppity",
                    "i am no longer your property"
                }
            },

            fish_fac_flying_fih = {
                name = "Flying Fish",
                text = {
                    "Gives {C:attention}#1#{} divided by",
                    "current {C:chips}Chips{} as {X:mult,C:white}XMult{}",
                    "{C:inactive}(Capped at {X:mult,C:white}X#2#{C:inactive} Mult)"
                },
                flavour = {
                    "I'm pretty sure this is a",
                    "fish, right? It has fins."
                }
            },

            fish_fac_argel_blowfish = {
                name = "Blowfish",
                text = {
                    "During scoring, {C:attention}blows{} the",
                    "leftmost {C:fac_fish}Fish{} all the way to the",
                    "{C:attention}right{}, then earn {C:fac_sand_dollars,f:fac_sand_dollars}$#1#{} for each",
                    "{C:fac_fish}Fish{} it passed on the way"
                },
                flavour = {
                    "I'm sorry, but what did you",
                    "expect for a 'blowfish'?"
                }
            },

            fish_fac_argel_findows = {
                name = "Findows",
                text = {
                    "{C:inactive}(Music made by {C:purple}Lizzie{C:inactive})"
                },
                flavour = {
                    "Would probably taste like Fruit Air.",
                }
            },

            fish_fac_argel_thing = {
                name = "Thing",
                text = {
                    "Once per round, {C:red}eats{} a random",
                    "{C:fac_fish}Fish{} and gains {C:fac_sand_dollars,f:fac_sand_dollars}$#1#{} in {C:attention}sell value{}",
                    "for each {C:fac_fish}Fish{} eaten so far",
                    "{C:inactive}(Max of {C:fac_sand_dollars,f:fac_sand_dollars}+$#2#{C:inactive} sell value)",
                    "{ppu_bubble:usable}"
                },
                flavour = {
                    "What the hell did you just find.",
                    "What in the world?"
                }
            },

            fish_fac_still_fish = {
                name = "Still Fish",
                text = {
                    "{C:green}#1# in #2#{} chance for any",
                    "{C:attention}Joker{} or {C:fac_fish}Fish{} trigger",
                    "to be {C:green}repeated"
                },
                flavour = {
                    "The hardest part was",
                    "catching its unmoving body."
                }
            },

            fish_fac_lizie_cafindish = {
                name = "Cafindish",
                text = {
                    "All owned {C:fac_fish}Fish{} give {X:mult,C:white}X#3#{} Mult",
                    "{C:green}#1# in #2#{} chance this {C:fac_fish}Fish{} is",
                    "destroyed at end of round",
                },
                flavour = {
                    "banana fih"
                }
            },

            fish_fac_lizzie_jellyfish_larva = {
                name = {
                    "Immortal Jellyfish",
                    "{C:inactive,s:0.75}(Larva)"
                },
                text = {
                    "Becomes a {C:attention}polyp{} at",
                    "the end of the round"
                },
                flavour = {
                    "Branching off from the known immortal jellyfish,",
                    "this jellyfish has adapted to mimic a purple presence",
                    "just to survive in the harshest environments."
                }
            },
            fish_fac_lizzie_jellyfish_polyp = {
                name = {
                    "Immortal Jellyfish",
                    "{C:inactive,s:0.75}(Polyp)"
                },
                text = {
                    {
                        "{C:green}#1# in #2#{} chance to earn {C:fac_sand_dollars,f:fac_sand_dollars}$#3#{}",
                        "at the end of the round"
                    },
                    {
                        "Becomes {C:attention}maturing{} at",
                        "the end of the round,",
                        "{C:green}#4# in #5#{} chance to create a",
                        "{C:attention}larva{} when this happens"
                    }
                },
                flavour = {
                    "Branching off from the known immortal jellyfish,",
                    "this jellyfish has adapted to mimic a purple presence",
                    "just to survive in the harshest environments."
                }
            },
            fish_fac_lizzie_jellyfish_maturing = {
                name = {
                    "Immortal Jellyfish",
                    "{C:inactive,s:0.75}(Maturing)"
                },
                text = {
                    {
                        "{C:green}#1# in #2#{} chance to earn {C:fac_sand_dollars,f:fac_sand_dollars}$#3#{}",
                        "at the end of the round"
                    },
                    {
                        "If {C:red}destroyed{}, regresses",
                        "to a {C:attention}polyp{} instead",
                        "Becomes {C:attention}mature{} at",
                        "the end of the round"
                    }
                },
                flavour = {
                    "Branching off from the known immortal jellyfish,",
                    "this jellyfish has adapted to mimic a purple presence",
                    "just to survive in the harshest environments."
                }
            },
            fish_fac_lizzie_jellyfish = {
                name = {
                    "Immortal Jellyfish",
                    "{C:inactive,s:0.75}(Mature)"
                },
                text = {
                    {
                        "{C:green}#1# in #2#{} chance to earn {C:fac_sand_dollars,f:fac_sand_dollars}$#3#{}",
                        "at the end of the round"
                    },
                    {
                        "If {C:red}destroyed{}, regresses",
                        "to a {C:attention}polyp{} instead"
                    }
                },
                flavour = {
                    "Branching off from the known immortal jellyfish,",
                    "this jellyfish has adapted to mimic a purple presence",
                    "just to survive in the harshest environments."
                }
            },

            fish_fac_lizie_toxikarp = {
                name = "Toxikarp",
                text = {
                    {
                        "Before scoring, blows a {C:dark_edition}bubble",
                        "around a random owned {C:attention}Joker{}"
                    },
                    {
                        "If the {C:dark_edition}bubbled{} {C:attention}Joker{} triggers",
                        "during {C:attention}scoring{}, the bubble",
                        "{C:blue}pops{} and gives {X:mult,C:white}X#1#{} Mult"
                    }
                },
                flavour = {
                    "Fished from the waters of scourges",
                    "and tumors, this fish would be having",
                    "better days not as a makeshift weapon."
                }
            },

            fish_fac_lizie_bladetongue = {
                name = "Bladetongue",
                text = {
                    {
                        "Once per round, {C:attention}use{} this {C:fac_fish}Fish{}",
                        "to {C:green}activate{} it for one hand",
                        "{ppu_bubble:1}{ppu_bubble:2}"
                    },
                    {
                        "When {C:green}active{}, {C:fac_fish}Bladetongue{} {C:red}slashes",
                        "the first scored {C:hearts}Hearts{} card",
                        "and gives {X:blind,C:white}X#1#{} Blind size"
                    }
                },
                flavour = {
                    "Fished from the waters of guck and",
                    "flesh, this fish would be having better",
                    "days with a cleaner tongue."
                }
            }
        },
        PotatoPatch = {
            PotatoPatchDev_lanedarushpy = {
                name = "Lizzie",
                text = {
                    "A simple purple creature",
                    "I made the balacats",
                    "banana fih",
                }
            },
            PotatoPatchDev_pangaea47 = {
                name = "Argel",
                text = {
                    "im a spider who just fishened",
                    "i dont think thats a word",
                    "whatever im a good artist hi"
                }
            }
        }
    },

    misc = {
        dictionary = {
            k_fac_sand_dollars = "Sand Dollars",
            k_fac_lizie_dollars = "Dollars",
            k_fac_lizie_chips = "Chips",
            k_fac_lizie_repeated = "Repeated!",
            k_fac_lizie_ready = "Ready!",
            k_fac_lizie_regressed = "Regressed!",
            k_fac_lizie_birthed = "Birthed!",
            k_fac_lizie_aged = "Aged!",
            k_fac_lizie_fly = "Totally a Fish",
            k_fac_lizie_windows = "Window",
            k_fac_lizie_blow = "Fan",
            k_fac_lizie_thing = "Unknown",
            k_fac_lizie_still = "Still Life",
            k_fac_lizie_jelly = "Jellyfish",
            k_fac_lizie_terria = "Weaponized Fish",
            k_fac_lizie_jellyfish_larva = "(Larva)",
            k_fac_lizie_jellyfish_polyp = "(Polyp)",
            k_fac_lizie_jellyfish_maturing = "(Maturing)",
            k_fac_lizie_jellyfish_mature = "(Mature)",
        }
    }
}