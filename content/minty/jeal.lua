---@param data function
local event = function (data)
    G.E_MANAGER:add_event(Event{func = data})
end
local once = true

FishAndChips.Fish{
    key = "minty_jeal",
    pronouns = "he_him",
    atlas = "minty_fish",
    pos = {x=3, y=0},
    badge_key = "k_fac_maybe_fish",
    weight = 1,
    ppu_coder = {"minty"},
    ppu_artist = {"minty"},
    environments = { --Maximum 6
        city_river = 10,
        styx = 10,
        chocolate_river = 10,
        garden = 10,
        backroom = 10,
        wormhole = 10,
        --[[
        calm_pond = 10,
        pier = 10,
        swamp = 10,
        aquifer = 10,
        volcano = 10,
        soup = 10,
        --]]
    },
    attributes = {
        "usable", "generation"
    },
    config = {
        extra = {
            wish = "j_joker",
            set = "Joker",
            cost = 4
        }
    },
    loc_vars = function (self, info_queue, card)
        local wish = card.ability.extra.wish
        local key = self.key
        if wish then
            info_queue[#info_queue+1] = G.P_CENTERS[wish]
        else
            key = key.."_unready"
        end
        local main_end
        if card.ability.extra.set == "Joker" then
            main_end = {}
            localize{type = 'other', key = 'fac_minty_jeal_needsroom', nodes = main_end, vars = {}}
            main_end = main_end[1]
        end

        return {
            key = key,
            vars = {
                localize{type = "name_text", set = card.ability.extra.set, key = card.ability.extra.wish},
                not G.GAME.fac_jeal_free_wishes and card.ability.extra.cost or "free"
            },
            main_end = main_end
        }
    end,
    flavour_vars = function (self, info_queue, card)
        local num = math.random(1000)
        local key = self.key
        if next(SMODS.find_mod("DebugPlus")) and num == 1000 then
            key = key.."_3"
        elseif num%2 == 0 then
            key = key.."_2"
        end
        return {
            key = key
        }
    end,
    stats = {
        weight = { min = 80, max = 95}, --In kilograms
        length = { min = 1.5, max = 1.9}, --In meters
    },
    can_use = function (self, card)
        return card.ability.extra.wish and (G.GAME.fac_jeal_free_wishes or (G.GAME.fac_sand_dollars + G.GAME.bankrupt_at) >= card.ability.extra.cost) and (card.ability.extra.set ~= "Joker" or #G.jokers.cards < G.jokers.config.card_limit)
    end,
    keep_on_use = function (self, card)
        return true
    end,
    use = function (self, card)
        local prev_state = G.STATE
        local lock = card.ID
        G.CONTROLLER.locks[lock] = true
        card:highlight(false)

        local wish, set = card.ability.extra.wish, card.ability.extra.set
        local granted = SMODS.create_card{
            key = wish,
            set = set,
            area = G.play
        }
        event(function ()
            granted:juice_up()
            play_sound('tarot1')
            if not G.GAME.fac_jeal_free_wishes then
                ease_sand_dollars(-card.ability.extra.cost, true)
            end
            return true
        end)
        delay(2)
        event(function ()
            if set == "Voucher" then
                granted.cost = 0
                granted.shop_voucher = false
                local current_round_voucher = G.GAME.current_round.voucher
                granted:redeem()
                G.GAME.current_round.voucher = current_round_voucher
                event(function ()
                    granted:start_dissolve()
                    return true
                end)
            else
                SMODS.add_to_deck(granted, {
                    area = G.jokers
                })
            end
            return true
        end)
        delay(2)
        event(function ()
            G.STATE = prev_state
            card.ability.extra = {}
            G.CONTROLLER.locks[lock] = nil
            return true
        end)
    end,
    set_ability = function (self, card, initial, delay_sprites)
        local jokers, vouchers = {}, {}

        for k,v in pairs(G.P_CENTERS) do
            local atp = false
            -- This is causing a crash when viewing this page on the title screen collection due to polling if the fish 
            -- is in the pool or not. Not sure best way to fix - WilsontheWolf
            if SMODS.add_to_pool(v, {source = "fac_minty_jeal"}) then
                atp = true
            end
            if v.set == "Joker" then
                jokers[#jokers+1] = atp and k or "UNAVAILABLE"
            elseif v.set == "Voucher" then
                vouchers[#vouchers+1] = atp and k or "UNAVAILABLE"
            end
        end

        if pseudorandom("fac_minty_jeal_choose_set", 1, 10) == 10 then
            local wish = pseudorandom_element(vouchers, "fac_minty_jeal_choose_card")
            card.ability.extra.wish = wish
            card.ability.extra.set = "Voucher"
            card.ability.extra.cost = G.P_CENTERS[wish].cost * 1.5
        else
            local wish = pseudorandom_element(jokers, "fac_minty_jeal_choose_card")
            card.ability.extra.wish = wish
            card.ability.extra.set = "Joker"
            card.ability.extra.cost = G.P_CENTERS[wish].cost * 2
        end

        event(function ()
            if not card.area then return false end
            if card.area.config.collection then
                function card:click()
                    if once then
                        once = false
                        love.system.openURL("https://archiveofourown.org/works/43162149")
                    end
                    return Card.click(card)
                end
            end
            return true
        end)
    end,
    calculate = function (self, card, context)
        if context.after then
            local jokers, vouchers = {}, {}

            for k,v in pairs(G.P_CENTERS) do
                local atp = false
                if SMODS.add_to_pool(v, {source = "fac_minty_jeal"}) then
                    atp = true
                end
                if v.set == "Joker" then
                    jokers[#jokers+1] = atp and k or "UNAVAILABLE"
                elseif v.set == "Voucher" then
                    vouchers[#vouchers+1] = atp and k or "UNAVAILABLE"
                end
            end

            if pseudorandom("fac_minty_jeal_choose_set", 1, 10) == 10 then
                local wish = pseudorandom_element(vouchers, "fac_minty_jeal_choose_card")
                card.ability.extra.wish = wish
                card.ability.extra.set = "Voucher"
                card.ability.extra.cost = G.P_CENTERS[wish].cost * 1.5
            else
                local wish = pseudorandom_element(jokers, "fac_minty_jeal_choose_card")
                card.ability.extra.wish = wish
                card.ability.extra.set = "Joker"
                card.ability.extra.cost = G.P_CENTERS[wish].cost * 2
            end

            return {
                message = localize("k_reset")
            }
        end
    end
}
