extern number fade;

vec4 effect( vec4 colour, Image texture, vec2 texture_coords, vec2 screen_coords )
{
    return vec4(Texel(texture, texture_coords).rgb + vec3(fade), 1);
}