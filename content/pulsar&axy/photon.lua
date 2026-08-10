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
	-- draw = function(self, card, layer)
	-- 	if self.discovered or card.params.bypass_discovery_center then
	-- 		card.children.center:draw_shader(self.config.center.shader, nil, card.ARGS.send_to_shader)
	-- 	end
	-- end,
	shader = 'pa_photon',
}

SMODS.Shader{
	key = 'pa_photon',
	path = "pulsar&axy/pa_photon.fs",
	send_vars = function(sprite, card)
		local display_value = card and card.ability and card.ability.stats and card.ability.stats.length / card.ability.stats.units.length.scale or 0
		display_value = tonumber(string.format('%.0f', display_value))
		return {
			fish_length = display_value,
			pa_photon = {card.ability.stats.units.length, 0}
		}
	end,
}