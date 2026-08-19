SMODS.current_mod.optional_features = SMODS.current_mod.optional_features or {}
SMODS.current_mod.optional_features.retrigger_joker = true
SMODS.current_mod.optional_features.post_trigger = true

-- I did intend to do 75
-- but i dont have it in me
-- You win for now

SMODS.Atlas({
	key = "notmario_fish", -- Please include your name/team name in your atlas keys
	path = "notmario/ts_fishes_me.png",
	px = 71,
	py = 95,
})

local esanddollars_gradient = SMODS.Gradient({
	key = "fac_mf_esanddollars",
	colours = {
		HEX("ff8a8a"),
		HEX("f24b99"),
	},
	cycle = 4,
	update = update_exp_colour,
})

FishAndChips.Fish {
	key = "mf_john_fishlatro",
	atlas = "notmario_fish",
	pos = { x = 0, y = 0 },
	weight = 3,
	ppu_coder = { "notmario" },
	ppu_artist = { "notmario" },
	attributes = { "economy", "usable", },
	pixel_size = {w = 62, h = 69},
	badge_key = "k_fac_mf_john",
	config = {
		extra = {
			max = 7,
		}
	},
	environments = {
		styx = 1.0,
		backroom = 0.2,
	},
	stats = {
		weight = {min = 6.7, max = 6.7},
		length = {min = 0.67, max = 0.67}
	},
	blueprint_compat = false,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.max } }
	end,
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('timpani')
                card:juice_up(0.3, 0.5)
				local sand_dollar_diff = G.GAME.fac_sand_dollars ^ G.GAME.fac_sand_dollars - G.GAME.fac_sand_dollars
                ease_sand_dollars(math.max(0, math.min(sand_dollar_diff, card.ability.extra.max)), true)
                return true
            end
        }))
        delay(0.6)
    end,
    can_use = function(self, card)
        return true
    end
}

FishAndChips.Fish {
	key = "mf_broken_mirror",
	atlas = "notmario_fish",
	pos = { x = 2, y = 0 },
	weight = 3,
	ppu_coder = { "notmario" },
	ppu_artist = { "notmario" },
	attributes = { "copying", "joker", "position", "rarity", "destroy_card", "chance" },
	blueprint_compat = false,
	badge_key = "k_fac_mf_relic",
	config = {
		extra = { odds = 5, },
	},
	environments = {
		city_river = 1,
		backroom = 0.2,
	},
	stats = {
		weight = {min = 0.35, max = 0.35},
		length = {min = 0.18, max = 0.18}
	},
    loc_vars = function(self, info_queue, card)
		local new_numerator, new_denominator =
			SMODS.get_probability_vars(card, 1, card.ability.extra.odds, "fac_mf_broken_mirror")
        if card.area and card.area == G.fac_fish_area then
            local other_joker
            for i = 1, #G.fac_fish_area.cards do
                if G.fac_fish_area.cards[i] == card then other_joker = G.fac_fish_area.cards[i + 1] end
            end
            local compatible = other_joker and other_joker ~= card and other_joker.config.center.blueprint_compat
            local main_end = {
                {
                    n = G.UIT.C,
                    config = { align = "bm", minh = 0.4 },
                    nodes = {
                        {
                            n = G.UIT.C,
                            config = { ref_table = card, align = "m", colour = compatible and FishAndChips.C.FISH or mix_colours(G.C.RED, G.C.JOKER_GREY, 0.8), r = 0.05, padding = 0.06 },
                            nodes = {
                                { n = G.UIT.T, config = { text = ' ' .. localize('k_' .. (compatible and 'compatible' or 'incompatible')) .. ' ', colour = G.C.UI.TEXT_LIGHT, scale = 0.32 * 0.8 } },
                            }
                        }
                    }
                }
            }
            return { main_end = main_end, vars = { new_numerator, new_denominator} }
        else
			return { vars = { new_numerator, new_denominator } }
		end
    end,

	fac_mf_add_multibox = function(_c, info_queue, other_card, desc_nodes, specific_vars, full_UI_table, ability, card, ...)
		if G.jokers and _c.set == "Joker" and _c.rarity == 2 then
			local desc_text = G.localization.descriptions.Other.fac_mf_broken_mirror.text
			local new_numerator, new_denominator =
				SMODS.get_probability_vars(card, 1, card.ability.extra.odds, "fac_mf_broken_mirror")
			PotatoPatchUtils.Developers.fac_notmario.generate_ui_multiboxes({
                {
                    localized_text = desc_text,
                    loc_vars = function(self, card, center)
                        local other_joker
						for i = 1, #G.fac_fish_area.cards do
							if G.fac_fish_area.cards[i] == copier then other_joker = G.fac_fish_area.cards[i + 1] end
						end
						local compatible = other_joker and other_joker ~= copier and other_joker.config.center.blueprint_compat
						local main_end = {
							{
								n = G.UIT.C,
								config = { align = "bm", minh = 0.4 },
								nodes = {
									{
										n = G.UIT.C,
										config = { ref_table = copier, align = "m", colour = compatible and FishAndChips.C.FISH or mix_colours(G.C.RED, G.C.JOKER_GREY, 0.8), r = 0.05, padding = 0.06 },
										nodes = {
											{ n = G.UIT.T, config = { text = ' ' .. localize('k_' .. (compatible and 'compatible' or 'incompatible')) .. ' ', colour = G.C.UI.TEXT_LIGHT, scale = 0.32 * 0.8 } },
										}
									}
								}
							}
						}
						return { main_end = main_end, vars = { new_numerator, new_denominator } }
                    end
                }
            })(_c, info_queue, other_card, desc_nodes, specific_vars, full_UI_table)
		end
	end,
	fac_mf_add_extra_effect = function(other_card, context, jokers, triggered, card)
		if other_card:is_rarity("Uncommon") then
			local other_joker = nil
			for i = 1, #G.fac_fish_area.cards do
				if G.fac_fish_area.cards[i] == card then other_joker = G.fac_fish_area.cards[i + 1] end
			end
			local ret = SMODS.blueprint_effect(other_card, other_joker, context)
			if ret then
				ret.colour = FishAndChips.C.FISH
				if not jokers then jokers = {} end
				jokers = SMODS.merge_effects({ jokers, ret })
			end

			if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
				if SMODS.pseudorandom_probability(other_card, 'fac_mf_broken_mirror', 1, card.ability.extra.odds) then
					SMODS.destroy_cards(other_card, nil, nil, true)
					return {
						message = localize('k_broken_ex'),
						colour = G.C.RED,
					}
				end
			end
		end
		return jokers, triggered
	end
}

local has_calc_key = function(key)
	for _, k in pairs(SMODS.scoring_parameter_keys) do
		if k == key then return true end
	end
	return false
end
local should_talisman_key = function (key)
	return has_calc_key(key) and not not (SMODS.Mods.Talisman or SMODS.Mods.cdataman or {}).can_load
end

-- SMODS.Sound({
-- 	key = "notmario_emult",
-- 	path = "notmario/emult.ogg",
-- 	pitch = 1.0,
-- })

-- local emult_gradient = SMODS.Gradient({
-- 	key = "fac_mf_emult",
-- 	colours = {
-- 		HEX("ff73ad"),
-- 		HEX("db005f"),
-- 	},
-- 	cycle = 4,
-- 	update = update_exp_colour,
-- })

-- Scrapped because too niche

-- FishAndChips.Fish {
-- 	key = "mf_holofish",
-- 	atlas = "notmario_fish",
-- 	pos = { x = 0, y = 1 },
--     soul_pos = {
--         x = 1, y = 1,
-- 		draw = function(card, scale_mod, rotate_mod)
-- 			local fish_data = G.PROFILES[G.SETTINGS.profile].fac_fishing.fish_data[card.config.center_key] or {}
-- 			local is_compendium = card.area and card.area.config.fac_compendium
-- 			if (fish_data and fish_data.times_caught and fish_data.times_caught > 0) or (not is_compendium) then
-- 				card.hover_tilt = card.hover_tilt * 1.5
-- 				card.children.floating_sprite:draw_shader('dissolve', nil, nil, nil, card.children.center, 2 * scale_mod, 2 * rotate_mod)
-- 				card.children.floating_sprite:draw_shader('voucher', nil, card.ARGS.send_to_shader, nil, card.children.center, 2 * scale_mod, 2 * rotate_mod)
-- 				card.hover_tilt = card.hover_tilt / 1.5
-- 			end
-- 		end
--     },
-- 	weight = 1,
-- 	ppu_coder = { "notmario" },
-- 	ppu_artist = { "notmario" },
-- 	attributes = { "destroy_card", "usable" },
-- 	config = {
-- 		extra = {}
-- 	},
-- 	environments = {
-- 		wormhole = 1.0,
-- 	},
-- 	blueprint_compat = false,
-- 	loc_vars = function(self, info_queue, card)
-- 		return { vars = { } }
-- 	end,
--     use = function(self, card, area, copier)
--         local my_pos = nil
-- 		for i = 1, #G.fac_fish_area.cards do
-- 			if G.fac_fish_area.cards[i] == card then
-- 				my_pos = i
-- 				break
-- 			end
-- 		end
-- 		if my_pos and G.fac_fish_area.cards[my_pos + 1] and not SMODS.is_eternal(G.fac_fish_area.cards[my_pos + 1], card) then
-- 			local sliced_card = G.fac_fish_area.cards[my_pos + 1]
-- 			G.GAME.fac_mf_holofish = sliced_card.config.center.key

-- 			G.E_MANAGER:add_event(Event({
-- 				func = function()
-- 					SMODS.destroy_cards(sliced_card, nil, nil, true)
-- 					return true
-- 				end,
-- 			}))
-- 		end
--     end,
--     can_use = function(self, card)
--         local my_pos = nil
-- 		for i = 1, #G.fac_fish_area.cards do
-- 			if G.fac_fish_area.cards[i] == card then
-- 				my_pos = i
-- 				break
-- 			end
-- 		end
--         return not G.GAME.fac_mf_holofish and my_pos and G.fac_fish_area.cards[my_pos + 1] and not SMODS.is_eternal(G.fac_fish_area.cards[my_pos + 1], card)
--     end,
-- 	keep_on_use = function(card) return true end,
-- }

