Pro dispersion1

PI=3.14159265359
w =fltarr(1000)
B = 101.0e-9
nee = 1.0e5

w_pe = 56.4*sqrt(nee)
w_ph = 1.32*sqrt(nee)
w_phe = 1.32*sqrt(nee/4.0)

omega_e = 1.76e11*B
omega_h = 9.85e7*B
omega_he = 9.85e7*B/4.


alpha =0.8
beta = 0.15
gamma = 0.05
;alpha + beta + gamma = 1


for i=0,999 do $
w[i] = 9.*i/1000.

A = w/omega_h

R = 1 + (w_pe/omega_e)^2.0 + w_pe^2.0/(omega_h*omega_e)*[1/A - alpha/(A*(1+A)) - beta/(A*(1+4*A)) - gamma/(A*(1+16*A))]

L = 1 + (w_pe/omega_e)^2.0 - w_pe^2.0/(omega_h*omega_e)*[1/A - alpha/(A*(1-A)) - beta/(A*(1-4*A)) - gamma/(A*(1-16*A))]

;for i=0,999 do $
;begin
;if R[i] GE 10000. then $
;R[i] = 10000.
;end


;for i=0,999 do $
;begin
;if L[i] GE 10000. then $
;L[i] = 10000.
;end

window,0,xsize=600,ysize=600
plot,A,L,xrange=[0,1.],yrange=[10,5000];,linestyle=1;,/ylog
oplot,A,R,linestyle=1
print,omega_h
print,omega_he/omega_h

th = 40.*PI/180.


R_obl = 2.*R*L/(-cos(th)*(R-L)+R+L)

L_obl = 2.*R*L/(cos(th)*(R-L)+R+L)


window,1,xsize=600,ysize=600
plot,A,L_obl,xrange=[0,1.],yrange=[10,5000];,linestyle=1;,/ylog
oplot,A,R_obl,linestyle=4
print,omega_h
print,omega_he/omega_h

end
