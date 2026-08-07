FishAndChips.thunder_and_aiko.drawables = {}
FishAndChips.thunder_and_aiko.drawable_cache = {}
FishAndChips.thunder_and_aiko.Animations = {}

function FishAndChips.thunder_and_aiko.clamp(n, min, max)
	local lower = min or 0
	local higher = max or 1
	if lower > higher then
		error("min cannot be higher than max")
	end
	if n < lower then
		return lower
	elseif n > higher then
		return higher
	else
		return n
	end
end

FishAndChips.thunder_and_aiko.init_animation = function(t)
    local full_key = SMODS.current_mod.prefix .. "_" .. t.key
	local file_data =
		assert(SMODS.NFS.newFileData(FishAndChips.mod.path .. "assets/thunder_and_aiko_misc_stuff/" .. t.path), "Failed to get file data")
	local image_data = assert(love.image.newImageData(file_data), "Failed to convert to image data")
	local love_image = assert(love.graphics.newImage(image_data), "Failed to create an image")
	local anim_data = {
		frames = t.frames,
		image = love_image,
		is_continuous = t.is_continuous or false,
		x_scale = t.x_scale or 1,
		y_scale = t.y_scale or 1,
		rotation = t.rotation or 0,
		px = t.px,
		py = t.py,
		duration = t.duration,
		frame_data = {},
		no_stretch = t.no_stretch,
		anchor = t.anchor,
	}
	for i = 1, t.frames do
		local x, y = (i - 1) % (t.columns or i), (t.columns and math.floor((i - 1) / t.columns) or 0)
		anim_data.frame_data[#anim_data.frame_data + 1] =
			love.graphics.newQuad(x * t.px, y * t.py, t.px, t.py, love_image)
	end
    FishAndChips.thunder_and_aiko.Animations[full_key] = anim_data
end

function FishAndChips.thunder_and_aiko.handle_other_drawing()
	for _, drawable in ipairs(FishAndChips.thunder_and_aiko.drawables) do
		if not drawable._removed then
			love.graphics.setColor(1, 1, 1, 1)
			if drawable.ref_obj.frame_data then
				love.graphics.draw(
					drawable.drawable,
					drawable.ref_obj.frame_data[FishAndChips.thunder_and_aiko.clamp(
						math.floor(drawable._progress) + 1,
						1,
						drawable.ref_obj.frames
					)],
					FishAndChips.thunder_and_aiko.get_transform(drawable)
				)
			else
				love.graphics.draw(drawable.drawable, FishAndChips.thunder_and_aiko.get_transform(drawable))
			end
		end
	end
end

function FishAndChips.thunder_and_aiko.update_drawables()
	local new_drawables = {}
	for _, drawable in ipairs(FishAndChips.thunder_and_aiko.drawables) do
		drawable:update()
		if not drawable._removed then
			new_drawables[#new_drawables+1] = drawable
		end
	end
	FishAndChips.thunder_and_aiko.drawables = new_drawables
end


function FishAndChips.thunder_and_aiko.get_screen_x_scale()
	return love.graphics.getWidth() / 1536
end

function FishAndChips.thunder_and_aiko.get_screen_y_scale()
	return love.graphics.getHeight() / 864
end

function FishAndChips.thunder_and_aiko.get_screen_scale()
	return FishAndChips.thunder_and_aiko.get_screen_x_scale(), FishAndChips.thunder_and_aiko.get_screen_y_scale()
end

FishAndChips.thunder_and_aiko.x_offsets = {
	l = function(x)
		return x / 2
	end,
	c = function(x)
		return 0
	end,
	r = function(x)
		return -x / 2
	end,
}

FishAndChips.thunder_and_aiko.y_offsets = {
	t = function(x)
		return -x / 2
	end,
	c = function(x)
		return 0
	end,
	b = function(x)
		return x / 2
	end,
}

function FishAndChips.thunder_and_aiko.get_true_coords(moveable)
	local transform = moveable.VT or moveable.T
	local scale = G.TILESIZE * G.TILESCALE
	return {
		(G.ROOM.T.x + transform.x + transform.w * 0.5) * scale,
		(G.ROOM.T.y + transform.y + transform.h * 0.5) * scale,
	}
end

function FishAndChips.thunder_and_aiko.to_balatro_units(x)
	return x / (G.TILESIZE * G.TILESCALE)
end

function FishAndChips.thunder_and_aiko.to_pixels(x)
	return x * (G.TILESIZE * G.TILESCALE)
end

function FishAndChips.thunder_and_aiko.get_transform(drawable)
	local target = drawable.anchor.target
	local temp = target and FishAndChips.thunder_and_aiko.get_true_coords(target)
		or { love.graphics.getWidth() / 2, love.graphics.getHeight() / 2 }
	local x = temp[1]
	local y = temp[2]
	x = x + (drawable.anchor.x_offset or 0)
	y = y + (drawable.anchor.y_offset or 0)
	local x_scale = (drawable.anchor.x_scale or 1)
		* (drawable.ref_obj.no_stretch and 1 or FishAndChips.thunder_and_aiko.get_screen_x_scale())
	local y_scale = (drawable.anchor.y_scale or 1)
		* (drawable.ref_obj.no_stretch and 1 or FishAndChips.thunder_and_aiko.get_screen_y_scale())
	local x_align = drawable.anchor.x_alignment or "c"
	local y_align = drawable.anchor.y_alignment or "c"
	x = x
		+ FishAndChips.thunder_and_aiko.x_offsets[x_align](
			target and FishAndChips.thunder_and_aiko.to_pixels((target.VT or target.T).w) or love.graphics.getWidth()
		)
	y = y
		+ FishAndChips.thunder_and_aiko.y_offsets[y_align](
			target and FishAndChips.thunder_and_aiko.to_pixels((target.VT or target.T).h) or love.graphics.getHeight()
		)
	if drawable.anchor.inner_align then
		x = x - FishAndChips.thunder_and_aiko.x_offsets[x_align](drawable.ref_obj.py * x_scale)
		y = y - FishAndChips.thunder_and_aiko.y_offsets[y_align](drawable.ref_obj.py * y_scale)
	end
	return love.math.newTransform(
		x,
		y,
		drawable.anchor.rotation,
		x_scale,
		y_scale,
		drawable.ref_obj.px / 2,
		drawable.ref_obj.py / 2
	)
end

function FishAndChips.thunder_and_aiko.play_animation(key, args)
	args = args or {}
	FishAndChips.thunder_and_aiko.drawables[#FishAndChips.thunder_and_aiko.drawables + 1] = {
		key = key,
		anchor = SMODS.merge_defaults(args.anchor, FishAndChips.thunder_and_aiko.Animations[key].anchor or {}),
		_progress = 0,
		update = function(self)
			if self.ref_obj.is_continuous then
				self._progress = self._progress + G.real_dt * self.ref_obj.frames / self.ref_obj.duration
				if self._progress >= self.ref_obj.frames then
					self._progress = self._progress - self.ref_obj.frames
				end
			else
				if self._progress < self.ref_obj.frames then
					self._progress = self._progress + G.real_dt * self.ref_obj.frames / self.ref_obj.duration
				else
					self._removed = true
					FishAndChips.thunder_and_aiko.drawable_cache["a_" .. key] = FishAndChips.thunder_and_aiko.drawable_cache["a_" .. key] - 1
				end
			end
		end,
		ref_obj = FishAndChips.thunder_and_aiko.Animations[key],
		drawable = FishAndChips.thunder_and_aiko.Animations[key].image,
	}
	FishAndChips.thunder_and_aiko.drawable_cache["a_" .. key] = (FishAndChips.thunder_and_aiko.drawable_cache["a_" .. key] or 0) + 1
end

FishAndChips.thunder_and_aiko.init_animation({
    key = "reaper_death",
    frames = 80,
    duration = 3,
    path = "reaper.png",
    columns = 5,
    px = 400,
    py = 187,
    anchor = {
		x_scale = 3.84,
		y_scale = 3.84,
	}
})