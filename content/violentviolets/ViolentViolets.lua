PotatoPatchUtils.Team {
    name = "Violent Violets",
    colour = HEX("450061"),
    loc = "Violent Violets",
    short_credit = true
}
PotatoPatchUtils.Developer({
	name = 'FireIce',
	atlas = 'fac_cards',
	pos = {x = 1, y = 0},
	colour = G.C.PURPLE,
	fac_partner = 'Willow'
})
PotatoPatchUtils.Developer({
	name = 'Willow',
	atlas = 'fac_cards',
	pos = {x = 1, y = 0},
	colour = G.C.GREEN,
	fac_partner = 'FireIce'
})
SMODS.Sound {
    key = "vv_ominous",
    path = "violentviolets/ominous.ogg",
    volume = 0.5,
    pitch = 1
}

FishAndChips.Fish {
    key = "vv_vesselfish",
    weight = 1,
    ppu_coder = { "FireIce" },
    ppu_artist = { "Willow" },
    attributes = { "passive" },
    environments = {
        wormhole = 0.05,
        styx = 0.1
    },
    cost = 1,
    config = { extra = { e_blind = 1.05 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.e_blind } }
    end,
    calculate = function(self, card, context)
        if context.setting_blind then
            G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function()
                    G.GAME.blind.chips = math.floor(G.GAME.blind.chips ^ card.ability.extra.e_blind)
                    G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)

                    local chips_UI = G.hand_text_area.blind_chips
                    G.FUNCS.blind_chip_UI_scale(G.hand_text_area.blind_chips)
                    G.HUD_blind:recalculate()
                    chips_UI:juice_up()

                    play_sound('fac_vv_ominous')
                return true end }))
        end
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
