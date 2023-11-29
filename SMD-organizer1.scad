include <lasercut.scad>; 

$fn = 60;

n_layers = 9;

thickness = 3.0;
x = 165 + thickness;
y = 310 + 2 * thickness;
h = 30 + thickness;
z = h * n_layers + thickness;

//echo("Dimensions (x, y, z):", x, y, z);

r_hole = 0.75;
dist_hole = 4;
height_hole = z/4;

step = x / 5;


layer_indices = [1:1:n_layers-1];


function simple_tabs_layer_x(layer_id) = [for (xi = [step:step:x]) [MID, xi-thickness/2, h * layer_id - thickness]];


function simple_tabs_layer_y(layer_id) = [for (yi = [step:step:y-step]) [MID, h * layer_id - thickness, yi-thickness/2]];


simple_tabs_x = [for (i = layer_indices) each simple_tabs_layer_x(i)];
simple_tabs_y = [for (i = layer_indices) each simple_tabs_layer_y(i)];


color("Gold",0.75)
lasercutoutBox(thickness=thickness, x=x, y=y, z=z,
    sides=5, num_fingers=4,
    simple_tab_holes_a=[
        [], [],
        simple_tabs_x,
        simple_tabs_x,
        simple_tabs_y
    ],
);


module layerWithTabs(layer_id=1) {
    translate([thickness, thickness, h * layer_id])
    lasercutoutSquare(thickness=thickness, x=x-thickness, y=y-2*thickness,
        simple_tabs=concat(
            [for (xi = [step:step:x-step]) [DOWN, xi, 0]],
            [for (xi = [step:step:x-step]) [UP, xi, y-2*thickness]],
            [for (yi = [step:step:y-step]) [LEFT, 0, yi]]
        )
    );
}


for (i = [1:1:n_layers-1]) layerWithTabs(i);
