shader_type canvas_item;

uniform float rotation : hint_range(0.0, 1.0);

void fragment() {
	vec2 scalledUV = vec2(UV.x * rotation, UV.y);
}


