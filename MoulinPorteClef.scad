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
epPale = .2;
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
            barreToitRot(80,.3);
            // Le toit
            translate([0,0,hMur+.1]) {
                cylinder( h=hRoof+.4, r1 = rRoof+.6, r2 = 0, center = false, $fn=resolution);
            }
        }
        
        intersection() {
            barreToit(20,.9,.3);
                    // Le toit
            translate([0,1.,hMur+.1]) {
                prism(10, lPrism, hPrism2+.4, hPrism1+.4);
            }
            
        }
    }
}

module murs() {
    intersection() {
        cylinder( h=hMur, r1 = rBase, r2 = rTop, center = false, $fn=resolution);
        cylinder( h=hMur, r1 = rBase+.5, r2 = rTop+.5, center = false, $fn=resolution);
    }
}



module pale(lTige, lPale, wPale, ep, z=0) {
    nb = 12;
    k = lPale/nb;

    translate([lTige+lPale/2,0,0]) cube([lPale,wPale,ep], center=true);
    
    translate([0,-ep*2,0]) {
        cube([lTige+lPale+ep,ep*4,z+ep*4]);
    }
    translate([lTige-ep,wPale/2-ep,0]) {
        cube([lPale+2*ep,ep*2,z+ep*2]);
    }
    translate([lTige-ep,-wPale/2-ep,0]) {
        cube([lPale+2*ep,ep*2,z+ep*2]);
    }
    for ( i = [0:nb] ) {
        translate([lTige + k*i, 0, (z+ep)/2]) {
            cube([ep,wPale,z+ep], center = true);
        }
    }
}


module pales(lTige, lPale, wPale, ep, z=0) {
    for ( i = [0:4] ) {
        rotate(90*i,[0,0,1]) pale(lTige, lPale, wPale, ep, z);
    }
    translate([-ep*2.1,-lTige/2,0]) 
        cube([ep*4.2,lTige,z+ep*5], center=false);
    translate([-lTige/2,-ep*2.1,0]) 
        cube([lTige,ep*4.2,z+ep*5], center=false);
    translate([0,0,z+ep*3])
        cylinder( h=ep*6, r = rPaleHole*2, center = true, $fn=16);
}       

module moulin(withPale) {
    // Les murs
    murs();        
    // Le toit
    toit();
}



module torus(r1=2,r2=1) {
    rotate_extrude(convexity=4, $fn=36)
    translate([r1, 0, 0])
    circle(r=r2, $fn=36);
}


// On le met debout pour le voir dans thingivers mais il faut bien sur l'imprimer a plat
//rotate(90) rotate(-90, [1,0,0]) {
    difference() {
        union() {
            intersection() {
                translate([0,-31,0]) rotate(45) pales(lTige,lPale,wPale,epPale,z=3.5);
                translate([0,-31,-200]) sphere(203.5+3*epPale,$fn=100);
            }
            rotate(90,[1,0,0]) scale([1,.3,1]) moulin(false);
            translate([0,-44.4,1.5]) scale([1,1,1.6]) torus(r1=4.1, r2=1);
        }
        translate([-100,-100,-100]) cube([200,200,100]);
    }

    translate([-1,-11,3]) rotate(180,[0,0,1]) scale([3, 3, 1.6]) logoTelethon();
    //translate([.5,-11,4]) rotate(180,[0,0,1]) scale([2.3, 2.3, .3]) occitane();
//}

echo(version=version());



