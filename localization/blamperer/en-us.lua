return {
    descriptions = {
        fac_Fish = {
            fish_fac_blamperer_kala = {
                name = "kala",
                text = {
                    "This Fish gives {X:mult,C:white}X#1#{} Mult for each",
                    "empty {C:attention}Fish{} slot in your Bucket",
                    "{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive} Mult)"
                },
                flavor = {
                    "tenpo la, lili li pona"
                }
            },
            fish_fac_blamperer_perfish = {
                name = "Perfish",
                text = {
                    "Earn {C:money}$#1#{} when returning",
                    "from fishing based on your",
                    "best streak of {C:gold}Perfect Catches",
                    "{C:inactive}(Highest streak: {C:gold}#2#{C:inactive} in a row)"
                },
                flavor = {
                    "This Fish only rewards those",
                    "who can perform with",
                    "neither err or hesitation.",
                    "Go for a Perfish!"
                }
            },
            fish_fac_blamperer_timer = {
                name = "Delayed Gratipiscation",
                text = { 
                    "Earn {C:fac_sand_dollars,f:fac_sand_dollars}${C:fac_sand_dollars}#1#{} for every {C:attention}5 seconds",
                    "you have a fish on your hook",
                    "{C:inactive}(Maximum of {C:fac_sand_dollars,f:fac_sand_dollars}${C:fac_sand_dollars}#3#{C:inactive})"
                },
                flavor = {
                    "Why speed through the moment?",
                    "Sit back and savor the time you spend."
                }
            }
        },
        PotatoPatch = {
            PotatoPatchDev_blamperer = {
                name = "blamperer",
                text = {
                    "I also made a mod called",
                    "{C:chips}The Latro{}, if you want to",
                    "try that as well.",
                    "{s:0.8}(Click me to check that out!)"
                }
            },
        }
    },
    misc = {
        dictionary = {
            k_fac_blamperer_str_broke = "Streak Broken!"
        },
        v_dictionary = {
            a_fac_blamperer_str_gain = "#1#X Streak!"
        }
    }
}
