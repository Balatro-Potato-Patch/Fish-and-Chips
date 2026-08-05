--[[ TODO SHIT
https://www.youtube.com/watch?v=-ARE0i6dzsU garfield monday lines

Seiun Sky weight displayed as "Undeclared"
]]


PotatoPatchUtils.Developer({
	name = 'DottyKitty',
	atlas = 'fac_cards',
	colour = G.C.BLUE,
	fac_partner = 'CampfireCollective' 
})
PotatoPatchUtils.Developer({
	name = 'CampfireCollective',
	atlas = 'fac_cards',
	pos = {x = 1, y = 0},
	colour = G.C.PURPLE,
	fac_partner = 'DottyKitty'
})
SMODS.Atlas({
	key = "CCittyfish", 
	path = "CCitty/CCittyfish.png",
	px = 71,
	py = 95,
})

SMODS.Sound({
	key = "CCitty_drewitup",
	path = "CCitty/drewitup.mp3"
})
SMODS.Sound({
	key = "CCitty_ecstasy",
	path = "CCitty/ecstasy.mp3"
})
SMODS.Sound({
	key = "CCitty_gonext",
	path = "CCitty/gonext.mp3"
})
SMODS.Sound({
	key = "CCitty_laugh",
	path = "CCitty/laugh.mp3"
})
SMODS.Sound({
	key = "CCitty_lightemup",
	path = "CCitty/lightemup.mp3"
})
SMODS.Sound({
	key = "CCitty_michelle",
	path = "CCitty/michelle.mp3"
})
SMODS.Sound({
	key = "CCitty_muhnee",
	path = "CCitty/muhnee.mp3"
})
SMODS.Sound({
	key = "CCitty_nooo",
	path = "CCitty/nooo.mp3"
})
SMODS.Sound({
	key = "CCitty_sadmuhnee",
	path = "CCitty/sadmuhnee.mp3"
})
SMODS.Sound({
	key = "CCitty_stinky",
	path = "CCitty/stinky.mp3"
})
SMODS.Sound({
	key = "CCitty_welcomeback",
	path = "CCitty/welcomeback.mp3"
})
SMODS.Sound({
	key = "CCitty_yass",
	path = "CCitty/yass.mp3"
})

FishAndChips.Fish { --perkoio
	key = "perkoio",
	atlas = "CCittyfish",
	pos = { x = 0, y = 0 },
	weight = 1,
	ppu_coder = { "CampfireCollective" },
	ppu_artist = { "DottyKitty" },
	attributes = { 'generation','copying'},
	config = {
		extra = {
			rounds = 1,
            remaining = 1
		}
	},
	environments = {
		soup = 1
	},
    blueprint_compat = false,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.rounds,card.ability.extra.remaining } }
	end,
	calculate = function(self, card, context)
		if context.end_of_round and context.main_eval and not context.blueprint then 
            card.ability.extra.remaining = card.ability.extra.remaining - 1
            if card.ability.extra.remaining <= 0 then
                if #G.jokers.cards > 0 then
                    local _card = copy_card(pseudorandom_element(G.jokers.cards, pseudoseed('perkoio')), nil,nil,nil, true)
					_card:add_to_deck()
					G.jokers:emplace(_card)
                    _card:set_edition{negative = true}
                    card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_duplicated_ex')})
                else
                    card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_no_other_jokers')})
                end
                card.ability.extra.remaining = card.ability.extra.rounds
            end
        end
	end,
}

FishAndChips.Fish { --yoray
	key = "yoray",
	atlas = "CCittyfish",
	pos = { x = 1, y = 0 },
	weight = 1,
	ppu_coder = {"CampfireCollective"},
	ppu_artist = {"DottyKitty"},
	attributes = {'xmult'},
	config = {
		extra = {
            Xmult = .23
		}
	},
	environments = {
        styx = 1
	},
	loc_vars = function(self, info_queue, card)
		return {vars = {card.ability.extra.Xmult}}
	end,
	calculate = function(self, card, context)
		if context.discard then
            context.other_card.ability.perma_x_mult = context.other_card.ability.perma_x_mult or 1
            context.other_card.ability.perma_x_mult = context.other_card.ability.perma_x_mult + card.ability.extra.Xmult
            return {
                message = 'Yoray!',
                card = context.other_card,
                delay = 0.1
            }
        end
	end,
}

