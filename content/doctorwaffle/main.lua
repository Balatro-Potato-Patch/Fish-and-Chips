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
        
        if context.round_eval then
        
            for _, fish in pairs(G.fac_fish_area.cards) do
                
                if fish.ability and fish.ability.extra and fish.ability.extra.fac_waffle_finclair_copy then
                    G.E_MANAGER:add_event(Event({
                        func = function ()
                            fish:set_ability(fish.ability.extra.fac_waffle_finclair_copy)
                            if G.GAME.fac_fish_expanded then
                            else
                                fish.T.scale = 0.7
                            end
                            return true
                        end
                    }))
                    SMODS.calculate_effect({message = localize('k_fac_waffle_presto_ex'), colour = G.C.PURPLE}, fish)
                end

            end
        
        end

        if context.using_consumeable then
            print(context.consumeable.ability.set)
        end

    end
})