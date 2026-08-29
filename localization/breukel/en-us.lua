return {
    descriptions = {
        fac_Fish = {
            fish_fac_businesscarp = {
                name = "Business Carp",
                text = {
                    {
                        "When {C:attention}Blind{} is selected,",
                        "{C:green}#1# in #2#{} chance to earn",
                        "{C:fac_sand_dollars,f:fac_sand_dollars}+$#3#{} per owned {C:fac_fish}Fish{}",
                        "{E:1,C:green}Chances{} increase with {C:fac_breukel_overtime,E:1}Overtime{}"
                    },
                    {
                        "{C:attention}+#4#{} {C:fac_breukel_overtime,E:1}Overtime{} when triggered",
                        "{C:inactive}(Overtime: #5#/#6#){}"
                    }
                },
                flavor = {
                    "oh my god. it even",
                    "has a watermark."
                }
            },

            fish_fac_enveloach = {
                name = "Enveloach",
                text = {
                    {
                        "At {C:attention}end of round{}, earn",
                        "{C:money}${} equal to current",
                        "{C:fac_breukel_overtime,E:1}Overtime{} rounded down",
                    },
                    {
                        "{C:attention}+#1#{} {C:fac_breukel_overtime,E:1}Overtime{}",
                        "when triggered",
                        "{C:inactive}(Overtime: #2#/#3#){}"
                    }
                },
                flavor = {
                    "paid bidaily"
                }
            },

            fish_fac_markerel = {
                name = "Markerel",
                text = {
                    {
                        "{C:attention}Creates{} a random {C:attention}Tag{} and applies",
                        "{C:dark_edition}Eternal{} to a random owned {C:attention}Joker{}",
                        "{C:attention}Creates{} a second {C:attention}Tag{} if {C:fac_breukel_overtime,E:1}Overtime{}",
                        "is greater than or equal to {C:attention}8",
                        "{ppu_bubble:usable}"
                    },
                    {
                        "{C:attention}+#1#{} {C:fac_breukel_overtime,E:1}Overtime{} when used",
                        "{C:inactive}(Overtime: #2#/#3#){}"
                    }
                },
                flavor = {
                    "It's like a marker",
                    "from the office"
                }
            },

            fish_fac_ceo = {
                name = { "Chief Executive", "Oarfisher" },
                text = {
                    {
                        "{C:fac_breukel_overtime,E:1}Overtime{} can go up to {C:attention}20",
                        "Other {C:fac_fish}Fish{} give an extra",
                        "{C:attention}+#1#{} {C:fac_breukel_overtime,E:1}Overtime{} when triggered"
                    },
                    {
                        "{C:attention}+#2#{} {C:fac_breukel_overtime,E:1}Overtime{} after",
                        "each hand played",
                        "{C:inactive}(Overtime: #3#/#4#){}"
                    }
                },
                flavor = {
                    "Money money money",
                }
            },

            fish_fac_stockfish = {
                name = "Stockfish",
                text = {
                    {
                        "At end of round, earn",
                        "between {C:fac_sand_dollars,f:fac_sand_dollars}-$#1#{} and {C:fac_sand_dollars,f:fac_sand_dollars}+$#1#",
                        "{C:green}#2# in #3#{} chance reward is {C:attention}positive{},",
                        "{E:1,C:green}chance{} increases with {C:fac_breukel_overtime,E:1}Overtime{}"
                    },
                    {
                        "{C:attention}+#4#{} {C:fac_breukel_overtime,E:1}Overtime{} when triggered",
                        "{C:inactive}(Overtime: #5#/#6#){}"
                    }
                },
                flavor = {
                    "Not associated with chess!"
                }
            },

            fish_fac_employeel = {
                name = "Employeel",
                text = {
                    {
                        "Gives {C:mult}+Mult{} equal",
                        "to {C:fac_breukel_overtime,E:1}Overtime"
                    },
                    {
                        "{C:attention}+#1#{} {C:fac_breukel_overtime,E:1}Overtime{}",
                        "when triggered",
                        "{C:inactive}(Overtime: #2#/#3#){}"
                    }
                },
                flavor = {
                    "9 to 5 sure is",
                    "boring, ey?"
                }
            },

            fish_fac_plecoworker = {
                name = "Plecoworker",
                text = {
                    {
                        "Gives {C:chips}Chips{} equal",
                        "to {C:white,X:attention}#1#X{} {C:fac_breukel_overtime,E:1}Overtime"
                    },
                    {
                        "{C:attention}+#2#{} {C:fac_breukel_overtime,E:1}Overtime{}",
                        "when triggered",
                        "{C:inactive}(Overtime: #3#/#4#){}"
                    }
                },
                flavor = {
                    "Listening to coworker",
                    "music RIGHT NOW!"
                }
            },

            fish_fac_codcument = {
                name = "Codcument",
                text = {
                    {
                        "{C:attention}Transforms{} into the",
                        "next caught {C:fac_fish}Fish",
                        "{C:attention}Duplicate{} it if",
                        "{C:fac_breukel_overtime,E:1}Overtime{} is exactly {C:attention}#1#",
                        "{C:inactive}(Must have room){}"
                    },
                    {
                        "{C:attention}+#2#{} {C:fac_breukel_overtime,E:1}Overtime{}",
                        "when triggered",
                        "{C:inactive}(Overtime: #3#/#4#){}"
                    }
                },
                flavor = {
                    "Containing information about",
                    "the next Potato Patch event!",
                    "{C:red,s:0.8,E:1}DO NOT TOUCH"
                }
            },

            fish_fac_pirinter = {
                name = "Pirinter",
                text = {
                    {
                        "If {C:attention}first {C:red}discard{} of round has",
                        "only {C:attention}1{} card, {C:red}destroy{} that card and",
                        "create a {C:attention}copy{} of it, with a",
                        "{C:green}chance{} to gain a random",
                        "{C:attention}Enhancement{}, {C:dark_edition}Edition{} or {C:attention}Seal{}",
                        "{E:1,C:green}Chances{} increase with {C:fac_breukel_overtime,E:1}Overtime{}"
                    },
                    {
                        "{C:attention}+#1#{} {C:fac_breukel_overtime,E:1}Overtime{} when triggered",
                        "{C:inactive}(Overtime: #2#/#3#){}"
                    }
                },
                flavor = {
                    "Comykel is calling",
                }
            },

            fish_fac_produck = {
                name = "Produck",
                text = {
                    {
                        "Played and scored cards",
                        "give {C:attention}+#1#{} {C:fac_breukel_overtime,E:1}Overtime{}",
                        "Apply {C:attention}Gold{} to all played cards",
                        "if {C:fac_breukel_overtime,E:1}Overtime{} is more than {C:attention}#2#{}"
                    },
                    {
                        "{C:attention}+#3#{} {C:fac_breukel_overtime,E:1}Overtime{} after",
                        "each hand played",
                        "{C:inactive}(Overtime: #4#/#5#){}"
                    }
                },
                flavor = {
                    "Breuhh is calling",
                }
            },
        },
        Other = {
            fac_breukel_overtime = {
                name = "Overtime",
                text = {
                    "Used by and increased",
                    "by some {C:fac_fish}Fish{}",
                    "If it exceeds the",
                    "maximum {C:inactive}[#1#]{}, it wraps",
                    "around to {C:attention}0{} again",
                    "{C:inactive,s:0.8}(ex: 9/10 OT + 2 OT = 1/10 OT){}"
                }
            }
        }
    }
}
