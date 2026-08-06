// Code not taken from https://youtu.be/Qr3VsZYQy4s?t=1888 but the uploaded did give me the code

uniform vec2 dims;
uniform float samples;
const float PI = 3.1415926535;
const vec2 texSize = vec2(.1);

vec3 samp(vec2 uv, Image texture) {
	return Texel(texture, uv/dims).rgb/samples/samples;
}

vec4 effect( vec4 colour, Image texture, vec2 texture_coords, vec2 screen_coords ) {
	vec2 blockCoord = mod(screen_coords - .5, samples);
	vec3 c = vec3(0.);
	
	for(float x = 0.; x < samples; x++) {
		for(float y = 0.; y < samples; y++) {
			vec2 sineMult = vec2(x,y) * PI / samples;
			float sineFactor = cos((blockCoord.x+.5)*sineMult.x)*cos((blockCoord.y+.5)*sineMult.y)*2.;
			if(x==0.) sineFactor /= sqrt(2.);
			if(y==0.) sineFactor /= sqrt(2.);
			c += samp(screen_coords-blockCoord+vec2(x,y), texture)*sineFactor;
		}
	}
	
	return vec4(c,1.);
}

