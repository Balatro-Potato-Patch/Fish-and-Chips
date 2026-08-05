FishAndChips.Fish {
    key = "blamperer_autotuna",
    atlas = "fitch",
    pos = { x = 8, y = 0 },
    ppu_coder = { "blamperer" },
    ppu_artist = { "blamperer" },
    attributes = {
        "passive"
    },
    stats = {
        weight = { min = 4, max = 34.5 },
        length = { min = 0.5, max = 1.08 },
    },
    weight = 5,
    environments = {},
    treasure = true,
    blueprint_compat = false,
    in_pool = function (self, args)
        return G.fac_rod_area and G.fac_rod_area.cards[1] and G.fac_rod_area.cards[1].config.center.key ~= "rod_fac_harpoon"
    end
    -- BALANCE: All Autotuna functionality is in _common.lua; Change AUTOFACTOR to affect speed of passive gain
}