$fn = 128;

// Inner dimensions
X0 = 92;  // initially 93
Y0 = 72;  // initially 73
Z0 = 72;  // initially 87

t = 3.0;
t_text = 0.4;

// Bottom plastic spacer + board thickness + box thickness
h0 = 8 + t;

// Flange M4 inner and outer diameters
d_M4_outer = 11;
d_M4_inner = 5.25;

X = X0 + 2*d_M4_outer-t;
Y = Y0 + 2*d_M4_outer-t;
Z = Z0 + t;

DPS_hole_w = 75.6;
DPS_hole_h = 40.2;
D_banana = 6.5;

N_array = 6;
cut_array = 2;
step_array = 10;
offset_array = (Y - (N_array-1) * step_array)/2 + step_array/2 - cut_array + 4;


module flangeM4(h=15, diff=false) {
    if (diff) {
        translate([0, 0, Z-h]) cylinder(h=h, d=d_M4_inner, center=false);
        translate([0, 0, Z-1]) cylinder(h=1, d1=d_M4_inner, d2=d_M4_inner + 2, center=false);
    } else {
        cylinder(h=Z, d=d_M4_outer, center=false);
    }
}


module flanges_outer(diff, x=d_M4_outer/2) {
    translate([x, x, 0]) flangeM4(diff=diff);
    translate([X - x, Y - x, 0]) flangeM4(diff=diff);
    translate([X - x, x, 0]) flangeM4(diff=diff);
    translate([x, Y - x, 0]) flangeM4(diff=diff);
}


module fillet(smooth) {
   offset(r = smooth) {
     offset(delta = -smooth) {
       children();
     }
   }
}


module m4_holes(d=4.5, x=d_M4_outer/2, z=0) {
    translate([x, x, z]) cylinder(h=t, d=d);
    translate([X - x, Y - x, z]) cylinder(h=t, d=d);
    translate([X - x, x, z]) cylinder(h=t, d=d);
    translate([x, Y - x, z]) cylinder(h=t, d=d);
}


module top_cap() {
    difference() {
        linear_extrude(height=2)
        fillet(0.5)
        square([X, Y]);
        m4_holes();
    }
}


module box() {
    difference() {
        cube([X, Y, Z]);
        translate([t, t, t]) cube([X-2*t, Y-2*t, Z]);
    }
}


module xt60em() {
    scale([1, 1, 1.1])
    rotate([90, 0, 90])
    linear_extrude(height=t) {
        square([15.50, 8.10+0.2], center=true);
        translate([10, 0]) circle(d=2.7);
        translate([-10, 0]) circle(d=2.7);
    }
}


module xt60e() {
    scale([1, 1, 1.1])
    rotate([90, 0, 90])
    linear_extrude(height=t) {
        square([16.50, 9.0+0.2], center=true);
        translate([12.5, 0]) circle(d=2.7);
        translate([-12.5, 0]) circle(d=2.7);
    }
}

module main() {
    difference() {
        union() {
            box();
            flanges_outer(diff=false);        
        }
        flanges_outer(diff=true);
        
        translate([(X - DPS_hole_w) / 2, 0, 18+h0])
        cube([DPS_hole_w, t, DPS_hole_h]);
        
        translate([0, 50, 40]) xt60em();
        translate([X-t, 60, 40]) xt60e();
        
        translate([X-t, 28, 15+h0]) scale([1, 1, 1.1]) rotate([0, 90, 0]) cylinder(h=t, d=D_banana);
        translate([X-t, 28, 35+h0]) scale([1, 1, 1.1]) rotate([0, 90, 0]) cylinder(h=t, d=D_banana);
        
        for (i=[0:N_array-1]) {
            translate([offset_array + i * step_array, Y-t, h0+10]) cube([cut_array, t, 50]);
        }
        
        translate([t_text, 80, 50]) rotate([90, 0, -90]) linear_extrude(height=t_text) text("IN  6-60V", size=12);
        
        translate([X-t_text, 8, 58]) rotate([90, 0, 90]) linear_extrude(height=t_text) text("OUT 0-50V", size=11);
        
        //translate([(X-X0)/2, (Y-Y0)/2, 0]) cube([X0, Y0, 10]);
    }
}


main();
//top_cap();
//translate([69, 10]) rotate([90, 0, -90]) text("IN", size=12);