FishAndChips.radiation_eremel = {}

SMODS.Atlas({
    key = 'radiation_eremel_credits',
    path = 'radiation_eremel/credits.png',
    px = 142, py = 80
})

SMODS.Atlas({
    key = 'galdur_grave',
    path = 'radiation_eremel/grave.png',
    px = 31, py = 31
})

PotatoPatchUtils.Developer({
	name = 'eremel',
    loc = true,
	atlas = 'fac_radiation_eremel_credits',
    joint_credits = true,
	colour = HEX('3FC7EB'),
	fac_partner = 'fac_radiation',
    loc_vars = function()
        return {vars = {elements = {SMODS.create_sprite(0,0,0.4,0.4,SMODS.get_atlas('fac_galdur_grave'), {x=0, y=0})}}, scale = 1.2}
    end,
    calculate = function(self, context)
        if context.fac_fish_caught and G.P_CENTERS[context.fish].set == 'fac_Fish' then
            G.GAME.fac_r_e_last_fish = context.fish
        end
        if context.end_of_round and context.main_eval then
            for _, pcard in ipairs(G.playing_cards) do
                if pcard.ability.fac_r_e_temp then 
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after', delay = 0.7,
                        func = function()
                            G.E_MANAGER:add_event(Event({
                                trigger = 'after', delay = 0.7,
                                func = function()
                                    pcard:start_dissolve()
                                    return true
                                end
                            }))
                            return true
                        end
                    }))
                end
            end
        end
    end,
})

PotatoPatchUtils.Developer({
	name = 'radiation',
    loc = true,
	atlas = 'fac_radiation_eremel_credits',
    joint_credits = true,
	pos = {x = 0, y = 0},
	colour = HEX('FF7C0A'),
	fac_partner = 'fac_eremel',
    loc_vars = function()
        return {vars = {}, scale = 1.2}
    end,
})

SMODS.Atlas({
    key = 'r_e_fish',
    path = 'radiation_eremel/fish.png',
    px = 71, py = 95
})

FishAndChips.Fish({
    key = 'r_e_butterfly_fish',
    atlas = 'r_e_fish',
    pos = {x = 4, y = 0},
    ppu_coder = {'eremel'},
    ppu_artist = {'radiation'},
    weight = 10,
    environments = {
        calm_pond = 3,
        pier = 4,
        garden = 6,
        wormhole = 1,
        chocolate_river = 1
    },
    attributes = {'chance', 'modify_card', 'suit', 'hand_type'},
    stats = {
        weight = {min = 0.03, max = 0.15},
        length = {min = 0.12, max = 0.22},
    },
    config = {extra = {denom = 4, hand = 'Flush'}},
    loc_vars = function(self, info_queue, card)
        local n, d = SMODS.get_probability_vars(card, 1, card.ability.extra.denom, 'r_e_butterfly')
        return {vars = {n, d, localize(card.ability.extra.hand, 'poker_hands'), 
           card.ability.extra.current and (card.ability.extra.current == 'Wild' and localize({set = 'Enhanced', type = 'name_text', key = 'm_wild'}) or localize(card.ability.extra.current, 'suits_plural')) or localize('fac_r_e_random_suits'),
           colours = {card.ability.extra.current and (G.C.SO_1[card.ability.extra.current] or G.ARGS.LOC_COLOURS.attention) or G.ARGS.LOC_COLOURS.inactive},
        ppu_bubbles = {'usable', 'toggle'}}}
    end,
    flush_options = {
        Hearts = {pos = {x=1,y=0}, colour = 'Hearts'},
        Diamonds = {pos = {x=3,y=0}, colour = 'Diamonds'},
        Clubs = {pos = {x=2,y=0}, colour = 'Clubs'},
        Spades = {pos = {x=0,y=0}, colour = 'Spades'},
        Wild = {pos = {x=1,y=1}, colour = 'attention'},
        Modded = {pos = {x=0,y=1}, colour = 'inactive'}
    },
    detect_suit = function(hand)
        local suits = {}
        local suit
        for _, card in ipairs(hand) do
            if SMODS.has_no_suit(card) then
            elseif SMODS.has_any_suit(card) then
                suits.Wild = (suits.Wild or 0) + 1
                if suits.Wild > (suits[suit] or 0) then suit = 'Wild' end
            else
                suits[card.base.suit] = (suits[card.base.suit] or 0) + 1
                if suits[card.base.suit] > (suits[suit] or 0) then suit = card.base.suit end
            end
        end
        return suit
    end,
    check_card = function(self, card, other)
        if card.ability.extra.current == 'Wild' then
            return not SMODS.has_enhancement(other, 'm_wild')
        end
        return not other:is_suit(card.ability.extra.current)
    end,
    calculate = function(self, card, context)
        if context.before and next(context.poker_hands.Flush) then
            card.ability.extra.current = self.detect_suit(context.scoring_hand)
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                func = function()
                    local pos = self.flush_options[card.ability.extra.current] or self.flush_options.Modded
                    card.children.center:set_sprite_pos(pos.pos)
                    card:juice_up()
                    return true
                end
            }))
            return {
                message = card.ability.extra.current .. ' Flush!',
                colour = G.C.SO_1[card.ability.extra.current]
            }
        end
        if context.individual and context.cardarea == G.play and self:check_card(card, context.other_card) then
            if SMODS.pseudorandom_probability(card, 'r_e_butterfly', 1, card.ability.extra.denom) then
                local target = context.other_card
                local suit = card.ability.extra.current or pseudorandom_element(SMODS.Suit.obj_buffer)
                while target:is_suit(suit) do
                    suit = pseudorandom_element(SMODS.Suit.obj_buffer)
                end

                if suit == 'Wild' then
                    G.E_MANAGER:add_event(Event({
                        type = 'after', delay = 0.7,
                        func = function()
                            target:juice_up()
                            target:set_ability('m_wild')
                            SMODS.calculate_effect({
                                message = localize('fac_r_e_butterfly'),
                                instant = true
                            }, target)
                            return true
                        end
                    }))
                else
                    target.base.suit = suit
                    G.E_MANAGER:add_event(Event({
                        type = 'after', delay = 0.7,
                        func = function()
                            target:juice_up()
                            assert(SMODS.change_base(target, suit))
                            SMODS.calculate_effect({
                                message = localize('fac_r_e_butterfly'),
                                instant = true
                            }, target)
                            return true
                        end
                    }))
                end
                delay(1)
                return nil, true
            end
        end
    end,
})

