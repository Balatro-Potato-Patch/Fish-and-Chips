SMODS.Atlas({
	key = "crimsonseraphim_credits",
	path = "crimsonseraphim/credits.png",
	px = 71,
	py = 95,
})

SMODS.Atlas {
    key = "crimsonseraphim_aeonfish",
    path = "crimsonseraphim/aeonfish.png",
    px = 71,
    py = 95
}

SMODS.Atlas {
    key = "crimsonseraphim_drawstep_faces",
    path = "crimsonseraphim/drawstep_faces.png",
    px = 71,
    py = 95
}

SMODS.Atlas({
	key = "mealy_lore",
	path = "crimsonseraphim/mealy_lore.png",
	px = 1125,
	py = 1086,
})

SMODS.Atlas({
	key = "omega_crimsonfang_lore_alexi",
	path = "crimsonseraphim/omega_crimsonfang_lore_alexi.png",
	px = 438,
	py = 75,
})

SMODS.Atlas({
	key = "omega_crimsonfang_lore_mf",
	path = "crimsonseraphim/jollydogs.png",
    px = 204,
	py = 66,
})

SMODS.Atlas({
	key = "omega_crimsonfang_lore_iq",
	path = "crimsonseraphim/aniqtoofish.png",
	px = 374,
	py = 233,
})

SMODS.Atlas({
	key = "crimsonseraphim_fish_seals",
	path = "crimsonseraphim/fish_seals.png",
	px = 71,
	py = 95,
})

SMODS.Atlas({
	key = "crimsonseraphim_door",
	path = "crimsonseraphim/door.png",
	px = 71,
	py = 95,
})

SMODS.Atlas({
	key = "crimsonseraphim_ultimate_weapon",
	path = "crimsonseraphim/ultimate_weapon.png",
	px = 104,
	py = 70,
    atlas_table = "ANIMATION_ATLAS",
    fps = 10,
    frames = 8
})

SMODS.Atlas({
	key = "crimsonseraphim_picayune",
	path = "crimsonseraphim/CursedFishA.png",
	px = 71,
	py = 95,
    atlas_table = "ANIMATION_ATLAS",
    fps = 10,
    frames = 10
})

SMODS.Atlas({
	key = "crimsonseraphim_temporary",
	path = "crimsonseraphim/temporary.png",
	px = 71,
	py = 95,
})

SMODS.Atlas({
	key = "crimsonseraphim_lotus_default",
	path = "crimsonseraphim/lotuses/base.png",
	px = 71,
	py = 95,
    atlas_table = "ANIMATION_ATLAS",
    fps = 10,
    frames = 8
})

SMODS.DrawStep({
	key = "crimsonseraphim_aeonfish",
	order = 25,
	func = function(self)
        local card = self.config.center_key
        if (card ~= "fish_fac_crimsonseraphim_aeonfish" and card ~= "fish_fac_crimsonseraphim_gungir")  then return end
        if card == "fish_fac_crimsonseraphim_gungir" and not self.ability.extra.charged then return end
        if self.children.center.aeonfish_transmute then return end
        self.children.center:draw_shader('fac_aeonfish_caustics', nil, self.ARGS.send_to_shader)
	end,
	conditions = { vortex = false, facing = "front" },
})

SMODS.DrawStep({
	key = "aeonfish_transmute",
	order = 25,
	func = function(self)
        if not self.children.center.aeonfish_transmute then return end  
        self.shadow_height = ((((self.highlighted and self.area == G.play) or self.states.drag.is) and 0.35) or (self.area and self.area.config.type == 'title_2') and 0.04 or 0.1)
        local sprite = self.children.center.aeonfish_transmute.image
        sprite.role.draw_major = self
        sprite.aeonfish_transmute = {
            realtime_start = self.children.center.aeonfish_transmute.realtime_start,
            reverse = true
        }
        self.children.center:draw_shader('fac_aeonfish_transmute', nil, self.ARGS.send_to_shader)
        sprite:draw_shader('fac_aeonfish_transmute', nil, self.ARGS.send_to_shader, nil, self.children.center)
	end,
	conditions = { vortex = false, facing = "front" },
})

