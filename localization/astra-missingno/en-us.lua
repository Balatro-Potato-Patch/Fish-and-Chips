return {
    descriptions = {
        PotatoPatch = {
            PotatoPatchDev_theAstra = {
                name = "theAstra",
                text = {
                    { "Howdy! I'm {C:purple,E:2}Astra{}, head of the {C:attention}Potato Patch!",
                        "Thanks for playing the mod! This was easily our {C:red}most ambitious",
                        "event mod yet, and I had a blast making it happen! Shout out to",
                        "my fellow {C:attention}Organizers{} and the {C:planet}Guest Dev{} team for bringing this crazy",
                        "vision to life!",
                        "{C:dark_edition,s:1.4}To The Stars!!! {C:dark_edition,s:1.4,f:8}🪐" },
                    { "Also check out this Brooke Trout I caught irl",
                        "during the development of this mod",
                        "{element:1}" }
                }
            },
            PotatoPatchDev_MissingNo = {
                name = "MissingNo",
                text = {
                    "{C:inactive,s:0.8}#1#",
                    "Artist for {C:red}0 ERROR{} and {C:purple}Finity",
                    "unhinged internet idiot",
                    "Listen to {C:blue,u:blue}my music{} to die instantly"
                }
            },
        },
        fac_Fish = {
            fish_fac_am_jerry = {
                name = "Jerry",
                text = {
                    "Gives {C:chips}Chips{} equal",
                    "to {C:attention}X#1#{} the current",
                    "{C:attention}Music Volume{} setting",
                    "{C:inactive}(Currently {C:chips}+#2#{C:inactive} Chips)"
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
                    "This {C:fac_fish}Fish{} gains {X:mult,C:white}X#2#{} Mult",
                    "per played and scored {C:attention}King{}",
                    "{C:inactive}(Currently {X:mult,C:white}X#1#{C:inactive} Mult)"
                },
                flavor = {
                    "There can only be one true king"
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
                    "This {C:fac_fish}Fish{} gains {C:mult}+#2#{} Mult when",
                    "a hand type is played {C:attention}#3#{} {C:inactive}[#4#]{} times",
                    "{C:inactive}(Current hand: {C:attention}#5#{C:inactive})",
                    "{C:inactive}(Currently {C:mult}+#1#{C:inactive} Mult){}"
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
                    "{C:attention}#1#{} additional time"
                },
                flavor = {
                    " _",
                    "><_>"
                }
            },
            fish_fac_am_teabag = {
                name = "Teabag",
                text = {
                    "Gives {C:attention}1{} selected",
                    "card a permanent",
                    "{C:money}$#1#{} when scored",
                    "{ppu_bubble:usable}"
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
                    "anticipation of a meal floating by"
                }
            },
            fish_fac_am_chameleon = {
                name = "Chameleon",
                text = {
                    "Copies the",
                    "{C:attention}centermost{} Joker",
                    "{C:inactive,s:0.8}(Must have odd number of Jokers)"
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
                    {
                        "Disables effect of",
                        "every {C:attention}Boss Blind"
                    },
                    {
                        "{C:green}#1# in #2#{} chance for",
                        "this {C:fac_fish}Fish{} to {C:red,E:1}die{} at",
                        "the end of the {C:attention}shop{}"
                    }
                },
                flavor = {
                    "While it's great at deterring",
                    "parasites, it's quite terrible",
                    "at literally everything else"
                }
            },
            fish_fac_am_dopefish = {
                name = "Dopefish",
                text = {
                    "When {C:attention}Blind{} is selected, this",
                    "{C:fac_fish}Fish{} {C:red,E:1}eats{} all {C:attention}adjacent{}",
                    "{C:fac_fish}Fish{} and gains {X:mult,C:white}X#2#{} Mult",
                    "for each {C:fac_fish}Fish{} eaten",
                    "{C:inactive}(Currently {X:mult,C:white}X#1#{C:inactive} Mult)"
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
                    {
                        "Use this {C:fac_fish}Fish{} to upgrade",
                        "the level of the {C:attention}last played{}",
                        "poker hand {C:attention}#1#{} times",
                        "{ppu_bubble:usable}"
                    },
                    {
                        "{S:0.8}({S:0.8,V:1}lvl.#2#{S:0.8}){} Level up",
                        "{C:attention}#3#",
                        "{C:mult}+#4#{} Mult and",
                        "{C:chips}+#5#{} chips",
                    }
                },
                flavor = {
                    "It is said that gazing at the",
                    "dazzling scales of this fish",
                    "gives you a glimpse into",
                    "another universe"
                }
            },
            fish_fac_am_blubby = {
                name = "Blubby",
                text = {
                    "{C:attention}1{} free {C:green}Reroll{} for",
                    "every {C:attention}#1#%{} of score",
                    "overshot each round",
                    "{C:inactive}(Currently {C:green}#2#{C:inactive} Rerolls)",
                    "{C:inactive,s:0.8}(Max #3# Rerolls)",
                },
                flavor = {
                    "It seems like this Fish came",
                    "from a factory somewhere...",
                    "Who knows what wonders",
                    "are made there"
                }
            },
            fish_fac_am_chocolat = {
                name = { "Le Fishe", "au chocolat" },
                text = {
                    "Applies a {C:green}random{} {C:dark_edition}edition",
                    "to the next {C:attention}#1# {C:fac_fish}Fish{}",
                    "caught {C:attention}perfectly{}"
                },
                flavor = {
                    "Typical French Cuisine",
                }
            },
        }
    },
    misc = {
        dictionary = {
            k_fac_am_card = 'Card',
            k_fac_am_rerolls = 'Rerolls'
        },
        v_dictionary = {
            a_fac_am_rerolls = '#1# Rerolls',
            a_fac_am_blank_left = '#1# Left',
        }
    }
}
