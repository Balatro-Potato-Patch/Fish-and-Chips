FishAndChips.FooSqueax = {
	file_path = "Foo&Squeax/",
	fat_chud = {
		active = false,
		state = 0,
		timer = nil,
		fih = nil,
		scale = function(card, mod)
			card.T.w = card.T.w / math.max(1, card.ability.extra.xmult / 2)
			card.ability.extra.xmult = card.ability.extra.xmult + mod
			card.T.w = card.T.w * math.max(1, card.ability.extra.xmult / 2)
		end
	},
	tsunderfish = {},
	toby_fish = {
		no_desc = nil
	},
	undertale = {},
	nyon = {},
}

FishAndChips.C.FooSqueax = {
	BLACK = {0, 0, 0, 1},
	ORANGE = HEX("ff7f27"),
	YELLOW = HEX("ffff40")
}

SMODS.Attribute{key = "undertale"}
SMODS.Attribute{key = "deltarune"}
SMODS.Attribute{key = "utdr"}
SMODS.Attribute{key = "vocaloid"}

SMODS.Atlas{
	key = "fas_credits_foo",
	path = FishAndChips.FooSqueax.file_path .. "credits/foo.png",
	px = 71,
	py = 95,
}

SMODS.Atlas{
	key = "fas_credits_sqx",
	path = FishAndChips.FooSqueax.file_path .. "credits/gabby.png",
	px = 71,
	py = 95,
}

SMODS.Atlas{
	key = "fas_fish_general",
	path = FishAndChips.FooSqueax.file_path .. "fish.png",
	px = 71,
	py = 95
}

SMODS.Atlas{
	key = "fas_credits_silly",
	path = FishAndChips.FooSqueax.file_path .. "credits/silly.png",
	px = 240,
	py = 240,
	atlas_table = "ANIMATION_ATLAS",
	frames = 38,
	fps = 10
}

PotatoPatchUtils.Developer{
	name = "Foo54",
	atlas = "fac_fas_credits_foo",
	colour = HEX("ED5B5B"),
	fac_partner = "fac_squeax09",
	loc = true,
	calculate = function(self, context)
		if context.fac_end_fishing and context.fish then
			G.GAME.fac_FooSqueax.fish_caught[context.fish] = true
		end
	end,
	click = function(self)
		FishAndChips.FooSqueax.undertale:init(self)
	end,
	loc_vars = function(self)
		return {vars = {elements = {SMODS.create_sprite(0, 0, 2, 2, "fac_fas_credits_silly")}}}
	end
}

for i=1, 11 do
	SMODS.Sound({key = 'fac_fas_gabby' .. i, path = FishAndChips.FooSqueax.file_path .. "gabby" .. i .. ".ogg",})
end

PotatoPatchUtils.Developer{
	name = "squeax09",
	atlas = "fac_fas_credits_sqx",
	pixel_size = {w = 66, h = 80},
	colour = HEX("c551bd"),
	fac_partner = "fac_Foo54",
	loc = true,
	loc_vars = function(self, info_queue, card)
		return {vars = {elements = {FishAndChips.FooSqueax.sqx_credit_ui_baits(), FishAndChips.FooSqueax.sqx_credit_ui_fish()}}}
	end,
	click = function(self)
		local pickables = pseudorandom('ts gabby', 1, 11)
		play_sound("fac_fas_gabby" .. pickables, 1, 0.8)
		self:juice_up()
	end,
}

function FishAndChips.FooSqueax.sqx_credit_ui_baits()
	local area = CardArea(G.ROOM.T.x, G.ROOM.T.y, (G.CARD_W * 4.5), G.CARD_H*0.4, { card_limit = 15, type = 'title', highlight_limit = 0, collection = true }) 
	for i=1, #G.P_CENTER_POOLS.fac_Bait do
		local card = Card(area.T.x, area.T.y, G.CARD_W*0.4, G.CARD_H*0.4, G.P_CARDS.empty, G.P_CENTERS[G.P_CENTER_POOLS.fac_Bait[i].key])
		area:emplace(card)
		card.no_ui = true
	end
	return {
        n = G.UIT.R,
        config = { emboss = 0.05, r = 0.1, align = "cm", padding = 0.1, colour = G.C.CLEAR },
        nodes = {
			-- Card Area
            {
                n = G.UIT.R,
                config = { align = "cm", padding = 0.05 },
                nodes = {
                    { n = G.UIT.O, config = { object = area } }
                }
            },
        }
    }
end