SMODS.DrawStep {
    key = 'fish_seal',
    order = 30,
    func = function(self, layer)
        local fish_seals = FishAndChips.crimsonseraphim.fish_seals
        local seal = fish_seals[self.fish_seal] and fish_seals[self.fish_seal] or G.P_SEALS[self.fish_seal] or {}
        if self.ability.delay_seal then return end
        if type(seal.draw) == 'function' then
            (seal.draw):draw(self, layer)
        elseif self.fish_seal then
            G.shared_seals["fish_"..self.fish_seal] = G.shared_seals["fish_"..self.fish_seal] or SMODS.create_sprite(0, 0, 2, 2, seal.atlas, seal.pos)
            G.shared_seals["fish_"..self.fish_seal].role.draw_major = self
            G.shared_seals["fish_"..self.fish_seal]:draw_shader('dissolve', nil, nil, nil, self.children.center)
            if self.fish_seal == 'Gold' then G.shared_seals["fish_"..self.fish_seal]:draw_shader('voucher', nil, self.ARGS.send_to_shader, nil, self.children.center) end
        end
    end,
    conditions = { vortex = false, facing = 'front' },
}

SMODS.draw_ignore_keys.bucket_front = true
SMODS.DrawStep({
	key = "bucket",
	order = 25,
	func = function(self)
        local card = self.config.center_key
        if (card ~= "fish_fac_crimsonseraphim_another_bucket")  then return end
        local shader = self.edition and G.P_CENTERS[self.edition.key].shader or "dissolve"
        self.children.center:set_sprite_pos({x=2,y=1})
        FishAndChips.crimsonseraphim.draw_sprite(self.children.center, self)
        if self.ability.saved_card then
            self.ability.saved_card.card.T = copy_table(self.T)
            self.ability.saved_card.card.VT = copy_table(self.VT)
            self.ability.saved_card.card.children.center:draw_shader('dissolve', nil, nil)  
            for _, k in ipairs(SMODS.DrawStep.obj_buffer) do
                if SMODS.DrawSteps[k]:check_conditions(self.ability.saved_card.card, 'both') then SMODS.DrawSteps[k].func(self.ability.saved_card.card, layer) end
            end
        end

        self.children.center:set_sprite_pos({x=1,y=1})
        FishAndChips.crimsonseraphim.draw_sprite(self.children.center, self)
	end,
	conditions = { vortex = false, facing = "front" },
})

SMODS.DrawStep({
	key = "ultimate_weapon",
	order = 25,
	func = function(self)
        local card = self.config.center_key
        if (card ~= "fish_fac_crimsonseraphim_ultimate_weapon")  then return end
        FishAndChips.crimsonseraphim.draw_sprite(self.children.center, self)
        self.children.center:draw_shader('fac_crimsonseraphim_ultimate_weapon', nil, self.ARGS.send_to_shader)
	end,
	conditions = { vortex = false, facing = "front" },
})

SMODS.draw_ignore_keys.crimsonseraphim_vanitas_censor = true
SMODS.DrawStep({
	key = "crimsonseraphim_vanitas",
	order = 9e10,
	func = function(self)
        local card = self.config.center_key
        if (card ~= "fish_fac_crimsonseraphim_vanitas") or not G.P_CENTERS[card].discovered or not G.P_CENTERS[card].unlocked then return end
        if not self.children.crimsonseraphim_vanitas_censor then 
            self.children.crimsonseraphim_vanitas_censor = SMODS.create_sprite(0, 0, self.T.w, self.T.h, "fac_crimsonseraphim_aeonfish", {x = 3, y = 1})
        end
        local sprite = self.children.crimsonseraphim_vanitas_censor
        sprite.T.w = self.T.w
        sprite.T.h = self.T.h
        sprite.VT.x = math.floor(self.children.center.VT.x*3.5)/3.5
        sprite.VT.y = math.floor(self.children.center.VT.y*3.5)/3.5
        sprite.VT.r = 0
        sprite:draw_shader("dissolve", nil, nil, true, nil, nil, 0)
	end,
	conditions = { vortex = false, facing = "front" },
})

