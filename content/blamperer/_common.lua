SMODS.Atlas {
    key = "blamperer_credits",
    path = "blamperer/ts_me.png",
    px = 71,
    py = 95
}

SMODS.Atlas {
    key = "fitch",
    path = "blamperer/fitch.png",
    px = 71,
    py = 95
}

PotatoPatchUtils.Developer {
    name = "blamperer",
    atlas = "fac_blamperer_credits",
    pos = { x = 0, y = 0 },
    colour = G.C.BLUE,
    loc = true,
    click = function()
        love.system.openURL("https://github.com/blamperer/The-Latro")
    end
}

-- Hoosks
local rgg_ref = FishAndChips.mod.reset_game_globals
function FishAndChips.mod.reset_game_globals(run_start)
    rgg_ref(run_start)
    if run_start then
        G.GAME.blamperer_hook_time = 0.0
    end
end

local game_update_ref = Game.update
function Game:update(dt)
    game_update_ref(self, dt)
    if G.STATE == G.STATES.FAC_FISHING then
        if G.FISHING_STATE == G.FISHING_STATES.HOOKING and G.FAC_FISH_GAME.decay_unlocked then
            G.GAME.blamperer_hook_time = G.GAME.blamperer_hook_time + dt
        end
    end
end

-- tf (this fish) templating me
-- FishAndChips.Fish {
--     key = "blamperer_",
--     atlas = "fitch",
--     pos = { x = 0, y = 0 },
--     ppu_coder = { "blamperer" },
--     ppu_artist = { "blamperer" },
--     attributes = {

--     },
--     config = {
--         extra = {

--         }
--     },
--     loc_vars = function(self, info_queue, card)
--         return {
--             vars = {}
--         }
--     end,
--     weight = ,
--     environments = {

--     },
--     calculate = function(self, card, context)

--     end
-- }
