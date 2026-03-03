$fn = 128;

X = 140;
Y = 120;
Z = 60;

t = 2.0;
x_camera = t + 35;

w_ir = 40;  // IR ligth width
h_ir_bottom = 8;  // 10 - t
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


module camera() {
    t_wall_camera = 4.0;

    y_camera_holder = t + 9;
    wx_camera_holder = 38;
    wy_camera_holder = 24;
    h1_camera_holder = 6.5;
    h2_camera_holder = h1_camera_holder + 26;
    
    wy_holder_top = 13;
    x_cut = 10;
    d_cut_edges = 1.5;
    
    difference() {
        union() {
            difference() {
                translate([x_camera-wx_camera_holder/2, y_camera_holder, t])
                cube([wx_camera_holder, wy_camera_holder, h1_camera_holder]);
                translate([x_camera-wx_camera_holder/2+8, t+24, t])
                cube([5, wy_camera_holder, h1_camera_holder]);
            }
            translate([x_camera-wx_camera_holder/2-t_wall_camera, y_camera_holder, t])
            cube([t_wall_camera, wy_camera_holder, h2_camera_holder]);
            
            difference() {
                translate([x_camera+wx_camera_holder/2, y_camera_holder, t])
                cube([t_wall_camera, wy_camera_holder, h2_camera_holder]);
                translate([x_camera+wx_camera_holder/2, t+15, t+h1_camera_holder+14])
                cube([2.5, wy_camera_holder, 3]);
            }
            
            difference() {
                translate([x_camera-wx_camera_holder/2-t_wall_camera, y_camera_holder, t+h2_camera_holder])
                cube([2*t_wall_camera+wx_camera_holder, wy_holder_top, 16]);
                translate([x_camera, y_camera_holder, t+h1_camera_holder+18])
                rotate([-90, 0, 0]) cylinder(h=wy_camera_holder, d=33);
                translate([x_camera-x_cut/2, y_camera_holder, t+h1_camera_holder+18])
                cube([x_cut, wy_holder_top, 50]);
            }
        }
        
        translate([x_camera-wx_camera_holder/2, y_camera_holder, t+h2_camera_holder])
        rotate([-90, 0, 0]) cylinder(h=wy_holder_top, d=d_cut_edges);
        
        translate([x_camera+wx_camera_holder/2, y_camera_holder, t+h2_camera_holder])
        rotate([-90, 0, 0]) cylinder(h=wy_holder_top, d=d_cut_edges);
        
        translate([x_camera, y_camera_holder+wy_holder_top/2, 46.5])
        rotate([0, 90, 0]) cylinder(h=100, d=4.5, center=true);
    }
}


module ir_light(d_ir=28.6, simple=true) {
    h_total = h_ir_bottom + 47;
    difference() {
        linear_extrude(height=w_ir)
        polygon(points=[[0,0],[40,0],[40,h_ir_bottom],[20,h_ir_bottom+20],[20,h_total-12],[17,h_total],[0,h_total]]);
        translate([20,h_ir_bottom,t]) cube([20, 100, 40-2*t]);
        translate([0, z_ir_center, 20]) rotate([0, 90, 0]) cylinder(h=100, d=d_ir);
        translate([0, 40, 18]) cube([100, 100, 4]);
        translate([0, h_ir_bottom+20, 20-d_ir/2]) rotate([0, 90, 0]) cylinder(h=100, d=2);
        translate([0, h_ir_bottom+20, 20+d_ir/2]) rotate([0, 90, 0]) cylinder(h=100, d=2);
        translate([10, h_total-7, 0]) cylinder(h=100, d=6);
        if (simple) {
            translate([20, -1, -1]) cube([100, 100, 100]);
        }
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
        
        translate([X-x_camera, t, 25])
        rotate([90, 0, 0]) cylinder(h=t, d=39.3);
        
        translate([x_ir_margin+w_ir/2, t, z_ir_center])
        rotate([90, 0, 0]) cylinder(h=t, d=40);
        
        translate([X-x_camera, Y, t+15])
        rotate([90, 0, 0]) cylinder(h=t, d=20);
        
        m4_holes(d=d_M4_outer);
    }
    flanges_outer();
    stiffeners();
    
    translate([X-2*x_camera, 0, 0])
    camera();
    
    translate([x_ir_margin, 80-44, t])
    rotate([90, 0, 90]) ir_light(d_ir=26.5);
    
    translate([x_ir_margin, 80, t])
    rotate([90, 0, 90]) ir_light();
}


main();

//ir_light();