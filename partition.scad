x=95;
y=69;
z=44;

thickness = 1.0;
cutDepth = z / 2;
manifoldCorrection = 0.1;


$fn=64;


module fillet(smooth) {
   offset(r = smooth) {
     offset(delta = -smooth) {
       children();
     }
   }
}


module partition(l) {

    intersection() {
        fillet(1.0)
        difference() {
            square([l, z], center=true);
            translate([0, cutDepth / 2])
            square([thickness, z - cutDepth], center=true);
        }
        translate([0, cutDepth/2]) square([l, z-cutDepth + manifoldCorrection], center=true);
    }

    intersection() {
        fillet(3.0)
        square([l, z], center=true);
        translate([0, -cutDepth/2]) square([l, z-cutDepth +manifoldCorrection], center=true);
    }

}


module face() {
    face_h = 19;
    face_w = 42;

    fillet(1.0)
    square([face_w, face_h]);
}


//partition(l=x);
face();