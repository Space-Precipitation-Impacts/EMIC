pro pc5test, lowgroup
common cm_crres,state,cm_eph,cm_val
common orbinfo,orb,orb_binfile,orb_date
common lowchoice ,filtords,fieldch,filttype,cut
print,filtords,fieldch,cut
;************************************************************************************
;The data is run through a Butterworth filter
;Filter is implemented using Bi-Linear Transformation.
;
SSInt=ABS(cm_val.(0)[1] - cm_val.(0)[0])
SSSInt=SSINt/1000.0
freq=1./SSSInt
count0=n_elements(cm_val.(0))
pI=3.1415926535898						;Declare Pi to 12 demical places.
sam1=float(cut)
sam1=sam1[0]                              ;lowpass dB to remove phase due to spacecraft
Order = filtords+1
FiltType = filttype+1
Cuts = float(sam1/freq)
Print,'Low pass filtering data now'
dumm =fltarr(count0)
Theta=fltArr(6)
;stop

BZpc=cm_val.(9)
BXpc=cm_val.(7)
Bypc=cm_val.(8)

;ww = n_elements(Bz1pc)/2.
;;stop
;nn = long(abs(ww - fix(ww))*long(5000.))

Bzzpc = smooth(Bzpc,300);,/edge_truncate)
Bxxpc = smooth(Bxpc,300);,/edge_truncate)
Byypc = smooth(Bypc,300)

Bzzzpc = smooth(Bzpc,3000);,/edge_truncate)
Bxxxpc = smooth(Bxpc,3000);,/edge_truncate)
Byyypc = smooth(Bypc,3000);,/edge_truncate)
;stop
Bazpc =Bzzpc - Bzzzpc
Baxpc =Bxxpc - Bxxxpc
Baypc =Byypc - Byyypc

Baxpc[count0-2000:count0-1]=0.0;mean(Bxpcnew[count0-100:count0-1])
Baxpc[0:2000]=0.0;mean(Bxpcnew[0:100])
Baypc[count0-2000:count0-1]=0.0;mean(Bypcnew[count0-100:count0-1])
Baypc[0:2000]=0.0;mean(Bypcnew[0:100])
Bazpc[count0-2000:count0-1]=0.0;mean(Bzpcnew[count0-100:count0-1])
Bazpc[0:2000]=0.0;mean(Bzpcnew[0:100])

;stop
;********************************************
;Dtrend2,Bxpc,count0,Rax,Rbx
;Bxxx=Bxpc;[count0-1]
;dtrend2,Bypc,count0,Ray,Rby
;Byyy=Bypc;[count0-1]
; dtrend2,Bzpc,count0,Raz,Rbz
;Bzzz=Bzpc;[count0-1]
;FiltCtrl,Bxpc,dumm,wc,Order,FiltType,cuts,count0,theta
;dumm =fltarr(count0)
;Theta=fltArr(6)
;FiltCtrl,Bypc,dumm,wc,Order,FiltType,cuts,count0,theta
;dumm =fltarr(count0)
;Theta=fltArr(6)
;FiltCtrl,Bzpc,dumm,wc,Order,FiltType,cuts,count0,theta
;Bxpcnew=Bxxx-Bxpc
;Bypcnew=Byyy-Bypc
;Bzpcnew=Bzzz-Bzpc

;Bxpcnew[count0-100:count0-1]=mean(Bxpcnew[count0-100:count0-1])
;Bxpcnew[0:100]=mean(Bxpcnew[0:100])
;Bypcnew[count0-100:count0-1]=mean(Bypcnew[count0-100:count0-1])
;Bypcnew[0:100]=mean(Bypcnew[0:100])
;Bzpcnew[count0-100:count0-1]=mean(Bzpcnew[count0-100:count0-1])
;Bzpcnew[0:100]=mean(Bzpcnew[0:100])
;;stop
;cm_val.(15)=BxPcnew
;cm_val.(16)=ByPcnew
;cm_val.(17)=Bzpcnew
cm_val.(15)=BaxPc
cm_val.(16)=BayPc
cm_val.(17)=Bazpc

window,0,xsize=700,ysize=700
plot,cm_val.(15),xstyle=1
plot,cm_val.(16),xstyle=1
plot,cm_val.(17),xstyle=1
WIDGET_CONTROL, state.text,SET_VALUE = 'LowPass filtering complete'
end