#!/bin/sh

# lasmerge -i N2170660.las  -i N2175660.las  -i N2175665.las  -i N2180665.las -o west.las
# merge your las files first...

# Calculate Tree height using lasheight--
# replace the z value with a height value
# allows for floating point z value

echo "		 								Calculating Tree Height..."
lasheight.exe -i $1 -replace_z -o $2.las

# Eliminate all but tall vegetation (class 5)

echo "		 								Eliminating non-veg points..."
#las2las -i $2.las -eliminate_class 2 -o $2.out.las
#las2las -i $2.out.las -eliminate_class 1 -o $2.out.out.las

las2las -i $2.las -eliminate_class 1 2 -o $2.out.out.las

las2txt $2.out.out.las $2.txt
# Count how many points we have from the las file
# (Could this be extracted from Standard Error from last step?)
numlines=`more $2.txt | grep -v ' 0' | ~/Documents/CM/Canopy/./linecount.o`
echo " 										$numlines points in resultant las."

# Build include files of tree locations and heights for PovRay rendering
echo "#declare tree_coords = array["$numlines"]{" > $2_coords.inc
more $2.txt | grep -v ' 0' | awk '{print "<" $1 ", 0, " $2 ">" };' >> $2_coords.inc
echo "} #declare tree_height = array["$numlines"]{" >> $2_coords.inc
more $2.txt | grep -v ' 0' |  awk '{ print $3 "," };' >> $2_coords.inc
echo '}' >> $2_coords.inc

# Calculate extent of point cloud using lasboundary and ogrinfo
lasboundary.exe -convex -i $2.out.out.las -o $2.out.shp

bb=`ogrinfo -ro -al -so -geom=NO $2.out.shp | grep Extent | tr '(' ' ' | tr ')' ' ' | tr ',' ' '`
minx=`echo $bb | awk '{print $2};'`
miny=`echo $bb | awk '{print $3};'`
maxx=`echo $bb | awk '{print $5};'`
maxy=`echo $bb | awk '{print $6};'`

width=`echo "$maxx - $minx" | bc`
height=`echo "$maxy - $miny" | bc`

# Calculate center of point cloud
centerx=`echo "($maxx + $minx) / 2" | bc`
centery=`echo "($maxy + $miny) / 2" | bc`

# Set camera size, pixel size and image size 
camera_size=$3
pixel_size=$4
image_size=`echo "scale=20; $camera_size / $pixel_size" | bc`

ulx=`echo "scale=20; $centerx - $camera_size / 2" | bc`
uly=`echo "scale=20; $centery + $camera_size / 2" | bc`

# Using what we know, let's build the pov file for rendering
echo "//Set the center of image" > $2.pov
echo "\n" >> $2.pov
echo "#version 3.6;" >> $2.pov
echo "#declare scene_center_x=$centerx;" >> $2.pov
echo "#declare scene_center_y=$centery;" >> $2.pov

echo "//Include locations and heights for trees." >> $2.pov
echo '#include "'$2'_coords.inc"' >> $2.pov

echo "#declare Camera_Size = $camera_size;" >> $2.pov

more treepov.inc >> $2.pov

# And render...
povray +I$2.pov +O$2.png +FN16 +W$image_size +H$image_size +A +D

# Now time to create a world file to georeference

echo $pixel_size > $2.pgw
echo 0 >> $2.pgw
echo 0 >> $2.pgw
echo -$pixel_size >> $2.pgw
echo $ulx >> $2.pgw
echo $uly >> $2.pgw
