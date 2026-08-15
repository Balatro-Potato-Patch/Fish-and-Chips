local row = 10
local atlas, pos = PotatoPatchUtils.Developers.fac_minty:get_lineboil_atlas_info(row)
PotatoPatchUtils.Developers.fac_minty.fish_named_fish = PotatoPatchUtils.Developers.fac_minty.fish_named_fish or {}

FishAndChips.Fish{
    key = "minty_chaos_salmon",
    atlas = atlas,
    pos = pos,
    weight = 1,
    ppu_coder = {"minty"},
    ppu_artist = {"minty"},
    environments = { --Maximum 6
        chocolate_river = 2,
        styx = 5,
        city_river = 10,
        backroom = 1,
        wormhole = 1,
        --[[
        calm_pond = 10,
        pier = 10,
        swamp = 10,
        aquifer = 10,
        volcano = 10,
        soup = 10,
        garden = 10,
        --]]
    },
    attributes = {
        "xmult", "meta"
    },
    update = function (self, card, dt)
        PotatoPatchUtils.Developers.fac_minty:set_line_boil(self, card, row)
    end,
    stats = {
        weight = { min = 1, max = 1}, --In kilograms
        length = { min = 1, max = 2}, --In meters
    },
    config = {
        extra = {
            xmult = 1.5
        }
    },
    loc_vars = function (self, info_queue, card)
        return {
            vars = {
                card.ability.extra.xmult
            }
        }
    end,
    calculate = function (self, card, context)
        if context.other_main and context.other_main.config.center.set == "fac_Fish" then
            local otherfish = context.other_main
            local othercenter = otherfish.config.center
            local otherkey = othercenter.key
            local othername = othercenter.name ~= otherkey and othercenter.name or ""

            if PotatoPatchUtils.Developers.fac_minty.fish_named_fish[otherkey] then
                return {
                    xmult = {
                        card.ability.extra.xmult
                    }
                }
            end

            for i,v in ipairs{othername, othercenter.original_key, localize{type = "name_text", key = otherkey, set = "fac_Fish"}} do
                print(v)
                if string.find(v:lower(), "fish") then -- TODO: potentially localize "fish"? so that other languages don't get screwed over. That implies the mod will get localized at all though so :shrug: (mf)
                    PotatoPatchUtils.Developers.fac_minty.fish_named_fish[otherkey] = true
                    return {
                        xmult = card.ability.extra.xmult
                    }
                end
            end
        end
    end
}
