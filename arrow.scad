arrow_len = 50;
shaft_w = 5;
head_w = 12;
head_len = 15;

module arrow(l, sw, hl, hw) {
    // The shaft (centered vertically)
    translate([0, -sw/2]) square([l - hl, sw]);
    
    // The head (a simple triangle polygon)
    translate([l - hl, 0])
    polygon(points=[[0, -hw/2], [hl, 0], [0, hw/2]]);
}

// Render the arrow
arrow(arrow_len, shaft_w, head_w, head_len);