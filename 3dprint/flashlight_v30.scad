$fn = 64;

// Flanges
r_inner = 5.25/2;
r_outer = 5.5; // 4.55

d_magnet = 20.4;  // 20 or 25
h_magnet = 3.4;
d_magnet_hole = 4.5;
y_maghole = 73;

X_board = 46;
Y_board = 122;
H = 30;
t = 2.8;
t_magnet_bottom = 1.4;

usb_cut_x = t;
usb_cut_y = 15.6;
usb_cut_z = 6;

dist_y1 = 110.6;  // Y distance between M4 centers
dist_y2 = 95.9;
dist_x = 34.8;


module flange(h_drill=12.5, diff=false) {
    if (diff) {
        cylinder(h=h_drill, r=r_inner, center=false);
        cylinder(h=1, r1=r_inner + 1.0, r2=r_inner, center=false);
    } else {
        cylinder(h=H, r=r_outer, center=false);
    }
}

module flanges(diff=false) {
    translate([X_board - 5.6, 5.8, 0]) flange(diff=diff);
    translate([X_board - 40.4, 20.5, 0]) flange(diff=diff);
    translate([X_board - 5.6, 116.4, 0]) flange(diff=diff);
    translate([X_board - 40.4, 116.4, 0]) flange(diff=diff);
}


module flashlight() {

    difference() {
        union () {
            difference() {
                union() {
                    difference() {
                        cube([X_board, Y_board, H], center=false);
                        
                        translate([t, t, 0])
                        cube([X_board - 2*t, Y_board - 2*t, H - t], center=false);
                    }
                    
                    translate([X_board / 2, Y_board - y_maghole, H - (h_magnet + t) / 2])
                    difference() {
                        cube([X_board, d_magnet + 15, h_magnet + t], center=true);
                        translate([0, 0, -(h_magnet + t)/2])
                        cylinder(h=t - t_magnet_bottom, d=15, center=false);
                    }
                }
                
                cube([usb_cut_x, usb_cut_y, usb_cut_z]);
                
                translate([X_board / 2, Y_board - y_maghole, H - h_magnet / 2])
                cylinder(h=h_magnet, d=d_magnet, center=true);
                translate([X_board / 2, Y_board - y_maghole, H]) cylinder(h=H, d=d_magnet_hole, center=true);
            }
            flanges(diff=false);
        }
        flanges(diff=true);
    }
}


flashlight();
