include <relays_lib.scad>

// 4. green buck converter with heatsink: IN pads in the left corners, OUT pads in the right ones;
// the same pad cut in all four corners, so the part is symmetrical
dims = [41.75, 29.75, 19];
pad_reach = 5.5;   // corner cut reach from the board corner (both walls)
pad_cut_h = pad_z + pad_h - 2;  // corner cut height above the floor

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
        corner_pad("R", "B", pad_reach, pad_cut_h)
    ),
    [15, 27],          // latches symmetric about the middle, clear of the corner cuts
    [
        ["4", 21, 22, 5],
        ["ЗЕЛЕНА", 21, 15, 5],
        ["ПОНИЖ", 21, 8, 5],
    ],
];


relay_box(BOX);
//cap(BOX);
//base(BOX);
//assembled(BOX);
