// Code taken from https://youtu.be/Qr3VsZYQy4s?t=1888

uniform float quality;
uniform vec2 dims;
uniform float samples;
const float PI = 3.1415926535;
const vec2 texSize = vec2(.1);

vec3 samp(vec2 uv, Image texture) {
	return Texel(texture, uv/dims).rgb;
}

vec4 effect( vec4 colour, Image texture, vec2 texture_coords, vec2 screen_coords ) {
	vec2 blockCoord = mod(screen_coords - .5, samples);
	vec2 sineMult = blockCoord * PI / samples;

	vec3 sineCorrelation = vec3(0.);

	for(float x = 0.; x < samples; x++) {
		for(float y = 0.; y < samples; y++) {
			vec3 baseFactor = samp(screen_coords-blockCoord+vec2(x,y),texture);
			float sineFactor = cos((x+.5)*sineMult.x)*cos((y+.5)*sineMult.y);
			sineCorrelation += baseFactor * vec3(sineFactor);
		}
	}

	vec3 c = sineCorrelation*2.0;
	if(blockCoord.x == 0.) c /= sqrt(2.);
	if(blockCoord.y == 0.) c /= sqrt(2.);

	//float finalQuality = quality * clamp(distance(screen_coords-blockCoord, vec2(focus.x, screen_coords.y-focus.y))/focus.z, 0.0, 1.0);

	if(abs(c.r) < (3.0-quality*3.0)*samples) c.r = 0.0;
	if(abs(c.g) < (3.0-quality*3.0)*samples) c.g = 0.0;
	if(abs(c.b) < (3.0-quality*3.0)*samples) c.b = 0.0;

	return vec4(c, 1.);
}

