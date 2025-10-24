//actually this isn't a test shader, don't delete it!

shader_type canvas_item;
uniform float red_intensity = 1;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	if (COLOR.r > 0.6){
		COLOR.r = red_intensity;
	};
	// Called for every pixel the material is visible on.
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
