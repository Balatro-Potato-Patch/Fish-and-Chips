FishAndChips.Achievement = SMODS.Achievement:extend({
    hidden_name = false, atlas = 'fac_achievements', bypass_all_unlocked = true
})

FishAndChips.Achievement({
    key = 'catch_1',
    config = {amount = 10},
    unlock_condition = function(self, args)
        if args.type == 'fac_fish_caught' and G.PROFILES[G.SETTINGS.profile].fac_fishing.career_fish_caught >= self.config.amount then return true end
    end,
    display_progress = function(self)
        return G.PROFILES[G.SETTINGS.profile].fac_fishing.career_fish_caught .. '/' .. self.config.amount
    end
})

FishAndChips.Achievement({
    key = 'catch_2',
    config = {amount = 50},
    unlock_condition = function(self, args)
        if args.type == 'fac_fish_caught' and G.PROFILES[G.SETTINGS.profile].fac_fishing.career_fish_caught >= self.config.amount then return true end
    end,
    display_progress = function(self)
        return G.PROFILES[G.SETTINGS.profile].fac_fishing.career_fish_caught .. '/' .. self.config.amount
    end
})

FishAndChips.Achievement({
    key = 'catch_3',
    config = {amount = 100},
    unlock_condition = function(self, args)
        if args.type == 'fac_fish_caught' and G.PROFILES[G.SETTINGS.profile].fac_fishing.career_fish_caught >= self.config.amount then return true end
    end,
    display_progress = function(self)
        return G.PROFILES[G.SETTINGS.profile].fac_fishing.career_fish_caught .. '/' .. self.config.amount
    end
})

FishAndChips.Achievement({
    key = 'catch_4',
    config = {amount = 1000},
    unlock_condition = function(self, args)
        if args.type == 'fac_fish_caught' and G.PROFILES[G.SETTINGS.profile].fac_fishing.career_fish_caught >= self.config.amount then return true end
    end,
    display_progress = function(self)
        return G.PROFILES[G.SETTINGS.profile].fac_fishing.career_fish_caught .. '/' .. self.config.amount
    end
})

FishAndChips.Achievement({
    key = 'perfect_1',
    config = {amount = 1},
    unlock_condition = function(self, args)
        if args.type == 'fac_fish_caught' and args.perfect and G.PROFILES[G.SETTINGS.profile].fac_fishing.career_perfect_catch >= self.config.amount then return true end
    end,
    display_progress = function(self)
        return G.PROFILES[G.SETTINGS.profile].fac_fishing.career_perfect_catch .. '/' .. self.config.amount
    end
})

FishAndChips.Achievement({
    key = 'perfect_2',
    config = {amount = 10},
    unlock_condition = function(self, args)
        if args.type == 'fac_fish_caught' and args.perfect and G.PROFILES[G.SETTINGS.profile].fac_fishing.career_perfect_catch >= self.config.amount then return true end
    end,
    display_progress = function(self)
        return G.PROFILES[G.SETTINGS.profile].fac_fishing.career_perfect_catch .. '/' .. self.config.amount
    end
})

FishAndChips.Achievement({
    key = 'perfect_3',
    config = {amount = 100},
    unlock_condition = function(self, args)
        if args.type == 'fac_fish_caught' and args.perfect and G.PROFILES[G.SETTINGS.profile].fac_fishing.career_perfect_catch >= self.config.amount then return true end
    end,
    display_progress = function(self)
        return G.PROFILES[G.SETTINGS.profile].fac_fishing.career_perfect_catch .. '/' .. self.config.amount
    end
})

FishAndChips.Achievement({
    key = 'snap_1',
    config = {amount = 1},
    unlock_condition = function(self, args)
        if args.type == 'fac_line_snapped' and G.PROFILES[G.SETTINGS.profile].fac_fishing.career_lines_snapped >= self.config.amount then return true end
    end,
    display_progress = function(self)
        return G.PROFILES[G.SETTINGS.profile].fac_fishing.career_lines_snapped .. '/' .. self.config.amount
    end
})

