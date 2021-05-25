
matrix_set(matrix_world, world);
if ( model != noone ) {
	vertex_submit(model, pr_trianglelist, texture);
}
matrix_set(matrix_world, matrix_build_identity());