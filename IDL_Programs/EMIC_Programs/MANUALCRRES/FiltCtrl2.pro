Pro FiltCtrl2,XDat,YDat,wc,Order,FiltType,CutFreq,LenX,theta
 pi=3.1415926535898
 wc=0.0
 wc=float(2.0*Tan(CutFreq*pi))
 print,wc
 uneven=0     ; False
 uu=order mod 2
 if (uu eq 1) then uneven=1  ; True
 for i=1,order/2 do $
  theta(i-1)=(order+2*i-1)*pi/(2.0*order)
 for m=0,order/2-1 do begin
  tmp=theta(m)
  filtr2,XDat,YDat,wc,CutFreq,tmp,FiltType,LenX
 end
end
