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
 
 The generation of a vertex buffer sphere that can be textured in a 6-sided fashion, to permit
 the use of inverted skyboxes as a source for planetary and spheroid surfaces.  Generalized
 algorithm permits both high and low resolution.   Call Init_CubeMappedSphere() once to generate two
 fine examples.  Now you have high resolution 6-side spheres.
 
 Background:
 https://gamedev.stackexchange.com/questions/108667/how-to-load-a-spherical-planet-and-its-regions
 
 */

function Init_CubeMappedSphere() {
    global.cms=CubeMappedSphere(0.5,false);
    global.cms_hi=CubeMappedSphere(0.5,true);

}

/*Creating a sphere from cube vertices.
	http://mathproofs.blogspot.com/2005/07/mapping-cube-to-sphere.html
	 [x1]  [x sqrt(1-(y^2/2)-(z^2/2)+((y^2*z^2)/3)]
	 [y1]= [y sqrt(1-(z^2/2)-(x^2/2)+((z^2*x^2)/3)]
	 [z1]  [z sqrt(1-(x^2/2)-(y^2/2)+((x^2*y^2)/3)]
	  /|-------/|
	 /_|______/ |
	 | |      | |  order of face generation: front, left, back, top, right, bottom
	 | |      | |
	 | |      | |
	 | /------|-/
	 |/_______|/
	 ____________
	 |/|/|/|/|/|/| triangle generation: res iterations on outer loop per side, res iterations on inner loop per side.
	 ____________
	 |/|/|/|/|/|/| repeats 6 times, one per face.
	 ____________           (v2+1-1) 
	 |/|/|/|/|/|/|   v2 ------ v2+1
	 ____________       |2  /|
	 |/|/|/|/|/|/|      |  / |
	 ____________       | /1 |
	 |/|/|/|/|/|/|   v1 |/  _| v1+1
	 
	 
	 The reason we use a 6-sided sphere generated this way is to use a 6-sided cubic texture (Skybox)
	 as the source material.
                   
	*/


#macro FRONT_ID  0
#macro RIGHT_ID  1
#macro BACK_ID   2
#macro LEFT_ID   3
#macro TOP_ID    4
#macro BOTTOM_ID 5

function SQ( a ) { return a*a; }

function CMS_TriVNT( vx, vy, vz, tcx, tcy ) {
	return {
		vx:vx,
		vy:vy,
		vz:vz,
		tcx: tcx,
		tcy: tcy,
	};
}
function CMS_TriNormal( vnt1, vnt2, vnt3 ) {
	var ax=vnt1.vx - vnt2.vx;
	var ay=vnt1.vy - vnt2.vy;
	var az=vnt1.vz - vnt2.vz;
	var bx=vnt3.vx - vnt1.vz;
	var by=vnt3.vy - vnt1.vz;
	var bz=vnt3.vz - vnt1.vz;
	var nx=ay*bz - az*by;
	var ny=az*bx - ax*bz;
	var nz=ax*by - ay*bx;
	return { nx: nx, ny: ny, nz: nz };
}
function CMS_MakeTri( vboo, t1,t2,t3 ) {
 var tn=CMS_TriNormal( t1,t2,t3 );
 VBOs.Add.VNTC_c( vboo, 
  t1.vx,t1.vy,t1.vz,
  tn.nx,tn.ny,tn.nz,
  t1.tcx,t1.tcy,
  c_white,1
 );
 VBOs.Add.VNTC_c( vboo, 
  t2.vx,t2.vy,t2.vz,
  tn.nx,tn.ny,tn.nz,
  t2.tcx,t2.tcy,
  c_white,1
 );
 VBOs.Add.VNTC_c( vboo, 
  t3.vx,t3.vy,t3.vz,
  tn.nx,tn.ny,tn.nz,
  t3.tcx,t3.tcy,
  c_white,1
 );
}



