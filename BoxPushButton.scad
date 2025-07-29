$fn = 65;

thickness = 4.0;
l_square1 = 16.0;

square([thickness, 8], center=true);
translate([thickness/2 + l_square1/2, 0]) square([l_square1, 12], center=true);


translate([0, -100])
difference() {
    square([462, 72]);
    translate([20, 9]) square([419, 20.5]);
    translate([140, 20]) square([14, 20]);
    for (i = [0:1]) {
        translate([20 + i * 145, 38]) square([110, 16.5]);
    }
    translate([5 + 2 * 145, 38]) square([110, 16.5]);
}
