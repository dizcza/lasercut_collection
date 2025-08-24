$fn=60;

scale1 = 1.5;
scale2 = 1.7;
scale3 = 1.2;

xl = 4;
xr = 22;
d1 = 200 + xr / 2;
d2 = d1 - xl - xr;


module fillet(smooth) {
   offset(r = smooth) {
     offset(delta = -smooth) {
       children();
     }
   }
}


module halfWhisker() {
    fillet(1)
    difference() {
        scale([scale1, scale3]) circle(d=d1 / scale1);
        translate([-(xr - xl) / 2, 0]) scale([scale2, scale3 + 0.1]) circle(d=d2 / scale2);
        translate([-d2/2, 0]) square([d2, 0.2], center=true);
        translate([-d2, 0]) square([2*d2, d2], center=false);
    }
}


module whisker() {
    translate([d1 / 2, 0])
    difference() {
        union() {
            halfWhisker();
            translate([d1 - xr, 0])
            rotate([0, 0, 180]) halfWhisker();

        }
        translate([d1/2 - xr/2, 0]) circle(d=8.9);
    }
}


module whiskerFull() {
    whisker();
    %translate([d1 * 2 - xr, 0])
    mirror([1, 0]) whisker();
}


module whiskerParts() {
    whisker();
    translate([-14, 50]) whisker();
}


whiskerParts();