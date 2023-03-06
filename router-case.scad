include <lasercut.scad>; 


length = 310;
width = 190;
h1 = 60;
h2 = 180;

thickness = 3.0;


height_total = h1 + h2;

n_inner_tabs = 4;
x_tab_space = width / (n_inner_tabs + 1);


bottom_hole_offset_x = 15;
bottom_hole_offset_h = thickness + 3;
bottom_hole_h = h1 - 20;


tab_inner_holes = [ for (i = [1 : n_inner_tabs]) [MID, i * x_tab_space - thickness/2, h1] ];


module stut()
{
    function tabs_inner(side, y) = [ for (i = [1 : n_inner_tabs]) [side, i * x_tab_space, y] ];

    tabs_right = tabs_inner(UP, length-thickness*2);
    tabs_left = tabs_inner(DOWN, 0);

    translate([0, thickness, thickness + h1])
    lasercutoutSquare(thickness=thickness, x=width, y=length-thickness*2, simple_tabs=concat(tabs_right, tabs_left)
    );
}


color("Gold",0.75)
lasercutoutBox(thickness=thickness, x=width, y=length, z=height_total, sides=4, num_fingers=4,
    simple_tab_holes_a=[
        [], [], tab_inner_holes, tab_inner_holes
    ],
    cutouts_a = [
        [], [], [[bottom_hole_offset_x, bottom_hole_offset_h, width - 2 * bottom_hole_offset_x, bottom_hole_h]]
    ]
);
stut();