$fn = 128;

t = 1.6;
d_outer = 74.75;
h_outer = 35;
d_start = 50;
d_finish = 7;
h_start = 30;
h_cap = 45;


module cap(inner=false) {
    T = inner ? t : 0;
    cylinder(h=h_outer-T, d=d_outer-2*T);
    translate([0, 0, h_outer-T]) cylinder(h=h_start+T, d=d_start-2*T);
    //translate([0, 0, h_outer+h_start-T]) cylinder(h=h_cap, d1=d_start-2*T, d2=d_finish-T);
}


module top_cap() {
    translate([0, 0, h_outer+h_start-t])
    for (angle=[15:30:360]) {
        rotate([0, 0, angle])
        translate([d_start/2-t, -t/2, 0])
        cube([t, t, t], center=false);
    }
}


module holes(layer=0, h_cell=4) {
    step = layer < 4 ? 30 : 60;
    for (angle=[0:step:360]) {
        rotate([0, 0, angle])
        translate([0, 0, h_outer+h_start+h_cell/2 + layer * (h_cell+t)]) cube([10-1.2*(layer), d_start, h_cell], center=true);
    }
}


module holder() {
    d_holder = 33;
    x_holder = 40;
    intersection() {
        translate([0, -x_holder, 0])
        difference() {
            cylinder(h=h_outer, d=d_holder);
            cylinder(h=h_outer, d=d_holder-2*t);
        }
        cap();
    }
}


module main() {
    difference() {
        cap();
        cap(inner=true);
        holes(layer=0);
        holes(layer=1);
        holes(layer=2);
        holes(layer=3);
        holes(layer=4);
        holes(layer=5);
        holes(layer=6);
        holes(layer=7);
        top_cap();
    }
    holder();
    mirror([0, 1, 0]) holder();
}


main();
top_cap();