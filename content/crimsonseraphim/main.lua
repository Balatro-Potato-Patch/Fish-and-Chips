FishAndChips.crimsonseraphim = {
    C = {
        spectral_gradient = SMODS.Gradient {
            key = "spectral_gradient",
            colours = {
                HEX"5e7297",
                HEX"c7b24a"
            }
        },
        stupid_fucking_DOGGYYYYIEEEs = SMODS.Gradient {
            key = "stupid_fucking_DOGGYYYYIEEEs",
            colours = {
                G.C.RED,
                G.C.GREEN
            }
        },
        crimsonseraphim_transparent = {0,0,0,0}
    }
}

SMODS.Atlas({
	key = "crimsonseraphim_credits",
	path = "crimsonseraphim/credits.png",
	px = 71,
	py = 95,
})

PotatoPatchUtils.Developer({
	name = 'crimsonseraphim',
	atlas = 'fac_crimsonseraphim_credits',
	colour = FishAndChips.crimsonseraphim.C.stupid_fucking_DOGGYYYYIEEEs,
    loc = true,
})

FishAndChips.Fish {
	key = "aeonfish",
	atlas = "crimsonseraphim_aeonfish",
	pos = { x = 0, y = 0 },
	weight = 3,
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

SMODS.Sound {
    key = "crimsonseraphim_shimmer",
    path = "crimsonseraphim/shimmer.ogg"
}

function Card:transmute(seed, center)
    local result = center
    local s = {
        w = self.T.w / self.original_T.w,
        h = self.T.h / self.original_T.h
    }
    if not center then
        local valid = {}
        for attribute, _ in pairs(self.config.center.attributes or {}) do
            if type(attribute) ~= "number" and not FishAndChips.Environments[attribute] then
                valid[#valid+1] = attribute
            end
        end
        result = G.P_CENTERS[SMODS.poll_object{type = "fac_Fish", attributes = valid, union = true}]
    end
    self.children.center.aeonfish_transmute = {
        realtime_start = G.TIMERS.REAL,
        image = SMODS.create_sprite(0, 0, G.CARD_W, G.CARD_H, result.atlas, result.pos),
        center = result
    }
    self.states.hover.can = false
    play_sound("fac_crimsonseraphim_shimmer")
    G.E_MANAGER:add_event(Event{
        blocking = false,
        func = function()
            if G.TIMERS.REAL - self.children.center.aeonfish_transmute.realtime_start > 0.6 then
                self:set_ability(self.children.center.aeonfish_transmute.center)
                self.children.center.aeonfish_transmute = nil
                self.states.hover.can = true
                self.T.w = self.T.w * s.w
                self.T.h = self.T.h * s.h
                return true
            end
        end
    })
    G.E_MANAGER:add_event(Event{
        blocking = false,
        func = function()
            if math.abs((G.TIMERS.REAL - self.children.center.aeonfish_transmute.realtime_start) - 0.2) < 0.01 then
                self:juice_up(0.6, 0.7)
                return true
            end
        end
    })
end

local data = NFS.newFileData(FishAndChips.mod.path .."/assets/1x/crimsonseraphim/caustics-texture.png")
local _caustics = love.graphics.newImage(data)
SMODS.Shader({
    key="aeonfish_caustics",
    path="crimsonseraphim/aeonfish_caustics.fs",
    send_vars = function (sprite, card)
        return {
            realtime = G.TIMERS.REAL,
            caustic_image = _caustics
        }
    end,
})

SMODS.Shader({
    key="aeonfish_transmute",
    path="crimsonseraphim/aeonfish_transmute.fs",
    send_vars = function (sprite, card)
        return {
            realtime_offset = G.TIMERS.REAL - sprite.aeonfish_transmute.realtime_start,
            reverse = not sprite.aeonfish_transmute.image,
        }
    end,
})

SMODS.Atlas {
    key = "crimsonseraphim_aeonfish",
    path = "crimsonseraphim/aeonfish.png",
    px = 71,
    py = 95
}

SMODS.DrawStep({
	key = "aeonfish",
	order = 25,
	func = function(self)
        local card = self.config.center_key
        if (card ~= "fish_fac_aeonfish" and card ~= "fish_fac_gungir")  then return end
        if card == "fish_fac_gungir" and not self.ability.extra.charged then return end
        self.children.center:draw_shader('fac_aeonfish_caustics', nil, self.ARGS.send_to_shader)
	end,
	conditions = { vortex = false, facing = "front" },
})

SMODS.DrawStep({
	key = "aeonfish_transmute",
	order = 25,
	func = function(self)
        if not self.children.center.aeonfish_transmute then return end  
        self.shadow_height = ((((self.highlighted and self.area == G.play) or self.states.drag.is) and 0.35) or (self.area and self.area.config.type == 'title_2') and 0.04 or 0.1)
        local sprite = self.children.center.aeonfish_transmute.image
        sprite.role.draw_major = self
        sprite.aeonfish_transmute = {
            realtime_start = self.children.center.aeonfish_transmute.realtime_start,
            reverse = true
        }
        self.children.center:draw_shader('fac_aeonfish_transmute', nil, self.ARGS.send_to_shader)
        sprite:draw_shaders('fac_aeonfish_transmute', nil, self.ARGS.send_to_shader, nil, self.children.center)
	end,
	conditions = { vortex = false, facing = "front" },
})

SMODS.Atlas({
	key = "mealy_lore",
	path = "crimsonseraphim/mealy_lore.png",
	px = 1125,
	py = 1086,
})

local should_draw_base_ref = Card.should_draw_base_shader
function Card:should_draw_base_shader(...)
    if self.children.center.aeonfish_transmute then return nil end
    return should_draw_base_ref(self, ...)
end

--When a fish is obtained sell it and this fish for 3x the sell price
FishAndChips.Fish {
	key = "mealy_apple",
	atlas = "crimsonseraphim_aeonfish",
	pos = { x = 0, y = 1 },
	weight = 3,
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
	loc_vars = function(self, info_queue, card)
		return { vars = { elements = { SMODS.create_sprite(0, 0, 2, 2 * 1125 / 1086, "fac_mealy_lore") } } }
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
}


FishAndChips.Fish {
	key = "jade_crystalfish",
	atlas = "crimsonseraphim_aeonfish",
	pos = { x = 5, y = 0 },
	weight = 3,
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
		return { vars = { num, dem, num2, dem2, localize{type = "name_text", set = "fac_Fish", key = "fish_fac_ruby_crystalfish"} } }
	end,
	calculate = function(self, card, context)
		if context.end_of_round and context.main_eval and SMODS.pseudorandom_probability(
            card, "fac_crimsonseraphim_jade_crystalfish", 1, card.ability.extra.odds
        ) then
            card:transmute(nil, G.P_CENTERS.fish_fac_ruby_crystalfish)
        end
        if context.fac_fish_caught and SMODS.pseudorandom_probability(
            card, "fac_crimsonseraphim_jade_crystalfish_seal", 1, card.ability.extra.odds_seal
        ) then
            context.fac_fish_caught:set_fish_seal(pseudorandom_element(SMODS.Seals, pseudoseed("jadefish_seal")).key)
        end
	end,
}

SMODS.Atlas({
	key = "crimsonseraphim_fish_seals",
	path = "crimsonseraphim/fish_seals.png",
	px = 71,
	py = 95,
})

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

function FishAndChips.crimsonseraphim.calculate_fish_seal(card, context)
    if card.fish_seal and FishAndChips.crimsonseraphim.fish_seals[card.fish_seal] and FishAndChips.crimsonseraphim.fish_seals[card.fish_seal].calculate then
        return FishAndChips.crimsonseraphim.fish_seals[card.fish_seal].calculate(card, context)
    end
end

function Card:set_fish_seal(_seal, silent, immediate)
    local fish_seals = FishAndChips.crimsonseraphim.fish_seals
    self.seal = nil
    if _seal then
        self.fish_seal = _seal
        self.ability.fish_seal = {}
        self.ability.fish_seal.key = _seal
        for k, v in pairs(fish_seals[_seal] and fish_seals[_seal].config or G.P_SEALS[_seal].config or {}) do
            if type(v) == 'table' then
                self.ability.fish_seal[k] = copy_table(v)
            else
                self.ability.fish_seal[k] = v
            end
        end
        
        self.ability.delay_seal = not silent
    
        G.CONTROLLER.locks.seal = true
        local sound = (fish_seals[_seal] and fish_seals[_seal].sound or G.P_SEALS[_seal].sound) or {sound = 'gold_seal', per = 1.2, vol = 0.4}
        if immediate then 
            self:juice_up(0.3, 0.3)
            self.ability.delay_seal = false
            play_sound(sound.sound, sound.per, sound.vol)
            G.CONTROLLER.locks.seal = false
        else
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.3,
                func = function()
                    self:juice_up(0.3, 0.3)
                    self.ability.delay_seal = false
                    play_sound(sound.sound, sound.per, sound.vol)
                return true
                end
            }))
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                    G.CONTROLLER.locks.seal = false
                return true
                end
            }))
        end
        if type(fish_seals[_seal] and fish_seals[_seal].on_apply) == "function" then
            fish_seals[_seal]:on_apply(self)
        end
    end
    self:set_cost()