FishAndChips.Fish({
    key = 'r_e_ominous_whale',
    atlas = 'r_e_fish',
    pos = {x = 0, y = 2},
    ppu_coder = {'eremel'},
    ppu_artist = {'radiation'},
    weight = 7,
    environments = {
        styx = 5,
        volcano = 3,
        backroom = 1
    },
    attributes = {'spades', 'discard', 'mult', 'suit'},
    stats = {
        weight = {min = 1, max = 2},
        length = {min = 90000, max = 180000},
    },
    config = {extra = {mult = 4, target_suit = 'Spades'}},
    loc_vars = function(self, info_queue, card)
        return {vars = {localize(card.ability.extra.target_suit, 'suits_singular'), card.ability.extra.mult, card.ability.extra.mult * self:count_spades()}}
    end,
    count_spades = function(self)
        if not G.discard then return 0 end
        local spades = 0
        for _, card in ipairs(G.discard.cards) do
            if card:is_suit(self.config.extra.target_suit) then spades = spades + 1 end
        end
        return spades
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            local spades = self:count_spades()
            return {
                mult = card.ability.extra.mult * spades
            }
        end
    end,
})

FishAndChips.Fish({
    key = 'r_e_orca_cola',
    atlas = 'r_e_fish',
    pos = {x = 2, y = 3},
    ppu_coder = {'eremel'},
    ppu_artist = {'radiation'},
    weight = 10,
    environments = {
        city_river = 7,
        wormhole = 2,
        chocolate_river = 3,
        garden = 2
    },
    attributes = {'on_sell',},
    stats = {
        weight = {min = 0.010, max = 0.014},
        length = {min = 0.115, max = 0.115},
    },
    loc_vars = function(self, info_queue, card)
        return {vars = {G.GAME.fac_r_e_last_fish and localize({type = 'name_text', set = 'fac_Fish', key = G.GAME.fac_r_e_last_fish}) or 'None'}}
    end,
    calculate = function(self, card, context)
        if context.selling_self then
            G.GAME.fac_forced_fish = G.GAME.fac_r_e_last_fish
        end
    end,
})

