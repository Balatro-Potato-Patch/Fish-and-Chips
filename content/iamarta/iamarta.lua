SMODS.Atlas({
	key = "iamarta_credits",
	path = "iamarta/iamarta.png",
	px = 71,
	py = 95,
})

SMODS.Sound({
    key = "iamarta_eating",
    path = "iamarta/eating.ogg"
})

PotatoPatchUtils.Developer({
	name = "iamarta",
	atlas = "fac_iamarta_credits",
    loc = true,
	colour = HEX("9a00ff")
})

SMODS.Atlas({
	key = "iamarta_fish",
	path = "iamarta/fish.png",
	px = 71,
    py = 95
})

SMODS.Atlas({
	key = "iamarta_100_gar",
	path = "iamarta/100_gar.png",
	px = 186,
    py = 149
})

SMODS.Atlas({
    key = "iamarta_glider",
    path = "iamarta/glider.png",
    atlas_table = "ANIMATION_ATLAS",
    px = 3,
    py = 3,
    frames = 4,
})

SMODS.Atlas({
	key = "iamarta_big_worm",
	path = "iamarta/big_worm.png",
	px = 34,
    py = 115
})

FishAndChips.Fish{
    key = "iamarta_100_gar",
    weight = 8,
    atlas = "iamarta_100_gar",
    ppu_coder = {"iamarta"},
    ppu_artist = {"iamarta"},
    attributes = {"xmult", "passive"},
    display_size = {w = 186, h = 149},
    stats = {
		weight = {min = 100, max = 700},
		length = {min = 1.2, max = 0.4}
	},
    environments = {
        swamp = 1,
        pier = 0.5
    },
    config = {
        extra = {
            xmult_gain = 0.25,
            xmult = 1
        }
    },
    loc_vars = function(self, info_queue, card)
        return {vars = {
            card.ability.extra.xmult_gain,
            card.ability.extra.xmult
        }}
    end,
    calculate = function(self, card, context)
        if context.joker_main and card.ability.extra.xmult > 1 then
            return {xmult = card.ability.extra.xmult}
        elseif context.fac_fish_caught then
            if not context.blueprint and context.perfect then

                G.E_MANAGER:add_event(Event({
                    func = function()
                        G.fac_fish_area:remove_card(card)
                        if not G.fac_iamarta_gar_area then
                            G.fac_iamarta_gar_area = CardArea(G.fac_bait_area.cards[1].T.x, G.fac_bait_area.cards[1].T.y, G.CARD_W, G.CARD_H,
                                {
                                    type = "joker",
                                    highlight_limit = 1,
                                    highlighted_limit = 1,
                                    bg_colour = G.C.CLEAR,
                                    no_card_count = true,
                                }
                            )
                        end
                        G.fac_iamarta_gar_area:emplace(card)
                        play_sound("fac_iamarta_eating")
                        return true
                    end
                }))

                for i = 1, 5 do
                    G.E_MANAGER:add_event(Event({
                        trigger = "after",
                        delay = 1,
                        func = function()
                            card:juice_up(0.3, 0.3)
                            return true
                        end
                    }))
                end

                if G.GAME.fac_active_bait then FishAndChips.remove_bait_from_inventory(G.GAME.fac_active_bait) end

                G.E_MANAGER:add_event(Event({
                    trigger = "after",
                    delay = 1,
                    func = function()
                        G.fac_iamarta_gar_area:remove_card(card)
                        G.fac_fish_area:emplace(card)

                        delay(1)
                        
                        return true
                    end
                }))

                SMODS.scale_card(card, {
                    ref_table = card.ability.extra,
                    ref_value = "xmult",
                    scalar_value = "xmult_gain"
                })
            end
        end
    end
}

FishAndChips.Fish{
    key = "iamarta_memory_fish",
    weight = 5,
    atlas = "iamarta_fish",
    pos = {x = 1, y = 0},
    ppu_coder = {"iamarta"},
    ppu_artist = {"iamarta"},
    attributes = {"economy", "passive"},
    stats = {
		weight = {min = 0.18, max = 0.30},
		length = {min = 0.2, max = 0.3}
	},
    environments = {
        calm_pond = 1,
        pier = 1,
        swamp = 1,
        aquifer = 1,
        city_river = 1.5,
        backroom = 1.5, 
    },
    config = {
        extra = {
            money = 5,
            environment = "backroom"
        }
    },
    loc_vars = function(self, info_queue, card)
        return {vars = {
            card.ability.extra.money,
            localize({
                type = "name_text",
                set = "fac_Env",
                key = card.ability.extra.environment
            })
        }}
    end,
    on_catch = function(self, card)
        card.ability.extra.environment = G.GAME.fac_fishing_environment
    end,
    calculate = function(self, card, context)
        if context.fac_end_fishing and context.fish and card.ability.extra.environment == G.GAME.fac_fishing_environment then
            return {dollars = card.ability.extra.money}
        end
    end
}

