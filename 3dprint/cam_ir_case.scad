$fn = 128;

X = 140;
Y = 120;
Z = 60;

t = 2.0;
x_camera = t + 35;

w_ir = 40;  // IR ligth holder width
h_ir_bottom = 9;
z_ir_center = h_ir_bottom + 20;

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


module ir_light(d_ir=29.1) {
    h_total = h_ir_bottom + 47;
    echo("IR light height: ", h_total+t);
    assert(t+h_total < Z, "IR light is too high!");
    depth_ir = 22;
    difference() {
        linear_extrude(height=w_ir)
        polygon(points=[[0,0],[depth_ir,0],[depth_ir,h_total-12],[depth_ir-3,h_total],[0,h_total]]);
        translate([0, z_ir_center, 20]) rotate([0, 90, 0]) cylinder(h=100, d=d_ir);
        translate([0, 40, 18]) cube([100, 100, 4]);
        translate([0, h_ir_bottom+20, 20-d_ir/2]) rotate([0, 90, 0]) cylinder(h=100, d=2);
        translate([0, h_ir_bottom+20, 20+d_ir/2]) rotate([0, 90, 0]) cylinder(h=100, d=2);
        translate([depth_ir/2, h_total-7, 0]) cylinder(h=100, d=6.5);
    }
}


module stiffeners(t2=2*t, w=10) {
    translate([X-t2, Y/2-w/2, 0]) cube([t2, w, Z]);
    translate([0, Y/2-w/2, 0]) cube([t2, w, Z]);
    translate([X/2-w/2, Y-t2, 0]) cube([w, t2, Z]);
    translate([X/2-w/2, 0, 0]) cube([w, t2, Z]);
}


module main() {
    x_ir_margin = 20;  // with 't' wall included
    difference() {
        cube([X, Y, Z]);
        
        translate([t, t, t]) cube([X-2*t, Y-2*t, Z]);
        
        translate([X-x_camera, t, t+25])
        rotate([90, 0, 0]) cylinder(h=t, d=40.5);
        
        translate([x_ir_margin+w_ir/2, t, z_ir_center])
        rotate([90, 0, 0]) cylinder(h=t, d=41.5);
        
        translate([X-x_camera, Y, t+15])
        rotate([90, 0, 0]) cylinder(h=t, d=20.5);
        
        m4_holes(d=d_M4_outer);
    }
    flanges_outer();
    stiffeners();
    
    translate([x_ir_margin, 80, t])
    rotate([90, 0, 90]) ir_light();
}


main();

//ir_light();