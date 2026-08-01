
FishAndChips.Fish {
    key = 'Parsa_dish',

    weight = 5,

    environments = {
        city_river = 50,
        pier = 20,
        soup = 5,
    },

    attributes = {
        economy = true,
        retrigger = true,
        xmult = true,
    },

    ppu_coder = {"Parsa"},
    ppu_artist = {"Parsa"},

    atlas = 'fac_Parsa_atlas_dish',
    pos = { x = 0, y = 0 },

    cost = 3,
    blueprint_compat = false,

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

        if context.before then
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


        if context.repetition and context.cardarea == G.play and context.other_card == context.full_hand[1] then
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