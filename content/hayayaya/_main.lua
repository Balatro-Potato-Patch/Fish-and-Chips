SMODS.Atlas({
	key = "hayayaya_credits",
	path = "hayayaya/credits.png",
	px = 71,
	py = 95,
})

SMODS.Atlas({
	key = "hayayaya_fih",
	path = "hayayaya/fih.png",
	px = 71,
	py = 95,
})

SMODS.Atlas({
	key = "hayayaya_explosion",
	path = "hayayaya/explosion.png",
	px = 71,
	py = 100,
	fps = 90,
	frames = 18,
	atlas_table = "ANIMATION_ATLAS",
})

SMODS.Sound({
	key = "hayayaya_explosion",
	path = "hayayaya/snd_badexplosion.ogg",
})

SMODS.Sound({
	key = "hayayaya_mistake",
	path = "hayayaya/se_mistake.ogg",
})

SMODS.Sound({
	key = "hayayaya_abyss",
	path = "hayayaya/se_abyss.ogg",
})

SMODS.Sound({
	key = "hayayaya_rainer",
	path = "hayayaya/rainer.ogg",
})

SMODS.Font({
	key = "hayayaya_pkmn",
	path = "hayayaya/pokemon-font.ttf",
	FONTSCALE = 0.07,
	squish = 1,
	TEXT_HEIGHT_SCALE = 0.75,
	TEXT_OFFSET = { x = 0, y = -40 },
})

SMODS.Font({
	key = "hayayaya_unown",
	path = "hayayaya/unown.ttf",
	FONTSCALE = 0.1,
	squish = 1,
	TEXT_HEIGHT_SCALE = 0.75,
	TEXT_OFFSET = { x = 0, y = -20 },
})

PotatoPatchUtils.Developer({
	name = "Ellen (Haya)",
	atlas = "fac_hayayaya_credits",
	colour = G.C.PURPLE,
	fac_partner = "fac_Pepix",
	loc = true,
	click = function()
		play_sound("fac_hayayaya_rainer")
	end,
})

PotatoPatchUtils.Developer({
	name = "Pepix",
	atlas = "fac_hayayaya_credits",
	pos = { x = 1, y = 0 },
	colour = G.C.GOLD,
	fac_partner = "fac_Ellen (Haya)",
	loc = true,
	calculate = function(self, context)
		-- Used for freedom motif
		if context.fac_end_fishing and context.fish_obj and not context.failed and not context.perfect then
			context.fish_obj.ability.fac_bait_used = G.GAME.fac_active_bait
			context.fish_obj:set_cost()
		end
	end,
})

-- Namespace for team specific utils

HayayayaUtils = {}
HayayayaUtils.MusicStopped = false
HayayayaUtils.DontRestartOnBlindSelect = false

local gum = Game.update_menu
function Game:update_menu(dt)
	gum(self, dt)
	if HayayayaUtils.MusicStopped then
		HayayayaUtils.MusicStopped = false
		HayayayaUtils.DontRestartOnBlindSelect = false
		HayayayaUtils.restart_music()
	end
end

local gubs = Game.update_blind_select
function Game:update_blind_select(dt)
	gubs(self, dt)
	if HayayayaUtils.MusicStopped and not HayayayaUtils.DontRestartOnBlindSelect then
		HayayayaUtils.MusicStopped = false
		HayayayaUtils.restart_music()
	end
end

local gudth = Game.update_draw_to_hand
function Game:update_draw_to_hand(dt)
	gudth(self, dt)
	if HayayayaUtils.MusicStopped then
		HayayayaUtils.MusicStopped = false
		HayayayaUtils.DontRestartOnBlindSelect = false
		HayayayaUtils.restart_music()
	end
end

function HayayayaUtils.restart_music()
	G.ARGS.push = G.ARGS.push or {}
	G.ARGS.push.type = "restart_music"
	if G.F_SOUND_THREAD then
		G.SOUND_MANAGER.channel:push(G.ARGS.push)
	else
		RESTART_MUSIC(G.ARGS.push)
	end
end

function HayayayaUtils.stop_music(prevent_blind)
	G.ARGS.push = G.ARGS.push or {}
	G.ARGS.push.type = "hayayaya_stop_music"
	if G.F_SOUND_THREAD then
		G.SOUND_MANAGER.channel:push(G.ARGS.push)
	else
		STOP_MUSIC(G.ARGS.push)
	end
	HayayayaUtils.MusicStopped = true
	if prevent_blind then
		HayayayaUtils.DontRestartOnBlindSelect = true
	end
end

-- This is so ridicluously old
HayayayaUtils.MisprintizeForbidden = {
	["id"] = true,
	["ID"] = true,
	["sort_id"] = true,
	["perish_tally"] = true,
	["colour"] = true,
	["suit_nominal"] = true,
	["base_nominal"] = true,
	["face_nominal"] = true,
	["qty"] = true,
	["selected_d6_face"] = true,
	["h_x_mult"] = true,
	["h_x_chips"] = true,
	["d_size"] = true,
	["h_size"] = true,
	["immutable"] = true,
	["min_highlighted"] = true,
	--["x_mult"] = true,
}

