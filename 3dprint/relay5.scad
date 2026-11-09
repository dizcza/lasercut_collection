include <relays_lib.scad>

// 5. black LX-P110 converter: IN pads left, OUT pads right
// the outer edges of the two pad holes stay fixed; shrinking the wall between
// them widens both holes towards the center
pad_c = 15;        // center between the two holes, along W
pad_out = 8.0;     // from pad_c to the outer edge of each hole
pad_wall = 4.5;    // wall left between the two holes on each side
pad_w = pad_out - pad_wall/2;       // resulting hole width
pad_d = (pad_wall + pad_w) / 2;     // hole center offset from pad_c
assert(pad_w > 0, "pad_wall too large for pad_out");

BOX = [
    [50.25, 30.25, 16.25],
    [],
    [
        ["L", pad_c - pad_d, pad_w, pad_z + pad_h],
        ["L", pad_c + pad_d, pad_w, pad_z + pad_h],
        ["R", pad_c - pad_d, pad_w, pad_z + pad_h],
        ["R", pad_c + pad_d, pad_w, pad_z + pad_h],
    ],
    [12, 38],
    [
        ["5", 25.25, 22.25, 5],
        ["ЧОРНА", 25.25, 15.25, 5],
        ["ПОНИЖ", 25.25, 8.25, 5],
    ],
];


relay_box(BOX);
//cap(BOX);
//base(BOX);
//assembled(BOX);
