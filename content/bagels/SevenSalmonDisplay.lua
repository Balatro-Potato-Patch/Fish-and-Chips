SMODS.Atlas {
	key = 'bagels_seven_salmon_display',
	path = 'bagels/seven_salmon_display.png',
	px = 71,
	py = 95,
}

FishAndChips.Fish {
	key = 'bagels_seven_salmon_display',
	atlas = 'bagels_seven_salmon_display',
	ppu_coder = { 'BakersDozenBagels' },
	ppu_artist = { 'BakersDozenBagels' },
	weight = 10,
	environments = { garden = 1, calm_pond = 1, chocolate_river = 0.7 },
	stats = { weight = { min = 218, max = 427 }, length = { min = 5.2, max = 10.5 } },
	attributes = { 'xmult' },
	config = { extra = { xmult = 3, cards = 1 } },
	loc_vars = function(_, _, card)
		return {
			vars = {
				card.ability.extra.xmult,
				card.ability.extra.cards,
			},
		}
	end,
	add_to_deck = function(_, card, from_debuff)
		if not from_debuff then
			card.ability.extra.cards = pseudorandom('fac_fish_bagels_seven_salmon_display', 1, 5)
		end
	end,
	calculate = function(_, card, context)
		if context.end_of_round and not context.repetition then
			card.ability.extra.cards = pseudorandom('fac_fish_bagels_seven_salmon_display', 1, 5)
			return { message = localize "k_reset", colour = G.C.RED, message_card = card }
		end

		if context.joker_main and #context.scoring_hand == card.ability.extra.cards then
			return {
				x_mult = card.ability.extra.xmult,
			}
		end
	end,
}

if Balatest then
	-- No time lmao
end
