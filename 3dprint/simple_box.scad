$fn = 128;

t = 2.8;
size = 50;
h = 85;

module fillet(smooth) {
   offset(r = smooth) {
     offset(delta = -smooth) {
       children();
     }
   }
}

difference() {
    linear_extrude(h) fillet(5) square(size);
    translate([t, t, t]) linear_extrude(h-t) fillet(5) square(size-2*t);
}