-- Loosely based on https://github.com/balt-dev/Inkbleed/blob/trunk/modules/misprintize.lua
-- Specifically for non random values
---@param val any Value to be modified. Recursive.
---@param amt? any Value to be used with `value`. See `func`. Defaults to 1.
---@param reference? table Reference table to check previous values edited by this function. Defaults to an empty table.
---@param key? any Key of the current table used, if `val` is a table. Defaults to "1".
---@param func? fun(value: any, amount: any): any Function used to modify `val` with `amt`. Uses multiplication if not specified.
---@param whitelist? table<any, boolean> Whitelisted keys for tables. If not specified, uses `blacklist`.
---@param blacklist? table<any, boolean> Blacklisted keys for tables. If not specified, uses a default blacklist.
---@param layer? number Layer of current table for recursive checking, if `val` is a table. Defaults to 0.
---@param blacklist_key? fun(key: any, value: any, layer: number): boolean Additional blacklist function, taking in the key, value and layer as parameters. Defaults to a function for checking `x_mult` and `x_chips` for the ability table.
---@return any val Value modified.
function HayayayaUtils.MMisprintize(val, amt, reference, key, func, whitelist, blacklist, layer, blacklist_key)
	local meta = type(val) == "table" and getmetatable(val) or nil
	if meta then
		setmetatable(val, nil)
	end
	reference = reference or {}
	key = key or "1"
	amt = amt or 1
	func = func or function(v, a)
		return v * a
	end
	layer = layer or 0
	blacklist_key = blacklist_key
		or function(k, v, l)
			if v == 1 and l == 1 then
				if k == "x_mult" or k == "x_chips" then
					return false
				end
			end
			return true
		end
	blacklist = blacklist or HayayayaUtils.MisprintizeForbidden
	-- Forbidden, skip it
	if blacklist[key] then
		if type(val) == "table" and meta then
			setmetatable(val, meta)
		end
		return val
	end
	if (whitelist and whitelist[key]) or not whitelist then
		local t = type(val)
		--if is_number(val) then print("key: "..key.." val: "..val.." layer: "..layer) end
		if t == "number" and blacklist_key(key, val, layer) then
			if type(val) == "table" and meta then
				setmetatable(val, meta)
			end
			reference[key] = val
			return func(val, amt)
		elseif t == "table" then
			for k, v in pairs(val) do
				val[k] = HayayayaUtils.MMisprintize(
					v,
					amt,
					reference[key],
					k,
					func,
					whitelist,
					blacklist,
					layer + 1,
					blacklist_key
				)
			end
		end
	end
	if type(val) == "table" and meta then
		setmetatable(val, meta)
	end
	return val
end

---@class MisprintizeContext
---@field val any Value to be modified. Recursive.
---@field amt? any Value to be used with `value`. See `func`. Defaults to 1.
---@field reference? table Reference table to check previous values edited by this function. Defaults to an empty table.
---@field key? any Key of the current table used, if `val` is a table. Defaults to "1".
---@field func? fun(value: any, amount: any): any Function used to modify `val` with `amt`. Uses multiplication if not specified.
---@field whitelist? table<any, boolean> Whitelisted keys for tables. If not specified, uses `blacklist`.
---@field blacklist? table<any, boolean> Blacklisted keys for tables. If not specified, uses a default blacklist.
---@field layer? number Layer of current table for recursive checking, if `val` is a table. Defaults to 0.
---@field blacklist_key? fun(key: any, value: any, layer: number): boolean Additional blacklist function, taking in the key, value and layer as parameters. Defaults to a function for checking `x_mult` and `x_chips` for the ability table.

-- The above, but with the parameters as a table instead.
-- In short, misprintizes values by multiplication or a specified `func` function.
---@param t MisprintizeContext Misprintize parameters.
---@return any val Return value.
function HayayayaUtils.Misprintize(t)
	t = t or {}
	assert(t.val, "HayayayaUtils.Misprintize: Value not provided!")
	assert(t.amt, "HayayayaUtils.Misprintize: Amount not provided!")
	return HayayayaUtils.MMisprintize(
		t.val,
		t.amt,
		t.reference,
		t.key,
		t.func,
		t.whitelist,
		t.blacklist,
		t.layer,
		t.blacklist_key
	)
end

HayayayaUtils.Ones = { "", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine" }
HayayayaUtils.Teens =
	{ "ten", "eleven", "twelve", "thirteen", "fourteen", "fifteen", "sixteen", "seventeen", "eighteen", "nineteen" }
HayayayaUtils.Tens = { "", "", "twenty", "thirty", "forty", "fifty", "sixty", "seventy", "eighty", "ninety" }

HayayayaUtils.LocalizeNumber = function(num)
	num = math.floor(num) -- Just in case...
	if num < 10 then
		return HayayayaUtils.Ones[num + 1]
	elseif num < 20 then
		return HayayayaUtils.Teens[num + 1]
	elseif num < 100 then
		return HayayayaUtils.Tens[math.floor(num / 10) + 1]
			+ (num % 10 ~= 0 and HayayayaUtils.LocalizeNumber(num % 10) or "")
	end
	return "null" -- At this point, just stop doing this.
end
