SMODS.Shader{
	key = 'pa_photon',
	path = "pulsar&axy/pa_photon.fs",
	send_vars = function(sprite, card)
		local display_value = card and card.ability and card.ability.stats and card.ability.stats.length / card.ability.stats.units.length.scale or 0
		display_value = tonumber(string.format('%.0f', display_value))
		return {
			fish_length = display_value
		}
	end,
}

FishAndChips.Fish {
	key = "pa_photon",
	weight = 1,
	atlas = "pa_pulsarfish",
	pos = { x = 1, y = 3 },
	ppu_artist = { "Pulsar" },
	ppu_coder = { "Axy" },
	attributes = { "generation", "skip", "tag" },
	environments = {
		wormhole = 1,
	},
	stats = {
		length = {min = 38e-8, max = 74e-8, units = { format = "nm_format", scale = 1e-9, precision = 4}},
		weight = {min = 0, max = 0}
	},
	blueprint_compat = true,
	config = {
		extra = {
			tags = 2
		}
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.tags } }
	end,
	calculate = function(self, card, context)
        -- give two random tags when a blind is skipped_rank
        if context.skip_blind then
            for i=1,card.ability.extra.tags do
                local tag = Tag(pseudorandom_element(G.P_TAGS).key)
                tag:set_ability()
                add_tag(tag)
            end
        end
	end,
	set_sprites = function(self, card, front)
		local position = 1
		local fish_length = card and card.ability and card.ability.stats and card.ability.stats.length / card.ability.stats.units.length.scale or 500
		fish_length = tonumber(string.format('%.0f', fish_length))
		if fish_length > 625 then
			position = 0
		elseif fish_length > 590 then
			position = 1
		elseif fish_length > 565 then
			position = 2
		elseif fish_length > 520 then
			position = 3
		elseif fish_length > 500 then
			position = 4
		elseif fish_length > 435 then
			position = 5
		elseif fish_length >= 380 then
			position = 6
		end

		if position then
			card.children.center:set_sprite_pos({x = position, y = 4})
		end
	end,
	draw = function(self, card, layer)
		if self.discovered or card.params.bypass_discovery_center then
			card.children.center:draw_shader('booster', nil, card.ARGS.send_to_shader)
		end
	end,
	-- shader = 'pa_photon',
}
