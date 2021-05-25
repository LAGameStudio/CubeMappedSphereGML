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
  
  To create a standard form basic 3D camera system, similar to what is found in the LAGCF.
  
  This section is still WIP and may appear in other packages in a more advanced state.
  Visit LAGameStudio's Github often!  Star our projects!  Support us!  Tell your friends about us.
  
  Follow us on Twitter:  @LAGameStudio
 */

#macro CAM3D global.cam3d

function Init_CameraSystem3D() {
 global.cam3d = {
		camera: [],
		aspect: ( window_get_width() / window_get_height() ),
		inverseAspect: ( window_get_height() / window_get_width() ),
		Update: function ( c_idx ) {
			CAM3D.camera[c_idx].v=matrix_build_lookat(
			 CAM3D.camera[c_idx].cx,CAM3D.camera[c_idx].cy,CAM3D.camera[c_idx].cz,
			 CAM3D.camera[c_idx].lx,CAM3D.camera[c_idx].ly,CAM3D.camera[c_idx].lz,
			 CAM3D.camera[c_idx].ux,CAM3D.camera[c_idx].uy,CAM3D.camera[c_idx].uz
			);
			CAM3D.camera[c_idx].p=matrix_build_projection_perspective_fov(
			 CAM3D.camera[c_idx].fov,
			 CAM3D.camera[c_idx].aspect,
			 CAM3D.camera[c_idx].near,
			 CAM3D.camera[c_idx].far
			);
			CAM3D.camera[c_idx].dirty=false;
		},
		UpdateAll: function () {
			var len = array_length(CAM3D.camera);
			for ( var i=0; i<len; i++ ) CAM3D.Update(i);
		},
		PointAt: function ( c_idx, lx, ly, lz ) {
			CAM3D.camera[c_idx].lx=lx;
			CAM3D.camera[c_idx].ly=ly;
			CAM3D.camera[c_idx].lz=lz;
			CAM3D.camera[c_idx].dirty=true;
		},
		MoveTo: function ( c_idx, cx, cy, cz ) {
			CAM3D.camera[c_idx].cx=cx;
			CAM3D.camera[c_idx].cy=cy;
			CAM3D.camera[c_idx].cz=cz;
			CAM3D.camera[c_idx].dirty=true;
		},
		Orbit: function ( c_idx, x_perc, y_perc ) { /* WIP */
		},
		AddCamera: function ( cx, cy, cz, lx, ly, lz ) {
			CAM3D.camera[array_length(CAM3D)]=CAM3D.NewCamera( cx, cy, cz, lx, ly, lz );
			return array_length(CAM3D.cameras)-1;
		},
		NewCamera: function ( cx, cy, cz, lx, ly, lz ) {
			return {
				cx: cx, cy: cy, cz: cz,
				near: 0.01,
				far: 10000.0,
				fov: 90,
				aspect: CAM3D.aspect,
				inverseAspect: CAM3D.inverseAspect,
				lx: lx, ly: ly, lz: lz,
				ux: 0.0, uy: 0.0, uz: -1.0,
				orbit: 1.0,
				mView: matrix_get(matrix_view),
				mProj: matrix_get(matrix_projection),
				mWorld: matrix_get(matrix_world),
				v: 0,
				p: 0,
				w: matrix_build_identity(),
				dirty: true
			};
		},
		Apply: function ( c_idx ) {
			if ( CAM3D.camera[c_idx].dirty ) CAM3D.Update(c_idx);
			var camera = camera_get_active();
			camera_set_view_mat(camera,CAM3D.camera[c_idx].v);
			camera_set_proj_mat(camera,CAM3D.camera[c_idx].p);
			gpu_set_cullmode(cull_noculling);
			gpu_set_ztestenable(true);
			gpu_set_zwriteenable(true);
			camera_apply(camera);
		},
		Disable: function () {
			gpu_set_cullmode(cull_noculling);
			gpu_set_ztestenable(false);
			gpu_set_zwriteenable(false);
		}
	};
	
	CAM3D.camera[0]=CAM3D.NewCamera( 0.0, 5.0, 5.0, 0.0, 0.0, 0.0 );
}
