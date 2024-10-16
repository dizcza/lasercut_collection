include <lasercut.scad>; 

$fn = 60;

// The wood thickness
thickness = 4.0;

X = 85 + 2 * thickness;
Y = 70 + 2 * thickness;
Z = 48 + 2 * thickness;

display_length = 45;
display_height = 26.5;

rocker_l = 13.8;
rocker_w = 8.9;


DC55_21_diam = 11;

cutouts_count = 10;
cutouts_thickness = 2;
cutouts_height = 30;
cutouts_offset = 7;
cutouts_step = (X - 2 * (cutouts_offset + thickness)) / (cutouts_count - 1);

cutouts_vent = [for (i = [0:cutouts_count-1]) [i * cutouts_step + cutouts_offset - cutouts_thickness / 2, 10, cutouts_thickness, cutouts_height]];
DC55_21_hole = [[DC55_21_diam / 2, 10, Y / 2 - thickness]];

M2_5_d = 2.9;

xt60_x0 = 15;
xt60_y0 = 7;


//color("Gold",0.75)
lasercutoutBox(thickness=thickness, x=X, y=Y, z=Z, sides=6, num_fingers=4,
    cutouts_a = [
        [],
        [],
        cutouts_vent,
        cutouts_vent,
        [[19, 4, rocker_l, rocker_w], [19, 22, display_height, display_length], [xt60_y0 - 8.1/2, xt60_x0 + (20.5 - 15.5)/2, 8.1, 15.5]],
        []
    ],
    circles_remove_a = [
        [],
        [],
        [],
        [],
        [[M2_5_d / 2, xt60_y0, xt60_x0], [M2_5_d / 2, xt60_y0, xt60_x0 + 20.5]],
        [[DC55_21_diam / 2, 30, Y / 2 - thickness]],
    ]
);