FishAndChips.Fish { --canioctopus 
	key = "canioctopus",
	atlas = "CCittyfish",
	pos = { x = 0, y = 1 },
	weight = 1,
	ppu_coder = { "CampfireCollective" },
	ppu_artist = { "DottyKitty" },
	attributes = { 'economy','destroy_card'},
	config = {
		extra = {
            bait = 1
		}
	},
	environments = {
        volcano = 1
	},
	loc_vars = function(self, info_queue, card)
		return {vars = {}}
	end,
	calculate = function(self, card, context)
		if context.remove_playing_cards then
			local w = (G.CARD_W + 0.1) * card.ability.extra.bait * #context.removed * 2 - 0.1
			local h = G.CARD_H
			G.fac_temp_bait_area = CardArea(
				card.T.x + card.T.w / 2 - w / 2, card.T.y - 0.5 - h,
				w, h,
				{
					type = "joker",
					card_limit = card.ability.extra.bait * #context.removed,
					highlight_limit = 1,
					highlighted_limit = 1,
					align_buttons = true,
					bg_colour = G.C.CLEAR,
					fixed_limit = true,
					no_card_count = true,
				}
			)
			delay(1)
			for i = 1, card.ability.extra.bait * #context.removed do
				G.E_MANAGER:add_event(Event {
					func = function()
						local card = SMODS.create_card { set = "fac_Bait" }
						G.fac_temp_bait_area:emplace(card)
						FishAndChips.add_bait_to_inventory(card.config.center.key)
						return true
					end
				})
				delay(0.2)
			end
			delay(1)
			for i = 1, card.ability.extra.bait * #context.removed do
				G.E_MANAGER:add_event(Event {
					func = function()
						G.fac_temp_bait_area.cards[1]:start_dissolve()
						return true
					end
				})
				delay(0.2)
			end
			delay(0.5)
			G.E_MANAGER:add_event(Event {
				func = function()
					G.fac_temp_bait_area:remove()
					return true
				end
			})
		elseif context.joker_type_destroyed then
			local w = (G.CARD_W + 0.1) * card.ability.extra.bait * 2 - 0.1
			local h = G.CARD_H
			G.fac_temp_bait_area = CardArea(
				card.T.x + card.T.w / 2 - w / 2, card.T.y - 0.5 - h,
				w, h,
				{
					type = "joker",
					card_limit = card.ability.extra.bait,
					highlight_limit = 1,
					highlighted_limit = 1,
					align_buttons = true,
					bg_colour = G.C.CLEAR,
					fixed_limit = true,
					no_card_count = true,
				}
			)
			delay(1)
			for i = 1, card.ability.extra.bait do
				G.E_MANAGER:add_event(Event {
					func = function()
						local card = SMODS.create_card { set = "fac_Bait" }
						G.fac_temp_bait_area:emplace(card)
						FishAndChips.add_bait_to_inventory(card.config.center.key)
						return true
					end
				})
				delay(0.2)
			end
			delay(1)
			for i = 1, card.ability.extra.bait do
				G.E_MANAGER:add_event(Event {
					func = function()
						G.fac_temp_bait_area.cards[1]:start_dissolve()
						return true
					end
				})
				delay(0.2)
			end
			delay(0.5)
			G.E_MANAGER:add_event(Event {
				func = function()
					G.fac_temp_bait_area:remove()
					return true
				end
			})
		end
	end,
}

FishAndChips.Fish { --troutulet
	key = "troutulet",
	atlas = "CCittyfish",
	pos = { x = 2, y = 0 },
	weight = 1,
	ppu_coder = { "CampfireCollective" },
	ppu_artist = { "DottyKitty" },
	attributes = { 'economy'},
	config = {
		extra = {
            sand = 1,
			rep = 1
		}
	},
	environments = {
        city_river = 1
	},
	loc_vars = function(self, info_queue, card)
		return { vars = {} }
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play then
			if (context.other_card:get_id() == 12 or context.other_card:get_id() == 13) then
				return {
					sand_dollars = card.ability.extra.sand
				}
			end
		elseif context.repetition and context.cardarea == G.play then
			if (context.other_card:get_id() == 12 or context.other_card:get_id() == 13) then
				return {
					repetitions = card.ability.extra.rep,
					message = localize('k_again_ex'),
					card = card
				}
			end
		end
	end,
}

