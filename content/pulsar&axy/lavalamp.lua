FishAndChips.Fish {
	key = "pa_lavalamp",
	weight = 4,
	atlas = "pa_pulsarfish",
	pos = { x = 4, y = 2 },
	ppu_artist = { "Pulsar" },
	ppu_coder = { "Pulsar" },
	attributes = { "editions", 'usable', "hands", "modify_card", },
	environments = {
		volcano = 1,
	},
	stats = {
		length = { min = .25, max = .65},  --vibes based
		weight = { min = 2, max = 10}
	},
    requires_hand = true,
	blueprint_compat = false,
	config = {
        max_highlighted = 1
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.max_highlighted } }
	end,
    use = function(self, card)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                local edition = SMODS.poll_edition { key = self.key, guaranteed = true, no_negative = true }
                local aura_card = G.hand.highlighted[1]
                aura_card:set_edition(edition, true)
                card:juice_up(0.3, 0.5)
                return true
            end
        }))
    end,
	can_use = function(self, card)
        return SMODS.last_hand_oneshot and G.hand and #G.hand.highlighted <= card.ability.max_highlighted and #G.hand.highlighted > 0
    end
}
