local facp = FishAndChips.ProdByProto

local dprint = function (...)
    local StillDebugging = false --change to true to see debug prints again if something goes horribly wrong
    if StillDebugging then return print(...) end
end

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
    if not (args and (args.flg or args.lvl)) then return end

    dprint("Attempting to "..(args.flg and "activate plot flag "..args.flg.." and " or "")..("travel to area "..(args.lvl or "idfk")))

    G.E_MANAGER:add_event(Event({
        trigger = "immediate",
        no_delete = true,
        pause_force = false,
        blockable = true,
        blocking = false,
        func = function()
            SMODS.calculate_context{noir_flag = args.flg, noir_level = args.lvl, fac_proto_progressing_noir_story = true}
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
            nearest_starter_level = { --ngl I do not know why
                1, --0
                2, --0
                2, --1
                4, --0
                5, --0
                6, --0
                6, --1
                6, --2
                6, --3
                6, --4
                6, --5
                12, --0
                13, --0 
            },
            noir_keys = 0,
            noir_inv = {},
            evidence_presented = {},
            level = 0,
            final_investigation = false,
            final_court = false,
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
        if not (ca.extra.storyActive or ca.extra.storyComplete) then
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
        return not cae.storyComplete and valid_area
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

        if context.remove_playing_cards then
            for i, v in ipairs(context.removed) do
                if v.ability.noir_mark then
                    local noirflags = {}
                    for kk, vv in pairs(v.ability) do
                        if string.find(kk, "noir") then
                            noirflags[kk] = vv
                        end
                    end

                    local unmarked_cards = {}
                    for ii,vv in ipairs(G.playing_cards) do
                        if not vv.ability.noir_mark then
                            unmarked_cards[#unmarked_cards+1] = vv
                        end
                    end

                    local new_card = pseudorandom_element(unmarked_cards, "fac_move_noir_mark")
                    for kk,vv in pairs(noirflags) do
                        new_card.ability[kk] = vv
                    end
                end
            end
        end

        if context.fac_proto_progressing_noir_story then
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
                    elseif cae.storyState == noir_states.finished then
                        cae.storyActive = false
                        cae.storyComplete = true
                        card.ability.eternal = false
                    end
                end
                if cae.final_court then
                    local court_items = {}
                    for i, jtem in ipairs(cae.noir_inv) do
                        court_items[#court_items+1] = { key = jtem }
                    end
                    court_items.state = cae.new_noir_levels[12].state
                    cae.new_noir_levels[12] = court_items
                end
                facp.loadLevel(card, context.noir_level)
            end

            if context.noir_flag then
                G.FUNCS.overlay_menu { definition = facp.noirDialog(context.noir_flag) }
            end
        end

        --#region helper functions
        local function noir_trigger(triggered_card)
            triggered_card.noir_triggered = true
            G.E_MANAGER:add_event(Event({
                func = function()
                    triggered_card.ability.noir_triggered = nil --kinda an artifact, this is handled in the dev object now, but probably better to leave it
                    triggered_card:juice_up()
                    return true;
                end
            }))
        end

        local function remove_item_from_current_level(item_key)
            dprint"Removing item"
            local removed
            for i, item_data in ipairs(cae.new_noir_levels[cae.level]) do
                if item_key == item_data.key then
                    removed = table.remove(cae.new_noir_levels[cae.level], i)
                    break
                end
            end
            if removed then
                for _,v in ipairs(G.playing_cards) do
                    if v.noir_mark == removed.key and v.noir_plot == v.plot and v.noir_level == v.level then
                        v.noir_mark = nil
                        v.noir_plot = nil
                        v.noir_level = nil
                        break
                    end
                end
            end
        end

        local function use_door(door_card)
            local doormark = door_card.ability.noir_mark
            if not string.find(doormark or "", "door") then
                return false
            end
            noir_trigger(door_card)
            dprint"Using door"
            if (cae.noir_keys <= 0 and doormark == "lockdoor") or doormark == "truedoor" then
                dprint"Locked, no key"
                SMODS.calculate_effect{message = localize("proot_noir_locked"), card = door_card}
                return false
            elseif cae.noir_keys > 0 and doormark == "lockdoor" then
                dprint"Unlocking"
                cae.noir_keys = cae.noir_keys - 1
                door_card.ability.noir_mark = "door"
                for i,v in ipairs(cae.new_noir_levels[cae.level]) do
                    if v.level == door_card.ability.noir_level then
                        v.key = "door"
                    end
                end
                SMODS.calculate_effect{message = localize("proot_noir_unlocked"), card = door_card}
            end

            local flag, level = door_card.ability.noir_plot, door_card.ability.noir_level
            facp.noirProg({ flg = flag, lvl = level })
            return true
        end

        local function claim_item(item_card)
            dprint"Claiming item"
            local mark = item_card.ability.noir_mark
            if cae.storyState == noir_states.chase then
                cae.hand_limit = cae.hand_limit + 2
            else
                if not item_card.ability.aux then
                    if mark == "key" then
                        cae.noir_keys = cae.noir_keys + 1
                    else
                        cae.noir_inv[#cae.noir_inv+1] = mark
                    end
                end
            end
            if not item_card.ability.aux then
                G.E_MANAGER:add_event(Event{
                    func = function ()
                        remove_item_from_current_level(mark)
                        item_card.ability.noir_mark = nil
                        return true
                    end
                })
            end
            noir_trigger(item_card)
            if cae.storyState ~= noir_states.chase then
                use_door(item_card)
            end
        end
        --#endregion

        local storyState = cae.storyState

        if storyState == noir_states.finished then

            if cae.finalScore > 144 and context.joker_main then
                local ret = {}
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

        if context.retrigger_joker or not cae.storyActive then return end

        if storyState == noir_states.drink then
            if context.individual and context.cardarea == G.play and not context.other_card.noir_triggered and context.other_card.ability.noir_mark == "soda" and context.other_card.ability.noir_level then
                G.GAME.proto_q_music = "noir2"
                noir_trigger(context.other_card)
                facp.noirProg({ flg = context.other_card.ability.noir_plot, lvl = context.other_card.ability.noir_level })
            end
        end

        if storyState == noir_states.warehouse then
            if context.individual and context.cardarea == G.play and context.other_card.ability.noir_mark and not context.other_card.noir_triggered then
                claim_item(context.other_card)
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
                dprint("Calling the lady...")
                noir_trigger(context.other_card)
                remove_item_from_current_level(context.other_card.ability.noir_mark)
                facp.noirProg({ flg = context.other_card.ability.noir_plot, lvl = context.other_card.ability.noir_level })
            end
        end

        if storyState == noir_states.timed_search then
            if context.press_play then
                cae.hand_limit = cae.hand_limit - 1
                return {
                    message = cae.hand_limit.." "..localize("proot_noir_hands")
                }
            end

            if context.individual and context.cardarea == G.play and context.other_card.ability.noir_mark and not context.other_card.noir_triggered then
                claim_item(context.other_card)
            end
            if context.after then
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

            if context.individual and context.cardarea == G.play and context.other_card.ability.noir_mark and not context.other_card.noir_triggered and #cae.evidence_presented < 3 then
                noir_trigger(context.other_card)
                print"Presenting evidence"
                local mark = context.other_card.ability.noir_mark
                G.GAME.noir_pts = G.GAME.noir_pts + facp.itemScores[mark].Pts
                G.GAME.noir_pts = G.GAME.noir_pts * facp.itemScores[mark].xPts
                cae.evidence_presented[#cae.evidence_presented+1] = mark
            end

            if context.after then
                if #cae.evidence_presented >= 3 then
                    cae.noir_inv = {}
                    for i,v in ipairs(cae.evidence_presented) do
                        if i>3 then
                            cae.evidence_presented[i] = nil
                        else
                            cae.noir_inv[i] = v
                        end
                    end

                    local level = 14
                    local flag = 7
                    
                    for i,v in ipairs(cae.noir_inv) do
                        dprint(v)
                        if v == "true_memo" then
                            dprint("Beginning true ending!")
                            flag = 8
                            level = 13
                            cae.trueEnd = true
                        end --Is it still absolute cinema if there's a line break in between...?
                    end
                    facp.noirProg({ flg = flag, lvl = level })
                end

                if cae.hand_limit <= 0 and not cae.trueEnd then
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

            if context.after then
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
    end,
    calc_sand_dollar_bonus = function(self, card)
        local cae = card.ability.extra
        local storyState = cae.storyState

        if storyState == noir_states.finished then
            local money = math.max(0, math.floor(cae.finalScore/10))
            if money > 0 then
                return money
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
        return #SMODS.find_card("fish_fac_proto_noir") > 0
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

        local noir_fish = SMODS.find_card("fish_fac_proto_noir")[1]
        if not noir_fish then return end
        local cae = noir_fish.ability.extra

        for i,v in ipairs(cae.new_noir_levels[cae.level]) do
            if v.key == "truedoor" then
                v.key = "door"
            end
        end
    end,


    calculate = function(self, card, context)
        local cae = card.ability.extra

        if context.hand_drawn then
            dprint"Checking for true door..."
            G.E_MANAGER:add_event(Event{
                func = function ()
                    for _,held_card in ipairs(G.hand.cards) do
                        if held_card.ability.noir_mark == "truedoor" then
                            dprint"True door found!"
                            local check = function ()
                                return not (
                                card.REMOVED
                                or held_card.REMOVED
                                or held_card.ability.noir_mark ~= "truedoor"
                                or held_card.area ~= G.hand
                                )
                            end

                            juice_card_until(held_card,check)
                            juice_card_until(card,check)
                            break
                        end
                    end
                    return true
                end
            })
        end
    end,
}
