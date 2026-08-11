FishAndChips.Fish {
    key = "blamperer_shfi",
    atlas = "blamperer_fitch",
    pos = { x = 3, y = 0 },
    ppu_coder = { "blamperer" },
    ppu_artist = { "blamperer" },
    attributes = {
        "swap"
    },
    stats = {
        weight = { min = 2, max = 5.5 },
        length = { min = 0.3, max = 0.8 },
    },
    weight = 3,
    environments = {
        styx = 8,
    },
    blueprint_compat = false,
    calculate = function(self, card, context)
        if context.initial_scoring_step and not context.blueprint then
            return { swap = true }
        end
    end
}
