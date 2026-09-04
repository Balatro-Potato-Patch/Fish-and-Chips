SMODS.Atlas({
	key = "sophie_cards",
	path = "sophie/fac_cards.png",
	px = 71,
	py = 95,
})

local sophie_click_count = math.floor(5.5 + math.random() * 15)

local sound = nil


SMODS.Sound {
    key = "sophie_egg",
    path = "sophie/snd_egg.ogg"
}

SMODS.Sound {
    key = "sophie_dumbvictory",
    path = "sophie/snd_won.ogg"
}

-- I had to ditch your funny OS stuff sorry Sophie
SMODS.Font {
    key = 'sophie_comic',
    path = 'sophie/comic_shanns_2.ttf',
 }

PotatoPatchUtils.Developer({
	name = 'Sophie',
	atlas = 'fac_sophie_cards',
    loc = true,
    pos = {x = 1, y = 0},
	colour = HEX('e6fafd'),
	fac_partner = 'fac_gfs',
    click = function(self)
        self:juice_up()
        if sophie_click_count == 0 then
            love.system.openURL("https://github.com/Yule42/TheCrackerPack")
            sophie_click_count = math.floor(5.5 + math.random() * 15)
            sound = play_sound("fac_sophie_dumbvictory", 1, 1)
        else
            sophie_click_count = sophie_click_count - 1
            sound = play_sound("fac_sophie_egg", 1, 1)
        end
    end,
})

local sophie_gfs_progress = 0

local sprite = nil

SMODS.Atlas {
    key = 'fih_gif',
    path = 'sophie/fih_gif.png',
    atlas_table = 'ANIMATION_ATLAS',
    fps = 11,
    frames = 24,
    px = 180,
    py = 180
}

PotatoPatchUtils.Developer({
	name = 'gfs',
	atlas = 'fac_sophie_cards',
    loc = true,
    loc_vars = function(self, info_queue, card)
        local strings = {   "Swag",
                            "This mod is sponsered by red shadow legends",
                            "Jarona",
                            "I cooka da fish",
                            "You guessed it",
                            "I make other mods (sometime(when i think about it))",
                            "Only drawing cause i can't code",
                            "OH MY GOD LOOK BEHIND YOU!",
                            "The end is never the end is never the end is never the end is never the end",
                            "Legalize nuclear bombs",
                            "SYNTAX ERROR",
                            "Insert quotes",
                            "You found me !",
                            "Follow me on myspace!",
                            "",
                            "Oh look its sophe" }
        if sophie_gfs_progress >= #strings then
            sophie_gfs_progress = 0
        end
        sophie_gfs_progress = sophie_gfs_progress + 1
        return { vars = { strings[sophie_gfs_progress], elements = sophie_gfs_progress == 15 and { SMODS.create_sprite(0, 0, 3.5, 3.5, 'fac_fih_gif', {x = 0, y = 0}) } or {} } }
    end,
    click = function(self)
        self:juice_up()
        play_sound('coin3', 0.9+0.2*math.random(), 0.7)
    end,
	pos = {x = 0, y = 0},
	colour = G.C.YELLOW,
	fac_partner = 'fac_Sophie'
})

SMODS.Atlas({
	key = "sophie_fish",
	path = "sophie/fish.png",
	px = 71,
	py = 95,
})

--#region Fish

FishAndChips.Fish {
	key = "sophie_human_fish",
	atlas = "sophie_fish",
	pos = { x = 0, y = 0 },
	weight = 5,
    stats = {weight = {min = 1, max = 5}, length = {min = 0.04, max = 0.4}},
	ppu_coder = { "Sophie" },
	ppu_artist = { "gfs" },
	attributes = { "chips", "face", "modify_card", "perma_bonus" },
	config = {
		extra = {
			chips = 1
		}
	},
	environments = {
		wormhole = 10,
		calm_pond = 0.5,
        garden = 0.5
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.chips } }
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play and context.other_card:is_face() then
            local valid_cards = {}
            for _, card in ipairs(G.hand.cards) do
                if card:is_face() then
                    valid_cards[#valid_cards + 1] = card
                end
            end
            if #valid_cards > 0 then
                local _card = pseudorandom_element(valid_cards, pseudoseed('fac_sophie_human_fish'))
                _card.ability.perma_bonus = (_card.ability.perma_bonus or 0) + card.ability.extra.chips
                return {
                    message = localize('k_upgrade_ex'),
                    colour = G.C.CHIPS,
                    card = _card,
                    focus = card
                }
            end
        end
	end,
}

