return {
    descriptions = {
        PotatoPatch = {
            PotatoPatchDev_Nick = {
                name = "{X:blind}Moby-Nick",
                text = {
                    {
                        "THE AGE OF THE WORMHOLE HAS ENDED",
                        "NO MORE SPACE THEMED EVENT",
                        "FOLLOW ME",
                        "AND YOU'LL NEVER GO HUNGRY AGAIN",
                        "ROOOOOOODSSSS UPPPPPP",
                        "I WILL LEAD US TO THE FISH AND CHIPS",
                        "{s:2}I... AM... MEGALADON!"
                    },
                    {
                        "Did half the art and concept ideas",
                        "and majority of the code meow :3"
                    },
                    {
                        "Play {C:incognito}Incognito{} and {C:jolyne}Hypererfixation{} :3"
                    }
                },
            },
            PotatoPatchDev_Jolyne = {
                name = "{X:blind}JoFIN",
                text = {
                    {
                        "WE CLUTCHED THE ART :3333",
                        "<- GLAZE ME FOR MY WONDERFUL ART"
                    },
                    {
                        "Did half the art and concept ideas",
                        "and some of the code :3"
                    },
                    {
                        "Play {C:jolyne}Hypererfixation{} and {C:incognito}Incognito{} :3"
                    }
                },
            },
        },
        fac_Fish = {
            fish_fac_one = {
                name = "One Fish",
                text = {
                    "Played {C:attention}Aces{}",
                    "give {C:mult}+#1#{} Mult",
                    "when scored"
                },
                flavour = {
                    "Its name seems redundant.",
                    "I mean, it's not like you can",
                    "catch multiple fish at once..."
                }
            },
            fish_fac_two = {
                name = "Two Fish",
                text = {
                    "Played {C:attention}2s{}",
                    "give {C:mult}+#1#{} Mult",
                    "when scored"
                },
                flavour = {
                    "Well, holy carp! You CAN",
                    "catch two fish at once!"
                }
            },
            fish_fac_red = {
                name = "Red Fish",
                text = {
                    "Converts {C:attention}#1#%{} of scored",
                    "{C:chips}Chips{} to {C:mult}Mult{} and set",
                    "scored {C:chips}Chips{} to base",
                    "poker hand {C:chips}Chips"
                },
                flavour = {
                    "Doesn't really work",
                    "with Blue Fish :/"
                }
            },
            fish_fac_blue = {
                name = "Blue Fish",
                text = {
                    "Convert {C:attention}#1#%{} of scored",
                    "{C:mult}Mult{} to {C:chips}Chips{} and set",
                    "scored {C:mult}Mult{} to base",
                    "poker hand {C:mult}Mult"
                },
                flavour = {
                    "Doesn't really work",
                    "with Red Fish :/"
                }
            },
            fish_fac_old = {
                name = "Old Fish",
                text = {
                    "Creates a Fish with",
                    "a {C:blind}Deltarune{} attribute",
                    "and {C:red}self-destructs",
                    "{ppu_bubble:usable}"
                },
                flavour = {
                    "{C:green}Gyaa Ha Ha!"
                }
            },
            fish_fac_bad = {
                name = "Bad Fish",
                text = {
                    {
                        "{X:blind,C:inscryption_blue}Brittle:",
                        "{C:red}Instantly perish{} at the",
                        "end of final score"
                    },
                    {
                        "{X:blind,C:inscryption_blue}Annoying:",
                        "When {C:attention}Blind{} is selected,",
                        "Increase Blind",
                        "Requirement by {X:blind,C:white}X#1#{}"
                    },
                    {
                        "Cannot be sold",
                        "{C:inactive,s:0.6}How {C:jolyne,s:0.6}priceless{C:inactive,s:0.6}..."
                    }
                },
                flavour = {
                    "Lost the 50/25/25 Lmao",
                }
            },
            fish_fac_darwin = {
                name = "Darwin",
                text = {
                    "{X:mult,C:white}X#1#{} Mult after",
                    "{C:attention}#2#{C:inactive} [#3#]{} rounds",
                    "{ppu_bubble:1}"
                },
                flavour = {
                    "I'm on my way, I'm on my way!"
                }
            },
            fish_fac_pear = {
                name = "Pear Fish",
                text = {
                    "The next {C:attention}#1#{C:inactive} [#2#]{} fishing",
                    "attempts, successful fish",
                    "catches level up {C:attention}Pair{} by {C:attention}#3#{}"
                },
                flavour = {
                    "A dark, forboding",
                    "feeling overtakes you.",
                    "You know this face,",
                    "even in its absence."
                }
            },
            fish_fac_sukuna = {
                name = "Ryomen Sutuna",
                text = {
                    "Switch {C:attention}current",
                    "{C:attention}ability{} when used",
                    "{C:inactive}(Currently {C:mult}+#1#{C:inactive} Mult)",
                    "{C:inactive}(Currently {C:chips}+#2#{C:inactive} Chips)",
                    "{C:inactive}(Currently: #3#){}",
                    "{ppu_bubble:usable}{ppu_bubble:toggle}"
                },
                flavour = {
                    "King of Sturgeons"
                }
            },
            fish_fac_gojo = {
                name = "Troutoru GoFish",
                text = {
                    "{C:green}Fixed #1#% chance{} to balance",
                    "{C:chips}Chips{} and {C:mult}Mult{}, switch {C:attention}current{}",
                    "{C:attention}ability{} at the end of round",
                    "{C:inactive,s:0.8}Percentage depends on current ability{}",
                    "{C:inactive}(Currently: #2#){}"
                },
                flavour = {
                    "Nah, I'd Fish"
                }
            },
            fish_fac_lordx = {
                name = "Lord X-ray Fish",
                text = {
                    "{X:mult,C:white}X#1#{} Mult when {C:attention}alone{}",
                    "{ppu_bubble:1}"
                },
                flavour = {
                    "{element:1}",
                    "{s:0.3} ",
                    "This fish seems to miss when",
                    "the pond was quieter...",
                }
            },
            fish_fac_majin = {
                name = "Marlin",
                text = {
                    {
                        "Gives you a {C:attention}prize{} if",
                        "you know the {C:attention}code!{}",
                        "{C:inactive,s:0.8}Reset when wrong",
                        "{C:inactive}[{V:1}#1#{C:inactive}] [{V:2}#2#{C:inactive}] [{V:3}#3#{C:inactive}] [{V:4}#4#{C:inactive}] [{V:5}#5#{C:inactive}] [{V:6}#6#{C:inactive}]",
                        "{ppu_bubble:1}"
                    },
                    {
                        "Selected card is used",
                        "to {C:attention}insert{} the next",
                        "digit for the {C:attention}code{}",
                        "{C:inactive,s:0.8}10 = 0, A = 1, no face cards",
                        "{ppu_bubble:usable}"
                    }
                },
                flavour = {
                    "{element:1}",
                    "{s:0.3} ",
                    "Don't let its looks fool",
                    "you, it's no savage!"
                }
            },
            fish_fac_redglove = {
                name = "Red-Herring",
                text = {
                    "{X:mult,C:white,s:0.8}Verdreifache{s:0.8} deinen aktuellen Punktemultiplikator,",
                    "{s:0.8}wenn sich dieser Fisch neben {C:attention,s:0.8}Lord X-Ray{s:0.8} befindet.",
                    "{ppu_bubble:1}"
                },
                flavour = {
                    "{element:1}",
                    "{s:0.3} ",
                    "{f:fac_tiktoksans,s:0.6}How I feel after singing my verse",
                    "{f:fac_tiktoksans,s:0.6}in German instead of English:"
                }
            },
            fish_fac_faker = {
                name = "Flounder",
                text = {
                    "Swaps current {C:money}money{}",
                    "and {C:fac_sand_dollars}sand dollars{}"
                },
                flavour = {
                    "{element:1}",
                    "{s:0.3} ",
                    "AND IT WINDS, AND IT WEAVES",
                    "ALL IT BINDS, ALL IT BLEEDS",
                    "NOWWWWWW",
                }
            },
            fish_fac_spalmon = {
                name = "[[{C:spalmon_pink}SPA{}L{C:spalmon_gold}MON{}]]",
                text = {
                    "{s:2}[Press F1 For] HELP",
                    "{C:inactive}at a [[phishing]] [site]",
                    "{ppu_bubble:1}"
                },
                flavour = {
                    "ARE {s:0.5,C:hearts}YOU{} GETTING ALL THIS {s:1.5,C:white}[Mack]{}!?",
                    "{s:0.7}I'M FINALLY {s:1.3}I'M FINALLY{} GONNA",
                    "BE A {s:2,C:spalmon_pink}BIG {s:2,C:spalmon_gold}TROUT{s:2}!!!{}"
                }
            },
            fish_fac_forgotten = {
                name = "Forgotten Fish",
                text = {
                    "Gains {C:fac_sand_dollars,f:fac_sand_dollars}${C:fac_sand_dollars}#1#{} of",
                    "{C:attention}sell value{} at",
                    "end of fishing"
                },
                flavour = {
                    "Well, there is a fish here."
                }
            },
            fish_fac_togore = {
                name = "Topegore",
                text = {
                    "{C:mult}+#1#{} Mult when in the",
                    "{C:attention}middle{} of the bucket",
                    "{ppu_bubble:1}"
                },
                flavour = {
                    "{C:attention}TO{}riel + to{C:attention}PE{} + as{C:attention}GORE{}"
                }
            },
            fish_fac_gaster = {
                name = "Basster",
                text = {
                    "Sets your {C:attention}FUN{}",
                    "value to {C:attention}#1#{}",
                    "{ppu_bubble:usable}"
                },
                flavour = {
                    "Notably Not Green"
                }
            },
            fish_fac_kay = {
                name = "'Kai",
                text = {
                    "{X:blind,C:white}S-Swing:",
                    "Destroys up to",
                    "{C:attention}#1#{} selected cards",
                    "{C:inactive,E:2}but...{}",
                    "{ppu_bubble:usable}"
                },
                flavour = {
                    "{C:hearts}    {}, {C:green}you {C:spades}actually {C:clubs}know {C:red}jack{}. {C:diamonds}Great{}"
                }
            },
            fish_fac_actually = {
                name = "Macktually",
                text = {
                    "{X:blind,C:white}Twister:",
                    "Up to {C:attention}#1#{} selected cards,",
                    "{C:attention}combine{} all ranks together",
                    "and create {C:attention}evenly split{} cards",
                    "{C:inactive,E:2}but...{}",
                    "{ppu_bubble:usable}"
                },
                flavour = {
                    "{C:hearts}'kay{}, {C:green}you {C:spades}         {C:clubs}know {C:red}jack{}. {C:diamonds}Great{}"
                }
            },
            fish_fac_know = {
                name = "Minknow",
                text = {
                    "{X:blind,C:white}Icetomb",
                    "Turn {C:attention}#1#{} random",
                    "cards in hand",
                    "into {C:attention}#2#{}",
                    "{C:inactive,E:2}but...{}",
                    "{ppu_bubble:usable}"
                },
                flavour = {
                    "{C:hearts}'kay{}, {C:green}you {C:spades}actually {C:clubs}     {C:red}jack{}. {C:diamonds}Great{}"
                }
            },
            fish_fac_jack = {
                name = "Jack",
                text = {
                    "{X:blind,C:white}Mean`````Fellow:",
                    "Decrease Blind",
                    "Requirement by {X:blind,C:white}X#1#{}",
                    "{C:inactive,E:2}but...{}",
                    "{ppu_bubble:usable}"
                },
                flavour = {
                    "{C:hearts}'kay{}, {C:green}you {C:spades}actually {C:clubs}know {C:red}    {}. {C:diamonds}Great{}"
                }
            },
            fish_fac_great = {
                name = "Great White",
                text = {
                    "{X:blind,C:white}Mean`````Fellow:",
                    "Halves Blind",
                    "Requirement",
                    "{C:inactive,E:2}but...{}",
                    "{ppu_bubble:usable}"
                },
                flavour = {
                    "{C:hearts}'kay{}, {C:green}you {C:spades}actually {C:clubs}know {C:red}jack{}. {C:diamonds}     {}"
                }
            },
        },
        Other = {
            w_d_seuss_dismantle = {
                name = "Dismantle",
                text = {
                    "Destroy a random Fish",
                    "and add {C:attention}double{} its",
                    "sell value to this {C:mult}Mult{}",
                },
            },
            w_d_seuss_cleave = {
                name = "Cleave",
                text = {
                    "Destroy selected card",
                    "and add {C:attention}triple{} its rank",
                    "value to this {C:chips}Chips{}",
                },
            },
            w_d_seuss_amplified = {
                name = "Amplified",
                text = {
                    "Total {C:dark_edition}Negative{} playing",
                    "cards / {C:attention}Full deck{} =",
                    "{C:green}Fixed #1#% chance{}"
                },
            },
            w_d_seuss_reversal = {
                name = "Reversal",
                text = {
                    "Total {C:dark_edition}Polychrome{} playing",
                    "cards / {C:attention}Full deck{} =",
                    "{C:green}Fixed #1#% chance{}"
                },
            },
        },
    },
    misc = {
        dictionary = {
            k_omw = "I'm on my way!",
            k_lost = "I'm lost :(",
            k_dismantle = "Dismantle",
            k_cleave = "Cleave",
            k_amplified = "Amplified",
            k_reversal = "Reversal",
            k_bigtrout = "[[BIG TROUT]]",
            k_hokimama = "[HOKI MAMA]",
            k_miss = "Miss",
            k_correct_ex = "Correct!",
            k_failure_ex = "Failure!",
        },
        achievement_names = {
        },
        achievement_descriptions = {
        },
        quips = {
        },
        v_dictionary = {
        },
        tutorial = {
        },
    }
}
