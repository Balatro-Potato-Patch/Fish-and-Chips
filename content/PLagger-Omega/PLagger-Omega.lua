----------
---CREDITS
----------

PotatoPatchUtils.Developer {
  name = 'Omegaflowey18',
  colour = G.C.MULT,
  fac_partner = 'PLagger',
  atlas = 'fac_plaggeromega_credits',
  pos = {x = 0, y = 0}
}

PotatoPatchUtils.Developer {
  name = 'PLagger',
  colour = G.C.MULT,
  fac_partner = 'Omegaflowey18',
  atlas = 'fac_plaggeromega_credits',
  pos = {x = 1, y = 0}
}

--[[
ideas:
Gurmag Angler in Swamp, scales off of joker destruction
Stewfish in Soup & Choco River?
Docfish in Pier & City River, hiker but for aces with scholar stats
Biblically accurate angelfish in backrooms
Relicanth in Cavern Aquifer, Stone cards
Gummigoo in Choco River & Swamp
]]

----------
---ATLASES
----------

SMODS.Atlas({
	key = "plaggeromega_fish",
	path = "PLagger-Omega/fish.png",
	px = 71,
	py = 95,
})

SMODS.Atlas({
  key = 'plaggeromega_credits',
  path = 'PLagger-Omega/credits.png',
  px = 71,
  py = 95
})

----------
---SOUNDS
----------

SMODS.Sound({
  key = 'plaggeromega_meteor',
  path = 'PLagger-Omega/meteor.ogg',
  pitch = 1
})

----------
---FISHES
----------

FishAndChips.Fish{ --Hawaii Fish
    key = 'plaggeromega_hawaii',
    atlas = 'plaggeromega_fish',
    pos = {x=0,y=0},
    weight = 10,
    environments = {
      volcano = 1
    },
    attributes = {'xmult'},
    stats = {
      weight = {min = 20, max = 50},
      length = {min = 1.2, max  = 5}
    },
    ppu_coder = {'PLagger'},
    ppu_artist = {'Omegaflowey18'},
    cost = 5,
    blueprint_compat = true,
    config = {extra = {xmult = 3, housed = false, poker_hand = 'Full House'}},

    loc_vars = function (self, info_queue, card)
      local main_end = nil
      main_end = {
                {
                    n = G.UIT.C,
                    config = { align = "bm", minh = 0.4 },
                    nodes = {
                        {
                            n = G.UIT.C,
                            config = { ref_table = card, align = "m", colour = card.ability.extra.housed and G.C.GREEN or G.C.RED, r = 0.05, padding = 0.06 },
                            nodes = {
                                { n = G.UIT.T, config = { text = ' ' .. localize(card.ability.extra.housed and 'fac_plaggeromega_active_ex' or 'fac_plaggeromega_inactive') .. ' ', colour = G.C.UI.TEXT_LIGHT, scale = 0.32 * 0.9 } },
                            }
                        }
                    }
                }
            }
      return{
        main_end = main_end,
        vars = {
          card.ability.extra.xmult,
          localize(card.ability.extra.poker_hand, 'poker_hands'),
        }
      }
    end,

    calculate = function (self, card, context)
      if context.pre_discard and not context.hook and not card.ability.extra.housed
          and G.FUNCS.get_poker_hand_info(G.hand.highlighted) == card.ability.extra.poker_hand then
          card.ability.extra.housed = true
      end

      if context.joker_main and card.ability.extra.housed then
          return{
            xmult = card.ability.extra.xmult
          }
      end

      if context.end_of_round then
        card.ability.extra.housed = false
      end
    end
}

FishAndChips.Fish{ --Trout Earth Extinction
    key = 'plaggeromega_troutearthextinct',
    atlas = 'plaggeromega_fish',
    pos = {x=1,y=0},
    weight = 2,
    environments = {
      wormhole = 0.67
    },
    attributes = {'usable'},
    stats = {
      weight = {min = 67, max = 69},
      length = {min = 30, max  = 30}
    },
    ppu_coder = {'PLagger'},
    ppu_artist = {'Omegaflowey18'},
    cost = 8,
    blueprint_compat = false,
    config = {extra = {ante = 1}},
    impulse_min = 0.3,
    impulse_max = 0.6,
    decision_min = 0.13,
    decision_max = 0.2,
    vel_limit = 1.5,

    loc_vars = function (self, info_queue, card)
      return{
        vars = {card.ability.extra.ante}
      }
    end,

    use = function (self, card, area)
      local trout_earths = SMODS.find_card('fish_fac_plaggeromega_troutearthextinct')
      ease_ante(-card.ability.extra.ante * #trout_earths)
      local first_dissolve = nil
      for _, fish in ipairs(G.fac_fish_area.cards) do
        fish:start_dissolve(nil, first_dissolve)
        first_dissolve = true
      end
      play_sound('fac_gplaggeromega_meteor', 1, 2)
    end,

    can_use = function(self, card)
      return true
    end
}

FishAndChips.Fish{ --Xanax Sargo
  key = 'plaggeromega_xanaxsargo',
  atlas = 'plaggeromega_fish',
  pos = {x=2,y=0},
  weight = 10,
  environments = {calm_pond = 5, garden = 10},
  attributes = {'passive', 'economy'},
  stats = {
      weight = {min = 4, max = 5},
      length = {min = 0.25, max  = 0.70}
    },
  ppu_coder = {'PLagger'},
  ppu_artist = {'Omegaflowey18'},
  cost = 4,
  blueprint_compat = false,
  config = {extra = {dollars = 2, sand_dollars = 1}},
  impulse_min = 0.13,
  impulse_max = 0.23,
  vel_limit = 0.33,

  loc_vars = function (self, info_queue, card)
    return{
      vars = {card.ability.extra.dollars, card.ability.extra.sand_dollars}
    }
  end,

  calculate = function (self, card, context)
    if context.modify_final_cashout and not context.blueprint then
      return{
        dollars = card.ability.extra.dollars,
        sand_dollars = card.ability.extra.sand_dollars
      }
    end
  end
}

FishAndChips.Fish{ --Docfish
  key = 'plaggeromega_docfish',
  atlas = 'plaggeromega_fish',
  pos = {x=0,y=1},
  weight = 7,
  environments = {pier = 0.6, city_river = 0.8},
  attributes = {'mult', 'chips'},
  stats = {
      weight = {min = 0.67, max = 3.5},
      length = {min = 1.20, max  = 2.25}
    },
  ppu_coder = {'PLagger'},
  ppu_artist = {'Omegaflowey18'},
  impulse_min = 0.13,
  impulse_max = 0.23,
  vel_limit = 0.33,
  cost = 6,
  blueprint_compat = true,
  config = {extra = {chips = 2, mult = 1}},

  loc_vars = function (self, info_queue, card)
    return{
      vars = {card.ability.extra.chips, card.ability.extra.mult}
    }
  end,

  calculate = function (self, card, context)
    if context.individual and context.cardarea == G.play and context.other_card:get_id() == 14 then
      context.other_card.ability.perma_bonus = (context.other_card.ability.perma_bonus or 0) + card.ability.extra.chips
      context.other_card.ability.perma_mult = (context.other_card.ability.perma_mult or 0) + card.ability.extra.mult
      return{
        message = localize('k_upgrade_ex'),
        colour = G.C.PURPLE
      }
    end
  end
}