return {
    descriptions = {
        PotatoPatch = {
			PotatoPatchDev_ouiiskey = {
				name = "ouiiskey"
			},
			PotatoPatchDev_Lusha = {
				name = "Lusha"
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
                        "{C:attention}+1{} Classic Bait"
                    }
                },
                flavor = {
                    "This UMA is often caught on",
                    "camera swimming through the air,",
                    "but you are the first fisher",
                    "to catch one in person."
                }
            },
            fish_fac_ruby_snapper = {
                name = "Ruby Snapper",
                text = {
                    {
                        "Gains {C:attention}sell value{} of first",
                        "fish sold each round"
                    },
                    {
                        "{C:inactive}Enchanted: Double",
                        "{C:inactive}sell value when sold"
                    },
                    {
                        "To {C:dark_edition}Enchant{}: Sell #1# fishes",
                        "{C:inactive}({C:attention}#2#{C:inactive} remaining)"
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
            fish_fac_quartz_pip = {
                name = "Quartz Pip",
                text = {
                    {
                        "{C:green}#1# in #2#{} chance to retrigger",
                        "played unenhanced cards"
                    },
                    {
                        "{C:inactive}Enchanted: #3# in #4# chance",
                        "{C:inactive}for a separate retrigger"
                    },
                    {
                        "To {C:dark_edition}Enchant{}: Score",
                        "unenhanced cards #5# times",
                        "{C:inactive}({C:attention}#6#{C:inactive} remaining)"
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
                        "played unenhanced cards"
                    },
                    {
                        "{C:dark_edition}Enchanted{}: {C:green}#3# in #4# chance",
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
                        "add an unenhanced copy to",
                        "deck with permanent {C:chips}+#1#{} Chips"
                    },
                    {
                        "{C:inactive}Enchanted: Stone cards",
                        "{C:inactive}are destroyed when scored"
                    },
                    {
                        "To {C:dark_edition}Enchant{}: Score a card with",
                        "#2# or more chips #3# times",
                        "{C:inactive}({C:attention}#4#{C:inactive} remaining)"
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
                        "add an unenhanced copy to",
                        "deck with permanent {C:chips}+#1#{} Chips"
                    },
                    {
                        "{C:dark_edition}Enchanted{}: {C:attention}Stone{} cards",
                        "are destroyed when scored"
                    }
                },
                flavor = {
                    [[Here's another "quick-silver"]],
                    [[you don't want to eat!]]
                }
            }
        },
    },
    misc = {
        dictionary = {
            k_fac_mineral_fish = "Mineral Fish",
            k_fac_infested = "Infested!"
        },
        v_dictionary = {
            a_cm = "+#1# cm"
        }
    }
}