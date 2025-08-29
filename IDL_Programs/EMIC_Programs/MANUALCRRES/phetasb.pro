Pro PhetaSB,cm_eph,cm_val,state
common SBangle, anglel
nn=n_elements(cm_val.(0))
angleSB =fltarr(nn)
Sx=cm_val.(11)
Sy=cm_val.(12)
Sz=cm_val.(13)
pi = 3.1415926535898
S = sqrt(Sx^2.0+Sy^2.0+Sz^2.0)
;B = sqrt(Bxn^2.0+Byn^2.0+Bzn^2.0)
ii=long(0)
for i=long(0), nn-1 do $
	begin
	angleSB[i] = atan(sqrt(Sx[i]^2+Sy[i]^2)/abs(S[i]))
	if Sz[i] LT float(0.0) then angleSB[i] = Pi - angleSB[i]
	angleSB[i]=angleSB[i]/pi*180.
	;if (angleSB[i] LT 150.) and (angleSB[i+1] GT 30.) then $
	;	begin
	; 			ii=ii+1
;		angleSB[i]=0.0
;	end
endfor

;print,ii
print,n_elements(angleSB)
;window,12,xsize=500
ctang=long(0)
for i=long(0),n_elements(angleSB)-long(1) do $
if angleSB[i] LE 60. then $
ctang =ctang+1
anglel=fltarr(n_elements(angleSB))
j=long(0)
for i=long(0),n_elements(angleSB)-long(1) do $
if angleSB[i] LE 60. or angleSB[i] GE 120.0 then $
begin
anglel[i]=angleSB[i]
end else $
anglel[i]=90.0
;stop
;plot,congrid(cm_val.(0),n_elements(cm_val.(0))/50.0),congrid(angleSB,n_elements(cm_val.(0))/50.0),$
plot,congrid(cm_val.(0),n_elements(cm_val.(0))/200.0),congrid(anglel,n_elements(cm_val.(0))/200.0),$
yrange=[0,180],xstyle=5,xtickformat='XTLab',ytitle='PhetaSB (!Uo!n)',$
xticks=3;,nsum=5
;eph_inter_win,cm_eph,cm_val,state,Dat5
cm_val.(14)=anglel
anglel=0.0
end
