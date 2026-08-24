return {
    misc = {
        dictionary = {
            k_fac_fish_mafia_reset = 'Reset!',
            k_fac_fish_compass_new = 'New location!'
        },
        v_dictionary = {
            k_fac_fish_mafia_mod = '+X#1# Mult',
        }
    },
    descriptions = {
        PotatoPatch = {
            PotatoPatchDev_Youh = {
                name = "Youh",
            },
            PotatoPatchDev_Gappie = {
                name = "Gappie",
            },
        },
        fac_Fish = {
            fish_fac_gappieyouh_mafia = {
                name = 'Mafia Fish',
                text = {
                    {
                        "Stores {X:mult,C:white}X#2#{} Mult for",
                        "each round this {C:fac_fish}Fish{}",
                        "has {C:attention}slept{} through"
                    },
                    {
                        "{C:attention}Use{} to wake up",
                        "{C:attention}After{} waking up, {X:mult,C:white}X#1#{} Mult",
                        "and resets at {C:attention}end of round",
                        "{ppu_bubble:1}"
                    }
                },
                flavour = {
                    "Though very sleepy, it packs a strong",
                    "punch when its nap is interrupted!"
                }
            },
            fish_fac_gappieyouh_obsession = {
                name = 'Obsessive Fish',
                text = {
                    "On {C:dark_edition}perfect catch{}, earn {C:money}$#1#{}",
                    "if there was {C:attention}Treasure{}",
                    "that you {C:red}didn't{} catch"
                },
                flavour = {
                    "These fish are big fans",
                    "of other fish! They'll do",
                    "{C:red}anything{} to be with one."
                }
            },
            fish_fac_gappieyouh_compass = {
                name = 'Fishy Compass',
                text = {
                    "Sets the next {C:fac_environment}Environment{} to",
                    "the most common {C:fac_environment}Environment{}",
                    "your {C:fac_fish}Fish{} belong to",
                    "{ppu_bubble:usable}"
                },
                flavour = {
                    "Fortunately for fishing enthusiasts",
                    "around the world, this compass has",
                    "nothing fishy to it. Only, well, it's a fish."
                }
            },
            fish_fac_gappieyouh_balloon = {
                name = 'Balloon Fish',
                text = {
                    "Gains {C:chips}+#2#{} Chips per",
                    "{C:fac_fish}Fish{} {C:attention}sold{} or {C:attention}used{}",
                    "{C:inactive}(Currently {C:chips}+#1#{C:inactive} Chips)"
                },
                flavour = {
                    "Specialists suggest that",
                    "balloon fish may be cannibals.",
                    "If you've ever seen one, this",
                    "becomes a lot less impressive."
                }
            },
            fish_fac_gappieyouh_soup = {
                name = 'Soup Fish',
                text = {
                    "Use this {C:fac_fish}Fish{} to apply",
                    "a {E:1,C:dark_edition}random edition{} to",
                    "{C:attention}another{} {C:fac_fish}Fish{}",
                    "{C:inactive}(Cannot apply {C:dark_edition}Negative{C:inactive})",
                    "{ppu_bubble:usable}"
                },
                flavour = {
                    "This popular dish is actually",
                    "not cooked, but served raw, as",
                    "it is caught already done!"
                }
            },
            fish_fac_gappieyouh_psa = {
                name = 'Freshly Minted PSA 10 Fish',
                text = {
                    "Defeating {C:attention}Boss Blind{} on {C:attention}first hand{}",
                    "of round gives {C:attention}#1#{} Bait and {C:fac_sand_dollars,f:fac_sand_dollars}$#2#{}"
                },
                flavour = {
                    "Legends say this fish is worth {C:fac_sand_dollars,f:fac_sand_dollars}$300,000{}, but",
                    "it got exposed to the sun and thrown into",
                    "the sea. Now it collects meaningless value."
                }
            },
        },
    }
}
