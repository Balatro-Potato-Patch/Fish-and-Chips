FishAndChips.Fish {
    key = 'gappieyouh_compass',
    atlas = 'gy_fish',
    weight = 3,
    pos = {x=2,y=0},
    ppu_coder = { 'Youh' },
    ppu_artist = { 'Gappie' },
    attributes = { 'usable' },
    stats = {
        weight = {min = 0.5, max = 0.5},
        length = {min = 1, max = 1}
    },
    environments = {
        calm_pond = 0.25,
        styx = 0.25,
        aquifer = 0.25,
        soup = 0.25,
        backroom = 0.25,
        wormhole = 0.25
    },
    can_use = function(self, card)
        return G.fac_fish_area.cards and #G.fac_fish_area.cards > 0
    end,
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event{
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('timpani')

                -- logic for defining compass
                local envirotable = {
                    calm_pond = 0,
                    chocolate_river = 0,
                    styx = 0,
                    pier = 0,
                    swamp = 0,
                    aquifer = 0,
                    volcano = 0,
                    city_river = 0,
                    soup = 0,
                    garden = 0,
                    backroom = 0,
                    wormhole = 0
                }
                local fish_table = G.fac_fish_area.cards
                for i,v in pairs(fish_table) do
                    if v.config.center.key == 'fish_fac_gappieyouh_obsession' then
                        fish_table:remove(i)
                    end
                end
                for envs,_ in pairs(envirotable) do
                    for _,fish in pairs(fish_table) do
                        for k,_ in pairs(fish.config.center.environments) do
                            if k == envs then envirotable[envs] = envirotable[envs] + 1 end
                        end
                    end
                end
                local highest = 'calm_pond'
                for environment,values in pairs(envirotable) do
                    if values > envirotable[highest] then
                        highest = environment
                    end
                end

                -- execute compass
                card:juice_up(0.3,0.5)
                G.GAME.fac_next_environment = highest

                return {message = localize('k_fac_fish_compass_new'), colour = G.C.SPECTRAL}
            end
        })
    end,
}
