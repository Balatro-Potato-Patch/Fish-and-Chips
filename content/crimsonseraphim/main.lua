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
        }
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
    calculate = function(self, context)
        local effects = {}
        for _, c in pairs(G.jokers.cards) do
            if not c.debuffed then
                local ret = FishAndChips.crimsonseraphim.calculate_forged_joker(c, context)
                if ret then
                    ret.card = c
                    ret.message_card = c
                    ret.juice_card = c
                    effects = SMODS.merge_effects({effects, ret})
                    effects[1] = true
                end
            end
        end
        for _, c in pairs(G.fac_fish_area.cards) do
            local ret = FishAndChips.crimsonseraphim.calculate_fish_seal(c, context)
            if ret then
                ret.card = c
                ret.message_card = ret.fish_message_card or c
                ret.juice_card = c
                effects = SMODS.merge_effects({effects, ret})
                effects[1] = true
            end
        end
        if #effects ~= 0 then
            return effects
        end
    end
})

FishAndChips.Fish {
	key = "aeonfish",
	atlas = "crimsonseraphim_aeonfish",
	pos = { x = 0, y = 0 },
	weight = 20,
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

SMODS.draw_ignore_keys.aeonfish_caustics = true
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
        sprite:draw_shader('fac_aeonfish_transmute', nil, self.ARGS.send_to_shader, nil, self.children.center)
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
	pos = { x = 0, y = 0 },
	weight = 5,
	ppu_coder = { "crimsonseraphim" },
	ppu_artist = { "crimsonseraphim" },
	attributes = { "economy" },
	environments = {
		calm_pond = 4,
		soup = 10,
        chocolate_river = 7,
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
	weight = 7,
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
	weight = 8,
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
	weight = 10, 
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
	weight = 5, 
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
	weight = 5, 
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
	loc_vars = function(self, info_queue, card)
    return {
        vars = {
            card.ability.extra.mult,
            card.ability.extra.chips
        }
    }
	end,
	calculate = function(self, card, context)
        
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
	weight = 5, 
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
	weight = 5, 
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
                    SMODS.calculate_effect({mult = card.ability.extra.mult}, card)
                else
                    SMODS.calculate_effect({chips = card.ability.extra.chips}, card)
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
	weight = 5, 
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
        self.children.center:set_sprite_pos({x=2,y=1})
        self.children.center:draw_shader('dissolve', nil, nil)
        if self.ability.saved_card then
            self.ability.saved_card.card.T = copy_table(self.T)
            self.ability.saved_card.card.VT = copy_table(self.VT)
            self.ability.saved_card.card.children.center:draw_shader('dissolve', nil, nil)  
            for _, k in ipairs(SMODS.DrawStep.obj_buffer) do
                if SMODS.DrawSteps[k]:check_conditions(self.ability.saved_card.card, 'both') then SMODS.DrawSteps[k].func(self.ability.saved_card.card, layer) end
            end
        end
        self.children.center:set_sprite_pos({x=1,y=1})
        self.children.center:draw_shader('dissolve', nil, nil)
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
	weight = 5, 
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
    if G.GAME.REVOLVER_RETICLE_ALPHA <= 0 then G.GAME.REVOLVER_RETICLE_ALPHA = nil end
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
                    for i, v in pairs(SMODS.find_card("fish_fac_rusty_revolver")) do
                        if v.ability.extra.primed then
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
                    return true
                end
            end
        }) 
        G.GAME.REVOLVER_RETICLE_ALPHA = 1
    end
end