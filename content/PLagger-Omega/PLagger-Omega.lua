----------
---CREDITS
----------

PotatoPatchUtils.Developer {
  name = 'Omegaflowey18',
  colour = G.C.MULT,
  fac_partner = 'fac_PLagger',
  atlas = 'fac_plaggeromega_credits',
  pos = {x = 0, y = 0}
}

PotatoPatchUtils.Developer {
  name = 'PLagger',
  colour = G.C.MULT,
  fac_partner = 'fac_Omegaflowey18',
  atlas = 'fac_plaggeromega_credits',
  pos = {x = 1, y = 0}
}

--[[
ideas:
mystic remora in pier
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
  config = {extra = {mult = 0, mult_mod = 3}},

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
  blueprint_compat = false,
  config = {extra = {}},

  loc_vars = function (self, info_queue, card)
    info_queue[#info_queue+1] = G.P_CENTERS['m_stone']
  end,

  calculate = function (self, card, context)
    if context.before and not context.blueprint then
      local cards = 0
      for _, scored_card in ipairs(context.scoring_hand) do
        cards = cards + 1
        if cards == #context.scoring_hand then
          scored_card:set_ability('m_stone', nil, true)
          G.E_MANAGER:add_event(Event({
            func = function()
              scored_card:juice_up()
              return true
            end
          }))
        end
      end
      return{
        message = localize('fac_plaggeromega_stone'),
        colour = G.C.CHIPS
      }
    end
  end
}

FishAndChips.Fish{ --Gummigoo
  key = 'plaggeromega_gummigoo',
  atlas = 'plaggeromega_fish',
  pos = {x=3,y=1},
  weight = 4,
  environments = {chocolate_river = 0.76, swamp = 0.5},
  attributes = {'retrigger'},
  stats = {
    weight = {min = 0.69, max = 4.20},
    length = {min = 45, max = 224}
  },
  ppu_coder = {'PLagger'},
  ppu_artist = {'Omegaflowey18'},
  impulse_min = 0.31,
  impulse_max = 0.39,
  vel_limit = 0.6,
  cost = 5,
  blueprint_compat = true,
  eternal_compat = false,
  config = {extra = {rounds = 3}},

  loc_vars = function (self, info_queue, card)
    return{
      vars = {card.ability.extra.rounds}
    }
  end,

  calculate = function (self, card, context)
      if context.repetition and context.cardarea == G.play then
        return {
          repetitions = 1
          }
      end
      if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
        if card.ability.extra.rounds - 1 <= 0 then
          SMODS.destroy_cards(card, nil, nil, true)
          return{
            message = localize('k_eaten_ex'),
            colour = G.C.BLUE
          }
        else
          card.ability.extra.rounds = card.ability.extra.rounds - 1
          return{
            message = card.ability.extra.rounds .. ' Rounds Left',
            colour = G.C.FILTER
          }
        end
      end
  end
}

FishAndChips.Fish{ --Frozen Chicken
  key = 'plaggeromega_frozenchicken',
  atlas = 'plaggeromega_fish',
  pos = {x=4,y=1},
  weight = 5,
  environments = {styx = 1},
  attributes = {'chips', 'deltarune'},
  stats = {
    weight = {min = 60, max = 90},
    length = {min = 130, max = 150},
  },
  ppu_coder = {'PLagger'},
  ppu_artist = {'Omegaflowey18'},
  impulse_min = 0,
  impulse_max = 0,
  vel_limit = 0,
  cost = 6,
  blueprint_compat = true,
  config = {extra = {chips = 0, chips_mod = 30}},

  loc_vars = function (self, info_queue, card)
    info_queue[#info_queue+1] = G.P_CENTERS.m_glass
    local glasses = 0
    if G.playing_cards then
      for _, playing_card in ipairs(G.playing_cards) do
        if SMODS.has_enhancement(playing_card, 'm_glass') then
          glasses = glasses + 1
        end
      end
      card.ability.extra.chips = card.ability.extra.chips_mod * glasses
      return{
        vars = {card.ability.extra.chips or 0, card.ability.extra.chips_mod or 30}
      }
    else
      return{
        vars = {card.ability.extra.chips or 0, card.ability.extra.chips_mod or 30}
      }
    end
  end,

  calculate = function (self, card, context)
    if context.joker_main then
      local glasses = 0
      for _, playing_card in ipairs(G.playing_cards) do
        if SMODS.has_enhancement(playing_card, 'm_glass') then
          glasses = glasses + 1
        end
      end
      return{
        chips = card.ability.extra.chips
      }
    end
  end
}

FishAndChips.Fish{ --Mystic Remora
  key = 'plaggeromega_mysticremora',
  atlas = 'plaggeromega_fish',
  pos = {x=0,y=2},
  weight = 4,
  environments = {pier = 1},
  attributes = {'draw'}, --i couldnt think of any fitting attributes from base FAC so i just made this one up, feel free to change
  stats = {
    weight = {min = 0.42, max = 0.87},
    length = {min = 0.35, max = 0.58}
  },
  ppu_coder = {'PLagger'},
  ppu_artist = {'Omegaflowey18'},
  impulse_min = 0.18,
  impulse_max = 0.42,
  vel_limit = 0.59,
  cost = 0,
  blueprint_compat = true,
  eternal_compat = false,
  config = {extra = {upkeep = 0, cumulative_upkeep = 1}},

  loc_vars = function (self, info_queue, card)
    return{
      vars = {card.ability.extra.upkeep, card.ability.extra.cumulative_upkeep}
    }
  end,

  can_sell = function (self, card, context)
    return false
  end,

  calculate = function (self, card, context)
    if context.setting_blind and not context.blueprint then
      card.ability.extra.upkeep = card.ability.extra.upkeep + card.ability.extra.cumulative_upkeep
      --Create the cumulative upkeep choice menu 
      G.E_MANAGER:add_event(Event({
            func = function()
                delay(0.4)
                G.FUNCS.fac_plaggeromega_run_upkeep_cost_menu(card.ability.extra.upkeep, card)
                return true
            end
        }))
      delay(0.4)
      --Destroy it if the cost wasn't paid
      G.E_MANAGER:add_event(Event({
            func = function()
                if G.GAME.fac_plaggeromega_sac_the_fish then
                  --reset the global
                  G.GAME.fac_plaggeromega_sac_the_fish = false
                  SMODS.destroy_cards(card, nil, true, false)
                  play_sound('slice1', 0.96+math.random()*0.08)
                end
                return true
            end
        }))
    end

    if context.individual and context.cardarea == G.play then
      SMODS.draw_cards(1)
    end
  end
}

FishAndChips.Fish{  --Chi-Yu
  key = 'plaggeromega_chiyu',
  atlas = 'plaggeromega_fish',
  pos = {x=1,y=2},
  weight = 3,
  environments = {volcano = 3, aquifer = 0.2},
  attributes = {'hand_level'},
  stats = {
    weight = {min = 3.8, max = 4.9},
    length = {min = 0.29, max = 0.4},
  },
  ppu_coder = {'PLagger'},
  ppu_artist = {'Omegaflowey18'},
  impulse_min = 0.184,
  impulse_max = 0.328,
  vel_limit = 0.4,
  blueprint_compat = true,
  cost = 5,

  calculate = function (self, card, context)
    if G.GAME.current_round.discards_left == 2 and not context.blueprint then --stole this from TOGA
			local eval = function() return G.GAME.current_round.discards_left == 1 and not G.RESET_JIGGLES end
			juice_card_until(card, eval, true)
		end
    if context.pre_discard and G.GAME.current_round.discards_left == 1 and not context.hook then
        local text, _ = G.FUNCS.get_poker_hand_info(G.hand.highlighted)
        return {
            level_up = true,
            level_up_hand = text
        }
    end
  end
}

----------
---UI BULLSHIT
----------

G.FUNCS.fac_plaggeromega_run_upkeep_cost_menu = function(upkeep, object)
  G.FUNCS.overlay_menu{
    definition = fac_plaggeromega_create_upkeep_cost_menu(upkeep, object),
    config = { no_esc = true }
  }
end

function fac_plaggeromega_create_upkeep_cost_menu(upkeep, object)
  G.SETTINGS.paused = true
  local temp_area = CardArea(
    G.hand.T.x + 0,
    G.hand.T.y + G.ROOM.T.y + 9,
    1.05 * G.CARD_W,
    1.05 * G.CARD_H,
    { card_limit = 0, type = 'joker', highlight_limit = 0, negative_info = true, no_card_count = true})
  local card_copy = SMODS.copy_card(object)
  card_copy.states.hover.can = true
  temp_area:emplace(card_copy)


  local ui_node = {n=G.UIT.R, config = {align = 'cm'}, nodes = {{n=G.UIT.O, config={object=temp_area}}}}
    --actually make the UI
    local pay =
      UIBox_button({
        button = 'fac_plaggeromega_pay_upkeep',
        func = 'fac_plaggeromega_can_pay_upkeep',
        ref_table = {cost = upkeep},
        minw = 5,
        minh = 3,
        shadow = true,
        label = {localize('fac_plaggeromega_pay'), localize('$') .. tostring(upkeep)},
      })

    local dont =
      UIBox_button({
        func = 'fac_plaggeromega_dont_pay',
        button = 'fac_plaggeromega_sacrifice_fish',
        minw = 5,
        minh = 3,
        label = {localize('fac_plaggeromega_sac_it')},
      })

    local t =
      { n = G.UIT.R, config = {
        align = 'cm',
        minw = 8,
        minh = 8,
        padding = 0.1,
        r = 0.2,
        colour = G.C.GREY,
        outline = 0.8,
        outline_colour = G.C.WHITE,
        instance_type = POPUP,
        no_esc = true,
        no_back = true
      },
        nodes = {
          ui_node,
          pay,
          dont,
        },
      }
      --thanks eremel and notmario for helping me sort out this crap
      --go my gigantic UI node to block clicking
  return {n=G.UIT.ROOT, config = {align = "cm", minw = G.ROOM.T.w*5, minh = G.ROOM.T.h*5,padding = 0.1, r = 0.1, colour = {G.C.GREY[1], G.C.GREY[2], G.C.GREY[3],0.7}}, nodes={
        t
    }}
end

function G.FUNCS.fac_plaggeromega_can_pay_upkeep(e)
    if ((G.GAME.dollars - G.GAME.bankrupt_at) - e.config.ref_table.cost < 0) and G.GAME.current_round.reroll_cost ~= 0 then
      e.config.colour = G.C.UI.BACKGROUND_INACTIVE
      e.config.button = nil
    else
      e.config.colour = G.C.GREEN
      e.config.button = 'fac_plaggeromega_pay_fish'
    end
end

function G.FUNCS.fac_plaggeromega_pay_fish(e)
  ease_dollars(-e.config.ref_table.cost)
  if type(G.OVERLAY_MENU) == "table" then G.FUNCS.exit_overlay_menu() end
    G.SETTINGS.paused = false
end

function G.FUNCS.fac_plaggeromega_dont_pay(e)
  e.config.colour = G.C.RED
  e.config.button = 'fac_plaggeromega_sacrifice_fish'
end

function G.FUNCS.fac_plaggeromega_sacrifice_fish(e)
  G.GAME.fac_plaggeromega_sac_the_fish = true
  if type(G.OVERLAY_MENU) == "table" then G.FUNCS.exit_overlay_menu() end
  G.SETTINGS.paused = false
end