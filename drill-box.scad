include <lasercut.scad>; 

$fn = 60;

thickness = 3.0;
pad_battery = 4.0;

L = 210;
H = 45 + 2 * pad_battery + 2 * thickness;
W1 = 80;
W2 = 30;

W = W1 + pad_battery + W2 + 2 * thickness;

D1 = 7.4;
D2 = 3.6;

y_face = H / 2 - D2;

H_in = H - 2 * thickness;
L_in = L - 2 * thickness;

rocker_l = 13.8;
rocker_w = 9.0;


step1 = L_in / 7;

function tab_inner_holes() = [ for (i = [1 : 6]) [MID, step1 * i, W2] ];


lasercutoutBox(thickness=thickness, x=L, y=W, z=H, sides=6, num_fingers=4,
    cutouts_a = [
        [],
        [],
        [[40, H/2 - rocker_w, rocker_l, rocker_w]],
        [],
        [[pad_battery,W2 + thickness - 0.1,H - 4 * pad_battery,W1 - pad_battery]]
    ],
    simple_tab_holes_a=[
        tab_inner_holes(),
        tab_inner_holes(),
        [],
        [],
        [[MID, H/2 - 1.5*thickness, W2]],
        [[MID, H/2 - 1.5*thickness, W2]]
    ],
    circles_remove_a = [
        [],
        [],
        [[D2 / 2, 100, y_face], [D2 / 2, 125, y_face]],
    ],
);



translate([thickness, W2 + thickness, thickness]) rotate([0, -90, -90])
%lasercutoutSquare(thickness=thickness, x=H_in, y=L_in,
    simple_tabs=concat(
        [[UP, H_in/2, L_in], [DOWN, H_in/2, 0], [UP, H_in + thickness/2, step1]],
        [ for (i = [1 : 6]) [UP, H_in + thickness/2, step1 * i] ],
        [ for (i = [1 : 6]) [UP, -thickness/2, step1 * i] ]
    ),
    circles_remove = [
        [D1 / 2, H_in/2, 20]
    ]
);