return {
    misc = {
        v_dictionary={
            a_discards="+#1# Discards",
        },
        dictionary = {
            k_fac_pi_cubed_mult = "Mult",
            k_fac_pi_cubed_bonus = "Bonus",
        },
    },
    descriptions = {
        PotatoPatch = {
            PotatoPatchDev_pi_cubed = {
                name = 'pi_cubed',
                text = { 
                    {
                        'i hope i get an {C:edition}iridium{}-quality',
                        'super cucumber this time!!',
                    }, {
                        'play {C:green,E:1}suikalatro{}',
                    }
                }
            },
        },
        fac_Fish = {
            fish_fac_pi_cubed_goldenegg = {
                name = "Golden Egg",
                text = {
                    {
                        "Earn {C:money}$#1#{} at",
                        "end of round",
                    },
                    {
                        "When {C:attention}Used{}, all cards",
                        "held in hand",
                        "become {C:attention}Gold{} cards",
                    },
                },
                flavor = {
                    "A powerful energy source.",
                    "Looks like the workers at Grizzco",
                    "forgot to pick this one up.",
                }
            },
            fish_fac_pi_cubed_salmonid = {
                name = "Salmonid",
                text = {
                    {
                        "If played hand has",
                        "{C:attention}#1#{} scoring cards, a random",
                        "unenhanced card becomes",
                        "a {C:attention}Mult{} or {C:attention}Bonus{} card",
                    },
                },
                flavor = {
                    "They're usually staring off into space,",
                    "so it's hard to tell what's",
                    "actually going on in their heads.",
                }
            },
            fish_fac_pi_cubed_squid = {
                name = "Squid?",
                text = {
                    {
                        "When {C:attention}Used{}, {C:attention}#1#{} random cards",
                        "held in hand become {V:1}#2#{}",
                        "{s:0.8}suit changes at end of round",
                    },
                },
                flavor = {
                    "A fine coating has prevented",
                    "this one from succumbing to",
                    "osmotic pressure whilst in water.",
                }
            },
            fish_fac_pi_cubed_spikedfish = {
                name = "Spiked Fish",
                text = {
                    {
                        "This Fish gains {C:white,X:mult}X#1#{} when",
                        "{C:money}Treasure{} is {C:attention}ready{} to be caught,",
                        "{C:red}resets{} when a {C:fac_fish}Fish{} is caught and",
                        "available {C:money}Treasure{} is {C:attention}not{} caught",
                        "{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive} Mult)",
                    },
                },
                flavor = {
                    "Moves linearly and predictably.",
                    "HATES mice.",
                }
            },
            fish_fac_pi_cubed_smallerwrappedfish = {
                name = "Smaller Wrapped Fish",
                text = {
                    {
                        "After scoring {C:attention}#1#{} {C:inactive}[#2#]{} cards",
                        "of rank {C:attention}2{}, {C:attention}Use{} this Fish",
                        "to create {C:attention}#3#{} random {C:fac_fish}Fish{}",
                        "{C:inactive}(Must have room){}",
                    },
                },
                flavor = {
                    "Descendent of Wrapped Fish,",
                    "specialised in its compactness.",
                }
            },
            fish_fac_pi_cubed_yellowtangwithahat = {
                name = {
                    "Yellow Tang",
                    "{s:0.6}(with a Hat)",
                },
                text = {
                    {
                        "Add a {C:attention}Seal{} to a random",
                        "scoring {C:diamonds}Diamond{} card",
                        "if scoring hand has",
                        "at least {C:attention}#1#{} {C:diamonds}Diamond{} cards",
                    },
                    {
                        "Retrigger all {C:diamonds}Diamond{}",
                        "cards with a {C:attention}Seal{}",
                    },
                },
                flavor = {
                    "A tropical fish, with some festive flair.",
                }
            },
            fish_fac_pi_cubed_mysteriouscanfish = {
                name = "Mysterious Canfish",
                text = {
                    {
                        "{C:green}#1# in #2#{} chance for",
                        "{C:fac_sand_dollars,s:0.9,f:fac_sand_dollars}$#3#{} at end of round",
                    },
                    {
                        "When {C:attention}Used{}, earn {C:fac_sand_dollars,s:0.9,f:fac_sand_dollars}$#4#{}",
                        "and {C:red}-$#5#",
                    },
                },
                flavor = {
                    "The can might qualify for",
                    "Containers for Change, but",
                    "prepare for a dispute with the fish.",
                }
            },
            fish_fac_pi_cubed_intergalacticdrunkfish = {
                name = "Intergalactic Drunkfish",
                text = {
                    {
                        "{C:red}+#1#{} Discard for {C:attention}this round{}",
                        "and each played card",
                        "gives {C:money}$#2#{} when scored if",
                        "poker hand is a {C:attention}#3#{}",
                        "{s:0.8}poker hand changes every {C:attention,s:0.8}hand{}",
                    },
                },
                flavor = {
                    "Supergiant Cider, Voidka, Piña Solada,",
                    "Stargarita, Big Bang Brandy, Absinthe...",
                    "this fish has downed it all!",
                }
            },
        },
    }
}
