include <relays_lib.scad>

// 600 W step-down converter: IN-/IN+ terminals at one end (x=0),
// OUT-/OUT+ at the other end (x=L), both near the y=0 long side.
// One oval wire entry per terminal pair in each end wall.

t = 1.2;           // wall and ceiling thickness (overrides the library value)

board = [101, 62, 36];

// one pedestal (rib) in the middle of every wall, from the base plate top to
// the ceiling; the cavity grows by 2 x ped_t in length and width so the board
// is held between the ribs
ped_t = 0.4;       // rib thickness (how far it sticks out of the wall)
ped_w = 10;        // rib width along the wall

dims = [board[0] + 2*ped_t, board[1] + 2*ped_t, board[2]];

// the same oval wire entry in both end walls
wire_w = 21;       // oval width along the wall, covers both - and + terminals
wire_hh = 16;      // oval height
wire_zc = 13;      // oval center above the floor
wire_y = wire_w/2;  // oval center along y (both terminal pairs), from the board edge

BOX = [
    dims,
    [],
    [
        ["L", ped_t + wire_y, wire_w, wire_hh, wire_zc],   // input wires
        ["R", ped_t + wire_y, wire_w, wire_hh, wire_zc],   // output wires
    ],
    [20, dims[0]/2, dims[0] - 20],   // 3 latches per side
    [],                // no label
];

// closed oval wall openings: [side, pos, width, height, center z above the floor]
module notch_cut(b, n, Z) {
    wall_cut(b, n[0], n[1], n[2], base_t + n[4] - n[3]/2, base_t + n[4] + n[3]/2, n[3]/2);
}


// the pedestals: one rib in the middle of each wall
module cap_inside(b) {
    Li = b[0][0] + 2*gap;
    Wi = b[0][1] + 2*gap;
    h = box_size(b)[2] - t - base_t + 0.01;   // up into the ceiling
    translate([t, t, base_t]) {
        translate([Li/2 - ped_w/2, -0.01]) cube([ped_w, ped_t + 0.01, h]);          // F
        translate([Li/2 - ped_w/2, Wi - ped_t]) cube([ped_w, ped_t + 0.01, h]);     // B
        translate([-0.01, Wi/2 - ped_w/2]) cube([ped_t + 0.01, ped_w, h]);          // L
        translate([Li - ped_t, Wi/2 - ped_w/2]) cube([ped_t + 0.01, ped_w, h]);     // R
    }
}


relay_box(BOX);
//cap(BOX);
//base(BOX);
//assembled(BOX);
