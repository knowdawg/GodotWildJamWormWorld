shader_type canvas_item;

uniform sampler2D mainNoise : repeat_enable;
uniform sampler2D warpNoise : repeat_enable;

uniform vec2 resolution = vec2(320.0, 180.0);

uniform float speed : hint_range(0.0, 10.0, 0.1) = 1.0;

vec2 toPolar(vec2 cart){
	vec2 pol = vec2(distance(vec2(0.5, 0.5), cart), atan(cart.y / cart.x));
	return pol;
}

void fragment() {
	vec2 qUV = floor(UV * resolution) / resolution;
	vec4 c = vec4(1.0);
	vec2 warp = texture(warpNoise, qUV + vec2(TIME * 0.005 * speed)).rg;// + vec2(sin(TIME * 0.01));
	vec4 main = texture(mainNoise, qUV + warp - vec2(TIME * 0.01 * speed));
	
	c = main;
	
	COLOR = c * vec4(vec3(0.5), 1.0);
}