FishAndChips.Fish({
    key = 'r_e_sushi_crab',
    atlas = 'r_e_fish',
    pos = {x = 3, y = 2},
    ppu_coder = {'eremel'},
    ppu_artist = {'radiation'},
    weight = 10,
    environments = {
        soup = 5,
        city_river = 4,
        pier = 2
    },
    attributes = {'scaling', 'xmult'},
    stats = {
        weight = {min = 3.8, max = 4.3},
        length = {min = 0.56, max = 0.91},
    },
    config = {extra = {xmult = 1, gain = 0.3, loss = 0.2, active = false}},
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.gain, card.ability.extra.loss, card.ability.extra.xmult,
            ppu_bubbles = {card.ability.extra.active and 'active' or 'inactive'},
            box_colours = {G.C.WHITE, card.ability.extra.active and mix_colours(G.C.PALE_GREEN, G.C.WHITE, 0.3) or G.C.UI.TRANSPARENT_DARK, card.ability.extra.active and G.C.UI.TRANSPARENT_DARK or mix_colours(G.C.PALE_GREEN, G.C.WHITE, 0.3)}}}
    end,
    calculate = function(self, card, context)
        if context.setting_blind and not card.ability.extra.active then
            SMODS.scale_card(card, {
                ref_table = card.ability.extra,
                ref_value = 'xmult',
                scalar_value = 'gain',
                message_key = 'a_xmult'
            })
            return nil, true
        end
        if context.joker_main and card.ability.extra.active then
            card.ability.extra.scale_down = true
            return {
                xmult = card.ability.extra.xmult
            }
        end
        if context.after and card.ability.extra.scale_down then
            SMODS.scale_card(card, {
                ref_table = card.ability.extra,
                ref_value = 'xmult',
                scalar_value = 'loss',
                operation = "-",
                message_key = 'a_xmult_minus',
                colour = G.C.RED,
            })
            return nil, true
        end
    end,
    keep_on_use = function() return true end,
    can_use = function() return true end,
    use = function(self, card)
        card.ability.extra.active = not card.ability.extra.active
        card.children.center:set_sprite_pos({x= card.ability.extra.active and 4 or 3, y = 2})
    end
})

FishAndChips.Fish({
    key = 'r_e_spookfish',
    atlas = 'r_e_fish',
    pos = {x = 1, y = 3},
    ppu_coder = {'eremel'},
    ppu_artist = {'radiation'},
    weight = 7,
    environments = {
        swamp = 5,
        backroom = 4,
        styx = 2
    },
    attributes = {'economy', 'passive'},
    stats = {
        weight = {min = 0.055, max = 0.140},
        length = {min = 0.10, max = 0.17},
    },
    config = {extra = {reduction = 1}},
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.reduction}}
    end,
    calculate = function(self, card, context)
        if context.fac_end_fishing and context.perfect then
            if G.GAME.fac_environment_reroll_cost > 0 then
                G.GAME.fac_environment_reroll_cost = math.max(0, G.GAME.fac_environment_reroll_cost - card.ability.extra.reduction)
                card.ability.extra.track = (card.ability.extra.track or 0) + 1
            end
            return {
                message = localize('fac_r_e_reduce'),
                colour = G.C.GOLD
            }
        end
        if context.fac_environment_changed then 
            G.GAME.fac_environment_reroll_cost = G.GAME.fac_environment_reroll_cost + (card.ability.extra.track or 0)
            card.ability.extra.track = 0
        end
    end,
})

