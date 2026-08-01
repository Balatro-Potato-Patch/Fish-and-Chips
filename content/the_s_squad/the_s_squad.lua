FishAndChips.TheShitSquad = {
	swoon_timer = 0,
	swoon_text_timer = 0,
	force_swoon = false
}

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
			--f.states.click.can = false -- Apparently it should be like this already but they forgot. Will remove once that is patched :p

			if FishAndChips.TheShitSquad.force_swoon or pseudorandom("fac_tss_chesh_swoon",1,225)==1 or os.date("%m%d",os.time()) == "1225" then
				FishAndChips.TheShitSquad.force_swoon = false
				G.E_MANAGER:add_event(Event({func=function()
					FishAndChips.TheShitSquad.swoon_timer = 4
					play_sound("fac_tss_swoon_knight_cut2", .06, 8)
					play_sound("fac_tss_swoon_knight_cut2", .1, 8)
					play_sound("fac_tss_swoon_knight_cut2", .12, 8)
					play_sound("fac_tss_swoon_knight_cut2", .18, 8)
					play_sound("fac_tss_swoon_knight_cut2", .24, 8)
					
					for _, v in ipairs(cheshlist) do
						v.area:remove_card(v)
						G.FISHING.fac_fish_reward_area:emplace(v)
					end
					SMODS.destroy_cards(f)
				return true end}))

				G.E_MANAGER:add_event(Event({func=function() return FishAndChips.TheShitSquad.swoon_timer == 0 end}))
				G.E_MANAGER:add_event(Event({func=function()
					play_sound("fac_tss_swoon_impact")
					play_sound("fac_tss_swoon_closet_impact")
					play_sound("fac_tss_swoon_closet_impact", .5)
					play_sound("fac_tss_swoon_bageldefeat", .8, .8)
					play_sound("fac_tss_swoon_damage")
					play_sound("fac_tss_swoon_glassbreak", .4, .8)
					play_sound("fac_tss_swoon_glassbreak", .3, .6)
					FishAndChips.TheShitSquad.swoon_text_timer = 5
				return true end}))
				
				G.E_MANAGER:add_event(Event({func=function()
					for _, v in ipairs(cheshlist) do
						G.E_MANAGER:add_event(Event({func=function()
							v.area:remove_card(v)
							G.fac_fish_area:emplace(v)
						return true end}))
					end
				return true end}))
				
				return
			end

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
		end
	end,
	fac_dw_shader = true
}

PotatoPatchUtils.Developer{
	name = 'azazel',
	atlas = 'fac_tss_devs',
	pos = {x=2,y=0},
	soul_pos = {x=3,y=0},
	colour = HEX("850021"),
	fac_partner = 'slimestuff',
	loc = true,
	fac_dw_shader = true
}


-- Update hook :)
if not love.update then function love.update(dt) end end
local update_hook = love.update
function love.update(dt)
	update_hook(dt)
	if FishAndChips.TheShitSquad.swoon_timer>0 then FishAndChips.TheShitSquad.swoon_timer = math.max(FishAndChips.TheShitSquad.swoon_timer - dt,0) end
end

if not love.mousepressed then function love.mousepressed(x, y, button, istouch, presses) end end
local click_hook = love.mousepressed
function love.mousepressed(x, y, button, istouch, presses)
	if FishAndChips.TheShitSquad.swoon_timer>0 then return end
	click_hook(x, y, button, istouch, presses)
end

local swoon_img = love.graphics.newImage(love.image.newImageData(SMODS.NFS.newFileData(SMODS.current_mod.path ..
	"assets/the_s_squad/swoon.png")))

if not love.draw then function love.draw() end end
local draw_hook = love.draw
function love.draw()
	if FishAndChips.TheShitSquad.swoon_timer>0 then
		love.graphics.clear(0,0,0)
		local w,h = love.graphics.getDimensions()
		local iw,ih = swoon_img:getDimensions()
		love.graphics.setColor(1,1,1)
		love.graphics.draw(swoon_img,w/2,h/2,0,3,3,iw/2,ih/2)
	else draw_hook() end
end

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
		return not FishAndChips.mod.config.disable_flashing and #SMODS.find_card("fish_fac_tss_uranium")>0
	end,
	order = 0
}

SMODS.Atlas{
	key = "tss_ellefish",
	path = "the_s_squad/ellefish.png",
	px = 71,
	py = 95,
}

SMODS.Atlas{
	key = "tss_azfish",
	path = "the_s_squad/azfish.png",
	px = 112,
	py = 112,
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
	path = 'the_s_squad/burp.ogg'
}

SMODS.Sound {
	key = 'tss_swoon_bageldefeat',
	path = 'the_s_squad/swoon/bageldefeat.wav'
}

SMODS.Sound {
	key = 'tss_swoon_closet_impact',
	path = 'the_s_squad/swoon/closet_impact.ogg'
}

SMODS.Sound {
	key = 'tss_swoon_damage',
	path = 'the_s_squad/swoon/damage.wav'
}

SMODS.Sound {
	key = 'tss_swoon_glassbreak',
	path = 'the_s_squad/swoon/glassbreak.wav'
}

SMODS.Sound {
	key = 'tss_swoon_impact',
	path = 'the_s_squad/swoon/impact.wav'
}

SMODS.Sound {
	key = 'tss_swoon_knight_cut2',
	path = 'the_s_squad/swoon/knight_cut2.wav'
}