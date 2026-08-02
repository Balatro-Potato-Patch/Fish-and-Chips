-- Variable preparation for Trust
local play_ref = evaluate_play_main
function evaluate_play_main(...)
	G.GAME.fac_trust_active = true
	local ret = {play_ref(...)}
	G.GAME.fac_trust_active = false
	return unpack(ret)
end