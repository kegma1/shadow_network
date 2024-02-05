shader_type canvas_item;

uniform vec2 Direction = vec2(1.0, -1.0);
uniform float Speed = 0.08;
uniform float Rotation = 0.0; 
uniform vec4 Color : source_color = vec4(1.0, 1.0, 1.0, 1.0);

void fragment() {
	mat2 rotation_matrix = mat2(vec2(cos(Rotation), -sin(Rotation)), vec2(sin(Rotation), cos(Rotation)));
	vec2 rotated_uv = rotation_matrix * (UV - vec2(0.5)) + vec2(0.5);
	vec4 grayscale_color = texture(TEXTURE, rotated_uv + (Direction * TIME * Speed));
	COLOR = grayscale_color * Color;
}

