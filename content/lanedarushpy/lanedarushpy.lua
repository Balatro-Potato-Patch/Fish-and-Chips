if SMODS.current_mod.optional_features then 
    SMODS.current_mod.optional_features.post_trigger = true 
else 
    SMODS.current_mod.optional_features = { post_trigger = true } 
end

SMODS.Atlas {
    key = "fac_lizie_credits",
    path = "lanedarushpy/credits.png",
    px = 71,
    py = 95
}

PotatoPatchUtils.Developer({
	name = 'lanedarushpy',
	-- atlas = 'fac_cards', -- TODO: add card for it
	atlas = 'fac_lizie_credits', -- TODO: add atlas
	pos = {x = 1, y = 0},
	colour = HEX("713a91"),
    loc = true,
	ignore_limits = false,
	fac_partner = 'fac_pangaea47' -- Only use this if you have a partner! This should be a string that's the same as your partner's PPU.Dev name property
})

PotatoPatchUtils.Developer({
	name = 'pangaea47',
	atlas = 'fac_lizie_credits', -- TODO: add atlas
	pos = {x = 0, y = 0},
	colour = G.C.YELLOW,
    loc = true,
	ignore_limits = false,
	fac_partner = 'fac_lanedarushpy'
})

SMODS.Atlas {
    key = "lanedarushpy_floppy_fih",
    path = "lanedarushpy/floppy.png",
    px = 71,
    py = 95
}
SMODS.Sound {
	key = 'laneda_flop',
	path = 'lanedarushpy/flop.ogg',
	volume = 1
}
SMODS.Sound {
	key = 'laneda_escape',
	path = 'lanedarushpy/escape.ogg',
	volume = 1
}
SMODS.Sound {
	key = 'laneda_blowfish',
	path = 'lanedarushpy/blowfish.ogg',
	volume = 1
}
SMODS.Sound {
	key = 'laneda_chips',
	path = 'lanedarushpy/chips.mp3',
	volume = 1
}

