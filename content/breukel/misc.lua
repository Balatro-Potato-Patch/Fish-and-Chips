--Idk if y'all are gonna check files while playtesting but if you do, could you fix the G.fac_Breukel.AddOverTime bug where it visually adds Overtime after every event has happened. I (Breuhh) have a vacation soon and can't be bothered fixing the bug though I believe SMODS.calculate_individual_effect should work but last time I tried using that for another mod shit just didn't work so I cant be bothered with that then is this the worlds widest file ever for a balatro mod honestly now Im just adding stuff at the end so that this file becomes wide as hell. Whatever please fix the bug

PotatoPatchUtils.Developer({
	name = 'Breuhh',
	atlas = 'fac_breukel_credit',
	colour = HEX("ac4dff"),
	pos = {x = 0, y = 0},
	fac_partner = 'fac_Comykel',
	joint_credits = true
})

PotatoPatchUtils.Developer({
	name = 'Comykel',
	atlas = 'fac_breukel_credit',
	colour = HEX("3e9bb3"),
	pos = {x = 1, y = 0},
	fac_partner = 'fac_Breuhh'
})

SMODS.Atlas({
	key = "fac_breukel_credit",
	path = "breukel/credit.png",
	px = 142,
	py = 95,
})

SMODS.Atlas({
	key = "fac_breukel_fish",
	path = "breukel/fish.png",
	px = 71,
	py = 95,
})

SMODS.Atlas({
	key = "fac_breukel_markerel",
	path = "breukel/markerels.png",
	px = 71,
	py = 95,
})

local ref = FishAndChips.mod.reset_game_globals
FishAndChips.mod.reset_game_globals = function(run_start) 
    if run_start then
        G.GAME.fac_Breukel = G.GAME.fac_Breukel or {}
        G.GAME.fac_Breukel.OverTime = 0
        G.GAME.fac_Breukel.MaxOverTime = 10
    end
    ref(run_start)
end

local overtime_col = SMODS.Gradient {
	key = "fac_breukel_overtime",
	colours = {
		HEX("f28a3f"),
		HEX("6ede49")
	},
	cycle = 3
}
G.C.FAC_BREUKEL_OVERTIME = overtime_col

local old_loc_colour = loc_colour
function loc_colour(_c, _default)
  if _c == "fac_breukel_overtime" then return G.C.FAC_BREUKEL_OVERTIME end
  return old_loc_colour(_c, _default)
end

G.fac_Breukel = {}
G.fac_Breukel.AddOverTime = function(card, val, func) -- adds val to OverTime if func isn't given. else applies func to OverTime. <- Blud aint even using func :skull:
    if func and func.operator then
        G.GAME.fac_Breukel.OverTime = func.operator(G.GAME.fac_Breukel.OverTime)
    else
        G.GAME.fac_Breukel.OverTime = G.GAME.fac_Breukel.OverTime + val
    end
        
	local check = G.GAME.fac_Breukel.OverTime
    if G.GAME.fac_Breukel.OverTime > G.GAME.fac_Breukel.MaxOverTime then
		G.GAME.fac_Breukel.OverTime = G.GAME.fac_Breukel.OverTime % G.GAME.fac_Breukel.MaxOverTime
	end

			if func and func.display then
				card_eval_status_text(card, 'extra', nil, nil, nil, {message = func.display, colour = G.C.FAC_BREUKEL_OVERTIME})
			else
				card_eval_status_text(card, 'extra', nil, nil, nil, {message = "+" .. val .. " OT!" , colour = G.C.FAC_BREUKEL_OVERTIME})
			end
			if check ~= G.GAME.fac_Breukel.OverTime then
				card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_reset'), colour = G.C.FAC_BREUKEL_OVERTIME})
			end
end

G.fac_Breukel.GetOverTime = function(val)
    if G.GAME and G.GAME.fac_Breukel then
        return G.GAME.fac_Breukel.OverTime, G.GAME.fac_Breukel.MaxOverTime
    end return 0,10
end