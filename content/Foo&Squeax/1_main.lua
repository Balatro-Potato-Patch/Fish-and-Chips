FishAndChips.FooSqueax = {
	file_path = "Foo&Squeax/",
	fat_chud = {
		active = false,
		state = 0,
		timer = nil,
		fih = nil,
		scale = function(card, mod)
			card.T.w = card.T.w / card.ability.extra.xmult
			card.ability.extra.xmult = card.ability.extra.xmult + mod
			card.T.w = card.T.w * card.ability.extra.xmult
		end
	},
	tsunderfish = {
		
	}
}

FishAndChips.C.FooSqueax = {
	BLACK = {0, 0, 0, 1}
}

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

PotatoPatchUtils.Developer{
	name = "Foo54",
	atlas = "fac_fas_credits_foo",
	colour = HEX("ED5B5B"),
	fac_partner = "squeax09",
	loc = true
}

PotatoPatchUtils.Developer{
	name = "squeax09",
	atlas = "fac_fas_credits_sqx",
	pixel_size = {w = 66, h = 80},
	colour = HEX("c551bd"),
	fac_partner = "Foo54",
	loc = true
}

FishAndChips.mod.optional_features = FishAndChips.mod.optional_features or {}
FishAndChips.mod.optional_features.retrigger_joker = true

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
			wormholes = {}
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
			if card.ability.fac_fas_kebab.order ~= 1000 then
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
				if _card.config.center.key == "fish_fac_fas_kine" and _card.ability.immutable.id == card.ability.fac_fas_kine then
					card.T.x = _card.T.x + _card.T.w
					card.T.y = _card.T.y + _card.T.h / 2
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
		if box == G.fac_fishing_bucket_cards then
			table.insert(G.I.CARD, index - 1, G.fac_fas_kine_area)
			break
		end
	end
end