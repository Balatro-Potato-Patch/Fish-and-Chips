

SMODS.Atlas{
	key = "fas_fish_kebab",
	path = FishAndChips.FooSqueax.file_path .. "kebab.png",
	px = 71,
	py = 95
}

--[[
function FishAndChips.FooSqueax.link_kebab_and_top(args)
	local kebab = args.kebab
	if (not args.kebab) and G.fac_fish_area then
		for _, card in ipairs(G.fac_fish_area.cards) do
			if card.config.center.key == "fish_fac_fas_fish_kebab" and card.ability.immutable.id == args.id then
				kebab = card
				break
			end
		end
	end
	if kebab then
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
	--ppu_artist = {"https://en.wikipedia.org/wiki/Kebab"},
	atlas = "fas_fish_kebab",
	pos = {x = 1, y = 0},
	environments = {
		soup = 1
	},
	weight = 4,
	in_pool = function (self, args)
		return false
	end,
	disable_visual_scaling = true,
	stats = {
		length = {min = 5, max = 5},
		weight = {min = 5, max = 5}
	},
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
		if G.fac_fish_area then
			for _, _card in ipairs(G.fac_fish_area.cards) do
				if _card.config.center.key == "fish_fac_fas_fish_kebab" and _card.ability.immutable.id == card.ability.fac_fas_kebab.id then
					kebab = _card
					break
				end
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
]]


FishAndChips.Fish{
	key = "fas_fish_kebab",
	atlas = "fas_fish_kebab",
	config = {
		immutable = {
			id = nil,
			fish = 0
		}
	},
	attributes = {"copying", "useable", "food"},
	ppu_artist = {"squeax09"},
	ppu_coder = {"Foo54"},
	environments = {
		soup = 1
	},
	badge_key = "k_fac_fas_skewer",
	stats = {
		length = {min = 0.25, max = 0.5},
		weight = {min = 0.05, max = 0.1}
	},
	weight = 5,
	set_ability = function (self, card, initial, delay_sprites)
		if G.fac_fas_fish_kebab_area then
			card.ability.immutable.id = random_string(20, pseudoseed("fac_fas_fish_kebab"))
			--FishAndChips.FooSqueax.fish_kebab_link = card
			--SMODS.add_card{key = "fish_fac_fas_fish_kebab_top", no_edition = true, area = G.fac_fas_fish_kebab_area}
		end
	end,
	keep_on_use = function (self, card)
		return true
	end,
	--[[load = function (self, card, card_table, other_card)
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
	end,]]
	loc_vars = function(self, info_queue, card)
		local fish_check = false
		if G.fac_fish_area and #G.fac_fish_area.cards > 0 then
			for i, fih in ipairs(G.fac_fish_area.cards) do
				if fih.ability.eternal then fish_check = true break end
			end
		end
		return {vars = {(fish_check and "(Cannot skewer " or ""), (fish_check and "Eternals" or ""), (fish_check and ")" or "")}}
	end,
	can_use = function (self, card)
		for i, fish in ipairs(G.fac_fish_area.cards) do
			if fish.config.center.key == 'fish_fac_fas_fish_kebab' then
				if fish.ID == card.ID and fish.rank ~= card.rank then return false end
			end
		end
		if (card.ability.immutable.fish > 0) or (not G.fac_fish_area) then return true end
		for i, _card in ipairs(G.fac_fish_area.cards) do
			if _card == card then return i ~= #G.fac_fish_area.cards end
		end
		return false
	end,
	use = function(self, card)
		if card.ability.immutable.fish == 0 then
			local found = false
			local free = {}
			if G.fac_fish_area then
				for _, _card in ipairs(G.fac_fish_area.cards) do
					if found then
						if _card.config.center.key ~= "fish_fac_fas_fish_kebab" and not _card.ability.eternal then
							free[#free+1] = _card
							_card.ability.fac_fas_kebab = {
								id = card.ability.immutable.id,
								order = card.ability.immutable.fish
							}
							card.ability.immutable.fish = card.ability.immutable.fish + 1
							--FishAndChips.FooSqueax.link_kebab(card, _card)
						else
							SMODS.calculate_effect({message = localize("k_nope_ex"), colour = G.C.PURPLE}, _card)
						end
					end
					if _card == card then found = true end
				end
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
		if context.end_of_round and context.main_eval and not context.blueprint then
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
		local eff = SMODS.merge_effects(effects)
		if retrigger then return eff, retrigger
		else return eff end
	end,
	remove_from_deck = function (self, card, from_debuff)
		local copy_check = false
		for i, fish in ipairs(G.fac_fish_area.cards) do
			if fish.ability.immutable.id and fish.config.center.key == 'fish_fac_fas_fish_kebab' then
				if fish.ability.immutable.id == card.ability.immutable.id and fish.rank ~= card.rank then copy_check = true end
			end
		end
		if not copy_check then
			card.ability.immutable.fish = 0
			for i = #G.fac_fas_fish_kebab_area.cards, 1, -1 do
				local _card = G.fac_fas_fish_kebab_area.cards[i]
				if _card.ability.fac_fas_kebab.id == card.ability.immutable.id and _card.ability.fac_fas_kebab.order ~= 1000 then
					_card:start_dissolve()
				end
			end
		end
	end
}



-- drawstep tomfoolery by gabby
SMODS.DrawStep {
    key = 'fas_fish_kebab_top',
    order = 690,
    func = function(self, layer)
        if self.config.center.key == "fish_fac_fas_fish_kebab" then
            if not FishAndChips.FooSqueax.kebab_top then
                FishAndChips.FooSqueax.kebab_top = Sprite(0, 0, G.CARD_W, G.CARD_H, G.ASSET_ATLAS['fac_fas_fish_kebab'], { x = 1, y = 0 })
            end
            FishAndChips.FooSqueax.kebab_top.role.draw_major = self
			FishAndChips.FooSqueax.kebab_top:draw_shader('dissolve', nil, nil, nil, self.children.center)
			
			-- edition handling i yoinked from absinthe wormhole - gabby 
            if self.edition and not self.delay_edition then
                for k, v in pairs(G.P_CENTER_POOLS.Edition) do
                    if self.edition[v.key:sub(3)] and v.shader then
						if type(v.draw) == 'function' then
							v:draw(self, layer)
						else
							FishAndChips.FooSqueax.kebab_top:draw_shader(v.shader, nil, self.ARGS.send_to_shader, nil, self.children.center)
						end
                    end
                end
                if self.edition.negative then
                    FishAndChips.FooSqueax.kebab_top:draw_shader('negative_shine', nil, self.ARGS.send_to_shader, nil, self.children.center)
                end
            elseif not self:should_draw_base_shader() then
            	-- Don't render base dissolve shader.
            elseif not self.greyed then
				FishAndChips.FooSqueax.kebab_top:draw_shader('dissolve', nil, nil, nil, self.children.center)
            end
        end
    end,
    conditions = { vortex = false, facing = 'front' },
}