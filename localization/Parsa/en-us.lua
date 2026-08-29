return {
    descriptions = {
        fac_Fish = {
            fish_fac_Parsa_dish = {
                name = 'Dish',
                text = {
                    '{C:red}-$#1#{} per hand played',
                    'Retriggers the {C:attention}leftmost{}',
                    'played card{} #2# times',
                    'If you have less than {C:money}$#1#{},',
                    'gives {X:chips,C:white}X#3#{} {C:chips}Chips{} instead',
                    'Becomes {C:red}unsellable{} next hand',
                },
                flavor = {
                    "Feels leprose and slimy in hand",
                    "looks completely like a plate",
                    "you can't believe that",
                    "this 'fish' was swimming",
                    "few minutes ago"
                }
            },
            fish_fac_Parsa_dish_unsellable = {
                name = 'Dish',
                text = {
                    '{C:red}-$#1#{} per hand played',
                    'Retriggers the {C:attention}leftmost{}',
                    'played card {C:attention}#2#{} times',
                    'If you have less than {C:money}$#1#{},',
                    'gives {X:chips,C:white}X#3#{} {C:chips}Chips{} instead',
                    '{C:red}Unsellable{}',
                },
                flavor = {
                    "Feels leprose and slimy in hand",
                    "looks completely like a plate",
                    "you can't believe that",
                    "this 'fish' was swimming",
                    "few minutes ago"
                }
            },
            fish_fac_Parsa_facfile = {
                name = 'N/A.fac',
                text = {
                    "When {C:attention}Blind{} is selected,",
                    "{C:red}destroys{} a {C:green}random {C:attention}Joker{}",
                    "and creates a {C:green}random {C:attention}Tag"
                },
                flavor = {
                    "Wait...",
                    "where did you find that?",
                }
            },
        },
        PotatoPatch = {
            PotatoPatchDev_Parsa = {
                name = "Parsa",
                text = {
                    '{C:green}Hello there!{}',
                    '{C:blue}hope you enjoy this mod as much as we enjoyed developing it{}',
                    "{C:inactive}although I haven't added much{}",
                    "happy playing and",
                    "see u around"
                },
            },
        },
    },
    misc = {
        dictionary = {
            k_fac_plus_tag = "+Tag"
        }
    }
}