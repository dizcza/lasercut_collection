$fn = 64;

// Flanges
r_inner = 5.5/2;
r_outer = 5.5; // 4.55

ring_h = 1.0;
ring_d = 7.5;  // 7.1

d_magnet = 25.4;
h_magnet = 3.1;
d_magnet_hole = 4.5;
y_maghole = 73;

X_board = 46;
Y_board = 122;
H = 31;  // Hbatt = 21-22
t = 2.6;

usb_cut_x = 2.6;
usb_cut_y = 15.6;
usb_cut_z = 6;

dist_y1 = 110.6;  // Y distance between M4 centers
dist_y2 = 95.9;
dist_x = 34.8;

module flange() {
    difference() {
        cylinder(h=H, r=r_outer, center=false);
        cylinder(h=15, r=r_inner, center=false);
        cylinder(h=1, r1=(r_outer + r_inner) / 2, r2=r_inner, center=false);
    }
}

module flanges() {
    translate([X_board - 5.6, 5.8, 0]) flange();
    translate([X_board - 40.4, 20.5, 0]) flange();
    translate([X_board - 5.6, 116.4, 0]) flange();
    translate([X_board - 40.4, 116.4, 0]) flange();
}


module flashlight() {
    difference() {
        union() {
            difference() {
                cube([X_board, Y_board, H], center=false);
                
                translate([t, t, 0])
                cube([X_board - 2*t, Y_board - 2*t, H - t], center=false);
            }
            
            translate([X_board / 2, Y_board - y_maghole, H - (h_magnet + t) / 2])
            cube([X_board, d_magnet + 15, h_magnet + t], center=true);  
        }
        
        cube([usb_cut_x, usb_cut_y, usb_cut_z]);
        
        translate([X_board / 2, Y_board - y_maghole, H - h_magnet / 2])
        cylinder(h=h_magnet, d=d_magnet, center=true);
        translate([X_board / 2, Y_board - y_maghole, H]) cylinder(h=H, d=d_magnet_hole, center=true);
    }

    flanges();
}

module test_flashlight() {
    intersection() {
        flashlight();
        cube([X_board, Y_board, 5]);
    }
}


flashlight();
