FishAndChips.Fish{
	key = "fas_isreal", -- Asriel -> Ralsei -> Isreal
	weight = 5,
	ppu_coder = {"Foo54"},
	stats = {
		weight = {min = 5, max = 5},
		length = {min = 5, max = 5}
	},
	environments = {
		aquifer = 1,
		wormhole = 1,
		styx = 0.5,
	},
	disable_visual_scaling = true,
	config = {
		extra = {
			mult = 1
		}
	},
	update = function(self, card, dt)
		if G.TIMERS.REAL - (card.fac_last_stored or 0) >= 0.005 then
			card.fac_past_pos = card.fac_past_pos or {}
			card.fac_past_pos[#card.fac_past_pos+1] = copy_table(card.VT)
			if #card.fac_past_pos > 11 then
				table.remove(card.fac_past_pos, 1)
			end
			card.fac_last_stored = G.TIMERS.REAL
		end
	end,
	loc_vars = function(self, info_queue, card)
		return {vars = {card.ability.extra.mult, card.ability.extra.mult * SMODS.table_size(G.GAME.fac_FooSqueax and G.GAME.fac_FooSqueax.fish_caught or {})}}
	end,
	calculate = function (self, card, context)
		if context.joker_main then
			return {
				mult = card.ability.extra.mult * SMODS.table_size(G.GAME.fac_FooSqueax.fish_caught)
			}
		end
	end
}

SMODS.Shader{
	key = "fas_isreal",
	path = FishAndChips.FooSqueax.file_path .. "isreal.fs",
	send_vars = function (sprite, card)
		return {
---@diagnostic disable-next-line: undefined-field, need-check-nil
			i = card.fac_fas_i
		}
	end
}

SMODS.DrawStep {
	key = 'fas_isreal',
	order = -11,
	func = function(self, layer)
		if self.config.center.key == "fish_fac_fas_isreal" or (self.config.center.key == "c_base" and self.ppu_member == PotatoPatchUtils.Developers.fac_Foo54 or self.fac_fas_do_shader) then
			local slightly_bigger = 0
			if self.config.center.key == "c_base" and self.ppu_member == PotatoPatchUtils.Developers.fac_Foo54 or self.fac_fas_do_shader then
				slightly_bigger = 0.2
				if G.TIMERS.REAL - (self.fac_last_stored or 0) >= 0.005 then
					self.fac_past_pos = self.fac_past_pos or {}
					self.fac_past_pos[#self.fac_past_pos+1] = copy_table(self.VT)
					if #self.fac_past_pos > 11 then
						table.remove(self.fac_past_pos, 1)
					end
					self.fac_last_stored = G.TIMERS.REAL
				end
			end
			for i = #(self.fac_past_pos or {}), 2, -1 do
				self.fac_fas_i = i - 1
				local offset = self.fac_past_pos[i]
				--thx AllUniversal and Ruby/Jade for help
				self.children.center:draw_shader('fac_fas_isreal', nil, self.ARGS.send_to_shader, true, self.children.center, offset.h / G.CARD_H + slightly_bigger - 1 + (i / 90 * (1 + math.sin(G.TIMERS.REAL + i))), offset.r - self.VT.r, offset.x - self.VT.x, offset.y - self.VT.y)
			end
		end
	end,
	conditions = { vortex = false, facing = 'front' },
}