FishAndChips.Fish{
    key = "iamarta_fish_xing",
    weight = 9,
    atlas = "iamarta_fish",
    blueprint_compat = false,
    pos = {x = 2, y = 0},
    pixel_size = {h = 71},
    ppu_coder = {"iamarta"},
    ppu_artist = {"iamarta"},
    attributes = {"usable", "destroy_card"},
    requires_hand = true,
    stats = {
		weight = {min = 2.4, max = 2.4},
		length = {min = 0.6, max = 0.6}
	},
    environments = {
        city_river = 1,
        backroom = 1,
    },
    config = {
        extra = {
            cards = 0,
            card_increase = 1
        }
    },
    loc_vars = function(self, info_queue, card)
        return {vars = {
            card.ability.extra.cards,
            card.ability.extra.card_increase
        }}
    end,
    calculate = function(self, card, context)
        if context.fac_end_fishing and context.failed and not context.blueprint then
            SMODS.scale_card(card, {
                ref_table = card.ability.extra,
                ref_value = "cards",
                scalar_value = "card_increase"
            })
        end
    end,
    can_use = function(self, card)
        return #G.hand.highlighted <= card.ability.extra.cards and #G.hand.highlighted >= 1
    end,
    use = function(self, card)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('tarot1')
                card:juice_up(0.3, 0.5)
                return true
            end
        }))
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.2,
            func = function()
                SMODS.destroy_cards(G.hand.highlighted)
                return true
            end
        }))
        delay(0.3)
    end
}

FishAndChips.Fish{
    key = "iamarta_punch_carp",
    weight = 6,
    atlas = "iamarta_fish",
    blueprint_compat = false,
    pos = {x = 3, y = 0},
    ppu_coder = {"iamarta"},
    ppu_artist = {"iamarta"},
    attributes = {"passive"},
    stats = {
		weight = {min = 0.0012, max = 0.0015},
		length = {min = 0.09, max = 0.1}
	},
    environments = {
        wormhole = 1,
        city_river = 0.1
    },
    config = {
        extra = {
            impulse_min = 2.5,
            impulse_max = 2.5,
            decision_min = 0.3,
            decision_max = 0.3,
            vel_limit = 4,
            target = nil
        }
    },
    calculate = function(self, card, context)
        if not context.blueprint then 
            if context.fac_cast_rod then
                card.ability.extra.target = nil
                for i = 1, #G.fac_fish_area.cards do
                    if G.fac_fish_area.cards[i] == card then
                        card.ability.extra.target = G.fac_fish_area.cards[i + 1]
                        break
                    elseif G.fac_fish_area.cards[i].config.center.key == "fish_fac_iamarta_punch_carp" then
                        card.ability.extra.target = nil
                        break
                    end
                end

                if card.ability.extra.target then
                    G.GAME.fac_forced_fish = card.ability.extra.target.config.center.key
                end
            end
            if context.fac_modify_fishing_profile and card.ability.extra.target then
                context.fishing_profile.impulse_min = context.fishing_profile.impulse_min * card.ability.extra.impulse_min
                context.fishing_profile.impulse_max = context.fishing_profile.impulse_max * card.ability.extra.impulse_max
                context.fishing_profile.decision_min = context.fishing_profile.decision_min * card.ability.extra.decision_min
                context.fishing_profile.decision_max = context.fishing_profile.decision_max * card.ability.extra.decision_max
                context.fishing_profile.vel_limit = context.fishing_profile.vel_limit * card.ability.extra.vel_limit
                G.GAME.fac_forced_fish = nil
                card:start_dissolve()
            end
        end
    end
}

FishAndChips.Fish{
    key = "iamarta_hot_dogfish",
    weight = 8,
    atlas = "iamarta_fish",
    ppu_coder = {"iamarta"},
    ppu_artist = {"iamarta"},
    attributes = {"usable", "xmult", "food"},
    keep_on_use = function(self, card) return true end,
    stats = {
		weight = {min = 3.2, max = 4.5},
		length = {min = 0.7, max = 1.1}
	},
    environments = {
        soup = 1
    },
    config = {
        extra = {
            xmult = 3,
            uses = 3,
            change = -1,
            active = false
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.xmult,
                card.ability.extra.uses
            }
        }
    end,
    calculate = function(self, card, context)
        if context.joker_main and card.ability.extra.active then
            return {xmult = card.ability.extra.xmult}
        end
        if context.end_of_round and context.main_eval and not context.blueprint then
            if card.ability.extra.uses <= 0 then
                SMODS.destroy_cards(card, nil, nil, true)
                return {
                    message = localize('k_eaten_ex'),
                    colour = G.C.RED
                }
            else
                card.ability.extra.active = false
                return {message = localize("k_fac_iamarta_inactive_ex"), colour = G.C.JOKER_GREY}
            end
        end
    end,
    use = function(self, card)
        SMODS.scale_card(card, {
            ref_table = card.ability.extra,
            ref_value = "uses",
            scalar_value = "change",
            scaling_message = {
                message = localize("k_active_ex")
            }
        })
        card.children.center:set_sprite_pos({x = math.ceil(2 - card.ability.extra.uses) , y = 1})
        card.ability.extra.active = true
        local eval = function(card) return card.ability.extra.active end
        juice_card_until(card, eval, true)
    end,
    can_use = function(self, card) return not card.ability.extra.active end
}

