G.FUNCS.toggle_shop = function(e)
    stop_use()
	if G.CONTROLLER.locks.toggle_shop then return end
    G.CONTROLLER.locks.toggle_shop = true
    if G.shop then
        SMODS.calculate_context({ ending_shop = true })
        G.E_MANAGER:add_event(Event({
            trigger = 'immediate',
            func = function()
                G.shop.alignment.offset.y = G.ROOM.T.y + 29
                G.SHOP_SIGN.alignment.offset.y = -15
                return true
            end
        }))
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.5,
            func = function()
                G.shop:remove()
                G.shop = nil
                G.SHOP_SIGN:remove()
                G.SHOP_SIGN = nil
                G.STATE_COMPLETE = false
                if not G.GAME.fishing then
                    G.GAME.fishing = true
                    G.STATE = G.STATES.FAC_FISHING
                else
                    G.GAME.fishing = false
                    G.STATE = G.STATES.BLIND_SELECT
                end
                G.CONTROLLER.locks.toggle_shop = nil
                return true
            end
        }))
    end
end

G.FUNCS.fac_toggle_fishing = function(e)
    stop_use()
	if G.CONTROLLER.locks.toggle_shop then return end
    G.CONTROLLER.locks.toggle_shop = true
    if G.GAME.fishing and not FishAndChips.in_tutorial then
        SMODS.calculate_context({ ending_fishing = true })
		G.GAME.fac_snapper_dialogue_opt = nil	-- To let Snapper know your next visit will advance his dialogue count.
        G.E_MANAGER:add_event(Event({
            trigger = 'immediate',
            func = function()
                G.FISHING.fishing.alignment.offset.y = G.ROOM.T.y + 29
                G.fac_fishing_bucket_bottom.alignment.offset.y = -0.5 - G.CARD_H
                G.fac_fishing_bucket_bottom.alignment.offset.x = -0.3
								G.fac_rod_area.T.y = G.fac_rod_area.T.y - 10
								G.fac_bait_area.T.y = G.fac_bait_area.T.y - 10
								G.deck.T.y = G.deck.T.y - 10
								G.hand.T.y = G.hand.T.y - 10
								G.jokers.T.y = G.jokers.T.y + 10
								G.consumeables.T.y = G.consumeables.T.y + 10
                ease_value(G.HUD.alignment.offset, "x", 10) -- for some reason this value changes instantly unlike others
                return true
            end
        }))
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.5,
            func = function()
                G.FISHING.fishing:remove()
                G.FISHING.fishing = nil
                G.GAME.fishing = false
                G.STATE_COMPLETE = false
                G.STATE = G.STATES.BLIND_SELECT
                G.CONTROLLER.locks.toggle_shop = nil
				FishAndChips:stop_ambience()
                return true
            end
        }))
    end
end

local igo = Game.init_game_object
function Game:init_game_object()
    local ret = igo(self)
    ret.fac_sand_dollars = 4
	ret.current_round.fac_sand_dollars = 0
    ret.fac_bait_shop_items = {}
    ret.fac_bait_inventory = {{key = 'bait_fac_normal', amt = 3}}
    ret.fac_active_bait = nil
    ret.fac_treasure_earned = 0
    ret.fac_perfect_catches = 0
	ret.fac_no_jokers = true
    return ret
end

local gsp = get_starting_params
function get_starting_params()
    local ret = gsp()
    ret.fac_sand_dollars = 0
    ret.fac_bait_shop_items = {}
    ret.fac_bait_inventory = {}
    ret.fac_active_bait = nil
    return ret
end

local cardarea_draw_ref = CardArea.draw
---@diagnostic disable-next-line: duplicate-set-field
function CardArea:draw(...)
	if self == G.fac_fish_area or (G.FISHING and self == G.FISHING.fac_fish_reward_area) then
---@diagnostic disable-next-line: undefined-field
		if not self.states.visible then return end 
		if G.VIEWING_DECK and (self==G.deck or self==G.hand or self==G.play) then return end
