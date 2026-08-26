SMODS.Atlas({
	key = "hayayaya_babel",
	path = "hayayaya/babel.png",
	px = 80,
	py = 80,
})

FishAndChips.Fish({
	key = "tower",
	weight = 5,
	environments = {
		garden = 0.6,
		chocolate_river = 1,
	},
	ppu_coder = { "Ellen (Haya)" },
	ppu_artist = { "Pepix" },
	attributes = { "xmult", "suit", },
	atlas = "hayayaya_babel",
	pos = { x = 0, y = 0 },
	stats = {
		length = { min = 1, max = 1 },
		weight = { min = 1, max = 1 },
	},
	pixel_size = { w = 80, h = 80 },
	display_size = { w = 80, h = 80 },
	badge_key = "k_fac_hayayaya_object",
	config = { extra = { xmult = 1 } },
	loc_vars = function(self, info_queue, card)
		return {
			vars = { card.ability.extra.xmult },
		}
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			local best = 0
			local function search(card_index, used_suits, chosen_cards)
				if card_index > #context.scoring_hand then
					local count = 0
					for _ in pairs(used_suits) do
						count = count + 1
					end
					if count > best then
						best = count
					end
					return
				end

				local had_suit = false
				for k, v in pairs(SMODS.Suits) do
					if context.scoring_hand[card_index]:is_suit(k) then
						had_suit = true
						local suit_used = not not used_suits[k]
						used_suits[k] = true

						if not suit_used then
							chosen_cards[#chosen_cards + 1] = card_index
						end

						search(card_index + 1, used_suits, chosen_cards)

						if not suit_used then
							chosen_cards[#chosen_cards] = nil
							used_suits[k] = nil
						end
					end
				end
				if not had_suit then
					search(card_index + 1, used_suits, chosen_cards)
				end
			end
			search(1, {}, {})

			return {
				xmult = math.max(1, best),
			}
		end
	end,
})
