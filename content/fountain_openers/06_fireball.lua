FishAndChips.Fish {
	key = "fo_fireball",
	atlas = "fo_fish",
	pos = { x = 4, y = 0 },
	weight = 11,
	ppu_coder = { "fo_alexi" },
	ppu_artist = { "fo_grahkon" },
	attributes = { "xmult", "usable", "food", },
    disable_visual_scaling = true,
	config = {
        extra = {
            xmult = 3,
        }
	},
	environments = {
		volcano = 1,
        calm_pond = 0.25,
        city_river = 1,
        soup = 0.25,
	},
    stats = {
        weight = {min = 0.015, max = 0.03},
		length = {min = 3 * 2.25, max = 3 * 2.251},
	},
    cost = 2,
    impulse_max = 1.35,
    impulse_min = 0.55,
    decision_max = 0.75,
    decision_min = 0.4,
    vel_limit = 0.75,
    colour = G.C.RED,
    loc_vars = function(self, info_queue, card)
        local active_str = card.ability.extra.active and "used" or "usable"
        return {
            vars = {
                card.ability.extra.xmult,
                elements = {
                    {n=G.UIT.C, config = {padding = 0.05}, nodes = {
                        {n=G.UIT.C, config={align = "m", colour = PotatoPatchUtils.Bubble_Colours[active_str] or G.C.RED, r = 0.05, padding = 0.06, res = 0.45}, nodes={
                            {n=G.UIT.T, config={text = localize('ppu_bubble_' .. active_str), colour = G.C.UI.TEXT_LIGHT, scale = 0.24}},
                        }}
                    }}
                },
            }
        }
	end,
	calculate = function(self, card, context)
        if context.final_scoring_step and card.ability.extra.active then
            G.E_MANAGER:add_event(Event({
                func = function()
                    SMODS.calculate_effect({
                        message = localize("k_drank_ex")
                    }, card)
                    SMODS.destroy_cards(card, {
                        bypass_eternal = true,
                        pinch_anim = true
                    })
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
                local eval = function(card) return not card.ability.extra.active and not G.RESET_JIGGLES end
                juice_card_until(card, eval, true)
                return true
            end
        }))
    end,
    can_use = function(self, card)
        return not card.ability.extra.active
    end,
    update = function(self, card, dt)
        card.prev_active = card.prev_active or false
        if card.ability.extra.active ~= card.prev_active then
            card.children.center:set_sprite_pos{ x = card.ability.extra.active and 5 or 4, y = 0 }
        end

        card.prev_active = card.ability.extra.active
    end,
    keep_on_use = function(self, card)
        return true
    end,
    set_card_type_badge = function(self, card, badges)
		badges[#badges + 1] = create_badge(localize("k_fac_fo_vodka"), FishAndChips.C.FISH, G.C.WHITE, 1.2)
	end,
}
