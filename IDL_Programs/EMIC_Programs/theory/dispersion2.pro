Pro dispersion2

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
omega_e = 1.76e11*B
omega_h = 9.85e7*B
;omega_he = 9.85e7*B/

alpha =0.93
beta = .07
gamma = 0.0;5
;alpha + beta + gamma = 1

w(0)=0.000
for i=0,999 do $
w[i] = i/100.

A = w
;omega_he = 1/4;1.0
R = 1 + (w_pe/omega_e)^2.0 + w_pe^2.0/(omega_h*omega_e)*[1/A - alpha/(A*(1+A)) - beta/(A*(1+4*A))-gamma/(A*(1+16*A))]

L = 1 + (w_pe/omega_e)^2.0 - w_pe^2.0/(omega_h*omega_e)*[1/A - alpha/(A*(1-A)) - beta/(A*(1-4*A))-gamma/(A*(1-16*A))]

;R = 1 + 1. + 1.0/(omega_h)*[1/A - alpha/(A*(1+A)) - beta/(A*(1+4*A))-gamma/(A*(1+16*A))]

;L = 1 + 1. - 1.0/(omega_h)*[1/A - alpha/(A*(1-A)) - beta/(A*(1-4*A))-gamma/(A*(1+16*A))]
;stop
print,w_pe/omega_h
;print,a[0:100]
;for i=0,999 do $
;begin
;if R[i] GE 10000. then $
;R[i] = 10000.
;end


;for i=0,999 do $
;begin
;if abs(R[i]) GE 5000. then $
;R[i] = 5000.
;end
;print,omega_h
;print,omega_he/omega_h

th = 24.*PI/180.


R_obl = 2.*R*L/(-cos(th)*(R-L)+(R+L))

L_obl = 2.*R*L/(cos(th)*(R-L)+R+L)
wq1=fltarr(1000)
wq2=fltarr(1000)
wq3=fltarr(1000)
wq4=fltarr(1000)
wq5=fltarr(1000)
wq6=fltarr(1000)
wq7=fltarr(1000)
w_xo = (1.+ 15.*beta)^0.5*omega_he
w_bi = (1.+ 3.*beta)/(1.+0.75*beta)*omega_he
w_co = (1.+ 3.*beta)*omega_he

for i=0,999 do $
begin
wq1[i]=i*1000.
wq2[i]=(omega_h/4.)/omega_h
wq3[i]=(omega_h/16.)/omega_h
wq4[i]=w_xo/omega_h
wq5[i]=w_bi/omega_h
wq6[i]=w_co/omega_h
wq7[i]=i/100.-2.
end
;egin
;if abs(R_obl[i]) GE 5000. then $
;R_obl[i] = 5000.
;end
;print, wq2;_co/omega_h
;index = where(w/omega_h, count)
;print,count
;print,index
;stop

!P.multi=[0,0,1]
;window,0,xsize=700,ysize=600
set_plot,'PS'
plot,w,L,xrange=[0.0,0.6],yrange=[0,10000.],$
xtitle='Normalized frequency (f/f!dH!n)',ytitle='Refractive Index (n!U2!n)',linestyle=0,ycharsize=1.5,xcharsize=1.5;,/xlog
;,linestyle=1;,/ylog
oplot,w,R,linestyle=3
oplot,wq2,wq1,linestyle=2
;oplot,wq3,wq1,linestyle=2
oplot,wq4,wq1,linestyle=2
;oplot,wq5,wq1,linestyle=2
oplot,wq6,wq1,linestyle=2
XYOUTS, 380,300,'f!dxo!n',charsize=2.3,/DEVICE
XYOUTS, 330,300,'f!dco!n',charsize=2.3,/DEVICE
XYOUTS, 285,300,'f!dHe!n',charsize=2.3,/DEVICE
XYOUTS, 210,300,'L1',charsize=2.3,/DEVICE
XYOUTS, 420,190,'L2',charsize=2.3,/DEVICE
XYOUTS, 220,157,'R',charsize=2.3,/DEVICE
set_plot,'WIN'
stop
D = 0.5*(R-L)
window,1,xsize=600,ysize=600
plot,w,L_obl,linestyle=0,xrange=[0.0,1.0],yrange=[0,10000.],xstyle=1,title='Oblique (24!Uo!n) Propagation',$
xtitle='Normalized frequency',ytitle='Refractive Index (n!U2!n)';,/xlog
;oplot,A,L_obl,linestyle=0,xrange=[w_xo/omega_h,1.0],yrange=[10,4000],xstyle=1;,linestyle=1;,/ylog

oplot,w,R_obl,linestyle=3
oplot,wq2,wq1,linestyle=2
;oplot,wq3,wq1,linestyle=2
oplot,wq4,wq1,linestyle=2
oplot,wq5,wq1,linestyle=2
oplot,wq6,wq1,linestyle=2
;oplot,D,linestyle=0
;print,2.*L_obl/R_obl
;print,omega_he/omega_h
;print,w_xo/omega_h


;D = 0.5*(R-L)
;qq=where(D EQ 0.0,index)
;print,index
S = 0.5*(R+L)

P_L = D*L_obl*cos(th)^2.0/(S*L_obl-R_obl*L_obl)
P_R = D*R_obl*cos(th)^2.0/(S*R_obl-R_obl*L_obl)

window,2,xsize=600,ysize=600
plot,w,P_L,yrange=[-2,2],xstyle=1,xrange=[0.0,0.6],linestyle=0;,/xlog
oplot,w,P_R,linestyle=1
oplot,wq2,wq7,linestyle=2
;oplot,wq3,wq1,linestyle=2
oplot,wq4,wq7,linestyle=2
oplot,wq5,wq7,linestyle=2
oplot,wq6,wq7,linestyle=2

;print,P_L[0:100]
;stop

end
