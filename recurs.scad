

module rep(n) {
    //cube([2,2,2], center=true);
    sphere(r=2,$fa=.05);
    if (n > 0) { 
        rotate(24,[0,.5,1])
            translate([1.61,0,0]) scale(.85) rep(n-1);      
    //    rotate(-60,[0,.5,1])
    //        translate([1.61,0,0]) scale(.7) rep(n-1);
    }
}

module rep2D(n) {
    difference() {
        square([2,2], center=true);
        square([1.2,1.2], center=true);
    }
    if (n > 0) {
        rotate(20)
            translate([1.5,0]) scale(.8) rep2D(n-1);      
    //    rotate(-40)
     //       translate([1.85,0]) scale(.7) rep2D(n-1);
    }
}


// simple 2D -> 3D extrusion of a rectangle
color("red")
    translate([0, -30, 0])
        linear_extrude(height = 20)
            square([20, 10], center = true);

// using the scale parameter a frustum can be constructed
color("green")
    translate([-30, 0, 0])
        linear_extrude(height = 20, scale = 0.2)
            square([20, 10], center = true);

// with twist the extruded shape will rotate around the Z axis
color("cyan")
    translate([30, 0, 0])
        linear_extrude(height = 20, twist = 90)
            square([20, 10], center = true);

// combining both relatively complex shapes can be created
color("gray")
    translate([0, 30, 0])
        linear_extrude(height = 40, twist = -360, scale = 0, center = true, slices = 200)
            square([20, 10], center = true);
//rep(24);