PotatoPatchUtils.Developer{
	name = 'slimestuff',
	atlas = 'fac_cards',
	colour = HEX("FF53A9"),
	fac_partner = 'azazel',
	loc = true,
	calculate = function(self, context)
		-- Putting Chesh here so they can all swarm at once like a pack of hungry piranhas
		if context.fac_end_fishing and not context.failed then
			local f = G.FISHING.fac_fish_reward_area.cards[1]
			local cheshlist = {}
			for i, card in ipairs(SMODS.find_card("fish_fac_tss_chesh")) do
				if SMODS.pseudorandom_probability(card,"fcc_tss_chesh",1,card.ability.extra.odds) then
					cheshlist[#cheshlist+1] = card
				end
			end
			
			if #cheshlist < 1 then return end
			
			f.tss_cheshed = true
			f.states.click.can = false -- Apparently it should be like this already but they forgot. Will remove once that is patched :p
			
			
			-- Move Cheshes to the fish
			for _, v in ipairs(cheshlist) do
				G.E_MANAGER:add_event(Event({trigger = "after", delay = .8/#cheshlist, func=function()
					v.area:remove_card(v)
					G.FISHING.fac_fish_reward_area:emplace(v)
					play_sound("whoosh")
					v.T.w = v.T.w*1.3
					v.T.h = v.T.h*1.3
				return true end}))
			end
			
			for _, v in ipairs(cheshlist) do
				G.E_MANAGER:add_event(Event({trigger = "after", delay = .8/#cheshlist, func=function()
					v:juice_up()
					SMODS.calculate_effect({message = localize("fac_tss_chesh_giggle_"..pseudorandom("fac_tss_chesh_giggle",1,4)), colour = G.C.PURPLE, instant = true}, v)
				return true end}))
			end

			for i = 1, 5 do
				for _, v in ipairs(cheshlist) do
					G.E_MANAGER:add_event(Event({trigger = "after", delay = .8/#cheshlist, func=function()
						v:juice_up()
						f:juice_up()
						play_sound("fac_tss_eat"..pseudorandom("fac_tss_chesh_eat_sfx",1,3))
					return true end}))
				end
			end

			G.E_MANAGER:add_event(Event({trigger = "after", delay = .8, func=function()
				f:juice_up()
				SMODS.destroy_cards(f)
				f:start_dissolve({HEX("917bad")})
				for _, v in ipairs(cheshlist) do
					v.ability.extra.xmult = v.ability.extra.xmult + v.ability.extra.xmult_mod
				end
			return true end}))

			for _, v in ipairs(cheshlist) do
				G.E_MANAGER:add_event(Event({trigger = "after", delay = .8/#cheshlist, func=function()
					v.area:remove_card(v)
					G.fac_fish_area:emplace(v)
					play_sound("fac_tss_burp")
					v.T.w = v.T.w/1.3
					v.T.h = v.T.h/1.3
				return true end}))
			end

		end
	end
}

PotatoPatchUtils.Developer{
	name = 'azazel',
	atlas = 'fac_cards',
	colour = G.C.YELLOW,
	fac_partner = 'slimestuff',
	loc = true
}

SMODS.Atlas{
	key = "tss_fish", -- Please include your name/team name in your atlas keys
	path = "the_s_squad/fish.png",
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