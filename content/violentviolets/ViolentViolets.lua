PotatoPatchUtils.Developer({
	name = 'FireIce',
	atlas = 'fac_cards',
	pos = {x = 1, y = 0},
	colour = G.C.PURPLE,
	fac_partner = 'Willow',
    team = 'ViolentViolets'
})
PotatoPatchUtils.Developer({
	name = 'Willow',
	atlas = 'fac_cards',
	pos = {x = 1, y = 0},
	colour = G.C.GREEN,
	fac_partner = 'FireIce',
    team = 'ViolentViolets'
})

SMODS.Attribute {
    key = 'blindsize',
    keys = { 'fish_fac_vv_fireicefish'}
}

FishAndChips.Fish {
    key = "vv_fireicefish",
    weight = 1,
    ppu_coder = { "FireIce" },
    ppu_artist = { "Willow" },
    attributes = { "passive", "blindsize" },
    environments = { wormhole = 0.05 },
    cost = 1,
    config = { extra = { x_blind = 0.9 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.x_blind } }
    end,
    calculate = function(self, card, context)
        if context.setting_blind and G.GAME.round_resets.ante ~= 8 then
            G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function()
                    G.GAME.blind.chips = math.floor(G.GAME.blind.chips * card.ability.extra.x_blind)
                    G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)

                    local chips_UI = G.hand_text_area.blind_chips
                    G.FUNCS.blind_chip_UI_scale(G.hand_text_area.blind_chips)
                    G.HUD_blind:recalculate()
                    chips_UI:juice_up()
                return true end }))
        end
    end,
    remove_from_deck =  function(self, card, from_debuff)
        play_sound('fac_vv_ominouscancel')
    end
}
FishAndChips.Fish {
    key = "vv_size2",
    weight = 1,
    ppu_coder = { "FireIce" },
    ppu_artist = { "Willow" },
    attributes = {  },
    environments = { wormhole = 0.01, styx = 0.005 },
    cost = 1,
    config = { extra = {  } },
    loc_vars = function(self, info_queue, card)
        return { vars = {  } }
    end,
    calculate = function(self, card, context)

    end
}

local oldcardsetsellvalue = Card.set_sell_value
function Card:set_sell_value()
    local g = oldcardsetsellvalue(self)
    if self.config.center.key == 'fish_fac_vv_vesselfish' then
        self.sell_cost = -1
    end
    return g
end
