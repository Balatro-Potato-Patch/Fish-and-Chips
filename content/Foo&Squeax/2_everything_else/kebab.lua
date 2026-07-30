local FishAndChips_mod_custom_card_areas_ref = FishAndChips.mod.custom_card_areas
---@diagnostic disable-next-line: duplicate-set-field
function FishAndChips.mod.custom_card_areas(game)
	FishAndChips_mod_custom_card_areas_ref(game)
	G.fac_fas_fish_kebab_area = CardArea(
		0, 0,
		G.CARD_W, G.CARD_H,
		{
			type = "joker",
			highlighted_limit = 1,
			highlight_limit = 1
		}
	)
	game.fac_fishing_bucket_cards = UIBox({
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
					card.T.x = b.T.x - 				 b.T.w / 2 / scale + x_offset + w * i / length
					card.T.y = b.T.y + b.T.h - b.T.h / 2 / scale - y_offset - h * i / length
					card.T.w = b.T.w / scale
					card.T.h = b.T.h / scale
					card.T.r = b.T.r

					--[[
					
					
					local b = base[card.ability.fac_fas_kebab.id]
					local length = tally[card.ability.fac_fas_kebab.id]
					local i = ii - 1
					
					local x = -b.T.w / 2 + card.T.w / 2 / scale + x_offset + w * i / length
					local y =  b.T.h / 2 - card.T.h / 2 / scale - y_offset - h * i / length
					
					local r = b.T.r + math.atan2(G.CARD_H, G.CARD_W)

					card.T.x = x * math.cos(r) - y * math.sin(r) + b.T.x
					card.T.y = x * math.sin(r) + y * math.cos(r) + b.T.y

					card.T.r = b.T.r
					card.T.w = G.CARD_W / scale
					card.T.h = G.CARD_H / scale
					
					
					]]
				end
			end
		end
	end

	for index, box in ipairs(G.I.CARD) do
		if box == G.fac_fishing_bucket_cards then
			table.remove(G.I.CARD, index)
			break
		end
	end
	for index, box in ipairs(G.I.CARD) do
		if box == G.fac_fishing_bucket_top then
			table.insert(G.I.CARD, index, G.fac_fishing_bucket_cards)
			break
		end
	end
end

SMODS.Atlas{
	key = "fas_fish_kebab",
	path = FishAndChips.FooSqueax.file_path .. "kebab.png",
	px = 71,
	py = 95
}

function FishAndChips.FooSqueax.link_kebab_and_top(args)
	local kebab = args.kebab
	if not args.kebab then
		for _, card in ipairs(G.fac_fish_area.cards) do
			if card.config.center.key == "fish_fac_fas_fish_kebab" and card.ability.immutable.id == args.id then
				kebab = card
				break
			end
		end
	end
	args.top.states.hover.can = false
	local kebab_remove_ref = kebab.remove
	function kebab:remove()
		kebab_remove_ref(self)
		args.top:remove()
	end
	for i, card in ipairs(G.MOVEABLES) do
		if card == args.top then
			table.remove(G.MOVEABLES, i)
			break
		end
	end
	for i, card in ipairs(G.MOVEABLES) do
		if card == args.kebab then
			table.insert(G.MOVEABLES, i - 1, args.top)
			break
		end
	end
end

function FishAndChips.FooSqueax.link_kebab(kebab, fish)
	fish.states.hover.can = false
	local card_remove_ref = kebab.remove
	function kebab:remove()
		card_remove_ref(self)
		fish:remove()
	end
	for i, card in ipairs(G.MOVEABLES) do
		if card == fish then
			table.remove(G.MOVEABLES, i)
			break
		end
	end
	for i, card in ipairs(G.MOVEABLES) do
		if card == kebab then
			table.insert(G.MOVEABLES, i - 1, fish)
			break
		end
	end
end

FishAndChips.Fish{
	key = "fas_fish_kebab_top",
	ppu_coder = {"Mack"},
	atlas = "fas_fish_kebab",
	pos = {x = 1, y = 0},
	environments = {
		soup = 1
	},
	weight = 4,
	in_pool = function (self, args)
		return false
	end,
	config = {
		fac_fas_kebab = {
			id = nil,
			order = 1000
		}
	},
	no_collection = true,
	load = function (self, card, card_table, other_card)
		G.E_MANAGER:add_event(Event{
			func = function()
				FishAndChips.FooSqueax.link_kebab_and_top{
					top = card,
					id = card_table.ability.fac_fas_kebab.id
				}
				return true
			end
		})
	end,
	update = function (self, card, dt)
		local kebab
		for _, _card in ipairs(G.fac_fish_area.cards) do
			if _card.config.center.key == "fish_fac_fas_fish_kebab" and _card.ability.immutable.id == card.ability.fac_fas_kebab.id then
				kebab = _card
				break
			end
		end
		if kebab then
			card.T = copy_table(kebab.T)
			card.VT = copy_table(kebab.VT)
		end
	end,
	set_ability = function (self, card, initial, delay_sprites)
		if G.fac_fas_fish_kebab_area then
			if not FishAndChips.FooSqueax.fish_kebab_link then
				print("Fish kebab top created without a link, removing")
				card:remove()
			end
			card.ability.fac_fas_kebab.id = FishAndChips.FooSqueax.fish_kebab_link.ability.immutable.id
			FishAndChips.FooSqueax.link_kebab_and_top{
				top = card,
				kebab = FishAndChips.FooSqueax.fish_kebab_link
			}
			FishAndChips.FooSqueax.fish_kebab_link = nil
		end
	end
}

FishAndChips.Fish{
	key = "fas_fish_kebab",
	atlas = "fas_fish_kebab",
	config = {
		immutable = {
			id = nil,
			fish = 0
		}
	},
	ppu_coder = {"Foo54"},
	environments = {
		soup = 1
	},
	weight = 10,
	set_ability = function (self, card, initial, delay_sprites)
		if G.fac_fas_fish_kebab_area then
			card.ability.immutable.id = random_string(20, pseudoseed("fac_fas_fish_kebab"))
			FishAndChips.FooSqueax.fish_kebab_link = card
			SMODS.add_card{key = "fish_fac_fas_fish_kebab_top", no_edition = true, area = G.fac_fas_fish_kebab_area}
		end
	end,
	keep_on_use = function (self, card)
		return true
	end,
	load = function (self, card, card_table, other_card)
		G.E_MANAGER:add_event(Event{
			func = function()
				for _, _card in ipairs(G.fac_fas_fish_kebab_area.cards) do
					if _card.ability.fac_fas_kebab.id == card.ability.immutable.id then
						FishAndChips.FooSqueax.link_kebab(card, _card)
					end
				end
				return true
			end
		})
	end,
	can_use = function (self, card)
		for i, _card in ipairs(G.fac_fish_area.cards) do
			if _card == card then return i ~= #G.fac_fish_area.cards end
		end
		return false
	end,
	use = function(self, card)
		if card.ability.immutable.fish == 0 then
			local found = false
			local free = {}
			for _, _card in ipairs(G.fac_fish_area.cards) do
				if found and _card.config.center.key ~= "fac_fas_fish_kebab" then
					free[#free+1] = _card
					_card.ability.fac_fas_kebab = {
						id = card.ability.immutable.id,
						order = card.ability.immutable.fish
					}
					card.ability.immutable.fish = card.ability.immutable.fish + 1
					FishAndChips.FooSqueax.link_kebab(card, _card)

					-- less evil value manip
					for key, value in pairs(_card.ability) do
						pcall(function() _card.ability[key] = value / 2 end)
					end
					if _card.ability.extra and type(_card.ability.extra) == "table" then
						for key, value in pairs(_card.ability.extra) do
							pcall(function() _card.ability.extra[key] = value / 2 end)
						end
					end
				end
				if _card == card then found = true end
			end
			for _, _card in ipairs(free) do
				_card.area:remove_card(_card)
				G.fac_fas_fish_kebab_area:emplace(_card)
			end
		else
			card.ability.immutable.fish = 0
			for i = #G.fac_fas_fish_kebab_area.cards, 1, -1 do
				local _card = G.fac_fas_fish_kebab_area.cards[i]
				if _card.ability.fac_fas_kebab.id == card.ability.immutable.id and _card.ability.fac_fas_kebab.order ~= 1000 then
					_card:start_dissolve()
				end
			end
		end
	end,
	calculate = function(self, card, context)
		local effects = {}
		local retrigger = false
		for _, _card in ipairs(G.fac_fas_fish_kebab_area.cards) do
			if _card.ability.fac_fas_kebab.id == card.ability.immutable.id and _card.config.center.key ~= "fish_fac_fas_fish_kebab_top" then
				local eff, ret = _card:calculate_joker(context)
				effects[#effects+1] = eff
				retrigger = retrigger or ret
			end
		end
		if context.end_of_round and not context.blueprint then
			local highest = {ability = {fac_fas_kebab = {order = -1}}}
			for _, _card in ipairs(G.fac_fas_fish_kebab_area.cards) do
				if _card.ability.fac_fas_kebab.id == card.ability.immutable.id and _card.config.center.key ~= "fish_fac_fas_fish_kebab_top" then
					if _card.ability.fac_fas_kebab.order > highest.ability.fac_fas_kebab.order then
						highest = _card
					end
				end
			end
			if highest.is then
				highest:start_dissolve()
				SMODS.calculate_effect({message = localize("k_fac_fas_yum")}, highest)
			end
		end
		return SMODS.merge_effects(effects), retrigger or nil
	end,
}