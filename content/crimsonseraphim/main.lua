FishAndChips.crimsonseraphim.click_sounds = {
    "null", "holiday", "flowery", "omega"
}


local function getYearsSince(birthYear, birthMonth, birthDay)
    local current = os.date("*t") -- Get current date
    local years = current.year - birthYear
    if current.month < birthMonth or (current.month == birthMonth and current.day < birthDay) then
        years = years - 1
    end
    return years
end

PotatoPatchUtils.Developer({
	name = 'crimsonseraphim',
	atlas = 'fac_crimsonseraphim_credits',
	colour = G.C.WHITE,
    loc = true,
    loc_vars = function(self, _, card)
        local area = CardArea(
            0, 0,
            G.CARD_W*0.75,
            G.CARD_H*0.75, 
            {card_limit = 1, type = 'play', highlight_limit = 0, negative_info = 'joker', collection = true})
        local c = SMODS.create_card({key = "fish_fac_crimsonseraphim_jade_crystalfish", area = area})
        area:emplace(c)
        FishAndChips.crimsonseraphim.desc_card = {
            center = G.P_CENTERS.fish_fac_crimsonseraphim_jade_crystalfish,
            dt = 0,
            card = c,
            area = area
        }
        G.E_MANAGER:add_event(Event{
            func = function()
                FishAndChips.crimsonseraphim.desc_card.card.config.h_popup_dir = "bm"
                FishAndChips.crimsonseraphim.desc_card.card:hover()
                FishAndChips.crimsonseraphim.desc_card.h_popup = FishAndChips.crimsonseraphim.desc_card.card.children.h_popup
                FishAndChips.crimsonseraphim.desc_card.card.children.h_popup.parent = nil
                FishAndChips.crimsonseraphim.desc_card.card.children.h_popup = nil
                FishAndChips.crimsonseraphim.desc_card.dt = 0.5
                return true
            end
        })
        return { vars = { getYearsSince(2005, 12, 4), elements = { {n=G.UIT.O, config={object = area}}, FishAndChips.crimsonseraphim.desc_card.h_popup } } }
    end,
    stop_hover = function()
        if not FishAndChips.crimsonseraphim.desc_card then return end
        FishAndChips.crimsonseraphim.desc_card.card:stop_hover()
        FishAndChips.crimsonseraphim.desc_card.h_popup:remove()
        FishAndChips.crimsonseraphim.desc_card.card:remove()
        FishAndChips.crimsonseraphim.desc_card.area:remove()
        FishAndChips.crimsonseraphim.desc_card = nil
    end,
    remove = function()
        if not FishAndChips.crimsonseraphim.desc_card then return end
        FishAndChips.crimsonseraphim.desc_card.card:stop_hover()
        FishAndChips.crimsonseraphim.desc_card.h_popup:remove()
        FishAndChips.crimsonseraphim.desc_card.card:remove()
        FishAndChips.crimsonseraphim.desc_card.area:remove()
        FishAndChips.crimsonseraphim.desc_card = nil 
    end,
    text_effect = "fac_crimsonseraphim_dev",
    crimsonseraphim_click_sound = function()
        return pseudorandom_element(FishAndChips.crimsonseraphim.click_sounds, pseudoseed("crimsonseraphim_click_sound"))
    end,
    h_popup_dir = function(self, card)
        return "cl"
    end
})

FishAndChips.Fish {
	key = "crimsonseraphim_aeonfish",
	atlas = "crimsonseraphim_aeonfish",
	pos = { x = 0, y = 0 },
	weight = 2,
	ppu_coder = { "crimsonseraphim" },
	ppu_artist = { "crimsonseraphim" },
	attributes = { "usable", "generation" },
	config = {
		extra = {}
	},
	environments = {
		styx = 4,
		garden = 10,
        backroom = 7,
        wormhole = 5,
	},
    stats = {
		weight = {min = 20, max = 100},
		length = {min = 0.3, max = 0.9}
	},
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue+1] = {set = "Other", key = "fac_crimsonseraphim_transmute"}
	end,
	calculate = function(self, card, context)
		if context.end_of_round and context.main_eval then card.ability.extra.used = nil end
	end,
    use = function(self, card)
        G.fac_fish_area.cards[#G.fac_fish_area.cards]:transmute("crimsonseraphim_aeonfish")
		card.ability.extra.used = true
	end,
	can_use = function(self, card)
		return not card.ability.extra.used
	end,
    keep_on_use = function()
        return true
    end
}

--When a fish is obtained sell it and this fish for 3x the sell price
FishAndChips.Fish {
	key = "crimsonseraphim_mealy_apple",
	atlas = "crimsonseraphim_aeonfish",
	pos = { x = 0, y = 1 },
	weight = 2,
	ppu_coder = { "crimsonseraphim" },
	ppu_artist = { "crimsonseraphim" },
	attributes = { "economy" },
	environments = {
		calm_pond = 4,
		soup = 10,
        chocolate_river = 7,
	},
    stats = {
		weight = {min = 0.15, max = 0.182},
		length = {min = 0.07, max = 0.08}
	},
    flavour_vars = function()
        return { vars = { elements = { SMODS.create_sprite(0, 0, 2, 0.75 * 1125 / 1086, "fac_mealy_lore") } } }
    end,
	calculate = function(self, card, context)
		if context.fac_fish_caught then
            local money = card.sell_cost + context.fac_fish_caught.sell_cost
            G.E_MANAGER:add_event(Event{
                trigger = "after",
                blocking = false,
                func = function()
                    SMODS.destroy_cards({card, context.fac_fish_caught}, nil, true)
                    return true
                end
            })
            if money ~= 0 then
                return {
                    sand_dollars = money * 3
                }
            end
        end
	end,
    set_card_type_badge = function(self, card, badges)
		badges[1] = create_badge(localize("k_fac_crimsonseraephim_fruit"), get_type_colour(self or card.config, card), nil, 1.2)
	end,
}


FishAndChips.Fish {
	key = "crimsonseraphim_jade_crystalfish",
	atlas = "crimsonseraphim_aeonfish",
	pos = { x = 5, y = 0 },
	weight = 2,
	ppu_coder = { "crimsonseraphim" },
	ppu_artist = { "crimsonseraphim" },
	attributes = { "passive", "chance" },
	config = {
		extra = {
            odds = 2,
            odds_seal = 2
        }
	},
	environments = {
		styx = 7,
        aquifer = 7
	},
    stats = {
		weight = {min = 61, max = 61},
		length = {min = 1.8, max = 1.8}
	},
	loc_vars = function(self, info_queue, card)
		local num, dem = SMODS.get_probability_vars(card, 1, card.ability.extra.odds_seal, "fac_crimsonseraphim_jade_crystalfish_seal")
        local num2, dem2 = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, "fac_crimsonseraphim_jade_crystalfish")
		return { vars = { num, dem, num2, dem2, localize{type = "name_text", set = "fac_Fish", key = "fish_fac_crimsonseraphim_ruby_crystalfish"} } }
	end,
	calculate = function(self, card, context)
		if context.end_of_round and context.main_eval and SMODS.pseudorandom_probability(
            card, "fac_crimsonseraphim_jade_crystalfish", 1, card.ability.extra.odds
        ) then
            card:transmute(nil, G.P_CENTERS.fish_fac_crimsonseraphim_ruby_crystalfish)
        end
        if context.fac_fish_caught and SMODS.pseudorandom_probability(
            card, "fac_crimsonseraphim_jade_crystalfish_seal", 1, card.ability.extra.odds_seal
        ) then
            context.fac_fish_caught:set_fish_seal(pseudorandom_element(SMODS.Seals, pseudoseed("jadefish_seal")).key)
        end
	end,
    requires_consumables = true
}

