/*********************************************************************************************
*  __    __________________   ________________________________   __________  ________       *
* /\ \  /\  __ \  ___\__  _\ /\  __ \  ___\__  _\  == \  __ \ "-.\ \  __ \ \/\ \__  _\ (tm) *
* \ \ \_\_\ \/\ \___  \/\ \/ \ \  __ \___  \/\ \/\  __<\ \/\ \ \-.  \  __ \ \_\ \/\ \/      *
*  \ \_____\_____\_____\ \_\  \ \_\ \_\_____\ \_\ \_\ \_\_____\_\\"\_\_\ \_\_____\ \_\      *
*   \/_____/_____/_____/\/_/   \/_/\/_/_____/\/_/\/_/\/_/_____/_/ \/_/_/\/_/_____/\/_/      *
*    --------------------------------------------------------------------------------       *
*     Lost Astronaut Game Development Framework (c) 2007-2020 H. Elwood Gilliland III       *
*********************************************************************************************
* This software is copyrighted software.  Use of this code is given only with permission to *
* parties who have been granted such permission by its author, Herbert Elwood Gilliland III *
*                                                                                           *
* CubeMappedSphereGML was based on:                                                         *
* https://github.com/LAGameStudio/apolune/blob/trunk/Apolune/CubeMappedSphere.h             *
* https://github.com/LAGameStudio/apolune/blob/trunk/Apolune/VBOFlavors.h                   *
*                       ...and other files in the Lost Astronaut Game Creation Framework    *
*                                                                                           *
* CubeMappedSphereGML is licensed BSD "New" "Revised" and requires adherence to the license.*
*                                                                                           *
* Thanks to Dragonite for his 3D tutorials that helped jog my memory.                       *
* Find them on reddit.com/r/GML and YouTube                                                 *
*********************************************************************************************/

/*
  Purpose: 
  
  To wrangle VBO creation and common operations.
  */

#macro VBOs global.vbo

function Init_VBO(){
 global.vbo = {
	 list: [],
	 V: function () {
		vertex_format_begin();
		vertex_format_add_position_3d();
		var vf=vertex_format_end();
		var bo=vertex_create_buffer();
		return {
			kind: pr_trianglelist,
			format: "V",
			vbo: bo,
			v_format: vf
		};
	 },
	 VC: function () {
		vertex_format_begin();
		vertex_format_add_position_3d();
		vertex_format_add_color();
		var vf=vertex_format_end();
		var bo=vertex_create_buffer();
		return {
			kind: pr_trianglelist,
			format: "VC",
			vbo: bo,
			v_format: vf
		};
	 },
	 VCLines: function () {
		vertex_format_begin();
		vertex_format_add_position_3d();
		vertex_format_add_color();
		var vf=vertex_format_end();
		var bo=vertex_create_buffer();
		return {
			kind: pr_linelist,
			format: "VCLines",
			vbo: bo,
			v_format: vf
		};
	 },
	 VNT: function () {
		vertex_format_begin();
		vertex_format_add_position_3d();
		vertex_format_add_normal();
		vertex_format_add_texcoord();
		var vf=vertex_format_end();
		var bo=vertex_create_buffer();
		return {
			kind: pr_trianglelist,
			format: "VNT",
			vbo: bo,
			v_format: vf
		};
	 },
	 VNTC: function () {
		vertex_format_begin();
		vertex_format_add_position_3d();
		vertex_format_add_normal();
		vertex_format_add_texcoord();
		vertex_format_add_color();
		var vf=vertex_format_end();
		var bo=vertex_create_buffer();
		return {
			kind: pr_trianglelist,
			format: "VNTC",
			vbo: bo,
			v_format: vf
		};
	 },
	 Add: {
		 V: function ( vboo, vx,vy,vz ) {
			 vertex_position_3d(vboo.vbo,vx,vy,vz);
		 },
		 VC: function ( vboo, vx,vy,vz, cr,cg,cb,ca ) {
			 vertex_position_3d(vboo.vbo,vx,vy,vz);
			 vertex_color(vboo.vbo, make_color_rgb(cr*255.0,cg*255.0,cb*255.0), ca );
		 },
		 VC_c: function ( vboo, vx,vy,vz, c,a ) {
			 vertex_position_3d(vboo.vbo,vx,vy,vz);
			 vertex_color(vboo.vbo, c,a );
		 },
		 VNT: function ( vboo, vx,vy,vz, nx,ny,nz, tx,ty ) {
			 vertex_position_3d(vboo.vbo,vx,vy,vz);
			 vertex_normal(vboo.vbo,vx,vy,vz);
			 vertex_texcoord(vboo.vbo,tx,ty);
		 },
		 VNTC: function ( vboo, vx,vy,vz, nx,ny,nz, tx,ty, cr,cg,cb,ca ) {
			 vertex_position_3d(vboo.vbo,vx,vy,vz);
			 vertex_normal(vboo.vbo,vx,vy,vz);
			 vertex_texcoord(vboo.vbo,tx,ty);
			 vertex_color(vboo.vbo, make_color_rgb(cr*255.0,cg*255.0,cb*255.0), ca );
		 },
		 VNTC_c: function ( vboo, vx,vy,vz, nx,ny,nz, tx,ty, c,a ) {
			 vertex_position_3d(vboo.vbo,vx,vy,vz);
			 vertex_normal(vboo.vbo,vx,vy,vz);
			 vertex_texcoord(vboo.vbo,tx,ty);
			 vertex_color(vboo.vbo, c,a);
		 },
	 },
	 Begin: function ( vbo_object ) { vertex_begin(vbo_object.vbo,vbo_object.v_format); },
	 End: function ( vbo_object ) { vertex_end(vbo_object.vbo); },
	 Freeze: function ( vbo_object ) { vertex_freeze(vbo_object.vbo); },
	 Draw: function ( vbo_object, texture ) {
		 vertex_submit(vbo_object.vbo, vbo_object.kind, texture);
	 }
  };
}


