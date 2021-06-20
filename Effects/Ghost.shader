shader_type canvas_item;
render_mode unshaded;

void fragment() {
	COLOR = texture(TEXTURE, UV);
	
	COLOR.r = COLOR.r + 0.5;	
	COLOR.g = COLOR.g + 0.5;
	COLOR.b = COLOR.b + 1.2;	
	COLOR.a = COLOR.a / 3.0;
}