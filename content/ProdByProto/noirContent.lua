local fac = SMODS.Mods["FishAndChips"]
local loadFihHook = FishAndChips.ProdByProto.loadFih
FishAndChips.ProdByProto.loadFih = function()

	if loadFihHook then loadFihHook() end
	
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

    facp.auxItems = { "soda","door","lockdoor","truedoor","key","booth" }

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
        G.E_MANAGER:add_event(Event({
            trigger = "immediate",
            no_delete = true,
            pause_force = false,
            blockable = true,
            blocking = false,
            func = function()
                local contextTable = {}
                if args.flg then contextTable["noir_flag"] = args.flg end
                if args.lvl then contextTable["noir_level"] = args.lvl end
                SMODS.calculate_context(contextTable)
                return true
            end
        }))
    end

    FishAndChips.Fish {
        key = "fac_proto_noir",
        atlas = "fac_proto_fish",
		mod = fac,
		pos = { x = 2, y = 0 },
        pixel_size = { w,h = 61,32},

        stats = {
            weight = { min = 3.75, max = 4.5 },
            length = { min = 0.8, max = 1.4 }
        },
        weight = 25,
        ppu_coder = {"ProdByProto"},
        attributes = { "usable","generation","destroy_card" },
        environments = facp.addEnvs(),

        config = {
            extra = {
                storyActive = false,
                storyComplete = false,
                noir_music = {

                },
                noir_levels = {
                    --{item_key} or {{item_key,plotFlag,level}}
                    {{"soda",2,2},false},
                    {{"lockdoor",false,3},"fabric","bcard","key"},
                    {{"door",false,2},{"pen"}}, -- remember to manually do plotFlag 3 and level 4. find all
                    {false,false}, -- remember to manually do plotFlag 4 and level 5. defeat blind
                    {{"booth",5,6}},
                    {"key",{"door",false,7}},
                    {{"lockdoor",false,8},{"lockdoor",false,9}},
                    {"key","gun",{"door",false,7}},
                    {"key","ledger",{"door",false,7},{"lockdoor",false,10}},
                    {{"door",false,9},{"truedoor",false,11},"knife"},
                    {{"door",false,10},"true_memo"}, -- plotFlag 6, level 12. 15 hands, find all except memo w/o lockpick, or find all w/ lockpick 
                    {false,false},
                    {false,false}
                },
                nearest_starter_level = {
                    1,2,2,4,5,6,6,6,6,6,6,12,13
                },
                noir_keys = 0,
                noir_inv = {},
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
            cae = card.ability.extra
            local vars_ = {}
            if cae.storyComplete then
                vars_[#vars_+1] = localize({type = "variable", key = "proot_sanddoller", vars = {math.floor(cae.finalScore/10)}})
                if cae.finalScore > 144 then vars_[#vars_+1] = "{C:chips}"..localize({type = "variable", key = "a_chips", vars = {cae.finalScore*2}}) else vars_[#vars_+1] = " " end
                if cae.finalScore > 184 then vars_[#vars_+1] = "{C:white,X:mult}"..localize({type = "variable", key = "a_xmult", vars = {cae.finalScore/100}}) else vars_[#vars_+1] = " " end
            else
                vars_[#vars_+1] = " "
                vars_[#vars_+1] = localize("proot_noir_desc")
                vars_[#vars_+1] = " "
            end
            return({vars = vars_})
        end,


        use = function (self, card)
            local ca = card.ability
            G.GAME.proto_noirshade = not G.GAME.proto_noirshade
            if not ca.extra.storyActive then
                G.ARGS.push.type = 'restart_music'
                G.SOUND_MANAGER.channel:push(G.ARGS.push)
                G.GAME.proto_q_music = "noir1"
                facp.noirProg({ flg = 1, lvl = 1})
                ca.eternal = true
                ca.extra.storyActive = true
            end
        end,

        can_use = function(self, card)
            local cae = card.ability.extra
            return not cae.storyActive or not cae.storyComplete
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
            local trueEnd = false

            if cae.storyActive then
                if context.individual and context.cardarea == G.play then
                    if context.other_card.ability.noir_mark then
                        if cae.playing_true_end then cae.hand_limit = cae.hand_limit + 2 end
                        if not context.other_card.ability.aux then
                            cae.noir_inv[#cae.noir_inv+1] = context.other_card.ability.noir_mark
                            for i,item in pairs(cae.noir_levels[cae.level]) do
                                if context.other_card.ability.noir_mark == (item[1] or item) then
                                    table.remove(cae.noir_levels[cae.level],i)
                                    break
                                end
                            end
                            context.other_card.ability.noir_mark = nil
                        end
                        if context.other_card.ability.noir_mark == "key" then
                            cae.noir_keys = cae.noir_keys + 1
                            for i,item in pairs(cae.noir_levels[cae.level]) do
                                if context.other_card.ability.noir_mark == (item[1] or item) then
                                    table.remove(cae.noir_levels[cae.level],i)
                                    break
                                end
                            end
                            context.other_card.ability.noir_mark = nil
                        end
                        if context.other_card.ability.noir_mark == "lockdoor" then
                            if cae.noir_keys - 1 > -1 then
                                juice_card(context.other_card)
                                context.other_card.ability.noir_mark = "door"
                                for i,item in pairs(cae.noir_levels[cae.level]) do
                                    if context.other_card.ability.noir_mark == item[1] and ((context.other_card.ability.noir_plot and item[2] and context.other_card.ability.noir_plot == item[2]) or (context.other_card.ability.noir_level and item[3] and context.other_card.ability.noir_level == item[3])) then
                                        if cae.noir_levels[cae.level][i][1] then cae.noir_levels[cae.level][i][1] = "door" else cae.noir_levels[cae.level][i] = "door" end
                                        cae.noir_keys = cae.noir_keys - 1
                                        ret.message = (localize("proot_noir_unlock"))
                                        break
                                    end
                                end
                            else
                                ret.message = (localize("proot_noir_locked"))
                            end
                        end
                        if cae.final_court then
                            if not G.GAME.noir_pts then G.GAME.noir_pts = 0
                            G.GAME.noir_pts = G.GAME.noir_pts + facp.itemScores[context.other_card.ability.noir_mark].Pts
                            G.GAME.noir_pts = G.GAME.noir_pts * facp.itemScores[context.other_card.ability.noir_mark].xPts
                                if #cae.noir_inv > 2 then
                                    for i,_ in ipairs(cae.noir_inv) do
                                        local level = false
                                        if i > 3 then
                                            cae.noir_inv[i] = nil
                                        end
                                        local flag = 7
                                        if trueEnd then
                                            flag = 8
                                            level = 13
                                        end
                                        facp.noirProg({ flg = flag, lvl = level })
                                    end
                                end
                            end
                        end
                        if context.other_card.ability.noir_mark == "truedoor" then ret.message = (localize("proot_noir_locked")) end
                    end
                    auxFound = nil
                    if not (context.other_card.ability.noir_mark == "truedoor" or context.other_card.ability.noir_mark == "lockdoor") then
                        if context.other_card.ability.noir_mark == "soda" and context.other_card.ability.noir_level then G.GAME.proto_q_music = "noir2" end
                        facp.noirProg({ flg = context.other_card.ability.noir_plot, lvl = context.other_card.ability.noir_level })
                    end
                    return ret
                end

                if context.after and cae.level < 4 then
                    local need = { "fabric","bcard","pen" }
                    local total = 0
                    for _,item in pairs(cae.noir_inv) do
                        for _, itemCheck in pairs(need) do
                            total = total + ((item == itemCheck and 1) or 0)
                        end
                    end
                    if total > 2 then
                        facp.noirProg({ flg = 3, lvl = 4 })
                        G.GAME.noir_popup = true
                    end
                end

                if context.setting_blind and G.GAME.noir_popup then
                    G.GAME.noir_popup = false
                end

                if context.end_of_round and cae.level == 4 and not G.GAME.noir_popup then
                    facp.noirProg({ flg = 4, lvl = 5 })
                end

                if context.hand_drawn then
                    if SMODS.find_card("fish_fac_proto_lockpick")[1] then
                        for _,card in ipairs(context.hand_drawn) do
                            if card.ability.noir_mark == "truedoor" then
                                juice_card_until(card,(function() return context.using_consumeable and context.consumeable == self end))
                            end
                        end
                    end
                end

                if context.hand_drawn and cae.playing_true_end then
                    for _,card in G.hand.cards do
                        card.ability.noir_mark = nil
                    end
                    local item_card = pseudorandom_element(G.hand.cards,"noir_item")
                    local item_keys = {}
                    for k,_ in pairs(facp.items) do
                        item_keys[#item_keys+1] = k
                    end
                    item_card.ability.noir_mark = pseudorandom_element(item_keys,"noir_mark_item")
                end

                if context.press_play then
                    if cae.final_investigation == 1 then
                        cae.hand_limit = 20
                        cae.final_investigation = 2
                    elseif cae.final_court == 1 then
                        cae.hand_limit = 7
                        cae.final_court = 2
                    elseif cae.playing_true_end == 1 then
                        cae.hand_limit = 3
                        cae.playing_true_end = 2
                    end
                    if cae.hand_limit then
                        cae.hand_limit = cae.hand_limit - 1
                        ret.message = cae.hand_limit..(not not cae.playing_true_end and (" / 10 ") or "")..localize("proot_noir_hands")
                        if cae.hand_limit > 9 then
                            cae.storyActive = false
                            cae.storyComplete = true
                            cae.finalScore = G.GAME.noir_pts or 0
                            facp.noirProg({flg = 7, lvl = 14})
                        end
                        if cae.hand_limit < 1 then
                            if cae.final_investigation then
                                facp.noirProg({flg = 6, lvl = 12})
                            end
                            if cae.playing_true_end then
                                SMODS.destroy_cards(self,nil,nil,true)
                            end
                        end
                    end
                end

                if context.noir_level then
                    cae.level = context.noir_level
                    if cae.level == 2 then G.GAME.proto_q_music = "noir2" end
                    if cae.level == 6 then cae.final_investigation = 1 end
                    if cae.level == 12 then cae.final_court = 1 end
                    for _,item in ipairs(cae.noir_inv) do
                        if item == "true_memo" then trueEnd = 1 end -- "trueEnd = true end"... absolute cinema
                    end
                    if trueEnd then cae.playing_true_end = 1 end
                    if cae.final_court then 
                        for i,jtem in ipairs(cae.noir_inv) do
                            cae.noir_levels[cae.level][i] = jtem
                        end
                    end
                    facp.loadLevel(card,context.noir_level)
                end

                if context.noir_flag then
                    G.FUNCS.overlay_menu{ definition = facp.noirDialog(context.noir_flag)}
                end
            end

            if cae.storyComplete then
                if context.modify_final_cashout then
                    local money = math.max(0, math.floor(cae.finalScore/10))
                    if money > 0 then
                        return { sand_dollars = money }
                    end
                end

                if cae.finalScore > 144 then
                    if context.joker_main then
                        return{ chips = cae.finalScore * 2}
                    end
                end

                if cae.finalScore > 184 then
                    if context.joker_main then
                        return{ xmult = cae.finalScore/100 }
                    end
                end
            end
        end

    }

    --Lockpick
    FishAndChips.Fish {
		key = "fac_proto_lockpick",
		atlas = "fac_proto_fish",
		mod = fac,
		pos = { x = 3, y = 0 },
        pixel_size = {w,h = 53,8},

		stats = {
			weight = { min = 0.015, max = 0.020 },
			length = { min = 0.05, max = 0.1 }
		},
		weight = 20,
		ppu_coder = {"ProdByProto"},
		attributes = { "usable" },
		environments = facp.addEnvs(),

		config = {
			extra = {

			}
		},

		loc_vars = function(self, info_queue, card)
			
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
end