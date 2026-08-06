uniform vec2 lusha;
uniform vec4 text_details;
uniform float text_scale;
uniform float text_rot;
uniform vec4 letter_details;
uniform float letter_scale;
uniform float letter_rot;
uniform bool text_shadow;

vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
    vec4 tex = Texel(texture, texture_coords);
    if (text_shadow) {
        return vec4(vec3(0.0), 0.3 * tex.a);
    }
    vec3 palette[2] = vec3[](
        vec3(243.0, 51.0, 111.0) / 255.0,
        vec3(243.0, 118.0, 116.0) / 255.0
    );
    float alpha = 1.0;
    if (lusha.x >= 0 || text_rot == 0 || letter_details.x == 0 || letter_scale == 0 || letter_rot == 0) { // Uniform consumer
        alpha = tex.a;
    }
    // Magic numbers needed to get the gradient more "centered". Not sure why.
    float u = 2 * text_scale * (screen_coords.x - text_details.x) / text_details.z - 1;
    return vec4(mix(palette[0], palette[1], u), alpha);
}