Pro Filtr1,XDat,YDat,wc,CutFreq,FiltType,LenX
 pi=3.1415926535898
 Print,'In 1st Order Filter...'
 Wait,0.5
 a=float((wc-2)/(wc+2))
 c=float(wc/(wc+2))
 eta=1.0
 If (FiltType eq 1) then Begin
  zeta=float(-cos(2*pi*CutFreq))
  a=float(-(a-zeta)/(1-a*zeta))
  c=c*(1-zeta)/(1-a*zeta)
  eta=-1.0
 end
 YDat(0)=c*XDat(0)
 If (FiltType eq 1) Then YDat(0)=0.0
 i=Long(1)
 For i=Long(1),Long(LenX-1) do $
  YDat(i)=-a*YDat(i-1)+c*(XDat(i)+eta*XDat(i-1))
 XDat=YDat
 For i=Long(0),Long(LenX-1) do $
  YDat(i)=0
end
