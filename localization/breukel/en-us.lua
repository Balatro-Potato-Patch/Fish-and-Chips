return {
    descriptions = {
        fac_Fish = {
            fish_fac_markerel = {
                name = "Markerel",
                text = {
                    {"Upon use:",
                    "{C:attention}Creates{} a random {C:attention}Tag",
                    "Applies {C:dark_edition}Eternal{} to",
                    "a random {C:attention}Joker{} in hand",
                    "{C:attention}Creates{} a second tag",
                    "if {C:fac_breukel_overtime,E:1}Overtime{} is more",
                    "than or equal to {C:attention}8"},
                    {"{C:attention}+#1#{} to {C:fac_breukel_overtime,E:1}Overtime{}",
                    "{C:inactive}(Overtime: #2#/#3#){}"}
                },
                flavor = {
                    "Its like a marker",
                    "from the office"
                }
            },

            fish_fac_ceo = {
                name = {"Chief Executive","Oarfisher"},
                text = {
                    {"{C:fac_breukel_overtime,E:1}Overtime{} can go up to {C:attention}20",
                    "Every {C:fac_fish}Fish{} gives an extra",
                    "{C:attention}+#1#{} to {C:fac_breukel_overtime,E:1}Overtime{} when triggered"},
                    {"{C:attention}+#2#{} to {C:fac_breukel_overtime,E:1}Overtime{}",
                    "{C:inactive}(Overtime: #3#/#4#){}"}
                },
                flavor = {
                    "Money money money",
                }
            },

            fish_fac_stockfish = {
                name = "Stockfish",
                text = {
                    {"Gives between {C:fac_sand_dollars}-{C:fac_sand_dollars,f:fac_sand_dollars}${C:fac_sand_dollars}#1#{} and {C:fac_sand_dollars}+{C:fac_sand_dollars,f:fac_sand_dollars}${C:fac_sand_dollars}#1#",
                    "at the {C:attention}end",
                    "{C:attention}of the round{}, higher chance",
                    "for {C:fac_sand_dollars}+{C:fac_sand_dollars,f:fac_sand_dollars}${} the higher",
                    "{C:fac_breukel_overtime,E:1}Overtime{} is"
                    },
                    {"{C:attention}+#2#{} to {C:fac_breukel_overtime,E:1}Overtime{}",
                    "{C:inactive}(Overtime: #3#/#4#){}"}
                },
                flavor = {
                    "Not associated",
                    "with chess!"
                }
            },

            fish_fac_employeel = {
                name = "Employeel",
                text = {
                    {"Gives {C:mult}Mult{} equal",
                    "to {C:fac_breukel_overtime,E:1}Overtime"},
                    {"{C:attention}+#1#{} to {C:fac_breukel_overtime,E:1}Overtime{}",
                    "{C:inactive}(Overtime: #2#/#3#){}"}
                },
                flavor = {
                    "9 to 5 sure is",
                    "boring, ey?"
                }
            },

            fish_fac_codcument = {
                name = "Codcument",
                text = {
                    {"{C:attention}Transforms{} into the",
                    "next catched {C:fac_fish}Fish",
                    "{C:attention}Create{} a copy if",
                    "{C:fac_breukel_overtime,E:1}Overtime{} is exactly",
                    "{C:attention}10"},
                    {"{C:attention}+#1#{} to {C:fac_breukel_overtime,E:1}Overtime{}",
                    "{C:inactive}(Overtime: #2#/#3#){}"}
                },
                flavor = {
                    "Containing information about",
                    "the next Potato Patch event!",
                    "{C:red,s:0.8,E:1}DO NOT TOUCH"
                }
            },
        },

    }
}