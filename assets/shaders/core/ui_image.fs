#if defined(VERTEX) || __VERSION__ > 100 || defined(GL_FRAGMENT_PRECISION_HIGH)
    #define MY_HIGHP_OR_MEDIUMP highp
#else
    #define MY_HIGHP_OR_MEDIUMP mediump
#endif

extern MY_HIGHP_OR_MEDIUMP vec2 ui_image;
extern MY_HIGHP_OR_MEDIUMP vec4 uie_details;
extern MY_HIGHP_OR_MEDIUMP number uie_scale;
extern MY_HIGHP_OR_MEDIUMP number uie_rot;

extern MY_HIGHP_OR_MEDIUMP Image mask;
extern MY_HIGHP_OR_MEDIUMP vec2 atlas_dim;
extern MY_HIGHP_OR_MEDIUMP vec2 atlas_pos;


vec4 effect( vec4 colour, Image texture, vec2 texture_coords, vec2 screen_coords )
{
    // Transform coords to match atlas
    vec2 uv = (screen_coords - uie_details.xy) / uie_details.zw;
    uv = uv * atlas_dim;
    uv = uv + (atlas_dim * atlas_pos);
    
        // I don't know what these do
    if (uie_scale < uie_details.x) {
        uv.x = uv.x + 0.0001 + ui_image.x * 0;
    }
    if (uie_rot < 0.00001) {
        uv.x = uv.x + 0.0001;
    }
    if (ui_image.x < 0.00001) {
        uv.x = uv.x + 0.0001;
    }
    //masking
    vec4 maskColor = Texel(mask, uv);
    maskColor = maskColor * colour;
    return maskColor;
}