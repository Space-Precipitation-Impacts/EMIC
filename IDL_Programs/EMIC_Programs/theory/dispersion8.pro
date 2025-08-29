Pro dispersion8

PI=3.14159265359
w =fltarr(1000)
omega_he =fltarr(1000)
omega_h =fltarr(1000)
B =fltarr(1000)
n = fltarr(1000)
for i=0,999 do $
begin
n[i] = sin(i/10.)
B[i] = 101.0e-9 ;+ n[i]*50.0e-9
end
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

;plot,omega_he,yrange=[0.3,0.45]
;stop

alpha =0.80
beta = .20
gamma = 0.0;5



w(0)=0.000
for i=0,999 do $
w[i] = i/100.

wq1=fltarr(1000)
wq2=fltarr(1000)
wq3=fltarr(1000)
wq4=fltarr(1000)
wq5=fltarr(1000)
wq6=fltarr(1000)
wq7=fltarr(1000)
w_bi=fltarr(1000)
w_xo = (1.+ 15.*beta)^0.5*omega_he
w_co = (1.+ 3.*beta)*omega_he

for i=0,999 do $
begin
wq1[i]=i*100.-4
wq7[i]=i/100.-2.
w_bi[i] = [(1.+ 3.*beta)/(1.-0.75*beta)]^0.5*omega_he[i]

end

wq2=(omega_he)/omega_h[0]
wq3=(omega_h/16.)/omega_h[0]
wq4=w_xo/omega_h[0]
wq5=w_bi/omega_h[0]
wq6=w_co/omega_h[0]


A = w

R = 1 + ((w_pe/omega_e))^2.0 + w_pe^2.0/(omega_h*omega_e)*[1/A - alpha/(A*(1+A)) - beta/(A*(1+4*A))-gamma/(A*(1+16*A))]

L = 1 + ((w_pe/omega_e))^2.0 - w_pe^2.0/(omega_h*omega_e)*[1/A - alpha/(A*(1-A)) - beta/(A*(1-4*A))-gamma/(A*(1-16*A))]

;R = 1 + fix((w_pe/omega_e))^2.0 + w_pe/(omega_h)*[1/A - alpha/(A*(1+A)) - beta/(A*(1+4*A))];-gamma/(A*(1+16*A))]

;L = 1 + fix((w_pe/omega_e))^2.0 - w_pe/(omega_h)*[1/A - alpha/(A*(1-A)) - beta/(A*(1-4*A))];-gamma/(A*(1-16*A))]

P = 1 - 1.0/A^2.0*(w_pe/omega_h)^2.0

S=0.5*(R+L)

D=0.5*(R-L)

th = 20.*PI/180.


F = [(R*L-P*S)^2.0*(sin(th))^4.0 + 4.*P^2.0*D^2.0*(cos(th))^2.0]^0.5

B = R*L*(sin(th))^2.0 + P*S*(1+(cos(th))^2.0)

A = S*(sin(th))^2.0 + P*(cos(th))^2.0

R_obl = (B+F)/(2.*A)

L_obl = (B-F)/(2.*A)

set_plot,'win'
plot,w,R_obl,xrange=[0.0,0.8],yrange=[100,10000];,/ylog
oplot,w,L_obl
oplot,wq2,wq1
oplot,wq4,wq1
oplot,wq5,wq1
oplot,wq6,wq1
stop


;P_R = -D*(R_obl)*(cos(th))^2.0/(S*R_obl-R*L)
;P_L =-D*(L_obl)*(cos(th))^2.0/(S*L_obl-R*L)

P_R = (R_obl-S)/(D)
P_L =(L_obl-S)/(D)

;plot,w,P_R,xrange=[0.0,0.8];,yrange=[100,10000];,/ylog
;oplot,w,P_L;L_obl
;oplot,wq2,wq1
;oplot,wq4,wq1
;loplot,wq5,wq1
;oplot,wq6,wq1
;stop
q0 = fltarr(100)
q1 = fltarr(100)

