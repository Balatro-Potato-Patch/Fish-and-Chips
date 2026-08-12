FishAndChips.TheShitSquad.syslist = {}
local json = require("json")
local https = require("SMODS.https")
local last_update_time = 0
local initial = true
local attempt_count = 0

local function update_syslist(code, body, headers)
	--print(#body)
	if body and #body>0 then
		attempt_count = 0
		local list = json.decode(body)
		for i, member in ipairs(list) do
			member.colour = member.colour and HEX(member.colour) or nil
			
			if member.gradient then
				for i, c in ipairs(member.gradient) do
					member.gradient[i] = c and HEX(c) or nil
				end
				--print("Creating effect for "..member.name)
				member.effect = SMODS.DynaTextEffect{
					key = "ellesys_"..member.name,
					func = function(dynatext, index, letter)
						local t = (G.TIMERS.REAL*3.75 + index) * 0.84 / (member.gradient_len or 1)
						letter.colour = mix_colours(member.gradient[math.ceil(t)%#member.gradient+1], member.gradient[math.floor(t)%#member.gradient+1],t%1)
					end
				}
			end
		end

		FishAndChips.TheShitSquad.syslist = list
	else
		attempt_count = attempt_count+1
		if attempt_count<4 then FishAndChips.TheShitSquad.get_syslist() end
	end
end
function FishAndChips.TheShitSquad.get_syslist()
	--print(https)
	if https and https.asyncRequest then
		--print("Making Request")
		initial = false
		last_update_time = os.time()
		https.asyncRequest(
			"https://ellestuff.dev/plurality.json",
			update_syslist
		)
	end
end
G.E_MANAGER:add_event(Event{func=function()
	FishAndChips.TheShitSquad.get_syslist()
return true end})

function FishAndChips.TheShitSquad.generate_syslist_ui(list)
	local text = {}
	for i = 1, 2 do
		for i, v in ipairs(list) do
			text[#text + 1] = {
				n = G.UIT.O,
				config = {
					object = DynaText({ font = SMODS.Fonts.fac_tss_slimelets, string = v.name.." ", text_effect = v.effect and v.effect.key or nil, colours = { v.colour or G.C.WHITE }, silent = true, spacing = 1, scale = 0.297 })
				}
			}
		end
	end
	text[#text + 1] = {n = G.UIT.C}
	local text_content = { n = G.UIT.ROOT, config = { colour = G.C.CLEAR, padding = 0 }, nodes = text }
	local box = SMODS.UIScrollBox({
		content = {
			definition = text_content,
			config = {},
		},
		container = {
			config = {
				can_collide = false
			}
		},
		overflow = {
			node_config = {
				maxw = 4, -- SPECIFY MAX WIDTH YOU WANT HERE
			},
			config = {
				can_collide = false
			}
		},
		sync_mode = "offset",
		scroll_move = function(self, dt)
			local dx = self:get_scroll_distance()
			self.scroll_offset.x = ((self.scroll_offset.x or 0) + G.real_dt) % (self.content_container.T.w/2)
		end,
	})
	return { n=G.UIT.C, config={colour=G.C.BLACK,r=.1}, nodes={{n = G.UIT.O, config = { object = box }}} }
end