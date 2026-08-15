FishAndChips.Fish {
    key = 'gappieyouh_mafia',
    atlas = 'gy_fish',
    weight = 5,
    pos = {x=0,y=0},
    ppu_coder = { 'Youh' },
    ppu_artist = { 'Gappie' },
    attributes = { 'xmult', 'usable', "reset", },
    stats = {
        weight = {min = 0.5, max = 1},
        length = {min = 0.4, max = 0.9}
    },
    config = {
        extra = {
            xmult = 1,
            xmult_mod = 0.5,
            usable = 1,
            rounds_slept = 0
        }
    },
    environments = {
        styx = 0.5,
        city_river = 1,
        swamp = 0.25
    },
    loc_vars = function(self, info_queue, card)
        local true_xmult = card.ability.extra.xmult + (card.ability.extra.xmult_mod * card.ability.extra.rounds_slept)
        return {vars = {true_xmult, card.ability.extra.xmult_mod}}
    end,
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event{
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('timpani')
                card.ability.extra.usable = 1
                card:juice_up(0.3,0.5)
                return true
            end
        })
    end,
    can_use = function(self,card)
        return card.ability.extra.usable == 1
    end,
    keep_on_use = function()
        return true
    end,
    calculate = function(self, card, context)
        -- main functionality
        if context.joker_main and card.ability.extra.usable == -1 then
            return {xmult = card.ability.extra.xmult + (card.ability.extra.xmult_mod * card.ability.extra.rounds_slept)}
        end

        -- sleep logic
        if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
            if card.ability.extra.usable == 1 then
                card.ability.extra.rounds_slept = card.ability.extra.rounds_slept + 1
                return {message = localize('k_fac_fish_mafia_mod'), colour = G.C.RED}
            else
                card.ability.extra.rounds_slept = 0
                card.ability.extra.usable = -1
                return {message = localize('k_fac_fish_mafia_reset'), colour = G.C.RED}
            end
        end
    end
}
