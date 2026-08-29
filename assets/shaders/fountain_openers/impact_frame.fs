extern Image frame;

vec4 effect( vec4 colour, Image texture, vec2 texture_coords, vec2 screen_coords )
{
    vec4 tex = Texel(frame, texture_coords);
    return vec4(vec3(floor(max(max(tex.r, tex.g), tex.b) + 0.5)), 1);
}