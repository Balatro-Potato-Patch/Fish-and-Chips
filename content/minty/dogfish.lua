local row = 6
local atlas, pos = PotatoPatchUtils.Developers.fac_minty:get_lineboil_atlas_info(row)

FishAndChips.Fish{
    key = "minty_dogfish",
    atlas = atlas,
    pos = pos,
    weight = 3,
    ppu_coder = {"minty"},
    ppu_artist = {"minty"},
    perishable_compat = false,
    environments = { --Maximum 6
        pier = 10,
        city_river = 10,
        aquifer = 10,
        chocolate_river = 1,
    },
    attributes = {
        "destroy_card", "xmult", "scaling", "enhancements",
    },
    stats = {
        weight = { min = 1.2, max = 4.8}, --In kilograms
        length = { min = 0.47, max = 0.92}, --In meters
    },
    config = {
        extra = {
            xmult = 1,
            xmult_gain = 0.25
        }
    },
    loc_vars = function (self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_lucky
        return {
            vars = {
                card.ability.extra.xmult,
                card.ability.extra.xmult_gain
            }
        }
    end,
    update = function (self, card, dt)
        PotatoPatchUtils.Developers.fac_minty:set_line_boil(self, card, row)
    end,
    calculate = function (self, card, context)
        if context.individual and SMODS.has_enhancement(context.other_card, "m_lucky") and not context.blueprint and not context.retrigger_joker then
            context.other_card.nommed_by_dogfish = true
        end

        if context.destroy_card and context.destroy_card.nommed_by_dogfish and not context.blueprint then
            context.destroy_card.nommed_by_dogfish = nil
            SMODS.scale_card(card, {
                ref_table = card.ability.extra,
                ref_value = "xmult",
                scalar_value = "xmult_gain"
            })
            return {
                remove = true
            }
        end

        if context.joker_main then
            return {
                xmult = card.ability.extra.xmult
            }
        end
    end,
}
