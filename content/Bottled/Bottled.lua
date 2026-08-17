SMODS.Atlas({ key = "Bottled_dev", path = "Bottled/dev.png", px = 71, py = 95 })
SMODS.Atlas({ key = "Bottled_bottles", path = "Bottled/bottles.png", px = 71, py = 95 })
--SMODS.Sound({ key = "Bottled_bottle_open", path = "Bottled/bottle_open.ogg" })
--SMODS.Sound({ key = "Bottled_bottle_break", path = "Bottled/bottle_break.ogg" })
loc_colour(); G.ARGS.LOC_COLOURS.Bottled = HEX('9090B0')

PotatoPatchUtils.Developer({
	name = "Flowire",
	colour = HEX("FF8FA9"),
	atlas = "fac_Bottled_dev",
	pos = { x = 0, y = 0 },
	loc = true
})

--# ### # ### # ### # ### # ### # ### # ### # ### # ### #
--# Main Functions										#
--# ### # ### # ### # ### # ### # ### # ### # ### # ### #
local MB_modes = { "select", "select", "ranked", "random" }
local MB_modify = { 1, 1, 2, 2, 2, 2, 2, 3, 3, 4 }--, 4, 5 }  -->  min/max in "MB_loc_vars"
local MB_moroom = { 1, 1, 1, 1, 2 }

local function MB_stats(special)
	return {
		weight = special or { min = 0.17, max = 0.28 },
		length = { min = 0.16, max = 0.33 }
	}
end
local function MB_attributes(attribute)
	return { "usable", "modify_card", "perma_bonus", attribute }
end

local function MB_get_texture(card)
	if card then
		if card.ability and card.ability.extra then
			if not card.fac_Fish_Bottled_pos then
				if card.ability.extra.t_wrong then
					card.fac_Fish_Bottled_pos = { x = 6, y = 0 }
				else
					local xpos = card.ability.extra.t_green and 3 or 0
					if card.ability.extra.mode == "ranked" then
						xpos = xpos + 1
					elseif card.ability.extra.mode == "random" then
						xpos = xpos + 2
					end
					card.fac_Fish_Bottled_pos = { x = xpos, y = 0 }
				end
			end
			return card.fac_Fish_Bottled_pos
		else
			return card.config.center.pos
		end
	else
		return { x = 0, y = 0 }
	end
end
local function MB_set_texture(card)
	card.children.center:set_sprite_pos(MB_get_texture(card))
end

local function MB_get_mode(seed)
	return pseudorandom_element(MB_modes, seed)
