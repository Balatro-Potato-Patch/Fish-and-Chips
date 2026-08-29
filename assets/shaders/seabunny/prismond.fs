uniform float dissolve;
uniform float time;
uniform vec4 texture_details;
uniform vec2 image_details;
uniform bool shadow;
uniform vec4 burn_colour_1;
uniform vec4 burn_colour_2;

vec4 dissolve_mask(vec4 tex, vec2 texture_coords, vec2 uv) {
    if (dissolve < 0.001) {
        return shadow ? vec4(0.0, 0.0, 0.0, tex.a * 0.3) : tex;
    }

    float adjusted_dissolve = dissolve * dissolve * (3.0 - 2.0 * dissolve) * 1.02 - 0.01;
    // Adjusting 0.0 - 1.0 to fall to -0.1 - 1.1 scale so the mask does not pause at extreme values

    float t = time * 10.0 + 2003.0;
    vec2 floored_uv = floor(uv * texture_details.ba) / max(texture_details.b, texture_details.a);
    vec2 uv_scaled_centered = (floored_uv - 0.5) * 2.3 * max(texture_details.b, texture_details.a);
    
    vec2 field_part1 = uv_scaled_centered + 50.0 * vec2(sin(-t / 143.6340), cos(-t / 99.4324));
    vec2 field_part2 = uv_scaled_centered + 50.0 * vec2(cos(t / 53.1532), cos(t / 61.4532));
    vec2 field_part3 = uv_scaled_centered + 50.0 * vec2(sin(-t / 87.53218), sin(-t / 49.0000));

    float field = (1.0 + cos(length(field_part1) / 19.483) + sin(length(field_part2) / 33.155) * cos(field_part2.y / 15.73) + cos(length(field_part3) / 27.193) * sin(field_part3.x / 21.92)) / 2.0;
    vec2 borders = vec2(0.2, 0.8);
    
    float res = 0.5 + 0.5 * cos(adjusted_dissolve / 82.612 + (field + -0.5) * 3.14)
    - (floored_uv.x > borders.y ? (floored_uv.x - borders.y) * (5.0 + 5.0 * dissolve) : 0.0) * dissolve
    - (floored_uv.y > borders.y ? (floored_uv.y - borders.y) * (5.0 + 5.0 * dissolve) : 0.0) * dissolve
    - (floored_uv.x < borders.x ? (borders.x - floored_uv.x) * (5.0 + 5.0 * dissolve) : 0.0) * dissolve
    - (floored_uv.y < borders.x ? (borders.x - floored_uv.y) * (5.0 + 5.0 * dissolve) : 0.0) * dissolve;

    if (tex.a > 0.01 && burn_colour_1.a > 0.01 && !shadow && res < adjusted_dissolve + 0.8 * (0.5 - abs(adjusted_dissolve - 0.5)) && res > adjusted_dissolve) {
        if (!shadow && res < adjusted_dissolve + 0.5 * (0.5 - abs(adjusted_dissolve - 0.5)) && res > adjusted_dissolve) {
            tex.rgba = burn_colour_1.rgba;
        } else if (burn_colour_2.a > 0.01) {
            tex.rgba = burn_colour_2.rgba;
        }
    }

    return vec4(shadow ? vec3(0.0, 0.0, 0.0) : tex.xyz, res > adjusted_dissolve ? (shadow ? tex.a * 0.3: tex.a) : 0.0);
}

uniform float prismond;
// G.TIMERS.REAL

vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
    vec3 palette[8] = vec3[](
        vec3(55.0, 133.0, 200.0) / 255.0,
        vec3(246.0, 222.0, 72.0) / 255.0,
        vec3(198.0, 119.0, 24.0) / 255.0,
        vec3(168.0, 179.0, 51.0) / 255.0,
        vec3(109.0, 63.0, 124.0) / 255.0,
        vec3(215.0, 150.0, 132.0) / 255.0,
        vec3(244.0, 158.0, 0.0) / 255.0,
        vec3(184.0, 34.0, 71.0) / 255.0
    );
    vec4 tex = Texel(texture, texture_coords);
    vec2 uv = (texture_coords * image_details - texture_details.xy * texture_details.zw) / texture_details.zw;
    float element = mod(prismond + tex.b * 8, 8);
    int i = int(element);
    int j = i + 1;
    vec3 base = mix(palette[i], palette[j == 8 ? 0 : j], fract(element));
    float alpha = (sin(1.2 * prismond) * 0.5 + 0.5) * 0.4 * tex.a;
    return dissolve_mask(vec4(base, alpha), texture_coords, uv);
}

uniform vec2 mouse_screen_pos;
uniform float hovering;
uniform float screen_scale;

#ifdef VERTEX
vec4 position(mat4 transform_projection, vec4 vertex_position) {
    if (hovering <= 0.0) {
        return transform_projection * vertex_position;
    }
    float mid_dist = length(vertex_position.xy - 0.5 * love_ScreenSize.xy) / length(love_ScreenSize.xy);
    vec2 mouse_offset = (vertex_position.xy - mouse_screen_pos.xy) / screen_scale;
    float scale = 0.2 * (-0.03 - 0.3 * max(0.0, 0.3 - mid_dist)) * hovering * (length(mouse_offset) * length(mouse_offset)) / (2.0 - mid_dist);
    return transform_projection * vertex_position + vec4(0.0, 0.0, 0.0, scale);
}
#endif