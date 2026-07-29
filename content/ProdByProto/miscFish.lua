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

    add_to_deck = function(self, card, from_debuff)
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
            if context.other_card:is_rank("King") and context.other_card:is_suit("Hearts") then
                return {mult = cae.mult}
            end
        end

	end,
}