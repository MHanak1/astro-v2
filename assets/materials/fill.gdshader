shader_type spatial;
render_mode unshaded,cull_disabled;

const vec4 default_wireframe_color = vec4(0., 1., 0., 1.);
instance uniform vec4 color : source_color = vec4(0.0);

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec4 color_ = (color * color.a) + (default_wireframe_color * (1.0 - color.a));
	ALBEDO = color_.rgb;
	ALPHA = color_.a;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
