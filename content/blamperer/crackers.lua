FishAndChips.Fish {
    key = "blamperer_crackers",
    atlas = "blamperer_fitch",
    pos = { x = 7, y = 0 },
    ppu_coder = { "blamperer" },
    ppu_artist = { "blamperer" },
    attributes = {
        "mult", "food", "scaling"
    },
    config = {
        extra = {
            cards_left = 20
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = { card.ability.extra.cards_left }
        }
    end,
    stats = {
        weight = { min = 0.003, max = 0.0155 },
        length = { min = 0.045, max = .127 },
    },
    weight = 10,
    environments = {
        soup = 1
    },
    badge_key = "k_fac_maybe_fish",
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            local mult = #context.full_hand
            SMODS.scale_card(card, {
                ref_table = card.ability.extra,
                ref_value = "cards_left",
                operation = '-',
                no_message = true
            })
            if card.ability.extra.cards_left <= 0 then
                SMODS.destroy_cards(card, { pinch_anim = true })
            end

            return { mult = mult }
        end
    end
}
