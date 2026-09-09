local row = 1
local atlas, pos = PotatoPatchUtils.Developers.fac_minty:get_lineboil_atlas_info(row)

FishAndChips.Fish{
    key = "minty_catfish",
    atlas = atlas,
    pos = pos,
    weight = 3,
    ppu_coder = {"minty"},
    ppu_artist = {"minty"},
    blueprint_compat = false,
    environments = { --Maximum 6
        calm_pond = 10,
        city_river = 10,
        chocolate_river = 1,
        soup = 1,
    },
    attributes = {
        "passive", "mod_chance"
    },
    stats = {
        weight = { min = 0.9, max = 18.3}, --In kilograms
        length = { min = 0.3, max = 2}, --In meters
    },
    config = {
        extra = {
            oddshelp = 2
        },
    },
    loc_vars = function (self, info_queue, card)
        return {
            vars = {
                -card.ability.extra.oddshelp,
                math.max(5 - card.ability.extra.oddshelp, 1)
            }
        }
    end,
    update = function (self, card, dt)
        PotatoPatchUtils.Developers.fac_minty:set_line_boil(self, card, row)
    end,
    calculate = function (self, card, context)
        if context.mod_probability and not context.blueprint and not context.retrigger_joker then
            return {
                denominator = math.max(context.denominator - card.ability.extra.oddshelp, 1)
            }
        end
    end,
}