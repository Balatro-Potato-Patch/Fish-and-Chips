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

---@class IntStats
---@field min number Minimum value of this measurement
---@field max number Maximum value of this measurement

---@class Stats
---@field weight IntStats Set a min and max value for weight, measure in kilograms
---@field length IntStats Set a min and max value for length, measured in metres

---@class FishAndChips.Fish: SMODS.Center
---@field environments Environments where this fish can appear, key = weight
---@field stats Stats Set a range for available measurements for the fish
---@field impulse_min? number base minimum movement distance when being caught; lower values are easier (for fish)
---@field impulse_max? number base maximum movement distance when being caught; lower values are easier (for fish)
---@field decision_min? number base minimum time before changing movement; higher values are easier (for fish)
---@field decision_max? number base maximum time before changing movement; higher values are easier (for fish)
---@field vel_limit? number base maximum speed along the catch track; lower values are easier (for fish)
---@field colour? number colour of sweet spot (I THINK NEED TO CHECK THIS)
---@field requires_hand? boolean makes the hand move back into view if this card is selected
---@field requires_jokers? boolean makes the jokers area move back into view if this card is selected while in the fishing state
---@field requires_consumables? boolean makes the comsumables area move back into view if this card is selected while in the fishing state
---@field ppu_coder string[] key(s) for the developer(s) who coded this fish
---@field ppu_artist? string[] key(s) for the artist(s) who drew this fish
---@field use? fun(self: FishAndChips.Fish, card: Card) Defines behaviour when this fish is used. 
---@field can_use? fun(self: FishAndChips.Fish, card: Card): boolean? Return `true` if the fish is allowed to be used.
---@field keep_on_use? fun(self: FishAndChips.Fish, card: Card): boolean? return `true` if the fish should be kept when used.
---@field treasure? boolean mark as true if this can be caught as a treasure 
---@field disable_visual_scaling? boolean disable adjustments of the size of this fish based on its caught measurements
---@field on_catch? fun(self: FishAndChips.Fish, card: Card) If defined, this function will be called when this fish is called.
---@field badge_key? string replace the text on the fish badge with whatever is in misc.dictionary[badge_key]
---@field button_key? string|fun(self: FishAndChips.Fish, card: Card): string Replace the use button text key with the provided key. Providing a function replaces the text without localizing
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
---@field vel_limit? number multiplier applied to the fish's maximum movement speed; values below 1 are easier (for rods)
---@field impulse_min? number multiplier applied to the fish's minimum movement distance; values below 1 are easier (for rods)
---@field impulse_max? number multiplier applied to the fish's maximum movement distance; values below 1 are easier (for rods)
---@field decision_min? number multiplier applied to the fish's minimum time before changing movement; values above 1 are easier (for rods)
---@field decision_max? number multiplier applied to the fish's maximum time before changing movement; values above 1 are easier (for rods)

---@class FishAndChips.FishingProfile
---@field key string key of the fish being caught
---@field name string name of the fish being caught
---@field bar_size number rod-only catch-zone size, taken from the rod or default; higher values are easier
---@field catch_gain number rod-only catch progress gained per second, taken from the rod or default; higher values are easier
---@field catch_loss number rod-only catch progress lost per second, taken from the rod or default; lower values are easier
---@field treasure_gain number treasure progress gained per second for this catch, taken from the rod or default; higher values are easier
---@field vel_limit number maximum fish speed that will be used for this catch, after applying the fish/default base and rod multiplier; lower values are easier
---@field impulse_min number minimum movement distance that will be used for this catch, after applying the fish/default base and rod multiplier; lower values are easier
---@field impulse_max number maximum movement distance that will be used for this catch, after applying the fish/default base and rod multiplier; lower values are easier
---@field decision_min number minimum time before changing movement that will be used for this catch, after applying the fish/default base and rod multiplier; higher values are easier
---@field decision_max number maximum time before changing movement that will be used for this catch, after applying the fish/default base and rod multiplier; higher values are easier
---@field colour number[] Sweet Spot colour that will be used for this catch, taken from the fish, rod, or default
---@field rod table active rod's fishing settings
---@field rod_key string key of the active rod
---@field center FishAndChips.Fish center object of the fish being caught

---@class FishAndChips.ModifiableFishingProfile
---@field treasure_gain number treasure progress gained per second; higher values are easier
---@field vel_limit number maximum fish speed; lower values are easier
---@field impulse_min number minimum movement distance; lower values are easier
---@field impulse_max number maximum movement distance; lower values are easier
---@field decision_min number minimum time before changing movement; higher values are easier
---@field decision_max number maximum time before changing movement; higher values are easier
---@field colour number[] Sweet Spot colour

---@class FishAndChips.ModifyFishingProfileContext
---@field fac_modify_fishing_profile true identifies the pre-minigame profile modification context
---@field fishing_profile FishAndChips.ModifiableFishingProfile values fish may change for the upcoming catch
---@field hooked_fish FishAndChips.Fish hooked fish center object; use `.key` to identify its species

---@class FishAndChips.FishCaughtContext
---@field fac_fish_caught Card actual Card object created for the caught fish
---@field fish string center key of the caught fish
---@field treasure boolean whether this Card was caught as the bonus treasure fish
---@field perfect boolean whether the main catch was perfect

---@class FishAndChips.EndFishingContext
---@field fac_end_fishing true identifies the end-of-fishing context
---@field failed boolean whether the fish escaped
---@field fish string? center key of the caught fish; nil when the catch failed
---@field treasure boolean whether treasure was collected
---@field treasure_available boolean whether treasure appeared during the fishing attempt
---@field treasure_progress number treasure progress when the fishing attempt ended
---@field missed_treasure boolean whether the fish was caught while available treasure was not collected
---@field attempted_treasure boolean whether uncollected treasure received any progress
---@field perfect boolean whether the catch succeeded without losing catch progress

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
