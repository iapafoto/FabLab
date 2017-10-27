//------------------------------
// Created by Sebastien Durand - 2017
// License Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License.
//------------------------------

use <logoTelethon.scad>

//---------------------------------
//            General
//---------------------------------
// Resolution des cylindres
resolution = 100;


//---------------------------------
//            Batiment
//---------------------------------
// epaisseur du mur 
epWall = 2.2;
// Hauteur du moulin sans le toit
hMur = 26;
// rayon a la base
rBase = 14;
// rayon au sommet
rTop = 10;
// hauteur de la porte
hDoor = 11;
// largeur de la porte
wDoor = 6;
// largeur de la zone autour de la porte (briques)
bDoor = 1;
// hauteur de la fenetre
hWin = 6;
// largeur de la fenetre
wWin = 4.5;
// position de la fenetre
altiWin = 20;

//---------------------------------
//               Toit
//---------------------------------
// rayon du toit
rRoof = rTop +.7;
// hauteur du toit
hRoof = 17; 
// dimension de l'avancée du toit
lPrism = 10;
hPrism1 = 10.5;
hPrism2 = 11.5;

//---------------------------------
//              Pales
//---------------------------------
// Longeur de la tige avant pales
lTige = 6;
// Longeur de la partie pale
lPale = 24;
// Largeur des pales
wPale = 9;
// Epaisseur des tiges de bois (le reste est proportionnel)
epPale = .4;
// Rayon du trou au centre des pales
rPaleHole = .8;
// Inclinaison des pales
incPale = 85;

//Draw a prism based on a 
//right angled triangle
//l - length of prism
//w - width of triangle
//h - height of triangle
module prism(l, w, h1, h2) {
    w1 = -w/2;
    w2 = w/2;
    polyhedron(
        points=[[0,0,h1],[w1,0,0],[w2,0,0],
                [0,l,h2],[w1,l,0],[w2,l,0]],
        faces=[[0,2,1],[3,4,5],[0,1,4,3],[1,2,5,4],[0,3,5,2]]);
}

module barreToitRot(nbRot, ep) {
    for ( i = [0:nbRot] ) {
        rotate( i*360/nbRot, [0, 0, 1]) {
            cube([ep,30,100]);
        }
    }
}

module barreToit(nb, pas, ep) {
    for ( i = [0:nb] ) {
        translate([0,i*pas,0]) {
            cube([30,ep,100], center = true);
        }
    }
}

module barreToit2(nb, pas, ep) {
    for ( i = [-nb/2:nb/2] ) {
        translate([i*pas,0,0]) {
            cube([ep,30,100], center = true);
        }
    }
}

module porte() {
    translate([-rBase+2,0,hDoor/2+bDoor]) {
        cube([8, wDoor+2*bDoor, hDoor+bDoor], center=true);   
        intersection() {
            rotate(90,[0,1,0]){         
                cylinder(h=8, r=hDoor*.62, center = true, $fn=resolution);
            }
            translate([0,0,wDoor/2.]) {
                cube([8, wDoor+2*bDoor, hDoor+4], center=true);
            } 
       }
   } 
}

module porteSub() {
    translate([-rBase+2,0,hDoor/2]) {
      //  cube([9, wDoor, hDoor], center=true);   
        intersection() {
            rotate(90,[0,1,0]){         
                cylinder(h=9.1, r=hDoor*.6, center = true, $fn=resolution);
            }
            translate([0,0,wDoor/2.]) {
                cube([9, wDoor, hDoor+4], center=true);
            } 
       }
   } 
}




module toit() {
    union() {
        // Toit Conique
        translate([0,0,hMur]) {
            cylinder( h=hRoof, r1 = rRoof, r2 = 0, center = false, $fn=resolution);
        }
        
        // L'avancé du toit pour les pales (non planaire voir si pb)
        translate([0,1.,hMur]) prism(10, lPrism, hPrism2, hPrism1);
        
