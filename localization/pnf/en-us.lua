
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
            {"Resets after scoring"}
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
