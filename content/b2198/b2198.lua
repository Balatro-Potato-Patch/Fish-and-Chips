PotatoPatchUtils.Developer({
	name = 'b2198',
	colour = HEX("00FF00")
})

SMODS.Atlas({
	key = "b2198_fish", -- Please include your name/team name in your atlas keys
	path = "b2198/fish.png",
	px = 71,
	py = 95,
})

-- adapted from Pokermon's evolution code
local function change_dimensionality(
    card,
    target_dimensions,
    on_transforming
)
    if not card or target_dimensions < 0 or target_dimensions > 4 then return end

    print("Starting transformation checks")
    -- local trigger_add = nil
    local old_fish_ability = {}
    if card.ability and type(card.ability) == "table" then
        for key, value in pairs(card.ability) do
            old_fish_ability[key] = value
        end
    end

    local new_fish = G.P_CENTERS["fish_fac_" .. target_dimensions .. "dgreenfish"]
    card:set_ability(new_fish)
    -- if card.ability.perishable then
    --     if card.ability.perish_tally == 0 then trigger_add = true end
    --     card.ability.perish_tally = G.GAME.perishable_rounds
    --     card.debuff = false
    --     print("un-perishable-d?")
    -- end

    card.children.center = Sprite(card.T.x, card.T.y, card.T.w, card.T.h, SMODS.get_atlas(new_fish.atlas or "Joker"), new_fish.pos)
    card.children.center:set_role({major = card, role_type = 'Glued', draw_major = card})
    card:set_ability(new_fish, true)
    card:set_cost()
    print("card transformed?")

    play_sound('generic1')

    -- if trigger_add then
    --     card:add_to_deck()
    -- end

    if on_transforming and type(on_transforming) == "function" then
        on_transforming(card, old_fish_ability)
    end
end

--#region Fish

FishAndChips.Fish {
	key = "0dgreenfish",
	atlas = "b2198_fish",
	pos = { x = 0, y = 0 },
	weight = 43,
	ppu_coder = { "b2198" },
	ppu_artist = { "b2198" },
	attributes = { "chips", "boss_blind" },
	config = {
		extra = {
			chips = 1,
            counter = 0
		},
        immutable = {
            target_counter = 1
        }
	},
	environments = {
		calm_pond = 0.8,
        wormhole = 1
	},
	stats = {
		weight = {min = 0, max = 0},
		length = {min = 0, max = 0}
	},
    impulse_min = 0.01,
    impulse_max = 0.01,
    decision_min = 5,
    decision_max = 5,
    vel_limit = 0.01,
	loc_vars = function(self, info_queue, card)
		return { vars = { 
            card.ability.extra.chips,
            card.ability.extra.counter,
            card.ability.immutable.target_counter
        } }
	end,
	calculate = function(self, card, context)
        if (
            context.end_of_round and
            context.game_over == false and
            context.main_eval and
            context.beat_boss and
            not context.blueprint
        ) then
            card.ability.extra.counter = card.ability.extra.counter + 1
            if card.ability.extra.counter >= card.ability.immutable.target_counter then
                change_dimensionality(card, 1)
            end
        end
		if context.joker_main then return { chips = card.ability.extra.chips } end
	end,
}

FishAndChips.Fish {
	key = "1dgreenfish",
	atlas = "b2198_fish",
	pos = { x = 1, y = 0 },
	weight = 20,
	ppu_coder = { "b2198" },
	ppu_artist = { "b2198" },
	attributes = { "mult", "boss_blind" },
	config = {
		extra = {
			mult = 10,
            counter = 0
		},
        immutable = {
            target_counter = 2
        }
	},
	environments = {
		swamp = 0.6,
        wormhole = 1
	},
	stats = {
		weight = {min = 0, max = 0},
		length = {min = 1, max = 10}
	},
    impulse_min = 0.1,
    impulse_max = 0.1,
    decision_min = 1,
    decision_max = 1,
    vel_limit = 0.1,
	loc_vars = function(self, info_queue, card)
		return { vars = { 
            card.ability.extra.mult,
            card.ability.extra.counter,
            card.ability.immutable.target_counter
        } }
	end,
	calculate = function(self, card, context)
        if (
            context.end_of_round and
            context.game_over == false and
            context.main_eval and
            context.beat_boss and
            not context.blueprint
        ) then
            card.ability.extra.counter = card.ability.extra.counter + 1
            if card.ability.extra.counter >= card.ability.immutable.target_counter then
                change_dimensionality(card, 2)
            end
        end
		if context.joker_main then return { mult = card.ability.extra.mult } end
	end,
}