end

SMODS.DrawStep {
    key = 'fish_seal',
    order = 30,
    func = function(self, layer)
        local fish_seals = FishAndChips.crimsonseraphim.fish_seals
        local seal = fish_seals[self.fish_seal] and fish_seals[self.fish_seal] or G.P_SEALS[self.fish_seal] or {}
        if self.ability.delay_seal then return end
        if type(seal.draw) == 'function' then
            (seal.draw):draw(self, layer)
        elseif self.fish_seal then
            G.shared_seals["fish_"..self.fish_seal] = G.shared_seals["fish_"..self.fish_seal] or SMODS.create_sprite(0, 0, 2, 2, seal.atlas, seal.pos)
            G.shared_seals["fish_"..self.fish_seal].role.draw_major = self
            G.shared_seals["fish_"..self.fish_seal]:draw_shader('dissolve', nil, nil, nil, self.children.center)
            if self.fish_seal == 'Gold' then G.shared_seals["fish_"..self.fish_seal]:draw_shader('voucher', nil, self.ARGS.send_to_shader, nil, self.children.center) end
        end
    end,
    conditions = { vortex = false, facing = 'front' },
}

local get_badge_colour_ref = get_badge_colour
function get_badge_colour(key)
    return get_badge_colour_ref(key:gsub("fish_seal", "seal"))
