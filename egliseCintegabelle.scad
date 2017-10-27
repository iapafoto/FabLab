hClochet = 25;
hSommet = 10;
rClochet = 5;

res=20;
winw=10; 
winh=38;
ep = 4;
hEtages = 55;
hSommet = 5; // Rab du haut pour la frise
hCoiffe = 140;
hRambarde = 15;

// Fenetre romane centree sur le centre du cercle
// r = ryon => w = 2*r
// h = hauteur avant arrondi
// p = profondeur
//
module borne(r,h,p) {
    rotate(90,[1,0,0]) cylinder(r=r,h=p,$fn=16);
    translate([-r,-p,-h]) cube([r*2,p,h]);
}
    
// Fenetre gothique
module simpleDoor() {
    w = winw+.2;
    h = winh+.2;
    dec = 4.;
    r2 = w/2+dec;
    translate([-w/2,0,0]) {
        union() {
            cube([w, ep*2, h]);
            intersection() {
                translate([r2,0,h]) rotate(-90,[1,0,0]) cylinder(h=ep*2,r=r2,$fn=res);
                translate([w-r2,0,h]) rotate(-90,[1,0,0]) cylinder(h=ep*2,r=r2,$fn=res);
            }
        }
    }
}

module _2D_Window() {
    union() {
      translate([1.5,0]) rotate(45/2) circle(r=2, $fn=8);
      translate([0,1.5]) rotate(45/2) circle(r=2, $fn=8);
    }
}

module window1() {
    translate([winw/2,0,0]) {
        dec = 3.;
        r2 = winw/2+dec;
        intersection() {
            translate([-winw/2,-r2,winh]) cube(r2*2);
            translate([-r2,0,winh]) rotate(-90,[1,0,0])
                rotate_extrude(convexity = 2) translate([r2, 0, 0]) _2D_Window();
        }
        translate([0,0,winh/2])
            linear_extrude(height=winh, center = true, convexity = 10, twist = 0)
          _2D_Window();
    }
}

module window() {
    scale([1,1.1,1]) window1();
    scale([-1,1.1,1]) window1();
}


module clochet() {
    dy = 2;
    r = 50;
    
    difference() {
        union() {
            difference() {
            // La forme principale
            // TODO faire avec de simple octogones       
                rotate(45/2) rotate_extrude($fn=8) translate([-r,0]) {
                    // La rambarde tout en haut
                    translate([dy,hEtages*3+hSommet]) square([ep,hRambarde],$fn=8);
                    // Les murs
                    translate([2*dy+ep,2*hEtages]) square([ep*4,hEtages+hSommet]);
                    translate([1*dy+ep,1*hEtages]) square([ep*4,hEtages]);
                    translate([ep,-hEtages*.25]) square([ep*4,hEtages*1.25]);
                }
                
                union() {
                    // Trou des fenetres
                    for (i =[0:2], j =[0:6]) { // (on economise une fenetre derriere la petite colonne)
                         rotate(180+j*45) translate([0,-r+i*dy+ep-.1,i*hEtages]) scale([1.2,2,1]) simpleDoor();
                    }
                }
            }
            
            // Particularitee de l'une des fenetres du bas (demie fenetre avec porte incrustee)
            translate([40-1.5,-10,-hEtages*.25]) cube([ep,20,40]);
            translate([40-1.5,10,-hEtages*.25+40]) rotate(90,[1,0,0]) linear_extrude(20) polygon([[0,0],[ep,0],[0,ep]]);
      
            // Les bordure tout autour
            rotate(45/2) rotate_extrude($fn=8) translate([-r,0])
                for (i =[1:2]) {
                    w = 41 - i*dy;
                    // TODO faire avec polygone plutot
                    intersection() {
                        translate([i*dy,i*hEtages-w/2]) square([5.5,w+.65]);
                        translate([i*dy,i*hEtages]) rotate(-45) square(w+.65);
                    }
                }
                          
             // La bordure du bas (surface inclinee dans les fenetres)
             rotate(45/2) rotate_extrude($fn=8) translate([-r+2*dy,0]) {
                w = 41;
                // TODO faire avec polygone plutot
                intersection() {
                    translate([0,-w/2]) square([5.5,w+.65]);
                    translate([0,0]) rotate(-45) square(w+.65);
                }
             }

             for (i =[0:2], j =[0:6]) { // (on economise une fenetre derriere la petite colonne)
                 // Ajout des contours de fenetres
                 rotate(j*45+180) translate([0,-r+5.+i*dy+ep,i*hEtages]) window();
            }
            
        }

        union() {
         // Creux à l'interieur de la tour (on le fait a la fin pour bien tout simplifier a l interieur
         translate([0,0,-hEtages*.25]) rotate(45/2) cylinder(h=hEtages*3.25+hSommet, r1=r-2*ep, r2=(r-2*ep-2*dy), $fn=8);
            translate([40-ep*2,0,-hEtages*.25+25]) rotate(90) borne(r=9,h=25,p=40);
        }
    }

