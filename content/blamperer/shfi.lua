FishAndChips.Fish {
    key = "blamperer_shfi",
    atlas = "fitch",
    pos = { x = 3, y = 0 },
    ppu_coder = { "blamperer" },
    ppu_artist = { "blamperer" },
    attributes = {
        "swap"
    },
    weight = 3,
    environments = {
        styx = 8,
    },
    calculate = function(self, card, context)
        if context.initial_scoring_step then
            return { swap = true }
        end
    end
}
