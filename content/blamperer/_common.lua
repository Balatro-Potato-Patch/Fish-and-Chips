SMODS.Atlas {
    key = "blamperer_credits",
    path = "blamperer/ts_me.png",
    px = 71,
    py = 95
}

SMODS.Atlas {
    key = "blamperer_fitch",
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
    end,
    calculate = function(self, context)
        -- Reset hook time
        if context.fac_end_fishing then
            G.E_MANAGER:add_event(Event({
                func = function()
                    G.GAME.blamperer_hook_time = 0
                    return true
                end
            }))
        end
        -- Reallow Washed-out Voucher to spawn
        if context.ante_change and context.ante_change ~= 0 and context.ante_end then
            if G.GAME.pool_flags.fac_blamperer_vouched then
                G.GAME.pool_flags.fac_blamperer_vouched = nil
            end
        end
    end
}

-- Custom attributes
-- (legal as per https://discord.com/channels/1397999048559951923/1528889180695035924/1531781743449997535)
SMODS.Attribute {
    key = "fac_fish_slot",
    alias = { "fish_slot" }
}
SMODS.Attribute {
    key = "fac_perfect_catch",
    aliases = { "fac_perfect_catches", "perfect_catches", "perfect_catch", "perfect" }
}

-- Hoosks
local rgg_ref = FishAndChips.mod.reset_game_globals
function FishAndChips.mod.reset_game_globals(run_start)
    rgg_ref(run_start)
    if run_start then
        G.GAME.blamperer_hook_time = 0.0
    end
end

local upd_fac_fish_hooking_ref = G.update_fac_fishing_hooking
function G:update_fac_fishing_hooking(dt)
    upd_fac_fish_hooking_ref(self, dt)
    -- Increase hook time
    if G.FAC_FISH_GAME.decay_unlocked then
        G.GAME.blamperer_hook_time = G.GAME.blamperer_hook_time + dt
    end
    -- Autotuna
    if G.FAC_FISH_GAME.profile.rod_key ~= "rod_fac_harpoon" then
        -- BALANCE: Passive gain relative to rod catch gain; consider it a catch speed boost (in this case, +33%)
        local AUTOFACTOR = 0.33
        local autotuna = #SMODS.find_card("fish_fac_blamperer_autotuna")
        if autotuna > 0 then
            local autoprogress = autotuna * AUTOFACTOR * G.FAC_FISH_GAME.profile.catch_gain * dt
            -- BALANCE: Uncomment this to let Autotuna directly (but weakly) oppose catch loss
            -- if G.FAC_FISH_GAME.decay_unlocked then
            --     autoprogress = autoprogress + (AUTOFACTOR * G.FAC_FISH_GAME.profile.catch_loss * dt) / 2
            -- end
            local DECAY_THRESHOLD = 0.15 -- FAC_DECAY_UNLOCK_THRESHOLD = 0.15, update if this value changes
            if G.FAC_FISH_GAME.decay_unlocked or (G.FAC_FISH_GAME.meter + autoprogress) < DECAY_THRESHOLD then
                G.FAC_FISH_GAME.meter = G.FAC_FISH_GAME.meter + autoprogress
            end
            -- Treasure meter stuff might not be allowed (https://discord.com/channels/1397999048559951923/1528888229971890316/1535703036691742832)
            -- If it is, though, you can uncomment this part
            -- if G.FAC_FISH_GAME.treasure_enabled and not G.FAC_FISH_GAME.got_treasure then
            --     -- You don't get to autocatch treasure faster if you're relying on autotune
            --     local autotreasure = autotuna * AUTOFACTOR * math.min(G.FAC_FISH_GAME.profile.treasure_gain, G.FAC_FISH_GAME.profile.catch_gain) * dt
            --     G.FAC_FISH_GAME.treasure_meter = G.FAC_FISH_GAME.treasure_meter + autotreasure
            -- end
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
--     stats = {
--         weight = { min = 1, max = 1 },
--         length = { min = 1, max = 1 },
--     },
--     weight = ,
--     environments = {

--     },
--     calculate = function(self, card, context)

--     end
-- }
