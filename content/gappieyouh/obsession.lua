FishAndChips.Fish {
    key = 'gappieyouh_obsession',
    atlas = 'gy_fish',
    weight = 10,
    pos = {x=1,y=0},
    ppu_coder = { 'Youh' },
    ppu_artist = { 'Gappie' },
    attributes = { 'economy', 'fac_perfect_catch', },
    stats = {
        weight = {min = 2, max = 4},
        length = {min = 0.5, max = 2}
    },
    config = {
        extra = {
            money = 4
        }
    },
    environments = {
        calm_pond = 1,
        pier = 1,
        styx = 1
    },
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.money}}
    end,
    calculate = function(self, card, context)
        if context.fac_end_fishing and context.perfect and context.missed_treasure then
            return {dollars = card.ability.extra.money}
        end
    end
}
