module fillet(smooth) {
   offset(r = smooth) {
     offset(delta = -smooth) {
       children();
     }
   }
}


fillet(1.0) square(282, 262);
//fillet(1.0) square(362, 262);
