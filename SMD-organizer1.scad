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

step_x = x / 3;
step_y = y / 4;

cutout_sz = 15;

hole_extra = 0.15;
thickness_hole = thickness + hole_extra;
cutout_hole = cutout_sz;

layer_indices = [1:1:n_layers-1];

manifoldCorrection = 0.1;


function cutout_tabs_layer_x(layer_id) = [for (xi = [step_x:step_x:x-step_x]) [xi-cutout_hole/2, h*layer_id-thickness_hole, cutout_hole, thickness_hole]];

function cutout_tabs_layer_y(layer_id) = [for (yi = [step_y:step_y:y-step_y]) [h*layer_id-thickness_hole, yi-cutout_hole/2-thickness, thickness_hole, cutout_hole]];


cutout_tabs_x = [for (i = layer_indices) each cutout_tabs_layer_x(i)];
cutout_tabs_y = [for (i = layer_indices) each cutout_tabs_layer_y(i)];


module floorLayer(layer_id=1) {
    x_cut = 10;
    y_leave = 20;
    translate([thickness, thickness, thickness / 2 + h * layer_id])
    fillet(1)
    difference() {
        union() {
            square([x - thickness, y - 2 * thickness], center=false);
            for (xi = [step_x:step_x:x-step_x]) {
                for (yi = [0, y - 2 * thickness]) {
                    translate([xi-cutout_sz/2, -thickness + yi])
                    square([cutout_sz, 2*thickness], center=false);
                }
            }
            for (yi = [step_y:step_y:y-step_y]) {
                translate([-thickness, yi-cutout_sz/2-thickness])
                square([2*thickness, cutout_sz], center=false);
            }
        }
        translate([x - thickness - x_cut, y_leave])
        square([x_cut, y - 2 * thickness - 2 * y_leave], center=false);
    }
}


module box() {
    color("Gold",0.75)
    lasercutoutBox(thickness=thickness, x=x, y=y, z=z,
        sides=5, num_fingers=4,
        cutouts_a = [[], [],
            cutout_tabs_x,
            cutout_tabs_x,
            cutout_tabs_y
        ]
    );
}

//floorLayer(); translate([0, y, 5]) mirror([0, 1]) floorLayer();
for (i = [1:1:n_layers-1]) floorLayer(i);
box();