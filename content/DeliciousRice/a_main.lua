PotatoPatchUtils.Developer({
	name = 'cheekyrotter',
	atlas = 'fac_delrice_credits',
	pos = {x = 0, y = 0},
	colour = G.C.RED,
	fac_partner = 'fac_EDriGO'
})

PotatoPatchUtils.Developer({
	name = 'EDriGO',
	atlas = 'fac_delrice_credits',
	pos = {x = 1, y = 0},
	colour = G.C.GREEN,
	fac_partner = 'fac_cheekyrotter'
})

SMODS.Atlas({
	key = "delrice_fish",
	path = "DeliciousRice/fish.png",
	px = 71,
	py = 95,
})

SMODS.Atlas({
	key = "delrice_credits",
	path = "DeliciousRice/credits.png",
	px = 71,
	py = 95,
})


SMODS.Sound({
	key = "delrice_instakill",
	path = "DeliciousRice/instakilled.ogg"
})

SMODS.Sound({
	key = "delrice_blender",
	path = "DeliciousRice/blender.ogg"
})


--stolen from yahimod and he stole from the internet (explosion.ogg title is "deltarune explosion greenscreen")
SMODS.Atlas {
    key = "delrice_explode",
    path = "DeliciousRice/explosiongif.png",
    px = 200,
    py = 282,
    atlas_table = "ANIMATION_ATLAS",
    frames = 17,
	fps = 10
}

SMODS.Sound({
	key = "delrice_explode",
	path = "DeliciousRice/explosion.ogg"
})

SMODS.Sound({
	key = "delrice_letsgo",
	path = "DeliciousRice/letsgo.ogg"
})
SMODS.Sound({
	key = "delrice_dangit",
	path = "DeliciousRice/dangit.ogg"
})
SMODS.Sound({
	key = "delrice_winning",
	path = "DeliciousRice/winning.ogg"
})


SMODS.Sound({
	key = "delrice_boowomp",
	path = "DeliciousRice/boowomp.ogg"
})
SMODS.Sound({
	key = "delrice_imspongebob",
	path = "DeliciousRice/imspongebob.ogg"
})

FishAndChips.DeliciousRice = {}
FishAndChips.DeliciousRice.SB_envs = {
	"calm_pond",
	"styx",
	"pier",
	"aquifer",
	"city_river",
	"garden",
	"backroom"
}

FishAndChips.DeliciousRice.valid_SB_env = function(key)
	for i, v in ipairs(FishAndChips.DeliciousRice.SB_envs) do
		if v == key then return true end
	end
	return false
end


FishAndChips.DeliciousRice.talk = function(card, length, gap, sound, vol)
	-- sendDebugMessage("start of talk")
	G.E_MANAGER:add_event(Event({
		func = function()
			-- sendDebugMessage("sound")
			play_sound(sound, nil, vol)
			return true
		end
	}))
	gap = gap or 0.2
	length = length or 2
	local loops = math.ceil(length / gap)
	for i = 1, loops do
		G.E_MANAGER:add_event(Event({
			trigger = "after",
			timer = "REAL",
			delay = gap,
			func = function()
				card:juice_up()
				return true
			end
		}))
	end
end

---@param card Card
FishAndChips.DeliciousRice.explode_destroy = function(card)
	-- local card = G.fac_fish_area.cards[1] --  for testing ingame
	local w = G.CARD_W / 71 * 200
	local h = G.CARD_W / 71 * 282
	-- local x = card.VT.x + (card.VT.w - w) / 2
	local x = 0
	local y = 0
	-- local y = card.VT.y + (card.VT.h - h) / 2
	G.E_MANAGER:add_event(Event({
		func = function()
			G.fac_delrice_explode = SMODS.create_sprite(x, y, w, h, "fac_delrice_explode")
			G.fac_delrice_explode_box = UIBox {
				definition = {
					n = G.UIT.ROOT,
					config = {no_fill = true, colour = HEX("00000000"), hover = true},
					nodes = {
						{ n = G.UIT.O, config = { no_fill = true, colour = G.C.GREEN, object = G.fac_delrice_explode } },
					},
				},
				config = {
					align = "cmi",
					major = card,
					no_fill = true,
					instance_type = "POPUP"
				},
			}
			play_sound("fac_delrice_explode")
			return true
		end
	}))
	
	G.E_MANAGER:add_event(Event({
		trigger = "after",
		timer = "REAL",
		delay = 0.9,
		func = function()
			return true
		end
	}))

	SMODS.destroy_cards(card, {no_juice = true})

	G.E_MANAGER:add_event(Event({
		trigger = "after",
		timer = "REAL",
		delay = 0.6,
		func = function()
			G.fac_delrice_explode:remove()
			G.fac_delrice_explode_box:remove()
			return true
		end
	}))
