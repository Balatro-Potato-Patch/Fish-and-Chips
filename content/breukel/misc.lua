PotatoPatchUtils.Developer({
	name = 'Breuhh',
	atlas = 'fac_breukel_credit',
	colour = HEX("ac4dff"),
	pos = {x = 0, y = 0},
	fac_partner = 'Comykel'
})

PotatoPatchUtils.Developer({
	name = 'Comykel',
	atlas = 'fac_breukel_credit',
	colour = HEX("3e9bb3"),
	pos = {x = 1, y = 0},
	fac_partner = 'Breuhh'
})

SMODS.Atlas({
	key = "fac_breukel_credit",
	path = "breukel/credit.png",
	px = 129,
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
G.fac_Breukel.AddOverTime = function(card, val, func) -- adds val to OverTime if func isn't given. else applies func to OverTime
    if func and func.operator then
        G.GAME.fac_Breukel.OverTime = func.operator(G.GAME.fac_Breukel.OverTime)
    else
        G.GAME.fac_Breukel.OverTime = G.GAME.fac_Breukel.OverTime + val
    end
        
	local check = G.GAME.fac_Breukel.OverTime
    G.GAME.fac_Breukel.OverTime = G.GAME.fac_Breukel.OverTime % (G.GAME.fac_Breukel.MaxOverTime + 1)

	if func and func.display then
		G.E_MANAGER:add_event(Event({
			trigger = "immediate",
			func = function()
				card_eval_status_text(card, 'extra', nil, nil, nil, {message = func.display, colour = G.C.FAC_BREUKEL_OVERTIME})
			return true end,
		}))
	else
		G.E_MANAGER:add_event(Event({
			trigger = "immediate",
			func = function()
				card_eval_status_text(card, 'extra', nil, nil, nil, {message = "+" .. val .. " OT!" , colour = G.C.FAC_BREUKEL_OVERTIME})
			return true end,
		}))
	end

	if check ~= G.GAME.fac_Breukel.OverTime then
		G.E_MANAGER:add_event(Event({
			trigger = "immediate",
			func = function()
				card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_reset'), colour = G.C.FAC_BREUKEL_OVERTIME})
			return true end,
		}))	
	end
end

G.fac_Breukel.GetOverTime = function(val)
    if G.GAME and G.GAME.fac_Breukel then
        return G.GAME.fac_Breukel.OverTime, G.GAME.fac_Breukel.MaxOverTime
    end return 0,10
end