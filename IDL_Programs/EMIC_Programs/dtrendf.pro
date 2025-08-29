Pro DTrendF,Y,N,OutArr
; Y: Input Array
; N: Num. data points in Y
; OutArr: Linear Approx to the input data
 Sx=0.0 & Sy=0.0
 Sxx=0.0 & Syy=0.0 & Sxy=0.0
 For i=Long(0),Long(N-1) do $
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
 OutArr=Y
 For i=Long(0),Long(N-1) do OutArr(i)=Ra+Rb*Float(i)   ; Construct Linear Fit
End
