return {
    descriptions = {
		PotatoPatch = {
			PotatoPatchDev_Blanthos = {
				name = "Blanthos",
			},
			PotatoPatchDev_Hunter = {
				name = "Hunter",
			},
        },
        fac_Fish = {
            fish_fac_gneep_gnarp = {
                name = "Gneep Gnarp",
                text = {
		{
                    "Gives temporary {C:planet}Hand Levels{} to {C:attention}#6#{}",
                    "based on current {C:fac_happy_gradient}Happiness{}",
                    "{C:inactive}Currently{} {C:fac_happy_gradient}#1# Happiness{} {C:inactive}/{} {C:planet}#5# Levels{}",
                },
		{
                    "{C:fac_bored_gradient}-#2# Happiness{} from {C:fac_bored_gradient}Boredom{} at end of round",
                },
		{
                    "Gains {C:fac_happy_gradient}#4# Happiness{} when {C:attention}Fed{}",
		}
},
                flavor = {
                    "Bingle bongle, dingle dangle,",
                    "yickety-doo, yickety-da,",
                    "ping-pong, lippy-tappy too-ta."
                }
	},
            fish_fac_spectre_fish = {
                name = "Spectre Fish",
                text = {
                    "The first time this would be {C:attention}destroyed{} each round",
		"instead gain {C:mult}+#2# Mult{}",
		"{C:inactive}Currently{} {C:mult}+#1# Mult{} {C:inactive}/{} {C:attention}#3#{}"
},
                flavor = {
                    "It’s a little bit… {C:attention}OFF{}-putting."
                }
	},
            fish_fac_gaster_hat = {
                name = "{C:dark_edition}Green Pirate Hat{}",
                text = {
                    "Whenever ye sell a {C:attention}Joker{}, ye 'ave a {C:green}#1#/#2#{} chance to",
		"plunder a random amount of {C:fac_sand_dollars,f:fac_sand_dollars}${C:fac_sand_dollars}Sand Dollars{}"
},
                flavor = {
                    "{C:green}CHIPS AHOY, LANDMAGGOTS{}"
                }
	},
        },
   misc = {
        dictionary = {
			blanth_yum = "Yummy!",
			blanth_bored = "Bored...",
			blanth_placeholder = "YUFGTYUITWEYU"
},
}
    }
}