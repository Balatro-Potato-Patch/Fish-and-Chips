return {
	descriptions = {
		fac_Fish = {
			fish_fac_trojan_fish = {
				name = "Trojan Fish",
				text = {
					"Copies the ability",
					"of {C:attention}Fish{} to the right",
					"{C:green}#1# in #2#{} chance to create",
					"a random {C:attention}Joker{} at end of",
					"round and {C:red,E:2}self destruct",
					"{C:inactive}(Must have room)",
				},
				flavor = {
					"A suspiciously wooden",
					"fish. Surely it doesn't",
					"contain anything",
					"strange inside...",
				},
			},
			fish_fac_moai_statue = {
				name = "Moai Statue",
				text = {
					"Gives more {X:mult,C:white}XMult{} the",
					"closer your date is",
					"to {C:attention}April 5th",
					"{C:inactive}(Gives {X:mult,C:white}X#1#{C:inactive}-{X:mult,C:white}X#2#{C:inactive} Mult)",
					"{C:inactive}(Currently {X:mult,C:white}X#3#{C:inactive} Mult)",
				},
				flavor = {
					"Somehow, this fell off",
					"of Easter Island and",
					"sunk into the water",
				},
			},
			fish_fac_nft = {
				name = "Non-Fungible Trout",
				text = {
					"when hand is played",
					"Gives {C:mult}+1{} Mult per {C:fac_sand_dollars,f:fac_sand_dollars}$",
					"of sell value",
					"{C:inactive}(Minimum of {C:mult}+#1#{C:inactive} Mult)",
					"{C:inactive}(Currently {C:mult}+#2#{C:inactive} Mult)",
				},
				flavor = {
					"This fish is going to",
					"to be worth millions",
					"in the future",
					"trust me bro",
				},
			},
			fish_fac_soul_fysh = {
				name = "Soul Fysh",
				text = {
					{
						"{f:fac_kreon}This {C:attention,f:fac_kreon}Fish{f:fac_kreon} can be",
						"{f:fac_kreon}used {C:attention,f:fac_kreon}once{f:fac_kreon} per round",
						"{ppu_bubble:usable}{ppu_bubble:1}",
					},
					{
						"{f:fac_kreon}When used, adds {C:attention,f:fac_kreon}#1#{f:fac_kreon} random",
						"{C:attention,f:fac_kreon}Enhanced{f:fac_kreon} cards to your deck",
						"{f:fac_kreon}and this {C:attention,f:fac_kreon}Fish{f:fac_kreon} gains {X:mult,C:white,f:fac_kreon}X#2#{f:fac_kreon} Mult",
						"{C:inactive,f:fac_kreon}(Currently {X:mult,C:white,f:fac_kreon}X#3#{C:inactive,f:fac_kreon} Mult)",
					},
				},
				flavor = {
					"{f:fac_kreon}May or may not beckon",
					"{f:fac_kreon}you to your doom",
				},
			},
			fish_fac_fish_flavored_fish = {
				name = "Fish Flavored Fish",
				text = {
					"After a {C:attention}Fish{} is caught,",
					"create a random {C:attention}Fish",
					"{C:inactive}(Must have room)",
				},
				flavor = {
					"I fished you a fish!",
					"Oh boy, what flavour?",
					"Fish flavoured fish",
					"*guitar riff*",
				},
			},
			fish_fac_killer = {
				name = { "Killer Fish", "from San Diego" },
				text = {
					{
						"At end of round, destroy the",
						"nearest {C:attention}Fish{} in the direction",
						"that this {C:attention}Fish{} points towards",
						"and this {C:attention}Fish{} gains {C:attention}1{} charge",
						"Flips direction at end of round",
					},
					{
						"Spend {C:attention}1{} charge to use this",
						"Fish and turn {C:attention}1{} selected",
						"card into a {C:attention}Glass Card",
						"{C:inactive}(Currently {C:attention}#1#{C:inactive} charges)",
						"{ppu_bubble:usable}",
					},
				},
				flavor = {
					"I don't know what I am,",
					"but I taste really good",
				},
			},
			fish_fac_growfish = {
				name = "Growfish",
				text = {
					"Gains {C:chips}+#1#{} Chips",
					"per card played",
					"{C:inactive}(Currently {C:chips}+#2#{C:inactive} Chips)",
				},
				flavor = {
					"{f:fac_papyrus,s:1.2,C:white}address me",
				},
			},
			fish_fac_phish = {
				name = "Phish",
				text = {
					{
						"Doubles money after",
						"playing a hand",
					},
					{
						"At end of round, {X:money,C:white}$^#1#{}",
					},
				},
				flavor = {
					"Looks too good to be true...",
				},
			},
			fish_fac_message = {
				name = "Message in a Bottle",
				text = {
					{
						"Use to open",
					},
					{
						"Contains either a",
						"{C:attention}Voucher{}, {C:money}$#1#{}, or {C:attention}#2#{}",
						"random {C:tarot}Tarot{} cards",
						"{C:inactive}(Must have room)",
						"{ppu_bubble:usable}",
					},
				},
				flavor = {
					"I wonder who sent this?",
				},
			},
			fish_fac_snad = {
				name = "Snad",
				text = {
					"Earn {C:fac_sand_dollars,f:fac_sand_dollars}${C:fac_sand_dollars}#1#{} for every {C:attention}#2#",
					"{C:attention}Fish{} owned at end",
					"of round",
					"{C:inactive}(Currently {C:fac_sand_dollars,f:fac_sand_dollars}${C:fac_sand_dollars}#3#{C:inactive})",
				},
				flavor = {
					"fast sugarcane growth real!!!!",
				},
			},
			fish_fac_reaper_leviathan = {
				name = "Reaper Leviathan",
				text = {
					{
						"At end of round, eats both adjacent {C:attention}Fish",
						"Gains {X:mult,C:white}X#1#{} Mult per {C:attention}Fish{} eaten",
						"{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive} Mult)",
					},
					{
						"{C:attention}Fixed{} {C:green}1 in 2{} chance to leave your",
						"bucket when selecting a {C:attention}Blind{} if no",
						"{C:attention}Fish{} was eaten last round",
					},
				},
				flavor = {
					"Detecting multiple leviathan",
					"class lifeforms in the region.",
					"Are you certain whatever",
					"you're doing is worth it?",
				},
			},
			fish_fac_miku = {
				name = "Hatsune Fishu",
				text = {
					{
						"{C:attention}Aces{} give {X:chips,C:white}X#1#{} Chips",
						"when scored",
					},
				},
				flavor = {
					"The idol of the sea",
				},
			},
		},
		Other = {},
		PotatoPatch = {
			PotatoPatchDev_thunderedge = {
				name = "ThunderEdge",
				text = {
					"Did all the coding work for our fish",
					"Play {C:fac_thunderedge_gradient}Multiverse{} maybe",
					"{C:inactive}(coming soon i swear)",
					"Can't thank Aikoyori enough for helpin",
					"out with the art, they did a really",
					"good job with the spritework",
					"{C:inactive}can confirm, fishes are hard to draw",
					" ",
					"{C:inactive,s:0.7}(also sorry about the electricity",
					"{C:inactive,s:0.7}i can't help it)",
				},
			},
			PotatoPatchDev_aikoyori = {
				name = "Aikoyori",
				text = {
					"ow ow Hello guys today ill be showing you",
					"my fish!!!! ow ow isn't that amazing??",
					"Thanks to ow ThunderEdge (who's ow right",
					"next to me here) I was able to ow focus on",
					"doing ow ow just the art for this ow event",
					"massive ow props to him for ow ow this one",
					"ow",
					"{s:1.3,C:red}Lastly, ow play",
					"{s:1.3,C:red}Aikoyori's ow Shenanigans",
					"{C:inactive}P.S. Fishes are so ow",
					"{C:inactive}ow hard to draw",
					" ",
					"{C:inactive,s:0.7}that hurts a lot",
				},
			},
		},
	},
	misc = {
		dictionary = {
			k_fac_boom_ex = "Boom!",
			k_fac_left_ex = "Left!",
			k_fac_nft_sell_value1 = "Gains",
			k_fac_nft_sell_value1_alt = "Loses",
			k_fac_nft_sell_value2 = "of sell value",
			k_fac_was_used = "Was used this round",
			k_fac_not_used = "Not used this round",
		},
	},
}
