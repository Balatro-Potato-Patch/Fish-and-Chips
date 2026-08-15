FishAndChips.Fish {
	key = "pa_shellphone",
	weight = 4,
	atlas = "pa_pulsarfish",
	pos = { x = 5, y = 1 },
	ppu_artist = { "Pulsar" },
	ppu_coder = { "Axy" },
	attributes = { "economy", "rank", "scaling", "sell_value", },
	environments = {
		city_river = 0.5,
		pier = 1,
		backroom = 0.3,
	},
	stats = {
		length = {min = 0.12, max = 0.12},  --vaugely based on actual phone + measurements of a shell i have
		weight = {min = 0.125, max = 0.125}
	},
	blueprint_compat = false,
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
		if card.config and card.config.center and card.config.center.set == "fac_Fish" and card.area and (card.area.config.collection or card.area.config.fac_compendium) then
			card.ability.extra.sequence = {}
			card.ability.extra.sell_value_increase = pseudorandom(pseudoseed(self.key), card.ability.extra.sequence_min, card.ability.extra.sequence_max)
			card.ability.extra.current_position = 1
			for i=1,card.ability.extra.sell_value_increase do
				table.insert(card.ability.extra.sequence, ('Ace'))
			end
		end

		local ranks = {colours = {}, #card.ability.extra.sequence}
		for i=1,card.ability.extra.sequence_max do
			ranks.colours[#ranks.colours+1] = (card.ability.extra.current_position > i and FishAndChips.C.SAND_DOLLAR or G.C.UI.TEXT_DARK)
			ranks[#ranks+1] = SMODS.Ranks[card.ability.extra.sequence[i]] or {card_key = '', key = ''}

			local display_value = ranks[#ranks].key
			for k,i in pairs({'Ace', 'King', 'Queen', 'Jack'}) do
				if display_value == i then
					display_value = ranks[#ranks].card_key
					break
				end
			end
			ranks[#ranks] = (i >= #card.ability.extra.sequence and (display_value) or (display_value .. ', '))
		end
		return { vars = ranks }
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play then
			for k,v in ipairs(context.scoring_hand) do
				local target = card.ability.extra.sequence and #card.ability.extra.sequence >= card.ability.extra.current_position and SMODS.Ranks[card.ability.extra.sequence[card.ability.extra.current_position]].sort_id + 1 or nil
				local matched_position =  v:get_id() == target
				if matched_position then
					card.ability.extra.current_position = card.ability.extra.current_position + 1
				end
			end
		end

		if context.joker_main and not context.blueprint then
			if card.ability.extra.current_position > #card.ability.extra.sequence then -- sequence is complete
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
					table.insert(card.ability.extra.sequence, (pseudorandom_element(SMODS.Ranks, pseudoseed(self.key)).key))
				end
				return {message = localize('k_val_up'), colour = G.C.MONEY}
			end
		end
	end,
	add_to_deck = function(self, card, from_debuff)
		card.ability.extra.sell_value_increase = pseudorandom(pseudoseed(self.key), card.ability.extra.sequence_min, card.ability.extra.sequence_max)
		card.ability.extra.current_position = 1
		for i=1,card.ability.extra.sell_value_increase do
			table.insert(card.ability.extra.sequence, (pseudorandom_element(SMODS.Ranks, pseudoseed(self.key)).key))
		end
	end,
}
