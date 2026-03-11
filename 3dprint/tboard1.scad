$fn = 128;


X = 100;
Y = 100;
Z = 7;
t = 2;

Y_offset = 1.4;  // 

d_outer = 8;
d_inner = 3.85;
drill_offset = 0.0;
dM3 = 3.2;

xc = 0.75 + dM3 / 2;


module fillet(smooth) {
   offset(r = smooth) {
     offset(delta = -smooth) {
       children();
     }
   }
}


module arc(dout=Z-2.5) {
    rotate([90, 0, 0])
    linear_extrude(height=t)
    difference() {
        intersection() {
            circle(r=dout);
            translate([-dout, 0]) square(size=dout*2);
        }
        circle(r=dout-t);
    }
}


module lcylinder(h=t, d=3, l=4) {
    linear_extrude(h=h) {
        square([l-d, d], center=true);
        translate([-(l-d)/2, 0]) circle(d=d);
        translate([(l-d)/2, 0]) circle(d=d);
    }
}


module flangeArray(x, y, y_offset=0) {
    flangeM3();
    translate([0, y, 0]) flangeM3();
    translate([x, y_offset, 0]) flangeM3();
    translate([x, y-y_offset, 0]) flangeM3();
}


module flangeM3(h_drill=Z, diff=false) {
    difference() {
        cylinder(h=Z, d=d_outer, center=false);
        cylinder(h=h_drill, d=d_inner, center=false);
        translate([0, 0, h_drill-1])
        cylinder(h=1.5, d1=d_inner, d2=d_inner + 1, center=false);
    }
}


module board_irlight() {
    // 1.4 is the dist between the hole center and the closest pad center
    // 1.4 <-- (y=15.5 - 2.54 * 5) / 2
    flangeArray(x=47, y=15.5, y_offset=1.4);
}


module board_ads1115() {
    flangeArray(x=39.5, y=36.5, y_offset=1.4);
}


module board_solenoid(x=56.5, y=36.5) {
    flangeArray(x=56.5, y=36.5);
}


module board_proximity() {
    flangeArray(x=66.5, y=26.5);
}


module main() {

    difference() {
        cube([X, Y, t]);
        translate([0, Y-16, 0]) cube([29, 16, t]);
    }
    translate([80, 96, t]) rotate([0, 0, -90]) board_irlight();
    translate([68+5+1, 56, t]) rotate([0, 0, 90]) board_ads1115();
    translate([30, 4, t]) rotate([0, 0, 90]) board_proximity();
    translate([39, 4, t]) board_solenoid();

    for (x=[10:15:X-10]) {
        translate([x, 20, t]) rotate([0, 0, -45]) arc();
        translate([x, 80, t]) rotate([0, 0, -45]) arc();
    }
    translate([10, 35, t]) rotate([0, 0, -45]) arc();
    translate([10+15, 35, t]) rotate([0, 0, -45]) arc();
    translate([10+15, 35+15, t]) rotate([0, 0, -45]) arc();
    translate([10+15*3, 35, t]) rotate([0, 0, -45]) arc();
    translate([10+15*4, 35, t]) rotate([0, 0, -45]) arc();
    translate([10+15*4, 35+15, t]) rotate([0, 0, -45]) arc();
    translate([10+15*5, 35, t]) rotate([0, 0, -45]) arc();
    translate([10+15*3, 35+15, t]) rotate([0, 0, -45]) arc();
    translate([10, 35+15, t]) rotate([0, 0, -45]) arc();
    translate([10+15*3, 35+15*2, t]) rotate([0, 0, -45]) arc();
    translate([10+15*4, 35+15*2, t]) rotate([0, 0, -45]) arc();
    translate([10+15*5, 35+15*2, t]) rotate([0, 0, -45]) arc();
}


main();