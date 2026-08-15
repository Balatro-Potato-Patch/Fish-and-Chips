---@param data function
local event = function (data)
    G.E_MANAGER:add_event(Event{func = data})
end
local once = true

---@param args table I forget how to spell this shit out lmao. not that anything uses it i'm just future-proofing
---@return string wish_key Key in G.P_CENTERS of the available item
---@return string wish_set Set of the available item
---@return integer wish_cost Cost in sand dollars to buy the item
local function get_wish(args)
    if G.SETTINGS.paused then -- prevent rng advancement in collection and atp crash in main menu
        return "j_joker", "Joker", 8
    end

    args = args or {}
    local append = args.append or ""

    if args.pool then
        local any_available
        for i,v in ipairs(args.pool) do
            local succ, res = pcall(SMODS.add_to_pool, G.P_CENTERS[v], { source = "fac_minty_jeal" .. append })
            if not (succ and res) then
                args.pool[i] = "UNAVAILABLE"
            else
                any_available = true
            end
        end
        if not any_available then args.pool = {"j_joker"} end
        local wish
        local iter = 0
        repeat
            wish = pseudorandom_element(args.pool, "fac_minty_jeal_choose_card" .. append .. iter)
            iter = iter+1
        until wish ~= "UNAVAILABLE"
        return wish, args.force_set or G.P_CENTERS[wish].set, G.P_CENTERS[wish].cost * (args.cost_multiplier or 2)
    end

    local jokers, vouchers, etc = {}, {}, {}

    for k, v in pairs(G.P_CENTERS) do
        local atp = false
        if (v.set == "Joker" or v.set == "Voucher" or v.set == args.force_set) and SMODS.add_to_pool(v, { source = "fac_minty_jeal" .. append }) then
            atp = true
        end
        if v.set == "Joker" then
            jokers[#jokers + 1] = atp and k or "UNAVAILABLE"
        elseif v.set == "Voucher" then
            vouchers[#vouchers + 1] = atp and k or "UNAVAILABLE"
        elseif v.set == args.force_set then
            etc[#etc + 1] = atp and k or "UNAVAILABLE"
        end
    end

    if args.force_set == "Voucher" or pseudorandom("fac_minty_jeal_choose_set", 1, 10) == 10 then
        local wish = pseudorandom_element(vouchers, "fac_minty_jeal_choose_card" .. append)
        return wish, "Voucher", G.P_CENTERS[wish].cost * 1.5
    elseif args.force_set and args.force_set ~= "Joker" then
        local wish = pseudorandom_element(etc, "fac_minty_jeal_choose_card" .. append)
        return wish, args.force_set, G.P_CENTERS[wish].cost * (args.cost_multiplier or 2)
    else
        local wish = pseudorandom_element(jokers, "fac_minty_jeal_choose_card" .. append)
        return wish, "Joker", G.P_CENTERS[wish].cost * 2
    end
end

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
        "usable", "generation", "lose_economy", "joker",
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
        if not G.SETTINGS.paused then
            card.ability.extra.wish, card.ability.extra.set, card.ability.extra.cost = get_wish{}
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
            card.ability.extra.wish, card.ability.extra.set, card.ability.extra.cost = get_wish{}

            return {
                message = localize("k_reset")
            }
        end
    end
}
