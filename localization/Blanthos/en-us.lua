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
                    "{C:attention}Feed{} {C:money}$#3#{} to increase {C:fac_happy_gradient}Happiness{} by {C:fac_happy_gradient}#4#{}",
                    "{ppu_bubble:usable}"
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
		"{C:inactive}Currently{} {C:mult}+#1# Mult{} {C:inactive}",
--not enough time to figure out how to make this work so its your problem i guess
		"{ppu_bubble:1}"
},
                flavor = {
                    "It’s a little bit… {C:attention}OFF{}-putting."
                }
	},
            fish_fac_gaster_hat = {
                name = "{C:dark_edition}Green Pirate Hat{}",
                text = {
                    "Whenever ye sell a {C:attention}Joker{}, ye 'ave a {C:green}#1#/#2#{} chance to",
		"plunder a random amount o' {C:fac_sand_dollars,f:fac_sand_dollars}${C:fac_sand_dollars}Sand Dollars{}"
},
                flavor = {
                    "{C:green}CHIPS AHOY, LANDMAGGOTS{}"
                }
	},
            fish_fac_shadowfish = {
                name = "Shadowfish",
                text = {		
			"Has 3 random Attributes",
			"and corresponding effects",
			"while held" 
},
                flavor = {
                    "We {C:fac_bored_gradient}sadly{} did not implement Pluey"
                }
},


            mult = {
                name = "#1# Attribute | {C:mult}Mult{}",
                text = { 
		"{C:mult}+4{} Mult"
		}
	},

            chips = {
                name = "#1# Attribute | {C:chips}Chips{}",
                text =  {
		"{C:chips}+30{} Chips"
		}
	},

            xmult = {
                name = "#1# Attribute | {X:mult,C:white}XMult{}",
                text =  {
		"{X:mult,C:white}X1.5{} Mult"
		}
	},

            economy= {
                name = "#1# Attribute | {C:money}Economy{}",
                text =  {
		"Earn {C:money}$1{}",
		"when you sell a card"
		}
	},

            retrigger = {
                name = "#1# Attribute | {C:attention}Retrigger{}",
                text =  {
		"Retrigger #2# scored card 1 time"
		}
	},

            hand_level = {
                name = "#1# Attribute | {C:planet}Hand Level{}",
                text =  {
		"Level up {C:attention}#2#{}",
		"at end of round"
		}
	},

            usable = {
                name = "#1# Attribute | {C:planet}Usable{}",
                text =  {
		"On use, create a {C:attention}Shadowfish{}",
		"{ppu_bubble:usable}"
		}
	},

            generation= {
                name = "#1# Attribute | Generation",
                text =  {
		"Create a random consumable",
		"whenever you skip a Blind"
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