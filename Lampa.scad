include <lasercut.scad>; 

$fn = 60;

thickness = 3.1;
x = 120;
y = 45;
z = 30;

r_hole = 0.75;
dist_hole = 4;
height_hole = z/4;

cutouts_air = [for (xi = [0:4:x/2 - 15]) [xi + x/2, z/2-height_hole, 1.5, height_hole]];

color("Gold",0.75)
lasercutoutBox(thickness = thickness, x=x, y=y, z=z,
    sides=6, num_fingers=2,
    cutouts_a = [
            [[40, 25, 13.8, 8.9]],  // rocker
            [],
            concat([[4, -0.5, 12, 6]], cutouts_air),
            [],
            []
        ],
    circles_remove_a = [
            [[r_hole, x - 10, y/2 - dist_hole/2 - thickness],
            [r_hole, x - 10, y/2 + dist_hole/2 - thickness]],
        ]
);
