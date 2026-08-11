local function q(s)
	local a = {I = "C:inactive", G = "C:green", A = "C:attention", S = "s:0.7,C:inactive", x = "X:mult,C:white", f = "C:fac_fish"}
	return (s:gsub("~[%l%u]", function(n) return a[n:sub(2)] end))
end

return {
	misc = {
		dictionary = {
			fac_vman2002_manos1 = "\"All it thought about was hands.\"",
			fac_vman2002_manos2 = "I understand eulachon now",
			fac_vman2002_manos3 = "Sardine explains it perfectly",
			fac_vman2002_manos4 = "I don't know anchovy anymore",
			fac_vman2002_manos5 = "Stingray isn't descriptive enough",
			fac_vman2002_manosorry = "11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111",
			fac_vman2002_manos_done = "oIy'owny mkoaeondtrvha nc  n",
			fac_vman2002_timothy0 = "How do you get mods on Nintendo Switch?",
			fac_vman2002_timothy1 = "I'm Timothy!",
			fac_vman2002_timothy2 = "Are you a fishing guy?",
			fac_vman2002_timothy3 = "Why is it called Balatro anyway?",
			fac_vman2002_timothy4 = "Did the game have compounds and allotropes?",
			fac_vman2002_timothy5 = "I can't move Ceremonial Dagger?",
			fac_vman2002_timothy_active = "Yayyyyyy",
			fac_vman2002_timothy_inactive = "Pay attention to me",
			fac_vman2002_timothy_reset = "*crys* why...",
			k_fac_pkr_chips = "Chips",
			k_fac_coupon = "Coupon",
			k_fac_jewellery = "Jewellery"
		}
	},
	descriptions = {
		fac_Fish = {
			fish_fac_vman2002_chips = {
				name = "Chips",
				flavor = {"Yes, indeed."},
				text = {
					"{X:chips,C:white}X#1#{} Chips",
					"{C:purple}+#2#{} Score"
				}
			},
			fish_fac_vman2002_trust = {
				name = "Trust",
				flavor = {"I'm cooking trust"},
				text = {
					q("Raises {~G,E:1}probabilities{} by {~G}+#1#"),
					q("while scoring {~A}first hand"),
					q("{~I}(ex: {~G}1 in 3{~I} -> {~G}#2# in 3{~I})")
				}
			},
			fish_fac_vman2002_manos = {
				name = "?????",
				flavor = {"#1#"},
				text = {
					q("{~A}USE{} to activate,"),
					"becomes {V:1}Eternal",
					"???",
					"{ppu_bubble:usable}"
				}
			},
			fish_fac_vman2002_manos_known = {
				name = "Manos-war",
				flavor = {"#1#"},
				text = {
					{
						q("{~A}USE{} to activate, becomes {V:1}Eternal"),
						"{ppu_bubble:usable}"
					}, {
						q("{~I}While active:"),
						q("{~I}Destroy all played cards in first hand"),
						q("{~I}Retrigger played cards in second hand #6# time"),
						q("{~I}Destroyed after playing hands containing"),
						q("{~I}#2#/#3# Straights and #4#/#5# Flushes")
					}
				}
			},
			fish_fac_vman2002_manos_active = {
				name = "Manos-war",
				flavor = {"#1#"},
				text = {
					q("{~A}Destroy{} all played cards in first hand"),
					q("Retrigger {~A}played{} cards in second hand {~A}#6#{} time"),
					q("{~A}Destroyed{} after playing hands containing"),
					q("{~A}#2#/#3#{} Straights and {~A}#4#/#5#{} Flushes")
				}
			},
			fish_fac_vman2002_necklace = {
				name = "Jewel Necklace",
				flavor = {"Makes you feel like","Deltarune OST - Hip Shop"},
				text = {
					"Always has an {C:dark_edition}Edition"
				}
			},
			fish_fac_vman2002_coupon = {
				name = "Glimmering Coupon",
				flavor = {"Big Companies Care About You!","They Really Do"},
				text = {
					"Create a {C:attention}Shop Edition Tag",
					"Cannot be used while fishing",
					"{ppu_bubble:usable}"
				}
			},
			fish_fac_vman2002_timothy = {
				name = "Timothy",
				flavor = {"Hi, I'm Timothy!","#1#"},
				text = {
					{
						q("Once per {~A}Ante{},"),
						q("Pay {~A}attention{} to {~f}Timothy"),
						"{ppu_bubble:usable}"
					}, {
						q("Gains {~x}X#2#{} Mult at {~A}end of round"),
						q("Resets instead if {~f}Timothy{} is not"),
						q("the most {~A}recently used{} {~f}Fish"),
						"{ppu_bubble:1}",
						q("{~I}(Currently {~x}X#1#{~I} Mult)")
					}
				}
			},
			fish_fac_vman2002_blackbody = {
				name = "Blackbody",
				flavor = {"The darkness emits","a darkness"},
				text = {
					q("After {~A}#1#/#2#{} rounds,"),
					q("{~A}USE{} to add {C:dark_edition}Negative"),
					q("to a random {~A}Joker"),
					"{ppu_bubble:1}"
				}
			},
			fish_fac_vman2002_navyblade = {
				name = "Navy Blade",
				flavor = {"Blinds don't like being","pickpocketed by a","swordfish, it seems."},
				text = {
					q("{~A}USE{} up to {~A}#1#/#2#{}"),
					q("times per {~A}Ante{}"),
					"{ppu_bubble:1}",
					"On each use:",
					"{X:blind,C:white}X#3#{} Blind Size",
					"and earn {C:money}$#4#"
				}
			}
		},
		PotatoPatch = {
			fac_dev_vman2002 = {
				name = "VMan_2002",
				text = {
					"meow mrrp mraow",
					"{s:0.4} ",
					"click me :3",
					"{s:0.8}vman-2002.bsky.social"
				}
			}
		}
	}
}