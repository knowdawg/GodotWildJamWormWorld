shader_type canvas_item;

uniform sampler2D maskNoise : repeat_enable;

uniform sampler2D mainNoise : repeat_enable;
uniform sampler2D warpNoise : repeat_enable;

uniform float maskSize : hint_range(-1.0, 1.0);

uniform vec2 resolution = vec2(320.0, 180.0);

vec2 toPolar(vec2 cart){
	vec2 pol = vec2(distance(vec2(0.5, 0.5), cart), atan(cart.y / cart.x));
	return pol;
}

void fragment() {
	vec2 qUV = floor(UV * resolution) / resolution;
	vec4 c = vec4(1.0);
	vec2 warp = texture(warpNoise, qUV + vec2(TIME * 0.01)).rg;// + vec2(sin(TIME * 0.01));
	vec4 main = texture(mainNoise, qUV + warp - vec2(TIME * 0.01));
	
	c = main;
	
	
	vec4 n = texture(maskNoise, UV + warp - vec2(TIME * 0.02));
	float disToCenter = maskSize - distance(vec2(0.5, 0.5), qUV);
	c.a = smoothstep(0.0, 1.0, n.a + disToCenter * 5.0);
	
	COLOR = c * vec4(vec3(0.5), 1.0);
}