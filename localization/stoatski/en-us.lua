return {
    descriptions = {
        fac_Fish = {
            fish_fac_otter = {
                name = "Otter",
                text = {
                    {
                        "When {C:attention}Blind{} is selected, {C:attention}eat{}",
                        "rightmost destructible {C:fac_Fish}Fish{}",
                        "and create a {C:spectral}Spectral{} card",
                        "{C:inactive}(Must have room){}"
                    },
                    {
                        "If this Fish would eat",
                        "itself, it {C:attention}runs away{}"
                    }
                },
                flavor = {
                    "A hungry otter that eats Fish",
                    "and generates Spectral cards."
                }
            }
        },
    },
    misc = {
        dictionary = {
            ph_otter_eat = "Chomp!",
            ph_otter_run = "Weaseled away!"
        }
    }
}