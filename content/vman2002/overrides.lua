-- Variable preparation for Trust
local play_ref = evaluate_play_main
function evaluate_play_main(...)
	G.GAME.fac_trust_active = true
	local ret = {play_ref(...)}
	G.GAME.fac_trust_active = nil
	return unpack(ret)
end

local peepeeTimer = -6e9

SMODS.ScreenShader({
	key = "vman2002_cool_shit",
	path = "vman2002/fluf.fs",
	order = 1e1,
	should_apply = function(self)
		return peepeeTimer + 3 > G.TIMERS.REAL
	end,
	send_vars = function(self)
		local f = (G.TIMERS.REAL - peepeeTimer) / 3
		local fp = math.pow(f, 0.5)
		return {
			fip = (1 - fp) * math.pow(math.min(f * 25, 1), 2),
			expand = fp,
			mixf = 1 - fp
		}
	end
})

local click_ref = Card.click
function Card.click(c, ...)
	if c.ppu_member and c.ppu_member.mod_id == "FishAndChips" and c.ppu_member.name == "VMan_2002" then
		c:juice_up(10, 4)
		for k,v in pairs({"talisman_eechip", "slib_eechips", "payasaka_eechips", "explosion_release1"}) do
			if k == 4 or SMODS.Sounds[v] then
				play_sound(v)
				break
			end
		end
		peepeeTimer = G.TIMERS.REAL
	end
	return click_ref(c, ...)
end