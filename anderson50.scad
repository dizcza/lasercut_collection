$fn = 64;

hole_x = 42.5;
hole_y = 22;

m4_dist_x = 46.5;
m4_dist_y = 27;


square([hole_x, hole_y], center=true);
translate([m4_dist_x / 2, m4_dist_y / 2]) circle(d=4.2);
translate([-m4_dist_x / 2, m4_dist_y / 2]) circle(d=4.2);
translate([-m4_dist_x / 2, -m4_dist_y / 2]) circle(d=4.2);
translate([m4_dist_x / 2, -m4_dist_y / 2]) circle(d=4.2);