FishAndChips.Fish {
    key = "sophie_fishing_fear_hat", atlas = "sophie_fish", pos = { x =
    1, y = 0 }, weight = 3, stats = {weight = {min = 0.5, max = 0.5},
    length = {min = 0.1, max = 0.1}}, ppu_coder = { "Sophie" },
    ppu_artist = { "gfs" }, attributes = { "generation", "spectral", "chance", "consumable", },
    config = {
		extra = {
			odds = 5,
            odds_num = 1,
		}
	},
	environments = {
		pier = 1,
		swamp = 1,
        aquifer = 1,
        styx = 1,
	},
	loc_vars = function(self, info_queue, card)
        numerator, denominator = SMODS.get_probability_vars(card, card.ability.extra.odds_num, card.ability.extra.odds, 'fac_fish_sophie_fishing_fear_hat')
		return { vars = { numerator, denominator } }
	end,
	calculate = function(self, card, context)
		if context.fac_end_fishing and context.failed and SMODS.pseudorandom_probability(card, 'fac_fish_sophie_fishing_fear_hat', card.ability.extra.odds_num, card.ability.extra.odds, 'fac_fish_sophie_fishing_fear_hat') then
            if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.2,
                    func = (function()
                        local card = SMODS.add_card { set = 'Spectral', key_append = 'fac_fish_sophie_fishing_fear_hat', area = G.play }
                        G.GAME.consumeable_buffer = 0
                        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 2,
                            func = (function()
                                draw_card(G.play, G.consumeables, 1, 'up', true, card, nil, mute)
                            return true
                            end)
                        }))
                        return true
                    end)
                }))
                return {
                    message = localize('k_plus_spectral'),
                    colour = G.C.SECONDARY_SET.Spectral,
                    remove = true
                }
            end
        end
	end,
}

FishAndChips.Fish {
	key = "sophie_main_plug",
	atlas = "sophie_fish",
	pos = { x = 2, y = 0 },
	weight = 5,
    stats = {weight = {min = 0.5, max = 1.0}, length = {min = 1, max = 2}},
	ppu_coder = { "Sophie" },
	ppu_artist = { "gfs" },
	attributes = { "boss_blind", "suit" },
    blueprint_compat = false,
	config = {
		extra = {
			odds = 5,
            odds_num = 1,
		}
	},
	environments = {
		backroom = 5,
        pier = 1,
	},
	loc_vars = function(self, info_queue, card)
        numerator, denominator = SMODS.get_probability_vars(card, card.ability.extra.odds_num, card.ability.extra.odds, 'fac_fish_sophie_fishing_fear_hat')
		return { vars = { numerator, denominator } }
	end,
}

local ref_is_suit = Card.is_suit

function Card:is_suit(suit, bypass_debuff, flush_calc)
    local ret = ref_is_suit(self, suit, bypass_debuff, flush_calc)
    if not flush_calc and next(SMODS.find_card('fish_fac_sophie_main_plug')) then
        return true
    end
    return ret
end

FishAndChips.Fish {
	key = "sophie_poisson_davril",
	atlas = "sophie_fish",
	pos = { x = 3, y = 0 },
	weight = 3,
    stats = {weight = {min = 0.0001, max = 0.0008}, length = {min = 0.01, max = 0.2}},
	ppu_coder = { "Sophie" },
	ppu_artist = { "gfs" },
	attributes = { "passive", "mod_chance", "scaling", },
    blueprint_compat = false,
    eternal_compat = false,
	config = {
		extra = {
			odds = 5,
            odds_decrease = 1,
		}
	},
	environments = {
		city_river = 1,
        calm_pond = 1,
        swamp = 1
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.odds, card.ability.extra.odds_decrease } }
	end,
    calculate = function(self, card, context)
		if context.mod_probability and (context.identifier == 'lucky_mult' or context.identifier == 'lucky_money') and not context.blueprint and not context.retrigger_joker then
            return {
                numerator = context.numerator + card.ability.extra.odds
            }
        elseif context.end_of_round and context.game_over == false and context.main_eval and context.beat_boss then
            SMODS.scale_card(card, {
                ref_table = card.ability.extra,
                ref_value = "odds",
                scalar_value = "odds_decrease",
                operation = "-",
                message_key = 'k_fish_sophie_odds_m',
                message_colour = G.C.MULT
            })
            if card.ability.extra.odds < 0 then
                SMODS.destroy_cards(card)
            end
        end
	end,
}