function CubeMappedSphere( radius, hires ) {
  var res;
  if ( hires == false ) res=10.0;
  else res=64.0;
	
  var arraySize=(res+1)*(res+1)*6+1;
  var unit=2.0;
  var unit2=1.0;
  var deltaunit=unit/res;
  var r=0.5;
  var F=0, L=0, B=0, R=0, D=0, U=0;
	
  var v1=0,v2=0;
  var pos=0;
  var px=0.0,py=0.0,pz=0.0;
	
  var pointsX=[], pointsY=[], pointsZ=[];
	
  //generate points for unit sphere
  //front face
  for ( px=-unit2; px<=unit2; px+=deltaunit ) {
   for ( py=-unit2; py<=unit2; py+=deltaunit ) {
    pointsX[pos]= px * sqrt( 0.5 - SQ(py)/2.0 + SQ(py)/3.0 );
    pointsY[pos]= py * sqrt( 0.5 - SQ(px)/2.0 + SQ(px)/3.0 );
    pointsZ[pos]=  1 * sqrt( 1.0 - SQ(px)/2.0 - SQ(py)/2.0 + (SQ(px)*SQ(py))/3.0 );
    pos++;
   }
  }
  F=pos;
  //left face
  for ( pz=unit2; pz>=-unit2; pz-=deltaunit ) {
   for ( py=-unit2; py<=unit2; py+=deltaunit ) {
    pointsX[pos]=  1 * sqrt( 1.0 - SQ(py)/2.0 - SQ(pz)/2.0 + (SQ(py)*SQ(pz))/3.0 );
    pointsY[pos]= py * sqrt( 0.5 - SQ(pz)/2.0 + SQ(pz)/3.0 );
    pointsZ[pos]= pz * sqrt( 0.5 - SQ(py)/2.0 + SQ(py)/3.0 );
    pos++;
   }
  }
  L=pos;
   //back face
  for ( px=unit2; px>=-unit2; px-=deltaunit ) {
   for ( py=-unit2; py<=unit2; py+=deltaunit ) {
    pointsX[pos]= px * sqrt( 0.5 - SQ(py)/2.0 + SQ(py)/3.0 );
    pointsY[pos]= py * sqrt( 0.5 - SQ(px)/2.0 + SQ(px)/3.0 );
    pointsZ[pos]= -1 * sqrt( 1.0 - SQ(px)/2.0 - SQ(py)/2.0 + (SQ(px)*SQ(py))/3.0 );
    pos++;
   }
  }
  B=pos;
 //right face
  for ( pz=-unit2; pz<=unit2; pz+=deltaunit ) {
   for ( py=-unit2; py<=unit2; py+=deltaunit ) {
    pointsX[pos]= -1 * sqrt( 1.0- SQ(py)/2.0 - SQ(pz)/2.0 + (SQ(py)*SQ(pz))/3.0 );
    pointsY[pos]=py * sqrt( 0.5- SQ(pz)/2.0 + SQ(pz)/3.0 );
    pointsZ[pos]=pz * sqrt( 0.5 - SQ(py)/2.0 + SQ(py)/3.0 );
    pos++;
   }
  }
  R=pos;
   //bottom face
  for ( px=-unit2; px<=unit2; px+=deltaunit ) {
   for ( pz=-unit2; pz<=unit2; pz+=deltaunit ) {
    pointsX[pos]= px * sqrt( 0.5 - SQ(pz)/2.0 + SQ(pz)/3.0 );
    pointsY[pos]=  1 * sqrt( 1.0 - SQ(pz)/2.0 - SQ(px)/2.0 + (SQ(pz)*SQ(px))/3.0 );
    pointsZ[pos]= pz * sqrt( 0.5 - SQ(px)/2.0 + SQ(px)/3.0 );
    pos++;
   }
  }
  D=pos;
  //top face
  for ( px=-unit2; px<=unit2; px+=deltaunit ) {
   for ( pz=-unit2; pz<=unit2; pz+=deltaunit ) {
    pointsX[pos]= px * sqrt( 0.5 - SQ(pz)/2.0 + SQ(pz)/3.0 );
    pointsY[pos]= -1 * sqrt( 1.0 - SQ(pz)/2.0 - SQ(px)/2.0 + (SQ(pz)*SQ(px))/3.0 );
    pointsZ[pos]= pz * sqrt( 0.5 - SQ(px)/2.0 + SQ(px)/3.0 );
    pos++;
   }
  }
  U=pos;
  v1=0;
  v2=res+1;
  for (var i=0;i<arraySize;i++){
   if (i==(arraySize-1)){
    pointsX[i]=pointsX[i-1];
   	pointsY[i]=pointsY[i-1];
   	pointsZ[i]=pointsZ[i-1];
    continue;
   }
   pointsX[i] *= r;
   pointsY[i] *= r;
   pointsZ[i] *= r;
  }
  
  var side=[];
  
//polygon generation
  var count=0;
  var rD=1.0/res;
  for (var k=0; k<6; k++){
   side[k]=VBOs.VNTC();
   VBOs.Begin(side[k]);
   var tcx=0.0;
   for (var j=0; j<=res; j++){//per x
    var tcy=1.0;
    for (var i=0; i<=res;i++){//per y                     // 
     if (i==res) {v1++; v2++; break;}                     // v1+1    __  v2+1 
	    count++;                                          //      |\   | 
	    //two triangles together per column segment       // |    | \ 2|
                                                          //      |1 \ |
                                                          // v1   |__ \| v2 (v2-1)
   	 if ((k==4||k==3)&&j==res) {v1++;v2++; continue;}  
     if ( k==5&&j==res) {v1++;v2++; break;}   
     if ( k == 4 ) { // bottom
	  v1++;
      var xU=tcx;
	  var xV=tcx+rD;
      var yU=1.0-tcy;
	  var yV=1.0-(tcy-rD); // Y is inverted on bottom face
	  var p1=CMS_TriVNT(pointsX[v1], pointsY[v1], pointsZ[v1], xU, yV);
	  var p2=CMS_TriVNT(pointsX[v2], pointsY[v2], pointsZ[v2], xV, yU);
      v1--;
	  var p3=CMS_TriVNT(pointsX[v1], pointsY[v1], pointsZ[v1], xU, yU);
	  CMS_MakeTri( side[k], p1,p2,p3 )
      v2++;
      v1++;
	  var q1=CMS_TriVNT( pointsX[v2], pointsY[v2], pointsZ[v2], xV, yV );
	  var q2=CMS_TriVNT( pointsX[v2-1], pointsY[v2-1], pointsZ[v2-1], xV, yU );
	  var q3=CMS_TriVNT( pointsX[v1], pointsY[v1], pointsZ[v1], xU, yV );
	  CMS_MakeTri( side[k], q1,q2,q3 )
     } else { // other faces
      var xU=tcx;
	  var xV=tcx+rD;
      var yU=tcy;
	  var yV=tcy-rD;
	  var p1=CMS_TriVNT(pointsX[v1], pointsY[v1], pointsZ[v1], xU, yU);
      v1++;
	  var p2=CMS_TriVNT(pointsX[v2], pointsY[v2], pointsZ[v2], xV, yU);
      v2++;
	  var p3=CMS_TriVNT(pointsX[v1], pointsY[v1], pointsZ[v1], xU, yV);
	  CMS_MakeTri( side[k], p1,p2,p3 );
	  var q1=CMS_TriVNT( pointsX[v2], pointsY[v2], pointsZ[v2], xU, yV );
	  var q2=CMS_TriVNT( pointsX[v2-1], pointsY[v2-1], pointsZ[v2-1], xV, yU );
	  var q3=CMS_TriVNT( pointsX[v1], pointsY[v1], pointsZ[v1], xV, yV );
	  CMS_MakeTri( side[k], q1,q2,q3 )
     }
     tcy-=rD;
    }//end i
    tcx+=rD;
   }//end j
   VBOs.End(side[k]);
   VBOs.Freeze(side[k]);
  }//end k
  
  return {
	  front: side[0],	  right:  side[1], 
	  back: side[2], 	  left:   side[3], 
	  top: side[4],    	  bottom: side[5]
 };
}

