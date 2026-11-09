include <relays_lib.scad>

// 1. blue 1-relay module: 3-screw terminal + VCC/GND/IN pin header

// The relay takes the whole board width, so the box is wide_extra wider
// (straight outer walls) and the long walls are thickened inwards along short
// stretches at both board ends, so the board fits tightly there; in between
// there is room on both long sides for wires.
wide_extra = 4.0; // extra total width, half on each side (AWG20 wire is ~1.8 mm)
wide_r = 2.0;     // rounding of the thickened wall ends (no sharp edges for wires)
wide_ends = [4, 4];  // thickened stretch lengths along x: at the LED/header end (x=0), at the terminal end (x=L)

// window to read the relay nominal (05VDC / 12VDC printed on the relay top);
// plus a second window at the 180 deg position
term_x = 37;       // terminal block (screw opening) center along x
nominal_w = 8;     // window size along x
nominal_h = 4;     // window size along y
nominal_dx = 13.5; // window center distance from the terminal block center
nominal_y = 14;    // window center, board coordinates

BOX_L = 42.8;
BOX_W = 16.8;

BOX = [
    [BOX_L, BOX_W, 19.5],
    [
        [term_x, 8.5, 8, 16],    // terminal, 3 screws
        [4.7, 8.5, 6, 12],       // pin header wires from the top
        [term_x - nominal_dx, nominal_y, nominal_w, nominal_h, 1],
        [BOX_L - (term_x - nominal_dx), BOX_W - nominal_y, nominal_w, nominal_h, 1],  // 180 deg rotated
    ],
    [
        ["R", 8.5, 16],
        ["L", 8.5, 9, 6],        // solder wires to the pin header from below
    ],
    [16.5, 27],                  // latches in the thin-walled middle
    [
        ["1", 12, 14.5, 5.5],              // top left, beside the window
        ["РЕЛЕ (-)", 20.4, 8.4, 3.8],    // between the two windows
    ],
];

// thin-walled section between x0 and x1 (board coordinates)
function wide_x(b) = [wide_ends[0], b[0][0] - wide_ends[1]];

function extra_w(b) = wide_extra;

// cavity narrowed at the ends by the thickened long walls; all corners rounded
module inner_shape(b) {
    Li = b[0][0] + 2*gap;
    Wi = b[0][1] + 2*gap;
    e = extra_w(b);
    x0 = gap + wide_x(b)[0];
    x1 = gap + wide_x(b)[1];
    fillet(min(1, wide_r))                       // convex corners
    offset(r=-wide_r) offset(delta=wide_r)       // concave corners
    union() {
        translate([0, e/2]) square([Li, Wi]);                    // board width
        translate([x0, 0]) square([x1 - x0, Wi + e]);            // wire room
    }
}

// latches must sit in the thin-walled section, where the walls flex
module latch_check(b, x) {
    assert(x - latch_win_l/2 >= wide_x(b)[0] + wide_r && x + latch_win_l/2 <= wide_x(b)[1] - wide_r,
           str("latch at ", x, " must sit inside the wide section, off the thick walls: allowed centers ",
               wide_x(b)[0] + wide_r + latch_win_l/2, "..", wide_x(b)[1] - wide_r - latch_win_l/2));
}


relay_box(BOX);
//cap(BOX);
//base(BOX);
//assembled(BOX);
