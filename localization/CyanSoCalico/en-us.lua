return {
    descriptions = {
        PotatoPatch = {
            PotatoPatchDev_CyanSoCalico = {
                name = "{C:green}Cyan{}",
                text = {
                    {
                        "{C:fac_csc_CSC,E:2}CyanSoCalico{}! Nervous catboy, digital artist,",
                        "and pixel artist! 21yo and happily {X:fac_csc_MLM1,C:white}t{X:fac_csc_MLM2}a{X:fac_csc_MLM3}k{X:fac_csc_MLM4}e{X:fac_csc_MLM5,C:white}n{} for 7y {C:fac_csc_CSC}:3{}",
                    },
                    {
                        "{C:fac_csc_CSC,E:2,u:fac_csc_CSC}My Time on Fish and Chips{}",
                        "Ooh boy, was this event rough for me, generally",
                        "being swamped for time and my art laptop going",
                        "out of commission for the whole event... {C:fac_csc_CSC}>>{} It's",
                        "definitely not my best showing, but I hope what",
                        "I squeaked out still brings you some enjoyment!"
                    },
                    {
                        "{C:fac_csc_CSC,E:2,u:fac_csc_CSC}My Upcoming Mod{}",
                        "What {C:fac_csc_CSC}is{} my best showing is my breakout mod I'm",
                        "developing as a fledgling solo Balatro mod dev!",
                        "Whether 11 hours or 11 years, look forward",
                        "to my one-man vanilla+ mod {C:fac_csc_CSC,E:1}Steady Hand{}!",
                        "I'm putting all of my love and effort into it {C:fac_csc_CSC}^w^{}"
                    },
                    {
                        "{C:fac_csc_CSC,E:2,u:fac_csc_CSC}Thanks for Playing!{}",
                        "I'm also a full-on superfan of everything I've",
                        "referenced in my Fish! Find me on {C:blue}Bluesky{} and",
                        "{C:enhanced}Discord{} and I'd love to bond over it all {C:fac_csc_CSC}>:3{}"
                    }
                }
            }
        },
        fac_Fish = {
            fish_fac_csc_fishmongus = {
                name = "Fishmongus",
                flavor = {
                    "Did you mean",
                    "\"fishmonger\"?"
                },
                text = {
                    "When {C:attention}Blind{} is selected,",
                    "add a {C:attention}#1#{} to a",
                    "random {C:attention}playing card{}",
                    "in {C:attention}full deck{}"
                }
            },
            fish_fac_csc_the_fish = {
                name = "The Fish",
                flavor = {
                    "Cards drawn face down",
                    "after each hand played"
                },
                text = {
                    {
                        "{C:attention}The Fish{} (Boss Blind)",
                        "cannot appear while",
                        "this Fish is owned"
                    },
                    {
                        "Use this Fish before a",
                        "{C:attention}Boss Blind{} to replace",
                        "it with {C:attention}The Fish{}",
                        "{C:inactive,s:0.8}Showdown Blinds excluded{}",
                        "{ppu_bubble:usable}"
                    }
                }
            },
            fish_fac_csc_wishiwashi = {
                name = "Wishiwashi",
                flavor = {
                    "This Pokémon is known for",
                    "being weak on its own but",
                    "forming menacing schools.",
                    "Don't underestimate the",
                    "power of exponentiation!"
                },
                text = {
                    "{C:white,X:mult}X#1#{} Mult for",
                    "each {C:fac_fish}Fish{} owned",
                    "{C:inactive}(Currently {C:white,X:mult}X#2#{C:inactive} Mult){}"
                },
            },
            fish_fac_csc_floundery = {
                name = "Floundery",
                flavor = {
                    "Nothing is stronger than...",
                    "a... Flounder's... dream...!"
                },
                --[[
                text = {
                    "{C:dark_edition}+#1#{} {C:fac_fish}Fish{} slot per",
                    "empty {C:attention}Joker{} slot",
                }
                    ]]
                text = {
                    "{C:chips}+#1#{} Chips per {C:fac_fish}Fish",
                    "outnumbering {C:attention}Jokers{}",
                    "{C:inactive}(Currently {C:chips}+#2#{C:inactive} Chips){}"
                }
            },
            fish_fac_csc_basculegion = {
                name = "Basculegion",
                flavor = {
                    "This Pokémon is cloaked",
                    "in the souls of its peers",
                    "that perished on their",
                    "hard journey upstream..."
                },
                text = {
                    "This Fish gains",
                    "{C:chips}+#1#{} Chips per",
                --    "each {C:attention}card{} or",
                    "{C:fac_fish}Fish{} {C:red}destroyed{}",
                --    "or {C:red}used up{}",
                    "{C:inactive}(Currently {C:chips}+#2#{C:inactive} Chips){}"
                }
            },
            fish_fac_csc_chi_yu = {
                name = "Chi-Yu",
                flavor = {
                    "This Pokémon took form",
                    "when treasured beads",
                    "bore repeated conflict",
                    "for their ownership and",
                    "transformed, charred in",
                    "an inferno of jealousy."
                },
                text = {
                    "{C:white,X:blind}X#1#{} Blind size"
                }
            },
            fish_fac_csc_luvdisc = {
                name = "Luvdisc",
                flavor = {
                    "This Pokémon is said to",
                    "bless couples that spot",
                    "it with eternal love.",
                },
                text = {
                    "If poker hand is a",
                    "{C:attention}#1#{} of {C:attention}face{} cards,",
                --    "create a copy of",
                --    "{C:tarot}#2#{}",
                    "create {C:tarot}#2#{}",
                    "{C:inactive}(Must have room){}"
                },
            },
            fish_fac_csc_suketoudara = {
                name = "Suketoudara",
                flavor = {
                    "It's pronounced",
                    "\"sket-o-darr-uh!\"",
                    "Cue the music!"
                },
                text = {
                    "Select {C:attention}#1#+{} cards",
                    "sharing a {C:attention}suit{}",
                    "Use this Fish to",
                    "{C:red}destroy{} them",
                    "{ppu_bubble:usable}",
                },
            },
            fish_fac_csc_sardinium = {
                name = "Sardinium",
                flavor = {
                    "If you had any weapons,",
                    "this could upgrade 'em!"
                },
                text = {
                    "Use this Fish to",
                    "upgrade selected",
                    "cards' {C:attention}poker hand{}",
                    "{ppu_bubble:usable}"
                }
            },
            fish_fac_csc_inkling_squid = {
                name = "Inkling Squid",
                flavor = {
                    "What is this even",
                    "doing in the water?"
                },
                text = {
                    --[[
                    "This Fish gains {C:chips}+#1#{} Chips",
                    "per consecutive hand",
                    "played that contains",
                    "no {C:attention}#2#{} or {C:attention}#3#{}",
                    "{C:inactive}(Currently {C:chips}+#4#{C:inactive} Chips){}"
                    ]]
                    "{C:mult}+#1#{} Mult if poker hand",
                    "does not contain a",
                    "{C:attention}#2#{} or {C:attention}#3#{}",
                }
            },
        },
    },
    misc = {
        dictionary = {
            k_fac_csc_add_seal = "+Seal"
        }
    }
}