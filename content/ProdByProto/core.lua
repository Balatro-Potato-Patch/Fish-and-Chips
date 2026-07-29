PotatoPatchUtils.Developer({
	name = "ProdByProto",
    colour = HEX("d66b1c"),
    --loc = "PotatoPatchDev_ProdByProto",
	--atlas = 'fac_cards',
	--pos = {x = 1, y = 0},
})


SMODS.Atlas({
	key = "proto_noName",
	path = "ProdByProto/noName.png",
	px = 256,
	py = 192,
})

SMODS.Atlas({
	key = "proto_fish",
	path = "ProdByProto/fish.png",
	px = 71,
	py = 95,
})


SMODS.Font({
    key = "helvetica",
    path = "ProdByProto/Helvetica.ttf",
})

SMODS.Font({
    key = "handwriting",
    path = "ProdByProto/slwronghandfont/SlWronghandRegularDemoxRDeR.ttf",
})


FishAndChips.ProdByProto = {}

function FishAndChips.ProdByProto.addEnvs()
	local envWeights = {}
	for _,env in pairs(FishAndChips.Environment.obj_buffer) do
		-- PATCH TARGET: proto fish in all environments
		if not envWeights[env] then envWeights[env] = 1 end 
	end
	return envWeights
end