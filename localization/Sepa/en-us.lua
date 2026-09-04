return {
    descriptions = {
        Other = {
            fac_sepa_Tarot_infovar ={
                name = "Specific Tarots",
                text = {
                    "The Fool",
                    "The Emperor",
                    "The Hermit",
                    "The Hanged Man",
                    "Death",
                }
            },

            fac_sepa_Spectral_infovar ={
                name = "Specific Spectrals",
                text = {
                    "Talisman",
                    "Ectoplasm",
                    "Immolate",
                    "Deja Vu",
                    "Hex",
                    "Trance",
                    "Medium",
                    "Cryptid",
                    "Aura",
                }
            }

        },

        fac_Fish = {
            fish_fac_clownfish = {
                name = "Clownfish",
                text = {
                    "On {C:attention}first played hand{}",
                    "in round, {C:mult}+#1#{} Mult"
                },
                flavor = {
                    "Quite the famous fish",
                    "due to the documentary",
                    "of one his species lost son"
                }
            },

            fish_fac_freds_leg = {
                name = "{f:fac_sepa_spongemeboy}Fred's Leg{}",
                text = {
                    "When a hand is played,",
                    "{C:red}destroys{} the {C:attention}rightmost{}",
                    "card held in hand"
                },
                flavor = {
                    "{f:fac_sepa_spongemeboy}MY LEG!{}"
                }
            },

            fish_fac_blinky = {
                name = "Blinky",
                text = {
                    "{C:attention}Retriggers{} the",
                    "{C:attention}first hand{} played",
                    "Each played card has a",
                    "{C:green}#1# in #2#{} chance to be destroyed"
                },
                flavor = {
                    "Hi"
                }
            },
            fish_fac_friendfish = {
                name = "DEVICE_FRIEND",
                text = {
                    'Earn {C:money}$2{} for each',
                    'empty {C:fac_fish}Fish{} slot in the',
                    'bucket at the end of round',
                    '{C:inactive}(Currently {}{C:money}$#1#{}{C:inactive}){}'
                },
                flavor = {
                    "ALWAYS_AT_YOUR",
                    "HUMBLE_SERVICE"
                }
            },
            fish_fac_bunnyslug = {
                name = "Sea Bunny",
                text = {
                    "{C:mult}+#1#{} Mult for each",
                    "{C:C:fac_fish}Fish{} in your bucket",
                    "{C:inactive}(Currently {C:mult}+#2#{C:inactive} Mult){}"
                },
                flavor = {
                    "hi again"
                }
            },

            fish_fac_bombfish = {
                name = "{f:fac_sepa_ultra}Bomb Fish{}",
                text = {
                    {
                        "Creates {C:attention}#5#{} specific {C:tarot}Tarot{} cards when",
                        "defused. If {C:attention}attempt{} count hits 0,",
                        "sets money to {C:gold}$0{}. Play {C:attention}#4#{}",
                        "to advance the defuse count {C:green}[#1#/#2#]{}"
                    },
                    {
                        "{C:attention}Attempts{} go down for every round",
                        "that the disable count {C:attention}doesn't go up.{}",
                        "{C:green}Current attempts:{} #3#"
                    }
                },
                flavor = {
                    "{f:fac_sepa_ultra}Often found on flowing water.{}",
                    "{f:fac_sepa_ultra}Has a self defence mechanism{}",
                    "{f:fac_sepa_ultra}that causes bodly harm{}",
                    "{f:fac_sepa_ultra}to unaware fishers.{}"
                }
            },

            fish_fac_icbf = {
                name = "{f:fac_sepa_ultra}ICBFish{}",
                text = {{
                        "Creates {C:attention}#5#{} specific {C:spectral}Spectral{} cards when",
                        "defused. If {C:attention}attempt{} count hits 0,",
                        "sets money to {C:red}-$15{}. Play {C:attention}#4#{}",
                        "to advance the defuse count {C:green}[#1#/#2#]{}"
                    },
                    {
                        "{C:attention}Attempts{} go down for every hand",
                        "that the requested hand isnt",
                        "played, {C:attention}then hand resets{}",
                        "{C:green}Current attempts:{} #3#"
                    }},
                flavor = {
                    "{f:fac_sepa_ultra}Similar in nature to its{}",
                    "{f:fac_sepa_ultra}fish relative, only this time",
                    "{f:fac_sepa_ultra}it seems that this variant is",
                    "{f:fac_sepa_ultra}much more dangerous"
                }
            },

            fish_fac_lies= {
                name = "{f:fac_sepa_spongemeboy}Fish...?{}",
                text = {
                    "When {C:attention}Blind{} is selected, destroy {C:fac_fish}Fish{} to the", 
                    "left and adds its sell value as",
                    "dollars given at the end of round",
                    "{C:inactive}(Currently{} {C:gold}$#1#{}{C:inactive}){}"
                },
                flavor = {
                    "Its still unknown if this fish is ",
                    "real or not, but for your bucket, it is",
                }
            },

            fish_fac_devicehands = {
                name = "DEVICE_HANDS",
                text = {
                    "Gains {X:mult,C:white}X#2#{} Mult for",
                    "every {C:attention}hand{} played",
                    "{C:blue}-#3#{} Hand per round",
                    "{C:inactive}(Currently {}{X:mult,C:white}X#1#{}{C:inactive} Mult){}",
                },
                flavor = {
                    "Is this even a fish?",
                    "I mean, it looks like one"
                }
            },

            fish_fac_bagrehumo = {
                name = "Catfish...?",
                text = {
                    "{C:green}#1# in #2#{} chance",
                    "to upgrade most",
                    "played {C:attention}poker hand{}",
                    "after end of round"

                },
                flavor = {
                    "Im tecnically the Crawling Chaos...",
                    "Although, not sure to what porcentage..",
                    "Probably on the 20% or 30%",
                    "- Sketch"
                }
            },
            

 
        },

        PotatoPatch = {
            PotatoPatchDev_AbelSketch = { 
                name = "AbelSketch", 
                text = { 
                    "Even if I'm not a biological cat", 
                    "I {u:white}WILL{} enjoy the fish you sell",
                    "Voice: Left",
                }
            },
            PotatoPatchDev_DoggFly = { 
                name = "Dogg-Fly", 
                text = { 
                    "Fih & Chi",
                    "Click on us {u:white}multiple{} times --AbelS.",
                    "Voice: Right"
                } 
            },
        }

    },
    misc = {
        dictionary = {
            k_fac_sepa_minus_attempt = '-1 Attempt',
            k_fac_sepa_hallucination = 'Hallucination...?',
            k_fac_sepa_darkner = 'Darkner'
        }
    }
}
