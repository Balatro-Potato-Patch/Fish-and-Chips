
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
    stats = {
    weight = { min = 10, max = 20 },
    length = { min = 10, max = 20 },
    },
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


FishAndChips.Fish {
    key = 'Parsa_facfile',
    weight = 2,
    environments = { wormhole = 40, garden = 10 },
    attributes = { copying = true, generation = true },

    ppu_coder = {"Parsa"},
    ppu_artist = {"Parsa"},

    stats = {
    weight = { min = 0.01, max = 0.1 },
    length = { min = 10, max = 20 },
    },

    atlas = 'Parsa_atlas_file',
    pos = { x = 0, y = 0 },

    cost = 8,
    blueprint_compat = false,

    impulse_min = 0.2,
    impulse_max = 0.45,
    decision_min = 0.3,
    decision_max = 0.6,
    vel_limit = 0.5,
    requires_hand = false,
    treasure = false,

    config = { extra = {} },

    loc_vars = function(self, info_queue, card)
        return {}
    end,

    get_copy_pool = function(self)
        if self._copy_pool then return self._copy_pool end
        local pool = {}
        for k, c in pairs(G.P_CENTERS) do
            if c.set == 'Joker' and not c.mod and c.calculate then
                pool[#pool + 1] = k
            end
        end
        self._copy_pool = pool
        return pool
    end,

    calculate = function(self, card, context)

        if context.setting_blind then
            local pool = self:get_copy_pool()
            local key = pseudorandom_element(pool, pseudoseed('facfile_' .. tostring(card.sort_id or 0)))
            card.fac_copied_key = key
            card.ability.extra = copy_table(G.P_CENTERS[key].config.extra or {})
        end


        if card.fac_copied_key then
            local center = G.P_CENTERS[card.fac_copied_key]
            if center and center.calculate then
                local result = center.calculate(center, card, context)
                if result then return result end
            end
        end


        if context.end_of_round then
            card.fac_rounds_played = (card.fac_rounds_played or 0) + 1
        end

        if context.check_eternal and context.other_card == card and (card.fac_rounds_played or 0) < 5 then
            local trig = context.trigger
            if type(trig) == 'table' and trig.from_sell then
                return { no_destroy = true }
            end
        end
    end,
}