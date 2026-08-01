
return {
    descriptions = {
        fac_Fish = {
            fish_fac_blueax = {
                name = "Suspicious Blue Axolotl",
                text = {
                    {"This {V:1}Fish{} gains",
                    "{C:white,X:dark_edition}X#2#{} Scoring Value",
                    "{C:attention}when scoring",},
                    {"{C:attention}Use{} this {V:1}Fish{} to give a random",
                    "{C:attention}scoring effect{} equal to {C:dark_edition}#1#",
                    "in the {C:attention}next hand"},
                    {"Resets after scoring",
                    "or after each round"}
                },
                flavor = {
                    [["I'm sorry for existing"]]
                }
            },
            fish_fac_dupli = {
                name = "Barramun-Duplicare",
                text = {
                    "This {V:1}Fish{} gains",
                    "{C:mult}+#2#{} Mult when",
                    "a {C:attention}playing card{} is scored",
                    "and resets at the",
                    "{C:attention}end of every round",
                    "{C:inactive}(Currently: {C:mult}+#1#{C:inactive})"
                },
                flavor = {
                    [["I'm totally not who you think i am"]]
                }
            },
            fish_fac_pixelfish = {
                name = "Pixish",
                text = {
                    "This {V:1}Fish{} gains {C:chips}+#3#{} Chips when",
                    "a {C:attention}card{} is sold",
                    "Gains {X:chips,C:white}X#4#{} {C:chips}Chips{} for",
                    "every {C:attention}#6#{} {C:inactive}(#5#){} cards sold",
                    "{C:inactive}(Currently: {C:chips}+#1#{}, {X:chips,C:white}X#2#{C:inactive})"
                },
                flavor = {
                    [[Active explosion risk.]]
                }
            },
            fish_fac_ribbit = {
                name = "Circus Frog",
                text = {
                    {
                         "{C:attention}+#1#{} Card Selection Limit",
                         "{C:blue}+#1#{} Hand Size",
                         "{C:red}-#1#{} Discard",
                }
                },
                flavor = {
                    [["Hehe it's me, the character from]],
                    [[that one show"]]
                }
            },
            fish_fac_patrickstarwalker = {
                name = "Patrick Starwalker",
                text = {
                    {
                        "{C:attention}Stone cards{} are {C:red}destroyed{}",
                        "and this {V:1}Fish{} gains {C:white,X:chips}X#2#{} Chips",
                        "{C:inactive}(Currently: {X:chips,C:white}X#1#{C:inactive})"
                        
                }
                },
                flavor = {
                    [[These shorts piss me off]]
                }
            },
            fish_fac_flyinganchovy = {
                name = "Flying Anchovy",
                text = {
                    {
                        "Highest rank in a {C:attention}Straight",
                        "gives {C:mult}Mult{} equal to it's {C:attention}rank"
                        
                }
                },
                flavor = {
                    [[WAK!!]]
                }
            },
            fish_fac_froggychair = {
                name = "Froggy Chair",
                text = {
                    {"{C:dark_edition}+2{} Bucket slots",},
                    {"{C:mult}Destroys{} {C:attention}1 adjacent{} Fish at the",
                    "start of the round",
                    "{C:inactive}(Prioritises Fish to the right)",},
                },
                flavor = {
                    "When you seen this in the water, you",
                    "could've swore this looked like a leaf."
                }
            },
            fish_fac_fishery = {
                name = "Fishery",
                text = {
                    {"placeholder",},
                },
                flavor = {
                    "placeholder",
                }
            },
        },
        PotatoPatch = {
            PotatoPatchDev_FirstTry = {
                name = 'FirstTry',
                text = {
                    "{s:2,C:spectral}FirstTry",
                    "yo."
                }
            },
            PotatoPatchDev_Pixel = {
                name = 'Pixel',
                text = {
                    "{s:2,C:planet}pi xle LL e",
                    "I am the one who is computer,.,"
                },
            }
        }
    }
}
