PotatoPatchUtils.Developer{
	name = 'slimestuff',
	atlas = 'fac_tss_devs',
	pos = {x=0,y=0},
	soul_pos = {x=1,y=0},
	colour = HEX("FF53A9"),
	fac_partner = 'azazel',
	loc = true,
	calculate = function(self, context)
		-- Putting Chesh here so they can all swarm at once like a pack of hungry piranhas
		if context.fac_end_fishing and not context.failed then
			local chesh_scale = 1.4
			local chesh_speed = .75

			local f = context.fish_obj or G.FISHING.fac_fish_reward_area.cards[1]
			local cheshlist = {}
			for i, card in ipairs(SMODS.find_card("fish_fac_tss_chesh")) do
				if SMODS.pseudorandom_probability(card,"fcc_tss_chesh",1,card.ability.extra.odds) then
					cheshlist[#cheshlist+1] = card
				end
			end

			if not f or #cheshlist < 1 then return end

			f.tss_cheshed = true
			f.states.click.can = false -- Apparently it should be like this already but they forgot. Will remove once that is patched :p

			-- Move Cheshes to the fish
			for _, v in ipairs(cheshlist) do
				G.E_MANAGER:add_event(Event({trigger = "after", delay = chesh_speed/#cheshlist, func=function()
					v.area:remove_card(v)

					G.FISHING.fac_fish_reward_area:emplace(v)

					local a
					for i, v2 in ipairs(v.area.cards) do
						if v == v2 then a = i break end
					end

					table.remove(G.FISHING.fac_fish_reward_area.cards,a)
					table.insert(G.FISHING.fac_fish_reward_area.cards,v)

					play_sound("whoosh")
					v.T.w = v.T.w*chesh_scale
					v.T.h = v.T.h*chesh_scale
				return true end}))
			end

			for _, v in ipairs(cheshlist) do
				G.E_MANAGER:add_event(Event({trigger = "after", delay = chesh_speed/#cheshlist, func=function()
					v:juice_up()
					SMODS.calculate_effect({message = localize("fac_tss_chesh_giggle_"..pseudorandom("fac_tss_chesh_giggle",1,4)), colour = G.C.PURPLE, instant = true}, v)
				return true end}))
			end

			for i = 1, 5*#cheshlist do
				local v = pseudorandom_element(cheshlist, "fac_tss_chesh_bite")
				G.E_MANAGER:add_event(Event({trigger = "after", delay = chesh_speed/#cheshlist, func=function()
					v:juice_up()
					f:juice_up()
					play_sound("fac_tss_eat"..pseudorandom("fac_tss_chesh_eat_sfx",1,3))
				return true end}))
			end

			G.E_MANAGER:add_event(Event({trigger = "after", delay = chesh_speed, func=function()
				f:juice_up()
				SMODS.destroy_cards(f)
				f:start_dissolve({HEX("917bad")})
				for _, v in ipairs(cheshlist) do
					v.ability.extra.xmult = v.ability.extra.xmult + v.ability.extra.xmult_mod
				end
			return true end}))

			for _, v in ipairs(cheshlist) do
				G.E_MANAGER:add_event(Event({trigger = "after", delay = chesh_speed/#cheshlist, func=function()
					v.area:remove_card(v)
					G.fac_fish_area:emplace(v)
					play_sound("fac_tss_burp")
					v.T.w = v.T.w/chesh_scale
					v.T.h = v.T.h/chesh_scale
				return true end}))
			end

			if #cheshlist>0 then G.E_MANAGER:add_event(Event({trigger = "after", delay = chesh_speed, func=function() return true end})) end
		end
	end,
	fac_dw_shader = true
}

PotatoPatchUtils.Developer{
	name = 'azazel',
	atlas = 'fac_tss_devs',
	pos = {x=2,y=0},
	soul_pos = {x=3,y=0},
	colour = G.C.YELLOW,
	fac_partner = 'slimestuff',
	loc = true,
	fac_dw_shader = true
}

-- Credits shader stuff :3
SMODS.Shader {
	key = 'dev_darkworld', -- Doesn't have team name in as also used by another team :3
	path = 'the_s_squad/dev_darkworld.fs',

	send_vars = function(self, sprite, card)
		local w, h = love.graphics.getDimensions()
		local mx, my = love.mouse.getPosition()
		return {
			mouse_pos = { mx, my },
			t = G.TIMERS.REAL
		}
	end
}

local ppu_front_hook = SMODS.DrawSteps.center.func
SMODS.DrawSteps.center.func = function(card, layer)
	if card.ppu_member and card.ppu_member.fac_dw_shader then
		card.children.center:draw_shader('fac_dev_darkworld', nil, card.ARGS.send_to_shader)
	else
		ppu_front_hook(card, layer)
	end
end

local ppu_floating_sprite_hook = SMODS.DrawSteps.ppu_floating_sprite.func
SMODS.DrawSteps.ppu_floating_sprite.func = function(card, layer)
	if card.ppu_member and card.ppu_member.fac_dw_shader then
		local scale_mod = 0.07 + 0.02 * math.sin(1.8 * G.TIMERS.REAL) +
			0.00 * math.sin((G.TIMERS.REAL - math.floor(G.TIMERS.REAL)) * math.pi * 14) *
			(1 - (G.TIMERS.REAL - math.floor(G.TIMERS.REAL))) ^ 3
		local rotate_mod = 0.05 * math.sin(1.219 * G.TIMERS.REAL) +
			0.00 * math.sin((G.TIMERS.REAL) * math.pi * 5) * (1 - (G.TIMERS.REAL - math.floor(G.TIMERS.REAL))) ^ 2

		card.children.ppu_floating_sprite:draw_shader('fac_dev_darkworld', nil, nil, nil, card.children.center,
			scale_mod, rotate_mod)
	else
		ppu_floating_sprite_hook(card, layer)
	end
end

-- Credits shader stuff :3
SMODS.Shader {
	key = 'tss_uranium', -- Doesn't have team name in as also used by another team :3
	path = 'the_s_squad/uranium.fs'
}

SMODS.ScreenShader {
	key = "fac_tss_uranium",
	shader = "fac_tss_uranium",

	send_vars = function(self, sprite, card)
		local t = G.TIMERS.REAL
		for _, v in ipairs(SMODS.find_card("fish_fac_tss_uranium")) do
			t = math.min(t,v.ability.extra.pickup)
		end

		local w,h = love.graphics.getDimensions()
		return {
			screen_dims = {w,h},
			t = G.TIMERS.REAL-t-10
		}
	end,
	should_apply = function(self)
		return #SMODS.find_card("fish_fac_tss_uranium")>0
	end,
	order = 0
}

SMODS.Atlas{
	key = "tss_fish", -- Please include your name/team name in your atlas keys
	path = "the_s_squad/fish.png",
	px = 71,
	py = 95,
}

SMODS.Atlas{
	key = "tss_devs", -- Please include your name/team name in your atlas keys
	path = "the_s_squad/credits.png",
	px = 71,
	py = 95,
}

for i = 1, 3 do
	SMODS.Sound {
		key = 'tss_eat'..i,
		path = 'the_s_squad/eat'..i..'.ogg',
		volume = 1
	}
end
	
SMODS.Sound {
	key = 'tss_burp',
	path = 'the_s_squad/burp.ogg',
	volume = 1
}