return {
    descriptions = {
		PotatoPatch = {
			PotatoPatchDev_cheekyrotter = {
				name = "cheekyrotter",
			},
			PotatoPatchDev_EDriGO = {
				name = "EDriGO",
			},
        },
        fac_Fish = {
            fish_fac_delrice_fringills = {
                name = "Fringills",
                text = {
                    {
                        "{X:mult,C:white}X#1#{} Mult"
                    },
                    {
                        "{C:red,E:2}Self-destructs{} if you defeat",
                        "a blind on your first hand"
                    }
                },
                flavor = {
                    "(This is an inside joke)"
                }
            },
            fish_fac_delrice_spongebob = {
                name = "SpongeBob",
                text = {
                    {
                        "Gains {C:mult}+#2#{} Mult",
                        "when a card {C:attention}flips{}",
                        "{C:inactive}(Currently {C:mult}+#1#{C:inactive} Mult){}"
                    },
                    {
                        "{C:red,E:2}Self-destructs{} if not {C:attention}rehydrated{}",
                        "at a fishing spot with water",
                        "after every round"
                    }
                },
                flavor = {
                    "The original goofy goober!"
                }
            },
            fish_fac_delrice_spongecorpse = {
                name = "SpongeBob's Corpse",
                text = {
                    {
                        "Does nothing, a reminder",
                        "of your negligence."
                    }
                },
                flavor = {
                    "What have you done?"
                }
            },
            
            fish_fac_delrice_blender = {
                name = "Faulty Blender",
                text = {
                    {
                        "Blends all fish into a {C:attention}fish smoothie{},",
                        "which absorbs all their effects",
                        "{C:inactive}(#3#){}"
                    },
                    {
                        "{C:green}#1# in #2#{} chance to {C:red,E:2}self-destruct{} after each round"
                    }
                },
                flavor = {
                    "A little water damaged, but",
                    "I'm sure it probably works fine"
                }
            },
            fish_fac_delrice_gambling = {
                name = "Can't Stop Fishing!",
                text = {
                    {
                        "Gives {C:fac_sand_dollars,f:fac_sand_dollars}${C:fac_sand_dollars}#1#{} when a {C:attention}Treasure{} is",
                        "collected and increase amount by #2#"
                    },
                    {
                        "{C:red,E:2}Self-destructs{} if you fail to",
                        "collect {C:attention}Treasure{} while fishing"
                    }
                },
                flavor = {
                    "pretend raxdflipnote is trapped inside,",
                    "that's why you can hear him talking"
                }
            }
        }
    }
}
