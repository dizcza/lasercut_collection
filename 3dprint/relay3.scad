include <relays_lib.scad>

// 3. green MOSFET module: 2x2 + 2 screw terminals

// tall wire notches: [side, pos, width, "top", plank]
notch_keep = 1.0; // wall left at the top of a "top" notch
plank_h = 6.0;    // height of the horizontal plank (bar) dividing a tall notch in two
plank_z = 4.0;    // plank bottom above the floor, facing the terminal block base

BOX = [
    [46, 25, 17],
    [
        [8.6, 12.5, 16, 20, 2],  // 2x2 terminal block, 4 screws
        [39, 12.5, 8, 19],       // 2-screw terminal block
    ],
    [
        ["F", 8.2, 16.5, "top", true],
        ["B", 8.2, 16.5, "top", true],
        ["R", 12.5, 18, "top", true],
    ],
    [25, 38],
    [["3", "РЕЛЕ", "(+)"], 25.8, 12.5, 3.6],
];

// height "top" leaves only notch_keep of wall at the top; plank true (at
// plank_z) or a number (its bottom above the floor) keeps a plank_h high bar
// across the notch; the part below stays open at the bottom edge (soldering
// under the board)
module notch_cut(b, n, Z) {
    z1 = n[3] == undef ? base_t + wire_h : n[3] == "top" ? Z - notch_keep : base_t + n[3];
    if (n[4] == undef) {
        wall_cut(b, n[0], n[1], n[2], -5, z1, wire_r);
    } else {
        pz = base_t + (n[4] == true ? plank_z : n[4]);
        wall_cut(b, n[0], n[1], n[2], -5, pz, wire_r);             // below the plank
        wall_cut(b, n[0], n[1], n[2], pz + plank_h, z1, wire_r);   // above the plank
    }
}


relay_box(BOX);
//cap(BOX);
//base(BOX);
//assembled(BOX);
