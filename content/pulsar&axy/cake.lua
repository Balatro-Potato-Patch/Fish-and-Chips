FishAndChips.Fish {
	key = "pa_cake",
	weight = 5,
	atlas = "pa_pulsarfish",
	pos = { x = 3, y = 2 },
	ppu_artist = { "Pulsar" },
	ppu_coder = { "Pulsar" },
	attributes = { "mult", 'usable' },
	environments = {
		chocolate_river = 1
	},
	stats = {
		length = { min = 0.50, max = 1},  --vibes based
		weight = { min = 5, max = 15}
	},
    requires_hand = true,
	blueprint_compat = true,
	config = {
		extra = {
			mult = 2,
		}
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mult } }
	end,
    use = function(self, card)
        for k, v in ipairs(G.hand.cards) do
                v.ability.perma_mult = v.ability.perma_mult or 0
		        v.ability.perma_mult = v.ability.perma_mult + card.ability.extra.mult
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