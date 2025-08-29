Pro dispersion14

PI=3.14159265359
w =fltarr(1000)
B = 101.0e-9
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

th = 20.*PI/180.


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
w_xo = (1.+ 15.*beta)^0.5*omega_he
w_bi = [(1.+ 3.*beta)/(1.-0.75*beta)]^0.5*omega_he
w_co = (1.+ 3.*beta)*omega_he

for i=0,999 do $
begin
wq1[i]=i/100.-4
wq2[i]=(omega_he)/omega_h
wq3[i]=(omega_h/16.)/omega_h
wq4[i]=w_xo/omega_h
wq5[i]=w_bi/omega_h
wq6[i]=w_co/omega_h
wq7[i]=i/100.-2.
end

A = w

R = 1 + ((w_pe/omega_e))^2.0 + w_pe^2.0/(omega_h*omega_e)*[1/A - alpha/(A*(1+A)) - beta/(A*(1+4*A))-gamma/(A*(1+16*A))]

L = 1 + ((w_pe/omega_e))^2.0 - w_pe^2.0/(omega_h*omega_e)*[1/A - alpha/(A*(1-A)) - beta/(A*(1-4*A))-gamma/(A*(1-16*A))]

;R = 1 + fix((w_pe/omega_e))^2.0 + w_pe/(omega_h)*[1/A - alpha/(A*(1+A)) - beta/(A*(1+4*A))];-gamma/(A*(1+16*A))]

;L = 1 + fix((w_pe/omega_e))^2.0 - w_pe/(omega_h)*[1/A - alpha/(A*(1-A)) - beta/(A*(1-4*A))];-gamma/(A*(1-16*A))]

P = 1 - 1.0/A^2.0*(w_pe/omega_h)^2.0

S=0.5*(R+L)

D=0.5*(R-L)

F = [(R*L-P*S)^2.0*(sin(th))^4.0 + 4.*P^2.0*D^2.0*(cos(th))^2.0]^0.5

B = R*L*(sin(th))^2.0 + P*S*(1+(cos(th))^2.0)

A = S*(sin(th))^2.0 + P*(cos(th))^2.0

R_obl = (B+F)/(2.*A)

L_obl = (B-F)/(2.*A)

;P_R = -D*(R_obl)*(cos(th))^2.0/(S*R_obl-R*L)
;P_L =-D*(L_obl)*(cos(th))^2.0/(S*L_obl-R*L)

P_R = (R_obl-S)/(D)
P_L =(L_obl-S)/(D)

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
for i=0, 999 do $
begin
if P_R[i] GE 2.0 then $
P_R[i]=2.0

;q5[i] =0.0
;q2[i]=1.0
;q3[i]=-1.0
end
;stop
!P.multi=[0,0,1]
;window,0,xsize=700,ysize=600
;set_plot,'PS'
;fname='c:\paul\phd\crres\theory\ellip_oblique_multi222.ps'

;set_plot,'ps'
;device,filename=FName;,yoffset=3, ysize=23
plot,w[0:35],P_L[0:35],xrange=[0.0,0.6],yrange=[-3.0,3.0],ystyle=1,$
xtitle='Normalized requency (!7x!3/!7X!3!dH!U+!n)',ytitle='Ellpticity (!7e!3 = iEy/Ex)',linestyle=0,ycharsize=1.5,xcharsize=1.5;,/device;,/xlog
oplot,w[36:999],P_L[36:999],linestyle=0
;oplot,w,P_L,linestyle=0
stop
;,linestyle=1;,/ylog
;oplot,w[1:24],P_R[1:24],linestyle=1
;oplot,w[1:24],P_R[1:24],linestyle=0
;oplot,w[30:500],P_R[30:500],linestyle=0;,linestyle=1;,xrange=[0.0,0.6],yrange=[-3.0,3.0];,linestyle=1;,/device
oplot,wq2,wq1,linestyle=2
;oplot,wq3,wq1,linestyle=2
oplot,wq4,wq1,linestyle=2
oplot,wq4[300:500],wq1[300:500],linestyle=0
oplot,wq5,wq1,linestyle=2
oplot,wq6,wq1,linestyle=2
oplot,w,q5,linestyle=3
oplot,w,q2,linestyle=0
oplot,w[0:25],q3[0:25],linestyle=0
oplot,w[30:100],q3[30:100],linestyle=0

;XYOUTS, 11200,6000,'f!dxo!n',charsize=1.5,/DEVICE
;XYOUTS, 9800,6000,'f!dco!n',charsize=1.5,/DEVICE
;XYOUTS, 8500,6000,'f!dHe!U+!n',charsize=1.5,/DEVICE

XYOUTS, 11200,6000,'!7x!3!dxo!n',charsize=1.5,/DEVICE
XYOUTS, 9800,6000,'!7x!3!dco!n',charsize=1.5,/DEVICE
XYOUTS, 8500,6000,'!7X!3!dHe!U+!n',charsize=1.5,/DEVICE

XYOUTS,5000,8600,'R',charsize=1.2,/DEVICE
XYOUTS, 14000,8600,'R',charsize=1.2,/DEVICE
XYOUTS, 5000,5100,'L1',charsize=1.2,/DEVICE
;XYOUTS, 12200,10000,'He!U+!n = 7%',charsize=1.3,/DEVICE
;XYOUTS, 12200,11000,'H!U+!n = 93%',charsize=1.3,/DEVICE
XYOUTS, 10300,4400,'L2',charsize=1.2,/DEVICE
XYOUTS, 14000,5100,'L3',charsize=1.2,/DEVICE


;P_R = (R_obl-S)/(D)
;P_L =(L_obl-S)/(D)

;P_R = -D*(R_obl)*(cos(th))^2.0/(S*R_obl-R*L)
;P_L =-D*(L_obl)*(cos(th))^2.0/(S*L_obl-R*L)
;q0 = fltarr(100)
;q1 = fltarr(100)

;oplot,w[0:26],P_R[0:26],linestyle=5
;oplot,w[0:35],P_R[0:35],linestyle=5
;oplot,w[30:500],P_R[30:500],linestyle=5
;oplot,w,P_L,linestyle=5
;oplot,w[0:35],P_L[0:35],linestyle=5
;oplot,w[40:999],P_L[40:999],linestyle=5
device,/close
set_plot,'win'

end