FishAndChips.Fish {
    key = 'gappieyouh_soup',
    atlas = 'gy_fish',
    weight = 10,
    pos = {x=4,y=0},
    ppu_coder = { 'Youh' },
    ppu_artist = { 'Gappie' },
    attributes = { 'chips', 'food', "editions", },
    stats = {
        weight = {min = 1, max = 2},
        length = {min = 0.45, max = 0.65}
    },
    environments = {
        soup = 10
    },
    can_use = function(self, card)
        local check = 0
        for _,v in pairs(G.fac_fish_area.cards) do
            if not v.edition then
                check = check + 1
            end
        end
        return G.fac_fish_area.cards and #G.fac_fish_area.cards > 0 and check == #G.fac_fish_area.cards
    end,
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event{
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('timpani')
                local area = G.fac_fish_area.cards
                for i,v in ipairs(area) do
                    if v == card then
                        table.remove(area,i)
                        break
                    end
                end
                local editioned_card = pseudorandom_element(area, "fish_fac_gy_soupseed" .. G.GAME.round_resets.ante)
                local edition = SMODS.poll_edition({key = "fish_fac_gy_soupseed", guaranteed = true, no_negative = true})
                editioned_card:set_edition(edition)
                return true
            end
        })
    end,
}