-- local fac_poll_fish = FishAndChips.poll_fish
-- function FishAndChips.poll_fish(...)
-- 	if G.GAME.fac_mf_holofish then
-- 		local ret = G.GAME.fac_mf_holofish
-- 		G.GAME.fac_mf_holofish = nil
-- 		return ret
-- 	else
-- 		return fac_poll_fish(...)
-- 	end
-- end

-- SMODS.Attribute {
--     key = "emult",
-- }

-- SMODS.Attribute {
--     key = "eemult",
-- }

-- Scrapped because they probably hate fun

-- -- To whom it may concern
-- -- This is catchable by Spindown Daceing into it then using Holofish
-- -- 100% catches is still possible :3
-- -- also its like x5 at 100000 mult
-- -- and x10 at 14000000.. its like vanilla balance right ?
-- -- Also. quote we are "allowed to use extinct mechanics". plus it uses up weight
-- FishAndChips.Fish {
-- 	key = "mf_cryptic_fossil",
-- 	atlas = "notmario_fish",
-- 	pos = { x = 3, y = 0 },
-- 	weight = 1,
-- 	ppu_coder = { "notmario" },
-- 	ppu_artist = { "notmario" },
-- 	attributes = { "emult", },
-- 	pixel_size = {w = 71, h = 91},
-- 	config = {
-- 		extra = {
-- 			emult = 1.14,
-- 		}
-- 	},
-- 	blueprint_compat = true,
-- 	loc_vars = function(self, info_queue, card)
-- 		return { vars = { card.ability.extra.emult } }
-- 	end,
-- 	environments = {
-- 		backroom = 1.0,
-- 	},
--     in_pool = function(self, args)
--         return false -- lol ?
--     end,
-- 	calculate = function(self, card, context)
-- 		if context.joker_main then
-- 			if should_talisman_key("emult") then
-- 				return {
-- 					emult = card.ability.extra.emult,
-- 				}
-- 			else
-- 				return {
-- 					pre_func = function()
-- 						mult = mod_mult(mult ^ card.ability.extra.emult)
-- 					end,
-- 					message = "^" .. card.ability.extra.emult .. " Mult",
-- 					sound = "fac_notmario_emult",
-- 					colour = G.C.DARK_EDITION,
-- 				}
-- 			end
-- 		end
-- 	end,
-- }

FishAndChips.mf_redherring_attributes = {}

local post_attribute_hook = SMODS.Attribute.post_inject_class
SMODS.Attribute.post_inject_class = function(self, ...)
    post_attribute_hook(self, ...)

    for _, attr in ipairs(SMODS.Attribute.obj_buffer) do
        if not G.FAC_ENVIRONMENTS[attr] and attr ~= "fac_treasure" then
            FishAndChips.mf_redherring_attributes[#FishAndChips.mf_redherring_attributes + 1] = attr
        end
    end
end

FishAndChips.Fish {
	key = "mf_red_herring",
	atlas = "notmario_fish",
	pos = { x = 1, y = 0 },
	weight = 1,
	ppu_coder = { "notmario" },
	ppu_artist = { "notmario" },
	attributes = FishAndChips.mf_redherring_attributes,
	config = {
		extra = { fish_slot = 1, },
	},
	stats = {
		weight = {min = 4, max = 6},
		length = {min = 0.34, max = 0.65}
	},
	environments = {
		backroom = 1.0,
		wormhole = 0.2,
		calm_pond = 0.2,
	},
	blueprint_compat = false,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.fish_slot } }
	end,
	add_to_deck = function(self, card, from_debuff)
		G.E_MANAGER:add_event(Event({
			func = function()
				G.fac_fish_area.config.card_limits.base = G.fac_fish_area.config.card_limits.base + 1
				return true
			end,
		}))
	end,
	remove_from_deck = function(self, card, from_debuff)
		G.E_MANAGER:add_event(Event({
			func = function()
				G.fac_fish_area.config.card_limits.base = G.fac_fish_area.config.card_limits.base - 1
				return true
			end,
		}))
	end,
}

-- local smods_get_attribute_pool = SMODS.get_attribute_pool
-- local ghurt_yo = nil
-- function SMODS.get_attribute_pool(attribute, seen, ...)
--     if not ghurt_yo and not G.FAC_ENVIRONMENTS[attribute] then
-- 		ghurt_yo = true
-- 		local res = smods_get_attribute_pool(attribute, seen, ...)
-- 		ghurt_yo = nil
-- 		res[#res + 1] = "fish_fac_mf_red_herring"
-- 		return res
-- 	else
-- 		return smods_get_attribute_pool(attribute, seen, ...)
-- 	end
-- end

-- local smods_has_attribute = SMODS.has_attribute
-- function SMODS.has_attribute(obj, attribute, ...)
--     if obj.key == "fish_fac_mf_red_herring" and not G.FAC_ENVIRONMENTS[attribute] then return true end
-- 	return smods_has_attribute(obj, attribute, ...)
-- end

FishAndChips.Fish {
	key = "mf_prismatic_shard",
	atlas = "notmario_fish",
	pos = { x = 4, y = 0 },
	weight = 1,
	ppu_coder = { "notmario" },
	ppu_artist = { "notmario" },
	attributes = { "passive", "editions", },
	badge_key = "k_fac_mf_relic",
	config = {
		extra = { },
	},
	environments = {
		garden = 1.0,
		backroom = 0.2,
	},
	stats = {
		weight = {min = 50, max = 50},
		length = {min = 0.25, max = 0.25}
	},
	pixel_size = { w = 71, h = 70 },
	blueprint_compat = false,
	loc_vars = function(self, info_queue, card)
		return { vars = { } }
	end,
	set_ability = function(self, card, initial, delay_sprites)
		local fish_data = G.PROFILES[G.SETTINGS.profile].fac_fishing.fish_data[card.config.center_key] or {}
		local is_compendium = card.area and card.area.config.fac_compendium
		if (fish_data and fish_data.times_caught and fish_data.times_caught > 0) or (not is_compendium) then
			card:set_edition("e_polychrome", true, true, true)
		end
	end,
}

local create_card_ref = create_card
function create_card(_type, area, legendary, _rarity, skip_materialize, soulable, forced_key, key_append)
	local card = create_card_ref(_type, area, legendary, _rarity, skip_materialize, soulable, forced_key, key_append)
	if card.config.center.key == "fish_fac_mf_prismatic_shard" then
		local fish_data = G.PROFILES[G.SETTINGS.profile].fac_fishing.fish_data[card.config.center_key] or {}
		local is_compendium = card.area and card.area.config.fac_compendium
		if (fish_data and fish_data.times_caught and fish_data.times_caught > 0) or (not is_compendium) then
			card:set_edition("e_polychrome", true, true, true)
		end
	end
	return card
end

local set_edition_ref = Card.set_edition
function Card:set_edition(edition, ...)
	if self.config and self.config.center.key == "fish_fac_mf_prismatic_shard" then
		set_edition_ref(self, "e_polychrome", ...)
	else
		set_edition_ref(self, edition, ...)
	end
end

function sign(number)
    return number > 0 and 1 or (number == 0 and 0 or -1)
end

local get_weight_of_object = SMODS.get_weight_of_object
function SMODS.get_weight_of_object(obj, opt_weight, args)
	local w, w2 = get_weight_of_object(obj, opt_weight, args)
	if obj and obj.set == 'fac_Fish' and next(SMODS.find_card("fish_fac_mf_prismatic_shard")) then
		return sign(w), sign(w2)
	end
	return w, w2
end

SMODS.Atlas({
	key = "notmario_wa", -- Please include your name/team name in your atlas keys
	path = "notmario/Wa.png",
	px = 128,
	py = 55,
})

FishAndChips.Fish {
	key = "mf_wa",
	atlas = "notmario_wa",
	pos = { x = 0, y = 0 },
	weight = 3,
	ppu_coder = { "notmario" },
	-- ppu_artist = { "notmario" },
	attributes = { "retrigger", "position", },
	-- pixel_size = {w = 128, h = 55},
	display_size = {w = 128 * 0.75, h = 55 * 0.75},
	config = {
		extra = {}
	},
	stats = {
		weight = {min = 0.04, max = 0.1}, -- it's a still image !
		length = {min = 0.40, max = 0.70}
	},
	environments = {
		wormhole = 1.0,
	},
	fac_mf_rotate_by = math.pi * 1 / 3,
	blueprint_compat = true,
	loc_vars = function(self, info_queue, card)
		return { vars = { } }
	end,
	calculate = function(self, card, context)
        if context.repetition and context.cardarea == G.play then
            local first_half = math.ceil(#G.play.cards / 2)
    		local in_first_half = false
    		for i = 1, first_half do
    			if context.other_card == G.play.cards[i] then
    				in_first_half = true
    				break
    			end
    		end
            if in_first_half then
                return {
                    repetitions = 1
                }
            end
        end
	end,
}

-- rotate hook
local card_draw = Card.draw
function Card:draw(layer, ...)
	if self.config and self.config.center and self.config.center.fac_mf_rotate_by then
		self.VT.r = self.VT.r + self.config.center.fac_mf_rotate_by
		for k, v in pairs(self.children) do
			v.VT.r = v.VT.r + self.config.center.fac_mf_rotate_by
		end
	end

	card_draw(self, layer, ...)

	if self.config and self.config.center and self.config.center.fac_mf_rotate_by then
		self.VT.r = self.VT.r - self.config.center.fac_mf_rotate_by
		for k, v in pairs(self.children) do
			v.VT.r = v.VT.r - self.config.center.fac_mf_rotate_by
		end
	end
end

local ncwp = Node.collides_with_point
function Node:collides_with_point(point, ...)
	if self.config and self.config.center and self.config.center.fac_mf_rotate_by then
		self.VT.r = self.VT.r + self.config.center.fac_mf_rotate_by
	end

	local res = ncwp(self, point, ...)

	if self.config and self.config.center and self.config.center.fac_mf_rotate_by then
		self.VT.r = self.VT.r - self.config.center.fac_mf_rotate_by
	end

	return res
end

FishAndChips.Fish {
	key = "mf_spindown_plaice",
	atlas = "notmario_fish",
	pos = { x = 2, y = 1 },
	weight = 1,
	ppu_coder = { "notmario" },
	ppu_artist = { "notmario" },
	attributes = { "usable", "reset" },
	config = {
		extra = { available = true, }
	},
	pixel_size = { w = 71, h = 83 },
	environments = {
		city_river = 1.0,
		backroom = 0.2,
	},
	stats = {
		weight = {min = 0.08, max = 0.1},
		length = {min = 0.02, max = 0.03}
	},
	blueprint_compat = false,
	loc_vars = function(self, info_queue, card)
		return { vars = { ppu_bubbles = {card.ability.extra.available and 'usable' or 'used'} } }
	end,
    use = function(self, card, area, copier)
        local my_pos = nil
		for i = 1, #G.fac_fish_area.cards do
			if G.fac_fish_area.cards[i] == card then
				my_pos = i
				break
			end
		end
		if my_pos and G.fac_fish_area.cards[my_pos + 1] then
			local sliced_card = G.fac_fish_area.cards[my_pos + 1]
			local key = sliced_card.config.center.key

			local fih, old_fih

			for _, f in ipairs(G.P_CENTER_POOLS["fac_Fish"]) do
				if f.set == "fac_Fish" then
					old_fih = fih
					fih = f

					if fih.key == key then break end
				end
			end

			if not old_fih then old_fih = G.P_CENTERS["fish_fac_test"] end

			card.ability.extra.available = false

			play_sound("tarot1")
			sliced_card:juice_up(0.3, 0.5)
            sliced_card:set_ability(old_fih)
		end
    end,
	calculate = function(self, card, context)
		if context.end_of_round and context.cardarea == G.fac_fish_area and not context.blueprint and not card.ability.extra.available then
			card.ability.extra.available = true
			return {
				message = localize("k_reset"),
			}
		end
	end,
    can_use = function(self, card)
        local my_pos = nil
		for i = 1, #G.fac_fish_area.cards do
			if G.fac_fish_area.cards[i] == card then
				my_pos = i
				break
			end
		end
        return my_pos and G.fac_fish_area.cards[my_pos + 1] and card.ability.extra.available
    end,
	keep_on_use = function(card) return true end,
}

FishAndChips.Fish {
	key = "mf_junk_carp",
	atlas = "notmario_fish",
	pos = { x = 3, y = 1 },
	weight = 2,
	ppu_coder = { "notmario" },
	ppu_artist = { "notmario" },
	attributes = { "passive" },
	badge_key = "k_fac_maybe_fish",
	config = {
		extra = { xhand_amounts = 1.25 }
	},
	pixel_size = { w = 65, h = 95 },
	stats = {
		weight = {min = 8, max = 10},
		length = {min = 0.4, max = 0.70}
	},
	environments = {
		wormhole = 1.0,
		backroom = 0.2,
	},
	blueprint_compat = false,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.xhand_amounts, colours = { HEX("ff5e25") } } }
	end,
}

