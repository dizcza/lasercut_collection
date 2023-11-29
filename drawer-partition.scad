x1=94.75;
y1=69;
z1=44;

x2=126;
y2=101;
z2=30;

$fn=64;


module fillet(smooth) {
   offset(r = smooth) {
     offset(delta = -smooth) {
       children();
     }
   }
}


module partitionHalferV1(l=x1, extra_cuts=0) {
    bottomPadCutLength = 6.0;
    bottomPadCutWidth = 1.5;
    upperSlotCutDepth = z1 / 2;

    module cutout(x, thickness=1.0) {
        translate([x, upperSlotCutDepth / 2])
        square([thickness, z1 - upperSlotCutDepth], center=true);
    }
    
    // top and bottom Y halfers require the larger length
    pad = (l == y1 && extra_cuts > 0) ? 1.0 : 0;
    l_padded = l + pad;
    
    fillet(2.0)
    difference() {
        square([l_padded, z1], center=true);
        
        cutout(0);
        if (l == x1) {
            if (extra_cuts > 0) {
                cutout(l/4);
            }
            if (extra_cuts > 1) {
                cutout(-l/4);
            }
        }

        pad_translate_z = z1/2 - bottomPadCutLength/2;
        pad_translate_z_mirror = l == y1 ? pad_translate_z : -pad_translate_z;

        translate([-l_padded/2, pad_translate_z_mirror])
        square([2*bottomPadCutWidth, bottomPadCutLength], center=true);
        
        translate([l_padded/2, pad_translate_z_mirror])
        square([2*bottomPadCutWidth, bottomPadCutLength], center=true);
    }
}


module partitionHalferV2(l=x2) {
    // l: x2 or y2
    bottomPadCutLength = 6.0;
    bottomPadCutWidth = 1.5;
    upperSlotCutDepth = z2 / 2;
    
    thickness = 1.5;
    
    fillet(2.0)
    difference() {
        square([l, z2], center=true);
        
        translate([0, upperSlotCutDepth / 2])
        square([thickness, z2 - upperSlotCutDepth], center=true);
    }
}


module faceV1() {
    face_h = 20;
    face_w = 42.5;

    fillet(1.0)
    square([face_w, face_h]);
}


partitionHalferV1(l=x1, extra_cuts=1);
//faceV1();