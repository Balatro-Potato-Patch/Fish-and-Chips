G.E_MANAGER.queues.astra_notif_queue = {}
FishAndChips.AstraMissingno = {
	notif_stack = {}
}

PotatoPatchUtils.Developer({
	name = 'theAstra',
	atlas = 'fac_astra-missingno-credits',
	pos = { x = 1, y = 0 },
	loc = true,
	colour = HEX('8710c7'),
	fac_partner = 'fac_MissingNo',
	click = function(self)
		play_sound('fac_am_astra_click')
		self:juice_up(0.1, 0.1)

		local notif = UIBox {
			definition = {
				n = G.UIT.ROOT,
				config = { colour = G.C.CLEAR, },
				nodes = {
					{
						n = G.UIT.O,
						config = {
							object = SMODS.create_sprite(0, 0, 3.99, 1, "fac_astra-missingno-notification", { x = 0, y = 0 }),
						},
					},
				},
			},
			config = {
				align = "br",
				offset = { y = 1, x = -2.5 },
				major = G.ROOM_ATTACH,
				bond = "weak",
				instance_type = 'POPUP'
			}
		}
		
		table.insert(FishAndChips.AstraMissingno.notif_stack, notif)
		for _, v in pairs(FishAndChips.AstraMissingno.notif_stack) do
			ease_value(v.alignment.offset, 'y', v == notif and -1.25 or -1)
		end

		G.E_MANAGER:add_event(Event({
			delay = 6,
			trigger = 'after',
			blockable = false,
			func = function()
				ease_value(notif.alignment.offset, 'y', 1 - notif.alignment.offset.y)
				for i = 1, #FishAndChips.AstraMissingno.notif_stack do
					if FishAndChips.AstraMissingno.notif_stack[i] == notif then
						table.remove(FishAndChips.AstraMissingno.notif_stack, i)
						break
					end
				end
				return true;
			end
		}, "astra_notif_queue"))

		G.E_MANAGER:add_event(Event({
			delay = 0.25,
			trigger = 'after',
			func = function()
				notif:remove()
				notif = nil
				return true;
			end
		}, "astra_notif_queue"))
	end
})

SMODS.Gradient({
	key = "am_missingno_rainbow",
	cycle = 1,
	colours = {
		HEX("FFB0B2"),
		HEX("FFD7B0"),
		HEX("FFFAB0"),
		HEX("BFFFB0"),
		HEX("B0FFED"),
		HEX("B0E7FF"),
		HEX("B0B0FF"),
		HEX("E0B0FF"),
	},
})

PotatoPatchUtils.Developer({
	name = 'MissingNo',
	atlas = 'fac_astra-missingno-credits',
	pos = { x = 0, y = 0 },
	loc = true,
	colour = SMODS.Gradients["fac_am_missingno_rainbow"],
	fac_partner = 'fac_theAstra',
	click = function(self)
		play_sound('generic1')
		love.system.openURL("https://www.youtube.com/@copykeys")
	end
})

SMODS.Atlas({
	key = "astra-missingno-fish",
	path = "astra-missingno/fish.png",
	px = 71,
	py = 95,
})

SMODS.Atlas({
	key = "astra-missingno-credits",
	path = "astra-missingno/credits.png",
	px = 71,
	py = 95,
})

SMODS.Atlas({
	key = 'astra-missingno-notification',
	path = "astra-missingno/notification.png",
	px = 351,
	py = 88,
})

for i = 1, 3 do
	SMODS.Sound {
		key = 'am_shrimp_' .. i,
		path = 'astra-missingno/am_shrimp_' .. i .. '.ogg'
	}
end

SMODS.Sound {
	key = 'am_jerry_intro',
	path = 'astra-missingno/am_jerry_intro.ogg'
}

SMODS.Sound {
	key = 'am_jerry_chips',
	path = 'astra-missingno/am_jerry_chips.ogg',
}

SMODS.Sound {
	key = 'am_chomp',
	path = 'astra-missingno/am_chomp.ogg'
}

SMODS.Sound {
	key = 'am_le_fishe',
	path = 'astra-missingno/am_le_fishe.ogg'
}

SMODS.Sound {
	key = 'am_le_fishe_death',
	path = 'astra-missingno/am_le_fishe_death.ogg'
}

SMODS.Sound {
	key = 'am_astra_click',
	path = 'astra-missingno/am_astra_click.ogg',
	volume = 1
}
