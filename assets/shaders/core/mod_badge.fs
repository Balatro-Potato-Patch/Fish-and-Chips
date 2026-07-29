#if defined(VERTEX) || __VERSION__ > 100 || defined(GL_FRAGMENT_PRECISION_HIGH)
    #define MY_HIGHP_OR_MEDIUMP highp
#else
    #define MY_HIGHP_OR_MEDIUMP mediump
#endif

extern MY_HIGHP_OR_MEDIUMP vec2 mod_badge;
extern MY_HIGHP_OR_MEDIUMP vec4 uie_details;
extern MY_HIGHP_OR_MEDIUMP number uie_scale;
extern MY_HIGHP_OR_MEDIUMP number uie_rot;

extern MY_HIGHP_OR_MEDIUMP Image mask;
extern MY_HIGHP_OR_MEDIUMP number cos_neg_theta;
extern MY_HIGHP_OR_MEDIUMP number sin_neg_theta;
extern MY_HIGHP_OR_MEDIUMP number tx;
extern MY_HIGHP_OR_MEDIUMP number ty;

vec4 effect( vec4 colour, Image texture, vec2 texture_coords, vec2 screen_coords ) {
		//transform the coords
    vec2 uv = (screen_coords - uie_details.xy - uie_details.bg / 2);// * 10;

    if (uie_scale < 0.00001) {
        uv.x = uv.x + 0.0001;
    }
    if (uie_rot < 0.00001) {
				uv.x = uv.x + 0.0001;
    }

		if (mod_badge.x == mod_badge.x * 2) {
			colour.a = 0;
		}

		// movement
		uv = uv - vec2(21, 21);
		number sprite_size = 44;
		number x = uv.x;
		number b = tx;//mod(tx, (floor(uie_details.b / sprite_size)) * sprite_size);
		number a = ty;//mod(ty, (floor(uie_details.a / sprite_size) + 1) * sprite_size);
		uv.x = (uv.x - b) * cos_neg_theta - (uv.y - a) * sin_neg_theta;
		uv.y = (x - b) * sin_neg_theta + (uv.y - a) * cos_neg_theta;
		uv = mod(uv, vec2(uie_details.b / (uie_details.b / (2 * uie_details.a)), uie_details.a)) / min(uie_details.b, uie_details.a);

		//masking
		number maskColor = step(0.9, texture2D(mask, uv).a) * 0.2;
		
		vec4 outcolor = mix(colour, vec4(0.0, 0.0, 0.0, 1.0), maskColor);

		//outcolor.r = texture2D(mask, uv).a;
		//outcolor.g = texture2D(mask, uv).a;
		//outcolor.b = texture2D(mask, uv).a;

    return outcolor;
}