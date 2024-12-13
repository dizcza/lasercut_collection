$fn = 60;

// **** USER CONSTANTS ****
d_small = 260;
h_small = 65;

d_large = 390;
h_large = 200;

d_bearing = 26.1;  // outer
w_circle = 30;


// **** PROGRAM CONSTANTS ****
ANGLE_STEP = 360 / 8;
r_large = d_large / 2;
trian_bottom_half = r_large * sin(ANGLE_STEP/2);
trian_h_shift = r_large - r_large * cos(ANGLE_STEP/2);
trian_h_full = h_large + trian_h_shift;
trian_alpha = 2 * atan2(trian_bottom_half, trian_h_full);

echo([d_small + 2 * h_small, d_large + 2 * h_large]);


module fillet(smooth) {
   offset(r = smooth) {
     offset(delta = -smooth) {
       children();
     }
   }
}

module trian(h=h_small, angle=70) {
    b = 2 * h * sin(angle / 2);
    fillet(1.0)
    polygon([[0, h], [b, -h], [-b, -h]]);
}


module trian_with_hole(h=h_large, w=15) {
    y_offset = w / sin(trian_alpha / 2);
    b = trian_bottom_half;
    
    module trian2() {
        polygon([[0, h], [b, -trian_h_shift], [-b, -trian_h_shift]]);
    }
    
    module bar() {
        translate([-b + 3, -trian_h_shift+0])
        rotate(ANGLE_STEP/2)
        rotate(-90)
        union() {
            square([20, 10], center=false);
            translate([10, 0])
            square([10, 25], center=false);
        }
    }
    
    fillet(1.0)
    difference() {
        trian2();
        translate([0, -y_offset])
        trian2();
    }
    bar();
    mirror([1,0]) bar();

}


module star_inner() {
    difference() {
        circle(d=d_small);
        circle(d=d_bearing);
    }
    for (i=[0:8]) {
        rotate(i * ANGLE_STEP + ANGLE_STEP / 2)
        translate([0, d_small / 2])
        difference() {
            trian();
            translate([0, h_small - 7]) circle(d=2.5);
        }
    }
}



module circle_outer_hollow(d=d_large, w_bar=20) {
    difference() {
        circle(d=d+0.5);
        circle(r=d/2-w_circle);
        for (i=[0:8]) {
            rotate(i * ANGLE_STEP)
            translate([0, d / 2])
            trian_with_hole();
        }
    }
    
    difference() {
        union() {
            for (i=[0:8]) {
                rotate(i * ANGLE_STEP + ANGLE_STEP / 2)
                square([w_bar, d-2*w_circle+0.1], center=true);
            }
            circle(d=80);
        }
        circle(d=d_bearing);
    }
    
}

module star_outer(d=d_large) {
    circle_outer_hollow();
    
    for (i=[0:8]) {
        rotate(i * ANGLE_STEP)
        translate([0, d / 2])
        trian_with_hole();
    }
}


//translate([0, 0, 50])
//star_inner();
star_outer();
//trian_with_hole();
//circle_outer_hollow();
//#translate([0, -d_large/2]) circle(d=d_large);


