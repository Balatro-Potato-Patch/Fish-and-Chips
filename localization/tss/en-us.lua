return {
	descriptions = {
		fac_Fish = {
			-- - Azazel's Fish -
			fish_fac_tss_shadow_cryscarp = {
				name = "Shadow Cryscarp",
				text = {
					"{C:attention}Classic Canned{} catches",
					"Treasure {C:white,X:attention}X#1#{} faster"
				},
				flavour = {
					"A sharp shadow swims quickly",
					"through water, even above the waves."
				}
			},
			fish_fac_tss_medic = {
				name = "Medic Shark",
				text = {
					"If you run out of {C:attention}hands{} and lose,",
					"restore {C:attention}hands{} and {C:red}Self-destruct"
				},
				flavour = {
					"They forgot to buy the Shield Upgrade."
				}
			},
			fish_fac_tss_bfb = {
				name = "Lobster BFB",
				text = {
					"{C:chips}+#1#{} Chips and {C:white,X:mult}X#2#{} Mult",
					"Sell to create {C:attention}#3# Puffer MOAB{}s",
					"{C:green}#4# in #5#{} chance to be {C:red}destroyed",
					"after scoring, creating one {C:attention}Puffer MOAB"
				},
				flavour = {
					"As if Pat wasn't hungry enough!"
				}
			},
			fish_fac_tss_moab = {
				name = "Puffer MOAB",
				text = {
					"{C:white,X:chips}X#1#{} Chips",
					"{C:green}#2# in #3#{} chance to",
					"be {C:red}destroyed{} after scoring"
				},
				flavour = {
					"All blown up even",
					"before it gets blown up."
				}
			},
			fish_fac_tss_cult = {
				name = "Cultfish",
				text = {
					{
						"Once per {C:attention}Ante{},",
						"{C:red}Sacrifice{} the {C:fac_fish}Fish{} on the",
						"right and gain {C:white,X:mult}X#1#{} Mult",
						"{ppu_bubble:1}"
					},
					{
						"Lose {C:white,X:mult}X#3#{} Mult if no",
						"{C:red}Sacrifice{} is made this {C:attention}Ante",
						"{C:inactive}(Currently {C:white,X:mult}X#2#{C:inactive} Mult)"
					}
				},
				flavour = {
					'"No longer a servant,',
					'no less than a God."'
				}
			},
			fish_fac_tss_watrena = {
				name = "Nymphfish",
				text = {
					"{C:green}#1# in #2#{} chance for {C:fac_fish}Fish",
					"caught in {C:fac_environment}Garden of Hope",
					"to be {C:dark_edition}Editioned"
				},
				flavour = {
					"Don't tell anyone, Watrena",
					"accidentally got turned into a fish."
				}
			},
			fish_fac_tss_ferish = {
				name = "Ferish",
				text = {
					"Played {C:hearts}Hearts{} cards",
					"permanently gain",
					"{C:mult}+#1#{} Mult when scored"
				},
				flavour = {
					"The most popular",
					"pop star of the deep!"
				}
			},
			fish_fac_tss_bee = {
				name = "Bee Fish",
				text = {
					"{E:1}This is good news"
				},
				flavour = {
					"We can finally be bees",
					"This is good news",
					"You'll live for 30 years"
				}
			},

			-- - slimestuff.'s' Fish -
			fish_fac_tss_chesh = {
				name = "Cheshire Catfish",
				text = {
					"{C:green}#1# in #2#{} chance to {C:red}eat",
					"fish when caught",
					"and gain {C:white,X:mult}X#3#{} Mult",
					"{C:inactive}(Currently {C:white,X:mult}X#4#{C:inactive} Mult)"
				},
				flavour = {
					"A carnivorous relative of the",
					"Residential Carp that exclusively",
					"eats other living creatures.",
					" ",
					"Be careful when handling, its",
					"diet isn't limited to fish..."
				},
				unlock = {
					"{C:red}Destroy{} a {C:attention}Residential Carp"
				}
			},
			fish_fac_tss_resident = {
				name = "Residential Carp",
				text = {
					"Gains {C:mult}+#1#{} Mult at",
					"end of round",
					"{C:inactive}(Currently {C:mult}+#2# {C:inactive}Mult)"
				},
				flavour = {
					"This slimy fish seems to",
					"have gotten lost on its",
					"way around The Mall."
				}
			},
			fish_fac_tss_guppy = {
				name = "Guppy",
				text = {
					"Show which {C:fac_fish}Fish{} is",
					"currently being caught"
				},
				flavour = {
					"An eye for secrets"
				}
			},
			fish_fac_tss_plecoholder = {
				name = "Plecoholder",
				text = {
					"When round starts, turn {C:fac_fish}Fish",
					"to the right into another",
					"{C:fac_fish}Fish{} by the same {C:attention}developers"
				},
				flavour = {
					"pls add flavour text later"
				}
			},
			fish_fac_tss_plecoholder1 = {
				name = "Plecoholder",
				text = {
					"When round starts, turn {C:fac_fish}Fish",
					"to the right into another",
					"{C:fac_fish}Fish{} by the same {C:attention}developers",
					"{C:inactive}({V:1}#1#{C:inactive})"
				},
				flavour = {
					"pls add flavour text later"
				}
			},
			fish_fac_tss_plecoholder2 = {
				name = "Plecoholder",
				text = {
					"When round starts, turn {C:fac_fish}Fish",
					"to the right into another",
					"{C:fac_fish}Fish{} by the same {C:attention}developers",
					"{C:inactive}({V:1}#1# {C:inactive}and {V:2}#2#{C:inactive})"
				},
				flavour = {
					"pls add flavour text later"
				}
			},
			fish_fac_tss_caviar = {
				name = "Caviar",
				text = {
					"Gains {C:fac_sand_dollars,f:fac_sand_dollars}${C:fac_sand_dollars}#1#{} of",
					"{C:attention}sell value{} at",
					"end of round"
				},
				flavour = {
					"Expensive fish eggs,",
					"often associated",
					"with the wealthy"
				}
			},
			fish_fac_tss_forcefish = {
				name = "Forcefish",
				text = {
					"Played cards have a",
					"{C:green}#1# in #2#{} chance to turn into",
					"{C:attention}Queens{} after scoring"
				},
				flavour = {
					"I have a suggestion."
				}
			},
			fish_fac_tss_uranium = {
				name = "Uranium Rod",
				text = {
					"{C:attention}Ranks{} of held cards are",
					"{C:attention}randomized{} before scoring"
				},
				flavour = {
					"Who threw this away?",
					"This is definitely radioactive..."
				}
			},
			fish_fac_tss_slop = {
				name = "fishingslop",
				text = {
					"All {C:fac_fish}Fish{} have a fixed {C:green}#1# in #2#",
					"chance to retrigger {C:attention}repeatedly",
					"until the probability fails",
					"{C:red,s:.8}Toggle Low Performance Mode in Mod Settings",
					"{C:inactive,s:.7}...but if you can read this, it's already off"
				},
				flavour = {
					"{C:red}>>283505479 (OP) #",
					"this is just fishingslop. You",
					"only like it because it's fish",
					" ",
					"{C:red}>>283509426 #",
					"What?"
				}
			}
		},
		PotatoPatch = {
			PotatoPatchDev_slimestuff = {
				name = 'slimestuff.',
				text = {
					{
						"{f:fac_tss_slimelets}A system of {f:fac_tss_slimelets,E:fac_tss_rainbow}#1#{f:fac_tss_slimelets} different {f:fac_tss_slimelets,E:fac_tss_rainbow}creatures",
						" {element:1} "
					},
					{
						"{f:fac_tss_slimelets}We did all the code for our",
						"{f:fac_tss_slimelets}entry as {f:fac_tss_slimelets,V:1}Azazel{f:fac_tss_slimelets} isn't a coder.",
						"{f:fac_tss_slimelets}Usually {f:fac_tss_slimelets,V:2}I{f:fac_tss_slimelets} am fronting most of the time",
						"{f:fac_tss_slimelets}but {f:fac_tss_slimelets,V:3}Sara{f:fac_tss_slimelets}'s been fronting a lot",
						"{f:fac_tss_slimelets}so {f:fac_tss_slimelets,V:3}it{f:fac_tss_slimelets} also deserves coding credit."
					},
					{
						"{f:fac_tss_slimelets}Play {f:fac_tss_slimelets,E:fac_tss_rainbow}Mallatro{f:fac_tss_slimelets} pretty please",
						"{f:fac_tss_slimelets}*flutters eyelashes or something*",
						"{f:fac_tss_slimelets,C:inactive}(Clicking the card will take",
						"{f:fac_tss_slimelets,C:inactive}you to its page on our site)",
					},
					{
						"{f:fac_tss_slimelets,s:.8}oh yeah btw our team name is {f:fac_tss_slimelets,E:fac_tss_rainbow,s:.8}the $!$? squad{f:fac_tss_slimelets,s:.8} :3"
					}
				}
			},
			PotatoPatchDev_azazel = {
				name = 'That Azazel Fire',
				text = {
					{
						"Hi, It's me {V:1}Azazel{}, you probably know me.",
					},
					{
						"I like making mods for games I like",
						"and this game {C:attention}TECHNICALLY{} counts as a game I like.",
						"So I worked with {V:2}elle.{} and {V:3}Sara{} to add some {C:fac_fish}fishies{} to this jam.",
					},
					{"There are no {V:4}friends in{V:5}side me{}."}
				}
			},
		}
	},
	misc = {
		dictionary = {
			fac_tss_chesh_giggle_1 = "Hehehe~",
			fac_tss_chesh_giggle_2 = "Yoink~",
			fac_tss_chesh_giggle_3 = "Mine~",
			fac_tss_chesh_giggle_4 = "Thanks~",
			fac_tss_forcefem = "Forcefem!",
			fac_tss_cult_fail = "...", -- ask az what it should say next call
			fac_tss_cult_used = "Used",
			fac_tss_cult_available = "Available",
			fac_tss_popped = "Popped!",

			fac_tss_good_news = "Good News!",
			fac_tss_na1 = "#1#",
			fac_tss_na2 = "#2#",
			fac_tss_bloon = "Bloon"
		},
		v_dictionary = {
			k_fac_tss_again_ex_multi = "Again! x#1#"
		}
	}
}
