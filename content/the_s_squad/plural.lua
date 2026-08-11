FishAndChips.TheShitSquad.syslist = {}
local json = require("json")
local https = require("SMODS.https")
local last_update_time = 0
local initial = true

local function update_syslist(code, body, headers)
	print(#body)
    if body and #body>0 then
		local list = json.decode(body)

		for i, member in ipairs(list) do
			member.colour = member.colour and HEX(member.colour) or nil
			
			if member.gradient then
				for i, c in ipairs(member.gradient) do
					member.gradient[i] = c and HEX(c) or nil
				end
				print("Creating effect for "..member.name)
				member.effect = SMODS.DynaTextEffect{
					key = "ellesys_"..member.name,
					func = function(dynatext, index, letter)
						local t = (G.TIMERS.REAL*3.75 + index) *0.84
						letter.colour = mix_colours(member.gradient[math.ceil(-t)%#member.gradient+1], member.gradient[math.floor(-t)%#member.gradient+1],-t%1)
					end
				}
			end
		end

		FishAndChips.TheShitSquad.syslist = list
	end
end
function FishAndChips.TheShitSquad.get_syslist()
    print(https)
	if https and https.asyncRequest then
		if (os.time() - last_update_time >= 60) or initial then
            print("Making Request")
			initial = false
			last_update_time = os.time()
			https.asyncRequest(
				"https://ellestuff.dev/plurality.json",
				update_syslist
			)
		end
	end
end
G.E_MANAGER:add_event(Event{func=function()
	FishAndChips.TheShitSquad.get_syslist()
return true end})