extern float realtime;

vec2 rhash(vec2 uv){
	mat2 myt=mat2(.12121212,.13131313,-.13131313,.12121212);
	vec2 mys=vec2(1e4,1e6);
    uv*=myt;
    uv*=mys;
    return fract(fract(uv/mys)*uv);
}

vec3 hash(vec3 p){
    return fract(sin(vec3(dot(p,vec3(1.,57.,113.)),
    dot(p,vec3(57.,113.,1.)),
    dot(p,vec3(113.,1.,57.))))*
43758.5453);
}

float voronoi2d(const in vec2 point){
	vec2 p=floor(point);
	vec2 f=fract(point);
	float res=0.;
	for(int j=-1;j<=1;j++){
		for(int i=-1;i<=1;i++){
			vec2 b=vec2(i,j);
			vec2 r=vec2(b)-f+rhash(p+b);
			res+=1./pow(dot(r,r),8.);
		}
	}
	return pow(1./res,.0625);
}

vec2 cart2polar(vec2 uv){
	float phi=atan(uv.y,uv.x);
	float r=length(uv);
	return vec2(phi,r);
}

vec4 godrays(vec2 uv, float offset) {
	float time = realtime * offset;
	vec2 p=uv;
	p.x*=love_ScreenSize.x/love_ScreenSize.y;

	uv=(uv-.5)*2.;
	uv.x*=love_ScreenSize.x/love_ScreenSize.y;

	vec3 col=vec3(0.);
	// float noise=voronoi2d(uv*3.);
	// col=vec3(noise);

	uv.y-=2.;
	uv/=50.;
	uv=cart2polar(uv);
	col=vec3(uv.x);

	float n1=voronoi2d((vec2(uv.x,0.)+.04*time)*10.);
	col=vec3(n1);
	float n2=voronoi2d((vec2(.1,uv.x)+.04*time*1.5)*10.);
	col=vec3(n2);
	float n3=min(n1,n2);
	col=vec3(n3);

	// col=vec3(1.);
	float mask=smoothstep(.15,.86,p.y);
	float alpha=n3*mask*.8;

	col=mix(vec3(0.),vec3(1.),alpha);
	col.r = col.r + .75*alpha;
	col.g = col.g + .33*alpha;
	return vec4(col, 1);
}

// This is what actually changes the look of card
vec4 effect(vec4 colour,Image texture,vec2 tc,vec2 screen_coords)
{
    vec2 uv=screen_coords/love_ScreenSize.xy;
	uv.y = 1-uv.y;
	return Texel(texture,tc) + max(godrays(uv, 1.25), godrays(uv, -0.77))*0.66;
}

#ifdef VERTEX
vec4 position(mat4 transform_projection,vec4 vertex_position)
{
    return transform_projection*vertex_position;
}
#endif