-- SMODS.Sound({
-- 	key = "sprat_can_opening",
-- 	path = "sg11_n_vekhi/can_opening.ogg",
-- })

SMODS.Atlas({
	key = "sg11_n_vekhi_lemon_fish",
	path = "sg11_n_vekhi/lemon_fish.png",
	px = 71,
	py = 95,
})

FishAndChips.Fish({
	key = "sg11_n_vekhi_lemon_fish",
	atlas = "fac_sg11_n_vekhi_lemon_fish",
	pos = { x = 0, y = 0 },
	ppu_coder = { "sleepyg11" },
	ppu_artist = { "vevekhi" },
	attributes = {},
	config = {
		extra = {
			skip_tags = 2,
		},
	},
	weight = 5,
	stats = {
		weight = { min = 1, max = 1 },
		length = { min = 1, max = 1 },
	},
	environments = {
		soup = 2,
		chocolate_river = 2,
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = { card.ability.extra.skip_tags },
		}
	end,
	can_use = function(self, card)
		return true
	end,
	use = function(self, card)
		-- TODO: squeeze sound
		-- play_sound("fac_sprat_can_opening")
		card:juice_up(0.3, 0.4)
		card.states.drag.is = true
		card.children.center.pinch.y = true
		for i = 1, card.ability.extra.skip_tags do
			local tag_pool = get_current_pool("Tag")
			local selected_tag = pseudorandom_element(tag_pool, "fac_lemon_fish")
			local it = 1
			while selected_tag == "UNAVAILABLE" do
				it = it + 1
				selected_tag = pseudorandom_element(tag_pool, "fac_lemon_fish_resample" .. it)
			end
			add_tag(Tag(selected_tag, false, "Small"))
		end
	end,
})