FishAndChips.Achievement({
    key = 'snap_2',
    config = {amount = 50},
    unlock_condition = function(self, args)
        if args.type == 'fac_line_snapped' and G.PROFILES[G.SETTINGS.profile].fac_fishing.career_lines_snapped >= self.config.amount then return true end
    end,
    display_progress = function(self)
        return G.PROFILES[G.SETTINGS.profile].fac_fishing.career_lines_snapped .. '/' .. self.config.amount
    end
})

FishAndChips.Achievement({
    key = 'treasure_1',
    config = {amount = 1},
    unlock_condition = function(self, args)
        if args.type == 'fac_fish_caught' and args.treasure and G.PROFILES[G.SETTINGS.profile].fac_fishing.career_treasure_caught >= self.config.amount then return true end
    end,
    display_progress = function(self)
        return G.PROFILES[G.SETTINGS.profile].fac_fishing.career_treasure_caught .. '/' .. self.config.amount
    end
})

FishAndChips.Achievement({
    key = 'treasure_2',
    config = {amount = 10},
    unlock_condition = function(self, args)
        if args.type == 'fac_fish_caught' and args.treasure and G.PROFILES[G.SETTINGS.profile].fac_fishing.career_treasure_caught >= self.config.amount then return true end
    end,
    display_progress = function(self)
        return G.PROFILES[G.SETTINGS.profile].fac_fishing.career_treasure_caught .. '/' .. self.config.amount
    end
})

FishAndChips.Achievement({
    key = 'treasure_3',
    config = {amount = 100},
    unlock_condition = function(self, args)
        if args.type == 'fac_fish_caught' and args.treasure and G.PROFILES[G.SETTINGS.profile].fac_fishing.career_treasure_caught >= self.config.amount then return true end
    end,
    display_progress = function(self)
        return G.PROFILES[G.SETTINGS.profile].fac_fishing.career_treasure_caught .. '/' .. self.config.amount
    end
})

FishAndChips.Achievement({
    key = 'treasure_fish',
    config = {amount = 1},
    unlock_condition = function(self, args)
        return args.type == 'fac_double_fish'
    end
})

local emplace_ref = CardArea.emplace
function CardArea:emplace(card, location, stay_flipped)
    emplace_ref(self, card, location, stay_flipped)
    if self == G.fac_fish_area then
        check_for_unlock({type = 'fac_add_fish'})
    end
end

FishAndChips.Achievement({
    key = 'bucket',
    config = {amount = 10},
    unlock_condition = function(self, args)
        return args.type == 'fac_add_fish' and #G.fac_fish_area.cards >= self.config.amount
    end
})

FishAndChips.Achievement({
    key = 'dollars_1',
    config = {amount = 100},
    unlock_condition = function(self, args)
        return args.type == 'fac_sand_dollars' and G.GAME.fac_sand_dollars >= self.config.amount
    end
})

FishAndChips.Achievement({
    key = 'dollars_2',
    config = {amount = 1000},
    unlock_condition = function(self, args)
        return args.type == 'fac_sand_dollars' and G.PROFILES[G.SETTINGS.profile].fac_fishing.career_sand_dollars >= self.config.amount
    end
})

FishAndChips.Achievement({
    key = 'early',
    unlock_condition = function(self, args)
        return args.type == 'fac_too_early'
    end
})

FishAndChips.Achievement({
    key = 'late',
    unlock_condition = function(self, args)
        return args.type == 'fac_fish_escaped'
    end
})

local add_to_deck_ref = Card.add_to_deck
function Card:add_to_deck(...)
    add_to_deck_ref(self, ...)
    if self.ability.set == 'Joker' then
        G.GAME.fac_no_jokers = false
    end
end

FishAndChips.Achievement({
    key = 'no_jokers',
    unlock_condition = function(self, args)
        return args.type == 'win' and G.GAME.fac_no_jokers
    end
})

