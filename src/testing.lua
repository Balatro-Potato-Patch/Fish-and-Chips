-- FishAndChips.Fish{
-- 	key = "test",
-- 	weight = 10,
-- 	ppu_coder = {'eremel'},
-- 	environments = {
-- 		calm_pond = 0.82,
-- 		angry_pond = 0.4,
-- 		river_styx = 0.05
-- 	}
-- }

-- for i=1, 10 do
-- 	FishAndChips.Fish{
-- 		key = "test"..i,
-- 		weight = 5,
-- 		treasure = true,
-- 		ppu_coder = {'eremel'},
-- 		attributes = {i % 2 == 0 and 'mult', i < 2 and 'chips', i == 10 and 'generation'},
-- 		environments = {
-- 			calm_pond = math.random(1, 10),
-- 			city_river = i > 5 and math.random(1, 10) or nil
-- 		},
-- 	}
-- end

-- PotatoPatchUtils.Developer({
-- 	name = 'eremel',
-- 	colour = G.C.RED,
-- })

function FishAndChips.inspect_fish(fish)
	print('Fish weight:', fish.config.center.weight)
	print('Environment Weights')
	print(fish.config.center.environments)
	print('Attributes')
	print(fish.config.center.attributes)
end