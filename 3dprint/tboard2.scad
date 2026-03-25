$fn = 128;

Z = 8;
t = 2.0;
arc_width = 4.0;

d_outer = 8;
d_inner = 3.85;
dM3 = 4.2;
dM5 = 5.7;

module fillet(smooth) {
   offset(r = smooth) {
     offset(delta = -smooth) {
       children();
     }
   }
}


module arc(w=4, dout=Z-2) {
    rotate([90, 0, 0])
    linear_extrude(height=w)
    difference() {
        intersection() {
            circle(r=dout);
            translate([-dout, 0]) square(size=dout*2);
        }
        circle(r=dout-t);
    }
}


module arrow(l, sw, hl, hw) {
    // The shaft (centered vertically)
    translate([0, -sw/2]) square([l - hl, sw]);
    
    // The head (a simple triangle polygon)
    translate([l - hl, 0])
    polygon(points=[[0, -hw/2], [hl, 0], [0, hw/2]]);
}


module flangeM3(h=Z, diff=false) {
    difference() {
        cylinder(h=h, d=d_outer, center=false);
        cylinder(h=h, d=d_inner, center=false);
        translate([0, 0, h-1])
        cylinder(h=1.5, d1=d_inner, d2=d_inner + 1.5, center=false);
    }
}


module flangeArray(x, y, shift=d_outer/2) {
    translate([shift, shift, t]) flangeM3();
    translate([shift, y-shift, t]) flangeM3();
    translate([x-shift, shift, t]) flangeM3();
    translate([x-shift, y-shift, t]) flangeM3();
}

module board(xc, yc) {
    X = xc + d_outer;
    Y = yc + d_outer;
    linear_extrude(height=t) fillet(d_outer/2) difference() {
        square([X, Y]);
        translate([X/3, Y/2]) circle(d=dM5);
        translate([X-X/3, Y/2]) circle(d=dM5);
    }
    flangeArray(X, Y);
    translate([X/2, arc_width, t]) arc();
    translate([X/2, Y, t]) arc();
    translate([0, Y/2, t]) rotate([0, 0, 90]) arc();
    translate([X-arc_width, Y/2, t]) rotate([0, 0, 90]) arc();
}

module caseTextL(H_obj, h=0.5) {
    translate([0, 0, H_obj+t-h]) linear_extrude(height=h) {
        translate([5, 38]) rotate([0, 0, -90]) text("IN");
        translate([80, 54]) rotate([0, 0, -90]) text("OUT");
        translate([69, 22]) rotate([0, 0, -90]) text("+");
        translate([69, 10]) rotate([0, 0, -90]) text("-", size=12);
        translate([23, 20]) rotate([0, 0, -90]) text("+");
        translate([23, 8]) rotate([0, 0, -90]) text("-", size=12);
        translate([35, 38]) arrow(30, 5, 10, 10);
    }
}

module caseL() {
    X = 100.5;
    Y = 60 + 2*t;
    h = 31;
    m3c = 3;
    difference() {
        union() {
            difference() {
                cube([X, Y, h+t]);
                translate([t, t, 0]) cube([X-2*t, Y-2*t, h]);
                
                caseTextL(h);
                               
                // full-height terminal cuts
                translate([0, 0, 0]) cube([t+20,t+18,h+t]);
                translate([t+77,0,0]) cube([100, t+21, h+t]);
                
                // upper left corner for hidden M3 screw
                translate([0, Y-t-7, 0]) cube([t+7, t+7, 4]);
                
                // fan
                for (i=[1:3]) {
                    translate([0, t+30+i*6, 4]) cube([t, 3, 21]);
                }
                translate([0, t+30+3*6+6, 7]) cube([t, 3, 18]);
            }
            
            // prolong pads
            w_extra = 2;
            translate([-w_extra, 0, 0]) cube([w_extra, Y-9, t]);
            translate([X, 0, 0]) cube([w_extra, Y, t]);

            // long walls
            cube([X, t, t]);
            translate([6+t, 0, 0]) cube([20, t, h+t]);
            translate([X-t-22, 0, 0]) cube([16, t, h+t]);
            
            // left terminal bottom and wall
            cube([t+5, t+18, t]);
            translate([0, t+18, 0]) cube([t+3, t, t+h]);
            translate([t+20, t, h-17]) cube([t, t+18, 17]);
            translate([0, t+18, h-10]) cube([t+20, t, 10]);
            
            // right terminal bottom and wall
            translate([X-t-4, 0, 0]) cube([4+t, t+21, t]);
            translate([X-t-4, t+21, 0]) cube([4+t, t, t+h]);
            translate([77, 0, h-10]) cube([t, t+21, 10]);
            translate([77, t+21, h-10]) cube([X-77, t, 10]);

            // m3 corner cubes
            translate([X-t-8, Y-t-8, 0]) cube([t+8, t+8, h+t]);
        }
        translate([X-t-7, Y-t-7, t]) cube([t+7, t+7, h]);
        translate([m3c, t+m3c, 0]) cylinder(h=t, d=dM3);
        translate([X-m3c, Y-(t+m3c), 0]) cylinder(h=t, d=dM3);
        translate([X-m3c, t+m3c, 0]) cylinder(h=t, d=dM3);
    }
}


module caseS(margin=4+t) {
    X = 59.5 + 2*t;
    Y = 45 + 2*margin;
    h = 28;
    m3c = 3.2;
    difference() {
        union() {
            difference() {
                cube([X, Y, h+t]);
                translate([t, t, 0]) cube([X-2*t, Y-2*t, h]);
                
                // full-height terminal cuts
                translate([0, 13.5+margin, 5]) cube([t+12,17,h]);
                translate([X-t-13,20+margin,5]) cube([t+13, 17, h]);
                
                // fan
                for (i=[1:9]) {
                    translate([10+i*4.5, 0, 4]) cube([2, Y, 16]);
                }
                
            }
            
            
            // m3 corner cubes
            cube([8+t, 7+margin, h+t]);
            translate([0, Y-(7+margin), 0]) cube([8+t, 7+margin, h+t]);
            translate([X-(8+t), Y-(7+margin), 0]) cube([8+t, 7+margin, h+t]);
            translate([X-(8+t), 0, 0]) cube([8+t, 7+margin, h+t]);
        }
        
        translate([0, 0, t]) cube([8, 7+margin, h]);
        translate([0, Y-(7+margin), t]) cube([8, 7+margin, h]);
        translate([X-8, Y-(7+margin), t]) cube([8, 7+margin, h]);
        translate([X-8, 0, t]) cube([8, 7+margin, h]);

        // m3 drills
        translate([t+m3c+.5, margin+m3c, 0]) cylinder(h=t, d=dM3);
        translate([t+m3c+.5, Y-(margin+m3c), 0]) cylinder(h=t, d=dM3);
        translate([X-(t+m3c)+.5, margin+m3c, 0]) cylinder(h=t, d=dM3);
        translate([X-(t+m3c)+.5, Y-(margin+m3c), 0]) cylinder(h=t, d=dM3);
    }
}


boardL = [94, 54, 33];
boardS = [53.25, 39.25];

//board(boardS[0], boardS[1]);

caseS();