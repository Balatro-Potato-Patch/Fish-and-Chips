SMODS.Atlas({
	key = "sg11_n_vekhi_transcendent",
	path = "sg11_n_vekhi/transcendent.png",
	px = 71,
	py = 95,
	atlas_table = "ANIMATION_ATLAS",
	frames = 14,
})

FishAndChips.Fish({
	key = "sg11_n_vekhi_transcendent",
	atlas = "fac_sg11_n_vekhi_transcendent",
	pos = { x = 0, y = 0 },
	ppu_coder = { "sleepyg11" },
	ppu_artist = { "vevekhi" },
	attributes = { "mult", "face_down", "full_deck", }, -- In practice this just ends up being a blue joker sidegrade right ? (mf)
	config = {
		extra = {
			mult = 0.5,
		},
	},
	weight = 3,
	stats = {
		weight = { min = 0, max = 0 },
		length = { min = 0, max = 0 },
	},
	environments = {
		backroom = 1,
		wormhole = 1,
	},
	loc_vars = function(self, info_queue, card)
		local face_down_cards = 0
		for _, _card in ipairs(G.I.CARD) do
			if _card.facing == "back" and _card.area ~= G.discard then
				face_down_cards = face_down_cards + 1
			end
		end
		return {
			vars = { SMODS.signed(card.ability.extra.mult), SMODS.signed(face_down_cards * card.ability.extra.mult) },
		}
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			local face_down_cards = 0
			for _, _card in ipairs(G.I.CARD) do
				if _card.facing == "back" and _card.area ~= G.discard then
					face_down_cards = face_down_cards + 1
				end
			end
			return {
				mult = face_down_cards * card.ability.extra.mult,
			}
		end
	end,
})
