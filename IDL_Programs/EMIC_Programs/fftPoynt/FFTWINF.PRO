Pro FFtWinF,FFTN,Wnd,ism
; Generates the appropriate Freq. Domain FFT window function
;
Wnd=DblArr(5*ism)
Sum1=0.0
Sum2=0.0
For i=0,4*ism do $
Begin
 Wnd(i)=Exp(-(Float(i-2*ism)/Float(ism))^2)
 Sum1=Sum1+Wnd(i)
 Sum2=Sum2+Wnd(i)*Wnd(i)
End
DegFr=Sum1^2/Sum2
Wait,0.1
Print,'Smoothing Window Degrees of Freedom = ',DegFr
For i=0,4*ism do Wnd(i)=Wnd(i)/Sum1
end
