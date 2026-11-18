include <relays_lib.scad>

// 4. green buck converter with heatsink: IN pads in the left corners, OUT pads in the right ones;
// the same pad cut in all four corners, so the part is symmetrical
dims = [41.75, 29.75, 20.8];
pad_reach = 5.5;   // corner cut reach from the board corner (both walls)
pad_cut_h = pad_z + pad_h - 2;  // corner cut height above the floor

// the coil sticks out of the board edge next to the OUT+ pad (x=L, y=W corner):
// full-height opening in the back wall, right where the OUT+ corner cut ends
coil_w = 10;                      // opening width along x
coil_x1 = dims[0] - pad_reach;    // opening end (OUT+ corner cut start)
coil_x0 = coil_x1 - coil_w;

// one long clip per side, between the IN corner cuts and the coil opening
latch_l = 14;
latch_x = (pad_reach + coil_x0) / 2;

// corner pad openings: the same cut on both walls meeting at a board corner,
// so the pad can be soldered from either direction. short: "L"/"R", long: "F"/"B";
// reach: how far the cut goes from the board corner along both walls;
// h: height above the floor.
function corner_pad(short, long, reach, h) =
    let(e0 = gap + t + wire_r,   // run past the outer corner, so the rounding stays outside
        s0 = long == "F" ? -e0 : dims[1] - reach,
        s1 = long == "F" ? reach : dims[1] + e0,
        l0 = short == "L" ? -e0 : dims[0] - reach,
        l1 = short == "L" ? reach : dims[0] + e0)
    [[short, (s0 + s1)/2, s1 - s0, h], [long, (l0 + l1)/2, l1 - l0, h]];

BOX = [
    dims,
    [],
    concat(
        corner_pad("L", "F", pad_reach, pad_cut_h),
        corner_pad("L", "B", pad_reach, pad_cut_h),
        corner_pad("R", "F", pad_reach, pad_cut_h),
        corner_pad("R", "B", pad_reach, pad_cut_h),
        [["coil"]]
    ),
    [latch_x],
    [
        ["4", 21, 22, 5],
        ["ЗЕЛЕНА", 21, 15, 5],
        ["ПОНИЖ", 21, 8, 5],
    ],
];

// "coil": back wall opening from the bottom up to the ceiling, merged with the
// OUT+ corner cut; all corners of the merged opening rounded (no sharp edges)
module notch_cut(b, n, Z) {
    if (n[0] == "coil") {
        S = box_size(b);
        e0 = gap + t + wire_r;
        translate([board_x0(b), S[1] + 1, 0]) rotate([90, 0, 0]) linear_extrude(height=t+2)
        offset(r=-wire_r) offset(delta=wire_r)      // concave corners
        fillet(wire_r)                              // convex corners
        union() {
            translate([coil_x0, -5]) square([coil_w + 0.01, Z - t + 5]);
            translate([dims[0] - pad_reach, -5]) square([pad_reach + e0, base_t + pad_cut_h + 5]);
        }
    } else {
        wall_cut(b, n[0], n[1], n[2], -5, base_t + (n[3] == undef ? wire_h : n[3]), wire_r);
    }
}

// the clip window must stay clear of the corner cuts and the coil opening
module latch_check(b, x) {
    assert(x - latch_win_l/2 >= pad_reach + wire_r && x + latch_win_l/2 <= coil_x0 - wire_r,
           str("clip at ", x, " (window ", latch_win_l, ") hits the corner cut or the coil opening"));
}


relay_box(BOX);
//cap(BOX);
//base(BOX);
//assembled(BOX);
