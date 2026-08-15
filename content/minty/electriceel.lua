local row = 2
local atlas, pos = PotatoPatchUtils.Developers.fac_minty:get_lineboil_atlas_info(row)

FishAndChips.Fish{
    key = "minty_electric_eel",
    --[[
    atlas = atlas,
    pos = pos,
    --]]
    weight = 1,
    ppu_coder = {"minty"},
    ppu_artist = {"minty"},
    environments = { --Maximum 6
        swamp = 10,
        calm_pond = 10,
        city_river = 10,
        styx = 1,
        --[[
        chocolate_river = 10,
        pier = 10,
        aquifer = 10,
        volcano = 10,
        soup = 10,
        garden = 10,
        backroom = 10,
        wormhole = 10,
        --]]
    },
    attributes = {
        "usable", "retrigger", "boss_blind",
    },
    stats = {
        weight = { min = 3, max = 20}, --In kilograms
        length = { min = 0.5, max = 3}, --In meters
    },
    config = {
        extra = {
            stored = 1,
            ready = 0,
            charged_sprite = true
        }
    },
    loc_vars = function (self, info_queue, card)
        return {
            vars = {
                card.ability.extra.stored,
                card.ability.extra.ready,
            }
        }
    end,
    flavour_vars = function (self, info_queue, card)
        local key = self.key
        local eels = SMODS.find_card(self.key, true)
        local line = 4     --Funniest line to show up when it shouldn't, in case that happens somehow
        if #eels == 4 then --Probably never gonna happen, but I *will* fulfill the joke just in case it does
            for i, v in ipairs(eels) do
                if v == card then
                    line = i
                    key = key .. "_alt"
                    break
                end
            end
        end

        return {
            key = key,
            vars = {
                localize("k_fac_minty_iamfoureels"..line)
            }
        }
    end,
    can_use = function (self, card)
        return card.ability.extra.stored > 0
    end,
    use = function (self, card)
        card.ability.extra.stored = card.ability.extra.stored - 1
        card.ability.extra.ready = card.ability.extra.ready + 1
        SMODS.calculate_effect{message = localize("k_fac_minty_ready_ex"), card = card}
    end,
    update = function (self, card, dt)
        local force
        if card.ability.extra.stored + card.ability.extra.ready == 0 then
            force = false
        end

        PotatoPatchUtils.Developers.fac_minty:set_line_boil(self, card, row, force)
    end,
    calculate = function (self, card, context)
        if card.ability.extra.ready > 0 and (context.repetition or context.retrigger_joker and context.other_card ~= card) then
            return {
                repetitions = card.ability.extra.ready
            }
        end

        if context.end_of_round and context.main_eval then
            local reset, charge = {}, {}
            if card.ability.extra.ready > 0 then
                card.ability.extra.ready = 0
                reset = {
                    message = localize("k_reset")
                }
            end

            if context.beat_boss then
                card.ability.extra.stored = card.ability.extra.stored + 1
                charge = {
                    message = localize("k_fac_minty_charged_ex")
                }
            end

            return SMODS.merge_effects(reset, charge)
        end
    end
}
