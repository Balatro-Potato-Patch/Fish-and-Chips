SMODS.Attribute {
    key = "fac_fish_slot",
    alias = { "fish_slot" }
}

FishAndChips.Fish {
    key = "blamperer_kala",
    atlas = "fitch",
    pos = { x = 0, y = 0 },
    ppu_coder = { "blamperer" },
    ppu_artist = { "blamperer" },
    attributes = {
        "xmult", "fac_fish_slot"
    },
    config = {
        extra = {
            slot_mult = 0.25
        }
    },
    weight = 7,
    environments = {
        calm_pond = 10,
        pier = 2.5
    },
    loc_vars = function(self, info_queue, card)
        local fish_slots_open = math.max(G.fac_fish_area and (G.fac_fish_area.config.card_limit - #G.fac_fish_area.cards) or 0, 0)
        local total_mult = 1 + (fish_slots_open * card.ability.extra.slot_mult)
        return { vars = { card.ability.extra.slot_mult, total_mult } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            local fish_slots_open = math.max(G.fac_fish_area and (G.fac_fish_area.config.card_limit - #G.fac_fish_area.cards) or 0, 0)
            return {
                xmult = 1 + (fish_slots_open * card.ability.extra.slot_mult)
            }
        end
    end
}
