shader_type canvas_item;

uniform vec4 outline_color: source_color = vec4(255, 226, 40, 255);
uniform int outline_size = 1;
uniform bool enabled = true;

const vec2 OFFSETS[8] = {vec2(-1, -1), vec2(-1, 0), vec2(-1, 1), vec2(0, -1), vec2(0, 1), vec2(1, -1), vec2(1, 0), vec2(1, 1)};

void fragment(){
	if (enabled) {
		vec2 size = TEXTURE_PIXEL_SIZE * float(outline_size);
		float outline = 0.0;

		for (int i = 0; i < OFFSETS.length(); i++) {outline += texture(TEXTURE, UV + size * OFFSETS[i]).a;}
		outline = min(outline, 1.0);

		vec4 color = texture(TEXTURE, UV);
		COLOR = mix(color, outline_color, outline - color.a);
	}
}