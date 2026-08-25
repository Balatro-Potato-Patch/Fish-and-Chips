return {
	descriptions = {
		PotatoPatch = {
			["PotatoPatchDev_Ellen (Haya)"] = {
				name = "Ellen (Haya)",
				text = {
					{
						"{f:1}There's a note attached...",
						"{f:fac_hayayaya_pkmn,C:red}LEAF's{f:fac_hayayaya_pkmn} just an {f:fac_hayayaya_pkmn,C:blue}ABYSS",
						"{f:fac_hayayaya_pkmn}for {f:fac_hayayaya_pkmn,C:dark_edition}MISSINGNO.{f:fac_hayayaya_pkmn} about the",
						"{f:fac_hayayaya_pkmn,C:green}new rock by the water",
					},
					{
						"{s:1.2}You already know who it is......",
						"It's still {C:red}haya{} but feel free to call me {C:edition}ellen{} now",
						"{s:0.6}also {s:1.5,C:dark_edition}PLAY MY GAME(s):",
						"https://haya3218.nekoweb.org/",
					},
				},
			},
			PotatoPatchDev_Pepix = {
				name = "Pepix",
				text = {
					"We can fuck until the sun burns out, you can rot for clout",
					"-Kasane Teto 2024",
					"(Im Pepix, no one favorite Bi guy)",
				},
			},
		},
		fac_Fish = {
			fish_fac_mewtwostrikesback = {
				name = "Cloner Fish",
				text = {
					"{C:attention}Clones{} a random {C:fac_fish}Fish{}",
					"and multiplies its",
					"values by {X:attention,C:white}X#1#-X#2#{}",
					"{C:inactive,s:0.8}Cannot clone other Cloner Fish{}",
					"{ppu_bubble:usable}",
				},
				flavor = {
					"Cloning fish like this has",
					"dire, dire consequences..."
				},
			},
			fish_fac_8f = { -- For compendium
				name = "????",
			},
			fish_fac_8f_normal = {
				name = "{f:fac_hayayaya_pkmn}8F",
				text = {
					"{C:inactive,f:fac_hayayaya_pkmn}#1#/#2#",
				},
				flavor = {
					"{f:fac_hayayaya_pkmn}???",
				},
			},
			fish_fac_8f_alt = {
				name = "{f:fac_hayayaya_pkmn}8F",
				text = {
					"{C:red,f:fac_hayayaya_pkmn}Removes",
					"{f:fac_hayayaya_pkmn}an Ante",
					"{ppu_bubble:usable}",
				},
				flavor = {
					"{f:fac_hayayaya_pkmn}3 NEW",
				},
			},
			fish_fac_codamite = {
				name = "Codamite",
				text = {
					"{C:attention}Halves{} or {C:attention}doubles{} current",
					"{C:attention}Boss Blind's{} requirement,",
					"{C:red,E:2}explodes{}",
					"{ppu_bubble:usable}",
				},
				flavor = {
					"'Try my new flavor!'",
				},
			},
			fish_fac_anglrifle = {
				name = "Anglrifle",
				text = {
					"{C:red}Destroys{} all cards in first",
					"{C:red}discard{} of round, gains {C:chips}+#1#{} Chips",
					"for each card {C:red}destroyed{} this way",
					"{C:inactive}(Currently {C:chips}+#2#{C:inactive} Chips)",
					"{ppu_bubble:1}",
				},
				flavor = {
					"This fish somehow shoots bullet-like",
					"things out of its mouth",
				},
			},
			fish_fac_boot = {
				name = "Boot",
				text = {
					"Gains {C:mult}+#1#{} Mult for",
					"every {C:attention}discarded{} card",
					"{C:inactive}(Currently{} {C:mult}+#2#{C:inactive} Mult)",
				},
				flavor = {
					"What sailor left this here?",
				},
			},
			fish_fac_cat1 = {
				name = "Crazed Fish Cat",
				text = {
					{
						"Gains {C:chips}+#1#{} Chips when",
						"a card is {C:attention}scored",
						"{C:inactive}Resets after scoring hand{}",
					},
					{
						"{C:inactive}(Currently{} {C:chips}+#2#{C:inactive} Chips)",
						"{C:inactive}(Evolves at #3#/#4#)",
					},
				},
				flavor = {
					"Strong against reds",
					"Doesn't work on blinds",
				},
			},
			fish_fac_cat2 = {
				name = "Crazed Whale Cat",
				text = {
					{
						"Gains {C:chips}+#1#{} Chips when",
						"a card is {C:attention}scored",
						"{C:inactive}Resets at end of round{}",
					},
					{
						"{C:inactive}(Currently{} {C:chips}+#2#{C:inactive} Chips)",
						"{C:inactive}(Evolves at #3#/#4#)",
					},
				},
				flavor = {
					"It's a little better...",
				},
			},
			fish_fac_cat3 = {
				name = "Manic Island Cat",
				text = {
					{
						"Gains {X:chips,C:white}X#1#{} Chips when",
						"a card is {C:attention}scored",
						"{C:inactive}Resets at end of Ante{}",
					},
					{
						"{C:inactive}(Currently{} {X:chips,C:white}X#2#{C:inactive} Chips)",
					},
				},
				flavor = {
					"This isn't a fish anymore...",
				},
			},
			fish_fac_inferno = {
				name = "Fish's Inferno",
				text = {
					"{C:green}#1# in #2#{} chance of",
					"getting the Bait {C:attention}back{}",
					"after a successful catch",
				},
				flavor = {
					"Excuse me sir! There must be",
					"someone you've confused me for!",
				},
			},
			fish_fac_celadon = {
				name = "Rainbow Badge",
				text = {
					"Add {C:dark_edition}Polychrome{} to",
					"a random {C:fac_fish}Fish{}",
					"{ppu_bubble:usable}",
				},
				flavor = {
					"{C:white}Celadon City Gym Badge",
					"It's covered in algae...",
				},
			},
			fish_fac_motif = {
				name = "Freedom Motif",
				text = {
					"When a {C:fac_fish}Fish{} is {C:attention}sold{}, get",
					"the Bait you used {C:attention}back{}",
					"{X:attention,C:white}X0{C:red} {C:fac_fish}Fish{} sell value",
					"{C:inactive,s:0.8}Doesn't apply to perfect catches{}",
				},
				flavor = {
					"TURN ME INTO A [REAL BOY!!!]",
				},
			},
			fish_fac_unown = {
				name = "Unown",
				text = {
					"Prevents Death and",
					"rewinds the {C:attention}Ante{} by {C:attention}1{}",
					"{C:red,E:2}self destructs",
				},
				flavor = {
					"If there is an Unown for",
					"every character, surely",
					"ones exist for emojis...",
				},
			},
			fish_fac_luvdisc = {
				name = "Luvdisc",
				text = {
					"This {C:fac_fish}Fish{} gains {X:mult,C:white}X#1#{} Mult when a",
					"{C:hearts}Hearts{} card scores, {C:attention}resets{} when",
					"a non-{C:hearts}Hearts{} card scores",
					"{C:inactive}(Currently{} {X:mult,C:white}X#2#{C:inactive} Mult)",
				},
				flavor = {
					"It is said that a couple",
					"finding this Pokémon will",
					"be blessed with eternal love.",
				},
			},
			fish_fac_gfzrock = {
				name = "GFZROCK",
				text = {
					"{X:mult,C:white}X#1#{} Mult if",
					"you have {C:money}$#2#{}",
				},
				flavor = {
					"When you're out of quarters,",
					"he's got your back!",
				},
			},
			fish_fac_tower = {
				name = "Tower of Babel",
				text = {
					"{X:mult,C:white}X#1#{} Mult for every",
					"{C:attention}unique suit{} in scored hand",
				},
				flavor = {
					"Y'know, from the Bible!",
				},
			},
		},
	},
	misc = {
		dictionary = {
			ph_facyou_hayayaya_active = "Active!",
			ph_facyou_hayayaya_inactive = "Inactive!",
			ph_facyou_hayayaya_evolved = "Evolved!",
			ph_facyou_hayayaya_returned = "Returned!",
			-- Fish 'types'
			k_fac_hayayaya_unknown = "???",
			k_fac_hayayaya_badge_q = "Badge?",
			k_fac_hayayaya_object = "Object",
			k_fac_hayayaya_catfish = "Catfish",
			-- Misc other stuff
			k_fac_hayayaya_unown_saved = "WELCOME BACK",
			k_fac_hayayaya_unown_saved_ex = "Rewind!",
			k_fac_hayayaya_unown_saved_1 = "WELCOME BACK",
			k_fac_hayayaya_unown_saved_2 = "ARE YOU OKAY?",
			k_fac_hayayaya_unown_saved_3 = "THE SIMULACRUM IS STILL STABLE",
			k_fac_hayayaya_unown_saved_4 = "THE KING AWAITS",
			k_fac_hayayaya_unown_saved_5 = "ARE YOU TRYING TO DECODE THIS",
			k_fac_hayayaya_unown_saved_6 = "THERE IS A NEW ROCK BY THE POND",
			k_fac_hayayaya_unown_saved_7 = "DON'T DO THAT AGAIN",
		},
	},
}
