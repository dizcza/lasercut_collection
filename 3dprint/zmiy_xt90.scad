$fn = 64;

w = 15;
x0 = 17;
t = 2.0;
d = 20;

module fillet(smooth) {
   offset(r = smooth) {
     offset(delta = -smooth) {
       children();
     }
   }
}


module wing() {
    linear_extrude(height=t)
    translate([d/2 - t, 0])
    union() {
        fillet(1)
        difference() {
            square([x0, w]);
            translate([x0 / 2 + 1, w / 2])
            fillet(2) square([7, 5.5], center=true);
        }
        square([t, w]);
    }
}

translate([0, 0, t])
intersection() {
    translate([0, 0, 1])
    rotate([0, 90, 90])
    difference() {
        cylinder(h=w, d=d);
        cylinder(h=w, d=d - 2 * t);
    }
    translate([-50, 0, 0])
    cube([100, 100, 100]);
}

wing();
mirror([1, 0, 0])
wing();
