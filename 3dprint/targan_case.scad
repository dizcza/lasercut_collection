$fn = 64;

t = 1.6;

// External dimensions
X = 210;
Y = 145;
Z = 75;

// Flange M4 inner and outer diameters
d_M4_outer = 11;
d_M4_inner = 5.25;


module flangeM4(h=Z) {
    difference() {
        cylinder(h=h, d=d_M4_outer, center=false);
        cylinder(h=h, d=d_M4_inner, center=false);
        translate([0, 0, h-1]) cylinder(h=1, d1=d_M4_inner, d2=d_M4_inner + 2, center=false);
        cylinder(h=1, d1=d_M4_inner + 2, d2=d_M4_inner, center=false);
    }
}


module flangeM3(h_drill=6) {
    d_inner = 3.85;
    d_outer = d_inner + 2*t;
    h = h_drill + t;
    difference() {
        cylinder(h=h, d=d_outer, center=false);
        translate([0, 0, t]) cylinder(h=h_drill, d=d_inner, center=false);
        translate([0, 0, h-1.5]) cylinder(h=1.5, d1=d_inner, d2=d_inner + 1, center=false);
    }
}


module flangesM3_matek(x=30.5) {
    flangeM3();
    translate([x, 0, 0]) flangeM3();
    translate([x, x, 0]) flangeM3();
    translate([0, x, 0]) flangeM3();
}


module flanges_outer(x=d_M4_outer/2) {
    translate([x, x, 0]) flangeM4();
    translate([X - x, Y - x, 0]) flangeM4();
    translate([X - x, x, 0]) flangeM4();
    translate([x, Y - x, 0]) flangeM4();
}

module m4_holes(d, x=d_M4_outer/2, z=0) {
    translate([x, x, z]) cylinder(h=t, d=d);
    translate([X - x, Y - x, z]) cylinder(h=t, d=d);
    translate([X - x, x, z]) cylinder(h=t, d=d);
    translate([x, Y - x, z]) cylinder(h=t, d=d);
}


module walls_extra(margin=0.0) {
    translate([0, Y-t, 0]) cube([d_M4_outer+margin, t, Z]);
    translate([X-d_M4_outer-margin, Y-t, 0]) cube([d_M4_outer+margin, t, Z]);
}


module wifi_holes() {
    translate([t, 0, 0])
    rotate([0, -90, 0])
    linear_extrude(h=t) {
        translate([11.5+t, 66+15]) circle(d=15);
        translate([11.5+t, 100+15]) circle(d=15);
    }
}


module bottom_case() {
    hole_size_y = 35;
    hole_size_z = 25;
    difference() {
        cube([X, Y, Z]);
        translate([t, t, t]) cube([X-2*t, Y, Z]);
        translate([X - t, Y - d_M4_outer - hole_size_y, t+2]) cube([t, hole_size_y, hole_size_z]);
        m4_holes(d=d_M4_inner, z=0);
        wifi_holes();
    }
    walls_extra();
    translate([X - 40, Y - 45, 0]) flangesM3_matek();
    %translate([t, 15, t]) cube([110, 115, 30]);
    flanges_outer();
}


module top_case_half1() {
    cut_x = 20;
    cut_y = 30;
    difference() {
        cube([X, Y, Z]);
        cube([X, Y-t, Z-t]);
        cube([X, Y/2, Z]);
        translate([X-cut_x, Y/2, 0]) cube([cut_x, cut_y, Z]);
        walls_extra(margin=0.25);
        m4_holes(d=4.4, z=Z-t);
    }
}


module top_case_half2(margin=0.25) {
    difference() {
        cube([X, Y/2-margin, t]);
        m4_holes(d=4.4, z=0);
    }
}

//bottom_case();
top_case_half1();
//top_case_half2();
//wifi_holes();