shader_type canvas_item;

uniform vec4 flash_color: source_color = vec4(1, 1, 1, 1);
uniform float flash_intensity: hint_range(0.0, 1.0) = 0.0;
uniform float opacity: hint_range(0.0, 1.0) = 1.0;

void fragment() {
	vec4 base_color = COLOR;
	base_color.a *= opacity;
	vec4 target_color = vec4(flash_color.r, flash_color.g, flash_color.b, base_color.a);
	
	COLOR = mix(base_color, target_color, flash_intensity);
}