local nm_calc_ref = PotatoPatchUtils.Developers.fac_notmario.calculate
PotatoPatchUtils.Developers.fac_notmario.calculate = function(self, context)
    if context.evaluate_poker_hand then
        if next(SMODS.find_card("fish_fac_mf_junk_carp")) then
            local txt = "Junk"
            local replacement = txt .. " " .. context.display_name
            return {
                replace_display_name = replacement
            }
        end
    end
    -- return nm_calc_ref(self, context)
end

if Spectrallib and Spectrallib.ascend then
    local sasc = Spectrallib.ascend
    function Spectrallib.ascend(...)
        local cards = G.STATE == G.STATES.SELECTING_HAND and G.hand.highlighted or G.play.cards
		local mult = 1
		for _, card in ipairs(SMODS.find_card("fish_fac_mf_junk_carp")) do
			mult = mult * card.ability.extra.xhand_amounts
		end

        return sasc(...) * mult
    end
else
    local parse_highlighted = CardArea.parse_highlighted
    function CardArea:parse_highlighted(...)
        local text,disp_text,poker_hands,scoring = G.FUNCS.get_poker_hand_info(self.highlighted)
        local ret = parse_highlighted(self, ...)
        local backwards = nil
        for k, v in pairs(self.highlighted) do
            if v.facing == 'back' then
                backwards = true
            end
        end
        if backwards then return end
        if text and G.GAME.hands[text] then
            local junks = 0
			local mult = 1
			for _, card in ipairs(SMODS.find_card("fish_fac_mf_junk_carp")) do
				mult = mult * card.ability.extra.xhand_amounts
			end
            for name, parameter in pairs(SMODS.Scoring_Parameters) do
                if name == "chips" or name == "mult" then
                    parameter.current = parameter.current * mult
                    update_hand_text({immediate = true, nopulse = nil, delay = 0}, {[name] = parameter.current})
                end
            end
        end
        return ret
    end
end