FishAndChips.Fish {
	key = "sophie_fish_of_theseus",
	atlas = "sophie_fish",
	pos = { x = 4, y = 0 },
	weight = 5,
    stats = {weight = {min = 0.8, max = 3}, length = {min = 0.1, max = 0.8}},
	ppu_coder = { "Sophie" },
	ppu_artist = { "gfs" },
	attributes = { "rank", "suit", "modify_card", "enhancements", "seal", "edition", },
	config = {
		extra = {
		}
	},
	environments = {
		pier = 0.5,
        styx = 3,
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { } }
	end,
    calculate = function(self, card, context)
		if context.end_of_round and context.main_eval then
            local valid_cards = {}
            local modifier = 2
            for _, card in ipairs(G.hand.cards) do
                valid_cards[#valid_cards + 1] = card
            end
            if #valid_cards > 0 then
                local _card = pseudorandom_element(valid_cards, pseudoseed('fac_sophie_fish_of_theseus'))
                local edition = SMODS.poll_edition({'sophie_fish_of_theseus', mod = modifier, no_negative = true})
                local enhancement = SMODS.poll_enhancement({key = 'sophie_fish_of_theseus', mod = modifier})
                local seal = SMODS.poll_seal({key = 'sophie_fish_of_theseus', mod = modifier})
                local suit = pseudorandom_element(SMODS.Suits, pseudoseed('fac_sophie_fish_of_theseus')).key
                local rank = pseudorandom_element(SMODS.Ranks, pseudoseed('fac_sophie_fish_of_theseus')).key
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
                    delay = 0.15,
                    func = function()
                        _card:flip()
                        play_sound('card1', 1)
                        _card:juice_up(0.3, 0.3)
                        return true
                    end
                }))
                delay(0.2)
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.1,
                    func = function()
                        if enhancement then
                            _card:set_ability(enhancement)
                        end
                        if edition then
                            _card:set_edition(edition, false, true)
                        end
                        if seal then
                            _card:set_seal(seal, nil, true)
                        end
                        SMODS.change_base(_card, suit, rank)
                        return true
                    end
                }))
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.15,
                    func = function()
                        _card:flip()
                        play_sound('tarot2', 1, 0.6)
                        _card:juice_up(0.3, 0.3)
                        return true
                    end
                }))
                delay(0.5)
            end
        end
	end,
}

FishAndChips.Fish {
	key = "sophie_message_in_a_bottle",
	atlas = "sophie_fish",
	pos = { x = 0, y = 1 },
	weight = 5,
    stats = {weight = {min = 0.4, max = 0.7}, length = {min = 0.1, max = 0.3}},
	ppu_coder = { "Sophie" },
	ppu_artist = { "gfs" },
	attributes = { "generation", "consumable", },
	config = {
		extra = {
		}
	},
	environments = {
		pier = 1
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { } }
	end,
    calculate = function(self, card, context)
		if context.ending_fishing then
            if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                local _card = SMODS.add_card({set = "Consumeables"})
                return {
                    message = localize('fish_sophie_plus_consumable'),
                    colour = G.C.SECONDARY_SET[_card.config.center.set] or G.C.FILTER,
                }
            end
        end
	end,
}

FishAndChips.Fish {
	key = "sophie_meridias_beacon",
	atlas = "sophie_fish",
	pos = { x = 1, y = 1 },
	weight = 1,
    stats = {weight = {min = 1.0, max = 1.0}, length = {min = 0.3, max = 0.3}},
	ppu_coder = { "Sophie" },
	ppu_artist = { "gfs" },
	attributes = { "passive" },
	config = {
		extra = {
		}
	},
	environments = {
		calm_pond = 1,
        pier = 1,
        swamp = 1,
        aquifer = 1,
        volcano = 1,
        city_river = 1,
	},
    blueprint_compat = false,
	loc_vars = function(self, info_queue, card)
		return { vars = { } }
	end,
    calculate = function(self, card, context)
		if (context.joker_type_destroyed or context.check_eternal) and context.other_card and context.other_card.ability.set == 'Joker' and not context.blueprint and not context.retrigger_joker then
            return {
                no_destroy = { override_compat = true }
            }
        end
	end,
}

FishAndChips.Fish {
	key = "sophie_hermit_crab",
	atlas = "sophie_fish",
	pos = { x = 2, y = 1 },
	weight = 5,
    stats = {weight = {min = 0.03, max = 4.5}, length = {min = 0.01, max = 1}},
	ppu_coder = { "Sophie" },
	ppu_artist = { "gfs" },
	attributes = { "usable", "economy", },
	config = {
		extra = {
            max = 20
		}
	},
	environments = {
        pier = 1,
        aquifer = 1,
	},
    blueprint_compat = false,
    eternal_compat = false,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.max } }
	end,
    can_use = function(self, card)
        return true
    end,
    use = function(self, card)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('timpani')
                card:juice_up(0.3, 0.5)
                ease_sand_dollars(math.max(0, math.min(G.GAME.fac_sand_dollars, card.ability.extra.max)), true)
                return true
            end
        }))
    end
}

