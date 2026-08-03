-- stole the flowery voicelines from utdr

local files = SMODS.NFS.getDirectoryItemsInfo(FishAndChips.mod.path .. "/assets/sounds/fountain_openers/flowery/")
for _, file in pairs(files) do
    -- load Every Fucking Flowery Voiceline
    if file.type == "file" then
        SMODS.Sound {
            key = "fo_flowery_" .. file.name:sub(1, #file.name - 4),
            path = "fountain_openers/flowery/" .. file.name
        }
    end
end

function FountainOpeners.flowery_sound(sfx)
    play_sound("fac_fo_flowery_" .. sfx, 1.0, 0.85)
end

function FountainOpeners.random_flowery_sound(table)
    local sfx = pseudorandom_element(table, "flowery_sfx")
    play_sound("fac_fo_flowery_" .. sfx, 1.0, 0.85)
end

FishAndChips.Fish {
	key = "fo_fishery",
	atlas = "fish",
	pos = { x = 3, y = 0 },
	weight = 5,
	ppu_coder = { "Alexi" },
	ppu_artist = { "Grahkon" },
	attributes = { "rank", "jack", "king", "queen", "mult", "xmult" },
	config = {
        extra = {
            mult = 2,
            xmult = 1.25,
        }
	},
	environments = {
		garden = 1,
	},
    stats = {
		weight = {min = 80, max = 80 + 0.00001},
		length = {min = 2.2, max = 2.2 + 0.00001}
	},
    loc_vars = function(self, info_queue, card)
		return { vars = {
            card.ability.extra.mult,
            card.ability.extra.xmult,
        }}
	end,
	calculate = function(self, card, context)
        if context.after and not context.blueprint then
            local jacks = false
            for _, scored_card in ipairs(context.scoring_hand) do
                if scored_card:get_id() == 11 then
                    jacks = true
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            assert(SMODS.change_base(scored_card, nil, "Queen"))
                            scored_card:juice_up()
                            return true
                        end
                    }))
                end
            end
            if jacks then
                return {
                    message = localize("fac_fo_hey_raly"),
                }
            end
        end

        if context.individual and context.cardarea == G.play then
            if (context.other_card:get_id() == 13 or context.other_card:get_id() == 12) then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        FountainOpeners.random_flowery_sound({
                            "hoo",
                            "hah",
                            "jarona1",
                            "jarona2",
                            "jarona3",
                            "jarona4",
                        })
                        return true
                    end
                }))
                return {
                    xmult = card.ability.extra.xmult
                }
            elseif context.other_card:get_id() == 11 then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        FountainOpeners.random_flowery_sound({
                            "hoo",
                            "hah",
                            "jarona1",
                            "jarona2",
                            "jarona3",
                            "jarona4",
                        })
                        return true
                    end
                }))
                return {
                    mult = card.ability.extra.mult
                }
            end
        end

        if not context.blueprint then
            if context.joker_type_destroyed and context.card == card then
                FountainOpeners.flowery_sound("theyre_eating_my_flesh")
            elseif context.selling_self then
                FountainOpeners.flowery_sound("goodbye")
            end
        end
    end,

    add_to_deck = function(self, card, from_debuff)
        if not from_debuff then
            G.E_MANAGER:add_event(Event({
                func = function()
                    FountainOpeners.random_flowery_sound({
                        "hereicomesanfrandisco",
                        "hey_boys",
                        "hey",
                        "hey_guys",
                        "heyguysithinkifoundaglue",
                        "itsme",
                        "itsmeflowery",
                        "flowery",
                        "flowery2",
                        "leaf_it_to_me",
                        "minipeppers",
                        "thisguysyourbestfriend",
                        "try_my_flavor",
                        "imsorryonceagainikeptaladyinwaiting",
                        "sorrytokeepaladyinwaiting",
                        "sorrytokeepyouwaiting1",
                        "sorrytokeepyouwaiting2",
                        "heh_its_my_jarona"
                    })
                    return true
                end
            }))
        end
    end,
}