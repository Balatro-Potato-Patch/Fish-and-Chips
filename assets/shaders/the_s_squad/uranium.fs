extern float t;
extern vec2 screen_dims;
extern float size;

float rand(vec2 c) {
	return fract(sin(dot(c.xy, vec2(12.9898,78.233))) * 43758.5453);
}

vec4 effect( vec4 colour, Image texture, vec2 texture_coords, vec2 screen_coords ) {
	float f = rand(floor(screen_coords/size)/screen_dims+floor(mod(t*15, 15))/15);
	return f>1-t*.1/600. ? vec4(1.) : Texel(texture,texture_coords);
}