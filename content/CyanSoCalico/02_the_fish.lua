-- I see G.FORCE_BOSS in the code but I'm afraid to touch that so hopefully an imitation using the same logic will suffice and not cause any complications

local new_boss_hook = get_new_boss
function get_new_boss()
    if G.FAC_csc_force_fish then
		return "bl_fish"
	end
    return new_boss_hook()
end

FishAndChips.Fish {
	key = "csc_the_fish",
	atlas = "csc_fish",
	pos = { x = 1, y = 0},
	badge_key = "k_fac_csc_blind",

	ppu_coder = { "CyanSoCalico" },
	ppu_artist = { "CyanSoCalico" },

	attributes = { "usable", "boss_blind" },
	config = {
		extra = {
			blind = "bl_fish"
		}
	},

	stats = {
		weight = {
			min = 0.00001,
			max = 0.0004
		},
		length = {
			min = 0.00075,
			max = 0.0025
		}
	},

    weight = 10,
	environments = {
		wormhole = 10,
		styx = 0.1
	},

	blueprint_compat = false,
	eternal_compat = false,
--	treasure = true,

	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_BLINDS[card.ability.extra.blind]
		return { vars = { card.ability.extra.blind } }
	end,

	in_pool = function(self, args)
		return G and G.GAME and G.GAME.round_resets and G.GAME.round_resets.blind_choices
		and G.GAME.round_resets.blind_choices.Boss ~= self.config.extra.blind
	end,

	add_to_deck = function(self, card, from_debuff)
		G.GAME.banned_keys[card.ability.extra.blind] = true
	end,
	remove_from_deck = function(self, card, from_debuff)
		G.GAME.banned_keys[card.ability.extra.blind] = nil
		local loop = 1
		for k, v in pairs(G.GAME.bosses_used.boss) do
--			loop = v > loop and v or loop
--			if G.P_BLINDS[k].boss.min == G.P_BLINDS[card.ability.extra.blind].boss.min and v > loop then
--				loop = v
--			end
			loop = G.P_BLINDS[k].boss.min == G.P_BLINDS[card.ability.extra.blind].boss.min and v > loop and v or loop
		end
		G.GAME.bosses_used.boss[card.ability.extra.blind] = loop
	end,

    can_use = function(self, card)
        return not (G.GAME.blind and G.GAME.blind.in_blind and G.GAME.blind.boss) and not SMODS.is_showdown_ante()
    end,

    use = function(self, card, area)
        -- Referencing VanillaRemade's Boss Tag code
        local lock = card.ID
        G.CONTROLLER.locks[lock] = true
        G.FAC_csc_force_fish = true
        G.from_boss_tag = true
        G.FUNCS.reroll_boss()
        G.E_MANAGER:add_event(Event({
            func = function()
                G.E_MANAGER:add_event(Event({
                    func = function()
                        G.CONTROLLER.locks[lock] = nil
						G.FAC_csc_force_fish = nil
		-- Known issue: if you reload the run right after using this Fish, the reroll will be saved but the Fish being used up won't.
		-- I don't know if there's anything I can do about this?
						save_run()
                        return true
                    end
                }))
                return true
            end
        }))
    end
}
