local row = 9
local atlas, pos = PotatoPatchUtils.Developers.fac_minty:get_lineboil_atlas_info(row)

FishAndChips.Fish{
    key = "minty_gem",
    atlas = atlas,
    pos = pos,
    badge_key = "k_fac_maybe_fish",
    weight = 1,
    ppu_coder = {"minty"},
    ppu_artist = {"minty"},
    treasure = true,
    environments = {},
    attributes = {
        "economy"
    },
    stats = {
        weight = { min = 1, max = 200}, --In kilograms
        length = { min = 0.3, max = 25}, --In meters
    },
    on_catch = function (self, card)
        card.ability.extra_value = math.ceil(card.ability.stats.length)
        card:set_cost()
    end,
    update = function (self, card, dt)
        PotatoPatchUtils.Developers.fac_minty:set_line_boil(self, card, row)
    end,
}