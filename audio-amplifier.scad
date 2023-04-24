include <lasercut.scad>; 

$fn = 60;

thickness = 3.0;

x0 = 80;
speaker_w = 99;
x_battery = 80;
length_total = x0 + x_battery;
height_total = 90;
speaker_l = 162;
w_pad = 10;

module fillet(smooth) {
   offset(r = smooth) {
     offset(delta = -smooth) {
       children();
     }
   }
}

width_total = speaker_l + 2 * w_pad + 2 * thickness;


rocker_l = 13.8;
rocker_w = 9.0;

height_hole = 10;
cutouts_air = [for (yi = [20:10:width_total-20]) [10, yi, 10, 3]];

n_inner_tabs = 3;

tabs_l = 35;
y_tab_space = tabs_l / (n_inner_tabs + 1);


stut_h = 10;

function tab_inner_holes(y) = [ for (i = [1 : n_inner_tabs]) [MID, 20, i * y_tab_space - thickness + y] ];


module stut(y=10)
{
    tabs_inner = [ for (i = [1 : n_inner_tabs]) [UP, 11.5, i * y_tab_space] ];

    translate([20 + thickness, y, thickness + stut_h])
    rotate([0, 90, 0])
    lasercutoutSquare(thickness=thickness, x=stut_h, y=tabs_l, simple_tabs=tabs_inner);
}

color("Gold",0.75)
lasercutoutBox(thickness=thickness, x=length_total, y=width_total, z=height_total, sides=6, num_fingers=4,
    cutouts_a = [
        [],
        [[length_total - speaker_w - 15, w_pad, speaker_w, speaker_l]],
        [],
        [[35, 35, rocker_l, rocker_w], [80, 10, 40, 20]],
        concat([[50, width_total - 7.5 - 2 * thickness - 2, 20, 7.5]], cutouts_air)
    ],
    simple_tab_holes_a=[
        concat(tab_inner_holes(10), tab_inner_holes(90))
    ],
);


module pillar() {
    // for the charger
    fillet(0.5)
    square([27, 17]);
}

stut(y=10);
stut(y=90);

//pillar();