end
local function MB_get_modify(rank, seed)
	if rank then
		local ret_val = { rank = "King", id = 13 }
		if G.playing_cards then
			local valid_cards = {}
			for _, playing_card in ipairs(G.playing_cards) do
				if not SMODS.has_no_rank(playing_card) then
					valid_cards[#valid_cards + 1] = playing_card
				end
			end
			local check_rank = pseudorandom_element(valid_cards, seed)
			if check_rank then
				ret_val.rank = check_rank.base.value
				ret_val.id = check_rank.base.id
			end
		end
		return ret_val
	else
		return pseudorandom_element(MB_modify, seed)
	end
end
local function MB_get_amount(bottle)
	if bottle.max then
		local ret_val = pseudorandom(bottle.main, bottle.min, bottle.max)
		if bottle.div then ret_val = ret_val/bottle.div end
		return ret_val
	else
		return bottle.min
	end
end
local function MB_setup(card, debuff)
	if card and not debuff then
		if not card.ability.extra.setup then
			card.ability.extra.setup = true
			local seed = card.ability.extra.bottle.main
			local env = FishAndChips.get_environment()
			if env and env.key == "backroom" then
				card.ability.extra.mode = "random"
				card.ability.extra.modify = pseudorandom_element(MB_moroom, seed)
				local val_1 = MB_get_amount(card.ability.extra.bottle)
				local val_2 = MB_get_amount(card.ability.extra.bottle)
				card.ability.extra.amount = math.min(val_1, val_2)
				card.ability.extra.t_wrong = true
			else-- Default:
				local mode = MB_get_mode(seed)
				card.ability.extra.mode = mode
				card.ability.extra.modify = MB_get_modify(mode == "ranked", seed)
				card.ability.extra.amount = MB_get_amount(card.ability.extra.bottle)
				card.ability.extra.t_green = math.random() > 0.67
			end
		end
		G.E_MANAGER:add_event(Event({
			func = function()
				MB_set_texture(card)
				return true
			end
		}))
	end
end

local function MB_loc_key(card)
	if not card.fac_Fish_Bottled_loc_key then
		local new_key = card.config.center_key.."_"..card.ability.extra.mode
		if card.ability.extra.mode ~= "ranked" and card.ability.extra.modify == 1 then
			new_key = new_key.."_solo"
		end
		card.fac_Fish_Bottled_loc_key = new_key
	end
	return card.fac_Fish_Bottled_loc_key
end
local function MB_loc_vars(card)
	if not card.ability.extra.setup then MB_setup(card) end
	if card.area and (card.area.config.collection or card.area.config.fac_compendium) then
		local bottle, min, max = card.ability.extra.bottle, nil, nil
		if bottle.max then
			if bottle.div then min = tostring(bottle.min/bottle.div); max = tostring(bottle.max/bottle.div)
			else min = tostring(bottle.min); max = tostring(bottle.max) end
		else min = tostring(bottle.min) end
		return { vars = { "1", "4", min, max or "" } }
	else
		local modify
		if card.ability.extra.mode == "ranked" then
			modify = localize(card.ability.extra.modify.rank, "ranks")
			-- Wiggles all affected Cards:
			if G.hand and #G.hand.cards > 0 then
				local mod_id = card.ability.extra.modify.id
				for _, playing_card in ipairs(G.hand.cards) do
					if playing_card:get_id() == mod_id then
						playing_card:juice_up(0.1, 0.2)
					end
				end
			end
		else
			modify = card.ability.extra.modify
		end
		return { key = MB_loc_key(card), vars = { modify, card.ability.extra.amount } }
	end
end
local function MB_flavour_vars(card)
	if not (card.area and (card.area.config.collection or card.area.config.fac_compendium)) then
		return { key = MB_loc_key(card) }
	end
	return { }
end

local function MB_can_use(card)
	if G.hand then
		if card.ability.extra.mode == "select" then
			return #G.hand.highlighted <= card.ability.extra.modify and #G.hand.highlighted > 0
		else
			return #G.hand.cards > 0
		end
	end
	return false
end
local function MB_use(card)
	local cards = { }
	if G.hand then
		local mode = card.ability.extra.mode
		if mode == "select" then
			for _, playing_card in ipairs(G.hand.highlighted) do
				cards[#cards+1] = playing_card
			end
		elseif mode == "ranked" then
			local modify = card.ability.extra.modify
			for _, playing_card in ipairs(G.hand.cards) do
				if playing_card:get_id() == modify.id then
					cards[#cards+1] = playing_card
				end
			end
		elseif mode == "random" then
			local modify = card.ability.extra.modify
			local temp_cards = { }
			for _, playing_card in ipairs(G.hand.cards) do
				temp_cards[#temp_cards+1] = playing_card
			end
			if #temp_cards > modify then
				pseudoshuffle(temp_cards, card.ability.extra.bottle.main)
			end
			for i = 1, math.min(#temp_cards, modify) do
				cards[#cards+1] = temp_cards[i]
			end
		end
	end
	if #cards > 0 then
		-- Change Cards
		local perma = card.ability.extra.bottle.main
		local amount = card.ability.extra.amount
		for i = 1, #cards do
			cards[i].ability[perma] = (cards[i].ability[perma] or 0) + amount
		end
		-- Animation
		G.E_MANAGER:add_event(Event({
			trigger = "after",
			delay = 0.4,
			func = function()
				play_sound("tarot1")
				card:juice_up(0.3, 0.5)
				return true
			end,
		}))
		for i = 1, #cards do
			local percent = 1.15 - (i - 0.999) / (#cards - 0.998) * 0.3
			G.E_MANAGER:add_event(Event({
				trigger = "after",
				delay = 0.15,
				func = function()
					cards[i]:flip()
					play_sound("card1", percent)
					cards[i]:juice_up(0.3, 0.3)
					return true
				end,
			}))
		end
		delay(0.2)
		for i = 1, #cards do
			local percent = 0.85 + (i - 0.999) / (#cards - 0.998) * 0.3
			G.E_MANAGER:add_event(Event({
				trigger = "after",
				delay = 0.15,
				func = function()
					cards[i]:flip()
					play_sound("tarot2", percent, 0.6)
					cards[i]:juice_up(0.3, 0.3)
					return true
				end,
			}))
		end
		if card.ability.extra.mode == "select" then
			G.E_MANAGER:add_event(Event({
				trigger = "after",
				delay = 0.2,
				func = function()
					G.hand:unhighlight_all()
					return true
				end
			}))
			delay(0.3)
		else
			delay(0.5)
		end
	end
	G.E_MANAGER:add_event(Event({
		trigger = "after",
		func = function()
			card:shatter()
			return true
		end
	}))
end

--# ### # ### # ### # ### # ### # ### # ### # ### # ### #
--# Feesh												#
--# ### # ### # ### # ### # ### # ### # ### # ### # ### #
FishAndChips.Fish {
	weight = 15,
	-- Fish Keys
	key = "Bottled_CHIPS",
	ppu_artist = { "Flowire" },
	ppu_coder = { "Flowire" },
	atlas = "Bottled_bottles",
	pos = { x = 0, y = 0 },
	soul_pos = { x = 0, y = 1 },
	-- Fish Base
	blueprint_compat = false,
	eternal_compat = false,
	requires_hand = true,
	environments = {
		calm_pond = 3, city_river = 3, swamp = 1,
		pier = 2, garden = 0.5, backroom = 0.125,
	},
	-- Fish Stats
	stats = MB_stats(),
	impulse_min = 0.04, impulse_max = 0.4,
	decision_min = 0.28, decision_max = 0.73,
	vel_limit = 0.48,
	-- Fish Config
	attributes = MB_attributes("chips"),
	config = { extra = {
		bottle = { main = "perma_bonus", min = 5, max = 25 },
		modify = 3, amount = 12, mode = "select",
		t_green = false, t_wrong = false
	} },
	cost = 2,
	-- Fish Code
	loc_vars = function(_, _, card) return MB_loc_vars(card) end,
	flavour_vars = function(_, _, card) return MB_flavour_vars(card) end,
	set_sprites = function(_, card, _) return MB_set_texture(card) end,
    add_to_deck = function(_, card, debuff) return MB_setup(card, debuff) end,
	can_use = function(_, card) return MB_can_use(card) end,
	use = function(_, card) return MB_use(card) end
}

FishAndChips.Fish {
	weight = 15,
	-- Fish Keys
	key = "Bottled_MULT",
	ppu_artist = { "Flowire" },
	ppu_coder = { "Flowire" },
	atlas = "Bottled_bottles",
	pos = { x = 0, y = 0 },
	soul_pos = { x = 2, y = 1 },
	-- Fish Base
	blueprint_compat = false,
	eternal_compat = false,
	requires_hand = true,
	environments = {
		calm_pond = 3, city_river = 3, volcano = 1,
		pier = 2, soup = 0.5, backroom = 0.125,
	},
	-- Fish Stats
	stats = MB_stats(),
	impulse_min = 0.04, impulse_max = 0.4,
	decision_min = 0.28, decision_max = 0.73,
	vel_limit = 0.48,
	-- Fish Config
	attributes = MB_attributes("mult"),
	config = { extra = {
		bottle = { main = "perma_mult", min = 1, max = 4 },
		modify = 3, amount = 2, mode = "select",
		t_green = false, t_wrong = false
	} },
	cost = 2,
	-- Fish Code
	loc_vars = function(_, _, card) return MB_loc_vars(card) end,
	flavour_vars = function(_, _, card) return MB_flavour_vars(card) end,
	set_sprites = function(_, card, _) return MB_set_texture(card) end,
    add_to_deck = function(_, card, debuff) return MB_setup(card, debuff) end,
	can_use = function(_, card) return MB_can_use(card) end,
	use = function(_, card) return MB_use(card) end
}

FishAndChips.Fish {
	weight = 12,
	-- Fish Keys
	key = "Bottled_XCHIPS",
	ppu_artist = { "Flowire" },
	ppu_coder = { "Flowire" },
	atlas = "Bottled_bottles",
	pos = { x = 3, y = 0 },
	soul_pos = { x = 1, y = 1 },
	-- Fish Base
	blueprint_compat = false,
	eternal_compat = false,
	requires_hand = true,
	environments = {
		city_river = 0.5, swamp = 1, pier = 3,
		styx = 3, garden = 1, backroom = 0.25,
	},
	-- Fish Stats
	stats = MB_stats(),
	impulse_min = 0.16, impulse_max = 0.26,
	decision_min = 0.17, decision_max = 0.47,
	vel_limit = 0.51,
	-- Fish Config
	attributes = MB_attributes("xchips"),
	config = { extra = {
		bottle = { main = "perma_x_chips", min = 8, max = 15, div = 100 },
		modify = 2, amount = 0.1, mode = "select",
		t_green = true, t_wrong = false
	} },
	cost = 4,
	-- Fish Code
	loc_vars = function(_, _, card) return MB_loc_vars(card) end,
	flavour_vars = function(_, _, card) return MB_flavour_vars(card) end,
	set_sprites = function(_, card, _) return MB_set_texture(card) end,
    add_to_deck = function(_, card, debuff) return MB_setup(card, debuff) end,
	can_use = function(_, card) return MB_can_use(card) end,
	use = function(_, card) return MB_use(card) end
}

FishAndChips.Fish {
	weight = 12,
	-- Fish Keys
	key = "Bottled_XMULT",
	ppu_artist = { "Flowire" },
	ppu_coder = { "Flowire" },
	atlas = "Bottled_bottles",
	pos = { x = 3, y = 0 },
	soul_pos = { x = 3, y = 1 },
	-- Fish Base
	blueprint_compat = false,
	eternal_compat = false,
	requires_hand = true,
	environments = {
		city_river = 0.5, volcano = 1, pier = 3,
		chocolate_river = 3, soup = 1, backroom = 0.25,
	},
	-- Fish Stats
	stats = MB_stats(),
	impulse_min = 0.16, impulse_max = 0.26,
	decision_min = 0.17, decision_max = 0.47,
	vel_limit = 0.51,
	-- Fish Config
	attributes = MB_attributes("xmult"),
	config = { extra = {
		bottle = { main = "perma_x_mult", min = 8, max = 15, div = 100 },
		modify = 2, amount = 0.12, mode = "select",
		t_green = true, t_wrong = false
	} },
	cost = 4,
	-- Fish Code
	loc_vars = function(_, _, card) return MB_loc_vars(card) end,
	flavour_vars = function(_, _, card) return MB_flavour_vars(card) end,
	set_sprites = function(_, card, _) return MB_set_texture(card) end,
    add_to_deck = function(_, card, debuff) return MB_setup(card, debuff) end,
	can_use = function(_, card) return MB_can_use(card) end,
	use = function(_, card) return MB_use(card) end
}

FishAndChips.Fish {
	weight = 8,
	-- Fish Keys
	key = "Bottled_MONEY",
	ppu_artist = { "Flowire" },
	ppu_coder = { "Flowire" },
	atlas = "Bottled_bottles",
	pos = { x = 2, y = 0 },
	soul_pos = { x = 4, y = 1 },
	-- Fish Base
	blueprint_compat = false,
	eternal_compat = false,
	requires_hand = true,
	environments = {
		city_river = 1, aquifer = 2, pier = 1.5,
		styx = 1.5, garden = 0.5, backroom = 0.125,
	},
	-- Fish Stats
	stats = MB_stats(),
	impulse_min = 0.18, impulse_max = 0.22,
	decision_min = 0.32, decision_max = 0.61,
	vel_limit = 0.6,
	-- Fish Config
	attributes = MB_attributes("economy"),
	config = { extra = {
		bottle = { main = "perma_p_dollars", min = 1, max = 2 },
		modify = 2, amount = 1, mode = "random",
		t_green = false, t_wrong = false
	} },
	cost = 4,
	-- Fish Code
	loc_vars = function(_, _, card) return MB_loc_vars(card) end,
	flavour_vars = function(_, _, card) return MB_flavour_vars(card) end,
	set_sprites = function(_, card, _) return MB_set_texture(card) end,
    add_to_deck = function(_, card, debuff) return MB_setup(card, debuff) end,
	can_use = function(_, card) return MB_can_use(card) end,
	use = function(_, card) return MB_use(card) end
}

FishAndChips.Fish {
	weight = 5,
	-- Fish Keys
	key = "Bottled_SAND",
	ppu_artist = { "Flowire" },
	ppu_coder = { "Flowire" },
	atlas = "Bottled_bottles",
	pos = { x = 2, y = 0 },
	soul_pos = { x = 5, y = 1 },
	-- Fish Base
	blueprint_compat = false,
	eternal_compat = false,
	requires_hand = true,
	treasure = true,
	environments = {
		calm_pond = 0.002, pier = 0.25, styx = 0.25,
		garden = 0.75, backroom = 0.5 -- & Treasure
	},
	-- Fish Stats
	stats = MB_stats(),
	impulse_min = 0.12, impulse_max = 0.24,
	decision_min = 0.09, decision_max = 0.18,
	vel_limit = 0.32,
	-- Fish Config
	attributes = MB_attributes("economy"),
	config = { extra = {
		bottle = { main = "perma_p_fac_sand_dollars", min = 1 },
		modify = 1, amount = 1, mode = "random",
		t_green = false, t_wrong = false
	} },
	cost = 8,
	-- Fish Code
	loc_vars = function(_, _, card) return MB_loc_vars(card) end,
	flavour_vars = function(_, _, card) return MB_flavour_vars(card) end,
	set_sprites = function(_, card, _) return MB_set_texture(card) end,
    add_to_deck = function(_, card, debuff) return MB_setup(card, debuff) end,
	can_use = function(_, card) return MB_can_use(card) end,
	use = function(_, card) return MB_use(card) end
}

FishAndChips.Fish {
	weight = 8,
	-- Fish Keys
	key = "Bottled_REPEAT",
	ppu_artist = { "Flowire" },
	ppu_coder = { "Flowire" },
	atlas = "Bottled_bottles",
	pos = { x = 5, y = 0 },
	soul_pos = { x = 6, y = 1 },
	-- Fish Base
	blueprint_compat = false,
	eternal_compat = false,
	requires_hand = true,
	environments = {
		volcano = 0.25, styx = 0.5, soup = 0.5,
		garden = 0.75, wormhole = 5, backroom = 0.75,
	},
	-- Fish Stats
	stats = MB_stats({ min = -0.28, max = -0.17 }),
	impulse_min = 0.06, impulse_max = 0.6,
	decision_min = 0.06, decision_max = 0.18,
	vel_limit = 0.84,
	-- Fish Config
	attributes = MB_attributes("retrigger"),
	config = { extra = {
		bottle = { main = "perma_repetitions", min = 1 },
		modify = 1, amount = 1, mode = "random",
		t_green = true, t_wrong = false
	} },
	cost = 6,
	-- Fish Code
	loc_vars = function(_, _, card) return MB_loc_vars(card) end,
	flavour_vars = function(_, _, card) return MB_flavour_vars(card) end,
	set_sprites = function(_, card, _) return MB_set_texture(card) end,
    add_to_deck = function(_, card, debuff) return MB_setup(card, debuff) end,
	can_use = function(_, card) return MB_can_use(card) end,
	use = function(_, card) return MB_use(card) end
}