        // L'attache des pales
        intersection() {
            translate([0,1.,hMur]) prism(15, lPrism-.2, hPrism2-.2, hPrism1-.2);

            translate([0, (rTop+rBase)/2, hMur+hRoof/3]) {
                rotate(-90,[0,0,1]) {
                    rotate(-incPale,[0,1,0]) {
                            translate([-1, 0, -1.5]) cylinder( h=3., r2 = rPaleHole*2, r1=rPaleHole*5, center = true, $fn=32);
                    }
                }
            }

        }
        
        intersection() {
            barreToitRot(30,.6);
            // Le toit
            translate([0,0,hMur+.1]) {
                cylinder( h=hRoof+.4, r1 = rRoof+.6, r2 = 0, center = false, $fn=resolution);
            }
        }
        
        intersection() {
            barreToit(10,1.8,.6);
                    // Le toit
            translate([0,1.,hMur+.1]) {
                prism(10, lPrism, hPrism2+.4, hPrism1+.4);
            }
            
        }
    }
}

module murs() {
    intersection() {
        difference() {
            union() {
                // murs
                cylinder( h=hMur, r1 = rBase, r2 = rTop, center = false, $fn=resolution);
             
                // Tour Porte
                porte();
                
                // Tour Fenetre du haut
                translate([-rBase+2,0, altiWin]) {
                   cube([4, wWin+2*bDoor, hWin], center=true);
                }
            }
            
            // Le creu a l'interieur du moulin
            cylinder( h=hMur, r1 = rBase-epWall*1.5, r2 = rTop-epWall, center = false, $fn=resolution);
                
            
        }
        cylinder( h=hMur, r1 = rBase+.5, r2 = rTop+.5, center = false, $fn=resolution);
    }
}


module pale(lTige, lPale, wPale, ep) {
    nb = 12;
    k = lPale/nb;
    
    translate([0,-ep*2,0]) {
        cube([lTige+lPale+ep,ep*4,ep*4]);
    }
    translate([lTige-ep,wPale/2-ep,0]) {
        cube([lPale+2*ep,ep*2,ep*2]);
    }
    translate([lTige-ep,-wPale/2-ep,0]) {
        cube([lPale+2*ep,ep*2,ep*2]);
    }
    for ( i = [0:nb] ) {
        translate([lTige + k*i, 0, ep]) {
            cube([ep*2,wPale,ep*2], center = true);
        }
    }
}


module pales(lTige, lPale, wPale, ep) {
    difference() {
        union() {
            for ( i = [0:4] ) {
                rotate(90*i,[0,0,1]) pale(lTige, lPale, wPale, ep);
            }
            translate([-ep*2.1,-lTige/2,0]) 
                cube([ep*4.2,lTige,ep*5], center=false);
            translate([-lTige/2,-ep*2.1,0]) 
                cube([lTige,ep*4.2,ep*5], center=false);
            translate([0,0,ep*3])
                cylinder( h=ep*6, r = rPaleHole*2, center = true, $fn=16);
        }
        cylinder( h=20, r = rPaleHole, center = true, $fn=100);
    }
}       

module moulin(withPale) {
     
