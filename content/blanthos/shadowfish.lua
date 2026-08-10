
--#region Fish


FishAndChips.Fish {
	key = "shadowfish",
	atlas = "blanthos_hunter_fish",
	pos = { x = 2, y = 0 },
	weight = 10,
	ppu_coder = { "Blanthos" },
	ppu_artist = { "Hunter" },
	config = {
		extra = {
			mult = 4,
			chips = 30,
			xmult = 1.5,
			economy = 1,
			retrigger = 1
		},
		valid_attributes = {
mult = "mult",
chips = "chips",
economy = "economy",
xmult = "xmult",
retrigger = "retrigger",

hand_level = "hand_level",
usable = "usable",
rank = "rank",
passive = "passive",
suit = "suit",
copying = "copying",
generation = "generation",
boss_blind = "boss_blind",
destroy_card = "destroy_card" 
		},
		attributes = {
attrone = "mult",
attrtwo = "chips",
attrthree = "economy"
		}
	},
	loc_vars = function(self, info_queue, card)
		return { vars = {card.ability.attributes.attrone, card.ability.attributes.attrtwo, card.ability.attributes.attrthree} }
	end,
	environments = {
		styx = 1,
		pier = 0.5,
		garden = 0.1
	},
	stats = {
		weight = {min = 0.5, max = 0.5},
		length = {min = 0.62, max = 0.62}
	},

	calculate = function(self, card, context)
		if context.joker_main then 
if card.ability.attributes.attrone == "mult" then 
SMODS.calculate_effect( { mult = card.ability.extra.mult }, card)
end
if card.ability.attributes.attrone == "chips" then 
SMODS.calculate_effect( { chips = card.ability.extra.chips }, card)
end
if card.ability.attributes.attrone == "xmult" then 
SMODS.calculate_effect( { xmult = card.ability.extra.xmult }, card)
end

if card.ability.attributes.attrtwo == "mult" then 
SMODS.calculate_effect( { mult = card.ability.extra.mult }, card)
end
if card.ability.attributes.attrtwo == "chips" then 
SMODS.calculate_effect( { chips = card.ability.extra.chips }, card)
end
if card.ability.attributes.attrtwo == "xmult" then 
SMODS.calculate_effect( { xmult = card.ability.extra.xmult }, card)
end

if card.ability.attributes.attrthree == "mult" then 
SMODS.calculate_effect( { mult = card.ability.extra.mult }, card)
end
if card.ability.attributes.attrthree == "chips" then 
SMODS.calculate_effect( { chips = card.ability.extra.chips }, card)
end
if card.ability.attributes.attrthree == "xmult" then 
SMODS.calculate_effect( { xmult = card.ability.extra.xmult }, card)
end
	end

if context.selling_card then

if card.ability.attributes.attrone == "economy" then 
SMODS.calculate_effect( { dollars = card.ability.extra.economy }, card)
end
if card.ability.attributes.attrtwo == "economy" then 
SMODS.calculate_effect( { dollars = card.ability.extra.economy }, card)
end
if card.ability.attributes.attrthree == "economy" then 
SMODS.calculate_effect( { dollars = card.ability.extra.economy }, card)
end
	end

        if context.repetition and context.cardarea == G.play and context.other_card == context.scoring_hand[1] then
if card.ability.attributes.attrone == "retrigger" then 
return{
repetitions = card.ability.extra.retrigger }
end
end
        if context.repetition and context.cardarea == G.play and context.other_card == context.scoring_hand[2] then
if card.ability.attributes.attrtwo == "retrigger" then 
return{
repetitions = card.ability.extra.retrigger }
end
end
        if context.repetition and context.cardarea == G.play and context.other_card == context.scoring_hand[3] then
if card.ability.attributes.attrthree == "retrigger" then 
return{
repetitions = card.ability.extra.retrigger }
end
end



end,


    set_ability = function(self, card, initial, delay_sprites)
attributes = {}
        for aterboot, _ in pairs(card.ability.valid_attributes) do
                attributes[#attributes + 1] = aterboot
end
		card.ability.attributes.attrone = pseudorandom_element(attributes, 'fac_shadowfish')
		card.ability.attributes.attrtwo = pseudorandom_element(attributes, 'fac_shadowfish')
		card.ability.attributes.attrthree = pseudorandom_element(attributes, 'fac_shadowfish')
end
            
}
--#endregion