return {
    descriptions = {
		PotatoPatch = {
			PotatoPatchDev_eremel = {
				name = "Eremel",
                text = {
                    {
                        'Hey! I\'m a part of the organiser team here at the Potato Patch,',
                        'and I\'m really proud of the work everyone has done on this mod!',
                        'It\'s been a blast hosting this event and I hope you all enjoy it!',
                        '{ppu_bubble:active}'
                    },
                    {
                        'Some of the other mods I\'ve worked on are',
                        'SMODS, Galdur #1#, Malverk, Ortalab and Monarchy'
                    }
                }
			},
			PotatoPatchDev_radiation = {
				name = "RadiationV2",
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
        },
    },
    misc = {
        dictionary = {
            fac_r_e_random_suits = 'random suits'
        }
    }
}