function FishAndChips.FooSqueax.sqx_credit_ui_fish()
	local area = CardArea(G.ROOM.T.x, G.ROOM.T.y, (G.CARD_W * 4.5), G.CARD_H*0.4, { card_limit = 11, type = 'title', highlight_limit = 0, collection = true })
	local listables = {
		"submarine",
		"fish_kebab",
		"john_cod",
		"kawkaw",
		"annoying_fish",
		"isreal",
		"super_bo_noise",
		"kine",
		'tsundere',
		'you',
		'luka',
		'chimera',
		'kyu_kurafin',
		'sardine',
	}
	for i=1, #listables do
		local card = Card(area.T.x, area.T.y, G.CARD_W*0.5, G.CARD_H*0.5, G.P_CARDS.empty, G.P_CENTERS['fish_fac_fas_' .. listables[i]])
		area:emplace(card)
		card.no_ui = true
	end
	return {
        n = G.UIT.R,
        config = { emboss = 0.05, r = 0.1, align = "cm", padding = 0.1, colour = G.C.CLEAR },
        nodes = {
			-- Card Area
            {
                n = G.UIT.R,
                config = { align = "cm", padding = 0.1 },
                nodes = {
                    { n = G.UIT.O, config = { object = area } }
                }
            },
        }
    }
end

FishAndChips.mod.optional_features = FishAndChips.mod.optional_features or {}
FishAndChips.mod.optional_features.retrigger_joker = true


local game_start_run_ref = Game.start_run
---@diagnostic disable-next-line: duplicate-set-field
function Game:start_run(...)
	if G.fac_fas_nyon then
		G.fac_fas_nyon:remove()
		G.fac_fas_nyon = nil
	end
	return game_start_run_ref(self, ...)
end

local fishandchips_mod_reset_game_globals_ref = FishAndChips.mod.reset_game_globals
---@diagnostic disable-next-line: duplicate-set-field
function FishAndChips.mod.reset_game_globals (run_start)
---@diagnostic disable-next-line: need-check-nil
	fishandchips_mod_reset_game_globals_ref(run_start)
	if run_start then
		G.GAME.fac_FooSqueax = {
			bucket = {
				on = false,
				water_height = 1
			},
			wormholes = {},
			tobies = 0,
			fish_caught = {},
			nyon = 0,
		}
	end
	G.GAME.fac_FooSqueax.wormholes.target = pseudorandom_element(PotatoPatchUtils.Developers).name
end

local cardarea_emplace_red = CardArea.emplace
---@diagnostic disable-next-line: duplicate-set-field
function CardArea:emplace(card, ...)
	if card.ppu_member and card.ppu_member.name == "Foo54" then
		local dev_card2 = Card(0, 0, G.CARD_W / 1.25, G.CARD_H / 1.25, nil, G.P_CENTERS.c_base)
    dev_card2.children.center:remove()
    dev_card2.children.center = SMODS.create_sprite(dev_card2.T.x, dev_card2.T.y, dev_card2.T.w, dev_card2.T.h, "fac_rods", {x = 1, y = 2})
    dev_card2.children.center.states.hover = dev_card2.states.hover
    dev_card2.children.center.states.click = dev_card2.states.click
    dev_card2.children.center.states.drag = dev_card2.states.drag
    dev_card2.children.center.states.collide.can = true
    dev_card2.children.center:set_role({major = dev_card2, role_type = 'Glued', draw_major = dev_card2})
		dev_card2.fac_fas_do_shader = true
    dev_card2.no_shadow = true
		function dev_card2:hover() end
		self:emplace(dev_card2)
	end
	cardarea_emplace_red(self, card, ...)
end