FishAndChips.Fish({
    key = 'r_e_flowerhorn',
    atlas = 'r_e_fish',
    pos = {x = 0, y = 3},
    ppu_coder = {'eremel'},
    ppu_artist = {'radiation'},
    weight = 10,
    environments = {
        swamp = 6,
        backroom = 3,
        styx = 3
    },
    attributes = {'generation', 'destroy_card', 'usable'},
    stats = {
        weight = {min = 0.5, max = 2.6},
        length = {min = 0.21, max = 0.35},
    },
    can_use = function() return true end,
    use = function(self, card)
        local weight = card.ability.stats.weight
        local targets = {low = {}, high = {}}
        for _, fish in ipairs(G.fac_fish_area.cards) do
            if fish ~= card then
                if fish.ability.stats.weight <= weight then targets.low[#targets.low + 1] = fish else targets.high[#targets.high + 1] = fish end
            end
        end
        SMODS.destroy_cards(targets.low)
        for _, fish in ipairs(targets.high) do
            SMODS.copy_card(fish)
        end
    end
})

FishAndChips.Fish({
    key = 'r_e_tempura',
    atlas = 'r_e_fish',
    pos = {x = 2, y = 1},
    ppu_coder = {'eremel'},
    ppu_artist = {'radiation'},
    weight = 7,
    environments = {
        volcano = 4,
        city_river = 3,
        soup = 3,
        chocolate_river = 1
    },
    attributes = {'chips', 'food', 'chance'},
    stats = {
        weight = {min = 0.025, max = 0.080},
        length = {min = 0.003, max = 0.3},
    },
    config = {extra = {multiplier = 1000, denom = 6, max_length = 0.3}},
    loc_vars = function(self, info_queue, card)
        local n, d = SMODS.get_probability_vars(card, 1, card.ability.extra.denom, 'fac_r_e_tempura')
        return {vars = {(card.ability.stats and card.ability.stats.length or 0.003) * card.ability.extra.multiplier, n, d, card.ability.extra.max_length * card.ability.extra.multiplier, localize({type = 'name_text', set = self.set, key = self.key})}}
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                chips = card.ability.stats.length * card.ability.extra.multiplier
            }
        end
        if context.after then
            if SMODS.pseudorandom_probability(card, 'fac_r_e_tempura', 1, card.ability.extra.denom) then
                G.GAME.fac_r_e_tempura_eaten = true
                SMODS.destroy_cards(card, {pinch_anim = true})
                return {
                    message = localize('k_eaten_ex')
                }
            end
        end
    end,
    set_ability = function(self, card)
        if G.GAME.fac_r_e_tempura_eaten then
            G.E_MANAGER:add_event(Event({
                func = function()
                    if not card.ability.stats then return end
                    card.ability.stats.length = card.ability.extra.max_length
                    card.ability.stats.l_prop = 1
                    return true
                end
            }))
        end
    end
})

local popup_hook = G.UIDEF.card_h_popup
function G.UIDEF.card_h_popup(card)
    local ret = popup_hook(card)
	if card.ability.fac_r_e_temp then
		local name = SMODS.deepfind(ret, 'main_box_flag', 'i')[1]
		table.insert(name.objtree[#name.objtree-2].nodes,
			{n=G.UIT.R, config = {align = 'cm', padding = 0.05}, nodes = {
				{n=G.UIT.C, config={align = "m", colour = G.C.RED, r = 0.05, padding = 0.06, res = 0.45}, nodes={
					{n=G.UIT.T, config={text = localize('fac_r_e_temporary_bubble'), colour = G.C.UI.TEXT_LIGHT, scale = 0.24}},
				}}
			}}
		)
	end
	return ret
end

-- TODO: fix sprite reset when going in bucket (Main FAC issue)
FishAndChips.Fish({
    key = 'r_e_clam',
    atlas = 'r_e_fish',
    pos = {x = 3, y = 1},
    ppu_coder = {'eremel'},
    ppu_artist = {'radiation'},
    weight = 5,
    environments = {
        pier = 4,
        swamp = 3,
        calm_pond = 2,
        aquifer = 2
    },
    attributes = {'generation', 'passive'},
    stats = {
        weight = {min = 515, max = 2136},
        length = {min = 0.60, max = 0.90},
    },
    config = {extra = {enhancement = 'm_gold', amount = 3, reset = 3, current = 0, active = true}},
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {set='Other',key='fac_r_e_temp'}
        return {vars = {localize({type='name_text', set='Enhanced', key=card.ability.extra.enhancement}), card.ability.extra.amount, card.ability.extra.reset, card.ability.extra.current},
    key = not card.ability.extra.active and self.key..'_2'}
    end,
    calculate = function(self, card, context)
        if context.first_hand_drawn and card.ability.extra.active then
            draw_card(G.fac_fish_area, G.play, nil, nil, nil, card)
            for i=1, card.ability.extra.amount do
                G.E_MANAGER:add_event(Event({
                    trigger = 'after', delay = 0.8,
                    func = function()
                        local pcard = SMODS.add_card({key = card.ability.extra.enhancement, set = 'Enhanced', area = G.play, skip_materialize = true})
                        pcard.ability.fac_r_e_temp = true
                        local seal = SMODS.poll_object({type = 'Seal', chance = 0.4, seed = 'fac_r_e_clam_seal'})
                        local edition = SMODS.poll_object({type = 'Edition', chance = 0.4, seed = 'fac_r_e_clam_edition', no_negative = true})
                        pcard:set_seal(seal, true, true)
                        pcard:set_edition(edition, true, true)
                        card:juice_up()
                        pcard:start_materialize()
                        pcard.ability.extra_slots_used = -1
                        return true
                    end
                }))
            end
            delay(0.8)
            G.E_MANAGER:add_event(Event({
                trigger = 'after', delay = 0.7,
                func = function()
                    card:juice_up()
                    card.children.center:set_sprite_pos({x=4, y=1})
                    card.ability.extra.active = false
                    return true
                end
            }))
            delay(1.4)
            draw_card(G.play, G.fac_fish_area, nil, nil, nil, card, 0.6)
            for i=1, card.ability.extra.amount do
                draw_card(G.play, G.hand, nil, nil, nil, nil, 0.6)
            end
            G.E_MANAGER:add_event(Event({
                func = function()
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            save_run()
                            return true
                        end
                    }))
                    return true
                end
            }))
        end
        if context.fac_end_fishing and not card.ability.extra.active and context.treasure then
            card.ability.extra.current = card.ability.extra.current + 1
            if card.ability.extra.current == card.ability.extra.reset then
                draw_card(G.fac_fish_area, G.play, nil, nil, nil, card)
                G.E_MANAGER:add_event(Event({
                    trigger = 'after', delay = 0.7,
                    func = function()
                        card:juice_up()
                        card.children.center:set_sprite_pos({x=3, y=1})
                        card.ability.extra.active = true
                        return true
                    end
                }))
                delay(1.4)
                draw_card(G.play, G.fac_fish_area, nil, nil, nil, card)
            end
        end
    end,
})


