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
						"Skewered {C:fac_fish}Fish{} still activate normally",
						"At end of round, consume topmost {C:fac_fish}Fish{}"
					},
					{
						"While Empty:",
						"Use to skewer all {C:fac_fish}Fish{}",
						"to the right of this {C:fac_fish}Fish{}",
					},
					{
						"While filled:",
						"Use to eat all skewered {C:fac_fish}Fish{}"
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
						"All {C:fac_fish}Fish{} retrigger {C:attention}#1#{} times",
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
						"This {C:fac_fish}Fish{} consumes",
						"caught {C:attention}Food{} {C:fac_fish}Fish{}",
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
						"This {C:fac_fish}Fish{} gains {X:mult,C:white}X#1#{} Mult when a {C:fac_fish}Fish{} made by {C:attention}#2#{} is caught",
						"{C:inactive}[Currently {X:mult,C:white}X#3#{C:inactive} Mult]   {C:inactive}[Target changes every round]"
					},
					{
						"Use this {C:fac_fish}Fish{} to convert it into {C:attention}#4#{} bait per {C:attention}#1# {X:mult,C:white}XMult{} gained"
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
					"This {C:fac_fish}Fish{} gains {C:chips}+#1#{} Chips",
					"when a {C:fac_fish}Fish{} is {C:red}lost",
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
						"Held Joker is treated as if it was a {C:fac_fish}Fish"
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
					"{C:mult}+#1#{} Mult per unique {C:fac_fish}Fish{}",
					"caught this run",
					"{C:inactive}[Currently {C:mult}+#2#{C:inactive} Mult]"
				}
			},
			fish_fac_fas_sardine = {
				name = "Loser's Zacco",
				flavour = {
					"{f:5}なに ちょっと無視しないで"
				},
				text = {
					{
						"{C:fac_fish}Fish{} with at most {C:attention}#1#",
						"attributes give {C:chips}+#2#{} Chips",
						"{C:inactive}#3#",
						"{C:inactive}#4#",
					}
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
						"You should click me it'll be funny trust"
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
			k_fac_fas_toby = "Toby",
			k_fac_fas_temmie = "Temmie",
			k_fac_fas_left = "left",
			k_fac_fas_right = "right",

			k_fac_fas_flirt = "Flirt",
			k_fac_fas_approach = "Approach",
			k_fac_fas_check = "Check",
			ph_fac_fas_tsunderfish_check_1 = "TSUNDERFISH 25 ATK 26 DEF",
			ph_fac_fas_tsunderfish_check_2 = "Seems mean, but does",
			ph_fac_fas_tsunderfish_check_3 = "it secretly like you?",
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

			k_fac_fas_undertale_fight = "FIGHT",
			k_fac_fas_undertale_act = "ACT",
			k_fac_fas_undertale_item = "ITEM",
			k_fac_fas_undertale_mercy = "MERCY",
			
			b_fac_fas_undertale_foo = "Foo54",
			b_fac_fas_undertale_squeax = "Gabby",
			b_fac_fas_undertale_check = "Check",
			b_fac_fas_undertale_spare = "Spare",
			b_fac_fas_undertale_flee = "Flee",
			b_fac_fas_undertale_projects = "Mods",
			b_fac_fas_undertale_worked_on = "Mods I've worked on (you should check them out after this)",
			b_fac_fas_undertale_synthb = "SynthB - The Vocaloid Balatro Mod",
			b_fac_fas_undertale_bad_director = "Bad Director - The Glitchiest Balatro Mod",
			b_fac_fas_undertale_guest_dev = "Guest Dev",
			b_fac_fas_undertale_colon_3 = ":3",

			k_fac_fas_undertale_textbox = {
				start = {
					"Foo stumbles into combat!",
					"Gabby flies in!"
				},
				combat = {
					"Due to budget cuts,",
					"we have removed the combat system.",
					"",
					"We apologize for the inconvience."
				},
				check_foo = {
					"FOO 04 ATK 01 DEF",
					"Programmer for (almost) everything between me and Gabby's submissions",
					"Made this UI that way I could give her a break while still coding :3",
					"Tried to learn art before this so I could go solo, but man fish are hard"
				},
				foo_guest_dev = {
					"Yep, I'm a guest dev!",
					"I was originally chosen for my ui work (see SynthB's credits, or this),",
					"but ended up doing most of the API instead.",
					"You wont actually see most of the things I did,",
					"as its mostly the framework for fish and environments.",
					"I had the idea for the bucket though (:"
				},
				foo_colon_3 = {
					":3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3",
					":3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3",
					":3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3",
					":3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3",
					":3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3",
					":3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3",
					":3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3:3",
				},
				check_squeax = {
					"GABBY 06 ATK 09 DEF",
					"A simple washed machine.",
					"Allegedly a 'Guest Dev' of some kind.",
					"It seems like her Credit Card",
					"in the compendium has more information..."
				},
				spare = {
					"You WON!",
					"Earned 0 EXP and 0 GOLD"
				},
				flee_1 = {
					"Escaped..."
				},
				flee_2 = {
					"Don't slow me down."
				},
				flee_3 = {
					"I'm outta here."
				},
				flee_4 = {
					"I got better things to do."
				},
				no_items = {
					"You aren't carrying any items on you."
				}
			}
		},
		v_dictionary = {
			k_fac_fas_attributes = "The Fish to the #3# has #1# attribute#2#",
			k_fac_fas_zaako_no_fish = "There are no Fish to the #1#",
		}
	}
}