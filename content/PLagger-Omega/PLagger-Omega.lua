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

Relicanth in Cavern Aquifer, Stone cards
Gummigoo in Choco River & Swamp
mystic remora in ?
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
          local eval = function () return card.ability.extra.housed and not G.RESET_JIGGLES end
        juice_card_until(card, eval, true)
          return{
            message = localize('k_active_ex')
          }
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
      play_sound('fac_plaggeromega_meteor', 1, 2)
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

FishAndChips.Fish{ --Gurmag Angler
  key = 'plaggeromega_gurmag',
  atlas = 'plaggeromega_fish',
  pos = {x=3,y=0},
  weight = 8,
  environments = {styx = 0.4, swamp = 0.7},
  attributes = {'xmult'},
  stats = {
    weight = {min = 10.2, max = 25.4},
    length = {min = 3, max = 7}
  },
  ppu_coder = {'PLagger'},
  ppu_artist = {'Omegaflowey18'},
  impulse_min = 0.2,
  impulse_max = 0.3,
  vel_limit = 0.7,
  cost = 7,
  blueprint_compat = true,
  config = {extra = {xmult = 1, xmult_mod = 0.5}},

  loc_vars = function (self, info_queue, card)
    return{
      vars = {card.ability.extra.xmult, card.ability.extra.xmult_mod}
    }
  end,

  calculate = function (self, card, context)
    if context.joker_type_destroyed and context.card.config.center.set == 'Joker' and not context.blueprint then
      card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.xmult_mod
      return{
        message = localize{type = 'variable', key = 'a_xmult', vars = {card.ability.extra.xmult_mod}}
      }
    end

    if context.joker_main then
      return{
        xmult = card.ability.extra.xmult
      }
    end
  end
}

FishAndChips.Fish{ --Stewfish
  key = 'plaggeromega_stewfish',
  atlas = 'plaggeromega_fish',
  pos = {x=4,y=0},
  weight = 10,
  environments = {soup = 0.6, chocolate_river = 0.1},
  attributes = {'mult'},
  stats = {
    weight = {min = 7, max = 14},
    length = {min = 0.25, max = 0.72}
  },
  ppu_coder = {'PLagger'},
  ppu_artist = {'Omegaflowey18'},
  impulse_min = 0.1,
  impulse_max = 0.3,
  vel_limit = 0.189,
  cost = 6,
  blueprint_compat = true,
  config = {extra = {mult = 0, mult_mod = 1}},

  loc_vars = function (self, info_queue, card)
    return{
      vars = {card.ability.extra.mult, card.ability.extra.mult_mod}
    }
  end,

  calculate = function (self, card, context)
    if context.fac_fish_caught then
      if FishAndChips.get_environment().key == 'soup' then
        card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_mod
        return{
          message = localize{type = 'variable', key = 'a_mult', vars = {card.ability.extra.mult}}
        }
      elseif card.ability.extra.mult > 0 then
        card.ability.extra.mult = 0
        return{
          message = localize('k_reset')
        }
      end
    end

    if context.joker_main then
      return{
        mult = card.ability.extra.mult
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

FishAndChips.Fish{ --Biblically Accurate Angelfish
  key = 'plaggeromega_baa',
  atlas = 'plaggeromega_fish',
  pos = {x=1,y=1},
  weight = 4,
  environments = {backroom = 0.77, garden = 0.022},
  attributes = {'usable', 'generation'},
  stats = {
    weight = {min = 2222, max = 4444},
    length = {min = 2222, max = 9999}
  },
  ppu_coder = {'PLagger'},
  ppu_artist = {'Omegaflowey18'},
  impulse_min = 0.12,
  impulse_max = 0.23,
  vel_limit = 1.11,
  cost = 7,
  blueprint_compat = false,
  config = {extra = {}},

  loc_vars = function (self, info_queue, card)
    info_queue[#info_queue+1] = {set = 'Other', key = 'rental', vars = {G.GAME.rental_rate or 1}}
  end,

  use = function (self, card, area)
    print'shout out giada'
    SMODS.add_card({set = 'Joker', rarity = 'Rare', force_stickers = {'rental'}, key_append = 'fac_plaggeromega_baa'})
  end,

  can_use = function(self, card)
    return G.jokers and #G.jokers.cards < G.jokers.config.card_limit
  end
}

FishAndChips.Fish{ --Relicanth
  key = 'plaggeromega_relicanth',
  atlas = 'plaggeromega_fish',
  pos = {x=2,y=1},
  weight = 8,
  environments = {aquifer = 1},
  attributes = {'passive', 'modify_card'}, --if there's better attributes for this fish i missed feel free to add them
  stats = {
    weight = {min = 69, max = 420},
    length = {min = 2.01, max = 4.01}
  },
  ppu_coder = {'PLagger'},
  ppu_artist = {'Omegaflowey18'},
  impulse_min = 0.212,
  impulse_max = 0.313,
  vel_limit = 0.44223,
  cost = 4,
  blueprint_compat = true,
  config = {extra = {}}
}