FishAndChips.Fish{
    key = "iamarta_glider",
    weight = 12,
    atlas = "iamarta_glider",
    ppu_coder = {"iamarta"},
    ppu_artist = {"iamarta"},
    attributes = {"passive", "rank"},
    display_size = {w = 71, h = 71},
    stats = {
		weight = {min = 0, max = 0},
		length = {min = 0.03, max = 0.03}
	},
    environments = {
        wormhole = 1
    },
    calculate = function(self, card, context)
        if context.before then
            local cards_to_increase = {}
            for i = 2, #context.full_hand - 1 do
                if context.full_hand[i-1]:get_id() > context.full_hand[i]:get_id() then
                    if context.full_hand[i+1]:get_id() > context.full_hand[i]:get_id() then
                        cards_to_increase[#cards_to_increase + 1] = context.full_hand[i]
                    end
                end
            end
            G.E_MANAGER:add_event(Event({
                func = function()
                    for _, card in ipairs(cards_to_increase) do
                        SMODS.modify_rank(card, 1)
                        card:juice_up()
                    end
                    return true
                end
            }))
            if #cards_to_increase > 0 then
                return {
                    message = localize("k_upgrade_ex"),
                    colour = G.C.BLACK
                }
            end
        end
    end,
}

FishAndChips.Fish{
    key = "iamarta_big_fish",
    weight = 9,
    atlas = "iamarta_fish",
    pos = {x = 3, y = 1},
    ppu_coder = {"iamarta"},
    ppu_artist = {"iamarta"},
    attributes = {"blind", "usable"},
    blueprint_compat = false,
    stats = {
		weight = {min = 0.18, max = 0.3},
		length = {min = 0.2, max = 0.3}
	},
    environments = {
        calm_pond = 1,
        pier = 0.6,
    },
    config = {
        extra = {
            xblindsize = 1.5,
            deduction = 1,
            rounds = 0,
            total_rounds = 3
        }
    },
    loc_vars = function(self, info_queue, card)
        return {vars = {
            card.ability.extra.xblindsize,
            card.ability.extra.total_rounds,
            card.ability.extra.deduction,
            card.ability.extra.rounds
        }}
    end,
    calculate = function(self, card, context)
        if context.setting_blind and not context.blueprint then
            return { xblindsize = card.ability.extra.xblindsize }
        end
        if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint and card.ability.extra.rounds <= card.ability.extra.total_rounds then
            card.ability.extra.rounds = card.ability.extra.rounds + 1
            if card.ability.extra.rounds == card.ability.extra.total_rounds then
                local eval = function(card) return not card.REMOVED end
                juice_card_until(card, eval, true)
            end
            return {
                message = (card.ability.extra.rounds < card.ability.extra.total_rounds) and
                    (card.ability.extra.rounds .. '/' .. card.ability.extra.total_rounds) or
                    localize('k_active_ex'),
                colour = G.C.FILTER
            }
        end
    end,
    use = function(self, card)
        ease_ante(-card.ability.extra.deduction)
    end,
    can_use = function(self, card) return card.ability.extra.rounds == card.ability.extra.total_rounds end
}

FishAndChips.Fish{
    key = "iamarta_big_worm",
    weight = 10,
    atlas = "iamarta_big_worm",
    blueprint_compat = false,
    display_size = {w = 34, h = 115},
    ppu_coder = {"iamarta"},
    ppu_artist = {"iamarta"},
    attributes = {"generation", "passive"},
    stats = {
		weight = {min = 0.05, max = 0.07},
		length = {min = 0.17, max = 0.18}
	},
    environments = {
        calm_pond = 0.8,
        pier = 1,
    },
    config = {
        extra = {
            active = false
        }
    },
    calculate = function(self, card, context)
        if context.fac_end_fishing and not context.blueprint then
            if card.ability.extra.active then
                card.ability.extra.active = false
                if not context.perfect then
                    FishAndChips.add_bait_to_inventory("bait_fac_normal")
                    return {
                        message = localize("k_fac_iamarta_plus_bait")
                    }
                end
            else
                card.ability.extra.active = true
            end
        end
    end
}