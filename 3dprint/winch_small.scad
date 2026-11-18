$fn = 64;

// Case for the small winch reversing relay (ZJSF-120A DC12V).
// The relay sits upside down in the bottom case: its can (58.5 x 33 x 26.5)
// goes in first, the wider body (62 x 38) fills the rest up to the main plate
// at 35.5 mm, where the terminals start. The bottom case ends at that plate,
// the top cap covers the terminals.
// - bottom case: two flange columns (left/right, full height) with M4 heat
//   inserts; two vertical M5 ears on the back side (opposite the signal pins)
//   for hanging the case on a vertical wall
// - top cap: flat flanges screwed onto the columns; all wire openings are
//   open at the cap rim, so the cap lifts off over the soldered wires.
//   Printed rim down (the flanges lie on the bed, the ceiling bridges).
// Axes: x along the relay length (left/right = power), y across it
// (front y=0 = signal pins, back y=Wo = against the wall), z up from the floor.

// relay
can = [58.5, 33, 26.5];      // can, goes into the bottom case first
body = [62, 38, 35.5];       // wider body; body[2] = main plate height from the can bottom
term_h = 22;                 // room above the main plate for the terminals, ring lugs and wire bends

// case
gap = 0.3;                   // clearance around the relay
t = 2.0;                     // wall thickness
floor_t = 3.0;               // back plate thickness
top_t = 2.0;                 // cap ceiling thickness
corner_r = 2.0;              // outer corner rounding

// Flanges (as in flashlight_v30.scad): a column on the left and right walls,
// floor to rim, at the back corners, clear of the power wire openings;
// M4 heat insert from the top
r_inner = 5.25/2;            // heat insert hole radius
r_outer = 5.5;               // column radius (the hole sits at its center)
M4_d = 4.4;                  // M4 clearance in the cap flange
head_d = 9;                  // M4 screw head clearance above the cap flange
flange_top_t = 2;            // cap flange: flat plate under the screw head
grow_r = 3;                  // smooth growup (concave rounding) where flanges and ears meet the walls
flange_dx = grow_r + head_d/2 + 0.5;   // hole distance from the side wall: the screw head clears the growup

// vertical wall mounting ears on the back side, sticking out left and right
// past the flange columns; the screws go into the wall along y
ear_t = 4;                   // ear thickness (along y)
ear_r = 6.5;                 // ear end radius
ear_hole = 5.5;              // M5 screw
ear_head_d = 10;             // M5 screw head (and screwdriver) clearance
ear_grow_r = 4;              // smooth growup between the flange column and the ear
ear_dx = flange_dx + r_outer + ear_grow_r + ear_head_d/2;   // hole distance from the side wall

// wire openings in the cap walls, open at the cap rim
// power: 2 x AWG8 (up to ~7 mm with insulation) on the left and right
pwr_w = 17;                  // opening width along the wall
pwr_h = 11.25;               // opening height above the rim
// signal: 3 x AWG24 at the front
sig_w = 18;
sig_h = 8;
wire_r = 2.5;                // opening corner rounding

spacing = 5;                 // distance between the parts in the print layout

Li = body[0] + 2*gap;        // cavity
Wi = body[1] + 2*gap;
Lo = Li + 2*t;               // outer
Wo = Wi + 2*t;
Hb = floor_t + body[2] + gap;    // bottom case height (= cap rim, aligned with the main plate)
Ht = term_h + top_t;             // cap height above the rim
flange_y = Wo - r_outer;     // flange column centers along y (back corners)
ear_z = Hb/2;                // ear screw hole height

assert(pwr_w/2 + 1 < Wo/2 - 2*r_outer, "power wire opening runs into the flange");


module fillet(smooth) {
   offset(r = smooth) {
     offset(delta = -smooth) {
       children();
     }
   }
}


// front corners rounded; back corners square, so the flanges merge into the
// walls there without a gap
module outline() {
    union() {
        fillet(corner_r) square([Lo, Wo]);
        translate([0, Wo/2]) square([Lo, Wo/2]);
    }
}


module rrect(l, w, r=1) {
    translate([(Lo - l)/2, (Wo - w)/2]) fillet(r) square([l, w]);
}


// concave corners rounded with r (smooth growup), convex corners kept
module grow(r) {
    offset(r=-r) offset(delta=r) children();
}


// wall band of side s, inside the wall, along the back part of the side wall
module wall_band(s, y0) {
    translate([s < 0 ? 0 : Lo - t, y0]) square([t, Wo - y0]);
}


// flange footprint on side s (-1 left, +1 right): circle around the hole,
// merged solid into the wall with a smooth growup on the front side
module flange_2d(s) {
    xw = s < 0 ? 0 : Lo;
    grow(grow_r) union() {
        hull() {
            translate([xw + s*flange_dx, flange_y]) circle(r=r_outer);
            translate([s < 0 ? 0 : Lo - t, flange_y - r_outer]) square([t, 2*r_outer]);
        }
        wall_band(s, flange_y - r_outer - 2*grow_r);
    }
}


function flange_xc(s) = s < 0 ? -flange_dx : Lo + flange_dx;


