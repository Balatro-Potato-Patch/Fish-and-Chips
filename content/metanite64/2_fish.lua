FishAndChips.Fish {
    key = "yellow_pikman",
    atlas = "meta_fish",
    weight = 10,
    environments = {
        swamp = 10,
        aquifer = 5,
        garden = 7,
        backroom = 2
    },
    attributes = { "chips" },
    ppu_coder = { "metanite64" },

    config = {
        extra = {
            chips = 0,
            chip_gain = 5
        }
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chip_gain, card.ability.extra.chips } }
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            return { chips = card.ability.extra.chips }
        end

        if context.post_trigger and context.other_card.area == G.fac_fish_area then
            local me_index = 0
            local you_index = 0
            for i, v in ipairs(G.fac_fish_area.cards) do
                if v == card then me_index = i end
                if v == context.other_card then you_index = i end
            end
            if me_index > 0 and you_index > 0 and math.abs(me_index - you_index) == 1 then
                return { func = function()
                    SMODS.scale_card(card, {
                        ref_table = card.ability.extra,
                        ref_value = "chips",
                        scalar_value = "chip_gain",
                        message_key = "a_chips",
                        message_colour = G.C.CHIPS
                    })
                end }
            end
        end

        if context.using_consumeable then
            print("fish triggered")
        end
    end
}
