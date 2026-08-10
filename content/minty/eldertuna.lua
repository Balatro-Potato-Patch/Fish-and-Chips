local row = 7
local atlas, pos = PotatoPatchUtils.Developers.fac_minty:get_lineboil_atlas_info(row)

FishAndChips.Fish{
    key = "minty_elder_tuna",
    atlas = atlas,
    pos = pos,
    weight = 1,
    ppu_coder = {"minty"},
    ppu_artist = {"whomstever"},
    environments = { --Maximum 6
        pier = 10,
        soup = 10,
        styx = 10,
        --[[
        calm_pond = 10,
        chocolate_river = 10,
        swamp = 10,
        aquifer = 10,
        volcano = 10,
        city_river = 10,
        garden = 10,
        backroom = 10,
        wormhole = 10,
        --]]
    },
    attributes = {
        "level_up"
    },
    stats = {
        weight = { min = 1, max = 1}, --In kilograms
        length = { min = 1, max = 2}, --In meters
    },
    update = function (self, card, dt)
        PotatoPatchUtils.Developers.fac_minty:set_line_boil(self, card, row)
    end,
    add_to_deck = function (self, card, from_debuff)
        print"added"
        local res = pseudorandom("fac_minty_elder_tuna", 1, 9)
        local hand
        if res <= 3 then
            local level = 0
            for k,v in pairs(G.GAME.hands) do
                if not hand or v.level > level or v.level == level and v.order < G.GAME.hands[hand].order then
                    hand = k
                end
            end
        elseif res <= 6 then
            local played = 0
            for k,v in pairs(G.GAME.hands) do
                if not hand or v.played > played or v.played == played and v.order < G.GAME.hands[hand].order then
                    hand = k
                end
            end
        elseif res <= 8 then
            local level = math.huge
            for k,v in pairs(G.GAME.hands) do
                if not hand or v.level < level or v.level == level and v.order < G.GAME.hands[hand].order then
                    hand = k
                end
            end
        else
            local visible = {}
            local any_visible = false
            for k,v in pairs(G.GAME.hands) do
                if SMODS.is_poker_hand_visible(k) then
                    any_visible = true
                    visible[#visible+1] = k
                else
                    visible[#visible+1] = "UNAVAILABLE"
                end
            end
            if not any_visible then --Will this ever happen? Probably not but LARGE SHRUGGING NOISES
                visible = {"High Card"}
            end
            local iter = 1
            repeat
                hand = pseudorandom_element(visible, "fac_minty_elder_tuna_random_hand"..iter)
                iter = iter + 1
            until hand ~= "UNAVAILABLE"
        end
        G.E_MANAGER:add_event(Event{
            func = function ()
                SMODS.calculate_effect{message = localize(hand, "poker_hands").."!", card = card}
                SMODS.upgrade_poker_hands{
                    hands = {hand},
                    level_up = 1,
                    from = card
                }
                SMODS.destroy_cards(card, {pinch_anim = true})
                return true
            end
        })
    end
}