FishAndChips.laneda_floppy_escape = {}
FishAndChips.Fish {
	key = "floppy_fih",
	atlas = "lanedarushpy_floppy_fih",
	pos = { x = 4, y = 0 },
	weight = 5,
	ppu_coder = { "lanedarushpy" },
	ppu_artist = { "lanedarushpy" },
	attributes = { "xmult" },
	config = {
        anim = {
            fps = 6,
            frames = 5,
            x_pos = 4,
            delay = 0
        },
		extra = {
			Xmult = 1.0,
            Xmult_mod = 0.1,
            min_flop_time = 12,
            max_flop_time = 28,
            time_flop_escape = 5
		},
        immutable = {
            flopping = false,
            flop_flag = false,
            time_until_flop = 0,
            flop_start_time = 0,
            flop_away_time = 3,
            flop_at = 0
        }
	},
	environments = {
		pier = 5,
		city_river = 2.5,
        calm_pond = 4
	},
    pixel_size = { h = 71, w = 71 },
    stats = {
        weight = { min = 1, max = 15 },
        length = { min = 0.2, max = 1.2}
    },

	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.Xmult_mod, card.ability.extra.Xmult } }
	end,
	calculate = function(self, card, context)
		if context.joker_main and not card.ability.immutable.cant_flop then return { Xmult = card.ability.extra.Xmult > 1.0 and card.ability.extra.Xmult or nil } end
        local context_check = (context.end_of_round or context.first_hand_drawn or context.after or (context.fac_fish_hooked and pseudorandom("laneda_floppy_fuckyou", 1, 10) < 3))
        if context_check and card.ability.immutable.flop_flag then
            G.E_MANAGER:add_event(Event({
                func = function ()
                    card.ability.immutable.flop_flag = false;
                    card.ability.immutable.flopping = true;
                    card.ability.immutable.flop_start_time = G.TIMERS.REAL
                    return true;
                end
            }))
        end
	end,
    update = function(self, card, dt)
        if G.fac_fish_area then
            if card.ability.immutable.flopping then
                for _, _card in ipairs(G.fac_fish_area.highlighted) do
                    if _card == card then
                        card.ability.immutable.time_until_flop = pseudorandom("lizzie_floppy_fih", card.ability.extra.min_flop_time, card.ability.extra.max_flop_time)
                        card.ability.immutable.flop_at = G.TIMERS.REAL + card.ability.immutable.time_until_flop
                        card.ability.immutable.flopping = false;
                        
                        card.children.center:set_sprite_pos({ x = 4, y = 0 })
                        SMODS.scale_card(card, {
                            ref_table = card.ability.extra,
                            ref_value = "Xmult",
                            scalar_value = "Xmult_mod",
                        });
                    end
                end
            end
        end

        if card.ability.immutable.flop_at - G.TIMERS.REAL < 1 and not card.ability.immutable.cant_flop then
            card.ability.immutable.flop_flag = true
        end

        if card.ability.immutable.flopping and card.ability.immutable.flop_start_time + card.ability.extra.time_flop_escape < G.TIMERS.REAL then
            -- time to escape vro
            card.ability.immutable.flopping = false;
            card.ability.immutable.cant_flop = true;
            
            play_sound("fac_laneda_escape", 1.0);
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                blockable = false,
                delay = 0,
                func = function()
                    if FishAndChips and FishAndChips.laneda_floppy_escape then
                        local min_rad = math.pi / 4     
                        local max_rad = 1.67 * math.pi / 4 
                        local direction_thing = min_rad + (math.random() * (max_rad - min_rad))
                        card.children.center:set_sprite_pos({ x = 5, y = 0 })
                        FishAndChips.laneda_floppy_escape[#FishAndChips.laneda_floppy_escape + 1] = {
                            x = (G.ROOM.T.x + card.VT.x) * (G.TILESIZE * G.TILESCALE),
                            y = (G.ROOM.T.y + card.VT.y) * (G.TILESIZE * G.TILESCALE),
                            w = card.VT.w * (G.TILESIZE * G.TILESCALE),
                            h = card.VT.h * (G.TILESIZE * G.TILESCALE),

                            atlas_x = 4,
                            atlas_y = 0,

                            dx = direction_thing * (G.TILESIZE * G.TILESCALE) * 7.,
                            dy = -(G.TILESIZE * G.TILESCALE) * 15.,

                            r = card.VT.r,
                            dr = direction_thing * 2.5,
                        }
                    end

                    return true;
                end
            }))
            G.E_MANAGER:add_event(Event({
                blockable = false,
                delay = 0.3,
                func = function()
                    SMODS.destroy_cards(card, { immediate = true })
                    return true;
                end
            }))
        end

        if card.ability.immutable.flopping then
            if card.ability.anim.delay >= 60 / card.ability.anim.fps then
                card.ability.anim.x_pos = (card.ability.anim.x_pos + 1) % card.ability.anim.frames;
                
                if card.ability.anim.x_pos == 0 then 
                    play_sound("fac_laneda_flop", 1.0);
                end

                card.children.center:set_sprite_pos({ x = card.ability.anim.x_pos, y = 0 })
                card.ability.anim.delay = 0
            else
                card.ability.anim.delay = card.ability.anim.delay + 1
            end
        end
    end
}

FishAndChips.laneda_floppy_escapees = {}
-- called by lovely patch :vomit:
FishAndChips.laneda_draw_floppy_escapees = function()
    for _, particle in ipairs(FishAndChips.laneda_floppy_escape) do
        if not FishAndChips.laneda_floppy_escapees[particle.atlas_x.."_"..particle.atlas_y] then
            FishAndChips.laneda_floppy_escapees[particle.atlas_x.."_"..particle.atlas_y] =
                love.graphics.newQuad(particle.atlas_x * 71, particle.atlas_y * 95, 71, 95, G.ASSET_ATLAS["fac_lanedarushpy_floppy_fih"].image)
        end
        love.graphics.push()
        love.graphics.setColor(1., 1., 1., 1.)
        love.graphics.translate(particle.x, particle.y)
        love.graphics.scale(particle.w / 71, particle.h / 95)
        love.graphics.translate(71/2, 95/2)
        love.graphics.rotate(particle.r)
        love.graphics.translate(-71/2, -95/2)
        love.graphics.draw(G.ASSET_ATLAS["fac_lanedarushpy_floppy_fih"].image, FishAndChips.laneda_floppy_escapees[particle.atlas_x.."_"..particle.atlas_y], 0., 0.)

        love.graphics.pop()
    end
end

