G.E_MANAGER.queues.astra_notif_queue = {}
FishAndChips.AstraMissingno = {
	notif_stack = {},
	missingno_quotes = {
		'Breaking News: Kokichi Oma found dead in Tennessee',
		'I want this twink obliterated.',
		'Can we kill this guy?',
		'What if there was a Joker that retriggered?',
		'They\'re doing this to me.',
		'I suppose, hey!',
		'Pokemon Scarlet and Violet!',
		'I\'m fucking dying, please stop doing the Gangnam Style!',
		'You can\'t afford a PC so stop talking.',
		'Woah, he\'s bisexual! I didn\'t know that!',
		'Haha, ha, one!',
		'This is what happens when the red and grey ones combine.',
		'You\'d better hope that they\'re as good at building as they are at eating!',
		'Have you seen my keys?',
		'Tick tock time all dogs keep your fucking puppies in the house',
		'Hey guys, I think I found a glue!',
		'ngl this is definitely me when the',
		'What? What kind of mechanic is THAT?!',
		'Still a better love story than Wedding Dash 3.',
		'Jarona!',
		'Shikanoko nokonoko koshitantan',
		'It would be a really funny prank at a funeral.',
		'Where is kitty?',
		'Suzuki Bakuhatsu.',
		'Oh! Okay...',
		'This shit frying me.',
		'Are we deadass?',
		'Oh my god! He\'s God!',
		'Yeah, a lot of us do, but we don\'t write it on fucking tins.',
		'Versus... FIGHTING POLYGON TEAM!',
		'Oh lord... again? A-fucking-gain?',
		'You can\'t just ask women that question!',
		'No one likes you, not even other British people.',
		'They call it the Doki Doki Literature Club special.',
		'NAME HIM CHUNGY',
		'It\'s me, your best meme.',
		'Can\'t have shit in Detroit.',
		'You got Strep Throat!',
		'Banjo and Kazuya Mishima!',
		'You are going to die in three days.',
		'Fuck you, prepare to die.',
		'Death death was killed, Death dharobob-himobob-himobobobble...',
		'Umm... NORK?',
		'I\'m super cancelled.',
		'He missed guaranteed lethal, what a bozo!',
		'How do you describe your child? (Accident on the road. I left.)',
		'Yoshi will also get high on crack cocaine',
		'If you say 67 in 2026, most people will tell you to shut the fuck up. And if you still say 67, they will beat the shit out of you!',
		'Deltarune 67 theory',
		'Peter, what are you doing? (Crack)',
		'Oh, I see! So that\'s how it\'s going to be!',
		'Outta my way, Meta Knight!',
		'Seven thousand fucking pigeons: eat this man!',
		'They\'re killing me with hammers.',
		'Chinese! Chinese! Chinese! Chinese! Anything goes, even Chinese!',
		'Who gives a Go Next?',
		'Sealed away forever.',
		'SPAMTON G. SPAMTON, THAT\'S MY FUCKING NAME!',
		'TMTrainer major skill issue.',
		'This shit is so ass. Alexa, play Fright Flight!',
		'STOP HITTING ON MY MOM',
		'It\'s funny until it isn\'t anymore.',
		'D\'oh, I missed!',
		'Yippee!',
		'SeeU in hell!',
		'My wife left me!',
		'I don\'t care. I\'m also leaving.',
		'I want Petalburg back, Carbon.',
		'Wow, it\'s fucking nothing!',
		'Mr Krabs is dead! WHAAAAT?!',
		'Bubsy is DEAD!!',
		'Hey, women and insects, let\'s go Super Quiz Super 65 Quiz!',
		'Hecking heck now?',
		'THE COMPUTER!!!',
		'Who is this worm looking mf, I like their vibe.',
		'Would you rather have $1 or $2?',
		'Code my Jokers.',
		'This is what I like to call in recycle days: a waste.',
		'Brave Bird! It\'s going DOWN!!',
		'Click on Flare Blitz!',
		'Click on Icicle Crash!',
		'Mental breakdown in the hotpot VC.',
		'I can\'t touch grass, I EATED it all!',
		'Michaelsoft Binbows.',
		'I\'m pissing on the MOOOOOOON!!!',
		'HATSUNE MIKU?! IS THAT YOU???',
		'Mikudayo~',
		'Te-to~',
		'That wasn\'t very funny, Teto. (YOU EAT PEOPLE!!)',
		'JOKES ON YOU DUMBASS, THE CHICKEN HAS GHOST TOO!',
		'Because he is a protagonist from Danganronpa, basically.',
		'Not Aran Ryan! He\'s the last guy I need in this game!',
		'Guh-huh!',
		'Look, it says "fish"!',
		'Five hundred cigarettes.',
		'I\'m committing tax fraud.',
		'IF YOU SAY YOUR MOM, YOU\'RE FIRED!',
		'You\'re mad and I\'m not?',
		'Are you mentally well?',
	}
}

function G.FUNCS.fac_am_notification_click(e)
	local os = love.system.getOS()
	if os == 'OS X' or os == "Windows" or os == 'Linux' then
		love.system.openURL("steam://openurl/https://steamcommunity.com/id/theAstra_/")
	else
		love.system.openURL("https://steamcommunity.com/id/theAstra_/")
	end
	
end

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
				config = { 
					colour = G.C.CLEAR,
					button = 'fac_am_notification_click'
				},
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
	loc_vars = function(self, info_queue, card)
		local quip = pseudorandom_element(FishAndChips.AstraMissingno.missingno_quotes)

		return { vars = { quip } }
	end,
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