local function choose_a_few(items, seed, count)
	local hands = SMODS.shallow_copy(items)
	local chosen_hands = {}
	for i = 1, count do
		if #hands == 0 then break end
		local hand = pseudorandom_element(hands, seed)
		chosen_hands[#chosen_hands + 1] = hand
		for i, v in ipairs(hands) do
			if v == hand then
				table.remove(hands, i)
				break
			end
		end
	end
	return chosen_hands
end

-- local function choose_a_few_hands(include_hidden, seed, count)
--     local hands = {}
--     for _,name in ipairs(G.handlist) do
--         if include_hidden or SMODS.is_poker_hand_visible(name) then
--             hands[#hands+1] = name
--         end
--     end

--     return choose_a_few(hands, seed, count)
-- end

-- FishAndChips.Fish {
-- 	key = "mf_saturn_fish",
-- 	atlas = "notmario_fish",
-- 	pos = { x = 4, y = 1 },
-- 	weight = 1,
-- 	ppu_coder = { "notmario" },
-- 	ppu_artist = { "notmario" },
-- 	attributes = { "hand_level", "on_sell", "space", },
-- 	config = {
-- 		extra = { levels = 3 }
-- 	},
-- 	pixel_size = { w = 61, h = 88 },
-- 	environments = {
-- 		wormhole = 1.0,
-- 		backroom = 0.2,
-- 	},
-- 	stats = {
-- 		weight = {min = 0.2, max = 1.0}, -- gas
-- 		length = {min = 0.50, max = 0.75}
-- 	},
-- 	blueprint_compat = true,
-- 	loc_vars = function(self, info_queue, card)
-- 		return { vars = { card.ability.extra.levels } }
-- 	end,
-- 	calculate = function(self, card, context)
-- 		if context.selling_self then
-- 			local hands = choose_a_few_hands(false, "saturn_fish", card.ability.extra.levels)
-- 			SMODS.upgrade_poker_hands{
-- 				hands = hands,
-- 				level_up = 1,
-- 				from = card,
-- 			}
-- 			return nil, true
-- 		end
-- 		if context.joker_type_destroyed and context.card == card then
-- 			local hands = choose_a_few_hands(false, "saturn_fish", card.ability.extra.levels)
-- 			SMODS.upgrade_poker_hands{
-- 				hands = hands,
-- 				level_up = 1,
-- 				from = card,
-- 			}
-- 			return nil, true
-- 		end
-- 	end,
-- }

FishAndChips.Fish {
	key = "mf_minifish",
	atlas = "notmario_fish",
	pos = { x = 0, y = 2 },
	weight = 1,
	ppu_coder = { "notmario" },
	ppu_artist = { "notmario" },
	attributes = { "rank", "two", "xblindsize", "chance" },
	config = {
		extra = { x_blind_size = 0.9, odds = 7 }
	},
	pixel_size = { w = 15, h = 15 },
	environments = {
		calm_pond = 1.0,
		styx = 0.01,
	},
	stats = {
		weight = {min = 0.1, max = 0.2},
		length = {min = 0.02, max = 0.02}
	},
	blueprint_compat = true,
	loc_vars = function(self, info_queue, card)
		local new_numerator, new_denominator =
			SMODS.get_probability_vars(card, 1, card.ability.extra.odds, "fac_mf_minifish")
		return { vars = { card.ability.extra.x_blind_size, new_numerator, new_denominator } }
	end,
	calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and context.other_card:get_id() == 2 then
            return {
				xblindsize = card.ability.extra.x_blind_size
			}
        end

		if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
			if SMODS.pseudorandom_probability(card, 'fac_mf_minifish', 1, card.ability.extra.odds) then
				SMODS.destroy_cards(card, nil, nil, true)
				return {
					message = localize('k_lost_ex'),
					colour = G.C.RED,
				}
			end
		end
	end,
}

SMODS.Atlas({
	key = "notmario_size_three", -- Please include your name/team name in your atlas keys
	path = "notmario/size_three.png",
	px = 140,
	py = 88,
})

-- FishAndChips.Fish {
-- 	key = "mf_size_three",
-- 	atlas = "notmario_size_three",
-- 	pos = { x = 0, y = 0 },
-- 	weight = 1,
-- 	ppu_coder = { "notmario" },
-- 	ppu_artist = { "notmario" },
-- 	attributes = { "eemult" },
-- 	config = {
-- 		extra = { }
-- 	},
-- 	display_size = { w = 140, h = 88 },
-- 	environments = {
-- 		styx = 1.0,
-- 		backroom = 0.2,
-- 	},
-- 	blueprint_compat = true,
-- 	loc_vars = function(self, info_queue, card)
-- 		return { vars = { } }
-- 	end,
-- 	calculate = function(self, card, context)
-- 		if context.initial_scoring_step then
-- 			if should_talisman_key("eemult") then
-- 				return {
-- 					eemult = 1.03,
-- 				}
-- 			else
-- 				return {
-- 					pre_func = function()
-- 						mult = mod_mult(mult ^ mult ^ 0.03)
-- 					end,
-- 					message = "^^1.04 Mult",
-- 					sound = "fac_notmario_emult",
-- 					colour = G.C.DARK_EDITION,
-- 				}
-- 			end
-- 		end
-- 	end,
-- }

FishAndChips.Fish {
	key = "mf_sap_fish",
	atlas = "notmario_fish",
	pos = { x = 1, y = 2 },
	weight = 2,
	ppu_coder = { "notmario" },
	ppu_artist = { "notmario" },
	attributes = { "hand_level", "chips", "mult", "modify_card", "perma_bonus", },
	config = {
		extra = { perma_chips = 3, perma_mult = 1, }
	},
	pixel_size = { w = 71, h = 59 },
	environments = {
		pier = 1.0,
		calm_pond = 0.1,
	},
	stats = {
		weight = {min = 5, max = 8},
		length = {min = 0.45, max = 0.85}
	},
	blueprint_compat = true,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.perma_chips, card.ability.extra.perma_mult } }
	end,
	calculate = function(self, card, context)
		if context.poker_hand_changed then
			if context.old_level and context.old_level ~= context.new_level then
				local eligible_fish = {}
				for _, other_card in ipairs(G.fac_fish_area.cards) do
					if other_card ~= card then eligible_fish[#eligible_fish + 1] = other_card end
				end
				local fishies = choose_a_few(eligible_fish, "super_auto_fish", 2)
				if #fishies > 0 then
					for _, fish in ipairs(fishies) do
						fish.ability.fac_mf_sap_chips = (fish.ability.fac_mf_sap_chips or 0) + card.ability.extra.perma_chips
						fish.ability.fac_mf_sap_mult = (fish.ability.fac_mf_sap_mult or 0) + card.ability.extra.perma_mult
					end
					return {
						message = localize "k_upgrade_ex",
						colour = FishAndChips.C.FISH
					}
				end
			end
		end
	end,
}

SMODS.Sound({
	key = "notmario_cardshock",
	path = "notmario/cardshock.ogg",
	pitch = 1.0,
})

FishAndChips.Fish {
	key = "mf_car_battery",
	atlas = "notmario_fish",
	pos = { x = 3, y = 2 },
	weight = 4,
	ppu_coder = { "notmario" },
	ppu_artist = { "notmario" },
	attributes = { "retrigger", "modify_card", "chance", "perma_bonus", },
	badge_key = "k_fac_mf_relic_qu",
	config = {
		extra = { odds = 7, }
	},
	pixel_size = { w = 71, h = 59 },
	environments = {
		pier = 1.0,
		city_river = 0.1,
	},
	stats = {
		weight = {min = 19, max = 20},
		length = {min = 0.40, max = 0.40}
	},
	disable_visual_scaling = true,
	blueprint_compat = true,
	loc_vars = function(self, info_queue, card)
		local new_numerator, new_denominator =
			SMODS.get_probability_vars(card, 1, card.ability.extra.odds, "fac_mf_car_battery")
		return { vars = { new_numerator, new_denominator } }
	end,
    use = function(self, card, area, copier)
		play_sound("fac_notmario_cardshock", 1.0, 1.0)
		for _, other_card in ipairs(G.fac_fish_area.cards) do
			other_card.ability.fac_mf_car_battery = other_card.ability.fac_mf_car_battery or {}
			other_card.ability.fac_mf_car_battery[#other_card.ability.fac_mf_car_battery + 1] = card.ability.extra.odds
			other_card:juice_up(0.3, 0.5)
		end
    end,
    can_use = function(self, card)
        return #G.fac_fish_area.cards >= 2 -- 2 because we want another target you know?
    end
}


SMODS.Atlas({
	key = "notmario_shellony", -- Please include your name/team name in your atlas keys
	path = "notmario/shellony.png",
	px = 128,
	py = 96,
})

PotatoPatchUtils.Bubble_Colours["mf_evil"] = G.C.RED

FishAndChips.Fish {
	key = "mf_flounder_felony",
	atlas = "notmario_shellony",
	pos = { x = 0, y = 0 },
	weight = 1,
	ppu_coder = { "notmario" },
	ppu_artist = { "notmario" },
	attributes = { "destroy_card", "full_deck", },
	config = {
		extra = { cards = 7, }
	},
	display_size = { w = 128 * 0.666, h = 96 * 0.666 },
	environments = {
		styx = 1.0,
		wormhole = 0.2,
		backroom = 0.2,
	},
	stats = {
		weight = {min = 6.7, max = 6.7},
		length = {min = 0.67, max = 0.67}
	},
	blueprint_compat = false,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.cards } }
	end,
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
				local cards = {}
				for i, v in pairs(G.playing_cards) do
					if not SMODS.is_eternal(v) then
						cards[#cards + 1] = v
					end
				end
				local num = card.ability.extra.cards
				pseudoshuffle(cards, "shellony")
				for i = 1, num do
					local card = cards[i]
					if card then
						card.area:remove_card(card)
						SMODS.destroy_cards(card)
					end
				end
                return true
            end
        }))
        delay(0.6)
    end,
    can_use = function(self, card)
        return true
    end
}

SMODS.Font({
	key = "notmario_emoji",
	path = "notmario/NotoEmoji-Bold.ttf",
})

SMODS.Sound({
	key = "notmario_abort_mission",
	path = "notmario/abort_mission.ogg",
	pitch = 1.0,
	volume = 0.5,
})

local abort_mission_amt = 0.

FishAndChips.Fish {
	key = "mf_inquisitive_fish",
	atlas = "notmario_fish",
	pos = { x = 3, y = 7 },
	weight = 1,
	ppu_coder = { "notmario" },
	ppu_artist = { "notmario" },
	attributes = { "chips", },
	config = {
		extra = { chips = 10, }
	},
	impulse_min = 0.01,
	impulse_max = 0.02,
	environments = {
		pier = 1.0,
		wormhole = 0.2,
	},
	pixel_size = {w = 65, h = 92},
	stats = {
		weight = {min = 3, max = 4},
		length = {min = 0.25, max = 0.35}
	},
	blueprint_compat = true,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.chips } }
	end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            return {
                chips = card.ability.extra.chips
            }
        end
    end,
	on_catch = function(self, card)
		delay(3.4)
		G.E_MANAGER:add_event(Event({
			trigger = 'after',
			delay = 0.4,
			func = function()
				play_sound('fac_notmario_abort_mission')
				abort_mission_amt = 0.5
				return true
			end
		}))
	end,
}

local get_area_for_center = FishAndChips.get_area_for_center
function FishAndChips.get_area_for_center(center, ...)
	if center.key == "fish_fac_mf_inquisitive_fish" then
		return G.consumeables
	end

	return get_area_for_center(center, ...)
end

local loveupdatehook = love.update
function love.update( dt, ... )
	loveupdatehook( dt, ...)
	abort_mission_amt = abort_mission_amt * (0.5 ^ dt)
end

local lovedrawhook = love.draw
function love.draw( ... )
    lovedrawhook( ... )

    if abort_mission_amt > 0.01 then
        local width, height = love.graphics.getDimensions()

        love.graphics.setColor(1,0,0.1,abort_mission_amt)
        love.graphics.rectangle("fill",0,0,width,height)
    end
end

FishAndChips.Fish {
	key = "mf_nerd_shark",
	atlas = "notmario_fish",
	pos = { x = 0, y = 6 },
	weight = 3,
	ppu_coder = { "notmario" },
	ppu_artist = { "notmario" },
	attributes = { "xchips", "mult", "scaling", "lose_economy", },
	config = {
		extra = { multiplier = 0.01 }
	},
	environments = {
		city_river = 1.0,
		wormhole = 0.2,
		backroom = 0.01,
		garden = 0.1,
	},
	stats = {
		weight = {min = 100, max = 200},
		length = {min = 2.4, max = 3.50}
	},
	pixel_size = {w = 70, h = 90},
	blueprint_compat = false,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.multiplier * 100, 1 + 15 * card.ability.extra.multiplier, colours = {
			G.C.JOKER_GREY,
			G.C.DYN_UI.DARK
		} } }
	end,
}

local ed = ease_dollars
ease_dollars = function(mod, instant, ...)
    if next(SMODS.find_card("fish_fac_mf_nerd_shark")) then
        mod = math.min(0, mod)
    end
	ed(mod, instant, ...)
end

local scalcieff = SMODS.calculate_individual_effect
SMODS.calculate_individual_effect = function(effect, scored_card, key, amount, from_edition)
    if next(SMODS.find_card("fish_fac_mf_nerd_shark")) then
        if key == "mult" or key == "h_mult" or key == "mult_mod" then
			local multiplier = 0
			for _, card in ipairs(SMODS.find_card("fish_fac_mf_nerd_shark")) do
				multiplier = multiplier + card.ability.extra.multiplier
			end
            if key == "mult_mod" then
                effect["mult_mod"] = nil
                effect["message"] = nil
            end
            amount = (1 + amount * multiplier)
            key = "xchips"
        end
    end
    return scalcieff(effect, scored_card, key, amount, from_edition)
end

