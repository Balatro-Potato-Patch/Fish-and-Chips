return {
	descriptions = {
		PotatoPatch = {
			PotatoPatchDev_BakersDozenBagels = {
				name = 'Bagels',
				text = {
					'*headbutts you*',
					'*headbutts you*',
					'*headbutts you*',
					'*headbutts you*',
					'*headbutts you*',
				},
			},
			PotatoPatchDev_Emik = {
				name = 'Emik',
				text = { "And Escapey's here, too!" },
			},
		},
		fac_Fish = {
			fish_fac_bagels_european_perch = {
				name = 'European Perch',
				text = { 'You can {C:attention}Skip', '{C:attention}#1#{} Boss Blind' },
				flavor = { "Today's fish is", 'trout a la creme.' },
			},
			fish_fac_bagels_flakefish = {
				name = 'Flakefish',
				text = {
					'{X:mult,C:white}X#1#{} Mult if this hand has',
					'{C:attention}more{} Mult than the last one',
					'or {X:mult,C:white}X0{} Mult otherwise',
					'{C:inactive}(Previously {C:mult}#2#{C:inactive} Mult)',
				},
				flavor = { 'A tiny, delicate fish.', "It's said no two are alike." },
			},
			fish_fac_bagels_hookworm = {
				name = 'Hookworm',
				text = { '{C:attention}+#1#{} Bait when any', 'Booster Pack is opened' },
				flavor = { 'I think this is the', 'same worm you used', 'as bait. It must really', 'like your hook.' },
			},
			fish_fac_bagels_a_for_effish = {
				name = '{element:6} for Effish',
				text = {
					'Held {C:attention}{element:1}ces{} {element:2}re',
					'{element:3}{C:attention}dded{} to pl{element:4}yed h{element:5}nd',
				},
				flavor = { 'This fish seems to', 'like drinking coco{element:1}.' },
			},
			fish_fac_bagels_captain_gills = {
				name = 'Captain Gills',
				text = {
					'{C:attention}Release{} this fish in the',
					'{C:attention}#1#{} to create',
					'a {C:dark_edition}#2# {C:attention}#3#',
				},
				flavor = { 'This carniverous fish grows fast,', 'often outgrowing its habitat.' },
			},
			fish_fac_bagels_fish_phone = {
				name = 'fish fone',
				text = {
					'{C:attention}+#1#{} card slots in shop',
					'{C:red}Destroys{} a random {C:fac_fish}Fish{} or',
					'{C:attention}Joker{} when {C:attention}rerolling{} the shop',
				},
				flavor = { 'Honorable mention of', 'Top 10 Cool Phones' },
			},
		},
	},
	misc = {
		dictionary = {
			k_fac_bagels_plus_bait = '+1 Bait',
			k_fac_bagels_a = 'A',
			k_fac_bagels_release = 'Release',
		},
	},
}
