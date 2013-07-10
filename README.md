tree-interpolator
=================

A PovRay powered tree interpolator for creating forest digital surface models from LiDAR point clouds.

This is a project which puts verisimilitude at or above the level of veracity, i. e. it will create a surface model of a forest canopy down to the last little leaf, in the absence of that level of detail in the LiDAR dataset itself.



Requirements:

Linux Machine Running Wine
rapidlasso's LASTools: http://rapidlasso.com/lastools/
PovRay 3.6 or later: http://povray.org/
Bourne Again Shell (BASH)

Written (ATM) in BASH, this code does a few simple things:
0. Uses lasheight to calculate the height of all points above ground
1. Uses las2las to remove class 1 and 2 in the LiDAR data, leaving class 5 (tall vegetation)
2. Converts the las to text and manipulates it to be the following:
  * Coordinate file of XY laspoints
