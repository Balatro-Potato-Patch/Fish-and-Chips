return {
    descriptions = {
        fac_Fish = {
            fish_fac_blamperer_kala = {
                name = "kala",
                text = {
                    "{X:mult,C:white}X#1#{} for each {C:fac_fish}Fish{} with",
                    "a {C:attention}one-word name",
                    "{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive} Mult)"
                },
                flavor = {
                    "tenpo la, lili li pona"
                }
            },
            fish_fac_blamperer_perfish = {
                name = "Perfish",
                text = {
                    "Earn {C:money}$#1#{} when returning",
                    "from fishing based on your",
                    "best streak of {C:gold}Perfect Catches",
                    "{C:inactive}(Resets on payout)",
                    "{C:inactive}(Highest streak: {C:gold}#2#{C:inactive} in a row)"
                },
                flavor = {
                    "This Fish only rewards those who can",
                    "perform with neither err or hesitation.",
                    "Go for a Perfish!"
                }
            },
            fish_fac_blamperer_timer = {
                name = "Delayed Gratipiscation",
                text = {
                    "Earn {C:fac_sand_dollars,f:fac_sand_dollars}${C:fac_sand_dollars}#1#{} for every {C:attention}5 seconds",
                    "you have a {C:fac_fish}Fish{} on your hook",
                    "{C:inactive}(Maximum of {C:fac_sand_dollars,f:fac_sand_dollars}${C:fac_sand_dollars}#3#{C:inactive})"
                },
                flavor = {
                    "Why speed through the moment?",
                    "Sit back and savor the time you spend."
                }
            },
            fish_fac_blamperer_shfi = {
                name = "shFi",
                text = {
                    "Swap {C:chips}Chips{} and {C:mult}Mult",
                    "{C:attention}before{} any scoring"
                },
                flavor = {
                    "It seems relatively happy,",
                    "which is a wonder when",
                    "it's bisected like that."
                }
            },
            fish_fac_blamperer_voucher = {
                name = "Washed-out Voucher",
                text = {
                    "Use this {C:fac_fish}Fish{} to add a",
                    "{C:attention}Voucher{} to the shop",
                    "{C:inactive}(Defeat {C:attention}Boss Blind {C:inactive}to restock)",
                    "{ppu_bubble:usable}"
                },
                flavor = {
                    "Maybe you can still exchange it",
                    "for one of equal or lesser value..."
                }
            },
            fish_fac_blamperer_clout = {
                name = "Clout Trout",
                text = {
                    "{X:attention,C:white}#1#X{} Treasure rewards if",
                    "{C:fac_fish}Fish{} is caught {C:gold}perfectly"
                },
                flavor = {
                    "This one's just trying",
                    "to get your attention."
                }
            },
            fish_fac_blamperer_atlas = {
                name = "Soaked Atlas",
                text = {
                    "{C:chips}#1#{} Chips each time you",
                    "catch a {C:fac_fish}Fish{} in a",
                    "different {C:fac_environment}Environment",
                    "{C:inactive}(Currently {C:chips}#2#{C:inactive} Chips)"
                },
                flavor = {
                    "Probably not suitable for any",
                    "road trips any time soon,",
                    "but can still show you around."
                }
            },
            fish_fac_blamperer_crackers = {
                name = "Fish-shaped Crackers",
                text = {
                    "The next {C:attention}#1#{} scored cards give",
                    "{C:mult}+1{} Mult for every {C:attention}played{} card"
                },
                flavor = {
                    "Hey, at least it was the crackers.",
                    "There are worse fish-shaped things",
                    "to find in your food."
                }
            },
            fish_fac_blamperer_autotuna = {
                name = "Autotuna",
                text = {
                    "Slowly {C:attention}raises{} catch progress",
                },
                flavor = {
                    "Yeah, it'll help, but you still",
                    "need to put in the work yourself."
                }
            },
            fish_fac_blamperer_multisquid = {
                name = "Multicolor Squid",
                text = {
                    "Convert up to {C:attention}#1#{} selected cards",
                    "into a {C:fac_suits}suit{} that {C:attention}isn't{} selected,",
                    "{C:green}#2# in #3#{} chance each",
                    "card becomes {C:attention}Wild",
                    "{ppu_bubble:usable}"
                },
                flavor = {
                    "Normal squids use their ink",
                    "to defend themselves from predation.",
                    "The multiple colors might imply",
                    "this squid has a sense of showmanship."
                }
            }
        },
        PotatoPatch = {
            PotatoPatchDev_blamperer = {
                name = "blamperer",
                text = {
                    "I also made a mod called",
                    "{C:chips}The Latro{}, if you want to",
                    "try that as well.",
                    "{s:0.8}(Click me to check that out!)"
                }
            },
        }
    },
    misc = {
        dictionary = {
            k_fac_blamperer_str_broke = "Streak Broken!",
            k_fac_blamperer_junk = "Junk"
        },
        v_dictionary = {
            a_fac_blamperer_str_gain = "#1#X Streak!"
        }
    }
}
