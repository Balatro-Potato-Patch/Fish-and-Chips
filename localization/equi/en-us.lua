return {
    descriptions = {
        fac_Fish = {
            fish_fac_mrchips = {
                name = "Mr. Chips",
                text = {
                    "Cards held in hand at end",
                    "of round permanently gain",
                    "{C:chips}Chips{} equal to their {C:attention}rank"
                },
                flavour = {
                    "A British national treasure that",
                    "wants you to say what you see."
                }
            },

            fish_fac_antarctickrill = {
                name = "Antarctic Krill",
                text = {
                    "Create a random {C:blue}Common{}",
                    "{C:attention}Joker{} if hand is played",
                    "with at least {C:fac_sand_dollars,f:fac_sand_dollars}$#1#{}"
                },
                flavour = {
                    "A Dangerous Pack of critters."
                }
            },

            fish_fac_webfishing = {
                name = "Webfishing",
                text = {
                    "{X:mult,C:white}X3{} Mult, forces {C:attention}1{} card",
                    "to always be selected",
                },
                flavour = {
                    "Ew! How did you even",
                    "fish that up??"
                }
            },

            fish_fac_fishedforitagain = {
                name = "Fished For It Again Award",
                text = {
                    "After {C:red}failing{} {C:attention}#2#{} catches,",
                    "create a random {C:attention}Targeted Bait{}",
                    "{C:inactive}(Currently #1#/#2#){}",
                    "{C:inactive}(Maximum #3# [#4#] times per round){}"
                },
                flavour = {
                    "Just another day in my stupid chum life"
                }
            },

            fish_fac_carpticalillusion = {
                name = "Carptical Illusion",
                text = {
                    "After using {C:attention}#1#{},",
                    "create a random {C:spectral}Spectral{}",
                    "card, then change the type",
                    "of {C:attention}Targeted Bait{} required",
                    "{C:inactive}(Must have room){}"
                },
                flavour = {
                    "Maybe a fish, or maybe not."
                }
            },

            fish_fac_mawray = {
                name = "Maw Ray",
                text = {
                    "This {C:fac_fish}Fish{} gives {X:mult,C:white}XMult{} based",
                    "on the {C:attention}length{} of the",
                    "longest {C:fac_fish}Fish{} you own",
                    "{C:inactive}(Does not include Maw Ray){}",
                    "{C:inactive}(Currently {X:mult,C:white}X#1#{C:inactive} Mult){}"
                },
                flavour = {
                    "When the moon hits your eye..."
                }
            },

            fish_fac_gofish = {
                name = "Go Fish",
                text = {
                    "When {C:attention}Blind{} is selected, asks",
                    "for a random {C:attention}rank{}",
                    "If your next hand has {C:attention}only{} that",
                    "{C:attention}rank{}, {C:red}destroy{} all played cards",
                    "and gain {X:mult,C:white}X#3#{} Mult for each",
                    "{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive} Mult){}"
                },
                flavour = {
                    "Got any #1#s?"
                }
            },

            fish_fac_mutekimaruchannel = {
                name = "Mutekimaru Channel",
                text = {
                    "card when scored",
                    "{C:inactive}(Must have room){}"
                },
                flavour = {
                    "{element:1}"
                }
            }
        },
        PotatoPatch = {
            PotatoPatchDev_Equi = {
                name = "Equi",
                text = {
                    {
                        "if i had a nickel for every sentient",
                        "triangle that got into balatro modding..."
                    },
                    {
                        "this is my first balatro modding event, if",
                        "you happen to like my content then check out",
                        "my other mod SuperAutoJokers :3",
                    }
                }
            }
        }
    },

    misc = {
        dictionary = {
            k_fac_equi_go_fish_response = "Go Fish!"
        },
        v_dictionary = {
            k_fac_equi_plus_bait = "+#1# Bait",
            k_fac_equi_go_fish_call = "Got any #1#s?"
        }
    }
}