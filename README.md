CubeMappedSphereGML
===================

The generation of a vertex buffer sphere that can be textured in a 6-sided fashion, to permit the use of inverted skyboxes (really: cube-faced surface textures) as a source for planetary and spheroid surfaces.  Generalized algorithm permits both high and low resolution.   Call Init_CubeMappedSphere() once to generate two fine examples.  Now you two, one low and one high resolution, 6-side spheres.  You can then provide 6-sided skybox-like things and have it display textured.  There are some interesting ways to achieve this using certain legacy graphics utilities, and some freeware, or creativity in a paint program.  Try using skybox textures, since they are readily available, and it will look like you have a cloudy planet.  Add shaders and blending with multiple redraws and you will get something like https://www.indiedb.com/games/empire-in-the-sky/images/more-planets1#imagebox
 
Background:
 https://gamedev.stackexchange.com/questions/108667/how-to-load-a-spherical-planet-and-its-regions

The above stackexchange article discusses scalable planetoids but we are talking about the macro not the micro version of this sphere, so you cannot rely on this library to, for example, fly all the way into a high resolution planet like you can in NoManSky.  It's just a one-off single LOD sphere that is generated based on your inputs.

Also included:

- CAM3D, the beginning of a 3D camera wrangling library
- VBO, the Vertex Buffer Object wrangler based on the discoveries made in https://github.com/LAGameStudio/apolune
- A test case.

This example uses no shaders.  You could easily add shaders to this pipeline.
