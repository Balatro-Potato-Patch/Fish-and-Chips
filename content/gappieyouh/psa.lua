FishAndChips.Fish {
    key = 'gappieyouh_psa',
    atlas = 'gy_fish',
    weight = 5,
    pos = {x=5,y=0},
    ppu_coder = { 'Youh' },
    ppu_artist = { 'Gappie' },
    attributes = { 'economy', 'boss_blind', "generation", },
    stats = {
        weight = {min = 0.001, max = 0.01},
        length = {min = 0.1, max = 0.15}
    },
    environments = {
        garden = 1,
        calm_pond = 1,
        wormhole = 1,
        backroom = 1
    },
    config = {
        extra = {
            bait = 2,
            sand_dollars = 3
        }
    },
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.bait, card.ability.extra.sand_dollars}}
    end,
    calculate = function(self, card, context)
        if context.end_of_round and context.game_over == false and context.main_eval and context.beat_boss then
            FishAndChips.create_baits_from_card(card, card.ability.extra.bait)
            return {sand_dollars = card.ability.extra.sand_dollars}
        end
    end
}