---@diagnostic disable-next-line: undefined-field
		self.ARGS.draw_layers = self.ARGS.draw_layers or self.config.draw_layers or {'shadow', 'card'}
---@diagnostic disable-next-line: undefined-field
		for k, v in ipairs(self.ARGS.draw_layers) do
			for i = 1, #self.cards do
				if self.cards[i] ~= G.CONTROLLER.focused.target then
					if not self.cards[i].highlighted then
						if G.CONTROLLER.dragging.target ~= self.cards[i] then self.cards[i]:draw(v) end
					end
				end
			end
			for i = 1, #self.cards do
				if self.cards[i] ~= G.CONTROLLER.focused.target then
					if self.cards[i].highlighted then
						if G.CONTROLLER.dragging.target ~= self.cards[i] then self.cards[i]:draw(v) end
					end
				end
			end
		end
	else
		cardarea_draw_ref(self, ...)
	end
end

local sprite_draw_ref = Sprite.draw
---@diagnostic disable-next-line: duplicate-set-field
function Sprite:draw(...)
	if G.FISHING and (
		self == G.FISHING.wormhole_rocket_under_sprite or self == G.FISHING.wormhole_rocket_over_sprite
		or self == G.FISHING.wormhole_rocket_top_sprite
		or self == G.FISHING.wormhole_potato_under_sprite or self == G.FISHING.wormhole_potato_over_sprite
		or self == G.FISHING.wormhole_potato_top_sprite
	) then
		local bg = G.FISHING.fishing
		if bg then
			love.graphics.stencil(function()
				prep_draw(bg, 1)
				love.graphics.scale(1 / G.TILESIZE)
				love.graphics.rectangle("fill", 0, 0, bg.VT.w * G.TILESIZE, bg.VT.h * G.TILESIZE)
				love.graphics.pop()
			end, "replace", 1)
			love.graphics.setStencilTest("greater", 0)
			if self.fac_rotation then
				self.T.r = self.fac_rotation
			end
			if self.fac_w and self.fac_h then
				self.T.w = self.fac_w
				self.T.h = self.fac_h
			end
			sprite_draw_ref(self, ...)
			love.graphics.setStencilTest()
		else
			self:remove()
		end
	else
		sprite_draw_ref(self, ...)
	end
end

