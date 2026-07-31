return {
    descriptions = {
        PotatoPatch = {
            PotatoPatchDev_crimsonseraphim = {
                name = "crimsonseraphim",
                text = {
                    "Inside me there are two wolves",
                    "and one of them is {C:red}Red{}, and one of them is {C:green}Green{}",
                    "say hello to them both."
                }
            },
        },
        fac_Fish = {
            fish_fac_aeonfish = {
                name = "Aeonfish",
                text = {
                    "Once per round you may",
                    "use this {C:attention}Fish{} to {C:fac_spectral_gradient}Transmute{}",
                    "the rightmost {C:attention}Fish{}."
                },
                flavor = {
                    "You may hear it whisper",
                    "secrets if you get too close."
                }
            },
            fish_fac_hammerhead_shark = {
                name = "Hammerhead Shark",
                text = {
                    "When a {C:attention}Fish{} is caught",
                    "{C:red}Forge{} a {C:blue}Common{} Joker",
                    "with a random added effect."
                },
                flavor = {
                    "Usually found near anvils",
                    "and circuses. for some reason..."
                }
            },

            fish_fac_mealy_apple = {
                name = "Mealy Apple",
                text = {
                    "When a {C:attention}Fish{} is caught",
                    "Destroy it and this {C:attention}Fish{}",
                    "and give 3X their combined",
                    "sell values"
                },
                flavour = {
                    "{element:1}"
                }
            },

            fish_fac_ruby_crystalfish = {
                name = "Crystalfish (Al{s:0.5}2{}O{s:0.5}3{}:Cr)",
                text = {
                    {
                        "All other {C:attention}Fish{} have",
                        "random Suits and ranks"
                    },
                    {
                        "All other {C:attention}Fish{} contribute",
                        "to poker hand calculation"
                    }
                }
            },
            fish_fac_jade_crystalfish = {
                name = "Crystalfish (Ca{s:0.5}2{}[Mg,Fe]{s:0.5}5{}Si{s:0.5}8{}O{s:0.5}22{}[OH]{s:0.5}2{})",
                text = {
                    {
                        ""
                    },
                    {
                        ""
                    }
                }
            }
        },
        Other = {
            fac_crimsonseraphim_transmute = {
                name = "Transmute",
                text = {
                    "This Fish becomes another",
                    "Fish with similar effects."
                }
            },

            fac_crimsonseraphim_forged_mult = {
                name = {"Hammerhead Shark", "Generate me a {C:blue}Common{} Joker", "that gives {C:red}+Mult{}"},
                text = {
                    "{C:red}+4{} Mult"
                }
            },
            fac_crimsonseraphim_forged_chips = {
                name = {"Hammerhead Shark", "Generate me a {C:blue}Common{} Joker", "that gives {C:blue}+Chips{}"},
                text = {
                    "{C:blue}+15{} Chips"
                }
            },
            fac_crimsonseraphim_forged_money = {
                name = {"Hammerhead Shark", "Generate me a {C:blue}Common{} Joker", "that gives {C:money}${}"},
                text = {
                    "Earn {C:money}$3{}",
                    "When a blind is selected"
                }
            },
            fac_crimsonseraphim_forged_sand = {
                name = {"Hammerhead Shark", "Generate me a {C:blue}Common{} Joker", "that gives me roi"},
                text = {
                    "When a Fish is caught",
                    "earn {C:fac_sand_dollars,f:fac_sand_dollars}${C:fac_sand_dollars}1{}"
                }
            }
        }
    }
}