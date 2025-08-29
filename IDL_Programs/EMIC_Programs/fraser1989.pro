pro fraser1989

;This program receates figure 7 from Fraser et al 1989, Ground -
;Satellite study of a Pc1 Ion Cyclotron Wave Event, and Kozyra et al 1984
;Alexa Halford April 8th 2009

bo =  300. ;nT not sure if right number to use.
nw = [5.1, .05]
kb = 1.3807*10^(-23.) ;Boltzman's constant 
beta =  .08 ;the fractional HE+ ion concentration
gamma = .01 ; the fractional O+ ion concentration
alpha  = 1-beta -gamma ; the fractional concentration of the protons 
betal = 8.*!pi*nl*kb*TLL/(bo^2.)



end
