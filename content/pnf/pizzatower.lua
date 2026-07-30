

PotatoPatchUtils.Developer({
	name = 'FirstTry',
	atlas = 'fac_pnf_blueax',
	colour = G.C.SECONDARY_SET.Spectral,
	fac_partner = 'Pixel' -- Only use this if you have a partner! This should be a string that's the same as your partner's PPU.Dev name property
})

PotatoPatchUtils.Developer({
	name = 'Pixel',
	atlas = 'fac_pnf_pixelfish',
	colour = G.C.SECONDARY_SET.Planet,
	fac_partner = 'FirstTry' -- Only use this if you have a partner! This should be a string that's the same as your partner's PPU.Dev name property
})

SMODS.Atlas({
	key = "pnf_blueax", -- Please include your name/team name in your atlas keys
	path = "pnf/SuspiciousBlueAxolotl.png",
	px = 71,
	py = 95,
})

SMODS.Atlas({
	key = "pnf_dupli", -- Please include your name/team name in your atlas keys
	path = "pnf/Barramunduplicare.png",
	px = 71,
	py = 95,
})

SMODS.Atlas({
	key = "pnf_pixelfish", -- Please include your name/team name in your atlas keys
	path = "pnf/PixelFish.png",
	px = 71,
	py = 95,
})

FishAndChips.Fish {
	key = "blueax",
	atlas = "pnf_blueax",
	pos = { x = 0, y = 0 },
	weight = 1,
    blueprint_compat = true,
	ppu_coder = { "FirstTry" },
	ppu_artist = { "FirstTry" },
	attributes = { "mult", "chips", "xmult", "economy" },
	config = {
		extra = {
			scoring = 2,
            gain = 2,
            trigger = false
		},
        immutable = {
            revert = 2
        }
	},
	environments = {
        wormhole = 1,
        backroom = 1
    },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.scoring, card.ability.extra.gain, colours = { HEX("4db1f6") } } }
	end,
	    calculate = function(self, card, context)
        local eval = function(card) return card.ability.extra.trigger == true end
        juice_card_until(card, eval, false)
        if context.joker_main then
            if card.ability.extra.trigger then
                local ret = {}
                local scoreret = pseudorandom(pseudoseed("fish_fac_blueax"), 1, 10)
            if scoreret == 1 or scoreret == 10 then
                        ret.chips = card.ability.extra.scoring
            end
            if scoreret == 2 or scoreret == 10 then
                        ret.mult = card.ability.extra.scoring
            end
            if scoreret == 3 or scoreret == 10 then
                        ret.xmult = (card.ability.extra.scoring/2)
            end
            if scoreret == 4 or scoreret == 10 then
                        ret.xchips = (card.ability.extra.scoring/2)
            end
            if scoreret == 5 or scoreret == 10 then
                        ret.score = card.ability.extra.scoring
            end
            if scoreret == 6 or scoreret == 10 then
                        ret.xscore = (card.ability.extra.scoring/2)
            end
            if scoreret == 7 or scoreret == 10 then
                        ret.blindsize = -card.ability.extra.scoring
            end
            if scoreret == 8 or scoreret == 10 then
                        ret.xblindsize = -(card.ability.extra.scoring/2)
            end
            if scoreret == 9 or scoreret == 10 then
                        ret.dollars = card.ability.extra.scoring
            end
                return ret
                else
            SMODS.scale_card(card, {
                ref_table = card.ability.extra,
                ref_value = "scoring",
                scalar_value = "gain",
                operation = "X",
                scaling_message = {
                message = "+" ..(card.ability.extra.scoring * card.ability.extra.gain).. " Value",
                colour = G.C.DARK_EDITION
            }})
        end
    end
    if context.after then
        if card.ability.extra.trigger then
        card.ability.extra.scoring = card.ability.immutable.revert
        card.ability.extra.trigger = false
            return { message = localize("k_reset") }
    end
    end
end,
    can_use = function(self,card)
        return G.GAME.blind.in_blind
    end,
    keep_on_use = function(self,card)
        return true
    end,
    use = function(self, card, area, copier)
        card.ability.extra.trigger = true
                    G.E_MANAGER:add_event(Event({
						trigger = 'before',
						delay = 0.5 + math.random() * 0.4,
						func = function()
							play_sound('gong',1, 0.5)
							card:juice_up(1, 0.2)
							return true
                        end
						}))

    end
}

FishAndChips.Fish {
	key = "dupli",
	atlas = "pnf_dupli",
	pos = { x = 0, y = 0 },
	soul_pos = { x = 1, y = 0 },
    weight = 1,
    blueprint_compat = true,
	ppu_coder = { "FirstTry" },
	ppu_artist = { "FirstTry" },
	attributes = { "mult", "chips", "xmult", "economy" },
	config = {
		extra = {
			mult = 0,
            mult_mod = 2,
		},
        immutable = {
            revert = 0
        }
	},
	environments = {
        wormhole = 1,
        backroom = 1
    },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mult, card.ability.extra.mult_mod, colours = { HEX("4db1f6") } } }
	end,

    calculate = function(self, card, context)
           if context.end_of_round and context.main_eval then
                card.ability.extra.mult = card.ability.immutable.revert
                return { message = localize("k_reset") }
            end
        if context.individual and context.cardarea == G.play then
            SMODS.scale_card(card, {
                ref_table = card.ability.extra,
                ref_value = "mult",
                scalar_value = "mult_mod",
                scaling_message = {
                message = "+" ..(card.ability.extra.mult * card.ability.extra.mult_mod).. " Mult",
                colour = G.C.MULT
            }
            })
        end
        if (context.joker_main and (to_big(card.ability.extra.mult) > 1)) or context.forcetrigger then
            return {
                mult = card.ability.extra.mult
            }
        end
    end,
}