FishAndChips.Fish {
	key = "mf_dandan",
	atlas = "notmario_fish",
	pos = { x = 1, y = 3 },
	weight = 4,
	ppu_coder = { "notmario" },
	ppu_artist = { "notmario" },
	attributes = { "xblindsize", },
	config = {
		extra = { xblindsize = 0.8 }
	},
	environments = {
		pier = 1.0,
	},
	stats = {
		weight = {min = 0.00165, max = 0.00182},
		length = {min = 0.088, max = 0.088}
	},
	cost = 2,
	blueprint_compat = true,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.xblindsize } }
	end,
	calculate = function(self, card, context)
		if context.setting_blind then
			return {
				xblindsize = card.ability.extra.xblindsize
			}
		end
		if context.fac_environment_changed and G.GAME.fac_fishing_environment ~= "pier" then
			SMODS.destroy_cards(card, nil, nil, true)
			return {
				message = localize('k_lost_ex'),
				colour = G.C.RED,
			}
		end
	end,
	on_catch = function(self, card)
		if FishAndChips.get_environment().key ~= "pier" then
			G.E_MANAGER:add_event(Event({
				func = function()
					G.E_MANAGER:add_event(Event({
						func = function()
							G.E_MANAGER:add_event(Event({
								func = function()
									-- do ts manually :drool
									FishAndChips:stop_ambience()
									local old_env = G.GAME.fac_fishing_environment
									G.GAME.fac_fishing_environment = "pier"
									SMODS.calculate_context{fac_environment_changed = G.GAME.fac_fishing_environment, old_environment = old_env, forced = true}
									if G.GAME.fac_next_environment then G.GAME.fac_next_environment = nil end
									G.FISHING_STATE = G.FISHING_STATES.MOVING
									G.FISHING_STATE_COMPLETE = false
									return true
								end
							}))
							return true
						end
					}))
					return true
				end
			}))
		end
	end,
	add_to_deck = function(self, card, from_debuff)
		if FishAndChips.get_environment().key ~= "pier" and not from_debuff then
			G.E_MANAGER:add_event(Event({
				func = function()
					G.E_MANAGER:add_event(Event({
						func = function()
							G.E_MANAGER:add_event(Event({
								func = function()
									-- do ts manually :drool
									FishAndChips:stop_ambience()
									local old_env = G.GAME.fac_fishing_environment
									G.GAME.fac_fishing_environment = "pier"
									SMODS.calculate_context{fac_environment_changed = G.GAME.fac_fishing_environment, old_environment = old_env, forced = true}
									if G.GAME.fac_next_environment then G.GAME.fac_next_environment = nil end
									G.FISHING_STATE = G.FISHING_STATES.MOVING
									G.FISHING_STATE_COMPLETE = false
									return true
								end
							}))
							return true
						end
					}))
					return true
				end
			}))
		end
	end,
}

FishAndChips.Fish {
	key = "mf_fish_fear_me",
	atlas = "notmario_fish",
	pos = { x = 3, y = 3 },
	weight = 9,
	ppu_coder = { "notmario" },
	ppu_artist = { "notmario" },
	attributes = { "passive", "editions", },
	badge_key = "k_fac_mf_relic_qu",
	config = {
		extra = {
		}
	},
	pixel_size = { w = 67, h = 56 },
	environments = {
		city_river = 1.0,
		pier = 0.1,
	},
	blueprint_compat = true,
	loc_vars = function(self, info_queue, card)
		return { vars = { } }
	end,
	stats = {
		weight = {min = 0.085, max = 0.113},
		length = {min = 0.10, max = 0.13}
	},
	calculate = function(self, card, context)
		if context.fac_modify_fishing_profile then
				-- context.fishing_profile.decision_min = context.fishing_profile.decision_min / 2.0
				-- context.fishing_profile.decision_max = context.fishing_profile.decision_max / 2.0

				context.fishing_profile.impulse_min = context.fishing_profile.impulse_min * 2.5
				context.fishing_profile.impulse_max = context.fishing_profile.impulse_max * 2.5

				context.fishing_profile.vel_limit = context.fishing_profile.vel_limit * 4.0
		end
		if context.fac_fish_caught then
			local edition = SMODS.poll_edition {
				no_negative = true,
				guaranteed = true,
				key = "fish_fear_me_cap",
			}
			context.fac_fish_caught:set_edition(edition)
		end
	end,
}

FishAndChips.Fish {
	key = "mf_fishion_reactor",
	atlas = "notmario_fish",
	pos = { x = 4, y = 3 },
	weight = 1,
	ppu_coder = { "notmario" },
	ppu_artist = { "notmario" },
	attributes = { "generation", "chance", "usable", "reset", "perma_bonus", },
	config = {
		extra = { destroy_odds = 3, available = true }
	},
	environments = {
		swamp = 1.0,
		styx = 0.1,
	},
	pixel_size = {w = 66, h = 77},
	stats = {
		weight = {min = 8500, max = 10000},
		length = {min = 2.20, max = 2.20}
	},
	disable_visual_scaling = true,
	blueprint_compat = false,
	badge_key = "k_fac_mf_relic_qu",
	loc_vars = function(self, info_queue, card)
		local new_numerator, new_denominator =
			SMODS.get_probability_vars(card, 1, card.ability.extra.destroy_odds, "fac_mf_fishion_reactor")
		return { vars = { new_numerator, new_denominator, ppu_bubbles = {card.ability.extra.available and 'usable' or 'used'} } }
	end,
    use = function(self, card, area, copier)
        local my_pos = nil
		for i = 1, #G.fac_fish_area.cards do
			if G.fac_fish_area.cards[i] == card then
				my_pos = i
				break
			end
		end
		if my_pos and G.fac_fish_area.cards[my_pos + 1] then
			card.ability.extra.available = false
			local sliced_card = G.fac_fish_area.cards[my_pos + 1]

			sliced_card.ability.fac_mf_fishion_reactor = sliced_card.ability.fac_mf_fishion_reactor or {}
			sliced_card.ability.fac_mf_fishion_reactor[#sliced_card.ability.fac_mf_fishion_reactor + 1] = card.ability.extra.destroy_odds

			G.E_MANAGER:add_event(Event({
				trigger = 'before',
				delay = 0.4,
				func = function()
					local copied_joker = SMODS.copy_card(sliced_card)
                	play_sound('timpani', 0.75)
                	play_sound('timpani', 0.6)
                	play_sound('timpani', 0.3)
                	play_sound('fac_notmario_cardshock', 0.3)
					local scale_add = 0.8 + pseudorandom("fac_mf_fishion_rescale") * 0.4
					local round_ts = function(value)
						return tonumber(string.format(value < 100 and "%.2f" or "%.d", value))
					end
					copied_joker.ability.stats.weight = round_ts(copied_joker.ability.stats.weight * scale_add) -- ts cubic and such
					copied_joker.ability.stats.length = round_ts(copied_joker.ability.stats.length * scale_add)
					sliced_card.ability.stats.weight = round_ts(sliced_card.ability.stats.weight / scale_add)
					sliced_card.ability.stats.length = round_ts(sliced_card.ability.stats.length / scale_add)
					if not FishAndChips.mod.config.disable_fish_scaling and not G.P_CENTERS[sliced_card.config.center.key].disable_visual_scaling then
					    copied_joker.T.scale = copied_joker.T.scale * scale_add
						sliced_card.T.scale = sliced_card.T.scale / scale_add
					end
					copied_joker:juice_up(1.0, 1.0)
					sliced_card:juice_up(1.0, 1.0)
					copied_joker:start_materialize()
					return true
				end
			}))
		end
    end,
	calculate = function(self, card, context)
		if context.end_of_round and context.cardarea == G.fac_fish_area and not context.blueprint and not card.ability.extra.available then
			card.ability.extra.available = true
			return {
				message = localize("k_reset"),
			}
		end
	end,
    can_use = function(self, card)
        local my_pos = nil
		for i = 1, #G.fac_fish_area.cards do
			if G.fac_fish_area.cards[i] == card then
				my_pos = i
				break
			end
		end
        return my_pos and G.fac_fish_area.cards[my_pos + 1] and card.ability.extra.available
    end,
	keep_on_use = function(card) return true end,
}

FishAndChips.Fish {
	key = "mf_baneslayer_angelfish",
	atlas = "notmario_fish",
	pos = { x = 2, y = 4 },
	weight = 5,
	ppu_coder = { "notmario" },
	ppu_artist = { "notmario" },
	attributes = { "chips", "mult", },
	config = {
		extra = { chips = 7, }
	},
	environments = {
		garden = 1.0,
		aquifer = 0.1,
	},
	badge_key = "k_fac_mf_angelfish",
	pixel_size = {w = 67, h = 70},
	blueprint_compat = true,
	loc_vars = function(self, info_queue, card)
		return {
			vars = { card.ability.extra.chips }
		}
	end,
	stats = {
		weight = {min = 1.3, max = 2.0},
		length = {min = 0.3, max = 0.45}
	},
	calculate = function(self, card, context)
		if context.initial_scoring_step then
			return {
				chips = card.ability.extra.chips
			}
		end
		if context.post_trigger and (context.blueprint_card or card) == context.other_card then
			local new_mults = {}
			local ret = context.other_ret.jokers
			while ret do
				if ret.chips then
					new_mults[#new_mults + 1] = {
						mult = ret.chips
					}
				end
				ret = ret.extra
			end
			return SMODS.merge_effects(new_mults)
		end
	end,
}

local card_flip = Card.flip
function Card:flip(...)
    if self.facing == 'back' or self.config.center.key ~= "fish_fac_mf_baneslayer_angelfish" then
        card_flip(self, ...)
    end
end

local old_set_debuff = FishAndChips.mod.set_debuff
FishAndChips.mod.set_debuff = function(card, ...)
	if card.config.center.key == "fish_fac_mf_baneslayer_angelfish" then
		return "prevent_debuff"
	end
	if old_set_debuff then return
		old_set_debuff(card, ...)
	end
end

FishAndChips.Fish {
	key = "mf_perchance",
	atlas = "notmario_fish",
	pos = { x = 0, y = 4 },
	weight = 4,
	ppu_coder = { "notmario" },
	ppu_artist = { "notmario" },
	attributes = { "mod_chance", "passive", "reset", "scaling", },
	config = {
		extra = { mod_chance = 1, mod_mod_chance = 1, }
	},
	environments = {
		city_river = 1.0,
		wormhole = 0.1,
		aquifer = 0.1,
	},
	pixel_size = {w = 61, h = 63},
	stats = {
		weight = {min = 1.30, max = 2.5},
		length = {min = 0.20, max = 0.4}
	},
	blueprint_compat = false,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mod_chance, 2 + card.ability.extra.mod_chance, card.ability.extra.mod_mod_chance }}
	end,
	calculate = function(self, card, context)
		if context.mod_probability and not context.blueprint then
			local new_denominator = context.denominator
			if context.denominator >= 1 and context.denominator < 1 + card.ability.extra.mod_chance then
				new_denominator = 1
			elseif context.denominator >= 2 then
				new_denominator = new_denominator - card.ability.extra.mod_chance
			end
			return {
				denominator = new_denominator,
			}
		end
		if context.pseudorandom_result and not context.blueprint then
			if context.result then
				card.ability.mod_chance = card.ability.mod_mod_chance
				return {
					message = localize "k_reset",
					colour = G.C.RED
				}
			else
				SMODS.scale_card(card, {
					ref_table = card.ability.extra,
					ref_value = "mod_chance",
					scalar_value = "mod_mod_chance",
					-- message_key = "a_xmult",
					message_colour = G.C.GREEN,
				})
				return nil, true
			end
		end
	end,
}