function CMS_DrawShaderVBO( sprite_id, image_id, shader_id, vbo_id ) {
 var tex = sprite_get_texture(sprite_id,image_id);
 shader_set(shader_id);
 vertex_submit(vbo_id, pr_trianglelist, tex);
 shader_reset();
}

function CMS_DrawShaderCMS( cms, cubebox_sprite, shader_id ) {
	CMS_DrawShaderVBO( cubebox_sprite, FRONT_ID,  shader_id, cms.front  );
	CMS_DrawShaderVBO( cubebox_sprite, RIGHT_ID,  shader_id, cms.right  );
	CMS_DrawShaderVBO( cubebox_sprite, BACK_ID,   shader_id, cms.back   );
	CMS_DrawShaderVBO( cubebox_sprite, LEFT_ID,   shader_id, cms.left   );
	CMS_DrawShaderVBO( cubebox_sprite, TOP_ID,    shader_id, cms.top    );
	CMS_DrawShaderVBO( cubebox_sprite, BOTTOM_ID, shader_id, cms.bottom );
}

function CMS_DrawVBO( sprite_id, image_id, vboo ) {
 var tex = sprite_get_texture(sprite_id,image_id);
 VBOs.Draw(vboo,tex);
}

function CMS_DrawCMS( cms, cubebox_sprite ) {
	CMS_DrawVBO( cubebox_sprite, FRONT_ID,  cms.front  );
	CMS_DrawVBO( cubebox_sprite, RIGHT_ID,  cms.right  );
	CMS_DrawVBO( cubebox_sprite, BACK_ID,   cms.back   );
	CMS_DrawVBO( cubebox_sprite, LEFT_ID,   cms.left   );
	CMS_DrawVBO( cubebox_sprite, TOP_ID,    cms.top    );
	CMS_DrawVBO( cubebox_sprite, BOTTOM_ID, cms.bottom );
}

function CMS_DrawTexCMS( cms, sprite_F, sprite_R, sprite_B, sprite_L, sprite_U, sprite_D ) {
	CMS_DrawVBO( sprite_F, 0, cms.front  );
	CMS_DrawVBO( sprite_R, 0, cms.right  );
	CMS_DrawVBO( sprite_B, 0, cms.back   );
	CMS_DrawVBO( sprite_L, 0, cms.left   );
	CMS_DrawVBO( sprite_U, 0, cms.top    );
	CMS_DrawVBO( sprite_D, 0, cms.bottom );
}
