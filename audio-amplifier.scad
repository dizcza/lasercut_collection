include <lasercut.scad>; 

$fn = 60;

thickness = 3.0;

x0 = 80;
x_mic_cover = 100;
x_battery = 80;
length_total = x0 + x_battery;
height_total = 90;
width = 163;

rocker_l = 13.8;
rocker_w = 9.0;

height_hole = 10;
cutouts_air = [for (yi = [12:10:width - 12]) [10, yi, 10, 3]];

n_inner_tabs = 3;

tabs_l = 35;
y_tab_space = tabs_l / (n_inner_tabs + 1);

w_pad = 10;

stut_h = 10;

function tab_inner_holes(y) = [ for (i = [1 : n_inner_tabs]) [MID, 20 - thickness, i * y_tab_space - thickness + y] ];


module stut(y=10)
{
    tabs_inner = [ for (i = [1 : n_inner_tabs]) [UP, 10, i * y_tab_space] ];

    translate([20, y, thickness + stut_h])
    rotate([0, 90, 0])
    lasercutoutSquare(thickness=thickness, x=stut_h, y=tabs_l, simple_tabs=tabs_inner);
}

color("Gold",0.75)
lasercutoutBox(thickness=thickness, x=length_total, y=width, z=height_total, sides=6, num_fingers=4,
    cutouts_a = [
        [],
        [[length_total-x_mic_cover - 15, w_pad, x_mic_cover, width - 2 * w_pad - 2 * thickness]],
        [],
        [[35, 35, rocker_l, rocker_w], [80, 10, 40, 20]],
        concat([[50, width - 7.5 - 2 * thickness - 2, 20, 7.5]], cutouts_air)
    ],
    simple_tab_holes_a=[
        concat(tab_inner_holes(10), tab_inner_holes(90))
    ],
);

stut(y=10);
stut(y=90);