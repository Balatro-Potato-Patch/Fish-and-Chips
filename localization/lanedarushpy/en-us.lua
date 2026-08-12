return {
    descriptions = {
        fac_Fish = {
            fish_fac_floppy_fih = {
                name = "Floppy Fish",
                text = {
                    "Occasionally starts {C:attention}flopping",
                    "and permanently gains {X:mult,C:white}X#1#{} Mult",
                    "when the flopping is stopped",
                    "by {C:attention}selecting{} this fish",
                    "{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive} Mult)"
                },
                flavour = {
                    "flippity floppity",
                    "i am no longer",
                    "your property"
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
                    "I'm pretty sure this",
                    "is a fish, right? It has fins."
                }
            },

            fish_fac_argel_blowfish = {
                name = "Blowfish",
                text = {
                    "{C:attention}Blows{} the fish to the",
                    "left to the {C:attention}other side",
                    "of the area, and gives",
                    "{C:fac_sand_dollars,f:fac_sand_dollars}$#1#{} for each fish",
                    "passed on the way"
                },
                flavour = {
                    "I'm sorry, but what did you expect",
                    "for a 'blowfish'?"
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

                    "{C:attention}Using{} this Fish makes it",
                    "eat a random owned Fish,",
                    "gaining {C:fac_sand_dollars,f:fac_sand_dollars}+$#1#{} in",
                    "sell value for each fish eaten",
                    "{C:inactive}(Once per round, max of {C:fac_sand_dollars,f:fac_sand_dollars}+$#2#{C:inactive})"
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
                    "Joker or Fish trigger",
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
                    "All owned Fish give {X:mult,C:white}X#3#{} Mult",
                    "{C:green}#1# in #2#{} chance this Fish is",
                    "destroyed at end of round",
                },
                flavour = {
                    "banana fih"
                }
            },

            fish_fac_lizzie_jellyfish = {
                name = {
                    "Immortal Jellyfish",
                    "{C:inactive,s:0.75}#1#"
                },
                text = {
                    {
                        "{C:green}#2#{}#3#",
                        "#4#{C:fac_sand_dollars,f:fac_sand_dollars}#5#{C:inactive}#8#",
                        "#6#{C:attention}#7#"
                    },
                    {
                        "A {C:attention}maturing{} or {C:attention}mature{} Jellyfish",
                        "will regress to its {C:attention}Polyp{} stage",
                        "when {C:red}destroyed{}, with a {C:green}#9# in #10#{}",
                        "chance to create a new {C:attention}Larva{}",
                        "when it matures",
                        "{C:inactive}(Stage changes at end of round){}"
                    }
                },
                flavour = {
                    "Branching off from the known immortal jellyfish,",
                    "this jellyfish has adapted to mimic a purple",
                    "presence just to survive in the harshest environments."
                }
            },

            fish_fac_lizie_toxikarp = {
                name = "Toxikarp",
                text = {
                    {
                        "Before scoring, blows a {C:attention}bubble",
                        "around a random owned Joker"
                    },
                    {
                        "If the bubbled Joker triggers",
                        "during {C:attention}scoring{}, the bubble",
                        "pops, giving {X:mult,C:white}X#1#{} Mult"
                    }
                },
                flavour = {
                    "Fished from the waters of scourges and tumors,",
                    "this fish would be having better days",
                    "not as a makeshift weapon."
                }
            },

            fish_fac_lizie_bladetongue = {
                name = "Bladetongue",
                text = {
                    {
                        "Once per round, use this Fish",
                        "to activate it for one hand"
                    },
                    {
                        "When active, Bladetongue {C:red}slashes",
                        "the first scored {C:hearts}Hearts{} card,",
                        "destroying it and applying",
                        "{X:purple,C:white}X#1#{} blind size"
                    }
                },
                flavour = {
                    "Fished from the waters of guck and flesh,",
                    "this fish would be having better days",
                    "with a cleaner tongue."
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
            k_fac_lizie_terria = "Weaponized Fish",
            k_fac_lizie_jellyfish_larva = "(Larva)",
            k_fac_lizie_jellyfish_polyp = "(Polyp)",
            k_fac_lizie_jellyfish_maturing = "(Maturing)",
            k_fac_lizie_jellyfish_mature = "(Mature)",
        }
    }
}