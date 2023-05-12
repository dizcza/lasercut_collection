include <lasercut.scad>; 

$fn = 60;

// The wood thickness
thickness = 3.0;

X1 = 95;  // DPS3005 space
X2 = 30;  // Banana plug space
Y = 65;
Z = 65;

X = X1 + X2;

DC55_21_diam = 10.5;
D_banana = 5.5;

DPS_hole_x = 76;
DPS_hole_z = 39;

cutouts_count = 7;
cutouts_thickness = 2;
cutouts_height = 20;
cutouts_offset = 10;
cutouts_step = (Y - 2 * (cutouts_offset + thickness)) / (cutouts_count - 1);
cutouts_array = [for (yi = [0:cutouts_count-1]) [25, yi * cutouts_step + cutouts_offset - cutouts_thickness / 2, cutouts_height, cutouts_thickness]];

echo(cutouts_array);


color("Gold",0.75)
lasercutoutBox(thickness=thickness, x=X, y=Y, z=Z, sides=6, num_fingers=4,
    cutouts_a = [
        [],
        [],
        [[X2 + (X1 - DPS_hole_x) / 2 - thickness, (Z - DPS_hole_z) / 2 - thickness, DPS_hole_x, DPS_hole_z]],
        [],
        cutouts_array,
        cutouts_array
    ],
    circles_remove_a = [
        [],
        [],
        [[D_banana / 2, X2 / 2 + thickness, 15], [D_banana / 2, X2 / 2 + thickness, 40]],
        [[DC55_21_diam / 2, X / 2 - thickness, Y / 2]],
    ]
);