FishAndChips.crimsonseraphim.fish_seals = {
    Red = {
        atlas = "fac_crimsonseraphim_fish_seals",
        pos = {x = 0, y = 0},
        calculate = function(card, context)
            if context.repetition and G.GAME.round_resets.hands-1 >= G.GAME.current_round.hands_left and context.other_card == context.scoring_hand[1] then
                return {
                    fish_message_card = card,
                    repetitions = 1
                }
            end
        end
    },
    Blue = {
        atlas = "fac_crimsonseraphim_fish_seals",
        pos = {x = 1, y = 0},
        on_apply = function()
            if G.GAME.consumeable_buffer + #G.consumeables.cards < G.consumeables.config.card_limit then
                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                G.E_MANAGER:add_event(Event{
                    func = function()
                        SMODS.add_card{
                            set = "Planet"
                        }
                        G.GAME.consumeable_buffer = 0
                        return true
                    end
                })
            end
            if G.GAME.consumeable_buffer + #G.consumeables.cards < G.consumeables.config.card_limit then
                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                G.E_MANAGER:add_event(Event{
                    func = function()
                        SMODS.add_card{
                            set = "Planet"
                        }
                        G.GAME.consumeable_buffer = 0
                        return true
                    end
                })
            end
        end
    },
    Gold = {
        atlas = "fac_crimsonseraphim_fish_seals",
        pos = {x = 2, y = 0},
        calculate = function(card, context)
            if context.setting_blind then
                for i, v in pairs(G.fac_fish_area.cards) do
                    if v ~= card then
                        SMODS.calculate_effect({dollars = 1}, v)
                    end
                end
            end
        end
    },
    Purple = {
        atlas = "fac_crimsonseraphim_fish_seals",
        pos = {x = 3, y = 0},
        on_apply = function()
            if G.GAME.consumeable_buffer + #G.consumeables.cards < G.consumeables.config.card_limit then
                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                G.E_MANAGER:add_event(Event{
                    func = function()
                        SMODS.add_card{
                            set = "Tarot"
                        }
                        G.GAME.consumeable_buffer = 0
                        return true
                    end
                })
            end
            if G.GAME.consumeable_buffer + #G.consumeables.cards < G.consumeables.config.card_limit then
                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                G.E_MANAGER:add_event(Event{
                    func = function()
                        SMODS.add_card{
                            set = "Tarot"
                        }
                        G.GAME.consumeable_buffer = 0
                        return true
                    end
                })
            end
        end
    }
}

FishAndChips.Fish {
	key = "crimsonseraphim_ruby_crystalfish",
	atlas = "crimsonseraphim_aeonfish",
	pos = { x = 6, y = 0 },
	weight = 2,
	ppu_coder = { "crimsonseraphim" },
	ppu_artist = { "crimsonseraphim" },
	attributes = { "passive", "chance" },
	config = {
		extra = {
            odds = 2
        }
	},
	environments = {
		styx = 8,
        aquifer = 8
	},
    stats = {
		weight = {min = 61, max = 61},
		length = {min = 1.8, max = 1.8}
	},
	loc_vars = function(self, info_queue, card)
		local num, dem = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, "fac_crimsonseraphim_ruby_crystalfish")
        return {vars = {num, dem, localize{type = "name_text", set = "fac_Fish", key = "fish_fac_crimsonseraphim_jade_crystalfish"}}}
	end,
	calculate = function(self, card, context)
		if context.end_of_round and context.main_eval and SMODS.pseudorandom_probability(
            card, "fac_crimsonseraphim_ruby_crystalfish", 1, card.ability.extra.odds
        ) then
            card:transmute(nil, G.P_CENTERS.fish_fac_crimsonseraphim_jade_crystalfish)
        end
        if context.fac_fish_caught then
            SMODS.change_base(context.fac_fish_caught, 
                pseudorandom_element(SMODS.Suits, pseudoseed("ruby_crystalfish_suit")).key, 
                pseudorandom_element(SMODS.Ranks, pseudoseed("ruby_crystalfish_rank")).key,
            nil)
        end
	end,
    add_to_deck = function(self, card)
        if #SMODS.find_card("fish_fac_ruby_crystalfish") <= 0 then
            for i, v in pairs(G.I.CARD) do
                if v.config and v.config.center and v.config.center.set == "fac_Fish" and v ~= card then
                    SMODS.change_base(v, 
                        pseudorandom_element(SMODS.Suits, pseudoseed("ruby_crystalfish_suit")).key, 
                        pseudorandom_element(SMODS.Ranks, pseudoseed("ruby_crystalfish_rank")).key,
                    nil)
                end
            end
        end
    end
}

FishAndChips.Fish {
	key = "crimsonseraphim_hammerhead_shark",
	atlas = "crimsonseraphim_aeonfish",
	pos = { x = 4, y = 2 },
	weight = 2, 
	ppu_coder = { "crimsonseraphim" },
	ppu_artist = { "crimsonseraphim" },
	attributes = { "generation" },
	config = {
		extra = {
            odds = 2
        }
	},
	environments = {
		aquifer = 10,
        volcano = 10
	},
    stats = {
		weight = {min = 3, max = 580},
		length = {min = 0.9, max = 6.1}
	},
	loc_vars = function(self, info_queue, card)
		
	end,
	calculate = function(self, card, context)
        if context.fac_end_fishing and context.fish then
            if G.GAME.joker_buffer + #G.jokers.cards < G.jokers.config.card_limit then
                G.GAME.joker_buffer = G.GAME.joker_buffer + 1
                G.E_MANAGER:add_event(Event{
                    func = function()
                        local card = SMODS.add_card {
                            rarity = "Common",
                            set = "Joker"
                        }
                        card:jokered_forge()
                        G.GAME.joker_buffer = 0
                        return true
                    end
                })
            end
        end
	end,
    requires_jokers = true
}

FishAndChips.Fish {
	key = "crimsonseraphim_ghost_chaosfish",
	atlas = "crimsonseraphim_aeonfish",
	pos = { x = 1, y = 0 },
	weight = 2, 
	ppu_coder = { "crimsonseraphim" },
	ppu_artist = { "crimsonseraphim" },
	attributes = { "passive" },
	config = {
		extra = {
            odds = 2
        }
	},
	environments = {
		garden = 5,
        wormhole = 5
	},
    stats = {
		weight = {min = 1000, max = 2000},
		length = {min = 67, max = 110}
	},
    target = "",
    force_environment = function(card)
        if pseudorandom("fac_crimsonseraphim_ghost_chaosfish") < 0.2 then
			return pseudorandom_element(FishAndChips.Environments, "fac_crimsonseraphim_ghost_chaosfish_poll", {
				in_pool = function(v, _args)
					return v ~= FishAndChips.CurrentFishingPool
				end
			}).key
		end
    end,
    on_catch = function()
        G.E_MANAGER:add_event(Event{
            trigger = "after",
            blocking = false,
            func = function()
                if not G.FAC_FISH_GAME.fishing_active then
                    G.E_MANAGER:add_event(Event{
                        trigger = "after",
                        blocking = false,
                        delay = 1,
                        func = function()
                            G.FUNCS.fac_go_fish()
                            return true
                        end
                    })
                    return true
                end
            end
        })  
    end
}

FishAndChips.Fish {
	key = "crimsonseraphim_laplaces_angelfish",
	atlas = "crimsonseraphim_aeonfish",
	pos = { x = 2, y = 0 },
	weight = 2, 
	ppu_coder = { "crimsonseraphim" },
	ppu_artist = { "crimsonseraphim" },
	attributes = { "mult", "chips" },
	config = {
		extra = {
            mult = 1,
            chips = 1
        }
	},
	environments = {
		styx = 5,
        volcano = 5,
        wormhole = 5,
        backroom = 5
	},
    stats = {
		weight = {min = 0, max = 0},
		length = {min = 0.1, max = 0.2}
	},
	loc_vars = function(self, info_queue, card)
    return {
        vars = {
            card.ability.extra.mult,
            card.ability.extra.chips
        }
    }
	end,
	calculate = function(self, card, context)
        if context.selling_card and context.card.ability.set == "fac_Fish" then
            card.ability.extra.mult = (card.ability.extra.mult + context.card.ability.stats.length) / 2
            card.ability.extra.chips = (card.ability.extra.chips + context.card.ability.stats.weight) / 2
        end
        if context.joker_main then
            return {
                mult = card.ability.extra.mult,
                chips = card.ability.extra.chips
            }
        end
	end,
}

