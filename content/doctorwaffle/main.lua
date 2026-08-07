local PPU = PotatoPatchUtils

SMODS.Atlas {
    key = "waffle_credit",
    px = 71,
    py = 95,
    path = "doctorwaffle/credit.png"
}

PPU.Developer({
	name = 'waffle',
	atlas = 'fac_waffle_credit',
	colour = HEX("7A2E2E"),
    pos = {x = 0, y = 0},
    soul_pos = {x = 1, y = 0},
    loc = true,
    calculate = function (self, context)
        
        -- Finclair reverting at end of round
        if context.round_eval then
        
            for _, fish in pairs(G.fac_fish_area.cards) do
                
                if fish.ability and fish.ability.extra and fish.ability.extra.fac_waffle_finclair_copy then
                    G.E_MANAGER:add_event(Event({
                        func = function ()
                            local originalStats = fish.ability.extra.fac_waffle_finclair_stats
                            fish:set_ability(fish.ability.extra.fac_waffle_finclair_copy)
                            fish.ability.stats = originalStats
                            if not G.GAME.fac_fish_expanded then
                                fish.T.scale = 0.7
                            end
                            return true
                        end
                    }))
                    SMODS.calculate_effect({message = localize('k_fac_waffle_presto_ex'), colour = G.C.PURPLE}, fish)
                end

            end
        
        end

        -- Finclair reverting when used
        if context.fac_use_fish then
            local fish = context.fac_use_fish
            if fish.ability.extra.fac_waffle_finclair_copy then
                --print("used finclair copy")
                local originalStats = fish.ability.extra.fac_waffle_finclair_stats
                if not context.kept_on_use then
                    --print("do not keep")
                    G.E_MANAGER:add_event(Event({
                        func = function ()
                            local card = SMODS.add_card({
                                key = "fish_fac_waffle_finclair",
                                area = G.fac_fish_area
                            })
                            card.ability.stats = originalStats
                            return true
                        end
                    }))
                end
            end
        end

        -- Clear snail marker at end of round
        if context.end_of_round and context.main_eval and not context.game_over then
            G.GAME.fac_waffle_snail_activated = nil
        end

    end
})