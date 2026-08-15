return {
    descriptions = {
        fac_Fish = {
            fish_fac_sagatail_catfish = {
                name = "Cat-Fish",
                text = {
                    "{C:attention}Retrigger{} all cards played",
                    "this round if a {C:attention}Perfect catch{}",
                    "is done on previously caught fish",
                    "{ppu_bubble:1}",
                },
                flavor = {
                    "Hey, look! This is",
                    "a ca- I mean fish!",
                },
            },
            fish_fac_sagatail_gold_catfish = {
                name = "Gold Cat-Fish",
                text = {
                    "{C:mult}+#1#{} Mult for every",
                    "{C:fac_sand_dollars,f:fac_sand_dollars}${C:fac_sand_dollars}#2#{} you have",
                    "{C:inactive}(Currently {C:mult}+#3#{C:inactive} Mult)",
                },
                flavor = {
                    "This ca- I mean fish loves to",
                    "pull itself up the bootstrap.",
                    "Heh, get it?",
                },
            },
            fish_fac_sagatail_koi_cat = {
                name = "KOI Cat",
                text = {
                    "{X:mult,C:white}X#1#{} Mult if scoring hand",
                    "contains at least {C:attention}2{} suits",
                },
                flavor = {
                    "Look at those spots.",
                    "Surely our ca- I mean fish",
                    "can't be this beautiful, right?",
                },
            },
            fish_fac_sagatail_fishcat = {
                name = "Fish-Cat",
                text = {
                    "Gain {C:fac_sand_dollars,f:fac_sand_dollars}${C:fac_sand_dollars}#1#{} of {C:attention}sell value{} if played hand",
                    "raises the {C:attention}highest chain{} of",
                    "consecutive {C:attention}#2#s{} played",
                    "{V:1}#3#/{V:2}#4#",
                },
                flavor = {
                    "Hey, look! This is a fi-",
                    "I mean ca- I mean fish!",
                },
            },
            fish_fac_sagatail_lava_catfish = {
                name = "Lava Cat-Fish",
                text = {
                    "{X:mult,C:white}X#1#{} Mult",
                    "{C:attention}destroy{} a random",
                    "played card every hand",
                },
                flavor = {
                    "Careful! Do not pick this ca-",
                    "I mean fish up with bare hands.",
                },
            },
            fish_fac_sagatail_seraphish = {
                name = "Seraphish",
                text = {
                    "{X:mult,C:white}X#1#{} Mult if at least",
                    "{C:attention}#3# {C:inactive}[#2#] {C:tarot}Tarot{} cards",
                    "are used this Ante",
                },
                flavor = {
                    "Legends say this fish entered",
                    "the mortal realm by cosmic water.",
                },
            },
            fish_fac_sagatail_plastic_chair = {
                name = "Plastic Chair",
                text = {
                    {"{C:green}#1# in #2#{} chance of",
                    "not consuming {C:attention}bait{}",
                    "when caught"},
                    {"{C:green}Guaranteed{} if caught",
                    "with {C:attention}treasure"},
                },
                flavor = {
                    "I AM THE STORM",
                    "THAT IS APPROACHING",
                },
            },
            fish_fac_sagatail_vintage_cellphone = {
                name = "Vintage Cellphone",
                text = {
                    "{C:attention}Retrigger{} all {C:attention}numbered",
                    "{C:attention}cards{} for the next",
                    "{C:attention}#1#{} rounds",
                },
                flavor = {
                    "This old phone can survive",
                    "harsh conditions and still",
                    "be usable for years to come.",
                },
            },
            fish_fac_sagatail_sunfish = {
                name = "Sun-Fish",
                text = {
                    {"{V:3}[{B:1}  {B:2}  {B:3}  {V:3}]{ppu_bubble:usable}{ppu_bubble:1}",
                    "Use this fish to consume {C:attention}3{} charges",
                    "and enable the {C:attention}following effects{} this round",
                    "Gain {C:attention}1{} charge at end of round"},
                    {"All played cards {C:attention}score{}, give {X:mult,C:white}X#1#{} Mult",
                    "when scored and {C:attention}destroyed{} after scoring"},
                },
                flavor = {
                    "Feel the scorching heat of a pocket sun.",
                },
            },
            fish_fac_sagatail_moonfish = {
                name = "Moon-Fish",
                text = {
                    "When a {C:attention}Stone Card{} is drawn,",
                    "draw {C:attention}1{} extra card",
                },
                flavor = {
                    "Moon rocks are the same",
                    "as Earth rocks, really.",
                }
            },
            fish_fac_sagatail_jelly_catfish = {
                name = "Jelly Cat-Fish",
                text = {
                    {"If played hand contains a {C:attention}Flush{},",
                    "gives effects based on {C:attention}suits{} that",
                    "form a valid {C:attention}Flush{}"},
                    {"{C:hearts}Hearts{}: {X:mult,C:white}X#1#{} Mult; {C:diamonds}Diamonds{}: {C:fac_sand_dollars,f:fac_sand_dollars}${C:fac_sand_dollars}#2#{}",
                    "{C:clubs}Clubs{}: {C:mult}+#3#{} Mult; {C:spades}Spades{}: {C:chips}+#4#{} Chips"},
                },
                flavor = {
                    "Wear a glove before petting",
                    "this ca- I mean fish, please.",
                }
            },
            fish_fac_sagatail_michael_fishson = {
                name = "Michael Fishson",
                text = {
                    "If played hand only contains",
                    "{C:attention}1{} card, retrigger played",
                    "{C:attention}King{} of {C:clubs}Clubs {C:attention}#1#{} times",
                },
                flavor = {
                    "HEE HEE",
                },
            },
            fish_fac_sagatail_paper_crane = {
                name = "Paper Crane",
                text = {
                    {"Played cards give",
                    "{C:mult}+#1#{} Mult when scored"},
                    {"{C:attention}Permanently{} upgrade",
                    "to {X:mult,C:white}X#2#{} Mult after",
                    "{C:attention}1000 {C:inactive}[#3#]{} triggers"},
                },
                flavor = {
                    "How did it stay dry",
                    "the entire time?",
                },
            },
            fish_fac_sagatail_fisher_fish = {
                name = "Fisher Fish",
                text = {
                    "Once per {C:attention}Ante{}, sell another fish",
                    "to {C:attention}create{} a random {C:fac_fish}Fish{} from",
                    "any {C:attention}environment",
                    "{C:inactive}(Must have room)",
                    "{ppu_bubble:1}",
                },
                flavor = {
                    "Ever heard of a fish",
                    "holding a rod?",
                },
            },
            fish_fac_sagatail_starryfish = {
                name = "The Starry Fish",
                text = {
                    "Draw extra cards {C:attention}equal{} to",
                    "number of {C:attention}unscored{} cards",
                    "every hand",
                },
                flavor = {
                    "Fish can be shiny and",
                    "not shiny at once.",
                },
            },
        },
        PotatoPatch = {
            PotatoPatchDev_HuyTheKiller = {
                name = "HuyTheKiller",
                text = {
                    {"First-time participant, developer",
                    "of Sagatro and Silk Touch."},
                    {"Meow- I mean Blub!"},
                },
            },
            PotatoPatchDev_HuyCorn = {
                name = "HuyCorn",
                text = {
                    "First-time participant,",
                    "artist for Sagatro.",
                },
            },
        },
    },
    misc = {
        dictionary = {
            k_inactive = "inactive",
            k_broken_ex = "Broken!",
            k_hee_hee_ex = "HEE HEE!",
            ph_thats_mine = "That's mine!",
        },
    },
}
