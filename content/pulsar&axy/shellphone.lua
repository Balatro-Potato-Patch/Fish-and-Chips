FishAndChips.Fish {
	key = "pa_shellphone",
	weight = 5,
	atlas = "pa_pulsarfish",
	pos = { x = 5, y = 1 },
	ppu_artist = { "Pulsar" },
	ppu_coder = { "Axy" },
	attributes = { "economy", "rank", "scaling" },
	environments = {
		city_river = 0.5,
		pier = 1,
		backroom = 0.3,
	},
	stats = {
		length = {min = 0.012, max = 0.012},  --vaugely based on actual phone + measurements of a shell i have
		weight = {min = 0.125, max = 0.125}
	},
	blueprint_compat = true,
	config = {
		extra = {
			sequence = {},
			sell_value_increase = 0,
			current_position = 1,
			sequence_min = 3,
			sequence_max = 8
		}
	},
	loc_vars = function(self, info_queue, card)
		local ranks = {colours = {}}
		for i=1,card.ability.extra.sequence_max do
			ranks.colours[#ranks.colours+1] = (card.ability.extra.current_position > i and G.C.UI.TEXT_INACTIVE or G.C.UI.TEXT_DARK)
			ranks[#ranks+1] = card.ability.extra.sequence[i] or {card_key = ''}
			ranks[#ranks] = (i >= #card.ability.extra.sequence and (ranks[#ranks].card_key) or (ranks[#ranks].card_key .. ', '))
		end
		return { vars = ranks }
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play then
			for k,v in ipairs(context.scoring_hand) do
				local target = card.ability.extra.sequence and card.ability.extra.sequence[card.ability.extra.current_position].sort_id + 1
				local matched_position =  v:get_id() == target
				if matched_position then
					card.ability.extra.current_position = card.ability.extra.current_position + 1
				end
			end
		end

		if context.joker_main and not context.blueprint then
			if card.ability.extra.current_position >= #card.ability.extra.sequence then -- sequence is complete
				SMODS.scale_card(card, {
					ref_table = card.ability,
					ref_value = "extra_value",
					scalar_table = card.ability.extra,
					scalar_value = "sell_value_increase",
					operation = "+"
				})
				card:set_sell_value()
				card.ability.extra.sequence = {}
				card.ability.extra.current_position = 1

				card.ability.extra.sell_value_increase = pseudorandom(pseudoseed(self.key), card.ability.extra.sequence_min, card.ability.extra.sequence_max)
				for i=1,card.ability.extra.sell_value_increase do
					table.insert(card.ability.extra.sequence, (pseudorandom_element(SMODS.Ranks, pseudoseed(self.key))))
				end
				return {message = localize('k_val_up'), colour = G.C.MONEY}
			end
		end
	end,
	add_to_deck = function(self, card, from_debuff)
		card.ability.extra.sell_value_increase = pseudorandom(pseudoseed(self.key), card.ability.extra.sequence_min, card.ability.extra.sequence_max)
		card.ability.extra.current_position = 1
		for i=1,card.ability.extra.sell_value_increase do
			table.insert(card.ability.extra.sequence, (pseudorandom_element(SMODS.Ranks, pseudoseed(self.key))))
		end
	end,
}