FishAndChips.Fish {
	key = "crimsonseraphim_gungir",
	atlas = "crimsonseraphim_aeonfish",
	pos = { x = 3, y = 0 },
	weight = 2, 
	ppu_coder = { "crimsonseraphim" },
	ppu_artist = { "crimsonseraphim" },
	attributes = { "generation" },
	config = {
		extra = {
            charged = nil
        }
	},
	environments = {
		volcano = 5,
        garden = 5,
        aquifer = 5,
	},
    stats = {
		weight = {min = 20, max = 20},
		length = {min = 2.2, max = 2.2}
	},
	loc_vars = function(self, info_queue, card)
    return {
        vars = {
            localize(card.ability.extra.charged and "k_charged" or "k_uncharged")
        }
    }
	end,
	use = function(self, card)
        if card.ability.extra.charged then
            play_sound("fac_crimsonseraphim_gungir_decharge")
        else    
            play_sound("fac_crimsonseraphim_gungir_charge")
        end
		card.ability.extra.charged = not card.ability.extra.charged
	end,
	can_use = function(self, card)
		return true
	end,
    keep_on_use = function()
        return true
    end,
    calculate = function(self, card, context)
        if card.ability.extra.charged then
            if context.fac_fish_caught then
                context.fac_fish_caught:set_edition(SMODS.poll_object{type = "Edition", guaranteed = true})
            end
            if context.fac_end_fishing then
                if not context.perfect then
                    G.E_MANAGER:add_event(Event{
                        trigger = "after",
                        blocking = false,
                        func = function()
                            play_sound("fac_crimsonseraphim_gungir_break")
                            SMODS.destroy_cards(card, nil, true)
                            return true
                        end
                    })
                else
                    G.E_MANAGER:add_event(Event{
                        trigger = "after",
                        blocking = false,
                        func = function()
                            play_sound("fac_crimsonseraphim_gungir_success")
                            return true
                        end
                    })
                end
            end
        end
    end,
    set_card_type_badge = function(self, card, badges)
		badges[1] = create_badge(localize("k_fac_crimsonseraephim_heavenly_artefact"), get_type_colour(self or card.config, card), nil, 1.2)
	end,
}

FishAndChips.Fish {
	key = "crimsonseraphim_trout_population",
	atlas = "crimsonseraphim_aeonfish",
	pos = { x = 5, y = 1 },
	weight = 2, 
	ppu_coder = { "crimsonseraphim" },
	ppu_artist = { "crimsonseraphim" },
	attributes = { "generation" },
	config = {
		extra = {
            mult = 1,
            chips = 3
        }
	},
	environments = {
		calm_pond = 5,
        city_river = 5,
        pier = 5,
	},
    stats = {
		weight = {min = 4*10, max = 5*10},
		length = {min = 0.15 * 5, max = 0.75*6}
	},
	loc_vars = function(self, info_queue, card)
    return {
        vars = {
            card.ability.extra.mult,
            card.ability.extra.chips
        }
    }
	end,
    calculate = function(self, card, context)
        if context.joker_main then
            for i = 1, 10 do
                if pseudorandom("crimsonseraphim_crimsonseraphim_trout_population") < 0.5 then
                    SMODS.calculate_effect({mult = card.ability.extra.mult}, context.blueprint_card or card)
                else
                    SMODS.calculate_effect({chips = card.ability.extra.chips}, context.blueprint_card or card)
                end
            end
            return nil, true
        end
    end
}