q2 = fltarr(1000)
q3 = fltarr(1000)
for i=0, 99 do $
begin
q0[i]=0.4+i/1200.
q1[i]=7000.
end
q5=fltarr(1000)
for i=0, 999 do $
begin
q5[i] =0.0
q2[i]=1.0
q3[i]=-1.0
end
q5=fltarr(1000)
;for i=0, 999 do $
;begin
;if P_R[i] GE 2.0 then $
;P_R[i]=2.0

;q5[i] =0.0
;q2[i]=1.0
;q3[i]=-1.0
;end

!P.multi=[0,0,1]
;window,0,xsize=700,ysize=600
;set_plot,'PS'
fname='c:\paul\phd\crres\theory\disp_oblique_multi71b.ps'

set_plot,'ps'
device,filename=FName;,yoffset=3, ysize=23
plot,w,R,xrange=[0.0,0.6],yrange=[0,10000],ystyle=1,$
xtitle='Normalized requency (!7x!3/!7X!3!dH!U+!n)',ytitle='Refractive Index (n!U2!n)',linestyle=0,ycharsize=1.5,xcharsize=1.5;,/device;,/xlog
oplot,w,L,linestyle=0
;,linestyle=1;,/ylog
;oplot,w[1:24],P_R[1:24],linestyle=1
;oplot,w[1:24],L_obl[1:24],linestyle=1
;oplot,w[30:500],P_R[30:500],linestyle=1;,linestyle=1;,xrange=[0.0,0.6],yrange=[-3.0,3.0];,linestyle=1;,/device
oplot,wq2,wq1,linestyle=2
;oplot,wq3,wq1,linestyle=2
oplot,wq4,wq1,linestyle=2
;oplot,wq4[300:500],wq1[300:500],linestyle=0
oplot,wq5,wq1,linestyle=2
oplot,wq6,wq1,linestyle=2
oplot,w,q5,linestyle=3
oplot,w,q2,linestyle=0
oplot,w,q3,linestyle=0
oplot,q0,q1,linestyle=0

XYOUTS, 11200,6000,'!7x!3!dxo!n',charsize=1.5,/DEVICE
XYOUTS, 9800,6000,'!7x!3!dco!n',charsize=1.5,/DEVICE
XYOUTS, 8500,6000,'!7X!3!dHe!U+!n',charsize=1.5,/DEVICE
XYOUTS,6000,3800,'R',charsize=1.2,/DEVICE
XYOUTS, 13700,3300,'R',charsize=1.2,/DEVICE
XYOUTS, 6200,8300,'L1',charsize=1.2,/DEVICE
XYOUTS, 12200,10000,'He!U+!n = 7%',charsize=1.3,/DEVICE
XYOUTS, 12200,11000,'H!U+!n = 93%',charsize=1.3,/DEVICE
XYOUTS, 10400,2000,'L2',charsize=1.2,/DEVICE
XYOUTS, 12500,5200,'L3',charsize=1.2,/DEVICE
XYOUTS, 14500,8700,'0%',charsize=1.2,/DEVICE
XYOUTS, 14500,8200,'20%',charsize=1.0,/DEVICE
XYOUTS, 14500,7650,'30%',charsize=1.0,/DEVICE
XYOUTS, 14500,7100,'40%',charsize=1.0,/DEVICE

th = 20.*PI/180.

F = [(R*L-P*S)^2.0*(sin(th))^4.0 + 4.*P^2.0*D^2.0*(cos(th))^2.0]^0.5

B = R*L*(sin(th))^2.0 + P*S*(1+(cos(th))^2.0)

A = S*(sin(th))^2.0 + P*(cos(th))^2.0

R_obl = (B+F)/(2.*A)

L_obl = (B-F)/(2.*A)

