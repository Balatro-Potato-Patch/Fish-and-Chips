
SMODS.Atlas{
	key = "fas_bo_noise",
	path = FishAndChips.FooSqueax.file_path .. "bo_noise.png",
	px = 71,
	py = 95,
	atlas_table = "STATE_ATLAS"
}

FishAndChips.Fish {
	key = "fas_super_bo_noise",
	weight = 5,
	environments = {
		aquifer = 1,
		wormhole = 0.5,
	},
	sprite_args = {
		states = {
			wait = {
				start_pos = {x = 0, y = 0},
				frames = 1,
			},
			spin = {
				start_pos = {x = 1, y = 0},
				frames = 13,
				fps = 20,
				exit_to = "wait"
			}
		},
		default_state = "wait"
	},
	ppu_coder = {"Foo54"},
	ppu_artist = {'squeax09'},
	atlas = "fas_bo_noise",
	pos = {x=0,y=0},
	config = {
		extra = {
			xmult = 0.01
		}
	},
	stats = {
		length = {min = 5, max = 5},
		weight = {min = 5, max = 5}
	},
	disable_visual_scaling = true,
	attributes = {"modify_card", "xmult"},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.xmult } }
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play then
			context.other_card.ability.perma_x_mult = (context.other_card.ability.perma_x_mult or 0) + card.ability.extra.xmult
			return {
				message = localize('k_upgrade_ex'),
				func = function()
					G.E_MANAGER:add_event(Event{
						func = function()
							card:set_sprite_state("spin")
							return true
						end
					})
				end,
				colour = G.C.MULT
			}
		end
	end
}