end

FishAndChips.DeliciousRice.fancy_death = function(card, destroy_args, middle_func, destroys, delay_after, delay_before, end_func)
	local old_state = G.STATE
	G.E_MANAGER:add_event(Event({
		func = function()
			G.STATE = nil
			if not G.GAME.fac_fish_expanded then G.FUNCS.fac_open_fishing_menu() end
			FishAndChips.DeliciousRice.bucket_locked = true
			-- sendDebugMessage("bucket open")
			return true
		end
	}))

	G.E_MANAGER:add_event(Event({
		trigger = "after",
		timer = "REAL",
		delay = delay_before or 0.2,
	}))
	if middle_func then middle_func() end
	if destroys == nil then destroys = true end
	if destroys == true then SMODS.destroy_cards(card, destroy_args) end
	-- sendDebugMessage("middle of death function")

	G.E_MANAGER:add_event(Event({
		trigger = "after",
		timer = "REAL",
		delay = delay_after or 0,
		func = function()
			FishAndChips.DeliciousRice.bucket_locked = false
			G.FUNCS.fac_open_fishing_menu()
			-- sendDebugMessage("bucket closed")
			if end_func then end_func() end
			G.STATE = old_state
			return true
		end
	}))
end

local start_run_ref = G.start_run
function G:start_run(args)
	local ret = start_run_ref(self, args)
    G.GAME.delrice_blenders = G.GAME.delrice_blenders or 0
	G.delrice_blender_areas = G.delrice_blender_areas or {}
    return ret
end

local areas_ref = SMODS.current_mod.custom_card_areas or function(game) end
SMODS.current_mod.custom_card_areas = function(game)
	local ret = areas_ref(game)
	game.delrice_blender_area = CardArea(0, 0, 0, 0, {type = "discard", major = G.play})
	return ret
end

local flip_ref = Card.flip
function Card:flip()
	local ret = flip_ref(self)
	SMODS.calculate_context({card_flipped = true})
	return ret
end

local emplace_ref = CardArea.emplace
function CardArea:emplace(card, location, stay_flipped)
	FishAndChips.DeliciousRice.emplacing = true
	emplace_ref(self, card, location, stay_flipped)
	FishAndChips.DeliciousRice.emplacing = false
end

local draw_ref = draw_card
function draw_card(from, to, percent, dir, sort, card, delay, mute, stay_flipped, vol, discarded_only)
	FishAndChips.DeliciousRice.bad_flip = false
	if to == G.deck or to == G.discard or from == G.play then 
		FishAndChips.DeliciousRice.bad_flip = true
	end
	local ret = draw_ref(from, to, percent, dir, sort, card, delay, mute, stay_flipped, vol, discarded_only)
	return ret
end

local play_cards_ref = G.FUNCS.play_cards_from_highlighted
function G.FUNCS.play_cards_from_highlighted(e)
	FishAndChips.DeliciousRice.in_hand = true
	local ret = play_cards_ref(e)
	return ret
end

local to_discard_ref = G.FUNCS.draw_from_play_to_discard
function G.FUNCS.draw_from_play_to_discard()
	local ret = to_discard_ref()
	FishAndChips.DeliciousRice.in_hand = false
	return ret
end

local bucket_ref = G.FUNCS.fac_open_fishing_menu
function G.FUNCS.fac_open_fishing_menu(e)
	if FishAndChips.DeliciousRice.bucket_locked then return end
	return bucket_ref(e)  
end