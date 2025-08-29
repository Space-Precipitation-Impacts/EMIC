; Procedure to Linear Detrend Time Series
;
; C. Waters : June, 1995
;
Pro DTrend2,Y,N,Ra,Rb
Sx=0.0
Sy=0.0
Sxx=0.0
Syy=0.0
Sxy=0.0
For i=long(0),long(N)-long(1) do $
Begin
 Ir=Float(i)
 Sx=Sx+Ir
 Sy=Sy+Y(i)
 Sxx=Sxx+Ir*Ir
 Syy=Syy+Y(i)*Y(i)
 Sxy=Sxy+Ir*Y(i)
End
Nr=Float(N)
Del=Nr*Sxx-Sx*Sx
Ra=(Sxx*Sy-Sx*Sxy)/Del
Rb=(Nr*Sxy-Sx*Sy)/Del
For i=long(0),long(N)-long(1) do $
 Y(i)=Y(i)-Ra-Rb*double(i)
End