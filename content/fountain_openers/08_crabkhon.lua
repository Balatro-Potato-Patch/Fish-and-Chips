local crabkhon_scale = FishAndChips.mod.config.shrink_sprites and 0.4 or 0.55

FishAndChips.Fish {
	key = "fo_crabkhon",
	atlas = "fo_crabkhon",
	pos = { x = 0, y = 0 },
	display_size = { w = 234 * crabkhon_scale, h = 240 * crabkhon_scale },
    pixel_size = { w = 234, h = 240 },
	weight = 12,
	blueprint_compat = false,
	ppu_coder = { "fo_alexi" },
	ppu_artist = { "fo_grahkon" },
	attributes = { "reset", "passive", "reroll", "economy" },
	config = {
		extra = {
			rerolls = 5,
            remaining = 5,
            old_remaining = 5,
		},
	},
    cost = 2,
	environments = {
		pier = 1,
		volcano = 1,
		styx = 1,
	},
	stats = {
		weight = {min = 30, max = 180},
		length = {min = 0.5, max = 3},
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.rerolls, card.ability.extra.remaining } }
	end,
	calculate = function(self, card, context)
		if not context.blueprint then
			if context.starting_shop then
				card.ability.extra.old_remaining = card.ability.extra.remaining
			end

			if context.ending_shop then
				SMODS.change_free_rerolls(card.ability.extra.remaining - card.ability.extra.old_remaining)
			end

			if context.ante_change and context.ante_end then
				local mod = card.ability.extra.rerolls - card.ability.extra.remaining
				card.ability.extra.remaining = card.ability.extra.rerolls
				SMODS.change_free_rerolls(mod)

				return {
					message = localize("k_reset")
				}
			end
		end
	end,
    add_to_deck = function(self, card, from_debuff)
        SMODS.change_free_rerolls(card.ability.extra.remaining)
    end,
    remove_from_deck = function(self, card, from_debuff)
        SMODS.change_free_rerolls(-card.ability.extra.remaining)
    end,
	set_card_type_badge = function(self, card, badges)
		badges[#badges + 1] = create_badge(localize("k_fac_fo_crab"), FishAndChips.C.FISH, G.C.WHITE, 1.2)
	end,
}