FishAndChips.Fish { --chicod
	key = "chicod",
	atlas = "CCittyfish",
	pos = { x = 1, y = 1 },
	weight = 1,
	ppu_coder = { "CampfireCollective" },
	ppu_artist = { "DottyKitty" },
	attributes = { 'boss_blind'},
	config = {
		extra = {
            reduce = 0.75
		}
	},
	environments = {
		swamp = 1
	},
	loc_vars = function(self, info_queue, card)
		return { vars = {card.ability.extra.reduce} }
	end,
	calculate = function(self, card, context)
        if context.selling_card and G.STATE == G.STATES.SELECTING_HAND then
            return {
                xblindsize = card.ability.extra.reduce,
                colour = G.C.RED
            }
        end
	end,
}

--shoutout balatrostuck dialogue functions vvv (with minor edits)
function Card:CCitty_dialogue_say_stuff(n, sound, not_first, pitch)
    self.talking = true
    local pitch = pitch or 1
    if not not_first then 
        G.E_MANAGER:add_event(Event({trigger = "after", delay = 0.1, func = function()
            if self.children.speech_bubble then self.children.speech_bubble.states.visible = true end
            self:CCitty_dialogue_say_stuff(n, sound, true, pitch)
        return true end}), 'other')
		if sound then
			play_sound(sound[1], sound[2] or nil, sound[3] or nil)
			play_sound(sound[1], sound[2] or nil, sound[3] or nil)
			-- play_sound(sound[1], sound[2] or nil, sound[3] or nil)
		end
    else
        if n <= 0 then self.talking = false; return end
		if not sound then
        	play_sound('voice'..math.random(1, 11), pitch*(math.random()*0.2+1), 0.5)
		end
        self:juice_up()
        G.E_MANAGER:add_event(Event({trigger = "after", blockable = false, blocking = false, delay = 0.13, func = function()
            self:CCitty_dialogue_say_stuff(n-1, true, pitch)
        return true end}), 'other')
    end
end
function Card:CCitty_add_dialogue(text_key, sound, align, yap_amount, baba_pitch)
    if self.children.speech_bubble then self.children.speech_bubble:remove() end
    self.config.speech_bubble_align = {align=align or 'bm', offset = {x=-1,y=-4},parent = self}
    self.children.speech_bubble = 
    UIBox{
        definition = G.UIDEF.speech_bubble(text_key, {quip = true}),
        config = self.config.speech_bubble_align
    }
    self.children.speech_bubble:set_role{role_type = "Minor", xy_bond = "Strong", r_bond = "Strong", major = self}
    self.children.speech_bubble.states.visible = false
    local yap_amount = yap_amount or 5
    local baba_pitch = baba_pitch or 1
    self:CCitty_dialogue_say_stuff(yap_amount, sound, nil, baba_pitch)
end
function Card:CCitty_remove_dialogue(timer)
    local timer = (timer * G.SETTINGS.GAMESPEED) or 0
    G.E_MANAGER:add_event(Event({trigger = "after", blockable = false, blocking = false, delay = timer, func = function()
        if self.children.speech_bubble then self.children.speech_bubble:remove(); self.children.speech_bubble = nil end
    return true end}))
end
function CCitty_tip()
	return 'CCitty_tip'..pseudorandom('doctortips',1,5)
