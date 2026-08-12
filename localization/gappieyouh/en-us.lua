return {
    misc = {
        dictionary = {
            k_fac_fish_mafia_reset = 'Reset!',
            k_fac_fish_mafia_mod = '+X0.5',
            k_fac_fish_compass_new = 'New location!'
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
                    { "{C:tarot}Use{} to wake up", "Gains {X:mult,C:white}X#2#{} for", "each {C:attention}round{} slept" },
                    { 
                        "{C:attention}After{} waking up, {X:mult,C:white}X#1#{} Mult",
                        "and resets on {C:attention}end of round"
                    }
                },
                flavour = {
                    "Though very sleepy, it",
                    "packs a strong punch when",
                    "its nap is interrupted!"
                }
            },
            fish_fac_gappieyouh_obsession = {
                name = 'Obsessive Fish',
                text = {
                    { 
                        "Getting a {C:dark_edition}perfect catch{}",
                        "and missing a {C:attention}treasure{}",
                        "gives you {C:money}$#1#{}"
                    }
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
                    { 
                        "Sets next location to",
                        "the most common {C:attention}environment{}",
                        "your {C:chips}fish{} belong to"
                    }
                },
                flavour = {
                    "Fortunately for fishing enthusiasts",
                    "around the world, this compass",
                    "has nothing fishy to it. Only, well,",
                    "it's a fish."
                }
            },
            fish_fac_gappieyouh_balloon = {
                name = 'Balloon Fish',
                text = {
                    { 
                        "Gains {C:chips}+#2#{} Chips per fish",
                        "{C:attention}sold{} or {C:attention}used{}",
                        "{C:inactive}(Currently {C:chips}+#1#{C:inactive} Chips)"
                    }
                },
                flavour = {
                    "Especialists suggest that",
                    "balloon fish may be cannibals.",
                    "If you've ever seen one, this",
                    "becomes a lot less impressive."
                }
            },
            fish_fac_gappieyouh_soup = {
                name = 'Soup Fish',
                text = {
                    { 
                        "{C:tarot}Use{} this fish to give",
                        "a {E:1,C:dark_edition}random edition{} to",
                        "{C:attention}another{} fish",
                        "{C:inactive,S:0.8}(Does not give negative)"
                    }
                },
                flavour = {
                    "This popular dish is",
                    "actually not cooked, but",
                    "served raw, as it is caught",
                    "already done!"
                }
            },
            fish_fac_gappieyouh_psa = {
                name = 'Freshly Minted PSA 10 Fish',
                text = {
                    { 
                        "Defeating a {C:attention}Boss Blind{} in one",
                        "{C:blue}hand{} gives {C:planet}#1# Bait{} and {C:fac_sand_dollars,f:fac_sand_dollars}${C:fac_sand_dollars}#2#{}"
                    }
                },
                flavour = {
                    "Legends say this fish is worth",
                    "{{C:fac_sand_dollars,f:fac_sand_dollars}${C:fac_sand_dollars}300,000{}, but it got",
                    "exposed to the sun and thrown",
                    "into the sea. Now it collects",
                    "meaningless value."
                }
            },
        },
    }
}
