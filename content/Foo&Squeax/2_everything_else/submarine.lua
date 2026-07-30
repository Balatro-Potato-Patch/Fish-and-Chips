SMODS.Shader{
	key = "fas_water",
	path = FishAndChips.FooSqueax.file_path .. "water.fs",
	send_vars = function (sprite, card)
		return {
			water_height = G.GAME.fac_FooSqueax.bucket.water_height
		}
	end
}
SMODS.Shader{
	key = "fas_water_card",
	path = FishAndChips.FooSqueax.file_path .. "water_card.fs",
	send_vars = function (sprite, card)
		return {
			water_height = G.GAME.fac_FooSqueax.bucket.water_height
		}
	end
}

local fishandchips_mod_reset_game_globals_ref = FishAndChips.mod.reset_game_globals
---@diagnostic disable-next-line: duplicate-set-field
function FishAndChips.mod.reset_game_globals (run_start)
---@diagnostic disable-next-line: need-check-nil
	fishandchips_mod_reset_game_globals_ref(run_start)
	if run_start then
		G.GAME.fac_FooSqueax = {
			bucket = {
				on = false,
				water_height = 1
			}
		}
	end
end

function FishAndChips.FooSqueax.toggle_bucket_shader()
	if not FishAndChips then return end
	G.GAME.fac_FooSqueax.bucket.on = not G.GAME.fac_FooSqueax.bucket.on
	if G.GAME.fac_FooSqueax.bucket.on then
		ease_value(G.GAME.fac_FooSqueax.bucket, "water_height", -1.1, nil, nil, nil, 20)
		G.fac_fishing_bucket_top.definition.nodes[1].config.shader = "fac_fas_water"
		G.fac_fishing_bucket_bottom.definition.nodes[1].config.shader = "fac_fas_water"
	else
		ease_value(G.GAME.fac_FooSqueax.bucket, "water_height", 1.1, nil, nil, nil, 20)
		G.E_MANAGER:add_event(Event{
			blocking = false,
			func = function()
				if G.GAME.fac_FooSqueax.bucket.water_height < 1 and not G.GAME.fac_FooSqueax.bucket.on then return false end
				G.fac_fishing_bucket_top.definition.nodes[1].config.shader = nil
				G.fac_fishing_bucket_bottom.definition.nodes[1].config.shader = nil
				return true
			end
		})
	end
end

FishAndChips.Fish{
	key = "fas_submarine",
	ppu_coder = {"Foo54"},
	weight = 10,
	environments = {
		pier = 1,
		backroom = 0.4,
		aquifer = 0.01
	},
	can_use = function (self, card)
		return true
	end,
	keep_on_use = function (self, card)
		return true
	end,
	update = function (self, card, dt)
		if G.GAME.fac_FooSqueax.bucket.on then
			G.fac_fishing_bucket_top.definition.nodes[1].config.shader = "fac_fas_water"
			G.fac_fishing_bucket_bottom.definition.nodes[1].config.shader = "fac_fas_water"
		end
	end,
	use = function(self, card)
		FishAndChips.FooSqueax.toggle_bucket_shader()
	end,
}

SMODS.DrawStep{
	key = "fas_submarine",
	order = 25,
	func = function (card, layer)
		if card.config.center.key == "fish_fac_fas_submarine" then
			card.children.center:draw_shader("fac_fas_water_card", nil, card.ARGS.send_to_shader)
		end
	end
}