Pro FFtWinF,Wnd,ism
; Generates the appropriate Freq. Domain FFT window function
; C.L. Waters
;
 Wnd=DblArr(2*ism+1)
 Sum1=0.0
 Sum2=0.0
 For i=0,2*ism do $
 Begin
  Wnd(i)=Exp(-(Float(i-ism)/Float(ism/2.))^2)
  Sum1=Sum1+Wnd(i)
  Sum2=Sum2+Wnd(i)*Wnd(i)
 End
 DegFr=Sum1^2/Sum2
 Print,'Smoothing Window Degrees of Freedom = ',DegFr
 For i=0,2*ism do Wnd(i)=Wnd(i)/Sum1
end
