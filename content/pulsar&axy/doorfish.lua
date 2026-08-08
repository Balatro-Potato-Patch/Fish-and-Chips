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
			blue_streak = 0 -- increment when chips/xchips fish are chosen
		}
	},
	loc_vars = function(self, info_queue, card)
		local card_status = "Inactive"
		local toggle = card.ability.extra.toggle or 0
		if toggle and toggle > 0 then
			card_status = "'" .. localize({ type = 'name_text', set = "fac_Fish", key = card.ability.extra.drawn_fish[toggle].key }) .. "'"
		end
		return { vars = { card.ability.extra.times_used + 1, card_status, colours = {HEX("c3222b")} } }
	end,
	flavour_vars = function(self, info_queue, card)
		return {vars = {colours = {HEX("c3222b")}}}
	end,
	-- draw fish based on rank 0
	-- rotate through four effects: inactive, fish 1/2/3
	-- after successful catch of chosen fish, increase rank and redraw fish based on rank, stop at rank 9
	-- set use cost based on total cost/weight of chosen fish, we have 6 sand dollars per ante
	add_to_deck = function(self, card, from_debuff)
		--draw fish based on rank 0
		card.ability.extra.drawn_fish = self:choose_fish_in_pool(card.ability.extra.times_used)
		local seal_unlocked = G.PROFILES[G.SETTINGS.profile].fac_fishing.fish_data.fish_fac_pa_doorfish and G.PROFILES[G.SETTINGS.profile].fac_fishing.fish_data.fish_fac_pa_doorfish.seal_unlocked
		if seal_unlocked then
			G.E_MANAGER:add_event(Event({
				trigger = 'after',
				func = function()
					card:juice_up(0.3, 0.5)
					card.children.center:set_sprite_pos({x = 6, y = 3})
					return true
				end,
			}))
		end
	end,
	calculate = function(self, card, context)
		if context.fac_environment_changed then
			card.ability.extra.drawn_fish = self:choose_fish_in_pool(card.ability.extra.times_used)
		end

		if context.fac_modify_fishing_profile then
			G.GAME.fac_forced_fish = card.ability.extra.toggle > 0 and card.ability.extra.drawn_fish[card.ability.extra.toggle].key or G.GAME.fac_forced_fish
		end

		if context.fac_end_fishing and context.fish == (card.ability.extra.drawn_fish[card.ability.extra.toggle].key) then
			card.ability.extra.times_used = card.ability.extra.times_used + 1
			local is_blue = context.fish_obj.config.center.attributes and (context.fish_obj.config.center.attributes.chips or context.fish_obj.config.center.attributes.xchips)
			card.ability.extra.blue_streak = is_blue and card.ability.extra.blue_streak + 1 or 0
			card.ability.extra.drawn_fish = self:choose_fish_in_pool(card.ability.extra.times_used)
			card.ability.extra.toggle = 0
		end
	end,
    can_use = function(self, card)
        return true
    end,
	keep_on_use = function(self, card)
		return true
	end,
	use = function(self, card)
		card.ability.extra.toggle = (card.ability.extra.toggle + 1) % 4 -- 0,1,2,3

		local blue_streak = card.ability.extra.blue_streak
		local seal_unlocked = G.PROFILES[G.SETTINGS.profile].fac_fishing
			and G.PROFILES[G.SETTINGS.profile].fac_fishing.fish_data
			and G.PROFILES[G.SETTINGS.profile].fac_fishing.fish_data.fish_fac_pa_doorfish
			and G.PROFILES[G.SETTINGS.profile].fac_fishing.fish_data.fish_fac_pa_doorfish.seal_unlocked
		local sprite_change = seal_unlocked and 3 or (blue_streak >= 7 and 3 or blue_streak >= 3 and 2 or 1)
		G.E_MANAGER:add_event(Event({
			trigger = 'after',
			func = function()
				card:juice_up(0.3, 0.5)
				card.children.center:set_sprite_pos({x = 6, y = sprite_change})
				return true
			end}))
			
		if (not seal_unlocked) and card.ability.extra.blue_streak == 8 then -- change to blue_streak == 8 outside of testing, times_used > 0 during testing
			self:show_seal_unlocked()
		end
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
		
		local fish_data = G.PROFILES[G.SETTINGS.profile].fac_fishing.fish_data
		local seal_unlocked = fish_data and fish_data.fish_fac_pa_doorfish and fish_data.fish_fac_pa_doorfish.seal_unlocked
		local only_treasure = seal_unlocked and card.ability.extra.blue_streak >= 8 and true or nil
		for i=1,3 do
			local chosen_fish = G.P_CENTERS[SMODS.poll_object({
				pool = fish_pool,
				use_bait = fishing_active,
				current_env = _force_env or G.GAME.fac_fishing_environment,
				guaranteed = true,
			})]
			local timeout = 0
			if only_treasure then
				local out_of_time = false
				local fish_is_treasure = (chosen_fish and chosen_fish.treasure)
				while not out_of_time and not fish_is_treasure do
					chosen_fish = G.P_CENTERS[SMODS.poll_object({
						pool = fish_pool,
						use_bait = fishing_active,
						current_env = _force_env or G.GAME.fac_fishing_environment,
						guaranteed = true,
					})]
					timeout = timeout + 1
					out_of_time = timeout >= 15
					fish_is_treasure = (chosen_fish and chosen_fish.treasure)
				end
			end

			table.insert(pool, chosen_fish)
		end

		pool[0] = {key = ''}
		return pool
	end,
	button_key = function (self)
		return "Toggle"
	end,
	show_seal_unlocked = function(self)
		G.GAME.fac_pa_doorfish = 0
		G.E_MANAGER:add_event(Event({
			ease = "lerp",
			trigger = "ease",
			ref_table = G.GAME,
			ref_value = "fac_pa_doorfish",
			ease_to = 1,
			delay = 0.6 * G.SPEEDFACTOR,
			blockable = false,
		}))
		G.E_MANAGER:add_event(Event({
			trigger = 'immediate',
			func = function()
				play_sound('fac_treasure_get')
				return true
			end}))
		G.PROFILES[G.SETTINGS.profile].fac_fishing.fish_data.fish_fac_pa_doorfish.seal_unlocked = true
		G.E_MANAGER:add_event(Event({
			ease = "lerp",
			trigger = "ease",
			ref_table = G.GAME,
			ref_value = "fac_pa_doorfish",
			ease_to = 0,
			delay = 0.6 * G.SPEEDFACTOR,
		}))
	end,
}

local old_draw_ref = Game.draw
function Game:draw(...)
	old_draw_ref(self, ...)
	if G and G.GAME and G.GAME.fac_pa_doorfish then
			local image = SMODS.Atlases.fac_pa_doorfish.image
			local w, h = image:getDimensions()
			local sx = 5
			local sy = 5
			local width = love.graphics:getWidth() / 2 - (w * sx) / 2
			local height = love.graphics:getHeight() / 2 - (h * sy) / 2

			love.graphics.setColor(1,1,1,G.GAME.fac_pa_doorfish)
			love.graphics.draw(image, width, height, 0, sx, sy)
	end
end