FishAndChips.Fish {
	key = "mf_narwall",
	atlas = "notmario_fish",
	pos = { x = 1, y = 4 },
	weight = 3,
	ppu_coder = { "notmario" },
	ppu_artist = { "notmario" },
	attributes = { "passive", "economy", "boss_blind", },
	config = {
		extra = { }
	},
	environments = {
		wormhole = 1.0,
		aquifer = 0.5,
	},
	pixel_size = {w = 63, h = 93},
	stats = {
		weight = {min = 800, max = 1600},
		length = {min = 3.5, max = 4.0}
	},
	blueprint_compat = false,
	loc_vars = function(self, info_queue, card)
		return { vars = {} }
	end,
	add_to_deck = function(self, card, from_debuff)
		G.E_MANAGER:add_event(Event({
			func = function()
				G.from_boss_tag = true
				G.FUNCS.reroll_boss()
				return true
			end,
		}))
	end,
	remove_from_deck = function(self, card, from_debuff)
		G.E_MANAGER:add_event(Event({
			func = function()
				G.from_boss_tag = true
				G.FUNCS.reroll_boss()
				return true
			end,
		}))
	end,
}

local smods_get_new_blind = SMODS.get_new_blind
function SMODS.get_new_blind(blind_type, ...)
	local ret = smods_get_new_blind(blind_type, ...)
	if G.P_BLINDS[ret].boss and not G.P_BLINDS[ret].boss.showdown and next(SMODS.find_card("fish_fac_mf_narwall")) then
		return "bl_wall"
	end
	return ret
end

local old_get_new_boss = get_new_boss
function get_new_boss(...)
	local ret = old_get_new_boss(...)
	if G.P_BLINDS[ret].boss and not G.P_BLINDS[ret].boss.showdown and next(SMODS.find_card("fish_fac_mf_narwall")) then
		return "bl_wall"
	end
	return ret
end

-- scrapped for being too boring

-- FishAndChips.Fish {
-- 	key = "mf_uncommon_cod",
-- 	atlas = "notmario_fish",
-- 	pos = { x = 0, y = 5 },
-- 	weight = 1,
-- 	ppu_coder = { "notmario" },
-- 	ppu_artist = { "notmario" },
-- 	attributes = { "xchips", },
-- 	config = {
-- 		extra = {
-- 			xchips = 1.2
-- 		}
-- 	},
-- 	environments = {
-- 		pier = 10,
-- 		city_river = 2.5
-- 	},
-- 	blueprint_compat = true,
-- 	loc_vars = function(self, info_queue, card)
-- 		return { vars = { card.ability.extra.xchips } }
-- 	end,
-- 	calculate = function(self, card, context)
-- 		if context.joker_main then
-- 			return {
-- 				xchips = card.ability.extra.xchips
-- 			}
-- 		end
-- 	end,
-- }

FishAndChips.Fish {
	key = "mf_frying_fish",
	atlas = "notmario_fish",
	pos = { x = 1, y = 5 },
	weight = 4,
	ppu_coder = { "notmario" },
	ppu_artist = { "notmario" },
	attributes = { "generation", "modify_card", "joker", "retrigger", "perma_bonus", },
	config = {
		extra = {}
	},
	environments = {
		soup = 1.0,
		chocolate_river = 0.1,
	},
	stats = {
		weight = {min = 0.5, max = 1.58},
		length = {min = 0.20, max = 0.35}
	},
	blueprint_compat = false,
	pixel_size = {w = 71, h = 72},
	requires_jokers = true,
	loc_vars = function(self, info_queue, card)
		return { vars = { } }
	end,
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('timpani')
                local food = SMODS.add_card({ set = 'Joker', attributes = {"food"}, key_append = "frying_fish" })
				food.ability.fac_mf_frying_fish = 1
                card:juice_up(0.3, 0.5)
                return true
            end
        }))
        delay(0.6)
    end,
    can_use = function(self, card)
        return G.jokers and #G.jokers.cards < G.jokers.config.card_limit
    end
}

FishAndChips.Fish {
	key = "mf_dominnows",
	atlas = "notmario_fish",
	pos = { x = 2, y = 5 },
	weight = 2,
	ppu_coder = { "notmario" },
	ppu_artist = { "notmario" },
	attributes = { "balance", "rank", "reset", },
	config = {
		extra = {
			percent_swap = 0.2,
			rank_one = 'Ace',
			rank_two = '6',
		}
	},
	environments = {
		city_river = 1.0,
		chocolate_river = 0.1,
	},
	stats = {
		weight = {min = 0.20, max = 0.50},
		length = {min = 0.05, max = 0.10}
	},
	blueprint_compat = false,
	pixel_size = {w = 64, h = 78},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.percent_swap * 100, localize(card.ability.extra.rank_one, 'ranks'), localize(card.ability.extra.rank_two, 'ranks') } }
	end,
	set_ability = function(self, card, initial, delay_sprites)
		local ranks = choose_a_few(SMODS.Rank.obj_buffer, "dominnows", 2)
		card.ability.extra.rank_one = ranks[1]
		card.ability.extra.rank_two = ranks[2]
	end,
	calculate = function(self, card, context)
		if context.end_of_round and context.cardarea == G.fac_fish_area and not context.blueprint then
			local ranks = choose_a_few(SMODS.Rank.obj_buffer, "dominnows", 2)
			card.ability.extra.rank_one = ranks[1]
			card.ability.extra.rank_two = ranks[2]
			return {
				message = localize("k_reset"),
			}
		end
		if context.joker_main then
			local has_rank_one = false
			local has_rank_two = false
			local id_one = SMODS.Ranks[card.ability.extra.rank_one].id
			local id_two = SMODS.Ranks[card.ability.extra.rank_two].id
			for _, other_card in ipairs(context.full_hand) do
				if other_card:get_id() == id_one then has_rank_one = true end
				if other_card:get_id() == id_two then has_rank_two = true end
			end
			if not has_rank_one or not has_rank_two then

			elseif has_calc_key("cry_broken_swap") then
				return {
					cry_broken_swap = extra.percent_swap
				}
			else
				return {
					message = localize "k_balanced_qu",
					colour = G.C.PURPLE,
					pre_func = function()
						juice_card(card)
						local chips = SMODS.Scoring_Parameters.chips
						local mult = SMODS.Scoring_Parameters.mult
						local chip_mod = chips.current * card.ability.extra.percent_swap
						local mult_mod = mult.current * card.ability.extra.percent_swap

						-- modifications are done in two steps to avoid rounding errors with larger bignums setting values to 0
						chips.current = chips.current * (1 - card.ability.extra.percent_swap)
						chips:modify(mult_mod)
						mult.current = mult.current * (1 - card.ability.extra.percent_swap)
						mult:modify(chip_mod)

						G.E_MANAGER:add_event(Event({
							func = (function()
								-- scored_card:juice_up()
								play_sound('gong', 0.6, 0.3)
								play_sound('gong', 0.6*1.5, 0.2)
								play_sound('tarot1', 1.5)
								ease_colour(G.C.UI_CHIPS, {0.8, 0.45, 0.85, 1})
								ease_colour(G.C.UI_MULT, {0.8, 0.45, 0.85, 1})
								G.E_MANAGER:add_event(Event({
									trigger = 'after',
									blockable = false,
									blocking = false,
									delay =  0.8,
									func = (function()
										ease_colour(G.C.UI_CHIPS, G.C.BLUE, 0.8)
										ease_colour(G.C.UI_MULT, G.C.RED, 0.8)
										return true
									end)
								}))
								G.E_MANAGER:add_event(Event({
									trigger = 'after',
									blockable = false,
									blocking = false,
									no_delete = true,
									delay =  1.3,
									func = (function()
										G.C.UI_CHIPS[1], G.C.UI_CHIPS[2], G.C.UI_CHIPS[3], G.C.UI_CHIPS[4] = G.C.BLUE[1], G.C.BLUE[2], G.C.BLUE[3], G.C.BLUE[4]
										G.C.UI_MULT[1], G.C.UI_MULT[2], G.C.UI_MULT[3], G.C.UI_MULT[4] = G.C.RED[1], G.C.RED[2], G.C.RED[3], G.C.RED[4]
										return true
									end)
								}))
								return true
							end)
						}))
					end
				}
			end
		end
	end,
}

