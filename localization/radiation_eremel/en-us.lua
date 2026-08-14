return {
    descriptions = {
		PotatoPatch = {
			PotatoPatchDev_eremel = {
				name = "Eremel",
                text = {
                    {
                        'Hey! I\'m {C:3FC7EB}Eremel{}, one of the {C:attention}Organisers{}',
                        'here at the {C:attention}Potato Patch!',
                        'This mod has been a long time in the making, and I\'m',
                        'really excited for you all to play it!',
                        'This {C:attention}compendium{} here is my creation, and I helped work on',
                        'a lot of the other UI in the mod.',
                        '{C:3FC7EB,s:1.6}Let\'s go fishin\'!'
                    },
                    {
                        'If you want to check out some of the',
                        'other mods I\'ve worked on look at',
                        '{C:FF13F0}SMODS{}, {C:00D4FF,st:00D4FF}Galdur{element:1}{}, {C:E0B0FF}Malverk{}, {C:990000}Ortalab{} and {C:00919c}Monarchy'
                    }
                }
			},
			PotatoPatchDev_radiation = {
				name = "RadiationV2",
                text = {
                    {
                        "Yo! I'm {C:FF7C0A}RadiationV2{}, an {C:attention}artist{}, {C:attention}coder{} and",
                        "{C:attention}level designer{}, and this is my second",
                        "Potato Patch contribution. All of the assets",
                        "in our submission were {C:green}drawn by me{} and",
                        "{C:3FC7EB}coded by Eremel{}. Everything went swimmingly",
                        "and I had a fintastic time!",
                    },
                    {
                        "If you like my art, you should look out for",
                        "my challenge-based mod, {C:attention,E:1}House Rules{}.",
                        "I'll be releasing it in {C:blue}early September{},",
                        "after 8 months of solo dev time!",
                    }
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
            fish_fac_r_e_spookfish = {
                name = 'Abstract Spookfish',
                text = {
                    '{C:money}#1#{} to {C:fac_environment}Environment{}',
                    'reroll cost when {C:attention}perfectly{}',
                    'catching a {C:fac_fish}Fish'
                },
                flavour = {
                    "Piscesso's finest work"
                }
            },
            fish_fac_r_e_flowerhorn = {
                name = 'Infectious Flowerhorn',
                text = {
                    'When used, {C:red}destroy{} all {C:fac_fish}Fish{} that',
                    'weigh less than this Fish and',
                    '{C:attention}create copies{} of {C:fac_fish}Fish{} that weigh more',
                    '{ppu_bubble:usable}'
                },
                flavour = {
                    "Be careful or you'll",
                    "catch it's disease, too"
                }
            },
            fish_fac_r_e_tempura = {
                name = 'Tempura Shrimp',
                text = {
                    {
                        '{C:blue}+#1#{} Chips',
                        'This Fish gains chips equivalent to',
                        'it\'s {C:attention}length{} in mm'
                    },{
                        '{C:green}#2# in #3#{} chance this Fish',
                        'is destroyed at end of round',
                        'and force the next','{C:attention}#5#{} to be {C:dark_edition}#4#mm',
                    }

                },
                flavour = {
                    "You may see them as food, but",
                    "they're still a fish on the inside."
                }
            },
            fish_fac_r_e_clam = {
                name = 'Treasure Clam',
                text = {
                    'Add {C:attention}#2# temporary #1#s{}',
                    'to your first drawn hand',
                    'and then {C:attention}slam shut'
                },
                flavour = {
                    "Expanding the collection",
                    "with an Armless Joker soon!"
                }
            },
            fish_fac_r_e_clam_2 = {
                name = 'Treasure Clam',
                text = {
                    'Catch {C:attention}#3# {C:money}treasures',
                    'to open the chest',
                    '{C:inactive}(Currently #4#/#3#)'
                }
            },
            fish_fac_r_e_globe = {
                name = 'Globe Fish',
                text = {
                    'Store the {C:fac_fish}Fish{} to the',
                    '{C:attention}right{} within this fish',
                    'and gain {C:attention}scaling types',
                    'based on its {C:attention}attributes',
                    '{C:inactive,s:0.8}(Will gain:#1#)',
                    '{ppu_bubble:usable}'
                },
                flavour = {
                    'Choose your very own pet fish!'
                }
            },
            fish_fac_r_e_globe_2 = {
                name = 'Globe Fish',
                text = {
                    'Store the {C:fac_fish}Fish{} to the',
                    '{C:attention}right{} within this fish',
                    '{C:inactive}(Stored {C:attention}#1#{C:fac_fish} Fish{C:inactive})',
                    '{ppu_bubble:usable}'
                }
            },
        },
        Other = {
            fac_r_e_temp = {
                name = 'Temporary',
                text = {
                    'Removed at end of round'
                }
            },
            fac_r_e_mult = {
                name = 'Mult',
                text = {
                    'Gain {C:mult}+#1#{} Mult for each',
                    'stored {C:fac_fish}Fish',
                    '{C:inactive}(Currently {C:mult}+#2#{C:inactive} Mult)'
                }
            },
            fac_r_e_xmult = {
                name = 'XMult',
                text = {
                    'Gain {C:white,X:mult}X#1#{} Mult for each',
                    'stored {C:fac_fish}Fish',
                    '{C:inactive}(Currently {C:white,X:mult}X#2#{C:inactive} Mult)'
                }
            },
            fac_r_e_chips = {
                name = 'Chips',
                text = {
                    'Gain {C:chips}+#1#{} Chips for each',
                    'stored {C:fac_fish}Fish',
                    '{C:inactive}(Currently {C:chips}+#2#{C:inactive} Chips)'
                }
            },
            fac_r_e_economy = {
                name = 'Dollars',
                text = {
                    'Earn {C:money}#1#{} for each',
                    'stored {C:fac_fish}Fish',
                    '{C:inactive}(Currently {C:money}#2#{C:inactive})'
                }
            }
        }
    },
    misc = {
        dictionary = {
            fac_r_e_random_suits = 'random suits',
            fac_r_e_reduce = '-$1',
            fac_r_e_temporary_bubble = '  temporary  ',
            fac_r_e_stored = 'Stored!',
            fac_r_e_butterfly = 'Butterfly!',
        }
    }
}
