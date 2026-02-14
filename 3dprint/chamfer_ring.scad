$fn=128;
t = 1.2;
d0 = 24.3;
h_metal=3.5;
ring_width = 2;


module ring(h, d_outer, d_inner) {
    difference() {
        cylinder(h=h, d=d_outer, center=true);
        cylinder(h=h, d=d_inner, center=true);
    }
}


difference() {
    ring(h=h_metal + 2 * t, d_outer=d0 + 2 * ring_width, d_inner = d0 - 2 * t);
    ring(h=h_metal, d_outer = d0 + 2 * ring_width+0.1, d_inner = d0);
}