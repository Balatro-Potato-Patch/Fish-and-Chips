return {
    descriptions = {
        PotatoPatch = {
            PotatoPatchDev_Blanthos = {
                name = "Blanthos",
            },
            PotatoPatchDev_Hunter = {
                name = "Hunter",
            },
        },
        fac_Fish = {
            fish_fac_gneep_gnarp = {
                name = "Gneep Gnarp",
                text = {
                    {
                        "Gives temporary {C:planet}hand levels{}",
                        "to {C:attention}#6#{} based",
                        "on current {C:fac_happy_gradient}Happiness{}",
                        "{C:inactive}(Currently {C:fac_happy_gradient}#1# Happiness{C:inactive} / {C:planet}#5#{C:inactive} levels){}",
                    },
                    {
                        "{C:fac_happy_gradient}-#2# Happiness{} from {C:fac_bored_gradient}Boredom{}",
                        "at end of round, {C:attention}feed{}",
                        "{C:money}$#3#{} to gain {C:fac_happy_gradient}+#4# Happiness{}",
                        "{ppu_bubble:usable}"
                    }
                },
                flavor = {
                    "Bingle bongle, dingle dangle,",
                    "yickety-doo, yickety-da,",
                    "ping-pong, lippy-tappy too-ta."
                }
            },
            fish_fac_spectre_fish = {
                name = "Spectre Fish",
                text = {
                    "The first time this {C:fac_fish}Fish{}",
                    "would be {C:red}destroyed{} each round,",
                    "it gains {C:mult}+#2#{} Mult instead",
                    "{C:inactive}(Currently {C:mult}+#1#{C:inactive} Mult){}",
                    "{ppu_bubble:1}"
                },
                flavor = {
                    "It's a little bit... {C:attention}OFF{}-putting."
                }
            },
            fish_fac_gaster_hat = {
                name = "{C:dark_edition}Green Pirate Hat{}",
                text = {
                    "Whenever ye sell a {C:attention}Joker{},",
                    "ye 'ave a {C:green}#1# in #2#{} chance to",
                    "plunder between {C:fac_sand_dollars,f:fac_sand_dollars}$#3#{} an' {C:fac_sand_dollars,f:fac_sand_dollars}$#4#{}"
                },
                flavor = {
                    "{C:green}CHIPS AHOY, LANDMAGGOTS{}"
                }
            },
            fish_fac_shadowfish = {
                name = "Shadowfish",
                text = {
                    "Has {C:attention}3{} random {C:attention}Attributes{}",
                    "and corresponding {C:attention}effects{}"
                },
                flavor = {
                    "We {C:fac_bored_gradient}sadly{} did not implement Pluey"
                }
            }
        },
        Other = {
            fac_blanthos_shadowfish_mult = {
                name = "Mult",
                text = {
                    "{C:mult}+#1#{} Mult"
                }
            },

            fac_blanthos_shadowfish_chips = {
                name = "Chips",
                text = {
                    "{C:chips}+#1#{} Chips"
                }
            },

            fac_blanthos_shadowfish_xmult = {
                name = "XMult",
                text = {
                    "{X:mult,C:white}X#1#{} Mult"
                }
            },

            fac_blanthos_shadowfish_economy = {
                name = "Economy",
                text = {
                    "Earn {C:money}$#1#{} when",
                    "you sell a card"
                }
            },

            fac_blanthos_shadowfish_retrigger = {
                name = "Retrigger",
                text = {
                    "Retrigger scored",
                    "card in position {C:attention}#2#{}",
                    "{C:attention}#1#{} additional time"
                }
            },

            fac_blanthos_shadowfish_hand_level = {
                name = "Hand Level",
                text = {
                    "Level up {C:attention}#1#{}",
                    "at end of round"
                }
            },

            fac_blanthos_shadowfish_usable = {
                name = "Usable",
                text = {
                    "Use to {C:green}reroll{} this",
                    "{C:fac_fish}Fish's{} {C:attention}Attributes{}",
                    "{ppu_bubble:usable}"
                }
            },

            fac_blanthos_shadowfish_generation = {
                name = "Generation",
                text = {
                    "Create a random",
                    "{C:attention}consumable{} when",
                    "skipping any {C:attention}Blind{}"
                }
            }
        }
    },
    misc = {
        dictionary = {
            k_fac_blanthos_feed = "FEED",
            blanth_yum = "Yummy!",
            blanth_bored = "Bored..."
        },
    }
}
