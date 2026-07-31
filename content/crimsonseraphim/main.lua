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

function Card:transmute(seed, center)
    local result = center
    if not center then
        local attributes = self.config.center.attributes or {}
        local valid = {}
        for attribute, _ in pairs(attributes) do
            for i, v in pairs(G.P_CENTERS) do
                if v.set == self.config.center.set then
                    for a, _ in pairs(v.attributes or {}) do
                        if a == attribute and not FishAndChips.Environments[a] then valid[#valid+1] = v end
                    end
                end
            end
        end
        result = pseudorandom_element(valid, pseudoseed(seed))
    end
    --DO ANIM LATER
    G.E_MANAGER:add_event(Event{func = function() 
        self:flip()
        return true
    end, trigger = "after", delay = 0.75})

    G.E_MANAGER:add_event(Event{func = function() 
        self:set_ability(result)
        return true
    end, trigger = "after", delay = 0.75})

    G.E_MANAGER:add_event(Event{func = function() 
        self:flip()
        return true
    end, trigger = "after", delay = 0.75})
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
        if (card ~= "fish_fac_aeonfish")  then return end
        self.children.center:draw_shader('fac_aeonfish_caustics', nil, self.ARGS.send_to_shader)
	end,
	conditions = { vortex = false, facing = "front" },
})

SMODS.Atlas({
	key = "mealy_lore",
	path = "crimsonseraphim/mealy_lore.png",
	px = 1125,
	py = 1086,
})


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
	pos = { x = 0, y = 0 },
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
		styx = 7
	},
	loc_vars = function(self, info_queue, card)
		local num, dem = SMODS.get_probability_vars(card, 1, card.ability.extra.odds_seal, "fac_crimsonseraphim_jade_crystalfish_seal")
		return { vars = { num, dem } }
	end,
	calculate = function(self, card, context)
		if context.end_of_round and context.main_eval and SMODS.pseudorandom_probability(
            card, "fac_crimsonseraphim_jade_crystalfish", 1, card.ability.extra.odds
        ) then
            card:transmute(G.P_CENTERS.fish_fac_ruby_crystalfish)
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
	pos = { x = 0, y = 0 },
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
		styx = 8
	},
	loc_vars = function(self, info_queue, card)
		
	end,
	calculate = function(self, card, context)
		if context.end_of_round and context.main_eval and SMODS.pseudorandom_probability(
            card, "fac_crimsonseraphim_ruby_crystalfish", 1, card.ability.extra.odds
        ) then
            card:transmute(G.P_CENTERS.fish_fac_jade_crystalfish)
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
		aquifer = 10
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