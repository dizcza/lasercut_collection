$fn = 128;

t = 1.2;  // material thickness
h = 70;   // total height
d1 = 65;  // bottom
d2 = 65;  // top

board_thickness = 1.6 + 0.1;
board_width = 46;
cut_length = 40;


module hook(w=10, depth=3) {
    translate([-w/2, 0, 0])
    difference() {
        cube([w, depth+t, board_thickness + t]);
        translate([0, t, 0])
        cube([w, depth, board_thickness]);
    }
}


module hook_array(shift=10) {
    translate([shift, -board_width/2-t, h]) hook();
    translate([-shift, -board_width/2-t, h]) hook();
    mirror([0, 1, 0]) translate([shift, -board_width/2-t, h]) hook();
    mirror([0, 1, 0]) translate([-shift, -board_width/2-t, h]) hook();
}


module main(square_type=true) {
    if (square_type) {
        linear_extrude(height=h)
        difference() {
            square([cut_length + 2 * t, board_width + 2 * t], center=true);
            square([cut_length, board_width], center=true);
        }
    } else {
        difference() {
            cylinder(h=h, d1=d1, d2=d2);
            cylinder(h=h-t, d1=d1-2*t, d2=d2-2*t);
            translate([0, 0, h])
            cube([cut_length, board_width, 10], center=true);
        }
    }
    hook_array();
}


main();
