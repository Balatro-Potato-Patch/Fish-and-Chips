FishAndChips.Fish({
	key = "unown",
	weight = 4,
	environments = {
		styx = 0.4,
		wormhole = 1,
	},
	ppu_coder = { "Ellen (Haya)" },
	ppu_artist = { "Pepix" },
	attributes = {
		"prevents_death",
	},
	atlas = "hayayaya_fih",
	pos = { x = 3, y = 1 },
	pixel_size = { w = 48, h = 58 },
	display_size = { w = 48 * 1.33, h = 58 * 1.33 },
	stats = {
		length = { min = 1, max = 4 },
		weight = { min = 2, max = 3 },
	},
	badge_key = "k_fac_maybe_fish",
	calculate = function(self, card, context)
		if context.game_over then
			G.E_MANAGER:add_event(Event({
				func = function()
					play_sound("tarot1")
					card:start_dissolve()
					return true
				end,
			}))
			ease_ante(-1)
			return {
				font = "fac_hayayaya_unown",
				saved = "k_fac_hayayaya_unown_saved_" .. math.floor(pseudorandom("unown_text", 1, 7)),
				message = localize("k_fac_hayayaya_unown_saved_ex"),
				colour = G.C.RED,
			}
		end
	end,
})

-- SMODS.calculation_keys["font"] = true
table.insert(SMODS.other_calculation_keys, "font")
SMODS.silent_calculation["font"] = true
