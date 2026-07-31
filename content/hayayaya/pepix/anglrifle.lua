FishAndChips.Fish({
	key = "anglrifle",
	weight = 10,
	environments = {
		chocolate_river = 0.5,
		styx = 1,
	},
	ppu_coder = { "Ellen (Haya)" },
	ppu_artist = { "Pepix" },
	attributes = {
		"destroy_card",
		"discard",
		"scaling",
		"chips",
	},
	config = { extra = { chips = 0, chips_add = 5, done = false, discard_flush = false } },
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.chips_add,
				card.ability.extra.chips,
				card.ability.extra.done and localize("ph_facyou_hayayaya_active")
					or localize("ph_facyou_hayayaya_inactive"),
			},
		}
	end,
	calculate = function(self, card, context)
		if context.pre_discard and not card.ability.extra.done then
			G.E_MANAGER:add_event(Event({
				func = function()
					card.ability.extra.done = true
					return true
				end,
			}))
		end

		-- TODO: Make each card disappear one by one?
		if context.discard and not card.ability.extra.done then
			SMODS.destroy_cards(context.other_card, {
				immediate = true,
				destroy_func = function(destroy_card, args)
					if destroy_card.shattered then
						destroy_card:shatter()
					else
						destroy_card:start_dissolve()
					end
					card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chips_add
					SMODS.calculate_effect({ message = localize("k_upgrade_ex") }, card)
				end,
			})
		end

		-- Genuinely, for some reason they still exist in the discard pile
		-- We already know the actual moveable is deleted now, so just clear the table manually
		if context.hand_drawn and card.ability.extra.done and not card.ability.extra.discard_flush then
			G.E_MANAGER:add_event(Event({
				func = function()
					G.discard.cards = {}
					card.ability.extra.done = true
					return true
				end,
			}))
			card.ability.extra.discard_flush = true
		end

		if context.end_of_round and context.main_eval then
			card.ability.extra.done = false
			card.ability.extra.discard_flush = false
		end

		if context.joker_main then
			return {
				chips = card.ability.extra.chips,
			}
		end
	end,
})
