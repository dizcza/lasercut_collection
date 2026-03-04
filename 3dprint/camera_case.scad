$fn = 128;

t = 1.6;

// Inner dimensions
Xi = 77;
Yi = 47.5;
Zi = 44;
H_right = 12;  // right ledge hight relative to the inner bottom

X = t + Xi;
Y = 2 * t + Yi;
Z = 2 * t + Zi;

w_solid = 38;

x_screw = 18;    // offset from X end
y_screw = 26.5;  // offset from Y end (need to subtract 't')
d_screw = 2.8;

xsnap1 = X/3;
xsnap2 = 2*X/3;
ysnap1 = Y-t-18;
dsnap = 2.5;
hsnap = 5;

// Flange M3 inner and outer diameters
d_M3_outer = 8;
d_M3_inner = 3.85;

d_M4_outer = 11;
d_M4_inner = 5.25;

echo(">>> Yi-w_solid", Yi-w_solid, "d_M3_outer-t", d_M3_outer-t);


module lcylinder(h, d, l) {
    linear_extrude(h=h) {
        square([l-d, d], center=true);
        translate([-(l-d)/2, 0]) circle(d=d);
        translate([(l-d)/2, 0]) circle(d=d);
    }
}

module flangeM3(h, h_drill=8, h_facet=1.5) {
    difference() {
        translate([-d_M3_outer/2-t, -d_M3_outer/2, 0])
        cube([d_M3_outer+t, d_M3_outer+t, h]);
        
        translate([0, 0, h-h_drill])
        cylinder(h=h_drill, d=d_M3_inner);
        
        translate([0, 0, h-h_facet])
        cylinder(h=h_facet, d1=d_M3_inner, d2=d_M3_inner+1);
    }
}


module M2_back_holes() {
    // M2 hole offset from the edge on the black board
    ofst1 = 2.5;
    M2_centers = 33.5;
    translate([0, Y-t-2.3, t+5])
    rotate([0, 90, 0])
    lcylinder(h=t, d=3, l=7);
    
    translate([0, Y-t-ofst1, Z-t-5])
    rotate([0, 90, 0])
    lcylinder(h=t, d=3, l=7);
    
    translate([0, Y-t-ofst1-M2_centers, Z-t-5])
    rotate([0, 90, 0])
    lcylinder(h=t, d=3, l=7);
    
    translate([0, Y-t-ofst1-M2_centers, Z-t-5])
    rotate([0, 90, 0])
    lcylinder(h=t, d=3, l=7);
    
    translate([0, Y-t-ofst1-M2_centers, t+5])
    rotate([0, 90, 0])
    lcylinder(h=t, d=3, l=7);
}

module top_part() {
//    translate([0, 0, 3])
    difference() {
        union() {
            translate([t, 0, Z-t]) cube([X-t, Y-t, t]);
            translate([t, 0, H_right+t]) cube([X-t, t, Z-H_right-t]);
            
            translate([X-d_M3_outer-2*t, 0, t+H_right])
            cube([d_M3_outer+2*t, d_M3_outer+t, Z-(t+H_right)]);
        }
        
        translate([X-28.5, 0, Z-4])
        rotate([-90, 90, 0]) lcylinder(h=t, d=3, l=5);
        
        translate([X-d_M3_outer, 0, t+H_right+2])
        cube([d_M3_outer, d_M3_outer, Z-(t+H_right-2)]);
    
        translate([X-d_M3_outer/2, d_M3_outer/2, t+H_right])
        cylinder(h=2, d=3.5);  // M3
        
        translate([X-x_screw, Y-t-y_screw, Z-t])
        cylinder(h=t, d=d_screw);
    }
    translate([xsnap1, Y-t, Z-t])
    rotate([180, 0, 0])
    snap();
    translate([xsnap2, Y-t, Z-t])
    rotate([180, 0, 0])
    snap();
    translate([t, ysnap1, Z-t])
    rotate([180, 0, 90])
    snap();
    translate([t, ysnap1, Z-t])
    rotate([180, 0, 90])
    snap();
}


module snap(d=dsnap, h=hsnap, thickness=2) {
    translate([-d/2, 0, 0])
    difference() {
        cube([d, thickness, h-d/2]);
        rotate([0, 90, 0]) cylinder(h=dsnap, d=thickness/4);
        translate([0, thickness, 0])
        rotate([0, 90, 0]) cylinder(h=dsnap, d=thickness/4);
    }
    
    translate([0, thickness, h-d/2])
    intersection() {
        rotate([90, 0, 0]) cylinder(h=2*thickness, d=d);
        sphere(r=2*thickness);
    }
}


module wingM4() {
    linear_extrude(height=t)
    translate([0, -d_M4_outer/2])
    difference() {
        union() {
            circle(d=d_M4_outer);
            translate([-d_M4_outer/2, 0])
            square([d_M4_outer, d_M4_outer/2]);
        }
        circle(d=d_M4_inner);
    }
}


module bottom_part() {
    difference() {
        cube([X, Y, Z]);
        translate([t, 0, t]) cube([X, Yi+t, Z]);
        
        translate([X-x_screw, Y-t-y_screw, 0])
        cylinder(h=t, d=d_screw);
        
        M2_back_holes();
        
        ycut_start = 3;
        ycut_end = Y-t-30;
        zcut_start = Z - t - 30;
        zcut_end = Z - t - 6;
        translate([0, ycut_start, zcut_start])
        cube([t, ycut_end, zcut_end-zcut_start]);
        
        translate([X-8, Y-t, t+17]) rotate([-90, 90, 0])
        lcylinder(h=t, d=3, l=10);
        
        translate([xsnap1, Y-t, Z-t-(hsnap-dsnap/2)])
        rotate([-90, 0, 0])
        cylinder(h=t, d=dsnap+0.5);
        
        translate([xsnap2, Y-t, Z-t-(hsnap-dsnap/2)])
        rotate([-90, 0, 0])
        cylinder(h=t, d=dsnap+0.5);
        
        translate([t, ysnap1, Z-t-(hsnap-dsnap/2)])
        rotate([0, -90, 0])
        cylinder(h=t, d=dsnap+0.5);
    }
    
    cube([X, t, H_right+t]);
    
    translate([X-d_M3_outer/2, d_M3_outer/2, t]) flangeM3(h=H_right);
    
    translate([X-49, Y-t-5, t]) cube([25, 5, 2]);
    
    translate([X/2, 0, H_right]) wingM4();
    translate([X/2, Y, H_right]) rotate([0, 0, 180]) wingM4();
}

//bottom_part();
top_part();
//flangeM3(h=10);
//snap();
//wingM4();