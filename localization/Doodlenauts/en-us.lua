return {
    descriptions = {
        fac_Fish = {
            fish_fac_bottomfeeder = {
                name = "Bottom Feeder",
                text = {
                    'This Fish gains {C:mult}+#2#{} Mult',
                    'when a {C:attention}2{}, {C:attention}3{}, {C:attention}4{}, or {C:attention}5{} is scored',
                    "{C:inactive}Currently {C:mult}+#1#{} {C:inactive}chips"                 
                },
                flavour = {
                    'Quite frankly, I never knew',
                    'bottom was on the menu, but',
                    'this fish certainly did'
                }
            },
            fish_fac_bigbasswheel = {
                name = 'Big Bass Wheel',
                text = {
                    '{C:green}#1# in #2#{} chance to give',
                    '{C:blue}Foil{} or {C:dark_edition}Holographic{} edition',
                    'to a random Fish'
                },
                flavour = {
                    "He was once the CEO and entrepreneur",
                    "of a big arcade manufacturing gig.",
                    "However, he wasn't born in 1964"
                }
            },
            fish_fac_britishflag = {
                name = 'British Flag',
                text = {
                    '{C:chips}+#1#{} chips per Fish',
                    '{C:inactive}Currently {C:chips}+#2#{} {C:inactive}chips'
                },
                flavour = {
                    "An icon for the Bri'ish.",
                    "They pronounce words like",
                    'that because they drank',
                    'all the "T"'
                }
            },
            fish_fac_bullfrog = {
                name = 'Bullfrog',
                text = {
                    '{C:chips}+#1#{} chips per',
                    '{C:fac_sand_dollars,f:fac_sand_dollars}${C:fac_sand_dollars}1{} you have',
                    '{C:inactive}Currently {C:chips}+#2#{} {C:inactive}chips'
                },
                flavour = {
                    'Buck would not join this event',
                    'unless he could add a frog.',
                    'Here you go, Buck. You can leave now'
                }
            },
            fish_fac_catfish = {
                name = 'Lucky Catfish',
                text = {
                    'Sets all {C:attention}Lucky Card',
                    '{C:green}probability numerators{} to {C:green}3',
                },
                flavour = {
                    'The soul of a cat',
                    'put inside a fish body,',
                    'and they will seriously',
                    'act like a cat'
                }
            },
            fish_fac_eyelessfish = {
                name = 'Eyeless Fish',
                text = {
                    'Jokers {C:red}without{} the',
                    '{C:attention}letter "I"{} in their',
                    'names each give {X:mult,C:white}X#1#{} Mult'
                },
                flavour = {
                    "What do you call a fish",
                    "with no eyes? Not sure.",
                    "Hmm, there's gotta be a",
                    "good punchline there ..."
                }
            },
            fish_fac_moonjelly = {
                name = 'Moon Jelly',
                text = {
                    'Convert all cards',
                    'in hand to {V:1}#1#{}'
                },
                flavour = {
                    'One of the most beautiful',
                    'jellyfish in the whole world.',
                    "I'd know because I drew it.",
                    '-F404'
                }
            },
            fish_fac_loanshark = {
                name = 'Loan Shark',
                text = {
                    'Gives {C:money}$#1#{}, lose {C:red}$#2#',
                    'at end of round until',
                    '{C:red}debt{} has been payed',
                    '{C:inactive}Current debt: {C:red}$#3#{}'
                },
                flavour = {
                    "A fierce predator",
                    "in the Oceanic Abyss.",
                    "That's the name of",
                    "the bank he works at"
                }
            },
            fish_fac_neontetra = {
                name = 'Neon Tetra',
                text = {
                    'If played hand is a {C:attention}Four of a Kind{},',
                    'scoring cards have a {C:green}1 in 4 chance{}',
                    'to gain {C:dark_edition}Polychrome{} edition'
                },
                flavour = {
                    'This rather asymmetrical fish',
                    'can glow in the dark! It seems',
                    'to like the number 4 as well'
                }
            },
            fish_fac_wantedposter = {
                name = 'Wanted Poster',
                text = {
                    {
                        "When a Joker is sold,",
                        "gain {C:money}$#1#{} multiplied by",
                        "a value determined by",
                        "the Joker's {C:attention}rarity",
                        "and destroy this card"
                    },{
                        '{C:common}Common{} -> X#2#',
                        '{C:uncommon}Uncommon{} -> X#3#',
                        '{C:rare}Rare{} -> X#4#',
                        '{C:legendary}Legendary{} -> X#5#',
                    }
                },
                flavour = {
                    'While hard to read, it says,',
                    '"WANTED: Tom J. Foolery".'
                }
            },
            fish_fac_goldfishcrackers = {
                name = 'Goldfish Crackers',
                text = {
                    'Adds a {C:attention}Gold Seal{} to the',
                    'next {C:attention}#1#{} scoring cards',
                    'without a seal'
                },
                flavour = {
                    'These cheesy treats are among',
                    'the holy grail of snack foods',
                    'fishermen can only dream of obtaining'
                }
            },
            fish_fac_buckaroodlefish = {
                name = 'Buckaroodlefish',
                text = {
                    'This Fish gains {X:mult,C:white}X#1#{} Mult',
                    'per dollar spent {C:attention}rerolling',
                    "{C:inactive}Currently {X:mult,C:white}X#2#{} {C:inactive}Mult"
                },
                flavour = {
                    '"they turned me into',
                    'a fish what the hell"',
                    '- Buck'
                }
            },
            fish_fac_frogspawn = {
                name = 'Frogspawn',
                text = {
                    'Gains {C:fac_sand_dollars,f:fac_sand_dollars}${C:fac_sand_dollars}#3#{} of sell value',
                    'at end of round'
                },
                flavour = {
                    "Beautiful pearls of soon-to-be life.",
                    "Or at least what's left of it"
                }
            },
            fish_fac_fihnull = {
                name = 'FihNULL',
                text = {
                    'Randomize the {C:attention}rank{} and {C:attention}suit{}',
                    'of all cards held in hand,',
                    '{C:green}#1# in #2#{} chance for each',
                    'unenhanced card to gain',
                    'a random {C:attention}enhancement'
                },
                flavour = {
                    'Attempted to index fih,',
                    'a nil value string expected,',
                    'got fishing wire'
                }
            },
            fish_fac_leech = {
                name = 'Leech',
                text = {
                    'Lose {C:red}$#2#{} each hand,',
                    'destroys {C:attention}#1#{} random cards',
                    'in hand {C:attention}when sold{}'
                },
                flavour = {
                    'Filthy, annoying little bloodsuckers.'
                }
            },
            fish_fac_obsidianstarfish = {
                name = 'Obsidian Starfish',
                text = {
                    'Create #1# {C:dark_edition}Polychrome{} {C:attention}Stone cards',
                    'with {C:purple}Purple {C:attention}seals{}'
                },
                flavour = {
                    'These hardy stars are made',
                    'when an ordinary starfish',
                    'is engulfed in lava.'
                }
            },
            fish_fac_hermitcrab = {
                name = 'Hermit Crab',
                text = {
                    'Doubles {C:money}money{} and {C:fac_sand_dollars}sand dollars',
                    '{C:inactive}(Max of{} {C:money}$#1#{} {C:inactive}and{} {C:fac_sand_dollars,f:fac_sand_dollars}${C:fac_sand_dollars}#2#{C:inactive}){}'
                },
                flavour = {
                    'These well known crustaceans live in',
                    'discarded shells and will find new ones',
                    'if they outgrow their old ones.'
                }
            },
            fish_fac_spicytuna = {
                name = 'Spicy Tuna',
                text = {
                    'Earn {C:money}$#1#{} if played hand',
                    'scores {C:attention}higher{} than the {C:attention}Blind amount'
                },
                flavour = {
                    'These quick, red variants of tuna',
                    'are known to be a hot as Thai Chilies.'
                }
            },
            fish_fac_oldtire = {
                name = 'Old Tire',
                text = {
                    '{C:attention}#1#{} free {C:green}Rerolls{} per shop,',
                    'per ante'
                },
                flavour = {
                    'The lost rubber wheel of someones bike.',
                    'It, like the world, is still revolving.'
                }
            },
            fish_fac_liveammunition = {
                name = 'Live Ammunition',
                text = {
                    'On use, decrease',
                    '{C:attention}Blind{} requirement by {C:attention}#1#%{}',
                    '{C:inactive}(#2# uses left){}'
                },
                flavour = {
                    "Careful! This stuff is still live!",
                    "It's one of the few dangers that",
                    "come with magnet fishing.",
                }
            }
        },
    }
}