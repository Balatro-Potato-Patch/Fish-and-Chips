FishAndChips.Fish{
    key = "minty_seabass",
    atlas = "minty_fish",
    pos = {x=0, y=0},
    weight = 50, --should be 75-(all other minty fish weights) but can't think of a way to get this number procedurally so i'm just gonna have to set it manually once i've designed all my other fish
    native_weight = 5, --In the pier only, not affected by chumming
    ppu_coder = {"minty"},
    ppu_artist = {"Animal Crossing devteam"},
    environments = {
        pier = 10,
        soup = 10,
        chocolate_river = 10,
        volcano = 10,
        backroom = 10,
        wormhole = 10,
    },
    stats = {
        weight = {min = 2.5, max = 4},
        length = {min = 0.2, max = 0.65},
    },
    cost = 1,
    blueprint_compat = false,
    config = {
        extra = {
            luck = 1,
            sand_dollar_odds = 3,
            bait_odds = 8
        }
    },
    attributes = {
        "usable", "economy", "generation"
    },
    loc_vars = function (self, info_queue, card)
        local key = self.key
        local luck = card.ability.extra.luck
        if card.ability.extra.native then
            luck = luck*2
            key = key.."_alt"
        end

        local sd_luck, sd_odds = SMODS.get_probability_vars(card, luck, card.ability.extra.sand_dollar_odds, "fac_minty_seabass_sand_dollar", false)
        local bait_luck, bait_odds = SMODS.get_probability_vars(card, luck, card.ability.extra.bait_odds, "fac_minty_seabass_bait", false)
        return {
            key = key,
            vars = {
                sd_luck, sd_odds,
                bait_luck, bait_odds,
            }
        }
    end,
    use = function (self, card)
        SMODS.destroy_cards(card, {colours = {G.C.RED}})
        local luck = card.ability.extra.luck
        if card.ability.extra.native then
            luck = luck*2
        end

        if SMODS.pseudorandom_probability(card, "fac_minty_seabass_sand_dollar", luck, card.ability.extra.sand_dollar_odds) then
            ease_sand_dollars(1)
        end
        if SMODS.pseudorandom_probability(card, "fac_minty_seabass_bait", luck, card.ability.extra.bait_odds) then
            local bait = SMODS.poll_object{type = "fac_Bait"}
            FishAndChips.add_bait_to_inventory(bait, 1)
        end
        if (FishAndChips.get_environment() or {}).key ~= "pier" then
            G.GAME.minty_seabass_chummed = (G.GAME.minty_seabass_chummed or 0) + 1
        end
    end,
    can_use = function (self, card)
        return true
    end,
    on_catch = function (self, card)
        if (FishAndChips.get_environment() or {}).key == "pier" then
            card.ability.extra.native = true
        end
        if G.GAME.minty_seabass_ever_caught then
            SMODS.calculate_effect({message = localize("k_fac_minty_youagain_qex"), delay = 3 }, card)
        else
            G.GAME.minty_seabass_ever_caught = true
        end
    end,
    get_weight = function (self)
        if (FishAndChips.get_environment() or {}).key == "pier" then return self.native_weight end

        local chummed = math.min(G.GAME.minty_seabass_chummed or 0, self.weight)
        return self.weight - chummed
    end

}