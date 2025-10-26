shader_type canvas_item;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() { 
	float factor = 10.0; 
	float white_sub = 0.2;
	COLOR *=(vec4(factor, factor, factor, 1) * COLOR);
	COLOR -= vec4(white_sub, white_sub, white_sub, 0);
	if (abs(((COLOR.x + COLOR.y + COLOR.z) / 3.0) - COLOR.x) > 0.1){
		//COLOR.a = 0.6;
		COLOR.a = 0.6 * COLOR.a;
	}
	// Called for every pixel the material is visible on.
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
