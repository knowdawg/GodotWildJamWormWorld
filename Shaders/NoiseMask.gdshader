shader_type canvas_item;

uniform sampler2D noise : filter_nearest, repeat_enable;

void fragment() {
	vec4 n = texture(noise, UV);
	vec4 c  = vec4(1.0);
	float disToCenter = 0.3 - distance(vec2(0.5, 0.5), UV);
	
	c.a = smoothstep(0.5, 1.0, n.a + disToCenter * 3.0);
	
	COLOR.a = c.a;
}

