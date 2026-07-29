SMODS.Atlas {
    key = "blamperer_credits",
    path = "blamperer/ts me.png",
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
    atlas = "blamperer_credits",
    pos = { x = 0, y = 0 },
    colour = G.C.BLUE,
    loc = true,
    click = function()
        love.system.openURL("https://github.com/blamperer/The-Latro")
    end
}

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
        
--     end,
--     weight = ,
--     environments = {
        
--     },
--     calculate = function(self, card, context)
        
--     end
-- }