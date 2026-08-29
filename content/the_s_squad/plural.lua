FishAndChips.TheShitSquad.syslist = {{name="elle.",colour="ff53a9"},{name="Emily"},{name="Amber",colour="83E858"},{name="Umbra",colour="B0C3F5"},{name="Sara",colour="69CEFF"},{name="Suzy",colour="C189D4"},{name="Ash",gradient={"FF5173","FFA967","FFF886","97FF61","9EEFFF","7896FE","CD9AFF","FF72CE"}},{name="Rebecca",colour="FFA837"},{name="Amy",colour="FF9BDE"},{name="Cass",colour="97FF61"},{name="???",gradient_len=3,gradient={"766A70","BD91CD"}},{name="Amity",colour="B25E6E"}}
local function update_syslist(list)
	for _, member in ipairs(list) do
		member.colour = member.colour and HEX(member.colour) or nil

		if member.gradient then
			for i, c in ipairs(member.gradient) do
				member.gradient[i] = c and HEX(c) or nil
			end
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
end

update_syslist(FishAndChips.TheShitSquad.syslist)

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
