include <lasercut.scad>; 

$fn = 60;

// The wood thickness
thickness = 3.0;

X = 75 + 2 * thickness;
Y = 60 + 2 * thickness;
Z = 37 + 2 * thickness;


DC55_21_diam = 10.8;

cutouts_count = 10;
cutouts_thickness = 3;
cutouts_height = 20;
cutouts_offset = 7;
cutouts_step = (X - 2 * (cutouts_offset + thickness)) / (cutouts_count - 1);

cutouts_vent = [for (i = [0:cutouts_count-1]) [i * cutouts_step + cutouts_offset - cutouts_thickness / 2, 7, cutouts_thickness, cutouts_height]];
DC55_21_hole = [[DC55_21_diam / 2, 25, Y / 2 - thickness]];


color("Gold",0.75)
lasercutoutBox(thickness=thickness, x=X, y=Y, z=Z, sides=6, num_fingers=4,
    cutouts_a = [
        [],
        [],
        cutouts_vent,
        cutouts_vent,
    ],
    circles_remove_a = [
        [],
        [],
        [],
        [],
        DC55_21_hole,
        DC55_21_hole,
    ]
);