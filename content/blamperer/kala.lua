FishAndChips.Fish {
    key = "blamperer_kala",
    atlas = "blamperer_fitch",
    pos = { x = 0, y = 0 },
    ppu_coder = { "blamperer" },
    ppu_artist = { "blamperer" },
    attributes = {
        "xmult", "fac_fish_slot"
    },
    config = {
        extra = {
            -- BALANCE: Balanced around otherwise empty bucket = 2X (1/5 slots filled)
            slot_mult = 0.25
        }
    },
    stats = {
        weight = { min = 0.003, max = 0.03 },
        length = { min = 0.006, max = 0.06 },
    },
    weight = 7,
    environments = {
        calm_pond = 5,
        garden = 10
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