// heat insert hole with a 1 mm entry chamfer, through the full column height
module insert_hole() {
    translate([0, 0, -Hb - 1]) cylinder(h=Hb + 2, r=r_inner);
    translate([0, 0, -1]) cylinder(h=1.01, r1=r_inner, r2=r_inner + 1.0);
}


// vertical ear outline on side s (-1 left, +1 right), in the back wall
// plane (x, z), from the floor up past the screw hole
module ear_profile(s) {
    xw = s < 0 ? 0 : Lo;
    fillet(1)
    hull() {
        translate([xw + s*ear_dx, ear_z]) circle(r=ear_r);
        translate([xw + (s < 0 ? -(ear_dx + ear_r) : ear_dx + ear_r - 0.01), 0]) square([0.01, 0.01]);
        translate([xw - (s < 0 ? 0 : 1), 0]) square([1, ear_z + ear_r]);
    }
}


// the ear plate plus a smooth growup into the flange column in front of it
module ear(s) {
    xw = s < 0 ? 0 : Lo;
    difference() {
        intersection() {
            // footprint: column + ear plate with the concave corner rounded
            linear_extrude(height=Hb)
            grow(ear_grow_r) union() {
                flange_2d(s);
                translate([s < 0 ? -(ear_dx + ear_r) : Lo - t, Wo - ear_t])
                square([ear_dx + ear_r + t, ear_t]);
            }
            // ... cut to the ear outline
            translate([0, Wo + 1, 0]) rotate([90, 0, 0])
            linear_extrude(height=Wo + 2) ear_profile(s);
        }
        translate([xw + s*ear_dx, Wo + 1, ear_z]) rotate([90, 0, 0]) cylinder(d=ear_hole, h=ear_t + ear_grow_r + 2*r_outer + 2);
    }
}


module bottom_case() {
    difference() {
        union() {
            linear_extrude(height=Hb) outline();
            for (s = [-1, 1]) {
                ear(s);
                // same rounding as in ear(), so the column surface matches above and below the ear top
                linear_extrude(height=Hb) grow(ear_grow_r) flange_2d(s);
            }
        }
        // can pocket, then the wider body pocket up to the rim
        translate([0, 0, floor_t]) linear_extrude(height=Hb) rrect(can[0] + 2*gap, can[1] + 2*gap);
        translate([0, 0, floor_t + can[2]]) linear_extrude(height=Hb) rrect(Li, Wi);
        for (s = [-1, 1]) translate([flange_xc(s), flange_y, Hb]) insert_hole();
    }
}


// wire opening in the cap wall, open at the rim (z=0); side "L"/"R"/"F", pos along the wall
module rim_notch(side, pos, w, h) {
    module shape() {
        translate([-w/2, -5]) fillet(min(wire_r, w/2 - 0.01)) square([w, h + 5]);
    }
    if (side == "F")
        translate([pos, t + 1, 0]) rotate([90, 0, 0]) linear_extrude(height=t+2) shape();
    else {
        x = side == "L" ? -1 : Lo - t - 1;
        translate([x, pos, 0]) rotate([90, 0, 90]) linear_extrude(height=t+2) shape();
    }
}


// top cap, z=0 at its rim (sits on the bottom case)
module top_cap() {
    difference() {
        union() {
            difference() {
                linear_extrude(height=Ht) outline();
                translate([0, 0, -1]) linear_extrude(height=term_h + 1) rrect(Li, Wi);
            }
            // flat flange plate with a smooth growup into the wall above it,
            // clear of the screw head
            for (s = [-1, 1]) {
                linear_extrude(height=flange_top_t) flange_2d(s);
                intersection() {
                    linear_extrude(height=Ht) flange_2d(s);
                    translate([s < 0 ? 0 : Lo, 0, flange_top_t]) mirror([s < 0 ? 1 : 0, 0, 0])
                    rotate([90, 0, 0]) translate([0, 0, -Wo - 1])
                    linear_extrude(height=Wo + 2)
                    difference() {
                        translate([-0.01, -0.01]) square(grow_r + 0.01);
                        translate([grow_r, grow_r]) circle(r=grow_r);
                    }
                }
            }
        }
        for (s = [-1, 1]) translate([flange_xc(s), flange_y, -1]) cylinder(d=M4_d, h=flange_top_t + 2);
        rim_notch("L", Wo/2, pwr_w, pwr_h);
        rim_notch("R", Wo/2, pwr_w, pwr_h);
        rim_notch("F", Lo/2, sig_w, sig_h);
    }
}


// relay outline, for checking the fit
module relay() {
    translate([0, 0, floor_t]) {
        translate([(Lo - can[0])/2, (Wo - can[1])/2, 0]) cube(can);
        translate([(Lo - body[0])/2, (Wo - body[1])/2, can[2]]) cube([body[0], body[1], body[2] - can[2]]);
    }
}


module assembled() {
    bottom_case();
    translate([0, 0, Hb]) top_cap();
    %relay();
}


// both parts upright: bottom case on its floor, cap on its rim
module print_layout() {
    bottom_case();
    translate([0, Wo + spacing, 0]) top_cap();
}


print_layout();
//bottom_case();
//top_cap();
//assembled();