local lu = love.update
function love.update(dt, ...)
    lu(dt, ...)
    if FishAndChips and FishAndChips.laneda_floppy_escape then
        local should_filter = false
        for _, particle in ipairs(FishAndChips.laneda_floppy_escape) do
            particle.x = particle.x + particle.dx * dt
            particle.dy = particle.dy + (1800) * 0.5 * dt
            particle.y = particle.y + particle.dy * dt
            particle.dy = particle.dy + (1800) * 0.5 * dt
            particle.r = particle.r + particle.dr * dt

            if particle.y > 100000 then
                should_filter = true
            end
        end
        if should_filter then
            local temp = FishAndChips.laneda_floppy_escape
            FishAndChips.laneda_floppy_escape = {}

            for _, particle in ipairs(FishAndChips.laneda_floppy_escape) do
                if particle.y < 100000 then
                    FishAndChips.laneda_floppy_escape[#FishAndChips.laneda_floppy_escape + 1] = particle
                end
            end
        end
    end
end

SMODS.Atlas {
    key = "lanedarushpy_flying",
    path = "lanedarushpy/flying.png",
    px = 142,
    py = 285
}

FishAndChips.Fish {
	key = "flying_fih",
	atlas = "lanedarushpy_flying",
	pos = { x = 0, y = 0 },
	weight = 5,
	ppu_coder = { "lanedarushpy" },
	ppu_artist = { "pangaea47" },
	attributes = { "xmult" },
	config = {
		extra = {
			divide = 250,
            cap = 3
		}
	},
	environments = {
		garden = 5,
		city_river = 15,
        calm_pond = 5,
	},

    stats = {
        weight = { min = 550000, max = 600000 },
        length = { min = 45, max = 55}
    },

    display_size = { w = 142, h = 285 },
    pixel_size = { w = 142, h = 285 },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.divide, card.ability.extra.cap } }
	end,
	calculate = function(self, card, context)
		if context.joker_main then 
            local xmult = math.min(card.ability.extra.divide / hand_chips, 4)
            if xmult > 1 then
                return { Xmult = xmult };
            end
        end
    end,
}

SMODS.Atlas {
    key = "pangaea47_main",
    path = "lanedarushpy/pangaea47.png",
    px = 71,
    py = 95
}


--- Findows
SMODS.Sound {
    key = "music_findows_shop",
    path = "lanedarushpy/music_findows_shop.ogg",
    pitch = 1.0,
    volume = 0.75,
    -- sync = {
    --     ['music_findows_booster'] = true,
    --     ['music_findows_main'] = true,
    --     ['music_findows_boss'] = true,
    -- },

    select_music_track = function (self)
        local play_condition = G.STATE == G.STATES.SHOP
        local has_findows = not not next(SMODS.find_card("fish_fac_argel_findows", true))

        return (has_findows and play_condition) and 105 or false
    end
}

SMODS.Sound {
    key = "music_findows_main",
    path = "lanedarushpy/music_findows_main.ogg",
    pitch = 1.0,
    volume = 0.75,
    -- sync = {
    --     ['music_findows_booster'] = true,
    --     ['music_findows_shop'] = true,
    --     ['music_findows_boss'] = true,
    -- },

    select_music_track = function (self)
        local has_findows = not not next(SMODS.find_card("fish_fac_argel_findows", true))

        return has_findows and 103 or false
    end
}

SMODS.Sound {
    key = "music_findows_booster",
    path = "lanedarushpy/music_findows_boosters.ogg",
    pitch = 1.0,
    volume = 0.75,
    -- sync = {
    --     ['music_findows_main'] = true,
    --     ['music_findows_shop'] = true,
    --     ['music_findows_boss'] = true,
    -- },

    select_music_track = function (self)
        local play_condition = G.STATE == G.STATES.SMODS_BOOSTER_OPENED;
        local has_findows = not not next(SMODS.find_card("fish_fac_argel_findows", true))

        return (play_condition and has_findows) and 106 or false
    end
}

SMODS.Sound {
    key = "music_findows_boss",
    path = "lanedarushpy/music_findows_boss.ogg",
    pitch = 1.0,
    volume = 0.75,
    -- sync = {
    --     ['music_findows_main'] = true,
    --     ['music_findows_shop'] = true,
    --     ['music_findows_booster'] = true,
    -- },

    select_music_track = function (self)
        local play_condition = G.GAME.blind and (G.GAME.blind.in_blind and not not G.GAME.blind.boss);
        local has_findows = not not next(SMODS.find_card("fish_fac_argel_findows", true))

        return (play_condition and has_findows) and 106 or false
    end
}

