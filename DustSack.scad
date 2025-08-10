$fn=60;

d1 = 40;
d2 = 60;
d_wire = 1.5;


module WireBar() {
    r_center = (d1 + d2) / 4 + 3;
    angle = 180 - 40;
    y_wire = r_center * cos(angle);
    x_wire = r_center * sin(angle);
    translate([x_wire, y_wire])
        square([100, d_wire + 0.1], center=false);
    translate([x_wire + d_wire / 2, y_wire + 5])
        circle(d = d_wire + 0.5);
}


difference() {
    circle(d=d2);
    circle(d=d1);
    WireBar();
    mirror([1, 0, 0]) WireBar();
}