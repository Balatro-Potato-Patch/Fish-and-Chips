FishAndChips.Fish {
    key = 'gappieyouh_balloon',
    atlas = 'gy_fish',
    weight = 10,
    pos = {x=3,y=0},
    ppu_coder = { 'Youh' },
    ppu_artist = { 'Gappie' },
    attributes = { 'chips', 'on_sell', "scaling", },
    stats = {
        weight = {min = 0.01, max = 0.02},
        length = {min = 0.3, max = 0.6}
    },
    environments = {
        swamp = 3.33,
        soup = 3.33,
        wormhole = 3.33
    },
    perishable_compat = false,
    config = {
        extra = {
            chips = 0,
            chips_mod = 10
        }
    },
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.chips, card.ability.extra.chips_mod}}
    end,
    calculate = function(self, card, context)
        if not context.blueprint and (context.fac_use_fish or (context.selling_card and context.card.ability.set == 'fac_Fish' and context.card ~= card)) then
            -- card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chips_mod
            SMODS.scale_card(card, {
                ref_value = "chips",
                scalar_value = "chips_mod",
                message_colour = G.C.CHIPS,
            })
            return nil, true
            -- return {message = 'Upgrade!', colour = G.C.CHIPS}
        end
        if context.joker_main then return {chips = card.ability.extra.chips} end
    end
}
