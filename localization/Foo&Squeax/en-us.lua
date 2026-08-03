return {
	descriptions = {
		fac_Fish = {
			fish_fac_fas_fish_kebab = {
				name = "Fish Kebab",
				flavour = {
					"Great for the grill",
					"AND the krill."
				},
				text = {
					{
						"figure out how to word this"
					},
					{
						"While Empty:",
						"Use to skewer all fish",
						"to the right of this fish",
					},
					{
						"While filled:",
						"Use to eat all skewered fish"
					}
				}
			},
			fish_fac_fas_submarine = {
				name = 'Submarine',
				flavour = {
					"Looks like someone decided to",
					"take the 3-0-0 out on a joyride"
				},
				text = {
					{
						"While Submerged:",
						"All {C:attention}Jokers{} are debuffed",
						"All Fish retrigger {C:attention}#1#{} times",
						"{C:inactive}[#2#]"
					},
					{
						"Use to submerge/unsubmerge"
					}
				}
			},
			fish_fac_fas_chimera = {
				name = "Water Chimera",
				flavour = {
					"Often mistaken for",
					"birds, bugs, drugs, drills",
					"and baguettes (somehow???)"
				},
				text = {
					{
						"{C:attention}#1#{} are {X:attention,C:white}#2#X{}",
						"more likely to appear"
					},
					{
						"This Fish consumes",
						"caught {C:attention}Food{} Fish",
						"and gains {X:mult,C:white}X#3#{} Mult",
						"{C:inactive}[Currently {X:mult,C:white}X#4#{C:inactive} Mult]"
					}
				}
			},
			fish_fac_fas_kawkaw = {
				name = "BlubBlub",
				flavour = {
					"#3#"
				},
				text = {
					{
						"{X:mult,C:white}X#1#{} Mult",
					},
					{
						"Must be pet periodically",
						"{C:inactive}(but not too much)",
						"or it's shooed away",
						"{C:inactive}[#4# seconds remaining]"
					}
				}
			},
			fish_fac_fas_john_cod = {
				name = "John Cod",
				flavour = {
					"he's john cod"
				},
				text = {
					"Use to instantly {C:attention}win",
					"current non-boss blind",
					"or gain {X:purple,C:white}#1#%{} of",
					"required chips"
				}
			},
			fish_fac_fas_can_of_wormholes = {
				name = "Can of Wormholes",
				flavour = {
					"These space-faring worms finally",
					"managed to reach the other",
					"side of the wormhole"
				},
				text = {
					{
						"This Fish gains {X:mult,C:white}X#1#{} Mult when a Fish made by {C:attention}#2#{} is caught",
						"{C:inactive}[Currently {X:mult,C:white}X#3#{C:inactive} Mult]   {C:inactive}[Target changes every round]"
					},
					{
						"Use this Fish to convert it into {C:attention}#4#{} bait per {C:attention}#1# {X:mult,C:white}XMult{} gained"
					}
				}
			},
			fish_fac_fas_super_bo_noise = {
				name = "Super Bo Noise",
				flavour = {
					"Dear Bo N.,",
					"Stop pretending to be an endangered fish.",
					"It's not funny, we get worried everytime.",
					"Stop wasting our time, ",
					"- Animal Rescue Services"
					--[[ This is ripped from one of the letters you can get ingame, 
					specifically for staying out of water for a while in Fish Form lol
					- gabby ]]
				},
				text = {
					"Each played card",
					"permanently gains",
					"{X:mult,C:white}X#1#{} Mult when scored"
				}
			},
			fish_fac_fas_kyu_kurafin = {
				name = "Kyu-Kurafin",
				flavour = {
					"{f:5}わたし ちゅうぶらりん"
				},
				text = {
					"This Fish gains {C:chips}+#1#{} Chips",
					"when a Fish is {C:red}lost",
					"or a treasure is {C:red}failed",
					"{C:inactive}[Currently {C:chips}+#2#{C:inactive} Chips]"
				}
			},
			fish_fac_fas_kine = {
				name = "Kine",
				flavour = {
					"A funny guy who looks",
					"just like an ocean sunfish.",
					"He'll always stick",
					"by everyone's side."
					-- ripped from Kirby's Star Stacker website [ https://www.nintendo.co.jp/n02/dmg/akcj/chr.html ]
				},
				text = {
					{
						"not sure how to word"
					},
					{
						"Use to {C:red}consume{} held Joker",
						"and then {C:attention}grab{} leftmost Joker",
					}
				}
			},
			fish_fac_fas_tsundere = {
				name = "Tsunderfish",
				flavour = {
					"No way! Why would I like YOU"
				},
				text = {
					"Needs some encouragement",
					"before it's ready to help you.",
					"Maybe some {C:attention}ACT{}ing would work?",
					"{C:inactive}[Once per round]"
				}
			},
			fish_fac_fas_tsundere_active = {
				name = "Tsunderfish",
				flavour = {
					"Finally Confessed",
					"{s:0.8}What!? I didn't!!"
				},
				text = {
					"It's not like I want to give you",
					"{C:attention}+#1#{} selection limit. Hmph!"
				}
			},
			fish_fac_fas_toby_fish = {
				name = "Goby Fox",
				flavour = {
					"{element:1}"
				},
				text = {
					"this should never appear"
				}
			},
			fish_fac_fas_isreal = {
				name = "Bassriel Dreemurr",
				flavour = {
					"Don't krill, and don't be krilled, alright?"
				},
				text = {
					"{C:mult}+#1#{} Mult per unique Fish",
					"caught this run",
					"{C:inactive}[Currently {C:mult}+#2#{C:inactive} Mult]"
				}
			},
			fish_fac_fas_sardine = {
				name = "Loser's Sardine",
				flavour = {

				},
				text = {

				}
			},
			fish_fac_fas_luka = {
				name = "Tako Luka",
				flavour = {
					"{f:5}たこルカ★マグロフィーバー"
				},
				text = {
					"Each {C:attention}8{} held in hand",
					"at the end of round",
					"has a {C:green}#1# in #2#{} change",
					"to create a {C:attention}Bait"
				}
			},
			fish_fac_fas_you = {
				name = "YOU",
				flavour = {

				},
				text = {

				}
			}
		},
		PotatoPatch = {
			fac_fas_dev = {
				name = "Developer"
			},
			PotatoPatchDev_Foo54 = {
				name = "Foo54",
				text = {
					{
						"temp"
					},
					{
						"Defoko drawn by {C:ED5B5B}me",
						"Harpoon Gun drawn by {C:attention}Kitty"
					}
				}
			},
			PotatoPatchDev_squeax09 = {
				name = "squeax09",
				text = {
					{"ts {C:green,E:1}gabby{}"},
					{"{element:1}",
					"As you may have seen, I was a {C:edition,E:1}Guest Dev{}, and helped make",
					"art for the base mod itself.",
					"{s:0.8}(Though you'll likely see I ended up spriting more stuff besides all the baits lol)",
					"{element:2}",
					"I also worked with Foo to art a lot of silly things",
					"for our entry, so I do hope you enjoy the goofiness that's come of it! :3"}
				}
			}
		}
	},
	misc = {
		dictionary = {
			k_fac_fas_submerged = "Submerged!",
			k_fac_fas_unsubmerged = "Unsubmerged!",
			k_fac_fas_resurface = "Going Up!",
			k_fac_fas_dive = "Dive! Dive! Dive!",
			k_fac_fas_yum = "Yum!",
			k_fac_fas_nom = "Nom!",
			k_fac_fas_nyom = "nyoooooom...",
			k_fac_fas_nyon = 'Nyon!',
			k_fac_fas_ule = "Ueueleuleuleue!",
			k_fas_fas_annoying_dog = "Annoying Fish",

			k_fac_fas_flirt = "Flirt",
			k_fac_fas_approach = "Approach",
			k_fac_fas_check = "Check",
			ph_fac_fas_tsunderfish_check_1 = "Seems mean, but does",
			ph_fac_fas_tsunderfish_check_2 = "it secretly like you?",
			ph_fac_fas_tsunderfish_fail_a_1 = "Tsunderfish looks over,",
			ph_fac_fas_tsunderfish_fail_a_2 = "then turns up its nose.",
			ph_fac_fas_tsunderfish_fail_b_1 = "Tsunderfish shakes its",
			ph_fac_fas_tsunderfish_fail_b_2 = "tail dimissively at you.",
			ph_fac_fas_tsunderfish_fail_c_1 = "Tsunderfish \"accidentally\"",
			ph_fac_fas_tsunderfish_fail_c_2 = "bumps you with its fins.",
			ph_fac_fas_tsunderfish_fail_d_1 = "Tsunderfish gives you a",
			ph_fac_fas_tsunderfish_fail_d_2 = "condescending barrel roll.",
			ph_fac_fas_tsunderfish_flirt_a_1 = "You tell Tsunderfish it has",
			ph_fac_fas_tsunderfish_flirt_a_2 = "an impressive finspan.",
			ph_fac_fas_tsunderfish_flirt_b_1 = "You tell Tsunderfish",
			ph_fac_fas_tsunderfish_flirt_b_2 = "it has nice gills.",
			ph_fac_fas_tsunderfish_flirt_c_1 = "You tell Tsunderfish it",
			ph_fac_fas_tsunderfish_flirt_c_2 = "has a powerful tail.",
			ph_fac_fas_tsunderfish_flirt_d_1 = "You tell Tsunderfish that you",
			ph_fac_fas_tsunderfish_flirt_d_2 = "like its taste in movies and books.",
			ph_fac_fas_tsunderfish_approach_a_1 = "You get close to Tsunderfish.",
			ph_fac_fas_tsunderfish_approach_a_2 = "But not that close.",
			ph_fac_fas_tsunderfish_approach_b_1 = "You get close to Tsunderfish.",
			ph_fac_fas_tsunderfish_approach_b_2 = "But not too close.",
			ph_fac_fas_tsunderfish_approach_c_1 = "You get closer to Tsunderfish.",
			ph_fac_fas_tsunderfish_approach_c_2 = "But not too closer.",
			ph_fac_fas_tsunderfish_approach_d_1 = "You get closest to Tsunderfish.",
			ph_fac_fas_tsunderfish_approach_d_2 = "But not too closest.",
			ph_fac_fas_tsunderfish_active = "Human, I...",
			b_fac_fas_act = "ACT",

			k_fac_fas_worm = "Can? Worms?",
			k_fac_fas_skewer = "Skewer",
			k_fac_fas_nyon_label = "Nyon",
			k_fac_fas_submarine = "Submarine",
			k_fac_fas_fatchud = "Fat Chud",
		}
	}
}