for _, env in ipairs(FishAndChips.Environment.obj_buffer) do
    FishAndChips.Achievement({
        key = env..'_1',
        config = {type = env},
        unlock_condition = function(self, args)
            if args.type == 'fac_fish_caught' and args[self.config.type] then return true end
        end
    })
    
    FishAndChips.Achievement({
        key = env..'_2',
        config = {type = env},
        unlock_condition = function(self, args)
            if args.type == 'fac_fish_caught' and FishAndChips.is_environment_complete(self.config.type) then return true end
        end
    })
end

FishAndChips.Achievement({
    key = 'all_caught',
    unlock_condition = function(self, args)
        if args.type == 'fac_fish_caught' then
            for _, env in ipairs(FishAndChips.Environment.obj_buffer) do
                if not FishAndChips.is_environment_complete(env) then return false end
            end
            return true
        end
    end
})

local bait_achieves = {}
for _, bait in ipairs(FishAndChips.Bait.obj_buffer) do
    local a = FishAndChips.Achievement({
        key = bait..'_1',
        config = {type = bait, amount = 1},
        unlock_condition = function(self, args)
            if args.type == 'fac_fish_caught' and args.bait == self.config.type and G.PROFILES[G.SETTINGS.profile].fac_fishing.bait_data[G.GAME.fac_active_bait].fish_caught >= self.config.amount then return true end
        end
    })

    bait_achieves[#bait_achieves+1] = a
    
    a = FishAndChips.Achievement({
        key = bait..'_2',
        config = {type = bait, amount = 20},
        unlock_condition = function(self, args)
            if args.type == 'fac_fish_caught' and args.bait == self.config.type and G.PROFILES[G.SETTINGS.profile].fac_fishing.bait_data[G.GAME.fac_active_bait].fish_caught >= self.config.amount then return true end
        end
    })

    bait_achieves[#bait_achieves+1] = a
end

FishAndChips.Achievement({
    key = 'all_bait',
    unlock_condition = function(self, args)
        if args.type == 'fac_fish_caught' then
            for _, ach in ipairs(bait_achieves) do
                if not ach.earned then return false end
            end
            return true
        end
    end
})

FishAndChips.Achievement({
    key = 'all_rods',
    unlock_condition = function(self, args)
        if args.type == 'fac_rod_unlocked' then
            for _, rod in ipairs(G.P_CENTER_POOLS.fac_Rod) do
                if not rod.unlocked then return false end
            end
            return true
        end
    end
})

FishAndChips.Achievement({
    key = 'sell_1',
    config = {amount = 10},
    unlock_condition = function(self, args)
        return args.type == 'fac_fish_sold' and G.PROFILES[G.SETTINGS.profile].fac_fishing.career_fish_sold >= self.config.amount
    end
})

FishAndChips.Achievement({
    key = 'sell_2',
    config = {amount = 100},
    unlock_condition = function(self, args)
        return args.type == 'fac_fish_sold' and G.PROFILES[G.SETTINGS.profile].fac_fishing.career_fish_sold >= self.config.amount
    end
})

FishAndChips.Achievement({
    key = 'snapper_alt',
    unlock_condition = function (self, args)
        return args.type == 'fac_snapper_alt'
    end
})

local notify = notify_alert
function notify_alert(_achievement, _type)
    notify(_achievement, _type)
    local t = _type or 'achievement'
    if t == 'achievement' and _achievement ~= 'ach_fac_all_complete' then check_for_unlock({type = 'achievement_gained'}) end
end


FishAndChips.Achievement({
    key = 'all_complete',
    unlock_condition = function(self, args)
        if args.type == 'achievement_gained' then
            for _, ach in ipairs(FishAndChips.Compendium.get_achievements()) do
                if ach ~= self and not ach.earned then return false end
            end
            return true
        end
    end
})

-- all envs
