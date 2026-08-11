FishAndChips.radiation_eremel = {}

SMODS.Atlas({
    key = 'radiation_eremel_credits',
    path = 'radiation_eremel/credits.png',
    px = 142, py = 80
})

PotatoPatchUtils.Developer({
	name = 'eremel',
    loc = true,
	atlas = 'fac_radiation_eremel_credits',
    joint_credits = true,
	colour = HEX('3FC7EB'),
	fac_partner = 'fac_radiation',
    loc_vars = function()
        return {vars = {'RIP'}, scale = 1.2}
    end,
    calculate = function(self, context)
        if context.fac_fish_caught and G.P_CENTERS[context.fish].set == 'fac_Fish' then
            FishAndChips.radiation_eremel.last_fish = context.fish
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
	fac_partner = 'fac_eremel'
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
        -- TODO: tidy up these animations
        if context.individual and context.cardarea == G.play and self:check_card(card, context.other_card) then
            if SMODS.pseudorandom_probability(card, 'r_e_butterfly', 1, card.ability.extra.denom) then
                local target = context.other_card
                local suit = card.ability.extra.current or pseudorandom_element(SMODS.Suit.obj_buffer)

                if suit == 'Wild' then
                    G.E_MANAGER:add_event(Event({
                            type = 'after',
                            func = function()
                                target:juice_up()
                                target:set_ability('m_wild')
                                return true
                            end
                        }))
                else
                    target.base.suit = card.ability.extra.current
                        G.E_MANAGER:add_event(Event({
                            type = 'after',
                            func = function()
                                target:juice_up()
                                assert(SMODS.change_base(target, suit))
                                return true
                            end
                        }))
                end
                return {
                    message = 'Butterfly!',
                }
            end
        end
    end,
})

-- TODO: visual scaling
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
        return {vars = {FishAndChips.radiation_eremel.last_fish and localize({type = 'name_text', set = 'fac_Fish', key = FishAndChips.radiation_eremel.last_fish}) or 'None'}}
    end,
    calculate = function(self, card, context)
        if context.selling_self then
            G.GAME.fac_forced_fish = FishAndChips.radiation_eremel.last_fish
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
    attributes = {'generation', 'destroy_card'},
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