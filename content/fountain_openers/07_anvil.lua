local anvil_sprite = love.graphics.newImage(love.image.newImageData(SMODS.NFS.newFileData(FishAndChips.mod.path ..
	'/assets/1x/fountain_openers/anvil.png')))
local ax, ay = anvil_sprite:getDimensions()
local anvil_quad = love.graphics.newQuad(0, 0, 1, 1, 1, 1)

-- Borrowed from https://github.com/real-niacat/Aquillarri/blob/70b99dc8dec14a0e4e8c4ca5e56c259fa8bb32fd/items/p_utils.lua#L236-L241
local function get_movable_pixel_pos(mov)
    return {
        x = (G.ROOM.T.x + mov.VT.x + mov.VT.w * 0.5) * (G.TILESIZE * G.TILESCALE),
        y = (G.ROOM.T.y + mov.VT.y + mov.VT.h * 0.5) * (G.TILESIZE * G.TILESCALE),
        ytop = (G.ROOM.T.y + mov.VT.y) * (G.TILESIZE * G.TILESCALE)
    }
end

local function set_freezeframe(image)
    FountainOpeners.anvil_animation.freeze_img = love.graphics.newImage(image)
end

SMODS.Shader {
	key = "fo_impact_frame",
	path = "fountain_openers/impact_frame.fs"
}

SMODS.ScreenShader {
	key = "fo_impact_frame",
	shader = "fac_fo_impact_frame",

	send_vars = function(self)
		return {
			frame = FountainOpeners.anvil_animation.freeze_img
		}
	end,
	should_apply = function(self)
		return FountainOpeners.anvil_animation.freeze_img
	end,
	order = math.huge
}

SMODS.Shader {
	key = "fo_fade",
	path = "fountain_openers/fade.fs"
}

SMODS.ScreenShader {
	key = "fo_fade",
	shader = "fac_fo_fade",

	send_vars = function(self)
		return {
			fade = FountainOpeners.anvil_animation.white_fade
		}
	end,
	should_apply = function(self)
		return FountainOpeners.anvil_animation.white_fade >= 1/256
	end,
	order = math.huge
}

FountainOpeners.anvil_animation = {
    active = false,
    pos = {
        x = 0,
        y = 0
    },

    starting_y = 0,
    target_y = 0,
    start_timer = 0,
    end_timer = 0,

    freeze_img = nil,
    white_fade = 0,

    play = function(self, card)
		G.E_MANAGER:add_event(Event({func = function()
			self.active = true
            self.start_timer = G.TIMERS.REAL
            self.end_timer = self.start_timer + 0.4
            self.card = card

            local pos = get_movable_pixel_pos(card)
            self.pos.x = pos.x
            self.pos.y = pos.y - (love.graphics.getHeight()*0.5 + 600)
            self.starting_y = self.pos.y
            self.target_y = pos.ytop
		return true end}))

        -- don't think i can use an ease event here because of how this is structured
        -- handles the anvil falling animation
        G.E_MANAGER:add_event(Event({func = function()
            self.pos.y = self.starting_y + (self.target_y - self.starting_y) *
                (1 - SMODS.ease_types.outquad(math.min(1, (self.end_timer - G.TIMERS.REAL) / (self.end_timer - self.start_timer))))
		    if G.TIMERS.REAL > self.end_timer then
                love.graphics.captureScreenshot(set_freezeframe)
                play_sound("fac_fo_parry")
                return true
            end
        end}))

        -- handles the freezeframe
        G.E_MANAGER:add_event(Event({
            func = function()
                self.freeze_img = nil
                play_sound("fac_fo_explosion2")
                self.white_fade = 1
                self.active = false
                return true
            end,
            trigger = "after",
            delay = 1,
            timer = "REAL"
        }))

        -- handles aftereffects
        G.E_MANAGER:add_event(Event({
            trigger = "ease",
            delay = 5,
            ref_table = self,
            ref_value = "white_fade",
            ease_to = 0,
            blocking = false,
            timer = "REAL"
        }))

		G.E_MANAGER:add_event(Event({func = function()
			SMODS.destroy_cards(card)
            for _, j in ipairs(SMODS.find_card("fish_fac_fo_anvil")) do
                SMODS.scale_card(j, {
                    ref_table = j.ability.extra,
                    ref_value = "mult",
                    scalar_value = "mult_mod",
                })
            end
		return true end}))
	end,
}

-- Draw the anvil
if not love.draw then function love.draw() end end
local draw_hook = love.draw
function love.draw()
	draw_hook()

    local anim = FountainOpeners.anvil_animation
    if anim.active and not anim.freeze_img then
        local color = {love.graphics.getColor()}
        love.graphics.setColor(1, 1, 1, 1)

        anvil_quad:setViewport(0, 0, ax, ay, ax, ay) -- Reposition quad to use the correct frame
		love.graphics.draw(anvil_sprite, anvil_quad, anim.pos.x, anim.pos.y, 0, 4, 4, ax/2, ay/2)
        love.graphics.setColor(unpack(color))
    end
end

FishAndChips.Fish {
	key = "fo_anvil",
	atlas = "fo_anvil",
	pos = { x = 0, y = 0 },
    display_size = { w = 95, h = 71 },
    pixel_size = { w = 95, h = 71 },
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
    treasure = true,
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
    set_card_type_badge = function(self, card, badges)
		badges[#badges + 1] = create_badge(localize("k_fac_fo_anvil"), FishAndChips.C.FISH, G.C.WHITE, 1.2)
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
    FountainOpeners.anvil_animation:play(card)
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