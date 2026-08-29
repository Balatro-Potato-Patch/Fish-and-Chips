#if defined(VERTEX) || __VERSION__ > 100 || defined(GL_FRAGMENT_PRECISION_HIGH)
    #define MY_HIGHP_OR_MEDIUMP highp
#else
    #define MY_HIGHP_OR_MEDIUMP mediump
#endif

extern MY_HIGHP_OR_MEDIUMP vec2 fas_water;
extern MY_HIGHP_OR_MEDIUMP vec4 uie_details;
extern MY_HIGHP_OR_MEDIUMP number uie_scale;
extern MY_HIGHP_OR_MEDIUMP number uie_rot;

extern MY_HIGHP_OR_MEDIUMP number water_height;

// from AlexZGreat
vec2 random2(vec2 st){
    st = vec2( dot(st,vec2(127.1,311.7)),
              dot(st,vec2(269.5,183.3)) );
    return -1.0 + 2.0*fract(sin(st)*43758.5453123);
}

// Gradient Noise by Inigo Quilez - iq/2013
// https://www.shadertoy.com/view/XdXGW8
float noise(vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);

    vec2 u = f*f*(3.0-2.0*f);

    return mix( mix( dot( random2(i + vec2(0.0,0.0) ), f - vec2(0.0,0.0) ),
                     dot( random2(i + vec2(1.0,0.0) ), f - vec2(1.0,0.0) ), u.x),
                mix( dot( random2(i + vec2(0.0,1.0) ), f - vec2(0.0,1.0) ),
                     dot( random2(i + vec2(1.0,1.0) ), f - vec2(1.0,1.0) ), u.x), u.y);
}

#define LIGHT_BLUE vec4(0.047058823529412, 0.68627450980392, 0.86666666666667, 1)
#define DARK_BLUE vec4(0.68235294117647, 0.93529411764706, 1, 1)

vec4 effect( vec4 colour, Image texture, vec2 texture_coords, vec2 screen_coords ) {
		//transform the coords
    vec2 uv = (screen_coords - uie_details.xy) / uie_details.ga;// * 10;

    if (uie_scale < 0.00001) {
        uv.x = uv.x + 0.0001;
    }
    if (uie_rot < 0.00001) {
				uv.x = uv.x + 0.0001;
    }

        vec2 mem_uv = uv;

        uv = uv - vec2(fas_water.x, fas_water.x / 4);
		float n = noise(uv * 10) + 0.1;
        n = n + 0.5 * noise((uv + vec2(
            fas_water.x * 4 + 4 * sin(fas_water.x),
            fas_water.x + 4 * cos(fas_water.x) + screen_coords.y / 1000 + screen_coords.x / 5000
        )) * 10);
        n = clamp(n, 0, 1);
		vec4 outcolor = mix(LIGHT_BLUE, DARK_BLUE, n * 2);
        vec4 col = Texel(texture, texture_coords) * colour;
        outcolor.a = col.a;

        return mix(col, outcolor, min(1, n / 2 + 0.3) * step(water_height + 0.075 * sin(fas_water.y * 5 + uv.x * 7) + 0.005 * sin(-fas_water.y * 20 + uv.x * 35), mem_uv.y));
}
