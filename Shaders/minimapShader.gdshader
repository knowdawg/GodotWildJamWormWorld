shader_type canvas_item;

uniform sampler2D noise : filter_nearest, repeat_enable;

uniform float progress : hint_range(0.0, 1.0);

void fragment() {
	vec4 n = texture(noise, UV);
	
	float dis = 1.0 - distance(UV.y, progress - 0.5);
	
	n.a = step(0.5 - n.r * 0.05, dis);
	
	COLOR.rgb = vec3(0.5, 0.1, 0.1);
	COLOR.rgb += vec3(n.a);
}

