include <lasercut.scad>; 

$fn = 60;

// The wood thickness
thickness = 4.0;

X = 95 + 2 * thickness;
Y = 80 + 2 * thickness;
Z = 55 + 2 * thickness;

display_length = 45;
display_height = 26.5;

rocker_l = 13.8;
rocker_w = 8.9;


DC55_21_diam = 10.75;

cutouts_count = 10;
cutouts_thickness = 3;
cutouts_height = 30;
cutouts_offset = 7;
cutouts_step = (X - 2 * (cutouts_offset + thickness)) / (cutouts_count - 1);

cutouts_vent = [for (i = [0:cutouts_count-1]) [i * cutouts_step + cutouts_offset - cutouts_thickness / 2, 10, cutouts_thickness, cutouts_height]];
DC55_21_hole = [[DC55_21_diam / 2, 10, Y / 2 - thickness]];


//color("Gold",0.75)
lasercutoutBox(thickness=thickness, x=X, y=Y, z=Z, sides=6, num_fingers=4,
    cutouts_a = [
        [],
        [],
        cutouts_vent,
        cutouts_vent,
        [[23, 7, rocker_l, rocker_w], [23, 27, display_height, display_length]],
        []
    ],
    circles_remove_a = [
        [],
        [],
        [],
        [],
        DC55_21_hole,
        [[DC55_21_diam / 2, 25, Y / 2 - thickness]],
    ]
);