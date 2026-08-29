if Balatest then
	-- Redefine this for mods that don't expect the fishing minigame to exist
	---@diagnostic disable-next-line: duplicate-set-field
	function Balatest.exit_shop()
		FishAndChips.Balatest_go_fishing()
		FishAndChips.Balatest_exit_fishing()
	end

	-- Redefine this to support using fish
	---@diagnostic disable-next-line: duplicate-set-field
	function Balatest.use(card)
		Balatest.wait_for_input()
		card = Balatest.internal.ensure_not_nil(card)
		Balatest.q(function()
			local c = card();
			(c.config.center.set == 'fac_Fish' and G.FUNCS.fac_use_fish or G.FUNCS.use_card) {
				config = { ref_table = c },
			}
		end)
		Balatest.wait_for_input()
	end

	--- Exits the shop and goes to the fishing minigame.
	function FishAndChips.Balatest_go_fishing()
		Balatest.wait_for_input(G.STATES.SHOP)
		Balatest.q(function()
			if Balatest.internal.abort then
				return
			end
			G.FUNCS.toggle_shop()
		end)
		FishAndChips.Balatest_wait_for_fishing_input(G.STATES.FAC_FISHING, G.FISHING_STATES.LOBBY)
	end

	--- Exits the fishing minigame and goes to the blind select screen.
	function FishAndChips.Balatest_exit_fishing()
		FishAndChips.Balatest_wait_for_fishing_input(G.STATES.FAC_FISHING, G.FISHING_STATES.LOBBY)
		Balatest.q(function()
			if Balatest.internal.abort then
				return
			end
			G.FUNCS.fac_toggle_fishing()
		end)
		Balatest.wait_for_input(G.STATES.BLIND_SELECT)
	end

	--- Rerolls the fishing minigame's current environment.
	---@param environment? string The new environment to go to.
	function FishAndChips.Balatest_reroll_environment(environment)
		FishAndChips.Balatest_wait_for_fishing_input(G.STATES.FAC_FISHING, G.FISHING_STATES.LOBBY)
		Balatest.hook_raw(G.GAME, 'fac_next_environment', environment)
		Balatest.q(function()
			G.FUNCS.fac_reroll_location()
		end)
		FishAndChips.Balatest_wait_for_fishing_input(G.STATES.FAC_FISHING, G.FISHING_STATES.LOBBY)
	end

	---@alias FishingState number A state in G.FISHING_STATES.
	---
	--- Works like Balatest.wait_for_input, but also waits for the correct Fish And Chips state.
	---@param state? (State|State[]) The state to wait for.
	---@param fishing_state? (FishingState|FishingState[]) The fishing state to wait for.
	function FishAndChips.Balatest_wait_for_fishing_input(state, fishing_state)
		Balatest.q(function()
			local state_done = G.STATE_COMPLETE
			if type(state) == 'number' then
				state_done = G.STATE == state and G.STATE_COMPLETE
			elseif type(state) == 'table' then
				state_done = false
				for _, s in pairs(state) do
					if G.STATE == s then
						state_done = G.STATE_COMPLETE
					end
				end
			end
			local fishing_done = G.FISHING_STATE_COMPLETE
			if type(fishing_state) == 'number' then
				fishing_done = G.FISHING_STATE == fishing_state and G.FISHING_STATE_COMPLETE
			elseif type(fishing_state) == 'table' then
				fishing_done = false
				for _, s in pairs(fishing_state) do
					if G.FISHING_STATE == s then
						fishing_done = G.FISHING_STATE_COMPLETE
					end
				end
			end
			return Balatest.internal.abort and true
				or (
					state_done
					and fishing_done
					and not G.CONTROLLER.locked
					and not (G.GAME.STOP_USE and G.GAME.STOP_USE > 0)
				)
		end)
	end

	---@class CatchFishArgs
	---@field fish? string The key of the fish to catch.
	---@field lose? boolean True if the fish should be lost.
	---@field perfect? boolean Whether the catch should be perfect. Defaults to true.
	---@field treasure_type? "sand_dollars"|"dollars"|"fish" The type of treasure to catch, if any.
	---@field treasure? string The key of the treasure fish to catch. Implies treasure_type = "fish".
	---@field treasure_amount? number The number of dollars or sand dollars to catch.
	---@field weight? number The weight of the caught fish.
	---@field length? number The length of the caught fish.

	--- Catches a fish in the fishing minigame.
	---@param args CatchFishArgs
	function FishAndChips.Balatest_catch_fish(args)
		if args.treasure then
			args.treasure_type = 'fish'
		end
		if args.treasure_amount then
			args.treasure_type = args.treasure_type or 'dollars'
		end

		Balatest.hook_raw(G.GAME, 'fac_forced_fish', args.fish)
		local fac_finish_round = Balatest.internal.getupvalue(G.update_fac_fishing_hooking, 'fac_finish_round')
		Balatest.hook_upvalue(fac_finish_round, 'fac_weighted_pick', function(orig, a, b, ...)
			if b == 'fac_treasure_type' and args.treasure_type then
				return args.treasure_type
			end
			return orig(a, b, ...)
		end)
		Balatest.hook_upvalue(fac_finish_round, 'fac_normal_pseudorandom', function(orig, a, ...)
			if a == 'fac_treasure_base_amount' and args.treasure_amount then
				return args.treasure_amount
			end
			return orig(a, ...)
		end)
		Balatest.hook(FishAndChips, 'poll_treasure_fish', function(orig, ...)
			return args.treasure or orig(...)
		end)

		FishAndChips.Balatest_wait_for_fishing_input(G.STATES.FAC_FISHING, G.FISHING_STATES.LOBBY)
		Balatest.q(function()
			G.FUNCS.fac_go_fish()
		end)
		Balatest.q(function()
			G.FAC_FISH_GAME.cast_power = 0.5
			G.FAC_FISH_GAME.casting_charge = true
		end)
		FishAndChips.Balatest_wait_for_fishing_input(G.STATES.FAC_FISHING, G.FISHING_STATES.HOOKED)
		Balatest.q(function()
			G.FAC_FISH_GAME.tap_requested = true
		end)
		FishAndChips.Balatest_wait_for_fishing_input(G.STATES.FAC_FISHING, G.FISHING_STATES.HOOKING)
		Balatest.q(function()
			G.FAC_FISH_GAME.profile.stats.weight = args.weight or G.FAC_FISH_GAME.profile.stats.weight
			G.FAC_FISH_GAME.profile.stats.length = args.length or G.FAC_FISH_GAME.profile.stats.length
			G.FAC_FISH_GAME.perfect = args.perfect ~= false
			G.FAC_FISH_GAME.got_treasure = args.treasure_type ~= nil
			if args.lose then
				G.FAC_FISH_GAME.meter_primed = true
				G.FAC_FISH_GAME.meter = -100
			else
				G.FAC_FISH_GAME.meter = 100
			end
		end)
		FishAndChips.Balatest_wait_for_fishing_input(G.STATES.FAC_FISHING, G.FISHING_STATES.LOBBY)
	end

	--- Navigates to the fishing minigame, catches the specified fish, and navigates to the next blind.
	---@param fish string|CatchFishArgs|(string|CatchFishArgs)[] The fish to catch.
	function FishAndChips.Balatest_obtain_fish(fish)
		Balatest.end_round()
		Balatest.cash_out()
		FishAndChips.Balatest_go_fishing()
		if type(fish) == 'string' then
			FishAndChips.Balatest_catch_fish { fish = fish }
		elseif not fish[1] then
			FishAndChips.Balatest_catch_fish(fish)
		else
			for _, v in ipairs(fish) do
				if type(v) == 'string' then
					FishAndChips.Balatest_catch_fish { fish = v }
				else
					FishAndChips.Balatest_catch_fish(v)
				end
			end
		end
		FishAndChips.Balatest_exit_fishing()
		Balatest.start_round()
	end
end
