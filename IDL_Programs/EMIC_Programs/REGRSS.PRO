; Linear Regression routine
;
; Xv : X Value Array
; Yv : Y Value Array
; NGr : smoothing width (7)
; Slp : Regression Slope (returned)
; Intc : Y Intercept
; 
; C Waters 25 Oct, 1993
;
Pro Regrss,Xv,Yv,NGr,Slp,Intc
Sx=0
sy=0
sxx=0
syy=0
sxy=0
For i=0,NGr-1 do $
Begin
 sx=sx+Xv(i)
 sy=sy+Yv(i)
 sxx=sxx+Xv(i)*Xv(i)
 syy=syy+Yv(i)*Yv(i)
 sxy=sxy+Xv(i)*Yv(i)
end
Bt=Float(NGr)*Sxx-Sx*Sx
Intc=(Sxx*Sy-Sx*Sxy)/Bt
Slp=(Float(NGr)*Sxy-Sx*Sy)/Bt
End