SMODS.draw_ignore_keys.omega_crimsonfang_tv_face = true
SMODS.DrawStep({
	key = "omega_crimsonfang",
	order = 25,
	func = function(self)
        if self.config.center.discovered and self.config.center.key == "fish_fac_omega_crimsonfang" then
            local fish_data = G.PROFILES[G.SETTINGS.profile].fac_fishing.fish_data[self.config.center_key] or {}
            if not (fish_data.times_caught and fish_data.times_caught > 0) and self.area and self.area.config.fac_compendium then return end
            self.children.omega_crimsonfang_tv_face = self.children.omega_crimsonfang_tv_face or SMODS.create_sprite(0, 0, G.CARD_W, G.CARD_H, "fac_crimsonseraphim_drawstep_faces", {x=0,y=0})
            self.children.omega_crimsonfang_tv_face.role.draw_major = self
            if self.area == G.fac_fish_area then
                if self.ability.face then
                    self.ability.temp_face = self.ability.face
                    self.ability.face = nil
                    self.ability.face_dt = 0
                end
                if self.ability.face_dt then
                    self.ability.face_dt = self.ability.face_dt + love.timer.getDelta()
                end
                if self.ability.temp_face and self.ability.face_dt > 0.05 then
                    self.ability.face_dt = 0
                    self.ability.static_face = (self.ability.static_face or 0) + 1
                    if self.ability.static_face > 3 then
                    self.ability.static_face = nil 
                    self.ability.face_dt = nil
                    self.ability.true_face = self.ability.temp_face
                    self.ability.temp_face = nil
                    self.ability.static_face = nil
                    self.children.omega_crimsonfang_tv_face:set_sprite_pos({x=self.ability.true_face, y=0})
                    self.ability.change_dt = math.random() * 3
                    else
                        self.children.omega_crimsonfang_tv_face:set_sprite_pos({x=self.ability.static_face, y=0})
                    end
                end
                self.ability.change_dt = self.ability.change_dt or 1
                self.ability.change_dt = self.ability.change_dt - love.timer.getDelta()
                if self.ability.change_dt < 0 then
                    self.ability.change_dt = 99999
                    local e = {0}
                    for i = 4, 13 do
                        e[#e+1] = i
                    end
                    self.ability.face = pseudorandom_element(e)
                end
            end
            FishAndChips.crimsonseraphim.draw_sprite(self.children.omega_crimsonfang_tv_face, self, {
                nil, nil, nil, self.children.center
            })
            FishAndChips.crimsonseraphim.draw_sprite(self.children.center, self)
        end
	end,
	conditions = { vortex = false, facing = "front" },
})

SMODS.DynaTextEffect {
    key = "nameless",
    func = function (dynatext, index, letter)
        if not FishAndChips.mod.config.performance_mode then
            letter.dt = (letter.dt or 0) + G.TIMERS.REAL - (letter.timer or G.TIMERS.REAL)
            if letter.dt2 then
                letter.dt2 = letter.dt2 + G.TIMERS.REAL - (letter.timer or G.TIMERS.REAL)
            end
            letter.timer_offset = letter.timer_offset or (math.random() + 0.1)
            letter.orig_char = letter.orig_char or letter.char
            if (not letter.dt2 or letter.dt2 > 0.075) and not letter.done_char then
                letter.letter:release()
                if letter.dt < letter.timer_offset and letter.orig_char ~= " " then
                    letter.letter = love.graphics.newText(dynatext.font.FONT, string.char(math.fmod((string.byte(letter.char) + math.fmod(math.floor(G.TIMERS.REAL * 142.1 + index), 192)), 94)+ 33))
                else
                    letter.letter = love.graphics.newText(dynatext.font.FONT, letter.char)
                    letter.done_char = true
                end
                letter.dt2 = 0
            end
            letter.timer = G.TIMERS.REAL
        end
    end
}

SMODS.DynaTextEffect{
    key = "crimsonseraphim_dev",
    draw_letter = function(self, k, letter)
        love.graphics.setColor(k <= 4 and G.C.RED or k >= 8 and G.C.GREEN or G.C.WHITE)
        FishAndChips.crimsonseraphim.draw_letter(letter, self)
    end
}

for i, v in pairs(FishAndChips.crimsonseraphim.click_sounds) do
    SMODS.Sound {
        key = "crimsonseraphim_"..v,
        path = "crimsonseraphim/click/"..v..".ogg",
        volume = 2
    }
end

SMODS.Sound {
    key = "crimsonseraphim_shimmer",
    path = "crimsonseraphim/shimmer.ogg"
}

SMODS.Sound {
    key = "crimsonseraphim_forge",
    path = "crimsonseraphim/forge.ogg"
}

SMODS.Sound {
    key = "crimsonseraphim_gungir_break",
    path = "crimsonseraphim/gungir_break.ogg"
}
SMODS.Sound {
    key = "crimsonseraphim_gungir_charge",
    path = "crimsonseraphim/gungir_charge.ogg"
}
SMODS.Sound {
    key = "crimsonseraphim_gungir_success",
    path = "crimsonseraphim/gungir_success.ogg"
}
SMODS.Sound {
    key = "crimsonseraphim_gungir_decharge",
    path = "crimsonseraphim/gungir_decharge.ogg"
}

SMODS.Sound {
    key = "crimsonseraphim_revolver_spin",
    path = "crimsonseraphim/revolver_spin.ogg"
}

SMODS.Sound {
    key = "crimsonseraphim_revolver_empty",
    path = "crimsonseraphim/revolver_empty.ogg"
}

for i = 1, 8 do
    SMODS.Sound {
    key = "crimsonseraphim_revolver_shots_"..i,
    path = "crimsonseraphim/revolver_shots_"..i..".ogg"
}
end

SMODS.Sound {
    key = "crimsonseraphim_sulfur_slash",
    path = "crimsonseraphim/falx_sulphurata_slash.ogg"
}

SMODS.Sound {
    key = "crimsonseraphim_bounce",
    path = "crimsonseraphim/bounce.ogg"
}

local data = NFS.newFileData(FishAndChips.mod.path .."/assets/1x/crimsonseraphim/caustics-texture.png")
local _caustics = love.graphics.newImage(data)
SMODS.Shader({
    key="aeonfish_caustics",
    path="crimsonseraphim/aeonfish_caustics.fs",
    send_vars = function (sprite, card)
        return {
            realtime = G.TIMERS.REAL,
            caustic_image = _caustics
        }
    end,
})

SMODS.Shader({
    key="aeonfish_transmute",
    path="crimsonseraphim/aeonfish_transmute.fs",
    send_vars = function (sprite, card)
        return {
            realtime_offset = G.TIMERS.REAL - sprite.aeonfish_transmute.realtime_start,
            reverse = not sprite.aeonfish_transmute.image,
        }
    end,
})

SMODS.Shader({
    key="crimsonseraphim_starblighted",
    path="crimsonseraphim/starblighted.fs",
})

SMODS.Shader({
    key="crimsonseraphim_ultimate_weapon",
    path="crimsonseraphim/ultimate_weapon.fs",
})

SMODS.Shader({key = 'crimsonseraphim_afterimage', path = 'crimsonseraphim/afterimage.fs', send_vars = function(s) return {alpha = G.afterimage_alpha or 1} end})

local data = SMODS.NFS.newFileData(FishAndChips.mod.path .."/assets/1x/crimsonseraphim/jade.png")
local _jade = love.graphics.newImage(data)
SMODS.ScreenShader({
    key="jadeflashbang",
    path="crimsonseraphim/jadeflashbang.fs",
    send_vars = function (sprite, card)
        return {
            evilassjade = _jade,
            dist = G.TIMERS.REAL - FishAndChips.crimsonseraphim.jade_flashbang,
            scale = G.TILESCALE,
            center_pos = {1/2,1/2}
        }
    end,
    should_apply = function()
        return FishAndChips.crimsonseraphim.jade_flashbang
    end
})

SMODS.ScreenShader {
    key = "flashlight",
    path = "crimsonseraphim/flashlight.fs",
    send_vars = function(self)
        return {
            center_pos = { love.mouse.getX(), love.mouse.getY() },
            dist = 350,
        }
    end,
    should_apply = function(self)
        return next(SMODS.find_card("fish_fac_crimsonseraphim_jack_o_lantern"))
    end,
}

SMODS.ScreenShader {
    key = "godrays",
    path = "crimsonseraphim/godrays.fs",
    send_vars = function(self)
        return {
            realtime = G.TIMERS.REAL
        }
    end,
    should_apply = function(self)
        return next(SMODS.find_card("fish_fac_crimsonseraphim_nameless_lotus")) and not FishAndChips.mod.config.performance_mode
    end,
}

FishAndChips.crimsonseraphim.words = {
    determiners = {
        "all", "another", "any", "both", "every", "few", "former", "half", "least", "many", "own"
    },
    adjectives = {
        "able", "alone", "available", "bad", "beautiful", "big", "black", "certain", "clear", "common", "complete", "current", "different", "difficult", "direct", "due", "each", "early", "easy", "economic", "either", "else", "fast", "final", "financial", "fine", "firm", "fit", "foreign", "free", "full", "general", "good", "great", "happy", "hard", "high", "human", "important", "individual", "international", "kind", "large", "late", "likely", "little", "local", "long", "low", "main", "major", "military", "national", "necessary", "new", "nice", "official", "old", "open", "other", "particular", "patient", "personal", "political", "poor", "popular", "possible", "present", "private", "public", "ready", "real", "recent", "red", "right", "round", "same", "serious", "several", "short", "significant", "similar", "simple", "single", "small", "social", "some", "sorry", "special", "specific", "standard", "strong", "such", "sure", "that", "this", "total", "true", "various", "white", "whole", "wide", "wrong", "young"
    },
    nouns = {
        "ability", "accord", "account", "act", "action", "activity", "addition", "address", "advantage", "age", "agreement", "aim", "air", "amount", "analysis", "animal", "answer", "approach", "area", "arm", "art", "article", "attack", "attention", "average", "back", "bank", "base", "bed", "behavior", "benefit", "bit", "board", "body", "book", "boy", "business", "campaign", "capital", "car", "card", "care", "case", "cause", "cell", "cent", "center", "century", "city", "claim", "class", "club", "college", "color", "community", "company", "computer", "concern", "condition", "contact", "contract", "cost", "country", "couple", "course", "court", "culture", "customer", "data", "date", "day", "death", "decision", "degree", "demand", "department", "detail", "development", "difference", "director", "discussion", "doctor", "door", "drug", "economy", "education", "effect", "effort", "election", "employee", "end", "environment", "evening", "event", "evidence", "example", "experience", "eye", "face", "fact", "factor", "family", "father", "fear", "feature", "field", "figure", "film", "fire", "floor", "focus", "food", "foot", "form", "friend", "front", "function", "fund", "future", "game", "girl", "government", "ground", "group", "growth", "guy", "hand", "head", "health", "heart", "history", "holiday", "home", "hope", "hospital", "hotel", "hour", "house", "chance", "character", "child", "choice", "church", "idea", "image", "industry", "influence", "information", "interest", "interview", "issue", "item", "job", "key", "kid", "knowledge", "land", "language", "law", "leader", "letter", "level", "life", "light", "limit", "line", "link", "list", "lot", "love", "machine", "man", "management", "manager", "market", "material", "matter", "medium", "member", "method", "mile", "mind", "minute", "model", "moment", "money", "month", "morning", "mother", "movie", "music", "name", "nation", "nature", "news", "night", "note", "notice", "number", "office", "one", "opinion", "opportunity", "order", "organization", "outside", "page", "paint", "paper", "parent", "park", "part", "party", "pause", "people", "percent", "performance", "period", "person", "phone", "picture", "piece", "place", "plan", "plant", "player", "point", "police", "policy", "population", "position", "power", "practice", "president", "press", "price", "problem", "process", "product", "production", "program", "project", "purpose", "quality", "question", "race", "range", "rate", "reason", "record", "region", "relationship", "report", "research", "respect", "response", "rest", "result", "review", "risk", "road", "role", "room", "rule", "sale", "season", "section", "security", "sense", "series", "service", "shop", "school", "side", "sign", "site", "situation", "size", "skill", "society", "solution", "son", "sort", "sound", "source", "space", "sport", "staff", "stage", "state", "statement", "station", "stock", "store", "story", "street", "structure", "student", "stuff", "subject", "success", "summer", "surprise", "system", "table", "target", "tax", "teacher", "team", "technology", "television", "term", "test", "thing", "time", "today", "tomorrow", "top", "town", "trade", "train", "tree", "type", "unit", "value", "view", "voice", "wall", "war", "water", "way", "week", "wife", "window", "woman", "wonder", "word", "worker", "world", "year", "yesterday"
    },
    verbs = {
        "accept", "add", "affect", "agree", "achieve", "allow", "appear", "apply", "argue", "arrive", "ask", "attempt", "be", "bear", "become", "begin", "believe", "break", "bring", "build", "buy", "call", "can", "carry", "catch", "close", "come", "comment", "compare", "consider", "contain", "continue", "control", "could", "cover", "create", "cut", "deal", "decide", "depend", "describe", "design", "determine", "develop", "die", "discuss", "do", "draw", "drink", "drive", "drop", "eat", "enjoy", "enter", "establish", "exist", "expect", "explain", "fail", "fall", "feel", "fight", "find", "finish", "follow", "force", "forget", "gain", "get", "give", "go", "grow", "happen", "have", "hear", "help", "hit", "hold", "challenge", "change", "charge", "check", "choose", "improve", "include", "increase", "introduce", "involve", "join", "keep", "kill", "know", "lack", "laugh", "lead", "learn", "leave", "let", "lie", "like", "listen", "live", "look", "lose", "make", "manage", "mark", "marry", "may", "mean", "measure", "meet", "mention", "might", "miss", "move", "must", "need", "occur", "offer", "pass", "pay", "pick", "play", "prepare", "produce", "prove", "provide", "pull", "put", "raise", "read", "reach", "realize", "receive", "recognize", "reduce", "regard", "relate", "release", "remain", "remember", "represent", "require", "return", "rise", "run", "save", "say", "see", "seek", "seem", "sell", "send", "serve", "set", "share", "should", "show", "sit", "speak", "spend", "stand", "start", "stay", "step", "stop", "strike", "study", "suggest", "support", "suppose", "take", "talk", "teach", "tell", "thank", "think", "travel", "try", "turn", "understand", "use", "visit", "vote", "wait", "walk", "want", "watch", "wear", "will", "win", "wish", "work", "worry", "would", "write"
    },
    prepositions = {
        "about", "above", "across", "after", "against", "along", "among", "around", "at", "before", "behind", "below", "between", "by", "despite", "during", "for", "from", "in", "inside", "into", "near", "of", "on", "over", "past", "per", "through", "to", "toward", "under", "upon", "with", "within", "without"
    }
}
--[Determiner] [Adjective] [Noun] [Verb] [Preposition] [Determiner] [Adjective] [Noun].

function FishAndChips.crimsonseraphim.get_word_cycle(type)
    if FishAndChips.mod.config.performance_mode then
        return pseudorandom_element(FishAndChips.crimsonseraphim.words[type])
    end
    return DynaText({ string = FishAndChips.crimsonseraphim.words[type], colours = { G.C.JOKER_GREY }, pop_in_rate = 9999999, silent = true, random_element = true, pop_delay = 0.5, scale = 0.32, min_cycle_time = 0 })
end

SMODS.Sound {
    key = "music_crimsonseraphim_edenic_whispers",
    path = "crimsonseraphim/edenic_whispers.ogg",
    select_music_track = function()
        return next(SMODS.find_card("fish_fac_crimsonseraphim_nameless_lotus")) and 1e307
    end
}

SMODS.Sound {
    key = "music_crimsonseraphim_omega_death",
    path = "crimsonseraphim/music_omega_crimsonfang_death.ogg",
    select_music_track = function()
        return G.GAME.omega_fake_death
    end
}

SMODS.Sound {
	key = "crimsonseraphim_swoon",
	path = "crimsonseraphim/swoon.ogg",
	pitch = 1,
}

SMODS.Font {
    path = "determination.ttf",
    key = "determination"
}

SMODS.Sound {
	key = "crimsonseraphim_flowey1",
	path = "crimsonseraphim/snd_floweytalk1.ogg",
	pitch = 1,
}
SMODS.Sound {
	key = "crimsonseraphim_flowey2",
	path = "crimsonseraphim/snd_floweytalk2.ogg",
	pitch = 1,
}
SMODS.Sound {
	key = "crimsonseraphim_spacejumpscare",
	path = "crimsonseraphim/spacejumpscare.ogg",
	pitch = 1,
}