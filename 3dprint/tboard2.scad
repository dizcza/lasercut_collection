$fn = 128;

Z = 8;
t = 2.0;
arc_width = 4.0;

d_outer = 8;
d_inner = 3.85;
dM5 = 5.7;

module fillet(smooth) {
   offset(r = smooth) {
     offset(delta = -smooth) {
       children();
     }
   }
}


module arc(w=4, dout=Z-2) {
    rotate([90, 0, 0])
    linear_extrude(height=w)
    difference() {
        intersection() {
            circle(r=dout);
            translate([-dout, 0]) square(size=dout*2);
        }
        circle(r=dout-t);
    }
}


module flangeM3(h=Z, diff=false) {
    difference() {
        cylinder(h=h, d=d_outer, center=false);
        cylinder(h=h, d=d_inner, center=false);
        translate([0, 0, h-1])
        cylinder(h=1.5, d1=d_inner, d2=d_inner + 1.5, center=false);
    }
}


module flangeArray(x, y, shift=d_outer/2) {
    translate([shift, shift, t]) flangeM3();
    translate([shift, y-shift, t]) flangeM3();
    translate([x-shift, shift, t]) flangeM3();
    translate([x-shift, y-shift, t]) flangeM3();
}

module board(xc, yc) {
    X = xc + d_outer;
    Y = yc + d_outer;
    linear_extrude(height=t) fillet(d_outer/2) difference() {
        square([X, Y]);
        translate([X/3, Y/2]) circle(d=dM5);
        translate([X-X/3, Y/2]) circle(d=dM5);
    }
    flangeArray(X, Y);
    translate([X/2, arc_width, t]) arc();
    translate([X/2, Y, t]) arc();
    translate([0, Y/2, t]) rotate([0, 0, 90]) arc();
    translate([X-arc_width, Y/2, t]) rotate([0, 0, 90]) arc();
}

//board(93.5, 54);
board(53.5, 39.5);