end
FishAndChips.Fish { --Doctor Sharktred TODO
	key = "drspectred",
	atlas = "CCittyfish",
	pos = { x = 2, y = 1 },
	blueprint_compat = false,
	weight = 20,
	ppu_coder = { "CampfireCollective" },
	ppu_artist = { "DottyKitty" },
	attributes = { },
	config = {
		extra = {
		}
	},
	environments = {
        calm_pond = 20,
        city_river = 18,
        aquifer = 15

	},
	loc_vars = function(self, info_queue, card)
		return { vars = {  } }
	end,
	add_to_deck = function (self, card, from_debuff)
		card:CCitty_add_dialogue('CCitty_welcomeback',{'fac_CCitty_welcomeback'})
		card:CCitty_remove_dialogue(5)
	end,
	remove_from_deck = function(self,card,from_debuff)
		card:CCitty_add_dialogue('CCitty_nooo',{'fac_CCitty_nooo'}) --can't see the dialogue but eh
		card:CCitty_remove_dialogue(5)
	end,

	calculate = function(self, card, context)
		if not context.blueprint then
			if context.end_of_round and context.main_eval then 													--end of round options
				if G.GAME.chips/G.GAME.blind.chips < 1.02 and G.GAME.chips > G.GAME.blind.chips then				--close call
					card:CCitty_add_dialogue('CCitty_calc')
					card:CCitty_remove_dialogue(5)
				elseif G.GAME.current_round.hands_left then 														--all hands used
					card:CCitty_add_dialogue('CCitty_neverpunished')
					card:CCitty_remove_dialogue(5)
				elseif context.game_over then
					card:CCitty_add_dialogue('CCitty_gameover',{'fac_CCitty_stinky'})
					card:CCitty_remove_dialogue(5)
				end

			elseif context.money_altered then																	--money changes
				if context.amount <= -20 then																		--big loss
					card:CCitty_add_dialogue('CCitty_loss',{'fac_CCitty_sadmuhnee'})
					card:CCitty_remove_dialogue(5)
				elseif context.amount >= 20 then																	--big gain
					card:CCitty_add_dialogue('CCitty_gain',{'fac_CCitty_yass'})
					card:CCitty_remove_dialogue(5)
				end

			elseif context.first_hand_drawn then
				
			end
		end
	end,
}

FishAndChips.Fish { --Seiun Sky seahorse TODO
	key = "seiunsky",
	atlas = "CCittyfish",
	pos = { x = 1, y = 2 },
	weight = 10,
    decision_min = 0.8,
    decision_max = 1.2,
    impulse_min = .08,
    impulse_max = .18,
	ppu_coder = { "CampfireCollective" },
	ppu_artist = { "DottyKitty" },
	attributes = {'passive','usable'},
	config = {
		extra = {
            odds = 4,
            freeroll = 1
		}
	},
	environments = {
        garden = 5,
        soup = 3,
        calm_pond = 2
	},
	loc_vars = function(self, info_queue, card)
		return { vars = {} }
	end,

    use = function(self, card)
        
        card.ability.extra.freeroll = 0
    end,
    can_use = function(self, card)
        return card.ability.extra.freeroll > 0 and G.FISHING_STATE == G.FISHING_STATES.LOBBY
    end,
    keep_on_use = function(self, card)
        return true
    end,

	calculate = function(self, card, context)
		if context.fac_end_fishing and context.fish then
            
        elseif context.ending_fishing and not context.blueprint then
            card.ability.extra.freeroll = 1
        end
	end,
}

