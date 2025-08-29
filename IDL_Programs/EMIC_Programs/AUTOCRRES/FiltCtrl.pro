Pro FiltCtrl,XDat,YDat,wc,Order,FiltType,CutFreq,LenX,theta
common init_parameter,idl_path,data_path,eph_path,res_path,eve_path,spl_int,fre_int,log_path
common cm_crres,state,cm_eph,cm_val
 pi=3.1415926535898
 wc=0.0
 ;Ydat = 0.0
 wc=float(2.0*Tan(CutFreq*pi))

 print,wc
 WIDGET_CONTROL, state.text,SET_VALUE = string(wc),/append
 uneven=0     ; False
 uu=order mod 2
 if (uu eq 1) then uneven=1  ; True
 for i=1,order/2 do $
  theta(i-1)=(order+2*i-1)*pi/(2.0*order)
 for m=0,order/2-1 do begin
  tmp=theta(m)
  filtr2,XDat,YDat,wc,CutFreq,tmp,FiltType,LenX
 end
 if (uneven eq 1) then $
  Filtr1,XDat,YDat,wc,CutFreq,FiltType,LenX
 Reverse,XDat,YDat,LenX
 For m=0,order/2-1 do begin
  tmp=theta(m)
  filtr2,XDat,YDat,wc,CutFreq,tmp,FiltType,LenX
 end
 if (uneven eq 1) then $
  filtr1,XDat,YDat,wc,CutFreq,FiltType,LenX
 Reverse,XDat,YDat,LenX
end
