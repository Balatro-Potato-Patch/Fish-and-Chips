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
    blueprint_compat = false,
    eternal_compat = false,
    can_use = function(self, card)
        return true
    end,
    use = function(self, card, area, copier)
        local envirotable = {}
        for _,fish in ipairs(G.fac_fish_area.cards) do
            if fish.config.center.key ~= 'fish_fac_gappieyouh_compass' then
                for k,_ in pairs(fish.config.center.environments) do
                    envirotable[k] = (envirotable[k] or 0) + 1
                end
            end
        end
        local highest = 'calm_pond'
        for environment,values in pairs(envirotable) do
            if values > (envirotable[highest] or 0) then
                highest = environment
            end
        end
        G.GAME.fac_next_environment = highest

        G.E_MANAGER:add_event(Event{
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('timpani')
                card:juice_up(0.3,0.5)
                return true
            end
        })
        return {message = localize('k_fac_fish_compass_new'), colour = G.C.SPECTRAL}
    end,
}