     // -----------------------------------------------------
     // Les colonnes   
     // -----------------------------------------------------
    for (j =[0:7], i =[1:2]) {
        rotate(j*45+45/2) translate([0,-r+i*dy+ep-.1,i*hEtages]) cylinder(r=1.8,h=hEtages,$fn=res);
     }
     
     // Les colonnes du bas s'arretent un peu avant le bas des fenetres
     for (j =[0:7]) {
        rotate(j*45+45/2) {
            translate([0,-r+ep-.1,hEtages/3-10]) cylinder(r=1.8,h=2*hEtages/3+10,$fn=res);
            translate([0,-r+ep-.1,hEtages/3-10-hEtages*.03]) cylinder(r=1.,h=hEtages*.03,$fn=res);
        }
     }
        
     // Les petites colonnes tout en haut 
     // TODO: a revoir pour impression
     for (i =[0:2], j =[0:7]) {
        rotate(j*45+45/2) {
            translate([0,-r+ep/2+2*dy,hEtages*3+hRambarde]) {
                cylinder(r=2.2,h=10,$fn=res,center=false);
                translate([0,0,10]) cylinder(r=2.6,h=2,$fn=res,center=false);
                translate([0,0,12]) cylinder(r1=2,r2=0,h=6,$fn=8,center=false);
                translate([0,0,18]) sphere(r=.9,$fn=16);
            }
        }         
     }     


     // La frise sous le rebord (a ameliorer)
    rt = r-4*dy;
    ww = 30;
	hh = 10;
	h1 = 5;
	rr = ww/13;
	p = 20;
    y = rr;
     
	translate([0,0,hEtages*3+hSommet-hh]) difference() {
		rotate(45/2) rotate_extrude($fn=8) translate([rt,0]) polygon([[0,0],[y,h1],[y,hh],[0,hh]]);
		for(j=[0:7]) {
			rotate(j*45) for(i=[0:3]) translate([(3*i+2)*rr-ww/2,rt,h1]) borne(rr,h1,p);
		}
	}

    // TODO ameliorer pour impression
     // La Coiffe
    translate([0,0,hEtages*3+hSommet]) {
        rotate(45/2) {
            cylinder(r1=r-dy*10,r2=0,h=hCoiffe,$fn=8,center=false);
            cylinder(r=r, h=ep,$fn=8);
        }
        translate([0,0,hCoiffe-3]) sphere(2,$fn=8);

        // La croix
        translate([0,0,hCoiffe+7]) cube([2,2,20], center=true);
        translate([0,0,hCoiffe+13]) cube([8,2,2], center=true);
    }
    
        
    // La tour fine sur le coté
    translate([35,35,0]) {    
        difference() {
            translate([0,0,-hEtages*.25]) cylinder(h=hEtages*3.65,r=11);
            union() {
                translate([0,0,-hEtages*.25]) cylinder(h=hEtages*3.65,r=11-ep);
                rotate(-20) translate([5,-4.5, hEtages*2.2]) cube([9,9,9]);
                // porte de la petite tour
                rotate(-40) translate([5,-5, -hEtages*.25]) cube([10,8,24]);
            }
        }
        translate([0,0,hEtages*3.4]) cylinder(h=1,r=12);
        translate([0,0,hEtages*3.4]) cylinder(h=hEtages*.5,r1=11,r2=0,$fn=6);
    }

}