end

FishAndChips.Fish {
	key = "ruby_crystalfish",
	atlas = "crimsonseraphim_aeonfish",
	pos = { x = 6, y = 0 },
	weight = 3,
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
        return {vars = {num, dem, localize{type = "name_text", set = "fac_Fish", key = "fish_fac_jade_crystalfish"}}}
	end,
	calculate = function(self, card, context)
		if context.end_of_round and context.main_eval and SMODS.pseudorandom_probability(
            card, "fac_crimsonseraphim_ruby_crystalfish", 1, card.ability.extra.odds
        ) then
            card:transmute(nil, G.P_CENTERS.fish_fac_jade_crystalfish)
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

local get_poker_hand_info_ref = G.FUNCS.get_poker_hand_info
function G.FUNCS.get_poker_hand_info(_cards)
    local cards = {}
    for i, v in pairs(_cards) do
        cards[#cards+1] = v
    end
    if next(SMODS.find_card("fish_fac_ruby_crystalfish")) then
        for i, v in pairs(G.I.CARD) do
            if v.config and v.config.center and v.config.center.set == "fac_Fish" and not SMODS.in_scoring(_cards, v) and v.base.suit then
                cards[#cards+1] = v
            end
        end
    end
    return get_poker_hand_info_ref(cards)
end

FishAndChips.Fish {
	key = "hammerhead_shark",
	atlas = "crimsonseraphim_aeonfish",
	pos = { x = 0, y = 0 },
	weight = 3, 
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
}

SMODS.Sound {
    key = "crimsonseraphim_forge",
    path = "crimsonseraphim/forge.ogg"
}

function Card:jokered_forge() 
    self.ability.crimsonseraphim_forged = pseudorandom_element({
        "fac_crimsonseraphim_forged_mult",
        "fac_crimsonseraphim_forged_chips",
        "fac_crimsonseraphim_forged_money",
        "fac_crimsonseraphim_forged_sand",
    })

    self:juice_up()
    play_sound("fac_crimsonseraphim_forge")
end

function FishAndChips.crimsonseraphim.create_forge_text(cfg)
    if not cfg.crimsonseraphim_forged then return end
    local text = G.localization.descriptions.Other[cfg.crimsonseraphim_forged].text or {}
    if #text == 0 then return end
    return text
end

local forge_effects = {
    fac_crimsonseraphim_forged_mult = function(c, context)
        if context.main_scoring then
            return {mult = 4}
        end
    end,
    fac_crimsonseraphim_forged_chips = function(c, context)
        if context.main_scoring then
            return {chips = 15}
        end
    end,
    fac_crimsonseraphim_forged_money = function(c, context)
        if context.setting_blind then
            return {dollars  = 4}
        end
    end,
    fac_crimsonseraphim_forged_sand = function(c, context)
        if context.fac_end_fishing and context.fish then
            return {sand_dollars = 1}
        end
    end,
}

function FishAndChips.crimsonseraphim.calculate_forged_joker(card, context)
    if card.ability.crimsonseraphim_forged and forge_effects[card.ability.crimsonseraphim_forged] then
        return forge_effects[card.ability.crimsonseraphim_forged](card, context)
    end
end

FishAndChips.Fish {
	key = "ghost_chaosfish",
	atlas = "crimsonseraphim_aeonfish",
	pos = { x = 1, y = 0 },
	weight = 3, 
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
        if pseudorandom("fac_ghost_chaosfish") < 0.2 then
			return pseudorandom_element(FishAndChips.Environments, "fac_ghost_chaosfish_poll", {
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
    -- calculate = function(self, card, context)
    --     if context.fac_end_fishing then
    --         if not context.perfect and G.GAME.fac_active_bait == "fish_fac_ghost_chaosfish" then
    --             if not G.GHOST_CHAOSFISH_SLICED then
    --                 G.GHOST_CHAOSFISH_SLICED = true
    --                 SMODS.destroy_cards(FishAndChips.crimsonseraphim.find_fish("fish_fac_ghost_chaosfish")[1], nil, true)
    --                 G.E_MANAGER:add_event(Event{func = function()
    --                     G.GHOST_CHAOSFISH_SLICED = nil
    --                     return true
    --                 end, trigger = "after"})
    --             end
    --         end
    --         local e
    --         if #G.GAME.fac_bait_inventory == 0 or (G.GAME.fac_bait_inventory[1] and G.GAME.fac_bait_inventory[1].key == "fish_fac_ghost_chaosfish") then
    --             e = true
    --         end
    --         G.E_MANAGER:add_event(Event{func = function()
    --             FishAndChips.clean_up_bait_inventory()
    --             if e then
    --                 G.FUNCS.fac_set_active_bait({ config = G.GAME.fac_bait_inventory[1] })
    --             end
    --             return true
    --         end})
    --     end
    -- end,
    -- on_caught = function()
    --     G.E_MANAGER:add_event(Event{func = function()
    --         FishAndChips.clean_up_bait_inventory()
    --         return true
    --     end})
    -- end
}

local poll_fish_ref = FishAndChips.poll_fish
function FishAndChips.poll_fish(_fevn)
    for i, v in pairs(SMODS.find_card("fish_fac_ghost_chaosfish")) do
        _fenv = _fenv or v.config.center:force_environment(v)
    end
    return poll_fish_ref(_fevn)
end

local card_eval_status_text_ref = card_eval_status_text
function card_eval_status_text(card, ...)
    if card then
        card_eval_status_text_ref(card, ...)
    end
end

-- local bait_inv_ref = FishAndChips.clean_up_bait_inventory
-- function FishAndChips.clean_up_bait_inventory()
--     bait_inv_ref()
--     if not G.GAME.fac_bait_inventory[1] or not G.GAME.fac_bait_inventory[1].amt or G.GAME.fac_bait_inventory[1].key == "fish_fac_ghost_chaosfish" then
--         G.GAME.fac_bait_inventory = {}
--     end
--     if next(FishAndChips.crimsonseraphim.find_fish("fish_fac_ghost_chaosfish")) and #G.GAME.fac_bait_inventory == 0 then
--         local tbl = SMODS.shallow_copy(G.P_CENTERS.fish_fac_ghost_chaosfish)
--         tbl.amt = #FishAndChips.crimsonseraphim.find_fish("fish_fac_ghost_chaosfish")
--         G.GAME.fac_bait_inventory[#G.GAME.fac_bait_inventory+1] = tbl
--     end
-- end

-- function FishAndChips.crimsonseraphim.find_fish(key)
--     local c = SMODS.find_card(key)
--     local cards = {}
--     for i, v in pairs(c) do
--         if v.area == G.fac_fish_area then
--             cards[#cards+1] = v
--         end
--     end
--     return cards
-- end

FishAndChips.Fish {
	key = "laplaces_angelfish",
	atlas = "crimsonseraphim_aeonfish",
	pos = { x = 2, y = 0 },
	weight = 3, 
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

SMODS.Sound {
    key = "crimsonseraphim_gungir_break",
    path = "crimsonseraphim/gungir_break.ogg"
}
SMODS.Sound {
    key = "crimsonseraphim_gungir_charge",
    path = "crimsonseraphim/gungir_charge.ogg"
}
SMODS.Sound {
    key = "crimsonseraphim_gungir_success",
    path = "crimsonseraphim/gungir_success.ogg"
}
SMODS.Sound {
    key = "crimsonseraphim_gungir_decharge",
    path = "crimsonseraphim/gungir_decharge.ogg"
}

FishAndChips.Fish {
	key = "gungir",
	atlas = "crimsonseraphim_aeonfish",
	pos = { x = 3, y = 0 },
	weight = 3, 
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
    end
}

FishAndChips.Fish {
	key = "trout_population",
	atlas = "crimsonseraphim_aeonfish",
	pos = { x = 0, y = 0 },
	weight = 3, 
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
                if pseudorandom("crimsonseraphim_trout_population") < 0.5 then
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
	key = "another_bucket",
	atlas = "bucket",
	pos = { x = 1, y = 1 },
	weight = 3, 
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
}

SMODS.draw_ignore_keys.bucket_front = true
SMODS.DrawStep({
	key = "bucket",
	order = 25,
	func = function(self)
        local card = self.config.center_key
        if (card ~= "fish_fac_another_bucket")  then return end
        local shader = self.edition and G.P_CENTERS[self.edition.key].shader or "dissolve"
        self.children.center:set_sprite_pos({x=2,y=1})
        self.children.center:draw_shader(shader, nil, nil)
        if self.ability.saved_card then
            self.ability.saved_card.card.T = copy_table(self.T)
            self.ability.saved_card.card.VT = copy_table(self.VT)
            self.ability.saved_card.card.children.center:draw_shader('dissolve', nil, nil)  
            for _, k in ipairs(SMODS.DrawStep.obj_buffer) do
                if SMODS.DrawSteps[k]:check_conditions(self.ability.saved_card.card, 'both') then SMODS.DrawSteps[k].func(self.ability.saved_card.card, layer) end
            end
        end
        self.children.center:set_sprite_pos({x=1,y=1})
        self.children.center:draw_shader(shader, nil, nil)
	end,
	conditions = { vortex = false, facing = "front" },
})

local card_load_ref = Card.load
function Card:load(tbl)
    local ret = card_load_ref(self, tbl)
    self.fish_seal = tbl.fish_seal
    if self.ability.saved_card then
        self.ability.saved_card.card = SMODS.create_card{set = "Joker"}
        self.ability.saved_card.card:load(self.ability.saved_card.save_table)
        self.ability.saved_card.card.states.collide.can = false
        self.ability.saved_card.card.states.hover.can = false
        self.ability.saved_card.card.states.click.can = false
        self.ability.saved_card.card.states.drag.can = false
        self.ability.saved_card.card.states.focus.can = false
        self.ability.saved_card.card.states.visible = false
    end
    return ret
end

local card_save_ref = Card.save
function Card:save()
    local c = self.ability.saved_card and self.ability.saved_card.card
    if c then
        self.ability.saved_card.card = nil
    end
    local ret = card_save_ref(self)
    ret.fish_seal = self.fish_seal
    if c then
        self.ability.saved_card.card = c
    end
    return ret
end

SMODS.Sound {
    key = "crimsonseraphim_revolver_spin",
    path = "crimsonseraphim/revolver_spin.ogg"
}

SMODS.Sound {
    key = "crimsonseraphim_revolver_empty",
    path = "crimsonseraphim/revolver_empty.ogg"
}

for i = 1, 8 do
    SMODS.Sound {
    key = "crimsonseraphim_revolver_shots_"..i,
    path = "crimsonseraphim/revolver_shots_"..i..".ogg"
}
end

FishAndChips.Fish {
	key = "rusty_revolver",
	atlas = "crimsonseraphim_aeonfish",
	pos = { x = 4, y = 0 },
	weight = 3, 
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
    end
}

function FishAndChips.crimsonseraphim.draw_reticle(x, y, size)
    love.graphics.setColor({G.C.RED[1], G.C.RED[2], G.C.RED[3], G.GAME.REVOLVER_RETICLE_ALPHA or 1})
    local w = love.graphics.getLineWidth()
    love.graphics.setLineWidth(2)
    x = x - 2.5
    y = y + 1.5
    love.graphics.ellipse("line", x, y, size, size)
    love.graphics.ellipse("fill", x - size, y, size * 0.5, size * 0.2)
    love.graphics.ellipse("fill", x + size, y, size * 0.5, size * 0.2)

    love.graphics.ellipse("fill", x, y - size, size * 0.2, size * 0.5)
    love.graphics.ellipse("fill", x, y + size, size * 0.2, size * 0.5)
    love.graphics.setLineWidth(w)
    if (G.GAME.REVOLVER_RETICLE_ALPHA or 1) <= 0 then G.GAME.REVOLVER_RETICLE_ALPHA = nil end
end

local go_fish = G.FUNCS.fac_go_fish
function G.FUNCS.fac_go_fish(e)
    go_fish(e)
    if next(SMODS.find_card("fish_fac_rusty_revolver")) then
        G.E_MANAGER:add_event(Event{
            trigger = "after",
            blocking = false,
            func = function()
                if G.FISHING_STATE == G.FISHING_STATES.HOOKING then
                    local p
                    for i, v in pairs(SMODS.find_card("fish_fac_rusty_revolver")) do
                        if v.ability.extra.primed then
                            p = true
                            for i = 1, v.ability.extra.primed do
                                G.E_MANAGER:add_event(Event{
                                    trigger = "after",
                                    delay = 0.075*G.SETTINGS.GAMESPEED,
                                    func = function()
                                        play_sound("fac_crimsonseraphim_revolver_shots_"..math.random(1, 8))
                                        return true
                                    end
                                })
                            end
                            v.ability.extra.primed = nil
                        end
                    end
                    if p then 
                        G.GAME.REVOLVER_RETICLE_ALPHA = 1
                        G.E_MANAGER:add_event(Event({
                            trigger = 'ease',
                            blockable = false,
                            blocking = false,
                            ref_table = G.GAME,
                            ref_value = 'REVOLVER_RETICLE_ALPHA',
                            ease_to = 0,
                            delay = 2*G.SETTINGS.GAMESPEED,
                            func = (function(t) return t end)
                        }))
                    end
                    return true
                end
            end
        }) 
    end
end

function FishAndChips.crimsonseraphim.get_dummy(center, area, self)
    local abil = copy_table(center.config) or {}
    abil.consumeable = copy_table(abil)
    abil.name = center.name or center.key
    abil.set = "Joker"
    abil.t_mult = abil.t_mult or 0
    abil.t_chips = abil.t_chips or 0
    abil.x_mult = abil.x_mult or abil.Xmult or 1
    abil.extra_value = abil.extra_value or 0
    abil.d_size = abil.d_size or 0
    abil.mult = abil.mult or 0
    abil.effect = center.effect
    abil.h_size = abil.h_size or 0
    local eligible_editionless_jokers = {}
    for i, v in pairs(G.jokers and G.jokers.cards or {}) do
        if not v.edition then
            eligible_editionless_jokers[#eligible_editionless_jokers+1] = v
        end
    end
    local tbl = {
        ability = abil,
        config = {
            center = center,
            center_key = center.key
        },
        juice_up = function(_, ...)
            return self:juice_up(...)
        end,
        start_dissolve = function(_, ...)
            return self:start_dissolve(...)
        end,
        remove = function(_, ...)
            return self:remove(...)
        end,
        flip = function(_, ...)
            return self:flip(...)
        end,
        use_consumeable = function(self, ...)
            self.bypass_echo = true
            local ret = Card.use_consumeable(self, ...)
            self.bypass_echo = nil
        end,
        can_use_consumeable = function(self, ...)
            return Card.can_use_consumeable(self, ...)
        end,
        calculate_joker = function(self, ...)
            return Card.calculate_joker(self, ...)
        end,
        can_calculate = function(self, ...)
            return Card.can_calculate(self, ...)
        end,
        original_card = self,
        area = area,
        added_to_deck = added_to_deck,
        cost = self.cost,
        sell_cost = self.sell_cost,
        eligible_strength_jokers = eligible_editionless_jokers,
        eligible_editionless_jokers = eligible_editionless_jokers,
        T = self.t,
        VT = self.VT
    }
    for i, v in pairs(self) do
        if type(v) == "function" and i ~= "flip_side" then
            tbl[i] = function(_, ...)
                return v(self, ...)
            end
        end
    end
    return tbl
end

FishAndChips.Fish {
	key = "larp",
	atlas = "crimsonseraphim_aeonfish",
	pos = { x = 0, y = 0 },
	weight = 3, 
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
	key = "larp",
	atlas = "crimsonseraphim_aeonfish",
	pos = { x = 0, y = 0 },
	weight = 3, 
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
	key = "still_life",
	atlas = "crimsonseraphim_aeonfish",
	pos = { x = 0, y = 0 },
	weight = 3, 
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
	key = "starblight_eel",
	atlas = "crimsonseraphim_aeonfish",
	pos = { x = 1, y = 1 },
	weight = 3, 
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
                    local c = copy_card(pseudorandom_element(cards, pseudoseed("starblight_eel")), nil)
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

local calculate_joker_ref = Card.calculate_joker
function Card:calculate_joker(context)
    local effects = calculate_joker_ref(self, context)
    local ret = FishAndChips.crimsonseraphim.calculate_forged_joker(self, context)
    if ret then
        effects = SMODS.merge_effects({effects or {}, ret})
    end
    
    local ret = FishAndChips.crimsonseraphim.calculate_fish_seal(self, context)
    if ret then
        effects = SMODS.merge_effects({effects or {}, ret})
    end

    if context.joker_main then
        if self.ability.crimsonseraphim_starblighted then
            effects = SMODS.merge_effects({effects or {}, {
                mult = -self.ability.crimsonseraphim_starblighted_mult
            }})
            self.ability.crimsonseraphim_starblighted_mult = self.ability.crimsonseraphim_starblighted_mult + 0.5 
        end
    end
    if context.starting_shop and self.ability.crimsonseraphim_temporary then
        SMODS.destroy_cards(self, true, true)
    end
    return effects
end

local generate_ui_ref = SMODS.Center.generate_ui
function SMODS.Center.generate_ui(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
    if card and card.ability.crimsonseraphim_starblighted then
        info_queue[#info_queue+1] = {set = "Other", key = "crimsonseraphim_starblighted", vars = {card.ability.crimsonseraphim_starblighted_mult, 0.5}}
    end
    if card and card.ability.crimsonseraphim_temporary then
        info_queue[#info_queue+1] = {set = "Other", key = "crimsonseraphim_temporary"}
    end
    return generate_ui_ref(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
end

SMODS.Shader({
    key="crimsonseraphim_starblighted",
    path="crimsonseraphim/starblighted.fs",
})

SMODS.Atlas({
	key = "crimsonseraphim_ultimate_weapon",
	path = "crimsonseraphim/ultimate_weapon.png",
	px = 102,
	py = 70,
    atlas_table = "ANIMATION_ATLAS",
    fps = 10,
    frames = 8
})

FishAndChips.Fish {
	key = "ultimate_weapon",
	atlas = "crimsonseraphim_ultimate_weapon",
	pos = { x = 0, y = 0 },
	weight = 3, 
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
    treasure = true
}

SMODS.Shader({
    key="ultimate_weapon",
    path="crimsonseraphim/ultimate_weapon.fs",
})

SMODS.DrawStep({
	key = "ultimate_weapon",
	order = 25,
	func = function(self)
        local card = self.config.center_key
        if (card ~= "fish_fac_ultimate_weapon")  then return end
        self.children.center:draw_shader('fac_ultimate_weapon', nil, self.ARGS.send_to_shader)
	end,
	conditions = { vortex = false, facing = "front" },
})

local card_add_to_deck = Card.add_to_deck
function Card:add_to_deck(...)
    card_add_to_deck(self, ...)
    if self.ability.set == "fac_Fish" and self.config.center_key ~= "fish_fac_ultimate_weapon" then
        G.GAME.crimsonseraphim_obtained_fish = G.GAME.crimsonseraphim_obtained_fish or {}
        G.GAME.crimsonseraphim_obtained_fish[#G.GAME.crimsonseraphim_obtained_fish+1] = {card = self, savetable = self:save()}
    end
end

local card_remove = Card.remove
function Card:remove(...)
    if self.ability.set == "fac_Fish" and G.GAME.crimsonseraphim_obtained_fish then
        for i, v in pairs(G.GAME.crimsonseraphim_obtained_fish) do
            if v.card == self then
                v.savetext = self:save()
                v.card = nil
            end
        end
    end
    return card_remove(self, ...)
end

local card_start_dissolve = Card.start_dissolve
function Card:start_dissolve(...)
    if self.ability.set == "fac_Fish" and G.GAME.crimsonseraphim_obtained_fish then
        for i, v in pairs(G.GAME.crimsonseraphim_obtained_fish) do
            if v.card == self then
                v.savetext = self:save()
                v.card = nil
            end
        end
    end
    return card_start_dissolve(self, ...)
end

local save_run_ref = save_run
function save_run(...)
    for i, v in pairs(G.GAME.crimsonseraphim_obtained_fish or {}) do
        if type(v.card) == "number" then
            v.card = nil
        end
        if v.card then
            v.savetable = v.card:save()
            v.card = v.card.sort_id
        end
    end
    return save_run_ref(...)
end

local game_new_run = Game.new_run
function Game:new_run(args, ...)
    game_new_run(args, ...)
    if args.savetext and G.GAME.crimsonseraphim_obtained_fish then
        for i, v in pairs(G.GAME.crimsonseraphim_obtained_fish) do
            if v.card then
                for i, c in pairs(G.I.CARD) do
                    if c.sort_id == v.card and c.ability.set == "fac_Fish" then
                        v.card = c
                    end
                end
            end
        end
    end
end

FishAndChips.Fish {
	key = "jack_o_lantern",
	atlas = "crimsonseraphim_aeonfish",
	pos = { x = 0, y = 0 },
	weight = 3, 
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
    end
}

SMODS.ScreenShader {
    key = "flashlight",
    path = "crimsonseraphim/flashlight.fs",
    send_vars = function(self)
        return {
            center_pos = { love.mouse.getX(), love.mouse.getY() },
            dist = 350,
        }
    end,
    should_apply = function(self)
        return next(SMODS.find_card("fish_fac_jack_o_lantern"))
    end,
}

FishAndChips.Fish {
	key = "piranha_cruenta",
	atlas = "crimsonseraphim_aeonfish",
	pos = { x = 0, y = 0 },
	weight = 3, 
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
	key = "delphinus_dormiens",
	atlas = "crimsonseraphim_aeonfish",
	pos = { x = 0, y = 0 },
	weight = 3, 
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

--based on Platinum Arowana
FishAndChips.Fish {
	key = "anima",
	atlas = "crimsonseraphim_aeonfish",
	pos = { x = 0, y = 0 },
	weight = 3, 
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

SMODS.Sound {
    key = "crimsonseraphim_sulfur_slash",
    path = "crimsonseraphim/falx_sulphurata_slash.ogg"
}

FishAndChips.Fish {
	key = "falx_sulphurata",
	atlas = "crimsonseraphim_aeonfish",
	pos = { x = 0, y = 0 },
	weight = 3, 
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
            local c = pseudorandom_element(G.hand.highlighted, pseudoseed("falx_sulphurata_card"))
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
	key = "squalus_aeternus",
	atlas = "crimsonseraphim_aeonfish",
	pos = { x = 0, y = 0 },
	weight = 3, 
	ppu_coder = { "crimsonseraphim" },
	ppu_artist = { "crimsonseraphim" },
	attributes = { "passive" },
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
        local c = pseudorandom_element(h, pseudoseed("squalus_aeternus"))
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
        if #SMODS.find_card("fish_fac_squalus_aeternus") <= 0 then
            G.fac_fish_area.config.highlighted_limit = 1
        end
    end,
    loc_vars = function(_, info_queue) 
        info_queue[#info_queue+1] = {set = "Other", key = "eternal"}
    end
}

FishAndChips.Fish {
	key = "vanitas",
	atlas = "crimsonseraphim_aeonfish",
	pos = { x = 2, y = 1 },
	weight = 3, 
	ppu_coder = { "crimsonseraphim" },
	ppu_artist = { "crimsonseraphim" },
	attributes = { "passive" },
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

SMODS.Atlas({
	key = "crimsonseraphim_temporary",
	path = "crimsonseraphim/temporary.png",
	px = 71,
	py = 95,
})

SMODS.draw_ignore_keys.vanitas_censor = true
SMODS.DrawStep({
	key = "vanitas",
	order = 9e10,
	func = function(self)
        local card = self.config.center_key
        if (card ~= "fish_fac_vanitas") or not G.P_CENTERS[card].discovered or not G.P_CENTERS[card].unlocked then return end


        if not self.children.vanitas_censor then 
            self.children.vanitas_censor = SMODS.create_sprite(0, 0, self.T.w, self.T.h, "fac_crimsonseraphim_aeonfish", {x = 3, y = 1})
        end
        local sprite = self.children.vanitas_censor
        sprite.T.w = self.T.w
        sprite.T.h = self.T.h
        sprite.VT.x = math.floor(self.children.center.VT.x*3.5)/3.5
        sprite.VT.y = math.floor(self.children.center.VT.y*3.5)/3.5
        sprite.VT.r = 0
        sprite:draw_shader("dissolve", nil, nil, true, nil, nil, 0)
	end,
	conditions = { vortex = false, facing = "front" },
})

for i, v in pairs(FishAndChips.crimsonseraphim.C) do
    G.ARGS.LOC_COLOURS[i] = v
end