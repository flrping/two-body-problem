shader_type canvas_item;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	if (COLOR.r > 0.2){
		COLOR.r = 0.0;
	}

	float darken_factor = 0.4;
	COLOR *= vec4(darken_factor, darken_factor, darken_factor, 1);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
