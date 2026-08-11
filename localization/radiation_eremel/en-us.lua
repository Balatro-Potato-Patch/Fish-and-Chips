return {
    descriptions = {
		PotatoPatch = {
			PotatoPatchDev_eremel = {
				name = "Eremel",
                text = {
                    {
                        'Hey! I\'m {C:3FC7EB}Eremel{}, one of the {C:attention}Organisers{} here at the {C:attention}Potato Patch!',
                        'This mod has been a long time in the making, and I\'m',
                        'really excited for you all to play it!',
                        'This {C:attention}compendium{} here is my creation, and I helped work on',
                        'a lot of the other UI in the mod.',
                        '{C:3FC7EB,s:1.6}Let\'s go fishin\'!'
                    },
                    {
                        'If you want to check out some of the',
                        'other mods I\'ve worked on look at',
                        '{C:FF13F0}SMODS{}, {C:00D4FF}Galdur #1#{}, {C:E0B0FF}Malverk{}, {C:990000}Ortalab{} and {C:00919c}Monarchy'
                    }
                }
			},
			PotatoPatchDev_radiation = {
				name = "RadiationV2",
                text = {
                    'placeholder'
                }
			},
        },
        fac_Fish = {
            fish_fac_r_e_butterfly_fish = {
                name = 'Butterfly Fish',
                text = {
                    'Scoring cards have a `{C:green}#1# in #2#{} chance',
                    'to be converted into the {C:attention}suit',
                    'of the last played {C:attention}#3#',
                    '{C:inactive,s:0.9}(Currently {C:1,s:0.9}#4#{C:inactive,s:0.9})'
                },
                flavour = {
                    'A true miracle of {E:1,C:fac_suits}adaptability'
                }
            },
            fish_fac_r_e_ominous_whale = {
                name = 'Ominous Whale',
                text = {
                    '{C:mult}+#2#{} Mult for each {C:spades}#1#{} card',
                    'in your discard pile this round',
                    '{C:inactive}(Currently {C:mult}+#3#{C:inactive} Mult)'
                },
                flavour = {
                    'Grows larger with each soul it consumes.',
                    'Thrives near sacrificial sites.'
                }
            },
            fish_fac_r_e_orca_cola = {
                name = 'Orca Cola',
                text = {
                    'Sell this fish to make your',
                    '{C:attention}next bite{} the same as',
                    'your last {C:attention}successful{} catch',
                    '{C:inactive,s:0.9}(Currently #1#)'
                },
                flavour = {
                    'Saltwater drink made',
                    'by fish, from fish, for fish.',
                    '"Taste the fishness!"'
                }
            },
            fish_fac_r_e_sushi_crab = {
                name = 'Sushi Crab',
                text = {
                    {
                        'Use this fish to toggle it\'s state',
                        '{ppu_bubble:toggle}{ppu_bubble:1}'
                    },
                    {
                        'When {C:green}active{}, gives {C:white,X:red}X#3#{} Mult',
                        'and loses {C:white,X:red}X#2#{} for every hand played'
                    },{
                        'When {C:red}inactive{}, gains {C:white,X:red}X#1#{} Mult',
                        'when {C:attention}Blind{} is selected'
                    },
                },
                flavour = {
                    "This giant enemy crab offers you",
                    "it's stack of tasty looking sushi.",
                    "What do you do?"
                }
            },
        },
    },
    misc = {
        dictionary = {
            fac_r_e_random_suits = 'random suits'
        }
    }
}
