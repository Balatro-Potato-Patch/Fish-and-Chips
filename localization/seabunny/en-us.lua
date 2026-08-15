return {
    descriptions = {
        PotatoPatch = {
			PotatoPatchDev_ouiiskey = {
				name = "ouiiskey",
                text = {
                    "Teammate with {element:1}"
                }
			},
			PotatoPatchDev_Lusha = {
				name = "Lusha",
                text = {
                    {
                        "{C:attention}queergirlbunnydollthing with very normal thoughts :3",
                        "{C:inactive,s:0.8}i'm a drawer, we made the mineral fishes glugluglu",
                        "teammate with {V:1}ouiiskey"
                    },
                    {
                        "play Ghost trick, Peglin, Mother 3",
                        'and my balatro mod "LushedUp"!',
                        "except you can't because",
                        "it's not finished!! (idk how to code)"
                    },
                    {
                        "{element:1}"
                    }
                }
			}
        },
        fac_Fish = {
            fish_fac_skyfish = {
                name = "Skyfish",
                text = {
                    {
                        "Double this fish's",
                        "length at end of round",
                        "{C:inactive}(Max #1# m)"
                    },
                    {
                        "{C:attention}Use{}: -#2# cm length,",
                        "{C:attention}+1 Classic Canned{}", -- intentional bleed here but could be adjusted - gabby
                        "{ppu_bubble:usable}",
                    }
                },
                flavor = {
                    "This UMA is often caught on",
                    "camera swimming through the air,",
                    "but you are the first fisher",
                    "to catch one in person."
                }
            },
            fish_fac_quartz_pip = {
                name = "Quartz Pip",
                text = {
                    {
                        "{C:green}#1# in #2#{} chance to retrigger",
                        "played Unenhanced cards"
                    },
                    {
                        "{C:inactive}Enchanted: #3# in #4# chance",
                        "{C:inactive}for a separate retrigger"
                    },
                    {
                        "To {C:dark_edition}Enchant{}: Score",
                        "Unenhanced cards {C:attention}#5#{} times",
                        "{C:inactive}(Currently {C:attention}#6#{C:inactive}/#5#)"
                    }
                },
                flavor = {
                    "Fun fact: Amethyst is",
                    "just purple quartz."
                }
            },
            fish_fac_quartz_pip_enchant = {
                name = "Quartz Pip",
                text = {
                    {
                        "{C:green}#1# in #2#{} chance to retrigger",
                        "played Unenhanced cards"
                    },
                    {
                        "{C:dark_edition}Enchanted{}: {C:green}#3# in #4#{} chance",
                        "for a separate retrigger"
                    }
                },
                flavor = {
                    "Fun fact: Amethyst is",
                    "just purple quartz."
                }
            },
            fish_fac_iron_silverfish = {
                name = "Iron Silverfish",
                text = {
                    {
                        "When a {C:attention}Stone{} card is destroyed,",
                        "add an Unenhanced copy to",
                        "deck with permanent {C:chips}+#1#{} Chips"
                    },
                    {
                        "{C:inactive}Enchanted: Stone cards",
                        "{C:inactive}are destroyed when scored"
                    },
                    {
                        "To {C:dark_edition}Enchant{}: Score a card with",
                        "{C:chips}#2#{} or more Chips #3# times",
                        "{C:inactive}(Currently {C:attention}#4#{C:inactive}/#3#)"
                    }
                },
                flavor = {
                    [[Here's another "quick-silver"]],
                    [[you don't want to eat!]]
                }
            },
            fish_fac_iron_silverfish_enchant = {
                name = "Iron Silverfish",
                text = {
                    {
                        "When a {C:attention}Stone{} card is destroyed,",
                        "add an Unenhanced copy to",
                        "deck with permanent {C:chips}+#1#{} Chips"
                    },
                    {
                        "{C:dark_edition}Enchanted{}: {C:purple}Stone{} cards",
                        "are destroyed when scored"
                    }
                },
                flavor = {
                    [[Here's another "quick-silver"]],
                    [[you don't want to eat!]]
                }
            },
            fish_fac_ruby_snapper = {
                name = "Ruby Snapper",
                text = {
                    {
                        "Gains {C:attention}sell value{} of first",
                        "{C:fac_fish}Fish{} sold each round"
                    },
                    {
                        "{C:inactive}Enchanted: Double",
                        "{C:inactive}sell value when sold"
                    },
                    {
                        "To {C:dark_edition}Enchant{}: Sell #1# {C:fac_fish}Fish",
                        "{C:inactive}(Currently {C:attention}#2#{C:inactive}/#1#)"
                    }
                },
                flavor = {
                    "Its eyes absorb the",
                    "souls of the dying."
                }
            },
            fish_fac_ruby_snapper_enchant = {
                name = "Ruby Snapper",
                text = {
                    {
                        "Gains {C:attention}sell value{} of first",
                        "fish sold each round"
                    },
                    {
                        "{C:dark_edition}Enchanted{}: Double",
                        "{C:attention}sell value{} when sold"
                    }
                },
                flavor = {
                    "Its eyes absorb the",
                    "souls of the dying."
                }
            },
            fish_fac_lapis_catfish = {
                name = "Lapis Catfish",
                text = {
                    {
                        "Balance {C:purple}#1#%{} of {C:chips}Chips{} and {C:mult}Mult",
                        "{C:purple}-#2#%{} per round played"
                    },
                    {
                        "{C:inactive}Enchanted: +#2#% per round instead",
                        "{C:inactive}(Max #3#%)"
                    },
                    {
                        "To {C:dark_edition}Enchant{}: {C:green}#4# in #5#{} chance when",
                        "a fish is sold during a {C:attention}Blind"
                    }
                },
                flavor = {
                    "Blue like the sea."
                }
            },
            fish_fac_lapis_catfish_enchant = {
                name = "Lapis Catfish",
                text = {
                    {
                        "Balance {C:attention}#1#%{} of {C:chips}Chips{} and {C:mult}Mult",
                        "{C:attention}-#2#%{} per round played"
                    },
                    {
                        "{C:dark_edition}Enchanted{}: {C:attention}+#2#%{} per round instead",
                        "{C:inactive}(Max {C:attention}#3#%{C:inactive})"
                    }
                },
                flavor = {
                    "Blue like the sea."
                }
            },
            fish_fac_golden_goldfish = {
                name = "Golden Goldfish",
                text = {
                    {
                        "{C:green}#1# in #2#{} chance to destroy last",
                        "scored card, double money if",
                        "it was {C:attention}Gold{}, halve otherwise",
                        "{C:inactive}(Range of {C:money}-$#3#{C:inactive} to {C:money}+$#3#{C:inactive})"
                    },
                    {
                        "{C:inactive}Enchanted:",
                        "{C:inactive}Range of -$#3# to +$#4# instead"
                    },
                    {
                        "To {C:dark_edition}Enchant{}: Destroy #5# cards",
                        "{C:inactive}(Currently {C:attention}#6#{C:inactive}/#5#)"
                    }
                },
                flavor = {
                    "A goldfish made of gold? What's",
                    "next? A silverfish made of iron?"
                }
            },
            fish_fac_golden_goldfish_enchant = {
                name = "Golden Goldfish",
                text = {
                    {
                        "{C:green}#1# in #2#{} chance to destroy last",
                        "scored card, double money if",
                        "it was {C:attention}Gold{}, halve otherwise",
                        "{C:inactive}(Range of {C:money}-$#3#{C:inactive} to {C:money}+$#3#{C:inactive})"
                    },
                    {
                        "{C:dark_edition}Enchanted{}:",
                        "Range of {C:money}-$#3#{} to {C:money}+$#4#{} instead"
                    }
                },
                flavor = {
                    "A goldfish made of gold? What's",
                    "next? A silverfish made of iron?"
                }
            },
            fish_fac_opal_moonfish = {
                name = "Opal Moonfish",
                text = {
                    {
                        "At end of round,",
                        "create a {C:planet}Planet{} card for",
                        "a random played {C:attention}poker hand",
                    },
                    {
                        "{C:inactive}Enchanted:",
                        "{C:inactive}When you select a Boss Blind,",
                        "{C:inactive}disable it and Unenchant this"
                    },
                    {
                        "To {C:dark_edition}Enchant{}: Skip #1# {C:attention}Blinds",
                        "{C:inactive}(Currently {C:attention}#2#{C:inactive}/#1#)"
                    }
                },
                flavor = {
                    "Normally resting in undersea caves,",
                    "this fish surfaces with the full moon."
                }
            },
            fish_fac_opal_moonfish_enchant = {
                name = "Opal Moonfish",
                text = {
                    {
                        "At end of round,",
                        "create a {C:planet}Planet{} card for",
                        "a random played {C:attention}poker hand",
                    },
                    {
                        "{C:dark_edition}Enchanted{}:",
                        "When you select a {C:attention}Boss Blind{},",
                        "disable it and Unenchant this"
                    }
                },
                flavor = {
                    "Normally resting in undersea caves,",
                    "this fish surfaces with the full moon."
                }
            },
            fish_fac_bismuth_totemfish = {
                name = "Bismuth Totemfish",
                text = {
                    {
                        "Unenhanced cards in",
                        "your poker hand steal",
                        "{C:attention}Enhancements{} from your deck"
                    },
                    {
                        "{C:inactive}Enchanted: This gains",
                        "{X:inactive,C:white}X#1#{C:inactive} Mult this hand per unique",
                        "{C:inactive}Enhancement in poker hand",
                        "{C:inactive}(Currently {X:inactive,C:white}X#2#{C:inactive} Mult)"
                    },
                    {
                        "To {C:dark_edition}Enchant{}:",
                        "Steal #3# {C:attention}Enhancements",
                        "{C:inactive}(Currently {C:attention}#4#{C:inactive}/#3#)"
                    }
                },
                flavor = {
                    "Mix with copper and zinc",
                    "for the perfect Poke bowl."
                }
            },
            fish_fac_bismuth_totemfish_enchant = {
                name = "Bismuth Totemfish",
                text = {
                    {
                        "Unenhanced cards in",
                        "your poker hand steal",
                        "{C:attention}Enhancements{} from your deck"
                    },
                    {
                        "{C:dark_edition}Enchanted{}: This gains",
                        "{X:mult,C:white}X#1#{} Mult this hand per unique",
                        "{C:attention}Enhancement{} in poker hand",
                        "{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive} Mult)"
                    }
                },
                flavor = {
                    "Mix with copper and zinc",
                    "for the perfect Poke bowl."
                }
            },
            fish_fac_betta_onyx = {
                name = "Betta Onyx",
                text = {
                    {
                        "When {C:attention}Blind{} is selected,",
                        "create a {C:attention}consumable{} of",
                        "each type you're missing",
                        "{C:inactive}(Must have room)"
                    },
                    {
                        "{C:inactive}Enchanted:",
                        "{C:inactive}+1 consumable slot for each",
                        "{C:inactive}consumable type you have",
                        "{C:inactive}(Currently +#1#)"
                    },
                    {
                        "To {C:dark_edition}Enchant{}: Use #2# {C:attention}consumables{}",
                        "{C:inactive}(Currently {C:attention}#3#{C:inactive}/#2#)"
                    }
                },
                flavor = {
                    "It looks like some cool black crystal..."
                }
            },
            fish_fac_betta_onyx_enchant = {
                name = "Betta Onyx",
                text = {
                    {
                        "When {C:attention}Blind{} is selected,",
                        "create a {C:attention}consumable{} of",
                        "each type you're missing",
                        "{C:inactive}(Must have room)"
                    },
                    {
                        "{C:dark_edition}Enchanted{}:",
                        "{C:attention}+1{} consumable slot for each",
                        "{C:attention}consumable{} type you have",
                        "{C:inactive}(Currently {C:attention}+#1#{C:inactive})"
                    }
                },
                flavor = {
                    "It looks like some cool black crystal..."
                }
            },
            fish_fac_aquamarine_anglerfish = {
                name = "Aquamarine Anglerfish",
                text = {
                    {
                        "When your deck runs out,",
                        "this gains {X:mult,C:white}X#1#{} Mult",
                        "per card held in hand",
                        "{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive} Mult)"
                    },
                    {
                        "{C:inactive}Enchanted: When your deck",
                        "{C:inactive}runs out, cards held in hand",
                        "{C:inactive}gain 1 retrigger this round"
                    },
                    {
                        "To {C:dark_edition}Enchant{}: Discard exactly",
                        "{C:attention}#3#{} cards #4# times in a row",
                        "{C:inactive}(Currently {C:attention}#5#{C:inactive}/#4#)"
                    }
                },
                flavor = {
                    "This fish uses its gemstone",
                    "as a light source to survive",
                    "in the depths it calls home."
                }
            },
            fish_fac_aquamarine_anglerfish_enchant = {
                name = "Aquamarine Anglerfish",
                text = {
                    {
                        "When your deck runs out,",
                        "this gains {X:mult,C:white}X#1#{} Mult",
                        "per card held in hand",
                        "{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive} Mult)"
                    },
                    {
                        "{C:dark_edition}Enchanted{}: When your deck",
                        "runs out, cards held in hand",
                        "gain {C:attention}1{} retrigger this round"
                    }
                },
                flavor = {
                    "This fish uses its gemstone",
                    "as a light source to survive",
                    "in the depths it calls home."
                }
            },
            fish_fac_prismond_bunnyfish = {
                name = "Prismond Bunnyfish",
                text = {
                    {
                        "If {C:attention}poker hand{} contains",
                        "#1# {C:attention}Suits{}, add {C:dark_edition}Polychrome{} to a",
                        "random card of each rank in it"
                    },
                    {
                        "{C:inactive}Enchanted: Played cards",
                        "{C:inactive}with Polychrome give",
                        "{X:inactive,C:white}X#2#{C:inactive} Mult when scored",
                    },
                    {
                        "To {C:dark_edition}Enchant{}: Discard a hand",
                        "that contains a {C:attention}Straight",
                        "or {C:attention}Flush{} #3# times",
                        "{C:inactive}(Currently {C:attention}#4#{C:inactive}/#3#)"
                    }
                },
                flavor = {
                    "They say rabbits' feet bring you luck.",
                    "This time luck brought you a rabbit!"
                }
            },
            fish_fac_prismond_bunnyfish_enchant = {
                name = "Prismond Bunnyfish",
                text = {
                    {
                        "If {C:attention}poker hand{} contains",
                        "#1# {C:attention}Suits{}, add {C:dark_edition}Polychrome{} to a",
                        "random card of each rank in it"
                    },
                    {
                        "{C:dark_edition}Enchanted{}: Played cards",
                        "with {C:dark_edition}Polychrome{} give",
                        "{X:mult,C:white}X#2#{} Mult when scored",
                    }
                },
                flavor = {
                    "They say rabbits' feet bring you luck.",
                    "This time luck brought you a rabbit!"
                }
            },
            fish_fac_enchantfish = {
                name = "Enchantfish",
                text = {
                    "After {C:attention}#1#{} rounds, sell this to",
                    "{C:dark_edition}enchant{} your {C:attention}Mineral Fishes{},",
                    "then double sell value of your",
                    "Unenchanted {C:attention}Fishes{}, up to {C:fac_sand_dollars}+{C:fac_sand_dollars,f:fac_sand_dollars}${C:fac_sand_dollars}#2#",
                    "{C:inactive}(Currently {C:attention}#3#{C:inactive}/#1#)"
                },
                flavor = {
                    "{f:fac_sga}Is this a book brought to life by magic or",
                    "{f:fac_sga}a fish brought to magic by life Who knows"
                }
            }
        }
    },
    misc = {
        dictionary = {
            k_fac_seabunny_created = "Created!",
            k_fac_seabunny_eroded = "Eroded!",
            k_fac_seabunny_mineral_fish = "Mineral Fish",
            k_fac_seabunny_polychrome = "Polychrome!",
            k_fac_seabunny_retrigger = "+1 Retrigger",
            k_fac_seabunny_uma = "UMA"
        },
        v_dictionary = {
            a_fac_seabunny_cm = "+#1# cm",
            a_fac_seabunny_percent = "#1#%",
            a_fac_seabunny_percent_plus = "+#1#%"
        }
    }
}