FishAndChips.Fish {
	key = "pa_chocolate",
	weight = 5,
	atlas = "pa_pulsarfish",
	pos = { x = 4, y = 1 },
	ppu_artist = { "Pulsar" },
	ppu_coder = { "Pulsar" },
	attributes = { "chips", 'usable', 'food', "perma_bonus", "modify_card" },
	environments = {
		chocolate_river = 1
	},
	impulse_min = 0.6,
	impulse_max = 0.7, -- distance per impulse
	decision_min = 2,
	decision_max = 3, -- time in seconds
	vel_limit = 2, -- speed limit
	stats = {
		length = { min = 0.25, max = .50},  --vaugely similar to hershey's bar but longer
		weight = { min = 0.075, max = 0.150}
	},
    requires_hand = true,
	blueprint_compat = false,
	config = {
		extra = {
			chips = 15,
		}
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.chips } }
	end,
    use = function(self, card)
        for k, v in ipairs(G.hand.cards) do
                v.ability.perma_bonus = v.ability.perma_bonus or 0
		        v.ability.perma_bonus = v.ability.perma_bonus + card.ability.extra.chips
                G.E_MANAGER:add_event(Event({
                    func = function()
                        play_sound("tarot1")
                        v:juice_up()
                        return true

                    end
                    }))
             end
    end,
	can_use = function(self, card)
        if G.hand and G.hand.cards and #G.hand.cards > 0 then
                return true
        else
            return false
        end
    end
}
