include <relays_lib.scad>

// 2. red 1-relay module with optocoupler: 2 x 3-screw terminals
dims = [49.5, 24.8, 19];

// window to read the relay nominal (05VDC / 12VDC printed on the relay top);
// the cap fits either way round, so a second window sits at the 180 deg position
term_x = [6, 44];  // terminal block (screw opening) centers along x
nominal_w = 8;     // window size along x
nominal_h = 4;     // window size along y
nominal_dx = 13.5; // window center distance from the nearest terminal block center
nominal_y = 7.0;   // window center, board coordinates

BOX = [
    dims,
    [
        [term_x[0], 12.5, 7, 17],     // left terminal, 3 screws
        [term_x[1], 12.5, 7, 17],     // right terminal, 3 screws
        [term_x[0] + nominal_dx, nominal_y, nominal_w, nominal_h, 1],
        [term_x[1] - nominal_dx, dims[1] - nominal_y, nominal_w, nominal_h, 1],  // 180 deg rotated
    ],
    [["L", 12.5, 18], ["R", 12.5, 18]],
    [12, 38],
    [
        ["2", 18.5, 20.5, 6],          // left of the upper window
        ["РЕЛЕ", 18.5, 13, 4.2],         // above the lower window
        ["ОПТОПАР", 22.5, 2.4, 3.6],       // bottom, below the lower window
    ],
];


relay_box(BOX);
//cap(BOX);
//base(BOX);
//assembled(BOX);
