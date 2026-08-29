SMODS.Atlas({
    key = "sg11_n_vekhi_soul_cannon",
    path = "sg11_n_vekhi/soul_cannon.png",
    px = 71,
    py = 95,
})

local initialize_soul_cannon_sequence = function(cannon, cards_to_destroy)
    cannon.fac_cannon_rescaled = true

    local explode_time = 1.3 * (math.sqrt(G.SETTINGS.GAMESPEED))

    G.E_MANAGER:add_event(Event({
        trigger = "after",
        delay = 1,
        func = function()
            return true
        end,
    }))
    for _, card in ipairs(cards_to_destroy) do
        G.E_MANAGER:add_event(Event({
            func = function()
                card:explode()
                return true
            end,
        }))
    end
    G.E_MANAGER:add_event(Event({
        trigger = "after",
        delay = explode_time,
        func = function()
            cannon:juice_up()
            cannon:hard_set_T(nil, nil, cannon.T.w * 1.25, cannon.T.h * 1.25)
            cannon.ability.extra.activated = true
            return true
        end,
    }))
end

FishAndChips.Fish({
    key = "sg11_n_vekhi_soul_cannon",
    atlas = "fac_sg11_n_vekhi_soul_cannon",
    pos = { x = 0, y = 0 },
    ppu_coder = { "sleepyg11" },
    ppu_artist = { "vevekhi" },
    attributes = { "prevents_death", "destroy_card", "fac_fish_slot", },
    blueprint_compat = false,
    config = {
        extra = {
            sacrifice = 2,
            activated = false,
        },
    },
    weight = 5,
    stats = {
        weight = { min = 8, max = 8 },
        length = { min = 1.7, max = 1.7 },
    },
    environments = {
        styx = 3,
        aquifer = 1,
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = { card.ability.extra.sacrifice },
        }
    end,
    flavour_vars = function(self, info_queue, card)
        if card.ability.extra.activated then
            return {
                key = self.key .. "_proceed",
            }
        end
        if G.STAGE == G.STAGES.RUN and G.GAME.current_round.hands_left <= 1 then
            return {
                key = self.key .. "_desperate",
            }
        end
    end,
    calculate = function(self, card, context)
        if
            context.end_of_round
            and context.game_over
            and not context.blueprint
            and G.fac_fish_area
            and G.fac_fish_area.config.card_limits.base >= card.ability.extra.sacrifice
        then
            local target_amount = card.ability.extra.sacrifice
            local potential_cards = {}
            for _, c in ipairs(SMODS.shallow_copy(card.area.cards)) do
                if not (c == card or SMODS.is_eternal(c)) then
                    table.insert(potential_cards, c)
                end
            end
            if #potential_cards >= target_amount then
                local cards_to_destory = {}
                while #cards_to_destory < target_amount do
                    local loser, key = pseudorandom_element(potential_cards, "pac_soul_cannon_activation")
                    if loser then
                        table.insert(cards_to_destory, loser)
                        table.remove(potential_cards, key)
                    else
                        break
                    end
                end
                if #cards_to_destory >= target_amount then
                    initialize_soul_cannon_sequence(card, cards_to_destory)
                    return {
                        saved = "k_pac_soul_cannon_trigger",
                        func = function()
                            SMODS.destroy_cards(cards_to_destory)
                            G.fac_fish_area.config.card_limits.base = G.fac_fish_area.config.card_limits.base
                                - target_amount
                        end,
                    }
                end
            end
        end
        if context.starting_shop and card.fac_cannon_rescaled then
            local scale_factor = 1.25
            card:hard_set_T(nil, nil, card.T.w / scale_factor, card.T.h / scale_factor)
            card:juice_up()
            card.fac_cannon_rescaled = nil
        end
        if context.starting_shop then
            card.ability.extra.activated = false
        end
    end,
    update = function(self, card, dt)
        if G.GAME then
            local atlas_x = card.children.center.sprite_pos.x
            if card.ability and card.ability.extra.activated then
                card.fac_cannon_wiggle = nil
                if atlas_x ~= 2 then
                    card.children.center:set_sprite_pos({ x = 2, y = 0 })
                end
            elseif G.GAME.current_round.hands_left <= 1 then
                if atlas_x ~= 1 then
                    card.children.center:set_sprite_pos({ x = 1, y = 0 })
                end
                if not card.fac_cannon_wiggle then
                    local eval = function()
                        return not card.REMOVED and card.fac_cannon_wiggle
                    end
                    card.fac_cannon_wiggle = true
                    juice_card_until(card, eval, true)
                end
            else
                card.fac_cannon_wiggle = nil
                if atlas_x ~= 0 then
                    card.children.center:set_sprite_pos({ x = 0, y = 0 })
                end
            end
        end
    end,
})
