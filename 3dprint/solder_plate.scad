$fn = 128;

t = 2.0;
r = 22;
h = 30;
l = 50;

module sector(radius, angles) {
    r = radius / cos(180 / $fn);
    step = -360 / $fn;

    points = concat([[0, 0]],
        [for(a = [angles[0] : step : angles[1] - 360]) 
            [r * cos(a), r * sin(a)]
        ],
        [[r * cos(angles[1]), r * sin(angles[1])]]
    );

    difference() {
        circle(radius);
        polygon(points);
    }
}

module arc(radius, angles, width = t) {
    difference() {
        sector(radius, angles);
        sector(radius - width, angles);
    }
}


difference() {
    linear_extrude(height=h) {
        translate([0, r]) arc(r, [120, 270]);
        square([l, t]);
    }
    translate([l-15, 0, h/2])
    rotate([-90, 0, 0]) scale([1, 1.1, 1]) cylinder(h=t, d=5.2);
}