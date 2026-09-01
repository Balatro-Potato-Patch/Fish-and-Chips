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

function FountainOpeners.fucking_kill_sprite(scale)
    scale = scale or 1
    return SMODS.create_sprite(
        0, 0,
        (FishAndChips.mod.config.family_friendly and 378 or 377) / 255 * scale,
        105 / 255 * scale,
        FishAndChips.mod.config.family_friendly and
            "fac_fo_fucking_kill_alt"
            or "fac_fo_fucking_kill",
        {x = 0, y = 0}
    )
end

function FountainOpeners.fucking_killed_sprite(scale)
    scale = scale or 1
    return SMODS.create_sprite(
        0, 0,
        (FishAndChips.mod.config.family_friendly and 463 or 466) / 255 * scale,
        105 / 255 * scale,
        FishAndChips.mod.config.family_friendly and
            "fac_fo_fucking_killed_alt"
            or "fac_fo_fucking_killed",
        {x = 0, y = 0}
    )
end

FountainOpeners.anvil_animation = {
    active = false,
    pos = {
        x = 0,
        y = 0
    },

    starting_y = 0,
    target_y = 0,
    ypos = 0,
    start_timer = 0,
    end_timer = 0,

    freeze_img = nil,
    white_fade = 0,
    reopen_fish_menu = false,

    play = function(self, card)
        local prev_state = G.TAROT_INTERRUPT
        G.TAROT_INTERRUPT = G.STATE
        G.CONTROLLER.locks.use = true
        self.reopen_fish_menu = false

        -- ui shit aaaaaaaaaaa
        if G.GAME.fac_fish_expanded then
            G.FUNCS.fac_open_fishing_menu()
            self.reopen_fish_menu = true
        end
        if G.booster_pack then
            G.booster_pack.alignment.offset.py = G.booster_pack.alignment.offset.y
            G.booster_pack.alignment.offset.y = G.ROOM.T.y + 29
        end
        if G.shop and not G.shop.alignment.offset.py then
            G.shop.alignment.offset.py = G.shop.alignment.offset.y
            G.shop.alignment.offset.y = G.ROOM.T.y + 29
        end
        if G.blind_select and not G.blind_select.alignment.offset.py then
            G.blind_select.alignment.offset.py = G.blind_select.alignment.offset.y
            G.blind_select.alignment.offset.y = G.ROOM.T.y + 39
        end
        if G.round_eval and not G.round_eval.alignment.offset.py then
            G.round_eval.alignment.offset.py = G.round_eval.alignment.offset.y
            G.round_eval.alignment.offset.y = G.ROOM.T.y + 29
        end
        -- TARGET: add more ui elements that get hidden

		G.E_MANAGER:add_event(Event({func = function()
			self.card = card
            card.area:remove_card(card)
            G.play:emplace(card)
		return true end}))

        G.E_MANAGER:add_event(Event({
            delay = 0.5,
            func = function()
                self.active = true
                self.start_timer = G.TIMERS.REAL
                self.end_timer = self.start_timer + 0.4
                self.card = card

                self.ypos = -(love.graphics.getHeight()*0.5 + 600)
                self.starting_y = self.ypos
                self.target_y = -card.VT.h * 0.75 * (G.TILESIZE * G.TILESCALE)
		    return true
        end}))

        -- don't think i can use an ease event here because of how this is structured
        -- handles the anvil falling animation
        G.E_MANAGER:add_event(Event({func = function()
            self.ypos = self.starting_y + (self.target_y - self.starting_y) *
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
                G.E_MANAGER:add_event(Event({
                    delay = 0.1,
                    func = function()
                        if not G.GAME.fac_fish_expanded and self.reopen_fish_menu and next(G.fac_fish_area.cards) then
                            G.FUNCS.fac_open_fishing_menu()
                        end
                        if G.booster_pack and G.booster_pack.alignment.offset.py then 
                            G.booster_pack.alignment.offset.y = G.booster_pack.alignment.offset.py
                            G.booster_pack.alignment.offset.py = nil
                        end
                        if G.shop then
                            G.shop.alignment.offset.y = G.shop.alignment.offset.py
                            G.shop.alignment.offset.py = nil
                        end
                        if G.blind_select then
                            G.blind_select.alignment.offset.y = G.blind_select.alignment.offset.py
                            G.blind_select.alignment.offset.py = nil
                        end
                        if G.round_eval then
                            G.round_eval.alignment.offset.y = G.round_eval.alignment.offset.py
                            G.round_eval.alignment.offset.py = nil
                        end
                        -- TARGET: add more ui elements that get brought back

                        G.TAROT_INTERRUPT = prev_state
                        G.CONTROLLER.locks.use = false
                        self.reopen_fish_menu = false
                        return true
                    end
                }))
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
			SMODS.destroy_cards(card, {ignore_eternal = true})
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
SMODS.Shader {
	key = "fo_shader_that_also_does_absolutely_fucking_nothing",
	path = "fountain_openers/shader_that_also_does_absolutely_fucking_nothing.fs"
}

SMODS.ScreenShader {
    key = "fac_fo_anvil",
    shader = "fac_fo_shader_that_also_does_absolutely_fucking_nothing",
    should_apply = function(self)
        return FountainOpeners.anvil_animation.active and not FountainOpeners.anvil_animation.freeze_img
    end,
    order = 1,
    draw = function(self, shader, canvas)
        love.graphics.setShader()
        love.graphics.draw(canvas,0,0)

        local anim = FountainOpeners.anvil_animation
        local color = {love.graphics.getColor()}
        love.graphics.setColor(1, 1, 1, 1)
        local pos = get_movable_pixel_pos(anim.card) or {x=0, y=0}

        anvil_quad:setViewport(0, 0, ax, ay, ax, ay) -- Reposition quad to use the correct frame
		love.graphics.draw(anvil_sprite, anvil_quad, pos.x, pos.y + anim.ypos, 0, 4, 4, ax/2, ay/2)
        love.graphics.setColor(unpack(color))
    end
}

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
	attributes = { "mult", "destroy_card", "scaling", },
	config = {
		extra = {
			mult = 0,
			mult_mod = 3,
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
                            FountainOpeners.fucking_killed_sprite(2)
                        }}
                    }},
                    { n=G.UIT.R, config = { align="cm" }, nodes = {
                        { n=G.UIT.O, config={ object=
                            FountainOpeners.fucking_kill_sprite(2)
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

G.FUNCS.fac_fo_can_fucking_kill_fish = function(e)
	if e.config.ref_table.ability.set == "fac_Fish" then
		e.config.colour = G.C.UI.TEXT_LIGHT
        e.config.fac_ignore = true
		e.config.button = "fac_fo_fucking_kill_fish"
	else
        if G.hide_areas_again then
            e.config.fac_ignore = true
        else
            e.config.fac_ignore = nil
        end
		e.config.colour = G.C.UI.BACKGROUND_INACTIVE
		e.config.button = nil
	end
    if e.config.ref_table.config.center.key == "fish_fac_fas_annoying_fish" then
        if e.states.hover.is then
            if not e.config.fac_fas_hovered then
                e.config.ref_table.children.use_button:set_role{r_bond = "Weak"}
                local target = {
                    x = 10 * (math.random() - 0.5),
                    y = 10 * (math.random() - 0.5)
                }
                ease_value(e.config.ref_table.children.use_button.alignment.offset, "x", target.x - e.config.ref_table.children.use_button.alignment.offset.x, nil, nil, true)
                ease_value(e.config.ref_table.children.use_button.alignment.offset, "y", target.y - e.config.ref_table.children.use_button.alignment.offset.y, nil, nil, true)
                e.config.ref_table.children.use_button.T.r = 2 * math.pi * math.random()
            end
        else
            e.config.fac_fas_hovered = nil
        end
    end
end

G.FUNCS.fac_fo_fucking_kill_fish = function(e)
	local card = e.config.ref_table
    FountainOpeners.anvil_animation:play(card)
end

local uasb = G.UIDEF.use_and_sell_buttons
function G.UIDEF.use_and_sell_buttons(card)
    local ret = uasb(card)

     if card.ability.set == 'fac_Fish' and card.config.center.key ~= "fish_fac_fo_anvil" and #SMODS.find_card("fish_fac_fo_anvil") > 0 then
        local kill = {n=G.UIT.C, config={align = "cr"}, nodes={
            {n=G.UIT.R, config = {
                ref_table = card, r = 0.08, padding = 0.1, align = 'cl',
                minw = 0.5*card.T.w - 0.15, maxw = 0.9*card.T.w - 0.15, minh = 0.3*card.T.h, hover = true, shadow = true, colour = G.C.UI.BACKGROUND_INACTIVE,
                one_press = true, button = 'fac_fo_fucking_kill_fish', func = 'fac_fo_can_fucking_kill_fish'
            }, nodes = {
                {n=G.UIT.O, config={object = FountainOpeners.fucking_kill_sprite()}}
            }},
        }}
        local use = {n=G.UIT.C, config={align = "cr"}, nodes={
            {n=G.UIT.C, config={ref_table = card, align = "cm",padding = 0.1, r=0.08, minw = 1.25, minh = 0.8, hover = true, shadow = true, colour = G.C.UI.BACKGROUND_INACTIVE, fac_ignore = true, button = 'fac_use_fish', func = "fac_can_use_fish", handy_insta_action = 'use'}, nodes={
                {n=G.UIT.B, config = {w=0.1,h=0.6}},
                {n=G.UIT.C, config={align = "cm"}, nodes={
                    {n=G.UIT.R, config={align = "cm", maxw = 1.25}, nodes={
                        {n=G.UIT.T, config={text = card.config.center.button_key and (type(card.config.center.button_key) == "function" and card.config.center:button_key(card) or localize(card.config.center.button_key)) or localize("b_use"), colour = G.C.UI.TEXT_LIGHT, scale = 0.55, shadow = true}}
                    }},
                }},
            }},
        }}
        ret = {n=G.UIT.ROOT, config = {padding = 0, colour = G.C.CLEAR}, nodes={
            {n=G.UIT.C, config={padding = 0.15, align = 'cl'}, nodes={
                {n=G.UIT.R, config={align = 'cl'}, nodes={
                    kill
                }},
                card.config.center.use and {n=G.UIT.R, config={align = 'cl'}, nodes={
                    use
                }} or nil,
            }},
        }}
    end
    return ret
end