FishAndChips.Fish {
	key = "2dgreenfish",
	atlas = "b2198_fish",
	pos = { x = 2, y = 0 },
	weight = 8,
	ppu_coder = { "b2198" },
	ppu_artist = { "b2198" },
	attributes = { "xmult", "boss_blind" },
	config = {
		extra = {
			xmult = 2.5,
            counter = 0
		},
        immutable = {
            target_counter = 3
        }
	},
	environments = {
		garden = 0.4,
        wormhole = 1
	},
	stats = {
		weight = {min = 0, max = 0},
		length = {min = 1, max = 10}
	},
    impulse_min = 0.2,
    impulse_max = 0.5,
    decision_min = 0.5,
    decision_max = 2,
    vel_limit = 0.5,
	loc_vars = function(self, info_queue, card)
		return { vars = {
            card.ability.extra.xmult,
            card.ability.extra.counter,
            card.ability.immutable.target_counter
        } }
	end,
	calculate = function(self, card, context)
        if (
            context.end_of_round and
            context.game_over == false and
            context.main_eval and
            context.beat_boss and
            not context.blueprint
        ) then
            card.ability.extra.counter = card.ability.extra.counter + 1
            if card.ability.extra.counter >= card.ability.immutable.target_counter then
                change_dimensionality(card, 3, function(card, old_fish_ability)
                    print("Transforming...")
                    print("Old ability:")
                    print(old_fish_ability)
                    print("New ability")
                    print(card.ability)
                    print("Xmult to be transferred:")
                    print(old_fish_ability.extra.xmult)
                    print("Current Xmult of new fish:")
                    print(card.ability.extra.xmult)
                    card.ability.extra.xmult = old_fish_ability.extra.xmult
                    print("New Xmult of new fish:")
                    print(card.ability.extra.xmult)
                end)
            end
        end
		if context.joker_main then return { xmult = card.ability.extra.xmult } end
	end,
}

FishAndChips.Fish {
	key = "3dgreenfish",
	atlas = "b2198_fish",
	pos = { x = 3, y = 0 },
	weight = 3,
	ppu_coder = { "b2198" },
	ppu_artist = { "b2198" },
	attributes = { "xmult", "scaling", "boss_blind" },
	config = {
		extra = {
			xmult = 2.5,
            scalar = 0.1,
            counter = 0
		},
        immutable = {
            target_counter = 4
        }
	},
	environments = {
		backroom = 0.2,
        wormhole = 1
	},
	stats = {
		weight = {min = 1, max = 100},
		length = {min = 1, max = 10}
	},
    impulse_min = 0.2,
    impulse_max = 0.8,
    decision_min = 0.4,
    decision_max = 1.2,
    vel_limit = 0.8,
    treasure = true,
	loc_vars = function(self, info_queue, card)
		return { vars = {
            card.ability.extra.xmult,
            card.ability.extra.scalar,
            card.ability.extra.counter,
            card.ability.immutable.target_counter
        } }
	end,
	calculate = function(self, card, context)
        if (
            context.end_of_round and
            context.game_over == false and
            context.main_eval and
            context.beat_boss and
            not context.blueprint
        ) then
            -- change to actually account for amount of fishes owned
            SMODS.scale_card(card, {
                ref_table = card.ability.extra,
                ref_value = "xmult",
                scalar_value = "scalar"
            })
            card.ability.extra.counter = card.ability.extra.counter + 1
            if card.ability.extra.counter >= card.ability.immutable.target_counter then
                change_dimensionality(card, 4, function(card, old_fish_ability)
                    print("Transforming...")
                    print("Old ability:")
                    print(old_fish_ability)
                    print("New ability")
                    print(card.ability)
                    print("Xmult to be transferred:")
                    print(old_fish_ability.extra.xmult)
                    print("Current Xmult of new fish:")
                    print(card.ability.extra.xmult)
                    card.ability.extra.xmult = old_fish_ability.extra.xmult
                    print("New Xmult of new fish:")
                    print(card.ability.extra.xmult)
                end)
            end
        end
		if context.joker_main then return { xmult = card.ability.extra.xmult } end
	end
}

FishAndChips.Fish {
	key = "4dgreenfish",
	atlas = "b2198_fish",
	pos = { x = 4, y = 0 },
	weight = 1,
	ppu_coder = { "b2198" },
	ppu_artist = { "b2198" },
	attributes = { "xmult", "scaling", "boss_blind" },
	config = {
		extra = {
			xmult = 1,
            scalar = 0.2
		},
        immutable = {
            spec_scalar = 1.5
        }
	},
	environments = {
		wormhole = 1
	},
	stats = {
		weight = {min = 10^308, max = 10^308},
		length = {min = 1, max = 10}
	},
    impulse_min = 0.2,
    impulse_max = 1,
    decision_min = 0.2,
    decision_max = 1,
    vel_limit = 1,
	loc_vars = function(self, info_queue, card)
		return { vars = {
            card.ability.extra.xmult,
            card.ability.extra.scalar,
            card.ability.immutable.spec_scalar,
            colours = {
                HEX("00BB00")
            }
        } }
	end,
	calculate = function(self, card, context)
        if (
            context.end_of_round and
            context.game_over == false and
            context.main_eval and
            context.beat_boss and
            not context.blueprint
        ) then
            -- change to actually account for amount of fishes owned
            SMODS.scale_card(card, {
                ref_table = card.ability.extra,
                ref_value = "xmult",
                scalar_value = "scalar"
            })
        end
		if context.joker_main then return { chips = card.ability.extra.xmult } end
	end,
    calc_scaling = function (self, card, other_card, initial_value, scalar_value, args)
        print("Im observing a scaling event")
        print("Card:")
        print(card)
        print("Other Card:")
        print(other_card)
        print("Initial Value:")
        print(initial_value)
        print("Scalar Value:")
        print(scalar_value)
        print("Args:")
        print(args)
        print("Scaling card's metatable:")
        print(getmetatable(other_card))
        print("Card type:")
        print(other_card.card_type)
        print(other_card.ability.card_type)
        print(other_card.config.card_type)
        print(other_card.config.center.card_type)
        print("Is it a fish?")
        print(getmetatable(other_card) == Fish)
        print(getmetatable(other_card) == FishAndChips.Fish)
        print(getmetatable(other_card) == getmetatable(FishAndChips.Fish))
        -- change it to scale with only fishes once the check works
        -- also actually change the scaling instead of just printing
    end
}

--#endregion