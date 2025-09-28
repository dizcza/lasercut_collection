include <fillet.scad>

w = 110;

l_total = 290;
h_total = 100;
a = 75;

h_rot = (w / (2 * tan(a))) * sin(a);


fillet(2)
difference() {
    square([l_total, h_total]);
    
    translate([20, 40 + h_rot])
    rotate(a - 90)
    fillet(2)
    square([w, l_total]);
}