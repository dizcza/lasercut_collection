include <lasercut.scad>; 

$fn = 60;

thickness = 3;
x_gps_space = 0;
x0 = 50 + 2 * thickness + x_gps_space;
x_pad = 7;
x = x0 + x_pad;
y = 72 + 2 * thickness;
z = 120 + 2 * thickness;
x_twist_ledge = 4;

holder_width = 10;

x_twist_extra_space = 0.5 * thickness;
x_twist = 10;

x_twist_pos = z - x_twist / 2 - 2 * thickness - x_twist_extra_space;

twist_array = [[DOWN, x0 - thickness / 2, x_twist_pos, x_twist, 2 * thickness]];


manifoldCorrection = 0.1;


module box() {
    lasercutoutBox(thickness = thickness, x=x, y=y, z=z,
        sides=5, num_fingers=2,
        twist_holes_a=[[], [],
            twist_array,
            twist_array,
        ],
        cutouts_a = [
            [[x0 - thickness, y/2-holder_width/2 - thickness, x_pad + manifoldCorrection, holder_width]]
        ]
    );
}


module fillet(smooth) {
   offset(r = smooth) {
     offset(delta = -smooth) {
       children();
     }
   }
}


module panelSquare() {
    translate([thickness, thickness])
    difference() {
        %square([z - 2 * thickness - 1.0, y - 2 * thickness], center=false);
        
        //translate([30, 40])
        //square([28, 28]);
        
        translate([z - 46, 40])
        circle(d=9);
    }
    holder_ledge = thickness + 3;
    translate([holder_ledge / 2, y / 2])
    square([2 * holder_ledge + manifoldCorrection, holder_width + 0.25], center=true);
}


module panel2d() {
    fillet(1)
    union() {
        panelSquare();

        translate([x_twist_pos - x_twist / 2 + thickness, -x_twist_ledge])
        projection()
        lasercutoutSquare(thickness=thickness, x=x_twist, y=y + 2 * x_twist_ledge,
            twist_connect=[
                [RIGHT,0,x_twist_ledge,2*thickness - manifoldCorrection],
                [RIGHT,0,y - thickness + x_twist_ledge,2*thickness - manifoldCorrection],
            ]
        );
    }
}



module panel3d() {
    translate([x0 + thickness, 0, 0])
    rotate([0, -90, 0])
    linear_extrude(height=thickness)
    panel2d();
}


box();
panel3d();
//panel2d();
