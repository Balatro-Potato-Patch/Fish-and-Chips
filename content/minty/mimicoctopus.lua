local row = 4
local atlas, pos = PotatoPatchUtils.Developers.fac_minty:get_lineboil_atlas_info(row)

FishAndChips.Fish{
    key = "minty_mimic_octopus",
    atlas = atlas,
    pos = pos,
    weight = 1,
    ppu_coder = {"minty"},
    ppu_artist = {"minty"},
    environments = { --Maximum 6
        pier = 10,
        backroom = 10,
        wormhole = 10,
        volcano = 10,
        garden = 10,
        --[[
        calm_pond = 10,
        chocolate_river = 10,
        styx = 10,
        swamp = 10,
        aquifer = 10,
        city_river = 10,
        soup = 10,
        --]]
    },
    attributes = {
        "copying", "usable"
    },
    config = {
        extra = {
            target_val = nil,
            target_name = localize("k_none"),
            copying = false
        }
    },
    stats = {
        weight = { min = 1, max = 1}, --In kilograms
        length = { min = 1, max = 2}, --In meters
    },
    update = function (self, card, dt)
        PotatoPatchUtils.Developers.fac_minty:set_line_boil(self, card, row)
    end,
    can_use = function (self, card)
        if card.ability.extra.copying then return false end
        local mypos
        for i,v in ipairs(G.fac_fish_area.cards) do
            if v == card then
                mypos = i
                break
            end
        end
        if mypos == #G.fac_fish_area.cards or not mypos then return false end

        if G.fac_fish_area.cards[mypos+1].config.center.blueprint_compat == false then return false end
        return true
    end,
    use = function (self, card)
        local mypos
        for i,v in ipairs(G.fac_fish_area.cards) do
            if v == card then
                mypos = i
                break
            end
        end

        local target_card = G.fac_fish_area.cards[mypos+1]
        if not target_card or target_card.config.center.blueprint_compat == false then --Shouldn't happen, but
            SMODS.calculate_effect{message = localize("k_nope_ex"), card = card}
            return
        end

        card.ability.extra.copying = true
        card.ability.extra.target_val = target.unique_val
        local target_key = target.config.center.key
        local target_vars = G.P_CENTERS[target_key].loc_vars and (G.P_CENTERS[target_key]:loc_vars({}, target_card) or {}).vars or {}
        card.ability.extra.target_name = localize{type = "name_text", key = target.config.center.key, vars = target_vars}

        SMODS.calculate_effect{message = localize("k_copied_ex"), card = card}
    end,
    calculate = function (self, card, context)
        if not card.ability.extra.target_val then return nil end

        local target_card
        for i,v in ipairs(G.fac_fish_area.cards) do
            if v.unique_val == card.ability.extra.target_val then
                target_card = v
                break
            end
        end

        local ret = SMODS.blueprint_effect(card, target_card, context) or {}

        if context.end_of_round and context.main_eval and not context.blueprint then
            local reset = {
                func = function ()
                    G.E_MANAGER:add_event(Event{
                        func = function ()
                            card.ability.extra.copying = false
                            card.ability.extra.target_val = false
                            card.ability.extra.target_name = "None"
                            return true
                        end
                    })
                end,
                message = localize("k_reset")
            }

            ret = SMODS.merge_effects(ret, reset)
        end

        return next(ret) and ret or nil
    end,
}