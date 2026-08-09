return {
    descriptions = {
        PotatoPatch = {
			PotatoPatchDev_Sophie = {
				name = "Sophie",
			},
			PotatoPatchDev_gfs = {
				name = "gfs",
			},
        },
        fac_Fish = {
            fish_fac_sophie_human_fish = {
                name = "Human Fish",
                text = {
                    "When a played {C:attention}face{} card is scored,",
                    "a random face card held in hand",
                    "permanently gains {C:chips}+#1#{} Chip",
                },
                flavor = {
                    "Wow, you fished me up?",
                    "You must be soooo proud of yourself."
                }
            },
            fish_fac_sophie_fishing_fear_hat = {
                name = "Fishing Cap",
                text = {
                    "{C:green}#1# in #2#{} chance to",
                    "create a {C:spectral}Spectral{} card",
                    "when catching a fish {C:attention}fails{}",
                    "{C:inactive}(Must have room)"
                },
                flavour = {
                    "The worst thing a fish",
                    "could ever see.",
                    "(Next to a seagull,",
                    "I guess.)",
                }
            },
            fish_fac_sophie_main_plug = {
                name = "Plug",
                text = {
                    "During the boss blind,",
                    "all cards are {C:attention}scored{} as",
                    "all suits",
                    "{C:inactive}(Must have room)"
                },
                flavour = {
                    "Ummmm...",
                    "Hope this wasn't important.",
                }
            },
            fish_fac_sophie_poisson_davril = {
                name = "Poisson d'avril",
                text = {
                    "{C:attention}Lucky Cards{} have their listed",
                    "{C:green,E:1,S:1.1}probabilties{} increased by {C:attention}#1#{},",
                    "decreases by {C:attention}#2#{} after {C:attention}Boss Blind",
                },
                flavour = {
                    "got you :)",
                }
            },
            fish_fac_sophie_fish_of_theseus = {
                name = "Fish of Theseus",
                text = {
                    "At end of round,",
                    "completely {C:attention}randomize",
                    "one card held in hand",
                },
                flavour = {
                    "Inspired by a ship",
                    "of a similar name,",
                    "this fish has been sewn",
                    "from bits of other fish."
                }
            },
            fish_fac_sophie_message_in_a_bottle = {
                name = "Message in a Bottle",
                text = {
                    "When {C:attention}leaving{} the fishing area,",
                    "create a {C:attention}random{} Consumable",
                    "{C:inactive}(Must have room)",
                },
                flavour = {
                    "If you are reading this, I am on an island,",
                    "lost at sea, looking for a way back to my home.",
                    "I miss my family dearly and I... don't know what to write really,",
                    "it's my first time on a deserted island."
                }
            },
            fish_fac_sophie_meridias_beacon = {
                name = "Meridia's Beacon",
                text = {
                    "All Jokers are considered",
                    "{C:attention}Quest Items{} {C:inactive}({C:purple}Eternal{C:inactive})",
                },
                flavour = {
                    "A NEW HAND TOUCHES THE BEACON.",
                }
            },
            fish_fac_sophie_hermit_crab = {
                name = "Hermit Crab",
                text = {
                    "Doubles {C:fac_sand_dollars}Sand Dollars",
                    "{C:inactive}(Max of {C:fac_sand_dollars,f:fac_sand_dollars}${C:fac_sand_dollars}#1#{}{C:inactive})",
                },
                flavour = {
                    "This crustacean stores",
                    "saltwater inside its shell.",
                    "(and sand dollars)",
                }
            },
            fish_fac_sophie_fish_jenga = {
                name = "Fish Jenga",
                text = {
                    "Other {C:attention}Fish{} scale at {C:attention}X#1#{}",
                    "the normal rate",
                },
                flavour = {
                    "IS THAT {C:attention}FUCKING{} FISH JENGA",
                }
            },
            fish_fac_sophie_the_fish = {
                name = "The Fish",
                text = {
                    "Cards played this {C:attention}ante",
                    "are drawn {C:attention}face down",
                    "and earn {C:money}$#1#{} when scored,",
                    "{C:attention}The Fish (Blind){} cannot appear"
                },
                flavour = {
                    "Fish? Like the blind?",
                }
            },
        },
    },
    misc = {
        dictionary = {
            fish_sophie_plus_consumable = "+1 Consumable"
        },
        v_dictionary = {
            k_fish_sophie_odds_m = "-#1# Odds",
        }
    }
}