module base() {
    
    wBase1 = 125;
    wBase2 = 115;
    wBase3 = 118;
    wTower = wBase2/4.2;
    hBase1 = hRambarde+ep;
    hBase2 = 60;

    w = wBase2/7.5;
    z = -hBase1*2;

    difference() {
        // La forme principale
        union() {
            translate([-wBase1*.5,-wBase1*.5,-hBase1]) cube([wBase1,wBase1, hBase1]);
            translate([0,0,-hBase1*1.5]) rotate(45) cylinder(r2=wBase1/2*sqrt(2), r1=wBase2/2*sqrt(2), h=hBase1*.5, $fn=4);
            translate([-wBase2*.5,-wBase2*.5,-hBase1*2.-hBase2*.8]) cube([wBase2,wBase2, hBase2*.8+hBase1*.5]);
            translate([0,0,-hBase1*2.-hBase2*.8]) rotate(45) cylinder(r1=wBase3/2*sqrt(2), r2=wBase2/2*sqrt(2), h=5, $fn=4);
            translate([-wBase3*.5,-wBase3*.5,-hBase1*2.-2*hBase2]) cube([wBase3,wBase3, hBase2*1.2]);
            
        }
        union() {
            // La terrasse
            translate([-wBase1*.5+ep,-wBase1*.5+ep,-hBase1+ep]) cube([wBase1-2*ep,wBase1-2*ep, hBase1]);
            // Les crenaux
            for(f=[0:3]) {
                rotate(f*90) {
                    for (i=[0:6]) {
                        x = -wBase1/2+w*i+w;
                        translate([x+w/4,wBase2/2,z+hBase1]) rotate(-90,[1,0,0]) cylinder(r=w/4, h=hBase1, $fn = 36);
                        translate([x,wBase2/2,z]) cube([w/2,hBase1,hBase1]);
                    }
                }
            }
            
            // La grande porte en bas
            translate([wBase3/2+1,0,-hBase1*2.-2*hBase2]) scale([2,2,1]) rotate(90) simpleDoor();
        }
    }
    
    // La petite tour hexagonale
    translate([-wBase2*.25,-wBase2*.51,-hBase1]) {
        difference() {
             rotate(45/2) {
            // Du sommet vers le bas
                translate([0,0,2.2*hBase1+hBase1*.25]) cylinder(r1=wTower*.8, r2=0.8, h=1.8*hBase1, $fn=8);
                translate([0,0,2.2*hBase1]) cylinder(r1=wTower, r2=wTower*.8, h=hBase1*.25, $fn = 8);
                translate([0,0,0]) cylinder(r=wTower, h=2.2*hBase1, $fn=8);
                translate([0,0,-hBase1*.3]) cylinder(r1=wTower*1.2, r2=wTower, h=hBase1*.3, $fn = 8);
                translate([0,0,-hBase1*.3-hBase2*2-13.5]) cylinder(r=wTower*1.16, h=hBase2*2+13.5, $fn = 8);
            }
               
            union() {
                // La petite porte
                translate([hBase1+5,-.8,0]) cube([8,12,30]);
                // La petite lucarne du haut
                rotate(-45) translate([hBase1+5,-5.,-hBase2+28]) cube([22,9,14]);
                // La petite lucarne du bas
                translate([hBase1+5,-10.,-hBase2-5]) cube([20,9,14]);
            }
                
        }
    }
}

rotate(90+180) scale(.2) {
    translate([0,0,hRambarde+ep]) base();
    translate([0,0,hEtages*.25]) clochet();
}

