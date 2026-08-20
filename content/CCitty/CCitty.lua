SMODS.Atlas({
	key = "Kittyfire",
	path = "CCitty/Kittyfire.png",
	px = 142,
	py = 95,
})
SMODS.Atlas({
	key = "We_fishing_it",
	path = "CCitty/We_fishing_it.png",
	px = 128,
	py = 64,
})
SMODS.Atlas({
	key = "mybeautifulandwonderfulfish",
	path = "CCitty/mybeautifulandwonderfulfish.png",
	px = 3024,
	py = 4032,
})
PotatoPatchUtils.Developer({
	name = 'DottyKitty',
	atlas = 'fac_Kittyfire',
	pos = { x = 0, y = 0 },
	colour = G.C.GREEN,
	fac_partner = 'fac_CampfireCollective',
	joint_credits = 2,
	loc = true,
	loc_vars = function(self, info_queue, card)
		return { vars = { elements = { SMODS.create_sprite(0, 0, 3.5, 3.5 * 64 / 128, "fac_We_fishing_it") } } }
	end,
})
PotatoPatchUtils.Developer({
	name = 'CampfireCollective',
	atlas = 'fac_Kittyfire',
	pos = { x = 0, y = 0 },
	colour = G.C.PURPLE,
	fac_partner = 'fac_DottyKitty',
	joint_credits = 2,
	loc = true,
	loc_vars = function(self, info_queue, card)
		return { vars = { elements = { SMODS.create_sprite(0, 0, 2, 2 * 4032 / 3024, "fac_mybeautifulandwonderfulfish") } } }
	end,
})

SMODS.Atlas({
	key = "CCittyfish",
	path = "CCitty/CCittyfish.png",
	px = 71,
	py = 95,
})


FishAndChips.Fish { --perkoio
	key = "perkoio",
	atlas = "CCittyfish",
	pos = { x = 0, y = 0 },
	weight = 1,
	ppu_coder = { "CampfireCollective" },
	ppu_artist = { "DottyKitty" },
	attributes = { 'generation', 'joker', },
	config = {
		extra = {
			rounds = 4,
			remaining = 4
		}
	},
	stats = {
		weight = { min = 2.2, max = 18 },
		length = { min = .6, max = 1 }
	},
	environments = {
		soup = 1
	},
	blueprint_compat = false,
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue+1] = G.P_CENTERS["e_negative"]
		return { vars = { card.ability.extra.rounds, card.ability.extra.remaining } }
	end,
	calculate = function(self, card, context)
		if context.end_of_round and context.main_eval and not context.blueprint then
			card.ability.extra.remaining = card.ability.extra.remaining - 1
			if card.ability.extra.remaining <= 0 then
				if #G.jokers.cards > 0 then
					local _card = copy_card(pseudorandom_element(G.jokers.cards, pseudoseed('perkoio')), nil, nil, nil, true)
					_card:add_to_deck()
					G.jokers:emplace(_card)
					_card:set_edition { negative = true }
					card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, { message = localize('k_duplicated_ex') })
				else
					card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, { message = localize('k_fac_no_jokers') })
				end
				card.ability.extra.remaining = card.ability.extra.rounds
			else
				return { message = card.ability.extra.remaining.."" }
			end
		end
	end,
}

