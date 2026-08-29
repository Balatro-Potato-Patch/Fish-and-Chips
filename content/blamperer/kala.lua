local name = function(fish)
    return localize { type = "name_text", set = "fac_Fish", key = fish.config.center_key }
end

local is_one_word = function(fish)
    for char in name(fish):gmatch('.') do
        if char == ' ' then return false end
    end
    return true
end

local one_word_count = function()
    local c = 0
    for _, fish in pairs(G.fac_fish_area.cards) do
        c = c + (is_one_word(fish) and 1 or 0)
    end
    return c
end

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
            slot_mult = 0.5
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
        local one_word_fish = G.fac_fish_area and one_word_count() or 0
        return { vars = { card.ability.extra.slot_mult, 1 + (one_word_fish * card.ability.extra.slot_mult) } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return { xmult = 1 + (one_word_count() * card.ability.extra.slot_mult) }
        end
    end
}
