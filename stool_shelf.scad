include <lasercut.scad>; 

$fn = 60;

// The wood thickness
thickness = 3.0;


X = 125;
Y = 167;
Z = 150;


color("Gold",0.75)
lasercutoutBox(thickness=thickness, x=X, y=Y, z=Z, sides=3, num_fingers=4,
    cutouts_a = [[], [], [[0, 20, 60, 70]]]
);
