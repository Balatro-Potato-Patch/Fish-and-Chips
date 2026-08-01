local function q(s)
	local a = {I = "C:inactive", G = "C:green", A = "C:attention", S = "s:0.7,C:inactive"}
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
			fac_vman2002_manos_done = "oIy'owny mkoaeondtrvha nc  n"
		}
	},
	descriptions = {
		fac_Fish = {
			fish_fac_vman2002_chips = {
				name = "Chips",
				text = {
					"{X:chips,C:white}X#1#{} Chips",
					"{C:purple}+#2#{} Score",
					--TODO: Remove this part if the positioning shit gets fixed
					q("{~S}how the frick do you make the"),
					q("{~S}sprite positioning match up")
				},
				flavor = {
					"Yes."
				}
			},
			fish_fac_vman2002_trust = {
				name = "Trust",
				text = {
					q("Raises {~G,E:1}probabilities{} by {~G}+2"),
					q("while scoring {~A}first hand"),
					q("{~I}(ex: {~G}1 in 3{~I} -> {~G}3 in 3{~I})")
				},
				flavor = {"I'm cooking trust"}
			},
			fish_fac_vman2002_manos = {
				name = "?????",
				flavor = {"#1#"},
				text = {
					q("{~A}USE{} to activate,"),
					"becomes {V:1}Eternal",
					"???"
				}
			},
			fish_fac_vman2002_manos_known = {
				name = "Manos-war",
				flavor = {"#1#"},
				text = {
					{
						q("{~A}USE{} to activate, becomes {V:1}Eternal")
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
			}
		},
		PotatoPatch = {
			fac_dev_vman2002 = {
				name = "VMan_2002",
				text = {
					"meow mrrp mraow",
					"{S:0.5}vman-2002.bsky.social"
				}
			}
		}
	}
}