function FishAndChips.radiation_eremel.create_multi_box(args, AUT)
    local _c = G.P_CENTERS[args.center]
    if _c then
        local res = {}
        res = _c:loc_vars({}, args.card, args.type).vars
        args.vars = args.vars or res
    end
    local box = {background_colour = G.C.WHITE}
    for j, line in ipairs(G.localization.descriptions[args.set][args.key].text_parsed) do
        local final_line = SMODS.localize_box(line, args)
        box[#box+1] = final_line
    end
    return box
end

local gen_aut_hook = Card.generate_UIBox_ability_table
function Card:generate_UIBox_ability_table(v)
    if v then return gen_aut_hook(self, v) end
    local aut = gen_aut_hook(self)
    aut.multi_box = aut.multi_box or {}
    aut.info = aut.info or {}
    if self.config.center_key == 'fish_fac_r_e_globe' then
        if next(self.ability.extra.current_scaling) then
            for _, type in ipairs(self.ability.extra.current_scaling) do
                aut.multi_box[#aut.multi_box+1] = FishAndChips.radiation_eremel.create_multi_box({key = 'fac_r_e_'..type, set = 'Other', center = self.config.center_key, card = self, type = type}, aut)
            end
        end
    end
    return aut
end

FishAndChips.Fish({
    key = 'r_e_globe',
    atlas = 'r_e_fish',
    pos = {x = 1, y = 2},
    ppu_coder = {'eremel'},
    ppu_artist = {'radiation'},
    weight = 9,
    environments = {
        calm_pond = 6,
        garden = 5,
        wormhole = 2,
        soup = 2
    },
    attributes = {'scaling', 'destroy_card', 'usable'},
    stats = {
        weight = {min = 1, max = 2},
        length = {min = 1, max = 2},
    },
    config = {extra = {consumed = 0, current_scaling = {}}},
    scaling_types = {
        mult = {gain = 2, key = 'mult'},
        chips = {gain = 10, key = 'chips'},
        economy = {gain = 1, key = 'dollars'},
        xmult = {gain = 0.05, key = 'xmult', base = 1}
    },
    loc_vars = function(self, info_queue, card, type)
        if card.ability and not next(card.ability.extra.current_scaling) then 
            for type, _ in pairs(self.scaling_types) do
                info_queue[#info_queue+1] = {set = 'Other', key = 'fac_r_e_'..type, vars = {(type=='economy' and localize('$') or '') .. _.gain, _.gain * card.ability.extra.consumed + (_.base or 0)}}
            end
            local target
            local att = ''
            for i, fish in ipairs(G.fac_fish_area.cards) do
                if fish == card and G.fac_fish_area.cards[i+1] then target = G.fac_fish_area.cards[i+1]; break end
            end
            if target and not next(card.ability.extra.current_scaling) then
                for attribute, v in pairs(target.config.center.attributes) do
                    if v and self.scaling_types[attribute] then
                        att = att .. ' ' .. localize({type='name_text', key='fac_r_e_'..attribute, set='Other'})
                    end
                end
            end
            if string.len(att) == 0 then att = ' None' end
            return {vars = {att}}
        end
        return {vars = type and {self.scaling_types[type].gain, self.scaling_types[type].gain * card.ability.extra.consumed + (self.scaling_types[type].base or 0)} or {card.ability.extra.consumed},
                key = next(card.ability.extra.current_scaling) and self.key..'_2'}
    end,
    can_use = function(self, card)
        for i, fish in ipairs(G.fac_fish_area.cards) do
            if fish == card and G.fac_fish_area.cards[i+1] then
                for attribute, v in pairs(G.fac_fish_area.cards[i+1].config.center.attributes) do
                    if v and self.scaling_types[attribute] then
                        return true
                    end
                end
                return next(card.ability.extra.current_scaling)
            end
        end
        return false
    end,
    set_sprites = function(self, card)
        card.children.base_shine = SMODS.create_sprite(0,0, card.T.w, card.T.h, SMODS.get_atlas(self.atlas), {x=2, y=2})
        card.children.base_shine:set_role({major = card, role_type = 'Glued', draw_major = card}) -- TODO: figure out how to get this to stick properly
        card.children.base_shine.custom_draw = true
        if card.ability and card.ability.fac_r_e_globed_fish then
            for k, info in pairs(card.ability.fac_r_e_globed_fish) do
                    card.children['stored_'..k] = SMODS.create_sprite(0,0, info.w, info.h, SMODS.get_atlas(info.atlas), info.pos)
                    local offset = {
                        x = card.T.w/2 - card.children['stored_'..k].T.w/2,
                        y = card.T.h/2 - card.children['stored_'..k].T.h/4
                    }
                    card.children['stored_'..k]:set_role({major = card, role_type = 'Minor', draw_major = card, offset = offset})
                    card.children['stored_'..k].T.scale = 0.4
                    card.children['stored_'..k].custom_draw = 'globe'
            end
        end
    end,
    use = function(self, card)
        local target
        for i, fish in ipairs(G.fac_fish_area.cards) do
            if fish == card and G.fac_fish_area.cards[i+1] then target = G.fac_fish_area.cards[i+1]; break end
        end
        if target and not next(card.ability.extra.current_scaling) then
            for attribute, v in pairs(target.config.center.attributes) do
                if v and self.scaling_types[attribute] then
                    card.ability.extra.current_scaling[#card.ability.extra.current_scaling + 1] = attribute
                end
            end
            card.ability.fac_r_e_globed_fish = {}
            local ignore_keys = {back = true, shadow = true}
            for k, sprite in pairs(target.children) do
                if not ignore_keys[k] then
                    local info = {
                        w = sprite.T.w/3, h = sprite.T.h/3,
                        atlas = sprite.atlas.key, pos = sprite.sprite_pos
                    }
                    card.ability.fac_r_e_globed_fish[k] = info
                end
            end
            self:set_sprites(card)
        end
        card.ability.extra.consumed = card.ability.extra.consumed + 1
        SMODS.destroy_cards(target, {pinch_anim = true})
        SMODS.calculate_effect({message = localize('fac_r_e_stored')}, card)
    end,
    keep_on_use = function() return true end,
    calculate = function(self, card, context)
        if context.joker_main and next(card.ability.extra.current_scaling) then
            local ret = {}
            for _, key in ipairs(card.ability.extra.current_scaling) do
                local s = self.scaling_types[key]
                ret[s.key] = s.gain * card.ability.extra.consumed + (s.base or 0)
            end
            return ret
        end
    end,
})

SMODS.DrawStep {
    key = 'fac_r_e_globe_fish',
    order = -11,
    func = function(self)
        self.children.base_shine:draw()
        for k, v in pairs(self.children) do
            if v.custom_draw and v.custom_draw == 'globe' then
                v:draw()    
            end
        end
    end,
    check_individual_condition = function(self, card, layer, k, v)
        if k == 'key' then return card.config.center_key == v end
        return true
    end,
    conditions = {key = 'fish_fac_r_e_globe'}
}