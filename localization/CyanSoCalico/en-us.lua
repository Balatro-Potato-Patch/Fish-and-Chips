return {
    descriptions = {
        PotatoPatch = {
            PotatoPatchDev_CyanSoCalico = {
                name = "Cyan"
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
        PotatoPatch = {
            PotatoPatchDev_Cyan = {
                name = "Cyan",
                text = {
                    {
                        "CyanSoCalico, neurotic catboy! :3",
                        "I love digital art and pixel art!",
                        "I'm a fledgeling Balatro mod dev;",
                        "please look out for {C:CyanSoCalico}Steady Hand{}!"
                    },
                    {
                        "Oh boy, between being absolutely",
                        "inundated in other matters and",
                        "being out of my art laptop, my",
                        "circumstances here were ROUGH >>"
                    },
                    {
                        "I tried my best despite it all,",
                        "but this still is definiely not",
                        "my best showing ^^\" I hope you",
                        "can nonetheless find enjoyment",
                        "in what I was able to cook up!"
                    },
                    {
                        "You can bet on every reference",
                        "in my Fish being to something",
                        "I'm a superfan of! If you can",
                        "relate, then, while I'm not too",
                        "chatty, I'd love to make new",
                        "friends over our shared loves!",
                        "Find me on {C:blue}Bluesky & {C:enhanced}Discord{}!"
                    }
                }
            }
        }
    },
    misc = {
        dictionary = {
            k_fac_csc_add_seal = "+Seal"
        }
    }
}