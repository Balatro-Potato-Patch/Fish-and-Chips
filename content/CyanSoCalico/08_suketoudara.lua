FishAndChips.Fish {
	key = "csc_suketoudara",
	atlas = "csc_suke",
	pos = { x = 0, y = 0 },
	badge_key = "k_fac_maybe_fish",

	ppu_coder = { "CyanSoCalico" },
	ppu_artist = { "CyanSoCalico" },

	attributes = { "usable", "suit", "destroy_card" },
	config = {
		extra = {
			destroy = 4
		}
	},

	stats = {
		weight = {
			min = 88,
			max = 198
		},
		length = {
			min = 1.52,
			max = 2.28
		}
	},

    weight = 10,
	environments = {
		calm_pond = 10,
		wormhole = 5,
		backroom = 1
	},

	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.destroy } }
	end,

	blueprint_compat = false,
	eternal_compat = false,
	requires_hand = true,

	-- Code based on get_flush() in misc_functions.lua
	can_use = function(self, card)
		if not (G.hand and G.hand.highlighted and #G.hand.highlighted >=4) then return end
		local suits = SMODS.Suit.obj_buffer
		local counts = {}
		for i = 1, #suits do
			local suit = suits[i]
			for j = 1, #G.hand.highlighted do
				if G.hand.highlighted[j]:is_suit(suit, nil, true) then
					counts[suit] = (counts[suit] or 0) + 1
				end
			end
		end
		local finalcount = 0
		for k, v in pairs(counts) do
			if v > finalcount then
				finalcount = v
			end
		end
		if finalcount >= card.ability.extra.destroy then return true else return false end
	end,
	use = function(self, card)
		if not (G.hand and G.hand.highlighted and #G.hand.highlighted >=4) then return end
		local suits = SMODS.Suit.obj_buffer
		local counts = {}
		for i = 1, #suits do
			local suit = suits[i]
			for j = 1, #G.hand.highlighted do
				if SMODS.is_playing_card(G.hand.highlighted[j]) and G.hand.highlighted[j]:is_suit(suit, nil, true) then
					counts[suit] = (counts[suit] or 0) + 1
				end
			end
		end
		local finalsuit
		local finalcount = 0
		for k, v in pairs(counts) do
			if v > finalcount then
				finalsuit = k
				finalcount = v
			end
		end
		if finalcount >= card.ability.extra.destroy then
			local cards = {}
			for j = 1, #G.hand.highlighted do
				if SMODS.is_playing_card(G.hand.highlighted[j]) and G.hand.highlighted[j]:is_suit(finalsuit, nil, true) then
					cards[#cards+1] = G.hand.highlighted[j]
				end
			end
			SMODS.destroy_cards(cards)
		end
	end,
}
