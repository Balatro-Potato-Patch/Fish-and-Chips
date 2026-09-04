FishAndChips.Fish {
    key = 'gappieyouh_mafia',
    atlas = 'gy_fish',
    weight = 5,
    pos = {x=0,y=0},
    ppu_coder = { 'Youh' },
    ppu_artist = { 'Gappie' },
    attributes = { 'xmult', 'usable', 'reset', 'scaling' },
    stats = {
        weight = {min = 0.5, max = 1},
        length = {min = 0.4, max = 0.9}
    },
    config = {
        extra = {
            xmult = 1,
            xmult_mod = 0.5,
            awake = false,
            rounds_slept = 0
        }
    },
    environments = {
        styx = 0.5,
        city_river = 1,
        swamp = 0.25
    },
    perishable_compat = false,
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.xmult + (card.ability.extra.xmult_mod * card.ability.extra.rounds_slept), card.ability.extra.xmult_mod,
        ppu_bubbles = { card.ability.extra.awake and "used" or "usable" }}}
    end,
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event{
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('timpani')
                card.ability.extra.awake = true
                card:juice_up(0.3,0.5)
                return true
            end
        })
    end,
    can_use = function(self,card)
        return not card.ability.extra.awake
    end,
    keep_on_use = function()
        return true
    end,
    calculate = function(self, card, context)
        -- main functionality
        if context.joker_main and card.ability.extra.awake then
            return {xmult = card.ability.extra.xmult + (card.ability.extra.xmult_mod * card.ability.extra.rounds_slept)}
        end

        -- sleep logic
        if context.end_of_round and not context.game_over and context.main_eval and not context.blueprint and not context.retrigger_joker then
            if not card.ability.extra.awake then
                card.ability.extra.rounds_slept = card.ability.extra.rounds_slept + 1
                return {message = localize { type = 'variable', key = 'k_fac_fish_mafia_mod', vars = { card.ability.extra.xmult_mod } }, colour = G.C.RED}
            else
                card.ability.extra.rounds_slept = 0
                card.ability.extra.awake = false
                return {message = localize('k_fac_fish_mafia_reset'), colour = G.C.RED}
            end
        end
    end
}