P_R = (R_obl-S)/(D)
P_L =(L_obl-S)/(D)
;P_R = -D*(R_obl)*(cos(th))^2.0/(S*R_obl-R*L)
;P_L =-D*(L_obl)*(cos(th))^2.0/(S*L_obl-R*L)
q0 = fltarr(100)
q1 = fltarr(100)
for i=0, 99 do $
begin
q0[i]=0.4+i/1200.
q1[i]=6500.
end
;for i=0, 999 do $
;begin
;if P_R[i] LT 2.0 then $
;P_R[i]=2.0

;q5[i] =0.0
;q2[i]=1.0
;q3[i]=-1.0
;end
;
;oplot,w[1:10],P_R[1:10],linestyle=4
oplot,w,R_obl,linestyle=1
oplot,w,L_obl,linestyle=1
oplot,q0,q1,linestyle=1
;oplot,w,P_R,linestyle=4
;oplot,w9],P_R[37:999],linestyle=4
;oplot,w,P_L,linestyle=4
;oplot,w[0:35],P_L[0:35],linestyle=4
;oplot,w[38:999],P_L[38:999],linestyle=4





th = 30.*PI/180.


F = [(R*L-P*S)^2.0*(sin(th))^4.0 + 4.*P^2.0*D^2.0*(cos(th))^2.0]^0.5

B = R*L*(sin(th))^2.0 + P*S*(1+(cos(th))^2.0)

A = S*(sin(th))^2.0 + P*(cos(th))^2.0

R_obl = (B+F)/(2.*A)

L_obl = (B-F)/(2.*A)

P_R = (R_obl-S)/(D)
P_L =(L_obl-S)/(D)
;P_R = -D*(R_obl)*(cos(th))^2.0/(S*R_obl-R*L)
;P_L =-D*(L_obl)*(cos(th))^2.0/(S*L_obl-R*L)
q0 = fltarr(100)
q1 = fltarr(100)
for i=0, 99 do $
begin
q0[i]=0.4+i/1200.
q1[i]=6000.
end
;for i=0, 999 do $
;begin
;if P_R[i] LT 2.0 then $
;P_R[i]=2.0

;q5[i] =0.0
;q2[i]=1.0
;q3[i]=-1.0
;end
;
;oplot,w[1:10],P_R[1:10],linestyle=4
oplot,w,R_obl,linestyle=4
oplot,w,L_obl,linestyle=4
oplot,q0,q1,linestyle=4
;oplot,w9],P_R[37:999],linestyle=4
;oplot,w,P_L,linestyle=4
;oplot,w[0:35],P_L[0:35],linestyle=4
;oplot,w[38:999],P_L[38:999],linestyle=4
th = 40.*PI/180.


F = [(R*L-P*S)^2.0*(sin(th))^4.0 + 4.*P^2.0*D^2.0*(cos(th))^2.0]^0.5

B = R*L*(sin(th))^2.0 + P*S*(1+(cos(th))^2.0)

A = S*(sin(th))^2.0 + P*(cos(th))^2.0

R_obl = (B+F)/(2.*A)

L_obl = (B-F)/(2.*A)

P_R = (R_obl-S)/(D)
P_L =(L_obl-S)/(D)

;P_R = -D*(R_obl)*(cos(th))^2.0/(S*R_obl-R*L)
;P_L =-D*(L_obl)*(cos(th))^2.0/(S*L_obl-R*L)
q0 = fltarr(100)
q1 = fltarr(100)
for i=0, 99 do $
begin
q0[i]=0.4+i/1200.
q1[i]=5500.
end
oplot,w,R_obl,linestyle=5
;oplot,w[0:35],P_R[0:35],linestyle=5
oplot,w,L_obl,linestyle=5
oplot,q0,q1,linestyle=5
;oplot,w[0:35],P_L[0:35],linestyle=5
;oplot,w[40:999],P_L[40:999],linestyle=5
device,/close
set_plot,'win'

end