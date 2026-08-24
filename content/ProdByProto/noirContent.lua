local facp = FishAndChips.ProdByProto

--Noir Fish (duh)
facp.items = {
    soda = { x = 0, y = 0 },
    fabric = { x = 1, y = 0 },
    pen = { x = 2, y = 0 },
    bcard = { x = 3, y = 0 },
    booth = { x = 4, y = 0 },
    ledger = { x = 0, y = 1 },
    gun = { x = 1, y = 1 },
    knife = { x = 2, y = 1 },
    true_memo = { x = 3, y = 1},
    door = { x = 0, y = 2 },
    lockdoor = { x = 1, y = 2 },
    truedoor = { x = 1, y = 2 },
    key = { x = 2, y = 2 }
}

local item_keys = {}
for k in pairs(facp.items) do
    item_keys[#item_keys+1] = k
end

--[[ reqs:
A Rank 185+
B Rank 145+
C Rank ---
]]

facp.itemScores = {
    fabric = { Pts = 10, xPts = 0.9 },
    pen = { Pts = 10, xPts = 1.35 },
    bcard = { Pts = 20, xPts = 1.15 },
    ledger = { Pts = 40, xPts = 1.5 },
    gun = { Pts = 40, xPts = 1.35 },
    knife = { Pts = 50, xPts = 1.3 },
    true_memo = { Pts = 70, xPts = 1.7 },
}

facp.auxItems = {
    soda = true,
    door = true,
    lockdoor = true,
    truedoor = true,
    key = true,
    booth = true,
}

function facp.init_mark_sprite(pos)
    return SMODS.create_sprite(0, 0, G.CARD_W, G.CARD_H, "fac_proto_items", pos)
end

-- *feels the thunderedge*
-- this is our table of all currently initialized sprites
-- each key in this table should correspond to its respective sprite
facp.item_sprites = {}

SMODS.DrawStep({
    key = "proto_item",
    -- stickers also have an order of 40
    order = 40,
    func = function(self, layer)
        -- check if the card is marked and its mark corresponds to a valid mark in facp.items
        if self.ability and self.ability.noir_mark and facp.items[self.ability.noir_mark] then
            -- if item_sprites does not contain a sprite for our current mark, add that sprite to the table
            -- otherwise, we just use the already created sprite
            if not facp.item_sprites[self.ability.noir_mark] then
                facp.item_sprites[self.ability.noir_mark] =
                    facp.init_mark_sprite(facp.items[self.ability.noir_mark])
            end
            -- for drawing alignment purposes
            facp.item_sprites[self.ability.noir_mark].role.draw_major = self
            -- draw the actual sprite
            facp.item_sprites[self.ability.noir_mark]:draw_shader("dissolve", nil, nil, nil, self.children.center)
        end
    end,
    -- just to ensure that the sprite is not drawn at the wrong times
    conditions = { vortex = false, facing = "front" },
})


function facp.noirProg(args)
    if not args then return end
    G.E_MANAGER:add_event(Event({
        trigger = "immediate",
        no_delete = true,
        pause_force = false,
        blockable = true,
        blocking = false,
        func = function()
            SMODS.calculate_context{noir_flag = args.flg, noir_level = args.lvl}
            return true
        end
    }))
end

local noir_statelist = {
    "unstarted",
    "drink",
    "warehouse",
    "go_home",
    "call",
    "timed_search",
    "hearing",
    "chase",
    "finished"
}

local noir_states = {}
for i,v in ipairs(noir_statelist) do
    noir_states[v] = i
end

--For reference in case the refactor broke something. Should be safe to delete once playtesting confirms it's working as intended now.
local old_noir_levels = {
    --{item_key} or {{item_key,plotFlag,level}}
    { { "soda", 2, 2 },     false },
    { { "lockdoor", false, 3 }, "fabric",          "bcard",          "key" },
    { { "door", false, 2 }, { "pen" } },    -- remember to manually do plotFlag 3 and level 4. find all
    { false,                false },        -- remember to manually do plotFlag 4 and level 5. defeat blind
    { { "booth", 5, 6 } },
    { "key",                { "door", false, 7 } },
    { { "lockdoor", false, 8 }, { "lockdoor", false, 9 } },
    { "key",                "gun",                 { "door", false, 7 } },
    { "key",                "ledger",              { "door", false, 7 }, { "lockdoor", false, 10 } },
    { { "door", false, 9 }, { "truedoor", false, 11 }, "knife" },
    { { "door", false, 10 }, "true_memo" },      -- plotFlag 6, level 12. 15 hands, find all except memo w/o lockpick, or find all w/ lockpick
    { false,                false },
    { false,                false }
}

FishAndChips.Fish {
    key = "fac_proto_noir",
    atlas = "fac_proto_fish",

    pos = { x = 2, y = 0 },
    pixel_size = { w = 61, h = 32},

    stats = {
        weight = { min = 3.75, max = 4.5 },
        length = { min = 0.8, max = 1.4 }
    },
    weight = 25,
    ppu_coder = {"ProdByProto"},
    attributes = { "usable","modify_card", --Adding noir marks is a type of modification?
                    "economy", "chips", "xmult" },
    environments = facp.addEnvs(),

    config = {
        extra = {
            storyActive = false,
            storyComplete = false,
            storyState = noir_states.unstarted, --cursed case-mixing!

            new_noir_levels = {
                --Refactored this to be easier to comprehend
                --New format is { {key="item_key", plot = number, level = number} (repeat for each item), state = number }
                {--1: Get a soda
                    {key = "soda", plot = 2, level = 2},
                    state = noir_states.drink
                },
                {--2: Search the warehouse
                    {key = "lockdoor", level = 3},
                    {key = "fabric"},
                    {key = "bcard"},
                    {key = "key"},
                    state = noir_states.warehouse
                },
                {--3: Locked room in the warehouse
                    {key = "door", level = 2},
                    {key = "pen"},
                    state = noir_states.warehouse
                },
                {--4: No items, just defeat a blind to go home,
                    state = noir_states.go_home
                },
                {--5: Call the lady
                    {key = "booth", plot = 5, level = 6},
                    state = noir_states.call
                },
                {--6: Big search starting rooms
                    {key = "key"},
                    {key = "door", level = 7},
                    state = noir_states.timed_search
                },
                {--7: Another room
                    {key = "lockdoor", level = 8},
                    {key = "lockdoor", level = 9},
                    state = noir_states.timed_search
                },
                {--8: Further room
                    {key = "key"},
                    {key = "gun"},
                    {key = "door", level = 7},
                    state = noir_states.timed_search
                },
                {--9: Additional room
                    {key = "key"},
                    {key = "ledger"},
                    {key = "door", level = 7},
                    {key = "lockdoor", level = 10},
                    state = noir_states.timed_search
                },
                {--10: Room with a Mysterious Superwholocked Door *murdered for tumblr crimes*
                    {key = "door", level = 9},
                    {key = "truedoor", level = 11},
                    {key = "knife"},
                    state = noir_states.timed_search
                },
                {--11: Find the true memo, unlock the true ending!
                    {key = "door", level = 10},
                    {key = "true_memo"},
                    state = noir_states.timed_search
                },
                {--12: Final hearing
                    {},
                    state = noir_states.hearing
                },
                {--13: Chase
                    {},
                    state = noir_states.chase
                },
                {--14: Postgame
                    {},
                    state = noir_states.finished
                },
            },
            nearest_starter_level = {
                1,2,2,4,5,6,6,6,6,6,6,12,13
            },
            noir_keys = 0,
            noir_inv = {},
            evidence_presented = {},
            level = 0,
            final_investigation = false,
            final_court = false,
            playing_true_end = false,
            hand_limit = false,
            finalScore = 0

        }
    },
    blueprint_compat = false,

    loc_vars = function(self, info_queue, card)
        local cae = card.ability.extra
        local vars_ = {}
        if cae.storyComplete then
            vars_[#vars_+1] = math.floor(cae.finalScore/10)
            if cae.finalScore > 144 then vars_[#vars_+1] = cae.finalScore*2 end
            if cae.finalScore > 184 then vars_[#vars_+1] = cae.finalScore/100 end
        end
        return({
            key = self.key .. (cae.storyComplete and '_complete_' .. #vars_ or ''),
            vars = vars_,
        })
    end,


    use = function (self, card)
        local ca = card.ability
        G.GAME.proto_noirshade = not G.GAME.proto_noirshade
        if not ca.extra.storyActive then
            G.GAME.proto_q_music = "noir1"
            G.ARGS.push.type = 'restart_music'
            G.SOUND_MANAGER.channel:push(G.ARGS.push)
            facp.noirProg({ flg = 1, lvl = 1})
            ca.eternal = true
            ca.extra.storyActive = true
        end
    end,

    can_use = function(self, card)
        local cae = card.ability.extra
        local valid_area = (card.area and not card.area.config.fac_catch_area)
        return (not cae.storyActive or not cae.storyComplete) and valid_area
    end,

    keep_on_use = function(self,card)
        return true
    end,

    remove_from_deck = function (self, card, from_debuff)
        if not from_debuff then
            G.GAME.proto_noirshade = nil
            G.GAME.proto_q_music = "false"
        end
    end,

    calculate = function(self, card, context)
        local cae = card.ability.extra
        local ret = {}

        --#region helper functions
        local function noir_trigger(triggered_card)
            triggered_card.noir_triggered = true
            G.E_MANAGER:add_event(Event({
                func = function()
                    triggered_card.ability.noir_triggered = nil
                    return true;
                end
            }))
        end

        local function remove_item_from_current_level(item_key)
            for i, item_data in pairs(cae.new_noir_levels[cae.level]) do
                if item_key == item_data.key then
                    table.remove(cae.new_noir_levels[cae.level], i)
                    break
                end
            end
        end

        local function unlock_door(key_card)
            for i,v in ipairs(cae.new_noir_levels[cae.level]) do
                if v.key == "lockdoor" and (key_card.ability.noir_plot == v.plot or key_card.ability.noir_level == v.level) then
                    v.key = "door"
                    key_card:juice_up()
                end
            end
        end

        local function use_door(door_card)
            local doormark = door_card.ability.noir_mark
            if not string.find(doormark or "", "door") then
                return false
            end
            if (cae.noir_keys <= 0 and doormark == "lockdoor") or doormark == "truedoor" then
                return false
            elseif cae.noir_keys > 0 and doormark == "lockdoor" then
                unlock_door(door_card)
                cae.noir_keys = cae.noir_keys - 1
                door_card.ability.noir_mark = "door"
            end

            facp.noirProg({ flg = flag, lvl = level })
            return true
        end

        local function claim_item(item_card)
            if cae.storyState == noir_states.chase then cae.hand_limit = cae.hand_limit + 2 end
            local mark = item_card.ability.noir_mark
            if not item_card.ability.aux then
                cae.noir_inv[#cae.noir_inv+1] = mark
                remove_item_from_current_level(mark)
                item_card.ability.noir_mark = nil
                noir_trigger(item_card)
            end
            use_door(item_card)
        end
        --#endregion

        local storyState = cae.storyState

        if storyState == noir_states.finished then
            if context.modify_final_cashout then
                local money = math.max(0, math.floor(cae.finalScore/10))
                if money > 0 then
                    return { sand_dollars = money }
                end
            end

            if cae.finalScore > 144 and context.joker_main then
                ret.chips = cae.finalScore * 2
                if cae.finalScore > 184 then
                    ret.xmult = cae.finalScore/100
                end

                return ret
            end
        end

        if context.setting_blind and G.GAME.noir_popup then
            G.GAME.noir_popup = false
        end

        if storyState == noir_states.drink then
            if context.individual and context.cardarea == G.play and not context.other_card.noir_triggered and context.other_card.ability.noir_mark == "soda" and context.other_card.ability.noir_level then
                G.GAME.proto_q_music = "noir2"
                noir_trigger(context.other_card)
            end
            facp.noirProg({ flg = context.other_card.ability.noir_plot, lvl = context.other_card.ability.noir_level })
        end

        if storyState == noir_states.warehouse then
            if context.individual and context.cardarea == G.play and context.other_card.ability.noir_mark and not context.other_card.noir_triggered then
                if context.other_card.ability.noir_mark == "key" then
                    cae.noir_keys = cae.noir_keys + 1
                    remove_item_from_current_level("key")
                    noir_trigger(context.other_card)
                    context.other_card.ability.noir_mark = nil
                elseif context.other_card.ability.noir_mark == "lockdoor" then
                    if cae.noir_keys > 0 then
                        unlock_door(context.other_card)
                        return {
                            message = localize("proot_noir_unlock")
                        }
                    else
                        return {
                            message = localize("proot_noir_locked")
                        }
                    end
                end
            end

            if context.after then
                local need = {
                    fabric = true,
                    bcard = true,
                    pen = true,
                }
                local total = 0
                for _,item in pairs(cae.noir_inv) do
                    if need[item] then total = total + 1 end
                end
                if total > 2 then
                    facp.noirProg({ flg = 3, lvl = 4 })
                    G.GAME.noir_popup = true
                end
            end
        end

        if storyState == noir_states.go_home then
            if context.end_of_round and context.main_eval and not G.GAME.noir_popup then
                facp.noirProg({ flg = 4, lvl = 5 })
            end
        end

        if storyState == noir_states.call then
            if context.individual and context.cardarea == G.play and context.other_card.ability.noir_mark == "booth" and not context.other_card.noir_triggered then
                noir_trigger(context.other_card)
                remove_item_from_current_level(context.other_card.ability.noir_mark)
                facp.noirProg({ flg = context.other_card.ability.noir_plot, lvl = context.other_card.ability.noir_level })
            end
        end

        if storyState == noir_states.timed_search then
            if context.hand_drawn then
                if SMODS.find_card("fish_fac_proto_lockpick")[1] then
                    for _,pcard in ipairs(context.hand_drawn) do
                        if pcard.ability.noir_mark == "truedoor" then
                            juice_card_until(pcard,(function() return (context.using_consumeable and context.consumeable.config.center_key == "fish_fac_proto_lockpick") or pcard.ability.noir_mark ~= "truedoor" end))
                        end
                    end
                end
            end

            if context.press_play then
                cae.hand_limit = cae.hand_limit - 1
                return {
                    message = cae.hand_limit.." "..localize("proot_noir_hands")
                }
            end

            if context.individual and context.cardarea == G.play and context.other_card.ability.noir_mark and not context.other_card.noir_triggered then
                claim_item(context.other_card)
            end
            if context.final_scoring_step then
                local should_progress = cae.hand_limit <= 0
                if not should_progress then
                    local true_memo_needed = (G.GAME.fac_proto_noir_lockpick_used or next(SMODS.find_card("fish_fac_proto_lockpick")))
                    local needed = {
                        gun = true,
                        ledger = true,
                        knife = true,
                        true_memo = true_memo_needed
                    }
                    local unfound = true_memo_needed and 4 or 3
                    for _,v in ipairs(cae.noir_inv) do
                        if needed[v] then
                            unfound = unfound - 1
                        end
                    end
                    if unfound <= 0 then should_progress = true end
                end
                if should_progress then
                    facp.noirProg({flg = 6, lvl = 12})
                end
            end
        end

        if storyState == noir_states.hearing then
            if context.press_play then
                cae.hand_limit = cae.hand_limit - 1
                return {
                    message = cae.hand_limit.." "..localize("proot_noir_hands")
                }
            end

            if context.individual and context.cardarea == G.play and context.other_card.ability.noir_mark and not context.other_card.noir_triggered then
                local mark = context.other_card.ability.noir_mark
                G.GAME.noir_pts = G.GAME.noir_pts + facp.itemScores[mark].Pts
                G.GAME.noir_pts = G.GAME.noir_pts * facp.itemScores[mark].xPts
                cae.evidence_presented[#cae.evidence_presented+1] = mark
                if #cae.evidence_presented > 2 then
                    cae.noir_inv = cae.evidence_presented
                    for i,_ in ipairs(cae.noir_inv) do
                        local level
                        local flag = 7
                        if cae.trueEnd then
                            flag = 8
                            level = 13
                        end
                        facp.noirProg({ flg = flag, lvl = level })
                    end
                end
            end

            if context.final_scoring_step and not cae.trueEnd then
                if cae.hand_limit <= 0 then
                    facp.noirProg({flg = 7, lvl = 14})
                end
            end
        end

        if storyState == noir_states.chase then
            if context.press_play then
                cae.hand_limit = cae.hand_limit - 1
                return {
                    message = cae.hand_limit.." / 10"
                }
            end

            if context.hand_drawn then
                for _,pcard in ipairs(G.hand.cards) do
                    pcard.ability.noir_mark = nil
                end
                local item_card = pseudorandom_element(G.hand.cards,"noir_item")
                item_card.ability.noir_mark = pseudorandom_element(item_keys,"noir_mark_item")
            end

            if context.individual and context.cardarea == G.play and context.other_card.ability.noir_mark and not context.other_card.noir_triggered then
                claim_item(context.other_card)
            end

            if context.final_scoring_step then
                if cae.hand_limit >= 10 then
                    cae.storyActive = false
                    cae.storyComplete = true
                    cae.finalScore = G.GAME.noir_pts or 0
                    facp.noirProg({flg = 7, lvl = 14})
                elseif cae.hand_limit <= 0 then
                    SMODS.destroy_cards(card, {pinch_anim = true, bypass_eternal = true})
                end
            end
        end

        if cae.storyActive then
            if context.noir_level then
                cae.level = context.noir_level
                local oldstate = cae.storyState
                cae.storyState = cae.new_noir_levels[context.noir_level].state
                if cae.storyState ~= oldstate then
                    if cae.storyState == noir_states.warehouse then
                        G.GAME.proto_q_music = "noir2"
                    elseif cae.storyState == noir_states.timed_search then
                        cae.final_investigation = 1
                        cae.hand_limit = 20
                    elseif cae.storyState == noir_states.hearing then
                        cae.final_court = 1
                        cae.hand_limit = 7
                        G.GAME.noir_pts = 0
                    elseif cae.storyState == noir_states.chase then
                        cae.hand_limit = 3
                    end
                end
                for _,item in ipairs(cae.noir_inv) do
                    if item == "true_memo" then cae.trueEnd = true end -- "trueEnd = true end"... absolute cinema
                end
                if cae.trueEnd then cae.playing_true_end = 1 end
                if cae.final_court then
                    for i,jtem in ipairs(cae.noir_inv) do
                        cae.new_noir_levels = {key=jtem}
                    end
                end
                facp.loadLevel(card,context.noir_level)
            end

            if context.noir_flag then
                G.FUNCS.overlay_menu{ definition = facp.noirDialog(context.noir_flag)}
            end
        end
    end

}

--Lockpick
FishAndChips.Fish {
    key = "fac_proto_lockpick",
    atlas = "fac_proto_fish",

    pos = { x = 3, y = 0 },
    pixel_size = {w = 53, h = 8},

    stats = {
        weight = { min = 0.015, max = 0.020 },
        length = { min = 0.05, max = 0.1 }
    },
    weight = 20,
    ppu_coder = {"ProdByProto"},
    attributes = { "usable" },
    environments = facp.addEnvs(),

    in_pool = function (self, args)
        return #SMODS.find_card("fac_proto_noir") > 0
    end,

    can_use = function (self, card)
        for _,held_card in ipairs(G.hand.cards) do
            if held_card.ability.noir_mark == "truedoor" then
                return true
            end
        end
    end,

    use = function (self, card)
        for _,held_card in ipairs(G.hand.cards) do
            if held_card.ability.noir_mark == "truedoor" then
                held_card.ability.noir_mark = "door"
                G.GAME.fac_proto_noir_lockpick_used = true
            end
        end
    end,


    calculate = function(self, card, context)
        local cae = card.ability.extra

        if context.hand_drawn then
            for _,held_card in ipairs(context.hand_drawn) do
                if held_card.ability.noir_mark == "truedoor" then
                    juice_card_until(self,(function() return context.using_consumeable and context.consumeable == self end))
                end
            end
        end

    end,
}