FishAndChips.Fish {
	key = "sophie_fish_jenga",
	atlas = "sophie_fish",
	pos = { x = 3, y = 1 },
	weight = 1,
    stats = {weight = {min = 10, max = 30}, length = {min = 0.3, max = 1.5}},
	ppu_coder = { "Sophie" },
	ppu_artist = { "gfs" },
	attributes = { "passive" },
	config = {
		extra = {
            scaling = 1.5
		}
	},
	environments = {
        calm_pond = 1,
        wormhole = 0.1,
        backroom = 2,
	},
    blueprint_compat = false,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.scaling } }
	end,
    calculate = function(self, card, context)
		if context.scaling_card and context.card and not context.blueprint and not context.retrigger_joker then
            return {
                override_scalar = math.ceil(context.scalar * card.ability.extra.scaling)
            }
        end
	end
}

FishAndChips.Fish {
	key = "sophie_the_fish",
	atlas = "sophie_fish",
	pos = { x = 4, y = 1 },
	weight = 3,
    stats = {weight = {min = 0.01, max = 0.01}, length = {min = 0.04, max = 0.04}},
	ppu_coder = { "Sophie" },
	ppu_artist = { "gfs" },
	attributes = { "economy", "face_down", "boss_blind", },
	config = {
		extra = {
            dollars = 2,
		}
	},
	environments = {
        calm_pond = 1,
        wormhole = 0.1,
        backroom = 2,
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.dollars } }
	end,
    add_to_deck = function(self, card, from_debuff)
		G.GAME.banned_keys["bl_fish"] = true
	end,
	remove_from_deck = function(self, card, from_debuff)
		G.GAME.banned_keys["bl_fish"] = nil
    end,
    calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play and context.other_card.ability.played_this_ante then
			G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + card.ability.extra.dollars
            return {
                dollars = card.ability.extra.dollars,
                func = function()
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            G.GAME.dollar_buffer = 0
                            return true
                        end
                    }))
                end
            }
        elseif context.stay_flipped and context.to_area == G.hand and not context.blueprint then
            if context.other_card.ability.played_this_ante then
                return { stay_flipped = true }
            end
		end
	end,
}

FishAndChips.Fish {
	key = "sophie_glados",
	atlas = "sophie_fish",
	pos = { x = 0, y = 2 },
	weight = 5,
    stats = {weight = {min = 0.2, max = 0.4}, length = {min = 0.07, max = 0.15}},
	ppu_coder = { "Sophie" },
	ppu_artist = { "gfs" },
	attributes = { "xmult", "scaling", },
	config = {
		extra = {
            xmult = 1,
            xmult_min = 0.10,
            xmult_max = 0.30,
		}
	},
	environments = {
        soup = 1,
        chocolate_river = 0.2,
        wormhole = 0.3,
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.xmult_min, card.ability.extra.xmult_max, card.ability.extra.xmult } }
	end,
    calculate = function(self, card, context)
		if context.joker_main then
            return {
                xmult = card.ability.extra.xmult
            }
        elseif context.end_of_round and context.main_eval and not context.blueprint then
            SMODS.scale_card(card, {
                ref_table = card.ability.extra,
                ref_value = "xmult",
                operation = function(ref_table, ref_value, initial, change)
                    local amount = ref_table.xmult_min + pseudorandom("sophie_glados") * (ref_table.xmult_max - ref_table.xmult_min)
                    ref_table[ref_value] = initial + amount
                end,
                message_key = 'a_xmult',
                message_colour = G.C.MULT
            })
            return nil, true
        end
	end,
}

FishAndChips.Fish {
	key = "sophie_fish_award",
	atlas = "sophie_fish",
	pos = { x = 1, y = 2 },
	weight = 2,
    stats = {weight = {min = 0.1, max = 0.2}, length = {min = 0.05, max = 0.15}},
	ppu_coder = { "Sophie" },
	ppu_artist = { "gfs" },
	attributes = { "economy", "seals", },
	config = {
		extra = {
            fish_dollars = 1
		}
	},
	environments = {
        aquifer = 1,
        wormhole = 0.3,
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.fish_dollars } }
	end,
    calculate = function(self, card, context)
		if context.fish_sophie_seal_trigger then
            return {
                sand_dollars = card.ability.extra.fish_dollars,
            }
        end
	end,
}

