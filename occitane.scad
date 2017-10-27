//------------------------------
// Created by Sebastien Durand - 2017
// License Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License.
//------------------------------

resolution=100;

module occitanePart1(ep=.25, isFill=false, withPlot=true) {
    r=3;
    rr = .33;
    if (isFill) {
        difference() { 
            translate([0,0]) square([r,r]);
            union() {
                translate([0,3.4]) circle(r=r, $fn=resolution);  
                translate([5.4,3.5*.5]) circle(r=r, $fn=resolution);
            }
        }
    } else {
        intersection() {
           difference() { 
                union() {
                    translate([0,3.4]) circle(r=r+ep, $fn=resolution);  
                    translate([5.4,3.5*.5]) circle(r=r+ep, $fn=resolution);
                }
                union() {
                    translate([0,3.4]) circle(r=r, $fn=resolution);  
                    translate([5.4,3.5*.5]) circle( r=r, $fn=resolution);
                    translate([0,-r*2]) square([r*3,r*2]);
                }                
             }
             translate([3.4,0]) circle( r=r+ep, $fn=resolution);
        }
    }
    if (withPlot) {
        translate([r*cos(33),r*sin(33),0]) circle(r=rr, $fn=resolution);
    } 
}

module occitane2D(ep=.25, isFill=false, withPlot=true) {
    r = 3;
    rr = .33;
    for (i=[0:4]) rotate(i*90) {
        occitanePart1(ep=ep, isFill=isFill, withPlot=withPlot);
        scale([1,-1]) occitanePart1(ep=ep, isFill=isFill, withPlot=withPlot);
        if (withPlot) translate([r,0]) circle( r=rr, $fn=resolution);
    }
}


//-----------------------------------

intersection() {
    translate([0,0,-15]) sphere(15.6,$fn=resolution);
    linear_extrude() occitane2D(isFill=true, withPlot=false);
}

intersection() {
    translate([0,0,-15]) sphere(15.8,$fn=resolution);
    linear_extrude() occitane2D(isFill=false, withPlot=true);
}
