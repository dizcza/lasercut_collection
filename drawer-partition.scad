x=125;
y=100;
z=30;


$fn=64;


module fillet(smooth) {
   offset(r = smooth) {
     offset(delta = -smooth) {
       children();
     }
   }
}


module partitionHalfer(l=x) {
    bottomPadCutLength = 6.0;
    bottomPadCutWidth = 1.5;
    upperSlotCutDepth = z / 2;
    
    thickness = 1.5;
    
    fillet(2.0)
    difference() {
        square([l, z], center=true);
        
        translate([0, upperSlotCutDepth / 2])
        square([thickness, z - upperSlotCutDepth], center=true);
        
    }
}


module face() {
    face_h = 20;
    face_w = 42.5;

    fillet(1.0)
    square([face_w, face_h]);
}


partitionHalfer(l=x);
//face();