FishAndChips.Fish {
	key = "crimsonseraphim_another_bucket",
	atlas = "bucket",
	pos = { x = 1, y = 1 },
	weight = 2, 
	ppu_coder = { "crimsonseraphim" },
	ppu_artist = { "squeax09" },
	attributes = { "useable" },
	environments = {
		calm_pond = 5,
        city_river = 5,
        pier = 5,
	},
    config = {
        extra = {}
    },
    stats = {
		weight = {min = 0.25, max = 0.25},
		length = {min = 0.3, max = 0.3}
	},
    use = function(self, card)
        if card.ability.saved_card then
            if #G.fac_fish_area.cards < G.fac_fish_area.config.card_limit then
                card.ability.saved_card.card.states.collide.can = true
                card.ability.saved_card.card.states.hover.can = true
                card.ability.saved_card.card.states.click.can = true
                card.ability.saved_card.card.states.drag.can = true
                card.ability.saved_card.card.states.focus.can = true
                local s = card.ability.saved_card.card:save()
                card.ability.saved_card.card:start_dissolve()
                local car = SMODS.add_card{set = "Joker", area = G.fac_fish_area}
                car.states.visible = false
                car:load(s)
                G.E_MANAGER:add_event(Event({
                    func = function()
                        car:start_materialize()
                        return true
                    end
                })) 
                card.ability.saved_card = nil
            else
                SMODS.calculate_effect({message = localize("k_nope_ex")}, card)
            end
        else
            local c = G.fac_fish_area.cards[#G.fac_fish_area.cards]
            if c == card then return end
            c.area:remove_card(c)
            c.states.collide.can = false
            c.states.hover.can = false
            c.states.click.can = false
            c.states.drag.can = false
            c.states.focus.can = false
            c.states.visible = false
            card.ability.saved_card = {
                save_table = c:save(),
                card = c
            }
        end
	end,
	can_use = function(self, card)
		return (#G.fac_fish_area.cards >= 2 and G.fac_fish_area.cards[#G.fac_fish_area.cards] ~= card) or card.ability.saved_card
	end,
    keep_on_use = function()
        return true
    end,
    set_card_type_badge = function(self, card, badges)
		badges[1] = create_badge(localize("k_fac_crimsonseraephim_game_object"), get_type_colour(self or card.config, card), nil, 1.2)
	end,
}

FishAndChips.Fish {
	key = "crimsonseraphim_rusty_revolver",
	atlas = "crimsonseraphim_aeonfish",
	pos = { x = 4, y = 0 },
	weight = 2, 
	ppu_coder = { "crimsonseraphim" },
	ppu_artist = { "crimsonseraphim" },
	attributes = { "useable" },
	environments = {
        city_river = 5,
	},
    config = {
        extra = {
            shots = 4
        }
    },
    stats = {
		weight = {min = 0.6, max = 0.6},
		length = {min = 0.2, max = 0.2}
	},
    loc_vars = function(_, _, card)
        return {
            vars = {
                card.ability.extra.shots,
                card.ability.extra.primed or 0
            }
        }
    end,
    use = function(self, card)
        play_sound()
        if card.ability.extra.shots <= 0 then
            play_sound("fac_crimsonseraphim_revolver_empty")
        else
            play_sound("fac_crimsonseraphim_revolver_spin")
            card.ability.extra.primed = (card.ability.extra.primed or 0) + 1
            card.ability.extra.shots = card.ability.extra.shots - 1
        end
	end,
	can_use = function(self, card)
		return card.ability.extra.shots > 0
	end,
    keep_on_use = function()
        return true
    end,
    calculate = function(self, card, context)
        if context.fac_modify_fishing_profile then  
            context.fishing_profile.vel_limit = context.fishing_profile.vel_limit * math.pow(1/2, card.ability.extra.primed or 0)
        end
    end,
    set_card_type_badge = function(self, card, badges)
		badges[1] = create_badge(localize("k_fac_crimsonseraephim_weapon"), get_type_colour(self or card.config, card), nil, 1.2)
	end,
}

FishAndChips.Fish {
	key = "crimsonseraphim_larp",
	atlas = "crimsonseraphim_aeonfish",
	pos = { x = 5, y = 2 },
	weight = 2, 
	ppu_coder = { "crimsonseraphim" },
	ppu_artist = { "crimsonseraphim" },
	attributes = { "useable", "passive" },
	environments = {
        city_river = 5,
        calm_pond = 5,
        garden = 5
	},
    config = {
        extra = {
            joker = "fish_fac_cod"
        }
    },
    stats = {
		weight = {min = 2.6, max = 20},
		length = {min = 0.4, max = 1.2}
	},
    loc_vars = function(self, q, card)
        return {
            vars = {
                localize{type = "name_text", key = card.ability.extra.joker, set = "fac_Fish"}
            },
        }
    end,
    use = function(self, card)
        if G.P_CENTERS[card.ability.extra.joker].use then
            G.P_CENTERS[card.ability.extra.joker]:use(card.dummy)
        end
	end,
	can_use = function(self, card)
		return G.P_CENTERS[card.ability.extra.joker].can_use and G.P_CENTERS[card.ability.extra.joker]:can_use(card.dummy) or nil
	end,
    keep_on_use = function(self, card)
        return G.P_CENTERS[card.ability.extra.joker].keep_on_use and G.P_CENTERS[card.ability.extra.joker]:keep_on_use(card.dummy) or nil
    end,
    calculate = function(self, card, context)
        if context.starting_shop then
            G.E_MANAGER:add_event(Event{
                trigger = "after",
                func = function()
                    card.ability.extra.joker = SMODS.poll_object{type = "fac_Fish"}
                    Card.remove_from_deck(card.dummy)
                    card.dummy = FishAndChips.crimsonseraphim.get_dummy(G.P_CENTERS[card.ability.extra.joker], G.fac_fish_area, card)
                    card.dummy.added_to_deck = nil
                    Card.add_to_deck(card.dummy)
                    card.dummy.added_to_deck = true
                    card.ability.extra.dummy_abil = card.dummy.ability
                    FishAndChips.modify_fish_stats(card, FishAndChips.create_fish_stats(card.dummy.config.center))
                    card_eval_status_text(
                        card,
                        "extra",
                        nil,
                        nil,
                        nil,
                        { message = localize("k_switch_ex") }
                    )
                    return true
                end
            })
        end
        if not card.dummy then
            card.dummy = FishAndChips.crimsonseraphim.get_dummy(G.P_CENTERS[card.ability.extra.joker], G.fac_fish_area, card)
            card.dummy.added_to_deck = true
            if card.ability.extra.dummy_abil then card.dummy.ability = card.ability.extra.dummy_abil end
        end
        if card.ability.extra.joker == "fish_fac_steelhead" then
            local other_fish = nil
            for i = 2, #G.fac_fish_area.cards do
                if G.fac_fish_area.cards[i] == card then other_fish = G.fac_fish_area.cards[i - 1] end
            end
            return SMODS.blueprint_effect(card, other_fish, context)
        elseif card.ability.extra.joker == "fish_fac_flounder" then
            if G.fac_fish_area.cards[#G.fac_fish_area.cards] ~= card then
                return SMODS.blueprint_effect(card, G.fac_fish_area.cards[#G.fac_fish_area.cards], context)
            end
        else
            local ret = Card.calculate_joker(card.dummy, context)
            card.ability.extra.dummy_abil = card.dummy.ability
            return ret
        end
    end,
    calc_dollar_bonus = function(self, card)
        if card.dummy then
            local ret = Card.calculate_dollar_bonus(card.dummy)
            card.ability.extra.dummy_abil = card.dummy.ability
            return ret
        end
    end,
}

FishAndChips.Fish {
	key = "crimsonseraphim_still_life",
	atlas = "crimsonseraphim_aeonfish",
	pos = { x = 3, y = 2 },
	weight = 2, 
	ppu_coder = { "crimsonseraphim" },
	ppu_artist = { "crimsonseraphim" },
	attributes = { "mult" },
	environments = {
        backroom = 5
	},
    config = {
        extra = {
            mult = 4,
            mult_gain = 4
        }
    },
    stats = {
		weight = {min = 1.00, max = 8.50},
		length = {min = 0.20, max = 1.45}
	},
    loc_vars = function(self, q, card)
        return {
            vars = {
                card.ability.extra.mult,
                card.ability.extra.mult_gain
            },
        }
    end,
    calculate = function(self, card, context)
        if context.setting_blind then
            local fih = {}
            for i, v in pairs(G.fac_fish_area.cards) do
                if not SMODS.is_eternal(v) and v ~= card then
                    fih[#fih+1] = v
                end
            end
            if #fih > 0 then
                SMODS.destroy_cards(pseudorandom_element(fih, pseudoseed("stilllife_card")), nil, true)
            end
            SMODS.scale_card(card, {
                ref_table = card.ability.extra,
                ref_value = "mult",
                scalar_value = "mult_gain"
            })
            return nil, true
        end
        if context.joker_main then
            return {
                mult = card.ability.extra.mult
            }
        end
    end,
}

FishAndChips.Fish {
	key = "crimsonseraphim_starblight_eel",
	atlas = "crimsonseraphim_aeonfish",
	pos = { x = 1, y = 1 },
	weight = 2, 
	ppu_coder = { "crimsonseraphim" },
	ppu_artist = { "crimsonseraphim" },
	attributes = { "generation" },
	environments = {
        wormhole = 5
	},
    config = {
        extra = {
            copies = 2
        }
    },
    stats = {
		weight = {min = 6.00, max = 14.50},
		length = {min = 20.20, max = 30.45}
	},
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {set = "Other", key = "crimsonseraphim_starblighted", vars = {1, -0.5}}
        return {
            vars = {
                card.ability.extra.copies
            }
        }
    end,
    on_catch = function(self, card)
        if #G.fac_fish_area.cards > 1 then
            local cards = {}
            for i, v in pairs(G.fac_fish_area.cards) do
                if v ~= card then
                    cards[#cards+1] = v
                end
            end
            for i = 1, card.ability.extra.copies do
                if #G.fac_fish_area.cards < G.fac_fish_area.config.card_limit then
                    local c = copy_card(pseudorandom_element(cards, pseudoseed("crimsonseraphim_starblight_eel")), nil)
                    G.fac_fish_area:emplace(c)
                    c:add_to_deck()
                    c:start_materialize()
                    c.ability.crimsonseraphim_starblighted = true
                    c.ability.crimsonseraphim_starblighted_mult = 1
                end
            end
        end
    end
}

FishAndChips.Fish {
	key = "crimsonseraphim_ultimate_weapon",
	atlas = "crimsonseraphim_ultimate_weapon",
	pos = { x = 0, y = 0 },
	weight = 2, 
	ppu_coder = { "crimsonseraphim" },
	ppu_artist = { "crimsonseraphim" },
	attributes = { "useable" },
    pixel_size = {
        w = 102,
        h = 70
    },
    display_size = {
        w = 71,
        h = 71 * 70/102
    },
	environments = {
        styx = 5,
        backroom = 5,
        city_river = 5
	},
    config = {
        extra = {
            fish = 3    
        }
    },
    stats = {
		weight = {min = 0, max = 0},
		length = {min = 4.13, max = 4.13}
	},
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.fish
            }
        }
    end,
    use = function(self, card)
        if #G.fac_fish_area.cards < G.fac_fish_area.config.card_limit then
            for i = 1, math.min(card.ability.extra.fish, G.fac_fish_area.config.card_limit - #G.fac_fish_area.cards) do
                local c = G.GAME.crimsonseraphim_obtained_fish[#G.GAME.crimsonseraphim_obtained_fish]
                if c then
                    local car = SMODS.create_card{key = "j_joker", area = G.fac_fish_are}
                    car:load(c.card and type(c.card) ~= "number" and c.card:save() or c.savetable)
                    G.GAME.crimsonseraphim_obtained_fish[#G.GAME.crimsonseraphim_obtained_fish] = nil
                    G.fac_fish_area:emplace(car)
                    car:start_materialize()
                end
            end
        end
    end,
    can_use = function()
        return G.GAME.crimsonseraphim_obtained_fish
    end,
    treasure = true,
    set_card_type_badge = function(self, card, badges)
		badges[1] = create_badge(localize("k_fac_crimsonseraephim_weapon"), get_type_colour(self or card.config, card), nil, 1.2)
	end,
}

FishAndChips.Fish {
	key = "crimsonseraphim_jack_o_lantern",
	atlas = "crimsonseraphim_aeonfish",
	pos = { x = 4, y = 3 },
	weight = 2, 
	ppu_coder = { "crimsonseraphim" },
	ppu_artist = { "crimsonseraphim" },
	attributes = { "passive" },
	environments = {
        wormhole = 5
	},
    config = {
        extra = {
            money = 1,
            times = 3,
            times_done = 0
        }
    },
    stats = {
		weight = {min = 7, max = 7},
		length = {min = .33, max = .33}
	},
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.money,
                card.ability.extra.times_done,
                card.ability.extra.times,
            }
        }
    end,
    calculate = function(self, card ,context)
        if context.crimsonseraphim_fish_leaving_sweet_spot then
            card.ability.extra.times_done = card.ability.extra.times_done + 1
            if card.ability.extra.times_done >= card.ability.extra.times then
                card.ability.extra.times_done = 0
                return {
                    dollars = card.ability.extra.money
                }
            end
            return {
                message = card.ability.extra.times_done .. "/" .. card.ability.extra.times
            }
        end
    end,
    set_card_type_badge = function(self, card, badges)
		badges[1] = create_badge(localize("k_fac_crimsonseraephim_fruit"), get_type_colour(self or card.config, card), nil, 1.2)
	end,
}

FishAndChips.Fish {
	key = "crimsonseraphim_piranha_cruenta",
	atlas = "crimsonseraphim_aeonfish",
	pos = { x = 6, y = 2 },
	weight = 2, 
	ppu_coder = { "crimsonseraphim" },
	ppu_artist = { "crimsonseraphim" },
	attributes = { "xmult", "hearts" },
	environments = {
        styx = 5,
        swamp = 5,
        pier = 5
	},
    config = {
        extra = {
            xmult = 1.25
        }
    },
    stats = {
		weight = {min = 4, max = 6},
		length = {min = 0.5, max = 0.8}
	},
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.xmult
            }
        }
    end,
    calculate = function(self, card ,context)
        if context.individual and context.cardarea == G.hand and context.other_card:is_suit("Hearts") then
            return {
                xmult = card.ability.extra.xmult
            }
        end
    end
}

FishAndChips.Fish {
	key = "crimsonseraphim_delphinus_dormiens",
	atlas = "crimsonseraphim_aeonfish",
	pos = { x = 4, y = 1 },
	weight = 2, 
	ppu_coder = { "crimsonseraphim" },
	ppu_artist = { "crimsonseraphim" },
	attributes = { "passive" },
	environments = {
        backroom = 5,
        garden = 5,
        pier = 5
	},
    stats = {
		weight = {min = 40, max = 90},
		length = {min = 1.2, max = 4}
	},
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {set = "Other", key = "perishable", vars = {5,5}}
    end,
    calculate = function(self, card ,context)
        if context.fac_use_fish and not context.fac_use_fish.ability.perishable then
            if #G.fac_fish_area.cards < G.fac_fish_area.config.card_limit then
                local c = SMODS.add_card{key=context.fac_use_fish.config.center.key, area = G.fac_fish_area}
                c.ability.perishable = true
                c.ability.perish_tally = 5
                SMODS.destroy_cards(card, nil, true)
            end
            return nil, true
        end
    end
}

FishAndChips.Fish {
	key = "crimsonseraphim_anima",
	atlas = "crimsonseraphim_aeonfish",
	pos = { x = 0, y = 2 },
	weight = 2, 
	ppu_coder = { "crimsonseraphim" },
	ppu_artist = { "crimsonseraphim" },
	attributes = { "passive" },
	environments = {
        calm_pond = 5,
        garden = 5,
        pier = 5
	},
    stats = {
		weight = {min = 2.7, max = 6},
		length = {min = 0.6, max = 0.9}
	},
}

FishAndChips.Fish {
	key = "crimsonseraphim_falx_sulphurata",
	atlas = "crimsonseraphim_aeonfish",
	pos = { x = 3, y = 3 },
	weight = 2, 
	ppu_coder = { "crimsonseraphim" },
	ppu_artist = { "crimsonseraphim" },
	attributes = { "destroy_card" },
	environments = {
        volcano = 5,
        styx = 5,
        swamp = 5
	},
    stats = {
		weight = {min = 0.3, max = 1.5},
		length = {min = 0.25, max = 0.5}
	},
    calculate = function(self, card, context)
        if context.crimsonseraphim_before_hightlighted_moved and #G.hand.highlighted > 1 then
            local c = pseudorandom_element(G.hand.highlighted, pseudoseed("crimsonseraphim_falx_sulphurata_card"))
            if c then
                c.area:remove_card(c)
                SMODS.destroy_cards(c, nil, true)
                G.E_MANAGER:add_event(Event{
                    func = function()
                        play_sound("fac_crimsonseraphim_sulfur_slash")
                        return true
                    end 
                })
                delay(0.75)
            end
            return nil, true
        end
    end
}

FishAndChips.Fish {
	key = "crimsonseraphim_squalus_aeternus",
	atlas = "crimsonseraphim_aeonfish",
	pos = { x = 2, y = 3 },
	weight = 2, 
	ppu_coder = { "crimsonseraphim" },
	ppu_artist = { "crimsonseraphim" },
	attributes = { "usable" },
	environments = {
        volcano = 5,
        styx = 5,
        swamp = 5
	},
    stats = {
		weight = {min = 0.3, max = 1.5},
		length = {min = 0.25, max = 0.5}
	},
    can_use = function(self, card)
        local h = {}
        for i, v in pairs(G.jokers.highlighted) do
            if v.ability.eternal then h[#h+1] = v end
        end
        for i, v in pairs(G.fac_fish_area.highlighted) do
            if v.ability.eternal and v ~= card then h[#h+1] = v end
        end
        return #h > 0 and not card.ability.eternal
    end,
    use = function(self, card)
        local h = {}
        for i, v in pairs(G.jokers.highlighted) do
            if v.ability.eternal then h[#h+1] = v end
        end
        for i, v in pairs(G.fac_fish_area.highlighted) do
            if v.ability.eternal and v ~= card then h[#h+1] = v end
        end
        local c = pseudorandom_element(h, pseudoseed("crimsonseraphim_squalus_aeternus"))
        c.ability.eternal = false
        card.ability.eternal = true
    end,
    keep_on_use = function()
        return true
    end,
    add_to_deck = function()
        G.fac_fish_area.config.highlighted_limit = 2
    end,
    remove_from_deck = function()
        if #SMODS.find_card("fish_fac_crimsonseraphim_squalus_aeternus") <= 0 then
            G.fac_fish_area.config.highlighted_limit = 1
        end
    end,
    loc_vars = function(_, info_queue) 
        info_queue[#info_queue+1] = {set = "Other", key = "eternal"}
    end,
    requires_jokers = true
}

FishAndChips.Fish {
	key = "crimsonseraphim_vanitas",
	atlas = "crimsonseraphim_aeonfish",
	pos = { x = 2, y = 1 },
	weight = 2, 
	ppu_coder = { "crimsonseraphim" },
	ppu_artist = { "crimsonseraphim" },
	attributes = { "generation" },
	environments = {
        volcano = 5,
        styx = 5,
        swamp = 5
	},
    stats = {
		weight = {min = 200, max = 300},
		length = {min = 12, max = 13}
	},
    loc_vars = function(_, info_queue)
        info_queue[#info_queue+1] = {set = "Other", key = "crimsonseraphim_temporary"}
    end,
    blueprint_compat = false,
    calculate = function(self, card, context)
        if context.setting_blind then
            for i = 1, G.fac_fish_area.config.card_limit - #G.fac_fish_area.cards do
                local card = SMODS.add_card{set = "fac_Fish", area = G.fac_fish_area}
                card:start_materialize()
                card.ability.crimsonseraphim_temporary = true
            end
        end
    end
}

for i, v in pairs(FishAndChips.crimsonseraphim.C) do
    G.ARGS.LOC_COLOURS[i] = v
end

FishAndChips.Fish {
	key = "crimsonseraphim_silly_bunny",
	atlas = "crimsonseraphim_aeonfish",
	pos = { x = 6, y = 1 },
	weight = 2, 
	ppu_coder = { "crimsonseraphim" },
	ppu_artist = { "crimsonseraphim" },
	attributes = { "generation" },
	environments = {
        calm_pond = 5
	},
    stats = {
		weight = {min = 1.1, max = 1.6},
		length = {min = .25, max = .30}
	},
    blueprint_compat = false,
    calculate = function(self, card, context)
        if context.crimsonseraphim_before_hightlighted_moved then
            local xmult = 1
            if #G.fac_fish_area.cards > 1 then
                local self_pos = 1
                for i, v in pairs(G.fac_fish_area.cards) do
                    if v == card then self_pos = i end
                end
                local position = pseudorandom("crimsonseraphim_crimsonseraphim_silly_bunny", 1, #G.fac_fish_area.cards)
                local other = G.fac_fish_area.cards[position]
                G.fac_fish_area.cards[position] = card
                G.fac_fish_area.cards[self_pos] = other
                play_sound("fac_crimsonseraphim_bounce")
                xmult = self_pos
            end
        end
        if context.joker_main then
            local self_pos = 1
            for i, v in pairs(G.fac_fish_area.cards) do
                if v == card then self_pos = i end
            end
            return {
                xmult = self_pos
            }
        end
    end,
    set_card_type_badge = function(self, card, badges)
		badges[1] = create_badge(localize("k_fac_maybe_fish"), get_type_colour(self or card.config, card), nil, 1.2)
	end,
}

FishAndChips.Fish {
	key = "crimsonseraphim_ronald_reagan_2",
	atlas = "crimsonseraphim_aeonfish",
	pos = { x = 1, y = 3 },
	weight = 2, 
	ppu_coder = { "crimsonseraphim" },
	ppu_artist = { "crimsonseraphim" },
	attributes = { "mod_chance" },
	environments = {
        calm_pond = 5
	},
    stats = {
		weight = {min = .1, max = .3},
		length = {min = 0.1, max = .20}
	},
    blueprint_compat = false,
    calculate = function(self, card, context)
        if context.end_of_round and context.main_eval then
            for i, v in pairs(G.fac_fish_area.cards) do
                v.ability.crimsonseraphim_ronald_reagan_is_my_saviour
                = (v.ability.crimsonseraphim_ronald_reagan_is_my_saviour or 1) + 0.2
                SMODS.calculate_effect{card = v, message = localize("k_upgrade_ex")}
            end 
        end
        if context.mod_probability and context.trigger_obj and context.trigger_obj.ability 
        and context.trigger_obj.ability.crimsonseraphim_ronald_reagan_is_my_saviour then
            return {
                numerator = context.numerator * context.trigger_obj.ability.crimsonseraphim_ronald_reagan_is_my_saviour
            }
        end
    end
}

FishAndChips.Fish {
	key = "crimsonseraphim_picayune_cursedfish",
	atlas = "crimsonseraphim_picayune",
	pos = { x = 0, y = 0 },
	weight = 2, 
	ppu_coder = { "crimsonseraphim" },
	ppu_artist = { "crimsonseraphim" },
	attributes = { "usable", "generation" },
	environments = {
        wormhole = 5
	},
    stats = {
		weight = {min = .2, max = .6},
		length = {min = 0.4, max = .70}
	},
    blueprint_compat = false,
    use = function()
        G.FUNCS.overlay_menu {
            definition = create_UIBox_crimsonseraphim_cursedfish()
        }
    end,
    can_use = function()
        return true
    end
}

FishAndChips.Fish {
	key = "crimsonseraphim_miniaturized_exoplanet",
	atlas = "crimsonseraphim_aeonfish",
	pos = { x = 1, y = 2 },
	weight = 2, 
	ppu_coder = { "crimsonseraphim" },
	ppu_artist = { "crimsonseraphim" },
	attributes = { "usable" },
	environments = {
        wormhole = 5
	},
    stats = {
		weight = {min = 1, max = 1},
		length = {min = 1, max = 1}
	},
    config = {
        extra = {
            planets = 4
        }
    },
    loc_vars = function(self, _, card)
        return {
            vars = {
                card.ability.extra.planets
            }
        }
    end,
    blueprint_compat = false,
    use = function(self, card)
        if G.GAME.fac_fish_expanded then
            G.FUNCS.fac_open_fishing_menu()
        end
        G.E_MANAGER:add_event(Event{
            trigger = "after",
            func = function()
                local area
                if G.STATE == G.STATES.HAND_PLAYED then
                    if not G.redeemed_vouchers_during_hand then
                        G.redeemed_vouchers_during_hand =
                            CardArea(G.play.T.x, G.play.T.y, G.play.T.w, G.play.T.h, { type = "play", card_limit = 5 })
                    end
                    area = G.redeemed_vouchers_during_hand
                else
                    area = G.play
                end
                for i = 1, card.ability.extra.planets do
                    local card = SMODS.create_card{set = "Planet"}
                    card:add_to_deck()
                    area:emplace(card)

                    local top_dynatext = nil
                    
                    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                            top_dynatext = DynaText({string = localize{type = 'name_text', set = card.config.center.set, key = card.config.center.key}, colours = {G.C.WHITE}, rotate = 1,shadow = true, bump = true,float=true, scale = 0.9, pop_in = 0.6/G.SPEEDFACTOR, pop_in_rate = 1.5*G.SPEEDFACTOR})
                            card:juice_up(0.3, 0.5)
                            play_sound('card1')
                            play_sound('coin1')
                            card.children.top_disp = UIBox{
                                definition =    {n=G.UIT.ROOT, config = {align = 'tm', r = 0.15, colour = G.C.CLEAR, padding = 0.15}, nodes={
                                                    {n=G.UIT.O, config={object = top_dynatext}}
                                                }},
                                config = {align="tm", offset = {x=0,y=0},parent = card}
                            }
    
                        return true end }))
                    --G.GAME.current_round.voucher = nil


                    delay(0.6)
                    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 2.6, func = function()
                        top_dynatext:pop_out(4)
                        return true end }))
                    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.5, func = function()
                        card.children.top_disp:remove()
                        card.children.top_disp = nil
                    return true end }))

                    card:use_consumeable()
                    G.E_MANAGER:add_event(Event{
                        trigger = "after",
                        func = function()
                            card:start_dissolve()
                            return true
                        end
                    })
                end
                return true
            end
        })
    end,
    can_use = function()
        return true
    end,
    set_card_type_badge = function(self, card, badges)
		badges[1] = create_badge(localize("k_planet"), get_type_colour(self or card.config, card), nil, 1.2)
	end,
}

FishAndChips.crimsonseraphim.lotus_alts = {
    "mf", "maxboi", "eris", "squeax09", "cassknows", "jade", "ruby",
    "lizie"
}
for i, v in pairs(FishAndChips.crimsonseraphim.lotus_alts) do
    SMODS.Atlas {
        key = "crimsonseraphim_lotus_"..v,
        path = "crimsonseraphim/lotuses/"..v..".png",
        px = 71, py = 95,
        atlas_table = "ANIMATION_ATLAS",
        fps = 10,
        frames = 8
    }
end

local load_profile = Game.load_profile
function Game:load_profile(p, ...)
    local ret = load_profile(self, p, ...)
    if G.P_CENTERS.fish_fac_crimsonseraphim_nameless_lotus then
        if not G.PROFILES[p] then p = 1 end
        local prof = G.PROFILES[p]
        G.P_CENTERS.fish_fac_crimsonseraphim_nameless_lotus.atlas = "fac_crimsonseraphim_lotus_default"
        for i, v in pairs(FishAndChips.crimsonseraphim.lotus_alts) do
            if string.lower(prof.name) == v then
                G.P_CENTERS.fish_fac_crimsonseraphim_nameless_lotus.atlas = "fac_crimsonseraphim_lotus_"..v
            end
        end
    end
    return ret
end
local save_settings = G.save_settings
function G:save_settings(...)
    save_settings(self, ...)
    if G.P_CENTERS.fish_fac_crimsonseraphim_nameless_lotus then
        local prof = G.PROFILES[G.SETTINGS.profile]
        G.P_CENTERS.fish_fac_crimsonseraphim_nameless_lotus.atlas = "fac_crimsonseraphim_lotus_default"
        for i, v in pairs(FishAndChips.crimsonseraphim.lotus_alts) do
            if string.lower(prof.name) == v then
                G.P_CENTERS.fish_fac_crimsonseraphim_nameless_lotus.atlas = "fac_crimsonseraphim_lotus_"..v
            end
        end
    end
end

FishAndChips.Fish {
	key = "crimsonseraphim_nameless_lotus",
	atlas = "crimsonseraphim_lotus_default",
	pos = { x = 0, y = 0 },
	weight = 2, 
	ppu_coder = { "crimsonseraphim" },
	ppu_artist = { "crimsonseraphim" },
	attributes = { "xmult" },

	environments = {
        wormhole = 5,
        garden = 5, 
	},
    stats = {
		weight = {min = 0, max = 0},
		length = {min = 0, max = 0}
	},
    config = {
        extra = {
            mult = 1
        }
    },
    flavour_vars = function()
        return {
            vars = {
                elements = {
                    FishAndChips.crimsonseraphim.get_word_cycle("determiners"),
                    FishAndChips.crimsonseraphim.get_word_cycle("adjectives"),
                    FishAndChips.crimsonseraphim.get_word_cycle("nouns"),
                    FishAndChips.crimsonseraphim.get_word_cycle("verbs"),
                    FishAndChips.crimsonseraphim.get_word_cycle("prepositions"),
                    FishAndChips.crimsonseraphim.get_word_cycle("determiners"),
                    FishAndChips.crimsonseraphim.get_word_cycle("adjectives"),
                    FishAndChips.crimsonseraphim.get_word_cycle("nouns")
                }
            }
        }
    end,
    loc_vars = function(self, _, card)
        local heart
        for i, v in pairs(FishAndChips.crimsonseraphim.lotus_alts) do
            if string.lower(G.PROFILES[G.SETTINGS.profile].name) == v then
                heart = true
            end
        end
        return {
            vars = {
                card.ability.extra.mult,
                card.ability.extra.mult * FishAndChips.crimsonseraphim.count_developers(),
            },
            name_key = heart and "fish_fac_crimsonseraphim_nameless_lotus_heart" or nil
        }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                xmult = card.ability.extra.mult * FishAndChips.crimsonseraphim.count_developers()
            }
        end
    end,
    set_card_type_badge = function(self, card, badges)
		badges[1] = create_badge(localize("k_fac_crimsonseraephim_questionmarks"), get_type_colour(self or card.config, card), nil, 1.2)
	end,
}

FishAndChips.Fish {
	key = "crimsonseraphim_sans_door",
	atlas = "crimsonseraphim_door",
	pos = { x = 1, y = 0 },
	weight = 2, 
	ppu_coder = { "crimsonseraphim" },
	ppu_artist = { "crimsonseraphim" },
	attributes = { "useable" },

	environments = {
        wormhole = 5,
        garden = 5, 
	},
    stats = {
		weight = {min = 5, max = 5},
		length = {min = 1.9, max = 1.9}
	},
    config = {
        extra = {
            environment = "calm_pond",
            cost = 3
        }
    },
    loc_vars = function(self, _, card)
        return {
            vars = {
                card.ability.extra.cost,
                localize{type = "name_text", set = "fac_Env", key = card.ability.extra.environment}
            },
        }
    end,
    use = function(self, card)
        G.TAROT_INTERRUPT = nil
        FishAndChips:stop_ambience()
		local old_env = G.GAME.fac_fishing_environment
		G.GAME.fac_fishing_environment = card.ability.extra.environment
		SMODS.calculate_context{fac_environment_changed = G.GAME.fac_fishing_environment, old_environment = old_env, forced = true}
		G.FISHING_STATE = G.FISHING_STATES.MOVING
		G.FISHING_STATE_COMPLETE = false
        SMODS.scale_card(card, {
            ref_table = card.ability.extra,
            ref_value = "cost"
        })
        ease_dollars(-card.ability.extra.cost)
        card.ability.extra.environment = pseudorandom_element(FishAndChips.Environments, "fac_next_location", {
			in_pool = function (v, args)
				return v.key ~= G.GAME.fac_fishing_environment
			end
		}).key
    end,
    can_use = function(self, card)
        return G.GAME.dollars + G.GAME.bankrupt_at > card.ability.extra.cost
    end,
    keep_on_use = function()
        return true
    end,
    no_rotation = true,
    calculate = function(self, card, context)
        if context.end_of_round and context.main_eval then
            card.ability.extra.cost = 3
            return {
                message = localize("k_reset_ex")
            }
        end
    end,
    set_card_type_badge = function(self, card, badges)
		badges[1] = create_badge(localize("k_fac_crimsonseraephim_game_object"), get_type_colour(self or card.config, card), nil, 1.2)
	end,
}

SMODS.draw_ignore_keys.crimsonseraphim_sans_door_canvas = true
SMODS.DrawStep({
	key = "crimsonseraphim_sans_door",
	order = 25,
	func = function(self)
        local card = self.config.center_key
        if (card ~= "fish_fac_crimsonseraphim_sans_door") or not self.config.center.discovered  then return end
        if not self.children.crimsonseraphim_sans_door_canvas then 
            self.children.crimsonseraphim_sans_door_canvas = SMODS.CanvasSprite(
                {X=0, Y=0, W=71, H=95, canvasW=71, canvasH=95, canvasScale=1}
            )
        end
        love.graphics.push()
        love.graphics.origin()
        self.children.crimsonseraphim_sans_door_canvas.canvas:renderTo(function() 
            local scale = G.T_CANV_SCALE or 1.25
            love.graphics.clear({0,0,0,1})
            local environment = FishAndChips.Environments[self.ability.extra.environment]
            local atlas = SMODS.get_atlas(environment.atlas == "fac_Env" and "fac_background" or environment.atlas)
            local pos = environment.background_pos or {x=0,y=0}
            love.graphics.setColor(G.C.WHITE)
            local quad = love.graphics.newQuad(560 * pos.x, 322 * pos.y, 560, 322, atlas.image:getWidth(), atlas.image:getHeight())
            local ts = 3.3488*3.3488
            love.graphics.draw(atlas.image, quad, -self.T.x*ts*scale*2*scale, -self.T.y*ts*scale*2*scale, 0, scale, scale, 0, 0) 

            local open = self.area == G.fac_fish_area
            local quad = love.graphics.newQuad(open and 71 or 0, 0, 71, 95, 71*2, 95)
            local di = SMODS.get_atlas("fac_crimsonseraphim_door").image
            love.graphics.draw(di, quad, 0,0, 0, 1,1, 0, 0) 
        end)
        love.graphics.pop()
        self.children.crimsonseraphim_sans_door_canvas.role.draw_major = self
        FishAndChips.crimsonseraphim.draw_sprite(self.children.crimsonseraphim_sans_door_canvas, self, {
            nil, nil, nil, self.children.center
        })
	end,
	conditions = { vortex = false, facing = "front" },
})


FishAndChips.Fish {
	key = "crimsonseraphim_roaring_fish",
	atlas = "crimsonseraphim_aeonfish",
	pos = { x = 2, y = 2 },
	weight = 2, 
	ppu_coder = { "crimsonseraphim" },
	ppu_artist = { "crimsonseraphim" },
	attributes = { "destroy_card", },

	environments = {
        wormhole = 5,
        garden = 5, 
	},
    stats = {
		weight = {min = 0.1, max = 0.2},
		length = {min = 0.15, max = 0.2}
	},
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.e_negative
    end,
    calculate = function(self, card, context)
        if context.ending_shop then
            local cards = {}
            for i, v in pairs(G.fac_fish_area.cards) do
                if not SMODS.is_eternal(v) then
                    cards[#cards+1] = v
                end
            end
            FishAndChips.crimsonseraphim.swoon()
            G.E_MANAGER:add_event(Event{
                func = function()
                    pseudoshuffle(cards, pseudoseed("fac_fish_crimsonseraphim_roaring_fish"))
                    cards[1]:start_dissolve()
                    pseudoshuffle(cards, pseudoseed("fac_fish_crimsonseraphim_roaring_fish"))
                    cards[1]:set_edition("e_negative")
                    return true
                end
            })
            return nil, true
        end
    end
}

function FishAndChips.crimsonseraphim.omega_next_fish(cent)
    local av = {}
    for i, v in pairs(G.P_CENTERS) do
        local a 
        if v.ppu_artist then
            for i, v in pairs(v.ppu_artist) do
                for _, j in pairs(cent.ppu_artist or {}) do
                    if j == v then a = true; break end
                end
                if a then break end
            end
        end
        if v.ppu_coder then
            for i, v in pairs(v.ppu_coder) do
                for _, j in pairs(cent.ppu_coder or {}) do
                    if j == v then a = true; break end
                end
                if a then break end
            end
        end
        if a then 
            av[#av+1] = v.key
        end
    end
    return pseudorandom_element(av, pseudoseed("omegabitchkill"))
end

FishAndChips.Fish {
	key = "omega_crimsonfang",
	atlas = "crimsonseraphim_aeonfish",
	pos = { x = 0, y = 3 },
	weight = 2, 
	ppu_coder = { "crimsonseraphim" },
	ppu_artist = { "crimsonseraphim" },
	attributes = { "useable", },

	environments = {
        wormhole = 5,
        aquifer = 5, 
        backroom = 5,
        styx = 5
	},
    stats = {
		weight = {min = 0.1, max = 0.2},
		length = {min = 0.15, max = 0.2}
	},
    select_flavor_text = function(self, card)
        local num = pseudorandom("OMEGA_CRIMSONFANGERY", 1, 22)
        local elem
        if num == 2 then
            elem = SMODS.create_sprite(0, 0, 5.5, 5.5 * 75/438, "fac_omega_crimsonfang_lore_alexi")
        end
        if num == 9 then
            elem = SMODS.create_sprite(0, 0, 3, 3 * 66/204, "fac_omega_crimsonfang_lore_mf")
        end
        return num, elem
    end,
    flavour_vars = function(self, info_queue, card)
        local s, e = self:select_flavor_text(card)
        local st = type(localize("k_omega_crimsonfang_"..s)) == "table" and localize("k_omega_crimsonfang_"..s) or {localize("k_omega_crimsonfang_"..s)}
        --
        local n = {}
        for i, v in pairs(st) do
            n[#n+1] = {n=G.UIT.R, config={align = "cm"}, nodes={
                {n=G.UIT.O, config={object = DynaText({ string = st[i], colours = { G.C.JOKER_GREY }, pop_in_rate = 9999999, silent = true, random_element = true, pop_delay = 0.5, scale = 0.32, min_cycle_time = 0 })}}
            }}
        end
        local elem = e or {n=G.UIT.C, config={align = "cm"}, nodes=n}
        return {
            vars = {
                elements = {
                    elem
                }
            }
        }
    end,
    use = function()
        local c = G.fac_fish_area.cards[#G.fac_fish_area.cards]
        G.GAME.fac_forced_fish = FishAndChips.crimsonseraphim.omega_next_fish(c.config.center)
        SMODS.destroy_cards(c, nil, true)
    end,
    can_use = function()
        return true
    end,
    keep_on_use = function()
        return true
    end,
    add_to_deck = function()
        if not G.PROFILES[G.SETTINGS.profile].omega_crimsonfang_obtained then
            FishAndChips.crimsonseraphim.fake_game_over()
            G.PROFILES[G.SETTINGS.profile].omega_crimsonfang_obtained = true
        end
    end,
    set_card_type_badge = function(self, card, badges)
		badges[1] = create_badge(localize("k_fac_crimsonseraephim_omega"), get_type_colour(self or card.config, card), nil, 1.2)
	end,
}

function create_UIBox_omega_game_over()
  local show_lose_cta = false


  local eased_red = copy_table(G.C.RED)
  eased_red[4] = 0
  ease_value(eased_red, 4, 0.8, nil, nil, true)
  local t = create_UIBox_generic_options({ bg_colour = eased_red ,no_back = true, padding = 0, contents = {
    {n=G.UIT.R, config={align = "cm"}, nodes={
      {n=G.UIT.O, config={object = DynaText({string = {localize('ph_game_over')}, colours = {G.C.RED},shadow = true, float = true, scale = 1.5, pop_in = 0.4, maxw = 6.5})}},
    }},
    {n=G.UIT.R, config={align = "cm", padding = 0.15}, nodes={
      {n=G.UIT.C, config={align = "cm"}, nodes={
        {n=G.UIT.R, config={align = "cm", padding = 0.05, colour = G.C.BLACK, emboss = 0.05, r = 0.1}, nodes={
          {n=G.UIT.R, config={align = "cm", padding = 0.08}, nodes={
            create_UIBox_round_scores_row('hand'),
            create_UIBox_round_scores_row('poker_hand'),
          }},
          {n=G.UIT.R, config={align = "cm"}, nodes={
            {n=G.UIT.C, config={align = "cm", padding = 0.08}, nodes={
              create_UIBox_round_scores_row('cards_played', G.C.BLUE),
              create_UIBox_round_scores_row('cards_discarded', G.C.RED),
              create_UIBox_round_scores_row('cards_purchased', G.C.MONEY),
              create_UIBox_round_scores_row('times_rerolled', G.C.GREEN),
              create_UIBox_round_scores_row('new_collection', G.C.WHITE),
              create_UIBox_round_scores_row('seed', G.C.WHITE),
              UIBox_button({button = 'copy_seed', label = {localize('b_copy')}, colour = G.C.BLUE, scale = 0.3, minw = 2.3, minh = 0.4, focus_args = {nav = 'wide'}}),
            }},
            {n=G.UIT.C, config={align = "tr", padding = 0.08}, nodes={
              create_UIBox_round_scores_row('furthest_ante', G.C.FILTER),
              create_UIBox_round_scores_row('furthest_round', G.C.FILTER),
              create_UIBox_round_scores_row('defeated_by'),
            }}
          }}
        }},
        show_lose_cta and 
        {n=G.UIT.R, config={align = "cm", padding = 0.1}, nodes={
          {n=G.UIT.C, config={id = 'lose_cta', align = "cm", minw = 5, padding = 0.1, r = 0.1, hover = true, colour = G.C.GREEN, button = "show_main_cta", shadow = true}, nodes={
            {n=G.UIT.R, config={align = "cm", padding = 0, no_fill = true}, nodes={
              {n=G.UIT.T, config={text = localize('b_next'), scale = 0.5, colour = G.C.UI.TEXT_LIGHT, focus_args = {nav = 'wide', snap_to = true}}}
            }}
          }}
        }} or
        {n=G.UIT.R, config={align = "cm", padding = 0.1}, nodes={
          {n=G.UIT.R, config={id = 'from_game_over', align = "cm", minw = 5, padding = 0.1, r = 0.1, hover = true, colour = G.C.RED, button = "omega_fake_new_run", shadow = true, focus_args = {nav = 'wide', snap_to = true}}, nodes={
            {n=G.UIT.R, config={align = "cm", padding = 0, no_fill = true, maxw = 4.8}, nodes={
              {n=G.UIT.T, config={text = localize('k_give_up'), scale = 0.5, colour = G.C.UI.TEXT_LIGHT}}
            }}
          }},
        }},
        {n=G.UIT.R, config={align = "cm", padding = 0.1}, nodes={
          {n=G.UIT.R, config={id = 'from_game_over', align = "cm", minw = 5, padding = 0.1, r = 0.1, hover = true, colour = G.C.RED, button = "omega_fake_new_run", shadow = true, focus_args = {nav = 'wide', snap_to = true}}, nodes={
            {n=G.UIT.R, config={align = "cm", padding = 0, no_fill = true, maxw = 4.8}, nodes={
              {n=G.UIT.T, config={text = localize('k_lose_hope'), scale = 0.5, colour = G.C.UI.TEXT_LIGHT}}
            }}
          }},
        }}
      }},
    }}
}})
  return t
end

function FishAndChips.crimsonseraphim.fake_game_over()
    G.SETTINGS.paused = true
    G.GAME.omega_fake_death = true
    G.FUNCS.overlay_menu{
        definition = create_UIBox_omega_game_over(),
        config = {no_esc = true}
    }
    G.E_MANAGER:add_event(Event{
        delay = 2.5,
        timer = "REAL",
        trigger = "after",
        func = function()
            love.graphics.captureScreenshot( function ( data )
                FishAndChips.crimsonseraphim.door_image = love.graphics.newImage( data )
                FishAndChips.crimsonseraphim.door_timer = 4.3
                play_sound("fac_crimsonseraphim_spacejumpscare")
                G.OMEGA_CRIMSONFANG_FACE = 0
            end )
            return true
        end
    })
end

G.FUNCS.omega_fake_new_run = function()
 
end

function _G.create_UIBox_text_popup(txt)
    local nodes = {}
    for _, str in ipairs(_G.str_sepr(txt,"\n")) do 
        nodes[#nodes+1] = {n=G.UIT.R, config={}, nodes = {{n=G.UIT.T, config={text = str, scale = 0.5, colour = G.C.UI.TEXT_LIGHT}}}}       
    end
    return create_UIBox_generic_options { --this function is vanilla its generic boilerplate stuff, its the thing that creates the "menu" and the back button
        contents = {{n=G.UIT.C, config={}, nodes = nodes}}
    }
end

function _G.str_sepr(inputstr, sep)
        if sep == nil then sep = "%s" end
    local t = {}
    for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
        table.insert(t, str)
    end
    return t
end