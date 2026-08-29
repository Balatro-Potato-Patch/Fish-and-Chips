extern float fip;
extern float expand;
extern float mixf;

vec4 effect( vec4 colour, Image texture, vec2 uv, vec2 screen_coords )
{
	vec4 col = Texel(texture, vec2(uv.x, uv.y + (sin((uv.x + (mixf * -0.3)) * 16.0) * fip * 0.1)));
	vec4 col2 = Texel(texture, vec2(uv.x, (uv.y + (sin((uv.x + (mixf * 0.1)) * 64.0) * fip))));
	float fmid = -(uv.x - 0.5) * expand;
	vec4 col3 = Texel(texture, vec2(uv.x + fmid, uv.y));

	// Output to screen
	return mix(col, (col + col2 + col3) / vec4(3.0, 2.9, 1.0, 0.0), mixf);
}