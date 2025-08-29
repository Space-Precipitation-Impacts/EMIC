Pro dispersion6

PI=3.14159265359
w =fltarr(1000)

n = fltarr(1000)
r = fltarr(1000)
for i=0,999 do $
n[i] = sin(i/2.)

;plot,n[0:100]
;stop
;************************************
L = 6.6
req = L
;Be = 3.11e-5 ;equatorial magnetic field strength at surface
Be = 100e-9 ;equatorial magnetic field strength at surface

		 ;at geocentric

lambda = fltarr (1000)
B = fltarr(1000)

for i=0, 999 do $
begin
lambda[i] = (float(i)/999.)*PI-Pi/2
r[i] = req*cos(lambda[i])^2.0
end

 ;+n*3.11e-6

;window,1,xsize=650,ysize=700
;plot,r,lambda,/polar;xrange=[0,1e4]

;r = 0.8*req*cos(lambda)^2.0+n/5;*exp(-n)
;oplot,r,lambda,/polar

;r = 0.6*req*cos(lambda)^2.0 +n/10;.
;oplot,r,lambda,/polar

;stop
;************************************
for i=0, 999 do $
begin
lambda[i] = (float(i)/999.)*PI
end
re = 6.37e6
B = (Be/L^3.0)*(1+3*sin(lambda)^2.0)^0.5/(cos(lambda)^6.0)+n*0.001e-7
;B = (Be/L^3.0)*(1+3*sin(lambda)^2.0)^0.5/(cos(lambda)^6.0);+n*3.11e-5

nee = 1.0e5

w_pe = 56.4*sqrt(nee)/(2*pi)
w_ph = 1.32*sqrt(nee)/(2*pi)
w_phe = 1.32*sqrt(nee/4.0)/(2*pi)

omega_e = 1.76e11*B/(2*pi)
omega_h = 9.98e7*B/(2*pi)
omega_he = 9.98e7*B/(8*pi)
omega_o = 9.98e7*B/(32*pi)
omega_e = 1.76e11*B/(2*pi)

;omega_h = 9.85e7*B
;omega_he = 9.85e7*B/

alpha =0.92
beta = .07
gamma = 0.01



w(0)=0.000
for i=0,999 do $
w[i] = i/1000.


w_bi=fltarr(1000)
;wq2=fltarr(1000)
;wq3=fltarr(1000)
;wq4=fltarr(1000)
;wq5=fltarr(1000)
;wq6=fltarr(1000)
wq7=fltarr(1000)
w_xo = (1.+ 15.*beta)^0.5*omega_he/omega_h[0]
for i=0,999 do $
w_bi[i] = [(1.+ 3.*beta)/(1.-0.75*beta)]^0.5*omega_he[i]/omega_h[0]

w_co = (1.+ 3.*beta)*omega_he/omega_h[0]


wq1 =fltarr(1000)
wq2 =fltarr(1000)
r = req*cos(lambda)^2.0
for i=0,999 do $
begin
wq1[i]=0.4
wq2[i]=0.252
end
;wq7[i]=i/100.-2.
;end
;wq2=(omega_he)/omega_h
;wq3=(omega_h/16.)/omega_h
;wq4=w_xo/omega_h
;wq5=w_bi/omega_h
;wq6=w_co/omega_h
;end
;fname='c:\paul\phd\crres\theory\multi222.ps'

;set_plot,'ps'
;device,filename=FName;,yoffset=3, ysize=23
;window,0,xsize=700,ysize=650
;plot,r*6.0/req,lambda/PI*180.;,yrange =[80,100]
;stop
plot,lambda/PI*180.,w_xo,yrange=[0.2,0.6],xrange=[0,30],xstyle=1,$
ytitle='Normalized frequency X',xtitle='Magnetic latitude !7k!3',charsize=2.0
oplot,lambda/PI*180.,w_co,linestyle=1
oplot,lambda/PI*180.,w_bi,linestyle=2
oplot,lambda/PI*180.,omega_he/omega_h[0]

oplot,lambda/PI*180.,wq1;,/device;smooth(w_xo,10),linestyle=1
oplot,lambda/PI*180.,wq2;,/device
;oplot,lambda/PI*180.,w_bi
;oplot,lambda/PI*180.,omega_he/omega_h[0]
;device,/close
set_plot,'win'
openw,u,'c:\paul\phd\crres\theory\omega_he.val',/get_lun
for i=0, n_elements(w_co)-1 do $
 printf,u,lambda[i]/PI*180.,' ',omega_he[i]/omega_h[0],'  ',w_co[i]
close,u
free_lun,u
;stop
end