FishAndChips.Fish { --yoray
	key = "yoray",
	atlas = "CCittyfish",
	pos = { x = 1, y = 0 },
	weight = 1,
	ppu_coder = { "CampfireCollective" },
	ppu_artist = { "DottyKitty" },
	attributes = { 'xmult', 'discard', 'modify_card', 'perma_bonus', },
	config = {
		extra = {
			Xmult = .23
		}
	},
	stats = {
		weight = { min = 1, max = 30 },
		length = { min = .1, max = 400 }
	},
	environments = {
		styx = 1
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.Xmult } }
	end,
	calculate = function(self, card, context)
		if context.discard and G.GAME.current_round.discards_left == 1 then
			context.other_card.ability.perma_x_mult = context.other_card.ability.perma_x_mult or 1
			context.other_card.ability.perma_x_mult = context.other_card.ability.perma_x_mult + card.ability.extra.Xmult
			return {
				message = 'Yoray!',
				message_card = context.other_card,
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
	attributes = { 'generation', },
	config = {
		extra = {
			bait = 1
		}
	},
	stats = {
		weight = { min = 0.06, max = .3 },
		length = { min = .06, max = .15 }
	},
	environments = {
		volcano = 1
	},
	loc_vars = function(self, info_queue, card)
		return { vars = {} }
	end,
	calculate = function(self, card, context)
		if context.remove_playing_cards or context.joker_type_destroyed then
			local removed = context.removed and #context.removed or 1
			FishAndChips.create_baits_from_card(card, card.ability.extra.bait * removed)
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
	attributes = { 'economy', 'rank', 'king', 'queen', },
	config = {
		extra = {
			sand = 1,
			rep = 1
		}
	},
	stats = {
		weight = { min = 0.2, max = 4 },
		length = { min = 0.2, max = 0.7 }
	},
	environments = {
		city_river = 1
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.sand } }
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play then
			if context.other_card:get_id() == 12 or context.other_card:get_id() == 13 then
				return {
					sand_dollars = card.ability.extra.sand
				}
			end
		elseif context.repetition and context.cardarea == G.play then
			if context.other_card:get_id() == 12 or context.other_card:get_id() == 13 then
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
	attributes = { 'xblindsize', 'on_sell', },
	config = {
		extra = {
			reduce = 0.75
		}
	},
	stats = {
		weight = { min = 2.7, max = 11 },
		length = { min = 0.7, max = 1 }
	},
	environments = {
		swamp = 1
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.reduce } }
	end,
	calculate = function(self, card, context)
		if context.selling_card and context.card ~= card and G.STATE == G.STATES.SELECTING_HAND then
			return {
				xblindsize = card.ability.extra.reduce,
				colour = G.C.RED
			}
		end
	end,
}

--shoutout balatrostuck dialogue functions vvv (with minor edits)
function Card:CCitty_dialogue_say_stuff(n, sound, not_first, pitch, dialogue_id)
	if dialogue_id ~= self.CCitty_dialogue_id then return end
	self.talking = true
	local pitch = pitch or 1
	if not not_first then
		G.E_MANAGER:add_event(Event({
			trigger = "after",
			delay = 0.1,
			func = function()
				if dialogue_id ~= self.CCitty_dialogue_id then return true end
				if self.children.speech_bubble then self.children.speech_bubble.states.visible = true end

				if sound then
					if not G.GAME.sixsevenalready then
						if pseudorandom('docsixseven') < 1 / 150 then
							sound = { 'fac_CCitty_67' }
							G.GAME.sixsevenalready = true
						end
					end
					play_sound(sound[1], sound[2], sound[3] or 0.7) -- i amplified the voice lines, so they need to be quieter (ghostsalt)
				end
				return true
			end
		}))
		self:CCitty_dialogue_say_stuff(n - 1, sound, true, pitch, dialogue_id)
	else
		if n <= 0 then
			self.talking = false; return
		end
		G.E_MANAGER:add_event(Event({
			trigger = "after",
			delay = 0.13,
			func = function()
				if dialogue_id ~= self.CCitty_dialogue_id then return true end
				if not sound then
					play_sound('voice' .. math.random(1, 11), pitch * (math.random() * 0.2 + 1), 0.5)
				end
				self:juice_up()
				return true
			end
		}))
		self:CCitty_dialogue_say_stuff(n - 1, sound, true, pitch, dialogue_id)
	end
end

function Card:CCitty_add_dialogue(text_key, sound, align, yap_amount, baba_pitch)
	if self.children.speech_bubble then self.children.speech_bubble:remove() end
	self.CCitty_dialogue_id = (self.CCitty_dialogue_id or 0) + 1
	self.config.speech_bubble_align = { align = align or 'bm', offset = { x = -1, y = -4 }, parent = self }
	self.children.speech_bubble =
		UIBox {
			definition = G.UIDEF.speech_bubble(text_key, { quip = true }),
			config = self.config.speech_bubble_align
		}
	self.children.speech_bubble:set_role { role_type = "Minor", xy_bond = "Strong", r_bond = "Strong", major = self }
	self.children.speech_bubble.states.visible = false
	local yap_amount = yap_amount or 5
	local baba_pitch = baba_pitch or 1
	self:CCitty_dialogue_say_stuff(yap_amount, sound, nil, baba_pitch, self.CCitty_dialogue_id)
end

function Card:CCitty_remove_dialogue(timer)
	local dialogue_id = self.CCitty_dialogue_id
	G.E_MANAGER:add_event(Event({
		trigger = "after",
		timer = "REAL",
		blockable = false,
		blocking = false,
		delay = timer,
		func = function()
			if dialogue_id == self.CCitty_dialogue_id and self.children.speech_bubble then
				self.children.speech_bubble:remove(); self.children.speech_bubble = nil
			end
			return true
		end
	}))
