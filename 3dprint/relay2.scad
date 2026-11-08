include <relays_lib.scad>

// 2. red 1-relay module with optocoupler: 2 x 3-screw terminals
BOX = [
    [50, 26.5, 20],
    [
        [6, 12.5, 8.4, 19],      // left terminal, 3 screws
        [44, 12.5, 8.4, 19],     // right terminal, 3 screws
    ],
    [["L", 12.5, 18], ["R", 12.5, 18]],
    [12, 38],
    [["2", "РЕЛЕ", "ОПТОПАРА"], 25, 13.25, 3.6],
];


relay_box(BOX);
//cap(BOX);
//base(BOX);
//assembled(BOX);