local where_making_it_hapen = ease_background_colour
function ease_background_colour(args)
    if G.GAME and G.GAME.distaction then
        local car = {}
        for _, v in ipairs(G.C) do
            car[#car+1] = v
            if #car == 27 then break end
        end
        for _, v in pairs(G.C.SET) do
            car[#car+1] = v
        end
        for _, v in pairs(G.C.SECONDARY_SET) do
            car[#car+1] = v
        end
        local car = pseudorandom_element(car,pseudoseed('ihavethe'))
        if args.new_colour then
            args.new_colour = mix_colours(darken(car, 0.4), args.new_colour, math.min(.9, G.GAME.distaction))
        end
        if args.special_colour then
            args.special_colour = mix_colours(darken(car, 0.4), args.special_colour, math.min(.9, G.GAME.distaction))
        end
        if args.tertiary_colour then
            args.tertiary_colour = mix_colours(darken(car, 0.4), args.tertiary_colour, math.min(.9, G.GAME.distaction))
        end
    end
    return where_making_it_hapen(args)
end
SMODS.Atlas({
	key = "fihs_CCitty_desc",
	path = "CCitty/fihs_CCitty_desc.png",
	px = 500,
	py = 250,
})
FishAndChips.Fish { --sweet bro and hella jeff fish
	key = "fihs_CCitty",
	atlas = "CCittyfish",
	pos = { x = 2, y = 2 },
	weight = 10,
	ppu_coder = { "CampfireCollective" },
	ppu_artist = { "CampfireCollective" },
	attributes = {'mult'},
	config = {
		extra = {
			lines = {
				"i warned you about stairs fish!!!! i told you fish!",
				"today i put......... JELLY on this fish",
				"maybe there right ..... that some times video games, DOES cause violence",
				"that is SO SWEET man how about a fish hug bump",
				"fish........ i AM SO JEALOUS you KNOW i love the big game.",
				"AGAIN with the socks what IS it even with you and SOCKS FISH",
				"i could tell you but then i'd would have to kill you",
				"not all fishs are the same",
				"NANCHO PARTY",
				"who were you expecting.... the easter fish>",
				"WHAT'S IS that fishs even his PROBLEM?", 	
				"dude, open then drawer FIRST!!! THAN punt the fish in.",
				"everyboby all yall hold up",
				"100# garganted to be you're new friend..........",
				"deudly"
			},
			chosen = 1
		}
	},
	environments = {
        backroom = 1
	},
	loc_vars = function(self, info_queue, card)
		return { vars = {elements = {SMODS.create_sprite(0, 0, 3.5, 3.5 * 250 / 500, "fac_fihs_CCitty_desc")}, card.ability.extra.lines[card.ability.extra.chosen]}}
	end,
	in_pool = function(self, args)
		return pseudorandom('howhighdoyouevenhavetobe') < 1 / 4
	end,
    add_to_deck = function(self, card, from_debuff)
        if not from_debuff then
            G.GAME.distaction = G.GAME.distaction or 0.04
        end
		card.ability.extra.chosen = pseudorandom('keepitreal',1,15)
    end,
	calculate = function(self, card, context)
		if context.joker_main then
            G.GAME.distaction = G.GAME.distaction + 0.04
			card.ability.extra.chosen = pseudorandom('keepitreal',1,15)
        elseif context.final_scoring_step and not context.blueprint then
            mult = mult + pseudorandom('hehastheball',8,13) + pseudorandom('hehastheball')
            return {
                message = "+10 mult..........",
                colour = G.C.FILTER
            }
        end
	end,

    use = function(self, card)
        local _card = copy_card(card) --intended behaviour
    end,
    can_use = function(self, card)
        return true
    end,
    keep_on_use = function(self, card)
        return false
    end,
}

FishAndChips.Fish { --Garfield Phone TODO
	key = "garfieldphone",
	atlas = "CCittyfish",
	pos = { x = 0, y = 2 },
	weight = 10,
    treasure = true,
	ppu_coder = { "CampfireCollective" },
	ppu_artist = { "DottyKitty" },
	attributes = { 'usable', 'generation' },
	config = {
		extra = {
		}
	},
	environments = {
        pier = 10,
        backroom = 3,
        wormhole = 2
	},
	loc_vars = function(self, info_queue, card)
		return { vars = {  } }
	end,
	calculate = function(self, card, context)
		
	end,
}

FishAndChips.Fish { --Bluebell Angler
	key = "bluebell_angler",
	atlas = "CCittyfish",
	pos = { x = 0, y = 3 },
	weight = 10,
	ppu_coder = { "CampfireCollective" },
	ppu_artist = { "DottyKitty" },
	attributes = { },
	config = {
		extra = {
		}
	},
	environments = {
		aquifer = 1,
		garden = 1
	},
	loc_vars = function(self, info_queue, card)
		return { vars = {} }
	end,
	calculate = function(self, card, context)
		if (context.first_hand_drawn or context.hand_drawn) and G.GAME.current_round.hands_played == 0 then
			if not context.blueprint then
				local any_forced = nil
				for k, v in ipairs(G.hand.cards) do
					if v.ability.forced_selection then
						any_forced = true
						v.ability.bluebell_choice = true
					end
				end
				if not any_forced then 
					G.hand:unhighlight_all()
					local forced_card = pseudorandom_element(G.hand.cards, pseudoseed('blue_bell'))
					forced_card.ability.forced_selection = true
					forced_card.ability.bluebell_choice = true
					G.hand:add_to_highlighted(forced_card)
				end
			end
		elseif context.before then
			local bluebell = false
			for _, v in pairs(context.scoring_hand) do
				if v.ability.bluebell_choice then bluebell = true break end
			end
			for _, v in pairs(context.full_hand) do
				if v.ability.bluebell_choice then v.ability.bluebell_choice = nil break end
			end
			if bluebell then
				for _, v in ipairs(context.scoring_hand) do
					local choice = pseudorandom('bluebell')
					if choice < 1 / 200 then --perma repetition
						v.ability.perma_repetition = (v.ability.perma_repetition or 0) + 1
					elseif choice < 1 / 15 then --perma money
						choice = pseudorandom('bluebell')
						if choice < 1 / 3 then 
							v.ability.perma_p_dollars = (v.ability.perma_p_dollars or 0) + 1
						else
							v.ability.perma_h_dollars = (v.ability.perma_h_dollars or 0) + 1
						end
					else --perma scoring stuff
						choice = pseudorandom('bluebell')
						if choice < 1 / 5 then --X
							choice = pseudorandom('bluebell')
							if choice < 1 / 6 then
								v.ability.perma_h_x_chips = (v.ability.perma_h_x_chips or 1) + 0.2
							elseif choice < 2 / 6 then
								v.ability.perma_h_x_mult = (v.ability.perma_h_x_mult or 1) + 0.2
							elseif choice < 4 / 6 then
								v.ability.perma_x_chips = (v.ability.perma_x_chips or 1) + 0.2
							else
								v.ability.perma_x_mult = (v.ability.perma_x_mult or 1) + 0.2
							end
						else --addition
							choice = pseudorandom('bluebell')
							if choice < 1 / 6 then
								v.ability.perma_h_chips = (v.ability.perma_h_chips or 0) + 1
							elseif choice < 2 / 6 then
								v.ability.perma_h_mult = (v.ability.perma_h_mult or 0) + 1
							elseif choice < 4 / 6 then
								v.ability.perma_chips = (v.ability.perma_chips or 0) + 1
							else
								v.ability.perma_mult = (v.ability.perma_mult or 0) + 1
							end
						end
					end
					v:juice_up()
				end
				card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_upgrade_ex'), colour = G.C.SECONDARY_SET.Spectral})
			end
		end
	end,
}

FishAndChips.Fish { --Solin the Sea Slug
	key = "solinseaslug",
	atlas = "CCittyfish",
	pos = { x = 1, y = 3 },
	weight = 10,
	ppu_coder = { "CampfireCollective" },
	ppu_artist = { "DottyKitty" },
	attributes = {'economy','food'},
	config = {
		extra = {
			remaining = 5,
			dollars = 5,
			names = {'Solin','Solin','Solin','Solin','Secil','Shris','Slive','Slyde','Sharlie','Slinky','Suthbert','Sorris','Siggles','Siara','Sooper','Sarl','Sompost','Sompost','Sompost','Sompost'},
			chosen = 1
		}
	},
	environments = {
		chocolate_river = 1
	},
	loc_vars = function(self, info_queue, card)
		return { vars = {card.ability.extra.dollars, card.ability.extra.remaining, card.ability.extra.names[card.ability.extra.chosen], card.ability.extra.chosen < 17 and "This delectable Slug goes by numerous names. It often rolls on" or "You could say he is... pogging through the pain. It attempts to", card.ability.extra.chosen < 17 and "the ocean floor, picking up chocolate beans in the process." or "roll on the ocean floor, though typically gets stuck on it."} }
	end,

	on_catch = function(self, card)
		card.ability.extra.chosen = pseudorandom('solin',1,20)
		if card.ability.extra.chosen >= 5 then
			if card.ability.extra.chosen >= 17 then
				card.ability.extra.dollars = 3
				card.children.center:set_sprite_pos{x = 2, y = 3}
			else 
				card.ability.extra.dollars = 4
			end
		end
	end,

	calculate = function(self, card, context)
		if context.selling_card then
			if context.card.ability.set == 'fac_Fish' then
				card.ability.extra.remaining = card.ability.extra.remaining - 1
				if card.ability.extra.remaining <= 0 then
					SMODS.destroy_cards(card)
				end
				return {
					dollars = card.ability.extra.dollars,
				}
			end
		end
	end,
}