    difference() {
        union() {
            // Les murs
            murs();        
            // Le toit
            toit();
            
            // Les pales (a faire separement)
            if (withPale) {
                translate([0, (rTop+rBase)/2+.5, hMur+hRoof/3-1]) {
                    rotate(-90,[0,0,1]) {
                        rotate(-incPale,[0,1,0]) {
                            rotate(45,[0,0,1]) {
                                pales(lTige,lPale,wPale,epPale);
                            }
                        }
                    }
                }
            }
            
        }        
        union() {
            // Soustraction de la porte
            porteSub();
            // Soustraction de la fenetre
            translate([-rBase+2,0, altiWin]) {
               cube([8, wWin, hWin], center=true);
            }
             
            // Soustraction du cone sous le toit
            translate([0,0,hMur-.1]) {
                cylinder( h=hRoof-epWall*1.5, r1 = rRoof-epWall, r2 = 0, center = false, $fn=resolution);
            }
            // Trou pour les pales
            translate([0, (rTop+rBase)/2, hMur+hRoof/3-1]) {
                rotate(-90,[0,0,1]) {
                    rotate(-incPale,[0,1,0]) {
                        cylinder( h=20., r = rPaleHole, center = true, $fn=32);
                    }
                }
            }
        }    

    }
    
    
    difference() {
        union() {
        // Boiseries porte
            translate([-rBase+3.3,0,(hDoor+bDoor)/2])
                cube([2.6, wDoor+.1, hDoor+bDoor], center=true);
    // Boiseries fenetre
            translate([-rBase+5,0, altiWin]) {
                 cube([2, wWin, hWin], center=true);
            }
            translate([-rBase+5,0, altiWin]) {
                 cube([2.5, .6, hWin+.1], center=true);
            }
            translate([-rBase+5,0, altiWin-(hWin/2)+hWin/3]) {
                 cube([2.5, wWin+.1, .6], center=true);
            }
            translate([-rBase+5,0, altiWin-(hWin/2)+hWin*2/3]) {
                 cube([2.5, wWin+.1, .6], center=true);
            }
        }
        // Le creu a l'interieur du moulin
        cylinder( h=hMur, r1=rBase-epWall*1.5, r2 = rTop-epWall, center = false, $fn=resolution);
    }

}

module revolve_text(radius, chars) {
    PI = 3.14159;
    circumference = 2 * PI * radius;
    chars_len = len(chars);
    font_size = 1.6*circumference / chars_len;
    step_angle = 360 / chars_len;
    for(i = [0 : chars_len - 1]) {
        rotate(-i * step_angle) 
            translate([0, radius + 1.*font_size / 2, 0]) 
                text(
                    chars[i], 
                    font = "Arial; Style = Bold", 
                    size = font_size, 
                    valign = "baseline",
                    halign = "center"
                );
    }
}




module occitanePart() {
    r = 3;
    a = 33;
    c = r*cos(a);
    s = r*sin(a);
    
    difference() {
        cylinder( h=1, r = 3, center = true, $fn=resolution);
        union() {
            for (i=[-1,1]) {
                translate([0,i*3.4,0]) cylinder( h=3, r=3, center=true, $fn=resolution);
            }
            translate([-5.4,-3.5*.5,0]) cylinder(h=3, r=3, center=true, $fn=resolution);
            translate([-5.4,3.5*.5,0]) cylinder(h=3, r=3, center=true, $fn=resolution);
            translate([5.4,-3.5*.5,0]) cylinder(h=3, r=3, center=true, $fn=resolution);
            translate([5.4,3.5*.5,0]) cylinder(h=3, r=3, center=true, $fn=resolution);
            
        }
    }
    
    for (i=[-1,1]) {
        translate([i*r,0,0]) cylinder(h=1, r=.33, center=true, $fn=resolution);
        for (j=[-1,1]) {    
            translate([i*c,j*s,0]) cylinder(h=1, r=.33, center=true, $fn=resolution);
        }
    }
}

module occitane() {
    occitanePart();
    rotate(90,[0,0,1]) occitanePart();
}


// Socle
module socle() {
    radius = rBase*1.35;
    chars = "          Cintegabelle         ";

    difference() {
        translate([0,0,1]) cylinder( h=2.1, r2 = rBase*1.9, r1 = rBase*2, center = true, $fn=resolution);

        translate([0,0,1.7])
            linear_extrude(height = 1.5, center = true, convexity = 10, twist = 0)
                minkowski() {
                    revolve_text(radius*.88, chars);
                    circle(r=.24);
                }
    }

//   translate([0,1.3*rBase,2]) scale([2,2,1.5]) occitane();
    translate([0,1.3*rBase,2]) rotate(180,[0,0,1]) scale([2.7, 2.7, .7]) logoTelethon();
}


translate([1.9*rBase+wPale,1.9*rBase+wPale,0]) pales(lTige,lPale,wPale,epPale);
translate([0,-rBase/4,2]) moulin(false);
socle();

//murs();
//toit();

//echo(version=version());



