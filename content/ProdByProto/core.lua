PotatoPatchUtils.Developer({
	name = "ProdByProto",
    colour = HEX("d66b1c"),
    --loc = true,
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


SMODS.Sound{
    key = "music_jersey",
    path = "ProdByProto/music_jersey.wav",
    pitch = 1,
    volume = 0.8,
    select_music_track = function (self)
        if not G.screenwipe and FishAndChips.ProdByProto.q_music == "jclub" then
            return 1.7e308
        end
    end
}


SMODS.ScreenShader{
    key = "proto_noir",
    path = "ProdByProto/noir.fs",
    should_apply = function(self)
        return G.GAME and G.GAME.proto_noirshade
    end
}


FishAndChips.ProdByProto = {}

FishAndChips.ProdByProto.q_music = false


function FishAndChips.ProdByProto.addEnvs()
	local envWeights = {}
	local envBuffer = FishAndChips.Environment.obj_buffer
	for i = 1, 6 do
		envWeights[envBuffer[(i < 4 and i) or (i > 3 and (#envBuffer - (i - 4)))]] = 1
	end
	return envWeights
end