end

function CCitty_tip()
	return 'CCitty_tip' .. pseudorandom('doctortips', 1, 5)
end

FishAndChips.Fish { --Doctor Sharktred
	key = "drspectred",
	atlas = "CCittyfish",
	pos = { x = 2, y = 1 },
	blueprint_compat = false,
	weight = 20,
	ppu_coder = { "CampfireCollective" },
	ppu_artist = { "DottyKitty" },
	attributes = { 'nothing' },
	config = {
		extra = {
		}
	},
	stats = {
		weight = { min = 80, max = 330 },
		length = { min = 1, max = 3 }
	},
	environments = {
		calm_pond = 20,
		city_river = 18,
		aquifer = 15

	},
	loc_vars = function(self, info_queue, card)
		return { vars = {} }
	end,
	add_to_deck = function(self, card, from_debuff)
		card:CCitty_add_dialogue('CCitty_welcomeback', { 'fac_CCitty_welcomeback' })
		card:CCitty_remove_dialogue(5)
	end,
	remove_from_deck = function(self, card, from_debuff)
		card:CCitty_add_dialogue('CCitty_nooo', { 'fac_CCitty_nooo' }) --can't see the dialogue but eh
		card:CCitty_remove_dialogue(5)
	end,

	calculate = function(self, card, context)
		if not context.blueprint then
			if context.end_of_round and not context.repetition and not context.individual then --end of round options
				if G.GAME.chips == G.GAME.blind.chips then
					card:CCitty_add_dialogue('CCitty_Potassium', { 'fac_CCitty_Potassium' })
					card:CCitty_remove_dialogue(5)
				elseif G.GAME.chips / G.GAME.blind.chips < 1.02 and G.GAME.chips > G.GAME.blind.chips then --close call
					card:CCitty_add_dialogue('CCitty_calc', { 'fac_CCitty_Kachow' })
					card:CCitty_remove_dialogue(5)
				elseif G.GAME.current_round.hands_left == 0 then --all hands used
					card:CCitty_add_dialogue('CCitty_neverpunished', { 'fac_CCitty_NeverDidntHaveIt' })
					card:CCitty_remove_dialogue(5)
				elseif G.GAME.blind.boss then --boss beaten
					card:CCitty_add_dialogue('CCitty_drewitup', { 'fac_CCitty_drewitup' })
					card:CCitty_remove_dialogue(5)
				elseif context.game_over then
					card:CCitty_add_dialogue('CCitty_gameover', { 'fac_CCitty_stinky' })
					card:CCitty_remove_dialogue(5)
				end

			elseif context.before then
				if SMODS.has_enhancement(context.scoring_hand[#context.scoring_hand], "m_glass") then
					card:CCitty_add_dialogue('CCitty_GoSmash', { 'fac_CCitty_GoSmash' })
					card:CCitty_remove_dialogue(5)
				end

			elseif context.after then
				local hand_score = SMODS.calculate_round_score()
				local total_chips = G.GAME.chips + hand_score
				if hand_score < 100 then
					card:CCitty_add_dialogue('CCitty_Amount', { 'fac_CCitty_Amount' })
					card:CCitty_remove_dialogue(5)
				elseif total_chips / G.GAME.blind.chips > 0.98 and total_chips < G.GAME.blind.chips then
					card:CCitty_add_dialogue('CCitty_NotEnough', { 'fac_CCitty_NotEnough' })
					card:CCitty_remove_dialogue(5)
				end

			elseif context.debuffed_hand then
				if G.GAME.current_round.hands_left == 1 then
					card:CCitty_add_dialogue('CCitty_UhOh', { 'fac_CCitty_UhOh' })
					card:CCitty_remove_dialogue(5)
				else
					card:CCitty_add_dialogue('CCitty_ThatsYikes', { 'fac_CCitty_ThatsYikes' })
					card:CCitty_remove_dialogue(5)
				end
			elseif context.money_altered then --money changes
				if context.amount <= -11 then --big loss
					card:CCitty_add_dialogue('CCitty_loss', { 'fac_CCitty_sadmuhnee' })
					card:CCitty_remove_dialogue(5)
				elseif context.amount > 20 then --big gain
					card:CCitty_add_dialogue('CCitty_gain', { 'fac_CCitty_yass' })
					card:CCitty_remove_dialogue(5)
				end

			elseif context.first_hand_drawn then
				if pseudorandom('doc_tips') < 1 / 6 then
					card:CCitty_add_dialogue('CCitty_tip' .. pseudorandom('doc_tips', 1, 5))
					card:CCitty_remove_dialogue(7)
				elseif G.GAME.blind.boss and pseudorandom('doc_boss') < 1 / 3 then
					card:CCitty_add_dialogue('CCitty_StinkyBoss', { 'fac_CCitty_StinkyBoss' })
					card:CCitty_remove_dialogue(5)
				else
					local outofcontext = pseudorandom_element({ 'ForbiddenYaoi', 'Ball', 'Buttons', 'Cooking', 'LaughPanic', 'PlayThose', 'RIPRoffle', 'ShuffleSigh', 'Straight', 'uhhhh', 'WorkedOut', 'Worm', 'YourNew' }, pseudoseed('doc_tips'))
					card:CCitty_add_dialogue('CCitty_' .. outofcontext, { 'fac_CCitty_' .. outofcontext })
					card:CCitty_remove_dialogue(5)
				end
			elseif context.starting_shop or context.reroll_shop then --enter shop
				local shopping = { michel = false, ball = false, swash = false, egg = false, mask = false, blue = false, vamp = false, wee = false, square = false, neg = false }
				for _, v in pairs(G.shop_jokers.cards) do
					if v.config.center.key == "j_gros_michel" then
						shopping.michel = true
					elseif v.config.center.key == "j_wee" then
						shopping.wee = true
					elseif v.config.center.key == "j_8_ball" then
						shopping.ball = true
					elseif v.config.center.key == 'j_swashbuckler' then
						shopping.swash = true
					elseif v.config.center.key == 'j_egg' then
						shopping.egg = true
					elseif v.config.center.key == 'j_midas_mask' then
						shopping.mask = true
					elseif v.config.center.key == 'j_blueprint' then
						shopping.blue = true
					elseif v.config.center.key == 'j_vampire' then
						shopping.vamp = true
					elseif v.config.center.key == 'j_square' then
						shopping.square = true
					elseif v.edition and v.edition.negative then
						shopping.neg = true
					end
				end
				if shopping.michel then
					card:CCitty_add_dialogue('CCitty_michelle', { 'fac_CCitty_michelle' })
					card:CCitty_remove_dialogue(5)
				elseif shopping.neg then
					card:CCitty_add_dialogue('CCitty_ecstasy', { 'fac_CCitty_ecstasy' })
					card:CCitty_remove_dialogue(5)
				elseif shopping.wee then
					card:CCitty_add_dialogue('CCitty_Wee', { 'fac_CCitty_Wee' })
					card:CCitty_remove_dialogue(5)
				elseif shopping.ball then
					card:CCitty_add_dialogue('CCitty_8BallGlass', { 'fac_CCitty_8BallGlass' })
					card:CCitty_remove_dialogue(5)
				elseif shopping.swash then
					card:CCitty_add_dialogue('CCitty_BuggyDClown', { 'fac_CCitty_BuggyDClown' })
					card:CCitty_remove_dialogue(5)
				elseif shopping.egg then
					card:CCitty_add_dialogue('CCitty_ChickenJoker', { 'fac_CCitty_ChickenJoker' })
					card:CCitty_remove_dialogue(5)
				elseif shopping.mask then
					card:CCitty_add_dialogue('CCitty_Midas', { 'fac_CCitty_Midas' })
					card:CCitty_remove_dialogue(5)
				elseif shopping.blue then
					card:CCitty_add_dialogue('CCitty_SellBlueprint', { 'fac_CCitty_SellBlueprint' })
					card:CCitty_remove_dialogue(5)
				elseif shopping.vamp then
					card:CCitty_add_dialogue('CCitty_Suck', { 'fac_CCitty_Suck' })
					card:CCitty_remove_dialogue(5)
				elseif shopping.square then
					card:CCitty_add_dialogue('CCitty_YaoiHands', { 'fac_CCitty_YaoiHands' })
					card:CCitty_remove_dialogue(5)
				end

			elseif context.open_booster then
				if context.booster.kind == 'Celestial' then
					card:CCitty_add_dialogue('CCitty_Uranus', { 'fac_CCitty_Uranus' })
					card:CCitty_remove_dialogue(5)
				else
					card:CCitty_add_dialogue('CCitty_Interesting', { 'fac_CCitty_Interesting' })
					card:CCitty_remove_dialogue(5)
				end


			elseif context.skipping_booster then
				if context.booster.kind == 'Celestial' then
					card:CCitty_add_dialogue('CCitty_NotInterested', { 'fac_CCitty_NotInterested' })
					card:CCitty_remove_dialogue(5)
				elseif context.booster.kind == 'Standard' then
					card:CCitty_add_dialogue('CCitty_RatherDie', { 'fac_CCitty_RatherDie' })
					card:CCitty_remove_dialogue(5)
				elseif context.booster.kind == 'Spectral' then
					card:CCitty_add_dialogue('CCitty_Yikes', { 'fac_CCitty_Yikes' })
					card:CCitty_remove_dialogue(5)
				end

			elseif context.buying_card then
				if pseudorandom('doc_purchase') < 1 / 5 then
					local choice = pseudorandom_element({ 'DoesntHurt', 'Expectations', 'Forgor', 'HowDare', 'Laugh', 'MakesSense', 'MidVibes', 'Nice', 'OhOkay', 'Risky', 'TakeOne', 'ThatHelps', 'ThatsHuge', 'Wut' }, pseudoseed('doc_purchase'))
					card:CCitty_add_dialogue('CCitty_' .. choice, { 'fac_CCitty_' .. choice })
					card:CCitty_remove_dialogue(5)
				end

			elseif context.selling_card and not context.selling_self then
				if pseudorandom('doc_sell') < 1 / 6 then
					card:CCitty_add_dialogue('CCitty_ThatsMoney', { 'fac_CCitty_ThatsMoney' })
					card:CCitty_remove_dialogue(5)
				end

			elseif context.using_consumeable then
				if context.consumeable.config.center.key == "c_hanged_man" then
					card:CCitty_add_dialogue('CCitty_Bang', { 'fac_CCitty_Bang' })
					card:CCitty_remove_dialogue(5)
				elseif context.consumeable.config.center.key == 'c_hermit' then
					card:CCitty_add_dialogue('CCitty_Plus20', { 'fac_CCitty_Plus20' })
					card:CCitty_remove_dialogue(5)
				elseif context.consumeable.config.center.key == 'c_temperance' then
					card:CCitty_add_dialogue('CCitty_Money', { 'fac_CCitty_Money' })
					card:CCitty_remove_dialogue(5)
				elseif context.consumeable.config.center.key == "c_trance" then
					card:CCitty_add_dialogue('CCitty_BlueSeals', { 'fac_CCitty_BlueSeals' })
					card:CCitty_remove_dialogue(5)
				elseif context.consumeable.config.center.key == "c_pluto" then
					card:CCitty_add_dialogue('CCitty_Plutonium', { 'fac_CCitty_Plutonium' })
					card:CCitty_remove_dialogue(5)
				elseif context.consumeable.config.center.key == "c_immolate" then
					card:CCitty_add_dialogue('CCitty_lightemup', { 'fac_CCitty_lightemup' })
					card:CCitty_remove_dialogue(5)
				elseif context.consumeable.config.center.key == "c_soul" then
					card:CCitty_add_dialogue('CCitty_IsThatYou', { 'fac_CCitty_IsThatYou' })
					card:CCitty_remove_dialogue(5)
				end

			elseif context.joker_type_destroyed then
				card:CCitty_add_dialogue('CCitty_Ao3', { 'fac_CCitty_Ao3' })
				card:CCitty_remove_dialogue(5)
			elseif context.pre_discard and #context.full_hand == 3 then
				card:CCitty_add_dialogue('CCitty_3Cards', { 'fac_CCitty_3Cards' })
				card:CCitty_remove_dialogue(5)
			elseif context.ending_shop then
				card:CCitty_add_dialogue('CCitty_gonext', { 'fac_CCitty_gonext' })
				card:CCitty_remove_dialogue(5)
			end
		end
	end,
}

local CCitty_g_uidef_card_h_popup_ref = G.UIDEF.card_h_popup --Don't ask a girl how much she weighs. That's rude.
function G.UIDEF.card_h_popup(card)
	local ret = CCitty_g_uidef_card_h_popup_ref(card)
	if card.ability and card.ability.set == 'fac_Fish' and card.config.center_key == 'fish_fac_seiunsky' and card.area and not (card.area.config.collection or card.area.config.fac_compendium) then
		local name = SMODS.deepfind(ret, 'main_box_flag', 'i')[1]
		local name_node = name.objtree
		name_node[#name_node - 3][5].nodes[2].config.text = "Undeclared"
	end
	return ret
end

FishAndChips.Fish { --Seiun Sky seahorse
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
	attributes = { 'usable', 'reroll', 'hands', 'prevents_death', },
	config = {
		extra = {
			freeroll = 1
		}
	},
	stats = {
		weight = { min = 63, max = 68 },
		length = { min = 1.55, max = 1.55 }
	},
	environments = {
		garden = 5,
		soup = 3,
		calm_pond = 2
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.freeroll } }
	end,

	use = function(self, card)
		card.ability.extra.freeroll = card.ability.extra.freeroll - 1
		G.TAROT_INTERRUPT = nil
		FishAndChips:stop_ambience()
		local old_env = G.GAME.fac_fishing_environment
		G.GAME.fac_fishing_environment = pseudorandom_element(FishAndChips.Environments, "fac_next_location", {
			in_pool = function(v, args)
				return v.key ~= G.GAME.fac_fishing_environment
			end
		}).key
		SMODS.calculate_context { fac_environment_changed = G.GAME.fac_fishing_environment, old_environment = old_env, forced = true }
		G.FISHING_STATE = G.FISHING_STATES.MOVING
		G.FISHING_STATE_COMPLETE = false
	end,
	can_use = function(self, card)
		return card.ability.extra.freeroll > 0 and G.FISHING_STATE == G.FISHING_STATES.LOBBY
	end,
	keep_on_use = function(self, card)
		return true
	end,

	calculate = function(self, card, context)
		if context.after and G.GAME.current_round.hands_left == 0 then
			if card.ability.extra.freeroll > 0 and (G.GAME.chips + math.floor(mult * hand_chips)) - G.GAME.blind.chips < 0 then
				ease_hands_played(1)
				card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, { message = localize { type = 'variable', key = 'a_hand', vars = { 1 } } })
				if not context.blueprint then
					card.ability.extra.freeroll = card.ability.extra.freeroll - 1
				end
			end
		elseif context.ending_fishing and not context.blueprint then
			card.ability.extra.freeroll = card.ability.extra.freeroll + 1
		end
	end,
}

local where_making_it_hapen = ease_background_colour
function ease_background_colour(args)
	if G.GAME and G.GAME.distaction then
		local car = {}
		for _, v in ipairs(G.C) do
			car[#car + 1] = v
			if #car == 27 then break end
		end
		for _, v in pairs(G.C.SET) do
			car[#car + 1] = v
		end
		for _, v in pairs(G.C.SECONDARY_SET) do
			car[#car + 1] = v
		end
		local car = pseudorandom_element(car, pseudoseed('ihavethe'))
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
	attributes = { 'mult', 'usable', },
	config = {
		extra = {
			chosen = 1
		}
	},
	stats = {
		weight = { min = 0.0003, max = 0.0004 },
		length = { min = -1000000, max = 0 }
	},
	environments = {
		backroom = 1
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { elements = { SMODS.create_sprite(0, 0, 3.5, 3.5 * 250 / 500, "fac_fihs_CCitty_desc") } } }
	end,
	flavour_vars = function(self, info_queue, card)
		return { vars = { localize("CCitty_fihs_"..card.ability.extra.chosen) } }
	end,
	in_pool = function(self, args)
		return pseudorandom('howhighdoyouevenhavetobe') < 1 / 4
	end,
	add_to_deck = function(self, card, from_debuff)
		if not from_debuff then
			G.GAME.distaction = G.GAME.distaction or 0.04
		end
		card.ability.extra.chosen = pseudorandom('keepitreal', 1, 15)
	end,
	calculate = function(self, card, context)
		if context.joker_main and not context.blueprint then
			G.GAME.distaction = G.GAME.distaction + 0.04
			card.ability.extra.chosen = pseudorandom('keepitreal', 1, 15)
		elseif context.final_scoring_step then
			return {
				mult = (pseudorandom('hehastheball', 8, 13) + pseudorandom('hehastheball')) * (pseudorandom('aids', -1, 10) * .5),
				mult_message = { message = "+10 mult..........", colour = G.C.FILTER }
			}
		end
	end,

	use = function(self, card)
		local _card = copy_card(card) --intended behaviour
		_card:CCitty_add_dialogue('CCitty_sbahj', nil, 'tl')
		_card:CCitty_remove_dialogue(20)
	end,
	can_use = function(self, card)
		return true
	end
}

local garf_change = end_round
function end_round()
	garf_change()
	G.GAME.garfield_day = ((G.GAME.garfield_day or 0) % 7) + 1
end

local garf_start = Game.start_run
function Game:start_run(args)
	garf_start(self, args)
	G.GAME.garfield_day = G.GAME.garfield_day or pseudorandom('ihatemondays', 1, 7)
end

FishAndChips.Fish { --Garfield Phone
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
			can_call = true
		}
	},
	stats = {
		weight = { min = 1, max = 2 },
		length = { min = .25, max = 2 }
	},
	environments = {
		pier = 10,
		backroom = 3,
		wormhole = 2
	},
	blueprint_compat = false,
	in_pool = function(self, args)
		return G.GAME.garfield_day > 1
	end,
	loc_vars = function(self, info_queue, card)
		local day = G.GAME and G.GAME.garfield_day or 1
		local all_colours = { G.C.RED, G.C.BLUE, G.C.PURPLE, G.C.BLACK, G.C.GREEN, G.C.MONEY, G.C.ETERNAL }
		local colour = all_colours[day]
		local main_end = {
			{
				n = G.UIT.C,
				config = { align = "bm", minh = 0.4 },
				nodes = {
					{
						n = G.UIT.C,
						config = { ref_table = card, align = "m", colour = colour, r = 0.05, padding = 0.06 },
						nodes = {
							{ n = G.UIT.T, config = { text = " " .. localize("fac_garfield_day"..day) .. " ", colour = G.C.UI.TEXT_LIGHT, scale = 0.32 * 0.8 } },
						}
					}
				}
			}
		}
		return { main_end = main_end, vars = { ppu_bubbles = { card.ability.extra.can_call and "usable" or "used" } } }
	end,

	use = function(self, card)
		local actually_used = false
		if G.GAME.garfield_day == 1 then
			play_sound('fac_CCitty_garf' .. pseudorandom('ihatemondayssound', 1, 5))
			card_eval_status_text(card, 'extra', nil, nil, nil, { message = "No answer...", colour = G.C.ORANGE })
			actually_used = true
		elseif G.GAME.garfield_day == 2 then
			SMODS.upgrade_poker_hands { hands = G.GAME.current_round.most_played_poker_hand, level_up = 3, from = card }
			actually_used = true
		elseif G.GAME.garfield_day == 3 then
			for i = 1, (G.consumeables.config.card_limit) do
				if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
					G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
					G.E_MANAGER:add_event(Event({
						func = function()
							local new = SMODS.add_card { set = 'Spectral', area = G.consumeables, key = 'c_medium' }
							G.GAME.consumeable_buffer = 0
							new:juice_up(0.5, 0.5)
							return true
						end
					}))
					actually_used = true
					card_eval_status_text(card, 'extra', nil, nil, nil, { message = localize('k_plus_spectral'), colour = G.C.SECONDARY_SET.Spectral })
				end
			end
			if not actually_used then
				card_eval_status_text(card, 'extra', nil, nil, nil, { message = localize('k_no_room_ex') })
			end
		elseif G.GAME.garfield_day == 4 then
			G.fac_fish_area.config.card_limits.base = G.fac_fish_area.config.card_limits.base + 2
			card_eval_status_text(card, 'extra', nil, nil, nil, { colour = G.C.ORANGE, message = localize { type = "variable", key = "ph_fac_upgrade_increase", vars = { G.fac_fish_area.config.card_limits.base - 2, G.fac_fish_area.config.card_limits.base } } })
			actually_used = true
		elseif G.GAME.garfield_day == 5 then
			if #G.jokers.cards < G.jokers.config.card_limit then
				SMODS.add_card { set = 'Joker', rarity = 'Rare', key_append = 'garfybaby5' }
				actually_used = true
			else
				card_eval_status_text(card, 'extra', nil, nil, nil, { message = localize('k_no_room_ex') })
			end
		elseif G.GAME.garfield_day == 6 then
			local available = {}
			for k, v in pairs(G.fac_fish_area.cards) do
				if v ~= card and not v.ability.eternal then
					available[#available + 1] = v
				end
			end
			if next(available) then
				actually_used = true
				SMODS.destroy_cards(pseudorandom_element(available, pseudoseed('garfybaby6')))
				ease_sand_dollars(9)
				ease_dollars(20)
			else
				card_eval_status_text(card, 'extra', nil, nil, nil, { message = localize('k_nope_ex'), colour = G.C.ORANGE })
			end
		elseif G.GAME.garfield_day == 7 then
			local available = {}
			for k, v in pairs(G.fac_fish_area.cards) do
				if v ~= card and not v.edition then
					available[#available + 1] = v
				end
			end
			if next(available) then
				actually_used = true
				pseudorandom_element(available, pseudoseed('garfybaby7')):set_edition('e_polychrome')
			else
				card_eval_status_text(card, 'extra', nil, nil, nil, { message = localize('k_nope_ex'), colour = G.C.ORANGE })
			end
		end
		if actually_used then card.ability.extra.can_call = false end
	end,

	can_use = function(self, card)
		return card.ability.extra.can_call
	end,
	keep_on_use = function(self, card)
		return true
	end,

	calculate = function(self, card, context)
		if context.end_of_round and context.main_eval and G.GAME.blind.boss and not context.blueprint then
			card.ability.extra.can_call = true
			return {
				message = localize('k_reset')
			}
		end
	end,
}

FishAndChips.Fish { --Bluebell Angler
	key = "bluebell_angler",
	atlas = "CCittyfish",
	pos = { x = 0, y = 3 },
	weight = 10,
	ppu_coder = { "CampfireCollective" },
	ppu_artist = { "DottyKitty" },
	attributes = {},
	config = {
		extra = {
		}
	},
	environments = {
		aquifer = 1,
		garden = 1
	},
	stats = {
		weight = { min = .01, max = .06 },
		length = { min = .02, max = .18 }
	},
	loc_vars = function(self, info_queue, card)
		return { vars = {'modify_card','perma_bonus'} }
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
				if v.ability.bluebell_choice then
					bluebell = true
					break
				end
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
					else     --perma scoring stuff
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
								v.ability.perma_bonus = (v.ability.perma_bonus or 0) + 1
							else
								v.ability.perma_mult = (v.ability.perma_mult or 0) + 1
							end
						end
					end
				end
				G.E_MANAGER:add_event(Event({
                	func = function()
						for _, v in ipairs(context.scoring_hand) do
							v:juice_up()
						end
						return true
					end
				}))
				return { message = localize('k_upgrade_ex'), colour = G.C.SECONDARY_SET.Spectral }
			elseif context.after then
				for _, v in pairs(G.playing_card) do
					if v.ability.bluebell_choice then
						v.ability.bluebell_choice = nil
					end
				end
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
	attributes = { 'economy', 'food' },
	config = {
		extra = {
			remaining = 5,
			dollars = 5,
			names = { 'Solin', 'Solin', 'Solin', 'Solin', 'Secil', 'Shris', 'Slive', 'Slyde', 'Sharlie', 'Slinky', 'Suthbert', 'Sorris', 'Siggles', 'Siara', 'Sooper', 'Sarl', 'Sompost', 'Sompost', 'Sompost', 'Sompost' },
			chosen = 1
		}
	},
	stats = {
		weight = { min = .2, max = 3.3 },
		length = { min = .07, max = .44 }
	},
	environments = {
		chocolate_river = 1
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.dollars, card.ability.extra.remaining, card.ability.extra.names[card.ability.extra.chosen] } }
	end,
	flavour_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.chosen < 17 and localize("CCitty_solinseaslug_1") or localize("CCitty_sompostseaslug_1"),
						  card.ability.extra.chosen < 17 and localize("CCitty_solinseaslug_2") or localize("CCitty_sompostseaslug_2"),
						  card.ability.extra.chosen < 17 and localize("CCitty_solinseaslug_3") or localize("CCitty_sompostseaslug_3") } }
	end,
	on_catch = function(self, card)
		card.ability.extra.chosen = pseudorandom('solin', 1, 20)
		if card.ability.extra.chosen >= 5 then
			if card.ability.extra.chosen >= 17 then
				card.ability.extra.dollars = 3
				card.children.center:set_sprite_pos { x = 2, y = 3 }
			else
				card.ability.extra.dollars = 4
			end
		end
	end,

	calculate = function(self, card, context)
		if context.selling_card and context.card ~= card then
			if context.card.ability.set == 'fac_Fish' then
				if not context.blueprint then
					card.ability.extra.remaining = card.ability.extra.remaining - 1
					if card.ability.extra.remaining <= 0 then
						SMODS.destroy_cards(card)
					end
				end
				return {
					dollars = card.ability.extra.dollars,
				}
			end
		end
	end,
}
