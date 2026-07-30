return {
    descriptions = {
		PotatoPatch = {
			PotatoPatchDev_Mack = {
				name = "Mack",
			},
			PotatoPatchDev_Snapper = {
				name = "Snapper",
			},
        },
        fac_Fish = {
            fish_fac_cod = {
                name = "Common Cod",
                text = {
                    "{C:chips}+#1#{} Chips"
                },
                flavor = {
                    "This fish likes to",
                    "call itself Zubin."
                }
            },
            fish_fac_bass = {
                name = "Basic Bass",
                text = {
                    "{C:mult}+#1#{} Mult"                    
                },
                flavour = {
                    "This fish is often seen",
                    "at the back of the string",
                    "section in most orchestras.",
                    "...Wait no, wrong bass..."
                }
            },
            fish_fac_earthfish = {
                name = "Ocean Earthfish",
                text = {
                    "Earn {C:fac_sand_dollars,f:fac_sand_dollars}${C:fac_sand_dollars}#1#{} for every",
                    "{C:money}$#2#{} that you have",
                    "at end of round"
                },
                flavour = {
                    "{element:1}"
                }
            },
            fish_fac_steelhead = {
                name = "Sticky Steelhead",
                text = {
                    "Copies the ability of",
                    "the {C:attention}Fish{} to the left",
                },
                flavour = {
                    "Typically an ocean fish,",
                    "these gummy fish return to",
                    "rivers to lay Easter eggs."
                }
            },
            fish_fac_swordine = {
                name = "Swordine",
                text = {
                    "On the {C:attention}first hand{} of",
                    "the round, {C:red}destroys{} the",
                    "{C:attention}rightmost{} scoring card"
                },
                flavour = {
                    "In medieval times, chefs are",
                    "believed to have used this",
                    "fish to cut their fillets."
                }
            },
            fish_fac_flailnder = {
                name = "Flailnder",
                text = {
                    "Disables the next",
                    "selected {C:attention}Boss Blind{}",
                    "and {S:1.1,C:red,E:2}self destructs{}"
                },
                flavour = {
                    "A weapon once held",
                    "in the flippers of",
                    "the Cod of War."
                }
            },
            fish_fac_piranha = {
                name = "Prehistoric Piranha",
                text = {
                    "Retrigger all played",
                    "cards that were played",
                    "previously this {C:attention}Ante{}"
                },
                flavour = {
                    "A remnant of ancient times.",
                    "It's a miracle it's still alive."
                }
            },
            fish_fac_dogfish = {
                name = "Dirty Dogfish",
                text = {
                    "Use this fish to",
                    "create {C:attention}#1#{} Baits",
                },
                flavour = {
                    "Despite its name, it's not a dog.",
                    "You can still pet it, though!"
                }
            },
            fish_fac_minnow = {
                name = "Giant Minnow",
                text = {
                    "Played and unscored cards",
                    "each have a {C:green}#1# in #2#{} chance",
                    "to increase rank by {C:attention}#3#{}"
                },
                flavour = {
                    "Despite the similarities,",
                    "giant minnows are completely",
                    "unrelated to giant blinnows."
                }
            },
            fish_fac_poolfish = {
                name = "Liminal Poolfish",
                text = {
                    "All hands are",
                    "{C:planet}#1#{} levels higher",
                    "{C:red}-#2#{} level per",
                    "round played"
                },
                flavour = {
                    "Side effects may include:",
                    "Nausea, Water Breathing, Wall Climbing"
                }
            },
            fish_fac_flounder = {
                name = "Flatbread Flounder",
                text = {
                    "Copies the ability of",
                    "the rightmost {C:attention}Fish{}",
                },
                flavour = {
                    "Quite bland on its own,",
                    "but makes a great base",
                    "for other foods!"
                }
            },
            fish_fac_clothesfish = {
                name = "Clothesfish",
                text = {
                    "{X:mult,C:white}X#1#{} Mult if played",
                    "hand contains",
                    "a {C:attention}#2#{}"
                },
                flavour = {
                    "WHAT STORE ARE YOU IN",
                    "I'M AT THE SOUP STORE",
                    "WHY ARE YOU BUYING",
                    "CLOTHES AT THE SOUP STORE",
                }
            },
            fish_fac_deathfish = {
                name = "Deathfish",
                text = {
                    "Select {C:attention}#1#{} cards,",
                    "convert the {C:attention}left{} card",
                    "into the {C:attention}right{} card",
                    "{C:inactive}(Drag to rearrange){}"
                },
                flavour = {
                    "The name should hopefully give",
                    "you an idea of what happens",
                    "when you eat this fish."
                }
            },
            fish_fac_bonefish = {
                name = "Bonefish",
                text = {
                    "Prevents Death",
                    "if chips scored",
                    "are at least {C:attention}25%",
                    "of required chips",
                    "{C:red,E:2}self destructs"
                },
                flavour = {
                    "Treating these fish to a",
                    "banana is a sure way to",
                    "tame their fiesty nature!"
                }
                --[[ possible other flavor text suggestion [gabby]
                "Bound together with",
                "the last remnants of",
                "a poor sinner's soul..."
                ]]
            },
            fish_fac_milkfin = {
                name = "Milkfin",
                text = {
                    "Cards with {V:1}#1#{} suit",
                    "give {C:mult}+#2#{} Mult when",
                    "held in hand,",
                    "{C:inactive,s:0.8}suit changes at end of round{}"
                },
                flavour = {
                    "WARNING: Do NOT eat",
                    "milkfin roe! It is",
                    "incredibly toxic!"
                }
            }
        },
    }
}
