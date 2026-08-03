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
            fish_fac_bombfish = {
                name = "{f:fac_ultra}Bomb Fish{}",
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
                    "{f:fac_ultra}Often found on flowing water.{}",
                    "{f:fac_ultra}Has a self defence mechanism{}",
                    "{f:fac_ultra}that causes bodly harm{}",
                    "{f:fac_ultra}to unaware fishers.{}"
                }
            },

            fish_fac_lies= {
                name = "Fish...?",
                text = {
                    "When {C:attention}Blind{} is selected, destroy Fish to the", 
                    "left and adds double its sell value as",
                    "dollars given at end of round",
                    "{C:inactive}(Currently{} {C:gold}$#1#{} {C:inactive}){}"
                },
                flavor = {
                    "Its still unknown if this",
                    "fish is real or not, but",
                    "for your bucket, it is"
                }
            },
            
            fish_fac_freds_leg = {
                name = "Fred's Leg",
                text = {
                    "When a hand is played,",
                    "{C:red}destroys{} the {C:attention}leftmost{}",
                    "card held in hand"
                },
                flavor = {
                    "OUCH",
                    "MY LEG!"
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