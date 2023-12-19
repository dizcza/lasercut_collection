include <lasercut.scad>; 

$fn = 60;

thickness = 4.0;
thickness_twist = 3.0;
z = 510 + 2 * thickness;
y = 50 + 2 * thickness;
x = 70 + thickness;

holder_width = 10;
holder_height = 8.5;

x_twist = 12;


magic1 = y - x_twist / 2 - 3 * thickness_twist;

twist_array = [[DOWN, x - holder_height - thickness / 2, magic1, x_twist, 3 * thickness_twist]];

manifoldCorrection = 0.1;



module fillet(smooth) {
   offset(r = smooth) {
     offset(delta = -smooth) {
       children();
     }
   }
}


module panelSquare() {
    translate([thickness, thickness])
    square([y - 2.5 * thickness, z - 2 * thickness], center=false);
    holder_ledge = thickness + 2;
    translate([holder_ledge / 2, z / 2])
    square([2 * holder_ledge + manifoldCorrection, holder_width + 0.25], center=true);
}


module panel2d() {
    x_twist_ledge = 3;
    fillet(1)
    union() {
        panelSquare();
        
        translate([magic1 - x_twist / 2 + thickness_twist + thickness - thickness_twist, -x_twist_ledge])
        projection()
        lasercutoutSquare(thickness=thickness, x=x_twist, y=z + 2 * x_twist_ledge,
            twist_connect=[
                [RIGHT,0,x_twist_ledge,2*thickness_twist - manifoldCorrection],
                [RIGHT,0,z - thickness + x_twist_ledge,2*thickness_twist - manifoldCorrection],
            ]
        );
    }
}



module panel3d() {
    translate([x - holder_height, 0, 0])
    rotate([90, 0, 90])
    linear_extrude(height=thickness)
    panel2d();
}




module box() {
    lasercutoutBox(thickness = thickness, x=x, y=y, z=z,
        sides=5, num_fingers=2,
        twist_holes_a=[
            twist_array,
            twist_array,
        ],
        cutouts_a = [[], [], 
                [[x - holder_height - thickness, z/2 - holder_width/2 - thickness - manifoldCorrection, holder_height + manifoldCorrection, holder_width + 2 * manifoldCorrection]]
            ]
    );
}



//panel2d();
box();
%panel3d();