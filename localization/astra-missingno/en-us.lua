return {
    descriptions = {
        fac_Fish = {
            fish_fac_am_jerry = {
                name = "Jerry",
                text = {
                    "Gives {C:chips}Chips{} equal",
                    "to {C:attention}x#1#{} the current",
                    "{C:attention}Music Volume{} setting",
                    "{C:inactive,s:0.8}Currently: {s:0.8,C:chips}+#2# {C:inactive,s:0.8}Chips"
                },
                flavor = {
                    "This music-loving jellyfish",
                    "is the lead bassist for",
                    "the Wave Breakers!"
                }
            },
            fish_fac_am_king = {
                name = "King of the Pond",
                text = {
                    "Each played and unscoring {C:attention}King{}",
                    "gives {X:red,C:white}X#1#{} Mult"
                },
                flavor = {
                    "There can only be one",
                    "true king",
                }
            },
            fish_fac_am_missingno = {
                name = "MissingNo.",
                text = {
                    "Next opened {C:attention}Booster Pack",
                    "will contain a random"
                },
                flavor = {
                    "{X:green,C:white}BIRD{} {X:inactive,C:white}NORMAL{}",
                    " ",
                    " ",
                }
            },
            fish_fac_am_shrimp = {
                name = "Shrimp Scamperer",
                text = {
                    "{C:mult}+#1#{} Mult, gains {C:mult}+#2#{} Mult if a",
                    " hand type is played {C:attention}#3#{C:inactive}[#4#]{} times",
                    "{C:inactive,s:0.8}Current hand: #5#"
                },
                flavor = {
                    "One! Two! Three!",
                    "Three! Two! One!",
                }
            },
            fish_fac_am_ascii = {
                name = "Ascii Fish",
                text = {
                    "{C:attention}Retriggers{} played cards",
                    "with non-number ranks",
                    "{C:attention}#1#{} time"
                },
                flavor = {
                    " _",
                    "><_>"
                }
            },
            fish_fac_am_teabag = {
                name = "Teabag",
                text = {
                    "Gives {C:attention}1",
                    "selected card ",
                    "permanent {C:money}$#1#{}",
                    "when scored"
                },
                flavor = {
                    "Finding one of these in",
                    "the harbour must mean",
                    "you're in Boston"
                }
            },
            fish_fac_am_starcatcher = {
                name = "Starcatcher",
                text = {
                    "Before scoring, {C:red}eats",
                    "all scoring {C:diamonds}Diamond{} cards",
                    "and gains {C:fac_sand_dollars,f:fac_sand_dollars}$#1#{} of sell value",
                    "for each eaten {C:diamonds}Diamond{}"
                },
                flavor = {
                    "Its tentacles dangle with",
                    "anticipation of a meal",
                    "floating by"
                }
            },
            fish_fac_am_chameleon = {
                name = "Chameleon",
                text = {
                    "Copies the",
                    "{C:attention}centermost{} Joker",
                    "{C:inactive,s:0.8}Must have odd number of Jokers"
                },
                flavor = {
                    "It attempts to blend into",
                    "anything and everything,",
                    "although usually quite poorly"
                }
            },
            fish_fac_am_mola = {
                name = "Mola Mola",
                text = {
                    {"Disables effect of",
                    "every {C:attention}Boss Blind",},
                    {"{C:green}#1# in #2#{} chance to {C:red,E:1}die{}",
                    "at the end of the {C:attention}shop{}"}
                },
                flavor = {
                    "While it's great at",
                    "deterring parasites,",
                    "it's quite terrible at",
                    "literally everything else"
                }
            },
            fish_fac_am_dopefish = {
                name = "Dopefish",
                text = {
                    "When blind is selected,",
                    "this Fish {C:red,E:1}eats{} all",
                    "{C:attention}adjacent{} Fish and gains",
                    "{X:red,C:white}X#2#{} for each Fish eaten",
                    "{C:inactive,s:0.8}Currently: {X:red,C:white,s:0.8}X#1#{C:inactive,s:0.8} Mult"
                },
                flavor = {
                    "The second dumbest",
                    "creature in the universe,",
                    "they'll eat anything alive",
                    "and moving near them"
                }
            },
            fish_fac_am_piscis = {
                name = "Piscis Austrinus",
                text = {
                    {"Use this Fish to upgrade",
                    "the level of the {C:attention}last played{}",
                    "poker hand #1# times"},
                    {"{S:0.8}({S:0.8,V:1}lvl.#2#{S:0.8}){} Level up",
                    "{C:attention}#3#",
                    "{C:mult}+#4#{} Mult and",
                    "{C:chips}+#5#{} chips",}
                },
                flavor = {
                    "It is said that gazing at the ",
                    "dazzling scales of this fish",
                    "gives you a glimpse into",
                    "another universe"
                }
            },
        }
    },
    misc = {
        dictionary = {
            k_fac_am_card = 'Card'
        }
    }
}