do return end

local row = nil
local atlas, pos = PotatoPatchUtils.Developers.fac_minty:get_lineboil_atlas_info(row)
--[[
    update = function (self, card, dt)
        PotatoPatchUtils.Developers.fac_minty:set_line_boil(self, card, row)
    end,
]]

FishAndChips.Fish{
    key = "minty_FISH",
    atlas = atlas,
    pos = pos,
    weight = 3,
    ppu_coder = {"minty"},
    ppu_artist = {"whomstever"},
    environments = { --Maximum 6
        --[[
        calm_pond = 10,
        chocolate_river = 10,
        styx = 10,
        pier = 10,
        swamp = 10,
        aquifer = 10,
        volcano = 10,
        city_river = 10,
        soup = 10,
        garden = 10,
        backroom = 10,
        wormhole = 10,
        --]]
    },
    attributes = {

    },
    stats = {
        weight = { min = 1, max = 1}, --In kilograms
        length = { min = 1, max = 2}, --In meters
    },
}