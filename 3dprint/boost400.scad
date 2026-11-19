include <relays_lib.scad>

// 400 W boost converter with two heatsinks: 2-screw terminals at both ends (IN / OUT)
t = 1.4;
dims = [67.1, 49, 30];

// vent slots in both long walls, in front of the heatsinks
vent_n = 5;
vent_w = 1;        // slot width along x
vent_h = 20;       // slot height
vent_z = 6;        // slot bottom above the floor (base plate top)
vent_pitch = 8;

function vents(side) = [for (i = [0:vent_n-1])
    [side, dims[0]/2 + (i - (vent_n-1)/2)*vent_pitch, vent_w, vent_z + vent_h, vent_z]];

BOX = [
    dims,
    [],
    concat([["L", dims[1]/2, 16], ["R", dims[1]/2, 16]], vents("F"), vents("B")),
    [15, dims[0] - 15],
    [
        ["BOOST", dims[0]/2, dims[1]/2, 7],
    ],
];

// notches with a 5th element (bottom height) are closed slots, the rest open at the bottom
module notch_cut(b, n, Z) {
    if (n[4] == undef)
        wall_cut(b, n[0], n[1], n[2], -5, base_t + (n[3] == undef ? wire_h : n[3]), wire_r);
    else
        wall_cut(b, n[0], n[1], n[2], base_t + n[4], base_t + n[3], n[2]/2);
}


relay_box(BOX);
//cap(BOX);
//base(BOX);
//assembled(BOX);
