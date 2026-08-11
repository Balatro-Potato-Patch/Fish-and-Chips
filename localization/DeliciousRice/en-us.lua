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
                    "{X:mult,C:white}X#1#{} Mult,",
                    "{C:red,E:2}self-destructs{} if you defeat",
                    "a blind on your first hand"
                },
                flavor = {
                    "Very helpful but he does",
                    "NOT like instakills"
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
                        "{C:red,E:2}Self-destructs{} if not {C:attention}rehydrated{}"
                    }
                },
                flavor = {
                    "The original goofy goober!"
                }
            },
            
            fish_fac_delrice_blender = {
                name = "Faulty Blender",
                text = {
                    {
                        "Can be used once to turn all fish",
                        "into a {C:attention}fish smoothie{} that contains",
                        "every effect of the blended fish",
                        "{C:inactive}(#3#){}"
                    },
                    {
                        "{C:green}#1# in #2#{} chance to {C:red,E:2}self-destruct{} after every hand"
                    }
                },
                flavor = {
                    "A little water damaged, but",
                    "I'm sure it probably works fine"
                }
            }
        }
    }
}
