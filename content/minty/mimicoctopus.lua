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
        local center = card.ability.extra.target_key and G.P_CENTERS[card.ability.extra.target_key] or self

        if center.update and center.ppu_coder == self.ppu_coder then
            PotatoPatchUtils.Developers.fac_minty:set_line_boil(center, card, center.pos.y)
        end

        if false --[[current sprite doesn't match card.ability.extra.sprite (how do we check that???)]] then
            card:set_sprites(center)
        end
    end,
    --on_catch = function (self, card) --[[mimic a random other fish from the area?]] end,
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
    load = function (self, card, card_table, other_card)
        G.E_MANAGER:add_event(Event{
            func = function ()
                if not (card.ability and card.ability.extra) or not card.area then return false end

                if card.ability.extra.copying then
                    G.E_MANAGER:add_event(Event{
                        func = function ()
                            local target_card
                            for i,v in ipairs(G.fac_fish_area.cards) do
                                if v.unique_val == card.ability.extra.target_val then target_card = v break end
                            end
                            if target_card then
                                local target_center = target_card.config.center
                                card:set_sprites(target_center)
                            end
                        end, blocking = false, blockable = false
                    })
                    return true
                end
            end, blocking = false, blockable = false
        })
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
        card.ability.extra.target_val = target_card.unique_val
        local target_key = target_card.config.center.key
        local target_center = G.P_CENTERS[target_key]
        local target_vars = target_center.loc_vars and (target_center:loc_vars({}, target_card) or {}).vars or {}
        card.ability.extra.target_name = localize{type = "name_text", key = target_key, vars = target_vars}
        card.ability.extra.target_key = target_key

        card:set_sprites(target_center)
        card.ability.extra.sprite = target_center.key

        SMODS.calculate_effect{message = localize("k_copied_ex"), card = card}
    end,
    keep_on_use = function (self, card)
        return true
    end,
    loc_vars = function (self, info_queue, card)
        local target_name = localize("k_none")

        if card.ability.extra.copying then
            local target_card
            for i,v in ipairs(G.fac_fish_area.cards) do
                if v.unique_val == card.ability.extra.target_val then target_card = v break end
            end
            if target_card then
                local target_center = target_card.config.center
                local target_key = target_center.key
                local target_set = target_center.set
                local target_vars = target_center.loc_vars and (target_center:loc_vars({}, target_card) or {})
                target_name = localize{type= "name_text", key = target_key, set = target_set, vars = target_vars.vars or {}}
                info_queue[#info_queue+1] = {key = target_key, set = target_set, config = target_vars, vars = target_vars.vars}
                --info_queue[#info_queue+1] = G.P_CENTERS[target_key]
                --swap these info queues if smods doesn't accept my pr in time. sad but we'll live
            end
        end

        return {
            vars = {
                target_name
            }
        }
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

        if not target_card then return end

        local ret = SMODS.blueprint_effect(card, target_card, context)

        if context.end_of_round and context.main_eval and not context.blueprint then
            local reset = {
                func = function ()
                    G.E_MANAGER:add_event(Event{
                        func = function ()
                            card.ability.extra.copying = false
                            card.ability.extra.target_val = nil
                            card.ability.extra.target_key = nil
                            card.ability.extra.sprite = nil
                            card.ability.extra.target_name = "None"
                            card:set_sprites(self)
                            return true
                        end
                    })
                end,
                message = localize("k_reset")
            }

            ret = ret and SMODS.merge_effects(ret, reset) or reset
        end

        return ret
    end,
}