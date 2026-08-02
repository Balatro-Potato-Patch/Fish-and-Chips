local addEnvs = FishAndChips.ProdByProto.addEnvs


-- no name
local idolSuit = function()
    local suit = 'Spades'
    local valid_idol_cards = {}
    for k, v in ipairs(G.playing_cards) do
        if v.ability.effect ~= 'Stone Card' then
            if not SMODS.has_no_suit(v) and not SMODS.has_no_rank(v) then
                valid_idol_cards[#valid_idol_cards+1] = v
            end
        end
    end
    if valid_idol_cards[1] then 
        local idol_card = pseudorandom_element(valid_idol_cards, pseudoseed('proto_noName'..G.GAME.round_resets.ante))
        suit = idol_card.base.suit
    end
    return suit
end

FishAndChips.Fish {
	key = "proto_noName",
    atlas = "proto_noName",
	pos = { x = 0, y = 0 },
    display_size = {w = 71, h = 47},

	weight = 15,
    ppu_coder = {"ProdByProto"},
	attributes = { "economy", "suits" },
	environments = addEnvs(),

	config = {
		extra = {
			suit = "Spades",
            num = 1,
            denom = 2,
            dollhairs = 2
		}
	},

	loc_vars = function(self, info_queue, card)
        local cae = card.ability.extra
        local num, denom = SMODS.get_probability_vars(self, cae.num, cae.denom, "proto_noName")
		return { vars = { localize(cae.suit, "suits_singular"), num, denom, cae.dollhairs, colours = { G.C.SUITS[cae.suit] } } }
	end,
    collection_loc_vars = function(self)
        return { vars = { "Spades","1","2","2" } }
    end,

    on_catch = function(self,card)
        card.ability.extra.suit = idolSuit()
    end,

	calculate = function(self, card, context)
		local cae = card.ability.extra


        if context.individual and context.cardarea == G.play then
            if context.other_card:is_suit(cae.suit) then
                if SMODS.pseudorandom_probability(self,"fish for fishing",cae.num,cae.denom,"proto_noName") then
                    ease_sand_dollars(cae.dollhairs)
                end
            end
        end

        if context.ending_shop then
            cae.suit = idolSuit()
        end

	end,
}

-- eyedle
FishAndChips.Fish {
	key = "proto_eyedle",
    atlas = "proto_fish",
	pos = { x = 0, y = 0 },

	weight = 15,
    ppu_coder = {"ProdByProto"},
	attributes = { "chips","mult","rank", "suit","king","hearts" },
	environments = addEnvs(),

	config = {
		extra = {
			mult = 2
		}
	},

	loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = {
            set = "Other",
            key = "proto_kingdomhearts",
        }
        local cae = card.ability.extra
		return { vars = { cae.mult } }
	end,

	calculate = function(self, card, context)
		local cae = card.ability.extra


        if context.individual and context.cardarea == G.play then
            if context.other_card:get_id() == 13 and context.other_card:is_suit("Hearts") then
                return {mult = cae.mult}
            end
        end

	end,
}

-- DJ Fish

local playlistEvent
playlistEvent = {
    trigger = "after",
    delay = 64,
    --start_timer = true,
    no_delete = true,
    pause_force = true,
    blockable = false,
    blocking = false,
    func = function()
        FishAndChips.ProdByProto.q_music = false
        return true
    end
}

FishAndChips.Fish {
	key = "proto_dj",
    atlas = "proto_fish",
	pos = { x = 1, y = 0 },
    pixel_size = {w = 71, h = 64},

	weight = 15,
    ppu_coder = {"ProdByProto"},
	attributes = { "usable","generation" },
	environments = addEnvs(),

	config = {
		extra = {
			bait = 2
		}
	},

	loc_vars = function(self, info_queue, card)
        local cae = card.ability.extra
		return { vars = { cae.bait } }
	end,

	use = function(self,card,area)
        local cae = card.ability.extra
        local w = (G.CARD_W + 0.1) * cae.bait * 2 - 0.1
		local h = G.CARD_H
		G.fac_temp_bait_area = CardArea(
			card.T.x + card.T.w / 2 - w / 2, card.T.y - 0.5 - h,
			w, h,
			{
				type = "joker",
				card_limit = cae.bait,
				highlight_limit = 1,
				highlighted_limit = 1,
				align_buttons = true,
				bg_colour = G.C.CLEAR,
				fixed_limit = true,
				no_card_count = true,
			}
		)
		delay(1)
		for i = 1, cae.bait do
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
		delay(3)
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
				card:start_dissolve()
				return true
			end
		})
        G.ARGS.push.type = 'restart_music'
        G.SOUND_MANAGER.channel:push(G.ARGS.push)
        FishAndChips.ProdByProto.q_music = "jclub"
        G.E_MANAGER:add_event(Event(playlistEvent))
    end,
    can_use = function(self,card)
        return true
    end
        
}