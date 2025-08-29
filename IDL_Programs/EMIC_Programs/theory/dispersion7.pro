Pro dispersion7

PI=3.14159265359
w =fltarr(1000)
;************************************
Be = 3.11e-5 ;equatorial magnetic field strength at surface

L = 6.6		 ;at geocentric

lambda = fltarr (100)
B = fltarr(100)

for i=0, 99 do $
begin
lambda[i] = (float(i)/99.)*PI -Pi/2.
end

B = (Be/L^3.0)*(1+3*sin(lambda)^2.0)^0.5/(cos(lambda)^6.0)

;************************************

nee = 1.0e5

w_pe = 56.4*sqrt(nee)/(2*pi)
w_ph = 1.32*sqrt(nee)/(2*pi)
w_phe = 1.32*sqrt(nee/4.0)/(2*pi)

omega_e = 1.76e11*B/(2*pi)
omega_h = 9.98e7*B/(2*pi)
omega_he = 9.98e7*B/(8*pi)
omega_e = 1.76e11*B/(2*pi)

;omega_h = 9.85e7*B
;omega_he = 9.85e7*B/

alpha =0.93
beta = .07
gamma = 0.0;5



w(0)=0.000
for i=0,99 do $
w[i] = i/100.


w_bi=fltarr(100)
;wq2=fltarr(1000)
;wq3=fltarr(1000)
;wq4=fltarr(1000)
;wq5=fltarr(1000)
;wq6=fltarr(1000)
wq7=fltarr(100)
w_xo = (1.+ 15.*beta)^0.5*omega_he/omega_h[0]
for i=0,99 do $
w_bi[i] = [(1.+ 3.*beta)/(1.-0.75*beta)]^0.5*omega_he[i]/omega_h[0]

w_co = (1.+ 3.*beta)*omega_he/omega_h[0]

req = 1;l6.*6.37e6
r =fltarr(100)
r = cos(lambda)^2.0
n = intarr(100)
for i=0,99 do $
begin
n[i] = i
end
;wq1[i]=i*1000.-4
;wq7[i]=i/100.-2.
;end
;wq2=(omega_he)/omega_h
;wq3=(omega_h/16.)/omega_h
;wq4=w_xo/omega_h
;wq5=w_bi/omega_h
;wq6=w_co/omega_h
;end

set_plot,'win'
window,0,xsize=700,ysize=650
plot,/polar,r,lambda/PI*180,xrange =[0,1];,yrange=[-90,90],ystyle=1
stop
plot,lambda/PI*180.,w_xo,yrange=[0.2,0.6],xrange=[0,30],xstyle=1,ytitle='Normalized frequency X',xtitle='Magnetic latitude !7k!3',charsize=2.0
oplot,lambda/PI*180.,w_co
oplot,lambda/PI*180.,w_bi
oplot,lambda/PI*180.,omega_he/omega_h[0]
;stop
end
