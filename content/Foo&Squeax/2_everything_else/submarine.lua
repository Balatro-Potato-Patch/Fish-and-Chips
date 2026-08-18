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
			water_height = G.GAME.fac_FooSqueax and G.GAME.fac_FooSqueax.bucket.water_height or 0.1
		}
	end
}

function FishAndChips.FooSqueax.toggle_bucket_shader()
	if not FishAndChips then return end
	G.GAME.fac_FooSqueax.bucket.on = not G.GAME.fac_FooSqueax.bucket.on
	if G.GAME.fac_FooSqueax.bucket.on then
		G.GAME.fac_FooSqueax.bucket.water_height = 1
		ease_value(G.GAME.fac_FooSqueax.bucket, "water_height", -1.1, nil, nil, nil, 20)
		G.fac_fishing_bucket_top.definition.nodes[1].config.shader = "fac_fas_water"
		G.fac_fishing_bucket_bottom.definition.nodes[1].config.shader = "fac_fas_water"
	else
		G.GAME.fac_FooSqueax.bucket.water_height = -0.1
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
	atlas = "fas_fish_general",
	pos = {x=0,y=0},
	pixel_size = {w=70,h=87},
	ppu_coder = {"Foo54"},
	ppu_artist = {"squeax09"},
	badge_key = "k_fac_fas_submarine",
	weight = 5,
	attributes = {"retrigger", "joker", "debuff"},
	disable_visual_scaling = true,
	environments = {
		pier = 1,
		backroom = 0.4,
		aquifer = 0.01
	},
	stats = {
		length = {min = 165, max = 175},
		weight = {min = 2000000, max = 18000000, units = {format = "k_fac_fas_tonne", scale = 1000, precision = 0}}
	},
	config = {
		extra = {
			repetitions = 2,
		}
	},
	loc_vars = function(self, info_queue, card)
		return {vars = {card.ability.extra.repetitions, localize(G.GAME.fac_FooSqueax and G.GAME.fac_FooSqueax.bucket.on and "k_fac_fas_submerged" or "k_fac_fas_unsubmerged")}}
	end,
	can_use = function (self, card)
		return G.STATE ~= G.STATES.SHOP
	end,
	keep_on_use = function (self, card)
		return true
	end,
	update = function (self, card, dt)
		if G.GAME.fac_FooSqueax and G.GAME.fac_FooSqueax.bucket.on then
			G.fac_fishing_bucket_top.definition.nodes[1].config.shader = "fac_fas_water"
			G.fac_fishing_bucket_bottom.definition.nodes[1].config.shader = "fac_fas_water"
		end
	end,
	remove_from_deck = function (self, card, from_debuff)
		if G.GAME.fac_FooSqueax.bucket.on then
			FishAndChips.FooSqueax.toggle_bucket_shader()
			SMODS.calculate_effect({message = localize("k_fac_fas_resurface"), colour = G.C.BLUE}, card)
			for _, _card in ipairs(G.jokers.cards) do
				SMODS.debuff_card(_card, false, "fac_fas_submarine")
			end
		end
	end,
	use = function(self, card)
		FishAndChips.FooSqueax.toggle_bucket_shader()
		SMODS.calculate_effect({message = localize(G.GAME.fac_FooSqueax.bucket.on and "k_fac_fas_dive" or "k_fac_fas_resurface"), colour = G.C.BLUE}, card)
		for _, _card in ipairs(G.jokers.cards) do
			SMODS.debuff_card(_card, G.GAME.fac_FooSqueax.bucket.on, "fac_fas_submarine")
		end
	end,
	calculate = function(self, card, context)
		if G.GAME.fac_FooSqueax.bucket.on then
			if context.card_added and not context.blueprint then
				if context.card.config.center.set == "Joker" then
					SMODS.debuff_card(context.card, true, "fac_fas_submarine")
				end
			end
			if context.retrigger_joker_check and context.other_card and context.other_card.config.center.set == "fac_Fish" then
				return {
					repetitions = card.ability.extra.repetitions
				}
			end
		end

		if context.starting_shop and G.GAME.fac_FooSqueax.bucket.on then
			card.ability.extra.should_resume_debuff = true
			FishAndChips.FooSqueax.toggle_bucket_shader()
			SMODS.calculate_effect({message = localize(G.GAME.fac_FooSqueax.bucket.on and "k_fac_fas_dive" or "k_fac_fas_resurface"), colour = G.C.BLUE}, card)
			for _, _card in ipairs(G.jokers.cards) do
				SMODS.debuff_card(_card, G.GAME.fac_FooSqueax.bucket.on, "fac_fas_submarine")
			end
		end

		if context.ending_shop and card.ability.extra.should_resume_debuff then
			card.ability.extra.should_resume_debuff = nil
			FishAndChips.FooSqueax.toggle_bucket_shader()
			SMODS.calculate_effect({message = localize(G.GAME.fac_FooSqueax.bucket.on and "k_fac_fas_dive" or "k_fac_fas_resurface"), colour = G.C.BLUE}, card)
			for _, _card in ipairs(G.jokers.cards) do
				SMODS.debuff_card(_card, G.GAME.fac_FooSqueax.bucket.on, "fac_fas_submarine")
			end
		end
	end,
}

SMODS.DrawStep{
	key = "fas_submarine",
	order = 25,
	func = function (card, layer)
		if card.config.center.key == "fish_fac_fas_submarine" then
			if not (card.area and card.area.config.fac_compendium) then
				card.children.center:draw_shader("fac_fas_water_card", nil, card.ARGS.send_to_shader)
			else
				local fish_data = G.PROFILES[G.SETTINGS.profile].fac_fishing.fish_data[card.config.center_key] or {}
				if (fish_data.times_caught and fish_data.times_caught > 0) then
					card.children.center:draw_shader("fac_fas_water_card", nil, card.ARGS.send_to_shader)
				end
			end
		end
	end
}
