$fn=60;

scale1 = 1.5;
scale2 = 1.7;

d1 = 155;
d2 = 130;

x_center = 73.5;


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
        scale([scale1, 0.9]) circle(d=d1 / scale1);
        translate([-8.5, 0]) scale([scale2, 1]) circle(d=d2 / scale2);
        translate([-d2/2, 0]) square([d2, 0.2], center=true);
        translate([-d2, 0]) square([2*d2, d2], center=false);
    }
}


module whisker() {
    translate([d1 / 2, 0])
    difference() {
        union() {
            halfWhisker();
            translate([(d1 + d2 / 2) / scale1, 0]) mirror([1, 0]) halfWhisker();
            translate([x_center, 0]) scale([1.2, 0.95]) circle(d=28);
        }
        translate([x_center, 0]) circle(d=6.6);
    }
}


module whiskerParts() {

    module quaterPart() {
        difference() {
            translate([d1 / 2, 0]) halfWhisker();
            translate([x_center + d1/2, 0]) circle(d=38);
        }
    }

    translate([0, -40])
    intersection() {
        whisker();
        translate([x_center + d1/2, 0]) circle(d=150);
    }

    quaterPart();
    translate([2 * d1 - 8, 0]) mirror([1, 0]) quaterPart();
    mirror([0, 1]) whisker();
}


whiskerParts();