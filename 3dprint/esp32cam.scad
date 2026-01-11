$fn = 64;

X = 62;
Y = 33;
Z = 11;

t = 1.6;
usb_wall = 4.5;

difference() {
    cube([X, Y, Z], center=false);
    translate([t, t, 0]) cube([X - 2 * t, Y - 2 * t, Z - t], center=false);
    translate([X-5, usb_wall, 2]) cube([20, Y - 2 * usb_wall, 6], center=false);
    translate([X - 40.5, Y/2, Z-5]) cylinder(h=10, d=10, center=true);
}