FishAndChips.Fish {
	key = "mf_really_long_name_copper_stairs",
	atlas = "notmario_fish",
	pos = { x = 3, y = 5 },
	weight = 5,
	ppu_coder = { "notmario" },
	ppu_artist = { "notmario" },
	attributes = { "passive", "reset", },
	config = {
		extra = {
			scaling_mod = 3,
		}
	},
	badge_key = "k_fac_mf_block",
	environments = {
		aquifer = 1.0,
		wormhole = 0.1,
	},
	stats = {
		weight = {min = 6960, max = 6980},
		length = {min = 1.00, max = 1.00}
	},
	blueprint_compat = false,
	pixel_size = {w = 71, h = 79},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.scaling_mod, localize(card.ability.extra.preventing_scaling and "k_preventing" or "k_not_preventing") } }
	end,
	calculate = function(self, card, context)
		if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
			card.ability.extra.preventing_scaling = false
			return {
				message = localize('k_reset'),
				colour = mix_colours(G.C.GREEN, G.C.FILTER, 0.7),
			}
		end
		if context.scaling_card then
		    card.ability.extra.preventing_scaling = true
    		if context.operation == "X" then
    			return {
    				override_scalar_value = { value = context.scalar ^ card.ability.extra.scaling_mod },
    			}
    		else
    			return {
    				override_scalar_value = { value = context.scalar * card.ability.extra.scaling_mod },
    			}
    		end
		end
	end,
	-- calc_scaling = function(self, _self, card, initial, scalar_value, args)
		-- if args.operation == "X" then
		-- 	_self.ability.extra.preventing_scaling = true
		-- 	return {
		-- 		override_scalar_value = { value = scalar_value ^ _self.ability.extra.scaling_mod },
		-- 	}
		-- else
		-- 	_self.ability.extra.preventing_scaling = true
		-- 	return {
		-- 		override_scalar_value = { value = scalar_value * _self.ability.extra.scaling_mod },
		-- 	}
		-- end
	-- end,
}

local ssc = SMODS.scale_card
function SMODS.scale_card(card, ...)
	local should_prevent = false
	-- Im probably like really stupid but whatever
	for _, card in ipairs(SMODS.find_card("fish_fac_mf_really_long_name_copper_stairs")) do
		if card.ability.extra.preventing_scaling then
			should_prevent = true
		end
	end
	if should_prevent then return nil end
    return ssc(card, ...)
end

FishAndChips.Fish {
	key = "mf_the_sole",
	atlas = "notmario_fish",
	pos = { x = 4, y = 5 },
	weight = 1,
	ppu_coder = { "notmario" },
	ppu_artist = { "notmario" },
	attributes = { "usable", "generation", "rarity", "chance", "perma_bonus", },
	config = {
		extra = {
			odds = 6,
		}
	},
	badge_key = "k_fac_mf_relic_qu",
	environments = {
		city_river = 1.0,
		pier = 0.1,
	},
	stats = {
		weight = {min = 0.21, max = 0.30},
		length = {min = 0.21, max = 0.30}
	},
	blueprint_compat = false,
	pixel_size = {w = 60, h = 78},
	loc_vars = function(self, info_queue, card)
		local new_numerator, new_denominator =
			SMODS.get_probability_vars(card, 1, card.ability.extra.odds, "fac_mf_the_sole")
		return { vars = { new_numerator, new_denominator } }
	end,
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('timpani')
                local food = SMODS.add_card({ set = 'Joker', rarity = "Legendary", key_append = "the_sole" })
				food.ability.fac_mf_the_sole = { card.ability.extra.odds }
                card:juice_up(0.3, 0.5)
                return true
            end
        }))
        delay(0.6)
    end,
    can_use = function(self, card)
        return G.jokers and #G.jokers.cards < G.jokers.config.card_limit
    end
}

-- FishAndChips.Fish {
-- 	key = "mf_glistening_oilfish",
-- 	atlas = "notmario_fish",
-- 	pos = { x = 0, y = 0 },
-- 	weight = 1,
-- 	ppu_coder = { "notmario" },
-- 	ppu_artist = { "notmario" },
-- 	attributes = { },
-- 	config = {
-- 		extra = {
-- 			toxic_val = 10,
-- 		}
-- 	},
-- 	environments = {
-- 		swamp = 1.0,
-- 	},
-- 	stats = {
-- 		weight = {min = 10.0, max = 15.0},
-- 		length = {min = 0.9, max = 1.4}
-- 	},
-- 	blueprint_compat = false,
-- 	pixel_size = {w = 62, h = 69},
-- 	loc_vars = function(self, info_queue, card)
-- 		return { vars = { card.ability.extra.toxic_val, colours = {
-- 			darken(G.C.GREEN, 0.2)
-- 		} } }
-- 	end,
-- 	calculate = function(self, card, context)
-- 	end,
-- 	fac_mf_add_multibox = function(_c, info_queue, other_card, desc_nodes, specific_vars, full_UI_table, ability, card, ...)
-- 		-- find actual card with evil evil evil eeeevil hack
-- 		local _other_card = nil
-- 		for _, _card in ipairs(G.fac_fish_area.cards) do
-- 			if ability == _card.ability then
-- 				_other_card = _card
-- 			end
-- 		end
-- 		if _other_card and _other_card.area == G.fac_fish_area then
-- 			local other_joker = nil
-- 			for i = 1, #G.fac_fish_area.cards do
-- 				if G.fac_fish_area.cards[i] == card then other_joker = G.fac_fish_area.cards[i + 1] end
-- 			end
-- 			if other_joker == _other_card then
-- 				local desc_text = G.localization.descriptions.Other.fac_mf_toxic.text
-- 				PotatoPatchUtils.Developers.fac_notmario.generate_ui_multiboxes({
-- 					{
-- 						localized_text = desc_text,
-- 						loc_vars = function(self, card, center)
-- 							return { vars = { card.ability.extra.toxic_val, colours = {
-- 								darken(G.C.GREEN, 0.2)
-- 							} } }
-- 						end
-- 					}
-- 				})(_c, info_queue, other_card, desc_nodes, specific_vars, full_UI_table)
-- 			end
-- 		end
-- 	end,
-- 	fac_mf_add_extra_effect = function(other_card, context, jokers, triggered, card)
-- 		return jokers, triggered
-- 	end
-- }

FishAndChips.Fish {
	key = "mf_number_gem",
	atlas = "notmario_fish",
	pos = { x = 4, y = 7 },
	weight = 1,
	ppu_coder = { "notmario" },
	ppu_artist = { "notmario" },
	attributes = { "economy", "usable", },
	config = {
		extra = {
		    per_digit = 2,
			cap = 67,
		}
	},
	badge_key = "k_fac_mf_relic",
	environments = {
	    wormhole = 1.0,
		city_river = 0.3,
	},
	stats = {
		weight = {min = 10.0, max = 15.0},
		length = {min = 0.5, max = 0.6}
	},
	blueprint_compat = false,
	pixel_size = {w = 53, h = 61},
	display_size = { w = 53 * 1.25, h = 61 * 1.25 },
	loc_vars = function(self, info_queue, card)
	    return { vars = { card.ability.extra.per_digit, card.ability.extra.cap } }
	end,
	use = function(self, card, area, copier)
        local round = (G.GAME.round or 0)
        local times = 10^(math.floor(math.log10(round)) + 1)
        if concat == 0 then times = 10 end

        local dollars = (math.floor(math.log10(round)) + 1) * 2
        if round == 0 then dollars = 1 end
        if round == inf or dollars > 308 then dollars = 308 end

        ease_round(round * times)
        ease_dollars(math.min(dollars * card.ability.extra.per_digit, card.ability.extra.cap))
    end,
    can_use = function(self, card)
        return true
    end
}

FishAndChips.Fish {
	key = "mf_treasure_chest",
	atlas = "notmario_fish",
	pos = { x = 0, y = 8 },
	weight = 5,
	ppu_coder = { "notmario" },
	ppu_artist = { "notmario" },
	attributes = { "economy", "generation", "usable", },
	config = {
		extra = {
		    money = 4,
			available = true,
		}
	},
	badge_key = "k_fac_mf_relic",
	environments = {
	    pier = 1.0,
		swamp = 0.1,
		volcano = 0.1,
	},
	stats = {
		weight = {min = 250.0, max = 300.0},
		length = {min = 0.8, max = 0.9}
	},
	treasure = true,
	blueprint_compat = false,
	pixel_size = {w = 71, h = 78},
	loc_vars = function(self, info_queue, card)
	    return { vars = { card.ability.extra.money, ppu_bubbles = {card.ability.extra.available and 'usable' or 'used'} } }
	end,
	calculate = function(self, card, context)
		if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint and G.GAME.blind.boss then
			card.ability.extra.available = true
			return {
				message = localize('k_reset'),
			}
		end
	end,
	use = function(self, card, area, copier)
	    card.ability.extra.available = false
	    if #G.fac_fish_area.cards < G.fac_fish_area.config.card_limit then
    		G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.4,
                func = function()
                    play_sound('timpani')
                    local food = SMODS.add_card({ set = 'fac_Fish', type = 'fac_Fish', attributes = {'fac_mf_pearl'}, key_append = "chest", filter = function(pool)
                        local new_pool = {}
						for k, v in pairs(pool) do
							if v.key ~= "fish_fac_mf_red_herring" then
								table.insert(new_pool, v)
							end
						end
						if #new_pool == 0 then return pool end
						return new_pool
                    end })
                    card:juice_up(0.3, 0.5)
                    return true
                end
            }))
            delay(0.6)
        else
            ease_dollars(card.ability.extra.money)
		end
    end,
    can_use = function(self, card)
        return card.ability.extra.available
    end,
    keep_on_use = function(card) return true end
}

SMODS.Attribute {
    key = "fac_mf_pearl",
    -- todo : add a loc thing :p -- I did this (mf) -- Woah who's that (mf) -- Hiiiii (mf)
}

