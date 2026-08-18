local tarot_anim = function(cards, func, args)
    args = args or {}
    args.func_delay = args.func_delay or 0.1
    args.flip_delay = args.flip_delay or 0.2
    args.unhighlight = args.unhighlight or true
    for i = 1, #cards do
        local percent = 1.15 - (i - 0.999) / (#cards - 0.998) * 0.3
        G.E_MANAGER:add_event(Event({
            trigger = "after",
            delay = 0.15,
            func = function()
                cards[i]:flip()
                play_sound("card1", percent)
                cards[i]:juice_up(0.3, 0.3)
                return true
            end,
        }))
    end
    delay(args.flip_delay)
    for i = 1, #cards do
        G.E_MANAGER:add_event(Event({
            trigger = "after",
            delay = args.func_delay,
            func = function()
                func(cards[i]); return true
            end
        }))
    end
    delay(args.flip_delay)
    for i = 1, #cards do
        local percent = 0.85 + (i - 0.999) / (#cards - 0.998) * 0.3
        G.E_MANAGER:add_event(Event({
            trigger = "after",
            delay = 0.15,
            func = function()
                cards[i]:flip()
                play_sound("tarot2", percent, 0.6)
                cards[i]:juice_up(0.3, 0.3)
                return true
            end,
        }))
    end
    if args.unhighlight then
        G.E_MANAGER:add_event(Event({
            trigger = "after",
            delay = 0.2,
            func = function()
                G.hand:unhighlight_all()
                return true
            end
        }))
    end
    delay(0.5)
end

FishAndChips.Fish {
    key = "blamperer_multisquid",
    atlas = "blamperer_fitch",
    pos = { x = 9, y = 0 },
    ppu_coder = { "blamperer" },
    ppu_artist = { "blamperer" },
    attributes = {
        "suit", "usable", "modify_card", "chance", "enhancements",
    },
    config = {
        extra = {
            select = 3,
            odds = 4
        }
    },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.m_wild
        local num, denom = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, "blamperer_multisquid")
        return {
            vars = {
                card.ability.extra.select,
                num, denom
            }
        }
    end,
    stats = {
        weight = { min = 0.2, max = 1.5 },
        length = { min = 0.15, max = 0.4 },
    },
    weight = 10,
    environments = {
        pier = 10,
        calm_pond = 4
    },
    blueprint_compat = false,
    eternal_compat = false,
    requires_hand = true,
    can_use = function(self, card)
        return #G.hand.highlighted > 0 and #G.hand.highlighted <= card.ability.extra.select
    end,
    use = function(self, card)
        local selected_suits = {}
        for _, v in ipairs(G.hand.highlighted) do
            selected_suits[v.base.suit] = true
        end
        local new_suit, _ = pseudorandom_element(SMODS.Suits, "blamperer_multisquid", {
            in_pool = function(v, args)
                return not selected_suits[v.key]
            end
        })
        local func = function(c)
            assert(SMODS.change_base(c, new_suit.key, nil))
            if SMODS.pseudorandom_probability(card, "blamperer_multisquid", 1, card.ability.extra.odds, "blamperer_multisquid") then
                c:set_ability(G.P_CENTERS.m_wild)
            end
        end

        tarot_anim(G.hand.highlighted, func)
    end
}
