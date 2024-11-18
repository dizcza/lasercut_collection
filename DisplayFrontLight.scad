$fn = 60;

thickness = 4.0;
pad1 = 5;
pad_engrave = 2.0;
x = 62;
y = 41.8;


module pattern(w, h, pad) {
    square([22 + pad, pad]);
    translate([0, pad]) square([pad, h + pad]);
    translate([pad, h + pad]) square([w, pad]);
}


module engravePart() {
    translate([pad1, pad1])
    pattern(x - pad_engrave, y - 2 * pad_engrave, pad_engrave);
    translate([pad1 - pad_engrave + 8, pad1 + y]) square([51, pad1]);
    translate([0, pad1 + y + 1.5]) square([pad1 + 10, 2.5]);
}

//pattern(x - pad_engrave, y - 2 * pad_engrave, pad1 + pad_engrave);
//pattern(x, y, pad1);
#engravePart();