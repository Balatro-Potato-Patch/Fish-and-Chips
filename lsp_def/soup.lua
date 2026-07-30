---@meta

---@alias ValidPools "calm_pond"|"chocolate_river"|"styx"|"pier"|"swamp"|"aquifer"|"volcano"|"city_river"|"soup"|"garden"|"backroom"|"wormhole"

---@class Environments
---@field calm_pond? number
---@field chocolate_river? number
---@field styx? number
---@field pier? number
---@field swamp? number
---@field aquifer? number
---@field volcano? number
---@field city_river? number
---@field soup? number
---@field garden? number
---@field backroom? number
---@field wormhole? number

---@class FishAndChips.Fish: SMODS.Center
---@field environments Environments where this fish can appear, key = weight
---@field impulse_min? number minimum distance fish will move when being caught
---@field impulse_max? number maximum distance fish will move when being caught
---@field decision_min? number minimum time fish will wait before moving
---@field decision_max? number maximum time fish will wait before moving
---@field colour? number colour of sweet spot (I THINK NEED TO CHECK THIS)
---@field requires_hand? boolean makes the hand move back into view if this card is selected
---@field ppu_coder string[] key(s) for the developer(s) who coded this fish
---@field ppu_artist? string[] key(s) for the artist(s) who drew this fish
---@field use? fun(self: FishAndChips.Fish, card: Card) Defines behaviour when this fish is used. 
---@field can_use? fun(self: FishAndChips.Fish, card: Card): boolean? Return `true` if the fish is allowed to be used.
---@field keep_on_use? fun(self: FishAndChips.Fish, card: Card): boolean? return `true` if the fish should be kept when used.
---@field treasure? boolean mark as true if this can be caught as a treasure 
---@field on_catch? fun(self: FishAndChips.Fish, card: Card) If defined, this function will be called when this fish is called.
---@overload fun(self: FishAndChips.Fish): FishAndChips.Fish
FishAndChips.Fish = setmetatable({}, {
	__call = function(self)
		return self
	end
})

---@alias PoolEntry {key: string, label: string}

---@class FishingConfig
---@field bar_size? number dimensions of the Sweet Spot
---@field catch_gain? number how fast the fishing meter should increase
---@field catch_loss? number how fast the fishing meter should decrease
---@field treasure_gain? number how fast the treasure meter should increase
---@field vel_limit? number limit to the speed of the Sweet Spot
---@field impulse_min? number minimum distance fish will move when being caught (fish takes priority)
---@field impulse_max? number maximum distance fish will move when being caught (fish takes priority)
---@field decision_min? number minimum time fish will wait before moving (fish takes priority)
---@field decision_max? number maximum time fish will wait before moving (fish takes priority)

---@class FishAndChips.Rod: SMODS.Center
---@field config? table|{fishing: FishingConfig} how this rod modifies the fishing minigame
---@field force_environment? fun(self: FishAndChips.Rod, card: Card): ValidPools|nil change the environment your considered to be fishing in
---@field modify_pool? fun(self: FishAndChips.Rod, card: Card, pool: PoolEntry[]): PoolEntry[]|nil change the pool of fish to catch, see SMODS.create_poll_pool for details
---@field modify_catch? fun(self: FishAndChips.Rod, card: Card, key: string): string|nil change the key of the fish to catch 
---@field on_catch? fun(self: FishAndChips.Rod, card: Card, key: string) called when a fish (or something else) is caught
---@field bait_bonus? number|fun(self: FishAndChips.Rod, obj: FishAndChips.Bait, boost: number): number multiplies the bait boost if it's a number, and sets it to the returned value if it's a function
---@overload fun(self: FishAndChips.Rod): FishAndChips.Rod
FishAndChips.Rod = setmetatable({}, {
	__call = function(self)
		return self
	end
})

---@class FishAndChips.Bait: SMODS.Center
---@field target string|string[] what attribute(s) this bait should target
---@field boost? number how much this bait should boost its targets
---@overload fun(self: FishAndChips.Bait): FishAndChips.Bait
FishAndChips.Bait = setmetatable({}, {
	__call = function(self)
		return self
	end
})


---@class FishAndChips.Environment: SMODS.GameObject
---@field generate_ui fun(self: FishAndChips.Environment) creates additional UI boxes to overlay ontop of the background
---@field update? fun(self: FishAndChips.Environment, dt: number) called every frame, use for animation
---@field post_generate_ui? fun(self: FishAndChips.Environment) creates additional UI boxes to overlay ontop of the background after jimbo is drawn
---@field ambience? string sound key to ambient sounds related to this environment
---@field collection_atlas? string atlas to use in the collection
---@field collection_pos? table|{x: number, y: number} position in the collection_atlas to use in the collection
---@field background_atlas? string atlas to use in the fishing screen
---@field background_pos? table|{x: number, y: number} position in the background_atlas to use in the fishing screen
---@field water_bounds? table|{top: number, bottom: number} bounds of where the bobber can land on this environment
---@field ppu_artist string[] key(s) for the artist(s) who drew this environment
---@field jimbo_offset? table|{x: number, y: number} offset position for jimbo, default is {x = 0.05, y = -1.85}
---@overload fun(self: FishAndChips.Environment): FishAndChips.Environment
FishAndChips.Environment = setmetatable({}, {
	__call = function(self)
		return self
	end
})
