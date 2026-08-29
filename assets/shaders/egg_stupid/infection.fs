#if defined(VERTEX) || __VERSION__ > 100 || defined(GL_FRAGMENT_PRECISION_HIGH)
    #define MY_HIGHP_OR_MEDIUMP highp
#else
    #define MY_HIGHP_OR_MEDIUMP mediump
#endif

extern MY_HIGHP_OR_MEDIUMP float time;
extern MY_HIGHP_OR_MEDIUMP float infection;

vec4 effect( vec4 colour, Image texture, vec2 texture_coords, vec2 screen_coords )
{
    vec2 uv = (screen_coords.xy - 0.5*love_ScreenSize.xy)/length(love_ScreenSize.xy);
    vec2 adjusted_uv = uv;

    float radius = (2.15 - infection * 0.06 + 0.1 * sin(0.8 * time)) * 0.5;

    float val = smoothstep(0., radius*radius, adjusted_uv.x * adjusted_uv.x + adjusted_uv.y * adjusted_uv.y);

    vec4 col = Texel(texture, texture_coords);
    
    return (1 - val) * col + val * vec4(0.345, 0.713, 0.815, 1.0);
}