FishAndChips.Fish {
	key = "argel_findows",
	atlas = "pangaea47_main",
	pos = { x = 0, y = 0 },
	weight = 10,
	ppu_coder = { "lanedarushpy" },
	ppu_artist = { "pangaea47" },
	attributes = { "chips", "mult", "economy" },
	config = {
		extra = {
			min_sand_dollars = -1,
            max_sand_dollars =  2,
            min_dollars = -1,
            max_dollars =  4,
            min_chips = -10,
            max_chips =  30,
            min_mult = -2,
            max_mult = 10
		},
        immutable = {}
	},
	environments = {
		city_river = 10,
        backroom = 30,
        wormhole = 10,
        soup = 1
	},

    stats = {
        weight = { min = 0, max = 0 },
        length = { min = 0.267, max = 0.67}
    },
	loc_vars = function(self, info_queue, card)
        local loc_choices = {
        }

        local loc_colors = {
            fish = FishAndChips.C.SAND_DOLLAR,
            jokers = G.C.MULT,
            playing_cards = G.C.CHIPS,
            consumables = G.C.PURPLE
        }

        for count = card.ability.extra.min_sand_dollars, card.ability.extra.max_sand_dollars do
            loc_choices[#loc_choices+1] = { string = (count < 0 and "" or "+") .. tostring(count) .. " ", colour = loc_colors.fish }
        end

        for count = card.ability.extra.min_mult, card.ability.extra.max_mult do
            loc_choices[#loc_choices+1] = { string = (count < 0 and "" or "+") .. tostring(count) .. " ", colour = loc_colors.jokers }
        end

        for count = card.ability.extra.min_chips, card.ability.extra.max_chips do
            loc_choices[#loc_choices+1] = { string = (count < 0 and "" or "+") .. tostring(count) .. " ", colour = loc_colors.playing_cards }
        end

        for count = card.ability.extra.min_dollars, card.ability.extra.max_dollars do
            loc_choices[#loc_choices+1] = { string = (count < 0 and "" or "+") .. tostring(count) .. " ", colour = loc_colors.consumables }
        end

        -- print(loc_choices)

        local main_start = {
            { n = G.UIT.O, config = { object = DynaText({ string = { 
                { string = "All Jokers ", colour = loc_colors["jokers"] },
                { string = "All Fish ", colour = loc_colors["fish"] },
                { string = "Consumables ", colour = loc_colors["consumables"] },
                { string = "Scored cards ", colour = loc_colors["playing_cards"] }
            }, colours = { G.C.RED }, pop_in_rate = 9999999, silent = true, random_element = true, pop_delay = 0.75, scale = 0.32, min_cycle_time = 0 }) } },
            { n = G.UIT.T, config = { text = 'give ', colour = G.C.UI.TEXT_DARK, scale = 0.32 } },
            { n = G.UIT.O, config = { object = DynaText({ string = loc_choices, colours = { G.C.RED }, pop_in_rate = 9999999, silent = true, random_element = true, pop_delay = 0.5, scale = 0.32, min_cycle_time = 0 }) } },
            {
                n = G.UIT.O,
                config = {
                    object = DynaText({
                        string = {
                            { string = localize("k_mult"), colour = loc_colors["jokers"] },
                            { string = localize("k_fac_lizie_chips"), colour = loc_colors["playing_cards"] },
                            { string = localize("k_fac_sand_dollars"), colour = loc_colors["fish"] },
                            { string = localize("k_fac_lizie_dollars"), colour = loc_colors["consumables"] },
                        },
                        colours = { G.C.UI.TEXT_DARK },
                        pop_in_rate = 9999999,
                        silent = true,
                        random_element = true,
                        pop_delay = 0.75,
                        scale = 0.32,
                        min_cycle_time = 0
                    })
                }
            },
        }

        return { main_start = main_start }
	end,
	calculate = function(self, card, context)
		if context.other_joker then 
            local rand_mult = pseudorandom("fac_findows_mult", card.ability.extra.min_mult, card.ability.extra.max_mult)
            if rand_mult ~= 0 then
                return {
                    mult = rand_mult,
                    message_card = context.other_joker
                }
            end
        end

        if context.individual and context.cardarea == G.play then
            local rand_chips = pseudorandom("fac_findows_chips", card.ability.extra.min_chips, card.ability.extra.max_chips)
            if rand_chips ~= 0 then
                return {
                    chips = rand_chips
                }
            end
        end

        if context.other_consumeable then
            local rand_dollars = pseudorandom("fac_findows_dollars", card.ability.extra.min_dollars, card.ability.extra.max_dollars)
            if rand_dollars ~= 0 then
                return {
                    dollars = rand_dollars,
                    message_card = context.other_consumeable
                }
            end
        end

        if context.other_main and context.cardarea == G.fac_fish_area then
            local rand_sand =  pseudorandom("fac_findows_sands", card.ability.extra.min_sand_dollars, card.ability.extra.max_sand_dollars)
            if rand_sand ~= 0 then
                return {
                    sand_dollars = rand_sand,
                    message_card = context.other_main
                }
            end
        end
	end,
}

FishAndChips.Fish {
	key = "argel_blowfish",
	atlas = "pangaea47_main",
	pos = { x = 1, y = 0 },
	weight = 10,
	ppu_coder = { "lanedarushpy" },
	ppu_artist = { "pangaea47" },
	attributes = { "economy" },
	config = {
		extra = {
			sands = 1
		}
	},
	environments = {
		pier = 20,
		city_river = 50,
        calm_pond = 10,
	},

    stats = {
        weight = { min = 5, max = 20 },
        length = { min = 0.9, max = 1.1}
    },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.sands } }
	end,
	calculate = function(self, card, context)
		if context.joker_main then 
            local current_pos = 0
            for index, value in ipairs(G.fac_fish_area.cards) do
                if value == card then current_pos = index end
            end

            if current_pos > 2 then
                return { 
                    sand_dollars = current_pos - 2, 
                    pre_func = function()
                        G.E_MANAGER.add_event(Event({
                            func = function(e)
                                play_sound("fac_laneda_blowfish", 1.0)
                                local left = G.fac_fish_area.cards[current_pos - 1]
                                G.fac_fish_area.cards[current_pos-1] = G.fac_fish_area.cards[1]
                                G.fac_fish_area.cards[1] = left
                                return true
                            end
                        }))
                    end
                } 
            end
        end
	end,
}

FishAndChips.Fish {
	key = "argel_thing",
	atlas = "pangaea47_main",
	pos = { x = 2, y = 0 },
	weight = 5,
	ppu_coder = { "lanedarushpy" },
	ppu_artist = { "pangaea47" },
	attributes = { "economy", "destroy_card" },
	config = {
		extra = {
			sell_value = 1,
            cap = 4
		},

        immutable = {
            usable = false
        }
	},
	environments = {
		volcano = 40,
		backroom = 10,
        wormhole = 25,
	},

    stats = {
        weight = { min = -100, max = -5 },
        length = { min = -10, max = 10}
    },
	loc_vars = function(self, info_queue, card)
		return { vars = { 1, card.ability.extra.cap } }
	end,
	calculate = function(self, card, context)
        if context.setting_blind then 
            G.E_MANAGER:add_event(Event({
                func = function(e)
                    card.ability.immutable.usable = true
                    SMODS.calculate_effect({ message = localize("k_fac_lizie_ready"), message_card = card })
                    return true;
                end
            }))
        end
	end,
    can_use = function (self, card)
        local fih = {}
        for _, fish in ipairs(G.fac_fish_area.cards) do
            if (fish ~= card) and not SMODS.is_eternal(fish) then fih[#fih+1] = fish end
        end
        
        return card.ability.immutable.usable and (#fih > 0)
    end,
    keep_on_use = function ()
        return true
    end,
    use = function (self, card)
        G.E_MANAGER:add_event(Event({
            func = function(e)
                local fih = {}
                for _, fish in ipairs(G.fac_fish_area.cards) do
                    if fish ~= card and not SMODS.is_eternal(fish) then fih[#fih+1] = fish end
                end

                if #fih < 1 then return true end
                SMODS.destroy_cards(pseudorandom_element(fih, "fac_lizie_thing"), { bypass_eternal = false, immediate = true })
                play_sound("fac_laneda_chips", 1.0)
                card.ability.extra_value = card.ability.extra_value + math.min(card.ability.extra.sell_value, card.ability.extra.cap)
                card.ability.extra.sell_value = card.ability.extra.sell_value + 1
                card:set_cost()
                SMODS.calculate_effect {
                    message = localize('k_val_up'),
                    message_card = card,
                    colour = FishAndChips.C.SAND_DOLLAR
                }

                return true
            end
        }))
    end
}

FishAndChips.Fish {
	key = "still_fish",
	atlas = "pangaea47_main",
	pos = { x = 3, y = 0 },
	weight = 10,
	ppu_coder = { "lanedarushpy" },
	ppu_artist = { "pangaea47" },
	attributes = { "copying" },
	config = {
		extra = {
			odds = 4
		}
	},
    
    stats = {
        weight = { min = 1, max = 15 },
        length = { min = 0.8, max = 2.4}
    },

	environments = {
		backroom = 25,
		wormhole = 15,
	},

	loc_vars = function(self, info_queue, card)
		local num, denom = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, "lizie_stillfish")
		return { vars = { num, denom } }
	end,

	calculate = function(self, card, context)
        if context.post_trigger and (context.cardarea == G.jokers or context.cardarea == G.fac_fish_area) and (context.other_card ~= card) then
            local num, denom = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, "lizie_stillfish")
		    if SMODS.pseudorandom_probability(card, "fac_lizie_still_fish", num, denom) then
                local new_ret = context.other_ret and context.other_ret.jokers or {};
                print(context.other_ret or new_ret)
                local function shuffle_letters(str)
                    local letters = {}
                    for letter in str:gmatch'.[\128-\191]*' do
                        table.insert(letters, letter)
                    end

                    for i = 1, #letters - 1 do
                        -- Swap the first item with a random item (including itself).
                        local j = math.random(i, #letters)
                        letters[i], letters[j] = letters[j], letters[i]
                    end

                    local ret = ""
                    for _, j in ipairs(letters) do
                        ret = ret .. j
                    end

                    return ret
                end

                if new_ret.message then new_ret.message = shuffle_letters(new_ret.message) end
                if not new_ret.message then new_ret.message = localize("k_fac_lizie_repeated") end
                new_ret.message_card = card
                print("Post_trigger?")
                return new_ret
            end
        end
	end,
}

FishAndChips.Fish {
	key = "lizie_cafindish",
	atlas = "pangaea47_main",
	pos = { x = 1, y = 2 },
	weight = 10,
	ppu_coder = { "lanedarushpy" },
	ppu_artist = { "pangaea47" },
	attributes = { "chips" },
	config = {
		extra = {
			odds = 67,
            Xmult = 1.3
		}
	},
    
    stats = {
        weight = { min = 0.4, max = 2 },
        length = { min = 0.1, max = 0.6}
    },
	environments = {
        pier = 1,
        soup = 0.35,
        city_river = 0.15
	},
	loc_vars = function(self, info_queue, card)
        local num, denom = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, "lizie_cafindish")
		return { vars = { num, denom, card.ability.extra.Xmult } }
	end,
	calculate = function(self, card, context)
        if (context.other_unknown and context.cardarea == G.fac_fish_area) or context.joker_main then
            local fx = {}

            for _, v in ipairs(G.fac_fish_area.cards) do
                fx[#fx+1] = {
                    Xmult = card.ability.extra.Xmult,
                    message_card = v,
                    func = function()
                        G.E_MANAGER:add_event(Event({
                            func = function(e)
                                card:juice_up(0.7, 0.3);
                                return true
                            end
                        }))
                    end
                }
            end

            return SMODS.merge_effects(fx);
        end

        if context.end_of_round and context.main_eval and context.cardarea == G.fac_fish_area then
            local num, denom = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, "lizie_cafindish")
		    if SMODS.pseudorandom_probability(card, "lizie_cafindish", num, denom) then 
                SMODS.destroy_cards(card, nil, nil, true)
                return {
                    message = localize('k_extinct_ex')
                }
            else
                return {
                    message = localize('k_safe_ex')
                }
            end
        end
	end,

    in_pool = function(self, args) -- equivalent to `yes_pool_flag = 'vremade_gros_michel_extinct'`
        return G.GAME.pool_flags.fac_lizie_cafindish_extinct
    end
}