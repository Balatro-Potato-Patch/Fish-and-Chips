local anvil_sprite = love.graphics.newImage(love.image.newImageData(SMODS.NFS.newFileData(FishAndChips.mod.path ..
	'/assets/1x/fountain_openers/boid_1x.png')))
local ax, ay = anvil_sprite:getDimensions()
local anvil_quad = love.graphics.newQuad(0, 0, 1, 1, 1, 1)

-- Borrowed from https://github.com/real-niacat/Aquillarri/blob/70b99dc8dec14a0e4e8c4ca5e56c259fa8bb32fd/items/p_utils.lua#L236-L241
local function get_movable_pixel_pos(mov)
    return {
        (G.ROOM.T.x + mov.VT.x + mov.VT.w * 0.5) * (G.TILESIZE * G.TILESCALE),
        (G.ROOM.T.y + mov.VT.y + mov.VT.h * 0.5) * (G.TILESIZE * G.TILESCALE),
    }
end

FishAndChips.Fish {
	key = "fo_anvil",
	atlas = "fish",
	pos = { x = 3, y = 0 },
	weight = 8,
	blueprint_compat = true,
	disable_visual_scaling = true,
	ppu_coder = { "fo_alexi" },
	ppu_artist = { "fo_grahkon" },
	attributes = { "mult", "destroy_card" },
	config = {
		extra = {
			mult = 0,
			mult_mod = 5,
		}
	},
	environments = {
		aquifer = 1,
		volcano = 1,
	},
	stats = {
		weight = {min = 53, max = 118},
		length = {min = 0.5715, max = 0.7493},
	},
	loc_vars = function(self, info_queue, card)
		return {
            vars = {
                card.ability.extra.mult,
                card.ability.extra.mult_mod,
                elements = {
                    { n=G.UIT.R, config = { align="cm" }, nodes = {
                        { n=G.UIT.O, config={ object=
                            SMODS.create_sprite(0, 0, 466 / 255 * 2, 105 / 255 * 2, "fac_fo_fucking_killed", {x = 0, y = 0})
                        }}
                    }},
                    { n=G.UIT.R, config = { align="cm" }, nodes = {
                        { n=G.UIT.O, config={ object=
                            SMODS.create_sprite(0, 0, 377 / 255 * 2, 105 / 255 * 2, "fac_fo_fucking_kill", {x = 0, y = 0})
                        }}
                    }}
                }
            }
        }
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			return {
				mult = card.ability.extra.mult
			}
		end
	end,
}

G.FUNCS.fac_fo_can_take_fish = function(e)
	local card = e.config.ref_table
	card._fac_use_key = localize("fac_fo_take")
	if #G.fac_fish_area.cards < G.fac_fish_area.config.card_limit then
		e.config.colour = G.C.ORANGE
		e.config.button = "fac_fo_take_fish"
	else
		e.config.colour = G.C.UI.BACKGROUND_INACTIVE
		e.config.button = nil
	end
end

G.FUNCS.fac_fo_take_fish = function(e)
	local card = e.config.ref_table
	local area = G.fac_fish_area

	card.fac_fo_anvil = nil
	area:emplace(card)
	card:juice_up()
end

G.FUNCS.fac_fo_can_fucking_kill_fish = function(e)
	local card = e.config.ref_table
	if card.fac_fo_anvil then
		e.config.colour = G.C.UI.TEXT_LIGHT
		e.config.button = "fac_fo_fucking_kill_fish"
	else
		e.config.colour = G.C.UI.BACKGROUND_INACTIVE
		e.config.button = nil
	end
end

G.FUNCS.fac_fo_fucking_kill_fish = function(e)
	local card = e.config.ref_table
	SMODS.destroy_cards(card)

	for _, j in ipairs(SMODS.find_card("fish_fac_fo_anvil")) do
		SMODS.scale_card(j, {
			ref_table = j.ability.extra,
			ref_value = "mult",
			scalar_value = "mult_mod",
		})
	end
end

local uasb = G.UIDEF.use_and_sell_buttons
function G.UIDEF.use_and_sell_buttons(card)
    local ret = uasb(card)

    if card.ability.set == 'fac_Fish' and card.fac_fo_anvil then
        local sell = {n=G.UIT.C, config={align = "cr"}, nodes={
            {n=G.UIT.C, config={ref_table = card, align = "cr",padding = 0.1, r=0.08, minw = 1.25, hover = true, shadow = true, colour = G.C.UI.BACKGROUND_INACTIVE, one_press = true, button = 'sell_card', func = 'can_sell_card', handy_insta_action = 'sell'}, nodes={
                {n=G.UIT.B, config = {w=0.1,h=0.6}},
                {n=G.UIT.C, config={align = "tm"}, nodes={
                    {n=G.UIT.R, config={align = "cm", maxw = 1.25}, nodes={
                        {n=G.UIT.T, config={text = localize('b_sell'),colour = G.C.UI.TEXT_LIGHT, scale = 0.4, shadow = true}}
                    }},
                    {n=G.UIT.R, config={align = "cm"}, nodes={
                        {n=G.UIT.T, config={text = localize('$'), colour = G.C.WHITE, scale = 0.55, shadow = true, font = SMODS.Fonts["fac_sand_dollars"]}},
                        {n=G.UIT.T, config={ref_table = card, ref_value = 'sell_cost_label',colour = G.C.WHITE, scale = 0.55, shadow = true}}
                    }}
                }}
            }},
        }}
        local take = {n=G.UIT.C, config={align = "cr"}, nodes={
            {n=G.UIT.C, config={ref_table = card, align = "cm",padding = 0.1, r=0.08, minw = 1.25, minh = 0.8, hover = true, shadow = true, colour = G.C.UI.BACKGROUND_INACTIVE, fac_ignore = true, button = 'fac_fo_take_fish', func = "fac_fo_can_take_fish", handy_insta_action = 'use'}, nodes={
                {n=G.UIT.B, config = {w=0.1,h=0.6}},
                {n=G.UIT.C, config={align = "cm"}, nodes={
                    {n=G.UIT.R, config={align = "cm", maxw = 1.25}, nodes={
                        {n=G.UIT.T, config={text = card.config.center.button_key and (type(card.config.center.button_key) == "function" and card.config.center:button_key() or localize(card.config.center.button_key)) or localize("fac_fo_take"), colour = G.C.UI.TEXT_LIGHT, scale = 0.55, shadow = true}}
                    }},
                }},
            }},
        }}
        ret = {n=G.UIT.ROOT, config = {padding = 0, colour = G.C.CLEAR}, nodes={
            {n=G.UIT.C, config={padding = 0.15, align = 'cl'}, nodes={
                {n=G.UIT.R, config={align = 'cl'}, nodes={
                    sell
                }},
                {n=G.UIT.R, config={align = 'cl'}, nodes={
                    take
                }},
                {n=G.UIT.R, config={ref_table = card, r = 0.08, padding = 0.1, align = 'cl', minw = 0.5*card.T.w - 0.15, maxw = 0.9*card.T.w - 0.15, minh = 0.3*card.T.h, hover = true, shadow = true, colour = G.C.UI.BACKGROUND_INACTIVE,
                one_press = true, button = 'fac_fo_fucking_kill_fish', func = 'fac_fo_can_fucking_kill_fish'}, nodes={
                    {n=G.UIT.O, config={object=
                        SMODS.create_sprite(0, 0, 377 / 255, 105 / 255, "fac_fo_fucking_kill", {x = 0, y = 0})
                    }}
                }},
            }},
        }}
    end
    return ret
end