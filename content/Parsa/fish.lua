
FishAndChips.Fish {
    key = 'Parsa_dish',

    weight = 50,

    environments = {
        city_river = 30,
        soup = 20,
    },

    attributes = {
        economy = true,
        retrigger = true,
        xmult = true,
    },

    ppu_coder = {"Parsa"},
    ppu_artist = {"Parsa"},
    attributes = { "lose_economy", "retrigger", "xchips", }

    atlas = 'fac_Parsa_atlas_dish',
    stats = {
    weight = { min = 0.1, max = 0.5 },
    length = { min = 0.10, max = 0.20 },
    },
    pos = { x = 0, y = 0 },

    cost = 3,

    impulse_min = 0.12,
    impulse_max = 0.3,
    decision_min = 0.24,
    decision_max = 0.55,
    vel_limit = 0.42,
    requires_hand = false,
    treasure = false,

    config = {
        extra = {
            dollar_cost = 3,
            retriggers = 3,
            xchips_penalty = 0.8,
            underpaid = false,
            hand_played = false,
        },
    },

    loc_vars = function(self, info_queue, card)
        return { vars = {
            card.ability.extra.dollar_cost,
            card.ability.extra.retriggers,
            card.ability.extra.xchips_penalty,
        } }
    end,
calculate = function(self, card, context)

    if context.before and not context.blueprint then
        if G.GAME.dollars >= card.ability.extra.dollar_cost then
            ease_dollars(-card.ability.extra.dollar_cost, true)
            card.ability.extra.underpaid = false
        else
            card.ability.extra.underpaid = true
        end


        if not card.ability.extra.hand_played then
            card.ability.extra.hand_played = true
        end
    end


    if context.joker_main and card.ability.extra.underpaid then
        return {
            xchips = card.ability.extra.xchips_penalty,
            colour = G.C.RED,
        }
    end


    if context.repetition and not card.ability.extra.underpaid and context.cardarea == G.play and context.other_card == context.full_hand[1] then
        return {
            repetitions = card.ability.extra.retriggers,
            card = card,
        }
    end


    if context.check_eternal and context.other_card == card and card.ability.extra.hand_played then
        local trig = context.trigger
        if type(trig) == 'table' and trig.from_sell then
            return { no_destroy = true }
        end
    end
end
}


FishAndChips.Fish {
    key = 'Parsa_facfile',
    weight = 15,
    environments = {
        wormhole = 7,
    },
    attributes = {
        destroy_card = true,
        generation = true,
    },

    ppu_coder = { 'Parsa' },
    ppu_artist = { 'Parsa' },

    atlas = 'fac_Parsa_atlas_file',
    pos = { x = 0, y = 0 },

    cost = 8,
    blueprint_compat = false,

    stats = {
        weight = { min = 0.001, max = 0.009 },
        length = { min = 0.1, max = 0.5 },
    },

    impulse_min = 0.2,
    impulse_max = 0.45,
    decision_min = 0.3,
    decision_max = 0.6,
    vel_limit = 0.5,
    requires_hand = false,
    treasure = false,

    attributes = {"destroy_card", "generation", "tag", "joker", }

    config = {
        extra = {
            rounds_played = 0,
        },
    },

    loc_vars = function(self, info_queue, card)
        return {
            vars = { card.ability.extra.rounds_played },
        }
    end,

calculate = function(self, card, context)
    if context.setting_blind then
        if card.ability.extra.rounds_played <= 2 then -- TODO: This definitely seems wrong but i can't be bothered testing it rn (mf)
            card.ability.extra.rounds_played = 2
        else
            card.ability.extra.rounds_played = card.ability.extra.rounds_played + 1
        end

        local destructable_jokers = {}
        for i = 1, #G.jokers.cards do
            if G.jokers.cards[i] ~= card
                and not SMODS.is_eternal(G.jokers.cards[i], card)
                and not G.jokers.cards[i].getting_sliced then
                destructable_jokers[#destructable_jokers + 1] = G.jokers.cards[i]
            end
        end

        local joker_to_destroy = pseudorandom_element(destructable_jokers, 'facfile_destroy')
        if joker_to_destroy then
            joker_to_destroy.getting_sliced = true
            G.E_MANAGER:add_event(Event({
                func = function()
                    card:juice_up(0.8, 0.8)
                    joker_to_destroy:start_dissolve({ G.C.RED }, nil, 1.6)
                    return true
                end
            }))
        end

        local tag_pool = {}
        for k, _ in pairs(G.P_TAGS) do
            tag_pool[#tag_pool + 1] = k
        end
        for i = 1, 2 do
            local tag_key = pseudorandom_element(tag_pool, 'facfile_tag_' .. i)
            add_tag(Tag(tag_key))
        end
    end

    if context.check_eternal and context.other_card == card and card.ability.extra.rounds_played < 2 then
        local trig = context.trigger
        if type(trig) == 'table' and trig.from_sell then
            return { no_destroy = true }
        end
    end
end,
}
