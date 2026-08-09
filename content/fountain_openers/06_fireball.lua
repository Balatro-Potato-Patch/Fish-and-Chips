FishAndChips.Fish {
	key = "fo_fireball",
	atlas = "fo_fish",
	pos = { x = 5, y = 0 },
	weight = 5,
	ppu_coder = { "fo_alexi" },
	ppu_artist = { "fo_grahkon" },
	attributes = { "xmult", "usable" },
    disable_visual_scaling = true,
	config = {
        extra = {
            xmult = 3,
        }
	},
	environments = {
		volcano = 1,
        calm_pond = 1,
	},
    stats = {
        weight = {min = 0.015, max = 0.03},
		length = {min = 3 * 2.25, max = 3 * 2.251},
	},
    loc_vars = function(self, info_queue, card)
		return { vars = {
            card.ability.extra.xmult,
        }}
	end,
	calculate = function(self, card, context)
        if context.final_scoring_step and card.ability.extra.active then
            G.E_MANAGER:add_event(Event({
                func = function()
                    SMODS.destroy_cards(card)
                    return true
                end
            }))
            return {
                xmult = card.ability.extra.xmult
            }
        end
    end,
    use = function(self, card, area)
        card.ability.extra.active = true
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('tarot1')
                card:juice_up(0.3, 0.5)
                return true
            end
        }))
    end,
    can_use = function(self, card)
        return not card.ability.extra.active
    end,
    keep_on_use = function(self, card)
        return true
    end
}