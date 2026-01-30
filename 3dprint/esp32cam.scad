$fn = 64;

X = 62;
Y = 34;
Z = 10.5;

t = 1.6;
usb_wall = 4.0;

d_outer = 8;
d_inner = 3.85;
drill_offset = 0.0;


module flange(h_drill=7, diff=false) {
    if (diff) {
        cylinder(h=h_drill, d=d_inner, center=false);
        cylinder(h=1.5, d1=d_inner + 1, d2=d_inner, center=false);
    } else {
        cylinder(h=Z, d=d_outer, center=false);
    }
}

module flanges(diff=false) {
    x_offset = drill_offset;
    translate([X - x_offset, x_offset, 0]) flange(diff=diff);
    translate([X - x_offset, Y - x_offset, 0]) flange(diff=diff);
    translate([x_offset, x_offset, 0]) flange(diff=diff);
    translate([x_offset, Y - x_offset, 0]) flange(diff=diff);
}

module espcam_solid() {
    difference() {
        cube([X, Y, Z], center=false);
        translate([t, t, 0]) cube([X - 2 * t, Y - 2 * t, Z - t], center=false);
        translate([X-5, usb_wall, 2]) cube([20, Y - 2 * usb_wall, 6], center=false);
        translate([X - 41.5, Y/2, Z-5]) cylinder(h=10, d=9, center=true);
    }
    flanges();
}


module espcam() {
    difference() {
        espcam_solid();
        flanges(diff=true);
    }
}


module lid(d=3.6) {
    linear_extrude(height=t) {
    difference() {
        projection() {
            flanges(diff=false);
            cube([X, Y, Z], center=false);
        }
        x_offset = drill_offset;
        translate([X - x_offset, x_offset]) circle(d=d);
        translate([X - x_offset, Y - x_offset]) circle(d=d);
        translate([x_offset, x_offset]) circle(d=d);
        translate([x_offset, Y - x_offset]) circle(d=d);
    }
    }
}

translate([0, 45, 0]) lid();
espcam();