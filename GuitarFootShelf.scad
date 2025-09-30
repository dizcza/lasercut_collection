$fn = 60;

width = 150;
width_bar = 20;
thickness=10;

w_cut = 0.5;
l_cut = 10;

h1 = 160;
h2 = h1 + 40;
x = 320;
a1 = atan2(h1, x);
a2 = atan2(h2, x);

a_top = atan2(h2 - h1, x);
l_top = x / cos(a_top);

l1 = x / cos(a1);
l2 = x / cos(a2);

x1c = x * h1 / (h1 + x * tan(a2));
x2c = x * h2 / (h2 + x * tan(a1));


module fillet(smooth) {
   offset(r = smooth) {
     offset(delta = -smooth) {
       children();
     }
   }
}


module central_pad(l=10, d=5.5) {
    square([l, d], center=true);
    translate([-l/2, 0]) circle(d=d);
    translate([l/2, 0]) circle(d=d);
}


module bar1() {
    difference() {
        square([l1, width_bar]);
        translate([x1c / cos(a1), width_bar / 2]) central_pad();
        translate([l1 - width_bar, width_bar / 2]) circle(d=2);
    }
}


module bar2() {
    difference() {
        square([l2, width_bar]);
        translate([l2 - x2c / cos(a2), width_bar / 2]) central_pad();
        translate([width_bar, width_bar / 2]) circle(d=2);
        translate([l2, 0]) rotate([0, 0, 90 - (a2 - a_top)])
        square([100, 100]);
    }
}


module bottom_connector(l=width) {
    echo(l);
    difference() {
        square([width_bar, l]);
        translate([width_bar/2, 0]) square([w_cut, l_cut]);
        translate([width_bar/2, l - l_cut + 0.1]) square([w_cut, l_cut]);
    }
}


module lid(x_offset=10) {
    difference() {
        square([l_top, width]);
        translate([x_offset, 0]) square([w_cut, l_cut]);
        translate([x_offset, width - l_cut + 0.1]) square([w_cut, l_cut]);
        translate([l_top - 15, thickness / 2]) circle(d=2);
        translate([l_top - 15, width - thickness / 2]) circle(d=2);
    }
}



module draw_all() {
    fillet(3) {
        lid();
        translate([0, width + 1]) bar1();
        translate([0, width + 2 + width_bar]) bar1();
        translate([0, width + 3 + 2 * width_bar]) bar2();
        translate([0, width + 4 + 3 * width_bar]) bar2();
        translate([l_top + 1, 0]) bottom_connector();
        translate([l_top + 2 + width_bar, 0]) bottom_connector(l=width - 2 * thickness);
    }
}


draw_all();