local calculate_seal_ref = Card.calculate_seal
function Card:calculate_seal(context, ...)
    local ret, ret2 = calculate_seal_ref(self, context, ...)
    if (ret or ret2) and (self.seal ~= "Red" or not context.repetition) then
        SMODS.calculate_context({cardarea = G.jokers, fish_sophie_seal_trigger = true, seal = self.seal or nil, other_card = self})
    end
    return ret, ret2
end

FishAndChips.Fish {
	key = "sophie_kfc_statue",
	atlas = "sophie_fish",
	pos = { x = 2, y = 2 },
	weight = 4,
    stats = {weight = {min = 0.1, max = 0.3}, length = {min = 0.1, max = 0.15}},
	ppu_coder = { "Sophie" },
	ppu_artist = { "gfs" },
	attributes = { "economy", "hands", "consumables", },
	config = {
		extra = {
            consumables = 0,
		}
	},
	environments = {
        calm_pond = 1,
        pier = 1,
        swamp = 1,
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { } }
	end,
    blueprint_compat = false,
    calculate = function(self, card, context)
		if context.end_of_round and context.main_eval then
            card.ability.extra.consumables = G.GAME.current_round.hands_left or 0
        end
        if context.starting_shop then
            for i = 1, card.ability.extra.consumables do

                local ctypes = {}
                for _,v in ipairs(SMODS.ConsumableType.obj_buffer) do
                    ctypes[#ctypes + 1] = v
                end
                -- Include spectrals in the pool
                local old_spec_rate = G.GAME.spectral_rate
                G.GAME.spectral_rate = 2
                local type = SMODS.poll_object_type{types = ctypes, 'kfc'..G.GAME.round_resets.ante..i}
                G.GAME.spectral_rate = old_spec_rate

                local consumable = SMODS.create_card{set = type, area = G.shop_jokers, skip_materialize = true}
                consumable.states.visible = false
                G.shop_jokers:emplace(consumable)
                consumable:start_materialize()
                consumable:set_cost()
                create_shop_card_ui(consumable)
            end
            -- G.shop_jokers.T.w = math.min(#G.shop_jokers.cards*1.02*G.CARD_W,4.08*G.CARD_W) -- Commented this out because I think it might be worth implementing something like this SMODS-side
            -- G.shop:recalculate()
            card.ability.extra.consumables = 0
        end
	end,
}

FishAndChips.Fish {
	key = "sophie_gay_fish",
	atlas = "sophie_fish",
	pos = { x = 4, y = 2 },
	weight = 1,
    stats = {weight = {min = 40, max = 70}, length = {min = 1.5, max = 1.9}},
	ppu_coder = { "Sophie" },
	ppu_artist = { "gfs" },
	attributes = { "xmult", "rank", "king", "full_deck", },
	config = {
		extra = {
            xmult = 0.5
		}
	},
	environments = {
        soup = 1,
        pier = 1,
        garden = 1
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.xmult } }
	end,
    calculate = function(self, card, context)
        if context.joker_main then
            local kings = 0
            for _, playing_card in ipairs(G.deck.cards) do
                if playing_card:get_id() == 13 then
                    kings = kings + 1
                end
            end
            return {
                xmult = 1 + card.ability.extra.xmult * kings
            }
        end
    end
}

FishAndChips.Fish {
	key = "sophie_triple_barracuda",
	atlas = "sophie_fish",
	pos = { x = 0, y = 3 },
	weight = 3,
    stats = {weight = {min = 0.5, max = 3}, length = {min = 0.5, max = 1.2}},
	ppu_coder = { "Sophie" },
	ppu_artist = { "gfs" },
	attributes = { "modify_card", "enhancements", "hand_type", },
	config = {
		extra = {
		}
	},
	environments = {
        calm_pond = 1,
        pier = 1,
        swamp = 1,
        styx = 1
	},
	loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS["m_bonus"]
        info_queue[#info_queue+1] = G.P_CENTERS["m_mult"]
        info_queue[#info_queue+1] = G.P_CENTERS["m_gold"]
		return { vars = { } }
	end,
    blueprint_compat = false,
    calculate = function(self, card, context)
        if context.before and G.GAME.current_round.hands_played == 0 and context.scoring_name == 'Three of a Kind' then
            local i = 1
            for _, playing_card in ipairs(context.scoring_hand) do
                if i == 1 then
                    playing_card:set_ability(G.P_CENTERS.m_bonus, nil, true)
                end
                if i == 2 then
                    playing_card:set_ability(G.P_CENTERS.m_mult, nil, true)
                end
                if i == 3 then
                    playing_card:set_ability(G.P_CENTERS.m_gold, nil, true)
                end
                i = i + 1
            end
        end
    end
}

--#endregion