local align_cards_hook = CardArea.align_cards
---@diagnostic disable-next-line: duplicate-set-field
function CardArea:align_cards(...)
	if self == G.fac_fish_area then
		if G.GAME.fac_fish_expanded then
			self.T.w = self.T.w * 5
			self.T.x = self.T.x - G.CARD_W * 6
		end
		for k, card in ipairs(self.cards) do
			if G.GAME.fac_fish_expanded then
				if card._fac_bucketed then
					card.states.click.can = true
					card.states.hover.can = true
					card.states.drag.can = true
					card.T.w = card.T.w / 0.7
					card.T.h = card.T.h / 0.7
          card._fac_bucketed = false
				end
			elseif not card._fac_bucketed then
				card.states.click.can = false
				card.states.hover.can = false
				card.states.drag.can = false
				card.T.w = card.T.w * 0.7
				card.T.h = card.T.h * 0.7
        card._fac_bucketed = true
			end
			if not card.states.drag.is and not card.disable_align then
				card.T.r = (G.GAME.fac_fish_expanded and 0.1 or 1) * (-#self.cards / 2 + k) / #self.cards
					+ (G.SETTINGS.reduced_motion and 0 or 1) * 0.02 * math.sin(2 * G.TIMERS.REAL + card.T.x)
				local max_cards = math.max(#self.cards, self.config.temp_limit)
				card.T.x = self.T.x
					+ (self.T.w - self.card_w) * ((k - 1) / math.max(max_cards - 1, 1) - 0.5 * (#self.cards - max_cards) / math.max(
						max_cards - 1,
						1
					))
					+ 0.5 * (self.card_w - card.T.w)
				if
					#self.cards > 2
					or (#self.cards > 1 and self == G.consumeables)
					or (#self.cards > 1 and self.config.spread)
				then
					card.T.x = self.T.x
						+ (self.T.w - self.card_w) * ((k - 1) / (#self.cards - 1))
						+ 0.5 * (self.card_w - card.T.w)
				elseif #self.cards > 1 and self ~= G.consumeables then
					card.T.x = self.T.x
						+ (self.T.w - self.card_w) * ((k - 0.5) / #self.cards)
						+ 0.5 * (self.card_w - card.T.w)
				else
					card.T.x = self.T.x + self.T.w / 2 - self.card_w / 2 + 0.5 * (self.card_w - card.T.w)
				end
				local highlight_height = G.HIGHLIGHT_H / 2
				if not card.highlighted then
					highlight_height = 0
				end
				card.T.y = self.T.y
					- 0.2
					+ self.T.h / 2
					- card.T.h / 2
					- highlight_height
					+ (G.SETTINGS.reduced_motion and 0 or 1) * 0.03 * math.sin(0.666 * G.TIMERS.REAL + card.T.x)
				card.T.x = card.T.x + card.shadow_parrallax.x / 30
			end
		end
		if G.GAME.fac_fish_expanded then
			self.T.w = self.T.w / 5
			self.T.x = self.T.x + G.CARD_W * 6
		end
		table.sort(self.cards, function(a, b)
			return a.T.x + a.T.w / 2 - 100 * ((a.pinned and not a.ignore_pinned) and a.sort_id or 0)
				< b.T.x + b.T.w / 2 - 100 * ((b.pinned and not b.ignore_pinned) and b.sort_id or 0)
		end)
	else
		align_cards_hook(self, ...)
	end
end



local g_uidef_card_h_popup_ref = G.UIDEF.card_h_popup
---@diagnostic disable-next-line: duplicate-set-field
function G.UIDEF.card_h_popup(card)
	if card.ability and card.ability.set == 'fac_Fish' and not FishAndChips.mod.config.disable_flavour then FishAndChips.tooltip_seed = (FishAndChips.tooltip_seed or 0) + 1 end
    local ret = g_uidef_card_h_popup_ref(card)
	-- Environments tooltip
    if card.config and card.config.center and card.config.center.set == "fac_Fish" and card.area and (card.area.config.collection or card.area.config.fac_compendium) then
        local t = {n=G.UIT.C, config = {padding = 0.1, align = 'cm'}, nodes = {}}
        for _, env in ipairs(G.FAC_ENVIRONMENT_POOL) do
			if card.config.center.environments[env.key] then
				t.nodes[#t.nodes+1] = {n = G.UIT.R, config = {align = 'cm', colour = env.colour or G.C.UI.BACKGROUND_WHITE, r=0.12, padding = 0.07, minh = 0.5, minw = 2.2, outline = 1, outline_colour = darken(FishAndChips.mod.badge_colour, 0.5)}, nodes = {
					{n = G.UIT.T, config = {text = localize{type = "name_text", set = "fac_Env", key = env.key}, scale = 0.3, colour = env.colour and G.C.UI.TEXT_LIGHT or G.C.UI.TEXT_DARK}}
				}}
			end
        end
		ret.nodes[#ret.nodes].n = G.UIT.R
		ret.nodes[#ret.nodes].nodes[#ret.nodes[#ret.nodes].nodes].n = G.UIT.C

        table.insert(ret.nodes[#ret.nodes].nodes, 1, {n=G.UIT.C, config = {align = 'cm', padding = -0.175}, nodes = {
			{n=G.UIT.R, config={align = "cm", padding = 0.05, r = 0.12, colour = darken(FishAndChips.mod.badge_colour, 0.6)}, nodes={
				{n=G.UIT.R, config={align = "cm", padding = 0.05, r = 0.12, minw = 2.4, colour = lighten(FishAndChips.mod.badge_colour, 0.2), shader = 'fac_mod_badge'}, nodes={
					{n=G.UIT.C, nodes = {
						{n = G.UIT.R, config = {align = "cm", r = 0.1}, nodes = {
							{n = G.UIT.T, config = {text = localize("ph_fac_catchable_in"), scale = 0.4, colour = darken(FishAndChips.mod.badge_colour, 0.5)}}
						}},
						{n=G.UIT.R, config = {align = 'cm'}, nodes = {t}},
					}},
					{n = G.UIT.C, config = {minw = 0.05}}
				}},
			}},
		}})
		ret.nodes[#ret.nodes].nodes[2] = {n=G.UIT.C, nodes = {ret.nodes[#ret.nodes].nodes[2]}}
    end
	-- Flavour text addition
    if card.ability and card.ability.set == 'fac_Fish' and not FishAndChips.mod.config.disable_flavour and card.config.center.discovered and G.localization.descriptions.fac_Fish[card.config.center_key] and G.localization.descriptions.fac_Fish[card.config.center_key].fac_flavour_parsed then
		local name = SMODS.deepfind(ret, 'tooltip_id_'..FishAndChips.tooltip_seed, nil, true)[1]
        local name_node = name.objtree
        local flavour_node = {}
        local loc_vars = G.P_CENTERS[card.config.center_key].loc_vars and G.P_CENTERS[card.config.center_key]:loc_vars({}, card) or {}
        localize({type = 'flavour', nodes = flavour_node, loc_target = G.localization.descriptions.fac_Fish[loc_vars.key or card.config.center_key], scale = 0.8, text_colour = G.C.JOKER_GREY, shadow = true, vars = loc_vars.vars})
        local final_flavour = {{n=G.UIT.R, config = {minh = 0.1}}}
        for i, line in ipairs(flavour_node) do
            local node = {n=G.UIT.R, config = {align = 'cm'}, nodes = {}}
            for _, part in ipairs(line) do
                table.insert(node.nodes, part)
            end
            table.insert(final_flavour, i, node)
        end
        table.insert(name_node[#name_node - 3], name.tree[#name.tree - 2] + 1, {n=G.UIT.R, config = {align = 'cm'}, nodes = final_flavour})
    end
	-- Measurements
	if card.ability and card.ability.set == 'fac_Fish' and card.area and not (card.area.config.collection or card.area.config.fac_compendium) then
		local name = SMODS.deepfind(ret, 'main_box_flag', 'i')[1]
        local name_node = name.objtree
        local flavour_node = {}
		local stats = card.ability.stats
		local stat_proto = card.config.center.stats
		local weight_perc = (stats.weight - stat_proto.weight.min)/(stat_proto.weight.max-stat_proto.weight.min)*100
		local length_perc = (stats.length - stat_proto.length.min)/(stat_proto.length.max-stat_proto.length.min)*100
		local colours = { -- TODO: are these colours okay?
			darken(G.C.RED, 0.1),
			G.C.RED,
			G.C.ORANGE,
			G.C.YELLOW,
			G.C.GREEN,
			G.ARGS.LOC_COLOURS.edition
		}
		
		local weight_col_index = math.min(5, math.max(math.floor(weight_perc/20), 1))
		local weight_col = stats.weight == stat_proto.weight.max and colours[6] or mix_colours(colours[weight_col_index+1], colours[math.max(weight_col_index, 1)], (weight_perc - (weight_col_index * 20))/20)
		
		local length_col_index = math.min(5, math.max(math.floor(length_perc/20), 1))
		local length_col = stats.length == stat_proto.length.max and colours[6] or mix_colours(colours[length_col_index+1], colours[length_col_index], (length_perc - (length_col_index * 20))/20)
		
        table.insert(name_node[#name_node - 3], #name_node[#name_node - 3], {n=G.UIT.R, config = {align = 'cm'}, nodes = {
			{n=G.UIT.T, config = {text = localize('ph_fac_weight'), scale = 0.27, colour = G.C.WHITE, shadow = true}},
			{n=G.UIT.T, config = {text = FishAndChips.format_measurement(stats.weight, 'weight'), scale = 0.27, colour = weight_col, shadow = true}},
			{n=G.UIT.T, config = {text = '  '..localize('ph_fac_length'), scale = 0.27, colour = G.C.WHITE, shadow = true}},
			{n=G.UIT.T, config = {text = FishAndChips.format_measurement(stats.length, 'length'), scale = 0.27, colour = length_col, shadow = true}},
		}})
    end
	return ret
end

local name_from_hook = name_from_rows
function name_from_rows(name_nodes, background_colour)
    local ret = name_from_hook(name_nodes, background_colour)
    if ret then ret.config.id = 'tooltip_id_'..(FishAndChips.tooltip_seed or 1) end
    return ret
end

local mainmenuref = Game.main_menu
function Game:main_menu(change_context)
	FishAndChips.stop_ambience()

	local ret = mainmenuref(self, change_context)

	if FishAndChips.mod.config.menu then
        -- Creates FAC Logo Sprite
        local SC_scale = 0.95 * (G.debug_splash_size_toggle and 0.8 or 1)
        G.SPLASH_FAC_LOGO = Sprite(0, 0,
            6 * SC_scale,
            6 * SC_scale * (G.ASSET_ATLAS["fac_logo"].py / G.ASSET_ATLAS["fac_logo"].px),
            G.ASSET_ATLAS["fac_logo"], { x = 0, y = 0 }
        )
        G.SPLASH_FAC_LOGO:set_alignment({
            major = G.title_top,
            type = 'cm',
            bond = 'Strong',
            offset = { x = 0, y = 3.35 }
        })
        G.SPLASH_FAC_LOGO:define_draw_steps({ {
            shader = 'dissolve',
        } })

        -- Define logo properties
        G.SPLASH_FAC_LOGO.tilt_var = { mx = 0, my = 0, dx = 0, dy = 0, amt = 0 }

        G.SPLASH_FAC_LOGO.dissolve_colours = { FishAndChips.C.FAC_PRIMARY, FishAndChips.C.FAC_SECONDARY }
        G.SPLASH_FAC_LOGO.dissolve = 1

        G.SPLASH_FAC_LOGO.states.collide.can = true

        -- Define node functions for Maximus Logo
        function G.SPLASH_FAC_LOGO:click()
            play_sound('button', 1, 0.3)
            SMODS.LAST_SELECTED_MOD_TAB = nil
            G.FUNCS['openModUI_FishAndChips']()
            G.OVERLAY_MENU:get_UIE_by_ID("overlay_menu_back_button").config.button = "exit_overlay_menu_mxms"
        end

        G.FUNCS.exit_overlay_menu_mxms = function()
            play_sound("fac_book_close")
            G.ACTIVE_MOD_UI = nil
            G.FUNCS.exit_overlay_menu()
        end

        function G.SPLASH_FAC_LOGO:hover()
            G.SPLASH_FAC_LOGO:juice_up(0.05, 0.03)
            play_sound('paper1', math.random() * 0.2 + 0.9, 0.35)
            Node.hover(self)
        end

        function G.SPLASH_FAC_LOGO:stop_hover() Node.stop_hover(self) end

        --Logo animation
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = change_context == 'splash' and 3.6 or change_context == 'game' and 4 or 1,
            blockable = false,
            blocking = false,
            func = (function()
                play_sound('magic_crumple' .. (change_context == 'splash' and 2 or 3),
                    (change_context == 'splash' and 1 or 1.3), 0.9)
                play_sound('whoosh1', 0.2, 0.8)
                ease_value(G.SPLASH_FAC_LOGO, 'dissolve', -1, nil, nil, nil,
                    change_context == 'splash' and 2.3 or 0.9)
                G.VIBRATION = G.VIBRATION + 1.5
                return true
            end)
        }))

        -- make the title screen use different background colors
        G.SPLASH_BACK:define_draw_steps({ {
            shader = 'splash',
            send = {
                { name = 'time',       ref_table = G.TIMERS,  ref_value = 'REAL_SHADER' },
                { name = 'vort_speed', val = 0.4 },
                { name = 'colour_1',   ref_table = FishAndChips.C, ref_value = 'FAC_PRIMARY' },
                { name = 'colour_2',   ref_table = FishAndChips.C, ref_value = 'FAC_SECONDARY' },
            }
        } })
    end

    return ret

end

local start_run_ref = Game.start_run
function Game:start_run(...)
	start_run_ref(self, ...)
	FishAndChips.stop_ambience()
	FishAndChips.stop_reel_sound()

	FishAndChips.C.FISHING_BUTTONS_ACTIVE = { 62 / 255, 222 / 255, 250 / 255, 0.65 }
	FishAndChips.C.FISHING_BUTTONS_BG = { G.C.BLACK[1], G.C.BLACK[2], G.C.BLACK[3], 0.65 }
	FishAndChips.C.FISHING_BUTTONS_TEXT = { G.C.UI.TEXT_LIGHT[1], G.C.UI.TEXT_LIGHT[2], G.C.UI.TEXT_LIGHT[3], 1 }
end


G.FUNCS.fac_can_use_fish = function(e)
	local center = e.config.ref_table.config.center
	local card = e.config.ref_table
	card._fac_use_key = localize("b_use")
	if
		center.can_use and center:can_use(e.config.ref_table) and not e.config.ref_table.debuff
		and G.STATE ~= G.STATES.HAND_PLAYED and G.STATE ~= G.STATES.DRAW_TO_HAND and G.STATE ~= G.STATES.PLAY_TAROT
		and not (((G.play and #G.play.cards > 0) or (G.CONTROLLER.locked) or (G.GAME.STOP_USE and G.GAME.STOP_USE > 0)))
	then
		e.config.colour = G.C.ORANGE
		e.config.button = "fac_use_fish"
	else
		e.config.colour = G.C.UI.BACKGROUND_INACTIVE
		e.config.button = nil
	end
end

G.FUNCS.fac_use_fish = function(e)
	local card = e.config.ref_table
	local prev_state = G.TAROT_INTERRUPT
	G.TAROT_INTERRUPT = G.STATE
	G.CONTROLLER.locks.use = true
	
	local center = card.config.center
	local keep_on_use = false
	if center.keep_on_use and type(center.keep_on_use) == 'function' then
        keep_on_use = center:keep_on_use(card)
    end
	if center.use and type(center.use) == 'function' then
		center:use(card)
	end
	card:juice_up()
	
	G.E_MANAGER:add_event(Event({
		delay = 0.2,
		func = function()
			if not keep_on_use then card:start_dissolve() end
			G.E_MANAGER:add_event(Event({
				delay = 0.1,
				func = function()
					G.TAROT_INTERRUPT = prev_state
					G.CONTROLLER.locks.use = false
					return true;
				end
			}))
			return true;
		end
	}))

	G.GAME.fac_last_used_fish = card.config.center_key
end

local uielement_click_ref = UIElement.click
---@diagnostic disable-next-line: duplicate-set-field
function UIElement:click(...)
	if FishAndChips.safe_to_press_buttons() or self.config.fac_ignore then
		return uielement_click_ref(self, ...)
	end
end

local smods_add_to_deck_ref = SMODS.add_to_deck
---@diagnostic disable-next-line: duplicate-set-field
function SMODS.add_to_deck (card, args)
	if not args.area and card.config.center.set == "fac_Fish" then args.area = G.fac_fish_area end
	return smods_add_to_deck_ref(card, args)
end

local card_open_ref = Card.open
function Card:open()
	G.GAME.fac_booster_opening = true
	card_open_ref(self)
	G.E_MANAGER:add_event(Event({
		func = function()
			G.E_MANAGER:add_event(Event({
				func = function()
					G.GAME.fac_booster_opening = nil
					return true;
				end
			}))
			return true;
		end
	}))
end

local start_run_hook = Game.start_run
function Game:start_run(args)
	start_run_hook(self, args)
	G.GAME.fac_fish_expanded = false
end
