
matrix_set(matrix_world, matrix);
//CMS_DrawCMS( global.cms_hi, s_Test_Spherebox );
CMS_DrawTexCMS( global.cms_hi, s_Test_F, s_Test_R, s_Test_B, s_Test_L, s_Test_U, s_Test_D );
matrix_set(matrix_world, matrix_build_identity());
