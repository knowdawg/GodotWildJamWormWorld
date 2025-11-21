shader_type canvas_item;


uniform sampler2D noise : repeat_enable, filter_nearest;
uniform vec2 resolution = vec2(320.0, 180.0);

uniform float progress : hint_range(0.0, 1.0);

void fragment() {
	vec2 qUV = floor(UV * resolution) / resolution;
	
	vec4 c = texture(TEXTURE, UV);
	vec4 n = texture(noise, qUV);
	
	float dis = pow(distance(SCREEN_UV.x + 1.0, progress * 3.0), 5.0);
	float trans = (1.0 - step(0.99, n.r + dis * 4.0)) * c.a;
	
	COLOR.a *= trans;
}


