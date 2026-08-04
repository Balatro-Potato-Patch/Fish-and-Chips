FishAndChips.Fish {
	key = "pa_doorfish",
	weight = 5,
	atlas = "pa_pulsarfish",
	pos = { x = 6, y = 1 },
	ppu_artist = { "Pulsar" },
	ppu_coder = { "Axy" },
	attributes = { "generation", "usable" },
	environments = {
		city_river = 1,
		backroom = 0.5
	},
	stats = {
		length = { min = 0.0120, max = 0.0120},  --based on ordinary cd
		weight = { min = 0.02, max = 0.02}
	},
	choose = 3,
	blueprint_compat = true,
	config = {
		extra = {
			times_used = 0, -- 0 at rank 1, 7 at rank 8
			drawn_fish = {},
			toggle = 0, -- 0,1,2,3, 0 is inactive
		}
	},
	loc_vars = function(self, info_queue, card)
		local card_status = "(Inactive)"
		local toggle = card.ability.extra.toggle or 0
		if toggle and toggle > 0 then
			card_status = "(Currently '" .. localize({ type = 'name_text', set = "fac_Fish", key = card.ability.extra.drawn_fish[toggle] }) .. "' )"
		end
		print("loc vars variables:")
		print(card_status, toggle)
		return { vars = { card.ability.extra.times_used + 1, card_status } }
	end,
	-- draw fish based on rank 0
	-- rotate through four effects: inactive, fish 1/2/3
	-- after successful catch of chosen fish, increase rank and redraw fish based on rank, stop at rank 9
	-- set use cost based on total cost/weight of chosen fish, we have 6 sand dollars per ante
	add_to_deck = function(self, card)
		--draw fish based on rank 0
		card.ability.extra.drawn_fish = self.choose_fish_in_pool(card.ability.extra.times_used)
		print("drawn fish:")
		print(card.ability.extra.drawn_fish)
	end,
	calculate = function(self, card, context)
		if context.fac_end_fishing and context.fish == card.ability.extra.drawn_fish[card.ability.extra.toggle] then
			
		end
	end,
    can_use = function(self, card)
        return true
    end,
	keep_on_use = function(self, card)
		return true
	end,
	use = function(self, card)
		-- Increment persistent variables
		card.ability.extra.toggle = (card.ability.extra.toggle + 1) % 4 -- 0,1,2,3
		card.ability.extra.times_used = card.ability.extra.times_used + 1


		local times_used = card.ability.extra.times_used
		local sprite_change = times_used >= 7 and 3 or times_used >= 3 and 2 or 1
		G.E_MANAGER:add_event(Event({
			trigger = 'after',
			func = function()
				card:juice_up(0.3, 0.5)
				card.children.center:set_sprite_pos({x = 6, y = sprite_change})
				return true
			end}))
		print(card.ability.extra)
	end,
	choose_fish_in_pool = function(self, rank)
		-- find current environment, get all fish from it, set rarities based on weight
		-- set gem costs based on relative costs, but they will likely all be 4
		-- filter out treasure fish, only spawn them if seal unlocked
		-- fetch 3 fish and colorize, if blue_streak > 3 continue fetching until at least 1 fish is blue
		-- display fish to pick, carpboard cutout will always be able to be spawned
		local pool = {}

		_force_env = FishAndChips.rod_function('force_environment')
		local unfiltered_fish_pool = SMODS.create_poll_pool({_force_env or G.GAME.fac_fishing_environment}, {types = {'fac_Fish'}})
		fish_pool = FishAndChips.rod_function('modify_pool', fish_pool) or fish_pool

		local fish_pool = unfiltered_fish_pool
		for _,v in ipairs(unfiltered_fish_pool) do
			if v.ability and v.ability.set == "fac_Fish" then
				table.insert(fish_pool, v)
			end
		end
		
		-- local only_treasure = self.ability.extra.seal_unlocked and rank >= 8 and "treasure" or nil
		for i=1,3 do
			table.insert(pool, SMODS.poll_object({pool = fish_pool, use_bait = fishing_active, current_env = _force_env or G.GAME.fac_fishing_environment}))
		end
		return pool
	end,
	button_key = function (self)
		return "Toggle"
	end
}