tree-interpolator
=================

A PovRay-powered tree interpolator for creating forest digital surface models from LiDAR point clouds.

This is a project which puts verisimilitude at or above the level of veracity, i. e. it will create a surface model of a forest canopy down to the last little leaf, in the absence of that level of detail in the LiDAR dataset itself.

This output is accomplished by using (effectively) a 3D tree "stamp" which is placed at each and every LiDAR point, and scaled to the height above groun of that point.  See https://smathermather.wordpress.com/tag/lidar/ for more info.

**Requirements:**

* Linux Machine Running Wine
* rapidlasso's LASTools: http://rapidlasso.com/lastools/
* PovRay 3.6 or later: http://povray.org/
* Bourne Again Shell (BASH)
(PovRay, LASTools, tree.inc, and treepov.inc are included in your path)

Written (ATM) in BASH, this code does a few simple things:
* Uses lasheight to calculate the height of all points above ground
* Uses las2las to remove class 1 and 2 in the LiDAR data, leaving class 5 (tall vegetation)
* Converts the las to text and creates:
  * File of coordinates of XY laspoints, as a PovRay array and an array of point heights from ground.  XY array is used to place tree "stamp", point height array used to scale stamp size in XYZ dimensions
  * PovRay File for rendering (*.pov) to PNG (*.png)
  * Executes the render of the PNG
  * World file (*.pgw) to reference the PNG into your coordinate system.



tree.inc is a triangular mesh of a tree generated using Pov-Tree, now defunct but available at the illustrious Internet Archive: http://web.archive.org/web/*/http://propro.ru/go/Wshop/povtree/povtree.html (in case you want a different tree shape).
treepov.inc is the additional code needed create the renderable povray document

**Usage**
```SHELL
tree-interpolator.sh input.las output-name width-height pixel-size
```
e.g.
```SHELL
./tree-interpolator.sh input.las Licking 5000 10 
```
