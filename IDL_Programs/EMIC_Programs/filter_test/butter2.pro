pro Butter2
pi=3.1415926535898
ct =100
h1=fltarr(ct)
;a2=fltarr(ct)
;b2=fltarr(ct)
H =fltarr(ct)
z =FINDGEN(ct)
z1 =fltarr(ct)
z4 =fltarr(ct)
w=10.0
wc=2*tan(w/2.0)
a2=4.0+4.0*wc*sin(PI/2.0)+wc^2.0
Reab = 8.0 - 2.0*wc^2.0
b2=4.0-4.0*wc*sin(PI/2.0)+wc^2.0
for i=0, ct-1 do $
 begin
z1=sin(2.0*z*PI)
h1[i] = -wc^2.0*(1.0+z1[i])^2.0
H[i] = h1[i]/(a2-Reab*Z1[i]+b2*z1[i])
endfor
z2=fft(z1,-1)
!p.multi=[0,1,1]
plot,z2
end
