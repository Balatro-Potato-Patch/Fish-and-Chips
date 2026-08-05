#define PI 3.14159265358979323846

extern vec2 center_pos;
extern float dist;
extern Image evilassjade;
extern float scale;

float rand(vec2 c){
    return fract(sin(dot(c.xy,vec2(12.9898,78.233)))*43758.5453);
}

float lindist(float a,float b){
    return abs(a-b);
}

number hue(number s, number t, number h)
{
	number hs = mod(h, 1.)*6.;
	if (hs < 1.) return (t-s) * hs + s;
	if (hs < 3.) return t;
	if (hs < 4.) return (t-s) * (4.-hs) + s;
	return s;
}

vec4 RGB(vec4 c)
{
	if (c.y < 0.0001)
		return vec4(vec3(c.z), c.a);

	number t = (c.z < .5) ? c.y*c.z + c.z : -c.y*c.z + (c.y+c.z);
	number s = 2.0 * c.z - t;
	return vec4(hue(s,t,c.x + 1./3.), hue(s,t,c.x), hue(s,t,c.x - 1./3.), c.w);
}

vec4 HSL(vec4 c)
{
	number low = min(c.r, min(c.g, c.b));
	number high = max(c.r, max(c.g, c.b));
	number delta = high - low;
	number sum = high+low;

	vec4 hsl = vec4(.0, .0, .5 * sum, c.a);
	if (delta == .0)
		return hsl;

	hsl.y = (hsl.z < .5) ? delta / sum : delta / (2.0 - sum);

	if (high == c.r)
		hsl.x = (c.g - c.b) / delta;
	else if (high == c.g)
		hsl.x = (c.b - c.r) / delta + 2.0;
	else
		hsl.x = (c.r - c.g) / delta + 4.0;

	hsl.x = mod(hsl.x / 6., 1.);
	return hsl;
}
// This is what actually changes the look of card
vec4 effect(vec4 colour,Image texture,vec2 tc,vec2 screen_coords)
{
    vec4 tex=Texel(texture,tc);
    float p = dist / 20.;
    vec4 final_bg = tex * (1-p) + tex*p;
    if(p > 1) final_bg = tex;
    vec2 wh = vec2(0.2, 0.2) / (love_ScreenSize.xy / vec2(1920, 1920).xy);
    wh *= scale;
    vec2 uv2 = (-center_pos + screen_coords/love_ScreenSize.xy)/wh.xy + vec2(0.5,0.5);
    float frame = 0;
    vec4 frac = Texel(evilassjade, uv2);
    vec4 final = final_bg + frac;
	float d = dist;
	if (d > 2.5) d = 2.5;
    float fade = (sin(3.1415*2*d/3.2) + 1.) / 2.;
    if(fade > 0) {
		if (uv2.x > 1 || uv2.x < 0 || uv2.y > 1 || uv2.y < 0) {
			final = tex;
		}
		else {
			final = frac*fade + tex*(1-fade);
		}
    }
    final.a = 1;
    return final;

}

#ifdef VERTEX
vec4 position(mat4 transform_projection,vec4 vertex_position)
{
    return transform_projection*vertex_position;
}
#endif