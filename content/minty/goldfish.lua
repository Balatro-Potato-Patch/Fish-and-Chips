local row = 0
local atlas, pos = PotatoPatchUtils.Developers.fac_minty:get_lineboil_atlas_info(row)

FishAndChips.Fish{
    key = "minty_goldfish",
    atlas = atlas,
    pos = pos,
    weight = 1,
    ppu_coder = {"minty"},
    ppu_artist = {"minty"},
    environments = { --Maximum 6
        calm_pond = 10,
        city_river = 10,
        chocolate_river = 1,
        swamp = 5,
        backroom = 3,
        --[[
        styx = 10,
        pier = 10,
        aquifer = 10,
        volcano = 10,
        soup = 10,
        garden = 10,
        wormhole = 10,
        --]]
    },
    attributes = {
        "economy"
    },
    stats = {
        weight = { min = 0.05, max = 0.2},
        length = { min = 0.02, max = 0.08}
    },
    config = {
        extra_value = 0,
        extra = {
            value_gain = 1
        }
    },
    loc_vars = function (self, info_queue, card)
        return {
            vars = {
                card.ability.extra.value_gain
            }
        }
    end,
    update = function (self, card, dt)
        PotatoPatchUtils.Developers.fac_minty:set_line_boil(self, card, row)
    end,
    calculate = function (self, card, context)
        if (context.money_altered or context.sand_dollars_altered) and context.amount > 0 then
            SMODS.scale_card(card, {
                ref_table = card.ability,
                ref_value = "extra_value",
                scalar_table = card.ability.extra,
                scalar_value = "value_gain"
            })

            G.E_MANAGER:add_event(Event{
                func = function ()
                    card:set_cost()
                    return true
                end
            })

            return nil, true
        end
    end,
}