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
                    "{C:red}destroys{} the {C:attention}leftmost{}",
                    "card held in hand"
                },
                flavor = {
                    "{f:fac_sepa_spongemeboy}MY LEG!{}"
                }
            },

            fish_fac_bombfish = {
                name = "{f:fac_sepa_ultra}Bomb Fish{}",
                text = {
                    {
                        "Creates {C:attention}#5#{} specific {C:tarot}tarot{} cards when",
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
                name = "{f:fac_sepa_ultra}ICBFish",
                text = "Does nothing",
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
                    "left and adds double its sell value as",
                    "dollars given at end of round",
                    "{C:inactive}(Currently{} {C:gold}$#1#{}{C:inactive}){}"
                },
                flavor = {
                    "Its still unknown if this",
                    "fish is real or not, but",
                    "for your bucket, it is"
                }
            },
            

 
        },

        PotatoPatch = {
            PotatoPatchDev_AbelSketch = { 
                name = "AbelSketch", 
                text = { 
                    "Even if I'm not a biological cat", 
                    "I {u:white}WILL{} enjoy the fish you sell",
                }
            },
            PotatoPatchDev_DoggFly = { 
                name = "Dogg-Fly", 
                text = { 
                    "Fih & Chi" 
                } 
            },
        }

    },
}