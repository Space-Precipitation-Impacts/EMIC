Pro FFtWin,WType,ism,FFTN,Wnd
; Generates the appropriate FFT window function
; C. Waters
If WType EQ 0 Then $
Begin
 ism=1
 Print,'Enter the Smoothing [ism] : '
 Read,ism
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
 Wait,0.5
 Print,'Smoothing Window Degrees of Freedom = ',DegFr
 For i=0,4*ism do Wnd(i)=Wnd(i)/Sum1
end
If WType EQ 1 Then Wnd=Hanning(FFTN)
end