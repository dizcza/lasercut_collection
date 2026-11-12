$fn = 64;

// Common code for the relay, MOSFET and DC-DC converter boxes (relay1..5.scad).
// Each box = flat base plate (board lies on it) + cap with walls and ceiling.
// The base plate snaps inside the bottom of the cap: ridges on the plate
// edges click into windows in the cap walls (push the ridges through the
// windows to open).

t = 1.0;          // wall and ceiling thickness
gap = 0.25;        // free space around the board on every side (L, W and H)
base_t = 2.0;     // base plate thickness (thicker to hold the latch ridges)
fit = 0.1;        // clearance between the base plate and the cap walls

// latch ridges on the base plate (long sides)
latch_l = 8;      // ridge length
latch_d = 1.1;    // ridge protrusion from the plate edge
latch_h = 1.0;    // ridge height (ramp)
latch_z = base_t - latch_h;  // ridge bottom above the plate bottom; ridge top flush with the plate top (bed side when printed upside down)

// latch windows in the cap walls
latch_win_l = latch_l + 0.5;
latch_win_h = latch_h;
latch_win_r = 0.6;                    // corner fillet (limited to half the window height)

assert(latch_z + latch_h <= base_t, "latch ridge sticks out of the base plate");
assert(latch_d > fit, "latch ridge does not reach the wall");
if (latch_d - fit > t) echo(str("NOTE: latch ridge pokes ", latch_d - fit - t, " mm out of the wall windows"));
// the ramp gets thinner upwards: the window may end below the ridge top as long
// as the ramp there does not reach the wall
latch_win_top = latch_z - 0.1 + latch_win_h;
latch_ramp_reach = latch_d * (latch_z + latch_h - latch_win_top) / latch_h - fit;
if (latch_ramp_reach > 0)
    echo(str("NOTE: latch ramp overlaps the window top edge by ", latch_ramp_reach, " mm"));
assert(latch_ramp_reach <= 0.05, "latch window too low for the ridge ramp");
// the window corner fillets must not cut into the ridge ends (flat locking face)
latch_win_rr = min(latch_win_r, latch_win_h/2 - 0.01);  // fillet can't exceed half the height
latch_corner_dx = latch_l/2 - (latch_win_l/2 - latch_win_rr);
latch_corner_rise = latch_corner_dx > 0 ? latch_win_rr - sqrt(latch_win_rr^2 - latch_corner_dx^2) : 0;
if (latch_corner_rise > 0.1)
    echo(str("NOTE: latch window corner fillets clip the ridge ends by ", latch_corner_rise - 0.1,
             " mm, use a smaller latch_win_r or a longer latch_win_l"));

// wire notches cut from the bottom edge of the cap walls (screw terminals)
wire_h = 12;      // notch height above the floor (base plate top)
wire_r = 3;       // notch corner radius

// soldering pad openings (relay4, relay5)
pad_h = 6;        // pad opening height above pad_z
pad_z = 1.5;      // board thickness

// labels engraved into the cap top and the base plate bottom
text_d = 0.2;     // engraving depth
text_font = "Liberation Sans:style=Bold";

// Each box: [dims, holes, notches, latches, label]
//
// dims: board L x W x H
//
// holes: openings in the cap ceiling, [x, y, lx, ly, (corner radius)] in board
//   coordinates (origin at the board corner, x along L, y along W), x/y is the
//   opening center. Without the corner radius the opening is a full oval.
//
// notches: wire slots open at the bottom edge of the cap walls,
//   [side, pos, width, (height)]; side "L" (x=0), "R" (x=L), "F" (y=0),
//   "B" (y=W); pos is the center along that wall in board coordinates;
//   height is the slot top above the floor (base plate top), wire_h by default.
//
// latches: latch ridge centers along L (board coordinates), on both long sides.
//
// label: rows [[text, x, y, size], ...]; each row is engraved into the cap top
//   centered at its own x/y (board coordinates, keep it off the holes); the
//   base plate bottom gets the rows stacked in order, centered on the board.
//
// A box file can redefine the hooks below to add its own features:
// extra_w(), inner_shape(), notch_cut(), latch_check(), cap_inside().


module fillet(smooth) {
   offset(r = smooth) {
     offset(delta = -smooth) {
       children();
     }
   }
}


// r=undef makes a full oval (stadium)
module oval(lx, ly, r=undef) {
    fillet(r == undef ? min(lx, ly)/2 - 0.01 : r) square([lx, ly], center=true);
}


// hook: extra box width beyond the board (centered on the board)
function extra_w(b) = 0;


function box_size(b) = [
    b[0][0] + 2*gap + 2*t,
    b[0][1] + 2*gap + 2*t + extra_w(b),
    base_t + b[0][2] + 2*gap + t,
];


// board origin in cap coordinates
function board_x0(b) = t + gap;
function board_y0(b) = t + gap + extra_w(b)/2;


// outer outline of the cavity (rectangle the walls are built around)
module inner_rect(b) {
    fillet(1) square([b[0][0] + 2*gap, b[0][1] + 2*gap + extra_w(b)]);
}


