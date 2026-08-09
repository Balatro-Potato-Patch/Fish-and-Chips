return {
    descriptions = {
		PotatoPatch = {
			PotatoPatchDev_stupid = {
				name = "stupid",
			},
			PotatoPatchDev_egg_node = {
				name = "egg_node",
			},
        },
        fac_Fish = {
            fish_fac_segg_pale_oil = {
                name = "Pale Oil",
                text = {
                    "Use to apply an {C:dark_edition}Edition{}",
                    "to a random Joker",
                    "{s:0.8,C:inactive}Cannot apply Negative{}"
                },
                flavor = {
                    "Bile gland of a",
                    "rare sylphean slug."
                }
            },
            fish_fac_segg_void_fish = {
                name = "Void Fish",
                text = {
                    "Retriggers all played cards,",
                    "but sets money to {C:money}$#1#",
                    "at the end of the {C:attention}shop"
                },
                flavor = {
                    "Lashing fragments of pure darkness,",
                    "shaped into sharpened tentacles."
                }
            },
            fish_fac_segg_root_fish = {
                name = "Rootfish",
                text = {
                    "When {C:attention}Blind{} is selected,",
                    "lowers {C:attention}sell value{} of all Jokers",
                    "by {C:money}$#1#{} and gains {X:mult,C:white} X#2# {} Mult",
                    "for each dollar removed",
                    "{C:inactive}(Currently {X:mult,C:white} X#3# {C:inactive} Mult)"
                },
                flavor = {
                    "The time...",
                    "the time of birth approaches."
                }
            },
            fish_fac_segg_plasmium_phial = {
                name = "Plasmium Phial",
                text = {
                    "{C:blue}+#1#{} Hands",
                },
                flavor = {
                    "Injecting the liquid allows",
                    "one to gain health beyond",
                    "their natural limits."
                }
            },
            -- todo

            fish_fac_segg_lost_lays = {
                name = "Lost Lay's",
                text = {
                    "{C:blue}+#1#{} Chips",
                    "{C:blue}-#2#{} Chips per",
                    "round played",
                },
                flavor = {
                    "You can never",
                    "eat just one chip.",
                }
            },

            -- todo

            fish_fac_segg_yumama = {
                name = "Yumama",
                text = {
                    "Add {C:attention}#1#{} randomly {C:attention}Enhanced cards{}",
                    "with the rank of {C:attention}#2#{} selected card",
                    "to your hand",
                },
                flavor = {
                    "Large, gelatinous drifter.",
                    "Chases away threats by",
                    "hurling its bulk around.",
                }
            },

        },
    },
    misc = {
        dictionary = {
            b_fac_segg_void_fish = "Void",
            b_fac_segg_chips_down = "Yum Yum!",
            b_fac_segg_chips_gone = "Bye Bye!",
        },
    },
}
