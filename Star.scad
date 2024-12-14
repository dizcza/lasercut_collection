$fn = 60;

// **** USER CONSTANTS ****
d_small = 260;
h_small = 65;

d_large = 390;
h_large = 200;

d_bearing = 26.1;  // outer
w_circle = 40;

angle_inner = 70;
inner_ring_scale = 0.95;


// **** PROGRAM CONSTANTS ****
ANGLE_STEP = 360 / 8;
a1 = ANGLE_STEP / 2;
r_large = d_large / 2;
trian_bottom_half = r_large * sin(ANGLE_STEP/2);
trian_h_shift = r_large - r_large * cos(ANGLE_STEP/2);
trian_h_full = h_large + trian_h_shift;
trian_alpha = 2 * atan2(trian_bottom_half, trian_h_full);

a_side_inner = h_small / cos(angle_inner/2);
a_side_outer = trian_h_full / cos(trian_alpha/2);


echo([d_small + 2 * h_small, d_large + 2 * h_large, 16 * 1.5 * a_side_inner, 16 * a_side_outer]);


module sector(radius, angles, fn=60) {
    r = radius / cos(180 / fn);
    step = -360 / fn;

    points = concat([[0, 0]],
        [for(a = [angles[0] : step : angles[1] - 360]) 
            [r * cos(a), r * sin(a)]
        ],
        [[r * cos(angles[1]), r * sin(angles[1])]]
    );

    difference() {
        circle(radius);
        polygon(points);
    }
}


module arc(radius, angles, width = 1, fn = 24) {
    difference() {
        sector(radius + width, angles);
        sector(radius, angles);
    }
} 


module fillet(smooth) {
   offset(r = smooth) {
     offset(delta = -smooth) {
       children();
     }
   }
}

module trian(h=h_small, angle=angle_inner) {
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
        translate([-b-0.5, -trian_h_shift])
        rotate(ANGLE_STEP/2)
        rotate(-90)
        square([26, 15.5], center=false);

        translate([0, -r_large/cos(ANGLE_STEP/2)-w/2-4])
        arc(d_large/2, [75+ANGLE_STEP/2, 86+ANGLE_STEP/2], 12);
    }
    
    fillet(1.0)
    difference() {
        trian2();
        translate([0, -y_offset])
        trian2();
        translate([0, h - y_offset/2]) circle(d=2.5);
    }
    bar();
    mirror([1,0]) bar();
}


module m4_holes(d=d_large) {
    for (i=[0:3]) {
        rotate(i * 360 / 4 + ANGLE_STEP / 2)
        translate([0, 0.7 * d/2])
        circle(d=4.5);  // M4
    }
}


module star_inner(with_m4=true, d_wires=2.5) {
    difference() {
        union() {
            difference() {
                circle(d=d_small);
                circle(d=d_bearing);
            }
            for (i=[0:8]) {
                rotate(i * ANGLE_STEP + ANGLE_STEP / 2)
                translate([0, d_small / 2])
                trian();
            }
        }
        if (with_m4) {
            m4_holes();
            translate([0, inner_ring_scale * d_small/2 - 1])
            scale([2, 1]) circle(d=d_wires);
        }
    }
}



module circle_outer_hollow(d=d_large, w_bar=20, with_holes=true) {
    difference() {
        circle(d=d+0.5);
        circle(r=d/2-w_circle);
        if (with_holes) {
            for (i=[0:8]) {
                rotate(i * ANGLE_STEP)
                translate([0, d / 2])
                trian_with_hole();
            }
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
        m4_holes();
    }
    
}

module star_outer(d=d_large, with_holes=false) {
    circle_outer_hollow(with_holes=with_holes);
    
    for (i=[0:8]) {
        rotate(i * ANGLE_STEP)
        translate([0, d / 2])
        trian_with_hole();
    }
}


module print_trian_lasercut() {
    for (i=[0:5]) {
        rotate(i * (trian_alpha+0.2)-7)
        translate([0, -h_large-1]) trian_with_hole();
    }
}


module inner_ring(s=inner_ring_scale) {
    difference() {
        star_inner(with_m4=false);
        fillet(5)
        scale([s, s]) star_inner(with_m4=false);
    }
}


star_inner();
//star_outer();
//trian_with_hole();
//print_trian_lasercut();
//circle_outer_hollow();
translate([0, 0, 2]) inner_ring();