FishAndChips.Fish {
	key = "mf_red_pearl",
	atlas = "notmario_fish",
	pos = { x = 3, y = 6 },
	weight = 1,
	ppu_coder = { "notmario" },
	ppu_artist = { "notmario" },
	attributes = { "usable", "mult", "modify_card", "fac_mf_pearl" },
	config = { extra = { base_highlighted = 0, mult_bonus = 5, money_earned = 0, money_per = 8 } },
	badge_key = "k_fac_mf_pearl",
	environments = {
	    pier = 1.0,
	},
	stats = {
		weight = {min = 0.02, max = 0.06},
		length = {min = 0.0012, max = 0.021}
	},
	requires_hand = true,
	blueprint_compat = false,
	pixel_size = {w = 39, h = 39},
	loc_vars = function(self, info_queue, card)
	    return { vars = { card.ability.extra.base_highlighted, card.ability.extra.mult_bonus, card.ability.extra.money_per, card.ability.extra.money_earned,
			card.ability.extra.base_highlighted + math.floor( card.ability.extra.money_earned / card.ability.extra.money_per ) } }
	end,
	calculate = function(self, card, context)
        if context.money_altered and context.amount > 0 then
            card.ability.extra.money_earned = card.ability.extra.money_earned + context.amount
        end
    end,
    use = function(self, card, area, copier)
        for i = 1, #G.hand.highlighted do
            o_card = G.hand.highlighted[i]
            o_card.ability.perma_mult = (o_card.ability.perma_mult or 0) + card.ability.extra.mult_bonus
            local percent = 0.85 + (i - 0.999) / (#G.hand.highlighted - 0.998) * 0.25
            G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.15,
            func = function()
                play_sound('multhit1', percent, 0.6); G.hand.highlighted[i]
                :juice_up(
                    0.3, 0.3); return true
            end
            }))
        end
    end,
    can_use = function(self, card)
        return #G.hand.highlighted ~= 0 and #G.hand.highlighted <= card.ability.extra.base_highlighted + math.floor( card.ability.extra.money_earned / card.ability.extra.money_per )
    end
}

FishAndChips.Fish {
	key = "mf_blue_pearl",
	atlas = "notmario_fish",
	pos = { x = 4, y = 6 },
	weight = 1,
	ppu_coder = { "notmario" },
	ppu_artist = { "notmario" },
	attributes = { "usable", "modify_card", "enhancements", "fac_mf_pearl" },
	config = { extra = { base_highlighted = 0, money_earned = 0, money_per = 10 } },
	badge_key = "k_fac_mf_pearl",
	environments = {
	    pier = 1.0,
	},
	stats = {
		weight = {min = 0.02, max = 0.06},
		length = {min = 0.0012, max = 0.021}
	},
	requires_hand = true,
	blueprint_compat = false,
	pixel_size = {w = 39, h = 39},
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.base_highlighted, card.ability.extra.money_per, card.ability.extra.money_earned,
            card.ability.extra.base_highlighted + math.floor( card.ability.extra.money_earned / card.ability.extra.money_per ) } }
    end,
    calculate = function(self, card, context)
        if context.money_altered and context.amount < 0 then
            card.ability.extra.money_earned = card.ability.extra.money_earned - context.amount

            if math.floor(card.ability.extra.money_earned / card.ability.extra.money_per) > math.floor((card.ability.extra.money_earned - context.amount) / card.ability.extra.money_per) then
                return {
                    message = localize("k_upgrade_ex")
                }
            end
        end
    end,
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('tarot1')
                card:juice_up(0.3, 0.5)
                return true
            end
        }))
        for i = 1, #G.hand.highlighted do
            local percent = 1.15 - (i - 0.999) / (#G.hand.highlighted - 0.998) * 0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                    G.hand.highlighted[i]:flip()
                    play_sound('card1', percent)
                    G.hand.highlighted[i]:juice_up(0.3, 0.3)
                    return true
                end
            }))
        end
        delay(0.2)
        for i = 1, #G.hand.highlighted do
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.1,
                func = function()
                    G.hand.highlighted[i]:set_ability("m_wild")
                    return true
                end
            }))
        end
        for i = 1, #G.hand.highlighted do
            local percent = 0.85 + (i - 0.999) / (#G.hand.highlighted - 0.998) * 0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                    G.hand.highlighted[i]:flip()
                    play_sound('tarot2', percent, 0.6)
                    G.hand.highlighted[i]:juice_up(0.3, 0.3)
                    return true
                end
            }))
        end
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.2,
            func = function()
                G.hand:unhighlight_all()
                return true
            end
        }))
        delay(0.5)
    end,
    can_use = function(self, card)
        return #G.hand.highlighted ~= 0 and #G.hand.highlighted <= card.ability.extra.base_highlighted + math.floor( card.ability.extra.money_earned / card.ability.extra.money_per )
    end
}

FishAndChips.Fish {
	key = "mf_green_pearl",
	atlas = "notmario_fish",
	pos = { x = 0, y = 7 },
	weight = 1,
	ppu_coder = { "notmario" },
	ppu_artist = { "notmario" },
	attributes = { "usable", "reroll", "on_sell", "fac_mf_pearl" },
	config = { extra = { base_rerolls = 0, sells_per = 2, my_sells = 0, } },
	badge_key = "k_fac_mf_pearl",
	environments = {
	    pier = 1.0,
	},
	stats = {
		weight = {min = 0.02, max = 0.06},
		length = {min = 0.0012, max = 0.021}
	},
	blueprint_compat = false,
	pixel_size = {w = 39, h = 39},
	loc_vars = function(self, info_queue, card)
	    return { vars = { card.ability.extra.base_rerolls, card.ability.extra.sells_per, card.ability.extra.my_sells, math.floor(card.ability.extra.my_sells / card.ability.extra.sells_per), } }
	end,
	calculate = function(self, card, context)
	    if context.selling_card and context.card ~= card then
            card.ability.extra.my_sells = card.ability.extra.my_sells + 1
            if math.floor(card.ability.extra.my_sells / card.ability.extra.sells_per) > math.floor((card.ability.extra.my_sells - 1) / card.ability.extra.sells_per) then
                return {
                    message = localize("k_upgrade_ex")
                }
            end
        end
    end,
    use = function(self, card, area, copier)
        if card.ability.extra.base_rerolls + math.floor(card.ability.extra.my_sells / card.ability.extra.sells_per) > 0 then
            G.GAME.current_round.free_rerolls = math.max(G.GAME.current_round.free_rerolls +
                card.ability.extra.base_rerolls + math.floor(card.ability.extra.my_sells / card.ability.extra.sells_per), 0)
            calculate_reroll_cost(true)
        end
    end,
    can_use = function(self, card)
        return G.shop and (card.ability.extra.base_rerolls + math.floor(card.ability.extra.my_sells / card.ability.extra.sells_per)) > 0
    end
}

FishAndChips.Fish {
	key = "mf_gold_pearl",
	atlas = "notmario_fish",
	pos = { x = 1, y = 7 },
	weight = 1,
	ppu_coder = { "notmario" },
	ppu_artist = { "notmario" },
	attributes = { "usable", "chance", "modify_card", "joker", "fac_mf_pearl" },
	config = { extra = { numerator = 17, denominator = 1, increase_denominator = 1, } },
	badge_key = "k_fac_mf_pearl",
	environments = {
	    pier = 1.0,
	},
	stats = {
		weight = {min = 0.02, max = 0.06},
		length = {min = 0.0012, max = 0.021}
	},
	requires_jokers = true,
	blueprint_compat = false,
	pixel_size = {w = 39, h = 39},
	loc_vars = function(self, info_queue, card)
    	local new_numerator, new_denominator =
    		SMODS.get_probability_vars(card, card.ability.extra.numerator, card.ability.extra.denominator, "fac_mf_gold_pearl")
	    return { vars = { new_numerator, new_denominator, card.ability.extra.increase_denominator, } }
	end,
	calculate = function(self, card, context)
	    if context.before then
			if #context.scoring_hand < #context.full_hand then
                card.ability.extra.denominator = card.ability.extra.denominator + card.ability.extra.increase_denominator * (#context.full_hand - #context.scoring_hand)
			    return {
					message = localize "k_upgrade_ex"
				}
			end
		end
    end,
    use = function(self, card, area, copier)
        for _, other_card in ipairs(G.jokers.cards) do
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.2,
                func = function()
                    play_sound('timpani')
         			other_card.ability.fac_mf_gold_pearl = other_card.ability.fac_mf_gold_pearl or {}
         			other_card.ability.fac_mf_gold_pearl[#other_card.ability.fac_mf_gold_pearl + 1] = {
                        card.ability.extra.numerator, card.ability.extra.denominator
                    }
         			other_card:juice_up(0.3, 0.5)
                    return true
                end
            }))
  		end
    end,
    can_use = function(self, card)
        return #G.jokers.cards >= 1
    end
}

FishAndChips.Fish {
	key = "mf_black_pearl",
	atlas = "notmario_fish",
	pos = { x = 2, y = 7 },
	weight = 1,
	ppu_coder = { "notmario" },
	ppu_artist = { "notmario" },
	attributes = { "usable", "destroy_card", "discard", "fac_mf_pearl" },
	config = { extra = { base_highlighted = 0, discards_per = 17, my_discards = 0, } },
	badge_key = "k_fac_mf_pearl",
	environments = {
	    pier = 1.0,
	},
	stats = {
		weight = {min = 0.02, max = 0.06},
		length = {min = 0.0012, max = 0.021}
	},
	requires_hand = true,
	blueprint_compat = false,
	pixel_size = {w = 39, h = 39},
	loc_vars = function(self, info_queue, card)
	    return { vars = { card.ability.extra.base_highlighted, card.ability.extra.discards_per, card.ability.extra.my_discards, math.floor(card.ability.extra.my_discards / card.ability.extra.discards_per), } }
	end,
	calculate = function(self, card, context)
	    if context.discard then
            card.ability.extra.my_discards = card.ability.extra.my_discards + 1
            if math.floor(card.ability.extra.my_discards / card.ability.extra.discards_per) > math.floor((card.ability.extra.my_discards - 1) / card.ability.extra.discards_per) then
                return {
                    message = localize("k_upgrade_ex")
                }
            end
        end
    end,
    use = function(self, card, area, copier)
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
    end,
    can_use = function(self, card)
        return #G.hand.highlighted ~= 0 and #G.hand.highlighted <= card.ability.extra.base_highlighted + math.floor( card.ability.extra.my_discards / card.ability.extra.discards_per )
    end
}

-- Krilliant
-- Wheel of Fortuna
-- Epic Callback
-- Reaver Shark

-- self insert ?
-- Cranky ?