// hook: cavity outline
module inner_shape(b) {
    inner_rect(b);
}


// opening in a wall from z0 to z1, centered at pos along it;
// all corners rounded with r: no sharp edges, the bridges print without support
module wall_cut(b, side, pos, w, z0, z1, r) {
    S = box_size(b);
    module shape() {
        translate([-w/2, z0]) fillet(min(r, w/2 - 0.01, (z1 - z0)/2 - 0.01)) square([w, z1 - z0]);
    }
    if (side == "F" || side == "B") {
        y = side == "F" ? t + 1 : S[1] + 1;
        translate([board_x0(b) + pos, y, 0]) rotate([90, 0, 0]) linear_extrude(height=t+2) shape();
    } else {
        x = side == "L" ? -1 : S[0] - t - 1;
        translate([x, board_y0(b) + pos, 0]) rotate([90, 0, 90]) linear_extrude(height=t+2) shape();
    }
}


// hook: one notch n of box b, open at the bottom edge; Z is the cap height
module notch_cut(b, n, Z) {
    wall_cut(b, n[0], n[1], n[2], -5, base_t + (n[3] == undef ? wire_h : n[3]), wire_r);
}


// hook: check a latch position
module latch_check(b, x) {}


// hook: extra solids added inside the cap (ribs etc.)
module cap_inside(b) {}


// ridge along x, protruding to +y
module latch_ridge() {
    // flat bottom locks the plate, ramp on top eases insertion
    rotate([90, 0, 0])
    rotate([0, 90, 0])
    mirror([0, 0, 1])
    linear_extrude(height=latch_l, center=true)
    polygon([[-0.1, latch_z], [latch_d, latch_z], [0, latch_z + latch_h], [-0.1, latch_z + latch_h]]);  // 0.1 overlap with the plate
}


module label_row(row) {
    text(row[0], size=row[3], font=text_font, halign="center", valign="center");
}


// distance from the first row center down to row i, rows 1.4 x size apart
function label_dy(rows, i) =
    i == 0 ? 0 : label_dy(rows, i-1) + (rows[i-1][3] + rows[i][3]) / 2 * 1.4;


// rows stacked one under another, centered at the origin
module label_stack(rows) {
    n = len(rows);
    if (n > 0)
        for (i = [0:n-1])
            translate([0, label_dy(rows, n-1)/2 - label_dy(rows, i)]) label_row(rows[i]);
}


// walls + ceiling, open at the bottom
module cap(b) {
    S = box_size(b);
    X = S[0]; Y = S[1]; Z = S[2];
    cap_inside(b);
    difference() {
        linear_extrude(height=Z) offset(r=t) translate([t, t]) inner_rect(b);
        translate([t, t, -1]) linear_extrude(height=Z-t+1) inner_shape(b);

        // label rows on the top, each at its own place, read from above
        for (row = b[4])
            translate([board_x0(b) + row[1], board_y0(b) + row[2], Z - text_d])
            linear_extrude(height=text_d+1) label_row(row);

        for (h = b[1]) {
            translate([board_x0(b) + h[0], board_y0(b) + h[1], Z - t - 1])
            linear_extrude(height=t+2) oval(h[2], h[3], h[4]);
        }

        for (n = b[2]) notch_cut(b, n, Z);

        // latch windows, bottom edge locks the ridges
        for (x = b[3]) {
            latch_check(b, x);
            translate([board_x0(b) + x, Y + 1, latch_z - 0.1]) rotate([90, 0, 0])
            linear_extrude(height=Y+2)
            translate([-latch_win_l/2, 0]) fillet(latch_win_rr) square([latch_win_l, latch_win_h]);
        }
    }
}


// flat base plate with latch ridges, label engraved into its bottom
module base(b) {
    Y = box_size(b)[1];
    difference() {
        translate([t, t, 0])
        linear_extrude(height=base_t) offset(delta=-fit) inner_shape(b);
        // mirrored, so it reads correctly from below
        translate([board_x0(b) + b[0][0]/2, board_y0(b) + b[0][1]/2, -1])
        linear_extrude(height=text_d+1) mirror([1, 0, 0]) label_stack(b[4]);
    }
    for (x = b[3]) {
        translate([board_x0(b) + x, t + fit, 0]) rotate([0, 0, 180]) latch_ridge();
        translate([board_x0(b) + x, Y - t - fit, 0]) latch_ridge();
    }
}


module assembled(b) {
    cap(b);
    base(b);
}


// both parts flipped over (rotated, not mirrored) for printing, no supports
// needed: cap with the ceiling on the bed, base with its top (board side) on
// the bed, so the latch ridges grow on a ramp and their locking face prints clean
module relay_box(b, spacing=5) {
    S = box_size(b);
    translate([0, S[1], S[2]]) rotate([180, 0, 0]) cap(b);
    // base plate edge starts `spacing` away from the cap
    translate([S[0] + spacing - t - fit, S[1], base_t]) rotate([180, 0, 0]) base(b);
}