local FishAndChips_mod_custom_card_areas_ref = FishAndChips.mod.custom_card_areas
---@diagnostic disable-next-line: duplicate-set-field
function FishAndChips.mod.custom_card_areas(game)
	FishAndChips_mod_custom_card_areas_ref(game)
	-- kebab
	G.fac_fas_fish_kebab_area = CardArea(
		0, 0,
		G.CARD_W, G.CARD_H,
		{
			type = "joker",
			highlighted_limit = 1,
			highlight_limit = 1
		}
	)
	game.fac_fas_kebab_cards = UIBox({
		definition = {
			n = G.UIT.ROOT,
			config = { colour = G.C.CLEAR },
			nodes = {
				{ n = G.UIT.O, config = { object = game.fac_fas_fish_kebab_area } },
			},
		},
		config = {
			align = "tr",
			offset = { x = 20, y = -5 },
			major = G.ROOM_ATTACH,
			instance_type = "CARD",
		},
	})
	function G.fac_fas_fish_kebab_area:align_cards()
		table.sort(self.cards, function (a, b)
			return a.ability.fac_fas_kebab.order < b.ability.fac_fas_kebab.order
		end)
		local tally = {}
		for _, card in ipairs(self.cards) do
			if card.ability.fac_fas_kebab.order ~= 1000 then
				tally[card.ability.fac_fas_kebab.id] = (tally[card.ability.fac_fas_kebab.id] or 0) + 1
			end
		end

		local scale = 2

		local base = {}
		for id in pairs(tally) do
			for _, card in ipairs(G.fac_fish_area.cards) do
				if card.config.center.key == "fish_fac_fas_fish_kebab" and card.ability.immutable.id == id then
					base[id] = card
					break
				end
			end
		end
		
		for ii, card in ipairs(self.cards) do
			if card.ability.fac_fas_kebab.order ~= 1000 and not card.disable_align then
				local b = base[card.ability.fac_fas_kebab.id]
				if b then
					local length = tally[card.ability.fac_fas_kebab.id]
					local w = b.T.w * 0.5
					local h = b.T.h * 0.5
					local x_offset = b.T.w * 0.3
					local y_offset = b.T.h * 0.3
					local i = ii - 1
					card.T.x = b.T.x  			 + x_offset + w * i / length
					card.T.y = b.T.y + b.T.h - y_offset - h * i / length
					if not card.memT then card.memT = copy_table(card.T) end
					card.T.w = card.memT.w / G.CARD_W * b.T.w / scale
					card.T.x = card.T.x - card.T.w / 2
					card.T.h = card.memT.h / G.CARD_H *  b.T.h / scale
					card.T.y = card.T.y - card.T.h / 2
					card.T.r = b.T.r
				end
			end
		end
	end

	for index, box in ipairs(G.I.CARD) do
		if box == G.fac_fas_kebab_cards then
			table.remove(G.I.CARD, index)
			break
		end
	end
	for index, box in ipairs(G.I.CARD) do
		if box == G.fac_fishing_bucket_top then
			table.insert(G.I.CARD, index, G.fac_fas_kebab_cards)
			break
		end
	end

	-- kine
	G.fac_fas_kine_area = CardArea(
		-20, -20,
		G.CARD_W, G.CARD_H,
		{
			type = "joker",
			highlighted_limit = 1,
			highlight_limit = 1
		}
	)
	function G.fac_fas_kine_area:align_cards()
		local scale = 4
		for i, card in ipairs(self.cards) do
			for _, _card in ipairs(G.fac_fish_area.cards) do
				if _card.config.center.key == "fish_fac_fas_kine" and _card.ability.immutable.id == card.ability.fac_fas_kine and not card.disable_align then
					card.T.x = _card.T.x + _card.T.w - 0.1
					card.T.y = _card.T.y + _card.T.h / 2 + 0.1
					card.T.r = _card.T.r
					if not card.memT then card.memT = copy_table(card.T) end
					card.T.w = card.memT.w / G.CARD_W * _card.T.w / scale
					card.T.h = card.memT.h / G.CARD_H * _card.T.h / scale
					card.T.x = card.T.x - card.T.w
					card.T.y = card.T.y - card.T.h / 2
				end
			end
			for _, _card in ipairs(G.fac_fas_fish_kebab_area.cards) do
				if _card.config.center.key == "fish_fac_fas_kine" and _card.ability.immutable.id == card.ability.fac_fas_kine and not card.disable_align then
					card.T.x = _card.T.x + _card.T.w - 0.1
					card.T.y = _card.T.y + _card.T.h / 2 + 0.1
					card.T.r = _card.T.r
					if not card.memT then card.memT = copy_table(card.T) end
					card.T.w = card.memT.w / G.CARD_W * _card.T.w / scale
					card.T.h = card.memT.h / G.CARD_H * _card.T.h / scale
					card.T.x = card.T.x - card.T.w
					card.T.y = card.T.y - card.T.h / 2
				end
			end
		end
	end

	for index, box in ipairs(G.I.CARD) do
		if box == G.fac_fas_kine_area then
			table.remove(G.I.CARD, index)
			break
		end
	end
	for index, box in ipairs(G.I.CARD) do
		if box == G.fac_fishing_bucket_top then
			table.insert(G.I.CARD, index, G.fac_fas_kine_area)
			break
		end
	end
end