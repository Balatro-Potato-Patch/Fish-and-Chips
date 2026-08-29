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
                
                if fish.ability and fish.ability.extra and type(fish.ability.extra) == "table" and fish.ability.extra.fac_waffle_finclair then
                    G.E_MANAGER:add_event(Event({
                        func = function ()
                            local originalStats = fish.ability.extra.fac_waffle_finclair.stats
                            local originalEdition = fish.ability.extra.fac_waffle_finclair.edition
                            local originalSeal = fish.ability.extra.fac_waffle_finclair.seal
                            fish:set_ability(fish.ability.extra.fac_waffle_finclair.key)
                            if not G.GAME.fac_fish_expanded then
                                fish.T.scale = 0.7
                            end
                            fish.ability.stats = originalStats
                            fish:set_edition(originalEdition, true, true) -- True, true. I agree with your statement.
                            fish:set_seal(originalSeal, true, true)
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
            if fish.ability.extra and fish.ability.extra.fac_waffle_finclair then
                --print("used finclair copy")
                local originalStats = fish.ability.extra.fac_waffle_finclair.stats
                if not context.kept_on_use then
                    --print("do not keep")
                    G.E_MANAGER:add_event(Event({
                        func = function ()
                            local card = SMODS.add_card({
                                key = fish.ability.extra.fac_waffle_finclair.key,
                                area = G.fac_fish_area,
                                edition = fish.ability.extra.fac_waffle_finclair.edition,
                                seal = fish.ability.extra.fac_waffle_finclair.seal,
                                silent = true
                            })
                            card.ability.stats = originalStats
                            return true
                        end
                    }))
                end
            end
        end

        -- Clear Scaly-Foot Snail flag at end of round (having multiple Scaly-Foot Snails only activates and consumes one)
        if context.end_of_round and context.main_eval and not context.game_over then
            G.GAME.fac_waffle_snail_activated = nil
        end

    end,
    click = function ()
        love.system.openURL("https://github.com/DoctorWafflePhD/WaffleMod")
    end
})